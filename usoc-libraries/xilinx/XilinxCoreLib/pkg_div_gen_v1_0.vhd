---------------------------------------------------------------------------
-- $Header: /local/Projects/CVS/P1/zpu_SoC/sources/xilinx/XilinxCoreLib/pkg_div_gen_v1_0.vhd,v 1.1 2010-07-10 21:43:18 mmartinez Exp $
---------------------------------------------------------------------------
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
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package pkg_div_gen_v1_0 is

  --poor man's enumerated type for c_algorithm
  constant cval_algo_auto    : integer := 0;
  constant cval_algo_rad2    : integer := 1;
  constant cval_algo_repmult : integer := 2;
  constant cval_algo_last    : integer := cval_algo_repmult;

  --poor man's enumerated type for c_opt_goal
  constant cval_optgoal_auto    : integer := 0;
  constant cval_optgoal_speed   : integer := 1;
  constant cval_optgoal_area    : integer := 2;
  constant cval_optgoal_latency : integer := 3;
  constant cval_optgoal_last    : integer := cval_optgoal_latency;

  --poor man's enumerated type for c_div_per_clk
  constant cval_divclk_1   : integer := 1;
  constant cval_divclk_2   : integer := 2;
  constant cval_divclk_4   : integer := 4;
  constant cval_divclk_8   : integer := 8;
  constant cval_divclk_max : integer := 8;

  --poor man's enumerated type for c_operand_type
  constant cval_optype_auto  : integer := 0;
  constant cval_optype_int   : integer := 1;
  constant cval_optype_mant  : integer := 2;
  constant cval_optype_last  : integer := cval_optype_mant;
    
  constant c_rad2_max_width    : integer := 32;
  constant c_repmult_max_width : integer := 64;
  constant c_ram_width         : integer := 10;
  
  type t_enum_algorithm    is (enum_rad2_nonrestore, enum_repmult);
  type t_enum_operand_type is (enum_optype_int, enum_optype_mant);

  function fn_choose_algo (
    p_algorithm : integer
--    p_opt_goal  : integer
    )
    return t_enum_algorithm;

  function fn_bias (
    p_bias  : integer;
    p_width : integer)
    return integer;

  function fn_mantissa_width (
    p_mantissa_width : integer)
    return integer;

  function fn_check_generics (
    p_algorithm       : integer;
    p_divisor_width   : integer;
    p_dividend_width  : integer;
    p_has_ce          : integer;
    p_has_aclr        : integer;
    p_has_sclr        : integer;
    p_sync_enable     : integer;
    p_div_per_clk     : integer;
    p_has_remainder   : integer;
    p_remainder_width : integer;
    p_exponent_width  : integer;
    p_bias            : integer
    )
    return integer;

  function fn_choose_operand_type (
    p_algorithm : t_enum_algorithm;
    p_optype    : integer)
    return t_enum_operand_type;
  
  
end pkg_div_gen_v1_0;

package body pkg_div_gen_v1_0 is
  -----------------------------------------------------------------------------
  -- Chose algorithm to implement 
  -----------------------------------------------------------------------------
  function fn_choose_algo (
    p_algorithm : integer
--    p_opt_goal  : integer
    )
    return t_enum_algorithm is
  begin
    case p_algorithm is
      --When auto, Pick an algorithm according to other generic choices.
--      when cval_algo_auto =>
--        case p_opt_goal is
--          when cval_optgoal_auto =>   
--            return enum_repmult;
--          when cval_optgoal_speed =>  
--            return enum_rad2_nonrestore;
--          when cval_optgoal_area =>   
--            return enum_repmult;
--          when cval_optgoal_latency =>
--            return enum_repmult;
--          when others =>
--            assert false report "ERROR: Unrecognised c_opt_goal value" severity FAILURE;
--            return enum_repmult;
--        end case;
      --Explicit choices. Do what the user asks
      when cval_algo_rad2    => return enum_rad2_nonrestore;  
      when cval_algo_repmult => return enum_repmult;
      --there should be no other choices, so flag error.
      when others =>
        assert false report "ERROR: Unrecognised algorithm_type value "&INTEGER'IMAGE(p_algorithm) severity FAILURE;
        return enum_repmult;
    end case;
  end fn_choose_algo;

  --bias is whatever the user wants if it's positive. -1 means use midpoint.
  function fn_bias (
    p_bias  : integer;
    p_width : integer)
    return integer is
  begin
    if p_bias >= 0 then
      return p_bias;
    else
      return 2**(p_width -1)-1;
    end if;
  end fn_bias;


  function fn_mantissa_width (
    p_mantissa_width : integer)
    return integer is
  begin
    if p_mantissa_width >8 then
      return p_mantissa_width;
    else
      return 9;
    end if;
  end fn_mantissa_width;


  function fn_choose_operand_type (
    p_algorithm : t_enum_algorithm;
    p_optype    : integer)
    return t_enum_operand_type is
  begin
    case p_optype is
      when cval_optype_auto =>
        case p_algorithm is
          when enum_rad2_nonrestore => return enum_optype_int;
          when enum_repmult         => return enum_optype_mant;
          when others               => return enum_optype_mant;
        end case;
      when cval_optype_int  => return enum_optype_int;
      when cval_optype_mant => return enum_optype_mant;                       
      when others =>
        assert false
          report "Error: Unrecognised optype in fn_choose_operand_type"
          severity ERROR;
        return enum_optype_mant;
    end case;
  end fn_choose_operand_type;

    
    
  function fn_check_generics (
    p_algorithm       : integer;
    p_divisor_width   : integer;
    p_dividend_width  : integer;
    p_has_ce          : integer;
    p_has_aclr        : integer;
    p_has_sclr        : integer;
    p_sync_enable     : integer;
    p_div_per_clk     : integer;
    p_has_remainder   : integer;
    p_remainder_width : integer;
    p_exponent_width  : integer;
    p_bias            : integer
    )
    return integer is
  begin

    --p_algorithm checks
    assert (p_algorithm >= 0 and p_algorithm <= cval_algo_last)
      report "ERROR. Unrecognised value for c_algorithm"
      severity FAILURE;
    
