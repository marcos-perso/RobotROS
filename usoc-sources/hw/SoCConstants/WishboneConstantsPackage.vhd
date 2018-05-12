-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- Wishbone constants
--
-- NOTES:
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
use work.SoCConstantsPackage.all;

----------------------------------
-- COMPONENT PACKAGE DEFINITION --
----------------------------------

package WishboneConstantsPackage is

  -- CONSTANTS
  constant c_WishboneDataWidth      : integer := 32; -- Number of data lines
  constant c_WishboneAddrWidth      : integer := 28; -- Number of address lines
  constant c_WishboneSelWidth       : integer := 1;  -- Number of selection lines
  constant c_WishboneTagDataWidth   : integer := 32; -- Number of Tag data lines
  constant c_WishboneTagAddrWidth   : integer := 32; -- Number of Tag Address lines
  constant c_WishboneTagCycleWidth  : integer := 32; -- Number of Tag cycle lines

  -- TYPES
  type t_FSM_WB  is (e_Idle, e_READ, e_WRITE);


end WishboneConstantsPackage;

-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
   
