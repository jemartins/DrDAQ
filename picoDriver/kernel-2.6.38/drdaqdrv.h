/****************************************************************************
 *
 * Product:      PICO DrDaq
 *
 * Copyright 2001 - 2004 Pico Technology Limited
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, write to the Free Software
 *   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
 *
 *
 * Revision Info: "file %n date %f revision %v" *
 *                "file drdaqdrv.h date 11-Feb-95,17:40:10 revision 1"
 *
 *   M K Green   email: mike.green@picotech.com
 *               http: www.picotech.com
 *
 *                "file drdaqdrv.h date 06-Sep-04 revision 2"
 *   Thanks to J R Hunt, added support for kernel 2.6
 *
 *   J R Hunt    email: jrhunt at iee dot org
 *               http:  www.yoredale.uklinux.net
 *
 ****************************************************************************/ 
#ifndef _DRDAQDRH
#define _DRDAQDRH

#include <linux/kernel.h>       /* We're doing kernel work */
#include <linux/module.h>       /* Specifically, a module */

#include "pico_lnx.h"

// I can't find out where labs is defined for the kernel. As I understand it you cannot include <stdlib.h>
// in kernel modules.
//extern long int labs (long int __x);

/* 
 * inclui o define abaixo porque foi retirado do kernel.h
 * na versao 2.6.22.12 do kernel
 */
#define labs(x) ({                              \
		long __x = (x);                 \
		(__x < 0) ? -__x : __x;         \
		})

typedef unsigned char  BOOLEAN;
typedef unsigned long  UNS32;
typedef   signed long  INT32;
typedef unsigned short UNS16;
typedef signed   short INT16;
typedef unsigned char  UNS8;

#define MAX_DRDAQ_CHANNELS 	9
#define MAX_DRDAQ_VALUE	4095
#define INVALID_DRDAQ_SCALED -32768

#if defined (WIN95) || defined (WINNT) || defined (WINDOWS)
void read_scaling_files (HANDLE hInstance);
#else
void read_scaling_files (void);
#endif
void drdaq_update_scaling (void * port_ptr, UNS8 channel);
void update_temperature (void * port_ptr);
INT16 convert_to_scaled (UNS16 raw, UNS16 channel);
UNS16 convert_to_raw (INT16 scaled, UNS16 channel);

void drdaq_initialise (void * port_ptr);
int drdaq_get_value (void * port_ptr, int channel, int scale);
void drdaq_initialise (void * port_ptr);

#endif  //_DRDAQDRH
