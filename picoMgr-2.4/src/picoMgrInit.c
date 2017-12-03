/*=====================================================

	This software was developed for
	iCanProgram Inc., Toronto, Canada

FILE:		picoMgrInit.c

DESCRIPTION:	
This file contains initialization code for picoMgr.

AUTHOR:		R.D. Findlay

Revision history:
=======================================================
$Log: picoMgrInit.c,v $
Revision 1.2  2006/03/24 20:11:53  bobfcsoft
task b001 changes

Revision 1.1  2006/03/13 20:45:39  bobfcsoft
separate Linux 2.4 version

Revision 1.1.1.1  2006/03/07 21:29:47  bobfcsoft
startup

=======================================================

=====================================================*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>

#include "pico_lnx.h"

#include "picoMgrMsgs.h"

#define _ALLOC extern
#include "picoMgr.h"
#undef _ALLOC

#include "picoMgrProto.h"
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
int myslot;
int value;

globalMask=0xff;
myName[0]=0;
loggerName[0]=0;
myMsg[0]=0;

#if 0
sprintf(myMsg,"hello there");
#endif

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


			case 'm':
                                for(;*p != 0; p++);
				p++;
				globalMask=atoh(&p[2]);
				break;

			case 'l':
                                for(;*p != 0; p++);
				sprintf(loggerName,"%.19s",++p);
				break;

                        default:
				printf("%s:unknown arg %s\n",fn, p);
                                break;
                        }/*end switch*/
                } /* end if *p */
        }/*end for i*/

// if manditory name is not supplied show usage
if(myName[0] == 0)
	{
	myUsage();
	exit(0);
	}

logger_ID = is_logger_upx(loggerName);

fcLogx(__FILE__, fn,
	PICOMGR_MARK,	// force it to log
	PICOMGR_MARK,
	"executable: <%s> cksum=%lu",
	argv[0],
	cksum(argv[0])
	);

fcLogx(__FILE__, fn,
	PICOMGR_MARK,	// force it to log
	PICOMGR_MARK,
	"SIMPL name: <%s> slot=%d",
	myName,
	myslot
	);

fcLogx(__FILE__, fn,
	PICOMGR_MARK,	// force it to log
	PICOMGR_MARK,
	"trace logger mask = 0x%04X",
	globalMask);

// default state of LED
ledState = 0;
turnLedOff();

// open the fd to driver
picofd=drdaq_open(0);

// set some stuff in driver
ioctl (picofd, IOCTL_PICO_GET_VERSION, &value);

fcLogx(__FILE__, fn,
	PICOMGR_MARK,	// force it to log
	PICOMGR_MARK,
  	"Kernel driver version %04x", value);

value = PRODUCT_DRDAQ;
ioctl (picofd, IOCTL_PICO_SET_PRODUCT, &value);

// Set scale adc
//value = SCALE_ADC;
value = SCALE_MV;
ioctl(picofd, IOCTL_PICO_SET_SCALE, &value);

// Set read mode to double
value = READ_MODE_DOUBLE;
ioctl(picofd, IOCTL_PICO_SET_READ_MODE, &value);

} /* end initialize */

/*===================================================
	myUsage - entry point
===================================================*/
void myUsage()
{
printf("======================= usage =====================================\n");
printf(" usage for picoMgr:\n");
printf("     picoMgr -n <myName> <optionals>\n");
printf("     where optionals are:\n");
printf("        -m 0xXX - set global mask\n");
printf("        -l <loggerName> - connect to trace logger\n");
printf("===================================================================\n");
}// end myUsage
