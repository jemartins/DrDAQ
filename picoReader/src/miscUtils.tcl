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
		
		binary scan $restofMsg i1i1i1i1 rtoken ID tv_sec tv_usec
	
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
