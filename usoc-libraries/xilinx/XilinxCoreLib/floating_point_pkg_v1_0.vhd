--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor: Xilinx
-- \   \   \/    Version: 1.0
--  \   \        Filename: $RCSfile: floating_point_pkg_v1_0.vhd,v $           
--  /   /        Date Last Modified: $Date: 2010-07-10 21:43:11 $ 
-- /___/   /\    Date Created: Dec 2005
-- \   \  /  \
--  \___\/\___\
-- 
--Device  : All
--Library : xilinxcorelib.floating_point_pkg_v1_0
--Purpose : Package of supporting functions
--Revision History:
--   17 Feb 05 : Added fpMwParam and other related constants.
--    1 Mar 05 : Added support for DSP48.
--    8 Mar 05 : Changed comparator and divider latencies to 2 and 29 resp. 
--    9 Mar 05 : Changed Virtex4 to virtex4 - all lower case
--   24 Mar 05 : Moved check function into this package
--               C_Mult_Usage range extended.
--   28 Mar 05 : Added type WIDTH=44, FRACTION_WIDTH=34.
--               Added check for DSP48+logic. In this case 
--               (in which case selection changed to DSP48 only)
--   31 Mar 05 : Removed 18-bit FRACTION_WIDTH from legal wordlengths check.
--               Modified flt_pt_get_embedded so that 17-bit FRACTION_WIDTH
--               DSP+logic (MULTY_USAGE=1 on Virtex4) becomes DSP48 only. 
--    5 Apr 05 : Changed latency to 10 for mult18x18 53 bit multiplier.
--               Changed check function so that asserts are based upon
--               constants. Updated wordlength values to those in datasheet.
--               Op_code comparisons based on integer representation to avoid
--               'U' states.
--               Moved utility functions from floating_point_v1_0_consts to
--               here.
--    6 Apr 05 : Modified flt_pt_number_of_operations to count subtract with 
--               add as 2 operations.
--   21 Apr 05 : Changed latency of basic divider to 30.   
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
use xilinxcorelib.floating_point_v1_0_consts.all;

package floating_point_pkg_v1_0 is
  
--------------------------------------------------------------------------------
-- The following function can be used to determine the latency of an operation
-- for a given set of generics. Use default values where appropriate. 
-- Parameters width and fraction_width should be set to the common value used 
-- on inputs and outputs.
--------------------------------------------------------------------------------     
  function flt_pt_delay(family : string; 
    op_code: std_logic_vector;
    width, fraction_width, optimization, mult_usage, rate : integer) return 
    integer; 
    
  function conv_int_to_slv_3(a,w : integer) return std_logic_vector;

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
  
  function floating_point_v1_0_check(C_FAMILY : string; C_HAS_ADD, 
    C_HAS_SUBTRACT, C_HAS_MULTIPLY, C_HAS_DIVIDE, C_HAS_SQRT,
    C_HAS_COMPARE, 
    C_RESULT_WIDTH, C_RESULT_FRACTION_WIDTH,
    C_COMPARE_OPERATION, C_OPTIMIZATION, C_MULT_USAGE,
    C_HAS_SCLR,           
    C_HAS_OPERATION_ND, C_HAS_OPERATION_RFD, C_HAS_RDY,
    C_HAS_UNDERFLOW, C_HAS_OVERFLOW, C_HAS_INVALID_OP,
    C_HAS_DIVIDE_BY_ZERO, 
    C_HAS_EXCEPTION,
    C_STATUS_EARLY : integer) return boolean; 
  -- Add this constant to C_MULT_USAGE to force family to Virtex-4	
  constant FLT_PT_IS_VIRTEX4	: integer := 16;

  function fpAddDelay(ew, mw : integer) return integer;
  function fpMulDelay(ew, mw : integer; embedded, useDSP48 : boolean) return 
    integer; 
  function fpDivDelay(ew, mw : integer) return integer;
  function fpSqrtDelay(ew, mw : integer) return integer;
  function flt_pt_get_embedded(w, fw : integer; family : string; 
    mult_usage : integer) return boolean;
  function flt_pt_get_useDSP48(w, fw : integer; family : string; 
    mult_usage : integer) return boolean;
    
  subtype fpPolarityType is integer range 0 to 1;
  constant fpMwParam  : integer :=6;
  constant fpEwParam  : integer :=4;
  constant fxWParam   : integer :=32;
  constant fpEmbedded : boolean := false;
  constant cleWParam  : integer :=0;	 

  constant maxEW      : integer := 16;
  constant minEW      : integer := 4;
  constant maxMW      : integer := 112;
  constant minMW      : integer := 6;  
