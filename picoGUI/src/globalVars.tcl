#=============================================
#
#	globalVars.tcl
#
#=============================================
#########################################################################
#
#    Copyright (C) 2006 DrDAQ Application Project.
#
#   This software is in the public domain.
#    Permission to use, copy, modify, and distribute this software and its
#    documentation for any purpose and without fee is hereby granted,
#    without any conditions or restrictions.
#    This software is provided "as is" without express or implied warranty.
#
#    If you discover a bug or add an enhancement here's how to reach us:
#
#        https://sourceforge.net/projects/drdaq
#
##########################################################################

##########################################################################
# Revision history:
# 
# $Log: globalVars.tcl,v $
# Revision 1.11  2007/06/09 02:17:15  jemartins
# changes for ANGLE_CALIBRATE
#
# Revision 1.10  2006/06/22 14:03:01  jemartins
# added myID
#
# Revision 1.9  2006/05/26 20:22:38  jemartins
# *** empty log message ***
#
# Revision 1.8  2006/05/25 18:15:46  jemartins
# added new token
#
# Revision 1.7  2006/05/24 13:31:50  jemartins
# arrange in send msg
#
# Revision 1.6  2006/05/15 17:48:50  jemartins
# added Copyright
#
# Revision 1.5  2006/05/03 01:55:22  jemartins
# added -f entry
#
# Revision 1.3  2006/05/02 00:39:50  jemartins
# added myName as global var
#
# Revision 1.2  2006/05/01 23:37:13  jemartins
# added global vars entry
#
# Revision 1.1  2006/05/01 20:31:01  jemartins
# test guivTcl
#
# Revision 1.3  2006/04/26 15:05:46  jemartins
# changes to intercept STOP message
#
# Revision 1.2  2006/03/23 22:32:10  bobfcsoft
# code cleanup
#
# Revision 1.1.1.1  2006/03/07 21:29:31  bobfcsoft
# startup
#
#=============================================
global this 
global MASK_MISC 
global MASK_IO 
global PICO_LED_TOGGLE 
global PICO_TOKEN
global j 
global pendingEventFrom 
global logMask 
global logger 
global picoMgrID 
global myName 
global recvid
global myID

set this "picoGUI"
set MASK_MISC		1
set MASK_IO		2

set PICO_LED_TOGGLE	0x100

set PICO_TOKEN(PICO_WHAT_YA_GOT)	0
set PICO_TOKEN(PICO_SOUND_WAVEFORM)     1
set PICO_TOKEN(PICO_SOUND_LEVEL)        2
set PICO_TOKEN(PICO_VOLTAGE)            3
set PICO_TOKEN(PICO_RESISTANCE)         4
set PICO_TOKEN(PICO_PH)                 5
set PICO_TOKEN(PICO_TEMPERATURE)        6
set PICO_TOKEN(PICO_LIGHT)              7
set PICO_TOKEN(PICO_READING_START)      8
set PICO_TOKEN(PICO_READING_STOP)       9
set PICO_TOKEN(PICO_WHAT_READINGS)      10
set PICO_TOKEN(PICO_LED)                11
set PICO_TOKEN(PICO_ANGLE)              12
set PICO_TOKEN(PICO_ANGLE_CALIBRATE)	13

set j			1
set pendingEventFrom	-1

#
#=================== end globalVars ==================
#
