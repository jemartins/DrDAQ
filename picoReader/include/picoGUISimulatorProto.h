/*************************************************************
FILE:	picoGUISimulatorProto.h	

DESCRIPTION:	
This file contains prototypes for picoGUISimulator app.

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
$Log: picoGUISimulatorProto.h,v $
Revision 1.1  2006/04/25 21:33:36  bobfcsoft
GUI stub

=======================================================

*************************************************************/

#ifndef _PICOGUI_SIM_PROTO_DEF
#define _PICOGUI_SIM_PROTO_DEF

void initialize(int, char **);
char *skipOverWhiteSpace(char *);
void myUsage();

#endif
