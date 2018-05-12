/* ******************************* */
/* *** Console ( C++ )         *** */
/* ******************************* */

// ******************
// **** INCLUDES ****
// ******************
#include "Console.h"




// **************
// **** MAIN ****
// **************
//int main(int argc, char ** argv) {
int main(int argc, char *argv[]) {

  // -------------------
  // --- Definitions ---
  // -------------------
  std::string message_in;

  if (argc < 1)
    { // ERROR CONDITIONS
    } else
    { // MAIN
  
      int sock;
      struct sockaddr_in server;
      char message[1000] , server_reply[2000];
      
      //Create socket
      sock = socket(AF_INET , SOCK_STREAM , 0);
      if (sock == -1)
	{
	  printf("Could not create socket");
	}
      puts("Socket created");
      
      server.sin_addr.s_addr = inet_addr("127.0.0.1");
      server.sin_family = AF_INET;
      server.sin_port = htons( PORT_MOL3P );
      
      //Connect to remote server
      if (connect(sock , (struct sockaddr *)&server , sizeof(server)) < 0)
	{
	  perror("connect failed. Error");
	  return 1;
	}
      
      puts("Connected\n");
      
      //keep communicating with server
      while(1)
	{
	  
	  std::cout << "[CMD]: ";
	  getline(std::cin,message_in);
	  std::cout << std::endl;

	  if (message_in == "H")
	    { // HELP
	      std::cout << "HELP : " << std::endl;
	      std::cout << "\t CAMERA_MOTOR_CONTROL X Y" << std::endl;
	    } else
	    { // NORMAL OPERATION
	  
	    //Send some data
	    std::cout << "Sending message : " << message_in << std::endl;
	    std::cout << "LENGHT : " << message_in.size() << std::endl;
	    if( send(sock , message_in.c_str() , message_in.size() , 0) < 0)
	      {
		puts("Send failed");
		return 1;
	      }
	    
	    //Receive a reply from the server
	    if( recv(sock , server_reply , sizeof(server_reply) , 0) < 0)
	      {
		puts("recv failed");
		break;
	      }
	    
	    puts("Server reply :");
	    puts(server_reply);
	  }

	}
	  
      close(sock);  
    }
  return 0;
}
