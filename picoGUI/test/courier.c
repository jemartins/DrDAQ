/*************************************************************

FILE:		courier.c

DESCRIPTION:	
This program is an example of a courier SIMPL softwareIC. 

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
$Log: courier.c,v $
Revision 1.1.1.1  2006/03/07 21:29:38  bobfcsoft
startup

Revision 1.3  2003/04/03 16:16:05  root
get rid of some RedHat 7.x warnings

Revision 1.2  2002/12/03 21:15:38  root
v2.0 compatible

Revision 1.1  2002/12/03 19:13:08  root
Initial revision

=======================================================

*************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#if 0
#include <fcntl.h>
#include <time.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/timeb.h>
#include <sys/time.h>
#endif

#include "courierMsgs.h"

#define _ALLOC
#include "courier.h"
#undef _ALLOC

#include "courierProto.h"
#include "simplProto.h"
#include "loggerProto.h"

/*===============================================
	courier - entry point
===============================================*/
int main(int argc, char **argv, char **envp)
{
static char *fn="courier";
int x_it=0;
UINT16 *token;
CR_WHAT_YA_GOT_MSG *outMsg;

initialize(argc, argv);

fcLogx(__FILE__, fn,
	globalMask,
	COURIER_MARK,
	"starting"
	);

token=(UINT16 *)inArea;

outMsg=(CR_WHAT_YA_GOT_MSG *)outArea;
outMsg->token = CR_WHAT_YA_GOT;

while(!x_it)
	{
	Send(guiID, outArea, inArea, sizeof(CR_WHAT_YA_GOT_MSG), MAX_MSG_SIZE);

	switch(*token)
		{
		case CR_TEST:
			{
			CR_TEST_MSG *inMsg;

			inMsg=(CR_TEST_MSG *)inArea;

			fcLogx(__FILE__, fn,
				globalMask,
				COURIER_MISC,
				"TEST recv name=<%s> str=<%s>",
				inMsg->toWhom,
				inMsg->str
				);

#if 0
printf("%s:TEST recv name=<%s> str=<%s>\n",
	fn,
	inMsg->toWhom,
	inMsg->str
	);
#endif

			if(memcmp(inMsg->toWhom,recv_name,strlen(inMsg->toWhom))!=0)
				{
				if(recvID != -1)
					{
					close(recvID);
					}

				recvID=name_locate(inMsg->toWhom);
				}

			if(recvID == -1)
				{
				CR_ERROR_MSG *outMsg;

				printf("%s: can't locate %s\n",
					fn,inMsg->toWhom);

				outMsg=(CR_ERROR_MSG *)outArea;
				outMsg->token = CR_ERROR;
				}
			else
				{
				Send(recvID, inArea, inArea, sizeof(CR_TEST_MSG), MAX_MSG_SIZE);
				}
			}
			break;

		default:
			{
			CR_ERROR_MSG *outMsg;

			fcLogx(__FILE__, fn,
				globalMask,
				COURIER_MARK,
				"unknown token=%d",
				*token
				);
			printf("%s:unknown token=%d\n",fn,*token);

			outMsg=(CR_ERROR_MSG *)outArea;
			outMsg->token = CR_ERROR;
			}
			break;
		}

	} // end while

fcLogx(__FILE__, fn,
	globalMask,
	COURIER_FUNC_IO,
	"done");

name_detach();

exit(0);
}// end courier
