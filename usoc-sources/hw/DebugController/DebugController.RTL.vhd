-------------------------------------------------------------------------------
-- DESCRIPTION: 
--  Debug controller. It generate sthe debug signals for all the blocks
-- TBD: The Debug controller should be controlled by the CPU
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
use work.DebugControllerPackage.all;

-----------------------------
-- ARCHITECTURE DEFINITION --
-----------------------------
   
architecture RTL of DebugController is


  -- REGISTERS
  signal r_DebugOversampling : std_logic;

  -- FSM

  -- OTHER

  -- DEBUG
  file l_file : TEXT open write_mode is log_file;
  
begin

  process(clk, reset)

  begin

    if reset = '1' then                 -- if#1

      r_DebugOversampling  <= '0';

    elsif (clk'event and clk = '1') then -- if#1


      -- Default values
      r_DebugOversampling  <= '0';

    end if;

  end process;

  -- ==============================
  -- === CONTINUOUS ASSIGNMENTS ===
  -- ==============================

  -- Interface with Video RAM
  p_DebugOversampling <= r_DebugOversampling;

end RTL;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------
 
