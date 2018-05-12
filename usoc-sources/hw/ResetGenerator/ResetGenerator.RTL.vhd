-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- It generates the reset function for
--      * Clocking system
--      * FPGA Logic
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
   
architecture RTL of ResetGenerator is

  -- SIGNAL DEFINITION --
  signal resetcounter    : unsigned(6 downto 0);
  signal resetcounterZPU : unsigned(6 downto 0);
  signal combined_reset : std_logic;

  -- OTHER --

  -- DEBUG
  file l_file : TEXT open write_mode is log_file;
  
begin

  process(clk, areset)
  begin
    if areset = '1' then
      resetcounter <= to_unsigned(0, 7);

    elsif (clk'event and clk = '1') then
      -- keep interrupt signal high for 64 cycles
      if (resetcounter < to_unsigned(64,7))
      then
        resetcounter <= resetcounter + 1;
      end if;
    end if;
  end process;

  process(clk, combined_reset)
  begin
    if combined_reset = '1' then

      resetcounterZPU <= to_unsigned(0, 7);

    elsif (clk'event and clk = '1') then
      -- keep interrupt signal high for 64 cycles
      if (resetcounterZPU < to_unsigned(64,7))
      then
        resetcounterZPU <= resetcounterZPU + 1;
      end if;
    end if;
  end process;

  -- Continuous assignments
  combined_reset <= areset or zreset;
  p_LogicReset    <= resetcounter(5);
  p_LogicResetZPU <= resetcounterZPU(5);
  
end RTL;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------
 
