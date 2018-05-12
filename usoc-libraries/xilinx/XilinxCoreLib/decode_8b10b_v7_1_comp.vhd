---------------------------------------------------------------------------
-- $RCSfile: decode_8b10b_v7_1_comp.vhd,v $
---------------------------------------------------------------------------
-- 8b/10b Decoder - Behavioral Model Component Declaration
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
-- Filename:    decode_8b10b_v7_1_comp.vhd
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;


PACKAGE decode_8b10b_v7_1_comp IS

  COMPONENT decode_8b10b_v7_1
    GENERIC (
-------------------------------------------------------------------------
-- Generic Parameters
--  
--  c_decode_type      : Implementation: 0=Slice based, 1=BlockRam, 2=LutRam
--  c_enable_rlocs     : Enable Relative PLacement (T=1,F=0)
--  c_has_bports       : 1 indicates second decoder should be generated
--  c_has_ce           : 1 indicates ce port is present
--  c_has_ce_b         : 1 indicates ce_b port is present (if c_has_bports=1)
--  c_has_code_err     : 1 indicates code_err port is present
--  c_has_code_err_b   : 1 indicates code_err_b port is present (if c_has_bports=1)
--  c_has_disp_err     : 1 indicates disp_err port is present
--  c_has_disp_err_b   : 1 indicates disp_err_b port is present (if c_has_bports=1)
--  c_has_disp_in      : 1 indicates disp_in port is present
--  c_has_disp_in_b    : 1 indicates disp_in_b port is present (if c_has_bports=1)
--  c_has_nd           : 1 indicates nd port is present
--  c_has_nd_b         : 1 indicates nd_b port is present (if c_has_bports=1)
--  c_has_run_disp     : 1 indicates run_disp port is present
--  c_has_run_disp_b   : 1 indicates run_disp_b port is present (if c_has_bports=1)
--  c_has_sinit        : 1 indicates sinit port is present
--  c_has_sinit_b      : 1 indicates sinit_b port is present (if c_has_bports=1)
--  c_has_sym_disp     : 1 indicates sym_disp port is present
--  c_has_sym_disp_b   : 1 indicates sym_disp_b port is present (if c_has_bports=1)
--  c_sinit_dout       : 8-bit binary string, dout value when sinit is active
--  c_sinit_dout_b     : 8-bit binary string, dout_b value when sinit_b is active
--  c_sinit_kout       : controls kout output when sinit is active
--  c_sinit_kout_b     : controls kout_b output when sinit_b is active
--  c_sinit_run_disp   : Initializes run_disp value to positive(1) or negative(0)
--  c_sinit_run_disp_b : Initializes run_disp_b value to positive(1) or negative(0)
-------------------------------------------------------------------------
      c_decode_type      : integer := 1;
      c_enable_rlocs     : integer := 0;
      c_has_bports       : integer := 0;
      c_has_ce           : integer := 0;
      c_has_ce_b         : integer := 0;
      c_has_code_err     : integer := 1;
      c_has_code_err_b   : integer := 0;
      c_has_disp_err     : integer := 1;
      c_has_disp_err_b   : integer := 0;
      c_has_disp_in      : integer := 0;
      c_has_disp_in_b    : integer := 0;
      c_has_nd           : integer := 0;
      c_has_nd_b         : integer := 0;
      c_has_run_disp     : integer := 0;
      c_has_run_disp_b   : integer := 0;
      c_has_sinit        : integer := 0;
      c_has_sinit_b      : integer := 0;
      c_has_sym_disp     : integer := 0;
      c_has_sym_disp_b   : integer := 0;
      c_sinit_dout       : string  := "00000000";
      c_sinit_dout_b     : string  := "00000000";
      c_sinit_kout       : integer := 0;
      c_sinit_kout_b     : integer := 0;
      c_sinit_run_disp   : integer := 0;
      c_sinit_run_disp_b : integer := 0
      );

    PORT (
      -------------------------------------------------------------------------
      -- Mandatory Pins
      --  clk  : Clock Input
      --  din  : Encoded Symbol Input
      --  dout : Data Output, decoded data byte
      --  kout : Command Output
      -------------------------------------------------------------------------
      clk  : IN  std_logic;
      din  : IN  std_logic_vector(9 DOWNTO 0);
      dout : OUT std_logic_vector(7 DOWNTO 0);
      kout : OUT std_logic;

      -------------------------------------------------------------------------
      -- Optional Pins
      --  ce         : Clock Enable
      --  ce_b       : Clock Enable (B port)
      --  clk_b      : Clock Input (B port)
      --  din_b      : Encoded Symbol Input (B port)
      --  disp_in    : Disparity Input (running disparity in)
      --  disp_in_b  : Disparity Input (running disparity in) 
      --  sinit      : Synchronous Initialization. Resets core to known state.
      --  sinit_b    : Synchronous Initialization. Resets core to known state. (B port)
      --  code_err   : Code Error, indicates that input symbol did not correspond
      --                to a valid member of the code set.
      --  code_err_b : Code Error, indicates that input symbol did not correspond
      --                to a valid member of the code set. (B port)
      --  disp_err   : Disparity Error
      --  disp_err_b : Disparity Errort (B port)
      --  dout_b     : Data Output, decoded data byte (B port)
      --  kout_b     : Command Output (B port)
      --  nd         : New Data
      --  nd_b       : New Data (B port)
      --  run_disp   : Running Disparity
      --  run_disp_b : Running Disparity (B port)
      --  sym_disp   : Symbol Disparity
      --  sym_disp_b : Symbol Disparity (B port)
      -------------------------------------------------------------------------
      ce         : IN  std_logic                    := '0';
      ce_b       : IN  std_logic                    := '0';
      clk_b      : IN  std_logic                    := '0';
      din_b      : IN  std_logic_vector(9 DOWNTO 0) := "0000000000";
      disp_in    : IN  std_logic                    := '0';
      disp_in_b  : IN  std_logic                    := '0';
      sinit      : IN  std_logic                    := '0';
      sinit_b    : IN  std_logic                    := '0';
      code_err   : OUT std_logic;
      code_err_b : OUT std_logic;
      disp_err   : OUT std_logic;
      disp_err_b : OUT std_logic;
      dout_b     : OUT std_logic_vector(7 DOWNTO 0);
      kout_b     : OUT std_logic;
      nd         : OUT std_logic;
      nd_b       : OUT std_logic;
      run_disp   : OUT std_logic;
      run_disp_b : OUT std_logic;
      sym_disp   : OUT std_logic_vector(1 DOWNTO 0);
      sym_disp_b : OUT std_logic_vector(1 DOWNTO 0)
      );

  END COMPONENT;   
  
END decode_8b10b_v7_1_comp;
