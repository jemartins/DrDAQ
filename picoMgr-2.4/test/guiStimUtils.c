/*************************************************************

	This software was developed for
	iCanProgram Inc., Toronto, Canada

FILE:		guiStimUtils.c

DESCRIPTION:	
This file contains utility code for guiStim. 

AUTHOR:			R.D. Findlay

Revision history:
=======================================================
$Log: guiStimUtils.c,v $
Revision 1.2  2006/03/20 22:19:49  bobfcsoft
added START functionality

Revision 1.1  2006/03/15 20:26:22  bobfcsoft
added guiStim

=======================================================

*************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#include "picoMgrMsgs.h"

#define _ALLOC extern
#include "guiStim.h"
#undef _ALLOC

#include "guiStimProto.h"
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
