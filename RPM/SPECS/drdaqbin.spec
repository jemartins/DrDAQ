%define prefix %{_prefix}/lib/drdaq

Summary:	Data Logger for DrDAQ device
Name:		drdaqbin
Version:	0.21
Release:	1mdk
License:	GPL
Group:		Sciences/Physics
Source:		drdaqbin.0.21.tar.bz2

BuildRoot:	%{_tmppath}/%{name}-%{version}-root
Requires: 	grace 
Requires: 	tcl 
Requires: 	tk 
Requires: 	simpl 
Requires:	picopar = 2004.10.12-1mdk

Conflicts:	kernel < 2.6.12-24mdk
Conflicts:	drdaq

%description
DrDAQ is projected to read all the sensors of the DrDAQ device and plot them in
the Grace window. By now the program is capable to read two sensors simultaneously
and convert to the units of the Temperature, Light, Sound Level and Voltage.
Waveform, Resistance and pH are read directly from units of ADC.

%prep
%setup

%build
make

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p %{prefix}

make "prefix=%{prefix} PREFIX=%{prefix} DESTDIR=$RPM_BUILD_ROOT/%{prefix}" install

install -D -s -m 755 bin/picoGUI.tcl $RPM_BUILD_ROOT/%{prefix}/bin/picoGUI.tcl
install -D -s -m 755 bin/picoReader.tcl $RPM_BUILD_ROOT/%{prefix}/bin/picoReader.tcl
install -D -s -m 755 bin/picoMgr $RPM_BUILD_ROOT/%{prefix}/bin/picoMgr
install -D -s -m 755 bin/nameServer $RPM_BUILD_ROOT/%{prefix}/bin/nameServer
install -D -s -m 755 bin/requestName $RPM_BUILD_ROOT/%{prefix}/bin/requestName
install -D -s -m 755 bin/freeName $RPM_BUILD_ROOT/%{prefix}/bin/freeName
install -D -s -m 755 bin/drdaq $RPM_BUILD_ROOT/%{prefix}/bin/drdaq
install -D -s -m 755 lib/libgrace.so.0 $RPM_BUILD_ROOT/%{prefix}/lib/libgrace.so.0
install -D -s -m 755 lib/pkgIndex.tcl $RPM_BUILD_ROOT/%{prefix}/lib/pkgIndex.tcl
install -D -s -m 755 icons/DrDAQ50x50.png $RPM_BUILD_ROOT/usr/share/icons/DrDAQ50x50.png
install -D -s -m 755 bin/drdaq $RPM_BUILD_ROOT/usr/bin/drdaq

install -m 755 -d $RPM_BUILD_ROOT%{_menudir}
cat << EOF > $RPM_BUILD_ROOT%{_menudir}/%name
?package(drdaq):\
        needs="X11"\
        icon="DrDAQ50x50.png"\
        section="More Applications/Sciences/Other"\
        title="DrDAQ"\
        longtitle="DrDAQ Application Project"\
        command="drdaq"
EOF

%post
%{update_menus}

# It is need to install drive from Picotech

#if [ -z "$(lsmod|grep -E '^picopar +')" ]; then

#cat << EOF >> /etc/rc.d/rc.local
## This (bash) command can be used to conditionally load the module; 
## typically you might add this into /etc/rc.local to load the module at boot time.

#[ -z "$(lsmod|grep -E '^picopar +')" ] && insmod /%{prefix}/picoDriver/picopar.ko
#mknod /dev/picopar0 c 242 0
#EOF

#sync;sync
#insmod /%{prefix}/picoDriver/picopar.ko

#fi

#if [ -f "$(ls /dev | grep picopar)" ]; then
#	mknod /dev/picopar0 c 242 0
#fi

%postun
%{clean_menus}
rm -rf /%{prefix}

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%{prefix}/*
%{_prefix}/bin/*

%doc docs/Readme docs/Leiame
%_iconsdir/DrDAQ50x50.png
%{_menudir}/%name

%changelog

* Thu Aug 02 2006 José Eduardo Martins <jemartins@fis.unb.br>
- First spec.


