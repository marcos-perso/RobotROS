--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor: Xilinx
-- \   \   \/    Version: 2.0
--  \   \        Filename: $RCSfile: floating_point_pkg_v2_0.vhd,v $           
--  /   /        Date Last Modified: $Date: 2010-07-10 21:43:11 $ 
-- /___/   /\    Date Created: Dec 2005
-- \   \  /  \
--  \___\/\___\
-- 
--Device  : All
--Library : xilinxcorelib.floating_point_pkg_v2_0
--Purpose : Package of supporting functions
--
--------------------------------------------------------------------------------    
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
-------------------------------------------------------------------------------- 
   
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library xilinxcorelib;
use xilinxcorelib.floating_point_v2_0_consts.all;

package floating_point_pkg_v2_0 is

  -- Floating-point exponent width limits
  constant FLT_PT_MIN_EW : integer := 4;
  constant FLT_PT_MAX_EW : integer := 16;
  -- Floating-point fraction width limits
  constant FLT_PT_MIN_FW : integer := 4;
  constant FLT_PT_MAX_FW : integer := 64;
  -- Fixed-point width limits 
  constant FIX_PT_MIN_W  : integer := 4;
  constant FIX_PT_MAX_W  : integer := 64;
  -- Fixed-point fraction width limits  
  constant FIX_PT_MIN_FW : integer := 0;
  constant FIX_PT_MAX_FW : integer := 64;
  -- Fixed-point integer width limits (including sign) 
  constant FIX_PT_MIN_IW : integer := 1;
  constant FIX_PT_MAX_IW : integer := 63;  
  
  constant FLT_PT_ONE  : std_logic_vector(FLT_PT_MAX_W-1 downto 0) := (others=>'1');
  constant FLT_PT_ZERO : std_logic_vector(FLT_PT_MAX_W-1 downto 0) := (others=>'0');   

  -- Add this bias value to latency to indicate that registers
  -- are enabled via a bit pattern 
  -- e.g. C_LATENCY = FLT_PT_LATENCY_BIAS+"11110" to switch off register on input
  -- Bits over-and-above the maximum latency are discarded. 
  -- Note that this is not a customer supported feature 
   
  constant FLT_PT_LATENCY_BIAS : integer := 1000000000;
  
  type alignment_type is
  record 
    shift_width : integer;
    zero_det_width : integer;
    zero_det_stage : integer;
    shift_stage    : integer;
    stage          : integer;
  end record; 
  
  type normalize_type is
  record
    norm_stage : integer;
    full_norm_stage : integer;
    last_stage : integer;
  end record;
  
--------------------------------------------------------------------------------  
-- Basic utility functions
--------------------------------------------------------------------------------  
  -- Determine the number of bits needed to represent a number
  -- i.e. if x=8, then function returns 4  
  function flt_pt_get_n_bits(x: integer) return integer;
  function flt_pt_get_n_bits_signed( x: integer) return integer;
  function flt_pt_max(x, y : integer) return integer;
  function flt_pt_min(x, y : integer) return integer;
  function conv_int_to_slv_3(a,w : integer) return std_logic_vector;
    
--------------------------------------------------------------------------------
-- The following function can be used to determine the latency of an operation
-- for a given set of generics. Use default values where appropriate. 
-- Parameters width and fraction_width should be set to the common value used 
-- on inputs and outputs. Set status_early to 0. 
--------------------------------------------------------------------------------     
  function flt_pt_delay(family : string; 
    op_code: std_logic_vector;
    a_width, a_fraction_width, b_width, b_fraction_width, 
    result_width, result_fraction_width, optimization, 
    mult_usage, rate, status_early  : integer; 
    required : integer := FLT_PT_MAX_LATENCY) return integer;

  function flt_pt_number_of_operations(C_HAS_ADD, C_HAS_SUBTRACT,
    C_HAS_MULTIPLY, C_HAS_DIVIDE, C_HAS_SQRT, C_HAS_COMPARE,
    C_HAS_FIX_TO_FLT, C_HAS_FLT_TO_FIX : integer) return integer;
    
  function flt_pt_number_of_inputs(C_HAS_ADD, C_HAS_SUBTRACT,
    C_HAS_MULTIPLY, C_HAS_DIVIDE, C_HAS_SQRT, C_HAS_COMPARE,
    C_HAS_FIX_TO_FLT, C_HAS_FLT_TO_FIX : integer) return integer; 
    
  function flt_pt_number_of_inputs(op_code : integer) return integer;     
  
  function flt_pt_get_op_code(C_HAS_ADD, C_HAS_SUBTRACT, C_HAS_MULTIPLY,
    C_HAS_DIVIDE, C_HAS_SQRT, C_HAS_COMPARE, C_HAS_FIX_TO_FLT, 
    C_HAS_FLT_TO_FIX : integer) return std_logic_vector;   
      
--------------------------------------------------------------------------------  
-- The following functions are for internal use only, and should not be called
-- directly.
-------------------------------------------------------------------------------- 
  
  function floating_point_v2_0_check(C_FAMILY : string; C_HAS_ADD, 
     C_HAS_SUBTRACT, C_HAS_MULTIPLY, C_HAS_DIVIDE, C_HAS_SQRT,
     C_HAS_COMPARE, C_HAS_FLT_TO_FIX, C_HAS_FIX_TO_FLT,
     C_A_WIDTH, C_A_FRACTION_WIDTH,
     C_B_WIDTH, C_B_FRACTION_WIDTH,    
     C_RESULT_WIDTH, C_RESULT_FRACTION_WIDTH,
     C_COMPARE_OPERATION, C_OPTIMIZATION, C_MULT_USAGE,
     C_RATE, C_LATENCY,
     C_HAS_SCLR, C_HAS_CE,           
     C_HAS_OPERATION_ND, C_HAS_OPERATION_RFD, C_HAS_RDY,
     C_HAS_UNDERFLOW, C_HAS_OVERFLOW, C_HAS_INVALID_OP,
     C_HAS_DIVIDE_BY_ZERO, 
     C_HAS_EXCEPTION,
     C_STATUS_EARLY : integer) return boolean; 
  -- Add this constant to C_MULT_USAGE to force family to Virtex-4	
  constant FLT_PT_IS_VIRTEX4	: integer := 16;
  
--------------------------------------------------------------------------------
-- Function to determine latency of sub components
--------------------------------------------------------------------------------  
  function flt_pt_get_shift_msb_first_stages(
    a_width, result_width, last_stages_to_omit : integer;
    left : boolean) return integer; 
  
  -- Supplied the number of stages required by the zero_det component for given generics  
  function flt_pt_get_zero_det_delay (
    STAGE_DIST_WIDTH : integer;
    IP_WIDTH         : integer;
    OP_WIDTH         : integer;
    DISTANCE_WIDTH   : integer) return integer;

  -- Supplied the number of stages required by the shift component for given generics    
  function flt_pt_get_shift_delay (
    STAGE_DIST_WIDTH : integer;
    IP_WIDTH         : integer;
    OP_WIDTH         : integer;
    DISTANCE_WIDTH   : integer) return integer;
    
  function flt_pt_get_align_delay(ip_width, 
    op_width : integer) return integer;
    
  function flt_pt_get_normalization_delay(in_width: integer) return integer;
  function flt_pt_get_alignment(ip_width, det_width, op_width : integer) return 
      alignment_type;
  function flt_pt_get_normalize(ip_width : integer) return normalize_type;
       
