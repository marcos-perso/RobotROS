
-- $Id: div_gen_v1_0.vhd,v 1.1 2010-07-10 21:43:06 mmartinez Exp $
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

library xilinxcorelib;
use xilinxcorelib.pkg_div_gen_v1_0.all;
use xilinxcorelib.prims_constants_v8_0.all;
use xilinxcorelib.prims_utils_v8_0.all;
use xilinxcorelib.div_repmult_v1_0_comp.all;
use Xilinxcorelib.sdivider_v4_0_comp.all;

-- (A)synchronous multi-input gate
--
--core_if on entity 
  entity div_gen_v1_0 is
    GENERIC (
      C_FAMILY : string :=  "virtex2";
      C_XDEVICEFAMILY : string :=  "virtex2";
      ALGORITHM_TYPE : integer :=  1;
      C_HAS_CE : integer :=  0;
      C_HAS_ACLR : integer :=  0;
      C_HAS_SCLR : integer :=  0;
      C_SYNC_ENABLE : integer :=  0;
      DIVISOR_WIDTH : integer :=  16;
      DIVIDEND_WIDTH : integer :=  16;
      SIGNED_B : integer :=  0;
      DIVCLK_SEL : integer :=  1;
      FRACTIONAL_B : integer :=  0;
      FRACTIONAL_WIDTH : integer :=  16;
      MANTISSA_WIDTH : integer :=  8;
      EXPONENT_WIDTH : integer :=  8;
      LATENCY : integer :=  1;
      BIAS : integer :=  -1;
      C_ELABORATION_DIR : string :=  "./"
      );
    PORT (
      CLK : in std_logic                                   := '0';
      CE : in std_logic                                   := '1';
      ACLR : in std_logic                                   := '0';
      SCLR : in std_logic                                   := '0';
      DIVIDEND : in std_logic_vector(DIVIDEND_WIDTH-1 downto 0) := (others => '0');
      DIVISOR : in std_logic_vector(DIVISOR_WIDTH-1 downto 0)  := (others => '0');
      QUOTIENT : out std_logic_vector(DIVIDEND_WIDTH-1 downto 0);
      REMAINDER : out std_logic_vector(FRACTIONAL_WIDTH-1 downto 0);
      RFD : out std_logic;
      DIVIDEND_MANTISSA : in std_logic_vector(MANTISSA_WIDTH-1 downto 0) := (others => '0');
      DIVIDEND_SIGN : in std_logic                                   := '0';
      DIVIDEND_EXPONENT : in std_logic_vector(EXPONENT_WIDTH-1 downto 0) := (others => '0');
      DIVISOR_MANTISSA : in std_logic_vector(MANTISSA_WIDTH-1 downto 0) := (others => '0');
      DIVISOR_SIGN : in std_logic                                   := '0';
      DIVISOR_EXPONENT : in std_logic_vector(EXPONENT_WIDTH-1 downto 0) := (others => '0');
      QUOTIENT_MANTISSA : out std_logic_vector(MANTISSA_WIDTH-1 downto 0);
      QUOTIENT_SIGN : out std_logic;
      QUOTIENT_EXPONENT : out std_logic_vector(EXPONENT_WIDTH-1 downto 0);
      OVERFLOW : out std_logic;
      UNDERFLOW : out std_logic
      );
--core_if off
  end entity div_gen_v1_0;



ARCHITECTURE behavioral OF div_gen_v1_0 IS
  constant check_gens : integer := fn_check_generics(
    p_algorithm       => ALGORITHM_TYPE ,      
    p_divisor_width   => DIVISOR_WIDTH  ,
    p_dividend_width  => DIVIDEND_WIDTH,
    p_has_ce          => C_HAS_CE,
    p_has_aclr        => C_HAS_ACLR,
    p_has_sclr        => C_HAS_SCLR,
    p_sync_enable     => C_SYNC_ENABLE,
    p_div_per_clk     => DIVCLK_SEL,
    p_has_remainder   => FRACTIONAL_B,
    p_remainder_width => FRACTIONAL_WIDTH,
    p_exponent_width  => EXPONENT_WIDTH,
    p_bias            => BIAS
    );

  constant ci_algorithm : t_enum_algorithm := fn_choose_algo(
    algorithm_type
--    c_opt_goal
    );

  constant ci_has_ce          : integer := C_HAS_CE;
  constant ci_has_aclr        : integer := C_HAS_ACLR;
  constant ci_has_sclr        : integer := C_HAS_SCLR;
  constant ci_sync_enable     : integer := C_SYNC_ENABLE;
