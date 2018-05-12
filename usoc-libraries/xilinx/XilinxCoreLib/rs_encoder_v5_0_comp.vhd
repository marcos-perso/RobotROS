--------------------------------------------------------------------------------
-- Copyright(C) 2004 by Xilinx, Inc. All rights reserved.
-- This text contains proprietary, confidential
-- information of Xilinx, Inc., is distributed
-- under license from Xilinx, Inc., and may be used,
-- copied and/or disclosed only pursuant to the terms
-- of a valid license agreement with Xilinx, Inc. This copyright
-- notice must be retained as part of this text at all times."
--
-- $RCSfile: rs_encoder_v5_0_comp.vhd,v $ $Revision: 1.1 $ $Date: 2010-07-10 21:43:20 $
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.STD_LOGIC_1164.ALL;

PACKAGE rs_encoder_v5_0_comp IS

CONSTANT c_family_default          : STRING   := "virtex2";
CONSTANT c_gen_poly_type_default   : INTEGER  := 0;
CONSTANT c_gen_start_default       : INTEGER  := 0;
CONSTANT c_h_default               : INTEGER  := 1;
CONSTANT c_ce_default              : INTEGER  := 0;
CONSTANT c_n_in_default            : INTEGER  := 0;
CONSTANT c_nd_default              : INTEGER  := 0;
CONSTANT c_r_in_default            : INTEGER  := 0;
CONSTANT c_rdy_default             : INTEGER  := 0;
CONSTANT c_rfd_default             : INTEGER  := 0;
CONSTANT c_rffd_default            : INTEGER  := 0;
CONSTANT c_k_default               : INTEGER  := 188;
CONSTANT c_mem_init_prefix_default : STRING   := "rse1";
CONSTANT c_memstyle_default        : INTEGER  := 2; -- = automatic
CONSTANT c_n_default               : INTEGER  := 204;
CONSTANT c_num_channels_default    : INTEGER  := 1;
CONSTANT c_optimization_default    : INTEGER  := 2; --optimize for speed
CONSTANT c_polynomial_default      : INTEGER  := 0;
CONSTANT c_spec_default            : INTEGER  := 0;
CONSTANT c_symbol_width_default    : INTEGER  := 8;
CONSTANT c_userpm_default          : INTEGER  := 1;

FUNCTION integer_width( integer_value : INTEGER ) RETURN INTEGER;
      
--------------------------------------------------------------------------------
COMPONENT rs_encoder_v5_0
  GENERIC (
    c_family          : STRING            := c_family_default;
    c_gen_poly_type   : INTEGER           := c_gen_poly_type_default;
    c_gen_start       : INTEGER           := c_gen_start_default;
    c_h               : INTEGER           := c_h_default;
    c_has_ce          : INTEGER           := c_ce_default;
    c_has_n_in        : INTEGER           := c_n_in_default;
    c_has_nd          : INTEGER           := c_nd_default;
    c_has_r_in        : INTEGER           := c_r_in_default;
    c_has_rdy         : INTEGER           := c_rdy_default;
    c_has_rfd         : INTEGER           := c_rfd_default;
    c_has_rffd        : INTEGER           := c_rffd_default;
    c_k               : INTEGER           := c_k_default;
    c_mem_init_prefix : STRING            := "rse1";
    c_memstyle        : INTEGER           := c_memstyle_default;
    c_n               : INTEGER           := c_n_default;
    c_num_channels    : INTEGER           := c_num_channels_default;
    -- c_optimization is no longer used. Keep parameter for b/w compatibility.
    c_optimization    : INTEGER           := c_optimization_default;
    c_polynomial      : INTEGER           := c_polynomial_default;
    c_spec            : INTEGER           := c_spec_default;
    c_symbol_width    : INTEGER           := c_symbol_width_default;
    c_userpm          : INTEGER           := c_userpm_default
  );
  PORT (
    data_in         : IN  STD_LOGIC_VECTOR(c_symbol_width - 1 DOWNTO 0);
    n_in            : IN  STD_LOGIC_VECTOR(c_symbol_width - 1 DOWNTO 0) := (OTHERS => '1');
    r_in            : IN  STD_LOGIC_VECTOR(integer_width(c_n-c_k) - 1 DOWNTO 0) := (OTHERS => '0');
    start           : IN  STD_LOGIC;
    bypass          : IN  STD_LOGIC := '0';
    nd              : IN  STD_LOGIC := '1';
    data_out        : OUT STD_LOGIC_VECTOR(c_symbol_width - 1 DOWNTO 0);
    info            : OUT STD_LOGIC;
    rdy             : OUT STD_LOGIC;
    rfd             : OUT STD_LOGIC;
    rffd            : OUT STD_LOGIC;
    ce              : IN  STD_LOGIC := '1';
    reset           : IN  STD_LOGIC := '0';
    clk             : IN  STD_LOGIC
  );
END COMPONENT; -- rs_encoder_v5_0

-- The following tells XST that rs_encoder_v5_0 is a black box which  
-- should be generated command given by the value of this attribute 
-- Note the fully qualified SIM (JAVA class) name that forms the 
-- basis of the core 
ATTRIBUTE box_type : string; 
ATTRIBUTE box_type OF RS_ENCODER_v5_0 : COMPONENT IS "black_box"; 
ATTRIBUTE GENERATOR_DEFAULT : string; 
ATTRIBUTE GENERATOR_DEFAULT OF RS_ENCODER_v5_0 : COMPONENT IS 
          "generatecore com.xilinx.ip.rs_encoder_v5_0.rs_encoder_v5_0";

END rs_encoder_v5_0_comp;
          
PACKAGE BODY rs_encoder_v5_0_comp IS

FUNCTION integer_width( integer_value : INTEGER ) RETURN INTEGER IS
    VARIABLE width : INTEGER := 1;
BEGIN
  FOR i IN 30 DOWNTO 0 LOOP
    IF integer_value >= 2**i THEN
      width := i+1;
      EXIT;
    END IF;
  END LOOP;

  RETURN width;

END integer_width;
  
  
END rs_encoder_v5_0_comp;


--------------------------------------------------------------------------------
