%define prefix %{_prefix}/lib/simpl

Summary:	This project aims to bring this powerful messaging paradigm to the Open Source application developer.
Name:		simpltest
Version:	1.0
Release:	1mdk
License:	GPL
Group:          System
Source:	        simpltest.1.0.tar.bz2
BuildRoot:	%{_tmppath}/%{name}-%{version}-root

Requires:       simpl = 3.1.0

Conflicts:      simplbin

%description

%prep
%setup

%build

%install

install -D -m 655 scripts/auxtest $RPM_BUILD_ROOT/%{prefix}/scripts/auxtest
install -D -m 655 scripts/copytest $RPM_BUILD_ROOT/%{prefix}/scripts/copytest
install -D -m 655 scripts/datatest $RPM_BUILD_ROOT/%{prefix}/scripts/datatest
install -D -m 655 scripts/dotest $RPM_BUILD_ROOT/%{prefix}/scripts/dotest
install -D -m 655 scripts/linktest $RPM_BUILD_ROOT/%{prefix}/scripts/linktest
install -D -m 655 scripts/posttest $RPM_BUILD_ROOT/%{prefix}/scripts/posttest
install -D -m 655 scripts/pretest $RPM_BUILD_ROOT/%{prefix}/scripts/pretest
install -D -m 655 scripts/seetest $RPM_BUILD_ROOT/%{prefix}/scripts/seetest
install -D -m 655 scripts/viewtest $RPM_BUILD_ROOT/%{prefix}/scripts/viewtest
install -D -m 655 testing/templates/desc_template $RPM_BUILD_ROOT/%{prefix}/testing/templates/desc_template
install -D -m 655 testing/templates/run_template $RPM_BUILD_ROOT/%{prefix}/testing/templates/run_template
install -D -m 655 testing/templates/setup_template $RPM_BUILD_ROOT/%{prefix}/testing/templates/setup_template
install -D -m 655 testing/templates/what_template $RPM_BUILD_ROOT/%{prefix}/testing/templates/what_template
install -D -m 655 testing/tests0001/data/trigger $RPM_BUILD_ROOT/%{prefix}/testing/tests0001/data/trigger
install -D -m 655 testing/tests0001/description $RPM_BUILD_ROOT/%{prefix}/testing/tests0001/description
install -D -m 655 testing/tests0001/results/trigger $RPM_BUILD_ROOT/%{prefix}/testing/tests0001/results/trigger
install -D -m 655 testing/tests0001/scripts/runtest $RPM_BUILD_ROOT/%{prefix}/testing/tests0001/scripts/runtest
install -D -m 655 testing/tests0001/scripts/setup $RPM_BUILD_ROOT/%{prefix}/testing/tests0001/scripts/setup
install -D -m 655 testing/tests0001/scripts/whathappened $RPM_BUILD_ROOT/%{prefix}/testing/tests0001/scripts/whathappened
install -D -m 655 testing/tests0002/data/trigger $RPM_BUILD_ROOT/%{prefix}/testing/tests0002/data/trigger
install -D -m 655 testing/tests0002/description $RPM_BUILD_ROOT/%{prefix}/testing/tests0002/description
install -D -m 655 testing/tests0002/results/trigger $RPM_BUILD_ROOT/%{prefix}/testing/tests0002/results/trigger
install -D -m 655 testing/tests0002/scripts/runtest $RPM_BUILD_ROOT/%{prefix}/testing/tests0002/scripts/runtest
install -D -m 655 testing/tests0002/scripts/setup $RPM_BUILD_ROOT/%{prefix}/testing/tests0002/scripts/setup
install -D -m 655 testing/tests0002/scripts/whathappened $RPM_BUILD_ROOT/%{prefix}/testing/tests0002/scripts/whathappened

%clean
rm -rf $RPM_BUILD_ROOT

%post  

%{update_menus}

%postun
%{clean_menus}
rm -rf %{prefix}

%files
%defattr(-,root,root)
%{prefix}/*

%doc docs/readme.testing

%changelog

* Wed Aug 16 2006 José Eduardo Martins <jemartins@fis.unb.br>
- first spec for Simpltest files

