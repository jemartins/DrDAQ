/*************************************************************
FILE:	guiSim.h	

DESCRIPTION:	
This file contains globals for guiSim app.

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
$Log: guiSim.h,v $
Revision 1.1.1.1  2006/03/07 21:29:22  bobfcsoft
startup

Revision 1.2  2002/12/03 21:14:34  root
v2.0 compatible

Revision 1.1  2002/12/03 19:13:51  root
Initial revision

=======================================================

*************************************************************/
#ifndef _GUI_SIM_DEFS
#define _GUI_SIM_DEFS

#include "simpl.h"
#include "loggerVars.h"

#define MAX_MSG_SIZE 	8192

// stuff to enable trace logger
_ALLOC unsigned int globalMask;
#define GUI_SIM_MARK		0x00000001
#define GUI_SIM_FUNC_IO		0x00000002
#define GUI_SIM_MISC		0x00000010

_ALLOC char recv_name[20];
_ALLOC char *courierPending;

// for keyboard access
_ALLOC int fd;
_ALLOC int maxfd;
_ALLOC int my_fds[2];
_ALLOC fd_set watchset;
_ALLOC fd_set inset;

_ALLOC char inArea[MAX_MSG_SIZE];
_ALLOC char outArea[MAX_MSG_SIZE];

#endif
