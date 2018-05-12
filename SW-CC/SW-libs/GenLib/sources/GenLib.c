/* *********************************** */
/* *** General Purpose lib ( C++ ) *** */
/* *********************************** */

// ******************
// **** INCLUDES ****
// ******************
#include "GenLib.h"

// *****************************
// **** FUNCTION DEFINITION ****
// *****************************

// **************
// **** MAIN ****
// **************

namespace GenLib
{

    // Function to extend with a character the beginning of a string up to X characters
    std::string Extend(std::string Value, int NumChars)
    {
	std::string Temp = Value;
	if (Value.length() < NumChars)
	{
	    for (int i = Value.length(); i < NumChars ; i++)
	    {
		Temp.insert(0,"0");
	    }
	}
	

	return Temp;
	
    }

    // Function to transform integer to string
    std::string IntToString ( int Number )
    {
	std::ostringstream ss;
	ss << Number;
	return ss.str();
    }

    // Function to transform positive number to formatted string
    std::string PosIntToFormattedString(int Number,int digits)
    {
	std::ostringstream ss;
	ss << std::setfill('0') << std::setw(digits) << Number;
	return ss.str();
    }
    

    // Function to transform string to integer
    int StringToInt(const std::string &Text)
    {
	std::istringstream ss(Text);
	int result;
	return ss >> result ? result : 0;

    }

    // Function to transform an integer (dec) into hex
    std::string int_to_hex( int i, int digits )
    {
	std::stringstream stream;
	stream << std::setfill('0') << std::setw(digits) << std::hex << i;
	return stream.str();
    }

}
