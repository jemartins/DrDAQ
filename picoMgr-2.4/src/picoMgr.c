/*=======================================================

	This software was developed by
	iCanProgram Inc., Toronto, Canada


FILE:		picoMgr.c

DESCRIPTION:	
This file contains main source for picoMgr.

AUTHOR:		R.D. Findlay

Revision history:
=======================================================
$Log: picoMgr.c,v $
Revision 1.3  2006/03/24 20:11:53  bobfcsoft
task b001 changes

Revision 1.2  2006/03/20 22:19:49  bobfcsoft
added START functionality

Revision 1.1  2006/03/13 20:45:39  bobfcsoft
separate Linux 2.4 version

Revision 1.1.1.1  2006/03/07 21:29:47  bobfcsoft
startup

=====================================================*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "picoMgrMsgs.h"

#define _ALLOC
#include "picoMgr.h"
#undef _ALLOC

#include "picoMgrProto.h"
#include "loggerProto.h"

/*--------------------------------------
	picoMgr - entry point
--------------------------------------*/
int main(int argc, char **argv)
{
static char *fn="picoMgr";
PICO_TOKEN *token;
char *fromWhom;
char *picoReaderPending=NULL;
int nbytes;

initialize(argc, argv);

token=(PICO_TOKEN *)inArea;
while(1)
	{
	nbytes = Receive(&fromWhom, inArea, 8192);

	switch(*token)
		{
		case PICO_WHAT_YA_GOT:
			{
			fcLogx(__FILE__, fn,
				globalMask,
				PICOMGR_MISC,
				"WHAT_YA_GOT");

			picoReaderPending=fromWhom;
			}
			break;

		case PICO_READING_START:
			{
			PICO_START_MSG *inMsg;


			inMsg=(PICO_START_MSG *)inArea;

			fcLogx(__FILE__, fn,
				globalMask,
				PICOMGR_MISC,
				"START period=%d msec maxReadings=%d",
				inMsg->period,
				inMsg->maxReadings);

			if(picoReaderPending != NULL) // picoReader is ready
				{
				Reply(picoReaderPending, inArea, nbytes);
				}

			Reply(fromWhom, NULL, 0);
			}
			break;

		case PICO_LED:
			{
			fcLogx(__FILE__, fn,
				globalMask,
				PICOMGR_MISC,
				"LED is currently %s",
				(ledState == 1) ? "on" : "off");

			if(ledState == 1) // its on
				{
				turnLedOff();
				ledState =0;
				}
			else
				{
				turnLedOn();
				ledState =1;
				}
			
			fcLogx(__FILE__, fn,
				globalMask,
				PICOMGR_MISC,
				"LED is now %s",
				(ledState == 1) ? "on" : "off");

			Reply(fromWhom, NULL, 0);
			}
			break;

		case PICO_TEMPERATURE:
			{
			PICO_TEMPERATURE_MSG *outMsg;
			int mytemp;

			mytemp=readTemperature();

			fcLogx(__FILE__, fn,
				globalMask,
				PICOMGR_MISC,
				"temperature=%d.%d",
				mytemp/10,
				mytemp%10);

			outMsg=(PICO_TEMPERATURE_MSG *)outArea;
			outMsg->token=PICO_TEMPERATURE;
			outMsg->temperature=mytemp;

			Reply(fromWhom, outArea, sizeof(PICO_TEMPERATURE_MSG));
			}
			break;

		default:
			fcLogx(__FILE__, fn,
				globalMask,
				PICOMGR_MISC,
				"unknown token=%d",
				*token);

			Reply(fromWhom,NULL,0);
			break;
		}
	} // end while

name_detach();

return(1);
}// end picoMgr
