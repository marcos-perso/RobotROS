/* ******************************** */
/* *** Set the speed of a motor *** */
/* ******************************** */

// ******************
// **** INCLUDES ****
// ******************
#include "WriteRegister.h"


/* ***************** */
/* *** FUNCTIONS *** */
/* ***************** */


/* ************ */
/* *** MAIN *** */
/* ************ */

int main(int argc, char *argv[])
{

    // -------------------
    // --- Definitions ---
    // -------------------
    char* AddressChar;
    char* DataChar;

    AddressChar = (char *) malloc(strlen(argv[1])+1);
    DataChar = (char *) malloc(strlen(argv[2])+1);

    strcpy(AddressChar,argv[1]);
    strcpy(DataChar,argv[2]);

    std::string Address(AddressChar);
    std::string Data(DataChar);

    std::cout << "WRITE OPERATION - REGISTER: " << Address << " DATA: " << Data << std::endl;

    // Definitions
    SERIALCOMMLIBS::WriteRegister(Address,Data);

}
