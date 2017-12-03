%define prefix %{_prefix}/local/share/swig/1.3.29

Summary:	Simplified Wrapper and Interface Generator
Name:		swig
Version:	1.3.29
Release:	1mdk
License:	GPL
Group:		Development
Source:		swig-1.3.29.tar.bz2
BuildRoot:	%{_tmppath}/%{name}-%{version}-root

BuildRequires: 	gcc
BuildRequires: 	gcc-c++
BuildRequires: 	python >= 1.5
BuildRequires: 	perl >= 5.003
BuildRequires: 	guile >= 1.3.4

%description
Version: 1.3.29 (March 21, 2006)

Tagline: SWIG is a compiler that integrates C and C++ with languages
         including Perl, Python, Tcl, Ruby, PHP, Java, Ocaml, Lua,
         Scheme (Guile, MzScheme, CHICKEN), Pike, C#, Modula-3, and
         Common Lisp (CLISP, Allegro CL, CFFI, UFFI).

SWIG reads annotated C/C++ header files and creates wrapper code (glue
code) in order to make the corresponding C/C++ libraries available to
the listed languages, or to extend C/C++ programs with a scripting
language.

This distribution represents the latest development release of SWIG.
The guilty parties working on this are:

%prep
%setup

%build
#./configure --prefix=$HOME/RPM/BUILD/swig-1.3.29 --exec-prefix=$HOME/RPM/BUILD/swig-1.3.29/share/swig/1.3.29
./configure
make

%install
rm -rf $RPM_BUILD_ROOT
rm -rf $/usr/local/share/swig

make install

cd /%{prefix}

