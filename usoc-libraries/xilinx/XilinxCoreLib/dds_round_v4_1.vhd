--
-- file C:\My_Designs\C_DDS_V4_1\compile\dds_round_v4_1.vhd
-- generated Thu Jan 31 16:40:45 2002
-- from C:\My_Designs\C_DDS_V4_1\src\dds_round_v4_1.bde
-- by BDE2VHDL generator version 1.10
--
---- Packages and use clauses defined by user on the diagram ----
--$Id: dds_round_v4_1.vhd,v 1.1 2010-07-10 21:43:02 mmartinez Exp $
library IEEE;
use IEEE.std_logic_1164.all;
library XilinxCoreLib;
use XilinxCoreLib.C_ADDSUB_V5_0_COMP.all;
use XilinxCoreLib.C_TWOS_COMP_V5_0_COMP.all;
use XilinxCoreLib.prims_constants_v5_0.all;

-- standard libraries declarations
library XILINXCORELIB;
use XILINXCORELIB.prims_constants_v5_0.all;

entity dds_round_v4_1 is
  generic(
       C_HAS_CE : integer := 0;
       C_INPUT_WIDTH : integer  := 35;
       C_OUTPUT_WIDTH : integer   := 18
  );
  port(
       ce : in STD_LOGIC;
       clk : in STD_LOGIC;
       DIN : in STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 downto 0);
       round : out STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 downto 0)
  );
end dds_round_v4_1;

architecture structural of dds_round_v4_1 is

---- Signal declarations used on the diagram ----

signal outputTwosCompOut : STD_LOGIC_VECTOR (C_OUTPUT_WIDTH downto 0);
signal roundAdderOut : STD_LOGIC_VECTOR (C_OUTPUT_WIDTH-1 downto 0);
signal twosCompOut : STD_LOGIC_VECTOR (C_INPUT_WIDTH downto 0);

---- Configuration specifications for declared components 

for ROUNDING_ADDER : C_ADDSUB_V5_0 use entity xilinxcorelib.C_ADDSUB_V5_0;
for INPUT_TWOS_COMP : C_TWOS_COMP_V5_0 use entity xilinxcorelib.C_TWOS_COMP_V5_0;
for OUTPUT_TWOS_COMP : C_TWOS_COMP_V5_0 use entity xilinxcorelib.C_TWOS_COMP_V5_0;

begin

---- User defined VHDL code ----

----- Statement0 ----
round <= outputTwosCompOut(C_OUTPUT_WIDTH-1 downto 0);

----  Component instantiations  ----

INPUT_TWOS_COMP : C_TWOS_COMP_V5_0
  generic map (
       C_HAS_ACLR => 0,
       C_HAS_AINIT => 0,
       C_HAS_ASET => 0,
       C_HAS_BYPASS => 0,
       C_HAS_CE => 0,
       C_HAS_Q => 0,
       C_HAS_S => 1,
       C_HAS_SCLR => 0,
       C_HAS_SINIT => 0,
       C_HAS_SSET => 0,
       C_PIPE_STAGES => 0,
       C_WIDTH => C_INPUT_WIDTH
  )
  port map(
       A => DIN( C_INPUT_WIDTH-1 downto 0 ),
       S => twosCompOut( C_INPUT_WIDTH downto 0 )
  );

OUTPUT_TWOS_COMP : C_TWOS_COMP_V5_0
  generic map (
       C_HAS_ACLR => 0,
       C_HAS_AINIT => 0,
       C_HAS_ASET => 0,
       C_HAS_BYPASS => 0,
       C_HAS_CE => C_HAS_CE,
       C_HAS_Q => 1,
       C_HAS_S => 0,
       C_HAS_SCLR => 0,
       C_HAS_SINIT => 0,
       C_HAS_SSET => 0,
       C_PIPE_STAGES => 0,
       C_WIDTH => C_OUTPUT_WIDTH
  )
  port map(
       A => roundAdderOut( C_OUTPUT_WIDTH-1 downto 0 ),
       CE => ce,
       CLK => clk,
       Q => outputTwosCompOut( C_OUTPUT_WIDTH downto 0 )
  );

ROUNDING_ADDER : C_ADDSUB_V5_0
  generic map (
       C_A_TYPE => c_signed,
       C_A_WIDTH => C_OUTPUT_WIDTH,
       C_B_CONSTANT => 0,
       C_B_VALUE => "0000",
       C_B_WIDTH => 1,
       C_HAS_BYPASS => 0,
       C_HAS_B_IN => 0,
       C_HAS_CE => 0,
       C_HAS_C_IN => 0,
       C_HAS_OVFL => 0,
       C_HAS_Q => 0,
       C_HAS_Q_OVFL => 0,
       C_HAS_S => 1,
       C_HIGH_BIT => C_OUTPUT_WIDTH-1,
       C_LOW_BIT => 0,
       C_OUT_WIDTH => C_OUTPUT_WIDTH
  )
  port map(
       A => twosCompOut( C_INPUT_WIDTH-1 downto C_INPUT_WIDTH-C_OUTPUT_WIDTH ),
       B => twosCompOut( C_INPUT_WIDTH-1-C_OUTPUT_WIDTH downto C_INPUT_WIDTH-1-C_OUTPUT_WIDTH ),
       S => roundAdderOut( C_OUTPUT_WIDTH-1 downto 0 )
  );


end structural;
