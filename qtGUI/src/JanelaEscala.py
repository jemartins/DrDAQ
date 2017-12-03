#!/usr/bin/env python
# -*- coding: utf-8 -*-

'''
Este módulo contém a definição da classe JanelaPrincipal.

$Log: JanelaEscala.py,v $
Revision 1.1  2012/11/01 17:59:43  diogenes-silva
Adicionada a chamada ao diálogo de ajuste da escala.

'''

from PyQt4 import QtGui, uic

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
        