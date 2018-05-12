/* ********************************* */
/* *** SerialCom ( C++ )         *** */
/* ********************************* */

// ******************
// **** INCLUDES ****
// ******************
#include "ITC.h"

// *****************************
// **** FUNCTION DEFINITION ****
// *****************************

// **************
// **** MAIN ****
// **************

namespace ITC
{

    // Function to create a client connection
    int close_client(int sockfd)
    {
	close(sockfd);
    }

    // Function to create a client connection
    int ITC_connect_to_server(int server_port)
    {

	std::cout << "Creating a client connection...";

	int sockfd, portno = server_port;
	struct sockaddr_in serv_addr;
	// Create the socket
	sockfd = socket(AF_INET, SOCK_STREAM, 0);
	if (sockfd < 0)
	    std::cout << "ERROR opening socket" << std::endl;
	bzero(&serv_addr, sizeof(serv_addr));
	serv_addr.sin_family = AF_INET;
	serv_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
	serv_addr.sin_port = htons(portno);

	if (connect(sockfd, (struct sockaddr *) &serv_addr, sizeof(serv_addr)) == 0) 
	{
	    printf("Client connecting to server\n");
	}
	else
	{
	    std::cout << "ERROR connecting" << std::endl;
	}

	std::cout << "Created." << std::endl;

	return sockfd;
	
    }
    
    // Function to create a server connection
    int create_server(int server_port)
    {

	std::cout << "Creating a server connection with port " << server_port << "...";
	// socket stuff
	int sockfd, newsockfd, portno = server_port;
	struct sockaddr_in serv_addr;
    
	sockfd = socket(AF_INET,SOCK_STREAM,0);
	if (sockfd < 0)
	{
	    std::cout << "ERROR opening socket" << std::endl;
	}
	// Clear address structure
	bzero((char *) &serv_addr,sizeof(serv_addr));

	// Setup the host_addr structure for use in bind call
	// server byte order
	serv_addr.sin_family = AF_INET;
	serv_addr.sin_addr.s_addr = INADDR_ANY;
	serv_addr.sin_port = htons(portno);
    
	serv_addr.sin_family = AF_INET;
    
	// This bind() call will bind  the socket to the current IP address on port
	if (bind(sockfd, (struct sockaddr *) &serv_addr, sizeof(serv_addr)) < 0) {
	    std::cout << "ERROR on binding" << std::endl;
	}

	// This listen() call tells the socket to listen to the incoming connections.
	// The listen() function places all incoming connection into a backlog queue
	// until accept() call accepts the connection.
	// Here, we set the maximum size for the backlog queue to 5.
	listen(sockfd,5);

	std::cout << "Created." << std::endl;

	return sockfd;

    }


    int ITC_create_client_instance (int sockfd)
    {

	int newsockfd;

	newsockfd = accept(sockfd, 0, 0);
	if (newsockfd > 0)
	{
	} else {
	    std::cout << "ERROR on accept" << std::endl;
	}
	return newsockfd;

    }

    // ***************************************
    // *** Function to write in the socket ***
    // ***************************************
    bool ITC_writeString(int sockfd,std::string Command)
    {
	// -------------------
	// --- Definitions ---
	// -------------------
	// We create the transaction
	char * MyCommand = new char [Command.length()+1];
	strcpy(MyCommand,Command.c_str());

	// ------------
	// --- Body ---
	// ------------
	write(sockfd, MyCommand, strlen(MyCommand));
	std::cout << "Written" << std::endl;
    }

    std::string ITC_read (int sockfd,int length)
    {

	int newsockfd;

	char buf[length+1];
	bzero(buf,length+1);
	buf[length] = '\0';
	
	int count = read(sockfd, buf, length);

	std::string Rx(buf,length);

	return Rx;

    }

    std::string ITC_WaitAnswer(int sockfd)
    {

	int newsockfd;

	// Now we read from the socket
	char buf[9];
	bzero(buf,9);
	buf[8] = '\0';

	int count = read(sockfd, buf, 8);
	std::cout << "OUT : " << count << std::endl;

	std::string Rx(buf,8);
	
	return Rx;

    }
    
	

}
