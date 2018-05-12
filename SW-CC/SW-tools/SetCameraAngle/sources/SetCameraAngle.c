/* ******************************** */
/* *** Set the speed of a motor *** */
/* ******************************** */

// ******************
// **** INCLUDES ****
// ******************
#include "SetCameraAngle.h"


/* ***************** */
/* *** FUNCTIONS *** */
/* ***************** */


/* ************ */
/* *** MAIN *** */
/* ************ */

int main(int argc, char *argv[])
{

    if (std::string(argv[1]) == "-h")
    {

	std::cout << "Controls the stepper motors of the camera" << std::endl;
	std::cout << "Usage: SetCameraAngle.x <STEPS1> <STEPS2>" << std::endl;
	std::cout << "\tSTEPS1: Horizontal steps to move camera" << std::endl;
	std::cout << "\tSTEPS2: Vertical steps to move camera" << std::endl;
	
    } else {

	// -------------------
	// --- Definitions ---
	// -------------------
	int Steps1 = atoi(argv[1]); // Horizontal motor
	int Steps2 = atoi(argv[2]); // Vertical motor

	std::cout << "Requesting steps for camera:" << std::endl;
	std::cout << "\tSteps1 : " << Steps1 << std::endl;
	std::cout << "\tSteps2 : " << Steps2 << std::endl;

	// Definitions
	CAMERAMOTIONCONTROLLIBS::SetCameraAngle(Steps1,Steps2);

    }

}
