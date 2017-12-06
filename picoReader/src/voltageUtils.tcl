#########################################################################
## Procedure:  processVoltage

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
# Revisions history:
#
# $Log: voltageUtils.tcl,v $
# Revision 1.11  2010/02/23 11:43:08  jemartins
# removed stdout
#
# Revision 1.10  2010/02/22 22:16:16  jemartins
# added case XY in doReadings
#
# Revision 1.9  2006/07/23 23:35:31  jemartins
# cleanup
#
# Revision 1.8  2006/06/22 14:02:39  jemartins
# added myID
#
# Revision 1.7  2006/06/07 12:08:27  jemartins
# *** empty log message ***
#
# Revision 1.6  2006/06/05 15:37:13  jemartins
# changes in logit
#
# Revision 1.5  2006/06/05 15:32:42  jemartins
# changes in binary scan
#
# Revision 1.4  2006/06/01 17:23:48  jemartins
# removed extra arguments in format
#
# Revision 1.3  2006/06/01 17:07:11  jemartins
# removed elapsed time calculation
#
# Revision 1.2  2006/05/29 18:12:30  jemartins
# removed InitGrace entry
#
# Revision 1.1  2006/05/26 19:41:56  jemartins
# initial
#
##########################################################################

#=======================================
# processVoltage - entry point
#=======================================
proc processVoltage { inMsg cont n} {
set fn "processVoltage"
global f
global picoMgrID
global PICO_TOKEN
global this
global loggerID
global MASK_MISC
global logMask

global Passo AutoEscala elapsed 

# 32bit:
#binary scan $inMsg i1i1i1i1i1 rtoken myID tv_sec tv_usec myVoltage
# 64bit:
binary scan $inMsg i1i1w1w1i1 rtoken myID tv_sec tv_usec myVoltage

logit $loggerID $this $fn $MASK_MISC $logMask \
	[format "Voltage = %d mV" $myVoltage ]
#       [expr $myVoltage / 10 ]\
#	[expr $myVoltage % 10] ]

set myVolt $myVoltage
#set myVolt [format "%d.%d" \
#        [expr $mySoundLevel / 10 ]\
#        [expr $mySoundLevel % 10] ]
		
# Plotting points
if { $Passo == "Tempo" } {
    PlotaGrace $elapsed $myVolt $n
    SendtoGui $elapsed $myVolt $n
} else {
    PlotaGrace $cont $myVolt $n
    SendtoGui $cont $myVolt $n
}

# auto scale
if {($AutoEscala == 1)} {
    GracePrintf "autoscale"
}

# redraw
GracePrintf "redraw"

if { $Passo == "Tempo" } {
    logit $loggerID $this $fn $MASK_MISC $logMask \
            [format "myVolt=%f mV elapsed=%f sec" \
            $myVolt $elapsed ]
} else {
    logit $loggerID $this $fn $MASK_MISC $logMask \
            [format "myVolt=%f mV cont=%d " \
            $myVolt $cont ]
}

};# end processVoltage
