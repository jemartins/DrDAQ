/*************************************************************

FILE:		picoGUISimulator.c

DESCRIPTION:	
This program is the picoGUI place holder. 

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
$Log: picoGUISimulator.c,v $
Revision 1.3  2006/05/27 12:29:10  jemartins
added include drdaqMsgs.h

Revision 1.2  2006/05/25 19:46:09  jemartins
added case WHAT_READINGS

Revision 1.1  2006/04/25 21:34:30  bobfcsoft
GUI stub added

=======================================================

*************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <string.h>

#include "drdaqMsgs.h"

#define _ALLOC
#include "picoGUISimulator.h"
#undef _ALLOC

#include "picoGUISimulatorProto.h"
#include "simplProto.h"
#include "loggerProto.h"

/*--------------------------------------
	picoGUISimulator - entry point
--------------------------------------*/
int main(int argc, char **argv, char **envp)
{
static char *fn="picoGUISim";
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
				printf("picoGUISimulator commands:\n");
				printf("q - quit\n");
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
			case PICO_READING_STOP:
				{
				fcLogx(__FILE__, fn,
					globalMask,
					RECV_SIM_MISC,
					"STOP"
					);

				Reply(sender,NULL, 0);
				}
				break;

                        case PICO_WHAT_READINGS:
                        {
                            PICO_WHAT_READINGS_MSG *inMsg;
                            inMsg=(PICO_WHAT_READINGS_MSG *)inArea;
                            
                            fcLogx(__FILE__, fn,
                                    globalMask,
                                    RECV_SIM_MISC,
                                    "timer=%f reading=%f sensor=%d",
                                    inMsg->timer,
                                    inMsg->reading,
                                    inMsg->sensor                                    
                                    );
                        
                            Reply(sender,NULL, 0);
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

}// end picoGUISimulator
