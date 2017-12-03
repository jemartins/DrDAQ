/*=======================================================

	This software was developed for
	iCanProgram Inc., Toronto, Canada


FILE:		picoMgrUtils.c

DESCRIPTION:	
This file contains source for picoMgr.

AUTHOR:		R.D. Findlay

Revision history:
=======================================================
$Log: picoMgrUtils.c,v $
Revision 1.2  2006/03/24 20:11:53  bobfcsoft
task b001 changes

Revision 1.1  2006/03/13 20:45:39  bobfcsoft
separate Linux 2.4 version

Revision 1.1.1.1  2006/03/07 21:29:47  bobfcsoft
startup

=====================================================*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <sys/ioctl.h>

#include "pico_lnx.h"

#define _ALLOC extern
#include "picoMgr.h"
#undef _ALLOC

#include "picoMgrProto.h"
#include "loggerProto.h"

/*============================================
	turnLedOn - entry point
============================================*/
int turnLedOn()
{
static char *fn="turnLedOn";
int value;
int rc=0;

fcLogx(__FILE__, fn,
	globalMask,
	PICOMGR_FUNC_IO,
	"ding"
	);

      value = 1 * DRDAQ_LED + digital_output * DRDAQ_DIGITAL_OUTPUT;
      ioctl (picofd, IOCTL_PICO_SET_DIGITAL_OUT, &value);

return(rc);

} // turnLedOn

/*============================================
	turnLedOff - entry point
============================================*/
int turnLedOff()
{
static char *fn="turnLedOff";
int value;
int rc;

fcLogx(__FILE__, fn,
	globalMask,
	PICOMGR_FUNC_IO,
	"ding"
	);

      value = 0 * DRDAQ_LED + digital_output * DRDAQ_DIGITAL_OUTPUT;
      ioctl (picofd, IOCTL_PICO_SET_DIGITAL_OUT, &value);

return(rc);

} // turnLedOff

/*============================================
	readTemperature - entry point
============================================*/
int readTemperature()
{
static char *fn="readTemperature";
int value;

value = 6; // temperature
//value = 7; //light
ioctl (picofd, IOCTL_PICO_GET_VALUE, &value);

fcLogx(__FILE__, fn,
	globalMask,
	PICOMGR_FUNC_IO,
	"value=%d",
	value
	);

//value=scale_temp(value);

return(value);

} // end readTemperature

/****************************************************************************
 *
 *
 ****************************************************************************/
int drdaq_open (int lp)
  {
  int 		file;
  char 		dev_name [20];
#if 0
  int		value;
#endif

  /* Open the device for this printer port
   */
  sprintf (dev_name, "/dev/pico%d", lp);
  file = open (dev_name, 0);
  return file;
  }


static int temp[17][2] = {
{ 55, 1500 },
{ 216, 1000 },
{ 400, 800 },
{ 755, 600 },
{ 1384, 400 },
{ 1813, 300 },
{ 2048, 250 },
{ 2289, 200 },
{ 2530, 150 },
{ 2765, 100 },
{ 2985, 50 },
{ 3187, 0 },
{ 3366, -50 },
{ 3520, -100 },
{ 3756, -200 },
{ 3907, -300 },
{ 4046, -500 },
};

int scale_temp(int adcCount)
{
	int i, diffScaled, diffRaw, diffAdc, scaledValue=0;
	double scaleFactor;
	for (i=0; i<16; i++)
	{
		if (adcCount >= temp[i][0] && adcCount < temp[i+1][0])
		{
			diffScaled = temp[i][1] - temp[i+1][1];
			diffRaw = temp[i+1][0] - temp[i][0];
			scaleFactor = (double)diffScaled / (double)diffRaw;
			diffAdc = adcCount - temp[i][0];
			scaledValue = temp[i][1] - (diffAdc * scaleFactor);
			return scaledValue;
		}
	}
	return -1;
}


