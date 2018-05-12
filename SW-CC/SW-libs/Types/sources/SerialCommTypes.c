/* ********************************* */
/* *** SerialCom ( C++ )         *** */
/* ********************************* */

// ******************
// **** INCLUDES ****
// ******************
#include "SerialCommTypes.h"

// *****************************
// **** FUNCTION DEFINITION ****
// *****************************

// **************
// **** MAIN ****
// **************

namespace SerialCommTypes
{
    // ************************
    // *** CLASS DEFINITION ***
    // ************************

    // --- CONSTRUCTOR ---
    t_SerialTransaction::t_SerialTransaction(char* Address, char* Data)
    {
	strncpy(v_Address,Address,8);
	v_Address[8] = '\0';
	strncpy(v_Data,Data,8);
	v_Data[8] = '\0';
    }
    t_SerialTransaction::t_SerialTransaction(char * AddressData)
    {
	strncpy(v_Serialized,AddressData,16);
    }
    
    // --- DESTRUCTOR ---
    t_SerialTransaction::~t_SerialTransaction()
    {
    }
    
    // --- METHODS ---
    void t_SerialTransaction::serialize()
    {
	memcpy(v_Serialized,v_Address,9);
	memcpy(v_Serialized+strlen(v_Address),v_Data,9);
	std::cout << "Building Serialized : " << v_Serialized << std::endl;
    }

    void t_SerialTransaction::deserialize()
    {
	strncpy(v_Address,v_Serialized,8);
	v_Address[8] = '\0';
	strncpy(v_Data,v_Serialized+strlen(v_Data),8);
	v_Data[8] = '\0';
	std::cout << "Serialized : " << v_Serialized << std::endl;
	std::cout << "Deserializing : " << v_Address << " / " << v_Data << std::endl;
    }
    
    
}
