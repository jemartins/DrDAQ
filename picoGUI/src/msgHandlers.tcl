#=============================================
#
#	msgHandlers.tcl
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
# $Log: msgHandlers.tcl,v $
# Revision 1.9  2006/05/26 16:32:23  jemartins
# added new token
#
# Revision 1.8  2006/05/15 17:48:50  jemartins
# added Copyright
#
# Revision 1.7  2006/05/03 01:55:22  jemartins
# added -f entry
#
# Revision 1.1  2006/05/01 20:31:01  jemartins
# test guivTcl
#
# Revision 1.5  2006/04/27 19:16:50  jemartins
# added global var m
#
# Revision 1.4  2006/04/26 19:44:43  jemartins
# added configure -text..
#
# Revision 1.3  2006/04/26 15:05:46  jemartins
# changes to intercept STOP message
#
# Revision 1.2  2006/03/08 19:20:48  bobfcsoft
# code cleanup
#
# Revision 1.1.1.1  2006/03/07 21:29:31  bobfcsoft
# startup
#
#=============================================

#=============================================
# 	hndlMsg - entry point
#=============================================

proc hndlMsg {fromWhom msg} {
global m
global forever
global reply
global PICO_TOKEN
global this
global logger
global MASK_MISC
global logMask
global pendingEventFrom
global stopped

set fn hndlMsg

#catch {puts stdout [format "%s:ding" $fn]}

binary scan $msg i1 token

logit $logger $this $fn $MASK_MISC $logMask [format "token=0x%X fromWhom=%d" $token $fromWhom]

if { $token == $PICO_TOKEN(PICO_READING_STOP) } {
    #	set pendingEventFrom $fromWhom

    #	catch {puts stdout [format "token=PICO_READING_STOP(0x%X)" $token ] }
    logit $logger $this $fn $MASK_MISC $logMask [format "token=PICO_READING_STOP(0x%X)" $token ]

    #putInfo [format "PICO_READING_STOP received from %s" $pendingEventFrom ]
    
    Reply $fromWhom NULL 0
    
    Parar configure -state disabled 
    Iniciar configure -state normal
    set stopped 1
    
    #showMsg "Hi"
} elseif { $token == $PICO_TOKEN(PICO_WHAT_READINGS) } {

    binary scan $msg i1f1f1i1 \
                token \
                timer \
                reading \
                sensor

    Cronometro config -text [format "%.2f" $timer]

    Medidor$sensor config -text [format "%.2f" $reading]

    logit $logger $this $fn $MASK_MISC $logMask \
	[format "token=%d timer=%f reading=%f sensor=%d" \
	$token $timer $reading $sensor ] 

    Reply $fromWhom NULL 0
} else {
    puts stdout [format "token=0x%X unsupported" $token]
}


#catch {puts stdout [format "%s:done" $fn]}
};#end hndlMsg
#
#======================== end msgHandlers =====================
#
