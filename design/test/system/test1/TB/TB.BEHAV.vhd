-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- Testbench
--
-- NOTES:
--
-- $Author: mmartinez $
-- $Date: 2010-07-01 16:59:44 $
-- $Name:  $
-- $Revision: 1.2 $
--
-------------------------------------------------------------------------------

-- *****************
-- *** LIBRARIES ***
-- *****************

library IEEE;
library work;
library fmf;

    USE IEEE.std_logic_1164.ALL;
    USE IEEE.VITAL_timing.ALL;
    USE IEEE.VITAL_primitives.ALL;
    USE STD.textio.ALL;

    USE FMF.gen_utils.all;
    USE FMF.conversions.all;

-- Standard
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- ZPU related

-- SoC packages
use work.SoCConstantsPackage.all;
use work.WishboneConstantsPackage.all;

-- Components
use work.ClockResetGeneratorComponentPackage.all;
use work.uSoCComponentPackage.all;
use work.miniuartComponentPackage.all;
use work.StimuliComponentPackage.all;
use work.ConsoleEmulatorComponentPackage.all;
use work.s29gl032nComponentPackage.all;

-- *************************
-- *** Entity definition ***
-- *************************
entity TB is
end TB;

-----------------------------
-- ARCHITECTURE DEFINITION --
-----------------------------

architecture behav of TB is

  CONSTANT Del1        : VitalDelayType  := 90 ns;

-- *** SIGNAL DECLARATION ***

  signal clk            : std_logic;  -- Clock signal
  signal areset         : std_logic;  -- Asynchronous reset
  signal LED0           : std_ulogic;
  signal LED1           : std_ulogic;
  signal LED2           : std_ulogic;
  signal LED3           : std_ulogic;
  signal FromButton1    : std_logic;    -- TBC to be deleted
  signal FromButton2    : std_logic;    -- TBC to be deleted
  signal FromButton3    : std_logic;    -- TBC to be deleted
  signal FromButton     : std_logic_vector(2 downto 0);

  -- UART signals
  signal UART_TX_DUT    : std_logic;    -- DUT perspective
  signal UART_RX_DUT    : std_logic;    -- DUT perspective

  -- Interrupts
  signal UART_TX_INTERRUPT : std_logic;
  signal UART_RX_INTERRUPT : std_logic;

  -- WISHBONE interface between miniuart and Stimuli generator
  signal WB_ADDR_TO_MINIUART   : std_logic_vector(c_WishboneAddrWidth-1 downto 0);
  signal WB_DATA_TO_MINIUART   : std_logic_vector(c_WishboneDataWidth-1 downto 0);
  signal WB_DATA_FROM_MINIUART : std_logic_vector(c_WishboneDataWidth-1 downto 0);
  signal WB_WE_TO_MINIUART     : std_logic;
  signal WB_STB_TO_MINIUART    : std_logic;
  signal WB_ACK_FROM_MINIUART  : std_logic;

  -- FLASH
  signal s_FL_ADDR20   : std_logic;
  signal s_FL_ADDR19   : std_logic;
  signal s_FL_ADDR18   : std_logic;
  signal s_FL_ADDR17   : std_logic;
  signal s_FL_ADDR16   : std_logic;
  signal s_FL_ADDR15   : std_logic;
  signal s_FL_ADDR14   : std_logic;
  signal s_FL_ADDR13   : std_logic;
  signal s_FL_ADDR12   : std_logic;
  signal s_FL_ADDR11   : std_logic;
  signal s_FL_ADDR10   : std_logic;
  signal s_FL_ADDR9    : std_logic;
  signal s_FL_ADDR8    : std_logic;
  signal s_FL_ADDR7    : std_logic;
  signal s_FL_ADDR6    : std_logic;
  signal s_FL_ADDR5    : std_logic;
  signal s_FL_ADDR4    : std_logic;
  signal s_FL_ADDR3    : std_logic;
  signal s_FL_ADDR2    : std_logic;
  signal s_FL_ADDR1    : std_logic;
  signal s_FL_ADDR0    : std_logic;
  signal s_FL_DQ15     : std_logic;
  signal s_FL_DQ14     : std_logic;
  signal s_FL_DQ13     : std_logic;
  signal s_FL_DQ12     : std_logic;
  signal s_FL_DQ11     : std_logic;
  signal s_FL_DQ10     : std_logic;
  signal s_FL_DQ9      : std_logic;
  signal s_FL_DQ8      : std_logic;
  signal s_FL_DQ7      : std_logic;
  signal s_FL_DQ6      : std_logic;
  signal s_FL_DQ5      : std_logic;
  signal s_FL_DQ4      : std_logic;
  signal s_FL_DQ3      : std_logic;
  signal s_FL_DQ2      : std_logic;
  signal s_FL_DQ1      : std_logic;
  signal s_FL_DQ0      : std_logic;
  signal s_FL_CENeg    : std_logic;
  signal s_FL_OENeg    : std_logic;
  signal s_FL_WENeg    : std_logic;
  signal s_FL_ResetNeg : std_logic;
  signal s_FL_WPNeg    : std_logic;
  signal s_FL_ByteNeg  : std_logic;
  signal s_FL_RY       : std_logic;

