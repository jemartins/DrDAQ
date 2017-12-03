#########################################################################
## Procedure:  processLight

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
# $Log: lightUtils.tcl,v $
# Revision 1.9  2006/07/23 23:35:31  jemartins
# cleanup
#
# Revision 1.8  2006/06/22 14:02:39  jemartins
# added myID
#
# Revision 1.7  2006/06/05 16:00:53  jemartins
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
# processLight - entry point
#=======================================
proc processLight { inMsg cont n} {
set fn "processLight"
global f
global picoMgrID
global PICO_TOKEN
global this
global loggerID
global MASK_MISC
global logMask

global Passo AutoEscala elapsed 

binary scan $inMsg i1i1i1i1i1 rtoken myID tv_sec tv_usec myLight

logit $loggerID $this $fn $MASK_MISC $logMask \
	[format "Light = %d.%d" \
	[expr $myLight / 10 ]\
	[expr $myLight % 10] ]

set myLig [format "%d.%d" \
        [expr $myLight / 10 ]\
        [expr $myLight % 10] ]
		
# Plotting points
if { $Passo == "Tempo" } {
    PlotaGrace $elapsed $myLig $n
    SendtoGui $elapsed $myLig $n
} else {
    PlotaGrace $cont $myLig $n
    SendtoGui $cont $myLig $n
}

# auto scale
if {($AutoEscala == 1)} {
    GracePrintf "autoscale"
}

# redraw
GracePrintf "redraw"

if { $Passo == "Tempo" } {
    logit $loggerID $this $fn $MASK_MISC $logMask \
            [format "myLig=%f elapsed=%f sec" \
            $myLig $elapsed ]
} else {
    logit $loggerID $this $fn $MASK_MISC $logMask \
            [format "myLig=%f cont=%d " \
            $myLig $cont ]
}

};# end processLight