#if 0
/****************************************************************************
 *
 * Pico DrDAQ example program
 *
 * Module:       ddtest.c
 *
 * Copyright 2001 Pico Technology Limited
 *
 * Description:
 * This module demonstrates how to access the DrDAQ driver.
 *
 * The following IOCTLs are supported:
 *	IOCTL_PICO_SET_PRODUCT
 *		67 - product is DrDAQ
 *
 * 	IOCTL_PICO_SET_SCALE
 *		SCALE_ADC - return values in ADC counts
 *		SCALE_MV - return values in engineering units, eg degC for temperature
 *
 *	DrDAQ is a 10-bit device, but the driver treats it as a 12-bit device and
 *	returns a value between 0 and 4095. The external inputs accept signals in the 0..2500mV input range.
 *      the driver applies the following conversions:
 *		ADC	mV
 *		0	0
 *		4095    2500
 *
 *	IOCTL_PICO_SET_READ_MODE
 *		READ_MODE_SINGLE - take a single conversion for each call
 *		READ_MODE_DOUBLE - take two conversions for each call
 *
 *	On each conversion, the ADC returns the value of the previous conversion.
 *	If READ_MODE_SINGLE is used, the returned value is the value for the previous call.
 *	This may be acceptable when reading at high speed, but could cause problems
 *	if you take (say) one reading per second.
 *
 *	If READ_MODE_DOUBLE is used, each call takes twice as long, butthe
 *      returned value is the value for the first of the two conversions- ie
 *      it is a current reading, rather than one from the previous call.
 *
 *	IOCTL_PICO_SET_DO
 *		0 - digital output is off
 *		1 - digital output is on
 *		2 - LED is on
 *		3 - LED and digital output are on
 *
 *	IOCTL_PICO_GET_VALUE
 *	  accepts:
 *        	1 - Sound waveform
 *		2 - Sound level
 *		3 - Voltage
 *		4 - Resistance
 *		5 - pH
 *		6 - Temperature
 *		7 - Light
 *		8 - External input 1
 *		9 - External input 2
 *		10 - resistance value for EXT1
 *		11 - resistance value for EXT2
 *	  returns:
 *		adc value or reading in engineering units
 *
 * Revision Info: "file %n date %f revision %v"
 *                "file a11test.c date 11-Feb-95,17:40:10 revision 1"
 *
 ****************************************************************************/


#include <stdio.h>
#include <sys/time.h>
#include <unistd.h>
#include <asm/ioctl.h>

#include "pico_lnx.h"

#define FALSE 		0
#define TRUE 		1
#define MAX_SAMPLES 	1000
#define MAX_CHANNELS	2      /* No of channels you can record from at once
				* You can increase this if required */
#define MAX_DRDAQ_CHANNELS 9


int	file;
int	values [MAX_CHANNELS] [MAX_SAMPLES];
long	times [MAX_SAMPLES];
int	scale_values = TRUE;
int	digital_output;
int	led;

/****************************************************************************
 *
 *
 ****************************************************************************/
int drdaq_open (int lp)
  {
  int 		file;
  char 		dev_name [20];
  int		value;

  /* Open the device for this printer port
   */
  sprintf (dev_name, "/dev/pico%d", lp);
  file = open (dev_name, 0);
  return file;
  }

/****************************************************************************
 *
 *
 ****************************************************************************/
void time_readings (void)
  {
  struct timeval 	start;
  struct timeval 	end;
  struct timezone 	tz;
  int			i;
  int			value;
  int			interval;

  /* Set single read mode
   *  (fast, but each call gives you get the result of the previous conversion)
   */

  value = READ_MODE_SINGLE;
  ioctl (file, IOCTL_PICO_SET_READ_MODE, &value);

  gettimeofday (&start, &tz);
  for (i = 0; i < MAX_SAMPLES; i++)
    {
    /* Single read from channel 3
     */
    value = 3;
    ioctl (file, IOCTL_PICO_GET_VALUE, &value);
    values [0] [i] = value;
    }
  gettimeofday (&end, &tz);

  interval = end.tv_usec - start.tv_usec;
  if (interval < 0)
    {
    interval += 1000000;
    }

  printf ("%d readings in %ld us\n", MAX_SAMPLES, interval);
  }


/****************************************************************************
 *
 *
 ****************************************************************************/
void write_block_to_file (void)
  {
  struct timeval 	time;
  struct timezone 	tz;
  int			i;
  int			j;
  int			value;
  int			interval;
  FILE *		out_fp;

  printf ("Writing data to drdaq.txt\n");

  /* Set single read mode
   *  (fast, but each call gives you get the result of the previous conversion)
   */

  value = READ_MODE_SINGLE;
  ioctl (file, IOCTL_PICO_SET_READ_MODE, &value);

  for (i = 0; i < MAX_SAMPLES; i++)
    {
    /* This is how to vary the sampling interval...
     *  or omit for full-speed operation
     */
    for (j = 0; j < 1000; j++);

    /* Single read  from channels 3 and 5
     *  remember that each ioctl gives the result of the PREVIOUS conversion,
     * So we have to take one extra reading to get the last conversion
     */
    value = 6;
    ioctl (file, IOCTL_PICO_GET_VALUE, &value);
    value = 7;
    ioctl (file, IOCTL_PICO_GET_VALUE, &value);
    values [0] [i] = value;
    value = 7;
    ioctl (file, IOCTL_PICO_GET_VALUE, &value);
    values [1] [i] = value;

    gettimeofday (&time, &tz);
    times [i] = time.tv_usec;
    }

  out_fp = fopen ("drdaq.txt", "w");
  if (out_fp != NULL)
    {
    for (i = 0; i < MAX_SAMPLES; i++)
      {
      interval = times [i] - times [0];
      if (interval < 0)
        interval += 1000000;

      fprintf (out_fp, "%d %d %d\n", interval, values [0] [i], values [1] [i]);
      }
    fclose (out_fp);

    }
  }

