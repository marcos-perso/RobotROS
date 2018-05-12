#ifndef SERIALCOMMTYPES_H
#define SERIALCOMMTYPES_H

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

namespace SerialCommTypes
{

    // ************************
    // *** CLASS PROTOTYPES ***
    // ************************
    class t_SerialTransaction
    {
        // --- CONSTRUCTOR ---
    public:
        t_SerialTransaction(char* Address, char* Data);
        t_SerialTransaction(char* AddressData);
    
        // --- DESTRUCTOR ---
        ~t_SerialTransaction();
    
        // --- METHODS ---
	void serialize();
	void deserialize();
    
        // --- DATA MEMBERS ---
	char v_Address[9];
	char v_Data[9];
	char v_Serialized[17];
	
    };
    
}

#endif
