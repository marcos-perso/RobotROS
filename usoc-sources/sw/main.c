/* -------------------------------------------------------------
   -- DESCRIPTION:                                              
   -- Main SW component                                          
   --                                                           
   -- NOTES:
   -- 
   -- $Author: mmartinez $
   -- $Date: 2010-07-10 21:46:52 $
   -- $Name:  $
   -- $Revision: 1.1 $
   -- 
   ------------------------------------------------------------- */

#include "main.h"//

/* //int main(int argc, char **argv) */
/* int main() */
/* { */

/*     // Startup code */

/*     *R_LEDS = 0; */

/*     // Main loop */
/*     while (1) */
/*     { */
	
/* 	*R_LEDS  = *R_LEDS +1; */
	
/*     } */
    
/* } */
/* /#include "main.h"// */
//
    //void  _zpu_interrupt(void)
    //{
    //}

//volatile long * R_LEDS      = (volatile long *)0x08000040; // Trial register (R/W)


int main()
{
    //int t;
    //int b;

//    put("Hello world!\n");

    // Startup code
//    *R_LEDS  = 3;

//*R_LEDS = 4;

while (1)
{
    //*R_LEDS = *R_LEDS + 1;
    //*R_LEDS = 7;
    
}
//    //counter  = 0;
////
    // Infinite loop
//    for (;;)
//    {
//      printf("Hello world. 2!\n");
////    }

return 0;
}

void _premain(void)
{
//  volatile int *someRegister=(volatile int *)0;
//  volatile int *otherRegister=(volatile int *)4;
//  while (*someRegister!=0)
//    {
//      *otherRegister++;
//    }
main();
}


/*
---------------------------------------------------------
-- $Log: main.c,v $
-- Revision 1.1  2010-07-10 21:46:52  mmartinez
-- Files imported
--
-- Revision 1.3  2010-07-10 21:36:01  mmartinez
-- *** empty log message ***
--
-- Revision 1.2  2010-06-17 22:41:40  mmartinez
-- Basic behaviour completed
--
-- Revision 1.1  2010-06-13 08:40:19  mmartinez
-- File creation
--
---------------------------------------------------------
*/
