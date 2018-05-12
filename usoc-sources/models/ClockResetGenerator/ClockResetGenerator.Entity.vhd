-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- Clock and reset generator
--
-- NOTES:
--
-- $Author: mmartinez $
-- $Date: 2010-07-11 17:59:46 $
-- $Name:  $
-- $Revision: 1.1 $
--
-------------------------------------------------------------------------------

---------------
-- LIBRARIES --
---------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SOCConstantsPackage.all;

-----------------------
-- ENTITY DEFINITION --
-----------------------
 
entity ClockResetGenerator is
  generic (
    clock_half_period: time
    );
  port(
       clk    : out std_logic;
       areset : out std_logic := '1'
       );
end ClockResetGenerator;

-------------------------------------------------------------------------------
-- $Log: ClockResetGenerator.Entity.vhd,v $
-- Revision 1.1  2010-07-11 17:59:46  mmartinez
-- Include generics for the half period
--
-------------------------------------------------------------------------------
   
