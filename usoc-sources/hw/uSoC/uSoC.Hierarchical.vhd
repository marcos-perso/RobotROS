-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- My own SoC toplevel
--
-- NOTES:
--
--
-- $Author$
-- $Date$
-- $Name$
-- $Revision$
--
-------------------------------------------------------------------------------

---------------
-- LIBRARIES --
---------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use std.textio.all;

library work;
-- Packages
use work.SoCConstantsPackage.all;
use work.WishboneConstantsPackage.all;
use work.RegisterMapPackage.all;
use work.SimpleCounterPackage.all;
use work.zpu_config.all;
use work.zpupkg.all;
-- synthesis translate_off
Library XilinxCoreLib;
-- synthesis translate_on
library UNISIM;
use UNISIM.Vcomponents.ALL;

-- Components
use work.TICTimerComponentPackage.all;
use work.ResetGeneratorComponentPackage.all;
use work.ButtonCaptionComponentPackage.all;
use work.SimpleCounterComponentPackage.all;
use work.miniuartComponentPackage.all;
use work.wbMasterComponentPackage.all;
use work.ZPUBusComponentPackage.all;
use work.uSoCControllerComponentPackage.all;
use work.LEDInterfaceComponentPackage.all;
use work.DebugControllerComponentPackage.all;
use work.ConsoleComponentPackage.all;
use work.wbInterconComponentPackage.all;
--use work.InternalMemoryWrapperComponentPackage.all;
use work.FlashWrapperComponentPackage.all;
use work.FlashControllerComponentPackage.all;
use work.PWMGeneratorComponentPackage.all;
use work.MotorControlComponentPackage.all;
use work.wbMemoryWrapperComponentPackage.all;
-- Generators
use work.generatorsComponentPackage.all;

-----------------------------
-- ARCHITECTURE DEFINITION --
-----------------------------
   
