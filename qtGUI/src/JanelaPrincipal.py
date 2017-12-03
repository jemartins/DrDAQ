#!/usr/bin/env python
# -*- coding: utf-8 -*-

'''
Este módulo contém a definição da classe JanelaPrincipal.

Revision history:
$Log: JanelaPrincipal.py,v $
Revision 1.17  2012/12/20 19:00:32  diogenes-silva
Comentada a linha que importava ui.Ui_JanelaPrincipal

Revision 1.16  2012/11/27 23:46:51  diogenes-silva
Adicionada a opção de linha de comando --name=NAME para definir o nome do programa no SIMPL

Revision 1.15  2012/11/27 10:28:57  diogenes-silva
Criado o arquivo Python da janela da interface, ao inves de carrega-la diretamente do arquivo UI

Revision 1.14  2012/11/26 23:45:21  diogenes-silva
*** empty log message ***

Revision 1.13  2012/11/19 22:17:23  diogenes-silva
Alterado ConfiguracoesDaMedicao para ConfigurationManager

Revision 1.12  2012/11/19 18:24:42  diogenes-silva
Adicionado o teste no simpl_qobject

Revision 1.11  2012/11/19 16:50:51  diogenes-silva
Adicionado o objeto para interação com o SIMPL.

Revision 1.10  2012/11/12 15:23:28  diogenes-silva
Adicionada a classe SimplQObject, que fornece uma interface assíncrona ao SIMPL.

Revision 1.9  2012/11/02 00:36:01  diogenes-silva
*** empty log message ***

Revision 1.8  2012/11/01 19:59:49  diogenes-silva
Adicionada a classe Controlador para controlar o processo de medição.

Revision 1.7  2012/11/01 18:33:22  diogenes-silva
Agora as configurações são travadas ao clicar no botão "Iniciar"

Revision 1.6  2012/11/01 17:59:43  diogenes-silva
Adicionada a chamada ao diálogo de ajuste da escala.

Revision 1.5  2012/10/24 17:50:08  diogenes-silva
Adicionado o drop-down para escolher "versus" ou "e" entre os sensores e agora intervalo e número de medições são botões Radio.

Revision 1.4  2012/10/24 16:31:32  diogenes-silva
O painel de auto-escala foi tirado e substituído por um checkbox.

Revision 1.3  2012/10/23 23:54:30  diogenes-silva
Agora a classe JanelaPrincipal é derivada da classe QMainWindow, ao invés de QDialog. Isso faz com que a janela não feche quando o usuário digita Enter em algum campo.

Revision 1.2  2012/10/16 18:50:17  diogenes-silva
First version

'''

"""TODO
"""

from PyQt4 import QtCore, QtGui, uic
from PyQt4.Qt import Qt

from JanelaCalibracao import JanelaCalibracao
from JanelaEscala import JanelaEscala
from ConfigurationManager import ConfigurationManager

from app_config import config
import widgets.CustomComboBox as CustomComboBox


#from ui.Ui_JanelaPrincipal import Ui_JanelaPrincipal

