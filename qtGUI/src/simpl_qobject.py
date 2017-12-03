#!/usr/bin/env python
# -*- coding: utf-8 -*-

u'''
Este módulo contém a definição da classe SimplQObject, que expõe
a interface do SIMPL num Qt-Style.
'''

from PyQt4 import QtCore
QtCore.Signal = QtCore.pyqtSignal

import struct
import wcsimpl
import multiprocessing
import Queue


class SimplQObject(QtCore.QObject):
    '''
    Classe que expõe uma interface no Qt-Style (com sinais e slots assíncronos)
    da biblioteca SIMPL.
    '''
    
    received = QtCore.Signal(str, list)
    '''
    Sinal emitido quando uma mensagem é recebida.
    
    Parâmetros:
    - (str) nome: nome da mensagem, conforme registrado por self.register()
    - (list) valores: lista dos valores recebidos na mensagem.
    '''
    
    failed = QtCore.Signal(str)
    '''
    Sinal emitido quando o envio da mensagem falhou.
    
    Parâmetros:
    - (str) nome: nome da mensagem
    '''
    
    def __init__(self, my_name, other_name):
        '''
        Inicializador.
        
        Parâmetros:
        - my_name: Nome deste programa.
        - other_name: Nome do outro programa com o qual este irá se comunicar.
        '''
        self.my_name, self.other_name = my_name, other_name
        
        input = multiprocessing.Queue()
        output = multiprocessing.Queue()
        
        self.p = multiprocessing.Process(
                        'simpl_manager',
                        target = _simplTask,
                        args = (my_name, input, output) )
        
        
    def register(self, name, token, format):
        '''
        Registra o formato do token.
        
        Parâmetros
        - (str) name: Nome da mensagem
        - (int) token: Inteiro que identifica esta mensagem
        - (str) format: Formato reconhecido por struct.pack()
        '''
        self.formats[name] = ('i'+token, format)
        
        
    def send(self, name, *values):
        '''
        Envia uma mensagem ao outro programa.
        
        Parâmetros:
        - name: Nome da mensagem a enviar
        - values: Lista de valores a serem enviados
        '''
        out_buffer = struct.pack(self.formats[name][1],
                                 *( (self.formats[name][0],) + tuple(values) ))
        
        
    def destroy(self):
        '''
        Destrói o processo que cuida da interação com o SIMPL.
        Chame SEMPRE esta função antes do programa terminar, a fim de evitar
        que o processo vire órfão.
        '''
        self.p.terminate()
        
    
    def _update(self):
        '''
        Verifica se há mensagens recebidas na fila.
        '''
        QtCore.QTimer.singleShot(0, self._update)
        


class AttachError(StandardError):
    '''
    Erro ao registrar o programa no bus do SIMPL.
    '''
    pass


def _simplTask(my_name, other_name, input, output):
    
    simpl = wcsimpl.Simpl()
    
    if simpl.nameAttach(my_name, 1024) == -1:
        print 'NAO CONECTOU: %s' % simpl.whatsMyError()
    
    while True:
        try:
            out_message = output.get(block=False)
            
            other_id = simpl.nameLocate(other_name)
            if other_id == -1:
                print 'NAO ACHEI O DESTINATARIO: %s' % simpl.whatsMyError()
                continue
            
            simpl.packInt(9, simpl.CHR)
            simpl.packInt(0, simpl.CHR)
            
            retVal = simpl.Send(other_id)
            
            if retVal == -1:
                print 'NAO DEU PARA ENVIAR: %s' % simpl.whatsMyError()
        except Queue.Empty:
            pass
        
    pass


if __name__ == '__main__':
    import sys
    from PyQt4 import QtGui
    
    fifo = ''
    picomgr = ''
    
    for arg in sys.argv[1:]:
        # Processe argumentos do tipo --fifo=/home/nada
        if arg.startswith('--'):
            key, sep, val = arg[2:].partition('=')
            
            if not sep:
                continue
            
            if key in ('fifo', 'picomgr'):
                # Meio errado fazer isso, mas por enquanto fica assim.
                vars()[key] = val
    
    
    app = QtGui.QApplication(sys.argv)
    button = QtGui.QPushButton('Cligneu')
    
    simpl = SimplQObject()
    simpl.register('stop', token=9, format='ii')
    
    button.clicked.connect(lambda: simpl.send('stop', (9,0)))
    button.show()
    
    val = app.exec_()
    simpl.destroy()
    sys.exit(val)
    