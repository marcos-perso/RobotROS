-- $Id: c_mux_slice_buft_v4_0_comp.vhd,v 1.1 2010-07-10 21:42:51 mmartinez Exp $
--
-- Filename - c_mux_slice_buft_v4_0_comp.vhd
-- Author - Xilinx
-- Creation - 3 Mar 1999
--
-- Description - This file contains the component declaration for
--				 the C_MUX_SLICE_BUFT_V4_0 core

Library IEEE;
Use IEEE.std_logic_1164.all;

package c_mux_slice_buft_v4_0_comp is

----- Component C_MUX_SLICE_BUFT_V4_0 -----
-- Short Description
--
-- Wide Tristate buffer
--
component C_MUX_SLICE_BUFT_V4_0
	generic(
			 C_WIDTH 		: integer := 16
			 ); 
			 
    port (I 	: in std_logic_vector(C_WIDTH-1 downto 0) := (others => '0'); -- Input vector
		  T 	: in std_logic := '0'; -- Output/Tristate ('0'/'1')
		  O 	: out std_logic_vector(C_WIDTH-1 downto 0) -- Registered output value
		  );
end component;

end c_mux_slice_buft_v4_0_comp;
