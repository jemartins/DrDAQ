#!/usr/bin/env python
# -*- coding: utf-8 -*-

'''
Importe este módulo para registrar ao PyQt detalhes desta aplicação,
tais como nome, organização e domínio.

Revision history:
$Log: register_application.py,v $
Revision 1.2  2012/10/16 18:50:17  diogenes-silva
First version

'''

from PyQt4.QtCore import QCoreApplication, QSettings

QCoreApplication.setOrganizationDomain( 'fis.unb.br' )
QCoreApplication.setOrganizationName( 'labfis2' )
QCoreApplication.setApplicationName( 'DrDaq' )

QSettings.setDefaultFormat( QSettings.IniFormat )

del QCoreApplication
del QSettings
