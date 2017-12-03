#===========================================================
#
#	This software was developed for
#	iCanProgram Inc., Toronto, Canada
#
# Makefile - for mypico/picoMgr-2.4/test
#
#==============================================
# Revision History
# $Log: Makefile,v $
# Revision 1.3  2006/03/20 22:19:49  bobfcsoft
# added START functionality
#
# Revision 1.2  2006/03/15 20:26:22  bobfcsoft
# added guiStim
#
# Revision 1.1  2006/03/13 20:45:40  bobfcsoft
# separate Linux 2.4 version
#
# Revision 1.1.1.1  2006/03/07 21:29:47  bobfcsoft
# startup
#
#===========================================================

CPLEX_DIR=../..
SIMPL_DIR=$(SIMPL_HOME)

CC=cc

PROGRAM_NAME=
line1 = --------------------------------------------------------------------

OBJ_DIR=obj
BIN_DIR=../bin
LIB_DIR=../lib

INSTALL_LIB_DIR=$(CPLEX_DIR)/lib
INSTALL_BIN_DIR=$(CPLEX_DIR)/bin

LOCAL_INCL_DIR=../include
PICOMGR_INCL_DIR=../../picoMgr/include
INCL_DIR=$(CPLEX_DIR)/include
SIMPL_INCL_DIR=$(SIMPL_DIR)/include

PICO_STIM_OBJ=\
	$(OBJ_DIR)/picoStim.o\
	$(OBJ_DIR)/picoStimInit.o\
	$(OBJ_DIR)/picoStimUtils.o

GUI_STIM_OBJ=\
	$(OBJ_DIR)/guiStim.o\
	$(OBJ_DIR)/guiStimInit.o\
	$(OBJ_DIR)/guiStimUtils.o

CDFLAGS=\
	-c\
	-g\
	-Wall\
        -I $(LOCAL_INCL_DIR)\
        -I $(PICOMGR_INCL_DIR)\
        -I $(INCL_DIR)\
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
     $(BIN_DIR)/picoStim\
     $(BIN_DIR)/guiStim
	@$(DO_END)

title:
	@echo "============== picoMgr/test $(THIS_TARGET) ================"

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
$(BIN_DIR)/picoStim:	$(PICO_STIM_OBJ)
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) -o $(BIN_DIR)/picoStim $(PICO_STIM_OBJ) $(LDFLAGS)
	
$(BIN_DIR)/guiStim:	$(GUI_STIM_OBJ)
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) -o $(BIN_DIR)/guiStim $(GUI_STIM_OBJ) $(LDFLAGS)
	
#========================
# Compiles
#========================
$(OBJ_DIR)/picoStim.o: picoStim.c
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/picoStim.o picoStim.c

$(OBJ_DIR)/picoStimInit.o: picoStimInit.c
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/picoStimInit.o picoStimInit.c

$(OBJ_DIR)/picoStimUtils.o: picoStimUtils.c
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/picoStimUtils.o picoStimUtils.c

$(OBJ_DIR)/guiStim.o: guiStim.c
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/guiStim.o guiStim.c

$(OBJ_DIR)/guiStimInit.o: guiStimInit.c
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/guiStimInit.o guiStimInit.c

$(OBJ_DIR)/guiStimUtils.o: guiStimUtils.c
	@make -s description PROGRAM_NAME="$<" OBJ_NAME="$@"
	$(CC) $(CDFLAGS) -o $(OBJ_DIR)/guiStimUtils.o guiStimUtils.c

#========================
# Cleanup
#========================
clobber:
	@-rm -f $(OBJ_DIR)/*.o
	@-rm -f $(BIN_DIR)/picoStim
	@-rm -f $(BIN_DIR)/guiStim
	@$(DO_END)

#========================
# Install
#========================
install:\
     title \
     $(OBJ_DIR) \
     $(BIN_DIR) \
     $(BIN_DIR)/picoStim\
     $(BIN_DIR)/guiStim
	@$(DO_END)
