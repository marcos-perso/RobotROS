--
-- file C:\My_Designs\dds_v4_0\compile\dither_add_v4_0.vhd
-- generated Tue Aug 14 14:08:45 2001
-- from C:\My_Designs\dds_v4_0\src\dither_add_v4_0.bde
-- by BDE2VHDL generator version 1.10
--
---- Packages and use clauses defined by user on the diagram ----
library IEEE, XilinxCoreLib;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;
use XilinxCoreLib.c_reg_fd_v5_0_comp.all;
use XilinxCoreLib.c_addsub_v5_0_comp.all;
use XilinxCoreLib.dither_v4_0_comp.all;

-- standard libraries declarations
library XILINXCORELIB;
use XILINXCORELIB.prims_constants_v5_0.all;

entity dither_add_v4_0 is
  generic(
       ACCUM_WIDTH : integer   := 16;
       C_HAS_ACLR : integer   := 0;
       C_HAS_CE : integer   := 0;
       C_HAS_SCLR : integer   := 0;
       C_PIPELINED : integer  := 0;
       PHASE_WIDTH : integer   := 8
  );
  port(
       ACLR : in STD_LOGIC;
       CE : in STD_LOGIC;
       CLK : in STD_LOGIC;
       ND : in STD_LOGIC;
       SCLR : in STD_LOGIC;
       A : in STD_LOGIC_VECTOR(ACCUM_WIDTH-1 downto 0);
       RDY : out STD_LOGIC;
       DITHERED_PHASE : out STD_LOGIC_VECTOR(PHASE_WIDTH-1 downto 0)
  );
end dither_add_v4_0;

architecture structural of dither_add_v4_0 is

---- Signal declarations used on the diagram ----

signal addQ : STD_LOGIC_VECTOR (ACCUM_WIDTH-1 downto 0);
signal addS : STD_LOGIC_VECTOR (ACCUM_WIDTH-1 downto 0);
signal ditherInt : integer;
signal ditherRdy : STD_LOGIC_VECTOR (0 downto 0);
signal ditherVector : STD_LOGIC_VECTOR (9 downto 0);
signal ndDelay : STD_LOGIC_VECTOR (0 downto 0);
signal scaledDither : STD_LOGIC_VECTOR (ACCUM_WIDTH-PHASE_WIDTH downto 0);

---- Configuration specifications for declared components 

for U1 : dither_v4_0 use entity xilinxcorelib.dither_v4_0;
for U2 : C_REG_FD_V5_0 use entity xilinxcorelib.C_REG_FD_V5_0;
for U3 : C_ADDSUB_V5_0 use entity xilinxcorelib.C_ADDSUB_V5_0;

begin

---- User defined VHDL code ----

----- Statement0 ----
ndDelay1: if C_PIPELINED=1 generate
	RDY <= ndDelay(0);
end generate;
ndDelay0 : if C_PIPELINED=0 generate
	RDY <= ND;
end generate;
ditherRdy(0) <= ND;
----- Statement1 ----
ditherVector <= conv_std_logic_vector(ditherInt, 10);
process (ditherVector)
	variable index : integer;
	variable i : integer := 0;
begin
	index :=  ACCUM_WIDTH-PHASE_WIDTH;
	scaledDither <= (others=>'0');
	for i in 9 downto 0 loop
		if index >= 0 then
			scaledDither(index) <= ditherVector(i);
			index := index-1;
		end if;
	end loop;
end process;
----- Statement2 ----
addDelay1: if C_PIPELINED=1 generate
	DITHERED_PHASE <= addQ(ACCUM_WIDTH-1
		downto ACCUM_WIDTH-PHASE_WIDTH);
end generate;
addDelay0 : if C_PIPELINED=0 generate
	DITHERED_PHASE <= addS(ACCUM_WIDTH-1
		downto ACCUM_WIDTH-PHASE_WIDTH);
end generate;

----  Component instantiations  ----

U1 : dither_v4_0
  generic map (
       hasAInit => C_HAS_ACLR,
       hasCe => C_HAS_CE,
       hasSInit => C_HAS_SCLR,
       pipelined => C_PIPELINED
  )
  port map(
       AINIT => ACLR,
       CE => CE,
       CLK => CLK,
       DITHER => ditherInt,
       SINIT => SCLR
  );

U2 : C_REG_FD_V5_0
  generic map (
       C_HAS_ACLR => C_HAS_ACLR,
       C_HAS_CE => C_HAS_CE,
       C_HAS_SCLR => C_HAS_SCLR,
       C_WIDTH => 1
  )
  port map(
       ACLR => ACLR,
       CE => CE,
       CLK => CLK,
       D => ditherRdy( 0 downto 0 ),
       Q => ndDelay( 0 downto 0 ),
       SCLR => SCLR
  );

U3 : C_ADDSUB_V5_0
  generic map (
       C_A_WIDTH => ACCUM_WIDTH,
       C_B_TYPE => c_signed,
       C_B_WIDTH => ACCUM_WIDTH-PHASE_WIDTH+1,
       C_HAS_ACLR => C_HAS_ACLR,
       C_HAS_CE => C_HAS_CE,
       C_HAS_S => 1,
       C_HAS_SCLR => C_HAS_SCLR,
       C_HIGH_BIT => ACCUM_WIDTH-1,
       C_LATENCY => C_PIPELINED,
       C_LOW_BIT => 0,
       C_OUT_WIDTH => ACCUM_WIDTH
  )
  port map(
       A => A( ACCUM_WIDTH-1 downto 0 ),
       ACLR => ACLR,
       B => scaledDither( ACCUM_WIDTH-PHASE_WIDTH downto 0 ),
       CE => CE,
       CLK => CLK,
       Q => addQ( ACCUM_WIDTH-1 downto 0 ),
       S => addS( ACCUM_WIDTH-1 downto 0 ),
       SCLR => SCLR
  );


end structural;
