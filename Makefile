#================================================
#  top level Makefile for DrDAQ tree
#================================================
#-----------------------------------------------------------------------
#    Copyright (C) 2006 DrDAQ Application Project. 
#
#    This library is free software; you can redistribute it and/or
#    modify it under the terms of the GNU Lesser General Public
#    License as published by the Free Software Foundation; either
#    version 2.1 of the License, or (at your option) any later version.
#
#    This library is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#    Lesser General Public License for more details.
#
#    You should have received a copy of the GNU Lesser General Public
#    License along with this library; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
#    If you discover a bug or add an enhancement here's how to reach us: 
#
#	https://sourceforge.net/projects/drdaq
#-----------------------------------------------------------------------
#
#$Log: Makefile,v $
#Revision 1.9  2008/05/16 23:58:11  jemartins
#added PHIDGETMGR stuff
#
#Revision 1.8  2008/05/16 23:47:29  jemartins
#changed PICOGRACEUTILS_DIR name
#
#Revision 1.7  2006/07/10 21:00:24  jemartins
#added make install for bin dir
#
#Revision 1.6  2006/07/10 15:08:52  jemartins
#added PICOLIB
#
#Revision 1.5  2006/07/10 12:49:42  jemartins
#added PICOBIN_DIR
#
#Revision 1.4  2006/07/09 21:01:24  jemartins
#*** empty log message ***
#
#Revision 1.3  2006/05/25 14:23:00  jemartins
#added graceUtils
#
#Revision 1.2  2006/03/24 02:08:17  bobfcsoft
#added picoReader
#
#Revision 1.1  2006/03/08 19:30:48  bobfcsoft
#original
#
#

PICOMGR_DIR=picoMgr
PICOCOURIER_DIR=picoCourier
PICOBIN_DIR=bin
PICOLIB_DIR=lib
PICOGUI_DIR=picoGUI
PICOREADER_DIR=picoReader
NAMESERVER_DIR=nameServer
GRACEUTILS_DIR=graceUtils
PHIDGETMGR_DIR=phidgetMgr

#===================================
# entry point for simple make
#===================================
all:
	@echo DrDAQ Top Level Build all starting
	@echo `date`
	@cd $(PICOMGR_DIR); make -i
	@cd $(PICOREADER_DIR); make -i
	@cd $(PICOGUI_DIR); make -i
	@cd $(NAMESERVER_DIR); make -i
	@cd $(GRACEUTILS_DIR); make -i
	@cd $(PHIDGETMGR_DIR); make -i
	@echo Done DrDAQ TOP LEVEL all done
	@echo `date`

#=================================
# to force a total rebuild
#=================================
clobber:
	@echo DrDAQ Top Level clobber starting
	@cd $(PICOMGR_DIR); make clobber
	@cd $(PICOREADER_DIR); make clobber
	@cd $(PICOGUI_DIR); make clobber
	@cd $(NAMESERVER_DIR); make clobber
	@cd $(GRACEUTILS_DIR); make clobber
	@cd $(PICOBIN_DIR); make clobber
	@cd $(PICOLIB_DIR); rm -f ligrace.so*
	@cd $(PHIDGETMGR_DIR); make clobber
	@echo DrDAQ TOP LEVEL clobber done

#========================
# to move into master area
#========================
install:
	@echo DrDAQ Top Level Build install starting
	@echo `date`
	@cd $(PICOMGR_DIR); make -i install
	@cd $(PICOREADER_DIR); make -i install
	@cd $(PICOGUI_DIR); make -i install
	@cd $(PICOBIN_DIR); make -i install
	@cd $(NAMESERVER_DIR); make -i install
	@cd $(GRACEUTILS_DIR); make -i install
	@cd $(PHIDGETMGR_DIR); make -i install
	@echo DrDAQ TOP LEVEL install done
	@echo `date`

dynamic:
	@echo DrDAQ Top Level Build dynamic starting
	@echo `date`
	@echo DrDAQ TOP LEVEL install done
	@echo `date`

