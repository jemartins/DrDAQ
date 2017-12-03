%define prefix %{_prefix}/lib/simpl

Summary:	This project aims to bring this powerful messaging paradigm to the Open Source application developer.
Name:		simpl
Version:	3.1.2
Release:	%mkrel 1
License:	GPL
Group:          System
Source:	        simpl.3.1.2.tar.bz2
BuildRoot:	%{_tmppath}/%{name}-%{version}-root

Requires:       gcc

#Conflicts:      simplbin

%description

%prep
%setup

%build

%install
rm -rf $RPM_BUILD_ROOT

install -m 655 INSTALL.simpl -D $RPM_BUILD_ROOT/%{prefix}/INSTALL.simpl
install -m 655 Makefile -D $RPM_BUILD_ROOT/%{prefix}/Makefile
install -m 655 simplList -D $RPM_BUILD_ROOT/%{prefix}/simplList
install -m 655 version -D $RPM_BUILD_ROOT/%{prefix}/version
install -m 655 benchmarks/include/receiver.h -D $RPM_BUILD_ROOT/%{prefix}/benchmarks/include/receiver.h
install -m 655 benchmarks/include/sender.h -D $RPM_BUILD_ROOT/%{prefix}/benchmarks/include/sender.h
install -m 655 benchmarks/src/makefcipc -D $RPM_BUILD_ROOT/%{prefix}/benchmarks/src/makefcipc
install -m 655 benchmarks/src/Makefile -D $RPM_BUILD_ROOT/%{prefix}/benchmarks/src/Makefile
install -m 655 benchmarks/src/makesimplfcipc -D $RPM_BUILD_ROOT/%{prefix}/benchmarks/src/makesimplfcipc
install -m 655 benchmarks/src/makesipc -D $RPM_BUILD_ROOT/%{prefix}/benchmarks/src/makesipc
install -m 655 benchmarks/src/makesrr -D $RPM_BUILD_ROOT/%{prefix}/benchmarks/src/makesrr
install -m 655 benchmarks/src/readme -D $RPM_BUILD_ROOT/%{prefix}/benchmarks/src/readme
install -m 655 benchmarks/src/receiver.c -D $RPM_BUILD_ROOT/%{prefix}/benchmarks/src/receiver.c
install -m 655 benchmarks/src/sender.c -D $RPM_BUILD_ROOT/%{prefix}/benchmarks/src/sender.c
install -m 655 bin/Makefile -D $RPM_BUILD_ROOT/%{prefix}/bin/Makefile
install -m 655 bin/trigger -D $RPM_BUILD_ROOT/%{prefix}/bin/trigger
install -m 655 fclogger/Makefile -D $RPM_BUILD_ROOT/%{prefix}/fclogger/Makefile
install -m 655 fclogger/src/fclogger.c -D $RPM_BUILD_ROOT/%{prefix}/fclogger/src/fclogger.c
install -m 655 fclogger/src/Makefile -D $RPM_BUILD_ROOT/%{prefix}/fclogger/src/Makefile
install -m 655 fclogger/src/simplLogUtils.c -D $RPM_BUILD_ROOT/%{prefix}/fclogger/src/simplLogUtils.c
install -m 655 fclogger/test/logit.c -D $RPM_BUILD_ROOT/%{prefix}/fclogger/test/logit.c
install -m 655 fclogger/test/Makefile -D $RPM_BUILD_ROOT/%{prefix}/fclogger/test/Makefile
install -m 655 fclogger/test/readme -D $RPM_BUILD_ROOT/%{prefix}/fclogger/test/readme
install -m 655 include/binstr.h -D $RPM_BUILD_ROOT/%{prefix}/include/binstr.h
install -m 655 include/loggerProto.h -D $RPM_BUILD_ROOT/%{prefix}/include/loggerProto.h
install -m 655 include/loggerVars.h -D $RPM_BUILD_ROOT/%{prefix}/include/loggerVars.h
install -m 655 include/simplDefs.h -D $RPM_BUILD_ROOT/%{prefix}/include/simplDefs.h
install -m 655 include/simplErrors.h -D $RPM_BUILD_ROOT/%{prefix}/include/simplErrors.h
install -m 655 include/simpl.h -D $RPM_BUILD_ROOT/%{prefix}/include/simpl.h
install -m 655 include/simplLibProto.h -D $RPM_BUILD_ROOT/%{prefix}/include/simplLibProto.h
install -m 655 include/simplLibVars.h -D $RPM_BUILD_ROOT/%{prefix}/include/simplLibVars.h
install -m 655 include/simplmiscProto.h -D $RPM_BUILD_ROOT/%{prefix}/include/simplmiscProto.h
install -m 655 include/simplNames.h -D $RPM_BUILD_ROOT/%{prefix}/include/simplNames.h
install -m 655 include/simplProtocols.h -D $RPM_BUILD_ROOT/%{prefix}/include/simplProtocols.h
install -m 655 include/simplProto.h -D $RPM_BUILD_ROOT/%{prefix}/include/simplProto.h
install -m 655 include/standardTypes.h -D $RPM_BUILD_ROOT/%{prefix}/include/standardTypes.h
install -m 655 include/surMsgs.h -D $RPM_BUILD_ROOT/%{prefix}/include/surMsgs.h
install -m 655 lib/Makefile -D $RPM_BUILD_ROOT/%{prefix}/lib/Makefile
install -m 655 lib/pkgIndex.tcl.fcsocket -D $RPM_BUILD_ROOT/%{prefix}/lib/pkgIndex.tcl.fcsocket
install -m 655 lib/pkgIndex.tcl.fctclx -D $RPM_BUILD_ROOT/%{prefix}/lib/pkgIndex.tcl.fctclx
install -m 655 lib/trigger -D $RPM_BUILD_ROOT/%{prefix}/lib/trigger
install -m 655 licence/LGPL.txt -D $RPM_BUILD_ROOT/%{prefix}/licence/LGPL.txt
install -m 655 licence/public.licence -D $RPM_BUILD_ROOT/%{prefix}/licence/public.licence
install -m 655 modules/trigger -D $RPM_BUILD_ROOT/%{prefix}/modules/trigger
install -m 655 scripts/buildsimpl -D $RPM_BUILD_ROOT/%{prefix}/scripts/buildsimpl
install -m 655 scripts/simpl_init -D $RPM_BUILD_ROOT/%{prefix}/scripts/simpl_init
install -m 655 scripts/simplver -D $RPM_BUILD_ROOT/%{prefix}/scripts/simplver
install -m 655 simplipc/Makefile -D $RPM_BUILD_ROOT/%{prefix}/simplipc/Makefile
install -m 655 simplipc/src/Makefile -D $RPM_BUILD_ROOT/%{prefix}/simplipc/src/Makefile
install -m 655 simplipc/src/simpl.c -D $RPM_BUILD_ROOT/%{prefix}/simplipc/src/simpl.c
install -m 655 simplipc/src/simplUtils.c -D $RPM_BUILD_ROOT/%{prefix}/simplipc/src/simplUtils.c
install -m 655 simplipc/test/Makefile -D $RPM_BUILD_ROOT/%{prefix}/simplipc/test/Makefile
install -m 655 simplipc/test/readme -D $RPM_BUILD_ROOT/%{prefix}/simplipc/test/readme
install -m 655 simplipc/test/receiver.c -D $RPM_BUILD_ROOT/%{prefix}/simplipc/test/receiver.c
install -m 655 simplipc/test/sender.c -D $RPM_BUILD_ROOT/%{prefix}/simplipc/test/sender.c
install -m 655 simplUtils/Makefile -D $RPM_BUILD_ROOT/%{prefix}/simplUtils/Makefile
install -m 655 simplUtils/src/binstr.c -D $RPM_BUILD_ROOT/%{prefix}/simplUtils/src/binstr.c
install -m 655 simplUtils/src/dumpProtocolTable.c -D $RPM_BUILD_ROOT/%{prefix}/simplUtils/src/dumpProtocolTable.c
install -m 655 simplUtils/src/fcshow.c -D $RPM_BUILD_ROOT/%{prefix}/simplUtils/src/fcshow.c
install -m 655 simplUtils/src/fcslay.c -D $RPM_BUILD_ROOT/%{prefix}/simplUtils/src/fcslay.c
install -m 655 simplUtils/src/Makefile -D $RPM_BUILD_ROOT/%{prefix}/simplUtils/src/Makefile
install -m 655 simplUtils/src/miscUtils.c -D $RPM_BUILD_ROOT/%{prefix}/simplUtils/src/miscUtils.c
install -m 655 simplUtils/test/Makefile -D $RPM_BUILD_ROOT/%{prefix}/simplUtils/test/Makefile
install -m 655 simplUtils/test/testbinstr.c -D $RPM_BUILD_ROOT/%{prefix}/simplUtils/test/testbinstr.c
install -m 655 surrogates/Makefile -D $RPM_BUILD_ROOT/%{prefix}/surrogates/Makefile
install -m 655 surrogates/protocol_router/Makefile -D $RPM_BUILD_ROOT/%{prefix}/surrogates/protocol_router/Makefile
install -m 655 surrogates/protocol_router/src/Makefile -D $RPM_BUILD_ROOT/%{prefix}/surrogates/protocol_router/src/Makefile
install -m 655 surrogates/protocol_router/src/protocolRouter.c -D $RPM_BUILD_ROOT/%{prefix}/surrogates/protocol_router/src/protocolRouter.c
install -m 655 surrogates/tcp/include/surrogate.h -D $RPM_BUILD_ROOT/%{prefix}/surrogates/tcp/include/surrogate.h
install -m 655 surrogates/tcp/Makefile -D $RPM_BUILD_ROOT/%{prefix}/surrogates/tcp/Makefile
install -m 655 surrogates/tcp/src/Makefile -D $RPM_BUILD_ROOT/%{prefix}/surrogates/tcp/src/Makefile
install -m 655 surrogates/tcp/src/surrogate.c -D $RPM_BUILD_ROOT/%{prefix}/surrogates/tcp/src/surrogate.c
install -m 655 surrogates/tcp/src/surrogateInit.c -D $RPM_BUILD_ROOT/%{prefix}/surrogates/tcp/src/surrogateInit.c
install -m 655 surrogates/tcp/src/surrogate_r.c -D $RPM_BUILD_ROOT/%{prefix}/surrogates/tcp/src/surrogate_r.c
install -m 655 surrogates/tcp/src/surrogate_R.c -D $RPM_BUILD_ROOT/%{prefix}/surrogates/tcp/src/surrogate_R.c
install -m 655 surrogates/tcp/src/surrogate_s.c -D $RPM_BUILD_ROOT/%{prefix}/surrogates/tcp/src/surrogate_s.c
install -m 655 surrogates/tcp/src/surrogate_S.c -D $RPM_BUILD_ROOT/%{prefix}/surrogates/tcp/src/surrogate_S.c
install -m 655 surrogates/tcp/src/surrogateUtils.c -D $RPM_BUILD_ROOT/%{prefix}/surrogates/tcp/src/surrogateUtils.c
install -m 655 surrogates/tcp/test/go -D $RPM_BUILD_ROOT/%{prefix}/surrogates/tcp/test/go
install -m 655 surrogates/tcp/test/Makefile -D $RPM_BUILD_ROOT/%{prefix}/surrogates/tcp/test/Makefile
install -m 655 surrogates/tcp/test/receiver0.c -D $RPM_BUILD_ROOT/%{prefix}/surrogates/tcp/test/receiver0.c
install -m 655 surrogates/tcp/test/receiver1.c -D $RPM_BUILD_ROOT/%{prefix}/surrogates/tcp/test/receiver1.c
install -m 655 surrogates/tcp/test/receiver2.c -D $RPM_BUILD_ROOT/%{prefix}/surrogates/tcp/test/receiver2.c
install -m 655 surrogates/tcp/test/sender0.c -D $RPM_BUILD_ROOT/%{prefix}/surrogates/tcp/test/sender0.c
install -m 655 surrogates/tcp/test/sender1.c -D $RPM_BUILD_ROOT/%{prefix}/surrogates/tcp/test/sender1.c
install -m 655 surrogates/tcp/test/sender2.c -D $RPM_BUILD_ROOT/%{prefix}/surrogates/tcp/test/sender2.c
install -m 655 surrogates/tcp/test/stop -D $RPM_BUILD_ROOT/%{prefix}/surrogates/tcp/test/stop
install -m 655 surrogates/tcp/test/surroProxy.tcl -D $RPM_BUILD_ROOT/%{prefix}/surrogates/tcp/test/surroProxy.tcl

