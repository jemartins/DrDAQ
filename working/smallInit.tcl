#=============================================
#
#	smallInit.tcl
#
#=============================================
# $Log: smallInit.tcl,v $
# Revision 1.3  2006/05/01 15:46:26  jemartins
# comment out
#
# Revision 1.2  2006/05/01 14:28:13  jemartins
# unit test
#
#=============================================

#================================================
#	main - entry point
#================================================

set fn init 
set logMask 0xff
set MASK_MISC          1
set myName ""
set loggerName ""
#set FIFO_PATH "/home/jemartins/icanprogram/simpl/fifo"

set state flag 
foreach arg $argv {
	switch -- $state {
		flag	{
			switch -glob -- $arg {
				-N	{ set state name }
				-l	{ set state logger }
				default { puts stdout  "error unknown flag $arg" 
					exit
				}
			}
		}
		
		name {
			set myName $arg
			set state flag 
		}

		logger {
			set loggerName $arg
			set state flag
		}
	};# end switch state
};# end foreach

set myslot [name_attach $myName 2048]

#catch {puts stdout [format "myName=<%s> myslot=%d" $myName $myslot]}

if { $loggerName == "" } {
	set logger -1
} else {
	set logger [name_locate "LOGGER"]
}

#set myFifo [ format "%s/%s" $FIFO_PATH $myslot ]
#set recvid [ open $myFifo {RDWR}]
#catch {puts stdout [ format "myFifo=%s fd=%d" $myFifo $recvid]}

logit $logger $this $fn $MASK_MISC $logMask [format "myName=<%s> myslot=%s" $myName $myslot]
logit $logger $this $fn $MASK_MISC $logMask [format "loggerName=<%s> id=%d" $loggerName $logger]
#logit $logger $this $fn $MASK_MISC $logMask [format "logMask=%X" $logMask]
#logit $logger $this $fn $MASK_MISC $logMask [format "myFifo=<%s> fd=<%s>" $myFifo $recvid]

name_detach

#puts stdout {done}

#
#================ end smallInit.tcl =======================
