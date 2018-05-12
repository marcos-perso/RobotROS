-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- Clock and reset generator
--
-- NOTES:
--
-- $Author: mmartinez $
-- $Date: 2010-07-11 17:59:46 $
-- $Name:  $
-- $Revision: 1.2 $
--
-------------------------------------------------------------------------------

---------------
-- LIBRARIES --
---------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

----------------------------------
-- COMPONENT PACKAGE DEFINITION --
----------------------------------

package ClockResetGeneratorComponentPackage is

--------------------------
-- COMPONENT DEFINITION --
--------------------------
 
  component ClockResetGenerator is
    generic (
      clock_half_period: time
      );
    port(
      clk    : out std_logic;
      areset : out std_logic := '1'
      );
  end component;
   
end ClockResetGeneratorComponentPackage;

-------------------------------------------------------------------------------
-- $Log: ClockResetGeneratorComponentPackage.vhd,v $
-- Revision 1.2  2010-07-11 17:59:46  mmartinez
-- Include generics for the half period
--
-------------------------------------------------------------------------------
 