--------------------------------------------------------------------------------
-- Functions to determine latency of operator functions
--------------------------------------------------------------------------------       
  function fpAddDelay(ew, mw, version : integer) return integer;
  function fpMulDelay(ew, mw : integer; mult_type : integer) return 
    integer; 
  function fpDivDelay(ew, mw : integer) return integer;
  function fpSqrtDelay(ew, mw : integer) return integer;
  function flt_pt_flt_to_fix_delay(a_width, a_fraction_width, 
    result_width, result_fraction_width : integer) return integer;
  function flt_pt_fix_to_flt_delay(a_width, version : integer) return integer;
  function flt_pt_flt_to_flt_delay(a_width, a_fraction_width, 
    result_width, result_fraction_width : integer) return integer;
      
  -- Determine multiplier type from parameters
  function flt_pt_get_mult_type(w, fw : integer; family : string; 
     mult_usage : integer) return integer;
     
--------------------------------------------------------------------------------
-- Functions test for and get special fixed and float values
--------------------------------------------------------------------------------       
  -- Tests for a signalling NaN or quiet NaN as defined by this implementation
  -- Note that sign is excluded  
  function flt_pt_is_nan(w, fw : integer; value : std_logic_vector)
    return boolean;
  -- Tests for a signalling NaN as defined by this implementation
  -- Note that sign is excluded   
  function flt_pt_is_signalling_nan(w, fw : integer; value : std_logic_vector)
    return boolean;
  -- Tests for a quiet NaN as defined by this implementation    
  function flt_pt_is_quiet_nan(w, fw : integer; value : std_logic_vector)
    return boolean;
  -- Tests for positive or negative zero  
  function flt_pt_is_zero(w, fw : integer; value : std_logic_vector)
    return boolean;
  -- Tests for positive or negative infinity 
  function flt_pt_is_inf(w, fw : integer; value : std_logic_vector)
    return boolean;
  -- Tests for a denormalized number 
  function flt_pt_is_denormalized(w, fw : integer; value : std_logic_vector)
    return boolean;
  -- Gets a quiet NaN as defined by this implementation 
  function flt_pt_get_quiet_nan(w, fw : integer) return std_logic_vector;  
  -- Gets a signalling NaN as defined by this implementation 
  function flt_pt_get_signalling_nan(w, fw : integer) return std_logic_vector;
  -- Gets a signed zero
  function flt_pt_get_zero(w, fw : integer; sign : std_logic)
    return std_logic_vector;  
  -- Gets a signed infinity
  function flt_pt_get_inf(w, fw : integer; sign : std_logic) 
    return std_logic_vector; 
  -- Gets the most negative fixed-point number 
  function flt_pt_get_most_negative_fix(w : integer) return std_logic_vector;  
   -- Gets the most positive fixed-point number 
  function flt_pt_get_most_positive_fix(w : integer) return std_logic_vector; 
      
end package floating_point_pkg_v2_0;

package body floating_point_pkg_v2_0 is
--------------------------------------------------------------------------------  
-- Basic utility functions
-------------------------------------------------------------------------------- 
	-- determines number of bits required to represent an integer
	-- if x=0 then bits=0 
	--  x    result
	--  0       0
	--  1       1
	--  2       2
	--  3       2
	--  4       3
	--  5       3
	--  8       4
  function flt_pt_get_n_bits( x: integer) return integer is
    variable bits      : integer :=0;
    variable remainder : integer;
  begin
    assert (x>=0) 
      report "get_n_bits: negative input is unsupported" severity FAILURE;
		
    remainder := x;
    while remainder >= 1 loop	
      remainder := (remainder)/2;
      bits := bits+1;
    end loop;
    return (bits);
  end function; 
  
 	-- if x=0 then bits=0 
	 --  x    result
	 --  0       1
	 --  1       2
	 --  2       3
	 --  3       4
	 --  4       4
	 --  5       4
	 --  8       5
	 --  -1      2
	 --  -2      2
	 --  -3      3
   function flt_pt_get_n_bits_signed( x: integer) return integer is
     variable bits      : integer :=1; -- one bit for sign
     variable remainder : integer;
     variable neg_sign  : boolean;
   begin
     if x<0 then
       remainder := -x;
       neg_sign := true;
     else
       remainder := x;
       neg_sign := false;  
		 end if;
     
     while remainder >= 1 loop	
       remainder := (remainder)/2;
       bits := bits+1;
     end loop;
     -- Check to see if maximum negative number,
     -- as this reqires less bits. (i.e. -2 => 10)
     if neg_sign and 2**bits=-x then
        bits:=bits -1;
     end if;
      
     return (bits);
   end function; 
  
  
  function flt_pt_max(x,y : integer) return integer is 
    variable ret_val : integer;
  begin
    if x < y then
      ret_val := y;
    else
      ret_val := x;
    end if;
    return(ret_val);
  end function;	
	
  function flt_pt_min(x,y : integer) return integer is 
    variable ret_val : integer;
  begin
    if x < y then
      ret_val := x;
    else
      ret_val := y;
    end if;
    return(ret_val);
  end function;	
  
  -- Function to convert integer op_code to slv
  function conv_int_to_slv_3(a, w : integer) return std_logic_vector is
    variable ret_val : std_logic_vector(2 downto 0);
  begin
    assert w=3 report "conv_int_to_slv_3: only supports op_code length of 3"
    severity FAILURE;
    case a is
    when 0 => ret_val := "000";
    when 1 => ret_val := "001"; 
    when 2 => ret_val := "010";
    when 3 => ret_val := "011";
    when 4 => ret_val := "100";
    when 5 => ret_val := "101";
    when 6 => ret_val := "110";
    when 7 => ret_val := "111";
    when others => 
      assert false report "conv_int_to_slv_3: number to be converted" &  
      "is out of range 0..7" severity FAILURE;
    end case;
    return(ret_val);
  end function;
    
--------------------------------------------------------------------------------
-- Function to determine the number of operations that are enabled
-------------------------------------------------------------------------------- 
  function flt_pt_number_of_operations(C_HAS_ADD, C_HAS_SUBTRACT,
    C_HAS_MULTIPLY, C_HAS_DIVIDE, C_HAS_SQRT, C_HAS_COMPARE,
    C_HAS_FIX_TO_FLT, C_HAS_FLT_TO_FIX : integer) return integer is
    
    variable n_op : integer;
  begin
    n_op := 0;
    if C_HAS_ADD = FLT_PT_YES then
      n_op := n_op+1;
    end if;
    if C_HAS_SUBTRACT = FLT_PT_YES then
        n_op := n_op+1;
    end if;
    if C_HAS_MULTIPLY = FLT_PT_YES then
      n_op := n_op+1;
    end if;    
    if C_HAS_DIVIDE = FLT_PT_YES then
      n_op := n_op+1;
    end if;   
    if C_HAS_SQRT = FLT_PT_YES then
      n_op := n_op+1;
    end if;   
    if C_HAS_COMPARE = FLT_PT_YES then
      n_op := n_op+1;
    end if;
    if C_HAS_FIX_TO_FLT = FLT_PT_YES then
      n_op := n_op+1;
    end if;   
    if C_HAS_FLT_TO_FIX = FLT_PT_YES then
      n_op := n_op+1;
    end if;     
  return(n_op);
  end function; 
   
