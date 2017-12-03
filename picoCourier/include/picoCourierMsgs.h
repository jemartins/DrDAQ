/*************************************************************
FILE:	courierMsgs.h	

DESCRIPTION:	
This file contains globals for courier SIMPL software IC. 

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
$Log: picoCourierMsgs.h,v $
Revision 1.1.1.1  2006/03/07 21:29:22  bobfcsoft
startup

Revision 1.2  2002/12/03 21:14:11  root
v2.0 compatible

Revision 1.1  2002/12/03 19:13:31  root
Initial revision

=======================================================

*************************************************************/

#ifndef _COURIER_MSGS_DEF
#define _COURIER_MSGS_DEF

#include "standardTypes.h"

typedef enum
	{
	CR_WHAT_YA_GOT,
	CR_TEST,
	CR_TEST_REPLY,
	CR_ERROR,
	MAX_COURIER_TOKENS
	}COURIER_TOKEN;

typedef struct
	{
	COURIER_TOKEN token; 	//CR_WHAT_YA_GOT
	}CR_WHAT_YA_GOT_MSG;

typedef struct
	{
	COURIER_TOKEN token; 	//CR_TEST, CR_TEST_REPLY
	char toWhom[20]; // SIMPL name
	char str[80];
	}CR_TEST_MSG;

typedef struct
	{
	COURIER_TOKEN token; 	//CR_ERROR
	}CR_ERROR_MSG;

#endif
