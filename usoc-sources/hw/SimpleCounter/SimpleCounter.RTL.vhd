-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- Simple counter. Counts the number of tics received
-- NOTE TBD: Number of biits in the counter should be generic
--
-- NOTES:
--
--
-- $Author$
-- $Date$
-- $Name$
-- $Revision$
--
-------------------------------------------------------------------------------

---------------
-- LIBRARIES --
---------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use std.textio.all;

library work;
use work.SoCConstantsPackage.all;
use work.SimpleCounterPackage.all;

-----------------------------
-- ARCHITECTURE DEFINITION --
-----------------------------
   
architecture RTL of SimpleCounter is

  -- SIGNAL DEFINITION --

  signal r_SimpleCounter : unsigned(c_NbBitsSimpleCounter-1 downto 0);

  -- OTHER --

  -- DEBUG
  file l_file : TEXT open write_mode is log_file;
  
begin

  process(clk, reset)
  begin
    if reset = '1' then

      r_SimpleCounter  <= to_unsigned(0, c_NbBitsSimpleCounter);

    elsif (clk'event and clk = '1') then

      if (p_TIC = '1') then
        
        if (r_SimpleCounter < to_unsigned(c_MaxSimpleCounter-1,c_NbBitsSimpleCounter))
        then
          r_SimpleCounter <= r_SimpleCounter + 1;
        else
          r_SimpleCounter <= to_unsigned(0,c_NbBitsSimpleCounter);
        end if;

      end if;

    end if;
  end process;

  -- Continuous assignements
  p_Counter <= std_logic_vector(r_SimpleCounter);
  
end RTL;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------
 
