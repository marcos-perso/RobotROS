--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor: Xilinx
-- \   \   \/    Version: 3.0
--  \   \        Filename: $RCSfile: floating_point_pkg_v3_0.vhd,v $           
--  /   /        Date Last Modified: $Date: 2010-07-10 21:43:11 $ 
-- /___/   /\    Date Created: Dec 2005
-- \   \  /  \
--  \___\/\___\
-- 
--Device  : All
--Library : xilinxcorelib.floating_point_pkg_v3_0
--Purpose : Package of supporting functions
--
--------------------------------------------------------------------------------    
--  Copyright(C) 2006 by Xilinx, Inc. All rights reserved.
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
--  of this text at all times. (c) Copyright 1995-2006 Xilinx, Inc.
--  All rights reserved.
-------------------------------------------------------------------------------- 
   
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library xilinxcorelib;
use xilinxcorelib.floating_point_v3_0_consts.all;

package floating_point_pkg_v3_0 is

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
 
  -- Add FLT_PT_LATENCY_BIAS to latency to indicate that latency
  -- provides a bit pattern for enabling specific registers.
  -- e.g. C_LATENCY = FLT_PT_LATENCY_BIAS+30 provides a pattern
  -- "11110", and so will switch off first register
  -- and enable the next 4. The total latency will be 4.
  -- Bits over-and-above the maximum latency are discarded. 
  -- Note that this is not a customer supported feature 
   
  constant FLT_PT_LATENCY_BIAS : integer := 1000000000;
  
	type int_array is array (natural range <>) of integer; 

  -- Types to support pipeline delay calculation   
  constant FLT_PT_REG_LEN : integer := 200;
  type flt_pt_reg_type is array(0 to FLT_PT_REG_LEN-1) of boolean;
  constant FLT_PT_REG_DEFAULT : flt_pt_reg_type := (others=>true);	
  
  -- Alignment component descriptor
  type alignment_type is
  record
    ip_width       : integer; -- input width
    det_width      : integer; -- zero detection width
    op_width       : integer; -- output width
    shift_width    : integer; -- shift distance width
    zero_det_width : integer; -- zero detect shift width
    zero_det_stage : integer; -- stages in zero detection
    shift_stage    : integer; -- stages in aligment shift
    last_stage     : integer; -- number of stages removed
    last_bits      : integer; -- number of bits removed
    stage          : integer; -- number of stages remaining
    stage_mask     : flt_pt_reg_type; -- enable/disable registers 
  end record; 
  
  -- Normalize component descriptor
  type normalize_type is
  record
    norm_stage      : integer; -- stages to result and dist
    last_bits       : integer; -- number of bits in last stage                     
    last_stage      : integer; -- is extra 1-bit shift required?
    can_stage       : integer; -- stages to cancellation output
  end record;
  
  -- Renorm and round component descriptor
  type round_type is
  record
    IMP_TYPE  : integer; -- Implementation type
    STAGES    : integer; -- Stages 
    NORM_BITS : integer; -- Supported normalization distance (in bits) 
    EXP_STAGE : integer; -- Stage that exponent should be input
    LEGACY    : boolean; -- No pipelining
  end record; 
  
  -- Floating-point multiplier component descriptor  
  type flt_mult_type is
  record
    IMP_TYPE        : integer;
    STAGES          : integer;
    USE_QQ          : boolean;
    FIX_MULT_STAGES : integer;
    EXP_SPEED       : integer;
    ROUND_CONFIG    : round_type;
  end record;
  
  -- Floating-point adder component descriptor   
  type flt_add_type is
  record
    AB_EXTW             : integer; -- low_latency: extended wordlength for low-latency variant
    LAST_STAGE          : integer; -- low_latency: whether there is a last stage
    LAST_BITS           : integer; -- low_latency: number of bits implemented by last norm stage
    MUX_STAGE           : integer; -- input multplexing stage
    ALIGN_STAGE         : integer; -- stage at which alignment starts
    ALIGN_ADD_OP_STAGE  : integer; -- low-latency: stage for output of align_add
    ADD_STAGE           : integer; -- stage at which addition/subtraction is performed
    NORM_OP_STAGE       : integer; -- low-latency: stage for output of normalization
    LOD_STAGE           : integer; -- stage at which leading-one detect performed 
    DIST_STAGE          : integer; -- stage at which normalize distance is available
    CAN_STAGE           : integer; -- cancellation stage
    SEL_STAGE           : integer; -- low-latency variant
    SIG_STAGE           : integer; -- determine overflow signals
    SIG_UP_STAGE        : integer; -- update
    PRE_OP_STAGE        : integer; -- stage prior to output
    RND_STAGE           : integer; -- round input stage
    EXP_STAGE           : integer; -- exponent output from exp logic
    OP_STAGE            : integer; -- output
    STAGES              : integer;
    ROUND_CONFIG        : round_type;
    ROUND_USAGE         : integer;
    ADDSUB_USAGE        : integer;
  end record; 
  
  -- Some default component descriptors
  constant ROUND_DEFAULT   : round_type := (0,0,0,0,false); 
  constant FLT_ADD_DEFAULT : flt_add_type := 
    (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,(0,0,0,0,false),0,0); -- Have to be explicit - limitation of XST
  constant FLT_PT_MULT_TYPE_DEFAULT : flt_mult_type := (0,0,false,0,0,(0,0,0,0,false));
 
     
--------------------------------------------------------------------------------
-- Functions to provide information about floating-point operator core
--------------------------------------------------------------------------------
-- The following function can be used to determine the latency of an operation
-- for a given set of generics. Use default values where appropriate. 
-- Parameters width and fraction_width should be set to the common value used 
-- on inputs and outputs. If 'required' have value other than default, then
-- function will return that value. 
--------------------------------------------------------------------------------     
  function flt_pt_delay(family : string; 
    op_code : std_logic_vector(FLT_PT_OP_CODE_WIDTH-1 downto 0);
    a_width, a_fraction_width, b_width, b_fraction_width, 
    result_width, result_fraction_width, optimization, 
    mult_usage, rate : integer;
    has_add, has_subtract, has_multiply, has_divide, has_sqrt, has_compare, 
    has_fix_to_flt, has_flt_to_fix, has_flt_to_flt : integer := 0;
    required : integer := FLT_PT_MAX_LATENCY) return integer;
  
  -- Provide number of operations for given set of switches
  function flt_pt_number_of_operations(C_HAS_ADD, C_HAS_SUBTRACT,
    C_HAS_MULTIPLY, C_HAS_DIVIDE, C_HAS_SQRT, C_HAS_COMPARE,
    C_HAS_FIX_TO_FLT, C_HAS_FLT_TO_FIX, 
    C_HAS_FLT_TO_FLT : integer) return integer;
  
  -- Determines number of inputs required to support requested operations  
  function flt_pt_number_of_inputs(C_HAS_ADD, C_HAS_SUBTRACT,
    C_HAS_MULTIPLY, C_HAS_DIVIDE, C_HAS_SQRT, C_HAS_COMPARE,
    C_HAS_FIX_TO_FLT, C_HAS_FLT_TO_FIX, 
    C_HAS_FLT_TO_FLT : integer) return integer; 
  
  -- Determines number of inputs based upon op_code  
  function flt_pt_number_of_inputs(op_code : integer) return integer;     
  
  -- Provides op_code from switches (only one should be enabled!)
  function flt_pt_get_op_code(C_HAS_ADD, C_HAS_SUBTRACT, C_HAS_MULTIPLY,
    C_HAS_DIVIDE, C_HAS_SQRT, C_HAS_COMPARE, C_HAS_FIX_TO_FLT, 
    C_HAS_FLT_TO_FIX, 
    C_HAS_FLT_TO_FLT : integer) return std_logic_vector; 
  
  -- Determines if operation is add or subtract from switches    
  function flt_pt_has_add_or_subtract(C_HAS_ADD, C_HAS_SUBTRACT : integer) return integer;
  
  -- Extracts add/subtract signal from operation
  function flt_pt_get_addsub_op(operation : 
    std_logic_vector(FLT_PT_OPERATION_WIDTH-1 downto 0)) return std_logic;
  
  -- Extracts compare operation from operation  
  function flt_pt_get_compare_op(operation : 
    std_logic_vector(FLT_PT_OPERATION_WIDTH-1 downto 0)) return std_logic_vector;       

