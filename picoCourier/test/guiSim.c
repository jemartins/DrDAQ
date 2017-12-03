/*************************************************************

FILE:		guiSim.c

DESCRIPTION:	
This program is an example of a simulator process.
It will be used to simulate the gui in the courier 
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
$Log: guiSim.c,v $
Revision 1.1.1.1  2006/03/07 21:29:22  bobfcsoft
startup

Revision 1.4  2003/04/03 16:40:35  root
more warning cleanup

Revision 1.3  2003/04/03 16:39:18  root
fixed RedHat 7.x warnings

Revision 1.2  2002/12/03 21:16:32  root
v2.0 compatible

Revision 1.1  2002/12/03 19:14:37  root
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
#include "guiSim.h"
#undef _ALLOC

#include "guiSimProto.h"
#include "simplProto.h"
#include "loggerProto.h"

/*--------------------------------------
	guiSim - entry point
--------------------------------------*/
int main(int argc, char **argv, char **envp)
{
static char *fn="guiSim";
int x_it=0;
char line[80];

initialize(argc, argv);

fcLogx(__FILE__, fn,
	globalMask,
	GUI_SIM_MARK,
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
		fgets(line, 79, stdin);

		switch(line[0])
			{
			case '?':	// help
				printf("guiSim commands:\n");
printf("L - toggle the LED\n");
				printf("t <str> - courier test string\n");
				printf("q       - quit\n");

				printf("-> ");
				fflush(stdout);
				break;

			case 'L': //string
				{
				PICO_LED_MSG *outMsg;

				if(courierPending != NULL)
					{
					fcLogx(__FILE__, fn,
						globalMask,
						GUI_SIM_MISC,
						"PICO_LED_TOGGLE");

					outMsg=(PICO_LED_MSG *)outArea;
					outMsg->token=PICO_LED;

fcLogx(__FILE__, fn,
globalMask,
GUI_SIM_MISC,
"sending LED_TOGGLE to picoMgr via courier"
);
Reply(courierPending,
outArea,
sizeof(PICO_LED_MSG));
courierPending = NULL;
}
else
{
printf("courier busy\n");
printf("-> ");
fflush(stdout);
}
}
break;
			case 't':	//string
				{
				CR_TEST_MSG *outMsg;
				char str[80];

				if(courierPending != NULL)
					{
					sprintf(str,"%s",&line[2]);

					fcLogx(__FILE__, fn,
						globalMask,
						GUI_SIM_MISC,
						"TEST str=<%s>",
						str
						);

					outMsg=(CR_TEST_MSG *)outArea;

					outMsg->token=CR_TEST;
					sprintf(outMsg->toWhom,"%s",recv_name);
					sprintf(outMsg->str,"%s",str);

					fcLogx(__FILE__, fn,
						globalMask,
						GUI_SIM_MISC,
						"sending <%s> to recv via courier",
						outMsg->str
						);

					Reply(courierPending,
						outArea, 
						sizeof(CR_TEST_MSG));
					courierPending = NULL;
					}
				else
					{
					printf("courier busy\n");
					printf("-> ");
					fflush(stdout);
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
				printf("-> ");
				fflush(stdout);
				break;
			} // end switch

		} // end if keyboard
	else
// Is this from receive fifo
	if(FD_ISSET(my_fds[1], &inset))  //  receive is ready
		{
		int nbytes;			
		char *sender;
		UINT16 *token;

		token=(UINT16 *)inArea;

		nbytes = Receive(&sender, inArea, MAX_MSG_SIZE);

		switch(*token)
			{
			case CR_WHAT_YA_GOT:
				courierPending=sender;
				break;

			case CR_TEST_REPLY:
				{
				CR_TEST_MSG *inMsg;

				inMsg=(CR_TEST_MSG *)inArea;

				fcLogx(__FILE__, fn,
					globalMask,
					GUI_SIM_MISC,
					"TEST_REPLY str=<%s>",
					inMsg->str
					);

printf("%s:TEST_REPLY str=<%s>\n",
	fn,
	inMsg->str
	);
			
printf("-> ");
fflush(stdout);
				courierPending = sender;
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
	GUI_SIM_MISC,
	"done");

name_detach();

exit(0);

}// end guiSim
