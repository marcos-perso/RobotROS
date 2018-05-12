#########################
## PROJECT INFORMATION ##
#########################
include ./defines.mak

######################
## TEST INFORMATION ##
######################
TEST_NAME = test1

####################
## DIRECTORY INFO ##
####################

TB_DIR        = ./TB
SOURCE_DIR    = ../../../../usoc-sources
SYNTH_DIR     = ../../../../design/synthesis
TOOL_DIR      = ../../../tools
SCRIPTS_DIR   = $(TOOL_DIR)/scripts
TEST_DIR      = $(PRJ_DIR)/test/system/$(TEST_NAME)
XILINXCORELIB_SRC_DIR = ../../../../usoc-libraries/xilinx/XilinxCoreLib
XILINXUNISIM_SRC_DIR  = ../../../../usoc-libraries/xilinx/unisims
XILINXSIMPRIM_SRC_DIR = /opt/Xilinx/14.7/ISE_DS/ISE/vhdl/src/simprims
FMF_SRC_DIR   = ../../../../usoc-sources/models/s29gl032n
SIMPRIM_DIR = ../../../../usoc-libraries/xilinx/simprim
#ZPU_TOOL_DIR = /share/Projects/uSoC/design/tools/toolchain/bin
ZPU_TOOL_DIR = ../../../../../Tools/zpugcc/toolchain/install/bin

##################
## PROJECT INFO ##
##################

TOP1      = simulation1
TOP2      = simulation2
TOP_POST  = simulationPost
LOG      = log.txt
PRJ_NAME = ZPU_SoC

###########
## TOOLS ##
###########

GHDL        = ghdl
WAVE_TOOL   = gtkwave
ZPU_GCC   = $(ZPU_TOOL_DIR)/zpu-elf-gcc
ZPU_SIZE  = $(ZPU_TOOL_DIR)/zpu-elf-size
ZPU_OBJCOPY = $(ZPU_TOOL_DIR)/zpu-elf-objcopy
ZPU_OBJDUMP = $(ZPU_TOOL_DIR)/zpu-elf-objdump
LAUNCHER    = $(TOOL_DIR)/launcher/launcher.perl


################
## FILE NAMES ##
################

DEP_FILE       = make.dep
VCD_FILE       = run.vcd
WAVE_FILE      = run.ghw
ELF_FILE       = main.elf
BIN_FILE       = main.bin
BIN_FILE_ROM   = rom.bin
BIN_FILE_RAM   = ram.bin
COE_FILE       = main.coe
ROM_FILE       = main.rom
RAM_FILE       = main.ram
ROM_FILE1      = main.rom1
SIM_FILE_ROM   = rom.sim
SIM_FILE_RAM   = ram.sim
SIM_FILE_FLASH = flash.in
BIN_FILE_FLASH = flash.bin
SER_FILE       = main.ser
DISS_FILE      = main.dis
DISS_FILE_RAM  = ram.dis
DISS_FILE_ROM  = rom.dis
VHDL_TO_ADAPT  = $(TB_DIR)/main.vhd
VHDL_ADAPTED   = $(TB_DIR)/main_new.vhd
ADAPT_SCRIPT   = TransformRAM.pl 
RUN_LOG        = run.out
ZPU_LD_SCRIPT  = $(SOURCE_DIR)/sw/zpuelf.lds

######################
## ENVIRONMENT INFO ##
######################

target_arch  = -linux

##################
## GHDL OPTIONS ##
##################

IMPORT_OPTIONS = --std=93c --ieee=synopsys --workdir=work
XILINXCORELIB_IMPORT_OPTIONS = --std=93c -Punisim --workdir=xilinxcorelib --work=xilinxcorelib --ieee=synopsys -fexplicit
FMF_IMPORT_OPTIONS = --std=93c -Punisim --workdir=FMF --work=FMF --ieee=synopsys -fexplicit
XILINXUNISIM_IMPORT_OPTIONS = --std=93c --workdir=unisim --work=unisim --ieee=synopsys -fexplicit
XILINXSIMPRIM_IMPORT_OPTIONS = --std=93c --workdir=$(SIMPRIM_DIR) --work=simprim --ieee=synopsys -fexplicit
#MAKE_OPTIONS   = -Wc,-ggdb $(IMPORT_OPTIONS) -Wl,-s -fexplicit --syn-binding
#MAKE_OPTIONS   = -Wc,-g $(IMPORT_OPTIONS) -Wl,-g -Wl,-s -fexplicit --syn-binding
MAKE_OPTIONS   = -Wc,-g $(IMPORT_OPTIONS) -PFMF --warn-no-vital-generic --no-vital-checks -P$(SIMPRIM_DIR) -Punisim -Pxilinxcorelib -Wl,-g -fexplicit --syn-binding --warn-unused 
RUN_OPTIONS    = --wave=$(WAVE_FILE) --disp-tree=inst
RUN_OPTIONS3   =

