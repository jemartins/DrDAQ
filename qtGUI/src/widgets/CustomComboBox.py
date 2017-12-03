#!/usr/bin/env python
# -*- coding: utf-8 -*-

'''
$Log: CustomComboBox.py,v $
Revision 1.1  2012/11/01 17:59:42  diogenes-silva
Adicionada a chamada ao diálogo de ajuste da escala.

'''

from PyQt4 import QtGui, QtCore

def setItems(self, items):
    self.clear()
    self.addItems(items)
    
    
def setItem(self, item):
    
    try:
        i = self.findText(item.toString())
    except AttributeError:
        i = self.findText(item)
    
    if i != -1:
        self.setCurrentIndex(i)
    else:
        print 'nao achei %s' % item.toString()

def getItem(self):
    return QtCore.QVariant(self.currentText())