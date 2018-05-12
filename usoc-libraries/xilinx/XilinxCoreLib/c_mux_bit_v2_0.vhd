-- $Id: c_mux_bit_v2_0.vhd,v 1.1 2010-07-10 21:42:47 mmartinez Exp $
--
-- Filename - c_mux_bit_v2_0.vhd
-- Author - Xilinx
-- Creation - 9 Oct 1998
--
-- Description - This file contains the behavior for the baseblocks C_MUX_BIT_V2_0 module

Library IEEE;
Use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

Library XilinxCoreLib;
Use XilinxCoreLib.prims_utils_v2_0.all;
use XilinxCoreLib.prims_constants_v2_0.all;
Use XilinxCoreLib.c_reg_fd_v2_0_comp.all;

-- n to 1 mux

entity C_MUX_BIT_V2_0 is
	generic (C_INPUTS 		: integer := 2;
			 C_SEL_WIDTH 	: integer := 1;
			 C_PIPE_STAGES 	: integer := 0;
			 C_AINIT_VAL 	: string  := "";
			 C_SINIT_VAL 	: string  := "";
			 C_SYNC_ENABLE 	: integer := c_override;
			 C_SYNC_PRIORITY: integer := c_clear;
			 C_HAS_O 		: integer := 1;
			 C_HAS_Q 		: integer := 0;
			 C_HAS_CE 		: integer := 0;
			 C_HAS_ACLR 	: integer := 0;
			 C_HAS_ASET 	: integer := 0;
			 C_HAS_AINIT 	: integer := 0;
			 C_HAS_SCLR 	: integer := 0;
			 C_HAS_SSET 	: integer := 0;
			 C_HAS_SINIT 	: integer := 0;
			 C_ENABLE_RLOCS : integer := 1
			); 

    port (M 	: in std_logic_vector(C_INPUTS-1 downto 0) := (others => '0'); -- Input vector
		  S 	: in std_logic_vector(C_SEL_WIDTH-1 downto 0) := (others => '0'); -- Select pin
		  CLK 	: in std_logic := '0'; -- Optional clock
		  CE 	: in std_logic := '1';  -- Optional Clock enable
		  AINIT : in std_logic := '0'; -- optional asynch reset to init_val
		  ASET 	: in std_logic := '0'; -- optional asynch set to '1'
		  ACLR 	: in std_logic := '0'; -- optional asynch clear to '0'
		  SINIT : in std_logic := '0'; -- Optional synch reset to init_val
		  SSET 	: in std_logic := '0'; -- optional synch set to '1'
		  SCLR 	: in std_logic := '0'; -- optional synch set to '0'
		  O 	: out std_logic; -- Output value
		  Q 	: out std_logic); -- Registered output value

end C_MUX_BIT_V2_0;

architecture behavioral of C_MUX_BIT_V2_0 is

	constant timeunit : time := 1 ns;

	signal intO : std_logic := 'X';
	signal intQ : std_logic := 'X';
	constant n_sel : integer := C_SEL_WIDTH;
	signal intCE : std_logic;
	
	-- pipelining signal
	signal intQpipeend : std_logic;
	signal intQpipe : std_logic_vector(C_PIPE_STAGES+2 downto 0) := (others => '0');

begin
		
	ce1: if C_HAS_CE = 1 generate
		intCE <= CE;
	end generate;
	ce0: if not (C_HAS_CE = 1) generate
		intCE <= '1';
	end generate;
		
	p1 : process(M,S)
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
	
	-- Check that this is a valid sel value!!
		if k > C_INPUTS then
			intO <= 'X' after timeunit;
		elsif is_X(S) then
			intO <= 'X' after timeunit;
		else		
	-- Select the k'th input word for output
        	intO <= M(k-1) after timeunit;
		end if;		
		
	end process;
	
	g1: if C_HAS_Q = 1 generate -- Need a register on the output
--	begin
		opreg : c_reg_fd_v2_0 generic map(C_WIDTH => 1,
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
							port map(D(0) => intQpipeend,
									 CLK => CLK,
									 CE => CE,
									 ACLR => ACLR,
									 SCLR => SCLR,
									 ASET => ASET,
									 SSET => SSET,
									 AINIT => AINIT,
									 SINIT => SINIT,
									 Q(0) => intQ);
									 
	end generate;
	
	pipeq : process (CLK)
	begin
		
		if intCE = '1' and CLK = '1' and CLK'last_value /= 'X' and C_PIPE_STAGES > 1 then
			pipeloop : for p in 2 to C_PIPE_STAGES-1 loop
				intQpipe(p) <= intQpipe(p+1);
			end loop; -- pipeloop
			intQpipe(C_PIPE_STAGES) <= intO;
		elsif (intCE = 'X' or (CLK = 'X' and CLK'last_value = '0') or (CLK = '1' and CLK'last_value = 'X')) and C_PIPE_STAGES > 1 then
			pipeloopx : for p in 2 to C_PIPE_STAGES-1 loop
				if intQpipe(p) /= intQpipe(p+1) then
					intQpipe(p) <= 'X';
				end if;
			end loop; -- pipeloopx
			if intQpipe(C_PIPE_STAGES) /= intO then
				intQpipe(C_PIPE_STAGES) <= 'X';	
			end if;		
		end if;
		
	end process; -- pipeq
	ps1 : if C_PIPE_STAGES < 2 generate
		intQpipeend <= intO;
	end generate;
	ps1b : if C_PIPE_STAGES > 1 generate
		intQpipeend <= intQpipe(2);
	end generate;
	
	q1 : if C_HAS_Q = 1 generate
		Q <= intQ;
	end generate;
	q0 : if not (C_HAS_Q = 1) generate
		Q <= 'X';
	end generate;
		
	o0: if not (C_HAS_O = 1) generate
		O <= 'X';
	end generate;
	o1: if C_HAS_O = 1 generate
		O <= intO;
	end generate;
	
end behavioral;
