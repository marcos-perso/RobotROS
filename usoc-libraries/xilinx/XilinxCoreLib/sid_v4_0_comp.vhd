--------------------------------------------------------------------------------
-- Copyright(C) 2004 by Xilinx, Inc. All rights reserved.
-- This text/file contains proprietary, confidential
-- information of Xilinx, Inc., is distributed under license
-- from Xilinx, Inc., and may be used, copied and/or
-- disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc. Xilinx hereby grants you
-- a license to use this text/file solely for design, simulation,
-- implementation and creation of design files limited
-- to Xilinx devices or technologies. Use with non-Xilinx
-- devices or technologies is expressly prohibited and
-- immediately terminates your license unless covered by
-- a separate agreement.
--
-- Xilinx is providing this design, code, or information
-- "as is" solely for use in developing programs and
-- solutions for Xilinx devices. By providing this design,
-- code, or information as one possible implementation of
-- this feature, application or standard, Xilinx is making no
-- representation that this implementation is free from any
-- claims of infringement. You are responsible for
-- obtaining any rights you may require for your implementation.
-- Xilinx expressly disclaims any warranty whatsoever with
-- respect to the adequacy of the implementation, including
-- but not limited to any warranties or representations that this
-- implementation is free from claims of infringement, implied
-- warranties of merchantability or fitness for a particular
-- purpose.
--
-- Xilinx products are not intended for use in life support
-- appliances, devices, or systems. Use in such applications are
-- expressly prohibited.
--
-- This copyright and support notice must be retained as part
-- of this text at all times. (c) Copyright 1995-2004 Xilinx, Inc.
-- All rights reserved.
--
-- $RCSfile: sid_v4_0_comp.vhd,v $ $Revision: 1.1 $ $Date: 2010-07-10 21:43:22 $
--
-- Description: Component statement for Interleaver/Deinterleaver
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE sid_v4_0_comp IS

FUNCTION bits_to_rep(a_value : NATURAL) RETURN NATURAL;
  
FUNCTION select_int(i0  : INTEGER;
                    i1  : INTEGER;
                    sel : BOOLEAN) RETURN INTEGER;
  
-- Rectangular-block limits
CONSTANT abs_min_num_rows        : INTEGER := 1;
CONSTANT abs_min_num_cols        : INTEGER := 2;

-- c_family_int constants
CONSTANT c_virtex                : INTEGER := 0;
CONSTANT c_virtex2               : INTEGER := 1;

-- c_type constants
CONSTANT c_rectangular_block     : INTEGER := 0;
CONSTANT c_random_block          : INTEGER := 1;
CONSTANT c_relative_prime_block  : INTEGER := 2;
CONSTANT c_dvb_rcs_block         : INTEGER := 3;
CONSTANT c_umts_block            : INTEGER := 4;
-- 5-19 are reserved for future block-based types
CONSTANT c_forney_convolutional  : INTEGER := 20;
CONSTANT c_ramsey1_convolutional : INTEGER := 21;
CONSTANT c_ramsey2_convolutional : INTEGER := 22;
CONSTANT c_ramsey3_convolutional : INTEGER := 23;
CONSTANT c_ramsey4_convolutional : INTEGER := 24;
-- 25-40 are reserved for future convolutional-based types
-- c_mode constants
CONSTANT c_interleaver           : INTEGER := 0;
CONSTANT c_deinterleaver         : INTEGER := 1;
-- c_row_type, c_col_type, c_block_size_type, and c_branch_length_type constants
CONSTANT c_constant              : INTEGER := 0; -- c_row_type, c_col_type, c_block_size_type, c_branch_length_type
CONSTANT c_variable              : INTEGER := 1; -- c_row_type, c_col_type, c_block_size_type
CONSTANT c_selectable            : INTEGER := 2; -- c_row_type, c_col_type
CONSTANT c_row_x_col             : INTEGER := 3; -- c_block_size_type
CONSTANT c_file                  : INTEGER := 4; -- c_branch_length_type
-- c_memstyle constants
CONSTANT c_distmem               : INTEGER := 0;
CONSTANT c_blockmem              : INTEGER := 1;
CONSTANT c_automatic             : INTEGER := 2;
-- c_pipe_level constants
CONSTANT c_minimum               : INTEGER := 0;
CONSTANT c_maximum               : INTEGER := 2;


-- c_architecture constants
-- For Convolutional interleaver
CONSTANT c_use_rom               : INTEGER := 0;
CONSTANT c_use_logic             : INTEGER := 1;