--------------------------------------------------------------------------------
-- Function to determine the number of inputs
-------------------------------------------------------------------------------- 
  function flt_pt_number_of_inputs(C_HAS_ADD, C_HAS_SUBTRACT,
    C_HAS_MULTIPLY, C_HAS_DIVIDE, C_HAS_SQRT, C_HAS_COMPARE,
    C_HAS_FIX_TO_FLT, C_HAS_FLT_TO_FIX : integer) return integer is
    variable n_ip : integer;
  begin
    if ((C_HAS_ADD = FLT_PT_YES) or (C_HAS_SUBTRACT = FLT_PT_YES) or
      (C_HAS_MULTIPLY = FLT_PT_YES) or (C_HAS_DIVIDE = FLT_PT_YES) or
      (C_HAS_COMPARE = FLT_PT_YES)) then
      n_ip := 2;
    elsif ((C_HAS_SQRT = FLT_PT_YES) or (C_HAS_FIX_TO_FLT = FLT_PT_YES) or
      (C_HAS_FLT_TO_FIX = FLT_PT_YES)) then
      n_ip := 1;
    else
      n_ip := 0;
    end if;     
    return(n_ip);
  end function;
  
--------------------------------------------------------------------------------
-- Function to determine the number of inputs
-------------------------------------------------------------------------------- 
  function flt_pt_number_of_inputs(op_code : integer) return integer is
    variable n_ip : integer; 
  begin
    if ((op_code = FLT_PT_ADD_OP_CODE) or (op_code = FLT_PT_SUBTRACT_OP_CODE) or
      (op_code = FLT_PT_MULTIPLY_OP_CODE) or (op_code = FLT_PT_DIVIDE_OP_CODE) or
      (op_code = FLT_PT_COMPARE_OP_CODE)) then
      n_ip := 2;
    elsif ((op_code = FLT_PT_SQRT_OP_CODE) or (op_code = FLT_PT_FIX_TO_FLT_OP_CODE) or
      (op_code = FLT_PT_FLT_TO_FIX_OP_CODE)) then
      n_ip := 1;
    else
      n_ip := 0;
    end if;     
    return(n_ip);
  end function;
--------------------------------------------------------------------------------
-- Function to provide op_code for a particular operation
--------------------------------------------------------------------------------  
  function flt_pt_get_op_code(C_HAS_ADD, C_HAS_SUBTRACT, C_HAS_MULTIPLY,
    C_HAS_DIVIDE, C_HAS_SQRT, C_HAS_COMPARE, C_HAS_FIX_TO_FLT,
    C_HAS_FLT_TO_FIX : integer) return std_logic_vector is
    
    variable op_code : integer:=0;
  begin
      
    if C_HAS_ADD = FLT_PT_YES then
      op_code := FLT_PT_ADD_OP_CODE;
    elsif C_HAS_SUBTRACT = FLT_PT_YES then
      op_code := FLT_PT_SUBTRACT_OP_CODE;
    elsif C_HAS_MULTIPLY = FLT_PT_YES then
      op_code := FLT_PT_MULTIPLY_OP_CODE;      
    elsif C_HAS_DIVIDE = FLT_PT_YES then
      op_code := FLT_PT_DIVIDE_OP_CODE;  
    elsif C_HAS_COMPARE = FLT_PT_YES then
      op_code := FLT_PT_COMPARE_OP_CODE;
    elsif C_HAS_FLT_TO_FIX = FLT_PT_YES then
      op_code := FLT_PT_FLT_TO_FIX_OP_CODE;       
    elsif C_HAS_FIX_TO_FLT = FLT_PT_YES then
      op_code := FLT_PT_FIX_TO_FLT_OP_CODE;     
    elsif C_HAS_SQRT = FLT_PT_YES then
      op_code := FLT_PT_SQRT_OP_CODE;   
    end if;
    return(conv_int_to_slv_3(op_code,FLT_PT_OP_CODE_WIDTH));
  end function;
   
--------------------------------------------------------------------------------
-- Functions to provide delays for a subcomponents
-------------------------------------------------------------------------------- 
  function flt_pt_get_shift_msb_first_stages(
    a_width, result_width, last_stages_to_omit : integer;
    left : boolean) return integer is
    variable width : integer;
  begin
    if left then
      width := a_width;
    else
      width := result_width;
    end if;
    return((flt_pt_get_n_bits(width-1)-LAST_STAGES_TO_OMIT+2-1)/2);
  end function; 
  
  function flt_pt_get_zero_det_delay(
    STAGE_DIST_WIDTH : integer;
    IP_WIDTH         : integer;
    OP_WIDTH         : integer;
    DISTANCE_WIDTH   : integer) return integer is

    constant NEEDED_DIST_BITS : integer := flt_pt_get_n_bits(IP_WIDTH-1);
    constant SHIFT_BITS       : integer := flt_pt_max(NEEDED_DIST_BITS, DISTANCE_WIDTH);  
    constant NUMB_OF_STAGES   : integer := (SHIFT_BITS+STAGE_DIST_WIDTH-1)/STAGE_DIST_WIDTH;	
  begin
    return(NUMB_OF_STAGES);
  end function;
  
  function flt_pt_get_shift_delay (
    STAGE_DIST_WIDTH : integer;
    IP_WIDTH         : integer;
    OP_WIDTH         : integer;
    DISTANCE_WIDTH   : integer) return integer is

    constant NEEDED_DIST_BITS : integer := flt_pt_get_n_bits(OP_WIDTH-1);
    constant SHIFT_BITS       : integer := flt_pt_max(NEEDED_DIST_BITS, DISTANCE_WIDTH);  
    constant NUMB_OF_STAGES   : integer := (SHIFT_BITS+STAGE_DIST_WIDTH-1)/STAGE_DIST_WIDTH;
  
  begin
    return(NUMB_OF_STAGES);
  end function; 
  
  function flt_pt_get_normalization_delay(in_width: integer) return integer is
  begin
    
    return((flt_pt_get_n_bits(in_width-2) + 1) / 2);
  end function;
    
  function flt_pt_get_align_delay(ip_width, op_width : integer) return 
    integer is  
    
    constant ZERO_DET_WIDTH : integer := flt_pt_get_n_bits(ip_width-1);
    constant ZERO_DET_STAGES : integer := flt_pt_get_zero_det_delay(
      STAGE_DIST_WIDTH => 2,
      IP_WIDTH         => ip_width,
      OP_WIDTH         => op_width,
      DISTANCE_WIDTH   => ZERO_DET_WIDTH); 
       
    constant ALIGN_WIDTH  : integer := flt_pt_get_n_bits(op_width-1);     
    constant ALIGN_STAGES : integer := flt_pt_get_shift_delay(
      STAGE_DIST_WIDTH => 2,    
      IP_WIDTH         => ip_width,
      OP_WIDTH         => op_width,
      DISTANCE_WIDTH   => ALIGN_WIDTH);
    
  begin
    return(flt_pt_max(ZERO_DET_STAGES, ALIGN_STAGES));  
  end function;
  
  function flt_pt_get_normalize(ip_width : integer) return normalize_type is
    variable norm_data : normalize_type; 
  begin 
    norm_data.norm_stage:= flt_pt_get_shift_msb_first_stages(
    ip_width, ip_width, 1, true);
    norm_data.full_norm_stage:= flt_pt_get_shift_msb_first_stages(
    ip_width, ip_width, 0, true);
    norm_data.last_stage := norm_data.full_norm_stage-norm_data.norm_stage;
    return(norm_data);  -- Add one for delay  
  end function;  
   
  function flt_pt_get_alignment(ip_width, det_width, op_width : integer) return 
    alignment_type is  
    variable alignment_delay : alignment_type;
  begin
    alignment_delay.shift_width := flt_pt_get_n_bits(op_width-1);
    alignment_delay.zero_det_width := flt_pt_get_n_bits(DET_WIDTH-1);
    alignment_delay.zero_det_stage := flt_pt_get_zero_det_delay(
       STAGE_DIST_WIDTH => 2,
       IP_WIDTH         => det_width,
       OP_WIDTH         => op_width,
       DISTANCE_WIDTH   => alignment_delay.zero_det_width);
       
    alignment_delay.shift_stage := flt_pt_get_shift_delay(
       STAGE_DIST_WIDTH => 2,    
       IP_WIDTH         => ip_width,
       OP_WIDTH         => op_width,
       DISTANCE_WIDTH   => alignment_delay.shift_width);    
                                            
      alignment_delay.stage:= 
      flt_pt_max(alignment_delay.zero_det_stage, alignment_delay.shift_stage);
    return(alignment_delay);  
  end function;
  
