##################################
#
#  Makefile para o DrDAQ&Grace
#
#  script para criar as bibliotecas libgrace.so e libdrdaq.so 
#  com o swig e rodar no tcl/tk voce vai precisar 
#  do swig e do grace-devel
#
#  Revision history:
#  $Log: Makefile,v $
#  Revision 1.3  2006/05/02 15:12:52  jemartins
#  added libgrace.so libdrdaq.so
#
#  Revision 1.2  2006/03/16 12:04:51  jemartins
#  inicial revision
#
##################################

FREEWRAP_DIR=/usr/lib/vtcl-1.6.0/Freewrap/bin
SWIG_DIR=/usr/local/bin
DRDAQ_DIR=$(HOME)/DrDAQ

all: drdaq.tcl grace drdaq
	@echo all feito

clobber:
	rm drdaq *wrap.* *.o *.so *~*
	@echo arquivos removidos

install:
	install -d $(DRDAQ_DIR)
	install -d $(DRDAQ_DIR)/tmp/
	install -d $(DRDAQ_DIR)/lib/
	install -m 0755 -c drdaq $(DRDAQ_DIR)/drdaq
	install -m 0755 -c lib/libdrdaq.so $(DRDAQ_DIR)/lib/drdaq.so
	install -m 0755 -c lib/libgrace.so $(DRDAQ_DIR)/lib/grace.so
	@echo "Arquivos binarios copiados para $(DRDAQ_DIR)"
	
drdaq.tcl: drdaq.tcl
	$(FREEWRAP_DIR)/freewrap drdaq.tcl
	@echo "drdaq foi atualizado"
	
grace: grace.c grace.i
	$(SWIG_DIR)/swig -tcl grace.i
	gcc  -fpic -c grace.c grace_wrap.c
	gcc -shared grace.o grace_wrap.o -o lib/libgrace.so -lgrace_np
	@echo grace.so feito

drdaq: drdaq.c drdaq.i
	$(SWIG_DIR)/swig -tcl drdaq.i
	gcc -fpic -c drdaq.c drdaq_wrap.c
	gcc -shared drdaq.o drdaq_wrap.o -o lib/libdrdaq.so
	@echo drdaq.so feito

