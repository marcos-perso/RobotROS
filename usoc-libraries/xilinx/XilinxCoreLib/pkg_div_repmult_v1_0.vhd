-- $Header
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
library std, ieee;
use ieee.std_logic_1164.all;

--library mult_gen_utils_v8_0;
--use mult_gen_utils_v8_0.mult_gen_const_pkg_v8_0.all;
--use mult_gen_utils_v8_0.mult_gen_v8_0_services.all;

--library unisim;
--use unisim.vcomponents.all;

--library std;
--use std.textio.all;

package pkg_div_repmult_v1_0 IS

  constant c_max_width         : integer := 64;
  constant c_ram_width         : integer := 10;
  constant c_init_precision    : integer := c_ram_width-1;
  constant c_ram_data_width    : integer := 16;
  constant c_added_precision   : integer := 4;  --number of bits added precision
  constant c_input_stages_regs : integer := 3;
  constant c_pipes_per_stage   : integer := 3;
  constant max_iterations      : integer := 4;

  constant c_estimate_offset : integer := 1;
  constant c_mult_offset     : integer := 2;
  constant c_adder_offset    : integer := 3;

  constant c_shift_and_round_latency_stages : integer := 5;
  
  type t_bus_pos   is array (0 to max_iterations) of integer;

  component unrolled is
    generic (
      C_FAMILY         : string  := "virtex2";
      C_XDEVICEFAMILY  : string  := "virtex2";
      C_MANTISSA_WIDTH : integer := 8;
      C_LATENCY        : integer := 0;
      C_HAS_CE         : integer := 0;
      C_SYNC_ENABLE    : integer := 0;
      C_HAS_SCLR       : integer := 0;
      C_HAS_ACLR       : integer := 0;
      C_ELABORATION_DIR : string := "./"
      );
    port (
      CLK  : in  std_logic := '0';
      CE   : in  std_logic := '1';
      SCLR : in  std_logic := '0';
      ACLR : in  std_logic := '0';
      X    : in  std_logic_vector(C_MANTISSA_WIDTH-1 downto 0) := (others => '0');  --0.1xxxxxx
      Y    : in  std_logic_vector(C_MANTISSA_WIDTH-1 downto 0) := (others => '0');  --0.1yyyyyy
      Q    : out std_logic_vector(C_MANTISSA_WIDTH+c_added_precision+2 -1 downto 0) --
      --the 2 is for the leading 1.qqqqq or 0.qqqqq
      );
  end component unrolled;
  
  component rom_wrap is
    generic (
      C_FAMILY      : STRING  := "virtex2";
      ADDR_WIDTH    : integer := 10;
      DATA_WIDTH    : integer := 10;
      C_LATENCY     : integer := 0;
      C_HAS_CE      : integer := 0;
      C_SYNC_ENABLE : integer := 0;
      C_HAS_SCLR    : integer := 0;
      C_HAS_ACLR    : integer := 0;
      C_ELABORATION_DIR : string := "./"
      );
    port (
      CLK : IN  std_logic := '0';
      SCLR: IN  std_logic := '0';
      CE  : IN  std_logic := '0';
      X   : IN  std_logic_vector(ADDR_WIDTH-1 downto 0) := (others => '0');  --0.1xxxxxx
      Q   : OUT std_logic_vector(DATA_WIDTH-1 downto 0)
      );
  end component rom_wrap;

  component add_wrap
    generic (
      C_A_WIDTH     : integer;
      C_B_WIDTH     : integer;
      C_OUT_WIDTH   : integer;
      C_LATENCY     : integer;
      C_SYNC_ENABLE : integer;
      C_HAS_CE      : integer;
      C_HAS_ACLR    : integer;
      C_HAS_SCLR    : integer
      );
    port (
      CLK    : in  std_logic;
      CE     : in  std_logic;
      ACLR   : in  std_logic;
      SCLR   : in  std_logic;
      A      : in  std_logic_vector(C_A_WIDTH-1 downto 0);
      B      : in  std_logic_vector(C_B_WIDTH-1 downto 0);
      RESULT : out std_logic_vector(C_OUT_WIDTH-1 downto 0)
      );
  end component;
  
  component compare_wrap is
    generic(
      C_FAMILY      : string;
      C_WIDTH       : integer;
      C_B_VALUE     : string;
      C_GATE_TYPE   : integer;         --temp until comparator fixed
      C_SYNC_ENABLE : integer;
      C_LATENCY     : integer;
      C_HAS_CE      : integer;
      C_HAS_ACLR    : integer;
      C_HAS_SCLR    : integer
      );
    port (
      CLK    : in  std_logic;
      CE     : in  std_logic;
      ACLR   : in  std_logic;
      SCLR   : in  std_logic;
      A      : in  std_logic_vector(C_WIDTH-1 downto 0);
      RESULT : out std_logic
      );
  end component;

  component mult_wrap is
    generic (
      C_FAMILY         : string  := "virtex2";
      C_XDEVICEFAMILY  : string  := "virtex2";
      A_WIDTH          : integer := 0;
      EST_WIDTH        : integer := 0;
      OUT_WIDTH        : integer := 0;
      C_HAS_ACLR       : integer := 0;
      C_HAS_SCLR       : integer := 0;
      C_SYNC_ENABLE    : integer := 0;
      C_HAS_CE         : integer := 0;
      C_LATENCY        : integer := 0;
      C_MULT_LAT       : integer := 0
      );
    port (
      CLK   : IN  std_logic := '0';
      ACLR  : IN  std_logic := '0';
      SCLR  : IN  std_logic := '0';
      CE    : IN  std_logic := '0';
      A     : IN  std_logic_vector(A_WIDTH-1 downto 0)   := (others => '0');  
      EST_X : IN  std_logic_vector(EST_WIDTH-1 downto 0) := (others => '0');  
      Q     : OUT std_logic_vector(OUT_WIDTH-1 downto 0)
      );
  end component mult_wrap;
  
  component reg_wrap is
    generic (
      C_LATENCY     : integer := 0;
      C_HAS_CE      : integer := 0;
      C_HAS_SCLR    : integer := 0;
      C_HAS_SINIT   : integer := 0;
      C_SINIT_VAL   : string  := "0";
      C_HAS_AINIT   : integer := 0;
      C_AINIT_VAL   : string  := "0";
      C_SYNC_ENABLE : integer := 0;
      C_HAS_ACLR    : integer := 0;
      C_WIDTH       : integer
      );
    port (
      CLK   : IN  std_logic := '0';
      CE    : IN  std_logic := '0';
      SCLR  : IN  std_logic := '0';
      SINIT : IN  std_logic := '0';
      AINIT : IN  std_logic := '0';
      ACLR  : IN  std_logic := '0';
      D     : IN  std_logic_vector(C_WIDTH-1 downto 0) := (others => '0');
      Q     : OUT std_logic_vector(C_WIDTH-1 downto 0)
      );
  end component reg_wrap;

  component exponent_handler is
    generic(
      C_EXPONENT_WIDTH : integer := 0;
      C_BIAS           : integer := 0;
      C_LATENCY        : integer := 0;
      C_HAS_SCLR       : integer := 0;
      C_SYNC_ENABLE    : integer := 0;
      C_HAS_ACLR       : integer := 0;
      C_HAS_CE         : integer := 0
      );
    port (
      CLK               : in  std_logic := '0';
      CE                : in  std_logic := '0';
      SCLR              : in  std_logic := '0';
      ACLR              : in  std_logic := '0';
      DIVISOR_EXPONENT  : in  std_logic_vector(C_EXPONENT_WIDTH-1 downto 0) := (others => '0');
      DIVIDEND_EXPONENT : in  std_logic_vector(C_EXPONENT_WIDTH-1 downto 0) := (others => '0');
      QUOTIENT_EXPONENT : out std_logic_vector(C_EXPONENT_WIDTH-1 downto 0);
      OVERFLOW          : out std_logic;
      UNDERFLOW         : out std_logic
      );
  end component exponent_handler;
  
  component exception_handler is
    generic(
      C_FAMILY         : string  := "";
      C_EXPONENT_WIDTH : integer := 0;
      C_MANTISSA_WIDTH : integer := 0;
      C_LATENCY        : integer := 0;
      C_HAS_SCLR       : integer := 0;
      C_SYNC_ENABLE    : integer := 0;
      C_HAS_ACLR       : integer := 0;
      C_HAS_CE         : integer := 0
      );
    port (
      CLK               : in  std_logic := '0';
      CE                : in  std_logic := '0';
      SCLR              : in  std_logic := '0';
      ACLR              : in  std_logic := '0';
      DIVISOR_EXPONENT  : in  std_logic_vector(C_EXPONENT_WIDTH-1 downto 0) := (others => '0');
      DIVISOR_MANTISSA  : in  std_logic_vector(C_MANTISSA_WIDTH-1 downto 0) := (others => '0');
      DIVIDEND_EXPONENT : in  std_logic_vector(C_EXPONENT_WIDTH-1 downto 0) := (others => '0');
      DIVIDEND_MANTISSA : in  std_logic_vector(C_MANTISSA_WIDTH-1 downto 0) := (others => '0');
      NAN_DETECT        : out std_logic;
      ZERO_DETECT       : out std_logic;
      INFINITY_DETECT   : out std_logic
      );
  end component exception_handler;
  
  component sign_handler is
    generic (
      C_LATENCY     : integer := 0;
      C_HAS_CE      : integer := 0;
      C_HAS_SCLR    : integer := 0;
      C_SYNC_ENABLE : integer := 0;
      C_HAS_ACLR    : integer := 0
      );
    port (
      CLK           : in  std_logic := '0';
      CE            : in  std_logic := '0';
      SCLR          : in  std_logic := '0';
      ACLR          : in  std_logic := '0';
      DIVISOR_SIGN  : in  std_logic := '0';
      DIVIDEND_SIGN : in  std_logic := '0';
      QUOTIENT_SIGN : out std_logic
      );
  end component sign_handler;

  component shift_and_round is
    generic(
      C_WIDTH_IN       : integer := 16;
      C_WIDTH_OUT      : integer := 16;
      C_EXPONENT_WIDTH : integer := 8;
      C_LATENCY        : integer := 1;
      C_HAS_SCLR       : integer := 0;
      C_SYNC_ENABLE    : integer := 0;
      C_HAS_ACLR       : integer := 0;
      C_HAS_CE         : integer := 0
      );
    port (
      CLK             : in  std_logic := '0';
      CE              : in  std_logic := '0';
      SCLR            : in  std_logic := '0';
      ACLR            : in  std_logic := '0';
      UNDERFLOW_IN    : in  std_logic := '0';
      OVERFLOW_IN     : in  std_logic := '0';
      MAN_IN          : in  std_logic_vector(C_WIDTH_IN-1 downto 0) := (others => '0');
      EXP_IN          : in  std_logic_vector(C_EXPONENT_WIDTH-1 downto 0) := (others => '0');
      NAN_DETECT      : in  std_logic := '0';
      ZERO_DETECT     : in  std_logic := '0';
      INFINITY_DETECT : in  std_logic := '0';
      MAN_OUT         : out std_logic_vector(C_WIDTH_OUT-1 downto 0);
      EXP_OUT         : out std_logic_vector(C_EXPONENT_WIDTH-1 downto 0);
      UNDERFLOW_OUT   : out std_logic;
      OVERFLOW_OUT    : out std_logic
      );
  end component shift_and_round;

  function check_generics (
    p_family         : string;
    p_mantissa_width : integer;
    p_exponent_width : integer;
    p_latency        : integer;
    p_has_ce         : integer;
    p_sync_enable    : integer;
    p_has_sclr       : integer;
    p_has_aclr       : integer
    )
    return integer;

  function fn_required_width (
    p_width           : integer;
    p_added_precision : integer
    )
    return integer;

  function fn_iterations (
    p_width : integer
    )
    return integer;

  function fn_max_error_power
    return t_bus_pos;

  function fn_xmult_bus_width(
    p_max_err : t_bus_pos;
    p_width   : integer)
    return t_bus_pos;
  
  function fn_pres (
    p_iter   : integer;
    p_offset : t_bus_pos
    )
    return t_bus_pos;

  function fn_one(
    p_width : integer
    )
    return std_logic_vector;

  function fn_mult_type (
    p_family : string
    )
    return integer;

  