--  constant ci_opt_goal        : integer := C_OPT_GOAL;
--  constant ci_prim_pref       : integer := C_PRIM_PREF;
--  constant ci_operand_type    : integer := C_OPERAND_TYPE;
  constant ci_div_per_clk     : integer := DIVCLK_SEL;
  constant ci_operand_signed  : integer := SIGNED_B;
  constant ci_divisor_width   : integer := DIVISOR_WIDTH;
  constant ci_dividend_width  : integer := DIVIDEND_WIDTH;
  constant ci_has_remainder   : integer := FRACTIONAL_B;
  constant ci_remainder_width : integer := FRACTIONAL_WIDTH;
  
  constant ci_bias            : integer := fn_bias(BIAS,EXPONENT_WIDTH);
  constant ci_mantissa_width  : integer := fn_mantissa_width(MANTISSA_WIDTH);
  constant ci_exponent_width  : integer := EXPONENT_WIDTH;
  constant ci_latency         : integer := LATENCY;

  -- signals section
  signal aclr_i    : std_logic := '0';  -- optional
  signal sclr_i    : std_logic := '0';  -- optional
  signal rfd_i     : std_logic := '0';  -- optional
  signal nd_i      : std_logic := '0';  -- optional
  signal ce_i      : std_logic := '0';  -- optional
  signal divisor_mantissa_i  : std_logic_vector(ci_mantissa_width-1 downto 0) := (others => '0'); 
  signal dividend_mantissa_i : std_logic_vector(ci_mantissa_width-1 downto 0) := (others => '0');
  signal quotient_mantissa_i : std_logic_vector(ci_mantissa_width-1 downto 0);


BEGIN
   --connect optional input pins
  opt_aclr: if ci_has_aclr = 1 generate
    aclr_i <= aclr;
  end generate opt_aclr;
    
  opt_sclr: if ci_has_sclr = 1 generate
    sclr_i <= sclr;
  end generate opt_sclr;
    
  opt_ce: if ci_has_ce = 1 generate
    ce_i <= ce;
  end generate opt_ce;
    
  dividend_mantissa_i(ci_mantissa_width-1 downto ci_mantissa_width-MANTISSA_WIDTH) <= DIVIDEND_MANTISSA;
  divisor_mantissa_i(ci_mantissa_width-1 downto ci_mantissa_width-MANTISSA_WIDTH)  <= DIVISOR_MANTISSA;
  QUOTIENT_MANTISSA <= quotient_mantissa_i(ci_mantissa_width -1 downto ci_mantissa_width-MANTISSA_WIDTH);
    
--  opt_nd: if ci_has_nd = 1 generate
--    nd_i <= nd;
--  end generate opt_nd;
    
  --connect optional output pins
--  opt_rfd: if ci_has_rfd = 1 generate
    rfd <= rfd_i;
--  end generate opt_rfd;
    
  --implement a divider using repeated multiplication
  i_algo_rep_mult: if ci_algorithm = enum_repmult generate
    i_rep_mult : div_repmult_v1_0
      generic map(
        C_MANTISSA_WIDTH => ci_mantissa_width,
        C_EXPONENT_WIDTH => ci_exponent_width,
        C_BIAS           => ci_bias          ,
        C_LATENCY        => ci_latency       ,
        C_SYNC_ENABLE    => ci_sync_enable   ,
        C_HAS_CE         => ci_has_ce        ,
        C_HAS_SCLR       => ci_has_sclr      ,
        C_HAS_ACLR       => ci_has_aclr      
        )
      port map(
        CLK               => CLK              ,
        CE                => CE               ,
        SCLR              => SCLR             ,
        ACLR              => ACLR             ,
        DIVISOR_SIGN      => DIVISOR_SIGN     ,
        DIVISOR_MANTISSA  => divisor_mantissa_i ,
        DIVISOR_EXPONENT  => DIVISOR_EXPONENT ,
        DIVIDEND_SIGN     => DIVIDEND_SIGN    ,
        DIVIDEND_MANTISSA => dividend_mantissa_i,
        DIVIDEND_EXPONENT => DIVIDEND_EXPONENT,
        UNDERFLOW         => UNDERFLOW        ,
        OVERFLOW          => OVERFLOW         ,
        QUOTIENT_SIGN     => QUOTIENT_SIGN    ,
        QUOTIENT_MANTISSA => quotient_mantissa_i,
        QUOTIENT_EXPONENT => QUOTIENT_EXPONENT 
        );
  end generate i_algo_rep_mult;

  --implement a divider using radix 2 non-restoring division
  i_algo_r2_nr: if ci_algorithm = enum_rad2_nonrestore generate
    i_sdivider : sdivider_v4_0
      generic map(
        C_HAS_ACLR       => ci_has_aclr,
        C_HAS_CE         => ci_has_ce,
        C_HAS_SCLR       => ci_has_sclr,
        C_SYNC_ENABLE    => ci_sync_enable,
        DIVCLK_SEL       => ci_div_per_clk,
        DIVIDEND_WIDTH   => ci_dividend_width,
        DIVISOR_WIDTH    => ci_divisor_width,
        FRACTIONAL_B     => ci_has_remainder,
        FRACTIONAL_WIDTH => ci_remainder_width,
        SIGNED_B         => ci_operand_signed
        )
      port map(
        DIVIDEND => DIVIDEND,
        DIVISOR  => DIVISOR,
        QUOT     => QUOTIENT,
        REMD     => REMAINDER,
        CLK      => CLK, 
        RFD      => rfd_i,
        ACLR     => aclr_i,
        SCLR     => sclr_i,
        CE       => ce_i      
        );
  end generate i_algo_r2_nr;
 
END behavioral;

