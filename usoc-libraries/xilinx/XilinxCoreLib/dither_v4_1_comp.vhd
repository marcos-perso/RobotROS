--$Id: dither_v4_1_comp.vhd,v 1.1 2010-07-10 21:43:06 mmartinez Exp $

library ieee;
use ieee.std_logic_1164.all;

package dither_v4_1_comp is
	
component dither_v4_1
  generic(
       hasAInit : INTEGER := 0;
       hasCe : INTEGER := 0;
       hasSInit : INTEGER := 0;
       lfsrALength : INTEGER := 13;
       lfsrBLength : INTEGER := 14;
       lfsrCLength : INTEGER := 15;
       lfsrDLength : INTEGER := 16;
       pipelined : INTEGER := 1
  );
  port (
       AINIT : in STD_LOGIC;
       CE : in STD_LOGIC;
       CLK : in STD_LOGIC;
       SINIT : in STD_LOGIC;
       DITHER : out INTEGER := 0
  );
end component;
	
end dither_v4_1_comp;
