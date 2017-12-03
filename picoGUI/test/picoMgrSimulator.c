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
Revision 1.12  2007/06/12 18:09:35  jemartins
bugs fixed

Revision 1.11  2007/06/11 18:58:19  jemartins
*** empty log message ***

Revision 1.10  2007/06/11 18:30:07  jemartins
*** empty log message ***

Revision 1.9  2006/05/27 12:31:17  jemartins
added include drdaqMsgs.h

Revision 1.8  2006/05/24 14:31:32  jemartins
*** empty log message ***

Revision 1.7  2006/05/19 21:13:16  jemartins
added n_passo

Revision 1.6  2006/05/06 23:32:58  jemartins
added new entrys in fclogx

Revision 1.5  2006/04/27 19:07:01  bobfcsoft
recheckin

Revision 1.4  2006/04/27 19:00:38  jemartins
*** empty log message ***

Revision 1.3  2006/04/26 17:40:31  bobfcsoft
added STOP to test stub

Revision 1.2  2006/04/21 21:56:51  jemartins
add case PICO_READING_STOP

Revision 1.1  2006/03/23 22:32:11  bobfcsoft
code cleanup

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
int main(int argc, char **argv)
{
static char *fn="picoMgrSim";
int x_it=0;
char line[80];

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

		switch(line[0])
			{
			case '?':	// help
				printf("picoMgrSimulator commands:\n");
				printf("s - issue a STOP to GUI\n");
				printf("q - quit\n");
				break;

			case 's':
				{
				PICO_STOP_MSG *outMsg;

// deferred this name_locate to give an opportunity for picoGUI
// to be brought up
				picoGuiID=name_locate(picoGuiName);

				if( picoGuiID != -1)
					{
				outMsg=(PICO_STOP_MSG *)outArea;
				outMsg->token=PICO_READING_STOP;

				Send(picoGuiID, 
					outArea, 
					NULL, 
					sizeof(PICO_STOP_MSG), 
					0);
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
			PICOMGR_SIM_MISC,
			"nbytes=%d",
			nbytes
			);


		switch(*token)
			{
			case PICO_READING_START:
				{
				PICO_START_MSG *inMsg;

				inMsg=(PICO_START_MSG *)inArea;
				fcLogx(__FILE__, fn,
					globalMask,
					PICOMGR_SIM_MISC,
					"START TMax=%5.2f sec period=%d msec maxReadings=%d nsensors=%d sensor(n_modo,1)=%d sensor(set_value,1)=%d sensor(n_modo,2)=%d sensor(n_modo,2)=%d",
					inMsg->TMax,
					inMsg->period,
					inMsg->maxReadings,
					inMsg->nsensors,
					inMsg->sensor[0].n_modo,
					inMsg->sensor[0].set_value,
					inMsg->sensor[1].n_modo
					);

					inMsg=(PICO_START_MSG *)inArea;
					fcLogx(__FILE__, fn,
							globalMask,
							PICOMGR_SIM_MISC,
							"sensor(set_value,2)=%d n_passo=%d AutoEscala=%d xmax=%5.1f ymax=%5.1f maior_divx=%5.1f menor_divx=%5.1f maior_divy=%5.1f menor_divy=%5.1f",
							inMsg->sensor[1].set_value,
							inMsg->n_passo,
							inMsg->AutoEscala,
							inMsg->xmax,
							inMsg->ymax,
							inMsg->maior_divx,
							inMsg->menor_divx,
							inMsg->maior_divy,
							inMsg->menor_divy
							);
                                					
					printf("START TMax=%5.2f sec period=%d msec maxReadings=%d nsensors=%d\n",
					inMsg->TMax,
					inMsg->period,
					inMsg->maxReadings,
					inMsg->nsensors);
					printf("-> ");
					fflush(stdout);
				}
				Reply(sender,NULL,0);
				break;

				case PICO_ANGLE_CALIBRATE:
				{
					PICO_ANGLE_CALIBRATE_MSG *inMsg;
					
					inMsg=(PICO_ANGLE_CALIBRATE_MSG *)inArea;                    
					
					int myID;
					float myangle;
					int mysensor;
					int myvalue;
			
					myID=inMsg->ID;
					myangle=inMsg->angle;
					mysensor=inMsg->sensor;
					myvalue=inMsg->set_value; 
					
					int myvoltage;
		
					//myvoltage=readVoltage(myvalue);
					myvoltage=555;
			
					calibrationArray[inMsg->index][inMsg->sensor].angle=myangle;
					calibrationArray[inMsg->index][inMsg->sensor].voltage=myvoltage;
					
					fcLogx(__FILE__, fn,
						globalMask,
						PICOMGR_SIM_MISC,
						"ID=%d index=%d angle=%f sensor=%d set_value=%d voltage=%d",
						inMsg->ID,
						inMsg->index,
						inMsg->angle,
						inMsg->sensor,
						inMsg->set_value,
						myvoltage	
						);

					Reply(sender,NULL,0);
				}
				break;

			case PICO_READING_STOP:
				{
//				PICO_STOP_MSG *inMsg;

//				inMsg=(PICO_STOP_MSG *)inArea;
				fcLogx(__FILE__, fn,
					globalMask,
					PICOMGR_SIM_MISC,
					"STOP Measurements"
					);

					printf("STOP Measurements\n");
					printf("-> ");
					fflush(stdout);
				}
				Reply(sender,NULL,0);
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
	PICOMGR_SIM_MISC,
	"done");

name_detach();

exit(0);

}// end picoMgrSimulator
