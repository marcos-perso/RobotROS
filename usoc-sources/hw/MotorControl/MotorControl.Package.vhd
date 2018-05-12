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

package MotorControlPackage is

  -- CONSTANTS

  constant C_MOTOR_SPEEDCOUNTER_MAX : integer := 64000;  -- 2 ms steps
  constant C_NBBITS_SPEEDCOUNTER : integer := 16;  -- # BIts in Motor 0 counter
  constant C_PHASECOUNTERMAX_INIT : integer := 4;
  constant C_NBBITS_MOTORCOUNTER : integer := 16;  -- # BIts in Motor 0 counter
  constant C_NBBITS_PHASECOUNTER  : integer := 2;  -- # BIts in Phase counter

  -- TYPES

end MotorControlPackage;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------
   
