-- ************************************************************************
-- $Id: da_1d_dct_pack_v2_1.vhd
-- ************************************************************************
-- Copyright 2001 - Xilinx Inc.
-- All rights reserved.
-- ************************************************************************
-- Filename: da_1d_dct_pack_v2_1.vhd
-- Creation : May 9th, 2001
-- Description: Function package for VHDL Behavioral Model for 
--              1D DCT operation
-- 
-- Equations: Even DCT                                               
--                                                                   
--            N-1                                        
--  X(k) = SUM { c_k * x(n) * cos((pi*(2n+1)k) /(2*N)) } 
--            n=0                                        
--                                 where k = 0,1, ... ,N-1            
--                                                                   
-- Even IDCT                                                         
--            N-1                                        
--  x(n) = SUM { c_k * X(k) * cos((pi*(2n+1)k) /(2*N)) } 
--            k=0                                        
--                                 where n = 0,1, ... ,N-1            
--                                                                   
--           NOTE :  c_k = 1/sqrt(N)        for k=0                         
--                       = sqrt(2)/sqrt(N)  for k=1,2,..,N-1                
--                                                                   
-- *******************************************************************
-- Last Change :
--
-- *********************************************************************

library ieee;  
use ieee.std_logic_1164.all;
--use ieee.STD_LOGIC_SIGNED.all;

library XilinxCoreLib;
use XilinxCoreLib.ul_utils.all;
use XilinxCoreLib.iputils_std_logic_signed.all;

------------------------------------------------------------------------------
-- FUNCTIONS
------------------------------------------------------------------------------
package da_1d_dct_pack_v2_1 is   
  
  ---------------------------------------------------------------------------------------
  -- CONSTANTS
  ---------------------------------------------------------------------------------------
  constant  FORWARD_DCT         : integer := 0;
  constant  INVERSE_DCT         : integer := 1;
  constant  FORWARD_INVERSE_DCT : integer := 2;
  
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
  constant MAX_RESULT_WIDTH     : integer := 54;
  --------------------------------------------------------------------------------------
  -- FUNCTION declarations
  -------------------------------------------------------------------------------------- 
  FUNCTION getDataWidth( c_data_width, c_data_type : INTEGER) return INTEGER;
  FUNCTION data_type_adjust(data:std_logic_vector; data_type:integer) return std_logic_vector;
  FUNCTION getResultWidth( c_result_width, c_points, c_data_width, c_data_type, c_coeff_width,c_precision_control: INTEGER) return INTEGER;
    
  FUNCTION cosine(theta : real) return real;
  FUNCTION uslv_mult(multiplicant, multiplier : std_logic_vector) return std_logic_vector;
  FUNCTION slv_mult(multiplicant, multiplier : std_logic_vector; is_signed: integer) return std_logic_vector;
  
  FUNCTION slv_to_unsigned_int( vector: std_logic_vector ) return INTEGER;
  FUNCTION slv_to_signed_int( vector: std_logic_vector ) return INTEGER;
  FUNCTION slv_to_int( vector: std_logic_vector; vectorType: INTEGER ) return INTEGER; 
  
  FUNCTION int_to_slv( value, length: integer ) return std_logic_vector;
  FUNCTION real_to_slv( value: real; length, c_precision_control: integer ) return std_logic_vector;
  FUNCTION trim_result( value: std_logic_vector; length, c_precision_control: integer ) return std_logic_vector;
  
  FUNCTION numberLevels( value: INTEGER ) return INTEGER;
  FUNCTION calculateNumberClocks( c_data_width, c_clks_per_sample, c_points, c_operation, c_enable_symmetry: INTEGER ) return INTEGER;
  FUNCTION calc_sqrt_c_points (c_points : INTEGER) return REAL;
  
  -- The k and n variables are maintained as per the equation above
  FUNCTION calculateDCTPoint( k, n, c_points: INTEGER ) return real;
  FUNCTION calculateIDCTPoint( k, n, c_points: INTEGER ) return real; 
  
  TYPE coefficientArray is array (natural range <>, natural range <>) of  real;
  
  FUNCTION generateCoefficients( c_points, coefficientType: integer ) return coefficientArray;
  