--------------------------------------------------------------------------------
-- Functions to provide delays for a operations
--------------------------------------------------------------------------------   
  function flt_pt_flt_to_fix_delay(a_width, a_fraction_width, 
    result_width, result_fraction_width : integer) return integer is
    variable align_delay : integer;
  begin
    align_delay := flt_pt_get_align_delay(ip_width => a_fraction_width, 
    op_width => result_width);
    return(align_delay+3);
  end function;
  
  function flt_pt_fix_to_flt_delay(a_width, version: integer) return integer is
    variable normalization_delay : integer;
    variable delay : integer;
    variable normalize_data : normalize_type;
  begin
    case version is
    when 2 => 
      normalization_delay := flt_pt_get_normalization_delay(a_width+1);
      delay := normalization_delay+3;
    when 3 =>
      normalize_data :=flt_pt_get_normalize(ip_width => a_width);
      delay := normalize_data.norm_stage+4;
    when others =>
      report "Internal error : flt_pt_fix_to_flt_delay does not support version, latency set to 0";
      delay := 0;  
    end case;
    return delay;  
  end function;
  
  function flt_pt_flt_to_flt_delay(a_width, a_fraction_width, 
    result_width, result_fraction_width : integer) return integer is
    variable delay : integer;
  begin
    if (a_fraction_width<=result_fraction_width) and
        ((a_width-a_fraction_width)<=(result_width-result_fraction_width)) then
      delay := 2;
    else
      delay := 3;
    end if;
    return(delay);
  end function;  

  -- Latency calculation function for the floating point adder
  function fpAddDelay(ew, mw, version : integer) return integer is
    variable delay : integer;
    variable normalize_data : normalize_type;
    variable alignment_data : alignment_type; 
  begin
    case version is
    when 2 =>
      -- use common normalizer					 
      delay := flt_pt_get_normalization_delay(mw+2);
      -- use specific aligner
      delay := delay + (ew+3)/4;
      delay := delay + 6; -- fixed delays
    when 3 =>
      normalize_data := flt_pt_get_normalize(ip_width => mw+3); 
      alignment_data := flt_pt_get_alignment(
        ip_width => mw, det_width => mw+2, op_width => mw+2); 
        delay := normalize_data.norm_stage+alignment_data.stage;
        delay := delay + 6;
      return (delay);    
    when others =>
      report "Internal error : fpAddDelay does not support version, latency set to 0";
      delay := 0;  
    end case;
    return delay;  
  end function fpAddDelay;
	
  -- Latency calculation function for the floating point multiplier
  function fpMulDelay(ew, mw : integer; mult_type : integer) return 
    integer is
  begin
    case mult_type is
    when 1 =>
    -- no embedded multipliers    
      if mw <= 5 then -- 3+2
        return 5;
      elsif mw <= 11 then -- 6+5
        return 6;
      elsif mw <= 23 then -- 12+11
        return 7;
      elsif mw <= 47 then -- 24+23
        return 8;
      elsif mw <= 95 then -- 48+47
        return 9;
      elsif mw <= 191 then -- 96+95
        return 10;         
      else
        assert (false)
        report "fpMulDelay: Unsupported value of mw/ew for fpMul."
        severity FAILURE;
        return 0;  
      end if;
    when 2 => 	
      -- mult18x18s only
      if mw <= 17 then
	     return 4;
      elsif mw <= 34 then
        return 6;
      elsif mw <= 51 then
        return 7;
      elsif mw <= 68 then
        return 8;
      else
        assert (false)
        report "fpMulDelay: Unsupported value of mw/ew for fpMul."
        severity FAILURE;
        return 0;
      end if;
    when 4 =>
      -- mult18x18s + logic
      if mw = 53 then
        return 10; 
      else 
        assert (false)
        report "fpMulDelay: Unsupported value of mw/ew for fpMul."
        severity FAILURE;
        return 0;
      end if;      
    when 6 =>
      -- DSP48 only
      if mw <= 17 then
	     return 6;
      elsif mw <= 34 then
        return 9;
      elsif mw <= 51 then
        return 14;
      elsif mw <= 68 then
        return 21;
      else
        assert (false)
        report "fpMulDelay: Unsupported value of mw/ew for fpMul."
        severity FAILURE;
        return 0;
      end if;       
    when 7 =>
      -- DSP48 + logic 
      if mw = 53 then
        return 17; 
      else 
        assert (false)
        report "fpMulDelay: Unsupported value of mw/ew for fpMul."
        severity FAILURE;
        return 0;
      end if;
    when others =>
      assert (false)
      report "fpMulDelay: Unsupported multiplier type."
      severity FAILURE;
      return 0;     
    end case;
  end function fpMulDelay;
	
-- Latency calculation function for the floating point Divider
  function fpDivDelay(ew, mw : integer) return integer is
  begin
    return mw+3;
  end function fpDivDelay;
	
  -- Latency calculation function for the floating point Square Root
  function fpSqrtDelay(ew, mw : integer) return integer is
  begin
    return mw+3;
  end function fpSqrtDelay;

