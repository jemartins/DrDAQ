#=======================================================
#
# DESCRIPTION:	
# Makefile for softwareICs/courier/src tree.
#
# AUTHOR:	R.D. Findlay
#
#-----------------------------------------------------------------------
#    Copyright (C) 2000, 2002 FCSoftware Inc. 
#
#    This software is in the public domain.
#    Permission to use, copy, modify, and distribute this software and its
#    documentation for any purpose and without fee is hereby granted, 
#    without any conditions or restrictions.
#    This software is provided "as is" without express or implied warranty.
#
#    If you discover a bug or add an enhancement here's how to reach us: 
#
#	fcsoft@attcanada.ca
#-----------------------------------------------------------------------
# Revision history:
#=======================================================
# $Log: Makefile,v $
# Revision 1.1.1.1  2006/03/07 21:29:22  bobfcsoft
# startup
#
# Revision 1.2  2002/12/03 21:15:28  root
# v2.0 compatible
#
# Revision 1.1  2002/12/03 19:13:01  root
# Initial revision
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
PICOMGR_INCL_DIR=../../picoMgr/include
SIMPL_INCL_DIR=$(SIMPL_DIR)/include

PICOCOURIER_OBJ=\
	$(OBJ_DIR)/picoCourier.o\
	$(OBJ_DIR)/picoCourierInit.o

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
     $(BIN_DIR)/picoCourier
	@$(DO_END)

title:
	@echo "=============== courier/src $(THIS_TARGET) ================"

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
$(BIN_DIR)/picoCourier:	$(PICOCOURIER_OBJ)
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) -o $(BIN_DIR)/picoCourier $(PICOCOURIER_OBJ) $(LDFLAGS)

#===================
# Compiles
#===================
$(OBJ_DIR)/picoCourier.o: picoCourier.c
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/picoCourier.o picoCourier.c

$(OBJ_DIR)/picoCourierInit.o: picoCourierInit.c
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/picoCourierInit.o picoCourierInit.c

#===================
# Cleanup
#===================
clobber:
	@-rm -f $(OBJ_DIR)/*.o
	@-rm -f $(LIB_DIR)/*.a
	@$(DO_END)

#===================
# Install
#===================
install:\
     title \
     $(OBJ_DIR) \
     $(BIN_DIR) \
     $(BIN_DIR)/picoCourier
	cp $(BIN_DIR)/picoCourier $(INSTALL_BIN_DIR)/picoCourier
	@$(DO_END)