--    --p_operand_type checks
--    assert (p_operand_type >= 0 and p_operand_type <= cval_optype_last)
--      report "ERROR: c_operand_type out of range"
--      severity FAILURE;
--    assert not(p_operand_type = cval_optype_int and p_algorithm = cval_algo_repmult)
--      report "WARNING: Using Integers with repeated multiplication divider will result in extra latency"
--      severity WARNING;
--    assert not(p_operand_type = cval_optype_mant and p_algorithm = cval_algo_rad2)
--      report "WARNING: Using Normalised numbers with radix2 divider will result in extra latency"
--      severity WARNING;
--
--    --p_operand_signed checks
--
    --p_divisor_width checks
    assert not(p_algorithm = cval_algo_rad2 and p_divisor_width > 32)
      report "ERROR: Divisor width too great for rad2 divider"
      severity FAILURE;
    assert not(p_algorithm = cval_algo_repmult and p_divisor_width > c_repmult_max_width)
      report "ERROR: Divisor width too great for repeated multiple divider."
      severity FAILURE;
    
    --p_dividend_width checks   
    assert not(p_algorithm = cval_algo_rad2 and p_dividend_width > 32)
      report "ERROR: Dividend width too great for rad2 divider"
      severity FAILURE;
    assert not(p_algorithm = cval_algo_repmult and p_dividend_width > c_repmult_max_width)
      report "ERROR: Dividend width too great for repeated multiple divider."
      severity FAILURE;
    
    --p_has_ce checks    
    assert (p_has_ce = 0 or p_has_ce = 1)
      report "ERROR: c_has_ce must be 0 or 1"
      severity FAILURE;
    
    --p_has_aclr checks    
    assert (p_has_aclr = 0 or p_has_aclr = 1)
      report "ERROR: c_has_aclr must be 0 or 1"
      severity FAILURE;
    
    --p_has_sclr checks   
    assert (p_has_sclr = 0 or p_has_sclr = 1)
      report "ERROR: c_has_sclr must be 0 or 1"
      severity FAILURE;
    
    --p_sync_enable checks   
    assert (p_sync_enable = 0 or p_sync_enable = 1)
      report "ERROR: c_sync_enable must be 0 or 1"
      severity FAILURE;
    
--    --p_has_nd checks
--    assert (p_has_nd = 0 or p_has_nd = 1)
--      report "ERROR: c_has_nd must be 0 or 1"
--      severity FAILURE;
--    
--    --p_has_rfd checks    
--    assert (p_has_rfd = 0 or p_has_rfd = 1)
--      report "ERROR: c_has_rfd must be 0 or 1"
--      severity FAILURE;
--    
    --p_div_per_clk checks
    assert (p_div_per_clk >= 1 and p_div_per_clk <= cval_divclk_max)
      report "ERROR: c_div_per_clk out of range."
      severity FAILURE;
    
    --p_remainder_width checks
    assert (p_has_remainder = 0 or (p_remainder_width>0  and p_remainder_width <= 32))
      report "ERROR: Remainder width out of range 1 to 32 for radix2 divider"
      severity FAILURE;

    --p_exponent_width checks
    assert (p_exponent_width >=2  and p_exponent_width <= 16)
      report "ERROR: Exponent width out of range 2 to 16."
      severity FAILURE;
    
    --p_bias_checks
    assert(p_bias >=0 or p_bias = -1)
      report "Error: Bias on exponent must be positive or -1"--must it???
      severity ERROR;
    return 0;
  end fn_check_generics;

  

end pkg_div_gen_v1_0;
