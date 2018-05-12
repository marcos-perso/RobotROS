-------------------------------------------------------------------------------
-- ResetGenerator
-------------------------------------------------------------------------------

---------------
-- LIBRARIES --
---------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SOCConstantsPackage.all;

----------------------------------
-- COMPONENT PACKAGE DEFINITION --
----------------------------------

package ResetGeneratorComponentPackage is

--------------------------
-- COMPONENT DEFINITION --
--------------------------
 
  component ResetGenerator is
    generic (
      log_file:       string
      );
    port(
      clk             : in  std_logic;
      areset          : in  std_logic;
      zreset          : in  std_logic;
      p_LogicReset    : out std_logic;
      p_LogicResetZPU : out std_logic
      );
  end component;

end ResetGeneratorComponentPackage;
