/*************************************************************

FILE:		picoMgrSimulatorUtils.c

DESCRIPTION:	
This file contains some utility modules for picoMgrSim. 

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
$Log: picoMgrSimulatorUtils.c,v $
Revision 1.2  2006/05/27 12:31:17  jemartins
added include drdaqMsgs.h

Revision 1.1  2006/03/23 22:32:11  bobfcsoft
code cleanup

Revision 1.2  2006/03/22 23:15:15  bobfcsoft
added messaging framework

Revision 1.1  2006/03/15 20:14:09  bobfcsoft
seed code

=======================================================

*************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>

#include "drdaqMsgs.h"

#define _ALLOC extern
#include "picoMgrSimulator.h"
#undef _ALLOC

#include "picoMgrSimulatorProto.h"
#include "simplProto.h"
#include "loggerProto.h"

/*=========================================
	skipOverWhiteSpace - entry point
=========================================*/
char *skipOverWhiteSpace(char *start)
{
char *p;

for(p=start; *p != 0 && *p != ' ' && *p != 0x09; p++);  // skip to whitespace
if(*p != 0)
	{
	for(; *p == ' ' || *p == 0x09; p++); // skip whitespace
	}

return(p);
}// end skipOverWhiteSpace

/*=========================================
	ioaOffset - entry point
=========================================*/
time_t ioaOffset()
{
struct tm t;
time_t stamp;

t.tm_year=1980-1900;
t.tm_mon=0;
t.tm_mday=1;
t.tm_hour=0;
t.tm_min=0;
t.tm_sec=0;
t.tm_isdst=0;

stamp=mktime(&t);

return(stamp);
}// end ioaOffset
