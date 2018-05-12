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
  int sockfd, newsockfd, portno;
  socklen_t clilen;
  char buffer[256];
  struct sockaddr_in serv_addr, cli_addr;
  int NumberBytesRead;

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
  
  // -------------------------------
  // --- MAIN LOOP OF ACCEPTANCE ---
  // -------------------------------
  while(1)
    { // MAIN loop

      // Accepting a socket conection
      printf("SERVER: Accepting on port %d\n",portno);
      newsockfd = accept(sockfd, 
			 (struct sockaddr *) &cli_addr, 
			 &clilen);
      if (newsockfd < 0) { error("ERROR on accept");}

      // Reading the incoming stream
      bzero(buffer,256);
      NumberBytesRead = read(newsockfd,buffer,255);
      if (NumberBytesRead < 0) error("ERROR reading from socket");
      std::string Command(buffer);
      std::cout << "COMMAND : " << Command << std::endl;

      // Chop the incoming stream
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

      std::cout << std::endl;

      // Once received, we deal with the data
      if (strcmp(words[0].c_str(),"CAMERA_MOTOR_CONTROL") ==0)
	{
	  // ---> CAMERA_MOTOR_CONTROL H V
	  std::string LVAL = words[1];
	  std::string RVAL = words[2];
	  std::cout << "\rL : " << LVAL << std::endl;
	  std::cout << "\rR : " << RVAL << std::endl;
	  
	  std::cout << "SERVER: Writing back: " << LVAL.c_str() << std::endl;
	  send(newsockfd , LVAL.c_str() , LVAL.size() , 0);
	  
	} else
	{
	  std::cout << "COMMAND NOT FOUND" << std::endl;
	}

      // Close the accepting file descriptor
      close(newsockfd);
      
    }

  close(sockfd);
  return 0; 
     
}
