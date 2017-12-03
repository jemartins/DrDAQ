/*************************************************************

FILE:		picoGUISimulatorInit.c

DESCRIPTION:	
This file contains initialization routines for picoGUISim. 

AUTHOR:			R.D. Findlay

-----------------------------------------------------------------------
    Copyright (C) 2006 DrDAQ Application Project

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
$Log: picoGUISimulatorInit.c,v $
Revision 1.2  2006/05/31 14:05:33  jemartins
added drdaqMsgs.h

Revision 1.1  2006/04/25 21:34:30  bobfcsoft
GUI stub added

=======================================================

*************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <time.h>

#include "drdaqMsgs.h"

#define _ALLOC extern
#include "picoGUISimulator.h"
#undef _ALLOC

#include "picoGUISimulatorProto.h"
#include "simplProto.h"
#include "loggerProto.h"
#include "simplmiscProto.h"  // atoh

/*============================================
	initialize - entry point
============================================*/
void initialize(int argc, char **argv)
{
static char *fn="initialize";
int i;                          /* loop variable */
char loggerName[20];
int myslot=-1;

globalMask=0xff;
myName[0]=0;
backgroundMode=0;

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
			case 'b':
				backgroundMode=1;
				break;

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

// try to connect to trace logger
logger_ID = is_logger_upx(loggerName);

// arm the select routine
my_fds[0] = whatsMyRecvfd(); // receive fifo

FD_ZERO(&watchset);
FD_SET(my_fds[0], &watchset);

maxfd=0;
if(backgroundMode)
	{
	maxfd=my_fds[0];
	}
else
	{
	my_fds[1] = STDIN_FILENO;   // keyboard
	FD_SET(my_fds[1], &watchset);

	for(i=0; i<2; i++)
		if(maxfd < my_fds[i]) maxfd=my_fds[i];
	}

fcLogx(__FILE__, fn,
	0xff,
	RECV_SIM_MARK,
	"myName=<%s> myslot=%d",
	myName,
	myslot
	);

fcLogx(__FILE__, fn,
	0xff,
	RECV_SIM_MARK,
	"trace logger mask = 0x%04X",
	globalMask);

} /* end initialize */

/*===================================================
	myUsage - entry point
===================================================*/
void myUsage()
{
printf("====================== usage =============================\n");
printf(" usage for picoGUISimulator:\n");
printf("      picoGUISimulator -n <myName> <optionals>\n");
printf("      where optionals are:\n");
printf("        -m 0x<mask> - trace logger mask override\n");
printf("        -l <loggerName> - connect to trace logger\n");
printf("==========================================================\n");
}// end myUsage
