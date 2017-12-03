#!/usr/bin/env python
# -*- coding: utf-8 -*-

'''
$Log: CustomCheckBox.py,v $
Revision 1.1  2012/11/01 17:59:42  diogenes-silva
Adicionada a chamada ao diálogo de ajuste da escala.

'''

from PyQt4 import QtGui, QtCore

def getItem(widget):
    return QtCore.QVariant('True') if widget.checked() else QtCore.QVariant('False')

def setItem(widget, value):
    widget.setChecked(False if value.toString() == 'False' or not value.toString() else True)
