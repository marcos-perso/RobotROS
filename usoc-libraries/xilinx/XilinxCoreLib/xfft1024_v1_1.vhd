--$RCSfile: xfft1024_v1_1.vhd,v $ $Revision: 1.1 $ $Date: 2010-07-10 21:43:29 $
----------------------------------------------------------------------
-- This file is owned and controlled by Xilinx and must be used     --
-- solely for design, simulation, implementation and creation of    --
-- design files limited to Xilinx devices or technologies. Use      --
-- with non-Xilinx devices or technologies is expressly prohibited  --
-- and immediately terminates your license.                         --
--                                                                  --
-- Xilinx products are not intended for use in life support         --
-- appliances, devices, or systems. Use in such applications are    --
-- expressly prohibited.                                            --
--                                                                  --
-- Copyright (C) 2002, Xilinx, Inc.  All Rights Reserved.           --
----------------------------------------------------------------------
-------------------------------------------------------------------------------
--
-- Description: 
--
-- saturating inverter, returns positive fullscale if D is negative fullscale
-- otherwise  the inverse of the input
--
-------------------------------------------------------------------------------
-- Library Declarations
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library Xilinxcorelib;
use Xilinxcorelib.iputils_STD_LOGIC_ARITH.ALL;
use Xilinxcorelib.iputils_STD_LOGIC_SIGNED.ALL;


library work;

ENTITY inverter IS
   GENERIC ( Bi :  integer := 16);
   PORT (
      gate                    : IN std_logic;   
      D                       : IN std_logic_vector(Bi - 1 DOWNTO 0) := (others => '0');   
      Q                       : OUT std_logic_vector(Bi - 1 DOWNTO 0):= (others => '0'));   
END inverter;

ARCHITECTURE VirtexII OF inverter IS


	SIGNAL fullscale_pos			:  std_logic_vector(Bi-1 DOWNTO 0) := (others => '0');
	SIGNAL fullscale_neg			:  std_logic_vector(Bi-1 DOWNTO 0) := (others => '0');
	SIGNAL inverted					:  std_logic_vector(Bi-1 DOWNTO 0) := (others => '0');   
	SIGNAL gated					:  std_logic_vector(Bi-1 DOWNTO 0) := (others => '0');   

BEGIN
	fullscale_neg(Bi-1) <= D(Bi-1);
	and_gate_net: for i in Bi-2 downto 0 generate
		fullscale_neg(i) <= fullscale_neg(i+1) AND NOT D(i);
		end generate;
	fullscale_pos(Bi-1) <= '0';
	fullscale_pos(Bi-2 downto 0) <= (others => '1');
	
	inverted<= fullscale_pos WHEN (fullscale_neg(0)='1') ELSE (-D);
	gated 	<= inverted WHEN gate = '1' ELSE D;
	Q		<= gated ;

END VirtexII;
-------------------------------------------------------------------------------
--
-- Description: 
--
-- radix2 fft butterfly
-- r denotes the real, i denotes the imaginary part
-- x0, x1 are the inputs, y0, y1 are the corresponding outputs
--
-------------------------------------------------------------------------------
-- Library Declarations
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library Xilinxcorelib;
use Xilinxcorelib.iputils_STD_LOGIC_ARITH.ALL;
use Xilinxcorelib.iputils_STD_LOGIC_SIGNED.ALL;

library work;

ENTITY cmplx_butterfly IS
	GENERIC (WIDTH :  integer := 16);
   PORT (
	x0r, x0i, x1r, x1i      : IN std_logic_vector(WIDTH - 1 DOWNTO 0);   
	y0r, y0i, y1r, y1i      : OUT std_logic_vector(WIDTH DOWNTO 0):= (others => '0'));   
END cmplx_butterfly;

ARCHITECTURE VirtexII OF cmplx_butterfly IS

SIGNAL i0r, i0i, i1r, i1i	:  std_logic_vector(WIDTH DOWNTO 0)  := (others => '0');   

BEGIN
	i0r <= x0r(WIDTH - 1) & x0r(WIDTH - 1 DOWNTO 0) ;
	i0i <= x0i(WIDTH - 1) & x0i(WIDTH - 1 DOWNTO 0) ;
	i1r <= x1r(WIDTH - 1) & x1r(WIDTH - 1 DOWNTO 0) ;
	i1i <= x1i(WIDTH - 1) & x1i(WIDTH - 1 DOWNTO 0) ;
	y0r <= i0r + i1r ;
	y0i <= i0i + i1i ;
	y1r <= i0r - i1r ;
	y1i <= i0i - i1i ;

END VirtexII;-------------------------------------------------------------------------------
--
-- Description: 
--
-- this is a radix4 fft dragonfly
-- r denotes the real, i denotes the imaginary part
-- x0, x1 are the inputs, y0, y1 are the corresponding outputs
--
-------------------------------------------------------------------------------
-- Library Declarations
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library Xilinxcorelib;
use Xilinxcorelib.iputils_STD_LOGIC_ARITH.ALL;
use Xilinxcorelib.iputils_STD_LOGIC_SIGNED.ALL;


library work;

ENTITY dragonfly IS
   GENERIC (WIDTH                          :  integer := 16);
   PORT (
      x0r, x0i, x1r, x1i      : IN std_logic_vector(WIDTH - 1 DOWNTO 0);   
      x2r, x2i, x3r, x3i      : IN std_logic_vector(WIDTH - 1 DOWNTO 0);   
      y0r, y0i, y1r, y1i      : OUT std_logic_vector(WIDTH + 1 DOWNTO 0):= (others => '0');   
      y2r, y2i, y3r, y3i      : OUT std_logic_vector(WIDTH + 1 DOWNTO 0):= (others => '0'));   
END dragonfly;

ARCHITECTURE VirtexII OF dragonfly IS

   COMPONENT cmplx_butterfly
      GENERIC ( WIDTH                          :  integer := 16);
      PORT (
      x0r, x0i, x1r, x1i      : IN std_logic_vector(WIDTH - 1 DOWNTO 0);   
      y0r, y0i, y1r, y1i      : OUT std_logic_vector(WIDTH  DOWNTO 0));   
   END COMPONENT;

   COMPONENT inverter
      GENERIC (
          Bi                             :  integer := 16);
      PORT (
         gate                    : IN  std_logic;
         D                       : IN  std_logic_vector(Bi - 1 DOWNTO 0);
         Q                       : OUT std_logic_vector(Bi - 1 DOWNTO 0));
   END COMPONENT;


   SIGNAL t0r, t0i, t1r, t1i		:  std_logic_vector(WIDTH DOWNTO 0) := (others => '0');   
   SIGNAL t2r, t2i, t3r, t3i		:  std_logic_vector(WIDTH DOWNTO 0) := (others => '0');   
   SIGNAL t3r_inv         			:  std_logic_vector(WIDTH DOWNTO 0) := (others => '0');   
   SIGNAL vcc						:  std_logic := '1';   

BEGIN
	BF_0 : cmplx_butterfly 
		GENERIC MAP (	WIDTH => WIDTH)
		PORT MAP (
			x0r => x0r, x0i => x0i, x1r => x2r, x1i => x2i,
			y0r => t0r, y0i => t0i, y1r => t1r, y1i => t1i);   
   
	BF_1 : cmplx_butterfly
		GENERIC MAP ( WIDTH => WIDTH)
		PORT MAP (
			x0r => x1r, x0i => x1i, x1r => x3r, x1i => x3i,
			y0r => t2r, y0i => t2i, y1r => t3r, y1i => t3i);   
   
	vcc <= '1';
	inv : inverter 
		GENERIC MAP ( Bi => WIDTH + 1)
		PORT MAP ( gate => vcc, D => t3r, Q => t3r_inv);   
   
	BF_2 : cmplx_butterfly
		GENERIC MAP ( WIDTH => WIDTH + 1)
		PORT MAP ( 
			x0r => t0r, x0i => t0i, x1r => t2r, x1i => t2i,
			y0r => y0r, y0i => y0i, y1r => y2r, y1i => y2i);   
   
	BF_3 : cmplx_butterfly
		GENERIC MAP (WIDTH => WIDTH + 1)
		PORT MAP (
			x0r => t1r, x0i => t1i, x1r => t3i, x1i => t3r_inv,
			y0r => y1r, y0i => y1i, y1r => y3r, y1i => y3i);   
   
