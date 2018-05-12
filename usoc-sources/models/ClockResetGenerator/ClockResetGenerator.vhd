-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- Clock and reset generator
--
-- NOTES:
--
-- $Author: mmartinez $
-- $Date: 2010-07-11 17:59:46 $
-- $Name:  $
-- $Revision: 1.3 $
--
-------------------------------------------------------------------------------

---------------
-- LIBRARIES --
---------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.SOCConstantsPackage.all;

-----------------------
-- ENTITY DEFINITION --
-----------------------
 
-----------------------------
-- ARCHITECTURE DEFINITION --
-----------------------------
   
architecture BEHAV of ClockResetGenerator is


  -- SIGNAL DEFINITION --

begin
    

  -- PROCESS DEFINITION --

  clock : PROCESS
  begin
    clk <= '0';
    wait for clock_half_period; 
    clk <= '1';
    wait for clock_half_period; 
  end PROCESS clock;

      areset <= '1' after 0 ns,
                '0' after 300 ns;

end BEHAV;

-------------------------------------------------------------------------------
-- $Log: ClockResetGenerator.vhd,v $
-- Revision 1.3  2010-07-11 17:59:46  mmartinez
-- Include generics for the half period
--
-- Revision 1.2  2010-07-11 17:56:59  mmartinez
-- Include generic for the period
--
-------------------------------------------------------------------------------
 
