########################################################################
#
#  Makefile para o DrDAQ&Grace
#
#  script para criar a biblioteca libgrace.so 
#  voce vai precisar do swig e do grace-devel
#
#########################################################################

#########################################################################
#
#    Copyright (C) 2006 DrDAQ Application Project.
#
#   This software is in the public domain.
#    Permission to use, copy, modify, and distribute this software and its
#    #    documentation for any purpose and without fee is hereby granted,
#    without any conditions or restrictions.
#    #    This software is provided "as is" without express or implied warranty.
#
#    If you discover a bug or add an enhancement here's how to reach us:
#
#        https://sourceforge.net/projects/drdaq
#
###########################################################################

###########################################################################
#  Revision history:
#  
#  $Log: Makefile,v $
#  Revision 1.10  2008/07/22 15:18:28  jemartins
#  change name to graceutils
#
#  Revision 1.9  2006/12/06 11:01:25  jemartins
#  changed swig path
#
#  Revision 1.8  2006/07/09 21:01:24  jemartins
#  *** empty log message ***
#
#  Revision 1.7  2006/06/07 12:06:43  jemartins
#  changes in SetSimbolo
#
#  Revision 1.6  2006/06/02 14:16:07  jemartins
#  changes in install
#
#  Revision 1.5  2006/06/01 18:33:45  jemartins
#  *** empty log message ***
#
#  Revision 1.4  2006/05/30 21:30:42  jemartins
#  changes in target
#
#  Revision 1.3  2006/05/26 20:32:02  jemartins
#  *** empty log message ***
#
#  Revision 1.2  2006/05/17 21:16:59  jemartins
#  added Copyright
#
#  Revision 1.1  2006/05/17 20:30:45  jemartins
#  *** empty log message ***
#
###########################################################################

SWIG_DIR=/usr/bin
LIBGRACE_DIR=../lib
LIB_DIR=../../lib

all: graceutils_wrap.c graceutils_wrap.o
	@echo all done 

clobber:
	@-rm -f $(LIBGRACE_DIR)/libgrace.so.0
	@-rm -f $(LIB_DIR)/libgrace.so.0
	@-rm -f drdaq *wrap.* *.o *.so* *~* 
	@echo all files removed

install:
	@install -d $(LIBGRACE_DIR)
	cp libgrace.so.0 $(LIBGRACE_DIR)/libgrace.so.0
	cp libgrace.so.0 $(LIB_DIR)/libgrace.so.0
	@echo "copied libgrace.so.0" 
	
graceutils_wrap.c: graceutils.i
	$(SWIG_DIR)/swig -tcl graceutils.i
	@echo created graceutils_wrap.c
graceutils_wrap.o: graceutils.c
	gcc  -fpic -c graceutils.c graceutils_wrap.c
	@echo created graceutils_wrap.o
	gcc -shared graceutils.o graceutils_wrap.o -o libgrace.so.0 -lgrace_np
	@echo created libgrace.so.0

