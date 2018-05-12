
-- $Id: div_repmult_v1_0.vhd,v 1.1 2010-07-10 21:43:06 mmartinez Exp $
--
--  Copyright(C) 2005 by Xilinx, Inc. All rights reserved.
--  This text/file contains proprietary, confidential
--  information of Xilinx, Inc., is distributed under license
--  from Xilinx, Inc., and may be used, copied and/or
--  disclosed only pursuant to the terms of a valid license
--  agreement with Xilinx, Inc.  Xilinx hereby grants you
--  a license to use this text/file solely for design, simulation,
--  implementation and creation of design files limited
--  to Xilinx devices or technologies. Use with non-Xilinx
--  devices or technologies is expressly prohibited and
--  immediately terminates your license unless covered by
--  a separate agreement.
--
--  Xilinx is providing this design, code, or information
--  "as is" solely for use in developing programs and
--  solutions for Xilinx devices.  By providing this design,
--  code, or information as one possible implementation of
--  this feature, application or standard, Xilinx is making no
--  representation that this implementation is free from any
--  claims of infringement.  You are responsible for
--  obtaining any rights you may require for your implementation.
--  Xilinx expressly disclaims any warranty whatsoever with
--  respect to the adequacy of the implementation, including
--  but not limited to any warranties or representations that this
--  implementation is free from claims of infringement, implied
--  warranties of merchantability or fitness for a particular
--  purpose.
--
--  Xilinx products are not intended for use in life support
--  appliances, devices, or systems. Use in such applications are
--  expressly prohibited.
--
--  This copyright and support notice must be retained as part
--  of this text at all times. (c) Copyright 1995-2005 Xilinx, Inc.
--  All rights reserved.
--
-------------------------------------------------------------------------------
-- Behavioural Model
-------------------------------------------------------------------------------
  
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

library XilinxCoreLib;
use xilinxcorelib.iputils_conv.all;
use xilinxcorelib.pkg_div_repmult_v1_0.all;
use xilinxcorelib.c_reg_fd_v8_0_comp.all;
--core_if on entity no_coregen_specials
  entity div_repmult_v1_0 is
    GENERIC (
      C_MANTISSA_WIDTH : integer :=  16;
      C_EXPONENT_WIDTH : integer :=  4;
      C_BIAS : integer :=  0;
      C_LATENCY : integer :=  0;
      C_HAS_CE : integer :=  0;
      C_HAS_SCLR : integer :=  0;
      C_SYNC_ENABLE : integer :=  0;
      C_HAS_ACLR : integer :=  0;
      C_ELABORATION_DIR : string :=  "./"
      );
    PORT (
      CLK : in std_logic;
      CE : in std_logic;
      SCLR : in std_logic;
      ACLR : in std_logic;
      DIVISOR_SIGN : in std_logic;
      DIVISOR_EXPONENT : in std_logic_vector(C_EXPONENT_WIDTH-1 downto 0);
      DIVISOR_MANTISSA : in std_logic_vector(C_MANTISSA_WIDTH-1 downto 0);
      DIVIDEND_SIGN : in std_logic;
      DIVIDEND_MANTISSA : in std_logic_vector(C_MANTISSA_WIDTH-1 downto 0);
      DIVIDEND_EXPONENT : in std_logic_vector(C_EXPONENT_WIDTH-1 downto 0);
      UNDERFLOW : out std_logic;
      OVERFLOW : out std_logic;
      QUOTIENT_SIGN : out std_logic;
      QUOTIENT_MANTISSA : out std_logic_vector(C_MANTISSA_WIDTH-1 downto 0);
      QUOTIENT_EXPONENT : out std_logic_vector(C_EXPONENT_WIDTH-1 downto 0)
      );
--core_if off
  end entity div_repmult_v1_0;


