-------------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
-------------------------------------------------------------------------------
--This is the simulation model for the vfft32_v1_0. Have concatenated all the lower
--level vhdl files into this one file to get around an incorrect analyze order
--written by get_models.
--------------------------------------------------------------------------------
----------------vfft32_pkg_v3.vhd------------------------------------------------------
-------------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;


PACKAGE vfft32_pkg_v3 IS

TYPE scaling_profile_type IS ARRAY(0 TO 4) OF INTEGER;


FUNCTION get_delay_addr(W_WIDTH : INTEGER)
RETURN STD_LOGIC_VECTOR;

FUNCTION get_early_delay_addr(W_WIDTH : INTEGER)
RETURN STD_LOGIC_VECTOR;

FUNCTION rat( value : std_logic )
RETURN std_logic;

FUNCTION std_logic_vector_2_posint(vect : std_logic_vector)
RETURN INTEGER;

FUNCTION mult_latency (B_INPUT_WIDTH : INTEGER)
RETURN INTEGER;

FUNCTION greatest2( a_value, b_value : INTEGER )
RETURN INTEGER;

FUNCTION eval( condition : BOOLEAN )
RETURN INTEGER;

FUNCTION cmplx_mult_latency(W_WIDTH, DATA_WIDTH : INTEGER)
RETURN INTEGER;

FUNCTION bfly32_latency (W_WIDTH, DATA_WIDTH : INTEGER)
RETURN INTEGER;

FUNCTION bfly_latency (W_WIDTH, DATA_WIDTH : INTEGER)
RETURN INTEGER;

FUNCTION get_offset_value(fwd_inv: STD_LOGIC; sixteen_string:STRING(1 TO 5); zero_string: STRING(1 TO 5))
RETURN STRING;

END vfft32_pkg_v3;

PACKAGE BODY vfft32_pkg_v3 IS

--note: get_delay_addr provides the std_logic_vector version of the
--bfly32_latency result

FUNCTION get_delay_addr(W_WIDTH : INTEGER)
	RETURN STD_LOGIC_VECTOR IS
	VARIABLE delay_addr : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
 	CASE W_WIDTH IS
 	  WHEN 2 => delay_addr := "0110";
 	  WHEN 3|4 => delay_addr := "0111";
 	  WHEN 5 | 6 | 7 | 8  => delay_addr := "1000";
 	  WHEN 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 => delay_addr := "1001";
 	  WHEN 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 
		| 25 | 26 | 27 | 28 | 29 | 30 | 31 | 32 => delay_addr := "1010";
 	  WHEN OTHERS => delay_addr := "1010"; --"0110";
 	END CASE;
 	return delay_addr;
END get_delay_addr;


--note: get_early_delay_addr provides one less than the result of get_delay_addr 
FUNCTION get_early_delay_addr(W_WIDTH : INTEGER)
	RETURN STD_LOGIC_VECTOR IS
	VARIABLE delay_addr : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
	CASE W_WIDTH IS
	  WHEN 2 => delay_addr := "0101";
	  WHEN 3|4 => delay_addr := "0110";
	  WHEN 5|6|7|8  => delay_addr := "0111";
	  WHEN 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 => delay_addr := "1000";
	  WHEN 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 
		| 25 | 26 | 27 | 28 | 29 | 30 | 31 | 32 => delay_addr := "1001";
	  WHEN OTHERS => delay_addr := "1001";
	END CASE;
	return delay_addr;
END get_early_delay_addr;

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

-- ------------------------------------------------------------------------ --

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

-- ------------------------------------------------------------------------ --

--mult_vgen_latency --

FUNCTION mult_latency (B_INPUT_WIDTH : INTEGER)
	RETURN INTEGER IS
	VARIABLE latency : INTEGER;
BEGIN
	case B_INPUT_WIDTH IS
	  --WHEN  2=> latency := 1;
	  WHEN  3|4=> latency := 1;
	  WHEN 5|6|7|8 => latency :=2;
	  WHEN 9|10|11|12|13|14|15|16 => latency :=3;
	  WHEN 17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32 => latency :=4;
	  WHEN OTHERS => latency := 4;
	END CASE;
	return latency;
END mult_latency;

-- ------------------------------------------------------------------------ --

  FUNCTION greatest2( a_value, b_value : INTEGER )
    RETURN INTEGER IS

  BEGIN

    IF a_value >= b_value THEN
      RETURN a_value;
    ELSE
      RETURN b_value;
    END IF;

  END greatest2;

-- ------------------------------------------------------------------------ --


-- ------------------------------------------------------------------------ --

  FUNCTION eval( condition : BOOLEAN )
    RETURN INTEGER IS

  BEGIN

    IF condition=TRUE THEN
      RETURN 1;
    ELSE
      RETURN 0;
    END IF;

  END eval;

-- ------------------------------------------------------------------------ --

FUNCTION cmplx_mult_latency (W_WIDTH , DATA_WIDTH : INTEGER)
	RETURN INTEGER IS
	
	CONSTANT lat_prod_a_mult : INTEGER := mult_latency(W_WIDTH);
	CONSTANT lat_prod_b_mult : INTEGER := mult_latency(DATA_WIDTH);
	CONSTANT max_prod_mult_latency : INTEGER:= greatest2(lat_prod_a_mult, lat_prod_b_mult);
	VARIABLE latency	: INTEGER;

BEGIN
	latency :=1 + max_prod_mult_latency + 1;
return latency;	
END cmplx_mult_latency;


FUNCTION bfly_latency (W_WIDTH, DATA_WIDTH: INTEGER)
	RETURN INTEGER IS
	VARIABLE latency : INTEGER;
	VARIABLE butterfly_latency :INTEGER;

BEGIN
	butterfly_latency := cmplx_mult_latency(W_WIDTH, DATA_WIDTH+1)+1 ;
	latency := butterfly_latency; 
return latency;
END bfly_latency;

FUNCTION bfly32_latency (W_WIDTH, DATA_WIDTH: INTEGER)
	RETURN INTEGER IS
	VARIABLE latency : INTEGER;
	VARIABLE butterfly_latency :INTEGER;

BEGIN
	butterfly_latency := cmplx_mult_latency(W_WIDTH, DATA_WIDTH)+1 ;
	latency := butterfly_latency +2; 
return latency;
END bfly32_latency;


FUNCTION get_offset_value(fwd_inv: STD_LOGIC; sixteen_string:STRING(1 TO 5); zero_string: STRING(1 TO 5))
	RETURN STRING IS
	VARIABLE return_string : STRING(1 TO 5);
BEGIN
	IF fwd_inv = '0' THEN 
		return_string:= zero_string;
	ELSIF fwd_inv = '1' THEN
		return_string:= sixteen_string;
	END IF;
return return_string;
END get_offset_value;



END vfft32_pkg_v3;

-------------END vfft32_pkg_v3---------------------------------------------------------
-----------------vfft32_comps_v3-------------------------------------------------------
-------------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.vfft32_pkg_v3.all;


PACKAGE vfft32_comps_v3 IS


COMPONENT or_a_b_32_v3 
	GENERIC(c_enable_rlocs	: INTEGER := 1);
	PORT (	a_in	: IN STD_LOGIC;
		b_in   	: IN STD_LOGIC;
		or_out	: OUT STD_LOGIC);
END COMPONENT;

COMPONENT or_a_b_c_32_v3
	GENERIC(c_enable_rlocs	: INTEGER := 1);
	PORT (	a_in	: IN STD_LOGIC;
		b_in   	: IN STD_LOGIC;
		c_in	: IN STD_LOGIC;
		or_out	: OUT STD_LOGIC);
END COMPONENT;

COMPONENT xor_a_b_32_v3
	GENERIC (c_enable_rlocs	: INTEGER := 0);
	PORT (	a_in	: IN STD_LOGIC;
		b_in   	: IN STD_LOGIC;
		xor_out	: OUT STD_LOGIC);
END COMPONENT;

COMPONENT and_a_b_32_v3
	GENERIC (c_enable_rlocs	: INTEGER := 0);
	PORT (	a_in	: IN STD_LOGIC;
		b_in   	: IN STD_LOGIC;
		and_out	: OUT STD_LOGIC);
END COMPONENT;


COMPONENT nand_a_b_32_v3
	GENERIC (c_enable_rlocs	: INTEGER := 1);
	PORT (	a_in	: IN STD_LOGIC;
		b_in   	: IN STD_LOGIC;
		nand_out	: OUT STD_LOGIC);
END COMPONENT;


COMPONENT and_a_notb_32_v3 
	GENERIC(c_enable_rlocs	: INTEGER := 1);
	PORT (	a_in		: IN STD_LOGIC;
		b_in   		: IN STD_LOGIC;
		and_out		: OUT STD_LOGIC);
END COMPONENT;


COMPONENT flip_flop_v3
	PORT (d : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		ce : IN STD_LOGIC;
		reset : IN STD_LOGIC := '0';
		q : OUT STD_LOGIC);
END COMPONENT;

COMPONENT flip_flop_sclr_v3
	PORT (d : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		ce : IN STD_LOGIC;
		reset : IN STD_LOGIC := '0';
		sclr : IN STD_LOGIC := '0';
		q : OUT STD_LOGIC);
END COMPONENT;

COMPONENT flip_flop_sclr_sset_v3
	PORT (d : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		ce : IN STD_LOGIC;
		reset : IN STD_LOGIC := '0';
		sclr : IN STD_LOGIC := '0';
		sset : IN STD_LOGIC := '0';
		q : OUT STD_LOGIC);
END COMPONENT;


COMPONENT flip_flop_ainit_sclr_v3
	GENERIC (ainit_val : STRING :="1");
	PORT (d : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		ce : IN STD_LOGIC;
		ainit : IN STD_LOGIC := '0';
		sclr : IN STD_LOGIC := '0';
		q : OUT STD_LOGIC);
END COMPONENT;

COMPONENT srflop_v3
	PORT (clk	: IN STD_LOGIC;
		ce	:  IN STD_LOGIC;
		set	: IN STD_LOGIC;
		reset	: IN STD_LOGIC;
		q	: OUT STD_LOGIC);
END COMPONENT;

COMPONENT delay_wrapper_v3
	GENERIC (ADDR_WIDTH : INTEGER := 4;
		DEPTH	: INTEGER := 16;
		DATA_WIDTH : INTEGER );
	PORT (addr  : IN STD_LOGIC_VECTOR(ADDR_WIDTH -1 DOWNTO 0);
		data : IN STD_LOGIC_VECTOR(DATA_WIDTH -1 DOWNTO 0);
		clk	: IN STD_LOGIC;
		reset	: IN STD_LOGIC;
		start	: IN STD_LOGIC;
		delayed_data : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0));
END COMPONENT;

COMPONENT complex_mult_v3  		-- a*b; a=(ar+jai) & b=(br=jbi)
	 GENERIC (a_width	: INTEGER;
		  b_width	: INTEGER;
		mult_type:	INTEGER :=1); --0 selects lut mult, 1 selects emb v2 mult
	PORT	(ar	: IN STD_LOGIC_VECTOR(a_width-1 DOWNTO 0);
		 ai	: IN STD_LOGIC_VECTOR(a_width-1 DOWNTO 0);
		 br	: IN STD_LOGIC_VECTOR(b_width-1 DOWNTO 0);
		 bi	: IN STD_LOGIC_VECTOR(b_width-1 DOWNTO 0);
		 clk	: IN STD_LOGIC;
		 ce	: IN STD_LOGIC;
		 reset	: IN STD_LOGIC;
		start	: IN STD_LOGIC;
		 p_re	: OUT STD_LOGIC_VECTOR(a_width+b_width+1 DOWNTO 0); --full pr re o/p
		 p_im	: OUT STD_LOGIC_VECTOR(a_width+b_width+1 DOWNTO 0)  --full pr im o/p
		);
END COMPONENT;



COMPONENT conj_reg_v3
	GENERIC ( B	: INTEGER := 16);  --input data precision
	PORT (clk	: IN STD_LOGIC;
		ce	: IN STD_LOGIC;
		fwd_inv	: IN STD_LOGIC;  -- conjugation control
		dr	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);  --Re input
		di	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);  --Im input
		qr	: OUT STD_LOGIC_VECTOR(B-1  DOWNTO 0);  --Re result
		qi	: OUT STD_LOGIC_VECTOR(B-1  DOWNTO 0));  --Im result
END COMPONENT;



COMPONENT complex_reg_conj_v3
	GENERIC (B	: INTEGER);
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		conj		: in std_logic;				-- conjugation control
									-- forms conjugation when ==1
		dr		: in std_logic_vector(B-1 downto 0);	-- Re/Im data in
		di		: in std_logic_vector(B-1 downto 0);
		qr		: out std_logic_vector(B-1 downto 0);	-- Re/Im data out
		qi		: out std_logic_vector(B-1 downto 0)
	      );
END COMPONENT;


COMPONENT state_machine_v3
	GENERIC (n	: INTEGER);
	PORT (	clk	: IN STD_LOGIC;
		ce	: IN STD_LOGIC;
		start: IN STD_LOGIC;
		reset	: IN STD_LOGIC;
		s	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));  
END COMPONENT;

COMPONENT butterfly_v3
	GENERIC (B	: INTEGER;
		   W_WIDTH : INTEGER;
		memory_architecture : INTEGER;
		mult_type:	INTEGER :=1); --0 selects lut mult, 1 selects emb v2 mult
	PORT (	clk	: IN STD_LOGIC;
		ce	: IN STD_LOGIC;
		start_bf: IN STD_LOGIC;
		start	: IN STD_LOGIC;
		reset	: IN STD_LOGIC;
		scale_factor : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		x0r	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);  --Re operand 0
		x0i	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);  --Im operand 0
		x1r	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);  --Re operand 1
		x1i	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);  --Im operand 1
		done	: IN STD_LOGIC;
		y0r	: OUT STD_LOGIC_VECTOR(B+1 DOWNTO 0);  --Re result 0
		y0i	: OUT STD_LOGIC_VECTOR(B+1 DOWNTO 0);  --Im result 0
		y1r	: OUT STD_LOGIC_VECTOR(B +1 DOWNTO 0);  --Re result 1
		y1i	: OUT STD_LOGIC_VECTOR(B+1  DOWNTO 0);  --Im result 1
		ovflo	: OUT STD_LOGIC;
		wi	: IN STD_LOGIC_VECTOR(W_WIDTH-1 DOWNTO 0);  --Re omega
		wr	: IN STD_LOGIC_VECTOR(W_WIDTH-1 DOWNTO 0);
		io_out : in std_logic;
		edone_s: in std_logic;
		busy_in: in std_logic);  --Im omega
END COMPONENT;

COMPONENT butterfly_32_v3
	GENERIC (B	: INTEGER;
		   W_WIDTH : INTEGER;
		memory_architecture : INTEGER;
		mult_type:	INTEGER :=1); --0 selects lut mult, 1 selects emb v2 mult
	PORT (	clk	: IN STD_LOGIC;
		ce	: IN STD_LOGIC;
		start: IN STD_LOGIC;
		reset	: IN STD_LOGIC;
		conj	: IN STD_LOGIC;
		dr	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);
		ce_phase_factors: OUT STD_LOGIC;
		di	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);
		scale_factor : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		done	: IN STD_LOGIC;
		y0r	: OUT STD_LOGIC_VECTOR(B+1 DOWNTO 0);  --Re result 0
		y0i	: OUT STD_LOGIC_VECTOR(B+1 DOWNTO 0);  --Im result 0
		y1r	: OUT STD_LOGIC_VECTOR(B+1  DOWNTO 0);  --Re result 1
		y1i	: OUT STD_LOGIC_VECTOR(B+1  DOWNTO 0);  --Im result 1
		ovflo	: OUT STD_LOGIC;
		wi	: IN STD_LOGIC_VECTOR(W_WIDTH-1 DOWNTO 0);  --Re omega
		wr	: IN STD_LOGIC_VECTOR(W_WIDTH-1 DOWNTO 0);
		io_out : in std_logic;
		edone_s: in std_logic;
		busy_in: in std_logic);  --Im omega
END COMPONENT;

COMPONENT bflyw_j_v3 
	GENERIC (bfly_width : INTEGER);
	PORT (x0r	: IN STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
		x0i	: IN STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
		x1r	: IN STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
		x1i	: IN STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
		clk	: IN STD_LOGIC;
		ce 	: IN STD_LOGIC;
		start	: IN STD_LOGIC;
		reset : IN STD_LOGIC;
		scale_by : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		y0r	: OUT STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
		y0i	: OUT STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
		y1r	: OUT STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
		y1i	: OUT STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0));
END COMPONENT;

COMPONENT bflyw0_v3 
	GENERIC (bfly_width : INTEGER);
	PORT (x0r	: IN STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
		x0i	: IN STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
		x1r	: IN STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
		x1i	: IN STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
		clk	: IN STD_LOGIC;
		ce 	: IN STD_LOGIC;
		start	: IN STD_LOGIC;
		reset : IN STD_LOGIC;
		scale_by : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		y0r	: OUT STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
		y0i	: OUT STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
		y1r	: OUT STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
		y1i	: OUT STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0));
END COMPONENT;

COMPONENT fft4_32_v3 
	GENERIC ( B:	INTEGER:= 16);
	port (
		clk		: in std_logic;				-- system clock
		reset		: in std_logic;				-- reset
		start		: in std_logic;				-- global start
		ce		: in std_logic;
		conj		: in std_logic;				-- conjugation control
										-- conjugates when == 0
		scale_rank3_by	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		scale_rank4_by	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		x0r		: in std_logic_vector(B-1 downto 0);	-- data input
		x0i		: in std_logic_vector(B-1 downto 0);
		x1r		: in std_logic_vector(B-1 downto 0);	-- data input
		x1i		: in std_logic_vector(B-1 downto 0);
		x2r		: in std_logic_vector(B-1 downto 0);	-- data input
		x2i		: in std_logic_vector(B-1 downto 0);
		x3r		: in std_logic_vector(B-1 downto 0);	-- data input
		x3i		: in std_logic_vector(B-1 downto 0);
		y0r		: out std_logic_vector(B-1 downto 0);	-- transform outp. samples
		y0i		: out std_logic_vector(B-1 downto 0);
		y1r		: out std_logic_vector(B-1 downto 0);
		y1i		: out std_logic_vector(B-1 downto 0);
		y2r		: out std_logic_vector(B-1 downto 0);
		y2i		: out std_logic_vector(B-1 downto 0);
		y3r		: out std_logic_vector(B-1 downto 0);
		y3i		: out std_logic_vector(B-1 downto 0)
	      );
END COMPONENT;



COMPONENT phase_factor_adgen_v3
	GENERIC ( W_WIDTH:	INTEGER:= 16);
	port (
		clk		: in std_logic;				-- system clock
		reset		: in std_logic;				-- reset
		start		: in std_logic;				-- global start
		ce		: in std_logic;
		fwd_inv		: IN STD_LOGIC;
		rank_number	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		w_addr_sine	: OUT STD_LOGIC_VECTOR(4 DOWNTO 0); --shifted by 1/2 cycle 
		w_addr_cos	: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	      );
END COMPONENT ;


COMPONENT hand_shaking_v3
	GENERIC (memory_architecture : INTEGER);
	PORT (clk : IN STD_LOGIC;
		ce : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		start : IN STD_LOGIC;
		result_avail : IN STD_LOGIC;
		eio_pulse_out : IN STD_LOGIC;
		busy	: OUT STD_LOGIC;
		done	: OUT STD_LOGIC;
		edone	: OUT STD_LOGIC);
END COMPONENT;


COMPONENT mem_wkg_r_i_v3
	GENERIC (B : INTEGER;
		POINTS_POWER : INTEGER);
	PORT (	addra	: IN STD_LOGIC_VECTOR(POINTS_POWER-1 DOWNTO 0);
		wea	: IN STD_LOGIC;
		ena	: IN STD_LOGIC;
		dia_r	: IN STD_lOGIC_VECTOR(B-1 DOWNTO 0);
		dia_i	: IN STD_lOGIC_VECTOR(B-1 DOWNTO 0);
		reset	: IN STD_LOGIC;
		clk	: IN STD_LOGIC;
		addrb	: IN STD_LOGIC_VECTOR(POINTS_POWER-1 DOWNTO 0);
		web	: IN STD_LOGIC;
		enb	: IN STD_LOGIC;
		dib_r	: IN STD_lOGIC_VECTOR(B-1 DOWNTO 0);
		dib_i	: IN STD_lOGIC_VECTOR(B-1 DOWNTO 0);
		dob_r	: OUT STD_lOGIC_VECTOR(B-1 DOWNTO 0);
		dob_i	: OUT STD_lOGIC_VECTOR(B-1 DOWNTO 0));
END COMPONENT;

COMPONENT dmem_wkg_r_i_v3
	GENERIC (B : INTEGER;
		POINTS_POWER : INTEGER);
	PORT (	a	: IN STD_LOGIC_VECTOR(POINTS_POWER-1 DOWNTO 0);
		we	: IN STD_LOGIC;
		d_re	: IN STD_lOGIC_VECTOR(B-1 DOWNTO 0);
		d_im	: IN STD_lOGIC_VECTOR(B-1 DOWNTO 0);
		clk	: IN STD_LOGIC;
		dpra	: IN STD_LOGIC_VECTOR(POINTS_POWER-1 DOWNTO 0);
		qdpo_re	: OUT STD_lOGIC_VECTOR(B-1 DOWNTO 0);
		qdpo_im	: OUT STD_lOGIC_VECTOR(B-1 DOWNTO 0));
END COMPONENT;
COMPONENT input_working_result_memory_v3
	GENERIC (B		: INTEGER;
		POINTS_POWER	: INTEGER := 5;
		result_width	: INTEGER :=5;
		data_memory	: STRING :="distributed_memory");
	PORT (	clk	: IN STD_LOGIC;
		reset	: IN STD_LOGIC;
		ce	: IN STD_LOGIC;
		fwd_inv : IN STD_LOGIC;
		dia_r	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0); --intermediate result
		dia_i	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0); --intermediate result
		xn_re	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0); --xn input (ext)
		xn_im	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0); --xn input (ext)
		ena	: IN STD_LOGIC;
		wea	: IN STD_LOGIC;
		addra	: IN STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		addra_dmem	: IN STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		xn_r	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0); 
		xn_i	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0); 
		data_sel	: IN STD_LOGIC_VECTOR(1 DOWNTO 0); 
		--xk_result_re	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);--result from fft4 
		--xk_result_im	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);--result from fft4 
		y0r	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);--result from fft4
		y0i	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);--result from fft4
		y1r	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);--result from fft4
		y1i	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);--result from fft4
		y2r	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);--result from fft4
		y2i	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);--result from fft4
		y3r	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);--result from fft4
		y3i	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);--result from fft4
		we_dmem : IN STD_LOGIC;
		web	: IN STD_LOGIC;
		addrb	: IN STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		addrb_dmem	: IN STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		result_avail : IN STD_LOGIC;	--from bfly_buf_fft pulse
		reading_result	: IN STD_LOGIC;
		writing_result : IN STD_LOGIC;
		mem_outr: OUT STD_LOGIC_VECTOR(B-1 DOWNTO 0); -- to bfly_fft proc. re
		mem_outi: OUT STD_LOGIC_VECTOR(B-1 DOWNTO 0);-- to bfly_fft proc. im
		xk_result_out_re : OUT STD_LOGIC_VECTOR(B-1 DOWNTO 0);  --result_read_out re
		xk_result_out_im : OUT STD_LOGIC_VECTOR(B-1 DOWNTO 0));--result_read_out im		
END COMPONENT;

COMPONENT addr_gen_v3
	GENERIC (points_power : INTEGER :=5;
	memory_architecture : INTEGER :=3);
	PORT (clk	: IN STD_LOGIC;
		ce	: IN STD_LOGIC;
		reset	: IN STD_LOGIC;	
		start	: IN STD_LOGIC;
		io_pulse : IN STD_LOGIC;
		dmsedone : out std_logic;
		delayed_io_pulse_out : OUT STD_LOGIC;
		address	: OUT STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);
		rank_number : OUT STD_LOGIC_VECTOR(2-1 DOWNTO 0));
END COMPONENT;

COMPONENT mem_address_v3 
	GENERIC (points_power : INTEGER := 5;
		memory_configuration : INTEGER :=3);
	PORT (clk	: IN STD_LOGIC;
		ce	: IN STD_LOGIC;
		reset	: IN STD_LOGIC;	
		start	: IN STD_LOGIC;
		mwr	: IN STD_LOGIC;
		io_pulse: IN STD_LOGIC;
		io	: IN STD_LOGIC;
		dmsedone : out std_logic;
		address	: OUT STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);
		rank_number : OUT STD_LOGIC_VECTOR(2-1 DOWNTO 0);
		user_ld_addr : OUT STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);
		busy_usr_loading_addr : OUT STD_LOGIC;
		initial_data_load_x : OUT STD_LOGIC );
END COMPONENT;

COMPONENT mem_ctrl_v3 
	GENERIC ( points_power : INTEGER := 5;
		W_WIDTH		: INTEGER :=16;
		B 		: INTEGER := 16;
		memory_configuration	: INTEGER :=3;
		data_memory	: STRING :="distributed_mem");
	PORT (	clk 	: IN STD_LOGIC;
		ce	: IN STD_LOGIC;
		start 	: IN STD_LOGIC;
		reset	: IN STD_LOGIC;
		mwr	: IN STD_LOGIC;
		mrd	: IN STD_LOGIC;
		usr_loading_addr : IN STD_LOGIC;
		address : IN STD_LOGIC_VECTOR(points_power -1 DOWNTO 0);
		usr_load_addr	: IN STD_LOGIC_VECTOR(points_power -1 DOWNTO 0);
		initial_data_load_x : IN STD_LOGIC;
		rank_number	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		bfly_res_avail	: IN STD_LOGIC;
		e_bfly_res_avail : IN STD_LOGIC; --one clock before bfly_res_avail
		e_done_int	: IN STD_LOGIC;
		done_int	: IN STD_LOGIC;
		result_avail	: IN STD_LOGIC; --pulse
		xbar_y		: OUT STD_LOGIC;
		ext_to_xbar_y_temp_out		: OUT STD_LOGIC_VECTOR(0 DOWNTO 0);

		io			: OUT STD_LOGIC;
		io_pulse		: OUT STD_LOGIC;
		eio_pulse_out		: OUT STD_LOGIC;
		eio			: OUT STD_LOGIC;
		reset_io_out		: OUT STD_LOGIC;
		we_dmem : OUT STD_LOGIC;
		we_dmem_dms:  OUT STD_LOGIC;
		wex_dmem_tms : OUT STD_LOGIC;
		wey_dmem_tms : OUT STD_LOGIC;
		d_a_dmem_dms_sel: OUT STD_LOGIC;
		wea_x : OUT STD_LOGIC;
		wea_y : OUT STD_LOGIC;
		web_x : OUT STD_LOGIC;
		web_y : OUT STD_LOGIC;
		ena_x : OUT STD_LOGIC;
		ena_y : OUT STD_LOGIC;
		data_sel	: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		address_select : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); 
		address_select_dms_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);  
		reading_result : OUT STD_LOGIC;
		writing_result : OUT STD_LOGIC;
		wr_addr : OUT STD_LOGIC_VECTOR(points_power -1 DOWNTO 0);
		addra_dmem	: OUT STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		addra_x_dmem	: OUT STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		addra_y_dmem	: OUT STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		addrb_dmem	: OUT STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		addrb_dmem_dms : OUT STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		addrb_dmem_tms : OUT STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		rd_addrb_x : OUT STD_LOGIC_VECTOR(points_power -1 DOWNTO 0); 
		rd_addrb_y : OUT STD_LOGIC_VECTOR(points_power -1 DOWNTO 0));
END COMPONENT;

COMPONENT working_memory_v3
	GENERIC (B		: INTEGER;
		POINTS_POWER	: INTEGER := 5;
		memory_architecture : INTEGER := 3;
		data_memory: STRING := "distributed_mem");
	PORT (	clk	: IN STD_LOGIC;
		reset	: IN STD_LOGIC;
		start	: IN STD_LOGIC;
		xbar_y	: IN STD_LOGIC;
		ext_to_xbar_y_temp_out		: IN STD_LOGIC_VECTOR(0 DOWNTO 0);

		dia_r	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0); --intermediate result
		dia_i	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0); --intermediate result
		ena_x	: IN STD_LOGIC;
		wea_x	: IN STD_LOGIC;
		wex_dmem_tms : IN STD_LOGIC;
		wey_dmem_tms : IN STD_LOGIC;
		addra	: IN STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		addra_dmem	: IN STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		addra_x_dmem	: IN STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		addra_y_dmem	: IN STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		xn_re	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0); 
		xn_im	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0); 
		web_x	: IN STD_LOGIC;
		we_dmem_dms:  IN STD_LOGIC;
		d_a_dmem_dms_sel: IN STD_LOGIC;
		address_select_dms : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
		usr_loading_addr : IN STD_LOGIC;
		addrb_dmem_dms	: IN STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		addrb_dmem_tms	: IN STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		address_select : IN STD_LOGIC_VECTOR(1 DOWNTO 0); 
		ena_y	: IN STD_LOGIC;
		wea_y	: IN STD_LOGIC;
		web_y	: IN STD_LOGIC;
		mem_outr: OUT STD_LOGIC_VECTOR(B-1 DOWNTO 0); -- to bfly_fft proc. re
		mem_outi: OUT STD_LOGIC_VECTOR(B-1 DOWNTO 0));-- to bfly_fft proc. im		
END COMPONENT;

COMPONENT delay_v3 
	GENERIC(bits	: INTEGER);
	PORT (clk		: in std_logic;
		ce		: IN std_logic;
		din		: in std_logic_vector(bits-1 DOWNTO 0);
		dout		: out std_logic_vector(bits-1 DOWNTO 0)
	);
END COMPONENT;




COMPONENT bfly_buffer_v3
	GENERIC (bfly_width : INTEGER;
		memory_configuration : INTEGER );
	PORT (by0 : IN STD_LOGIC_VECTOR(bfly_width+2 -1 DOWNTO 0);
		by1 : IN STD_LOGIC_VECTOR(bfly_width+2 -1 DOWNTO 0);
		clk : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		start : IN STD_LOGIC;
		e_start : IN STD_LOGIC;
		fft4y0 : OUT STD_LOGIC_VECTOR(bfly_width -1 DOWNTO 0);
		fft4y1 : OUT STD_LOGIC_VECTOR(bfly_width -1 DOWNTO 0);
		fft4y2 : OUT STD_LOGIC_VECTOR(bfly_width -1 DOWNTO 0);
		fft4y3 : OUT STD_LOGIC_VECTOR(bfly_width -1 DOWNTO 0));
END COMPONENT;


COMPONENT bfly_buf_fft_v3
	GENERIC (B	: INTEGER;
		W_WIDTH : INTEGER;
		memory_configuration : INTEGER;
		mem_init_file	: STRING;
		mem_init_file_2	: STRING;
		mult_type:	INTEGER :=1); --0 selects lut mult, 1 selects emb v2 mult
	PORT (	clk	: IN STD_LOGIC;
		ce	: IN STD_LOGIC;
		start	: IN STD_LOGIC;
		reset	: IN STD_LOGIC;
		conj	: IN STD_LOGIC;
		fwd_inv	: IN STD_LOGIC;
		rank_number : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		dr	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);
		di	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);
		done	: IN STD_LOGIC;
		xkr	: OUT STD_LOGIC_VECTOR(B-1  DOWNTO 0);  --Re bfly result to wkg mem x or y --was B downto 0
		xki	: OUT STD_LOGIC_VECTOR(B-1  DOWNTO 0);  --Im 
		wr	: IN STD_LOGIC_VECTOR(W_WIDTH-1 DOWNTO 0);  --Re omega
		wi	: IN STD_LOGIC_VECTOR(W_WIDTH-1 DOWNTO 0);  --Im omega
		e_result_avail : OUT STD_LOGIC; --start_fft4 delayed by 2
		result_avail : OUT STD_LOGIC; --start_fft4 delayed by 2
		e_result_ready : OUT STD_LOGIC;
		bfly_res_avail : OUT STD_LOGIC; --start delayed by bfly32 latency
		e_bfly_res_avail : OUT STD_LOGIC; --start delayed by bfly32 latency -1
		ce_phase_factors: OUT STD_LOGIC;
		ovflo	: OUT STD_LOGIC;
		y0r	: out std_logic_vector(B+3 downto 0);	-- transform outp. samples
		y0i	: out std_logic_vector(B-1 downto 0);
		y1r	: out std_logic_vector(B-1 downto 0);
		y1i	: out std_logic_vector(B-1 downto 0);
		y2r	: out std_logic_vector(B-1 downto 0);
		y2i	: out std_logic_vector(B-1 downto 0);
		y3r	: out std_logic_vector(B-1 downto 0);
		y3i	: out std_logic_vector(B-1 downto 0);
		io_out : in std_logic;
		edone_s: in std_logic;
		busy_in: in std_logic
	      );
END COMPONENT ;


COMPONENT phase_factors_v3
	GENERIC ( W_WIDTH:	INTEGER:= 16);
	port (
		clk		: in std_logic;				-- system clock
		reset		: in std_logic;				-- reset
		start		: in std_logic;				-- global start
		--conj		: IN STD_LOGIC;
		ce		: in std_logic;
		fwd_inv		: IN STD_LOGIC;
		rank_number	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		wr		: OUT STD_LOGIC_VECTOR(W_WIDTH-1 DOWNTO 0);
		wi		: OUT STD_LOGIC_VECTOR(W_WIDTH-1 DOWNTO 0)
	      );
END COMPONENT ;

COMPONENT result_memory_v3
	GENERIC (result_width : INTEGER;
		points_power : INTEGER:= 5;
		data_memory : STRING := "distributed_mem";
		memory_architecture : INTEGER);
	PORT (clk : IN STD_LOGIC;
		ce : IN STD_LOGIC;
		mrd   : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		fwd_inv : IN STD_LOGIC;
		y0r: IN STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);	
		y0i: IN STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
		y1r: IN STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
		y1i: IN STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
		y2r: IN STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
		y2i: IN STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
		y3r: IN STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
		y3i: IN STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
		e_result_avail : IN STD_LOGIC; --from bfly_fft4 processor
		e_result_ready : IN STD_LOGIC;
		reset_io : IN STD_LOGIC;
		eio_out : IN STD_LOGIC;
		result_ready : OUT STD_LOGIC;
		xk_result_re: OUT STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
		xk_result_im: OUT STD_LOGIC_VECTOR(result_width-1 DOWNTO 0));
END COMPONENT;

END vfft32_comps_v3;
-----------------END vfft32_comps_v3-----------------------------------------------------

----------------- flip_flop-----------------------------------------------------
-------------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_REG_FD_V4_0_comp.all;
USE XilinxCoreLib.prims_constants_v4_0.all;
USE XilinxCoreLib.vfft32_comps_v3.all;
USE XilinxCoreLib.vfft32_pkg_v3.all;

ENTITY flip_flop_v3 IS
	PORT (d : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		ce : IN STD_LOGIC;
		reset : IN STD_LOGIC := '0';
		q : OUT STD_LOGIC);
END flip_flop_v3;

ARCHITECTURE behavioral OF flip_flop_v3 IS

CONSTANT zero_string : STRING (1 TO 1) := "0";
SIGNAL d_int : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL q_int : STD_LOGIC_VECTOR(0 DOWNTO 0);

SIGNAL dummy_in : STD_LOGIC := '0';

BEGIN

dummy_in <= '0';

d_int(0) <= d;
q <= q_int(0);

ff: C_REG_FD_V4_0 GENERIC MAP(C_WIDTH => 1,
				C_AINIT_VAL => zero_string,
				C_HAS_CE => 1,
				C_HAS_AINIT => 1)
			PORT MAP (	D => d_int,
				  	CLK => clk,
				  	CE => ce,
				  	ACLR => dummy_in,
				  	ASET => dummy_in,
					AINIT => reset,
					SCLR => dummy_in,
					SSET => dummy_in,
					SINIT => dummy_in,
					Q => q_int);
END behavioral;

----------------- END flip_flop-----------------------------------------------------

-----------------flip_flop_sclr-----------------------------------------------------
---------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
---------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_REG_FD_V4_0_comp.all;
USE XilinxCoreLib.prims_constants_v4_0.all;
USE XilinxCoreLib.vfft32_comps_v3.all;
USE XilinxCoreLib.vfft32_pkg_v3.all;

ENTITY flip_flop_sclr_v3 IS
	PORT (d : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		ce : IN STD_LOGIC;
		reset : IN STD_LOGIC := '0';
		sclr : IN STD_LOGIC := '0';
		q : OUT STD_LOGIC);
END flip_flop_sclr_v3;

ARCHITECTURE behavioral OF flip_flop_sclr_v3 IS

CONSTANT zero_string : STRING (1 TO 1) := "0";
SIGNAL d_int : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL q_int : STD_LOGIC_VECTOR(0 DOWNTO 0);

SIGNAL dummy_in : STD_LOGIC := '0';

BEGIN

dummy_in <= '0';

d_int(0) <= d;
q <= q_int(0);

ff: C_REG_FD_V4_0 GENERIC MAP(C_WIDTH => 1,
				C_AINIT_VAL => zero_string,
				C_HAS_CE => 1,
				C_HAS_AINIT => 1,
				C_HAS_SCLR => 1)
			PORT MAP (	D => d_int,
				  	CLK => clk,
				  	CE => ce,
				  	ACLR => dummy_in,
				  	ASET => dummy_in,
					AINIT => reset,
					SCLR => sclr,
					SSET => dummy_in,
					SINIT => dummy_in,
					Q => q_int);
END behavioral;
-----------------END flip_flop_sclr-----------------------------------------------------

-----------------flip_flop_sclr_sset_v3-----------------------------------------------------

---------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
---------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_REG_FD_V4_0_comp.all;
USE XilinxCoreLib.prims_constants_v4_0.all;
USE XilinxCoreLib.vfft32_comps_v3.all;
USE XilinxCoreLib.vfft32_pkg_v3.all;

ENTITY flip_flop_sclr_sset_v3 IS
	PORT (d : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		ce : IN STD_LOGIC;
		reset : IN STD_LOGIC := '0';
		sclr : IN STD_LOGIC := '0';
		sset : IN STD_LOGIC := '0';
		q : OUT STD_LOGIC);
END flip_flop_sclr_sset_v3;

ARCHITECTURE behavioral OF flip_flop_sclr_sset_v3 IS

CONSTANT zero_string : STRING (1 TO 1) := "0";
SIGNAL d_int : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL q_int : STD_LOGIC_VECTOR(0 DOWNTO 0);

SIGNAL dummy_in : STD_LOGIC := '0';

BEGIN

dummy_in <= '0';

d_int(0) <= d;
q <= q_int(0);

ff: C_REG_FD_V4_0 GENERIC MAP(C_WIDTH => 1,
				C_AINIT_VAL => zero_string,
				C_HAS_CE => 1,
				C_HAS_AINIT => 1,
				C_HAS_SCLR => 1,
				C_HAS_SSET => 1)
			PORT MAP (	D => d_int,
				  	CLK => clk,
				  	CE => ce,
				  	ACLR => dummy_in,
				  	ASET => dummy_in,
					AINIT => reset,
					SCLR => sclr,
					SSET => sset,
					SINIT => dummy_in,
					Q => q_int);
END behavioral;
-----------------END flip_flop_sclr_sset_v3-----------------------------------------------------

-----------------flip_flop_ainit_sclr_v3-----------------------------------------------------

---------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
---------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_REG_FD_V4_0_comp.all;
USE XilinxCoreLib.prims_constants_v4_0.all;
USE XilinxCoreLib.vfft32_comps_v3.all;
USE XilinxCoreLib.vfft32_pkg_v3.all;

ENTITY flip_flop_ainit_sclr_v3 IS
	GENERIC (ainit_val : STRING :="1");
	PORT (d : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		ce : IN STD_LOGIC;
		ainit : IN STD_LOGIC := '0';
		sclr : IN STD_LOGIC := '0';
		q : OUT STD_LOGIC);
END flip_flop_ainit_sclr_v3;

ARCHITECTURE behavioral OF flip_flop_ainit_sclr_v3 IS

--CONSTANT zero_string : STRING (1 TO 1) := "0";
SIGNAL d_int : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL q_int : STD_LOGIC_VECTOR(0 DOWNTO 0);

SIGNAL dummy_in : STD_LOGIC := '0';

BEGIN

dummy_in <= '0';

d_int(0) <= d;
q <= q_int(0);

ff: C_REG_FD_V4_0 GENERIC MAP(C_WIDTH => 1,
				C_AINIT_VAL => ainit_val,
				C_HAS_CE => 1,
				C_HAS_AINIT => 1,
				C_HAS_SCLR => 1)
			PORT MAP (	D => d_int,
				  	CLK => clk,
				  	CE => ce,
				  	ACLR => dummy_in,
				  	ASET => dummy_in,
					AINIT => ainit,
					SCLR => sclr,
					SSET => dummy_in,
					SINIT => dummy_in,
					Q => q_int);
END behavioral;
-----------------END flip_flop_ainit_sclr_v3-----------------------------------------------------

-----------------state_machine_v3-----------------------------------------------------
--------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
--------------------------------------------------------------------------
-- Last modified on 03/06/00
-- Name : state_machine_v3 .vhd
-- Function : n state one-hot state machine.
-- 04/11/00 : Initial rev. of file.
-- Last modified on 04/11/00
---------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
--USE ieee.std_logic_arith.all;
		
LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_REG_FD_V4_0_comp.all;
USE XilinxCoreLib.vfft32_comps_v3.all;
	
ENTITY state_machine_v3 is
	GENERIC (n	: INTEGER);
	PORT (	clk	: IN STD_LOGIC;
		ce	: IN STD_LOGIC;
		start: IN STD_LOGIC;
		reset	: IN STD_LOGIC;
		s	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));  

END state_machine_v3 ;

ARCHITECTURE behavioral OF state_machine_v3 IS

------FUNCTIONS----------------------
FUNCTION eval( condition : BOOLEAN )
	RETURN INTEGER IS
BEGIN
	IF (condition=TRUE) THEN
	  RETURN 1;
	ELSE
	  RETURN 0;
	END IF;
END eval;
--------------------------------------
FUNCTION int_string(value : INTEGER)
	RETURN string IS
BEGIN
	IF (value = 1) THEN
	  RETURN "1";
	ELSE
	  RETURN "0";
	END IF;
END int_string;
---------------------------------------
-- This function creates a string of --
-- length "value" where the MSB is   --
-- set to 1 and other bits = 0.      --
---------------------------------------
FUNCTION init_string (value: INTEGER)
	RETURN string IS
      VARIABLE init : string( 1 to value);
 BEGIN

      FOR i IN 1 TO value LOOP
	IF (i = value) THEN
	  init(i) := '1';
	ELSE
          init(i) := '0';
	END IF;
      END LOOP;

      RETURN init;
     
 END init_string;
---------------------------------------

SIGNAL dummy_in: STD_LOGIC := '0';
--SIGNAL reset_or_start : STD_LOGIC := '0';
--SIGNAL start_and_not_reset : STD_LOGIC := '0';
SIGNAL temp	: STD_LOGIC_VECTOR(n-1 DOWNTO 0);
SIGNAL q	: STD_LOGIC_VECTOR(n-1 DOWNTO 0);

CONSTANT initstring : STRING(1 TO n) :=init_string(n);
CONSTANT ainitstring : STRING(1 TO n) :=(OTHERS => '0');


BEGIN

temp(0) <= q(n-1);
temp_bits : FOR i IN n-1 DOWNTO 1 GENERATE
		temp(i) <= q(i-1); 
END GENERATE temp_bits;



flops_n:	C_REG_FD_V4_0 GENERIC MAP (C_WIDTH => n,
			 C_AINIT_VAL => ainitstring,
			 C_SINIT_VAL => initstring, --"",
			 C_SYNC_PRIORITY => 0,
			 --C_SYNC_ENABLE => , 
			 C_HAS_CE => 1,
			 C_HAS_ACLR => 0,
			 C_HAS_ASET=> 0,
			 C_HAS_AINIT => 1,
			 C_HAS_SCLR => 0,
			 C_HAS_SSET => 0,
			 C_HAS_SINIT =>1, -- 0,
			 C_ENABLE_RLOCS => 1
			 )
		PORT MAP (D =>	temp,
			    CLK =>	clk,
			    CE =>	ce,
			    ACLR =>	dummy_in,
			    ASET => dummy_in,
			    AINIT => reset, --start_and_not_reset, --dummy_in
			    SCLR => dummy_in,
			    SINIT => start, --reset_or_start
			    Q => q );

states : FOR i IN 0 TO n-1 GENERATE
	s(n-1-i) <= q(i); 
END GENERATE states;

dummy_in <= '0';
END behavioral;
-----------------END state_machine_v3-----------------------------------------------------

-----------------or_a_b-----------------------------------------------------

---------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
-- Header added by cde on 12/09/99
-------------------------------------------------------------------------------
-- Last modified on 08/25/99
-- Name : or_a_b.vhd
-- Function : A combinatorial implementation of C_GATE_BIT that generates A + B
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XILINXCORELIB;
USE XILINXCORELIB.c_gate_bit_v4_0_COMP.ALL;

ENTITY or_a_b_32_v3 IS
	GENERIC(c_enable_rlocs	: INTEGER := 1);
	PORT (	a_in	: IN STD_LOGIC;
		b_in   	: IN STD_LOGIC;
		or_out	: OUT STD_LOGIC);
END or_a_b_32_v3;

ARCHITECTURE behavioral OF or_a_b_32_v3 IS
	CONSTANT no	: INTEGER 	:= 0;
	CONSTANT yes	: INTEGER 	:= 1;
	SIGNAL fake_in	: STD_LOGIC	:= '0';
	SIGNAL fake_out	: STD_LOGIC;
	SIGNAL or_in	: STD_LOGIC_VECTOR(1 DOWNTO 0);
	
BEGIN
	or_in(1) <= a_in;
	or_in(0) <= b_in;

or_a_b_32_v3:C_GATE_BIT_V4_0 
   	GENERIC MAP (
   		C_ENABLE_RLOCS  => c_enable_rlocs,
      		C_GATE_TYPE 	=> 2,		--c_or
		C_INPUTS    	=> 2,
		C_INPUT_INV_MASK=> "00", 
		C_AINIT_VAL 	=> "0",
		C_SINIT_VAL 	=> "0",
		C_HAS_O		=> yes,
		C_HAS_Q		=> no,
		C_HAS_CE	=> no,
		C_HAS_ACLR	=> no,
		C_HAS_ASET	=> no,
		C_HAS_AINIT	=> no,
		C_HAS_SCLR	=> no,
		C_HAS_SSET	=> no,
		C_HAS_SINIT	=> no) 
          PORT MAP (
          	I	=> or_in,
		O	=> or_out,
		clk	=> fake_in,
		q	=> fake_out,
		CE	=> fake_in, 	
		AINIT 	=> fake_in, 
		ASET 	=> fake_in, 	
		ACLR 	=> fake_in, 	
		SINIT	=> fake_in,
		SSET	=> fake_in,	
		SCLR 	=> fake_in
		);
END behavioral;
-----------------END or_a_b-----------------------------------------------------
----------------- or_a_b_c-----------------------------------------------------

---------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
-- Header added by cde on 12/09/99
-------------------------------------------------------------------------------
-- Last modified on 08/25/99
-- Name : or_a_b_c.vhd
-- Function : A combinatorial implementation of C_GATE_BIT that generates A+B+C
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XILINXCORELIB;
USE XILINXCORELIB.c_gate_bit_v4_0_COMP.ALL;

ENTITY or_a_b_c_32_v3 IS
	GENERIC(c_enable_rlocs	: INTEGER := 1);
	PORT (	a_in	: IN STD_LOGIC;
		b_in   	: IN STD_LOGIC;
		c_in	: IN STD_LOGIC;
		or_out	: OUT STD_LOGIC);
END or_a_b_c_32_v3;

ARCHITECTURE behavioral OF or_a_b_c_32_v3 IS
	CONSTANT no	: INTEGER 	:= 0;
	CONSTANT yes	: INTEGER 	:= 1;
	SIGNAL fake_in	: STD_LOGIC	:= '0';
	SIGNAL fake_out	: STD_LOGIC;
	SIGNAL or_in	: STD_LOGIC_VECTOR(2 DOWNTO 0);
	
BEGIN
	or_in(2) <= a_in;
	or_in(1) <= b_in;
	or_in(0) <= c_in;

or_a_b_c_32_v3:C_GATE_BIT_V4_0 
   	GENERIC MAP (
   		C_ENABLE_RLOCS  => c_enable_rlocs,
      		C_GATE_TYPE 	=> 2,		--c_or
		C_INPUTS    	=> 3,
		C_INPUT_INV_MASK=> "000", 
		C_AINIT_VAL 	=> "0",
		C_SINIT_VAL 	=> "0",
		C_HAS_O		=> yes,
		C_HAS_Q		=> no,
		C_HAS_CE	=> no,
		C_HAS_ACLR	=> no,
		C_HAS_ASET	=> no,
		C_HAS_AINIT	=> no,
		C_HAS_SCLR	=> no,
		C_HAS_SSET	=> no,
		C_HAS_SINIT	=> no) 
          PORT MAP (
          	I	=> or_in,
		O	=> or_out,
		clk	=> fake_in,
		q	=> fake_out,
		CE	=> fake_in, 	
		AINIT 	=> fake_in, 
		ASET 	=> fake_in, 	
		ACLR 	=> fake_in, 	
		SINIT	=> fake_in,
		SSET	=> fake_in,	
		SCLR 	=> fake_in
		);
END behavioral;
----------------- ENd or_a_b_c-----------------------------------------------------
-----------------  xor_a_b-----------------------------------------------------

-------------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
-------------------------------------------------------------------------------
-- Last modified on 08/25/99
-- Name : xor_a_b.vhd
-- Function : A combinatorial implementation of C_GATE_BIT that generates A xor B
-------------------------------------------------------------------------------
--  Last modified on 10/07/99                                            --
--  By          : cde                                                    --
--              : Added header ($Id)					 --
--		: GENERIC c_enable_rlocs added				 --
-- By 		: veena.
--			: changed to v2 of baseblox
---------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XILINXCORELIB;
USE XILINXCORELIB.C_GATE_BIT_V4_0_COMP.ALL;

ENTITY xor_a_b_32_v3 IS
	GENERIC (c_enable_rlocs	: INTEGER := 0);
	PORT (	a_in	: IN STD_LOGIC;
		b_in   	: IN STD_LOGIC;
		xor_out	: OUT STD_LOGIC);
END xor_a_b_32_v3;

ARCHITECTURE behavioral OF xor_a_b_32_v3 IS
	CONSTANT no	: INTEGER 	:= 0;
	CONSTANT yes	: INTEGER 	:= 1;
	SIGNAL fake_in	: STD_LOGIC	:= '0';
	SIGNAL fake_out	: STD_LOGIC;
	SIGNAL xor_in	: STD_LOGIC_VECTOR(1 DOWNTO 0);
	
BEGIN
	xor_in(1) <= a_in;
	xor_in(0) <= b_in;

xor_a_b_32_v3:C_GATE_BIT_V4_0 
   	GENERIC MAP (
   		C_ENABLE_RLOCS	=> c_enable_rlocs,
      		C_GATE_TYPE 	=> 4,		--c_xor
		C_INPUTS    	=> 2,
		C_INPUT_INV_MASK=> "00", 
		C_AINIT_VAL 	=> "0",
		C_SINIT_VAL 	=> "0",
		C_HAS_O		=> yes,
		C_HAS_Q		=> no,
		C_HAS_CE	=> no,
		C_HAS_ACLR	=> no,
		C_HAS_ASET	=> no,
		C_HAS_AINIT	=> no,
		C_HAS_SCLR	=> no,
		C_HAS_SSET	=> no,
		C_HAS_SINIT	=> no) 
          PORT MAP (
          	I	=> xor_in,
		O	=> xor_out,
		clk	=> fake_in,
		q	=> fake_out,
		CE	=> fake_in, 	
		AINIT 	=> fake_in, 
		ASET 	=> fake_in, 	
		ACLR 	=> fake_in, 	
		SINIT	=> fake_in,
		SSET	=> fake_in,	
		SCLR 	=> fake_in
		);
END behavioral;
-----------------  END xor_a_b-----------------------------------------------------

---------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
-- Header added by cde on 12/09/99
-------------------------------------------------------------------------------
-- Last modified on 08/25/99
-- Name : nand_a_b.vhd
-- Function : implements nand of a and b -------------------------------------------------------------------------------
--  Last modified on 09/23/99                                            -- 
--  By          : cde                                                    --
--              : Added c_enable_rlocs generic		                 --
---------------------------------------------------------------------------


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XILINXCORELIB;
USE XILINXCORELIB.C_GATE_BIT_V4_0_COMP.ALL;

ENTITY nand_a_b_32_v3 IS
	GENERIC (c_enable_rlocs	: INTEGER := 1);
	PORT (	a_in	: IN STD_LOGIC;
		b_in   	: IN STD_LOGIC;
		nand_out	: OUT STD_LOGIC);
END nand_a_b_32_v3;

ARCHITECTURE behavioral OF nand_a_b_32_v3 IS
	CONSTANT no	: INTEGER 	:= 0;
	CONSTANT yes	: INTEGER 	:= 1;
	SIGNAL vcc   	: STD_LOGIC 	:= '1';
	SIGNAL fake_in	: STD_LOGIC	:= '0';
	SIGNAL fake_out	: STD_LOGIC;
	SIGNAL nand_in	: STD_LOGIC_VECTOR(1 DOWNTO 0);

	
BEGIN
	nand_in(0) <= a_in;
	nand_in(1) <= b_in;

nand_a_b_32_v3:C_GATE_BIT_V4_0 
   	GENERIC MAP (
   		C_ENABLE_RLOCS	=> c_enable_rlocs,
      		C_GATE_TYPE 	=> 1,		--c_nand
		C_INPUTS    	=> 2,
		C_INPUT_INV_MASK=> "00", 
		C_SINIT_VAL 	=> "0",
		C_HAS_O		=> yes,
		C_HAS_Q		=> no,
		C_HAS_CE	=> no,
		C_HAS_ACLR	=> no,
		C_HAS_ASET	=> no,
		C_HAS_AINIT	=> no,
		C_HAS_SCLR	=> no,
		C_HAS_SSET	=> no,
		C_HAS_SINIT	=> no) 
          PORT MAP (
          	I	=> nand_in,
		O	=> nand_out,
		clk	=> fake_in,
		q	=> fake_out,
		CE	=> vcc, 	
		AINIT 	=> fake_in, 
		ASET 	=> fake_in, 	
		ACLR 	=> fake_in, 	
		SINIT	=> fake_in,
		SSET	=> fake_in,	
		SCLR 	=> fake_in
		);
END behavioral;
-------------------------------END nand_a_b-----------------------------

-------------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
-------------------------------------------------------------------------------
-- Last modified on 08/25/99
-- Name : and_a_b.vhd
-- Function : A combinatorial implementation of C_GATE_BIT that generates A & B
-------------------------------------------------------------------------------
--  Last modified on 10/07/99                                            --
--  By          : cde                                                    --
--              : Added header ($Id)					 --
--		: GENERIC c_enable_rlocs added				 --
-- By 		: veena.
--			: changed to v2 of baseblox
---------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XILINXCORELIB;
USE XILINXCORELIB.C_GATE_BIT_V4_0_COMP.ALL;

ENTITY and_a_b_32_v3 IS
	GENERIC (c_enable_rlocs	: INTEGER := 0);
	PORT (	a_in	: IN STD_LOGIC;
		b_in   	: IN STD_LOGIC;
		and_out	: OUT STD_LOGIC);
END and_a_b_32_v3;

ARCHITECTURE behavioral OF and_a_b_32_v3 IS
	CONSTANT no	: INTEGER 	:= 0;
	CONSTANT yes	: INTEGER 	:= 1;
	SIGNAL fake_in	: STD_LOGIC	:= '0';
	SIGNAL fake_out	: STD_LOGIC;
	SIGNAL and_in	: STD_LOGIC_VECTOR(1 DOWNTO 0);
	
BEGIN
	and_in(1) <= a_in;
	and_in(0) <= b_in;

and_a_b_32_v3:C_GATE_BIT_V4_0 
   	GENERIC MAP (
   		C_ENABLE_RLOCS	=> c_enable_rlocs,
      		C_GATE_TYPE 	=> 0,		--c_and
		C_INPUTS    	=> 2,
		C_INPUT_INV_MASK=> "00", 
		C_AINIT_VAL 	=> "0",
		C_SINIT_VAL 	=> "0",
		C_HAS_O		=> yes,
		C_HAS_Q		=> no,
		C_HAS_CE	=> no,
		C_HAS_ACLR	=> no,
		C_HAS_ASET	=> no,
		C_HAS_AINIT	=> no,
		C_HAS_SCLR	=> no,
		C_HAS_SSET	=> no,
		C_HAS_SINIT	=> no) 
          PORT MAP (
          	I	=> and_in,
		O	=> and_out,
		clk	=> fake_in,
		q	=> fake_out,
		CE	=> fake_in, 	
		AINIT 	=> fake_in, 
		ASET 	=> fake_in, 	
		ACLR 	=> fake_in, 	
		SINIT	=> fake_in,
		SSET	=> fake_in,	
		SCLR 	=> fake_in
		);
END behavioral;
-------------------------------END and_a_b-----------------------------

---------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
-- Header added by cde on 12/09/99
-------------------------------------------------------------------------------
-- Last modified on 08/25/99
-- Name : and_a_notb.vhd
-- Function : A combinatorial implementation of C_GATE_BIT that generates A & !B
-------------------------------------------------------------------------------
--  Last modified on 09/23/99                                            -- 
--  By          : cde                                                    --
--              : Added c_enable_rlocs generic		                 --
---------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XILINXCORELIB;
USE XILINXCORELIB.C_GATE_BIT_V4_0_COMP.ALL;

ENTITY and_a_notb_32_v3 IS
	GENERIC(c_enable_rlocs	: INTEGER := 1);
	PORT (	a_in		: IN STD_LOGIC;
		b_in   		: IN STD_LOGIC;
		and_out		: OUT STD_LOGIC);
END and_a_notb_32_v3;

ARCHITECTURE behavioral OF and_a_notb_32_v3 IS
	CONSTANT no	: INTEGER 	:= 0;
	CONSTANT yes	: INTEGER 	:= 1;
	SIGNAL fake_in	: STD_LOGIC	:= '0';
	SIGNAL fake_out	: STD_LOGIC;
	SIGNAL and_in	: STD_LOGIC_VECTOR(1 DOWNTO 0);
	
BEGIN

	and_in(1) <= a_in;
	and_in(0) <= b_in;

and_a_notb_32_v3:C_GATE_BIT_V4_0 
   	GENERIC MAP (
      		C_GATE_TYPE 	=> 0,		--c_and
      		C_ENABLE_RLOCS	=> c_enable_rlocs,
		C_INPUTS    	=> 2,
		C_INPUT_INV_MASK=> "01", 
		C_AINIT_VAL 	=> "0",
		C_SINIT_VAL 	=> "0",
		C_HAS_O		=> yes,
		C_HAS_Q		=> no,
		C_HAS_CE	=> no,
		C_HAS_ACLR	=> no,
		C_HAS_ASET	=> no,
		C_HAS_AINIT	=> no,
		C_HAS_SCLR	=> no,
		C_HAS_SSET	=> no,
		C_HAS_SINIT	=> no) 
          PORT MAP (
          	I	=> and_in,
		O	=> and_out,
		clk	=> fake_in,
		q	=> fake_out,
		CE	=> fake_in, 	
		AINIT 	=> fake_in, 
		ASET 	=> fake_in, 	
		ACLR 	=> fake_in, 	
		SINIT	=> fake_in,
		SSET	=> fake_in,	
		SCLR 	=> fake_in
		);
END behavioral;
-------------------------------END and_a_not_b-----------------------------
---------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
---------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.prims_constants_v4_0.all;
USE XilinxCoreLib.vfft32_comps_v3.all;
USE XilinxCoreLib.vfft32_pkg_v3.all;

ENTITY srflop_v3 IS
	PORT (	--d	: IN STD_LOGIC;
		clk	: IN STD_LOGIC;
		ce	:  IN STD_LOGIC;
		set	: IN STD_LOGIC;
		reset	: IN STD_LOGIC;
		q	: OUT STD_LOGIC);
END srflop_v3;

ARCHITECTURE behavioral OF srflop_v3 IS

SIGNAL q_int	: STD_LOGIC;
SIGNAL to_dff	: STD_LOGIC;
SIGNAL to_and	: STD_LOGIC;
SIGNAL dummy_in	: STD_LOGIC := '0';

BEGIN

dummy_in <= '0';

or_set: or_a_b_32_v3 PORT MAP	(a_in =>set,
			b_in => q_int,
			or_out => to_and);
and_reset: and_a_notb_32_v3 PORT MAP	(a_in => to_and,
				b_in => reset,
				and_out => to_dff);
dff	: flip_flop_sclr_v3 PORT MAP (d => to_dff,
				clk => clk,
				ce => ce,
				sclr => dummy_in,
				reset => dummy_in,
				q => q_int);
q <= q_int; 


END behavioral;
----------------------------------END srflop_v3--------------------------------------------
---------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
---------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_SHIFT_RAM_V4_0_comp.all;
USE XilinxCoreLib.prims_constants_v4_0.all;

ENTITY delay_wrapper_v3 IS
	GENERIC (ADDR_WIDTH : INTEGER := 4;
		DEPTH	: INTEGER := 16;
		DATA_WIDTH : INTEGER );
	PORT (addr  : IN STD_LOGIC_VECTOR(ADDR_WIDTH -1 DOWNTO 0);
		data : IN STD_LOGIC_VECTOR(DATA_WIDTH -1 DOWNTO 0);
		clk	: IN STD_LOGIC;
		reset	: IN STD_LOGIC;
		start	: IN STD_LOGIC;
		delayed_data : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0));
END delay_wrapper_v3;

ARCHITECTURE behavioral OF delay_wrapper_v3 IS

CONSTANT ainit_val : STRING := "0000000";
CONSTANT sinit_val : STRING := "0000000";
CONSTANT default_data : STRING(1 TO DATA_WIDTH):=(OTHERS => '0');


BEGIN

delay_element: C_SHIFT_RAM_V4_0 
		GENERIC MAP (C_ADDR_WIDTH => ADDR_WIDTH,
				C_AINIT_VAL => ainit_val,
				C_DEPTH => DEPTH,
				C_DEFAULT_DATA => default_data,
				C_WIDTH => DATA_WIDTH,
				C_HAS_AINIT => 0,
				C_HAS_SINIT =>1,
				C_HAS_ACLR => 1)
		PORT MAP (A => addr,
			D => data,
			CLK => clk,
			--CE => logic_1,
			ACLR => reset, --dummy_in,
			--ASET => dummy_in,
			--AINIT => dummy_in, --reset,
			--SCLR =>dummy_in,
			--SSET => dummy_in,
			SINIT => start,
			Q => delayed_data);
END behavioral;

-------------------------END delay_wrapper_v3-------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
--USE ieee.std_logic_arith.all;
		
LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_MUX_BUS_V4_0_comp.all;
USE XilinxCoreLib.prims_constants_v4_0.all;
USE XilinxCoreLib.C_COUNTER_BINARY_V4_0_comp.all;
USE XilinxCoreLib.C_GATE_BIT_V4_0_comp.all;
USE XilinxCoreLib.vfft32_comps_v3.all;

ENTITY hand_shaking_v3 IS
	GENERIC (memory_architecture : INTEGER);
	PORT (clk : IN STD_LOGIC;
		ce : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		start : IN STD_LOGIC;
		result_avail : IN STD_LOGIC;
		eio_pulse_out : IN STD_LOGIC;
		busy	: OUT STD_LOGIC;
		done	: OUT STD_LOGIC;
		edone	: OUT STD_LOGIC);
END hand_shaking_v3;

ARCHITECTURE behavioral OF hand_shaking_v3 IS

CONSTANT init_value		: STRING(6 DOWNTO 1) := "000000";
SIGNAL done_internal : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL dummy_addr : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL dummy_in : STD_LOGIC;
SIGNAL logic_1	: STD_LOGIC := '1';
SIGNAL result_avail_temp : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL tms_busy_clr: STD_LOGIC ; --for xcc := '0';

SIGNAL zero_96		: STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
SIGNAL one_96		: STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000001";
SIGNAL open_thresh0_96: STD_LOGIC; --for xcc	:= '0';
SIGNAL open_q_thresh0_96: STD_LOGIC; --for xcc	:= '0';
SIGNAL open_thresh1_96: STD_LOGIC; --for xcc	:= '0';
SIGNAL open_q_thresh1_96: STD_LOGIC; --for xcc	:= '0';
SIGNAL count96_tc : STD_LOGIC;
SIGNAL count96 : STD_LOGIC_VECTOR(6 DOWNTO 0) ;
SIGNAL ce_96: STD_LOGIC;

SIGNAL edone_internal: STD_LOGIC;
SIGNAL fake_out	: STD_LOGIC;
SIGNAL edone_decode95	: STD_LOGIC;
SIGNAL edone_temp : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL done_temp : STD_LOGIC_VECTOR(0 DOWNTO 0);

BEGIN

--done <= done_int(0);
edone_internal <= result_avail;
result_avail_temp(0) <= result_avail;

logic_1 <= '1';
tms_busy_clr <= '0';

done_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => 32,
					DATA_WIDTH => 1)
				PORT MAP (addr =>dummy_addr,
					data =>result_avail_temp,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => done_internal);

sms_done_gen : IF (memory_architecture =1) GENERATE
edone <= edone_internal;
done <= done_internal(0);

END GENERATE sms_done_gen;


tms_dms_done_gen: IF (memory_architecture =3) GENERATE 
------------------------------
--Generating count96 signal --
------------------------------

count96_gen : C_COUNTER_BINARY_V4_0 GENERIC MAP(C_WIDTH => 7,
				C_OUT_TYPE => 1, 
			 	C_RESTRICT_COUNT=> 0,
			 	--C_COUNT_TO =>ninety_six,
				--C_COUNT_BY =>count_by_value,
			 	--C_COUNT_MODE => 0,
			 	C_THRESH0_VALUE => "",
			 	C_THRESH1_VALUE =>  "",
			 	C_AINIT_VAL => init_value,
			 	C_SINIT_VAL => init_value,
			 	--C_LOAD_ENABLE 	=> c_no_override,
			 	C_SYNC_ENABLE	=>  c_override,
			 	C_SYNC_PRIORITY	=>   c_clear,
			 	C_PIPE_STAGES	=>  1,
			 	C_HAS_THRESH0	=>  0, 
			 	C_HAS_Q_THRESH0	=>  0,
			 	C_HAS_THRESH1	=>  0,
			 	C_HAS_Q_THRESH1=>  0,
				C_HAS_CE => 1,
			 	C_HAS_UP=>  0,
			 	C_HAS_IV=>  1,
			 	C_HAS_L=>  0, 
			 	C_HAS_LOAD=>  0,
			 	C_LOAD_LOW=>  0,
			 	C_HAS_ACLR=>  0, 
			 	C_HAS_ASET=> 0,
			 	C_HAS_SSET=>  0,
			 	C_HAS_SINIT=>  1,
				C_HAS_SCLR => 1,
				C_HAS_AINIT =>0)
			PORT MAP(CLK => clk,
				UP => dummy_in, 
				CE => ce_96,
				LOAD => dummy_in,
		  		L => zero_96,  
		  		IV  => one_96,  
		  		ACLR  =>dummy_in,
		  		ASET  => dummy_in, 
				SCLR => done_internal(0), 
				AINIT => dummy_in,
				SINIT => count96_tc , 
		  		SSET => dummy_in, 
		 		THRESH0 => open_thresh0_96,  
		  		Q_THRESH0  => open_q_thresh0_96,  
		  		THRESH1 => open_thresh1_96,  
		  		Q_THRESH1 => open_q_thresh1_96,
				Q => count96);

----------------------------------------------
-- clock_enable & terminal count for count96 
----------------------------------------------
ce_96_gen: srflop_v3 PORT MAP(clk => clk,
			ce => ce,
			set => done_internal(0),
			reset => reset,
			q => ce_96);
tc_96_gen: and_a_b_32_v3 PORT MAP(a_in=> count96(5),
			b_in => count96(6),
			and_out => count96_tc);


 

-------------------------------------------------
--generate count95_tc. wide and gate to decode 95
-------------------------------------------------

decode_95: C_GATE_BIT_V4_0 
   	GENERIC MAP (
      		C_GATE_TYPE 	=> 0,		--c_and
      		--C_ENABLE_RLOCS	=> c_enable_rlocs,
		C_INPUTS    	=> 7,
		C_INPUT_INV_MASK=> "0100000", --95
		C_AINIT_VAL 	=> "0",
		C_SINIT_VAL 	=> "0",
		C_HAS_O		=> 1,
		C_HAS_Q		=> 0,
		C_HAS_CE	=> 0,
		C_HAS_ACLR	=> 0,
		C_HAS_ASET	=> 0,
		C_HAS_AINIT	=> 0,
		C_HAS_SCLR	=> 0,
		C_HAS_SSET	=> 0,
		C_HAS_SINIT	=> 0) 
          PORT MAP (
          	I	=> count96,
		O	=> edone_decode95,
		clk	=> dummy_in,
		q	=> fake_out,
		CE	=> dummy_in, 	
		AINIT 	=> dummy_in, 
		ASET 	=> dummy_in, 	
		ACLR 	=> dummy_in, 	
		SINIT	=> dummy_in,
		SSET	=> dummy_in,	
		SCLR 	=> dummy_in
		);


edone_gen: or_a_b_32_v3 PORT MAP (a_in => edone_internal,
			b_in => edone_decode95,
			or_out => edone_temp(0));

edone <= edone_temp(0);

done_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => 32,
					DATA_WIDTH => 1)
				PORT MAP (addr =>dummy_addr,
					data =>edone_temp,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => done_temp);
done <= done_temp(0);

END GENERATE tms_dms_done_gen;

--END GENERATE tms_dms_done_gen;

dms_done_gen: IF (memory_architecture=2) GENERATE

edone <= eio_pulse_out;
edone_temp(0) <= eio_pulse_out;
done_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => 32,
					DATA_WIDTH => 1)
				PORT MAP (addr =>dummy_addr,
					data =>edone_temp,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => done_temp);
done <= done_temp(0);
END GENERATE dms_done_gen;
--END GENERATE tms_dms_done_gen;

--tms_done_gen: IF (memory_architecture=3) GENERATE
--done <= count96_tc or done_internal(0);
--END GENERATE tms_done_gen;

tms_dms_busy_gen: IF (memory_architecture=3) or (memory_architecture=2) GENERATE
busy_gen: flip_flop_sclr_v3 PORT MAP (d => logic_1,
				clk => clk,
				ce => start,
				reset => reset,
				sclr => tms_busy_clr, --done_int(0),
				q => busy);
END GENERATE tms_dms_busy_gen;




END behavioral;

-----------------END hand_shaking_v3----------------------------------------------------

--------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
--------------------------------------------------------------------------



LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_MUX_BIT_V4_0_comp.all;
USE XilinxCoreLib.C_COUNTER_BINARY_V4_0_comp.all;
USE XilinxCoreLib.prims_constants_v4_0.all;
USE XilinxCoreLib.C_MUX_BUS_V4_0_comp.all;
USE XilinxCoreLib.vfft32_comps_v3.all;

ENTITY addr_gen_v3 IS
	GENERIC (points_power : INTEGER :=5;
			memory_architecture: INTEGER :=3);
	PORT (clk	: IN STD_LOGIC;
		ce	: IN STD_LOGIC;
		reset	: IN STD_LOGIC;	
		start	: IN STD_LOGIC;
		io_pulse : IN STD_LOGIC;
		dmsedone : OUT STD_LOGIC;
		delayed_io_pulse_out : OUT STD_LOGIC;
		address	: OUT STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);
		rank_number : OUT STD_LOGIC_VECTOR(2-1 DOWNTO 0));
END addr_gen_v3;

ARCHITECTURE behavioral OF addr_gen_v3 IS

CONSTANT ainit_val	: STRING(1 TO 5) := "00000";
CONSTANT rank_ctr_ainit_val	:STRING(1 TO 2) := "00";
CONSTANT thirty_one	: STRING(1 TO 5) := "11111";
CONSTANT counter_width	: INTEGER := points_power;
CONSTANT rank_counter_width	: INTEGER := 2;
CONSTANT three	: STRING(1 TO 2) := "11";
CONSTANT one_string	: STRING(1 TO 5) := "00001";
CONSTANT one_string_1	: STRING(1 TO 2) := "01";
CONSTANT two : STRING (1 TO 2) := "10";

SIGNAL b: STD_LOGIC_VECTOR(counter_width-1 DOWNTO 0);
SIGNAL rank_count : STD_LOGIC_VECTOR(rank_counter_width-1 DOWNTO 0);

SIGNAL dummy_in		: STD_LOGIC	:= '0';
SIGNAL logic_1		: STD_LOGIC	:= '1';
SIGNAL open_thresh0: STD_LOGIC; --for xcc	:= '0';
SIGNAL open_q_thresh0: STD_LOGIC; --for xcc	:= '0';
SIGNAL open_thresh1: STD_LOGIC; --for xcc	:= '0';
SIGNAL  open_q_thresh1: STD_LOGIC; --for xcc	:= '0';
SIGNAL open_q_thresh0_1: STD_LOGIC; --for xcc	:= '0';
SIGNAL open_thresh1_1: STD_LOGIC; --for xcc	:= '0';
SIGNAL  open_q_thresh1_1: STD_LOGIC; --for xcc	:= '0';
SIGNAL one: STD_LOGIC_VECTOR(counter_width-1 DOWNTO 0) := "00001";
SIGNAL zero: STD_LOGIC_VECTOR(counter_width-1 DOWNTO 0) := "00000";
SIGNAL rank_ctr_one: STD_LOGIC_VECTOR(rank_counter_width-1 DOWNTO 0) := "01";
SIGNAL rank_ctr_zero: STD_LOGIC_VECTOR(rank_counter_width-1 DOWNTO 0) := "00";
SIGNAL rank_counter_enable: STD_LOGIC;
SIGNAL or_rank_number	: STD_LOGIC_VECTOR(0 DOWNTO 0) ;
SIGNAL or_rank_num_temp : STD_LOGIC; --for xcc := '0';
 
SIGNAL open_q: STD_LOGIC; --for xcc	:= '0';
SIGNAL open_q_1: STD_LOGIC;--for xcc	:= '0';
SIGNAL open_q_2: STD_LOGIC;--for xcc	:= '0';

SIGNAL b0b3: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL b3b0b4 : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL b4b0 : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL rank_count_1 : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL r02address : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL rank3_address : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL sel_rank3 : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL sel_rank3_temp : STD_LOGIC;

SIGNAL open_thresh0_2 : STD_LOGIC;--for xcc	:= '0';
SIGNAL open_q_thresh0_2 : STD_LOGIC;--for xcc	:= '0';
SIGNAL open_thresh1_2 : STD_LOGIC;--for xcc	:= '0';
SIGNAL open_q_thresh1_2 : STD_LOGIC;--for xcc	:= '0';

--SIGNAL dummy_mux_inputs	: STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);
--SIGNAL open_q_mux :STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);

SIGNAL rank_counter_enable_or_start : STD_LOGIC	; --for xcc:= '0';
SIGNAL start_or_delayed_io_pulse : STD_LOGIC;
--SIGNAL start_or_delayed_io_pulse: STD_LOGIC;
SIGNAL io_pulse_temp : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL delayed_io_pulse_temp : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL delayed_io_pulse: STD_LOGIC;
SIGNAL dummy_addr :STD_LOGIC_VECTOR(0 DOWNTO 0);

BEGIN
   dmsedone<= rank_count(1) and (b(0)) and (b(1)) and (b(2)) and (b(3)) and (b(4));
zero <= (OTHERS => '0');
rank_ctr_zero <= (OTHERS => '0');

one(0) <= '1';
one(1) <= '0';
one(2) <= '0';
one(3) <= '0';
one(4) <= '0';

rank_ctr_one(0) <= '1';
rank_ctr_one(1) <= '0';

dummy_in <= '0';
logic_1 <= '1';

--b0b3 <= b(0) & b(3);			--mux_inputs
--b3b0b4 <= b(3) & b(0) & b(4);		--mux_inputs
--b4b0 <= b(4) & b(0);			--mux_inputs

--break it up for xcc--
b0b3(1) <= b(0);
b0b3(0) <= b(3);

b3b0b4(2) <= b(3);
b3b0b4(1) <= b(0);
b3b0b4(0) <= b(4);

b4b0(1) <= b(4);
b4b0(0) <= b(0);

sel_rank3(0) <= sel_rank3_temp;

address <= r02address;

tms_sms_gen: IF ((memory_architecture=1) or (memory_architecture=3) ) GENERATE
five_bit_count: C_COUNTER_BINARY_V4_0
		GENERIC MAP (	C_WIDTH		=> counter_width,
				C_OUT_TYPE	=> 1,  --unsigned
				C_COUNT_BY	=> one_string,
				C_THRESH0_VALUE => thirty_one,
				C_AINIT_VAL	=> ainit_val,
				C_LOAD_ENABLE 	=> c_no_override,
				C_SYNC_ENABLE	=>  c_no_override,
				C_HAS_THRESH0	=>  0, --1,
				C_HAS_Q_THRESH0	=>  1,
				C_HAS_CE	=> 1,
				C_HAS_IV	=> 1,
				C_HAS_L		=> 1,
				C_HAS_SCLR	=> 1,
				C_HAS_AINIT 	=> 1)
		PORT MAP (CLK => clk,
			  UP => logic_1,
			  CE => ce,
			  LOAD => dummy_in,
			  L => zero,
			  IV => one,
			  ACLR => dummy_in,
			  ASET => dummy_in,
			  AINIT => reset,
			  SCLR => start,
			  SINIT => dummy_in,
			  SSET => dummy_in,
			  THRESH0 => open_q_thresh0, --rank_counter_enable,
			  Q_THRESH0 => rank_counter_enable, --open_q_thresh0,  
		  	  THRESH1 => open_thresh1,  
		  	  Q_THRESH1 => open_q_thresh1,
			  Q => b);
	
			 				

rank_counter: C_COUNTER_BINARY_V4_0
		GENERIC MAP (	C_WIDTH		=> rank_counter_width,
				C_OUT_TYPE	=> 1, --c_unsigned
				C_COUNT_BY	=> one_string_1,
				C_COUNT_TO	=> two,
				C_RESTRICT_COUNT => 1,
				C_THRESH0_VALUE => two,
				C_AINIT_VAL	=> rank_ctr_ainit_val,
				C_SINIT_VAL	=> rank_ctr_ainit_val,
				C_LOAD_ENABLE 	=> c_no_override,
				C_SYNC_ENABLE	=>  c_no_override, --c_override,
				C_HAS_THRESH0	=>  0,
				C_HAS_Q_THRESH0	=>  0,
				C_HAS_CE	=> 1,
				C_HAS_IV	=> 1,
				C_HAS_SCLR	=> 1,
				C_HAS_ACLR	=> 0,
				C_HAS_SINIT	=> 0,
				C_HAS_AINIT 	=> 1)
		PORT MAP (CLK => clk,
			  UP => logic_1,
			--  CE => rank_counter_enable,
			CE => rank_counter_enable_or_start,
			  LOAD => dummy_in,
			  L => rank_ctr_zero,
			  IV => rank_ctr_one,
			  ACLR => dummy_in,
			  ASET => dummy_in,
			  AINIT => reset,
			  SCLR => start,
			  SINIT => dummy_in, 
			  SSET => dummy_in,
			  THRESH0 => open_thresh0,
			  Q_THRESH0 => open_q_thresh0_1,  --not using it as sinit 
		  	  THRESH1 => open_thresh1_1,  
		  	  Q_THRESH1 => open_q_thresh1_1,
			  Q => rank_count);

--rank_counter_enable_or_start <= rank_counter_enable or start;
rank_ctr_en_gen: or_a_b_32_v3	PORT MAP (a_in => rank_counter_enable,
				 b_in => start,
				or_out => rank_counter_enable_or_start);

END GENERATE tms_sms_gen;								

dms_gen: IF (memory_architecture=2) GENERATE

delayed_io_pulse_out <= delayed_io_pulse;
 
io_pulse_temp(0) <= io_pulse;
delayed_io_pulse <= delayed_io_pulse_temp(0);
delay_io_pulse_gen: delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => 30,
					DATA_WIDTH => 1)
				PORT MAP (addr => dummy_addr,
 					data => io_pulse_temp,
 					clk => clk,
 					reset => reset,
 					start => start,
 					delayed_data => delayed_io_pulse_temp);

start_or_io_pulsegen: or_a_b_32_v3 PORT MAP(a_in => start,
						b_in => delayed_io_pulse,
						or_out => start_or_delayed_io_pulse);

five_bit_count: C_COUNTER_BINARY_V4_0
		GENERIC MAP (	C_WIDTH		=> counter_width,
				C_OUT_TYPE	=> 1,  --unsigned
				C_COUNT_BY	=> one_string,
				C_THRESH0_VALUE => thirty_one,
				C_AINIT_VAL	=> ainit_val,
				C_LOAD_ENABLE 	=> c_no_override,
				C_SYNC_ENABLE	=>  c_override,
				C_HAS_THRESH0	=>  0, --1,
				C_HAS_Q_THRESH0	=>  1,
				C_HAS_CE	=> 1,
				C_HAS_IV	=> 1,
				C_HAS_L		=> 1,
				C_HAS_SCLR	=> 1,
				C_HAS_AINIT 	=> 1)
		PORT MAP (CLK => clk,
			  UP => logic_1,
			  CE => ce,
			  LOAD => dummy_in,
			  L => zero,
			  IV => one,
			  ACLR => dummy_in,
			  ASET => dummy_in,
			  AINIT => reset,
			  SCLR => start_or_delayed_io_pulse,
			  SINIT => dummy_in,
			  SSET => dummy_in,
			  THRESH0 => open_q_thresh0, --rank_counter_enable,
			  Q_THRESH0 => rank_counter_enable, --open_q_thresh0,  
		  	  THRESH1 => open_thresh1,  
		  	  Q_THRESH1 => open_q_thresh1,
			  Q => b);
			 				

rank_counter: C_COUNTER_BINARY_V4_0
		GENERIC MAP (	C_WIDTH		=> rank_counter_width,
				C_OUT_TYPE	=> 1, --c_unsigned
				C_COUNT_BY	=> one_string_1,
				C_COUNT_TO	=> two,
				C_RESTRICT_COUNT => 1,
				C_THRESH0_VALUE => two,
				C_AINIT_VAL	=> rank_ctr_ainit_val,
				C_SINIT_VAL	=> rank_ctr_ainit_val,
				C_LOAD_ENABLE 	=> c_no_override,
				C_SYNC_ENABLE	=>  c_no_override,
				C_HAS_THRESH0	=>  0,
				C_HAS_Q_THRESH0	=>  0,
				C_HAS_CE	=> 1,
				C_HAS_IV	=> 1,
				C_HAS_SCLR	=> 1,
				C_HAS_ACLR	=> 0,
				C_HAS_SINIT	=> 0,
				C_HAS_AINIT 	=> 1)
		PORT MAP (CLK => clk,
			  UP => logic_1,
			--  CE => rank_counter_enable,
			CE => rank_counter_enable_or_start,
			  LOAD => dummy_in,
			  L => rank_ctr_zero,
			  IV => rank_ctr_one,
			  ACLR => dummy_in,
			  ASET => dummy_in,
			  AINIT => reset,
			  SCLR => start_or_delayed_io_pulse,
			  SINIT => dummy_in, 
			  SSET => dummy_in,
			  THRESH0 => open_thresh0,
			  Q_THRESH0 => open_q_thresh0_1,  --not using it as sinit 
		  	  THRESH1 => open_thresh1_1,  
		  	  Q_THRESH1 => open_q_thresh1_1,
			  Q => rank_count);

--testedone<= rank_count(1) and not(b(0)) and not(b(1)) and not(b(2)) and not(b(3)) and not(b(4));


rank_ctr_en_gen: or_a_b_32_v3	PORT MAP (a_in => rank_counter_enable,
				 b_in => start_or_delayed_io_pulse, --start,
				or_out => rank_counter_enable_or_start);
END GENERATE dms_gen;




address2_mux: C_MUX_BIT_V4_0 
		GENERIC MAP (C_INPUTS => 2,
			  	C_SEL_WIDTH =>1,
				C_HAS_O => 1,
				C_HAS_Q => 0)
		PORT MAP (M =>b0b3,
			  S => rank_count_1, --rank_count(1),
	CLK => clk,
	AINIT => dummy_in,
	ASET => dummy_in,
	ACLR => dummy_in,
	SINIT => dummy_in,
	SSET => dummy_in,
	SCLR => dummy_in,
	O => r02address(2),
	Q => open_q);

			
address3_mux: C_MUX_BIT_V4_0 
		GENERIC MAP (C_INPUTS => 3,
			  	C_SEL_WIDTH =>2,
				C_HAS_O => 1,
				C_HAS_Q => 0)
		PORT MAP (M => b3b0b4,
			    S => rank_count,
	CLK => clk,
	AINIT => dummy_in,
	ASET => dummy_in,
	ACLR => dummy_in,
	SINIT => dummy_in,
	SSET => dummy_in,
	SCLR => dummy_in,
	O => r02address(3),
			   Q => open_q_1);

address4_mux: C_MUX_BIT_V4_0 
		GENERIC MAP (C_INPUTS => 2,
			  	C_SEL_WIDTH =>1,
				C_HAS_O => 1,
				C_HAS_Q => 0)
		PORT MAP (M =>b4b0,
			  S => or_rank_number,
	CLK => clk,
	AINIT => dummy_in,
	ASET => dummy_in,
	ACLR => dummy_in,
	SINIT => dummy_in,
	SSET => dummy_in,
	SCLR => dummy_in,
	O => r02address(4),
	Q => open_q_2);

			
r02address(0) <= b(1);
r02address(1) <= b(2);

rank_number <= rank_count;
--xor_rank_number(0) <= rank_count(0) xor rank_count(1);

or_rank_count:	or_a_b_32_v3	PORT MAP(a_in => rank_count(0),
				 b_in => rank_count(1),
				or_out => or_rank_num_temp);
--xor_rank_num_temp <= rank_count(0) or rank_count(1);
rank_count_1(0) <= rank_count(1);



xor_reg : flip_flop_v3 PORT MAP (	d =>or_rank_num_temp,
		     	clk => clk,
			ce => ce,
			reset => reset,
			q => or_rank_number(0));






END behavioral;
		

-----------------END addr_gen_v3-------------------------------------------------------

---------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
---------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

		
LIBRARY XilinxCoreLib;
USE XilinxCoreLib.c_dist_mem_v5_0_comp.all;
USE XilinxCoreLib.prims_constants_v5_0.all;

ENTITY dmem_wkg_r_i_v3 IS
	GENERIC (B : INTEGER;
		POINTS_POWER : INTEGER);
	PORT (	a	: IN STD_LOGIC_VECTOR(POINTS_POWER-1 DOWNTO 0);
		we	: IN STD_LOGIC;
		d_re	: IN STD_lOGIC_VECTOR(B-1 DOWNTO 0);
		d_im	: IN STD_lOGIC_VECTOR(B-1 DOWNTO 0);
		clk	: IN STD_LOGIC;
		dpra	: IN STD_LOGIC_VECTOR(POINTS_POWER-1 DOWNTO 0);
		qdpo_re	: OUT STD_lOGIC_VECTOR(B-1 DOWNTO 0);
		qdpo_im	: OUT STD_lOGIC_VECTOR(B-1 DOWNTO 0));
END dmem_wkg_r_i_v3;


ARCHITECTURE behavioral OF dmem_wkg_r_i_v3 IS

SIGNAL dummy_in		: STD_LOGIC;
SIGNAL dummy_spra	: STD_LOGIC_VECTOR(POINTS_POWER-1 DOWNTO 0);
SIGNAL open_spo_re	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL open_qspo_re	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL open_dpo_re	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL open_spo_im	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL open_qspo_im	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL open_dpo_im	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);


BEGIN


dummy_in <= '0';
dis_mem_re:  C_DIST_MEM_V5_0
	GENERIC MAP (
            C_ADDR_WIDTH     => POINTS_POWER,
           -- C_DEFAULT_DATA   : string  := "0";
	   -- C_DEFAULT_DATA_RADIX : integer := 1;
            C_DEPTH  => 32,
            C_HAS_CLK => 1,
            C_HAS_D=> 1,
            C_HAS_DPO => 0,
            C_HAS_DPRA=> 1,
            C_HAS_I_CE=> 0,
            C_HAS_QDPO => 1, --0,
            C_HAS_QDPO_CE => 0,
            C_HAS_QDPO_CLK => 0,
            C_HAS_QDPO_RST => 0,    -- RSTA
	    C_HAS_QDPO_SRST => 0,
            C_HAS_QSPO  => 0,
            C_HAS_QSPO_CE => 0,
            C_HAS_QSPO_RST => 0,    --RSTB
            C_HAS_QSPO_SRST=> 0,
            C_HAS_RD_EN => 0,
            C_HAS_SPO => 0,
            C_HAS_SPRA => 0,
            C_HAS_WE => 1,
            C_MEM_TYPE => c_dp_ram,
            C_MUX_TYPE =>  c_lut_based,
	    C_LATENCY => 0,
           -- C_PIPE_STAGES => 1,
            C_READ_MIF       => 0,
            C_REG_A_D_INPUTS => 0,
            C_REG_DPRA_INPUT => 0,
C_SYNC_ENABLE => 0,
            C_WIDTH => B)
  PORT MAP (A  => a,
        D => d_re,
        DPRA => dpra,
        SPRA => dummy_spra,
        CLK  => clk,
        WE => we,
        DPO => open_dpo_re,
        SPO  => open_spo_re,
	QSPO => open_qspo_re,
	QDPO => qdpo_re --open_qdpo_re
);

dis_mem_im:  C_DIST_MEM_V5_0
	GENERIC MAP (
            C_ADDR_WIDTH     => POINTS_POWER,
           -- C_DEFAULT_DATA   : string  := "0";
	   -- C_DEFAULT_DATA_RADIX : integer := 1;
            C_DEPTH  => 32,
            C_HAS_CLK => 1,
            C_HAS_D=> 1,
            C_HAS_DPO => 0,
            C_HAS_DPRA=> 1,
            C_HAS_I_CE=> 0,
            C_HAS_QDPO => 1,
            C_HAS_QDPO_CE => 0,
            C_HAS_QDPO_CLK => 0,
            C_HAS_QDPO_RST => 0,    -- RSTA
	    C_HAS_QDPO_SRST => 0,
            C_HAS_QSPO  => 0,
            C_HAS_QSPO_CE => 0,
            C_HAS_QSPO_RST => 0,    --RSTB
            C_HAS_QSPO_SRST=> 0,
            C_HAS_RD_EN => 0,
            C_HAS_SPO => 0,
            C_HAS_SPRA => 0,
            C_HAS_WE => 1,
            C_MEM_TYPE => c_dp_ram,
            C_MUX_TYPE =>  c_lut_based,
	    C_LATENCY => 0,
           -- C_PIPE_STAGES => 1,
            C_READ_MIF       => 0,
            C_REG_A_D_INPUTS => 0,
            C_REG_DPRA_INPUT => 0,
C_SYNC_ENABLE => 0,
            C_WIDTH => B)
  PORT MAP (A  => a,
        D => d_im,
        DPRA => dpra,
        SPRA => dummy_spra,
        CLK  => clk,
        WE => we,
        DPO => open_dpo_im,
        SPO  => open_spo_im,
	QSPO => open_qspo_im,
	QDPO => qdpo_im
);

       --  RD_EN => dummy_in, ---can't use for dpram
 


END behavioral;

----------------------------END dmem_wkg_r_i_v3-----------------------------------------------------
--------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
--------------------------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_COUNTER_BINARY_V4_0_comp.all;
USE XilinxCoreLib.prims_constants_v4_0.all;
USE XilinxCoreLib.C_REG_FD_V4_0_comp.all;
USE XilinxCoreLib.vfft32_comps_v3.all;

ENTITY mem_address_v3 IS
	GENERIC (points_power : INTEGER := 5;
		memory_configuration : INTEGER :=3);
	PORT (clk	: IN STD_LOGIC;
		ce	: IN STD_LOGIC;
		reset	: IN STD_LOGIC;	
		start	: IN STD_LOGIC;
		mwr	: IN STD_LOGIC;
		io_pulse : IN STD_LOGIC;
		io	: IN STD_LOGIC;
		dmsedone : out std_logic;
		address	: OUT STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);
		rank_number : OUT STD_LOGIC_VECTOR(2-1 DOWNTO 0);
		user_ld_addr : OUT STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);
		busy_usr_loading_addr : OUT STD_LOGIC;
		initial_data_load_x : OUT STD_LOGIC );
END mem_address_v3;

ARCHITECTURE behavioral OF mem_address_v3 IS

CONSTANT  init_value		: STRING(1 TO 5) := "00000";
CONSTANT  usr_ld_init_value		: STRING(1 TO 5) := "00000"; --"11111";

CONSTANT  init_value_1		: STRING(1 TO 2) := "00";
CONSTANT  count_by_value		: STRING(1 TO 5) := "00001";
CONSTANT  count_by_value_1		: STRING(1 TO 2) := "01";
CONSTANT  thresh_0_value	: STRING(1 TO 5) := "11111";
CONSTANT thresh_0_value_dms :  STRING(1 TO 5) := "11111";
CONSTANT  two_string		: STRING(1 TO 2) := "10";
CONSTANT  two_string_thresh0		: STRING(1 TO 2) := "10"; --vk aug 24 "11";

--SIGNAL loading_and_not_end	: STD_LOGIC := '0';
--SIGNAL loading_and_not_end_temp	: STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL usr_loading_addr_temp	: STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL usr_loading_addr		: STD_LOGIC; --for xcc := '0';

SIGNAL reset_usr_ldng_addr	: STD_LOGIC;
SIGNAL reset_usr_ldng_addr_0	: STD_LOGIC;

SIGNAL reset_data_ld_x : STD_LOGIC;

SIGNAL mwr_or_io_pulse: STD_LOGIC;

SIGNAL reset_ula : STD_LOGIC;
SIGNAL delayed_io_pulse_out : STD_LOGIC;
--------------------------------------------------
-- Dummy Signals. Connect to unused baseblox ports.
--------------------------------------------------
SIGNAL dummy_in		: STD_LOGIC	:= '0';
SIGNAL open_thresh0: STD_LOGIC; --for xcc	:= '0';
SIGNAL open_q_thresh0: STD_LOGIC; --for xcc	:= '0';
SIGNAL open_thresh1: STD_LOGIC; --for xcc	:= '0';
SIGNAL open_q_thresh1: STD_LOGIC; --for xcc	:= '0';

SIGNAL logic_1		: STD_LOGIC	:= '1';
SIGNAL zero		: STD_LOGIC_VECTOR(4 DOWNTO 0) := "00000";
SIGNAL one		: STD_LOGIC_VECTOR(4 DOWNTO 0) := "00001";
SIGNAL zero_1		: STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
SIGNAL one_1		: STD_LOGIC_VECTOR(1 DOWNTO 0) := "01";

SIGNAL open_q_thresh0_1: STD_LOGIC; --for xcc	:= '0';
SIGNAL open_thresh1_1: STD_LOGIC; --for xcc	:= '0';
SIGNAL open_q_thresh1_1: STD_LOGIC; --for xcc	:= '0';

SIGNAL unused_count	: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL ce_every_three : STD_LOGIC; --for xcc	:= '0';

SIGNAL start_or_mwr : STD_LOGIC;
SIGNAL usr_loading_addr_0 : STD_LOGIC;
SIGNAL reset_sig : STD_LOGIC;
BEGIN

zero <= (OTHERS => '0');
zero_1 <= (OTHERS => '0');
one(0) <= '1';
one(4) <= '0';
one(3) <= '0';
one(2) <= '0';
one(1) <= '0';

one_1(0) <= '1';
one_1(1) <= '0';

busy_usr_loading_addr <= usr_loading_addr;
logic_1 <= '1';

rd_wr_adgen : addr_gen_v3 GENERIC MAP (points_power => 5,
						memory_architecture =>memory_configuration )
			PORT MAP (clk => clk,
				ce => ce,
				reset => reset,
				start => start,
				io_pulse =>io_pulse,
				dmsedone => dmsedone,
				delayed_io_pulse_out => delayed_io_pulse_out,
				address => address,
				rank_number => rank_number);

---------TMS usr ld addrgen --------------------------------------------------------

start_or_mwr_gen : or_a_b_32_v3 PORT MAP(a_in => start,
				 b_in => mwr,
				or_out => start_or_mwr);

tms_usr_ld_addrgen: IF (memory_configuration = 3) GENERATE 
trms_user_ld_addrgen : c_counter_binary_v4_0
			GENERIC MAP(C_WIDTH => 5,
				C_OUT_TYPE => 1, --unsigned ??
			 	--C_RESTRICT_COUNT=> 0,
			 	--C_COUNT_TO =>init_value,
				--C_COUNT_BY =>count_by_value,
			 	--C_COUNT_MODE => 0,
			 	C_THRESH0_VALUE => thresh_0_value, --"",
			 	C_THRESH1_VALUE =>  "",
			 	C_AINIT_VAL => usr_ld_init_value,
			 	C_SINIT_VAL => init_value,
			 	--C_LOAD_ENABLE 	=> c_no_override,
			 	C_SYNC_ENABLE	=>  c_override,
			 	C_SYNC_PRIORITY	=>   c_clear,
			 	C_PIPE_STAGES	=>  1,
			 	C_HAS_THRESH0	=>  0, --1,
			 	C_HAS_Q_THRESH0	=>  1, --0,
			 	C_HAS_THRESH1	=>  0,
			 	C_HAS_Q_THRESH1=>  0,
				C_HAS_CE => 1,
			 	C_HAS_UP=>  0,
			 	C_HAS_IV=>  1,
			 	C_HAS_L=>  0, --1,
			 	C_HAS_LOAD=>  0, --1,
			 	C_LOAD_LOW=>  0,
			 	C_HAS_ACLR=>  0, --1,
			 	C_HAS_ASET=> 0,
			 	C_HAS_SSET=>  0,
			 	C_HAS_SINIT=>  0,
				C_HAS_SCLR => 1,
				C_HAS_AINIT =>0)
			PORT MAP(CLK => clk,
				UP => dummy_in, --vk aug 24 logic_1,
				CE => ce_every_three,
				LOAD => dummy_in,
		  		L => zero,  -- Optional Synch load value
		  		IV  => one,  -- Optional Increment value
		  		ACLR  =>dummy_in, --reset, --vk aug 25 dummy_in,
		  		ASET  => dummy_in, -- optional asynch set to '1'
				SCLR => start_or_mwr, 
				AINIT => dummy_in,
				SINIT => dummy_in , --vk aug 25 mwr, --vk aug 24 start,
		  		SSET => dummy_in, -- optional synch set to '1'
		 		THRESH0 => open_thresh0,  
		  		Q_THRESH0  => open_q_thresh0,  
		  		THRESH1 => open_thresh1,  
		  		Q_THRESH1 => open_q_thresh1,
				Q => user_ld_addr);



ce_every_threegen : c_counter_binary_v4_0
			GENERIC MAP(C_WIDTH => 2,
				C_OUT_TYPE => 1, --unsigned ??
			 	C_RESTRICT_COUNT=> 1,
			 	C_COUNT_TO =>two_string,
				C_COUNT_BY =>count_by_value_1,
			 	C_COUNT_MODE => 0,
			 	C_THRESH0_VALUE => two_string_thresh0,
			 	C_THRESH1_VALUE =>  "",
			 	C_AINIT_VAL => init_value_1,
			 	C_SINIT_VAL => init_value_1,
			 	C_LOAD_ENABLE 	=> c_no_override,
			 	C_SYNC_ENABLE	=>  c_override,
			 	C_SYNC_PRIORITY	=>  c_clear,
			 	C_PIPE_STAGES	=>  1,
			 	C_HAS_THRESH0	=>  1,
			 	C_HAS_Q_THRESH0	=>  1, --0,
			 	C_HAS_THRESH1	=>  0,
			 	C_HAS_Q_THRESH1=>  0,
				C_HAS_CE => 1,
			 	C_HAS_UP=>  0,
			 	C_HAS_IV=>  1,
			 	C_HAS_L=>  1,
			 	C_HAS_LOAD=>  1,
			 	C_LOAD_LOW=>  0,
			 	C_HAS_ACLR=>  0,
			 	C_HAS_ASET=> 0,
			 	C_HAS_SSET=>  0,
			 	C_HAS_SINIT=>  0,
				C_HAS_SCLR => 1,
				C_HAS_AINIT =>1)
			PORT MAP(CLK => clk,
				UP => logic_1,
				CE => ce,
				LOAD => dummy_in,
		  		L => zero_1,  -- Optional Synch load value
		  		IV  => one_1,  -- Optional Increment value
		  		ACLR  => dummy_in,
		  		ASET  => dummy_in, -- optional asynch set to '1'
				SCLR => start_or_mwr , --vk aug 24  mwr,
				AINIT => reset,
				SINIT => dummy_in,
		  		SSET => dummy_in, -- optional synch set to '1'
		 		THRESH0 =>open_q_thresh0_1, -- ce_every_three,  
		  		Q_THRESH0  => ce_every_three, --vk aug 24open_q_thresh0_1,  
		  		THRESH1 => open_thresh1_1,  
		  		Q_THRESH1 => open_q_thresh1_1,
				Q => unused_count);

reg_q_thresh0 : flip_flop_v3 PORT MAP (d => open_q_thresh0,
					clk => clk,
					ce => ce,
					reset => reset, 
					q => reset_usr_ldng_addr_0);
reg_q_thresh0_again : flip_flop_v3 PORT MAP (d => reset_usr_ldng_addr_0,
					clk => clk,
					ce => ce,
					reset => reset, 
					q => reset_data_ld_x);					
inital_data_ld_x_gen: srflop_v3 PORT MAP (clk => clk,
					ce => ce,
					set => mwr,
					reset => reset_data_ld_x, 
					q => initial_data_load_x);


usr_loading_addr_gen: srflop_v3 PORT MAP (clk => clk,
					ce => ce,
					set => mwr,
					reset => reset, --reset_usr_ldng_addr, 
					q => usr_loading_addr);

END GENERATE tms_usr_ld_addrgen;
--------------------------------------------------------------------------------------------------

--------------DMS usr load addregen ---------------------------------------------------


dms_usr_ld_addrgen: IF (memory_configuration = 2) GENERATE 
user_ld_addrgen : c_counter_binary_v4_0
			GENERIC MAP(C_WIDTH => 5,
				C_OUT_TYPE => 1, 
			 	C_RESTRICT_COUNT=> 0,
			 	C_COUNT_TO =>init_value,
				C_COUNT_BY =>count_by_value,
			 	C_COUNT_MODE => 0,
			 	C_THRESH0_VALUE => thresh_0_value_dms, --"",
			 	C_THRESH1_VALUE =>  "",
			 	C_AINIT_VAL => init_value,
			 	C_SINIT_VAL => init_value,
			 	C_LOAD_ENABLE 	=> c_no_override,
			 	C_SYNC_ENABLE	=>  c_override, --was no override vk aug21
			 	C_SYNC_PRIORITY	=>  c_clear,
			 	C_PIPE_STAGES	=>  1,
			 	C_HAS_THRESH0	=>  1,
			 	C_HAS_Q_THRESH0	=>  1, --0,
			 	C_HAS_THRESH1	=>  0,
			 	C_HAS_Q_THRESH1=>  0,
				C_HAS_CE => 1,
			 	C_HAS_UP=>  0,
			 	C_HAS_IV=>  0,
			 	C_HAS_L=>  1,
			 	C_HAS_LOAD=>  1,
			 	C_LOAD_LOW=>  0,
			 	C_HAS_ACLR=>  0,
			 	C_HAS_ASET=> 0,
			 	C_HAS_SSET=>  0,
			 	C_HAS_SINIT=>  0,
				C_HAS_SCLR =>1, 
				C_HAS_AINIT =>1)
			PORT MAP(CLK => clk,
				UP => logic_1,
				CE => ce,
				LOAD => dummy_in,
		  		L => zero,  -- Optional Synch load value
		  		IV  => one,  -- Optional Increment value
		  		ACLR  => dummy_in,
		  		ASET  => dummy_in, -- optional asynch set to '1'
				SCLR => mwr_or_io_pulse, 
				AINIT => reset,
				SINIT => dummy_in, --mwr or io_pulse, 
		  		SSET => dummy_in, -- optional synch set to '1'
		 		THRESH0 => open_thresh0,  
		  		Q_THRESH0  => open_q_thresh0,  
		  		THRESH1 => open_thresh1,  
		  		Q_THRESH1 => open_q_thresh1,
				Q => user_ld_addr);


mwr_or_io_pulse_gen: or_a_b_32_v3 PORT MAP(a_in => mwr,
					b_in => io_pulse,
					or_out => mwr_or_io_pulse);
reset_ula <= delayed_io_pulse_out or open_q_thresh0;


usr_loading_addr_gen: srflop_v3 PORT MAP (clk => clk,
					ce => ce,
					set => mwr_or_io_pulse,
					reset =>open_q_thresh0, --reset_ula, -- open_q_thresh0, 
					q => usr_loading_addr_0);
usr_loading_addr <= usr_loading_addr_0 OR io;

END GENERATE dms_usr_ld_addrgen;
-----------------------------------------------------------------------------------------
--------------SMS usr load addregen ---------------------------------------------------

sms_usr_ld_addrgen: IF (memory_configuration = 1) GENERATE 
user_ld_addrgen : c_counter_binary_v4_0
			GENERIC MAP(C_WIDTH => 5,
				C_OUT_TYPE => 1, 
			 	C_RESTRICT_COUNT=> 0,
			 	C_COUNT_TO =>init_value,
				C_COUNT_BY =>count_by_value,
			 	C_COUNT_MODE => 0,
			 	C_THRESH0_VALUE => thresh_0_value, --"",
			 	C_THRESH1_VALUE =>  "",
			 	C_AINIT_VAL => init_value,
			 	C_SINIT_VAL => init_value,
			 	C_LOAD_ENABLE 	=> c_no_override,
			 	C_SYNC_ENABLE	=>  c_override, --was no override vk aug21
			 	C_SYNC_PRIORITY	=>  c_clear,
			 	C_PIPE_STAGES	=>  1,
			 	C_HAS_THRESH0	=>  1,
			 	C_HAS_Q_THRESH0	=>  1, --0,
			 	C_HAS_THRESH1	=>  0,
			 	C_HAS_Q_THRESH1=>  0,
				C_HAS_CE => 1,
			 	C_HAS_UP=>  0,
			 	C_HAS_IV=>  0,
			 	C_HAS_L=>  1,
			 	C_HAS_LOAD=>  1,
			 	C_LOAD_LOW=>  0,
			 	C_HAS_ACLR=>  0,
			 	C_HAS_ASET=> 0,
			 	C_HAS_SSET=>  0,
			 	C_HAS_SINIT=>  1,
				C_HAS_SCLR =>0, --vk aug 21 1,
				C_HAS_AINIT =>1)
			PORT MAP(CLK => clk,
				UP => logic_1,
				CE => ce,
				LOAD => dummy_in,
		  		L => zero,  -- Optional Synch load value
		  		IV  => one,  -- Optional Increment value
		  		ACLR  => dummy_in,
		  		ASET  => dummy_in, -- optional asynch set to '1'
				SCLR => dummy_in , --mwr, vk aug21
				AINIT => reset,
				SINIT => mwr, --start,  vk aug21
		  		SSET => dummy_in, -- optional synch set to '1'
		 		THRESH0 => open_thresh0,  
		  		Q_THRESH0  => open_q_thresh0,  
		  		THRESH1 => open_thresh1,  
		  		Q_THRESH1 => open_q_thresh1,
				Q => user_ld_addr);



usr_loading_addr_gen: srflop_v3 PORT MAP (clk => clk,
					ce => ce,
					set => mwr,
					reset => reset_sig, --open_q_thresh0, 
					q => usr_loading_addr);

reset_sig <= open_q_thresh0 and not mwr;

END GENERATE sms_usr_ld_addrgen;


END behavioral;

-------------------------END mem_address ----------------------------------------------

--------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
--------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_COUNTER_BINARY_V4_0_comp.all;
USE XilinxCoreLib.C_MUX_BUS_V4_0_comp.all;
USE XilinxCoreLib.C_COMPARE_V4_0_comp.all;
USE XilinxCoreLib.C_GATE_BIT_V4_0_comp.all;
USE XilinxCoreLib.prims_constants_v4_0.all;
USE XilinxCoreLib.vfft32_comps_v3.all;
USE XilinxCoreLib.vfft32_pkg_v3.all;

ENTITY mem_ctrl_v3 IS
	GENERIC ( points_power : INTEGER := 5;
		W_WIDTH		: INTEGER :=16;
		B 		: INTEGER := 16;
		memory_configuration	: INTEGER :=3;
		data_memory	: STRING :="distributed_memory");
	PORT (	clk 	: IN STD_LOGIC;
		ce	: IN STD_LOGIC;
		start 	: IN STD_LOGIC;
		reset	: IN STD_LOGIC;
		mwr	: IN STD_LOGIC;
		mrd	: IN STD_LOGIC;
		usr_loading_addr : IN STD_LOGIC;
		address : IN STD_LOGIC_VECTOR(points_power -1 DOWNTO 0);
		usr_load_addr	: IN STD_LOGIC_VECTOR(points_power -1 DOWNTO 0);
		initial_data_load_x : IN STD_LOGIC;
		rank_number	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		bfly_res_avail	: IN STD_LOGIC;
		e_bfly_res_avail : IN STD_LOGIC; --one clock before bfly_res_avail
		e_done_int	: IN STD_LOGIC;
		done_int	: IN STD_LOGIC;
		result_avail	: IN STD_LOGIC; --pulse
		xbar_y		: OUT STD_LOGIC;
		ext_to_xbar_y_temp_out		: OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
		io			: OUT STD_LOGIC;
		eio			: OUT STD_LOGIC;
		io_pulse		: OUT STD_LOGIC;
		eio_pulse_out		: OUT STD_LOGIC;
		reset_io_out		: OUT STD_LOGIC;
		we_dmem : OUT STD_LOGIC;
		we_dmem_dms:  OUT STD_LOGIC;
		wex_dmem_tms : OUT STD_LOGIC;
		wey_dmem_tms : OUT STD_LOGIC;
		d_a_dmem_dms_sel: OUT STD_LOGIC;
		wea_x : OUT STD_LOGIC;
		wea_y : OUT STD_LOGIC;
		web_x : OUT STD_LOGIC;
		web_y : OUT STD_LOGIC;
		ena_x : OUT STD_LOGIC;
		ena_y : OUT STD_LOGIC;
		data_sel	: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		address_select : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); 
		address_select_dms_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0); 
		reading_result : OUT STD_LOGIC;
		writing_result : OUT STD_LOGIC;
		wr_addr : OUT STD_LOGIC_VECTOR(points_power -1 DOWNTO 0);
		addra_dmem	: OUT STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		addra_x_dmem	: OUT STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		addra_y_dmem	: OUT STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		addrb_dmem	: OUT STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		addrb_dmem_dms : OUT STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		addrb_dmem_tms : OUT STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		rd_addrb_x : OUT STD_LOGIC_VECTOR(points_power -1 DOWNTO 0); 
		rd_addrb_y : OUT STD_LOGIC_VECTOR(points_power -1 DOWNTO 0));
END mem_ctrl_v3;

ARCHITECTURE behavioral OF mem_ctrl_v3 IS 



CONSTANT ainit_val		: STRING (1 TO 1) := "1";

CONSTANT delay_by_value	: INTEGER := bfly32_latency(W_WIDTH, B) +9 -3; --+6;
CONSTANT butterfly_latency : INTEGER := bfly_latency(W_WIDTH, B); --in terms of bfly_clocks
CONSTANT start_to_bfly_input_latency : INTEGER := 3; --master clocks
CONSTANT bfly_res_avail_latency: INTEGER := 16; --start_to_bfly_input_latency + 2*butterfly_latency; --relative to start, in terms of master clocks 


CONSTANT init_value		: STRING(6 DOWNTO 1) := "000000";
CONSTANT count_by_value		: STRING(1 TO 6) := "000001";
CONSTANT string_31		: STRING := "11111";
CONSTANT ainit_val_bank		: STRING (1 TO 1) := "0";

CONSTANT ninety_six : STRING(7 DOWNTO 1) := "1100000";
------------------
--sms constants--
CONSTANT one_string_1 : STRING (points_power DOWNTO 1) := "00001";
CONSTANT ainit_val_1 : STRING (points_power DOWNTO 1) := "00000";
CONSTANT sinit_val_1 : STRING (points_power DOWNTO 1) := "00000";
CONSTANT thirty_one_1 : STRING (points_power DOWNTO 1) := "11111";
-----------------
CONSTANT string_29		: STRING(points_power DOWNTO 1)  := "11101";
CONSTANT string_28		: STRING(points_power DOWNTO 1)  := "11100";


SIGNAL final_rank	: STD_LOGIC; --for xcc vk aug 23 := '0';
SIGNAL bank		: STD_LOGIC; --for xcc vk aug 23 := '0';  --bank=0 is memory X and bank=1 is memory Y.
SIGNAL switch_banks		: STD_LOGIC ; 
SIGNAL switch_bank_temp	: STD_LOGIC; 
SIGNAL not_bank		: STD_LOGIC; 

SIGNAL dummy_in		: STD_LOGIC	:= '0';
SIGNAL open_q_0_tms	: STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);
SIGNAL open_q_0_dms	: STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);
SIGNAL open_q_0_sms	: STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);
SIGNAL open_q_1_tms	: STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);
SIGNAL aeqb	: STD_LOGIC;
SIGNAL aneb	: STD_LOGIC;
SIGNAL altb	: STD_LOGIC;
SIGNAL agtb	: STD_LOGIC;
SIGNAL aleb	: STD_LOGIC;
SIGNAL ageb	: STD_LOGIC;
SIGNAL qaeqb	: STD_LOGIC;
SIGNAL qaneb	: STD_LOGIC;
SIGNAL qaltb	: STD_LOGIC;
SIGNAL qagtb	: STD_LOGIC;
SIGNAL qaleb	: STD_LOGIC;
SIGNAL qageb	: STD_LOGIC;


SIGNAL dummy_mux_inputs	: STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);

SIGNAL xbar_y_temp	: STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL delay_addr_value : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL bfly_res_avail_flag : STD_LOGIC; --for xcc := '0';
SIGNAL e_bfly_res_avail_flag : STD_LOGIC:= '0';

SIGNAL int_ena_x	:STD_LOGIC; --for xcc := '0';
SIGNAL int_ena_y	:STD_LOGIC; --for xcc := '0';
SIGNAL int_web_x	:STD_LOGIC_VECTOR(0 DOWNTO 0) ;
SIGNAL int_web_y	:STD_LOGIC_VECTOR(0 DOWNTO 0) ;

SIGNAL last_bfly_in_rank :STD_LOGIC; --for xcc := '0';
SIGNAL ext_to_xbar_y: STD_LOGIC; --for xcc := '0';
SIGNAL not_ext_to_xbar_y: STD_LOGIC ;
SIGNAL ext_to_xbar_y_temp: STD_LOGIC_VECTOR(0 DOWNTO 0);

SIGNAL open_thresh0: STD_LOGIC; --for xcc	:= '0';
SIGNAL open_q_thresh0: STD_LOGIC; --for xcc	:= '0';
SIGNAL open_thresh1: STD_LOGIC; --for xcc	:= '0';
SIGNAL open_q_thresh1: STD_LOGIC; --for xcc	:= '0';

SIGNAL logic_1		: STD_LOGIC	:= '1';
SIGNAL zero		: STD_LOGIC_VECTOR(5 DOWNTO 0) := "000000";
SIGNAL one		: STD_LOGIC_VECTOR(5 DOWNTO 0) := "000001";
SIGNAL thirty_one	: STD_LOGIC_VECTOR(4 DOWNTO 0) := "11111";

SIGNAL dummy_addr: STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL temp_int_ena_x :STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL temp_int_ena_y :STD_LOGIC_VECTOR(0 DOWNTO 0);


SIGNAL zero_96		: STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
SIGNAL one_96		: STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000001";
SIGNAL open_thresh0_96: STD_LOGIC; --for xcc	:= '0';
SIGNAL open_q_thresh0_96: STD_LOGIC; --for xcc	:= '0';
SIGNAL open_thresh1_96: STD_LOGIC; --for xcc	:= '0';
SIGNAL open_q_thresh1_96: STD_LOGIC; --for xcc	:= '0';
SIGNAL count96_tc : STD_LOGIC;
SIGNAL mwr_or_start_or_count96_tc : STD_LOGIC;
SIGNAL count96 : STD_LOGIC_VECTOR(6 DOWNTO 0) ;
SIGNAL ce_96: STD_LOGIC;
SIGNAL delayed_ext_to_xbar_y_temp : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL delayed_usr_load_addr: STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);
SIGNAL address_select_int : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL count95_tc : STD_LOGIC ;
SIGNAL fake_out	: STD_LOGIC;


------sms signals ---------------------------------------------------------------

SIGNAL reading_result_flag	: STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL reading_result_temp	: STD_LOGIC;
SIGNAL writing_result_internal	: STD_LOGIC:='0';
SIGNAL writing_result_int	: STD_LOGIC_VECTOR(0 DOWNTO 0) :=(OTHERS => '0');
SIGNAL writing_result_int_temp	: STD_LOGIC_VECTOR(0 DOWNTO 0):=(OTHERS => '0');

SIGNAL usr_loading_addr_temp	:STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL result_wr_addr		: STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);
SIGNAL bfly_or_result_wr_rd_addr	: STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);
SIGNAL bfly_rd_or_user_ld_addr	: STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);
SIGNAL open_q_0_1		: STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);
SIGNAL one_1: STD_LOGIC_VECTOR(points_power-1 DOWNTO 0) := "00001";
SIGNAL zero_1: STD_LOGIC_VECTOR(points_power-1 DOWNTO 0) := "00000";
SIGNAL open_thresh0_2 : STD_LOGIC; --for xcc	:= '0';
SIGNAL open_q_thresh0_2 : STD_LOGIC; --for xcc	:= '0';
SIGNAL open_thresh1_2 : STD_LOGIC; --for xcc	:= '0';
SIGNAL open_q_thresh1_2 : STD_LOGIC; --for xcc	:= '0';
SIGNAL open_thresh0_3 : STD_LOGIC; --for xcc	:= '0';
SIGNAL open_thresh1_3 : STD_LOGIC; --for xcc	:= '0';
SIGNAL open_q_thresh1_3 : STD_LOGIC; --for xcc	:= '0'; 
SIGNAL disable_read_enable : STD_LOGIC;
SIGNAL open_mux_ad	: STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);

SIGNAL bfly_or_rd_wr_result_sel	: STD_LOGIC_VECTOR(1 DOWNTO 0); 
SIGNAL result_wr_addr_scrambled : STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);
SIGNAL result_wr_addr_scrambled_delayed : STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);
SIGNAL result_read_addr : STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);

SIGNAL e_done_int_z : STD_LOGIC:= '0';
SIGNAL done_int_z : STD_LOGIC:= '0';
SIGNAL e_writing_result_int : STD_LOGIC:= '0';
SIGNAL web_x_temp : STD_LOGIC:= '0';

SIGNAL e_done_int_z_temp : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL done_int_z_temp : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL e_done_int_z_32 : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL done_int_z_32 : STD_LOGIC_VECTOR(0 DOWNTO 0);

SIGNAL e_bfly_res_avail_temp : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL reset_wea_x : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL reset_wea_x_int : STD_LOGIC;
SIGNAL web_x_pre_reg : STD_LOGIC;
SIGNAL data_addr_sel : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL addr_sel : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL wr_addr_int : STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);
SIGNAL open_addrb_sms : STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);
SIGNAL wea_x_int	: STD_LOGIC;
SIGNAL we_dmem_int	: STD_LOGIC;

SIGNAL write_to_x : STD_LOGIC;
SIGNAL write_to_y : STD_LOGIC;
SIGNAL sclr_sig_0 : STD_LOGIC;

SIGNAL clr_sig : sTD_LOGIC;

-------------------------------------------------------------------------------

SIGNAL e_last_bfly_in_rank : STD_LOGIC;
--SIGNAL twenty_nine : STD_LOGIC_VECTOR(4 DOWNTO 0) := "11101";
SIGNAL twenty_eight : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');--"11100"; vk for xcc

SIGNAL e_last_bfly_in_rank_temp : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL io_temp	: STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL eio_pulse : STD_LOGIC;
SIGNAL eio_temp : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL reset_eio : STD_LOGIC;
SIGNAL reset_io : STD_LOGIC;
SIGNAL eio_reset_temp : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL io_reset_temp : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL temp_eio_int : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL eio_int : STD_LOGIC;
SIGNAL io_pulse_temp :STD_LOGIC_VECTOR(0 DOWNTO 0); 
SIGNAL address_select_dms: STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL address_select_dms_temp : STD_LOGIC;
SIGNAL delayed_address : STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);
SIGNAL e_bfly_res_avail_flag_dms : STD_LOGIC;
SIGNAL reset_io_16_temp : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL reset_io_16 : STD_LOGIC;
SIGNAL hold_off_we_16 : sTD_LOGIC;
SIGNAL test_sig: std_logic:='0';
-------------------------------------------------------------------------------

BEGIN

logic_1 <= '1';
dummy_in <= '0';
--twenty_nine <="11101";
twenty_eight <= (OTHERS => '0');--"11100"; vk for xcc
dummy_mux_inputs <= (OTHERS => '0');
wr_addr <= wr_addr_int;

delay_addr_value <= get_delay_addr(W_WIDTH);

delay_address : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>4,
					DEPTH => bfly_res_avail_latency, --delay_by_value, -- -1 ,
					DATA_WIDTH => 5)
				PORT MAP (addr => delay_addr_value,
					data => address,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => wr_addr_int);


--vk aug18
bfly_res_avail_flag_gen: srflop_v3 PORT MAP (clk => clk,
				ce => ce,
				set => bfly_res_avail,
				reset => start,
				q => bfly_res_avail_flag);
--vk aug18
e_bfly_res_avail_flag_gen: srflop_v3 PORT MAP (clk => clk,
				ce => ce,
				set => e_bfly_res_avail,
				reset => start,
				q => e_bfly_res_avail_flag);

delay_usr_ld_addr : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>4,
					DEPTH => bfly_res_avail_latency, --delay_by_value, -- -1 ,
					DATA_WIDTH => 5)
				PORT MAP (addr => delay_addr_value,
					data => usr_load_addr,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => delayed_usr_load_addr);

delayed_ext_to_xbar_y_temp_gen: delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>4,
					DEPTH => bfly_res_avail_latency, --delay_by_value, -- -1 ,
					DATA_WIDTH => 1)
				PORT MAP (addr => delay_addr_value,
					data => ext_to_xbar_y_temp,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => delayed_ext_to_xbar_y_temp);

-----------------------------------------------------------------------------
---------------------Tripple Memory Space Config Memory Control ------------- 
-----------------------------------------------------------------------------
tms_mem_ctrl_gen: IF (memory_configuration=3) GENERATE 
ena_x <= int_ena_x;
ena_y <= int_ena_y;

temp_int_ena_x(0) <= int_ena_x;

web_x <= int_web_x(0);
web_y <= int_web_y(0);

thirty_one <= (OTHERS => '1');
ext_to_xbar_y_temp(0) <= ext_to_xbar_y;
ext_to_xbar_y_temp_out <= ext_to_xbar_y_temp;

mem_or_ext_x: c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH => points_power,
					C_INPUTS => 2,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP (MA	=>address,
				MB 	=> usr_load_addr,
				MC 	=> dummy_mux_inputs,
				MD 	=> dummy_mux_inputs,
				ME 	=> dummy_mux_inputs,
				MF	=> dummy_mux_inputs,
				MG 	=> dummy_mux_inputs,
				MH 	=> dummy_mux_inputs,
				S 	=> int_web_x,
		  		CLK 	=> dummy_in, 
				O	=> rd_addrb_x,
				Q 	=> open_q_0_tms);

mem_or_ext_y: c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH => points_power,
					C_INPUTS => 2,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP ( MA	=> address, --usr_load_addr,
				MB 	=> usr_load_addr, --address,
				MC 	=> dummy_mux_inputs,
				MD 	=> dummy_mux_inputs,
				ME 	=> dummy_mux_inputs,
				MF	=> dummy_mux_inputs,
				MG 	=> dummy_mux_inputs,
				MH 	=> dummy_mux_inputs,
				S 	=> int_web_y,
		  		CLK 	=> dummy_in, 	
				O 	=> rd_addrb_y,
				Q 	=> open_q_1_tms);




xbar_y <= bank;


thirty_one <= "11111";

--ena_x : not bank and bfly_res_avail_flag

ena_x_gen : and_a_notb_32_v3 PORT MAP(a_in => e_bfly_res_avail_flag,
			b_in => bank,
			and_out => int_ena_x);


--delay int_ena_x by 104 clocks for tem_int_ena_y. If bank=1 and temp_int_ena_y then int_ena_y =1

delay_int_ena_x : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => 96,
					DATA_WIDTH => 1)
				PORT MAP (addr => dummy_addr,
					data => temp_int_ena_x,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => temp_int_ena_y);


ena_y_gen : and_a_b_32_v3 PORT MAP(a_in => temp_int_ena_y(0),
			b_in => bank,
			and_out => int_ena_y);


ext_to_xbar_y_gen : flip_flop_ainit_sclr_v3 GENERIC MAP(ainit_val =>ainit_val)
					PORT MAP (d => not_ext_to_xbar_y,
						clk => clk,
						ce => mwr_or_start_or_count96_tc, --mwr,
						ainit => reset,
						sclr => dummy_in,
						q => ext_to_xbar_y );
--using nand to generate inversion of ext_to_xbar_y
not_ext_to_xbar_y_gen: nand_a_b_32_v3 PORT MAP (a_in => ext_to_xbar_y,
				b_in => ext_to_xbar_y,
				nand_out => not_ext_to_xbar_y);


-- web_y =  ext_to_xbar_y and usr_loading_addr

web_y_gen : and_a_b_32_v3 PORT MAP(a_in => ext_to_xbar_y,
			b_in => usr_loading_addr,
			and_out => int_web_y(0)); --web_y);

-- web_x = not ext_to_xbar_y and usr_loading_addr

web_x_gen : and_a_notb_32_v3 PORT MAP(a_in => usr_loading_addr,
			b_in => ext_to_xbar_y,
			and_out => int_web_x(0)); --web_x);



wea_x <= int_ena_x;
wea_y <= int_ena_y;

------------------------------
--Generating count96 signal --
------------------------------

count96_gen : C_COUNTER_BINARY_V4_0 GENERIC MAP(C_WIDTH => 7,
				C_OUT_TYPE => 1, 
			 	C_RESTRICT_COUNT=> 0,
			 	--C_COUNT_TO =>ninety_six,
				--C_COUNT_BY =>count_by_value,
			 	--C_COUNT_MODE => 0,
			 	C_THRESH0_VALUE => "",
			 	C_THRESH1_VALUE =>  "",
			 	C_AINIT_VAL => init_value,
			 	C_SINIT_VAL => init_value,
			 	--C_LOAD_ENABLE 	=> c_no_override,
			 	C_SYNC_ENABLE	=>  c_override,
			 	C_SYNC_PRIORITY	=>   c_clear,
			 	C_PIPE_STAGES	=>  1,
			 	C_HAS_THRESH0	=>  0, 
			 	C_HAS_Q_THRESH0	=>  0,
			 	C_HAS_THRESH1	=>  0,
			 	C_HAS_Q_THRESH1=>  0,
				C_HAS_CE => 1,
			 	C_HAS_UP=>  0,
			 	C_HAS_IV=>  1,
			 	C_HAS_L=>  0, 
			 	C_HAS_LOAD=>  0,
			 	C_LOAD_LOW=>  0,
			 	C_HAS_ACLR=>  0, 
			 	C_HAS_ASET=> 0,
			 	C_HAS_SSET=>  0,
			 	C_HAS_SINIT=>  0,
				C_HAS_SCLR => 1,
				C_HAS_AINIT =>0)
			PORT MAP(CLK => clk,
				UP => dummy_in, 
				CE => ce_96,
				LOAD => dummy_in,
		  		L => zero_96,  
		  		IV  => one_96,  
		  		ACLR  =>dummy_in,
		  		ASET  => dummy_in, 
				SCLR => sclr_sig_0, --e_bfly_res_avail, --start, 
				AINIT => dummy_in,
				SINIT => dummy_in, --count96_tc , 
		  		SSET => dummy_in, 
		 		THRESH0 => open_thresh0_96,  
		  		Q_THRESH0  => open_q_thresh0_96,  
		  		THRESH1 => open_thresh1_96,  
		  		Q_THRESH1 => open_q_thresh1_96,
				Q => count96);

sclr_sig_0_gen: or_a_b_32_v3 PORT MAP(a_in => e_bfly_res_avail,
				b_in => count95_tc,
				or_out => sclr_sig_0);

----------------------------------------------
-- clock_enable & terminal count for count96 
----------------------------------------------
ce_96_gen: srflop_v3 PORT MAP(clk => clk,
			ce => ce,
			set => e_bfly_res_avail, --start,
			reset => reset,
			q => ce_96);
tc_96_gen: and_a_b_32_v3 PORT MAP(a_in=> count96(5),
			b_in => count96(6),
			and_out => count96_tc);

ce_for_ext_toxbary: or_a_b_c_32_v3 PORT MAP (a_in => mwr,
					b_in => e_bfly_res_avail, --start,
					c_in => count95_tc, --count96_tc,
					or_out => mwr_or_start_or_count96_tc);
-------------------------------------------------
--generate count95_tc. wide and gate to decode 95
-------------------------------------------------

decode_95: C_GATE_BIT_V4_0 
   	GENERIC MAP (
      		C_GATE_TYPE 	=> 0,		--c_and
      		--C_ENABLE_RLOCS	=> c_enable_rlocs,
		C_INPUTS    	=> 7,
		C_INPUT_INV_MASK=> "0100000", --95
		C_AINIT_VAL 	=> "0",
		C_SINIT_VAL 	=> "0",
		C_HAS_O		=> 1,
		C_HAS_Q		=> 0,
		C_HAS_CE	=> 0,
		C_HAS_ACLR	=> 0,
		C_HAS_ASET	=> 0,
		C_HAS_AINIT	=> 0,
		C_HAS_SCLR	=> 0,
		C_HAS_SSET	=> 0,
		C_HAS_SINIT	=> 0) 
          PORT MAP (
          	I	=> count96,
		O	=> count95_tc,
		clk	=> dummy_in,
		q	=> fake_out,
		CE	=> dummy_in, 	
		AINIT 	=> dummy_in, 
		ASET 	=> dummy_in, 	
		ACLR 	=> dummy_in, 	
		SINIT	=> dummy_in,
		SSET	=> dummy_in,	
		SCLR 	=> dummy_in
		);


-----------------------------------------------------------------------------------
--generating bank signal. bank=0 means memory bank X . bank=1 means memory bank Y.
-----------------------------------------------------------------------------------
compare_address_31:	C_COMPARE_V4_0 GENERIC MAP(C_WIDTH =>5,
						C_B_CONSTANT => 1,
						C_B_VALUE => string_31,
						C_HAS_A_EQ_B => 1)
				PORT MAP (A=> address,
					B => thirty_one,
					CLK => clk,
					--CE => dummy_in,
					--ACLR => dummy_in,
					--ASET => dummy_in,
					--SCLR => start, 
					--SSET => dummy_in,
					A_EQ_B => last_bfly_in_rank, --aeqb, --last_bfly_in_rank,
					A_NE_B => aneb,
					A_LT_B => altb,	
					A_GT_B => agtb,	
					A_LE_B => aleb,	
					A_GE_B => ageb,	
					QA_EQ_B => qaeqb, --last_bfly_in_rank, --qaeqb, 	
					QA_NE_B => qaneb,	
					QA_LT_B => qaltb,	
					QA_GT_B => qagtb,	
					QA_LE_B => qaleb,	
					QA_GE_B => qageb	
					);


switch_banks_gen : and_a_b_32_v3 PORT MAP(a_in => last_bfly_in_rank,
			b_in => rank_number(1),
			and_out => switch_bank_temp);

delay_one_switch_bank: flip_flop_sclr_v3 PORT MAP ( d => switch_bank_temp,
						clk => clk,
						ce => ce,
						sclr => start,
						q => switch_banks);

bank_gen : flip_flop_ainit_sclr_v3 GENERIC MAP(ainit_val =>ainit_val_bank)
					PORT MAP (d => not_bank,
						clk => clk,
						ce => switch_banks,
						ainit => reset,
						sclr => start,
						q => bank );
--using nand to generate inversion of bank
not_bank_gen: nand_a_b_32_v3 PORT MAP (a_in => bank,
				b_in => bank,
				nand_out => not_bank);
------------------------------------------------------------------
-- Distsributed mem TMS   --
------------------------------------------------------------------

write_to_x_gen: and_a_notb_32_v3 PORT MAP(a_in => initial_data_load_x, --usr_loading_addr,
						b_in => ext_to_xbar_y,
						and_out => write_to_x);
--vk nov 21
--write_to_x <= initial_data_load_x OR NOT write_to_y;

wex_gen: or_a_b_32_v3 PORT MAP (a_in => write_to_x,
					b_in => e_bfly_res_avail_flag,
					or_out => wex_dmem_tms); 

--write_to_y_gen: and_a_b PORT MAP(a_in => usr_loading_addr,
--						b_in => delayed_ext_to_xbar_y_temp(0),
--						and_out => write_to_y);
write_to_y <= delayed_ext_to_xbar_y_temp(0);

wey_gen: or_a_b_32_v3 PORT MAP (a_in => write_to_y,
					b_in => e_bfly_res_avail_flag,
					or_out => wey_dmem_tms); 

addrb_dmem_tms <= address;
usr_loading_addr_temp(0) <= usr_loading_addr;
address_select_int(1) <= initial_data_load_x;
address_select_int(0) <= ext_to_xbar_y_temp(0); --delayed_ext_to_xbar_y_temp(0);
address_select <= address_select_int;

wr_or_usr_ld_addr_x: c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH => points_power,
					C_INPUTS => 3,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0,
					C_SEL_WIDTH => 2)
			PORT MAP (MA	=>delayed_usr_load_addr,
				MB 	=> wr_addr_int,
				MC 	=> usr_load_addr,
				MD 	=> dummy_mux_inputs,
				ME 	=> dummy_mux_inputs,
				MF	=> dummy_mux_inputs,
				MG 	=> dummy_mux_inputs,
				MH 	=> dummy_mux_inputs,
				S 	=> address_select_int, --ext_to_xbar_y_temp, --usr_loading_addr_temp, -- same as d_a_dmem_dms_sel,
		  		CLK 	=> dummy_in, 
		  		--CE 	=> dummy_in, 
		  		--EN 	=> dummy_in, 
		  		--ASET 	=> dummy_in, 
		  		--ACLR 	=> dummy_in, 
		  		--AINIT => dummy_in, 
		  		--SSET	=> dummy_in, 
		  		--SCLR 	=> dummy_in, 		
		  		--SINIT	=> dummy_in,	
				O	=> addra_x_dmem, 
				Q 	=> open_q_0_dms);

wr_or_usr_ld_addr_y: c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH => points_power,
					C_INPUTS => 2,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP (MA	=>wr_addr_int,
				MB 	=> delayed_usr_load_addr, --usr_load_addr,
				MC 	=> dummy_mux_inputs,
				MD 	=> dummy_mux_inputs,
				ME 	=> dummy_mux_inputs,
				MF	=> dummy_mux_inputs,
				MG 	=> dummy_mux_inputs,
				MH 	=> dummy_mux_inputs,
				S 	=> ext_to_xbar_y_temp, --ext_to_xbar_y_temp, --usr_loading_addr_temp, -- same as d_a_dmem_dms_sel,
		  		CLK 	=> dummy_in, 
		  		--CE 	=> dummy_in, 
		  		--EN 	=> dummy_in, 
		  		--ASET 	=> dummy_in, 
		  		--ACLR 	=> dummy_in, 
		  		--AINIT => dummy_in, 
		  		--SSET	=> dummy_in, 
		  		--SCLR 	=> dummy_in, 		
		  		--SINIT	=> dummy_in,	
				O	=> addra_y_dmem, 
				Q 	=> open_q_0_dms);


END GENERATE tms_mem_ctrl_gen;
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
---------------------Single Memory Space Config Memory Control ------------- 
-----------------------------------------------------------------------------

sms_mem_ctrl_gen: IF (memory_configuration=1) GENERATE

reading_result_flag(0) <= reading_result_temp;
usr_loading_addr_temp(0) <= usr_loading_addr;
reading_result <= reading_result_temp;
ena_x <= e_bfly_res_avail_flag;
e_bfly_res_avail_temp(0) <= e_bfly_res_avail;
reset_wea_x_int <= reset_wea_x(0);
writing_result_int_temp(0) <= writing_result_internal;
data_sel <= data_addr_sel ;
wea_x <= wea_x_int;

wea_x_gen : flip_flop_sclr_v3 PORT MAP (d => logic_1,
						clk => clk,
						ce => e_bfly_res_avail,
						reset => reset,
						sclr =>reset_wea_x_int,
						q => wea_x_int);

reset_wea_x_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => 64,
					DATA_WIDTH => 1)
				PORT MAP (addr => dummy_addr,
					data => e_bfly_res_avail_temp,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => reset_wea_x);
writing_result <= writing_result_internal; --(0);

--
--

result_wr_adgen_scrambled: C_COUNTER_BINARY_V4_0
		GENERIC MAP (	C_WIDTH		=> points_power,
				C_OUT_TYPE	=> 1,  --unsigned
				C_COUNT_BY	=> one_string_1,
				--C_THRESH0_VALUE => thirty_one,
				C_AINIT_VAL	=> ainit_val_1,
				C_SINIT_VAL	=> sinit_val_1,
				C_LOAD_ENABLE 	=> c_no_override,
				C_SYNC_ENABLE	=>  c_override, --vk aug 24
				C_HAS_THRESH0	=>  0, --1,
				C_HAS_Q_THRESH0	=>  0,
				C_HAS_CE	=> 1,
				C_HAS_IV	=> 1,
				C_HAS_L		=> 1,
				C_HAS_SCLR	=> 0,
				C_HAS_SINIT	=> 1,
				C_HAS_AINIT 	=> 0)
		PORT MAP (CLK => clk,
			  UP => logic_1,
			  CE => ce,
			  LOAD => dummy_in,
			  L => zero_1,
			  IV => one_1,
			  ACLR => dummy_in,
			  ASET => dummy_in,
			  AINIT => dummy_in, --vk aug 29reset,
			  SCLR => dummy_in,
			  SINIT => e_done_int, --_z, --result_avail,
			  SSET => dummy_in,
			  THRESH0 => open_thresh0_2, 
			  Q_THRESH0 => open_q_thresh0_2,   
		  	  THRESH1 => open_thresh1_2,  
		  	  Q_THRESH1 => open_q_thresh1_2,
			  Q => result_wr_addr);

scramble_wr_addr: FOR addr_bit IN 0 TO points_power-1 GENERATE
			result_wr_addr_scrambled(addr_bit) <= result_wr_addr(points_power-1 -addr_bit);			END GENERATE scramble_wr_addr; 

delay_result_wr_addr_scr : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => 3, --34, -- vk oct 26 32,
					DATA_WIDTH => points_power)
				PORT MAP (addr => dummy_addr,
					data => result_wr_addr_scrambled,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => result_wr_addr_scrambled_delayed);


result_rd_adgen: C_COUNTER_BINARY_V4_0
		GENERIC MAP (	C_WIDTH		=> points_power,
				C_OUT_TYPE	=> 1,  --unsigned
				C_COUNT_BY	=> one_string_1,
				C_THRESH0_VALUE => thirty_one_1,
				C_AINIT_VAL	=> ainit_val_1,
				C_SINIT_VAL	=> sinit_val_1,
				C_LOAD_ENABLE 	=> c_no_override,
				C_SYNC_ENABLE	=>  c_override, -- vk aug 24 c_no_override 
				C_HAS_THRESH0	=>  0, --1,
				C_HAS_Q_THRESH0	=>  1,
				C_HAS_CE	=> 1,
				C_HAS_IV	=> 1,
				C_HAS_L		=> 1,
				C_HAS_SCLR	=> 1,
				C_HAS_SINIT	=> 0, -- vk aug 24 0,
				C_HAS_AINIT 	=> 1,
				C_HAS_ACLR => 0) --vk aug 24 1)
		PORT MAP (CLK => clk,
			  UP => logic_1,
			  CE => ce,
			  LOAD => dummy_in,
			  L => zero_1,
			  IV => one_1,
			  ACLR => dummy_in, -- vk aug 24mrd, --dummy_in,
			 -- ASET => dummy_in,
			  AINIT => reset,
			  SCLR => mrd, -- dummy_in,
			 SINIT => dummy_in, --mrd, -- dummy_in, --mrd,
			 -- SSET => dummy_in,
			  --THRESH0 => open_thresh0_3, 
			  Q_THRESH0 => disable_read_enable,   
		  	 -- THRESH1 => open_thresh1_3,  
		  	 -- Q_THRESH1 => open_q_thresh1_3,
			  Q => result_read_addr);



reading_result_gen : flip_flop_sclr_v3 PORT MAP (d => logic_1,
						clk => clk,
						ce => mrd,
						reset => reset,
						sclr =>clr_sig, --disable_read_enable,-- mwr,
						q => reading_result_temp);


--clr_sig <= (disable_read_enable and not mrd) or (mwr); --mrd; vk nov 29
clr_sig <= (disable_read_enable and not mrd);
writing_result_gen : flip_flop_sclr_v3 PORT MAP (d => logic_1,
						clk => clk,
						ce => e_done_int, --_z, --_32(0), --e_done_int_z, --done_int, --e_done_int,
						reset => reset,
						sclr => done_int, --_z_32(0), --done_int_z,
						q => writing_result_internal);



writing_result_delayed_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => 3, --34, --vk oct 26 32,
					DATA_WIDTH => 1)
				PORT MAP (addr => dummy_addr,
					data => writing_result_int_temp,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => writing_result_int);

delay_1_done_int_gen : flip_flop_sclr_v3 PORT MAP (d => done_int,
						clk => clk,
						ce => ce,
						reset => reset,
						sclr =>dummy_in,
						q => done_int_z);

delay_1_e_done_int_gen : flip_flop_sclr_v3 PORT MAP (d => e_done_int,
						clk => clk,
						ce => ce,
						reset => reset,
						sclr =>dummy_in,
						q => e_done_int_z);

e_done_int_z_temp(0) <= e_done_int_z;
done_int_z_temp(0) <= done_int_z;

delayed_e_done_int_z_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => 32,
					DATA_WIDTH => 1)
				PORT MAP (addr => dummy_addr,
					data => e_done_int_z_temp,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => e_done_int_z_32);

delayed_done_int_z_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => 32,
					DATA_WIDTH => 1)
				PORT MAP (addr => dummy_addr,
					data => done_int_z_temp,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => done_int_z_32);

e_writing_result_int_gen :flip_flop_sclr_v3 PORT MAP (d => logic_1,
						clk => clk,
						ce => e_done_int, --done_int, --e_done_int,
						reset => reset,
						sclr => done_int,
						q => e_writing_result_int);

--
--
bfly_or_rd_wr_result_sel(1) <= reading_result_temp;
bfly_or_rd_wr_result_sel(0) <= writing_result_internal; --(0);--writing_result_internal;



web_gen_temp: or_a_b_32_v3	PORT MAP (a_in => usr_loading_addr,
			b_in => writing_result_int(0),
			or_out => web_x_temp);
web_gen: and_a_notb_32_v3 PORT MAP (a_in => web_x_temp,
					b_in => reading_result_temp,
					and_out => web_x); 

--dmem_controls_gen: If (data_memory="distributed_mem") GENERATE
data_addr_sel(0) <= usr_loading_addr;
data_addr_sel_gen_1_gen : and_a_notb_32_v3 PORT MAP (a_in => writing_result_int(0), --internal, --(0),
					b_in => reading_result_temp,
					and_out => data_addr_sel(1));
addr_sel(0) <= reading_result_temp;
mux_wr_usr_ld_wr_sc :  c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH => POINTS_POWER,
					C_INPUTS => 3,
					C_SEL_WIDTH => 2,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP ( MA  	=> wr_addr_int,
					MB 	=> usr_load_addr,
					MC 	=> result_wr_addr_scrambled_delayed,
					MD 	=> dummy_mux_inputs,
					ME 	=> dummy_mux_inputs,
					MF 	=> dummy_mux_inputs,
					MG 	=> dummy_mux_inputs,
					MH 	=> dummy_mux_inputs,
					S 	=> data_addr_sel,
		  			CLK 	=>dummy_in, 
		  			CE 	=>dummy_in,  
		  			EN 	=>dummy_in,  
		  			ASET 	=>dummy_in, 
		  			ACLR 	=>dummy_in, 
		  			AINIT 	=>dummy_in, 
		  			SSET	=>dummy_in, 
		  			SCLR 	=>dummy_in, 
		  			SINIT	=>dummy_in,	
					O => addra_dmem,
					Q => open_mux_ad);

mux_addr_rd_addr_uns : c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH => points_power,
					C_INPUTS => 2,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP (MA	=>address,
				MB 	=> result_read_addr,
				MC 	=> dummy_mux_inputs,
				MD 	=> dummy_mux_inputs,
				ME 	=> dummy_mux_inputs,
				MF	=> dummy_mux_inputs,
				MG 	=> dummy_mux_inputs,
				MH 	=> dummy_mux_inputs,
				S 	=> addr_sel,  --reading_result
		  		CLK 	=> dummy_in, 	
				O	=> addrb_dmem,
				Q 	=> open_addrb_sms);
				
				
we_dmem_int_gen: or_a_b_c_32_v3 PORT MAP (a_in => wea_x_int,
				b_in => usr_loading_addr,
				c_in => writing_result_int(0), --internal, --(0),
				or_out => we_dmem_int);
we_dmem_gen : and_a_notb_32_v3 PORT MAP (a_in => we_dmem_int,
				b_in => reading_result_temp,
				and_out => we_dmem);

--END GENERATE dmem_controls_gen;

END GENERATE sms_mem_ctrl_gen;


-----------------------------------------------------------------------------
---------------------Dual Memory Space Config Memory Control ------------- 
-----------------------------------------------------------------------------
dms_mem_ctrl_gen: IF (memory_configuration=2) GENERATE 

usr_loading_addr_temp(0) <= usr_loading_addr;
thirty_one <= (OTHERS => '1'); --"11111"; vk for xcc

int_ena_x <= e_bfly_res_avail_flag;
wea_x <= int_ena_x;
ena_x <= int_ena_x;
web_x <= usr_loading_addr;
int_web_x(0)<= usr_loading_addr;
temp_int_ena_x(0) <= int_ena_x;


--dmem: IF (data_memory="distributed_mem") GENERATE
wr_or_usr_ld_addr: c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH => points_power,
					C_INPUTS => 2,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP (MA	=>wr_addr_int,
				MB 	=> usr_load_addr,
				MC 	=> dummy_mux_inputs,
				MD 	=> dummy_mux_inputs,
				ME 	=> dummy_mux_inputs,
				MF	=> dummy_mux_inputs,
				MG 	=> dummy_mux_inputs,
				MH 	=> dummy_mux_inputs,
				S 	=> usr_loading_addr_temp, -- same as d_a_dmem_dms_sel,
		  		CLK 	=> dummy_in, 
		  		--CE 	=> dummy_in, 
		  		--EN 	=> dummy_in, 
		  		--ASET 	=> dummy_in, 
		  		--ACLR 	=> dummy_in, 
		  		--AINIT => dummy_in, 
		  		--SSET	=> dummy_in, 
		  		--SCLR 	=> dummy_in, 		
		  		--SINIT	=> dummy_in,	
				O	=> addra_dmem, 
				Q 	=> open_q_0_dms);



--vkaug3101
--hold_off_we_16_gen : srflop_v3 PORT MAP (clk => clk,
--				ce => ce,
--				set => reset_io,
--				reset => reset_io_16,
--				q => hold_off_we_16);
process (clk)
begin
 if clk'event and clk='1' then
   if (start ='1' or reset_io_16 = '1') then hold_off_we_16 <= '0';
   elsif reset_io= '1' then  hold_off_we_16 <='1';
 --    if reset_io_16 = '1' then hold_off_we_16 <='0';  

  --  end if;--
 end if;
 end if;
end process;


reset_io_16_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => 14,
					DATA_WIDTH => 1)
				PORT MAP (addr => dummy_addr,
					data => io_reset_temp, --same as reset_io,
					clk => clk,
					reset => reset,
					start => io_pulse_temp(0),
					delayed_data => reset_io_16_temp);
reset_io_16 <= reset_io_16_temp(0);


we_dmem_and : and_a_notb_32_v3  PORT MAP (a_in => test_sig, --e_bfly_res_avail_flag,
				b_in => hold_off_we_16,
				and_out => e_bfly_res_avail_flag_dms);
				

test_sig_gen: srflop_v3 PORT MAP (clk => clk,
				ce => ce,
				set =>e_bfly_res_avail,
				reset => reset,
				q => test_sig);

--we_dmem_dms <= usr_loading_addr or e_bfly_res_avail_flag;
we_dmem_dms_gen : or_a_b_32_v3 PORT MAP (a_in => usr_loading_addr,
						b_in => e_bfly_res_avail_flag_dms, --e_bfly_res_avail_flag,
						or_out => we_dmem_dms);

--vknov901
--addrb_dmem_dms <= address;
process (clk)
begin
if eio_int='1' then
addrb_dmem_dms <= (OTHERS => '0');
else addrb_dmem_dms <= address;
end if;
end process;

-----------------------------------------------------------------------------------
--generating io and eio signals
-----------------------------------------------------------------------------------
compare_address_29:	C_COMPARE_V4_0 GENERIC MAP(C_WIDTH =>5,
						C_B_CONSTANT => 1,
						C_B_VALUE => string_31, --string_28,
						C_HAS_A_EQ_B => 1,
						C_HAS_QA_EQ_B => 0,
						C_HAS_CE => 0)
				PORT MAP (A=> address,
					B => twenty_eight,
					CLK => clk,
					CE => ce,
					--ACLR => dummy_in,
					--ASET => dummy_in,
					--SCLR => start, 
					--SSET => dummy_in,
					A_EQ_B => e_last_bfly_in_rank ,
					A_NE_B => aneb,
					A_LT_B => altb,	
					A_GT_B => agtb,	
					A_LE_B => aleb,	
					A_GE_B => ageb,	
					QA_EQ_B => qaeqb, 	
					QA_NE_B => qaneb,	
					QA_LT_B => qaltb,	
					QA_GT_B => qagtb,	
					QA_LE_B => qaleb,	
					QA_GE_B => qageb	
					);

e_last_bfly_in_rank_temp(0) <= e_last_bfly_in_rank;
io <= io_temp(0);
eio_temp(0) <= eio_pulse;
eio_pulse_out <= eio_pulse;
reset_eio <= eio_reset_temp(0);
reset_io <= io_reset_temp(0);
reset_io_out <= reset_io;

eio <= eio_int;
temp_eio_int(0) <= eio_int;


eio_gen : and_a_b_32_v3 PORT MAP(a_in => e_last_bfly_in_rank,
			b_in => rank_number(1),
			and_out => eio_pulse);

eio_flag_gen : flip_flop_sclr_v3 PORT MAP (d => logic_1,
						clk => clk,
						ce => eio_pulse,
						reset => reset,
						sclr =>reset_eio,
						q => eio_int);

eio_flag_reset_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => 32,
					DATA_WIDTH => 1)
				PORT MAP (addr => dummy_addr,
					data => eio_temp,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => eio_reset_temp);


io_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => 2,
					DATA_WIDTH => 1)
				PORT MAP (addr => dummy_addr,
					data => temp_eio_int, --eio_temp, --e_last_bfly_in_rank_temp,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => io_temp);

io_pulse_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => 2, --1
					DATA_WIDTH => 1)
				PORT MAP (addr => dummy_addr,
					data => eio_temp,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => io_pulse_temp);

io_pulse <= io_pulse_temp(0);


io_reset_gen: delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => 2,
					DATA_WIDTH => 1)
				PORT MAP (addr => dummy_addr,
					data => eio_reset_temp,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => io_reset_temp); 
set_delayed_addr: srflop_v3 PORT MAP (clk => clk,
				ce => ce,
				set => reset_eio,
				reset => start,  
				q => address_select_dms_temp);

address_select_dms(0) <= address_select_dms_temp;
address_select_dms_out <= address_select_dms;

END GENERATE dms_mem_ctrl_gen;
-----------------------------------------------------------------------------



END behavioral;

---------------------END mem_ctrl---------------------------------------------------


---------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
---------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
--USE ieee.std_logic_arith.all;
		
LIBRARY XilinxCoreLib;
USE XilinxCoreLib.blkmemdp_v4_0_comp.all;

ENTITY mem_wkg_r_i_v3 IS
	GENERIC (B : INTEGER;
		POINTS_POWER : INTEGER);
	PORT (	addra	: IN STD_LOGIC_VECTOR(POINTS_POWER-1 DOWNTO 0);
		wea	: IN STD_LOGIC;
		ena	: IN STD_LOGIC;
		dia_r	: IN STD_lOGIC_VECTOR(B-1 DOWNTO 0);
		dia_i	: IN STD_lOGIC_VECTOR(B-1 DOWNTO 0);
		reset	: IN STD_LOGIC;
		clk	: IN STD_LOGIC;
		addrb	: IN STD_LOGIC_VECTOR(POINTS_POWER-1 DOWNTO 0);
		web	: IN STD_LOGIC;
		enb	: IN STD_LOGIC;
		dib_r	: IN STD_lOGIC_VECTOR(B-1 DOWNTO 0);
		dib_i	: IN STD_lOGIC_VECTOR(B-1 DOWNTO 0);
		dob_r	: OUT STD_lOGIC_VECTOR(B-1 DOWNTO 0);
		dob_i	: OUT STD_lOGIC_VECTOR(B-1 DOWNTO 0));
END mem_wkg_r_i_v3;

ARCHITECTURE behavioral OF mem_wkg_r_i_v3 IS

CONSTANT default_data : STRING(B DOWNTO 1):=(OTHERS => '0');
SIGNAL open_doa_r		: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL open_doa_i		: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL logic_1		: STD_LOGIC	:= '1';

SIGNAL open_rdya_r : STD_LOGIC;
SIGNAL open_rdyb_r : STD_LOGIC;
SIGNAL open_rfda_r : STD_LOGIC;
SIGNAL open_rfdb_r : STD_LOGIC;

SIGNAL open_rdya_i : STD_LOGIC;
SIGNAL open_rdyb_i : STD_LOGIC;
SIGNAL open_rfda_i : STD_LOGIC;
SIGNAL open_rfdb_i : STD_LOGIC;
BEGIN

logic_1 <= '1';

mem_r	: blkmemdp_v4_0
			GENERIC MAP(c_addra_width=> points_power,
				c_addrb_width => points_power,
            			--C_CLKA_POLARITY   => 1,
            			--C_CLKB_POLARITY   => 1,
            			C_DEFAULT_DATA    => default_data, 
				C_DEPTH_A => 32,
				C_DEPTH_B => 32,
            			--C_ENA_POLARITY    => 1,
           			--C_ENB_POLARITY    => 1,
            			--C_GENERATE_MIF    => 0,
            			c_has_dina         => 1,
            			c_has_dinb         => 1,
            			C_HAS_DOUTA         => 0,
            			C_HAS_DOUTB         => 1,
            			C_HAS_ENA         => 1,
             			C_HAS_ENB         => 1,
            			C_HAS_SINITA        => 1,
            			C_HAS_SINITB        => 1,
           		 	C_HAS_WEA         => 1,
            			C_HAS_WEB         => 1,
            			C_MEM_INIT_FILE   => "null.mif",
            			--C_MEM_INIT_RADIX  => 2,
            			C_PIPE_STAGES_A     => 0,
            			C_PIPE_STAGES_B     => 0,
            			--C_READ_MIF        => 0,
            			--C_RSTA_POLARITY   => 1,
            			--C_RSTB_POLARITY   => 1,
            			--C_WEA_POLARITY    => 1,
            			--C_WEB_POLARITY    => 1,
				C_WIDTH_A => B,
				C_WIDTH_B => B)
			PORT MAP (addra => addra, --write_addr,
				addrb => addrb, --read_addr_x,
				dina => dia_r, --xk_r,
				dinb => dib_r, --xn_r,
				clka => clk,
				clkb => clk,
				wea => wea, 
				web => web, 
				ena => ena, 
				enb => logic_1,
				sinita => reset,
				sinitb => reset,
				douta => open_doa_r,
				doutb => dob_r,
				rdya => open_rdya_r,
				rdyb => open_rdyb_r,
				rfda => open_rfda_r,
				rfdb => open_rfdb_r);

mem_i	: blkmemdp_v4_0
			GENERIC MAP(c_addra_width=> points_power,
				c_addrb_width => points_power,
            			--C_CLKA_POLARITY   => 1,
            			--C_CLKB_POLARITY   => 1,
            			C_DEFAULT_DATA    => default_data, 
				C_DEPTH_A => 32,
				C_DEPTH_B => 32,
            			--C_ENA_POLARITY    => 1,
           			--C_ENB_POLARITY    => 1,
            			--C_GENERATE_MIF    => 0,
            			c_has_dina         => 1,
            			c_has_dinb         => 1,
            			C_HAS_DOUTA         => 0,
            			C_HAS_DOUTB         => 1,
            			C_HAS_ENA         => 1,
             			C_HAS_ENB         => 1,
            			C_HAS_SINITA        => 1,
            			C_HAS_SINITB        => 1,
           		 	C_HAS_WEA         => 1,
            			C_HAS_WEB         => 1,
            			C_MEM_INIT_FILE   => "null.mif",
            			--C_MEM_INIT_RADIX  => 2,
            			C_PIPE_STAGES_A     => 0,
            			C_PIPE_STAGES_B     => 0,
            			--C_READ_MIF        => 0,
            			--C_RSTA_POLARITY   => 1,
            			--C_RSTB_POLARITY   => 1,
            			--C_WEA_POLARITY    => 1,
            			--C_WEB_POLARITY    => 1,
				C_WIDTH_A => B,
				C_WIDTH_B => B)
			PORT MAP (addra => addra, --write_addr,
				addrb => addrb, --read_addr_x,
				dina => dia_i, --xk_r,
				dinb => dib_i, --xn_r,
				clka => clk,
				clkb => clk,
				wea => wea, 
				web => web, 
				ena => ena, 
				enb => logic_1,
				sinita => reset,
				sinitb => reset,
				douta => open_doa_i,
				doutb => dob_i,
				rdya => open_rdya_i,
				rdyb => open_rdyb_i,
				rfda => open_rfda_i,
				rfdb => open_rfdb_i);

END behavioral;

-------------------------------END mem_wkg_r_i_v3-------------------------------------

--------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
--------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
		
LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_MUX_BUS_V4_0_comp.all;
USE XilinxCoreLib.vfft32_comps_v3.all;

ENTITY working_memory_v3 IS
	GENERIC (B		: INTEGER;
		POINTS_POWER	: INTEGER := 5;
		memory_architecture : INTEGER := 3;
		data_memory: STRING := "distributed_mem");
	PORT (	clk	: IN STD_LOGIC;
		reset	: IN STD_LOGIC;
		start	: IN STD_LOGIC;
		xbar_y	: IN STD_LOGIC;
		ext_to_xbar_y_temp_out		: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		dia_r	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0); --intermediate result
		dia_i	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0); --intermediate result
		ena_x	: IN STD_LOGIC;
		wea_x	: IN STD_LOGIC;
		wex_dmem_tms : IN STD_LOGIC;
		wey_dmem_tms : IN STD_LOGIC;
		addra	: IN STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		addra_dmem	: IN STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		addra_x_dmem	: IN STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		addra_y_dmem	: IN STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		xn_re	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0); --intermediate result
		xn_im	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0); --intermediate result
		web_x	: IN STD_LOGIC;
		we_dmem_dms:  IN STD_LOGIC;
		usr_loading_addr : IN STD_LOGIC;
		d_a_dmem_dms_sel: IN STD_LOGIC;
		address_select_dms : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
		addrb_dmem_dms	: IN STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		addrb_dmem_tms	: IN STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		address_select : IN STD_LOGIC_VECTOR(1 DOWNTO 0); 
		ena_y	: IN STD_LOGIC;
		wea_y	: IN STD_LOGIC;
		web_y	: IN STD_LOGIC;
		mem_outr: OUT STD_LOGIC_VECTOR(B-1 DOWNTO 0); -- to bfly_fft proc. re
		mem_outi: OUT STD_LOGIC_VECTOR(B-1 DOWNTO 0));-- to bfly_fft proc. im		
END working_memory_v3;

ARCHITECTURE behavioral of working_memory_v3 IS


CONSTANT bfly_res_avail_latency: INTEGER := 16;

--------------------------------------------------
-- Dummy Signals. Connect to unused baseblox ports.
--------------------------------------------------
SIGNAL dummy_in		: STD_LOGIC	:= '0';
SIGNAL dummy_mux_inputs_1	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL open_q_2			: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL open_q_3			: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL open_q_re : STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL open_q_im : STD_LOGIC_VECTOR(B-1 DOWNTO 0);


SIGNAL logic_1		: STD_LOGIC	:= '1';
SIGNAL logic_0		: STD_LOGIC	:= '0';

--------------------------------------------------
-- Memory outputs. Connect to "x or y mux" inputs .
--------------------------------------------------
SIGNAL x_to_bfly_r: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL x_to_bfly_i: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL y_to_bfly_r: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL y_to_bfly_i: STD_LOGIC_VECTOR(B-1 DOWNTO 0);

---------------------------------------------------
--  Baseblox mux select must be std_logic_vector
---------------------------------------------------
SIGNAL xbar_y_temp	: STD_LOGIC_VECTOR(0 DOWNTO 0);

SIGNAL d_a_dmem_dms_sel_temp : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL dib_r : STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL dib_i : STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL d_re : STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL d_im : STD_LOGIC_VECTOR(B-1 DOWNTO 0);

SIGNAL open_dib_r :STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL open_dib_i :STD_LOGIC_VECTOR(B-1 DOWNTO 0);

SIGNAL delayed_xn_re : STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL delayed_xn_im : STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL d_re_x : STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL d_im_x : STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL d_re_y : STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL d_im_y : STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL dummy_addr : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL not_ext_to_xbar_y_temp_out : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL usr_loading_addr_temp	:STD_LOGIC_VECTOR(0 DOWNTO 0);


BEGIN
logic_1 <= '1';
logic_0 <= '0';


d_a_dmem_dms_sel_temp(0) <= d_a_dmem_dms_sel;
dib_r <= xn_re;
dib_i <= xn_im;

tms_wkg_mem_gen: IF (memory_architecture = 3) GENERATE

xbar_y_temp(0) <= xbar_y;
not_ext_to_xbar_y_temp_out <= not ext_to_xbar_y_temp_out;

delay_xn_re : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => bfly_res_avail_latency, --delay_by_value, -- -1 ,
					DATA_WIDTH => B)
				PORT MAP (addr => dummy_addr,
					data => xn_re,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => delayed_xn_re);

delay_xn_im : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => bfly_res_avail_latency, --delay_by_value, -- -1 ,
					DATA_WIDTH => B)
				PORT MAP (addr => dummy_addr,
					data => xn_im,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => delayed_xn_im);

--dmem_tms_gen: If (data_memory="distributed_mem") GENERATE

xn_or_dia_r_x:	c_mux_bus_v4_0
			GENERIC MAP(	C_WIDTH => B,
					C_INPUTS => 3,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0,
					C_SEL_WIDTH => 2)
			PORT MAP ( 	MA	=> delayed_xn_re, --dia_r,
					MB 	=> dia_r,
					MC 	=> xn_re, --dummy_mux_inputs_1,
					MD 	=> dummy_mux_inputs_1,
					ME 	=> dummy_mux_inputs_1,
					MF 	=> dummy_mux_inputs_1,
					MG 	=> dummy_mux_inputs_1,
					MH 	=> dummy_mux_inputs_1,
					MAA 	=> dummy_mux_inputs_1,
					MAB 	=> dummy_mux_inputs_1,
					MAC 	=> dummy_mux_inputs_1,
					MAD 	=> dummy_mux_inputs_1,
					MAE 	=> dummy_mux_inputs_1,
					MAF 	=> dummy_mux_inputs_1,
					MAG 	=> dummy_mux_inputs_1,
					MAH 	=> dummy_mux_inputs_1,
					MBA 	=> dummy_mux_inputs_1,
					MBB 	=> dummy_mux_inputs_1,
					MBC 	=> dummy_mux_inputs_1,
					MBD 	=> dummy_mux_inputs_1,
					MBE 	=> dummy_mux_inputs_1,
					MBF 	=> dummy_mux_inputs_1,
					MBG 	=> dummy_mux_inputs_1,
					MBH 	=> dummy_mux_inputs_1,
					MCA 	=> dummy_mux_inputs_1,
					MCB 	=> dummy_mux_inputs_1,
					MCC 	=> dummy_mux_inputs_1,
					MCD 	=> dummy_mux_inputs_1,
					MCE 	=> dummy_mux_inputs_1,
					MCF 	=> dummy_mux_inputs_1,
					MCG 	=> dummy_mux_inputs_1,
					MCH 	=> dummy_mux_inputs_1,
					S 	=> address_select, --d_a_dmem_dms_sel_temp, --same as usr_loading_addr
		  			CLK 	=> dummy_in, -- Optional clock
		  			CE 	=> dummy_in,  -- Optional Clock enable
		 			EN 	=> dummy_in,  -- Optional BUFT enable
		  			ASET 	=> dummy_in, -- optional asynch set to '1'
		  			ACLR 	=> dummy_in, -- Asynch init.
		  			AINIT 	=> dummy_in, -- optional asynch reset to init_val
		  			SSET	=> dummy_in, -- optional synch set to '1'
		  			SCLR 	=> dummy_in, -- Synch init.
		  			SINIT	=> dummy_in,	
					O 	=> d_re_x,
					Q 	=> open_q_re);

xn_or_dia_i_x:	c_mux_bus_v4_0
			GENERIC MAP(	C_WIDTH => B,
					C_INPUTS => 3,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0,
					C_SEL_WIDTH => 2)
			PORT MAP ( 	MA	=> delayed_xn_im, --dia_r,
					MB 	=> dia_i,
					MC 	=> xn_im, --dummy_mux_inputs_1,
					MD 	=> dummy_mux_inputs_1,
					ME 	=> dummy_mux_inputs_1,
					MF 	=> dummy_mux_inputs_1,
					MG 	=> dummy_mux_inputs_1,
					MH 	=> dummy_mux_inputs_1,
					MAA 	=> dummy_mux_inputs_1,
					MAB 	=> dummy_mux_inputs_1,
					MAC 	=> dummy_mux_inputs_1,
					MAD 	=> dummy_mux_inputs_1,
					MAE 	=> dummy_mux_inputs_1,
					MAF 	=> dummy_mux_inputs_1,
					MAG 	=> dummy_mux_inputs_1,
					MAH 	=> dummy_mux_inputs_1,
					MBA 	=> dummy_mux_inputs_1,
					MBB 	=> dummy_mux_inputs_1,
					MBC 	=> dummy_mux_inputs_1,
					MBD 	=> dummy_mux_inputs_1,
					MBE 	=> dummy_mux_inputs_1,
					MBF 	=> dummy_mux_inputs_1,
					MBG 	=> dummy_mux_inputs_1,
					MBH 	=> dummy_mux_inputs_1,
					MCA 	=> dummy_mux_inputs_1,
					MCB 	=> dummy_mux_inputs_1,
					MCC 	=> dummy_mux_inputs_1,
					MCD 	=> dummy_mux_inputs_1,
					MCE 	=> dummy_mux_inputs_1,
					MCF 	=> dummy_mux_inputs_1,
					MCG 	=> dummy_mux_inputs_1,
					MCH 	=> dummy_mux_inputs_1,
					S 	=> address_select, --d_a_dmem_dms_sel_temp, --same as usr_loading_addr
		  			CLK 	=> dummy_in, -- Optional clock
		  			CE 	=> dummy_in,  -- Optional Clock enable
		 			EN 	=> dummy_in,  -- Optional BUFT enable
		  			ASET 	=> dummy_in, -- optional asynch set to '1'
		  			ACLR 	=> dummy_in, -- Asynch init.
		  			AINIT 	=> dummy_in, -- optional asynch reset to init_val
		  			SSET	=> dummy_in, -- optional synch set to '1'
		  			SCLR 	=> dummy_in, -- Synch init.
		  			SINIT	=> dummy_in,	
					O 	=> d_im_x,
					Q 	=> open_q_im);
xn_or_dia_i_y:	c_mux_bus_v4_0
			GENERIC MAP(	C_WIDTH => B,
					C_INPUTS => 2,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP ( 	MA	=> dia_i,
					MB 	=> delayed_xn_im,
					MC 	=> dummy_mux_inputs_1,
					MD 	=> dummy_mux_inputs_1,
					ME 	=> dummy_mux_inputs_1,
					MF 	=> dummy_mux_inputs_1,
					MG 	=> dummy_mux_inputs_1,
					MH 	=> dummy_mux_inputs_1,
					MAA 	=> dummy_mux_inputs_1,
					MAB 	=> dummy_mux_inputs_1,
					MAC 	=> dummy_mux_inputs_1,
					MAD 	=> dummy_mux_inputs_1,
					MAE 	=> dummy_mux_inputs_1,
					MAF 	=> dummy_mux_inputs_1,
					MAG 	=> dummy_mux_inputs_1,
					MAH 	=> dummy_mux_inputs_1,
					MBA 	=> dummy_mux_inputs_1,
					MBB 	=> dummy_mux_inputs_1,
					MBC 	=> dummy_mux_inputs_1,
					MBD 	=> dummy_mux_inputs_1,
					MBE 	=> dummy_mux_inputs_1,
					MBF 	=> dummy_mux_inputs_1,
					MBG 	=> dummy_mux_inputs_1,
					MBH 	=> dummy_mux_inputs_1,
					MCA 	=> dummy_mux_inputs_1,
					MCB 	=> dummy_mux_inputs_1,
					MCC 	=> dummy_mux_inputs_1,
					MCD 	=> dummy_mux_inputs_1,
					MCE 	=> dummy_mux_inputs_1,
					MCF 	=> dummy_mux_inputs_1,
					MCG 	=> dummy_mux_inputs_1,
					MCH 	=> dummy_mux_inputs_1,
					S 	=> ext_to_xbar_y_temp_out,
		  			CLK 	=> dummy_in, -- Optional clock
		  			CE 	=> dummy_in,  -- Optional Clock enable
		 			EN 	=> dummy_in,  -- Optional BUFT enable
		  			ASET 	=> dummy_in, -- optional asynch set to '1'
		  			ACLR 	=> dummy_in, -- Asynch init.
		  			AINIT 	=> dummy_in, -- optional asynch reset to init_val
		  			SSET	=> dummy_in, -- optional synch set to '1'
		  			SCLR 	=> dummy_in, -- Synch init.
		  			SINIT	=> dummy_in,	
					O 	=> d_im_y,
					Q 	=> open_q_im);

xn_or_dia_r_y:	c_mux_bus_v4_0
			GENERIC MAP(	C_WIDTH => B,
					C_INPUTS => 2,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP ( 	MA	=> dia_r,
					MB 	=> delayed_xn_re,
					MC 	=> dummy_mux_inputs_1,
					MD 	=> dummy_mux_inputs_1,
					ME 	=> dummy_mux_inputs_1,
					MF 	=> dummy_mux_inputs_1,
					MG 	=> dummy_mux_inputs_1,
					MH 	=> dummy_mux_inputs_1,
					MAA 	=> dummy_mux_inputs_1,
					MAB 	=> dummy_mux_inputs_1,
					MAC 	=> dummy_mux_inputs_1,
					MAD 	=> dummy_mux_inputs_1,
					MAE 	=> dummy_mux_inputs_1,
					MAF 	=> dummy_mux_inputs_1,
					MAG 	=> dummy_mux_inputs_1,
					MAH 	=> dummy_mux_inputs_1,
					MBA 	=> dummy_mux_inputs_1,
					MBB 	=> dummy_mux_inputs_1,
					MBC 	=> dummy_mux_inputs_1,
					MBD 	=> dummy_mux_inputs_1,
					MBE 	=> dummy_mux_inputs_1,
					MBF 	=> dummy_mux_inputs_1,
					MBG 	=> dummy_mux_inputs_1,
					MBH 	=> dummy_mux_inputs_1,
					MCA 	=> dummy_mux_inputs_1,
					MCB 	=> dummy_mux_inputs_1,
					MCC 	=> dummy_mux_inputs_1,
					MCD 	=> dummy_mux_inputs_1,
					MCE 	=> dummy_mux_inputs_1,
					MCF 	=> dummy_mux_inputs_1,
					MCG 	=> dummy_mux_inputs_1,
					MCH 	=> dummy_mux_inputs_1,
					S 	=> ext_to_xbar_y_temp_out, 
		  			CLK 	=> dummy_in, -- Optional clock
		  			CE 	=> dummy_in,  -- Optional Clock enable
		 			EN 	=> dummy_in,  -- Optional BUFT enable
		  			ASET 	=> dummy_in, -- optional asynch set to '1'
		  			ACLR 	=> dummy_in, -- Asynch init.
		  			AINIT 	=> dummy_in, -- optional asynch reset to init_val
		  			SSET	=> dummy_in, -- optional synch set to '1'
		  			SCLR 	=> dummy_in, -- Synch init.
		  			SINIT	=> dummy_in,	
					O 	=> d_re_y,
					Q 	=> open_q_re);

bmem_tms_gen: If (data_memory="block_mem") GENERATE
mem_x_re_imag: mem_wkg_r_i_v3
	GENERIC MAP (B => B,
		POINTS_POWER => points_power)
	PORT MAP (	addra	=> addra_x_dmem, --addra_dmem, --addra,
		wea	=> wex_dmem_tms, --wea_x,
		ena	=> logic_1, --ena_x,
		dia_r	=> d_re_x, --d_re, --dia_r,
		dia_i	=> d_im_x, --d_im, --dia_i,
		reset	=> reset,
		clk	=> clk,
		addrb	=> addrb_dmem_tms, --addrb_x,
		web	=> logic_0, --web_x,
		enb	=> logic_1,
		dib_r	=> open_dib_r,--dib_r,
		dib_i	=> open_dib_i, --dib_i,
		dob_r	=> x_to_bfly_r,
		dob_i	=> x_to_bfly_i);

mem_y_re_imag: mem_wkg_r_i_v3
	GENERIC MAP (B => B,
		POINTS_POWER => points_power)
	PORT MAP (	addra	=> addra_y_dmem, --addra_dmem, --addra,
		wea	=> wey_dmem_tms, --wea_y,
		ena	=> logic_1, --ena_y,
		dia_r	=> d_re_y, --d_re, --dia_r,
		dia_i	=> d_im_y, --d_im, --dia_i,
		reset	=> reset,
		clk	=> clk,
		addrb	=> addrb_dmem_tms, --addrb_y,
		web	=> logic_0, --web_y,
		enb	=> logic_1,
		dib_r	=> open_dib_r, --dib_r,
		dib_i	=> open_dib_i, --dib_i,
		dob_r	=> y_to_bfly_r,
		dob_i	=> y_to_bfly_i);

END GENERATE bmem_tms_gen;

dmem_tms_gen: If (data_memory="distributed_mem") GENERATE

dmem_x_re_imag: dmem_wkg_r_i_v3
	GENERIC MAP (B => B,
		POINTS_POWER => points_power)
	PORT MAP (	a	=> addra_x_dmem,
		we => wex_dmem_tms,
		d_re => d_re_x,
		d_im => d_im_x,
		clk => clk,
		dpra => addrb_dmem_tms,
		qdpo_re => x_to_bfly_r,
		qdpo_im => x_to_bfly_i);

dmem_y_re_imag: dmem_wkg_r_i_v3
	GENERIC MAP (B => B,
		POINTS_POWER => points_power)
	PORT MAP (	a	=> addra_y_dmem,
		we => wey_dmem_tms,
		d_re => d_re_y,
		d_im => d_im_y,
		clk => clk,
		dpra => addrb_dmem_tms,
		qdpo_re => y_to_bfly_r,
		qdpo_im => y_to_bfly_i);

END GENERATE dmem_tms_gen;


x_or_y_to_bfly_r:	c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH => B,
					C_INPUTS => 2,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP ( 	MA	=> x_to_bfly_r,
					MB 	=> y_to_bfly_r,
					MC 	=> dummy_mux_inputs_1,
					MD 	=> dummy_mux_inputs_1,
					ME 	=> dummy_mux_inputs_1,
					MF 	=> dummy_mux_inputs_1,
					MG 	=> dummy_mux_inputs_1,
					MH 	=> dummy_mux_inputs_1,
					MAA 	=> dummy_mux_inputs_1,
					MAB 	=> dummy_mux_inputs_1,
					MAC 	=> dummy_mux_inputs_1,
					MAD 	=> dummy_mux_inputs_1,
					MAE 	=> dummy_mux_inputs_1,
					MAF 	=> dummy_mux_inputs_1,
					MAG 	=> dummy_mux_inputs_1,
					MAH 	=> dummy_mux_inputs_1,
					MBA 	=> dummy_mux_inputs_1,
					MBB 	=> dummy_mux_inputs_1,
					MBC 	=> dummy_mux_inputs_1,
					MBD 	=> dummy_mux_inputs_1,
					MBE 	=> dummy_mux_inputs_1,
					MBF 	=> dummy_mux_inputs_1,
					MBG 	=> dummy_mux_inputs_1,
					MBH 	=> dummy_mux_inputs_1,
					MCA 	=> dummy_mux_inputs_1,
					MCB 	=> dummy_mux_inputs_1,
					MCC 	=> dummy_mux_inputs_1,
					MCD 	=> dummy_mux_inputs_1,
					MCE 	=> dummy_mux_inputs_1,
					MCF 	=> dummy_mux_inputs_1,
					MCG 	=> dummy_mux_inputs_1,
					MCH 	=> dummy_mux_inputs_1,
					S 	=> xbar_y_temp,
		  			CLK 	=> dummy_in, -- Optional clock
		  			CE 	=> dummy_in,  -- Optional Clock enable
		 			EN 	=> dummy_in,  -- Optional BUFT enable
		  			ASET 	=> dummy_in, -- optional asynch set to '1'
		  			ACLR 	=> dummy_in, -- Asynch init.
		  			AINIT 	=> dummy_in, -- optional asynch reset to init_val
		  			SSET	=> dummy_in, -- optional synch set to '1'
		  			SCLR 	=> dummy_in, -- Synch init.
		  			SINIT	=> dummy_in,				
					O 	=> mem_outr,
					Q 	=> open_q_2);

x_or_y_to_bfly_i:	c_mux_bus_v4_0
			GENERIC MAP(	C_WIDTH => B,
					C_INPUTS => 2,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP ( 	MA	=> x_to_bfly_i,
					MB 	=> y_to_bfly_i,
					MC 	=> dummy_mux_inputs_1,
					MD 	=> dummy_mux_inputs_1,
					ME 	=> dummy_mux_inputs_1,
					MF 	=> dummy_mux_inputs_1,
					MG 	=> dummy_mux_inputs_1,
					MH 	=> dummy_mux_inputs_1,
					MAA 	=> dummy_mux_inputs_1,
					MAB 	=> dummy_mux_inputs_1,
					MAC 	=> dummy_mux_inputs_1,
					MAD 	=> dummy_mux_inputs_1,
					MAE 	=> dummy_mux_inputs_1,
					MAF 	=> dummy_mux_inputs_1,
					MAG 	=> dummy_mux_inputs_1,
					MAH 	=> dummy_mux_inputs_1,
					MBA 	=> dummy_mux_inputs_1,
					MBB 	=> dummy_mux_inputs_1,
					MBC 	=> dummy_mux_inputs_1,
					MBD 	=> dummy_mux_inputs_1,
					MBE 	=> dummy_mux_inputs_1,
					MBF 	=> dummy_mux_inputs_1,
					MBG 	=> dummy_mux_inputs_1,
					MBH 	=> dummy_mux_inputs_1,
					MCA 	=> dummy_mux_inputs_1,
					MCB 	=> dummy_mux_inputs_1,
					MCC 	=> dummy_mux_inputs_1,
					MCD 	=> dummy_mux_inputs_1,
					MCE 	=> dummy_mux_inputs_1,
					MCF 	=> dummy_mux_inputs_1,
					MCG 	=> dummy_mux_inputs_1,
					MCH 	=> dummy_mux_inputs_1,
					S 	=> xbar_y_temp,
		  			CLK 	=> dummy_in, -- Optional clock
		  			CE 	=> dummy_in,  -- Optional Clock enable
		 			EN 	=> dummy_in,  -- Optional BUFT enable
		  			ASET 	=> dummy_in, -- optional asynch set to '1'
		  			ACLR 	=> dummy_in, -- Asynch init.
		  			AINIT 	=> dummy_in, -- optional asynch reset to init_val
		  			SSET	=> dummy_in, -- optional synch set to '1'
		  			SCLR 	=> dummy_in, -- Synch init.
		  			SINIT	=> dummy_in,	
					O 	=> mem_outi,
					Q 	=> open_q_3);

END GENERATE tms_wkg_mem_gen;

dms_wkg_mem_gen: IF (memory_architecture = 2) GENERATE


usr_loading_addr_temp(0) <= usr_loading_addr;

xn_or_dia_r:	c_mux_bus_v4_0
			GENERIC MAP(	C_WIDTH => B,
					C_INPUTS => 2,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP ( 	MA	=> dia_r,
					MB 	=> xn_re,
					MC 	=> dummy_mux_inputs_1,
					MD 	=> dummy_mux_inputs_1,
					ME 	=> dummy_mux_inputs_1,
					MF 	=> dummy_mux_inputs_1,
					MG 	=> dummy_mux_inputs_1,
					MH 	=> dummy_mux_inputs_1,
					MAA 	=> dummy_mux_inputs_1,
					MAB 	=> dummy_mux_inputs_1,
					MAC 	=> dummy_mux_inputs_1,
					MAD 	=> dummy_mux_inputs_1,
					MAE 	=> dummy_mux_inputs_1,
					MAF 	=> dummy_mux_inputs_1,
					MAG 	=> dummy_mux_inputs_1,
					MAH 	=> dummy_mux_inputs_1,
					MBA 	=> dummy_mux_inputs_1,
					MBB 	=> dummy_mux_inputs_1,
					MBC 	=> dummy_mux_inputs_1,
					MBD 	=> dummy_mux_inputs_1,
					MBE 	=> dummy_mux_inputs_1,
					MBF 	=> dummy_mux_inputs_1,
					MBG 	=> dummy_mux_inputs_1,
					MBH 	=> dummy_mux_inputs_1,
					MCA 	=> dummy_mux_inputs_1,
					MCB 	=> dummy_mux_inputs_1,
					MCC 	=> dummy_mux_inputs_1,
					MCD 	=> dummy_mux_inputs_1,
					MCE 	=> dummy_mux_inputs_1,
					MCF 	=> dummy_mux_inputs_1,
					MCG 	=> dummy_mux_inputs_1,
					MCH 	=> dummy_mux_inputs_1,
					S 	=> usr_loading_addr_temp, --address_select_dms, --usr_loading_addr_temp,
		  			CLK 	=> dummy_in, -- Optional clock
		  			CE 	=> dummy_in,  -- Optional Clock enable
		 			EN 	=> dummy_in,  -- Optional BUFT enable
		  			ASET 	=> dummy_in, -- optional asynch set to '1'
		  			ACLR 	=> dummy_in, -- Asynch init.
		  			AINIT 	=> dummy_in, -- optional asynch reset to init_val
		  			SSET	=> dummy_in, -- optional synch set to '1'
		  			SCLR 	=> dummy_in, -- Synch init.
		  			SINIT	=> dummy_in,	
					O 	=> d_re,
					Q 	=> open_q_re);

xn_or_dia_i:	c_mux_bus_v4_0
			GENERIC MAP(	C_WIDTH => B,
					C_INPUTS => 2,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP ( 	MA	=> dia_i,
					MB 	=> xn_im,
					MC 	=> dummy_mux_inputs_1,
					MD 	=> dummy_mux_inputs_1,
					ME 	=> dummy_mux_inputs_1,
					MF 	=> dummy_mux_inputs_1,
					MG 	=> dummy_mux_inputs_1,
					MH 	=> dummy_mux_inputs_1,
					MAA 	=> dummy_mux_inputs_1,
					MAB 	=> dummy_mux_inputs_1,
					MAC 	=> dummy_mux_inputs_1,
					MAD 	=> dummy_mux_inputs_1,
					MAE 	=> dummy_mux_inputs_1,
					MAF 	=> dummy_mux_inputs_1,
					MAG 	=> dummy_mux_inputs_1,
					MAH 	=> dummy_mux_inputs_1,
					MBA 	=> dummy_mux_inputs_1,
					MBB 	=> dummy_mux_inputs_1,
					MBC 	=> dummy_mux_inputs_1,
					MBD 	=> dummy_mux_inputs_1,
					MBE 	=> dummy_mux_inputs_1,
					MBF 	=> dummy_mux_inputs_1,
					MBG 	=> dummy_mux_inputs_1,
					MBH 	=> dummy_mux_inputs_1,
					MCA 	=> dummy_mux_inputs_1,
					MCB 	=> dummy_mux_inputs_1,
					MCC 	=> dummy_mux_inputs_1,
					MCD 	=> dummy_mux_inputs_1,
					MCE 	=> dummy_mux_inputs_1,
					MCF 	=> dummy_mux_inputs_1,
					MCG 	=> dummy_mux_inputs_1,
					MCH 	=> dummy_mux_inputs_1,
					S 	=> usr_loading_addr_temp, --address_select_dms, --usr_loading_addr_temp, 
		  			CLK 	=> dummy_in, -- Optional clock
		  			CE 	=> dummy_in,  -- Optional Clock enable
		 			EN 	=> dummy_in,  -- Optional BUFT enable
		  			ASET 	=> dummy_in, -- optional asynch set to '1'
		  			ACLR 	=> dummy_in, -- Asynch init.
		  			AINIT 	=> dummy_in, -- optional asynch reset to init_val
		  			SSET	=> dummy_in, -- optional synch set to '1'
		  			SCLR 	=> dummy_in, -- Synch init.
		  			SINIT	=> dummy_in,	
					O 	=> d_im,
					Q 	=> open_q_im);

dmem_gen: IF (data_memory="distributed_mem") GENERATE
dmem_x_re_imag: dmem_wkg_r_i_v3
	GENERIC MAP (B => B,
		POINTS_POWER => points_power)
	PORT MAP (	a	=> addra_dmem,
		we => we_dmem_dms,
		d_re => d_re,
		d_im => d_im,
		clk => clk,
		dpra => addrb_dmem_dms,
		qdpo_re => mem_outr,
		qdpo_im => mem_outi);
END GENERATE dmem_gen;

bmem_gen: IF (data_memory="block_mem") GENERATE
mem_x_re_imag: mem_wkg_r_i_v3
	GENERIC MAP (B => B,
		POINTS_POWER => points_power)
	PORT MAP (	addra	=> addra_dmem, --addra,
		wea	=> we_dmem_dms, --wea_x,
		ena	=> logic_1, --ena_x,
		dia_r	=> d_re, --dia_r,
		dia_i	=> d_im, --dia_i,
		reset	=> reset,
		clk	=> clk,
		addrb	=> addrb_dmem_dms, --addrb_x,
		web	=> logic_0, --web_x,
		enb	=> logic_1,
		dib_r	=> open_dib_r, --xn_re,
		dib_i	=> open_dib_i, --xn_im,
		dob_r	=> mem_outr, --x_to_bfly_r,
		dob_i	=> mem_outi); --x_to_bfly_i);

--mem_outr <= x_to_bfly_r;
--mem_outi <= x_to_bfly_i;
END GENERATE bmem_gen;
END GENERATE dms_wkg_mem_gen;

END behavioral;

-------------------------------END working_memory_v3-------------------------------------

---------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
---------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.prims_constants_v4_0.all;
USE XilinxCoreLib.C_REG_FD_V4_0_comp.all;
USE XilinxCoreLib.C_TWOS_COMP_V4_0_comp.all;
USE XilinxCoreLib.C_MUX_BUS_V4_0_comp.all;
USE XilinxCoreLib.C_COMPARE_V4_0_comp.all;
USE XilinxCoreLib.vfft32_comps_v3.all;
USE XilinxCoreLib.vfft32_pkg_v3.all;


ENTITY conj_reg_v3 IS
	GENERIC ( B	: INTEGER := 16);  --input data precision
	PORT (clk	: IN STD_LOGIC;
		ce	: IN STD_LOGIC;
		fwd_inv	: IN STD_LOGIC;  -- conjugation control
		dr	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);  --Re input
		di	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);  --Im input
		qr	: OUT STD_LOGIC_VECTOR(B-1  DOWNTO 0);  --Re result
		qi	: OUT STD_LOGIC_VECTOR(B-1  DOWNTO 0));  --Im result
END conj_reg_v3;


ARCHITECTURE behavioral OF conj_reg_v3 IS

SIGNAL dummy_in : STD_LOGIC:= '0';
SIGNAL open_s:	STD_LOGIC_VECTOR(B DOWNTO 0);
SIGNAL qi_internal: STD_LOGIC_VECTOR(B DOWNTO 0);
SIGNAL qr_int : STD_LOGIC_VECTOR(B-1 DOWNTO 0);

SIGNAL compare_signal : STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL aneb	: STD_LOGIC;
SIGNAL altb	: STD_LOGIC;
SIGNAL agtb	: STD_LOGIC;
SIGNAL aleb	: STD_LOGIC;
SIGNAL ageb	: STD_LOGIC;
SIGNAL qaeqb	: STD_LOGIC;
SIGNAL qaneb	: STD_LOGIC;
SIGNAL qaltb	: STD_LOGIC;
SIGNAL qagtb	: STD_LOGIC;
SIGNAL qaleb	: STD_LOGIC;
SIGNAL qageb	: STD_LOGIC;

SIGNAL conj	: STD_LOGIC;

SIGNAL const_signal : STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL mux_select   : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL mux_select_int : STD_LOGIC;
SIGNAL di_eq_comp : STD_LOGIC;
SIGNAL di_eq_comp_reg : STD_LOGIC;
SIGNAL dummy_mux_inputs	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
--SIGNAL open_q: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL open_o: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
 
BEGIN

dummy_in <= '0';

compare_signal(B-1) <= '1';
compare_signal(B-2 DOWNTO 0) <= (OTHERS => '0');

const_signal(B-1) <= '0';
const_signal(B-2 DOWNTO 0) <= (OTHERS => '1');

mux_select(0) <= mux_select_int;

conj_gen: nand_a_b_32_v3 PORT MAP (a_in => fwd_inv,
			b_in => fwd_inv,
			nand_out => conj);

-- Register the real component of complex sample

reg_real:	C_REG_FD_V4_0 
		GENERIC MAP (C_WIDTH => B,
				C_HAS_CE => 1,
				C_HAS_ACLR => 0,
				C_HAS_ASET => 0,
				C_HAS_AINIT => 0,
				C_HAS_SCLR => 0,
				C_HAS_SSET => 0,
				C_HAS_SINIT => 0,
				C_ENABLE_RLOCS  => 1)
		PORT MAP 	(D => dr,
			  	CLK => clk,
			  	CE => ce,
			  	ACLR => dummy_in, 
			  	ASET => dummy_in,
			  	AINIT => dummy_in, 
			  	SCLR => dummy_in,
			  	SSET => dummy_in,
			  	SINIT => dummy_in,
			  	Q => qr_int);

reg_real_z:	C_REG_FD_V4_0 
		GENERIC MAP (C_WIDTH => B,
				C_HAS_CE => 1,
				C_HAS_ACLR => 0,
				C_HAS_ASET => 0,
				C_HAS_AINIT => 0,
				C_HAS_SCLR => 0,
				C_HAS_SSET => 0,
				C_HAS_SINIT => 0,
				C_ENABLE_RLOCS  => 1)
		PORT MAP 	(D => qr_int,
			  	CLK => clk,
			  	CE => ce,
			  	ACLR => dummy_in, 
			  	ASET => dummy_in,
			  	AINIT => dummy_in, 
			  	SCLR => dummy_in,
			  	SSET => dummy_in,
			  	SINIT => dummy_in,
			  	Q => qr);

twos_comp_imag: c_twos_comp_v4_0 
			GENERIC MAP (C_WIDTH  => B,
				C_AINIT_VAL => "0", 		
				C_BYPASS_LOW => 1, --bypass when low and 2's comp when high??
				C_PIPE_STAGES=> 1, 
				C_HAS_BYPASS => 1,
				C_BYPASS_ENABLE => c_no_override, 
				C_HAS_CE => 1,
				C_HAS_Q => 1,
				C_ENABLE_RLOCS  => 1)
			PORT MAP (A => di,
				BYPASS => conj,
				CLK => clk,
				ce => ce,
				ACLR => dummy_in,
				ASET => dummy_in,
				AINIT => dummy_in,
				SCLR => dummy_in,
				SSET => dummy_in,
				SINIT => dummy_in,
				S => open_s,
				Q => qi_internal);

compare_im_constant:	C_COMPARE_V4_0 GENERIC MAP(C_WIDTH =>B,
						C_B_CONSTANT => 0,
						C_DATA_TYPE => c_signed,
						--C_B_VALUE => eight_msb,
						C_HAS_A_EQ_B => 1)
				PORT MAP (A=> di,
					B => compare_signal,
					CLK => clk,
					A_EQ_B => di_eq_comp,
					A_NE_B => aneb,
					A_LT_B => altb,	
					A_GT_B => agtb,	
					A_LE_B => aleb,	
					A_GE_B => ageb,	
					QA_EQ_B => qaeqb,  	
					QA_NE_B => qaneb,	
					QA_LT_B => qaltb,	
					QA_GT_B => qagtb,	
					QA_LE_B => qaleb,	
					QA_GE_B => qageb	
					);
diregpr: process (clk)
begin
if clk'event and clk='1' then
di_eq_comp_reg <= di_eq_comp;
end if;
end process;

fwd_inv_qualify: and_a_notb_32_v3 PORT MAP (a_in => di_eq_comp_reg,
					b_in => fwd_inv,
					and_out => mux_select_int);
const_q_int_mux_reg: c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH => B,
					C_INPUTS => 2,
					C_HAS_O =>  0,
					C_HAS_Q =>  1,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP (MA	=> qi_internal(B-1 DOWNTO 0),
				MB 	=> const_signal,
				MC 	=> dummy_mux_inputs,
				MD 	=> dummy_mux_inputs,
				ME 	=> dummy_mux_inputs,
				MF	=> dummy_mux_inputs,
				MG 	=> dummy_mux_inputs,
				MH 	=> dummy_mux_inputs,
					MAA 	=> dummy_mux_inputs,
					MAB 	=> dummy_mux_inputs,
					MAC 	=> dummy_mux_inputs,
					MAD 	=> dummy_mux_inputs,
					MAE 	=> dummy_mux_inputs,
					MAF 	=> dummy_mux_inputs,
					MAG 	=> dummy_mux_inputs,
					MAH 	=> dummy_mux_inputs,
					MBA 	=> dummy_mux_inputs,
					MBB 	=> dummy_mux_inputs,
					MBC 	=> dummy_mux_inputs,
					MBD 	=> dummy_mux_inputs,
					MBE 	=> dummy_mux_inputs,
					MBF 	=> dummy_mux_inputs,
					MBG 	=> dummy_mux_inputs,
					MBH 	=> dummy_mux_inputs,
					MCA 	=> dummy_mux_inputs,
					MCB 	=> dummy_mux_inputs,
					MCC 	=> dummy_mux_inputs,
					MCD 	=> dummy_mux_inputs,
					MCE 	=> dummy_mux_inputs,
					MCF 	=> dummy_mux_inputs,
					MCG 	=> dummy_mux_inputs,
					MCH 	=> dummy_mux_inputs,
				S 	=> mux_select,
		  		CLK 	=> clk, --dummy_in, 
				O	=>  open_o, --qi,
				Q 	=>  qi); --open_q);
END behavioral;

-------------------------------------END conj_reg_v3-------------------------------------------

--------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
--------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
--USE ieee.std_logic_arith.all;
		
LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_MUX_BUS_V4_0_comp.all;
USE XilinxCoreLib.C_REG_FD_V4_0_comp.all;
USE XilinxCoreLib.prims_constants_v4_0.all;
USE XilinxCoreLib.C_COUNTER_BINARY_V4_0_comp.all;
USE XilinxCoreLib.vfft32_comps_v3.all;



ENTITY input_working_result_memory_v3 IS
	GENERIC (B		: INTEGER;
		POINTS_POWER	: INTEGER := 5;
		result_width	: INTEGER :=5;
		data_memory	: STRING :="distributed_memory");
	PORT (	clk	: IN STD_LOGIC;
		reset	: IN STD_LOGIC;
		ce	: IN STD_LOGIC;
		fwd_inv : IN STD_LOGIC;
		dia_r	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0); --intermediate result
		dia_i	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0); --intermediate result
		xn_re	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0); --xn input (ext)
		xn_im	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0); --xn input (ext)
		ena	: IN STD_LOGIC;
		wea	: IN STD_LOGIC;
		addra	: IN STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		addra_dmem	: IN STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		xn_r	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0); 
		xn_i	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0); 
		data_sel	: IN STD_LOGIC_VECTOR(1 DOWNTO 0); 
		--xk_result_re	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);--result from fft4 
		--xk_result_im	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);--result from fft4 
		y0r	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);--result from fft4
		y0i	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);--result from fft4
		y1r	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);--result from fft4
		y1i	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);--result from fft4
		y2r	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);--result from fft4
		y2i	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);--result from fft4
		y3r	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);--result from fft4
		y3i	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);--result from fft4
		we_dmem : IN STD_LOGIC;
		web	: IN STD_LOGIC;
		addrb	: IN STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		addrb_dmem	: IN STD_LOGIC_VECTOR(POINTS_POWER -1 DOWNTO 0);
		result_avail : IN STD_LOGIC;	--from bfly_buf_fft pulse
		reading_result	: IN STD_LOGIC;
		writing_result : IN STD_LOGIC;
		mem_outr: OUT STD_LOGIC_VECTOR(B-1 DOWNTO 0); -- to bfly_fft proc. re
		mem_outi: OUT STD_LOGIC_VECTOR(B-1 DOWNTO 0);-- to bfly_fft proc. im
		xk_result_out_re : OUT STD_LOGIC_VECTOR(B-1 DOWNTO 0);  --result_read_out re
		xk_result_out_im : OUT STD_LOGIC_VECTOR(B-1 DOWNTO 0));--result_read_out im
END input_working_result_memory_v3;

ARCHITECTURE behavioral of input_working_result_memory_v3 IS

SIGNAL dummy_mux_inputs	: STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL dummy_mux_inputs_1	: STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL open_q_r	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL open_q_i	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL open_qr	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL open_qi	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL dib_r	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL dib_i	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL logic_1 : STD_LOGIC := '1';
SIGNAL logic_0 : STD_LOGIC := '0';
SIGNAL dummy_in : STD_LOGIC:= '0';

SIGNAL writing_result_temp :STD_LOGIC_VECTOR(0 DOWNTO 0):= (OTHERS => '0'); 
SIGNAL mem_outr_int	: STD_LOGIC_VECTOR(B-1 DOWNTO 0):= (OTHERS => '0');
SIGNAL mem_outi_int	: STD_LOGIC_VECTOR(B-1 DOWNTO 0):= (OTHERS => '0');

SIGNAL y0r_delayed	: STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL y0i_delayed	: STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL y1r_delayed	: STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL y1i_delayed	: STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL y2r_delayed	: STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL y2i_delayed	: STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL y3r_delayed	: STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL y3i_delayed	: STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);

SIGNAL writing_result_delayed_internal : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL result_avail_delayed_internal : STD_LOGIC_VECTOR(0 DOWNTO 0);

SIGNAL writing_result_internal : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL result_avail_internal : STD_LOGIC_VECTOR(0 DOWNTO 0);


SIGNAL writing_result_delayed_int : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL result_avail_delayed_int : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL result_avail_delayed: STD_LOGIC; 

SIGNAL dummy_addr : STD_LOGIC_VECTOR(0 DOWNTO 0) := (OTHERS => '0');

SIGNAL fft4_result_re : STD_LOGIC_VECTOR(result_width-1 DOWNTO 0); 
SIGNAL fft4_result_im : STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL fft4_result_re_preconj: STD_LOGIC_VECTOR(result_width-1 DOWNTO 0); 
SIGNAL fft4_result_im_preconj: STD_LOGIC_VECTOR(result_width-1 DOWNTO 0); 

SIGNAL open_thresh0 : STD_LOGIC; --for xcc	:= '0';
SIGNAL open_q_thresh0 : STD_LOGIC; --for xcc	:= '0';
SIGNAL open_thresh1 : STD_LOGIC; --for xcc	:= '0';
SIGNAL open_q_thresh1 : STD_LOGIC; --for xcc	:= '0';

SIGNAL d_select : STD_LOGIC_VECTOR(1 DOWNTO 0):= (OTHERS => '0');
SIGNAL open_q_r_1 : STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL open_q_i_1 : STD_LOGIC_VECTOR(B-1 DOWNTO 0);

CONSTANT default_data : STRING(result_width DOWNTO 1):=(OTHERS => '0');
CONSTANT one_string : STRING (2 DOWNTO 1) := "01";
CONSTANT three	: STRING(2 DOWNTO 1) := "11";
CONSTANT ainit_val	: STRING(2 DOWNTO 1) := "00";
CONSTANT sinit_val	: STRING(2 DOWNTO 1) := "00";

SIGNAL one_1: STD_LOGIC_VECTOR(points_power-1 DOWNTO 0) := "00001";
SIGNAL zero_1: STD_LOGIC_VECTOR(points_power-1 DOWNTO 0) := "00000";
SIGNAL zero : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
SIGNAL one : STD_LOGIC_VECTOR(1 DOWNTO 0) := "01";

SIGNAL fft4_result_re_z: STD_LOGIC_VECTOR(B-1 DOWNTO 0):= (OTHERS => '0');
SIGNAL fft4_result_im_z: STD_LOGIC_VECTOR(B-1 DOWNTO 0):= (OTHERS => '0');

SIGNAL xk_result_out_re_temp : STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL xk_result_out_im_temp : STD_LOGIC_VECTOR(B-1 DOWNTO 0);

SIGNAL d_re : STD_LOGIC_VECTOR(B-1 DOWNTO 0):= (OTHERS => '0');
SIGNAL d_im : STD_LOGIC_VECTOR(B-1 DOWNTO 0):= (OTHERS => '0');

SIGNAL open_mux_qr : STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL open_mux_qi : STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);

SIGNAL open_dib_r : STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL open_dib_i : STD_LOGIC_VECTOR(B-1 DOWNTO 0);

BEGIN

logic_1 <= '1';
logic_0 <= '0';
dummy_in <= '0';
writing_result_temp(0) <= writing_result; --writing_result_delayed_int(0);
result_avail_delayed <= result_avail_delayed_int(0);

writing_result_internal(0) <= writing_result;
result_avail_internal(0) <= result_avail;
 
mem_outr <= mem_outr_int;
mem_outi <= mem_outi_int;
zero <= (OTHERS => '0');
zero_1 <= (OTHERS => '0');
one(0) <= '1';
one(1) <= '0';
one_1(0) <= '1';
one_1(1) <= '0';
one_1(2) <= '0';
one_1(3) <= '0';
one_1(4) <= '0';

--------------------------------------
--- Lining up the results from fft4 --
--------------------------------------
delay_y0r_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH =>2, --66, -- vk oct 26, -- vk spet15 64, --32,
					DATA_WIDTH => result_width)
				PORT MAP (addr => dummy_addr,
					data =>y0r,
					clk => clk,
					reset => reset,
					start => dummy_in,
					delayed_data => y0r_delayed);
delay_y0i_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH =>2, --66, -- vk oct 26, -- vk spet1564, --32,
					DATA_WIDTH => result_width)
				PORT MAP (addr => dummy_addr,
					data =>y0i,
					clk => clk,
					reset => reset,
					start => dummy_in,
					delayed_data => y0i_delayed);

delay_y1r_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH =>2, --66, --vk oct 26 64, --32,
					DATA_WIDTH => result_width)
				PORT MAP (addr => dummy_addr,
					data =>y1r,
					clk => clk,
					reset => reset,
					start => dummy_in,
					delayed_data => y1r_delayed);
delay_y1i_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH =>2, --66, --vk oct 26 64, --32,
					DATA_WIDTH => result_width)
				PORT MAP (addr => dummy_addr,
					data =>y1i,
					clk => clk,
					reset => reset,
					start => dummy_in,
					delayed_data => y1i_delayed);

delay_y2r_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH =>4, --68, --66, -- vk spet1566, --34, --2,
					DATA_WIDTH => result_width)
				PORT MAP (addr => dummy_addr,
					data =>y2r,
					clk => clk,
					reset => reset,
					start => dummy_in,
					delayed_data => y2r_delayed);
delay_y2i_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH =>4, --68, --66, -- vk spet1566, --34, --2,
					DATA_WIDTH => result_width)
				PORT MAP (addr => dummy_addr,
					data =>y2i,
					clk => clk,
					reset => reset,
					start => dummy_in,
					delayed_data => y2i_delayed);

delay_y3r_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH =>4, --68, --vk oct 26 66, --34, --2,
					DATA_WIDTH => result_width)
				PORT MAP (addr => dummy_addr,
					data =>y3r,
					clk => clk,
					reset => reset,
					start => dummy_in,
					delayed_data => y3r_delayed);
delay_y3i_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH =>4, --68, --vk oct 26 66, --34, --2,
					DATA_WIDTH => result_width)
				PORT MAP (addr => dummy_addr,
					data =>y3i,
					clk => clk,
					reset => reset,
					start => dummy_in,
					delayed_data => y3i_delayed);

----------------------------------------
-- Mux fft4 results out one at a time --
----------------------------------------
mux_y0_y3r :  c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH => result_width,
					C_INPUTS => 4,
					C_SEL_WIDTH => 2,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP ( MA  	=> y0r_delayed,
					MB 	=> y1r_delayed,
					MC 	=> y2r_delayed,
					MD 	=> y3r_delayed,
					ME 	=> dummy_mux_inputs,
					MF 	=> dummy_mux_inputs,
					MG 	=> dummy_mux_inputs,
					MH 	=> dummy_mux_inputs,
					MAA 	=> dummy_mux_inputs_1,
					MAB 	=> dummy_mux_inputs_1,
					MAC 	=> dummy_mux_inputs_1,
					MAD 	=> dummy_mux_inputs_1,
					MAE 	=> dummy_mux_inputs_1,
					MAF 	=> dummy_mux_inputs_1,
					MAG 	=> dummy_mux_inputs_1,
					MAH 	=> dummy_mux_inputs_1,
					MBA 	=> dummy_mux_inputs_1,
					MBB 	=> dummy_mux_inputs_1,
					MBC 	=> dummy_mux_inputs_1,
					MBD 	=> dummy_mux_inputs_1,
					MBE 	=> dummy_mux_inputs_1,
					MBF 	=> dummy_mux_inputs_1,
					MBG 	=> dummy_mux_inputs_1,
					MBH 	=> dummy_mux_inputs_1,
					MCA 	=> dummy_mux_inputs_1,
					MCB 	=> dummy_mux_inputs_1,
					MCC 	=> dummy_mux_inputs_1,
					MCD 	=> dummy_mux_inputs_1,
					MCE 	=> dummy_mux_inputs_1,
					MCF 	=> dummy_mux_inputs_1,
					MCG 	=> dummy_mux_inputs_1,
					MCH 	=> dummy_mux_inputs_1,
					S 	=> d_select,
		  			CLK 	=>dummy_in, 
		  			CE 	=>dummy_in,  
		  			EN 	=>dummy_in,  
		  			ASET 	=>dummy_in, 
		  			ACLR 	=>dummy_in, 
		  			AINIT 	=>dummy_in, 
		  			SSET	=>dummy_in, 
		  			SCLR 	=>dummy_in, 
		  			SINIT	=>dummy_in,	
					O => fft4_result_re_preconj,
					Q => open_qr);
mux_y0_y3i :  c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH => result_width,
					C_INPUTS => 4,
					C_SEL_WIDTH => 2,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP ( MA  	=> y0i_delayed,
					MB 	=> y1i_delayed,
					MC 	=> y2i_delayed,
					MD 	=> y3i_delayed,
					ME 	=> dummy_mux_inputs,
					MF 	=> dummy_mux_inputs,
					MG 	=> dummy_mux_inputs,
					MH 	=> dummy_mux_inputs,
					MAA 	=> dummy_mux_inputs_1,
					MAB 	=> dummy_mux_inputs_1,
					MAC 	=> dummy_mux_inputs_1,
					MAD 	=> dummy_mux_inputs_1,
					MAE 	=> dummy_mux_inputs_1,
					MAF 	=> dummy_mux_inputs_1,
					MAG 	=> dummy_mux_inputs_1,
					MAH 	=> dummy_mux_inputs_1,
					MBA 	=> dummy_mux_inputs_1,
					MBB 	=> dummy_mux_inputs_1,
					MBC 	=> dummy_mux_inputs_1,
					MBD 	=> dummy_mux_inputs_1,
					MBE 	=> dummy_mux_inputs_1,
					MBF 	=> dummy_mux_inputs_1,
					MBG 	=> dummy_mux_inputs_1,
					MBH 	=> dummy_mux_inputs_1,
					MCA 	=> dummy_mux_inputs_1,
					MCB 	=> dummy_mux_inputs_1,
					MCC 	=> dummy_mux_inputs_1,
					MCD 	=> dummy_mux_inputs_1,
					MCE 	=> dummy_mux_inputs_1,
					MCF 	=> dummy_mux_inputs_1,
					MCG 	=> dummy_mux_inputs_1,
					MCH 	=> dummy_mux_inputs_1,
					S 	=> d_select,
		  			CLK 	=>dummy_in, 
		  			CE 	=>dummy_in,  
		  			EN 	=>dummy_in,  
		  			ASET 	=>dummy_in, 
		  			ACLR 	=>dummy_in, 
		  			AINIT 	=>dummy_in, 
		  			SSET	=>dummy_in, 
		  			SCLR 	=>dummy_in, 
		  			SINIT	=>dummy_in,	
					O => fft4_result_im_preconj,
					Q => open_qi);

d_select_gen: C_COUNTER_BINARY_V4_0
		GENERIC MAP (	C_WIDTH		=> 2,
				C_OUT_TYPE	=> 1,
				C_COUNT_BY	=> one_string,
				--C_COUNT_TO	=> two,
				C_THRESH0_VALUE => three,
				C_AINIT_VAL	=> ainit_val,
				C_SINIT_VAL	=> sinit_val,
				C_LOAD_ENABLE 	=> c_no_override,
				C_SYNC_ENABLE	=>  c_no_override,
				C_HAS_THRESH0	=>  0, 
				C_HAS_Q_THRESH0	=>  0,
				C_HAS_CE	=> 1,
				C_HAS_IV	=> 1,
				C_HAS_SCLR	=> 0,
				C_HAS_SINIT 	=> 1,
				C_HAS_AINIT 	=> 1)
		PORT MAP (CLK => clk,
			  UP => logic_1,
			  CE => ce,
			  LOAD => dummy_in,
			  L => zero,
			  IV => one,
			  ACLR => dummy_in,
			  ASET => dummy_in,
			  AINIT => reset,
			  SCLR => dummy_in,
			  SINIT => result_avail, --_delayed, 
			  SSET => dummy_in,
			  THRESH0 => open_thresh0, 
			  Q_THRESH0 => open_q_thresh0,   
		  	  THRESH1 => open_thresh1,  
		  	  Q_THRESH1 => open_q_thresh1,
			  Q => d_select);


--insert conj_reg_v3 here

conj_res_mem_inputs: conj_reg_v3 GENERIC MAP (B => result_width)
				PORT MAP (clk => clk,
						ce => ce,
						fwd_inv => fwd_inv,
						dr => fft4_result_re_preconj,
						di => fft4_result_im_preconj,
						qr => fft4_result_re,
						qi => fft4_result_im);

--dmem_gen: IF (data_memory="distributed_mem") GENERATE
-----------------------------------------------------------------------
-- mux fft_result_re, xn_re, an dia_r. output connected to d_re of dmem
-----------------------------------------------------------------------
mux_fftres_xn_diar :  c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH => result_width,
					C_INPUTS => 3,
					C_SEL_WIDTH => 2,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP ( MA  	=> dia_r,
					MB 	=> xn_re,
					MC 	=> fft4_result_re_z,
					MD 	=> dummy_mux_inputs,
					ME 	=> dummy_mux_inputs,
					MF 	=> dummy_mux_inputs,
					MG 	=> dummy_mux_inputs,
					MH 	=> dummy_mux_inputs,
					MAA 	=> dummy_mux_inputs_1,
					MAB 	=> dummy_mux_inputs_1,
					MAC 	=> dummy_mux_inputs_1,
					MAD 	=> dummy_mux_inputs_1,
					MAE 	=> dummy_mux_inputs_1,
					MAF 	=> dummy_mux_inputs_1,
					MAG 	=> dummy_mux_inputs_1,
					MAH 	=> dummy_mux_inputs_1,
					MBA 	=> dummy_mux_inputs_1,
					MBB 	=> dummy_mux_inputs_1,
					MBC 	=> dummy_mux_inputs_1,
					MBD 	=> dummy_mux_inputs_1,
					MBE 	=> dummy_mux_inputs_1,
					MBF 	=> dummy_mux_inputs_1,
					MBG 	=> dummy_mux_inputs_1,
					MBH 	=> dummy_mux_inputs_1,
					MCA 	=> dummy_mux_inputs_1,
					MCB 	=> dummy_mux_inputs_1,
					MCC 	=> dummy_mux_inputs_1,
					MCD 	=> dummy_mux_inputs_1,
					MCE 	=> dummy_mux_inputs_1,
					MCF 	=> dummy_mux_inputs_1,
					MCG 	=> dummy_mux_inputs_1,
					MCH 	=> dummy_mux_inputs_1,
					S 	=> data_sel,
		  			CLK 	=>dummy_in, 
		  			CE 	=>dummy_in,  
		  			EN 	=>dummy_in,  
		  			ASET 	=>dummy_in, 
		  			ACLR 	=>dummy_in, 
		  			AINIT 	=>dummy_in, 
		  			SSET	=>dummy_in, 
		  			SCLR 	=>dummy_in, 
		  			SINIT	=>dummy_in,	
					O => d_re,
					Q => open_mux_qr);
-----------------------------------------------------------------------
-- mux fft_result_im, xn_im, an dia_i. output connected to d_im of dmem
-----------------------------------------------------------------------
mux_fftres_xn_diai :  c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH => result_width,
					C_INPUTS => 3,
					C_SEL_WIDTH => 2,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP ( MA  	=> dia_i,
					MB 	=> xn_im,
					MC 	=> fft4_result_im_z,
					MD 	=> dummy_mux_inputs,
					ME 	=> dummy_mux_inputs,
					MF 	=> dummy_mux_inputs,
					MG 	=> dummy_mux_inputs,
					MH 	=> dummy_mux_inputs,
					MAA 	=> dummy_mux_inputs_1,
					MAB 	=> dummy_mux_inputs_1,
					MAC 	=> dummy_mux_inputs_1,
					MAD 	=> dummy_mux_inputs_1,
					MAE 	=> dummy_mux_inputs_1,
					MAF 	=> dummy_mux_inputs_1,
					MAG 	=> dummy_mux_inputs_1,
					MAH 	=> dummy_mux_inputs_1,
					MBA 	=> dummy_mux_inputs_1,
					MBB 	=> dummy_mux_inputs_1,
					MBC 	=> dummy_mux_inputs_1,
					MBD 	=> dummy_mux_inputs_1,
					MBE 	=> dummy_mux_inputs_1,
					MBF 	=> dummy_mux_inputs_1,
					MBG 	=> dummy_mux_inputs_1,
					MBH 	=> dummy_mux_inputs_1,
					MCA 	=> dummy_mux_inputs_1,
					MCB 	=> dummy_mux_inputs_1,
					MCC 	=> dummy_mux_inputs_1,
					MCD 	=> dummy_mux_inputs_1,
					MCE 	=> dummy_mux_inputs_1,
					MCF 	=> dummy_mux_inputs_1,
					MCG 	=> dummy_mux_inputs_1,
					MCH 	=> dummy_mux_inputs_1,
					S 	=> data_sel,
		  			CLK 	=>dummy_in, 
		  			CE 	=>dummy_in,  
		  			EN 	=>dummy_in,  
		  			ASET 	=>dummy_in, 
		  			ACLR 	=>dummy_in, 
		  			AINIT 	=>dummy_in, 
		  			SSET	=>dummy_in, 
		  			SCLR 	=>dummy_in, 
		  			SINIT	=>dummy_in,	
					O => d_im,
					Q => open_mux_qi);
 
--------------------------------------
-- Distributed memory		    --
--------------------------------------
dmem_gen: IF (data_memory="distributed_mem") GENERATE

--we_dmem <= wea or user_loading_addr or writing_result;

dmem_re_im : dmem_wkg_r_i_v3
	GENERIC MAP (B => B,
		POINTS_POWER => points_power)
	PORT MAP (a => addra_dmem,
		we => we_dmem,
		d_re => d_re,
		d_im => d_im,
		clk => clk,
		dpra => addrb_dmem,
		qdpo_re => mem_outr_int,
		qdpo_im => mem_outi_int);
END GENERATE dmem_gen;

--------------------------------------
-- Block  memory		    --
--------------------------------------

bmem_gen: IF (data_memory="block_mem") GENERATE
bmem_re_imag: mem_wkg_r_i_v3
	GENERIC MAP (B => B,
		POINTS_POWER => points_power)
	PORT MAP (	addra	=> addra_dmem,
		wea	=> we_dmem,
		ena	=> logic_1, --ena,
		dia_r	=> d_re, --dia_r,
		dia_i	=> d_im, --dia_i,
		reset	=> reset,
		clk	=> clk,
		addrb	=> addrb_dmem, --addrb,
		web	=> logic_0, --web,
		enb	=> logic_1,
		dib_r	=> open_dib_r, --dib_r,
		dib_i	=> open_dib_i, --dib_i,
		dob_r	=> mem_outr_int,
		dob_i	=> mem_outi_int);
END GENERATE bmem_gen;



result_gen_re: c_reg_fd_v4_0 GENERIC MAP 
			(C_WIDTH => B,
			C_AINIT_VAL => "0",
			--C_SINIT_VAL => "",
			--C_SYNC_PRIORITY => "c_clear",
			--C_SYNC_ENABLE => "c_override",
			C_HAS_CE => 1,
			C_HAS_ACLR =>0, 
			C_HAS_ASET => 0,
			C_HAS_AINIT => 1, 
			C_HAS_SCLR => 0,
			C_HAS_SSET => 0,
			C_HAS_SINIT => 0,
			C_ENABLE_RLOCS  => 1)
		PORT MAP (D=> mem_outr_int,
			  CLK => clk,
			  CE => reading_result,
			  ACLR => dummy_in, --was reset,
			  ASET => dummy_in,
			  AINIT => reset, --was nc,
			  SCLR => dummy_in,
			  SSET => dummy_in,
			  SINIT => dummy_in,
			  Q => xk_result_out_re_temp); --xk_result_out_re);--xk_result_out_re_temp);
xk_result_out_re<= mem_outr_int ;
xk_result_out_im <= mem_outi_int ;

result_gen_im: c_reg_fd_v4_0 GENERIC MAP 
			(C_WIDTH => B,
			C_AINIT_VAL => "0",
			--C_SINIT_VAL => "",
			--C_SYNC_PRIORITY => "c_clear",
			--C_SYNC_ENABLE => "c_override",
			C_HAS_CE => 1,
			C_HAS_ACLR =>0, 
			C_HAS_ASET => 0,
			C_HAS_AINIT => 1, 
			C_HAS_SCLR => 0,
			C_HAS_SSET => 0,
			C_HAS_SINIT => 0,
			C_ENABLE_RLOCS  => 1)
		PORT MAP (D=> mem_outi_int,
			  CLK => clk,
			  CE => reading_result,
			  ACLR => dummy_in, --was reset,
			  ASET => dummy_in,
			  AINIT => reset, --was nc,
			  SCLR => dummy_in,
			  SSET => dummy_in,
			  SINIT => dummy_in,
			  Q =>xk_result_out_im_temp); --xk_result_out_im ); --xk_result_out_im_temp);

fft4_result_re_z_gen: c_reg_fd_v4_0 GENERIC MAP 
			(C_WIDTH => B,
			C_AINIT_VAL => "0",
			--C_SINIT_VAL => "",
			--C_SYNC_PRIORITY => "c_clear",
			--C_SYNC_ENABLE => "c_override",
			C_HAS_CE => 1,
			C_HAS_ACLR =>0, 
			C_HAS_ASET => 0,
			C_HAS_AINIT => 1, 
			C_HAS_SCLR => 0,
			C_HAS_SSET => 0,
			C_HAS_SINIT => 0,
			C_ENABLE_RLOCS  => 1)
		PORT MAP (D=> fft4_result_re,
			  CLK => clk,
			  CE => ce,
			  ACLR => dummy_in, --was reset,
			  ASET => dummy_in,
			  AINIT => reset, --was nc,
			  SCLR => dummy_in,
			  SSET => dummy_in,
			  SINIT => dummy_in,
			  Q =>fft4_result_re_z);


fft4_result_im_z_gen: c_reg_fd_v4_0 GENERIC MAP 
			(C_WIDTH => B,
			C_AINIT_VAL => "0",
			--C_SINIT_VAL => "",
			--C_SYNC_PRIORITY => "c_clear",
			--C_SYNC_ENABLE => "c_override",
			C_HAS_CE => 1,
			C_HAS_ACLR =>0, 
			C_HAS_ASET => 0,
			C_HAS_AINIT => 1, 
			C_HAS_SCLR => 0,
			C_HAS_SSET => 0,
			C_HAS_SINIT => 0,
			C_ENABLE_RLOCS  => 1)
		PORT MAP (D=> fft4_result_im,
			  CLK => clk,
			  CE => ce,
			  ACLR => dummy_in, --was reset,
			  ASET => dummy_in,
			  AINIT => reset, --was nc,
			  SCLR => dummy_in,
			  SSET => dummy_in,
			  SINIT => dummy_in,
			  Q =>fft4_result_im_z);


delay_result_avail_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH =>32, -- vk oct 26
					DATA_WIDTH => 1)
				PORT MAP (addr => dummy_addr,
					data =>result_avail_internal,
					clk => clk,
					reset => reset,
					start => dummy_in,
					delayed_data => result_avail_delayed_int);
delay_writing_result : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH =>32 , --(31=vk oct 26)
					DATA_WIDTH => 1)
				PORT MAP (addr => dummy_addr,
					data =>writing_result_internal,
					clk => clk,
					reset => reset,
					start => dummy_in,
					delayed_data => writing_result_delayed_int);

END behavioral;


----------------------------------END input_working_result_memory----------------------------

--------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
--------------------------------------------------------------------------
-- Last modified on 03/06/00
-- Name : complex_mult_v3.vhd
-- Function : This contains one complex multiplier.
-- This module implements a a_width x b_width bit complex multiplier.
-- A B-bit complex number is returned, again 
-- B bits is allocated for each of the real and imaginary components.
-- The product is perfomed as

--	(ar + jai) x (br + jbi) = e + jf
--	where
--	e = (ar - ai)bi + ar(br - bi) and
--	f = (ar - ai)bi + ar(br + bi)
--
-- 03/02/00 : Initial rev. of file.
-- 03/23/00 : Modified baseblox used from v1_0 to v2_0
---------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;


LIBRARY XilinxCoreLib;

--USE XilinxCoreLib.vfft32_pkg_v3.all;
USE XilinxCoreLib.mult_gen_v4_0_comp.all;
USe XilinxCoreLib.mult_gen_v4_0_services.all;
--USE XilinxCoreLib.mult_funcs_v4_0.all;
USE XilinxCoreLib.mult_pkg_v4_0.all;
USE XilinxCoreLib.mult_const_pkg_v4_0.all;
USE XilinxCoreLib.C_REG_FD_V4_0_COMP.all;
USE XilinxCoreLib.C_ADDSUB_V4_0_COMP.all;
USE XilinxCoreLib.vfft32_comps_v3.all;

ENTITY complex_mult_v3 IS 		-- a*b; a=(ar+jai) & b=(br=jbi)
	 GENERIC (a_width	: INTEGER;
		  b_width	: INTEGER;
		  mult_type	: INTEGER :=1); --0 selects lut mult, 1 selects emb. mult
	PORT	(ar	: IN STD_LOGIC_VECTOR(a_width-1 DOWNTO 0);
		 ai	: IN STD_LOGIC_VECTOR(a_width-1 DOWNTO 0);
		 br	: IN STD_LOGIC_VECTOR(b_width-1 DOWNTO 0);
		 bi	: IN STD_LOGIC_VECTOR(b_width-1 DOWNTO 0);
		 clk	: IN STD_LOGIC;
		 ce	: IN STD_LOGIC;
		 reset	: IN STD_LOGIC;
		 start	: IN STD_LOGIC;
		 p_re	: OUT STD_LOGIC_VECTOR(a_width+b_width+1 DOWNTO 0); --full pr re o/p
		 p_im	: OUT STD_LOGIC_VECTOR(a_width+b_width+1 DOWNTO 0)  --full pr im o/p
		);
END complex_mult_v3;

ARCHITECTURE behavioral of complex_mult_v3 IS

constant emb_mult : INTEGER := eval(mult_type=1); --note avail for v2 and above only.
constant lut_mult : integer := eval(mult_type=0); --0;
constant mult_const: integer := lut_mult*0 + emb_mult*V2_PARALLEL;
CONSTANT prod_a_mult_latency : INTEGER := calc_latency(a_width+1, b_width, 0, 0, 1, 0, 1, mult_const, 0, a_width+1, " ", 0, 0, 0, 0);
CONSTANT prod_b_mult_latency : INTEGER := calc_latency(b_width+1, a_width, 0, 0, 1, 0, 1, mult_const, 0, b_width+1, " ", 0, 0, 0, 0);
CONSTANT greatest_mult_latency : INTEGER := prod_a_mult_latency*eval(prod_a_mult_latency >= prod_b_mult_latency) +  prod_b_mult_latency*eval(prod_b_mult_latency > prod_a_mult_latency);

CONSTANT max_complex_mult_v3_latency : INTEGER :=emb_mult*(6 -(greatest_mult_latency)) + lut_mult*4; 
CONSTANT delay_complex_mult_v3_result_by : INTEGER := max_complex_mult_v3_latency - (greatest_mult_latency); 


CONSTANT diff_in_latency_a	: INTEGER := greatest_mult_latency - prod_a_mult_latency;
CONSTANT diff_in_latency_b	: INTEGER := greatest_mult_latency - prod_b_mult_latency;
CONSTANT b_slower		: INTEGER := eval((prod_b_mult_latency =greatest_mult_latency) );
CONSTANT a_slower		: INTEGER := eval((prod_a_mult_latency =greatest_mult_latency) );
CONSTANT delay_faster_mult_by	: INTEGER := ((b_slower * diff_in_latency_a ) + (a_slower * diff_in_latency_b));
CONSTANT a_b_latency_equal	: INTEGER := eval(prod_a_mult_latency = prod_b_mult_latency);

-----------------------------------------------------------------
-- signals to hold (ar - ai), (br - bi), (br + bi) respectively.
-----------------------------------------------------------------
SIGNAL	ar_minus_ai	: STD_LOGIC_VECTOR(a_width DOWNTO 0);
SIGNAL	br_minus_bi	: STD_LOGIC_VECTOR(b_width DOWNTO 0);
SIGNAL	br_plus_bi	: STD_LOGIC_VECTOR(b_width DOWNTO 0);

-----------------------------------------------------------------
-- pipeline balancing registers for input operands
-- These compensate for the delay through the pre-add stage
-----------------------------------------------------------------
SIGNAL	bi_balance	: STD_LOGIC_VECTOR(b_width-1 DOWNTO 0);
SIGNAL	ar_balance	: STD_LOGIC_VECTOR(a_width-1 DOWNTO 0);
SIGNAL	ai_balance	: STD_LOGIC_VECTOR(a_width-1 DOWNTO 0);
SIGNAL	prod_a		: STD_LOGIC_VECTOR((a_width + b_width +1) -1 DOWNTO 0):= (OTHERS => '0'); 	-- (ar-ai)*bi
SIGNAL	prod_b		: STD_LOGIC_VECTOR((a_width + b_width +1) -1 DOWNTO 0); 	-- (br-bi)*ar
SIGNAL	prod_c		: STD_LOGIC_VECTOR((a_width + b_width +1) -1 DOWNTO 0); 	-- (br+bi)*ai

SIGNAL	prod_a_int		: STD_LOGIC_VECTOR((a_width + b_width +1) -1 DOWNTO 0) := (OTHERS => '0'); 	-- (ar-ai)*bi
SIGNAL	prod_b_int		: STD_LOGIC_VECTOR((a_width + b_width +1) -1 DOWNTO 0); 	-- (br-bi)*ar
SIGNAL	prod_c_int		: STD_LOGIC_VECTOR((a_width + b_width +1) -1 DOWNTO 0); 	-- (br+bi)*ai


---------------------------------------------
-- signals to hold full precision outputs
---------------------------------------------
SIGNAL	pr_full_precision	: STD_LOGIC_VECTOR((a_width + b_width +1) downto 0); -- Re(product)
SIGNAL	pi_full_precision	: STD_LOGIC_VECTOR((a_width + b_width +1) downto 0);-- Im(product)

SIGNAL delayed_pr_full_precision : STD_LOGIC_VECTOR((a_width + b_width +1) downto 0);
SIGNAL delayed_pi_full_precision : STD_LOGIC_VECTOR((a_width + b_width +1) downto 0); 

----------------------------------------------
-- signals to hold vcc, gnd, no_connect values
----------------------------------------------
SIGNAL logic0 : STD_LOGIC := '0';
SIGNAL logic1 : STD_LOGIC := '1';
SIGNAL nc     : STD_LOGIC := '0';
SIGNAL dummy_in : STD_LOGIC := '0';
SIGNAL dummy_addr : STD_LOGIC_VECTOR(0 DOWNTO 0) := (OTHERS => '0');

SIGNAL open_ovfl: STD_LOGIC;
SIGNAL open_c_out: STD_LOGIC;
SIGNAL open_b_out: STD_LOGIC;
SIGNAL open_q_ovfl: STD_LOGIC;
SIGNAL open_q_c_out: STD_LOGIC;
SIGNAL open_q_b_out: STD_LOGIC;
SIGNAL open_s: STD_LOGIC_VECTOR(a_width DOWNTO 0);

SIGNAL open_ovfl_1: STD_LOGIC;
SIGNAL open_c_out_1: STD_LOGIC;
SIGNAL open_b_out_1: STD_LOGIC;
SIGNAL open_q_ovfl_1: STD_LOGIC;
SIGNAL open_q_c_out_1: STD_LOGIC;
SIGNAL open_q_b_out_1: STD_LOGIC;
SIGNAL open_s_1: STD_LOGIC_VECTOR(b_width DOWNTO 0);

SIGNAL open_ovfl_2: STD_LOGIC;
SIGNAL open_c_out_2: STD_LOGIC;
SIGNAL open_b_out_2: STD_LOGIC;
SIGNAL open_q_ovfl_2: STD_LOGIC;
SIGNAL open_q_c_out_2: STD_LOGIC;
SIGNAL open_q_b_out_2: STD_LOGIC;
SIGNAL open_s_2: STD_LOGIC_VECTOR(b_width DOWNTO 0);

SIGNAL open_ovfl_3: STD_LOGIC;
SIGNAL open_c_out_3: STD_LOGIC;
SIGNAL open_b_out_3: STD_LOGIC;
SIGNAL open_q_ovfl_3: STD_LOGIC;
SIGNAL open_q_c_out_3: STD_LOGIC;
SIGNAL open_q_b_out_3: STD_LOGIC;
SIGNAL open_s_3: STD_LOGIC_VECTOR(a_width +b_width +1 DOWNTO 0);

SIGNAL open_ovfl_4: STD_LOGIC;
SIGNAL open_c_out_4: STD_LOGIC;
SIGNAL open_b_out_4: STD_LOGIC;
SIGNAL open_q_ovfl_4: STD_LOGIC;
SIGNAL open_q_c_out_4: STD_LOGIC;
SIGNAL open_q_b_out_4: STD_LOGIC;
SIGNAL open_s_4: STD_LOGIC_VECTOR(a_width +b_width +1 DOWNTO 0);

SIGNAL open_rfd_a : STD_LOGIC;
SIGNAL open_rdy_a : STD_LOGIC;
SIGNAL open_ld_a : STD_LOGIC;
SIGNAL open_q_a : STD_LOGIC_VECTOR(a_width+b_width+1 -1 DOWNTO 0);

SIGNAL open_rfd_b : STD_LOGIC;
SIGNAL open_rdy_b : STD_LOGIC;
SIGNAL open_ld_b : STD_LOGIC;
SIGNAL open_q_b : STD_LOGIC_VECTOR(a_width+b_width+1 -1 DOWNTO 0);

SIGNAL open_rfd_c : STD_LOGIC;
SIGNAL open_rdy_c : STD_LOGIC;
SIGNAL open_ld_c : STD_LOGIC;
SIGNAL open_q_c : STD_LOGIC_VECTOR(a_width+b_width+1 -1 DOWNTO 0);

BEGIN

logic0 <= '0';
logic1 <= '1';
nc <= '0';

ar_ai_sub:	C_ADDSUB_V4_0 GENERIC MAP (C_A_WIDTH => a_width,
			 C_B_WIDTH => a_width,   				   
			 C_OUT_WIDTH => a_width+1,
			 C_LOW_BIT => 0,  				   
			 C_HIGH_BIT => a_width,
			 C_ADD_MODE => 1, 	--"c_sub", 
			 C_A_TYPE =>  0, 	--"c_signed",  
			 C_B_TYPE => 0,		--"c_signed",
			 C_B_CONSTANT=> 0,  				   
			 C_B_VALUE   => "", 
			 C_AINIT_VAL => "",
			 C_SINIT_VAL => "", 
			-- C_BYPASS_ENABLE => "c_override",   
			 C_BYPASS_LOW => 0, 
			-- C_SYNC_ENABLE => "c_override", 	   
			-- C_SYNC_PRIORITY => "c_clear",	   
			 C_PIPE_STAGES => 1,
			 C_HAS_S => 0,
			 C_HAS_Q => 1,
			 C_HAS_C_IN => 0, -- was 1
			 C_HAS_C_OUT => 0,
			 C_HAS_Q_C_OUT => 0,
			 C_HAS_B_IN =>  1,
			 C_HAS_B_OUT => 0,
			 C_HAS_Q_B_OUT => 0,
			 C_HAS_OVFL => 0,
			 C_HAS_Q_OVFL => 0,
			 C_HAS_CE => 1,
			 C_HAS_ADD => 0, --was 1,
			 C_HAS_BYPASS => 0,
			 C_HAS_A_SIGNED => 1,
			 C_HAS_B_SIGNED => 1,
			 C_HAS_ACLR => 0,
			 C_HAS_ASET => 0,
			 C_HAS_AINIT => 1, -- was 0
			 C_HAS_SCLR => 0,
			 C_HAS_SSET => 0,
			 C_HAS_SINIT => 0,
			 C_ENABLE_RLOCS => 1)
		PORT MAP (A => ar,
			  B => ai,
			  CLK => clk,
			  ADD => dummy_in, --was logic0
			  C_IN => dummy_in, --was logic0
			  B_IN => logic1, --dummy_in, --was logic0
			  CE => ce, -- was logic1,
			  BYPASS => dummy_in, --was logic0
			  ACLR => dummy_in, -- was reset,
			  ASET => nc,
			  AINIT => reset, --was nc,
			  SCLR => nc,
			  SSET => nc,
			  SINIT => nc,
			  A_SIGNED => logic1,
			  B_SIGNED => logic1,
			  OVFL => open_ovfl,
			  C_OUT => open_c_out,
			  B_OUT => open_b_out,
			  Q_OVFL => open_q_ovfl,
			  Q_C_OUT => open_q_c_out,
			  Q_B_OUT => open_q_b_out,
			  S => open_s,
			  Q => ar_minus_ai);


br_bi_sub:	C_ADDSUB_V4_0 GENERIC MAP (C_A_WIDTH => b_width,
			 C_B_WIDTH => b_width,   				   
			 C_OUT_WIDTH => b_width+1,
			 C_LOW_BIT => 0,  				   
			 C_HIGH_BIT => b_width,
			 C_ADD_MODE => 1,		--"c_sub", 
			 C_A_TYPE => 0,			--"c_signed",  
			 C_B_TYPE => 0,			--"c_signed",
			 C_B_CONSTANT=> 0,  				   
			 C_B_VALUE   => "", 
			 C_AINIT_VAL => "",
			 C_SINIT_VAL => "", 
			-- C_BYPASS_ENABLE => "c_override",   
			 C_BYPASS_LOW => 0, 
			-- C_SYNC_ENABLE => "c_override", 	   
			-- C_SYNC_PRIORITY => "c_clear",	   
			 C_PIPE_STAGES => 1,
			 C_HAS_S => 0,
			 C_HAS_Q => 1,
			 C_HAS_C_IN => 0, --was 1
			 C_HAS_C_OUT => 0,
			 C_HAS_Q_C_OUT => 0,
			C_HAS_B_IN => 1,
			 C_HAS_B_OUT => 0,
			 C_HAS_Q_B_OUT => 0,
			 C_HAS_OVFL => 0,
			 C_HAS_Q_OVFL => 0,
			 C_HAS_CE => 1,
			 C_HAS_ADD => 0, --was 1
			 C_HAS_BYPASS => 0,
			 C_HAS_A_SIGNED => 1,
			 C_HAS_B_SIGNED => 1,
			 C_HAS_ACLR => 0,
			 C_HAS_ASET => 0,
			 C_HAS_AINIT => 1,
			 C_HAS_SCLR => 0,
			 C_HAS_SSET => 0,
			 C_HAS_SINIT => 0,
			 C_ENABLE_RLOCS => 1)
		PORT MAP (A => br,
			  B => bi,
			  CLK => clk,
			  ADD => dummy_in,
			  C_IN => dummy_in, --was logic0,
			  B_IN =>logic1, -- dummy_in, --was logic0,
			  CE => ce,
			  BYPASS => dummy_in, --was logic0,
			  ACLR => reset,
			  ASET => nc,
			  AINIT => reset, --was nc
			  SCLR => nc,
			  SSET => nc,
			  SINIT => nc,
			  A_SIGNED => logic1,
			  B_SIGNED => logic1,
			  OVFL => open_ovfl_1,
			  C_OUT => open_c_out_1,
			  B_OUT => open_b_out_1,
			  Q_OVFL => open_q_ovfl_1,
			  Q_C_OUT => open_q_c_out_1,
			  Q_B_OUT => open_q_b_out_1,
			  S => open_s_1,
			  Q => br_minus_bi);



br_bi_add:	C_ADDSUB_V4_0 GENERIC MAP (C_A_WIDTH => b_width,
			 C_B_WIDTH =>  b_width, 				   
			 C_OUT_WIDTH => b_width+1,
			 C_LOW_BIT => 0,  				   
			 C_HIGH_BIT => b_width,
			 C_ADD_MODE => 0,			--"c_add", 
			 C_A_TYPE => 0,		--"c_signed",  
			 C_B_TYPE => 0,		--"c_signed",
			 C_B_CONSTANT=> 0,  				   
			 C_B_VALUE   => "", 
			 C_AINIT_VAL => "",
			 C_SINIT_VAL => "", 
			-- C_BYPASS_ENABLE => "c_override",   
			 C_BYPASS_LOW => 0, 
			-- C_SYNC_ENABLE => "c_override", 	   
			-- C_SYNC_PRIORITY => "c_clear",	   
			 C_PIPE_STAGES => 1,
			 C_HAS_S => 0,
			 C_HAS_Q => 1,
			 C_HAS_C_IN => 1, --0,
			 C_HAS_C_OUT => 0,
			 C_HAS_Q_C_OUT => 0,
			 C_HAS_B_IN => 0,
			 C_HAS_B_OUT => 0,
			 C_HAS_Q_B_OUT => 0,
			 C_HAS_OVFL => 0,
			 C_HAS_Q_OVFL => 0,
			 C_HAS_CE => 1,
			 C_HAS_ADD => 0, -- was 1,
			 C_HAS_BYPASS => 0,
			 C_HAS_A_SIGNED => 1,
			 C_HAS_B_SIGNED => 1,
			 C_HAS_ACLR => 0,
			 C_HAS_ASET => 0,
			 C_HAS_AINIT => 1,
			 C_HAS_SCLR => 0,
			 C_HAS_SSET => 0,
			 C_HAS_SINIT => 0,
			 C_ENABLE_RLOCS => 1)
		PORT MAP (A => br,
			  B => bi,
			  CLK => clk,
			  ADD => dummy_in, --was logic1,
			  C_IN => logic0, --dummy_in, --was logic0,
			  B_IN => dummy_in, --was logic0,
			  CE => ce,
			  BYPASS => dummy_in, --was logic0,
			  ACLR => reset,
			  ASET => nc,
			  AINIT => reset, --was nc
			  SCLR => nc,
			  SSET => nc,
			  SINIT => nc,
			  A_SIGNED => logic1,
			  B_SIGNED => logic1,
			  OVFL => open_ovfl_2,
			  C_OUT => open_c_out_2,
			  B_OUT => open_b_out_2,
			  Q_OVFL => open_q_ovfl_2,
			  Q_C_OUT => open_q_c_out_2,
			  Q_B_OUT => open_q_b_out_2,
			  S => open_s_2,
			  Q => br_plus_bi);


bi_balance_reg : C_REG_FD_V4_0 GENERIC MAP 
			(C_WIDTH => b_width,
			C_AINIT_VAL => "0",
			--C_SINIT_VAL => "",
			--C_SYNC_PRIORITY => "c_clear",
			--C_SYNC_ENABLE => "c_override",
			C_HAS_CE => 1,
			C_HAS_ACLR =>0, --was 1
			C_HAS_ASET => 0,
			C_HAS_AINIT => 1, --was 0
			C_HAS_SCLR => 0,
			C_HAS_SSET => 0,
			C_HAS_SINIT => 0,
			C_ENABLE_RLOCS  => 1)
		PORT MAP (D=> bi,
			  CLK => clk,
			  CE => ce,
			  ACLR => dummy_in, --was reset,
			  ASET => nc,
			  AINIT => reset, --was nc,
			  SCLR => nc,
			  SSET => nc,
			  SINIT => nc,
			  Q =>bi_balance);


ar_balance_reg : C_REG_FD_V4_0 GENERIC MAP 
			(C_WIDTH => a_width,
			C_AINIT_VAL => "0",
			--C_SINIT_VAL => "",
			--C_SYNC_PRIORITY => "c_clear",
			--C_SYNC_ENABLE => "c_override",
			C_HAS_CE => 1,
			C_HAS_ACLR => 0, --was 1,
			C_HAS_ASET => 0,
			C_HAS_AINIT => 1, --was 0,
			C_HAS_SCLR => 0,
			C_HAS_SSET => 0,
			C_HAS_SINIT => 0,
			C_ENABLE_RLOCS  => 1)
		PORT MAP (D=> ar,
			  CLK => clk,
			  CE => ce,
			  ACLR => dummy_in, --was reset
			  ASET => nc,
			  AINIT => reset, --was nc,
			  SCLR => nc,
			  SSET => nc,
			  SINIT => nc,
			  Q =>ar_balance);

ai_balance_reg : C_REG_FD_V4_0 GENERIC MAP 
			(C_WIDTH => a_width,
			C_AINIT_VAL => "0",
			--C_SINIT_VAL => "",
			--C_SYNC_PRIORITY => "c_clear",
			--C_SYNC_ENABLE => "c_override",
			C_HAS_CE => 1,
			C_HAS_ACLR => 0, --was 1,
			C_HAS_ASET => 0,
			C_HAS_AINIT => 1, --was 0,
			C_HAS_SCLR => 0,
			C_HAS_SSET => 0,
			C_HAS_SINIT => 0,
			C_ENABLE_RLOCS  => 1)
		PORT MAP (D=> ai,
			  CLK => clk,
			  CE => ce,
			  ACLR => dummy_in, --was reset,
			  ASET => nc,
			  AINIT => reset, --was nc,
			  SCLR => nc,
			  SSET => nc,
			  SINIT => nc,
			  Q =>ai_balance);


prod_a_mult:	mult_gen_v4_0
		GENERIC MAP (	C_A_WIDTH => a_width + 1,
 				C_B_WIDTH => b_width,
				c_out_width => a_width+b_width+1,
				c_has_q => 0,
				c_has_o => 1,
				c_reg_a_b_inputs => 1,
				c_a_type => 0, --want signed
				c_b_type => 0, --want signed
				c_b_constant => 0,
				c_has_sclr => 0,
				c_has_a_signed => 0,
				c_has_loadb => 0,
				c_use_luts => lut_mult, --0, --1 vk changed to 0 jun26 to use emb. mult,
				c_baat => a_width+1,				
 				--C_TYPE => 0, 		--c_signed,
 	    			C_PIPELINE => 1,-- vk aug19, --1,
 	    			--C_OUTPUT_REG =>0, --vk aug19, -- 1,
 				--C_SYNC_PRIORITY : integer := c_clear;         
 				--C_SYNC_ENABLE   : integer := c_no_override; 
        			C_HAS_CE => 1,
 				C_HAS_ACLR=> 1,
                                c_mult_type =>mult_const)--V2_PARALLEL)-- 1) --vk jun26 use emb_mult mult)
 		PORT MAP (	A => ar_minus_ai,
				B => bi_balance,
				CLK => clk,
				CE => ce,
				ACLR => reset,
				--ASET => nc,
				SCLR => nc,
				--SSET => nc,
				a_signed => nc,
				loadb =>nc,
				swapb => nc,
				nd => nc,
				rfd => open_rfd_a,
				rdy => open_rdy_a,
				load_done => open_ld_a,
				o => prod_a_int,
				q => open_q_a); 
	
prod_b_mult:	mult_gen_v4_0
		GENERIC MAP (	C_A_WIDTH => b_width + 1,
 				C_B_WIDTH => a_width,
				c_out_width => a_width+b_width+1,
				c_has_q => 0,
				c_has_o => 1,
				c_reg_a_b_inputs => 1,
				c_a_type => 0, --want signed
				c_b_type => 0, --want signed
				c_b_constant => 0,
				c_has_sclr => 0,
				c_has_a_signed => 0,
				c_has_loadb => 0,
				c_use_luts =>lut_mult, -- 0, --vk jun2601 for emb mult  1,
				c_baat => b_width+1,				
 				--C_TYPE => 0, 		--c_signed,
 	    			C_PIPELINE => 1,-- vk aug19, --1,
 	    			--C_OUTPUT_REG =>0, --vk aug19, -- 1,
 				--C_SYNC_PRIORITY : integer := c_clear;         
 				--C_SYNC_ENABLE   : integer := c_no_override; 
        			C_HAS_CE => 1,
 				C_HAS_ACLR=> 1,
				c_mult_type =>mult_const)-- V2_PARALLEL) --vk jun2601 use emb.mult
 		PORT MAP (	A => br_minus_bi,
				B => ar_balance,
				CLK => clk,
				CE => ce,
				ACLR => reset,
				--ASET => nc,
				SCLR => nc,
				--SSET => nc,
				a_signed => nc,
				loadb =>nc,
				swapb => nc,
				nd => nc,
				rfd => open_rfd_b,
				rdy => open_rdy_b,
				load_done => open_ld_b,
				o => prod_b_int,
				q => open_q_b);  


prod_c_mult:	mult_gen_v4_0
		GENERIC MAP (	C_A_WIDTH => b_width + 1,
 				C_B_WIDTH => a_width,
				c_out_width => a_width+b_width+1,
				c_has_q => 0,
				c_has_o => 1,
				c_reg_a_b_inputs => 1,
				c_a_type => 0, --want signed
				c_b_type => 0, --want signed
				c_b_constant => 0,
				c_has_sclr => 0,
				c_has_a_signed => 0,
				c_has_loadb => 0,
				c_use_luts => lut_mult, --0, -- vk jun2601 for emb. mult 1,
				c_baat => b_width+1,				
 				--C_TYPE => 0, 		--c_signed,
 	    			C_PIPELINE => 1,-- vk aug19, --1,
 	    			--C_OUTPUT_REG =>0, --vk aug19, -- 1,
 				--C_SYNC_PRIORITY : integer := c_clear;         
 				--C_SYNC_ENABLE   : integer := c_no_override; 
        			C_HAS_CE => 1,
				C_HAS_ACLR=> 1,
				c_mult_type =>mult_const)-- V2_PARALLEL) --vk jun2601 use emb. mult
 		PORT MAP (	A => br_plus_bi,
				B => ai_balance,
				CLK => clk,
				CE => ce,
				ACLR => reset,
				--ASET => nc,
				SCLR => nc,
				--SSET => nc,
				a_signed => nc,
				loadb =>nc,
				swapb => nc,
				nd => nc,
				rfd => open_rfd_c,
				rdy => open_rdy_c,
				load_done => open_ld_c,
				o => prod_c_int,
				q => open_q_c); 

				

eq_lat: IF ( a_b_latency_equal = 1) GENERATE
prod_a <= prod_a_int;
prod_b <= prod_b_int;
prod_c <= prod_c_int;
END GENERATE eq_lat;

delay_prod_a_result: IF ((b_slower=1) and ( a_b_latency_equal = 0)) GENERATE
delay_prod_a	: delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => delay_faster_mult_by+1+eval(diff_in_latency_a>=2)
 + eval(diff_in_latency_b>=2)+ eval(diff_in_latency_a>=3) + eval(diff_in_latency_b>=3), 
					DATA_WIDTH => a_width + b_width +1)
				PORT MAP (addr => dummy_addr,
					data => prod_a_int,
					clk => clk,
					reset => dummy_in,
					start => start,
					delayed_data => prod_a);

prod_b <= prod_b_int;
prod_c <= prod_c_int;
END GENERATE; --delay_prod_a_result

delay_prod_b_and_c_result: IF ((a_slower=1) and (a_b_latency_equal=0)) GENERATE
delay_prod_b	: delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => delay_faster_mult_by+1+eval(diff_in_latency_a>=2)
 + eval(diff_in_latency_b>=2)+eval(diff_in_latency_a>=3) + eval(diff_in_latency_b>=3),  
					DATA_WIDTH => a_width + b_width +1)
				PORT MAP (addr => dummy_addr,
					data => prod_b_int,
					clk => clk,
					reset => dummy_in,--reset,
					start => reset, --start,
					delayed_data => prod_b);

delay_prod_c	: delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => delay_faster_mult_by+1+eval(diff_in_latency_a>=2)
 + eval(diff_in_latency_b>=2)+eval(diff_in_latency_a>=3) + eval(diff_in_latency_b>=3), 
					DATA_WIDTH => a_width + b_width +1)
				PORT MAP (addr => dummy_addr,
					data => prod_c_int,
					clk => clk,
					reset => dummy_in, --reset,
					start => reset, --start,
					delayed_data => prod_c);
prod_a <= prod_a_int;

END GENERATE; --delay_prod_b_and_c_result



p_re_add:	C_ADDSUB_V4_0 
		GENERIC MAP (C_A_WIDTH => a_width + b_width +1, 
			 C_B_WIDTH => a_width + b_width +1, 				   
			 C_OUT_WIDTH => a_width + b_width+2,
			 C_LOW_BIT => 0,  				   
			 C_HIGH_BIT => a_width + b_width +1,
			 C_ADD_MODE => 0,		--"c_add", 
			 C_A_TYPE => 0,			--"c_signed",  
			 C_B_TYPE => 0,			--"c_signed",
			 C_B_CONSTANT=> 0,  				   
			 C_B_VALUE   => "", 
			 C_AINIT_VAL => "",
			-- C_SINIT_VAL => "", 
			-- C_BYPASS_ENABLE => "c_override",   
			 C_BYPASS_LOW => 0, 
			-- C_SYNC_ENABLE => "c_override", 	   
			-- C_SYNC_PRIORITY => "c_clear",	   
			 C_PIPE_STAGES => 1,
			 C_HAS_S => 0,
			 C_HAS_Q => 1,
			 C_HAS_C_IN => 1,
			 C_HAS_C_OUT => 0,
			 C_HAS_Q_C_OUT => 0,
			 C_HAS_B_IN => 0,
			 C_HAS_B_OUT => 0,
			 C_HAS_Q_B_OUT => 0,
			 C_HAS_OVFL => 0,
			 C_HAS_Q_OVFL => 0,
			 C_HAS_CE => 0,
			 C_HAS_ADD => 1,
			 C_HAS_BYPASS => 0,
			 C_HAS_A_SIGNED => 1,
			 C_HAS_B_SIGNED => 1,
			 C_HAS_ACLR => 1, --0,vknov301
			 C_HAS_ASET => 0,
			 C_HAS_AINIT => 0,
			 C_HAS_SCLR => 0,
			 C_HAS_SSET => 0,
			 C_HAS_SINIT => 0,
			 C_ENABLE_RLOCS => 1)
		PORT MAP (A => prod_a,
			  B => prod_b,
			  CLK => clk,
			  ADD => logic1,
			  C_IN => logic0,
			  B_IN => logic0,
			  CE => logic1,
			  BYPASS => logic0,
			  ACLR => reset,
			  ASET => nc,
			  AINIT => nc,
			  SCLR => nc,
			  SSET => nc,
			  SINIT => nc,
			  A_SIGNED => logic1,
			  B_SIGNED => logic1,
			  OVFL => open_ovfl_3,
			  C_OUT => open_c_out_3,
			  B_OUT => open_b_out_3,
			  Q_OVFL => open_q_ovfl_3,
			  Q_C_OUT => open_q_c_out_3,
			  Q_B_OUT => open_q_b_out_3,
			  S => open_s_3,
			  Q => pr_full_precision);
	

p_im_add:	C_ADDSUB_V4_0 
		GENERIC MAP (C_A_WIDTH => a_width + b_width +1, 
			 C_B_WIDTH => a_width + b_width +1, 				   
			 C_OUT_WIDTH =>a_width + b_width+2,
			 C_LOW_BIT => 0,  				   
			 C_HIGH_BIT => a_width + b_width +1,
			 C_ADD_MODE => 0,			--"c_add", 
			 C_A_TYPE => 0,				--"c_signed",  
			 C_B_TYPE => 0,				--"c_signed",
			 C_B_CONSTANT=> 0,  				   
			 C_B_VALUE   => "", 
			 C_AINIT_VAL => "",
			-- C_SINIT_VAL => "", 
			-- C_BYPASS_ENABLE => "c_override",   
			 C_BYPASS_LOW => 0, 
			-- C_SYNC_ENABLE => "c_override", 	   
			-- C_SYNC_PRIORITY => "c_clear",	   
			 C_PIPE_STAGES => 1,
			 C_HAS_S => 0,
			 C_HAS_Q => 1,
			 C_HAS_C_IN =>1, --0, -- 1,
			 C_HAS_C_OUT => 0,
			 C_HAS_Q_C_OUT => 0,
			 C_HAS_B_IN => 0, --1,
			 C_HAS_B_OUT => 0,
			 C_HAS_Q_B_OUT => 0,
			 C_HAS_OVFL => 0,
			 C_HAS_Q_OVFL => 0,
			 C_HAS_CE => 0,
			 C_HAS_ADD => 0, --1,
			 C_HAS_BYPASS => 0,
			 C_HAS_A_SIGNED => 1,
			 C_HAS_B_SIGNED => 1,
			 C_HAS_ACLR => 1, --0, vknov301
			 C_HAS_ASET => 0,
			 C_HAS_AINIT => 0,
			 C_HAS_SCLR => 0,
			 C_HAS_SSET => 0,
			 C_HAS_SINIT => 0,
			 C_ENABLE_RLOCS => 1)
		PORT MAP (A => prod_a,
			  B => prod_c,
			  CLK => clk,
			  ADD => logic1,
			  C_IN => logic0,
			  B_IN => logic0,
			  CE => logic1,
			  BYPASS => logic0,
			  ACLR => reset,
			  ASET => nc,
			  AINIT => nc,
			  SCLR => nc,
			  SSET => nc,
			  SINIT => nc,
			  A_SIGNED => logic1,
			  B_SIGNED => logic1,
			  OVFL => open_ovfl_4,
			  C_OUT => open_c_out_4,
			  B_OUT => open_b_out_4,
			  Q_OVFL => open_q_ovfl_4,
			  Q_C_OUT => open_q_c_out_4,
			  Q_B_OUT => open_q_b_out_4,
			  S => open_s_4,
			  Q => pi_full_precision);

delay_gen: IF (delay_complex_mult_v3_result_by > 0) GENERATE
-------------------------------------------------
-- Delay the full precision result.   
-------------------------------------------------

delay_pr_full_p	: delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => delay_complex_mult_v3_result_by +1, 
					DATA_WIDTH => a_width+b_width+2)
				PORT MAP (addr => dummy_addr,
					data => pr_full_precision,
					clk => clk,
					reset => reset,--dummy_in,vknov301
					start => start,
					delayed_data => delayed_pr_full_precision);

delay_pi_full_p	: delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => delay_complex_mult_v3_result_by +1, 
					DATA_WIDTH => a_width+b_width+2)
				PORT MAP (addr => dummy_addr,
					data => pi_full_precision,
					clk => clk,
					reset => reset,--dummy_in, vknov301
					start => start,
					delayed_data => delayed_pi_full_precision);

-------------------------------------------------------
-- Bring to the port the delayed full precision result.   
-------------------------------------------------------
p_re <= delayed_pr_full_precision;
p_im <= delayed_pi_full_precision;

END GENERATE delay_gen;

no_delay_gen: IF (delay_complex_mult_v3_result_by = 0) GENERATE
p_re <= pr_full_precision;
p_im <= pi_full_precision;

END GENERATE no_delay_gen;

END behavioral;

----new cmult----
-----------------------------END complex_mult_v3---------------------------------------------

--------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
--------------------------------------------------------------------------
-- Last modified on 03/06/00
-- Name : complex_reg_conj.vhd
-- Function : This contains a complex register/conjugator. When the
-- inverse_fft (conj= 1) is reqd, the output of this module is a registered
-- real part and a two's complimented imaginary part. When forward fft
-- (non-inverse!, conj=0) fft is required, the output of the module is a registered
-- real and imaginary part. The conjugation control pin, conj, is connected 
-- to 'bypass' on the two's complimenter. Bypass is active low ie:
-- conj. is bypassed when bypass=0; o/p is simply a registered version of input.

-- 04/03/00 : Initial rev. of file.
-- Last modified on 03/30/00
---------------------------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY XilinxCoreLib;
Use XilinxCoreLib.prims_constants_v4_0.all;
USE XilinxCoreLib.C_REG_FD_V4_0_comp.all;
USE XilinxCoreLib.C_TWOS_COMP_V4_0_comp.all;
USE XilinxCoreLib.vfft32_comps_v3.all;
USE XilinxCoreLib.vfft32_pkg_v3.all;


ENTITY complex_reg_conj_v3 IS
	GENERIC ( B		: INTEGER := 16);  --input data precision
	PORT (clk	: IN STD_LOGIC;
		ce	: IN STD_LOGIC;
		conj	: IN STD_LOGIC;  -- conjugation control
		dr	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);  --Re input
		di	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);  --Im input
		qr	: OUT STD_LOGIC_VECTOR(B-1  DOWNTO 0);  --Re result
		qi	: OUT STD_LOGIC_VECTOR(B-1  DOWNTO 0));  --Im result
END complex_reg_conj_v3;


ARCHITECTURE behavioral OF complex_reg_conj_v3 IS

SIGNAL dummy_in : STD_LOGIC:= '0';
SIGNAL nc:		STD_LOGIC:= '0';
SIGNAL open_s:	STD_LOGIC_VECTOR(B DOWNTO 0);
SIGNAL qi_internal: STD_LOGIC_VECTOR(B DOWNTO 0);

BEGIN
dummy_in <= '0';
nc <= '0';

twos_comp_imag: c_twos_comp_v4_0 
			GENERIC MAP (C_WIDTH  => B,
					C_AINIT_VAL => "0", 		
					C_BYPASS_LOW => 1, --bypass when low and 2's comp when high??
					C_PIPE_STAGES=> 1, --was 1
					C_HAS_BYPASS => 1,
					C_BYPASS_ENABLE => c_no_override, 
					C_HAS_CE => 1,
					C_HAS_Q => 1,
					C_ENABLE_RLOCS  => 1)
			PORT MAP 	(A => di,
					BYPASS => conj,
					CLK => clk,
					ce => ce,
					ACLR => dummy_in,
					ASET => dummy_in,
					AINIT => dummy_in,
					SCLR => dummy_in,
					SSET => dummy_in,
					SINIT => dummy_in,
					S => open_s,
					Q => qi_internal);


reg_real:	C_REG_FD_V4_0 
		GENERIC MAP (C_WIDTH => B,
				C_HAS_CE => 1,
				C_HAS_ACLR => 0,
				C_HAS_ASET => 0,
				C_HAS_AINIT => 0,
				C_HAS_SCLR => 0,
				C_HAS_SSET => 0,
				C_HAS_SINIT => 0,
				C_ENABLE_RLOCS  => 1)
		PORT MAP 	(D=> dr,
			  	CLK => clk,
			  	CE => ce,
			  	ACLR => dummy_in, --was reset,
			  	ASET => nc,
			  	AINIT => nc, --was nc,
			  	SCLR => nc,
			  	SSET => nc,
			  	SINIT => nc,
			  	Q =>qr);

qi <= qi_internal(B-1 DOWNTO 0);	
END behavioral;
------------------------------------END complex_reg_conj_v3--------------------------------------
--------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
--------------------------------------------------------------------------
-- Last modified on 03/06/00
-- Name : butterfly.vhd
-- Function : This contains one butterfly engine.
--
--
-- 		x0--------\---(+)----------------y0
--			    / 
--		     	   / \
--		x1--------/----(+)--------(X)----y1
--			      -		  |
--					  |
--					  w
--
--
-- NOTE:	The outputs, y0 and y1, grow by one bit. However the growth
--		on the output signals is really much larger owing to the growth
--		resulting from the adder, subtractor and multiplier. Output is
--		truncated. 
-- 03/02/00 : Initial rev. of file.
-- Last modified on 03/30/00
-- Changed:	baseblox_v1_0 modules to baseblox_v2_0 modules. Also fixed
--		some parameters on the addsub_v2_0- matches with complex_mult_v3
---------------------------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_ADDSUB_V4_0_comp.all;
USE XilinxCoreLib.C_MUX_BUS_V4_0_comp.all;
USE XilinxCoreLib.C_SHIFT_RAM_V4_0_comp.all;
USE XilinxCoreLib.vfft32_comps_v3.all;
USE XilinxCoreLib.vfft32_pkg_v3.all;

ENTITY butterfly_v3 IS
	GENERIC ( B		: INTEGER := 16;  --input data precision
		  W_WIDTH	: INTEGER := 16;
		memory_architecture : INTEGER :=3;
		mult_type:	INTEGER :=1); --0 selects lut mult, 1 selects emb v2 mult
	PORT (	clk	: IN STD_LOGIC;
		ce	: IN STD_LOGIC;
		start_bf: IN STD_LOGIC;
		start	: IN STD_LOGIC;
		reset	: IN STD_LOGIC;
		scale_factor : IN STD_LOGIC_VECTOR (1 DOWNTO 0); 
		x0r	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);  --Re operand 0
		x0i	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);  --Im operand 0
		x1r	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);  --Re operand 1
		x1i	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);  --Im operand 1
		done	: IN STD_LOGIC;
		y0r	: OUT STD_LOGIC_VECTOR(B-1 DOWNTO 0);  --Re result 0   
		y0i	: OUT STD_LOGIC_VECTOR(B-1 DOWNTO 0);  --Im result 0   
		y1r	: OUT STD_LOGIC_VECTOR(B-1  DOWNTO 0);  --Re result 1    
		y1i	: OUT STD_LOGIC_VECTOR(B-1  DOWNTO 0);  --Im result 1     
		ovflo	: OUT STD_LOGIC;
		wi	: IN STD_LOGIC_VECTOR(W_WIDTH-1 DOWNTO 0);  --Re omega
		wr	: IN STD_LOGIC_VECTOR(W_WIDTH-1 DOWNTO 0);
		io_out : in std_logic;
		edone_s: in std_logic;
		busy_in : in std_logic);  --Im omega
END butterfly_v3;


ARCHITECTURE behavioral OF butterfly_v3 IS

-------------------------------------------------------------------------------
--  extend: sign extend a bit vector to the designated width.
-------------------------------------------------------------------------------

  FUNCTION extend( vector : std_logic_vector; bits : INTEGER )
    RETURN std_logic_vector IS

    CONSTANT return_width : INTEGER := bits; 
    VARIABLE return_value : std_logic_vector(return_width-1 DOWNTO 0);

  BEGIN

    FOR i IN 0 TO return_width-1 LOOP
      IF i <= vector'LENGTH-1 THEN
	return_value(i) := vector(i);
      ELSE
	return_value(i) := vector(vector'high);
      END IF;
    END LOOP;

    RETURN return_value;

  END extend;


CONSTANT ainit_val : STRING := "0000000";
CONSTANT sinit_val : STRING := "0000000";

CONSTANT max_complex_mult_v3_latency : INTEGER :=6;
CONSTANT max_bfly_latency	: INTEGER := 7;
CONSTANT delay_upper_arm_by	: INTEGER := 6; --so result is avail one clock cycle earlier than lower arm.


CONSTANT xmul_full_pr_width	: INTEGER	:= B + W_WIDTH +3; --B + 1 + W_WIDTH +1 +1
CONSTANT diff_with_0_scaling	: INTEGER	:= xmul_full_pr_width - (B+2) ;  --changed from (B+1)
CONSTANT latency_thro_mult_vgen	: INTEGER	:= mult_latency(W_WIDTH);
CONSTANT latency_thro_comp_mult	: INTEGER	:= cmplx_mult_latency(W_WIDTH, B+1); -- *2; --+6; -- (multiply by 2 ??) 2 + latency_thro_mult_vgen;
--CONSTANT delay_upper_arm_by	: INTEGER := latency_thro_comp_mult ;
CONSTANT result			: INTEGER 	:= B + W_WIDTH-1 -1;
CONSTANT diff0			: INTEGER 	:= result-B;
CONSTANT upperarm_diff0		: INTEGER 	:= 0; -- B - (B)

SIGNAL logic0		: STD_LOGIC	:='0';
SIGNAL logic1		: STD_LOGIC	:='1';
SIGNAL sub_to_mult_r	: STD_LOGIC_VECTOR(B DOWNTO 0);
SIGNAL sub_to_mult_i	: STD_LOGIC_VECTOR(B DOWNTO 0);
SIGNAL nc		: STD_LOGIC	:= '0';
SIGNAL dummy_in		: STD_LOGIC	:= '0';

SIGNAL ce_bf		: STD_LOGIC; --for xcc	:= '0';

SIGNAL int_y0r	: STD_LOGIC_VECTOR(B+1 DOWNTO 0);
SIGNAL int_y0i	: STD_LOGIC_VECTOR(B+1 DOWNTO 0);

SIGNAL y0r_pre_delay : STD_LOGIC_VECTOR(B DOWNTO 0);
SIGNAL y0i_pre_delay : STD_LOGIC_VECTOR(B DOWNTO 0);

SIGNAL p_re_temp_0scaled: STD_LOGIC_VECTOR(result DOWNTO 0);
SIGNAL p_im_temp_0scaled: STD_LOGIC_VECTOR(result DOWNTO 0);

SIGNAL p_re_temp_1scaled: STD_LOGIC_VECTOR(result+1 DOWNTO 0);
SIGNAL p_im_temp_1scaled: STD_LOGIC_VECTOR(result+1 DOWNTO 0);

SIGNAL p_re_temp_2scaled: STD_LOGIC_VECTOR(result+2 DOWNTO 0);
SIGNAL p_im_temp_2scaled: STD_LOGIC_VECTOR(result+2 DOWNTO 0);


SIGNAL y0r_pre_delay_s_ext : STD_LOGIC_VECTOR(B+1 DOWNTO 0);
SIGNAL y0i_pre_delay_s_ext : STD_LOGIC_VECTOR(B+1 DOWNTO 0);


SIGNAL p_re_full_precision : STD_LOGIC_VECTOR(B + 1 + W_WIDTH +1 DOWNTO 0);
SIGNAL p_im_full_precision : STD_LOGIC_VECTOR(B + 1 + W_WIDTH +1 DOWNTO 0);
SIGNAL p_re_truncated	: STD_LOGIC_VECTOR(B+1 DOWNTO 0);
SIGNAL p_im_truncated	: STD_LOGIC_VECTOR(B+1 DOWNTO 0);

SIGNAL open_ovfl: STD_LOGIC;
SIGNAL open_c_out: STD_LOGIC;
SIGNAL open_b_out: STD_LOGIC;
SIGNAL open_q_ovfl: STD_LOGIC;
SIGNAL open_q_c_out: STD_LOGIC;
SIGNAL open_q_b_out: STD_LOGIC;
SIGNAL open_s: STD_LOGIC_VECTOR(B DOWNTO 0);

SIGNAL open_ovfl_1: STD_LOGIC;
SIGNAL open_c_out_1: STD_LOGIC;
SIGNAL open_b_out_1: STD_LOGIC;
SIGNAL open_q_ovfl_1: STD_LOGIC;
SIGNAL open_q_c_out_1: STD_LOGIC;
SIGNAL open_q_b_out_1: STD_LOGIC;
SIGNAL open_s_1: STD_LOGIC_VECTOR(B DOWNTO 0);

SIGNAL open_ovfl_2: STD_LOGIC;
SIGNAL open_c_out_2: STD_LOGIC;
SIGNAL open_b_out_2: STD_LOGIC;
SIGNAL open_q_ovfl_2: STD_LOGIC;
SIGNAL open_q_c_out_2: STD_LOGIC;
SIGNAL open_q_b_out_2: STD_LOGIC;
SIGNAL open_s_2: STD_LOGIC_VECTOR(B DOWNTO 0);

SIGNAL open_ovfl_3: STD_LOGIC;
SIGNAL open_c_out_3: STD_LOGIC;
SIGNAL open_b_out_3: STD_LOGIC;
SIGNAL open_q_ovfl_3: STD_LOGIC;
SIGNAL open_q_c_out_3: STD_LOGIC;
SIGNAL open_q_b_out_3: STD_LOGIC;
SIGNAL open_s_3: STD_LOGIC_VECTOR(B DOWNTO 0);


SIGNAL mux_select	: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL dummy_mux_inputs	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL y0r_scale0	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL y0i_scale0	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL y1r_scale0	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL y1i_scale0	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL y0r_scale1	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL y0i_scale1	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL y1r_scale1	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL y1i_scale1	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL y0r_scale2	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL y0i_scale2	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL y1r_scale2	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL y1i_scale2	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);

SIGNAL open_q_r		: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL open_q_i		: STD_LOGIC_VECTOR(B-1 DOWNTO 0);

SIGNAL dummy_addr	: STD_LOGIC_VECTOR(0 DOWNTO 0);

SIGNAL ovflo_0		: STD_LOGIC;
SIGNAL ovflo_1		: STD_LOGIC;
SIGNAL ovflo_2		: STD_LOGIC;

SIGNAL ovflo_0_temp_re_or_im	: STD_LOGIC_VECTOR(0 DOWNTO 0); 

SIGNAL ovflo_1_temp_re_or_im	: STD_LOGIC_VECTOR(0 DOWNTO 0); 

SIGNAL ovflo_2_temp_re_or_im	: STD_LOGIC_VECTOR(0 DOWNTO 0); 
SIGNAL ovflo_temp	: STD_LOGIC_VECTOR(0 DOWNTO 0);

SIGNAL open_q_ovflo	: STD_LOGIC_VECTOR(0 DOWNTO 0);

SIGNAL dummy_mux_inputs_ovflo :STD_LOGIC_VECTOR(0 DOWNTO 0); 
SIGNAL open_sclr		: STD_LOGIC;

SIGNAL ovflo_0_int	: STD_LOGIC_VECTOR(xmul_full_pr_width-1 DOWNTO result+1); -- DOWNTO result);
SIGNAL ovflo_1_int	: STD_LOGIC_VECTOR(xmul_full_pr_width-1 DOWNTO result+2); --+1
SIGNAL ovflo_2_int	: STD_LOGIC_VECTOR(xmul_full_pr_width-1 DOWNTO result+3); --+2

SIGNAL or_out_0		: STD_LOGIC_VECTOR(xmul_full_pr_width-1 DOWNTO result+2);
SIGNAL or_out_1		: STD_LOGIC_VECTOR(xmul_full_pr_width-1 DOWNTO result+3);
SIGNAL or_out_2		: STD_LOGIC_VECTOR(xmul_full_pr_width-1 DOWNTO result+4);

SIGNAL ovflo_0_int_im	: STD_LOGIC_VECTOR(xmul_full_pr_width-1 DOWNTO result+1); --+0
SIGNAL ovflo_1_int_im	: STD_LOGIC_VECTOR(xmul_full_pr_width-1 DOWNTO result+2); --+1
SIGNAL ovflo_2_int_im	: STD_LOGIC_VECTOR(xmul_full_pr_width-1 DOWNTO result+3); --+2

SIGNAL or_out_0_im		: STD_LOGIC_VECTOR(xmul_full_pr_width-1 DOWNTO result+2);
SIGNAL or_out_1_im		: STD_LOGIC_VECTOR(xmul_full_pr_width-1 DOWNTO result+3);
SIGNAL or_out_2_im		: STD_LOGIC_VECTOR(xmul_full_pr_width-1 DOWNTO result+4);

SIGNAL ovflo_0_re_or_im		: STD_LOGIC;
SIGNAL ovflo_1_re_or_im		: STD_LOGIC;
SIGNAL ovflo_2_re_or_im		: STD_LOGIC;

SIGNAL ovflo_0_re			: STD_LOGIC;
SIGNAL ovflo_0_im			: STD_LOGIC;

SIGNAL ovflo_1_re			: STD_LOGIC;
SIGNAL ovflo_1_im			: STD_LOGIC;

SIGNAL ovflo_2_re			: STD_LOGIC;
SIGNAL ovflo_2_im			: STD_LOGIC;

SIGNAL done_or_start			: STD_LOGIC;


SIGNAL ovflo_sdt			: STD_LOGIC:='0';
signal fft_busy_sms : std_logic:='0';
signal ovfl_invalid: std_logic:='0';
BEGIN

logic0 <= '0';
logic1 <= '1';
open_sclr <= '0';

ce_bf_gen : and_a_b_32_v3 PORT MAP (a_in => ce,
				b_in => start_bf,
				and_out =>ce_bf);

mux_select <= scale_factor;


ovflo_0_temp_re_or_im(0) <= ovflo_0_re_or_im;
ovflo_1_temp_re_or_im(0) <= ovflo_1_re_or_im;
ovflo_2_temp_re_or_im(0) <= ovflo_2_re_or_im;


upper_arm_adder_re: C_ADDSUB_V4_0
		   GENERIC MAP (C_A_WIDTH => B,
				C_B_WIDTH => B,
				C_OUT_WIDTH => B+1,
				C_LOW_BIT => 0,
				C_HIGH_BIT => B,
				C_ADD_MODE => 0,		--c_add,
				C_A_TYPE => 0,			--c_signed,
				C_B_TYPE => 0,			--c_signed,
				C_B_CONSTANT => 0,
				C_B_VALUE => "",
				C_AINIT_VAL => "0",
				C_SINIT_VAL => "0",
				C_BYPASS_ENABLE => 0,
				C_BYPASS_LOW => 0,
				--C_SYNC_ENABLE=> c_override; 	   
				--C_SYNC_PRIORITY	=> c_clear;	   
				C_PIPE_STAGES=> 1,
				C_HAS_S=> 0,
				C_HAS_Q	=> 1,
			 	C_HAS_C_IN =>1,  --0
				C_HAS_C_OUT=> 0,
				C_HAS_Q_C_OUT=> 0,
				C_HAS_B_IN => 0,
				C_HAS_B_OUT=> 0,
			 	C_HAS_Q_B_OUT=> 0,
			 	C_HAS_OVFL=> 0,
			 	C_HAS_Q_OVFL=> 0,
			 	C_HAS_CE => 1,
			 	C_HAS_ADD => 0,
			 	C_HAS_BYPASS=> 0,
			 	C_HAS_A_SIGNED=> 1,
			 	C_HAS_B_SIGNED=> 1,
			 	C_HAS_ACLR=> 0,
			 	C_HAS_ASET=> 0,
			 	C_HAS_AINIT=> 0,
			 	C_HAS_SCLR=> 0,
			 	C_HAS_SSET=> 0,
			 	C_HAS_SINIT=> 0,
			 	C_ENABLE_RLOCS=> 1)
		PORT MAP (	A => x0r, 
				B=> x1r, 
				CLK => clk,
				ADD => dummy_in,
				C_IN => logic0, --dummy_in,
				B_IN => dummy_in,
				CE => ce_bf, -- was ce,
				BYPASS => dummy_in,
				ACLR => dummy_in,
				ASET => dummy_in,
				AINIT => reset,
				SCLR => nc,
				SSET => nc,
				SINIT => nc,
				A_SIGNED => logic1,
				B_SIGNED => logic1,
				OVFL => open_ovfl,
				C_OUT => open_c_out,
				B_OUT => open_b_out,
				Q_OVFL => open_q_ovfl,
				Q_C_OUT => open_q_c_out,
				Q_B_OUT => open_q_b_out,
				S => open_s,
				Q => y0r_pre_delay);
 

upper_arm_adder_im: C_ADDSUB_V4_0
		   GENERIC MAP (C_A_WIDTH => B,
				C_B_WIDTH => B,
				C_OUT_WIDTH => B+2,
				C_LOW_BIT => 0,
				C_HIGH_BIT => B,
				C_ADD_MODE => 0,		-- c_add,
				C_A_TYPE => 0,			--c_signed,
				C_B_TYPE => 0,			--c_signed,
				C_B_CONSTANT => 0,
				C_B_VALUE => "",
				C_AINIT_VAL => "0",
				C_SINIT_VAL => "0",
				C_BYPASS_ENABLE => 0,
				C_BYPASS_LOW => 0,
				--C_SYNC_ENABLE=> c_override; 	   
				--C_SYNC_PRIORITY	=> c_clear,	   
				C_PIPE_STAGES=> 1,
				C_HAS_S=> 0,
				C_HAS_Q	=> 1,
			 	C_HAS_C_IN =>1,
				C_HAS_C_OUT=> 0,
				C_HAS_Q_C_OUT=> 0,
				C_HAS_B_IN => 0,
				C_HAS_B_OUT=> 0,
			 	C_HAS_Q_B_OUT=> 0,
			 	C_HAS_OVFL=> 0,
			 	C_HAS_Q_OVFL=> 0,
			 	C_HAS_CE => 1,
			 	C_HAS_ADD => 0,
			 	C_HAS_BYPASS=> 0,
			 	C_HAS_A_SIGNED=> 1,
			 	C_HAS_B_SIGNED=> 1,
			 	C_HAS_ACLR=> 0,
			 	C_HAS_ASET=> 0,
			 	C_HAS_AINIT=> 1,
			 	C_HAS_SCLR=> 0,
			 	C_HAS_SSET=> 0,
			 	C_HAS_SINIT=> 0,
			 	C_ENABLE_RLOCS=> 1)
		PORT MAP (	A => x0i,
				B=> x1i,
				CLK => clk,
				ADD => dummy_in,
				C_IN => logic0, --dummy_in,
				B_IN => dummy_in,
				CE => ce_bf, --was ce,
				BYPASS => dummy_in,
				ACLR => dummy_in,
				ASET => dummy_in,
				AINIT => reset,
				SCLR => nc,
				SSET => nc,
				SINIT => nc,
				A_SIGNED => logic1,
				B_SIGNED => logic1,
				OVFL => open_ovfl_1,
				C_OUT => open_c_out_1,
				B_OUT => open_b_out_1,
				Q_OVFL => open_q_ovfl_1,
				Q_C_OUT => open_q_c_out_1,
				Q_B_OUT => open_q_b_out_1,
				S => open_s_1,
				Q => y0i_pre_delay);

-------------------------------------------------------------------
-- TO sign extend to B+2 bits the result of the upper arm
-------------------------------------------------------------------


y0r_pre_delay_s_ext(B+1) <= y0r_pre_delay(B);
y0r_pre_delay_s_ext(B DOWNTO 0) <= y0r_pre_delay;

y0i_pre_delay_s_ext(B+1) <= y0i_pre_delay(B);
y0i_pre_delay_s_ext(B DOWNTO 0) <= y0i_pre_delay;

-------------------------------------------------------------------
-- TO compensate for the delay through multiplier in the lower arm
-------------------------------------------------------------------

delay_upper_arm_re: C_SHIFT_RAM_V4_0 
		GENERIC MAP (C_ADDR_WIDTH => 1,
				C_AINIT_VAL => ainit_val,
				C_DEPTH => delay_upper_arm_by,
				--C_DEFAULT_DATA => default_data,
				C_WIDTH => B+2,
				C_HAS_AINIT => 0,
				C_HAS_SINIT =>1,
				C_HAS_ACLR => 1,
				C_HAS_CE => 1)
		PORT MAP (A => dummy_addr,
			D => y0r_pre_delay_s_ext,
			CLK => clk,
			CE => ce_bf,
			ACLR => reset, --dummy_in,
			--ASET => dummy_in,
			--AINIT => dummy_in, --reset,
			--SCLR =>dummy_in,
			--SSET => dummy_in,
			SINIT => start,
			Q => int_y0r);

		
delay_upper_arm_im: C_SHIFT_RAM_V4_0 
		GENERIC MAP (C_ADDR_WIDTH => 1,
				C_AINIT_VAL => ainit_val,
				C_DEPTH => delay_upper_arm_by,
				--C_DEFAULT_DATA => default_data,
				C_WIDTH => B+2,
				C_HAS_AINIT => 0,
				C_HAS_SINIT =>1,
				C_HAS_ACLR => 1,
				C_HAS_CE => 1)
		PORT MAP (A => dummy_addr,
			D => y0i_pre_delay_s_ext,
			CLK => clk,
			CE => ce_bf,
			ACLR => reset, --dummy_in,
			--ASET => dummy_in,
			--AINIT => dummy_in, --reset,
			--SCLR =>dummy_in,
			--SSET => dummy_in,
			SINIT => start,
			Q => int_y0i);


lower_arm_subtr_re: C_ADDSUB_V4_0
		   GENERIC MAP (C_A_WIDTH => B,
				C_B_WIDTH => B,
				C_OUT_WIDTH => B+1,
				C_LOW_BIT => 0,
				C_HIGH_BIT => B,
				C_ADD_MODE => 1,		-- c_sub,
				C_A_TYPE => 0,			-- c_signed,
				C_B_TYPE => 0, 			-- c_signed,
				C_B_CONSTANT => 0,
				C_B_VALUE => "",
				C_AINIT_VAL => "0",
				C_SINIT_VAL => "0",
				C_BYPASS_ENABLE => 0,
				C_BYPASS_LOW => 0,
				--C_SYNC_ENABLE=> c_override, 	   
				--C_SYNC_PRIORITY	=> c_clear,	   
				C_PIPE_STAGES=> 1,
				C_HAS_S=> 0,
				C_HAS_Q	=> 1,
			 	C_HAS_C_IN =>0,
				C_HAS_C_OUT=> 0,
				C_HAS_Q_C_OUT=> 0,
				C_HAS_B_IN => 1,
				C_HAS_B_OUT=> 0,
			 	C_HAS_Q_B_OUT=> 0,
			 	C_HAS_OVFL=> 0,
			 	C_HAS_Q_OVFL=> 0,
			 	C_HAS_CE => 1,
			 	C_HAS_ADD => 0,
			 	C_HAS_BYPASS=> 0,
			 	C_HAS_A_SIGNED=> 1,
			 	C_HAS_B_SIGNED=> 1,
			 	C_HAS_ACLR=> 0,
			 	C_HAS_ASET=> 0,
			 	C_HAS_AINIT=> 1,
			 	C_HAS_SCLR=> 0,
			 	C_HAS_SSET=> 0,
			 	C_HAS_SINIT=> 0,
			 	C_ENABLE_RLOCS=> 1)
		PORT MAP (	A => x0r,
				B=>  x1r,
				CLK => clk,
				ADD => dummy_in,
				C_IN => dummy_in,
				B_IN => logic1,  -- YOU HAVE TO SET THIS TO 1 !!!!!
				CE => ce_bf, --was ce,
				BYPASS => dummy_in,
				ACLR => dummy_in,
				ASET => nc,
				AINIT => reset,
				SCLR => nc,
				SSET => nc,
				SINIT => nc,
				A_SIGNED => logic1,
				B_SIGNED => logic1,
				OVFL => open_ovfl_2,
				C_OUT => open_c_out_2,
				B_OUT => open_b_out_2,
				Q_OVFL => open_q_ovfl_2,
				Q_C_OUT => open_q_c_out_2,
				Q_B_OUT => open_q_b_out_2,
				S => open_s_2,
				Q => sub_to_mult_r);

lower_arm_subtr_im: C_ADDSUB_V4_0
		   GENERIC MAP (C_A_WIDTH => B,
				C_B_WIDTH => B,
				C_OUT_WIDTH => B+1,
				C_LOW_BIT => 0,
				C_HIGH_BIT => B,
				C_ADD_MODE => 1,		--c_sub,
				C_A_TYPE => 0,			--c_signed,
				C_B_TYPE => 0,			--c_signed,
				C_B_CONSTANT => 0,
				C_B_VALUE => "",
				C_AINIT_VAL => "0",
				C_SINIT_VAL => "0",
				C_BYPASS_ENABLE => 0,
				C_BYPASS_LOW => 0,
				--C_SYNC_ENABLE=> c_override, 	   
				--C_SYNC_PRIORITY	=> c_clear,	   
				C_PIPE_STAGES=> 1,
				C_HAS_S=> 0,
				C_HAS_Q	=> 1,
			 	C_HAS_C_IN =>0,
				C_HAS_C_OUT=> 0,
				C_HAS_Q_C_OUT=> 0,
				C_HAS_B_IN => 1,
				C_HAS_B_OUT=> 0,
			 	C_HAS_Q_B_OUT=> 0,
			 	C_HAS_OVFL=> 0,
			 	C_HAS_Q_OVFL=> 0,
			 	C_HAS_CE => 1,
			 	C_HAS_ADD => 0,
			 	C_HAS_BYPASS=> 0,
			 	C_HAS_A_SIGNED=> 1,
			 	C_HAS_B_SIGNED=> 1,
			 	C_HAS_ACLR=> 0,
			 	C_HAS_ASET=> 0,
			 	C_HAS_AINIT=> 1,
			 	C_HAS_SCLR=> 0,
			 	C_HAS_SSET=> 0,
			 	C_HAS_SINIT=> 0,
			 	C_ENABLE_RLOCS=> 1)
		PORT MAP (	A =>  x0i,
				B=>  x1i,
				CLK => clk,
				ADD => dummy_in,
				C_IN => dummy_in,
				B_IN => logic1,  -- MUST SET TO 1 !!!!
				CE => ce_bf, --was ce,
				BYPASS => dummy_in,
				ACLR => dummy_in,
				ASET => dummy_in,
				AINIT => reset,
				SCLR => nc,
				SSET => nc,
				SINIT => nc,
				A_SIGNED => logic1,
				B_SIGNED => logic1,
				OVFL => open_ovfl_3,
				C_OUT => open_c_out_3,
				B_OUT => open_b_out_3,
				Q_OVFL => open_q_ovfl_3,
				Q_C_OUT => open_q_c_out_3,
				Q_B_OUT => open_q_b_out_3,
				S => open_s_3,
				Q => sub_to_mult_i);



mult: complex_mult_v3
	GENERIC MAP (a_width => B+1,
		     b_width => W_WIDTH,
		     mult_type => mult_type)
	PORT MAP    (ar => sub_to_mult_r,
		     ai => sub_to_mult_i,
		     br => wr,
		     bi => wi,
		     clk => clk,
		     ce => ce_bf,  --was ce
		     reset => reset,
		     start => start,
		     p_re => p_re_full_precision,  		--y1r,
		     p_im => p_im_full_precision); 		--y1i);	


--------scale factor =0--------------------------------------------------------------
-- Can send only B bits back to memory. 
-- With 0 scaling, bits to send back are:
-- y0: qb-1 + qb-1 = qb-1
-- hence send full precison (b-1 downto 0).
-- y1: on lower arm, inputs to complex mult are:qb x qw_width-1. 
-- ouput of complex mult is therefore qresult=qb+w_width-1.
-- look at bits result downto 0.
-- count down B from result. hence send back to memory result downto diff.
--diff = result -b.
-- y1 : (result-1 downto result-b)
  
p_re_temp_0scaled <=p_re_full_precision(result DOWNTO 0);
p_im_temp_0scaled <=p_im_full_precision(result DOWNTO 0);
-------------------------------------------------------------------------------------

-------scale factor =1----------------------------

p_re_temp_1scaled <=p_re_full_precision(result+1 DOWNTO 0);
p_im_temp_1scaled <=p_im_full_precision(result+1 DOWNTO 0);
--------------------------------------------------

-------scale factor =2----------------------------

p_re_temp_2scaled <=p_re_full_precision(result+2 DOWNTO 0);
p_im_temp_2scaled <=p_im_full_precision(result+2 DOWNTO 0);

--------------------------------------------------

y0r_scale0 <=  int_y0r(B-1 DOWNTO upperarm_diff0);
y0i_scale0 <=  int_y0i(B-1 DOWNTO upperarm_diff0);
y1r_scale0 <= p_re_temp_0scaled(result DOWNTO diff0+1);
y1i_scale0 <= p_im_temp_0scaled(result DOWNTO diff0+1);

y0r_scale1 <= int_y0r(B DOWNTO upperarm_diff0+1);
y0i_scale1 <= int_y0i(B DOWNTO upperarm_diff0+1);
y1r_scale1 <=  p_re_temp_1scaled(result+1 DOWNTO diff0+2);
y1i_scale1 <=  p_im_temp_1scaled(result+1 DOWNTO diff0+2);

y0r_scale2 <= int_y0r(B+1 DOWNTO upperarm_diff0+2);
y0i_scale2 <= int_y0i(B+1 DOWNTO upperarm_diff0+2);
y1r_scale2 <=  p_re_temp_2scaled(result+2 DOWNTO diff0+3);
y1i_scale2 <=  p_im_temp_2scaled(result+2 DOWNTO diff0+3);


--- Overflow scale 0 ---
ovfl_gen_scale0: FOR i IN result+1 To xmul_full_pr_width-1 GENERATE 
		xor_gen: xor_a_b_32_v3 PORT MAP(a_in =>p_re_full_precision(i),
				b_in => p_re_temp_0scaled(result),
				xor_out => ovflo_0_int(i));
END GENERATE ovfl_gen_scale0;

or_gen_scale_0_first_stage: or_a_b_32_v3 PORT MAP (a_in => ovflo_0_int(result+1),
						b_in => ovflo_0_int(result+2),
						or_out => or_out_0(result+2));
or_gen_scale0: FOR i IN result+3 TO  xmul_full_pr_width-1 GENERATE
		or_gen: or_a_b_32_v3 PORT MAP (a_in => or_out_0(i-1),
						b_in => ovflo_0_int(i),
						or_out => or_out_0(i));
END GENERATE or_gen_scale0;


ovfl_gen_0: srflop_v3 PORT MAP (clk => clk,
				ce => ce,
				set => or_out_0(xmul_full_pr_width-1 ),
				reset => done_or_start,
				q => ovflo_0_re);
----------------------------------------------------------------------------------------------

--- Overflow scale 1 ---

ovfl_gen_scale1: FOR i IN result+2 To xmul_full_pr_width-1 GENERATE
		xor_gen: xor_a_b_32_v3 PORT MAP(a_in =>p_re_full_precision(i),
				b_in => p_re_temp_1scaled(result+1),
				xor_out => ovflo_1_int(i));
END GENERATE ovfl_gen_scale1;

or_gen_scale_1_first_stage: or_a_b_32_v3 PORT MAP (a_in => ovflo_1_int(result+2),
						b_in => ovflo_1_int(result+3),
						or_out => or_out_1(result+3));
or_gen_scale1: FOR i IN result+4 TO  xmul_full_pr_width-1 GENERATE
		or_gen: or_a_b_32_v3 PORT MAP (a_in => or_out_1(i-1),
						b_in => ovflo_1_int(i),
						or_out => or_out_1(i));
END GENERATE or_gen_scale1;


ovfl_gen_1: srflop_v3 PORT MAP (clk => clk,
				ce => ce,
				set => or_out_1(xmul_full_pr_width-1 ),
				reset => done_or_start,
				q => ovflo_1_re);

----------------------------------------------------------------------------------------------

--- Overflow scale 2 ---
ovfl_gen_scale2: FOR i IN result+3 To xmul_full_pr_width-1 GENERATE
		xor_gen: xor_a_b_32_v3 PORT MAP(a_in =>p_re_full_precision(i),
				b_in => p_re_temp_2scaled(result+2),
				xor_out => ovflo_2_int(i));
END GENERATE ovfl_gen_scale2;

or_gen_scale_2_first_stage: or_a_b_32_v3 PORT MAP (a_in => ovflo_1_int(result+3),
						b_in => ovflo_2_int(result+4),
						or_out => or_out_2(result+4));
or_gen_scale2: FOR i IN result+5 TO  xmul_full_pr_width-1 GENERATE
		or_gen: or_a_b_32_v3 PORT MAP (a_in => or_out_2(i-1),
						b_in => ovflo_2_int(i),
						or_out => or_out_2(i));
END GENERATE or_gen_scale2;



ovfl_gen_2: srflop_v3 PORT MAP (clk => clk,
				ce => ce,
				set => or_out_2(xmul_full_pr_width-1 ),
				reset => done_or_start,
				q => ovflo_2_re);

----------------------------------------------------------------------------------------------
--- Imaginary ---
--- Overflow scale 0 ---
ovfl_gen_scale0_im: FOR i IN result+1 To xmul_full_pr_width-1 GENERATE --(B + 1 + W_WIDTH +1-1) DOWNTO result+1 GENERATE
		xor_gen: xor_a_b_32_v3 PORT MAP(a_in =>p_im_full_precision(i),
				b_in => p_im_temp_0scaled(result),
				xor_out => ovflo_0_int_im(i));
END GENERATE ovfl_gen_scale0_im;

or_gen_scale_0_first_stage_im: or_a_b_32_v3 PORT MAP (a_in => ovflo_0_int_im(result+1),
						b_in => ovflo_0_int_im(result+2),
						or_out => or_out_0_im(result+2));
or_gen_scale0_im: FOR i IN result+3 TO  xmul_full_pr_width-1 GENERATE
		or_gen: or_a_b_32_v3 PORT MAP (a_in => or_out_0_im(i-1),
						b_in => ovflo_0_int_im(i),
						or_out => or_out_0_im(i));
END GENERATE or_gen_scale0_im;



ovfl_gen_0_im: srflop_v3 PORT MAP (clk => clk,
				ce => ce,
				set => or_out_0_im(xmul_full_pr_width-1 ),
				reset => done_or_start,
				q => ovflo_0_im);

----------------------------------------------------------------------------------------------

--- Overflow scale 1 ---

ovfl_gen_scale1_im: FOR i IN result+2 To xmul_full_pr_width-1 GENERATE
		xor_gen_im: xor_a_b_32_v3 PORT MAP(a_in =>p_im_full_precision(i),
				b_in => p_im_temp_1scaled(result+1),
				xor_out => ovflo_1_int_im(i));
END GENERATE ovfl_gen_scale1_im;

or_gen_scale_1_first_stage_im: or_a_b_32_v3 PORT MAP (a_in => ovflo_1_int_im(result+2),
						b_in => ovflo_1_int_im(result+3),
						or_out => or_out_1_im(result+3));
or_gen_scale1_im: FOR i IN result+4 TO  xmul_full_pr_width-1 GENERATE
		or_gen_im: or_a_b_32_v3 PORT MAP (a_in => or_out_1_im(i-1),
						b_in => ovflo_1_int_im(i),
						or_out => or_out_1_im(i));
END GENERATE or_gen_scale1_im;


ovfl_gen_1_im: srflop_v3 PORT MAP (clk => clk,
				ce => ce,
				set => or_out_1_im(xmul_full_pr_width-1 ),
				reset => done_or_start,
				q => ovflo_1_im);
----------------------------------------------------------------------------------------------

--- Overflow scale 2 ---
ovfl_gen_scale2_im: FOR i IN result+3 To xmul_full_pr_width-1 GENERATE
		xor_gen_im: xor_a_b_32_v3 PORT MAP(a_in =>p_im_full_precision(i),
				b_in => p_im_temp_2scaled(result+2),
				xor_out => ovflo_2_int_im(i));
END GENERATE ovfl_gen_scale2_im;

or_gen_scale_2_first_stage_im: or_a_b_32_v3 PORT MAP (a_in => ovflo_1_int_im(result+3),
						b_in => ovflo_2_int_im(result+4),
						or_out => or_out_2_im(result+4));
or_gen_scale2_im: FOR i IN result+5 TO  xmul_full_pr_width-1 GENERATE
		or_gen: or_a_b_32_v3 PORT MAP (a_in => or_out_2_im(i-1),
						b_in => ovflo_2_int_im(i),
						or_out => or_out_2_im(i));
END GENERATE or_gen_scale2_im;


ovfl_gen_2_im: srflop_v3 PORT MAP (clk => clk,
				ce => ce,
				set => or_out_2_im(xmul_full_pr_width-1 ),
				reset => done_or_start,
				q => ovflo_2_im);

----------------------------------------------------------------------------------------------

---OR results of real & im ovfl outputs for scale0, scale1 and scale2

or_sc0 : or_a_b_32_v3 PORT MAP (a_in => ovflo_0_re,
				b_in => ovflo_0_im,
				or_out => ovflo_0_re_or_im);

or_sc1 : or_a_b_32_v3 PORT MAP (a_in => ovflo_1_re,
				b_in => ovflo_1_im,
				or_out => ovflo_1_re_or_im);

or_sc2 : or_a_b_32_v3 PORT MAP (a_in => ovflo_2_re,
				b_in => ovflo_2_im,
				or_out => ovflo_2_re_or_im);

scaled_result_mux_y0r :  c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH => B,
					C_INPUTS => 3,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0,
					C_SEL_WIDTH => 2)
			PORT MAP ( MA=> y0r_scale0, --bfly_y0r,
					MB => y0r_scale1, --bfly_y1r,
					MC => y0r_scale2,
					MD => dummy_mux_inputs,
					ME => dummy_mux_inputs,
					MF => dummy_mux_inputs,
					MG => dummy_mux_inputs,
					MH => dummy_mux_inputs,
					MAA 	=> dummy_mux_inputs,
					MAB 	=> dummy_mux_inputs,
					MAC 	=> dummy_mux_inputs,
					MAD 	=> dummy_mux_inputs,
					MAE 	=> dummy_mux_inputs,
					MAF 	=> dummy_mux_inputs,
					MAG 	=> dummy_mux_inputs,
					MAH 	=> dummy_mux_inputs,
					MBA 	=> dummy_mux_inputs,
					MBB 	=> dummy_mux_inputs,
					MBC 	=> dummy_mux_inputs,
					MBD 	=> dummy_mux_inputs,
					MBE 	=> dummy_mux_inputs,
					MBF 	=> dummy_mux_inputs,
					MBG 	=> dummy_mux_inputs,
					MBH 	=> dummy_mux_inputs,
					MCA 	=> dummy_mux_inputs,
					MCB 	=> dummy_mux_inputs,
					MCC 	=> dummy_mux_inputs,
					MCD 	=> dummy_mux_inputs,
					MCE 	=> dummy_mux_inputs,
					MCF 	=> dummy_mux_inputs,
					MCG 	=> dummy_mux_inputs,
					MCH 	=> dummy_mux_inputs,
					S => mux_select,
		  			CLK 	=>dummy_in, -- Optional clock
		  			CE 	=>dummy_in,  -- Optional Clock enable
		  			EN 	=>dummy_in,  -- Optional BUFT enable
		  			ASET 	=>dummy_in, -- optional asynch set to '1'
		  			ACLR 	=>dummy_in, -- Asynch init.
		  			AINIT =>dummy_in, -- optional asynch reset to init_val
		  			SSET	=>dummy_in, -- optional synch set to '1'
		  			SCLR 	=>dummy_in, -- Synch init.
		  			SINIT	=>dummy_in,	
					O => y0r, 
					Q => open_q_r);

scaled_result_mux_y0i :  c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH => B,
					C_INPUTS => 3,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0,
					C_SEL_WIDTH => 2)
			PORT MAP ( MA=> y0i_scale0, --bfly_y0r,
					MB => y0i_scale1, --bfly_y1r,
					MC => y0i_scale2,
					MD => dummy_mux_inputs,
					ME => dummy_mux_inputs,
					MF => dummy_mux_inputs,
					MG => dummy_mux_inputs,
					MH => dummy_mux_inputs,
					MAA 	=> dummy_mux_inputs,
					MAB 	=> dummy_mux_inputs,
					MAC 	=> dummy_mux_inputs,
					MAD 	=> dummy_mux_inputs,
					MAE 	=> dummy_mux_inputs,
					MAF 	=> dummy_mux_inputs,
					MAG 	=> dummy_mux_inputs,
					MAH 	=> dummy_mux_inputs,
					MBA 	=> dummy_mux_inputs,
					MBB 	=> dummy_mux_inputs,
					MBC 	=> dummy_mux_inputs,
					MBD 	=> dummy_mux_inputs,
					MBE 	=> dummy_mux_inputs,
					MBF 	=> dummy_mux_inputs,
					MBG 	=> dummy_mux_inputs,
					MBH 	=> dummy_mux_inputs,
					MCA 	=> dummy_mux_inputs,
					MCB 	=> dummy_mux_inputs,
					MCC 	=> dummy_mux_inputs,
					MCD 	=> dummy_mux_inputs,
					MCE 	=> dummy_mux_inputs,
					MCF 	=> dummy_mux_inputs,
					MCG 	=> dummy_mux_inputs,
					MCH 	=> dummy_mux_inputs,
					S => mux_select,
		  			CLK 	=>dummy_in, -- Optional clock
		  			CE 	=>dummy_in,  -- Optional Clock enable
		  			EN 	=>dummy_in,  -- Optional BUFT enable
		  			ASET 	=>dummy_in, -- optional asynch set to '1'
		  			ACLR 	=>dummy_in, -- Asynch init.
		  			AINIT =>dummy_in, -- optional asynch reset to init_val
		  			SSET	=>dummy_in, -- optional synch set to '1'
		  			SCLR 	=>dummy_in, -- Synch init.
		  			SINIT	=>dummy_in,	
					O => y0i, 
					Q => open_q_i);

scaled_result_mux_y1r :  c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH => B,
					C_INPUTS => 3,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0,
					C_SEL_WIDTH => 2)
			PORT MAP ( MA=> y1r_scale0, --bfly_y0r,
					MB => y1r_scale1, --bfly_y1r,
					MC => y1r_scale2,
					MD => dummy_mux_inputs,
					ME => dummy_mux_inputs,
					MF => dummy_mux_inputs,
					MG => dummy_mux_inputs,
					MH => dummy_mux_inputs,
					MAA 	=> dummy_mux_inputs,
					MAB 	=> dummy_mux_inputs,
					MAC 	=> dummy_mux_inputs,
					MAD 	=> dummy_mux_inputs,
					MAE 	=> dummy_mux_inputs,
					MAF 	=> dummy_mux_inputs,
					MAG 	=> dummy_mux_inputs,
					MAH 	=> dummy_mux_inputs,
					MBA 	=> dummy_mux_inputs,
					MBB 	=> dummy_mux_inputs,
					MBC 	=> dummy_mux_inputs,
					MBD 	=> dummy_mux_inputs,
					MBE 	=> dummy_mux_inputs,
					MBF 	=> dummy_mux_inputs,
					MBG 	=> dummy_mux_inputs,
					MBH 	=> dummy_mux_inputs,
					MCA 	=> dummy_mux_inputs,
					MCB 	=> dummy_mux_inputs,
					MCC 	=> dummy_mux_inputs,
					MCD 	=> dummy_mux_inputs,
					MCE 	=> dummy_mux_inputs,
					MCF 	=> dummy_mux_inputs,
					MCG 	=> dummy_mux_inputs,
					MCH 	=> dummy_mux_inputs,
					S => mux_select,
		  			CLK 	=>dummy_in, -- Optional clock
		  			CE 	=>dummy_in,  -- Optional Clock enable
		  			EN 	=>dummy_in,  -- Optional BUFT enable
		  			ASET 	=>dummy_in, -- optional asynch set to '1'
		  			ACLR 	=>dummy_in, -- Asynch init.
		  			AINIT =>dummy_in, -- optional asynch reset to init_val
		  			SSET	=>dummy_in, -- optional synch set to '1'
		  			SCLR 	=>dummy_in, -- Synch init.
		  			SINIT	=>dummy_in,	
					O => y1r, 
					Q => open_q_r);

scaled_result_mux_y1i :  c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH => B,
					C_INPUTS => 3,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0,
					C_SEL_WIDTH => 2)
			PORT MAP ( MA=> y1i_scale0, --bfly_y0r,
					MB => y1i_scale1, --bfly_y1r,
					MC => y1i_scale2,
					MD => dummy_mux_inputs,
					ME => dummy_mux_inputs,
					MF => dummy_mux_inputs,
					MG => dummy_mux_inputs,
					MH => dummy_mux_inputs,
					MAA 	=> dummy_mux_inputs,
					MAB 	=> dummy_mux_inputs,
					MAC 	=> dummy_mux_inputs,
					MAD 	=> dummy_mux_inputs,
					MAE 	=> dummy_mux_inputs,
					MAF 	=> dummy_mux_inputs,
					MAG 	=> dummy_mux_inputs,
					MAH 	=> dummy_mux_inputs,
					MBA 	=> dummy_mux_inputs,
					MBB 	=> dummy_mux_inputs,
					MBC 	=> dummy_mux_inputs,
					MBD 	=> dummy_mux_inputs,
					MBE 	=> dummy_mux_inputs,
					MBF 	=> dummy_mux_inputs,
					MBG 	=> dummy_mux_inputs,
					MBH 	=> dummy_mux_inputs,
					MCA 	=> dummy_mux_inputs,
					MCB 	=> dummy_mux_inputs,
					MCC 	=> dummy_mux_inputs,
					MCD 	=> dummy_mux_inputs,
					MCE 	=> dummy_mux_inputs,
					MCF 	=> dummy_mux_inputs,
					MCG 	=> dummy_mux_inputs,
					MCH 	=> dummy_mux_inputs,
					S => mux_select,
		  			CLK 	=>dummy_in, -- Optional clock
		  			CE 	=>dummy_in,  -- Optional Clock enable
		  			EN 	=>dummy_in,  -- Optional BUFT enable
		  			ASET 	=>dummy_in, -- optional asynch set to '1'
		  			ACLR 	=>dummy_in, -- Asynch init.
		  			AINIT =>dummy_in, -- optional asynch reset to init_val
		  			SSET	=>dummy_in, -- optional synch set to '1'
		  			SCLR 	=>dummy_in, -- Synch init.
		  			SINIT	=>dummy_in,	
					O => y1i, 
					Q => open_q_i);


ovflo_mux: c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH => 1,
					C_INPUTS => 3,
					C_HAS_O => 0,
					C_HAS_Q => 1,
					C_HAS_CE => 1,
					C_HAS_ACLR => 1,
					C_HAS_EN => 0,
					C_SEL_WIDTH => 2)
			PORT MAP ( MA=> ovflo_0_temp_re_or_im, 
					MB => ovflo_1_temp_re_or_im,
					MC => ovflo_2_temp_re_or_im,
					MD => dummy_mux_inputs_ovflo,
					ME => dummy_mux_inputs_ovflo,
					MF => dummy_mux_inputs_ovflo,
					MG => dummy_mux_inputs_ovflo,
					MH => dummy_mux_inputs_ovflo,
					MAA 	=> dummy_mux_inputs_ovflo,
					MAB 	=> dummy_mux_inputs_ovflo,
					MAC 	=> dummy_mux_inputs_ovflo,
					MAD 	=> dummy_mux_inputs_ovflo,
					MAE 	=> dummy_mux_inputs_ovflo,
					MAF 	=> dummy_mux_inputs_ovflo,
					MAG 	=> dummy_mux_inputs_ovflo,
					MAH 	=> dummy_mux_inputs_ovflo,
					MBA 	=> dummy_mux_inputs_ovflo,
					MBB 	=> dummy_mux_inputs_ovflo,
					MBC 	=> dummy_mux_inputs_ovflo,
					MBD 	=> dummy_mux_inputs_ovflo,
					MBE 	=> dummy_mux_inputs_ovflo,
					MBF 	=> dummy_mux_inputs_ovflo,
					MBG 	=> dummy_mux_inputs_ovflo,
					MBH 	=> dummy_mux_inputs_ovflo,
					MCA 	=> dummy_mux_inputs_ovflo,
					MCB 	=> dummy_mux_inputs_ovflo,
					MCC 	=> dummy_mux_inputs_ovflo,
					MCD 	=> dummy_mux_inputs_ovflo,
					MCE 	=> dummy_mux_inputs_ovflo,
					MCF 	=> dummy_mux_inputs_ovflo,
					MCG 	=> dummy_mux_inputs_ovflo,
					MCH 	=> dummy_mux_inputs_ovflo,
					S => mux_select,
		  			CLK 	=>clk, -- Optional clock
		  			CE 	=>ce,  -- Optional Clock enable
		  			EN 	=>dummy_in,  -- Optional BUFT enable
		  			ASET 	=>dummy_in, -- optional asynch set to '1'
		  			ACLR 	=>done_or_start, -- Asynch init.
		  			AINIT 	=>dummy_in, -- optional asynch reset to init_val
		  			SSET	=>dummy_in, -- optional synch set to '1'
		  			SCLR 	=>dummy_in, -- Synch init.
		  			SINIT	=>dummy_in,	
					O => open_q_ovflo, --ovflo_temp, 
					Q => ovflo_temp); --open_q_ovflo);



ovfl_gen: srflop_v3 PORT MAP (clk => clk,
				ce => ce,
				set => ovflo_temp(0),
				reset => done_or_start,
				q => ovflo_sdt);
				
sms_gen: IF memory_architecture=1 GENERATE
done_or_start <= start; --done or start;--was start vk nov301

process (clk)
begin
if  edone_s='1' then
  ovfl_invalid<='1';
 else if clk'event and clk='1' then
  if start='1' then
   ovfl_invalid<='0';
   end if;
end if;
end if;
end process;

process ( clk)
begin
if done='1' then
 fft_busy_sms<='0';
 else if clk'event and clk='1' then
  if start='1' then
   fft_busy_sms<='1';
   end if;
  end if;
 end if; 
 end process;
 
 process (clk)
 begin
 if clk'event and clk='1' then
  if (ovfl_invalid='1' or fft_busy_sms='0') then
    ovflo <= '0';
   else ovflo <= ovflo_sdt;
   end if;
   end if;
 end process;
END GENERATE sms_gen;

dtms_gen: IF (memory_architecture=2) or (memory_architecture=3) GENERATE
done_or_start <= done or start;
END GENERATE dtms_gen;

--vknov901
dov: if memory_architecture=2 GENERATE
process (clk)
begin
if clk'event and clk='1' then
 if io_out='1' or busy_in='0' then
 ovflo <= '0';
 else ovflo <= ovflo_sdt;
end if;
end if;
end process;
end GENERATE dov;

tov: IF memory_architecture=3 GENERATE
process (clk)
begin
if clk'event and clk='1' then
  if busy_in='0' then
  ovflo <= '0';
  else
  ovflo <= ovflo_sdt;
  end if;
end if;
end process;
end GENERATE tov;

END behavioral;
---------------------------------END butterfly_v3.vhd----------------------------------------------

--------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
--------------------------------------------------------------------------
-- Last modified on 03/06/00
-- Name : butterfly_32_v3.vhd
-- Function : This contains a butterfly and conjugation/registers for data
--		: inputs. The data bus is shared. Data is loaded into the first
--		: cong_reg and then the second. Data load is controlled by
--		: two-state state machine.
-- 04/07/00 : Initial rev. of file.
-- Last modified on 04/07/00
---------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

		
LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_REG_FD_V4_0_comp.all;
USE XilinxCoreLib.C_TWOS_COMP_V4_0_comp.all;
USE XilinxCoreLib.vfft32_comps_v3.all;
USE XilinxCoreLib.vfft32_pkg_v3.all;
	
ENTITY butterfly_32_v3 is
	GENERIC (B	: INTEGER;
		   W_WIDTH : INTEGER;
		memory_architecture : INTEGER;
		mult_type:	INTEGER :=1); --0 selects lut mult, 1 selects emb v2 mult
	PORT (	clk	: IN STD_LOGIC;
		ce	: IN STD_LOGIC;
		start: IN STD_LOGIC;
		reset	: IN STD_LOGIC;
		conj	: IN STD_LOGIC;
		dr	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);
		di	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);
		scale_factor : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		done	: IN STD_LOGIC;
		ce_phase_factors: OUT STD_LOGIC;
		y0r	: OUT STD_LOGIC_VECTOR(B-1 DOWNTO 0);  --Re result 0  --was (B downto 0)
		y0i	: OUT STD_LOGIC_VECTOR(B-1 DOWNTO 0);  --Im result 0  --was (B downto 0)
		y1r	: OUT STD_LOGIC_VECTOR(B-1  DOWNTO 0);  --Re result 1  --was (B downto 0)
		y1i	: OUT STD_LOGIC_VECTOR(B-1  DOWNTO 0);  --Im result 1  --was (B downto 0)
		ovflo	: OUT STD_LOGIC;
		wi	: IN STD_LOGIC_VECTOR(W_WIDTH-1 DOWNTO 0);  --Re omega
		wr	: IN STD_LOGIC_VECTOR(W_WIDTH-1 DOWNTO 0);
		io_out : in std_logic;
		edone_s : in std_logic;
		busy_in: in std_logic
		);  --Im omega
END butterfly_32_v3;

ARCHITECTURE behavioral OF butterfly_32_v3 IS

signal ce0		: std_logic;		-- sample reg. ld enables
signal ce1		: std_logic;
signal cex0		: std_logic;		-- sample reg. ld enables
signal cex1		: std_logic;
SIGNAL int_cex1		: STD_LOGIC;
SIGNAL int_cex0		: STD_LOGIC;
signal start_butterfly_32	: std_logic;		-- start 4-point FFT
		-- registered samples presented to butterfly
signal x0r		: std_logic_vector(B-1 downto 0); 
signal x0i		: std_logic_vector(B-1 downto 0); 
signal int_x0r		: std_logic_vector(B-1 downto 0); 
signal int_x0i		: std_logic_vector(B-1 downto 0); 
signal x1r		: std_logic_vector(B-1 downto 0); 
signal x1i		: std_logic_vector(B-1 downto 0); 
		-- registered outputs for butterfly #0

signal	conji		: std_logic;

SIGNAL	w_logic0	: STD_LOGIC_VECTOR(W_WIDTH-1 DOWNTO 0):= (OTHERS => '0');
SIGNAL	w_logic_minus_j	: STD_LOGIC_VECTOR(W_WIDTH-1 DOWNTO 0):= (OTHERS => '1'); -- -1
SIGNAL logic0		: STD_LOGIC := '0';
SIGNAL w_logic1		: STD_LOGIC_VECTOR(W_WIDTH-1 DOWNTO 0); 
SIGNAL	cex1x0	: STD_LOGIC_VECTOR(2-1 DOWNTO 0);

SIGNAL wr_delay3	:STD_LOGIC_VECTOR(W_WIDTH-1 DOWNTO 0); --for xcc:= (OTHERS => '0'); 
SIGNAL wi_delay3	:STD_LOGIC_VECTOR(W_WIDTH-1 DOWNTO 0);--for xcc:= (OTHERS => '0'); 
SIGNAL dummy_addr	:STD_LOGIC_VECTOR(0 DOWNTO 0):= (OTHERS => '0');

-- complex conjugation. Instantiated twice. Each instance is gated off a 
-- separate clock enable. This is to be able to read in the 4 different 
-- pieces of data from memory. The clock enable distribution is controlled 
-- by the state machine.
-- Complex conjugation is to support inverse transforms controlled by 
-- the conj pin. When the inverse transform is reqd., the imaginary part
-- is two's complemented and the real part is simply registered. When inverse
-- transform is not reqd., both real and imaginary parts are registered.




BEGIN

w_logic0 <= (OTHERS => '0');
--w_logic1 <= conv_std_logic_vector(1, W_WIDTH);
w_logic1(0) <= '1';                                     ---vk aug14
w_logic1(W_WIDTH-1 DOWNTO 1) <=(OTHERS => '0');		---vk aug14
w_logic_minus_j <= (OTHERS => '1');
logic0 <= '0';
int_cex1 <= cex1x0(0);  --flipped!
int_cex0 <= cex1x0(1);

dummy_addr <= (OTHERS => '0');

state_mc : state_machine_v3
	GENERIC MAP (n =>2)
	PORT MAP (clk => clk,
		    ce => ce,
		    start => start,
		    reset => reset,
		    s => cex1x0);

register_cex1 : flip_flop_sclr_v3 
	PORT MAP (d => int_cex1,
		ce => ce,
		clk => clk,
		reset => reset,
		sclr => start,
		q => cex1);

register_cex0 : flip_flop_sclr_v3 
	PORT MAP (d => int_cex0,
		ce => ce,
		clk => clk,
		reset => reset,
		sclr => start,
		q => cex0);

x0_reg : complex_reg_conj_v3
	GENERIC MAP (B => B)
	PORT MAP (
		clk		=> clk,
		ce		=> ce0,
		conj		=> conji,
		dr		=> dr,
		di		=> di,
		qr		=> x0r,--int_x0r,--			-- Re
		qi		=> x0i --int_x0i			-- Im
	);

x1_reg : complex_reg_conj_v3
	GENERIC MAP (B => B)
	PORT MAP (
		clk		=> clk,
		ce		=> ce1,
		conj		=> conji,
		dr		=> dr,
		di		=> di,
		qr		=> x1r,			-- Re
		qi		=> x1i			-- Im
	);



--delay the omegas by 3 clocks so they line up with input samples 
-- correctly at butterfly inputs

delay3_wr: delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH => 1,
					DEPTH =>  2,
					DATA_WIDTH => W_WIDTH)
				PORT MAP (addr => dummy_addr,
					data => wr,
					clk => start_butterfly_32, --clk,
					reset => reset,
					start => start,
					delayed_data => wr_delay3);

delay3_wi: delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH => 1,
					DEPTH => 2,
					DATA_WIDTH => W_WIDTH)
				PORT MAP (addr => dummy_addr,
					data => wi,
					clk => start_butterfly_32, --clk,
					reset => reset,
					start => start,
					delayed_data => wi_delay3);

	
b0 : butterfly_v3
	GENERIC MAP (B => B,
			 W_WIDTH => W_WIDTH,
		memory_architecture => memory_architecture,
		mult_type => mult_type)
	PORT MAP (
		clk		=> clk,			-- mast clock
		ce		=> ce,			-- master clock enable
		start_bf	=> start_butterfly_32,
		start		=> start,
		reset		=> logic0,
		scale_factor	=> scale_factor,
		done		=> done,
		x0r		=> x0r,
		x0i		=> x0i,	
		x1r		=> x1r,
		x1i		=> x1i,	
		y0r		=> y0r, --b0_y0r,
		y0i		=> y0i, --b0_y0i,	
		y1r		=> y1r, --b0_y1r,	
		y1i		=> y1i, --b0_y1i,
		ovflo		=> ovflo,
		wr		=> wr_delay3, --wr,
		wi		=> wi_delay3, --wi
		io_out => io_out,
		edone_s => edone_s,
		busy_in => busy_in
	);
	
			

gen_start: and_a_b_32_v3 PORT MAP(a_in => ce,
					b_in => cex0,
					and_out => start_butterfly_32);
gen_ce0: and_a_b_32_v3 PORT MAP(a_in => ce,
					b_in => cex0,
					and_out => ce0);

gen_ce1: and_a_b_32_v3 PORT MAP(a_in => ce,
					b_in => cex1,
					and_out => ce1);


	conji <= conj;					
ce_phase_factors <= start_butterfly_32;
END behavioral;

--------------------END butterfly_32_v3.vhd--------------------------------------------------

---------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
---------------------------------------------------------------------------
--reduced bfly with w0=1

LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_REG_FD_V4_0_comp.all;
USE XilinxCoreLib.C_ADDSUB_V4_0_comp.all;
USE XilinxCoreLib.C_MUX_BUS_V4_0_comp.all;
USE XilinxCoreLib.vfft32_comps_v3.all;
USE XilinxCoreLib.vfft32_pkg_v3.all;

ENTITY bflyw0_v3 IS
	GENERIC (bfly_width : INTEGER);
	PORT (x0r	: IN STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
		x0i	: IN STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
		x1r	: IN STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
		x1i	: IN STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
		clk	: IN STD_LOGIC;
		ce 	: IN STD_LOGIC;
		start	: IN STD_LOGIC;
		reset : IN STD_LOGIC;
		scale_by : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		y0r	: OUT STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
		y0i	: OUT STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
		y1r	: OUT STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
		y1i	: OUT STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0)
		);
END bflyw0_v3;

ARCHITECTURE behavioral OF bflyw0_v3 IS

CONSTANT diff_with_0_scaling	: INTEGER := 1; --(bfly_width+1 - bfly_width) 

SIGNAL y0r_int	: STD_LOGIC_VECTOR(bfly_width DOWNTO 0);
SIGNAL y0i_int	: STD_LOGIC_VECTOR(bfly_width DOWNTO 0);
SIGNAL y1r_int	: STD_LOGIC_VECTOR(bfly_width DOWNTO 0);
SIGNAL y1i_int	: STD_LOGIC_VECTOR(bfly_width DOWNTO 0);

SIGNAL y0r_scale0 : STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
SIGNAL y0i_scale0 : STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
SIGNAL y1r_scale0 : STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
SIGNAL y1i_scale0 : STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
SIGNAL y0r_scale1 : STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
SIGNAL y0i_scale1 : STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
SIGNAL y1r_scale1 : STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
SIGNAL y1i_scale1 : STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);

--SIGNAL logic0		: STD_LOGIC	:='0';
SIGNAL logic1		: STD_LOGIC	:='1';
SIGNAL nc			: STD_LOGIC	:= '0';
SIGNAL dummy_in		: STD_LOGIC	:= '0';

--SIGNAL ce_bf		: STD_LOGIC; --for xcc	:= '0';

SIGNAL open_ovfl: STD_LOGIC;
SIGNAL open_c_out: STD_LOGIC;
SIGNAL open_b_out: STD_LOGIC;
SIGNAL open_q_ovfl: STD_LOGIC;
SIGNAL open_q_c_out: STD_LOGIC;
SIGNAL open_q_b_out: STD_LOGIC;
SIGNAL open_s: STD_LOGIC_VECTOR(bfly_width  DOWNTO 0);

SIGNAL open_ovfl_1: STD_LOGIC;
SIGNAL open_c_out_1: STD_LOGIC;
SIGNAL open_b_out_1: STD_LOGIC;
SIGNAL open_q_ovfl_1: STD_LOGIC;
SIGNAL open_q_c_out_1: STD_LOGIC;
SIGNAL open_q_b_out_1: STD_LOGIC;
SIGNAL open_s_1: STD_LOGIC_VECTOR(bfly_width  DOWNTO 0);

SIGNAL open_ovfl_2: STD_LOGIC;
SIGNAL open_c_out_2: STD_LOGIC;
SIGNAL open_b_out_2: STD_LOGIC;
SIGNAL open_q_ovfl_2: STD_LOGIC;
SIGNAL open_q_c_out_2: STD_LOGIC;
SIGNAL open_q_b_out_2: STD_LOGIC;
SIGNAL open_s_2: STD_LOGIC_VECTOR(bfly_width  DOWNTO 0);

SIGNAL open_ovfl_3: STD_LOGIC;
SIGNAL open_c_out_3: STD_LOGIC;
SIGNAL open_b_out_3: STD_LOGIC;
SIGNAL open_q_ovfl_3: STD_LOGIC;
SIGNAL open_q_c_out_3: STD_LOGIC;
SIGNAL open_q_b_out_3: STD_LOGIC;
SIGNAL open_s_3: STD_LOGIC_VECTOR(bfly_width  DOWNTO 0);
SIGNAL dummy_mux_inputs :STD_LOGIC_VECTOR(bfly_width-1  DOWNTO 0);
SIGNAL dummy_mux_inputs_1 :STD_LOGIC_VECTOR(bfly_width-1  DOWNTO 0);

SIGNAL mux_select : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL open_q_r	: STD_LOGIC_VECTOR(bfly_width-1  DOWNTO 0);
SIGNAL open_q_i	: STD_LOGIC_VECTOR(bfly_width-1  DOWNTO 0);

BEGIN

mux_select(0) <= scale_by(0);
dummy_mux_inputs <= (OTHERS => '0');
logic1 <= '1';
nc <= '0';
dummy_in <= '0';

upper_arm_adder_re: C_ADDSUB_V4_0
		   GENERIC MAP (C_A_WIDTH => bfly_width,
				C_B_WIDTH => bfly_width,
				C_OUT_WIDTH => bfly_width+1,
				C_LOW_BIT => 0,
				C_HIGH_BIT => bfly_width,
				C_ADD_MODE => 0,		--c_add,
				C_A_TYPE => 0,			--c_signed,
				C_B_TYPE => 0,			--c_signed,
				C_B_CONSTANT => 0,
				C_B_VALUE => "",
				C_AINIT_VAL => "0",
				C_SINIT_VAL => "0",
				C_BYPASS_ENABLE => 0,
				C_BYPASS_LOW => 0,
				--C_SYNC_ENABLE=> c_override; 	   
				--C_SYNC_PRIORITY	=> c_clear;	   
				C_PIPE_STAGES=> 1,
				C_HAS_S=> 0,
				C_HAS_Q	=> 1,
			 	C_HAS_C_IN =>0,
				C_HAS_C_OUT=> 0,
				C_HAS_Q_C_OUT=> 0,
				C_HAS_B_IN => 0,
				C_HAS_B_OUT=> 0,
			 	C_HAS_Q_B_OUT=> 0,
			 	C_HAS_OVFL=> 0,
			 	C_HAS_Q_OVFL=> 0,
			 	C_HAS_CE => 1,
			 	C_HAS_ADD => 0,
			 	C_HAS_BYPASS=> 0,
			 	C_HAS_A_SIGNED=> 1,
			 	C_HAS_B_SIGNED=> 1,
			 	C_HAS_ACLR=> 0,
			 	C_HAS_ASET=> 0,
			 	C_HAS_AINIT=> 0,
			 	C_HAS_SCLR=> 0,
			 	C_HAS_SSET=> 0,
			 	C_HAS_SINIT=> 0,
			 	C_ENABLE_RLOCS=> 1)
		PORT MAP (	A => x0r, 
				B=> x1r, 
				CLK => clk,
				ADD => dummy_in,
				C_IN => dummy_in,
				B_IN => dummy_in,
				CE => ce, --ce_bf, -- was ce,
				BYPASS => dummy_in,
				ACLR => dummy_in,
				ASET => dummy_in,
				AINIT => reset,
				SCLR => nc,
				SSET => nc,
				SINIT => nc,
				A_SIGNED => logic1,
				B_SIGNED => logic1,
				OVFL => open_ovfl,
				C_OUT => open_c_out,
				B_OUT => open_b_out,
				Q_OVFL => open_q_ovfl,
				Q_C_OUT => open_q_c_out,
				Q_B_OUT => open_q_b_out,
				S => open_s,
				Q => y0r_int);
 

upper_arm_adder_im: C_ADDSUB_V4_0
		   GENERIC MAP (C_A_WIDTH => bfly_width,
				C_B_WIDTH => bfly_width,
				C_OUT_WIDTH => bfly_width+1,
				C_LOW_BIT => 0,
				C_HIGH_BIT => bfly_width,
				C_ADD_MODE => 0,		-- c_add,
				C_A_TYPE => 0,			--c_signed,
				C_B_TYPE => 0,			--c_signed,
				C_B_CONSTANT => 0,
				C_B_VALUE => "",
				C_AINIT_VAL => "0",
				C_SINIT_VAL => "0",
				C_BYPASS_ENABLE => 0,
				C_BYPASS_LOW => 0,
				--C_SYNC_ENABLE=> c_override; 	   
				--C_SYNC_PRIORITY	=> c_clear,	   
				C_PIPE_STAGES=> 1,
				C_HAS_S=> 0,
				C_HAS_Q	=> 1,
			 	C_HAS_C_IN =>0,
				C_HAS_C_OUT=> 0,
				C_HAS_Q_C_OUT=> 0,
				C_HAS_B_IN => 0,
				C_HAS_B_OUT=> 0,
			 	C_HAS_Q_B_OUT=> 0,
			 	C_HAS_OVFL=> 0,
			 	C_HAS_Q_OVFL=> 0,
			 	C_HAS_CE => 1,
			 	C_HAS_ADD => 0,
			 	C_HAS_BYPASS=> 0,
			 	C_HAS_A_SIGNED=> 1,
			 	C_HAS_B_SIGNED=> 1,
			 	C_HAS_ACLR=> 0,
			 	C_HAS_ASET=> 0,
			 	C_HAS_AINIT=> 1,
			 	C_HAS_SCLR=> 0,
			 	C_HAS_SSET=> 0,
			 	C_HAS_SINIT=> 0,
			 	C_ENABLE_RLOCS=> 1)
		PORT MAP (	A => x0i,
				B=> x1i,
				CLK => clk,
				ADD => dummy_in,
				C_IN => dummy_in,
				B_IN => dummy_in,
				CE => ce, --ce_bf, --was ce,
				BYPASS => dummy_in,
				ACLR => dummy_in,
				ASET => dummy_in,
				AINIT => reset,
				SCLR => nc,
				SSET => nc,
				SINIT => nc,
				A_SIGNED => logic1,
				B_SIGNED => logic1,
				OVFL => open_ovfl_1,
				C_OUT => open_c_out_1,
				B_OUT => open_b_out_1,
				Q_OVFL => open_q_ovfl_1,
				Q_C_OUT => open_q_c_out_1,
				Q_B_OUT => open_q_b_out_1,
				S => open_s_1,
				Q => y0i_int);

lower_arm_subtr_re: C_ADDSUB_V4_0
		   GENERIC MAP (C_A_WIDTH => bfly_width,
				C_B_WIDTH => bfly_width,
				C_OUT_WIDTH => bfly_width+1,
				C_LOW_BIT => 0,
				C_HIGH_BIT => bfly_width,
				C_ADD_MODE => 1,		-- c_sub,
				C_A_TYPE => 0,			-- c_signed,
				C_B_TYPE => 0, 			-- c_signed,
				C_B_CONSTANT => 0,
				C_B_VALUE => "",
				C_AINIT_VAL => "0",
				C_SINIT_VAL => "0",
				C_BYPASS_ENABLE => 0,
				C_BYPASS_LOW => 0,
				--C_SYNC_ENABLE=> c_override, 	   
				--C_SYNC_PRIORITY	=> c_clear,	   
				C_PIPE_STAGES=> 1,
				C_HAS_S=> 0,
				C_HAS_Q	=> 1,
			 	C_HAS_C_IN =>0,
				C_HAS_C_OUT=> 0,
				C_HAS_Q_C_OUT=> 0,
				C_HAS_B_IN => 1, --0,
				C_HAS_B_OUT=> 0,
			 	C_HAS_Q_B_OUT=> 0,
			 	C_HAS_OVFL=> 0,
			 	C_HAS_Q_OVFL=> 0,
			 	C_HAS_CE => 1,
			 	C_HAS_ADD => 0,
			 	C_HAS_BYPASS=> 0,
			 	C_HAS_A_SIGNED=> 1,
			 	C_HAS_B_SIGNED=> 1,
			 	C_HAS_ACLR=> 0,
			 	C_HAS_ASET=> 0,
			 	C_HAS_AINIT=> 1,
			 	C_HAS_SCLR=> 0,
			 	C_HAS_SSET=> 0,
			 	C_HAS_SINIT=> 0,
			 	C_ENABLE_RLOCS=> 1)
		PORT MAP (	A => x0r,
				B=>  x1r,
				CLK => clk,
				ADD => dummy_in,
				C_IN => dummy_in,
				B_IN => logic1, --dummy_in,
				CE => ce, --ce_bf, --was ce,
				BYPASS => dummy_in,
				ACLR => dummy_in,
				ASET => nc,
				AINIT => reset,
				SCLR => nc,
				SSET => nc,
				SINIT => nc,
				A_SIGNED => logic1,
				B_SIGNED => logic1,
				OVFL => open_ovfl_2,
				C_OUT => open_c_out_2,
				B_OUT => open_b_out_2,
				Q_OVFL => open_q_ovfl_2,
				Q_C_OUT => open_q_c_out_2,
				Q_B_OUT => open_q_b_out_2,
				S => open_s_2,
				Q => y1r_int);

lower_arm_subtr_im: C_ADDSUB_V4_0
		   GENERIC MAP (C_A_WIDTH => bfly_width,
				C_B_WIDTH => bfly_width,
				C_OUT_WIDTH => bfly_width+1,
				C_LOW_BIT => 0,
				C_HIGH_BIT => bfly_width,
				C_ADD_MODE => 1,		--c_sub,
				C_A_TYPE => 0,			--c_signed,
				C_B_TYPE => 0,			--c_signed,
				C_B_CONSTANT => 0,
				C_B_VALUE => "",
				C_AINIT_VAL => "0",
				C_SINIT_VAL => "0",
				C_BYPASS_ENABLE => 0,
				C_BYPASS_LOW => 0,
				--C_SYNC_ENABLE=> c_override, 	   
				--C_SYNC_PRIORITY	=> c_clear,	   
				C_PIPE_STAGES=> 1,
				C_HAS_S=> 0,
				C_HAS_Q	=> 1,
			 	C_HAS_C_IN =>0,
				C_HAS_C_OUT=> 0,
				C_HAS_Q_C_OUT=> 0,
				C_HAS_B_IN => 1, --0,
				C_HAS_B_OUT=> 0,
			 	C_HAS_Q_B_OUT=> 0,
			 	C_HAS_OVFL=> 0,
			 	C_HAS_Q_OVFL=> 0,
			 	C_HAS_CE => 1,
			 	C_HAS_ADD => 0,
			 	C_HAS_BYPASS=> 0,
			 	C_HAS_A_SIGNED=> 1,
			 	C_HAS_B_SIGNED=> 1,
			 	C_HAS_ACLR=> 0,
			 	C_HAS_ASET=> 0,
			 	C_HAS_AINIT=> 1,
			 	C_HAS_SCLR=> 0,
			 	C_HAS_SSET=> 0,
			 	C_HAS_SINIT=> 0,
			 	C_ENABLE_RLOCS=> 1)
		PORT MAP (	A =>  x0i,
				B=>  x1i,
				CLK => clk,
				ADD => dummy_in,
				C_IN => dummy_in,
				B_IN => logic1,
				CE => ce, --ce_bf, --was ce,
				BYPASS => dummy_in,
				ACLR => dummy_in,
				ASET => dummy_in,
				AINIT => reset,
				SCLR => nc,
				SSET => nc,
				SINIT => nc,
				A_SIGNED => logic1,
				B_SIGNED => logic1,
				OVFL => open_ovfl_3,
				C_OUT => open_c_out_3,
				B_OUT => open_b_out_3,
				Q_OVFL => open_q_ovfl_3,
				Q_C_OUT => open_q_c_out_3,
				Q_B_OUT => open_q_b_out_3,
				S => open_s_3,
				Q => y1i_int);


--ce_bf_gen : and_a_b PORT MAP (a_in => ce,
--					b_in =>start,
--					and_out =>ce_bf);

-------scale factor =0----------------------------

--sf0: IF scale_by=0 GENERATE


--with 0 scaling --
--y0r <= y0r_int(bfly_width-1 DOWNTO 0); --(bfly_width DOWNTO 1);
--y0i <= y0i_int(bfly_width-1 DOWNTO 0); --(bfly_width DOWNTO 1);

--y1r <= y1r_int(bfly_width-1 DOWNTO 0); --(bfly_width DOWNTO 1);
--y1i <= y1i_int(bfly_width-1 DOWNTO 0); --(bfly_width DOWNTO 1);
--END GENERATE;

-------scale factor =1----------------------------

--sf1: IF scale_by=1 GENERATE


--with 1 scaling --

--y0r <= y0r_int(bfly_width DOWNTO 1);
--y0i <= y0i_int(bfly_width DOWNTO 1);

--y1r <= y1r_int(bfly_width DOWNTO 1);
--1i <= y1i_int(bfly_width DOWNTO 1);

--END GENERATE;

y0r_scale0 <= y0r_int(bfly_width-1 DOWNTO 0);
y0i_scale0 <= y0i_int(bfly_width-1 DOWNTO 0);

y1r_scale0 <= y1r_int(bfly_width-1 DOWNTO 0);
y1i_scale0 <= y1i_int(bfly_width-1 DOWNTO 0); 

y0r_scale1 <= y0r_int(bfly_width DOWNTO 1);
y0i_scale1 <= y0i_int(bfly_width DOWNTO 1);

y1r_scale1 <= y1r_int(bfly_width DOWNTO 1);
y1i_scale1 <= y1i_int(bfly_width DOWNTO 1);


scale_mux_y0r :  c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH =>bfly_width,
					C_INPUTS => 2,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP ( MA=> y0r_scale0, 
					MB => y0r_scale1, 
					MC => dummy_mux_inputs,
					MD => dummy_mux_inputs,
					ME => dummy_mux_inputs,
					MF => dummy_mux_inputs,
					MG => dummy_mux_inputs,
					MH => dummy_mux_inputs,
					MAA 	=> dummy_mux_inputs_1,
					MAB 	=> dummy_mux_inputs_1,
					MAC 	=> dummy_mux_inputs_1,
					MAD 	=> dummy_mux_inputs_1,
					MAE 	=> dummy_mux_inputs_1,
					MAF 	=> dummy_mux_inputs_1,
					MAG 	=> dummy_mux_inputs_1,
					MAH 	=> dummy_mux_inputs_1,
					MBA 	=> dummy_mux_inputs_1,
					MBB 	=> dummy_mux_inputs_1,
					MBC 	=> dummy_mux_inputs_1,
					MBD 	=> dummy_mux_inputs_1,
					MBE 	=> dummy_mux_inputs_1,
					MBF 	=> dummy_mux_inputs_1,
					MBG 	=> dummy_mux_inputs_1,
					MBH 	=> dummy_mux_inputs_1,
					MCA 	=> dummy_mux_inputs_1,
					MCB 	=> dummy_mux_inputs_1,
					MCC 	=> dummy_mux_inputs_1,
					MCD 	=> dummy_mux_inputs_1,
					MCE 	=> dummy_mux_inputs_1,
					MCF 	=> dummy_mux_inputs_1,
					MCG 	=> dummy_mux_inputs_1,
					MCH 	=> dummy_mux_inputs_1,
					S => mux_select,
		  			CLK 	=>dummy_in, -- Optional clock
		  			CE 	=>dummy_in,  -- Optional Clock enable
		  			EN 	=>dummy_in,  -- Optional BUFT enable
		  			ASET 	=>dummy_in, -- optional asynch set to '1'
		  			ACLR 	=>dummy_in, -- Asynch init.
		  			AINIT =>dummy_in, -- optional asynch reset to init_val
		  			SSET	=>dummy_in, -- optional synch set to '1'
		  			SCLR 	=>dummy_in, -- Synch init.
		  			SINIT	=>dummy_in,	
					O => y0r,
					Q => open_q_i);

scale_mux_y0i :  c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH =>bfly_width,
					C_INPUTS => 2,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP ( MA=> y0i_scale0, 
					MB => y0i_scale1, 
					MC => dummy_mux_inputs,
					MD => dummy_mux_inputs,
					ME => dummy_mux_inputs,
					MF => dummy_mux_inputs,
					MG => dummy_mux_inputs,
					MH => dummy_mux_inputs,
					MAA 	=> dummy_mux_inputs_1,
					MAB 	=> dummy_mux_inputs_1,
					MAC 	=> dummy_mux_inputs_1,
					MAD 	=> dummy_mux_inputs_1,
					MAE 	=> dummy_mux_inputs_1,
					MAF 	=> dummy_mux_inputs_1,
					MAG 	=> dummy_mux_inputs_1,
					MAH 	=> dummy_mux_inputs_1,
					MBA 	=> dummy_mux_inputs_1,
					MBB 	=> dummy_mux_inputs_1,
					MBC 	=> dummy_mux_inputs_1,
					MBD 	=> dummy_mux_inputs_1,
					MBE 	=> dummy_mux_inputs_1,
					MBF 	=> dummy_mux_inputs_1,
					MBG 	=> dummy_mux_inputs_1,
					MBH 	=> dummy_mux_inputs_1,
					MCA 	=> dummy_mux_inputs_1,
					MCB 	=> dummy_mux_inputs_1,
					MCC 	=> dummy_mux_inputs_1,
					MCD 	=> dummy_mux_inputs_1,
					MCE 	=> dummy_mux_inputs_1,
					MCF 	=> dummy_mux_inputs_1,
					MCG 	=> dummy_mux_inputs_1,
					MCH 	=> dummy_mux_inputs_1,
					S => mux_select,
		  			CLK 	=>dummy_in, -- Optional clock
		  			CE 	=>dummy_in,  -- Optional Clock enable
		  			EN 	=>dummy_in,  -- Optional BUFT enable
		  			ASET 	=>dummy_in, -- optional asynch set to '1'
		  			ACLR 	=>dummy_in, -- Asynch init.
		  			AINIT =>dummy_in, -- optional asynch reset to init_val
		  			SSET	=>dummy_in, -- optional synch set to '1'
		  			SCLR 	=>dummy_in, -- Synch init.
		  			SINIT	=>dummy_in,	
					O => y0i,
					Q => open_q_i);

scale_mux_y1r :  c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH =>bfly_width,
					C_INPUTS => 2,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP ( MA=> y1r_scale0, 
					MB => y1r_scale1, 
					MC => dummy_mux_inputs,
					MD => dummy_mux_inputs,
					ME => dummy_mux_inputs,
					MF => dummy_mux_inputs,
					MG => dummy_mux_inputs,
					MH => dummy_mux_inputs,
					MAA 	=> dummy_mux_inputs_1,
					MAB 	=> dummy_mux_inputs_1,
					MAC 	=> dummy_mux_inputs_1,
					MAD 	=> dummy_mux_inputs_1,
					MAE 	=> dummy_mux_inputs_1,
					MAF 	=> dummy_mux_inputs_1,
					MAG 	=> dummy_mux_inputs_1,
					MAH 	=> dummy_mux_inputs_1,
					MBA 	=> dummy_mux_inputs_1,
					MBB 	=> dummy_mux_inputs_1,
					MBC 	=> dummy_mux_inputs_1,
					MBD 	=> dummy_mux_inputs_1,
					MBE 	=> dummy_mux_inputs_1,
					MBF 	=> dummy_mux_inputs_1,
					MBG 	=> dummy_mux_inputs_1,
					MBH 	=> dummy_mux_inputs_1,
					MCA 	=> dummy_mux_inputs_1,
					MCB 	=> dummy_mux_inputs_1,
					MCC 	=> dummy_mux_inputs_1,
					MCD 	=> dummy_mux_inputs_1,
					MCE 	=> dummy_mux_inputs_1,
					MCF 	=> dummy_mux_inputs_1,
					MCG 	=> dummy_mux_inputs_1,
					MCH 	=> dummy_mux_inputs_1,
					S => mux_select,
		  			CLK 	=>dummy_in, -- Optional clock
		  			CE 	=>dummy_in,  -- Optional Clock enable
		  			EN 	=>dummy_in,  -- Optional BUFT enable
		  			ASET 	=>dummy_in, -- optional asynch set to '1'
		  			ACLR 	=>dummy_in, -- Asynch init.
		  			AINIT =>dummy_in, -- optional asynch reset to init_val
		  			SSET	=>dummy_in, -- optional synch set to '1'
		  			SCLR 	=>dummy_in, -- Synch init.
		  			SINIT	=>dummy_in,	
					O => y1r,
					Q => open_q_i);

scale_mux_y1i :  c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH =>bfly_width,
					C_INPUTS => 2,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP ( MA=> y1i_scale0, 
					MB => y1i_scale1, 
					MC => dummy_mux_inputs,
					MD => dummy_mux_inputs,
					ME => dummy_mux_inputs,
					MF => dummy_mux_inputs,
					MG => dummy_mux_inputs,
					MH => dummy_mux_inputs,
					MAA 	=> dummy_mux_inputs_1,
					MAB 	=> dummy_mux_inputs_1,
					MAC 	=> dummy_mux_inputs_1,
					MAD 	=> dummy_mux_inputs_1,
					MAE 	=> dummy_mux_inputs_1,
					MAF 	=> dummy_mux_inputs_1,
					MAG 	=> dummy_mux_inputs_1,
					MAH 	=> dummy_mux_inputs_1,
					MBA 	=> dummy_mux_inputs_1,
					MBB 	=> dummy_mux_inputs_1,
					MBC 	=> dummy_mux_inputs_1,
					MBD 	=> dummy_mux_inputs_1,
					MBE 	=> dummy_mux_inputs_1,
					MBF 	=> dummy_mux_inputs_1,
					MBG 	=> dummy_mux_inputs_1,
					MBH 	=> dummy_mux_inputs_1,
					MCA 	=> dummy_mux_inputs_1,
					MCB 	=> dummy_mux_inputs_1,
					MCC 	=> dummy_mux_inputs_1,
					MCD 	=> dummy_mux_inputs_1,
					MCE 	=> dummy_mux_inputs_1,
					MCF 	=> dummy_mux_inputs_1,
					MCG 	=> dummy_mux_inputs_1,
					MCH 	=> dummy_mux_inputs_1,
					S => mux_select,
		  			CLK 	=>dummy_in, -- Optional clock
		  			CE 	=>dummy_in,  -- Optional Clock enable
		  			EN 	=>dummy_in,  -- Optional BUFT enable
		  			ASET 	=>dummy_in, -- optional asynch set to '1'
		  			ACLR 	=>dummy_in, -- Asynch init.
		  			AINIT =>dummy_in, -- optional asynch reset to init_val
		  			SSET	=>dummy_in, -- optional synch set to '1'
		  			SCLR 	=>dummy_in, -- Synch init.
		  			SINIT	=>dummy_in,	
					O => y1i,
					Q => open_q_i);

END behavioral;

---------------------------------END bflyw0_v3----------------------------------------------

---------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
---------------------------------------------------------------------------
--reduced bfly with w=-j

LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_REG_FD_V4_0_comp.all;
USE XilinxCoreLib.C_ADDSUB_V4_0_comp.all;
USE XilinxCoreLib.C_MUX_BUS_V4_0_comp.all;
USE XilinxCoreLib.vfft32_comps_v3.all;
USE XilinxCoreLib.vfft32_pkg_v3.all;

ENTITY bflyw_j_v3 IS
	GENERIC (bfly_width : INTEGER);
	PORT (x0r	: IN STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
		x0i	: IN STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
		x1r	: IN STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
		x1i	: IN STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
		clk	: IN STD_LOGIC;
		ce 	: IN STD_LOGIC;
		start	: IN STD_LOGIC;
		reset : IN STD_LOGIC;
		scale_by : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		y0r	: OUT STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
		y0i	: OUT STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
		y1r	: OUT STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
		y1i	: OUT STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0));
END bflyw_j_v3;

ARCHITECTURE behavioral OF bflyw_j_v3 IS

CONSTANT diff_with_0_scaling	: INTEGER := 1; --(bfly_width+1 - bfly_width) 

SIGNAL y0r_int	: STD_LOGIC_VECTOR(bfly_width DOWNTO 0);
SIGNAL y0i_int	: STD_LOGIC_VECTOR(bfly_width DOWNTO 0);
SIGNAL y1r_int	: STD_LOGIC_VECTOR(bfly_width DOWNTO 0);
SIGNAL y1i_int	: STD_LOGIC_VECTOR(bfly_width DOWNTO 0);


SIGNAL y0r_scale0 : STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
SIGNAL y0i_scale0 : STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
SIGNAL y1r_scale0 : STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
SIGNAL y1i_scale0 : STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
SIGNAL y0r_scale1 : STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
SIGNAL y0i_scale1 : STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
SIGNAL y1r_scale1 : STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
SIGNAL y1i_scale1 : STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);


--SIGNAL logic0		: STD_LOGIC	:='0';
SIGNAL logic1		: STD_LOGIC	:='1';
SIGNAL nc			: STD_LOGIC	:= '0';
SIGNAL dummy_in		: STD_LOGIC	:= '0';

SIGNAL ce_bf		: STD_LOGIC; --for xcc	:= '0';

SIGNAL open_ovfl: STD_LOGIC;
SIGNAL open_c_out: STD_LOGIC;
SIGNAL open_b_out: STD_LOGIC;
SIGNAL open_q_ovfl: STD_LOGIC;
SIGNAL open_q_c_out: STD_LOGIC;
SIGNAL open_q_b_out: STD_LOGIC;
SIGNAL open_s: STD_LOGIC_VECTOR(bfly_width  DOWNTO 0);

SIGNAL open_ovfl_1: STD_LOGIC;
SIGNAL open_c_out_1: STD_LOGIC;
SIGNAL open_b_out_1: STD_LOGIC;
SIGNAL open_q_ovfl_1: STD_LOGIC;
SIGNAL open_q_c_out_1: STD_LOGIC;
SIGNAL open_q_b_out_1: STD_LOGIC;
SIGNAL open_s_1: STD_LOGIC_VECTOR(bfly_width  DOWNTO 0);

SIGNAL open_ovfl_2: STD_LOGIC;
SIGNAL open_c_out_2: STD_LOGIC;
SIGNAL open_b_out_2: STD_LOGIC;
SIGNAL open_q_ovfl_2: STD_LOGIC;
SIGNAL open_q_c_out_2: STD_LOGIC;
SIGNAL open_q_b_out_2: STD_LOGIC;
SIGNAL open_s_2: STD_LOGIC_VECTOR(bfly_width  DOWNTO 0);

SIGNAL open_ovfl_3: STD_LOGIC;
SIGNAL open_c_out_3: STD_LOGIC;
SIGNAL open_b_out_3: STD_LOGIC;
SIGNAL open_q_ovfl_3: STD_LOGIC;
SIGNAL open_q_c_out_3: STD_LOGIC;
SIGNAL open_q_b_out_3: STD_LOGIC;
SIGNAL open_s_3: STD_LOGIC_VECTOR(bfly_width  DOWNTO 0);

SIGNAL dummy_mux_inputs :STD_LOGIC_VECTOR(bfly_width-1  DOWNTO 0);
SIGNAL dummy_mux_inputs_1 :STD_LOGIC_VECTOR(bfly_width-1  DOWNTO 0);

SIGNAL mux_select : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL open_q_r	: STD_LOGIC_VECTOR(bfly_width-1  DOWNTO 0);
SIGNAL open_q_i	: STD_LOGIC_VECTOR(bfly_width-1  DOWNTO 0);

BEGIN

mux_select(0) <= scale_by(0);
dummy_mux_inputs <= (OTHERS => '0');
logic1 <= '1';
nc <= '0';
dummy_in <= '0';

upper_arm_adder_re: C_ADDSUB_V4_0
		   GENERIC MAP (C_A_WIDTH => bfly_width,
				C_B_WIDTH => bfly_width,
				C_OUT_WIDTH => bfly_width+1,
				C_LOW_BIT => 0,
				C_HIGH_BIT => bfly_width,
				C_ADD_MODE => 0,		--c_add,
				C_A_TYPE => 0,			--c_signed,
				C_B_TYPE => 0,			--c_signed,
				C_B_CONSTANT => 0,
				C_B_VALUE => "",
				C_AINIT_VAL => "0",
				C_SINIT_VAL => "0",
				C_BYPASS_ENABLE => 0,
				C_BYPASS_LOW => 0,
				--C_SYNC_ENABLE=> c_override; 	   
				--C_SYNC_PRIORITY	=> c_clear;	   
				C_PIPE_STAGES=> 1,
				C_HAS_S=> 0,
				C_HAS_Q	=> 1,
			 	C_HAS_C_IN =>0,
				C_HAS_C_OUT=> 0,
				C_HAS_Q_C_OUT=> 0,
				C_HAS_B_IN => 0,
				C_HAS_B_OUT=> 0,
			 	C_HAS_Q_B_OUT=> 0,
			 	C_HAS_OVFL=> 0,
			 	C_HAS_Q_OVFL=> 0,
			 	C_HAS_CE => 1,
			 	C_HAS_ADD => 0,
			 	C_HAS_BYPASS=> 0,
			 	C_HAS_A_SIGNED=> 1,
			 	C_HAS_B_SIGNED=> 1,
			 	C_HAS_ACLR=> 0,
			 	C_HAS_ASET=> 0,
			 	C_HAS_AINIT=> 0,
			 	C_HAS_SCLR=> 0,
			 	C_HAS_SSET=> 0,
			 	C_HAS_SINIT=> 0,
			 	C_ENABLE_RLOCS=> 1)
		PORT MAP (	A => x0r, 
				B=> x1r, 
				CLK => clk,
				ADD => dummy_in,
				C_IN => dummy_in,
				B_IN => dummy_in,
				CE => ce, --ce_bf, -- was ce,
				BYPASS => dummy_in,
				ACLR => dummy_in,
				ASET => dummy_in,
				AINIT => reset,
				SCLR => nc,
				SSET => nc,
				SINIT => nc,
				A_SIGNED => logic1,
				B_SIGNED => logic1,
				OVFL => open_ovfl,
				C_OUT => open_c_out,
				B_OUT => open_b_out,
				Q_OVFL => open_q_ovfl,
				Q_C_OUT => open_q_c_out,
				Q_B_OUT => open_q_b_out,
				S => open_s,
				Q => y0r_int);
 

upper_arm_adder_im: C_ADDSUB_V4_0
		   GENERIC MAP (C_A_WIDTH => bfly_width,
				C_B_WIDTH => bfly_width,
				C_OUT_WIDTH => bfly_width+1,
				C_LOW_BIT => 0,
				C_HIGH_BIT => bfly_width,
				C_ADD_MODE => 0,		-- c_add,
				C_A_TYPE => 0,			--c_signed,
				C_B_TYPE => 0,			--c_signed,
				C_B_CONSTANT => 0,
				C_B_VALUE => "",
				C_AINIT_VAL => "0",
				C_SINIT_VAL => "0",
				C_BYPASS_ENABLE => 0,
				C_BYPASS_LOW => 0,
				--C_SYNC_ENABLE=> c_override; 	   
				--C_SYNC_PRIORITY	=> c_clear,	   
				C_PIPE_STAGES=> 1,
				C_HAS_S=> 0,
				C_HAS_Q	=> 1,
			 	C_HAS_C_IN =>0,
				C_HAS_C_OUT=> 0,
				C_HAS_Q_C_OUT=> 0,
				C_HAS_B_IN => 0,
				C_HAS_B_OUT=> 0,
			 	C_HAS_Q_B_OUT=> 0,
			 	C_HAS_OVFL=> 0,
			 	C_HAS_Q_OVFL=> 0,
			 	C_HAS_CE => 1,
			 	C_HAS_ADD => 0,
			 	C_HAS_BYPASS=> 0,
			 	C_HAS_A_SIGNED=> 1,
			 	C_HAS_B_SIGNED=> 1,
			 	C_HAS_ACLR=> 0,
			 	C_HAS_ASET=> 0,
			 	C_HAS_AINIT=> 1,
			 	C_HAS_SCLR=> 0,
			 	C_HAS_SSET=> 0,
			 	C_HAS_SINIT=> 0,
			 	C_ENABLE_RLOCS=> 1)
		PORT MAP (	A => x0i,
				B=> x1i,
				CLK => clk,
				ADD => dummy_in,
				C_IN => dummy_in,
				B_IN => dummy_in,
				CE => ce, --ce_bf, --was ce,
				BYPASS => dummy_in,
				ACLR => dummy_in,
				ASET => dummy_in,
				AINIT => reset,
				SCLR => nc,
				SSET => nc,
				SINIT => nc,
				A_SIGNED => logic1,
				B_SIGNED => logic1,
				OVFL => open_ovfl_1,
				C_OUT => open_c_out_1,
				B_OUT => open_b_out_1,
				Q_OVFL => open_q_ovfl_1,
				Q_C_OUT => open_q_c_out_1,
				Q_B_OUT => open_q_b_out_1,
				S => open_s_1,
				Q => y0i_int);

lower_arm_subtr_re: C_ADDSUB_V4_0
		   GENERIC MAP (C_A_WIDTH => bfly_width,
				C_B_WIDTH => bfly_width,
				C_OUT_WIDTH => bfly_width+1,
				C_LOW_BIT => 0,
				C_HIGH_BIT => bfly_width,
				C_ADD_MODE => 1,		-- c_sub,
				C_A_TYPE => 0,			-- c_signed,
				C_B_TYPE => 0, 			-- c_signed,
				C_B_CONSTANT => 0,
				C_B_VALUE => "",
				C_AINIT_VAL => "0",
				C_SINIT_VAL => "0",
				C_BYPASS_ENABLE => 0,
				C_BYPASS_LOW => 0,
				--C_SYNC_ENABLE=> c_override, 	   
				--C_SYNC_PRIORITY	=> c_clear,	   
				C_PIPE_STAGES=> 1,
				C_HAS_S=> 0,
				C_HAS_Q	=> 1,
			 	C_HAS_C_IN =>0,
				C_HAS_C_OUT=> 0,
				C_HAS_Q_C_OUT=> 0,
				C_HAS_B_IN => 1,
				C_HAS_B_OUT=> 0,
			 	C_HAS_Q_B_OUT=> 0,
			 	C_HAS_OVFL=> 0,
			 	C_HAS_Q_OVFL=> 0,
			 	C_HAS_CE => 1,
			 	C_HAS_ADD => 0,
			 	C_HAS_BYPASS=> 0,
			 	C_HAS_A_SIGNED=> 1,
			 	C_HAS_B_SIGNED=> 1,
			 	C_HAS_ACLR=> 0,
			 	C_HAS_ASET=> 0,
			 	C_HAS_AINIT=> 1,
			 	C_HAS_SCLR=> 0,
			 	C_HAS_SSET=> 0,
			 	C_HAS_SINIT=> 0,
			 	C_ENABLE_RLOCS=> 1)
		PORT MAP (	A => x0i, --x0r,
				B=>  x1i, --x1r,
				CLK => clk,
				ADD => dummy_in,
				C_IN => dummy_in,
				B_IN => logic1,
				CE => ce, --ce_bf, --was ce,
				BYPASS => dummy_in,
				ACLR => dummy_in,
				ASET => nc,
				AINIT => reset,
				SCLR => nc,
				SSET => nc,
				SINIT => nc,
				A_SIGNED => logic1,
				B_SIGNED => logic1,
				OVFL => open_ovfl_2,
				C_OUT => open_c_out_2,
				B_OUT => open_b_out_2,
				Q_OVFL => open_q_ovfl_2,
				Q_C_OUT => open_q_c_out_2,
				Q_B_OUT => open_q_b_out_2,
				S => open_s_2,
				Q => y1r_int);

lower_arm_subtr_im: C_ADDSUB_V4_0
		   GENERIC MAP (C_A_WIDTH => bfly_width,
				C_B_WIDTH => bfly_width,
				C_OUT_WIDTH => bfly_width+1,
				C_LOW_BIT => 0,
				C_HIGH_BIT => bfly_width,
				C_ADD_MODE => 1,		--c_sub,
				C_A_TYPE => 0,			--c_signed,
				C_B_TYPE => 0,			--c_signed,
				C_B_CONSTANT => 0,
				C_B_VALUE => "",
				C_AINIT_VAL => "0",
				C_SINIT_VAL => "0",
				C_BYPASS_ENABLE => 0,
				C_BYPASS_LOW => 0,
				--C_SYNC_ENABLE=> c_override, 	   
				--C_SYNC_PRIORITY	=> c_clear,	   
				C_PIPE_STAGES=> 1,
				C_HAS_S=> 0,
				C_HAS_Q	=> 1,
			 	C_HAS_C_IN =>0,
				C_HAS_C_OUT=> 0,
				C_HAS_Q_C_OUT=> 0,
				C_HAS_B_IN => 1,
				C_HAS_B_OUT=> 0,
			 	C_HAS_Q_B_OUT=> 0,
			 	C_HAS_OVFL=> 0,
			 	C_HAS_Q_OVFL=> 0,
			 	C_HAS_CE => 1,
			 	C_HAS_ADD => 0,
			 	C_HAS_BYPASS=> 0,
			 	C_HAS_A_SIGNED=> 1,
			 	C_HAS_B_SIGNED=> 1,
			 	C_HAS_ACLR=> 0,
			 	C_HAS_ASET=> 0,
			 	C_HAS_AINIT=> 1,
			 	C_HAS_SCLR=> 0,
			 	C_HAS_SSET=> 0,
			 	C_HAS_SINIT=> 0,
			 	C_ENABLE_RLOCS=> 1)
		PORT MAP (	A =>  x1r, --x0i,
				B=>  x0r, --x1i,
				CLK => clk,
				ADD => dummy_in,
				C_IN => dummy_in,
				B_IN => logic1,
				CE => ce, --ce_bf, --was ce,
				BYPASS => dummy_in,
				ACLR => dummy_in,
				ASET => dummy_in,
				AINIT => reset,
				SCLR => nc,
				SSET => nc,
				SINIT => nc,
				A_SIGNED => logic1,
				B_SIGNED => logic1,
				OVFL => open_ovfl_3,
				C_OUT => open_c_out_3,
				B_OUT => open_b_out_3,
				Q_OVFL => open_q_ovfl_3,
				Q_C_OUT => open_q_c_out_3,
				Q_B_OUT => open_q_b_out_3,
				S => open_s_3,
				Q => y1i_int);


ce_bf_gen : and_a_b_32_v3 PORT MAP (a_in => ce,
					b_in =>start,
					and_out =>ce_bf);

-------scale factor =0----------------------------

--sf0: IF scale_by=0 GENERATE

--with 0 scaling --
--y0r <= y0r_int(bfly_width-1 DOWNTO 0); --(bfly_width DOWNTO 1);
--y0i <= y0i_int(bfly_width-1 DOWNTO 0); --(bfly_width DOWNTO 1);

--y1r <= y1r_int(bfly_width-1 DOWNTO 0); --(bfly_width DOWNTO 1);
--y1i <= y1i_int(bfly_width-1 DOWNTO 0); --(bfly_width DOWNTO 1);

--END GENERATE;

-------scale factor =1----------------------------

--sf1: IF scale_by=1 GENERATE
--with 1 scaling --

--y0r <= y0r_int(bfly_width DOWNTO 1);
--y0i <= y0i_int(bfly_width DOWNTO 1);

--y1r <= y1r_int(bfly_width DOWNTO 1);
--y1i <= y1i_int(bfly_width DOWNTO 1);
--END GENERATE;



y0r_scale0 <= y0r_int(bfly_width-1 DOWNTO 0);
y0i_scale0 <= y0i_int(bfly_width-1 DOWNTO 0);

y1r_scale0 <= y1r_int(bfly_width-1 DOWNTO 0);
y1i_scale0 <= y1i_int(bfly_width-1 DOWNTO 0); 

y0r_scale1 <= y0r_int(bfly_width DOWNTO 1);
y0i_scale1 <= y0i_int(bfly_width DOWNTO 1);

y1r_scale1 <= y1r_int(bfly_width DOWNTO 1);
y1i_scale1 <= y1i_int(bfly_width DOWNTO 1);


scale_mux_y0r :  c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH =>bfly_width,
					C_INPUTS => 2,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP ( MA=> y0r_scale0, 
					MB => y0r_scale1, 
					MC => dummy_mux_inputs,
					MD => dummy_mux_inputs,
					ME => dummy_mux_inputs,
					MF => dummy_mux_inputs,
					MG => dummy_mux_inputs,
					MH => dummy_mux_inputs,
					MAA 	=> dummy_mux_inputs_1,
					MAB 	=> dummy_mux_inputs_1,
					MAC 	=> dummy_mux_inputs_1,
					MAD 	=> dummy_mux_inputs_1,
					MAE 	=> dummy_mux_inputs_1,
					MAF 	=> dummy_mux_inputs_1,
					MAG 	=> dummy_mux_inputs_1,
					MAH 	=> dummy_mux_inputs_1,
					MBA 	=> dummy_mux_inputs_1,
					MBB 	=> dummy_mux_inputs_1,
					MBC 	=> dummy_mux_inputs_1,
					MBD 	=> dummy_mux_inputs_1,
					MBE 	=> dummy_mux_inputs_1,
					MBF 	=> dummy_mux_inputs_1,
					MBG 	=> dummy_mux_inputs_1,
					MBH 	=> dummy_mux_inputs_1,
					MCA 	=> dummy_mux_inputs_1,
					MCB 	=> dummy_mux_inputs_1,
					MCC 	=> dummy_mux_inputs_1,
					MCD 	=> dummy_mux_inputs_1,
					MCE 	=> dummy_mux_inputs_1,
					MCF 	=> dummy_mux_inputs_1,
					MCG 	=> dummy_mux_inputs_1,
					MCH 	=> dummy_mux_inputs_1,
					S => mux_select,
		  			CLK 	=>dummy_in, -- Optional clock
		  			CE 	=>dummy_in,  -- Optional Clock enable
		  			EN 	=>dummy_in,  -- Optional BUFT enable
		  			ASET 	=>dummy_in, -- optional asynch set to '1'
		  			ACLR 	=>dummy_in, -- Asynch init.
		  			AINIT =>dummy_in, -- optional asynch reset to init_val
		  			SSET	=>dummy_in, -- optional synch set to '1'
		  			SCLR 	=>dummy_in, -- Synch init.
		  			SINIT	=>dummy_in,	
					O => y0r,
					Q => open_q_i);

scale_mux_y0i :  c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH =>bfly_width,
					C_INPUTS => 2,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP ( MA=> y0i_scale0, 
					MB => y0i_scale1, 
					MC => dummy_mux_inputs,
					MD => dummy_mux_inputs,
					ME => dummy_mux_inputs,
					MF => dummy_mux_inputs,
					MG => dummy_mux_inputs,
					MH => dummy_mux_inputs,
					MAA 	=> dummy_mux_inputs_1,
					MAB 	=> dummy_mux_inputs_1,
					MAC 	=> dummy_mux_inputs_1,
					MAD 	=> dummy_mux_inputs_1,
					MAE 	=> dummy_mux_inputs_1,
					MAF 	=> dummy_mux_inputs_1,
					MAG 	=> dummy_mux_inputs_1,
					MAH 	=> dummy_mux_inputs_1,
					MBA 	=> dummy_mux_inputs_1,
					MBB 	=> dummy_mux_inputs_1,
					MBC 	=> dummy_mux_inputs_1,
					MBD 	=> dummy_mux_inputs_1,
					MBE 	=> dummy_mux_inputs_1,
					MBF 	=> dummy_mux_inputs_1,
					MBG 	=> dummy_mux_inputs_1,
					MBH 	=> dummy_mux_inputs_1,
					MCA 	=> dummy_mux_inputs_1,
					MCB 	=> dummy_mux_inputs_1,
					MCC 	=> dummy_mux_inputs_1,
					MCD 	=> dummy_mux_inputs_1,
					MCE 	=> dummy_mux_inputs_1,
					MCF 	=> dummy_mux_inputs_1,
					MCG 	=> dummy_mux_inputs_1,
					MCH 	=> dummy_mux_inputs_1,
					S => mux_select,
		  			CLK 	=>dummy_in, -- Optional clock
		  			CE 	=>dummy_in,  -- Optional Clock enable
		  			EN 	=>dummy_in,  -- Optional BUFT enable
		  			ASET 	=>dummy_in, -- optional asynch set to '1'
		  			ACLR 	=>dummy_in, -- Asynch init.
		  			AINIT =>dummy_in, -- optional asynch reset to init_val
		  			SSET	=>dummy_in, -- optional synch set to '1'
		  			SCLR 	=>dummy_in, -- Synch init.
		  			SINIT	=>dummy_in,	
					O => y0i,
					Q => open_q_i);

scale_mux_y1r :  c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH =>bfly_width,
					C_INPUTS => 2,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP ( MA=> y1r_scale0, 
					MB => y1r_scale1, 
					MC => dummy_mux_inputs,
					MD => dummy_mux_inputs,
					ME => dummy_mux_inputs,
					MF => dummy_mux_inputs,
					MG => dummy_mux_inputs,
					MH => dummy_mux_inputs,
					MAA 	=> dummy_mux_inputs_1,
					MAB 	=> dummy_mux_inputs_1,
					MAC 	=> dummy_mux_inputs_1,
					MAD 	=> dummy_mux_inputs_1,
					MAE 	=> dummy_mux_inputs_1,
					MAF 	=> dummy_mux_inputs_1,
					MAG 	=> dummy_mux_inputs_1,
					MAH 	=> dummy_mux_inputs_1,
					MBA 	=> dummy_mux_inputs_1,
					MBB 	=> dummy_mux_inputs_1,
					MBC 	=> dummy_mux_inputs_1,
					MBD 	=> dummy_mux_inputs_1,
					MBE 	=> dummy_mux_inputs_1,
					MBF 	=> dummy_mux_inputs_1,
					MBG 	=> dummy_mux_inputs_1,
					MBH 	=> dummy_mux_inputs_1,
					MCA 	=> dummy_mux_inputs_1,
					MCB 	=> dummy_mux_inputs_1,
					MCC 	=> dummy_mux_inputs_1,
					MCD 	=> dummy_mux_inputs_1,
					MCE 	=> dummy_mux_inputs_1,
					MCF 	=> dummy_mux_inputs_1,
					MCG 	=> dummy_mux_inputs_1,
					MCH 	=> dummy_mux_inputs_1,
					S => mux_select,
		  			CLK 	=>dummy_in, -- Optional clock
		  			CE 	=>dummy_in,  -- Optional Clock enable
		  			EN 	=>dummy_in,  -- Optional BUFT enable
		  			ASET 	=>dummy_in, -- optional asynch set to '1'
		  			ACLR 	=>dummy_in, -- Asynch init.
		  			AINIT =>dummy_in, -- optional asynch reset to init_val
		  			SSET	=>dummy_in, -- optional synch set to '1'
		  			SCLR 	=>dummy_in, -- Synch init.
		  			SINIT	=>dummy_in,	
					O => y1r,
					Q => open_q_i);

scale_mux_y1i :  c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH =>bfly_width,
					C_INPUTS => 2,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP ( MA=> y1i_scale0, 
					MB => y1i_scale1, 
					MC => dummy_mux_inputs,
					MD => dummy_mux_inputs,
					ME => dummy_mux_inputs,
					MF => dummy_mux_inputs,
					MG => dummy_mux_inputs,
					MH => dummy_mux_inputs,
					MAA 	=> dummy_mux_inputs_1,
					MAB 	=> dummy_mux_inputs_1,
					MAC 	=> dummy_mux_inputs_1,
					MAD 	=> dummy_mux_inputs_1,
					MAE 	=> dummy_mux_inputs_1,
					MAF 	=> dummy_mux_inputs_1,
					MAG 	=> dummy_mux_inputs_1,
					MAH 	=> dummy_mux_inputs_1,
					MBA 	=> dummy_mux_inputs_1,
					MBB 	=> dummy_mux_inputs_1,
					MBC 	=> dummy_mux_inputs_1,
					MBD 	=> dummy_mux_inputs_1,
					MBE 	=> dummy_mux_inputs_1,
					MBF 	=> dummy_mux_inputs_1,
					MBG 	=> dummy_mux_inputs_1,
					MBH 	=> dummy_mux_inputs_1,
					MCA 	=> dummy_mux_inputs_1,
					MCB 	=> dummy_mux_inputs_1,
					MCC 	=> dummy_mux_inputs_1,
					MCD 	=> dummy_mux_inputs_1,
					MCE 	=> dummy_mux_inputs_1,
					MCF 	=> dummy_mux_inputs_1,
					MCG 	=> dummy_mux_inputs_1,
					MCH 	=> dummy_mux_inputs_1,
					S => mux_select,
		  			CLK 	=>dummy_in, -- Optional clock
		  			CE 	=>dummy_in,  -- Optional Clock enable
		  			EN 	=>dummy_in,  -- Optional BUFT enable
		  			ASET 	=>dummy_in, -- optional asynch set to '1'
		  			ACLR 	=>dummy_in, -- Asynch init.
		  			AINIT =>dummy_in, -- optional asynch reset to init_val
		  			SSET	=>dummy_in, -- optional synch set to '1'
		  			SCLR 	=>dummy_in, -- Synch init.
		  			SINIT	=>dummy_in,	
					O => y1i,
					Q => open_q_i);



END behavioral;

----------------------------------------END bflyw_j_v3-------------------------------------------
--------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
--------------------------------------------------------------------------
-- Last modified on 03/06/00
-- Name : fft4_32_v3.vhd
-- Function : This contains a 4 point FFT. Based on Chris Dick's version.
--		: Optimised  radix 4 dragonfly. Will be used 
--		: to combine ranks 3 and 4 of 32 pt FFT. 
-- 04/03/00 : Initial rev. of file.
-- Last modified on 03/30/00
--			 :04/7/00 : mistake in butterfly omega value connections fixed.
--			 :04/12/00: replaced RTL state machine with structural 
--					state_machine_v3.vhd . Replaced other RTL gate code with
--					baseblox versions. Replaced RTL register to reg. input
--					data with baseblox register.
--10/18/00 : Removed 1st 4 reg-conj registers as this function was moved 
-- 		to the output of the butterfly processor, between the butterfly
--		processor output and the crossbar switch (bfly_buffer) input.
-- 10/18/00: Removed intermediate stage 4 reg-conj registers. Moved them to
-- 		input of result memory so only 1 reg-conj is required on the 
--		data input to memory bus. 
---------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
		
LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_REG_FD_V4_0_comp.all;
USE XilinxCoreLib.C_TWOS_COMP_V4_0_comp.all;
USE XilinxCoreLib.vfft32_comps_v3.all;
USE XilinxCoreLib.vfft32_pkg_v3.all;
	
ENTITY fft4_32_v3 is
	GENERIC ( B:	INTEGER:= 16);
	port (
		clk		: in std_logic;				-- system clock
		reset		: in std_logic;				-- reset
		start		: in std_logic;				-- global start
		ce		: in std_logic;
		conj		: in std_logic;				-- conjugation control
										-- conjugates when == 0
		scale_rank3_by	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		scale_rank4_by	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		x0r		: in std_logic_vector(B-1 downto 0);	-- data input
		x0i		: in std_logic_vector(B-1 downto 0);
		x1r		: in std_logic_vector(B-1 downto 0);	-- data input
		x1i		: in std_logic_vector(B-1 downto 0);
		x2r		: in std_logic_vector(B-1 downto 0);	-- data input
		x2i		: in std_logic_vector(B-1 downto 0);
		x3r		: in std_logic_vector(B-1 downto 0);	-- data input
		x3i		: in std_logic_vector(B-1 downto 0);
		y0r		: out std_logic_vector(B-1 downto 0);	-- transform outp. samples
		y0i		: out std_logic_vector(B-1 downto 0);
		y1r		: out std_logic_vector(B-1 downto 0);
		y1i		: out std_logic_vector(B-1 downto 0);
		y2r		: out std_logic_vector(B-1 downto 0);
		y2i		: out std_logic_vector(B-1 downto 0);
		y3r		: out std_logic_vector(B-1 downto 0);
		y3i		: out std_logic_vector(B-1 downto 0)
	      );
END fft4_32_v3;

ARCHITECTURE behavioral OF fft4_32_v3 IS

signal start_fft4	: std_logic;		-- start 4-point FFT
signal	conji		: std_logic;

SIGNAL logic0		: STD_LOGIC := '0';
SIGNAL	dummy_in	: STD_LOGIC := '0';



signal ce0		: std_logic;		-- sample reg. ld enables
signal ce1		: std_logic;
signal ce2		: std_logic;
signal ce3		: std_logic;
SIGNAL cex0x1x2x3	: STD_LOGIC_VECTOR(3 DOWNTO 0);
signal cex0		: std_logic;		-- sample reg. ld enables
signal cex1		: std_logic;
signal cex2		: std_logic;
signal cex3		: std_logic;

SIGNAL b0_y0r_preconj : STD_LOGIC_VECTOR(B-1 downto 0);
SIGNAL b0_y0i_preconj : STD_LOGIC_VECTOR(B-1 downto 0);
SIGNAL b0_y1r_preconj : STD_LOGIC_VECTOR(B-1 downto 0);
SIGNAL b0_y1i_preconj : STD_LOGIC_VECTOR(B-1 downto 0);

SIGNAL b1_y0r_preconj : STD_LOGIC_VECTOR(B-1 downto 0);
SIGNAL b1_y0i_preconj : STD_LOGIC_VECTOR(B-1 downto 0);
SIGNAL b1_y1r_preconj : STD_LOGIC_VECTOR(B-1 downto 0);
SIGNAL b1_y1i_preconj : STD_LOGIC_VECTOR(B-1 downto 0);



begin


logic0 <= '0';
dummy_in <= '0';


--conji <= not conj; --to get the right sense for the complex_reg_conj_v3. 
--using nand to generate inversion
inv_gen: nand_a_b_32_v3 PORT MAP (a_in => conj,
			b_in => conj,
			nand_out => conji);

	
b0 : bflyw0_v3
	GENERIC MAP (bfly_width  => B)
	PORT MAP (
		x0r		=> x0r,
		x0i		=> x0i, 	
		x1r		=> x2r, 
		x1i		=> x2i, 	
		clk		=> clk,			-- mast clock
		ce		=> ce,			-- master clock enable
		start		=> start_fft4,
		reset		=> reset,
		scale_by	=> scale_rank3_by,
		y0r		=> b0_y0r_preconj,
		y0i		=> b0_y0i_preconj,	
		y1r		=> b0_y1r_preconj,	
		y1i		=> b0_y1i_preconj
	);

b1 : bflyw_j_v3
	GENERIC MAP (bfly_width  => B)
	PORT MAP (
		x0r		=> x1r, 
		x0i		=> x1i, 	
		x1r		=> x3r, 
		x1i		=> x3i,	
		clk		=> clk,			-- mast clock
		ce		=> ce,			-- master clock enable
		start		=> start_fft4,
		reset		=> reset,
		scale_by	=> scale_rank3_by,
		y0r		=> b1_y0r_preconj,
		y0i		=> b1_y0i_preconj,	
		y1r		=> b1_y1r_preconj,	
		y1i		=> b1_y1i_preconj
	);

b2 : bflyw0_v3
	GENERIC MAP (bfly_width  => B)
	PORT MAP (
		x0r		=> b0_y0r_preconj, 
		x0i		=> b0_y0i_preconj,	
		x1r		=> b1_y0r_preconj, 
		x1i		=> b1_y0i_preconj, 	
		clk		=> clk,			-- mast clock
		ce		=> ce,			-- master clock enable
		start		=> start_fft4,
		reset		=> reset,
		scale_by	=> scale_rank4_by,
		y0r		=> y0r, 
		y0i		=> y0i, 	
		y1r		=> y1r, 	
		y1i		=> y1i 
	);

b3 : bflyw0_v3
	GENERIC MAP (bfly_width  => B)
	PORT MAP (
		x0r		=> b0_y1r_preconj,  
		x0i		=> b0_y1i_preconj,  	
		x1r		=> b1_y1r_preconj, 
		x1i		=> b1_y1i_preconj, 	
		clk		=> clk,			-- mast clock
		ce		=> ce,			-- master clock enable
		start		=> start_fft4,
		reset		=> reset,
		scale_by	=> scale_rank4_by,
		y0r		=> y2r, 
		y0i		=> y2i,	
		y1r		=> y3r, 	
		y1i		=> y3i 
	);			

smach	: state_machine_v3
	GENERIC MAP (n => 4)
	PORT MAP (clk => clk,
		    ce => ce,
		    start => start,
		    reset => reset,
		    s => cex0x1x2x3);


	cex0 <= cex0x1x2x3(3);
	cex1 <= cex0x1x2x3(2);
	cex2 <= cex0x1x2x3(1);
	cex3 <= cex0x1x2x3(0);


gen_start: and_a_b_32_v3 PORT MAP(a_in => ce,
					b_in => cex0,
					and_out => start_fft4);

gen_ce0: and_a_b_32_v3 PORT MAP(a_in => ce,
					b_in => cex0,
					and_out => ce0);

gen_ce1: and_a_b_32_v3 PORT MAP(a_in => ce,
					b_in => cex1,
					and_out => ce1);
gen_ce2: and_a_b_32_v3 PORT MAP(a_in => ce,
					b_in => cex2,
					and_out => ce2);
gen_ce3: and_a_b_32_v3 PORT MAP(a_in => ce,
					b_in => cex3,
					and_out => ce3);

END behavioral;
--------------------------------END fft4.vhd------------------------------------------------------

---------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
---------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_MUX_BUS_V4_0_comp.all;
USE XilinxCoreLib.C_SHIFT_RAM_V4_0_comp.all;
USE XilinxCoreLib.prims_constants_v4_0.all;
USE XilinxCoreLib.C_COUNTER_BINARY_V4_0_comp.all;
USE XilinxCoreLib.C_REG_FD_V4_0_comp.all;

--LIBRARY work;
USE XilinxCoreLib.vfft32_comps_v3.all;
USE XilinxCoreLib.vfft32_pkg_v3.all;


ENTITY bfly_buffer_v3 IS
	GENERIC (bfly_width : INTEGER;
		memory_configuration : INTEGER );
	PORT (by0 : IN STD_LOGIC_VECTOR(bfly_width -1 DOWNTO 0); --bfly_width+2 -1 DOWNTO 0
		by1 : IN STD_LOGIC_VECTOR(bfly_width -1 DOWNTO 0);--bfly_width+2 -1 DOWNTO 0
		clk : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		start : IN STD_LOGIC;
		e_start : IN STD_LOGIC;
		fft4y0 : OUT STD_LOGIC_VECTOR(bfly_width -1 DOWNTO 0); --bfly_width+2 -1 DOWNTO 0
		fft4y1 : OUT STD_LOGIC_VECTOR(bfly_width -1 DOWNTO 0);--bfly_width+2 -1 DOWNTO 0
		fft4y2 : OUT STD_LOGIC_VECTOR(bfly_width -1 DOWNTO 0);--bfly_width+2 -1 DOWNTO 0
		fft4y3 : OUT STD_LOGIC_VECTOR(bfly_width -1 DOWNTO 0)--bfly_width+2 -1 DOWNTO 0
);

END bfly_buffer_v3;

ARCHITECTURE behavioral OF bfly_buffer_v3 IS

CONSTANT one_string : string := "01";
CONSTANT ainit_val : string := "00";
CONSTANT sinit_val : string := "00";

CONSTANT c_delay_value : INTEGER := 1 + eval(memory_configuration = 3);

SIGNAL zero : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
SIGNAL one : STD_LOGIC_VECTOR(1 DOWNTO 0) := "01";


SIGNAL ce0		: STD_LOGIC;		
SIGNAL ce1		: STD_LOGIC;
SIGNAL cex0		: STD_LOGIC;		
SIGNAL cex1		: STD_LOGIC;
SIGNAL	cex1x0		: STD_LOGIC_VECTOR(2-1 DOWNTO 0);

SIGNAL by1_2z		: STD_LOGIC_VECTOR(bfly_width -1 DOWNTO 0);
SIGNAL by1_1z		: STD_LOGIC_VECTOR(bfly_width -1 DOWNTO 0);
SIGNAL reg_by0		: STD_LOGIC_VECTOR(bfly_width -1 DOWNTO 0);

SIGNAL fft4y2_int	: STD_LOGIC_VECTOR(bfly_width -1 DOWNTO 0);

SIGNAL a	: STD_LOGIC_VECTOR(bfly_width -1 DOWNTO 0);
--SIGNAL a_z	: STD_LOGIC_VECTOR(bfly_width -1 DOWNTO 0);
SIGNAL b	: STD_LOGIC_VECTOR(bfly_width -1 DOWNTO 0);
SIGNAL c	: STD_LOGIC_VECTOR(bfly_width -1 DOWNTO 0);
SIGNAL d	: STD_LOGIC_VECTOR(bfly_width -1 DOWNTO 0);
SIGNAL e	: STD_LOGIC_VECTOR(bfly_width -1 DOWNTO 0);
SIGNAL f	: STD_LOGIC_VECTOR(bfly_width -1 DOWNTO 0);
SIGNAL c_1z	: STD_LOGIC_VECTOR(bfly_width -1 DOWNTO 0);

SIGNAL e_2z	: STD_LOGIC_VECTOR(bfly_width -1 DOWNTO 0);


SIGNAL logic_0		: STD_LOGIC := '0';
SIGNAL logic_1		: STD_LOGIC := '1';

SIGNAL dummy_addr	:STD_LOGIC_VECTOR(0 DOWNTO 0):= (OTHERS => '0');
SIGNAL dummy_in : STD_LOGIC := '0';

SIGNAL dummy_mux_inputs	 : STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
SIGNAL dummy_mux_inputs_1	 : STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
SIGNAL open_o		 : STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
SIGNAL open_o_d		 : STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
SIGNAL open_o_e		 : STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);

SIGNAL mux_select : STD_LOGIC_VECTOR(0 DOWNTO 0);


SIGNAL open_di : STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
SIGNAL open_x0i : STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
SIGNAL open_x0i_ffty0 : STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
SIGNAL open_x0i_ffty1 : STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
SIGNAL open_x0i_ffty2 : STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);
SIGNAL open_x0i_ffty3 : STD_LOGIC_VECTOR(bfly_width-1 DOWNTO 0);


SIGNAL buf_clk		: STD_LOGIC; --for xcc := '0';

SIGNAL count	: STD_LOGIC_VECTOR(1 DOWNTO 0); --for xcc:="00";
SIGNAL count_temp	: STD_LOGIC_VECTOR(1 DOWNTO 0); --for xcc :="00";
SIGNAL open_thresh0 : STD_LOGIC;
SIGNAL open_q_thresh0 : STD_LOGIC;
SIGNAL open_thresh1 : STD_LOGIC;
SIGNAL open_q_thresh1 : STD_LOGIC;

SIGNAL nc:		STD_LOGIC:= '0';

BEGIN

nc <= '0';
dummy_in <= '0';
logic_0 <= '0';
logic_1 <= '1';
open_di <= (OTHERS => '0');

a <= by0;
b <= by1;

mux_select(0) <= count(1);

buf_clk <= ce0;

zero <= (OTHERS => '0');
one(0) <= '1';
one(1) <= '0';


mux1 :  c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH => bfly_width, 
					C_INPUTS => 2,
					C_HAS_O => 0,
					C_HAS_Q => 1,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP ( MA=> a,
					MB =>c, --by1 delayed by 2
					MC => dummy_mux_inputs,
					MD => dummy_mux_inputs,
					ME => dummy_mux_inputs,
					MF => dummy_mux_inputs,
					MG => dummy_mux_inputs,
					MH => dummy_mux_inputs,
					MAA 	=> dummy_mux_inputs_1,
					MAB 	=> dummy_mux_inputs_1,
					MAC 	=> dummy_mux_inputs_1,
					MAD 	=> dummy_mux_inputs_1,
					MAE 	=> dummy_mux_inputs_1,
					MAF 	=> dummy_mux_inputs_1,
					MAG 	=> dummy_mux_inputs_1,
					MAH 	=> dummy_mux_inputs_1,
					MBA 	=> dummy_mux_inputs_1,
					MBB 	=> dummy_mux_inputs_1,
					MBC 	=> dummy_mux_inputs_1,
					MBD 	=> dummy_mux_inputs_1,
					MBE 	=> dummy_mux_inputs_1,
					MBF 	=> dummy_mux_inputs_1,
					MBG 	=> dummy_mux_inputs_1,
					MBH 	=> dummy_mux_inputs_1,
					MCA 	=> dummy_mux_inputs_1,
					MCB 	=> dummy_mux_inputs_1,
					MCC 	=> dummy_mux_inputs_1,
					MCD 	=> dummy_mux_inputs_1,
					MCE 	=> dummy_mux_inputs_1,
					MCF 	=> dummy_mux_inputs_1,
					MCG 	=> dummy_mux_inputs_1,
					MCH 	=> dummy_mux_inputs_1,
					S => mux_select,
		  			CLK 	=>clk,  -- Optional clock
		  			CE 	=>dummy_in,  -- Optional Clock enable
		  			EN 	=>dummy_in,  -- Optional BUFT enable
		  			ASET 	=>dummy_in,  -- optional asynch set to '1'
		  			ACLR 	=>dummy_in,  -- Asynch init.
		  			AINIT   =>dummy_in,  -- optional asynch reset to init_val
		  			SSET	=>dummy_in,  -- optional synch set to '1'
		  			SCLR 	=>dummy_in,  -- Synch init.
		  			SINIT	=>dummy_in,	
					O => open_o_d,
					Q => d); --mux1_to_z);


mux2 :  c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH => bfly_width, 
					C_INPUTS => 2,
					C_HAS_O => 0,
					C_HAS_Q => 1,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP ( MA=> c, 
					MB =>a,
					MC => dummy_mux_inputs,
					MD => dummy_mux_inputs,
					ME => dummy_mux_inputs,
					MF => dummy_mux_inputs,
					MG => dummy_mux_inputs,
					MH => dummy_mux_inputs,
					MAA 	=> dummy_mux_inputs_1,
					MAB 	=> dummy_mux_inputs_1,
					MAC 	=> dummy_mux_inputs_1,
					MAD 	=> dummy_mux_inputs_1,
					MAE 	=> dummy_mux_inputs_1,
					MAF 	=> dummy_mux_inputs_1,
					MAG 	=> dummy_mux_inputs_1,
					MAH 	=> dummy_mux_inputs_1,
					MBA 	=> dummy_mux_inputs_1,
					MBB 	=> dummy_mux_inputs_1,
					MBC 	=> dummy_mux_inputs_1,
					MBD 	=> dummy_mux_inputs_1,
					MBE 	=> dummy_mux_inputs_1,
					MBF 	=> dummy_mux_inputs_1,
					MBG 	=> dummy_mux_inputs_1,
					MBH 	=> dummy_mux_inputs_1,
					MCA 	=> dummy_mux_inputs_1,
					MCB 	=> dummy_mux_inputs_1,
					MCC 	=> dummy_mux_inputs_1,
					MCD 	=> dummy_mux_inputs_1,
					MCE 	=> dummy_mux_inputs_1,
					MCF 	=> dummy_mux_inputs_1,
					MCG 	=> dummy_mux_inputs_1,
					MCH 	=> dummy_mux_inputs_1,
					S => mux_select, 
		  			CLK 	=>clk,  -- Optional clock
		  			CE 	=>dummy_in,  -- Optional Clock enable
		  			EN 	=>dummy_in,  -- Optional BUFT enable
		  			ASET 	=>dummy_in,  -- optional asynch set to '1'
		  			ACLR 	=>dummy_in,  -- Asynch init.
		  			AINIT   =>dummy_in,  -- optional asynch reset to init_val
		  			SSET	=>dummy_in,  -- optional synch set to '1'
		  			SCLR 	=>dummy_in,  -- Synch init.
		  			SINIT	=>dummy_in,	
					O => open_o_e,
					Q => e); --mux2_int);





mux_sel_gen: C_COUNTER_BINARY_V4_0
		GENERIC MAP (	C_WIDTH		=> 2,
				C_OUT_TYPE	=> 1, --c_unsigned
				C_COUNT_BY	=> one_string,
				C_AINIT_VAL	=> ainit_val,
				C_SINIT_VAL	=> sinit_val,
				C_LOAD_ENABLE 	=> c_no_override,
				C_SYNC_ENABLE	=>  c_no_override,
				C_HAS_THRESH0	=>  0, --1,
				C_HAS_Q_THRESH0	=>  0,
				C_HAS_CE	=> 1,
				C_HAS_IV	=> 1,
				C_HAS_SCLR	=> 0, --1,
				C_HAS_ACLR	=> 1,
				C_HAS_AINIT 	=> 1,
				C_HAS_SINIT	=> 1)
		PORT MAP (CLK => clk,
			  UP => logic_1,
			  CE => logic_1,
			  LOAD => dummy_in,
			  L => zero,
			  IV => one,
			  ACLR => e_start, --dummy_in,
			  ASET => dummy_in,
			  AINIT => reset,
			  SCLR => dummy_in, --e_start,--dummy_in,
			  SINIT => dummy_in,--start,
			  SSET => dummy_in,
			  THRESH0 => open_thresh0,
			  Q_THRESH0 => open_q_thresh0,   
		  	  THRESH1 => open_thresh1,  
		  	  Q_THRESH1 => open_q_thresh1,
			  Q => count); --_temp);



 ---note: for netlist, depth (tms =1). for beh models, depth=2.--
tms_cgen: If (memory_configuration = 3) GENERATE 
c_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH =>2, --c_delay_value, -- 1, --2 vk agu 23
					DATA_WIDTH => bfly_width)
				PORT MAP (addr => dummy_addr,
					data => by1,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => c);
END GENERATE tms_cgen;
 
dms_cgen: IF ((memory_configuration = 1)OR (memory_configuration = 2)) GENERATE 
c_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => 2, --vkdms aug 28 1, --2 vk agu 23
					DATA_WIDTH => bfly_width)
				PORT MAP (addr => dummy_addr,
					data => by1,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => c);
END GENERATE dms_cgen;

sms_cgen: IF ((memory_configuration = 1)OR (memory_configuration = 2)) GENERATE 
c_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => 2, -- 1, --2 vk agu 23
					DATA_WIDTH => bfly_width)
				PORT MAP (addr => dummy_addr,
					data => by1,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => c);
END GENERATE sms_cgen;


f_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH =>3, --2,
					DATA_WIDTH => bfly_width)
				PORT MAP (addr => dummy_addr,
					data =>d, 
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => f);


state_mc : state_machine_v3
	GENERIC MAP (n =>2)
	PORT MAP (clk => clk,
		    ce => logic_1, --ce,
		    start => e_start,
		    reset => reset,
		    s => cex1x0);

ffty0_gen:	C_REG_FD_V4_0 
		GENERIC MAP (C_WIDTH => bfly_width,
				C_HAS_CE => 1,
				C_HAS_ACLR => 0,
				C_HAS_ASET => 0,
				C_HAS_AINIT => 0,
				C_HAS_SCLR => 0,
				C_HAS_SSET => 0,
				C_HAS_SINIT => 0,
				C_ENABLE_RLOCS  => 1)
		PORT MAP 	(D=> f,
			  	CLK => clk,
			  	CE => ce1,
			  	ACLR => dummy_in, --was reset,
			  	ASET => nc,
			  	AINIT => nc, --was nc,
			  	SCLR => nc,
			  	SSET => nc,
			  	SINIT => nc,
			  	Q =>fft4y0);


ffty1_gen:	C_REG_FD_V4_0 
		GENERIC MAP (C_WIDTH => bfly_width,
				C_HAS_CE => 1,
				C_HAS_ACLR => 0,
				C_HAS_ASET => 0,
				C_HAS_AINIT => 0,
				C_HAS_SCLR => 0,
				C_HAS_SSET => 0,
				C_HAS_SINIT => 0,
				C_ENABLE_RLOCS  => 1)
		PORT MAP 	(D=> f,
			  	CLK => clk,
			  	CE => ce0,
			  	ACLR => dummy_in, --was reset,
			  	ASET => nc,
			  	AINIT => nc, --was nc,
			  	SCLR => nc,
			  	SSET => nc,
			  	SINIT => nc,
			  	Q =>fft4y1);



ffty2_gen: C_REG_FD_V4_0 GENERIC MAP (C_WIDTH => bfly_width,
					 C_HAS_AINIT =>0)
				PORT MAP (D => e_2z,
					CLK => clk,
					CE => ce0,--ce1, --ce0,
					ACLR => dummy_in,
					ASET => dummy_in,
					AINIT => nc, --reset,
					SCLR => dummy_in,
					SSET => dummy_in,
					SINIT => dummy_in,
					Q => fft4y2);


ffty3_gen:	C_REG_FD_V4_0 
		GENERIC MAP (C_WIDTH => bfly_width,
				C_HAS_CE => 1,
				C_HAS_ACLR => 0,
				C_HAS_ASET => 0,
				C_HAS_AINIT => 0,
				C_HAS_SCLR => 0,
				C_HAS_SSET => 0,
				C_HAS_SINIT => 0,
				C_ENABLE_RLOCS  => 1)
		PORT MAP 	(D=> e,
			  	CLK => clk,
			  	CE => ce1, --ce1,
			  	ACLR => dummy_in, --was reset,
			  	ASET => nc,
			  	AINIT => nc, --was nc,
			  	SCLR => nc,
			  	SSET => nc,
			  	SINIT => nc,
			  	Q =>fft4y3);


e_2z_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH =>2,
					DATA_WIDTH => bfly_width)
				PORT MAP (addr => dummy_addr,
					data => e,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => e_2z);


ce0 <= cex1x0(0);
ce1 <= cex1x0(1);


END behavioral;

----------------------------------------END bfly_buffer_v3--------------------------------
---------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
---------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_MUX_BUS_V4_0_comp.all;
USE XilinxCoreLib.C_COUNTER_BINARY_V4_0_comp.all;
USE XilinxCoreLib.prims_constants_v4_0.all;
USE XilinxCoreLib.C_DIST_MEM_V5_0_comp.all;
USE XilinxCoreLib.C_COMPARE_V4_0_comp.all;
USE XilinxCoreLib.C_REG_FD_V4_0_comp.all;


--LIBRARY work;
USE XilinxCoreLib.vfft32_comps_v3.all;
USE XilinxCoreLib.vfft32_pkg_v3.all;


ENTITY bfly_buf_fft_v3 IS
	GENERIC (B	: INTEGER;
		W_WIDTH : INTEGER;
		memory_configuration : INTEGER;
		mem_init_file : STRING;
		mem_init_file_2 : STRING;
		mult_type:	INTEGER :=1); --0 selects lut mult, 1 selects emb v2 mult
	PORT (	clk	: IN STD_LOGIC;
		ce	: IN STD_LOGIC;
		start	: IN STD_LOGIC;
		reset	: IN STD_LOGIC;
		conj	: IN STD_LOGIC;
		fwd_inv	: IN STD_LOGIC;
		rank_number : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		dr	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);
		di	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);
		done	: IN STD_LOGIC;
		xkr	: OUT STD_LOGIC_VECTOR(B-1  DOWNTO 0);  --Re bfly result to wkg mem x or y --was B downto 0
		xki	: OUT STD_LOGIC_VECTOR(B-1  DOWNTO 0);  --Im 
		wr	: IN STD_LOGIC_VECTOR(W_WIDTH-1 DOWNTO 0);  --Re omega
		wi	: IN STD_LOGIC_VECTOR(W_WIDTH-1 DOWNTO 0);  --Im omega
		e_result_avail : OUT STD_LOGIC; --indicates pre-conj results avail from fft4; 2 clocks early of actual result avail to write to memory.
		result_avail : OUT STD_LOGIC;
		e_result_ready : OUT STD_LOGIC; --flag
		bfly_res_avail : OUT STD_LOGIC; --start delayed by bfly32 latency
		e_bfly_res_avail : OUT STD_LOGIC; --start delayed by bfly32 latency -1
		ce_phase_factors : OUT STD_LOGIC;
		ovflo	: OUT STD_LOGIC;
		y0r	: out std_logic_vector(B-1 downto 0);	-- transform outp. samples --B+3 downto 0
		y0i	: out std_logic_vector(B-1 downto 0); --B+3 downto 0
		y1r	: out std_logic_vector(B-1 downto 0); --B+3 downto 0
		y1i	: out std_logic_vector(B-1 downto 0); --B+3 downto 0
		y2r	: out std_logic_vector(B-1 downto 0);--B+3 downto 0
		y2i	: out std_logic_vector(B-1 downto 0); --B+3 downto 0
		y3r	: out std_logic_vector(B-1 downto 0); --B+3 downto 0
		y3i	: out std_logic_vector(B-1 downto 0) ;--B+3 downto 0
		io_out : in std_logic;
		edone_s: in std_logic;
		busy_in : in std_logic
	      );
END bfly_buf_fft_v3 ;

ARCHITECTURE behavioral OF bfly_buf_fft_v3 IS

CONSTANT butterfly_latency : INTEGER :=6; --one less than actual of 7; -- bfly_latency(W_WIDTH, B); --in terms of bfly_clocks
CONSTANT start_to_bfly_input_latency : INTEGER := 3; --master clocks
CONSTANT bfly_res_avail_latency: INTEGER := 17; --3 + 12; --start_to_bfly_input_latency + 2*butterfly_latency; --relative to start, in terms of master clocks 

CONSTANT delay_by_value	: INTEGER := bfly_latency(W_WIDTH, B)+9; --vk aug 32 (-2) 
CONSTANT latency_thro_mult_vgen	: INTEGER	:= mult_latency(W_WIDTH);
CONSTANT latency_thro_comp_mult	: INTEGER	:= 2 + latency_thro_mult_vgen;
--CONSTANT bfly_scale_delay_by	: INTEGER 	:= bfly32_latency(W_WIDTH, B) +8 -2;--vk aug 31(-2) --latency_thro_comp_mult + 2 +2;
CONSTANT bfly_scale_delay_by	: INTEGER 	:= 16; --17; --bfly_res_avail_latency;

CONSTANT  init_value		: STRING(1 TO 5) := "00000";
CONSTANT  count_by_value		: STRING(1 TO 7) := "0000001";
CONSTANT  thresh_0_value	: STRING(1 TO 7) := "0000000";
CONSTANT five			: STRING(1 TO 3) := "101";

SIGNAL start_fft4_temp	: STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL start_fft4 	: STD_LOGIC; --for xcc := '0';
--SIGNAL start_bfly 	: STD_LOGIC; --for xcc := '0';
SIGNAL open_sclr 	: STD_LOGIC := '0';


SIGNAL bfly_y0r 	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL bfly_y0i 	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL bfly_y1r 	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL bfly_y1i 	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL bfly_res_select : STD_LOGIC;
SIGNAL not_bfly_res_select : STD_LOGIC;
SIGNAL mux_select	: STD_LOGIC_VECTOR(0 DOWNTO 0);

SIGNAL xkr_mux 	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL xki_mux 	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);



SIGNAL fft4_x0r		: STD_LOGIC_VECTOR(B-1 DOWNTO 0); --B+1 DOWNTO 0
SIGNAL fft4_x1r		: STD_LOGIC_VECTOR(B-1 DOWNTO 0); --B+1 DOWNTO 0
SIGNAL fft4_x2r		: STD_LOGIC_VECTOR(B-1 DOWNTO 0); --B+1 DOWNTO 0
SIGNAL fft4_x3r		: STD_LOGIC_VECTOR(B-1 DOWNTO 0); --B+1 DOWNTO 0
SIGNAL fft4_x0i		: STD_LOGIC_VECTOR(B-1 DOWNTO 0); --B+1 DOWNTO 0
SIGNAL fft4_x1i		: STD_LOGIC_VECTOR(B-1 DOWNTO 0); --B+1 DOWNTO 0
SIGNAL fft4_x2i		: STD_LOGIC_VECTOR(B-1 DOWNTO 0); --B+1 DOWNTO 0
SIGNAL fft4_x3i		: STD_LOGIC_VECTOR(B-1 DOWNTO 0); --B+1 DOWNTO 0

SIGNAL delay_addr_value : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL early_delay_addr	: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL fft_delay_addr	: STD_LOGIC_VECTOR(0 DOWNTO 0); --was 9 downto 0
SIGNAL start_temp	: STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL bfly_res_avail_temp :STD_LOGIC_VECTOR(0 DOWNTO 0); --for xcc:= (OTHERS => '0');
SIGNAL e_bfly_res_avail_temp :STD_LOGIC_VECTOR(0 DOWNTO 0); --for xcc := (OTHERS => '0');
SIGNAL e_result_avail_temp :STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL result_avail_temp :STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL start_double_buf_temp :STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL start_double_buf : STD_LOGIC; --for xcc:= '0';

SIGNAL e_start_double_buf_temp : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL e_start_double_buf :STD_LOGIC; --for xcc:= '0';

SIGNAL zero_count	: STD_LOGIC; --for xcc	:= '0';


SIGNAL thirty_two_clocks: STD_LOGIC; --for xcc:= '0';

SIGNAL dummy_in		: STD_LOGIC:= '0';

SIGNAL dummy_mux_inputs	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL dummy_mux_inputs_1	 : STD_LOGIC_VECTOR(B-1 DOWNTO 0);

SIGNAL open_q_r		: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL open_q_i		: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL dummy_addr	: STD_LOGIC_VECTOR(0 DOWNTO 0) := (OTHERS => '0');

SIGNAL logic_0		: STD_LOGIC := '0';
SIGNAL logic_1		: STD_LOGIC := '1';

SIGNAL open_q_thresh0	: STD_LOGIC; --for xcc	:= '0';
SIGNAL open_thresh1	: STD_LOGIC; --for xcc		:= '0';
SIGNAL open_q_thresh1	: STD_LOGIC; --for xcc	:= '0';

SIGNAL zero		: STD_LOGIC_VECTOR(4 DOWNTO 0) := "00000";
SIGNAL one		: STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000001";
SIGNAL count		: STD_LOGIC_VECTOR(6 DOWNTO 0);

SIGNAL ninety_five	: STD_LOGIC_VECTOR(6 DOWNTO 0) := "1011111";

SIGNAL three : STD_LOGIC_VECTOR(1 DOWNTO 0);

SIGNAL set_signal:	STD_LOGIC; --for xcc := '0';
SIGNAL counter_ainit:	STD_LOGIC; --for xcc := '0';
SIGNAL temp_counter_ainit:	STD_LOGIC; --for xcc := '0';
SIGNAL to_ff_d:	STD_LOGIC; --for xcc := '0';
SIGNAL to_ainit_logic : STD_LOGIC; --for xcc := '0';
SIGNAL load_signal : STD_LOGIC; --for xcc := '0';


SIGNAL ce_phase_factors_tmp : STD_LOGIC; --for xcc := '0';


SIGNAL scale_factor : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL scale_factor_fft4 : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL scale_rank3_by : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL scale_rank4_by : STD_LOGIC_VECTOR(1 DOWNTO 0);

SIGNAL open_dpo		: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL open_qdpo	: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL open_qspo	: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL dummy_mem_addr	: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL dummy_data	: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL dummy_dpra	: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL bfly_rank_number	: STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL bfly_rank_number_padded: STD_LOGIC_VECTOR(3 DOWNTO 0); 
SIGNAL bfly_rank_number_tmp : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL open_dpo_1		: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL open_qdpo_1	: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL open_qspo_1	: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL fft4_sca_mem_addr: STD_LOGIC_VECTOR(0 DOWNTO 0) := (OTHERS => '0');
SIGNAL fft4_sca_mem_addr_padded: STD_LOGIC_VECTOR(3 DOWNTO 0);

SIGNAL ce0		: STD_LOGIC;		
SIGNAL ce1		: STD_LOGIC;
SIGNAL cex0		: STD_LOGIC;		
SIGNAL cex1		: STD_LOGIC;
SIGNAL	cex1x0		: STD_LOGIC_VECTOR(2-1 DOWNTO 0);
SIGNAL open_di : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL open_x0i : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL open_x0i_3 : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL open_x0i_4 : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL dummy_mem_addr_2	: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL dummy_dpra_2	: STD_LOGIC_VECTOR(3 DOWNTO 0);

SIGNAL open_thresh0	: STD_LOGIC;

SIGNAL zero_7 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
CONSTANT string_zero_7 : STRING (7 DOWNTO 1) := "0000000";

SIGNAL aneb : STD_LOGIC;
SIGNAL altb : STD_LOGIC;
SIGNAL agtb : STD_LOGIC;
SIGNAL aleb : STD_LOGIC;
SIGNAL ageb : STD_LOGIC;
SIGNAL qaeqb : STD_LOGIC;
SIGNAL qaneb : STD_LOGIC;
SIGNAL qaltb : STD_LOGIC;
SIGNAL qagtb : STD_LOGIC;
SIGNAL qaleb : STD_LOGIC;
SIGNAL qageb : STD_LOGIC;

SIGNAL post_conj_reg_bfly_y0r 	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL post_conj_reg_bfly_y0i 	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL post_conj_reg_bfly_y1r 	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);
SIGNAL post_conj_reg_bfly_y1i 	: STD_LOGIC_VECTOR(B-1 DOWNTO 0);

SIGNAL logic_0_temp : STD_LOGIC_VECTOR(3 DOWNTO 0); 
SIGNAL logic_1_temp : STD_LOGIC_VECTOR(3 DOWNTO 0); 

BEGIN

logic_0 <= '0';
logic_1 <= '1';
logic_0_temp <= (OTHERS => '0');
logic_1_temp <= "0001";
dummy_data <= (OTHERS => '0');
dummy_in <= '0';
dummy_addr <=  (OTHERS => '0');
open_di <= (OTHERS => '0');
dummy_mux_inputs <= (OTHERS => '0');
mux_select(0) <= bfly_res_select;
start_temp(0) <= start;
bfly_res_avail <= bfly_res_avail_temp(0);
e_bfly_res_avail <= e_bfly_res_avail_temp(0);
three <= "11";
e_result_avail <= e_result_avail_temp(0); --count(6);
result_avail <= result_avail_temp(0);
e_result_ready <= count(6);

start_fft4 <= start_fft4_temp(0);
start_double_buf <= start_double_buf_temp(0);
e_start_double_buf <= e_start_double_buf_temp(0);

ce_phase_factors <= ce_phase_factors_tmp;

 zero_7 <= (OTHERS => '0'); --"0000000"; vk for xcc
ninety_five(6) <= '1';--"1011111"  vk for xcc
ninety_five(5) <= '0';
ninety_five(4) <= '1';
ninety_five(3) <= '1';
ninety_five(2) <= '1';
ninety_five(1) <= '1';
ninety_five(0) <= '1';

scal_prof_mem : c_dist_mem_v5_0
		GENERIC MAP (C_ADDR_WIDTH =>4, -- for xcc 3,
			C_DEPTH =>3, --5,
			C_WIDTH => 2,
			C_HAS_D => 0,
			C_HAS_DPRA => 0,
			C_HAS_SPRA =>0,
			C_HAS_QSPO => 0,
			C_HAS_QDPO => 0,
			C_HAS_DPO => 0,
			C_HAS_SPO => 1,
			C_HAS_WE  => 0,
			C_HAS_QDPO_RST => 0,
			C_HAS_QSPO_RST => 0,
			C_MEM_TYPE => 0,--sp ram
			C_MEM_INIT_FILE => mem_init_file,
			C_READ_MIF =>1)  
		PORT MAP ( A =>bfly_rank_number_padded , 
			D => dummy_data,
			DPRA => dummy_dpra,
			SPRA =>dummy_mem_addr ,
			CLK => clk,
			we => dummy_in,
			I_CE => dummy_in,
			RD_EN => logic_1,
			QSPO_CE => dummy_in, 
			QDPO_CE => dummy_in,
			QDPO_CLK => dummy_in,
			QSPO_RST => dummy_in, 
			QDPO_RST => dummy_in,
			SPO => scale_factor,
			DPO => open_dpo,
			QSPO => open_qspo,
			QDPO => open_qdpo);


bfly_rank_number_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => bfly_scale_delay_by, ---2,-- 1 for 16vk sept 5 was 2, 
					DATA_WIDTH => 2)
				PORT MAP (addr => dummy_addr,
					data => rank_number,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => bfly_rank_number_tmp);

--bfly_rank_number <= '0' & bfly_rank_number_tmp;
--break it up for xcc--also padded it by 1 bit to make it 4 bits since that's the minimum
-- addr width the c_dist_mem_v4_1 wants

bfly_rank_number_padded(3) <= '0';
bfly_rank_number_padded(2) <= '0';
bfly_rank_number_padded(1) <= bfly_rank_number_tmp(1);
bfly_rank_number_padded(0) <= bfly_rank_number_tmp(0);



fft4_sca_prof_mem : c_dist_mem_v5_0
		GENERIC MAP (C_ADDR_WIDTH =>4, --1,
			C_DEPTH =>2,
			C_WIDTH => 2,
			C_HAS_D => 1,
			C_HAS_DPRA => 1,
			C_HAS_SPRA =>0,
			C_HAS_QSPO => 1, --0,
			C_HAS_QDPO => 1, --0,
			C_HAS_DPO => 0, --1,
			C_HAS_SPO => 0, --1,
			C_HAS_WE  => 1,
			C_HAS_QDPO_RST => 0,
			C_HAS_QSPO_RST => 0,
			C_MEM_TYPE => 2,--dp sp ram
			C_MEM_INIT_FILE => mem_init_file_2,
			C_READ_MIF =>1)  
		PORT MAP ( A =>logic_0_temp,  
			D => dummy_data, 
			DPRA => logic_1_temp, 
			SPRA =>dummy_mem_addr_2 ,
			CLK => clk,
			we => logic_0, 
			I_CE => dummy_in,
			RD_EN => logic_1,
			QSPO_CE => logic_1,  
			QDPO_CE => logic_1,
			QDPO_CLK => clk, 
			QSPO_RST => dummy_in, 
			QDPO_RST => dummy_in,
			SPO => open_qspo_1,
			DPO => open_qdpo_1,
			QSPO => scale_rank3_by, 
			QDPO => scale_rank4_by);



state_mc : state_machine_v3
	GENERIC MAP (n =>2)
	PORT MAP (clk => clk,
		    ce => logic_1, --ce,
		    start => start,
		    reset => reset,
		    s => cex1x0);
cex1 <= cex1x0(0);
cex0 <= cex1x0(1);


gen_ce0: and_a_b_32_v3 PORT MAP(a_in =>logic_1, -- ce,
					b_in => cex0,
					and_out => ce0);

gen_ce1: and_a_b_32_v3 PORT MAP(a_in => logic_1, --ce,
					b_in => cex1,
					and_out => ce1);

bfly	: butterfly_32_v3 GENERIC MAP(B => B,
				W_WIDTH => W_WIDTH,
				memory_architecture => memory_configuration,
				mult_type => mult_type)
			PORT MAP (clk => clk,
					ce => ce,
					start => start,
					reset => reset,
					conj => conj,
					dr => dr,
					di => di,
					scale_factor => scale_factor,
					ce_phase_factors => ce_phase_factors_tmp,
					done => done,
					y0r => bfly_y0r,
					y0i => bfly_y0i,
					y1r => bfly_y1r,
					y1i => bfly_y1i,
					ovflo => ovflo,
					wi => wi,
					wr => wr,
					io_out => io_out,
					edone_s => edone_s,
					busy_in => busy_in
					);



bfly_res_seq: flip_flop_sclr_sset_v3 PORT MAP (D => not_bfly_res_select,
					clk  => clk,
					ce => ce,
					reset => start,
					sclr => dummy_in,
					sset => e_bfly_res_avail_temp(0),
					q => bfly_res_select);

--not_bfly_res_select <= not bfly_res_select;
--using nand to generate inversion
inv_gen: nand_a_b_32_v3 PORT MAP (a_in => bfly_res_select,
			b_in => bfly_res_select,
			nand_out => not_bfly_res_select); 

bfly_res_mux_r :  c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH => B, -- B+2,
					C_INPUTS => 2,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP ( MA=> bfly_y1r, --bfly_y0r,
					MB => bfly_y0r, --bfly_y1r,
					MC => dummy_mux_inputs,
					MD => dummy_mux_inputs,
					ME => dummy_mux_inputs,
					MF => dummy_mux_inputs,
					MG => dummy_mux_inputs,
					MH => dummy_mux_inputs,
					MAA 	=> dummy_mux_inputs_1,
					MAB 	=> dummy_mux_inputs_1,
					MAC 	=> dummy_mux_inputs_1,
					MAD 	=> dummy_mux_inputs_1,
					MAE 	=> dummy_mux_inputs_1,
					MAF 	=> dummy_mux_inputs_1,
					MAG 	=> dummy_mux_inputs_1,
					MAH 	=> dummy_mux_inputs_1,
					MBA 	=> dummy_mux_inputs_1,
					MBB 	=> dummy_mux_inputs_1,
					MBC 	=> dummy_mux_inputs_1,
					MBD 	=> dummy_mux_inputs_1,
					MBE 	=> dummy_mux_inputs_1,
					MBF 	=> dummy_mux_inputs_1,
					MBG 	=> dummy_mux_inputs_1,
					MBH 	=> dummy_mux_inputs_1,
					MCA 	=> dummy_mux_inputs_1,
					MCB 	=> dummy_mux_inputs_1,
					MCC 	=> dummy_mux_inputs_1,
					MCD 	=> dummy_mux_inputs_1,
					MCE 	=> dummy_mux_inputs_1,
					MCF 	=> dummy_mux_inputs_1,
					MCG 	=> dummy_mux_inputs_1,
					MCH 	=> dummy_mux_inputs_1,
					S => mux_select,
		  			CLK 	=>dummy_in, -- Optional clock
		  			--CE 	=>dummy_in,  -- Optional Clock enable
		  			--EN 	=>dummy_in,  -- Optional BUFT enable
		  			--ASET 	=>dummy_in, -- optional asynch set to '1'
		  			--ACLR 	=>dummy_in, -- Asynch init.
		  			--AINIT =>dummy_in, -- optional asynch reset to init_val
		  			--SSET	=>dummy_in, -- optional synch set to '1'
		  			--SCLR 	=>dummy_in, -- Synch init.
		  			---SINIT	=>dummy_in,	
					O => xkr_mux, --bfly_result_r to working mem x or y,
					Q => open_q_r);

bfly_res_mux_i :  c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH =>B, -- B+2,
					C_INPUTS => 2,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP ( MA=> bfly_y1i, --bfly_y0i,
					MB => bfly_y0i, --bfly_y1i,
					MC => dummy_mux_inputs,
					MD => dummy_mux_inputs,
					ME => dummy_mux_inputs,
					MF => dummy_mux_inputs,
					MG => dummy_mux_inputs,
					MH => dummy_mux_inputs,
					MAA 	=> dummy_mux_inputs_1,
					MAB 	=> dummy_mux_inputs_1,
					MAC 	=> dummy_mux_inputs_1,
					MAD 	=> dummy_mux_inputs_1,
					MAE 	=> dummy_mux_inputs_1,
					MAF 	=> dummy_mux_inputs_1,
					MAG 	=> dummy_mux_inputs_1,
					MAH 	=> dummy_mux_inputs_1,
					MBA 	=> dummy_mux_inputs_1,
					MBB 	=> dummy_mux_inputs_1,
					MBC 	=> dummy_mux_inputs_1,
					MBD 	=> dummy_mux_inputs_1,
					MBE 	=> dummy_mux_inputs_1,
					MBF 	=> dummy_mux_inputs_1,
					MBG 	=> dummy_mux_inputs_1,
					MBH 	=> dummy_mux_inputs_1,
					MCA 	=> dummy_mux_inputs_1,
					MCB 	=> dummy_mux_inputs_1,
					MCC 	=> dummy_mux_inputs_1,
					MCD 	=> dummy_mux_inputs_1,
					MCE 	=> dummy_mux_inputs_1,
					MCF 	=> dummy_mux_inputs_1,
					MCG 	=> dummy_mux_inputs_1,
					MCH 	=> dummy_mux_inputs_1,
					S => mux_select,
		  			CLK 	=>dummy_in, -- Optional clock
		  			--CE 	=>dummy_in,  -- Optional Clock enable
		  			--EN 	=>dummy_in,  -- Optional BUFT enable
		  			--ASET 	=>dummy_in, -- optional asynch set to '1'
		  			--ACLR 	=>dummy_in, -- Asynch init.
		  			--AINIT =>dummy_in, -- optional asynch reset to init_val
		  			--SSET	=>dummy_in, -- optional synch set to '1'
		  			--SCLR 	=>dummy_in, -- Synch init.
		  			--SINIT	=>dummy_in,	
					O => xki_mux, --bfly_result_i to working mem x or y,
					Q => open_q_i);



xkr <= xkr_mux;
xki <= xki_mux;


--Insert conjugation between output of butterfly processor and crossbar switch (called double_buffer here).

conj_reg_y0 : conj_reg_v3 GENERIC MAP (B => B)
			PORT MAP (clk => clk, --vk nov 7 ce_phase_factors_tmp, --vk oct 18clk,
				ce => ce,
				fwd_inv => fwd_inv,
				dr => bfly_y0r,
				di => bfly_y0i,
				qr => post_conj_reg_bfly_y0r,
				qi => post_conj_reg_bfly_y0i);

conj_reg_y1 : conj_reg_v3 GENERIC MAP (B => B)
			PORT MAP (clk => clk, --vk nov 7 ce_phase_factors_tmp, --vk oct 18clk,
				ce => ce,
				fwd_inv => fwd_inv,
				dr => bfly_y1r,
				di => bfly_y1i,
				qr => post_conj_reg_bfly_y1r,
				qi => post_conj_reg_bfly_y1i);


start_double_buf_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => 34, --64, --res of rank2 avail 
					DATA_WIDTH => 1)
				PORT MAP (addr => dummy_addr,
					data => bfly_res_avail_temp, --e_bfly_res_avail_temp,
					clk => cex0, --cex1, --cex0, --ce0, --clk,
					reset => reset,
					start => start,
					delayed_data => start_double_buf_temp);

e_start_double_buf_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => 30, -- vk nov 7 31, --vk oct 18 33,  
					DATA_WIDTH => 1)
				PORT MAP (addr => dummy_addr,
					data => e_bfly_res_avail_temp,
					clk => cex1, --cex0, --cex1, --ce0, --clk,
					reset => reset,
					start => start,
					delayed_data => e_start_double_buf_temp);


double_buf_re: bfly_buffer_v3 GENERIC MAP(bfly_width => B,
					memory_configuration => memory_configuration)
				PORT MAP (by0 => post_conj_reg_bfly_y0r, --bfly_y0r,
						by1 =>post_conj_reg_bfly_y1r, --bfly_y1r,
						clk => ce_phase_factors_tmp, --clk,
						reset => reset,
						start => start_double_buf, --start, --start_double_buf,
						e_start => e_start_double_buf,
						fft4y0 =>fft4_x0r,
						fft4y1 => fft4_x1r,
						fft4y2 => fft4_x2r,
						fft4y3 => fft4_x3r);
						
double_buf_im: bfly_buffer_v3 GENERIC MAP(bfly_width => B,
					memory_configuration => memory_configuration)
				PORT MAP (by0 => post_conj_reg_bfly_y0i, --bfly_y0i,
						by1 =>post_conj_reg_bfly_y1i, --bfly_y1i,
						clk => ce_phase_factors_tmp, --clk,
						reset => reset,
						start => start_double_buf, --start, --start_double_buf,
						e_start => e_start_double_buf,
						fft4y0 => fft4_x0i  ,
						fft4y1 => fft4_x1i  ,
						fft4y2 => fft4_x2i    ,
						fft4y3 => fft4_x3i);


last_2_ranks_fft4: fft4_32_v3	GENERIC MAP (B => B) --B+2
				PORT MAP (clk => clk,
					reset => reset,
					start =>start_fft4,-- bfly_res_avail_temp(0), 
					ce => ce,
					conj => fwd_inv, --conj,
					scale_rank3_by => scale_rank3_by,
					scale_rank4_by => scale_rank4_by,
					x0r => fft4_x0r,
					x0i => fft4_x0i,
					x1r => fft4_x1r,
					x1i => fft4_x1i,
					x2r => fft4_x2r,
					x2i => fft4_x2i,
					x3r => fft4_x3r,
					x3i => fft4_x3i,
					y0r => y0r, --result_y0r,
					y0i => y0i, --result_y0i,
					y1r => y1r, --result_y1r,
					y1i => y1i, --result_y1i,
					y2r => y2r, --result_y2r,
					y2i => y2i, --result_y2i,
					y3r => y3r, --result_y3r,
					y3i => y3i --result_y3i);
);

 
--generate bfly_res_avail by delaying start by bfly32 latency value --

delay_addr_value <= get_delay_addr(W_WIDTH);


blfy_res_avail_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>4,
					DEPTH => bfly_res_avail_latency, --vk dept 6 was +1 --delay_by_value, 
					DATA_WIDTH => 1)
				PORT MAP (addr => delay_addr_value,
					data => start_temp,
					clk => clk,
					reset => reset,
					start => dummy_in, --vknov301start,
					delayed_data => bfly_res_avail_temp);

--generate early_bfly_res_avail by delaying start by bfly32 latency value -1 --

early_delay_addr <= get_early_delay_addr(W_WIDTH);

e_blfy_res_avail_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>4,
					DEPTH => bfly_res_avail_latency -1 , --for 16 -1,--vk spet 6 -1 --(was -1)--delay_by_value-1, 
					DATA_WIDTH => 1)
				PORT MAP (addr => early_delay_addr,
					data => start_temp,
					clk => clk,
					reset => reset,
					start => dummy_in, --vknov301start,
					delayed_data => e_bfly_res_avail_temp);


--delay bfly_res_avail_temp by 95 clocks to generate fft4 start signal.

fft4_startgen: delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH => 1,
					DEPTH =>  bfly_res_avail_latency + 31 + 32 +4, --73, --95, --71, --(31(r0) +32(r1)+8(1st 8 results of r2)) --95,
					DATA_WIDTH => 1)
				PORT MAP (addr => dummy_addr,
					data => start_temp, --bfly_res_avail_temp,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => start_fft4_temp);


fft_delay_addr(0) <= '0';
------------------------------------------------------------------------------
-- need 102 clocks after bfly_res_avail. Using early signal to accomodate 1 reg
-- delay to set result_avial flag.
------------------------------------------------------------------------------
e_result_avail_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH =>2+9 , --vk nov 7   +2, --vk added +2 oct 18
					DATA_WIDTH => 1)
				PORT MAP (addr => fft_delay_addr,
					data =>start_fft4_temp, --start_temp, --e_bfly_res_avail_temp,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => e_result_avail_temp); 

result_avail_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH =>2,
					DATA_WIDTH => 1)
				PORT MAP (addr => fft_delay_addr,
					data =>e_result_avail_temp,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => result_avail_temp);


sr_result_avail_temp: srflop_v3 PORT MAP (clk => clk,
					ce => ce,
					set => start,
					reset => e_result_avail_temp(0),
					q => temp_counter_ainit);

ainit_logic: and_a_notb_32_v3 PORT MAP(a_in => temp_counter_ainit,
				b_in => e_result_avail_temp(0),
				and_out => counter_ainit);
 




result_96_counter : c_counter_binary_v4_0
			GENERIC MAP(C_WIDTH => 7,
				C_OUT_TYPE => 1, --unsigned ??
			 	C_RESTRICT_COUNT=> 1,
			 	C_COUNT_TO =>init_value,
				C_COUNT_BY =>count_by_value,
			 	C_COUNT_MODE => 1,
			 	C_THRESH0_VALUE => thresh_0_value, 
			 	C_THRESH1_VALUE =>  "",
			 	C_AINIT_VAL => init_value,
			 	C_SINIT_VAL => init_value,
			 	C_LOAD_ENABLE 	=> c_no_override,
			 	C_SYNC_ENABLE	=>  c_no_override,
			 	C_SYNC_PRIORITY	=>  c_clear,
			 	C_PIPE_STAGES	=>  1,
			 	C_HAS_THRESH0	=>  0, --1,
			 	C_HAS_Q_THRESH0	=>  0,
			 	C_HAS_THRESH1	=>  0,
			 	C_HAS_Q_THRESH1=>  0,
				C_HAS_CE => 1,
			 	C_HAS_UP=>  0,
			 	C_HAS_IV=>  1,
			 	C_HAS_L=>  1,
			 	C_HAS_LOAD=>  1,
			 	C_LOAD_LOW=>  0,
			 	C_HAS_ACLR=>  0,
			 	C_HAS_ASET=> 0,
			 	C_HAS_SSET=>  0,
			 	C_HAS_SINIT=>  0,
				C_HAS_SCLR => 1,
				C_HAS_AINIT =>0)
			PORT MAP(CLK => clk,
				UP => logic_0,
				CE => ce,
				LOAD => load_signal, --zero_count,
		  		L => ninety_five,  -- Optional Synch load value
		  		IV  => one,  -- Optional Increment value
		  		ACLR  => dummy_in ,
		  		--ASET  => dummy_in, 
				SCLR => counter_ainit,
				--AINIT => dummy_in, --counter_ainit,
				--SINIT => dummy_in,
		  		--SSET => dummy_in, 
		 		--THRESH0 => open_thresh0, --zero_count,  
		  		--Q_THRESH0  => open_q_thresh0,  
		  		--THRESH1 => open_thresh1,  
		  		--Q_THRESH1 => open_q_thresh1,
				Q => count);

--zero_count <= '1' WHEN count ="0000000" ELSE '0';

zero_count_gen:	C_COMPARE_V4_0 GENERIC MAP(C_WIDTH =>7,
						C_B_CONSTANT => 1,
						C_B_VALUE => string_zero_7,
						C_HAS_A_EQ_B => 1)
				PORT MAP (A=> count,
					B => zero_7,
					CLK => clk,
					--CE => dummy_in,
					--ACLR => dummy_in,
					--ASET => dummy_in,
					--SCLR => start, 
					--SSET => dummy_in,
					A_EQ_B => zero_count, 
					A_NE_B => aneb,
					A_LT_B => altb,	
					A_GT_B => agtb,	
					A_LE_B => aleb,	
					A_GE_B => ageb,	
					QA_EQ_B => qaeqb,
					QA_NE_B => qaneb,	
					QA_LT_B => qaltb,	
					QA_GT_B => qagtb,	
					QA_LE_B => qaleb,	
					QA_GE_B => qageb	
					);





load_logic: and_a_notb_32_v3 PORT MAP(a_in => zero_count,
				b_in => counter_ainit,
				and_out => load_signal);


END behavioral;

----------------------------------------END bfly_buf_fft_v3.vhd------------------------------------
--------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
--------------------------------------------------------------------------
-- Last modified on 03/06/00
-- Name : phase_factor_adgen.vhd
-- Function : Generates 2 addresses: cosine address and -ve sine address.
--		: These addresses are used to address into 2 separate sin_cos look 
--		: up tables. 
-- 04/03/00 : Initial rev. of file.
-- Last modified on 03/30/00
-----------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.prims_constants_v4_0.all;
USE XilinxCoreLib.C_MUX_BUS_V4_0_comp.all;
USE XilinxCoreLib.C_COUNTER_BINARY_V4_0_comp.all;
USE XilinxCoreLib.C_ADDSUB_V4_0_comp.all;
USE XilinxCoreLib.vfft32_comps_v3.all;
USE XilinxCoreLib.vfft32_pkg_v3.all;
	
ENTITY phase_factor_adgen_v3 is
	GENERIC ( W_WIDTH:	INTEGER:= 16);
	port (
		clk		: in std_logic;				-- system clock
		reset		: in std_logic;				-- reset
		start		: in std_logic;				-- global start
		ce		: in std_logic;
		fwd_inv		: IN STD_LOGIC;
		rank_number	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		w_addr_sine	: OUT STD_LOGIC_VECTOR(4 DOWNTO 0); --shifted by 1/2 cycle 
		w_addr_cos	: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	      );
END phase_factor_adgen_v3;

ARCHITECTURE behavioral OF phase_factor_adgen_v3 IS

CONSTANT ainit_val	: STRING(1 TO 4) := "0000";
CONSTANT sinit_val	: STRING(1 TO 4) := "0000";
CONSTANT fifteen	: STRING(1 TO 4) := "1111";
CONSTANT sixteen_string	: STRING(1 TO 5) := "10000";
CONSTANT zero_string	: STRING(1 TO 5) := "00000";

CONSTANT offset_string	: STRING(1 TO 5) := sixteen_string; --get_offset_value(fwd_inv, sixteen_string, zero_string);

SIGNAL w_addr		:STD_LOGIC_VECTOR(3 DOWNTO 0);

SIGNAL logic0		: STD_LOGIC := '0';
SIGNAL logic_1		: STD_LOGIC := '1';
SIGNAL	dummy_in	: STD_LOGIC := '0';

SIGNAL open_thresh0	: STD_LOGIC;
SIGNAL open_q_thresh0	: STD_LOGIC;
SIGNAL open_thresh1	: STD_LOGIC;
SIGNAL open_q_thresh1	: STD_LOGIC;

SIGNAL open_ovfl		:STD_LOGIC;
SIGNAL open_c_out		:STD_LOGIC; 
SIGNAL open_b_out		:STD_LOGIC; 
SIGNAL open_q_ovfl		:STD_LOGIC; 
SIGNAL open_q_c_out		:STD_LOGIC; 
SIGNAL open_q_b_out		:STD_LOGIC; 
SIGNAL open_s		:STD_LOGIC_VECTOR(4 DOWNTO 0);  


SIGNAL addr_to_mux	: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL rank1_ph_addr	: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL rank2_ph_addr	: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL dummy_mux_inputs	: STD_LOGIC_VECTOR(4-1 DOWNTO 0);
SIGNAL open_q_0	: STD_LOGIC_VECTOR(4-1 DOWNTO 0);

SIGNAL one	: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
SIGNAL zero	: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
SIGNAL zero_1	: STD_LOGIC_VECTOR(4 DOWNTO 0) := "00000";
SIGNAL sixteen	: STD_LOGIC_VECTOR(4 DOWNTO 0) := "10000";
SIGNAL offset_value	: STD_LOGIC_VECTOR(4 DOWNTO 0) ;  --"10000";



BEGIN

logic0 <= '0';
logic_1 <= '1';
dummy_in <= '0';
one(0) <= '1';
one(1) <= '0';
one(2) <= '0';
one(3) <= '0';
zero <= (OTHERS => '0');
zero_1 <= (OTHERS => '0');
sixteen(4) <= '1';
sixteen(3) <= '0';
sixteen(2) <= '0';
sixteen(1) <= '0';
sixteen(0) <= '0';




--rank1_ph_addr <= addr_to_mux(2 DOWNTO 0) & '0';
--rank2_ph_addr <= addr_to_mux(1 DOWNTO 0) & "00";

--break it up for xcc--
rank1_ph_addr(3) <= addr_to_mux(2);
rank1_ph_addr(2) <= addr_to_mux(1);
rank1_ph_addr(1) <= addr_to_mux(0);
rank1_ph_addr(0) <= '0';

rank2_ph_addr(3) <= addr_to_mux(1);
rank2_ph_addr(2) <= addr_to_mux(0);
rank2_ph_addr(1) <= '0';
rank2_ph_addr(0) <= '0';

one <= "0001";
zero <= "0000";
sixteen <= "10000";
zero_1 <= "00000";

--sixteen_gen: IF (fwd_inv='1') GENERATE
--	offset_value <= sixteen;
--END GENERATE;
--zero_1_gen: IF (fwd_inv='0') GENERATE
--	offset_value <= zero_1;
--END GENERATE;


--offset_value <= fwd_inv & "0000";
--break it up for xcc--
offset_value(4) <= fwd_inv;
offset_value(3) <= '0';
offset_value(2) <= '0';
offset_value(1) <= '0';
offset_value(0) <= '0';



addr_gen_v3: C_COUNTER_BINARY_V4_0
		GENERIC MAP (	C_WIDTH		=> 4,
				C_OUT_TYPE	=> 1,  --unsigned
				C_THRESH0_VALUE => fifteen,
				C_AINIT_VAL	=> ainit_val,
				C_SINIT_VAL => sinit_val,
				C_LOAD_ENABLE 	=> c_no_override,
				C_SYNC_ENABLE	=>  c_no_override,
				C_HAS_THRESH0	=>  1,
				C_HAS_CE	=> 1,
				C_HAS_SCLR	=> 0,
				C_HAS_SINIT => 1,
				C_HAS_AINIT 	=> 0,
				C_HAS_LOAD	=>1,
				C_HAS_IV	=> 1)
		PORT MAP (CLK => clk,
			  UP => logic_1,
			  CE => ce,
			  LOAD => dummy_in,
			  L => zero,
			  IV => one,
			  ACLR => dummy_in,
			  ASET => dummy_in,
			  AINIT => reset,
			  SCLR => dummy_in,
			  SINIT => start,
			  SSET => dummy_in,
			  THRESH0 => open_thresh0,
			  Q_THRESH0 => open_q_thresh0,  
		  	  THRESH1 => open_thresh1,  
		  	  Q_THRESH1 => open_q_thresh1,
			  Q => addr_to_mux);


addr_mux: c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH => 4,
					C_INPUTS => 3,
					C_SEL_WIDTH =>2,
					C_HAS_O => 1,
					C_HAS_Q => 1,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP (MA	=> addr_to_mux, --rank0_ph_addr
				MB 	=> rank1_ph_addr,
				MC 	=> rank2_ph_addr,
				MD 	=> dummy_mux_inputs,
				ME 	=> dummy_mux_inputs,
				MF	=> dummy_mux_inputs,
				MG 	=> dummy_mux_inputs,
				MH 	=> dummy_mux_inputs,
				S 	=> rank_number,
		  		CLK 	=> clk, 
		  		CE 	=> dummy_in, 
		  		EN 	=> dummy_in, 
		  		ASET 	=> dummy_in, 
		  		ACLR 	=> dummy_in, 
		  		AINIT 	=> dummy_in, 
		  		SSET	=> dummy_in, 
		  		SCLR 	=> dummy_in, 		
		  		SINIT	=> dummy_in,	
				O	=> w_addr,  -- addr to cosine table
				Q 	=> w_addr_cos); --open_q_0);



-- offset w_addr by 16 to address sine table and generate -ve sine value since
-- cos (theta) -j sin(theta) is required.


neg_sine_offset: c_addsub_v4_0
			   GENERIC MAP (C_A_WIDTH => 4,
				C_B_WIDTH => 5,
				C_OUT_WIDTH => 5,
				C_LOW_BIT => 0,
				C_HIGH_BIT => 4,
				C_ADD_MODE => 0,		--c_add,
				C_A_TYPE => 1,			--c_unsigned,
				C_B_TYPE => 1,			--c_unsigned,
				C_B_CONSTANT => 0, --1,
				C_B_VALUE => offset_string, --sixteen_string,
				C_AINIT_VAL => "0",
				C_SINIT_VAL => "0",
				C_BYPASS_ENABLE => 0,
				C_BYPASS_LOW => 0,
				--C_SYNC_ENABLE=> c_override; 	   
				--C_SYNC_PRIORITY	=> c_clear;	   
				C_PIPE_STAGES=> 1,
				C_HAS_S=> 0,
				C_HAS_Q	=> 1,
			 	C_HAS_C_IN =>0,
				C_HAS_C_OUT=> 0,
				C_HAS_Q_C_OUT=> 0,
				C_HAS_B_IN => 0,
				C_HAS_B_OUT=> 0,
			 	C_HAS_Q_B_OUT=> 0,
			 	C_HAS_OVFL=> 0,
			 	C_HAS_Q_OVFL=> 0,
			 	C_HAS_CE => 0, -- 1,
			 	C_HAS_ADD => 0,
			 	C_HAS_BYPASS=> 0,
			 	C_HAS_A_SIGNED=> 0,
			 	C_HAS_B_SIGNED=> 0,
			 	C_HAS_ACLR=> 0,
			 	C_HAS_ASET=> 0,
			 	C_HAS_AINIT=> 1,
			 	C_HAS_SCLR=> 1,
			 	C_HAS_SSET=> 0,
			 	C_HAS_SINIT=> 0,
			 	C_ENABLE_RLOCS=> 1)
		PORT MAP (	A => w_addr, 
				B=> offset_value, --sixteen, 
				CLK => clk,
				ADD => dummy_in,
				C_IN => logic0, --logic_1,
				B_IN => logic0,
				CE => logic0, --ce,
				BYPASS => dummy_in,
				ACLR => dummy_in,
				ASET => dummy_in,
				AINIT => reset,
				SCLR => start,
				SSET => dummy_in,
				SINIT => dummy_in,
				A_SIGNED => logic0,
				B_SIGNED => logic0,
				OVFL => open_ovfl,
				C_OUT => open_c_out,
				B_OUT => open_b_out,
				Q_OVFL => open_q_ovfl,
				Q_C_OUT => open_q_c_out,
				Q_B_OUT => open_q_b_out,
				S => open_s,
				Q => w_addr_sine);

END behavioral;

----------------------------END phase_factor_adgen--------------------------------------------
--------------------------------------------------------------------------
-- $Id: vfft32_v3_0.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
--------------------------------------------------------------------------
-- Last modified on 03/06/00
-- Name : phase_factors.vhd
-- Function : implements cos(theta) -j sin(theta)
-- 06/26/00 : Initial rev. of file.
-- Last modified on 7/3/00 : dropped 2's comp to negate sine output. 
--		: Instead use 2 sincos luts-one for cos and one for -ve sine.
--		: sine addresses out of phase_factor_adgen shifted by 16 from cos 
--		: address.
-----------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
 
LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_SIN_COS_V4_0_COMP.all;
USE XilinxCoreLib.C_TWOS_COMP_V4_0_comp.all;
USE XilinxCoreLib.prims_constants_v4_0.all;
USE XilinxCoreLib.vfft32_comps_v3.all;
USE XilinxCoreLib.vfft32_pkg_v3.all;

ENTITY phase_factors_v3  is
	GENERIC ( W_WIDTH:	INTEGER:= 16);
	port (
		clk		: in std_logic;				-- system clock
		reset		: in std_logic;				-- reset
		start		: in std_logic;				-- global start
		ce		: in std_logic;
		fwd_inv		: IN STD_LOGIC;
		rank_number	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		wr		: OUT STD_LOGIC_VECTOR(W_WIDTH-1 DOWNTO 0);
		wi		: OUT STD_LOGIC_VECTOR(W_WIDTH-1 DOWNTO 0)
	      );
END phase_factors_v3 ;

ARCHITECTURE behavioral OF phase_factors_v3  IS

SIGNAL w_addr_cos : STD_LOGIC_VECTOR(4 DOWNTO 0); --set to 5 bits although addr is 4 bits wide!
SIGNAL w_addr_sin : STD_LOGIC_VECTOR(4 DOWNTO 0); 
SIGNAL sine: STD_LOGIC_VECTOR(W_WIDTH-1 DOWNTO 0);
SIGNAL cosine: STD_LOGIC_VECTOR(W_WIDTH-1 DOWNTO 0);


SIGNAL dummy_in : STD_LOGIC := '0';
SIGNAL open_rfd : STD_LOGIC; --for xcc := '0';
SIGNAL open_rdy : STD_LOGIC; --for xcc := '0';
SIGNAL open_aclr : STD_LOGIC; --for xcc := '0';
SIGNAL open_rfd_s : STD_LOGIC; --for xcc := '0';
SIGNAL open_rdy_s : STD_LOGIC ; --for xcc:= '0';
SIGNAL open_aclr_s : STD_LOGIC; --for xcc := '0';
SIGNAL open_sine: STD_LOGIC_VECTOR(W_WIDTH-1 DOWNTO 0);
SIGNAL open_cosine: STD_LOGIC_VECTOR(W_WIDTH-1 DOWNTO 0);



BEGIN

dummy_in <= '0';
w_addr_cos(4) <= '0'; --tie top bit low

w_address: phase_factor_adgen_v3 
		GENERIC MAP (W_WIDTH => W_WIDTH)
		PORT MAP (clk => clk,
				reset => reset,
				start => start,
				ce => ce,
				fwd_inv => fwd_inv,
				rank_number=> rank_number,
				w_addr_cos => w_addr_cos(3 DOWNTO 0),
				w_addr_sine => w_addr_sin(4 DOWNTO 0));


sincos_cosine : c_sin_cos_v4_0 GENERIC MAP (C_THETA_WIDTH => 5,
				C_OUTPUT_WIDTH => W_WIDTH,
				C_OUTPUTS_REQUIRED => 1, --COSINE
				C_MEM_TYPE => 0, --DIST_ROM,
				C_PIPE_STAGES => 0,
				C_REG_OUTPUT => 1,
				C_HAS_ACLR => 1,
				C_HAS_ND => 0,
				C_HAS_RFD => 0,
				C_HAS_RDY => 0,
				C_HAS_CE => 1,
				C_LATENCY => 1)
		PORT MAP (theta => w_addr_cos,
			sine => open_sine,
			cosine => cosine,
			nd => dummy_in,
			rfd => open_rfd,
			rdy => open_rdy,
			clk => clk,
			ce => ce,
			aclr => reset,
			sclr => open_aclr);

sincos_neg_sine : c_sin_cos_v4_0 GENERIC MAP (C_THETA_WIDTH => 5,
				C_OUTPUT_WIDTH => W_WIDTH,
				C_OUTPUTS_REQUIRED => 0, --SINE
				C_MEM_TYPE => 0, --DIST_ROM,
				C_PIPE_STAGES => 0,
				C_REG_OUTPUT => 1,
				C_HAS_ACLR => 1,
				C_HAS_ND => 0,
				C_HAS_RFD => 0,
				C_HAS_RDY => 0,
				C_HAS_CE => 1,
				C_LATENCY => 1)
		PORT MAP (theta => w_addr_sin,
			sine => sine,
			cosine => open_cosine,
			nd => dummy_in,
			rfd => open_rfd_s,
			rdy => open_rdy_s,
			clk => clk,
			ce => ce,
			aclr => reset,
			sclr => open_aclr_s);				

wr <= cosine;
wi <= sine;

END behavioral;

--------------------------------ENd phase_factors.vhd-----------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
		
LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_MUX_BUS_V4_0_comp.all;
USE XilinxCoreLib.blkmemdp_v4_0_comp.all;
USE XilinxCoreLib.c_dist_mem_v5_0_comp.all;
USE XilinxCoreLib.prims_constants_v4_0.all;
USE XilinxCoreLib.C_COUNTER_BINARY_V4_0_comp.all;
USE XilinxCoreLib.vfft32_comps_v3.all;

ENTITY result_memory_v3 IS
	GENERIC (result_width : INTEGER;
		points_power : INTEGER:= 5;
		data_memory : STRING :="distributed_mem";
		memory_architecture : INTEGER);
	PORT (clk : IN STD_LOGIC;
		ce : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		mrd	: IN STD_LOGIC;
		fwd_inv : IN STD_LOGIC;
		y0r: IN STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);	
		y0i: IN STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
		y1r: IN STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
		y1i: IN STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
		y2r: IN STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
		y2i: IN STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
		y3r: IN STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
		y3i: IN STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
		e_result_avail : IN STD_LOGIC; --from bfly_fft4 processor
		e_result_ready : IN STD_LOGIC; --from bfly_buf_fft
		reset_io : IN STD_LOGIC;
		eio_out : IN STD_LOGIC;
		result_ready : OUT STD_LOGIC;
		xk_result_re: OUT STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
		xk_result_im: OUT STD_LOGIC_VECTOR(result_width-1 DOWNTO 0)
);
END result_memory_v3;

ARCHITECTURE behavioral OF result_memory_v3 IS

CONSTANT default_data : STRING(result_width DOWNTO 1):=(OTHERS => '0');
CONSTANT one_string : STRING (2 DOWNTO 1) := "01";
CONSTANT three	: STRING(2 DOWNTO 1) := "11";
CONSTANT ainit_val	: STRING(2 DOWNTO 1) := "00";
CONSTANT sinit_val	: STRING(2 DOWNTO 1) := "00";

CONSTANT one_string_1 : STRING (points_power DOWNTO 1) := "00001";
CONSTANT thirty_one : STRING (points_power DOWNTO 1) := "11111";
CONSTANT ainit_val_1 : STRING (points_power DOWNTO 1) := "00000";
CONSTANT sinit_val_1 : STRING (points_power DOWNTO 1) := "00000";

SIGNAL dr_mem : STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL di_mem : STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL d_select : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL result_read_addr : STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);
SIGNAL result_wr_addr : STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);
SIGNAL result_wr_addr_scrambled : STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);
SIGNAL result_wr_addr_scrambled_delayed :STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);
--SIGNAL result_rd_addr_scrambled : STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);

SIGNAL read_enable : STD_LOGIC;
SIGNAL disable_read_enable : STD_LOGIC;

SIGNAL logic_1 : STD_LOGIC := '1';
SIGNAL one_1: STD_LOGIC_VECTOR(points_power-1 DOWNTO 0) := "00001";
SIGNAL zero_1: STD_LOGIC_VECTOR(points_power-1 DOWNTO 0) := "00000";
SIGNAL zero : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
SIGNAL one : STD_LOGIC_VECTOR(1 DOWNTO 0) := "01";

SIGNAL open_qr : STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL open_qi : STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL dummy_in	: STD_LOGIC:= '0';
SIGNAL dummy_mux_input	: STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL dummy_mux_inputs_1	: STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL open_thresh0_2 : STD_LOGIC; --for xcc	:= '0';
SIGNAL open_q_thresh0_2 : STD_LOGIC; --for xcc	:= '0';
SIGNAL open_thresh1_2 : STD_LOGIC; --for xcc	:= '0';
SIGNAL open_q_thresh1_2 : STD_LOGIC; --for xcc	:= '0';


SIGNAL unused_addra : STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);
SIGNAL unused_dib : STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL unused_dib_i : STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL open_doa_r :STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL open_doa_i :STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL open_thresh0 : STD_LOGIC; --for xcc	:= '0';
SIGNAL open_q_thresh0 : STD_LOGIC; --for xcc	:= '0';
SIGNAL open_thresh1 : STD_LOGIC; --for xcc	:= '0';
SIGNAL open_q_thresh1 : STD_LOGIC; --for xcc	:= '0';


SIGNAL open_thresh0_3 : STD_LOGIC; --for xcc	:= '0';
SIGNAL open_thresh1_3 : STD_LOGIC; --for xcc	:= '0';
SIGNAL open_q_thresh1_3 : STD_LOGIC; --for xcc	:= '0';
SIGNAL rd_addr_unscrambled	: STD_LOGIC_VECTOR(points_power-1 DOWNTO 0);

SIGNAL y2r_delayed	: STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL y2i_delayed	: STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL y3r_delayed	: STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL y3i_delayed	: STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);

SIGNAL dummy_addr : STD_LOGIC_VECTOR(0 DOWNTO 0) := (OTHERS => '0');

SIGNAL dummy_spra	: STD_LOGIC_VECTOR(POINTS_POWER-1 DOWNTO 0);
SIGNAL open_spo_re	: STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL open_qspo_re	: STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL open_dpo_re	: STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL open_spo_im	: STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL open_qspo_im	: STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL open_dpo_im	: STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);

SIGNAL dr_mem_int		: STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL di_mem_int		: STD_LOGIC_VECTOR(result_width-1 DOWNTO 0);
SIGNAL result_ready_int	: STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL e_result_ready_temp : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL mrd_or_reset_io : STD_LOGIC;
sIGNAL we_dms : sTD_LOGIC;
SIGNAL eio_out_reg : STD_LOGIC;

SIGNAL disable_read_enable_and_not_mrd : STD_lOGIC;


SIGNAL open_rdya : STD_LOGIC := '0';
SIGNAL open_rdyb : STD_LOGIC := '0';
SIGNAL open_rfda : STD_LOGIC := '0';
SIGNAL open_rfdb : STD_LOGIC := '0';

SIGNAL open_rdya_i : STD_LOGIC := '0';
SIGNAL open_rdyb_i : STD_LOGIC := '0';
SIGNAL open_rfda_i : STD_LOGIC := '0';
SIGNAL open_rfdb_i : STD_LOGIC := '0';


BEGIN

logic_1 <= '1';
dummy_in <= '0';
zero <= (OTHERS => '0');
zero_1 <= (OTHERS => '0');
one(0) <= '1';
one(1) <= '0';

one_1(0) <= '1';
one_1(1) <= '0';
one_1(2) <= '0';
one_1(3) <= '0';
one_1(4) <= '0';

dummy_addr <= (OTHERS => '0');
result_ready <= result_ready_int(0);
e_result_ready_temp(0) <= e_result_ready;

delay_y2r_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH =>2,
					DATA_WIDTH => result_width)
				PORT MAP (addr => dummy_addr,
					data =>y2r,
					clk => clk,
					reset => reset,
					start => dummy_in,
					delayed_data => y2r_delayed);
delay_y2i_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH =>2,
					DATA_WIDTH => result_width)
				PORT MAP (addr => dummy_addr,
					data =>y2i,
					clk => clk,
					reset => reset,
					start => dummy_in,
					delayed_data => y2i_delayed);

delay_y3r_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH =>2,
					DATA_WIDTH => result_width)
				PORT MAP (addr => dummy_addr,
					data =>y3r,
					clk => clk,
					reset => reset,
					start => dummy_in,
					delayed_data => y3r_delayed);
delay_y3i_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH =>2,
					DATA_WIDTH => result_width)
				PORT MAP (addr => dummy_addr,
					data =>y3i,
					clk => clk,
					reset => reset,
					start => dummy_in,
					delayed_data => y3i_delayed);

mux_y0_y3r :  c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH => result_width,
					C_INPUTS => 4,
					C_SEL_WIDTH => 2,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP ( MA  	=> y0r,
					MB 	=> y1r,
					MC 	=> y2r_delayed,
					MD 	=> y3r_delayed,
					ME 	=> dummy_mux_input,
					MF 	=> dummy_mux_input,
					MG 	=> dummy_mux_input,
					MH 	=> dummy_mux_input,
					MAA 	=> dummy_mux_inputs_1,
					MAB 	=> dummy_mux_inputs_1,
					MAC 	=> dummy_mux_inputs_1,
					MAD 	=> dummy_mux_inputs_1,
					MAE 	=> dummy_mux_inputs_1,
					MAF 	=> dummy_mux_inputs_1,
					MAG 	=> dummy_mux_inputs_1,
					MAH 	=> dummy_mux_inputs_1,
					MBA 	=> dummy_mux_inputs_1,
					MBB 	=> dummy_mux_inputs_1,
					MBC 	=> dummy_mux_inputs_1,
					MBD 	=> dummy_mux_inputs_1,
					MBE 	=> dummy_mux_inputs_1,
					MBF 	=> dummy_mux_inputs_1,
					MBG 	=> dummy_mux_inputs_1,
					MBH 	=> dummy_mux_inputs_1,
					MCA 	=> dummy_mux_inputs_1,
					MCB 	=> dummy_mux_inputs_1,
					MCC 	=> dummy_mux_inputs_1,
					MCD 	=> dummy_mux_inputs_1,
					MCE 	=> dummy_mux_inputs_1,
					MCF 	=> dummy_mux_inputs_1,
					MCG 	=> dummy_mux_inputs_1,
					MCH 	=> dummy_mux_inputs_1,
					S 	=> d_select,
		  			CLK 	=>dummy_in, 
		  			--CE 	=>dummy_in,  
		  			--EN 	=>dummy_in,  
		  			--ASET 	=>dummy_in, 
		  			--ACLR 	=>dummy_in, 
		  			--AINIT 	=>dummy_in, 
		  			--SSET	=>dummy_in, 
		  			--SCLR 	=>dummy_in, 
		  			--SINIT	=>dummy_in,	
					O => dr_mem_int,
					Q => open_qr);
mux_y0_y3i :  c_mux_bus_v4_0
			GENERIC MAP(C_WIDTH => result_width,
					C_INPUTS => 4,
					C_SEL_WIDTH => 2,
					C_HAS_O => 1,
					C_HAS_Q => 0,
					C_HAS_CE => 0,
					C_HAS_EN => 0)
			PORT MAP ( MA  	=> y0i,
					MB 	=> y1i,
					MC 	=> y2i_delayed,
					MD 	=> y3i_delayed,
					ME 	=> dummy_mux_input,
					MF 	=> dummy_mux_input,
					MG 	=> dummy_mux_input,
					MH 	=> dummy_mux_input,
					MAA 	=> dummy_mux_inputs_1,
					MAB 	=> dummy_mux_inputs_1,
					MAC 	=> dummy_mux_inputs_1,
					MAD 	=> dummy_mux_inputs_1,
					MAE 	=> dummy_mux_inputs_1,
					MAF 	=> dummy_mux_inputs_1,
					MAG 	=> dummy_mux_inputs_1,
					MAH 	=> dummy_mux_inputs_1,
					MBA 	=> dummy_mux_inputs_1,
					MBB 	=> dummy_mux_inputs_1,
					MBC 	=> dummy_mux_inputs_1,
					MBD 	=> dummy_mux_inputs_1,
					MBE 	=> dummy_mux_inputs_1,
					MBF 	=> dummy_mux_inputs_1,
					MBG 	=> dummy_mux_inputs_1,
					MBH 	=> dummy_mux_inputs_1,
					MCA 	=> dummy_mux_inputs_1,
					MCB 	=> dummy_mux_inputs_1,
					MCC 	=> dummy_mux_inputs_1,
					MCD 	=> dummy_mux_inputs_1,
					MCE 	=> dummy_mux_inputs_1,
					MCF 	=> dummy_mux_inputs_1,
					MCG 	=> dummy_mux_inputs_1,
					MCH 	=> dummy_mux_inputs_1,
					S 	=> d_select,
		  			CLK 	=>dummy_in, 
		  			--CE 	=>dummy_in,  
		  			--EN 	=>dummy_in,  
		  			--ASET 	=>dummy_in, 
		  			--ACLR 	=>dummy_in, 
		  			--AINIT 	=>dummy_in, 
		  			--SSET	=>dummy_in, 
		  			--SCLR 	=>dummy_in, 
		  			--SINIT	=>dummy_in,	
					O => di_mem_int,
					Q => open_qi);


--insert conj_reg here

conj_res_mem_inputs: conj_reg_v3 GENERIC MAP (B => result_width)
				PORT MAP (clk => clk,
						ce => ce,
						fwd_inv => fwd_inv,
						dr => dr_mem_int,
						di => di_mem_int,
						qr => dr_mem,
						qi => di_mem);

d_select_gen: C_COUNTER_BINARY_V4_0
		GENERIC MAP (	C_WIDTH		=> 2,
				C_OUT_TYPE	=> 1,
				C_COUNT_BY	=> one_string,
				--C_COUNT_TO	=> two,
				C_THRESH0_VALUE => three,
				C_AINIT_VAL	=> ainit_val,
				C_SINIT_VAL	=> sinit_val,
				C_LOAD_ENABLE 	=> c_no_override,
				C_SYNC_ENABLE	=>  c_no_override,
				C_HAS_THRESH0	=>  0, 
				C_HAS_Q_THRESH0	=>  0,
				C_HAS_CE	=> 1,
				C_HAS_IV	=> 1,
				C_HAS_SCLR	=> 0,
				C_HAS_SINIT 	=> 1,
				C_HAS_AINIT 	=> 1)
		PORT MAP (CLK => clk,
			  UP => logic_1,
			  CE => ce,
			  LOAD => dummy_in,
			  L => zero,
			  IV => one,
			  ACLR => dummy_in,
			  ASET => dummy_in,
			  AINIT => reset,
			 -- SCLR => dummy_in,
			  SINIT => e_result_avail, 
			 -- SSET => dummy_in,
			  --THRESH0 => open_thresh0, 
			 -- Q_THRESH0 => open_q_thresh0,   
		  	  --THRESH1 => open_thresh1,  
		  	 -- Q_THRESH1 => open_q_thresh1,
			  Q => d_select);

result_ready_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH =>2,
					DATA_WIDTH => 1)
				PORT MAP (addr => dummy_addr,
					data =>e_result_ready_temp,
					clk => clk,
					reset => reset,
					start => dummy_in,
					delayed_data => result_ready_int);


bmem: IF (data_memory = "block_mem") GENERATE
result_mem_r : blkmemdp_v4_0
			GENERIC MAP(c_addra_width=> points_power,
				c_addrb_width => points_power,
            			--C_CLKA_POLARITY   => 1,
            			--C_CLKB_POLARITY   => 1,
            			C_DEFAULT_DATA    => default_data, 
				C_DEPTH_A => 32,
				C_DEPTH_B => 32,
            			--C_ENA_POLARITY    => 1,
           			--C_ENB_POLARITY    => 1,
            			--C_GENERATE_MIF    => 0,
            			c_has_dina         => 1,
            			c_has_dinb         => 1,
            			c_has_douta         => 0,
            			c_has_doutb         => 1,
            			C_HAS_ENA         => 1,
             			C_HAS_ENB         => 1,
            			c_has_sinita        => 1,
            			c_has_sinitb        => 1,
           		 	C_HAS_WEA         => 1,
            			C_HAS_WEB         => 1,
            			C_MEM_INIT_FILE   => "null.mif",
            			--C_MEM_INIT_RADIX  => 2,
            			c_pipe_stages_a     => 0,
            			c_pipe_stages_b     => 0,
            			--C_READ_MIF        => 0,
            			--C_RSTA_POLARITY   => 1,
            			--C_RSTB_POLARITY   => 1,
            			--C_WEA_POLARITY    => 1,
            			--C_WEB_POLARITY    => 1,
				C_WIDTH_A => result_width,
				C_WIDTH_B => result_width)
			PORT MAP (addra => result_wr_addr_scrambled_delayed,  
				addrb => rd_addr_unscrambled, 
				dina => dr_mem, --unused_dia,
				dinb => unused_dib, --dr_mem, 
				clka => clk,
				clkb => clk,
				wea => we_dms, --result_ready_int(0), --logic_1, 
				web => dummy_in, 
				ena => logic_1, --dummy_in, 
				enb => read_enable, --logic_1,
				sinita => reset,
				sinitb => reset,
				douta => open_doa_r,
				doutb => xk_result_re,
				rdya => open_rdya,
				rdyb => open_rdyb,
				rfda => open_rfda,
				rfdb => open_rfdb);

result_mem_i : blkmemdp_v4_0
			GENERIC MAP(c_addra_width=> points_power,
				c_addrb_width => points_power,
            			--C_CLKA_POLARITY   => 1,
            			--C_CLKB_POLARITY   => 1,
            			C_DEFAULT_DATA    => default_data, 
				C_DEPTH_A => 32,
				C_DEPTH_B => 32,
            			--C_ENA_POLARITY    => 1,
           			--C_ENB_POLARITY    => 1,
            			--C_GENERATE_MIF    => 0,
            			c_has_dina         => 1,
            			c_has_dinb         => 1,
            			c_has_douta         => 0,
            			c_has_doutb         => 1,
            			C_HAS_ENA         => 1,
             			C_HAS_ENB         => 1,
            			c_has_sinita        => 1,
            			c_has_sinitb        => 1,
           		 	C_HAS_WEA         => 1,
            			C_HAS_WEB         => 1,
            			C_MEM_INIT_FILE   => "null.mif",
            			--C_MEM_INIT_RADIX  => 2,
            			c_pipe_stages_a     => 0,
            			c_pipe_stages_b     => 0,
            			--C_READ_MIF        => 0,
            			--C_RSTA_POLARITY   => 1,
            			--C_RSTB_POLARITY   => 1,
            			--C_WEA_POLARITY    => 1,
            			--C_WEB_POLARITY    => 1,
				C_WIDTH_A => result_width,
				C_WIDTH_B => result_width)
			PORT MAP (addra => result_wr_addr_scrambled_delayed,  
				addrb => rd_addr_unscrambled, 
				dina => di_mem, 
				dinb => unused_dib_i, --dr_mem, 
				clka => clk,
				clkb => clk,
				wea => we_dms, --result_ready_int(0), --logic_1, 
				web => dummy_in, 
				ena => logic_1, --dummy_in, 
				enb => read_enable, --logic_1,
				sinita => reset,
				sinitb => reset,
				douta => open_doa_i,
				doutb => xk_result_im,
				rdya => open_rdya_i,
				rdyb => open_rdyb_i,
				rfda => open_rfda_i,
				rfdb => open_rfdb_i);



END GENERATE bmem;
--
--
dmem : IF (data_memory = "distributed_mem") GENERATE

result_mem_r:  C_DIST_MEM_V5_0
	GENERIC MAP (
            C_ADDR_WIDTH     => POINTS_POWER,
           -- C_DEFAULT_DATA   : string  := "0";
	   -- C_DEFAULT_DATA_RADIX : integer := 1;
            C_DEPTH  => 32,
            C_HAS_CLK => 1,
            C_HAS_D=> 1,
            C_HAS_DPO => 0,
            C_HAS_DPRA=> 1,
            C_HAS_I_CE=> 0,
            C_HAS_QDPO => 1, --0,
            C_HAS_QDPO_CE => 1,
            C_HAS_QDPO_CLK => 1,
            C_HAS_QDPO_RST => 0,    -- RSTA
	    C_HAS_QDPO_SRST => 0,
            C_HAS_QSPO  => 0,
            C_HAS_QSPO_CE => 0,
            C_HAS_QSPO_RST => 0,    --RSTB
            C_HAS_QSPO_SRST=> 0,
            C_HAS_RD_EN => 0,
            C_HAS_SPO => 0,
            C_HAS_SPRA => 0,
            C_HAS_WE => 1,
            C_MEM_TYPE => c_dp_ram,
            C_MUX_TYPE =>  c_lut_based,
 	    C_LATENCY => 0,
           -- C_PIPE_STAGES => 1,
            C_READ_MIF       => 0,
            C_REG_A_D_INPUTS => 0,
            C_REG_DPRA_INPUT => 0,
	    C_SYNC_ENABLE => 0,
            C_WIDTH => result_width)
  PORT MAP (A  => result_wr_addr_scrambled_delayed, --result_wr_addr_scrambled,
        D => dr_mem,
        DPRA => rd_addr_unscrambled,
        SPRA => dummy_spra,
        CLK  => clk,
        WE => we_dms, --result_ready_int(0),
        DPO => open_dpo_re,
        SPO  => open_spo_re,
	  QSPO => open_qspo_re,
        QDPO_CE  => read_enable,
        QDPO_CLK => clk,
	  QDPO => xk_result_re
);


result_mem_i:  C_DIST_MEM_V5_0
	GENERIC MAP (
            C_ADDR_WIDTH     => POINTS_POWER,
           -- C_DEFAULT_DATA   : string  := "0";
	   -- C_DEFAULT_DATA_RADIX : integer := 1;
            C_DEPTH  => 32,
            C_HAS_CLK => 1,
            C_HAS_D=> 1,
            C_HAS_DPO => 0,
            C_HAS_DPRA=> 1,
            C_HAS_I_CE=> 0,
            C_HAS_QDPO => 1, --0,
            C_HAS_QDPO_CE => 1,
            C_HAS_QDPO_CLK => 1,
            C_HAS_QDPO_RST => 0,    -- RSTA
	    C_HAS_QDPO_SRST => 0,
            C_HAS_QSPO  => 0,
            C_HAS_QSPO_CE => 0,
            C_HAS_QSPO_RST => 0,    --RSTB
            C_HAS_QSPO_SRST=> 0,
            C_HAS_RD_EN => 0,
            C_HAS_SPO => 0,
            C_HAS_SPRA => 0,
            C_HAS_WE => 1,
            C_MEM_TYPE => c_dp_ram,
            C_MUX_TYPE =>  c_lut_based,
	    C_LATENCY => 0,
           -- C_PIPE_STAGES => 1,
            C_READ_MIF       => 0,
            C_REG_A_D_INPUTS => 0,
            C_REG_DPRA_INPUT => 0,
	    C_SYNC_ENABLE => 0,
            C_WIDTH => result_width)
  PORT MAP (A  => result_wr_addr_scrambled_delayed, --result_wr_addr_scrambled,
        D => di_mem,
        DPRA => rd_addr_unscrambled,
        SPRA => dummy_spra,
        CLK  => clk,
        WE => we_dms, --result_ready_int(0),
        DPO => open_dpo_im,
        SPO  => open_spo_im,
	  QSPO => open_qspo_im,
        QDPO_CE  => read_enable,
        QDPO_CLK => clk,
	  QDPO => xk_result_im
);
END GENERATE dmem; 

--
--
result_wr_adgen_scrambled: C_COUNTER_BINARY_V4_0
		GENERIC MAP (	C_WIDTH		=> points_power,
				C_OUT_TYPE	=> 1,  --unsigned
				C_COUNT_BY	=> one_string_1,
				C_THRESH0_VALUE => thirty_one,
				C_AINIT_VAL	=> ainit_val_1,
				C_SINIT_VAL	=> sinit_val_1,
				C_LOAD_ENABLE 	=> c_no_override,
				C_SYNC_ENABLE	=>  c_no_override,
				C_HAS_THRESH0	=>  0, --1,
				C_HAS_Q_THRESH0	=>  0,
				C_HAS_CE	=> 1,
				C_HAS_IV	=> 1,
				C_HAS_L		=> 1,
				C_HAS_SCLR	=> 0,
				C_HAS_SINIT	=> 1,
				C_HAS_AINIT 	=> 1)
		PORT MAP (CLK => clk,
			  UP => logic_1,
			  CE => ce,
			  LOAD => dummy_in,
			  L => zero_1,
			  IV => one_1,
			--  ACLR => dummy_in,
			 -- ASET => dummy_in,
			  AINIT => reset,
			--  SCLR => dummy_in,
			  SINIT => e_result_avail,
			  --SSET => dummy_in,
			--  THRESH0 => open_thresh0_2, 
			 -- Q_THRESH0 => open_q_thresh0_2,   
		  	 -- THRESH1 => open_thresh1_2,  
		  	 -- Q_THRESH1 => open_q_thresh1_2,
			  Q => result_wr_addr);

scramble_wr_addr: FOR addr_bit IN 0 TO points_power-1 GENERATE
			result_wr_addr_scrambled(addr_bit) <= result_wr_addr(points_power-1 -addr_bit);			END GENERATE scramble_wr_addr; 


delay_result_wr_addr_scrambled_gen : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH =>2,
					DATA_WIDTH => points_power)
				PORT MAP (addr => dummy_addr,
					data =>result_wr_addr_scrambled,
					clk => clk,
					reset => reset,
					start => dummy_in,
					delayed_data => result_wr_addr_scrambled_delayed);

dis_en_gen: and_a_notb_32_v3 PORT MAP (a_in => disable_read_enable,
				b_in => mrd,
				and_out => disable_read_enable_and_not_mrd);

read_enable_gen: srflop_v3 PORT MAP (clk => clk,
					ce => ce,
					set => mrd,
					reset => disable_read_enable_and_not_mrd, 
					q => read_enable);

tms_gen: IF (memory_architecture=3) GENERATE

disable_read_enable_gen: C_COUNTER_BINARY_V4_0
		GENERIC MAP (	C_WIDTH		=> points_power,
				C_OUT_TYPE	=> 1,  --unsigned
				C_COUNT_BY	=> one_string_1,
				C_THRESH0_VALUE => thirty_one,
				C_AINIT_VAL	=> ainit_val_1,
				C_SINIT_VAL	=> sinit_val_1,
				C_LOAD_ENABLE 	=> c_no_override,
				C_SYNC_ENABLE	=>  c_override,
				C_HAS_THRESH0	=>  0, --1,
				C_HAS_Q_THRESH0	=>  1,
				C_HAS_CE	=> 1,
				C_HAS_IV	=> 1,
				C_HAS_L		=> 0,
				C_HAS_SCLR	=> 1, --0,
				C_HAS_SINIT	=> 0,
				C_HAS_AINIT 	=> 1)
		PORT MAP (CLK => clk,
			  UP => logic_1,
			  CE => ce,
			  LOAD => dummy_in,
			  L => zero_1,
			  IV => one_1,
			 -- ACLR => dummy_in,
			 -- ASET => dummy_in,
			  AINIT => reset,
			 SCLR => mrd, --mrd, --dummy_in,
			  SINIT => dummy_in, --mrd,
			 -- SSET => dummy_in,
			 -- THRESH0 => open_thresh0_3, 
			  Q_THRESH0 => disable_read_enable,   
		  	 -- THRESH1 => open_thresh1_3,  
		  	--  Q_THRESH1 => open_q_thresh1_3,
			  Q => rd_addr_unscrambled);

we_dms <= result_ready_int(0);

END GENERATE tms_gen;


		
dms_gen: IF (memory_architecture=2) GENERATE

mrd_or_reset_io_gen: or_a_b_32_v3 PORT MAP (a_in => mrd,
		b_in => reset_io,
		or_out => mrd_or_reset_io);

we_dms <= eio_out_reg;

eio_reg: flip_flop_v3 PORT MAP (d => eio_out,
			clk => clk,
			ce => ce,
			reset => reset,
			q => eio_out_reg);

disable_read_enable_gen: C_COUNTER_BINARY_V4_0
		GENERIC MAP (	C_WIDTH		=> points_power,
				C_OUT_TYPE	=> 1,  --unsigned
				C_COUNT_BY	=> one_string_1,
				C_THRESH0_VALUE => thirty_one,
				C_AINIT_VAL	=> ainit_val_1,
				C_SINIT_VAL	=> sinit_val_1,
				C_LOAD_ENABLE 	=> c_no_override,
				C_SYNC_ENABLE	=>  c_override,
				C_HAS_THRESH0	=>  0, --1,
				C_HAS_Q_THRESH0	=>  1,
				C_HAS_CE	=> 1,
				C_HAS_IV	=> 1,
				C_HAS_L		=> 0,
				C_HAS_SCLR	=> 1, --0,
				C_HAS_SINIT	=> 0,
				C_HAS_AINIT 	=> 1)
		PORT MAP (CLK => clk,
			  UP => logic_1,
			  CE => ce,
			  LOAD => dummy_in,
			  L => zero_1,
			  IV => one_1,
			 -- ACLR => dummy_in,
			 -- ASET => dummy_in,
			  AINIT => reset,
			 SCLR => mrd_or_reset_io, --mrd, --dummy_in,
			  SINIT => dummy_in, --mrd,
			 -- SSET => dummy_in,
			 -- THRESH0 => open_thresh0_3, 
			  Q_THRESH0 => disable_read_enable,   
		  	 -- THRESH1 => open_thresh1_3,  
		  	--  Q_THRESH1 => open_q_thresh1_3,
			  Q => rd_addr_unscrambled);


END GENERATE dms_gen;
END behavioral;

------------------------------END result_memory_v3.vhd--------------------------------------------

-----------------vfft32_v1_0----------------------------------------------------------
-----------------------------------------------------------
--Note: behavioral model does not use c_family_int generic.
-----------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.prims_constants_v4_0.all;
USE XilinxCoreLib.vfft32_comps_v3.all;
USE XilinxCoreLib.vfft32_pkg_v3.all;

ENTITY vfft32_v3_0 IS
	GENERIC (butterfly_precision	: INTEGER:=16;
		phase_factor_precision	: INTEGER:=16;
		scaling_schedule_mem1: STRING;
		scaling_schedule_mem2 : STRING;
		memory_architecture : INTEGER := 3;
		data_memory : STRING;
		mult_type:	INTEGER :=1; --0 selects lut mult, 1 selects emb v2 mult
		c_family_int:	INTEGER :=1); --0 selects virtex; 1 selects v2, v2p, spartan--unused
	PORT (clk		: IN STD_LOGIC;
		ce 		: IN STD_LOGIC;
		reset		: IN STD_LOGIC;
		start		: IN STD_LOGIC;
		fwd_inv		: IN STD_LOGIC;
		mrd		: IN STD_LOGIC;
		mwr		: IN STD_LOGIC;
		xn_re		: IN STD_LOGIC_VECTOR(butterfly_precision-1 DOWNTO 0);
		xn_im		: IN STD_LOGIC_VECTOR(butterfly_precision-1 DOWNTO 0);
		ovflo		: OUT STD_LOGIC;
		done		: OUT STD_LOGIC;
		edone		: OUT STD_LOGIC;
		io		: OUT STD_LOGIC;
		eio		: OUT STD_LOGIC;
		busy		: OUT STD_LOGIC;
		xk_re	: OUT STD_LOGIC_VECTOR(butterfly_precision-1 DOWNTO 0); 
		xk_im	: OUT STD_LOGIC_VECTOR(butterfly_precision-1 DOWNTO 0));

END vfft32_v3_0;


ARCHITECTURE behavioral OF vfft32_v3_0 IS


SIGNAL address	: STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL rank_number	: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL user_ld_addr	: STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL usr_loading_addr	: STD_LOGIC;
SIGNAL bfly_res_avail	: STD_LOGIC;
SIGNAL e_bfly_res_avail	: STD_LOGIC;
SIGNAL wea_x		: STD_LOGIC;
SIGNAL wea_y		: STD_LOGIC;
SIGNAL web_x		: STD_LOGIC;
SIGNAL web_y		: STD_LOGIC;
SIGNAL ena_x		: STD_LOGIC;
SIGNAL ena_y		: STD_LOGIC;
SIGNAL wr_addr		: STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL rd_addrb_x	: STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL rd_addrb_y	: STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL xbar_y		: STD_LOGIC;
SIGNAL xk_r		: STD_LOGIC_VECTOR(butterfly_precision-1 DOWNTO 0);
SIGNAL xk_i		: STD_LOGIC_VECTOR(butterfly_precision-1 DOWNTO 0);
SIGNAL to_bfly_re	: STD_LOGIC_VECTOR(butterfly_precision-1 DOWNTO 0);
SIGNAL to_bfly_im	: STD_LOGIC_VECTOR(butterfly_precision-1 DOWNTO 0);
SIGNAL y0r		: STD_LOGIC_VECTOR(butterfly_precision-1 DOWNTO 0);  
SIGNAL y0i		: STD_LOGIC_VECTOR(butterfly_precision-1 DOWNTO 0);  
SIGNAL y1r		: STD_LOGIC_VECTOR(butterfly_precision-1 DOWNTO 0);  
SIGNAL y1i		: STD_LOGIC_VECTOR(butterfly_precision-1 DOWNTO 0);  
SIGNAL y2r		: STD_LOGIC_VECTOR(butterfly_precision-1 DOWNTO 0);  
SIGNAL y2i		: STD_LOGIC_VECTOR(butterfly_precision-1 DOWNTO 0);  
SIGNAL y3r		: STD_LOGIC_VECTOR(butterfly_precision-1 DOWNTO 0); 
SIGNAL y3i		: STD_LOGIC_VECTOR(butterfly_precision-1 DOWNTO 0);  
SIGNAL wr		: STD_LOGIC_VECTOR(phase_factor_precision-1 DOWNTO 0);
SIGNAL wi		: STD_LOGIC_VECTOR(phase_factor_precision-1 DOWNTO 0);
SIGNAL result_avail	: STD_LOGIC; 
SIGNAL e_result_available	: STD_LOGIC; 
SIGNAL result_available	: STD_LOGIC; 
SIGNAL e_result_ready	: STD_LOGIC; 
SIGNAL result_ready	: STD_LOGIC; 
SIGNAL ce_phase_factors : STD_LOGIC;
SIGNAL e_done_int	: STD_LOGIC;
SIGNAL done_int		: STD_LOGIC;

SIGNAL writing_result	: STD_LOGIC;
SIGNAL reading_result	: STD_LOGIC;

SIGNAL addra_dmem	: STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL addrb_dmem	: STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL data_sel		: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL we_dmem		: STD_LOGIC;
SIGNAL we_dmem_dms:   STD_LOGIC;
SIGNAL d_a_dmem_dms_sel:  STD_LOGIC;
SIGNAL addrb_dmem_dms: STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL addrb_dmem_tms: STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL wex_dmem_tms : STD_LOGIC;
SIGNAL wey_dmem_tms : STD_LOGIC;

SIGNAL dummy_addr : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL done_int_temp : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL edone_int_temp : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL done_tms_dms: STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL done_sms: STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL edone_sms: STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL inv_fft		: STD_LOGIC:= '0';

SIGNAL addra_x_dmem : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL addra_y_dmem : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL initial_data_load_x : STD_LOGIC;
SIGNAL address_select : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL 	ext_to_xbar_y_temp_out		:STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL 	io_pulse : STD_LOGIC;
SIGNAL address_select_dms_out:STD_LOGIC_VECTOR(0 DOWNTO 0); 
SIGNAL reset_io_out : STD_LOGIC;
SIGNAL io_out : STD_LOGIC;
SIGNAL eio_out : STD_LOGIC;
SIGNAL eio_pulse_out : STD_LOGIC;

SIGNAL result_rdy : STD_LOGIC; --not used as a port anymore.
SIGNAL logic_1 : STD_LOGIC := '1';

SIGNAl dmsedone : sTD_logic;
SIGNAL done_in : STD_LOGIC;
signal count: integer:=0;
signal edone_s: std_logic:='0';
signal done_s: std_logic:='0';
signal busy_in: std_logic:='0';
BEGIN

logic_1 <= '1';
donedtgen:if (memory_architecture=2) generate -- or (memory_architecture=3) generate
done <= done_in;
end generate donedtgen;

tmsdgen: if (memory_architecture=3) generate
process (e_done_int, done_in)
begin
-- if clk'event and clk='1' then
  if done_in='1' then done <='1';
  else done <= '0';
  end if;
 if e_done_int='1' then edone <='1';
  else edone <= '0';
  end if;
--end if;
end process;
end generate tmsdgen;

smsdgen: if (memory_architecture=1) generate 
process (start, clk)
begin

if start='1' then
count <= 0;
  elsif clk'event and clk='1' then
   count <= count + 1;
   if count=98 then
    edone_s <='1' after 1 ns;
    else edone_s <='0';
   end if;
   
   if count=130 then
     done_s <='1' after 1 ns;
     else done_s <='0';
   end if;
   
end if;
end process;
edone <= edone_s;
done <= done_s;
end generate;


mem_addr_gen:  mem_address_v3
	GENERIC MAP (points_power => 5,
		memory_configuration => memory_architecture)
	PORT MAP (clk => clk,
		ce => ce,
		reset => reset,
		start => start,
		mwr => mwr,
		io_pulse => io_pulse,
		io => io_out,
		dmsedone => dmsedone,
		address => address,
		rank_number => rank_number,
		user_ld_addr => user_ld_addr,	
		busy_usr_loading_addr => usr_loading_addr,
		initial_data_load_x => initial_data_load_x);

mem_ctrl_gen:  mem_ctrl_v3
	GENERIC MAP (points_power => 5,
		W_WIDTH => phase_factor_precision,
		B => butterfly_precision,
		memory_configuration => memory_architecture,
		data_memory => data_memory)
	PORT MAP (clk => clk,
		ce => ce,
		start => start,
		reset => reset,
		mwr => mwr,
		mrd => mrd,
		usr_loading_addr => usr_loading_addr,
		address => address,
		usr_load_addr => user_ld_addr,
		initial_data_load_x => initial_data_load_x,
		rank_number => rank_number,
		bfly_res_avail => bfly_res_avail,
		e_bfly_res_avail => e_bfly_res_avail,
		done_int => done_int,
		e_done_int => e_done_int,
		result_avail => result_available,
		xbar_y	=> xbar_y,
		ext_to_xbar_y_temp_out=> ext_to_xbar_y_temp_out,
		io	=> io_out,
		io_pulse => io_pulse,
		eio_pulse_out => eio_pulse_out,
		eio	=> eio_out,
		reset_io_out => reset_io_out,
		we_dmem => we_dmem,
		we_dmem_dms => we_dmem_dms,
		wex_dmem_tms => wex_dmem_tms,
		wey_dmem_tms => wey_dmem_tms,
		d_a_dmem_dms_sel => d_a_dmem_dms_sel,
		wea_x => wea_x,
		wea_y => wea_y,
		web_x => web_x,
		web_y => web_y,
		ena_x => ena_x,
		ena_y => ena_y,
		data_sel => data_sel,
		writing_result => writing_result,
		reading_result => reading_result,
		wr_addr => wr_addr,
                address_select => address_select,
                address_select_dms_out => address_select_dms_out,  
		addra_dmem => addra_dmem,
		addra_x_dmem => addra_x_dmem,
		addra_y_dmem => addra_y_dmem,
		addrb_dmem => addrb_dmem,
		addrb_dmem_dms  => addrb_dmem_dms ,
		addrb_dmem_tms => addrb_dmem_tms,
		rd_addrb_x => rd_addrb_x,
		rd_addrb_y => rd_addrb_y);

tms_dms_working_mem_gen: IF ((memory_architecture =3)OR (memory_architecture=2) ) GENERATE 
working_mem_gen: working_memory_v3
	GENERIC MAP (B => butterfly_precision,
		POINTS_POWER => 5,
		memory_architecture => memory_architecture,
		data_memory => data_memory)
	PORT MAP (clk => clk,
		reset => reset,
		start => start,
		xbar_y => xbar_y,
		ext_to_xbar_y_temp_out=> ext_to_xbar_y_temp_out,
		dia_r => xk_r,
		dia_i => xk_i,
		ena_x => ena_x,
		wea_x => wea_x,
		wex_dmem_tms => wex_dmem_tms,
		wey_dmem_tms => wey_dmem_tms,
		addra => wr_addr,
		addra_dmem => addra_dmem,
		addra_x_dmem => addra_x_dmem,
		addra_y_dmem => addra_y_dmem,
		xn_re => xn_re,
		xn_im => xn_im,
		web_x => web_x,
		we_dmem_dms => we_dmem_dms,
		d_a_dmem_dms_sel => d_a_dmem_dms_sel,
		usr_loading_addr => usr_loading_addr,
		addrb_dmem_dms => addrb_dmem_dms,
		addrb_dmem_tms => addrb_dmem_tms,
                address_select => address_select, 
                address_select_dms => address_select_dms_out, 
		ena_y => ena_y,
		wea_y => wea_y,
		web_y => web_y,
		mem_outr => to_bfly_re,
		mem_outi => to_bfly_im);
END GENERATE tms_dms_working_mem_gen;

sms_working_mem_gen: IF (memory_architecture =1) GENERATE
i_w_r_mem:  input_working_result_memory_v3 
	GENERIC MAP (B=> butterfly_precision,
		POINTS_POWER=> 5,
		result_width => butterfly_precision,
		data_memory => data_memory)
	PORT MAP (clk => clk,
		reset => reset,
		ce => ce,
		fwd_inv => fwd_inv,
		dia_r => xk_r,
		dia_i => xk_i,
		xn_re => xn_re,
		xn_im => xn_im,
		ena => ena_x,
		wea => wea_x,
		addra => wr_addr,
		addra_dmem => addra_dmem,
		xn_r => xn_re, 
		xn_i=> xn_im, 
		data_sel => data_sel,
		y0r => y0r,
		y0i => y0i,
		y1r => y1r,
		y1i => y1i,
		y2r => y2r,
		y2i => y2i,
		y3r => y3r,
		y3i => y3i,
		we_dmem => we_dmem,
		web => web_x,
		addrb => rd_addrb_x,
		addrb_dmem => addrb_dmem,
		result_avail => result_available, --result_avail,
		writing_result=> writing_result,
		reading_result => reading_result,
		mem_outr => to_bfly_re, --bfly_input_or_result_re,
		mem_outi => to_bfly_im, --bfly_input_or_result_im,
		xk_result_out_re => xk_re,
		xk_result_out_im => xk_im);

END GENERATE sms_working_mem_gen;

bfly_buf_fft_gen: bfly_buf_fft_v3
	GENERIC MAP (B => butterfly_precision,
		W_WIDTH => phase_factor_precision,
		memory_configuration => memory_architecture,
		mem_init_file => scaling_schedule_mem1,
		mem_init_file_2 => scaling_schedule_mem2,
		mult_type => mult_type)
	PORT MAP (clk => clk,
		ce => ce,
		start => start,
		reset => reset,
		conj => inv_fft,
		fwd_inv => fwd_inv,
		rank_number => rank_number,
		dr => to_bfly_re,
		di => to_bfly_im,
		done => done_in,
		xkr => xk_r,
		xki => xk_i,
		wr => wr,
		wi => wi,
		result_avail => result_available,
		e_result_avail => e_result_available,
		e_result_ready => e_result_ready,
		bfly_res_avail => bfly_res_avail,
		e_bfly_res_avail => e_bfly_res_avail,
		ce_phase_factors => ce_phase_factors,
		ovflo => ovflo,
		y0r => y0r,
		y0i => y0i,
		y1r => y1r,
		y1i => y1i,
		y2r => y2r,
		y2i => y2i,
		y3r => y3r,
		y3i => y3i,
		io_out => io_out,
		edone_s => edone_s,
		busy_in => busy_in);

phase_factor_gen: phase_factors_v3
	GENERIC MAP (W_WIDTH => phase_factor_precision)
	PORT MAP (clk => clk,
		ce => ce_phase_factors, --ce,
		start => start,
		reset => reset,
		fwd_inv => fwd_inv,
		rank_number => rank_number,
		wr => wr,
		wi => wi);

tms_result_mem_gen: IF ((memory_architecture =3) OR (memory_architecture=2)) GENERATE
result_mem_gen: result_memory_v3 
	GENERIC MAP (result_width =>butterfly_precision, 
		points_power => 5,
		data_memory => data_memory,
		memory_architecture => memory_architecture)
	PORT MAP (clk => clk,
		ce => ce,
		mrd => mrd,
		reset => reset,
		fwd_inv => fwd_inv,
		y0r => y0r,
		y0i => y0i,
		y1r => y1r,
		y1i => y1i,
		y2r => y2r,
		y2i => y2i,
		y3r => y3r,
		y3i => y3i,
		e_result_avail => e_result_available,
		e_result_ready => e_result_ready,
		reset_io => reset_io_out,
		eio_out => eio_out,
		result_ready => result_ready,
		xk_result_re => xk_re,
		xk_result_im => xk_im);
END GENERATE tms_result_mem_gen;

hand_shaking_v3_gen: hand_shaking_v3
	GENERIC MAP (memory_architecture => memory_architecture)
	PORT MAP (clk => clk,
		ce => ce, 
		start => start,
		reset => reset,
		result_avail => result_available,
		eio_pulse_out => eio_pulse_out,
		busy => busy_in,
		done=> done_int,
		edone => e_done_int);

result_rdy <= result_ready;

TDBGEN: if (memory_architecture =3) or (memory_architecture =2) GENERATE
 busy <= busy_in;
end GENERATE TDBGEN;


done_int_temp(0) <= done_int;
edone_int_temp(0) <= e_done_int;
tms_done_gen: IF ((memory_architecture =3) ) GENERATE --OR (memory_architecture=2)) GENERATE
  done_delay : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => 1, 
					DATA_WIDTH => 1)
				PORT MAP (addr => dummy_addr,
					data => done_int_temp,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => done_tms_dms);
done_in <= done_tms_dms(0);
--edone <= e_done_int;
END GENERATE tms_done_gen;

dms_done_gen: IF ((memory_architecture =2) ) GENERATE 
  done_delay : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => 1, 
					DATA_WIDTH => 1)
				PORT MAP (addr => dummy_addr,
					data => done_int_temp,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => done_tms_dms);
done_in <= done_tms_dms(0);
edone <= dmsedone; --e_done_int;
END GENERATE dms_done_gen;
edone_done_busy_sms_gen: IF (memory_architecture =1) GENERATE
  done_delay : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => 3, 
					DATA_WIDTH => 1)
				PORT MAP (addr => dummy_addr,
					data => done_int_temp,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => done_sms);
 edone_delay : delay_wrapper_v3 GENERIC MAP (ADDR_WIDTH =>1,
					DEPTH => 3, 
					DATA_WIDTH => 1)
				PORT MAP (addr => dummy_addr,
					data => edone_int_temp,
					clk => clk,
					reset => reset,
					start => start,
					delayed_data => edone_sms);
busy_gen: flip_flop_sclr_v3 PORT MAP (d => logic_1,
				clk => clk,
				ce => start,
				reset => reset,
				sclr => done_sms(0),
				q => busy);
--edone <= edone_sms(0);
done_in <= done_sms(0);

END GENERATE edone_done_busy_sms_gen;
 

io <= io_out;
eio <= eio_out ;
END behavioral;
		