end package floating_point_pkg_v1_0;

package body floating_point_pkg_v1_0 is

--------------------------------------------------------------------------------
-- Function to convert integer op_code to slv
-------------------------------------------------------------------------------- 
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
    assert (flt_pt_number_of_operations(C_HAS_ADD, C_HAS_SUBTRACT,
      C_HAS_MULTIPLY, C_HAS_DIVIDE, C_HAS_SQRT, C_HAS_COMPARE,
      C_HAS_FIX_TO_FLT, C_HAS_FLT_TO_FIX) = 1)
      report "flt_pt_get_op_code: only one operator must selected" 
      severity FAILURE;
      
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
-- Functions to provide delays for a particular operation
-------------------------------------------------------------------------------- 

  -- Latency calculation function for the floating point adder
  function fpAddDelay(ew, mw : integer) return integer is
    variable delay : integer;
  begin					 
    delay := 7;
    if mw <= 15 then
      delay := delay + 2;
    else
      delay := delay + 3;
    end if;
      delay := delay + (ew+3)/4 - 1;
    return delay;
  end function fpAddDelay;
	
  -- Latency calculation function for the floating point multiplier
  function fpMulDelay(ew, mw : integer; embedded, useDSP48 : boolean) return 
    integer is
  begin
    if embedded = true then
      if useDSP48 = false then	
        -- mult18x18s only
        if mw <= 17 then
	  return 4;
        elsif mw > 17 and mw <= 34 then
          return 6;
        elsif mw = 53 then
          return 10; 
        else
          return 0;
	  report "Unsupported value of mw/ew for fpMul. Invalid latency returned.";
        end if;
      else 
        -- DSP48 only
        if mw <= 17 then
	  return 6;
        elsif mw > 17 and mw <= 34 then
          return 9;
        elsif mw = 53 then
          return 21; 
        else
          return 0;
	  report "Unsupported value of mw/ew for fpMul. Invalid latency returned.";
        end if;
      end if;     
    else  -- embedded false
      -- embedded + DSP48
      if useDSP48 = true then
        if mw <= 17 then
	  return 5; -- same as embedded!
        elsif mw > 17 and mw <= 34 then
          return 11;
        elsif mw = 53 then
          return 17; 
        else
          return 0;
	  report "Unsupported value of mw/ew for fpMul. Invalid latency returned.";
        end if;
      else  
        -- no embedded multipliers    
        if mw <= 10 then
          return 6;
        elsif mw > 10 and mw <= 22 then
          return 7;
        elsif mw > 22 and mw <= 34 then
	  return 8;
        elsif mw = 53 then
          return 9;
        else
          return 0;
          report "Unsupported value of mw/ew for fpMul. Invalid latency returned.";
        end if;
      end if;
    end if;
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
    width, fraction_width, optimization, mult_usage, rate : integer) return 
    integer is
    constant exponent_width : integer := width-fraction_width;
    variable del : integer:=0;
    variable embedded : boolean;
    variable useDSP48 : boolean;  
  begin
    
    case optimization is
    when FLT_PT_SPEED_OPTIMIZED =>
      case to_integer(unsigned(op_code)) is
      when FLT_PT_ADD_OP_CODE => 
        del := fpAddDelay(exponent_width, fraction_width);
      when FLT_PT_SUBTRACT_OP_CODE =>
        del := fpAddDelay(exponent_width, fraction_width);
      when FLT_PT_MULTIPLY_OP_CODE =>
        embedded := flt_pt_get_embedded(width, fraction_width, family, 
          mult_usage);
        useDSP48 := flt_pt_get_useDSP48(width, fraction_width, family, 
          mult_usage); 
        del := fpMulDelay(exponent_width, fraction_width, embedded, useDSP48); 
      when FLT_PT_DIVIDE_OP_CODE =>
        del := fpDivDelay(exponent_width, fraction_width);
      when FLT_PT_SQRT_OP_CODE =>
	del :=  fpSqrtDelay(exponent_width, fraction_width);       
      when others =>
        assert false 
         report "flt_pt_delay: Operation option not supported" & 
           " while FLT_PT_SPEED_OPTIMIZED" 
         severity FAILURE;
         del := 42;
      end case;
    when FLT_PT_BASIC =>
      case to_integer(unsigned(op_code))  is
      when FLT_PT_ADD_OP_CODE => 
        del := 5;
      when FLT_PT_SUBTRACT_OP_CODE =>
        del := 5;
      when FLT_PT_MULTIPLY_OP_CODE =>
        if mult_usage > 0 then
          del := 5;
        else
          assert false 
            report "flt_pt_delay: Operation option not supported while" & 
              " FLT_PT_SPEED_OPTIMIZED" 
            severity FAILURE;
        end if;
      when FLT_PT_DIVIDE_OP_CODE =>
        del := 30;
      when FLT_PT_COMPARE_OP_CODE =>
	del :=  2;      
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
    return(del);
  end function;
  
  function flt_pt_get_embedded(w, fw : integer; family : string; 
    mult_usage : integer) return boolean is
  begin
    if (family="virtex4") then
      case mult_usage is
        when FLT_PT_NO_USAGE => return(false);
        when FLT_PT_MEDIUM_USAGE => 
          if fw > 17 and not(fw=34) then 
            return(false);
          else
            -- logic + DSP48 multipliers are converted to DSP48 
            -- (otherwise they would be just logic)
            return(true);
          end if;
        when FLT_PT_FULL_USAGE => return(true);
        when others =>
          assert false 
            report "flt_pt_get_embedded: mult_usage value not supported" 
            severity FAILURE;         
      end case;
    else
      case mult_usage is
        when FLT_PT_NO_USAGE => return(false);
        when FLT_PT_MEDIUM_USAGE => return(true);
        when FLT_PT_FULL_USAGE => return(true);
        when others =>
          assert false 
            report "flt_pt_get_embedded: mult_usage value not supported" 
            severity FAILURE; 
      end case;   
    end if;
  end function;
  
  function flt_pt_get_useDSP48(w, fw : integer; family : string; 
    mult_usage : integer) return boolean is
  begin
    if (family="virtex4") then
      case mult_usage is
        when FLT_PT_NO_USAGE => return(false);
        when FLT_PT_MEDIUM_USAGE => return(true);
        when FLT_PT_FULL_USAGE => return(true);
        when others =>
          assert false 
            report "flt_pt_get_useDSP48: mult_usage value not supported" 
            severity FAILURE;         
      end case;
    else
      return(false); 
    end if;
  end function;
