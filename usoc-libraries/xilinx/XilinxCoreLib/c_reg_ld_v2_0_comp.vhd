-- $Id: c_reg_ld_v2_0_comp.vhd,v 1.1 2010-07-10 21:42:53 mmartinez Exp $
--
-- Filename - c_reg_ld_v2_0_comp.vhd
-- Author - Xilinx
-- Creation - 1 Mar 1999
--
-- Description - This file contains the component declaration for
--				 the C_REG_LD_V2_0 core

Library IEEE;
Use IEEE.std_logic_1164.all;

Library XilinxCoreLib;
Use XilinxCoreLib.prims_constants_v2_0.all;

package c_reg_ld_v2_0_comp is

----- Component C_REG_LD_V2_0 -----
-- Short Description
--
-- Wide latch
--

component C_REG_LD_V2_0
	generic (C_WIDTH 		: integer := 16;
			 C_AINIT_VAL 	: string  := "";
			 C_SINIT_VAL 	: string  := "";
			 C_SYNC_PRIORITY: integer := c_clear; 	
			 C_SYNC_ENABLE 	: integer := c_override;
			 C_HAS_GE 		: integer := 0;
			 C_HAS_ACLR 	: integer := 0;
			 C_HAS_ASET 	: integer := 0;
			 C_HAS_AINIT 	: integer := 0;
			 C_HAS_SCLR 	: integer := 0;
			 C_HAS_SSET 	: integer := 0;
			 C_HAS_SINIT 	: integer := 0;
			 C_ENABLE_RLOCS : integer := 1
			); 

    port (D : in std_logic_vector(C_WIDTH-1 downto 0) := (others => '0'); -- Input value
		  G : in std_logic := '0'; -- Gate
		  GE : in std_logic := '1'; -- Gate Enable
		  ACLR : in std_logic := '0'; -- Asynch clear.
		  ASET : in std_logic := '0'; -- Asynch set.
		  AINIT : in std_logic := '0'; -- Asynch init.
		  SCLR : in std_logic := '0'; -- Synch clear.
		  SSET : in std_logic := '0'; -- Synch set.
		  SINIT : in std_logic := '0'; -- Synch init.
		  Q : out std_logic_vector(C_WIDTH-1 downto 0) -- Output value
		  );
end component;

end c_reg_ld_v2_0_comp;
