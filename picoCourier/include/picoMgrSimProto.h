/*************************************************************
FILE:	recvSimProto.h	

DESCRIPTION:	
This file contains prototypes for receiverSim app.

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
$Log: picoMgrSimProto.h,v $
Revision 1.1.1.1  2006/03/07 21:29:22  bobfcsoft
startup

Revision 1.2  2002/12/03 21:15:08  root
v2.0 compatible

Revision 1.1  2002/12/03 19:14:12  root
Initial revision

=======================================================

*************************************************************/

#ifndef _RECV_SIM_PROTO_DEF
#define _RECV_SIM_PROTO_DEF

void initialize(int, char **);
char *skipOverWhiteSpace(char *);
void myUsage();

#endif
