/* ********************************* */
/* *** SerialCom ( C++ )         *** */
/* ********************************* */

// ******************
// **** INCLUDES ****
// ******************
#include "MotionControlTypes.h"

// *****************************
// **** FUNCTION DEFINITION ****
// *****************************

// **************
// **** MAIN ****
// **************

namespace MotionControlTypes
{
    // ************************
    // *** CLASS DEFINITION ***
    // ************************

    // --- CONSTRUCTOR ---
    t_Transaction::t_Transaction(char * SerializedData)
    {
	strncpy(v_Value,SerializedData,4);
//	std::cout << "Building Serialized : " << v_Serialized << std::endl;
    }
    
    // --- DESTRUCTOR ---
    t_Transaction::~t_Transaction()
    {
    }
    
    // --- METHODS ---
    
}
