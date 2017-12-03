/*************************************************************
FILE:	picoMgrSimulator.h	

DESCRIPTION:	
This file contains globals for picoMgrSimulator app.

AUTHOR:			R.D. Findlay

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
$Log: picoMgrSimulator.h,v $
Revision 1.2  2006/05/03 21:32:30  bobfcsoft
added file option to stub

Revision 1.1  2006/03/22 23:15:09  bobfcsoft
added messaging framework

=======================================================

*************************************************************/

#ifndef _PICOMGR_SIM_DEFS
#define _PICOMGR_SIM_DEFS

#include "simpl.h"
#include "loggerVars.h"

#define MAX_MSG_SIZE	8192

// some parameters for trace logger (fclogger)
_ALLOC unsigned int globalMask;
#define RECV_SIM_MARK		0x00000001
#define RECV_SIM_FUNC_IO	0x00000002
#define RECV_SIM_MISC		0x00000010

// general globals
_ALLOC char myName[20];
_ALLOC char myPath[128];

// to enable keyboard access
_ALLOC int backgroundMode;
_ALLOC int fd;
_ALLOC int maxfd;
_ALLOC int my_fds[2];
_ALLOC fd_set watchset;
_ALLOC fd_set inset;

_ALLOC char inArea[MAX_MSG_SIZE];
_ALLOC char outArea[MAX_MSG_SIZE];

#endif
