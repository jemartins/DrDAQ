%define prefix %{_prefix}/lib/drdaq

Summary:	Data Logger for DrDAQ device
Name:		drdaq
Version:	0.40
Release:	%mkrel 2
License:	GPL
Group:		More Applications/Sciences/Other
Source:		drdaq-0.40.tar.bz2
BuildRoot:	%{_tmppath}/%{name}-%{version}-root

BuildRequires:  gcc

Requires: 	swig 
Requires: 	grace
Requires: 	grace-devel
Requires: 	gcc
Requires: 	tcl
Requires: 	tk
Requires: 	simpl 
Requires: 	simpltcl 
Requires: 	simpltest 
Requires:	picopar 

%if %mdkversion >= 200610
Requires:  tcl-devel
BuildRequires:  tcl-devel
%endif

Conflicts:	kernel < 2.6

%description
DrDAQ is projected to read all the sensors of the DrDAQ device and plot them in
the Grace window. By now the program is capable to read two sensors simultaneously
and convert to the units of the Temperature, Light, Sound Level and Voltage.
Waveform, Resistance and pH are read directly from units of ADC.

%prep

%setup

%build

%install
rm -rf $RPM_BUILD_ROOT

install -m 655 Makefile -D $RPM_BUILD_ROOT/%{prefix}/Makefile
install -m 655 bin/Makefile -D $RPM_BUILD_ROOT/%{prefix}/bin/Makefile
install -m 655 graceUtils/Makefile -D $RPM_BUILD_ROOT/%{prefix}/graceUtils/Makefile
install -m 655 graceUtils/src/graceutils.c -D $RPM_BUILD_ROOT/%{prefix}/graceUtils/src/graceutils.c
install -m 655 graceUtils/src/graceutils.i -D $RPM_BUILD_ROOT/%{prefix}/graceUtils/src/graceutils.i
install -m 655 graceUtils/src/Makefile -D $RPM_BUILD_ROOT/%{prefix}/graceUtils/src/Makefile
install -m 655 icons/DrDAQ50x50.png -D $RPM_BUILD_ROOT/%{prefix}/icons/DrDAQ50x50.png
install -m 655 icons/DrDAQ.png -D $RPM_BUILD_ROOT/%{prefix}/icons/DrDAQ.png
install -m 655 include/drdaqMsgs.h -D $RPM_BUILD_ROOT/%{prefix}/include/drdaqMsgs.h
install -m 655 include/pico_lnx.h -D $RPM_BUILD_ROOT/%{prefix}/include/pico_lnx.h
install -m 655 lib/pkgIndex.tcl -D $RPM_BUILD_ROOT/%{prefix}/lib/pkgIndex.tcl
install -m 655 nameServer/include/freeName.h -D $RPM_BUILD_ROOT/%{prefix}/nameServer/include/freeName.h
install -m 655 nameServer/include/freeNameProto.h -D $RPM_BUILD_ROOT/%{prefix}/nameServer/include/freeNameProto.h
install -m 655 nameServer/include/nameServer.h -D $RPM_BUILD_ROOT/%{prefix}/nameServer/include/nameServer.h
install -m 655 nameServer/include/nameServerMsgs.h -D $RPM_BUILD_ROOT/%{prefix}/nameServer/include/nameServerMsgs.h
install -m 655 nameServer/include/nameServerProto.h -D $RPM_BUILD_ROOT/%{prefix}/nameServer/include/nameServerProto.h
install -m 655 nameServer/include/nameStim.h -D $RPM_BUILD_ROOT/%{prefix}/nameServer/include/nameStim.h
install -m 655 nameServer/include/nameStimProto.h -D $RPM_BUILD_ROOT/%{prefix}/nameServer/include/nameStimProto.h
install -m 655 nameServer/include/requestName.h -D $RPM_BUILD_ROOT/%{prefix}/nameServer/include/requestName.h
install -m 655 nameServer/include/requestNameProto.h -D $RPM_BUILD_ROOT/%{prefix}/nameServer/include/requestNameProto.h
install -m 655 nameServer/Makefile -D $RPM_BUILD_ROOT/%{prefix}/nameServer/Makefile
install -m 655 nameServer/src/freeName.c -D $RPM_BUILD_ROOT/%{prefix}/nameServer/src/freeName.c
install -m 655 nameServer/src/freeNameInit.c -D $RPM_BUILD_ROOT/%{prefix}/nameServer/src/freeNameInit.c
install -m 655 nameServer/src/freeNameUtils.c -D $RPM_BUILD_ROOT/%{prefix}/nameServer/src/freeNameUtils.c
install -m 655 nameServer/src/Makefile -D $RPM_BUILD_ROOT/%{prefix}/nameServer/src/Makefile
install -m 655 nameServer/src/nameServer.c -D $RPM_BUILD_ROOT/%{prefix}/nameServer/src/nameServer.c
install -m 655 nameServer/src/nameServerInit.c -D $RPM_BUILD_ROOT/%{prefix}/nameServer/src/nameServerInit.c
install -m 655 nameServer/src/nameServerUtils.c -D $RPM_BUILD_ROOT/%{prefix}/nameServer/src/nameServerUtils.c
install -m 655 nameServer/src/requestName.c -D $RPM_BUILD_ROOT/%{prefix}/nameServer/src/requestName.c
install -m 655 nameServer/src/requestNameInit.c -D $RPM_BUILD_ROOT/%{prefix}/nameServer/src/requestNameInit.c
install -m 655 nameServer/src/requestNameUtils.c -D $RPM_BUILD_ROOT/%{prefix}/nameServer/src/requestNameUtils.c
install -m 655 nameServer/test/Makefile -D $RPM_BUILD_ROOT/%{prefix}/nameServer/test/Makefile
install -m 655 nameServer/test/nameStim.c -D $RPM_BUILD_ROOT/%{prefix}/nameServer/test/nameStim.c
install -m 655 nameServer/test/nameStimInit.c -D $RPM_BUILD_ROOT/%{prefix}/nameServer/test/nameStimInit.c
install -m 655 nameServer/test/nameStimUtils.c -D $RPM_BUILD_ROOT/%{prefix}/nameServer/test/nameStimUtils.c
install -m 655 picoGUI/include/picoMgrSimulator.h -D $RPM_BUILD_ROOT/%{prefix}/picoGUI/include/picoMgrSimulator.h
install -m 655 picoGUI/include/picoMgrSimulatorProto.h -D $RPM_BUILD_ROOT/%{prefix}/picoGUI/include/picoMgrSimulatorProto.h
install -m 655 picoGUI/include/tclReceiverMsgs.h -D $RPM_BUILD_ROOT/%{prefix}/picoGUI/include/tclReceiverMsgs.h
install -m 655 picoGUI/include/tclStim.h -D $RPM_BUILD_ROOT/%{prefix}/picoGUI/include/tclStim.h
install -m 655 picoGUI/include/tclStimProto.h -D $RPM_BUILD_ROOT/%{prefix}/picoGUI/include/tclStimProto.h
install -m 655 picoGUI/Makefile -D $RPM_BUILD_ROOT/%{prefix}/picoGUI/Makefile
install -m 655 picoGUI/src/bottomPart.tcl -D $RPM_BUILD_ROOT/%{prefix}/picoGUI/src/bottomPart.tcl
install -m 655 picoGUI/src/fileJoiner.c -D $RPM_BUILD_ROOT/%{prefix}/picoGUI/src/fileJoiner.c
install -m 655 picoGUI/src/globalVars.tcl -D $RPM_BUILD_ROOT/%{prefix}/picoGUI/src/globalVars.tcl
install -m 655 picoGUI/src/guiHandlers.tcl -D $RPM_BUILD_ROOT/%{prefix}/picoGUI/src/guiHandlers.tcl
install -m 655 picoGUI/src/guivTcl.tcl -D $RPM_BUILD_ROOT/%{prefix}/picoGUI/src/guivTcl.tcl
install -m 655 picoGUI/src/Makefile -D $RPM_BUILD_ROOT/%{prefix}/picoGUI/src/Makefile
install -m 655 picoGUI/src/msgHandlers.tcl -D $RPM_BUILD_ROOT/%{prefix}/picoGUI/src/msgHandlers.tcl
install -m 655 picoGUI/src/receiveUtils.tcl -D $RPM_BUILD_ROOT/%{prefix}/picoGUI/src/receiveUtils.tcl
install -m 655 picoGUI/src/topPart.tcl -D $RPM_BUILD_ROOT/%{prefix}/picoGUI/src/topPart.tcl
install -m 655 picoGUI/test/Makefile -D $RPM_BUILD_ROOT/%{prefix}/picoGUI/test/Makefile
install -m 655 picoGUI/test/picoMgrSimulator.c -D $RPM_BUILD_ROOT/%{prefix}/picoGUI/test/picoMgrSimulator.c
install -m 655 picoGUI/test/picoMgrSimulatorInit.c -D $RPM_BUILD_ROOT/%{prefix}/picoGUI/test/picoMgrSimulatorInit.c
install -m 655 picoGUI/test/picoMgrSimulatorUtils.c -D $RPM_BUILD_ROOT/%{prefix}/picoGUI/test/picoMgrSimulatorUtils.c
install -m 655 picoGUI/test/tclStim.c -D $RPM_BUILD_ROOT/%{prefix}/picoGUI/test/tclStim.c
install -m 655 picoMgr/include/guiStim.h -D $RPM_BUILD_ROOT/%{prefix}/picoMgr/include/guiStim.h
install -m 655 picoMgr/include/guiStimProto.h -D $RPM_BUILD_ROOT/%{prefix}/picoMgr/include/guiStimProto.h
install -m 655 picoMgr/include/picoMgr.h -D $RPM_BUILD_ROOT/%{prefix}/picoMgr/include/picoMgr.h
install -m 655 picoMgr/include/picoMgrProto.h -D $RPM_BUILD_ROOT/%{prefix}/picoMgr/include/picoMgrProto.h
install -m 655 picoMgr/include/picoStim.h -D $RPM_BUILD_ROOT/%{prefix}/picoMgr/include/picoStim.h
install -m 655 picoMgr/include/picoStimProto.h -D $RPM_BUILD_ROOT/%{prefix}/picoMgr/include/picoStimProto.h
install -m 655 picoMgr/Makefile -D $RPM_BUILD_ROOT/%{prefix}/picoMgr/Makefile
install -m 655 picoMgr/src/Makefile -D $RPM_BUILD_ROOT/%{prefix}/picoMgr/src/Makefile
install -m 655 picoMgr/src/picoMgr.c -D $RPM_BUILD_ROOT/%{prefix}/picoMgr/src/picoMgr.c
install -m 655 picoMgr/src/picoMgrInit.c -D $RPM_BUILD_ROOT/%{prefix}/picoMgr/src/picoMgrInit.c
install -m 655 picoMgr/src/picoMgrUtils.c -D $RPM_BUILD_ROOT/%{prefix}/picoMgr/src/picoMgrUtils.c
install -m 655 picoMgr/test/guiStim.c -D $RPM_BUILD_ROOT/%{prefix}/picoMgr/test/guiStim.c
install -m 655 picoMgr/test/guiStimInit.c -D $RPM_BUILD_ROOT/%{prefix}/picoMgr/test/guiStimInit.c
install -m 655 picoMgr/test/guiStimUtils.c -D $RPM_BUILD_ROOT/%{prefix}/picoMgr/test/guiStimUtils.c
install -m 655 picoMgr/test/Makefile -D $RPM_BUILD_ROOT/%{prefix}/picoMgr/test/Makefile
install -m 655 picoMgr/test/picoStim.c -D $RPM_BUILD_ROOT/%{prefix}/picoMgr/test/picoStim.c
install -m 655 picoMgr/test/picoStimInit.c -D $RPM_BUILD_ROOT/%{prefix}/picoMgr/test/picoStimInit.c
install -m 655 picoMgr/test/picoStimUtils.c -D $RPM_BUILD_ROOT/%{prefix}/picoMgr/test/picoStimUtils.c
install -m 655 picoReader/include/picoGUISimulator.h -D $RPM_BUILD_ROOT/%{prefix}/picoReader/include/picoGUISimulator.h
install -m 655 picoReader/include/picoGUISimulatorProto.h -D $RPM_BUILD_ROOT/%{prefix}/picoReader/include/picoGUISimulatorProto.h
install -m 655 picoReader/include/picoMgrSimulator.h -D $RPM_BUILD_ROOT/%{prefix}/picoReader/include/picoMgrSimulator.h
install -m 655 picoReader/include/picoMgrSimulatorProto.h -D $RPM_BUILD_ROOT/%{prefix}/picoReader/include/picoMgrSimulatorProto.h
install -m 655 picoReader/Makefile -D $RPM_BUILD_ROOT/%{prefix}/picoReader/Makefile
install -m 655 picoReader/src/angleUtils.tcl -D $RPM_BUILD_ROOT/%{prefix}/picoReader/src/angleUtils.tcl
install -m 655 picoReader/src/bottomPart.tcl -D $RPM_BUILD_ROOT/%{prefix}/picoReader/src/bottomPart.tcl
install -m 655 picoReader/src/globalVars.tcl -D $RPM_BUILD_ROOT/%{prefix}/picoReader/src/globalVars.tcl
install -m 655 picoReader/src/graceUtils.tcl -D $RPM_BUILD_ROOT/%{prefix}/picoReader/src/graceUtils.tcl
install -m 655 picoReader/src/lightUtils.tcl -D $RPM_BUILD_ROOT/%{prefix}/picoReader/src/lightUtils.tcl
install -m 655 picoReader/src/Makefile -D $RPM_BUILD_ROOT/%{prefix}/picoReader/src/Makefile
install -m 655 picoReader/src/miscUtils.tcl -D $RPM_BUILD_ROOT/%{prefix}/picoReader/src/miscUtils.tcl
install -m 655 picoReader/src/phUtils.tcl -D $RPM_BUILD_ROOT/%{prefix}/picoReader/src/phUtils.tcl
install -m 655 picoReader/src/resistanceUtils.tcl -D $RPM_BUILD_ROOT/%{prefix}/picoReader/src/resistanceUtils.tcl
install -m 655 picoReader/src/soundUtils.tcl -D $RPM_BUILD_ROOT/%{prefix}/picoReader/src/soundUtils.tcl
install -m 655 picoReader/src/temperatureUtils.tcl -D $RPM_BUILD_ROOT/%{prefix}/picoReader/src/temperatureUtils.tcl
install -m 655 picoReader/src/topPart.tcl -D $RPM_BUILD_ROOT/%{prefix}/picoReader/src/topPart.tcl
install -m 655 picoReader/src/voltageUtils.tcl -D $RPM_BUILD_ROOT/%{prefix}/picoReader/src/voltageUtils.tcl
install -m 655 picoReader/src/waveUtils.tcl -D $RPM_BUILD_ROOT/%{prefix}/picoReader/src/waveUtils.tcl
install -m 655 picoReader/test/Makefile -D $RPM_BUILD_ROOT/%{prefix}/picoReader/test/Makefile
install -m 655 picoReader/test/picoGUISimulator.c -D $RPM_BUILD_ROOT/%{prefix}/picoReader/test/picoGUISimulator.c
install -m 655 picoReader/test/picoGUISimulatorInit.c -D $RPM_BUILD_ROOT/%{prefix}/picoReader/test/picoGUISimulatorInit.c
install -m 655 picoReader/test/picoGUISimulatorUtils.c -D $RPM_BUILD_ROOT/%{prefix}/picoReader/test/picoGUISimulatorUtils.c
install -m 655 picoReader/test/picoMgrSimulator.c -D $RPM_BUILD_ROOT/%{prefix}/picoReader/test/picoMgrSimulator.c
install -m 655 picoReader/test/picoMgrSimulatorInit.c -D $RPM_BUILD_ROOT/%{prefix}/picoReader/test/picoMgrSimulatorInit.c
install -m 655 picoReader/test/picoMgrSimulatorUtils.c -D $RPM_BUILD_ROOT/%{prefix}/picoReader/test/picoMgrSimulatorUtils.c
install -m 655 scripts/seetask -D $RPM_BUILD_ROOT/%{prefix}/scripts/seetask
install -m 655 testing/templates/desc_template -D $RPM_BUILD_ROOT/%{prefix}/testing/templates/desc_template
install -m 655 testing/templates/run_template -D $RPM_BUILD_ROOT/%{prefix}/testing/templates/run_template
install -m 655 testing/templates/setup_template -D $RPM_BUILD_ROOT/%{prefix}/testing/templates/setup_template
install -m 655 testing/templates/what_template -D $RPM_BUILD_ROOT/%{prefix}/testing/templates/what_template
install -m 655 testing/testb001/description -D $RPM_BUILD_ROOT/%{prefix}/testing/testb001/description
install -m 655 testing/testb001/scripts/auxtest -D $RPM_BUILD_ROOT/%{prefix}/testing/testb001/scripts/auxtest
install -m 655 testing/testb001/scripts/runtest -D $RPM_BUILD_ROOT/%{prefix}/testing/testb001/scripts/runtest
install -m 655 testing/testb001/scripts/setup -D $RPM_BUILD_ROOT/%{prefix}/testing/testb001/scripts/setup
install -m 655 testing/testb001/scripts/whathappened -D $RPM_BUILD_ROOT/%{prefix}/testing/testb001/scripts/whathappened
install -m 655 testing/testb002/description -D $RPM_BUILD_ROOT/%{prefix}/testing/testb002/description
install -m 655 testing/testb002/scripts/auxtest -D $RPM_BUILD_ROOT/%{prefix}/testing/testb002/scripts/auxtest
install -m 655 testing/testb002/scripts/runtest -D $RPM_BUILD_ROOT/%{prefix}/testing/testb002/scripts/runtest
install -m 655 testing/testb002/scripts/setup -D $RPM_BUILD_ROOT/%{prefix}/testing/testb002/scripts/setup
install -m 655 testing/testb002/scripts/whathappened -D $RPM_BUILD_ROOT/%{prefix}/testing/testb002/scripts/whathappened
install -m 655 testing/testb002t/description -D $RPM_BUILD_ROOT/%{prefix}/testing/testb002t/description
install -m 655 testing/testb002t/scripts/auxtest -D $RPM_BUILD_ROOT/%{prefix}/testing/testb002t/scripts/auxtest
install -m 655 testing/testb002t/scripts/runtest -D $RPM_BUILD_ROOT/%{prefix}/testing/testb002t/scripts/runtest
install -m 655 testing/testb002t/scripts/setup -D $RPM_BUILD_ROOT/%{prefix}/testing/testb002t/scripts/setup
install -m 655 testing/testb002t/scripts/whathappened -D $RPM_BUILD_ROOT/%{prefix}/testing/testb002t/scripts/whathappened
install -m 655 testing/testb003/data/bob.dat -D $RPM_BUILD_ROOT/%{prefix}/testing/testb003/data/bob.dat
install -m 655 testing/testb003/description -D $RPM_BUILD_ROOT/%{prefix}/testing/testb003/description
install -m 655 testing/testb003/scripts/runtest -D $RPM_BUILD_ROOT/%{prefix}/testing/testb003/scripts/runtest
install -m 655 testing/testb003/scripts/setup -D $RPM_BUILD_ROOT/%{prefix}/testing/testb003/scripts/setup
install -m 655 testing/testb003/scripts/whathappened -D $RPM_BUILD_ROOT/%{prefix}/testing/testb003/scripts/whathappened
install -m 655 testing/testb004/description -D $RPM_BUILD_ROOT/%{prefix}/testing/testb004/description
install -m 655 testing/testb004/scripts/runtest -D $RPM_BUILD_ROOT/%{prefix}/testing/testb004/scripts/runtest
install -m 655 testing/testb004/scripts/setup -D $RPM_BUILD_ROOT/%{prefix}/testing/testb004/scripts/setup
install -m 655 testing/testb004/scripts/whathappened -D $RPM_BUILD_ROOT/%{prefix}/testing/testb004/scripts/whathappened
install -m 655 testing/testb005/description -D $RPM_BUILD_ROOT/%{prefix}/testing/testb005/description
install -m 655 testing/testb005/scripts/runtest -D $RPM_BUILD_ROOT/%{prefix}/testing/testb005/scripts/runtest
install -m 655 testing/testb005/scripts/setup -D $RPM_BUILD_ROOT/%{prefix}/testing/testb005/scripts/setup
install -m 655 testing/testb005/scripts/whathappened -D $RPM_BUILD_ROOT/%{prefix}/testing/testb005/scripts/whathappened
install -m 655 testing/testb006/description -D $RPM_BUILD_ROOT/%{prefix}/testing/testb006/description
install -m 655 testing/testb006/scripts/runtest -D $RPM_BUILD_ROOT/%{prefix}/testing/testb006/scripts/runtest
install -m 655 testing/testb006/scripts/setup -D $RPM_BUILD_ROOT/%{prefix}/testing/testb006/scripts/setup
install -m 655 testing/testb006/scripts/whathappened -D $RPM_BUILD_ROOT/%{prefix}/testing/testb006/scripts/whathappened
install -m 655 testing/testj001/description -D $RPM_BUILD_ROOT/%{prefix}/testing/testj001/description
install -m 655 testing/testj001/scripts/auxtest -D $RPM_BUILD_ROOT/%{prefix}/testing/testj001/scripts/auxtest
install -m 655 testing/testj001/scripts/runtest -D $RPM_BUILD_ROOT/%{prefix}/testing/testj001/scripts/runtest
install -m 655 testing/testj001/scripts/setup -D $RPM_BUILD_ROOT/%{prefix}/testing/testj001/scripts/setup
install -m 655 testing/testj001/scripts/whathappened -D $RPM_BUILD_ROOT/%{prefix}/testing/testj001/scripts/whathappened
install -m 655 testing/testj002/description -D $RPM_BUILD_ROOT/%{prefix}/testing/testj002/description
install -m 655 testing/testj002/scripts/auxtest -D $RPM_BUILD_ROOT/%{prefix}/testing/testj002/scripts/auxtest
install -m 655 testing/testj002/scripts/runtest -D $RPM_BUILD_ROOT/%{prefix}/testing/testj002/scripts/runtest
install -m 655 testing/testj002/scripts/setup -D $RPM_BUILD_ROOT/%{prefix}/testing/testj002/scripts/setup
install -m 655 testing/testj002/scripts/whathappened -D $RPM_BUILD_ROOT/%{prefix}/testing/testj002/scripts/whathappened
install -m 655 testing/testj003/data/bob.dat -D $RPM_BUILD_ROOT/%{prefix}/testing/testj003/data/bob.dat
install -m 655 testing/testj003/description -D $RPM_BUILD_ROOT/%{prefix}/testing/testj003/description
install -m 655 testing/testj003/scripts/runtest -D $RPM_BUILD_ROOT/%{prefix}/testing/testj003/scripts/runtest
install -m 655 testing/testj003/scripts/setup -D $RPM_BUILD_ROOT/%{prefix}/testing/testj003/scripts/setup
install -m 655 testing/testj003/scripts/whathappened -D $RPM_BUILD_ROOT/%{prefix}/testing/testj003/scripts/whathappened
install -m 655 testing/testj004/description -D $RPM_BUILD_ROOT/%{prefix}/testing/testj004/description
install -m 655 testing/testj004/scripts/runtest -D $RPM_BUILD_ROOT/%{prefix}/testing/testj004/scripts/runtest
install -m 655 testing/testj004/scripts/setup -D $RPM_BUILD_ROOT/%{prefix}/testing/testj004/scripts/setup
install -m 655 testing/testj004/scripts/whathappened -D $RPM_BUILD_ROOT/%{prefix}/testing/testj004/scripts/whathappened
install -m 655 testing/testj004a/description -D $RPM_BUILD_ROOT/%{prefix}/testing/testj004a/description
install -m 655 testing/testj004a/scripts/runtest -D $RPM_BUILD_ROOT/%{prefix}/testing/testj004a/scripts/runtest
install -m 655 testing/testj004a/scripts/setup -D $RPM_BUILD_ROOT/%{prefix}/testing/testj004a/scripts/setup
install -m 655 testing/testj004a/scripts/whathappened -D $RPM_BUILD_ROOT/%{prefix}/testing/testj004a/scripts/whathappened
install -m 655 testing/testj005/description -D $RPM_BUILD_ROOT/%{prefix}/testing/testj005/description
install -m 655 testing/testj005/scripts/auxtest -D $RPM_BUILD_ROOT/%{prefix}/testing/testj005/scripts/auxtest
install -m 655 testing/testj005/scripts/runtest -D $RPM_BUILD_ROOT/%{prefix}/testing/testj005/scripts/runtest
install -m 655 testing/testj005/scripts/setup -D $RPM_BUILD_ROOT/%{prefix}/testing/testj005/scripts/setup
install -m 655 testing/testj005/scripts/whathappened -D $RPM_BUILD_ROOT/%{prefix}/testing/testj005/scripts/whathappened
install -m 655 testing/testj006/description -D $RPM_BUILD_ROOT/%{prefix}/testing/testj006/description
install -m 655 testing/testj006/scripts/auxtest -D $RPM_BUILD_ROOT/%{prefix}/testing/testj006/scripts/auxtest
install -m 655 testing/testj006/scripts/runtest -D $RPM_BUILD_ROOT/%{prefix}/testing/testj006/scripts/runtest
install -m 655 testing/testj006/scripts/setup -D $RPM_BUILD_ROOT/%{prefix}/testing/testj006/scripts/setup
install -m 655 testing/testj006/scripts/whathappened -D $RPM_BUILD_ROOT/%{prefix}/testing/testj006/scripts/whathappened

