#################
## DESCRIPTION ##
#################

# My Own L3 server


#####################
## PROJECT INCLUDE ##
#####################

include ../../../project.mak

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
TOP = MOL3P
OUT_FILE = $(TOP).out
RUN_FILE = $(TOP).x
DEP_FILE       = make.dep

######################
## ENVIRONMENT INFO ##
######################
LIB_DIR = $(PRJ_DIR)/SW-CC/lib

#####################
### COMPILER INFO ###
#####################

GCC = gcc
ifeq ($(TARGET),UBUNTU-RPI)
	GXX = arm-linux-gnueabihf-c++
endif
ifeq ($(TARGET),UBUNTU-PC)
	GXX = g++
endif

target_arch = -linux

#########################
### COMPILER COMMANDS ###
#########################

# Compilation flags
C_FLAGS = -DDEBUG_ENVIA=1
L_FLAGS = -DDEBUG_ENVIA=1
DFLAGS = -MM

###########
## TOOLS ##
###########

#############
## SOURCES ##
#############

SOURCE_DIR = ./sources
SOURCES := $(shell find $(SOURCE_DIR) -name '*.c')

##############
## INCLUDES ##
##############

INCLUDE = \
	-I$(LIB_DIR)

LINCLUDE = \
	-L$(LIB_DIR)

##########
## LIBS ##
##########
LIBS = \
#	-litc \
#	-ltypes

LIBS_SO = $(LIB_DIR)/libitc.so \
	$(LIB_DIR)/libtypes.so

#####################
## DERIVED SOURCES ##
#####################

OBJ = $(notdir $(SOURCES:$.c=$.o))

##################
### OTHER INFO ###
##################
DEST_PORT = 51718
DEST_IP   = 10.10.0.6

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
	@echo "  INFO            : Shows compiling information"
	@echo "  CLEAN           : Clean the database"
	@echo "  DEPEND          : Creating dependencies"
	@echo "  LINK            : Compile the program: C++"
	@echo "  RUN             : Run the program"
	@echo ""

#############
## ACTIONS ##
#############

DEPEND:
	@echo "Creating dependencies..."
	$(GXX) $(INCLUDE) $(DFLAGS) $(SOURCES) > $(DEP_FILE)


INFO:
	@echo " --- Compiler ---"
	@echo $(GXX)
	@echo " --- Object files (OBJ) ---"
	@echo $(OBJ)
	@echo " --- PATHS (OBJ) ---"
	@echo "LIB_DIR"
	@echo $(LIB_DIR)
	@echo "LIBS_SO"
	@echo $(LIBS_SO)
	@echo "PRJ_DIR"
	@echo $(PRJ_DIR)

CLEAN:
	@echo "Cleaning..."
	@-rm -rf $(OBJ)
	@-\rm $(RUN_FILE)

LINK: $(OBJ) $(LIBS_SO)
	@echo "Compiling C++ ..."
	$(GXX) $(L_FLAGS) $(INCLUDE) $(LINCLUDE) $(OBJ) -o $(TOP).x $(LIBS)

RUN: $(TOP).x
	@echo "Running..."
	./$(TOP).x

$(OBJ): %.o :
	echo "Compiling $<..."
	$(GXX) $(C_FLAGS) $(INCLUDE) -c $< -o $@

.PHONY: DEPEND

## Include dependencies file
ifeq ($(DEP_FILE), $(wildcard $(DEP_FILE)))
include $(DEP_FILE)
endif
