#=============================================
#
#	msgHandlers.tcl
#
#=============================================
# $Log: msgHandlers.tcl,v $
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
global stopFlag

set fn hndlMsg

#catch {puts stdout [format "%s:ding" $fn]}

binary scan $msg i1 token

logit $logger $this $fn $MASK_MISC $logMask [format "token=0x%X fromWhom=%d" $token $fromWhom]

if { $token == $PICO_TOKEN(PICO_READING_STOP) } {
#	set pendingEventFrom $fromWhom

#	catch {puts stdout [format "token=PICO_READING_STOP(0x%X)" $token ] }
	logit $logger $this $fn $MASK_MISC $logMask [format "token=PICO_READING_STOP(0x%X)" $token ]

	putInfo [format "PICO_READING_STOP received from %s" $pendingEventFrom ]
	
	Reply $fromWhom NULL 0
	
	$m.hitme configure -text "Start Measurements"
	set stopFlag 0
	
	showMsg "Hi"
} else {
	puts stdout [format "token=0x%X unsupported" $token]
}

#catch {puts stdout [format "%s:done" $fn]}
};#end hndlMsg
#
#======================== end msgHandlers =====================
#