--------------------------------------------------------------------------------
-- Function to provide latency for a particular operation
--------------------------------------------------------------------------------   
  function flt_pt_delay(family : string; 
    op_code: std_logic_vector;
    a_width, a_fraction_width, b_width, b_fraction_width, 
    result_width, result_fraction_width, optimization, mult_usage,
    rate, status_early : integer; 
    required : integer := FLT_PT_MAX_LATENCY) return integer is
    
    constant result_exponent_width : integer := 
      result_width-result_fraction_width;
    variable del         : integer;
    variable max_lat     : integer;
    variable mult_type    : integer;
    variable numb_ones   : integer;
    variable req_lat     : integer;   
  begin
    -- Determine maximum latency for particular parameters
    case optimization is
    when FLT_PT_SPEED_OPTIMIZED =>
      case to_integer(unsigned(op_code)) is
      when FLT_PT_ADD_OP_CODE => 
        max_lat := fpAddDelay(result_exponent_width, result_fraction_width, 3);
      when FLT_PT_SUBTRACT_OP_CODE =>
        max_lat := fpAddDelay(result_exponent_width, result_fraction_width, 3);
      when FLT_PT_MULTIPLY_OP_CODE =>
        mult_type := flt_pt_get_mult_type(result_width, result_fraction_width, 
          family, mult_usage); 
        max_lat := fpMulDelay(result_exponent_width, result_fraction_width, mult_type); 
      when FLT_PT_DIVIDE_OP_CODE =>
        max_lat := fpDivDelay(result_exponent_width, result_fraction_width);
      when FLT_PT_SQRT_OP_CODE =>
	     if status_early =FLT_PT_YES then
          max_lat := flt_pt_flt_to_flt_delay(a_width, a_fraction_width, 
          result_width, result_fraction_width);
        else 	          
	       max_lat :=  fpSqrtDelay(result_exponent_width, result_fraction_width);
	     end if;
      when FLT_PT_FIX_TO_FLT_OP_CODE =>
	      max_lat :=  flt_pt_fix_to_flt_delay(a_width, 3);      
      when FLT_PT_FLT_TO_FIX_OP_CODE =>
	      max_lat :=  flt_pt_flt_to_fix_delay(a_width, a_fraction_width, 
	        result_width, result_fraction_width); 
      when FLT_PT_COMPARE_OP_CODE =>
        max_lat := 3; 	       
      when others =>
        assert false 
        report "flt_pt_delay: Operation option not supported" & 
               " while FLT_PT_SPEED_OPTIMIZED" 
        severity FAILURE;
        max_lat := 42;
      end case;
    when FLT_PT_BASIC =>
      case to_integer(unsigned(op_code))  is
      when FLT_PT_ADD_OP_CODE => 
        max_lat := 5;
      when FLT_PT_SUBTRACT_OP_CODE => 
        max_lat := 5;  
      when FLT_PT_MULTIPLY_OP_CODE =>
        if mult_usage > 0 then
          max_lat := 5;
        else
          assert false 
            report "flt_pt_delay: Operation option not supported while" & 
                   " FLT_PT_BASIC" 
            severity FAILURE;
        end if;
      when FLT_PT_DIVIDE_OP_CODE =>
        max_lat := 30;
      when FLT_PT_COMPARE_OP_CODE =>
	      max_lat :=  2;  	    
      when others =>
        assert false 
         report "flt_pt_delay: Operation option not supported"
              & "while FLT_PT_BASIC" 
         severity FAILURE;
      end case;    
    when others =>
      assert false 
        report "flt_pt_delay: Optimization not supported" 
        severity FAILURE;       
    end case;
    -- Determine delay based on type of request.
    -- Check for special bit string
    if required >= FLT_PT_LATENCY_BIAS then
	    -- Registers given by bit pattern
	    req_lat := required-FLT_PT_LATENCY_BIAS; -- remove bias
      -- Remove all bits that are out of bounds
	    req_lat := req_lat mod (2**max_lat);
	    -- Count ones to establish latency	    
	    numb_ones := 0;
	    while req_lat> 0 loop
	      numb_ones := req_lat mod 2 + numb_ones; 
	      req_lat := req_lat/2;
	    end loop;
	    del := numb_ones;
	    
	  -- Check is reduced latency is required     
	  elsif required/=FLT_PT_MAX_LATENCY and 
        (optimization = FLT_PT_SPEED_OPTIMIZED) then
      -- Required is less than maximum, so use required 
      del := required;
    else
      del := max_lat; 
    end if;
    return(del);
  end function;
  
  function flt_pt_get_mult_type(w, fw : integer; family : string; 
     mult_usage : integer) return integer is
  begin
    
    if (family="virtex4") then
    case mult_usage is
      when FLT_PT_NO_USAGE => return(1);
      when FLT_PT_MEDIUM_USAGE => 
        if fw = 53 then 
          -- DSP48 + logic
          return(7);
        else
          -- DSP48 only
          return(6);
        end if;
      when FLT_PT_FULL_USAGE => return(6);
      when others =>
        assert false 
          report "flt_pt_get_mult_type: mult_usage value not supported" 
          severity FAILURE;
        return(0);   -- dummy      
      end case;
    elsif (family="virtex2p" or family="virtex2" or family="spartan3e" or family="spartan3"
      or family="qvirtex2" or family="qrvirtex2" or family="aspartan3") then
      -- Have embedded multipliers so
      case mult_usage is
        when FLT_PT_NO_USAGE => return(1);
        when FLT_PT_MEDIUM_USAGE => 
          if fw = 53 then
            -- mult18x18s + logic 
            return(4);
          else
            -- mult18x18s only
            return(2);
          end if;
        when FLT_PT_FULL_USAGE =>
        -- mult18x18s only 
          return(2);
        when others =>
          assert false 
            report "flt_pt_get_mult_type: mult_usage value not supported" 
              severity FAILURE;
          return(0);   -- dummy
      end case; 
    else         
      -- logic only
      return(1);        
    end if;
  end function; 
  