architecture Hierarchical of uSoC is

  component  zpu_io is
    generic (
      log_file:       string  := "log.txt"
      );
    port (
      clk         : in  std_logic;
      areset      : in  std_logic;
      busy        : out std_logic;
      writeEnable : in  std_logic;
      readEnable  : in  std_logic;
      write       : in  std_logic_vector(wordSize-1 downto 0);
      read        : out std_logic_vector(wordSize-1 downto 0);
      addr        : in  std_logic_vector(maxAddrBit downto minAddrBit)
      );
  end component;


  -- SIGNAL DEFINITION --

  -- Timers
  signal s_TICTimer16 : std_logic;      -- TIC Timer generated with a 16MHz clock
  signal s_TICTimer50 : std_logic;      -- TIC Timer generated with a 50MHz clock

  -- Reset
  signal s_reset         : std_logic;      -- Reset coming from the board
  signal s_resetZPU      : std_logic;      -- Reset coming from the ZPU reset register
  signal s_LogicReset    : std_logic;      -- Reset to be used in the logic
  signal s_LogicResetZPU : std_logic;      -- Reset to be used in the ZPU

  -- Clock
  signal s_clk16     : std_logic;           -- 16 MHz clock
  signal s_clk16_inv : std_logic;           -- 16 MHz clock (inverted)
  signal s_clk32     : std_logic;           -- 32 MHz clock
  signal s_clk50     : std_logic;           -- 50 MHz clock

  -- LEDs
  signal s_LEDS      : std_logic_vector(3 downto 0);

 -- External buttons
  signal s_ButtonPressed1 : std_logic;
  signal s_ButtonPressed2 : std_logic;
  signal s_ButtonPressed3 : std_logic;

  -- Counters
  signal s_Counter8 : std_logic_vector(c_NbBitsSimpleCounter-1 downto 0);

  -- Wishbone bus
  signal s_WB_DATA_TO_MASTER   : std_logic_vector(c_WishboneDataWidth - 1 downto 0);
  signal s_WB_DATA_FROM_MASTER : std_logic_vector(c_WishboneDataWidth - 1 downto 0);
  signal s_WB_ACK_TO_MASTER    : std_logic;
  signal s_WB_CYC_FROM_MASTER  : std_logic;
  signal s_WB_LOCK_FROM_MASTER : std_logic;
  signal s_WB_ERR_TO_MASTER    : std_logic;
  signal s_WB_RTY_TO_MASTER    : std_logic;
  signal s_WB_SEL_FROM_MASTER  : std_logic_vector(c_WishBoneSelWidth - 1 downto 0);
  signal s_WB_STB_FROM_MASTER  : std_logic;
  signal s_WB_TGD_TO_MASTER    : std_logic_vector(c_WishboneTagDataWidth - 1 downto 0);
  signal s_WB_TGD_FROM_MASTER  : std_logic_vector(c_WishboneTagDataWidth - 1 downto 0);
  signal s_WB_TGA_FROM_MASTER  : std_logic_vector(c_WishboneTagAddrWidth - 1 downto 0);
  signal s_WB_TGC_FROM_MASTER  : std_logic_vector(c_WishboneTagCycleWidth - 1 downto 0);
  signal s_WB_WE_FROM_MASTER   : std_logic;

  signal s_ADDR_FROM_MASTER_CONSOLE : std_logic_vector(c_WishboneAddrWidth - 1 downto 0);
  signal s_DATA_FROM_MASTER_CONSOLE : std_logic_vector(c_WishboneDataWidth - 1 downto 0);
  signal s_SEL_FROM_MASTER_CONSOLE  : std_logic_vector(c_WishBoneSelWidth - 1 downto 0);
  signal s_WE_FROM_MASTER_CONSOLE   : std_logic;
  signal s_CYC_FROM_MASTER_CONSOLE  : std_logic;
  signal s_STB_FROM_MASTER_CONSOLE  : std_logic;
  signal s_DATA_TO_MASTER_CONSOLE   : std_logic_vector(c_WishboneDataWidth - 1 downto 0);
  signal s_ACK_TO_MASTER_CONSOLE    : std_logic;                                     
  signal s_ERR_TO_MASTER_CONSOLE    : std_logic;
  signal s_RTY_TO_MASTER_CONSOLE    : std_logic;

  signal s_ADDR_FROM_MASTER_uP : std_logic_vector(c_WishboneAddrWidth - 1 downto 0);
  signal s_DATA_FROM_MASTER_uP : std_logic_vector(c_WishboneDataWidth - 1 downto 0);
  signal s_SEL_FROM_MASTER_uP  : std_logic_vector(c_WishBoneSelWidth - 1 downto 0);
  signal s_WE_FROM_MASTER_uP   : std_logic;
  signal s_CYC_FROM_MASTER_uP  : std_logic;
  signal s_STB_FROM_MASTER_uP  : std_logic;
  signal s_DATA_TO_MASTER_uP   : std_logic_vector(c_WishboneDataWidth - 1 downto 0);
  signal s_ACK_TO_MASTER_uP    : std_logic;                                     
  signal s_ERR_TO_MASTER_uP    : std_logic;
  signal s_RTY_TO_MASTER_uP    : std_logic;

  -- Wishbone glue

  signal s_ADDR_TO_SLAVES      : std_logic_vector(c_WishboneAddrWidth - 1 downto 0);
  signal s_DATA_TO_SLAVES      : std_logic_vector(c_WishboneDataWidth - 1 downto 0);
  signal s_WE_TO_SLAVES        : std_logic;
  signal s_STB_TO_SLAVES       : std_logic;
  
  -- WISHBONE individual signals
  --              -> PWMGenerator
  signal s_DATA_FROM_PWMGENERATOR      : std_logic_vector(c_WishboneDataWidth - 1 downto 0);
  signal s_ACTIVATE_TO_PWMGENERATOR    : std_logic;
  signal s_ACK_FROM_PWMGENERATOR       : std_logic;
  signal s_STB_TO_PWMGENERATOR         : std_logic;
  --              -> Motor Control
  signal s_DATA_FROM_MOTORCONTROL      : std_logic_vector(c_WishboneDataWidth - 1 downto 0);
  signal s_ACTIVATE_TO_MOTORCONTROL    : std_logic;
  signal s_ACK_FROM_MOTORCONTROL       : std_logic;
  signal s_STB_TO_MOTORCONTROL         : std_logic;
  --              -> USOCCONTROLLER
  signal s_DATA_FROM_USOCCONTROLLER   : std_logic_vector(c_WishboneDataWidth - 1 downto 0);
  signal s_ACTIVATE_TO_USOCCONTROLLER : std_logic;
  signal s_ACK_FROM_USOCCONTROLLER    : std_logic;
  signal s_STB_TO_USOCCONTROLLER      : std_logic;
  --              -> MINIUART
  signal s_DATA_FROM_MINIUART   : std_logic_vector(c_WishboneDataWidth - 1 downto 0);
  signal s_ACTIVATE_TO_MINIUART : std_logic;
  signal s_ACK_FROM_MINIUART    : std_logic;
  signal s_STB_TO_MINIUART      : std_logic;
  --              -> LED Interface
  signal s_DATA_FROM_LEDINTERFACE   : std_logic_vector(c_WishboneDataWidth - 1 downto 0);
  signal s_ACTIVATE_TO_LEDINTERFACE : std_logic;
  signal s_ACK_FROM_LEDINTERFACE    : std_logic;
  signal s_STB_TO_LEDINTERFACE      : std_logic;
  --              -> INTERNAL MEMORY
  signal s_DATA_FROM_INTERNALMEMORY   : std_logic_vector(c_WishboneDataWidth - 1 downto 0);
  signal s_ACTIVATE_TO_INTERNALMEMORY : std_logic;
  signal s_ACK_FROM_INTERNALMEMORY    : std_logic;
  signal s_STB_TO_INTERNALMEMORY      : std_logic;
  --              -> FLASH CONTROLLER
  signal s_DATA_FROM_FLASHCONTROLLER   : std_logic_vector(c_WishboneDataWidth - 1 downto 0);
  signal s_ACTIVATE_TO_FLASHCONTROLLER : std_logic;
  signal s_ACK_FROM_FLASHCONTROLLER    : std_logic;
  signal s_STB_TO_FLASHCONTROLLER      : std_logic;
  --              -> FLASH
  signal s_DATA_FROM_FLASH_WB1   : std_logic_vector(c_WishboneDataWidth - 1 downto 0);
  signal s_DATA_FROM_FLASH_WB2   : std_logic_vector(c_WishboneDataWidth - 1 downto 0);
  signal s_ACTIVATE_TO_FLASH     : std_logic;
  signal s_ACK_FROM_FLASH_WB1    : std_logic;
  signal s_ACK_FROM_FLASH_WB2    : std_logic;
  signal s_STB_TO_FLASH_WB1      : std_logic;
  signal s_STB_TO_FLASH_WB2      : std_logic;
  signal s_ACTIVATE_TO_FLASH_WB1 : std_logic;
  --              -> FLASH PROGRAM CACHE
  signal s_DATA_FROM_FLASHPROGRAMCACHE   : std_logic_vector(c_WishboneDataWidth - 1 downto 0);
  signal s_ACTIVATE_TO_FLASHPROGRAMCACHE : std_logic;
  signal s_ACK_FROM_FLASHPROGRAMCACHE    : std_logic;
  signal s_STB_TO_FLASHPROGRAMCACHE      : std_logic;
  --              -> Signal Analyzer Controller
  signal s_DATA_FROM_SIGNALANALYZERCONTROLLER   : std_logic_vector(c_WishboneDataWidth - 1 downto 0);
  signal s_ACTIVATE_TO_SIGNALANALYZERCONTROLLER : std_logic;
  signal s_ACK_FROM_SIGNALANALYZERCONTROLLER    : std_logic;
  signal s_STB_TO_SIGNALANALYZERCONTROLLER      : std_logic;

  -- UART
  signal UART_TX_INTERRUPT : std_logic;
  signal UART_RX_INTERRUPT : std_logic;
  signal s_UART_TX : std_logic;

  -- Stack memory
  signal s_StackMemoryBusy : std_logic;
  signal s_DataToStack     : std_logic_vector(31 downto 0);
  signal s_AddrToStack     : std_logic_vector(9 downto 0);
  signal s_DataFromStack   : std_logic_vector(31 downto 0);
  signal s_WEToStack       : std_logic_vector(0 downto 0);

  -- WB
  signal s_WBBusy     : std_logic;
  signal s_DataToWB   : std_logic_vector(wordSize-1 downto 0);
  signal s_AddrToWB   : std_logic_vector(maxAddrBitIncIO downto 0);
  signal s_DataFromWB : std_logic_vector(wordSize-1 downto 0);
  signal s_WEToWB     : std_logic;
  signal s_REToWB     : std_logic;

  -- Program memory
  signal s_ProgramMemoryBusy : std_logic;
  signal s_AddrToProgram     : std_logic_vector(12 downto 0);
  signal s_DataFromProgram   : std_logic_vector(31 downto 0);
  signal s_WEToProgram       : std_logic_vector(0 downto 0);

  -- FLASH
  signal s_FlashProgramMode    : std_logic;
  signal s_ITF_DATA_TO_FLASH   : std_logic_vector(15 downto 0);
  signal s_ITF_DATA_FROM_FLASH : std_logic_vector(15 downto 0);
  signal s_ITF_ADDR_TO_FLASH   : std_logic_vector(20 downto 0);
  signal s_FLASH_BIDIR_CONTROL : std_logic;
  signal s_CENeg_TO_FLASH      : std_logic;
  signal s_OENeg_TO_FLASH      : std_logic;
  signal s_WENeg_TO_FLASH      : std_logic;
  signal s_RESETNeg_TO_FLASH   : std_logic;
  signal s_WPNeg_TO_FLASH      : std_logic;
  signal s_BYTENeg_TO_FLASH    : std_logic;
  signal s_RY_FROM_FLASH       : std_logic;
  signal s_AddrFromController  : std_logic_vector(20 downto 0);
  signal s_DataFromController  : std_logic_vector(15 downto 0);
  signal s_DataToController    : std_logic_vector(15 downto 0);
  signal s_WENegFromController : std_logic;
  signal s_OENegFromController : std_logic;
  signal s_CENegFromController : std_logic;
  signal s_Access              : std_logic;
  signal s_WBAccess            : std_logic;
  signal s_ADDR_TO_FLASH_WB1   : std_logic_vector(c_WishboneAddrWidth - 1 downto 0);
  signal s_DATA_TO_FLASH_WB1   : std_logic_vector(c_WishboneDataWidth - 1 downto 0);
  signal s_WE_TO_FLASH_WB1     : std_logic;
  signal s_ADDR_TO_FLASH_WB2   : std_logic_vector(c_WishboneAddrWidth - 1 downto 0);
  signal s_DATA_TO_FLASH_WB2   : std_logic_vector(c_WishboneDataWidth - 1 downto 0);
  signal s_WE_TO_FLASH_WB2     : std_logic;

  -- FLASH PROGRAM CACHE
  signal s_WEFromInMuxToRAM        : std_logic_vector(0 downto 0);
  signal s_DataFromInMuxToRAM      : std_logic_vector(31 downto 0);
  signal s_DataFromRAMToControl    : std_logic_vector(31 downto 0);
  signal s_AddressFromInMuxToRAM   : std_logic_vector(2 downto 0);
  signal s_AddressFromOutMuxToRAM  : std_logic_vector(2 downto 0);

  -- SIGNAL ANALYZER
  signal s_WE_FROM_SIGNALANALYZERCONTROLLER           : std_logic_vector(0 downto 0);
  signal s_ADDRESS_FROM_SIGNALANALYZERCONTROLLER      : std_logic_vector(7 downto 0);
  signal s_TRIGGER_TO_SIGNALANALYZERCONTROLLER        : std_logic_vector(31 downto 0);
  signal s_DATA_FROM_MEM1_TO_SIGNALANALYZERCONTROLLER : std_logic_vector(31 downto 0);
  signal s_DATA_FROM_MEM2_TO_SIGNALANALYZERCONTROLLER : std_logic_vector(31 downto 0);
  signal s_DATA_FROM_SIGNALANALYZERCONTROLLER_TO_RAM1 : std_logic_vector(31 downto 0);
  signal s_DATA_FROM_SIGNALANALYZERCONTROLLER_TO_RAM2 : std_logic_vector(31 downto 0);
  signal s_DATA_TO_BE_CAPTURED1                       : std_logic_vector(31 downto 0);
  signal s_DATA_TO_BE_CAPTURED2                       : std_logic_vector(31 downto 0);

  -- CPU control signals
  signal enable             : std_logic;
  signal mem_busy           : std_logic;
  signal mem_read           : std_logic_vector(wordSize-1 downto 0);
  signal mem_write          : std_logic_vector(wordSize-1 downto 0);
  signal mem_addr           : std_logic_vector(maxAddrBitIncIO downto 0);
  signal mem_writeEnable    : std_logic;
  signal mem_readEnable     : std_logic;
  signal mem_writeMask      : std_logic_vector(wordBytes-1 downto 0);
  signal interrupt1         : std_logic;
  signal interrupt2         : std_logic;
  signal interrupt3         : std_logic;
  signal break              : std_logic;
  signal io_busy            : std_logic;
  signal io_mem_read        : std_logic_vector(wordSize-1 downto 0);
  signal io_mem_writeEnable : std_logic;
  signal io_mem_readEnable  : std_logic;
  signal dram_mem_busy        : std_logic;
  signal dram_mem_read        : std_logic_vector(wordSize-1 downto 0);
  signal dram_mem_write       : std_logic_vector(wordSize-1 downto 0);
  signal dram_mem_writeEnable : std_logic;
  signal dram_mem_readEnable  : std_logic;
  signal dram_mem_writeMask   : std_logic_vector(wordBytes-1 downto 0);

  signal dram_ready           : std_logic;
    signal io_ready             : std_logic;
    signal io_reading           : std_logic;

  -- IRQ
  signal s_IRQ_FlashController : std_logic;

  -- Console RAM
  signal s_AddressToConsoleRAMFromFlashController : std_logic_vector(2 downto 0);
  signal s_DataFromConsoleRAMToFlashController    : std_logic_vector(31 downto 0);
  signal s_AddressFromConsoleToConsoleRAM         : std_logic_vector(2 downto 0);
  signal s_DataFromConsoleToConsoleRAM            : std_logic_vector(31 downto 0);
  signal s_WEFromConsoleToConsoleRAM              : std_logic_vector(0 downto 0);
  signal s_DoProgram   : std_logic;
  signal s_ProgramDone : std_logic;


  -- Other
  signal s_ClockSynthesizer_status : std_logic_vector(7 downto 0);
  signal s_ClockSynthesizer_locked : std_logic;
  signal s_tmp1 : std_logic;
  signal s_tmp2 : std_logic;

  -- DEBUG
  signal s_DebugConsole   : std_logic_vector(31 downto 0);
  signal s_DebugFlashController   : std_logic_vector(3 downto 0);
  signal s_Debug_Miniuart : std_logic_vector(3 downto 0);
  signal s_DebugwbMemoryWrapper : std_logic;
  signal s_DebugFlashWrapper : std_logic_vector(7 downto 0);
  