architecture behavioral of div_repmult_v1_0 is
  constant c_width           : integer := fn_required_width(C_MANTISSA_WIDTH, c_added_precision);
  constant iterations        : integer := fn_iterations(c_width);

  type t_numer_array   is array (0 to iterations) of std_logic_vector(c_width-1 downto 0);
  type t_mult_array    is array (0 to iterations) of std_logic_vector(2*c_width-1 downto 0);
  type t_pres          is array (0 to iterations) of integer;
  type t_mantissa_pipe is array (0 to C_LATENCY)  of std_logic_vector(C_MANTISSA_WIDTH-1 downto 0);
  type t_exponent_pipe is array (0 to C_LATENCY)  of std_logic_vector(C_EXPONENT_WIDTH-1 downto 0);
  type t_onebit_pipe   is array (0 to C_LATENCY)  of std_logic;

  -- purpose: gets rid of warnings in simulation
  function fn_init_numer_array
    return t_numer_array is
    variable ret_val : t_numer_array;
  begin  -- fn_init_numer_array
    for i in 0 to iterations loop
      ret_val(i) := (others => '0');
    end loop;  -- i
    return ret_val;
  end fn_init_numer_array;
      
  -- purpose: gets rid of warnings in simulation
  function fn_init_mult_array
    return t_mult_array is
    variable ret_val : t_mult_array;
  begin  -- fn_init_numer_array
    for i in 0 to iterations loop
      ret_val(i) := (others => '0');
    end loop;  -- i
    return ret_val;
  end fn_init_mult_array;

  constant ci_diff_width : integer := c_width - C_MANTISSA_WIDTH;
  subtype t_comp_bits is integer range ci_diff_width - 2 downto 0;
  
  signal ce_i                : std_logic                                := '1';  -- optional
  signal sclr_i              : std_logic                                := '0';  -- optional
  signal aclr_i              : std_logic                                := '0';  -- optional
  signal numer               : t_numer_array                            := fn_init_numer_array;
  signal denom               : t_numer_array                            := fn_init_numer_array;
  signal num_result          : t_mult_array                             := fn_init_mult_array;
  signal den_result          : t_mult_array                             := fn_init_mult_array;
  signal rho                 : t_numer_array                            := fn_init_numer_array;
  signal rom_val             : std_logic_vector(c_ram_width-1 downto 0) := (others => '0');
  signal lut_index           : integer range 0 to 2**10-1;
  signal pre_norm            : std_logic_vector(c_width-1 downto 0);
  signal pre_round           : std_logic_vector(c_width-1 downto 0);  --aka normalised
  signal round               : std_logic_vector(c_width-1 downto 0);
  signal rounding_cornercase : std_logic := '0';
  signal shifted             : integer                                  := 0;
  signal overflow_i          : std_logic                                := '0';
  signal underflow_i         : std_logic                                := '0';
  signal quotient_sign_i     : std_logic                                := '0';
  signal quotient_exponent_i : std_logic_vector(C_EXPONENT_WIDTH+1 downto 0);

  signal piped_mantissa  : t_mantissa_pipe;
  signal piped_exponent  : t_exponent_pipe;
  signal piped_underflow : t_onebit_pipe;
  signal piped_overflow  : t_onebit_pipe;
  signal piped_sign      : t_onebit_pipe;

  constant all_zeroes_man_slv : std_logic_vector(C_MANTISSA_WIDTH-1 downto 0) := (others => '0');
  constant all_zeroes_man     : string(1 to C_MANTISSA_WIDTH) := std_logic_vector_2_string(all_zeroes_man_slv);
  constant all_zeroes_exp_slv : std_logic_vector(C_EXPONENT_WIDTH-1 downto 0) := (others => '0');
  constant all_ones_exp_slv   : std_logic_vector(C_EXPONENT_WIDTH-1 downto 0) := (others => '1');
  constant all_zeroes_exp     : string(1 to C_EXPONENT_WIDTH) := std_logic_vector_2_string(all_zeroes_exp_slv);
  constant mantissa_non_zero  : std_logic_vector(C_MANTISSA_WIDTH-1 downto 0) := all_zeroes_man_slv +1;
  
  type t_ROM_behv_table   is array (0 to 2**c_ram_width-1) of std_logic_vector(c_ram_width-1 downto 0); 

  --Create lookup table of 1/x. i.e 1.0dddd = 1/0.1aaaa1 
  function fn_ROM_behv_table (
    p_addr_width : integer;
    p_data_width : integer)
    return t_ROM_behv_table is
    variable ret_val      : t_ROM_behv_table;
    variable addr         : integer;
    variable exact_result : integer;
    variable slv_result   : std_logic_vector(p_data_width downto 0);
  begin
    --fill RAM with lookup of 1/x
    for i  in 0 to 2**p_addr_width-1 loop
      --For better accuracy, use 1/(p+0.5) rather than 1/p
      --This also avoids the MSB problem that 1/0.5 = 2 
      addr         := 2*(2**p_addr_width + i)+1;  --See note 1 above
      exact_result := (2**(p_addr_width+2+p_data_width+1)+1) / (addr*2);
