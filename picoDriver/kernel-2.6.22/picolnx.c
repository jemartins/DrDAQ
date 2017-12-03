/****************************************************************************
 *
 * Project:      Linux parallel port driver
 *
 * Copyright 2001 - 2004 Pico Technology Limited
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, write to the Free Software
 *   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
 *
 *
 * Revision Info: "file %n date %f revision %v" *
 *                "file picolnx.c date 11-Feb-95,17:40:10 revision 1"
 *
 *   M K Green   email: mike.green@picotech.com
 *               http: www.picotech.com
 *
 *                "file picolnx.c date 06-Sep-04 revision 2"
 *   Thanks to J R Hunt, added support for kernel 2.6
 *
 *   J R Hunt    email: jrhunt at iee dot org
 *               http:  www.yoredale.uklinux.net
 *
 ****************************************************************************
 *
 * Module:       picolnx.C
 *
 * Description:
 * This module is an installable kernel mode driver for Linux.
 *
 ****************************************************************************/
#include <linux/kernel.h>       /* We're doing kernel work */
#include <linux/module.h>       /* Specifically, a module */
#include <linux/fs.h>
#include <asm/uaccess.h>        /* for get_user and put_user */
#include <linux/init.h>         /* Needed for the macros */
#include <linux/mm.h>
#include <asm/io.h>
#include <linux/delay.h>

/* 
 * inclui as duas linha abaixo para compilar 
 * no kernel 2.6.22.12
 */
#include <linux/jiffies.h>
#include <linux/sched.h>

#include "pico_lnx.h"

//#define DEBUG

/* Module information */
MODULE_AUTHOR( "Pico Technology Limited and J R Hunt" );
MODULE_DESCRIPTION( "Pico adc driver" );
MODULE_LICENSE("GPL");    

// some function prototypes
static int __init pico_init(void);
static void __exit pico_exit(void);
static int pico_open (struct inode * inode, struct file * file);
static int pico_release (struct inode * inode, struct file * file);
ssize_t pico_read (struct file * file, char * buffer, size_t count, loff_t * loff);
ssize_t pico_write (struct file * file, const char * buffer, size_t count, loff_t * loff);
static int pico_ioctl (struct inode * inode, struct file * file, unsigned int cmd, unsigned long arg);


struct file_operations pico_ops = {
  .read = pico_read,
  .write = pico_write,
  .ioctl = pico_ioctl,
  .open = pico_open,
  .release = pico_release
  };

#define TRUE 1
#define FALSE 0


/* Address of BIOS printer port table
 */
typedef struct {
  unsigned short 	base_address;
  unsigned char		product;
  unsigned char 	version;
  unsigned char		power;
  unsigned char		double_read;
  unsigned char		ranges [2];
  unsigned char 	digital_out;
  unsigned char		scale;
  } PORT_INFO;

extern void drdaq_initialise (void * port_ptr);
// UNS8 is a copy from drdaqscl.orig.h
typedef unsigned char  UNS8;
extern void drdaq_update_scaling (void * port_ptr, UNS8 channel);
extern int drdaq_get_value (void * port_ptr, int channel, int scale);
static PORT_INFO port_info [3] =
  {
  {.base_address = 0x378},
  {.base_address = 0x278},
  {.base_address = 0x3BC}
  };



/* #define VERSION 0x0100 */
/* 29Dec01 MKG Support for all products
		Changed IOCTL numbers */
/* #define VERSION 0x0200   */
/* 06Sep06 JRH Support for kernel 2.6 */
#define VERSION 0x0300

/****************************************************************************
 *
 *
 ****************************************************************************/
void delay (int ms)
  {
  unsigned long j;

  j = jiffies + ms * HZ / 1000;
  while (jiffies < j)
    {
    schedule ();
    }
  }

/****************************************************************************
 *
 * adc10_get_value - get a reading from the ADC-10
 *
 * This routine gets the result of the previous conversion from the ADC-10
 * and starts a new conversion
 *
 * accepts:
 *      nothing
 * returns:
 *      adc-10 value for previous conversion
 *        0   = 0V
 *        255 = 5V
 *
 ****************************************************************************/
/* Output register values
 */

#define ADC10_POWER   0xFC
#define ADC10_OFF     0x00
#define ADC10_CS      0x02
#define ADC10_CLK     0x01

/* Input register values
 */
#define ADC10_DATA    0x80

int adc10_get_value (PORT_INFO * port_ptr)
  {
  int i;
  unsigned short	output_address;
  unsigned short	input_address;
  int			value;

  output_address = port_ptr->base_address;
  input_address = output_address + 1;

  /* set *CS low - start conversion */
  outb (ADC10_POWER, output_address);

  value = 0;
  for ( i = 0 ; i < 8 ; i++ )
    {
    /* set CLOCK high */
    outb (ADC10_POWER+ADC10_CLK, output_address);

    /* shift value left once */
    value <<= 1;

    /* if input bit is zero,
     *  set the LSB
     */
    if ( (inb(input_address) & ADC10_DATA) == 0)
      {
      value++;
      }

    /* set CLOCK low */
    outb (ADC10_POWER, output_address);
    }

  /* set *CS high - start conversion */
  outb (ADC10_POWER+ADC10_CS,output_address);

  return (value);
  }

/****************************************************************************
 *
 * ADC11
 *
 ****************************************************************************/



