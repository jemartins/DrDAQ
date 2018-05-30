#!/usr/bin/tclsh

#########################################################################
##  topPart.tcl

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
# Resivion history:
#
# $Log: topPart.tcl,v $
# Revision 1.7  2006/07/23 23:35:31  jemartins
# cleanup
#
# Revision 1.6  2006/07/10 20:39:59  jemartins
# changes in auto_path
#
# Revision 1.5  2006/07/09 21:01:26  jemartins
# *** empty log message ***
#
# Revision 1.4  2006/05/15 18:20:05  jemartins
# added Copyright
#
# Revision 1.3  2006/05/15 18:02:12  jemartins
# added Copyright
#
# Revision 1.2  2006/05/12 22:48:56  jemartins
# added grace
#
# Revision 1.1  2006/03/22 23:15:13  bobfcsoft
# added messaging framework
#
# Revision 1.1  2006/03/15 20:14:08  bobfcsoft
# seed code
#
#=======================================

set this "reader"

lappend auto_path $env(SIMPL_HOME)/lib
package require Fctclx
lappend auto_path $env(DRDAQ_HOME)/lib
package require grace

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

#########################################################################
## miscUtils.tcl

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
# $Log: miscUtils.tcl,v $
# Revision 1.70  2010/02/23 02:39:32  jemartins
# change in if XY==1
#
# Revision 1.69  2010/02/23 01:18:06  jemartins
# bug fix in brace balance
#
# Revision 1.68  2010/02/22 22:16:16  jemartins
# added case XY in doReadings
#
# Revision 1.67  2010/02/11 17:28:59  jemartins
# added XY feature
#
# Revision 1.66  2008/01/23 21:19:00  jemartins
# changes in for j
#
# Revision 1.65  2007/06/09 17:07:58  jemartins
# include Pendulo in nmodo
#
# Revision 1.64  2007/06/07 00:01:18  jemartins
# fix bugs
#
# Revision 1.63  2007/06/06 22:46:27  jemartins
# adjusted in PICO_ANGLE
#
# Revision 1.62  2007/06/06 18:36:14  jemartins
# added ANGLE case
#
# Revision 1.61  2006/09/26 13:01:04  jemartins
# added ymin var
#
# Revision 1.60  2006/07/23 23:35:31  jemartins
# cleanup
#
# Revision 1.59  2006/07/20 19:40:48  jemartins
# added LED msg
#
# Revision 1.58  2006/07/09 21:01:26  jemartins
# *** empty log message ***
#
# Revision 1.57  2006/06/25 14:01:40  jemartins
# *** empty log message ***
#
# Revision 1.56  2006/06/23 21:13:48  jemartins
# added myID
#
# Revision 1.55  2006/06/22 14:02:39  jemartins
# added myID
#
# Revision 1.54  2006/06/15 23:09:30  jemartins
# added nsensors_kill
#
# Revision 1.53  2006/06/15 13:13:30  jemartins
# added
#
# Revision 1.52  2006/06/07 12:08:27  jemartins
# *** empty log message ***
#
# Revision 1.51  2006/06/06 23:26:40  jemartins
# changes in elapsed calculation
#
# Revision 1.50  2006/06/06 22:02:36  jemartins
# changed calculation in elapsed
#
# Revision 1.49  2006/06/05 15:32:42  jemartins
# changes in binary scan
#
# Revision 1.48  2006/06/05 15:24:14  jemartins
# changes in binary scan
#
# Revision 1.47  2006/06/01 17:06:45  jemartins
# added elapsed time calculation
#
# Revision 1.46  2006/05/31 19:22:26  jemartins
# added threshold in after
#
# Revision 1.45  2006/05/31 19:07:30  jemartins
# added delta
#
# Revision 1.44  2006/05/31 14:28:45  jemartins
# added threshold
#
# Revision 1.43  2006/05/30 20:39:10  jemartins
# changed if condition
#
# Revision 1.42  2006/05/30 13:11:14  jemartins
# changes in  after
#
# Revision 1.41  2006/05/29 18:40:00  jemartins
# added GracePrintf
#
# Revision 1.40  2006/05/29 17:54:23  jemartins
# changed InitGracec call
#
# Revision 1.39  2006/05/26 19:41:55  jemartins
# initial
#
# Revision 1.38  2006/05/26 13:43:00  jemartins
# housekeeping
#
# Revision 1.37  2006/05/25 19:00:46  jemartins
# added SendtoGui
#
# Revision 1.35  2006/05/24 18:44:56  jemartins
# changed processResistance
#
# Revision 1.34  2006/05/24 18:23:05  jemartins
# added WaveForm
#
# Revision 1.33  2006/05/24 18:18:54  jemartins
# added WaveForm
#
# Revision 1.32  2006/05/24 16:15:07  jemartins
# added SOUND_WAVEFORM
#
# Revision 1.31  2006/05/24 15:50:40  jemartins
# changed Tmax
#
# Revision 1.30  2006/05/24 13:37:02  jemartins
# changes in InitGrace
#
# Revision 1.29  2006/05/24 00:23:18  jemartins
# added processSoundLevel call
#
# Revision 1.28  2006/05/23 17:29:45  jemartins
# added InitGrace
#
# Revision 1.27  2006/05/23 16:33:03  jemartins
# added sensor(token)
#
# Revision 1.26  2006/05/23 15:07:08  jemartins
# added sensor(set_value,#)
#
# Revision 1.25  2006/05/22 19:47:40  jemartins
# changed START msg
#
# Revision 1.24  2006/05/22 14:46:12  jemartins
# added logic for 2 sensors
#
# Revision 1.23  2006/05/22 14:32:46  jemartins
# added logic for 2 sensors
#
# Revision 1.22  2006/05/19 23:16:24  jemartins
# changed end loop
#
# Revision 1.21  2006/05/19 23:01:49  jemartins
# added new routines
#
# Revision 1.20  2006/05/19 22:40:56  jemartins
# added new routines
#
# Revision 1.19  2006/05/19 19:29:31  jemartins
# clean code
#
# Revision 1.18  2006/05/19 01:42:51  jemartins
# changes in switch
#
# Revision 1.17  2006/05/18 19:57:40  jemartins
# added switch
#
# Revision 1.16  2006/05/17 19:15:02  jemartins
# changed timestamp to processTemperature
#
# Revision 1.15  2006/05/17 17:15:02  jemartins
# changed elapsed calculation
#
# Revision 1.14  2006/05/17 12:18:21  jemartins
# added clock
#
# Revision 1.13  2006/05/16 19:20:59  jemartins
# changes in after
#
# Revision 1.12  2006/05/16 15:06:10  jemartins
# added while
#
# Revision 1.11  2006/05/15 20:34:34  jemartins
# added elapsed var
#
# Revision 1.10  2006/05/15 20:29:28  jemartins
# added timestamp
#
# Revision 1.9  2006/05/15 18:02:12  jemartins
# added Copyright
#
# Revision 1.8  2006/05/12 22:47:37  jemartins
# added Sensor#
#
# Revision 1.7  2006/05/05 14:28:29  jemartins
# added title in Grace
#
# Revision 1.6  2006/05/05 12:38:44  jemartins
# added Grace's calls
#
# Revision 1.5  2006/05/04 21:27:11  jemartins
# change binary scan in doReadings
#
# Revision 1.4  2006/05/04 16:56:36  bobfcsoft
# added binary scan format for Tmax
#
# Revision 1.3  2006/05/04 15:46:25  jemartins
# added new binary scan
#
# Revision 1.2  2006/04/26 15:06:34  jemartins
# changes to send STOP message
#
# Revision 1.1  2006/03/22 23:15:13  bobfcsoft
# added messaging framework
#
# Revision 1.1  2006/03/15 20:14:08  bobfcsoft
# seed code
#
#=======================================