end pkg_div_repmult_v1_0;

-------------------------------------------------------------------------------
-- end of declaration, start of body
-------------------------------------------------------------------------------

package body pkg_div_repmult_v1_0 is

  --Sanity check on incoming generics - defensive coding
  function check_generics (
    p_family         : string;
    p_mantissa_width : integer;
    p_exponent_width : integer;
    p_latency        : integer;
    p_has_ce         : integer;
    p_sync_enable    : integer;
    p_has_sclr       : integer;
    p_has_aclr       : integer
    )
    return integer is
  begin
    assert (0 < p_mantissa_width) and (p_mantissa_width <= c_max_width)
      report "ERROR: Illegal mantissa width."
      severity failure;

    assert (0 < p_exponent_width) and (p_exponent_width <= 16)
      report "ERROR: Illegal exponent width."
      severity failure;

    assert (p_sync_enable = 0) or (p_sync_enable = 1)
      report "ERROR: Illegal c_sync_enable. Expected 0 or 1, got "&INTEGER'IMAGE(p_sync_enable)
      severity failure;

    assert (p_latency >= 1) and (p_latency <100)
      report "ERROR: latency must be between 1 and 99 inclusive. Got"&INTEGER'IMAGE(p_latency)
      severity failure;

    assert (p_has_ce = 0) or (p_has_ce = 1)
      report "ERROR: Illegal c_has_ce. Expected 0 or 1, got "&INTEGER'IMAGE(p_has_ce)
      severity failure;

    assert (p_has_sclr = 0) or (p_has_sclr = 1)
      report "ERROR: Illegal c_has_sclr. Expected 0 or 1, got "&INTEGER'IMAGE(p_has_sclr)
      severity failure;

    assert (p_has_aclr = 0) or (p_has_aclr = 1)
      report "ERROR: Illegal c_has_aclr. Expected 0 or 1, got "&INTEGER'IMAGE(p_has_aclr)
      severity failure;

    
    return 0;
  end check_generics;
  
  -- purpose: determines the precision required within the divider circuit
  function fn_required_width (
    p_width           : integer;
    p_added_precision : integer
    )
    return integer is
    variable ret_val : integer;
    variable prefix_width : integer := 3;
  begin  -- fn_required_width
    --the 1 is for the leading, implicit 1. The added precision is for the NOT(x)&'1'.
    ret_val := prefix_width + p_width + p_added_precision;
