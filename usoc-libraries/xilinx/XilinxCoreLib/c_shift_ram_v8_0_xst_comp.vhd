-- $RCSfile: c_shift_ram_v8_0_xst_comp.vhd,v $ $Revision: 1.1 $ $Date: 2010-07-10 21:42:56 $
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
-----------------------------------------------------------------------
--
-- Use VHDL package bb_comps to define black box components to be
-- generated by a synthesis tool.
--
-- This file should not be copied over to the export area
-- unless it is specifically required by the synthesis tool.
--
-- Try to ensue that the file-sets processed by XCC and the synthesis
-- tool is disjoint.
--
-----------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package c_shift_ram_v8_0_xst_comp is

----------------------------------------------------------
-- Insert component declaration of top level xst file here
----------------------------------------------------------
  COMPONENT c_shift_ram_v8_0_xst
    GENERIC (
      c_family             : STRING  := "virtex2";  -- Lossless mode is architecture-specific
      c_width              : INTEGER := 16;  -- Default is 16
      c_depth              : INTEGER := 16;  -- SRL16 depth (default = 16 = 1x SRL16) 
      c_addr_width         : INTEGER := 4;  -- Dependent on c_width value specified
      c_shift_type         : INTEGER := 0;  -- 0=fixed, 1=lossless, 2=lossy
      c_opt_goal           : INTEGER := 0;  -- 0=area, 1=speed
      c_ainit_val          : STRING  := "0000000000000000";  -- Applies only to registered output
      c_sinit_val          : STRING  := "0000000000000000";  -- Applies only to registered output    
      c_default_data       : STRING  := "0000000000000000";  -- No init details, use this val
      c_default_data_radix : INTEGER := 1;  -- 0=no init values, 1=hex ,2=bin, 3=dec
      c_has_a              : INTEGER := 0;  -- Address bus only exists for var length
      c_has_ce             : INTEGER := 0;
      c_reg_last_bit       : INTEGER := 0;  -- Register last output bit (with FF)
      c_sync_priority      : INTEGER := 1;  -- Applies only to registered output
      c_sync_enable        : INTEGER := 0;  -- Applies only to registered output
      c_has_aclr           : INTEGER := 0;  -- Applies only to registered output    
      c_has_aset           : INTEGER := 0;  -- Applies only to registered output
      c_has_ainit          : INTEGER := 0;  -- Applies only to registered output    
      c_has_sclr           : INTEGER := 0;  -- Applies only to registered output
      c_has_sset           : INTEGER := 0;  -- Applies only to registered output
      c_has_sinit          : INTEGER := 0;  -- Applies only to registered output
      c_mem_init_file      : STRING  := "init.mif";
      c_elaboration_dir    : STRING  := "./";      
      c_mem_init_radix     : INTEGER := 1;  -- for backwards compatibility
      c_generate_mif       : INTEGER := 0;  -- Unused by the behavioural model    
      c_read_mif           : INTEGER := 0;  -- Redundant in VHDL core
      c_enable_rlocs       : INTEGER := 0   -- Not used with VHDL core
      );
    PORT (
      a     : IN  STD_LOGIC_VECTOR(c_addr_width-1 DOWNTO 0);
      d     : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0);
      clk   : IN  STD_LOGIC;
      ce    : IN  STD_LOGIC;
      aclr  : IN  STD_LOGIC;
      aset  : IN  STD_LOGIC;
      ainit : IN  STD_LOGIC;
      sclr  : IN  STD_LOGIC;
      sset  : IN  STD_LOGIC;
      sinit : IN  STD_LOGIC;
      q     : OUT STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)
      );

  END COMPONENT;

end c_shift_ram_v8_0_xst_comp;
