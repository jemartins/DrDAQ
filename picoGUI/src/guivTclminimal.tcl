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
    set site_3_0 $base.fra62
    set site_3_0 $base.fra102
    set site_3_0 $base.fra70
    set base .top52
    namespace eval ::widgets::$base {
        set set,origin 1
        set set,size 1
        set runvisible 0
    }
    set base .top53
    namespace eval ::widgets::$base {
        set set,origin 1
        set set,size 1
        set runvisible 0
    }
    namespace eval ::widgets_bindings {
        set tagslist _TopLevel
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
Calibrar1 configure -state disabled
Calibrar2 configure -state disabled
Calib12 configure -state disabled
Calib22 configure -state disabled

Entry_Angulo12 configure -state disabled
Entry_Angulo22 configure -state disabled

#Entry_Xmax configure -state disabled
#Entry_Max_divx configure -state disabled
#Entry_Min_divx configure -state disabled
#Entry_Ymax configure -state disabled
#Entry_Max_divy configure -state disabled
#Entry_Min_divy configure -state disabled
}
#############################################################################
## Procedure:  QualSensor

proc ::QualSensor {} {
global Sensor1 Sensor2 Modo1 Modo2 Conector1 Conector2
global widget nsensores set_value1 set_value2 nmodo1 nmodo2
#global AutoEscala xmax ymax ymin maior_divx menor_divx maior_divy menor_divy

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
    } elseif {($Modo1 == "Pendulo")} {
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
        } elseif {($Modo1 == "Pendulo")} {
            set set_value1 4
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
    } elseif {($Modo2 == "Pendulo")} {
        set nmodo2 8
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
        } elseif {($Modo2 == "Pendulo")} {
            set set_value2 4
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

#if { $AutoEscala == 1 } {
#    set xmax 10 
#    set ymax 10
#    set ymin 0
#    set maior_divx 10
#    set menor_divx 1
#    set maior_divy 10
#    set menor_divy 1
#}
}
#############################################################################
## Procedure:  ValidarEntradas

