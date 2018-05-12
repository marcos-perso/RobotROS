---------------------------------------------------------------------------
-- $RCSfile: encode_8b10b_v5_0_comp.vhd,v $ $Revision: 1.1 $ $Date: 2010-07-10 21:43:07 $
---------------------------------------------------------------------------
-- 8b/10b Encoder - Behavioral Model Component Declaration
---------------------------------------------------------------------------
--                                                                       

--  Copyright(C) 2004 by Xilinx, Inc. All rights reserved.
--  This text/file contains proprietary, confidential
--  information of Xilinx, Inc., is distributed under license
--  from Xilinx, Inc., and may be used, copied and/or
--  disclosed only pursuant to the terms of a valid license
--  agreement with Xilinx, Inc.  Xilinx hereby grants you
--  a license to use this text/file solely for design, simulation,
--  implementation and creation of design files limited
--  to Xilinx devices or technologies. Use with non-Xilinx
--  devices or technologies is expressly prohibited and
--  immediately terminates your license unless covered by
--  a separate agreement.
--
--  Xilinx is providing this design, code, or information
--  "as is" solely for use in developing programs and
--  solutions for Xilinx devices.  By providing this design,
--  code, or information as one possible implementation of
--  this feature, application or standard, Xilinx is making no
--  representation that this implementation is free from any
--  claims of infringement.  You are responsible for
--  obtaining any rights you may require for your implementation.
--  Xilinx expressly disclaims any warranty whatsoever with
--  respect to the adequacy of the implementation, including
--  but not limited to any warranties or representations that this
--  implementation is free from claims of infringement, implied
--  warranties of merchantability or fitness for a particular
--  purpose.
--
--  Xilinx products are not intended for use in life support
--  appliances, devices, or systems. Use in such applications are
--  expressly prohibited.
--
--  This copyright and support notice must be retained as part
--  of this text at all times. (c) Copyright 1995-2004 Xilinx, Inc.
--  All rights reserved.

--NOTICE:
-- This byte oriented DC balanced 8b/10b partitioned block
-- transmission code may contain material covered by patents
-- owned by other third parties including International Business
-- Machines Corporation.  By providing this core as one possible
-- implementation of this standard, Xilinx is making no representation
-- that the provided implementation of this standard is free
-- from any claims of infringement by any third party.  Xilinx 
-- expressly disclaims any warranty with respect to the adequacy 
-- of the implementation, including, but not limited to any warranty 
-- or representation that the implementation is free from claims of
-- any third party.  Furthermore, Xilinx is providing this core as
-- a courtesy to you and suggests that you contact all third parties
-- including IBM to obtain the necessary rights to use this implementation.
---------------------------------------------------------------------------
-- Filename:    encode_8b10b_v5_0_comp.vhd
---------------------------------------------------------------------------


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

PACKAGE encode_8b10b_v5_0_comp IS

-------------------------------------------------------------------------------
-- Definition of Generics
-------------------------------------------------------------------------------
-- c_enable_rlocs                       -- Enable relative placement
--    c_encode_type                     -- 0 slice, 1 blockRAM, 2 LUTRAM
--    c_has_ce                          -- 1 if CE port present
--    c_has_ce_b                        -- 1 if CE_B port present
--    c_has_bports                      -- 1 if second encoder
--    c_has_disp_in                     -- 1 if FORCE_DISP port present
--    c_has_disp_in_b                   -- 1 if FORCE_DISP_B port present
--    c_has_force_code                  -- 1 if FORCE_CODE port present
--    c_has_force_code_b                -- 1 if FORCE_CODE_B port present
--    c_force_code_val                  -- Force code value (10 bits)
--    c_force_code_val_b                -- Force code Value B (10 bits)
--    c_force_code_disp                 -- force code disparity
--    c_force_code_disp_b               -- Force code disparity B
--    c_has_nd                          -- 1 if ND port present
--    c_has_nd_b                        -- 1 if nd_b port present
--    c_has_kerr                        -- 1 if KERR port present
--    c_has_kerr_b                      -- 1 if KERR_B port present
--    c_has_disp_out                    -- 1 if DISPOUT port present
--    c_has_disp_out_b                  -- 1 if DISPOUT_B port present
-------------------------------------------------------------------------------

  COMPONENT encode_8b10b_v5_0
    GENERIC (
      c_enable_rlocs      : integer := 1;
      c_encode_type       : integer := 0;
      c_has_ce            : integer := 1;
      c_has_ce_b          : integer := 0;
      c_has_bports        : integer := 0;
      c_has_disp_in       : integer := 1;
      c_has_disp_in_b     : integer := 0;
      c_has_force_code    : integer := 1;
      c_has_force_code_b  : integer := 0;
      c_force_code_val    : string  := "0101010101";
      c_force_code_val_b  : string  := "0101010101";
      c_force_code_disp   : integer := 0;
      c_force_code_disp_b : integer := 0;
      c_has_nd            : integer := 1;
      c_has_nd_b          : integer := 0;
      c_has_kerr          : integer := 1;
      c_has_kerr_b        : integer := 0;
      c_has_disp_out      : integer := 1;
      c_has_disp_out_b    : integer := 0
      );
    PORT (
      din        : IN  std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
      kin        : IN  std_logic                    := '0';
      clk        : IN  std_logic                    := '0';
      ce         : IN  std_logic                    := '0';
      force_code : IN  std_logic                    := '0';
      force_disp : IN  std_logic                    := '0';
      disp_in    : IN  std_logic                    := '0';
      dout       : OUT std_logic_vector(9 DOWNTO 0);
      disp_out   : OUT std_logic;
      kerr       : OUT std_logic;
      nd         : OUT std_logic;

      din_b        : IN  std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
      kin_b        : IN  std_logic                    := '0';
      clk_b        : IN  std_logic                    := '0';
      ce_b         : IN  std_logic                    := '0';
      force_code_b : IN  std_logic                    := '0';
      force_disp_b : IN  std_logic                    := '0';
      disp_in_b    : IN  std_logic                    := '0';
      dout_b       : OUT std_logic_vector(9 DOWNTO 0);
      disp_out_b   : OUT std_logic;
      kerr_b       : OUT std_logic;
      nd_b         : OUT std_logic
      );
  END COMPONENT;


END encode_8b10b_v5_0_comp;