--------------------------------------------------------------------------------  
-- The following functions are for internal use only, and should not be called
-- directly.
-------------------------------------------------------------------------------- 
--------------------------------------------------------------------------------  
-- Basic utility functions
--------------------------------------------------------------------------------  
  -- Determine the number of bits needed to represent a number
  -- i.e. if x=8, then function returns 4  
  function flt_pt_get_n_bits(x : integer) return integer;
  function flt_pt_get_n_bits_signed(x : integer) return integer;
  -- Max/min functions
  function flt_pt_max(x, y : integer) return integer;
  function flt_pt_min(x, y : integer) return integer;
  -- Converts unsigned integer into 3-bit standard logic vector
  -- Throws and error if w not equal to 3  
  function conv_int_to_slv_3(a, w : integer) return std_logic_vector;

--------------------------------------------------------------------------------  
-- Functions for detecting family characteristics
--------------------------------------------------------------------------------    
  -- Determines which families should exploit RLOCs
  function flt_pt_fast_family(family : string) return integer;
  -- Determine whether RLOCs should be used on a particular family
  function flt_pt_get_rlocs_on(family : string) return boolean;
  -- Determine whether a LUT6 (or LUT4) is available for particular family 
  function flt_pt_has_lut6(family : string) return boolean; 
  -- Determine embedded multiplier type for particular family     
  function flt_pt_get_dsp_type(family : string) return integer;

--------------------------------------------------------------------------------  
-- Parameter check function
--------------------------------------------------------------------------------  
  function floating_point_v3_0_check(C_FAMILY : string; C_HAS_ADD, 
     C_HAS_SUBTRACT, C_HAS_MULTIPLY, C_HAS_DIVIDE, C_HAS_SQRT,
     C_HAS_COMPARE, C_HAS_FLT_TO_FIX, C_HAS_FIX_TO_FLT,
     C_HAS_FLT_TO_FLT,
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
     C_STATUS_EARLY, C_SPEED : integer) return boolean; 
  
--------------------------------------------------------------------------------
-- Functions to manage components
--------------------------------------------------------------------------------  
--------------------------------------------------------------------------------    
-- renorm_and_round
--------------------------------------------------------------------------------  
  
  function flt_pt_get_renorm_and_round_type(family : string; 
    mult_usage : integer) return integer;
    
  function flt_pt_get_renorm_and_round_delay(family: string; 
    mult_usage, fw : integer; legacy : boolean) return integer;
  
  function flt_pt_get_renorm_and_round_norm_bits(family : string; 
    mult_usage : integer) return integer;

  function flt_pt_get_renorm_and_round(has_multiply, has_addsub: integer := FLT_PT_NO;
    optimization : integer; 
    family : string; mult_usage, w, fw : integer) return round_type;

--------------------------------------------------------------------------------      
-- addsub  
--------------------------------------------------------------------------------  

  function flt_pt_get_addsub_type(family : string; 
    mult_usage : integer) return integer;
    
  function flt_pt_get_addsub_delay(family: string; 
    mult_usage, width : integer) return integer;
  function flt_pt_get_addsub_bits(family : string) return integer;
  
  -- Determines number of shift bits that addsub can handle
  function flt_pt_get_addmux_bits(family : string) return integer;
  
  -- Determines number of bits of shift required for particular configuration of
  -- shifter
  function flt_pt_get_shift_msb_first_bits(
    a_width, result_width, last_bits_to_omit : integer;
    left : boolean) return integer; 
  
  -- Supplies the number of stages required by the zero_det component for given generics  
  function flt_pt_get_zero_det_delay (
    STAGE_DIST_WIDTH : integer;
    IP_WIDTH         : integer;
    OP_WIDTH         : integer;
    DISTANCE_WIDTH   : integer) return integer;

  -- Supplies the number of stages required by the shift component for given generics    
  function flt_pt_get_shift_delay (
    STAGE_DIST_WIDTH : integer;
    IP_WIDTH         : integer;
    OP_WIDTH         : integer;
    DISTANCE_WIDTH   : integer) return integer;
  
  -- Provides delay of align component  
  function flt_pt_get_align_delay(ip_width, 
    op_width : integer) return integer;
  
  -- Provides delay of normalization component  
  function flt_pt_get_normalization_delay(in_width: integer) return integer;
  
  -- Provides descriptor for alignment component 
  function flt_pt_get_alignment(ip_width, det_width, op_width : integer;
    poss_last_bits : integer := 0) return alignment_type;
  
  -- Provides descriptor for normalize component
  function flt_pt_get_normalize(data_width : integer; 
    poss_last_bits : integer:=1) return normalize_type;
    
--------------------------------------------------------------------------------
-- Fixed-point multiplier
--------------------------------------------------------------------------------    
  -- Determines when to use the QinetiQ multiplier
  function flt_pt_use_qq_mult(family : string; mult_usage, w, fw: integer) 
    return boolean;
    
  -- Provides type and delay of Xilinx fixed-point multiplier (v9_0) 
  function flt_pt_get_fix_mult_type(family : string; mult_usage : integer) 
    return integer;
     
	function flt_pt_get_fix_mult_delay(fw : integer; family : string; 
                mult_usage : integer) return integer;
                        
  -- Determine multiplier type from parameters for QinetiQ multiplier
  function flt_pt_get_xmult_type(w, fw : integer; family : string; 
     mult_usage : integer) return integer;
                                    
--------------------------------------------------------------------------------
-- Floating-point add/subtract
--------------------------------------------------------------------------------       
  function flt_pt_get_flt_add(
      C_FAMILY                : string; 
      C_MULT_USAGE            : integer; 
      C_HAS_ADD               : integer;
      C_HAS_SUBTRACT          : integer;
      C_HAS_FIX_TO_FLT        : integer;
      C_HAS_FLT_TO_FIX        : integer;      
      C_A_WIDTH               : integer;
      C_A_FRACTION_WIDTH      : integer) 
      return flt_add_type;
  
  -- Type of floating-point add/subtract operator     
  function flt_pt_get_add_type(family : string; mult_usage, w, fw : integer) 
    return integer;    
  
  -- Delay of floating-point add/subtract operator
  function flt_pt_get_add_delay(family : string; 
    mult_usage, w, fw : integer) return integer;
  
--------------------------------------------------------------------------------
-- Floating-point multiplier
--------------------------------------------------------------------------------  
  function flt_pt_get_mult_type(family : string; mult_usage : integer) 
    return integer;
  -- Provides delay of floating-point multiplier  
 	function flt_pt_get_flt_mult_delay(width, fraction_width : integer; 
 	  family : string; mult_usage : integer) return integer; 
  -- Describes a floating-point multiplier   
  function flt_pt_get_mult(family : string; optimization : integer;  
    mult_usage, w, fw : integer) return flt_mult_type; 	   
--------------------------------------------------------------------------------
-- Other operations
--------------------------------------------------------------------------------                
  function flt_pt_get_div_delay(w, fw : integer) return integer;
  function flt_pt_get_sqrt_delay(w, fw : integer) return integer;
  function flt_pt_flt_to_fix_delay(a_width, a_fraction_width, 
    result_width, result_fraction_width : integer) return integer;
  function flt_pt_fix_to_flt_delay(a_width, version : integer) return integer;
  function flt_pt_flt_to_flt_delay(a_width, a_fraction_width, 
    result_width, result_fraction_width : integer) return integer;

--------------------------------------------------------------------------------
-- Functions to test  and get special fixed and float values
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
  
  -- Determines delay provided by a particular register pattern
  function get_reg_delay(reg : flt_pt_reg_type; start, length : integer)
    return integer;
  -- Generates an integer representation of the register pattern ("100"=4)
  function get_reg_delay_pat(reg : flt_pt_reg_type; start, length : integer)
    return integer;
  
  -- Slices off a particular section of register pattern starting at 'start'   
  function get_reg_blk(reg : flt_pt_reg_type; start : integer) 
    return flt_pt_reg_type;
  
  -- Converts a reg type to an array of integers (1=true, 0=false)  
  function conv_reg_to_reg_int(reg : flt_pt_reg_type) return int_array;
  	
  -- Mask register pattern with supplied mask (keep bit when mask bit is true)
  function mask_reg(reg_in, stage_mask : flt_pt_reg_type ) return flt_pt_reg_type;     
