%define prefix %{_prefix}/lib/simpl

Summary:	This project aims to bring this powerful messaging paradigm to the Open Source application developer.
Name:		simpltcl
Version:	1.2
Release:	%mkrel 1
License:	GPL
Group:          System
Source:	        simpltcl.1.2.tar.bz2
BuildRoot:	%{_tmppath}/%{name}-%{version}-root

Requires:       tcl
Requires:       tk
Requires:       simpl

Conflicts:      simplbin

%description

%prep
%setup

%build

%install
#rm -rf $RPM_BUILD_ROOT

install -m 655 simpltclList -D $RPM_BUILD_ROOT/%{prefix}/simpltclList
install -m 655 scripts/buildsimpl.tcl -D $RPM_BUILD_ROOT/%{prefix}/scripts/buildsimpl.tcl
install -m 655 scripts/tclver -D $RPM_BUILD_ROOT/%{prefix}/scripts/tclver
install -m 655 tcl/include/fifoReceiver.h -D $RPM_BUILD_ROOT/%{prefix}/tcl/include/fifoReceiver.h
install -m 655 tcl/include/fifoSender.h -D $RPM_BUILD_ROOT/%{prefix}/tcl/include/fifoSender.h
install -m 655 tcl/include/socketDefs.h -D $RPM_BUILD_ROOT/%{prefix}/tcl/include/socketDefs.h
install -m 655 tcl/include/socketProto.h -D $RPM_BUILD_ROOT/%{prefix}/tcl/include/socketProto.h
install -m 655 tcl/include/socketSender.h -D $RPM_BUILD_ROOT/%{prefix}/tcl/include/socketSender.h
install -m 655 tcl/include/surroMsgs.h -D $RPM_BUILD_ROOT/%{prefix}/tcl/include/surroMsgs.h
install -m 655 tcl/include/surroTestMsgs.h -D $RPM_BUILD_ROOT/%{prefix}/tcl/include/surroTestMsgs.h
install -m 655 tcl/include/tclSurrogate.h -D $RPM_BUILD_ROOT/%{prefix}/tcl/include/tclSurrogate.h
install -m 655 tcl/include/tclSurroProto.h -D $RPM_BUILD_ROOT/%{prefix}/tcl/include/tclSurroProto.h
install -m 655 tcl/Makefile -D $RPM_BUILD_ROOT/%{prefix}/tcl/Makefile
install -m 655 tcl/src/fcgateway.tcl -D $RPM_BUILD_ROOT/%{prefix}/tcl/src/fcgateway.tcl
install -m 655 tcl/src/fcsocket.tcl -D $RPM_BUILD_ROOT/%{prefix}/tcl/src/fcsocket.tcl
install -m 655 tcl/src/fctclx.c -D $RPM_BUILD_ROOT/%{prefix}/tcl/src/fctclx.c
install -m 655 tcl/src/Makefile -D $RPM_BUILD_ROOT/%{prefix}/tcl/src/Makefile
install -m 655 tcl/src/pkgIndex.tcl -D $RPM_BUILD_ROOT/%{prefix}/tcl/src/pkgIndex.tcl
install -m 655 tcl/src/pkgIndex.tcl.fctclx -D $RPM_BUILD_ROOT/%{prefix}/tcl/src/pkgIndex.tcl.fctclx
install -m 655 tcl/src/readme -D $RPM_BUILD_ROOT/%{prefix}/tcl/src/readme
install -m 655 tcl/src/socketUtils.c -D $RPM_BUILD_ROOT/%{prefix}/tcl/src/socketUtils.c
install -m 655 tcl/src/tclSurroFifo.c -D $RPM_BUILD_ROOT/%{prefix}/tcl/src/tclSurroFifo.c
install -m 655 tcl/src/tclSurrogate.c -D $RPM_BUILD_ROOT/%{prefix}/tcl/src/tclSurrogate.c
install -m 655 tcl/src/tclSurroInit.c -D $RPM_BUILD_ROOT/%{prefix}/tcl/src/tclSurroInit.c
install -m 655 tcl/src/tclSurroSocket.c -D $RPM_BUILD_ROOT/%{prefix}/tcl/src/tclSurroSocket.c
install -m 655 tcl/test/bottomPart.tcl -D $RPM_BUILD_ROOT/%{prefix}/tcl/test/bottomPart.tcl
install -m 655 tcl/test/fcTester.c -D $RPM_BUILD_ROOT/%{prefix}/tcl/test/fcTester.c
install -m 655 tcl/test/fifoReceiver.c -D $RPM_BUILD_ROOT/%{prefix}/tcl/test/fifoReceiver.c
install -m 655 tcl/test/fifoSender.c -D $RPM_BUILD_ROOT/%{prefix}/tcl/test/fifoSender.c
install -m 655 tcl/test/globalVars.tcl -D $RPM_BUILD_ROOT/%{prefix}/tcl/test/globalVars.tcl
install -m 655 tcl/test/guiHandlers.tcl -D $RPM_BUILD_ROOT/%{prefix}/tcl/test/guiHandlers.tcl
install -m 655 tcl/test/Makefile -D $RPM_BUILD_ROOT/%{prefix}/tcl/test/Makefile
install -m 655 tcl/test/msgHandlers.tcl -D $RPM_BUILD_ROOT/%{prefix}/tcl/test/msgHandlers.tcl
install -m 655 tcl/test/readme -D $RPM_BUILD_ROOT/%{prefix}/tcl/test/readme
install -m 655 tcl/test/receiveUtils.tcl -D $RPM_BUILD_ROOT/%{prefix}/tcl/test/receiveUtils.tcl
install -m 655 tcl/test/socketSender.c -D $RPM_BUILD_ROOT/%{prefix}/tcl/test/socketSender.c
install -m 655 tcl/test/topPart.tcl -D $RPM_BUILD_ROOT/%{prefix}/tcl/test/topPart.tcl

%clean
rm -rf $RPM_BUILD_ROOT

%post  

%{update_menus}
export SIMPL_HOME=%{prefix}
export FIFO_PATH=$SIMPL_HOME/fifo

cd %{prefix}/scripts
#	echo "Compiling Simpl..."
./buildsimpl.tcl

# A linha abaixo eh meio forcada
# mas a lib libfctclx.so.1.0.1 nao foi
# construida com o script anterior
#cd %{prefix}/tcl/src
#make

cd %{prefix}/lib/
echo "pkg_mkIndex . *.tcl *.so" | /usr/bin/tclsh

%postun
%{clean_menus}
rm -rf %{prefix}

%files
%defattr(-,root,root)
%{prefix}/*

%changelog
* Sat Jan 26 2008 Jose Eduardo Martins <jemartins@fis.unb.br> 
- new spec for 1.2 version

* Sun Feb 04 2007 Jose Eduardo Martins <jemartins@fis.unb.br>
- 1.0

* Wed Aug 16 2006 Jose Eduardo Martins <jemartins@fis.unb.br>
- first spec for Simpltcl files

