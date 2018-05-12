-- $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/vhdsclibs/data/simprims/simprim/VITAL/Attic/x_opad.vhd,v 1.7 2005/02/22 06:54:43 fphillip Exp $
-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  Output Pad
-- /___/   /\     Filename : X_OPAD.vhd
-- \   \  /  \    Timestamp : Thu Apr  8 10:57:11 PDT 2004
--  \___\/\___\
--
-- Revision:
--    03/23/04 - Initial version.

----- CELL X_OPAD -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library IEEE;
use IEEE.Vital_Primitives.all;
use IEEE.Vital_Timing.all;

entity X_OPAD is
  generic(
    LOC : string  := "UNPLACED"
    );
  port(
    PAD : out std_ulogic
    );

  attribute VITAL_LEVEL0 of
    X_OPAD : entity is true;
end X_OPAD;

architecture X_OPAD_V of X_OPAD is
  attribute VITAL_LEVEL0 of
    X_OPAD_V : architecture is true;

begin
  PAD <= 'Z';
end X_OPAD_V;
