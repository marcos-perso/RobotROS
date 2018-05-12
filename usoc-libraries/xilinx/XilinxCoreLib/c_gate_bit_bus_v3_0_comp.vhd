-- $Id: c_gate_bit_bus_v3_0_comp.vhd,v 1.1 2010-07-10 21:42:44 mmartinez Exp $
--
-- Filename - c_gate_bit_bus_v3_0_comp.vhd
-- Author - Xilinx
-- Creation - 3 Mar 1999
--
-- Description - This file contains the component declaration for
--				 the C_GATE_BIT_BUS_V3_0 core

Library IEEE;
Use IEEE.std_logic_1164.all;

Library XilinxCoreLib;
Use XilinxCoreLib.prims_constants_v3_0.all;

package c_gate_bit_bus_v3_0_comp is

	
component C_GATE_BIT_BUS_V3_0
	generic(
			 C_GATE_TYPE 		: integer := c_and; 
			 C_WIDTH 			: integer := 16;
			 C_INPUT_INV_MASK 	: string  := ""; 
			 C_AINIT_VAL 		: string  := ""; 		
			 C_SINIT_VAL 		: string  := ""; 		
			 C_SYNC_PRIORITY 	: integer := c_clear; 	
			 C_SYNC_ENABLE 		: integer := c_override;
			 C_HAS_O 			: integer := 0;
			 C_HAS_Q 			: integer := 1;
			 C_HAS_CE 			: integer := 0;
			 C_HAS_ACLR 		: integer := 0;
			 C_HAS_ASET 		: integer := 0;
			 C_HAS_AINIT 		: integer := 0;
			 C_HAS_SCLR 		: integer := 0;
			 C_HAS_SSET 		: integer := 0;
			 C_HAS_SINIT 		: integer := 0;
			 C_ENABLE_RLOCS 	: integer := 1
			);

    port (I : in std_logic_vector(C_WIDTH-1 downto 0) := (others => '0'); -- Input vector
		  CTRL : in std_logic := '0'; -- Control input
		  CLK : in std_logic := '0'; -- Clock
		  CE : in std_logic := '1'; -- Clock Enable
		  ACLR : in std_logic := '0'; -- Asynch init.
		  ASET : in std_logic := '0'; -- Asynch set.
		  AINIT : in std_logic := '0'; -- Asynch init.
		  SCLR : in std_logic := '0'; -- Synch init.
		  SSET : in std_logic := '0'; -- Synch set.		  
		  SINIT : in std_logic := '0'; -- Synch init.
		  O : out std_logic_vector(C_WIDTH-1 downto 0); -- Asynch output
		  Q : out std_logic_vector(C_WIDTH-1 downto 0) -- Registered output value
		  );
end component;

end c_gate_bit_bus_v3_0_comp;