--------------------------------------------------------------------------------
-- Component declaration
--------------------------------------------------------------------------------
COMPONENT sid_v4_0
GENERIC (
  c_family                  : STRING  := "virtex2";
  c_architecture            : INTEGER := c_use_rom;
  c_mem_init_prefix         : STRING  := "sid1";
  c_type                    : INTEGER := c_forney_convolutional;
  c_mode                    : INTEGER := c_interleaver;
  c_symbol_width            : INTEGER := 1;
  -- Row specific GENERICs
  c_row_type                : INTEGER := c_constant;
  c_row_constant            : INTEGER := 16;
  c_has_row                 : INTEGER := 0;
  c_has_row_valid           : INTEGER := 1;
  c_min_num_rows            : INTEGER := abs_min_num_rows;
  c_row_width               : INTEGER := 4;
  c_num_selectable_rows     : INTEGER := 4;
  c_row_select_file         : STRING  := "null.mif";
  c_has_row_sel             : INTEGER := 0;
  c_has_row_sel_valid       : INTEGER := 0;
  c_use_row_permute_file    : INTEGER := 0;
  c_row_permute_file        : STRING  := "null.mif";
  -- Col specific GENERICs
  c_col_type                : INTEGER := c_constant;
  c_col_constant            : INTEGER := 16;
  c_has_col                 : INTEGER := 0;
  c_has_col_valid           : INTEGER := 1;
  c_min_num_cols            : INTEGER := abs_min_num_cols;
  c_col_width               : INTEGER := 4;
  c_num_selectable_cols     : INTEGER := 4;
  c_col_select_file         : STRING  := "null.mif";
  c_has_col_sel             : INTEGER := 0;
  c_has_col_sel_valid       : INTEGER := 0;
  c_use_col_permute_file    : INTEGER := 0;
  c_col_permute_file        : STRING  := "null.mif";
  -- Block size specific GENERICs
  c_block_size_type         : INTEGER := c_constant;
  c_block_size_constant     : INTEGER := 256;
  c_has_block_size          : INTEGER := 0;
  c_block_size_width        : INTEGER := 8;
  c_has_block_size_valid    : INTEGER := 0;
  -- Random block specific GENERICs
  c_seed                    : INTEGER := 0;
  c_use_spreads             : INTEGER := 0;
  c_spread1                 : INTEGER := 1;
  c_spread2                 : INTEGER := 1;
  c_add_symmetry_constraint : INTEGER := 0;
  c_use_k                   : INTEGER := 0;
  c_k                       : INTEGER := 2;
  -- Relative prime block specific GENERICs
  c_relative_prime          : INTEGER := 1;
  -- Convolution specific GENERICs
  c_num_branches            : INTEGER := 16;
  c_branch_length_type      : INTEGER := c_constant;
  c_branch_length_constant  : INTEGER := 1;
  c_branch_length_file      : STRING  := "null.mif";
  c_num_configurations      : INTEGER := 1;
  -- Ramsey specific GENERICs
  c_n1                      : INTEGER := 3;
  c_n2                      : INTEGER := 1;
  -- Implementation GENERICs
  c_external_ram            : INTEGER := 0;
  -- Supplied c_ext_addr_width must match internally computed value
  c_ext_addr_width          : INTEGER;
  c_memstyle                : INTEGER := c_automatic;
  c_pipe_level              : INTEGER := c_minimum;
  c_throughput_mode         : INTEGER := 0;
  c_enable_rlocs            : INTEGER := 0;
  -- Optional pin GENERICs
  c_has_ce                  : INTEGER := 0;
  c_has_nd                  : INTEGER := 0;
  c_has_sclr                : INTEGER := 0;
  c_has_aclr                : INTEGER := 0;
  c_has_rdy                 : INTEGER := 0;
  c_has_rfd                 : INTEGER := 0;
  c_has_rffd                : INTEGER := 0;
  c_has_block_start         : INTEGER := 0;
  c_has_block_end           : INTEGER := 0;
  c_has_fdo                 : INTEGER := 0;
  c_has_ndo                 : INTEGER := 0);