--    assert false report "required width = "&INTEGER'IMAGE(ret_val) severity note;
    return ret_val;
  end fn_required_width;

  function fn_max_error_power
    return t_bus_pos is
    variable max_error_power : t_bus_pos;
  begin
    max_error_power(0) := 0;
    max_error_power(1) := -9;           --guaranteed from width of ROM
    for j in 2 to max_iterations loop
      --NOT approximation gives 1 bit less than quadratic convergence
      --i.e double the bits of precision, then lose a bit of precision.
      max_error_power(j) := max_error_power(j-1) * 2 + 1;  
    end loop;  -- j
    return max_error_power;
  end;

  -- purpose: determines the required number of iterations to reach the precision of the width of the output
  function fn_iterations (
    p_width : integer)
    return integer is
    variable ret_val : integer;
  begin  -- fn_iterations
    case p_width is
      when 0                        to c_init_precision-1             => ret_val := 1;  --up to 9
      when c_init_precision         to c_init_precision*2-1           => ret_val := 2;  --10  to 19
      when c_init_precision*2       to (c_init_precision*2-1)*2-1     => ret_val := 3;  --20  to 39
      when (c_init_precision*2-1)*2 to ((c_init_precision*2-1)*2)*2-1 => ret_val := 4;  -- to 65
                                               
