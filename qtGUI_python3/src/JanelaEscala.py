#!/usr/bin/env python3
# -*- coding: utf-8 -*-

'''
Este módulo contém a definição da classe JanelaPrincipal.

$Log: JanelaEscala.py,v $
Revision 1.2  2013/01/28 21:58:19  diogenes-silva
Finalizada a migração da sintaxe.

Revision 1.1  2013/01/28 20:55:36  diogenes-silva
Porting to Python3.

Revision 1.1  2012/11/01 17:59:43  diogenes-silva
Adicionada a chamada ao diálogo de ajuste da escala.

'''

from PyQt4 import QtGui, uic
from app_config import config

class JanelaEscala(QtGui.QDialog):
    '''
    Janela com os valores da auto-escala.
    '''
    
    def __init__(self, parent=None):
        '''
        Inicializador.
        '''
        super(JanelaEscala, self).__init__(parent)
        
        FormType, BaseType = uic.loadUiType('ui/JanelaEscala.ui')
        self.ui = FormType()
        self.ui.setupUi(self)
        
    
    def exec_(self):
        '''
        Mostra o diálogo.
        '''
        
        self.config.backup('escala')
        val = super(JanelaEscala, self).exec_()
        
        # O usuário cancelou
        if not val:
            self.config.restore('escala')
        
        return val
    
    
    def adicionarConfiguracoes(self, config):
        '''
        Adiciona os widgets às configurações.
        '''
        self.config = config
        
        widgets = (self.ui.xMenorDiv, self.ui.xMaiorDiv, self.ui.xMax,
                   self.ui.yMenorDiv, self.ui.yMaiorDiv, self.ui.yMax, self.ui.yMin)
        
        for w in widgets:
            config.addWidget(w, category='escala')


if __name__ == '__main__':
    import sys
    
    app = QtGui.QApplication(sys.argv)
    
    dialog = JanelaEscala()
    dialog.adicionarConfiguracoes(config)
    
    dialog.show()
    val = app.exec_()
    config.save()
    sys.exit(val)
    