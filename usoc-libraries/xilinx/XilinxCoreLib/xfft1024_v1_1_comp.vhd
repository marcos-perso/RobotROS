-- Copyright(C) 2002 by Xilinx, Inc. All rights reserved.
-- This text contains proprietary, confidential
-- information of Xilinx, Inc., is distributed
-- under license from Xilinx, Inc., and may be used,
-- copied and/or disclosed only pursuant to the terms
-- of a valid license agreement with Xilinx, Inc. This copyright
-- notice must be retained as part of this text at all times.
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE xfft1024_v1_1_comp IS
component xfft1024_v1_1
	port (
		xn_re			: in std_logic_vector(15 downto 0);   
		xn_im			: in std_logic_vector(15 downto 0);   
		reset			: in std_logic;   
		start			: in std_logic;   
		mrd				: in std_logic;   
		n_fft			: in std_logic_vector(1 downto 0);   
		n_fft_we		: in std_logic;   
		fwd_inv			: in std_logic;   
		fwd_inv_we		: in std_logic;   
		scale_sch		: in std_logic_vector(9 downto 0);   
		scale_sch_we	: in std_logic;   
		clk				: in std_logic;   
		ce				: in std_logic;   
		xk_re			: out std_logic_vector(15 downto 0);   
		xk_im			: out std_logic_vector(15 downto 0);   
		xn_index		: out std_logic_vector(9 downto 0);   
		xk_index		: out std_logic_vector(9 downto 0);   
		rdy				: out std_logic;
		busy			: out std_logic;   
		edone			: out std_logic;   
		done			: out std_logic;   
		ovflo			: out std_logic);   
end component;

END xfft1024_v1_1_comp;
