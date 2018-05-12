--------------------------------------------------------------------------
-- $Id: vfft32_v3_0_comp.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
--------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE vfft32_v3_0_comp IS

COMPONENT vfft32_v3_0
	GENERIC (butterfly_precision	: INTEGER:=16;
		phase_factor_precision	: INTEGER:=16;
		scaling_schedule_mem1: STRING := "scaling_schedule_mem1.mif";
		scaling_schedule_mem2 : STRING := "scaling_schedule_mem2.mif";
		memory_architecture : INTEGER := 3;
		data_memory : STRING := "distributed_mem";
		mult_type:	INTEGER := 1); --0 selects lutmult, 1 selects dedicated v2 mult
	PORT (clk		: IN STD_LOGIC;
		ce 		: IN STD_LOGIC;
		reset		: IN STD_LOGIC;
		start		: IN STD_LOGIC;
		fwd_inv		: IN STD_LOGIC;
		mrd		: IN STD_LOGIC;
		mwr		: IN STD_LOGIC;
		xn_re		: IN STD_LOGIC_VECTOR(butterfly_precision-1 DOWNTO 0);
		xn_im		: IN STD_LOGIC_VECTOR(butterfly_precision-1 DOWNTO 0);
		ovflo		: OUT STD_LOGIC;
		done		: OUT STD_LOGIC;
		edone		: OUT STD_LOGIC;
		io		: OUT STD_LOGIC;
		eio		: OUT STD_LOGIC;
		busy		: OUT STD_LOGIC;
		xk_re	: OUT STD_LOGIC_VECTOR(butterfly_precision-1 DOWNTO 0); 
		xk_im	: OUT STD_LOGIC_VECTOR(butterfly_precision-1 DOWNTO 0));

END COMPONENT;

-- The following tells XST that the vfft32_v3_0 is a black box which 
-- should be generated command given by the value of this attribute
-- Note the fully qualified SIM (JAVA class) name that forms the 
-- basis of the core
attribute box_type: string;
attribute box_type of  vfft32_v3_0: component is "black_box";
attribute GENERATOR_DEFAULT: string;
attribute GENERATOR_DEFAULT of vfft32_v3_0: component is 
	  "generatecore com.xilinx.ip.vfft32_v3_0.vfft32_v3_0";

END vfft32_v3_0_comp;