#=======================================
# mainLoop - entry point
#=======================================
proc mainLoop { } {
set fn "mainLoop"
global f
global picoMgrName
global picoMgrID
global picoGuiName
global picoGuiID
global PICO_TOKEN
global myID
global this
global loggerID
global MASK_MISC
global logMask

logit $loggerID $this $fn $MASK_MISC $logMask [format "ding" ]

if { $picoMgrName == "" } {
	set picoMgrID -1
} else {
	logit $loggerID $this $fn $MASK_MISC $logMask [format "picoMgr name=%s" $picoMgrName]
	set picoMgrID [name_locate $picoMgrName ]
	}

if { $picoGuiName == "" } {
	set picoGuiID -1
} else {
	logit $loggerID $this $fn $MASK_MISC $logMask [format "picoGui name=%s" $picoGuiName]
	set picoGuiID [name_locate $picoGuiName ]
	}

set x_it 0
while { $x_it != 1  } {

    if { $picoMgrID != -1 } {
    
		set sMsg    [binary format "i1i1" \
			$PICO_TOKEN(PICO_WHAT_YA_GOT) \
			$myID]
		set sBytes  [string length $sMsg]
		set rMsg [Send $picoMgrID $sMsg $sBytes]
	
		binary scan $rMsg i1i1a* slot rBytes restofMsg
	
		logit $loggerID $this $fn $MASK_MISC $logMask [format "slot=%d rbytes=%d" $slot $rBytes ]
	
		binary scan $restofMsg i1 rtoken
	
	
		logit $loggerID $this $fn $MASK_MISC $logMask [format "rtoken=%d" $rtoken ]
	
		if { $rtoken == $PICO_TOKEN(PICO_READING_START) } {
		
			doReadings $restofMsg
			
			if { $picoGuiID != -1 } {
			
				set sMsg    [binary format "i1i1" \
					$PICO_TOKEN(PICO_READING_STOP) \
					$myID ]
				set sBytes  [string length $sMsg]
				set rMsg 	[Send $picoGuiID $sMsg $sBytes]	

			# turning LED on
		        set outMsg(token) $PICO_TOKEN(PICO_LED)

			set outArea [binary format "i1" $outMsg(token)]
		        set sbytes [string length $outArea]
		        set inArea [Send $picoMgrID $outArea $sbytes]
			
		}	
		
	} 

    } ;# end if picoMgrID

};# end while

logit $loggerID $this $fn $MASK_MISC $logMask [format "done" ]

} ;# end of proc mainLoop