--------------------------------------------------------------------------------
-- Function to provide delays for a particular operation
--------------------------------------------------------------------------------   
  function floating_point_v1_0_check(C_FAMILY : string; C_HAS_ADD, 
  C_HAS_SUBTRACT, C_HAS_MULTIPLY, C_HAS_DIVIDE, C_HAS_SQRT,
  C_HAS_COMPARE, 
  C_RESULT_WIDTH, C_RESULT_FRACTION_WIDTH,
  C_COMPARE_OPERATION, C_OPTIMIZATION, C_MULT_USAGE,
  C_HAS_SCLR,           
  C_HAS_OPERATION_ND, C_HAS_OPERATION_RFD, C_HAS_RDY,
  C_HAS_UNDERFLOW, C_HAS_OVERFLOW, C_HAS_INVALID_OP,
  C_HAS_DIVIDE_BY_ZERO, 
  C_HAS_EXCEPTION,
  C_STATUS_EARLY : integer) return boolean is
    
  variable valid : boolean;
  variable n_op  : integer;
  variable i     : integer;
  variable valid_width : boolean;
      
  constant S_OP_NAME : string := "speed optimized";
  constant U_OP_NAME : string := "basic";
        
  constant HEADER : string := "floating_point_v1_0_check : "; 
  constant NOT_ON_S_OP : string := 
    " not available with core optimized for speed."; 
  constant ONLY_ON_U_OP : string := 
    " only available on basic core.";   
  type int_array is array (natural range <>) of integer;
  
  constant N_OPS : integer := flt_pt_number_of_operations(C_HAS_ADD, 
    C_HAS_SUBTRACT, C_HAS_MULTIPLY, C_HAS_DIVIDE, C_HAS_SQRT, C_HAS_COMPARE,
    0, 0);
  
  function is_valid_width(w, fw : integer) return boolean is
    constant FLT_PT_WIDTHS : int_array := (
      12, 8, 14, 8, 
      14, 10, 16, 10, 
      16, 12, 18, 12, 
      20, 14, 22, 14,
      22, 16, 24, 16, 
      23, 17, 25, 17,
      26, 20, 28, 20, 30, 20, 
      28, 22, 30, 22, 32, 22,
      30, 24, 32, 24, 34, 24,
      42, 34, 
      64, 53); 
    variable i : integer;
    variable valid_width : boolean;
          
  begin
    valid_width := false;
    i := FLT_PT_WIDTHS'left;
    while i <= FLT_PT_WIDTHS'right loop
      if (FLT_PT_WIDTHS(i) = C_RESULT_WIDTH) and 
         (FLT_PT_WIDTHS(i+1) = C_RESULT_FRACTION_WIDTH) then
        valid_width  := true;
        exit;
      end if;
      i := i + 2;
    end loop;
    return (valid_width);
  end function;
  
