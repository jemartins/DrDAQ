#=============================================
#
#	globalVars.tcl
#
#=============================================
# $Log: globalVars.tcl,v $
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
global this MASK_MISC MASK_IO PICO_LED_TOGGLE PICO_TOKEN
global j pendingEventFrom graf
global logMask logger picoMgrID myName

set this "picoGUI"
set MASK_MISC		1
set MASK_IO		2

set PICO_LED_TOGGLE	0x100

set PICO_TOKEN(PICO_READING_START)	3
set PICO_TOKEN(PICO_READING_STOP)	4

set j			1
set pendingEventFrom	-1

set graf		0

#
#=================== end globalVars ==================
#