#############
## SOURCES ##
#############

ifeq ($(SIMUL_TYPE),WITH_MODELS)
include sim_RTL_with_model.fof
else
include sim_POST_with_model.fof
endif
ifeq ($(SIMUL_TYPE),WITH_XILINX)
include sim_RTL_with_xilinx.fof
endif

include xilinx.fof
include fmf.fof

##################
## DERIVED DEFS ##
##################
OBJ = $(notdir $(SW_SOURCES:$.c=$.o))
ASS = $(notdir $(ASS_SOURCES:$.S=$.o))

####################
## COMPILER FLAGS ##
####################

DFLAGS = -MM
CFLAGS = -phi -g
LFLAGS = -Wl,$(ZPU_LD_SCRIPT)

###########
## OTHER ##
###########

HEAD   = **********
TAIL   = **********

##############
## COMMANDS ##
##############

commands:
	@echo ""
	@echo "$(HEAD) Available commands: $(TAIL)"
	@echo
	@echo "  INFO                 : Show information on the database"
	@echo ""
	@echo "  IMPORT_XILINXUNISIM  : Import XILINX models"
	@echo "  IMPORT_XILINXCORELIB : Import XILINX core models"
	@echo "  IMPORT_FMF           : Import Spansion models"
	@echo "  IMPORT_XILINXSIMPRIM : Import XILINX simulation primitives"
	@echo ""
	@echo "  CLEAN                : Clean database"
	@echo "  DEPEND               : Create SW dependencies"
	@echo "  COMPILE_SW           : Compile database"
	@echo "  GENERATE_ROM         : Generate ROM file"
	@echo "  DISS_SW              : Disassembly SW"
	@echo ""
	@echo "  IMPORT_HW            : Import VHDL sources"
	@echo "  COMPILE_HW           : Compile database"
	@echo ""
	@echo "  RUN1                 : Run simulation (Xilinx models)"
	@echo "  RUN2                 : Run simulation (Simulation models)"
	@echo "  RUN3                 : Run simulation (Simulation models without waves)"
	@echo ""
	@echo "  IMPORT_HW_POST       : Import VHDL sources for POST synthesis"
	@echo "  COMPILE_HW_POST      : Compile database for POST synthesis"
	@echo ""
	@echo "  WAVES                : Show Simulation waves"
	@echo ""
	@echo " REGRESSION            : Make regression tests (Single test)"
	@echo " REGRESSION_ALL        : Make regression tests"
	@echo ""
	@echo "  CREATE_XEMACS_PRJ : Creates XEMACS project file"
	@echo ""



#############
## ACTIONS ##
#############
all: RUN1 RUN2

CLEAN:
	@echo "Cleaning executables.."
	@-rm $(TOP1)
	@-rm $(TOP2)
	@echo "Cleaning log..."
	@-rm $(LOG)
	@echo "Cleaning temporrary VHDL files..."
	@-rm -rf $(VHDL_ADAPTED)
	@echo "Cleaning ROM file.."
	@-rm -rf $(ROM_FILE)
	@-rm -rf $(RAM_FILE)
	@-rm -rf $(BIN_FILE)
	@-rm -rf $(BIN_FILE_RAM)
	@-rm -rf $(BIN_FILE_ROM)
	@-rm -rf $(COE_FILE)
	@echo "Cleaning waves file.."
	@-rm -rf $(VCD_FILE)
	@-rm -rf $(WAVE_FILE)
	@echo "Cleaning object files..."
	@-rm -rf $(OBJ)
	@-rm -rf $(ASS)
	@echo "Cleaning VHDL work library..."
	@-rm -rf ./work

RUN1: $(TOP1)
	@echo "Running simulation..." $(TOP1)
	./$(TOP1) $(RUN_OPTIONS) | tee $(RUN_LOG)

RUN2: $(TOP2)
	@echo "Running simulation..." $(TOP2)
	./$(TOP2) $(RUN_OPTIONS) | tee $(RUN_LOG)

RUN3: $(TOP2)
	@echo "Running simulation..." $(TOP2)
	./$(TOP2) $(RUN_OPTIONS3) | tee $(RUN_LOG)

