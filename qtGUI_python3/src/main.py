#!/usr/bin/env python3
# -*- coding: utf-8 -*-

'''
Programa principal.
'''

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

from PyQt4 import QtGui
from JanelaPrincipal import JanelaPrincipal
from app_config import config
from Controlador import Controlador

app = QtGui.QApplication(sys.argv)

dialog = JanelaPrincipal()
dialog.adicionarConfiguracoes(config)

dialog.show()

my_name = 'nome_nada'

for arg in sys.argv[1:]:
    # Da forma --name=NOME
    if arg.startswith('--'):
        key, sep, value = arg[2:].partition('=')
        if not key or not sep:
            continue
        my_name = value

controlador = Controlador(dialog, dialog.janelaCalibracao, my_name=my_name)
controlador.inicializar()

val = app.exec_()
config.save()
controlador.destruir()
sys.exit(val)
