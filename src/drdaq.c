/*================================

 FILE:	drdaq.c

 DESCRIPTION:
 This file contains source for drdaq
 
 Revision history:
 ================================
 $Log: drdaq.c,v $
 Revision 1.2  2006/03/16 12:04:51  jemartins
 inicial revision

 ================================*/



#include <stdio.h>
#include <sys/time.h>
#include <unistd.h>
#include <asm/ioctl.h>

#include "../include/pico_lnx.h"

#define PORT 0
    
// int file;
int value;

int main (void)
{
    
    // OpenPort ();
    //printf("%5.2\t",value);   
}

int OpenPort (void)
{
    int file;
    int value;
   
    // Open the printer port
    file = open ("/dev/picopar0", PORT);
    if (file==0)
    {
        // printf("Failed\n");
        return -1;
    }
    // Set the product so the pico driver knows which sensor board we're talking to
    value = PRODUCT_DRDAQ;
    ioctl (file, IOCTL_PICO_SET_PRODUCT, &value);

    // Set scale adc
    value = SCALE_ADC;
    ioctl(file, IOCTL_PICO_SET_SCALE, &value);
	
    // Set read mode to double
    value = READ_MODE_DOUBLE;
    ioctl(file, IOCTL_PICO_SET_READ_MODE, &value);

    return file;
}

int LEDOn (int file)
{
    int value;
    
    // LED On
    value = 1 * DRDAQ_LED;
    ioctl(file, IOCTL_PICO_SET_DIGITAL_OUT, &value);
}
	
int LEDOff (int file)
{
    int value;
    
    // LED Off
    value = 0 * DRDAQ_LED;
    ioctl(file, IOCTL_PICO_SET_DIGITAL_OUT, &value);
}

float LeDados (int file, int sensor, int modo)
{
    int value;
    float saida;
    
    value = sensor;
    ioctl(file, IOCTL_PICO_GET_VALUE, &value);
    saida = value;
    
    if (modo==2) { 
        saida = (scale_sound(value))/10.0;
    }
    else if (modo==6) { 
        saida = (scale_temp(value))/10.0; 
    }
    else if (modo==7) { 
        saida = (scale_light(value))/10.0; 
    }		 

    return saida;
}

int ClosePort (int file)
{
    // Close printer port and exit
    // printf("Exiting...\n");
    close (file);
    return 0;
}




static int light[11][2] = {
{ 0, 0 },
{ 410, 20 },
{ 819, 40 },
{ 1229, 60 },
{ 1638, 110 },
{ 2048, 160 },
{ 2457, 230 },
{ 2867, 320 },
{ 3276, 440 },
{ 3686, 620 },
{ 4095, 1000 },
};

int scale_light(int adcCount)
{
	int i, diffScaled, diffRaw, diffAdc, scaledValue=0;
	double scaleFactor;
	for (i=0; i<10; i++)
	{
		if (adcCount >= light[i][0] && adcCount < light[i+1][0])
		{
			diffScaled = light[i+1][1] - light[i][1];
			diffRaw = light[i+1][0] - light[i][0];
			scaleFactor = (double)diffScaled / (double)diffRaw;
			diffAdc = adcCount - light[i][0];
			scaledValue = (diffAdc * scaleFactor) + light[i][1];
			return scaledValue;
		}
	}
	return -1;
}






static int temp[17][2] = {
{ 55, 1500 },
{ 216, 1000 },
{ 400, 800 },
{ 755, 600 },
{ 1384, 400 },
{ 1813, 300 },
{ 2048, 250 },
{ 2289, 200 },
{ 2530, 150 },
{ 2765, 100 },
{ 2985, 50 },
{ 3187, 0 },
{ 3366, -50 },
{ 3520, -100 },
{ 3756, -200 },
{ 3907, -300 },
{ 4046, -500 },
};

int scale_temp(int adcCount)
{
	int i, diffScaled, diffRaw, diffAdc, scaledValue=0;
	double scaleFactor;
	for (i=0; i<16; i++)
	{
		if (adcCount >= temp[i][0] && adcCount < temp[i+1][0])
		{
			diffScaled = temp[i][1] - temp[i+1][1];
			diffRaw = temp[i+1][0] - temp[i][0];
			scaleFactor = (double)diffScaled / (double)diffRaw;
			diffAdc = adcCount - temp[i][0];
			scaledValue = temp[i][1] - (diffAdc * scaleFactor);
			return scaledValue;
		}
	}
	return -1;
}






static int sound[48][2] = {
{ 0, 550 },
{ 3, 550 },
{ 4, 570 },
{ 5, 590 },
{ 6, 600 },
{ 7, 620 },
{ 8, 630 },
{ 9, 650 },
{ 10, 660 },
{ 11, 670 },
{ 13, 680 },
{ 14, 690 },
{ 16, 700 },
{ 17, 705 },
{ 19, 710 },
{ 23, 720 },
{ 28, 730 },
{ 34, 740 },
{ 41, 750 },
{ 50, 760 },
{ 61, 770 },
{ 73, 780 },
{ 89, 790 },
{ 108, 800 },
{ 131, 810 },
{ 159, 820 },
{ 193, 830 },
{ 213, 835 },
{ 242, 840 },
{ 275, 850 },
{ 313, 860 },
{ 357, 870 },
{ 406, 880 },
{ 462, 890 },
{ 526, 900 },
{ 599, 910 },
{ 682, 920 },
{ 777, 930 },
{ 885, 940 },
{ 1007, 950 },
{ 1147, 960 },
{ 1305, 970 },
{ 1486, 980 },
{ 1692, 990 },
{ 1926, 1000 },
{ 2193, 1010 },
{ 2497, 1020 },
{ 2843, 1030 },
};

int scale_sound(int adcCount)
{
	int i, diffScaled, diffRaw, diffAdc, scaledValue=0;
	double scaleFactor;
	for (i=0; i<47; i++)
	{
		if (adcCount >= sound[i][0] && adcCount < sound[i+1][0])
		{
			diffScaled = sound[i+1][1] - sound[i][1];
			diffRaw = sound[i+1][0] - sound[i][0];
			scaleFactor = (double)diffScaled / (double)diffRaw;
			diffAdc = adcCount - sound[i][0];
			scaledValue = (diffAdc * scaleFactor) + sound[i][1];
			return scaledValue;
		}
	}
	return -1;
}
