#================================================
#	This software was developed by
#	iCanProgram Inc., Toronto, Canada
#
#   Makefile for mypico
#================================================
#
#$Log: Makefile,v $
#Revision 1.1.1.1  2006/03/07 21:29:22  bobfcsoft
#startup
#
#

PROJECT=drdaq
TASK=picoCourier

SRC_DIR=src
TEST_DIR=test

#===================================
# entry point for simple make
#===================================
all:
	@echo "$(PROJECT) $(TASK) build <all> starting"
	@echo `date`
	@cd $(SRC_DIR); make -i
	@cd $(TEST_DIR); make -i
	@echo "$(PROJECT) $(TASK) <all> done"
	@echo `date`

#=================================
# to force a total rebuild
#=================================
clobber:
	@echo "$(PROJECT) $(TASK) <clobber> starting"
	@cd $(SRC_DIR); make -s clobber
	@cd $(TEST_DIR); make -s clobber
	@echo "$(PROJECT) $(TASK) <clobber> done"

#========================
# to move into master area
#========================
install:
	@echo "$(PROJECT) $(TASK) build <install> starting"
	@echo `date`
	@cd $(SRC_DIR); make -i install
	@cd $(TEST_DIR); make -i install
	@echo "$(PROJECT) $(TASK) <install> done"
	@echo `date`
