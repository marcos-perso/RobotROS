-- $Id: c_mux_bus_v2_0.vhd,v 1.1 2010-07-10 21:42:49 mmartinez Exp $
--
-- Filename - c_mux_bus_v2_0.vhd
-- Author - Xilinx
-- Creation - 4 Feb 1999
--
-- Description - This file contains the behavior for the baseblocks C_MUX_BUS_V2_0 module

Library IEEE;
Use IEEE.std_logic_1164.all;

Library XilinxCoreLib;
Use XilinxCoreLib.prims_utils_v2_0.all;
use XilinxCoreLib.prims_constants_v2_0.all;
Use XilinxCoreLib.c_reg_fd_v2_0_comp.all;

-- n*m to 1*m mux

entity C_MUX_BUS_V2_0 is
	generic(
			 C_WIDTH 		: integer := 16;
			 C_INPUTS 		: integer := 2;
			 C_MUX_TYPE		: integer := c_lut_based;
			 C_SEL_WIDTH 	: integer := 1;
			 C_AINIT_VAL 	: string  := "";
			 C_SINIT_VAL 	: string  := "";
			 C_SYNC_PRIORITY: integer := c_clear;
			 C_SYNC_ENABLE 	: integer := c_override;
			 C_HAS_O 		: integer := 0;
			 C_HAS_Q 		: integer := 1;
			 C_HAS_CE 		: integer := 1;
			 C_HAS_EN 		: integer := 1;
			 C_HAS_ACLR 	: integer := 0;
			 C_HAS_ASET 	: integer := 0;
			 C_HAS_AINIT 	: integer := 0;
			 C_HAS_SCLR 	: integer := 0;
			 C_HAS_SSET 	: integer := 0;
			 C_HAS_SINIT 	: integer := 0;
			 C_ENABLE_RLOCS : integer := 1
			 ); 
			 
    port (MA 	: in std_logic_vector(C_WIDTH-1 downto 0) := (others => '0'); -- Input vector
		  MB 	: in std_logic_vector(C_WIDTH-1 downto 0) := (others => '0'); -- Input vector
		  MC 	: in std_logic_vector(C_WIDTH-1 downto 0) := (others => '0'); -- Input vector
		  MD 	: in std_logic_vector(C_WIDTH-1 downto 0) := (others => '0'); -- Input vector
		  ME 	: in std_logic_vector(C_WIDTH-1 downto 0) := (others => '0'); -- Input vector
		  MF 	: in std_logic_vector(C_WIDTH-1 downto 0) := (others => '0'); -- Input vector
		  MG 	: in std_logic_vector(C_WIDTH-1 downto 0) := (others => '0'); -- Input vector
		  MH	: in std_logic_vector(C_WIDTH-1 downto 0) := (others => '0'); -- Input vector
		  S 	: in std_logic_vector(C_SEL_WIDTH-1 downto 0) := (others => '0'); -- Select pin
		  CLK 	: in std_logic := '0'; -- Optional clock
		  CE 	: in std_logic := '1';  -- Optional Clock enable
		  EN 	: in std_logic := '0';  -- Optional BUFT enable
		  ASET 	: in std_logic := '0'; -- optional asynch set to '1'
		  ACLR 	: in std_logic := '0'; -- Asynch init.
		  AINIT : in std_logic := '0'; -- optional asynch reset to init_val
		  SSET 	: in std_logic := '0'; -- optional synch set to '1'
		  SCLR 	: in std_logic := '0'; -- Synch init.
		  SINIT : in std_logic := '0'; -- Optional synch reset to init_val
		  O 	: out std_logic_vector(C_WIDTH-1 downto 0); -- Output value
		  Q 	: out std_logic_vector(C_WIDTH-1 downto 0)); -- Registered output value

end C_MUX_BUS_V2_0;

architecture behavioral of C_MUX_BUS_V2_0 is

	constant timeunit : time := 1 ns;

	signal intO : std_logic_vector(C_WIDTH-1 downto 0) := (others => 'X');
	signal intQ : std_logic_vector(C_WIDTH-1 downto 0) := (others => 'X');
	constant n_sel : integer := C_SEL_WIDTH;
	-- signals for optional pins...
	signal intEN : std_logic;
	
	signal intMA, intMB, intMC, intMD, intME, intMF, intMG, intMH : std_logic_vector(C_WIDTH-1 downto 0);
