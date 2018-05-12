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
use work.SOCConstantsPackage.all;
use work.SimpleCounterPackage.all;

----------------------------------
-- COMPONENT PACKAGE DEFINITION --
----------------------------------

package SimpleCounterComponentPackage is

--------------------------
-- COMPONENT DEFINITION --
--------------------------
 
  component SimpleCounter is
    generic (
      log_file:       string
      );
    port(
      clk             : in  std_logic;
      reset           : in  std_logic;
      p_TIC           : in  std_ulogic;
      p_Counter       : out std_logic_vector(c_NbBitsSimpleCounter-1 downto 0)
      );
  end component;

end SimpleCounterComponentPackage;
