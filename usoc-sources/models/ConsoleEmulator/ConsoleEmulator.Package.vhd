-------------------------------------------------------------------------------
-- DESCRIPTION: 
--
-- NOTES:
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
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.SoCConstantsPackage.all;
use work.FileIOUtilsPackage.all;
use work.WishboneConstantsPackage.all;

----------------------------------
-- COMPONENT PACKAGE DEFINITION --
----------------------------------

package ConsoleEmulatorPackage is

  -- TYPES
  type t_FSM_Itf is (e_Idle,
                     e_ReadLine,
                     e_WriteCommand,
                     e_WriteAddress,
                     e_WriteData,
                     e_WriteProgram,
                     e_ReceiveResponse);

  type t_CodeBlock is array (0 to 7) of std_logic_vector(7 downto 0);

  --CONSTANTS
  constant c_STOP_BYTE      : integer := 16#3E#;

  -- PROCEDURES
  procedure WaitNCycles (
    variable NbCycles : in integer;
    signal CLK_I        : in std_logic);

  -----------------------------------------------------------------------------
  -- Procedure to launch a transaction over the Serial interface
  -----------------------------------------------------------------------------
  procedure proc_SerialWriteRegister (
    signal CLK_I             : in    std_logic;
    signal DAT_O             : out   std_logic_vector(c_WishboneDataWidth -1 downto 0);
    signal ADDR_O            : out   std_logic_vector(c_WishboneAddrWidth -1 downto 0);
    signal SEL_O             : out   std_logic_vector(c_WishboneSelWidth -1 downto 0);
    signal WE_O              : out   std_logic;
    signal CYC_O             : out   std_logic;
    signal STB_O             : out   std_logic;
    signal s_Waiting         : out   std_logic;
    signal s_TxInterrupt     : in    std_logic;
    signal s_RxInterrupt     : in    std_logic;
    variable v_Register      : in    integer;
    variable v_Data          : in    std_logic_vector(7 downto 0);
    variable v_WaitCycles    : inout integer

    );

  -----------------------------------------------------------------------------
  -- Procedure to launch a Read Register transaction over the Serial interface
  -----------------------------------------------------------------------------
  procedure proc_SerialReadRegister (
    signal CLK_I             : in    std_logic;
    signal DAT_O             : out   std_logic_vector(c_WishboneDataWidth -1 downto 0);
    signal DAT_I             : in   std_logic_vector(c_WishboneDataWidth -1 downto 0);
    signal ADDR_O            : out   std_logic_vector(c_WishboneAddrWidth -1 downto 0);
    signal SEL_O             : out   std_logic_vector(c_WishboneSelWidth -1 downto 0);
    signal WE_O              : out   std_logic;
    signal CYC_O             : out   std_logic;
    signal STB_O             : out   std_logic;
    signal s_Waiting         : out   std_logic;
    signal s_TxInterrupt     : in    std_logic;
    signal s_RxInterrupt     : in    std_logic;
    variable v_Register      : in    integer;
    variable v_Data          : out    std_logic_vector(7 downto 0);
    variable v_WaitCycles    : inout integer

    );

  -----------------------------------------------------------------------------
  -- Procedure to launch a transaction over the Serial interface
  -----------------------------------------------------------------------------
  procedure proc_SerialWriteAddress (
    signal CLK_I             : in    std_logic;
    signal DAT_O             : out   std_logic_vector(c_WishboneDataWidth -1 downto 0);
    signal ADDR_O            : out   std_logic_vector(c_WishboneAddrWidth -1 downto 0);
    signal SEL_O             : out   std_logic_vector(c_WishboneSelWidth -1 downto 0);
    signal WE_O              : out   std_logic;
    signal CYC_O             : out   std_logic;
    signal STB_O             : out   std_logic;
    signal s_Waiting         : out   std_logic;
    signal s_TxInterrupt     : in    std_logic;
    signal s_RxInterrupt     : in    std_logic;
    variable v_Address32Bits : in    std_logic_vector(31 downto 0);
    variable v_Data32Bits    : in    std_logic_vector(31 downto 0);
    variable v_WaitCycles    : inout integer

    );

  -----------------------------------------------------------------------------
  -- Procedure to launch a Read Address transaction over the Serial interface
  -----------------------------------------------------------------------------
  procedure proc_SerialReadAddress (
    signal CLK_I             : in    std_logic;
    signal DAT_O             : out   std_logic_vector(c_WishboneDataWidth -1 downto 0);
    signal DAT_I             : in   std_logic_vector(c_WishboneDataWidth -1 downto 0);
    signal ADDR_O            : out   std_logic_vector(c_WishboneAddrWidth -1 downto 0);
    signal SEL_O             : out   std_logic_vector(c_WishboneSelWidth -1 downto 0);
    signal WE_O              : out   std_logic;
    signal CYC_O             : out   std_logic;
    signal STB_O             : out   std_logic;
    signal s_Waiting         : out   std_logic;
    signal s_TxInterrupt     : in    std_logic;
    signal s_RxInterrupt     : in    std_logic;
    variable v_Address32Bits : in    std_logic_vector(31 downto 0);
    variable v_Data32Bits    : out    std_logic_vector(31 downto 0);
    variable v_WaitCycles    : inout integer

    );
  
  -- FUNCTIONS
  function String2Command(string_in: string) return t_CommandEmulator;

end ConsoleEmulatorPackage;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------
   