#define ADC11_V1_DATA_BITS     10
#define ADC11_V1_ADDRESS_BITS  4
#define ADC11_V1_ASHIFT		3
#define ADC11_V1_ADDR          0x08
#define ADC11_V1_POWER         0x70
#define ADC11_V1_CS            0x00
#define ADC11_V1_NOT_CS        0x02
#define ADC11_V1_CLK           0x04
#define ADC11_V1_EOC    	0x40
#define ADC11_V1_DATA   	0x80
#define ADC11_V1_DOUT1   	0x01
#define ADC11_V1_DOUT2  	0x01
#define AD11_V1_MAX_BITCOUNT   1023

#define ADC11_V2_POWER         0xC6
#define ADC11_V2_CLK           0x20
#define ADC11_V2_NOT_CS        0x08
#define ADC11_V2_EOC           0x40
#define ADC11_V2_DATA          0x80
#define ADC11_V2_ADDR          0x10
#define ADC11_V2_DATA_BITS     10
#define ADC11_V2_ADDRESS_BITS  4
#define ADC11_V2_EOC    	0x40
#define ADC11_V2_DATA   	0x80
#define ADC11_V2_DOUT1   	0x01
#define ADC11_V2_DOUT2  	0x02
#define ADC11_V2_PWR2		0x04
#define AD11_V2_MAX_BITCOUNT	 4092

#define ADC11_V3_DATA_BITS     12
#define AD11_V3_MAX_BITCOUNT	 4095

static unsigned char adc11_v1_reverse_bits [14] =
 	{/* 1..11 are channels */
   0x00, 0x08, 0x04, 0x0C, 0x02, 0x0A, 0x06, 0x0E, 0x01, 0x09, 0x05,
   /* 12..14 are references (high, low, medium)*/
   0x0B, 0x03, 0x0D};

static unsigned char adc11_v2_reverse_bits [14] =
  {/* 1..11 are channels */
   0x50, 0x90, 0x10, 0xE0, 0x60, 0xA0, 0x20, 0xC0, 0x40, 0x80, 0x00,
   /* 12..14 are references (high, low, medium)*/
   0xB0, 0x30, 0xD0};

/****************************************************************************
 *
 * adc11_set_do
 *
 ****************************************************************************/

int adc11_set_do (PORT_INFO * port_ptr)
  {
  unsigned short	output_address;
  unsigned short	control_address;

  output_address = port_ptr->base_address;
  control_address = output_address + 2;

  switch (port_ptr->version)
    {
    case 1:
    port_ptr->power = ADC11_V1_POWER;
    if (port_ptr->digital_out & ADC11_DIGITAL_OUTPUT1)
      {
      port_ptr->power |= ADC11_V1_DOUT1;
      }
    outb (port_ptr->power, output_address);
    if (port_ptr->digital_out & ADC11_DIGITAL_OUTPUT2)
      {
      outb (ADC11_V1_DOUT2, control_address);
      }
    else
      {
      outb (0, control_address);
      }
    break;

    case 2:
    case 3:
    port_ptr->power = ADC11_V2_POWER;
    if (port_ptr->digital_out & ADC11_DIGITAL_OUTPUT1)
      {
      port_ptr->power |= ADC11_V2_DOUT1;
      }
    outb (port_ptr->power, output_address);
    if (port_ptr->digital_out & ADC11_DIGITAL_OUTPUT2)
      {
      outb (ADC11_V2_PWR2, control_address);
      }
    else
      {
      outb (ADC11_V2_PWR2+ADC11_V2_DOUT2, control_address);
      }
    break;
    }
    return 0;

  }

/****************************************************************************
 *
 * adc11_v1_get_value
 *
 *   This routine starts a conversion from channel "next_channel" and reads
 *   in the previous conversion.
 *
 *   The routine first waits for EOC to go low, indicating that the previous
 *   conversion has been completed.
 *
 *   *CS is then asserted,
 *
 *   The previous conversion is clocked into the PC by DATA_BITS high-to-low
 *   transitions on CLK. The address is clocked out to the ADC-11
 *   simultaneously on the first 4 of these transitions, as a 4-bit pattern,
 *   most significant bit first.
 *
 *
 *   accepts:
 *	port_ptr - port info
 *     next_channel - 0.. 10 - channel for next conversion
 *                    11     - zero reference     (0)
 *                    12     - midrange reference (511)
 *                    13     - maximum reference  (1023)
 *
 *   returns:
 *     0..1023 - result of conversion
 *     0    = 0V
 *     1023 = 2.5V
 *
 ****************************************************************************/

