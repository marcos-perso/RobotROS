-------------------------------------------------------------------------------
-- Programmable timer
-------------------------------------------------------------------------------

---------------
-- LIBRARIES --
---------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.SOCConstantsPackage.all;

-----------------------
-- ENTITY DEFINITION --
-----------------------
 
entity TICTimer is
  generic (
    log_file:       string -- Debug file
    );
  port(
    clk           : in  std_logic;
    reset         : in  std_logic;
    p_TICTimer    : out  std_ulogic
    );  
end TICTimer;