proc ::ValidarEntradas {} {
global widget Entradas Sensor1 Sensor2 Conector1 Conector2 Passo AutoEscala
global Delta_T TMax ncont xmax ymax ymin maior_divx maior_divy menor_divx menor_divy
global XY

set w .drdaqgrace

if {($Sensor1 == 0) && ($Sensor2 == 0)} {
    showMessageBox $w "um Sensor"
} elseif {(($Conector1 == "") && ($Sensor1 == 1)) || (($Conector2 == "") && ($Sensor2 == 1))} {
    showMessageBox $w "Conector"
} elseif {$Passo == ""} {
    showMessageBox $w "Intervalo ou Leituras"
} elseif {($Passo == "Tempo") && (($Delta_T == "") || ($TMax == "") || ($Delta_T <= 0) ||  ($TMax < 0) || ($Delta_T > $TMax))} {

    if {($Delta_T == "")} {
        showMessageBox $w "Intervalo de Tempo"
    } elseif {$TMax == ""} {
        showMessageBox $w "o Valor Max do Tempo"
    } elseif {$Delta_T <= 0} {
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
if {($XY == 1)} {
if {(($Sensor1 == 1) && ($Sensor2 == 0)) || (($Sensor1 == 0) && ($Sensor2 == 1))} {
	showMessageBox $w "os dois sensores, no modo XY"
}
}
}
#############################################################################
## Procedure:  showMessageBox

proc ::showMessageBox {w erro} {
global widget Entradas

set Entradas 0

tk_messageBox -icon info -message "Você Precisa Selecionar \"$erro\"" -type ok -parent $w
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
    wm maxsize $top 1585 870
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
        -menu "$top.m71" -background {#e6e7e6} -highlightbackground {#e6e7e6} \
        -highlightcolor black 
    wm focusmodel $top passive
    wm geometry $top 461x353+525+29; update
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
        -borderwidth 2 -relief groove -background {#d7d7d7} -height 155 \
        -highlightbackground {#d7d7d7} -highlightcolor black -width 200 
    vTcl:DefineAlias "$top.fra62" "Frame_Canal1" vTcl:WidgetProc "DrDaq" 1
    set site_3_0 $top.fra62
    radiobutton $site_3_0.cpd73 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d7d7d7} \
        -command {set Sensor1 1

if {($Modo1 == "Pendulo") && ($Conector1 != "")} {
    Calibrar1 configure -state normal
}} \
        -foreground black -highlightbackground {#d7d7d7} \
        -highlightcolor black -text Int -value Interno -variable Conector1 
    vTcl:DefineAlias "$site_3_0.cpd73" "Radiobutton_Interno1" vTcl:WidgetProc "DrDaq" 1
    radiobutton $site_3_0.cpd74 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d7d7d7} \
        -command {set Sensor1 1

if {$Conector2 ne "Interno"} {
    set Conector2 Ext2
}

if {($Modo1 == "Pendulo") && ($Conector1 != "")} {
    Calibrar1 configure -state normal
}} \
        -foreground black -highlightbackground {#d7d7d7} \
        -highlightcolor black -text {Ext 1} -value Ext1 -variable Conector1 
    vTcl:DefineAlias "$site_3_0.cpd74" "Radiobutton_Ext1_1" vTcl:WidgetProc "DrDaq" 1
    radiobutton $site_3_0.cpd75 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d7d7d7} \
        -command {set Sensor1 1

if {$Conector2 ne "Interno"} {
    set Conector2 Ext1
}

if {($Modo1 == "Pendulo") && ($Conector1 != "")} {
    Calibrar1 configure -state normal
}} \
        -foreground black -highlightbackground {#d7d7d7} \
        -highlightcolor black -text {Ext 2} -value Ext2 -variable Conector1 
    vTcl:DefineAlias "$site_3_0.cpd75" "Radiobutton_Ext2_1" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.lab78 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d7d7d7} -foreground black \
        -highlightbackground {#d7d7d7} -highlightcolor black -text Tipo: 
    vTcl:DefineAlias "$site_3_0.lab78" "Label_Modo1" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd79 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d7d7d7} -foreground black \
        -highlightbackground {#d7d7d7} -highlightcolor black -text Conector: 
    vTcl:DefineAlias "$site_3_0.cpd79" "Label_Conector1" vTcl:WidgetProc "DrDaq" 1
    canvas $site_3_0.can68 \
        -background {#d7d7d7} -borderwidth 2 -closeenough 1.0 -height 9 \
        -highlightbackground {#ffffff} -highlightcolor black \
        -insertbackground black -relief groove -selectbackground {#c4c4c4} \
        -selectforeground black -width 150 
    vTcl:DefineAlias "$site_3_0.can68" "Canvas1" vTcl:WidgetProc "DrDaq" 1
    spinbox $site_3_0.spi63 \
        -activebackground {#ffffff} -background {#d7d7d7} \
        -buttonbackground {#d7d7d7} \
        -command {set Sensor1 1

if {($Modo1 == "Pendulo") && ($Conector1 != "")} {
    Calibrar1 configure -state normal
} else {
    Calibrar1 configure -state disabled
    Window hide .top52
}} \
        -foreground black -from 0.0 -highlightcolor black -increment 1.0 \
        -insertbackground black -justify center -selectbackground {#c4c4c4} \
        -selectforeground black -state readonly -textvariable Modo1 -to 0.0 \
        -values {"Onda Sonora" "Nivel Sonoro" Voltagem Resistencia pH Temperatura  Luz Pendulo} 
    vTcl:DefineAlias "$site_3_0.spi63" "Spinbox_Modo1" vTcl:WidgetProc "DrDaq" 1
    button $site_3_0.but47 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#e6e7e6} \
        -command {
				      Window show .top52
				      focus .top52
				      Calib11 configure -state normal 
    				      Calib12 configure -state disabled 
    				      Entry_Angulo11 configure -state normal
    				      Entry_Angulo12 configure -state disabled 
				     } \
        -foreground black -highlightbackground {#d7d7d7} \
        -highlightcolor black -state disabled -text calibrar 
    vTcl:DefineAlias "$site_3_0.but47" "Calibrar1" vTcl:WidgetProc "DrDaq" 1
    place $site_3_0.cpd73 \
        -in $site_3_0 -x 7 -y 93 -width 47 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd74 \
        -in $site_3_0 -x 63 -y 93 -width 60 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd75 \
        -in $site_3_0 -x 127 -y 93 -width 60 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.lab78 \
        -in $site_3_0 -x 77 -y 6 -width 42 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd79 \
        -in $site_3_0 -x 68 -y 72 -width 63 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.can68 \
        -in $site_3_0 -x 25 -y 60 -width 150 -height 9 -anchor nw \
        -bordermode ignore 
    place $site_3_0.spi63 \
        -in $site_3_0 -x 53 -y 30 -width 99 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.but47 \
        -in $site_3_0 -x 65 -y 117 -width 72 -height 28 -anchor nw \
        -bordermode ignore 
    label $top.lab63 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#e6e7e6} -foreground black \
        -highlightbackground {#d7d7d7} -highlightcolor black -text {Sensor 1} 
    vTcl:DefineAlias "$top.lab63" "Label_Sensor1" vTcl:WidgetProc "DrDaq" 1
    checkbutton $top.lab63.che66 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#e6e7e6} -disabledforeground {#a1a1a1} -foreground black \
        -highlightbackground {#e6e7e6} -highlightcolor black -text check \
        -variable "$top\::che66" 
    vTcl:DefineAlias "$top.lab63.che66" "Checkbutton2" vTcl:WidgetProc "DrDaq" 1
    checkbutton $top.che65 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#e6e7e6} -foreground black \
        -highlightbackground {#d7d7d7} -highlightcolor black \
        -variable Sensor1 
    vTcl:DefineAlias "$top.che65" "Checkbutton_Sensor1" vTcl:WidgetProc "DrDaq" 1
    button $top.but87 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#e6e7e6} \
        -command {set Entradas 1

ValidarEntradas

if {$Entradas} {
    Parar configure -state normal
    Iniciar configure -state disabled
    set stopped 1
    QualSensor
    hitStart    
}} \
        -foreground black -highlightbackground {#d7d7d7} \
        -highlightcolor black -text Iniciar 
    vTcl:DefineAlias "$top.but87" "Iniciar" vTcl:WidgetProc "DrDaq" 1
    frame $top.fra102 \
        -borderwidth 2 -relief groove -background {#d7d7d7} -height 150 \
        -highlightbackground {#d7d7d7} -highlightcolor black -width 185 
    vTcl:DefineAlias "$top.fra102" "Frame_Canal2" vTcl:WidgetProc "DrDaq" 1
    set site_3_0 $top.fra102
    label $site_3_0.lab61 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d7d7d7} -foreground black \
        -highlightbackground {#d7d7d7} -highlightcolor black -text Tipo: 
    vTcl:DefineAlias "$site_3_0.lab61" "Label_Modo2" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd62 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d7d7d7} -foreground black \
        -highlightbackground {#d7d7d7} -highlightcolor black -text Conector: 
    vTcl:DefineAlias "$site_3_0.cpd62" "Label_Conector2" vTcl:WidgetProc "DrDaq" 1
    radiobutton $site_3_0.cpd67 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d7d7d7} \
        -command {set Sensor2 1

if {($Modo2 == "Pendulo") && ($Conector2 != "")} {
    Calibrar2 configure -state normal
}} \
        -foreground black -highlightbackground {#d7d7d7} \
        -highlightcolor black -text Int -value Interno -variable Conector2 
    vTcl:DefineAlias "$site_3_0.cpd67" "Radiobutton_Interno2" vTcl:WidgetProc "DrDaq" 1
    radiobutton $site_3_0.cpd68 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d7d7d7} \
        -command {set Sensor2 1

if {$Conector1 ne "Interno"} {
    set Conector1 Ext2
}

if {($Modo2 == "Pendulo") && ($Conector2 != "")} {
    Calibrar2 configure -state normal
}} \
        -foreground black -highlightbackground {#d7d7d7} \
        -highlightcolor black -text {Ext 1} -value Ext1 -variable Conector2 
    vTcl:DefineAlias "$site_3_0.cpd68" "Radiobutton_Ext1_2" vTcl:WidgetProc "DrDaq" 1
    radiobutton $site_3_0.cpd69 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d7d7d7} \
        -command {set Sensor2 1

if {$Conector1 ne "Interno"} {
    set Conector1 Ext1
}

if {($Modo2 == "Pendulo") && ($Conector2 != "")} {
    Calibrar2 configure -state normal
}} \
        -foreground black -highlightbackground {#d7d7d7} \
        -highlightcolor black -text {Ext 2} -value Ext2 -variable Conector2 
    vTcl:DefineAlias "$site_3_0.cpd69" "Radiobutton_Ext2_2" vTcl:WidgetProc "DrDaq" 1
    canvas $site_3_0.can70 \
        -background {#d7d7d7} -borderwidth 2 -closeenough 1.0 -height 9 \
        -highlightbackground {#ffffff} -highlightcolor black \
        -insertbackground black -relief groove -selectbackground {#c4c4c4} \
        -selectforeground black -width 140 
    vTcl:DefineAlias "$site_3_0.can70" "Canvas3" vTcl:WidgetProc "DrDaq" 1
    spinbox $site_3_0.spi64 \
        -activebackground {#f9f9f9} -background {#d7d7d7} \
        -buttonbackground {#d7d7d7} \
        -command {set Sensor2 1


if {($Modo2 == "Pendulo") && ($Conector2 != "")} {
    Calibrar2 configure -state normal
} else {
    Calibrar2 configure -state disabled
    Window hide .top53
}} \
        -foreground black -from 0.0 -highlightcolor black -increment 1.0 \
        -insertbackground black -justify center -selectbackground {#c4c4c4} \
        -selectforeground black -state readonly -textvariable Modo2 -to 0.0 \
        -values {"Onda Sonora" "Nivel Sonoro" Voltagem Resistencia pH Temperatura  Luz Pendulo} 
    vTcl:DefineAlias "$site_3_0.spi64" "Spinbox_Modo2" vTcl:WidgetProc "DrDaq" 1
    button $site_3_0.but48 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#e6e7e6} \
        -command {
				      Window show .top53
				      focus .top53
				      Calib21 configure -state normal 
    				      Calib22 configure -state disabled 
    				      Entry_Angulo21 configure -state normal
    				      Entry_Angulo22 configure -state disabled 
				      } \
        -foreground black -highlightbackground {#d7d7d7} \
        -highlightcolor black -state disabled -text calibrar 
    vTcl:DefineAlias "$site_3_0.but48" "Calibrar2" vTcl:WidgetProc "DrDaq" 1
    checkbutton $site_3_0.cpd43 \
        -activebackground {#d7d7d7} -activeforeground {#353535} \
        -background {#d7d7d7} -command {set Sensor1 1
set Sensor2 1} \
        -foreground {#353535} -highlightbackground {#d7d7d7} \
        -highlightcolor {#353535} -text XY -variable XY 
    vTcl:DefineAlias "$site_3_0.cpd43" "Checkbutton_XY" vTcl:WidgetProc "DrDaq" 1
    place $site_3_0.lab61 \
        -in $site_3_0 -x 77 -y 6 -width 42 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd62 \
        -in $site_3_0 -x 68 -y 72 -width 63 -height 20 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd67 \
        -in $site_3_0 -x 7 -y 93 -width 46 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd68 \
        -in $site_3_0 -x 63 -y 93 -width 60 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd69 \
        -in $site_3_0 -x 127 -y 93 -width 60 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.can70 \
        -in $site_3_0 -x 25 -y 60 -width 150 -height 9 -anchor nw \
        -bordermode ignore 
    place $site_3_0.spi64 \
        -in $site_3_0 -x 53 -y 30 -width 99 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.but48 \
        -in $site_3_0 -x 65 -y 117 -width 72 -height 28 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd43 \
        -in $site_3_0 -x 4 -y 5 -width 42 -height 22 -anchor nw \
        -bordermode ignore 
    checkbutton $top.cpd103 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#e6e7e6} -foreground black \
        -highlightbackground {#d7d7d7} -highlightcolor black \
        -variable Sensor2 
    vTcl:DefineAlias "$top.cpd103" "Checkbutton_Sensor2" vTcl:WidgetProc "DrDaq" 1
    label $top.cpd104 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#e6e7e6} -foreground black \
        -highlightbackground {#d7d7d7} -highlightcolor black -text {Sensor 2} 
    vTcl:DefineAlias "$top.cpd104" "Label_Sensor2" vTcl:WidgetProc "DrDaq" 1
    frame $top.fra70 \
        -borderwidth 2 -relief groove -background {#d7d7d7} -height 85 \
        -highlightbackground {#d7d7d7} -highlightcolor black -width 405 
    vTcl:DefineAlias "$top.fra70" "Frame_Passo" vTcl:WidgetProc "DrDaq" 1
    set site_3_0 $top.fra70
    entry $site_3_0.ent76 \
        -background white -foreground black -highlightbackground {#ffffff} \
        -highlightcolor black -insertbackground black -invalidcommand bell \
        -justify right -selectbackground {#c4c4c4} -selectforeground black \
        -textvariable Delta_T -validate all \
        -validatecommand {vTcl:DoCmdOption .drdaqgrace.fra70.ent76 {string is double %P}} 
    vTcl:DefineAlias "$site_3_0.ent76" "Entry_Tempo" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.lab80 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d7d7d7} -foreground black \
        -highlightbackground {#d7d7d7} -highlightcolor black -text (s) 
    vTcl:DefineAlias "$site_3_0.lab80" "Label_Seg" vTcl:WidgetProc "DrDaq" 1
    radiobutton $site_3_0.rad64 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d7d7d7} \
        -command {Entry_Tempo configure -state normal
Entry_TMax configure -state normal
Entry_Cont configure -state disabled} \
        -foreground black -highlightbackground {#d7d7d7} \
        -highlightcolor black -text Intervalo: -value Tempo -variable Passo 
    vTcl:DefineAlias "$site_3_0.rad64" "Radiobutton_Passo_Tempo" vTcl:WidgetProc "DrDaq" 1
    radiobutton $site_3_0.cpd65 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d7d7d7} \
        -command {Entry_Cont configure -state normal
#Entry_Tempo configure -state disabled
Entry_TMax configure -state disabled} \
        -foreground black -highlightbackground {#d7d7d7} \
        -highlightcolor black -text Leituras: -value Leituras -variable Passo 
    vTcl:DefineAlias "$site_3_0.cpd65" "Radiobutton_Passo_Contagens" vTcl:WidgetProc "DrDaq" 1
    entry $site_3_0.cpd66 \
        -background white -foreground black -highlightbackground {#ffffff} \
        -highlightcolor black -insertbackground black -invalidcommand bell \
        -justify right -selectbackground {#c4c4c4} -selectforeground black \
        -textvariable TMax -validate all \
        -validatecommand {vTcl:DoCmdOption .drdaqgrace.fra70.cpd66 {string is double %P}} 
    vTcl:DefineAlias "$site_3_0.cpd66" "Entry_TMax" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd67 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d7d7d7} -foreground black \
        -highlightbackground {#d7d7d7} -highlightcolor black -text (s) 
    vTcl:DefineAlias "$site_3_0.cpd67" "Label_Seg1" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd68 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d7d7d7} -foreground black \
        -highlightbackground {#d7d7d7} -highlightcolor black -text Max: 
    vTcl:DefineAlias "$site_3_0.cpd68" "Label_TMax" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.lab60 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#cccccc} \
        -font [vTcl:font:getFontFromDescr "-family avantgarde -size 18 -weight normal -slant roman -underline 0 -overstrike 0"] \
        -foreground black -highlightbackground {#d7d7d7} \
        -highlightcolor black -relief groove -text 0.00 
    vTcl:DefineAlias "$site_3_0.lab60" "Cronometro" vTcl:WidgetProc "DrDaq" 1
    entry $site_3_0.cpd60 \
        -background white -foreground black -highlightbackground {#ffffff} \
        -highlightcolor black -insertbackground black -invalidcommand bell \
        -justify right -selectbackground {#c4c4c4} -selectforeground black \
        -textvariable ncont -validate all \
        -validatecommand {vTcl:DoCmdOption .drdaqgrace.fra70.cpd60 {string is integer %P}} 
    vTcl:DefineAlias "$site_3_0.cpd60" "Entry_Cont" vTcl:WidgetProc "DrDaq" 1
    checkbutton $site_3_0.cpd61 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d7d7d7} \
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
        -foreground black -highlightbackground {#d7d7d7} \
        -highlightcolor black -variable AutoEscala -width 23 
    vTcl:DefineAlias "$site_3_0.cpd61" "Checkbutton_AutoScala1" vTcl:WidgetProc "DrDaq" 1
    label $site_3_0.cpd62 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d7d7d7} -foreground black \
        -highlightbackground {#d7d7d7} -highlightcolor black \
        -text {Auto Escala } 
    vTcl:DefineAlias "$site_3_0.cpd62" "Label_AutoScala1" vTcl:WidgetProc "DrDaq" 1
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
        -in $site_3_0 -x 7 -y 50 -width 88 -height 22 -anchor nw \
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
    place $site_3_0.cpd60 \
        -in $site_3_0 -x 97 -y 49 -width 38 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd61 \
        -in $site_3_0 -x 165 -y 50 -width 23 -height 22 -anchor nw \
        -bordermode ignore 
    place $site_3_0.cpd62 \
        -in $site_3_0 -x 195 -y 52 -width 90 -height 20 -anchor nw \
        -bordermode ignore 
    menu $top.m71 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d7d7d7} -cursor {} -foreground black 
    button $top.cpd83 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#e6e7e6} -command exit -foreground black \
        -highlightbackground {#d7d7d7} -highlightcolor black -text Sair 
    vTcl:DefineAlias "$top.cpd83" "Sair" vTcl:WidgetProc "DrDaq" 1
    button $top.cpd60 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#e6e7e6} \
        -command {Parar configure -state disabled
Iniciar configure -state normal
set stopped 1
hitStop} \
        -foreground black -highlightbackground {#d7d7d7} \
        -highlightcolor black -state disabled -text Parar 
    vTcl:DefineAlias "$top.cpd60" "Parar" vTcl:WidgetProc "DrDaq" 1
    label $top.cpd70 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#cccccc} -foreground black \
        -highlightbackground {#d7d7d7} -highlightcolor black -relief groove \
        -text 0.00 
    vTcl:DefineAlias "$top.cpd70" "Medidor1" vTcl:WidgetProc "DrDaq" 1
    label $top.cpd71 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#cccccc} -foreground black \
        -highlightbackground {#d7d7d7} -highlightcolor black -relief groove \
        -text 0.00 
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
        -in $top -x 31 -y 18 -width 26 -height 22 -anchor nw \
        -bordermode ignore 
    place $top.but87 \
        -in $top -x 205 -y 300 -width 72 -height 41 -anchor nw \
        -bordermode ignore 
    place $top.fra102 \
        -in $top -x 235 -y 45 -width 200 -height 155 -anchor nw \
        -bordermode ignore 
    place $top.cpd103 \
        -in $top -x 238 -y 18 -width 26 -height 22 -anchor nw \
        -bordermode ignore 
    place $top.cpd104 \
        -in $top -x 271 -y 20 -width 64 -height 20 -anchor nw \
        -bordermode ignore 
    place $top.fra70 \
        -in $top -x 30 -y 205 -width 405 -height 85 -anchor nw \
        -bordermode ignore 
    place $top.cpd83 \
        -in $top -x 400 -y 306 -width 34 -height 28 -anchor nw \
        -bordermode ignore 
    place $top.cpd60 \
        -in $top -x 310 -y 306 -width 62 -height 28 -anchor nw \
        -bordermode ignore 
    place $top.cpd70 \
        -in $top -x 145 -y 10 -width 62 -height 30 -anchor nw \
        -bordermode inside 
    place $top.cpd71 \
        -in $top -x 350 -y 10 -width 62 -height 30 -anchor nw \
        -bordermode inside 

    vTcl:FireEvent $base <<Ready>>
}

proc vTclWindow.top52 {base} {
    if {$base == ""} {
        set base .top52
    }
    if {[winfo exists $base]} {
        wm deiconify $base; return
    }
    set top $base
    ###################
    # CREATING WIDGETS
    ###################
    vTcl:toplevel $top -class Toplevel \
        -background {#eff3f7} -highlightbackground {#eff3f7} \
        -highlightcolor black 
    wm withdraw $top
    wm focusmodel $top passive
    wm geometry $top 220x150+509+70; update
    wm maxsize $top 1009 738
    wm minsize $top 1 1
    wm overrideredirect $top 0
    wm resizable $top 1 1
    wm title $top "Calibrar Sensor 1"
    vTcl:DefineAlias "$top" "PopUp1" vTcl:Toplevel:WidgetProc "" 1
    bindtags $top "$top Toplevel all _TopLevel"
    vTcl:FireEvent $top <<Create>>
    wm protocol $top WM_DELETE_WINDOW "vTcl:FireEvent $top <<DeleteWindow>>"

    button $top.but54 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d7d7d7} -command {Window hide .top52} -foreground black \
        -highlightbackground {#d7d7d7} -highlightcolor black -text Fechar 
    vTcl:DefineAlias "$top.but54" "OK1" vTcl:WidgetProc "PopUp1" 1
    button $top.but54.but55 \
        -activebackground {#eff3f7} -activeforeground black \
        -background {#eff3f7} -foreground black \
        -highlightbackground {#eff3f7} -highlightcolor black -text button 
    vTcl:DefineAlias "$top.but54.but55" "Button2" vTcl:WidgetProc "PopUp1" 1
    entry $top.cpd47 \
        -background white -foreground black -highlightbackground {#ffffff} \
        -highlightcolor black -insertbackground black -invalidcommand bell \
        -justify right -selectbackground {#c4c4c4} -selectforeground black \
        -textvariable angulo11 -validate all \
        -validatecommand {vTcl:DoCmdOption .drdaqgrace.fra70.ent76 {string is double %P}} 
    vTcl:DefineAlias "$top.cpd47" "Entry_Angulo11" vTcl:WidgetProc "PopUp1" 1
    entry $top.cpd48 \
        -background white -foreground black -highlightbackground {#ffffff} \
        -highlightcolor black -insertbackground black -invalidcommand bell \
        -justify right -selectbackground {#c4c4c4} -selectforeground black \
        -state disabled -textvariable angulo12 -validate all \
        -validatecommand {vTcl:DoCmdOption .drdaqgrace.fra70.ent76 {string is double %P}} 
    vTcl:DefineAlias "$top.cpd48" "Entry_Angulo12" vTcl:WidgetProc "PopUp1" 1
    button $top.cpd49 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d7d7d7} \
        -command {if {($Conector1 == "Interno")} {
    set set_value 4
} elseif {($Conector1 == "Ext1")} {
    set set_value 5
} elseif {($Conector1 == "Ext2")} {
    set set_value 10
}

set w .drdaqgrace

if {($angulo11 == "")} { 
    showMessageBox $w "o Valor do Ângulo"
} else { 

    Calib11 configure -state disabled
    Calib12 configure -state normal
    Entry_Angulo11 configure -state disabled
    Entry_Angulo12 configure -state normal
    
    hitCalibrate 0 $angulo11 0 $set_value
}} \
        -foreground black -highlightbackground {#d7d7d7} \
        -highlightcolor black -text OK 
    vTcl:DefineAlias "$top.cpd49" "Calib11" vTcl:WidgetProc "PopUp1" 1
    button $top.cpd50 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d7d7d7} \
        -command {if {($Conector1 == "Interno")} {
    set set_value 4
} elseif {($Conector1 == "Ext1")} {
    set set_value 5
} elseif {($Conector1 == "Ext2")} {
    set set_value 10
}

set w .drdaqgrace

if {($angulo12 == "")} { 
    showMessageBox $w "o Valor do Ângulo"
} else { 

    #Calib11 configure -state normal
    Calib12 configure -state disabled
    #Entry_Angulo11 configure -state normal
    Entry_Angulo12 configure -state disabled

    hitCalibrate 1 $angulo12 0 $set_value

    Window hide .top52

}} \
        -foreground black -highlightbackground {#d7d7d7} \
        -highlightcolor black -state disabled -text OK 
    vTcl:DefineAlias "$top.cpd50" "Calib12" vTcl:WidgetProc "PopUp1" 1
    label $top.lab47 \
        -activebackground {#eff3f7} -activeforeground black \
        -background {#eff3f7} -foreground black \
        -highlightbackground {#d7d7d7} -highlightcolor black -text {Angulo 1} 
    vTcl:DefineAlias "$top.lab47" "Label_Angulo11" vTcl:WidgetProc "PopUp1" 1
    label $top.cpd51 \
        -activebackground {#eff3f7} -activeforeground black \
        -background {#eff3f7} -foreground black \
        -highlightbackground {#d7d7d7} -highlightcolor black -text {Angulo 2} 
    vTcl:DefineAlias "$top.cpd51" "Label_Angulo12" vTcl:WidgetProc "PopUp1" 1
    ###################
    # SETTING GEOMETRY
    ###################
    place $top.but54 \
        -in $top -x 86 -y 110 -width 53 -height 28 -anchor nw \
        -bordermode ignore 
    place $top.but54.but55 \
        -in $top.but54 -x 55 -y 25 -anchor nw -bordermode ignore 
    place $top.cpd47 \
        -in $top -x 100 -y 30 -width 38 -height 23 -anchor nw \
        -bordermode inside 
    place $top.cpd48 \
        -in $top -x 100 -y 70 -width 38 -height 22 -anchor nw \
        -bordermode ignore 
    place $top.cpd49 \
        -in $top -x 150 -y 27 -width 28 -height 28 -anchor nw \
        -bordermode ignore 
    place $top.cpd50 \
        -in $top -x 150 -y 65 -width 28 -height 28 -anchor nw \
        -bordermode inside 
    place $top.lab47 \
        -in $top -x 25 -y 32 -width 70 -height 20 -anchor nw \
        -bordermode ignore 
    place $top.cpd51 \
        -in $top -x 24 -y 71 -width 71 -height 20 -anchor nw \
        -bordermode ignore 

    vTcl:FireEvent $base <<Ready>>
}

proc vTclWindow.top53 {base} {
    if {$base == ""} {
        set base .top53
    }
    if {[winfo exists $base]} {
        wm deiconify $base; return
    }
    set top $base
    ###################
    # CREATING WIDGETS
    ###################
    vTcl:toplevel $top -class Toplevel \
        -background {#eff3f7} -highlightbackground {#eff3f7} \
        -highlightcolor black 
    wm withdraw $top
    wm focusmodel $top passive
    wm geometry $top 220x150+787+70; update
    wm maxsize $top 1009 738
    wm minsize $top 1 1
    wm overrideredirect $top 0
    wm resizable $top 1 1
    wm title $top "Calibrar Sensor 2"
    vTcl:DefineAlias "$top" "PopUp2" vTcl:Toplevel:WidgetProc "" 1
    bindtags $top "$top Toplevel all _TopLevel"
    vTcl:FireEvent $top <<Create>>
    wm protocol $top WM_DELETE_WINDOW "vTcl:FireEvent $top <<DeleteWindow>>"

    button $top.cpd57 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d7d7d7} -command {Window hide .top53} -foreground black \
        -highlightbackground {#d7d7d7} -highlightcolor black -text Fechar 
    vTcl:DefineAlias "$top.cpd57" "OK2" vTcl:WidgetProc "PopUp2" 1
    entry $top.cpd51 \
        -background white -foreground black -highlightbackground {#ffffff} \
        -highlightcolor black -insertbackground black -invalidcommand bell \
        -justify right -selectbackground {#c4c4c4} -selectforeground black \
        -textvariable angulo21 -validate all \
        -validatecommand {vTcl:DoCmdOption .drdaqgrace.fra70.ent76 {string is double %P}} 
    vTcl:DefineAlias "$top.cpd51" "Entry_Angulo21" vTcl:WidgetProc "PopUp2" 1
    button $top.cpd52 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d7d7d7} \
        -command {if {($Conector2 == "Interno")} {
    set set_value 4
} elseif {($Conector2 == "Ext1")} {
    set set_value 5
} elseif {($Conector2 == "Ext2")} {
    set set_value 10
}

set w .drdaqgrace

if {($angulo21 == "")} { 
    showMessageBox $w "o Valor do Ângulo"
} else { 

    Calib21 configure -state disabled
    Calib22 configure -state normal
    Entry_Angulo21 configure -state disabled
    Entry_Angulo22 configure -state normal

    hitCalibrate 0 $angulo21 1 $set_value
}} \
        -foreground black -highlightbackground {#d7d7d7} \
        -highlightcolor black -text OK 
    vTcl:DefineAlias "$top.cpd52" "Calib21" vTcl:WidgetProc "PopUp2" 1
    entry $top.cpd53 \
        -background white -foreground black -highlightbackground {#ffffff} \
        -highlightcolor black -insertbackground black -invalidcommand bell \
        -justify right -selectbackground {#c4c4c4} -selectforeground black \
        -state disabled -textvariable angulo22 -validate all \
        -validatecommand {vTcl:DoCmdOption .drdaqgrace.fra70.ent76 {string is double %P}} 
    vTcl:DefineAlias "$top.cpd53" "Entry_Angulo22" vTcl:WidgetProc "PopUp2" 1
    button $top.cpd54 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d7d7d7} \
        -command {if {($Conector2 == "Interno")} {
    set set_value1 4
} elseif {($Conector2 == "Ext1")} {
    set set_value1 5
} elseif {($Conector2 == "Ext2")} {
    set set_value 10
}

set w .drdaqgrace

if {($angulo22 == "")} { 
    showMessageBox $w "o Valor do Ângulo"
} else { 

    #Calib21 configure -state normal
    Calib22 configure -state disabled
    #Entry_Angulo21 configure -state normal
    Entry_Angulo22 configure -state disabled

    hitCalibrate 1 $angulo22 1 $set_value

    Window hide .top53

}} \
        -foreground black -highlightbackground {#d7d7d7} \
        -highlightcolor black -state disabled -text OK 
    vTcl:DefineAlias "$top.cpd54" "Calib22" vTcl:WidgetProc "PopUp2" 1
    label $top.cpd55 \
        -activebackground {#eff3f7} -activeforeground black \
        -background {#eff3f7} -foreground black \
        -highlightbackground {#d7d7d7} -highlightcolor black -text {Angulo 1} 
    vTcl:DefineAlias "$top.cpd55" "Label_Angulo21" vTcl:WidgetProc "PopUp2" 1
    label $top.cpd56 \
        -activebackground {#eff3f7} -activeforeground black \
        -background {#eff3f7} -foreground black \
        -highlightbackground {#d7d7d7} -highlightcolor black -text {Angulo 2} 
    vTcl:DefineAlias "$top.cpd56" "Label_Angulo22" vTcl:WidgetProc "PopUp2" 1
    ###################
    # SETTING GEOMETRY
    ###################
    place $top.cpd57 \
        -in $top -x 87 -y 110 -width 53 -height 28 -anchor nw \
        -bordermode ignore 
    place $top.cpd51 \
        -in $top -x 100 -y 30 -width 38 -height 23 -anchor nw \
        -bordermode inside 
    place $top.cpd52 \
        -in $top -x 165 -y 25 -width 28 -height 28 -anchor nw \
        -bordermode inside 
    place $top.cpd53 \
        -in $top -x 100 -y 70 -width 38 -height 23 -anchor nw \
        -bordermode inside 
    place $top.cpd54 \
        -in $top -x 165 -y 65 -width 28 -height 28 -anchor nw \
        -bordermode inside 
    place $top.cpd55 \
        -in $top -x 26 -y 32 -width 71 -height 20 -anchor nw \
        -bordermode ignore 
    place $top.cpd56 \
        -in $top -x 26 -y 72 -width 71 -height 20 -anchor nw \
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

Window show .
Window show .drdaqgrace
Window show .top52
Window show .top53

main $argc $argv
