#!/usr/bin/env python3
# -*- coding: utf-8 -*-

'''
Este módulo contém o objeto de configuração global para o programa inteiro.

$Log: app_config.py,v $
Revision 1.2  2013/01/28 21:58:19  diogenes-silva
Finalizada a migração da sintaxe.

Revision 1.1  2013/01/28 20:55:36  diogenes-silva
Porting to Python3.

Revision 1.4  2012/11/27 23:46:51  diogenes-silva
Adicionada a opção de linha de comando --name=NAME para definir o nome do programa no SIMPL

Revision 1.3  2012/11/22 20:07:49  diogenes-silva
Alterado o nome de simpl_qobject para simplqobject

Revision 1.2  2012/11/12 15:23:28  diogenes-silva
Adicionada a classe SimplQObject, que fornece uma interface assíncrona ao SIMPL.

Revision 1.1  2012/11/01 17:59:43  diogenes-silva
Adicionada a chamada ao diálogo de ajuste da escala.

Revision 1.1  2012/10/24 17:50:08  diogenes-silva
Adicionado o drop-down para escolher "versus" ou "e" entre os sensores e agora intervalo e número de medições são botões Radio.

'''

import register_application
import sys
import codecs

from ConfigurationManager import ConfigurationManager

sys.stdout = codecs.getwriter('utf-8')(sys.__stdout__)

config = ConfigurationManager()

conectores = ('INT', 'EXT1', 'EXT2')
tipos      = ('Onda Sonora', 'Nível Sonoro', 'Voltagem',
              'Resistência', 'pH', 'Temperatura', 'Luz', 'Pêndulo')
unidades = ('', '', 'V', '', '', 'ºC', '', 'º')

config.restrict('sensor1_tipo', tipos)
config.restrict('sensor2_tipo', tipos)
config.restrict('sensor1_conector', conectores)
config.restrict('sensor2_conector', conectores + ('Tempo',))
#config.restrict('sensores_relacao', ('versus', 'e'))

config.setEnabledWhen('sensor1_calibrar', sensor1_tipo=('Pêndulo',) )
config.setEnabledWhen('sensor2_calibrar', sensor2_tipo=('Pêndulo',) )
config.setEnabledWhen('sensor2_tipoVisivel', sensor2_conector=conectores)
config.setEnabledWhen('sensor2_calibrarVisivel', sensor2_conector=conectores)
config.setEnabledWhen('autoEscala_configurar', autoEscala_habilitar=('false',))

for conector in conectores:
    config.setEnabledWhen('mostrador' + conector,
                          sensor1_conector=(conector,),
                          sensor2_conector=(conector,))

config.assureDistinctness('sensor1_conector', 'sensor2_conector')
