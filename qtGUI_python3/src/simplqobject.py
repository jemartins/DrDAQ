#!/usr/bin/env python3
# -*- coding: utf-8 -*-

'''
Este módulo contém a definição da classe SimplQObject, que expõe
a interface do SIMPL num Qt-Style.
'''

from PyQt4 import QtCore
QtCore.Signal = QtCore.pyqtSignal

import struct
import wcsimpl
import multiprocessing
import Queue

import logging

class SimplQObject(QtCore.QObject):
    '''
    Classe que expõe uma interface no Qt-Style (com sinais e slots assíncronos)
    da biblioteca SIMPL.
    '''
    
    received = QtCore.Signal(str, list)
    '''
    Sinal emitido quando uma mensagem é recebida.
    
    Parâmetros:
    - (str) nome: nome da mensagem, pode ser vazio
    - (list) valores: lista dos valores recebidos na mensagem.
    '''
    
    failed = QtCore.Signal(str)
    '''
    Sinal emitido quando o envio da mensagem falhou.
    
    Parâmetros:
    - (str) nome: nome da mensagem
    '''
    
    def __init__(self, my_name, other_name='PICOMGR', parent=None):
        '''
        Inicializador.
        
        Parâmetros:
        - my_name: Nome deste programa.
        - other_name: Nome do outro programa com o qual este irá se comunicar.
        '''
        super(QtCore.QObject, self).__init__(parent)
        
        self.my_name, self.other_name = my_name, other_name
        
        self.input_queue = multiprocessing.Queue()
        self.output_queue = multiprocessing.Queue()
        self.failures = multiprocessing.Queue()
        
        self.messages = {}
        self.pSender = None
        self.pReceiver = None
        self.received.connect(logging.debug)
        self.failed.connect(logging.debug)
        QtCore.QTimer.singleShot(0, self._update)
        
        
    def start(self):
        '''Inicializa o processo que recebe as mensagens do SIMPL.
        register() deve ser chamado com as mensagens a serem recebidas antes!'''
        
        self.pSender = multiprocessing.Process(
                        name='simpl_manager',
                        target = _senderTask,
                        args = ('souosender', self.other_name, self.output_queue, self.failures))
                        
        self.pReceiver = multiprocessing.Process(
                        name='simpl_receiver',
                        target = _receiverTask,
                        args = (self.my_name, self.other_name, self.input_queue))
        
        self.pSender.start()
        self.pReceiver.start()
        
        
    def register(self, message, format, token):
        '''
        Registrar a mensagem de entrada.
        
        Parâmetros:
        '''
        self.messages[token] = {'name': str(message), 'format': str(format)}
        
        
    def send(self, message_name, values):
        '''
        Envia uma mensagem ao outro programa.
        
        Parâmetros:
        - values: Lista de valores a serem enviados
        - message: Nome da mensagem a ser enviada. Esse será o nome transmitido
            pelo sinal failed() em caso de falha no envio.
        '''
        s = ''
        
        for val in values:
            if type(val) == int: s += 'i'
            elif type(val) == float: s += 'f'
            else: s += 's'
        
        self.output_queue.put((message_name, struct.pack(s, *values)))
        
        
    def destroy(self):
        '''
        Destrói o processo que cuida da interação com o SIMPL.
        Chame SEMPRE esta função antes do programa terminar, a fim de evitar
        que o processo vire órfão.
        '''
        if self.pSender:
            self.pSender.terminate()
        if self.pReceiver:
            self.pReceiver.terminate()
    
    
    def _update(self):
        '''
        Verifica se há mensagens recebidas na fila.
        '''
        QtCore.QTimer.singleShot(0, self._update)
        
        if not self.pSender:
            return
        
        try:
            # Mensagens enviadas que falharam
            while True:
                message_name = self.failures.get(block=False)
                self.failed.emit(message_name)
        except Queue.Empty:
            pass
        
        try:
            message_bytes = self.input_queue.get(block=False)
            
            # Pegar o token, que são os primeiros 4 bytes lidos
            try:
                token = struct.unpack('i', message_bytes[:struct.calcsize('i')])[0]
            except struct.error:
                logging.warn( 'Erro ao pegar o token')
                raise
            info = self.messages[token]
            values = struct.unpack(info['format'], message_bytes)
            self.received.emit(info['name'], list(values))
        except Queue.Empty:
            pass
        except struct.error:
            logging.warn('MENSAGEM MAL FORMATADA.')
        except KeyError:
            logging.warn('Unrecognized token2: %d' % token)
 

class AttachError(StandardError):
    '''
    Erro ao registrar o programa no bus do SIMPL.
    '''
    pass


def _senderTask(my_name, other_name, output_queue, failures):
    simpl = wcsimpl.Simpl()
    
    if simpl.nameAttach(my_name, 1024) == -1:
        logging.debug('NAO CONECTOU: %s' % simpl.whatsMyError())
    
    while True:
        try:
            message_name, message_bytes = output_queue.get(block=False)
            
            other_id = simpl.nameLocate(other_name)
            if other_id == -1:
                failures.put(message_name)
                logging.debug('NAO ACHEI O DESTINATARIO: %s' % simpl.whatsMyError())
                continue
            
            simpl.packString(message_bytes, simpl.CHR)
            
            retVal = simpl.send(other_id)
            if retVal == -1:
                failed_output.put(message_name)
                logging.debug('NAO DEU PARA ENVIAR: %s' % simpl.whatsMyError())
                
        except Queue.Empty:
            pass


def _receiverTask(my_name, other_name, input_queue):
    
    simpl = wcsimpl.Simpl()
    
    if simpl.nameAttach(my_name, 1024) == -1:
        logging.debug('NAO CONECTOU: %s' % simpl.whatsMyError())
    try:
        while True:
            message_size, sender_id = simpl.receive()
            
            if message_size == -1:
                continue
            elif message_size > 0:
                try:
                    bytes = simpl.unpackString(message_size, simpl.CHR)
                except:
                    logging.debug('erro no unpacking')
                
                try:
                    input_queue.put(bytes)
                    simpl.reply(sender_id)
                except:
                    logging.debug('erro na reply')
    except:
        logging.debug('excecao no processo _receiverTask')
    

if __name__ == '__main__':
    import sys
    from PyQt4 import QtGui
    
    fifo = ''
    picomgr = ''
    
    for arg in sys.argv[1:]:
        # Processe argumentos do tipo --fifo=/home/nada
        if arg.startswith('--'):
            key, sep, val = arg[2:].partition('=')
            
            if not sep or not key:
                continue
            
            if key in ('fifo', 'picomgr'):
                # Meio errado fazer isso, mas por enquanto fica assim.
                vars()[key] = val
    
    
    app = QtGui.QApplication(sys.argv)
    button = QtGui.QPushButton('Cligne')
        
    simpl = SimplQObject('nada', parent=button)
    #simpl.register('stop', token=9, format='ii')
    
    button.clicked.connect(lambda: simpl.send('stop', (9,0)))
    button.show()
    
    val = app.exec_()
    simpl.destroy()
    sys.exit(val)
    