install -D -s -m 655 allkw.swg $RPM_BUILD_ROOT/%{prefix}/allkw.swg
install -D -s -m 655 attribute.i $RPM_BUILD_ROOT/%{prefix}/attribute.i
install -D -s -m 655 carrays.i $RPM_BUILD_ROOT/%{prefix}/carrays.i
install -D -s -m 655 cdata.i $RPM_BUILD_ROOT/%{prefix}/cdata.i
install -D -s -m 655 cmalloc.i $RPM_BUILD_ROOT/%{prefix}/cmalloc.i
install -D -s -m 655 constraints.i $RPM_BUILD_ROOT/%{prefix}/constraints.i
install -D -s -m 655 cpointer.i $RPM_BUILD_ROOT/%{prefix}/cpointer.i
install -D -s -m 655 cstring.i $RPM_BUILD_ROOT/%{prefix}/cstring.i
install -D -s -m 655 cwstring.i $RPM_BUILD_ROOT/%{prefix}/cwstring.i
install -D -s -m 655 exception.i $RPM_BUILD_ROOT/%{prefix}/exception.i
install -D -s -m 655 inttypes.i $RPM_BUILD_ROOT/%{prefix}/inttypes.i
install -D -s -m 655 math.i $RPM_BUILD_ROOT/%{prefix}/math.i
install -D -s -m 655 pointer.i $RPM_BUILD_ROOT/%{prefix}/pointer.i
install -D -s -m 655 runtime.swg $RPM_BUILD_ROOT/%{prefix}/runtime.swg
install -D -s -m 655 std_except.i $RPM_BUILD_ROOT/%{prefix}/std_except.i
install -D -s -m 655 stdint.i $RPM_BUILD_ROOT/%{prefix}/stdint.i
install -D -s -m 655 stl.i $RPM_BUILD_ROOT/%{prefix}/stl.i
install -D -s -m 655 swigarch.i $RPM_BUILD_ROOT/%{prefix}/swigarch.i
install -D -s -m 655 swigerrors.swg $RPM_BUILD_ROOT/%{prefix}/swigerrors.swg
install -D -s -m 655 swiginit.swg $RPM_BUILD_ROOT/%{prefix}/swiginit.swg
install -D -s -m 655 swiglabels.swg $RPM_BUILD_ROOT/%{prefix}/swiglabels.swg
install -D -s -m 655 swigrun.i $RPM_BUILD_ROOT/%{prefix}/swigrun.i
install -D -s -m 655 swigrun.swg $RPM_BUILD_ROOT/%{prefix}/swigrun.swg
install -D -s -m 655 swig.swg $RPM_BUILD_ROOT/%{prefix}/swig.swg
install -D -s -m 655 swigwarnings.swg $RPM_BUILD_ROOT/%{prefix}/swigwarnings.swg
install -D -s -m 655 swigwarn.swg $RPM_BUILD_ROOT/%{prefix}/swigwarn.swg
install -D -s -m 655 wchar.i $RPM_BUILD_ROOT/%{prefix}/wchar.i
install -D -s -m 655 windows.i $RPM_BUILD_ROOT/%{prefix}/windows.i
install -D -s -m 655 allegrocl/allegrocl.swg $RPM_BUILD_ROOT/%{prefix}/allegrocl/allegrocl.swg
install -D -s -m 655 allegrocl/inout_typemaps.i $RPM_BUILD_ROOT/%{prefix}/allegrocl/inout_typemaps.i
install -D -s -m 655 allegrocl/longlongs.i $RPM_BUILD_ROOT/%{prefix}/allegrocl/longlongs.i
install -D -s -m 655 allegrocl/typemaps.i $RPM_BUILD_ROOT/%{prefix}/allegrocl/typemaps.i
install -D -s -m 655 cffi/cffi.swg $RPM_BUILD_ROOT/%{prefix}/cffi/cffi.swg
install -D -s -m 655 chicken/chickenkw.swg $RPM_BUILD_ROOT/%{prefix}/chicken/chickenkw.swg
install -D -s -m 655 chicken/chickenrun.swg $RPM_BUILD_ROOT/%{prefix}/chicken/chickenrun.swg
install -D -s -m 655 chicken/chicken.swg $RPM_BUILD_ROOT/%{prefix}/chicken/chicken.swg
install -D -s -m 655 chicken/multi-generic.scm $RPM_BUILD_ROOT/%{prefix}/chicken/multi-generic.scm
install -D -s -m 655 chicken/std_string.i $RPM_BUILD_ROOT/%{prefix}/chicken/std_string.i
install -D -s -m 655 chicken/swigclosprefix.scm $RPM_BUILD_ROOT/%{prefix}/chicken/swigclosprefix.scm
install -D -s -m 655 chicken/tinyclos-multi-generic.patch $RPM_BUILD_ROOT/%{prefix}/chicken/tinyclos-multi-generic.patch
install -D -s -m 655 chicken/typemaps.i $RPM_BUILD_ROOT/%{prefix}/chicken/typemaps.i
install -D -s -m 655 clisp/clisp.swg $RPM_BUILD_ROOT/%{prefix}/clisp/clisp.swg
install -D -s -m 655 csharp/csharphead.swg $RPM_BUILD_ROOT/%{prefix}/csharp/csharphead.swg
install -D -s -m 655 csharp/csharpkw.swg $RPM_BUILD_ROOT/%{prefix}/csharp/csharpkw.swg
install -D -s -m 655 csharp/csharp.swg $RPM_BUILD_ROOT/%{prefix}/csharp/csharp.swg
install -D -s -m 655 csharp/enumsimple.swg $RPM_BUILD_ROOT/%{prefix}/csharp/enumsimple.swg
install -D -s -m 655 csharp/enums.swg $RPM_BUILD_ROOT/%{prefix}/csharp/enums.swg
install -D -s -m 655 csharp/enumtypesafe.swg $RPM_BUILD_ROOT/%{prefix}/csharp/enumtypesafe.swg
install -D -s -m 655 csharp/std_common.i $RPM_BUILD_ROOT/%{prefix}/csharp/std_common.i
install -D -s -m 655 csharp/std_deque.i $RPM_BUILD_ROOT/%{prefix}/csharp/std_deque.i
install -D -s -m 655 csharp/std_except.i $RPM_BUILD_ROOT/%{prefix}/csharp/std_except.i
install -D -s -m 655 csharp/std_map.i $RPM_BUILD_ROOT/%{prefix}/csharp/std_map.i
install -D -s -m 655 csharp/std_pair.i $RPM_BUILD_ROOT/%{prefix}/csharp/std_pair.i
install -D -s -m 655 csharp/std_string.i $RPM_BUILD_ROOT/%{prefix}/csharp/std_string.i
install -D -s -m 655 csharp/std_vector.i $RPM_BUILD_ROOT/%{prefix}/csharp/std_vector.i
install -D -s -m 655 csharp/stl.i $RPM_BUILD_ROOT/%{prefix}/csharp/stl.i
install -D -s -m 655 csharp/typemaps.i $RPM_BUILD_ROOT/%{prefix}/csharp/typemaps.i
install -D -s -m 655 gcj/cni.i $RPM_BUILD_ROOT/%{prefix}/gcj/cni.i
install -D -s -m 655 gcj/cni.swg $RPM_BUILD_ROOT/%{prefix}/gcj/cni.swg
install -D -s -m 655 gcj/javaprims.i $RPM_BUILD_ROOT/%{prefix}/gcj/javaprims.i
install -D -s -m 655 guile/common.scm $RPM_BUILD_ROOT/%{prefix}/guile/common.scm
install -D -s -m 655 guile/cplusplus.i $RPM_BUILD_ROOT/%{prefix}/guile/cplusplus.i
install -D -s -m 655 guile/ghinterface.i $RPM_BUILD_ROOT/%{prefix}/guile/ghinterface.i
install -D -s -m 655 guile/guile_gh_run.swg $RPM_BUILD_ROOT/%{prefix}/guile/guile_gh_run.swg
install -D -s -m 655 guile/guile_gh.swg $RPM_BUILD_ROOT/%{prefix}/guile/guile_gh.swg
install -D -s -m 655 guile/guile.i $RPM_BUILD_ROOT/%{prefix}/guile/guile.i
install -D -s -m 655 guile/guilemain.i $RPM_BUILD_ROOT/%{prefix}/guile/guilemain.i
install -D -s -m 655 guile/guile_scm_run.swg $RPM_BUILD_ROOT/%{prefix}/guile/guile_scm_run.swg
install -D -s -m 655 guile/guile_scm.swg $RPM_BUILD_ROOT/%{prefix}/guile/guile_scm.swg
install -D -s -m 655 guile/interpreter.i $RPM_BUILD_ROOT/%{prefix}/guile/interpreter.i
install -D -s -m 655 guile/list-vector.i $RPM_BUILD_ROOT/%{prefix}/guile/list-vector.i
install -D -s -m 655 guile/pointer-in-out.i $RPM_BUILD_ROOT/%{prefix}/guile/pointer-in-out.i
install -D -s -m 655 guile/ports.i $RPM_BUILD_ROOT/%{prefix}/guile/ports.i
install -D -s -m 655 guile/std_common.i $RPM_BUILD_ROOT/%{prefix}/guile/std_common.i
install -D -s -m 655 guile/std_deque.i $RPM_BUILD_ROOT/%{prefix}/guile/std_deque.i
install -D -s -m 655 guile/std_except.i $RPM_BUILD_ROOT/%{prefix}/guile/std_except.i
install -D -s -m 655 guile/std_map.i $RPM_BUILD_ROOT/%{prefix}/guile/std_map.i
install -D -s -m 655 guile/std_pair.i $RPM_BUILD_ROOT/%{prefix}/guile/std_pair.i
install -D -s -m 655 guile/std_string.i $RPM_BUILD_ROOT/%{prefix}/guile/std_string.i
install -D -s -m 655 guile/std_vector.i $RPM_BUILD_ROOT/%{prefix}/guile/std_vector.i
install -D -s -m 655 guile/stl.i $RPM_BUILD_ROOT/%{prefix}/guile/stl.i
install -D -s -m 655 guile/swigrun.i $RPM_BUILD_ROOT/%{prefix}/guile/swigrun.i
install -D -s -m 655 guile/typemaps.i $RPM_BUILD_ROOT/%{prefix}/guile/typemaps.i
install -D -s -m 655 java/arrays_java.i $RPM_BUILD_ROOT/%{prefix}/java/arrays_java.i
install -D -s -m 655 java/director.swg $RPM_BUILD_ROOT/%{prefix}/java/director.swg
install -D -s -m 655 java/enumsimple.swg $RPM_BUILD_ROOT/%{prefix}/java/enumsimple.swg
install -D -s -m 655 java/enums.swg $RPM_BUILD_ROOT/%{prefix}/java/enums.swg
install -D -s -m 655 java/enumtypesafe.swg $RPM_BUILD_ROOT/%{prefix}/java/enumtypesafe.swg
install -D -s -m 655 java/enumtypeunsafe.swg $RPM_BUILD_ROOT/%{prefix}/java/enumtypeunsafe.swg
install -D -s -m 655 java/javahead.swg $RPM_BUILD_ROOT/%{prefix}/java/javahead.swg
install -D -s -m 655 java/javakw.swg $RPM_BUILD_ROOT/%{prefix}/java/javakw.swg
install -D -s -m 655 java/java.swg $RPM_BUILD_ROOT/%{prefix}/java/java.swg
install -D -s -m 655 java/std_common.i $RPM_BUILD_ROOT/%{prefix}/java/std_common.i
install -D -s -m 655 java/std_deque.i $RPM_BUILD_ROOT/%{prefix}/java/std_deque.i
install -D -s -m 655 java/std_except.i $RPM_BUILD_ROOT/%{prefix}/java/std_except.i
install -D -s -m 655 java/std_map.i $RPM_BUILD_ROOT/%{prefix}/java/std_map.i
install -D -s -m 655 java/std_pair.i $RPM_BUILD_ROOT/%{prefix}/java/std_pair.i
install -D -s -m 655 java/std_string.i $RPM_BUILD_ROOT/%{prefix}/java/std_string.i
install -D -s -m 655 java/std_vector.i $RPM_BUILD_ROOT/%{prefix}/java/std_vector.i
install -D -s -m 655 java/std_wstring.i $RPM_BUILD_ROOT/%{prefix}/java/std_wstring.i
install -D -s -m 655 java/stl.i $RPM_BUILD_ROOT/%{prefix}/java/stl.i
install -D -s -m 655 java/typemaps.i $RPM_BUILD_ROOT/%{prefix}/java/typemaps.i
install -D -s -m 655 java/various.i $RPM_BUILD_ROOT/%{prefix}/java/various.i
install -D -s -m 655 lua/luarun.swg $RPM_BUILD_ROOT/%{prefix}/lua/luarun.swg
install -D -s -m 655 lua/lua.swg $RPM_BUILD_ROOT/%{prefix}/lua/lua.swg
install -D -s -m 655 lua/_std_common.i $RPM_BUILD_ROOT/%{prefix}/lua/_std_common.i
install -D -s -m 655 lua/std_deque.i $RPM_BUILD_ROOT/%{prefix}/lua/std_deque.i
install -D -s -m 655 lua/std_except.i $RPM_BUILD_ROOT/%{prefix}/lua/std_except.i
install -D -s -m 655 lua/std_pair.i $RPM_BUILD_ROOT/%{prefix}/lua/std_pair.i
install -D -s -m 655 lua/std_string.i $RPM_BUILD_ROOT/%{prefix}/lua/std_string.i
install -D -s -m 655 lua/std_vector.i $RPM_BUILD_ROOT/%{prefix}/lua/std_vector.i
install -D -s -m 655 lua/typemaps.i $RPM_BUILD_ROOT/%{prefix}/lua/typemaps.i
install -D -s -m 655 modula3/modula3head.swg $RPM_BUILD_ROOT/%{prefix}/modula3/modula3head.swg
install -D -s -m 655 modula3/modula3.swg $RPM_BUILD_ROOT/%{prefix}/modula3/modula3.swg
install -D -s -m 655 modula3/typemaps.i $RPM_BUILD_ROOT/%{prefix}/modula3/typemaps.i
install -D -s -m 655 mzscheme/mzrun.swg $RPM_BUILD_ROOT/%{prefix}/mzscheme/mzrun.swg
install -D -s -m 655 mzscheme/mzscheme.swg $RPM_BUILD_ROOT/%{prefix}/mzscheme/mzscheme.swg
install -D -s -m 655 mzscheme/std_common.i $RPM_BUILD_ROOT/%{prefix}/mzscheme/std_common.i
install -D -s -m 655 mzscheme/std_deque.i $RPM_BUILD_ROOT/%{prefix}/mzscheme/std_deque.i
install -D -s -m 655 mzscheme/std_map.i $RPM_BUILD_ROOT/%{prefix}/mzscheme/std_map.i
install -D -s -m 655 mzscheme/std_pair.i $RPM_BUILD_ROOT/%{prefix}/mzscheme/std_pair.i
install -D -s -m 655 mzscheme/std_string.i $RPM_BUILD_ROOT/%{prefix}/mzscheme/std_string.i
install -D -s -m 655 mzscheme/std_vector.i $RPM_BUILD_ROOT/%{prefix}/mzscheme/std_vector.i
install -D -s -m 655 mzscheme/stl.i $RPM_BUILD_ROOT/%{prefix}/mzscheme/stl.i
install -D -s -m 655 mzscheme/typemaps.i $RPM_BUILD_ROOT/%{prefix}/mzscheme/typemaps.i
install -D -s -m 655 ocaml/carray.i $RPM_BUILD_ROOT/%{prefix}/ocaml/carray.i
install -D -s -m 655 ocaml/class.swg $RPM_BUILD_ROOT/%{prefix}/ocaml/class.swg
install -D -s -m 655 ocaml/cstring.i $RPM_BUILD_ROOT/%{prefix}/ocaml/cstring.i
install -D -s -m 655 ocaml/director.swg $RPM_BUILD_ROOT/%{prefix}/ocaml/director.swg
install -D -s -m 655 ocaml/ocamldec.swg $RPM_BUILD_ROOT/%{prefix}/ocaml/ocamldec.swg
install -D -s -m 655 ocaml/ocaml.i $RPM_BUILD_ROOT/%{prefix}/ocaml/ocaml.i
install -D -s -m 655 ocaml/ocamlkw.swg $RPM_BUILD_ROOT/%{prefix}/ocaml/ocamlkw.swg
install -D -s -m 655 ocaml/ocaml.swg $RPM_BUILD_ROOT/%{prefix}/ocaml/ocaml.swg
install -D -s -m 655 ocaml/preamble.swg $RPM_BUILD_ROOT/%{prefix}/ocaml/preamble.swg
install -D -s -m 655 ocaml/std_common.i $RPM_BUILD_ROOT/%{prefix}/ocaml/std_common.i
install -D -s -m 655 ocaml/std_complex.i $RPM_BUILD_ROOT/%{prefix}/ocaml/std_complex.i
install -D -s -m 655 ocaml/std_deque.i $RPM_BUILD_ROOT/%{prefix}/ocaml/std_deque.i
install -D -s -m 655 ocaml/std_list.i $RPM_BUILD_ROOT/%{prefix}/ocaml/std_list.i
install -D -s -m 655 ocaml/std_map.i $RPM_BUILD_ROOT/%{prefix}/ocaml/std_map.i
install -D -s -m 655 ocaml/std_pair.i $RPM_BUILD_ROOT/%{prefix}/ocaml/std_pair.i
install -D -s -m 655 ocaml/std_string.i $RPM_BUILD_ROOT/%{prefix}/ocaml/std_string.i
install -D -s -m 655 ocaml/std_vector.i $RPM_BUILD_ROOT/%{prefix}/ocaml/std_vector.i
install -D -s -m 655 ocaml/stl.i $RPM_BUILD_ROOT/%{prefix}/ocaml/stl.i
install -D -s -m 655 ocaml/swig.ml $RPM_BUILD_ROOT/%{prefix}/ocaml/swig.ml
install -D -s -m 655 ocaml/swig.mli $RPM_BUILD_ROOT/%{prefix}/ocaml/swig.mli
install -D -s -m 655 ocaml/swigp4.ml $RPM_BUILD_ROOT/%{prefix}/ocaml/swigp4.ml
install -D -s -m 655 ocaml/typecheck.i $RPM_BUILD_ROOT/%{prefix}/ocaml/typecheck.i
install -D -s -m 655 ocaml/typemaps.i $RPM_BUILD_ROOT/%{prefix}/ocaml/typemaps.i
install -D -s -m 655 ocaml/typeregister.swg $RPM_BUILD_ROOT/%{prefix}/ocaml/typeregister.swg
install -D -s -m 655 perl5/attribute.i $RPM_BUILD_ROOT/%{prefix}/perl5/attribute.i
install -D -s -m 655 perl5/carrays.i $RPM_BUILD_ROOT/%{prefix}/perl5/carrays.i
install -D -s -m 655 perl5/cdata.i $RPM_BUILD_ROOT/%{prefix}/perl5/cdata.i
install -D -s -m 655 perl5/cmalloc.i $RPM_BUILD_ROOT/%{prefix}/perl5/cmalloc.i
install -D -s -m 655 perl5/cni.i $RPM_BUILD_ROOT/%{prefix}/perl5/cni.i
install -D -s -m 655 perl5/cpointer.i $RPM_BUILD_ROOT/%{prefix}/perl5/cpointer.i
install -D -s -m 655 perl5/cstring.i $RPM_BUILD_ROOT/%{prefix}/perl5/cstring.i
install -D -s -m 655 perl5/exception.i $RPM_BUILD_ROOT/%{prefix}/perl5/exception.i
install -D -s -m 655 perl5/factory.i $RPM_BUILD_ROOT/%{prefix}/perl5/factory.i
install -D -s -m 655 perl5/jstring.i $RPM_BUILD_ROOT/%{prefix}/perl5/jstring.i
install -D -s -m 655 perl5/Makefile.pl $RPM_BUILD_ROOT/%{prefix}/perl5/Makefile.pl
install -D -s -m 655 perl5/noembed.h $RPM_BUILD_ROOT/%{prefix}/perl5/noembed.h
install -D -s -m 655 perl5/perl5.swg $RPM_BUILD_ROOT/%{prefix}/perl5/perl5.swg
install -D -s -m 655 perl5/perlerrors.swg $RPM_BUILD_ROOT/%{prefix}/perl5/perlerrors.swg
install -D -s -m 655 perl5/perlfragments.swg $RPM_BUILD_ROOT/%{prefix}/perl5/perlfragments.swg
install -D -s -m 655 perl5/perlhead.swg $RPM_BUILD_ROOT/%{prefix}/perl5/perlhead.swg
install -D -s -m 655 perl5/perlinit.swg $RPM_BUILD_ROOT/%{prefix}/perl5/perlinit.swg
install -D -s -m 655 perl5/perlkw.swg $RPM_BUILD_ROOT/%{prefix}/perl5/perlkw.swg
install -D -s -m 655 perl5/perlmacros.swg $RPM_BUILD_ROOT/%{prefix}/perl5/perlmacros.swg
install -D -s -m 655 perl5/perlmain.i $RPM_BUILD_ROOT/%{prefix}/perl5/perlmain.i
install -D -s -m 655 perl5/perlopers.swg $RPM_BUILD_ROOT/%{prefix}/perl5/perlopers.swg
install -D -s -m 655 perl5/perlprimtypes.swg $RPM_BUILD_ROOT/%{prefix}/perl5/perlprimtypes.swg
install -D -s -m 655 perl5/perlrun.swg $RPM_BUILD_ROOT/%{prefix}/perl5/perlrun.swg
install -D -s -m 655 perl5/perlruntime.swg $RPM_BUILD_ROOT/%{prefix}/perl5/perlruntime.swg
install -D -s -m 655 perl5/perlstrings.swg $RPM_BUILD_ROOT/%{prefix}/perl5/perlstrings.swg
install -D -s -m 655 perl5/perltypemaps.swg $RPM_BUILD_ROOT/%{prefix}/perl5/perltypemaps.swg
install -D -s -m 655 perl5/perluserdir.swg $RPM_BUILD_ROOT/%{prefix}/perl5/perluserdir.swg
install -D -s -m 655 perl5/reference.i $RPM_BUILD_ROOT/%{prefix}/perl5/reference.i
install -D -s -m 655 perl5/std_common.i $RPM_BUILD_ROOT/%{prefix}/perl5/std_common.i
install -D -s -m 655 perl5/std_deque.i $RPM_BUILD_ROOT/%{prefix}/perl5/std_deque.i
install -D -s -m 655 perl5/std_except.i $RPM_BUILD_ROOT/%{prefix}/perl5/std_except.i
install -D -s -m 655 perl5/std_list.i $RPM_BUILD_ROOT/%{prefix}/perl5/std_list.i
install -D -s -m 655 perl5/std_map.i $RPM_BUILD_ROOT/%{prefix}/perl5/std_map.i
install -D -s -m 655 perl5/std_pair.i $RPM_BUILD_ROOT/%{prefix}/perl5/std_pair.i
install -D -s -m 655 perl5/std_string.i $RPM_BUILD_ROOT/%{prefix}/perl5/std_string.i
install -D -s -m 655 perl5/std_vector.i $RPM_BUILD_ROOT/%{prefix}/perl5/std_vector.i
install -D -s -m 655 perl5/stl.i $RPM_BUILD_ROOT/%{prefix}/perl5/stl.i
install -D -s -m 655 perl5/typemaps.i $RPM_BUILD_ROOT/%{prefix}/perl5/typemaps.i
install -D -s -m 655 php4/const.i $RPM_BUILD_ROOT/%{prefix}/php4/const.i
install -D -s -m 655 php4/globalvar.i $RPM_BUILD_ROOT/%{prefix}/php4/globalvar.i
install -D -s -m 655 php4/php4init.swg $RPM_BUILD_ROOT/%{prefix}/php4/php4init.swg
install -D -s -m 655 php4/php4kw.swg $RPM_BUILD_ROOT/%{prefix}/php4/php4kw.swg
install -D -s -m 655 php4/php4run.swg $RPM_BUILD_ROOT/%{prefix}/php4/php4run.swg
install -D -s -m 655 php4/php4.swg $RPM_BUILD_ROOT/%{prefix}/php4/php4.swg
install -D -s -m 655 php4/phppointers.i $RPM_BUILD_ROOT/%{prefix}/php4/phppointers.i
install -D -s -m 655 php4/std_common.i $RPM_BUILD_ROOT/%{prefix}/php4/std_common.i
install -D -s -m 655 php4/std_deque.i $RPM_BUILD_ROOT/%{prefix}/php4/std_deque.i
install -D -s -m 655 php4/std_map.i $RPM_BUILD_ROOT/%{prefix}/php4/std_map.i
install -D -s -m 655 php4/std_pair.i $RPM_BUILD_ROOT/%{prefix}/php4/std_pair.i
install -D -s -m 655 php4/std_string.i $RPM_BUILD_ROOT/%{prefix}/php4/std_string.i
install -D -s -m 655 php4/std_vector.i $RPM_BUILD_ROOT/%{prefix}/php4/std_vector.i
install -D -s -m 655 php4/stl.i $RPM_BUILD_ROOT/%{prefix}/php4/stl.i
install -D -s -m 655 php4/typemaps.i $RPM_BUILD_ROOT/%{prefix}/php4/typemaps.i
install -D -s -m 655 php4/utils.i $RPM_BUILD_ROOT/%{prefix}/php4/utils.i
install -D -s -m 655 pike/pikekw.swg $RPM_BUILD_ROOT/%{prefix}/pike/pikekw.swg
install -D -s -m 655 pike/pikerun.swg $RPM_BUILD_ROOT/%{prefix}/pike/pikerun.swg
install -D -s -m 655 pike/pike.swg $RPM_BUILD_ROOT/%{prefix}/pike/pike.swg
install -D -s -m 655 pike/std_string.i $RPM_BUILD_ROOT/%{prefix}/pike/std_string.i
install -D -s -m 655 python/argcargv.i $RPM_BUILD_ROOT/%{prefix}/python/argcargv.i
install -D -s -m 655 python/attribute.i $RPM_BUILD_ROOT/%{prefix}/python/attribute.i
install -D -s -m 655 python/carrays.i $RPM_BUILD_ROOT/%{prefix}/python/carrays.i
install -D -s -m 655 python/ccomplex.i $RPM_BUILD_ROOT/%{prefix}/python/ccomplex.i
install -D -s -m 655 python/cdata.i $RPM_BUILD_ROOT/%{prefix}/python/cdata.i
install -D -s -m 655 python/cmalloc.i $RPM_BUILD_ROOT/%{prefix}/python/cmalloc.i
install -D -s -m 655 python/cni.i $RPM_BUILD_ROOT/%{prefix}/python/cni.i
install -D -s -m 655 python/complex.i $RPM_BUILD_ROOT/%{prefix}/python/complex.i
install -D -s -m 655 python/cpointer.i $RPM_BUILD_ROOT/%{prefix}/python/cpointer.i
install -D -s -m 655 python/cstring.i $RPM_BUILD_ROOT/%{prefix}/python/cstring.i
install -D -s -m 655 python/cwstring.i $RPM_BUILD_ROOT/%{prefix}/python/cwstring.i
install -D -s -m 655 python/defarg.swg $RPM_BUILD_ROOT/%{prefix}/python/defarg.swg
install -D -s -m 655 python/director_h.swg $RPM_BUILD_ROOT/%{prefix}/python/director_h.swg
install -D -s -m 655 python/director.swg $RPM_BUILD_ROOT/%{prefix}/python/director.swg
install -D -s -m 655 python/embed15.i $RPM_BUILD_ROOT/%{prefix}/python/embed15.i
install -D -s -m 655 python/embed.i $RPM_BUILD_ROOT/%{prefix}/python/embed.i
install -D -s -m 655 python/exception.i $RPM_BUILD_ROOT/%{prefix}/python/exception.i
install -D -s -m 655 python/factory.i $RPM_BUILD_ROOT/%{prefix}/python/factory.i
install -D -s -m 655 python/file.i $RPM_BUILD_ROOT/%{prefix}/python/file.i
install -D -s -m 655 python/implicit.i $RPM_BUILD_ROOT/%{prefix}/python/implicit.i
install -D -s -m 655 python/jstring.i $RPM_BUILD_ROOT/%{prefix}/python/jstring.i
install -D -s -m 655 python/pyapi.swg $RPM_BUILD_ROOT/%{prefix}/python/pyapi.swg
install -D -s -m 655 python/pybackward.swg $RPM_BUILD_ROOT/%{prefix}/python/pybackward.swg
install -D -s -m 655 python/pyclasses.swg $RPM_BUILD_ROOT/%{prefix}/python/pyclasses.swg
install -D -s -m 655 python/pycomplex.swg $RPM_BUILD_ROOT/%{prefix}/python/pycomplex.swg
install -D -s -m 655 python/pycontainer.swg $RPM_BUILD_ROOT/%{prefix}/python/pycontainer.swg
install -D -s -m 655 python/pydocs.swg $RPM_BUILD_ROOT/%{prefix}/python/pydocs.swg
install -D -s -m 655 python/pyerrors.swg $RPM_BUILD_ROOT/%{prefix}/python/pyerrors.swg
install -D -s -m 655 python/pyfragments.swg $RPM_BUILD_ROOT/%{prefix}/python/pyfragments.swg
install -D -s -m 655 python/pyhead.swg $RPM_BUILD_ROOT/%{prefix}/python/pyhead.swg
install -D -s -m 655 python/pyinit.swg $RPM_BUILD_ROOT/%{prefix}/python/pyinit.swg
install -D -s -m 655 python/pyiterators.swg $RPM_BUILD_ROOT/%{prefix}/python/pyiterators.swg
install -D -s -m 655 python/pymacros.swg $RPM_BUILD_ROOT/%{prefix}/python/pymacros.swg
install -D -s -m 655 python/pyopers.swg $RPM_BUILD_ROOT/%{prefix}/python/pyopers.swg
install -D -s -m 655 python/pyprimtypes.swg $RPM_BUILD_ROOT/%{prefix}/python/pyprimtypes.swg
install -D -s -m 655 python/pyrun.swg $RPM_BUILD_ROOT/%{prefix}/python/pyrun.swg
install -D -s -m 655 python/pyruntime.swg $RPM_BUILD_ROOT/%{prefix}/python/pyruntime.swg
install -D -s -m 655 python/pystdcommon.swg $RPM_BUILD_ROOT/%{prefix}/python/pystdcommon.swg
install -D -s -m 655 python/pystrings.swg $RPM_BUILD_ROOT/%{prefix}/python/pystrings.swg
install -D -s -m 655 python/pythonkw.swg $RPM_BUILD_ROOT/%{prefix}/python/pythonkw.swg
install -D -s -m 655 python/python.swg $RPM_BUILD_ROOT/%{prefix}/python/python.swg
install -D -s -m 655 python/pythreads.swg $RPM_BUILD_ROOT/%{prefix}/python/pythreads.swg
install -D -s -m 655 python/pytuplehlp.swg $RPM_BUILD_ROOT/%{prefix}/python/pytuplehlp.swg
install -D -s -m 655 python/pytypemaps.swg $RPM_BUILD_ROOT/%{prefix}/python/pytypemaps.swg
install -D -s -m 655 python/pyuserdir.swg $RPM_BUILD_ROOT/%{prefix}/python/pyuserdir.swg
install -D -s -m 655 python/pywstrings.swg $RPM_BUILD_ROOT/%{prefix}/python/pywstrings.swg
install -D -s -m 655 python/std_alloc.i $RPM_BUILD_ROOT/%{prefix}/python/std_alloc.i
install -D -s -m 655 python/std_basic_string.i $RPM_BUILD_ROOT/%{prefix}/python/std_basic_string.i
install -D -s -m 655 python/std_carray.i $RPM_BUILD_ROOT/%{prefix}/python/std_carray.i
install -D -s -m 655 python/std_char_traits.i $RPM_BUILD_ROOT/%{prefix}/python/std_char_traits.i
install -D -s -m 655 python/std_common.i $RPM_BUILD_ROOT/%{prefix}/python/std_common.i
install -D -s -m 655 python/std_complex.i $RPM_BUILD_ROOT/%{prefix}/python/std_complex.i
install -D -s -m 655 python/std_container.i $RPM_BUILD_ROOT/%{prefix}/python/std_container.i
install -D -s -m 655 python/std_deque.i $RPM_BUILD_ROOT/%{prefix}/python/std_deque.i
install -D -s -m 655 python/std_except.i $RPM_BUILD_ROOT/%{prefix}/python/std_except.i
install -D -s -m 655 python/std_ios.i $RPM_BUILD_ROOT/%{prefix}/python/std_ios.i
install -D -s -m 655 python/std_iostream.i $RPM_BUILD_ROOT/%{prefix}/python/std_iostream.i
install -D -s -m 655 python/std_list.i $RPM_BUILD_ROOT/%{prefix}/python/std_list.i
install -D -s -m 655 python/std_map.i $RPM_BUILD_ROOT/%{prefix}/python/std_map.i
install -D -s -m 655 python/std_multimap.i $RPM_BUILD_ROOT/%{prefix}/python/std_multimap.i
install -D -s -m 655 python/std_multiset.i $RPM_BUILD_ROOT/%{prefix}/python/std_multiset.i
install -D -s -m 655 python/std_pair.i $RPM_BUILD_ROOT/%{prefix}/python/std_pair.i
install -D -s -m 655 python/std_set.i $RPM_BUILD_ROOT/%{prefix}/python/std_set.i
install -D -s -m 655 python/std_sstream.i $RPM_BUILD_ROOT/%{prefix}/python/std_sstream.i
install -D -s -m 655 python/std_streambuf.i $RPM_BUILD_ROOT/%{prefix}/python/std_streambuf.i
install -D -s -m 655 python/std_string.i $RPM_BUILD_ROOT/%{prefix}/python/std_string.i
install -D -s -m 655 python/std_vectora.i $RPM_BUILD_ROOT/%{prefix}/python/std_vectora.i
install -D -s -m 655 python/std_vector.i $RPM_BUILD_ROOT/%{prefix}/python/std_vector.i
install -D -s -m 655 python/std_wios.i $RPM_BUILD_ROOT/%{prefix}/python/std_wios.i
install -D -s -m 655 python/std_wiostream.i $RPM_BUILD_ROOT/%{prefix}/python/std_wiostream.i
install -D -s -m 655 python/std_wsstream.i $RPM_BUILD_ROOT/%{prefix}/python/std_wsstream.i
install -D -s -m 655 python/std_wstreambuf.i $RPM_BUILD_ROOT/%{prefix}/python/std_wstreambuf.i
install -D -s -m 655 python/std_wstring.i $RPM_BUILD_ROOT/%{prefix}/python/std_wstring.i
install -D -s -m 655 python/stl.i $RPM_BUILD_ROOT/%{prefix}/python/stl.i
install -D -s -m 655 python/typemaps.i $RPM_BUILD_ROOT/%{prefix}/python/typemaps.i
install -D -s -m 655 python/wchar.i $RPM_BUILD_ROOT/%{prefix}/python/wchar.i
install -D -s -m 655 ruby/argcargv.i $RPM_BUILD_ROOT/%{prefix}/ruby/argcargv.i
install -D -s -m 655 ruby/attribute.i $RPM_BUILD_ROOT/%{prefix}/ruby/attribute.i
install -D -s -m 655 ruby/carrays.i $RPM_BUILD_ROOT/%{prefix}/ruby/carrays.i
install -D -s -m 655 ruby/cdata.i $RPM_BUILD_ROOT/%{prefix}/ruby/cdata.i
install -D -s -m 655 ruby/cmalloc.i $RPM_BUILD_ROOT/%{prefix}/ruby/cmalloc.i
install -D -s -m 655 ruby/cni.i $RPM_BUILD_ROOT/%{prefix}/ruby/cni.i
install -D -s -m 655 ruby/cpointer.i $RPM_BUILD_ROOT/%{prefix}/ruby/cpointer.i
install -D -s -m 655 ruby/cstring.i $RPM_BUILD_ROOT/%{prefix}/ruby/cstring.i
install -D -s -m 655 ruby/director.swg $RPM_BUILD_ROOT/%{prefix}/ruby/director.swg
install -D -s -m 655 ruby/embed.i $RPM_BUILD_ROOT/%{prefix}/ruby/embed.i
install -D -s -m 655 ruby/exception.i $RPM_BUILD_ROOT/%{prefix}/ruby/exception.i
install -D -s -m 655 ruby/extconf.rb $RPM_BUILD_ROOT/%{prefix}/ruby/extconf.rb
install -D -s -m 655 ruby/factory.i $RPM_BUILD_ROOT/%{prefix}/ruby/factory.i
install -D -s -m 655 ruby/file.i $RPM_BUILD_ROOT/%{prefix}/ruby/file.i
install -D -s -m 655 ruby/jstring.i $RPM_BUILD_ROOT/%{prefix}/ruby/jstring.i
install -D -s -m 655 ruby/Makefile.swig $RPM_BUILD_ROOT/%{prefix}/ruby/Makefile.swig
install -D -s -m 655 ruby/progargcargv.i $RPM_BUILD_ROOT/%{prefix}/ruby/progargcargv.i
install -D -s -m 655 ruby/rubyapi.swg $RPM_BUILD_ROOT/%{prefix}/ruby/rubyapi.swg
install -D -s -m 655 ruby/rubydef.swg $RPM_BUILD_ROOT/%{prefix}/ruby/rubydef.swg
install -D -s -m 655 ruby/rubyerrors.swg $RPM_BUILD_ROOT/%{prefix}/ruby/rubyerrors.swg
install -D -s -m 655 ruby/rubyfragments.swg $RPM_BUILD_ROOT/%{prefix}/ruby/rubyfragments.swg
install -D -s -m 655 ruby/rubyhead.swg $RPM_BUILD_ROOT/%{prefix}/ruby/rubyhead.swg
install -D -s -m 655 ruby/rubyinit.swg $RPM_BUILD_ROOT/%{prefix}/ruby/rubyinit.swg
install -D -s -m 655 ruby/rubykw.swg $RPM_BUILD_ROOT/%{prefix}/ruby/rubykw.swg
install -D -s -m 655 ruby/rubymacros.swg $RPM_BUILD_ROOT/%{prefix}/ruby/rubymacros.swg
install -D -s -m 655 ruby/rubyopers.swg $RPM_BUILD_ROOT/%{prefix}/ruby/rubyopers.swg
install -D -s -m 655 ruby/rubyprimtypes.swg $RPM_BUILD_ROOT/%{prefix}/ruby/rubyprimtypes.swg
install -D -s -m 655 ruby/rubyrun.swg $RPM_BUILD_ROOT/%{prefix}/ruby/rubyrun.swg
install -D -s -m 655 ruby/rubyruntime.swg $RPM_BUILD_ROOT/%{prefix}/ruby/rubyruntime.swg
install -D -s -m 655 ruby/rubystrings.swg $RPM_BUILD_ROOT/%{prefix}/ruby/rubystrings.swg
install -D -s -m 655 ruby/ruby.swg $RPM_BUILD_ROOT/%{prefix}/ruby/ruby.swg
install -D -s -m 655 ruby/rubytracking.swg $RPM_BUILD_ROOT/%{prefix}/ruby/rubytracking.swg
install -D -s -m 655 ruby/rubytypemaps.swg $RPM_BUILD_ROOT/%{prefix}/ruby/rubytypemaps.swg
install -D -s -m 655 ruby/rubyuserdir.swg $RPM_BUILD_ROOT/%{prefix}/ruby/rubyuserdir.swg
install -D -s -m 655 ruby/std_common.i $RPM_BUILD_ROOT/%{prefix}/ruby/std_common.i
install -D -s -m 655 ruby/std_deque.i $RPM_BUILD_ROOT/%{prefix}/ruby/std_deque.i
install -D -s -m 655 ruby/std_except.i $RPM_BUILD_ROOT/%{prefix}/ruby/std_except.i
install -D -s -m 655 ruby/std_map.i $RPM_BUILD_ROOT/%{prefix}/ruby/std_map.i
install -D -s -m 655 ruby/std_pair.i $RPM_BUILD_ROOT/%{prefix}/ruby/std_pair.i
install -D -s -m 655 ruby/std_string.i $RPM_BUILD_ROOT/%{prefix}/ruby/std_string.i
install -D -s -m 655 ruby/std_vector.i $RPM_BUILD_ROOT/%{prefix}/ruby/std_vector.i
install -D -s -m 655 ruby/stl.i $RPM_BUILD_ROOT/%{prefix}/ruby/stl.i
install -D -s -m 655 ruby/timeval.i $RPM_BUILD_ROOT/%{prefix}/ruby/timeval.i
install -D -s -m 655 ruby/typemaps.i $RPM_BUILD_ROOT/%{prefix}/ruby/typemaps.i
install -D -s -m 655 std/std_alloc.i $RPM_BUILD_ROOT/%{prefix}/std/std_alloc.i
install -D -s -m 655 std/std_basic_string.i $RPM_BUILD_ROOT/%{prefix}/std/std_basic_string.i
install -D -s -m 655 std/std_carray.swg $RPM_BUILD_ROOT/%{prefix}/std/std_carray.swg
install -D -s -m 655 std/std_char_traits.i $RPM_BUILD_ROOT/%{prefix}/std/std_char_traits.i
install -D -s -m 655 std/std_common.i $RPM_BUILD_ROOT/%{prefix}/std/std_common.i
install -D -s -m 655 std/std_container.i $RPM_BUILD_ROOT/%{prefix}/std/std_container.i
install -D -s -m 655 std/_std_deque.i $RPM_BUILD_ROOT/%{prefix}/std/_std_deque.i
install -D -s -m 655 std/std_deque.i $RPM_BUILD_ROOT/%{prefix}/std/std_deque.i
install -D -s -m 655 std/std_except.i $RPM_BUILD_ROOT/%{prefix}/std/std_except.i
install -D -s -m 655 std/std_ios.i $RPM_BUILD_ROOT/%{prefix}/std/std_ios.i
install -D -s -m 655 std/std_iostream.i $RPM_BUILD_ROOT/%{prefix}/std/std_iostream.i
install -D -s -m 655 std/std_list.i $RPM_BUILD_ROOT/%{prefix}/std/std_list.i
install -D -s -m 655 std/std_map.i $RPM_BUILD_ROOT/%{prefix}/std/std_map.i
install -D -s -m 655 std/std_multimap.i $RPM_BUILD_ROOT/%{prefix}/std/std_multimap.i
install -D -s -m 655 std/std_multiset.i $RPM_BUILD_ROOT/%{prefix}/std/std_multiset.i
install -D -s -m 655 std/std_pair.i $RPM_BUILD_ROOT/%{prefix}/std/std_pair.i
install -D -s -m 655 std/std_set.i $RPM_BUILD_ROOT/%{prefix}/std/std_set.i
install -D -s -m 655 std/std_sstream.i $RPM_BUILD_ROOT/%{prefix}/std/std_sstream.i
install -D -s -m 655 std/std_streambuf.i $RPM_BUILD_ROOT/%{prefix}/std/std_streambuf.i
install -D -s -m 655 std/std_string.i $RPM_BUILD_ROOT/%{prefix}/std/std_string.i
install -D -s -m 655 std/std_vectora.i $RPM_BUILD_ROOT/%{prefix}/std/std_vectora.i
install -D -s -m 655 std/std_vector.i $RPM_BUILD_ROOT/%{prefix}/std/std_vector.i
install -D -s -m 655 std/std_wios.i $RPM_BUILD_ROOT/%{prefix}/std/std_wios.i
install -D -s -m 655 std/std_wiostream.i $RPM_BUILD_ROOT/%{prefix}/std/std_wiostream.i
install -D -s -m 655 std/std_wsstream.i $RPM_BUILD_ROOT/%{prefix}/std/std_wsstream.i
install -D -s -m 655 std/std_wstreambuf.i $RPM_BUILD_ROOT/%{prefix}/std/std_wstreambuf.i
install -D -s -m 655 std/std_wstring.i $RPM_BUILD_ROOT/%{prefix}/std/std_wstring.i
install -D -s -m 655 tcl/attribute.i $RPM_BUILD_ROOT/%{prefix}/tcl/attribute.i
install -D -s -m 655 tcl/carrays.i $RPM_BUILD_ROOT/%{prefix}/tcl/carrays.i
install -D -s -m 655 tcl/cdata.i $RPM_BUILD_ROOT/%{prefix}/tcl/cdata.i
install -D -s -m 655 tcl/cmalloc.i $RPM_BUILD_ROOT/%{prefix}/tcl/cmalloc.i
install -D -s -m 655 tcl/cni.i $RPM_BUILD_ROOT/%{prefix}/tcl/cni.i
install -D -s -m 655 tcl/cpointer.i $RPM_BUILD_ROOT/%{prefix}/tcl/cpointer.i
install -D -s -m 655 tcl/cstring.i $RPM_BUILD_ROOT/%{prefix}/tcl/cstring.i
install -D -s -m 655 tcl/cwstring.i $RPM_BUILD_ROOT/%{prefix}/tcl/cwstring.i
install -D -s -m 655 tcl/exception.i $RPM_BUILD_ROOT/%{prefix}/tcl/exception.i
install -D -s -m 655 tcl/factory.i $RPM_BUILD_ROOT/%{prefix}/tcl/factory.i
install -D -s -m 655 tcl/jstring.i $RPM_BUILD_ROOT/%{prefix}/tcl/jstring.i
install -D -s -m 655 tcl/std_common.i $RPM_BUILD_ROOT/%{prefix}/tcl/std_common.i
install -D -s -m 655 tcl/std_deque.i $RPM_BUILD_ROOT/%{prefix}/tcl/std_deque.i
install -D -s -m 655 tcl/std_except.i $RPM_BUILD_ROOT/%{prefix}/tcl/std_except.i
install -D -s -m 655 tcl/std_map.i $RPM_BUILD_ROOT/%{prefix}/tcl/std_map.i
install -D -s -m 655 tcl/std_pair.i $RPM_BUILD_ROOT/%{prefix}/tcl/std_pair.i
install -D -s -m 655 tcl/std_string.i $RPM_BUILD_ROOT/%{prefix}/tcl/std_string.i
install -D -s -m 655 tcl/std_vector.i $RPM_BUILD_ROOT/%{prefix}/tcl/std_vector.i
install -D -s -m 655 tcl/std_wstring.i $RPM_BUILD_ROOT/%{prefix}/tcl/std_wstring.i
install -D -s -m 655 tcl/stl.i $RPM_BUILD_ROOT/%{prefix}/tcl/stl.i
install -D -s -m 655 tcl/tcl8.swg $RPM_BUILD_ROOT/%{prefix}/tcl/tcl8.swg
install -D -s -m 655 tcl/tclapi.swg $RPM_BUILD_ROOT/%{prefix}/tcl/tclapi.swg
install -D -s -m 655 tcl/tclerrors.swg $RPM_BUILD_ROOT/%{prefix}/tcl/tclerrors.swg
install -D -s -m 655 tcl/tclfragments.swg $RPM_BUILD_ROOT/%{prefix}/tcl/tclfragments.swg
install -D -s -m 655 tcl/tclinit.swg $RPM_BUILD_ROOT/%{prefix}/tcl/tclinit.swg
install -D -s -m 655 tcl/tclinterp.i $RPM_BUILD_ROOT/%{prefix}/tcl/tclinterp.i
install -D -s -m 655 tcl/tclkw.swg $RPM_BUILD_ROOT/%{prefix}/tcl/tclkw.swg
install -D -s -m 655 tcl/tclmacros.swg $RPM_BUILD_ROOT/%{prefix}/tcl/tclmacros.swg
install -D -s -m 655 tcl/tclopers.swg $RPM_BUILD_ROOT/%{prefix}/tcl/tclopers.swg
install -D -s -m 655 tcl/tclprimtypes.swg $RPM_BUILD_ROOT/%{prefix}/tcl/tclprimtypes.swg
install -D -s -m 655 tcl/tclresult.i $RPM_BUILD_ROOT/%{prefix}/tcl/tclresult.i
install -D -s -m 655 tcl/tclrun.swg $RPM_BUILD_ROOT/%{prefix}/tcl/tclrun.swg
install -D -s -m 655 tcl/tclruntime.swg $RPM_BUILD_ROOT/%{prefix}/tcl/tclruntime.swg
install -D -s -m 655 tcl/tclsh.i $RPM_BUILD_ROOT/%{prefix}/tcl/tclsh.i
install -D -s -m 655 tcl/tclstrings.swg $RPM_BUILD_ROOT/%{prefix}/tcl/tclstrings.swg
install -D -s -m 655 tcl/tcltypemaps.swg $RPM_BUILD_ROOT/%{prefix}/tcl/tcltypemaps.swg
install -D -s -m 655 tcl/tcluserdir.swg $RPM_BUILD_ROOT/%{prefix}/tcl/tcluserdir.swg
install -D -s -m 655 tcl/tclwstrings.swg $RPM_BUILD_ROOT/%{prefix}/tcl/tclwstrings.swg
install -D -s -m 655 tcl/typemaps.i $RPM_BUILD_ROOT/%{prefix}/tcl/typemaps.i
install -D -s -m 655 tcl/wish.i $RPM_BUILD_ROOT/%{prefix}/tcl/wish.i
install -D -s -m 655 typemaps/attribute.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/attribute.swg
install -D -s -m 655 typemaps/carrays.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/carrays.swg
install -D -s -m 655 typemaps/cdata.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/cdata.swg
install -D -s -m 655 typemaps/cmalloc.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/cmalloc.swg
install -D -s -m 655 typemaps/cpointer.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/cpointer.swg
install -D -s -m 655 typemaps/cstrings.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/cstrings.swg
install -D -s -m 655 typemaps/cstring.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/cstring.swg
install -D -s -m 655 typemaps/cwstring.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/cwstring.swg
install -D -s -m 655 typemaps/enumint.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/enumint.swg
install -D -s -m 655 typemaps/exception.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/exception.swg
install -D -s -m 655 typemaps/factory.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/factory.swg
install -D -s -m 655 typemaps/fragments.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/fragments.swg
install -D -s -m 655 typemaps/implicit.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/implicit.swg
install -D -s -m 655 typemaps/inoutlist.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/inoutlist.swg
install -D -s -m 655 typemaps/misctypes.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/misctypes.swg
install -D -s -m 655 typemaps/primtypes.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/primtypes.swg
install -D -s -m 655 typemaps/ptrtypes.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/ptrtypes.swg
install -D -s -m 655 typemaps/std_except.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/std_except.swg
install -D -s -m 655 typemaps/std_strings.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/std_strings.swg
install -D -s -m 655 typemaps/std_string.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/std_string.swg
install -D -s -m 655 typemaps/std_wstring.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/std_wstring.swg
install -D -s -m 655 typemaps/strings.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/strings.swg
install -D -s -m 655 typemaps/string.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/string.swg
install -D -s -m 655 typemaps/swigmacros.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/swigmacros.swg
install -D -s -m 655 typemaps/swigobject.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/swigobject.swg
install -D -s -m 655 typemaps/swigtypemaps.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/swigtypemaps.swg
install -D -s -m 655 typemaps/swigtype.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/swigtype.swg
install -D -s -m 655 typemaps/traits.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/traits.swg
install -D -s -m 655 typemaps/typemaps.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/typemaps.swg
install -D -s -m 655 typemaps/valtypes.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/valtypes.swg
install -D -s -m 655 typemaps/void.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/void.swg
install -D -s -m 655 typemaps/wstring.swg $RPM_BUILD_ROOT/%{prefix}/typemaps/wstring.swg
install -D -s -m 655 uffi/uffi.swg $RPM_BUILD_ROOT/%{prefix}/uffi/uffi.swg

cd /%{_prefix}/local/bin
install -D -s -m 755 swig $RPM_BUILD_ROOT/%{_prefix}/local/bin/swig

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
%{_prefix}/local/bin/*

%changelog

* Sat Aug 05 2006 José Eduardo Martins <jemartins@fis.unb.br>
- First spec for swip package


