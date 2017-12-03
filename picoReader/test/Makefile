#=======================================================================
#
# FILE:			Makefile
#
# DESCRIPTION:	This is the local test make file.
#
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
# Revision history:
# ======================================================================
# $Log: Makefile,v $
# Revision 1.4  2006/05/27 12:29:10  jemartins
# added include drdaqMsgs.h
#
# Revision 1.3  2006/04/25 21:34:30  bobfcsoft
# GUI stub added
#
# Revision 1.2  2006/03/22 23:15:15  bobfcsoft
# added messaging framework
#
# Revision 1.1  2006/03/15 20:14:09  bobfcsoft
# seed code
#
#
#=======================================================================

#====================================================================
# definitions
#====================================================================

SIMPL_DIR=$(SIMPL_HOME)

CC = cc

OBJ_DIR = ./obj
LIB_DIR = ../lib
INC_DIR = ../include
BIN_DIR = ../bin

PICOMGR_INCL_DIR=../../include
SIMPL_INCL_DIR=$(SIMPL_DIR)/include

PICOMGR_SIM_OBJ = \
	$(OBJ_DIR)/picoMgrSimulator.o\
	$(OBJ_DIR)/picoMgrSimulatorInit.o\
	$(OBJ_DIR)/picoMgrSimulatorUtils.o

PICOGUI_SIM_OBJ = \
	$(OBJ_DIR)/picoGUISimulator.o\
	$(OBJ_DIR)/picoGUISimulatorInit.o\
	$(OBJ_DIR)/picoGUISimulatorUtils.o

CDFLAGS =\
	-c\
	-O\
	-Wall\
	-I$(INC_DIR)\
	-I$(PICOMGR_INCL_DIR)\
	-I$(SIMPL_INCL_DIR)

LDFLAGS=\
	-L $(SIMPL_DIR)/lib\
	-lsimpllog\
	-lsimpl\
	-lsimplmisc


#=====================================================================
# Default targets
#=====================================================================
all: \
	title \
	$(OBJ_DIR) \
	$(BIN_DIR) \
	$(BIN_DIR)/picoMgrSimulator\
	$(BIN_DIR)/picoGUISimulator
	@echo picoReader/test all

title:
	@echo picoReader/test build starting

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
$(BIN_DIR)/picoGUISimulator: $(PICOGUI_SIM_OBJ)
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) -o $(BIN_DIR)/picoGUISimulator $(PICOGUI_SIM_OBJ) $(LDFLAGS)

$(BIN_DIR)/picoMgrSimulator: $(PICOMGR_SIM_OBJ)
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) -o $(BIN_DIR)/picoMgrSimulator $(PICOMGR_SIM_OBJ) $(LDFLAGS)

#===================
# Compiles
#===================
$(OBJ_DIR)/picoGUISimulator.o: picoGUISimulator.c
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/picoGUISimulator.o picoGUISimulator.c

$(OBJ_DIR)/picoGUISimulatorInit.o: picoGUISimulatorInit.c
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/picoGUISimulatorInit.o picoGUISimulatorInit.c

$(OBJ_DIR)/picoGUISimulatorUtils.o: picoGUISimulatorUtils.c
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/picoGUISimulatorUtils.o picoGUISimulatorUtils.c

$(OBJ_DIR)/picoMgrSimulator.o: picoMgrSimulator.c
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/picoMgrSimulator.o picoMgrSimulator.c

$(OBJ_DIR)/picoMgrSimulatorInit.o: picoMgrSimulatorInit.c
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/picoMgrSimulatorInit.o picoMgrSimulatorInit.c

$(OBJ_DIR)/picoMgrSimulatorUtils.o: picoMgrSimulatorUtils.c
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/picoMgrSimulatorUtils.o picoMgrSimulatorUtils.c

#===================
#  clobber 
#===================
clobber: clean
clean:
	@-rm -f $(OBJ_DIR)/*.o
	@-rm -f $(BIN_DIR)/picoMgrSimulator
	@-rm -f $(BIN_DIR)/picoGUISimulator
	@echo picoReader/test clobber

install: \
    title \
    $(OBJ_DIR) \
    $(BIN_DIR) \
    $(BIN_DIR)/picoMgrSimulator\
    $(BIN_DIR)/picoGUISimulator
	@echo picoReader/test install

