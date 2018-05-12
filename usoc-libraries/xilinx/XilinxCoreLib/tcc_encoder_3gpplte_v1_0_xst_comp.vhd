-- $RCSfile: tcc_encoder_3gpplte_v1_0_xst_comp.vhd,v $
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
-- Component statement for wrapper of behavioural model
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package tcc_encoder_3gpplte_v1_0_xst_comp is

  CONSTANT BLOCK_SIZE_PORT_WIDTH         : INTEGER := 13;
----------------------------------------------------------
-- Insert component declaration of top level xst file here
----------------------------------------------------------
  --core_if on component xst
  component tcc_encoder_3gpplte_v1_0_xst
  GENERIC (
    c_elaboration_dir :     string  := "./";
    c_component_name  :     string  := "tcc_encoder_3gpplte_v1_0"; --CR469085 : Added new generic.
    c_has_ce                  : INTEGER := 1;
    c_has_rfd_in              : INTEGER := 1;
    c_has_nd                  : INTEGER := 1;
    c_has_sclr                : INTEGER := 1;
    c_has_aclr                : INTEGER := 1;
    --c_has_block_size_valid    : INTEGER := 0;
    --c_mux_tail_bits           : INTEGER := 1;
    c_family                  : STRING  := "virtex4"
  );
  PORT (
    clk              : IN  std_logic;
    aclr             : IN  std_logic;
    sclr             : IN  std_logic;
    ce               : IN  std_logic;
    block_size       : IN STD_LOGIC_VECTOR(BLOCK_SIZE_PORT_WIDTH-1 DOWNTO 0);
    fd_in            : IN  std_logic;
    rfd_in           : IN  std_logic;
    data_in          : IN  std_logic;
    nd               : IN  std_logic;
    rffd             : OUT std_logic;
    rfd              : OUT std_logic;
    --block_size_valid : OUT std_logic;
    rsc1_systematic  : OUT std_logic;
    rsc1_parity0     : OUT std_logic;
    rsc1_tail        : OUT STD_LOGIC;
    --rsc2_systematic  : OUT std_logic;
    rsc2_parity0     : OUT std_logic;
    rsc2_tail        : OUT STD_LOGIC;
    block_start      : out std_logic;
    block_end        : out std_logic;
    rdy              : out std_logic
  );
  --core_if off
  END COMPONENT;


end tcc_encoder_3gpplte_v1_0_xst_comp;

