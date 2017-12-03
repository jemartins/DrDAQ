Pico Technology Parallel port drivers
for Linux Kernel 2.6
======================================

Introduction
------------

This document covers the following PICO products:
        ADC-10
        ADC-11
        ADC-12
        ADC-22
        ADC-40
        ADC-42
        ADC-100
        ADC-101
        
They have been tested with:
	Mandrake 10.1
    Kernel 2.6.8.1-10mdk         


Building
--------

Once you have un-tared the files, you can build the kernel driver and
example programs by typing in the command
    make

You MUST be root to do this.

You can make a fresh start with
    make clean

You can rpackage the tar file with
    make tar

Adding the Pico kernel driver
-----------------------------

The kernel module is called picopar.ko. to install the driver, log on as root and
then enter the following commands:

    sync;sync
    cp kernel/picopar.ko /usr/local/sbin
    insmod /usr/local/sbin/picopar.ko

The first line makes sure that your disks are safely tucked in before
you make any changes to the kernel...

the commands lsmod and rmmod may be useful to inspect installable drivers
and remove them.

This (bash) command can be used to conditionally load the module; typically
you might add this into /etc/rc.local to load the module at boot time.

    [ -z "$(lsmod|grep -E '^picopar +')" ] && insmod /usr/local/sbin/picopar.ko


Add a device for each printer port
----------------------------------

The kernel driver is accessed by three device entries in /dev, one for each
printer port. To create the device drivers, log on as root and then type in
the following commands:

    mknod /dev/picopar0 c 242 0
    mknod /dev/picopar1 c 242 1
    mknod /dev/picopar2 c 242 2

(If you have edited pico_lnx.h, change accordingly.)

Note: picopar0 corresponds to 0x378
      picopar1 corresponds to 0x278
      picopar2 corresponds to 0x3BC

If the driver module will not load or the devices /dev/picopar* are already
used for other purposes (unlikely), or the application programs below will not
run, review and if necessary change the #defines in pico_lnx.h, and run make
again.

Application programs
--------------------

Application programs call the driver by opening one of the three printer
devices and then sending ioctl commands to it. The list of valid IOCTL functions,
and their respective parameters, is defined at the start of the example
programs described below.

IOCTL_PICO_GET_VERSION - get the version number of the kernel driver
IOCTL_PICO_SET_PRODUCT - specify what product to use (eg 12 for the ADC-12)
IOCTL_PICO_SET_VERSION - set the product version (not normally necessary)
IOCTL_PICO_SET_DIGITAL_OUT - set the digital output on ADC11, ADC22 and DrDAQ
IOCTL_PICO_SET_RANGE - set the input voltage range for ADC100, or detect input for DrDAQ EXT1,EXT2
IOCTL_PICO_SET_READ_MODE - set for single or double reads (see below)
IOCTL_PICO_GET_VALUE - get a value- in either ADC counts or mV (accepts a channel no for ADC11,22,100,DrDAQ)
IOCTL_PICO_SET_SCALE - specify whether GET_VALUE should return ADC counts or mV

The analog to digital converters used in Pico products do not simply do a
conversion every time you ask. Each time you ask, they return the result of
the previous conversion, then take a new sample: the sample is converted IN BETWEEN
two requests for data.

In single read mode, the result returned is the result of the PREVIOUS conversion,
which was sampled during the previous IOCTL.
With double read mode, the result returned is the result of the first of two conversions,
ie it is a reading taken during the current IOCTL.

The port numbers may not be what you expect: they relate to the base address of the
printer port.
        0 - 0x378
        1 - 0x278
        2 - 0x3BC

Example programs
----------------

The following example programs are available:
        a10test.c - ADC-10, ADC-12, ADC-40 and ADC-42
        a11test.c - ADC-11 and ADC-22
        a100test.c - ADC-100 and ADC-101
        ddtest.c - DrDAQ

Each example program first asks for a port number: some also ask for a product
number, for example 11 for the ADC11. The program then gives a list of options
that demonstrate the various ways of using the program. The following options
are available:
        select ADC values or mV output
        collect data continuously at low speed and write to file and screen
        collect data at high speed and then write to a file
        measure how long it takes to collect 1000 readings at high speed
        set the digital output on ADC11, ADC22 (and LED on DrDAQ)
        set input voltage range on ADC100




Foreword to Perl Script and Picoread
-------------------------------------------
Many thanks for the perl examples and the c example picoread
by J Hunt. His notes on the examples amd driver are as follows:


Program picoread is my own (GPL'd) for making a single
reading from an ADC10-family and writing it to stdout.
It is intended to be called from a perl or bash script
in a data logging application.

Directory perl contains two programs of my own:
    adc42test.pl    A proof-of-concept program to
                    read an ADC42 without resorting
                    to calling a C program. (You 
                    must cd to the perl directory
                    before running this.)
    picologger.pl   A simple data logger for the
                    ADC42 that works by calling
                    picoread.


    J R Hunt     jrhunt at iee dot org
                 2004-08-26

On a technical note, I am concerned that the driver does
not lock the parallel port it is using, and there is
therefore no protection against using it on a port that
is also supporting a parallel printer driver. My browsing
of the kernel documentation suggests that there is a
standard way of locking ports. Any volunteers?

For more information on writing kernel modules, see
http://tldp.org/LDP/lkmpg/2.6/html/index.html .