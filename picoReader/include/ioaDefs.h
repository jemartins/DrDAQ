/*============================================
*	ioaDefs.h

-----------------------------------------------------------------------
    Copyright (C) 2004 IO Anywhere Library Project. 

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    If you discover a bug or add an enhancement here's how to reach us: 

	https://sourceforge.net/projects/ioanywhere

-----------------------------------------------------------------------
Revision history:
=======================================================
$Log: ioaDefs.h,v $
Revision 1.1  2006/03/15 20:14:08  bobfcsoft
seed code

Revision 1.8  2006/02/16 22:05:33  bobfcsoft
logger stuff

Revision 1.7  2005/08/08 19:15:46  bobfcsoft
added temperature functions

Revision 1.6  2005/08/08 13:19:33  bobfcsoft
enhancements

Revision 1.5  2005/04/28 13:26:01  bobfcsoft
more KWLUG changes

Revision 1.4  2005/04/21 19:49:48  bobfcsoft
KWLUG prep stuff

Revision 1.3  2004/08/18 13:57:00  bobfcsoft
some more functions added

Revision 1.2  2004/07/29 16:50:53  bobfcsoft
initWindow_IOA changes

Revision 1.1  2004/07/19 18:41:09  bobfcsoft
initial commit
.
q


============================================*/

#ifndef _API_DEFS
#define _API_DEFS

#include "standardTypes.h"

#define	MAX_MSG_SIZE		8192

#define	CLS_MSG			31
#define	BOX_MSG			32
#define	TEXT_MSG		33
#define	FONT_MSG		34
#define	SERIAL_MSG		35
#define	MODEM_MSG		36
#define	CONFIG_MSG		37
#define	IO_MSG			38
#define	PWM_MSG			39
#define	TOUCH_MSG		40
#define	MENU_CTRL_MSG		41
#define	MENU_LCD_MSG		42
#define	MENU_LCD_EVENT_MSG	43
#define	MENU_VIDEO_MSG		44
#define	MENU_VIDEO_EVENT_MSG	45
#define	KEYPAD_MSG		46
#define	RD_SERIAL_MSG		47
#define AD_MSG 			48 
#define	X10			49
#define	FOPEN_AD		50
#define	FREAD_AD		51

#define	FRAME_NONE			0
#define	FRAME_SINGLE		1
#define	FRAME_DOUBLE		2
#define	FRAME_FILL			0x10

// modem states
#define	READY_INT			0x01
#define	DIALING_INT			0x02
#define	CONNECTING_INT			0x04
#define	CONNECTED_INT			0x08
#define	DISCONNECTING_INT		0x10

// modem commands
#define	DIAL				0x01
#define	HANGUP			0x02
#define	MODEM_TEST			0x04
#define	QUERY				0x08

// IOA internal modem states
#define	DEAD				0x00
#define	READY				0x01
#define	CONNECTING			0x02
#define	ANSWERING			0x04
#define	CONNECTED			0x08
#define	DISCONNECTING			0x10
#define	HANGINGUP			0x11


#define MAX_TEXT_MSG_SIZE	512
#define MAX_SERIAL_MSG_SIZE	254


#if 0
// not yet supported
typedef struct
	{
	unsigned int token;
	int bank;
	float value[8];
	} USER_AD_MSG;
#endif

typedef struct
	{
	UINT16 token;
	UINT16 numrecs;
	char text[MAX_TEXT_MSG_SIZE];
	} XMIT_AD_LOG_MSG;

typedef struct
	{
	UINT16 bank;
	UINT16 filler;
	UINT32 stamp;
	UINT16 value[8];
	} AD_LOG_MSG;

typedef struct
	{
	UINT16 token;
	UINT16 bank;
	UINT16 value[8];
	} USER_AD_RAW_MSG;

typedef struct
	{
	UINT16	token;
	char label[32];
	UINT8 homeCode;
	UINT8 deviceCode;
	UINT16 action;
	} X10_MSG;

typedef struct
	{
	UINT16	token;
	UINT16	target_index;
	UINT16	r;
	UINT16	c;
	UINT16	r2;
	UINT16	c2;
	UINT16	attr;
	UINT16	frame;
	char		text[MAX_TEXT_MSG_SIZE];
	} USER_TEXT_MSG;

typedef struct
	{
	UINT16	token;
	UINT16	device_nbr;
	UINT16	channel_nbr;
	UINT16	length;
	UINT16	timeout;
	UINT16	type;
	char		msg[MAX_SERIAL_MSG_SIZE];
	} USER_SERIAL_MSG;

typedef struct
	{
	USER_SERIAL_MSG ser_msg;
	UINT16	command;
	char		reply_name[32];
	} USER_MODEM_MSG;

typedef struct
	{
	UINT16	token;
	UINT16	channel;
	UINT16	freq;
	UINT16	duty;
	UINT16	enable;
	} USER_PWM_MSG;

typedef struct
	{
	UINT16	token;
	char		string[80];
	} USER_TOUCH_MSG;

typedef struct
	{
	UINT16	token;
	char	mask[4];
	char	value[4];
	} USER_IO_MSG;

typedef struct
	{
	UINT16	token;
	UINT16	key_value;
	} USER_KEYPAD_MSG;

typedef struct
	{
	char		norm_menu[84];
	char		high_menu[84];
	char		function[32];
	char		target_ip[16];
	char		port[32];
	UINT16	key;
	UINT16	style;
	} MENU_TYPES;

typedef struct
	{
	UINT16	token;
	UINT16	page;
	char		title[32];
	UINT16	block_no;
	MENU_TYPES	item;
	} USER_MENU_MSG;

typedef struct
	{
	UINT16	token;
	UINT16	page;		// ?? is this needed ???
	char		menu_item[84];
	char		function[32];
	char		title[32];
	} EVENT_MENU_MSG;

#endif