install -m 655 icons/DrDAQ50x50.png -D $RPM_BUILD_ROOT/usr/share/icons/DrDAQ50x50.png

install -m 755 -d -D $RPM_BUILD_ROOT%{_menudir}
install -m 755 -d -D $RPM_BUILD_ROOT%{_prefix}/bin

cat << EOF > $RPM_BUILD_ROOT%{_menudir}/%name
?package(drdaq):\
        needs="X11"\
        icon="DrDAQ50x50.png"\
        section="More Applications/Sciences/Other"\
        title="DrDAQ"\
        longtitle="DrDAQ Application Project"\
        command="drdaq"
EOF

export SIMPL_HOME=/usr/lib/simpl
export DRDAQ_HOME=$RPM_BUILD_ROOT/%{prefix}

cd $RPM_BUILD_ROOT/%{prefix}

make > $DRDAQ_HOME/make.out  2>&1
make install >> $DRDAQ_HOME/make.out 2>&1

ln -sf %{prefix}/bin/drdaq $RPM_BUILD_ROOT%{_prefix}/bin/drdaq

%post
%{update_menus}

%postun
%{clean_menus}
rm -rf %{prefix}

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%{prefix}/*
%{_prefix}/bin/*

%doc docs/Readme docs/Leiame

%{_iconsdir}/DrDAQ50x50.png

%{_menudir}/%name

%changelog

* Fri Oct 17 2009 Jose Eduardo Martins <jemartins@fis.unb.br>
- new release with with bug fix

* Sat Jan 26 2008 Jose Eduardo Martins <jemartins@fis.unb.br>
- new version with calibrate feature

* Thu Jan 11 2007 Jose Eduardo Martins <jemartins@fis.unb.br>
- added if for tcl-devel

* Tue Sep 26 2006 Jose Eduardo Martins <jemartins@fis.unb.br>
- new spec for 0.40 version

* Sat Aug 05 2006 Jose Eduardo Martins <jemartins@fis.unb.br>
- First spec for DrDAQ source.


