/*************************************************************

FILE:		picoMgrSimulatorUtils.c

DESCRIPTION:	
This file contains some utility modules for picoMgrSim. 

AUTHOR:			R.D. Findlay

-----------------------------------------------------------------------
    Copyright (C) 2006 DrDAQ Application Project

    This software is in the public domain.
    Permission to use, copy, modify, and distribute this software and its
    documentation for any purpose and without fee is hereby granted, 
    without any conditions or restrictions.
    This software is provided "as is" without express or implied warranty.

    If you discover a bug or add an enhancement here's how to reach us: 

	https://sourceforge.net/projects/drdaq
-----------------------------------------------------------------------
Revision history:
=======================================================
$Log: picoMgrSimulatorUtils.c,v $
Revision 1.11  2010/02/23 16:42:42  jemartins
added new case X

Revision 1.10  2010/02/23 15:09:55  jemartins
added new XY parameter

Revision 1.9  2006/05/27 12:29:10  jemartins
added include drdaqMsgs.h

Revision 1.8  2006/05/15 20:28:36  jemartins
added new vars

Revision 1.7  2006/05/15 18:20:06  jemartins
added Copyright

Revision 1.6  2006/05/06 13:28:50  jemartins
removed sintax error

Revision 1.5  2006/05/04 21:20:55  jemartins
added new cases in parseSTART

Revision 1.4  2006/05/04 16:57:00  bobfcsoft
added TMax to parseSTART

Revision 1.3  2006/05/03 21:32:31  bobfcsoft
added file option to stub

Revision 1.2  2006/03/22 23:15:15  bobfcsoft
added messaging framework

Revision 1.1  2006/03/15 20:14:09  bobfcsoft
seed code

=======================================================

*************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <string.h>

#include "drdaqMsgs.h"

#define _ALLOC extern
#include "picoMgrSimulator.h"
#undef _ALLOC

#include "picoMgrSimulatorProto.h"
#include "simplProto.h"
#include "loggerProto.h"


/*=========================================
	parsefile - entry point
=========================================*/
int parsefile(char *myfile)
{
static char *fn="parsefile";
int rc=0;
char fullfile[256];
FILE *fp;
char line[80];
char *p;

#if 0
fcLogx(__FILE__, fn,
	globalMask,
	RECV_SIM_FUNC_IO,
	"file=<%s>",
	myfile
	);
#endif

sprintf(fullfile,"%s/%s",myPath,myfile);

#if 0
printf("%s:fullfile=<%s>\n",fn,fullfile);
#endif

fp=fopen(fullfile,"r");
if(fp == NULL)
	{
#if 0
	fcLogx(__FILE__, fn,
		RECV_SIM_MARK,
		"unable to open file=<%s>",
		fullfile
		);
#endif
printf("%s:unable to open file=<%s>\n",fn,fullfile);
	rc=-1;
	}
else
	{
	while(fgets(line,79,fp))
		{
		line[strlen(line)-1]=0; // get rid of CR
		p=skipOverWhiteSpace(line);

#if 0
		fcLogx(__FILE__, fn,
			globalMask,
			RECV_SIM_MISC,
			"line=%s",
			line
			);

		fcLogx(__FILE__, fn,
			globalMask,
			RECV_SIM_MISC,
			"p=%s",
			p
			);
#endif

		switch(line[0])
			{
			case 't':	// token
				if(p[0] == 'S') // START
					rc=parseSTART(fp);
				break;

			default:
				break;
			}
		}
	fclose(fp);
	}


#if 0
fcLogx(__FILE__, fn,
	globalMask,
	RECV_SIM_FUNC_IO,
	"rc=%d",
	rc
	);
#endif

return(rc);
}// end parsefile