end package floating_point_pkg_v3_0;

package body floating_point_pkg_v3_0 is
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
      report "ERROR in get_n_bits: negative input is unsupported" 
      severity ERROR;
		
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
  

  function conv_int_to_slv_3(a, w : integer) return std_logic_vector is
    variable ret_val : std_logic_vector(2 downto 0);
  begin
    assert w=3 report "ERROR in conv_int_to_slv_3: only supports op_code length of 3"
    severity ERROR;
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
      assert false report "ERROR in conv_int_to_slv_3: number to be converted" &  
      "is out of range 0..7" 
      severity ERROR;
    end case;
    return(ret_val);
  end function;
  
--------------------------------------------------------------------------------
-- Functions to determine nature of FPGA resources
--------------------------------------------------------------------------------     
  -- Determines which families are fast (logic, relative to route)
  function flt_pt_fast_family(family : string) return integer is
    variable exp_speed : integer;
  begin
    if family="virtex4" or family="avirtex4" or family="virtex5" then
      exp_speed := 2;
    else
      exp_speed :=0;
    end if;
    return(exp_speed);
  end function; 
  
  -- Determines which families have a LUT6
  function flt_pt_has_lut6(family : string) return boolean is
    variable has_lut6 : boolean;
  begin
    if (family="virtex5") then
      has_lut6 := true;
    else
      has_lut6 := false;
    end if;
    return(has_lut6);
  end function;
  
  -- Determines when RLOCS can be used 
  function flt_pt_get_rlocs_on(family : string) return boolean is
    variable ret_rlocs_on : boolean;
  begin
    if family="virtex5" or family="virtex4" or family="avirtex4" then
      ret_rlocs_on := true;
    else
      ret_rlocs_on := false;
    end if;
    return(ret_rlocs_on);
  end function;
  
  -- Determines the type of DSP elements on a family   
  function flt_pt_get_dsp_type(family : string) return integer is
    variable dsp_type : integer := FLT_PT_LOGIC;
  begin
    if (family="virtex5") then
      dsp_type := FLT_PT_DSP48E;
    elsif (family="virtex4" 
        or family="avirtex4") then
      dsp_type := FLT_PT_DSP48;
    elsif (family="virtex2" 
        or family="qvirtex2"
        or family="qrvirtex2" 
        or family="virtex2p"
        or family="spartan3" 
        or family="aspartan3"
        or family="spartan3a" 
        or family="spartan3e" 
        or family="aspartan3e") then
      dsp_type := FLT_PT_MULT18X18S;
    end if;
    return(dsp_type);
  end function;
    
--------------------------------------------------------------------------------
-- Function to determine the number of operations that are enabled
-------------------------------------------------------------------------------- 
  function flt_pt_number_of_operations(C_HAS_ADD, C_HAS_SUBTRACT,
    C_HAS_MULTIPLY, C_HAS_DIVIDE, C_HAS_SQRT, C_HAS_COMPARE,
    C_HAS_FIX_TO_FLT, C_HAS_FLT_TO_FIX, 
    C_HAS_FLT_TO_FLT : integer) return integer is
    
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
    if C_HAS_FLT_TO_FLT = FLT_PT_YES then
      n_op := n_op+1;
    end if;         
  return(n_op);
  end function; 
   
--------------------------------------------------------------------------------
-- Function to determine the number of inputs
-------------------------------------------------------------------------------- 
  function flt_pt_number_of_inputs(C_HAS_ADD, C_HAS_SUBTRACT,
    C_HAS_MULTIPLY, C_HAS_DIVIDE, C_HAS_SQRT, C_HAS_COMPARE,
    C_HAS_FIX_TO_FLT, C_HAS_FLT_TO_FIX,
    C_HAS_FLT_TO_FLT : integer) return integer is
    variable n_ip : integer;
  begin
    if ((C_HAS_ADD = FLT_PT_YES) or (C_HAS_SUBTRACT = FLT_PT_YES) or
      (C_HAS_MULTIPLY = FLT_PT_YES) or (C_HAS_DIVIDE = FLT_PT_YES) or
      (C_HAS_COMPARE = FLT_PT_YES)) then
      n_ip := 2;
    elsif ((C_HAS_SQRT = FLT_PT_YES) or (C_HAS_FIX_TO_FLT = FLT_PT_YES) or
      (C_HAS_FLT_TO_FIX = FLT_PT_YES) or (C_HAS_FLT_TO_FLT = FLT_PT_YES)) then
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
    if ((op_code = FLT_PT_ADD_OP_CODE) or 
        (op_code = FLT_PT_SUBTRACT_OP_CODE) or
        (op_code = FLT_PT_MULTIPLY_OP_CODE) or 
        (op_code = FLT_PT_DIVIDE_OP_CODE) or
        (op_code = FLT_PT_COMPARE_OP_CODE)) then
      n_ip := 2;
    elsif ((op_code = FLT_PT_SQRT_OP_CODE) or 
           (op_code = FLT_PT_FIX_TO_FLT_OP_CODE) or
           (op_code = FLT_PT_FLT_TO_FIX_OP_CODE) or 
           (op_code = FLT_PT_FLT_TO_FLT_OP_CODE)) then
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
    C_HAS_FLT_TO_FIX, C_HAS_FLT_TO_FLT : integer) return std_logic_vector is
    
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
    elsif C_HAS_FLT_TO_FLT = FLT_PT_YES then
      op_code := FLT_PT_FLT_TO_FLT_OP_CODE;        
    end if;
    -- Take modulus of op_code to strip off extended codes (i.e. flt_to_flt)
    return(conv_int_to_slv_3((op_code mod 8),FLT_PT_OP_CODE_WIDTH));
  end function;
   
--------------------------------------------------------------------------------
-- Functions to provide delays for a subcomponents
-------------------------------------------------------------------------------- 
--------------------------------------------------------------------------------
-- round_and_renorm
--------------------------------------------------------------------------------   
  function flt_pt_get_renorm_and_round_type(family : string; 
    mult_usage : integer) return integer is
    constant DSP_TYPE  : integer := flt_pt_get_dsp_type(family);
    variable round_type : integer;
  begin
    if DSP_TYPE = FLT_PT_LOGIC or DSP_TYPE = FLT_PT_MULT18X18S then
      round_type := FLT_PT_LOGIC;      
    elsif (mult_usage > FLT_PT_NO_USAGE) then
      if DSP_TYPE =FLT_PT_DSP48 then
        round_type := FLT_PT_DSP48;
      else
        round_type := FLT_PT_DSP48E;
      end if;
    else -- logic
      round_type := FLT_PT_LOGIC;
    end if;
    return(round_type);  
  end function;
  
  function flt_pt_get_renorm_and_round_delay(family: string; 
    mult_usage, fw : integer; legacy : boolean) return integer is
    constant ROUND_TYPE : integer := 
      flt_pt_get_renorm_and_round_type(family, mult_usage); 
    variable delay : integer;
  begin
    if legacy then
      delay := 1;
    elsif ROUND_TYPE=FLT_PT_DSP48 or ROUND_TYPE=FLT_PT_DSP48E then
      delay := 3;
    elsif fw<=FLT_PT_CARRY_LENGTH then
   -- Don't pipeline short chains
      delay := 1;
    else
      delay := 2; 
    end if;   
    return(delay);
  end function; 
   
  -- To establish if last two stages can be packed into the round operation
  function flt_pt_get_renorm_and_round_norm_bits(family : string; 
    mult_usage : integer) return integer is
    variable norm_bits  : integer;
    variable round_type : integer;
  begin
    round_type := flt_pt_get_renorm_and_round_type(family,mult_usage);
    if round_type=FLT_PT_DSP48 or round_type=FLT_PT_DSP48E then
      norm_bits := 1;
    elsif flt_pt_has_lut6(family) then 
      norm_bits := 2; -- logic with LUT6, can do 2-bit shift
    else
      norm_bits := 1; -- logic with LUT4, can do 1-bit shift
    end if;
    return(norm_bits);
  end function; 

  -- Renorm and round component
  function flt_pt_get_renorm_and_round(
    has_multiply, has_addsub: integer := FLT_PT_NO;
    optimization : integer; 
    family       : string; 
    mult_usage, w, fw : integer) return round_type is
    variable r_and_r   : round_type;
    constant DSP_TYPE  : integer := flt_pt_get_dsp_type(family);

  begin
    r_and_r.imp_type   := flt_pt_get_renorm_and_round_type(family,mult_usage);
    r_and_r.legacy     := false; 
    
    -- If multiplier, then switch off pipelined round
    if has_multiply = FLT_PT_YES then 
      if r_and_r.imp_type = FLT_PT_LOGIC or r_and_r.imp_type = FLT_PT_MULT18X18S then
        r_and_r.legacy  := true;     
      elsif mult_usage = FLT_PT_MEDIUM_USAGE then
        r_and_r.legacy  := true;  -- always legacy  
      end if;
    
      if mult_usage /= FLT_PT_MAX_USAGE then
        r_and_r.imp_type  := FLT_PT_LOGIC;
      end if;
    elsif has_addsub = FLT_PT_YES then
      -- Adder, so check which architecture
      if optimization = FLT_PT_SPEED_OPTIMIZED then
        -- Use pipelined rounder
        r_and_r.legacy  := false; 
      else -- low latency
        -- Use legacy, non-pipelined, rounder
        r_and_r.legacy  := true; 
      end if;      
    else
      -- All other components use legacy, non-pipelined, rounder
      r_and_r.legacy  := true; 
    end if;
 
    r_and_r.norm_bits   := flt_pt_get_renorm_and_round_norm_bits(family,r_and_r.imp_type);
    r_and_r.stages      := flt_pt_get_renorm_and_round_delay(family,r_and_r.imp_type,fw,r_and_r.legacy );
    
    if r_and_r.imp_type=FLT_PT_DSP48 or r_and_r.imp_type=FLT_PT_DSP48E then
      r_and_r.exp_stage := 2; -- addition done in parallel
    elsif fw <= FLT_PT_CARRY_LENGTH then
      -- Don't pipeline short chains
      r_and_r.exp_stage := 1;
    else
      r_and_r.exp_stage := 2; -- exp addition after mant
    end if;

    return(r_and_r);
  end function; 
     
