-- $Header: /local/Projects/CVS/P1/zpu_SoC/sources/xilinx/XilinxCoreLib/sdivider_v3_0_comp.vhd,v 1.1 2010-07-10 21:43:21 mmartinez Exp $
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
--
------------------------------------------------------------
--
--  Description
--  Pipelined divide package
--                  
--
------------------------------------------------------------
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

PACKAGE sdivider_v3_0_comp IS

  COMPONENT sdivider_v3_0
    GENERIC (
      c_has_aclr       : INTEGER  := 0;
      c_has_ce         : INTEGER  := 0;
      c_has_sclr       : INTEGER  := 0;
      c_sync_enable    : INTEGER  := 0;
      divclk_Sel       : POSITIVE := 1;
      dividend_width   : POSITIVE := 8;
      divisor_width    : POSITIVE := 8;
      fractional_b     : INTEGER  := 0;
      fractional_width : POSITIVE := 8;
      signed_b         : INTEGER  := 0
--      c_has_nd           : INTEGER  := 0;
--      c_has_rfd          : INTEGER  := 0;
--      c_has_rdy          : INTEGER  := 0;
--      c_enable_rlocs     : INTEGER        
      );
    PORT(
      dividend : IN  STD_LOGIC_VECTOR(dividend_width-1 DOWNTO 0);
      divisor  : IN  STD_LOGIC_VECTOR(divisor_width-1 DOWNTO 0);
      quot     : OUT STD_LOGIC_VECTOR(dividend_width-1 DOWNTO 0);
      remd     : OUT STD_LOGIC_VECTOR(fractional_width-1 DOWNTO 0);
      clk      : IN  STD_LOGIC;
      rfd      : OUT STD_LOGIC;
      aclr     : IN  STD_LOGIC := '0';
      sclr     : IN  STD_LOGIC := '0';
      ce       : IN  STD_LOGIC := '0'
--      nd       : IN  STD_LOGIC;
--      rdy      : OUT STD_LOGIC;
      );
  END COMPONENT;
  -- The following tells XST that div_repmult_v1_0 is a black box which  
  -- should be generated command given by the value of this attribute 
  -- Note the fully qualified SIM (JAVA class) name that forms the 
  -- basis of the core

  -- xcc exclude
  attribute box_type                              : string;
  attribute generator_default                     : string;
  attribute box_type of sdivider_v3_0          : component is "black_box";
  attribute generator_default of sdivider_v3_0 : component is
    "generatecore com.xilinx.ip.sdivider_v3_0.sdivider_v3_0";
  -- xcc include

END sdivider_v3_0_comp;
