#########################################################################
## Procedure:  processAngle

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
# $Log: angleUtils.tcl,v $
# Revision 1.4  2010/02/11 17:28:59  jemartins
# added XY feature
#
# Revision 1.3  2007/06/06 22:46:27  jemartins
# adjusted in PICO_ANGLE
#
# Revision 1.2  2007/06/06 20:52:13  jemartins
# adjusted ANGLE option
#
# Revision 1.1  2007/06/06 18:35:28  jemartins
# initial code
#
##########################################################################

#=======================================
# processAngle - entry point
#=======================================
proc processAngle { inMsg cont n} {
set fn "processAngle"
global f
global picoMgrID
global PICO_TOKEN
global this
global loggerID
global MASK_MISC
global logMask

global Passo AutoEscala elapsed 

binary scan $inMsg i1i1i1i1f1 rtoken myID tv_sec tv_usec myAngle

logit $loggerID $this $fn $MASK_MISC $logMask \
	[format "Angle = %f degree" $myAngle ]

		
# Plotting points
if { $Passo == "Tempo" } {
    PlotaGrace $elapsed $myAngle $n
    SendtoGui $elapsed $myAngle $n
} else {
    PlotaGrace $cont $myAngle $n
    SendtoGui $cont $myAngle $n
}

# auto scale
if {($AutoEscala == 1)} {
    GracePrintf "autoscale"
}

# redraw
GracePrintf "redraw"

if { $Passo == "Tempo" } {
    logit $loggerID $this $fn $MASK_MISC $logMask \
            [format "myAngle=%f degree elapsed=%f sec" \
            $myAngle $elapsed ]
} else {
    logit $loggerID $this $fn $MASK_MISC $logMask \
            [format "myAngle=%f degree cont=%d " \
            $myAngle $cont ]
}

};# end processVoltage
