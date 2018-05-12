-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- It generates an interrupt each second
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

-----------------------------
-- ARCHITECTURE DEFINITION --
-----------------------------
   
architecture RTL of TICTimer is

  -- SIGNAL DEFINITION --
  signal interruptcounter : unsigned(63 downto 0);  -- This is absolutelly not
-- optimal!

  -- OTHER --
  signal reg_TIC : std_logic;

  -- DEBUG
  file l_file : TEXT open write_mode is log_file;
  
begin

  process(clk, reset)
  begin
    if reset = '1' then
      interruptcounter <= to_unsigned(0, 64);
      reg_TIC <= '0'; 

    elsif (clk'event and clk = '1') then
      -- keep interrupt signal high for 16 cycles
      if (interruptcounter < to_unsigned(c_16MHzTICSIn1s,64))
      then
        interruptcounter <= interruptcounter + 1;
      else
        interruptcounter <= to_unsigned(0,64);
      end if;
      if (interruptcounter = to_unsigned(c_16MHzTICSIn1s,64)) then
        -- synopsys translate off
        report "TIC!!" severity note;
        -- synopsys translate on
        reg_TIC <= not reg_TIC;   -- Interruption asserted (MMV)
      end if;
    end if;
  end process;

  -- Continuous assignments
  p_TICTimer <= reg_TIC;
  
end RTL;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------
 
