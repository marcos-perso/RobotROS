#ifndef ITC_H
#define ITC_H

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

namespace ITC
{

    // Connections
    int close_client(int sockfd);
    int ITC_connect_to_server(int server_port);
    int create_server(int server_port);
    int ITC_create_client_instance (int sockfd);
    
    // Read/Write
    bool ITC_writeString(int sockfd,std::string Command);
    std::string ITC_read (int sockfd,int length);
    std::string ITC_WaitAnswer (int sockfd);
    
}

#endif
