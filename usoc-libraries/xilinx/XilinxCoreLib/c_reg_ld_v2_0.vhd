-- $Id: c_reg_ld_v2_0.vhd,v 1.1 2010-07-10 21:42:53 mmartinez Exp $
--
-- Filename - c_reg_ld_v2_0.vhd
-- Author - Xilinx
-- Creation - 1 Oct 1998
--
-- Description - This file contains the behavior for the baseblocks C_REG_LD_V2_0 module

Library IEEE;
Use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

Library XilinxCoreLib;
Use XilinxCoreLib.prims_utils_v2_0.all;
use XilinxCoreLib.prims_constants_v2_0.all;


-- bwid bit wide Latch with asynchronous clear

entity C_REG_LD_V2_0 is
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
		  Q : out std_logic_vector(C_WIDTH-1 downto 0)); -- Output value

end C_REG_LD_V2_0;

architecture behavioral of C_REG_LD_V2_0 is

	constant timeunit : time := 1 ns;

	signal intQ : std_logic_vector(C_WIDTH-1 downto 0) := (others => 'X');
	-- signals for optional pins...
	signal intGE : std_logic;
	signal intACLR : std_logic;
	signal intASET : std_logic;
	signal intAINIT : std_logic;
	signal intSCLR : std_logic;
	signal intSSET : std_logic;
	signal intSINIT : std_logic;
	signal AIV : std_logic_vector(C_WIDTH-1 downto 0) := str_to_slv_0(C_AINIT_VAL, C_WIDTH);
	signal SIV : std_logic_vector(C_WIDTH-1 downto 0) := str_to_slv_0(C_SINIT_VAL, C_WIDTH);

begin
	-- Deal with optional pins...
	ge1: if C_HAS_GE = 1 generate
		ge1_1 : if ((C_HAS_SCLR = 1) or (C_HAS_SSET = 1) or (C_HAS_SINIT = 1))
					and (C_HAS_GE = 1) and (C_SYNC_ENABLE = c_override) generate
				intGE <= GE or intSCLR or intSSET or intSINIT;
		end generate; 
		ge1simple : if (C_HAS_GE = 1) and not(((C_HAS_SCLR = 1) or (C_HAS_SSET = 1) or (C_HAS_SINIT = 1))
					and (C_SYNC_ENABLE = c_override)) generate
			intGE <= GE;
		end generate;
	end generate;
	ge0: if not (C_HAS_GE = 1) generate
		intGE <= '1';
	end generate;
	
	aclr1: if C_HAS_ACLR = 1 generate
		intACLR <= ACLR;
	end generate;
	aclr0: if not (C_HAS_ACLR = 1) generate
		intACLR <= '0';
	end generate;
	
	aset1: if C_HAS_ASET = 1 generate
		intASET <= ASET;
	end generate;
	aset0: if not (C_HAS_ASET = 1) generate
		intASET <= '0';
	end generate;
	
	ainit1: if C_HAS_AINIT = 1 generate
		intAINIT <= AINIT;
	end generate;
	ainit0: if not (C_HAS_AINIT = 1) generate
		intAINIT <= '0';
	end generate;
	
	sclr1: if C_HAS_SCLR = 1 generate
		intSCLR <= SCLR;
	end generate;
	sclr0: if not (C_HAS_SCLR = 1) generate
		intSCLR <= '0';
	end generate;
	
	sset1: if C_HAS_SSET = 1 generate
		intSSET <= SSET;
	end generate;
	sset0: if not (C_HAS_SSET = 1) generate
		intSSET <= '0';
	end generate;
	
	sinit1: if C_HAS_SINIT = 1 generate
		intSINIT <= SINIT;
	end generate;
	sinit0: if not (C_HAS_SINIT = 1) generate
		intSINIT <= '0';
	end generate;
	
	
	p1 : process(G, intGE, intACLR, intASET, intAINIT, intSCLR, intSSET, intSINIT, D)
		variable FIRST : boolean := TRUE;
		variable ASYNC_CTRL : boolean := FALSE;
		variable ACTIVE_G : std_logic;
		variable SET_OR_CLR : std_logic := '0';
		variable intQtmp : std_logic_vector(C_WIDTH-1 downto 0);
	begin
		

		if FIRST then
			-- Define power-up value
			if C_HAS_ACLR = 1 then
				intQ <= (others => '0');
			elsif C_HAS_ASET = 1 then
				intQ <= (others => '1');
			elsif C_HAS_AINIT = 1 then
				intQ <= AIV;
