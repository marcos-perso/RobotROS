-------------------------------------------------------------------------------
-- Programmable timer
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

package TICTimerComponentPackage is

--------------------------
-- COMPONENT DEFINITION --
--------------------------
 
  component TICTimer is
    generic (
      log_file:       string
      );
    port(
      clk         : in std_logic;
      reset       : in std_logic;
      p_TICTimer  : out std_ulogic
      );
  end component;

end TICTimerComponentPackage;