--------------------------------------------------------------------------------
-- addsub
--------------------------------------------------------------------------------   
  function flt_pt_get_addsub_type(family : string; 
    mult_usage : integer) return integer is
    variable dsp_type    : integer;
    variable addsub_type : integer;
  begin
    dsp_type    := flt_pt_get_dsp_type(family);
    addsub_type := FLT_PT_LOGIC;
    if (mult_usage > FLT_PT_NO_USAGE) then
      if dsp_type = FLT_PT_DSP48 then
        addsub_type := FLT_PT_DSP48;
      else
        addsub_type := FLT_PT_DSP48E;
      end if;
    end if;
    return(addsub_type);  
  end function;
  
  function flt_pt_get_addsub_delay(family: string; 
    mult_usage, width : integer) return integer is
    variable addsub_type : integer := 
      flt_pt_get_addsub_type(family, mult_usage); 
    variable delay       : integer;
  begin
    addsub_type := flt_pt_get_addsub_type(family, mult_usage);
    if addsub_type=FLT_PT_DSP48 or addsub_type=FLT_PT_DSP48E then
      delay := 3;
    elsif width+2<=FLT_PT_CARRY_LENGTH then
      -- don't pipeline short carry chains
      delay := 1;
    else
      delay := 2;  
    end if;   
    return(delay);
  end function;
  
  -- To establish how many stages of alignment can be packed into addsub operation
  function flt_pt_get_addsub_bits(family : string) return integer is
    variable bits  : integer;
  begin
  
    if flt_pt_has_lut6(family) then 
      bits := 1; -- logic with LUT6, can do 2-bit shift
    else
      bits := 0;
    end if;
    return(bits);
  end function; 
  
  -- Establishes how many stages of alignment can be packed into addmux operation
  function flt_pt_get_addmux_bits(family : string) return integer is
    variable bits  : integer;
  begin
  
    if flt_pt_has_lut6(family) then 
      bits := 1; -- logic with LUT6, can do 2-bit shift
    else
      bits := 0;
    end if;
    return(bits);
  end function; 
      
--------------------------------------------------------------------------------
-- shift_msb_first
--------------------------------------------------------------------------------    
  function flt_pt_get_shift_msb_first_bits(
    a_width, result_width, last_bits_to_omit : integer;
    left : boolean) return integer is
    variable width : integer;
    variable bits : integer;
  begin
    if left then
      width := a_width;
    else
      width := result_width;
    end if;
    -- Determine if removing bits will reduce number of stages
    -- If so, return total number of bits
    bits := flt_pt_get_n_bits(width-1);
    -- Modify bits according to last_bits_to_omit. e.g.
    -- Last bits, bits, new bits
    -- 0 7 7
    -- 1 7 6
    -- 2 7 6
    -- 0 6 6
    -- 1 6 6
    -- 2 6 4    
    if last_bits_to_omit>0 then
      bits:=((bits - last_bits_to_omit+1)/2)*2;
    end if;
    return(bits);
  end function; 
  
--------------------------------------------------------------------------------
-- zero_det
--------------------------------------------------------------------------------   
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
  
--------------------------------------------------------------------------------
-- shift
--------------------------------------------------------------------------------  
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
  
--------------------------------------------------------------------------------
-- normalization
--------------------------------------------------------------------------------   
  function flt_pt_get_normalization_delay(in_width: integer) return integer is
  begin   
    return((flt_pt_get_n_bits(in_width-2) + 1) / 2);
  end function;
  
--------------------------------------------------------------------------------
-- align
--------------------------------------------------------------------------------     
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
  
--------------------------------------------------------------------------------
-- normalize
--------------------------------------------------------------------------------  
  function flt_pt_get_normalize(data_width: integer;
    poss_last_bits : integer:=1) return normalize_type is
    variable norm_data       : normalize_type;
    variable full_norm_stage : integer; 
    variable part_bits       : integer;
    variable full_norm_bits  : integer;
  begin
    part_bits := flt_pt_get_shift_msb_first_bits(
    data_width, data_width, poss_last_bits, true);
    
    norm_data.norm_stage := (part_bits+1)/2+1;
    
    full_norm_bits:= flt_pt_get_shift_msb_first_bits(
    data_width, data_width, 0, true);
    
    full_norm_stage := (full_norm_bits+1)/2 + 1;
    
    norm_data.last_stage := full_norm_stage-norm_data.norm_stage;
    norm_data.last_bits  := full_norm_bits-part_bits;
    norm_data.can_stage  := 2;
    return(norm_data);
  end function;  
  
--------------------------------------------------------------------------------
-- alignment
--------------------------------------------------------------------------------   
  function flt_pt_get_alignment(ip_width, det_width, op_width : integer;
    poss_last_bits : integer := 0) return alignment_type is  
    variable aa         : alignment_type;
    variable full_stage : integer; 
    variable part_bits  : integer;
    variable full_bits  : integer;  
  begin
    -- Determine input width of shifter
    if poss_last_bits>0 then
      -- Need to accommodate 1-bit alignment shift within mux stage
      aa.ip_width := ip_width+1;
    else
      aa.ip_width := ip_width;
    end if;
    -- Set detection width
    aa.det_width  := det_width;
    -- Set width of shifter output
    aa.op_width   := op_width;
    
    assert (op_width=det_width)
      report "ERROR in flt_pt_get_alignment: OP_WIDTH and DET_WIDTH must be the same."
      severity ERROR;
      
    -- Determine number of bits required to represent shift distance
    -- Implementing right-shift so base this calculation on output width
         
    aa.shift_width    := flt_pt_get_n_bits(op_width-1);
    aa.zero_det_width := flt_pt_get_n_bits(det_width-1);
    
    -- Determine number of bits with last bits removed    
    part_bits := flt_pt_get_shift_msb_first_bits(ip_width, op_width, poss_last_bits, false);
  
    aa.stage  := (part_bits+1)/2;
    
    -- Check if more that 2 stages, in which case we can pipeline every other stage
    -- mux+z_det R, mux R
    -- mux+z_det R, mux, mux R
    aa.stage_mask := (others=>true);
  -- This functionality has been disabled as it impacts at highest speed
  --  if aa.stage>2 then
  --    aa.stage_mask(1) := false;
  --    aa.stage:=aa.stage-1;
  --  end if;
    
    -- Determine number of bits without any last bits 
    full_bits:= flt_pt_get_shift_msb_first_bits(ip_width, op_width, 0, false);
    full_stage := (full_bits+1)/2; 
    
    if full_stage>2 then
      full_stage:=full_stage-1;
    end if;
      
    aa.last_stage     := full_stage-aa.stage;
    aa.last_bits      := full_bits-part_bits;
    aa.shift_stage    := aa.stage;
    aa.zero_det_stage := aa.stage; 
      
    return(aa);  
  end function;
  
