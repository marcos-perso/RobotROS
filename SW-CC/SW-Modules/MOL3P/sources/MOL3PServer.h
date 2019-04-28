#ifndef MOL3PSERVER_H
#define MOL3PSERVER_H


// ************************
// *** GENERAL INCLUDES ***
// ************************

/* A simple server in the internet domain using TCP
   The port number is passed as an argument */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h> 
#include <sys/socket.h>
#include <netinet/in.h>
#include <sstream>
#include <iostream>
#include <vector>

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

// ************************
// *** PROJECT INCLUDES ***
// ************************
#include "Ports.h"
#include "errno.h"
//#include "ITC.h"
//#include "MotionControlTypes.h"

// ******************
// *** PROTOTYPES ***
// ******************
void error(const char *msg);

// ******************
// *** PROTOTYPES ***
// ******************
#define MAX_BUFF 256


#endif
