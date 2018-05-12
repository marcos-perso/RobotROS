-- $Id: xbip_multadd_v1_0_xst.vhd,v 1.1 2010-07-10 21:43:29 mmartinez Exp $
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
--  of this text at all times. (c) Copyright 2008 Xilinx, Inc.
--  All rights reserved.

-------------------------------------------------------------------------------
-- Wrapper for behavioral model
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

library XilinxCoreLib;
use xilinxcorelib.bip_utils_pkg_v1_0.all;
use xilinxcorelib.bip_usecase_utils_pkg_v1_0.all;
use Xilinxcorelib.xbip_multadd_v1_0_comp.all;

--core_if on entity xbip_multadd_v1_0_xst
  entity xbip_multadd_v1_0_xst is
  generic (
    C_VERBOSITY         : integer := 0;
    C_XDEVICEFAMILY     : string  := "NO_FAMILY";
    C_A_WIDTH           : integer := 16;
    C_B_WIDTH           : integer := 16;
    C_C_WIDTH           : integer := 32;
    C_DATA_TYPE         : integer := 0;
    C_CE_OVERRIDES_SCLR : integer := 0;
    C_AB_LATENCY        : integer := -1;
    C_C_LATENCY         : integer := -1;
    C_OUT_HIGH          : integer := 32;
    C_OUT_LOW           : integer := 0;
    C_USE_PCIN          : integer := 0
    );
  port (
    CLK      : in  std_logic                                     := '0';
    CE       : in  std_logic                                     := '0';
    SCLR     : in  std_logic                                     := '0';
    A        : in  std_logic_vector(C_A_WIDTH-1 downto 0)        := (others => '0');
    B        : in  std_logic_vector(C_B_WIDTH-1 downto 0)        := (others => '0');
    C        : in  std_logic_vector(C_C_WIDTH-1 downto 0)        := (others => '0');
    PCIN     : in  std_logic_vector(ci_dsp48_c_width-1 downto 0) := (others => '0');
    SUBTRACT : in  std_logic                                     := '0';
    P        : out std_logic_vector(C_OUT_HIGH downto C_OUT_LOW) := (others => '0');
    PCOUT    : out  std_logic_vector(ci_dsp48_c_width-1 downto 0) := (others => '0')
    );
--core_if off
end xbip_multadd_v1_0_xst;


architecture behavioral of xbip_multadd_v1_0_xst is

begin
  --core_if on instance i_behv xbip_multadd_v1_0
  i_behv : xbip_multadd_v1_0
    GENERIC MAP (
      C_VERBOSITY         => C_VERBOSITY,
      C_XDEVICEFAMILY     => C_XDEVICEFAMILY,
      C_A_WIDTH           => C_A_WIDTH,
      C_B_WIDTH           => C_B_WIDTH,
      C_C_WIDTH           => C_C_WIDTH,
      C_DATA_TYPE         => C_DATA_TYPE,
      C_CE_OVERRIDES_SCLR => C_CE_OVERRIDES_SCLR,
      C_AB_LATENCY        => C_AB_LATENCY,
      C_C_LATENCY         => C_C_LATENCY,
      C_OUT_HIGH          => C_OUT_HIGH,
      C_OUT_LOW           => C_OUT_LOW,
      C_USE_PCIN          => C_USE_PCIN
      )
    PORT MAP (
      CLK      => CLK,
      CE       => CE,
      SCLR     => SCLR,
      A        => A,
      B        => B,
      C        => C,
      PCIN     => PCIN,
      SUBTRACT => SUBTRACT,
      P        => P,
      PCOUT    => PCOUT
      );

  --core_if off
  
end behavioral;

