#!/usr/bin/env python
# -*- coding: utf-8 -*-

'''
Este módulo contém a definição da classe JanelaCalibracao.

Revision history:
$Log: JanelaCalibracao.py,v $
Revision 1.6  2012/11/27 23:43:56  diogenes-silva
Retirados os sinais e slots que tratavam de falhas na calibração

Revision 1.5  2012/11/01 19:59:49  diogenes-silva
Adicionada a classe Controlador para controlar o processo de medição.

Revision 1.4  2012/11/01 17:59:43  diogenes-silva
Adicionada a chamada ao diálogo de ajuste da escala.

Revision 1.3  2012/10/24 16:31:32  diogenes-silva
O painel de auto-escala foi tirado e substituído por um checkbox.

Revision 1.2  2012/10/16 18:50:17  diogenes-silva
First version

'''

from PyQt4 import QtCore, QtGui, uic
from PyQt4.Qt import Qt

from app_config import config

class JanelaCalibracao( QtGui.QDialog ) :
    '''
    Janela para calibração dos ângulos do pêndulo.
    '''
    
    anguloConfirmado = QtCore.pyqtSignal(object, int, float)
    '''
    Sinal emitido quando o usuário confirma o ângulo
    a ser utilizado na calibração.
    
    Parâmetros:
    - str sensor: Conector calibrado (INT, EXT1 ou EXT2)
    - int angulo: Número do ângulo calibrado (1 ou 2)
    - float valor: Valor do ângulo (-180.0 a 180.0)
    '''
    
    @QtCore.pyqtSlot()
    def exibir(self, sensor):
        '''Exibe a janela de calibração.'''
        self.sensor = config['sensor%d_conector' % sensor]
        self.show()
    
    
    def adicionarConfiguracoes( self, settings ) :
        '''
        The settingsObject must have the interface of SettingsEditor.
        '''
        for w in (self.ui.angulo1, self.ui.angulo2):
            settings.addWidget(w)
        
        
    def _processarAnguloConfirmado( self, angulo ):
        '''
        Slot chamado quando o usuário confirma o ângulo.
        
        Parâmetros:
        - angulo: Número do ângulo confirmado (1 ou 2)
        '''
        if angulo not in (1, 2) :
            raise ValueError( 'O ângulo deve ser 1 ou 2' )
        
        lineEdit = self.ui.angulo1 if angulo == 1 else self.ui.angulo2
        
        if lineEdit.text() == '':
            lineEdit.setText('0')
        
        if lineEdit.hasAcceptableInput() :
            self.anguloConfirmado.emit( self.sensor,
                                        angulo,
                                        lineEdit.text().toDouble()[0] )
            
            self._setarAnguloAtivo(2 if angulo == 1 else 1)
            
            if angulo == 2:
                self.accept()
            else:
                self.ui.angulo2.setFocus( Qt.OtherFocusReason )
        
        
    def _setarAnguloAtivo( self, indice ) :
        '''
        Seta o ângulo que terá o QLineEdit e seu QPushButton ativados.
        
        Parâmetros:
        - indice Número (1 ou 2) indicando o ângulo a ser ativado. Caso
        ele não seja 1 ou 2, todos os ângulos serão desativados.
        '''
        widgets = ( (self.ui.ok1, self.ui.angulo1),
                    (self.ui.ok2, self.ui.angulo2) )
        
        for i in (1, 2) :
            for widget in widgets[i-1] :
                widget.setEnabled( i == indice )
        
        
    def showEvent( self, event ) :
        '''
        Override.
        Faz com que o foco sempre inicie no valor do ângulo 1,
        por comodidade.
        '''
        self._setarAnguloAtivo(1)
        self.ui.angulo1.setFocus( Qt.OtherFocusReason )
        
        
    def __init__( self, parent=None ) :
        '''
        Construtor.
        '''
        super(JanelaCalibracao, self).__init__(parent)
        
        self.sensor = 1
        
        FormType, BaseType = uic.loadUiType( 'ui/JanelaCalibracao.ui' )
        self.ui = FormType()
        self.ui.setupUi( self )
        
        self.anguloAtivo = 1
        
        validator = QtGui.QDoubleValidator( -90, 90, 1, self )
        validator.setNotation( QtGui.QDoubleValidator.StandardNotation )
        self.ui.angulo1.setValidator( validator )
        self.ui.angulo2.setValidator( validator )
        
        lambda1 = lambda : self._processarAnguloConfirmado(1)
        lambda2 = lambda : self._processarAnguloConfirmado(2)
        
        self.ui.angulo1.returnPressed.connect( lambda1 )
        self.ui.angulo2.returnPressed.connect( lambda2 )
        
        self.ui.ok1.clicked.connect( lambda1 )
        self.ui.ok2.clicked.connect( lambda2 )
        
        

if __name__ == '__main__' :
    import sys
    
    def printf(*args): print args
    
    app = QtGui.QApplication( sys.argv )
    
    j = JanelaCalibracao()
    
    j.anguloConfirmado.connect(printf)
    
    j.exibir(2)
    
    sys.exit( app.exec_() )
