#ifndef CAMERAMOTIONCONTROLLIBS_H
#define CAMERAMOTIONCONTROLLIBS_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <iostream>
#include <iomanip>
#include <termios.h> 

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>

#include "GenLib.h"
#include "Ports.h"
#include "ITC.h"

namespace CAMERAMOTIONCONTROLLIBS
{

    bool SetCameraAngle(int StepsH, int StepsV);
    
}

#endif
