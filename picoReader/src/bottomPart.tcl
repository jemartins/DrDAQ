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

