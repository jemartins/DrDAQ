/*************************************************************

FILE:		picoMgrSimulator.c

DESCRIPTION:	
This program is the picoMgr place holder. 

-----------------------------------------------------------------------
    Copyright (C) 2006 DrDAQ Application Project. 

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
$Log: picoMgrSimulator.c,v $
Revision 1.15  2010/02/23 15:09:55  jemartins
added new XY parameter

Revision 1.14  2007/06/07 00:45:42  jemartins
clean code

Revision 1.13  2007/06/07 00:01:18  jemartins
fix bugs

Revision 1.12  2007/06/06 22:46:28  jemartins
adjusted in PICO_ANGLE

Revision 1.11  2007/06/06 20:52:13  jemartins
adjusted ANGLE option

Revision 1.10  2006/05/27 12:29:10  jemartins
added include drdaqMsgs.h

Revision 1.9  2006/05/26 20:30:45  jemartins
*** empty log message ***

Revision 1.8  2006/05/24 14:31:32  jemartins
*** empty log message ***

Revision 1.7  2006/05/23 15:07:51  jemartins
added DO_READING_MSG

Revision 1.6  2006/05/19 23:02:36  jemartins
added new tokens

Revision 1.5  2006/05/19 22:41:26  jemartins
added new tokens

Revision 1.4  2006/05/13 17:12:18  jemartins
added timestamp

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

#define _ALLOC
#include "picoMgrSimulator.h"
#undef _ALLOC

#include "picoMgrSimulatorProto.h"
#include "simplProto.h"
#include "loggerProto.h"

/*--------------------------------------
	picoMgrSimulator - entry point
--------------------------------------*/
int main(int argc, char **argv, char **envp)
{
static char *fn="picoMgrSim";
int x_it=0;
char line[80];
char *picoReaderPending=NULL;
int mySoundLevel=234;
int myVoltage=234;
int myResistance=234;
int myPH=234;
int myTemperature=234;
int myLight=234;
float myAngle=23.4;
int stopFlag=0;

initialize(argc, argv);

if(!backgroundMode)
	{
	printf("-> ");
	fflush(stdout);
	}
while(!x_it)
	{
	inset = watchset;
	select(maxfd+1, &inset, NULL, NULL, NULL);

// Is this from keyboard
	if(FD_ISSET(my_fds[1], &inset))  //  keyboard is ready
		{
		fgets(line, 79, stdin);
		line[strlen(line)-1]=0; //get rid of CR

		switch(line[0])
			{
			case '?':	// help
				printf("picoMgrSimulator commands:\n");
				printf("f <filename> - use data file\n");
				printf("s <period> <max readings> - start readings\n");
				printf("h - stop readings\n");
				printf("q - quit\n");
				break;
			
			case 'f':
				{
				char *p;
				int sbytes;

				p=skipOverWhiteSpace(line); // start of period

				sbytes=parsefile(p);
				if(picoReaderPending != NULL)
					{
					Reply(picoReaderPending,outArea,sbytes);
					}
				}
				break;

			case 'h':
				stopFlag=1;
				break;

			case 's':
				{
				PICO_START_MSG *outMsg;
				char *p;

				outMsg=(PICO_START_MSG *)outArea;
				outMsg->token=PICO_READING_START;

				p=skipOverWhiteSpace(line); // start of period
				outMsg->period=atoi(p);
				
				p=skipOverWhiteSpace(p); // start of maxReadings
				outMsg->maxReadings=atoi(p);

				p=skipOverWhiteSpace(p); // start of XY
				outMsg->XY=atoi(p);

				if(picoReaderPending != NULL)
					{
					Reply(picoReaderPending,outArea,sizeof(PICO_START_MSG));
					}
				}
				break;

			case 'q':
				x_it=1;
				break;

			default:
				printf("%s: unknown keypress <%c>\n",
					fn,
					line[0]);
				break;
			} // end switch

		printf("-> ");
		fflush(stdout);
		} // end if keyboard
	else
// Is this from receive fifo
	if(FD_ISSET(my_fds[0], &inset))  //  receive is ready
		{
		int nbytes;			
		char *sender;
		UINT32 *token;

		token=(UINT32 *)inArea;

		nbytes = Receive(&sender, inArea, MAX_MSG_SIZE);

		fcLogx(__FILE__, fn,
			globalMask,
			RECV_SIM_MISC,
			"nbytes=%d",
			nbytes
			);


		switch(*token)
			{
			case PICO_WHAT_YA_GOT:
				{
				fcLogx(__FILE__, fn,
					globalMask,
					RECV_SIM_MISC,
					"WHAT_YA_GOT"
					);

				picoReaderPending = sender;
				stopFlag=0;
				}
				break;
 
                        case PICO_SOUND_LEVEL:
                            {
                            PICO_SOUND_LEVEL_MSG *outMsg;
                            PICO_DO_READING_MSG  *inMsg;

                            struct timeval	tv_now;
                            struct timezone tz_now;   // only needed to complete gettimeofday()
                            struct tm *now;   // only needed for trace log message
                            
                    
                            outMsg=(PICO_SOUND_LEVEL_MSG *)outArea;
                            inMsg=(PICO_DO_READING_MSG *)inArea;
                    
                            if(stopFlag == 0)
                            {
                                gettimeofday(&tv_now,  &tz_now);
                                now = localtime((time_t *)&tv_now.tv_sec);  // only needed for log below
                    
                                fcLogx(__FILE__, fn,
                                        globalMask,
                                        RECV_SIM_MISC,
                                        "temperature=%d.%d at %02d%02d%02d.%03d",
                                        mySoundLevel/10,
                                        mySoundLevel%10,
                                        now->tm_hour,
                                        now->tm_min,
                                        now->tm_sec,
                                        (int)tv_now.tv_usec /1000  // covert to msec
                                        );

                                fcLogx(__FILE__, fn,
                                                globalMask,
                                                RECV_SIM_MISC,
                                                "set_value=%d",
                                                inMsg->set_value);


                                outMsg->token = PICO_SOUND_LEVEL;
                                outMsg->sound_level=mySoundLevel;
                                outMsg->mystamp.tv_sec=tv_now.tv_sec;
                                outMsg->mystamp.tv_usec=tv_now.tv_usec;
                                                                
                                        
                                mySoundLevel++;
                            }
                            else
                            {
                                outMsg->token = PICO_READING_STOP;
                            }
                                        
                            Reply(sender,outArea,sizeof(PICO_SOUND_LEVEL_MSG));
                        }
                        break;

                        case PICO_VOLTAGE:
                            {
                            PICO_VOLTAGE_MSG *outMsg;
                            PICO_DO_READING_MSG  *inMsg;

                            struct timeval	tv_now;
                            struct timezone tz_now;   // only needed to complete gettimeofday()
                            struct tm *now;   // only needed for trace log message
                                                
                                        
                            outMsg=(PICO_VOLTAGE_MSG *)outArea;
			    inMsg=(PICO_DO_READING_MSG *)inArea;
                                                            
                            if(stopFlag == 0)
                            {
                                gettimeofday(&tv_now,  &tz_now);
                                now = localtime((time_t *)&tv_now.tv_sec);  // only needed for log below
                                        
                                fcLogx(__FILE__, fn,
                                        globalMask,
                                        RECV_SIM_MISC,
                                        "voltage=%d at %02d%02d%02d.%03d",
                                        myVoltage,
                                        now->tm_hour,
                                        now->tm_min,
                                        now->tm_sec,
                                        (int)tv_now.tv_usec /1000  // covert to msec
                                        );
                                        
                                fcLogx(__FILE__, fn,
                                                globalMask,
                                                RECV_SIM_MISC,
                                                "set_value=%d",
                                                inMsg->set_value);

                                outMsg->token = PICO_VOLTAGE;
                                outMsg->voltage=myVoltage;
                                outMsg->mystamp.tv_sec=tv_now.tv_sec;
                                outMsg->mystamp.tv_usec=tv_now.tv_usec;
                                                                                    
                                                            
                                myVoltage++;
                            }
                            else
                            {
                                outMsg->token = PICO_READING_STOP;
                            }
                                                            
                            Reply(sender,outArea,sizeof(PICO_VOLTAGE_MSG));
                        }
                        break;

                        case PICO_ANGLE:
                            {
                            PICO_ANGLE_MSG *outMsg;
                            PICO_DO_READING_MSG  *inMsg;

                            struct timeval	tv_now;
                            struct timezone tz_now;   // only needed to complete gettimeofday()
                            struct tm *now;   // only needed for trace log message
                                                
                                        
                            outMsg=(PICO_ANGLE_MSG *)outArea;
			    inMsg=(PICO_DO_READING_MSG *)inArea;
                                                            
                            if(stopFlag == 0)
                            {
                                gettimeofday(&tv_now,  &tz_now);
                                now = localtime((time_t *)&tv_now.tv_sec);  // only needed for log below
                                        
                                fcLogx(__FILE__, fn,
                                        globalMask,
                                        RECV_SIM_MISC,
                                        "angle=%f at %02d%02d%02d.%03d",
                                        myAngle,
                                        now->tm_hour,
                                        now->tm_min,
                                        now->tm_sec,
                                        (int)tv_now.tv_usec /1000  // covert to msec
                                        );
                                        
                                fcLogx(__FILE__, fn,
					globalMask,
					RECV_SIM_MISC,
					"set_value=%d sensor=%d"  ,
					inMsg->set_value,
					inMsg->sensor
					);

                                outMsg->token=PICO_ANGLE;
                                outMsg->angle=myAngle;
                                outMsg->mystamp.tv_sec=tv_now.tv_sec;
                                outMsg->mystamp.tv_usec=tv_now.tv_usec;
                                                                                    
                                                            
                                myAngle++;
                            }
                            else
                            {
                                outMsg->token = PICO_READING_STOP;
                            }
                                                            
                            Reply(sender,outArea,sizeof(PICO_VOLTAGE_MSG));
                        }
                        break;
                    
                        case PICO_PH:
                        {
                            PICO_PH_MSG *outMsg;
							PICO_DO_READING_MSG  *inMsg;

                            struct timeval	tv_now;
                            struct timezone tz_now;   // only needed to complete gettimeofday()
                            struct tm *now;   // only needed for trace log message
                                                                    
                                                            
                            outMsg=(PICO_PH_MSG *)outArea;
							inMsg=(PICO_DO_READING_MSG *)inArea;
                                                            
                            if(stopFlag == 0)
                            {
                                gettimeofday(&tv_now,  &tz_now);
                                now = localtime((time_t *)&tv_now.tv_sec);  // only needed for log below
                                                            
                                fcLogx(__FILE__, fn,
                                        globalMask,
                                        RECV_SIM_MISC,
                                        "PH=%d at %02d%02d%02d.%03d",
                                        myPH,
                                        now->tm_hour,
                                        now->tm_min,
                                        now->tm_sec,
                                        (int)tv_now.tv_usec /1000  // covert to msec
                                        );
                            
                                fcLogx(__FILE__, fn,
                                                globalMask,
                                                RECV_SIM_MISC,
                                                "set_value=%d",
                                                inMsg->set_value);

                                outMsg->token = PICO_PH;
                                outMsg->ph=myPH;
                                outMsg->mystamp.tv_sec=tv_now.tv_sec;
                                outMsg->mystamp.tv_usec=tv_now.tv_usec;
                                                                                                        
                                                                                
                                myPH++;
                            }
                            else
                            {
                                outMsg->token = PICO_READING_STOP;
                            }
                                                                                
                            Reply(sender,outArea,sizeof(PICO_PH_MSG));
                        }
                        break;
       
                        case PICO_RESISTANCE:
                            {
                            PICO_RESISTANCE_MSG *outMsg;
							PICO_DO_READING_MSG  *inMsg;

                            struct timeval	tv_now;
                            struct timezone tz_now;   // only needed to complete gettimeofday()
                            struct tm *now;   // only needed for trace log message
                                                                    
                                                            
                            outMsg=(PICO_RESISTANCE_MSG *)outArea;
							inMsg=(PICO_DO_READING_MSG *)inArea;
                                                            
                            if(stopFlag == 0)
                            {
                                gettimeofday(&tv_now,  &tz_now);
                                now = localtime((time_t *)&tv_now.tv_sec);  // only needed for log below
                                                            
                                fcLogx(__FILE__, fn,
                                        globalMask,
                                        RECV_SIM_MISC,
                                        "voltage=%d at %02d%02d%02d.%03d",
                                        myResistance,
                                        now->tm_hour,
                                        now->tm_min,
                                        now->tm_sec,
                                        (int)tv_now.tv_usec /1000  // covert to msec
                                        );
                            
                                fcLogx(__FILE__, fn,
                                                globalMask,
                                                RECV_SIM_MISC,
                                                "set_value=%d",
                                                inMsg->set_value);

                                outMsg->token = PICO_RESISTANCE;
                                outMsg->resistance=myResistance;
                                outMsg->mystamp.tv_sec=tv_now.tv_sec;
                                outMsg->mystamp.tv_usec=tv_now.tv_usec;
                                                                                                        
                                                                                
                                myResistance++;
                            }
                            else
                            {
                                outMsg->token = PICO_READING_STOP;
                            }
                                                                                
                            Reply(sender,outArea,sizeof(PICO_RESISTANCE_MSG));
                        }
                        break;
                        
                        case PICO_TEMPERATURE:
                                {
								PICO_TEMPERATURE_MSG *outMsg;
                                PICO_DO_READING_MSG  *inMsg;

                                struct timeval	tv_now;
                                struct timezone tz_now;   // only needed to complete gettimeofday()
                                struct tm *now;   // only needed for trace log message
				
                                outMsg=(PICO_TEMPERATURE_MSG *)outArea;
								inMsg=(PICO_DO_READING_MSG *)inArea;
				
                                if(stopFlag == 0)
                                {
                                    gettimeofday(&tv_now,  &tz_now);
                                    now = localtime((time_t *)&tv_now.tv_sec);  // only needed for log below

                                    fcLogx(__FILE__, fn,
                                        globalMask,
                                        RECV_SIM_MISC,
                                        "temperature=%d.%d at %02d%02d%02d.%03d",
                                        myTemperature/10,
                                        myTemperature%10,
                                        now->tm_hour,
                                        now->tm_min,
                                        now->tm_sec,
                                        (int)tv_now.tv_usec /1000  // covert to msec
                                        );

                                    fcLogx(__FILE__, fn,
                                            globalMask,
                                            RECV_SIM_MISC,
                                            "set_value=%d",
                                            inMsg->set_value);

                                    outMsg->token = PICO_TEMPERATURE;
                                    outMsg->temperature=myTemperature;
                                    outMsg->mystamp.tv_sec=tv_now.tv_sec;
                                    outMsg->mystamp.tv_usec=tv_now.tv_usec;
                                            
                    
                                    myTemperature++;
                                }
                                else
                                {
                                    outMsg->token = PICO_READING_STOP;
                                }
                    
                                Reply(sender,outArea,sizeof(PICO_TEMPERATURE_MSG));
                                }
                                break;
            
                        case PICO_LIGHT:
                            {
                            PICO_LIGHT_MSG *outMsg;
							PICO_DO_READING_MSG  *inMsg;

                            struct timeval	tv_now;
                            struct timezone tz_now;   // only needed to complete gettimeofday()
                            struct tm *now;   // only needed for trace log message
                                                                    
                            outMsg=(PICO_LIGHT_MSG *)outArea;
							inMsg=(PICO_DO_READING_MSG *)inArea;
                                        
                            if(stopFlag == 0)
                            {
                                gettimeofday(&tv_now,  &tz_now);
                                now = localtime((time_t *)&tv_now.tv_sec);  // only needed for log below
                                        
                                fcLogx(__FILE__, fn,
                                        globalMask,
                                        RECV_SIM_MISC,
                                        "light=%d.%d at %02d%02d%02d.%03d",
                                        myLight/10,
                                        myLight%10,
                                        now->tm_hour,
                                        now->tm_min,
                                        now->tm_sec,
                                        (int)tv_now.tv_usec /1000  // covert to msec
                                        );
        
                                fcLogx(__FILE__, fn,
                                                globalMask,
                                                RECV_SIM_MISC,
                                                "set_value=%d",
                                                inMsg->set_value);

                                outMsg->token = PICO_LIGHT;
                                outMsg->light=myLight;
                                outMsg->mystamp.tv_sec=tv_now.tv_sec;
                                outMsg->mystamp.tv_usec=tv_now.tv_usec;
                                                                                    
                                                            
                                myLight++;
                            }
                            else
                            {
                                outMsg->token = PICO_READING_STOP;
                            }
                                                            
                            Reply(sender,outArea,sizeof(PICO_LIGHT_MSG));
                        }
                        break;

			case PICO_LED:
			{
				//printf("%s: light token=%d\n",fn,*token);
				Reply(sender,NULL,0);
			}
			break;

			default:
				printf("%s:unknown token=%d\n",fn,*token);
				Reply(sender,NULL,0);
				break;
			}
		} // end else receive is ready
	} // end while

fcLogx(__FILE__, fn,
	globalMask,
	RECV_SIM_MISC,
	"done");

name_detach();

exit(0);

}// end picoMgrSimulator
