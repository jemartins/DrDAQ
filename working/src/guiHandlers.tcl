#=============================================
#
#	guiHandlers.tcl
#
#=============================================
#=============================================
# $Log: guiHandlers.tcl,v $
# Revision 1.7  2006/05/02 03:31:31  jemartins
# removed fileevent entry
#
# Revision 1.6  2006/05/02 03:08:00  jemartins
# removed name_atach() entry
#
# Revision 1.5  2006/05/02 01:14:54  jemartins
# changes in name_atach() entry
#
# Revision 1.4  2006/05/02 00:38:48  jemartins
# added set myslot entry
#
# Revision 1.3  2006/05/02 00:00:31  jemartins
# added global Delta_T and ncont
#
# Revision 1.2  2006/05/01 23:37:13  jemartins
# added global vars entry
#
# Revision 1.1  2006/05/01 20:31:01  jemartins
# test guivTcl
#
# Revision 1.6  2006/04/26 19:46:38  jemartins
# changes in showMe subroutine
#
# Revision 1.5  2006/04/26 15:05:46  jemartins
# changes to intercept STOP message
#
# Revision 1.4  2006/04/21 22:02:22  jemartins
# add hitStop function
#
# Revision 1.3  2006/03/24 02:09:11  bobfcsoft
# adjusted hardcoded start params
#
# Revision 1.2  2006/03/23 22:32:10  bobfcsoft
# code cleanup
#
# Revision 1.1.1.1  2006/03/07 21:29:31  bobfcsoft
# startup
#
#======================

#############################################################################
## Procedure:  hitStart

proc ::hitStart { } {

#========================================
#	hitStart - entry point
#=========================================
global widget
global logger
global this
global MASK_MISC
global logMask
global picoMgrID
global PICO_TOKEN
global Delta_T
global ncont

set fn "hitStart"

logit $logger $this $fn $MASK_MISC $logMask \
	[format "picoMgrID=%d" $picoMgrID ]

puts stdout "logger=$logger this=$this fn=$fn MASK_MISC=$MASK_MISC logMask=$logMask picoMgrID=$picoMgrID"

if { $picoMgrID != -1 } {

	set outMsg(token)  $PICO_TOKEN(PICO_READING_START)
	set outMsg(period) [expr {$Delta_T * 1000}]
	set outMsg(maxReadings)	$ncont
	set outArea [binary format "i1i1i1"\
		$outMsg(token)\
		$outMsg(period)\
		$outMsg(maxReadings) ]
	set sbytes [string length $outArea]

	set inArea [Send $picoMgrID $outArea $sbytes]

	}

}
#############################################################################
## Procedure:  hitStop
proc ::hitStop {} {

#=========================================
#	hitStop - entry point
#=========================================
global widget
global logger
global this
global MASK_MISC
global logMask
global picoMgrID
global PICO_TOKEN
global myName
global recvid

set fn "hitStop"

logit $logger $this $fn $MASK_MISC $logMask \
	[format "picoMgrID=%d" $picoMgrID ]

if { $picoMgrID != -1 } {

	set outMsg(token)  $PICO_TOKEN(PICO_READING_STOP)
	set outArea [binary format "i1"\
		$outMsg(token)]
	set sbytes [string length $outArea]

	set inArea [Send $picoMgrID $outArea $sbytes]

#	putInfo [format "STOP Measurements" $picoMgrID]

	}

}

