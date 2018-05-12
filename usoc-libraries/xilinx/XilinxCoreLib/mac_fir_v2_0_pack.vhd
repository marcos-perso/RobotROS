-- Copyright(C) 2002 by Xilinx, Inc. All rights reserved.
-- This text contains proprietary, confidential
-- information of Xilinx, Inc., is distributed
-- under license from Xilinx, Inc., and may be used,
-- copied and/or disclosed only pursuant to the terms
-- of a valid license agreement with Xilinx, Inc. This copyright
-- notice must be retained as part of this text at all times.
--
-- $Id: mac_fir_v2_0_pack.vhd,v 1.1 2010-07-10 21:43:13 mmartinez Exp $ This package contains constants used by the behavioral model files
PACKAGE mac_fir_v2_0_pack IS
	
	-- Values for boolean type of paramters
	CONSTANT c_true		: integer := 1;
	CONSTANT c_false	: integer := 0;
	
	-- Values for c_data_type/c_coeff_type
	CONSTANT c_signed    : integer := 0;
	CONSTANT c_unsigned  : integer := 1;
	CONSTANT c_antipodal : integer := 2;
	
	-- Vaules for c_response
	CONSTANT c_symmetric 	 		: integer := 0;
	CONSTANT c_non_symmetric 	: integer := 1;
	CONSTANT c_neg_symmetric 	: integer := 2;
	
	-- Values for c_filter_type 
	CONSTANT c_single_rate 		 					: integer := 0;
	CONSTANT c_polyphase_interpolating 	: integer := 1;
	CONSTANT c_polyphase_decimating 		: integer := 2;
	CONSTANT c_hilbert_transform 				: integer := 3;
	CONSTANT c_interpolated		 					: integer := 4;
	CONSTANT c_half_band 								: integer := 5;
	CONSTANT c_decimating_half_band  		: integer := 6;
	CONSTANT c_interpolating_half_band 	: integer := 7;
	
	-- Values for c_reload
	CONSTANT c_no_reload : integer := 0;
	CONSTANT c_static    : integer := 1;
	
	-- Values for SEL_I port direction 
	CONSTANT c_sel_input_port_is_input  : integer := 1; 
	CONSTANT c_sel_input_port_is_output : integer := 0;	 	
	
END mac_fir_v2_0_pack;
