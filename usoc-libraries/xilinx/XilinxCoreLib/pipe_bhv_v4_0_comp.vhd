-- $Header: /local/Projects/CVS/P1/zpu_SoC/sources/xilinx/XilinxCoreLib/pipe_bhv_v4_0_comp.vhd,v 1.1 2010-07-10 21:43:18 mmartinez Exp $

library ieee;
use ieee.std_logic_1164.all;

package pipe_bhv_v4_0_comp is
	
	component pipe_bhv_v4_0
		generic (
			C_HAS_ACLR      : integer := 0;
			C_HAS_CE        : integer := 0;
			C_HAS_SCLR      : integer := 1;
			C_PIPE_STAGES   : integer := 2; 
			C_WIDTH         : integer := 16);		 
		port (
			D     : in  std_logic_vector(C_WIDTH-1 downto 0); -- Input value
			CLK   : in  std_logic := '0'; -- Clock
			CE    : in  std_logic := '1'; -- Clock Enable
			ACLR  : in  std_logic := '0'; -- Asynch clear.
			SCLR  : in  std_logic := '0'; -- Synch clear.
			Q     : out std_logic_vector(C_WIDTH-1 downto 0));
	end component;
	
end pipe_bhv_v4_0_comp;
