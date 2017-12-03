#!/usr/bin/env python3
# -*- coding: utf-8 -*-

'''
$Log: CustomCheckBox.py,v $
Revision 1.2  2013/01/28 21:58:19  diogenes-silva
Finalizada a migração da sintaxe.

Revision 1.1  2013/01/28 20:55:37  diogenes-silva
Porting to Python3.

Revision 1.1  2012/11/01 17:59:42  diogenes-silva
Adicionada a chamada ao diálogo de ajuste da escala.

'''

from PyQt4 import QtGui, QtCore

def getItem(widget):
    return QtCore.QVariant('True') if widget.checked() else QtCore.QVariant('False')

def setItem(widget, value):
    widget.setChecked(False if value.toString() == 'False' or not value.toString() else True)