int adc11_v1_get_value (PORT_INFO * port_ptr, int value)
  {

  unsigned int j;
  unsigned char i;
  unsigned char address;
  unsigned char power;
  unsigned short	output_address;
  unsigned short	input_address;

  output_address = port_ptr->base_address;
  input_address = output_address + 1;

  power = port_ptr->power;

  /* Use table to invert order of address bits...
   * MSB must be clocked out first
   */
  address = adc11_v1_reverse_bits [value & 0x0F] << ADC11_V1_ASHIFT;

  /* Wait for the end of the last conversion
   */

  for (j = 0; j < 1000000L; j++)
    {
    if (inb (input_address) & ADC11_V1_EOC)
      break;
    }

  /* Assert *CS
   */
  outb (power + ADC11_V1_CS, output_address);

  /* For the first bits,
   *  clock in data and out address
   */
  value = 0;
  for ( i = 0 ; i < ADC11_V1_ADDRESS_BITS ; i++ )
    {
    /* CLK low
     */
    outb (power + ADC11_V1_CS + (address & ADC11_V1_ADDR), output_address);

    /* CLK high
     */
    outb (power + ADC11_V1_CS + (address & ADC11_V1_ADDR) + ADC11_V1_CLK, output_address);

    address >>= 1;

    value <<= 1;
    if ((inb (input_address) & ADC11_V1_DATA) == 0)
      {
      value++;
      }
    }

  /* For the remaining bits,
   *  clock in data (no address)
   */
  for (; i < ADC11_V1_DATA_BITS ; i++ )
    {
    /* CLK low
     */
    outb (power + ADC11_V1_CS, output_address);

    /* CLK high
     */
    outb (power + ADC11_V1_CS +  ADC11_V1_CLK, output_address);

    value <<= 1;
    if ((inb (input_address) & ADC11_V1_DATA) == 0)
      {
      value++;
      }
    }

  /* Negate *CS
   */
  outb (power + ADC11_V1_CS, output_address);

  return (value);
  }


/****************************************************************************
 *
 * adc11_v2_get_value
 *
 *   This routine starts a conversion from channel "next_channel" and reads
 *   in the previous conversion.
 *
 *   The routine first waits for EOC to go low, indicating that the previous
 *   conversion has been completed.
 *
 *   *CS is then asserted,
 *
 *   The previous conversion is clocked into the PC by DATA_BITS high-to-low
 *   transitions on CLK. The address is clocked out to the ADC-11
 *   simultaneously on the first 4 of these transitions, as a 4-bit pattern,
 *   most significant bit first.
 *
 *
 *   accepts:
 *	port_ptr - port info
 *     next_channel - 1.. 11- channel for next conversion
 *                    12     - zero reference     (0)
 *                    13     - midrange reference (511)
 *                    14     - maximum reference  (1023)
 *
 *   returns:
 *     0..4095 - result of conversion
 *     0    = 0V
 *     4095 = 2.5V
 *
 ****************************************************************************/


int adc11_v2_get_value (PORT_INFO * port_ptr, int value)
  {
  unsigned int j;
  unsigned short i;
  unsigned char address;
  unsigned char power;
  unsigned short	output_address;

  output_address = port_ptr->base_address;

  power = port_ptr->power;

  /* Use table to invert order of address bits...
   * MSB must be clocked out first
   */
  address = adc11_v2_reverse_bits [value & 0x0F];

  /* Wait for the end of the last conversion
   */
  for (j = 0; j < 1000000L; j++)
    {
    if (inb (output_address+1) & ADC11_V2_EOC)
      break;
    }

  /* Assert *CS
   */

  outb (power, output_address);

  /* For the first bits,
   *  clock in data and out address
   */
  value = 0;

  for ( i = 0 ; i < ADC11_V2_ADDRESS_BITS ; i++ )
    {
    /* CLK low
     */
    outb (power + (address & ADC11_V2_ADDR), output_address);

    /* CLK high
     */
    outb (power + (address & ADC11_V2_ADDR) + ADC11_V2_CLK, output_address);

    address >>= 1;

    value <<= 1;
    if ((inb (output_address+1) & ADC11_V2_DATA) == 0)
      {
      value++;
      }
    }

  /* For the remaining bits,
   *  clock in data (no address)
   */
  for (; i < ADC11_V2_DATA_BITS ; i++ )
    {
    /* CLK low
     */
    outb (power, output_address);

    /* CLK high
     */
    outb (power + ADC11_V2_CLK, output_address);

    value <<= 1;
    if ((inb (output_address+1) & ADC11_V2_DATA) == 0)
      {
      value++;
      }
    }

  /* For compatibility with V3...
   */
  value <<= 2;

  /* Negate *CS
   */
  outb (power + ADC11_V2_NOT_CS, output_address);

  return (value);
  }

/****************************************************************************
 *
 * adc11_get_value
 *
 *   This routine starts a conversion from channel "next_channel" and reads
 *   in the previous conversion.
 *
 *   The routine first waits for EOC to go low, indicating that the previous
 *   conversion has been completed.
 *
 *   *CS is then asserted,
 *
 *   The previous conversion is clocked into the PC by DATA_BITS high-to-low
 *   transitions on CLK. The address is clocked out to the ADC-11
 *   simultaneously on the first 4 of these transitions, as a 4-bit pattern,
 *   most significant bit first.
 *
 *
 *   accepts:
 *	port_ptr - port info
 *     next_channel - 1.. 11- channel for next conversion
 *                    12     - zero reference     (0)
 *                    13     - midrange reference (511)
 *                    14     - maximum reference  (1023)
 *
 *   returns:
 *     0..4095 - result of conversion
 *     0    = 0V
 *     4095 = 2.5V
 *
 ****************************************************************************/

