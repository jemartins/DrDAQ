#########################################################################
## globalVars.tcl

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
# Revision 1.11  2007/06/06 18:36:14  jemartins
# added ANGLE case
#
# Revision 1.10  2006/09/11 13:51:52  jemartins
# added home var
#
# Revision 1.9  2006/07/23 23:35:31  jemartins
# cleanup
#
# Revision 1.8  2006/05/26 13:43:00  jemartins
# housekeeping
#
# Revision 1.7  2006/05/25 18:16:03  jemartins
# added new token
#
# Revision 1.6  2006/05/24 16:15:07  jemartins
# added SOUND_WAVEFORM
#
# Revision 1.5  2006/05/24 13:37:02  jemartins
# changes in InitGrace
#
# Revision 1.4  2006/05/18 18:09:18  jemartins
# added new tokens
#
# Revision 1.3  2006/05/15 18:02:12  jemartins
# added Copyright
#
# Revision 1.2  2006/05/04 13:52:53  jemartins
# added DRDAQ_MODE vars
#
# Revision 1.1  2006/03/22 23:15:13  bobfcsoft
# added messaging framework
#
# Revision 1.1  2006/03/15 20:14:08  bobfcsoft
# seed code
#
#========================================

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
set PICO_TOKEN(PICO_WHAT_READINGS)	10
set PICO_TOKEN(PICO_LED)                11
set PICO_TOKEN(PICO_ANGLE)              12

set DRDAQ_MODE(DRDAQ_SOUND_WAVEFORM)    1
set DRDAQ_MODE(DRDAQ_SOUND_LEVEL)       2
set DRDAQ_MODE(DRDAQ_VOLTAGE)           3
set DRDAQ_MODE(DRDAQ_RESISTANCE)        4
set DRDAQ_MODE(DRDAQ_PH)                5
set DRDAQ_MODE(DRDAQ_TEMPERATURE)       6
set DRDAQ_MODE(DRDAQ_LIGHT)             7
set DRDAQ_MODE(DRDAQ_ANGLE)             8

set MASK_MISC 1
set graf 0

set home $env(HOME)

