------------------------------------------------------------------------------
-- $Id: sync_fifo_pkg_v3_0.vhd,v 1.1 2010-07-10 21:43:23 mmartinez Exp $
-------------------------------------------------------------------------------
-- Name : sync_fifo_pkg.vhd
-- Function : Contains functions used in other files. 
-------------------------------------------------------------------------------
---
-- Author:  Robert Le                                                      ----
-- History:                                                                ----
--               Robert  8/17/00   - Initial draft                         ----
--                       8/25/00   - Add int_2_std_logic_vector            ----
--                       9/12/00   - Add std_logic_vector_2_posint and rat  ---
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE sync_fifo_pkg_v3_0 IS


FUNCTION two_comp(vect : std_logic_vector)
RETURN std_logic_vector;

FUNCTION rat( value : std_logic )
RETURN std_logic;




FUNCTION int_2_std_logic_vector( value, bitwidth : INTEGER )
RETURN std_logic_vector;


FUNCTION log2roundup(data_value : INTEGER)
RETURN INTEGER;

FUNCTION get_lesser (a: INTEGER; b: INTEGER)
RETURN INTEGER;

FUNCTION  calc_read_depth (wr_depth: INTEGER; wr_width: INTEGER; rd_width: INTEGER) 
RETURN INTEGER;

FUNCTION  zero_string (length: INTEGER)
RETURN STRING;

FUNCTION  ones_string (length: INTEGER)
RETURN STRING;

FUNCTION get_greater (a: INTEGER; b: INTEGER)
RETURN INTEGER;

FUNCTION std_logic_vector_2_posint(vect : std_logic_vector)
RETURN INTEGER;



END  sync_fifo_pkg_v3_0;

PACKAGE BODY sync_fifo_pkg_v3_0 IS


-- ---------------------------------------------------
-- FUNCTION : log2roundup                         --
-- ---------------------------------------------------
FUNCTION log2roundup (data_value: INTEGER)
	RETURN INTEGER IS 
	
	VARIABLE width 		: INTEGER := 4; 
	VARIABLE lower_limit 	: INTEGER := 4;
	VARIABLE upper_limit	: INTEGER := 16;
	
	BEGIN
		FOR i IN (lower_limit -1) TO (upper_limit -1) LOOP
			IF (data_value <= 0) THEN
				width := 0;
				EXIT;
			ELSIF (data_value > (2**i)) THEN   
				width := i + 1;
          		ELSE
          			width := width;
          		END IF;          			
      		END LOOP;
	RETURN width;
END log2roundup;

-- ---------------------------------------------------
-- FUNCTION : get_lesser                          --
-- ---------------------------------------------------
FUNCTION get_lesser (a: INTEGER; b: INTEGER)
	RETURN INTEGER IS
	VARIABLE smallest : INTEGER := 1;
	
	BEGIN
		IF (a < b) THEN
          		smallest := a;
          	ELSE
          		smallest := b;
          	END IF;          			
	RETURN smallest;
END get_lesser;	

-- ---------------------------------------------------
-- FUNCTION : calc_read_depth                     --
-- ---------------------------------------------------
FUNCTION  calc_read_depth (wr_depth: INTEGER; wr_width: INTEGER; rd_width: INTEGER) 
 RETURN INTEGER IS
 VARIABLE read_depth : INTEGER := 256;		

 BEGIN
	read_depth := ((wr_depth+1)*(wr_width))/rd_width;
 RETURN read_depth;
 END calc_read_depth;

--------------------------------------------------------
---  FUNCION : zero_string           -------------------
--------------------------------------------------------

FUNCTION zero_string (length: INTEGER) RETURN STRING IS
       VARIABLE zeros : string(1 TO length);
       BEGIN
               FOR i IN 1 TO length LOOP
                       zeros(i) := '0';
               end LOOP;
       RETURN zeros;
END zero_string;

--------------------------------------------------------
---  FUNCION : ones_string           -------------------
--------------------------------------------------------

FUNCTION ones_string (length: INTEGER) RETURN STRING IS
       VARIABLE ones : string(1 TO length);
       BEGIN
               FOR i IN 1 TO length LOOP
                       ones(i) := '1';
               end LOOP;
       RETURN ones;
END ones_string;

--------------------------------------------------------
---  FUNCION : get_greater           -------------------
--------------------------------------------------------

FUNCTION get_greater(a: INTEGER; b: INTEGER) RETURN INTEGER IS
       VARIABLE largest : INTEGER;
       BEGIN
               IF (a > b) THEN
                       largest := a;
               ELSE
                       largest := b;
               END IF;
       RETURN largest;
END get_greater;

-- ------------------------------------------------------------------------ --
 
  FUNCTION two_comp(vect : std_logic_vector)
    RETURN std_logic_vector IS
 
  variable local_vect : std_logic_vector(vect'HIGH downto 0);
  variable toggle : INTEGER := 0;
 
  BEGIN
 
    FOR i IN 0 to vect'HIGH LOOP
      IF (toggle = 1) THEN
        IF (vect(i) = '0') THEN
          local_vect(i) := '1';
        ELSE
          local_vect(i) := '0';
        END IF;
      ELSE
        local_vect(i) := vect(i);
        IF (vect(i) = '1') THEN
          toggle := 1;
        END IF;
      END IF;
    END LOOP;
 
    RETURN local_vect;
 
  END two_comp;


-- ------------------------------------------------------------------------ --

  FUNCTION int_2_std_logic_vector( value, bitwidth : INTEGER )
    RETURN std_logic_vector IS

    VARIABLE running_value  : INTEGER := value;
    VARIABLE running_result : std_logic_vector(bitwidth-1 DOWNTO 0);

  BEGIN  

    IF (value < 0) THEN
      running_value := -1 * value;
    END IF;

    FOR i IN 0 TO bitwidth-1 LOOP

      IF running_value MOD 2 = 0 THEN
        running_result(i) := '0';
      ELSE 
        running_result(i) := '1';
      END IF;
        running_value := running_value/2;
    END LOOP;

    IF (value < 0) THEN -- find the 2s complement
       RETURN two_comp(running_result);
    ELSE   
      RETURN running_result;
    END IF;
 
  END int_2_std_logic_vector;



  FUNCTION rat( value : std_logic )
    RETURN std_logic IS

  BEGIN

    CASE value IS
      WHEN '0' | '1' => RETURN value;
      WHEN 'H' => RETURN '1';
      WHEN 'L' => RETURN '0';
      WHEN OTHERS => RETURN 'X';
    END CASE;

  END rat;



  FUNCTION std_logic_vector_2_posint(vect : std_logic_vector)
    RETURN INTEGER IS

    variable result : INTEGER := 0;

  BEGIN

    FOR i in vect'HIGH downto vect'LOW LOOP
      result := result * 2;
      IF (rat(vect(i)) = '1') THEN
        result := result + 1;
      ELSIF (rat(vect(i)) /= '0') THEN
        ASSERT FALSE
          REPORT "Treating a non 0-1 std_logic_vector as 0 in std_logic_vector_2_posint"
          SEVERITY WARNING;
      END IF;
    END LOOP;

    RETURN result;

  END std_logic_vector_2_posint;




END sync_fifo_pkg_v3_0;