int adc11_v3_get_value (PORT_INFO * port_ptr, int value)
  {
  unsigned int j;
  unsigned short i;
  unsigned char address;
  unsigned char power;
  unsigned short	output_address;
  unsigned short	input_address;

  output_address = port_ptr->base_address;
  input_address = output_address + 1;

  power = port_ptr->power;

  /* Use table to invert order of address bits...
   * MSB must be clocked out first
   */
  address = adc11_v2_reverse_bits [value & 0x0F];

  /* Wait for the end of the last conversion
   */
  for (j = 0; j < 1000000L; j++)
    {
    if (inb (input_address) & ADC11_V2_EOC)
      break;
    }

  /* Assert *CS
   */

  outb (power, output_address);

  /* For the first bits,
   *  clock in data and out address
   */
  value = 0;

  for ( i = 0 ; i < ADC11_V2_ADDRESS_BITS ; i++ )
    {
    /* CLK low
     */
    outb (power + (address & ADC11_V2_ADDR), output_address);

    /* CLK high
     */
    outb (power + (address & ADC11_V2_ADDR) + ADC11_V2_CLK, output_address);

    address >>= 1;

    value <<= 1;
    if ((inb (output_address+1) & ADC11_V2_DATA) == 0)
      {
      value++;
      }
    }

  /* For the remaining bits,
   *  clock in data (no address)
   */
  for (; i < ADC11_V3_DATA_BITS ; i++ )
    {
    /* CLK low
     */
    outb (power, output_address);

    /* CLK high
     */
    outb (power + ADC11_V2_CLK, output_address);

    value <<= 1;
    if ((inb (output_address+1) & ADC11_V2_DATA) == 0)
      {
      value++;
      }
    }

  /* Negate *CS
   */
  outb (power + ADC11_V2_NOT_CS, output_address);

  return (value);
  }

/****************************************************************************
 *
 * adc11_get_value - calls the conversion routine for the selected ADC version
 *
 ****************************************************************************/
int adc11_get_value (PORT_INFO * port_ptr, int value)
  {

  switch (port_ptr->version)
    {
    case 1:
    value = adc11_v1_get_value (port_ptr, value);
    break;

    case 2:
    value = adc11_v2_get_value (port_ptr, value);
    break;

    case 3:
    value = adc11_v3_get_value (port_ptr, value);
    break;
    }
  return value;
  }

/***************************************************************************
 *
 *  adc11_get_type - find out what type of ADC11
 *
 *  returns 111 - V1 adc-11
 *	    112 - V2 adc-11 - 10 bits
 *	    113 - V2 adc-11 - 12 bits
 *
 ***************************************************************************/

static void adc11_get_version (PORT_INFO * port_ptr)
  {
  	int med_value;

   //Flush last value
   adc11_v2_get_value (port_ptr, 13);

  	// When using adc11_v2_get_value() the medium values are
	// v1 - 4092
   // v2 - 2048
   // v3 - 0
   // 13 gets the middle bitcount from the ADC11
   med_value = adc11_v2_get_value (port_ptr, 13);

   // Max bitcount is different for each unit
   if (med_value > 2048)
   	{
      port_ptr->version = 1;
      }
   else if (med_value > 0)
      {
      port_ptr->version = 2;
      }
   else
      {
      port_ptr->version = 3;
      }
  }


/****************************************************************************
 *
 *  ADC12 version 2 info
 *
 ****************************************************************************/

/* Output register values
 */

#define ADC12_POWER   0xFC
#define ADC12_CS      0x02
#define ADC12_CLK     0x01

/* Input register values
 */
#define ADC12_DATA    0x80


/****************************************************************************
 *
 * adc12_get_value - get a reading from the ADC-12
 *
 * This routine gets the result of the previous conversion from the ADC-12
 * and starts a new conversion
 *
 ****************************************************************************/


int adc12_v2_get_value (PORT_INFO * port_ptr)
  {
  int   value;
  int   i;
  unsigned short	output_address;
  unsigned short	input_address;

  output_address = port_ptr->base_address;
  input_address = output_address + 1;

  /* Put CS low
   */
  outb (ADC12_POWER, output_address);

  /* Clock twelve data bits from the ADC
   */
  value = 0;
  for ( i = 0; i < 12; i++)
    {
    value <<= 1;

    outb (ADC12_POWER+ADC12_CLK, output_address);
    outb (ADC12_POWER, output_address);
    if (inb (input_address) & ADC12_DATA)
      {
      value++;
      }
    }


  /* Put CS high
   */
  outb (ADC12_POWER+ADC12_CS, output_address);

  /* invert the result and mask off unused bits
   */
  value = ~value;
  value &= 0xFFF;

  return value;

}

/****************************************************************************
 *
 *  adc12_get_value - select type of converter
 *
 *  (Version 1 is not supported under Linux)
 *
 ****************************************************************************/
int adc12_get_value (PORT_INFO * port_ptr)
  {
  int	value = 0;

  switch (port_ptr->version)
    {
    case 1:
    value = adc12_v2_get_value (port_ptr);
    break;

    case 2:
    value = adc12_v2_get_value (port_ptr);
    break;
    }
  return value;
  }


/****************************************************************************
 *
 *  ADC22 info
 *
 ****************************************************************************/

#define ADC22_INVALID_READING 0xFFFF

#define ADC22_DATA_BITS     10
#define ADC22_ADDRESS_BITS  4

#define ADC22_OFF    0x00
#define ADC22_POWER  0x38
#define ADC22_CLK    0x04
#define ADC22_CS     0x00
#define ADC22_CS_OFF 0x81
#define ADC22_ADDR   0x02
#define ADC22_DOUT   0x40

