
/*************************************************************
FILE:		picoMgrProto.h

DESCRIPTION:	
This file contains prototypes for picoMgr.

AUTHOR:		R.D. Findlay

Revision history:
=======================================================
$Log: picoMgrProto.h,v $
Revision 1.2  2006/03/24 20:11:53  bobfcsoft
task b001 changes

Revision 1.1  2006/03/13 20:45:38  bobfcsoft
separate Linux 2.4 version

Revision 1.1.1.1  2006/03/07 21:29:38  bobfcsoft
startup

=======================================================

*************************************************************/

#ifndef _PICOMGR_PROTO_DEF
#define _PICOMGR_PROTO_DEF

#include "standardTypes.h"

void initialize(int, char **);
void myUsage();

int turnLedOff();
int turnLedOn();
int readTemperature();

int drdaq_open(int);

int scale_temp(int);

#endif
