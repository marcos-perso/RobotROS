
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

package FlashControllerComponentPackage is

--------------------------
-- COMPONENT DEFINITION --
--------------------------
 
  component FlashController is
    generic (
      log_file:       string;
      base_address : integer      -- Base address
      );
    port(
      CLK_I  : in  std_logic;                                        -- Input clock
      RST_I  : in  std_logic;                                       -- Input reset

      ACK_O  : out std_logic;                                       -- Acknowdledge
      ADDR_I : in  std_logic_vector(c_WishboneAddrWidth - 1 downto 0);
      DAT_I  : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0);  -- Data Input
      DAT_O  : out std_logic_vector(c_WishboneDataWidth - 1 downto 0);  -- Data Output
      STB_I  : in  std_logic;                                       -- Strobe In
      WE_I   : in  std_logic;                                       -- Write Enable
      p_DataFromConsole : in  std_logic_vector(31 downto 0);
      p_AddrToConsole   : out std_logic_vector(2 downto 0);
      p_DoProgram       : in  std_logic;
      p_ProgramDone     : out std_logic;

      p_ProgramMode         : out std_logic;
      p_WENegFromController : out std_logic;
      p_OENegFromController : out std_logic;
      p_CENegFromController : out std_logic;
      p_AddrToMem           : out std_logic_VECTOR(20 downto 0);
      p_DataToMem           : out std_logic_vector(15 downto 0);
      p_DataFromMem         : in  std_logic_vector(15 downto 0);
      p_Access              : out std_logic;
      p_WBAccess            : out std_logic;
      o_ResetFlash_n        : out std_logic;
      i_RY                  : in  std_logic;
      o_Interrupt           : out std_logic;
      p_Debug               : out std_logic_vector(3 downto 0)

      );
  end component;

end FlashControllerComponentPackage;