#define ADC22_EOC_A  0x80
#define ADC22_EOC_B  0x20
#define ADC22_DATA_A 0x08
#define ADC22_DATA_B 0x10

#define ADC22_ASHIFT 1

/****************************************************************************
 *
 * adc22_set_do
 *
  *
 ****************************************************************************/

int adc22_set_do (PORT_INFO * port_ptr)
  {

  if (port_ptr->digital_out)
    {
    port_ptr->power = ADC22_POWER + ADC22_DOUT;
    }
  else
    {
    port_ptr->power = ADC22_POWER;
    }

  outb (port_ptr->power, port_ptr->base_address);
  return 0;
  }

/****************************************************************************
 *
 * adc22_get_value
 *
 *   This routine starts a conversion from channel "next_channel" and reads
 *   in the previous conversion.
 *
 *   The routine first waits for EOC to go low, indicating that the previous
 *   conversion has been completed.
 *
 *   *CS is then asserted,
 *
 *   The previous conversion is clocked into the PC by DATA_BITS high-to-low
 *   transitions on CLK. The address is clocked out to the ADC-22
 *   simultaneously on the first 4 of these transitions, as a 4-bit pattern,
 *   most significant bit first.
 *
 *
 *   accepts:
 *     next_channel - 0..21  - channel for next conversion (Converters A, B)
 *                    22     - zero reference     (512)    (Converter 'A')
 *                    23     - midrange reference (0)      (Converter 'A')
 *                    24     - maximum reference  (1023)   (Converter 'A')
 *
 *                    25     - zero reference     (512)    (Converter 'B')
 *                    26     - midrange reference (0)      (Converter 'B')
 *                    27     - maximum reference  (1023)   (Converter 'B')
 *
 *   returns:
 *     0..1023 - result of conversion
 *
 ****************************************************************************/

int adc22_get_value (PORT_INFO * port_ptr, int next_channel)
  {
  unsigned char         i;
  unsigned int          value;
  unsigned char         data_ab;
  unsigned char         address;
  unsigned int          timeout;
  static unsigned char  last_channel;
  unsigned char		power;

  /* This table contains the address for each channel
   *  the address bits are in reverse order
   */
  static unsigned char reverse_bits [28] =
  {
  0x02,   0x0C,   0x04,   0x08,   0x00,   0x09,   0x05,
  0x01,   0x0E,   0x06,   0x0A,   0x02,   0x0C,   0x0A,
  0x06,   0x0E,   0x01,   0x05,   0x09,   0x00,   0x08,
  0x04,   0x0D,   0x03,   0x0B,   0x0D,   0x03,   0x0B
  };

  static unsigned char input_bit [28] =
  {
  ADC22_DATA_A, ADC22_DATA_A, ADC22_DATA_A, ADC22_DATA_A, ADC22_DATA_A, ADC22_DATA_B, ADC22_DATA_B,
  ADC22_DATA_B, ADC22_DATA_B, ADC22_DATA_B, ADC22_DATA_B, ADC22_DATA_B, ADC22_DATA_B, ADC22_DATA_A,
  ADC22_DATA_A, ADC22_DATA_A, ADC22_DATA_A, ADC22_DATA_A, ADC22_DATA_A, ADC22_DATA_B, ADC22_DATA_B,
  ADC22_DATA_B, ADC22_DATA_A, ADC22_DATA_A, ADC22_DATA_A, ADC22_DATA_B, ADC22_DATA_B, ADC22_DATA_B,
  };
  unsigned short	output_address;
  unsigned short	input_address;

  output_address = port_ptr->base_address;
  input_address = output_address + 1;

  value = 0;

  power = port_ptr->power;


  /* We are reading the result of the previous conversion:
   * if the last channel refered to converter B,
   *  we must get the result from that unit,
   *   even if we are clocking the next address into  converter A
   */

  data_ab = input_bit [last_channel];

  /*Store which ADC the current conversion refers to
   */
  last_channel = next_channel;

  /* Use address table to invert order of address bits...
   * MSB must be clocked out first
   */
  address = reverse_bits [next_channel] << ADC22_ASHIFT;

  /* Wait for both ADC-22's to finish converting
   */
  timeout = 0;
  while (((inb (input_address) & ADC22_EOC_A) == 1)
  &&     (timeout++ < 1000));

  while (((inb (input_address) & ADC22_EOC_B) == 0)
  &&     (timeout++ < 1000));

  if (timeout >= 1000)
    return (ADC22_INVALID_READING);

  /* Assert *CS
   */
  outb (power + ADC22_CS, output_address);

  /* For the first bits,
   *  clock in data and out address
   */
  for ( i = 0 ; i < ADC22_ADDRESS_BITS ; i++ )
    {
    /* CLK low
     */
    outb (power + (address & ADC22_ADDR) + ADC22_CS, output_address);

    /* CLK high
     */
    outb (power + (address & ADC22_ADDR) + ADC22_CS + ADC22_CLK, output_address);

    address >>= 1;

    value <<= 1;
    if ((inb (input_address) & data_ab) != 0)
      {
      value++;
      }
    }

  /* For the remaining bits,
   *  clock in data (no address)
   */
  for (; i < ADC22_DATA_BITS ; i++ )
    {
    /* CLK low
     */
    outb (power + ADC22_CS, output_address);

    /* CLK high
     */
    outb (power + ADC22_CS + ADC22_CLK, output_address);

    value <<= 1;
    if ((inb (input_address) & data_ab) != 0)
      {
      value++;
      }
    }

  /* Negate *CS
   */
  outb (power + ADC22_CS_OFF, output_address);

  return (value);
  }


