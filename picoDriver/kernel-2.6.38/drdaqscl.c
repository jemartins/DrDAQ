/****************************************************************************
 *
 * Product:      PICO DrDaq
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
 *                "file drdaqscl.c date 11-Feb-95,17:40:10 revision 1"
 *
 *   M K Green   email: mike.green@picotech.com
 *               http: www.picotech.com
 *
 *                "file drdaqscl.c date 06-Sep-04 revision 2"
 *   Thanks to J R Hunt, added support for kernel 2.6
 *
 *   J R Hunt    email: jrhunt at iee dot org
 *               http:  www.yoredale.uklinux.net
 *
 **************************************************************************** 
 *
 * Module:       drdaqscl.C
 *
 * Description:
 * This module provides the scaling functionality required for the DrDAQ.
 *
 *
 ****************************************************************************/
#include "drdaqdrv.h"

#define TRUE 1
#define FALSE 0
// This struct is a copy from picolnx.orig.c
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

extern int adc11_v2_get_value (PORT_INFO * port_ptr, int value);

/****************************************************************************
 *
 * Info about channels
 *
 ****************************************************************************/

 static struct
  {
  char * 	full_name;
  char * 	short_name;
  UNS8		channel;
  UNS8		reverse_bits;  /* Channel address to send to pico.xxx */
  UNS16		resistor;      /* Simulated 'resistor value' for internal sensors */
  } channel_details [] =
  {
  {"Sound Waveform",	"Sound",     4,	0xE0,	1200},
  {"Sound Level",	"Level",     3,	0x10, 	1300},
  {"Voltage",		"Volts",     2,	0x90,	1500},
  {"Resistance",	"Ohms",      1,	0x50, 	1600},
  {"pH",		"pH", 	     5,	0x60,	1400},
  {"Temperature",	"Temp",	     10,	0x80,	1100},
  {"Light",		"Light",     11,	0x00, 	1000},
  {"External 1",	"Ext1",      6,	0xA0,	0},
  {"External 2",	"Ext2",      8,	0xC0, 	0},

  /* 10 and 11 are detects for Ext1 and Ext2
   */
  {"Detect 1",		"", 	     7,	0x20,	2000},
  {"Detect 2",		"", 	     9,	0x40,	2000},

   /* 12..14 are references */
  {"Ref1",		"",	     12,	0xD0,   0},
  {"Ref2",		"",	     13,	0x30,   0},
  {"Ref3",		"",	     14,	0xB0,   0}

  };

/****************************************************************************
 *
 * Info about sensors
 *
 ****************************************************************************/
#define FULL_NAME_LENGTH 	30
#define SHORT_NAME_LENGTH 	6
#define UNITS_LENGTH		8

typedef struct
  {
  UNS16		raw;
  INT16		scaled;
  } SCALE_POINT;

typedef enum {
  OR_INVALID,
  OR_TRUNCATE,
  OR_EXTRAPOLATE,
  OR_MAX
  } OUT_OF_RANGE;

typedef enum {
  SM_LOOKUP,
  SM_PH,
  SM_TEMP,
  SM_DETECT,
  SM_MAX
  } SCALE_METHOD;

typedef struct
  {
  UNS16		scale_id;
  UNS16		resistor;

  UNS16		is_fast;

  char 		long_name [FULL_NAME_LENGTH+1];
  char 		short_name [SHORT_NAME_LENGTH+1];
  char 		units [UNITS_LENGTH+1];

  INT16		min_value;
  INT16		max_value;
  UNS8		out_of_range;   /* OUT_OF_RANGE type */
  UNS8		places;
  UNS8		method;         /* SCALE_METHOD type */

  UNS16		no_of_points;
  SCALE_POINT *	point_ptr;
  } SCALE;


#include "resint.h"
#include "tempc.h"
#include "light.h"
#include "tempintc.h"
#include "sndintw.h"
#include "soundl.h"
#include "voltsint.h"
#include "humidity.h"
#include "reed.h"
#include "conduct.h"
#include "oxygen.h"

