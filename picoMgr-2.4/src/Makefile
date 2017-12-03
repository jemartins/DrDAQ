###############################################
#
#	This software was developed by
#	iCanProgram Inc., Toronto, Canada
#
# Makefile - for  mypico/picoMgr/src
#
#
#$Log: Makefile,v $
#Revision 1.3  2006/03/20 22:19:49  bobfcsoft
#added START functionality
#
#Revision 1.2  2006/03/13 20:50:40  bobfcsoft
#some cleanup
#
#Revision 1.1  2006/03/13 20:45:39  bobfcsoft
#separate Linux 2.4 version
#
#Revision 1.1.1.1  2006/03/07 21:29:47  bobfcsoft
#startup
#
#
###############################################

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
INSTALL_BIN_DIR=../../bin

LOCAL_INCL_DIR=../include
PICOMGR_INCL_DIR=../../picoMgr/include
INCL_DIR=../../include
PICO_INCL_DIR=../../../pico
SIMPL_INCL_DIR=$(SIMPL_DIR)/include

PICO_MGR_OBJECT =\
	$(OBJ_DIR)/picoMgr.o\
	$(OBJ_DIR)/picoMgrInit.o\
	$(OBJ_DIR)/picoMgrUtils.o

CDFLAGS=-c\
	-Wall \
	-I $(LOCAL_INCL_DIR)\
	-I $(PICOMGR_INCL_DIR)\
	-I $(INCL_DIR)\
	-I $(PICO_INCL_DIR)\
	-I $(SIMPL_INCL_DIR)

LDFLAGS=\
	-L $(SIMPL_DIR)/lib\
	-lsimpl\
	-lsimplmisc\
	-lsimpllog

#========================
# Default targets
#========================
all:\
     title \
     $(OBJ_DIR) \
     $(BIN_DIR) \
     $(BIN_DIR)/picoMgr
	@echo picoMgr all

title:
	@echo picoMgr/src build starting

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
$(BIN_DIR)/picoMgr: $(PICO_MGR_OBJECT)
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) -o $(BIN_DIR)/picoMgr $(PICO_MGR_OBJECT) $(LDFLAGS)

#========================
# Compiles
#========================
$(OBJ_DIR)/picoMgr.o : picoMgr.c
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/picoMgr.o picoMgr.c

$(OBJ_DIR)/picoMgrInit.o : picoMgrInit.c
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/picoMgrInit.o picoMgrInit.c

$(OBJ_DIR)/picoMgrUtils.o : picoMgrUtils.c
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/picoMgrUtils.o picoMgrUtils.c

$(OBJ_DIR)/rpcFuncs.o : rpcFuncs.c
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/rpcFuncs.o rpcFuncs.c

#========================
# cleanup
#========================
clobber:
	@-rm -f $(OBJ_DIR)/*.o
	@-rm -f $(BIN_DIR)/*
	@echo picoMgr/src clobber

#========================
# install
#========================
install:\
     title \
     $(OBJ_DIR) \
     $(BIN_DIR) \
     $(BIN_DIR)/picoMgr
	cp $(BIN_DIR)/picoMgr $(INSTALL_BIN_DIR)/picoMgr
	@echo picoMgr/src install

#========================================
# build locally and link local db libary
#========================================
local:\
     title \
     $(OBJ_DIR) \
     $(BIN_DIR) \
     $(LIB_DIR) \
     $(BIN_DIR)/picoMgr
	@$(DO_END)