#=======================================
# doReadings - entry point
#=======================================
proc doReadings { startMsg } {
set fn "doReadings"
global f
global picoMgrID
global PICO_TOKEN
global myID
global DRDAQ_MODE
global this
global loggerID
global MASK_MISC
global logMask

global TMax Delta_T 
global set_value1 set_value2 nmodo1 nmodo2 nsensors
global Passo Modo1 Modo2 Sensor1 Sensor2 AutoEscala
global xmax ymax ymin maior_divx menor_divx maior_divy menor_divy

global elapsed initFlag cont graf nsensors_kill

global XY

logit $loggerID $this $fn $MASK_MISC $logMask [format "ding" ]

binary scan $startMsg x4i1f1i1i1i1i1i1i1i1i1i1i1i1f1f1f1f1f1f1f1i1 \
		ID \
		TMax \
		period \
		maxReadings \
		nsensors \
		Sensor1 \
		Sensor2 \
		sensor(set_value,1) \
		sensor(n_modo,1) \
		sensor(set_value,2) \
		sensor(n_modo,2) \
		n_passo \
		AutoEscala \
		xmax \
		ymax \
		ymin \
		maior_divx \
		menor_divx \
		maior_divy \
		menor_divy \
		modo_XY

# converting to old variables
#############################
#set nsensores 	$nsensors
set nmodo1 	$sensor(n_modo,1)
set nmodo2 	$sensor(n_modo,2)
set set_value1 	$sensor(set_value,1)
set set_value2 	$sensor(set_value,2)
set ncont 	$maxReadings
set XY		$modo_XY

if {$Sensor1 == 1} {

    if {$nmodo1 == 1} {
	set Modo1 "Onda Sonora"
    } elseif {$nmodo1 == 2} {
	set Modo1 "Nivel Sonoro"
    } elseif {$nmodo1 == 3} {
	set Modo1 "Voltagem"
    } elseif {$nmodo1 == 4} {
	set Modo1 "Resistencia"
    } elseif {$nmodo1 == 5} {
	set Modo1 "pH"
    } elseif {$nmodo1 == 6} {
	set Modo1 "Temperatura"
    } elseif {$nmodo1 == 7} {
	set Modo1 "Luz"
    } elseif {$nmodo1 == 8} {
	set Modo1 "Pendulo"
    }
} else {
    set Modo1 "Nao Selecionado"
}

if {$Sensor2 == 1} {
    if {$nmodo2 == 1} {
	set Modo2 "Onda Sonora"
    } elseif {$nmodo2 == 2} {
	set Modo2 "Nivel Sonoro"
    } elseif {$nmodo2 == 3} {
	set Modo2 "Voltagem"
    } elseif {$nmodo2 == 4} {
	set Modo2 "Resistencia"
    } elseif {$nmodo2 == 5} {
	set Modo2 "pH"
    } elseif {$nmodo2 == 6} {
	set Modo2 "Temperatura"
    } elseif {$nmodo2 == 7} {
	set Modo2 "Luz"
    } elseif {$nmodo1 == 8} {
	set Modo2 "Pendulo"
    }
} else {
    set Modo2 "Nao Selecionado"
}

if { $n_passo == 1 } {
    set Passo "Tempo"
} else {
    set Passo "Leituras"
}
# end converting
##########################

logit $loggerID $this $fn $MASK_MISC $logMask \
		[format "myID=%d period=%d msec TMax=%f sec maxReadings=%d" \
		$myID $period $TMax $maxReadings]
logit $loggerID $this $fn $MASK_MISC $logMask \
		[format "num. sensors=%d nmodo1=%d nmodo2=%d \
			Sensor1=%d Sensor2=%d" \
		$nsensors $nmodo1 $nmodo2 $Sensor1 $Sensor2]
logit $loggerID $this $fn $MASK_MISC $logMask \
		[format "set_value1=%d set_value2=%d" \
		$set_value1 $set_value2 ]
logit $loggerID $this $fn $MASK_MISC $logMask \
		[format "Modo 1=%s  Modo 2=%s" \
		$Modo1 $Modo2]
logit $loggerID $this $fn $MASK_MISC $logMask \
		[format "n_passo=%d Passo=%s AutoEscala=%d" \
		$n_passo $Passo $AutoEscala ]
logit $loggerID $this $fn $MASK_MISC $logMask \
		[format "xmax=%f ymax=%f ymin=%f maior divx=%f menor divx=%f \
		maior divy=%f menor divy=%f XY=%d" \
		$xmax $ymax $ymin $maior_divx $menor_divx $maior_divy $menor_divy $XY]

# Esse Truque � meio bizarro
GracePrintf "g0.s0 point 0,0"
# opening Grace and initializations
InitGrace

if { $graf == 0 } {
    set nsensors_prev $nsensors
} else {
    set nsensors_prev $nsensors_kill
}

KillSet $nsensors_prev
	
for {set i 1} {$i <=$nsensors} {incr i} {

    if {($Sensor1 == 0) && ($Sensor2 == 1)} {
	set n 2
    } else {
	set n $i
    }

    if { $n == 1 } {
	set nmodo $nmodo1
    } else {
	set nmodo $nmodo2
    }

    switch $nmodo \
        $DRDAQ_MODE(DRDAQ_SOUND_WAVEFORM) {
	    set token(sensor$n) $PICO_TOKEN(PICO_SOUND_WAVEFORM)
	} \
	$DRDAQ_MODE(DRDAQ_SOUND_LEVEL) {
	    set token(sensor$n) $PICO_TOKEN(PICO_SOUND_LEVEL)
        } \
        $DRDAQ_MODE(DRDAQ_VOLTAGE) {
	    set token(sensor$n) $PICO_TOKEN(PICO_VOLTAGE)
        } \
        $DRDAQ_MODE(DRDAQ_RESISTANCE) {
	    set token(sensor$n) $PICO_TOKEN(PICO_RESISTANCE)
        } \
        $DRDAQ_MODE(DRDAQ_PH) {
	    set token(sensor$n) $PICO_TOKEN(PICO_PH)
        } \
        $DRDAQ_MODE(DRDAQ_TEMPERATURE) {
	    set token(sensor$n) $PICO_TOKEN(PICO_TEMPERATURE)
        } \
        $DRDAQ_MODE(DRDAQ_LIGHT) {
	    set token(sensor$n) $PICO_TOKEN(PICO_LIGHT)
        } \
        $DRDAQ_MODE(DRDAQ_ANGLE) {
	    set token(sensor$n) $PICO_TOKEN(PICO_ANGLE)
        } \
        default { puts stdout "unknown nmodo=$nmodo" 
	};# end switch

};# end for

set elapsed 0
set initFlag 1	
set tolerance [ expr ($period / 1000) * 0.10]

set  x_it  0
for {set  i  1}  { $x_it  != 1 }  { incr i } {

    for {set j 1} {$j <= $nsensors} { incr j} {

		if {($Sensor1 == 0) && ($Sensor2 == 1)} {
			set n 2
		} else {
			set n $j
		}		
		
                set sMsg    [binary format "i1i1i1i1" $token(sensor$n) \
                            $myID $sensor(set_value,$n) $n]

		set sBytes  [string length $sMsg]
		set rMsg [Send $picoMgrID $sMsg $sBytes]
		
		binary scan $rMsg i1i1a* slot rBytes restofMsg
		
		binary scan $restofMsg i1i1w1w1 rtoken ID tv_sec tv_usec
	
		if { $rtoken == $PICO_TOKEN(PICO_READING_STOP) } {
			set x_it 1
			break
		} else {

			# getting start time
			if { $initFlag == 1 } {
				set tv_start [format "%d.%03d" \
					[expr $tv_sec ]\
					[expr $tv_usec / 1000] ]
								
				set initFlag 0

			}

			# getting current time
			set tv_current [format "%d.%03d" \
					[expr $tv_sec ]\
					[expr $tv_usec / 1000] ]			

			logit $loggerID $this $fn $MASK_MISC $logMask \
                		[format "tv_sec=%d tv_usec=%d tv_current=%f" \
			        $tv_sec $tv_usec $tv_current ]

			
			# getting elapsed time
			set elapsed [expr $tv_current - $tv_start] 
			
			if { $Passo == "Tempo" }  {
#				set delta [expr abs($TMax - $elapsed)] 
#				if { $elapsed  > $TMax } { set x_it 1 }	
#				if { $delta  < $tolerance } { set x_it 1 }	
				if { $elapsed  > [expr $TMax + $tolerance] } { 
					set x_it 1 
					break
				}	
			} else {
				if { $i  == $maxReadings } {set x_it 1}
			}
			if { $XY == 0 } {
			    switch $rtoken \
			    $PICO_TOKEN(PICO_SOUND_WAVEFORM) {
				    processSoundWave $restofMsg $i $n
			    } \
			    $PICO_TOKEN(PICO_SOUND_LEVEL) {
				    processSoundLevel $restofMsg $i $n
			    } \
			    $PICO_TOKEN(PICO_VOLTAGE) {
				    processVoltage $restofMsg $i $n
			    } \
			    $PICO_TOKEN(PICO_RESISTANCE) {
				    processResistance $restofMsg $i $n
			    } \
			    $PICO_TOKEN(PICO_PH) {
				    processPH $restofMsg $i $n
			    } \
			    $PICO_TOKEN(PICO_TEMPERATURE) {
				    processTemperature $restofMsg $i $n
			    } \
			    $PICO_TOKEN(PICO_LIGHT) {
				    processLight $restofMsg $i $n
			    } \
			    $PICO_TOKEN(PICO_ANGLE) {
				    processAngle $restofMsg $i $n
			    } \
			    default { puts stdout "unknwon rtoken=$rtoken"
			  };# end switch
			} else {
			    processXY $restofMsg $i $n
	             	}
			if { $j == $nsensors } {
				set x 0
				after [expr round($period - (0.040 * $period))] { set x 1}
#				after [expr round($period - $threshold)] { set x 1 }
				vwait x
			}
	
		};#end else
	
	};# end for set j		
    
};# end for set i


};# end doReadings

