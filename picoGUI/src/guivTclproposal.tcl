#!/bin/sh
# the next line restarts using wish\
exec wish "$0" "$@" 

if {![info exists vTcl(sourcing)]} {

    package require Tk
    switch $tcl_platform(platform) {
	windows {
            option add *Button.padY 0
	}
	default {
            option add *Scrollbar.width 10
            option add *Scrollbar.highlightThickness 0
            option add *Scrollbar.elementBorderWidth 2
            option add *Scrollbar.borderWidth 2
	}
    }
    
}

#############################################################################
# Visual Tcl v1.60 Project
#


#################################
# VTCL LIBRARY PROCEDURES
#

if {![info exists vTcl(sourcing)]} {
#############################################################################
## Library Procedure:  Window

proc ::Window {args} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    global vTcl
    foreach {cmd name newname} [lrange $args 0 2] {}
    set rest    [lrange $args 3 end]
    if {$name == "" || $cmd == ""} { return }
    if {$newname == ""} { set newname $name }
    if {$name == "."} { wm withdraw $name; return }
    set exists [winfo exists $newname]
    switch $cmd {
        show {
            if {$exists} {
                wm deiconify $newname
            } elseif {[info procs vTclWindow$name] != ""} {
                eval "vTclWindow$name $newname $rest"
            }
            if {[winfo exists $newname] && [wm state $newname] == "normal"} {
                vTcl:FireEvent $newname <<Show>>
            }
        }
        hide    {
            if {$exists} {
                wm withdraw $newname
                vTcl:FireEvent $newname <<Hide>>
                return}
        }
        iconify { if $exists {wm iconify $newname; return} }
        destroy { if $exists {destroy $newname; return} }
    }
}
#############################################################################
## Library Procedure:  vTcl:DefineAlias

proc ::vTcl:DefineAlias {target alias widgetProc top_or_alias cmdalias} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    global widget
    set widget($alias) $target
    set widget(rev,$target) $alias
    if {$cmdalias} {
        interp alias {} $alias {} $widgetProc $target
    }
    if {$top_or_alias != ""} {
        set widget($top_or_alias,$alias) $target
        if {$cmdalias} {
            interp alias {} $top_or_alias.$alias {} $widgetProc $target
        }
    }
}
#############################################################################
## Library Procedure:  vTcl:DoCmdOption

proc ::vTcl:DoCmdOption {target cmd} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    ## menus are considered toplevel windows
    set parent $target
    while {[winfo class $parent] == "Menu"} {
        set parent [winfo parent $parent]
    }

    regsub -all {\%widget} $cmd $target cmd
    regsub -all {\%top} $cmd [winfo toplevel $parent] cmd

    uplevel #0 [list eval $cmd]
}
#############################################################################
## Library Procedure:  vTcl:FireEvent

proc ::vTcl:FireEvent {target event {params {}}} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    ## The window may have disappeared
    if {![winfo exists $target]} return
    ## Process each binding tag, looking for the event
    foreach bindtag [bindtags $target] {
        set tag_events [bind $bindtag]
        set stop_processing 0
        foreach tag_event $tag_events {
            if {$tag_event == $event} {
                set bind_code [bind $bindtag $tag_event]
                foreach rep "\{%W $target\} $params" {
                    regsub -all [lindex $rep 0] $bind_code [lindex $rep 1] bind_code
                }
                set result [catch {uplevel #0 $bind_code} errortext]
                if {$result == 3} {
                    ## break exception, stop processing
                    set stop_processing 1
                } elseif {$result != 0} {
                    bgerror $errortext
                }
                break
            }
        }
        if {$stop_processing} {break}
    }
}
#############################################################################
## Library Procedure:  vTcl:Toplevel:WidgetProc

proc ::vTcl:Toplevel:WidgetProc {w args} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    if {[llength $args] == 0} {
        ## If no arguments, returns the path the alias points to
        return $w
    }
    set command [lindex $args 0]
    set args [lrange $args 1 end]
    switch -- [string tolower $command] {
        "setvar" {
            foreach {varname value} $args {}
            if {$value == ""} {
                return [set ::${w}::${varname}]
            } else {
                return [set ::${w}::${varname} $value]
            }
        }
        "hide" - "show" {
            Window [string tolower $command] $w
        }
        "showmodal" {
            ## modal dialog ends when window is destroyed
            Window show $w; raise $w
            grab $w; tkwait window $w; grab release $w
        }
        "startmodal" {
            ## ends when endmodal called
            Window show $w; raise $w
            set ::${w}::_modal 1
            grab $w; tkwait variable ::${w}::_modal; grab release $w
        }
        "endmodal" {
            ## ends modal dialog started with startmodal, argument is var name
            set ::${w}::_modal 0
            Window hide $w
        }
        default {
            uplevel $w $command $args
        }
    }
}
#############################################################################
## Library Procedure:  vTcl:WidgetProc

proc ::vTcl:WidgetProc {w args} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    if {[llength $args] == 0} {
        ## If no arguments, returns the path the alias points to
        return $w
    }

    set command [lindex $args 0]
    set args [lrange $args 1 end]
    uplevel $w $command $args
}
#############################################################################
## Library Procedure:  vTcl:toplevel

proc ::vTcl:toplevel {args} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    uplevel #0 eval toplevel $args
    set target [lindex $args 0]
    namespace eval ::$target {set _modal 0}
}
}