COMPILE_SW: $(OBJ) crt0.o
	@echo "----- Compiling SW sources -----"
	#$(ZPU_GCC) -Os $(CFLAGS) $(OBJ) $(LFLAGS) -o $(ELF_FILE) -Wl,--relax -Wl,--gc-sections
	$(ZPU_GCC) $(CFLAGS) $(OBJ) $(ASS) -o $(ELF_FILE) -Wl,$(ZPU_LD_SCRIPT) -Wl,--relax -Wl,--gc-sections -nostartfiles
	@echo "----- Provide information on the program file -----"
	$(ZPU_SIZE) $(ELF_FILE)
	@echo "----- Create memory binaries -----"
	$(ZPU_OBJCOPY) -O binary $(ELF_FILE) $(BIN_FILE)
	$(ZPU_OBJCOPY) -v --set-start 0 -j .fixed_vectors -j .data -j .rodata -j .init -j .text -j .fini $(ELF_FILE) rom.elf
	$(ZPU_OBJCOPY) -v --set-start 0 -j .stack -j .ctors -j .dtors -j .jcr -j .bss $(ELF_FILE) ram.elf
	$(ZPU_OBJCOPY) -v -O binary rom.elf $(BIN_FILE_ROM)
	$(ZPU_OBJCOPY) -v -O binary ram.elf $(BIN_FILE_RAM)
	$(ZPU_OBJCOPY) -v -O ihex rom.elf $(BIN_FILE_ROM).hex
	$(ZPU_OBJCOPY) -v -O ihex ram.elf $(BIN_FILE_RAM).hex

DISS_SW:
	$(ZPU_OBJDUMP) --disassemble-all $(ELF_FILE) > $(DISS_FILE)
	$(ZPU_OBJDUMP) --disassemble-all ram.elf > $(DISS_FILE_RAM)
	$(ZPU_OBJDUMP) --disassemble-all rom.elf > $(DISS_FILE_ROM)

$(REGRESSION_TEST_LIST): TEST% :
	@echo "--------------------------------------------------"
	@echo "--- Running regression... " $@
	@echo "---     Parem1: TEST NAME "
	@echo "---     Parem2: Time (ms) "
	@echo "---     Parem3: Waves (0=no; 1=yes) "
	@echo "--------------------------------------------------"
	$(LAUNCHER) $@ 0 0

$(OBJ): %.o :
	echo "Compiling $<..."
	$(ZPU_GCC) $(CFLAGS) -c $< -o $@

crt0.o: $(SOURCE_DIR)/sw/crt0.S
	echo "Compiling assembly code $<..."
	$(ZPU_GCC) $(CFLAGS) -c $< -o $@

GENERATE_ROM:
	@echo "Generating ROM file..."
	#$(TOOL_DIR)/bin/zpuromgen.x VHDL $(BIN_FILE) > $(ROM_FILE)
	#$(TOOL_DIR)/bin/zpuromgen.x RAW  $(BIN_FILE) > $(ROM_FILE1)
	#$(TOOL_DIR)/bin/zpuromgen.x COE  $(BIN_FILE) > $(COE_FILE)
	$(TOOL_DIR)/bin/zpuromgen.x RAW  $(BIN_FILE_ROM) > $(SIM_FILE_ROM)
	$(TOOL_DIR)/bin/zpuromgen.x SIM  $(BIN_FILE_ROM) > $(SIM_FILE_FLASH)
	$(TOOL_DIR)/bin/zpuromgen.x RAW  $(BIN_FILE_ROM) > $(BIN_FILE_FLASH)
	$(TOOL_DIR)/bin/zpuromgen.x RAW  $(BIN_FILE_RAM) > $(SIM_FILE_RAM)

ADAPT_VHDL:
	@echo "Adapting VHDL file"	
	$(SCRIPTS_DIR)/$(ADAPT_SCRIPT) $(VHDL_TO_ADAPT) $(VHDL_ADAPTED) $(ROM_FILE)
	cp $(VHDL_ADAPTED) $(VHDL_TO_ADAPT)

COMPILE_HW:
	@echo "Compiling HW platform...."
	$(GHDL) -m $(MAKE_OPTIONS) $(TOP1)
	$(GHDL) -m $(MAKE_OPTIONS) $(TOP2)

COMPILE_HW_POST:
	@echo "Compiling HW platform...."
	$(GHDL) -m $(MAKE_OPTIONS) $(TOP_POST)

IMPORT_FMF:
	@echo "Creating Spansion directory..."
	-mkdir -p FMF
	@echo "Importing FMF lib sources..."
	$(GHDL) -a $(FMF_IMPORT_OPTIONS) $(FMF_SOURCES)

IMPORT_HW:
	@echo "Creating work directory..."
	-mkdir -p work
	@echo "Importing HW sources..."
	$(GHDL) -i $(IMPORT_OPTIONS) $(HW_SOURCES)

