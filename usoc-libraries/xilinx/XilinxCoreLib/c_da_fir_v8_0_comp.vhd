-- $Id: c_da_fir_v8_0_comp.vhd,v 1.1 2010-07-10 21:42:42 mmartinez Exp $


--  Copyright(C) 2003 by Xilinx, Inc. All rights reserved.
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
--  of this text at all times. (c) Copyright 1995-2003 Xilinx, Inc.
--  All rights reserved.


--  Description:
--   Compontent declaration
--   DA FIR Simulation Model



LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
--USE XilinxCoreLib.dafir_pack.ALL;
USE XilinxCoreLib.ul_utils.ALL;


PACKAGE c_da_fir_v8_0_comp IS
COMPONENT C_DA_FIR_V8_0 
  GENERIC( c_data_width : INTEGER;
           c_result_width : INTEGER;
           c_coeff_width : INTEGER;
           c_taps : INTEGER;
           c_response : INTEGER;
           c_data_type : INTEGER;
           c_coeff_type : INTEGER;
           c_channels : INTEGER;
           c_filter_type : INTEGER;
           c_saturate : INTEGER;
           c_has_sel_o : INTEGER;
           c_has_sel_i : INTEGER;
           c_has_reset : INTEGER;
           c_mem_init_file : STRING;
           c_zpf : INTEGER;
           c_baat : INTEGER; 
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


END c_da_fir_v8_0_comp;
