#################
## DESCRIPTION ##
#################

# General Makefile

##############
## INCLUDES ##
##############

#####################
### COMPILER INFO ###
#####################

####################
## DIRECTORY INFO ##
####################

##################
## PROJECT INFO ##
##################

SW_MODULES = C-Console

###########
## TOOLS ##
###########

################
## FILE NAMES ##
################

######################
## ENVIRONMENT INFO ##
######################

#############
## SOURCES ##
#############

#########################
### COMPILER COMMANDS ###
#########################

##################
### OTHER INFO ###
##################

all: COMPILE

##############
## COMMANDS ##
##############

commands:
	@echo ""
	@echo "General MAKEFILE of SW-MODULES project"
	@echo
	@echo "  DEPEND  : Create dependencies"
	@echo "  COMPILE : Compile SW Modules"
	@echo ""

#############
## ACTIONS ##
#############

DEPEND:
	make -C ./C-Console DEPEND
	make -C ./SerialComm DEPEND
	make -C ./MOL3P DEPEND
	make -C ./MotionControl DEPEND
	make -C ./CameraMotionControl DEPEND

COMPILE:
	make -C ./C-Console
	make -C ./SerialComm
	make -C ./MOL3P
	make -C ./MotionControl
	make -C ./CameraMotionControl

