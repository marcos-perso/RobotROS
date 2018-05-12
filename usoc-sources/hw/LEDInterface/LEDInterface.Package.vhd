-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- Package for block LEDInterface
--
-- NOTES:
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
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

----------------------------------
-- COMPONENT PACKAGE DEFINITION --
----------------------------------

package LEDInterfacePackage is

  -- BusToIO module
  constant C_LEDS             : integer := 16#0#;  -- DATA Register
  constant C_LED_SELECTINPUT  : integer := 16#1#;  -- DATA Register
  constant C_BYTE_SELECTION   : integer := 16#2#;  -- DATA Register

end LEDInterfacePackage;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------
   