#############################################################################
## Procedure:  SendtoGui

proc SendtoGui {timer reading sensor} {

global picoMgrID
global picoGuiID
global PICO_TOKEN
global this
global loggerID
global MASK_MISC
global logMask

set fn "sendtoGui"

if { $picoGuiID != -1 } {
    set sMsg    [binary format "i1f1f1i1" \
                $PICO_TOKEN(PICO_WHAT_READINGS) \
                $timer \
                $reading \
                $sensor]
                
    set sBytes  [string length $sMsg]
    set rMsg [Send $picoGuiID $sMsg $sBytes]	
	

    logit $loggerID $this $fn $MASK_MISC $logMask \
                            [format "timer=%f reading=%f sensor=%d" \
                            $timer $reading $sensor]
}

};# end sendtoGui
#########################################################################
## graceUtils.tcl

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
# Revisions:
# $Log: graceUtils.tcl,v $
# Revision 1.14  2010/03/15 14:34:24  jemartins
# added elseif sensor1
#
# Revision 1.13  2010/02/23 01:26:55  jemartins
# changes for XY mode
#
# Revision 1.12  2010/02/11 17:28:59  jemartins
# added XY feature
#
# Revision 1.11  2006/09/26 13:01:04  jemartins
# added ymin var
#
# Revision 1.10  2006/09/11 13:51:52  jemartins
# added home var
#
# Revision 1.9  2006/07/23 23:35:31  jemartins
# cleanup
#
# Revision 1.8  2006/07/06 11:38:53  jemartins
# makeup
#
# Revision 1.7  2006/06/15 23:09:29  jemartins
# added nsensors_kill
#
# Revision 1.6  2006/05/29 18:10:20  jemartins
# changes in InitGrace
#
# Revision 1.5  2006/05/29 17:54:53  jemartins
# changes in InitGrace
#
# Revision 1.4  2006/05/26 19:41:55  jemartins
# initial
#
# Revision 1.3  2006/05/26 13:43:00  jemartins
# housekeeping
#
# Revision 1.2  2006/05/15 18:02:12  jemartins
# added Copyright
#
# Revision 1.1  2006/05/02 16:01:17  jemartins
# startup
#
##########################################################################

