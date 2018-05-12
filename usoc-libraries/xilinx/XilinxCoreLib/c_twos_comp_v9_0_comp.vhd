-- $RCSfile: c_twos_comp_v9_0_comp.vhd,v $ $Revision: 1.1 $ $Date: 2010-07-10 21:42:58 $
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
--
-- Filename - c_twos_comp_v9_0_comp.vhd
-- Author - Xilinx
-- Creation - 4 Mar 1999
--
-- Description - This file contains the component declaration for
--                               the c_twos_comp_v9_0 core

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

--LIBRARY Xilinxcorelib;
--USE Xilinxcorelib.prims_constants_v9_0.ALL;

PACKAGE c_twos_comp_v9_0_comp IS


----- Component c_twos_comp_v9_0 -----
-- Short Description
--
-- (A)synchronous 2's complimenter
--

  COMPONENT c_twos_comp_v9_0
    GENERIC(
      c_width         : INTEGER := 16;
      c_ainit_val     : STRING  := "0";                
      c_sinit_val     : STRING  := "0";                
      c_bypass_enable : INTEGER := 0;
      c_bypass_low    : INTEGER := 0;
      c_sync_priority : INTEGER := 0;
      c_sync_enable   : INTEGER := 0;
      c_pipe_stages   : INTEGER := 0;
      c_has_bypass    : INTEGER := 0;
      c_has_ce        : INTEGER := 0;
      c_has_aclr      : INTEGER := 0;
      c_has_aset      : INTEGER := 0;
      c_has_ainit     : INTEGER := 0;
      c_has_sclr      : INTEGER := 0;
      c_has_sset      : INTEGER := 0;
      c_has_sinit     : INTEGER := 0;
      c_has_s         : INTEGER := 0;
      c_has_q         : INTEGER := 1;
      c_enable_rlocs  : INTEGER := 0
      );

    PORT (
      a      : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0) := (OTHERS => '0');  -- signed input value!
      bypass : IN  STD_LOGIC                            := '0';  -- control of negation : '0' = negate input
      clk    : IN  STD_LOGIC                            := '0';  -- clock
      ce     : IN  STD_LOGIC                            := '1';  -- clock enable
      aclr   : IN  STD_LOGIC                            := '0';  -- asynch init.
      aset   : IN  STD_LOGIC                            := '0';  -- asynch set.
      ainit  : IN  STD_LOGIC                            := '0';  -- asynch init.
      sclr   : IN  STD_LOGIC                            := '0';  -- synch init.
      sset   : IN  STD_LOGIC                            := '0';  -- synch set.               
      sinit  : IN  STD_LOGIC                            := '0';  -- synch init.
      s      : OUT STD_LOGIC_VECTOR(c_width DOWNTO 0);  -- asynch output
      q      : OUT STD_LOGIC_VECTOR(c_width DOWNTO 0)  -- registered output value
      );

  END COMPONENT;
  -- The following tells XST that c_twos_comp_v9_0 is a black box which  
  -- should be generated command given by the value of this attribute 
  -- Note the fully qualified SIM (JAVA class) name that forms the 
  -- basis of the core 

  --xcc exclude
  ATTRIBUTE box_type                           : STRING;
  ATTRIBUTE GENERATOR_DEFAULT                  : STRING;

  ATTRIBUTE box_type OF c_twos_comp_v9_0          : COMPONENT IS "black_box"; 
  ATTRIBUTE GENERATOR_DEFAULT OF c_twos_comp_v9_0 : COMPONENT IS
    "generatecore com.xilinx.ip.c_twos_comp_v9_0.c_twos_comp_v9_0"; 
  --xcc include
END c_twos_comp_v9_0_comp;