--      exact_result := 2**(p_addr_width+2+p_data_width) / addr;
      slv_result   := int_2_std_logic_vector(exact_result,p_data_width+1);
      ret_val(i)   := slv_result(p_data_width-1 downto 0);  --p_data_width-1 downto 0?
    end loop;  -- i
    return ret_val;
  end fn_ROM_behv_table;
  constant rep_lut : t_ROM_behv_table := fn_ROM_behv_table(c_ram_width,c_ram_width);  -- 1k x 18 bits (10 used)

  signal rep_lut_diag : t_ROM_behv_table                    := rep_lut;
  signal index        : integer range 0 to 2**c_ram_width-1 := 0;

  --exception signals
  signal divisor_man_zero  : std_logic := '0';
  signal divisor_exp_zero  : std_logic := '0';
  signal divisor_exp_one   : std_logic := '0';
  signal dividend_man_zero : std_logic := '0';
  signal dividend_exp_zero : std_logic := '0';
  signal dividend_exp_one  : std_logic := '0';
  signal divisor_nan       : std_logic := '0';
  signal divisor_zero      : std_logic := '0';
  signal divisor_infinity  : std_logic := '0';
  signal dividend_nan      : std_logic := '0';
  signal dividend_zero     : std_logic := '0';
  signal dividend_infinity : std_logic := '0';
  signal nan_i      : std_logic := '0';
  signal zero_i     : std_logic := '0';
  signal infinity_i : std_logic := '0';

begin
    --wire up inputs to internals
  i_ce: if C_HAS_CE /=0 generate
    ce_i <= ce;
  end generate i_ce;
  i_sclr: if C_HAS_SCLR /=0 generate
    sclr_i <= sclr;
  end generate i_sclr;
  i_aclr: if C_HAS_ACLR /=0 generate
    aclr_i <= aclr;
  end generate i_aclr;

  --Both numerator and denominator are normalised to the range [0.5 to 1), but
  --only the bits of significance (i.e. those which contain information) are passed
  --to the circuit. Here, the bits passed are padded with the known bits, so
  --that both numerator and denominator conform to a standardized notation (which
  --makes it easier to debug).
  numer(0)(c_width-1 downto c_width-3)         <= "001";
  numer(0)(c_width-4 downto c_width-3-C_MANTISSA_WIDTH) <= DIVIDEND_MANTISSA;
  numer(0)(c_width-C_MANTISSA_WIDTH-4 downto 0)         <= (others => '0');
  
  denom(0)(c_width-1 downto c_width-3)         <= "001";
  denom(0)(c_width-4 downto c_width-3-C_MANTISSA_WIDTH) <= DIVISOR_MANTISSA;
  denom(0)(c_width-C_MANTISSA_WIDTH-4 downto 0)         <= (others => '0');

  --Build up first estimate from ROM LUT
  index   <= std_logic_vector_2_posint(denom(0)(c_width-4 downto c_width-3-c_ram_width));
  rom_val <= rep_lut(index);

  rho(0)(c_width-1)                              <= '0';
  rho(0)(c_width-2)                              <= '1';
  rho(0)(c_width-3 downto c_width-2-c_ram_width) <= rom_val;  --1.yyyyyy
  rho(0)(c_width-c_ram_width-3 downto 0)         <= (others => '0');  --1.yyyyyy

  i_stage: for stage in 0 to iterations -1 generate
    --determine what to multiply top and bottom by
    i_truct_stages: if stage> 0 generate
      --There are several ways to calculate the estimate of 1/x.
      --est(1/x) = 2-x is the textbook estimate
      --est(1/x) = 2-x truncated is the advanced textbook estimate
      --and of course there is the rinky dinky patented estimate...
--      rho(stage) <= 2**c_width-(denom(stage));
--      rho(stage)(c_width-1) <= denom(stage)(c_width-1);
      calc_rho: process (denom(stage))
        variable part_rho : t_numer_array;
      begin  -- process calc_rho
--        part_rho(stage) := NOT(denom(stage))+1;
        part_rho(stage) := NOT(denom(stage))+1;        
        rho(stage) <= part_rho(stage);
        rho(stage)(c_width-1) <= '0';
      end process calc_rho;
