-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

---------------
-- LIBRARIES --
---------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SOCConstantsPackage.all;
use work.WishboneConstantsPackage.all;

----------------------------------
-- COMPONENT PACKAGE DEFINITION --
----------------------------------

package ConsoleComponentPackage is

--------------------------
-- COMPONENT DEFINITION --
--------------------------
 
  component Console is
    generic (
      log_file:       string
      );
    port(

      CLK_I  : in  std_logic;
      RST_I  : in  std_logic;
      ADDR_O : out std_logic_vector(c_WishboneAddrWidth - 1 downto 0);
      DAT_O  : out std_logic_vector(c_WishboneDataWidth - 1 downto 0);
      SEL_O  : out std_logic_vector(c_WishBoneSelWidth - 1 downto 0);
      WE_O   : out std_logic;
      CYC_O  : out std_logic;
      STB_O  : out std_logic;
      DAT_I  : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0);
      ACK_I  : in  std_logic;                                     
      ERR_I  : in  std_logic;
      RTY_I  : in  std_logic;   
      p_DoProgram           : out  std_logic;
      p_ProgramDone         : in std_logic;
      p_DataToConsoleRAM    : out std_logic_vector(31 downto 0);
      p_AddressToConsoleRAM : out std_logic_vector(2 downto 0);
      p_WEToConsoleRAM      : out std_logic_vector(0 downto 0);
      p_UARTRxInterrupt : in  std_logic;
      p_UARTTxInterrupt : in  std_logic;
      p_Debug : out std_logic_vector(31 downto 0)

      );
  end component;

end ConsoleComponentPackage;