static SCALE scale_details [] = {

 {	901, 1600, TRUE,
	"Resistance", "Ohms", "kOhm",
	0, 1000, OR_INVALID, 0, SM_LOOKUP,
	sizeof (sp_resint) / sizeof (sp_resint [0]), sp_resint},

 {	902, 1500, TRUE,
	"Voltage", "Volts", "mV",
	0, 5000, OR_INVALID, 0, SM_LOOKUP,
	sizeof (sp_voltsint) / sizeof (sp_voltsint [0]), sp_voltsint},

 {	903, 1300, FALSE,
	"Sound Level", "SndL", "dBA",
	500, 1000, OR_TRUNCATE, 1, SM_LOOKUP,
	sizeof (sp_soundl) / sizeof (sp_soundl [0]), sp_soundl},

 {	904, 1200, TRUE,
	"Sound Waveform", "Sound", "",
	-1000, 1000, OR_INVALID, 1, SM_LOOKUP,
	sizeof (sp_sndintw) / sizeof (sp_sndintw [0]), sp_sndintw},

 {	905, 1400, FALSE,
	"pH", "pH", "",
	0, 1400, OR_INVALID, 2, SM_PH,
	0, NULL},

 {	906, 1100, FALSE,
	"Temperature", "Temp", "C",
	0, 1000, OR_INVALID, 1, SM_TEMP,
	sizeof (sp_tempintc) / sizeof (sp_tempintc [0]), sp_tempintc},

 {	907, 1000, TRUE,
	"Light", "Light", "",
	0, 1000, OR_INVALID, 1, SM_LOOKUP,
	sizeof (sp_light) / sizeof (sp_light [0]), sp_light},

 {	908, 330, FALSE,
	"Temperature", "Temp", "C",
	0, 1000, OR_INVALID, 1, SM_TEMP,
	sizeof (sp_tempc) / sizeof (sp_tempc [0]), sp_tempc},

 {	909, 2000, FALSE,
	"Detect", "Det", "kOhm",
	0, 2000, OR_INVALID, 0, SM_DETECT,
	0 , NULL},

 {	910, 150, FALSE,
	"Humidity", "Hum", "%",
	0, 1000, OR_INVALID, 1, SM_LOOKUP,
	sizeof (sp_humidity) / sizeof (sp_humidity [0]), sp_humidity},

 {	911, 120, FALSE,
	"Reed switch", "Reed", "%",
	0, 100, OR_INVALID, 0, SM_LOOKUP,
	sizeof (sp_reed) / sizeof (sp_reed [0]), sp_reed},

 {	912, 110, FALSE,
	"Conductivity", "Cond", "uS",
	0, 20000, OR_INVALID, 0, SM_LOOKUP,
	sizeof (sp_conduct) / sizeof (sp_conduct [0]), sp_conduct},

 {	913, 82, FALSE,
	"Oxygen", "O2", "%",
	0, 1000, OR_INVALID, 1, SM_LOOKUP,
	sizeof (sp_oxygen) / sizeof (sp_oxygen [0]), sp_oxygen},

};

#define MAX_SCALES (sizeof (scale_details) / sizeof (scale_details [0]))


/****************************************************************************
 *
 * Current channel scaling info
 *
 ****************************************************************************/

#define MEDIAN_WIDTH	5
static INT16		scale_nos [MAX_DRDAQ_CHANNELS+2];
static UNS16		median_counts [MAX_DRDAQ_CHANNELS+2];
static UNS16		median_filters [MAX_DRDAQ_CHANNELS+2] [MEDIAN_WIDTH];
static UNS16		resistances [MAX_DRDAQ_CHANNELS+2];
static INT16		temperature; /* current temperature - always celsius */
static UNS16		temp_channel = 6; /* channel to measure temp on (INT, EXT1, EXT2) */


static enum {
  TU_CELSIUS,
  TU_FAHRENHEIT,
  TU_KELVIN,
  TU_MAX} temp_units = TU_CELSIUS;

/****************************************************************************
 *
 * imd16 - do a 16-bit multiply/divide, via a 32-bit intermediate
 *
 ****************************************************************************/
INT16 imd16 (INT16 value, INT16 multiplier, INT16 divisor)
  {
  if (divisor == 0)
    {
    return INVALID_DRDAQ_SCALED;
    }
  else
    {
    return (INT16) (((INT32) value) * multiplier / divisor);
    }
  }

/************************************************************************
 *
 * Median Filter Routine
 *
 ************************************************************************/

long median_filter(UNS16 * values, unsigned short no_of_values)
{
   int i;
   int j;
   UNS16 sorted [MEDIAN_WIDTH];

   for( i = 0; i < no_of_values; ++i)
     {
     /* Insert next entry in numerical order
      */
     for(j = i; j > 0; j--)
       {
       /* This entry goes after new one,
        * so move it up one
        */
       if(sorted[j-1] > values [i])
         {
         sorted [j] = sorted [j-1];
	 }
       else
         {
         break;
         }

	}
      sorted [j] = values [i];
     }

   return sorted [(no_of_values)/2];   /* Return middle value */

}


