--$Id: dds_round_v4_1_comp.vhd,v 1.1 2010-07-10 21:43:02 mmartinez Exp $

library ieee;
use ieee.std_logic_1164.all;

package dds_round_v4_1_comp is
	
	component dds_round_v4_1
		generic(
			C_HAS_CE : integer  := 0;
			C_INPUT_WIDTH : integer := 18;
			C_OUTPUT_WIDTH : integer := 35
			);
		port(
			ce : in STD_LOGIC;
			clk : in STD_LOGIC;
			din : in STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 downto 0);
			round : out STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 downto 0)
			);
	end component;
	
end dds_round_v4_1_comp;