IMPORT_HW_POST:
	@echo "Creating work directory..."
	-mkdir -p work
	@echo "Importing HW sources..."
	$(GHDL) -i $(IMPORT_OPTIONS) $(HW_SOURCES_POST)

IMPORT_XILINXCORELIB:
	@echo "Creating xilinxcorelib directory..."
	-mkdir -p xilinxcorelib
	@echo "Importing XILINX core lib sources..."
	$(GHDL) -a $(XILINXCORELIB_IMPORT_OPTIONS) $(XILINXCORELIB_SOURCES)

IMPORT_XILINXUNISIM:
	@echo "Creating unisim directory..."
	-mkdir -p unisim
	@echo "Importing XILINX unisim lib sources..."
	$(GHDL) -a $(XILINXUNISIM_IMPORT_OPTIONS) $(XILINXUNISIM_SOURCES)

IMPORT_XILINXSIMPRIM:
	@echo "Creating simprim directory..."
	-mkdir -p simprim
	@echo "Importing XILINX simprim lib sources..."
	$(GHDL) -a $(XILINXSIMPRIM_IMPORT_OPTIONS) $(XILINXSIMPRIM_SOURCES)

INFO:
	@echo "================"
	@echo "=== PRJ INFO ==="
	@echo "================"
	@echo $(PRJ_DIR)
	@echo "=================="
	@echo "=== HW SOURCES ==="
	@echo "=================="
	@echo $(HW_SOURCES)
	@echo "=================="
	@echo "=== SW SOURCES ==="
	@echo "=================="
	@echo $(SW_SOURCES)
	@echo "========================="
	@echo "=== ASSEMBLER SOURCES ==="
	@echo "========================="
	@echo $(ASS_SOURCES)
	@echo "=================="
	@echo "=== SW OBJECTS ==="
	@echo "=================="
	@echo $(OBJ)
	@echo "========================="
	@echo "=== ASSEMBLER OBJECTS ==="
	@echo "========================="
	@echo $(ASS)

WAVES:
	@$(WAVE_TOOL) $(WAVE_FILE)

DEPEND:
	@echo "Creating dependencies..."
	$(ZPU_GCC) $(DFLAGS) $(SW_SOURCES) $(ASS_SOURCES) > $(DEP_FILE)


CREATE_XEMACS_PRJ:
	echo ";; Project : $(PRJ_NAME)"                               >  $(PRJ_NAME).prj
	echo ""                                                       >> $(PRJ_NAME).prj
	echo ";; project name"                                        >> $(PRJ_NAME).prj
	echo "(setq vhdl-project \"$(PRJ_NAME)\")"                    >> $(PRJ_NAME).prj
	echo ""                                                       >> $(PRJ_NAME).prj
	echo ";; project setup"                                       >> $(PRJ_NAME).prj
	echo "(aput 'vhdl-project-alist vhdl-project"                 >> $(PRJ_NAME).prj
	echo "'(\"ZPU Microprocessor\" \"" $(TEST_DIR) "/\" "         >> $(PRJ_NAME).prj
	echo "("                                                      >> $(PRJ_NAME).prj
	echo $(foreach FILE,$(HW_SOURCES), "\""$(FILE)"\"")           >> $(PRJ_NAME).prj
	echo "\"src/system/\""                                        >> $(PRJ_NAME).prj
	echo ")"                                                      >> $(PRJ_NAME).prj
	echo "\"\""                                                   >> $(PRJ_NAME).prj
	echo "((\"ModelSim\" \"-87 \\\2\" \"-f \\\1 top_level\" nil)" >> $(PRJ_NAME).prj
	echo "(\"Synopsys\" \"-vhdl87 \\\2\" \"-f \\\1 top_level\""   >> $(PRJ_NAME).prj
	echo "((\".*/datapath/.*\" . \"-optimize \\\3\")"             >> $(PRJ_NAME).prj
	echo "(\".*_tb\\\.vhd\"))))"                                  >> $(PRJ_NAME).prj
	echo "\"lib/\" "                                              >> $(PRJ_NAME).prj
	echo "\"example3_lib\" "                                      >> $(PRJ_NAME).prj
	echo "\"lib/example3/\" "                                     >> $(PRJ_NAME).prj
	echo "\"Makefile_\\\\2\" \"\""                                >> $(PRJ_NAME).prj
	echo ")"                                                      >> $(PRJ_NAME).prj
	echo ")"                                                      >> $(PRJ_NAME).prj
	echo ""                                                       >> $(PRJ_NAME).prj

## Include dependencies file
ifeq ($(DEP_FILE), $(wildcard $(DEP_FILE)))
include $(DEP_FILE)
endif

