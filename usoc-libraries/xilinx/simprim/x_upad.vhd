-- $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/vhdsclibs/data/simprims/simprim/VITAL/Attic/x_upad.vhd,v 1.6 2005/02/22 06:54:44 fphillip Exp $
-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  Unbonded Pad
-- /___/   /\     Filename : X_UPAD.vhd
-- \   \  /  \    Timestamp : Thu Apr  8 10:57:20 PDT 2004
--  \___\/\___\
--
-- Revision:
--    03/23/04 - Initial version.

----- CELL X_UPAD -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library IEEE;
use IEEE.Vital_Primitives.all;
use IEEE.Vital_Timing.all;

entity X_UPAD is
  generic(
    LOC : string  := "UNPLACED"
    );
  port(
    PAD : in std_ulogic
    );

  attribute VITAL_LEVEL0 of
    X_UPAD : entity is true;
end X_UPAD;

architecture X_UPAD_V of X_UPAD is
  attribute VITAL_LEVEL0 of
    X_UPAD_V : architecture is true;

begin
end X_UPAD_V;
