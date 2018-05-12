-- $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/vhdsclibs/data/simprims/simprim/VITAL/Attic/x_bpad.vhd,v 1.7 2005/02/22 06:54:42 fphillip Exp $
-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  Bi-Directional Pad
-- /___/   /\     Filename : X_BPAD.vhd
-- \   \  /  \    Timestamp : Thu Apr  8 10:57:07 PDT 2004
--  \___\/\___\
--
-- Revision:
--    03/23/04 - Initial version.

----- CELL X_BPAD -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library IEEE;
use IEEE.Vital_Primitives.all;
use IEEE.Vital_Timing.all;

entity X_BPAD is
  generic(
    LOC : string  := "UNPLACED"
    );
  port(
    PAD : inout std_ulogic
    );

  attribute VITAL_LEVEL0 of
    X_BPAD : entity is true;

end X_BPAD;

architecture X_BPAD_V of X_BPAD is
  attribute VITAL_LEVEL0 of
    X_BPAD_V : architecture is true;
begin
  PAD <= 'Z';
end X_BPAD_V;
-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Functional Simulation Library Component
--  /   /                  Boundary Scan Logic Control Circuit for FPGACORE
-- /___/   /\     Filename : X_BSCAN_FPGACORE.vhd
-- \   \  /  \    Timestamp : Sat Mar 26 16:03:05 PST 2005
--  \___\/\___\
--
-- Revision:
--    03/26/05 - Initial version.

----- CELL X_BSCAN_FPGACORE -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity X_BSCAN_FPGACORE is
  port(
    CAPTURE : out std_ulogic := 'H';
    DRCK1   : out std_ulogic := 'H';
    DRCK2   : out std_ulogic := 'H';
    RESET   : out std_ulogic := 'H';
    SEL1    : out std_ulogic := 'L';
    SEL2    : out std_ulogic := 'L';
    SHIFT   : out std_ulogic := 'L';
    TDI     : out std_ulogic := 'L';
    UPDATE  : out std_ulogic := 'L';

    TDO1 : in std_ulogic := 'X';
    TDO2 : in std_ulogic := 'X'
    );
end X_BSCAN_FPGACORE;

architecture X_BSCAN_FPGACORE_V of X_BSCAN_FPGACORE is
begin
  CAPTURE <= 'H';
  RESET   <= 'H';
  UPDATE  <= 'L';
  SHIFT   <= 'L';
  DRCK1   <= 'H';
  DRCK2   <= 'H';
  SEL1    <= 'L';
  SEL2    <= 'L';
  TDI     <= 'L';
end X_BSCAN_FPGACORE_V;
-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Functional Simulation Library Component
--  /   /                  Boundary Scan Logic Control Circuit for SPARTAN2
-- /___/   /\     Filename : X_BSCAN_SPARTAN2.vhd
-- \   \  /  \    Timestamp : Sat Mar 26 16:03:05 PST 2005
--  \___\/\___\
--
-- Revision:
--    03/26/05 - Initial version.

----- CELL X_BSCAN_SPARTAN2 -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity X_BSCAN_SPARTAN2 is
  port(
    DRCK1  : out std_ulogic := 'H';
    DRCK2  : out std_ulogic := 'H';
    RESET  : out std_ulogic := 'H';
    SEL1   : out std_ulogic := 'L';
    SEL2   : out std_ulogic := 'L';
    SHIFT  : out std_ulogic := 'L';
    TDI    : out std_ulogic := 'L';
    UPDATE : out std_ulogic := 'L';

    TDO1 : in std_ulogic := 'X';
    TDO2 : in std_ulogic := 'X'
    );
end X_BSCAN_SPARTAN2;

architecture X_BSCAN_SPARTAN2_V of X_BSCAN_SPARTAN2 is
begin
  RESET  <= 'H';
  UPDATE <= 'L';
  SHIFT  <= 'L';
  DRCK1  <= 'H';
  DRCK2  <= 'H';
  SEL1   <= 'L';
  SEL2   <= 'L';
  TDI    <= 'L';
end X_BSCAN_SPARTAN2_V;


-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Functional Simulation Library Component
--  /   /                  Boundary Scan Logic Control Circuit for SPARTAN3
-- /___/   /\     Filename : X_BSCAN_SPARTAN3.vhd
-- \   \  /  \    Timestamp : Sat Mar 26 16:03:05 PST 2005
--  \___\/\___\
--
-- Revision:
--    03/26/05 - Initial version.