begin


  -- INSTANCES

  i_DebugController : DebugController
    generic map (
    log_file => "DebugController.txt" )
    port map (
      clk                  => s_clk32,
      reset                => s_LogicReset,
      p_DebugOversampling  => open
      );

  i_TICTimer16 : TICTimer
    generic map (
    log_file => "TICTimer16.txt" )
    port map (
      clk        => s_clk16,
      reset      => s_LogicReset,
      p_TICTimer => s_TICTimer16);

  i_TICTimer50 : TICTimer
    generic map (
    log_file => "TICTimer50.txt" )
    port map (
      clk        => s_clk50,
      reset      => s_LogicReset,
      p_TICTimer => s_TICTimer50);

  i_ResetGenerator : ResetGenerator
    generic map (
    log_file => "ResetGenerator.txt" )
    port map (
      clk             => s_clk32,
      areset          => s_reset,
      zreset          => s_resetZPU,
      p_LogicReset    => s_LogicReset,
      p_LogicResetZPU => s_LogicResetZPU);

  i_ClockSynthesizer : ClockSynthesizer
    port map (
      CLKIN_IN        => clk,
      RST_IN          => s_tmp2,
      CLKFX_OUT       => s_clk50,
      CLKIN_IBUFG_OUT => open,
      CLK0_OUT        => s_clk16,
      CLK2X_OUT       => s_clk32,
      CLK180_OUT      => s_clk16_inv,
      LOCKED_OUT      => s_ClockSynthesizer_locked,
      STATUS_OUT      => s_ClockSynthesizer_status
      );

  -- CPU subsystem
  zpu: zpu_core
    port map (
      clk                 => s_clk32,
      reset               => s_LogicResetZPU,
      enable              => enable,
      in_mem_busy         => mem_busy,
      mem_read            => mem_read,
      mem_write           => mem_write,
      out_mem_addr        => mem_addr,
      out_mem_writeEnable => mem_writeEnable,
      out_mem_readEnable  => mem_readEnable,
      mem_writeMask       => mem_writeMask,
      interrupt           => interrupt2,
      break               => break
    );


  i_wbIntercon : wbIntercon
    generic map (
      log_file => "wbIntercon.txt" )
    port map (
      -- WISHBONE CONTROL SIGNALS
      CLK_I  => s_clk32,
      RST_I  => s_reset,
      -- WISHBONE MASTER PORT 1
      MASTER_1_ADDR_O => s_ADDR_FROM_MASTER_CONSOLE,
      MASTER_1_DAT_O  => s_DATA_FROM_MASTER_CONSOLE,
      MASTER_1_SEL_O  => s_SEL_FROM_MASTER_CONSOLE,
      MASTER_1_WE_O   => s_WE_FROM_MASTER_CONSOLE,
      MASTER_1_CYC_O  => s_CYC_FROM_MASTER_CONSOLE,
      MASTER_1_STB_O  => s_STB_FROM_MASTER_CONSOLE,
      MASTER_1_DAT_I  => s_DATA_TO_MASTER_CONSOLE,
      MASTER_1_ACK_I  => s_ACK_TO_MASTER_CONSOLE,
      MASTER_1_ERR_I  => s_ERR_TO_MASTER_CONSOLE,
      MASTER_1_RTY_I  => s_RTY_TO_MASTER_CONSOLE,
      -- WISHBONE MASTER PORT 1
      MASTER_2_ADDR_O => s_ADDR_FROM_MASTER_uP,
      MASTER_2_DAT_O  => s_DATA_FROM_MASTER_uP,
      MASTER_2_SEL_O  => s_SEL_FROM_MASTER_uP,
      MASTER_2_WE_O   => s_WE_FROM_MASTER_uP,
      MASTER_2_CYC_O  => s_CYC_FROM_MASTER_uP,
      MASTER_2_STB_O  => s_STB_FROM_MASTER_uP,
      MASTER_2_DAT_I  => s_DATA_TO_MASTER_uP,
      MASTER_2_ACK_I  => s_ACK_TO_MASTER_uP,
      MASTER_2_ERR_I  => s_ERR_TO_MASTER_uP,
      MASTER_2_RTY_I  => s_RTY_TO_MASTER_uP,
      -- WISHBONE SLAVE PORT (COMMON)
      SLAVE_ADDR          => s_ADDR_TO_SLAVES,
      SLAVE_DATA_TO_SLAVE => s_DATA_TO_SLAVES,
      SLAVE_WE            => s_WE_TO_SLAVES,

      -- WISHBONE SLAVE PORT (BY SLAVE)
      SLAVE_DATA_FROM_SLAVE_0 => s_DATA_FROM_MINIUART,
      SLAVE_ACK_FROM_SLAVE_0  => s_ACK_FROM_MINIUART,
      SLAVE_ACTIVATE_0        => s_ACTIVATE_TO_MINIUART,
      SLAVE_STB_0             => s_STB_TO_MINIUART,
      SLAVE_DATA_FROM_SLAVE_1 => s_DATA_FROM_LEDINTERFACE,
      SLAVE_ACK_FROM_SLAVE_1  => s_ACK_FROM_LEDINTERFACE,
      SLAVE_ACTIVATE_1        => s_ACTIVATE_TO_LEDINTERFACE,
      SLAVE_STB_1             => s_STB_TO_LEDINTERFACE,
      SLAVE_DATA_FROM_SLAVE_2 => s_DATA_FROM_USOCCONTROLLER,
      SLAVE_ACK_FROM_SLAVE_2  => s_ACK_FROM_USOCCONTROLLER,
      SLAVE_ACTIVATE_2        => s_ACTIVATE_TO_USOCCONTROLLER,
      SLAVE_STB_2             => s_STB_TO_USOCCONTROLLER,
      SLAVE_DATA_FROM_SLAVE_3 => s_DATA_FROM_FLASHCONTROLLER,
      SLAVE_ACK_FROM_SLAVE_3  => s_ACK_FROM_FLASHCONTROLLER,
      SLAVE_ACTIVATE_3        => s_ACTIVATE_TO_FLASHCONTROLLER,
      SLAVE_STB_3             => s_STB_TO_FLASHCONTROLLER,
      SLAVE_DATA_FROM_SLAVE_4 => s_DATA_FROM_FLASH_WB1,
      SLAVE_ACK_FROM_SLAVE_4  => s_ACK_FROM_FLASH_WB1,
      SLAVE_ACTIVATE_4        => s_ACTIVATE_TO_FLASH_WB1,
      SLAVE_STB_4             => s_STB_TO_FLASH_WB1,
      SLAVE_DATA_FROM_SLAVE_5 => s_DATA_FROM_FLASHPROGRAMCACHE,
      SLAVE_ACK_FROM_SLAVE_5  => s_ACK_FROM_FLASHPROGRAMCACHE,
      SLAVE_ACTIVATE_5        => s_ACTIVATE_TO_FLASHPROGRAMCACHE,
      SLAVE_STB_5             => s_STB_TO_FLASHPROGRAMCACHE,
      SLAVE_DATA_FROM_SLAVE_6 => s_DATA_FROM_MOTORCONTROL,
      SLAVE_ACK_FROM_SLAVE_6  => s_ACK_FROM_MOTORCONTROL,
      SLAVE_ACTIVATE_6        => s_ACTIVATE_TO_MOTORCONTROL,
      SLAVE_STB_6             => s_STB_TO_MOTORCONTROL,
      SLAVE_DATA_FROM_SLAVE_7 => s_DATA_FROM_PWMGENERATOR,
      SLAVE_ACK_FROM_SLAVE_7  => s_ACK_FROM_PWMGENERATOR,
      SLAVE_ACTIVATE_7        => s_ACTIVATE_TO_PWMGENERATOR,
      SLAVE_STB_7             => s_STB_TO_PWMGENERATOR

      );

  i_Console : Console
    generic map (
    log_file => "Console.txt" )
    port map (

      -- Wishbone interface (CONTROL)
      CLK_I          => s_clk32,
      RST_I          => s_LogicReset,
      -- Wishbone interface (MASTER)
      ADDR_O  => s_ADDR_FROM_MASTER_CONSOLE,
      DAT_O   => s_DATA_FROM_MASTER_CONSOLE,
      SEL_O   => s_SEL_FROM_MASTER_CONSOLE, 
      WE_O    => s_WE_FROM_MASTER_CONSOLE,
      CYC_O   => s_CYC_FROM_MASTER_CONSOLE,
      STB_O   => s_STB_FROM_MASTER_CONSOLE,
      DAT_I   => s_DATA_TO_MASTER_CONSOLE,
      ACK_I   => s_ACK_TO_MASTER_CONSOLE,
      ERR_I   => s_ERR_TO_MASTER_CONSOLE,
      RTY_I   => s_RTY_TO_MASTER_CONSOLE,
      -- Direct interface to console RAM
      p_DataToConsoleRAM    => s_DataFromConsoleToConsoleRAM,
      p_AddressToConsoleRAM => s_AddressFromConsoleToConsoleRAM,
      p_WEToConsoleRAM      => s_WEFromConsoleToConsoleRAM,
      p_DoProgram       => s_DoProgram,
      p_ProgramDone     => s_ProgramDone,
      
      -- UART interface
      p_UARTRxInterrupt => UART_RX_INTERRUPT,
      p_UARTTxInterrupt => UART_TX_INTERRUPT,
      -- DEBUG
      p_Debug => s_DebugConsole
      
      );

  i_wbMaster : wbMaster
    port map (

      -- WISHBONE MASTER interface
      CLK_I  => s_clk32,
      RST_I  => s_reset,
      DAT_I  => s_DATA_TO_MASTER_uP,
      DAT_O  => s_DATA_FROM_MASTER_uP,
      ACK_I  => s_ACK_TO_MASTER_uP,
      ADDR_O => s_ADDR_FROM_MASTER_uP,
      CYC_O  => s_CYC_FROM_MASTER_uP,
      LOCK_O => open,
      ERR_I  => s_ERR_TO_MASTER_uP,
      RTY_I  => '0',
      SEL_O  => s_SEL_FROM_MASTER_uP,
      STB_O  => s_STB_FROM_MASTER_uP,
      TGD_I  => (others => '0'),
      TGD_O  => open,
      TGA_O  => open,
      TGC_O  => open,
      WE_O   => s_WE_FROM_MASTER_uP,

      -- ZPU Bus interface
      ZPU_busy        => s_WBBusy,
      ZPU_read        => s_DataFromWB,
      ZPU_writeEnable => s_WEToWB,
      ZPU_readEnable  => s_REToWB,
      ZPU_addr        => s_AddrToWB,
      ZPU_write       => s_DataToWB
      );

  i_ZPUBus : ZPUBus
    port map (

      -- clock and reset
      clk                 => s_clk32,
      reset               => s_LogicReset,

      -- ROM interface
      ACK_I               => s_ACK_FROM_FLASH_WB2,
      ADDR_O              => s_ADDR_TO_FLASH_WB2,
      DAT_O               => s_DATA_TO_FLASH_WB2,
      DAT_I               => s_DATA_FROM_FLASH_WB2,
      STB_O               => s_STB_TO_FLASH_WB2,
      WE_O                => s_WE_TO_FLASH_WB2,

      -- RAM interface
      ram_busy            => s_StackMemoryBusy,
      ram_address         => s_AddrToStack,
      ram_DataWrite       => s_DataToStack,
      ram_DataRead        => s_DataFromStack,
      ram_WE              => s_WEToStack(0),

      -- WB interface
      WB_busy            => s_WBBusy,
      WB_address         => s_AddrToWB,
      WB_DataWrite       => s_DataToWB,
      WB_DataRead        => s_DataFromWB,
      WB_WE              => s_WEToWB,
      WB_RE              => s_REToWB,
      
      -- ZPU interface
      zpu_mem_busy         => mem_busy,
      zpu_mem_read         => mem_read,
      zpu_writeEnable      => mem_writeEnable,
      zpu_readEnable       => mem_readEnable,
      zpu_mem_addr         => mem_addr,
      zpu_mem_write        => mem_write,
      zpu_mem_writeMask    => mem_writeMask
      );

  s_StackMemoryBusy <= mem_readEnable;
  s_ProgramMemoryBusy <= mem_readEnable;

  i_ButtonCaption1 : ButtonCaption
    generic map (
    log_file => "ButtonCaptionGenerator1.txt" )
    port map (
      clk              => s_clk32,
      reset            => s_LogicReset,
      p_FromButton     => p_FromButton1,
      p_ButtonPressed  => s_ButtonPressed1,
      p_ButtonInterrupt => interrupt1);

  i_ButtonCaption2 : ButtonCaption
    generic map (
    log_file => "ButtonCaptionGenerator2.txt" )
    port map (
      clk              => s_clk32,
      reset            => s_LogicReset,
      p_FromButton     => p_FromButton2,
      p_ButtonPressed  => s_ButtonPressed2,
      p_ButtonInterrupt => interrupt2);

  i_ButtonCaption3 : ButtonCaption
    generic map (
    log_file => "ButtonCaptionGenerator3.txt" )
    port map (
      clk              => s_clk32,
      reset            => s_LogicReset,
      p_FromButton     => p_FromButton3,
      p_ButtonPressed  => s_ButtonPressed3,
      p_ButtonInterrupt => interrupt3);

  i_SimpleCounter : SimpleCounter
    generic map (
    log_file => "SimpleCounterGenerator.txt" )
    port map (
      clk              => s_clk32,
      reset            => s_LogicReset,
      p_TIC            => s_ButtonPressed1,
      p_Counter        => s_Counter8
      );

  -- Miniuart instantiation
  i_Miniuart : miniuart
    generic map (
      --BRDIVISOR => 35)
      BRDIVISOR => 17)
      --BRDIVISOR => 9)
    port map(
      WB_CLK_I => s_clk32,
      WB_RST_I => s_LogicReset,
      WB_ADR_I => s_ADDR_TO_SLAVES(1 downto 0),
      WB_DAT_I => s_DATA_TO_SLAVES(7 downto 0),
      WB_DAT_O => s_DATA_FROM_MINIUART(7 downto 0),
      WB_WE_I  => s_WE_TO_SLAVES,
      WB_STB_I => s_STB_TO_MINIUART,
      WB_ACK_O => s_ACK_FROM_MINIUART,
      -- process signals     
      IntTx_O  => UART_TX_INTERRUPT,
      IntRx_O  => UART_RX_INTERRUPT,
      BR_Clk_I => s_clk16,
      TxD_PAD_O => s_UART_TX,
      RxD_PAD_I => p_UART_RX,
      p_Debug => s_Debug_Miniuart(3 downto 0)
      );

    i_LEDInterface : LEDInterface
    generic map (
      log_file     => "LEDInterface.out",
      base_address => C_LEDINTERFACE_BASE_ADDRESS)
    port map (
      CLK_I  => s_clk32,
      RST_I  => s_LogicReset,
      ACK_O  => s_ACK_FROM_LEDINTERFACE,
      ADDR_I => s_ADDR_TO_SLAVES,
      DAT_I  => s_DATA_TO_SLAVES,
      DAT_O  => s_DATA_FROM_LEDINTERFACE,
      STB_I  => s_STB_TO_LEDINTERFACE,
      WE_I   => s_WE_TO_SLAVES,
      p_InLeds => s_DATA_TO_BE_CAPTURED1,
      P_LEDs => s_LEDS
    );

    i_uSoCController : uSoCController
    generic map (
      g_log_file     => "uSoCController.out",
      g_base_address => C_USOCCONTROLLER_BASE_ADDRESS)
    port map (
      CLK_I      => s_clk32,
      RST_I      => s_LogicReset,
      ACK_O      => s_ACK_FROM_USOCCONTROLLER,
      ADDR_I     => s_ADDR_TO_SLAVES,
      DAT_I      => s_DATA_TO_SLAVES,
      DAT_O      => s_DATA_FROM_USOCCONTROLLER,
      STB_I      => s_STB_TO_USOCCONTROLLER,
      WE_I       => s_WE_TO_SLAVES,
      p_Enable   => enable,
      p_ResetZPU => s_resetZPU
    );

    i_FlashWrapper : FlashWrapper
    generic map (
      log_file     => "FlashWrapper.out",
      base_address => C_FLASH_BASE_ADDRESS)
    port map (

      -- Clock & Reset
      CLK_I  => s_clk32,
      RST_I  => s_LogicReset,

      -- Control signals
      p_WBAccess => s_WBAccess,

      -- Interface to ZPUBus (WB2)
      ACK_O_WB2  => s_ACK_FROM_FLASH_WB2,
      ADDR_I_WB2 => s_ADDR_TO_FLASH_WB2,
      DAT_I_WB2  => s_DATA_TO_FLASH_WB2,
      DAT_O_WB2  => s_DATA_FROM_FLASH_WB2,
      STB_I_WB2  => s_STB_TO_FLASH_WB2,
      WE_I_WB2   => s_WE_TO_FLASH_WB2,

      -- Interface to WB (WB1)
      ACK_O_WB1  => s_ACK_FROM_FLASH_WB1,
      ADDR_I_WB1 => s_ADDR_TO_SLAVES,
      DAT_I_WB1  => s_DATA_TO_SLAVES,
      DAT_O_WB1  => s_DATA_FROM_FLASH_WB1,
      STB_I_WB1  => s_STB_TO_FLASH_WB1,
      WE_I_WB1   => s_WE_TO_SLAVES,

      -- Interface to FLASH controller
      p_AddressFromController => s_AddrFromController,
      p_ProgramMode           => s_FlashProgramMode,
      p_DataFromController    => s_DataFromController,
      p_WENegFromController   => s_WENegFromController,
      p_OENegFromController   => s_OENegFromController,
      p_CENegFromController   => s_CENegFromController,
      p_DataToController      => s_DataToController,
      p_Access                => s_Access,

      -- Interface to FLASH
      o_DataToMem    => s_ITF_DATA_TO_FLASH,
      i_DataFromMem  => s_ITF_DATA_FROM_FLASH,
      o_BidirControl => s_FLASH_BIDIR_CONTROL,
      o_AddrToMem    => s_ITF_ADDR_TO_FLASH,
      o_CENeg        => s_CENeg_TO_FLASH,
      o_OENeg        => s_OENeg_TO_FLASH,
      o_WENeg        => s_WENeg_TO_FLASH,
      o_WPNeg        => s_WPNeg_TO_FLASH,
      o_BYTENeg      => s_BYTENeg_TO_FLASH,
      i_RY           => s_RY_FROM_FLASH,
      p_Debug        => s_DebugFlashWrapper

    );

    i_FlashController : FlashController
    generic map (
      log_file     => "FlashController.out",
      base_address => C_FLASHCONTROLLER_BASE_ADDRESS)
    port map (
      CLK_I  => s_clk32,
      RST_I  => s_LogicReset,

      -- WB Interface
      --ACK_O  => s_ACK_FROM_FLASHCONTROLLER,
      ACK_O  => s_ACK_FROM_FLASHCONTROLLER,
      ADDR_I => s_ADDR_TO_SLAVES,
      DAT_I  => s_DATA_TO_SLAVES,
      DAT_O  => s_DATA_FROM_FLASHCONTROLLER,
      STB_I  => s_STB_TO_FLASHCONTROLLER,
      WE_I   => s_WE_TO_SLAVES,

      -- Direct interface to console
      p_DataFromConsole => s_DataFromConsoleRAMToFlashController,
      p_AddrToConsole   => s_AddressToConsoleRAMFromFlashController,
      p_DoProgram       => s_DoProgram,
      p_ProgramDone     => s_ProgramDone,

      p_ProgramMode   => s_FlashProgramMode,
      p_WENegFromController   => s_WENegFromController,
      p_OENegFromController   => s_OENegFromController,
      p_CENegFromController   => s_CENegFromController,
      p_AddrToMem     => s_AddrFromController,
      p_DataToMem     => s_DataFromController,
      p_DataFromMem   => s_DataToController,
      p_Access        => s_Access,
      p_WBAccess      => s_WBAccess,
      o_ResetFlash_n  => s_RESETNeg_TO_FLASH,
      i_RY            => s_RY_FROM_FLASH,
      o_Interrupt     => s_IRQ_FlashController,
      p_Debug         => s_DebugFlashController

    );

  i_FlashProgramCache1 : DualRAM_8x32
    port map (
      clka   => s_clk32,
      dina   => s_DataFromInMuxToRAM, 
      addra  => s_AddressFromInMuxToRAM,
      wea    => s_WEFromInMuxToRAM,
      clkb   => s_clk32,
      addrb  => s_AddressFromOutMuxToRAM,
      doutb  => s_DataFromRAMToControl
      );

  i_FlashProgramCacheWrappper : wbMemoryWrapper
    generic map (
      c_NbAddressBits => 3,
      c_NbDataBits    => 32,
      g_base_address  => C_FLASHPROGRAMCACHE_BASE_ADDRESS,
      g_offset        => C_FLASHPROGRAMCACHE_MAX_OFFSET)

    port map
    (

      -- Wishbone interface
      CLK_I  => s_clk32,
      RST_I  => s_LogicReset,
      ACK_O  => s_ACK_FROM_FLASHPROGRAMCACHE,
      ADDR_I => s_ADDR_TO_SLAVES, 
      DAT_I  => s_DATA_TO_SLAVES,
      DAT_O  => s_DATA_FROM_FLASHPROGRAMCACHE,
      STB_I  => s_STB_TO_FLASHPROGRAMCACHE,
      WE_I   => s_WE_TO_SLAVES,

      -- Interface to direct memory
      i_AddrToMemIn  => s_AddressFromConsoleToConsoleRAM,
      i_AddrToMemOut => s_AddressToConsoleRAMFromFlashController,
      i_WEToMemIn    => s_WEFromConsoleToConsoleRAM,
      i_DataToMem    => s_DataFromConsoleToConsoleRAM,
      o_DataFromMem  => s_DataFromConsoleRAMToFlashController,

      o_DataFromInMuxToRAM     => s_DataFromInMuxToRAM,
      o_AddressFromInMuxToRAM  => s_AddressFromInMuxToRAM,
      o_WEFromInMuxToRAM       => s_WEFromInMuxToRAM,
      o_AddressFromOutMuxToRAM => s_AddressFromOutMuxToRAM,
      i_DataFromRAMtoControl   => s_DataFromRAMToControl,
      o_Debug                  => s_DebugwbMemoryWrapper
      
      );

  i_PWMGenerator : PWMGenerator
    generic map (

      g_log_file      => "PWMGenerator.out",
      g_base_address  => C_PWMGENERATOR_BASE_ADDRESS)

    port map
    (

    -- Wishbone interface
    CLK_I  => s_clk32,
    RST_I  => s_LogicReset,
    ACK_O  => s_ACK_FROM_PWMGENERATOR,
    ADDR_I => s_ADDR_TO_SLAVES,
    DAT_I  => s_DATA_TO_SLAVES,
    DAT_O  => s_DATA_FROM_PWMGENERATOR,
    STB_I  => s_STB_TO_PWMGENERATOR,
    WE_I   => s_WE_TO_SLAVES,

    -- PWM interface
    p_PWM0_P => p_PWM0_P,
    p_PWM0_N => p_PWM0_N,
    p_PWM1_P => p_PWM1_P,
    p_PWM1_N => p_PWM1_N

    );

  i_MotorControl : MotorControl
    generic map (

      g_log_file      => "MotorControl.out",
      g_base_address  => C_MOTORCONTROL_BASE_ADDRESS)

    port map
    (

    -- Wishbone interface
    CLK_I  => s_clk32,
    RST_I  => s_LogicReset,
    ACK_O  => s_ACK_FROM_MOTORCONTROL,
    ADDR_I => s_ADDR_TO_SLAVES,
    DAT_I  => s_DATA_TO_SLAVES,
    DAT_O  => s_DATA_FROM_MOTORCONTROL,
    STB_I  => s_STB_TO_MOTORCONTROL,
    WE_I   => s_WE_TO_SLAVES,

    -- Motor interface
    p_MOTOR0_ENABLE => p_MOTOR0_ENABLE,
    p_MOTOR0_OUT0   => p_MOTOR0_OUT0,
    p_MOTOR0_OUT1   => p_MOTOR0_OUT1,
    p_MOTOR0_OUT2   => p_MOTOR0_OUT2,
    p_MOTOR0_OUT3   => p_MOTOR0_OUT3,
    p_MOTOR1_ENABLE => p_MOTOR1_ENABLE,
    p_MOTOR1_OUT0   => p_MOTOR1_OUT0,
    p_MOTOR1_OUT1   => p_MOTOR1_OUT1,
    p_MOTOR1_OUT2   => p_MOTOR1_OUT2,
    p_MOTOR1_OUT3   => p_MOTOR1_OUT3,
    p_MOTOR2_ENABLE => p_MOTOR2_ENABLE,
    p_MOTOR2_OUT0   => p_MOTOR2_OUT0,
    p_MOTOR2_OUT1   => p_MOTOR2_OUT1,
    p_MOTOR2_OUT2   => p_MOTOR2_OUT2,
    p_MOTOR2_OUT3   => p_MOTOR2_OUT3

    );

  -- This memory includes the stack of the ZPU
  i_StackMemory : RAM1024x32
    port map (
      clka   => s_clk32,
      dina   => s_DataToStack,
      addra  => s_AddrToStack,
      wea    => s_WEToStack,
      douta  => s_DataFromStack
      );

  -----------------------------------------------------------------------------
  -- CONTINUOUS ASSIGNMENTS
  -----------------------------------------------------------------------------

  s_RY_FROM_FLASH <= p_FL_RY;

  -- UART
  p_UART_TX <= s_UART_TX;

  -- Ports
  p_LED0 <= s_LEDS(0);
  p_LED1 <= s_LEDS(1);
  p_LED2 <= s_LEDS(2);
  p_LED3 <= s_LEDS(3);

  -- Flash
  p_FL_ADDR20 <= s_ITF_ADDR_TO_FLASH(20);
  p_FL_ADDR19 <= s_ITF_ADDR_TO_FLASH(19);
  p_FL_ADDR18 <= s_ITF_ADDR_TO_FLASH(18);
  p_FL_ADDR17 <= s_ITF_ADDR_TO_FLASH(17);
  p_FL_ADDR16 <= s_ITF_ADDR_TO_FLASH(16);
  p_FL_ADDR15 <= s_ITF_ADDR_TO_FLASH(15);
  p_FL_ADDR14 <= s_ITF_ADDR_TO_FLASH(14);
  p_FL_ADDR13 <= s_ITF_ADDR_TO_FLASH(13);
  p_FL_ADDR12 <= s_ITF_ADDR_TO_FLASH(12);
  p_FL_ADDR11 <= s_ITF_ADDR_TO_FLASH(11);
  p_FL_ADDR10 <= s_ITF_ADDR_TO_FLASH(10);
  p_FL_ADDR9  <= s_ITF_ADDR_TO_FLASH(9);
  p_FL_ADDR8  <= s_ITF_ADDR_TO_FLASH(8);
  p_FL_ADDR7  <= s_ITF_ADDR_TO_FLASH(7);
  p_FL_ADDR6  <= s_ITF_ADDR_TO_FLASH(6);
  p_FL_ADDR5  <= s_ITF_ADDR_TO_FLASH(5);
  p_FL_ADDR4  <= s_ITF_ADDR_TO_FLASH(4);
  p_FL_ADDR3  <= s_ITF_ADDR_TO_FLASH(3);
  p_FL_ADDR2  <= s_ITF_ADDR_TO_FLASH(2);
  p_FL_ADDR1  <= s_ITF_ADDR_TO_FLASH(1);
  p_FL_ADDR0  <= s_ITF_ADDR_TO_FLASH(0);

  p_FL_CENeg    <= s_CENeg_TO_FLASH;
  p_FL_OENeg    <= s_OENeg_TO_FLASH;
  p_FL_WENeg    <= s_WENeg_TO_FLASH;
  --p_FL_RESETNeg <= not s_LogicReset;
  p_FL_RESETNeg <= s_RESETNeg_TO_FLASH;
  --p_FL_WPNeg    <= '1';
  p_FL_ByteNeg  <= '1';

  -- Other
  s_reset <= reset;
  s_tmp1 <= (not s_ClockSynthesizer_locked) and s_ClockSynthesizer_status(2);
  s_tmp2 <= s_tmp1 or s_reset;

  IO_DQ15: IOBUF port map(I => s_ITF_DATA_TO_FLASH(15),O => s_ITF_DATA_FROM_FLASH(15),T => s_FLASH_BIDIR_CONTROL,IO => p_FL_DQ15);
  IO_DQ14: IOBUF port map(I => s_ITF_DATA_TO_FLASH(14),O => s_ITF_DATA_FROM_FLASH(14),T => s_FLASH_BIDIR_CONTROL,IO => p_FL_DQ14);
  IO_DQ13: IOBUF port map(I => s_ITF_DATA_TO_FLASH(13),O => s_ITF_DATA_FROM_FLASH(13),T => s_FLASH_BIDIR_CONTROL,IO => p_FL_DQ13);
  IO_DQ12: IOBUF port map(I => s_ITF_DATA_TO_FLASH(12),O => s_ITF_DATA_FROM_FLASH(12),T => s_FLASH_BIDIR_CONTROL,IO => p_FL_DQ12);
  IO_DQ11: IOBUF port map(I => s_ITF_DATA_TO_FLASH(11),O => s_ITF_DATA_FROM_FLASH(11),T => s_FLASH_BIDIR_CONTROL,IO => p_FL_DQ11);
  IO_DQ10: IOBUF port map(I => s_ITF_DATA_TO_FLASH(10),O => s_ITF_DATA_FROM_FLASH(10),T => s_FLASH_BIDIR_CONTROL,IO => p_FL_DQ10);
  IO_DQ9 : IOBUF port map(I => s_ITF_DATA_TO_FLASH(9), O => s_ITF_DATA_FROM_FLASH(9), T => s_FLASH_BIDIR_CONTROL,IO => p_FL_DQ9);
  IO_DQ8 : IOBUF port map(I => s_ITF_DATA_TO_FLASH(8), O => s_ITF_DATA_FROM_FLASH(8), T => s_FLASH_BIDIR_CONTROL,IO => p_FL_DQ8);
  IO_DQ7 : IOBUF port map(I => s_ITF_DATA_TO_FLASH(7), O => s_ITF_DATA_FROM_FLASH(7), T => s_FLASH_BIDIR_CONTROL,IO => p_FL_DQ7);
  IO_DQ6 : IOBUF port map(I => s_ITF_DATA_TO_FLASH(6), O => s_ITF_DATA_FROM_FLASH(6), T => s_FLASH_BIDIR_CONTROL,IO => p_FL_DQ6);
  IO_DQ5 : IOBUF port map(I => s_ITF_DATA_TO_FLASH(5), O => s_ITF_DATA_FROM_FLASH(5), T => s_FLASH_BIDIR_CONTROL,IO => p_FL_DQ5);
  IO_DQ4 : IOBUF port map(I => s_ITF_DATA_TO_FLASH(4), O => s_ITF_DATA_FROM_FLASH(4), T => s_FLASH_BIDIR_CONTROL,IO => p_FL_DQ4);
  IO_DQ3 : IOBUF port map(I => s_ITF_DATA_TO_FLASH(3), O => s_ITF_DATA_FROM_FLASH(3), T => s_FLASH_BIDIR_CONTROL,IO => p_FL_DQ3);
  IO_DQ2 : IOBUF port map(I => s_ITF_DATA_TO_FLASH(2), O => s_ITF_DATA_FROM_FLASH(2), T => s_FLASH_BIDIR_CONTROL,IO => p_FL_DQ2);
  IO_DQ1 : IOBUF port map(I => s_ITF_DATA_TO_FLASH(1), O => s_ITF_DATA_FROM_FLASH(1), T => s_FLASH_BIDIR_CONTROL,IO => p_FL_DQ1);
  IO_DQ0 : IOBUF port map(I => s_ITF_DATA_TO_FLASH(0), O => s_ITF_DATA_FROM_FLASH(0), T => s_FLASH_BIDIR_CONTROL,IO => p_FL_DQ0);

  -- Debug
  p_Debug1 <= p_UART_RX;                 -- p_UART_RX
  p_Debug2 <= s_UART_TX;                -- p_UART_TX

end Hierarchical;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------
 
