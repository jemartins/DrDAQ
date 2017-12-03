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

