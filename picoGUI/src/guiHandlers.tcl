#=============================================
#
#	guiHandlers.tcl
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
# $Log: guiHandlers.tcl,v $
# Revision 1.25  2010/02/11 17:28:59  jemartins
# added XY feature
#
# Revision 1.24  2007/06/12 18:09:35  jemartins
# bugs fixed
#
# Revision 1.23  2007/06/11 19:22:44  jemartins
# cleaned code in hitCalibrate
#
# Revision 1.22  2007/06/09 02:17:15  jemartins
# changes for ANGLE_CALIBRATE
#
# Revision 1.21  2006/09/28 13:46:39  jemartins
# removed bug in menor_divy
#
# Revision 1.20  2006/09/26 13:01:03  jemartins
# added ymin var
#
# Revision 1.19  2006/07/20 19:40:48  jemartins
# added LED msg
#
# Revision 1.18  2006/06/22 14:03:02  jemartins
# added myID
#
# Revision 1.17  2006/05/26 16:32:23  jemartins
# added new token
#
# Revision 1.16  2006/05/25 19:01:12  jemartins
# *** empty log message ***
#
# Revision 1.15  2006/05/24 13:31:51  jemartins
# arrange in send msg
#
# Revision 1.14  2006/05/15 17:48:50  jemartins
# added Copyright
#
# Revision 1.13  2006/05/12 22:42:38  jemartins
# expanded START msg
#
# Revision 1.12  2006/05/06 23:30:36  jemartins
# expanded START msg
#
# Revision 1.11  2006/05/04 14:07:19  jemartins
# changes in binary
#
# Revision 1.10  2006/05/03 22:27:32  jemartins
# changes in START hitStart
#
# Revision 1.9  2006/05/03 19:27:23  jemartins
# changed in START message
#
# Revision 1.8  2006/05/03 01:55:22  jemartins
# added -f entry201-14-79-141
#
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

proc hitStart { } {

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
global myID
global TMax Delta_T ncont
global set_value1 set_value2 nmodo1 nmodo2 nsensores
global Passo Sensor1 Sensor2 AutoEscala
global xmax ymax ymin maior_divx menor_divx maior_divy menor_divy
global XY

set fn "hitStart"

logit $logger $this $fn $MASK_MISC $logMask \
	[format "picoMgrID=%d" $picoMgrID ]

if {($Passo == "Tempo")} {
    set npasso 1
    set ncont 0
} else {
    set npasso 0
    set TMax 0
}


if { $picoMgrID != -1 } {
	
	# turning LED on
	set outMsg(token) $PICO_TOKEN(PICO_LED)

        set outArea [binary format "i1" $outMsg(token)]
        set sbytes [string length $outArea]
        set inArea [Send $picoMgrID $outArea $sbytes]

	# sending start message
	set outMsg(token) $PICO_TOKEN(PICO_READING_START)
	set outMsg(ID) $myID
	set outMsg(TMax) $TMax
	set outMsg(period) [expr round($Delta_T * 1000)]
	set outMsg(maxReadings)	$ncont
	set outMsg(nsensors) $nsensores
	set outMsg(Sensor1) $Sensor1
	set outMsg(Sensor2) $Sensor2
	set outMsg(set_value1) $set_value1
	set outMsg(n_modo1) $nmodo1
	set outMsg(set_value2) $set_value2
	set outMsg(n_modo2) $nmodo2
	set outMsg(n_passo) $npasso
	set outMsg(AutoEscala) $AutoEscala
	set outMsg(xmax) $xmax
	set outMsg(ymax) $ymax
	set outMsg(ymin) $ymin
	set outMsg(maior_divx) $maior_divx
	set outMsg(menor_divx) $menor_divx
	set outMsg(maior_divy) $maior_divy
	set outMsg(menor_divy) $menor_divy	
	set outMsg(XY) $XY
		
        set outArea [binary format "i1i1f1i1i1i1i1i1i1i1i1i1i1i1f1f1f1f1f1f1f1i1"\
					$outMsg(token)\
					$outMsg(ID)\
					$outMsg(TMax)\
					$outMsg(period)\
					$outMsg(maxReadings)\
					$outMsg(nsensors)\
					$outMsg(Sensor1)\
					$outMsg(Sensor2)\
					$outMsg(set_value1)\
					$outMsg(n_modo1)\
					$outMsg(set_value2)\
					$outMsg(n_modo2)\
					$outMsg(n_passo)\
					$outMsg(AutoEscala)\
					$outMsg(xmax)\
					$outMsg(ymax)\
					$outMsg(ymin)\
					$outMsg(maior_divx)\
					$outMsg(menor_divx)\
					$outMsg(maior_divy)\
					$outMsg(menor_divy)\
					$outMsg(XY)]

        set sbytes [string length $outArea]

        set inArea [Send $picoMgrID $outArea $sbytes]

}

};# end hitStart

