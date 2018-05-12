--
--  File: dither_v3_1.vhd
--  created by Design Wizard: 02/22/01 15:21:50
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;

entity dither_v4_0 is
	generic (
		hasAInit 	: integer := 0;
		hasCe 		: integer := 0;
		hasSInit 	: integer := 0;
		lfsrALength : integer := 13;
		lfsrBLength : integer := 14;
		lfsrCLength : integer := 15;
		lfsrDLength : integer := 16;
		pipelined	: integer := 1
		);
	port (
		AINIT	: in STD_LOGIC;
		CE		: in STD_LOGIC;
		CLK		: in STD_LOGIC;
		DITHER	: out INTEGER := 0;
		SINIT	: in STD_LOGIC
		);
end dither_v4_0;

--}} End of automatically maintained section

architecture rtl of dither_v4_0 is 
	signal aInitInt : std_logic := '0';
	signal sInitInt : std_logic := '0';
	signal ceInt	: std_logic := '1';
	-- NCSIM FIX
	constant aZeros : std_logic_vector(lfsrALength-2 downto 0) := (others=>'0');
	constant bZeros : std_logic_vector(lfsrBLength-2 downto 0) := (others=>'0');
	constant cZeros : std_logic_vector(lfsrCLength-2 downto 0) := (others=>'0');
	constant dZeros : std_logic_vector(lfsrDLength-2 downto 0) := (others=>'0');
	--signal lfsrA 	: std_logic_vector(lfsrALength-1 downto 0) := ('1', others=>'0');
	--signal lfsrB 	: std_logic_vector(lfsrBLength-1 downto 0) := ('1', others=>'0');
	--signal lfsrC 	: std_logic_vector(lfsrCLength-1 downto 0) := ('1', others=>'0'); 
	--signal lfsrD 	: std_logic_vector(lfsrDLength-1 downto 0) := ('1', others=>'0');
	signal lfsrA 	: std_logic_vector(lfsrALength-1 downto 0) := '1' & aZeros; 
	signal lfsrB 	: std_logic_vector(lfsrBLength-1 downto 0) := '1' & bZeros; 
	signal lfsrC 	: std_logic_vector(lfsrCLength-1 downto 0) := '1' & cZeros; 
	signal lfsrD 	: std_logic_vector(lfsrDLength-1 downto 0) := '1' & dZeros; 
	signal ditherMinusOne : integer := 0;
begin 
	
	aInitAssign1 : if hasAInit = 1 generate
		aInitInt <= AINIT;
	end generate; 
	
	aInitAssign0 : if hasAInit = 0 generate
		aInitInt <= '0';
	end generate;
	
	sInitAssign1 : if hasSInit = 1 generate
		sInitInt <= SINIT;
	end generate; 
	
	sInitAssign0 : if hasSInit = 0 generate
		sInitInt <= '0';
	end generate; 
	
	ceAssign1 : if hasCe = 1 generate
		ceInt <= CE;
	end generate;
	
	ceAssign0 : if hasCe = 0 generate
		ceInt <= '1';
	end generate;
	
	createLfsrs: process(CLK, aInitInt, sInitInt, ceInt)
	begin
		if aInitInt='1' then
			-- NCSIM FIX
			--lfsrA <= ('1', others=>'0'); 
			--lfsrB <= ('1', others=>'0');
			--lfsrC <= ('1', others=>'0');
			--lfsrD <= ('1', others=>'0');
			lfsrA(lfsrALength-2 downto 0) <= aZeros;
			lfsrA(lfsrA'high) <= '1';
			lfsrB(lfsrBLength-2 downto 0) <= bZeros;
			lfsrB(lfsrB'high) <= '1';
			lfsrC(lfsrCLength-2 downto 0) <= cZeros;
			lfsrC(lfsrC'high) <= '1';
			lfsrD(lfsrDLength-2 downto 0) <= dZeros;
			lfsrD(lfsrD'high) <= '1';
		elsif CLK'EVENT and CLK='1' then
			if sInitInt='1' then
				-- NCSIM FIX
				--lfsrA <= ('1', others=>'0');
				--lfsrB <= ('1', others=>'0');
				--lfsrC <= ('1', others=>'0');
				--lfsrD <= ('1', others=>'0');
				lfsrA(lfsrALength-2 downto 0) <= aZeros;
				lfsrA(lfsrA'high) <= '1';
				lfsrB(lfsrBLength-2 downto 0) <= bZeros;
				lfsrB(lfsrB'high) <= '1';
				lfsrC(lfsrCLength-2 downto 0) <= cZeros;
				lfsrC(lfsrC'high) <= '1';
				lfsrD(lfsrDLength-2 downto 0) <= dZeros;
				lfsrD(lfsrD'high) <= '1';
			elsif ceInt='1' then
				lfsrA(0) <= lfsrA(0) xor lfsrA(2) xor lfsrA(3) xor lfsrA(12);
				lfsrA(12 downto 1) <= lfsrA(11 downto 0);
				lfsrB(0) <= lfsrB(0) xor lfsrB(5) xor lfsrB(9) xor lfsrB(13);
				lfsrB(13 downto 1) <= lfsrB(12 downto 0);
				lfsrC(0) <= lfsrC(0) xor lfsrC(14);
				lfsrC(14 downto 1) <= lfsrC(13 downto 0);
				lfsrD(0) <= lfsrD(0) xor lfsrD(2) xor lfsrD(11) xor lfsrD(15);
				lfsrD(15 downto 1) <= lfsrD(14 downto 0);
			end if;
		end if;
	end process;
	
	addEm: process(CLK, aInitInt, sInitInt, ceInt, lfsrA, lfsrB, lfsrC, lfsrD)
	begin
		if pipelined = 1 then
			if aInitInt='1' then
				DITHER <= 0;
				ditherMinusOne <= 0;
			elsif CLK'EVENT and CLK='1' then
				if sInitInt='1' then
					DITHER <= 0;
					ditherMinusOne <= 0;
				elsif ceInt='1' then
					ditherMinusOne <= conv_integer(lfsrA(lfsrALength-1 downto lfsrALength-8)) +	 
					conv_integer(lfsrB(lfsrBLength-1 downto lfsrBLength-8)) +
					conv_integer(lfsrC(lfsrCLength-1 downto lfsrCLength-8)) +
					conv_integer(lfsrD(lfsrDLength-1 downto lfsrDLength-8));
					DITHER <= ditherMinusOne;
				end if;
			end if;	
		else
			DITHER <= conv_integer(lfsrA(lfsrALength-1 downto lfsrALength-8)) +	 
			conv_integer(lfsrB(lfsrBLength-1 downto lfsrBLength-8)) +
			conv_integer(lfsrC(lfsrCLength-1 downto lfsrCLength-8)) +
			conv_integer(lfsrD(lfsrDLength-1 downto lfsrDLength-8));
		end if;
	end process;
	
end rtl;
