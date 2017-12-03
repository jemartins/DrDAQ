/*******************************
 
 drdaq.i

 Revisions:
 *******************************
 $Log: drdaq.i,v $
 Revision 1.2  2006/03/16 12:04:51  jemartins
 inicial revision

 *******************************/

%module drdaq
%{
extern int OpenPort (void);
extern int LEDOn (int file);
extern int LEDOff (int file);
extern float LeDados (int file, int sensor, int modo);
extern int ClosePort (int file);
%}

extern int OpenPort (void);
extern int LEDOn (int file);
extern int LEDOff (int file);
extern float LeDados (int file, int sensor, int modo);
extern int ClosePort (int file);

