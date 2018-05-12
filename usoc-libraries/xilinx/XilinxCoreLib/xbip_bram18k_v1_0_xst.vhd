-- $Id: xbip_bram18k_v1_0_xst.vhd,v 1.1 2010-07-10 21:43:27 mmartinez Exp $
--
--  Copyright(C) 2008 by Xilinx, Inc. All rights reserved.
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
--  of this text at all times. (c) Copyright 1995-2008 Xilinx, Inc.
--  All rights reserved.

-------------------------------------------------------------------------------
-- Wrapper for behavioral model
-------------------------------------------------------------------------------
  
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
--USE XilinxCoreLib.prims_constants_v9_1.ALL;
USE Xilinxcorelib.bip_bram18k_v1_0_pkg.ALL;
USE Xilinxcorelib.xbip_bram18k_v1_0_comp.ALL;

-- (A)synchronous multi-input gate
--
--core_if on entity xbip_bram18k_v1_0_xst
  entity xbip_bram18k_v1_0_xst is
    GENERIC (
      C_XDEVICEFAMILY : string             := "virtex4";
      C_VERBOSITY     : integer            := 0;          -- 0 = Errors 1 = +Warnings, 2 = +Notes and tips
      C_OPTIMIZE_GOAL : integer            := 0;          -- 0 = area,  1 = speed.
      C_MODEL_TYPE    : integer            := 0;          -- 0 = synth, 1 = RTL
      C_LATENCY       : integer            := 1;
      C_ADDR_WIDTH    : integer            := 10;
      C_DATA_WIDTH    : integer            := 18;
      C_INIT_VAL      : t_BRAM18k_init_val := (others => (others => '0'))
      );
    PORT (
      CLK      : in  std_logic                                 := '1';
      CE       : in  std_logic                                 := '1';
      SCLR     : in  std_logic                                 := '0';
      WE1      : in  std_logic                                 := '0';
      WE2      : in  std_logic                                 := '0';
      ADDR1    : in  std_logic_vector(C_ADDR_WIDTH-1 downto 0) := (others => '0');
      ADDR2    : in  std_logic_vector(C_ADDR_WIDTH-1 downto 0) := (others => '0');
      DATAIN1  : in  std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
      DATAIN2  : in  std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
      DATAOUT1 : out std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
      DATAOUT2 : out std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0')
      );
--core_if off
END xbip_bram18k_v1_0_xst;


ARCHITECTURE behavioral OF xbip_bram18k_v1_0_xst IS

BEGIN
  --core_if on instance i_behv xbip_bram18k_v1_0
  i_behv : xbip_bram18k_v1_0
    GENERIC MAP (
      C_XDEVICEFAMILY => C_XDEVICEFAMILY,
      C_VERBOSITY     => C_VERBOSITY,
      C_OPTIMIZE_GOAL => C_OPTIMIZE_GOAL,
      C_MODEL_TYPE    => C_MODEL_TYPE,
      C_LATENCY       => C_LATENCY,
      C_ADDR_WIDTH    => C_ADDR_WIDTH,
      C_DATA_WIDTH    => C_DATA_WIDTH,
      C_INIT_VAL      => C_INIT_VAL
      )
    PORT MAP (
      CLK      => CLK,
      CE       => CE,
      SCLR     => SCLR,
      WE1      => WE1,
      WE2      => WE2,
      ADDR1    => ADDR1,
      ADDR2    => ADDR2,
      DATAIN1  => DATAIN1,
      DATAIN2  => DATAIN2,
      DATAOUT1 => DATAOUT1,
      DATAOUT2 => DATAOUT2
      );

  --core_if off
  
END behavioral;

