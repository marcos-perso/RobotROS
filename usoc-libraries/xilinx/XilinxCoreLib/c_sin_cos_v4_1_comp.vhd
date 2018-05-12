-- $Header: /local/Projects/CVS/P1/zpu_SoC/sources/xilinx/XilinxCoreLib/c_sin_cos_v4_1_comp.vhd,v 1.1 2010-07-10 21:42:56 mmartinez Exp $

library ieee;
use ieee.std_logic_1164.all;

--library XilinxCoreLib;
--use XilinxCoreLib.sincos_v2_1_pack.all;

package c_sin_cos_v4_1_comp is
	
	component C_SIN_COS_V4_1
		generic (
			C_ENABLE_RLOCS : integer	:= 0;		 
			C_HAS_ACLR : integer 		:= 0;
			C_HAS_CE : integer		:= 0;		 
			C_HAS_CLK : integer 		:= 0;
			C_HAS_ND : integer 		:= 1;
			C_HAS_RFD : integer 		:= 1;
			C_HAS_RDY : integer 		:= 1;
			C_HAS_SCLR : integer 		:= 0;
			C_LATENCY : integer			:= 0;
			C_MEM_TYPE : integer 		:= 0; --DIST_ROM;
			C_NEGATIVE_COSINE : integer 	:= 0;
			C_NEGATIVE_SINE : integer 	:= 0;
			C_OUTPUTS_REQUIRED : integer 	:= 0; --SINE_ONLY;
			C_OUTPUT_WIDTH : integer	:= 16;
			C_PIPE_STAGES : integer 	:= 0;
			C_REG_INPUT : integer 		:= 0;
			C_REG_OUTPUT : integer 		:= 0;
			C_THETA_WIDTH : integer 	:= 4
			);
		port (
			theta : in std_logic_vector (C_THETA_WIDTH-1 downto 0);
			sine : out std_logic_vector (C_OUTPUT_WIDTH-1 downto 0);
			cosine : out std_logic_vector (C_OUTPUT_WIDTH-1 downto 0);
			nd : in std_logic := '0';
			rfd : out std_logic;
			rdy : out std_logic;	  
			clk : in std_logic := '0';
			ce : in std_logic := '1';
			aclr : in std_logic := '0';
			sclr : in std_logic := '0'     
			);
	end component;
	
end c_sin_cos_v4_1_comp;