--------------------------------------------------------------------------------
-- Function to check the bounds of parameters
--------------------------------------------------------------------------------   
  function floating_point_v2_0_check(C_FAMILY : string; C_HAS_ADD, 
     C_HAS_SUBTRACT, C_HAS_MULTIPLY, C_HAS_DIVIDE, C_HAS_SQRT,
     C_HAS_COMPARE, C_HAS_FLT_TO_FIX, C_HAS_FIX_TO_FLT,
     C_A_WIDTH, C_A_FRACTION_WIDTH,
     C_B_WIDTH, C_B_FRACTION_WIDTH,    
     C_RESULT_WIDTH, C_RESULT_FRACTION_WIDTH,
     C_COMPARE_OPERATION, C_OPTIMIZATION, C_MULT_USAGE,
     C_RATE, C_LATENCY,
     C_HAS_SCLR,
     C_HAS_CE,           
     C_HAS_OPERATION_ND, C_HAS_OPERATION_RFD, C_HAS_RDY,
     C_HAS_UNDERFLOW, C_HAS_OVERFLOW, C_HAS_INVALID_OP,
     C_HAS_DIVIDE_BY_ZERO, 
     C_HAS_EXCEPTION,
     C_STATUS_EARLY : integer) return boolean is
    
  variable valid        : boolean;
  variable n_op         : integer;
  variable i            : integer;
  variable valid_width  : boolean;
      
  constant S_OP_NAME    : string := "speed optimized";
  constant U_OP_NAME    : string := "basic";
  
  constant WARNING      : string := "*********** NOTE ***********";     
  constant HEADER       : string := WARNING & CR & "floating_point_v2_0_check : "; 
  constant NOT_ON_S_OP  : string := 
    " not available with core optimized for speed."; 
  constant ONLY_ON_U_OP : string := 
    " only available on basic core."; 
  constant ONLY_ON_S_OP : string := 
    " only available on speed optimized core.";       
  type int_array is array (natural range <>) of integer;
  
  constant N_OPS : integer := flt_pt_number_of_operations(C_HAS_ADD, 
    C_HAS_SUBTRACT, C_HAS_MULTIPLY, C_HAS_DIVIDE, C_HAS_SQRT, C_HAS_COMPARE,
    C_HAS_FIX_TO_FLT, C_HAS_FLT_TO_FIX);
  
  function flt_pt_get_min_exp(fw : integer) return integer is
    begin
      return(flt_pt_get_n_bits(fw+2)+1);
  end function;
  
  function flt_pt_exp_check(flt_w, flt_fw, fw: integer) return boolean is
  begin
    -- Check that the exponent is large enough to support the fraction
    return (flt_pt_get_min_exp(fw) <= flt_w-flt_fw);
  end function;
  
  function fixed_pt_exp_check(flt_w, flt_fw, fix_w, fix_fw : integer;
    flt_name, fix_name : string) return boolean is
    variable pass : boolean := true;    
  begin
    if not (flt_pt_exp_check(flt_w, flt_fw, fix_w)) then   
      report HEADER
        & " The exponent of the floating-point number"
        & " which is " & integer'image(flt_w-flt_fw)      
        & " (as given by C_" & flt_name & "_WIDTH - C_" & flt_name 
        & "_FRACTION_WIDTH)" & CR
        & " is too small to support the fixed-point number"
        & " (as defined by C_" & fix_name & "_WIDTH and " 
        & " C_" & fix_name & "_FRACTION_WIDTH)." & CR
        & " Increase the exponent width to " 
        & integer'image(flt_pt_get_min_exp(fix_w)) & "." & CR
        & " Note that each bit of exponent doubles the number of "
        & " fraction bits supported. Or reduce the total width of"
        & " the fixed-point number.";
      pass := false;
    end if;     
    return pass;
  end function;  
  
  function flt_pt_check(w, fw : integer; flt_name : string) return boolean is
    variable pass : boolean := true;
  begin
    if not (flt_pt_exp_check(w, fw, fw)) then
      report HEADER
        & "The exponent width"
        & " which is " & integer'image(w-fw)         
        & " (as given by C_" & flt_name & "_WIDTH - C_" & flt_name 
        & "_FRACTION_WIDTH)" & CR
        & " is too small to support the chosen fraction width" 
        & " C_" & flt_name & "_FRACTION_WIDTH."
        & " Increase the exponent width to " 
        & integer'image(flt_pt_get_min_exp(fw)) & "." & CR
        & " Note that each extra bit of exponent doubles the number of "
        & " fraction bits supported.";
      pass := false;
    end if;
       
    -- Check exponent width larger than minimum
    if not (w-fw >= FLT_PT_MIN_EW) then
      report HEADER
        & "The exponent width"
        & " which is " & integer'image(w-fw)         
        & " (as given by C_" & flt_name & "_WIDTH - C_" & flt_name 
        & "_FRACTION_WIDTH)" & CR  
        & " is too small. Minimum value supported by the core is "
        & integer'image(FLT_PT_MIN_EW) & ".";
      pass := false;
    end if;
        
    -- Check exponent is not larger than maximum
    if not (w-fw <= FLT_PT_MAX_EW) then
      report HEADER
        & "The exponent width"
        & " which is " & integer'image(w-fw)      
        & " (as given by C_" & flt_name & "_WIDTH - C_" & flt_name 
        & "_FRACTION_WIDTH)" & CR 
        & " is too large. Maximum value supported by the core is "
        & integer'image(FLT_PT_MAX_EW) & ".";
      pass := false;
    end if;
           
    -- Check fraction width larger than minimum
    if not (fw >= FLT_PT_MIN_FW) then
      report HEADER
        & "The fraction width"
        & " which is " & integer'image(fw)        
        & " (as given by C_" & flt_name 
        & "_FRACTION_WIDTH)" & CR
        & " is too small. Minimum value supported by the core is "
        & integer'image(FLT_PT_MIN_FW) & "."; 
      pass := false;
    end if;
            
    -- Check fraction width is not larger than maximum 
     if not (fw <= FLT_PT_MAX_FW) then
       report HEADER
         & "The fraction width"
         & " which is " & integer'image(fw)          
         & " (as given by C_" & flt_name 
         & "_FRACTION_WIDTH)" & CR
         & " is too large. Maximum value supported by the core is "
         & integer'image(FLT_PT_MAX_FW) & "."; 
       pass := false;
     end if;
    return pass;       
  end function;
  
  function fixed_pt_check(fix_w, fix_fw : integer; fix_name : string) return boolean is
    variable pass : boolean := true;
  begin
    -- Check fraction width larger than minimum
    if not (fix_fw >= FIX_PT_MIN_FW) then
      report HEADER
        & "The fraction width"
        & " which is " & integer'image(fix_fw)       
        & " (as given by C_" & fix_name 
        & "_FRACTION_WIDTH)" & CR
        & " is too small. Minimum value is "
        & integer'image(FIX_PT_MIN_FW) & ".";
       pass := false;
    end if; 
            
    -- Check fraction width is not larger than maximum 
    if not (fix_fw <= FIX_PT_MAX_FW) then 
      report HEADER
         & "The fraction width"
         & " which is " & integer'image(fix_fw)        
         & " (as given by C_" & fix_name 
         & "_FRACTION_WIDTH)" & CR
         & " is too large. Maximum value is "
         & integer'image(FIX_PT_MAX_FW) & ".";
      pass := false;
    end if; 
    
   -- Check integer width larger than minimum
   if not (fix_w-fix_fw >= FIX_PT_MIN_IW) then
     report HEADER
       & "The integer width"
       & " which is " & integer'image(fix_w-fix_fw)       
        & " (as given by C_" & fix_name 
        & "_WIDTH - C_" & fix_name 
        & "_FRACTION_WIDTH)" & CR
       & " is too small. Minimum value is "
       & integer'image(FIX_PT_MIN_IW) & ".";
      pass := false;
   end if; 
      
     -- Check total width is not smaller than minimum      
    if not ((fix_w) >= FIX_PT_MIN_W) then
        report HEADER
          & "The total width"
          & " which is " & integer'image(fix_w)         
          & " (as given by C_" & fix_name 
          & "_WIDTH)" & CR
          & " is too small. Maximum value is "
          & integer'image(FIX_PT_MIN_W) & ".";
      pass := false;
    end if;
                  
     -- Check total width is not larger than maximum    
     if not ((fix_w) <= FIX_PT_MAX_W) then
       report HEADER
         & "The total width"
         & " which is " & integer'image(fix_w)         
         & " (as given by C_" & fix_name 
         & "_WIDTH)" & CR
         & " is too large. Maximum value is "
         & integer'image(FIX_PT_MAX_W) & ".";
      pass := false;
    end if;
    return pass;     
  end function;
  

  variable pass : boolean:=true;
begin
    
------------------------------------------------------------------------------- 
-- Check optimization
-------------------------------------------------------------------------------     
  if not ((C_OPTIMIZATION = FLT_PT_UNOPTIMIZED) or 
          (C_OPTIMIZATION = FLT_PT_SPEED_OPTIMIZED)) then 
    report HEADER & "Optimization is not supported." &
      " Set C_OPTIMIZATION to FLT_PT SPEED_OPTIMISED or " &
      " FLT_PT_UNOPTIMIZED.";
    pass:=false;
  end if;
    
------------------------------------------------------------------------------- 
-- Check operations
-------------------------------------------------------------------------------     

  if not (N_OPS < 2 or 
   (C_OPTIMIZATION = FLT_PT_SPEED_OPTIMIZED and
    -- Check that only add and subtract are selected
    N_OPS=2 and C_HAS_SUBTRACT=FLT_PT_YES and C_HAS_ADD=FLT_PT_YES) or
    -- Can have multiple operations with Unoptimized 
    (C_OPTIMIZATION = FLT_PT_UNOPTIMIZED)) then 
   report HEADER & 
    "Only add and subtract operations can be combined.";
    pass := false;
  end if;
      
  if not (N_OPS > 0) then
    report HEADER & 
    "At least one operation must be enabled.";
    pass := false;
  end if;
  
  if  (C_HAS_SQRT = FLT_PT_YES) then       
    if not (C_OPTIMIZATION = FLT_PT_SPEED_OPTIMIZED) then
      report HEADER &
        "Sqrt operation is only available with speed optimized core."
        & " Set C_OPTIMIZATION=FLT_PT_SPEED_OPTIMIZED.";
      pass := false;
    end if;
  end if;
      
