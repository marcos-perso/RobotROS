-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- Utility functions
--
-- NOTES:
--
-- $Author: mmartinez $
-- $Date: 2010-07-10 21:46:21 $
-- $Name:  $
-- $Revision: 1.1 $
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

package FileIOUtilsPackage is

  -- synopsys translate off

  type t_CommandEmulator is (e_NOP,           -- No operation
                             e_READ,          -- Read internal register
                             e_WRITE,         -- Write internal register
                             e_BUTTON,        -- Press a button
                             e_READ_ADDRESS,  -- Read from Address
                             e_WRITE_ADDRESS, -- Write to Address
                             e_PROGRAM_FLASH, -- Program FLASH
                             e_CHECK,         -- Check FLASH
                             e_WAIT          -- Wait X cycles
                             );

  type t_ADC is (e_NOP,          -- No operation
                 e_SIGNAL,       -- Read signal value
                 e_WAIT          -- Wait X cycles
                 );

  -- Read a command from an input line
  procedure ReadString(in_line: inout line; 
                       res_string: out string);
  -- Read a space character
  procedure ReadSpace(in_line: inout line);
  -- Read an Integer (hex from an input line
  procedure ReadHex1(in_line: inout line; 
                     value: out integer);
  procedure ReadHex2(in_line: inout line; 
                     value: out integer);
  procedure ReadHex4(in_line: inout line; 
                     value: out integer);
  procedure ReadHex7(in_line: inout line; 
                     value: out integer);
  procedure ReadHex8(in_line: inout line; 
                     value: out integer);
  procedure ReadHex8AsString(in_line: inout line; 
                     value: out string(1 to 8));
  procedure ReadHex10(in_line: inout line; 
                      value: out integer);

  -- synopsys translate on

end FileIOUtilsPackage;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------
   