#############################################################################
## Procedure:  Legendas

proc Legendas {} {
global Sensor1
global Sensor2
global Modo1
global Modo2
global Passo
global XY


GracePrintf "title \"Dados Adquiridos Via DrDAQ\""

if {($Sensor1 == 1) && ($Sensor2 == 1) && ($XY == 0)} {
    GracePrintf "subtitle \"$Modo1 x $Passo & $Modo2 x $Passo\""
} elseif {($Sensor1 == 1) && ($XY == 0)} {
    GracePrintf "subtitle \"$Modo1 x $Passo\""
} elseif {($Sensor2 == 1) && ($XY == 0)} {
    GracePrintf "subtitle \"$Modo2 x $Passo\""
}
if {($Sensor1 == 1) && ($Sensor2 == 1) && ($XY == 1)} {
	    GracePrintf "subtitle \"$Modo1 x $Modo2\""
    }
}

#############################################################################
## Procedure:  KillSet

proc KillSet {nsensors_prev} {
global nsensors nsensors_kill graf home

if {[GraceIsOpen]} {
	
	if {($graf > 99)} {
		set graf 0
	}
		
	if {($nsensors_prev == 1)} {
		GracePrintf "write g0.s0 file \"$home\/tmp\/tabela$graf.dat\""
		GracePrintf "kill g0.s0"
		GracePrintf "redraw"
		set graf [expr {$graf + 1}]
	} else {
		GracePrintf "write g0.s0 file \"$home\/tmp\/tabela$graf.dat\""
		GracePrintf "kill g0.s0"
		GracePrintf "redraw"
		set graf [expr {$graf + 1}]
		GracePrintf "write g0.s1 file \"$home\/tmp\/tabela$graf.dat\""
		GracePrintf "kill g0.s1"
		GracePrintf "redraw"
		set graf [expr {$graf + 1}]
	}
	
	SetSimbolo $nsensors
	set nsensors_kill $nsensors
}

}

#############################################################################
## Procedure:  SalvarArquivo

proc SalvarArquivo {s} {
global nsensors

set nomearq [tk_getSaveFile -initialfile g0s$s -defaultextension .dat  -title "Salvar Dados Como"]
            
if {($nsensors == 2) || ($s == 1)} { 
    GracePrintf "write g0.s$s file $nomearq"
}
}

#############################################################################
## Procedure:  InitGrace

proc InitGrace { } {

global Passo AutoEscala nsensors Sensor1 Sensor2 Modo1 Modo2
global xmax ymax ymin maior_divx menor_divx maior_divy menor_divy
global XY

# Opening and Init Grace
if {!([GraceIsOpen])} {

	# Opening Grace
	OpenGrace
	
	# Legends
	Legendas
	
	# defining simbols for graph
	#SetSimbolo $nsensors 
	
	# Init scale
	if {($AutoEscala == 0)} {
		SetEscala $xmax $ymax $ymin $maior_divx $menor_divx \
		$maior_divy $menor_divy
	}

};# end if GraceIsOpen

};# end InitGrace
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

# 32bit:
#binary scan $inMsg i1i1i1i1i1 rtoken myID tv_sec tv_usec myLight