/****************************************************************************
 *
 *
 *
 ****************************************************************************/
#define ADC100_POWER_ADAPTER 0x07
#define ADC100_POWER_NORMAL 0x0F

#define ADC100_CH_A	       0x00
#define ADC100_CH_B            0x20
#define ADC100_HIGH_BYTE       0x80
#define ADC100_SR_CLK          0x40
#define ADC100_SR_DATA         0x10
#define ADC100_FOURBIT_UPPER   0x08

  static struct
    {
    unsigned int mv;
    unsigned int multiplier;
    unsigned char a_shift;
    unsigned char b_shift;
    } adc100_ranges [] =
	{
	{50, 50000, 0x30,   0x09},
	{100, 100000, 0xb0,   0x0d},
	{200, 200000, 0xf0,   0x0f},
	{500, 500000, 0x20,   0x08},
	{1000, 1000, 0xa0,   0x0c},
	{2000, 2000, 0xd0,   0x0e},
	{5000, 5000, 0x00,   0x00},
	{10000, 10000, 0x80,   0x04},
	{20000, 20000, 0xC0,   0x06}};
#define MAX_ADC100_RANGES (sizeof (adc100_ranges) / sizeof (adc100_ranges [0]))


/****************************************************************************
 *
 * adc100_reset - power up sequence is important to prevent latch-up
 *
 ****************************************************************************/

void adc100_reset (PORT_INFO * port_ptr)
  {

  switch (port_ptr->version)
    {
    case 0:
    port_ptr->power = ADC100_POWER_NORMAL;
    break;

    case 1:
    port_ptr->power = ADC100_POWER_ADAPTER;
    break;
    }

  outb (0, port_ptr->base_address);
  outb (0x0B, port_ptr->base_address+2);
  delay (400);

  outb (port_ptr->power, port_ptr->base_address);
  outb (4, port_ptr->base_address+2);
  delay (100);
  }

/****************************************************************************
 *
 * adc100_set_range - write the voltage range into the shift register
 *
 ****************************************************************************/
void adc100_set_range (PORT_INFO * port_ptr)
  {

  int 	       		i;
  unsigned char		power = 0;
  unsigned char 	data;
  unsigned char 	shift;


  /* Decide what to write into the shift register
   *  for these ranges
   */

  shift = adc100_ranges [port_ptr->ranges [ADC100_CHANNEL_A]].a_shift
  	| adc100_ranges [port_ptr->ranges [ADC100_CHANNEL_B]].b_shift;

  /* Shift the data into the adc-100
   */
  for (i = 0; i < 8; i++)
    {
    if (shift & 0x80)
      {
      data = port_ptr->power + ADC100_SR_DATA;
      }
    else
      {
      data = port_ptr->power;
      }
      shift <<= 1;
      outb (data, port_ptr->base_address);
      outb (data+ ADC100_SR_CLK, port_ptr->base_address);
    }

  /* Put the clock low and the data high
   */
  outb (power, port_ptr->base_address);
  outb (power+ADC100_SR_DATA, port_ptr->base_address);

  }

/****************************************************************************
 *
 * adc100_get_fast_value - read from a non-adapter adc100
 *
 ****************************************************************************/

 short adc100_get_fast_value (PORT_INFO * port_ptr, unsigned char channel)
  {
  short 		part1;
  short 		value;
  unsigned short	control;

  control = ADC100_POWER_NORMAL + ADC100_SR_DATA;
  if (channel)
    {
    control |= ADC100_CH_B;
    }

  outb (control | ADC100_HIGH_BYTE, port_ptr->base_address);

  part1 = inb (port_ptr->base_address+2);

  outb (port_ptr->base_address, control);

  value = inw (port_ptr->base_address+1);
  value = ((value >> 8) & 0x000F) | (value & 0x00F0);

  value = (value | ((part1 << 8) & 0x0F00)) ^ 0xB8B;
  if (value & 0x0800)
    {
    value |= 0xF000;
    }
  value = 2047 - value;

  return value;
  }

/****************************************************************************
 *
 * adc100_get_adapter_value - read from an adc100 with adapter or an ADC101
 *
 ****************************************************************************/

short adc100_get_adapter_value (PORT_INFO * port_ptr, unsigned char channel)
  {
  short value;

  unsigned short	control;

  control = ADC100_POWER_ADAPTER + ADC100_SR_DATA;
  if (channel)
    {
    control |= ADC100_CH_B;
    }

  value = inb (port_ptr->base_address+1) & 0xF0;

  outb (port_ptr->base_address, control);
  value |= (inb (port_ptr->base_address+1) & 0xF0) >> 4;

  outb (control | 0x80, port_ptr->base_address);
  value |= (inb (port_ptr->base_address+1) & 0xF0) << 4;

  value ^= 0x888;
  outb (control | 0x08, port_ptr->base_address);

  if (value & 0x0800)
    {
    value |= 0xF000;
    }
  value = 2047 - value;

  return value;
  }

