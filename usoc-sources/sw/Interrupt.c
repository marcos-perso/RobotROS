#include "Interrupt.h"

void  _zpu_interrupt(void)
{

    /* interrupts are enabled so we need to finish up quickly,
     * lest we will get infinite recursion!*/
    //  counter++;
/*    InterruptReg = *R_INTERRUPT; */

    // Treat the different possible interruptions
/*    if (InterruptReg == 1) */
/*    { */
	ButtonCaptionInterrupt();
/*    } */

    // We delete the interrupt
/*    *R_INTERRUPT = 0; */

}

//! Interrupt that is raised when a button is pressed
void ButtonCaptionInterrupt()
{
    *R_LEDS = *R_LEDS + 1;
}