/****************************************************************************
 *
 * update_scaling
 *
 * This routine checks whether it is necessary to update the scaling for this
 * channel
 *
 ****************************************************************************/

void drdaq_update_scaling (void * port_ptr, UNS8 channel)
  {
  static int	r_table [] = {330, 220, 150, 120, 110, 100, 91, 82, 75, 68, 62, 56, 51, 47, 43, 39, 36, 33, 30, 27, 24, 22, 20, 18, 16, 15, 13, 11, 10, 7, 5, 3, 2, 1};
  int		s;
  UNS16		resistance;
  UNS32		measured;
  int		r;
  int		i;
  int		value;

  /* Check the resistance defined for this channel
   * If it's zero, read the resistance from the EXT1/EXT2 port
   */
  resistance = channel_details [channel-1].resistor;

  if (resistance == 0)
    {
    /*  EXT1 or EXT2...
     * Take a reading from the resistance channel
     */
    adc11_v2_get_value (port_ptr, channel_details [channel-1].channel+1);
    value = adc11_v2_get_value (port_ptr, channel_details [channel-1].channel+1);

    if (median_counts [channel] < MEDIAN_WIDTH)
      {
      median_filters [channel] [median_counts [channel]++] = value;
      }
    else
      {
      for (i = 0; i < MEDIAN_WIDTH-1; i++)
	{
	median_filters [channel] [i] = median_filters [channel] [i+1];
	}
      median_filters [channel] [i] = value;
      }

    value = median_filter (median_filters [channel], median_counts [channel]);

    if (value < 4000)
      {
      /* Find the nearest match
       */
      measured = (value * 100L) / (MAX_DRDAQ_VALUE - value);
      resistance = 1000;
      for (r = 0; r < sizeof (r_table) / sizeof (r_table [0]); r++)
	{
	if (labs (r_table [r] - measured) < labs (resistance - measured))
	  {
	  resistance = r_table [r];
	  }
	}
      }
    else
      {
      resistance = 10000;
      }
    }

  /* If the resistance has changed,
   *  select the first matching sensor
   *
   * Note: we forced old resistance to zero first time round,
   *  so this always does something first time
   */
  if (resistance != resistances [channel-1])
    {
    resistances [channel-1] = resistance;

    scale_nos [channel-1] = -1;
    for (s = 0; s < MAX_SCALES; s++)
      {
      if (scale_details [s].resistor == resistance)
	{
	scale_nos [channel-1] = s;
	break;
	}
      }
    }
  }

/****************************************************************************
 *
 * update_temperature = update the temperature used for pH measurements
 *
 ****************************************************************************/
void update_temperature (void * port_ptr)
  {
  UNS16		tu_save;
  int		value;

  adc11_v2_get_value (port_ptr, channel_details [temp_channel-1].channel);
  value = adc11_v2_get_value (port_ptr, channel_details [temp_channel-1].channel);

  /* Force the temperature units to celsius
   *  while we convert the temp
   */
  tu_save = temp_units;
  temp_units = TU_CELSIUS;
  temperature = convert_to_scaled (value, temp_channel);
  temp_units = tu_save;

  }

/****************************************************************************
 *
 * forward_lookup - convert raw value to scaled
 *
 ****************************************************************************/
