/* ********************************* */
/* *** SerialCom ( C++ )         *** */
/* ********************************* */

// ******************
// **** INCLUDES ****
// ******************
#include "MotionControl.h"

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
    sockfd = ITC::create_server(PORT_MOTIONCONTROL);

    // -----------------------
    // -- Clean everything --- 
    // -----------------------

    // ------------------------------------
    // -- MAIN ITERATION FOR THE SERVER --- 
    // ------------------------------------

    while (1)
    {

	// Wait for a request
	int newsockfd = ITC::ITC_create_client_instance(sockfd);
	std::string Rx = ITC::ITC_read(newsockfd,8);
	std:: cout << "MOTIONCONTROL: Received " << Rx << std::endl;

	// Now we transform it to controls to be sent to the serial interface
	// Extract the speed
	std::string Dir0 = Rx.substr(0,1);
	std::string Speed0 = Rx.substr(1,3);
	std::string Dir1 = Rx.substr(4,1);
	std::string Speed1 = Rx.substr(5,3);

	std::cout << "MOTIONCONTROL: Applying ..." << std::endl;
	std::cout << "\t: MOTOR 0 : " << std::endl;
	std::cout << "\t\t: Dir   : " << Dir0 << std::endl;
	std::cout << "\t\t: Speed : " << Speed0 << std::endl;
	std::cout << "\t: MOTOR 1 : " << std::endl;
	std::cout << "\t\t: Dir   : " << Dir1 << std::endl;
	std::cout << "\t\t: Speed : " << Speed1 << std::endl;

	std::string Address;
	std::string Data;
	// Data is constructed by:
	// 3 LSBytes:  Hex Speed in 32 MHz steps. 64000(dec) = 100% 
	// Bit 25: Direction

	int Speed0_Int = (100 - GenLib::StringToInt(Speed0)) * 64000 / 100;
	int Speed1_Int = (100 - GenLib::StringToInt(Speed1)) * 64000 / 100;

	std::cout << std::endl;

	// Set up the speed of motor 0
	Data = Dir0 + GenLib::int_to_hex(Speed0_Int,6);
	std::cout << "MOTOR0 : " << Data << std::endl;
	Address = "2000400";
	SERIALCOMMLIBS::WriteRegister(Address,Data);

	// Set up the speed of motor 1
	Data = Dir1 + GenLib::int_to_hex(Speed1_Int,6);
	std::cout << "MOTOR1 : " << Data << std::endl;
	Address = "2000401";
	SERIALCOMMLIBS::WriteRegister(Address,Data);
	
    }

    return 0;

}
