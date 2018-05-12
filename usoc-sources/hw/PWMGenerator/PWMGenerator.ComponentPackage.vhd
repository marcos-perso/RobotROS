
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

package PWMGeneratorComponentPackage is

--------------------------
-- COMPONENT DEFINITION --
--------------------------
 
  component PWMGenerator is
    generic (
      g_log_file     : string;
      g_base_address : integer
      );
    port(

      CLK_I  : in  std_logic;
      RST_I  : in  std_logic;
      ACK_O  : out std_logic;
      ADDR_I : in  std_logic_vector(c_WishboneAddrWidth - 1 downto 0);
      DAT_I  : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0);
      DAT_O  : out std_logic_vector(c_WishboneDataWidth - 1 downto 0);
      STB_I  : in  std_logic;
      WE_I   : in  std_logic;

      p_PWM0_P  : out std_logic;
      p_PWM0_N  : out std_logic;
      p_PWM1_P  : out std_logic;
      p_PWM1_N  : out std_logic

      );

  end component;

end PWMGeneratorComponentPackage;