static INT16 forward_lookup (SCALE * scale_ptr, UNS16 raw)
  {
  UNS16		raw1;
  UNS16		raw2;
  INT16		scaled1;
  INT16		scaled2;
  INT16		scaled = 0;
  int		lower;
  int		middle;
  int		upper;

  /* Find the two scale points straddling our raw value
   */
  lower = 0;
  upper = scale_ptr->no_of_points - 1;
  if (scale_ptr->point_ptr [upper].raw > scale_ptr->point_ptr [lower].raw)
    {
    while (upper - lower > 1)
      {
      middle = (upper + lower) / 2;
      if (raw > scale_ptr->point_ptr [middle].raw)
	{
	lower = middle;
	}
      else
	{
	upper = middle;
	}
      }
    raw1 = scale_ptr->point_ptr [lower].raw;
    raw2 = scale_ptr->point_ptr [upper].raw;
    scaled1 = scale_ptr->point_ptr [lower].scaled;
    scaled2 = scale_ptr->point_ptr [upper].scaled;
    }
  else
    {
    while (upper - lower > 1)
      {
      middle = (upper + lower) / 2;
      if (raw < scale_ptr->point_ptr [middle].raw)
	{
	lower = middle;
	}
      else
	{
	upper = middle;
	}
      }
    raw1 = scale_ptr->point_ptr [upper].raw;
    raw2 = scale_ptr->point_ptr [lower].raw;
    scaled1 = scale_ptr->point_ptr [upper].scaled;
    scaled2 = scale_ptr->point_ptr [lower].scaled;
    }

  /* Apply any out-of-range corrections
   */
  switch (scale_ptr->out_of_range)
    {
    case OR_INVALID:
    if (raw < raw1)
      {
      scaled = INVALID_DRDAQ_SCALED;
      }
    else if (raw > raw2)
      {
      scaled = INVALID_DRDAQ_SCALED;
      }
    else
      {
      scaled =  scaled1 + imd16 ( raw - raw1, scaled2 - scaled1,
						raw2 - raw1);
      }
    break;

    case OR_TRUNCATE:
    if (raw < raw1)
      {
      raw = raw1;
      }
    else if (raw > raw2)
      {
      raw = raw2;
      }
    scaled =  scaled1 + imd16 ( raw - raw1, scaled2 - scaled1,
						raw2 - raw1);
    break;


    case OR_EXTRAPOLATE:
    scaled =  scaled1 + imd16 ( raw - raw1, scaled2 - scaled1,
						raw2 - raw1);
    break;
    }

  return scaled;
  }


/****************************************************************************
 *
 * convert_to_scaled
 *
 ****************************************************************************/
INT16 convert_to_scaled (UNS16 raw, UNS16 channel)
  {
  SCALE * 	scale_ptr;
  INT16		scaled;
  INT16		normalised;

  if (scale_nos [channel-1] >= 0)
    {
    scale_ptr = &scale_details [scale_nos [channel-1]];
    switch (scale_ptr->method)
      {
      case SM_LOOKUP:
      scaled = forward_lookup (scale_ptr, raw);
      break;

      case SM_PH:
      /* Convert to value expected at 25C
       *  fixed point, 1 decimal place
       */
      normalised = imd16 (raw - 2048, 2981, 2731 + temperature);

      /* 577mV is 2048 counts
       * 59mV per pH at 25C
       * 2 decimal place result
       */
      scaled = 700 - imd16 (normalised, 4775, 10000);
      if (scaled < 0)
	{
	scaled = 0;
	}
      if (scaled > 1400)
	{
	scaled = 1400;
	}
      break;

      case SM_TEMP:
      scaled = forward_lookup (scale_ptr, raw);
      switch (temp_units)
	{
	case TU_CELSIUS:
	case TU_MAX: // default to deg C
	break;

	case TU_FAHRENHEIT:
	scaled = 320 + imd16 (scaled, 9, 5);
	break;

	case TU_KELVIN:
	scaled += 2731;
	break;
	}
      break;

      case SM_DETECT:
      if (raw < MAX_DRDAQ_VALUE-50)
	{
	scaled = (raw * 100L) / (MAX_DRDAQ_VALUE - raw);
	}
      else
	{
	scaled = 10000;
	}
      break;

      default:
      scaled = INVALID_DRDAQ_SCALED;
      break;
      }
    }
  else
    {
    scaled = INVALID_DRDAQ_SCALED;
    }

  return scaled;
  }

/****************************************************************************
 *
 * drdaq_get_value
 *
 ****************************************************************************/
int drdaq_get_value (void * port_ptr, int channel, int scale)
  {
  UNS16 	raw;
  INT16		scaled = 0;

  if ((channel >= 1) && (channel <= MAX_DRDAQ_CHANNELS+5))
    {
    update_temperature (port_ptr);
    
    drdaq_update_scaling (port_ptr, channel);
    adc11_v2_get_value (port_ptr, channel_details [channel-1].channel);
    raw = adc11_v2_get_value (port_ptr, channel_details [channel-1].channel);
    if (scale)
      scaled = convert_to_scaled (raw, channel);
    else
      scaled = raw;
    }
  return scaled;
  }

/****************************************************************************
 *
 * drdaq_initialise
 *
 ****************************************************************************/
void drdaq_initialise (void * port_ptr)
  {
  int	i;

  for (i = 1; i < 9; i++)
    {
    drdaq_update_scaling (port_ptr, i);
    }
  }

