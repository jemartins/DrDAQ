/*************************************************************

	This software was developed for
	iCanProgram Inc., Toronto, Canada

FILE:		picoStim.c

DESCRIPTION:	
This program helps stimulate the picoMgr.

AUTHOR:			R.D. Findlay

Revision history:
=======================================================
$Log: picoStim.c,v $
Revision 1.2  2006/03/20 22:19:49  bobfcsoft
added START functionality

Revision 1.1  2006/03/13 20:45:40  bobfcsoft
separate Linux 2.4 version

Revision 1.1.1.1  2006/03/07 21:29:47  bobfcsoft
startup

=======================================================

*************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#include "picoMgrMsgs.h"

#define _ALLOC
#include "picoStim.h"
#undef _ALLOC

#include "picoStimProto.h"
#include "simplProto.h"
#include "loggerProto.h"

/*--------------------------------------
	picoStim - entry point
--------------------------------------*/
int main(int argc, char **argv)
{
static char *fn="picoStim";
int x_it=0;
char line[80];

initialize(argc, argv);

fcLogx(__FILE__, fn,
	globalMask,
	PICO_STIM_MARK,
	"starting"
	);

printf("-> ");
fflush(stdout);
while(!x_it)
	{
	inset = watchset;
	select(maxfd+1, &inset, NULL, NULL, NULL);

// Is this from keyboard
	if(FD_ISSET(my_fds[0], &inset))  //  keyboard is ready
		{
		fgets(line,80,stdin);

		switch(line[0])
			{
			case '?':
				printf("picoStim commands:\n");
				printf("t - temperature\n");
				printf("l - toggle LED\n");
				printf("w - what ya got\n");
				printf("q - quit\n");
				break;

			case 'l':
				{
				PICO_LED_MSG *outMsg;
		
				outMsg=(PICO_LED_MSG *)outArea;
				outMsg->token=PICO_LED;

				Send(picoMgrID, 
					outArea, 
					NULL, 
					sizeof(PICO_LED_MSG), 
					0);

				}
				break;

			case 't':
				{
				PICO_TEMPERATURE_MSG *outMsg;
				PICO_TEMPERATURE_MSG *inMsg;
		
				outMsg=(PICO_TEMPERATURE_MSG *)outArea;
				outMsg->token=PICO_TEMPERATURE;

				Send(picoMgrID, 
					outArea, 
					inArea, 
					sizeof(PICO_TEMPERATURE_MSG), 
					sizeof(PICO_TEMPERATURE_MSG));

				inMsg=(PICO_TEMPERATURE_MSG *)inArea;

				fcLogx(__FILE__, fn,
					globalMask,
					PICO_STIM_MISC,
					"temperature=%d",
					inMsg->temperature
					);

				printf("temperature %d.%d C\n",
					inMsg->temperature/10,
					inMsg->temperature%10);
				}
				break;

			case 'w':
				{
				PICO_WHAT_YA_GOT_MSG *outMsg;
				PICO_START_MSG *inMsg;
		
				printf("blocked pending START\n");
				fflush(stdout);

				outMsg=(PICO_WHAT_YA_GOT_MSG *)outArea;
				outMsg->token=PICO_WHAT_YA_GOT;

				Send(picoMgrID, 
					outArea, 
					inArea, 
					sizeof(PICO_WHAT_YA_GOT_MSG), 
					sizeof(PICO_START_MSG));

				inMsg=(PICO_START_MSG *)inArea;

				if(inMsg->token == PICO_READING_START)
					{
					fcLogx(__FILE__, fn,
						globalMask,
						PICO_STIM_MISC,
						"got READING_START period=%d msec maxReadings=%d",
						inMsg->period,
						inMsg->maxReadings
						);

					printf("got READING_START\n");
					printf("period=%d msec maxReadings=%d\n",
					inMsg->period,
					inMsg->maxReadings);

					} // end if READING_START

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

	} // end while

printf("end game\n");

fcLogx(__FILE__, fn,
	globalMask,
	PICO_STIM_MISC,
	"done");

name_detach();

exit(1);
}// end picoStim
