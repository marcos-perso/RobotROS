#################
## DESCRIPTION ##
#################

# Makefile to generate ITC library

######################
## ENVIRONMENT INFO ##
######################
include ../../../project.mak

#####################
### COMPILER INFO ###
#####################

GCC = gcc
ifeq ($(TARGET),RASPBERRY)
	GXX = g++
endif
ifeq ($(TARGET),PC)
	GXX = g++
endif
target_arch = -linux

#########################
### COMPILER COMMANDS ###
#########################

# Compilation flags
C_FLAGS = -fpic -g -DDEBUG_ENVIA=1
#L_FLAGS = -shared -Wall,-soname,libitc.so -DDEBUG_ENVIA=1
L_FLAGS = -shared -Wall -DDEBUG_ENVIA=1
DFLAGS = -MM

###########
## TOOLS ##
###########

##################
## PROJECT INFO ##
##################

LIB_FILE = libtypes.so
DEP_FILE       = make.dep


#############
## SOURCES ##
#############

SOURCE_DIR = ./sources
SOURCES := $(shell find $(SOURCE_DIR) -name '*.c')

##############
## INCLUDES ##
##############

INCLUDE = \
	-I./cppfio
LINCLUDE = \
	-L./cppfio

##########
## LIBS ##
##########
LIBS = \
	-lc
#	-lcppfio

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
	@echo ""

#############
## ACTIONS ##
#############

DEPEND:
	@echo "Creating dependencies..."
	$(GXX) $(DFLAGS) $(SOURCES) > $(DEP_FILE)


INFO:
	@echo " --- Compiler ---"
	@echo $(GXX)
	@echo " --- Object files (OBJ) ---"
	@echo $(OBJ)

CLEAN:
	@echo "Cleaning..."
	@-rm -rf $(OBJ)
	@-\rm $(LIB_FILE)

#LINK: cppfio $(OBJ)
LINK: $(OBJ)
	@echo "Compiling C++ ..."
	$(GXX) $(L_FLAGS) $(INCLUDE) $(LINCLUDE) $(OBJ) -o $(LIB_FILE) $(LIBS)

$(OBJ): %.o :
	echo "Compiling $<..."
	$(GXX) $(C_FLAGS) $(INCLUDE) -c $< -o $@

cppfio:
	make -C ./cppfio

#.PHONY: cppfio

## Include dependencies file
ifeq ($(DEP_FILE), $(wildcard $(DEP_FILE)))
include $(DEP_FILE)
endif
