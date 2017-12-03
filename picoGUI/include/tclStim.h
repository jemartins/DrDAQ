/*=========================================
	tclStim.h

-------------------------
FCsoftware Inc. 1999
This code is released as open source.   We hope you find 
it useful.  If you discover a bug or add an enhancement 
we'd like to hear from you. 

	fcsoft@netcom.ca
-------------------------
 $Log: tclStim.h,v $
 Revision 1.1.1.1  2006/03/07 21:29:31  bobfcsoft
 startup

=========================================*/

#ifndef _TCLSTIM_DEF
#define _TCLSTIM_DEF

#include "loggerVars.h"

#define	MAX_MSG_BUFFER_SIZE		1024
#define TCLSTIM_MARK		0x00000001

_ALLOC unsigned int globalMask;

_ALLOC int toPid;

_ALLOC int my_fds[2];
_ALLOC int ctl;
_ALLOC fd_set watchset;
_ALLOC fd_set inset;

_ALLOC char data[1024];

_ALLOC char inArea[MAX_MSG_BUFFER_SIZE];
_ALLOC char outArea[MAX_MSG_BUFFER_SIZE];

#endif