END VirtexII;
-------------------------------------------------------------------------------
--
-- Description: 
--
-- This module performs a complex multiplication such as
-- yi = ar * bi + ai * br;
-- yr = ar * br - ai * bi;
-- Output width = WIDTH_a + WIDTH_b 
-- (as 1 sign bit falls out @ mults, but 1 extra bit is necessarry because of adds
--
-------------------------------------------------------------------------------
-- Library Declarations
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library Xilinxcorelib;
use Xilinxcorelib.iputils_STD_LOGIC_ARITH.ALL;
use Xilinxcorelib.iputils_STD_LOGIC_SIGNED.ALL;


library work;

ENTITY cmplx_mult IS
	GENERIC (
		WIDTH_a                        :  integer := 18;    
		WIDTH_b                        :  integer := 18);
	PORT (
		ar, ai			: IN std_logic_vector(WIDTH_a - 1 DOWNTO 0);   
		br, bi			: IN std_logic_vector(WIDTH_b - 1 DOWNTO 0);   
		yr, yi			: OUT std_logic_vector(WIDTH_a + WIDTH_b - 1 DOWNTO 0):= (others => '0'));   
END cmplx_mult;

ARCHITECTURE VirtexII OF cmplx_mult IS

	constant MSB_o                          :  integer := WIDTH_a + WIDTH_b - 1;    --  DO NOT MODIFY THIS EXTERNALLY	

	SIGNAL arxbr                    :  std_logic_vector(MSB_o DOWNTO 0) := (others => '0');
	SIGNAL arxbi                    :  std_logic_vector(MSB_o DOWNTO 0) := (others => '0');
	SIGNAL aixbr                    :  std_logic_vector(MSB_o DOWNTO 0) := (others => '0');
	SIGNAL aixbi                    :  std_logic_vector(MSB_o DOWNTO 0) := (others => '0');

BEGIN
	arxbr <= ar * br;   
	arxbi <= ar * bi;   
	aixbr <= ai * br;   
	aixbi <= ai * bi;   	
	yr <= arxbr - aixbi ;
	yi <= arxbi + aixbr ;

END VirtexII;-------------------------------------------------------------------------------
--
-- Description: 
--
-- this module performs an arithmetic right shift on  (sXXXXXXX), such as:
-- e.g. shift=2: 	y = sssXXXXX, 
-- where s denotes the sign of x, X are the mantissa bits of x
-- !!! ADJUST WIDTH OF INPUT <SHIFT> TO YOUR NEEDS !!!
--
-------------------------------------------------------------------------------
-- Library Declarations
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library Xilinxcorelib;
use Xilinxcorelib.iputils_STD_LOGIC_ARITH.ALL;
use Xilinxcorelib.iputils_STD_LOGIC_SIGNED.ALL;

library work;

ENTITY arithmetic_shift IS
   GENERIC (WIDTH :  integer := 16);
   PORT (
      x                       : IN std_logic_vector(WIDTH - 1 DOWNTO 0);   
      shift                   : IN std_logic_vector(1 DOWNTO 0);   
      y                       : OUT std_logic_vector(WIDTH - 1 DOWNTO 0):= (others => '0'));   
END arithmetic_shift;

ARCHITECTURE VirtexII OF arithmetic_shift IS

	SIGNAL temp               :  std_logic_vector(WIDTH-1 DOWNTO 0) := (others => '0');   

BEGIN
   temp <= x(WIDTH - 1) & x(WIDTH - 1) & x(WIDTH - 1 DOWNTO 2) WHEN (shift(1) = '1') ELSE x;
   y <= temp(WIDTH - 1) & temp(WIDTH - 1 DOWNTO 1) WHEN (shift(0) = '1') ELSE temp;

END VirtexII;
-------------------------------------------------------------------------------
--
-- Description: 
--
-- This module rounds a signed I_WIDTH bit integers to O_WIDTH bits without 
-- introducing any bias to the signal flow.
--
-------------------------------------------------------------------------------
-- Library Declarations
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library Xilinxcorelib;
use Xilinxcorelib.iputils_STD_LOGIC_ARITH.ALL;
use Xilinxcorelib.iputils_STD_LOGIC_SIGNED.ALL;


library work;

ENTITY unbias_round IS
	GENERIC (
		I_WIDTH                        :  integer := 8;    --  Number of input bits
		O_WIDTH                        :  integer := 4);    --  Number of output bits
	PORT (
		D                       : IN std_logic_vector(I_WIDTH - 1 DOWNTO 0) := (others => '0');   
		Q                       : OUT std_logic_vector(O_WIDTH - 1 DOWNTO 0):= (others => '0'));   
	END unbias_round;

ARCHITECTURE VirtexII OF unbias_round IS

	--  Number of fractional bits
	constant Nf                     :  integer := I_WIDTH - O_WIDTH;    		
	--  sign of number
	SIGNAL sign                     :  std_logic := '0';   							
	--  integer part of intput
	SIGNAL integer_part             :  std_logic_vector(O_WIDTH - 1 DOWNTO 0)  := (others => '0');   
	--  integer part of intput
	SIGNAL fract_part   			:  std_logic_vector(Nf - 1 DOWNTO 0) := (others => '0');   
	--  first_fractional_bit
	SIGNAL first_fract_bit          :  std_logic := '0';   
	--  fixed point value of integer is n.500
	SIGNAL point_five               :  std_logic_vector(Nf - 1 DOWNTO 0) := (others => '0');   
	--  integer part is odd
	SIGNAL integer_part_odd         :  std_logic :='0';   
	SIGNAL pos_fullscale            :  std_logic_vector(O_WIDTH - 1 DOWNTO 0) := (others => '0');   
	SIGNAL carry                    :  std_logic :='0';   
	SIGNAL fract_part_is_point_five :  std_logic :='0';   
	SIGNAL integer_part_saturated   :  std_logic :='0';   
	
BEGIN
   
	sign <= D(I_WIDTH - 1) ;
	first_fract_bit <= D(Nf - 1) ;
	
	integer_part <= D(I_WIDTH - 1 DOWNTO I_WIDTH - O_WIDTH) ;
	fract_part<= D(Nf - 1 downto 0) ;
	
	point_five(Nf - 1) <= '1'; point_five(Nf - 2 downto 0) <= (others => '0');
	fract_part_is_point_five <= '1' WHEN (fract_part = point_five) else '0';
		
	pos_fullscale(O_WIDTH - 1) <= '0'; pos_fullscale(O_WIDTH - 2 downto 0) <= (others => '1');
	integer_part_saturated <= '1' WHEN (integer_part = pos_fullscale) else '0';
	integer_part_odd <= D(I_WIDTH - O_WIDTH) ;

	carry <= first_fract_bit AND (integer_part_odd OR (NOT fract_part_is_point_five)) AND NOT integer_part_saturated;
	Q <= integer_part + carry;

END VirtexII;
-------------------------------------------------------------------------------
--
-- Description: 
--
-- See description in specs file for the project
-- PE0 module of the fft core
--
-------------------------------------------------------------------------------
-- Library Declarations
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library Xilinxcorelib;
use Xilinxcorelib.iputils_STD_LOGIC_ARITH.ALL;
use Xilinxcorelib.iputils_STD_LOGIC_SIGNED.ALL;


library work;

ENTITY PE0 IS
	GENERIC (
		Bdrfly                         :  integer := 16;    --  wordlength of the dragonfly 
		Btw                            :  integer := 18;    --  Width of twiddle factors 
		Bo                             :  integer := 16);   --  Output width
	PORT (
		DRFLY_I0_RE             : IN std_logic_vector(Bdrfly - 1 DOWNTO 0);   --  <Bdrfly> bit wide port connections
		DRFLY_I0_IM             : IN std_logic_vector(Bdrfly - 1 DOWNTO 0);   --  to the x0 input of the dragonfly
		DRFLY_I1_RE             : IN std_logic_vector(Bdrfly - 1 DOWNTO 0);   --  <Bdrfly> bit wide port connections
		DRFLY_I1_IM             : IN std_logic_vector(Bdrfly - 1 DOWNTO 0);   --  to the x1 input of the dragonfly
		DRFLY_I2_RE             : IN std_logic_vector(Bdrfly - 1 DOWNTO 0);   --  <Bdrfly> bit wide port connections
		DRFLY_I2_IM             : IN std_logic_vector(Bdrfly - 1 DOWNTO 0);   --  to the x2 input of the dragonfly
		DRFLY_I3_RE             : IN std_logic_vector(Bdrfly - 1 DOWNTO 0);   --  <Bdrfly> bit wide port connections
		DRFLY_I3_IM             : IN std_logic_vector(Bdrfly - 1 DOWNTO 0);   --  to the x3 input of the dragonfly
		TW1_RE                  : IN std_logic_vector(Btw - 1 DOWNTO 0);   
		TW1_IM                  : IN std_logic_vector(Btw - 1 DOWNTO 0);   
		TW2_RE                  : IN std_logic_vector(Btw - 1 DOWNTO 0);   
		TW2_IM                  : IN std_logic_vector(Btw - 1 DOWNTO 0);   
		TW3_RE                  : IN std_logic_vector(Btw - 1 DOWNTO 0);   
		TW3_IM                  : IN std_logic_vector(Btw - 1 DOWNTO 0);   
		SCALE                   : IN std_logic_vector(1 DOWNTO 0);   
		OVFLO                   : OUT std_logic := '0';   
		RES_O0_RE               : OUT std_logic_vector(Bo - 1 DOWNTO 0):= (others => '0');   
		RES_O0_IM               : OUT std_logic_vector(Bo - 1 DOWNTO 0):= (others => '0');   
		RES_O1_RE               : OUT std_logic_vector(Bo - 1 DOWNTO 0):= (others => '0');   
		RES_O1_IM               : OUT std_logic_vector(Bo - 1 DOWNTO 0):= (others => '0');   
		RES_O2_RE               : OUT std_logic_vector(Bo - 1 DOWNTO 0):= (others => '0');   
		RES_O2_IM               : OUT std_logic_vector(Bo - 1 DOWNTO 0):= (others => '0');   
		RES_O3_RE               : OUT std_logic_vector(Bo - 1 DOWNTO 0):= (others => '0');   
		RES_O3_IM               : OUT std_logic_vector(Bo - 1 DOWNTO 0):= (others => '0'));   
END PE0;

ARCHITECTURE VirtexII OF PE0 IS

	COMPONENT arithmetic_shift
	GENERIC ( WIDTH :  integer := 16);
	PORT (
		x                       : IN  std_logic_vector(WIDTH - 1 DOWNTO 0);
		shift                   : IN  std_logic_vector(1 DOWNTO 0);
		y                       : OUT std_logic_vector(WIDTH - 1 DOWNTO 0));
	END COMPONENT;

	COMPONENT cmplx_mult
	GENERIC (
		WIDTH_a					:  integer := 18;    
		WIDTH_b 				:  integer := 18);
	PORT (
		ar                      : IN  std_logic_vector(WIDTH_a - 1 DOWNTO 0);
		ai                      : IN  std_logic_vector(WIDTH_a - 1 DOWNTO 0);
		br                      : IN  std_logic_vector(WIDTH_b - 1 DOWNTO 0);
		bi                      : IN  std_logic_vector(WIDTH_b - 1 DOWNTO 0);
		yr                      : OUT std_logic_vector(WIDTH_a + WIDTH_b -1 DOWNTO 0);
		yi                      : OUT std_logic_vector(WIDTH_a + WIDTH_b -1 DOWNTO 0));
	END COMPONENT;

	COMPONENT dragonfly
	GENERIC (WIDTH 				:  integer := 16);
	PORT (
		x0r, x0i, x1r, x1i      : IN std_logic_vector(WIDTH - 1 DOWNTO 0);   
		x2r, x2i, x3r, x3i      : IN std_logic_vector(WIDTH - 1 DOWNTO 0);   
		y0r, y0i, y1r, y1i      : OUT std_logic_vector(WIDTH + 1 DOWNTO 0);   
		y2r, y2i, y3r, y3i      : OUT std_logic_vector(WIDTH + 1 DOWNTO 0));   
	END COMPONENT;

	COMPONENT unbias_round
	GENERIC (
		I_WIDTH   				:  integer := 8;    				--  Number of input bits
		O_WIDTH                 :  integer := 4);				--  Number of output bits
	PORT (
		D                       : IN  std_logic_vector(I_WIDTH - 1 DOWNTO 0);
		Q                       : OUT std_logic_vector(O_WIDTH - 1 DOWNTO 0));
	END COMPONENT;

	CONSTANT  MSB_mltpy          : integer := Bdrfly + Btw + 1;    		--  MSB Position after complex multiplication  (=35)
	CONSTANT  MSB_scale          : integer := Bdrfly + Btw + 4;    		--  MSB Position after scaling 				  (=38)

	SIGNAL drfly_o0_re			: std_logic_vector(Bdrfly + 1 	DOWNTO 0) := (others => '0');--  outputs of the dragonfly
	SIGNAL drfly_o0_im          : std_logic_vector(Bdrfly + 1 	DOWNTO 0) := (others => '0');   
	SIGNAL drfly_o1_re          : std_logic_vector(Bdrfly + 1 	DOWNTO 0) := (others => '0');   
	SIGNAL drfly_o1_im          : std_logic_vector(Bdrfly + 1 	DOWNTO 0) := (others => '0');   
	SIGNAL drfly_o2_re          : std_logic_vector(Bdrfly + 1 	DOWNTO 0) := (others => '0');   
	SIGNAL drfly_o2_im          : std_logic_vector(Bdrfly + 1 	DOWNTO 0) := (others => '0');   
	SIGNAL drfly_o3_re          : std_logic_vector(Bdrfly + 1 	DOWNTO 0) := (others => '0');   
	SIGNAL drfly_o3_im          : std_logic_vector(Bdrfly + 1 	DOWNTO 0) := (others => '0');   
	SIGNAL mlplied1_re          : std_logic_vector(MSB_mltpy  	DOWNTO 0) := (others => '0');  
	SIGNAL mlplied1_im          : std_logic_vector(MSB_mltpy  	DOWNTO 0) := (others => '0'); --  outputs of the multipliers
	SIGNAL mlplied2_re          : std_logic_vector(MSB_mltpy  	DOWNTO 0) := (others => '0');   
	SIGNAL mlplied2_im          : std_logic_vector(MSB_mltpy  	DOWNTO 0) := (others => '0');   
	SIGNAL mlplied3_re          : std_logic_vector(MSB_mltpy  	DOWNTO 0) := (others => '0');   
	SIGNAL mlplied3_im          : std_logic_vector(MSB_mltpy  	DOWNTO 0) := (others => '0');   
	SIGNAL scaled0_re           : std_logic_vector(Bdrfly + 5 	DOWNTO 0) := (others => '0');   
	SIGNAL scaled0_im           : std_logic_vector(Bdrfly + 5 	DOWNTO 0) := (others => '0');   
	SIGNAL scaled1_re           : std_logic_vector(MSB_scale  	DOWNTO 0) := (others => '0');   
	SIGNAL scaled1_im           : std_logic_vector(MSB_scale  	DOWNTO 0) := (others => '0');   
	SIGNAL scaled2_re           : std_logic_vector(MSB_scale	DOWNTO 0) := (others => '0');   
	SIGNAL scaled2_im           : std_logic_vector(MSB_scale	DOWNTO 0) := (others => '0');   
	SIGNAL scaled3_re           : std_logic_vector(MSB_scale	DOWNTO 0) := (others => '0');   
	SIGNAL scaled3_im           : std_logic_vector(MSB_scale	DOWNTO 0) := (others => '0');   
	SIGNAL padded_drfly_o0_re   : std_logic_vector(21 			DOWNTO 0) := (others => '0');   
	SIGNAL padded_drfly_o0_im   : std_logic_vector(21 			DOWNTO 0) := (others => '0');   
	SIGNAL padded_mlplied1_re	: std_logic_vector(38 			DOWNTO 0) := (others => '0');   
	SIGNAL padded_mlplied1_im	: std_logic_vector(38 			DOWNTO 0) := (others => '0');   
	SIGNAL padded_mlplied2_re	: std_logic_vector(38			DOWNTO 0) := (others => '0');   
	SIGNAL padded_mlplied2_im	: std_logic_vector(38		 	DOWNTO 0) := (others => '0');   
	SIGNAL padded_mlplied3_re	: std_logic_vector(38 			DOWNTO 0) := (others => '0');   
	SIGNAL padded_mlplied3_im	: std_logic_vector(38 			DOWNTO 0) := (others => '0');   

	FUNCTION ats3 (x: IN std_logic_vector(2 DOWNTO 0)) RETURN std_logic IS
	VARIABLE ats3	: std_logic;
	BEGIN
		ats3 := (x(0) and x(1) and x(2)) or ( (not x(0)) and (not x(1)) and (not x(2)) );
		RETURN(ats3);
	END ats3;

BEGIN 
   -- Hook up the dragonfly
   DFLY : dragonfly 
      GENERIC MAP (
         WIDTH => Bdrfly)
      PORT MAP (
         x0r => DRFLY_I0_RE, -- connections of the 
         x0i => DRFLY_I0_IM, -- 4 complex inputs and
         x1r => DRFLY_I1_RE,
         x1i => DRFLY_I1_IM,
         x2r => DRFLY_I2_RE,
         x2i => DRFLY_I2_IM,
         x3r => DRFLY_I3_RE,
         x3i => DRFLY_I3_IM,
         y0r => drfly_o0_re, -- 4 complex outputs
         y0i => drfly_o0_im,
         y1r => drfly_o1_re,
         y1i => drfly_o1_im,
         y2r => drfly_o2_re,
         y2i => drfly_o2_im,
         y3r => drfly_o3_re,
         y3i => drfly_o3_im);   
   
   
   -- Hook up the 1st complex multiplier to output1 of the dragonfly   
   Mul1 : cmplx_mult 
      GENERIC MAP (
         WIDTH_a => (Bdrfly + 2),
         WIDTH_b => Btw)
      PORT MAP (
         ar => drfly_o1_re,
         ai => drfly_o1_im,
         br => TW1_RE,
         bi => TW1_IM,
         yr => mlplied1_re,
         yi => mlplied1_im);   --  results
   
   
   -- Hook up the 2nd complex multiplier to output1 of the dragonfly
   Mul2 : cmplx_mult 
      GENERIC MAP (
         WIDTH_a => Bdrfly + 2,
         WIDTH_b => Btw)
      PORT MAP (
         ar => drfly_o2_re,
         ai => drfly_o2_im,
         br => TW2_RE,
         bi => TW2_IM,
         yr => mlplied2_re,
         yi => mlplied2_im);   --  results
   
   
   -- Hook up the 3rd complex multiplier to output1 of the dragonfly
   Mul3 : cmplx_mult 
      GENERIC MAP (
         WIDTH_a => Bdrfly + 2,
         WIDTH_b => Btw)
      PORT MAP (
         ar => drfly_o3_re,
         ai => drfly_o3_im,
         br => TW3_RE,
         bi => TW3_IM,
         yr => mlplied3_re,
         yi => mlplied3_im);   --  results

   -- Hook up the scaler mux in the real datapath of output0 after the corresponding multiplier  
   padded_drfly_o0_re <= drfly_o0_re(Bdrfly + 1 DOWNTO Bdrfly + 1) & drfly_o0_re & "000";
   SHIFT_0re : arithmetic_shift 
      GENERIC MAP (
         WIDTH => Bdrfly + 6)
      PORT MAP (
         x => padded_drfly_o0_re,
         shift => SCALE,
         y => scaled0_re);   
		 
   -- Hook up the scaler mux in the imaginary datapath of output0 after the corresponding multiplier   
   padded_drfly_o0_im <= drfly_o0_im(Bdrfly + 1 DOWNTO Bdrfly + 1) & drfly_o0_im & "000";
   SHIFT_0im : arithmetic_shift 
      GENERIC MAP (
         WIDTH => Bdrfly + 6)
      PORT MAP (
         x => padded_drfly_o0_im,
         shift => SCALE,
         y => scaled0_im);   
   
   -- Hook up the scaler mux in the real datapath of output1 after the corresponding multiplier
   padded_mlplied1_re <= mlplied1_re & "000";
   SHIFT_1re : arithmetic_shift 
      GENERIC MAP (
         WIDTH => MSB_scale + 1)
      PORT MAP (
         x => padded_mlplied1_re,
         shift => SCALE,
         y => scaled1_re);   
   
   -- Hook up the scaler mux in the imaginary datapath of output1 after the corresponding multiplier
   padded_mlplied1_im <= mlplied1_im & "000";
   SHIFT_1im : arithmetic_shift 
      GENERIC MAP (
         WIDTH => MSB_scale + 1)
      PORT MAP (
         x => padded_mlplied1_im,
         shift => SCALE,
         y => scaled1_im);   
   
      -- Hook up the scaler mux in the real datapath of output2 after the corresponding multiplier
	padded_mlplied2_re <= mlplied2_re & "000";
	SHIFT_2re : arithmetic_shift 
      GENERIC MAP (
         WIDTH => MSB_scale + 1)
      PORT MAP (
         x => padded_mlplied2_re,
         shift => SCALE,
         y => scaled2_re);   
   -- Hook up the scaler mux in the imaginary datapath of output2 after the corresponding multiplier   
   padded_mlplied2_im <= mlplied2_im & "000";
   SHIFT_2im : arithmetic_shift 
      GENERIC MAP (
         WIDTH => MSB_scale + 1)
      PORT MAP (
         x => padded_mlplied2_im,
         shift => SCALE,
         y => scaled2_im);   
		 
   -- Hook up the scaler mux in the real datapath of output3 after the corresponding multiplier   
   padded_mlplied3_re <= mlplied3_re & "000";
   SHIFT_3re : arithmetic_shift 
      GENERIC MAP (
         WIDTH => MSB_scale + 1)
      PORT MAP (
         x => padded_mlplied3_re,
         shift => SCALE,
         y => scaled3_re);   
		 
   -- Hook up the scaler mux in the imaginary datapath of output3 after the corresponding multiplier
   padded_mlplied3_im <= mlplied3_im & "000";
   SHIFT_3im : arithmetic_shift 
      GENERIC MAP (
         WIDTH => MSB_scale + 1)
      PORT MAP (
         x => padded_mlplied3_im,
         shift => SCALE,
         y => scaled3_im);   
   
   
   -- Hook up the rounder in the real datapath of output0 after the corresponding scaler
   RND0_re : unbias_round 
      GENERIC MAP (
         I_WIDTH => Bdrfly + 3,
         O_WIDTH => Bo)
      PORT MAP (
         D => scaled0_re(Bdrfly + 2 DOWNTO 0),
         Q => RES_O0_RE);   
   
   
   -- Hook up the rounder in the imaginary datapath of output0 after the scaler
   RND0_im : unbias_round 
      GENERIC MAP (
         I_WIDTH => Bdrfly + 3,
         O_WIDTH => Bo)
      PORT MAP (
         D => scaled0_im(Bdrfly + 2 DOWNTO 0),
         Q => RES_O0_IM);  
   
   -- Hook up the rounder in the real datapath of output1 after the corresponding scaler
   RND1_re : unbias_round 
      GENERIC MAP (
         I_WIDTH => MSB_scale - 2,
         O_WIDTH => Bo)
      PORT MAP (
         D => scaled1_re(MSB_scale - 3 DOWNTO 0),
         Q => RES_O1_RE);   
   
   -- Hook up the rounder in the imaginary datapath of output1 after the scaler
   RND1_im : unbias_round 
      GENERIC MAP (
         I_WIDTH => MSB_scale - 2,
         O_WIDTH => Bo)
      PORT MAP (
         D => scaled1_im(MSB_scale - 3 DOWNTO 0),
         Q => RES_O1_IM);   
   
   -- Hook up the rounder in the real datapath of output2 after the corresponding scaler
   RND2_re : unbias_round 
      GENERIC MAP (
         I_WIDTH => MSB_scale - 2,
         O_WIDTH => Bo)
      PORT MAP (
         D => scaled2_re(MSB_scale - 3 DOWNTO 0),
         Q => RES_O2_RE);   
   
   -- Hook up the rounder in the imaginary datapath of output2 after the scaler
   RND2_im : unbias_round 
      GENERIC MAP (
         I_WIDTH => MSB_scale - 2,
         O_WIDTH => Bo)
      PORT MAP (
         D => scaled2_im(MSB_scale - 3 DOWNTO 0),
         Q => RES_O2_IM);   
   
   -- Hook up the rounder in the real datapath of output3 after the corresponding scaler
   RND3_re : unbias_round 
      GENERIC MAP (
         I_WIDTH => MSB_scale - 2,
         O_WIDTH => Bo)
      PORT MAP (
         D => scaled3_re(MSB_scale - 3 DOWNTO 0),
         Q => RES_O3_RE);   
   
   -- Hook up the rounder in the imaginary datapath of output3 after the scaler
   RND3_im : unbias_round 
      GENERIC MAP (
         I_WIDTH => MSB_scale - 2,
         O_WIDTH => Bo)
      PORT MAP (
         D => scaled3_im(MSB_scale - 3 DOWNTO 0),
         Q => RES_O3_IM);   
   
	OVFLO <= 	NOT ats3(scaled0_re((Bdrfly + 4) DOWNTO (Bdrfly + 2))) OR 
				NOT ats3(scaled0_im((Bdrfly + 4) DOWNTO (Bdrfly + 2))) OR 
				NOT ats3(scaled1_re(MSB_scale DOWNTO MSB_scale - 2)) OR 
				NOT ats3(scaled1_im(MSB_scale DOWNTO MSB_scale - 2)) OR 
				NOT ats3(scaled2_re(MSB_scale DOWNTO MSB_scale - 2)) OR 
				NOT ats3(scaled2_im(MSB_scale DOWNTO MSB_scale - 2)) OR 
				NOT ats3(scaled3_re(MSB_scale DOWNTO MSB_scale - 2)) OR 
				NOT ats3(scaled3_im(MSB_scale DOWNTO MSB_scale - 2)) ;

END VirtexII;
-------------------------------------------------------------------------------
--
-- Description: 
--
-- See description is specs file for the project
-- PE1 module of the fft core
--
-------------------------------------------------------------------------------
-- Library Declarations
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library Xilinxcorelib;
use Xilinxcorelib.iputils_STD_LOGIC_ARITH.ALL;
use Xilinxcorelib.iputils_STD_LOGIC_SIGNED.ALL;


library work;

ENTITY PE1 IS
	GENERIC (
		Bdrfly      			:  integer := 16;     --  wordlength of the dragonfly 
		Bo        				:  integer := 16);    --  Output width
	PORT (
		DRFLY_I0_RE             : IN std_logic_vector(Bdrfly - 1 DOWNTO 0);   --  <Bdrfly> bit wide port connections
		DRFLY_I0_IM             : IN std_logic_vector(Bdrfly - 1 DOWNTO 0);   --  to the x0 input of the dragonfly
		DRFLY_I1_RE             : IN std_logic_vector(Bdrfly - 1 DOWNTO 0);   --  <Bdrfly> bit wide port connections
		DRFLY_I1_IM             : IN std_logic_vector(Bdrfly - 1 DOWNTO 0);   --  to the x1 input of the dragonfly
		DRFLY_I2_RE             : IN std_logic_vector(Bdrfly - 1 DOWNTO 0);   --  <Bdrfly> bit wide port connections
		DRFLY_I2_IM             : IN std_logic_vector(Bdrfly - 1 DOWNTO 0);   --  to the x2 input of the dragonfly
		DRFLY_I3_RE             : IN std_logic_vector(Bdrfly - 1 DOWNTO 0);   --  <Bdrfly> bit wide port connections
		DRFLY_I3_IM             : IN std_logic_vector(Bdrfly - 1 DOWNTO 0);   --  to the x3 input of the dragonfly
		SCALE                   : IN std_logic_vector(1 DOWNTO 0);   
		OVFLO                   : OUT std_logic := '0';   
		RES_O0_RE               : OUT std_logic_vector(Bo - 1 DOWNTO 0):= (others => '0');   
		RES_O0_IM               : OUT std_logic_vector(Bo - 1 DOWNTO 0):= (others => '0');   
		RES_O1_RE               : OUT std_logic_vector(Bo - 1 DOWNTO 0):= (others => '0');   
		RES_O1_IM               : OUT std_logic_vector(Bo - 1 DOWNTO 0):= (others => '0');   
		RES_O2_RE               : OUT std_logic_vector(Bo - 1 DOWNTO 0):= (others => '0');   
		RES_O2_IM               : OUT std_logic_vector(Bo - 1 DOWNTO 0):= (others => '0');   
		RES_O3_RE               : OUT std_logic_vector(Bo - 1 DOWNTO 0):= (others => '0');   
		RES_O3_IM               : OUT std_logic_vector(Bo - 1 DOWNTO 0):= (others => '0'));   
END PE1;

ARCHITECTURE VirtexII OF PE1 IS

	COMPONENT arithmetic_shift
	GENERIC ( WIDTH :  integer := 16);
	PORT (
		x                       : IN  std_logic_vector(WIDTH - 1 DOWNTO 0);
		shift                   : IN  std_logic_vector(1 DOWNTO 0);
		y                       : OUT std_logic_vector(WIDTH - 1 DOWNTO 0));
	END COMPONENT;

	COMPONENT dragonfly
	GENERIC (WIDTH 				:  integer := 16);
	PORT (
		x0r, x0i, x1r, x1i      : IN std_logic_vector(WIDTH - 1 DOWNTO 0);   
		x2r, x2i, x3r, x3i      : IN std_logic_vector(WIDTH - 1 DOWNTO 0);   
		y0r, y0i, y1r, y1i      : OUT std_logic_vector(WIDTH + 1 DOWNTO 0);   
		y2r, y2i, y3r, y3i      : OUT std_logic_vector(WIDTH + 1 DOWNTO 0));   
	END COMPONENT;

	COMPONENT unbias_round
	GENERIC (
		I_WIDTH   				:  integer := 8;    				--  Number of input bits
		O_WIDTH                 :  integer := 4);				--  Number of output bits
	PORT (
		D                       : IN  std_logic_vector(I_WIDTH - 1 DOWNTO 0);
		Q                       : OUT std_logic_vector(O_WIDTH - 1 DOWNTO 0));
	END COMPONENT;

	CONSTANT  MSB_scale			:  integer := Bdrfly + 3;    --  MSB Position after scaling 				  (=38)
	
	SIGNAL drfly_o0_re          :  std_logic_vector(Bdrfly + 1 DOWNTO 0) := (others => '0');   --  outputs of the dragonfly
	SIGNAL drfly_o0_im          :  std_logic_vector(Bdrfly + 1 DOWNTO 0) := (others => '0');   
	SIGNAL drfly_o1_re          :  std_logic_vector(Bdrfly + 1 DOWNTO 0) := (others => '0');   
	SIGNAL drfly_o1_im          :  std_logic_vector(Bdrfly + 1 DOWNTO 0) := (others => '0');   
	SIGNAL drfly_o2_re          :  std_logic_vector(Bdrfly + 1 DOWNTO 0) := (others => '0');   
	SIGNAL drfly_o2_im          :  std_logic_vector(Bdrfly + 1 DOWNTO 0) := (others => '0');   
	SIGNAL drfly_o3_re          :  std_logic_vector(Bdrfly + 1 DOWNTO 0) := (others => '0');   
	SIGNAL drfly_o3_im          :  std_logic_vector(Bdrfly + 1 DOWNTO 0) := (others => '0');   
	SIGNAL scaled0_re           :  std_logic_vector(MSB_scale DOWNTO 0) := (others => '0');   
	SIGNAL scaled0_im           :  std_logic_vector(MSB_scale DOWNTO 0) := (others => '0');   
	SIGNAL scaled1_re           :  std_logic_vector(MSB_scale DOWNTO 0) := (others => '0');   
	SIGNAL scaled1_im           :  std_logic_vector(MSB_scale DOWNTO 0) := (others => '0');   
	SIGNAL scaled2_re           :  std_logic_vector(MSB_scale DOWNTO 0) := (others => '0');   
	SIGNAL scaled2_im           :  std_logic_vector(MSB_scale DOWNTO 0) := (others => '0');   
	SIGNAL scaled3_re           :  std_logic_vector(MSB_scale DOWNTO 0) := (others => '0');   
	SIGNAL scaled3_im           :  std_logic_vector(MSB_scale DOWNTO 0) := (others => '0');   
	SIGNAL padded_drfly_o0_re   :  std_logic_vector(19 DOWNTO 0) := (others => '0');   
	SIGNAL padded_drfly_o0_im   :  std_logic_vector(19 DOWNTO 0) := (others => '0');   
	SIGNAL padded_drfly_o1_re   :  std_logic_vector(19 DOWNTO 0) := (others => '0');   
	SIGNAL padded_drfly_o1_im   :  std_logic_vector(19 DOWNTO 0) := (others => '0');   
	SIGNAL padded_drfly_o2_re   :  std_logic_vector(19 DOWNTO 0) := (others => '0');   
	SIGNAL padded_drfly_o2_im   :  std_logic_vector(19 DOWNTO 0) := (others => '0');   
	SIGNAL padded_drfly_o3_re   :  std_logic_vector(19 DOWNTO 0) := (others => '0');   
	SIGNAL padded_drfly_o3_im   :  std_logic_vector(19 DOWNTO 0) := (others => '0');   

	FUNCTION ats3 (x: IN std_logic_vector(2 DOWNTO 0)) RETURN std_logic IS
	VARIABLE ats3	: std_logic;
	BEGIN
--		if ((x = "111") OR (x = "000")) then ats3 := '1';
--			else ats3 := '0';
--			end if;		  
		ats3 := (x(0) and x(1) and x(2)) or ( (not x(0)) and (not x(1)) and (not x(2)) );
		RETURN(ats3);
	END ats3;

BEGIN
   
   -- Hook up the dragonfly

   DFLY : dragonfly 
      GENERIC MAP (
         WIDTH => Bdrfly)
      PORT MAP (
         x0r => DRFLY_I0_RE,   -- connections of the 
         x0i => DRFLY_I0_IM,   -- 4 complex inputs and
         x1r => DRFLY_I1_RE,
         x1i => DRFLY_I1_IM,
         x2r => DRFLY_I2_RE,
         x2i => DRFLY_I2_IM,
         x3r => DRFLY_I3_RE,
         x3i => DRFLY_I3_IM,
         y0r => drfly_o0_re,   -- 4 complex outputs
         y0i => drfly_o0_im,
         y1r => drfly_o1_re,
         y1i => drfly_o1_im,
         y2r => drfly_o2_re,
         y2i => drfly_o2_im,
         y3r => drfly_o3_re,
         y3i => drfly_o3_im);   

	-- Hook up the scaler mux in the real datapath of output0 		 
	padded_drfly_o0_re <= drfly_o0_re & "00";
	SHIFT_0re : arithmetic_shift 
	GENERIC MAP ( WIDTH => Bdrfly + 4)
	PORT MAP (
		x => padded_drfly_o0_re,
		shift => SCALE,
		y => scaled0_re);   
	
	-- Hook up the scaler mux in the imaginary datapath of output0 
	padded_drfly_o0_im <= drfly_o0_im & "00";
	SHIFT_0im : arithmetic_shift 
	GENERIC MAP ( WIDTH => Bdrfly + 4)
	PORT MAP (
		x => padded_drfly_o0_im,
		shift => SCALE,
		y => scaled0_im);   
	
	-- Hook up the scaler mux in the real datapath of output1 		 
	padded_drfly_o1_re <= drfly_o1_re & "00";
	SHIFT_1re : arithmetic_shift 
	GENERIC MAP ( WIDTH => Bdrfly + 4)
	PORT MAP (
		x => padded_drfly_o1_re,
		shift => SCALE,
		y => scaled1_re);   
	
	-- Hook up the scaler mux in the imaginary datapath of output1 
	padded_drfly_o1_im <= drfly_o1_im & "00";
	SHIFT_1im : arithmetic_shift 
	GENERIC MAP ( WIDTH => Bdrfly + 4)
	PORT MAP (
		x => padded_drfly_o1_im,
		shift => SCALE,
		y => scaled1_im);   
	
	-- Hook up the scaler mux in the real datapath of output2 		 
	padded_drfly_o2_re <= drfly_o2_re & "00";
	SHIFT_2re : arithmetic_shift 
	GENERIC MAP ( WIDTH => Bdrfly + 4)
	PORT MAP (
		x => padded_drfly_o2_re,
		shift => SCALE,
		y => scaled2_re);   
	
	-- Hook up the scaler mux in the imaginary datapath of output2 
	padded_drfly_o2_im <= drfly_o2_im & "00";
	SHIFT_2im : arithmetic_shift 
	GENERIC MAP ( WIDTH => Bdrfly + 4)
	PORT MAP (
		x => padded_drfly_o2_im,
		shift => SCALE,
		y => scaled2_im);   
	
	-- Hook up the scaler mux in the real datapath of output3 		 
	padded_drfly_o3_re <= drfly_o3_re & "00";
	SHIFT_3re : arithmetic_shift 
	GENERIC MAP ( WIDTH => Bdrfly + 4)
	PORT MAP (
		x => padded_drfly_o3_re,
		shift => SCALE,
		y => scaled3_re);   
	
	-- Hook up the scaler mux in the imaginary datapath of output3 
	padded_drfly_o3_im <= drfly_o3_im & "00";
	SHIFT_3im : arithmetic_shift 
	GENERIC MAP ( WIDTH => Bdrfly + 4)
	PORT MAP (
		x => padded_drfly_o3_im,
		shift => SCALE,
		y => scaled3_im);   
	
	-- Hook up the rounder in the real datapath of output0 after the corresponding scaler
	RND0_re : unbias_round 
	GENERIC MAP (
		I_WIDTH => Bdrfly + 2,
		O_WIDTH => Bo)
	PORT MAP (
		D => scaled0_re(Bdrfly + 1 DOWNTO 0),
		Q => RES_O0_RE);   
	
	-- Hook up the rounder in the imaginary datapath of output0 after the scaler
	RND0_im : unbias_round 
	GENERIC MAP (
		I_WIDTH => Bdrfly + 2,
		O_WIDTH => Bo)
	PORT MAP (
		D => scaled0_im(Bdrfly + 1 DOWNTO 0),
		Q => RES_O0_IM);   
	
	-- Hook up the rounder in the real datapath of output1 after the corresponding scaler
	RND1_re : unbias_round 
	GENERIC MAP (
		I_WIDTH => Bdrfly + 2,
		O_WIDTH => Bo)
	PORT MAP (
		D => scaled1_re(Bdrfly + 1 DOWNTO 0),
		Q => RES_O1_RE);   
	
	-- Hook up the rounder in the imaginary datapath of output1 after the scaler
	RND1_im : unbias_round 
	GENERIC MAP (
		I_WIDTH => Bdrfly + 2,
		O_WIDTH => Bo)
	PORT MAP (
		D => scaled1_im(Bdrfly + 1 DOWNTO 0),
		Q => RES_O1_IM);   
	
	-- Hook up the rounder in the real datapath of output2 after the corresponding scaler
	RND2_re : unbias_round 
	GENERIC MAP (
		I_WIDTH => Bdrfly + 2,
		O_WIDTH => Bo)
	PORT MAP (
		D => scaled2_re(Bdrfly + 1 DOWNTO 0),
		Q => RES_O2_RE);   

	-- Hook up the rounder in the imaginary datapath of output2 after the scaler
	RND2_im : unbias_round 
	GENERIC MAP (
		I_WIDTH => Bdrfly + 2,
		O_WIDTH => Bo)
	PORT MAP (
		D => scaled2_im(Bdrfly + 1 DOWNTO 0),
		Q => RES_O2_IM);   
	
	-- Hook up the rounder in the real datapath of output3 after the corresponding scaler
	RND3_re : unbias_round 
	GENERIC MAP (
		I_WIDTH => Bdrfly + 2,
		O_WIDTH => Bo)
	PORT MAP (
		D => scaled3_re(Bdrfly + 1 DOWNTO 0),
		Q => RES_O3_RE);   
	
	-- Hook up the rounder in the imaginary datapath of output3 after the scaler
	RND3_im : unbias_round 
	GENERIC MAP (
		I_WIDTH => Bdrfly + 2,
		O_WIDTH => Bo)
	PORT MAP (
		D => scaled3_im(Bdrfly + 1 DOWNTO 0),
		Q => RES_O3_IM);   
   
   OVFLO <= NOT ats3(scaled0_re(MSB_scale DOWNTO MSB_scale - 2)) OR 
		  	NOT ats3(scaled0_im(MSB_scale DOWNTO MSB_scale - 2)) OR 
			NOT ats3(scaled1_re(MSB_scale DOWNTO MSB_scale - 2)) OR 
			NOT ats3(scaled1_im(MSB_scale DOWNTO MSB_scale - 2)) OR 
			NOT ats3(scaled2_re(MSB_scale DOWNTO MSB_scale - 2)) OR 
			NOT ats3(scaled2_im(MSB_scale DOWNTO MSB_scale - 2)) OR 
			NOT ats3(scaled3_re(MSB_scale DOWNTO MSB_scale - 2)) OR 
			NOT ats3(scaled3_im(MSB_scale DOWNTO MSB_scale - 2)) ;

END VirtexII;
-------------------------------------------------------------------------------
--
-- xfft1024_v1_1 / TOP LEVEL VHDL Behavioral Model
--
-------------------------------------------------------------------------------
--
-- Description: 
-- This is the top level behavioral description for the xFFT_1024_v1_1 core
--
-------------------------------------------------------------------------------
-- Library Declarations
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library Xilinxcorelib;
use Xilinxcorelib.iputils_STD_LOGIC_ARITH.ALL;
use Xilinxcorelib.iputils_STD_LOGIC_SIGNED.ALL;

use std.textio.all;

library work;
-- Bi := 16;
ENTITY xfft1024_v1_1 IS
	PORT (
		XN_INDEX                : OUT std_logic_vector(9 DOWNTO 0) := "0000000000";   
		XN_RE                   : IN std_logic_vector(16 - 1 DOWNTO 0);   
		XN_IM                   : IN std_logic_vector(16 - 1 DOWNTO 0);   
		RESET                   : IN std_logic;   
		START                   : IN std_logic;   
		MRD                     : IN std_logic;   
		N_FFT                   : IN std_logic_vector(1 DOWNTO 0);   
		N_FFT_WE                : IN std_logic;   
		FWD_INV                 : IN std_logic;   
		FWD_INV_WE              : IN std_logic;   
		SCALE_SCH               : IN std_logic_vector(9 DOWNTO 0);   
		SCALE_SCH_WE            : IN std_logic;   
		CLK                     : IN std_logic;   
		CE                      : IN std_logic;   
		XK_RE                   : OUT std_logic_vector(16 - 1 DOWNTO 0) := (others =>'0');
		XK_IM                   : OUT std_logic_vector(16 - 1 DOWNTO 0):= (others =>'0');
		XK_INDEX                : OUT std_logic_vector(9 DOWNTO 0) := (others =>'0');
		RDY                     : OUT std_logic := '0';   
		BUSY                    : OUT std_logic := '0';   
		EDONE                   : OUT std_logic := '0';   
		DONE                    : OUT std_logic := '0';   
		OVFLO                   : OUT std_logic := '0');   
END xfft1024_v1_1;

ARCHITECTURE behav_VHDL OF xfft1024_v1_1 IS

	constant Bi  :  integer := 16;    --  Input width

	COMPONENT PE0
	GENERIC (
		Bo                             :  integer := 16;    --  Output width
		Bdrfly                         :  integer := 16;    --  wordlength of the dragonfly 
		Btw                            :  integer := 18);    --  Width of twiddle factors 
	PORT (
		DRFLY_I0_RE             : IN  std_logic_vector(Bdrfly - 1 DOWNTO 0);
		DRFLY_I0_IM             : IN  std_logic_vector(Bdrfly - 1 DOWNTO 0);
		DRFLY_I1_RE             : IN  std_logic_vector(Bdrfly - 1 DOWNTO 0);
		DRFLY_I1_IM             : IN  std_logic_vector(Bdrfly - 1 DOWNTO 0);
		DRFLY_I2_RE             : IN  std_logic_vector(Bdrfly - 1 DOWNTO 0);
		DRFLY_I2_IM             : IN  std_logic_vector(Bdrfly - 1 DOWNTO 0);
		DRFLY_I3_RE             : IN  std_logic_vector(Bdrfly - 1 DOWNTO 0);
		DRFLY_I3_IM             : IN  std_logic_vector(Bdrfly - 1 DOWNTO 0);
		TW1_RE                  : IN  std_logic_vector(Btw - 1 DOWNTO 0);
		TW1_IM                  : IN  std_logic_vector(Btw - 1 DOWNTO 0);
		TW2_RE                  : IN  std_logic_vector(Btw - 1 DOWNTO 0);
		TW2_IM                  : IN  std_logic_vector(Btw - 1 DOWNTO 0);
		TW3_RE                  : IN  std_logic_vector(Btw - 1 DOWNTO 0);
		TW3_IM                  : IN  std_logic_vector(Btw - 1 DOWNTO 0);
		SCALE                   : IN  std_logic_vector(1 DOWNTO 0);
		OVFLO                   : OUT std_logic;
		RES_O0_RE               : OUT std_logic_vector(Bo - 1 DOWNTO 0);
		RES_O0_IM               : OUT std_logic_vector(Bo - 1 DOWNTO 0);
		RES_O1_RE               : OUT std_logic_vector(Bo - 1 DOWNTO 0);
		RES_O1_IM               : OUT std_logic_vector(Bo - 1 DOWNTO 0);
		RES_O2_RE               : OUT std_logic_vector(Bo - 1 DOWNTO 0);
		RES_O2_IM               : OUT std_logic_vector(Bo - 1 DOWNTO 0);
		RES_O3_RE               : OUT std_logic_vector(Bo - 1 DOWNTO 0);
		RES_O3_IM               : OUT std_logic_vector(Bo - 1 DOWNTO 0));
	END COMPONENT;

	COMPONENT PE1
	GENERIC (
		Bo					:  integer := 16;    --  Output width
		Bdrfly				:  integer := 16);    --  wordlength of the dragonfly 
	PORT (
		DRFLY_I0_RE             : IN  std_logic_vector(Bdrfly - 1 DOWNTO 0);
		DRFLY_I0_IM             : IN  std_logic_vector(Bdrfly - 1 DOWNTO 0);
		DRFLY_I1_RE             : IN  std_logic_vector(Bdrfly - 1 DOWNTO 0);
		DRFLY_I1_IM             : IN  std_logic_vector(Bdrfly - 1 DOWNTO 0);
		DRFLY_I2_RE             : IN  std_logic_vector(Bdrfly - 1 DOWNTO 0);
		DRFLY_I2_IM             : IN  std_logic_vector(Bdrfly - 1 DOWNTO 0);
		DRFLY_I3_RE             : IN  std_logic_vector(Bdrfly - 1 DOWNTO 0);
		DRFLY_I3_IM             : IN  std_logic_vector(Bdrfly - 1 DOWNTO 0);
		SCALE                   : IN  std_logic_vector(1 DOWNTO 0);
		OVFLO                   : OUT std_logic;
		RES_O0_RE               : OUT std_logic_vector(Bo - 1 DOWNTO 0);
		RES_O0_IM               : OUT std_logic_vector(Bo - 1 DOWNTO 0);
		RES_O1_RE               : OUT std_logic_vector(Bo - 1 DOWNTO 0);
		RES_O1_IM               : OUT std_logic_vector(Bo - 1 DOWNTO 0);
		RES_O2_RE               : OUT std_logic_vector(Bo - 1 DOWNTO 0);
		RES_O2_IM               : OUT std_logic_vector(Bo - 1 DOWNTO 0);
		RES_O3_RE               : OUT std_logic_vector(Bo - 1 DOWNTO 0);
		RES_O3_IM               : OUT std_logic_vector(Bo - 1 DOWNTO 0));
	END COMPONENT;

	COMPONENT inverter
	GENERIC (Bi 				:  integer := 16);    
	PORT (
		gate                    : IN  std_logic;
		D                       : IN  std_logic_vector(Bi - 1 DOWNTO 0);
		Q                       : OUT std_logic_vector(Bi - 1 DOWNTO 0));
	END COMPONENT;



---------------------------------------------------------------------------------
--  type decalarations 
---------------------------------------------------------------------------------
	TYPE twiddle_vector	is array(0 to 1023) of std_logic_vector(17 DOWNTO 0) ;
	TYPE mem_bank 		is array(0 to 2048) of std_logic_vector(15 DOWNTO 0);
	TYPE rank_reg_type	is array(47 downto 0) of std_logic_vector(2 downto 0);
	TYPE rn_reg_type	is array(47 downto 0) of std_logic_vector(7 downto 0);
	TYPE n_reg_type		is array(47 downto 0) of std_logic_vector(9 downto 0);
	TYPE address_type	is array(3 downto 0) of std_logic_vector(9 downto 0);
	type TEXT is file of character;	

---------------------------------------------------------------------------------
--  signal decalarations 
---------------------------------------------------------------------------------

	signal started 	  		: std_logic_vector(2 DOWNTO 0) := (others => '0');   
	signal tw1_re					: std_logic_vector(17 DOWNTO 0) := (others => '0');   
	signal tw1_im					: std_logic_vector(17 DOWNTO 0) := (others => '0');   
	signal tw2_re					: std_logic_vector(17 DOWNTO 0) := (others => '0');   
	signal tw2_im					: std_logic_vector(17 DOWNTO 0) := (others => '0');   
	signal tw3_re					: std_logic_vector(17 DOWNTO 0) := (others => '0');   
	signal tw3_im					: std_logic_vector(17 DOWNTO 0) := (others => '0');   

	-- Data inputs and outputs of PE0
	signal data_i0_PE0              : std_logic_vector(2 * Bi - 1 DOWNTO 0) := (others => '0');   
	signal data_i1_PE0              : std_logic_vector(2 * Bi - 1 DOWNTO 0) := (others => '0');   
	signal data_i2_PE0              : std_logic_vector(2 * Bi - 1 DOWNTO 0) := (others => '0');   
	signal data_i3_PE0              : std_logic_vector(2 * Bi - 1 DOWNTO 0) := (others => '0');   
	signal data_o0_PE0              : std_logic_vector(2 * Bi - 1 DOWNTO 0) := (others => '0');   
	signal data_o1_PE0              : std_logic_vector(2 * Bi - 1 DOWNTO 0) := (others => '0');   
	signal data_o2_PE0              : std_logic_vector(2 * Bi - 1 DOWNTO 0) := (others => '0');   
	signal data_o3_PE0              : std_logic_vector(2 * Bi - 1 DOWNTO 0) := (others => '0');   

	-- Data inputs and outputs of PE1
	signal data_i0_PE1              : std_logic_vector(2 * Bi - 1 DOWNTO 0) := (others => '0');   
	signal data_i1_PE1              : std_logic_vector(2 * Bi - 1 DOWNTO 0) := (others => '0');   
	signal data_i2_PE1              : std_logic_vector(2 * Bi - 1 DOWNTO 0) := (others => '0');   
	signal data_i3_PE1              : std_logic_vector(2 * Bi - 1 DOWNTO 0) := (others => '0');   
	signal data_o0_PE1              : std_logic_vector(2 * Bi - 1 DOWNTO 0) := (others => '0');   
	signal data_o1_PE1              : std_logic_vector(2 * Bi - 1 DOWNTO 0) := (others => '0');   
	signal data_o2_PE1              : std_logic_vector(2 * Bi - 1 DOWNTO 0) := (others => '0');   
	signal data_o3_PE1              : std_logic_vector(2 * Bi - 1 DOWNTO 0) := (others => '0');   
	signal data_o0_PE1_inv          : std_logic_vector(Bi - 1 DOWNTO 0) := (others => '0');   
	signal data_o1_PE1_inv          : std_logic_vector(Bi - 1 DOWNTO 0) := (others => '0');   
	signal data_o2_PE1_inv          : std_logic_vector(Bi - 1 DOWNTO 0) := (others => '0');   
	signal data_o3_PE1_inv          : std_logic_vector(Bi - 1 DOWNTO 0) := (others => '0');   
	signal im_i_inv                 : std_logic_vector(Bi - 1 DOWNTO 0) := (others => '0');   
	signal fwd_inv0              	: std_logic :='0';   
	signal fwd_inv1              	: std_logic :='0';   
	signal fwd_inv2               	: std_logic :='0';   
	signal sc_sch0,  sc_sch1        : std_logic_vector(1 DOWNTO 0) := (others => '0');   
	signal OVFLO0,OVFLO1            : std_logic :='0';
	SIGNAL LDONE					: std_logic :='0';
	signal in_frame, iBS			: integer := 0;
	signal starts					: std_logic :='0';   


	FUNCTION TO_STD_LOGIC( b : boolean ) RETURN std_logic IS
	BEGIN
		if b	then RETURN ('1');
				else RETURN ('0');
		end if;			
	END TO_STD_LOGIC;

----------------------------------------------------------
-- Bitwise comparison of two std_logic_vector-s
----------------------------------------------------------
function bitwise_eql(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR)
return BOOLEAN is
    begin
    for i in L'range loop
        if L(i) /= R(i) then
        return FALSE;
        end if;
    end loop;
    return TRUE;
    end;	
---------------------------------------------------------------------------------
-- Begin Architecture
---------------------------------------------------------------------------------

BEGIN
	inv_i : inverter 
		PORT MAP (
		gate => fwd_inv0,
		D => XN_IM,
		Q => im_i_inv);   
   
	inv_PE0_0 : inverter 
		PORT MAP (
		gate => fwd_inv2,
		D => data_o0_PE1(Bi - 1 DOWNTO 0),
		Q => data_o0_PE1_inv);   
	
	inv_PE0_1 : inverter 
		PORT MAP (
		gate => fwd_inv2,
		D => data_o1_PE1(Bi - 1 DOWNTO 0),
		Q => data_o1_PE1_inv);   
	
	inv_PE0_2 : inverter 
		PORT MAP (
		gate => fwd_inv2,
		D => data_o2_PE1(Bi - 1 DOWNTO 0),
		Q => data_o2_PE1_inv);   
   
	inv_PE0_3 : inverter 
		PORT MAP (
		gate => fwd_inv2,
		D => data_o3_PE1(Bi - 1 DOWNTO 0),
		Q => data_o3_PE1_inv);   
   		 
	pe0_inst : PE0 		   											-- Hook up PE0
		PORT MAP (														   
		DRFLY_I0_RE => data_i0_PE0(2 * Bi - 1 DOWNTO Bi),				-- connections of the 
		DRFLY_I0_IM => data_i0_PE0(Bi - 1 DOWNTO 0),
		DRFLY_I1_RE => data_i1_PE0(2 * Bi - 1 DOWNTO Bi),				-- connections of the 
		DRFLY_I1_IM => data_i1_PE0(Bi - 1 DOWNTO 0),
		DRFLY_I2_RE => data_i2_PE0(2 * Bi - 1 DOWNTO Bi),
		DRFLY_I2_IM => data_i2_PE0(Bi - 1 DOWNTO 0),
		DRFLY_I3_RE => data_i3_PE0(2 * Bi - 1 DOWNTO Bi),
		DRFLY_I3_IM => data_i3_PE0(Bi - 1 DOWNTO 0),
		TW1_RE => tw1_re,				-- twiddle factors
		TW1_IM => tw1_im,
		TW2_RE => tw2_re,
		TW2_IM => tw2_im,
		TW3_RE => tw3_re,
		TW3_IM => tw3_im,
		SCALE => sc_sch0,
		OVFLO => OVFLO0,
		RES_O0_RE => data_o0_PE0(2 * Bi - 1 DOWNTO Bi),				-- connections of the 
		RES_O0_IM => data_o0_PE0(Bi - 1 DOWNTO 0),						-- 4 complex outputs 
		RES_O1_RE => data_o1_PE0(2 * Bi - 1 DOWNTO Bi),
		RES_O1_IM => data_o1_PE0(Bi - 1 DOWNTO 0),
		RES_O2_RE => data_o2_PE0(2 * Bi - 1 DOWNTO Bi),
		RES_O2_IM => data_o2_PE0(Bi - 1 DOWNTO 0),
		RES_O3_RE => data_o3_PE0(2 * Bi - 1 DOWNTO Bi),
		RES_O3_IM => data_o3_PE0(Bi - 1 DOWNTO 0));   

	pe1_inst : PE1 													-- Hook up PE1
		PORT MAP (
		DRFLY_I0_RE => data_i0_PE1(2 * Bi - 1 DOWNTO Bi),			-- connections of the 
		DRFLY_I0_IM => data_i0_PE1(Bi - 1 DOWNTO 0),				-- 4 complex inputs 
		DRFLY_I1_RE => data_i1_PE1(2 * Bi - 1 DOWNTO Bi),
		DRFLY_I1_IM => data_i1_PE1(Bi - 1 DOWNTO 0),
		DRFLY_I2_RE => data_i2_PE1(2 * Bi - 1 DOWNTO Bi),
		DRFLY_I2_IM => data_i2_PE1(Bi - 1 DOWNTO 0),
		DRFLY_I3_RE => data_i3_PE1(2 * Bi - 1 DOWNTO Bi),
		DRFLY_I3_IM => data_i3_PE1(Bi - 1 DOWNTO 0),
		SCALE => sc_sch1,
		OVFLO => OVFLO1,
		RES_O0_RE => data_o0_PE1(2 * Bi - 1 DOWNTO Bi),			-- connections of the 
		RES_O0_IM => data_o0_PE1(Bi - 1 DOWNTO 0),					-- 4 complex outputs 
		RES_O1_RE => data_o1_PE1(2 * Bi - 1 DOWNTO Bi),
		RES_O1_IM => data_o1_PE1(Bi - 1 DOWNTO 0),
		RES_O2_RE => data_o2_PE1(2 * Bi - 1 DOWNTO Bi),
		RES_O2_IM => data_o2_PE1(Bi - 1 DOWNTO 0),
		RES_O3_RE => data_o3_PE1(2 * Bi - 1 DOWNTO Bi),
		RES_O3_IM => data_o3_PE1(Bi - 1 DOWNTO 0));   
 
   
   PROCESS (CLK)
   
   -------------------------- VARIABLE DECLARATION PART ----------------------------	
	variable dpm_in_re 			: mem_bank ;		--  these are the real and imaginary parts of the
	variable dpm_in_im			: mem_bank ;		--  these are the real and imaginary parts of the
	variable dpm_PE0_re         : mem_bank ;		--  combined input, 
	variable dpm_PE0_im 		: mem_bank ;		--  combined input, 
	variable dpm_PE1_re			: mem_bank ;		--  ping-pong, and 
	variable dpm_PE1_im			: mem_bank ;		--  ping-pong, and 
	variable dpm_out_re 		: mem_bank ;		--  output buffers
	variable dpm_out_im			: mem_bank ;		--  output buffers
   	variable tw_re				: twiddle_vector;  --  twiddle memories. These will hold the real
	variable tw_im				: twiddle_vector;  --  and the imaginary part of twiddle factors 
	variable tw1,tw2,tw3		: std_logic_vector(9 DOWNTO 0) := (others => '0');   
	variable tw, tw_step		: integer := 0;
	variable scale_sch_i		: std_logic_vector(9 DOWNTO 0) := (others => '0');   --  registers keeping the scaling schedule
	variable scale_sch0         : std_logic_vector(9 DOWNTO 0) := (others => '0');  
	variable scale_sch1         : std_logic_vector(9 DOWNTO 0) := (others => '0');  
	variable scale_sch2         : std_logic_vector(9 DOWNTO 0) := (others => '0');  
	variable PE0_BS, PE0_BSd, PE1_BS, oBS : std_logic := '0';		--  I/O Bank select registers for PE0 and PE1
	variable RANKS, RNmax		: integer := 0;
	variable RNmaxad, Nmax		: integer := 0;
	variable ready, b 			: std_logic :='0';   
	variable frame, out_frame	: integer := 0;
	variable rank				: rank_reg_type;
	variable rn					: rn_reg_type;
	variable n					: n_reg_type;
	variable inverse			: std_logic := '0';   
	variable MRD_locked0, MRD_locked1, MRD_locked2, MRD_locked3 : std_logic := '0';
	variable OVFLOW_PE0			: std_logic :='0';
	variable OVFLOW_PE0_d		: std_logic :='0';
	variable OVFLOW_PE1			: std_logic :='0';
	variable i,d,k				: integer := 0;
	variable rd_addr0			: integer := 0;
	variable PE0_rd_addr		: address_type := ("0000000000", "0000000000", "0000000000", "0000000000");
	variable PE0_wr_addr		: address_type := ("0000000000", "0000000000", "0000000000", "0000000000");
	variable PE1_rd_addr		: address_type := ("0000000000", "0000000000", "0000000000", "0000000000");
	variable PE1_wr_addr		: address_type := ("0000000000", "0000000000", "0000000000", "0000000000");

	variable XK_RE_i			: std_logic_vector(Bi - 1 DOWNTO 0) := (others => '0');   
	variable XK_IM_i			: std_logic_vector(Bi - 1 DOWNTO 0) := (others => '0');   
	variable XK_INDEX1			: integer := 0;  
	variable XK_INDEX2			: std_logic_vector(9 DOWNTO 0) := (others => '0');   
	variable XK_INDEX_i  		: std_logic_vector(9 DOWNTO 0) := (others => '0');   
	variable rev_addr	  		: std_logic_vector(9 DOWNTO 0) := (others => '0');   
	variable started0_d			: std_logic :='0';   
	variable BUSY_i           	: std_logic :='0';   
	variable EDONE_i			: std_logic :='0';   
	variable DONE_i				: std_logic :='0';   
	variable OVFLO_i			: std_logic :='0';   
	variable RDY_i				: std_logic :='0';   
	variable bank_sel			: std_logic :='0';

	variable index				: integer;
	variable CR_LF				: boolean;
	variable c					: character;
	variable parm5				: string(1 to 5);
	variable load_index			: integer :=0;
	variable reset_xn_index		: std_logic;
	variable temp				: boolean;   
	variable inited				: boolean := false;
	
   	PROCEDURE init ( initialize : IN std_logic) IS      
	BEGIN
		IF (initialize = '1') THEN
			XK_RE <= "0000000000000000";    
			XK_IM <= "0000000000000000";    
			RANKS := 3;    
			scale_sch_i := "1111111111";    
			END IF;

		 --  set up flow control integers
		case RANKS is 			
			WHEN 5 		=> Nmax:=1024 ;
			WHEN 4 		=> Nmax:=256 ;
			WHEN others => Nmax:=64 ;
			end case;
		RNmax := (Nmax/4); RNmaxad := RNmax - 1; 
		if (Nmax/=1024) then RNmaxad := RNmaxad + 32; end if;
		frame :=  -1;    
		out_frame := 0;    
		PE0_BS := '0';    
		FOR i IN 1 TO 47 LOOP
			rank(i) := CONV_STD_LOGIC_vector(0,3);    
			n(i) := CONV_STD_LOGIC_vector(Nmax - i ,10);        
			rn(i) := CONV_STD_LOGIC_vector(RNmax - i , 8);    
			END LOOP;
		rank(0) := "000";    
		n(0)    := CONV_STD_LOGIC_vector(Nmax - 1, 10);    
		rn(0)   := CONV_STD_LOGIC_vector(RNmaxad, 8);    
		
		FOR i IN 0 TO 2047 LOOP
			dpm_in_re(i)  := (others => '0');    
			dpm_in_im(i)  := (others => '0');    
			dpm_PE0_re(i) := (others => '0');    
			dpm_PE0_im(i) := (others => '0');    
			dpm_out_re(i) := (others => '0');    
			dpm_out_im(i) := (others => '0');    
			IF (i < 1024) THEN
				dpm_PE1_re(i) := (others => '0');    
				dpm_PE1_im(i) := (others => '0');    
				END IF;
	      	END LOOP;         

		inverse := '0';    
		fwd_inv0 <= '0';    --  set up fft/ifft control variables
		fwd_inv1 <= '0';    
		fwd_inv2 <= '0';    
		ready := '1';    --  set up outputs
		DONE  <= '0';    
		BUSY  <= '0';    
		EDONE <= '0';    
		OVFLO <= '0';    
		started(0) <= '0'; 
		started(1) <= '0'; 
		started(2) <= '0'; 
		started0_d := '0'; 
		XK_INDEX  <= "0000000000";    
		XK_INDEX1 := 0;    
		XN_INDEX  <= "0000000000";    
		MRD_locked0 := '0';    
		MRD_locked1 := '0';    
		MRD_locked2 := '0';    
		MRD_locked3 := '0';
		tw1			:= (others => '0');
		tw2			:= (others => '0');
		tw3			:= (others => '0');
	END init;

	PROCEDURE get_rev_addr ( addr: OUT std_logic_vector(9 DOWNTO 0))IS
		VARIABLE tmp:  std_logic_vector(9 DOWNTO 0);   
		BEGIN
			tmp := XK_INDEX_i;    
			CASE RANKS IS
	            WHEN 4 		=> addr := "00" & tmp(1 DOWNTO 0) & tmp(3 DOWNTO 2) & tmp(5 DOWNTO 4) & tmp(7 DOWNTO 6);    
	            WHEN 5 		=> addr := tmp(1 DOWNTO 0) & tmp(3 DOWNTO 2) & tmp(5 DOWNTO 4) & tmp(7 DOWNTO 6) & tmp(9 DOWNTO 8);    
	            WHEN OTHERS => addr := "00" & "00" & tmp(1 DOWNTO 0) & tmp(3 DOWNTO 2) & tmp(5 DOWNTO 4);    
	         	END CASE;
      	END get_rev_addr;

	BEGIN
		if not inited then 			-- device "power-up"		
			tw_re(0000) := "011111111111111111"; tw_im(0000) := "000000000000000000"; tw_re(0001) := "011111111111111101"; tw_im(0001) := "111111110011011100"; tw_re(0002) := "011111111111110110"; tw_im(0002) := "111111100110110111"; tw_re(0003) := "011111111111101010"; tw_im(0003) := "111111011010010011"; 
			tw_re(0004) := "011111111111011000"; tw_im(0004) := "111111001101101111"; tw_re(0005) := "011111111111000010"; tw_im(0005) := "111111000001001011"; tw_re(0006) := "011111111110100111"; tw_im(0006) := "111110110100100111"; tw_re(0007) := "011111111110000111"; tw_im(0007) := "111110101000000100"; 
			tw_re(0008) := "011111111101100010"; tw_im(0008) := "111110011011100000"; tw_re(0009) := "011111111100111000"; tw_im(0009) := "111110001110111101"; tw_re(0010) := "011111111100001001"; tw_im(0010) := "111110000010011010"; tw_re(0011) := "011111111011010101"; tw_im(0011) := "111101110101111000"; 
			tw_re(0012) := "011111111010011101"; tw_im(0012) := "111101101001010101"; tw_re(0013) := "011111111001011111"; tw_im(0013) := "111101011100110100"; tw_re(0014) := "011111111000011100"; tw_im(0014) := "111101010000010010"; tw_re(0015) := "011111110111010101"; tw_im(0015) := "111101000011110001"; 
			tw_re(0016) := "011111110110001001"; tw_im(0016) := "111100110111010000"; tw_re(0017) := "011111110100110111"; tw_im(0017) := "111100101010110000"; tw_re(0018) := "011111110011100001"; tw_im(0018) := "111100011110010001"; tw_re(0019) := "011111110010000110"; tw_im(0019) := "111100010001110010"; 
			tw_re(0020) := "011111110000100110"; tw_im(0020) := "111100000101010011"; tw_re(0021) := "011111101111000001"; tw_im(0021) := "111011111000110101"; tw_re(0022) := "011111101101010111"; tw_im(0022) := "111011101100011000"; tw_re(0023) := "011111101011101001"; tw_im(0023) := "111011011111111011"; 
			tw_re(0024) := "011111101001110101"; tw_im(0024) := "111011010011011111"; tw_re(0025) := "011111100111111101"; tw_im(0025) := "111011000111000100"; tw_re(0026) := "011111100101111111"; tw_im(0026) := "111010111010101010"; tw_re(0027) := "011111100011111101"; tw_im(0027) := "111010101110010000"; 
			tw_re(0028) := "011111100001110110"; tw_im(0028) := "111010100001110111"; tw_re(0029) := "011111011111101010"; tw_im(0029) := "111010010101011111"; tw_re(0030) := "011111011101011001"; tw_im(0030) := "111010001001001000"; tw_re(0031) := "011111011011000100"; tw_im(0031) := "111001111100110010"; 
			tw_re(0032) := "011111011000101001"; tw_im(0032) := "111001110000011101"; tw_re(0033) := "011111010110001010"; tw_im(0033) := "111001100100001001"; tw_re(0034) := "011111010011100110"; tw_im(0034) := "111001010111110101"; tw_re(0035) := "011111010000111101"; tw_im(0035) := "111001001011100011"; 
			tw_re(0036) := "011111001110001111"; tw_im(0036) := "111000111111010010"; tw_re(0037) := "011111001011011100"; tw_im(0037) := "111000110011000010"; tw_re(0038) := "011111001000100101"; tw_im(0038) := "111000100110110011"; tw_re(0039) := "011111000101101001"; tw_im(0039) := "111000011010100101"; 
			tw_re(0040) := "011111000010101000"; tw_im(0040) := "111000001110011000"; tw_re(0041) := "011110111111100010"; tw_im(0041) := "111000000010001100"; tw_re(0042) := "011110111100010111"; tw_im(0042) := "110111110110000010"; tw_re(0043) := "011110111001001000"; tw_im(0043) := "110111101001111001"; 
			tw_re(0044) := "011110110101110100"; tw_im(0044) := "110111011101110001"; tw_re(0045) := "011110110010011011"; tw_im(0045) := "110111010001101011"; tw_re(0046) := "011110101110111101"; tw_im(0046) := "110111000101100110"; tw_re(0047) := "011110101011011011"; tw_im(0047) := "110110111001100010"; 
			tw_re(0048) := "011110100111110100"; tw_im(0048) := "110110101101100000"; tw_re(0049) := "011110100100001000"; tw_im(0049) := "110110100001011111"; tw_re(0050) := "011110100000010111"; tw_im(0050) := "110110010101011111"; tw_re(0051) := "011110011100100010"; tw_im(0051) := "110110001001100001"; 
			tw_re(0052) := "011110011000101000"; tw_im(0052) := "110101111101100101"; tw_re(0053) := "011110010100101010"; tw_im(0053) := "110101110001101010"; tw_re(0054) := "011110010000100110"; tw_im(0054) := "110101100101110001"; tw_re(0055) := "011110001100011110"; tw_im(0055) := "110101011001111001"; 
			tw_re(0056) := "011110001000010010"; tw_im(0056) := "110101001110000011"; tw_re(0057) := "011110000100000001"; tw_im(0057) := "110101000010001111"; tw_re(0058) := "011101111111101011"; tw_im(0058) := "110100110110011100"; tw_re(0059) := "011101111011010000"; tw_im(0059) := "110100101010101011"; 
			tw_re(0060) := "011101110110110001"; tw_im(0060) := "110100011110111100"; tw_re(0061) := "011101110010001101"; tw_im(0061) := "110100010011001110"; tw_re(0062) := "011101101101100101"; tw_im(0062) := "110100000111100010"; tw_re(0063) := "011101101000111000"; tw_im(0063) := "110011111011111001"; 
			tw_re(0064) := "011101100100000110"; tw_im(0064) := "110011110000010001"; tw_re(0065) := "011101011111010000"; tw_im(0065) := "110011100100101011"; tw_re(0066) := "011101011010010110"; tw_im(0066) := "110011011001000110"; tw_re(0067) := "011101010101010111"; tw_im(0067) := "110011001101100100"; 
			tw_re(0068) := "011101010000010011"; tw_im(0068) := "110011000010000100"; tw_re(0069) := "011101001011001011"; tw_im(0069) := "110010110110100110"; tw_re(0070) := "011101000101111110"; tw_im(0070) := "110010101011001001"; tw_re(0071) := "011101000000101101"; tw_im(0071) := "110010011111101111"; 
			tw_re(0072) := "011100111011010111"; tw_im(0072) := "110010010100010111"; tw_re(0073) := "011100110101111101"; tw_im(0073) := "110010001001000001"; tw_re(0074) := "011100110000011111"; tw_im(0074) := "110001111101101101"; tw_re(0075) := "011100101010111100"; tw_im(0075) := "110001110010011100"; 
			tw_re(0076) := "011100100101010100"; tw_im(0076) := "110001100111001100"; tw_re(0077) := "011100011111101001"; tw_im(0077) := "110001011011111111"; tw_re(0078) := "011100011001111000"; tw_im(0078) := "110001010000110100"; tw_re(0079) := "011100010100000100"; tw_im(0079) := "110001000101101011"; 
			tw_re(0080) := "011100001110001011"; tw_im(0080) := "110000111010100101"; tw_re(0081) := "011100001000001110"; tw_im(0081) := "110000101111100001"; tw_re(0082) := "011100000010001100"; tw_im(0082) := "110000100100011111"; tw_re(0083) := "011011111100000110"; tw_im(0083) := "110000011001100000"; 
			tw_re(0084) := "011011110101111100"; tw_im(0084) := "110000001110100011"; tw_re(0085) := "011011101111101101"; tw_im(0085) := "110000000011101000"; tw_re(0086) := "011011101001011010"; tw_im(0086) := "101111111000110000"; tw_re(0087) := "011011100011000011"; tw_im(0087) := "101111101101111010"; 
			tw_re(0088) := "011011011100101000"; tw_im(0088) := "101111100011000111"; tw_re(0089) := "011011010110001000"; tw_im(0089) := "101111011000010111"; tw_re(0090) := "011011001111100101"; tw_im(0090) := "101111001101101001"; tw_re(0091) := "011011001000111101"; tw_im(0091) := "101111000010111101"; 
			tw_re(0092) := "011011000010010000"; tw_im(0092) := "101110111000010101"; tw_re(0093) := "011010111011100000"; tw_im(0093) := "101110101101101110"; tw_re(0094) := "011010110100101100"; tw_im(0094) := "101110100011001011"; tw_re(0095) := "011010101101110011"; tw_im(0095) := "101110011000101010"; 
			tw_re(0096) := "011010100110110110"; tw_im(0096) := "101110001110001100"; tw_re(0097) := "011010011111110101"; tw_im(0097) := "101110000011110001"; tw_re(0098) := "011010011000110000"; tw_im(0098) := "101101111001011000"; tw_re(0099) := "011010010001100111"; tw_im(0099) := "101101101111000010"; 
			tw_re(0100) := "011010001010011010"; tw_im(0100) := "101101100100101111"; tw_re(0101) := "011010000011001001"; tw_im(0101) := "101101011010011111"; tw_re(0102) := "011001111011110100"; tw_im(0102) := "101101010000010010"; tw_re(0103) := "011001110100011011"; tw_im(0103) := "101101000110001000"; 
			tw_re(0104) := "011001101100111110"; tw_im(0104) := "101100111100000000"; tw_re(0105) := "011001100101011101"; tw_im(0105) := "101100110001111100"; tw_re(0106) := "011001011101111000"; tw_im(0106) := "101100100111111010"; tw_re(0107) := "011001010110001111"; tw_im(0107) := "101100011101111100"; 
			tw_re(0108) := "011001001110100010"; tw_im(0108) := "101100010100000000"; tw_re(0109) := "011001000110110001"; tw_im(0109) := "101100001010001000"; tw_re(0110) := "011000111110111101"; tw_im(0110) := "101100000000010010"; tw_re(0111) := "011000110111000100"; tw_im(0111) := "101011110110100000"; 
			tw_re(0112) := "011000101111001000"; tw_im(0112) := "101011101100110001"; tw_re(0113) := "011000100111001000"; tw_im(0113) := "101011100011000100"; tw_re(0114) := "011000011111000100"; tw_im(0114) := "101011011001011011"; tw_re(0115) := "011000010110111100"; tw_im(0115) := "101011001111110110"; 
			tw_re(0116) := "011000001110110001"; tw_im(0116) := "101011000110010011"; tw_re(0117) := "011000000110100001"; tw_im(0117) := "101010111100110100"; tw_re(0118) := "010111111110001111"; tw_im(0118) := "101010110011011000"; tw_re(0119) := "010111110101111000"; tw_im(0119) := "101010101001111111"; 
			tw_re(0120) := "010111101101011110"; tw_im(0120) := "101010100000101001"; tw_re(0121) := "010111100101000000"; tw_im(0121) := "101010010111010111"; tw_re(0122) := "010111011100011110"; tw_im(0122) := "101010001110001000"; tw_re(0123) := "010111010011111001"; tw_im(0123) := "101010000100111100"; 
			tw_re(0124) := "010111001011010000"; tw_im(0124) := "101001111011110100"; tw_re(0125) := "010111000010100100"; tw_im(0125) := "101001110010110000"; tw_re(0126) := "010110111001110100"; tw_im(0126) := "101001101001101110"; tw_re(0127) := "010110110001000001"; tw_im(0127) := "101001100000110000"; 
			tw_re(0128) := "010110101000001010"; tw_im(0128) := "101001010111110110"; tw_re(0129) := "010110011111001111"; tw_im(0129) := "101001001110111111"; tw_re(0130) := "010110010110010001"; tw_im(0130) := "101001000110001011"; tw_re(0131) := "010110001101010000"; tw_im(0131) := "101000111101011100"; 
			tw_re(0132) := "010110000100001011"; tw_im(0132) := "101000110100101111"; tw_re(0133) := "010101111011000011"; tw_im(0133) := "101000101100000110"; tw_re(0134) := "010101110001110111"; tw_im(0134) := "101000100011100001"; tw_re(0135) := "010101101000101001"; tw_im(0135) := "101000011011000000"; 
			tw_re(0136) := "010101011111010110"; tw_im(0136) := "101000010010100010"; tw_re(0137) := "010101010110000001"; tw_im(0137) := "101000001010001000"; tw_re(0138) := "010101001100101000"; tw_im(0138) := "101000000001110001"; tw_re(0139) := "010101000011001100"; tw_im(0139) := "100111111001011110"; 
			tw_re(0140) := "010100111001101100"; tw_im(0140) := "100111110001001111"; tw_re(0141) := "010100110000001010"; tw_im(0141) := "100111101001000011"; tw_re(0142) := "010100100110100100"; tw_im(0142) := "100111100000111100"; tw_re(0143) := "010100011100111011"; tw_im(0143) := "100111011000111000"; 
			tw_re(0144) := "010100010011001111"; tw_im(0144) := "100111010000111000"; tw_re(0145) := "010100001001100000"; tw_im(0145) := "100111001000111011"; tw_re(0146) := "010011111111101101"; tw_im(0146) := "100111000001000011"; tw_re(0147) := "010011110101111000"; tw_im(0147) := "100110111001001110"; 
			tw_re(0148) := "010011101011111111"; tw_im(0148) := "100110110001011110"; tw_re(0149) := "010011100010000100"; tw_im(0149) := "100110101001110001"; tw_re(0150) := "010011011000000101"; tw_im(0150) := "100110100010001000"; tw_re(0151) := "010011001110000100"; tw_im(0151) := "100110011010100011"; 
			tw_re(0152) := "010011000011111111"; tw_im(0152) := "100110010011000010"; tw_re(0153) := "010010111001111000"; tw_im(0153) := "100110001011100101"; tw_re(0154) := "010010101111101101"; tw_im(0154) := "100110000100001100"; tw_re(0155) := "010010100101100000"; tw_im(0155) := "100101111100110110"; 
			tw_re(0156) := "010010011011010000"; tw_im(0156) := "100101110101100101"; tw_re(0157) := "010010010000111101"; tw_im(0157) := "100101101110011000"; tw_re(0158) := "010010000110100111"; tw_im(0158) := "100101100111001111"; tw_re(0159) := "010001111100001111"; tw_im(0159) := "100101100000001010"; 
			tw_re(0160) := "010001110001110011"; tw_im(0160) := "100101011001001001"; tw_re(0161) := "010001100111010101"; tw_im(0161) := "100101010010001101"; tw_re(0162) := "010001011100110101"; tw_im(0162) := "100101001011010100"; tw_re(0163) := "010001010010010001"; tw_im(0163) := "100101000100011111"; 
			tw_re(0164) := "010001000111101011"; tw_im(0164) := "100100111101101111"; tw_re(0165) := "010000111101000010"; tw_im(0165) := "100100110111000011"; tw_re(0166) := "010000110010010111"; tw_im(0166) := "100100110000011011"; tw_re(0167) := "010000100111101001"; tw_im(0167) := "100100101001110111"; 
			tw_re(0168) := "010000011100111000"; tw_im(0168) := "100100100011011000"; tw_re(0169) := "010000010010000101"; tw_im(0169) := "100100011100111100"; tw_re(0170) := "010000000111010000"; tw_im(0170) := "100100010110100101"; tw_re(0171) := "001111111100010111"; tw_im(0171) := "100100010000010010"; 
			tw_re(0172) := "001111110001011101"; tw_im(0172) := "100100001010000100"; tw_re(0173) := "001111100110100000"; tw_im(0173) := "100100000011111001"; tw_re(0174) := "001111011011100001"; tw_im(0174) := "100011111101110011"; tw_re(0175) := "001111010000011111"; tw_im(0175) := "100011110111110010"; 
			tw_re(0176) := "001111000101011011"; tw_im(0176) := "100011110001110101"; tw_re(0177) := "001110111010010100"; tw_im(0177) := "100011101011111100"; tw_re(0178) := "001110101111001011"; tw_im(0178) := "100011100110000111"; tw_re(0179) := "001110100100000000"; tw_im(0179) := "100011100000010111"; 
			tw_re(0180) := "001110011000110011"; tw_im(0180) := "100011011010101011"; tw_re(0181) := "001110001101100100"; tw_im(0181) := "100011010101000100"; tw_re(0182) := "001110000010010010"; tw_im(0182) := "100011001111100001"; tw_re(0183) := "001101110110111110"; tw_im(0183) := "100011001010000010"; 
			tw_re(0184) := "001101101011101000"; tw_im(0184) := "100011000100101000"; tw_re(0185) := "001101100000010000"; tw_im(0185) := "100010111111010010"; tw_re(0186) := "001101010100110110"; tw_im(0186) := "100010111010000001"; tw_re(0187) := "001101001001011010"; tw_im(0187) := "100010110100110101"; 
			tw_re(0188) := "001100111101111100"; tw_im(0188) := "100010101111101100"; tw_re(0189) := "001100110010011011"; tw_im(0189) := "100010101010101001"; tw_re(0190) := "001100100110111001"; tw_im(0190) := "100010100101101010"; tw_re(0191) := "001100011011010101"; tw_im(0191) := "100010100000101111"; 
			tw_re(0192) := "001100001111101111"; tw_im(0192) := "100010011011111001"; tw_re(0193) := "001100000100000111"; tw_im(0193) := "100010010111001000"; tw_re(0194) := "001011111000011101"; tw_im(0194) := "100010010010011011"; tw_re(0195) := "001011101100110001"; tw_im(0195) := "100010001101110010"; 
			tw_re(0196) := "001011100001000100"; tw_im(0196) := "100010001001001111"; tw_re(0197) := "001011010101010101"; tw_im(0197) := "100010000100101111"; tw_re(0198) := "001011001001100100"; tw_im(0198) := "100010000000010101"; tw_re(0199) := "001010111101110001"; tw_im(0199) := "100001111011111111"; 
			tw_re(0200) := "001010110001111101"; tw_im(0200) := "100001110111101110"; tw_re(0201) := "001010100110000111"; tw_im(0201) := "100001110011100001"; tw_re(0202) := "001010011010001111"; tw_im(0202) := "100001101111011001"; tw_re(0203) := "001010001110010110"; tw_im(0203) := "100001101011010110"; 
			tw_re(0204) := "001010000010011011"; tw_im(0204) := "100001100111010111"; tw_re(0205) := "001001110110011110"; tw_im(0205) := "100001100011011101"; tw_re(0206) := "001001101010100000"; tw_im(0206) := "100001011111101000"; tw_re(0207) := "001001011110100001"; tw_im(0207) := "100001011011110111"; 
			tw_re(0208) := "001001010010100000"; tw_im(0208) := "100001011000001100"; tw_re(0209) := "001001000110011110"; tw_im(0209) := "100001010100100101"; tw_re(0210) := "001000111010011010"; tw_im(0210) := "100001010001000010"; tw_re(0211) := "001000101110010101"; tw_im(0211) := "100001001101100101"; 
			tw_re(0212) := "001000100010001110"; tw_im(0212) := "100001001010001100"; tw_re(0213) := "001000010110000111"; tw_im(0213) := "100001000110111000"; tw_re(0214) := "001000001001111110"; tw_im(0214) := "100001000011101000"; tw_re(0215) := "000111111101110011"; tw_im(0215) := "100001000000011110"; 
			tw_re(0216) := "000111110001101000"; tw_im(0216) := "100000111101011000"; tw_re(0217) := "000111100101011011"; tw_im(0217) := "100000111010010111"; tw_re(0218) := "000111011001001101"; tw_im(0218) := "100000110111011011"; tw_re(0219) := "000111001100111110"; tw_im(0219) := "100000110100100011"; 
			tw_re(0220) := "000111000000101110"; tw_im(0220) := "100000110001110001"; tw_re(0221) := "000110110100011101"; tw_im(0221) := "100000101111000011"; tw_re(0222) := "000110101000001010"; tw_im(0222) := "100000101100011010"; tw_re(0223) := "000110011011110111"; tw_im(0223) := "100000101001110110"; 
			tw_re(0224) := "000110001111100011"; tw_im(0224) := "100000100111010110"; tw_re(0225) := "000110000011001101"; tw_im(0225) := "100000100100111100"; tw_re(0226) := "000101110110110111"; tw_im(0226) := "100000100010100110"; tw_re(0227) := "000101101010100000"; tw_im(0227) := "100000100000010101"; 
			tw_re(0228) := "000101011110001000"; tw_im(0228) := "100000011110001001"; tw_re(0229) := "000101010001101111"; tw_im(0229) := "100000011100000010"; tw_re(0230) := "000101000101010110"; tw_im(0230) := "100000011010000000"; tw_re(0231) := "000100111000111011"; tw_im(0231) := "100000011000000011"; 
			tw_re(0232) := "000100101100100000"; tw_im(0232) := "100000010110001010"; tw_re(0233) := "000100100000000100"; tw_im(0233) := "100000010100010111"; tw_re(0234) := "000100010011101000"; tw_im(0234) := "100000010010101000"; tw_re(0235) := "000100000111001010"; tw_im(0235) := "100000010000111110"; 
			tw_re(0236) := "000011111010101100"; tw_im(0236) := "100000001111011001"; tw_re(0237) := "000011101110001110"; tw_im(0237) := "100000001101111001"; tw_re(0238) := "000011100001101111"; tw_im(0238) := "100000001100011110"; tw_re(0239) := "000011010101001111"; tw_im(0239) := "100000001011001000"; 
			tw_re(0240) := "000011001000101111"; tw_im(0240) := "100000001001110111"; tw_re(0241) := "000010111100001110"; tw_im(0241) := "100000001000101011"; tw_re(0242) := "000010101111101101"; tw_im(0242) := "100000000111100011"; tw_re(0243) := "000010100011001100"; tw_im(0243) := "100000000110100001"; 
			tw_re(0244) := "000010010110101010"; tw_im(0244) := "100000000101100011"; tw_re(0245) := "000010001010001000"; tw_im(0245) := "100000000100101010"; tw_re(0246) := "000001111101100101"; tw_im(0246) := "100000000011110110"; tw_re(0247) := "000001110001000010"; tw_im(0247) := "100000000011001000"; 
			tw_re(0248) := "000001100100011111"; tw_im(0248) := "100000000010011110"; tw_re(0249) := "000001010111111100"; tw_im(0249) := "100000000001111001"; tw_re(0250) := "000001001011011000"; tw_im(0250) := "100000000001011001"; tw_re(0251) := "000000111110110100"; tw_im(0251) := "100000000000111101"; 
			tw_re(0252) := "000000110010010000"; tw_im(0252) := "100000000000100111"; tw_re(0253) := "000000100101101100"; tw_im(0253) := "100000000000010110"; tw_re(0254) := "000000011001001000"; tw_im(0254) := "100000000000001010"; tw_re(0255) := "000000001100100100"; tw_im(0255) := "100000000000000010"; 
			tw_re(0256) := "000000000000000000"; tw_im(0256) := "100000000000000001"; tw_re(0257) := "111111110011011100"; tw_im(0257) := "100000000000000010"; tw_re(0258) := "111111100110110111"; tw_im(0258) := "100000000000001010"; tw_re(0259) := "111111011010010011"; tw_im(0259) := "100000000000010110"; 
			tw_re(0260) := "111111001101101111"; tw_im(0260) := "100000000000100111"; tw_re(0261) := "111111000001001011"; tw_im(0261) := "100000000000111101"; tw_re(0262) := "111110110100100111"; tw_im(0262) := "100000000001011001"; tw_re(0263) := "111110101000000100"; tw_im(0263) := "100000000001111001"; 
			tw_re(0264) := "111110011011100000"; tw_im(0264) := "100000000010011110"; tw_re(0265) := "111110001110111101"; tw_im(0265) := "100000000011001000"; tw_re(0266) := "111110000010011010"; tw_im(0266) := "100000000011110110"; tw_re(0267) := "111101110101111000"; tw_im(0267) := "100000000100101010"; 
			tw_re(0268) := "111101101001010101"; tw_im(0268) := "100000000101100011"; tw_re(0269) := "111101011100110100"; tw_im(0269) := "100000000110100001"; tw_re(0270) := "111101010000010010"; tw_im(0270) := "100000000111100011"; tw_re(0271) := "111101000011110001"; tw_im(0271) := "100000001000101011"; 
			tw_re(0272) := "111100110111010000"; tw_im(0272) := "100000001001110111"; tw_re(0273) := "111100101010110000"; tw_im(0273) := "100000001011001000"; tw_re(0274) := "111100011110010001"; tw_im(0274) := "100000001100011110"; tw_re(0275) := "111100010001110010"; tw_im(0275) := "100000001101111001"; 
			tw_re(0276) := "111100000101010011"; tw_im(0276) := "100000001111011001"; tw_re(0277) := "111011111000110101"; tw_im(0277) := "100000010000111110"; tw_re(0278) := "111011101100011000"; tw_im(0278) := "100000010010101000"; tw_re(0279) := "111011011111111011"; tw_im(0279) := "100000010100010111"; 
			tw_re(0280) := "111011010011011111"; tw_im(0280) := "100000010110001010"; tw_re(0281) := "111011000111000100"; tw_im(0281) := "100000011000000011"; tw_re(0282) := "111010111010101010"; tw_im(0282) := "100000011010000000"; tw_re(0283) := "111010101110010000"; tw_im(0283) := "100000011100000010"; 
			tw_re(0284) := "111010100001110111"; tw_im(0284) := "100000011110001001"; tw_re(0285) := "111010010101011111"; tw_im(0285) := "100000100000010101"; tw_re(0286) := "111010001001001000"; tw_im(0286) := "100000100010100110"; tw_re(0287) := "111001111100110010"; tw_im(0287) := "100000100100111100"; 
			tw_re(0288) := "111001110000011101"; tw_im(0288) := "100000100111010110"; tw_re(0289) := "111001100100001001"; tw_im(0289) := "100000101001110110"; tw_re(0290) := "111001010111110101"; tw_im(0290) := "100000101100011010"; tw_re(0291) := "111001001011100011"; tw_im(0291) := "100000101111000011"; 
			tw_re(0292) := "111000111111010010"; tw_im(0292) := "100000110001110001"; tw_re(0293) := "111000110011000010"; tw_im(0293) := "100000110100100011"; tw_re(0294) := "111000100110110011"; tw_im(0294) := "100000110111011011"; tw_re(0295) := "111000011010100101"; tw_im(0295) := "100000111010010111"; 
			tw_re(0296) := "111000001110011000"; tw_im(0296) := "100000111101011000"; tw_re(0297) := "111000000010001100"; tw_im(0297) := "100001000000011110"; tw_re(0298) := "110111110110000010"; tw_im(0298) := "100001000011101000"; tw_re(0299) := "110111101001111001"; tw_im(0299) := "100001000110111000"; 
			tw_re(0300) := "110111011101110001"; tw_im(0300) := "100001001010001100"; tw_re(0301) := "110111010001101011"; tw_im(0301) := "100001001101100101"; tw_re(0302) := "110111000101100110"; tw_im(0302) := "100001010001000010"; tw_re(0303) := "110110111001100010"; tw_im(0303) := "100001010100100101"; 
			tw_re(0304) := "110110101101100000"; tw_im(0304) := "100001011000001100"; tw_re(0305) := "110110100001011111"; tw_im(0305) := "100001011011110111"; tw_re(0306) := "110110010101011111"; tw_im(0306) := "100001011111101000"; tw_re(0307) := "110110001001100001"; tw_im(0307) := "100001100011011101"; 
			tw_re(0308) := "110101111101100101"; tw_im(0308) := "100001100111010111"; tw_re(0309) := "110101110001101010"; tw_im(0309) := "100001101011010110"; tw_re(0310) := "110101100101110001"; tw_im(0310) := "100001101111011001"; tw_re(0311) := "110101011001111001"; tw_im(0311) := "100001110011100001"; 
			tw_re(0312) := "110101001110000011"; tw_im(0312) := "100001110111101110"; tw_re(0313) := "110101000010001111"; tw_im(0313) := "100001111011111111"; tw_re(0314) := "110100110110011100"; tw_im(0314) := "100010000000010101"; tw_re(0315) := "110100101010101011"; tw_im(0315) := "100010000100101111"; 
			tw_re(0316) := "110100011110111100"; tw_im(0316) := "100010001001001111"; tw_re(0317) := "110100010011001110"; tw_im(0317) := "100010001101110010"; tw_re(0318) := "110100000111100010"; tw_im(0318) := "100010010010011011"; tw_re(0319) := "110011111011111001"; tw_im(0319) := "100010010111001000"; 
			tw_re(0320) := "110011110000010001"; tw_im(0320) := "100010011011111001"; tw_re(0321) := "110011100100101011"; tw_im(0321) := "100010100000101111"; tw_re(0322) := "110011011001000110"; tw_im(0322) := "100010100101101010"; tw_re(0323) := "110011001101100100"; tw_im(0323) := "100010101010101001"; 
			tw_re(0324) := "110011000010000100"; tw_im(0324) := "100010101111101100"; tw_re(0325) := "110010110110100110"; tw_im(0325) := "100010110100110101"; tw_re(0326) := "110010101011001001"; tw_im(0326) := "100010111010000001"; tw_re(0327) := "110010011111101111"; tw_im(0327) := "100010111111010010"; 
			tw_re(0328) := "110010010100010111"; tw_im(0328) := "100011000100101000"; tw_re(0329) := "110010001001000001"; tw_im(0329) := "100011001010000010"; tw_re(0330) := "110001111101101101"; tw_im(0330) := "100011001111100001"; tw_re(0331) := "110001110010011100"; tw_im(0331) := "100011010101000100"; 
			tw_re(0332) := "110001100111001100"; tw_im(0332) := "100011011010101011"; tw_re(0333) := "110001011011111111"; tw_im(0333) := "100011100000010111"; tw_re(0334) := "110001010000110100"; tw_im(0334) := "100011100110000111"; tw_re(0335) := "110001000101101011"; tw_im(0335) := "100011101011111100"; 
			tw_re(0336) := "110000111010100101"; tw_im(0336) := "100011110001110101"; tw_re(0337) := "110000101111100001"; tw_im(0337) := "100011110111110010"; tw_re(0338) := "110000100100011111"; tw_im(0338) := "100011111101110011"; tw_re(0339) := "110000011001100000"; tw_im(0339) := "100100000011111001"; 
			tw_re(0340) := "110000001110100011"; tw_im(0340) := "100100001010000100"; tw_re(0341) := "110000000011101000"; tw_im(0341) := "100100010000010010"; tw_re(0342) := "101111111000110000"; tw_im(0342) := "100100010110100101"; tw_re(0343) := "101111101101111010"; tw_im(0343) := "100100011100111100"; 
			tw_re(0344) := "101111100011000111"; tw_im(0344) := "100100100011011000"; tw_re(0345) := "101111011000010111"; tw_im(0345) := "100100101001110111"; tw_re(0346) := "101111001101101001"; tw_im(0346) := "100100110000011011"; tw_re(0347) := "101111000010111101"; tw_im(0347) := "100100110111000011"; 
			tw_re(0348) := "101110111000010101"; tw_im(0348) := "100100111101101111"; tw_re(0349) := "101110101101101110"; tw_im(0349) := "100101000100011111"; tw_re(0350) := "101110100011001011"; tw_im(0350) := "100101001011010100"; tw_re(0351) := "101110011000101010"; tw_im(0351) := "100101010010001101"; 
			tw_re(0352) := "101110001110001100"; tw_im(0352) := "100101011001001001"; tw_re(0353) := "101110000011110001"; tw_im(0353) := "100101100000001010"; tw_re(0354) := "101101111001011000"; tw_im(0354) := "100101100111001111"; tw_re(0355) := "101101101111000010"; tw_im(0355) := "100101101110011000"; 
			tw_re(0356) := "101101100100101111"; tw_im(0356) := "100101110101100101"; tw_re(0357) := "101101011010011111"; tw_im(0357) := "100101111100110110"; tw_re(0358) := "101101010000010010"; tw_im(0358) := "100110000100001100"; tw_re(0359) := "101101000110001000"; tw_im(0359) := "100110001011100101"; 
			tw_re(0360) := "101100111100000000"; tw_im(0360) := "100110010011000010"; tw_re(0361) := "101100110001111100"; tw_im(0361) := "100110011010100011"; tw_re(0362) := "101100100111111010"; tw_im(0362) := "100110100010001000"; tw_re(0363) := "101100011101111100"; tw_im(0363) := "100110101001110001"; 
			tw_re(0364) := "101100010100000000"; tw_im(0364) := "100110110001011110"; tw_re(0365) := "101100001010001000"; tw_im(0365) := "100110111001001110"; tw_re(0366) := "101100000000010010"; tw_im(0366) := "100111000001000011"; tw_re(0367) := "101011110110100000"; tw_im(0367) := "100111001000111011"; 
			tw_re(0368) := "101011101100110001"; tw_im(0368) := "100111010000111000"; tw_re(0369) := "101011100011000100"; tw_im(0369) := "100111011000111000"; tw_re(0370) := "101011011001011011"; tw_im(0370) := "100111100000111100"; tw_re(0371) := "101011001111110110"; tw_im(0371) := "100111101001000011"; 
			tw_re(0372) := "101011000110010011"; tw_im(0372) := "100111110001001111"; tw_re(0373) := "101010111100110100"; tw_im(0373) := "100111111001011110"; tw_re(0374) := "101010110011011000"; tw_im(0374) := "101000000001110001"; tw_re(0375) := "101010101001111111"; tw_im(0375) := "101000001010001000"; 
			tw_re(0376) := "101010100000101001"; tw_im(0376) := "101000010010100010"; tw_re(0377) := "101010010111010111"; tw_im(0377) := "101000011011000000"; tw_re(0378) := "101010001110001000"; tw_im(0378) := "101000100011100001"; tw_re(0379) := "101010000100111100"; tw_im(0379) := "101000101100000110"; 
			tw_re(0380) := "101001111011110100"; tw_im(0380) := "101000110100101111"; tw_re(0381) := "101001110010110000"; tw_im(0381) := "101000111101011100"; tw_re(0382) := "101001101001101110"; tw_im(0382) := "101001000110001011"; tw_re(0383) := "101001100000110000"; tw_im(0383) := "101001001110111111"; 
			tw_re(0384) := "101001010111110110"; tw_im(0384) := "101001010111110110"; tw_re(0385) := "101001001110111111"; tw_im(0385) := "101001100000110000"; tw_re(0386) := "101001000110001011"; tw_im(0386) := "101001101001101110"; tw_re(0387) := "101000111101011100"; tw_im(0387) := "101001110010110000"; 
			tw_re(0388) := "101000110100101111"; tw_im(0388) := "101001111011110100"; tw_re(0389) := "101000101100000110"; tw_im(0389) := "101010000100111100"; tw_re(0390) := "101000100011100001"; tw_im(0390) := "101010001110001000"; tw_re(0391) := "101000011011000000"; tw_im(0391) := "101010010111010111"; 
			tw_re(0392) := "101000010010100010"; tw_im(0392) := "101010100000101001"; tw_re(0393) := "101000001010001000"; tw_im(0393) := "101010101001111111"; tw_re(0394) := "101000000001110001"; tw_im(0394) := "101010110011011000"; tw_re(0395) := "100111111001011110"; tw_im(0395) := "101010111100110100"; 
			tw_re(0396) := "100111110001001111"; tw_im(0396) := "101011000110010011"; tw_re(0397) := "100111101001000011"; tw_im(0397) := "101011001111110110"; tw_re(0398) := "100111100000111100"; tw_im(0398) := "101011011001011011"; tw_re(0399) := "100111011000111000"; tw_im(0399) := "101011100011000100"; 
			tw_re(0400) := "100111010000111000"; tw_im(0400) := "101011101100110001"; tw_re(0401) := "100111001000111011"; tw_im(0401) := "101011110110100000"; tw_re(0402) := "100111000001000011"; tw_im(0402) := "101100000000010010"; tw_re(0403) := "100110111001001110"; tw_im(0403) := "101100001010001000"; 
			tw_re(0404) := "100110110001011110"; tw_im(0404) := "101100010100000000"; tw_re(0405) := "100110101001110001"; tw_im(0405) := "101100011101111100"; tw_re(0406) := "100110100010001000"; tw_im(0406) := "101100100111111010"; tw_re(0407) := "100110011010100011"; tw_im(0407) := "101100110001111100"; 
			tw_re(0408) := "100110010011000010"; tw_im(0408) := "101100111100000000"; tw_re(0409) := "100110001011100101"; tw_im(0409) := "101101000110001000"; tw_re(0410) := "100110000100001100"; tw_im(0410) := "101101010000010010"; tw_re(0411) := "100101111100110110"; tw_im(0411) := "101101011010011111"; 
			tw_re(0412) := "100101110101100101"; tw_im(0412) := "101101100100101111"; tw_re(0413) := "100101101110011000"; tw_im(0413) := "101101101111000010"; tw_re(0414) := "100101100111001111"; tw_im(0414) := "101101111001011000"; tw_re(0415) := "100101100000001010"; tw_im(0415) := "101110000011110001"; 
			tw_re(0416) := "100101011001001001"; tw_im(0416) := "101110001110001100"; tw_re(0417) := "100101010010001101"; tw_im(0417) := "101110011000101010"; tw_re(0418) := "100101001011010100"; tw_im(0418) := "101110100011001011"; tw_re(0419) := "100101000100011111"; tw_im(0419) := "101110101101101110"; 
			tw_re(0420) := "100100111101101111"; tw_im(0420) := "101110111000010101"; tw_re(0421) := "100100110111000011"; tw_im(0421) := "101111000010111101"; tw_re(0422) := "100100110000011011"; tw_im(0422) := "101111001101101001"; tw_re(0423) := "100100101001110111"; tw_im(0423) := "101111011000010111"; 
			tw_re(0424) := "100100100011011000"; tw_im(0424) := "101111100011000111"; tw_re(0425) := "100100011100111100"; tw_im(0425) := "101111101101111010"; tw_re(0426) := "100100010110100101"; tw_im(0426) := "101111111000110000"; tw_re(0427) := "100100010000010010"; tw_im(0427) := "110000000011101000"; 
			tw_re(0428) := "100100001010000100"; tw_im(0428) := "110000001110100011"; tw_re(0429) := "100100000011111001"; tw_im(0429) := "110000011001100000"; tw_re(0430) := "100011111101110011"; tw_im(0430) := "110000100100011111"; tw_re(0431) := "100011110111110010"; tw_im(0431) := "110000101111100001"; 
			tw_re(0432) := "100011110001110101"; tw_im(0432) := "110000111010100101"; tw_re(0433) := "100011101011111100"; tw_im(0433) := "110001000101101011"; tw_re(0434) := "100011100110000111"; tw_im(0434) := "110001010000110100"; tw_re(0435) := "100011100000010111"; tw_im(0435) := "110001011011111111"; 
			tw_re(0436) := "100011011010101011"; tw_im(0436) := "110001100111001100"; tw_re(0437) := "100011010101000100"; tw_im(0437) := "110001110010011100"; tw_re(0438) := "100011001111100001"; tw_im(0438) := "110001111101101101"; tw_re(0439) := "100011001010000010"; tw_im(0439) := "110010001001000001"; 
			tw_re(0440) := "100011000100101000"; tw_im(0440) := "110010010100010111"; tw_re(0441) := "100010111111010010"; tw_im(0441) := "110010011111101111"; tw_re(0442) := "100010111010000001"; tw_im(0442) := "110010101011001001"; tw_re(0443) := "100010110100110101"; tw_im(0443) := "110010110110100110"; 
			tw_re(0444) := "100010101111101100"; tw_im(0444) := "110011000010000100"; tw_re(0445) := "100010101010101001"; tw_im(0445) := "110011001101100100"; tw_re(0446) := "100010100101101010"; tw_im(0446) := "110011011001000110"; tw_re(0447) := "100010100000101111"; tw_im(0447) := "110011100100101011"; 
			tw_re(0448) := "100010011011111001"; tw_im(0448) := "110011110000010001"; tw_re(0449) := "100010010111001000"; tw_im(0449) := "110011111011111001"; tw_re(0450) := "100010010010011011"; tw_im(0450) := "110100000111100010"; tw_re(0451) := "100010001101110010"; tw_im(0451) := "110100010011001110"; 
			tw_re(0452) := "100010001001001111"; tw_im(0452) := "110100011110111100"; tw_re(0453) := "100010000100101111"; tw_im(0453) := "110100101010101011"; tw_re(0454) := "100010000000010101"; tw_im(0454) := "110100110110011100"; tw_re(0455) := "100001111011111111"; tw_im(0455) := "110101000010001111"; 
			tw_re(0456) := "100001110111101110"; tw_im(0456) := "110101001110000011"; tw_re(0457) := "100001110011100001"; tw_im(0457) := "110101011001111001"; tw_re(0458) := "100001101111011001"; tw_im(0458) := "110101100101110001"; tw_re(0459) := "100001101011010110"; tw_im(0459) := "110101110001101010"; 
			tw_re(0460) := "100001100111010111"; tw_im(0460) := "110101111101100101"; tw_re(0461) := "100001100011011101"; tw_im(0461) := "110110001001100001"; tw_re(0462) := "100001011111101000"; tw_im(0462) := "110110010101011111"; tw_re(0463) := "100001011011110111"; tw_im(0463) := "110110100001011111"; 
			tw_re(0464) := "100001011000001100"; tw_im(0464) := "110110101101100000"; tw_re(0465) := "100001010100100101"; tw_im(0465) := "110110111001100010"; tw_re(0466) := "100001010001000010"; tw_im(0466) := "110111000101100110"; tw_re(0467) := "100001001101100101"; tw_im(0467) := "110111010001101011"; 
			tw_re(0468) := "100001001010001100"; tw_im(0468) := "110111011101110001"; tw_re(0469) := "100001000110111000"; tw_im(0469) := "110111101001111001"; tw_re(0470) := "100001000011101000"; tw_im(0470) := "110111110110000010"; tw_re(0471) := "100001000000011110"; tw_im(0471) := "111000000010001100"; 
			tw_re(0472) := "100000111101011000"; tw_im(0472) := "111000001110011000"; tw_re(0473) := "100000111010010111"; tw_im(0473) := "111000011010100101"; tw_re(0474) := "100000110111011011"; tw_im(0474) := "111000100110110011"; tw_re(0475) := "100000110100100011"; tw_im(0475) := "111000110011000010"; 
			tw_re(0476) := "100000110001110001"; tw_im(0476) := "111000111111010010"; tw_re(0477) := "100000101111000011"; tw_im(0477) := "111001001011100011"; tw_re(0478) := "100000101100011010"; tw_im(0478) := "111001010111110101"; tw_re(0479) := "100000101001110110"; tw_im(0479) := "111001100100001001"; 
			tw_re(0480) := "100000100111010110"; tw_im(0480) := "111001110000011101"; tw_re(0481) := "100000100100111100"; tw_im(0481) := "111001111100110010"; tw_re(0482) := "100000100010100110"; tw_im(0482) := "111010001001001000"; tw_re(0483) := "100000100000010101"; tw_im(0483) := "111010010101011111"; 
			tw_re(0484) := "100000011110001001"; tw_im(0484) := "111010100001110111"; tw_re(0485) := "100000011100000010"; tw_im(0485) := "111010101110010000"; tw_re(0486) := "100000011010000000"; tw_im(0486) := "111010111010101010"; tw_re(0487) := "100000011000000011"; tw_im(0487) := "111011000111000100"; 
			tw_re(0488) := "100000010110001010"; tw_im(0488) := "111011010011011111"; tw_re(0489) := "100000010100010111"; tw_im(0489) := "111011011111111011"; tw_re(0490) := "100000010010101000"; tw_im(0490) := "111011101100011000"; tw_re(0491) := "100000010000111110"; tw_im(0491) := "111011111000110101"; 
			tw_re(0492) := "100000001111011001"; tw_im(0492) := "111100000101010011"; tw_re(0493) := "100000001101111001"; tw_im(0493) := "111100010001110010"; tw_re(0494) := "100000001100011110"; tw_im(0494) := "111100011110010001"; tw_re(0495) := "100000001011001000"; tw_im(0495) := "111100101010110000"; 
			tw_re(0496) := "100000001001110111"; tw_im(0496) := "111100110111010000"; tw_re(0497) := "100000001000101011"; tw_im(0497) := "111101000011110001"; tw_re(0498) := "100000000111100011"; tw_im(0498) := "111101010000010010"; tw_re(0499) := "100000000110100001"; tw_im(0499) := "111101011100110100"; 
			tw_re(0500) := "100000000101100011"; tw_im(0500) := "111101101001010101"; tw_re(0501) := "100000000100101010"; tw_im(0501) := "111101110101111000"; tw_re(0502) := "100000000011110110"; tw_im(0502) := "111110000010011010"; tw_re(0503) := "100000000011001000"; tw_im(0503) := "111110001110111101"; 
			tw_re(0504) := "100000000010011110"; tw_im(0504) := "111110011011100000"; tw_re(0505) := "100000000001111001"; tw_im(0505) := "111110101000000100"; tw_re(0506) := "100000000001011001"; tw_im(0506) := "111110110100100111"; tw_re(0507) := "100000000000111101"; tw_im(0507) := "111111000001001011"; 
			tw_re(0508) := "100000000000100111"; tw_im(0508) := "111111001101101111"; tw_re(0509) := "100000000000010110"; tw_im(0509) := "111111011010010011"; tw_re(0510) := "100000000000001010"; tw_im(0510) := "111111100110110111"; tw_re(0511) := "100000000000000010"; tw_im(0511) := "111111110011011100"; 
			tw_re(0512) := "100000000000000001"; tw_im(0512) := "000000000000000000"; tw_re(0513) := "100000000000000010"; tw_im(0513) := "000000001100100100"; tw_re(0514) := "100000000000001010"; tw_im(0514) := "000000011001001000"; tw_re(0515) := "100000000000010110"; tw_im(0515) := "000000100101101100"; 
			tw_re(0516) := "100000000000100111"; tw_im(0516) := "000000110010010000"; tw_re(0517) := "100000000000111101"; tw_im(0517) := "000000111110110100"; tw_re(0518) := "100000000001011001"; tw_im(0518) := "000001001011011000"; tw_re(0519) := "100000000001111001"; tw_im(0519) := "000001010111111100"; 
			tw_re(0520) := "100000000010011110"; tw_im(0520) := "000001100100011111"; tw_re(0521) := "100000000011001000"; tw_im(0521) := "000001110001000010"; tw_re(0522) := "100000000011110110"; tw_im(0522) := "000001111101100101"; tw_re(0523) := "100000000100101010"; tw_im(0523) := "000010001010001000"; 
			tw_re(0524) := "100000000101100011"; tw_im(0524) := "000010010110101010"; tw_re(0525) := "100000000110100001"; tw_im(0525) := "000010100011001100"; tw_re(0526) := "100000000111100011"; tw_im(0526) := "000010101111101101"; tw_re(0527) := "100000001000101011"; tw_im(0527) := "000010111100001110"; 
			tw_re(0528) := "100000001001110111"; tw_im(0528) := "000011001000101111"; tw_re(0529) := "100000001011001000"; tw_im(0529) := "000011010101001111"; tw_re(0530) := "100000001100011110"; tw_im(0530) := "000011100001101111"; tw_re(0531) := "100000001101111001"; tw_im(0531) := "000011101110001110"; 
			tw_re(0532) := "100000001111011001"; tw_im(0532) := "000011111010101100"; tw_re(0533) := "100000010000111110"; tw_im(0533) := "000100000111001010"; tw_re(0534) := "100000010010101000"; tw_im(0534) := "000100010011101000"; tw_re(0535) := "100000010100010111"; tw_im(0535) := "000100100000000100"; 
			tw_re(0536) := "100000010110001010"; tw_im(0536) := "000100101100100000"; tw_re(0537) := "100000011000000011"; tw_im(0537) := "000100111000111011"; tw_re(0538) := "100000011010000000"; tw_im(0538) := "000101000101010110"; tw_re(0539) := "100000011100000010"; tw_im(0539) := "000101010001101111"; 
			tw_re(0540) := "100000011110001001"; tw_im(0540) := "000101011110001000"; tw_re(0541) := "100000100000010101"; tw_im(0541) := "000101101010100000"; tw_re(0542) := "100000100010100110"; tw_im(0542) := "000101110110110111"; tw_re(0543) := "100000100100111100"; tw_im(0543) := "000110000011001101"; 
			tw_re(0544) := "100000100111010110"; tw_im(0544) := "000110001111100011"; tw_re(0545) := "100000101001110110"; tw_im(0545) := "000110011011110111"; tw_re(0546) := "100000101100011010"; tw_im(0546) := "000110101000001010"; tw_re(0547) := "100000101111000011"; tw_im(0547) := "000110110100011101"; 
			tw_re(0548) := "100000110001110001"; tw_im(0548) := "000111000000101110"; tw_re(0549) := "100000110100100011"; tw_im(0549) := "000111001100111110"; tw_re(0550) := "100000110111011011"; tw_im(0550) := "000111011001001101"; tw_re(0551) := "100000111010010111"; tw_im(0551) := "000111100101011011"; 
			tw_re(0552) := "100000111101011000"; tw_im(0552) := "000111110001101000"; tw_re(0553) := "100001000000011110"; tw_im(0553) := "000111111101110011"; tw_re(0554) := "100001000011101000"; tw_im(0554) := "001000001001111110"; tw_re(0555) := "100001000110111000"; tw_im(0555) := "001000010110000111"; 
			tw_re(0556) := "100001001010001100"; tw_im(0556) := "001000100010001110"; tw_re(0557) := "100001001101100101"; tw_im(0557) := "001000101110010101"; tw_re(0558) := "100001010001000010"; tw_im(0558) := "001000111010011010"; tw_re(0559) := "100001010100100101"; tw_im(0559) := "001001000110011110"; 
			tw_re(0560) := "100001011000001100"; tw_im(0560) := "001001010010100000"; tw_re(0561) := "100001011011110111"; tw_im(0561) := "001001011110100001"; tw_re(0562) := "100001011111101000"; tw_im(0562) := "001001101010100000"; tw_re(0563) := "100001100011011101"; tw_im(0563) := "001001110110011110"; 
			tw_re(0564) := "100001100111010111"; tw_im(0564) := "001010000010011011"; tw_re(0565) := "100001101011010110"; tw_im(0565) := "001010001110010110"; tw_re(0566) := "100001101111011001"; tw_im(0566) := "001010011010001111"; tw_re(0567) := "100001110011100001"; tw_im(0567) := "001010100110000111"; 
			tw_re(0568) := "100001110111101110"; tw_im(0568) := "001010110001111101"; tw_re(0569) := "100001111011111111"; tw_im(0569) := "001010111101110001"; tw_re(0570) := "100010000000010101"; tw_im(0570) := "001011001001100100"; tw_re(0571) := "100010000100101111"; tw_im(0571) := "001011010101010101"; 
			tw_re(0572) := "100010001001001111"; tw_im(0572) := "001011100001000100"; tw_re(0573) := "100010001101110010"; tw_im(0573) := "001011101100110001"; tw_re(0574) := "100010010010011011"; tw_im(0574) := "001011111000011101"; tw_re(0575) := "100010010111001000"; tw_im(0575) := "001100000100000111"; 
			tw_re(0576) := "100010011011111001"; tw_im(0576) := "001100001111101111"; tw_re(0577) := "100010100000101111"; tw_im(0577) := "001100011011010101"; tw_re(0578) := "100010100101101010"; tw_im(0578) := "001100100110111001"; tw_re(0579) := "100010101010101001"; tw_im(0579) := "001100110010011011"; 
			tw_re(0580) := "100010101111101100"; tw_im(0580) := "001100111101111100"; tw_re(0581) := "100010110100110101"; tw_im(0581) := "001101001001011010"; tw_re(0582) := "100010111010000001"; tw_im(0582) := "001101010100110110"; tw_re(0583) := "100010111111010010"; tw_im(0583) := "001101100000010000"; 
			tw_re(0584) := "100011000100101000"; tw_im(0584) := "001101101011101000"; tw_re(0585) := "100011001010000010"; tw_im(0585) := "001101110110111110"; tw_re(0586) := "100011001111100001"; tw_im(0586) := "001110000010010010"; tw_re(0587) := "100011010101000100"; tw_im(0587) := "001110001101100100"; 
			tw_re(0588) := "100011011010101011"; tw_im(0588) := "001110011000110011"; tw_re(0589) := "100011100000010111"; tw_im(0589) := "001110100100000000"; tw_re(0590) := "100011100110000111"; tw_im(0590) := "001110101111001011"; tw_re(0591) := "100011101011111100"; tw_im(0591) := "001110111010010100"; 
			tw_re(0592) := "100011110001110101"; tw_im(0592) := "001111000101011011"; tw_re(0593) := "100011110111110010"; tw_im(0593) := "001111010000011111"; tw_re(0594) := "100011111101110011"; tw_im(0594) := "001111011011100001"; tw_re(0595) := "100100000011111001"; tw_im(0595) := "001111100110100000"; 
			tw_re(0596) := "100100001010000100"; tw_im(0596) := "001111110001011101"; tw_re(0597) := "100100010000010010"; tw_im(0597) := "001111111100010111"; tw_re(0598) := "100100010110100101"; tw_im(0598) := "010000000111010000"; tw_re(0599) := "100100011100111100"; tw_im(0599) := "010000010010000101"; 
			tw_re(0600) := "100100100011011000"; tw_im(0600) := "010000011100111000"; tw_re(0601) := "100100101001110111"; tw_im(0601) := "010000100111101001"; tw_re(0602) := "100100110000011011"; tw_im(0602) := "010000110010010111"; tw_re(0603) := "100100110111000011"; tw_im(0603) := "010000111101000010"; 
			tw_re(0604) := "100100111101101111"; tw_im(0604) := "010001000111101011"; tw_re(0605) := "100101000100011111"; tw_im(0605) := "010001010010010001"; tw_re(0606) := "100101001011010100"; tw_im(0606) := "010001011100110101"; tw_re(0607) := "100101010010001101"; tw_im(0607) := "010001100111010101"; 
			tw_re(0608) := "100101011001001001"; tw_im(0608) := "010001110001110011"; tw_re(0609) := "100101100000001010"; tw_im(0609) := "010001111100001111"; tw_re(0610) := "100101100111001111"; tw_im(0610) := "010010000110100111"; tw_re(0611) := "100101101110011000"; tw_im(0611) := "010010010000111101"; 
			tw_re(0612) := "100101110101100101"; tw_im(0612) := "010010011011010000"; tw_re(0613) := "100101111100110110"; tw_im(0613) := "010010100101100000"; tw_re(0614) := "100110000100001100"; tw_im(0614) := "010010101111101101"; tw_re(0615) := "100110001011100101"; tw_im(0615) := "010010111001111000"; 
			tw_re(0616) := "100110010011000010"; tw_im(0616) := "010011000011111111"; tw_re(0617) := "100110011010100011"; tw_im(0617) := "010011001110000100"; tw_re(0618) := "100110100010001000"; tw_im(0618) := "010011011000000101"; tw_re(0619) := "100110101001110001"; tw_im(0619) := "010011100010000100"; 
			tw_re(0620) := "100110110001011110"; tw_im(0620) := "010011101011111111"; tw_re(0621) := "100110111001001110"; tw_im(0621) := "010011110101111000"; tw_re(0622) := "100111000001000011"; tw_im(0622) := "010011111111101101"; tw_re(0623) := "100111001000111011"; tw_im(0623) := "010100001001100000"; 
			tw_re(0624) := "100111010000111000"; tw_im(0624) := "010100010011001111"; tw_re(0625) := "100111011000111000"; tw_im(0625) := "010100011100111011"; tw_re(0626) := "100111100000111100"; tw_im(0626) := "010100100110100100"; tw_re(0627) := "100111101001000011"; tw_im(0627) := "010100110000001010"; 
			tw_re(0628) := "100111110001001111"; tw_im(0628) := "010100111001101100"; tw_re(0629) := "100111111001011110"; tw_im(0629) := "010101000011001100"; tw_re(0630) := "101000000001110001"; tw_im(0630) := "010101001100101000"; tw_re(0631) := "101000001010001000"; tw_im(0631) := "010101010110000001"; 
			tw_re(0632) := "101000010010100010"; tw_im(0632) := "010101011111010110"; tw_re(0633) := "101000011011000000"; tw_im(0633) := "010101101000101001"; tw_re(0634) := "101000100011100001"; tw_im(0634) := "010101110001110111"; tw_re(0635) := "101000101100000110"; tw_im(0635) := "010101111011000011"; 
			tw_re(0636) := "101000110100101111"; tw_im(0636) := "010110000100001011"; tw_re(0637) := "101000111101011100"; tw_im(0637) := "010110001101010000"; tw_re(0638) := "101001000110001011"; tw_im(0638) := "010110010110010001"; tw_re(0639) := "101001001110111111"; tw_im(0639) := "010110011111001111"; 
			tw_re(0640) := "101001010111110110"; tw_im(0640) := "010110101000001010"; tw_re(0641) := "101001100000110000"; tw_im(0641) := "010110110001000001"; tw_re(0642) := "101001101001101110"; tw_im(0642) := "010110111001110100"; tw_re(0643) := "101001110010110000"; tw_im(0643) := "010111000010100100"; 
			tw_re(0644) := "101001111011110100"; tw_im(0644) := "010111001011010000"; tw_re(0645) := "101010000100111100"; tw_im(0645) := "010111010011111001"; tw_re(0646) := "101010001110001000"; tw_im(0646) := "010111011100011110"; tw_re(0647) := "101010010111010111"; tw_im(0647) := "010111100101000000"; 
			tw_re(0648) := "101010100000101001"; tw_im(0648) := "010111101101011110"; tw_re(0649) := "101010101001111111"; tw_im(0649) := "010111110101111000"; tw_re(0650) := "101010110011011000"; tw_im(0650) := "010111111110001111"; tw_re(0651) := "101010111100110100"; tw_im(0651) := "011000000110100001"; 
			tw_re(0652) := "101011000110010011"; tw_im(0652) := "011000001110110001"; tw_re(0653) := "101011001111110110"; tw_im(0653) := "011000010110111100"; tw_re(0654) := "101011011001011011"; tw_im(0654) := "011000011111000100"; tw_re(0655) := "101011100011000100"; tw_im(0655) := "011000100111001000"; 
			tw_re(0656) := "101011101100110001"; tw_im(0656) := "011000101111001000"; tw_re(0657) := "101011110110100000"; tw_im(0657) := "011000110111000100"; tw_re(0658) := "101100000000010010"; tw_im(0658) := "011000111110111101"; tw_re(0659) := "101100001010001000"; tw_im(0659) := "011001000110110001"; 
			tw_re(0660) := "101100010100000000"; tw_im(0660) := "011001001110100010"; tw_re(0661) := "101100011101111100"; tw_im(0661) := "011001010110001111"; tw_re(0662) := "101100100111111010"; tw_im(0662) := "011001011101111000"; tw_re(0663) := "101100110001111100"; tw_im(0663) := "011001100101011101"; 
			tw_re(0664) := "101100111100000000"; tw_im(0664) := "011001101100111110"; tw_re(0665) := "101101000110001000"; tw_im(0665) := "011001110100011011"; tw_re(0666) := "101101010000010010"; tw_im(0666) := "011001111011110100"; tw_re(0667) := "101101011010011111"; tw_im(0667) := "011010000011001001"; 
			tw_re(0668) := "101101100100101111"; tw_im(0668) := "011010001010011010"; tw_re(0669) := "101101101111000010"; tw_im(0669) := "011010010001100111"; tw_re(0670) := "101101111001011000"; tw_im(0670) := "011010011000110000"; tw_re(0671) := "101110000011110001"; tw_im(0671) := "011010011111110101"; 
			tw_re(0672) := "101110001110001100"; tw_im(0672) := "011010100110110110"; tw_re(0673) := "101110011000101010"; tw_im(0673) := "011010101101110011"; tw_re(0674) := "101110100011001011"; tw_im(0674) := "011010110100101100"; tw_re(0675) := "101110101101101110"; tw_im(0675) := "011010111011100000"; 
			tw_re(0676) := "101110111000010101"; tw_im(0676) := "011011000010010000"; tw_re(0677) := "101111000010111101"; tw_im(0677) := "011011001000111101"; tw_re(0678) := "101111001101101001"; tw_im(0678) := "011011001111100101"; tw_re(0679) := "101111011000010111"; tw_im(0679) := "011011010110001000"; 
			tw_re(0680) := "101111100011000111"; tw_im(0680) := "011011011100101000"; tw_re(0681) := "101111101101111010"; tw_im(0681) := "011011100011000011"; tw_re(0682) := "101111111000110000"; tw_im(0682) := "011011101001011010"; tw_re(0683) := "110000000011101000"; tw_im(0683) := "011011101111101101"; 
			tw_re(0684) := "110000001110100011"; tw_im(0684) := "011011110101111100"; tw_re(0685) := "110000011001100000"; tw_im(0685) := "011011111100000110"; tw_re(0686) := "110000100100011111"; tw_im(0686) := "011100000010001100"; tw_re(0687) := "110000101111100001"; tw_im(0687) := "011100001000001110"; 
			tw_re(0688) := "110000111010100101"; tw_im(0688) := "011100001110001011"; tw_re(0689) := "110001000101101011"; tw_im(0689) := "011100010100000100"; tw_re(0690) := "110001010000110100"; tw_im(0690) := "011100011001111000"; tw_re(0691) := "110001011011111111"; tw_im(0691) := "011100011111101001"; 
			tw_re(0692) := "110001100111001100"; tw_im(0692) := "011100100101010100"; tw_re(0693) := "110001110010011100"; tw_im(0693) := "011100101010111100"; tw_re(0694) := "110001111101101101"; tw_im(0694) := "011100110000011111"; tw_re(0695) := "110010001001000001"; tw_im(0695) := "011100110101111101"; 
			tw_re(0696) := "110010010100010111"; tw_im(0696) := "011100111011010111"; tw_re(0697) := "110010011111101111"; tw_im(0697) := "011101000000101101"; tw_re(0698) := "110010101011001001"; tw_im(0698) := "011101000101111110"; tw_re(0699) := "110010110110100110"; tw_im(0699) := "011101001011001011"; 
			tw_re(0700) := "110011000010000100"; tw_im(0700) := "011101010000010011"; tw_re(0701) := "110011001101100100"; tw_im(0701) := "011101010101010111"; tw_re(0702) := "110011011001000110"; tw_im(0702) := "011101011010010110"; tw_re(0703) := "110011100100101011"; tw_im(0703) := "011101011111010000"; 
			tw_re(0704) := "110011110000010001"; tw_im(0704) := "011101100100000110"; tw_re(0705) := "110011111011111001"; tw_im(0705) := "011101101000111000"; tw_re(0706) := "110100000111100010"; tw_im(0706) := "011101101101100101"; tw_re(0707) := "110100010011001110"; tw_im(0707) := "011101110010001101"; 
			tw_re(0708) := "110100011110111100"; tw_im(0708) := "011101110110110001"; tw_re(0709) := "110100101010101011"; tw_im(0709) := "011101111011010000"; tw_re(0710) := "110100110110011100"; tw_im(0710) := "011101111111101011"; tw_re(0711) := "110101000010001111"; tw_im(0711) := "011110000100000001"; 
			tw_re(0712) := "110101001110000011"; tw_im(0712) := "011110001000010010"; tw_re(0713) := "110101011001111001"; tw_im(0713) := "011110001100011110"; tw_re(0714) := "110101100101110001"; tw_im(0714) := "011110010000100110"; tw_re(0715) := "110101110001101010"; tw_im(0715) := "011110010100101010"; 
			tw_re(0716) := "110101111101100101"; tw_im(0716) := "011110011000101000"; tw_re(0717) := "110110001001100001"; tw_im(0717) := "011110011100100010"; tw_re(0718) := "110110010101011111"; tw_im(0718) := "011110100000010111"; tw_re(0719) := "110110100001011111"; tw_im(0719) := "011110100100001000"; 
			tw_re(0720) := "110110101101100000"; tw_im(0720) := "011110100111110100"; tw_re(0721) := "110110111001100010"; tw_im(0721) := "011110101011011011"; tw_re(0722) := "110111000101100110"; tw_im(0722) := "011110101110111101"; tw_re(0723) := "110111010001101011"; tw_im(0723) := "011110110010011011"; 
			tw_re(0724) := "110111011101110001"; tw_im(0724) := "011110110101110100"; tw_re(0725) := "110111101001111001"; tw_im(0725) := "011110111001001000"; tw_re(0726) := "110111110110000010"; tw_im(0726) := "011110111100010111"; tw_re(0727) := "111000000010001100"; tw_im(0727) := "011110111111100010"; 
			tw_re(0728) := "111000001110011000"; tw_im(0728) := "011111000010101000"; tw_re(0729) := "111000011010100101"; tw_im(0729) := "011111000101101001"; tw_re(0730) := "111000100110110011"; tw_im(0730) := "011111001000100101"; tw_re(0731) := "111000110011000010"; tw_im(0731) := "011111001011011100"; 
			tw_re(0732) := "111000111111010010"; tw_im(0732) := "011111001110001111"; tw_re(0733) := "111001001011100011"; tw_im(0733) := "011111010000111101"; tw_re(0734) := "111001010111110101"; tw_im(0734) := "011111010011100110"; tw_re(0735) := "111001100100001001"; tw_im(0735) := "011111010110001010"; 
			tw_re(0736) := "111001110000011101"; tw_im(0736) := "011111011000101001"; tw_re(0737) := "111001111100110010"; tw_im(0737) := "011111011011000100"; tw_re(0738) := "111010001001001000"; tw_im(0738) := "011111011101011001"; tw_re(0739) := "111010010101011111"; tw_im(0739) := "011111011111101010"; 
			tw_re(0740) := "111010100001110111"; tw_im(0740) := "011111100001110110"; tw_re(0741) := "111010101110010000"; tw_im(0741) := "011111100011111101"; tw_re(0742) := "111010111010101010"; tw_im(0742) := "011111100101111111"; tw_re(0743) := "111011000111000100"; tw_im(0743) := "011111100111111101"; 
			tw_re(0744) := "111011010011011111"; tw_im(0744) := "011111101001110101"; tw_re(0745) := "111011011111111011"; tw_im(0745) := "011111101011101001"; tw_re(0746) := "111011101100011000"; tw_im(0746) := "011111101101010111"; tw_re(0747) := "111011111000110101"; tw_im(0747) := "011111101111000001"; 
			tw_re(0748) := "111100000101010011"; tw_im(0748) := "011111110000100110"; tw_re(0749) := "111100010001110010"; tw_im(0749) := "011111110010000110"; tw_re(0750) := "111100011110010001"; tw_im(0750) := "011111110011100001"; tw_re(0751) := "111100101010110000"; tw_im(0751) := "011111110100110111"; 
			tw_re(0752) := "111100110111010000"; tw_im(0752) := "011111110110001001"; tw_re(0753) := "111101000011110001"; tw_im(0753) := "011111110111010101"; tw_re(0754) := "111101010000010010"; tw_im(0754) := "011111111000011100"; tw_re(0755) := "111101011100110100"; tw_im(0755) := "011111111001011111"; 
			tw_re(0756) := "111101101001010101"; tw_im(0756) := "011111111010011101"; tw_re(0757) := "111101110101111000"; tw_im(0757) := "011111111011010101"; tw_re(0758) := "111110000010011010"; tw_im(0758) := "011111111100001001"; tw_re(0759) := "111110001110111101"; tw_im(0759) := "011111111100111000"; 
			tw_re(0760) := "111110011011100000"; tw_im(0760) := "011111111101100010"; tw_re(0761) := "111110101000000100"; tw_im(0761) := "011111111110000111"; tw_re(0762) := "111110110100100111"; tw_im(0762) := "011111111110100111"; tw_re(0763) := "111111000001001011"; tw_im(0763) := "011111111111000010"; 
			tw_re(0764) := "111111001101101111"; tw_im(0764) := "011111111111011000"; tw_re(0765) := "111111011010010011"; tw_im(0765) := "011111111111101010"; tw_re(0766) := "111111100110110111"; tw_im(0766) := "011111111111110110"; tw_re(0767) := "111111110011011100"; tw_im(0767) := "011111111111111101"; 
			tw_re(0768) := "000000000000000000"; tw_im(0768) := "011111111111111111"; tw_re(0769) := "000000001100100100"; tw_im(0769) := "011111111111111101"; tw_re(0770) := "000000011001001000"; tw_im(0770) := "011111111111110110"; tw_re(0771) := "000000100101101100"; tw_im(0771) := "011111111111101010"; 
			tw_re(0772) := "000000110010010000"; tw_im(0772) := "011111111111011000"; tw_re(0773) := "000000111110110100"; tw_im(0773) := "011111111111000010"; tw_re(0774) := "000001001011011000"; tw_im(0774) := "011111111110100111"; tw_re(0775) := "000001010111111100"; tw_im(0775) := "011111111110000111"; 
			tw_re(0776) := "000001100100011111"; tw_im(0776) := "011111111101100010"; tw_re(0777) := "000001110001000010"; tw_im(0777) := "011111111100111000"; tw_re(0778) := "000001111101100101"; tw_im(0778) := "011111111100001001"; tw_re(0779) := "000010001010001000"; tw_im(0779) := "011111111011010101"; 
			tw_re(0780) := "000010010110101010"; tw_im(0780) := "011111111010011101"; tw_re(0781) := "000010100011001100"; tw_im(0781) := "011111111001011111"; tw_re(0782) := "000010101111101101"; tw_im(0782) := "011111111000011100"; tw_re(0783) := "000010111100001110"; tw_im(0783) := "011111110111010101"; 
			tw_re(0784) := "000011001000101111"; tw_im(0784) := "011111110110001001"; tw_re(0785) := "000011010101001111"; tw_im(0785) := "011111110100110111"; tw_re(0786) := "000011100001101111"; tw_im(0786) := "011111110011100001"; tw_re(0787) := "000011101110001110"; tw_im(0787) := "011111110010000110"; 
			tw_re(0788) := "000011111010101100"; tw_im(0788) := "011111110000100110"; tw_re(0789) := "000100000111001010"; tw_im(0789) := "011111101111000001"; tw_re(0790) := "000100010011101000"; tw_im(0790) := "011111101101010111"; tw_re(0791) := "000100100000000100"; tw_im(0791) := "011111101011101001"; 
			tw_re(0792) := "000100101100100000"; tw_im(0792) := "011111101001110101"; tw_re(0793) := "000100111000111011"; tw_im(0793) := "011111100111111101"; tw_re(0794) := "000101000101010110"; tw_im(0794) := "011111100101111111"; tw_re(0795) := "000101010001101111"; tw_im(0795) := "011111100011111101"; 
			tw_re(0796) := "000101011110001000"; tw_im(0796) := "011111100001110110"; tw_re(0797) := "000101101010100000"; tw_im(0797) := "011111011111101010"; tw_re(0798) := "000101110110110111"; tw_im(0798) := "011111011101011001"; tw_re(0799) := "000110000011001101"; tw_im(0799) := "011111011011000100"; 
			tw_re(0800) := "000110001111100011"; tw_im(0800) := "011111011000101001"; tw_re(0801) := "000110011011110111"; tw_im(0801) := "011111010110001010"; tw_re(0802) := "000110101000001010"; tw_im(0802) := "011111010011100110"; tw_re(0803) := "000110110100011101"; tw_im(0803) := "011111010000111101"; 
			tw_re(0804) := "000111000000101110"; tw_im(0804) := "011111001110001111"; tw_re(0805) := "000111001100111110"; tw_im(0805) := "011111001011011100"; tw_re(0806) := "000111011001001101"; tw_im(0806) := "011111001000100101"; tw_re(0807) := "000111100101011011"; tw_im(0807) := "011111000101101001"; 
			tw_re(0808) := "000111110001101000"; tw_im(0808) := "011111000010101000"; tw_re(0809) := "000111111101110011"; tw_im(0809) := "011110111111100010"; tw_re(0810) := "001000001001111110"; tw_im(0810) := "011110111100010111"; tw_re(0811) := "001000010110000111"; tw_im(0811) := "011110111001001000"; 
			tw_re(0812) := "001000100010001110"; tw_im(0812) := "011110110101110100"; tw_re(0813) := "001000101110010101"; tw_im(0813) := "011110110010011011"; tw_re(0814) := "001000111010011010"; tw_im(0814) := "011110101110111101"; tw_re(0815) := "001001000110011110"; tw_im(0815) := "011110101011011011"; 
			tw_re(0816) := "001001010010100000"; tw_im(0816) := "011110100111110100"; tw_re(0817) := "001001011110100001"; tw_im(0817) := "011110100100001000"; tw_re(0818) := "001001101010100000"; tw_im(0818) := "011110100000010111"; tw_re(0819) := "001001110110011110"; tw_im(0819) := "011110011100100010"; 
			tw_re(0820) := "001010000010011011"; tw_im(0820) := "011110011000101000"; tw_re(0821) := "001010001110010110"; tw_im(0821) := "011110010100101010"; tw_re(0822) := "001010011010001111"; tw_im(0822) := "011110010000100110"; tw_re(0823) := "001010100110000111"; tw_im(0823) := "011110001100011110"; 
			tw_re(0824) := "001010110001111101"; tw_im(0824) := "011110001000010010"; tw_re(0825) := "001010111101110001"; tw_im(0825) := "011110000100000001"; tw_re(0826) := "001011001001100100"; tw_im(0826) := "011101111111101011"; tw_re(0827) := "001011010101010101"; tw_im(0827) := "011101111011010000"; 
			tw_re(0828) := "001011100001000100"; tw_im(0828) := "011101110110110001"; tw_re(0829) := "001011101100110001"; tw_im(0829) := "011101110010001101"; tw_re(0830) := "001011111000011101"; tw_im(0830) := "011101101101100101"; tw_re(0831) := "001100000100000111"; tw_im(0831) := "011101101000111000"; 
			tw_re(0832) := "001100001111101111"; tw_im(0832) := "011101100100000110"; tw_re(0833) := "001100011011010101"; tw_im(0833) := "011101011111010000"; tw_re(0834) := "001100100110111001"; tw_im(0834) := "011101011010010110"; tw_re(0835) := "001100110010011011"; tw_im(0835) := "011101010101010111"; 
			tw_re(0836) := "001100111101111100"; tw_im(0836) := "011101010000010011"; tw_re(0837) := "001101001001011010"; tw_im(0837) := "011101001011001011"; tw_re(0838) := "001101010100110110"; tw_im(0838) := "011101000101111110"; tw_re(0839) := "001101100000010000"; tw_im(0839) := "011101000000101101"; 
			tw_re(0840) := "001101101011101000"; tw_im(0840) := "011100111011010111"; tw_re(0841) := "001101110110111110"; tw_im(0841) := "011100110101111101"; tw_re(0842) := "001110000010010010"; tw_im(0842) := "011100110000011111"; tw_re(0843) := "001110001101100100"; tw_im(0843) := "011100101010111100"; 
			tw_re(0844) := "001110011000110011"; tw_im(0844) := "011100100101010100"; tw_re(0845) := "001110100100000000"; tw_im(0845) := "011100011111101001"; tw_re(0846) := "001110101111001011"; tw_im(0846) := "011100011001111000"; tw_re(0847) := "001110111010010100"; tw_im(0847) := "011100010100000100"; 
			tw_re(0848) := "001111000101011011"; tw_im(0848) := "011100001110001011"; tw_re(0849) := "001111010000011111"; tw_im(0849) := "011100001000001110"; tw_re(0850) := "001111011011100001"; tw_im(0850) := "011100000010001100"; tw_re(0851) := "001111100110100000"; tw_im(0851) := "011011111100000110"; 
			tw_re(0852) := "001111110001011101"; tw_im(0852) := "011011110101111100"; tw_re(0853) := "001111111100010111"; tw_im(0853) := "011011101111101101"; tw_re(0854) := "010000000111010000"; tw_im(0854) := "011011101001011010"; tw_re(0855) := "010000010010000101"; tw_im(0855) := "011011100011000011"; 
			tw_re(0856) := "010000011100111000"; tw_im(0856) := "011011011100101000"; tw_re(0857) := "010000100111101001"; tw_im(0857) := "011011010110001000"; tw_re(0858) := "010000110010010111"; tw_im(0858) := "011011001111100101"; tw_re(0859) := "010000111101000010"; tw_im(0859) := "011011001000111101"; 
			tw_re(0860) := "010001000111101011"; tw_im(0860) := "011011000010010000"; tw_re(0861) := "010001010010010001"; tw_im(0861) := "011010111011100000"; tw_re(0862) := "010001011100110101"; tw_im(0862) := "011010110100101100"; tw_re(0863) := "010001100111010101"; tw_im(0863) := "011010101101110011"; 
			tw_re(0864) := "010001110001110011"; tw_im(0864) := "011010100110110110"; tw_re(0865) := "010001111100001111"; tw_im(0865) := "011010011111110101"; tw_re(0866) := "010010000110100111"; tw_im(0866) := "011010011000110000"; tw_re(0867) := "010010010000111101"; tw_im(0867) := "011010010001100111"; 
			tw_re(0868) := "010010011011010000"; tw_im(0868) := "011010001010011010"; tw_re(0869) := "010010100101100000"; tw_im(0869) := "011010000011001001"; tw_re(0870) := "010010101111101101"; tw_im(0870) := "011001111011110100"; tw_re(0871) := "010010111001111000"; tw_im(0871) := "011001110100011011"; 
			tw_re(0872) := "010011000011111111"; tw_im(0872) := "011001101100111110"; tw_re(0873) := "010011001110000100"; tw_im(0873) := "011001100101011101"; tw_re(0874) := "010011011000000101"; tw_im(0874) := "011001011101111000"; tw_re(0875) := "010011100010000100"; tw_im(0875) := "011001010110001111"; 
			tw_re(0876) := "010011101011111111"; tw_im(0876) := "011001001110100010"; tw_re(0877) := "010011110101111000"; tw_im(0877) := "011001000110110001"; tw_re(0878) := "010011111111101101"; tw_im(0878) := "011000111110111101"; tw_re(0879) := "010100001001100000"; tw_im(0879) := "011000110111000100"; 
			tw_re(0880) := "010100010011001111"; tw_im(0880) := "011000101111001000"; tw_re(0881) := "010100011100111011"; tw_im(0881) := "011000100111001000"; tw_re(0882) := "010100100110100100"; tw_im(0882) := "011000011111000100"; tw_re(0883) := "010100110000001010"; tw_im(0883) := "011000010110111100"; 
			tw_re(0884) := "010100111001101100"; tw_im(0884) := "011000001110110001"; tw_re(0885) := "010101000011001100"; tw_im(0885) := "011000000110100001"; tw_re(0886) := "010101001100101000"; tw_im(0886) := "010111111110001111"; tw_re(0887) := "010101010110000001"; tw_im(0887) := "010111110101111000"; 
			tw_re(0888) := "010101011111010110"; tw_im(0888) := "010111101101011110"; tw_re(0889) := "010101101000101001"; tw_im(0889) := "010111100101000000"; tw_re(0890) := "010101110001110111"; tw_im(0890) := "010111011100011110"; tw_re(0891) := "010101111011000011"; tw_im(0891) := "010111010011111001"; 
			tw_re(0892) := "010110000100001011"; tw_im(0892) := "010111001011010000"; tw_re(0893) := "010110001101010000"; tw_im(0893) := "010111000010100100"; tw_re(0894) := "010110010110010001"; tw_im(0894) := "010110111001110100"; tw_re(0895) := "010110011111001111"; tw_im(0895) := "010110110001000001"; 
			tw_re(0896) := "010110101000001010"; tw_im(0896) := "010110101000001010"; tw_re(0897) := "010110110001000001"; tw_im(0897) := "010110011111001111"; tw_re(0898) := "010110111001110100"; tw_im(0898) := "010110010110010001"; tw_re(0899) := "010111000010100100"; tw_im(0899) := "010110001101010000"; 
			tw_re(0900) := "010111001011010000"; tw_im(0900) := "010110000100001011"; tw_re(0901) := "010111010011111001"; tw_im(0901) := "010101111011000011"; tw_re(0902) := "010111011100011110"; tw_im(0902) := "010101110001110111"; tw_re(0903) := "010111100101000000"; tw_im(0903) := "010101101000101001"; 
			tw_re(0904) := "010111101101011110"; tw_im(0904) := "010101011111010110"; tw_re(0905) := "010111110101111000"; tw_im(0905) := "010101010110000001"; tw_re(0906) := "010111111110001111"; tw_im(0906) := "010101001100101000"; tw_re(0907) := "011000000110100001"; tw_im(0907) := "010101000011001100"; 
			tw_re(0908) := "011000001110110001"; tw_im(0908) := "010100111001101100"; tw_re(0909) := "011000010110111100"; tw_im(0909) := "010100110000001010"; tw_re(0910) := "011000011111000100"; tw_im(0910) := "010100100110100100"; tw_re(0911) := "011000100111001000"; tw_im(0911) := "010100011100111011"; 
			tw_re(0912) := "011000101111001000"; tw_im(0912) := "010100010011001111"; tw_re(0913) := "011000110111000100"; tw_im(0913) := "010100001001100000"; tw_re(0914) := "011000111110111101"; tw_im(0914) := "010011111111101101"; tw_re(0915) := "011001000110110001"; tw_im(0915) := "010011110101111000"; 
			tw_re(0916) := "011001001110100010"; tw_im(0916) := "010011101011111111"; tw_re(0917) := "011001010110001111"; tw_im(0917) := "010011100010000100"; tw_re(0918) := "011001011101111000"; tw_im(0918) := "010011011000000101"; tw_re(0919) := "011001100101011101"; tw_im(0919) := "010011001110000100"; 
			tw_re(0920) := "011001101100111110"; tw_im(0920) := "010011000011111111"; tw_re(0921) := "011001110100011011"; tw_im(0921) := "010010111001111000"; tw_re(0922) := "011001111011110100"; tw_im(0922) := "010010101111101101"; tw_re(0923) := "011010000011001001"; tw_im(0923) := "010010100101100000"; 
			tw_re(0924) := "011010001010011010"; tw_im(0924) := "010010011011010000"; tw_re(0925) := "011010010001100111"; tw_im(0925) := "010010010000111101"; tw_re(0926) := "011010011000110000"; tw_im(0926) := "010010000110100111"; tw_re(0927) := "011010011111110101"; tw_im(0927) := "010001111100001111"; 
			tw_re(0928) := "011010100110110110"; tw_im(0928) := "010001110001110011"; tw_re(0929) := "011010101101110011"; tw_im(0929) := "010001100111010101"; tw_re(0930) := "011010110100101100"; tw_im(0930) := "010001011100110101"; tw_re(0931) := "011010111011100000"; tw_im(0931) := "010001010010010001"; 
			tw_re(0932) := "011011000010010000"; tw_im(0932) := "010001000111101011"; tw_re(0933) := "011011001000111101"; tw_im(0933) := "010000111101000010"; tw_re(0934) := "011011001111100101"; tw_im(0934) := "010000110010010111"; tw_re(0935) := "011011010110001000"; tw_im(0935) := "010000100111101001"; 
			tw_re(0936) := "011011011100101000"; tw_im(0936) := "010000011100111000"; tw_re(0937) := "011011100011000011"; tw_im(0937) := "010000010010000101"; tw_re(0938) := "011011101001011010"; tw_im(0938) := "010000000111010000"; tw_re(0939) := "011011101111101101"; tw_im(0939) := "001111111100010111"; 
			tw_re(0940) := "011011110101111100"; tw_im(0940) := "001111110001011101"; tw_re(0941) := "011011111100000110"; tw_im(0941) := "001111100110100000"; tw_re(0942) := "011100000010001100"; tw_im(0942) := "001111011011100001"; tw_re(0943) := "011100001000001110"; tw_im(0943) := "001111010000011111"; 
			tw_re(0944) := "011100001110001011"; tw_im(0944) := "001111000101011011"; tw_re(0945) := "011100010100000100"; tw_im(0945) := "001110111010010100"; tw_re(0946) := "011100011001111000"; tw_im(0946) := "001110101111001011"; tw_re(0947) := "011100011111101001"; tw_im(0947) := "001110100100000000"; 
			tw_re(0948) := "011100100101010100"; tw_im(0948) := "001110011000110011"; tw_re(0949) := "011100101010111100"; tw_im(0949) := "001110001101100100"; tw_re(0950) := "011100110000011111"; tw_im(0950) := "001110000010010010"; tw_re(0951) := "011100110101111101"; tw_im(0951) := "001101110110111110"; 
			tw_re(0952) := "011100111011010111"; tw_im(0952) := "001101101011101000"; tw_re(0953) := "011101000000101101"; tw_im(0953) := "001101100000010000"; tw_re(0954) := "011101000101111110"; tw_im(0954) := "001101010100110110"; tw_re(0955) := "011101001011001011"; tw_im(0955) := "001101001001011010"; 
			tw_re(0956) := "011101010000010011"; tw_im(0956) := "001100111101111100"; tw_re(0957) := "011101010101010111"; tw_im(0957) := "001100110010011011"; tw_re(0958) := "011101011010010110"; tw_im(0958) := "001100100110111001"; tw_re(0959) := "011101011111010000"; tw_im(0959) := "001100011011010101"; 
			tw_re(0960) := "011101100100000110"; tw_im(0960) := "001100001111101111"; tw_re(0961) := "011101101000111000"; tw_im(0961) := "001100000100000111"; tw_re(0962) := "011101101101100101"; tw_im(0962) := "001011111000011101"; tw_re(0963) := "011101110010001101"; tw_im(0963) := "001011101100110001"; 
			tw_re(0964) := "011101110110110001"; tw_im(0964) := "001011100001000100"; tw_re(0965) := "011101111011010000"; tw_im(0965) := "001011010101010101"; tw_re(0966) := "011101111111101011"; tw_im(0966) := "001011001001100100"; tw_re(0967) := "011110000100000001"; tw_im(0967) := "001010111101110001"; 
			tw_re(0968) := "011110001000010010"; tw_im(0968) := "001010110001111101"; tw_re(0969) := "011110001100011110"; tw_im(0969) := "001010100110000111"; tw_re(0970) := "011110010000100110"; tw_im(0970) := "001010011010001111"; tw_re(0971) := "011110010100101010"; tw_im(0971) := "001010001110010110"; 
			tw_re(0972) := "011110011000101000"; tw_im(0972) := "001010000010011011"; tw_re(0973) := "011110011100100010"; tw_im(0973) := "001001110110011110"; tw_re(0974) := "011110100000010111"; tw_im(0974) := "001001101010100000"; tw_re(0975) := "011110100100001000"; tw_im(0975) := "001001011110100001"; 
			tw_re(0976) := "011110100111110100"; tw_im(0976) := "001001010010100000"; tw_re(0977) := "011110101011011011"; tw_im(0977) := "001001000110011110"; tw_re(0978) := "011110101110111101"; tw_im(0978) := "001000111010011010"; tw_re(0979) := "011110110010011011"; tw_im(0979) := "001000101110010101"; 
			tw_re(0980) := "011110110101110100"; tw_im(0980) := "001000100010001110"; tw_re(0981) := "011110111001001000"; tw_im(0981) := "001000010110000111"; tw_re(0982) := "011110111100010111"; tw_im(0982) := "001000001001111110"; tw_re(0983) := "011110111111100010"; tw_im(0983) := "000111111101110011"; 
			tw_re(0984) := "011111000010101000"; tw_im(0984) := "000111110001101000"; tw_re(0985) := "011111000101101001"; tw_im(0985) := "000111100101011011"; tw_re(0986) := "011111001000100101"; tw_im(0986) := "000111011001001101"; tw_re(0987) := "011111001011011100"; tw_im(0987) := "000111001100111110"; 
			tw_re(0988) := "011111001110001111"; tw_im(0988) := "000111000000101110"; tw_re(0989) := "011111010000111101"; tw_im(0989) := "000110110100011101"; tw_re(0990) := "011111010011100110"; tw_im(0990) := "000110101000001010"; tw_re(0991) := "011111010110001010"; tw_im(0991) := "000110011011110111"; 
			tw_re(0992) := "011111011000101001"; tw_im(0992) := "000110001111100011"; tw_re(0993) := "011111011011000100"; tw_im(0993) := "000110000011001101"; tw_re(0994) := "011111011101011001"; tw_im(0994) := "000101110110110111"; tw_re(0995) := "011111011111101010"; tw_im(0995) := "000101101010100000"; 
			tw_re(0996) := "011111100001110110"; tw_im(0996) := "000101011110001000"; tw_re(0997) := "011111100011111101"; tw_im(0997) := "000101010001101111"; tw_re(0998) := "011111100101111111"; tw_im(0998) := "000101000101010110"; tw_re(0999) := "011111100111111101"; tw_im(0999) := "000100111000111011"; 
			tw_re(1000) := "011111101001110101"; tw_im(1000) := "000100101100100000"; tw_re(1001) := "011111101011101001"; tw_im(1001) := "000100100000000100"; tw_re(1002) := "011111101101010111"; tw_im(1002) := "000100010011101000"; tw_re(1003) := "011111101111000001"; tw_im(1003) := "000100000111001010"; 
			tw_re(1004) := "011111110000100110"; tw_im(1004) := "000011111010101100"; tw_re(1005) := "011111110010000110"; tw_im(1005) := "000011101110001110"; tw_re(1006) := "011111110011100001"; tw_im(1006) := "000011100001101111"; tw_re(1007) := "011111110100110111"; tw_im(1007) := "000011010101001111"; 
			tw_re(1008) := "011111110110001001"; tw_im(1008) := "000011001000101111"; tw_re(1009) := "011111110111010101"; tw_im(1009) := "000010111100001110"; tw_re(1010) := "011111111000011100"; tw_im(1010) := "000010101111101101"; tw_re(1011) := "011111111001011111"; tw_im(1011) := "000010100011001100"; 
			tw_re(1012) := "011111111010011101"; tw_im(1012) := "000010010110101010"; tw_re(1013) := "011111111011010101"; tw_im(1013) := "000010001010001000"; tw_re(1014) := "011111111100001001"; tw_im(1014) := "000001111101100101"; tw_re(1015) := "011111111100111000"; tw_im(1015) := "000001110001000010"; 
			tw_re(1016) := "011111111101100010"; tw_im(1016) := "000001100100011111"; tw_re(1017) := "011111111110000111"; tw_im(1017) := "000001010111111100"; tw_re(1018) := "011111111110100111"; tw_im(1018) := "000001001011011000"; tw_re(1019) := "011111111111000010"; tw_im(1019) := "000000111110110100"; 
			tw_re(1020) := "011111111111011000"; tw_im(1020) := "000000110010010000"; tw_re(1021) := "011111111111101010"; tw_im(1021) := "000000100101101100"; tw_re(1022) := "011111111111110110"; tw_im(1022) := "000000011001001000"; tw_re(1023) := "011111111111111101"; tw_im(1023) := "000000001100100100"; 
			init('1');
			inited := true;
		else
			IF (((CLK) AND (CE)) = '1') THEN
				IF (RESET = '1') THEN
			    	init('1');   
				ELSE
			    	IF (N_FFT_WE = '1') THEN
						RANKS := IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(N_FFT) + 3;    
						init('0');   
			    	ELSE

					-- Latch in the new scaling schedule, if SCALE_SCH_WE is asserted,
					
					IF (SCALE_SCH_WE = '1') THEN
					  scale_sch_i :=  SCALE_SCH;    
					END IF;
					-- Latch in the FWD_INV signal, if FWD_INV_WE is asserted. FWD_INV = 1 => forward FFT
					
					IF (FWD_INV_WE = '1') THEN
					  inverse := NOT FWD_INV;    
					END IF;
					-- if ready or DONE, and start is asserted, start a new frame
					
					-- otherwise increment system counters, 
			       
					FOR i IN 47 DOWNTO (0 + 1) LOOP
						-- Shift system counter history
					  
						rank(i) := rank(i - 1);    
						n(i) := n(i - 1);    
						rn(i) := rn(i - 1);    
						END LOOP;
					IF (((ready OR DONE_i) AND (START OR starts OR started(0) OR started(1))) = '1') THEN
						ready := '0';    
						rank(0) := "000";    
						rn(0) := "00000000";    
						n(0) := "0000000000";    
						frame := frame + 1;    
						started(2)	<= started(1);
						started(1)	<= started(0);
						started(0)	<= starts OR START;
						starts		<= '0';
					ELSE
						IF ( ((ready OR DONE_i)='0') AND (rn(0)= RNmaxad)) THEN
							rank(0) := rank(0) + '1';    
							rn(0) := (others => '0');    
							n(0) := n(0) + '1';    
						ELSE
							starts <= starts OR START;
							IF ((NOT (ready OR DONE_i)) = '1') THEN
								rn(0) := rn(0) + '1';    
								n(0) := n(0) + '1';    
								END IF;
							END IF;
						END IF;
						
					if (n(1) = 0) then 
						fwd_inv1 <= fwd_inv0;    
						fwd_inv2 <= fwd_inv1;    
						fwd_inv0 <= inverse; 
						end if;

					EDONE_i 	:= TO_STD_LOGIC( n(0) = Nmax - 2);    
					DONE_i  	:= TO_STD_LOGIC((n(0) = Nmax - 1) AND (n(1) = Nmax - 2));    
				
					EDONE 	<= EDONE_i AND started(2);
					DONE  	<= DONE_i AND started(2);
					LDONE  	<= DONE_i AND started(2);
					ready 	:= TO_STD_LOGIC((n(0) = Nmax - 1) AND (n(1) = Nmax - 1));    
					BUSY_i 	:= NOT ready;    
					BUSY	<= BUSY_i AND (START OR starts OR started(0) OR started(1) OR started(2));						
					IF (DONE_i = '1') THEN
					  OVFLO_i := OVFLOW_PE0_d OR OVFLOW_PE1;    
						END IF;

-- load new frame										       
					iBS <=  1 - (in_frame mod 2); 
					in_frame <= frame;
					IF (started0_d='1') THEN
					  dpm_in_re( iBS*1024 + IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(n(2))) := XN_RE;    --  write real part to the input buffer
					  dpm_in_im( iBS*1024 + IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(n(2))) := im_i_inv;    --  write imag part to the input buffer
					END IF;

					IF (started(0)='1') or (started(1)='1') or (started(2)='1') then
						XN_INDEX <= n(0);    
						end if;
					started0_d := started(0);
						
-- PE0 calculations: 			       
				   if (n(10) = 0) then
					    scale_sch2 := scale_sch1;    
						scale_sch1 := scale_sch0;    
						scale_sch0 := scale_sch_i;
						end if;

					   
					IF (rn(15) = 0) THEN
						if (n(15) = 0) then PE0_BS := '0'; ELSE PE0_BS := NOT PE0_BS; end if;
						CASE rank(15) IS
							WHEN "000" => sc_sch0 <= scale_sch1(1 DOWNTO 0);    
							WHEN "001" => sc_sch0 <= scale_sch1(3 DOWNTO 2);    
							WHEN "010" => sc_sch0 <= scale_sch1(5 DOWNTO 4);    
							WHEN "011" => sc_sch0 <= scale_sch1(7 DOWNTO 6);    
							WHEN "100" => sc_sch0 <= scale_sch1(9 DOWNTO 8);    
							WHEN OTHERS => NULL;
							END CASE;
						END IF;
					IF ( IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(rn(15)) < RNmax) THEN
						i := IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(rank(15));    
						case (RANKS-i) IS
							WHEN 1 => d := 1;
							WHEN 2 => d := 4;
							WHEN 3 => d := 16;
							WHEN 4 => d := 64;
							WHEN OTHERS => d := 256;
							end case;
			        	-- Set up input and output addresses						
			          
						k := IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(rn(15));    
						PE0_rd_addr(0) := CONV_STD_LOGIC_VECTOR( (( k mod d) + (k / d) * (d *4)), 10);
						PE0_rd_addr(1) := PE0_rd_addr(0) + CONV_STD_LOGIC_VECTOR(d, 10);  
						PE0_rd_addr(2) := PE0_rd_addr(1) + CONV_STD_LOGIC_VECTOR(d, 10);    
						PE0_rd_addr(3) := PE0_rd_addr(2) + CONV_STD_LOGIC_VECTOR(d, 10);    
						-- Set up the twiddle addresses
						
						tw_step := 256 / d;    
						tw := (k mod d)* tw_step;    
						tw1:= CONV_STD_LOGIC_VECTOR(tw, 10);    
						tw2:= CONV_STD_LOGIC_VECTOR(tw * 2, 10);    
						tw3:= CONV_STD_LOGIC_VECTOR(tw * 3, 10);    
--						tw := tw + tw_step;    
						-- Fetch input opearands
			          
						IF (i = 0)	THEN 
							bank_sel := TO_STD_LOGIC((frame mod 2 = 1));    
							data_i0_PE0(2 * Bi - 1 DOWNTO Bi)	<= dpm_in_re(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(bank_sel & PE0_rd_addr(0)));    
							data_i1_PE0(2 * Bi - 1 DOWNTO Bi)	<= dpm_in_re(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(bank_sel & PE0_rd_addr(1)));    
							data_i2_PE0(2 * Bi - 1 DOWNTO Bi)	<= dpm_in_re(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(bank_sel & PE0_rd_addr(2)));    
							data_i3_PE0(2 * Bi - 1 DOWNTO Bi)	<= dpm_in_re(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(bank_sel & PE0_rd_addr(3)));    
							data_i0_PE0(Bi - 1 DOWNTO 0) 		<= dpm_in_im(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(bank_sel & PE0_rd_addr(0)));    
							data_i1_PE0(Bi - 1 DOWNTO 0)		<= dpm_in_im(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(bank_sel & PE0_rd_addr(1)));       
							data_i2_PE0(Bi - 1 DOWNTO 0)		<= dpm_in_im(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(bank_sel & PE0_rd_addr(2)));    
							data_i3_PE0(Bi - 1 DOWNTO 0)		<= dpm_in_im(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(bank_sel & PE0_rd_addr(3)));        										
					  	else 
							bank_sel := PE0_BS;
							data_i0_PE0(2 * Bi - 1 DOWNTO Bi)	<= dpm_PE0_re(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(bank_sel & PE0_rd_addr(0)));    
							data_i1_PE0(2 * Bi - 1 DOWNTO Bi)	<= dpm_PE0_re(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(bank_sel & PE0_rd_addr(1)));    
							data_i2_PE0(2 * Bi - 1 DOWNTO Bi)	<= dpm_PE0_re(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(bank_sel & PE0_rd_addr(2)));    
							data_i3_PE0(2 * Bi - 1 DOWNTO Bi)	<= dpm_PE0_re(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(bank_sel & PE0_rd_addr(3)));    
							data_i0_PE0(Bi - 1 DOWNTO 0) 		<= dpm_PE0_im(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(bank_sel & PE0_rd_addr(0)));    
							data_i1_PE0(Bi - 1 DOWNTO 0)		<= dpm_PE0_im(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(bank_sel & PE0_rd_addr(1)));       
							data_i2_PE0(Bi - 1 DOWNTO 0)		<= dpm_PE0_im(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(bank_sel & PE0_rd_addr(2)));    
							data_i3_PE0(Bi - 1 DOWNTO 0)		<= dpm_PE0_im(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(bank_sel & PE0_rd_addr(3)));        																	
						  	end if;
						
						END IF;
			       -- Write output results
			       
			       IF ( IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(rn(15+1)) < RNmax) THEN
						i := IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(rank(15+1));    
			          	IF ( i < RANKS - 2) THEN
							dpm_PE0_im(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER( (NOT PE0_BSd) & PE0_wr_addr(0) )) := data_o0_PE0(Bi - 1 DOWNTO 0);    
							dpm_PE0_im(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER( (NOT PE0_BSd) & PE0_wr_addr(1) )) := data_o1_PE0(Bi - 1 DOWNTO 0);    
							dpm_PE0_im(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER( (NOT PE0_BSd) & PE0_wr_addr(2) )) := data_o2_PE0(Bi - 1 DOWNTO 0);    
							dpm_PE0_im(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER( (NOT PE0_BSd) & PE0_wr_addr(3) )) := data_o3_PE0(Bi - 1 DOWNTO 0);    
							dpm_PE0_re(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER( (NOT PE0_BSd) & PE0_wr_addr(0) )) := data_o0_PE0(2 * Bi - 1 DOWNTO Bi);    
							dpm_PE0_re(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER( (NOT PE0_BSd) & PE0_wr_addr(1) )) := data_o1_PE0(2 * Bi - 1 DOWNTO Bi);    
							dpm_PE0_re(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER( (NOT PE0_BSd) & PE0_wr_addr(2) )) := data_o2_PE0(2 * Bi - 1 DOWNTO Bi);    
							dpm_PE0_re(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER( (NOT PE0_BSd) & PE0_wr_addr(3) )) := data_o3_PE0(2 * Bi - 1 DOWNTO Bi);    
			          ELSE
							dpm_PE1_im(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(PE0_wr_addr(0))) := data_o0_PE0(Bi - 1 DOWNTO 0);    
							dpm_PE1_im(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(PE0_wr_addr(1))) := data_o1_PE0(Bi - 1 DOWNTO 0);    
							dpm_PE1_im(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(PE0_wr_addr(2))) := data_o2_PE0(Bi - 1 DOWNTO 0);    
							dpm_PE1_im(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(PE0_wr_addr(3))) := data_o3_PE0(Bi - 1 DOWNTO 0);    
							dpm_PE1_re(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(PE0_wr_addr(0))) := data_o0_PE0(2 * Bi - 1 DOWNTO Bi);    
							dpm_PE1_re(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(PE0_wr_addr(1))) := data_o1_PE0(2 * Bi - 1 DOWNTO Bi);    
							dpm_PE1_re(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(PE0_wr_addr(2))) := data_o2_PE0(2 * Bi - 1 DOWNTO Bi);    
							dpm_PE1_re(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(PE0_wr_addr(3))) := data_o3_PE0(2 * Bi - 1 DOWNTO Bi);    
			          END IF;
			          -- Keep track of overflows
			          
			          IF (n(15 + 1) = 0) THEN
			             OVFLOW_PE0_d := OVFLOW_PE0; 
			             OVFLOW_PE0 := OVFLO0;    
			          ELSE
			             OVFLOW_PE0 := OVFLOW_PE0 OR OVFLO0;    
			          END IF;
			       END IF;
			    END IF;
			 END IF;
			 -- PE1 calculations: 						

			 i := IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(n(9));					  
			 IF ((i > 31) AND (i < 32 + RNmax)) THEN
				CASE RANKS IS
					WHEN 3 		=> sc_sch1 <= scale_sch2(5 DOWNTO 4);    
					WHEN 4 		=> sc_sch1 <= scale_sch2(7 DOWNTO 6);    
					WHEN OTHERS	=> sc_sch1 <= scale_sch2(9 DOWNTO 8);    
					END CASE;
			    k := (IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(rn(9)) -32) *4 ;    
			    PE1_BS := TO_STD_LOGIC((frame mod 2) = 1);    
			    out_frame := frame;    
			    -- Set up input and output addresses						
			    
			    PE1_rd_addr(0) := CONV_STD_LOGIC_VECTOR(k, 10);    
			    PE1_rd_addr(1) := CONV_STD_LOGIC_VECTOR(k+1, 10);    
			    PE1_rd_addr(2) := CONV_STD_LOGIC_VECTOR(k+2, 10);    
			    PE1_rd_addr(3) := CONV_STD_LOGIC_VECTOR(k+3, 10);    
			    -- Fetch input opearands

				data_i0_PE1(2 * Bi - 1 DOWNTO Bi)	<= dpm_PE1_re(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(PE1_rd_addr(0)));    
				data_i1_PE1(2 * Bi - 1 DOWNTO Bi)	<= dpm_PE1_re(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(PE1_rd_addr(1)));    
				data_i2_PE1(2 * Bi - 1 DOWNTO Bi)	<= dpm_PE1_re(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(PE1_rd_addr(2)));    
				data_i3_PE1(2 * Bi - 1 DOWNTO Bi)	<= dpm_PE1_re(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(PE1_rd_addr(3)));    
				data_i0_PE1(Bi - 1 DOWNTO 0) 		<= dpm_PE1_im(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(PE1_rd_addr(0)));    
				data_i1_PE1(Bi - 1 DOWNTO 0)		<= dpm_PE1_im(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(PE1_rd_addr(1)));       
				data_i2_PE1(Bi - 1 DOWNTO 0)		<= dpm_PE1_im(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(PE1_rd_addr(2)));    
				data_i3_PE1(Bi - 1 DOWNTO 0)		<= dpm_PE1_im(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(PE1_rd_addr(3)));        
			 END IF;
			 -- Write output results

			IF (( i > 32) AND (i < 33 + RNmax)) THEN
				
				dpm_out_im(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER( PE1_BS & PE1_wr_addr(0) )) := data_o0_PE1_inv;    
				dpm_out_im(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER( PE1_BS & PE1_wr_addr(1) )) := data_o1_PE1_inv;
				dpm_out_im(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER( PE1_BS & PE1_wr_addr(2) )) := data_o2_PE1_inv;
				dpm_out_im(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER( PE1_BS & PE1_wr_addr(3) )) := data_o3_PE1_inv;
				dpm_out_re(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER( PE1_BS & PE1_wr_addr(0) )) := data_o0_PE1(2 * Bi - 1 DOWNTO Bi);    
				dpm_out_re(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER( PE1_BS & PE1_wr_addr(1) )) := data_o1_PE1(2 * Bi - 1 DOWNTO Bi);    
				dpm_out_re(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER( PE1_BS & PE1_wr_addr(2) )) := data_o2_PE1(2 * Bi - 1 DOWNTO Bi);    
				dpm_out_re(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER( PE1_BS & PE1_wr_addr(3) )) := data_o3_PE1(2 * Bi - 1 DOWNTO Bi);    

			    -- Keep track of overflows			    
			    OVFLOW_PE1 := OVFLO1 OR (TO_STD_LOGIC(i /= 33) AND OVFLOW_PE1);    
			END IF;
			FOR i IN 0 TO (4 - 1) LOOP
				PE0_wr_addr(i) := PE0_rd_addr(i);    
				PE1_wr_addr(i) := PE1_rd_addr(i);  
			END LOOP;
			PE0_BSd := PE0_BS;    
			-- Write output, if MRD was asserted

			XK_INDEX_i := CONV_STD_LOGIC_VECTOR(XK_INDEX1,10);    				
			IF (MRD_locked2 = '1') THEN XK_INDEX1 := XK_INDEX1 + 1; END IF;
			
			if (MRD_locked2) = '1' then temp := (XK_INDEX1 = Nmax);
								ELSE temp := (MRD_locked1 = '1');
			 					end if;
			
			-- Latch in operands, if MWR is/was active, and frame is not ready yet	
			 
			IF (MRD_locked2 = '1') THEN
				get_rev_addr(rev_addr);   
				XK_RE <= dpm_out_re(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(oBS & rev_addr));    --  write real part from the output buffer     
				XK_IM <= dpm_out_im(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(oBS & rev_addr));    --  write imag part from the output buffer
				END IF;

			IF (temp) THEN
				oBS := TO_STD_LOGIC(out_frame mod 2 =  1);    
				XK_INDEX1 := 0;    
				END IF;
			
			OVFLO <= OVFLO_i;
			RDY <= MRD_locked2;    
			MRD_locked3 := MRD_locked2;    			 
			MRD_locked2 := MRD_locked1;    
			MRD_locked1 := MRD_locked0;    
			MRD_locked0 := (MRD_locked0 AND TO_STD_LOGIC(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(XK_INDEX_i) /= Nmax - 3)) OR MRD;    
			END IF;
		end if;
		XK_INDEX <= XK_INDEX_i;
		tw1_re	 <= tw_re(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(tw1));
		tw1_im	 <= tw_im(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(tw1));
		tw2_re	 <= tw_re(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(tw2));
		tw2_im	 <= tw_im(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(tw2));
		tw3_re	 <= tw_re(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(tw3));
		tw3_im	 <= tw_im(IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER(tw3));
   END PROCESS;

END behav_VHDL;
