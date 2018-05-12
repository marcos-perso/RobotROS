-- ************************************************************************
-- $Id: da_2d_dct_pack_v2_0.vhd
-- ************************************************************************
-- Copyright 2001 - Xilinx Inc.
-- All rights reserved.
-- ************************************************************************
-- Filename: da_2d_dct_pack_v2_0.vhd
-- Creation : May 9th, 2001
-- Description: Function package for VHDL Behavioral Model for 
--              2D DCT operation
-- 
-- Equations: Even 1D DCT                                               
--                                                                   
--            N-1                                        
--  X(k) = SUM { c_k * x(n) * cos((pi*(2n+1)k) /(2*N)) } 
--            n=0                                        
--                                 where k = 0,1, ... ,N-1            
--                                                                   
-- Even 1D IDCT                                                         
--            N-1                                        
--  x(n) = SUM { c_k * X(k) * cos((pi*(2n+1)k) /(2*N)) } 
--            k=0                                        
--                                 where n = 0,1, ... ,N-1            
--                                                                   
--           NOTE :  c_k = 1/sqrt(N)        for k=0                         
--                       = sqrt(2)/sqrt(N)  for k=1,2,..,N-1                
--  
--
--  2D Forward or Inverse DCT implementation
--
--             ,---------,      ,---------,      ,---------,
--             |1D F/IDCT|      |Transpose|      |1D F/IDCT|
--       ----->|         |----->| Memory  |----->|         |---->
--             | Row Data|      |         |      |Col Data |
--             `---------'      `---------'      `---------'
-- *******************************************************************
-- Last Change :
--
-- *********************************************************************

library ieee;  
use ieee.std_logic_1164.all;
--use ieee.STD_LOGIC_SIGNED.all;

library XilinxCoreLib;
use XilinxCoreLib.ul_utils.all;
use XilinxCoreLib.iputils_std_logic_SIGNED.all;

------------------------------------------------------------------------------
-- FUNCTIONS
------------------------------------------------------------------------------
package da_2d_dct_pack_v2_0 is   
  
  ---------------------------------------------------------------------------------------
  -- CONSTANTS
  ---------------------------------------------------------------------------------------
  constant  FORWARD_DCT         : integer := 0;
  constant  INVERSE_DCT         : integer := 1;
	constant  IEEE1180_IDCT       : integer := 2;
  constant  FORWARD_INVERSE_DCT : integer := 3;
  
  constant  FULL_PRECISION      : integer := 0;
  constant  TRUNCATE            : integer := 1;
  constant  ROUND               : integer := 2;
  
  constant  UNSIGNED_VALUE      : integer := 1;
  constant  SIGNED_VALUE        : integer := 0;
  
  constant SQRT_2               : REAL    := 1.414213562373;
  constant PI                   : REAL    := 3.141592653;
  
  constant MAX_C_POINTS         : integer := 32;
  constant MAX_DATA_WIDTH       : integer := 24;
  constant MAX_COEFF_WIDTH      : integer := 24;
  constant MAX_INTERNAL_WIDTH   : integer := 52;
  constant MAX_RESULT_WIDTH     : integer := 79;

	constant UNSATURATED_INTERNAL_WIDTH : integer := 19;
	constant UNSATURATED_RESULT_WIDTH : integer := 16;

  --------------------------------------------------------------------------------------
  -- FUNCTION declarations
  -------------------------------------------------------------------------------------- 
  FUNCTION effective_operation( c_operation: INTEGER) return INTEGER;
  FUNCTION numberLevels( value: INTEGER ) return INTEGER;

  FUNCTION get_unsat_internalwidth(c_operation, c_points, c_data_width, c_data_type, c_internal_width, c_coeff_width,c_precision_control: INTEGER) return INTEGER;
  FUNCTION get_sat_internalwidth(c_operation, c_points, c_data_width, c_data_type, c_internal_width, c_coeff_width,c_precision_control: INTEGER) return INTEGER;
  FUNCTION get_unsat_resultwidth(c_operation, c_points, c_data_width, c_data_type, c_internal_width, c_result_width, c_coeff_width, c_precision_control: INTEGER) return INTEGER;
  FUNCTION get_sat_resultwidth(c_operation, c_points, c_data_width, c_data_type, c_internal_width, c_result_width, c_coeff_width, c_precision_control: INTEGER) return INTEGER;
    
  FUNCTION saturate_logic(data:std_logic_vector;data_width,saturation_width:integer) return std_logic_vector;

  FUNCTION slv_to_unsigned_int( vector: std_logic_vector ) return INTEGER;
  
end;

