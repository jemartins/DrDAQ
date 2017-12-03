/*************************************************************

FILE:		picoGUISimulatorUtils.c

DESCRIPTION:	
This file contains some utility modules for picoGUISim. 

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
$Log: picoGUISimulatorUtils.c,v $
Revision 1.2  2006/05/27 12:29:10  jemartins
added include drdaqMsgs.h

Revision 1.1  2006/04/25 21:34:30  bobfcsoft
GUI stub added

=======================================================

*************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>

#include "drdaqMsgs.h"

#define _ALLOC extern
#include "picoGUISimulator.h"
#undef _ALLOC

#include "picoGUISimulatorProto.h"
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