--------------------------------------------------------------------------------
-- Functions to provide delays for a operations
--------------------------------------------------------------------------------   
  function flt_pt_flt_to_fix_delay(a_width, a_fraction_width, 
    result_width, result_fraction_width : integer) return integer is
    variable align_delay : integer;
  begin
    align_delay := flt_pt_get_align_delay(ip_width => a_fraction_width+1, 
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
      normalize_data :=flt_pt_get_normalize(data_width => a_width);
      delay := normalize_data.norm_stage+3;
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
  
--------------------------------------------------------------------------------
-- Functions for floating-point add/subtract
--------------------------------------------------------------------------------   
  -- Determine adder implementation type  
  function flt_pt_get_add_type(family : string; mult_usage, w, fw : integer) 
    return integer is
    variable add_type  : integer;
    constant dsp_type  : integer := flt_pt_get_dsp_type(family);
  begin
    -- Default is logic
    add_type := FLT_PT_LOGIC;
    if w=32 and fw=24 and (mult_usage > FLT_PT_NO_USAGE) then
      if dsp_type = FLT_PT_DSP48E then
        add_type := FLT_PT_DSP48E;
      elsif dsp_type = FLT_PT_DSP48 then
        add_type := FLT_PT_DSP48;
      end if;
    end if;
    return(add_type);
  end function; 
    
  -- Latency calculation function for the floating point adder
  function flt_pt_get_add_delay(family : string; 
     mult_usage, w, fw : integer) return integer is
    variable delay             : integer:=0;
    variable normalize_data    : normalize_type;
    variable alignment_data    : alignment_type; 
    variable add_type          : integer := flt_pt_get_add_type(family, mult_usage, w, fw);
    variable norm_bits         : integer;
    variable addsub_align_bits : integer;
    variable addmux_align_bits : integer;
    variable renorm_and_rnd    : round_type;
    variable addsub_stages     : integer; 
    variable round_usage       : integer;
    variable addsub_usage      : integer;
        
  begin

    case add_type is
    when FLT_PT_LOGIC =>
      round_usage  := FLT_PT_NO_USAGE;
      addsub_usage := FLT_PT_NO_USAGE;      
      -- If double precision then used mult_usage to determine type
      -- **** Note that add_type could override this ****
      if mult_usage > FLT_PT_NO_USAGE then
        if w = 64 and fw = 53 then
          round_usage  := mult_usage;
          addsub_usage := mult_usage;  
        end if;
      end if;
    
      addsub_stages     := flt_pt_get_addsub_delay(family, addsub_usage, fw);
      renorm_and_rnd    := flt_pt_get_renorm_and_round(has_addsub   => FLT_PT_YES,
                                                       optimization => FLT_PT_SPEED_OPTIMIZED,
                                                       family       => family,
                                                       mult_usage   => round_usage,
                                                       w            => w, 
                                                       fw           => fw);
         
      norm_bits         := flt_pt_get_renorm_and_round_norm_bits(family, mult_usage);
      normalize_data    := flt_pt_get_normalize(data_width => fw+3, poss_last_bits => norm_bits);
      addsub_align_bits := flt_pt_get_addsub_bits(family); 
      addmux_align_bits := flt_pt_get_addmux_bits(family); 
      alignment_data    := flt_pt_get_alignment(ip_width       => fw, 
                                                det_width      => fw+2,
                                                op_width       => fw+2, 
                                                poss_last_bits => addsub_align_bits+addmux_align_bits);
      delay := 2; -- Input and multiplexer stages
      delay := delay + alignment_data.stage; 
      delay := delay + flt_pt_get_addsub_delay(family, addsub_usage, fw);    
      delay := delay + normalize_data.norm_stage;
      delay := delay + renorm_and_rnd.stages;
      delay := delay + 1; -- Output stage
    when FLT_PT_DSP48 =>
      delay := 16;
    when FLT_PT_DSP48E =>
      delay := 12;
    when others =>
      report "Internal error : flt_pt_add_delay does not support requested add_type.";
      delay := 0;  
    end case;
    return delay;  
  end function flt_pt_get_add_delay;
  
--------------------------------------------------------------------------------
-- Multiply
--------------------------------------------------------------------------------   
  
  -- Determines when to use the QinetiQ multiplier
  function flt_pt_use_qq_mult(family : string; mult_usage, w, fw: integer) return boolean is
    variable is_qq          : boolean := false;
    constant MOD_MULT_USAGE : integer := (mult_usage mod FLT_PT_QQ_OFFSET);
    constant DSP_TYPE       : integer := flt_pt_get_dsp_type(family);
    begin
      if mult_usage>= FLT_PT_QQ_OFFSET then
        is_qq := false;
      elsif  (MOD_MULT_USAGE = FLT_PT_LOGIC) or (DSP_TYPE = FLT_PT_LOGIC) then
        is_qq := true; -- Use enhanced radix-8 multiplier
      elsif DSP_TYPE = FLT_PT_MULT18X18S then
        is_qq := true;
      elsif DSP_TYPE = FLT_PT_DSP48 and w=64 and fw=53 and 
            MOD_MULT_USAGE = FLT_PT_MEDIUM_USAGE then
        -- Special case
        is_qq := true;
      else
         -- For other DSP48 and DSP48E multipliers use Xilinx mult_gen   
        is_qq := false;
      end if;
    return(is_qq);
  end function;
  
  -- Determines type of fixed-point multiplier, taking into account mult_usage  
  function flt_pt_get_fix_mult_type(family : string; mult_usage : integer) 
    return integer is
    variable fix_mult_type : integer;
    variable dsp_type      : integer;
  begin
    dsp_type := flt_pt_get_dsp_type(family);

    if mult_usage = FLT_PT_NO_USAGE then
      fix_mult_type := FLT_PT_LOGIC;
    else
      fix_mult_type := dsp_type;
    end if;
    return(fix_mult_type);
  end function;
   
	function flt_pt_get_fix_mult_delay(fw : integer; family : string; 
                mult_usage : integer) return integer is
    variable dsp_type         : integer;
    variable mult_type        : integer;
    variable mult_usage_local : integer;
    variable delay            : integer;
    constant USE_QQ           : boolean := flt_pt_use_qq_mult(family, mult_usage, 64, fw);    
  begin
    mult_usage_local := mult_usage mod FLT_PT_QQ_OFFSET;
 
    mult_type := flt_pt_get_fix_mult_type(family, mult_usage_local);  
    case mult_type is
      when FLT_PT_LOGIC =>
        if USE_QQ then
        -- Fall back to QQ multiplier
          if fw <= 5 then -- 3+2
            delay := 3;
          elsif fw <= 11 then -- 6+5
            delay := 4;
          elsif fw <= 23 then -- 12+11
            delay := 5;
          elsif fw <= 47 then -- 24+23
            delay := 6;
          elsif fw <= 95 then -- 48+47
            delay := 7;
          elsif fw <= 191 then -- 96+95
            delay := 8;         
          else
            assert (false)
            report "ERROR in flt_pt_get_fix_mult_delay: Unsupported logic multiplier size."
            severity ERROR;
            delay := 0;
          end if; 
        else
          -- Use Xilinx logic multiplier
          if fw <= 4 then    
            delay := 3;  -- Extra cycle for zero detect
          elsif fw <= 8 then 
            delay := 4;
          elsif fw <= 16 then 
            delay := 5;
          elsif fw <= 32 then 
            delay := 6;
          elsif fw <= 64 then 
            delay := 7;
          elsif fw <= 128 then 
            delay := 8;        
          else
            assert (false)
            report "ERROR in flt_pt_get_fix_mult_delay: Unsupported logic multiplier size."
            severity ERROR;
            delay := 0;
          end if;
        end if;          
      when FLT_PT_MULT18X18S =>
      -- mult18x18s only
        if USE_QQ then
          -- Fall back to QQ multiplier      
          if mult_usage_local=FLT_PT_FULL_USAGE or 
            mult_usage_local=FLT_PT_MAX_USAGE then
            if fw <= 17 then
	            delay := 2;
            elsif fw <= 34 then
              delay := 4;
            elsif fw <= 51 then
              delay := 5;
            elsif fw <= 68 then
              delay := 6;
            else
              assert (false)
              report "ERROR in flt_pt_get_fix_mult_delay: Multiplier size too large."
              severity ERROR;
              delay := 0;
            end if;
          else -- FLT_PT_MEDIUM_USAGE
            if fw = 53 then
              delay := 8; 
            else 
              assert (false)
              report "ERROR in flt_pt_get_fix_mult_delay: FLT_PT_MED_USAGE not supported " &
                "for chosen wordlength."
              severity ERROR;
              delay := 0;
            end if;
          end if;
        else
          if mult_usage_local=FLT_PT_FULL_USAGE or 
            mult_usage_local=FLT_PT_MAX_USAGE then
            if fw <= 17 then
	            delay := 3; -- extra for routing
            elsif fw <= 34 then
              delay := 5; -- pipeline cut on multiplier output
            elsif fw <= 51 then
              delay := 7; -- Uses 9-ip adder, pipeline cut on multiplier output
            elsif fw <= 68 then
              delay := 7; -- Pipeline cut on multiplier output;
            else
              assert (false)
              report "ERROR in flt_pt_get_fix_mult_delay: Multiplier size too large."
              severity ERROR;
              delay := 0;
            end if;
          else -- FLT_PT_MED_USAGE
            assert (false)
            report "ERROR in flt_pt_get_fix_mult_delay: FLT_PT_MED_USAGE not supported " &
              "for chosen wordlength."
            severity ERROR;
            delay := 0; 
          end if;      
        end if;                    
      when FLT_PT_DSP48 =>
        if mult_usage_local=FLT_PT_FULL_USAGE or 
           mult_usage_local=FLT_PT_MAX_USAGE then
          if fw <= 17 then 
            delay := 2+1+1;
          elsif fw <= 34 then 
            delay := 2+4+1;
          elsif fw <= 51 then 
            delay := 2+9+1;
          elsif fw <= 68 then 
            delay := 2+16+1;        
          else
            assert (false)
            report "ERROR in flt_pt_get_fix_mult_delay: Multiplier size too large."
            severity ERROR;
            delay := 0;  
          end if;
        else
          if USE_QQ then 
            -- DSP48 + logic 
            if fw = 53 then
              delay := 15; 
            else 
              assert (false)
              report "ERROR in flt_pt_get_fix_mult_delay: FLT_PT_MED_USAGE not supported " & 
                "by QQ multiplier for chosen wordlength."
              severity ERROR;
              delay := 0;
            end if;
          else -- Xilinx
            if fw = 24 then
              delay := 7; -- with input register and zero detect
            else
              assert (false)
              report "ERROR in flt_pt_get_fix_mult_delay: FLT_PT_MED_USAGE not supported " & 
                "by Xilinx multiplier for chosen wordlength."
              severity ERROR;
              delay := 0;
            end if;
          end if;                       
        end if;
      when FLT_PT_DSP48E =>
        if mult_usage >= FLT_PT_QQ_OFFSET then
          assert (false)
          report "ERROR in flt_pt_get_fix_mult_delay: Family not supported by QQ multiplier."
          severity ERROR;
          delay := 0;           
        else
          if mult_usage_local=FLT_PT_FULL_USAGE or 
            mult_usage_local=FLT_PT_MAX_USAGE then    
            if fw <= 17 then 
              delay := 2+1+1;
            elsif fw <= 24 then 
              delay := 2+2+1;
            elsif fw <= 34 then 
              delay := 2+4+1;
            elsif fw <= 41 then 
              delay := 2+6+1;        
            elsif fw <= 51 then 
              delay := 2+9+1;  
            elsif fw <= 58 then 
              delay := 2+12+1;
            elsif fw <= 68 then 
              delay := 2+16+1;                      
            else
              assert (false)
              report "ERROR in flt_pt_get_fix_mult_delay: Multiplier size too large " &
               "for Xilinx multiplier."
              severity ERROR;
              delay := 0;  
            end if; 
          else
            if fw = 24 then
              delay := 6; -- input register
            else
              assert (false)
              report "ERROR in flt_pt_get_fix_mult_delay: FLT_PT_MED_USAGE not supported."
              severity ERROR;
              delay := 0; 
            end if; 
          end if; 
        end if;          
      when others =>
        report "ERROR in flt_pt_get_fix_mult_delay : Multiplier type not supported.";
        delay := 0;  
    end case;
    return delay;       
  end function;
  	
  function flt_pt_get_mult_type(family : string; mult_usage : integer) 
    return integer is
    constant mult_type : integer := flt_pt_get_fix_mult_type(family, mult_usage);
  begin
    return(mult_type);
  end function;	 
  
	function flt_pt_get_flt_mult_delay(width, fraction_width : integer; family : string; 
                mult_usage : integer) return integer is
                
    variable mult : flt_mult_type;
  begin
    -- Multiplier
    mult := flt_pt_get_mult(optimization => FLT_PT_SPEED_OPTIMIZED,
                            family       => family,
                            mult_usage   => mult_usage,
                            w            => width,
                            fw           => fraction_width);
    return mult.stages;       
  end function;
  
  function flt_pt_get_mult(family : string; optimization : integer;  
    mult_usage, w, fw : integer) return flt_mult_type is
    variable mult_config : flt_mult_type;
  begin
    mult_config.exp_speed       := flt_pt_fast_family(family);
    mult_config.imp_type        := mult_usage mod FLT_PT_QQ_OFFSET;
    mult_config.use_qq          := flt_pt_use_qq_mult(family, mult_usage, w, fw);
 
    mult_config.fix_mult_stages := flt_pt_get_fix_mult_delay(
                                   fw             => fw,
                                   family         => family, 
                                   mult_usage     => mult_config.imp_type);
    mult_config.round_config    := flt_pt_get_renorm_and_round(
                                   has_multiply   => FLT_PT_YES,
                                   optimization   => optimization,
                                   family         => family, 
                                   mult_usage     => mult_config.imp_type,
                                   w              => w, 
                                   fw             => fw);
    mult_config.stages          := mult_config.round_config.stages+
                                   mult_config.fix_mult_stages + 1;
    return(mult_config);
  end function;
    
--------------------------------------------------------------------------------
-- Other operator functions
-------------------------------------------------------------------------------- 
-- Latency calculation function for the floating point Divider
  function flt_pt_get_div_delay(w, fw : integer) return integer is
  begin
    return fw+4;
  end function flt_pt_get_div_delay;
	
  -- Latency calculation function for the floating point Square Root
  function flt_pt_get_sqrt_delay(w, fw : integer) return integer is
  begin
    return fw+4;
  end function flt_pt_get_sqrt_delay;
  
  function flt_pt_get_flt_add(
    C_FAMILY                : string; 
    C_MULT_USAGE            : integer; 
    C_HAS_ADD               : integer;
    C_HAS_SUBTRACT          : integer;
    C_HAS_FIX_TO_FLT        : integer;
    C_HAS_FLT_TO_FIX        : integer;      
    C_A_WIDTH               : integer;
    C_A_FRACTION_WIDTH      : integer) 
    return flt_add_type is
    variable add_stage         : flt_add_type;
    variable align_stages      : alignment_type;
    variable norm_stages       : normalize_type;
    variable ab_extw           : integer;
    variable addmux_align_bits : integer; 
    variable addsub_align_bits : integer;
  begin
    if (C_HAS_FIX_TO_FLT=FLT_PT_YES or C_HAS_FLT_TO_FIX=FLT_PT_YES) then
      ab_extw := C_A_WIDTH; 
    else
      ab_extw := C_A_FRACTION_WIDTH;
    end if;
    
    add_stage.ab_extw := ab_extw;
    
    addmux_align_bits := flt_pt_get_addmux_bits(C_FAMILY); 
    addsub_align_bits := flt_pt_get_addsub_bits(C_FAMILY);
    
    align_stages := flt_pt_get_alignment(
      ip_width => ab_extw, det_width => ab_extw+2, op_width => ab_extw+2,
      poss_last_bits => addmux_align_bits+addsub_align_bits);
  
    norm_stages  := flt_pt_get_normalize(data_width => ab_extw+1, 
      poss_last_bits=> 2); -- for low_latency adder
    
    add_stage.round_config  := flt_pt_get_renorm_and_round(
                               optimization => FLT_PT_LOW_LATENCY,
                               family       => C_FAMILY,
                               mult_usage   => C_MULT_USAGE,
                               w            => C_A_WIDTH,
                               fw           => C_A_FRACTION_WIDTH); 
                                                
    add_stage.last_stage    := norm_stages.last_stage;
    add_stage.last_bits     := norm_stages.last_bits;             
    add_stage.mux_stage     := 1;
    add_stage.align_stage   := 2;
    add_stage.add_stage     := align_stages.stage+add_stage.align_stage;
    add_stage.align_add_op_stage := add_stage.add_stage+1;
    add_stage.lod_stage     := 2;
    add_stage.can_stage     := add_stage.lod_stage+norm_stages.can_stage;
    add_stage.norm_op_stage := norm_stages.norm_stage+2;   
    add_stage.dist_stage    := norm_stages.norm_stage+2;    
    add_stage.sel_stage     := flt_pt_max(add_stage.norm_op_stage, add_stage.align_add_op_stage);
    add_stage.rnd_stage     := add_stage.sel_stage+1;
    add_stage.op_stage      := add_stage.rnd_stage+1;
    add_stage.stages        := add_stage.op_stage+1;

    return (add_stage);
  end function;
--------------------------------------------------------------------------------
-- Function to provide latency for a particular operation
--------------------------------------------------------------------------------   
  function flt_pt_delay(family : string; 
    op_code: std_logic_vector(FLT_PT_OP_CODE_WIDTH-1 downto 0);
    a_width, a_fraction_width, b_width, b_fraction_width, 
    result_width, result_fraction_width, optimization, mult_usage,
    rate: integer;
    has_add, has_subtract, has_multiply, has_divide, has_sqrt, has_compare, 
    has_fix_to_flt, has_flt_to_fix, has_flt_to_flt : integer := 0; 
    required : integer := FLT_PT_MAX_LATENCY) return integer is
    
    constant result_exponent_width : integer := 
      result_width-result_fraction_width;
    variable del         : integer;
    variable max_lat     : integer;
    variable mult_type   : integer;
    variable numb_ones   : integer;
    variable req_lat     : integer; 
    variable add_stages  : flt_add_type;  
  begin
    -- Determine maximum latency for particular parameters
    case optimization is
    when FLT_PT_LOW_LATENCY =>
      add_stages := flt_pt_get_flt_add(
        C_FAMILY           => family,
        C_MULT_USAGE       => FLT_PT_NO_USAGE,  -- Logic only
        C_HAS_ADD          => has_add,
        C_HAS_SUBTRACT     => has_subtract,
        C_HAS_FIX_TO_FLT   => has_fix_to_flt,
        C_HAS_FLT_TO_FIX   => has_flt_to_fix,
        C_A_WIDTH          => a_width,
        C_A_FRACTION_WIDTH => a_fraction_width);  
      case op_code is  
      when FLT_PT_ADD_OP_CODE_SLV =>
        max_lat := add_stages.stages;          
      when FLT_PT_SUBTRACT_OP_CODE_SLV => 
        max_lat := add_stages.stages;
      when FLT_PT_FIX_TO_FLT_OP_CODE_SLV =>
	     max_lat := add_stages.stages;      
      when FLT_PT_FLT_TO_FIX_OP_CODE_SLV =>
	     max_lat := add_stages.stages;
      when others =>
        max_lat := 0;
      end case;	                      
    when FLT_PT_SPEED_OPTIMIZED =>
      case op_code is
      when FLT_PT_ADD_OP_CODE_SLV => 
        max_lat := flt_pt_get_add_delay(family, mult_usage, result_width,
                                        result_fraction_width);
      when FLT_PT_SUBTRACT_OP_CODE_SLV =>
        max_lat := flt_pt_get_add_delay(family, mult_usage, result_width, 
                                        result_fraction_width);
      when FLT_PT_MULTIPLY_OP_CODE_SLV =>
        max_lat := flt_pt_get_flt_mult_delay(result_width, result_fraction_width, 
                   family, mult_usage); 
      when FLT_PT_DIVIDE_OP_CODE_SLV =>
        max_lat := flt_pt_get_div_delay(result_width, result_fraction_width);
      when FLT_PT_SQRT_FTF_OP_CODE_SLV => 
	     if has_flt_to_flt =FLT_PT_YES then
          max_lat := flt_pt_flt_to_flt_delay(a_width, a_fraction_width, 
          result_width, result_fraction_width);
        else 	          
	       max_lat :=  flt_pt_get_sqrt_delay(result_width, result_fraction_width);
	     end if;
      when FLT_PT_FIX_TO_FLT_OP_CODE_SLV =>
	      max_lat :=  flt_pt_fix_to_flt_delay(a_width, 3);      
      when FLT_PT_FLT_TO_FIX_OP_CODE_SLV =>
	      max_lat :=  flt_pt_flt_to_fix_delay(a_width, a_fraction_width, 
	        result_width, result_fraction_width); 
      when FLT_PT_COMPARE_OP_CODE_SLV =>
        max_lat := 3; 	       
      when others =>
        max_lat := 0;
      end case;
    when 0 =>
      case op_code  is
      when FLT_PT_ADD_OP_CODE_SLV => 
        max_lat := 5;
      when FLT_PT_SUBTRACT_OP_CODE_SLV => 
        max_lat := 5;  
      when FLT_PT_MULTIPLY_OP_CODE_SLV =>
        if mult_usage > 0 then
          max_lat := 5;
        else
          assert false 
            report "ERROR in flt_pt_delay: Operation option not supported while" & 
                   " FLT_PT_BASIC" 
            severity ERROR;
        end if;
      when FLT_PT_DIVIDE_OP_CODE_SLV =>
        max_lat := 30;
      when FLT_PT_COMPARE_OP_CODE_SLV =>
	      max_lat :=  2;  	    
      when others =>
        assert false 
         report "ERROR in flt_pt_delay: Operation option not supported"
              & "while FLT_PT_BASIC" 
         severity ERROR;
      end case;    
    when others => 
      max_lat :=  0;       
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
        (optimization = FLT_PT_SPEED_OPTIMIZED or 
          optimization = FLT_PT_LOW_LATENCY) then
      -- Required is less than maximum, so use required 
      del := required;
    else
      del := max_lat; 
    end if;
    return(del);
  end function;
  
  function flt_pt_get_xmult_type(w, fw : integer; family : string; 
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
      when FLT_PT_FULL_USAGE | FLT_PT_MAX_USAGE => return(6);
      when others =>
        assert false 
          report "ERROR in flt_pt_get_mult_type: mult_usage value not supported" 
          severity ERROR;
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
        when FLT_PT_FULL_USAGE | FLT_PT_MAX_USAGE =>
        -- mult18x18s only 
          return(2);
        when others =>
          assert false 
            report "ERROR in flt_pt_get_mult_type: mult_usage value not supported" 
              severity ERROR;
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
  function floating_point_v3_0_check(C_FAMILY : string; C_HAS_ADD, 
     C_HAS_SUBTRACT, C_HAS_MULTIPLY, C_HAS_DIVIDE, C_HAS_SQRT,
     C_HAS_COMPARE, C_HAS_FLT_TO_FIX, C_HAS_FIX_TO_FLT,
     C_HAS_FLT_TO_FLT,
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
     C_STATUS_EARLY, C_SPEED : integer) return boolean is
    
  variable valid        : boolean;
  variable n_op         : integer;
  variable i            : integer;
  variable valid_width  : boolean;
      
  constant S_OP_NAME    : string := "speed optimized";
  constant U_OP_NAME    : string := "basic";
  
  constant STARS        : string := "***************************" & CR;     
  constant HEADER       : string := STARS & "ERROR in floating_point_v3_0_check : "; 
  constant NOT_ON_S_OP  : string := 
    " not available with core optimized for speed."; 
  constant ONLY_ON_U_OP : string := 
    " only available on basic core."; 
  constant ONLY_ON_S_OP : string := 
    " only available on speed optimized core.";       
  type int_array is array (natural range <>) of integer;
  
  constant N_OPS : integer := flt_pt_number_of_operations(C_HAS_ADD, 
    C_HAS_SUBTRACT, C_HAS_MULTIPLY, C_HAS_DIVIDE, C_HAS_SQRT, C_HAS_COMPARE,
    C_HAS_FIX_TO_FLT, C_HAS_FLT_TO_FIX, C_HAS_FLT_TO_FLT);
  
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
  if not ((C_OPTIMIZATION = FLT_PT_SPEED_OPTIMIZED) or
           (C_OPTIMIZATION = FLT_PT_LOW_LATENCY)) then 
    report HEADER & "Optimization is not supported." &
      " Set C_OPTIMIZATION to FLT_PT SPEED_OPTIMISED or " &
      " FLT_PT_LOW_LATENCY.";
    pass:=false;
  end if;
    
------------------------------------------------------------------------------- 
-- Check operations
-------------------------------------------------------------------------------     

  if not (N_OPS < 2 or 
   (C_OPTIMIZATION = FLT_PT_SPEED_OPTIMIZED and
    -- Check that only add and subtract are selected
    N_OPS=2 and C_HAS_SUBTRACT=FLT_PT_YES and C_HAS_ADD=FLT_PT_YES) or
    -- Can have multiple operations with low_latency 
    (C_OPTIMIZATION = FLT_PT_LOW_LATENCY)) then 
   report HEADER & 
    "Only add and subtract operations can be combined.";
    pass := false;
  end if;
      
  if not (N_OPS > 0) then
    report HEADER & 
    "At least one operation must be enabled.";
    pass := false;
  end if;
  
  if  (C_OPTIMIZATION = FLT_PT_LOW_LATENCY) then       
    if not (C_HAS_SUBTRACT=FLT_PT_YES or C_HAS_ADD=FLT_PT_YES) then
      report HEADER &
        "Only addition or subtraction operation supported by low latency core."
        & " Change operation, or set C_OPTIMIZATION=FLT_PT_SPEED_OPTIMIZED.";
      pass := false;
    end if;
    if not ((C_RESULT_WIDTH=64 and C_A_FRACTION_WIDTH=53) or
            (C_RESULT_WIDTH=32 and C_A_FRACTION_WIDTH=24)) then
      report HEADER &
        "Single or double precision only supported by low latency core."
        & " Change precision, or set C_OPTIMIZATION=FLT_PT_SPEED_OPTIMIZED.";
      pass := false;
    end if; 
    if not (FLT_PT_HAS_LUT6(C_FAMILY)) then
      report HEADER &
        "Low latency core only supported on virtex5."
        & " Change precision, or set C_OPTIMIZATION=FLT_PT_SPEED_OPTIMIZED.";
      pass := false;
    end if;      
  end if;
      
------------------------------------------------------------------------------- 
-- Check wordlengths: width and fraction_width
-------------------------------------------------------------------------------                  

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
    elsif C_HAS_FLT_TO_FLT = FLT_PT_YES then
      -- Need to check:
      --   1) floating-point input A is within bounds
      --   2) input A is same as B and result 
      pass := flt_pt_check(C_A_WIDTH, C_A_FRACTION_WIDTH, "A") and pass;
      pass := flt_pt_check(C_RESULT_WIDTH, C_RESULT_FRACTION_WIDTH, "RESULT") and pass;
    elsif C_HAS_COMPARE = FLT_PT_YES then
      pass := flt_pt_check(C_A_WIDTH, C_A_FRACTION_WIDTH, "A") and pass;    
    else
      -- Otherwise need to check:
      --   1) floating-point A input is within bounds
      --   2) input B and result are the same widths as input A 
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
    if (C_OPTIMIZATION = FLT_PT_SPEED_OPTIMIZED) then
      if not ((C_COMPARE_OPERATION >= 0) and (C_COMPARE_OPERATION <= 8)) then 
        report HEADER & "Compare operation is out of range. Current value"
         & " C_COMPARE_OPERATION= " & integer'image(C_COMPARE_OPERATION);
        pass := false;
      end if;
    end if;
  end if;