begin
	
	-- Deal with optional pins...
	ci8: if C_INPUTS = 8 generate
		intMA <= MA;
		intMB <= MB;
		intMC <= MC;
		intMD <= MD;
		intME <= ME;
		intMF <= MF;
		intMG <= MG;
		intMH <= MH;
	end generate;
	ci7: if C_INPUTS = 7 generate
		intMA <= MA;
		intMB <= MB;
		intMC <= MC;
		intMD <= MD;
		intME <= ME;
		intMF <= MF;
		intMG <= MG;
		intMH <= (others => 'X');
	end generate;
	ci6: if C_INPUTS = 6 generate
		intMA <= MA;
		intMB <= MB;
		intMC <= MC;
		intMD <= MD;
		intME <= ME;
		intMF <= MF;
		intMG <= (others => 'X');
		intMH <= (others => 'X');
	end generate;
	ci5: if C_INPUTS = 5 generate
		intMA <= MA;
		intMB <= MB;
		intMC <= MC;
		intMD <= MD;
		intME <= ME;
		intMF <= (others => 'X');
		intMG <= (others => 'X');
		intMH <= (others => 'X');
	end generate;
	ci4: if C_INPUTS = 4 generate
		intMA <= MA;
		intMB <= MB;
		intMC <= MC;
		intMD <= MD;
		intME <= (others => 'X');
		intMF <= (others => 'X');
		intMG <= (others => 'X');
		intMH <= (others => 'X');
	end generate;
	ci3: if C_INPUTS = 3 generate
		intMA <= MA;
		intMB <= MB;
		intMC <= MC;
		intMD <= (others => 'X');
		intME <= (others => 'X');
		intMF <= (others => 'X');
		intMG <= (others => 'X');
		intMH <= (others => 'X');
	end generate;
	ci2: if C_INPUTS = 2 generate
		intMA <= MA;
		intMB <= MB;
		intMC <= (others => 'X');
		intMD <= (others => 'X');
		intME <= (others => 'X');
		intMF <= (others => 'X');
		intMG <= (others => 'X');
		intMH <= (others => 'X');
	end generate;
	
	en1: if C_HAS_EN = 1 generate
		intEN <= EN;
	end generate;
	en0: if not (C_HAS_EN = 1) generate
		intEN <= '1';
	end generate;
	
	
	p1 : process(intMA, intMB, intMC, intMD, intME, intMF, intMG, intMH ,intEN, S)
		variable k : integer := 1;
		variable j : integer := 1;
	begin
        k := 1;
        j := 1;
	
		for i in 0 to n_sel-1 loop
			if(S(i) = '1') then
				k := k + j;
			end if;
			
			j := j * 2;
		end loop;
	
	-- Check that this is a valid sel value and enable is not active!!
		if intEN = '0' then
			intO <= (others => 'Z') after timeunit;
		elsif intEN = 'X' then
			intO <= (others => 'X') after timeunit;			
		elsif k > C_INPUTS then
			intO <= (others => 'X') after timeunit;
		elsif is_X(S) then
			intO <= (others => 'X') after timeunit;
		else		
	-- Select the k'th input word for output
			if k = 1 then 
        		intO <= intMA after timeunit;
			elsif k = 2 then
				intO <= intMB after timeunit;
			elsif k = 3 then
				intO <= intMC after timeunit;
			elsif k = 4 then
				intO <= intMD after timeunit;
			elsif k = 5 then
				intO <= intME after timeunit;
			elsif k = 6 then
				intO <= intMF after timeunit;
			elsif k = 7 then
				intO <= intMG after timeunit;
			elsif k = 8 then
				intO <= intMH after timeunit;
			else	-- Invalid sel value!
				intO <= (others => 'X') after timeunit;
			end if;	
		end if;		
		
	end process;
	
	g1: if C_HAS_Q = 1 generate -- Need a register on the output
--	begin
		opreg : c_reg_fd_v2_0 generic map(C_WIDTH => C_WIDTH,
									 C_AINIT_VAL => C_AINIT_VAL,
									 C_SINIT_VAL => C_SINIT_VAL,
									 C_SYNC_PRIORITY => C_SYNC_PRIORITY,
							    	 C_SYNC_ENABLE => C_SYNC_ENABLE,
									 C_HAS_CE => C_HAS_CE,
									 C_HAS_ACLR => C_HAS_ACLR,
									 C_HAS_ASET => C_HAS_ASET,
									 C_HAS_AINIT => C_HAS_AINIT,
									 C_HAS_SCLR => C_HAS_SCLR,
									 C_HAS_SSET => C_HAS_SSET,
									 C_HAS_SINIT => C_HAS_SINIT,
									 C_ENABLE_RLOCS => C_ENABLE_RLOCS)
							port map(D => intO,
									 CLK => CLK,
									 CE => CE,
									 ACLR => ACLR,
									 SCLR => SCLR,
									 ASET => ASET,
									 SSET => SSET,
									 AINIT => AINIT,
									 SINIT => SINIT,
									 Q => intQ);
									 
	end generate;
	
	q1 : if C_HAS_Q = 1 generate
		Q <= intQ;
	end generate;
	q0 : if not (C_HAS_Q = 1) generate
		Q <= (others => 'X');
	end generate;
		
	o0: if not (C_HAS_O = 1) generate
		O <= (others => 'X');
	end generate;
	o1: if C_HAS_O = 1 generate
		O <= intO;
	end generate;
	
end behavioral;