# 64bit:
binary scan $inMsg i1i1w1w1i1 rtoken myID tv_sec tv_usec myLight

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
#########################################################################
## Procedure:  processPH

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
# $Log: phUtils.tcl,v $
# Revision 1.8  2006/07/23 23:35:31  jemartins
# cleanup
#
# Revision 1.7  2006/06/22 14:02:39  jemartins
# added myID
#
# Revision 1.6  2006/06/05 15:32:42  jemartins
# changes in binary scan
#
# Revision 1.5  2006/06/01 17:23:48  jemartins
# removed extra arguments in format
#
# Revision 1.4  2006/06/01 17:07:11  jemartins
# removed elapsed time calculation
#
# Revision 1.3  2006/05/29 18:36:29  jemartins
# changed syntax error
#
# Revision 1.2  2006/05/29 18:12:30  jemartins
# removed InitGrace entry
#
# Revision 1.1  2006/05/26 19:41:55  jemartins
# initial
#
##########################################################################

#=======================================
# processPH - entry point
#=======================================
proc processPH { inMsg cont n} {
set fn "processPH"
global f
global picoMgrID
global PICO_TOKEN
global this
global loggerID
global MASK_MISC
global logMask

global Passo AutoEscala elapsed 

# 32bit:
#binary scan $inMsg i1i1i1i1i1 rtoken myID tv_sec tv_usec myPH

# 64bit:
binary scan $inMsg i1i1w1w1i1 rtoken myID tv_sec tv_usec myPH

logit $loggerID $this $fn $MASK_MISC $logMask \
	[format "PH = %d ADC" $myPH ]
#       [expr $myPH / 10 ]\
#	[expr $myPH % 10] ]

set myph $myPH
#set myph [format "%d.%d" \
#        [expr $myPH / 10 ]\
#        [expr $myPH % 10] ]
		
# Plotting points
if { $Passo == "Tempo" } {
    PlotaGrace $elapsed $myph $n
    SendtoGui $elapsed $myph $n
} else {
    PlotaGrace $cont $myph $n
    SendtoGui $cont $myph $n
}

# auto scale
if {($AutoEscala == 1)} {
    GracePrintf "autoscale"
}

# redraw
GracePrintf "redraw"

if { $Passo == "Tempo" } {
    logit $loggerID $this $fn $MASK_MISC $logMask \
            [format "myPH=%f ADC elapsed=%f sec" \
            $myPH $elapsed ]
} else {
    logit $loggerID $this $fn $MASK_MISC $logMask \
            [format "myPH=%f ADC cont=%d " \
            $myPH $cont ]
}

};# end processPH
#########################################################################
## Procedure:  processResistance

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
# $Log: resistanceUtils.tcl,v $
# Revision 1.8  2006/07/23 23:35:31  jemartins
# cleanup
#
# Revision 1.7  2006/06/22 14:02:39  jemartins
# added myID
#
# Revision 1.6  2006/06/05 15:32:42  jemartins
# changes in binary scan
#
# Revision 1.5  2006/06/01 17:23:48  jemartins
# removed extra arguments in format
#
# Revision 1.4  2006/06/01 17:07:11  jemartins
# removed elapsed time calculation
#
# Revision 1.3  2006/05/29 18:57:33  jemartins
# changed syntax error
#
# Revision 1.2  2006/05/29 18:12:30  jemartins
# removed InitGrace entry
#
# Revision 1.1  2006/05/26 19:41:55  jemartins
# initial
#
##########################################################################

