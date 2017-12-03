#!/usr/bin/env python3
# -*- coding: utf-8 -*-

'''
Este módulo contém definições de configurações.

$Log: ConfigurationManager.py,v $
Revision 1.2  2013/01/28 21:58:19  diogenes-silva
Finalizada a migração da sintaxe.

Revision 1.1  2013/01/28 20:55:36  diogenes-silva
Porting to Python3.

Revision 1.4  2012/11/27 23:03:58  diogenes-silva
Corrigido o bug que fazia as opcoes dependentes de outras voltarem habilitadas, independente do valores das opções mestras

Revision 1.3  2012/11/01 19:59:49  diogenes-silva
Adicionada a classe Controlador para controlar o processo de medição.

Revision 1.2  2012/11/01 18:33:22  diogenes-silva
Agora as configurações são travadas ao clicar no botão "Iniciar"

Revision 1.1  2012/11/01 17:59:43  diogenes-silva
Adicionada a chamada ao diálogo de ajuste da escala.

Revision 1.1  2012/10/24 17:50:08  diogenes-silva
Adicionado o drop-down para escolher "versus" ou "e" entre os sensores e agora intervalo e número de medições são botões Radio.

'''

import register_application

from PyQt4 import QtCore
from PyQt4.QtCore import QVariant

import sys
import codecs

sys.stdout = codecs.getwriter('utf-8')(sys.__stdout__)

def debug(s):
    return;print('DEBUG: ' + s)

def info(s):
    return;print('INFO: ' + s)

