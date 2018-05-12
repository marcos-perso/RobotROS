-------------------------------------------------------------------------------
-- Simple counter. Counts the number of tics received
-- NOTE TBD: Number of biits in the counter should be generic
-------------------------------------------------------------------------------

---------------
-- LIBRARIES --
---------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.SOCConstantsPackage.all;
use work.SimpleCounterPackage.all;

-----------------------
-- ENTITY DEFINITION --
-----------------------
 
entity SimpleCounter is
  generic (
    log_file:       string -- Debug file
    );
  port(
    clk             : in  std_logic;
    reset           : in  std_logic;
    p_TIC           : in  std_ulogic;
    p_Counter       : out std_logic_vector(c_NbBitsSimpleCounter-1 downto 0)
    );  
end SimpleCounter;
