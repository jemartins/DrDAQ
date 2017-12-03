#===============================================================
#
# Makefile   - for picoReader/src 
#

#########################################################################
#
##    Copyright (C) 2006 DrDAQ Application Project.
#
##   This software is in the public domain.
#    Permission to use, copy, modify, and distribute this software and its
#    #    documentation for any purpose and without fee is hereby granted,
#    without any conditions or restrictions.
#    #    This software is provided "as is" without express or implied warranty.
#
##    If you discover a bug or add an enhancement here's how to reach us:
#
##        https://sourceforge.net/projects/drdaq
#
###########################################################################

###########################################################################
# Revison history:
# 
# $Log: Makefile,v $
# Revision 1.7  2010/02/22 22:16:16  jemartins
# added case XY in doReadings
#
# Revision 1.6  2007/06/06 18:36:14  jemartins
# added ANGLE case
#
# Revision 1.5  2006/05/26 19:41:25  jemartins
# added new blocks
#
# Revision 1.4  2006/05/15 18:02:12  jemartins
# added Copyright
#
# Revision 1.3  2006/05/05 12:41:23  jemartins
# added graceUtils.tcl
#
# Revision 1.2  2006/03/22 23:15:13  bobfcsoft
# added messaging framework
#
# Revision 1.1  2006/03/15 20:14:08  bobfcsoft
# seed code
#
#===============================================================

PROGRAM_NAME=
line1 = --------------------------------------------------------------------
line2 = ====================================================================

CC=cc

DEST_DIR=.

OBJ_DIR=obj
BIN_DIR=../bin
LIB_DIR=../lib
SIMPL_DIR=$(SIMPL_HOME)

INSTALL_BIN_DIR=../../bin
LOCAL_INCL_DIR=../include
IOALIB_INCL_DIR=../../library/include
SIMPL_INCL_DIR=$(SIMPL_DIR)/include


READER_PARTS=\
	topPart.tcl\
	globalVars.tcl\
	miscUtils.tcl\
	graceUtils.tcl\
	lightUtils.tcl \
	phUtils.tcl \
	resistanceUtils.tcl \
	soundUtils.tcl \
	temperatureUtils.tcl \
	voltageUtils.tcl \
	waveUtils.tcl \
	angleUtils.tcl \
	XYUtils.tcl \
	bottomPart.tcl

CDFLAGS=\
	-c\
	-Wall\
        -I $(LOCAL_INCL_DIR)\
        -I $(IOALIB_INCL_DIR)\
        -I $(SIMPL_INCL_DIR)

LDFLAGS=\
	-L $(SIMPL_DIR)/lib\
	-lsimplmisc\
	-lsimpllog\
	-lsimpl

THIS_TARGET="starting"
DO_END=make -s title THIS_TARGET="<$@> done"

#========================
# Default targets
#========================
all:\
     title \
     $(OBJ_DIR)\
     $(BIN_DIR)\
     $(BIN_DIR)/picoReader.tcl
	@$(DO_END)

title:
	@echo Preparing DrDAQ picoReader ...

description:
	@(\
	echo;\
	echo "$(line1)";\
	echo "Compiling $(PROGRAM_NAME) module -> $<";\
	echo )

$(OBJ_DIR):
	mkdir obj
	chmod a+w obj

$(BIN_DIR):
	mkdir ../bin
	chmod a+w ../bin

$(LIB_DIR):
	mkdir ../lib
	chmod a+w ../lib

#========================
# Link
#========================

$(BIN_DIR)/picoReader.tcl: $(READER_PARTS)
	cat $(READER_PARTS) > $(BIN_DIR)/picoReader.tcl
	chmod a+x $(BIN_DIR)/picoReader.tcl

#===================
# Compiles
#===================

#========================
# cleanup
#========================
clobber:\
	title
	@-rm -f $(OBJ_DIR)/*.o
	@-rm $(BIN_DIR)/picoReader.tcl
	@$(DO_END)

#========================
# install
#========================
install:\
     title \
     $(OBJ_DIR) \
     $(BIN_DIR)\
     $(BIN_DIR)/picoReader.tcl
	cp $(BIN_DIR)/picoReader.tcl $(INSTALL_BIN_DIR)/picoReader.tcl
	@$(DO_END)
