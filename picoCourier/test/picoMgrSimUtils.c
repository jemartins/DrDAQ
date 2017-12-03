/*************************************************************

FILE:		recvSimUtils.c

DESCRIPTION:	
This file contains some utility modules for receiverSim. 

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
$Log: picoMgrSimUtils.c,v $
Revision 1.1.1.1  2006/03/07 21:29:31  bobfcsoft
startup

Revision 1.2  2002/12/03 21:17:34  root
v2.0 compatible

Revision 1.1  2002/12/03 19:15:12  root
Initial revision

=======================================================

*************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>

#include "picoMgrMsgs.h"

#define _ALLOC extern
#include "picoMgrSim.h"
#undef _ALLOC

#include "picoMgrSimProto.h"
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
