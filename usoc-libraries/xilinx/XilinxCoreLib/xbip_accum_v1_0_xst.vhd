-- $Id: xbip_accum_v1_0_xst.vhd,v 1.1 2010-07-10 21:43:27 mmartinez Exp $
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
USE Xilinxcorelib.xbip_accum_v1_0_comp.ALL;

-- (A)synchronous multi-input gate
--
--core_if on entity xbip_accum_v1_0_xst
  entity xbip_accum_v1_0_xst is
    GENERIC (
      C_XDEVICEFAMILY       : STRING  := "no_family";
      C_IMPLEMENTATION      : INTEGER := 0;
      C_VERBOSITY           : integer := 0;
      C_LATENCY             : integer := 0;
      C_BYPASS_LOW          : integer := 0;
      C_B_WIDTH             : INTEGER := 16;
      C_OUT_WIDTH           : INTEGER := 16;
      C_CE_OVERRIDES_SCLR   : INTEGER := 0; --0=SYNC over CE, 1 = CE over SYNC
      C_DATA_TYPE           : INTEGER := 1 --0=signed, 1=unsigned;
      );
    PORT (
      B        : in  std_logic_vector(C_B_WIDTH-1 downto 0) := (others => '0');  -- input value
      CLK      : in  std_logic                              := '0';  -- clock
      ADDF     : in  std_logic                              := '1';
      C_IN     : in  std_logic                              := '0';  -- carry in
      CE       : in  std_logic                              := '1';  -- clock enable
      BYPASS   : in  std_logic                              := '0';  -- sync load of b into reg
      SCLR     : in  std_logic                              := '0';  -- synch init.
      Q        : out std_logic_vector(C_OUT_WIDTH-1 downto 0) := (others => '0')  -- synch output value
      );
--core_if off
END xbip_accum_v1_0_xst;


ARCHITECTURE behavioral OF xbip_accum_v1_0_xst IS

BEGIN
  --core_if on instance i_behv xbip_accum_v1_0
  i_behv : xbip_accum_v1_0
    GENERIC MAP (
      C_XDEVICEFAMILY     => C_XDEVICEFAMILY,
      C_IMPLEMENTATION    => C_IMPLEMENTATION,
      C_VERBOSITY         => C_VERBOSITY,
      C_LATENCY           => C_LATENCY,
      C_BYPASS_LOW        => C_BYPASS_LOW,
      C_B_WIDTH           => C_B_WIDTH,
      C_OUT_WIDTH         => C_OUT_WIDTH,
      C_CE_OVERRIDES_SCLR => C_CE_OVERRIDES_SCLR,
      C_DATA_TYPE         => C_DATA_TYPE
      )
    PORT MAP (
      B      => B,
      CLK    => CLK,
      ADDF   => ADDF,
      C_IN   => C_IN,
      CE     => CE,
      BYPASS => BYPASS,
      SCLR   => SCLR,
      Q      => Q
      );

  --core_if off
  
END behavioral;

