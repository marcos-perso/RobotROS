-------------------------------------------------------------------------------
--  Debug controller. It generate sthe debug signals for all the blocks
-- TBD: The Debug controller should be controlled by the CPU
-------------------------------------------------------------------------------

---------------
-- LIBRARIES --
---------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.SOCConstantsPackage.all;
use work.DebugControllerPackage.all;

-----------------------
-- ENTITY DEFINITION --
-----------------------
 
entity DebugController is
  generic (
    log_file:       string -- Debug file
    );
  port(
    clk                 : in  std_logic;
    reset               : in  std_logic;
    p_DebugOversampling : out std_logic
    );  
end DebugController;