------------------------------------------------------------------------------- 
-- Check wordlengths: width and fraction_width
-------------------------------------------------------------------------------                  
            
  if (C_OPTIMIZATION = FLT_PT_UNOPTIMIZED) then
    if not ((C_RESULT_FRACTION_WIDTH = 24) and (C_RESULT_WIDTH = 32)) then 
      report HEADER & "Only single precision supported with unoptimized core."
      & " Set C_RESULT_WIDTH=32 and C_RESULT_FRACTION_WIDTH=24.";
    end if;   
  end if;
    
  if C_OPTIMIZATION = FLT_PT_SPEED_OPTIMIZED then
    if C_HAS_FIX_TO_FLT = FLT_PT_YES then
      -- Need to check 
      --   1) fixed-point input is within bounds
      --   2) fixed-point is supported by output exponent      
      --   3) floating-point result is within bounds
        pass := fixed_pt_check(C_A_WIDTH, C_A_FRACTION_WIDTH, "A") and pass;

        pass := fixed_pt_exp_check(C_RESULT_WIDTH, C_RESULT_FRACTION_WIDTH, 
                C_A_WIDTH, C_A_FRACTION_WIDTH, "RESULT", "A" ) and pass;

        pass := flt_pt_check(C_RESULT_WIDTH, C_RESULT_FRACTION_WIDTH, "RESULT") and pass;
  
    elsif C_HAS_FLT_TO_FIX = FLT_PT_YES then
      -- Need to check:
      --   1) floating-point input is within bounds      
      --   2) fixed-point output is within bounds 
      --   3) fixed-point output is supported by input exponent 
        pass := flt_pt_check(C_A_WIDTH, C_A_FRACTION_WIDTH, "A") and pass;

        pass := fixed_pt_check(C_RESULT_WIDTH, C_RESULT_FRACTION_WIDTH, "RESULT") and pass;

        pass := fixed_pt_exp_check(C_A_WIDTH, C_A_FRACTION_WIDTH, C_RESULT_WIDTH, 
                     C_RESULT_FRACTION_WIDTH, "A", "RESULT") and pass; 
    
    elsif C_HAS_SQRT = FLT_PT_YES then 
      if C_STATUS_EARLY = FLT_PT_YES then
        pass := true;
      else  
      -- Need to check:
      --   1) floating-point input A is within bounds      
      --   2) input A is same as output 
      pass :=  flt_pt_check(C_A_WIDTH, C_A_FRACTION_WIDTH, "A") and pass;  
          
      if not (C_A_WIDTH=C_RESULT_WIDTH and 
        C_A_FRACTION_WIDTH=C_RESULT_FRACTION_WIDTH) then
        report HEADER
           & "The floating-point input and result formats must be the same." & CR
           & " Set C_A_WIDTH=C_RESULT_WIDTH and" & CR
           & " C_A_FRACTION_WIDTH=C_RESULT_FRACTION_WIDTH.";
        pass := false;
      end if;
      end if;          
    else
      -- Need to check:
      --   1) floating-point input A is within bounds
      --   2) input A is same as B and result 
      pass := flt_pt_check(C_A_WIDTH, C_A_FRACTION_WIDTH, "A") and pass;         
      
      if not (C_A_WIDTH=C_RESULT_WIDTH and 
        C_A_FRACTION_WIDTH=C_RESULT_FRACTION_WIDTH and
        C_A_WIDTH=C_B_WIDTH and
        C_A_FRACTION_WIDTH=C_B_FRACTION_WIDTH             
        ) then     
        report HEADER
           & "The width parameters of floating-point inputs and result"
           & " must be the same." & CR
           & " Set C_A_WIDTH=C_RESULT_WIDTH and"
           & " C_A_FRACTION_WIDTH=C_RESULT_FRACTION_WIDTH and" & CR
           & " C_B_WIDTH=C_RESULT_WIDTH and"
           & " C_B_FRACTION_WIDTH=C_RESULT_FRACTION_WIDTH.";
        pass := false;
      end if;     
    end if;                                        
  end if;
  
------------------------------------------------------------------------------- 
-- Check compare operation
-------------------------------------------------------------------------------  
  if C_HAS_COMPARE=FLT_PT_YES then
    if (C_OPTIMIZATION = FLT_PT_UNOPTIMIZED) then
      if not ((C_COMPARE_OPERATION >= 0) and (C_COMPARE_OPERATION <= 8)
               and (C_COMPARE_OPERATION /= 7)) then 
        report HEADER & "Compare operation is out of range. Current value"
         & " C_COMPARE_OPERATION= " & integer'image(C_COMPARE_OPERATION);
        pass := false;
      end if;
    elsif (C_OPTIMIZATION = FLT_PT_SPEED_OPTIMIZED) then
      if not ((C_COMPARE_OPERATION >= 0) and (C_COMPARE_OPERATION <= 8)) then 
        report HEADER & "Compare operation is out of range. Current value"
         & " C_COMPARE_OPERATION= " & integer'image(C_COMPARE_OPERATION);
        pass := false;
      end if;
    end if;
  end if;
------------------------------------------------------------------------------- 
-- Check multiplier usage
-------------------------------------------------------------------------------
  if not (((C_MULT_USAGE >= 0) and (C_MULT_USAGE <= 2)) or 
    ((C_MULT_USAGE >= 16) and (C_MULT_USAGE <= 18))) then
    report HEADER & "Multiplier usage value is out of range. Requested value"
      & " C_MULT_USAGE= " & integer'image(C_MULT_USAGE);
    pass := false;
  end if; 

  if (C_RATE /= 1) then
    if not(((C_OPTIMIZATION = FLT_PT_SPEED_OPTIMIZED) and
     (C_HAS_DIVIDE=FLT_PT_YES or C_HAS_SQRT=FLT_PT_YES)) or
      (C_OPTIMIZATION = FLT_PT_UNOPTIMIZED and C_HAS_DIVIDE=FLT_PT_YES)) then
      report HEADER & "C_RATE greater than 1 only supported by divide or"
       & " square-root on " & S_OP_NAME & " core, or divide on " & U_OP_NAME  
       & " core.";  
      pass := false;
    end if;
    if  (C_HAS_DIVIDE=FLT_PT_YES and C_OPTIMIZATION = FLT_PT_UNOPTIMIZED) then
      if not (C_RATE=30) then 
        report HEADER & "C_RATE must be 30 for the divide operation with the " 
          & U_OP_NAME & " core." & CR 
          & " Set to C_RATE=30, or leave as default (in which"
          & " case value of 30 will be assumed).";
        pass := false;
      end if;
    end if;     
  end if;
------------------------------------------------------------------------------- 
-- Check optional control pins
------------------------------------------------------------------------------- 
  if (C_HAS_CE = FLT_PT_YES) then
    if not (C_OPTIMIZATION = FLT_PT_SPEED_OPTIMIZED) then
      report HEADER & "CE" & ONLY_ON_S_OP; 
      pass := false;
    end if;
  end if;

