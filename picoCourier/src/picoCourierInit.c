/*************************************************************

FILE:		courierInit.c

DESCRIPTION:	
This file contains initialization code for 
courier SIMPL softwareIC. 

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
$Log: picoCourierInit.c,v $
Revision 1.1.1.1  2006/03/07 21:29:22  bobfcsoft
startup

Revision 1.2  2002/12/03 21:15:54  root
v2.0 compatible

Revision 1.1  2002/12/03 19:13:15  root
Initial revision

=======================================================

*************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#include "picoCourierMsgs.h"

#define _ALLOC extern
#include "picoCourier.h"
#undef _ALLOC

#include "picoCourierProto.h"
#include "simplProto.h"
#include "loggerProto.h"
#include "simplmiscProto.h"

/*============================================
	initialize - entry point
============================================*/
void initialize(int argc, char **argv)
{
static char *fn="initialize";
int i;                          /* loop variable */
char myName[20];
char loggerName[20];
char guiName[20];
char picoMgrName[20];
int myslot;

globalMask=0xff;
myName[0]=0;
guiName[0]=0;
picoMgrName[0]=0;

/*===============================================
  process command args
===============================================*/
for(i=1; i<=argc; ++i)
        {
        char *p = argv[i];

        if(p == NULL) continue;

        if(*p == '-')
                {
                switch(*++p)
                        {
                        case 'n':
                                for(;*p != 0; p++);
				sprintf(myName,"%s",++p);
				myslot=name_attach(myName, NULL);
				if(myslot == -1)
					{
					printf("%s: unable to attach as <%s>\n",
						fn,
						myName);

					exit(0);
					}
                                break;

			case 'g':
				{
				int j;

				if(*++p == 0) p++;
				sprintf(guiName,"%.19s",p);

				for(j=0; j<2; j++)  // try 3 times
					{
					guiID=name_locate(guiName);
					if(guiID != -1) break;
					printf("retrying nameLocate after 1sec sleep\n");
					sleep(1);
					}

				if(guiID == -1)
					{
					printf("%s: can't locate %s\n",
						fn,guiName);
					exit(0);
					}
				}
				break;

			case 'p':
				{
				int j;

				if(*++p == 0) p++;
				sprintf(picoMgrName,"%.19s",p);

				for(j=0; j<2; j++)  // try 3 times
					{
					picoMgrID=name_locate(picoMgrName);
					if(picoMgrID != -1) break;
					printf("retrying nameLocate after 1sec sleep\n");
					sleep(1);
					}

				if(picoMgrID == -1)
					{
					printf("%s: can't locate %s\n",
						fn,picoMgrName);
					exit(0);
					}
				}
				break;

			case 'l':
                                for(;*p != 0; p++);
				sprintf(loggerName,"%.19s",++p);
				break;

			case 'm':
				if(*++p == 0) p++;
				globalMask=atoh(&p[2]);  // skip 0x
				break;

                        default:
				printf("%s:unknown arg %s\n",fn, p);
                                break;
                        }/*end switch*/
                } /* end if *p */
        }/*end for i*/

// check for compulsory args
if(myName[0] == 0)
	{
	myUsage();
	exit(0);
	}

if(guiName[0] == 0)
	{
	myUsage();
	name_detach();
	exit(0);
	}

// try to connect to trace logger
logger_ID = is_logger_upx(loggerName);

fcLogx(__FILE__, fn,
	0xff,
	COURIER_MARK,
	"myName=<%s> myslot=%d",
	myName,
	myslot
	);

fcLogx(__FILE__, fn,
	0xff,
	COURIER_MARK,
	"guiName=<%s> guislot=%d",
	guiName,
	guiID
	);

fcLogx(__FILE__, fn,
	0xff,
	COURIER_MARK,
	"trace logger mask = 0x%04X",
	globalMask);

} /* end initialize */

/*===================================================
	myUsage - entry point
===================================================*/
void myUsage()
{
printf("====================== usage =============================\n");
printf(" usage for courier:\n");
printf("      courier -n <myName> -g <gui name> <optionals>\n");
printf("      where optionals are:\n");
printf("        -m 0x<mask> - trace logger mask override\n");
printf("        -l <loggerName> - connect to trace logger\n");
printf("==========================================================\n");
}// end myUsage
