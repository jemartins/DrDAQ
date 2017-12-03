/*======================================================

	This software was developed for
	iCanProgram Inc., Toronto, Canada

FILE:	picoMgr.h

DESCRIPTION:	
This file contains globals for picoMgr.

AUTHOR:		R.D. Findlay

Revision history:
=======================================================
$Log: picoMgr.h,v $
Revision 1.1  2006/03/13 20:45:38  bobfcsoft
separate Linux 2.4 version

Revision 1.1.1.1  2006/03/07 21:29:38  bobfcsoft
startup

======================================================*/

#ifndef _PICO_MGR_DEFS
#define _PICO_MGR_DEFS

#include "simpl.h"
#include "loggerVars.h"

_ALLOC unsigned int globalMask;
#define PICOMGR_MARK		0x00000001
#define PICOMGR_FUNC_IO		0x00000002
#define PICOMGR_MISC		0x00000010

_ALLOC char loggerName[20];

_ALLOC int toPid;
_ALLOC char toName[20];
_ALLOC char myMsg[80];

_ALLOC int picofd;
_ALLOC int ledState;
_ALLOC int digital_output;

_ALLOC char inArea[8192];
_ALLOC char outArea[8192];

#endif
