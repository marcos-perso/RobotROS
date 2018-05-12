#ifndef SERIALCOMM_H
#define SERIALCOMM_H

// ************************
// *** GENERAL INCLUDES ***
// ************************

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <iostream>
#include <termios.h> 

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>

#define CPPFIO_I
#define CPPFIO_I_stdlib
#define CPPFIO_I_unistd
#define CPPFIO_I_string
#define CPPFIO_CmdLine
#define CPPFIO_ComSerie
#define CPPFIO_PTimer
#define CPPFIO_ErrorLog
#define CPPFIO_File
#define CPPFIO_Chrono
#define CPPFIO_Helpers
#include <cppfio.h>

// ************************
// *** PROJECT INCLUDES ***
// ************************

#include "Ports.h"
#include "ITC.h"
#include "GenLib.h"
#include "SerialCommTypes.h"

// ******************
// *** PROTOTYPES ***
// ******************

static unsigned ReadTO(char *buffer, unsigned size, bool exact=true,
                       unsigned toMult=1);

int WriteAddress(int Address, int Data);

// *******************
// *** DEFINITIONS ***
// *******************

static const char *portName="/dev/ttyACM0";

using namespace cppfio;

struct termios newtio;
struct termios oldtio;
static ComSerie *ser;


    

#endif
