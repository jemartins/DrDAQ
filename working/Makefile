#================================================
#  Makefile for merged vTcl and Tcl stuff
#  
#  $Log: Makefile,v $
#  Revision 1.2  2006/04/29 21:30:29  jemartins
#  small test
#
#================================================
#

BIN_DIR=bin

THIS_TARGET="starting"
DO_END=make -s title THIS_TARGET="$@ done"

#===================================
# entry point for simple make
#===================================
all:\
   title \
   $(BIN_DIR)/jsmall.tcl
	@$(DO_END)

title:
	@echo merger $(THIS_TARGET)

#===================================
#  apply the filter
#===================================
$(BIN_DIR)/jsmall.tcl: small.tcl topPart.tcl smallInit.tcl
	@cat small.tcl | $(DRDAQ_HOME)/picoGUI/bin/fileJoiner > $(BIN_DIR)/jsmall.tcl
	@echo "small.tcl -> jsmall.tcl"
	chmod a+x $(BIN_DIR)/jsmall.tcl
#=================================
# to force a total rebuild
#=================================
clobber:
	rm $(BIN_DIR)/jsmall.tcl
	@$(DO_END)

#========================
# to move into master area
#========================
install:\
   title \
   $(BIN_DIR)/jsmall.tcl
	@$(DO_END)