if {[info exists vTcl(sourcing)]} {

proc vTcl:project:info {} {
    set base .drdaqgrace
    namespace eval ::widgets::$base {
        set set,origin 1
        set set,size 1
        set runvisible 1
    }
    namespace eval ::widgets::$base.fra62 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    set site_3_0 $base.fra62
    namespace eval ::widgets::$site_3_0.cpd73 {
        array set save {-command 1 -state 1 -text 1 -value 1 -variable 1}
    }
    namespace eval ::widgets::$site_3_0.cpd74 {
        array set save {-command 1 -state 1 -text 1 -value 1 -variable 1}
    }
    namespace eval ::widgets::$site_3_0.cpd75 {
        array set save {-command 1 -state 1 -text 1 -value 1 -variable 1}
    }
    namespace eval ::widgets::$site_3_0.lab78 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$site_3_0.cpd79 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$site_3_0.spi63 {
        array set save {-activebackground 1 -background 1 -command 1 -foreground 1 -from 1 -highlightcolor 1 -increment 1 -insertbackground 1 -justify 1 -selectbackground 1 -selectforeground 1 -state 1 -textvariable 1 -to 1 -values 1}
    }
    namespace eval ::widgets::$site_3_0.cpd55 {
        array set save {-activeforeground 1 -background 1 -foreground 1 -text 1}
    }
    namespace eval ::widgets::$site_3_0.cpd57 {
        array set save {-activebackground 1 -background 1 -justify 1 -relief 1 -text 1}
    }
    namespace eval ::widgets::$site_3_0.fra59 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    set site_4_0 $site_3_0.fra59
    namespace eval ::widgets::$site_4_0.cpd60 {
        array set save {-activeforeground 1 -foreground 1 -text 1}
    }
    namespace eval ::widgets::$site_4_0.cpd61 {
        array set save {-anchor 1 -command 1 -state 1 -text 1 -value 1 -variable 1}
    }
    namespace eval ::widgets::$site_4_0.cpd62 {
        array set save {-anchor 1 -command 1 -state 1 -text 1 -value 1 -variable 1}
    }
    namespace eval ::widgets::$site_4_0.cpd63 {
        array set save {-anchor 1 -command 1 -state 1 -text 1 -value 1 -variable 1}
    }
    namespace eval ::widgets::$site_3_0.fra64 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    set site_4_0 $site_3_0.fra64
    namespace eval ::widgets::$site_4_0.cpd65 {
        array set save {-activeforeground 1 -foreground 1 -highlightcolor 1 -text 1}
    }
    namespace eval ::widgets::$site_4_0.cpd66 {
        array set save {-activebackground 1 -background 1 -command 1 -font 1 -foreground 1 -from 1 -highlightcolor 1 -increment 1 -insertbackground 1 -justify 1 -selectbackground 1 -selectforeground 1 -state 1 -textvariable 1 -to 1 -values 1}
    }
    namespace eval ::widgets::$site_3_0.but74 {
        array set save {-state 1 -text 1}
    }
    namespace eval ::widgets::$site_3_0.cpd58 {
        array set save {-anchor 1 -background 1 -highlightbackground 1 -variable 1}
    }
    namespace eval ::widgets::$base.but87 {
        array set save {-background 1 -command 1 -text 1}
    }
    namespace eval ::widgets::$base.fra88 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    set site_3_0 $base.fra88
    namespace eval ::widgets::$site_3_0.ent90 {
        array set save {-background 1 -insertbackground 1 -justify 1 -state 1 -textvariable 1 -validate 1 -validatecommand 1}
    }
    namespace eval ::widgets::$site_3_0.cpd92 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$site_3_0.cpd93 {
        array set save {-background 1 -insertbackground 1 -justify 1 -state 1 -textvariable 1 -validate 1 -validatecommand 1}
    }
    namespace eval ::widgets::$site_3_0.cpd94 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$site_3_0.cpd95 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$site_3_0.cpd96 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$site_3_0.cpd97 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$site_3_0.cpd98 {
        array set save {-background 1 -insertbackground 1 -justify 1 -state 1 -textvariable 1 -validate 1 -validatecommand 1}
    }
    namespace eval ::widgets::$site_3_0.cpd99 {
        array set save {-background 1 -insertbackground 1 -justify 1 -state 1 -textvariable 1 -validate 1 -validatecommand 1}
    }
    namespace eval ::widgets::$site_3_0.cpd100 {
        array set save {-background 1 -insertbackground 1 -justify 1 -state 1 -textvariable 1 -validate 1 -validatecommand 1}
    }
    namespace eval ::widgets::$site_3_0.cpd101 {
        array set save {-background 1 -insertbackground 1 -justify 1 -state 1 -textvariable 1 -validate 1 -validatecommand 1}
    }
    namespace eval ::widgets::$site_3_0.cpd60 {
        array set save {-background 1 -insertbackground 1 -justify 1 -state 1 -textvariable 1 -validate 1 -validatecommand 1}
    }
    namespace eval ::widgets::$site_3_0.cpd61 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$site_3_0.cpd47 {
        array set save {-anchor 1 -text 1}
    }
    namespace eval ::widgets::$site_3_0.cpd48 {
        array set save {-command 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::$site_3_0.cpd58 {
        array set save {-activeforeground 1 -background 1 -foreground 1 -text 1}
    }
    namespace eval ::widgets::$site_3_0.che60 {
        array set save {-anchor 1 -text 1 -variable 1}
    }
    namespace eval ::widgets::$site_3_0.fra62 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    set site_4_0 $site_3_0.fra62
    namespace eval ::widgets::$site_4_0.cpd63 {
        array set save {-background 1 -foreground 1 -text 1}
    }
    namespace eval ::widgets::$site_4_0.spi47 {
        array set save {-activebackground 1 -foreground 1 -from 1 -highlightcolor 1 -increment 1 -insertbackground 1 -selectbackground 1 -selectforeground 1 -to 1 -values 1}
    }
    namespace eval ::widgets::$site_4_0.cpd49 {
        array set save {-background 1 -insertbackground 1 -justify 1 -state 1 -textvariable 1 -validate 1 -validatecommand 1}
    }
    namespace eval ::widgets::$site_4_0.cpd50 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$site_4_0.cpd51 {
        array set save {-background 1 -insertbackground 1 -justify 1 -state 1 -textvariable 1 -validate 1 -validatecommand 1}
    }
    namespace eval ::widgets::$site_4_0.cpd52 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$site_3_0.lab91 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$site_3_0.cpd53 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    set site_4_0 $site_3_0.cpd53
    namespace eval ::widgets::$site_4_0.cpd63 {
        array set save {-background 1 -foreground 1 -text 1}
    }
    namespace eval ::widgets::$site_4_0.spi47 {
        array set save {-activebackground 1 -foreground 1 -from 1 -highlightcolor 1 -increment 1 -insertbackground 1 -selectbackground 1 -selectforeground 1 -values 1}
    }
    namespace eval ::widgets::$site_4_0.cpd49 {
        array set save {-background 1 -insertbackground 1 -justify 1 -state 1 -textvariable 1 -validate 1 -validatecommand 1}
    }
    namespace eval ::widgets::$site_4_0.cpd50 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$site_4_0.cpd51 {
        array set save {-background 1 -insertbackground 1 -justify 1 -state 1 -textvariable 1 -validate 1 -validatecommand 1}
    }
    namespace eval ::widgets::$site_4_0.cpd52 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$site_3_0.che54 {
        array set save {-text 1 -variable 1}
    }
    namespace eval ::widgets::$base.fra102 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    set site_3_0 $base.fra102
    namespace eval ::widgets::$site_3_0.cpd56 {
        array set save {-activeforeground 1 -background 1 -foreground 1 -text 1}
    }
    namespace eval ::widgets::$site_3_0.cpd49 {
        array set save {-background 1 -justify 1 -relief 1 -text 1}
    }
    namespace eval ::widgets::$site_3_0.fra50 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    set site_4_0 $site_3_0.fra50
    namespace eval ::widgets::$site_4_0.cpd51 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$site_4_0.cpd52 {
        array set save {-command 1 -text 1 -value 1 -variable 1}
    }
    namespace eval ::widgets::$site_4_0.cpd53 {
        array set save {-command 1 -text 1 -value 1 -variable 1}
    }
    namespace eval ::widgets::$site_4_0.cpd54 {
        array set save {-command 1 -text 1 -value 1 -variable 1}
    }
    namespace eval ::widgets::$site_3_0.cpd55 {
        array set save {-state 1 -text 1}
    }
    namespace eval ::widgets::$site_3_0.cpd59 {
        array set save {-anchor 1 -background 1 -highlightbackground 1 -variable 1}
    }
    namespace eval ::widgets::$site_3_0.fra49 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    set site_4_0 $site_3_0.fra49
    namespace eval ::widgets::$site_4_0.cpd50 {
        array set save {-activebackground 1 -background 1 -command 1 -font 1 -foreground 1 -from 1 -highlightcolor 1 -increment 1 -insertbackground 1 -justify 1 -selectbackground 1 -selectforeground 1 -state 1 -textvariable 1 -to 1 -values 1}
    }
    namespace eval ::widgets::$site_4_0.cpd51 {
        array set save {-activeforeground 1 -foreground 1 -highlightcolor 1 -text 1}
    }
    namespace eval ::widgets::$base.fra70 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    set site_3_0 $base.fra70
    namespace eval ::widgets::$site_3_0.ent76 {
        array set save {-background 1 -exportselection 1 -highlightthickness 1 -insertbackground 1 -invalidcommand 1 -justify 1 -textvariable 1 -validate 1 -validatecommand 1}
    }
    namespace eval ::widgets::$site_3_0.lab80 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$site_3_0.rad64 {
        array set save {-anchor 1 -command 1 -text 1 -value 1 -variable 1}
    }
    namespace eval ::widgets::$site_3_0.cpd66 {
        array set save {-background 1 -exportselection 1 -highlightthickness 1 -insertbackground 1 -invalidcommand 1 -justify 1 -textvariable 1 -validate 1 -validatecommand 1}
    }
    namespace eval ::widgets::$site_3_0.cpd67 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$site_3_0.cpd68 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$site_3_0.lab60 {
        array set save {-background 1 -justify 1 -relief 1 -text 1}
    }
    namespace eval ::widgets::$site_3_0.cpd60 {
        array set save {-background 1 -exportselection 1 -highlightthickness 1 -insertbackground 1 -invalidcommand 1 -justify 1 -textvariable 1 -validate 1 -validatecommand 1}
    }
    namespace eval ::widgets::$site_3_0.lab49 {
        array set save {-background 1 -foreground 1 -text 1}
    }
    namespace eval ::widgets::$site_3_0.rad50 {
        array set save {-anchor 1 -text 1 -value 1 -variable 1}
    }
    namespace eval ::widgets::$site_3_0.ent51 {
        array set save {-background 1 -insertbackground 1 -textvariable 1}
    }
    namespace eval ::widgets::$site_3_0.cpd52 {
        array set save {-anchor 1 -state 1 -text 1}
    }
    namespace eval ::widgets::$site_3_0.cpd53 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$site_3_0.cpd54 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$site_3_0.cpd55 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$base.m71 {
        array set save {-tearoff 1}
        namespace eval subOptions {
            array set save {-command 1 -compound 1 -label 1 -menu 1}
        }
    }
    namespace eval ::widgets::$base.cpd83 {
        array set save {-background 1 -command 1 -text 1}
    }
    namespace eval ::widgets::$base.cpd60 {
        array set save {-background 1 -command 1 -text 1}
    }
    namespace eval ::widgets_bindings {
        set tagslist {_TopLevel _vTclBalloon}
    }
    namespace eval ::vTcl::modules::main {
        set procs {
            init
            main
            QualSensor
            ValidarEntradas
            showMessageBox
            vTclWindow.
            vTclWindow.drdaqgrace
        }
        set compounds {
        }
        set projectType single
    }
}
}

#################################
# USER DEFINED PROCEDURES
#
#############################################################################
## Procedure:  main

proc ::main {argc argv} {

global widget
global AutoEscala

set AutoEscala 1

Parar configure -state disabled 
Iniciar configure -state normal

Entry_Xmax configure -state disabled
Entry_Max_divx configure -state disabled
Entry_Min_divx configure -state disabled
Entry_Ymax configure -state disabled
Entry_Max_divy configure -state disabled
Entry_Min_divy configure -state disabled

}
#############################################################################
## Procedure:  QualSensor

proc ::QualSensor {} {
global Sensor1 Sensor2 Modo1 Modo2 Conector1 Conector2
global widget nsensores set_value1 set_value2 nmodo1 nmodo2
global AutoEscala xmax ymax ymin maior_divx menor_divx maior_divy menor_divy

#	IOCTL_PICO_GET_VALUE
#	  accepts:
#       1 - Sound waveform
#		2 - Sound level
#		3 - Voltage
#		4 - Resistance
#		5 - pH
#		6 - Temperature
#		7 - Light
#		8 - External input 1
#		9 - External input 2
#		10 - resistance value for EXT1
#		11 - resistance value for EXT2
#

# Quantos Sensores?
# 
if {($Sensor1 == 1) && ($Sensor2 == 1)} {
    set nsensores 2
} else {
    set nsensores 1
}

# Identificando os Modos
# 
if {($Sensor1 == 1)} {
    if {($Modo1 == "Onda Sonora")} {
        set nmodo1 1
    } elseif {($Modo1 == "Nivel Sonoro")} {
        set nmodo1 2
    } elseif {($Modo1 == "Voltagem")} {
        set nmodo1 3
    } elseif {($Modo1 == "Resistencia")} {
        set nmodo1 4
    } elseif {($Modo1 == "pH")} {
        set nmodo1 5
    } elseif {($Modo1 == "Temperatura")} {
        set nmodo1 6
    } elseif {($Modo1 == "Luz")} {
        set nmodo1 7
    } elseif {($Modo1 == "Angulo")} {
        set nmodo1 8
    }

    # Identificando o value
    #     
    if {($Conector1 == "Interno")} {
        if {($Modo1 == "Onda Sonora")} {
            set set_value1 1
        } elseif {($Modo1 == "Nivel Sonoro")} {
            set set_value1 3
        } elseif {($Modo1 == "Voltagem")} {
            set set_value1 4
        } elseif {($Modo1 == "Resistencia")} {
            set set_value1 7
        } elseif {($Modo1 == "pH")} {
            set set_value1 2
        } elseif {($Modo1 == "Temperatura")} {
            set set_value1 11
        } elseif {($Modo1 == "Luz")} {
            set set_value1 6
        } elseif {($Modo1 == "Angulo")} {
            set set_value1 12 
       }
    } elseif {($Conector1 == "Ext1") && ($Modo1 != "Resistencia")} {
        set set_value1 5
    } elseif {($Conector1 == "Ext2") && ($Modo1 != "Resistencia")} {
        set set_value1 10
    } elseif {($Conector1 == "Ext1") && ($Modo1 == "Resistencia")} {
        set set_value1 8
    } elseif {($Conector1 == "Ext2") && ($Modo1 == "Resistencia")} {
        set set_value1 9
    }
} else {
	set nmodo1 0
	set set_value1 0
}

if {($Sensor2 == 1)} {
    if {($Modo2 == "Onda Sonora")} {
        set nmodo2 1
    } elseif {($Modo2 == "Nivel Sonoro")} {
        set nmodo2 2
    } elseif {($Modo2 == "Voltagem")} {
        set nmodo2 3
    } elseif {($Modo2 == "Resistencia")} {
        set nmodo2 4
    } elseif {($Modo2 == "pH")} {
        set nmodo2 5
    } elseif {($Modo2 == "Temperatura")} {
        set nmodo2 6
    } elseif {($Modo2 == "Luz")} {
        set nmodo2 7
    } elseif {($Modo2 == "Angulo")} {
        set nmodo1 8
    } 

    if {($Conector2 == "Interno")} {
        if {($Modo2 == "Onda Sonora")} {
            set set_value2 1
        } elseif {($Modo2 == "Nivel Sonoro")} {
            set set_value2 3
        } elseif {($Modo2 == "Voltagem")} {
            set set_value2 4
        } elseif {($Modo2 == "Resistencia")} {
            set set_value2 7
        } elseif {($Modo2 == "pH")} {
            set set_value2 2
        } elseif {($Modo2 == "Temperatura")} {
            set set_value2 11
        } elseif {($Modo2 == "Luz")} {
            set set_value2 6
        } elseif {($Modo2 == "Angulo")} {
            set set_value1 12 
        } 
    } elseif {($Conector2 == "Ext1") && ($Modo2 != "Resistencia")} {
        set set_value2 5
    } elseif {($Conector2 == "Ext2") && ($Modo2 != "Resistencia")} {
        set set_value2 10
    } elseif {($Conector2 == "Ext1") && ($Modo2 == "Resistencia")} {
        set set_value2 8
    } elseif {($Conector2 == "Ext2") && ($Modo2 == "Resistencia")} {
        set set_value2 9
    }
} else {
	set nmodo2 0
	set set_value2 0
}

if { $AutoEscala == 1 } {
    set xmax 10 
    set ymax 10
    set ymin 0
    set maior_divx 10
    set menor_divx 1
    set maior_divy 10
    set menor_divy 1
}


}
#############################################################################
## Procedure:  ValidarEntradas

proc ::ValidarEntradas {} {
global widget Entradas Sensor1 Sensor2 Conector1 Conector2 Passo AutoEscala
global Delta_T TMax ncont xmax ymax ymin maior_divx maior_divy menor_divx menor_divy
global Calibrar1 Calibrar2 Rate Eixox Eixoy

set w .drdaqgrace

if {($Sensor1 == 0) && ($Sensor2 == 0)} {
    showMessageBox $w "pelo menos um Sensor"
} elseif {(($Conector1 == "") && ($Sensor1 == 1)) || (($Conector2 == "") && ($Sensor2 == 1))} {
    showMessageBox $w "um Conector"
} elseif {$Passo == ""} {
    showMessageBox $w "Intervalo ou Leituras/seg"
} elseif {($Passo == "Tempo") && (($Delta_T == "") || ($TMax == "") || ($Delta_T < 0) ||  ($TMax < 0) || ($Delta_T > $TMax))} {
    if {($Delta_T == "")} {
        showMessageBox $w "Intervalo de Tempo"
    } elseif {$TMax == ""} {
        showMessageBox $w "o Valor Max do Tempo"
    } elseif {$Delta_T < 0} {
        showMessageBox $w "Valores positivos para Intervalo"

    } elseif {$TMax < 0} {
        showMessageBox $w "Valores positivos para Tempo Max"
    } elseif {($Delta_T > $TMax)} {
        showMessageBox $w "Tempo Max maior que Intervalo"
    }
} elseif {($Passo == "Leituras")} {
    if {($ncont <= 0) || ($ncont == "")} {
        showMessageBox $w "Leituras maior que 0"
    } elseif {($Delta_T == "")} {
        showMessageBox $w "Intervalo de Tempo"
    } elseif {($Delta_T <= 0)} {
        showMessageBox $w "Valores do Tempo maior que 0"
    }
} elseif {($AutoEscala == 0) && (($xmax == "") || ($ymax == "") || ($ymin == "") ||  ($maior_divx == "") ||  ($maior_divy == "") || ($menor_divx == "") ||  ($menor_divy == ""))} {
    showMessageBox $w "Auto Escala ou TODOS os Valores de x max, y max, maior div x,   maior div y,  menor div x, menor div y"
}
}
#############################################################################
## Procedure:  showMessageBox

proc ::showMessageBox {w erro} {
global widget Entradas

set Entradas 0

tk_messageBox -icon info -message "Você precisa selecionar \"$erro\"" -type ok -parent $w
}

#############################################################################
## Initialization Procedure:  init

proc ::init {argc argv} {

#include globalVars.tcl
#include bottomPart.tcl
	
}

init $argc $argv

#################################
# VTCL GENERATED GUI PROCEDURES
#

proc vTclWindow. {base} {
    if {$base == ""} {
        set base .
    }
    ###################
    # CREATING WIDGETS
    ###################
    wm focusmodel $top passive
    wm geometry $top 1x1+0+0; update
    wm maxsize $top 1265 994
    wm minsize $top 1 1
    wm overrideredirect $top 0
    wm resizable $top 1 1
    wm withdraw $top
    wm title $top "vtcl.tcl"
    bindtags $top "$top Vtcl.tcl all"
    vTcl:FireEvent $top <<Create>>
    wm protocol $top WM_DELETE_WINDOW "vTcl:FireEvent $top <<DeleteWindow>>"

    ###################
    # SETTING GEOMETRY
    ###################

    vTcl:FireEvent $base <<Ready>>
}

proc vTclWindow.drdaqgrace {base} {
    if {$base == ""} {
        set base .drdaqgrace
    }
    if {[winfo exists $base]} {
        wm deiconify $base; return
    }
    set top $base
    ###################
    # CREATING WIDGETS
    ###################
    vTcl:toplevel $top -class Toplevel \
        -menu "$top.m71" -background #e6e7e6 -highlightbackground #e6e7e6 \
        -highlightcolor black 
    wm focusmodel $top passive
    wm geometry $top 462x577+241+124; update
    wm maxsize $top 1009 738
    wm minsize $top 1 1
    wm overrideredirect $top 0
    wm resizable $top 1 1
    wm deiconify $top
    wm title $top "DrDAQ"
    vTcl:DefineAlias "$top" "DrDaq" vTcl:Toplevel:WidgetProc "" 1
    bindtags $top "$top Toplevel all _TopLevel"
    vTcl:FireEvent $top <<Create>>
    wm protocol $top WM_DELETE_WINDOW "vTcl:FireEvent $top <<DeleteWindow>>"

    frame $top.fra62 \
        -borderwidth 2 -relief groove -height 205 -width 195 
    vTcl:DefineAlias "$top.fra62" "Frame_Canal1" vTcl:WidgetProc "DrDaq" 1
    set site_3_0 $top.fra62
    radiobutton $site_3_0.cpd73 \
        -command {set Sensor1 1} -state normal -text Int -value Interno \
        -variable Conector1 
    vTcl:DefineAlias "$site_3_0.cpd73" "Radiobutton_Interno1" vTcl:WidgetProc "DrDaq" 1
    radiobutton $site_3_0.cpd74 \
        \
        -command {set Sensor1 1
if {$Conector2 ne "Interno"} {
    set Conector2 Ext2
}} \
        -state normal -text {Ext 1} -value Ext1 -variable Conector1 
    vTcl:DefineAlias "$site_3_0.cpd74" "Radiobutton_Ext1_1" vTcl:WidgetProc "DrDaq" 1
    radiobutton $site_3_0.cpd75 \
        \
        -command {set Sensor1 1
if {$Conector2 ne "Interno"} {
    set Conector2 Ext1
}} \
        -state normal -text {Ext 2} -value Ext2 -variable Conector1 
    vTcl:DefineAlias "$site_3_0.cpd75" "Radiobutton_Ext2_1" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.lab78 \
        -text Tipo: 
    vTcl:DefineAlias "$site_3_0.lab78" "Label_Modo1" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd79 \
        -text Conector: 
    vTcl:DefineAlias "$site_3_0.cpd79" "Label_Conector1" vTcl:WidgetProc "DrDaq" 1
    spinbox $site_3_0.spi63 \
        -activebackground #ffffff -background #ffffff \
        -command {set Sensor1 1} -foreground black -from 0.0 \
        -highlightcolor black -increment 1.0 -insertbackground black \
        -justify center -selectbackground #c4c4c4 -selectforeground black \
        -state readonly -textvariable Modo1 -to 0.0 \
        -values {"Onda Sonora" "Nivel Sonoro" Voltagem Resistencia pH Temperatura  Luz} 
    vTcl:DefineAlias "$site_3_0.spi63" "Spinbox_Modo1" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd55 \
        -activeforeground #999999 -background #999999 -foreground #ffffff \
        -text {SENSOR 1} 
    vTcl:DefineAlias "$site_3_0.cpd55" "Label_Sensor1" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd57 \
        -activebackground #f9f9f9 -background #cccccc -justify center \
        -relief groove -text 0.00 
    vTcl:DefineAlias "$site_3_0.cpd57" "Medidor1" vTcl:WidgetProc "DrDaq" 1
    frame $site_3_0.fra59 \
        -borderwidth 2 -relief groove -height 60 -width 178 
    vTcl:DefineAlias "$site_3_0.fra59" "Frame3" vTcl:WidgetProc "DrDaq" 1
    set site_4_0 $site_3_0.fra59
    label $site_4_0.cpd60 \
        -activeforeground #ffffff -foreground #000000 -text Conector: 
    vTcl:DefineAlias "$site_4_0.cpd60" "Label_Conector3" vTcl:WidgetProc "DrDaq" 1
    radiobutton $site_4_0.cpd61 \
        -anchor w -command {set Sensor1 1} -state normal -text Int. \
        -value Interno -variable Conector1 
    vTcl:DefineAlias "$site_4_0.cpd61" "Radiobutton_Interno3" vTcl:WidgetProc "DrDaq" 1
    radiobutton $site_4_0.cpd62 \
        -anchor w \
        -command {set Sensor1 1
if {$Conector2 ne "Interno"} {
    set Conector2 Ext2
}} \
        -state normal -text {Ext 1} -value Ext1 -variable Conector1 
    vTcl:DefineAlias "$site_4_0.cpd62" "Radiobutton_Ext1" vTcl:WidgetProc "DrDaq" 1
    radiobutton $site_4_0.cpd63 \
        -anchor w \
        -command {set Sensor1 1
if {$Conector2 ne "Interno"} {
    set Conector2 Ext1
}} \
        -state normal -text {Ext 2} -value Ext2 -variable Conector1 
    vTcl:DefineAlias "$site_4_0.cpd63" "Radiobutton_Ext2" vTcl:WidgetProc "DrDaq" 1
    place $site_4_0.cpd60 \
        -in $site_4_0 -x 55 -y 2 -width 72 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_4_0.cpd61 \
        -in $site_4_0 -x 5 -y 25 -width 56 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_4_0.cpd62 \
        -in $site_4_0 -x 55 -y 25 -width 60 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_4_0.cpd63 \
        -in $site_4_0 -x 115 -y 25 -width 60 -height 22 -anchor nw \
        -bordermode ignore 
    frame $site_3_0.fra64 \
        -borderwidth 2 -relief groove -height 45 -width 177 
    vTcl:DefineAlias "$site_3_0.fra64" "Frame4" vTcl:WidgetProc "DrDaq" 1
    set site_4_0 $site_3_0.fra64
    label $site_4_0.cpd65 \
        -activeforeground #ffffff -foreground #000000 -highlightcolor #ffff00 \
        -text Tipo: 
    vTcl:DefineAlias "$site_4_0.cpd65" "Label_Modo3" vTcl:WidgetProc "DrDaq" 1
    spinbox $site_4_0.cpd66 \
        -activebackground #ffffff -background #ffffff \
        -command {set Sensor1 1} -font {Helvetica -12 bold} \
        -foreground #000000 -from 0.0 -highlightcolor black -increment 1.0 \
        -insertbackground black -justify center -selectbackground #c4c4c4 \
        -selectforeground black -state readonly -textvariable Modo1 -to 0.0 \
        -values {"Onda Sonora" "Nivel Sonoro" Voltagem Resistencia pH Temperatura  Luz} 
    vTcl:DefineAlias "$site_4_0.cpd66" "Spinbox_Modo3" vTcl:WidgetProc "DrDaq" 1
    place $site_4_0.cpd65 \
        -in $site_4_0 -x 11 -y 11 -width 50 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_4_0.cpd66 \
        -in $site_4_0 -x 55 -y 12 -width 109 -height 22 -anchor nw \
        -bordermode ignore 
    button $site_3_0.but74 \
        -state disabled -text Calibrar 
    vTcl:DefineAlias "$site_3_0.but74" "Calibrar1" vTcl:WidgetProc "DrDaq" 1
    checkbutton $site_3_0.cpd58 \
        -anchor e -background #999999 -highlightbackground #999999 \
        -variable Sensor1 
    vTcl:DefineAlias "$site_3_0.cpd58" "Checkbutton_Sensor1" vTcl:WidgetProc "DrDaq" 1
    place $site_3_0.cpd73 \
        -in $site_3_0 -x 80 -y 275 -width 47 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd74 \
        -in $site_3_0 -x 80 -y 295 -width 60 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd75 \
        -in $site_3_0 -x 80 -y 325 -width 60 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.lab78 \
        -in $site_3_0 -x 195 -y 320 -width 42 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd79 \
        -in $site_3_0 -x 160 -y 295 -width 63 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.spi63 \
        -in $site_3_0 -x 175 -y 340 -width 99 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd55 \
        -in $site_3_0 -x 1 -y 1 -width 71 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd57 \
        -in $site_3_0 -x 127 -y 8 -width 61 -height 25 -anchor nw \
        -bordermode ignore 
    place $site_3_0.fra59 \
        -in $site_3_0 -x 7 -y 100 -width 178 -height 60 -anchor nw \
        -bordermode ignore 
    place $site_3_0.fra64 \
        -in $site_3_0 -x 10 -y 40 -width 177 -height 45 -anchor nw \
        -bordermode ignore 
    place $site_3_0.but74 \
        -in $site_3_0 -x 75 -y 170 -width 69 -height 26 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd58 \
        -in $site_3_0 -x 71 -y 0 -width 31 -height 21 -anchor nw \
        -bordermode ignore 
    button $top.but87 \
        -background #009900 \
        -command {set Entradas 1

ValidarEntradas

if {$Entradas} {
    Parar configure -state normal
    Iniciar configure -state disabled
    set stopped 1
    QualSensor
    hitStart    
}} \
        -text Iniciar 
    vTcl:DefineAlias "$top.but87" "Iniciar" vTcl:WidgetProc "DrDaq" 1
    frame $top.fra88 \
        -borderwidth 2 -relief groove -height 155 -width 405 
    vTcl:DefineAlias "$top.fra88" "Frame_Grafico" vTcl:WidgetProc "DrDaq" 1
    set site_3_0 $top.fra88
    entry $site_3_0.ent90 \
        -background white -insertbackground black -justify right \
        -state disabled -textvariable xmax -validate all \
        -validatecommand {vTcl:DoCmdOption .drdaqgrace.fra88.ent90 {string is double %P}} 
    vTcl:DefineAlias "$site_3_0.ent90" "Entry_Xmax" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd92 \
        -text {y max:} 
    vTcl:DefineAlias "$site_3_0.cpd92" "Label_Y_Max" vTcl:WidgetProc "DrDaq" 1
    entry $site_3_0.cpd93 \
        -background white -insertbackground black -justify right \
        -state disabled -textvariable ymax -validate all \
        -validatecommand {vTcl:DoCmdOption .drdaqgrace.fra88.cpd93 {string is double %P}} 
    vTcl:DefineAlias "$site_3_0.cpd93" "Entry_Ymax" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd94 \
        -text {maior div x:} 
    vTcl:DefineAlias "$site_3_0.cpd94" "Label_X_Max2" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd95 \
        -text {maior div y:} 
    vTcl:DefineAlias "$site_3_0.cpd95" "Label_X_Max3" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd96 \
        -text {menor div x:} 
    vTcl:DefineAlias "$site_3_0.cpd96" "Label_X_Max4" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd97 \
        -text {menor div y:} 
    vTcl:DefineAlias "$site_3_0.cpd97" "Label_X_Max5" vTcl:WidgetProc "DrDaq" 1
    entry $site_3_0.cpd98 \
        -background white -insertbackground black -justify right \
        -state disabled -textvariable maior_divx -validate all \
        -validatecommand {vTcl:DoCmdOption .drdaqgrace.fra88.cpd98 {string is double %P}} 
    vTcl:DefineAlias "$site_3_0.cpd98" "Entry_Max_divx" vTcl:WidgetProc "DrDaq" 1
    entry $site_3_0.cpd99 \
        -background white -insertbackground black -justify right \
        -state disabled -textvariable menor_divx -validate all \
        -validatecommand {vTcl:DoCmdOption .drdaqgrace.fra88.cpd99 {string is double %P}} 
    vTcl:DefineAlias "$site_3_0.cpd99" "Entry_Min_divx" vTcl:WidgetProc "DrDaq" 1
    entry $site_3_0.cpd100 \
        -background white -insertbackground black -justify right \
        -state disabled -textvariable maior_divy -validate all \
        -validatecommand {vTcl:DoCmdOption .drdaqgrace.fra88.cpd100 {string is double %P}} 
    vTcl:DefineAlias "$site_3_0.cpd100" "Entry_Max_divy" vTcl:WidgetProc "DrDaq" 1
    entry $site_3_0.cpd101 \
        -background white -insertbackground black -justify right \
        -state disabled -textvariable menor_divy -validate all \
        -validatecommand {vTcl:DoCmdOption .drdaqgrace.fra88.cpd101 {string is double %P}} 
    vTcl:DefineAlias "$site_3_0.cpd101" "Entry_Min_divy" vTcl:WidgetProc "DrDaq" 1
    entry $site_3_0.cpd60 \
        -background white -insertbackground black -justify right \
        -state disabled -textvariable ymin -validate all \
        -validatecommand {vTcl:DoCmdOption .drdaqgrace.fra88.cpd93 {string is double %P}} 
    vTcl:DefineAlias "$site_3_0.cpd60" "Entry_Ymin" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd61 \
        -text {y min:} 
    vTcl:DefineAlias "$site_3_0.cpd61" "Label_Y_Min" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd47 \
        -anchor w -text {Auto Escala (X,Y)} 
    vTcl:DefineAlias "$site_3_0.cpd47" "Label_AutoScala2" vTcl:WidgetProc "DrDaq" 1
    checkbutton $site_3_0.cpd48 \
        \
        -command {if {$AutoEscala} {
    Entry_Xmax configure -state disabled
    Entry_Ymax configure -state disabled
    Entry_Ymin configure -state disabled
    Entry_Max_divx configure -state disabled
    Entry_Min_divx configure -state disabled
    Entry_Max_divy configure -state disabled
    Entry_Min_divy configure -state disabled
} else {
    Entry_Xmax configure -state normal
    Entry_Ymax configure -state normal
    Entry_Ymin configure -state normal
    Entry_Max_divx configure -state normal
    Entry_Min_divx configure -state normal
    Entry_Max_divy configure -state normal
    Entry_Min_divy configure -state normal
}} \
        -variable AutoEscala -width 22 
    vTcl:DefineAlias "$site_3_0.cpd48" "Checkbutton_AutoScala1" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd58 \
        -activeforeground #999999 -background #999999 -foreground #ffffff \
        -text GRAFICO 
    vTcl:DefineAlias "$site_3_0.cpd58" "Label2" vTcl:WidgetProc "DrDaq" 1
    checkbutton $site_3_0.che60 \
        -anchor w -text {Auto Escala (Y)} -variable "$top\::che60" 
    vTcl:DefineAlias "$site_3_0.che60" "Checkbutton1" vTcl:WidgetProc "DrDaq" 1
    frame $site_3_0.fra62 \
        -borderwidth 2 -relief groove -height 100 -width 180 
    vTcl:DefineAlias "$site_3_0.fra62" "Frame1" vTcl:WidgetProc "DrDaq" 1
    set site_4_0 $site_3_0.fra62
    label $site_4_0.cpd63 \
        -background #009900 -foreground #ffffff -text {Eixo X} 
    vTcl:DefineAlias "$site_4_0.cpd63" "Label3" vTcl:WidgetProc "DrDaq" 1
    spinbox $site_4_0.spi47 \
        -activebackground #f9f9f9 -foreground black -from 0.0 \
        -highlightcolor black -increment 1.0 -insertbackground black \
        -selectbackground #c4c4c4 -selectforeground black -to 0.0 \
        -values {Tempo Sensor1 Sensor2} 
    vTcl:DefineAlias "$site_4_0.spi47" "Spinbox1" vTcl:WidgetProc "DrDaq" 1
    entry $site_4_0.cpd49 \
        -background white -insertbackground black -justify right \
        -state disabled -textvariable xmax -validate all \
        -validatecommand {vTcl:DoCmdOption .drdaqgrace.fra88.ent90 {string is double %P}} 
    vTcl:DefineAlias "$site_4_0.cpd49" "Entry_Xmax1" vTcl:WidgetProc "DrDaq" 1
    label $site_4_0.cpd50 \
        -text {x max:} 
    vTcl:DefineAlias "$site_4_0.cpd50" "Label_X_Max6" vTcl:WidgetProc "DrDaq" 1
    entry $site_4_0.cpd51 \
        -background white -insertbackground black -justify right \
        -state disabled -textvariable xmax -validate all \
        -validatecommand {vTcl:DoCmdOption .drdaqgrace.fra88.ent90 {string is double %P}} 
    vTcl:DefineAlias "$site_4_0.cpd51" "Entry_Xmax2" vTcl:WidgetProc "DrDaq" 1
    label $site_4_0.cpd52 \
        -text {x min :} 
    vTcl:DefineAlias "$site_4_0.cpd52" "Label_X_Max7" vTcl:WidgetProc "DrDaq" 1
    place $site_4_0.cpd63 \
        -in $site_4_0 -x 1 -y 1 -width 43 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_4_0.spi47 \
        -in $site_4_0 -x 86 -y 12 -width 69 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_4_0.cpd49 \
        -in $site_4_0 -x 87 -y 64 -width 68 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_4_0.cpd50 \
        -in $site_4_0 -x 31 -y 62 -width 46 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_4_0.cpd51 \
        -in $site_4_0 -x 87 -y 38 -width 68 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_4_0.cpd52 \
        -in $site_4_0 -x 30 -y 35 -anchor nw -bordermode inside 
    label $site_3_0.lab91 \
        -text {x max:} 
    vTcl:DefineAlias "$site_3_0.lab91" "Label_X_Max1" vTcl:WidgetProc "DrDaq" 1
    frame $site_3_0.cpd53 \
        -borderwidth 2 -relief groove -height 100 -width 180 
    vTcl:DefineAlias "$site_3_0.cpd53" "Frame2" vTcl:WidgetProc "DrDaq" 1
    set site_4_0 $site_3_0.cpd53
    label $site_4_0.cpd63 \
        -background #009999 -foreground #ffffff -text {Eixo Y} 
    vTcl:DefineAlias "$site_4_0.cpd63" "Label4" vTcl:WidgetProc "DrDaq" 1
    spinbox $site_4_0.spi47 \
        -activebackground #f9f9f9 -foreground black -from 0.0 \
        -highlightcolor black -increment 1.0 -insertbackground black \
        -selectbackground #c4c4c4 -selectforeground black \
        -values {Sensor1 Sensor2 Ambos } 
    vTcl:DefineAlias "$site_4_0.spi47" "Spinbox2" vTcl:WidgetProc "DrDaq" 1
    entry $site_4_0.cpd49 \
        -background white -insertbackground black -justify right \
        -state disabled -textvariable xmax -validate all \
        -validatecommand {vTcl:DoCmdOption .drdaqgrace.fra88.ent90 {string is double %P}} 
    vTcl:DefineAlias "$site_4_0.cpd49" "Entry_Xmax3" vTcl:WidgetProc "DrDaq" 1
    label $site_4_0.cpd50 \
        -text {y max:} 
    vTcl:DefineAlias "$site_4_0.cpd50" "Label_X_Max8" vTcl:WidgetProc "DrDaq" 1
    entry $site_4_0.cpd51 \
        -background white -insertbackground black -justify right \
        -state disabled -textvariable xmax -validate all \
        -validatecommand {vTcl:DoCmdOption .drdaqgrace.fra88.ent90 {string is double %P}} 
    vTcl:DefineAlias "$site_4_0.cpd51" "Entry_Xmax4" vTcl:WidgetProc "DrDaq" 1
    label $site_4_0.cpd52 \
        -text {y min :} 
    vTcl:DefineAlias "$site_4_0.cpd52" "Label_X_Max9" vTcl:WidgetProc "DrDaq" 1
    place $site_4_0.cpd63 \
        -in $site_4_0 -x 1 -y 1 -width 43 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_4_0.spi47 \
        -in $site_4_0 -x 83 -y 10 -width 69 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_4_0.cpd49 \
        -in $site_4_0 -x 85 -y 62 -width 68 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_4_0.cpd50 \
        -in $site_4_0 -x 37 -y 62 -width 46 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_4_0.cpd51 \
        -in $site_4_0 -x 85 -y 35 -width 68 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_4_0.cpd52 \
        -in $site_4_0 -x 35 -y 35 -anchor nw -bordermode inside 
    checkbutton $site_3_0.che54 \
        -text {Auto Escala (X,Y)} -variable "$top\::che54" 
    vTcl:DefineAlias "$site_3_0.che54" "Checkbutton3" vTcl:WidgetProc "DrDaq" 1
    place $site_3_0.ent90 \
        -in $site_3_0 -x 155 -y 210 -width 40 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd92 \
        -in $site_3_0 -x 15 -y 160 -width 43 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd93 \
        -in $site_3_0 -x 65 -y 155 -width 40 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd94 \
        -in $site_3_0 -x 125 -y 155 -width 72 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd95 \
        -in $site_3_0 -x 270 -y 155 -width 73 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd96 \
        -in $site_3_0 -x 125 -y 190 -width 76 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd97 \
        -in $site_3_0 -x 265 -y 180 -width 77 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd98 \
        -in $site_3_0 -x 205 -y 155 -width 40 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd99 \
        -in $site_3_0 -x 205 -y 185 -width 40 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd100 \
        -in $site_3_0 -x 350 -y 155 -width 40 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd101 \
        -in $site_3_0 -x 350 -y 180 -width 40 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd60 \
        -in $site_3_0 -x 65 -y 185 -width 40 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd61 \
        -in $site_3_0 -x 10 -y 190 -width 47 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd47 \
        -in $site_3_0 -x 255 -y 210 -width 120 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd48 \
        -in $site_3_0 -x 230 -y 210 -width 22 -height 22 -anchor nw \
        -bordermode inside 
    place $site_3_0.cpd58 \
        -in $site_3_0 -x 0 -y 1 -width 62 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.che60 \
        -in $site_3_0 -x 255 -y 9 -width 121 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.fra62 \
        -in $site_3_0 -x 10 -y 40 -width 180 -height 100 -anchor nw \
        -bordermode ignore 
    place $site_3_0.lab91 \
        -in $site_3_0 -x 100 -y 210 -width 42 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd53 \
        -in $site_3_0 -x 210 -y 40 -width 180 -height 100 -anchor nw \
        -bordermode ignore 
    place $site_3_0.che54 \
        -in $site_3_0 -x 95 -y 10 -width 132 -height 22 -anchor nw \
        -bordermode ignore 
    frame $top.fra102 \
        -borderwidth 2 -relief groove -height 205 -width 195 
    vTcl:DefineAlias "$top.fra102" "Frame_Canal2" vTcl:WidgetProc "DrDaq" 1
    set site_3_0 $top.fra102
    label $site_3_0.cpd56 \
        -activeforeground #999999 -background #999999 -foreground #ffffff \
        -text {SENSOR 2} 
    vTcl:DefineAlias "$site_3_0.cpd56" "Label_Sensor2" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd49 \
        -background #cccccc -justify center -relief groove -text 0.00 
    vTcl:DefineAlias "$site_3_0.cpd49" "Medidor2" vTcl:WidgetProc "DrDaq" 1
    frame $site_3_0.fra50 \
        -borderwidth 2 -relief groove -height 60 -width 170 
    vTcl:DefineAlias "$site_3_0.fra50" "Frame5" vTcl:WidgetProc "DrDaq" 1
    set site_4_0 $site_3_0.fra50
    label $site_4_0.cpd51 \
        -text Conector: 
    vTcl:DefineAlias "$site_4_0.cpd51" "Label_Conector2" vTcl:WidgetProc "DrDaq" 1
    radiobutton $site_4_0.cpd52 \
        -command {set Sensor2 1} -text Int -value Interno -variable Conector2 
    vTcl:DefineAlias "$site_4_0.cpd52" "Radiobutton_Interno2" vTcl:WidgetProc "DrDaq" 1
    radiobutton $site_4_0.cpd53 \
        \
        -command {set Sensor2 1
if {$Conector1 ne "Interno"} {
    set Conector1 Ext2
}} \
        -text {Ext 1} -value Ext1 -variable Conector2 
    vTcl:DefineAlias "$site_4_0.cpd53" "Radiobutton_Ext3" vTcl:WidgetProc "DrDaq" 1
    radiobutton $site_4_0.cpd54 \
        \
        -command {set Sensor2 1
if {$Conector1 ne "Interno"} {
    set Conector1 Ext1
}} \
        -text {Ext 2} -value Ext2 -variable Conector2 
    vTcl:DefineAlias "$site_4_0.cpd54" "Radiobutton_Ext4" vTcl:WidgetProc "DrDaq" 1
    place $site_4_0.cpd51 \
        -in $site_4_0 -x 50 -y 2 -width 63 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_4_0.cpd52 \
        -in $site_4_0 -x 2 -y 27 -width 45 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_4_0.cpd53 \
        -in $site_4_0 -x 49 -y 26 -width 60 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_4_0.cpd54 \
        -in $site_4_0 -x 109 -y 25 -width 60 -height 22 -anchor nw \
        -bordermode ignore 
    button $site_3_0.cpd55 \
        -state disabled -text Calibrar 
    vTcl:DefineAlias "$site_3_0.cpd55" "Calibrar2" vTcl:WidgetProc "DrDaq" 1
    checkbutton $site_3_0.cpd59 \
        -anchor e -background #999999 -highlightbackground #999999 \
        -variable Sensor2 
    vTcl:DefineAlias "$site_3_0.cpd59" "Checkbutton_Sensor2" vTcl:WidgetProc "DrDaq" 1
    frame $site_3_0.fra49 \
        -borderwidth 2 -relief groove -height 45 -width 170 
    vTcl:DefineAlias "$site_3_0.fra49" "Frame6" vTcl:WidgetProc "DrDaq" 1
    set site_4_0 $site_3_0.fra49
    spinbox $site_4_0.cpd50 \
        -activebackground #ffffff -background #ffffff \
        -command {set Sensor1 1} -font {Helvetica -12 bold} -foreground black \
        -from 0.0 -highlightcolor black -increment 1.0 \
        -insertbackground black -justify center -selectbackground #c4c4c4 \
        -selectforeground black -state readonly -textvariable Modo1 -to 0.0 \
        -values {"Onda Sonora" "Nivel Sonoro" Voltagem Resistencia pH Temperatura  Luz} 
    vTcl:DefineAlias "$site_4_0.cpd50" "Spinbox_Modo4" vTcl:WidgetProc "DrDaq" 1
    label $site_4_0.cpd51 \
        -activeforeground #ffffff -foreground #000000 -highlightcolor #ffff00 \
        -text Tipo: 
    vTcl:DefineAlias "$site_4_0.cpd51" "Label_Modo4" vTcl:WidgetProc "DrDaq" 1
    place $site_4_0.cpd50 \
        -in $site_4_0 -x 50 -y 12 -width 109 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_4_0.cpd51 \
        -in $site_4_0 -x 14 -y 13 -width 35 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd56 \
        -in $site_3_0 -x 1 -y 1 -width 71 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd49 \
        -in $site_3_0 -x 125 -y 7 -width 56 -height 25 -anchor nw \
        -bordermode ignore 
    place $site_3_0.fra50 \
        -in $site_3_0 -x 10 -y 100 -width 173 -height 60 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd55 \
        -in $site_3_0 -x 61 -y 170 -width 69 -height 26 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd59 \
        -in $site_3_0 -x 70 -y 0 -width 36 -height 21 -anchor nw \
        -bordermode ignore 
    place $site_3_0.fra49 \
        -in $site_3_0 -x 10 -y 40 -width 172 -height 45 -anchor nw \
        -bordermode ignore 
    frame $top.fra70 \
        -borderwidth 2 -relief groove -height 110 -width 405 
    vTcl:DefineAlias "$top.fra70" "Frame_Passo" vTcl:WidgetProc "DrDaq" 1
    set site_3_0 $top.fra70
    entry $site_3_0.ent76 \
        -background white -exportselection 1 -highlightthickness 1 \
        -insertbackground black -invalidcommand bell -justify right \
        -textvariable Delta_T -validate all \
        -validatecommand {vTcl:DoCmdOption .drdaqgrace.fra70.ent76 {string is double %P}} 
    vTcl:DefineAlias "$site_3_0.ent76" "Entry_Tempo" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.lab80 \
        -text (s) 
    vTcl:DefineAlias "$site_3_0.lab80" "Label_Seg" vTcl:WidgetProc "DrDaq" 1
    radiobutton $site_3_0.rad64 \
        -anchor w \
        -command {Entry_Tempo configure -state normal
Entry_TMax configure -state normal
Entry_Cont configure -state disabled} \
        -text Intervalo: -value Tempo -variable Passo 
    vTcl:DefineAlias "$site_3_0.rad64" "Radiobutton_Passo_Tempo" vTcl:WidgetProc "DrDaq" 1
    entry $site_3_0.cpd66 \
        -background white -exportselection 1 -highlightthickness 1 \
        -insertbackground black -invalidcommand bell -justify right \
        -textvariable TMax -validate all \
        -validatecommand {vTcl:DoCmdOption .drdaqgrace.fra70.cpd66 {string is double %P}} 
    vTcl:DefineAlias "$site_3_0.cpd66" "Entry_TMax" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd67 \
        -text (s) 
    vTcl:DefineAlias "$site_3_0.cpd67" "Label_Seg1" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd68 \
        -text {Tempo max:} 
    vTcl:DefineAlias "$site_3_0.cpd68" "Label_TMax" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.lab60 \
        -background #cccccc -justify center -relief groove -text 0.00 
    vTcl:DefineAlias "$site_3_0.lab60" "Cronometro" vTcl:WidgetProc "DrDaq" 1
    entry $site_3_0.cpd60 \
        -background white -exportselection 1 -highlightthickness 1 \
        -insertbackground black -invalidcommand bell -justify right \
        -textvariable ncont -validate all \
        -validatecommand {vTcl:DoCmdOption .drdaqgrace.fra70.cpd60 {string is integer %P}} 
    vTcl:DefineAlias "$site_3_0.cpd60" "Entry_Cont" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.lab49 \
        -background #999999 -foreground #ffffff -text {CONTROLE DE TEMPO} 
    vTcl:DefineAlias "$site_3_0.lab49" "Label1" vTcl:WidgetProc "DrDaq" 1
    radiobutton $site_3_0.rad50 \
        -anchor w -text Leituras/seg: -value Rate \
        -variable "$top\::selectedButton" 
    vTcl:DefineAlias "$site_3_0.rad50" "Radiobutton_Leituras_por_Segundo" vTcl:WidgetProc "DrDaq" 1
    entry $site_3_0.ent51 \
        -background white -insertbackground black \
        -textvariable "$top\::ent51" 
    vTcl:DefineAlias "$site_3_0.ent51" "Entry_Leituras_por_segundo" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd52 \
        -anchor w -state normal -text {(s    )} 
    vTcl:DefineAlias "$site_3_0.cpd52" "Label_Seg2" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd53 \
        -text -1 
    vTcl:DefineAlias "$site_3_0.cpd53" "Label_Seg3" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd54 \
        -text {No. Leituras:} 
    vTcl:DefineAlias "$site_3_0.cpd54" "Label_TMax1" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd55 \
        -text (s) 
    vTcl:DefineAlias "$site_3_0.cpd55" "Label_Seg4" vTcl:WidgetProc "DrDaq" 1
    place $site_3_0.ent76 \
        -in $site_3_0 -x 120 -y 40 -width 43 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.lab80 \
        -in $site_3_0 -x 165 -y 41 -width 25 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.rad64 \
        -in $site_3_0 -x 14 -y 40 -width 86 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd66 \
        -in $site_3_0 -x 315 -y 40 -width 38 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd67 \
        -in $site_3_0 -x 354 -y 43 -width 25 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd68 \
        -in $site_3_0 -x 230 -y 42 -width 85 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.lab60 \
        -in $site_3_0 -x 269 -y 8 -width 67 -height 25 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd60 \
        -in $site_3_0 -x 315 -y 72 -width 38 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.lab49 \
        -in $site_3_0 -x 0 -y 0 -width 145 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.rad50 \
        -in $site_3_0 -x 13 -y 72 -width 103 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.ent51 \
        -in $site_3_0 -x 120 -y 72 -width 43 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd52 \
        -in $site_3_0 -x 165 -y 73 -width 45 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd53 \
        -in $site_3_0 -x 180 -y 69 -width 18 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd54 \
        -in $site_3_0 -x 230 -y 73 -width 82 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd55 \
        -in $site_3_0 -x 335 -y 9 -width 25 -height 20 -anchor nw \
        -bordermode ignore 
    menu $top.m71 \
        -tearoff 1 
    button $top.cpd83 \
        -background #e6e7e6 -command exit -text Sair 
    vTcl:DefineAlias "$top.cpd83" "Sair" vTcl:WidgetProc "DrDaq" 1
    button $top.cpd60 \
        -background #ce1400000000 \
        -command {Parar configure -state disabled
Iniciar configure -state normal
set stopped 1
hitStop} \
        -text Parar 
    vTcl:DefineAlias "$top.cpd60" "Parar" vTcl:WidgetProc "DrDaq" 1
    ###################
    # SETTING GEOMETRY
    ###################
    place $top.fra62 \
        -in $top -x 30 -y 35 -width 200 -height 205 -anchor nw \
        -bordermode ignore 
    place $top.but87 \
        -in $top -x 110 -y 525 -width 72 -height 41 -anchor nw \
        -bordermode ignore 
    place $top.fra88 \
        -in $top -x 30 -y 361 -width 405 -height 155 -anchor nw \
        -bordermode ignore 
    place $top.fra102 \
        -in $top -x 234 -y 35 -width 200 -height 205 -anchor nw \
        -bordermode ignore 
    place $top.fra70 \
        -in $top -x 30 -y 245 -width 405 -height 110 -anchor nw \
        -bordermode ignore 
    place $top.cpd83 \
        -in $top -x 285 -y 525 -width 54 -height 43 -anchor nw \
        -bordermode ignore 
    place $top.cpd60 \
        -in $top -x 200 -y 525 -width 62 -height 42 -anchor nw \
        -bordermode ignore 

    vTcl:FireEvent $base <<Ready>>
}

#############################################################################
## Binding tag:  _TopLevel

bind "_TopLevel" <<Create>> {
    if {![info exists _topcount]} {set _topcount 0}; incr _topcount
}
bind "_TopLevel" <<DeleteWindow>> {
    if {[set ::%W::_modal]} {
                vTcl:Toplevel:WidgetProc %W endmodal
            } else {
                destroy %W; if {$_topcount == 0} {exit}
            }
}
bind "_TopLevel" <Destroy> {
    if {[winfo toplevel %W] == "%W"} {incr _topcount -1}
}
#############################################################################
## Binding tag:  _vTclBalloon


if {![info exists vTcl(sourcing)]} {
bind "_vTclBalloon" <<KillBalloon>> {
    namespace eval ::vTcl::balloon {
        after cancel $id
        if {[winfo exists .vTcl.balloon]} {
            destroy .vTcl.balloon
        }
        set set 0
    }
}
bind "_vTclBalloon" <<vTclBalloon>> {
    if {$::vTcl::balloon::first != 1} {break}

    namespace eval ::vTcl::balloon {
        set first 2
        if {![winfo exists .vTcl]} {
            toplevel .vTcl; wm withdraw .vTcl
        }
        if {![winfo exists .vTcl.balloon]} {
            toplevel .vTcl.balloon -bg black
        }
        wm overrideredirect .vTcl.balloon 1
        label .vTcl.balloon.l  -text ${%W} -relief flat  -bg #ffffaa -fg black -padx 2 -pady 0 -anchor w
        pack .vTcl.balloon.l -side left -padx 1 -pady 1
        wm geometry  .vTcl.balloon  +[expr {[winfo rootx %W]+[winfo width %W]/2}]+[expr {[winfo rooty %W]+[winfo height %W]+4}]
        set set 1
    }
}
bind "_vTclBalloon" <Button> {
    namespace eval ::vTcl::balloon {
        set first 0
    }
    vTcl:FireEvent %W <<KillBalloon>>
}
bind "_vTclBalloon" <Enter> {
    namespace eval ::vTcl::balloon {
        ## self defining balloon?
        if {![info exists %W]} {
            vTcl:FireEvent %W <<SetBalloon>>
        }
        set set 0
        set first 1
        set id [after 500 {vTcl:FireEvent %W <<vTclBalloon>>}]
    }
}
bind "_vTclBalloon" <Leave> {
    namespace eval ::vTcl::balloon {
        set first 0
    }
    vTcl:FireEvent %W <<KillBalloon>>
}
bind "_vTclBalloon" <Motion> {
    namespace eval ::vTcl::balloon {
        if {!$set} {
            after cancel $id
            set id [after 500 {vTcl:FireEvent %W <<vTclBalloon>>}]
        }
    }
}
}

Window show .
Window show .drdaqgrace

main $argc $argv
