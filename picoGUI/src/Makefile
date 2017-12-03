###############################################
#
# Makefile - for picoGUI
#
# NOTE:
# This make requires that Tcl8.0.x is installed
#
# Copyright (C) 2006 DrDAQ Application Project 
#
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
#
#$Log: Makefile,v $
#Revision 1.6  2006/07/24 00:15:47  jemartins
#added fileJoiner
#
#Revision 1.5  2006/05/02 13:46:25  jemartins
#new picoGUI
#
#Revision 1.4  2006/04/29 00:52:37  bobfcsoft
#fileJoiner added
#
#Revision 1.3  2006/03/24 02:09:10  bobfcsoft
#adjusted hardcoded start params
#
#Revision 1.2  2006/03/23 22:32:10  bobfcsoft
#code cleanup
#
#Revision 1.1.1.1  2006/03/07 21:29:31  bobfcsoft
#startup
#
#
###############################################

TCL_HOME=/home/tcl/tcl8.0.3

CC=cc
DE=NODEBUG

PROGRAM_NAME=
line1 = --------------------------------------------------------------------
line2 = ====================================================================

DEST_DIR=.

OBJ_DIR=obj
LIB_DIR=../lib
BIN_DIR=../bin
SIMPL_DIR=$(SIMPL_HOME)

INSTALL_LIB_DIR=$(SIMPL_DIR)/lib
INSTALL_BIN_DIR=../../bin

LOCAL_INCL_DIR=../include
INCL_DIR=$(SIMPL_DIR)/include
TCL_INCL_DIR=$(TCL_HOME)/generic

FILE_JOINER_OBJ=\
	$(OBJ_DIR)/fileJoiner.o

TCLSTIM_OBJ=\
	$(OBJ_DIR)/tclStim.o

TCLRECV_PARTS=\
	guivTcl.tcl \
	topPart.tcl \
	globalVars.tcl \
	msgHandlers.tcl \
	guiHandlers.tcl \
	receiveUtils.tcl \
	bottomPart.tcl

CDFLAGS=-c\
	-g\
	-Wall \
	-I $(LOCAL_INCL_DIR)\
	-I $(INCL_DIR)

LDFLAGS=\
	-L $(SIMPL_DIR)/lib\
	-lfclog\
	-lfcipc


#========================
# Default targets
#========================
all:\
     title \
     $(OBJ_DIR) \
     $(BIN_DIR) \
     $(LIB_DIR) \
     $(BIN_DIR)/fileJoiner\
     $(BIN_DIR)/picoGUI.tcl
	@echo picoGUI all

title:
	@echo picoGUI build starting

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
$(BIN_DIR)/fileJoiner:	$(FILE_JOINER_OBJ)
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) -o $(BIN_DIR)/fileJoiner $(FILE_JOINER_OBJ) 
	
$(BIN_DIR)/picoGUI.tcl: $(TCLRECV_PARTS)
#	cat $(TCLRECV_PARTS) > $(BIN_DIR)/picoGUI.tcl
	@cat guivTcl.tcl | $(BIN_DIR)/fileJoiner > $(BIN_DIR)/picoGUI.tcl
	chmod a+x $(BIN_DIR)/picoGUI.tcl

#========================
# Compiles
#========================
$(OBJ_DIR)/fileJoiner.o: fileJoiner.c
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/fileJoiner.o fileJoiner.c


#========================
# cleanup
#========================
clobber:
	@-rm -f $(OBJ_DIR)/*.o
	@-rm $(BIN_DIR)/picoGUI.tcl
	@-rm -f $(BIN_DIR)/fileMerger
	@-rm -f $(BIN_DIR)/fileJoiner
	@echo picoGUI clobber

#========================
# install
#========================
install:\
     title \
     $(OBJ_DIR) \
     $(BIN_DIR) \
     $(LIB_DIR) \
     $(BIN_DIR)/fileJoiner\
     $(BIN_DIR)/picoGUI.tcl
	cp $(BIN_DIR)/picoGUI.tcl $(INSTALL_BIN_DIR)/picoGUI.tcl
	@echo picoGUI install