#=======================================
# processResistance - entry point
#=======================================
proc processResistance { inMsg cont n} {
set fn "processResistance"
global f
global picoMgrID
global PICO_TOKEN
global this
global loggerID
global MASK_MISC
global logMask

global Passo AutoEscala elapsed 

# 32bit:
#binary scan $inMsg i1i1i1i1i1 rtoken myID tv_sec tv_usec myResistance
# 64bit:
binary scan $inMsg i1i1w1w1i1 rtoken myID tv_sec tv_usec myResistance

logit $loggerID $this $fn $MASK_MISC $logMask \
	[format "resistance = %d ADC" $myResistance]
#	[expr $myTemperature / 10 ]\
#	[expr $myTemperature % 10] ]

set myResist $myResistance
#set myResist [format "%d.%d" \
#        [expr $myResistance / 10 ]\
#        [expr $myResistance % 10] ]
		
# Plotting points
if { $Passo == "Tempo" } {
    PlotaGrace $elapsed $myResist $n
    SendtoGui $elapsed $myResist $n
} else {
    PlotaGrace $cont $myResist $n
    SendtoGui $cont $myResist $n
}

# auto scale
if {($AutoEscala == 1)} {
    GracePrintf "autoscale"
}

# redraw
GracePrintf "redraw"

if { $Passo == "Tempo" } {
    logit $loggerID $this $fn $MASK_MISC $logMask \
            [format "myResist=%f ADC elapsed=%f sec" \
            $myResist $elapsed ]
} else {
    logit $loggerID $this $fn $MASK_MISC $logMask \
            [format "myResist=%f ADC cont=%d " \
            $myResist $cont ]
}

};# end processResistance
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
#########################################################################
## Procedure:  processSoundWave

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
# $Log: waveUtils.tcl,v $
# Revision 1.8  2006/07/23 23:35:31  jemartins
# cleanup
#
# Revision 1.7  2006/06/22 14:02:39  jemartins
# added myID
#
# Revision 1.6  2006/06/05 15:46:24  jemartins
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
# processSoundWave - entry point
#=======================================
proc processSoundWave { inMsg cont n} {
set fn "processSoundWave"
global f
global picoMgrID
global PICO_TOKEN
global this
global loggerID
global MASK_MISC
global logMask

global Passo AutoEscala elapsed 

# 32bit:
#binary scan $inMsg i1i1i1i1i1 rtoken myID tv_sec tv_usec myWaveForm

# 64bit:
binary scan $inMsg i1i1w1w1i1 rtoken myID tv_sec tv_usec myWaveForm

set myWave $myWaveForm

logit $loggerID $this $fn $MASK_MISC $logMask \
	[format "Wave Form = %d ADC" $myWaveForm ]
#       [expr $myWaveForm / 10 ]\
#	[expr $myWaveForm % 10] ]

		
# Plotting points
if { $Passo == "Tempo" } {
    PlotaGrace $elapsed $myWave $n
    SendtoGui $elapsed $myWave $n
} else {
    PlotaGrace $cont $myWave $n
    SendtoGui $cont $myWave $n
}

# auto scale
if {($AutoEscala == 1)} {
    GracePrintf "autoscale"
}

# redraw
GracePrintf "redraw"

if { $Passo == "Tempo" } {
    logit $loggerID $this $fn $MASK_MISC $logMask \
            [format "myWave=%f ADC elapsed=%f sec" \
            $myWave $elapsed ]
} else {
    logit $loggerID $this $fn $MASK_MISC $logMask \
            [format "myWave=%f ADC cont=%d " \
            $myWave $cont ]
}

};# end processSoundWave
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

# 32bit:
#binary scan $inMsg i1i1i1i1f1 rtoken myID tv_sec tv_usec myAngle

# 64bit:
binary scan $inMsg i1i1w1w1f1 rtoken myID tv_sec tv_usec myAngle

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
#########################################################################
## Procedure:  processXY

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
# $Log: XYUtils.tcl,v $
# Revision 1.6  2010/06/14 20:06:55  jemartins
# added if in binary scan
#
# Revision 1.5  2010/02/23 12:05:15  jemartins
# pulished code
#
# Revision 1.4  2010/02/23 11:41:48  jemartins
# complete all switches
#
# Revision 1.3  2010/02/23 01:55:07  jemartins
# pulish code in case Temperarure
#
# Revision 1.2  2010/02/23 01:19:03  jemartins
# added swich rtoken
#
# Revision 1.1  2010/02/22 22:15:32  jemartins
# cloned from voltageUtils
#
#
##########################################################################