------------------------------------------------------------------------------- 
-- Check multiplier usage
-- Note that checking is not strict. The core is robust, and rather
-- than fail will do something sensible. May wish to change this when error
-- message is reported. 
-------------------------------------------------------------------------------
  if not (((C_MULT_USAGE >= FLT_PT_NO_USAGE) and 
           (C_MULT_USAGE <= FLT_PT_MAX_USAGE )) or 
          ((C_MULT_USAGE >= FLT_PT_QQ_OFFSET+FLT_PT_NO_USAGE) and 
           (C_MULT_USAGE <= FLT_PT_QQ_OFFSET+FLT_PT_MAX_USAGE))) then
    report HEADER & "Multiplier usage value is out of range. Requested value"
      & " C_MULT_USAGE= " & integer'image(C_MULT_USAGE);
    pass := false;
  end if; 

  if (C_RATE /= 1) then
    if not(C_HAS_DIVIDE=FLT_PT_YES or C_HAS_SQRT=FLT_PT_YES) then
      report HEADER & "C_RATE greater than 1 only supported by divide or"
       & " square-root on " & S_OP_NAME & " core.";  
      pass := false;
    end if;   
  end if;

--------------------------------------------------------------------------------
-- Optional output signals
--------------------------------------------------------------------------------    
  
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
  function flt_pt_has_add_or_subtract(C_HAS_ADD, C_HAS_SUBTRACT : integer) return integer is
  begin
    if (C_HAS_ADD = FLT_PT_YES) or (C_HAS_SUBTRACT = FLT_PT_YES) then
      return(FLT_PT_YES);
    else
      return(FLT_PT_NO);
    end if;
  end function;  

  function flt_pt_get_addsub_op(operation : 
    std_logic_vector(FLT_PT_OPERATION_WIDTH-1 downto 0)) return std_logic is
  begin
    return(operation(0));
  end function;

  function flt_pt_get_compare_op(operation : 
    std_logic_vector(FLT_PT_OPERATION_WIDTH-1 downto 0)) return std_logic_vector is
  begin  
    return(operation(FLT_PT_OPERATION_WIDTH-1 downto 
    FLT_PT_OPERATION_WIDTH-FLT_PT_COMPARE_OPERATION_WIDTH));
  end function;  
	------------------------------------------------------------------------
	--- Xilinx additions
  ------------------------------------------------------------------------		
  function get_reg_delay(reg : flt_pt_reg_type; start, length : integer) return integer is
    variable sum : integer := 0;
  begin
    for i in start to (start+length-1) loop
      if reg(i) then
        sum := sum + 1;
      end if;
    end loop;
    return(sum);
  end function;
   
  function get_reg_delay_pat(reg : flt_pt_reg_type; start, length : integer) return integer is
    variable sum : integer := 0;
    variable pow : integer := 1;
  begin
    for i in start to (start+length-1) loop
      if reg(i) then
        sum := sum + pow;
      end if;
      pow := pow*2;      
    end loop;
    return(sum);
  end function;  
           
  function get_reg_blk(reg : flt_pt_reg_type; start : integer) return flt_pt_reg_type is
    variable reg_blk : flt_pt_reg_type := (others=> false);
  begin
    for i in reg_blk'left to reg_blk'right-start-1 loop
      reg_blk(i) := reg(start+i);
    end loop;
    return(reg_blk);
  end function;  
  
  function conv_reg_to_reg_int(reg : flt_pt_reg_type) return int_array is	
    variable reg_int : int_array(0 to flt_pt_reg_type'length-1); 
  begin
    for i in 0 to flt_pt_reg_type'length-1 loop
      if reg(i) then
        reg_int(i):= 1;
      else
        reg_int(i):= 0;
      end if;
    end loop;
    return(reg_int);
  end function;
   	 
  function mask_reg(reg_in, stage_mask : flt_pt_reg_type ) return flt_pt_reg_type is
    variable loc_reg : flt_pt_reg_type; 
  begin
    for i in reg_in'left to reg_in'right loop
      if stage_mask(i) then
        loc_reg(i) := reg_in(i);
      else
        loc_reg(i) := false;
      end if;
	  end loop;
	  return(loc_reg);	  
  end function;   
  
end package body floating_point_pkg_v3_0;


