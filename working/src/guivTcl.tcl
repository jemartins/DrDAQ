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

#############################################################################
# vTcl Code to Load Stock Fonts


if {![info exist vTcl(sourcing)]} {
set vTcl(fonts,counter) 0
#############################################################################
## Procedure:  vTcl:font:add_font

proc ::vTcl:font:add_font {font_descr font_type {newkey {}}} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    if {[info exists ::vTcl(fonts,$font_descr,object)]} {
        ## cool, it already exists
        return $::vTcl(fonts,$font_descr,object)
    }

     incr ::vTcl(fonts,counter)
     set newfont [eval font create $font_descr]
     lappend ::vTcl(fonts,objects) $newfont

     ## each font has its unique key so that when a project is
     ## reloaded, the key is used to find the font description
     if {$newkey == ""} {
          set newkey vTcl:font$::vTcl(fonts,counter)

          ## let's find an unused font key
          while {[vTcl:font:get_font $newkey] != ""} {
             incr ::vTcl(fonts,counter)
             set newkey vTcl:font$::vTcl(fonts,counter)
          }
     }

     set ::vTcl(fonts,$newfont,type)       $font_type
     set ::vTcl(fonts,$newfont,key)        $newkey
     set ::vTcl(fonts,$newfont,font_descr) $font_descr
     set ::vTcl(fonts,$font_descr,object)  $newfont
     set ::vTcl(fonts,$newkey,object)      $newfont

     lappend ::vTcl(fonts,$font_type) $newfont

     ## in case caller needs it
     return $newfont
}

#############################################################################
## Procedure:  vTcl:font:getFontFromDescr

proc ::vTcl:font:getFontFromDescr {font_descr} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    if {[info exists ::vTcl(fonts,$font_descr,object)]} {
        return $::vTcl(fonts,$font_descr,object)
    } else {
        return ""
    }
}

}
#############################################################################
# vTcl Code to Load User Fonts

