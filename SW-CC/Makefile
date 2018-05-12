#################
## DESCRIPTION ##
#################

# General compilation makefile

######################
## ENVIRONMENT INFO ##
######################

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

all:

##############
## COMMANDS ##
##############

commands:
	@echo ""
	@echo "$(HEAD) Available commands: $(TAIL)"
	@echo
	@echo "  DEPEND          : Create dependencies"
	@echo "  COMPILE         : Compile libraries"
	@echo "  RUN_SERVERS     : Start all the servers"
	@echo ""

#############
## ACTIONS ##
#############

DEPEND:
	@echo "Creatign dependencies..."
	make -C ./SW-libs DEPEND
	make -C ./SW-Modules DEPEND
	make -C ./SW-tools DEPEND

COMPILE:
	@echo "Compiling ALL..."
	make -C ./SW-libs
	make -C ./SW-Modules
	make -C ./SW-tools

RUN_SERVERS:
	./RunRobotServers.sh


