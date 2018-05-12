--$Id: dither_add_v4_1_comp.vhd,v 1.1 2010-07-10 21:43:05 mmartinez Exp $

library ieee;
use ieee.std_logic_1164.all;

package dither_add_v4_1_comp is
	
component dither_add_v4_1
  generic(
       ACCUM_WIDTH : integer := 16;
       C_HAS_ACLR : integer := 0;
       C_HAS_CE : integer := 0;
       C_HAS_SCLR : integer := 0;
       C_PIPELINED : integer := 0;
       PHASE_WIDTH : integer := 8
  );
  port (
       A : in STD_LOGIC_VECTOR(ACCUM_WIDTH-1 downto 0);
       ACLR : in STD_LOGIC;
       CE : in STD_LOGIC;
       CLK : in STD_LOGIC;
       ND : in STD_LOGIC;
       SCLR : in STD_LOGIC;
       DITHERED_PHASE : out STD_LOGIC_VECTOR(PHASE_WIDTH-1 downto 0);
       RDY : out STD_LOGIC
  );
end component;
	
end dither_add_v4_1_comp;