vTcl:font:add_font \
    "-family avantgarde -size 18 -weight normal -slant roman -underline 0 -overstrike 0" \
    user \
    vTcl:font10
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
    namespace eval ::widgets::$site_3_0.can68 {
        array set save {-borderwidth 1 -closeenough 1 -height 1 -insertbackground 1 -relief 1 -selectbackground 1 -selectforeground 1 -width 1}
    }
    namespace eval ::widgets::$site_3_0.spi63 {
        array set save {-activebackground 1 -background 1 -command 1 -foreground 1 -from 1 -highlightcolor 1 -increment 1 -insertbackground 1 -justify 1 -selectbackground 1 -selectforeground 1 -state 1 -textvariable 1 -to 1 -values 1}
    }
    namespace eval ::widgets::$base.lab63 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$base.che65 {
        array set save {-variable 1}
    }
    namespace eval ::widgets::$base.but87 {
        array set save {-command 1 -text 1}
    }
    namespace eval ::widgets::$base.fra88 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    set site_3_0 $base.fra88
    namespace eval ::widgets::$site_3_0.ent90 {
        array set save {-background 1 -insertbackground 1 -justify 1 -textvariable 1 -validate 1 -validatecommand 1}
    }
    namespace eval ::widgets::$site_3_0.lab91 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$site_3_0.cpd92 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$site_3_0.cpd93 {
        array set save {-background 1 -insertbackground 1 -justify 1 -textvariable 1 -validate 1 -validatecommand 1}
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
        array set save {-background 1 -insertbackground 1 -justify 1 -textvariable 1 -validate 1 -validatecommand 1}
    }
    namespace eval ::widgets::$site_3_0.cpd99 {
        array set save {-background 1 -insertbackground 1 -justify 1 -textvariable 1 -validate 1 -validatecommand 1}
    }
    namespace eval ::widgets::$site_3_0.cpd100 {
        array set save {-background 1 -insertbackground 1 -justify 1 -textvariable 1 -validate 1 -validatecommand 1}
    }
    namespace eval ::widgets::$site_3_0.cpd101 {
        array set save {-background 1 -insertbackground 1 -justify 1 -textvariable 1 -validate 1 -validatecommand 1}
    }
    namespace eval ::widgets::$site_3_0.che61 {
        array set save {-command 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::$site_3_0.cpd63 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$base.fra102 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    set site_3_0 $base.fra102
    namespace eval ::widgets::$site_3_0.lab61 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$site_3_0.cpd62 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$site_3_0.cpd67 {
        array set save {-command 1 -text 1 -value 1 -variable 1}
    }
    namespace eval ::widgets::$site_3_0.cpd68 {
        array set save {-command 1 -text 1 -value 1 -variable 1}
    }
    namespace eval ::widgets::$site_3_0.cpd69 {
        array set save {-command 1 -text 1 -value 1 -variable 1}
    }
    namespace eval ::widgets::$site_3_0.can70 {
        array set save {-borderwidth 1 -closeenough 1 -height 1 -insertbackground 1 -relief 1 -selectbackground 1 -selectforeground 1 -width 1}
    }
    namespace eval ::widgets::$site_3_0.spi64 {
        array set save {-activebackground 1 -background 1 -command 1 -foreground 1 -from 1 -highlightcolor 1 -increment 1 -insertbackground 1 -justify 1 -selectbackground 1 -selectforeground 1 -state 1 -textvariable 1 -to 1 -values 1}
    }
    namespace eval ::widgets::$base.cpd103 {
        array set save {-variable 1}
    }
    namespace eval ::widgets::$base.cpd104 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$base.fra70 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    set site_3_0 $base.fra70
    namespace eval ::widgets::$site_3_0.cpd74 {
        array set save {-bigincrement 1 -from 1 -orient 1 -resolution 1 -tickinterval 1 -to 1 -variable 1}
    }
    namespace eval ::widgets::$site_3_0.ent76 {
        array set save {-background 1 -exportselection 1 -highlightthickness 1 -insertbackground 1 -invalidcommand 1 -justify 1 -textvariable 1 -validate 1 -validatecommand 1}
    }
    namespace eval ::widgets::$site_3_0.lab80 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$site_3_0.rad64 {
        array set save {-command 1 -text 1 -value 1 -variable 1}
    }
    namespace eval ::widgets::$site_3_0.cpd65 {
        array set save {-command 1 -text 1 -value 1 -variable 1}
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
        array set save {-background 1 -font 1 -justify 1 -relief 1 -text 1}
    }
    namespace eval ::widgets::$base.m71 {
        array set save {-tearoff 1}
        namespace eval subOptions {
            array set save {-command 1 -compound 1 -label 1 -menu 1}
        }
    }
    set site_3_0 $base.m71
    namespace eval ::widgets::$site_3_0.men63 {
        array set save {-tearoff 1}
        namespace eval subOptions {
            array set save {-accelerator 1 -command 1 -label 1 -state 1}
        }
    }
    namespace eval ::widgets::$base.cpd83 {
        array set save {-command 1 -text 1}
    }
    namespace eval ::widgets::$base.cpd60 {
        array set save {-command 1 -text 1}
    }
    namespace eval ::widgets::$base.cpd70 {
        array set save {-activebackground 1 -background 1 -justify 1 -relief 1 -text 1}
    }
    namespace eval ::widgets::$base.cpd71 {
        array set save {-background 1 -justify 1 -relief 1 -text 1}
    }
    namespace eval ::widgets_bindings {
        set tagslist _TopLevel
    }
    namespace eval ::vTcl::modules::main {
        set procs {
            init
            main
            showMessageBox
            ValidarEntradas
            QualSensor
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

}
#############################################################################
## Procedure:  showMessageBox

proc ::showMessageBox {w erro} {
global widget Entradas

set Entradas 0

tk_messageBox -icon info -message "Você Precisa Selecionar \"$erro\"" -type ok -parent $w
}
#############################################################################
## Procedure:  ValidarEntradas

proc ::ValidarEntradas {} {
global widget Entradas Sensor1 Sensor2 Conector1 Conector2 Passo AutoEscala
global Delta_T TMax ncont xmax ymax maior_divx maior_divy menor_divx menor_divy

set w .drdaqgrace

if {($Sensor1 == 0) && ($Sensor2 == 0)} {
    showMessageBox $w "um Sensor"
} elseif {($Conector1 == "") && ($Conector2 == "")} {
    showMessageBox $w "Conector"
} elseif {$Passo == ""} {
    showMessageBox $w "Intervalo ou Contagens"
} elseif {($Passo == "Tempo") && (($Delta_T == "") || ($TMax == "") || ($Delta_T < 0) ||  ($TMax < 0) || ($Delta_T > $TMax))} {
    if {($Delta_T == "")} {
        showMessageBox $w "Intervalo de Tempo"
    } elseif {$TMax == ""} {
        showMessageBox $w "o Valor Max do Tempo"
    } elseif {($Delta_T < 0) || ($TMax < 0)} {
        showMessageBox $w "Valores do Tempo maior que 0"
    } elseif {($Delta_T > $TMax)} {
        showMessageBox $w "Tempo Max maior que Intervalo"
    }
} elseif {($Passo == "Contagem")} {
    if {($ncont == 0)} {
        showMessageBox $w "Contagens maior que 0"
    } elseif {($Delta_T == "")} {
        showMessageBox $w "Intervalo de Tempo"
    } elseif {($Delta_T <= 0)} {
        showMessageBox $w "Valores do Tempo maior que 0"
    }
} elseif {($AutoEscala == 0) && (($xmax == "") || ($ymax == "") ||  ($maior_divx == "") ||  ($maior_divy == "") || ($menor_divx == "") ||  ($menor_divy == ""))} {
    showMessageBox $w "Auto Escala ou TODOS os Valores de x max, y max, maior div x,   maior div y,  menor div x, menor div y"
}
}
#############################################################################
## Procedure:  QualSensor

proc ::QualSensor {} {
global Sensor1 Sensor2 Modo1 Modo2 Conector1 Conector2
global widget nsensores set_value1 set_value2 nmodo1 nmodo2

#	IOCTL_PICO_GET_VALUE
#	  accepts:
#        	1 - Sound waveform
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
        } elseif {($Modo1 == "Luz")} {
            set set_value2 6
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
}

#puts stdout "nmodo1=$nmodo1"
#puts stdout "set_value1=$set_value1"
#puts stdout "nmodo2=$nmodo2"
#puts stdout "set_value2=$set_value2"
}

#include guiHandlers.tcl
#include msgHandlers.tcl
#include receiveUtils.tcl

#############################################################################
## Initialization Procedure:  init

proc ::init {argc argv} {


#include globalVars.tcl

#include topPart.tcl

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
    wm maxsize $top 1265 930
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
    wm geometry $top 461x458+515+59; update
    wm maxsize $top 1009 738
    wm minsize $top 1 1
    wm overrideredirect $top 0
    wm resizable $top 1 1
    wm deiconify $top
    wm title $top "drdaq & grace"
    vTcl:DefineAlias "$top" "DrDaq" vTcl:Toplevel:WidgetProc "" 1
    bindtags $top "$top Toplevel all _TopLevel"
    vTcl:FireEvent $top <<Create>>
    wm protocol $top WM_DELETE_WINDOW "vTcl:FireEvent $top <<DeleteWindow>>"

    frame $top.fra62 \
        -borderwidth 2 -relief groove -height 155 -width 200 
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
        -text Modo: 
    vTcl:DefineAlias "$site_3_0.lab78" "Label_Modo1" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd79 \
        -text Conector: 
    vTcl:DefineAlias "$site_3_0.cpd79" "Label_Conector1" vTcl:WidgetProc "DrDaq" 1
    canvas $site_3_0.can68 \
        -borderwidth 2 -closeenough 1.0 -height 9 -insertbackground black \
        -relief groove -selectbackground #c4c4c4 -selectforeground black \
        -width 150 
    vTcl:DefineAlias "$site_3_0.can68" "Canvas1" vTcl:WidgetProc "DrDaq" 1
    spinbox $site_3_0.spi63 \
        -activebackground #ffffff -background #ffffff \
        -command {set Sensor1 1} -foreground black -from 0.0 \
        -highlightcolor black -increment 1.0 -insertbackground black \
        -justify center -selectbackground #c4c4c4 -selectforeground black \
        -state readonly -textvariable Modo1 -to 0.0 \
        -values {"Onda Sonora" "Nivel Sonoro" Voltagem Resistencia pH Temperatura  Luz} 
    vTcl:DefineAlias "$site_3_0.spi63" "Spinbox_Modo1" vTcl:WidgetProc "DrDaq" 1
    place $site_3_0.cpd73 \
        -in $site_3_0 -x 7 -y 113 -width 47 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd74 \
        -in $site_3_0 -x 63 -y 113 -width 60 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd75 \
        -in $site_3_0 -x 127 -y 113 -width 60 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.lab78 \
        -in $site_3_0 -x 77 -y 11 -width 42 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd79 \
        -in $site_3_0 -x 68 -y 87 -width 63 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.can68 \
        -in $site_3_0 -x 25 -y 70 -width 150 -height 9 -anchor nw \
        -bordermode ignore 
    place $site_3_0.spi63 \
        -in $site_3_0 -x 53 -y 35 -width 99 -height 22 -anchor nw \
        -bordermode ignore 
    label $top.lab63 \
        -text {Sensor 1:} 
    vTcl:DefineAlias "$top.lab63" "Label_Sensor1" vTcl:WidgetProc "DrDaq" 1
    checkbutton $top.lab63.che66 \
        -activebackground #f9f9f9 -activeforeground black -background #e6e7e6 \
        -disabledforeground #a1a1a1 -foreground black \
        -highlightbackground #e6e7e6 -highlightcolor black -text check \
        -variable "$top\::che66" 
    vTcl:DefineAlias "$top.lab63.che66" "Checkbutton2" vTcl:WidgetProc "DrDaq" 1
    checkbutton $top.che65 \
        -variable Sensor1 
    vTcl:DefineAlias "$top.che65" "Checkbutton_Sensor1" vTcl:WidgetProc "DrDaq" 1
    button $top.but87 \
        \
        -command {set Entradas 1

ValidarEntradas

if {$Entradas} {
    Parar configure -state normal
    Iniciar configure -state disabled
    set stopped 1
    hitStart    
}} \
        -text Iniciar 
    vTcl:DefineAlias "$top.but87" "Iniciar" vTcl:WidgetProc "DrDaq" 1
    frame $top.fra88 \
        -borderwidth 2 -relief groove -height 100 -width 405 
    vTcl:DefineAlias "$top.fra88" "Frame_Grafico" vTcl:WidgetProc "DrDaq" 1
    set site_3_0 $top.fra88
    entry $site_3_0.ent90 \
        -background white -insertbackground black -justify right \
        -textvariable xmax -validate all \
        -validatecommand {vTcl:DoCmdOption .drdaqgrace.fra88.ent90 {string is double %P}} 
    vTcl:DefineAlias "$site_3_0.ent90" "Entry_Xmax" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.lab91 \
        -text {x max} 
    vTcl:DefineAlias "$site_3_0.lab91" "Label_X_Max" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd92 \
        -text {y max} 
    vTcl:DefineAlias "$site_3_0.cpd92" "Label_X_Max1" vTcl:WidgetProc "DrDaq" 1
    entry $site_3_0.cpd93 \
        -background white -insertbackground black -justify right \
        -textvariable ymax -validate all \
        -validatecommand {vTcl:DoCmdOption .drdaqgrace.fra88.cpd93 {string is double %P}} 
    vTcl:DefineAlias "$site_3_0.cpd93" "Entry_Ymax" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd94 \
        -text {maior div x} 
    vTcl:DefineAlias "$site_3_0.cpd94" "Label_X_Max2" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd95 \
        -text {maior div y} 
    vTcl:DefineAlias "$site_3_0.cpd95" "Label_X_Max3" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd96 \
        -text {menor div x} 
    vTcl:DefineAlias "$site_3_0.cpd96" "Label_X_Max4" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd97 \
        -text {menor div y} 
    vTcl:DefineAlias "$site_3_0.cpd97" "Label_X_Max5" vTcl:WidgetProc "DrDaq" 1
    entry $site_3_0.cpd98 \
        -background white -insertbackground black -justify right \
        -textvariable maior_divx -validate all \
        -validatecommand {vTcl:DoCmdOption .drdaqgrace.fra88.cpd98 {string is double %P}} 
    vTcl:DefineAlias "$site_3_0.cpd98" "Entry_Max_divx" vTcl:WidgetProc "DrDaq" 1
    entry $site_3_0.cpd99 \
        -background white -insertbackground black -justify right \
        -textvariable menor_divx -validate all \
        -validatecommand {vTcl:DoCmdOption .drdaqgrace.fra88.cpd99 {string is double %P}} 
    vTcl:DefineAlias "$site_3_0.cpd99" "Entry_Min_divx" vTcl:WidgetProc "DrDaq" 1
    entry $site_3_0.cpd100 \
        -background white -insertbackground black -justify right \
        -textvariable maior_divy -validate all \
        -validatecommand {vTcl:DoCmdOption .drdaqgrace.fra88.cpd100 {string is double %P}} 
    vTcl:DefineAlias "$site_3_0.cpd100" "Entry_Max_divy" vTcl:WidgetProc "DrDaq" 1
    entry $site_3_0.cpd101 \
        -background white -insertbackground black -justify right \
        -textvariable menor_divy -validate all \
        -validatecommand {vTcl:DoCmdOption .drdaqgrace.fra88.cpd101 {string is double %P}} 
    vTcl:DefineAlias "$site_3_0.cpd101" "Entry_Min_divy" vTcl:WidgetProc "DrDaq" 1
    checkbutton $site_3_0.che61 \
        \
        -command {if {$AutoEscala} {
    Entry_Xmax configure -state disabled
    Entry_Max_divx configure -state disabled
    Entry_Min_divx configure -state disabled
    Entry_Ymax configure -state disabled
    Entry_Max_divy configure -state disabled
    Entry_Min_divy configure -state disabled
} else {
    Entry_Xmax configure -state normal
    Entry_Max_divx configure -state normal
    Entry_Min_divx configure -state normal
    Entry_Ymax configure -state normal
    Entry_Max_divy configure -state normal
    Entry_Min_divy configure -state normal
}} \
        -variable AutoEscala -width 26 
    vTcl:DefineAlias "$site_3_0.che61" "Checkbutton_AutoScala" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd63 \
        -text {Auto Escala } 
    vTcl:DefineAlias "$site_3_0.cpd63" "Label_AutoScala" vTcl:WidgetProc "DrDaq" 1
    place $site_3_0.ent90 \
        -in $site_3_0 -x 57 -y 30 -width 40 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.lab91 \
        -in $site_3_0 -x 12 -y 33 -width 42 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd92 \
        -in $site_3_0 -x 12 -y 62 -width 43 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd93 \
        -in $site_3_0 -x 57 -y 60 -width 40 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd94 \
        -in $site_3_0 -x 124 -y 33 -width 72 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd95 \
        -in $site_3_0 -x 264 -y 32 -width 73 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd96 \
        -in $site_3_0 -x 122 -y 62 -width 76 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd97 \
        -in $site_3_0 -x 261 -y 63 -width 77 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd98 \
        -in $site_3_0 -x 199 -y 31 -width 40 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd99 \
        -in $site_3_0 -x 200 -y 60 -width 40 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd100 \
        -in $site_3_0 -x 342 -y 32 -width 40 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd101 \
        -in $site_3_0 -x 343 -y 60 -width 40 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.che61 \
        -in $site_3_0 -x 54 -y 5 -width 26 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd63 \
        -in $site_3_0 -x 75 -y 7 -width 73 -height 20 -anchor nw \
        -bordermode ignore 
    frame $top.fra102 \
        -borderwidth 2 -relief groove -height 150 -width 185 
    vTcl:DefineAlias "$top.fra102" "Frame_Canal2" vTcl:WidgetProc "DrDaq" 1
    set site_3_0 $top.fra102
    label $site_3_0.lab61 \
        -text Modo: 
    vTcl:DefineAlias "$site_3_0.lab61" "Label_Modo2" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd62 \
        -text Conector: 
    vTcl:DefineAlias "$site_3_0.cpd62" "Label_Conector2" vTcl:WidgetProc "DrDaq" 1
    radiobutton $site_3_0.cpd67 \
        -command {set Sensor2 1} -text Int -value Interno -variable Conector2 
    vTcl:DefineAlias "$site_3_0.cpd67" "Radiobutton_Interno2" vTcl:WidgetProc "DrDaq" 1
    radiobutton $site_3_0.cpd68 \
        \
        -command {set Sensor2 1
if {$Conector1 ne "Interno"} {
    set Conector1 Ext2
}} \
        -text {Ext 1} -value Ext1 -variable Conector2 
    vTcl:DefineAlias "$site_3_0.cpd68" "Radiobutton_Ext1_2" vTcl:WidgetProc "DrDaq" 1
    radiobutton $site_3_0.cpd69 \
        \
        -command {set Sensor2 1
if {$Conector1 ne "Interno"} {
    set Conector1 Ext1
}} \
        -text {Ext 2} -value Ext2 -variable Conector2 
    vTcl:DefineAlias "$site_3_0.cpd69" "Radiobutton_Ext2_2" vTcl:WidgetProc "DrDaq" 1
    canvas $site_3_0.can70 \
        -borderwidth 2 -closeenough 1.0 -height 9 -insertbackground black \
        -relief groove -selectbackground #c4c4c4 -selectforeground black \
        -width 140 
    vTcl:DefineAlias "$site_3_0.can70" "Canvas3" vTcl:WidgetProc "DrDaq" 1
    spinbox $site_3_0.spi64 \
        -activebackground #f9f9f9 -background #ffffff \
        -command {set Sensor2 1} -foreground black -from 0.0 \
        -highlightcolor black -increment 1.0 -insertbackground black \
        -justify center -selectbackground #c4c4c4 -selectforeground black \
        -state readonly -textvariable Modo2 -to 0.0 \
        -values {"Onda Sonora" "Nivel Sonoro" Voltagem Resistencia pH Temperatura  Luz} 
    vTcl:DefineAlias "$site_3_0.spi64" "Spinbox_Modo2" vTcl:WidgetProc "DrDaq" 1
    place $site_3_0.lab61 \
        -in $site_3_0 -x 77 -y 11 -width 42 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd62 \
        -in $site_3_0 -x 68 -y 87 -width 63 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd67 \
        -in $site_3_0 -x 7 -y 113 -width 46 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd68 \
        -in $site_3_0 -x 63 -y 113 -width 60 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd69 \
        -in $site_3_0 -x 127 -y 113 -width 60 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.can70 \
        -in $site_3_0 -x 25 -y 70 -width 150 -height 9 -anchor nw \
        -bordermode ignore 
    place $site_3_0.spi64 \
        -in $site_3_0 -x 53 -y 35 -width 99 -height 22 -anchor nw \
        -bordermode ignore 
    checkbutton $top.cpd103 \
        -variable Sensor2 
    vTcl:DefineAlias "$top.cpd103" "Checkbutton_Sensor2" vTcl:WidgetProc "DrDaq" 1
    label $top.cpd104 \
        -text {Sensor 2:} 
    vTcl:DefineAlias "$top.cpd104" "Label_Sensor2" vTcl:WidgetProc "DrDaq" 1
    frame $top.fra70 \
        -borderwidth 2 -relief groove -height 85 -width 405 
    vTcl:DefineAlias "$top.fra70" "Frame_Passo" vTcl:WidgetProc "DrDaq" 1
    set site_3_0 $top.fra70
    scale $site_3_0.cpd74 \
        -bigincrement 0.0 -from 0.0 -orient horizontal -resolution 1.0 \
        -tickinterval 0.0 -to 5000.0 -variable ncont 
    vTcl:DefineAlias "$site_3_0.cpd74" "Scale_Contagem" vTcl:WidgetProc "DrDaq" 1
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
        \
        -command {Entry_Tempo configure -state normal
Entry_TMax configure -state normal
Scale_Contagem configure -state disabled} \
        -text Intervalo: -value Tempo -variable Passo 
    vTcl:DefineAlias "$site_3_0.rad64" "Radiobutton_Passo_Tempo" vTcl:WidgetProc "DrDaq" 1
    radiobutton $site_3_0.cpd65 \
        \
        -command {Scale_Contagem configure -state normal
#Entry_Tempo configure -state disabled
Entry_TMax configure -state disabled} \
        -text Contagens: -value Contagem -variable Passo 
    vTcl:DefineAlias "$site_3_0.cpd65" "Radiobutton_Passo_Contagens" vTcl:WidgetProc "DrDaq" 1
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
        -text Max: 
    vTcl:DefineAlias "$site_3_0.cpd68" "Label_TMax" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.lab60 \
        -background #cccccc \
        -font [vTcl:font:getFontFromDescr "-family avantgarde -size 18 -weight normal -slant roman -underline 0 -overstrike 0"] \
        -justify center -relief groove -text 0.00 
    vTcl:DefineAlias "$site_3_0.lab60" "Cronometro" vTcl:WidgetProc "DrDaq" 1
    place $site_3_0.cpd74 \
        -in $site_3_0 -x 103 -y 35 -width 176 -height 33 -anchor nw \
        -bordermode ignore 
    place $site_3_0.ent76 \
        -in $site_3_0 -x 97 -y 15 -width 38 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.lab80 \
        -in $site_3_0 -x 137 -y 16 -width 25 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.rad64 \
        -in $site_3_0 -x 9 -y 15 -width 86 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd65 \
        -in $site_3_0 -x 13 -y 50 -width 88 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd66 \
        -in $site_3_0 -x 210 -y 15 -width 38 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd67 \
        -in $site_3_0 -x 250 -y 16 -width 25 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd68 \
        -in $site_3_0 -x 171 -y 17 -width 35 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.lab60 \
        -in $site_3_0 -x 294 -y 18 -width 92 -height 45 -anchor nw \
        -bordermode ignore 
    menu $top.m71 \
        -tearoff 1 
    $top.m71 add cascade \
        -menu "$top.m71.men63" -command {} -compound none -label Arquivo 
    set site_3_0 $top.m71
    menu $site_3_0.men63 \
        -tearoff 0 
    $site_3_0.men63 add command \
        -accelerator {} -command {if {($graf != 0)} {
    SalvarArquivo 0
}} \
        -label {Salvar S0 Como...} -state normal 
    $site_3_0.men63 add command \
        -accelerator {} -command {if {($graf != 0)} {
    SalvarArquivo 1
}} \
        -label {Salvar S1 Como...} -state normal 
    button $top.cpd83 \
        -command exit -text Sair 
    vTcl:DefineAlias "$top.cpd83" "Sair" vTcl:WidgetProc "DrDaq" 1
    button $top.cpd60 \
        \
        -command {Parar configure -state disabled
Iniciar configure -state normal
set stopped 1
hitStop} \
        -text Parar 
    vTcl:DefineAlias "$top.cpd60" "Parar" vTcl:WidgetProc "DrDaq" 1
    label $top.cpd70 \
        -activebackground #f9f9f9 -background #cccccc -justify center \
        -relief groove -text 0..00 
    vTcl:DefineAlias "$top.cpd70" "Medidor1" vTcl:WidgetProc "DrDaq" 1
    label $top.cpd71 \
        -background #cccccc -justify center -relief groove -text 0.00 
    vTcl:DefineAlias "$top.cpd71" "Medidor2" vTcl:WidgetProc "DrDaq" 1
    ###################
    # SETTING GEOMETRY
    ###################
    place $top.fra62 \
        -in $top -x 30 -y 45 -width 200 -height 155 -anchor nw \
        -bordermode ignore 
    place $top.lab63 \
        -in $top -x 62 -y 20 -width 63 -height 20 -anchor nw \
        -bordermode ignore 
    place $top.lab63.che66 \
        -in $top.lab63 -x 120 -y 75 -anchor nw -bordermode ignore 
    place $top.che65 \
        -in $top -x 40 -y 18 -width 26 -height 22 -anchor nw \
        -bordermode ignore 
    place $top.but87 \
        -in $top -x 205 -y 405 -width 72 -height 41 -anchor nw \
        -bordermode ignore 
    place $top.fra88 \
        -in $top -x 30 -y 295 -width 405 -height 100 -anchor nw \
        -bordermode ignore 
    place $top.fra102 \
        -in $top -x 235 -y 45 -width 200 -height 155 -anchor nw \
        -bordermode ignore 
    place $top.cpd103 \
        -in $top -x 250 -y 18 -width 26 -height 22 -anchor nw \
        -bordermode ignore 
    place $top.cpd104 \
        -in $top -x 271 -y 20 -width 64 -height 20 -anchor nw \
        -bordermode ignore 
    place $top.fra70 \
        -in $top -x 30 -y 205 -width 405 -height 85 -anchor nw \
        -bordermode ignore 
    place $top.cpd83 \
        -in $top -x 400 -y 411 -width 34 -height 28 -anchor nw \
        -bordermode ignore 
    place $top.cpd60 \
        -in $top -x 310 -y 410 -width 62 -height 28 -anchor nw \
        -bordermode ignore 
    place $top.cpd70 \
        -in $top -x 145 -y 10 -width 62 -height 30 -anchor nw \
        -bordermode inside 
    place $top.cpd71 \
        -in $top -x 350 -y 10 -width 62 -height 30 -anchor nw \
        -bordermode inside 

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

Window show .
Window show .drdaqgrace

main $argc $argv