/****************************************************************************
 *
 *  adc100_get_value - call the appropriate ADC100 conversion routine
 *
 ****************************************************************************/
int adc100_get_value (PORT_INFO * port_ptr, unsigned short channel)
  {
  int	value;

  if (port_ptr->version)
    {
    value = adc100_get_adapter_value (port_ptr, channel);
    }
  else
    {
    value = adc100_get_fast_value (port_ptr, channel);
    }
  return value;
  }


/****************************************************************************
 *
 * adc100_detect_adapter - find out whether the ADC100 has a 4-bit adapter
 *
 ****************************************************************************/

static void adc100_detect_adapter (PORT_INFO * port_ptr)
  {

  /* Turn on the other power bits,
   *  so that the adapter sense output is free to move
   */
  outb (ADC100_POWER_NORMAL, port_ptr->base_address);

  /* Turn off the adapter sense output
   *  and check whether in6 is low
   */
  outb (0x02, port_ptr->base_address+2);
  delay (50);

  if (inb (port_ptr->base_address+1) & 0x08)
    {
    port_ptr->version = 0;
    }
  else
    {
    /* Turn on the adapter sense output
     *  and check whether in6 is now high
     */
    outb (0x04, port_ptr->base_address+2);
    delay (50);

    if (inb (port_ptr->base_address) & 0x08)
      port_ptr->version = 1;
    else
      port_ptr->version = 0;
    }

  }


/****************************************************************************
 *
 * pico_read
 *
 ****************************************************************************/
ssize_t pico_read (struct file * file, char * buffer, size_t count, loff_t * loff)
  {
  return count;
  }

/****************************************************************************
 *
 * pico_write
 *
 ****************************************************************************/
ssize_t pico_write (struct file * file, const char * buffer, size_t count, loff_t * loff)
  {
  return count;
  }

/****************************************************************************
 *
 * pico_ioctl - main I/O handler
 *
 ****************************************************************************/
static int pico_ioctl (struct inode * inode, struct file * file, unsigned int cmd, unsigned long arg)
  {
  unsigned short	channel;
  PORT_INFO *		port_ptr;
  int 			value;

  port_ptr = &port_info [MINOR (inode->i_rdev)];
  switch (cmd)
    {
    case IOCTL_PICO_GET_VERSION:
    value = VERSION;
    put_user (value, (int *) arg);
    break;

    case IOCTL_PICO_READ_PORT:
    get_user (value, (int *) arg);
    value = inb (value);
    put_user (value, (int *) arg);
    break;

    case IOCTL_PICO_WRITE_PORT:
    get_user (value, (int *) arg);
    outb (value & 0xFFFF, value >> 16);
    break;

    case IOCTL_PICO_SET_PRODUCT:
    get_user (value, (int *) arg);
    port_ptr->product = value;
    port_ptr->scale = TRUE;
    switch (value)
      {
      case 10:
      case 40:
      adc10_get_value (port_ptr);
      break;

      case 12:
      case 42:
      port_ptr->version = 2;
      adc12_v2_get_value (port_ptr);
      break;

      case 11:
      port_ptr->version = 3;
      port_ptr->digital_out = ADC11_DIGITAL_OUTPUT1;
      adc11_set_do (port_ptr);
      delay (100);
      adc11_get_version (port_ptr);
      adc11_set_do (port_ptr);
      break;

      case 22:
      port_ptr->digital_out = ADC11_DIGITAL_OUTPUT1;
      adc22_set_do (port_ptr);
      delay (100);
      break;

      case PRODUCT_DRDAQ:
      port_ptr->digital_out = ADC11_DIGITAL_OUTPUT1;
      port_ptr->version = 2;
      adc11_set_do (port_ptr);
      delay (100);
      drdaq_initialise (port_ptr);
      break;

      case 100:
      adc100_detect_adapter (port_ptr);
      adc100_reset (port_ptr);
      port_ptr->ranges [ADC100_CHANNEL_A] = ADC100_RANGE_5V;
      port_ptr->ranges [ADC100_CHANNEL_B] = ADC100_RANGE_5V;
      adc100_set_range (port_ptr);
      break;

      default:
      port_ptr->product = 99;
      break;
      }

    break;
    
    case IOCTL_PICO_SET_HW_VERSION:
    get_user (value, (int *) arg);
    port_ptr->version = value;
    break;

    case IOCTL_PICO_GET_HW_VERSION:
    value = port_ptr->version;
    put_user (value, (int *) arg);
    break;

    case IOCTL_PICO_SET_DIGITAL_OUT:
    get_user (value, (int *) arg);
    port_ptr->digital_out = value;
    switch (port_ptr->product)
      {
      case 11:
      case PRODUCT_DRDAQ:
      adc11_set_do (port_ptr);
      break;

      case 22:
      adc22_set_do (port_ptr);
      break;
      }
    break;

    case IOCTL_PICO_SET_RANGE:
    get_user (value, (int *) arg);
    switch (port_ptr->product)
      {
      case 100:
      channel = value >> 16;
      port_ptr->ranges [channel] = value & 0xFFFF;
      if (port_ptr->ranges [channel] >= MAX_ADC100_RANGES)
	{
	port_ptr->ranges [channel] = MAX_ADC100_RANGES-1;
	}
      adc100_set_range (port_ptr);
      break;

      case PRODUCT_DRDAQ:
      drdaq_update_scaling (port_ptr, value);
      break;
      }
    break;

    case IOCTL_PICO_SET_READ_MODE:
    get_user (value, (int *) arg);
    port_ptr->double_read = value;
    break;

    case IOCTL_PICO_SET_SCALE:
    get_user (value, (int *) arg);
    port_ptr->scale = value;
    break;

    case IOCTL_PICO_GET_VALUE:
    get_user (value, (int *) arg);
    switch (port_ptr->product)
      {
      case 10:
      case 40:
      if (port_ptr->double_read)
        {
        adc10_get_value (port_ptr);
	udelay (40);
        }
      value = adc10_get_value (port_ptr);
      if (port_ptr->scale)
        {
        if (port_ptr->product == 10)
          {
          value = value * 5000 / 255;
          }
        else
          {
          value = (value - 128) * 5000 / 127;
          }
        }
      break;

      case 12:
      case 42:
      if (port_ptr->double_read)
        {
        adc12_get_value (port_ptr);
        udelay (40);
        }
      value = adc12_get_value (port_ptr);
      if (port_ptr->scale)
        {
        if (port_ptr->product == 12)
	  {
          value = value * 5000 / 4095;
          }
        else
          {
          value = (value - 2048) * 5000 / 2047;
          }
        }
      break;

      case 11:
      if (port_ptr->double_read)
        {
        adc11_get_value (port_ptr, value);
        udelay (30);
        }

      value = adc11_get_value (port_ptr, value);

		if (port_ptr->scale)
      	{
         switch (port_ptr->version)
         	{
            case 1:
            value = (value * 2500) / AD11_V1_MAX_BITCOUNT;
            break;

            case 2:
            value = (value * 2500) / AD11_V2_MAX_BITCOUNT;
            break;

            case 3:
        		value = (value * 2500) / AD11_V3_MAX_BITCOUNT;
            break;
            };
        	}
      break;

      case 22:
      if (port_ptr->double_read)
        {
        adc22_get_value (port_ptr, value);
        udelay (30);
        }
      value = adc22_get_value (port_ptr, value);
      if (port_ptr->scale)
        {
        value = (value * 5000) / 4095;
        }
      break;

      case PRODUCT_DRDAQ:
      if (port_ptr->double_read)
        {
        drdaq_get_value (port_ptr, value, FALSE);
        udelay (30);
        }
      value = drdaq_get_value (port_ptr, value, port_ptr->scale);
      break;

      case 100:
      channel = value & 1;
      if (port_ptr->double_read)
        {
        adc100_get_value (port_ptr, channel);
        udelay (10);
        }
      value = adc100_get_value (port_ptr, channel);
      if (port_ptr->scale)
        {
        value = ((value - 2048) * adc100_ranges [port_ptr->ranges[channel]].multiplier) / 2047;
        }
      break;

      default:
      value = port_ptr->product;
      break;

      }
    put_user (value, (int *) arg);
    break;

    default:
    break;
    }

  return 0;

  }

