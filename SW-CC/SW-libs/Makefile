#################
## DESCRIPTION ##
#################

# Makefile to generate ITC library

######################
## ENVIRONMENT INFO ##
######################
#include "../../project.mak"

#####################
### COMPILER INFO ###
#####################

GCC = gcc
GXX = g++
target_arch = -linux

#########################
### COMPILER COMMANDS ###
#########################

# Compilation flags

###########
## TOOLS ##
###########

##################
## PROJECT INFO ##
##################

#############
## SOURCES ##
#############

##############
## INCLUDES ##
##############

##########
## LIBS ##
##########

#####################
## DERIVED SOURCES ##
#####################


##################
### OTHER INFO ###
##################

#############
## DEFAULT ##
#############

all: COMPILE

##############
## COMMANDS ##
##############

commands:
	@echo ""
	@echo "$(HEAD) Available commands: $(TAIL)"
	@echo
	@echo "  DEPEND         : Create dependencies"
	@echo "  COMPILE         : Compile libraries"
	@echo ""

#############
## ACTIONS ##
#############

DEPEND:
	@echo "Creating dependencies..."
	make -C ./Types DEPEND
	make -C ./ITC DEPEND
	make -C ./GenLib DEPEND
	make -C ./MotionControlLibs DEPEND
	make -C ./CameraMotionControlLibs DEPEND
	make -C ./SerialCommLibs DEPEND

COMPILE:
	@echo "Compiling libraries..."
	make -C ./Types
	make -C ./ITC
	make -C ./GenLib
	make -C ./MotionControlLibs
	make -C ./CameraMotionControlLibs
	make -C ./SerialCommLibs


