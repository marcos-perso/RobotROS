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

package SoCConstantsPackage is

  -- CONSTANTS
  constant c_ClockHalfPeriod  : time    := 31.25 ns;     -- 50 MHz
  constant c_16MHzTICSIn1s    : integer := 16129032;  -- Number of 16MHz TICS in 1 s
  constant c_PixelWidth       : integer := 640;  -- Width of the screen
  constant c_PixelHeigth      : integer := 480;  -- Heighth of the screen
  constant c_PixelXMax        : integer := 320;  -- Portion of the screen we show
  constant c_PixelYMax        : integer := 240;  -- Portion of the screen we show

 -- Memory system
  constant c_NbAddrBitsDRAM     : integer := 10;  -- Number of address bit son internal DRAM

  -- ENUMERATED
  type t_DRAWING_COMMANDS is (e_POINT, e_LINE);  -- Drawing commands
  type t_Command is (e_NOP, e_READ, e_WRITE, e_PROGRAM_FLASH, e_WAIT, e_CHECK);

end SoCConstantsPackage;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------
   
