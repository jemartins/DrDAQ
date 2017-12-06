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

	binary scan $inMsg i1i1w1w1f1 rtoken myID tv_sec tv_usec myReading
	logit $loggerID $this $fn $MASK_MISC $logMask \
	[format "myReading = %f" $myReading ]

	
} else { 

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
