
/*************************************************************

FILE:		tclReceiverMsgs.h

DESCRIPTION:	
This file contains message and token definitions

AUTHOR:		R.D. Findlay

-------------------------
FCsoftware Inc. 1999
This code is released as open source.   We hope you find 
it useful.  If you discover a bug or add an enhancement 
we'd like to hear from you. 

	fcsoft@netcom.ca
-------------------------

Revision history:
=======================================================
$Log: tclReceiverMsgs.h,v $
Revision 1.1.1.1  2006/03/07 21:29:31  bobfcsoft
startup

=======================================================

*************************************************************/

#ifndef _TCLRECEIVER_MSGS_DEF
#define _TCLRECEIVER_MSGS_DEF

#include "standardTypes.h"   // for UINT16 etc

typedef enum
	{
	FC_TESTING=0xa0,
	FC_QUIT,
	MAX_TCL_RECEIVER_TOKENS
	}TCL_RECEIVER_TOKEN;

typedef struct
	{
	TCL_RECEIVER_TOKEN token;		// FC_TESTING
	char text[80];
	}FC_TESTING_MSG;

typedef struct
	{
	TCL_RECEIVER_TOKEN token;		// FC_QUIT
	}FC_QUIT_MSG;

#endif