%clean
rm -rf -D $RPM_BUILD_ROOT

%post  

%{update_menus}
export SIMPL_HOME=%{prefix}
export FIFO_PATH=$SIMPL_HOME/fifo

if [ ! -d $FIFO_PATH ]; then
        mkdir $FIFO_PATH
fi

cd %{prefix}/scripts
echo "	Compiling Simpl..."
./buildsimpl

%postun
%{clean_menus}
rm -rf %{prefix}

%files
%defattr(-,root,root)
%{prefix}/*

%doc docs/changes.2.0
%doc docs/readme.dynamic_library
%doc docs/readme.ipc
%doc docs/readme.MACOSX
%doc docs/readme.rcs
%doc docs/readme.surrogateTCP
%doc docs/readme.tcl
%doc docs/readme.vc
%doc docs/simpl-function.synopsis
%doc docs/surrogateDiagram.txt

%changelog
* Sat Jan 26 2008 Jose Eduardo Martins <jemartins@fis.unb.br>
- new spec for 3.1.2 version

* Sun Feb 04 2007 Jose Eduardo Martins <jemartins@fis.unb.br> 
- 3.1.1

* Wed Aug 16 2006 Jose Eduardo Martins <jemartins@fis.unb.br>
- spec for Simpl Project files version 3.1.0

* Fri Aug 05 2006 Jose Eduardo Martins <jemartins@fis.unb.br>
- first spec for Simpl Project files

