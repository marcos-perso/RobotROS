-------------------------------------------------------------------------------
-- Reset Generator
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
 
entity ResetGenerator is
  generic (
    log_file:       string -- Debug file
    );
  port(
    clk             : in  std_logic;
    areset          : in  std_logic;
    zreset          : in  std_logic;
    p_LogicReset    : out std_logic;
    p_LogicResetZPU : out std_logic
    );  
end ResetGenerator;
