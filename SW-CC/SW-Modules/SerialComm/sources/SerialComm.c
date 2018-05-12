/* ********************************* */
/* *** SerialCom ( C++ )         *** */
/* ********************************* */

// ******************
// **** INCLUDES ****
// ******************
#include "SerialComm.h"

// *****************************
// **** FUNCTION DEFINITION ****
// *****************************

// Read with Time Out
static
unsigned ReadTO(char *buffer, unsigned size, bool exact, unsigned toMult)
{
 unsigned read;
 PTimer to(100000*toMult); // 100 ms time-out
 do
   {
    read=ser->RawRead(buffer,size,exact);
    if (!read)
       usleep(1000);
//    printf("read: %d to.Reached() %d\n",read,to.Reached());
   }
 while (!read && !to.Reached());
 return read;
}

// Read from an indirect address
unsigned ReadAddress(int Address)
{

    // Definitions
    char *buffer;
    unsigned read;
    char a,b,c;
    PTimer to(100000*50); // 100 ms time-out

    // Send Command
//    std::cout << "\t\tSending command (2)" << std::endl;
    a = char(2);
    ser->Send(&a,1);

    // Send Address
//    std::cout << "\t\tSending Address " << Address << std::endl;
    b = char(Address);
    ser->Send(&b,1);

    // Receive data
    // Read the ack
    char reply[1];
    read=ReadTO(reply,1,false,80);
    //std::cout << "\t\tValue Read:  ";
//    printf("Value read : %d",reply[0]);
    //std::cout << " / " << read << std::endl << std::endl;

    return int(reply[0]);

}

// Write to an indirect address
int WriteAddress(int Address, int Data)
{

    // Definitions
    char a;
    char b;
    char c;
    unsigned read;
    
    // Send Command
//    std::cout << "\t\tSending command (1)" << std::endl;
    a = char(1);
    ser->Send(&a,1);

    // Send Address
//    std::cout << "\t\tSending Address " << Address << std::endl;
    b = char(Address);
    ser->Send(&b,1);

    // Send Data
//    std::cout << "\t\tSending Data " << Data << std::endl;
    c = char(Data);
    ser->Send(&c,1);

    // Read the ack
    char reply[1];
    read=ReadTO(reply,1,false,80);
//    std::cout << "\t\tAck Read:  ";
    printf("Value read : %d",reply[0]);
    std::cout << " / " << read << std::endl << std::endl;
    
}

// **************
// **** MAIN ****
// **************

int main(int argc, char ** argv) {

    // ------------------- 
    // --- Definitions ---
    // ------------------- 
    int sockfd;
    char buf[16];
    char Command_Address_hex[9];
    char Command_Data_hex[9];

    // -------------------------------
    // -- Open serial communication --
    // -------------------------------

    // Open the serial communication and initialize it
    ComSerie s(-1,230400,1024,portName);
    s.Initialize();
    ser=&s;

    // -------------------------------
    // -- Open communication socket --
    // -------------------------------
    sockfd = ITC::create_server(PORT_SERIALCOMM);

    // -----------------------
    // -- Clean everything --- 
    // -----------------------
    bzero(buf,16);

    // ------------------------------------
    // -- MAIN ITERATION FOR THE SERVER --- 
    // ------------------------------------

    while (1)
    {

	// Wait for a request
	int newsockfd = ITC::ITC_create_client_instance(sockfd);
	// When something arrives create an instance to read
	std::string Rx = ITC::ITC_read(newsockfd,17);
	std::string DIR = Rx.substr(0,1);
	std::string AD = Rx.substr(1,8);
	strncpy(Command_Address_hex,AD.c_str(),8);
	Command_Address_hex[8] = '\0';

	// Convert ADDRESS HEX to decimal
	char* pEnd;
	long int Command_Address_dec = strtol(Command_Address_hex,&pEnd,16) ;
	long int tmp;
	long int Address4 = Command_Address_dec % 256;
	tmp = Command_Address_dec / 256;
	long int Address3 = tmp % 256;
	tmp = tmp / 256;
	long int Address2 = tmp % 256;
	tmp = tmp / 256;
	long int Address1 = tmp % 256;
	tmp = tmp / 256;

	if (DIR == "W")
	{

	    // WRITE OPERATION
	    std::string DA = Rx.substr(9,8);

	    strncpy(Command_Data_hex,DA.c_str(),8);
	    Command_Data_hex[8] = '\0';
	    long int Command_Data_dec    = strtol(Command_Data_hex,&pEnd,16) ;

	    std::cout << "WRITE_ADDR 0x" << Command_Address_hex << " Data " << Command_Data_hex << std::endl;


	    // Convert DATA HEX to decimal
	    long int Data4 = Command_Data_dec % 256;
	    tmp = Command_Data_dec / 256;
	    long int Data3 = tmp % 256;
	    tmp = tmp / 256;
	    long int Data2 = tmp % 256;
	    tmp = tmp / 256;
	    long int Data1 = tmp % 256;
	    tmp = tmp / 256;

	    std::cout << "\tAddress 1: " << Address1 << " ";
	    std::cout << "\tAddress 2: " << Address2 << " ";
	    std::cout << "\tAddress 3: " << Address3 << " ";
	    std::cout << "\tAddress 4: " << Address4 << std::endl;
	    std::cout << "\tData 1: " << Data1 << " ";
	    std::cout << "\tData 2: " << Data2 << " ";
	    std::cout << "\tData 3: " << Data3 << " ";
	    std::cout << "\tData 4: " << Data4 << std::endl;
    
	    // Write registers
	    //std::cout << "\t -- Write Address -- " << std::endl;
	    WriteAddress(1,Address1);
	    WriteAddress(2,Address2);
	    WriteAddress(3,Address3);
	    WriteAddress(4,Address4);
	    //std::cout << "\t -- Write Data -- " << std::endl;
	    WriteAddress(5,Data1);
	    WriteAddress(6,Data2);
	    WriteAddress(7,Data3);
	    WriteAddress(8,Data4);
	    //std::cout << "\t -- Trigger action -- " << std::endl;
	    WriteAddress(0,1);
	    
	} else {

	    // READ OPERATION
//	    std::cout << "READ_ADDR 0x" << Command_Address_hex << std::endl;
	    WriteAddress(1,Address1);
	    WriteAddress(2,Address2);
	    WriteAddress(3,Address3);
	    WriteAddress(4,Address4);
	    WriteAddress(0,2);

	    // Read the result
	    int Result_tmp;
	    int Result;
	    Result =0;
	    Result_tmp = ReadAddress(5);
	    Result = Result + Result_tmp * 256 *256 *256;
	    Result_tmp = ReadAddress(6);
	    Result = Result + Result_tmp * 256 *256;
	    Result_tmp = ReadAddress(7);
	    Result = Result + Result_tmp * 256;
	    Result_tmp = ReadAddress(8);
	    Result = Result + Result_tmp;

	    // Write RESULT
	    std::cout << "RESULT: " ;
	    printf("[0x%02X]",Result);
	    std::cout << std::endl;
	    std::string Command = GenLib::PosIntToFormattedString(Result,8);

	    // We create the transaction
	    //std::cout << "LENGTH " << Command.length() << std::endl;
	    ITC::ITC_writeString(newsockfd,Command);
	    
	}
	
	
    }

    return 0;

}
