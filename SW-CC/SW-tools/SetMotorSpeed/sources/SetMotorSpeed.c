/* ******************************** */
/* *** Set the speed of a motor *** */
/* ******************************** */

// ******************
// **** INCLUDES ****
// ******************
#include "SetMotorSpeed.h"


/* ***************** */
/* *** FUNCTIONS *** */
/* ***************** */


/* ************ */
/* *** MAIN *** */
/* ************ */
using namespace ITC;

int main(int argc, char *argv[])
{

    if (std::string(argv[1]) == "-h")
    {

	std::cout << "Set speed in PWM motors (motion)" << std::endl;
	std::cout << "Usage: SetMotorSpeed.x <Speed0> <Speed1>" << std::endl;
	std::cout << "\tSpeed0: Speed (-100 to 100) of Motor 0" << std::endl;
	std::cout << "\tSpeed1: Speed (-100 to 100) of Motor 1" << std::endl;
	
    } else {

	// -------------------
	// --- Definitions ---
	// -------------------

	int Speed0 = atoi(argv[1]);
	int Speed1 = atoi(argv[2]);

	// ------------
	// --- MAIN ---
	// ------------

	std::cout << "Requesting speed for motor:" << std::endl;
	std::cout << "\tMotor0 : " << Speed0 << "% of max speed" << std::endl;
	std::cout << "\tMotor1 : " << Speed1 << "% of max speed" <<std::endl;

	// Definitions
	MOTIONCONTROLLIBS::SetMotorSpeed(Speed0,Speed1);
    
    }
    

}
