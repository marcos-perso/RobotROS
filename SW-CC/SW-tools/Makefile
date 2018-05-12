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
	make -C ./SetMotorSpeed DEPEND
	make -C ./WriteRegister DEPEND
	make -C ./ReadRegister DEPEND
	make -C ./SetCameraAngle DEPEND

COMPILE:
	make -C ./SetMotorSpeed
	make -C ./WriteRegister
	make -C ./SetCameraAngle