begin
  valid := false;
    
------------------------------------------------------------------------------- 
-- Check optimization
-------------------------------------------------------------------------------     
  assert ((C_OPTIMIZATION = FLT_PT_UNOPTIMIZED) or 
          (C_OPTIMIZATION = FLT_PT_SPEED_OPTIMIZED))  
    report HEADER & "Optimization is not supported." &
      " Set C_OPTIMIZATION to FLT_PT SPEED_OPTIMISED or " &
      " FLT_PT_UNOPTIMIZED."
      severity FAILURE;
    
------------------------------------------------------------------------------- 
-- Check operations
-------------------------------------------------------------------------------     
    
  assert (N_OPS < 2 or 
   (C_OPTIMIZATION = FLT_PT_SPEED_OPTIMIZED and
    -- Check that only add and subtract are selected
    N_OPS=2 and C_HAS_SUBTRACT=FLT_PT_YES and C_HAS_ADD=FLT_PT_YES) or
    -- Can have multiple operations with Unoptimized 
    (C_OPTIMIZATION = FLT_PT_UNOPTIMIZED)) 
   report HEADER & 
    "Only add and subtract operations can be combined."
    severity FAILURE;
      
  assert (N_OPS > 0) report HEADER & 
    "At least one operation must be enabled."
    severity FAILURE;
    
  if (C_HAS_COMPARE = FLT_PT_YES) then
    assert (C_OPTIMIZATION = FLT_PT_UNOPTIMIZED)
    report HEADER &
      "Compare operation is only available with unoptimized core."
      & " Set C_OPTIMIZATION=FLT_PT_UNOPTIMIZED."
    severity FAILURE;
  end if;
  if (C_HAS_SQRT = FLT_PT_YES) then       
    assert (C_OPTIMIZATION = FLT_PT_SPEED_OPTIMIZED) 
      report HEADER &
        "Sqrt operation is only available with speed optimized core."
        & " Set C_OPTIMIZATION=FLT_PT_SPEED_OPTIMIZED."
      severity FAILURE;
  end if;
      