--      rho(stage) <= NOT(denom(stage));  --Pat Pending ;)
    end generate i_truct_stages;
    num_result(stage) <= (numer(stage)) * (rho(stage));
    den_result(stage) <= (denom(stage)) * (rho(stage));
  end generate i_stage;

  --multiply top and bottom by an estimate 1/x so that the denominator approaches
  --one and the numerator approaches the quotient
  i_stageloop: for stage in 0 to iterations -1 generate
    numer(stage+1) <= num_result(stage)(2*c_width-3 downto c_width-2);
    denom(stage+1) <= den_result(stage)(2*c_width-3 downto c_width-2);
  end generate i_stageloop;

  -----------------------------------------------------------------------------
  -- single bit shift to renormalise result range of [0.5, 2) to [0.5, 1)
  -----------------------------------------------------------------------------
  pre_norm <= numer(iterations);
  i_norm: process (pre_norm)
  begin  -- process i_norm
    if pre_norm(c_width-2) = '1' then
      pre_round    <= '0'&pre_norm(c_width-1 downto 1);
      shifted <= 1;
    else
      pre_round    <= pre_norm(c_width-1 downto 0);
      shifted <= 0;
    end if;
  end process i_norm;

  i_round: process(pre_round)
    variable comp_bits : std_logic_vector(t_comp_bits);
    variable exception : std_logic_vector(t_comp_bits);
  begin
    comp_bits(t_comp_bits) := pre_round(t_comp_bits);
    exception := (others => '0');
    exception(ci_diff_width - 3) := '1';
    if pre_round(ci_diff_width - 2 downto ci_diff_width -3) = exception then
      round <= pre_round;
    else
      round <= pre_round + exception;
    end if;
  end process i_round;

  --if the rounding causes 0.11111111 to become 1.0000000 then the answer is
  --0.1000000 (i.e mantissa (in implicit one form) is unchanged, but exponent is incremented) 
  i_round_corner_case: process(round)
  begin
    rounding_cornercase <= round(round'LEFT-1);
  end process i_round_corner_case;

  
  quotient_exponent_i <= (("00"&DIVIDEND_EXPONENT) - ("00"&DIVISOR_EXPONENT)) + C_BIAS + shifted + rounding_cornercase;
  overflow_i          <= (not quotient_exponent_i(C_EXPONENT_WIDTH+1)) and quotient_exponent_i(C_EXPONENT_WIDTH);
  underflow_i         <= quotient_exponent_i(C_EXPONENT_WIDTH+1);
  quotient_sign_i     <= DIVIDEND_SIGN xor DIVISOR_SIGN;
  
  -----------------------------------------------------------------------------
  -- exception detection
  -----------------------------------------------------------------------------
  divisor_man_zero  <= '1' when DIVISOR_MANTISSA  = all_zeroes_man_slv else '0';
  dividend_man_zero <= '1' when DIVIDEND_MANTISSA = all_zeroes_man_slv else '0';
  divisor_exp_zero  <= '1' when DIVISOR_EXPONENT  = all_zeroes_exp_slv else '0';
  dividend_exp_zero <= '1' when DIVIDEND_EXPONENT = all_zeroes_exp_slv else '0';
  divisor_exp_one   <= '1' when DIVISOR_EXPONENT  = all_ones_exp_slv else '0';
  dividend_exp_one  <= '1' when DIVIDEND_EXPONENT = all_ones_exp_slv else '0';

  --Note that denormals are considered to be zero
  divisor_nan       <= '1' when (divisor_exp_one   = '1' and divisor_man_zero = '0') else '0';
  divisor_infinity  <= '1' when (divisor_exp_one   = '1' and divisor_man_zero = '1') else '0';
  divisor_zero      <= '1' when (divisor_exp_zero  = '1') else '0'; -- and divisor_man_zero = '1') else '0';
  dividend_nan      <= '1' when (dividend_exp_one  = '1' and dividend_man_zero = '0') else '0';
  dividend_infinity <= '1' when (dividend_exp_one  = '1' and dividend_man_zero = '1') else '0';
  dividend_zero     <= '1' when (dividend_exp_zero = '1') else '0'; -- and dividend_man_zero = '1') else '0';

  nan_i      <= '1' when (divisor_nan = '1'
                          or dividend_nan= '1'
                          or (divisor_zero = '1' and dividend_zero = '1')
                          or (divisor_infinity = '1' and dividend_infinity = '1')) else '0';
  zero_i     <= '1' when ((divisor_infinity = '1' and dividend_infinity = '0' and dividend_nan = '0')
                          or (dividend_zero = '1' and divisor_zero = '0'and divisor_nan = '0')) else '0';
  infinity_i <= '1' when ((dividend_infinity = '1' and divisor_infinity = '0' and divisor_nan = '0')
                          or (divisor_zero = '1' and dividend_zero = '0' and dividend_nan = '0')) else '0';

  --pipelining section: take the asynchronous result, just calculated, and pipe
  --it through a series of registers, to achieve the same effect as distributed
  --pipelining, as used to speed up the synth model.
  --Er, and also take account of the exceptions!
  piped_exponent(0)  <= all_ones_exp_slv when (nan_i = '1' or infinity_i = '1') else
                        all_zeroes_exp_slv when (zero_i = '1') else
                        quotient_exponent_i(C_EXPONENT_WIDTH-1 downto 0);
  piped_underflow(0) <= '0' when (nan_i = '1' or infinity_i = '1' or zero_i = '1') else
                        underflow_i;
  piped_overflow(0)  <= '0' when (nan_i = '1' or infinity_i = '1' or zero_i = '1') else
                        overflow_i;
  piped_sign(0)      <= quotient_sign_i;
  piped_mantissa(0)  <= all_zeroes_man_slv when (infinity_i = '1' or zero_i = '1') else
                        mantissa_non_zero when (nan_i = '1') else
                        round(c_width-1-3 downto c_width -C_MANTISSA_WIDTH-3);

  i_need_pipe : if C_LATENCY > 0 generate
    
    i_pipe : for stage in 1 to C_LATENCY generate
      i_man_reg : c_reg_fd_v8_0
        generic map (
          C_WIDTH     => C_MANTISSA_WIDTH,
          C_HAS_CE    => C_HAS_CE,
          C_HAS_SCLR  => C_HAS_SCLR,
          C_SYNC_ENABLE => C_SYNC_ENABLE,
          C_HAS_ACLR  => C_HAS_ACLR,
          C_AINIT_VAL => all_zeroes_man     --ensures por value of 0.
          )
        port map (
          clk  => clk,
          ce   => ce_i,
          sclr => sclr_i,
          aclr => aclr_i,
          d    => piped_mantissa(stage-1),
          q    => piped_mantissa(stage)
          );
      
      i_exp_reg : c_reg_fd_v8_0
        generic map (
          C_WIDTH     => C_EXPONENT_WIDTH,
          C_HAS_CE    => C_HAS_CE,
          C_HAS_SCLR  => C_HAS_SCLR,
          C_SYNC_ENABLE => C_SYNC_ENABLE,
          C_HAS_ACLR  => C_HAS_ACLR,
          C_AINIT_VAL => all_zeroes_exp     --ensures por value of 0.
          )
        port map (
          clk  => clk,
          ce   => ce_i,
          sclr => sclr_i,
          aclr => aclr_i,
          d    => piped_exponent(stage-1),
          q    => piped_exponent(stage)
          );
      
      i_underflow_reg : c_reg_fd_v8_0
        generic map (
          C_WIDTH     => 1,
          C_HAS_CE    => C_HAS_CE,
          C_HAS_SCLR  => C_HAS_SCLR,
          C_SYNC_ENABLE => C_SYNC_ENABLE,
          C_HAS_ACLR  => C_HAS_ACLR,
          C_AINIT_VAL => "0"     --ensures por value of 0.
          )
        port map (
          clk  => clk,
          ce   => ce_i,
          sclr => sclr_i,
          aclr => aclr_i,
          d(0) => piped_underflow(stage-1),
          q(0) => piped_underflow(stage)
          );
      
      i_overflow_reg : c_reg_fd_v8_0
        generic map (
          C_WIDTH     => 1,
          C_HAS_CE    => C_HAS_CE,
          C_HAS_SCLR  => C_HAS_SCLR,
          C_SYNC_ENABLE => C_SYNC_ENABLE,
          C_HAS_ACLR  => C_HAS_ACLR,
          C_AINIT_VAL => "0"     --ensures por value of 0.
          )
        port map (
          clk  => clk,
          ce   => ce_i,
          sclr => sclr_i,
          aclr => aclr_i,
          d(0) => piped_overflow(stage-1),
          q(0) => piped_overflow(stage)
          );
      
      i_sign_reg : c_reg_fd_v8_0
        generic map (
          C_WIDTH     => 1,
          C_HAS_CE    => C_HAS_CE,
          C_HAS_SCLR  => C_HAS_SCLR,
          C_SYNC_ENABLE => C_SYNC_ENABLE,
          C_HAS_ACLR  => C_HAS_ACLR,
          C_AINIT_VAL => "0"     --ensures por value of 0.
          )
        port map (
          clk  => clk,
          ce   => ce_i,
          sclr => sclr_i,
          aclr => aclr_i,
          d(0) => piped_sign(stage-1),
          q(0) => piped_sign(stage)
          );
    end generate i_pipe;
  end generate i_need_pipe;

  QUOTIENT_MANTISSA <= piped_mantissa(C_LATENCY);
  QUOTIENT_EXPONENT <= piped_exponent(C_LATENCY);
  QUOTIENT_SIGN     <= piped_sign(C_LATENCY);
  UNDERFLOW         <= piped_underflow(C_LATENCY);
  OVERFLOW          <= piped_overflow(C_LATENCY);
 
end behavioral;

