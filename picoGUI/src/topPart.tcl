#########################################################################
# topPart.tcl
#

#=============================================
# 	GUI for DrDAQ interface
#
#    Copyright (C) 2006 DrDAQ Application Project 
#
#    This software is in the public domain.
#    Permission to use, copy, modify, and distribute this software and its
#    documentation for any purpose and without fee is hereby granted, 
#    without any conditions or restrictions.
#    This software is provided "as is" without express or implied warranty.
#
#    If you discover a bug or add an enhancement here's how to reach us: 
#
#	https://sourceforge.net/projects/drdaq
#-------------------------
#=============================================
# Revision history:
#
# $Log: topPart.tcl,v $
# Revision 1.8  2006/07/10 20:41:29  jemartins
# changes in auto_path
#
# Revision 1.7  2006/07/09 21:01:25  jemartins
# *** empty log message ***
#
# Revision 1.6  2006/05/15 17:48:50  jemartins
# added Copyright
#
# Revision 1.5  2006/05/03 01:55:22  jemartins
# added -f entry
#
# Revision 1.2  2006/05/01 23:37:13  jemartins
# added global vars entry
#
# Revision 1.1  2006/05/01 20:31:01  jemartins
# test guivTcl
#
# Revision 1.2  2006/03/23 22:32:10  bobfcsoft
# code cleanup
#
# Revision 1.1.1.1  2006/03/07 21:29:31  bobfcsoft
# startup
#
#=============================================
lappend auto_path $env(SIMPL_HOME)/lib
package require Fctclx

#
#===================== end topPart ======================
#