------------------------------------------------------------------------------- 
-- Check wordlengths width and fraction_width
-------------------------------------------------------------------------------                  
            
  if C_OPTIMIZATION = FLT_PT_UNOPTIMIZED then
    assert ((C_RESULT_FRACTION_WIDTH = 24) and (C_RESULT_WIDTH = 32))
      report HEADER & "Only single precision supported with unoptimized core."
      & " Set C_RESULT_WIDTH=32 and C_RESULT_FRACTION_WIDTH=24."
      severity FAILURE;   
  end if;
    
  valid_width := false;
  if C_OPTIMIZATION = FLT_PT_SPEED_OPTIMIZED then
    assert (is_valid_width(C_RESULT_WIDTH, C_RESULT_FRACTION_WIDTH)) 
      report HEADER & "Format type is" & NOT_ON_S_OP
        & "Set C_RESULT_WIDTH and C_RESULT_FRACTION_WIDTH to valid values."
        severity FAILURE;  
  end if;
------------------------------------------------------------------------------- 
-- Check compare operation
-------------------------------------------------------------------------------  
  assert ((C_COMPARE_OPERATION >= -1) and (C_COMPARE_OPERATION <= 6)) 
    report HEADER & "Compare operation is out of range. Current value"
      & " C_COMPARE_OPERATION= " & integer'image(C_COMPARE_OPERATION)
    severity FAILURE;
------------------------------------------------------------------------------- 
-- Check multiplier usage
-------------------------------------------------------------------------------
  assert (((C_MULT_USAGE >= 0) and (C_MULT_USAGE <= 2)) or 
    ((C_MULT_USAGE >= 16) and (C_MULT_USAGE <= 18))) 
    report HEADER & "Multiplier usage value is out of range. Requested value"
      & " C_MULT_USAGE= " & integer'image(C_MULT_USAGE)
    severity FAILURE;
------------------------------------------------------------------------------- 
-- Check optional control pins
------------------------------------------------------------------------------- 
  if (C_HAS_SCLR = FLT_PT_YES) then
    assert (C_OPTIMIZATION = FLT_PT_UNOPTIMIZED)
      report HEADER & "SCLR" & ONLY_ON_U_OP 
      severity FAILURE;
   end if;
------------------------------------------------------------------------------- 
-- Check handshake signals
-------------------------------------------------------------------------------
  if (C_HAS_OPERATION_ND=FLT_PT_YES)  then 
    assert(C_OPTIMIZATION = FLT_PT_UNOPTIMIZED) 
      report HEADER & "Input OPERATION_ND" & ONLY_ON_U_OP
        & " Set C_HAS_OPERATION_ND=FLT_PT_NO." 
      severity FAILURE;
  end if; 
    
  if (C_HAS_OPERATION_RFD=FLT_PT_YES)  then 
    assert(C_OPTIMIZATION = FLT_PT_UNOPTIMIZED) 
      report HEADER & "Output OPERATION_RFD" & ONLY_ON_U_OP
        & " Set C_HAS_B_OPERATION_RFD=FLT_PT_NO." 
      severity FAILURE;
  end if;  
  
  if (C_HAS_OPERATION_RFD=FLT_PT_YES)  then 
    assert(C_OPTIMIZATION = FLT_PT_UNOPTIMIZED) 
      report HEADER & "Output OPERATION_RFD" & ONLY_ON_U_OP
        & " Set C_HAS_OPERATION_RFD=FLT_PT_NO." 
      severity FAILURE;
  end if;  
--------------------------------------------------------------------------------
-- Optional output signals
--------------------------------------------------------------------------------    
    
  if (C_HAS_EXCEPTION=FLT_PT_YES)  then 
    assert(C_OPTIMIZATION = FLT_PT_UNOPTIMIZED) 
      report HEADER & "Output EXCEPTION" & ONLY_ON_U_OP
        & " Set C_HAS_EXCEPTION=FLT_PT_NO." 
      severity FAILURE;
  end if;  
  
  if (C_HAS_EXCEPTION=FLT_PT_YES)  then 
    assert(C_HAS_DIVIDE = FLT_PT_YES) 
      report HEADER & "Output DIVIDE_BY_ZERO" 
        & " only available with divide operation."
        & " Set C_HAS_DIVIDE_BY_ZERO=FLT_PT_NO." 
      severity FAILURE;
  end if; 
 
  return (valid);
end function;

end package body floating_point_pkg_v1_0;


