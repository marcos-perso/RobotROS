-- Copyright(C) 2002 by Xilinx, Inc. All rights reserved.
-- This text contains proprietary, confidential
-- information of Xilinx, Inc., is distributed
-- under license from Xilinx, Inc., and may be used,
-- copied and/or disclosed only pursuant to the terms
-- of a valid license agreement with Xilinx, Inc. This copyright
-- notice must be retained as part of this text at all times.
--
-- $Id: mac_fir_v2_0_comp.vhd,v 1.1 2010-07-10 21:43:13 mmartinez Exp $
--
--  Description:
--   Compontent declaration
--   MAC FIR Simulation Model


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.ul_utils.ALL;

PACKAGE mac_fir_v2_0_comp IS
	
	--**** Use this line for ActiveHDL testbench
	--**** COMPONENT MAC_FIR_VHDL_Model 	
		
	--**** Use this line for SVG testbench
	COMPONENT C_MAC_FIR_V2_0 	
		
		GENERIC( c_area_speed_optimization : INTEGER;
					   c_channels 					: INTEGER;	
						 c_coefficients				: INTEGER;
		      	 c_coef_buffer_type 	: INTEGER;		      	
		      	 c_coef_init_file 		: STRING;
		      	 c_coef_type 					: INTEGER;
		      	 c_coef_width 				: INTEGER;
		      	 c_data_buffer_type 	: INTEGER;		      	
		      	 c_data_type 					: INTEGER;
				 		 c_data_width 				: INTEGER;
		      	 c_decimate_factor 		: INTEGER; 
		      	 c_filter_type 				: INTEGER; 
				 		 c_input_sample_rate 	: REAL;
		      	 c_interpolate_factor : INTEGER; 
		      	 c_latency 						: INTEGER;
				 		 c_num_coef_sets 			: INTEGER;
		      	 c_reg_output 				: INTEGER; 
		      	 c_reload 						: INTEGER; 
		   	  	 c_reload_delay 			: INTEGER;
		      	 c_response 					: INTEGER;
		       	 c_result_width 			: INTEGER; 
				 		 c_sel_i_dir 					: INTEGER;
				 		 c_system_clock_rate 	: REAL;
		       	 c_taps 							: INTEGER;
		      	 c_use_model_func 		: INTEGER; 
					 	 c_shape							: INTEGER;
						 c_enable_rlocs				: INTEGER;
		      	 c_zpf 								: INTEGER );
			   
		PORT ( 	reset : IN  std_logic;
		       	 	 nd : IN  std_logic;
							din : IN  std_logic_vector( (c_data_width - 1) DOWNTO 0 );
		      		clk : IN  std_logic;
		     	   dout : OUT std_logic_vector( (c_result_width - 1) DOWNTO 0 );
		   		 dout_i : OUT std_logic_vector( (c_data_width - 1)   DOWNTO 0);
		   		 dout_q : OUT std_logic_vector( (c_result_width - 1) DOWNTO 0 ); 
							rfd : OUT std_logic;
		      		rdy : OUT std_logic;
		  		coef_ld : IN  std_logic;
		   	 	 ld_din : IN  std_logic_vector( (c_coef_width - 1) DOWNTO 0);
		    	  ld_we : IN  std_logic;
		   		  sel_i : OUT std_logic_vector( (bitsneededtorepresent(c_channels - 1) - 1) DOWNTO 0);
		    	  sel_o : OUT std_logic_vector( (bitsneededtorepresent(c_channels - 1) - 1) DOWNTO 0) );
			 
	END COMPONENT;

END mac_fir_v2_0_comp;
