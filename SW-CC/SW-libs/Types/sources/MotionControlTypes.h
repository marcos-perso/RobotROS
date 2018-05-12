#ifndef MOTIONCONTROLTYPES_H
#define MOTIONCONTROLTYPES_H

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

namespace MotionControlTypes
{

    // ************************
    // *** CLASS PROTOTYPES ***
    // ************************
    class t_Transaction
    {
        // --- CONSTRUCTOR ---
    public:
        t_Transaction(char* SerializedData);
    
        // --- DESTRUCTOR ---
        ~t_Transaction();
    
        // --- METHODS ---
    
        // --- DATA MEMBERS ---
	char v_Value[4];
	
    };
    
}

#endif
