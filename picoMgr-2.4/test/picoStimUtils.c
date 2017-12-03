/*************************************************************

	This software was developed for
	iCanProgram Inc., Toronto, Canada

FILE:		picoStimUtils.c

DESCRIPTION:	
This file contains utility code for picoStim. 

AUTHOR:			R.D. Findlay

Revision history:
=======================================================
$Log: picoStimUtils.c,v $
Revision 1.2  2006/03/20 22:19:49  bobfcsoft
added START functionality

Revision 1.1  2006/03/13 20:45:40  bobfcsoft
separate Linux 2.4 version

Revision 1.1.1.1  2006/03/07 21:29:47  bobfcsoft
startup

=======================================================

*************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#include "picoMgrMsgs.h"

#define _ALLOC extern
#include "picoStim.h"
#undef _ALLOC

#include "picoStimProto.h"
#include "simplProto.h"
#include "loggerProto.h"
#include "simplmiscProto.h"

/*=========================================
	skipOverWhiteSpace - entry point
=========================================*/
char *skipOverWhiteSpace(char *start)
{
char *p;

for(p=start; *p != 0 && *p != ' ' && *p != 0x09; p++);  // skip to whitespace
if(*p != 0)
	{
	*p=0;	// null terminate
	p++;
	for(; *p == ' ' || *p == 0x09; p++); // skip whitespace
	}

return(p);
}// end skipOverWhiteSpace
