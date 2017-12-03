#=======================================================
#
# DESCRIPTION:	
# Makefile for picoCourier/test tree.
#
# AUTHOR:	R.D. Findlay
#
#-----------------------------------------------------------------------
#    Copyright (C) 2006 FCSoftware Inc. 
#
#    This software is in the public domain.
#    Permission to use, copy, modify, and distribute this software and its
#    documentation for any purpose and without fee is hereby granted, 
#    without any conditions or restrictions.
#    This software is provided "as is" without express or implied warranty.
#
#    If you discover a bug or add an enhancement here's how to reach us: 
#
#	fcsoft@allstream.net
#-----------------------------------------------------------------------
# Revision history:
#=======================================================
# $Log: Makefile,v $
# Revision 1.1.1.1  2006/03/07 21:29:22  bobfcsoft
# startup
#
#
#=======================================================
#
#=======================================================

SOFT_IC_DIR=../..
SIMPL_DIR=$(SIMPL_HOME)

CC=cc

PROGRAM_NAME=
line1 = --------------------------------------------------------------------

OBJ_DIR=obj
BIN_DIR=../bin

INSTALL_LIB_DIR=$(SOFT_IC_DIR)/lib
INSTALL_BIN_DIR=$(SOFT_IC_DIR)/bin

LOCAL_INCL_DIR=../include
PICOMGR_INCL_DIR=../../picoMgr/include
SIMPL_INCL_DIR=$(SIMPL_DIR)/include

PICOMGR_SIM_OBJ=\
	$(OBJ_DIR)/picoMgrSim.o\
	$(OBJ_DIR)/picoMgrSimInit.o\
	$(OBJ_DIR)/picoMgrSimUtils.o

GUI_SIM_OBJ=\
	$(OBJ_DIR)/guiSim.o\
	$(OBJ_DIR)/guiSimInit.o

CDFLAGS=\
	-c\
	-g\
	-Wall\
        -I $(LOCAL_INCL_DIR)\
        -I $(PICOMGR_INCL_DIR)\
        -I $(SIMPL_INCL_DIR)

LDFLAGS=\
	-L $(SIMPL_DIR)/lib\
	-lsimpllog\
	-lsimpl\
	-lsimplmisc

THIS_TARGET="starting"
DO_END=make -s title THIS_TARGET="<$@> done"

#========================
# Default targets
#========================
all:\
     title \
     $(OBJ_DIR) \
     $(BIN_DIR) \
     $(BIN_DIR)/picoMgrSim\
     $(BIN_DIR)/guiSim
	@$(DO_END)

title:
	@echo "=============== picoCourier/test $(THIS_TARGET) ================"

description:
	@(\
	echo;\
	echo "$(line1)";\
	echo "Compiling $(PROGRAM_NAME) -> $(OBJ_NAME)";\
	echo )

$(OBJ_DIR):
	mkdir obj
	chmod a+w obj

$(BIN_DIR):
	mkdir ../bin
	chmod a+w ../bin

#========================
# Link
#========================
$(BIN_DIR)/picoMgrSim:	$(PICOMGR_SIM_OBJ)
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) -o $(BIN_DIR)/picoMgrSim $(PICOMGR_SIM_OBJ) $(LDFLAGS)
	
$(BIN_DIR)/guiSim:	$(GUI_SIM_OBJ)
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) -o $(BIN_DIR)/guiSim $(GUI_SIM_OBJ) $(LDFLAGS)
	
#========================
# Compiles
#========================
$(OBJ_DIR)/guiSim.o: guiSim.c
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/guiSim.o guiSim.c

$(OBJ_DIR)/guiSimInit.o: guiSimInit.c
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/guiSimInit.o guiSimInit.c

$(OBJ_DIR)/sendStimUtils.o: sendStimUtils.c
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/sendStimUtils.o sendStimUtils.c

$(OBJ_DIR)/picoMgrSim.o: picoMgrSim.c
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/picoMgrSim.o picoMgrSim.c

$(OBJ_DIR)/picoMgrSimInit.o: picoMgrSimInit.c
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/picoMgrSimInit.o picoMgrSimInit.c

$(OBJ_DIR)/picoMgrSimUtils.o: picoMgrSimUtils.c
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/picoMgrSimUtils.o picoMgrSimUtils.c

#========================
# Cleanup
#========================
clobber:
	@-rm -f $(OBJ_DIR)/*.o
	@-rm -f $(BIN_DIR)/*.a
	@$(DO_END)

#========================
# Install
#========================
install:\
     title \
     $(OBJ_DIR) \
     $(BIN_DIR) \
     $(BIN_DIR)/picoMgrSim\
     $(BIN_DIR)/guiSim
	cp $(BIN_DIR)/picoMgrSim $(INSTALL_BIN_DIR)/picoMgrSim
	cp $(BIN_DIR)/guiSim $(INSTALL_BIN_DIR)/guiSim
	@$(DO_END)
