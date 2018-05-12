-- $Id: c_da_fir_v9_0_comp.vhd,v 1.1 2010-07-10 21:42:42 mmartinez Exp $
-- ************************************************************************
--  Copyright 1998 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************
--
--  Description:
--   Component declaration
--   DA FIR Simulation Model



LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.ul_utils.ALL;


PACKAGE c_da_fir_v9_0_comp IS
COMPONENT C_DA_FIR_V9_0 
  GENERIC( 
           component_name : STRING := "dafir9";
           c_data_width : INTEGER := 16;
           c_result_width : INTEGER := 32;
           c_coeff_width : INTEGER := 16;
           c_taps : INTEGER;
           c_response : INTEGER;
           c_data_type : INTEGER;
           c_coeff_type : INTEGER;
           c_channels : INTEGER := 2;
           c_filter_type : INTEGER;
           c_saturate : INTEGER;
           c_has_sel_o : INTEGER;
           c_has_sel_i : INTEGER;
           c_has_reset : INTEGER;
           c_mem_init_file : STRING;
           c_zpf : INTEGER;
           c_baat : INTEGER := 4; 
           c_has_sin_f : INTEGER; -- not supported 
           c_has_sin_r : INTEGER; -- not supported 
           c_has_sout_r : INTEGER; -- not supported
           c_has_sout_f : INTEGER; -- not supported
           c_reload : INTEGER; 
	   c_reload_delay : INTEGER;
	   c_reload_mem_type : INTEGER;
           c_reg_output : INTEGER; 
           c_polyphase_factor : INTEGER; 
           c_optimize : INTEGER; -- ignored by model
           c_enable_rlocs : INTEGER; -- ignore by model
           c_use_model_func : INTEGER; 
           c_latency : INTEGER; 
           c_shape : INTEGER); -- ignored by model
  PORT(      din  : IN  std_logic_vector( c_data_width-1 DOWNTO 0 );
               nd : IN  std_logic;
              clk : IN  std_logic;
              rst : IN  std_logic:= '0';
          coef_ld : IN  std_logic := '0';
           ld_din : IN  std_logic_vector( c_coeff_width-1 DOWNTO 0) := (others => '0');
            ld_we : IN  std_logic := '0';
         cas_f_in : IN  std_logic_vector( c_baat-1 downto 0) := (OTHERS => '0');
         cas_r_in : IN  std_logic_vector( c_baat-1 downto 0) := (OTHERS => '0');
        cas_f_out : OUT std_logic_vector( c_baat-1 downto 0);
        cas_r_out : OUT std_logic_vector( c_baat-1 downto 0);
            sel_i : OUT std_logic_vector( bitsneededtorepresent(c_channels-1)-1 DOWNTO 0);
            sel_o : OUT std_logic_vector( bitsneededtorepresent(c_channels-1)-1 DOWNTO 0);
             dout : OUT std_logic_vector( c_result_width-1 DOWNTO 0 );
           dout_q : OUT std_logic_vector( c_result_width-1 DOWNTO 0 );
           dout_i : OUT std_logic_vector( c_data_width-1 DOWNTO 0);
              rdy : OUT std_logic;
              rfd : OUT std_logic);
END COMPONENT;

END c_da_fir_v9_0_comp;