--------------------------------------------------------------------------------
-- Optional output signals
--------------------------------------------------------------------------------    
    
  if (C_HAS_EXCEPTION=FLT_PT_YES)  then 
    if not (C_OPTIMIZATION = FLT_PT_UNOPTIMIZED) then
      report HEADER & "Output EXCEPTION" & ONLY_ON_U_OP
        & " Set C_HAS_EXCEPTION=FLT_PT_NO."; 
      pass := false;
    end if;
  end if;  
  
  if (C_HAS_DIVIDE_BY_ZERO=FLT_PT_YES)  then 
    if not (C_HAS_DIVIDE = FLT_PT_YES) then 
      report HEADER & "Output DIVIDE_BY_ZERO" 
        & " only available with divide operation."
        & " Set C_HAS_DIVIDE_BY_ZERO=FLT_PT_NO."; 
      pass := false;
    end if;
  end if; 
    
  return (pass);
end function;
--------------------------------------------------------------------------------
-- Functions to determine floating-point special cases 
--------------------------------------------------------------------------------    
  
  function flt_pt_is_nan(w, fw : integer; value : std_logic_vector)
    return boolean is
  begin
    return (flt_pt_is_quiet_nan(w, fw, value) or 
      flt_pt_is_signalling_nan(w, fw, value));
  end function;
  
  function flt_pt_is_quiet_nan(w, fw : integer; value : std_logic_vector)
    return boolean is
    variable ip     : std_logic_vector(value'length-1 downto 0);
    variable mod_ip : std_logic_vector(w-1 downto 0);   
  begin
    --             w-1 w-2 fw-1 fw-2  0        
    -- Quiet NaN is <X><11...11><1X...XX>     
    ip := value;
    mod_ip := ip(ip'left downto ip'left-w+1);

    return (mod_ip(w-2 downto fw-2) = FLT_PT_ONE(w-fw downto 0));
  end function;
  
  function flt_pt_is_signalling_nan(w, fw : integer; value : std_logic_vector) return boolean is
    variable ip     : std_logic_vector(value'length-1 downto 0);
    variable mod_ip : std_logic_vector(w-1 downto 0); 
  begin
    --                   w-1 w-2 fw-1 fw-2  0       
    -- Signalling NaN is <X><11...11><0n...nn> where n is non zero  
    ip := value;
    mod_ip := ip(ip'left downto ip'left-w+1);

    return (( mod_ip(w-2 downto fw-1) = FLT_PT_ONE(w-fw-1 downto 0)) and 
           ( mod_ip(fw-2)             = '0') and
           ( mod_ip(fw-3 downto 0) /= FLT_PT_ZERO(fw-3 downto 0)));
  end function;
  
  function flt_pt_is_zero(w, fw : integer; value : std_logic_vector) return boolean is
    variable ip     : std_logic_vector(value'length-1 downto 0);
    variable mod_ip : std_logic_vector(w-1 downto 0);
  begin
    ip := value;
    mod_ip := ip(ip'left downto ip'left-w+1);
    --         w-1 w-2 fw-1 fw-2  0       
    -- Zero is <X><00...00><00...00>
    return (mod_ip(w-2 downto 0) = FLT_PT_ZERO(w-2 downto 0));
  end function;
  
  function flt_pt_is_inf(w, fw : integer; value : std_logic_vector) return boolean is
    variable ip     : std_logic_vector(value'length-1 downto 0);
    variable mod_ip : std_logic_vector(w-1 downto 0);  
  begin
    ip := value;
    mod_ip := ip(ip'left downto ip'left-w+1);   
    --             w-1 w-2 fw-1 fw-2  0 
    -- Infinity is <X><11...11><00...00>
    return ((mod_ip(w-2 downto fw-1) = FLT_PT_ONE(w-fw-1 downto 0)) and 
            (mod_ip(fw-2 downto 0)   = FLT_PT_ZERO(fw-2 downto 0))); 
  end function; 
  
  function flt_pt_is_denormalized(w, fw : integer; value : std_logic_vector) return boolean is
    variable ip     : std_logic_vector(value'length-1 downto 0);
    variable mod_ip : std_logic_vector(w-1 downto 0);
  begin                 
    --                 w-1 w-2 fw-1 fw-2  0  
    -- Denormalized is <X><00...00><nn...nnn> where n is non-zero      
    ip := value;
    mod_ip := ip(ip'left downto ip'left-w+1);
    return ((mod_ip(w-2 downto fw-1) =  FLT_PT_ZERO(w-fw-1 downto 0)) and 
            (mod_ip(fw-2 downto 0)  /= FLT_PT_ZERO(fw-2 downto 0)));
  end function; 
   
--------------------------------------------------------------------------------
-- Functions to derive floating-point special values 
--------------------------------------------------------------------------------    
  
  function flt_pt_get_quiet_nan(w, fw : integer) return std_logic_vector is
    variable val : std_logic_vector(w-1 downto 0);
  begin
     --             w-1 w-2 fw-1 fw-2  0       
    -- Quiet NaN is <0><11...11><10...00>
    val(w-1)             := '0';                      
    val(w-2 downto fw-2) := (others=>'1');   
    val(fw-3 downto 0)   := (others=>'0'); 
    return(val);
  end function; 
    
  function flt_pt_get_inf(w, fw : integer; sign : std_logic) 
    return std_logic_vector is
    variable val : std_logic_vector(w-1 downto 0);
  begin
     --              w-1 w-2 fw-1 fw-2  0       
    -- Infinity is <sign><11...11><00...00>   
    val(w-1)             := sign;
    val(w-2 downto fw-1) := (others=>'1');
    val(fw-2 downto 0)   := (others=>'0');
    return(val);
  end function;
   
  function flt_pt_get_signalling_nan(w, fw : integer) return std_logic_vector is
    variable val : std_logic_vector(w-1 downto 0);
  begin
    --                  w-1 w-2 fw-1 fw-2  0        
    -- Signalling NaN is <0><11...11><01...11>     
    val(w-1)             := '0';
    val(w-1 downto fw-1) := (others=>'1');
    val(fw-2)            := '0';
    val(fw-3 downto 0)   := (others=>'1');
    return(val);
  end function; 
    
  function flt_pt_get_zero(w, fw : integer; sign : std_logic) 
    return std_logic_vector is
    variable val : std_logic_vector(w-1 downto 0);
  begin
    --            w-1 w-2 fw-1 fw-2  0        
    -- Zero is <sign><00...00><00...00>  
    val(w-1)          := sign;
    val(w-2 downto 0) := (others=>'0');
    return(val);
  end function;  
   
  function flt_pt_get_most_negative_fix(w : integer) return std_logic_vector is
    variable val : std_logic_vector(w-1 downto 0);
  begin
    -- Most negative is <10...00>    
    val(w-1) := '1';
    if w>1 then -- for the day when width can be 1!
      val(w-2 downto 0) := (others=>'0');
    end if;
    return(val);
  end function;
  
  function flt_pt_get_most_positive_fix(w : integer) return std_logic_vector is
    variable val : std_logic_vector(w-1 downto 0);
  begin
    -- Most positive is <01...11>        
    val(w-1) := '0';
    if w>1 then   -- for the day when width can be 1!
      val(w-2 downto 0) := (others=>'1'); 
    end if;
    return(val);
  end function;
end package body floating_point_pkg_v2_0;


