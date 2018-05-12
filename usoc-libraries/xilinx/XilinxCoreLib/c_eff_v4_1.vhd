---------------------------------------------------------------------------------------------------
--
-- Title       : c_eff_v4_1
-- Design      : C_DDS_V4_1
-- Author      : Xilinx
-- Company     : Xilinx, Inc.
--
---------------------------------------------------------------------------------------------------
--
-- File        : C:\My_Designs\C_DDS_V4_1\compile\c_eff_v4_1.vhd
-- Generated   : Sun Mar  3 20:05:13 2002
-- From        : C:\My_Designs\C_DDS_V4_1\src\c_eff_v4_1.bde
-- By          : Bde2Vhdl ver. 2.01
--
---------------------------------------------------------------------------------------------------
--
-- Description : 
--
---------------------------------------------------------------------------------------------------
-- Design unit header --
--$Id: c_eff_v4_1.vhd,v 1.1 2010-07-10 21:42:44 mmartinez Exp $
library IEEE;
use IEEE.std_logic_1164.all;
library XilinxCoreLib;
use XilinxCoreLib.C_SHIFT_RAM_V5_0_COMP.all;
use XilinxCoreLib.c_dds_v4_1_pack.all;
use XilinxCoreLib.prims_constants_v5_0.all;
use XilinxCoreLib.C_ADDSUB_V5_0_COMP.all;
use XilinxCoreLib.mult_gen_v5_0_comp.all;
use XilinxCoreLib.mult_const_pkg_v5_0.all;
use XilinxCoreLib.C_REG_FD_V5_0_COMP.all;
use XilinxCoreLib.mult_pkg_v5_0.all;
use XilinxCoreLib.dds_round_v4_1_comp.all;
use XilinxCoreLib.C_SHIFT_FD_V5_0_COMP.all;

-- standard libraries declarations
library XILINXCORELIB;
use XILINXCORELIB.prims_constants_v5_0.all;

entity C_EFF_V4_1 is
  generic(
       C_ACCUM_WIDTH:integer:=32; 
       C_CONST_WIDTH:integer:=16; 
       C_HAS_ACLR:integer:=0; 
       C_HAS_CE:integer:=0; 
       C_HAS_SCLR:integer:=0; 
       C_INPUT_WIDTH : integer := 18; 
       C_LOOKUP_LATENCY:integer:=0; 
       C_NOISE_SHAPING:integer:=EFF; 
       C_OUTPUT_WIDTH:integer:=18; 
       C_PHASE_WIDTH:integer:=12; 
       C_PIPELINED:integer:=1 
  );
  port(
       ACLR : in STD_LOGIC;
       CE : in STD_LOGIC;
       CLK : in STD_LOGIC;
       ND : in STD_LOGIC;
       SCLR : in STD_LOGIC;
       ACCUMULATOR : in STD_LOGIC_VECTOR(C_ACCUM_WIDTH-1 downto 0);
       COS_IN : in STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 downto 0);
       SIN_IN : in STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 downto 0);
       RDY : out STD_LOGIC;
       COS : out STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 downto 0);
       SIN : out STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 downto 0)
  );
end C_EFF_V4_1;

architecture C_EFF_V4_1 of C_EFF_V4_1 is

---- Architecture declarations -----
constant errorWidth : integer := C_ACCUM_WIDTH-C_PHASE_WIDTH;


---- Signal declarations used on the diagram ----

