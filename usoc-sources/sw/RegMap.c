#include "RegMap.h"

/* ************************ */
/* *** SoC register map *** */
/* ************************ */

volatile long * R_LEDS      = (long *)0x08000040; // Trial register (R/W)
volatile long * R_TICPERIOD = (long *)0x080a0080; // TIC Period
volatile long * R_INTERRUPT = (long *)0x080a0060; // Interrupt register
volatile long * R_IO        = (long *)0x080a0100; // Interrupt register