class JanelaPrincipal( QtGui.QMainWindow ):
    '''
    A janela principal da aplicação.
    '''
    
    askedToStart = QtCore.pyqtSignal()
    '''
    Emitted when the user asks the application to start a measurement.
    '''
    
    askedToStop = QtCore.pyqtSignal()
    '''
    Emitted when the user asks the application to stop the ongoing measurement.
    '''
    
        
    def __init__(self, parent=None):
        '''
        Construtor.
        '''
        
        super(JanelaPrincipal, self).__init__(parent)
        
        FormType, BaseType = uic.loadUiType('ui/JanelaPrincipal.ui')
        self.ui = FormType()
        self.ui.setupUi(self)
        
        self.statusBar().hide()
        
        self.janelaCalibracao = JanelaCalibracao(self)
        self.janelaEscala = JanelaEscala(self)
        
        self.medicaoAtiva = False
        
        self._conectarSlots()
        self.zerar()
    
    
    def showTime(self, tempo):
        '''Shows the current time of the ongoing measurement.
        
        Parameters:
        - time Number of seconds since the beginning of the measurement.
        '''
        minutos, segundos = int(tempo) / 60, tempo % 60
        decimos = int(segundos * 10) % 10
        self.ui.tempo.setText( '%d:%02d.%d' % (minutos, segundos, decimos) )
        
        try:
            tempoMax = float(config['tempoDeMedicao'])
        except KeyError:
            tempoMax = 0.0
            
        val = tempo*100/tempoMax if tempoMax else 0
        self.ui.progresso.setValue(val)
        
    
    def setarTempoMaximo(self, tempoMax):
        '''
        Seta o tempo máximo da medição.
        '''
        self.tempoMax = tempoMax
        
        
    def showValue(self, conector, valor):
        '''Shows the value of the current measuring in the specified connector.
        
        Parameters:
        - connector Must be the string 'INT', 'EXT1' or 'EXT2'
        - value Number indicator of the current reading in the connector.
        '''
        try:
            mostrador = getattr(self.ui, 'sensor'+conector+'_valor')
        except AttributeError:
            return
        
        mostrador.setText( '%.2f' % valor )
    
    
    def avisarMedicaoTerminada(self):
        '''Avisa que a medição foi interrompida.'''
        
        self.medicaoAtiva = False
        self.ui.iniciar.setText( u'Iniciar' )
        self.zerar()
        self.config.unlock('medicao')
    
    
    def _iniciarOuPararMedicao(self):
        '''Inicia uma medição ou interrompe a medição atual.
        
        Slot chamado quando o usuário clica no botão Iniciar/Parar.
        '''
        
        if self.medicaoAtiva:
            self.askedToStop.emit()
        else:
            self.medicaoAtiva = True
            self.zerar()
            self.ui.iniciar.setText(u'Parar')
            
            self.config.lock('medicao')
            self.askedToStart.emit()
        
        
        
    def _conectarSlots(self):
        '''Conecta os sinais e slots dos widgets e deste diálogo.'''
        
        # Processar os cliques no botão "Iniciar"
        self.ui.iniciar.clicked.connect(self._iniciarOuPararMedicao)
        
        # Chamar a janela de calibração para o sensor apropriado
        self.ui.sensor1_calibrar.clicked.connect(
                    lambda : self.janelaCalibracao.exibir(1) )
        self.ui.sensor2_calibrar.clicked.connect(
                    lambda : self.janelaCalibracao.exibir(2) )
        
        self.ui.autoEscala_configurar.clicked.connect(
                    self.janelaEscala.exec_ )
        
        # Provisoriamente
        self.ui.salvar.clicked.connect(self.avisarMedicaoTerminada)
    
    
    def adicionarConfiguracoes(self, settings):
        QtCore.QTimer.singleShot(0, lambda: self._adicionarConfiguracoes(settings))
        
    def _adicionarConfiguracoes(self, settings):
        '''Adiciona os widgets às edições das configurações.'''
        
        for w in (
                self.ui.intervalo,
                self.ui.tempoDeMedicao,
                self.ui.numeroDeMedicoes,
                self.ui.autoEscala_habilitar,
                self.ui.intervalo_habilitar,
                self.ui.numeroDeMedicoes_habilitar ):
            settings.addWidget(w, category='medicao')
        
        settings.addWidget(self.ui.sensor1_calibrar, property='enabled', category='medicao')
        settings.addWidget(self.ui.sensor2_calibrar, property='enabled', category='medicao')
        settings.addWidget(self.ui.autoEscala_configurar, property='enabled', category='medicao')
        
        settings.addWidget(self.ui.sensor2_tipo, category='medicao', option='sensor2_tipoVisivel', property='visible')
        settings.addWidget(self.ui.sensor2_calibrar, category='medicao', option='sensor2_calibrarVisivel', property='visible')
        settings.addWidget(self.ui.frame_INT, option='mostradorINT', property='visible')
        settings.addWidget(self.ui.frame_EXT1, option='mostradorEXT1', property='visible')
        settings.addWidget(self.ui.frame_EXT2, option='mostradorEXT2', property='visible')
        
        specs = {'getter': CustomComboBox.getItem,
                 'setter': CustomComboBox.setItem,
                 'set_items': CustomComboBox.setItems,
                 'signal': 'currentIndexChanged' }
        
        for w in (self.ui.sensor1_tipo, self.ui.sensor2_tipo,
                  self.ui.sensor1_conector, self.ui.sensor2_conector):
            settings.addCustomWidget(w, specs, category='medicao')
        
        settings.addWidget(self, property='geometry', category='geometria')
        
        self.janelaEscala.adicionarConfiguracoes(settings)
        
        self.config = settings
    
    
    def zerar(self):
        '''
        Zera os troços tudo.
        '''
        self.tempoMax = 0
        self.showTime(0)
        
        for c in (self.ui.sensorINT_valor,
                  self.ui.sensorEXT1_valor,
                  self.ui.sensorEXT2_valor):
            c.setText('0.00')
        
        
    def showEvent(self, event):
        '''Override.
        
        Muda o foco para o botão "Iniciar", por comodidade.
        '''
        super(JanelaPrincipal, self).showEvent(event)
        self.ui.iniciar.setFocus( Qt.OtherFocusReason )
        
        
        
if __name__ == '__main__':
    import sys
    
    app = QtGui.QApplication(sys.argv)
    
    dialog = JanelaPrincipal()
    dialog.adicionarConfiguracoes(config)
    
    dialog.show()
    val = app.exec_()
    config.save()
    sys.exit(val)
        