package body da_2d_dct_pack_v2_0 is

  -- This function is specifically for the column-1d-dct since
	-- the ieee1180 is basically idct and hence we need to pass that
	-- information to it.
  FUNCTION effective_operation( c_operation: INTEGER) return INTEGER is
	variable operation :integer := c_operation;
	begin
	 if c_operation = IEEE1180_IDCT then
	   operation := INVERSE_DCT;
	 else
	   operation := c_operation;
	 end if;

	 return operation;
	end effective_operation;

  -- Determine the number of bits needed to represent the input number as an UNSIGNED integer
  FUNCTION numberLevels( value: INTEGER ) return INTEGER is

  VARIABLE compareValue: INTEGER := 1;
  VARIABLE base:        INTEGER := 0;

  BEGIN

  while compareValue < value loop
  compareValue := compareValue * 2;
  base := base + 1;
  end loop;

  return base;

  END numberLevels;


  FUNCTION get_unsat_internalwidth(c_operation, c_points, c_data_width, c_data_type, c_internal_width, c_coeff_width,c_precision_control: INTEGER) return INTEGER is

  variable internalWidth: INTEGER := c_internal_width;

  BEGIN

  if c_operation = IEEE1180_IDCT then
    internalWidth := UNSATURATED_INTERNAL_WIDTH;
  else
    if(c_precision_control = FULL_PRECISION) then
			internalWidth := c_data_width + c_coeff_width + numberLevels( c_points );
			if c_data_type = UNSIGNED_VALUE then
			  internalWidth := internalWidth + 1;
			end if;
    else
      internalWidth := c_internal_width;
    end if;
  end if;

  return internalWidth;

  END get_unsat_internalwidth;


  FUNCTION get_sat_internalwidth(c_operation, c_points, c_data_width, c_data_type, c_internal_width, c_coeff_width,c_precision_control: INTEGER) return INTEGER is

  variable internalWidth: INTEGER := c_internal_width;

  BEGIN

  if c_operation = IEEE1180_IDCT then
    internalWidth := c_internal_width; 
  else
    if(c_precision_control = FULL_PRECISION) then
			internalWidth := c_data_width + c_coeff_width + numberLevels( c_points );
			if c_data_type = UNSIGNED_VALUE then
			  internalWidth := internalWidth + 1;
			end if;
    else
      internalWidth := c_internal_width;
    end if;
  end if;

  return internalWidth;

  END get_sat_internalwidth;


  -- Determines the unsaturated result width 
  -- IF the c_result_width is a positive non-zero number then this is the final result
  -- ELSE the core determines the appropriate number of bits that the output can be providing a full precision output
  FUNCTION get_unsat_resultwidth(c_operation, c_points, c_data_width, c_data_type, c_internal_width, c_result_width, c_coeff_width, c_precision_control: INTEGER) return INTEGER is
  
  variable internalWidth: INTEGER := get_sat_internalwidth(c_operation, c_points, c_data_width, c_data_type, c_internal_width, c_coeff_width,c_precision_control);
  variable resultWidth: INTEGER := c_result_width;

  BEGIN

  if (c_operation = IEEE1180_IDCT) then
    resultWidth := UNSATURATED_RESULT_WIDTH;
  else
    if(c_precision_control = FULL_PRECISION) then
      -- assuming that c_data_type is UNSIGNED or SIGNED and UNSIGNED = 1 and SIGNED = 0
      resultWidth := internalWidth + c_coeff_width + numberLevels( c_points );
    else
      resultWidth := c_result_width;
    end if;
  end if;

  return resultWidth;

  END get_unsat_resultwidth;

  -- Determines the saturated result width 
  -- IF the c_result_width is a positive non-zero number then this is the final result
  -- ELSE the core determines the appropriate number of bits that the output can be providing a full precision output
  FUNCTION get_sat_resultwidth(c_operation, c_points, c_data_width, c_data_type, c_internal_width, c_result_width, c_coeff_width, c_precision_control: INTEGER) return INTEGER is
  
  variable internalWidth: INTEGER := get_sat_internalwidth(c_operation, c_points, c_data_width, c_data_type, c_internal_width, c_coeff_width,c_precision_control);
  variable resultWidth: INTEGER := c_result_width;

  BEGIN

  if  c_operation = IEEE1180_IDCT  then
    resultWidth := c_result_width;
  else
    if c_precision_control = FULL_PRECISION  then
      -- assuming that c_data_type is UNSIGNED or SIGNED and UNSIGNED = 1 and SIGNED = 0
      resultWidth := internalWidth + c_coeff_width + numberLevels( c_points );
    else
      resultWidth := c_result_width;
    end if;
  end if;

  return resultWidth;

  END get_sat_resultwidth;


  FUNCTION saturate_logic(data:std_logic_vector;data_width,saturation_width:integer) return std_logic_vector is

  variable saturated_data : std_logic_vector(saturation_width - 1 downto 0) := (others => '0');
	variable not_sign_bit : std_logic := not(data(data_width - 1));
	variable saturation_magnitude : std_logic_vector(saturation_width - 2 downto 0) := (others => not_sign_bit);
	variable compare_bits : std_logic_vector(data_width - saturation_width downto 0) := (others => data(data_width -1));

  begin
  
  	if(saturation_width = data_width) then
	    saturated_data := data;
		else
  	  if(data((data_width - 1) downto (saturation_width - 1)) = compare_bits) then
	      saturated_data := data(saturation_width -1 downto 0);
  	  else
  	    saturated_data := data(data_width - 1) & saturation_magnitude;
  	  end if;
		end if;
  
  	return saturated_data;

  end saturate_logic;

  -- converts the std_logic_vector to an UNSIGNED integer value
  FUNCTION slv_to_unsigned_int( vector: std_logic_vector ) return INTEGER is
  
  variable value: integer := 0;
  variable index: integer := 0;
  
  begin
  for index in (vector'length -1) downto 0 loop
  if ( vector(index) = '1' ) then value := (value * 2) + 1;
  else value := value * 2;
  end if;  
  end loop;
  
  return value;
  end slv_to_unsigned_int;

end da_2d_dct_pack_v2_0;
