--$Id: c_eff_v4_1_comp.vhd,v 1.1 2010-07-10 21:42:44 mmartinez Exp $

library ieee;
use ieee.std_logic_1164.all;

package c_eff_v4_1_comp is
	
component c_eff_v4_1
  generic(
       C_ACCUM_WIDTH : integer  := 8;
       C_CONST_WIDTH : integer     := 17;
       C_HAS_ACLR : integer   := 0;
       C_HAS_CE : integer  := 0;
       C_HAS_SCLR : integer     := 0; 
	   C_INPUT_WIDTH : integer := 18;
       C_LOOKUP_LATENCY : integer  := 0;
       C_NOISE_SHAPING : integer  := 2; --EFF;
       C_OUTPUT_WIDTH : integer  := 8;
       C_PHASE_WIDTH : integer  := 6;
       C_PIPELINED : integer   := 1
  );
  port(
       ACLR : in STD_LOGIC;
       CE : in STD_LOGIC;
       CLK : in STD_LOGIC;
       ND : in STD_LOGIC;
       SCLR : in STD_LOGIC;
       ACCUMULATOR : in STD_LOGIC_VECTOR(C_ACCUM_WIDTH-1 downto 0);
       COS_IN : in STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 downto 0);
       SIN_IN : in STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 downto 0);
       RDY : out STD_LOGIC;
       COS : out STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 downto 0);
       SIN : out STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 downto 0)
  );
end component;
	
end c_eff_v4_1_comp;
