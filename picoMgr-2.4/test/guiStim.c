/*************************************************************

	This software was developed for
	iCanProgram Inc., Toronto, Canada

FILE:		guiStim.c

DESCRIPTION:	
This program helps stimulate the picoMgr.

AUTHOR:			R.D. Findlay

Revision history:
=======================================================
$Log: guiStim.c,v $
Revision 1.2  2006/03/20 22:19:49  bobfcsoft
added START functionality

Revision 1.1  2006/03/15 20:26:22  bobfcsoft
added guiStim

=======================================================

*************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#include "picoMgrMsgs.h"

#define _ALLOC
#include "guiStim.h"
#undef _ALLOC

#include "guiStimProto.h"
#include "simplProto.h"
#include "loggerProto.h"

/*--------------------------------------
	guiStim - entry point
--------------------------------------*/
int main(int argc, char **argv)
{
static char *fn="guiStim";
int x_it=0;
char line[80];
char *p;

initialize(argc, argv);

fcLogx(__FILE__, fn,
	globalMask,
	GUI_STIM_MARK,
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
				printf("guiStim commands:\n");
				printf("s <period> <maxReadings> - start readings\n");
				printf("h - stop readings\n");
				printf("q - quit\n");
				break;

			case 's':
				{
				PICO_START_MSG *outMsg;
		
				outMsg=(PICO_START_MSG *)outArea;
				outMsg->token=PICO_READING_START;


				p=skipOverWhiteSpace(line); // start of period
				outMsg->period=atoi(p);
				
				p=skipOverWhiteSpace(p); // start of maxReadings
				outMsg->maxReadings=atoi(p);

				Send(picoMgrID, 
					outArea, 
					NULL, 
					sizeof(PICO_START_MSG), 
					0);

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
	GUI_STIM_MISC,
	"done");

name_detach();

exit(1);
}// end guiStim