/****************************************************************************
 *
 * pico_init
 *
 ****************************************************************************/
static int __init pico_init(void)
{
    int ret_val;

    ret_val = register_chrdev(MAJOR_NUM, DRIVER_NAME, &pico_ops);
    if (ret_val < 0) {
        printk("%s %s failed with %d\n",
                "Sorry, registering the pico device", DRIVER_NAME, ret_val);
        return ret_val;
    }

#ifdef DEBUG
    printk("%s The major device number is %d.\n",
            "Registration is a success", MAJOR_NUM);
    printk("If you want to talk to the device driver,\n");
    printk("you'll have to create a device file. \n");
    printk("We suggest you use:\n");
    printk("mknod %s c %d 0\n", DEVICE_FILE_NAME, MAJOR_NUM);
    printk("mknod %s c %d 1\n", DEVICE_FILE_NAME, MAJOR_NUM);
    printk("mknod %s c %d 2\n", DEVICE_FILE_NAME, MAJOR_NUM);
#endif

    return 0;
}

module_init(pico_init);

/****************************************************************************
 *
 * pico_exit
 *
 ****************************************************************************/
static void __exit pico_exit(void)
{
    int ret;

    ret = unregister_chrdev(MAJOR_NUM, DRIVER_NAME);
    if (ret < 0) {
        printk("Error in pico_exit: %d\n", ret);
        return;
    }

#ifdef DEBUG
    printk(KERN_ALERT "%s pico_exit OK\n", DRIVER_NAME);
#endif
}

module_exit(pico_exit);


/****************************************************************************
 *
 * pico_open
 *
 ****************************************************************************/
static int pico_open (struct inode * inode, struct file * file)
{
    int ret;

    ret = try_module_get(THIS_MODULE);
    if (ret < 0) {
        printk("Error in try_module_get: %d\n", ret);
        return ret;
    }

#ifdef DEBUG
    printk(KERN_ALERT "%s pico_open OK\n", DRIVER_NAME);
#endif
    return 0;
}

/****************************************************************************
 *
 * pico_release
 *
 ****************************************************************************/
static int pico_release (struct inode * inode, struct file * file)
{
    module_put(THIS_MODULE);

#ifdef DEBUG
    printk(KERN_ALERT "%s pico_release OK\n", DRIVER_NAME);
#endif
    return 0;
}