--			elsif (C_HAS_SCLR = 1) then
--				intQ <= (others => '0');
--			elsif (C_HAS_SSET = 1) then
--				intQ <= (others => '1');
--			elsif (C_HAS_SINIT = 1) then
--				intQ <= SIV;
			else
				intQ <= AIV;
			end if;
						
			if C_SYNC_PRIORITY = 0 then -- SSET takes priority
				if C_HAS_SSET = 1 then
					SET_OR_CLR := '0'; -- use SSET
				elsif C_HAS_SCLR = 1 then
					SET_OR_CLR := '1'; -- Use SCLR since there IS no SSET pin
				end if;
			else -- c_clear
				if C_HAS_SCLR = 1 then
					SET_OR_CLR := '1'; -- use SCLR
				elsif C_HAS_SSET = 1 then
					SET_OR_CLR := '0'; -- Use SSET since there IS no SCLR pin
				end if;
			end if;

			ACTIVE_G := '1';

			FIRST := FALSE;
			
		else -- not FIRST

			intQtmp := intQ;
			
			for i in 0 to C_WIDTH-1 loop
		
				if intACLR = '1' then -- asynch clear
					intQtmp(i) := '0';

				elsif intACLR = '0' and intASET = '1' then -- asynch set
					intQtmp(i) := '1';

				elsif intAINIT = '1' then -- Asynch init, aclr and aset = 0
					intQtmp(i) := AIV(i);
				
				elsif intACLR = 'X' and intASET /= '0' then -- Undefined!
					intQtmp(i) := 'X';

				elsif intACLR'event and intASET'event and intACLR'last_value = '1'
						and intASET'last_value = '1' and intACLR = '0' and intASET = '0' then -- RACE!
					intQtmp(i) := 'X';

				else
					ASYNC_CTRL := FALSE;
					
					if (G = '1') then -- Active level
						if ((intGE /= '0' or C_SYNC_ENABLE = 0) and (SET_OR_CLR = '0' and intSSET = 'X' and intSCLR /= '0')) then
							intQtmp(i) := 'X';
							ASYNC_CTRL := TRUE;
						end if;
						if ((intGE /= '0' or C_SYNC_ENABLE = 0) and (SET_OR_CLR = '1' and intSSET /= '0' and intSCLR = 'X')) then
							intQtmp(i) := 'X';
							ASYNC_CTRL := TRUE;
						end if;
						
						if (intGE = '1' and intSCLR /= '1' and intSSET /= '1' and intSINIT /= '1' and ASYNC_CTRL = FALSE) then -- Enabled
							intQtmp(i) := D(i);
						elsif (intGE = 'X' and intQtmp(i) /= D(i) and intSCLR /= '1' and intSSET /= '1' and intSINIT /= '1' and ASYNC_CTRL = FALSE) then -- possibly enabled
							intQtmp(i) := 'X';
						end if;
						if (intSINIT = '1' and (intGE = '1' or C_SYNC_ENABLE = 0) and ASYNC_CTRL = FALSE) then -- SINIT
							intQtmp(i) := SIV(i);
						elsif (intSINIT = '1' and (intGE = 'X' and C_SYNC_ENABLE = 1) and intQtmp(i) /= SIV(i)) then -- possible init
							intQtmp(i) := 'X';
						elsif (intSINIT = 'X' and (intGE /= '0' or C_SYNC_ENABLE = 0) and intQtmp(i) /= SIV(i)) then -- possible init
							intQtmp(i) := 'X';
						end if;
						if (intSCLR = '1' and (intGE = '1' or C_SYNC_ENABLE = 0) and (SET_OR_CLR = '1' or intSSET = '0') and ASYNC_CTRL = FALSE) then -- SCLR
							intQtmp(i) := '0';
						elsif (intSCLR = '1' and (intGE = 'X' and C_SYNC_ENABLE = 1) and intQtmp(i) /= '0' and (SET_OR_CLR = '1' or intSSET = '0')) then -- possible init
							intQtmp(i) := 'X';
						elsif (intSCLR = 'X' and (intGE /= '0' or C_SYNC_ENABLE = 0) and intQtmp(i) /= '0' and (SET_OR_CLR = '1' or intSSET = '0')) then -- possible init
							intQtmp(i) := 'X';
						end if;
						if (intSSET = '1' and (intGE = '1' or C_SYNC_ENABLE = 0) and (SET_OR_CLR = '0' or intSCLR = '0') and ASYNC_CTRL = FALSE) then -- SSET
							intQtmp(i) := '1';
						elsif (intSSET = '1' and (intGE = 'X' and C_SYNC_ENABLE = 1) and intQtmp(i) /= '1' and (SET_OR_CLR = '0' or intSCLR = '0')) then -- possible init
							intQtmp(i) := 'X';
						elsif (intSSET = 'X' and (intGE /= '0' or C_SYNC_ENABLE = 0) and intQtmp(i) /= '1' and (SET_OR_CLR = '0' or intSCLR = '0')) then -- possible init
							intQtmp(i) := 'X';
						end if;
					elsif (G = 'X') then -- possible rising edge
						if ((intGE /= '0' or C_SYNC_ENABLE = 0) and (SET_OR_CLR = '0' and intSSET = 'X' and intSCLR /= '0')) then
							intQtmp(i) := 'X';
						end if;
						if ((intGE /= '0' or C_SYNC_ENABLE = 0) and (SET_OR_CLR = '1' and intSSET /= '0' and intSCLR = 'X')) then
							intQtmp(i) := 'X';
						end if;
						
						if ((intGE /= '0' or (C_SYNC_ENABLE = 0 and (intSCLR /= '0' or intSSET /= '0' or intSINIT /= '0'))) and intSCLR /= '1' and intSSET /= '1' and intSINIT /= '1' and intQtmp(i) /= D(i)) then -- Enabled
							intQtmp(i) := 'X';
						end if;
						if (intSINIT /= '0' and (intGE /= '0' or C_SYNC_ENABLE = 0) and intQtmp(i) /= SIV(i)) then -- SINIT
							intQtmp(i) := 'X';
						end if;
						if (intSCLR /= '0' and (intGE /= '0' or C_SYNC_ENABLE = 0) and (SET_OR_CLR = '1' or intSSET = '0') and intQtmp(i) /= '0') then -- SCLR
							intQtmp(i) := 'X';
						end if;
						if (intSSET /= '0' and (intGE /= '0' or C_SYNC_ENABLE = 0) and (SET_OR_CLR = '0' or intSCLR = '0') and intQtmp(i) /= '1') then -- SSET
							intQtmp(i) := 'X';
						end if;
					end if; 
					if intACLR = '0' and intASET = 'X' then -- MAYBE asynch set
						if intQtmp(i) /= '1' then
							intQtmp(i) := 'X';
							ASYNC_CTRL := TRUE;
						end if;
				
					elsif intACLR = 'X' and intASET = '0' then -- MAYBE async clr
						if intQtmp(i) /= '0' then
							intQtmp(i) := 'X';
							ASYNC_CTRL := TRUE;
						end if;


					elsif intAINIT = 'X' then -- MAYBE async init					for i in 0 to C_WIDTH-1 loop
						if intQtmp(i) /= AIV(i) then
							intQtmp(i) := 'X';
							ASYNC_CTRL := TRUE;
						end if;
					end if;
				end if; 
			end loop;
			intQ <= intQtmp;

			end if; -- FIRST
						
	end process;

	Q <= intQ after timeunit;
	
end behavioral;
