#################
## DESCRIPTION ##
#################

# Makefile

##################
## PROJECT INFO ##
##################

PRJ_DIR = /mnt/Projects/Robot
TOP = WriteRegister
OUT_FILE = $(TOP).out
RUN_FILE = $(TOP).x
DEP_FILE       = make.dep

######################
## ENVIRONMENT INFO ##
######################
LIB_DIR = $(PRJ_DIR)/SW/lib

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
	-lgenlib \
	-litc \
	-lserialcommlib \
	-ltypes

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
