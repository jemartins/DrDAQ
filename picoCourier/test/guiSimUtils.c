/*************************************************************

FILE:		sendStimUtils.c

DESCRIPTION:	
This file contains utility code for senderStim app.

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
$Log: guiSimUtils.c,v $
Revision 1.1.1.1  2006/03/07 21:29:31  bobfcsoft
startup

Revision 1.2  2002/12/03 21:16:57  root
v2.0 compatible

Revision 1.1  2002/12/03 19:14:49  root
Initial revision

=======================================================

*************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#if 0
#include <fcntl.h>
#include <string.h>
#include <time.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/timeb.h>
#include <sys/time.h>
#endif

#include "fcMgrMsgs.h"

#define _ALLOC extern
#include "senderStim.h"
#undef _ALLOC

#include "sendStimProto.h"
#include "simplProto.h"
#include "loggerProto.h"
#include "simplmiscProto.h"

