#########################################################################
## Procedure:  processTemperature

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
# $Log: temperatureUtils.tcl,v $
# Revision 1.6  2006/07/23 23:35:31  jemartins
# cleanup
#
# Revision 1.5  2006/06/22 14:02:39  jemartins
# added myID
#
# Revision 1.4  2006/06/05 15:24:14  jemartins
# changes in binary scan
#
# Revision 1.3  2006/06/01 17:07:11  jemartins
# removed elapsed time calculation
#
# Revision 1.2  2006/05/29 18:12:30  jemartins
# removed InitGrace entry
#
# Revision 1.1  2006/05/26 19:41:55  jemartins
# initial
#
##########################################################################

#=======================================
# processTemperature - entry point
#=======================================
proc processTemperature { inMsg cont n} {
set fn "processTemperature"
global f
global picoMgrID
global PICO_TOKEN
global this
global loggerID
global MASK_MISC
global logMask

global Passo AutoEscala elapsed 


binary scan $inMsg i1i1i1i1i1 rtoken myID tv_sec tc_usec myTemperature

logit $loggerID $this $fn $MASK_MISC $logMask \
	[format "temperature = %d.%d C" \
	[expr $myTemperature / 10 ]\
	[expr $myTemperature % 10] ]

set myTemp [format "%d.%d" \
        [expr $myTemperature / 10 ]\
        [expr $myTemperature % 10] ]

# Plotting points
if { $Passo == "Tempo" } {
    PlotaGrace $elapsed $myTemp $n
    SendtoGui $elapsed $myTemp $n
} else {
    PlotaGrace $cont $myTemp $n
    SendtoGui $cont $myTemp $n
}

# auto scale
if {($AutoEscala == 1)} {
    GracePrintf "autoscale"
}

# redraw
GracePrintf "redraw"

if { $Passo == "Tempo" } {
    logit $loggerID $this $fn $MASK_MISC $logMask \
            [format "myTemp=%f C elapsed=%f sec" \
            $myTemp $elapsed ]
} else {
    logit $loggerID $this $fn $MASK_MISC $logMask \
            [format "myTemp=%f C cont=%d " \
            $myTemp $cont ]
}

};# end processTemperature