/****************************************************************************
 *
 *
 ****************************************************************************/
long get_ms (void)
  {
  struct timeval 	time;
  struct timezone 	tz;

  gettimeofday (&time, &tz);

  return time.tv_sec * 1000 + time.tv_usec / 1000;
  }

void write_continuous_to_file (void)
  {
  int			i;
  int			j;
  int			value;
  int			start_ms;
  int			next_ms;
  int			ms;
  FILE *		out_fp;
  int			ch;

  value = READ_MODE_DOUBLE;
  ioctl (file, IOCTL_PICO_SET_READ_MODE, &value);

  out_fp = fopen ("drdaq.txt", "w");
  if (out_fp != NULL)
    {
    start_ms = get_ms ();
    ms = 0;
    next_ms = 0;
    for (i = 0; i < 50; i++)
      {
      while (ms < next_ms)
        {
        ms = get_ms () - start_ms;
        }
      next_ms += 10;

      for (ch = 1; ch <= 11; ch++)
        {
        value = ch;
        ioctl (file, IOCTL_PICO_GET_VALUE, &value);

        fprintf (out_fp, "%5d", value);
        printf ("%5d", value);
        }
      fprintf (out_fp, "\n");
      printf ("\n");
      }

    fclose (out_fp);

    }
  }


/****************************************************************************
 *
 *
 ****************************************************************************/

int main (void)
  {
  char 		line [80];
  char		ch;
  int		port;
  int		value;

  printf ("Pico DrDAQ example for Linux V1.0\n");
  printf ("Enter printer port (0..2)\n");
  fgets (line, sizeof (line), stdin);
  port = line [0] - '0';

  file = drdaq_open (port);
  if (file == 0)
    {
    printf ("Unable to open port\n");
    exit (99);
    }

  ioctl (file, IOCTL_PICO_GET_VERSION, &value);
  printf ("Kernel driver version %04x\n", value);

  value = PRODUCT_DRDAQ;
  ioctl (file, IOCTL_PICO_SET_PRODUCT, &value);


  ch = ' ';
  while (ch != 'X')
    {
    printf ("A - switch between ADC values and measurement units\n");
    printf ("D - Toggle the digital output\n");
    printf ("L - Toggle the LED\n");
    printf ("T - timed readings\n");
    printf ("B - write block to file\n");
    printf ("C - write continuous data to file\n");
    printf ("X - exit\n");

    fgets (line, sizeof (line), stdin);
    ch = toupper (line [0]);
    switch (ch)
      {
      case 'A':
      scale_values = !scale_values;
      value = scale_values;
      ioctl (file, IOCTL_PICO_SET_SCALE, &value);
      if (scale_values)
        {
        printf ("Values will be displayed in measurement units\n");
        }
      else
        {
        printf ("Values will be displayed in ADC counts\n");
        }
      break;

      case 'D':
      digital_output = !digital_output;
      value = led * DRDAQ_LED + digital_output * DRDAQ_DIGITAL_OUTPUT;
      ioctl (file, IOCTL_PICO_SET_DIGITAL_OUT, &value);
      if (digital_output)
        {
        printf ("Digital output is ON\n");
        }
      else
        {
        printf ("Digital output is OFF\n");
        }
      break;

      case 'L':
      led = !led;
      value = led * DRDAQ_LED + digital_output * DRDAQ_DIGITAL_OUTPUT;
      ioctl (file, IOCTL_PICO_SET_DIGITAL_OUT, &value);
      if (led)
        {
        printf ("LED is ON\n");
        }
      else
        {
        printf ("LED is OFF\n");
        }
      break;

      case 'T':
      time_readings ();
      break;

      case 'B':
      write_block_to_file ();
      break;

      case 'C':
      write_continuous_to_file ();
      break;
      }
    }


  close (file);

  return 0;
  }
#endif
