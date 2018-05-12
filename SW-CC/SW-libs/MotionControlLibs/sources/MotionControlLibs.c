/* ********************************* */
/* *** SerialCom ( C++ )         *** */
/* ********************************* */

// ******************
// **** INCLUDES ****
// ******************
#include "MotionControlLibs.h"

// *****************************
// **** FUNCTION DEFINITION ****
// *****************************

// **************
// **** MAIN ****
// **************

namespace MOTIONCONTROLLIBS
{


    // Function to Set the speed of a motor
    bool SetMotorSpeed(int Speed0, int Speed1)
    {

	// Sockets
	int sockfd_ToMotionControl;

	// We create the data for the transaction to the MotioControl server
	// Syntax:
	// YZZZABBB where:
	//    MOTOR 0:
	//      Y the direction of the motor (1 = positive, 0 = negative)
	//      ZZZ is the speed of the motor (0-100)
	//    MOTOR 1:
	//      A the direction of the motor (1 = positive, 0 = negative)
	//      BBB is the speed of the motor (0-100)

	std::string string_Speed0 = GenLib::PosIntToFormattedString(abs(Speed0),3);
	std::string string_Direction0;
	std::string string_Speed1 = GenLib::PosIntToFormattedString(abs(Speed1),3);
	std::string string_Direction1;

	if (Speed0 < 0) { string_Direction0 = "0"; } else { string_Direction0 = "1"; }
	if (Speed1 < 0) { string_Direction1 = "0"; } else { string_Direction1 = "1"; }
	

	std::string Command = string_Direction0 + string_Speed0 + string_Direction1 + string_Speed1;

	std::cout << "Setting the speed of a motor:" << std::endl;
	std::cout << "\tMOTOR 0: " << std::endl;
	std::cout << "\t\tDIRECTION: " << string_Direction0 << std::endl;
	std::cout << "\t\tSPEED: " << string_Speed0 << std::endl;
	std::cout << "\tMOTOR 1: " << std::endl;
	std::cout << "\t\tDIRECTION: " << string_Direction1 << std::endl;
	std::cout << "\t\tSPEED: " << string_Speed1 << std::endl;
	std::cout << "\tCOMMAND: " << Command << std::endl;

	// We send the transaction to MotionControl server
	sockfd_ToMotionControl = ITC::ITC_connect_to_server(PORT_MOTIONCONTROL);
	ITC::ITC_writeString(sockfd_ToMotionControl,Command);
	sockfd_ToMotionControl = ITC::close_client(sockfd_ToMotionControl);
	
	
    }

}
