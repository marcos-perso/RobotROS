-- $Header: /local/Projects/CVS/P1/zpu_SoC/sources/xilinx/XilinxCoreLib/div_repmult_v1_0_xst_comp.vhd,v 1.1 2010-07-10 21:43:06 mmartinez Exp $
--
--  Copyright(C) 2005 by Xilinx, Inc. All rights reserved.
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
--  of this text at all times. (c) Copyright 1995-2005 Xilinx, Inc.
--  All rights reserved.

-------------------------------------------------------------------------------
-- Component statement for wrapper of behavioural model
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package div_repmult_v1_0_xst_comp is

----------------------------------------------------------
-- Insert component declaration of top level xst file here
----------------------------------------------------------
  --core_if on component xst
  component div_repmult_v1_0_xst
    GENERIC (
      C_FAMILY : string :=  "virtex2";
      C_XDEVICEFAMILY : string :=  "virtex2";
      C_MANTISSA_WIDTH : integer :=  16;
      C_EXPONENT_WIDTH : integer :=  4;
      C_BIAS : integer :=  0;
      C_LATENCY : integer :=  0;
      C_HAS_CE : integer :=  0;
      C_HAS_SCLR : integer :=  0;
      C_SYNC_ENABLE : integer :=  0;
      C_HAS_ACLR : integer :=  0;
      C_ELABORATION_DIR : string :=  "./"
      );
    PORT (
      CLK : in std_logic;
      CE : in std_logic;
      SCLR : in std_logic;
      ACLR : in std_logic;
      DIVISOR_SIGN : in std_logic;
      DIVISOR_EXPONENT : in std_logic_vector(C_EXPONENT_WIDTH-1 downto 0);
      DIVISOR_MANTISSA : in std_logic_vector(C_MANTISSA_WIDTH-1 downto 0);
      DIVIDEND_SIGN : in std_logic;
      DIVIDEND_MANTISSA : in std_logic_vector(C_MANTISSA_WIDTH-1 downto 0);
      DIVIDEND_EXPONENT : in std_logic_vector(C_EXPONENT_WIDTH-1 downto 0);
      UNDERFLOW : out std_logic;
      OVERFLOW : out std_logic;
      QUOTIENT_SIGN : out std_logic;
      QUOTIENT_MANTISSA : out std_logic_vector(C_MANTISSA_WIDTH-1 downto 0);
      QUOTIENT_EXPONENT : out std_logic_vector(C_EXPONENT_WIDTH-1 downto 0)
      );
  --core_if off
  end component;



end div_repmult_v1_0_xst_comp;
