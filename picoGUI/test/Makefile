#=======================================================
#
# DESCRIPTION:	
# Makefile for picoGUI/test tree.
#
#-----------------------------------------------------------------------
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
#-----------------------------------------------------------------------
# Revision history:
#=======================================================
# $Log: Makefile,v $
# Revision 1.3  2006/05/27 12:31:17  jemartins
# added include drdaqMsgs.h
#
# Revision 1.2  2006/03/23 22:32:11  bobfcsoft
# code cleanup
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
LIB_DIR=../lib

INSTALL_BIN_DIR=$(SOFT_IC_DIR)/bin
INSTALL_LIB_DIR=$(SOFT_IC_DIR)/lib

LOCAL_INCL_DIR=../include
SIMPL_INCL_DIR=$(SIMPL_DIR)/include
PICOMGR_INCL_DIR=../../include

GUISTIM_OBJ=\
	$(OBJ_DIR)/guiStim.o\
	$(OBJ_DIR)/guiStimInit.o\
	$(OBJ_DIR)/guiStimUtils.o

PICOMGR_SIM_OBJ = \
	$(OBJ_DIR)/picoMgrSimulator.o\
	$(OBJ_DIR)/picoMgrSimulatorInit.o\
	$(OBJ_DIR)/picoMgrSimulatorUtils.o


CDFLAGS=\
	-c\
	-g\
	-Wall\
        -I $(LOCAL_INCL_DIR)\
        -I $(PICOMGR_INCL_DIR)\
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
     $(OBJ_DIR) \
     $(BIN_DIR) \
     $(BIN_DIR)/picoMgrSimulator
	@$(DO_END)

title:
	@echo "=============== picoGUI/test $(THIS_TARGET) ================"

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

$(LIB_DIR):
	mkdir ../lib
	chmod a+w ../lib

#========================
# Link
#========================
$(BIN_DIR)/guiStim:	$(GUISTIM_OBJ)
	$(CC) -o $(BIN_DIR)/guiStim $(GUISTIM_OBJ) $(LDFLAGS)

$(BIN_DIR)/picoMgrSimulator: $(PICOMGR_SIM_OBJ)
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) -o $(BIN_DIR)/picoMgrSimulator $(PICOMGR_SIM_OBJ) $(LDFLAGS)

#===================
# Compiles
#===================
$(OBJ_DIR)/picoMgrSimulator.o: picoMgrSimulator.c
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/picoMgrSimulator.o picoMgrSimulator.c

$(OBJ_DIR)/picoMgrSimulatorInit.o: picoMgrSimulatorInit.c
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/picoMgrSimulatorInit.o picoMgrSimulatorInit.c

$(OBJ_DIR)/picoMgrSimulatorUtils.o: picoMgrSimulatorUtils.c
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/picoMgrSimulatorUtils.o picoMgrSimulatorUtils.c

$(OBJ_DIR)/guiStim.o: guiStim.c
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/guiStim.o guiStim.c

$(OBJ_DIR)/guiStimInit.o: guiStimInit.c
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/guiStimInit.o guiStimInit.c

$(OBJ_DIR)/guiStimUtils.o: guiStimUtils.c
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/guiStimUtils.o guiStimUtils.c

#===================
# Cleanup
#===================
clobber:
	@-rm -f $(OBJ_DIR)/*.o
	@-rm -f $(LIB_DIR)/*.a
	@-rm -f $(BIN_DIR)/picoMgrSimulator
	@$(DO_END)

#===================
# Install
#===================
install:\
     title \
     $(OBJ_DIR) \
     $(BIN_DIR) \
     $(BIN_DIR)/picoMgrSimulator
	@$(DO_END)
