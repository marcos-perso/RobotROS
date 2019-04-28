/* ********************************* */
/* *** SerialCom ( C++ )         *** */
/* ********************************* */

// ******************
// **** INCLUDES ****
// ******************
#include "SerialCommLibs.h"

// *****************************
// **** FUNCTION DEFINITION ****
// *****************************

// **************
// **** MAIN ****
// **************

namespace SERIALCOMMLIBS
{


    // Function to write into a register
    bool WriteRegister(std::string Address, std::string Data)
    {
//	// ------------------- 
//	// --- Definitions ---
//	// ------------------- 
//	int sockfd_tx;
//
//	// We create the data for the transaction with SerialComm server.
//	// Syntax:
//	// OXXXXXXXYYYYYYYY where:
//	//     O is the operation (W = Write; R = READ)
//	//     XXXXXXXX is the address in hex format
//	//     YYYYYYYY is the data in hex format
//
//	std::string Command = "W" + GenLib::Extend(Address,8) + GenLib::Extend(Data,8);
//
//	std::cout << "SERIALCOMMLIBS:\tCOMMAND: " << Command << std::endl;
//
//	sockfd_tx = ITC::ITC_connect_to_server(PORT_SERIALCOMM);
//	ITC::ITC_writeString(sockfd_tx,Command);
//	sockfd_tx = ITC::close_client(sockfd_tx);
      return true;
    }
//
//    // ***************************************
//    // *** Function to read froma register ***
//    // ***************************************
    std::string ReadRegister(const std::string Address)
    {
//
//	// ------------------- 
//	// --- Definitions ---
//	// ------------------- 
//	int sockfd_tx;
//
//	// ------------
//	// --- Body ---
//	// ------------
//
//	// We create the data for the transaction with SerialComm server.
//	// Syntax:
//	// OXXXXXXXYYYYYYYY where:
//	//     O is the operation (W = Write; R = READ)
//	//     XXXXXXXX is the address in hex format
//	//     YYYYYYYY is the data in hex format
//
//	std::string Command = "R" + GenLib::Extend(Address,8) + "00000000";
//	std::cout << "SERIALCOMMLIBS:\tCOMMAND: " << Command << std::endl;
//
//	sockfd_tx = ITC::ITC_connect_to_server(PORT_SERIALCOMM);
//	ITC::ITC_writeString(sockfd_tx,Command);
//
//	std::string Rx = ITC::ITC_WaitAnswer(sockfd_tx);
//	//std:: cout << "Value read: " << Rx << std:: endl;
//
//	sockfd_tx = ITC::close_client(sockfd_tx);
//	
      std::string Rx = "Marcos";
	return Rx;
    }
    

}
