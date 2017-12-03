#!/usr/bin/env python
# -*- coding: utf-8 -*-

'''
Programa principal.
'''

import sys
import time
from PyQt4 import QtGui
from JanelaPrincipal import JanelaPrincipal
print 'aqui-1'
from app_config import config
print 'aqui-0'
from Controlador import Controlador

print 'aqui1'
app = QtGui.QApplication(sys.argv)
print 'aqui2'
dialog = JanelaPrincipal()
print 'aqui3'
dialog.adicionarConfiguracoes(config)

dialog.show()

controlador = Controlador(dialog, dialog.janelaCalibracao)

val = app.exec_()
config.save()
controlador.destruir()
sys.exit(val)