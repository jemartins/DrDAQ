#=============================================
#
#	receiveUtils.tcl
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
# $Log: receiveUtils.tcl,v $
# Revision 1.5  2006/05/15 17:48:50  jemartins
# added Copyright
#
# Revision 1.4  2006/05/03 01:55:22  jemartins
# added -f entry
#
# Revision 1.1  2006/05/01 20:31:01  jemartins
# test guivTcl
#
# Revision 1.2  2006/03/08 19:20:48  bobfcsoft
# code cleanup
#
# Revision 1.1.1.1  2006/03/07 21:29:31  bobfcsoft
# startup
#
#=============================================

#=============================================
#	doReceive - entry point
#=============================================
proc doReceive {} {
global j
global this
global logger
global MASK_MISC
global logMask
set fn doReceive

set buf [Receive]

#catch {puts stdout [format "%s:got message #%d" $fn $j]}

binary scan $buf i1i1 fromWhom nbytes 
logit $logger $this $fn $MASK_MISC $logMask [format "received %d bytes from %d" $nbytes $fromWhom]
	
binary scan $buf x8a$nbytes msg 
hndlMsg $fromWhom $msg
incr j

#catch {puts stdout [format "%s:done" $fn]}

};# end doReceive
