-- $RCSfile: c_mux_bit_v9_1_comp.vhd,v $ $Revision: 1.1 $ $Date: 2010-07-10 21:42:48 $
--------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

PACKAGE c_mux_bit_v9_1_comp IS


----- Component c_mux_bit_v9_1 -----
-- Short Description
--
-- (A)Synchronous N-to-1 Mux
--

  COMPONENT c_mux_bit_v9_1
    GENERIC (
      c_inputs        : INTEGER := 2;
      c_sel_width     : INTEGER := 1;
      c_pipe_stages   : INTEGER := 0;
      c_latency       : INTEGER := 1;
      c_height        : INTEGER := 0;
      c_ainit_val     : STRING  := "0";
      c_sinit_val     : STRING  := "0";
      c_sync_enable   : INTEGER := 0;
      c_sync_priority : INTEGER := 1;
      c_has_o         : INTEGER := 0;
      c_has_q         : INTEGER := 1;
      c_has_ce        : INTEGER := 0;
      c_has_aclr      : INTEGER := 0;
      c_has_aset      : INTEGER := 0;
      c_has_ainit     : INTEGER := 0;
      c_has_sclr      : INTEGER := 0;
      c_has_sset      : INTEGER := 0;
      c_has_sinit     : INTEGER := 0;
      c_enable_rlocs  : INTEGER := 0
      ); 

    PORT (
      m     : IN  STD_LOGIC_VECTOR(c_inputs-1 DOWNTO 0)    := (OTHERS => '0');  -- input vector
      s     : IN  STD_LOGIC_VECTOR(c_sel_width-1 DOWNTO 0) := (OTHERS => '0');  -- select pin
      clk   : IN  STD_LOGIC                                := '0';  -- optional clock
      ce    : IN  STD_LOGIC                                := '1';  -- optional clock enable
      ainit : IN  STD_LOGIC                                := '0';  -- optional asynch reset to init_val
      aset  : IN  STD_LOGIC                                := '0';  -- optional asynch set to '1'
      aclr  : IN  STD_LOGIC                                := '0';  -- optional asynch clear to '0'
      sinit : IN  STD_LOGIC                                := '0';  -- optional synch reset to init_val
      sset  : IN  STD_LOGIC                                := '0';  -- optional synch set to '1'
      sclr  : IN  STD_LOGIC                                := '0';  -- optional synch set to '0'
      o     : OUT STD_LOGIC;            -- output value
      q     : OUT STD_LOGIC             -- registered output value
      );
  END COMPONENT;
  -- The following tells XST that c_mux_bit_v9_1 is a black box which  
  -- should be generated command given by the value of this attribute 
  -- Note the fully qualified SIM (JAVA class) name that forms the 
  -- basis of the core

  -- xcc exclude
  ATTRIBUTE box_type : STRING;
  ATTRIBUTE generator_default : STRING;
  ATTRIBUTE box_type OF c_mux_bit_v9_1 : COMPONENT IS "black_box";
  ATTRIBUTE generator_default OF c_mux_bit_v9_1 : COMPONENT IS
    "generatecore com.xilinx.ip.c_mux_bit_v9_1.c_mux_bit_v9_1";
  -- xcc include

END c_mux_bit_v9_1_comp;