#############################################################################
## Procedure:  hitStop
proc hitStop {} {

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
global myID
global myName
global recvid

set fn "hitStop"

logit $logger $this $fn $MASK_MISC $logMask \
	[format "picoMgrID=%d" $picoMgrID ]

if { $picoMgrID != -1 } {

	# sending stop message
	set outMsg(token)  $PICO_TOKEN(PICO_READING_STOP)
	set outMsg(ID) $myID
	set outArea [binary format "i1i1"\
		$outMsg(token) \
		$outMsg(ID) ]
	set sbytes [string length $outArea]

	set inArea [Send $picoMgrID $outArea $sbytes]

#	putInfo [format "STOP Measurements" $picoMgrID]

}

};# end hitStop

#############################################################################
## Procedure:  Calibrate

proc hitCalibrate {index angle sensor set_value} {

#========================================
#	hitCalibrate - entry point
#=========================================
global widget
global logger
global this
global MASK_MISC
global logMask
global picoMgrID
global PICO_TOKEN
global myID

set fn "hitCalibrate"

#logit $logger $this $fn $MASK_MISC $logMask \
#	[format "picoMgrID=%d index=%d angle=%d sensor=%d set_value=%d" \
#	$picoMgrID \
#	$index \
#	$angle \
#	$sensor \
#	$set_value ]

if { $picoMgrID != -1 } {
	
	# turning LED on
	set outMsg(token) $PICO_TOKEN(PICO_LED)

        set outArea [binary format "i1" $outMsg(token)]
        set sbytes [string length $outArea]
        set inArea [Send $picoMgrID $outArea $sbytes]

	# sending calibrate message
	set outMsg(token) $PICO_TOKEN(PICO_ANGLE_CALIBRATE)
	set outMsg(ID) $myID
	set outMsg(index) $index
	set outMsg(angle) $angle 
	set outMsg(sensor) $sensor 
	set outMsg(set_value) $set_value
		
	logit $logger $this $fn $MASK_MISC $logMask \
	[format "ID=%d index=%d angle=%f sensor=%d set_value=%d" \
					$outMsg(ID) \
					$outMsg(index) \
					$outMsg(angle) \
					$outMsg(sensor) \
					$outMsg(set_value)
					]
        
	set outArea [binary format "i1i1i1f1i1i1" \
					$outMsg(token) \
					$outMsg(ID) \
					$outMsg(index) \
					$outMsg(angle) \
					$outMsg(sensor) \
					$outMsg(set_value)
					]

        set sbytes [string length $outArea]

        set inArea [Send $picoMgrID $outArea $sbytes]

}

};# end hitCalibrate

#=========================================
#	showMsg - entry point
#=========================================
proc showMsg { msgText } {
global m

set fn "showMsg"

#$m.incoming config -text $msgText -background green
$m.hitme config -state normal

}; #end showMsg


#========================================
#	quitThis - entry point
#========================================
proc quitThis { } {
global f
global b
global m
global mySocket
global logger
global this
global MASK_MISC
global logMask
global forever

set fn "quitThis"

catch {puts stdout [format "%s: ding" $fn]}

catch {puts stdout [format "%s: done" $fn]}

set forever 1

};# end quitThis

#========================================
#	putInfo - entry point
#========================================
proc putInfo { infoText } {
global b

$b.info config -justify left -text $infoText -background lightblue
catch {puts stdout $infoText}

}; #end putInfo