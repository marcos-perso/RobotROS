/* ********************************************** */
/* *** My Own Layer 3 Protocol server ( C++ ) *** */
/* *** This server rmakes the interface with  *** */
/* *** the external world and the ROS system  *** */
/* ********************************************** */

// ******************
// **** INCLUDES ****
// ******************
#include "MOL3PServer.h"


/* ***************** */
/* *** FUNCTIONS *** */
/* ***************** */

void error(const char *msg)
{
    perror(msg);
    exit(1);
}

/* ************ */
/* *** MAIN *** */
/* ************ */

int main(int argc, char *argv[])
{

  // -------------------
  // --- Definitions ---
  // -------------------
  
  // Socket Definitions
  int sockfd, portno;
  socklen_t clilen;
  struct sockaddr_in serv_addr, cli_addr;

  int newsockfd;
  char buffer[MAX_BUFF];
  int NumberBytesRead;

  bool SocketActive = true;

  // -------------------------
  // --- Create the socket ---
  // -------------------------

  // Create the socket
  sockfd = socket(AF_INET, SOCK_STREAM, 0);
  if (sockfd < 0) 
    error("ERROR opening socket");
  bzero((char *) &serv_addr, sizeof(serv_addr));
  portno = PORT_MOL3P;
  serv_addr.sin_family = AF_INET;
  serv_addr.sin_addr.s_addr = INADDR_ANY;
  serv_addr.sin_port = htons(portno);
  // Bind socket
  if (bind(sockfd, (struct sockaddr *) &serv_addr,
	   sizeof(serv_addr)) < 0) 
    error("ERROR on binding");
  listen(sockfd,5);
  clilen = sizeof(cli_addr);

  // ---------------------------------------------
  // --- Accept an incoming connection         ---
  // --- Only the first connection is accepted ---
  // ---------------------------------------------

  
  // -----------------
  // --- MAIN LOOP ---
  // -----------------
  while(1)
    { // MAIN loop

      // Accepting a socket conection
      printf("SERVER: Accepting on port %d\n",portno);
      newsockfd = accept(sockfd,
			 (struct sockaddr *) &cli_addr,
			 &clilen);
      if (newsockfd < 0) { error("ERROR on accept");}
      SocketActive = true;

      while (SocketActive)
	{
	  
	  // Reading the incoming stream
	  bzero(buffer,MAX_BUFF);
	  NumberBytesRead = recv(newsockfd,buffer,MAX_BUFF,0);
	  std::cout << "Number bytes read : " << NumberBytesRead << std::endl;
	  if (NumberBytesRead <0)
	    {
	      fprintf(stderr, "recv: %s (%d)\n", strerror(errno), errno);
	      SocketActive = false;
	    } else {
	    
	    std::string Command(buffer);
	    std::cout << "COMMAND : " << Command << std::endl;
	    // Chop the incoming stream (with white spaces)
	    std::istringstream f(Command);
	    std::string s;
	    int i = 0;
	    std::vector<std::string> words;
	    while (getline(f, s,' '))
	      {
		std::cout << "[" << i << "]" << s << std::endl;
		words.push_back(s);
		i++;
	      }
	    
	    std::cout << "Number of words: " << i-1 << std::endl;
	    
	    // Once received, we deal with the data
	    // Flags
	    std::string Response = "NOK";
	    
	    /* // Get the MODULE name */
	    /* if (strcmp(words[0].c_str(),"LED") ==0) */
	    /* 	{ */
	    
	    /* 	  // Once received, we deal with the data */
	    /* 	  if (strcmp(words[1].c_str(),"SET") == 0) */
	    /* 	    { */
	    
	    /* 	      // ---> CAMERA_MOTOR_CONTROL H V */
	    /* 	      std::string LED_NUMBER = words[2]; // Horizontal */
	    /* 	      std::string LED_VALUE  = words[3]; // Vertical */
	    /* 	      std::cout << "*** ACTIVATING LEDS ***" << LED_NUMBER << std::endl; */
	    /* 	      std::cout << "\tLED NUMBER : " << LED_NUMBER << std::endl; */
	    /* 	      std::cout << "\tLED VALUE : "  << LED_VALUE << std::endl; */
	    /* 	      Response = "OK"; */
	    
	    /* 	    } */
	    /* 	} */
	    
	    // Write the confirmation back
	    std::cout << "SERVER: Writing Confirmation" << std::endl;
	    send(newsockfd , Response.c_str(), Response.size() , 0);
	  }
	  
	}
    }

  // Close the accepting file descriptor
  close(newsockfd);

  close(sockfd);
  return 0; 
     
}
