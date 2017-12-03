#!/usr/bin/env python3
# -*- coding: utf-8 -*-

'''
Contém a classe Controlador.
'''

from PyQt4 import QtCore
from app_config import config
import app_config
from collections import namedtuple
from simplqobject import SimplQObject

import logging

ReadingStart = namedtuple('ReadingStart', [
        'token', # 9
        'ID', #
        'TMax', # (float) 
        'period', # Intervalo entre as leituras, em milissegundos
        'maxReadings', # Número máximo de leituras
        'nsensors', #
        'Sensor1', #
        'Sensor2', #
        'set_value1', # 
        'n_modo1', # Modo de leitura do sensor (Onda sonora, pêndulo, etc)
        'set_value2', # 
        'n_modo2', # Modo de leitura do sensor (Onda sonora, pêndulo, etc)
        'n_passo', #
        'AutoEscala', # Auto-escala habilitada
        'xmax', # (float) 
        'ymax', # (float) 
        'ymin', # (float) 
        'maior_divx', # (float) 
        'menor_divx', # (float) 
        'maior_divy', # (float) 
        'menor_divy', # (float) 
        'XY' #
    ])

ReadingStop = namedtuple('ReadingStop', 'token')

Calibrate = namedtuple('Calibrate', [
    'token', # Tokens.PICO_ANGLE_CALIBRATE
    'ID', # 0, geralmente
    'index',
    'angle', # Valor do angulo
    'sensor', #
    'set_value' # Indice dado pelo driver
    ])

class Tokens:
    PICO_WHAT_YA_GOT     =  0
    PICO_SOUND_WAVEFORM  =  1
    PICO_SOUND_LEVEL     =  2
    PICO_VOLTAGE         =  3
    PICO_RESISTANCE      =  4
    PICO_PH              =  5
    PICO_TEMPERATURE     =  6
    PICO_LIGHT           =  7
    PICO_READING_START   =  8
    PICO_READING_STOP    =  9
    PICO_WHAT_READINGS   = 10
    PICO_LED             = 11
    PICO_ANGLE           = 12
    PICO_ANGLE_CALIBRATE = 13

class Controlador(QtCore.QObject):
    
    def __init__(self, janelaPrincipal, janelaCalibracao, my_name='NADA', parent=None):
        '''
        Inicializador.
        '''
        super(Controlador, self).__init__(parent)
        
        self.principal = janelaPrincipal
        self.janelaCalibracao = janelaCalibracao
        self.simpl = None
        self.my_name = my_name
        janelaCalibracao.anguloConfirmado.connect(self.calibrarAngulo)
    
        self.simpl = SimplQObject(my_name=self.my_name, other_name='PICOMGR', parent=self)
        self.principal.askedToStart.connect(self.iniciarMedicao)
        self.principal.askedToStop.connect(self.pararMedicao)
        self.simpl.received.connect(self.processarMensagens)
    
    
    def destruir(self):
        '''
        todo
        '''
        if self.simpl:
            self.simpl.destroy()
        
    
    def inicializar(self):
        '''Inicializa o SIMPL. As mensagens a serem recebidas devem ser
        registradas com register() antes!'''
        self.simpl.register('reading_stop', 'ii', Tokens.PICO_READING_STOP)
        self.simpl.register('reading_value', 'iffi', Tokens.PICO_WHAT_READINGS)
        self.simpl.start()
        
    
    def processarMensagens(self, name, values):
        if name == 'reading_stop':
            self.principal.avisarMedicaoTerminada()
        elif name == 'reading_value':
            self.principal.showTime(values[1])
            conector = config['sensor1_conector'] if values[3] == 1 else config['sensor2_conector']
            self.principal.showValue(conector, values[2])
            
            
    def processarFalhas(self, mensagem):
        '''Função que processa as falhas ocorridas no envio das mensagens.'''
        
        if mensagem == 'angle_calibrate':
            self.principal.janelaCalibracao.avisarAnguloNaoCalibrado()
         
        
    def iniciarMedicao(self):
        '''
        Deflagra o início do processo de medição.
        '''
        logging.debug("Chegou no iniciarMedicao()")
        modo1 = app_config.tipos.index(config['sensor1_tipo']) + 1
        
        try:
            modo2 = app_config.tipos.index(config['sensor2_tipo']) + 1
        except IndexError:
            # Significa que no sensor 2 foi escolhido 'Tempo', então
            # só o primeiro sensor estará habilitado.
            modo2 = 0
        
        set_value1 = self._getDriverNumber(config['sensor1_conector'], config['sensor1_tipo'])
        set_value2 = self._getDriverNumber(config['sensor2_conector'], config['sensor2_tipo'])
        
        Sensor2 = int(config['sensor2_conector'] != 'Tempo')
        
        n_passo = int(config['intervalo_habilitar'] == 'true')
        period = int(round(1000 * float(config['intervalo'])))
        maxReadings = int(config['numeroDeMedicoes'])
        TMax = float(config['tempoDeMedicao'])
        
        if not period or (n_passo and not TMax) or (not n_passo and not maxReadings):
            self.principal.avisarMedicaoTerminada()
            return
        
        # Compor a mensagem a ser enviada
        m = ReadingStart(
                token = Tokens.PICO_READING_START,
                ID = 0,
                
                TMax = TMax,
                period = period,
                maxReadings = maxReadings,
                
                n_modo1 = modo1,
                set_value1 = set_value1,
                n_modo2 = modo2,
                set_value2 = set_value2,
                
                Sensor1 = 1,
                Sensor2 = Sensor2,
                
                XY = Sensor2,
                nsensors = int(config['sensor2_conector'] != 'Tempo') + 1,
                n_passo = n_passo,
                
                AutoEscala = int(config['autoEscala_habilitar'] == 'true'),
                xmax = float(config['xMax']),
                ymax = float(config['yMax']),
                ymin = float(config['yMin']),
                maior_divx = float(config['xMaiorDiv']),
                menor_divx = float(config['xMenorDiv']),
                maior_divy = float(config['yMaiorDiv']),
                menor_divy = float(config['yMenorDiv']),
                
                )
        logging.debug(m)
        if self.simpl:
            self.simpl.send('reading_start', m)
    
    
    def pararMedicao(self):
        '''
        Pede que a medição seja parada.
        '''
        m = ( Tokens.PICO_READING_STOP, 0 )
        logging.debug(m)
        if self.simpl:
            self.simpl.send('reading_stop', m)
    
    
    def calibrarAngulo(self, conector, angulo_indice, valor):
        '''
        Calibra o angulo.
        '''
        driver_num = self._getDriverNumber(conector, app_config.tipos[-1])
        
        m = Calibrate(
            token = Tokens.PICO_ANGLE_CALIBRATE,
            ID = 0,
            index = int(angulo_indice-1),
            angle = float(valor),
            sensor = int(config['sensor1_tipo'] == conector),
            set_value = driver_num
        )
        
        logging.debug(m)
        
        if self.simpl:
            self.simpl.send('angle_calibrate', m)
        
        
    def _getDriverNumber(self, conector, tipo):
        '''
        Retorna o índice do valor atribuído pelo driver.
        '''
        if conector == 'INT':
            try:
                tipo_indice = app_config.tipos.index(tipo)
                return (1, 3, 4, 7, 2, 11, 6, 4)[tipo_indice]
            except IndexError:
                return 0
            
        elif tipo == 'Resistência':
            return 8 if conector == 'EXT1' else 9
        
        else:
            return 5 if conector == 'EXT1' else 10
        
        
        