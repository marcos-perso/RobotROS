/* ********************************* */
/* *** SerialCom ( C++ )         *** */
/* ********************************* */

// ******************
// **** INCLUDES ****
// ******************
#include "CameraMotionControl.h"

// *****************************
// **** FUNCTION DEFINITION ****
// *****************************

// **************
// **** MAIN ****
// **************

int main(int argc, char ** argv) {

    // ------------------- 
    // --- Definitions ---
    // ------------------- 
    int sockfd, sockfd_tx;
    char Command_Right_hex[2];
    char Command_Left_hex[2];
    char Command_Address_hex[] = "02000100";
    char Command_Data_hex[16];

    // -------------------------------
    // -- Open serial communication --
    // -------------------------------

    // -------------------------------
    // -- Open communication socket --
    // -------------------------------
    sockfd = ITC::create_server(PORT_CAMERAMOTIONCONTROL);

    // -----------------------
    // -- Clean everything --- 
    // -----------------------

    // ------------------------------------
    // -- MAIN ITERATION FOR THE SERVER --- 
    // ------------------------------------

    //    while (1)
     //   {

//	// Wait for a request
//	int newsockfd = ITC::ITC_create_client_instance(sockfd);
//	std::string Rx = ITC::ITC_read(newsockfd,8);
//	std:: cout << "CAMERAMOTIONCONTROL: Received " << Rx << std::endl;
//
//	// Now we transform it to controls to be sent to the serial interface
//	// Extract the speed
//	std::string DirH = Rx.substr(0,1);
//	std::string StepsH = Rx.substr(1,3);
//	std::string DirV = Rx.substr(4,1);
//	std::string StepsV = Rx.substr(5,3);
//
//	std::cout << "CAMERAMOTIONCONTROL: Applying ..." << std::endl;
//	std::cout << "\t: Horizontal : " << std::endl;
//	std::cout << "\t\t: Dir   : " << DirH << std::endl;
//	std::cout << "\t\t: Steps : " << StepsH << std::endl;
//	std::cout << "\t: Vertical : " << std::endl;
//	std::cout << "\t\t: Dir   : " << DirV << std::endl;
//	std::cout << "\t\t: Steps : " << StepsV << std::endl;
//
//	std::string Address;
//	std::string Data;
//
//	// WRITE horizontal MOTOR 
//
//	// Set up the direction
//	Address = "2000106";
//	SERIALCOMMLIBS::WriteRegister(Address,DirH);
//
//	// Set up the speed
//	Address = "2000100";
//	SERIALCOMMLIBS::WriteRegister(Address,StepsH);
//
//	// WRITE vertical MOTOR 
//
//	// Set up the direction
//	Address = "2000116";
//	SERIALCOMMLIBS::WriteRegister(Address,DirV);
//
//	// Set up the speed
//	Address = "2000110";
//	SERIALCOMMLIBS::WriteRegister(Address,StepsV);
//
//	// Move the motor
//	std::cout << "Moving motor" << std::endl;
//	Address = "2000105";
//	Data = "1";
//	SERIALCOMMLIBS::WriteRegister(Address,Data);
//
//	// Move the motor
//	std::cout << "Moving motor" << std::endl;
//	Address = "2000115";
//	Data = "1";
//	SERIALCOMMLIBS::WriteRegister(Address,Data);
//
//	
//    }

      return 0;

    }
