#================================================
#   Makefile
#================================================
##############################################################################
#
#    Copyright (C) 2006 DrDAQ Application Project.
#
#    This software is in the public domain.
#    Permission to use, copy, modify, and distribute this software and its
#    documentation for any purpose and without fee is hereby granted,
#    without any conditions or restrictions.
#    This software is provided "as is" without express or implied warranty.
#
#    If you discover a bug or add an enhancement here's how to reach us:
#
#        https://sourceforge.net/projects/drdaq
#
###############################################################################
# Revision history:
#
# $Log: Makefile,v $
# Revision 1.2  2006/05/31 14:11:48  jemartins
# removed installl
#
# Revision 1.1  2006/05/25 14:26:41  jemartins
# initial startup
#
###############################################################################

PROJECT=drdaq
TASK=graceUtils

SRC_DIR=src

#===================================
# entry point for simple make
#===================================
all:
	@echo "$(PROJECT) $(TASK) build <all> starting"
	@echo `date`
	@cd $(SRC_DIR); make -i
	@echo "$(PROJECT) $(TASK) <all> done"
	@echo `date`

#=================================
# to force a total rebuild
#=================================
clobber:
	@echo "$(PROJECT) $(TASK) <clobber> starting"
	@cd $(SRC_DIR); make -s clobber
	@echo "$(PROJECT) $(TASK) <clobber> done"

#========================
# to move into master area
#========================
install:
	@echo "$(PROJECT) $(TASK) build <install> starting"
	@echo `date`
	@cd $(SRC_DIR); make -i install
	@echo "$(PROJECT) $(TASK) <install> done"
	@echo `date`
