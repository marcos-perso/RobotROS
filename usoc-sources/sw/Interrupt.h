#ifndef INTERRUPT_H
#define INTERRUPT_H

#include "Variables.h"
#include "RegMap.h"

// To compile: zpu-elf-gcc test.c -o test.elf -phi
// To run:  

extern volatile int   counter;
extern volatile long* R_INTERRUPT;
extern volatile long* R_LEDS;
extern volatile long* R_IO;

// main Interruption treatment function
void  _zpu_interrupt(void);

// Interruption functions
void ButtonCaptionInterrupt();



#endif
