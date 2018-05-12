-------------------------------------------------------------------------------
-- Creates a pulse indicating that the button has been pressed
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
 
entity ButtonCaption is
  generic (
    log_file:       string -- Debug file
    );
  port(
    clk               : in  std_logic;
    reset             : in  std_logic;
    p_FromButton      : in  std_logic;
    p_ButtonPressed   : out std_logic;
    p_ButtonInterrupt : out std_logic
    );  
end ButtonCaption;