--      when v_init_precision*2 to v_init_precision*4-1 => ret_val := 3;  --18 to 35
--      when v_init_precision*4 to v_init_precision*8-1 => ret_val := 4;  --36 to 72
      when others                           => ret_val := 4;
    end case;
--    assert false report "iterations = "&INTEGER'IMAGE(ret_val) severity note;
    return ret_val;
  end fn_iterations;

  -- This function determines the upper bit position involved in the
  -- denominator calculations. As 1-e approaches 1, more bits after the binary
  -- point can be ignored since their value is 1. The interesting bits are e.
  -- This function determines the upper bit of the funnel which takes e as input.
  -- In theory, it could be calculated from the upper bit of the max_error_power,
  -- but that all becomes a little incenstuous and brittle. However, the code
  -- is kept (commented out) in case of change of mind.
  function fn_xmult_bus_width(p_max_err : t_bus_pos;
                              p_width   : integer)
    return t_bus_pos is
    variable ret_val : t_bus_pos;
  begin
    ret_val(0) := p_width;
    ret_val(1) := p_width-9;            -- -9 -2
    ret_val(2) := p_width-17;           -- -17 -2
    ret_val(3) := p_width-33;           -- -33 -2
    ret_val(4) := p_width-65;           -- -65 -2
--    for i in 1 to max_iterations loop
--      ret_val(i) := p_width+p_max_err(i)+2-2;  --+2(backoff)-2(binary
--                                                     --point offset
--      if ret_val(i) < 0 then
--        ret_val(i) := 0;
--      end if;
--    end loop;  -- i
    return ret_val;
  end fn_xmult_bus_width;
  
  --purpose: returns the precision of the estimate required at each stage
  --In line with Parhami, not all the bits of the estimate need be used, since
  --the error caused by truncation can be limited to the size of the error caused
  --by the algorithm iteration. This function returns an array of constants
  --(one for each stage) which dictates the width of the estimate required for calculation.
  --Although it is currently arbitrary constants, it could be calculated from
  --the max_error_power, the input funnel constant array (x_mult_bus_width) and
  --the stage number. 
  function fn_pres (
    p_iter   : integer;
    p_offset : t_bus_pos
    )
    return t_bus_pos is
    variable temp_pres : t_bus_pos;
  begin  -- fn_pres
    temp_pres(0) := 12;
    temp_pres(1) := 12;
    temp_pres(2) := 18;
    temp_pres(3) := 36;
    temp_pres(4) := p_offset(4);
    for i in 0 to p_iter loop
      if temp_pres(i) > p_offset(i) then
        temp_pres(i) := p_offset(i);
      end if;
--      assert false report "i = "&INTEGER'IMAGE(i)&" MSB = "&INTEGER'IMAGE(p_offset(i))&" Pres = "&INTEGER'IMAGE(temp_pres(i)) severity warning;
    end loop;  -- i
    return temp_pres;
  end fn_pres;

  function fn_one(p_width : integer)
    return std_logic_vector is
    variable ret_val : std_logic_vector(p_width-1 downto 0);
  begin  -- fn_one
    ret_val := (others => '0');
    ret_val(p_width-1 downto p_width -2):= "01";
    return ret_val;
  end fn_one;

  function fn_mult_type (
    p_family : string)
    return integer is
  begin  -- fn_mult_type
    if p_family = "virtex2" or p_family = "spartan3" or p_family = "virtex2p" then
      return 1;--V2_PARALLEL
    end if;
    if p_family = "virtex4" then
      return 5;--V4_PARALLEL;
    end if;
    return 0;--PARALLEL;
    --HYPBRID? Maybe one day...
  end fn_mult_type;
end pkg_div_repmult_v1_0;