class ConfigurationManager(object):
    '''
    Esta classe armazena as configurações da medição, conforme
    selecionadas pelo usuário.
    '''
    
    def __init__(self):
        '''Inicializador.'''
        
        self.options = {}
        '''
        Deve ter as chaves: 
        - widget: Widget editor.
        - category='main': Categoria da opção.
        - 'getter' e 'setter': Funções de acesso ao valor no widget
        - has_signal=False: Sinal de notificação de alteração do valor do widget.
        - set_items=None: Função para setar os possíveis valores do widget
        - values: Valores permitidos para a opção.
        '''
        
        self.backups = {}
        self.settings = QtCore.QSettings()
        self.dependencies = {}
        self.slaves = {}
    
    
    def save(self):
        '''
        Salva todas as configurações no arquivo INI.
        '''
        
        for name, opt in self.options.items():
            getter = opt['getter']
            if getter:
                self.settings.setValue(name, getter(opt['widget']))
        
        self.settings.sync()
        
        
    def __getitem__(self, option):
        '''
        Retorna o valor atual da opção como uma string unicode.
        
        A exceção KeyError é lançada caso a opção ainda não exita.
        '''
        
        opt = self.options[option]
        
        # Se não tiver o sinal de notificação, atualizar o valor nas settings
        # de acordo com o valor atual do widget
        if opt['has_signal'] is None:
            self._updateStoredValue(option)
        
        
        return str(self.settings.value(option))
    
    
    def __setitem__(self, option, value):
        '''
        Seta o valor da opção de configuração para o valor especificado.
        '''
        opt = self.options[option]
        
        # isinstance() é do mal, mas QVariant em Python também é...
        if isinstance(value, QVariant):
            value = value.toString()
        
        # Se não estiver na lista de valores permitidos
        if opt['values'] and str(value) not in opt['values']:
            opt['setter'](opt['widget'], self.settings.value(option))
            
            debug('Valor inválido para a opção "%s": "%s". '
                  'Os valores permitidos são %s' % (
                        option, str(value), opt['values']))
            return
        
        self.settings.setValue(option, value)
        opt['setter'](opt['widget'], value)
        
        self._updateDependency(option)
        self._updateDistinctValues(option)
        
        
    def setLocked(self, locked, category='all'):
        '''
        Trava ou destrava a edição das opções com a categoria informada. Só
        serão desabilitados/habilitados os widgets com o método setEnabled().
        
        Parâmetros:
        - locked Se for True, a edição é travada ou destravada se for False.
        - category Categoria das opções que devem ser travadas. Se for 'all',
          todas as opções serão travadas.
        '''
        for opt in self.options.values():
            if category == 'all' or category == opt['category']:
                if hasattr(opt['widget'], 'setEnabled'):
                    opt['widget'].setEnabled(not locked)
        
        for opt in self.options:
            self._updateDependency(opt)
    
    
    def lock(self, category='all'):
        '''
        Chama setLocked(True, category).
        '''
        self.setLocked(True, category)
        
        
    def unlock(self, category='all'):
        '''
        Chama setLocked(False, category).
        '''
        self.setLocked(False, category)
        
        
    def backup(self, category='main'):
        '''Faz um backup das configurações atuais da categoria.
        
        Esse backup pode ser restaurado utilizando o método self.restore().'''
        d = {}
        self.backups[category] = d
        
        for name, opt in self.options.items():
            if opt['category'] == category:
                d[name] = opt['getter'](opt['widget'])
        
        
    def restore(self, category='main'):
        '''Restaura as configurações aos valores presentes no backup.'''
        
        try:
            d = self.backups[category]
        except KeyError:
            return
        
        for name, val in d.items():
            self[name] = val
        
    
    def restrict(self, option, values):
        '''
        Restringe o valor da opção "option" apenas aos contidos na lista
        values. A opção é adicionada se ainda não existir, caso em que esta
        função deve ser chamada novamente.
        
        Parâmetros:
        - option Nome da opção a ser restringida.
        - values Lista de valores permitidos para a opção.
        '''
        opt = self._getOptionDict(option)
        opt['values'] = values
        
        if (opt['widget'] is not None) and (not opt['set_items']):
            debug('O widget da opção "%s" não suporta a operação "set_items".' % option)
            return False
        
        if opt['widget'] is None:
            info('A opção "%s" ainda não tem um widget.' % option)
            return True
            
        # Guardando o valor atual antes de inserir os itens no widget,
        # pois o valor do widget pode ser alterado ao inserir os itens
        val = self[option]
        
        opt['set_items']( opt['widget'], values )
        
        # Voltando ao valor original
        self[option] = val
        
        return True
    
    
    def assureDistinctness(self, option1, option2):
        '''
        Assegura que as opções option1 e option2 terão sempre
        valores distintos. É necessário que ambas tenham sido previamente
        restringidas com self.restrict().
        '''
        opt1 = self._getOptionDict(option1)
        opt2 = self._getOptionDict(option2)
        
        opt1['distinct'] = option2
        opt2['distinct'] = option1
        
        
    def setEnabledWhen(self, option, **kwargs):
        '''
        Habilita a opção dependendo do valor de outras opções.
        
        - option Nome da opção, chamada de "opção escrava" pois depende
            do valor de outras opções. Deve ser uma opção booleana.
        - kwargs Um dicionário com as opções (chamadas "opções mestras")
            da qual a opção escrava depende.
            - {key}: nome da opção mestra.
            - {value}: lista de valores na qual a opção escrava será habilitada.
            A chave especial '__conector__' indica o conector lógico ('or' ou 'and')
            que conectará os valores.
        '''
        # Registre as opçãos mestres.
        self.slaves[option] = {}
        self.slaves[option].update(kwargs)
        
        # Registre na opção mestre as opçãos dependentes
        for other_option in kwargs:
            d = self._getOptionDict(other_option)
            d['slaves'].append(option)
        
    
    def _updateDistinctValues(self, option):
        try:
            opt = self.options[option]
            if opt['distinct']:
                self._assureDistinctValues(option, opt['distinct'])
        except KeyError:
            pass
        
        
    def _assureDistinctValues(self, option_now, other_option):
        '''
        Faz coisas.
        '''
        try:
            option_val = self._getUnicodeValue(option_now)
            other_val = self._getUnicodeValue(other_option)
            
            if other_val == option_val:
                values = self.options[other_option]['values']
                
                try:
                    i = values.index(other_val)
                except ValueError:
                    pass
                
                opt = self.options[other_option]
                if opt['widget']:
                    new_value = values[ (i+1) % len(values) ]
                    opt['setter']( opt['widget'], new_value )
                    
        except KeyError:
            pass
        
        
    def _updateDependency(self, master_option):
        '''
        Atualiza o valor de todas as opções escravas que dependem
        da opção master_option.
        '''
        
        try:
            # Atualizar todas as opções escravas que dependem desta opção
            for slave_option in self.options[master_option]['slaves']:
                
                # Dependências da opção escrava
                slave_dep = self.slaves[slave_option]
                
                # Checar se há uma relação OR ou AND entre os valores mestres
                # desta opção
                conector = slave_dep.pop('__conector__', 'or')
                func = lambda x, y: x or y if conector == 'or' else x and y
                value = False if conector == 'or' else True
                
                # Aplicar o conector lógico apropriado aos valores mestres
                # desta opção para obter o valor final
                for master_option, master_values in slave_dep.items():
                    
                    try: master_val = self._getUnicodeValue(master_option)
                    except KeyError: continue 
                    
                    value = func(value, master_val in master_values)
                    
                slave_dep['__conector__'] = conector
                
                # Atualizando efetivamente a opção escrava
                self[slave_option] = value
        except KeyError:
            pass
    
    
    def _getUnicodeValue(self, option):
        '''
        Retorna o valor atual do widget.
        '''
        
        opt = self.options[option]
        try:
            val = opt['getter']( opt['widget'] )
        except TypeError:
            raise KeyError(option)
        
        if isinstance(val, QtCore.QVariant):
            val = val.toString()
        
        return str(val)
    
    
    def _updateStoredValue(self, option):
        '''
        Atualiza o valor atual da opção e o retorna (como um QVariant).
        '''
        opt = self.options[option]
        val = opt['getter'](opt['widget'])
        
        try:
            val = str(val.toString())
        except AttributeError:
            val = str(val)
            
            
        # Se o valor não for permitido, volte o widget ao valor
        # armazenado atualmente
        if opt['values'] and val not in opt['values']:
            self._updateWidgetValue(option)
        
        # Guardar o valor nas configurações
        self.settings.setValue(option, val)
        
        self._updateDependency(option)
        self._updateDistinctValues(option)
        
        
    def _updateWidgetValue(self, option):
        '''
        Atualiza o valor do widget de acordo com o valor atual armazenado
        nas configurações.
        '''
        opt = self.options[option]
        val = self.settings.value(option)
        
        opt['setter'](opt['widget'], val)
        
    
    def _getOptionDict(self, option):
        '''
        Retorna um dicionário padrão.
        '''
        try:
            d = self.options[option]
        except KeyError:
            d = {
                'widget': None,
                'category': 'main',
                'getter': None,
                'setter': None,
                'has_signal': False,
                'set_items': None,
                'values': [],
                'slaves': [],
                'distinct': None
                }
            self.options[option] = d
        
        return d
        
        
    def addCustomWidget(self, widget, specs, option='', category='main'):
        '''
        Adiciona o widget como editor de uma opção de configuração.
        
        - widget Widget que servirá como editor da opção de configuração.
        - specs Deve ser um dicionário com as seguintes chaves:
            - 'getter' Função que retorna o valor atual no widget. Deve ter a assinatura getter(widget: QWidget) -> object
            - 'setter' Função que ajusta o valor do widget. Deve ter a assinatura setter(widget: QWidget, value: QVariant)
            - 'set_items' Função que informa ao widget seus possíveis valores. Deve ter a assinatura setItems(widget: QWidget, values: list)
            - 'signal' Sinal que informa a mudança no valor do widget. Passe None para desabilitá-lo.
        - option Nome da opção de configuração que o widget irá editar. O
            padrão é o retornado por widget.objectName()
        - category Categoria da opção de configuração
        '''
        option = option or str(widget.objectName())
        
        if not option:
            debug('O nome da opção não foi especificado')
        
        option = str(option)
        
        if not specs['getter'] or not specs['setter']:
            debug('Nenhum getter ou setter especificado para a opção %s' % option)
            return False
        
        info('Adicionando a opção "%s"...' % option)
        d = self._getOptionDict(option)
        
        d['widget'] = widget
        d['category'] = category
        d['getter'] = specs['getter']
        d['setter'] = specs['setter']
        d['set_items'] = specs['set_items']
        
        if specs['signal']:
            getattr(d['widget'], specs['signal']).connect(
                        lambda: self._updateStoredValue(option) )
            d['has_signal'] = True
        
        if d['values']:
            self.restrict(option, d['values'])
        
        info('Atualizando a opcao')
        self._updateWidgetValue(option)
        return True
    
        
    def addWidget(self, widget, category='main', option='', property=''):
        '''
        Adiciona o widget como editor da opção option.
        
        Parâmetros:
        - widget Widget editor.
        - category Categoria da opção
        - option Nome da opção de configuração. Por padrão, é o nome retornado
            por widget.objectName()
        - property Propriedade do widget a ser utilizada. Por padrão, é a
            propriedade setada como USER. 
        '''
        
        try:
            if property:
                i = widget.metaObject().indexOfProperty(property)
                if i == -1:
                    raise KeyError(property)
                prop = widget.metaObject().property(i)
            else:
                prop = widget.metaObject().userProperty()
            
            if not( prop.isReadable() and prop.isWritable() ):
                return False
            
            specs = {
                     'getter': prop.read,
                     'setter': prop.write,
                     'set_items': None,
                     'signal': None
                     }
            
            if prop.hasNotifySignal():
                # Obter o sinal de mudança do valor do widget
                signature = prop.notifySignal().signature()
                name = signature.partition('(')[0]
                specs['signal'] = name
                
            
        except AttributeError:
            return False
        
        return self.addCustomWidget(widget, specs, option, category)
        