#########################################################################
## Procedure:  processSoundLevel

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
# $Log: soundUtils.tcl,v $
# Revision 1.9  2006/07/23 23:35:31  jemartins
# cleanup
#
# Revision 1.8  2006/06/22 14:02:39  jemartins
# added myID
#
# Revision 1.7  2006/06/05 15:46:24  jemartins
# changes in logit
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
# Revision 1.1  2006/05/26 19:41:55  jemartins
# initial
#
##########################################################################

#=======================================
# processSoundLevel - entry point
#=======================================
proc processSoundLevel { inMsg cont n} {
set fn "processSoundLevel"
global f
global picoMgrID
global PICO_TOKEN
global this
global loggerID
global MASK_MISC
global logMask

global Passo AutoEscala elapsed 

# 32bit:
#binary scan $inMsg i1i1i1i1i1 rtoken myID tv_sec tv_usec mySoundLevel
# 64bit:
binary scan $inMsg i1i1w1w1i1 rtoken myID tv_sec tv_usec mySoundLevel

logit $loggerID $this $fn $MASK_MISC $logMask \
	[format "sound level = %d.%d dB" \
	[expr $mySoundLevel / 10 ]\
	[expr $mySoundLevel % 10] ]

set mySound [format "%d.%d" \
        [expr $mySoundLevel / 10 ]\
        [expr $mySoundLevel % 10] ]
		
# Plotting points
if { $Passo == "Tempo" } {
    PlotaGrace $elapsed $mySound $n
    SendtoGui $elapsed $mySound $n
} else {
    PlotaGrace $cont $mySound $n
    SendtoGui $cont $mySound $n
}

# auto scale
if {($AutoEscala == 1)} {
    GracePrintf "autoscale"
}

# redraw
GracePrintf "redraw"

if { $Passo == "Tempo" } {
    logit $loggerID $this $fn $MASK_MISC $logMask \
            [format "mySound=%f dB elapsed=%f sec" \
            $mySound $elapsed ]
} else {
    logit $loggerID $this $fn $MASK_MISC $logMask \
            [format "mySound=%f dB cont=%d " \
            $mySound $cont ]
}

};# end processSoundLevel
