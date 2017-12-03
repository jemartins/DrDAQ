/*************************************************************

FILE:		fileMerger.c

DESCRIPTION:	
This program is the filter for merging vTcl and Tcl files. 

-----------------------------------------------------------------------
    Copyright (C) 2006 DrDAQ Application Project. 

    This software is in the public domain.
    Permission to use, copy, modify, and distribute this software and its
    documentation for any purpose and without fee is hereby granted, 
    without any conditions or restrictions.
    This software is provided "as is" without express or implied warranty.

    If you discover a bug or add an enhancement here's how to reach us: 

	https://sourceforge.net/projects/drdaq
-----------------------------------------------------------------------
Revision history:
=======================================================
$Log: fileJoiner.c,v $
Revision 1.1  2006/04/29 00:52:37  bobfcsoft
fileJoiner added

=======================================================

*************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *skipOverWhiteSpace(char *start);

int main(void)
{
char line[128];
char command[128];
char *p;

while(fgets(line,127,stdin) != NULL)
	{
	line[strlen(line)]=0;

	switch(line[0])
		{
		case '#':
			if(memcmp(line,"#include",8) == 0)
				{
				line[strlen(line)-1]=0; // get rid of CR
				p=skipOverWhiteSpace(&line[8]);
				
				sprintf(command,"cat %s",p);
				system(command);
				}
			else
				printf("%s",line);	
			break;

		default:
			printf("%s",line);	
			break;
		}

	memset(line,0,128);
	fflush(stdout);
	}

return(0);
}

/*=========================================
	skipOverWhiteSpace - entry point
=========================================*/
char *skipOverWhiteSpace(char *start)
{
char *p;

for(p=start; *p != 0 && *p != ' ' && *p != 0x09; p++);  // skip to whitespace
if(*p != 0)
	{
	for(; *p == ' ' || *p == 0x09; p++); // skip whitespace
	}

return(p);
}// end skipOverWhiteSpace

