-- $Id: c_compare_v3_0_comp.vhd,v 1.1 2010-07-10 21:42:38 mmartinez Exp $
--
-- Filename - c_compare_v3_0_comp.vhd
-- Author - Xilinx
-- Creation - 9 Dec 1998
--
-- Description - This file contains the component declaration for
--				 the C_COMPARE_V3_0 core

Library IEEE;
Use IEEE.std_logic_1164.all;

Library XilinxCoreLib;
Use XilinxCoreLib.prims_constants_v3_0.all;

package c_compare_v3_0_comp is


----- Component C_COMPARE_V3_0 -----
-- Short Description
--
-- (A)Synchronous Comparator
--

component C_COMPARE_V3_0
	generic (C_WIDTH 		: integer := 16; 					
			 C_AINIT_VAL	: string := "";
			 C_DATA_TYPE 	: integer := c_unsigned;
			 C_B_CONSTANT 	: integer := 0; 					
			 C_B_VALUE 		: string := ""; 			
			 C_SYNC_ENABLE 	: integer := c_override; 		
			 C_SYNC_PRIORITY: integer := c_clear; 		
			 C_PIPE_STAGES 	: integer := 1;		
			 C_HAS_A_EQ_B 	: integer := 1;
			 C_HAS_A_NE_B 	: integer := 0;
			 C_HAS_A_LT_B 	: integer := 0;
			 C_HAS_A_GT_B 	: integer := 0;
			 C_HAS_A_LE_B 	: integer := 0;
			 C_HAS_A_GE_B 	: integer := 0;
			 C_HAS_QA_EQ_B 	: integer := 0;
			 C_HAS_QA_NE_B 	: integer := 0;
			 C_HAS_QA_LT_B 	: integer := 0;
			 C_HAS_QA_GT_B 	: integer := 0;
			 C_HAS_QA_LE_B 	: integer := 0;
			 C_HAS_QA_GE_B 	: integer := 0;
			 C_HAS_CE 		: integer := 0;
			 C_HAS_ACLR 	: integer := 0;
			 C_HAS_ASET 	: integer := 0;
			 C_HAS_SCLR 	: integer := 0;
			 C_HAS_SSET 	: integer := 0;
			 C_ENABLE_RLOCS : integer := 1
			 ); 

    port (A : in std_logic_vector(C_WIDTH-1 downto 0) := (others => '0'); -- Input value
		  B : in std_logic_vector(C_WIDTH-1 downto 0) := (others => '0'); -- Input value
		  CLK : in std_logic := '0'; -- Clock
		  CE : in std_logic := '1'; -- Clock Enable
		  ACLR : in std_logic := '0'; -- Asynch init.
		  ASET : in std_logic := '0'; -- Asynch set.
		  SCLR : in std_logic := '0'; -- Synch init.
		  SSET : in std_logic := '0'; -- Synch set.
		  A_EQ_B : out std_logic;	
		  A_NE_B : out std_logic;	
		  A_LT_B : out std_logic;	
		  A_GT_B : out std_logic;	
		  A_LE_B : out std_logic;	
		  A_GE_B : out std_logic;	
		  QA_EQ_B : out std_logic;	
		  QA_NE_B : out std_logic;	
		  QA_LT_B : out std_logic;	
		  QA_GT_B : out std_logic;	
		  QA_LE_B : out std_logic;	
		  QA_GE_B : out std_logic	
		 ); 
end component;

end c_compare_v3_0_comp;