-- Motor signals
  signal s_MOTOR0_ENABLE : std_logic;
  signal s_MOTOR0_OUT0   : std_logic;
  signal s_MOTOR0_OUT1   : std_logic;
  signal s_MOTOR0_OUT2   : std_logic;
  signal s_MOTOR0_OUT3   : std_logic;
  signal s_MOTOR1_ENABLE : std_logic;
  signal s_MOTOR1_OUT0   : std_logic;
  signal s_MOTOR1_OUT1   : std_logic;
  signal s_MOTOR1_OUT2   : std_logic;
  signal s_MOTOR1_OUT3   : std_logic;
  signal s_MOTOR2_ENABLE : std_logic;
  signal s_MOTOR2_OUT0   : std_logic;
  signal s_MOTOR2_OUT1   : std_logic;
  signal s_MOTOR2_OUT2   : std_logic;
  signal s_MOTOR2_OUT3   : std_logic;

  -- Pull-Up for the RY signal
  signal s_FL_RY_Pullup: std_logic;

  -- Debug
  signal s_Debug1 : std_logic;
  signal s_Debug2 : std_logic;
  

-- *** COMPONENT DECLARATION ***

-- *** CODE DECLARATION ***

begin

  
-- *** COMPONENT INSTANTIATION ***

  i_ClockResetGenerator : ClockResetGenerator
    generic map (
      clock_half_period => c_ClockHalfPeriod)
    port map (
      clk    => clk,
      areset => areset
      );

  -- Miniuart instantiation
  i_Miniuart : miniuart
    generic map (
      BRDIVISOR => 17)
      --BRDIVISOR => 9)
    port map(
      WB_CLK_I => clk,
      WB_RST_I => areset,
      WB_ADR_I => WB_ADDR_TO_MINIUART(1 downto 0),
      WB_DAT_I => WB_DATA_TO_MINIUART(7 downto 0),
      WB_DAT_O => WB_DATA_FROM_MINIUART(7 downto 0),
      WB_WE_I  => WB_WE_TO_MINIUART,
      WB_STB_I => WB_STB_TO_MINIUART,
      WB_ACK_O => WB_ACK_FROM_MINIUART,
      -- process signals     
      IntTx_O  => UART_TX_INTERRUPT,
      IntRx_O  => UART_RX_INTERRUPT,
      BR_Clk_I => clk,
      TxD_PAD_O => UART_RX_DUT,
      RxD_PAD_I => UART_TX_DUT,
      p_Debug => open
      );


  i_ConsoleEmulator : ConsoleEmulator
    generic map (
    stimuli_file => "ConsoleEmulator.in" )
    port map (

      -- Wishbone interface (CONTROL)
      CLK_I   => clk,
      RST_I   => areset,
      -- Wishbone interface (MASTER)
      ADDR_O  => WB_ADDR_TO_MINIUART,
      DAT_O   => WB_DATA_TO_MINIUART, 
      SEL_O   => open,
      WE_O    => WB_WE_TO_MINIUART,
      CYC_O   => open,
      STB_O   => WB_STB_TO_MINIUART,
      DAT_I   => WB_DATA_FROM_MINIUART,
      ACK_I   => WB_ACK_FROM_MINIUART,
      ERR_I   => '0',
      RTY_I   => '0',
      -- Buttons
      p_Buttons => FromButton,
      -- UART interface
      p_UARTRxInterrupt => UART_RX_INTERRUPT,
      p_UARTTxInterrupt => UART_TX_INTERRUPT
      
      );
    

  i_DUT: uSoC
    port map (
      clk           => clk ,
      reset         => areset,
      p_LED0        => LED0,
      p_LED1        => LED1,
      p_LED2        => LED2,
      p_LED3        => LED3,
      p_FromButton1 => FromButton(0),
      p_FromButton2 => FromButton(1),
      p_FromButton3 => FromButton(2),
      p_UART_TX     => UART_TX_DUT,
      p_UART_RX     => UART_RX_DUT,
      p_MOTOR0_ENABLE => s_MOTOR0_ENABLE,
      p_MOTOR0_OUT0 => s_MOTOR0_OUT0,
      p_MOTOR0_OUT1 => s_MOTOR0_OUT1,
      p_MOTOR0_OUT2 => s_MOTOR0_OUT2,
      p_MOTOR0_OUT3 => s_MOTOR0_OUT3,
      p_MOTOR1_ENABLE => s_MOTOR0_ENABLE,
      p_MOTOR1_OUT0 => s_MOTOR1_OUT0,
      p_MOTOR1_OUT1 => s_MOTOR1_OUT1,
      p_MOTOR1_OUT2 => s_MOTOR1_OUT2,
      p_MOTOR1_OUT3 => s_MOTOR1_OUT3,
      p_MOTOR2_ENABLE => s_MOTOR0_ENABLE,
      p_MOTOR2_OUT0 => s_MOTOR2_OUT0,
      p_MOTOR2_OUT1 => s_MOTOR2_OUT1,
      p_MOTOR2_OUT2 => s_MOTOR2_OUT2,
      p_MOTOR2_OUT3 => s_MOTOR2_OUT3,
      p_FL_ADDR20   => s_FL_ADDR20,
      p_FL_ADDR19   => s_FL_ADDR19,
      p_FL_ADDR18   => s_FL_ADDR18,
      p_FL_ADDR17   => s_FL_ADDR17,
      p_FL_ADDR16   => s_FL_ADDR16,
      p_FL_ADDR15   => s_FL_ADDR15,
      p_FL_ADDR14   => s_FL_ADDR14,
      p_FL_ADDR13   => s_FL_ADDR13,
      p_FL_ADDR12   => s_FL_ADDR12,
      p_FL_ADDR11   => s_FL_ADDR11,
      p_FL_ADDR10   => s_FL_ADDR10,
      p_FL_ADDR9    => s_FL_ADDR9,
      p_FL_ADDR8    => s_FL_ADDR8,
      p_FL_ADDR7    => s_FL_ADDR7,
      p_FL_ADDR6    => s_FL_ADDR6,
      p_FL_ADDR5    => s_FL_ADDR5,
      p_FL_ADDR4    => s_FL_ADDR4,
      p_FL_ADDR3    => s_FL_ADDR3,
      p_FL_ADDR2    => s_FL_ADDR2,
      p_FL_ADDR1    => s_FL_ADDR1,
      p_FL_ADDR0    => s_FL_ADDR0,
      p_FL_DQ15     => s_FL_DQ15,
      p_FL_DQ14     => s_FL_DQ14,
      p_FL_DQ13     => s_FL_DQ13,
      p_FL_DQ12     => s_FL_DQ12,
      p_FL_DQ11     => s_FL_DQ11,
      p_FL_DQ10     => s_FL_DQ10,
      p_FL_DQ9      => s_FL_DQ9,
      p_FL_DQ8      => s_FL_DQ8,
      p_FL_DQ7      => s_FL_DQ7,
      p_FL_DQ6      => s_FL_DQ6,
      p_FL_DQ5      => s_FL_DQ5,
      p_FL_DQ4      => s_FL_DQ4,
      p_FL_DQ3      => s_FL_DQ3,
      p_FL_DQ2      => s_FL_DQ2,
      p_FL_DQ1      => s_FL_DQ1,
      p_FL_DQ0      => s_FL_DQ0,
      p_FL_CENeg    => s_FL_CENeg,
      p_FL_OENeg    => s_FL_OENeg,
      p_FL_WENeg    => s_FL_WENeg,
      p_FL_ResetNeg => s_FL_ResetNeg,
      p_FL_ByteNeg  => s_FL_ByteNeg,
      p_FL_RY       => s_FL_RY_Pullup,
      p_Debug1      => s_Debug1,
      p_Debug2      => s_Debug2
      );

  s_FL_RY_Pullup <= To_X01(s_FL_RY);                       -- 2nd Driver for pull up

  i_Stimuli : Stimuli
    port map (
      clk              => clk ,
      reset            => areset,
      p_ButtonCaption1 => FromButton1,
      p_ButtonCaption2 => FromButton2,
      p_ButtonCaption3 => FromButton3
      );

  i_ParallelFlash : s29gl032n
    generic map (
--      tpd_A0_DQ0     => 90 ns,
--      tpd_A0_DQ1     => Del1,

      UserPreload => true,
      mem_file_name       => "PreloadedFile.mem",
      LongTimming      => false,
      prot_file_name      => "none",
      secsi_file_name     => "none"

  )
    port map (
      A20             => s_FL_ADDR20,
      A19             => s_FL_ADDR19,
      A18             => s_FL_ADDR18,
      A17             => s_FL_ADDR17,
      A16             => s_FL_ADDR16,
      A15             => s_FL_ADDR15,
      A14             => s_FL_ADDR14,
      A13             => s_FL_ADDR13,
      A12             => s_FL_ADDR12,
      A11             => s_FL_ADDR11,
      A10             => s_FL_ADDR10,
      A9              => s_FL_ADDR9,
      A8              => s_FL_ADDR8,
      A7              => s_FL_ADDR7,
      A6              => s_FL_ADDR6,
      A5              => s_FL_ADDR5,
      A4              => s_FL_ADDR4,
      A3              => s_FL_ADDR3,
      A2              => s_FL_ADDR2,
      A1              => s_FL_ADDR1,
      A0              => s_FL_ADDR0,
      
      DQ15            => s_FL_DQ15,
      DQ14            => s_FL_DQ14,
      DQ13            => s_FL_DQ13,
      DQ12            => s_FL_DQ12,
      DQ11            => s_FL_DQ11,
      DQ10            => s_FL_DQ10,
      DQ9             => s_FL_DQ9,
      DQ8             => s_FL_DQ8,
      DQ7             => s_FL_DQ7,
      DQ6             => s_FL_DQ6,
      DQ5             => s_FL_DQ5,
      DQ4             => s_FL_DQ4,
      DQ3             => s_FL_DQ3,
      DQ2             => s_FL_DQ2,
      DQ1             => s_FL_DQ1,
      DQ0             => s_FL_DQ0,
      
      CENeg           => s_FL_CENeg,
      OENeg           => s_FL_OENeg,
      WENeg           => s_FL_WENeg,
      RESETNeg        => s_FL_ResetNeg,
      WPNeg           => '1',
      BYTENeg         => s_FL_ByteNeg,
      RY              => s_FL_RY
      );      

  -- Pullup
  s_FL_RY <= 'H'; 

-- *** CONTINUOUS ASSIGNMENTS ***

end behav;
