-- $Header: /local/Projects/CVS/P1/zpu_SoC/sources/xilinx/XilinxCoreLib/c_dds_v4_0_comp.vhd,v 1.1 2010-07-10 21:42:42 mmartinez Exp $

library ieee;
use ieee.std_logic_1164.all;

--library	XilinxCoreLib;
--use XilinxCoreLib.dds_v2_0_pack.all;

package dds_v4_0_comp is
	
	component C_DDS_V4_0
		generic(
			C_ACCUMULATOR_LATENCY : integer     := 1; --ONE_CYCLE;
			C_ACCUMULATOR_WIDTH : integer       := 16;
			C_DATA_WIDTH : integer          := 16;
			C_ENABLE_RLOCS : integer  := 0;
			C_HAS_ACLR : integer    := 0;
			C_HAS_CE : integer   := 0;
			C_HAS_RDY : integer  := 1;
			C_HAS_RFD : integer  := 0;
			C_HAS_SCLR : integer    := 0;
			C_LATENCY : integer  := 0;
			C_MEM_TYPE : integer   := 0; --DIST_ROM;
			C_NEGATIVE_COSINE : integer    := 0;
			C_NEGATIVE_SINE : integer  := 0;
			C_NOISE_SHAPING : integer := 0;
			C_OUTPUTS_REQUIRED : integer    := 2; --SINE_AND_COSINE;
			C_OUTPUT_WIDTH : integer     := 16;
			C_PHASE_ANGLE_WIDTH : integer     := 4;
			C_PHASE_INCREMENT : integer        := 1; --REG;
			C_PHASE_INCREMENT_VALUE : string      := "0";
			C_PHASE_OFFSET : integer      := 2; --CONST;
			C_PHASE_OFFSET_VALUE : string        := "0";
			C_PIPELINED : integer     := 1
			);
		port(
			a : in STD_LOGIC := '0';
			aclr : in STD_LOGIC := '0';
			ce : in STD_LOGIC := '0';
			clk : in STD_LOGIC;
			sclr : in STD_LOGIC := '0';
			we : in STD_LOGIC := '0';
			data : in STD_LOGIC_VECTOR (C_DATA_WIDTH-1 downto 0)
			:= (others=>'0');
			rdy : out STD_LOGIC;
			rfd : out STD_LOGIC;
			cosine : out STD_LOGIC_VECTOR (C_OUTPUT_WIDTH-1 downto 0);
			sine : out STD_LOGIC_VECTOR (C_OUTPUT_WIDTH-1 downto 0)
			);
	end component;
	
end dds_v4_0_comp;
