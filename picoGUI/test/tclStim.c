/*=======================================================
FILE:	tclStim.c

DESCRIPTION:
This module is used to stimulate the tclReceiver.tcl
script.

-------------------------
FCsoftware Inc. 1999
This code is released as open source.   We hope you find 
it useful.  If you discover a bug or add an enhancement 
we'd like to hear from you. 

	fcsoft@netcom.ca
-------------------------
Revision history:
 $Log: tclStim.c,v $
 Revision 1.3  2006/05/27 12:31:17  jemartins
 added include drdaqMsgs.h

 Revision 1.2  2006/03/08 19:20:48  bobfcsoft
 code cleanup

 Revision 1.1.1.1  2006/03/07 21:29:38  bobfcsoft
 startup

========================================================*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>

#include "tclReceiverMsgs.h"
#include "picoCourierMsgs.h"
#include "drdaqMsgs.h"

#define _ALLOC
#include "tclStim.h"
#undef _ALLOC

#include "tclStimProto.h"
#include "simplProto.h"
#include "loggerProto.h"

/*--------------------------------------
	tclStim - entry point
--------------------------------------*/
void main(int argc, char **argv, char **envp)
{
static char *fn="tclStim";
int maxfd;
char *p;
int x_it=0;
int n;

// for keyboard input
p=data;

initialize(argc,argv);
maxfd=my_fds[0];

while(!x_it)
	{
	printf("Enter command: ");
	fflush(stdout);

	inset = watchset;
	select(maxfd+1, &inset, NULL, NULL, NULL);

// check which file descriptors are ready to be read from

// Is this from keyboard
	if(FD_ISSET(my_fds[0], &inset))  // keyboard is ready
		{
		n=read(my_fds[0],p,80);
		p[n-1]=0;

		fcLogx(__FILE__, fn,
			globalMask,
			TCLSTIM_MARK,
			"%d bytes recd str=<%s>",n,p);

		switch(data[0])
			{
			case '?':  // help
				showUsage();
				break;

			case 'q':  // quit
				{
				FC_QUIT_MSG *outMsg;

				fcLogx(__FILE__, fn,
					globalMask,
					TCLSTIM_MARK,
					"sending FC_QUIT -> id=%d",
					toPid);

				outMsg=(FC_QUIT_MSG *)outArea;
				outMsg->token = FC_QUIT;
				Send(toPid, outArea, inArea,  sizeof(FC_QUIT_MSG), MAX_MSG_BUFFER_SIZE);
				x_it=1;
				}
				break;

			case 't':  // text
				{
				FC_TESTING_MSG *outMsg;

				fcLogx(__FILE__, fn,
					globalMask,
					TCLSTIM_MARK,
					"sending FC_TESTING -> id=%d with text=<%s>",
					toPid,
					&p[2]);

				outMsg=(FC_TESTING_MSG *)outArea;
				outMsg->token = FC_TESTING;
				sprintf(outMsg->text,"%.79s",&p[2]);
				Send(toPid, outArea, inArea, sizeof(FC_TESTING_MSG), MAX_MSG_BUFFER_SIZE);
				}
				break;

			case 'w':  // issue WHAT_YA_GOT
				{
				CR_WHAT_YA_GOT_MSG *outMsg;
				PICO_TOKEN *intoken;

				fcLogx(__FILE__, fn,
					globalMask,
					TCLSTIM_MARK,
					"sending WHAT_YA_GOT -> id=%d",
					toPid
					);

				outMsg=(CR_WHAT_YA_GOT_MSG *)outArea;
				outMsg->token = CR_WHAT_YA_GOT;
				Send(toPid, outArea, inArea, sizeof(CR_WHAT_YA_GOT_MSG), MAX_MSG_BUFFER_SIZE);

				intoken=(PICO_TOKEN *)inArea;
				fcLogx(__FILE__, fn,
					globalMask,
					TCLSTIM_MARK,
					"intoken=0x%X",
					*intoken
					);
				}
				break;

			default:
				printf("unknown command <%s>\n",p);
				break;
			} // end switch
		} // end if
	}// end while

name_detach();

}// end tclStim

/*============================================
	initialize - entry point
============================================*/
void initialize(int argc, char **argv)
{
static char *fn="initialize";
int i;                          /* loop variable */
char myName[20];
char toName[20];
char logger_name[20];
int myslot;

globalMask=0xffffffff;
myName[0]=0;
toName[0]=0;
logger_name[0]=0;

/*===============================================
  process command args
===============================================*/
for(i=1; i<=argc; ++i)
        {
        char *p = argv[i];

        if(p == NULL) continue;

        if(*p == '-')
                {
                switch(*++p)
                        {
                        case 'n':   // attach myName
				if(*++p == 0) p++;
				sprintf(myName,"%.19s",p);

				myslot=name_attach(myName, NULL);
				if (myslot == -1)
					{
					printf("%s: Can't attach as %s\n",fn,myName);
					exit(0);
					}
				break;

			case 'r':
				{
				if(*++p == 0) p++;
				sprintf(toName,"%.19s",p);

				toPid=name_locate(toName);
				}
				break;

			case 'l':
				if(*++p == 0) p++;
				sprintf(logger_name,"%.19s",p);
				break;

			default:
				printf("Bad command line switch `%c'\n", *p);
				break;
                        }/*end switch*/
                } /* end if *p */
        }/*end for i*/

// connect to error logger
logger_ID = is_logger_upx(logger_name);

// arm the select routine
my_fds[0] = STDIN_FILENO;  	// keyboard
FD_ZERO(&watchset);
FD_SET(my_fds[0], &watchset);

fcLogx(__FILE__, fn,
	0xff,	// force it to log
	TCLSTIM_MARK,
	"my name: <%s> slot=%d",
	myName,
	myslot
	);

fcLogx(__FILE__, fn,
	0xff,	// force it to log
	TCLSTIM_MARK,
	"gui name: <%s> slot=%d",
	toName,
	toPid
	);

} /* end initialize */

/*==================================================
	showUsage - entry point
==================================================*/
void showUsage()
{
printf("t <text> - send this text to tclReceiver\n");
printf("w - send the WHAT_YA_GOT token to GUI\n");
printf("q(uit)  - exit and kill tclReceiver\n");
} // end showUsage
