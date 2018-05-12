/* ********************************* */
/* *** SerialCom ( C++ )         *** */
/* ********************************* */

// ******************
// **** INCLUDES ****
// ******************
#include "CameraMotionControlLibs.h"

// *****************************
// **** FUNCTION DEFINITION ****
// *****************************

// **************
// **** MAIN ****
// **************

namespace CAMERAMOTIONCONTROLLIBS
{


    // Function to Set the speed of a motor
    bool SetCameraAngle(int StepsH, int StepsV)
    {

	// Sockets
	int sockfd_ToCameraMotionControl;

	// We create the data for the transaction to the CameraMotioControl server
	// Syntax:
	// YZZZABBB where:
	//      Y the direction of the horizontal motor (1 = positive, 0 = negative)
	//      ZZZ is the speed of the motor (0-100) (in HEX)
	//      A the direction of the vertical motor (1 = positive, 0 = negative)
	//      BBB is the speed of the motor (0-100) (in HEX)

	std::string string_StepsH = GenLib::PosIntToFormattedString(abs(StepsH),3);
	std::string string_StepsV = GenLib::PosIntToFormattedString(abs(StepsV),3);
	std::string string_DirectionH;
	std::string string_DirectionV;

	if (StepsH < 0) { string_DirectionH = "0"; } else { string_DirectionH = "1"; }
	if (StepsV < 0) { string_DirectionV = "0"; } else { string_DirectionV = "1"; }

	std::string Command = string_DirectionH + string_StepsH + string_DirectionV + string_StepsV;

	std::cout << "Setting the speed of a motor:" << std::endl;
	std::cout << "\t HORIZONTAL:" << std::endl;
	std::cout << "\t\tDIRECTION: " << string_DirectionH << std::endl;
	std::cout << "\t\tSTEPS: " << string_StepsH << std::endl;
	std::cout << "\t VERTICAL:" << std::endl;
	std::cout << "\t\tDIRECTION: " << string_DirectionV << std::endl;
	std::cout << "\t\tSTEPS: " << string_StepsV << std::endl;
	std::cout << "\tCOMMAND: " << Command << std::endl;

	// We send the transaction to CameraMotionControl server
	sockfd_ToCameraMotionControl = ITC::ITC_connect_to_server(PORT_CAMERAMOTIONCONTROL);
	ITC::ITC_writeString(sockfd_ToCameraMotionControl,Command);
	sockfd_ToCameraMotionControl = ITC::close_client(sockfd_ToCameraMotionControl);
	
	
    }

}