#=======================================
# processXY - entry point
#=======================================
proc processXY { inMsg cont n} {
set fn "processXY"
global f
global picoMgrID
global PICO_TOKEN
global this
global loggerID
global MASK_MISC
global logMask

global Passo AutoEscala elapsed 

global SensorX SensorY


binary scan $inMsg i1 rtoken

if { $rtoken == $PICO_TOKEN(PICO_ANGLE) } {

	# 32bits
	#binary scan $inMsg i1i1i1i1f1 rtoken myID tv_sec tv_usec myReading
	# 64bits
	binary scan $inMsg i1i1w1w1f1 rtoken myID tv_sec tv_usec myReading
	logit $loggerID $this $fn $MASK_MISC $logMask \
	[format "myReading = %f" $myReading ]

	
} else { 
	
	# 32bits
	binary scan $inMsg i1i1i1i1i1 rtoken myID tv_sec tv_usec myReading
	# 64bits
	binary scan $inMsg i1i1w1w1i1 rtoken myID tv_sec tv_usec myReading
	logit $loggerID $this $fn $MASK_MISC $logMask \
	[format "myReading = %d" $myReading ]

}

switch $rtoken \
    $PICO_TOKEN(PICO_SOUND_WAVEFORM) {

      if { $n == 1 } {
	set SensorY $myReading
	SendtoGui $elapsed $SensorY $n
      } elseif { $n == 2 } {
	set SensorX $myReading
	SendtoGui $elapsed $SensorX $n
      }

  } \
    $PICO_TOKEN(PICO_SOUND_LEVEL) {

    set mySound [format "%d.%d" \
	[expr $myReading / 10 ] \
	[expr $myReading % 10] ]

      if { $n == 1 } {
	set SensorY $mySound
	SendtoGui $elapsed $SensorY $n
      } elseif { $n == 2 } {
	set SensorX $mySound
	SendtoGui $elapsed $SensorX $n
      }

    } \
    $PICO_TOKEN(PICO_VOLTAGE) {

      if { $n == 1 } {
	set SensorY $myReading
	SendtoGui $elapsed $SensorY $n
      } elseif { $n == 2 } {
	set SensorX $myReading
	SendtoGui $elapsed $SensorX $n
      }

    } \
    $PICO_TOKEN(PICO_RESISTANCE) {

      if { $n == 1 } {
	set SensorY $myReading
	SendtoGui $elapsed $SensorY $n
      } elseif { $n == 2 } {
	set SensorX $myReading
	SendtoGui $elapsed $SensorX $n
      }

    } \
    $PICO_TOKEN(PICO_PH) {

      if { $n == 1 } {
	set SensorY $myReading
	SendtoGui $elapsed $SensorY $n
      } elseif { $n == 2 } {
	set SensorX $myReading
	SendtoGui $elapsed $SensorX $n
      }

    } \
    $PICO_TOKEN(PICO_TEMPERATURE) {

    set myTemperature [format "%d.%d" \
	[expr $myReading / 10 ] \
	[expr $myReading % 10] ]

      if { $n == 1 } {
	set SensorY $myTemperature
	SendtoGui $elapsed $SensorY $n
      } elseif { $n == 2 } {
	set SensorX $myTemperature
	SendtoGui $elapsed $SensorX $n
      }

    } \
    $PICO_TOKEN(PICO_LIGHT) {

    set myLight [format "%d.%d" \
	[expr $myReading / 10 ] \
	[expr $myReading % 10] ]

      if { $n == 1 } {
	set SensorY $myLight
	SendtoGui $elapsed $SensorY $n
      } elseif { $n == 2 } {
	set SensorX $myLight
	SendtoGui $elapsed $SensorX $n
      }

    } \
    $PICO_TOKEN(PICO_ANGLE) {

      if { $n == 1 } {
	set SensorY $myReading
	SendtoGui $elapsed $SensorY $n
      } elseif { $n == 2 } {
	set SensorX $myReading
	SendtoGui $elapsed $SensorX $n
      }

    } \
    default { puts stdout "unknwon rtoken=$rtoken"
};# end switch

# Plotting points
if { $n == 2 } {

  PlotaGrace $SensorX $SensorY $n

  logit $loggerID $this $fn $MASK_MISC $logMask \
	[format "SensorY=%f SensorX=%f" \
        $SensorY $SensorX ]

  # auto scale
  if {($AutoEscala == 1)} {
    GracePrintf "autoscale"
  }

}

# redraw
GracePrintf "redraw"


};# end processXY
#########################################################################
## bottomAgentPart.tcl

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
# Resivion history:
#
# $Log: bottomPart.tcl,v $
# Revision 1.10  2006/07/23 23:35:31  jemartins
# cleanup
#
# Revision 1.9  2006/06/26 13:06:58  jemartins
# removed flab
#
# Revision 1.8  2006/06/22 14:02:38  jemartins
# added myID
#
# Revision 1.7  2006/06/15 13:13:30  jemartins
# added
#
# Revision 1.6  2006/06/14 18:38:03  jemartins
# added ioaName
#
# Revision 1.5  2006/05/15 18:02:12  jemartins
# added Copyright
#
# Revision 1.4  2006/05/03 21:32:31  bobfcsoft
# added file option to stub
#
# Revision 1.3  2006/04/27 19:00:39  jemartins
# *** empty log message ***
#
# Revision 1.2  2006/04/26 15:06:33  jemartins
# changes to send STOP message
#
# Revision 1.1  2006/03/22 23:15:13  bobfcsoft
# added messaging framework
#
# Revision 1.1  2006/03/15 20:14:08  bobfcsoft
# seed code
#
#======================================


#========================================
#  main - entry point
#========================================

set fn main
set logMask 0xff
set toName ""
set loggerName ""
set myName "READER"
set picoMgrName ""
set picoGuiName ""
set ioaName ""
set myID 0

set state flag
foreach arg $argv {
	switch -- $state {
		flag {
			switch -glob -- $arg {
				-N	{ set state name }
				-m	{ set state mask }
				-g	{ set state gui }		
				-I	{ set state id }
				-p	{ set state pico }
				-l	{ set state logger }
				default { error "unknown flag $arg"}
			}
		}
		
		name {
			set myName $arg
			set state flag
		}

		gui {
			set picoGuiName $arg 
			set state flag
		}
		
		id {
			set myID $arg
			set state flag
		}

		pico {
			set picoMgrName $arg
			set state flag
		}

		mask {
			set logMask $arg
			set state flag
		}


		logger {
			set loggerName $arg
			set state flag
		}
	};# end switch state
};# end foreach

set myslot [name_attach $myName 2048]
#catch {puts stdout [format "myName=<%s> myslot=%s" $myName $myslot]}

if { $loggerName == "" } {
	set loggerID -1
} else {
	set loggerID [name_locate $loggerName]
	logit $loggerID $this $fn $MASK_MISC $logMask [format "loggerID=%d" $loggerID]
}

logit $loggerID $this $fn $MASK_MISC $logMask [format "myName=<%s> myslot=%s" $myName $myslot]
logit $loggerID $this $fn $MASK_MISC $logMask [format "loggerName=<%s> loggerID=%d" $loggerName $loggerID ]
logit $loggerID $this $fn $MASK_MISC $logMask [format "logMask=%X" $logMask]

after 2000 mainLoop

set myFifo [ format "%s/%s" $env(FIFO_PATH) $myslot ]
set recvid [ open $myFifo {RDWR}]

fileevent $recvid readable exit
vwait forever

name_detach

