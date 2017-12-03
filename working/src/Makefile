#================================================
#  Makefile for merged vTcl and Tcl stuff
#  
#  $Log: Makefile,v $
#  Revision 1.2  2006/05/01 21:04:36  jemartins
#  *** empty log message ***
#
#  Revision 1.1  2006/05/01 20:31:01  jemartins
#  test guivTcl
#
#  Revision 1.2  2006/04/29 21:30:29  jemartins
#  small test
#
#================================================
#

BIN_DIR=../bin

THIS_TARGET="starting"
DO_END=make -s title THIS_TARGET="$@ done"

#===================================
# entry point for simple make
#===================================
all:\
   title \
   $(BIN_DIR)/picoGUI.tcl
	@$(DO_END)

title:
	@echo merger $(THIS_TARGET)

#===================================
#  apply the filter
#===================================
$(BIN_DIR)/picoGUI.tcl: guivTcl.tcl topPart.tcl globalVars.tcl msgHandlers.tcl guiHandlers.tcl receiveUtils.tcl bottomPart.tcl
	@cat guivTcl.tcl | $(DRDAQ_HOME)/picoGUI/bin/fileJoiner > $(BIN_DIR)/picoGUI.tcl
	@echo "guivTcl.tcl -> picoGUI.tcl"
	chmod a+x $(BIN_DIR)/picoGUI.tcl
#=================================
# to force a total rebuild
#=================================
clobber:
	rm $(BIN_DIR)/picoGUI.tcl
	@$(DO_END)

#========================
# to move into master area
#========================
install:\
   title \
   $(BIN_DIR)/picoGUI.tcl
	@$(DO_END)