----- CELL X_BSCAN_SPARTAN3 -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity X_BSCAN_SPARTAN3 is
  port(
    CAPTURE : out std_ulogic := 'H';
    DRCK1   : out std_ulogic := 'L';
    DRCK2   : out std_ulogic := 'L';
    RESET   : out std_ulogic := 'L';
    SEL1    : out std_ulogic := 'L';
    SEL2    : out std_ulogic := 'L';
    SHIFT   : out std_ulogic := 'L';
    TDI     : out std_ulogic := 'L';
    UPDATE  : out std_ulogic := 'L';

    TDO1 : in std_ulogic := 'X';
    TDO2 : in std_ulogic := 'X'
    );
end X_BSCAN_SPARTAN3;

architecture X_BSCAN_SPARTAN3_V of X_BSCAN_SPARTAN3 is
begin
  CAPTURE <= 'H';
  RESET   <= 'L';
  UPDATE  <= 'L';
  SHIFT   <= 'L';
  DRCK1   <= 'L';
  DRCK2   <= 'L';
  SEL1    <= 'L';
  SEL2    <= 'L';
  TDI     <= 'L';
end X_BSCAN_SPARTAN3_V;


-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Functional Simulation Library Component
--  /   /                  Boundary Scan Logic Control Circuit for VIRTEX2
-- /___/   /\     Filename : X_BSCAN_VIRTEX2.vhd
-- \   \  /  \    Timestamp : Sat Mar 26 16:03:05 PST 2005
--  \___\/\___\
--
-- Revision:
--    03/26/05 - Initial version.

----- CELL X_BSCAN_VIRTEX2 -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity X_BSCAN_VIRTEX2 is
  port(
    CAPTURE : out std_ulogic := 'H';
    DRCK1   : out std_ulogic := 'H';
    DRCK2   : out std_ulogic := 'H';
    RESET   : out std_ulogic := 'H';
    SEL1    : out std_ulogic := 'L';
    SEL2    : out std_ulogic := 'L';
    SHIFT   : out std_ulogic := 'L';
    TDI     : out std_ulogic := 'L';
    UPDATE  : out std_ulogic := 'L';

    TDO1 : in std_ulogic := 'X';
    TDO2 : in std_ulogic := 'X'
    );
end X_BSCAN_VIRTEX2;

architecture X_BSCAN_VIRTEX2_V of X_BSCAN_VIRTEX2 is
begin
  CAPTURE <= 'H';
  RESET   <= 'H';
  UPDATE  <= 'L';
  SHIFT   <= 'L';
  DRCK1   <= 'H';
  DRCK2   <= 'H';
  SEL1    <= 'L';
  SEL2    <= 'L';
  TDI     <= 'L';
end X_BSCAN_VIRTEX2_V;


-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Functional Simulation Library Component
--  /   /                  Boundary Scan Logic Control Circuit for VIRTEX
-- /___/   /\     Filename : X_BSCAN_VIRTEX.vhd
-- \   \  /  \    Timestamp : Sat Mar 26 16:03:05 PST 2005
--  \___\/\___\
--
-- Revision:
--    03/26/05 - Initial version.

----- CELL X_BSCAN_VIRTEX -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity X_BSCAN_VIRTEX is
  port(
    DRCK1  : out std_ulogic := 'H';
    DRCK2  : out std_ulogic := 'H';
    RESET  : out std_ulogic := 'H';
    SEL1   : out std_ulogic := 'L';
    SEL2   : out std_ulogic := 'L';
    SHIFT  : out std_ulogic := 'L';
    TDI    : out std_ulogic := 'L';
    UPDATE : out std_ulogic := 'L';

    TDO1 : in std_ulogic := 'X';
    TDO2 : in std_ulogic := 'X'
    );
end X_BSCAN_VIRTEX;

architecture X_BSCAN_VIRTEX_V of X_BSCAN_VIRTEX is
begin
  RESET  <= 'H';
  UPDATE <= 'L';
  SHIFT  <= 'L';
  DRCK1  <= 'H';
  DRCK2  <= 'H';
  SEL1   <= 'L';
  SEL2   <= 'L';
  TDI    <= 'L';
end X_BSCAN_VIRTEX_V;


