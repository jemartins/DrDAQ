%define prefix %{_prefix}/lib/picopar

Summary:	Pico Technology Parallel port drivers	
Name:		picopar
Version:	0.2
Release:	%mkrel 1
License:	GPL
Group:          System/Kernel and hardware
Source:	        picopar.0.2.tar.bz2
BuildRoot:	%{_tmppath}/%{name}-%{version}-root

Requires:	kernel-devel >= 2.6
Requires:	gcc

Requires:	kernel  >= 2.6

%description
Pico Technology Parallel port drivers
for Linux Kernel 2.6

%prep

%setup

%build

%install
rm -rf $RPM_BUILD_ROOT

install -m 755 COPYING -D $RPM_BUILD_ROOT/%{prefix}/COPYING
install -m 755 rc.local -D $RPM_BUILD_ROOT/%{prefix}/rc.local
install -m 755 README.TXT -D $RPM_BUILD_ROOT/%{prefix}/README.TXT
install -m 755 Makefile -D $RPM_BUILD_ROOT/%{prefix}/Makefile
install -m 755 kernel/conduct.h -D $RPM_BUILD_ROOT/%{prefix}/kernel/conduct.h
install -m 755 kernel/drdaqdrv.h -D $RPM_BUILD_ROOT/%{prefix}/kernel/drdaqdrv.h
install -m 755 kernel/drdaqscl.c -D $RPM_BUILD_ROOT/%{prefix}/kernel/drdaqscl.c
install -m 755 kernel/humidity.h -D $RPM_BUILD_ROOT/%{prefix}/kernel/humidity.h
install -m 755 kernel/light.h -D $RPM_BUILD_ROOT/%{prefix}/kernel/light.h
install -m 755 kernel/lightint.h -D $RPM_BUILD_ROOT/%{prefix}/kernel/lightint.h
install -m 755 kernel/Makefile -D $RPM_BUILD_ROOT/%{prefix}/kernel/Makefile
install -m 755 kernel/oxygen.h -D $RPM_BUILD_ROOT/%{prefix}/kernel/oxygen.h
install -m 755 kernel/picolnx.c -D $RPM_BUILD_ROOT/%{prefix}/kernel/picolnx.c
install -m 755 kernel/pico_lnx.h -D $RPM_BUILD_ROOT/%{prefix}/kernel/pico_lnx.h
install -m 755 kernel/reed.h -D $RPM_BUILD_ROOT/%{prefix}/kernel/reed.h
install -m 755 kernel/resint.h -D $RPM_BUILD_ROOT/%{prefix}/kernel/resint.h
install -m 755 kernel/sndintw.h -D $RPM_BUILD_ROOT/%{prefix}/kernel/sndintw.h
install -m 755 kernel/soundl.h -D $RPM_BUILD_ROOT/%{prefix}/kernel/soundl.h
install -m 755 kernel/tempc.h -D $RPM_BUILD_ROOT/%{prefix}/kernel/tempc.h
install -m 755 kernel/tempintc.h -D $RPM_BUILD_ROOT/%{prefix}/kernel/tempintc.h
install -m 755 kernel/voltsint.h -D $RPM_BUILD_ROOT/%{prefix}/kernel/voltsint.h

%post
PICO_HOME=/usr/lib/picopar

cd %{prefix}
echo "	Aguarde. Compilando o modulo..."
make > make.out 2>&1

cd kernel
echo "	Aguarde. Instalando o modulo..."
KERNEL_VERSION=`uname -r`
MODULE_INSTALLDIR=/lib/modules/$KERNEL_VERSION/kernel/drivers/parport
	
install -m 0644 -c picopar.ko $MODULE_INSTALLDIR
/sbin/depmod -aq

#rm -rf .tmp_versions

# It is need to install drive from Picotech

#cat << EOF >> /etc/rc.d/rc.local

# This (bash) command can be used to conditionally load the module;
# typically you might add this into /etc/rc.local to load the module
# at boot time.

#[ -z "$(lsmod|grep -E '^picopar +')" ] && $MODULE_INSTALLDIR/picopar.ko
#mknod /dev/picopar0 c 242 0
#EOF

cp -f /etc/rc.d/rc.local /etc/rc.d/rc.local.rpmsave

cd %{prefix}
cat rc.local >> /etc/rc.d/rc.local

if [ ! -z "$(lsmod|grep -E '^picopar +')" ]; then
	sync;sync
	rmmod picopar
	insmod $MODULE_INSTALLDIR/picopar.ko
else 
	sync;sync
	insmod $MODULE_INSTALLDIR/picopar.ko	
fi

if [ ! -f "$(ls /dev | grep picopar)" ]; then
       mknod /dev/picopar0 c 242 0
fi

make clean > /dev/null 2>&1

echo "	Pronto."

%postun

rm -rf %{prefix}
rm -f /dev/picopar0
rmmod picopar

KERNEL_VERSION=`uname -r`
MODULE_INSTALLDIR=/lib/modules/$KERNEL_VERSION/kernel/drivers/serial
rm -rf $MODULE_INSTALLDIR/picopar.ko

cp -f /etc/rc.d/rc.local /etc/rc.d/rc.local.rpmbak
cp -f /etc/rc.d/rc.local.rpmsave /etc/rc.d/rc.local

%clean
rm -rf -D $RPM_BUILD_ROOT

%files

%defattr(-,root,root)
%{prefix}/*

%changelog

* Sat Jan 26 2008 Jose Eduardo Martins <jemartins@fis.unb.br>
- New spec for new version to kernel 2.6.22.12

* Thu Aug 03 2006 Jose Eduardo Martins <jemartins@fis.unb.br>
- First spec