/*=========================================
	parseSTART - entry point
=========================================*/
int parseSTART(FILE *fp)
{
static char *fn="parseSTART";
char line[80];
char *p;
PICO_START_MSG *outMsg;
int rc=-1;

fcLogx(__FILE__, fn,
	globalMask,
	RECV_SIM_FUNC_IO,
	"ding");

memset ( outArea
       , 0x00
       , 8192
       );

rc=sizeof(PICO_START_MSG);

outMsg=(PICO_START_MSG *)outArea;
outMsg->token=PICO_READING_START;

while(fgets(line,79,fp) != NULL)
	{
     	line[strlen(line)-1]=0; /* get rid of CR */
      	p=skipOverWhiteSpace(line);

	switch(line[0])
		{
		case 'p':	// period
			outMsg->period=atoi(p);

			fcLogx(__FILE__, fn,
				globalMask,
				RECV_SIM_MISC,
				"period: %d msec",
				outMsg->period);
			break;

		case 'm':	// maxReadings
			outMsg->maxReadings=atoi(p);

			fcLogx(__FILE__, fn,
				globalMask,
				RECV_SIM_MISC,
				"maxReadings: %d",
				outMsg->maxReadings);
			break;

		case 'T':	// TMax
			outMsg->TMax=(float)atof(p);

			fcLogx(__FILE__, fn,
				globalMask,
				RECV_SIM_MISC,
				"TMax: %5.1f",
				outMsg->TMax);
			break;

		case 'n':	// nsensors
			outMsg->nsensors=atoi(p);

			fcLogx(__FILE__, fn,
				globalMask,
				RECV_SIM_MISC,
				"nsensors: %d",
				outMsg->nsensors);
			break;

                case 'S':  // Sensor 1 or 2
                    if(line[6] == '1')  // Sensor1
                    {
                        outMsg->Sensor1=atoi(p);
                    
                        fcLogx(__FILE__, fn,
                               globalMask,
                               RECV_SIM_MISC,
                               "Sensor1: %d",
                               outMsg->Sensor1);

                    }
                    else // Sensor2
                    {
                        outMsg->Sensor2=atoi(p);
                    
                        fcLogx(__FILE__, fn,
                               globalMask,
                               RECV_SIM_MISC,
                               "Sensor2: %d",
                               outMsg->Sensor2);

                    }
                    break;

		case 's':  // sensor(n_modo,n) or sensor(set_value,n)
			if(line[7] == 'n')  // n_modo
			{
				if(line[14] == '1') // n_modo,1
                                {
	                   		outMsg->sensor[0].n_modo=atoi(p);
                                
                                        fcLogx(__FILE__, fn,
                                            globalMask,
                                            RECV_SIM_MISC,
                                            "nmodo1: %d",
                                            outMsg->sensor[0].n_modo);
                                }
                                else
                                {
				    outMsg->sensor[1].n_modo=atoi(p); 
			
                                    fcLogx(__FILE__, fn,
                                        globalMask,
                                        RECV_SIM_MISC,
                                        "nmodo2: %d",
                                        outMsg->sensor[1].n_modo);
                                }
                        }
			else //set_value
			{
				if(line[17] == '1') // set_value,1
                                {
					outMsg->sensor[0].set_value=atoi(p);

                                        fcLogx(__FILE__, fn,
                                            globalMask,
                                            RECV_SIM_MISC,
                                            "set_value1: %d",
                                            outMsg->sensor[0].set_value);
                                }
				else
                                {
					outMsg->sensor[1].set_value=atoi(p); 
    
                                        fcLogx(__FILE__, fn,
                                            globalMask,
                                            RECV_SIM_MISC,
                                            "set_value2: %d",
                                            outMsg->sensor[1].set_value);
                                }
			}
			break;

		case 'P':	// n_passo
			outMsg->n_passo=atoi(p);

			fcLogx(__FILE__, fn,
				globalMask,
				RECV_SIM_MISC,
				"n_passo: %d",
				outMsg->n_passo);
			break;

		case 'A':	// AutoEscala
			outMsg->AutoEscala=atoi(p);

			fcLogx(__FILE__, fn,
				globalMask,
				RECV_SIM_MISC,
				"AutoEscala: %d",
				outMsg->AutoEscala);
			break;

		case 'x':	// xmax
			outMsg->xmax=(float)atof(p);

			fcLogx(__FILE__, fn,
				globalMask,
				RECV_SIM_MISC,
				"xmax: %5.1f",
				outMsg->xmax);
			break;

		case 'y':	// ymax
			outMsg->ymax=(float)atof(p);

			fcLogx(__FILE__, fn,
				globalMask,
				RECV_SIM_MISC,
				"ymax: %5.1f",
				outMsg->ymax);
			break;

		case 'M':  // maior, menor div x ou y
			if(line[1] == 'a')  // maior_div
			{
				if(line[9] == 'x') // maior_divx
                                {
					outMsg->maior_divx=(float)atof(p);

					fcLogx(__FILE__, fn,
						globalMask,
						RECV_SIM_MISC,
						"maior_divx: %5.1f",
						outMsg->maior_divx);

                                }
                                else // maior_divy
                                {
				        outMsg->maior_divy=(float)atof(p); 

				        fcLogx(__FILE__, fn,
                                            globalMask,
                                            RECV_SIM_MISC,
				            "maior_divy: %5.1f",
                                            outMsg->maior_divy);
                                }
			}
			else // menor_div
			{
				if(line[9] == 'x') // menor_divx
                                {
					outMsg->menor_divx=(float)atof(p);

					fcLogx(__FILE__, fn,
						globalMask,
						RECV_SIM_MISC,
						"menor_divx: %5.1f",
						outMsg->menor_divx);

                                }
                                else // menor_divy
                                {
					outMsg->menor_divy=(float)atof(p); 

					fcLogx(__FILE__, fn,
						globalMask,
						RECV_SIM_MISC,
						"menor_divy: %5.1f",
                                		outMsg->menor_divy);
                                }
			}
			break;

		case 'X':	// xy
			outMsg->XY=atoi(p);

			fcLogx(__FILE__, fn,
				globalMask,
				RECV_SIM_MISC,
				"XY: %d",
				outMsg->XY);
			break;

		default:
			break;
		}

	} // end while

fcLogx(__FILE__, fn,
	globalMask,
	RECV_SIM_FUNC_IO,
	"rc=%d",
	rc);

return(rc);

} // end parseSTART

/*=========================================
	skipOverWhiteSpace - entry point
=========================================*/
char *skipOverWhiteSpace(char *start)
{
char *p;

for(p=start; *p != 0 && *p != ' ' && *p != 0x09; p++);  // skip to whitespace
if(*p != 0)
	{
	for(; *p == ' ' || *p == 0x09; p++); // skip whitespace
	}

return(p);
}// end skipOverWhiteSpace

/*=========================================
	ioaOffset - entry point
=========================================*/
time_t ioaOffset()
{
struct tm t;
time_t stamp;

t.tm_year=1980-1900;
t.tm_mon=0;
t.tm_mday=1;
t.tm_hour=0;
t.tm_min=0;
t.tm_sec=0;
t.tm_isdst=0;

stamp=mktime(&t);

return(stamp);
}// end ioaOffset
