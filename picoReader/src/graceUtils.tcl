#########################################################################
## graceUtils.tcl

#########################################################################
#
#    Copyright (C) 2006 DrDAQ Application Project.
#
#   This software is in the public domain.
#    Permission to use, copy, modify, and distribute this software and its
#    documentation for any purpose and without fee is hereby granted,
#    without any conditions or restrictions.
#    This software is provided "as is" without express or implied warranty.
#
#    If you discover a bug or add an enhancement here's how to reach us:
#
#        https://sourceforge.net/projects/drdaq
#
##########################################################################

##########################################################################
# Revision history:
# Revisions:
# $Log: graceUtils.tcl,v $
# Revision 1.14  2010/03/15 14:34:24  jemartins
# added elseif sensor1
#
# Revision 1.13  2010/02/23 01:26:55  jemartins
# changes for XY mode
#
# Revision 1.12  2010/02/11 17:28:59  jemartins
# added XY feature
#
# Revision 1.11  2006/09/26 13:01:04  jemartins
# added ymin var
#
# Revision 1.10  2006/09/11 13:51:52  jemartins
# added home var
#
# Revision 1.9  2006/07/23 23:35:31  jemartins
# cleanup
#
# Revision 1.8  2006/07/06 11:38:53  jemartins
# makeup
#
# Revision 1.7  2006/06/15 23:09:29  jemartins
# added nsensors_kill
#
# Revision 1.6  2006/05/29 18:10:20  jemartins
# changes in InitGrace
#
# Revision 1.5  2006/05/29 17:54:53  jemartins
# changes in InitGrace
#
# Revision 1.4  2006/05/26 19:41:55  jemartins
# initial
#
# Revision 1.3  2006/05/26 13:43:00  jemartins
# housekeeping
#
# Revision 1.2  2006/05/15 18:02:12  jemartins
# added Copyright
#
# Revision 1.1  2006/05/02 16:01:17  jemartins
# startup
#
##########################################################################

#############################################################################
## Procedure:  Legendas

proc Legendas {} {
global Sensor1
global Sensor2
global Modo1
global Modo2
global Passo
global XY


GracePrintf "title \"Dados Adquiridos Via DrDAQ\""

if {($Sensor1 == 1) && ($Sensor2 == 1) && ($XY == 0)} {
    GracePrintf "subtitle \"$Modo1 x $Passo & $Modo2 x $Passo\""
} elseif {($Sensor1 == 1) && ($XY == 0)} {
    GracePrintf "subtitle \"$Modo1 x $Passo\""
} elseif {($Sensor2 == 1) && ($XY == 0)} {
    GracePrintf "subtitle \"$Modo2 x $Passo\""
}
if {($Sensor1 == 1) && ($Sensor2 == 1) && ($XY == 1)} {
	    GracePrintf "subtitle \"$Modo1 x $Modo2\""
    }
}

#############################################################################
## Procedure:  KillSet

proc KillSet {nsensors_prev} {
global nsensors nsensors_kill graf home

if {[GraceIsOpen]} {
	
	if {($graf > 99)} {
		set graf 0
	}
		
	if {($nsensors_prev == 1)} {
		GracePrintf "write g0.s0 file \"$home\/tmp\/tabela$graf.dat\""
		GracePrintf "kill g0.s0"
		GracePrintf "redraw"
		set graf [expr {$graf + 1}]
	} else {
		GracePrintf "write g0.s0 file \"$home\/tmp\/tabela$graf.dat\""
		GracePrintf "kill g0.s0"
		GracePrintf "redraw"
		set graf [expr {$graf + 1}]
		GracePrintf "write g0.s1 file \"$home\/tmp\/tabela$graf.dat\""
		GracePrintf "kill g0.s1"
		GracePrintf "redraw"
		set graf [expr {$graf + 1}]
	}
	
	SetSimbolo $nsensors
	set nsensors_kill $nsensors
}

}

#############################################################################
## Procedure:  SalvarArquivo

proc SalvarArquivo {s} {
global nsensors

set nomearq [tk_getSaveFile -initialfile g0s$s -defaultextension .dat  -title "Salvar Dados Como"]
            
if {($nsensors == 2) || ($s == 1)} { 
    GracePrintf "write g0.s$s file $nomearq"
}
}

#############################################################################
## Procedure:  InitGrace

proc InitGrace { } {

global Passo AutoEscala nsensors Sensor1 Sensor2 Modo1 Modo2
global xmax ymax ymin maior_divx menor_divx maior_divy menor_divy
global XY

# Opening and Init Grace
if {!([GraceIsOpen])} {

	# Opening Grace
	OpenGrace
	
	# Legends
	Legendas
	
	# defining simbols for graph
	#SetSimbolo $nsensors 
	
	# Init scale
	if {($AutoEscala == 0)} {
		SetEscala $xmax $ymax $ymin $maior_divx $menor_divx \
		$maior_divy $menor_divy
	}

};# end if GraceIsOpen

};# end InitGrace
