-------------------------------------------------------------------------------
-- DESCRIPTION: 
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

package SimpleCounterPackage is

-- counter
  constant c_NbBitsSimpleCounter : integer := 3;    -- #bits in Simple counter
  constant c_MaxSimpleCounter    : integer := 8;  -- Maximum value for the TIC

end SimpleCounterPackage;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------
   
