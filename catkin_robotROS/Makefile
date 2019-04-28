#################
## DESCRIPTION ##
#################

# Makefile to launch ROS nodes


#####################
## PROJECT INCLUDE ##
#####################

include ../project.mak

########################
## COMPILATION TARGET ##
########################
# Target to compile this module. 
# It can be:
# --> UBUNTU-PC: Linux over x386 architecture
# --> UBUNTU-RPI: Linux over RPI
TARGET = UBUNTU-PC

##################
## PROJECT INFO ##
##################

PRJ_DIR = $(ROBOT_HOME)

######################
## ENVIRONMENT INFO ##
######################
VERBOSE = 1

#####################
### COMPILER INFO ###
#####################

ifeq ($(TARGET),UBUNTU-PC)
	target_arch = -linux
endif
ifeq ($(TARGET),UBUNTU-RPI)
	target_arch = -linux
endif

#########################
### COMPILER COMMANDS ###
#########################

# Compilation flags
J_FLAGS = 

###########
## TOOLS ##
###########
JAVAC = javac
JAVA = java

#############
## SOURCES ##
#############

SOURCE_DIR = ./sources
SOURCES := $(shell find $(SOURCE_DIR) -name '*.java')

##############
## INCLUDES ##
##############

##########
## LIBS ##
##########

#####################
## DERIVED SOURCES ##
#####################

CLASS = $(notdir $(SOURCES:$.java=$.class))

##################
### OTHER INFO ###
##################

#############
## DEFAULT ##
#############

all: LINK

##############
## COMMANDS ##
##############

commands:
	@echo ""
	@echo "$(HEAD) Available commands: $(TAIL)"
	@echo
	@echo "  CLEAN           : Clean the database"
	@echo "  COMPILE         : Compile the ROS project"
	@echo "  RUN             : Launch all ROS Nodes"
	@echo "  KILL            : Kill ros nodes"
	@echo ""

#############
## ACTIONS ##
#############
KILL:
	rosnode kill -a
COMPILE:
	catkin_make VERBOSE=$(VERBOSE)

CLEAN:
	catkin_make clean

RUN:
	@echo "Launching all nodes..."
	roslaunch robot.launch
