/*************************************************************

FILE:		receiverSim.c

DESCRIPTION:	
This program is an example of a receiver simulator. 
It is used for receiving messages from the courier 
SIMPL softwareIC.

AUTHOR:			R.D. Findlay

-----------------------------------------------------------------------
    Copyright (C) 2000, 2002 FCSoftware Inc. 

    This software is in the public domain.
    Permission to use, copy, modify, and distribute this software and its
    documentation for any purpose and without fee is hereby granted, 
    without any conditions or restrictions.
    This software is provided "as is" without express or implied warranty.

    If you discover a bug or add an enhancement here's how to reach us: 

	fcsoft@attcanada.ca
-----------------------------------------------------------------------
Revision history:
=======================================================
$Log: picoMgrSim.c,v $
Revision 1.1.1.1  2006/03/07 21:29:31  bobfcsoft
startup

Revision 1.4  2003/04/03 16:41:22  root
more warning cleanup

Revision 1.3  2003/04/03 16:38:01  root
fixed RedHat 7.x warnings

Revision 1.2  2002/12/03 21:17:12  root
v2.0 compatible

Revision 1.1  2002/12/03 19:14:59  root
Initial revision

=======================================================

*************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>

#include "picoCourierMsgs.h"
#include "picoMgrMsgs.h"

#define _ALLOC
#include "picoMgrSim.h"
#undef _ALLOC

#include "picoMgrSimProto.h"
#include "simplProto.h"
#include "loggerProto.h"

/*--------------------------------------
	receiverSim - entry point
--------------------------------------*/
int main(int argc, char **argv, char **envp)
{
static char *fn="recvSim";
int x_it=0;
char line[80];
int msgCount=0;

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
				printf("receiverSim commands:\n");
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
		UINT16 *token;

		token=(UINT16 *)inArea;

		nbytes = Receive(&sender, inArea, MAX_MSG_SIZE);

		switch(*token)
			{
			case PICO_LED:
				fcLogx(__FILE__, fn,
globalMask,
RECV_SIM_MISC,
"PICO_LED_TOGGLE");
				Reply(sender, NULL, 0);
				break;

			case CR_TEST:
				{
				CR_TEST_MSG *inMsg;
				CR_TEST_MSG *outMsg;

				inMsg=(CR_TEST_MSG *)inArea;

				fcLogx(__FILE__, fn,
					globalMask,
					RECV_SIM_MISC,
					"TEST str=<%s>",
					inMsg->str
					);

printf("%s:TEST str=<%s>\n",
	fn,
	inMsg->str
	);
			

				outMsg=(CR_TEST_MSG *)outArea;
				outMsg->token=CR_TEST_REPLY;
				sprintf(outMsg->str,"reply #%d",msgCount++);

				Reply(sender,outArea,sizeof(CR_TEST_MSG));
if(!backgroundMode)
	{
	printf("-> ");
	fflush(stdout);
	}
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

}// end receiverSim
