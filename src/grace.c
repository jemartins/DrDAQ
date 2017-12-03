/*====================================

 FILE:	grace.c


    Copyright (C) 2006 DrDAQ Application Project.

    This software is in the public domain.
    Permission to use, copy, modify, and distribute this software and its
    documentation for any purpose and without fee is hereby granted,
    without any conditions or restrictions.
    This software is provided "as is" without express or implied warranty.

    If you discover a bug or add an enhancement here's how to reach us:

        https://sourceforge.net/projects/drdaq


 Revision history:
 ======================================
 $Log: grace.c,v $
 Revision 1.3  2006/05/15 18:20:06  jemartins
 added Copyright

 Revision 1.2  2006/03/16 12:04:51  jemartins
 inicial revision
 
 ======================================*/


#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <grace_np.h>

#ifndef EXIT_SUCCESS
#  define EXIT_SUCCESS 0
#endif

#ifndef EXIT_FAILURE
#  define EXIT_FAILURE -1
#endif

int main (void)
{
	OpenGrace ();
	//InitGrace (100, 10000, 10, 5, 1000, 500);
	//PlotaGrace (10.0, 20.0, 100.0, 1000.0, 1, 0);
	GravaDados ();
}

int OpenGrace(void)
{
    /* Start Grace with a buffer size of 2048 and open the pipe */
    if (GraceOpen(2048) == -1) {
        return EXIT_FAILURE;
    } else {
        return EXIT_SUCCESS;
    }
    
}

int SetEscala (float max_x, float max_y, float major_tick_x, float minor_tick_x, float major_tick_y, float minor_tick_y)
{
 if (GraceIsOpen()) {
    /* Send some initialization commands to Grace */
    GracePrintf ("world xmax %5.2f", max_x);
    GracePrintf ("world ymax %5.2f", max_y);
    GracePrintf ("xaxis tick major %5.2f", major_tick_x);
    GracePrintf ("xaxis tick minor %5.2f", minor_tick_x);
    GracePrintf ("yaxis tick major %5.2f", major_tick_y);
    GracePrintf ("yaxis tick minor %5.2f", minor_tick_y);
    return EXIT_SUCCESS;
 } else {
    return EXIT_FAILURE;
 }
}

int SetSimbolo (int nchan)
{

int i;

 if (GraceIsOpen()) {
	for (i=0; i<nchan; i++)
	{
        GracePrintf ("s%d on", i);
        GracePrintf ("s%d symbol 1", i);
        GracePrintf ("s%d symbol size 0.3", i);
		GracePrintf ("s%d symbol color 1", i);
        GracePrintf ("s%d symbol fill pattern 1", i);
		GracePrintf ("s%d line color 1", i);
    }
    return EXIT_SUCCESS;
 } else {
    return EXIT_FAILURE;
 }
}

int PlotaGrace (float x1, float y1, float x2, float y2,  int nchan)
{

int i;

    if (GraceIsOpen()) {        
        	
		if (nchan==2) {
            GracePrintf ("g0.s0 point %5.2f, %5.2f", x1, y1);
	    	GracePrintf ("g0.s1 point %5.2f, %5.2f", x2, y2);
        } 
        else {
            GracePrintf ("g0.s0 point %5.2f, %5.2f", x1, y1);
        }

        return EXIT_SUCCESS;
        
    } else {
        return EXIT_FAILURE;
    }
}

int GravaDados (void)
{
    if (GraceIsOpen()) {
        /* Tell Grace to save the data */
        GracePrintf ("saveall \"sample.agr\"");

        /* Flush the output buffer and close Grace */
        // GraceClose();

        /* We are done */
        return EXIT_SUCCESS;
    } else {
        return EXIT_FAILURE;
    }
}

