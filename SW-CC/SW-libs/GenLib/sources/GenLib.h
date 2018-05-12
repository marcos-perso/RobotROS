#ifndef GENLIB_H
#define GENLIB_H

#include <stdio.h>
#include <string.h>
#include <sstream>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <iostream>
#include <iomanip>
#include <termios.h> 

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>

namespace GenLib
{

    // Function to extend with a character the beginning of a string up to X characters
    std::string Extend(std::string Value, int NumChars);
    // Function to transform integer to string
    std::string IntToString (int Number );
    // Function to transform positive number to formatted string
    std::string PosIntToFormattedString(int Number,int digits);
    // Function to transform string to integer
    int StringToInt(const std::string &Text);
    // Function to transform an integer (dec) into hex
    std::string int_to_hex( int i,int digits );

}

#endif