signal ceDelay : STD_LOGIC;
signal ceInt : STD_LOGIC;
signal cosOvfl : STD_LOGIC;
signal gnd : STD_LOGIC;
signal sinOvfl : STD_LOGIC;
signal accumInt : STD_LOGIC_VECTOR (19 downto 4);
signal constZeroPadding : STD_LOGIC_VECTOR (C_CONST_WIDTH-1 downto 0);
signal const_in : STD_LOGIC_VECTOR (15 downto 0);
signal const_mult : STD_LOGIC_VECTOR (16 downto 0);
signal cosAddIn : STD_LOGIC_VECTOR (COS_IN'length+constZeroPadding'length-1 downto 0);
signal cosAddOut : STD_LOGIC_VECTOR (cosAddIn'length-1 downto 0);
signal cosDelayed : STD_LOGIC_VECTOR (C_INPUT_WIDTH-1 downto 0);
signal cosRegOut : STD_LOGIC_VECTOR (C_OUTPUT_WIDTH-1 downto 0);
signal cosRound : STD_LOGIC_VECTOR (C_OUTPUT_WIDTH-1 downto 0);
signal cosSaturate : STD_LOGIC_VECTOR (cosAddOut'length-1 downto 0);
signal cos_mult_o : STD_LOGIC_VECTOR (SIN_IN'length + C_CONST_WIDTH-1 downto 0);
signal cos_mult_out : STD_LOGIC_VECTOR (cos_mult_o'length-1 downto 0);
signal cos_mult_q : STD_LOGIC_VECTOR (SIN_IN'length + C_CONST_WIDTH-1 downto 0);
signal errorToRad : STD_LOGIC_VECTOR (C_CONST_WIDTH-1 downto 0);
signal outRegCe : STD_LOGIC_VECTOR (0 downto 0);
signal rdyBus : STD_LOGIC_VECTOR (0 downto 0);
signal sinAddIn : STD_LOGIC_VECTOR (SIN_IN'length+constZeroPadding'length-1 downto 0);
signal sinAddOut : STD_LOGIC_VECTOR (sinAddIn'length-1 downto 0);
signal sinDelayed : STD_LOGIC_VECTOR (C_INPUT_WIDTH-1 downto 0);
signal sinRegOut : STD_LOGIC_VECTOR (C_OUTPUT_WIDTH-1 downto 0);
signal sinRound : STD_LOGIC_VECTOR (C_OUTPUT_WIDTH-1 downto 0);
signal sinSaturate : STD_LOGIC_VECTOR (sinAddOut'length-1 downto 0);
signal sin_mult_o : STD_LOGIC_VECTOR (COS_IN'length + C_CONST_WIDTH-1 downto 0);
signal sin_mult_out : STD_LOGIC_VECTOR (sin_mult_o'length-1 downto 0);
signal sin_mult_q : STD_LOGIC_VECTOR (COS_IN'length + C_CONST_WIDTH-1 downto 0);

---- Configuration specifications for declared components 

for COS_PIPE_BALANCE : C_SHIFT_RAM_V5_0 use entity xilinxcorelib.C_SHIFT_RAM_V5_0;
for COS_ROUND : dds_round_v4_1 use entity xilinxcorelib.dds_round_v4_1;
for SIN_PIPE_BALANCE : C_SHIFT_RAM_V5_0 use entity xilinxcorelib.C_SHIFT_RAM_V5_0;
for SIN_ROUND : dds_round_v4_1 use entity xilinxcorelib.dds_round_v4_1;
for ce_delay : C_SHIFT_FD_V5_0 use entity xilinxcorelib.C_SHIFT_FD_V5_0;
for constant_mult : mult_gen_v5_0 use entity xilinxcorelib.mult_gen_v5_0;
for cos_add : C_ADDSUB_V5_0 use entity xilinxcorelib.C_ADDSUB_V5_0;
for cos_mult : mult_gen_v5_0 use entity xilinxcorelib.mult_gen_v5_0;
for cos_reg : C_REG_FD_V5_0 use entity xilinxcorelib.C_REG_FD_V5_0;
for error_delay : C_SHIFT_RAM_V5_0 use entity xilinxcorelib.C_SHIFT_RAM_V5_0;
for rdyReg : C_REG_FD_V5_0 use entity xilinxcorelib.C_REG_FD_V5_0;
for sin_add : C_ADDSUB_V5_0 use entity xilinxcorelib.C_ADDSUB_V5_0;
for sin_mult : mult_gen_v5_0 use entity xilinxcorelib.mult_gen_v5_0;
for sin_reg : C_REG_FD_V5_0 use entity xilinxcorelib.C_REG_FD_V5_0;

begin

---- User Signal Assignments ----
cosAddIn(cosAddIn'high downto cosAddIn'high -cosDelayed'high)<= cosDelayed;
cosAddIn(constZeroPadding'high downto 0) <= constZeroPadding;
sinAddIn(sinAddIn'high downto sinAddIn'high-sinDelayed'high) <= sinDelayed;
sinAddIn(constZeroPadding'high downto 0) <= constZeroPadding;
pipedMult0 : if C_PIPELINED = 0 generate
	cos_mult_out <= cos_mult_o;
	sin_mult_out <= sin_mult_o;
end generate;
pipedMult1 : if C_PIPELINED = 1 generate
	cos_mult_out <= cos_mult_q;
	sin_mult_out <= sin_mult_q;
end generate;
output0 : if C_NOISE_SHAPING /= EFF generate
	SIN <= SIN_IN;
	COS <= COS_IN;
end generate;
output1 : if C_NOISE_SHAPING = EFF  generate
	output1a : if C_PIPELINED  = 1 generate
		SIN <= sinRegOut;
		COS <= cosRegOut;
	end generate;
	output1b : if  C_PIPELINED  = 0 generate
		SIN <= sinSaturate;
		COS <= cosSaturate;
	end generate;
end generate;
constZeroPadding <= (others=>'0');
const_in <= "0000000001100101";
eff1 : if C_NOISE_SHAPING = EFF generate
	accumInt <= ACCUMULATOR(19 downto 4);
end generate;
sinSat : process(sinOvfl , sinAddOut, ceInt, CLK)
	begin
		if CLK'event and CLK='1' and ceInt='1' then
			if sinOvfl = '1' then
				if sinAddOut(sinAddOut'high) = '0' then
					-- NCSIM FIX
					--sinSaturate <= ('1', others=>'0');
					sinSaturate(sinSaturate'high-1 downto 0) <= (others=>'0');
					sinSaturate(sinSaturate'high) <= '1';
				-- NCSIM FIX
				--else sinSaturate <= ('0', others=>'1');
				else
					sinSaturate(sinSaturate'high-1 downto 0) <= (others=>'1');
					sinSaturate(sinSaturate'high) <= '0';
				end if;
			else sinSaturate <= sinAddOut;
			end if;
		end if;
end process;
cosSat : process(cosOvfl , cosAddOut, ceInt, CLK)
	begin
		if CLK'event and CLK='1' and ceInt='1' then
			if cosOvfl = '1' then
				if cosAddOut(cosAddOut'high) = '0' then
					-- NCSIM FIX
					--cosSaturate <= ('1', others=>'0');
					cosSaturate(cosSaturate'high-1 downto 0) <= (others=>'0');
					cosSaturate(cosSaturate'high) <= '1';
				-- NCSIM FIX
				--else cosSaturate <= ('0', others=>'1');
				else
					cosSaturate(cosSaturate'high-1 downto 0) <= (others=>'1');
					cosSaturate(cosSaturate'high) <= '0';
				end if;
			else cosSaturate <= cosAddOut;
			end if;
		end if;
end process;
gatedCe : process(CE, ceDelay)
begin
	if C_HAS_CE = 1 then
		outRegCe(0) <= CE and ceDelay;
	else outRegCe(0) <= ceDelay;
	end if;
end process;
rdy0 : if C_PIPELINED = 0  or C_NOISE_SHAPING /= EFF generate
	RDY <= ND;
end generate;
rdy1 : if C_PIPELINED = 1 and C_NOISE_SHAPING = EFF generate
	RDY <= rdyBus(0);
end generate;
ceInt0 : if C_HAS_CE=0 generate
	ceInt <= '1';
end generate;
ceInt1 : if C_HAS_CE=1 generate
	ceInt <= CE;
end generate;

----  Component instantiations  ----

COS_PIPE_BALANCE : C_SHIFT_RAM_V5_0
  generic map (
       C_DEPTH => 2,
       C_GENERATE_MIF => 0,
       C_HAS_A => 0,
       C_HAS_ACLR => 0,
       C_HAS_AINIT => 0,
       C_HAS_ASET => 0,
       C_HAS_CE => C_HAS_CE,
       C_HAS_SCLR => 0,
       C_HAS_SINIT => 0,
       C_HAS_SSET => 0,
       C_READ_MIF => 0,
       C_REG_LAST_BIT => 0,
       C_SHIFT_TYPE => c_fixed,
       C_WIDTH => COS_IN'length
  )
  port map(
       ACLR => ACLR,
       CE => CE,
       CLK => CLK,
       D => COS_IN( C_INPUT_WIDTH-1 downto 0 ),
       Q => cosDelayed( C_INPUT_WIDTH-1 downto 0 ),
       SCLR => SCLR
  );

COS_ROUND : dds_round_v4_1
  generic map (
       C_HAS_CE => C_HAS_CE,
       C_INPUT_WIDTH => cosSaturate'length,
       C_OUTPUT_WIDTH => C_OUTPUT_WIDTH
  )
  port map(
       DIN => cosSaturate( cosAddOut'length-1 downto 0 ),
       ce => ce,
       clk => clk,
       round => cosRound( C_OUTPUT_WIDTH-1 downto 0 )
  );

SIN_PIPE_BALANCE : C_SHIFT_RAM_V5_0
  generic map (
       C_DEPTH => 2,
       C_GENERATE_MIF => 0,
       C_HAS_A => 0,
       C_HAS_ACLR => 0,
       C_HAS_AINIT => 0,
       C_HAS_ASET => 0,
       C_HAS_CE => C_HAS_CE,
       C_HAS_SCLR => 0,
       C_HAS_SINIT => 0,
       C_HAS_SSET => 0,
       C_READ_MIF => 0,
       C_REG_LAST_BIT => 0,
       C_SHIFT_TYPE => c_fixed,
       C_WIDTH => SIN_IN'length
  )
  port map(
       ACLR => ACLR,
       CE => CE,
       CLK => CLK,
       D => SIN_IN( C_INPUT_WIDTH-1 downto 0 ),
       Q => sinDelayed( C_INPUT_WIDTH-1 downto 0 ),
       SCLR => SCLR
  );

SIN_ROUND : dds_round_v4_1
  generic map (
       C_HAS_CE => C_HAS_CE,
       C_INPUT_WIDTH => sinSaturate'length,
       C_OUTPUT_WIDTH => C_OUTPUT_WIDTH
  )
  port map(
       DIN => sinSaturate( sinAddOut'length-1 downto 0 ),
       ce => ce,
       clk => clk,
       round => sinRound( C_OUTPUT_WIDTH-1 downto 0 )
  );

ce_delay : C_SHIFT_FD_V5_0
  generic map (
       C_FILL_DATA => c_sdin,
       C_HAS_ACLR => C_HAS_ACLR,
       C_HAS_CE => C_HAS_CE,
       C_HAS_D => 0,
       C_HAS_Q => 0,
       C_HAS_SCLR => C_HAS_SCLR,
       C_HAS_SDIN => 1,
       C_HAS_SDOUT => 1,
       C_WIDTH => 5
  )
  port map(
       ACLR => ACLR,
       CE => CE,
       CLK => CLK,
       SCLR => SCLR,
       SDIN => ND,
       SDOUT => ceDelay
  );

constant_mult : mult_gen_v5_0
  generic map (
       c_a_type => c_unsigned,
       c_a_width => 16,
       c_b_constant => 0,
       c_b_type => c_unsigned,
       c_b_width => const_in'length,
       c_baat => 16,
       c_has_a_signed => 0,
       c_has_aclr => 0,
       c_has_b => 0,
       c_has_ce => C_HAS_CE,
       c_has_load_done => 0,
       c_has_loadb => 0,
       c_has_nd => 0,
       c_has_o => 1,
       c_has_q => 0,
       c_has_rdy => 0,
       c_has_rfd => 0,
       c_has_sclr => 0,
       c_has_swapb => 0,
       c_mult_type => v2_parallel,
       c_out_width => 17,
       c_output_hold => 0,
       c_pipeline => 0,
       c_reg_a_b_inputs => 0,
       c_use_luts => 0
  )
  port map(
       a => accumInt( 19 downto 4 ),
       a_signed => gnd,
       aclr => gnd,
       b => const_in( 15 downto 0 ),
       ce => ce,
       clk => clk,
       loadb => gnd,
       nd => gnd,
       o => const_mult( 16 downto 0 ),
       sclr => gnd,
       swapb => gnd
  );

cos_add : C_ADDSUB_V5_0
  generic map (
       C_ADD_MODE => c_add,
       C_A_TYPE => c_signed,
       C_A_WIDTH => cosAddIn'length,
       C_BYPASS_LOW => 0,
       C_B_CONSTANT => 0,
       C_B_TYPE => c_signed,
       C_B_WIDTH => cos_mult_out'length,
       C_HAS_ACLR => 0,
       C_HAS_ADD => 0,
       C_HAS_AINIT => 0,
       C_HAS_ASET => 0,
       C_HAS_A_SIGNED => 0,
       C_HAS_BYPASS => 0,
       C_HAS_BYPASS_WITH_CIN => 0,
       C_HAS_B_IN => 0,
       C_HAS_B_OUT => 0,
       C_HAS_B_SIGNED => 0,
       C_HAS_CE => C_HAS_CE,
       C_HAS_C_IN => 0,
       C_HAS_C_OUT => 0,
       C_HAS_OVFL => 0,
       C_HAS_Q => 1,
       C_HAS_Q_B_OUT => 0,
       C_HAS_Q_C_OUT => 0,
       C_HAS_Q_OVFL => 1,
       C_HAS_S => 0,
       C_HAS_SCLR => 0,
       C_HAS_SINIT => 0,
       C_HAS_SSET => 0,
       C_HIGH_BIT => cosAddIn'length-1,
       C_LATENCY => 0,
       C_LOW_BIT => 0,
       C_OUT_WIDTH => cosAddIn'length,
       C_PIPE_STAGES => 0
  )
  port map(
       A => cosAddIn( COS_IN'length+constZeroPadding'length-1 downto 0 ),
       ACLR => ACLR,
       B => cos_mult_out( cos_mult_o'length-1 downto 0 ),
       CE => CE,
       CLK => CLK,
       Q => cosAddOut( cosAddIn'length-1 downto 0 ),
       Q_OVFL => cosOvfl,
       SCLR => SCLR
  );

cos_mult : mult_gen_v5_0
  generic map (
       c_a_type => c_signed,
       c_a_width => SIN_IN'length,
       c_b_constant => 0,
       c_b_type => c_unsigned,
       c_b_value => "0",
       c_b_width => errorToRad'length,
       c_baat => SIN_IN'length,
       c_has_a_signed => 0,
       c_has_aclr => 0,
       c_has_b => 0,
       c_has_ce => C_HAS_CE,
       c_has_load_done => 0,
       c_has_loadb => 0,
       c_has_nd => 0,
       c_has_o => 1,
       c_has_q => 1,
       c_has_rdy => 0,
       c_has_rfd => 0,
       c_has_sclr => 0,
       c_has_swapb => 0,
       c_mult_type => V2_PARALLEL,
       c_out_width => cos_mult_o'length,
       c_output_hold => 0,
       c_pipeline => C_PIPELINED,
       c_reg_a_b_inputs => 0
  )
  port map(
       a => SIN_IN( C_INPUT_WIDTH-1 downto 0 ),
       a_signed => gnd,
       aclr => gnd,
       b => errorToRad( C_CONST_WIDTH-1 downto 0 ),
       ce => ce,
       clk => clk,
       loadb => gnd,
       nd => gnd,
       o => cos_mult_o( SIN_IN'length + C_CONST_WIDTH-1 downto 0 ),
       q => cos_mult_q( SIN_IN'length + C_CONST_WIDTH-1 downto 0 ),
       sclr => gnd,
       swapb => gnd
  );

cos_reg : C_REG_FD_V5_0
  generic map (
       C_HAS_ACLR => C_HAS_ACLR,
       C_HAS_AINIT => 0,
       C_HAS_ASET => 0,
       C_HAS_CE => 1,
       C_HAS_SCLR => C_HAS_SCLR,
       C_HAS_SINIT => 0,
       C_HAS_SSET => 0,
       C_WIDTH => cosRound'length
  )
  port map(
       ACLR => ACLR,
       CE => outRegCe(0),
       CLK => CLK,
       D => cosRound( C_OUTPUT_WIDTH-1 downto 0 ),
       Q => cosRegOut( C_OUTPUT_WIDTH-1 downto 0 ),
       SCLR => SCLR
  );

error_delay : C_SHIFT_RAM_V5_0
  generic map (
       C_DEPTH => 3,
       C_GENERATE_MIF => 0,
       C_HAS_A => 0,
       C_HAS_ACLR => 0,
       C_HAS_AINIT => 0,
       C_HAS_ASET => 0,
       C_HAS_CE => C_HAS_CE,
       C_HAS_SCLR => 0,
       C_HAS_SINIT => 0,
       C_HAS_SSET => 0,
       C_READ_MIF => 0,
       C_REG_LAST_BIT => 0,
       C_SHIFT_TYPE => c_fixed,
       C_WIDTH => const_mult'length
  )
  port map(
       ACLR => ACLR,
       CE => CE,
       CLK => CLK,
       D => const_mult( 16 downto 0 ),
       Q => errorToRad( 16 downto 0 ),
       SCLR => SCLR
  );

rdyReg : C_REG_FD_V5_0
  generic map (
       C_HAS_ACLR => C_HAS_ACLR,
       C_HAS_AINIT => 0,
       C_HAS_ASET => 0,
       C_HAS_CE => C_HAS_CE,
       C_HAS_SCLR => C_HAS_SCLR,
       C_HAS_SINIT => 0,
       C_HAS_SSET => 0,
       C_WIDTH => 1
  )
  port map(
       ACLR => ACLR,
       CE => CE,
       CLK => CLK,
       D => outRegCe( 0 downto 0 ),
       Q => rdyBus( 0 downto 0 ),
       SCLR => SCLR
  );

sin_add : C_ADDSUB_V5_0
  generic map (
       C_ADD_MODE => c_sub,
       C_A_TYPE => c_signed,
       C_A_WIDTH => sinAddIn'length,
       C_BYPASS_LOW => 0,
       C_B_CONSTANT => 0,
       C_B_TYPE => c_signed,
       C_B_WIDTH => sin_mult_out'length,
       C_HAS_ACLR => 0,
       C_HAS_ADD => 0,
       C_HAS_AINIT => 0,
       C_HAS_ASET => 0,
       C_HAS_A_SIGNED => 0,
       C_HAS_BYPASS => 0,
       C_HAS_BYPASS_WITH_CIN => 0,
       C_HAS_B_IN => 0,
       C_HAS_B_OUT => 0,
       C_HAS_B_SIGNED => 0,
       C_HAS_CE => C_HAS_CE,
       C_HAS_C_IN => 0,
       C_HAS_C_OUT => 0,
       C_HAS_OVFL => 0,
       C_HAS_Q => 1,
       C_HAS_Q_B_OUT => 0,
       C_HAS_Q_C_OUT => 0,
       C_HAS_Q_OVFL => 1,
       C_HAS_S => 0,
       C_HAS_SCLR => 0,
       C_HAS_SINIT => 0,
       C_HAS_SSET => 0,
       C_HIGH_BIT => sinAddIn'length-1,
       C_LATENCY => 0,
       C_LOW_BIT => 0,
       C_OUT_WIDTH => sinAddIn'length,
       C_PIPE_STAGES => 0
  )
  port map(
       A => sinAddIn( SIN_IN'length+constZeroPadding'length-1 downto 0 ),
       ACLR => ACLR,
       B => sin_mult_out( sin_mult_o'length-1 downto 0 ),
       CE => CE,
       CLK => CLK,
       Q => sinAddOut( sinAddIn'length-1 downto 0 ),
       Q_OVFL => sinOvfl,
       SCLR => SCLR
  );

sin_mult : mult_gen_v5_0
  generic map (
       c_a_type => c_signed,
       c_a_width => COS_IN'length,
       c_b_constant => 0,
       c_b_type => c_unsigned,
       c_b_width => errorToRad'length,
       c_baat => COS_IN'length,
       c_has_a_signed => 0,
       c_has_aclr => 0,
       c_has_b => 0,
       c_has_ce => C_HAS_CE,
       c_has_load_done => 0,
       c_has_loadb => 0,
       c_has_nd => 0,
       c_has_o => 1,
       c_has_q => 1,
       c_has_rdy => 0,
       c_has_rfd => 0,
       c_has_sclr => 0,
       c_has_swapb => 0,
       c_mult_type => V2_PARALLEL,
       c_out_width => sin_mult_o'length,
       c_output_hold => 0,
       c_pipeline => C_PIPELINED,
       c_reg_a_b_inputs => 0
  )
  port map(
       a => COS_IN( C_INPUT_WIDTH-1 downto 0 ),
       a_signed => gnd,
       aclr => gnd,
       b => errorToRad( C_CONST_WIDTH-1 downto 0 ),
       ce => ce,
       clk => clk,
       loadb => gnd,
       nd => gnd,
       o => sin_mult_o( COS_IN'length + C_CONST_WIDTH-1 downto 0 ),
       q => sin_mult_q( COS_IN'length + C_CONST_WIDTH-1 downto 0 ),
       sclr => gnd,
       swapb => gnd
  );

sin_reg : C_REG_FD_V5_0
  generic map (
       C_HAS_ACLR => C_HAS_ACLR,
       C_HAS_AINIT => 0,
       C_HAS_ASET => 0,
       C_HAS_CE => 1,
       C_HAS_SCLR => C_HAS_SCLR,
       C_HAS_SINIT => 0,
       C_HAS_SSET => 0,
       C_WIDTH => sinRound'length
  )
  port map(
       ACLR => ACLR,
       CE => outRegCe(0),
       CLK => CLK,
       D => sinRound( C_OUTPUT_WIDTH-1 downto 0 ),
       Q => sinRegOut( C_OUTPUT_WIDTH-1 downto 0 ),
       SCLR => SCLR
  );


end C_EFF_V4_1;
