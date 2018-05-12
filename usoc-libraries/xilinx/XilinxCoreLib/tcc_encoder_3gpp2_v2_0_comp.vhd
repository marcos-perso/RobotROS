-- $RCSfile: tcc_encoder_3gpp2_v2_0_comp.vhd,v $ $Revision: 1.1 $ $Date: 2010-07-10 21:43:25 $
--
--  Copyright(C) 2007 by Xilinx, Inc. All rights reserved.
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
--  of this text at all times. (c) Copyright 1995-2007 Xilinx, Inc.
--  All rights reserved.

-------------------------------------------------------------------------------
-- Component statement for behavioral model
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

-- LIBRARY basebollox_utils_v9_0;
-- USE baseblox_utils_v9_0.prims_constants_v9_0.ALL;

PACKAGE tcc_encoder_3gpp2_v2_0_comp IS

  --core_if on component no_coregen_specials
  component tcc_encoder_3gpp2_v2_0
    generic (
      c_elaboration_dir :     string  := "./";
      c_family          :     string  := "virtex2";
      c_component_name  :     string  := "tcc_encoder_3gpp2_v2_0";
      c_has_nd          :     integer := 0;
      --c_has_rfd         :     integer := 0;
      c_has_rfd_in      :     integer := 0;
      c_has_ce          :     integer := 0;
      c_has_sclr        :     integer := 0;
      c_has_aclr        :     integer := 0
      );
    port (
      clk               : in  std_logic;
      ce                : in  std_logic:='0';
      aclr              : in  std_logic:='0';
      sclr              : in  std_logic:='0';
      fd_in             : in  std_logic;
      nd                : in  std_logic:='0';
      block_size_sel    : in  std_logic_vector(3 downto 0);
      rfd_in            : in  std_logic:='0';
      data_in           : in  std_logic;
      rfd               : out std_logic;
      rffd              : out std_logic;
      rdy               : out std_logic;
      rsc1_systematic   : out std_logic;
      rsc1_parity0      : out std_logic;
      rsc1_parity1      : out std_logic;
      rsc2_systematic   : out std_logic;
      rsc2_parity0      : out std_logic;
      rsc2_parity1      : out std_logic;
      --block_end        : out std_logic;
      rsc1_tail         : out std_logic;
      rsc2_tail         : out std_logic
      );

  --core_if off
  END COMPONENT;
  -- The following tells XST that tcc_encoder_3gpp2_v2_0 is a black box which  
  -- should be generated command given by the value of this attribute 
  -- Note the fully qualified SIM (JAVA class) name that forms the 
  -- basis of the core

  -- xcc exclude
  ATTRIBUTE box_type : STRING;
  ATTRIBUTE generator_default : STRING;
  ATTRIBUTE box_type OF tcc_encoder_3gpp2_v2_0 : COMPONENT IS "black_box";
  ATTRIBUTE generator_default OF tcc_encoder_3gpp2_v2_0 : COMPONENT IS
    "generatecore com.xilinx.ip.tcc_encoder_3gpp2_v2_0.tcc_encoder_3gpp2_v2_0";
  -- xcc include

END tcc_encoder_3gpp2_v2_0_comp;
