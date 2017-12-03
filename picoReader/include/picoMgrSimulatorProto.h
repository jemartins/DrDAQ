/*************************************************************
FILE:	picoMgrSimulatorProto.h	

DESCRIPTION:	
This file contains prototypes for picoMgrSimulator app.

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
$Log: picoMgrSimulatorProto.h,v $
Revision 1.2  2006/05/03 21:32:31  bobfcsoft
added file option to stub

Revision 1.1  2006/03/22 23:15:09  bobfcsoft
added messaging framework

=======================================================

*************************************************************/

#ifndef _RECV_SIM_PROTO_DEF
#define _RECV_SIM_PROTO_DEF

void initialize(int, char **);
char *skipOverWhiteSpace(char *);
void myUsage();
time_t ioaOffset();
int parsefile(char *);
int parseSTART(FILE *);

#endif
