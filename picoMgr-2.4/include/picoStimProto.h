
/*************************************************************
	This software was developed by
	iCanProgram Inc., Toronto, Canada

FILE:		picoStimProto.h

DESCRIPTION:	
This file contains prototypes used by picoStim.

AUTHOR:		R.D. Findlay

Revision history:
=======================================================
$Log: picoStimProto.h,v $
Revision 1.1  2006/03/13 20:45:38  bobfcsoft
separate Linux 2.4 version

Revision 1.1.1.1  2006/03/07 21:29:38  bobfcsoft
startup

=======================================================

*************************************************************/

#ifndef _PICO_STIM_PROTO_DEF
#define _PICO_STIM_PROTO_DEF

void initialize(int, char **);
void myUsage();

char *skipOverWhiteSpace(char *start);

#endif