end;

package body da_1d_dct_pack_v2_1 is

FUNCTION getDataWidth( c_data_width, c_data_type : INTEGER) return INTEGER is
variable DataWidth : INTEGER := c_data_width;
BEGIN
if(c_data_type = UNSIGNED_VALUE) then
DataWidth := c_data_width + 1;
end if;

return DataWidth;
END getDataWidth;
-- convert the input data, depending on the datatype
FUNCTION data_type_adjust(data:std_logic_vector; data_type:integer) return std_logic_vector is

VARIABLE returnSLV : std_logic_vector((getDataWidth(data'length,data_type) - 1) downto 0);

BEGIN

if(data_type = SIGNED_VALUE) then
returnSLV := data;
else
returnSLV := '0' & data;
end if;

return returnSLV;

end data_type_adjust;
-- Determines the result width 
-- IF the c_result_width is a positive non-zero number then this is the final result
-- ELSE the core determines the appropriate number of bits that the output can be providing a full precision output
FUNCTION getResultWidth( c_result_width, c_points, c_data_width, c_data_type, c_coeff_width, c_precision_control: INTEGER) return INTEGER is

variable resultWidth: INTEGER := c_result_width;

BEGIN

if(c_precision_control = FULL_PRECISION) then
    -- assuming that c_data_type is UNSIGNED or SIGNED and UNSIGNED = 1 and SIGNED = 0
  resultWidth := c_data_width + c_data_type + c_coeff_width + numberLevels( c_points );
else
  resultWidth := c_result_width;
end if;

return resultWidth;

END getResultWidth;


-- Calculate the COSINE value
FUNCTION cosine(theta : real) return real is

variable term, sum : real;
variable n : integer;

variable full_cycles :real := 0.0;
variable local_theta : real := theta;
BEGIN
term := 1.0;
sum := 1.0;
n := 0;

-- performing a modulo operation on real valued cosine_angle
-- to limit it to +PI to -PI.
full_cycles := (theta/(2.0*PI));

-- to perform truncation of real to integer value
-- and since integer(_real_) does a rounding to nearest integer,
-- adjusting full_cycles
if(full_cycles >= 0.0) then
full_cycles := full_cycles - 0.5;
else
full_cycles := full_cycles + 0.5;
end if;

-- getting the remainder when theta is divided by 2*PI
local_theta := local_theta - (real(integer(full_cycles))*2.0*PI);

for i in 0 to 99 loop
n := n + 2;
term := -term*local_theta**2/real((n-1)*n);
sum := sum + term;
end loop;
return sum;
end cosine;
-- multiplication for unsigned std_logic_vector
  FUNCTION uslv_mult(multiplicant, multiplier : std_logic_vector) return std_logic_vector is
    
    VARIABLE multiplicant_width : integer := multiplicant'length;
    VARIABLE multiplier_width : integer := multiplier'length;
    VARIABLE product_width : integer := multiplicant_width + multiplier_width;
    VARIABLE remaining_bits : integer := 0;
    VARIABLE partial_sum : std_logic_vector((product_width -1) downto 0) := (others => '0');
    VARIABLE sum : std_logic_vector((product_width -1) downto 0) := (others => '0');
    
    VARIABLE zeros : std_logic_vector((product_width -1) downto 0) := (others => '0');
    
  BEGIN
    
    if (multiplier(0) = '1') then
      sum(multiplicant_width -1 downto 0) := multiplicant;
    else
      sum(multiplicant_width -1 downto 0) := (others => '0');
    end if;
    
    for index in 1 to (multiplier_width - 1) loop
      
      partial_sum := (others => '0');
      remaining_bits := product_width - multiplicant_width - index;
      
      if (multiplier(index) = '1') then
        partial_sum :=zeros(remaining_bits - 1 downto 0) & multiplicant & zeros(index - 1 downto 0);
      end if;
      
      sum:= sum + partial_sum;
      
    end loop;
    
    return sum;
    
  END uslv_mult;
-- multiplication for std_logic_vector  
  FUNCTION slv_mult(multiplicant, multiplier : std_logic_vector; is_signed: integer) return std_logic_vector is
  
  VARIABLE multiplicant_width : integer := multiplicant'length;
  VARIABLE multiplier_width : integer := multiplier'length;
  VARIABLE product_width : integer := multiplicant_width + multiplier_width;
  VARIABLE product : std_logic_vector((product_width - 1) downto 0) := (others => '0');
  VARIABLE tmp_multiplicant : std_logic_vector(multiplicant_width - 1 downto 0);
  VARIABLE tmp_multiplier : std_logic_vector(multiplier_width - 1 downto 0);
  VARIABLE sign_count : integer := 0;
  
  BEGIN
  
  if(is_signed = 0) then
    product := uslv_mult(multiplicant, multiplier);
  else
    if(multiplicant(multiplicant_width -1) = '1') then
      tmp_multiplicant := two_comp(multiplicant); -- 2's complement
      sign_count := 1;
    else
      tmp_multiplicant := multiplicant;
      sign_count := 0;
    end if;

    if(multiplier(multiplier_width -1) = '1') then
      tmp_multiplier := two_comp(multiplier); -- 2's complement
      sign_count := sign_count + 1;
    else
      tmp_multiplier := multiplier;
    end if;
  
    product := uslv_mult(tmp_multiplicant, tmp_multiplier);
    if(sign_count = 1) then -- either of multiplicant or multiplier is negative
      product := two_comp(product); -- 2's complement
    end if;
  end if;
  
  return product;
END slv_mult;

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
-- converts the std_logic_vector to an SIGNED integer value
FUNCTION slv_to_signed_int( vector: std_logic_vector ) return INTEGER is

variable value: integer := 0;
variable index: integer := 0;
variable tmp : std_logic_vector ( vector'length downto 0);
variable tmp1: integer := 0;

begin

if (vector(index) = '1') then
tmp := not(vector) + 1;
tmp1 := std_logic_vector_2_posint(tmp);
value := tmp1 * (-1);
else
value := std_logic_vector_2_posint(vector);
end if;

return value;
end slv_to_signed_int;
-- converts the std_logic_vector to an specified integer value
FUNCTION slv_to_int( vector: std_logic_vector; vectorType: integer ) return INTEGER is

variable value: integer := 0;

begin

if vectorType = 0 then
value := std_logic_vector_2_posint(vector); 
else
value := slv_to_signed_int( vector ); 
end if;

return value;
end slv_to_int;  

-- converts the INTEGER value into a std_logic_vector 
-- NOTE that the MSB is considered the SIGN bit
FUNCTION int_to_slv( value, length: integer ) return std_logic_vector is

VARIABLE  returnSLV:  std_logic_vector( (length -1) downto 0) := (others => '0');

VARIABLE  maxNeg   :  integer := -(2**(length - 1));
VARIABLE  maxPos   :  integer := (2 ** (length -1)) - 1;  
VARIABLE  tempValue:  integer := value; 

BEGIN

  -- check to see if the INTEGER value exceeds the precision of the target std_logic_vector
  if (value < maxNeg) then
    -- value is less then the maximum negative value that the std_logic_vector can represent, 
    -- set to saturated maximum negative value, rest default to '0'
    returnSLV(length - 1) := '1';
  elsif (value > maxPos) then
    -- value is greater then the maximum positive value that the std_logic_vector can represent, 
    -- set to saturated maximum positive value, rest default to '0'
    for bitIndex in 0 to (length - 2) loop
      returnSLV(bitIndex) := '1';
    end loop;           
  else
    -- the value is within range, determine the 
    for bitIndex in 0 to (length - 1) loop
      if ((tempValue mod 2) = 1) then
        returnSLV(bitIndex) := '1';
      else 
        returnSLV(bitIndex) := '0';
      end if;
      tempValue := tempValue/2; 
    end loop;           
  end if;  
  
  return returnSLV;
  
END int_to_slv;

-- convert the real input value to a standard logic vector
FUNCTION real_to_slv( value: real; length, c_precision_control: integer ) return std_logic_vector is

variable returnSLV : std_logic_vector((length - 1) downto 0):= (others => '0');
variable adjustedValue: real := value;
variable adjustedValue1: real := value;

BEGIN

-- since integer(real_number) does a rounding, for truncating
if ( c_precision_control = TRUNCATE ) then
if (adjustedValue >= 0.0) then
adjustedValue := adjustedValue - 0.5;
else
adjustedValue := adjustedValue + 0.5;  
end if;
end if;   
--returnSLV := CONV_STD_LOGIC_VECTOR( integer(adjustedValue), length );
returnSLV := int_2_std_logic_vector( integer(adjustedValue), length );
return returnSLV;

END real_to_slv;
-- trim the slv result value to required bitwidths
FUNCTION trim_result( value: std_logic_vector; length, c_precision_control: integer ) return std_logic_vector is

variable input_length : integer := value'length;
variable adjustedValue: std_logic_vector(length -1 downto 0);

-- having 1 extra bit for sign, to make it an unsigned number and
-- hence allow usage of std_logic arithmetic operation like >, = etc
-- instead of casting them with std_ulogic operations.
variable half, zero: std_logic_vector(input_length - length downto 0) := (others => '0');
variable one : std_logic_vector(length - 1 downto 0) := (others => '0');

BEGIN

  -- truncating and/or passing full precision when input_length = length
  adjustedValue := value(input_length - 1 downto input_length - length);
  
	if((c_precision_control  = ROUND) and (input_length > length)) then

	  half(input_length - length - 1) := '1';  -- setting the MSB bit = '1', and leaving sign bit = '0'
	  one(0) := '1';  -- setting the MSB bit = '1', and leaving sign bit = '0'

		if(((value(input_length -1 ) = '0') and (('0' & value(input_length - length - 1 downto 0)) >= half)) or
		    ((value(input_length -1 ) = '1') and (('0' & value(input_length - length - 1 downto 0)) > half))) then
			adjustedValue := adjustedValue + one;
		end if;

    -- It is SIGNED number and to check for saturation use sign comparison
    -- sign comparison indicates any possible overflow or underflow
    -- and so we revert back to the original number (or to
    -- maxpositive/maxnegative number, since here only 1 is added
    -- maxpositive/maxnegative number shall be same as the original truncated
    -- number
    if(adjustedValue(length -1 ) = '1') and (value(input_length -1) = '0') then
      adjustedValue := value(input_length - 1 downto input_length - length);
    end if;

	end if;

  return adjustedValue;

END trim_result;

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
-- determine how many clock cycles will be required for a set of samples
FUNCTION calculateNumberClocks( c_data_width, c_clks_per_sample, c_points, c_operation, c_enable_symmetry: INTEGER ) return INTEGER is

VARIABLE  BitsAtATime : integer := (c_data_width + (c_clks_per_sample -1))/c_clks_per_sample;
VARIABLE  numberClocks: integer := (c_data_width + (BitsAtATime -1))/BitsAtATime;

BEGIN  

-- if the symmetry can be exploited then an additional clock cycle maybe required
if ((c_operation = FORWARD_DCT) and (c_enable_symmetry = 1)) then
BitsAtATime := (c_data_width + 1 + (c_clks_per_sample -1))/c_clks_per_sample;
numberClocks := (c_data_width + 1 + (BitsAtATime - 1))/BitsAtATime;
end if;

if ( numberClocks <= c_points ) then
  numberClocks := c_points ;
end if;

return numberClocks; 

END calculateNumberClocks;

-- calculate the sqroot of c_points, used in function calculateDCTPoint and calculateIDCTPoint
FUNCTION calc_sqrt_c_points (c_points : INTEGER) return REAL is

VARIABLE result : REAL := 0.0;
BEGIN
case c_points is
    when 4 => result := 2.00000000000000;
    when 5 => result := 2.23606797749978;
    when 6 => result := 2.44948974278317;
    when 7 => result := 2.64575131106459;
    when 8 => result := 2.82842712474619;
    when 9 => result := 3.00000000000000;
    when 10=> result := 3.16227766016837;
    when 11=> result := 3.31662479035539;
    when 12=> result := 3.46410161513775;
    when 13=> result := 3.60555127546398;
    when 14=> result := 3.74165738677394;
    when 15=> result := 3.87298334620741;
    when 16=> result := 4.00000000000000;
    when 17=> result := 4.12310562561766;
    when 18=> result := 4.24264068711928;
    when 19=> result := 4.35889894354067;
    when 20=> result := 4.47213595499957;
    when 21=> result := 4.58257569495584;
    when 22=> result := 4.69041575982342;
    when 23=> result := 4.79583152331271;
    when 24=> result := 4.89897948556635;
    when 25=> result := 5.00000000000000;
    when 26=> result := 5.09901951359278;
    when 27=> result := 5.19615242270663;
    when 28=> result := 5.29150262212918;
    when 29=> result := 5.38516480713450;
    when 30=> result := 5.47722557505166;
    when 31=> result := 5.56776436283002;
    when 32=> result := 5.65685424949238;
    when others => result := 8.00000000000000000;
end case;
return result;
end calc_sqrt_c_points;

-- Calculate a DCT table coefficient value
FUNCTION calculateDCTPoint( k, n, c_points: INTEGER ) return real is

VARIABLE sqrt_c_points : real := calc_sqrt_c_points(c_points);
VARIABLE c_k           : real := sqrt_2/sqrt_c_points;
VARIABLE cosine_angle  : real := (PI * (real(n) + 0.5) * real(k))/real(c_points);
VARIABLE resultValue   : real := 0.0;

BEGIN

if (k = 0) then
c_k := 1.0/sqrt_c_points;
end if;

-- compute the final constant value 
resultValue := c_k * cosine(cosine_angle);

return resultValue;
END calculateDCTPoint;

-- Calculate a IDCT table coefficient value
FUNCTION calculateIDCTPoint( k, n, c_points: INTEGER ) return real is

VARIABLE sqrt_c_points : real := calc_sqrt_c_points(c_points);
VARIABLE c_k           : real := sqrt_2/sqrt_c_points;
VARIABLE cosine_angle  : real := (PI * (real(n) + 0.5) * real(k))/real(c_points);
VARIABLE resultValue: real;

BEGIN

if( k = 0 ) then
c_k := 1.0/sqrt_c_points;
end if;

resultValue := c_k * cosine(cosine_angle);

return resultValue;

END calculateIDCTPoint;

-- calculate a table of either DCT or IDCT coefficients
FUNCTION generateCoefficients( c_points, coefficientType: integer )  return coefficientArray is

VARIABLE coeffArray: coefficientArray( 0 to (c_points - 1), 0 to (c_points - 1));

BEGIN

for k in 0 to (c_points -1 ) loop
for n in 0 to (c_points - 1) loop
if coefficientType = FORWARD_DCT then
coeffArray(k, n) := calculateDCTPoint( k, n, c_points );
else
coeffArray(n, k) := calculateIDCTPoint( k, n, c_points ); 
end if;


end loop;
end loop;

return coeffArray;

END generateCoefficients;

end da_1d_dct_pack_v2_1;
