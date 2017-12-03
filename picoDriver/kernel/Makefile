
KERNEL_VERSION = `uname -r`
KERNELDIR := /lib/modules/$(KERNEL_VERSION)/build
MODULE_INSTALLDIR=/lib/modules/$(KERNEL_VERSION)/kernel/drivers/parport
PWD := $(shell pwd)

all : kernel
	$(MAKE) -C $(KERNELDIR) SUBDIRS=$(PWD) modules
.PHONY : all

kernel: 
obj-m += picopar.o
picopar-objs :=  picolnx.o drdaqscl.o
.PHONY : kernel

install:
	install -m 0644 -c picopar.ko $(MODULE_INSTALLDIR)
	/sbin/depmod -ae
.PHONY : install

uninstall:
	rm -f $(MODULE_INSTALLDIR)/picopar.ko
	/sbin/depmod -aq
.PHONY : uninstall

clean:
	rm -rf *.o *.ko picopar.mod.c .*.cmd *~* .* Module.symvers
	chmod 644 *
.PHONY : clean