PORT (
  -- Mandatory input pins
  clk              : IN STD_LOGIC;
  fd               : IN STD_LOGIC;
  nd               : IN STD_LOGIC;
  din              : IN STD_LOGIC_VECTOR(c_symbol_width-1 DOWNTO 0);
  -- Optional input pins
  ce               : IN STD_LOGIC := '1';
  sclr             : IN STD_LOGIC := '0';
  aclr             : IN STD_LOGIC := '0';
  row              : IN STD_LOGIC_VECTOR(c_row_width-1 DOWNTO 0)
                                    := (OTHERS=>'0');
  row_sel          : IN STD_LOGIC_VECTOR(
                         (bits_to_rep(c_num_selectable_rows-1) -1)
                          DOWNTO 0) := (OTHERS=>'0');
                          
  col              : IN STD_LOGIC_VECTOR((c_col_width - 1) DOWNTO 0)
                                    := (OTHERS=>'0');
  col_sel          : IN STD_LOGIC_VECTOR(
                         (bits_to_rep(c_num_selectable_cols-1) -1)
                          DOWNTO 0) := (OTHERS=>'0');
                          
  block_size       : IN STD_LOGIC_VECTOR((c_block_size_width-1) DOWNTO 0)
                                    := (OTHERS=>'0');
                                    
  config_sel       : IN STD_LOGIC_VECTOR(
                     select_int(bits_to_rep(c_num_configurations-1),
                                1, c_num_configurations <= 1) -1 DOWNTO 0)
                                    := (OTHERS=>'0');
                                    
  new_config       : IN STD_LOGIC := '0';
                 
  rd_data          : IN STD_LOGIC_VECTOR(c_symbol_width-1 DOWNTO 0)
                                := (OTHERS=>'0'); -- Read data from external RAM
  -- DVB-RCS specific input pins
  np               : IN STD_LOGIC := '0';
  p0               : IN STD_LOGIC_VECTOR(5 DOWNTO 0) := (OTHERS=>'0');
  p1               : IN STD_LOGIC_VECTOR(9 DOWNTO 0) := (OTHERS=>'0');
  p2               : IN STD_LOGIC_VECTOR(9 DOWNTO 0) := (OTHERS=>'0');
  p3               : IN STD_LOGIC_VECTOR(9 DOWNTO 0) := (OTHERS=>'0');
  -- Mandatory output pins
  dout             : OUT STD_LOGIC_VECTOR(c_symbol_width-1 DOWNTO 0);
  -- Optional output pins
  rd_en            : OUT STD_LOGIC;
  wr_en            : OUT STD_LOGIC;
  rd_addr          : OUT STD_LOGIC_VECTOR(c_ext_addr_width-1 DOWNTO 0);
  wr_addr          : OUT STD_LOGIC_VECTOR(c_ext_addr_width-1 DOWNTO 0);
  wr_data          : OUT STD_LOGIC_VECTOR(c_symbol_width-1 DOWNTO 0); -- Write data to external RAM
  rfd              : OUT STD_LOGIC;
  rdy              : OUT STD_LOGIC;
  rffd             : OUT STD_LOGIC;
  row_valid        : OUT STD_LOGIC;
  col_valid        : OUT STD_LOGIC;
  row_sel_valid    : OUT STD_LOGIC;
  col_sel_valid    : OUT STD_LOGIC;
  block_size_valid : OUT STD_LOGIC;
  block_start      : OUT STD_LOGIC;
  block_end        : OUT STD_LOGIC;
  fdo              : OUT STD_LOGIC;
  ndo              : OUT STD_LOGIC);
END COMPONENT; -- sid_v4_0

-- The following tells XST that SID_V4_0 is a black box which 
-- should be generated by the command given by the value of this attribute.
-- Note the fully qualified SIM (JAVA class) name that forms the basis of the
-- core.
ATTRIBUTE box_type : STRING; 
ATTRIBUTE box_type OF SID_V4_0 : COMPONENT IS "black_box"; 
ATTRIBUTE GENERATOR_DEFAULT : STRING; 
ATTRIBUTE GENERATOR_DEFAULT OF SID_V4_0 : COMPONENT IS 
                                 "generatecore com.xilinx.ip.sid_v4_0.sid_v4_0";

END sid_v4_0_comp;


PACKAGE BODY sid_v4_0_comp IS

--------------------------------------------------------------------------------
-- Return number of bits required to represent the supplied parameter
--------------------------------------------------------------------------------
FUNCTION bits_to_rep(a_value : NATURAL) RETURN NATURAL IS
  VARIABLE return_value : NATURAL := 1;
BEGIN

  FOR i IN 30 DOWNTO 0 LOOP
    IF a_value >= 2**i THEN
        return_value := i+1;
        EXIT;
    END IF;
  END LOOP;

  RETURN return_value;
  
END bits_to_rep;

--------------------------------------------------------------------------------
-- Return i0 if sel = FALSE, i1 if sel = TRUE
--------------------------------------------------------------------------------
FUNCTION select_int(i0  : INTEGER;
                    i1  : INTEGER;
                    sel : BOOLEAN) RETURN INTEGER IS
BEGIN
  IF sel THEN
    RETURN i1;
  ELSE
    RETURN i0;
  END IF; -- sel
END select_int;
  

END sid_v4_0_comp;
