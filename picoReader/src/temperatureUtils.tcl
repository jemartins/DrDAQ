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

proc string2hex s {
    binary scan $s H* hex
    regsub -all (..) $hex {\\x\1}
} ;# RS

#proc string2hex {string} {
#    set where 0
#    set res {}
#    while {$where<[string length $string]} {
#        set str [string range $string $where [expr $where+15]]
#        if {![binary scan $str H* t] || $t==""} break
#        regsub -all (....) $t {\1 } t4
#        regsub -all (..) $t {\1 } t2
#        set asc ""
#        foreach i $t2 {
#            scan $i %2x c
#            append asc [expr {$c>=32 && $c<=127? [format %c $c]: "."}]
#        }
#        lappend res [format "%7.7x: %-42s %s" $where $t4  $asc]
#        incr where 16
#    }
#    join $res \n
#}

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

set DumpHex [string2hex $inMsg]
logit $loggerID $this $fn $MASK_MISC $logMask \
	"DumpHex $DumpHex"

# 32bit:
#binary scan $inMsg i1i1i1i1i1 rtoken myID tv_sec tc_usec myTemperature

# 64bit:
binary scan $inMsg i1i1w1w1i1 rtoken myID tv_sec tc_usec myTemperature

logit $loggerID $this $fn $MASK_MISC $logMask \
	[format "rtoken=%d myID = %d" \
	[expr $rtoken ] \
	[expr $myID ] ]

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
