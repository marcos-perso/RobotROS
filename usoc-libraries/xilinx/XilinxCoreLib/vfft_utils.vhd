-------------------------------------------------------------------------------
-- $Id: vfft_utils.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
-------------------------------------------------------------------------------
--
-- vfft_utils dummy package - for Virtex vfft v1.0 FFT VHDL
-- Behavioral Model
--
-------------------------------------------------------------------------------
-- This is a dummy package to force get_models to generate
-- the correct compile order for the Virtex v1.0 family of
-- FFTs. All of the Virtex FFT behv models reference this package.

library ieee;
use ieee.std_logic_1164.all;

package vfft_utils is

end vfft_utils;


-- Module Name		xdsp_cnt10
-- Synopsis		behv. model of10b counter
-- Author 		Dr Chris Dick
-- Creation Date: 	11/21/99
-- Comments: 		
-- Modification History

-- ************************************************************************
--  Copyright 1996-1998 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;
	
library xilinxcorelib;
	use xilinxcorelib.ul_utils.all;

entity xdsp_cnt10 is
  port( clk 	: in  std_logic;
        ce 	: in  std_logic;
        sclr 	: IN  std_logic;        
        q 	: out std_logic_vector(9 downto 0));
end xdsp_cnt10;

architecture behv of xdsp_cnt10 is
constant w: integer := 10;

	signal	cntr		: std_logic_vector(w-1 downto 0);
begin
	
process(clk,sclr,ce)
begin
	if clk'event and clk = '1' then
	    if sclr = '1' then
		cntr <= (others => '0');
	    elsif ce = '1' then
		cntr <= cntr + 1;
	    end if;
	end if;
end process;

	q <= cntr;
	
end behv;

-- Module Name		xdsp_cnt11
-- Synopsis		behv. model of11b counter
-- Author 		Dr Chris Dick
-- Creation Date: 	11/21/99
-- Comments: 		
-- Modification History

-- ************************************************************************
--  Copyright 1996-1998 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;
	
library xilinxcorelib;
use xilinxcorelib.ul_utils.all;

entity xdsp_cnt11 is
  port( clk 	: in  std_logic;
        ce 	: in  std_logic;
        sclr 	: IN  std_logic;        
        q 	: out std_logic_vector(10 downto 0));
end xdsp_cnt11;

architecture behv of xdsp_cnt11 is
constant w: integer := 11;

	signal	cntr		: std_logic_vector(w-1 downto 0);
begin
	
process(clk,sclr,ce)
begin
	if clk'event and clk = '1' then
	    if sclr = '1' then
		cntr <= (others => '0');
	    elsif ce = '1' then
		cntr <= cntr + 1;
	    end if;
	end if;
end process;

	q <= cntr;
	
end behv;

-- Module Name		xdsp_cnt12
-- Synopsis		behv. model of10b counter
-- Author 		Dr Chris Dick
-- Creation Date: 	02/18/2001
-- Comments: 		
-- Modification History

-- ************************************************************************
--  Copyright 1996-1998 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;
	
library xilinxcorelib;
	use xilinxcorelib.ul_utils.all;

entity xdsp_cnt12 is
  port( clk 	: in  std_logic;
        ce 		: in  std_logic;
        sclr 	: IN  std_logic;        
        q 		: out std_logic_vector(11 downto 0));
end xdsp_cnt12;

architecture behv of xdsp_cnt12 is
constant w: integer := 12;

	signal	cntr		: std_logic_vector(w-1 downto 0);
begin
	
process(clk,sclr,ce)
begin
	if clk'event and clk = '1' then
	    if sclr = '1' then
			cntr <= (others => '0');
	    elsif ce = '1' then
			cntr <= cntr + 1;
	    end if;
	end if;
end process;

	q <= cntr;
	
end behv;

-- Module Name		rsub16
-- Synopsis		behv. model of baseblox 2b counter
-- Author 		Dr Chris Dick
-- Creation Date: 	11/20/99
-- Comments: 		
-- Modification History

-- ************************************************************************
--  Copyright 1996-1998 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;
	
library xilinxcorelib;
	use xilinxcorelib.ul_utils.all;

entity xdsp_cnt2 IS
  port( clk 	: in  std_logic;
        ce 	: in  std_logic;
        sclr 	: IN  std_logic;        
        q 	: out std_logic_vector(1 downto 0) := (others => '0'));
end xdsp_cnt2;

architecture behv of xdsp_cnt2 is
constant w: integer := 2;

	signal	cntr		: std_logic_vector(w-1 downto 0) := ( others => '0' );
begin
	
process(clk,sclr,ce)
begin
	if sclr = '1' then
		cntr <= (others => '0');
	elsif clk'event and clk = '1' then
		if ce = '1' then
			cntr <= cntr + 1;	
		end if;
	end if;
end process;

	q <= cntr;
	
end behv;

-- Module Name		rsub16
-- Synopsis		behv. model of baseblox 5b counter
-- Author 		Dr Chris Dick
-- Creation Date: 	11/20/99
-- Comments: 		
-- Modification History

-- ************************************************************************
--  Copyright 1996-1998 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;
	
library xilinxcorelib;
	use xilinxcorelib.ul_utils.all;

entity xdsp_cnt4 IS
  port( clk 	: in  std_logic;
        ce 	: in  std_logic;
        sclr 	: IN  std_logic;        
        q 	: out std_logic_vector(3 downto 0) := (others => '0'));
end xdsp_cnt4;

architecture behv of xdsp_cnt4 is
constant w: integer := 4;

	signal	cntr		: std_logic_vector(w-1 downto 0);
begin
	
process(clk,sclr,ce)
begin
	if sclr = '1' then
		cntr <= (others => '0');
	elsif clk'event and clk = '1' then
		if ce = '1' then
			cntr <= cntr + 1;	
		end if;
	end if;
end process;

	q <= cntr;
	
end behv;

-- Module Name		rsub16
-- Synopsis		behv. model of baseblox 5b counter
-- Author 		Dr Chris Dick
-- Creation Date: 	11/20/99
-- Comments: 		
-- Modification History

-- ************************************************************************
--  Copyright 1996-1998 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;
	
library xilinxcorelib;
	use xilinxcorelib.ul_utils.all;

entity xdsp_cnt5 IS
  port( clk 	: in  std_logic;
        ce 	: in  std_logic;
        sclr 	: IN  std_logic;        
        q 	: out std_logic_vector(4 downto 0) := (others => '0'));
end xdsp_cnt5;

architecture behv of xdsp_cnt5 is
constant w: integer := 5;

	signal	cntr		: std_logic_vector(w-1 downto 0) := ( others => '0' );
begin
	
process(clk,sclr,ce)
begin
	if sclr = '1' then
		cntr <= (others => '0');
	elsif clk'event and clk = '1' then
		if ce = '1' then
			cntr <= cntr + 1;	
		end if;
	end if;
end process;

	q <= cntr;
	
end behv;

-- Module Name		xdsp_cnt8
-- Synopsis		behv. model of baseblox 8b counter
-- Author 		Dr Chris Dick
-- Creation Date: 	11/21/99
-- Comments: 		
-- Modification History

-- ************************************************************************
--  Copyright 1996-1998 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;
	
library xilinxcorelib;
	use xilinxcorelib.ul_utils.all;	

entity xdsp_cnt8 is
  port( clk 	: in  std_logic;
        ce 	: in  std_logic;
        sclr 	: IN  std_logic;        
        q 	: out std_logic_vector(7 downto 0));
end xdsp_cnt8;

architecture behv of xdsp_cnt8 is
constant w: integer := 8;

	signal	cntr		: std_logic_vector(w-1 downto 0);
begin
	
process(clk,sclr,ce)
begin
	if clk'event and clk = '1' then
	    if sclr = '1' then
		cntr <= (others => '0');
	    elsif ce = '1' then
		cntr <= cntr + 1;
	    end if;
	end if;
end process;

	q <= cntr;
	
end behv;

-- Module Name		xdsp_cnt9
-- Synopsis		behv. model of baseblox 9b counter
-- Author 		Dr Chris Dick
-- Creation Date: 	11/21/99
-- Comments: 		
-- Modification History

-- ************************************************************************
--  Copyright 1996-1998 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;
	
library xilinxcorelib;
	use xilinxcorelib.ul_utils.all;

entity  xdsp_cnt9 IS
  port( clk 	: in  std_logic;
        ce 	: in  std_logic;
        sclr 	: IN  std_logic;        
        q 	: out std_logic_vector(8 downto 0));
end xdsp_cnt9;

architecture behv of xdsp_cnt9 is
constant w: integer := 9;

	signal	cntr		: std_logic_vector(w-1 downto 0);
begin
	
process(clk,sclr,ce)
begin
	if clk'event and clk = '1' then
	    if sclr = '1' then
		cntr <= (others => '0');
	    elsif ce = '1' then
		cntr <= cntr + 1;
	    end if;
	end if;
end process;

	q <= cntr;
	
end behv;

-- output of CoreGen module generator
-- $Header: /local/Projects/CVS/P1/zpu_SoC/sources/xilinx/XilinxCoreLib/vfft_utils.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
-- *****************************************************************
--  Copyright 1997-1998 - Xilinx, Inc.
--  All rights reserved.
-- *****************************************************************
--
--  Description:
--    Behaviorial Model for 16 words by xx ROM LUT
--

library ieee;
use ieee.std_logic_1164.all;
--  
library xilinxcorelib;
use xilinxcorelib.ul_utils.all;
--
ENTITY xdsp_cos1024 IS  
  PORT (a	: IN STD_LOGIC_VECTOR(8-1 DOWNTO 0);
        clk	: IN STD_LOGIC;
        qspo_ce	: IN STD_LOGIC := default_fdce_ce;
        --clr	: IN STD_LOGIC := default_fdce_clr;
        qspo	: OUT STD_LOGIC_VECTOR(15-1 DOWNTO 0));
END xdsp_cos1024;
--
--  behavior describing a parameterized ROM
ARCHITECTURE behv OF xdsp_cos1024 IS
--
CONSTANT width: INTEGER := 15;
CONSTANT depth: INTEGER := 256;
CONSTANT adrwid: INTEGER := 8;
CONSTANT usetbufrlocs: BOOLEAN := false;
CONSTANT rloc_x: rloctype := default_rloc;
CONSTANT rloc_y: rloctype := default_rloc;
CONSTANT userpm: rpmflagtype := yes_rpm;
CONSTANT huset : husettype := default_huset;
CONSTANT memdata: memdatatype(0 TO 255) := 
            (0,
            1,
            2,
            6,
            10,
            15,
            22,
            30,
            39,
            50,
            62,
            75,
            89,
            104,
            121,
            139,
            158,
            178,
            200,
            222,
            246,
            272,
            298,
            326,
            355,
            385,
            416,
            449,
            482,
            517,
            554,
            591,
            630,
            669,
            710,
            753,
            796,
            841,
            887,
            934,
            982,
            1031,
            1082,
            1134,
            1187,
            1241,
            1297,
            1353,
            1411,
            1470,
            1530,
            1591,
            1654,
            1718,
            1782,
            1848,
            1915,
            1984,
            2053,
            2124,
            2196,
            2269,
            2343,
            2418,
            2494,
            2572,
            2650,
            2730,
            2811,
            2893,
            2976,
            3061,
            3146,
            3233,
            3320,
            3409,
            3499,
            3590,
            3682,
            3775,
            3869,
            3965,
            4061,
            4158,
            4257,
            4357,
            4457,
            4559,
            4662,
            4766,
            4871,
            4977,
            5084,
            5192,
            5301,
            5411,
            5522,
            5635,
            5748,
            5862,
            5977,
            6094,
            6211,
            6329,
            6448,
            6569,
            6690,
            6812,
            6935,
            7060,
            7185,
            7311,
            7438,
            7566,
            7695,
            7825,
            7956,
            8088,
            8220,
            8354,
            8489,
            8624,
            8760,
            8898,
            9036,
            9175,
            9315,
            9456,
            9598,
            9740,
            9884,
            10028,
            10173,
            10319,
            10466,
            10614,
            10762,
            10912,
            11062,
            11213,
            11365,
            11517,
            11671,
            11825,
            11980,
            12136,
            12293,
            12450,
            12608,
            12767,
            12927,
            13087,
            13248,
            13410,
            13573,
            13736,
            13900,
            14065,
            14230,
            14396,
            14563,
            14731,
            14899,
            15068,
            15237,
            15407,
            15578,
            15750,
            15922,
            16095,
            16268,
            16442,
            16617,
            16792,
            16968,
            17144,
            17321,
            17499,
            17677,
            17856,
            18035,
            18215,
            18395,
            18576,
            18758,
            18940,
            19122,
            19305,
            19489,
            19673,
            19858,
            20043,
            20228,
            20414,
            20601,
            20788,
            20975,
            21163,
            21351,
            21540,
            21729,
            21918,
            22108,
            22299,
            22489,
            22680,
            22872,
            23064,
            23256,
            23449,
            23641,
            23835,
            24028,
            24222,
            24417,
            24611,
            24806,
            25001,
            25197,
            25392,
            25588,
            25785,
            25981,
            26178,
            26375,
            26573,
            26770,
            26968,
            27166,
            27364,
            27563,
            27761,
            27960,
            28159,
            28358,
            28557,
            28757,
            28956,
            29156,
            29356,
            29556,
            29756,
            29957,
            30157,
            30357,
            30558,
            30759,
            30959,
            31160,
            31361,
            31562,
            31763,
            31964,
            32165,
            32366,
            32567);
--
BEGIN
-- 
 PROCESS (clk,qspo_ce)
 variable	clr : std_logic := '0'; 
 BEGIN
   IF (rat(clr) = 'X') THEN
     qspo <= setallX(width);
   ELSIF (rat(clr) = '1') THEN
     qspo <= setall0(width);
   ELSIF (rat(clk) = 'X' AND rat(clk'LAST_VALUE) /= 'X' AND rat(qspo_ce) /= '0') THEN
     qspo <= setallX(width);
   ELSIF (clk'EVENT and rat(clk) = '1' AND rat(clk'LAST_VALUE) = '0') THEN
     IF (rat(qspo_ce) = 'X') THEN
       qspo <= setallX(width);
     ELSIF (rat(qspo_ce) = '1') THEN
       IF (anyX(a)) THEN
         qspo <= setallX(width);
       ELSE
         qspo <= int_2_std_logic_vector(memdata(std_logic_vector_2_posint(a)), width);
       END IF;
     END IF;
   END IF;
 END PROCESS;
END behv;
-- output of CoreGen module generator
-- $Header: /local/Projects/CVS/P1/zpu_SoC/sources/xilinx/XilinxCoreLib/vfft_utils.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
-- *****************************************************************
--  Copyright 1997-1998 - Xilinx, Inc.
--  All rights reserved.
-- *****************************************************************
--
--  Description:
--    Behaviorial Model for 16 words by xx ROM LUT
--

library ieee;
use ieee.std_logic_1164.all;
--  
library xilinxcorelib;
use xilinxcorelib.ul_utils.all;
--
ENTITY xdsp_cos256 IS  
  PORT (a	: IN STD_LOGIC_VECTOR(6-1 DOWNTO 0);
        clk	: IN STD_LOGIC;
        qspo_ce	: IN STD_LOGIC := default_fdce_ce;
        qspo	: OUT STD_LOGIC_VECTOR(15-1 DOWNTO 0));
END xdsp_cos256;
--
--  behavior describing a parameterized ROM
ARCHITECTURE behv OF xdsp_cos256 IS
--
CONSTANT width: INTEGER := 15;
CONSTANT depth: INTEGER := 64;
CONSTANT adrwid: INTEGER := 6;
CONSTANT usetbufrlocs: BOOLEAN := false;
CONSTANT rloc_x: rloctype := default_rloc;
CONSTANT rloc_y: rloctype := default_rloc;
CONSTANT userpm: rpmflagtype := yes_rpm;
CONSTANT huset : husettype := default_huset;
CONSTANT memdata: memdatatype(0 TO 255) := 
            (0,
            10,
            39,
            89,
            158,
            246,
            355,
            482,
            630,
            796,
            982,
            1187,
            1411,
            1654,
            1915,
            2196,
            2494,
            2811,
            3146,
            3499,
            3869,
            4257,
            4662,
            5084,
            5522,
            5977,
            6448,
            6935,
            7438,
            7956,
            8489,
            9036,
            9598,
            10173,
            10762,
            11365,
            11980,
            12608,
            13248,
            13900,
            14563,
            15237,
            15922,
            16617,
            17321,
            18035,
            18758,
            19489,
            20228,
            20975,
            21729,
            22489,
            23256,
            24028,
            24806,
            25588,
            26375,
            27166,
            27960,
            28757,
            29556,
            30357,
            31160,
            31964,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0);
--
BEGIN
-- 
 PROCESS (clk)
 variable	clr : std_logic := '0'; 
 BEGIN
   IF (rat(clr) = 'X') THEN
     qspo <= setallX(width);
   ELSIF (rat(clr) = '1') THEN
     qspo <= setall0(width);
   ELSIF (rat(clk) = 'X' AND rat(clk'LAST_VALUE) /= 'X' AND rat(qspo_ce) /= '0') THEN
     qspo <= setallX(width);
   ELSIF (clk'EVENT and rat(clk) = '1' AND rat(clk'LAST_VALUE) = '0') THEN
     IF (rat(qspo_ce) = 'X') THEN
       qspo <= setallX(width);
     ELSIF (rat(qspo_ce) = '1') THEN
       IF (anyX(a)) THEN
         qspo <= setallX(width);
       ELSE
         qspo <= int_2_std_logic_vector(memdata(std_logic_vector_2_posint(a)), width);
       END IF;
     END IF;
   END IF;
 END PROCESS;
END behv;
-- Module Name		cos64
-- Synopsis		behv. model of baseblox ROM
-- Author 		Dr Chris Dick
-- Creation Date: 	4/24/99
-- Comments: 		design based on behv model from Coregen v1.5
-- Modification History

-- ************************************************************************
--  Copyright 1996-1999 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************



library ieee;
use ieee.std_logic_1164.all;
--  
library xilinxcorelib;
	use xilinxcorelib.ul_utils.all;
--
ENTITY xdsp_cos64 IS  
  PORT (a	: IN STD_LOGIC_VECTOR(4-1 DOWNTO 0);
        rclk	: IN STD_LOGIC;
        rd_ce	: IN STD_LOGIC := default_fdce_ce;
        --clr	: IN STD_LOGIC := default_fdce_clr;
        qspo	: OUT STD_LOGIC_VECTOR(15-1 DOWNTO 0));
END xdsp_cos64;
--
--  behavior describing a parameterized ROM
ARCHITECTURE behv OF xdsp_cos64 IS
--
CONSTANT width: INTEGER := 15;
CONSTANT depth: INTEGER := 16;
CONSTANT adrwid: INTEGER := 4;
CONSTANT usetbufrlocs: BOOLEAN := false;
CONSTANT rloc_x: rloctype := default_rloc;
CONSTANT rloc_y: rloctype := default_rloc;
CONSTANT userpm: rpmflagtype := yes_rpm;
CONSTANT huset : husettype := default_huset;
CONSTANT memdata: memdatatype(0 TO 255) := 
            (0,
            158,
            630,
            1411,
            2494,
            3869,
            5522,
            7438,
            9598,
            11980,
            14563,
            17321,
            20228,
            23256,
            26375,
            29556,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0);
--
BEGIN
-- 
 PROCESS (rclk)
 variable	clr : std_logic := '0';
 BEGIN
   IF (rat(clr) = 'X') THEN
     qspo <= setallX(width);
   ELSIF (rat(clr) = '1') THEN
     qspo <= setall0(width);
   ELSIF (rat(rclk) = 'X' AND rat(rclk'LAST_VALUE) /= 'X' AND rat(rd_ce) /= '0') THEN
     qspo <= setallX(width);
   ELSIF (rclk'EVENT and rat(rclk) = '1' AND rat(rclk'LAST_VALUE) = '0') THEN
     IF (rat(rd_ce) = 'X') THEN
       qspo <= setallX(width);
     ELSIF (rat(rd_ce) = '1') THEN
       IF (anyX(a)) THEN
         qspo <= setallX(width);
       ELSE
         qspo <= int_2_std_logic_vector(memdata(std_logic_vector_2_posint(a)), width);
       END IF;
     END IF;
   END IF;
 END PROCESS;
END behv;
-- Module Name		coss16
-- Synopsis		behv. model of baseblox ROM
-- Author 		Dr Chris Dick
-- Creation Date: 	4/23/99
-- Comments: 		design based on behv model from Coregen v1.5
-- Modification History

-- ************************************************************************
--  Copyright 1996-1999 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************


library ieee;
use ieee.std_logic_1164.all;
--  
library xilinxcorelib;
use xilinxcorelib.ul_utils.all;
--
ENTITY xdsp_coss16 IS  
  PORT (a	: IN STD_LOGIC_VECTOR(4-1 DOWNTO 0);
        clk	: IN STD_LOGIC;
        qspo_ce	: IN STD_LOGIC := default_fdce_ce;
        --clr	: IN STD_LOGIC := default_fdce_clr;
        qspo	: OUT STD_LOGIC_VECTOR(16-1 DOWNTO 0) := (others => '0'));
END xdsp_coss16;
--
--  behavior describing a parameterized ROM
ARCHITECTURE behv OF xdsp_coss16 IS
--
CONSTANT width: INTEGER := 16;
CONSTANT depth: INTEGER := 16;
CONSTANT adrwid: INTEGER := 4;
CONSTANT usetbufrlocs: BOOLEAN := false;
CONSTANT rloc_x: rloctype := default_rloc;
CONSTANT rloc_y: rloctype := default_rloc;
CONSTANT userpm: rpmflagtype := yes_rpm;
CONSTANT huset : husettype := default_huset;
CONSTANT memdata: memdatatype(0 TO 255) := 
            (32768,
            32768,
            32768,
            32768,
            32768,
            30274,
            23170,
            12540,
            32768,
            23170,
            0,
            42366,
            32768,
            12540,
            42366,
            35262,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0);
--
BEGIN
-- 
 PROCESS (clk)
 	variable clr	: std_logic := '0';
 BEGIN
   IF (rat(clr) = 'X') THEN
     qspo <= (others => '0');			--setallX(width);
   ELSIF (rat(clr) = '1') THEN
     qspo <= setall0(width);
   ELSIF (rat(clk) = 'X' AND rat(clk'LAST_VALUE) /= 'X' AND rat(qspo_ce) /= '0') THEN
     qspo <= (others => '0');			--setallX(width);
   ELSIF (clk'EVENT and rat(clk) = '1' AND rat(clk'LAST_VALUE) = '0') THEN
     IF (rat(qspo_ce) = 'X') THEN
       qspo <= (others => '0');			--setallX(width);
     ELSIF (rat(qspo_ce) = '1') THEN
       IF (anyX(a)) THEN
         qspo <= (others => '0');		--setallX(width);
       ELSE
         qspo <= int_2_std_logic_vector(memdata(std_logic_vector_2_posint(a)), width);
       END IF;
     END IF;
   END IF;
 END PROCESS;
END behv;
-- output of CoreGen module generator
-- $Header: /local/Projects/CVS/P1/zpu_SoC/sources/xilinx/XilinxCoreLib/vfft_utils.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
-- ************************************************************************
--  Copyright 1996-1998 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************
--
--  Description:
--    Variable operand multiplier
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library xilinxcorelib;
use xilinxcorelib.ul_utils.all;

entity xdsp_mul16x17 is
  port( a        : in  std_logic_vector( 17 - 1 downto 0 );
        b        : in  std_logic_vector( 16 - 1 downto 0 );
        clk      : in  std_logic;
        ce       : in  std_logic;
        p	 : out std_logic_vector( (17 + 16 -1) downto 0) := (others => '0') );
end xdsp_mul16x17;

architecture behv of xdsp_mul16x17 is
  constant aw : integer := 17;
  constant bw : integer := 16;
  constant signed : boolean := true;

  function level_nums(n: integer) return integer is  
  begin
    case n is
      when 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 => return 4;
      when 5 | 6 | 7 | 8 => return 3;
      when 3 | 4 => return 2;
      when 1 | 2 => return 1;
      when others => assert (false)
          report "The function level_nums recd an invalid param " & int_2_string(n)
                  severity error;
          return 0;
    end case;
  end level_nums;

  function convert_abs_2_two_comp(vect : std_logic_vector)
    return std_logic_vector is

  variable local_vect : std_logic_vector(vect'HIGH downto 0);
  begin

    -- ones complement first
    for i in 0 to vect'high loop
      if (vect(i) = '0') then
        local_vect(i) := '1';
      else
        local_vect(i) := '0';
      end if;
    end loop;
    
    -- add 1 and carry to next hight bit
    for i in 0 to vect'high loop
      if (local_vect(i) = '0') then
        local_vect(i) := '1';
        exit;
      else
        local_vect(i) := '0';

      end if;
    end loop;

    return local_vect;
 
  end convert_abs_2_two_comp ;

type data_array is array(level_nums((bw+1)/2) +1  downto 0) of 
                         std_logic_vector(aw+bw -1 downto 0);

begin

  process
    variable setup      : boolean := TRUE;
    variable va         : std_logic_vector( aw - 1 downto 0 ) := (others => '0');
    variable vb         : std_logic_vector( bw - 1 downto 0 ) := (others => '0');
    variable vprod      : std_logic_vector( aw+bw - 1 downto 0 ) := (others => '0');
    variable cin        : std_logic;
    variable value      : std_logic;
    variable s          : data_array := (others => (others => '0') );
    variable negative   : boolean;
    variable i,j        : integer;
    variable a_value    : integer;
    variable b_value    : integer;
    variable prod_value : integer;
    variable index      : integer;
    variable clk_cycles : integer;

  begin

    clk_cycles := level_nums((bw+1)/2) + 2 ;

    if (setup = TRUE) then
      for i in clk_cycles-1 downto 0 loop
        s(i) := setall0(aw+bw);
      end loop;
      setup := FALSE;


    elsif (rat(clk) = 'X' AND rat(ce) /= '0' AND rat(clk'LAST_VALUE)/='X') then
      for i in clk_cycles-1 downto 0 loop
        s(i) := setallX(aw+bw);
      end loop;

    elsif (clk'event and rat(clk)='1' and rat(clk'last_value)='0') then

      if (rat(ce)='X') then
        vprod := setallX(aw+bw);

      elsif (rat(ce)='1') then
        if (anyX(a) or anyX(b)) then
          vprod := setallX(aw+bw);
        else
          negative := FALSE;
          va := std_logic_vector_2_var(a);
          vb := std_logic_vector_2_var(b);
          if (signed) then
            if ( (va(aw-1) xor vb(bw-1)) = '1' ) then
              negative := TRUE;
            end if ;
            if (va(aw-1) = '1') then
              va := two_comp(va);
            end if ; 
            if (vb(bw-1) = '1') then
              vb := two_comp(vb);
            end if ; 
          end if;
          vprod := setall0(aw+bw);
          if ( aw + bw < 32 ) then
            a_value := std_logic_vector_2_posint(va);
            b_value := std_logic_vector_2_posint(vb);
            prod_value := a_value * b_value; 
            vprod := int_2_std_logic_vector(prod_value,aw+bw);
          else
            for i in 0 to bw -1 loop -- bw width
              if (vb(i) = '1') then
                index := i;
                cin := '0';
                for j in 0 to aw-1 loop  -- add a to prod 
                  value := vprod(index) xor va(j) xor cin; -- sum
                  cin := (vprod(index) and va(j)) or (vprod(index) and cin) or 
                         (va(j) and cin); -- carry
                  vprod(index) := value;
                  index := index + 1;
                end loop;
                vprod(index) := vprod(index) xor cin; -- last carry 
              else
                cin := '0';
              end if;        
            end loop;
          end if;
          if (negative) then
            vprod := convert_abs_2_two_comp(vprod);
          end if;
        end if;

      end if;
      
      if ce = '1' then
          for i in clk_cycles-2 downto 0 loop
              s(i+1) := s(i);
          end loop;
          s(0) := vprod;
      end if;
    end if;

    p <= s(clk_cycles-1);

    wait on clk;

  end process;

end behv;

-- Module Name		mul16x17
-- Synopsis		behv. model of baseblox 16x17b multiplier
-- Author 		Dr Chris Dick
-- Creation Date: 	4/27/99
-- Comments: 		design based on behv model from Coregen v1.5
-- Modification History

-- 16/06/99	Modifed 'mul16x17.vhd' to produce this multiplier
--		with a 4, instead of 5, clk cycle latency. This was done
--		by subtracting 1 from the 'clk_cycles' variable.

-- ************************************************************************
--  Copyright 1996-2000 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library xilinxcorelib;
	use xilinxcorelib.ul_utils.all;

entity xdsp_mul16x17z4 is
  port( a        	: in  std_logic_vector( 17 - 1 downto 0 );
        b        	: in  std_logic_vector( 16 - 1 downto 0 );
        clk       	: in  std_logic;
        ce       	: in  std_logic;
        p     		: out std_logic_vector( (17 + 16 -1) downto 0));
end xdsp_mul16x17z4;

architecture behv of xdsp_mul16x17z4 is
  constant aw : integer := 17;
  constant bw : integer := 16;
  constant signed : boolean := true;

  function level_nums(n: integer) return integer is  
  begin
    case n is
      when 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 => return 4;
      when 5 | 6 | 7 | 8 => return 3;
      when 3 | 4 => return 2;
      when 1 | 2 => return 1;
      when others => assert (false)
          report "The function level_nums recd an invalid param " & int_2_string(n)
                  severity error;
          return 0;
    end case;
  end level_nums;

  function convert_abs_2_two_comp(vect : std_logic_vector)
    return std_logic_vector is

  variable local_vect : std_logic_vector(vect'HIGH downto 0);
  begin

    -- ones complement first
    for i in 0 to vect'high loop
      if (vect(i) = '0') then
        local_vect(i) := '1';
      else
        local_vect(i) := '0';
      end if;
    end loop;
    
    -- add 1 and carry to next hight bit
    for i in 0 to vect'high loop
      if (local_vect(i) = '0') then
        local_vect(i) := '1';
        exit;
      else
        local_vect(i) := '0';

      end if;
    end loop;

    return local_vect;
 
  end convert_abs_2_two_comp ;

type data_array is array(level_nums((bw+1)/2) +1  downto 0) of 
                         std_logic_vector(aw+bw -1 downto 0);

begin

  process
    variable setup      : boolean := TRUE;
    variable va         : std_logic_vector( aw - 1 downto 0 );
    variable vb         : std_logic_vector( bw - 1 downto 0 );
    variable vprod      : std_logic_vector( aw+bw - 1 downto 0 );
    variable cin        : std_logic;
    variable value      : std_logic;
    variable s          : data_array;
    variable negative   : boolean;
    variable i,j        : integer;
    variable a_value    : integer;
    variable b_value    : integer;
    variable prod_value : integer;
    variable index      : integer;
    variable clk_cycles : integer;

  begin

    clk_cycles := level_nums((bw+1)/2) + 2 - 1;		-- '-1' added by chd 16/6/99

    if (setup = TRUE) then
      for i in clk_cycles-1 downto 0 loop
        s(i) := setall0(aw+bw);
      end loop;
      setup := FALSE;


    elsif (rat(clk) = 'X' AND rat(ce) /= '0' AND rat(clk'LAST_VALUE)/='X') then
      for i in clk_cycles-1 downto 0 loop
        s(i) := setallX(aw+bw);
      end loop;

    elsif (clk'event and rat(clk)='1' and rat(clk'last_value)='0') then

      if (rat(ce)='X') then
        vprod := setallX(aw+bw);

      elsif (rat(ce)='1') then
        if (anyX(a) or anyX(b)) then
          vprod := setallX(aw+bw);
        else
          negative := FALSE;
          va := std_logic_vector_2_var(a);
          vb := std_logic_vector_2_var(b);
          if (signed) then
            if ( (va(aw-1) xor vb(bw-1)) = '1' ) then
              negative := TRUE;
            end if ;
            if (va(aw-1) = '1') then
              va := two_comp(va);
            end if ; 
            if (vb(bw-1) = '1') then
              vb := two_comp(vb);
            end if ; 
          end if;
          vprod := setall0(aw+bw);
          if ( aw + bw < 32 ) then
            a_value := std_logic_vector_2_posint(va);
            b_value := std_logic_vector_2_posint(vb);
            prod_value := a_value * b_value; 
            vprod := int_2_std_logic_vector(prod_value,aw+bw);
          else
            for i in 0 to bw -1 loop -- bw width
              if (vb(i) = '1') then
                index := i;
                cin := '0';
                for j in 0 to aw-1 loop  -- add a to prod 
                  value := vprod(index) xor va(j) xor cin; -- sum
                  cin := (vprod(index) and va(j)) or (vprod(index) and cin) or 
                         (va(j) and cin); -- carry
                  vprod(index) := value;
                  index := index + 1;
                end loop;
                vprod(index) := vprod(index) xor cin; -- last carry 
              else
                cin := '0';
              end if;        
            end loop;
          end if;
          if (negative) then
            vprod := convert_abs_2_two_comp(vprod);
          end if;
        end if;

      end if;

      if ce = '1' then
          for i in clk_cycles-2 downto 0 loop
              s(i+1) := s(i);
          end loop;
          s(0) := vprod;
      end if;
      
    end if;

    p <= s(clk_cycles-1);

    wait on clk;

  end process;

end behv;

-- 2:1 1-bit wide multiplexor

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	
entity xdsp_mux2w1 is
	port (
		a		: in std_logic;	-- mux operand inputs
		b		: in std_logic;
		s0		: in std_logic;	-- mux sel
		y		: out std_logic	-- mux output signal
	);
end xdsp_mux2w1;

architecture mux1 of xdsp_mux2w1 is

begin
		y <= a when s0='0' else
		     b;
end mux1;		   
-- Module Name		mux2w16
-- Synopsis		behv. model of baseblox 2:1 16b mux
-- Author 		Dr Chris Dick
-- Creation Date: 	5/3/99
-- Comments: 		design based on behv model from Coregen v1.5
-- Modification History

-- ************************************************************************
--  Copyright 1996-1999 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************                 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

library xilinxcorelib;
use xilinxcorelib.ul_utils.all;

ENTITY xdsp_mux2w16 IS
  PORT( ma	 : IN  std_logic_vector( 16 - 1 DOWNTO 0 );
        mb 	 : IN  std_logic_vector( 16 - 1 DOWNTO 0 );
        sel      : IN  std_logic;
        o 	 : OUT std_logic_vector( 16 - 1 DOWNTO 0 ) );
END xdsp_mux2w16;


ARCHITECTURE behv OF xdsp_mux2w16 IS
CONSTANT w: integer := 16;
BEGIN
 process (ma, mb, sel)
 begin
  case rat(sel) is
    WHEN '0' => o <= ma;
    WHEN '1' => o <= mb;
    WHEN OTHERS => o <= (others => '0');		--setallX(w);
  end case;
 end process;
end behv;
 

-- Module Name		mux2w16
-- Synopsis		behv. model of baseblox registered 2:1 16b mux
-- Author 		Dr Chris Dick
-- Creation Date: 	5/3/99
-- Comments: 		design based on behv model from Coregen v1.5
-- Modification History

-- ************************************************************************
--  Copyright 1996-1999 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************                 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

library xilinxcorelib;
	use xilinxcorelib.ul_utils.all;

ENTITY xdsp_mux2w16r IS
  PORT( ma	 : IN  std_logic_vector( 16 - 1 DOWNTO 0 );
        mb 	 : IN  std_logic_vector( 16 - 1 DOWNTO 0 );
        clk	 : in std_logic;
        ce	 : in std_logic;
        s       : IN  std_logic_vector(0 downto 0);
        q 	 : OUT std_logic_vector( 16 - 1 DOWNTO 0 ) );
END xdsp_mux2w16r;


ARCHITECTURE behv OF xdsp_mux2w16r IS
CONSTANT w: integer := 16;
BEGIN
 process (clk, ma, mb, s)
 begin
 	if clk'event and clk = '1' then
 	    if ce = '1' then
  		case rat(s(0)) is
   			WHEN '0' => q <= ma;
    			WHEN '1' => q <= mb;
    			WHEN OTHERS => q <= setallX(w);
  		end case;
 	    end if;
  	end if;
 end process;
end behv;
 

-- Module Name		mux2w16
-- Synopsis		behv. model of baseblox 2:1 4b mux
-- Author 		Dr Chris Dick
-- Creation Date: 	5/3/99
-- Comments: 		design based on behv model from Coregen v1.5
-- Modification History

-- ************************************************************************
--  Copyright 1996-1999 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************                             

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

library xilinxcorelib;
use xilinxcorelib.ul_utils.all;

ENTITY xdsp_mux2w4 IS
  PORT( ma 	: IN  std_logic_vector( 4 - 1 DOWNTO 0 );
        mb	: IN  std_logic_vector( 4 - 1 DOWNTO 0 );
        sel	: IN  std_logic;
        o	: OUT std_logic_vector( 4 - 1 DOWNTO 0 ) );
END xdsp_mux2w4;


ARCHITECTURE behv OF xdsp_mux2w4 IS
CONSTANT w: integer := 4;
BEGIN
 process (ma, mb, sel)
 begin
  case rat(sel) is
    WHEN '0' => o <= ma;
    WHEN '1' => o <= mb;
    WHEN OTHERS => o <= (others => '0');		--setallX(w);
  end case;
 end process;
end behv;
 

-- Module Name		mux2w16
-- Synopsis		behv. model of baseblox 2:1 4b mux
-- Author 		Dr Chris Dick
-- Creation Date: 	5/3/99
-- Comments: 		design based on behv model from Coregen v1.5
-- Modification History

-- ************************************************************************
--  Copyright 1996-1999 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************                             

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

library xilinxcorelib;
use xilinxcorelib.ul_utils.all;

ENTITY xdsp_mux2w4r IS
  PORT( ma 	: IN  std_logic_vector( 4 - 1 DOWNTO 0 );
        mb	: IN  std_logic_vector( 4 - 1 DOWNTO 0 );
        clk	: in std_logic;
        ce	: in std_logic;
        s	: IN  std_logic_vector(0 downto 0);
        q	: OUT std_logic_vector( 4 - 1 DOWNTO 0 ) );
END xdsp_mux2w4r;


ARCHITECTURE behv OF xdsp_mux2w4r IS
CONSTANT w: integer := 4;
BEGIN
 process (clk, ma, mb, s)
 begin
 	if clk'event and clk = '1' then
 	    if ce = '1' then
  		case rat(s(0)) is
   			WHEN '0' => q <= ma;
    			WHEN '1' => q <= mb;
    			WHEN OTHERS => q <= setallX(w);
  		end case;
 	    end if;
  	end if;
 end process;
end behv;
 

-- 3:1 1-bit wide multiplexor

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	
entity xdsp_mux3w1 is
	port (
		a		: in std_logic;	-- mux operand inputs
		b		: in std_logic;
		c		: in std_logic;
		s0		: in std_logic;	-- mux selects
		s1		: in std_logic;	-- mux selects
		y		: out std_logic	-- mux output signal
	);
end xdsp_mux3w1;

architecture mux1 of xdsp_mux3w1 is

begin

		y <= a when s0='0' and s1='0' else
		     b when s0='1' and s1='0' else
		     c when s0='0' and s1='1' else
		     c;
end mux1;
-- Module Name		mux4w16
-- Synopsis		behv. model of baseblox 4:1 16b mux
-- Author 		Dr Chris Dick
-- Creation Date: 	5/3/99
-- Comments: 		design based on behv model from Coregen v1.5
-- Modification History

-- ************************************************************************
--  Copyright 1996-1999 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************                                              

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

library xilinxcorelib;
	use xilinxcorelib.ul_utils.all;

ENTITY xdsp_mux4w16 IS
  PORT( ma	: IN  std_logic_vector( 16 -1 DOWNTO 0 );
        mb	: IN  std_logic_vector( 16 -1 DOWNTO 0 );
        mc	: IN  std_logic_vector( 16 -1 DOWNTO 0 );
        md	: IN  std_logic_vector( 16 -1 DOWNTO 0 );
        sel	: IN  std_logic_vector(1 downto 0);
        o	: OUT std_logic_vector( 16 -1 DOWNTO 0 ) );
END xdsp_mux4w16;


ARCHITECTURE behv OF xdsp_mux4w16 IS
CONSTANT w: integer := 16;

BEGIN
 process (ma, mb, mc, md,  sel)
 begin
  case rat(sel(1)) is
    WHEN '1' =>
	case rat(sel(0)) is
         WHEN '1' => o <= md;
    	 WHEN '0' => o <= mc;
	 WHEN OTHERS => o <= setallX(w);
        end case;
    WHEN '0' => 
	case rat(sel(0)) is
         WHEN '1' => o <= mb;
    	 WHEN '0' => o <= ma;
	 WHEN OTHERS => o <= setallX(w);
        end case;
    WHEN OTHERS => o <= setallX(w);
  end case;
 end process;
end behv;
 

-- Module Name		mux4w16
-- Synopsis		behv. model of baseblox 4:1 16b mux
-- Author 		Dr Chris Dick
-- Creation Date: 	5/3/99
-- Comments: 		design based on behv model from Coregen v1.5
-- Modification History

-- ************************************************************************
--  Copyright 1996-1999 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************                                              

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

library xilinxcorelib;
use xilinxcorelib.ul_utils.all;

ENTITY xdsp_mux4w16r IS
  PORT( ma	: IN  std_logic_vector( 16 -1 DOWNTO 0 );
        mb	: IN  std_logic_vector( 16 -1 DOWNTO 0 );
        mc	: IN  std_logic_vector( 16 -1 DOWNTO 0 );
        md	: IN  std_logic_vector( 16 -1 DOWNTO 0 );
        clk	: in std_logic;
        ce	: in std_logic;
        s	: IN  std_logic_vector(1 downto 0);
        q	: OUT std_logic_vector( 16 -1 DOWNTO 0 ) := (others => '0'));
END xdsp_mux4w16r;


ARCHITECTURE behv OF xdsp_mux4w16r IS
CONSTANT w: integer := 16;

BEGIN
 process (clk, ce , ma, mb, mc, md,  s)
 begin
 if clk'event and clk = '1' then
     if ce = '1' then
  	case rat(s(1)) is
   	 WHEN '1' =>
		case rat(s(0)) is
         	WHEN '1' => q <= md;
    	 	WHEN '0' => q <= mc;
	 	WHEN OTHERS => q <= (others => '0');		--setallX(w);
        	end case;
    	WHEN '0' => 
		case rat(s(0)) is
         	WHEN '1' => q <= mb;
    	 	WHEN '0' => q <= ma;
	 	WHEN OTHERS => q <= (others => '0');		--setallX(w);
        	end case;
    	WHEN OTHERS => q <= (others => '0');			--setallX(w);
  	end case;
     end if;
 end if;
 end process;
end behv;
 

-- Module Name		radd16
-- Synopsis		behv. model of baseblox 16b adder
-- Author 		Dr Chris Dick
-- Creation Date: 	4/15/99
-- Comments: 		design based on behv model from Coregen v1.5
-- Modification History

-- ************************************************************************
--  Copyright 1996-1998 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library xilinxcorelib;
use xilinxcorelib.ul_utils.all;


ENTITY xdsp_radd16 IS
  PORT( a 	: IN  std_logic_vector( 16 - 1 DOWNTO 0 );
        b 	: IN  std_logic_vector( 16 - 1 DOWNTO 0 );
        clk 	: IN  std_logic;
        ce 	: IN  std_logic;
        c_in 	: IN  std_logic;
        q 	: OUT std_logic_vector( 16 DOWNTO 0 ) := (others => '0') );
END xdsp_radd16;

ARCHITECTURE behv OF xdsp_radd16 IS
CONSTANT w: integer := 16;
CONSTANT signed : boolean := true;

FUNCTION plus (a, b : std_logic_vector;
	       cin: std_logic;
	       width : integer) RETURN std_logic_vector IS
VARIABLE retval : std_logic_vector(width-1 DOWNTO 0);
VARIABLE carry : std_logic := cin;
BEGIN  -- plus
  IF (anyX(a) OR anyX(b) OR rat(cin) = 'X') THEN
      retval := (OTHERS => '0');
  else
      FOR i IN 0 TO width-1 LOOP
	  retval(i) := a(i) XOR b(i) XOR carry;
	  carry := (a(i) AND b(i)) or
		   (a(i) AND carry) or
		   (b(i) AND carry);
      END LOOP;  -- i
  END IF;    
  RETURN retval;
END plus;

BEGIN
 process (clk)
   variable sum : std_logic_vector(w DOWNTO 0) := (OTHERS => '0');
   begin
 
     if (rat(clk) = 'X' AND rat(clk'last_value)/='X' AND rat(ce) /= '0') then
       sum := (OTHERS => '0');
     elsif (clk'event and rat(clk) = '1' and rat(clk'last_value) = '0') then
       if (rat(ce) = 'X') then
         sum := (OTHERS => '0');
       elsif (rat(ce) = '1') then
         if(rat(c_in) = 'X' OR anyX(a) OR anyX(b)) then
           sum := (OTHERS => '0');
         else
           sum := plus(extend(a, w+1, signed), extend(b, w+1, signed), c_in, w+1);
         end if;
       end if;
     end if; 
   q <= sum;
   end process;
end behv;

-- Module Name		radd16
-- Synopsis		behv. model of baseblox 16b adder
-- Author 		Dr Chris Dick
-- Creation Date: 	4/15/99
-- Comments: 		design based on behv model from Coregen v1.5
-- Modification History

-- ************************************************************************
--  Copyright 1996-1998 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library xilinxcorelib;
use xilinxcorelib.ul_utils.all;


ENTITY xdsp_radd16c IS
  PORT( a 	: IN  std_logic_vector( 16 - 1 DOWNTO 0 );
        b 	: IN  std_logic_vector( 16 - 1 DOWNTO 0 );
        clk 	: IN  std_logic;
        ce 	: IN  std_logic;
        c_in 	: IN  std_logic;
        q 	: OUT std_logic_vector( 16 DOWNTO 0 ) := (others => '0') );
END xdsp_radd16c;

ARCHITECTURE behv OF xdsp_radd16c IS
CONSTANT w: integer := 16;
CONSTANT signed : boolean := true;

FUNCTION plus (a, b : std_logic_vector;
	       cin: std_logic;
	       width : integer) RETURN std_logic_vector IS
VARIABLE retval : std_logic_vector(width-1 DOWNTO 0);
VARIABLE carry : std_logic := cin;
BEGIN  -- plus
  IF (anyX(a) OR anyX(b) OR rat(cin) = 'X') THEN
      retval := (OTHERS => '0');
  else
      FOR i IN 0 TO width-1 LOOP
	  retval(i) := a(i) XOR b(i) XOR carry;
	  carry := (a(i) AND b(i)) or
		   (a(i) AND carry) or
		   (b(i) AND carry);
      END LOOP;  -- i
  END IF;    
  RETURN retval;
END plus;

BEGIN
 process (clk)
   variable sum : std_logic_vector(w DOWNTO 0) := (OTHERS => '0');
   begin
 
     if (rat(clk) = 'X' AND rat(clk'last_value)/='X' AND rat(ce) /= '0') then
       sum := (OTHERS => '0');
     elsif (clk'event and rat(clk) = '1' and rat(clk'last_value) = '0') then
       if (rat(ce) = 'X') then
         sum := (OTHERS => '0');
       elsif (rat(ce) = '1') then
         if(rat(c_in) = 'X' OR anyX(a) OR anyX(b)) then
           sum := (OTHERS => '0');
         else
           sum := plus(extend(a, w+1, signed), extend(b, w+1, signed), c_in, w+1);
         end if;
       end if;
     end if; 
   q <= sum;
   end process;
end behv;

-- Module Name		radd17
-- Synopsis		behv. model of baseblox 17b adder
-- Author 		Dr Chris Dick
-- Creation Date: 	4/22/99
-- Comments: 		design based on behv model from Coregen v1.5
-- Modification History

-- ************************************************************************
--  Copyright 1996-1999 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library xilinxcorelib;
use xilinxcorelib.ul_utils.all;


ENTITY xdsp_radd17 IS
  PORT( a : IN  std_logic_vector( 17 - 1 DOWNTO 0 );
        b : IN  std_logic_vector( 17 - 1 DOWNTO 0 );
        clk : IN  std_logic;
        ce : IN  std_logic;
        c_in : IN  std_logic;
        --clr : IN  std_logic;
        q : OUT std_logic_vector( 17 DOWNTO 0 ) := (others => '0')  );
END xdsp_radd17;

ARCHITECTURE behv OF xdsp_radd17 IS
CONSTANT w: integer := 17;
CONSTANT signed : boolean := true;

FUNCTION plus (a, b : std_logic_vector;
	       cin: std_logic;
	       width : integer) RETURN std_logic_vector IS
VARIABLE retval : std_logic_vector(width-1 DOWNTO 0);
VARIABLE carry : std_logic := cin;
BEGIN  -- plus
  IF (anyX(a) OR anyX(b) OR rat(cin) = 'X') THEN
      retval := (OTHERS => 'X');
  else
      FOR i IN 0 TO width-1 LOOP
	  retval(i) := a(i) XOR b(i) XOR carry;
	  carry := (a(i) AND b(i)) or
		   (a(i) AND carry) or
		   (b(i) AND carry);
      END LOOP;  -- i
  END IF;    
  RETURN retval;
END plus;

BEGIN
 process (clk)
   variable clr : std_logic := '0';
   variable sum : std_logic_vector(w DOWNTO 0) := (OTHERS => '0');
   begin
     if (rat(clr) = 'X') then
       sum := (OTHERS => 'X');
     elsif (rat(clr) = '1') then
       sum := (OTHERS => '0');
     elsif (rat(clk) = 'X' AND rat(clk'last_value)/='X' AND rat(ce) /= '0') then
       sum := (OTHERS => 'X');
     elsif (clk'event and rat(clk) = '1' and rat(clk'last_value) = '0') then
       if (rat(ce) = 'X') then
         sum := (OTHERS => 'X');
       elsif (rat(ce) = '1') then
         if(rat(c_in) = 'X' OR anyX(a) OR anyX(b)) then
           sum := (OTHERS => 'X');
         else
           sum := plus(extend(a, w+1, signed), extend(b, w+1, signed), c_in, w+1);
         end if;
       end if;
     end if; 
   q <= sum;
   end process;
end behv;

-- Module Name		ramd16a4
-- Synopsis		behv. model of baseblox distributed RAM
-- Author 		Dr Chris Dick
-- Creation Date: 	4/29/99
-- Comments: 		design based on behv model from Coregen v1.5
-- Modification History
	

-- ************************************************************************
--  Copyright 1996-1999 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************

library ieee;
use ieee.std_logic_1164.all;
--  
library xilinxcorelib;
use xilinxcorelib.ul_utils.all;
--
ENTITY xdsp_ramd16a4 IS  
  PORT (
  	WE	:in	std_logic;
	CLK	:in	std_logic;
	D	:in	std_logic_vector( 15 downto 0 );
	QSPO	:out	std_logic_vector( 15 downto 0 );
	qspo_CE	:in	std_logic;
	A	:in	std_logic_vector( 3 downto 0 ));
END xdsp_ramd16a4;
--
-- behavior describing a parameterized ram
ARCHITECTURE behv OF xdsp_ramd16a4 IS
--
CONSTANT width: INTEGER := 16;
CONSTANT depth: INTEGER := 16;
CONSTANT adrwid: INTEGER := 4;
CONSTANT rloc_x: rloctype := default_rloc;
CONSTANT rloc_y: rloctype := default_rloc;
CONSTANT userpm: rpmflagtype := default_userpm;
CONSTANT huset : husettype := default_huset;
CONSTANT memdata: memdatatype(0 TO 255):=
           (0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0);
--
BEGIN
--
 PROCESS (clk, qspo_ce, we, a)
 VARIABLE memdint : memdatatype(0 TO 255) := memdata;
 TYPE memtype IS ARRAY(0 TO 255) OF std_logic_vector(width-1 downto 0);
 VARIABLE memdvect : memtype;
 VARIABLE startup : BOOLEAN := TRUE;
 BEGIN
   IF (startup = TRUE) THEN
     qspo <= setall0(width);
     startup := FALSE;
     FOR i in 0 TO 255 LOOP
       memdvect(i) := int_2_std_logic_vector(memdint(i), width);
     END LOOP;
   ELSIF (rat(clk) = 'X' and rat(clk'last_value) /= 'X') THEN
     IF (rat(qspo_ce) /= '0') THEN
       qspo <= setallX(width);
     END IF;
     IF (rat(we) /= '0') THEN
         ASSERT FALSE
         REPORT "Memory Hazard: Clock is not defined when write enable is non-zero."
         SEVERITY WARNING;
       IF (anyX(a)) THEN
         FOR i IN 0 TO 255 LOOP
           memdvect(i) := setallX(width);
         END LOOP;
       ELSE
         memdvect(std_logic_vector_2_posint(a)) := setallX(width);
       END IF;
     END IF;
   ELSIF (clk'EVENT and rat(clk) = '1' AND rat(clk'LAST_VALUE) = '0') THEN
     IF (rat(qspo_ce) = 'X') THEN
       qspo <= setallX(width);
     ELSIF (rat(qspo_ce) = '1') THEN
       IF (anyX(a)) THEN
         qspo <= setallX(width);
       ELSE
         qspo <= memdvect(std_logic_vector_2_posint(a));
       END IF;
     END IF;
     IF (rat(we) = 'X') THEN
       ASSERT FALSE
         REPORT "Memory Hazard: Write enable is not defined at the rising clock edge."
         SEVERITY WARNING;      
       IF (anyX(a)) THEN
         FOR i IN 0 TO 255 LOOP
           memdvect(i) := setallX(width);
         END LOOP;
       ELSE
         memdvect(std_logic_vector_2_posint(a)) := setallX(width);
       END IF;
     ELSIF (rat(we) = '1') THEN
       IF (anyX(a)) THEN
         ASSERT FALSE
           REPORT "Memory Hazard: Writing in a location when address is not defined."
           SEVERITY WARNING;      
         FOR i IN 0 TO 255 LOOP
           memdvect(i) := setallX(width);
         END LOOP;
       ELSE
         memdvect(std_logic_vector_2_posint(a)) := d;
       END IF;
     END IF;
   END IF;
 END PROCESS;
--
END behv;
-- Virtex 16-point FFT
-- 16-bit register

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;
	
library xilinxcorelib;
use xilinxcorelib.ul_utils.all;
	
entity xdsp_reg16 is
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		d		: in std_logic_vector(15 downto 0);	-- data in
		q		: out std_logic_vector(15 downto 0) := (others => '0')	-- data out
	      );
end xdsp_reg16;

architecture behavioral of xdsp_reg16 is

begin

reg16_prc : process(clk,ce)
begin
	if (clk'event and clk = '1') then
		if (ce = '1') then
			q <= d;
		end if;
	end if;
end process;

end behavioral;
-- Virtex 16-point FFT
-- 16-bit register

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;
	
library xilinxcorelib;
use xilinxcorelib.ul_utils.all;
	
entity xdsp_reg16b is
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		d		: in std_logic_vector(15 downto 0);	-- data in
		q		: out std_logic_vector(15 downto 0)  := (others => '0')	-- data out
	      );
end xdsp_reg16b;

architecture behavioral of xdsp_reg16b is

begin

reg16_prc : process(clk,ce)
begin
	if (clk'event and clk = '1') then
		if (ce = '1') then
			q <= d;
		end if;
	end if;
end process;

end behavioral;
-- Virtex 16-point FFT
-- 16-bit register

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;
	
library xilinxcorelib;
	use xilinxcorelib.ul_utils.all;
		
entity xdsp_reg16l is
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		d		: in std_logic_vector(15 downto 0);	-- data in
		q		: out std_logic_vector(15 downto 0)	-- data out
	      );
end xdsp_reg16l;

architecture behavioral of xdsp_reg16l is

begin

reg16_prc : process(clk,ce)
begin
	if (clk'event and clk = '1') then
		if (ce = '1') then
			q <= d;
		end if;
	end if;
end process;

end behavioral;
-- Virtex 16-point FFT
-- 4-bit register

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;
	
library xilinxcorelib;
use xilinxcorelib.ul_utils.all;
	
entity xdsp_reg4 is
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		sclr		: in std_logic;
		d		: in std_logic_vector(3 downto 0);	-- data in
		q		: out std_logic_vector(3 downto 0) := (others => '0')	-- data out
	      );
end xdsp_reg4;

architecture behavioral of xdsp_reg4 is

begin

reg16_prc : process(clk,ce,sclr)
begin
	if sclr = '1' then
		q <= (others => '0');
	elsif clk'event and clk = '1' then
		if ce = '1' then
			q <= d;
		end if;
	end if;
end process;

end behavioral;
-- Module Name		rsub16
-- Synopsis		behv. model of baseblox 16b subtractor
-- Author 		Dr Chris Dick
-- Creation Date: 	4/22/99
-- Comments: 		design based on behv model from Coregen v1.5
-- Modification History

-- ************************************************************************
--  Copyright 1996-1998 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library xilinxcorelib;
use xilinxcorelib.ul_utils.all;

ENTITY xdsp_rsub16 IS
  PORT( a : IN  std_logic_vector( 16 - 1 DOWNTO 0 );
        b : IN  std_logic_vector( 16 - 1 DOWNTO 0 );
        clk : IN  std_logic;
        ce : IN  std_logic;
        b_in : IN  std_logic;
        --clr : IN  std_logic;
        q : OUT std_logic_vector( 16 DOWNTO 0 ) := (others => '0')  );
END xdsp_rsub16;

ARCHITECTURE behv OF xdsp_rsub16 IS
CONSTANT w: integer := 16;
CONSTANT signed : boolean := true;

FUNCTION minus (a, b : std_logic_vector;
		cin: std_logic;
                width : integer) RETURN std_logic_vector IS
VARIABLE retval : std_logic_vector(width-1 DOWNTO 0);
VARIABLE borrow : std_logic := cin;

BEGIN
    IF (anyX(a) OR anyX(b)) THEN
        retval := (OTHERS => 'X');
    ELSE
        FOR i IN 0 TO width-1 LOOP
            retval(i) := a(i) XOR NOT(b(i)) XOR borrow;
            borrow := (a(i) AND (NOT b(i)))  OR 
                      (a(i) AND  borrow) OR 
                      ((NOT b(i)) AND borrow);
        END LOOP;
    END IF;
    RETURN retval;
END minus;    

BEGIN
 process (clk)
   variable clr	: std_logic := '0';
   variable sum : std_logic_vector(w DOWNTO 0) := (OTHERS => '0');
   begin
     if (rat(clr) = 'X') then
       sum := (OTHERS => 'X');
     elsif (rat(clr) = '1') then
       sum := (OTHERS => '0');
     elsif (rat(clk) = 'X' AND rat(clk'LAST_VALUE)/='X' AND rat(ce) /= '0') then
       sum := (OTHERS => 'X');
     elsif (clk'event and rat(clk) = '1' and rat(clk'last_value) = '0') then
       if (rat(ce) = 'X') then
         sum := (OTHERS => 'X');
       elsif (rat(ce) = '1') then
	   if(rat(b_in) = 'X' OR anyX(a) OR anyX(b)) then
                 sum := (OTHERS => 'X');
	   else
             sum := minus(extend(a, w+1, signed), extend(b, w+1, signed),
			  b_in, w+1);
           end if;
       end if;
     end if; 
     q <= sum;
   end process;
end behv;

-- Module Name		rsub16
-- Synopsis		behv. model of baseblox 16b subtractor
-- Author 		Dr Chris Dick
-- Creation Date: 	4/22/99
-- Comments: 		design based on behv model from Coregen v1.5
-- Modification History

-- ************************************************************************
--  Copyright 1996-1998 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library xilinxcorelib;
use xilinxcorelib.ul_utils.all;

ENTITY xdsp_rsub16b IS
  PORT( a : IN  std_logic_vector( 16 - 1 DOWNTO 0 );
        b : IN  std_logic_vector( 16 - 1 DOWNTO 0 );
        clk : IN  std_logic;
        ce : IN  std_logic;
        b_in : IN  std_logic;
        --clr : IN  std_logic;
        q : OUT std_logic_vector( 16 DOWNTO 0 ));
END xdsp_rsub16b;

ARCHITECTURE behv OF xdsp_rsub16b IS
CONSTANT w: integer := 16;
CONSTANT signed : boolean := true;

FUNCTION minus (a, b : std_logic_vector;
		cin: std_logic;
                width : integer) RETURN std_logic_vector IS
VARIABLE retval : std_logic_vector(width-1 DOWNTO 0);
VARIABLE borrow : std_logic := cin;

BEGIN
    IF (anyX(a) OR anyX(b)) THEN
        retval := (OTHERS => 'X');
    ELSE
        FOR i IN 0 TO width-1 LOOP
            retval(i) := a(i) XOR NOT(b(i)) XOR borrow;
            borrow := (a(i) AND (NOT b(i)))  OR 
                      (a(i) AND  borrow) OR 
                      ((NOT b(i)) AND borrow);
        END LOOP;
    END IF;
    RETURN retval;
END minus;    

BEGIN
 process (clk)
   variable clr	: std_logic := '0';
   variable sum : std_logic_vector(w DOWNTO 0) := (OTHERS => '0');
   begin
     if (rat(clr) = 'X') then
       sum := (OTHERS => 'X');
     elsif (rat(clr) = '1') then
       sum := (OTHERS => '0');
     elsif (rat(clk) = 'X' AND rat(clk'LAST_VALUE)/='X' AND rat(ce) /= '0') then
       sum := (OTHERS => 'X');
     elsif (clk'event and rat(clk) = '1' and rat(clk'last_value) = '0') then
       if (rat(ce) = 'X') then
         sum := (OTHERS => 'X');
       elsif (rat(ce) = '1') then
	   if(rat(b_in) = 'X' OR anyX(a) OR anyX(b)) then
                 sum := (OTHERS => 'X');
	   else
             sum := minus(extend(a, w+1, signed), extend(b, w+1, signed),
			  b_in, w+1);
           end if;
       end if;
     end if; 
     q <= sum;
   end process;
end behv;

-- Module Name		rsub16
-- Synopsis		behv. model of baseblox 16b subtractor
-- Author 		Dr Chris Dick
-- Creation Date: 	4/22/99
-- Comments: 		design based on behv model from Coregen v1.5
-- Modification History

-- ************************************************************************
--  Copyright 1996-1998 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library xilinxcorelib;
use xilinxcorelib.ul_utils.all;

ENTITY xdsp_rsub16c IS
  PORT( a : IN  std_logic_vector( 16 - 1 DOWNTO 0 );
        b : IN  std_logic_vector( 16 - 1 DOWNTO 0 );
        clk : IN  std_logic;
        ce : IN  std_logic;
        b_in : IN  std_logic;
        --clr : IN  std_logic;
        q : OUT std_logic_vector( 16 DOWNTO 0 ));
END xdsp_rsub16c;

ARCHITECTURE behv OF xdsp_rsub16c IS
CONSTANT w: integer := 16;
CONSTANT signed : boolean := true;

FUNCTION minus (a, b : std_logic_vector;
		cin: std_logic;
                width : integer) RETURN std_logic_vector IS
VARIABLE retval : std_logic_vector(width-1 DOWNTO 0);
VARIABLE borrow : std_logic := cin;

BEGIN
    IF (anyX(a) OR anyX(b)) THEN
        retval := (OTHERS => 'X');
    ELSE
        FOR i IN 0 TO width-1 LOOP
            retval(i) := a(i) XOR NOT(b(i)) XOR borrow;
            borrow := (a(i) AND (NOT b(i)))  OR 
                      (a(i) AND  borrow) OR 
                      ((NOT b(i)) AND borrow);
        END LOOP;
    END IF;
    RETURN retval;
END minus;    

BEGIN
 process (clk)
   variable clr	: std_logic := '0';
   variable sum : std_logic_vector(w DOWNTO 0) := (OTHERS => '0');
   begin
     if (rat(clr) = 'X') then
       sum := (OTHERS => 'X');
     elsif (rat(clr) = '1') then
       sum := (OTHERS => '0');
     elsif (rat(clk) = 'X' AND rat(clk'LAST_VALUE)/='X' AND rat(ce) /= '0') then
       sum := (OTHERS => 'X');
     elsif (clk'event and rat(clk) = '1' and rat(clk'last_value) = '0') then
       if (rat(ce) = 'X') then
         sum := (OTHERS => 'X');
       elsif (rat(ce) = '1') then
	   if(rat(b_in) = 'X' OR anyX(a) OR anyX(b)) then
                 sum := (OTHERS => 'X');
	   else
             sum := minus(extend(a, w+1, signed), extend(b, w+1, signed),
			  b_in, w+1);
           end if;
       end if;
     end if; 
     q <= sum;
   end process;
end behv;

-- Module Name		rsub17
-- Synopsis		behv. model of baseblox 17b subtractor
-- Author 		Dr Chris Dick
-- Creation Date: 	4/22/99
-- Comments: 		design based on behv model from Coregen v1.5
-- Modification History

-- ************************************************************************
--  Copyright 1996-1999 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library xilinxcorelib;
use xilinxcorelib.ul_utils.all;

ENTITY xdsp_rsub17 IS
  PORT( a : IN  std_logic_vector( 17 - 1 DOWNTO 0 );
        b : IN  std_logic_vector( 17 - 1 DOWNTO 0 );
        clk : IN  std_logic;
        ce : IN  std_logic;
        b_in : IN  std_logic;
        --clr : IN  std_logic;
        q : OUT std_logic_vector( 17 DOWNTO 0 ) := (others => '0')  );
END xdsp_rsub17;

ARCHITECTURE behv OF xdsp_rsub17 IS
CONSTANT w: integer := 17;
CONSTANT signed : boolean := true;

FUNCTION minus (a, b : std_logic_vector;
		cin: std_logic;
                width : integer) RETURN std_logic_vector IS
VARIABLE retval : std_logic_vector(width-1 DOWNTO 0);
VARIABLE borrow : std_logic := cin;
BEGIN
    IF (anyX(a) OR anyX(b)) THEN
        retval := (OTHERS => 'X');
    ELSE
        FOR i IN 0 TO width-1 LOOP
            retval(i) := a(i) XOR NOT(b(i)) XOR borrow;
            borrow := (a(i) AND (NOT b(i)))  OR 
                      (a(i) AND  borrow) OR 
                      ((NOT b(i)) AND borrow);
        END LOOP;
    END IF;
    RETURN retval;
END minus;    

BEGIN
 process (clk)
   variable clr : std_logic := '0';
   variable sum : std_logic_vector(w DOWNTO 0) := (OTHERS => '0');
   begin
     if (rat(clr) = 'X') then
       sum := (OTHERS => 'X');
     elsif (rat(clr) = '1') then
       sum := (OTHERS => '0');
     elsif (rat(clk) = 'X' AND rat(clk'LAST_VALUE)/='X' AND rat(ce) /= '0') then
       sum := (OTHERS => 'X');
     elsif (clk'event and rat(clk) = '1' and rat(clk'last_value) = '0') then
       if (rat(ce) = 'X') then
         sum := (OTHERS => 'X');
       elsif (rat(ce) = '1') then
	   if(rat(b_in) = 'X' OR anyX(a) OR anyX(b)) then
                 sum := (OTHERS => 'X');
	   else
             sum := minus(extend(a, w+1, signed), extend(b, w+1, signed),
			  b_in, w+1);
           end if;
       end if;
     end if; 
     q <= sum;
   end process;
end behv;

-- Module Name		rsub17
-- Synopsis		behv. model of baseblox 17b subtractor
-- Author 		Dr Chris Dick
-- Creation Date: 	4/22/99
-- Comments: 		design based on behv model from Coregen v1.5
-- Modification History

-- ************************************************************************
--  Copyright 1996-1999 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library xilinxcorelib;
use xilinxcorelib.ul_utils.all;

ENTITY xdsp_rsub17b IS
  PORT( a : IN  std_logic_vector( 17 - 1 DOWNTO 0 );
        b : IN  std_logic_vector( 17 - 1 DOWNTO 0 );
        clk : IN  std_logic;
        ce : IN  std_logic;
        b_in : IN  std_logic;
        --clr : IN  std_logic;
        q : OUT std_logic_vector( 17 DOWNTO 0 ));
END xdsp_rsub17b;

ARCHITECTURE behv OF xdsp_rsub17b IS
CONSTANT w: integer := 17;
CONSTANT signed : boolean := true;

FUNCTION minus (a, b : std_logic_vector;
		cin: std_logic;
                width : integer) RETURN std_logic_vector IS
VARIABLE retval : std_logic_vector(width-1 DOWNTO 0);
VARIABLE borrow : std_logic := cin;
BEGIN
    IF (anyX(a) OR anyX(b)) THEN
        retval := (OTHERS => 'X');
    ELSE
        FOR i IN 0 TO width-1 LOOP
            retval(i) := a(i) XOR NOT(b(i)) XOR borrow;
            borrow := (a(i) AND (NOT b(i)))  OR 
                      (a(i) AND  borrow) OR 
                      ((NOT b(i)) AND borrow);
        END LOOP;
    END IF;
    RETURN retval;
END minus;    

BEGIN
 process (clk)
   variable clr : std_logic := '0';
   variable sum : std_logic_vector(w DOWNTO 0) := (OTHERS => '0');
   begin
     if (rat(clr) = 'X') then
       sum := (OTHERS => 'X');
     elsif (rat(clr) = '1') then
       sum := (OTHERS => '0');
     elsif (rat(clk) = 'X' AND rat(clk'LAST_VALUE)/='X' AND rat(ce) /= '0') then
       sum := (OTHERS => 'X');
     elsif (clk'event and rat(clk) = '1' and rat(clk'last_value) = '0') then
       if (rat(ce) = 'X') then
         sum := (OTHERS => 'X');
       elsif (rat(ce) = '1') then
	   if(rat(b_in) = 'X' OR anyX(a) OR anyX(b)) then
                 sum := (OTHERS => 'X');
	   else
             sum := minus(extend(a, w+1, signed), extend(b, w+1, signed),
			  b_in, w+1);
           end if;
       end if;
     end if; 
     q <= sum;
   end process;
end behv;

-- output of CoreGen module generator
-- $Header: /local/Projects/CVS/P1/zpu_SoC/sources/xilinx/XilinxCoreLib/vfft_utils.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
-- *****************************************************************
--  Copyright 1997-1998 - Xilinx, Inc.
--  All rights reserved.
-- *****************************************************************
--
--  Description:
--    Behaviorial Model for 16 words by xx ROM LUT
--

library ieee;
use ieee.std_logic_1164.all;
--  
library xilinxcorelib;
use xilinxcorelib.ul_utils.all;
--
ENTITY xdsp_sin1024 IS  
  PORT (a	: IN STD_LOGIC_VECTOR(8-1 DOWNTO 0);
        clk	: IN STD_LOGIC;
        qspo_ce	: IN STD_LOGIC := default_fdce_ce;
        --clr	: IN STD_LOGIC := default_fdce_clr;
        qspo	: OUT STD_LOGIC_VECTOR(15-1 DOWNTO 0));
END xdsp_sin1024;
--
--  behavior describing a parameterized ROM
ARCHITECTURE behv OF xdsp_sin1024 IS
--
CONSTANT width: INTEGER := 15;
CONSTANT depth: INTEGER := 256;
CONSTANT adrwid: INTEGER := 8;
CONSTANT usetbufrlocs: BOOLEAN := false;
CONSTANT rloc_x: rloctype := default_rloc;
CONSTANT rloc_y: rloctype := default_rloc;
CONSTANT userpm: rpmflagtype := yes_rpm;
CONSTANT huset : husettype := default_huset;
CONSTANT memdata: memdatatype(0 TO 255) := 
            (0,
            32567,
            32366,
            32165,
            31964,
            31763,
            31562,
            31361,
            31160,
            30959,
            30759,
            30558,
            30357,
            30157,
            29957,
            29756,
            29556,
            29356,
            29156,
            28956,
            28757,
            28557,
            28358,
            28159,
            27960,
            27761,
            27563,
            27364,
            27166,
            26968,
            26770,
            26573,
            26375,
            26178,
            25981,
            25785,
            25588,
            25392,
            25197,
            25001,
            24806,
            24611,
            24417,
            24222,
            24028,
            23835,
            23641,
            23449,
            23256,
            23064,
            22872,
            22680,
            22489,
            22299,
            22108,
            21918,
            21729,
            21540,
            21351,
            21163,
            20975,
            20788,
            20601,
            20414,
            20228,
            20043,
            19858,
            19673,
            19489,
            19305,
            19122,
            18940,
            18758,
            18576,
            18395,
            18215,
            18035,
            17856,
            17677,
            17499,
            17321,
            17144,
            16968,
            16792,
            16617,
            16442,
            16268,
            16095,
            15922,
            15750,
            15578,
            15407,
            15237,
            15068,
            14899,
            14731,
            14563,
            14396,
            14230,
            14065,
            13900,
            13736,
            13573,
            13410,
            13248,
            13087,
            12927,
            12767,
            12608,
            12450,
            12293,
            12136,
            11980,
            11825,
            11671,
            11517,
            11365,
            11213,
            11062,
            10912,
            10762,
            10614,
            10466,
            10319,
            10173,
            10028,
            9884,
            9740,
            9598,
            9456,
            9315,
            9175,
            9036,
            8898,
            8760,
            8624,
            8489,
            8354,
            8220,
            8088,
            7956,
            7825,
            7695,
            7566,
            7438,
            7311,
            7185,
            7060,
            6935,
            6812,
            6690,
            6569,
            6448,
            6329,
            6211,
            6094,
            5977,
            5862,
            5748,
            5635,
            5522,
            5411,
            5301,
            5192,
            5084,
            4977,
            4871,
            4766,
            4662,
            4559,
            4457,
            4357,
            4257,
            4158,
            4061,
            3965,
            3869,
            3775,
            3682,
            3590,
            3499,
            3409,
            3320,
            3233,
            3146,
            3061,
            2976,
            2893,
            2811,
            2730,
            2650,
            2572,
            2494,
            2418,
            2343,
            2269,
            2196,
            2124,
            2053,
            1984,
            1915,
            1848,
            1782,
            1718,
            1654,
            1591,
            1530,
            1470,
            1411,
            1353,
            1297,
            1241,
            1187,
            1134,
            1082,
            1031,
            982,
            934,
            887,
            841,
            796,
            753,
            710,
            669,
            630,
            591,
            554,
            517,
            482,
            449,
            416,
            385,
            355,
            326,
            298,
            272,
            246,
            222,
            200,
            178,
            158,
            139,
            121,
            104,
            89,
            75,
            62,
            50,
            39,
            30,
            22,
            15,
            10,
            6,
            2,
            1);
--
BEGIN
-- 
 PROCESS (clk,qspo_ce)
 variable	clr : std_logic := '0'; 
 BEGIN
   IF (rat(clr) = 'X') THEN
     qspo <= setallX(width);
   ELSIF (rat(clr) = '1') THEN
     qspo <= setall0(width);
   ELSIF (rat(clk) = 'X' AND rat(clk'LAST_VALUE) /= 'X' AND rat(qspo_ce) /= '0') THEN
     qspo <= setallX(width);
   ELSIF (clk'EVENT and rat(clk) = '1' AND rat(clk'LAST_VALUE) = '0') THEN
     IF (rat(qspo_ce) = 'X') THEN
       qspo <= setallX(width);
     ELSIF (rat(qspo_ce) = '1') THEN
       IF (anyX(a)) THEN
         qspo <= setallX(width);
       ELSE
         qspo <= int_2_std_logic_vector(memdata(std_logic_vector_2_posint(a)), width);
       END IF;
     END IF;
   END IF;
 END PROCESS;
END behv;
-- output of CoreGen module generator
-- $Header: /local/Projects/CVS/P1/zpu_SoC/sources/xilinx/XilinxCoreLib/vfft_utils.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
-- *****************************************************************
--  Copyright 1997-1998 - Xilinx, Inc.
--  All rights reserved.
-- *****************************************************************
--
--  Description:
--    Behaviorial Model for 16 words by xx ROM LUT
--

library ieee;
use ieee.std_logic_1164.all;
--  
library xilinxcorelib;
use xilinxcorelib.ul_utils.all;
--
ENTITY xdsp_sin256 IS  
  PORT (a	: IN STD_LOGIC_VECTOR(6-1 DOWNTO 0);
        clk	: IN STD_LOGIC;
        qspo_ce	: IN STD_LOGIC := default_fdce_ce;
        qspo	: OUT STD_LOGIC_VECTOR(15-1 DOWNTO 0));
END xdsp_sin256;
--
--  behavior describing a parameterized ROM
ARCHITECTURE behv OF xdsp_sin256 IS
--
CONSTANT width: INTEGER := 15;
CONSTANT depth: INTEGER := 64;
CONSTANT adrwid: INTEGER := 6;
CONSTANT usetbufrlocs: BOOLEAN := false;
CONSTANT rloc_x: rloctype := default_rloc;
CONSTANT rloc_y: rloctype := default_rloc;
CONSTANT userpm: rpmflagtype := yes_rpm;
CONSTANT huset : husettype := default_huset;
CONSTANT memdata: memdatatype(0 TO 255) := 
            (0,
            31964,
            31160,
            30357,
            29556,
            28757,
            27960,
            27166,
            26375,
            25588,
            24806,
            24028,
            23256,
            22489,
            21729,
            20975,
            20228,
            19489,
            18758,
            18035,
            17321,
            16617,
            15922,
            15237,
            14563,
            13900,
            13248,
            12608,
            11980,
            11365,
            10762,
            10173,
            9598,
            9036,
            8489,
            7956,
            7438,
            6935,
            6448,
            5977,
            5522,
            5084,
            4662,
            4257,
            3869,
            3499,
            3146,
            2811,
            2494,
            2196,
            1915,
            1654,
            1411,
            1187,
            982,
            796,
            630,
            482,
            355,
            246,
            158,
            89,
            39,
            10,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0);
--
BEGIN
-- 
 PROCESS (clk)
 variable	clr : std_logic := '0'; 
 BEGIN
   IF (rat(clr) = 'X') THEN
     qspo <= setallX(width);
   ELSIF (rat(clr) = '1') THEN
     qspo <= setall0(width);
   ELSIF (rat(clk) = 'X' AND rat(clk'LAST_VALUE) /= 'X' AND rat(qspo_ce) /= '0') THEN
     qspo <= setallX(width);
   ELSIF (clk'EVENT and rat(clk) = '1' AND rat(clk'LAST_VALUE) = '0') THEN
     IF (rat(qspo_ce) = 'X') THEN
       qspo <= setallX(width);
     ELSIF (rat(qspo_ce) = '1') THEN
       IF (anyX(a)) THEN
         qspo <= setallX(width);
       ELSE
         qspo <= int_2_std_logic_vector(memdata(std_logic_vector_2_posint(a)), width);
       END IF;
     END IF;
   END IF;
 END PROCESS;
END behv;
-- Module Name		sin64
-- Synopsis		behv. model of baseblox ROM
-- Author 		Dr Chris Dick
-- Creation Date: 	5/11/99
-- Comments: 		design based on behv model from Coregen v1.5
-- Modification History

-- ************************************************************************
--  Copyright 1996-1999 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************



library ieee;
use ieee.std_logic_1164.all;
--  
library xilinxcorelib;
	use xilinxcorelib.ul_utils.all;
--
ENTITY xdsp_sin64 IS  
  PORT (a	: IN STD_LOGIC_VECTOR(4-1 DOWNTO 0);
        rclk	: IN STD_LOGIC;
        rd_ce	: IN STD_LOGIC := default_fdce_ce;
        --clr	: IN STD_LOGIC := default_fdce_clr;
        qspo	: OUT STD_LOGIC_VECTOR(15-1 DOWNTO 0));
END xdsp_sin64;
--
--  behavior describing a parameterized ROM
ARCHITECTURE behv OF xdsp_sin64 IS
--
CONSTANT width: INTEGER := 15;
CONSTANT depth: INTEGER := 16;
CONSTANT adrwid: INTEGER := 4;
CONSTANT usetbufrlocs: BOOLEAN := false;
CONSTANT rloc_x: rloctype := default_rloc;
CONSTANT rloc_y: rloctype := default_rloc;
CONSTANT userpm: rpmflagtype := yes_rpm;
CONSTANT huset : husettype := default_huset;
CONSTANT memdata: memdatatype(0 TO 255) := 
            (0,
            29556,
            26375,
            23256,
            20228,
            17321,
            14563,
            11980,
            9598,
            7438,
            5522,
            3869,
            2494,
            1411,
            630,
            158,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0);
--
BEGIN
-- 
 PROCESS (rclk)
 variable clr 	: std_logic := '0';
 BEGIN
   IF (rat(clr) = 'X') THEN
     qspo <= setallX(width);
   ELSIF (rat(clr) = '1') THEN
     qspo <= setall0(width);
   ELSIF (rat(rclk) = 'X' AND rat(rclk'LAST_VALUE) /= 'X' AND rat(rd_ce) /= '0') THEN
     qspo <= setallX(width);
   ELSIF (rclk'EVENT and rat(rclk) = '1' AND rat(rclk'LAST_VALUE) = '0') THEN
     IF (rat(rd_ce) = 'X') THEN
       qspo <= setallX(width);
     ELSIF (rat(rd_ce) = '1') THEN
       IF (anyX(a)) THEN
         qspo <= setallX(width);
       ELSE
         qspo <= int_2_std_logic_vector(memdata(std_logic_vector_2_posint(a)), width);
       END IF;
     END IF;
   END IF;
 END PROCESS;
END behv;
-- Module Name		coss16
-- Synopsis		behv. model of baseblox ROM
-- Author 		Dr Chris Dick
-- Creation Date: 	4/24/99
-- Comments: 		design based on behv model from Coregen v1.5
-- Modification History

-- ************************************************************************
--  Copyright 1996-1999 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************


library ieee;
use ieee.std_logic_1164.all;
--  
library xilinxcorelib;
use xilinxcorelib.ul_utils.all;
--
ENTITY xdsp_sinn16 IS  
  PORT (a	: IN STD_LOGIC_VECTOR(4-1 DOWNTO 0);
        clk	: IN STD_LOGIC;
        qspo_ce	: IN STD_LOGIC := default_fdce_ce;
        --clr	: IN STD_LOGIC := default_fdce_clr;
        qspo	: OUT STD_LOGIC_VECTOR(16-1 DOWNTO 0) := (others => '0'));
END xdsp_sinn16;
--
--  behavior describing a parameterized ROM
ARCHITECTURE behv OF xdsp_sinn16 IS
--
CONSTANT width: INTEGER := 16;
CONSTANT depth: INTEGER := 16;
CONSTANT adrwid: INTEGER := 4;
CONSTANT usetbufrlocs: BOOLEAN := false;
CONSTANT rloc_x: rloctype := default_rloc;
CONSTANT rloc_y: rloctype := default_rloc;
CONSTANT userpm: rpmflagtype := yes_rpm;
CONSTANT huset : husettype := default_huset;
CONSTANT memdata: memdatatype(0 TO 255) := 
            (0,
            0,
            0,
            0,
            0,
            52996,
            42366,
            35262,
            0,
            42366,
            32768,
            42366,
            0,
            35262,
            42366,
            12540,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0);
--
BEGIN
-- 
 PROCESS (clk)
 	variable clr	: std_logic := '0';
 BEGIN
   IF (rat(clr) = 'X') THEN
     qspo <= (others => '0');		--setallX(width);
   ELSIF (rat(clr) = '1') THEN
     qspo <= setall0(width);
   ELSIF (rat(clk) = 'X' AND rat(clk'LAST_VALUE) /= 'X' AND rat(qspo_ce) /= '0') THEN
     qspo <= (others => '0');		--setallX(width);
   ELSIF (clk'EVENT and rat(clk) = '1' AND rat(clk'LAST_VALUE) = '0') THEN
     IF (rat(qspo_ce) = 'X') THEN
       qspo <= (others => '0');		--setallX(width);
     ELSIF (rat(qspo_ce) = '1') THEN
       IF (anyX(a)) THEN
         qspo <= (others => '0');	--setallX(width);
       ELSE
         qspo <= int_2_std_logic_vector(memdata(std_logic_vector_2_posint(a)), width);
       END IF;
     END IF;
   END IF;
 END PROCESS;
END behv;
-- Module Name		tcompw16
-- Synopsis		behv. model of baseblox 16b 2's comp
-- Author 		Dr Chris Dick
-- Creation Date: 	4/22/99
-- Comments: 		design based on behv model from Coregen v1.5
-- Modification History
--			4/26/99 changed bypass from active low to active high (
--				it now 2's comps when bypass ==1

-- ************************************************************************
--  Copyright 1996-1999 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;
library xilinxcorelib;
use xilinxcorelib.ul_utils.all;

entity xdsp_tcompw16 is
  port( 
	a	: in   std_logic_vector(15 downto 0 );
        bypass	: in   std_logic;
        clk	: in   std_logic;
        ce	: in   std_logic;
        q	: out  std_logic_vector(16 downto 0 ) := (others => '0'));
end xdsp_tcompw16;

architecture behv of xdsp_tcompw16 is
  constant k : integer := 16;
  CONSTANT two_comp : BOOLEAN := true;
begin

 process
   variable va   : std_logic_vector( k downto 0 );
   variable vq   : std_logic_vector( k downto 0 );
   VARIABLE one_detected : BOOLEAN := FALSE;
 begin

   va(k-1 downto 0) := std_logic_vector_2_var(a);
   va(k) := a(k-1);
   
   -- ---------------------------------------------------------------------------- --
   -- If the clock is an X, and the clock enable is a 1 or an X, the output gets X --
   -- ---------------------------------------------------------------------------- --
   IF (rat(clk)='X' AND rat(ce)/='0' AND rat(clk'LAST_VALUE)/='X') THEN
     vq := (OTHERS => 'X');

   -- ---------------------------------------------------------------------------- --
   -- If the clock'event is valid then...                                          --
   -- ---------------------------------------------------------------------------- --
     ELSIF (clk'EVENT and rat(clk)='1' and rat(clk'LAST_VALUE)='0') then

   -- ---------------------------------------------------------------------------- --
   -- If the clockenable is an X, the outputs get X                                --
   -- ---------------------------------------------------------------------------- --
       IF rat(ce)='X' THEN
         vq := (OTHERS => 'X');

   -- ---------------------------------------------------------------------------- --
   -- Otherwise, do the twos complement...                                         --
   -- ---------------------------------------------------------------------------- --
       ELSE IF rat(ce)='1' THEN
           IF bypass='1' THEN
             vq := not va + 1;
           ELSIF bypass='0' THEN
             vq := va;
           ELSE
             vq := (OTHERS => 'X');
           END IF;
         q <= vq;

       END IF;
     end if;
   end if;

   WAIT ON clk;

 end process;

end behv;

-- Module Name		tcompw16
-- Synopsis		behv. model of baseblox 16b 2's comp
-- Author 		Dr Chris Dick
-- Creation Date: 	4/22/99
-- Comments: 		design based on behv model from Coregen v1.5
-- Modification History
--			4/26/99 changed bypass from active low to active high (
--				it now 2's comps when bypass ==1

-- ************************************************************************
--  Copyright 1996-1999 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;
library xilinxcorelib;
use xilinxcorelib.ul_utils.all;

entity xdsp_tcompw16b is
  port( 
	a	: in   std_logic_vector(15 downto 0 );
        bypass	: in   std_logic;
        clk	: in   std_logic;
        ce	: in   std_logic;
        q	: out  std_logic_vector(16 downto 0 ) := (others => '0')  );
end xdsp_tcompw16b;

architecture behv of xdsp_tcompw16b is
  constant k : integer := 16;
  CONSTANT two_comp : BOOLEAN := true;
begin

 process
   variable va   : std_logic_vector( k downto 0 );
   variable vq   : std_logic_vector( k downto 0 );
   VARIABLE one_detected : BOOLEAN := FALSE;
 begin

   va(k-1 downto 0) := std_logic_vector_2_var(a);
   va(k) := a(k-1);
   
   -- ---------------------------------------------------------------------------- --
   -- If the clock is an X, and the clock enable is a 1 or an X, the output gets X --
   -- ---------------------------------------------------------------------------- --
   IF (rat(clk)='X' AND rat(ce)/='0' AND rat(clk'LAST_VALUE)/='X') THEN
     vq := (OTHERS => 'X');

   -- ---------------------------------------------------------------------------- --
   -- If the clock'event is valid then...                                          --
   -- ---------------------------------------------------------------------------- --
     ELSIF (clk'EVENT and rat(clk)='1' and rat(clk'LAST_VALUE)='0') then

   -- ---------------------------------------------------------------------------- --
   -- If the clockenable is an X, the outputs get X                                --
   -- ---------------------------------------------------------------------------- --
       IF rat(ce)='X' THEN
         vq := (OTHERS => 'X');

   -- ---------------------------------------------------------------------------- --
   -- Otherwise, do the twos complement...                                         --
   -- ---------------------------------------------------------------------------- --
       ELSE IF rat(ce)='1' THEN
           IF bypass='1' THEN
             vq := not va + 1;
           ELSIF bypass='0' THEN
             vq := va;
           ELSE
             vq := (OTHERS => 'X');
           END IF;
         q <= vq;

       END IF;
     end if;
   end if;

   WAIT ON clk;

 end process;

end behv;

-- Module Name		tcompw17
-- Synopsis		behv. model of baseblox 17b 2's comp
-- Author 		Dr Chris Dick
-- Creation Date: 	4/22/99
-- Comments: 		design based on behv model from Coregen v1.5
-- Modification History
--			4/26/99 changed bypass from active low to active high (
--				it now 2's comps when bypass ==1
-- ************************************************************************
--  Copyright 1996-1999 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;
library xilinxcorelib;
use xilinxcorelib.ul_utils.all;

entity xdsp_tcompw17 is
  port( 
	a	: in   std_logic_vector(16 downto 0 );
        bypass	: in   std_logic;
        clk	: in   std_logic;
        ce	: in   std_logic;
        q	: out  std_logic_vector(17 downto 0 ) := (others => '0') );
end xdsp_tcompw17;

architecture behv of xdsp_tcompw17 is
  constant k : integer := 17;
  CONSTANT two_comp : BOOLEAN := true;
begin

 process
   variable va   : std_logic_vector( k downto 0 );
   variable vq   : std_logic_vector( k downto 0 );
   VARIABLE one_detected : BOOLEAN := FALSE;
 begin

   va(k-1 downto 0) := std_logic_vector_2_var(a);
   va(k) := a(k-1);
   
   -- ---------------------------------------------------------------------------- --
   -- If the clock is an X, and the clock enable is a 1 or an X, the output gets X --
   -- ---------------------------------------------------------------------------- --
   IF (rat(clk)='X' AND rat(ce)/='0' AND rat(clk'LAST_VALUE)/='X') THEN
     vq := (OTHERS => 'X');

   -- ---------------------------------------------------------------------------- --
   -- If the clock'event is valid then...                                          --
   -- ---------------------------------------------------------------------------- --
     ELSIF (clk'EVENT and rat(clk)='1' and rat(clk'LAST_VALUE)='0') then

   -- ---------------------------------------------------------------------------- --
   -- If the clockenable is an X, the outputs get X                                --
   -- ---------------------------------------------------------------------------- --
       IF rat(ce)='X' THEN
         vq := (OTHERS => 'X');

   -- ---------------------------------------------------------------------------- --
   -- Otherwise, do the twos complement...                                         --
   -- ---------------------------------------------------------------------------- --
       ELSE IF rat(ce)='1' THEN
           IF bypass='1' THEN
             vq := not va + 1;
           ELSIF bypass='0' THEN
             vq := va;
           ELSE
             vq := (OTHERS => 'X');
           END IF;
         q <= vq;

       END IF;
     end if;
   end if;

   WAIT ON clk;

 end process;

end behv;

-- output of CoreGen module generator
-- $Header: /local/Projects/CVS/P1/zpu_SoC/sources/xilinx/XilinxCoreLib/vfft_utils.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
-- *****************************************************************
--  Copyright 1997-1998 - Xilinx, Inc.
--  All rights reserved.
-- *****************************************************************
--
--  Description:
--    Behaviorial Model for 16 words by xx ROM LUT
--

library ieee;
use ieee.std_logic_1164.all;
--  
library xilinxcorelib;
use xilinxcorelib.ul_utils.all;
--
ENTITY xdsp_triginv IS  
  PORT (a	: IN STD_LOGIC_VECTOR(4-1 DOWNTO 0);
        c	: IN STD_LOGIC;
        ce	: IN STD_LOGIC := default_fdce_ce;
        clr	: IN STD_LOGIC := default_fdce_clr;
        q	: OUT STD_LOGIC);	--OUT STD_LOGIC_VECTOR(2-1 DOWNTO 0));
END xdsp_triginv;
--
--  behavior describing a parameterized ROM
ARCHITECTURE behv OF xdsp_triginv IS
--
CONSTANT width: INTEGER := 1;
CONSTANT depth: INTEGER := 16;
CONSTANT adrwid: INTEGER := 4;
CONSTANT usetbufrlocs: BOOLEAN := false;
CONSTANT rloc_x: rloctype := default_rloc;
CONSTANT rloc_y: rloctype := default_rloc;
CONSTANT userpm: rpmflagtype := yes_rpm;
CONSTANT huset : husettype := default_huset;
CONSTANT memdata: memdatatype(0 TO 255) := 
            (
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            1,
            1,
            1,
            1,
            1,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0);
--
BEGIN
-- 
 PROCESS (c, clr)
 variable q_tmp: std_logic_vector(1 downto 0);
 BEGIN
   IF (rat(clr) = 'X') THEN
     q <= 'X';				--setallX(width);
   ELSIF (rat(clr) = '1') THEN
     q <= '0';				--setall0(width);
   ELSIF (rat(c) = 'X' AND rat(c'LAST_VALUE) /= 'X' AND rat(ce) /= '0') THEN
     q <= 'X';				--setallX(width);
   ELSIF (c'EVENT and rat(c) = '1' AND rat(c'LAST_VALUE) = '0') THEN
     IF (rat(ce) = 'X') THEN
       q <= 'X';			--setallX(width);
     ELSIF (rat(ce) = '1') THEN
       IF (anyX(a)) THEN
         q <= 'X';			--setallX(width);
       ELSE
         --q <= int_2_std_logic_vector(memdata(std_logic_vector_2_posint(a)), width);
         q_tmp := int_2_std_logic_vector(memdata(std_logic_vector_2_posint(a)), 2);
         q <= q_tmp(0);
       END IF;
     END IF;
   END IF;
 END PROCESS;
END behv;
-- Synopsis: FFT constants and other definitions
-- Modification History

library ieee;
use ieee.std_logic_1164.all;
package fft_defsx_1024 is
    constant B			: positive := 16;		-- word precision of FFT
    constant nfft		: natural := 1024;    
    constant max_fft		: natural := 1024;      
    constant log2_nfft		: natural := 10;
    constant log2_max_nfft	: natural := 10;    
    constant latency		: natural := 20;		-- latency through datapath
    constant max_sint		: natural := 2**(B-1) - 1;	-- max positive signed int.
    constant max_uint		: natural := 2**B;		-- max positive signed int.   
end fft_defsx_1024;
-- Virtex  FFT
-- complex 16-bit register with conjugation control

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;

library xilinxcorelib;
	use xilinxcorelib.fft_defsx_1024.all;
		
entity cmplx_reg16_conj is
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
end cmplx_reg16_conj;

architecture struct of cmplx_reg16_conj is
	
	signal	null0	: std_logic;
	
component xdsp_reg16
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		d		: in std_logic_vector(B-1 downto 0);	-- data in
		q		: out std_logic_vector(B-1 downto 0)	-- data out
	      );
end component;

component xdsp_tcompw16
	port (
		a		: in std_logic_VECTOR(B-1 downto 0);
		bypass		: in std_logic;
		clk		: in std_logic;
		ce		: in std_logic;
		q		: out std_logic_VECTOR(B downto 0));
end component;

attribute RLOC : string;
attribute RLOC of r_reg : label is "R0C0";
attribute RLOC of i_reg : label is "R8C0";

begin

r_reg : xdsp_reg16
	port map(
		clk		=> clk,				-- global clk
		ce		=> ce,				-- register ce
		d		=> dr,				-- data input
		q		=> qr				-- registered data output		
	);
	
i_reg : xdsp_tcompw16
	port map(
		a		=> di,				-- data input
		bypass		=> conj,			-- conjugation control
		clk		=> clk,				-- global clk
		ce		=> ce,				-- register ce
		q(B-1 downto 0)	=> qi,				-- registered data output		
		q(B)		=> null0
	);	

end struct;
-- Virtex  FFT
-- complex 16-bit register with conjugation control

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;
	
	
entity cmplx_reg16_conjb is
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		conj		: in std_logic;				-- conjugation control
									-- forms conjugation when ==1
		dr		: in std_logic_vector(15 downto 0);	-- Re/Im data in
		di		: in std_logic_vector(15 downto 0);
		qr		: out std_logic_vector(15 downto 0);	-- Re/Im data out
		qi		: out std_logic_vector(15 downto 0)
	      );
end cmplx_reg16_conjb;

architecture struct of cmplx_reg16_conjb is
	
	signal	null0	: std_logic;
	
component xdsp_reg16b
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		d		: in std_logic_vector(15 downto 0);	-- data in
		q		: out std_logic_vector(15 downto 0)	-- data out
	      );
end component;

component xdsp_tcompw16b
	port (
		a		: in std_logic_VECTOR(15 downto 0);
		bypass		: in std_logic;
		clk		: in std_logic;
		ce		: in std_logic;
		q		: out std_logic_VECTOR(16 downto 0));
end component;

attribute RLOC : string;
attribute RLOC of r_reg : label is "R0C0";
attribute RLOC of i_reg : label is "R8C0";

begin

r_reg : xdsp_reg16b
	port map(
		clk		=> clk,				-- global clk
		ce		=> ce,				-- register ce
		d		=> dr,				-- data input
		q		=> qr				-- registered data output		
	);
	
i_reg : xdsp_tcompw16b
	port map(
		a		=> di,				-- data input
		bypass		=> conj,			-- conjugation control
		clk		=> clk,				-- global clk
		ce		=> ce,				-- register ce
		q(15 downto 0)	=> qi,				-- registered data output		
		q(16)		=> null0
	);	

end struct;
-- Virtex  FFT
-- complex 16-bit register with conjugation control

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;

library xilinxcorelib;
	use xilinxcorelib.fft_defsx_1024.all;
	
entity cmplx_reg16_conjc is
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
end cmplx_reg16_conjc;

architecture struct of cmplx_reg16_conjc is
	
	signal	null0	: std_logic;
	
component xdsp_reg16
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		d		: in std_logic_vector(B-1 downto 0);	-- data in
		q		: out std_logic_vector(B-1 downto 0)	-- data out
	      );
end component;

component xdsp_tcompw16b
	port (
		a		: in std_logic_VECTOR(B-1 downto 0);
		bypass		: in std_logic;
		clk		: in std_logic;
		ce		: in std_logic;
		q		: out std_logic_VECTOR(B downto 0));
end component;			   

attribute RLOC : string;
attribute RLOC of r_reg : label is "R0C0";
attribute RLOC of i_reg : label is "R8C0";

begin

r_reg : xdsp_reg16
	port map(
		clk		=> clk,				-- global clk
		ce		=> ce,				-- register ce
		d		=> dr,				-- data input
		q		=> qr				-- registered data output		
	);
	
i_reg : xdsp_tcompw16b
	port map(
		a		=> di,				-- data input
		bypass		=> conj,			-- conjugation control
		clk		=> clk,				-- global clk
		ce		=> ce,				-- register ce
		q(B-1 downto 0)	=> qi,				-- registered data output		
		q(B)		=> null0
	);	

end struct;
-- Virtex 16-point FFT
-- simple state machine

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;
		
entity state_mach is
	port (
		clk		: in std_logic;				-- system clock
		rs		: in std_logic;				-- reset
		start		: in std_logic;				-- global start 
		ce		: in std_logic;				-- global clk enable
		s0		: out std_logic;			-- state outputs
		s1		: out std_logic;
		s2		: out std_logic;
		s3		: out std_logic
	      );
end state_mach;

architecture behavioral of state_mach is
	signal state_cntr	: std_logic_vector(1 downto 0);	-- state machine cntr	

begin

state_mach : process(clk,rs,ce,start)
begin
	if rs = '1' or start = '1' then
		state_cntr <= "00";
	elsif clk'event and clk='1' then
	    if ce = '1' then
		if (state_cntr = 0) then
			s0 <= '1';
		else
			s0 <= '0';
		end if;
		if (state_cntr = 1) then
			s1 <= '1';
		else
			s1 <= '0';
		end if;
		if (state_cntr = 2) then
			s2 <= '1';
		else
			s2 <= '0';
		end if;
		if (state_cntr = 3) then
			s3 <= '1';
		else
			s3 <= '0';
		end if;
		state_cntr <= state_cntr + 1;	
 	    end if;
	end if;
end process;

end behavioral;
-- flip-flop with load and clock enable (ce)  

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	
entity fflce is
	port (
		clk		: in std_logic;		-- clock
		ce		: in std_logic;		-- cleck enable
		rs		: in std_logic;		-- master reset
		load		: in std_logic;		-- load signal
		din		: in std_logic;		-- load data
		d		: in std_logic;		-- data input
		q		: out std_logic		-- ff output
	);
end fflce;

architecture fflce_arch of fflce is
begin

process(clk)
begin
    if (clk'event and clk = '1') then
        if (load = '1') then
    	    q <= din;
    	elsif (rs = '1') then
    	    q <= '0';
    	elsif (ce = '1') then
    	    q <= d;
    	end if;    
    end if;
end process;
end fflce_arch;
-- flip-flop with clock enable (ce) and reset 

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	
entity ffrce is
	port (
		clk		: in std_logic;		-- clock
		ce		: in std_logic;		-- cleck enable
		rs		: in std_logic;		-- master reset
		d		: in std_logic;		-- data input
		q		: out std_logic		-- ff output
	);
end ffrce;

architecture ffrce_arch of ffrce is
begin

process(clk,rs)
begin
    if clk'event and clk = '1' then
        if rs = '1' then
            q <= '0';
        elsif ce = '1' then
    	    q <= d;
        end if;    
    end if;
end process;
end ffrce_arch;
-- SRL16/FF based 1-bit wide 19 stage delay line

-- din -> srl16_1 -> FF1 -> Fsrl16_22 -> FF2
-- srl16_1 provides 16 bits of delay and srl16_2 provides 1 bit of delay 

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;

-- synopsys translate_off
library unisim;
	use unisim.vcomponents.all;
-- synopsys translate_on
		
entity z19w1 is
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		din		: in std_logic;
		dout		: out std_logic
	);
end z19w1;

architecture z19w1_arch of z19w1 is

	signal	u1	: std_logic;
	signal	u2	: std_logic;
	signal	ff1_q	: std_logic;
	signal	logic0	: std_logic;
	signal	logic1	: std_logic;
	
	
component SRL16E
	port (
		q		: out std_logic;	
		d		: in std_logic;
		ce		: in std_logic;
		clk   		: in std_logic;
 		a0		: in std_logic;			
 		a1		: in std_logic;
 		a2		: in std_logic;
 		a3		: in std_logic
	);
end component;

begin

srl16_1 : SRL16E 
	port map(
		q		=> u1,	
		d		=> din,
		ce		=> ce,
		clk   		=> clk,
		a0		=> logic1,	-- 16 stage delay line (addr = dec 15)
 		a1		=> logic1,
 		a2		=> logic1,
 		a3		=> logic1
 	);
 	
ff1 : process (clk,ce,u1)
begin
	if clk'event and clk = '1' then
		if ce = '1' then
			ff1_q <= u1;	
		end if;
	end if;
end process;

srl16_2 : SRL16E 
	port map(
		q		=> u2,	
		d		=> ff1_q,
		ce		=> ce,
		clk   		=> clk,
		a0		=> logic0,	-- 1 stage delay line (addr = dec 0)
 		a1		=> logic0,
 		a2		=> logic0,
 		a3		=> logic0
 	);

ff2 : process (clk,ce,u1)
begin
	if clk'event and clk = '1' then
		if ce = '1' then
			dout <= u2;	
		end if;
	end if;
end process;
 
	logic0 <= '0';
	logic1 <= '1';
		 	
end z19w1_arch;		   
-- SRL16/FF based 1-bit wide 20 stage delay line

-- din -> srl16_1 -> FF1 -> Fsrl16_22 -> FF2
-- srl16_1 provides 16 bits of delay and srl16_2 provides 2 bit of delay 

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;

-- synopsys translate_off
library unisim;
	use unisim.vcomponents.all;
-- synopsys translate_on
		
entity z20w1 is
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		din		: in std_logic;
		dout		: out std_logic
	);
end z20w1;

architecture struct of z20w1 is

	signal	u1	: std_logic;
	signal	u2	: std_logic;
	signal	ff1_q	: std_logic;
	signal	logic0	: std_logic;
	signal	logic1	: std_logic;
	
	
component SRL16E
	port (
		q		: out std_logic;	
		d		: in std_logic;
		ce		: in std_logic;
		clk   		: in std_logic;
 		a0		: in std_logic;			
 		a1		: in std_logic;
 		a2		: in std_logic;
 		a3		: in std_logic
	);
end component;

begin

srl16_1 : SRL16E 
	port map(
		q		=> u1,	
		d		=> din,
		ce		=> ce,
		clk   		=> clk,
		a0		=> logic1,	-- 16 stage delay line (addr = dec 15)
 		a1		=> logic1,
 		a2		=> logic1,
 		a3		=> logic1
 	);
 	
ff1 : process (clk,ce,u1)
begin
	if clk'event and clk = '1' then
		if ce = '1' then
			ff1_q <= u1;	
		end if;
	end if;
end process;

srl16_2 : SRL16E 
	port map(
		q		=> u2,	
		d		=> ff1_q,
		ce		=> ce,
		clk   		=> clk,
		a0		=> logic1,	-- 2 stage delay line (addr = dec 1)
 		a1		=> logic0,
 		a2		=> logic0,
 		a3		=> logic0
 	);

ff2 : process (clk,ce,u1)
begin
	if clk'event and clk = '1' then
		if ce = '1' then
			dout <= u2;	
		end if;
	end if;
end process;
 
	logic0 <= '0';
	logic1 <= '1';
		 	
end struct;		   
-- SRL16/FF based 1-bit wide 47 stage delay line

-- din -> srl16_1 -> FF1 -> srl16_22 -> FF2 -> srl16 -> FF3

-- srl16_1 provides 16 bits of delay, srl16_2 provides 16 bit of delay,
-- srl16_3 provides 12 bits of delay 
-- ... the 3 FFs provide the additional 3 bits of delay

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;

-- synopsys translate_off
library unisim;
	use unisim.vcomponents.all;
-- synopsys translate_on
		
entity z47w1 is
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		din		: in std_logic;
		dout		: out std_logic
	);
end z47w1;

architecture struct of z47w1 is

	signal	u1	: std_logic;
	signal	u2	: std_logic;
	signal	u3	: std_logic;	
	signal	ff1_q	: std_logic;
	signal	ff2_q	: std_logic;	
	signal	logic0	: std_logic;
	signal	logic1	: std_logic;
	
	
component SRL16E
	port (
		q		: out std_logic;	
		d		: in std_logic;
		ce		: in std_logic;
		clk   		: in std_logic;
 		a0		: in std_logic;			
 		a1		: in std_logic;
 		a2		: in std_logic;
 		a3		: in std_logic
	);
end component;

begin

srl16_1 : SRL16E 
	port map(
		q		=> u1,	
		d		=> din,
		ce		=> ce,
		clk   		=> clk,
		a0		=> logic1,	-- 16 stage delay line (addr = dec 15)
 		a1		=> logic1,
 		a2		=> logic1,
 		a3		=> logic1
 	);
 	
ff1 : process (clk,ce,u1)
begin
	if clk'event and clk = '1' then
		if ce = '1' then
			ff1_q <= u1;	
		end if;
	end if;
end process;

srl16_2 : SRL16E 
	port map(
		q		=> u2,	
		d		=> ff1_q,
		ce		=> ce,
		clk   		=> clk,
		a0		=> logic1,	-- 6 stage delay line (addr = dec 15)
 		a1		=> logic1,
 		a2		=> logic1,
 		a3		=> logic1
 	);

ff2 : process (clk,ce,u1)
begin
	if clk'event and clk = '1' then
		if ce = '1' then
			ff2_q <= u2;	
		end if;
	end if;
end process;

srl16_3 : SRL16E 
	port map(
		q		=> u3,	
		d		=> ff2_q,
		ce		=> ce,
		clk   		=> clk,
		a0		=> logic1,	-- 12 stage delay line (addr = dec 11)
 		a1		=> logic1,
 		a2		=> logic0,
 		a3		=> logic1
 	);

ff3 : process (clk,ce,u1)
begin
	if clk'event and clk = '1' then
		if ce = '1' then
			dout <= u3;	
		end if;
	end if;
end process;
 
	logic0 <= '0';
	logic1 <= '1';
		 	
end struct;		   
-- SRL16/FF based 1-bit wide 49 stage delay line

-- din -> srl16_1 -> FF1 -> srl16_22 -> FF2 -> srl16 -> FF3

-- srl16_1 provides 16 bits of delay, srl16_2 provides 16 bit of delay,
-- srl16_3 provides 14 bits of delay 
-- ... the 3 FFs provide the additional 3 bits of delay

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;

-- synopsys translate_off
library unisim;
	use unisim.vcomponents.all;
-- synopsys translate_on
		
entity z49w1 is
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		din		: in std_logic;
		dout		: out std_logic
	);
end z49w1;

architecture struct of z49w1 is

	signal	u1	: std_logic;
	signal	u2	: std_logic;
	signal	u3	: std_logic;	
	signal	ff1_q	: std_logic;
	signal	ff2_q	: std_logic;	
	signal	logic0	: std_logic;
	signal	logic1	: std_logic;
	
	
component SRL16E 
	port (
		q		: out std_logic;	
		d		: in std_logic;
		ce		: in std_logic;
		clk   		: in std_logic;
 		a0		: in std_logic;			
 		a1		: in std_logic;
 		a2		: in std_logic;
 		a3		: in std_logic
	);
end component;

begin

srl16_1 : SRL16E 
	port map(
		q		=> u1,	
		d		=> din,
		ce		=> ce,
		clk   		=> clk,
		a0		=> logic1,	-- 16 stage delay line (addr = dec 15)
 		a1		=> logic1,
 		a2		=> logic1,
 		a3		=> logic1
 	);
 	
ff1 : process (clk,ce,u1)
begin
	if clk'event and clk = '1' then
		if ce = '1' then
			ff1_q <= u1;	
		end if;
	end if;
end process;

srl16_2 : SRL16E 
	port map(
		q		=> u2,	
		d		=> ff1_q,
		ce		=> ce,
		clk   		=> clk,
		a0		=> logic1,	-- 16 stage delay line (addr = dec 15)
 		a1		=> logic1,
 		a2		=> logic1,
 		a3		=> logic1
 	);

ff2 : process (clk,ce,u1)
begin
	if clk'event and clk = '1' then
		if ce = '1' then
			ff2_q <= u2;	
		end if;
	end if;
end process;

srl16_3 : SRL16E 
	port map(
		q		=> u3,	
		d		=> ff2_q,
		ce		=> ce,
		clk   		=> clk,
		a0		=> logic1,	-- 14 stage delay line (addr = dec 13)
 		a1		=> logic0,
 		a2		=> logic1,
 		a3		=> logic1
 	);

ff3 : process (clk,ce,u1)
begin
	if clk'event and clk = '1' then
		if ce = '1' then
			dout <= u3;	
		end if;
	end if;
end process;
 
	logic0 <= '0';
	logic1 <= '1';
		 	
end struct;		   
-- SRL16/FF based 1-bit wide 17 stage delay line

-- din -> srl16_1 -> FF1
-- srl16_1 provides 16 bits of delay and a FF procides the final 1 bit of delay 

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;

-- synopsys translate_off
library unisim;
	use unisim.vcomponents.all;
-- synopsys translate_on
		
entity z17w1 is
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		din		: in std_logic;
		dout		: out std_logic
	);
end z17w1;

architecture struct of z17w1 is

	signal	u1	: std_logic;
	signal	logic0	: std_logic;
	signal	logic1	: std_logic;
	
	
component SRL16E 
	port (
		q		: out std_logic;	
		d		: in std_logic;
		ce		: in std_logic;
		clk   		: in std_logic;
 		a0		: in std_logic;			
 		a1		: in std_logic;
 		a2		: in std_logic;
 		a3		: in std_logic
	);
end component;

begin

srl16_1 : SRL16E 
	port map(
		q		=> u1,	
		d		=> din,
		ce		=> ce,
		clk   		=> clk,
		a0		=> logic1,	-- 16 stage delay line (addr = dec 15)
 		a1		=> logic1,
 		a2		=> logic1,
 		a3		=> logic1
 	);
 	
ff1 : process (clk,ce,u1)
begin
	if clk'event and clk = '1' then
		if ce = '1' then
			dout <= u1;	
		end if;
	end if;
end process;
 
	logic0 <= '0';
	logic1 <= '1';
		 	
end struct;		   
-- complex multiplier
-- This module implements a B x 17 bit complex multiplier. The real 
-- and imaginary components of the input operands are kept to a 
-- precision of B bits. A B-bit complex number is returned, again 
-- B bits is allocated for each of the real and imaginary components.
-- The product is perfomed as

--	(ar + jai) x (br + jbi) = e + jf
--	where
--	e = (ar - ai)bi + ar(br - bi) and
--	f = (ar - ai)bi + ar(br + bi)

-- Creation Date: 2/18/1999 

-- 4/22/99	baseblox B-bit adder integration
-- 4/27/99	changed pin names to baseblox compliant naming convention

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;

library xilinxcorelib;
	use xilinxcorelib.fft_defsx_1024.all;
	
entity xmul16x17 is
	port (
		clk		: in std_logic;		-- system clock
		rs		: in std_logic;		-- reset
		ce		: in std_logic;		-- master clk enable
		ar		: in std_logic_vector(B-1 downto 0);  	-- Re(operand 1)
		ai		: in std_logic_vector(B-1 downto 0);	-- Im(operand 1)
		br		: in std_logic_vector(B-1 downto 0);	-- Re(operand 2)
		bi		: in std_logic_vector(B-1 downto 0);	-- Im(operand 2)
		pr		: out std_logic_vector(B downto 0);	-- Re( a x b)
		pi		: out std_logic_vector(B downto 0)	-- Im( a x b)
	      );
end xmul16x17;

architecture struct of xmul16x17 is

	-- temp for holding (ar - ai)
	signal	ar_min_ai	: std_logic_vector(B downto 0);
	
	-- temp for holding (br - bi)
	signal	br_min_bi	: std_logic_vector(B downto 0);
	
	-- temp for holding (br + bi)
	signal	br_plus_bi	: std_logic_vector(B downto 0);
	
	-- pipeline balancing registers for input operands
	-- These compensate for the delay through the pre-add stage
	signal	biz		: std_logic_vector(B-1 downto 0);
	signal	arz		: std_logic_vector(B-1 downto 0);
	signal	aiz		: std_logic_vector(B-1 downto 0);
	signal	proda		: std_logic_vector(2*B downto 0); 	-- (ar-ai)*bi
	signal	prodb		: std_logic_vector(2*B downto 0); 	-- (br-bi)*ar
	signal	prodc		: std_logic_vector(2*B downto 0); 	-- (br+bi)*ai
	
	-- signals for holding full precision outputs
	signal	pr_full_precision	: std_logic_vector(B+1 downto 0);	-- Re(product)
	signal	pi_full_precision	: std_logic_vector(B+1 downto 0);	-- Im(product)
	
	-- constants for supplying logic levels to unused component pins
	signal	logic_1		: std_logic;
	signal	logic_0		: std_logic;
	
	signal	tmpa,tmpc	: std_logic_vector(B-1 downto 0);
	signal	null0		: std_logic_vector(B-1 downto 0);
	signal	null1		: std_logic_vector(B-1 downto 0);

component xdsp_reg16 
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		d		: in std_logic_vector(B-1 downto 0);	-- data in
		q		: out std_logic_vector(B-1 downto 0)	-- data out
	      );
end component;

component xdsp_radd16 
  PORT( a 	: IN  std_logic_vector( B - 1 DOWNTO 0 );
        b 	: IN  std_logic_vector( B - 1 DOWNTO 0 );
        clk 	: IN  std_logic;
        ce 	: IN  std_logic;
        c_in 	: IN  std_logic;
        q 	: OUT std_logic_vector( 16 DOWNTO 0 ));
END component;

component xdsp_radd17 
  PORT( a 	: IN  std_logic_vector( B  DOWNTO 0 );
        b 	: IN  std_logic_vector( B  DOWNTO 0 );
        clk 	: IN  std_logic;
        ce 	: IN  std_logic;
        c_in 	: IN  std_logic;
        q 	: OUT std_logic_vector( 16+1 DOWNTO 0 ));
END component;

component xdsp_rsub16 
  PORT( a 	: IN  std_logic_vector( B - 1 DOWNTO 0 );
        b 	: IN  std_logic_vector( B - 1 DOWNTO 0 );
        clk 	: IN  std_logic;
        ce 	: IN  std_logic;
        b_in 	: IN  std_logic;
        q 	: OUT std_logic_vector( 16 DOWNTO 0 ));
END component;

component xdsp_mul16x17 
  port( a        : in  std_logic_vector( B downto 0 );
        b        : in  std_logic_vector( B-1 downto 0 );     
        clk      : in  std_logic;
        ce       : in  std_logic;
        p	 : out std_logic_vector( (16 + 16) downto 0));
end component;

attribute RLOC : string;	
attribute RLOC of ar_min_ai_sub : label is "R0C0";
attribute RLOC of biz_reg : label is "R0C0";
attribute RLOC of mula: label is "R0C1";   
attribute RLOC of br_min_bi_sub : label is "R0C10";
attribute RLOC of arz_reg : label is "R0C10";
attribute RLOC of mulb: label is "R0C11";  
attribute RLOC of br_plus_bi_sub : label is "R14C10";
attribute RLOC of aiz_reg : label is "R14C10";
attribute RLOC of mulc: label is "R14C11";
attribute RLOC of pr_add : label is "R0C19";
attribute RLOC of pi_add : label is "R14C19";

begin

ar_min_ai_sub : xdsp_rsub16
	port map(
	a		=> ar,
	b		=> ai,
	clk		=> clk,
	ce		=> ce,
	b_in		=> logic_1,
	q		=> ar_min_ai
	);
	
br_min_bi_sub : xdsp_rsub16
	port map(
	a		=> br,
	b		=> bi,
	clk		=> clk,
	ce		=> ce,
	b_in		=> logic_1,
	q		=> br_min_bi
	);
	 
br_plus_bi_sub : xdsp_radd16
	port map(
	a		=> br,
	b		=> bi,
	clk		=> clk,
	ce		=> ce,
	c_in		=> logic_0,
	q		=> br_plus_bi
	);
	
-- component computes (ar - ai) x bi
mula : xdsp_mul16x17
	port map(
	a		=> ar_min_ai(B downto 0),
	b		=> biz,
	clk		=> clk,
	ce		=> ce,
	p		=> proda
	);
	
-- component computes (br - bi) x ar
mulb : xdsp_mul16x17
	port map(
	a		=> br_min_bi(B downto 0),
	b		=> arz,
	clk		=> clk,
	ce		=> ce,
	p		=> prodb
	);

-- component computes (br + bi) x ai
mulc : xdsp_mul16x17
	port map(
	a		=> br_plus_bi(B downto 0),
	b		=> aiz,
	clk		=> clk,
	ce		=> ce,
	p		=> prodc
	);
		
-- pipeline balancing registers to compensate for latency through pre-addition stage
biz_reg : xdsp_reg16
	port map(
		clk	=> clk,			-- master clock
		ce	=> ce,			-- master ce
		d	=> bi,			-- data input
		q	=> biz			-- delayed input sample
	);
	
-- pipeline balancing registers to compensate for latency through pre-addition stage
arz_reg : xdsp_reg16
	port map(
		clk	=> clk,			-- master clock
		ce	=> ce,			-- master ce
		d	=> ar,			-- data input
		q	=> arz			-- delayed input sample
	);

-- pipeline balancing registers to compensate for latency through pre-addition stage
aiz_reg : xdsp_reg16
	port map(
		clk	=> clk,			-- master clock
		ce	=> ce,			-- master ce
		d	=> ai,			-- data input
		q	=> aiz			-- delayed input sample
	);	
	
-- final output post-adds to form Re/Im components of output product

pr_add : xdsp_radd17					-- real part
	port map (
	a 		=> prodb(2*B-1 downto B-1),
        b 		=> proda(2*B-1 downto B-1),
        clk 		=> clk,
        ce 		=> ce,
        c_in 		=> logic_0,
        q		=> pr_full_precision
	);
	
pi_add : xdsp_radd17					-- imag. part
	port map (
	a 		=> prodc(2*B-1 downto B-1),
        b 		=> proda(2*B-1 downto B-1),
        clk 		=> clk,
        ce 		=> ce,
        c_in 		=> logic_0,
        q 		=> pi_full_precision
	);
	 
	tmpa <= proda(2*B-2 downto B-1);
	tmpc <= prodc(2*B-2 downto B-1);
	pr <= pr_full_precision(B downto 0);	 
	pi <= pi_full_precision(B downto 0);	
	logic_1 <= '1';
	logic_0 <= '0';
	 
end struct;




-- shift register
-- This shift register shifts right 2 bit positions on each clock edge.

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	
entity shift_reg2b is
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		load		: in std_logic;
		din		: in std_logic_vector(15 downto 0);
		ser_data_in0	: in std_logic;
		ser_data_in1	: in std_logic;
		par_data	: inout std_logic_vector(15 downto 0)
	);
end shift_reg2b;

architecture shift_reg2b_arch of shift_reg2b is

    alias normalized_par_data:
        std_logic_vector(15 downto 0) is par_data;
        
    component fflce
        port (
        	clk	: in std_logic;
		ce	: in std_logic;		-- cleck enable
		rs	: in std_logic;
		load	: in std_logic;		-- load signal
		din	: in std_logic;		-- load data
        	d	: in std_logic;
        	q	: out std_logic
        );
    end component;

begin
    reg_array : for index in normalized_par_data'range generate
        first_cell : if index = 0 generate
            cell : fflce
            	       port map(
            	       		clk	=> clk,
            	       		ce	=> ce,
            	       		rs	=> rs,
            	       		load	=> load,
            	       		din	=> din(index),
            	       		d	=> ser_data_in0,
            	       		q	=> normalized_par_data(index)
            	       );
        end generate;
        
        second_cell : if index = 1 generate
            cell :  fflce
            	       port map(
            	       		clk	=> clk,
            	       		ce	=> ce,
            	       		rs	=> rs,
            	       		load	=> load,
            	       		din	=> din(index),
            	       		d	=> ser_data_in1,
            	       		q	=> normalized_par_data(index)
            	       );
        end generate second_cell;
        
        other_cell : if (index /= 0 and index /= 1) generate
            cell :  fflce
            		port map(
            			clk	=> clk,
            			ce	=> ce,
            			rs	=> rs,
            			load	=> load,
            			din	=>din(index),
            			d	=> normalized_par_data(index-2),
            			q	=> normalized_par_data(index)
            		);
        end generate other_cell;
    end generate;     
end shift_reg2b_arch;		   
-- Virtex FFT
-- complex 4:1 16-bit registered multiplexor

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;
		
entity xmux4w16r is
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		s0		: in std_logic;				-- mux select inputs
		s1		: in std_logic;
		x0r		: in std_logic_vector(15 downto 0);	-- mux inputs Re and Im
		x0i		: in std_logic_vector(15 downto 0);
		x1r		: in std_logic_vector(15 downto 0);	
		x1i		: in std_logic_vector(15 downto 0);
		x2r		: in std_logic_vector(15 downto 0);	
		x2i		: in std_logic_vector(15 downto 0);
		x3r		: in std_logic_vector(15 downto 0);	
		x3i		: in std_logic_vector(15 downto 0);
		yr		: out std_logic_vector(15 downto 0);	-- mux outputs
		yi		: out std_logic_vector(15 downto 0)
	      );
end xmux4w16r;

architecture behv of xmux4w16r is

	signal	omuxr		: std_logic_vector(15 downto 0);
	signal	omuxi		: std_logic_vector(15 downto 0);
	
component xdsp_mux4w16r
  port( ma 	: in  std_logic_vector( 16 -1 DOWNTO 0 );
        mb 	: in  std_logic_vector( 16 -1 DOWNTO 0 );
        mc 	: in  std_logic_vector( 16 -1 DOWNTO 0 );
        md 	: in  std_logic_vector( 16 -1 DOWNTO 0 );
        clk	: in std_logic;
        ce	: in std_logic;
 	s	: in std_logic_vector(1 downto 0);
        q 	: out std_logic_vector( 16 -1 DOWNTO 0 ) );
end component;

attribute RLOC : string;
attribute RLOC of mux4w16_r : label is "R0C0";
attribute RLOC of mux4w16_i : label is "R13C9";
--attribute RLOC of muxreg_r  : label is "R0C0";
--attribute RLOC of muxreg_i  : label is "R13C9";

begin

mux4w16_r : xdsp_mux4w16r
	port map(
		ma		=> x0r,
		mb		=> x1r,
		mc		=> x2r,
		md		=> x3r,
		clk		=> clk,
		ce		=> ce,
		s(0)		=> s0,
		s(1)		=> s1,
		q		=> yr		
	);
	
mux4w16_i : xdsp_mux4w16r
	port map(
		ma		=> x0i,
		mb		=> x1i,
		mc		=> x2i,
		md		=> x3i,
	       	clk		=> clk,
	       	ce 		=> ce,	
		s(0)		=> s0,
		s(1)		=> s1,
		q		=> yi		
	);
		
end behv;
-- Virtex FFT
-- complex 4:1 16-bit registered multiplexor

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;
		
entity xmux4w16rb is
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		s0		: in std_logic;				-- mux select inputs
		s1		: in std_logic;
		x0r		: in std_logic_vector(15 downto 0);	-- mux inputs Re and Im
		x0i		: in std_logic_vector(15 downto 0);
		x1r		: in std_logic_vector(15 downto 0);	
		x1i		: in std_logic_vector(15 downto 0);
		x2r		: in std_logic_vector(15 downto 0);	
		x2i		: in std_logic_vector(15 downto 0);
		x3r		: in std_logic_vector(15 downto 0);	
		x3i		: in std_logic_vector(15 downto 0);
		yr		: out std_logic_vector(15 downto 0);	-- mux outputs
		yi		: out std_logic_vector(15 downto 0)
	      );
end xmux4w16rb;

architecture behv of xmux4w16rb is

	signal	omuxr		: std_logic_vector(15 downto 0);
	signal	omuxi		: std_logic_vector(15 downto 0);
	
component xdsp_mux4w16r
  port( ma 	: in  std_logic_vector( 16 -1 DOWNTO 0 );
        mb 	: in  std_logic_vector( 16 -1 DOWNTO 0 );
        mc 	: in  std_logic_vector( 16 -1 DOWNTO 0 );
        md 	: in  std_logic_vector( 16 -1 DOWNTO 0 );
        clk	: in std_logic;
        ce	: in std_logic;
 	s	: in std_logic_vector(1 downto 0);
        q 	: out std_logic_vector( 16 -1 DOWNTO 0 ) );
end component;

attribute RLOC : string;
attribute RLOC of mux4w16_r : label is "R0C0";
attribute RLOC of mux4w16_i : label is "R0C1";

begin

mux4w16_r : xdsp_mux4w16r
	port map(
		ma		=> x0r,
		mb		=> x1r,
		mc		=> x2r,
		md		=> x3r,
		clk		=> clk,
		ce		=> ce,
		s(0)		=> s0,
		s(1)		=> s1,
		q		=> yr		
	);
	
mux4w16_i : xdsp_mux4w16r
	port map(
		ma		=> x0i,
		mb		=> x1i,
		mc		=> x2i,
		md		=> x3i,
	       	clk		=> clk,
	       	ce 		=> ce,	
		s(0)		=> s0,
		s(1)		=> s1,
		q		=> yi		
	);
		
end behv;
-- complex 2:1 16-bit registered multiplexor

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;

library xilinxcorelib;
	use xilinxcorelib.fft_defsx_1024.all;
			
entity xmux2w16r is
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		s0		: in std_logic;				-- mux select inputs
		x0r		: in std_logic_vector(15 downto 0);	-- mux inputs Re and Im
		x0i		: in std_logic_vector(15 downto 0);
		x1r		: in std_logic_vector(15 downto 0);	
		x1i		: in std_logic_vector(15 downto 0);
		yr		: out std_logic_vector(15 downto 0);	-- mux outputs
		yi		: out std_logic_vector(15 downto 0)
	      );
end xmux2w16r;

architecture struct of xmux2w16r is

	signal	omuxr		: std_logic_vector(15 downto 0);
	signal	omuxi		: std_logic_vector(15 downto 0);
	
component xdsp_mux2w16r
  port( ma 	: in  std_logic_vector(B-1 DOWNTO 0);
        mb 	: in  std_logic_vector(B-1 DOWNTO 0);
        clk	: in  std_logic;
        ce	: in  std_logic;        
        s 	: in  std_logic_vector(0 downto 0);
        q  	: out std_logic_vector(B-1 DOWNTO 0));
end component;								  

attribute RLOC : string;
attribute RLOC of mux2w16_r : label is "R0C0";
attribute RLOC of mux2w16_i : label is "R8C0";

begin

mux2w16_r : xdsp_mux2w16r
	port map(
		ma		=> x0r,
		mb		=> x1r,
		clk		=> clk,
		ce		=> ce,
		s(0)		=> s0,
		q		=> yr
	);
	
mux2w16_i : xdsp_mux2w16r
	port map(
		ma		=> x0i,
		mb		=> x1i,
		clk		=> clk,
		ce		=> ce,		
		s(0)		=> s0,
		q		=> yi
	);	
	
end struct;
-- Virtex FFT
-- radix-2 butterfly, phase factor w=0

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;

library xilinxcorelib;
	use xilinxcorelib.fft_defsx_1024.all;	

entity bflyw0_16 is
	port (
		clk		: in std_logic;		-- mast clock
		ce		: in std_logic;		-- master clock enable
		start_fft4	: in std_logic;		-- start 4-point FFT
		x0r		: in std_logic_vector(B-1 downto 0);  -- Re operand 0
		x0i		: in std_logic_vector(B-1 downto 0);  -- Im operand 0	
		x1r		: in std_logic_vector(B-1 downto 0);  -- Re operand 1
		x1i		: in std_logic_vector(B-1 downto 0);  -- Im operand 1	
		y0r		: out std_logic_vector(B downto 0);   -- Re result 0
		y0i		: out std_logic_vector(B downto 0);   -- Im result 0	
		y1r		: out std_logic_vector(B downto 0);   -- Re result 1
		y1i		: out std_logic_vector(B downto 0)    -- Im result 1		
	);
end bflyw0_16;

architecture struct of bflyw0_16 is

	signal	raddr_ci	: std_logic;
	signal	raddr_clr	: std_logic;
	signal	raddi_ci	: std_logic;
	signal	raddi_clr	: std_logic;
	signal	rsubr_ci	: std_logic;
	signal	rsubr_clr	: std_logic;
	signal	rsubi_ci	: std_logic;
	signal	rsubi_clr	: std_logic;
	signal	ce_bfly		: std_logic;
	
component xdsp_radd16
  PORT( a 	: IN  std_logic_vector(B-1 DOWNTO 0);
        b 	: IN  std_logic_vector(B-1 DOWNTO 0);
        clk 	: IN  std_logic;
        ce 	: IN  std_logic;
        c_in 	: IN  std_logic;
        q 	: OUT std_logic_vector(16 DOWNTO 0));
END component;

component xdsp_rsub16b
  PORT( a 	: IN  std_logic_vector(B-1 DOWNTO 0);
        b 	: IN  std_logic_vector(B-1 DOWNTO 0);
        clk 	: IN  std_logic;
        ce 	: IN  std_logic;
        b_in 	: IN  std_logic;
        q 	: OUT std_logic_vector(16 DOWNTO 0));
END component;

attribute RLOC : string;
attribute RLOC of raddr : label is "R0C0";
attribute RLOC of raddi : label is "R9C0";
attribute RLOC of rsubr : label is "R0C0";
attribute RLOC of rsubi : label is "R9C0";

begin

raddr : xdsp_radd16 
	port map(
		a		=> x0r,
		b		=> x1r,
		clk		=> clk,
		ce		=> ce_bfly,
		c_in		=> raddr_ci,
		q		=> y0r	
	);

raddi : xdsp_radd16 
	port map(
		a		=> x0i,
		b		=> x1i,
		clk		=> clk,
		ce		=> ce_bfly,
		c_in		=> raddi_ci,
		q		=> y0i	
	);

rsubr : xdsp_rsub16b 
	port map(
		a		=> x0r,
		b		=> x1r,
		clk		=> clk,
		ce		=> ce_bfly,
		b_in		=> rsubr_ci,
		q		=> y1r	
	);

rsubi : xdsp_rsub16b 
	port map(
		a		=> x0i,
		b		=> x1i,
		clk		=> clk,
		ce		=> ce_bfly,
		b_in		=> rsubi_ci,
		q		=> y1i	
	);
	ce_bfly <= ce and start_fft4;
	raddr_clr <= '0';
	raddr_ci <= '0';
	raddi_clr <= '0';
	raddi_ci <= '0';
	rsubr_clr <= '0';
	rsubr_ci <= '1';
	rsubi_clr <= '0';
	rsubi_ci <= '1';	
end struct;
-- Virtex FFT
-- radix-2 butterfly, phase factor w=-j

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;

library xilinxcorelib;
	use xilinxcorelib.fft_defsx_1024.all;	


entity bflywj_16 is
	port (
		clk		: in std_logic;				-- mast clock
		ce		: in std_logic;				-- master clock enable
		start_fft4	: in std_logic;				-- start 4-point FFT
		x0r		: in std_logic_vector(B-1 downto 0);  	-- Re operand 0
		x0i		: in std_logic_vector(B-1 downto 0);  	-- Im operand 0	
		x1r		: in std_logic_vector(B-1 downto 0);  	-- Re operand 1
		x1i		: in std_logic_vector(B-1 downto 0);  	-- Im operand 1	
		y0r		: out std_logic_vector(B downto 0);	-- Re result 0
		y0i		: out std_logic_vector(B downto 0); 	-- Im result 0	
		y1r		: out std_logic_vector(B downto 0); 	-- Re result 1
		y1i		: out std_logic_vector(B downto 0)  	-- Im result 1		
	);
end bflywj_16;

architecture struct of bflywj_16 is

	signal	raddr_ci	: std_logic;
	signal	raddr_clr	: std_logic;
	signal	raddi_ci	: std_logic;
	signal	raddi_clr	: std_logic;
	signal	rsubr_ci	: std_logic;
	signal	rsubr_clr	: std_logic;
	signal	rsubi_ci	: std_logic;
	signal	rsubi_clr	: std_logic;
	signal	ce_bfly		: std_logic;
	
component xdsp_radd16
  PORT( a 	: IN  std_logic_vector(B-1 DOWNTO 0);
        b 	: IN  std_logic_vector(B-1 DOWNTO 0);
        clk 	: IN  std_logic;
        ce 	: IN  std_logic;
        c_in 	: IN  std_logic;
        q 	: OUT std_logic_vector(16 DOWNTO 0));
END component;

component xdsp_rsub16b
  PORT( a 	: IN  std_logic_vector(B-1 DOWNTO 0);
        b 	: IN  std_logic_vector(B-1 DOWNTO 0);
        clk 	: IN  std_logic;
        ce 	: IN  std_logic;
        b_in 	: IN  std_logic;
        q 	: OUT std_logic_vector(16 DOWNTO 0));
END component;

attribute RLOC : string;
attribute RLOC of raddr : label is "R0C0";
attribute RLOC of raddi : label is "R9C0";
attribute RLOC of rsubr : label is "R0C0";
attribute RLOC of rsubi : label is "R9C0";

begin

raddr : xdsp_radd16 
	port map(
		a		=> x0r,
		b		=> x1r,
		clk		=> clk,
		ce		=> ce_bfly,
		c_in		=> raddr_ci,
		q		=> y0r	
	);

raddi : xdsp_radd16 
	port map(
		a		=> x0i,
		b		=> x1i,
		clk		=> clk,
		ce		=> ce_bfly,
		c_in		=> raddi_ci,
		q		=> y0i	
	);

rsubr : xdsp_rsub16b 
	port map(
		a		=> x0i,
		b		=> x1i,
		clk		=> clk,
		ce		=> ce_bfly,
		b_in		=> rsubr_ci,
		q		=> y1r	
	);

rsubi : xdsp_rsub16b 
	port map(
		a		=> x1r,
		b		=> x0r,
		clk		=> clk,
		ce		=> ce_bfly,
		b_in		=> rsubi_ci,
		q		=> y1i	
	);
	ce_bfly <= ce and start_fft4;
	raddr_clr <= '0';
	raddr_ci <= '0';
	raddi_clr <= '0';
	raddi_ci <= '0';
	rsubr_clr <= '0';
	rsubr_ci <= '1';
	rsubi_clr <= '0';
	rsubi_ci <= '1';	
end struct;
-- Virtex  FFT
-- radix-2 butterfly, phase factor w=0
-- 17-bit arithmetic, 17-bit input operands and 18-bit outputs

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;

library xilinxcorelib;
	use xilinxcorelib.fft_defsx_1024.all;	

entity bflyw0_17 is
	port (
		clk		: in std_logic;		-- mast clock
		ce		: in std_logic;		-- master clock enable
		start_fft4	: in std_logic;		-- start 4-point FFT
		x0r		: in std_logic_vector(B downto 0);  -- Re operand 0
		x0i		: in std_logic_vector(B downto 0);  -- Im operand 0	
		x1r		: in std_logic_vector(B downto 0);  -- Re operand 1
		x1i		: in std_logic_vector(B downto 0);  -- Im operand 1	
		y0r		: out std_logic_vector(B+1 downto 0); -- Re result 0
		y0i		: out std_logic_vector(B+1 downto 0); -- Im result 0	
		y1r		: out std_logic_vector(B+1 downto 0); -- Re result 1
		y1i		: out std_logic_vector(B+1 downto 0)  -- Im result 1		
	);
end bflyw0_17;

architecture struct of bflyw0_17 is

	signal	raddr_ci	: std_logic;
	signal	raddr_clr	: std_logic;
	signal	raddi_ci	: std_logic;
	signal	raddi_clr	: std_logic;
	signal	rsubr_ci	: std_logic;
	signal	rsubr_clr	: std_logic;
	signal	rsubi_ci	: std_logic;
	signal	rsubi_clr	: std_logic;
	signal	ce_bfly		: std_logic;
	
component xdsp_radd17
  PORT( a 	: IN  std_logic_vector(B DOWNTO 0 );
        b 	: IN  std_logic_vector(B  DOWNTO 0 );
        clk 	: IN  std_logic;
        ce 	: IN  std_logic;
        c_in 	: IN  std_logic;
        q 	: OUT std_logic_vector(17 DOWNTO 0 ));
END component;

component xdsp_rsub17b
  PORT( a 	: IN  std_logic_vector(B DOWNTO 0 );
        b 	: IN  std_logic_vector(B  DOWNTO 0 );
        clk 	: IN  std_logic;
        ce 	: IN  std_logic;
        b_in 	: IN  std_logic;
        q 	: OUT std_logic_vector(17 DOWNTO 0 ));
END component;	  

attribute RLOC : string;
attribute RLOC of raddr : label is "R0C0";
attribute RLOC of raddi : label is "R9C0";
attribute RLOC of rsubr : label is "R0C0";
attribute RLOC of rsubi : label is "R9C0";			

begin

raddr : xdsp_radd17 
	port map(
		a		=> x0r,
		b		=> x1r,
		clk		=> clk,
		ce		=> ce_bfly,
		c_in		=> raddr_ci,
		q		=> y0r	
	);

raddi : xdsp_radd17 
	port map(
		a		=> x0i,
		b		=> x1i,
		clk		=> clk,
		ce		=> ce_bfly,
		c_in		=> raddi_ci,
		q		=> y0i	
	);

rsubr : xdsp_rsub17b 
	port map(
		a		=> x0r,
		b		=> x1r,
		clk		=> clk,
		ce		=> ce_bfly,
		b_in		=> rsubr_ci,
		q		=> y1r	
	);

rsubi : xdsp_rsub17b
	port map(
		a		=> x0i,
		b		=> x1i,
		clk		=> clk,
		ce		=> ce_bfly,
		b_in		=> rsubi_ci,
		q		=> y1i	
	);
	ce_bfly <= ce and start_fft4;
	raddr_clr <= '0';
	raddr_ci <= '0';
	raddi_clr <= '0';
	raddi_ci <= '0';
	rsubr_clr <= '0';
	rsubr_ci <= '1';
	rsubi_clr <= '0';
	rsubi_ci <= '1';	
end struct;
-- Synopsis: 4-point FFT module

-- ************************************************************************
--  Copyright 1996-2000 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;

library xilinxcorelib;
	use xilinxcorelib.fft_defsx_1024.all;	

	
entity fft4 is
	port (
		clk		: in std_logic;				-- system clock
		rs		: in std_logic;				-- reset
		start		: in std_logic;				-- global start
		ce		: in std_logic;
		conj		: in std_logic;				-- conjugation control
									-- conjugates when == 0
		dr		: in std_logic_vector(B-1 downto 0);	-- data input
		di		: in std_logic_vector(B-1 downto 0);
		y0r		: out std_logic_vector(B-1 downto 0);	-- transform outp. samples
		y0i		: out std_logic_vector(B-1 downto 0);
		y1r		: out std_logic_vector(B-1 downto 0);
		y1i		: out std_logic_vector(B-1 downto 0);
		y2r		: out std_logic_vector(B-1 downto 0);
		y2i		: out std_logic_vector(B-1 downto 0);
		y3r		: out std_logic_vector(B-1 downto 0);
		y3i		: out std_logic_vector(B-1 downto 0)
	      );
end fft4;

architecture struct of fft4 is

		signal ce0		: std_logic;		-- sample reg. ld enables
		signal ce1		: std_logic;
		signal ce2		: std_logic;
		signal ce3		: std_logic;
		signal cex0		: std_logic;		-- sample reg. ld enables
		signal cex1		: std_logic;
		signal cex2		: std_logic;
		signal cex3		: std_logic;
		signal start_fft4	: std_logic;		-- start 4-point FFT
		-- registered samples presented to 4-point FFT
		signal x0r		: std_logic_vector(B-1 downto 0); 
		signal x0i		: std_logic_vector(B-1 downto 0); 
		signal x1r		: std_logic_vector(B-1 downto 0); 
		signal x1i		: std_logic_vector(B-1 downto 0); 
		signal x2r		: std_logic_vector(B-1 downto 0); 
		signal x2i		: std_logic_vector(B-1 downto 0); 
		signal x3r		: std_logic_vector(B-1 downto 0); 
		signal x3i		: std_logic_vector(B-1 downto 0); 
		-- registered outputs for butterfly #0
		signal	b0_y0r		: std_logic_vector(B downto 0);
		signal	b0_y0i		: std_logic_vector(B downto 0);
		signal	b0_y1r		: std_logic_vector(B downto 0);
		signal	b0_y1i		: std_logic_vector(B downto 0);
		-- registered output for butterfly #1
		signal	b1_y0r		: std_logic_vector(B downto 0);
		signal	b1_y0i		: std_logic_vector(B downto 0);
		signal	b1_y1r		: std_logic_vector(B downto 0);
		signal	b1_y1i		: std_logic_vector(B downto 0);
		-- registered output for butterfly #2
		signal	b2_y0r		: std_logic_vector(B+1 downto 0);
		signal	b2_y0i		: std_logic_vector(B+1 downto 0);
		signal	b2_y1r		: std_logic_vector(B+1 downto 0);
		signal	b2_y1i		: std_logic_vector(B+1 downto 0);
		-- registered output for butterfly #3
		signal	b3_y0r		: std_logic_vector(B+1 downto 0);
		signal	b3_y0i		: std_logic_vector(B+1 downto 0);
		signal	b3_y1r		: std_logic_vector(B+1 downto 0);
		signal	b3_y1i		: std_logic_vector(B+1 downto 0);
		signal	conji		: std_logic;

component cmplx_reg16_conj
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
end component;

component cmplx_reg16_conjb
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		conj		: in std_logic;				-- conjugation control
									-- forms conjugation when ==1
		dr		: in std_logic_vector(15 downto 0);	-- Re/Im data in
		di		: in std_logic_vector(15 downto 0);
		qr		: out std_logic_vector(15 downto 0);	-- Re/Im data out
		qi		: out std_logic_vector(15 downto 0)
	      );
end component;

component state_mach
	port (
		clk		: in std_logic;				-- system clock
		rs		: in std_logic;				-- reset
		start		: in std_logic;				-- global start 
		ce		: in std_logic;				-- global clk enable
		s0		: out std_logic;			-- state outputs
		s1		: out std_logic;
		s2		: out std_logic;
		s3		: out std_logic
	      );
end component;

component bflyw0_16
	port (
		clk		: std_logic;		-- mast clock
		ce		: std_logic;		-- master clock enable
		start_fft4	: std_logic;		-- start 4-point FFT
		x0r		: in std_logic_vector(B-1 downto 0); -- Re operand 0
		x0i		: in std_logic_vector(B-1 downto 0); -- Im operand 0	
		x1r		: in std_logic_vector(B-1 downto 0); -- Re operand 1
		x1i		: in std_logic_vector(B-1 downto 0); -- Im operand 1	
		y0r		: out std_logic_vector(B downto 0); -- Re result 0
		y0i		: out std_logic_vector(B downto 0); -- Im result 0	
		y1r		: out std_logic_vector(B downto 0); -- Re result 1
		y1i		: out std_logic_vector(B downto 0)  -- Im result 1		
	);
end component;

component bflywj_16
	port (
		clk		: std_logic;		-- mast clock
		ce		: std_logic;		-- master clock enable
		start_fft4	: std_logic;		-- start 4-point FFT
		x0r		: in std_logic_vector(B-1 downto 0); -- Re operand 0
		x0i		: in std_logic_vector(B-1 downto 0); -- Im operand 0	
		x1r		: in std_logic_vector(B-1 downto 0); -- Re operand 1
		x1i		: in std_logic_vector(B-1 downto 0); -- Im operand 1	
		y0r		: out std_logic_vector(B downto 0); -- Re result 0
		y0i		: out std_logic_vector(B downto 0); -- Im result 0	
		y1r		: out std_logic_vector(B downto 0); -- Re result 1
		y1i		: out std_logic_vector(B downto 0)  -- Im result 1		
	);
end component;

component bflyw0_17
	port (
		clk		: std_logic;		-- mast clock
		ce		: std_logic;		-- master clock enable
		start_fft4	: std_logic;		-- start 4-point FFT
		x0r		: in std_logic_vector(B downto 0); -- Re operand 0
		x0i		: in std_logic_vector(B downto 0); -- Im operand 0	
		x1r		: in std_logic_vector(B downto 0); -- Re operand 1
		x1i		: in std_logic_vector(B downto 0); -- Im operand 1	
		y0r		: out std_logic_vector(B+1 downto 0); -- Re result 0
		y0i		: out std_logic_vector(B+1 downto 0); -- Im result 0	
		y1r		: out std_logic_vector(B+1 downto 0); -- Re result 1
		y1i		: out std_logic_vector(B+1 downto 0)  -- Im result 1		
	);
end component;

attribute RLOC : string;
attribute RLOC of x0_reg : label is "R0C0";
attribute RLOC of x1_reg : label is "R0C0";
attribute RLOC of x2_reg : label is "R0C1";
attribute RLOC of x3_reg : label is "R0C1";
attribute RLOC of b0 : label is "R0C2";
attribute RLOC of b1 : label is "R0C3";
attribute RLOC of b2 : label is "R0C4";
attribute RLOC of b3 : label is "R0C5";

begin

smach : state_mach
	port map(
		clk		=> clk,
		rs		=> rs,
		start		=> start,
		ce		=> ce,
		s0		=> cex0,
		s1		=> cex1,
		s2		=> cex2,
		s3		=> cex3
	);

x0_reg : cmplx_reg16_conj
	port map(
		clk		=> clk,
		ce		=> ce0,
		conj		=> conji,
		dr		=> dr,
		di		=> di,
		qr		=> x0r,			-- Re(x(0))
		qi		=> x0i			-- Im(x(0))
	);

x1_reg : cmplx_reg16_conjb
	port map(
		clk		=> clk,
		ce		=> ce1,
		conj		=> conji,
		dr		=> dr,
		di		=> di,
		qr		=> x1r,			-- Re(x(1))
		qi		=> x1i			-- Im(x(1))
	);
	
x2_reg : cmplx_reg16_conj
	port map(
		clk		=> clk,
		ce		=> ce2,
		conj		=> conji,
		dr		=> dr,
		di		=> di,
		qr		=> x2r,			-- Re(x(2))
		qi		=> x2i			-- Im(x(2))
	);

x3_reg : cmplx_reg16_conjb
	port map(
		clk		=> clk,
		ce		=> ce3,
		conj		=> conji,
		dr		=> dr,
		di		=> di,
		qr		=> x3r,			-- Re(x(3))
		qi		=> x3i			-- Im(x(3))
	);
	
b0 : bflyw0_16
	port map (
		clk		=> clk,			-- mast clock
		ce		=> ce,			-- master clock enable
		start_fft4	=> start_fft4,
		x0r		=> x0r,
		x0i		=> x0i,	
		x1r		=> x2r,
		x1i		=> x2i,	
		y0r		=> b0_y0r,
		y0i		=> b0_y0i,	
		y1r		=> b0_y1r,	
		y1i		=> b0_y1i
	);
	
b1 : bflywj_16
	port map (
		clk		=> clk,			-- mast clock
		ce		=> ce,			-- master clock enable
		start_fft4	=> start_fft4,
		x0r		=> x1r,
		x0i		=> x1i,	
		x1r		=> x3r,
		x1i		=> x3i,	
		y0r		=> b1_y0r,
		y0i		=> b1_y0i,	
		y1r		=> b1_y1r,	
		y1i		=> b1_y1i
	);

b2 : bflyw0_17
	port map (
		clk		=> clk,			-- mast clock
		ce		=> ce,			-- master clock enable
		start_fft4	=> start_fft4,
		x0r		=> b0_y0r,
		x0i		=> b0_y0i,	
		x1r		=> b1_y0r,
		x1i		=> b1_y0i,	
		y0r		=> b2_y0r,
		y0i		=> b2_y0i,	
		y1r		=> b2_y1r,	
		y1i		=> b2_y1i
	);	
b3 : bflyw0_17
	port map (
		clk		=> clk,			-- mast clock
		ce		=> ce,			-- master clock enable
		start_fft4	=> start_fft4,
		x0r		=> b0_y1r,
		x0i		=> b0_y1i,	
		x1r		=> b1_y1r,
		x1i		=> b1_y1i,	
		y0r		=> b3_y0r,
		y0i		=> b3_y0i,	
		y1r		=> b3_y1r,	
		y1i		=> b3_y1i
	);	
			
	start_fft4 <= ce and cex0;
	ce0 <= ce and cex0;	
	ce1 <= ce and cex1;
	ce2 <= ce and cex2;
	ce3 <= ce and cex3;
	y0r <= b2_y0r(B+1 downto 2);
	y0i <= b2_y0i(B+1 downto 2);
	y1r <= b3_y0r(B+1 downto 2);
	y1i <= b3_y0i(B+1 downto 2);
	y2r <= b2_y1r(B+1 downto 2);
	y2i <= b2_y1i(B+1 downto 2);
	y3r <= b3_y1r(B+1 downto 2);
	y3i <= b3_y1i(B+1 downto 2);
	conji <= conj;					--not conj;	
			
end struct;





-- dragonfly processor

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;
	
entity dragonfly_1024 is
	port (
		clk		: in std_logic;		-- system clock
		rs		: in std_logic;		-- reset
		start		: in std_logic;		-- start transform
		ce		: in std_logic;		-- master clk enable
		conj		: in std_logic;		-- conjugation control
		xnr		: in std_logic_vector(15 downto 0);
		xni		: in std_logic_vector(15 downto 0);
		wr		: in std_logic_vector(15 downto 0);	-- phase factors
		wi		: in std_logic_vector(15 downto 0);
		xk_r		: out std_logic_vector(16 downto 0);
		xk_i		: out std_logic_vector(16 downto 0)
	      );
end dragonfly_1024;

architecture struct of dragonfly_1024 is

	-- fft4 output mux selects
	signal	fft4_omux_s0		: std_logic;
	signal	fft4_omux_s1		: std_logic;
	signal	fft4_omux_state_cntr	: std_logic_vector(1 downto 0);
	
	-- 4-point FFT output samples
	signal	y0r			: std_logic_vector(15 downto 0);
	signal	y0i			: std_logic_vector(15 downto 0);
	signal	y1r			: std_logic_vector(15 downto 0);
	signal	y1i			: std_logic_vector(15 downto 0);
	signal	y2r			: std_logic_vector(15 downto 0);
	signal	y2i			: std_logic_vector(15 downto 0);
	signal	y3r			: std_logic_vector(15 downto 0);
	signal	y3i			: std_logic_vector(15 downto 0);
	
	-- output of multiplexor that selects the output samples from the 4-point FFT
	signal	tr			: std_logic_vector(15 downto 0);
	signal	ti			: std_logic_vector(15 downto 0);
	
component fft4
	port (
		clk		: in std_logic;				-- system clock
		rs		: in std_logic;				-- reset
		start		: in std_logic;				-- global start
		ce		: in std_logic;
		conj		: in std_logic;
		dr		: in std_logic_vector(15 downto 0);
		di		: in std_logic_vector(15 downto 0);
		y0r		: out std_logic_vector(15 downto 0);
		y0i		: out std_logic_vector(15 downto 0);
		y1r		: out std_logic_vector(15 downto 0);
		y1i		: out std_logic_vector(15 downto 0);
		y2r		: out std_logic_vector(15 downto 0);
		y2i		: out std_logic_vector(15 downto 0);
		y3r		: out std_logic_vector(15 downto 0);
		y3i		: out std_logic_vector(15 downto 0)
	      );
end component;

component xmux4w16r
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		s0		: in std_logic;				-- mux select inputs
		s1		: in std_logic;
		x0r		: in std_logic_vector(15 downto 0);	-- mux inputs Re and Im
		x0i		: in std_logic_vector(15 downto 0);
		x1r		: in std_logic_vector(15 downto 0);	
		x1i		: in std_logic_vector(15 downto 0);
		x2r		: in std_logic_vector(15 downto 0);	
		x2i		: in std_logic_vector(15 downto 0);
		x3r		: in std_logic_vector(15 downto 0);	
		x3i		: in std_logic_vector(15 downto 0);
		yr		: out std_logic_vector(15 downto 0);	-- mux outputs
		yi		: out std_logic_vector(15 downto 0)
	      );
end component;

-- 16 x 17 complex multiplier
component xmul16x17
	port (
		clk		: in std_logic;		-- system clock
		rs		: in std_logic;		-- reset
		ce		: in std_logic;		-- master clk enable
		ar		: in std_logic_vector(15 downto 0);  	-- Re(operand 1)
		ai		: in std_logic_vector(15 downto 0);	-- Im(operand 1)
		br		: in std_logic_vector(15 downto 0);	-- Re(operand 2)
		bi		: in std_logic_vector(15 downto 0);	-- Im(operand 2)
		pr		: out std_logic_vector(16 downto 0);	-- Re( a x b)
		pi		: out std_logic_vector(16 downto 0)	-- Im( a x b)
	      );
end component;

attribute RLOC : string;
attribute RLOC of xfft4 : label is "R0C0"; 
attribute RLOC of fft4_omux : label is "R0C6";
attribute RLOC of xmul : label is "R0C7";

-- 4-point FFT port mappings
-- This small transform is applied to the input data prior to processing by the
-- complex multiplier

begin

xfft4 : fft4
	port map (
		clk		=> clk,				-- system clock
		rs		=> rs,				-- reset
		start		=> start,			-- global start
		ce		=> ce,				-- master clk enable
		conj		=> conj,
		dr		=> xnr,				-- Re/Im input sample
		di		=> xni,
		y0r		=> y0r,				-- output samples
		y0i		=> y0i,
		y1r		=> y1r,
		y1i		=> y1i,
		y2r		=> y2r,
		y2i		=> y2i,
		y3r		=> y3r,
		y3i		=> y3i		
	);

fft4_omux : xmux4w16r 
	port map (
		clk		=> clk,			-- system clock
		ce		=> ce,			-- global clk enable
		s0		=> fft4_omux_s0,	-- mux select inputs
		s1		=> fft4_omux_s1,
		x0r		=> y2r,	
		x0i		=> y2i,
		x1r		=> y3r,	
		x1i		=> y3i,
		x2r		=> y0r,	
		x2i		=> y0i,
		x3r		=> y1r,	
		x3i		=> y1i,
		yr		=> tr,			-- sample presented to cmplx mul
		yi		=> ti
	);

-- complex product 
-- This module accepts outputs from the 4-point FFT 'xfft4' and applies
-- the phase rotations read from the phase factor trig LUT
-- The complex samples from the xfft4 unit are presented to the complex multiplier
-- via the 4:1 complex mutliplexor 'fft4_omux'.

xmul : xmul16x17 
	port map(
		clk		=> clk,		-- system clock
		rs		=> rs,		-- reset
		ce		=> ce,		-- master clk enable
		ar		=> tr, 		-- Re(operand 1)
		ai		=> ti,		-- Im(operand 1)
		br		=> wr,		-- Re(operand 2)
		bi		=> wi,		-- Im(operand 2)
		pr		=> xk_r,	-- output: Re( a x b)
		pi		=> xk_i		-- output: Im( a x b)
	      );
	      
-- rank-0 4-point FFT state machine

fft4_omux_state_mach : process(clk,rs,ce,start)
begin
	if (rs = '1' or start = '1') then
		fft4_omux_state_cntr <= "00";
	elsif (clk'event and clk='1') then
		if (ce = '1') then
			fft4_omux_state_cntr <= fft4_omux_state_cntr + 1;
		end if;	
	end if;
end process;

	fft4_omux_s0 <= fft4_omux_state_cntr(0);
	fft4_omux_s1 <= fft4_omux_state_cntr(1);
	
end struct;
-- Synopsis: phase factor address generator for N=1024 FFT

-- ************************************************************************
--  Copyright (C) 1998, 1999 - Xilinx, Inc.
-- ************************************************************************
-- This file is (c) Xilinx, Inc. 1998.  No part of this file may be modified, 
-- transmitted to any third party (other than as intended by Xilinx) or used 
-- without a Xilinx programmable or hardwire device without Xilinx's prior 
-- written permission.
--

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;
    --use ieee.std_logic_unsigned.all;
    use ieee.std_logic_unsigned."+";
        
library xilinxcorelib;
    use xilinxcorelib.fft_defsx_1024.all;	
    
entity phase_agen_1024 is
    port (
    	    clk			: in std_logic;		-- global clock
    	    ce			: in std_logic;		-- global clock enable
    	    start		: in std_logic;		-- system start
    	    rs			: in std_logic;		-- master reset
    	    result		: in std_logic;		-- result=1 indicates the
    	    						-- final rank is being processed  
    	    dma			: in std_logic;
    	    io			: in std_logic;						  	    
    	    phase_addr		: out std_logic_vector(log2_nfft-1 downto 0)	-- phase angle
    );
end phase_agen_1024;

architecture phase_agen_arch of phase_agen_1024 is

    signal kinc			: std_logic_vector(log2_nfft-2 downto 0);
    signal kincm		: std_logic_vector(log2_nfft-1 downto 0);
    signal tmp_kincm		: std_logic_vector(B-1 downto 0);
    signal tmp_kinc		: std_logic_vector(B-1 downto 0);
    
    -- butterfly counter
    signal bfli			: std_logic_vector(log2_nfft-1 downto 0);
    signal nxt_rank		: std_logic;	-- indicates the start of a new rank
    signal bfly			: std_logic_vector(log2_nfft-1 downto 0);   
    signal reset_bfly		: std_logic;
    signal pinco		: std_logic_vector(log2_nfft-2 downto 0);
    signal nxt_bfly		: std_logic;
    signal k1,k2                : std_logic_vector(B-1 downto 0);    
    signal logic0		: std_logic;
    signal load_sr		: std_logic;
    signal phase_addr_i		: std_logic_vector(log2_nfft-1 downto 0);
    signal sclr_a		: std_logic;
	signal sclr_b 		: std_logic;
	
component shift_reg2b
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		load		: in std_logic;
		din		: in std_logic_vector(B-1 downto 0);
		ser_data_in0	: in std_logic;
		ser_data_in1	: in std_logic;
		par_data	: inout std_logic_vector(B-1 downto 0)
	);
end component; 

component xdsp_cnt10
	port (clk		: in std_logic;		
		  ce	: in std_logic;		   
	      q		: out std_logic_vector(9 downto 0);
		  sclr 	: in std_logic);
end component;	 

attribute RLOC : string;
attribute RLOC of bfli_cntr : label is "R0C0"; 
attribute RLOC of bfly_cntr : label is "R0C1";

begin

sr1 : shift_reg2b
	port map(
	 	clk		=> clk,
	 	ce		=> nxt_rank,
	 	rs		=> rs,
	 	load		=> load_sr,
	 	din		=> k1,
	 	ser_data_in0	=> logic0,
	 	ser_data_in1	=> logic0,
	 	par_data	=> tmp_kinc
	);
	
sr2 : shift_reg2b
	port map(
	 	clk		=> clk,
	 	ce		=> nxt_rank,
	 	rs		=> rs,
	 	load		=> load_sr,
	 	din		=> k2,
	 	ser_data_in0	=> logic0,
	 	ser_data_in1	=> logic0,
	 	par_data	=> tmp_kincm
	);

sclr_a <= start or rs;

bfli_cntr : xdsp_cnt10
	port map (clk		=> clk,
		  q		=> bfli,
		  ce		=> ce,
		  sclr    	=> sclr_a);	  
					
--process(clk,ce,start,rs)
--begin	
--	if clk'event and clk = '1' then
--	    if ce = '1' then
--	        if start = '1' or rs = '1' then
--	            bfli <= (others => '0');
--	        else
--	            bfli <= bfli + 1;
--	        end if; 
--	    end if;
--	end if;
--end process bfli_update;

sclr_b <= start or rs or reset_bfly;

bfly_cntr : xdsp_cnt10
	port map (clk		=> clk,
		  q		=> bfly,
		  ce		=> ce,
		  sclr    	=> sclr_b);

--process(clk,ce,start,rs,reset_bfly)
--begin	
--	if clk'event and clk = '1' then
--	    if ce = '1' then
--	        if start = '1' or rs = '1' or reset_bfly = '1' then
--	            bfly <= (others => '0');
--	        else
--	            bfly <= bfly + 1;
--	        end if; 
--	    end if;
--	end if;
--end process bfly_update;

new_rank : process(clk,start,rs)
begin
	if clk'event and clk = '1' then
	    if start = '1' or rs = '1' then
	        nxt_rank <= '0';
	    elsif bfli = "1111111110" then	--conv_std_logic_vector(nfft-2,bfli'length) then
	        nxt_rank <= '1';
	    else
	        nxt_rank <= '0';
	    end if;
	end if;
end process new_rank;

rs_bfly : process(clk,ce,rs,start,kincm,bfly)
begin
    if clk'event and clk = '1' then
        if start = '1' or rs = '1' then
            reset_bfly <= '0';			
        elsif ce = '1' then 
            if kincm = bfly then
                reset_bfly <= '1';
            else
                reset_bfly <= '0';    
            end if;    
        end if;
    end if;
end process rs_bfly;

pinco_proc : process(clk,ce,start,reset_bfly,nxt_bfly)
begin
    if clk'event and clk = '1' then
        if start = '1' or reset_bfly = '1' then
            pinco <= (others => '0');
        elsif ce='1' and nxt_bfly='1' then
            pinco <= pinco + kinc;
        end if;
    end if;
end process pinco_proc;

nxt_bfly_proc : process(clk,ce,start,bfli)
begin
    if clk'event and clk = '1' then
        if ce = '1' then
            if start = '1' then
                nxt_bfly <= '0';
            elsif bfli(0) = '0' and bfli(1) = '1' then
                nxt_bfly <= '1';
            else nxt_bfly <= '0';
            end if;
        end if;
    end if;
end process nxt_bfly_proc;

phase_addr_proc : process(clk,ce,start)
begin
    if clk'event and clk = '1' then
        if ce = '1' then
            if start = '1' then
                phase_addr_i <= (others => '0');
            elsif nxt_bfly = '1' then
                phase_addr_i <= (others => '0');
            else
                phase_addr_i <= phase_addr_i + pinco;
            end if;
        end if;
    end if;
end process phase_addr_proc;

    load_sr <= start or (not dma and result and nxt_rank) or (dma and io and nxt_rank);   
    kinc <= tmp_kinc(log2_nfft-2 downto 0);
    kincm <= (tmp_kincm(0),tmp_kincm(1),tmp_kincm(2),tmp_kincm(3),tmp_kincm(4),
    tmp_kincm(5),tmp_kincm(6),tmp_kincm(7),tmp_kincm(8),'0'); 
    
 
    kincm(0) <= '0';
    k1 <= "0000000000000001"; 		--conv_std_logic_vector(1,B); 
    k2 <= "1111111111111111"; 		--conv_std_logic_vector(2**B - 1,B); 
    phase_addr <= phase_addr_i;
    logic0 <= '0';
    
end phase_agen_arch;
-- Synopsis: FFT phase factor address generator

-- ************************************************************************
--  Copyright (C) 1998, 1999 - Xilinx, Inc.
-- ************************************************************************
-- This file is (c) Xilinx, Inc. 1998.  No part of this file may be modified, 
-- transmitted to any third party (other than as intended by Xilinx) or used 
-- without a Xilinx programmable or hardwire device without Xilinx's prior 
-- written permission.
--

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;

library xilinxcorelib;
    use xilinxcorelib.fft_defsx_1024.all;
    
-- synopsys translate_off
library unisim;
	use unisim.vcomponents.all;
-- synopsys translate_on
        	
entity phase_factors_1024 is
    port (
    	    clk			: in std_logic;		-- global clock
    	    ce			: in std_logic;		-- global clock enable
    	    start		: in std_logic;		-- system start
    	    rs			: in std_logic;		-- master reset
    	    result		: in std_logic;	
    	    dma			: in std_logic;
    	    io			: in std_logic;	    	    
    	    sinn		: out std_logic_vector(B-1 downto 0);	-- cos()
    	    coss		: out std_logic_vector(B-1 downto 0);	-- sin()
    	    comp		: out std_logic		-- comp. mult product
    );
end phase_factors_1024;

architecture phase_factors_arch of phase_factors_1024 is

    -- phase angle
    signal phase_addr		: std_logic_vector(log2_nfft-1 downto 0);
    signal phase_addr_omega	: std_logic_vector(log2_nfft-3 downto 0);
    signal cos_val		: std_logic_vector(B-2 downto 0);
    signal sin_val		: std_logic_vector(B-2 downto 0);
    signal cos_sign_z1		: std_logic;
    signal cos_sign_z2		: std_logic;
    signal comp_cos_z1		: std_logic;
    signal comp_cos_z2		: std_logic;
    signal sin_sign_z1		: std_logic;
    signal sin_sign_z2		: std_logic;
    signal comp_sin_z1		: std_logic;
    signal comp_sin_z2		: std_logic;
    signal comp_tmp		: std_logic;
    signal logic0		: std_logic;
    signal logic1		: std_logic;
        
    -- start for phase factor address (i.e. phase angle) generator
    signal phase_start		: std_logic;
    
component phase_agen_1024
    port (
    	    clk			: in std_logic;		-- global clock
    	    ce			: in std_logic;		-- global clock enable
    	    start		: in std_logic;		-- system start
    	    rs			: in std_logic;
    	    result		: in std_logic;
    	    dma			: in std_logic;
    	    io			: in std_logic;	
    	    phase_addr		: out std_logic_vector(log2_nfft-1 downto 0)	-- phase angle
    );
end component;

component SRL16E 
	port (
		q		: out std_logic;	
		d		: in std_logic;
		ce		: in std_logic;
		clk   		: in std_logic;
 		a0		: in std_logic;			
 		a1		: in std_logic;
 		a2		: in std_logic;
 		a3		: in std_logic
	);
end component;

-- distributed RAM cos() LUT

component xdsp_cos1024 port (
	a	: IN std_logic_VECTOR(log2_nfft-3 downto 0);
	clk	: IN std_logic;
	qspo_ce	: IN std_logic;
	qspo	: OUT std_logic_VECTOR(B-2 downto 0));
end component;

-- distributed RAM cos() LUT

component xdsp_sin1024 port (
	a	: IN std_logic_VECTOR(log2_nfft-3 downto 0);
	clk	: IN std_logic;
	qspo_ce	: IN std_logic;
	qspo	: OUT std_logic_VECTOR(B-2 downto 0));
end component;

attribute RLOC : string;
attribute RLOC of cos_lut : label is "R0C0"; 
--attribute RLOC of sin_lut : label is "R0C4";

begin

phase_addr_gen : phase_agen_1024
	port map(
		clk		=> clk,
		ce		=> ce,
		start		=> phase_start,
		rs		=> rs,
		result          => result,
		dma		=> dma,
		io		=> io,
		phase_addr	=> phase_addr
	); 
	
cos_lut : xdsp_cos1024 
	port map (
		a 		=> phase_addr_omega,
		clk 		=> clk,
		qspo_ce 	=> ce,
		qspo 		=> cos_val
	);
	
sin_lut : xdsp_sin1024 
	port map (
		a 		=> phase_addr_omega,
		clk 		=> clk,
		qspo_ce 	=> ce,
		qspo 		=> sin_val
	);
	
-- phase factor address generator start-up sequencer
phastart : SRL16E 
	port map(
		q		=> phase_start,	
		d		=> start,
		ce		=> ce,
		clk   		=> clk,
		a0		=> logic1,	-- 8 stage delay line (addr = dec 7)
 		a1		=> logic1,
 		a2		=> logic1,
 		a3		=> logic0
 	);	
 	
comp_pipex : SRL16E 
	port map(
		q		=> comp,	
		d		=> comp_tmp,
		ce		=> ce,
		clk   		=> clk,
		a0		=> logic0,	-- 9 stage delay line (addr = dec 8)
 		a1		=> logic0,
		a2		=> logic0,
 		a3		=> logic1
 	);	
 		
cos_proc : process(clk,ce,phase_addr)
variable comp_cos : std_logic;
variable cos_tmp : std_logic_vector(B-2 downto 0);
variable sign,sign0,sign1,sign2 : std_logic;
begin
    comp_cos := not ( phase_addr(log2_nfft-1) xor phase_addr(log2_nfft-2) );
    
    if clk'event and clk = '1' then
      if ce = '1' then
        comp_cos_z2 <= comp_cos_z1;
        comp_cos_z1 <= comp_cos;
        if comp_cos_z2 = '1' then
            cos_tmp := not cos_val + 1;
        else
            cos_tmp := cos_val;
        end if;
        if phase_addr = 0 then
            sign0 := '1';
            comp_tmp <= '1';
        else
            sign0 := '0';
            comp_tmp <= '0';
        end if;
        sign1 := phase_addr(log2_nfft-1) xor phase_addr(log2_nfft-2);
        if phase_addr = nfft/4 then
            sign2 := '0';
        else
            sign2 := '1';
        end if;
        
        sign := (sign0 or sign1) and sign2;
        cos_sign_z2 <= cos_sign_z1;
        cos_sign_z1 <= sign;
        coss <= (cos_sign_z2 & cos_tmp);
      end if;
    end if;
end process cos_proc;

sin_proc : process(clk,ce,phase_addr)
variable comp_sin : std_logic;
variable sin_tmp : std_logic_vector(B-2 downto 0);
variable sign,sign0,sign1 : std_logic;
begin
    comp_sin := phase_addr(log2_nfft-1);
    
    if clk'event and clk = '1' then
      if ce = '1' then
        comp_sin_z2 <= comp_sin_z1;
        comp_sin_z1 <= comp_sin;
        if comp_sin_z2 = '1' then
            sin_tmp := not sin_val + 1;
        else
            sin_tmp := sin_val;
        end if;
        if phase_addr = 0 then
            sign0 := '1';
        else
            sign0 := '0';
        end if;
        sign1 := phase_addr(log2_nfft-1);     
        sign := not sign0 and not sign1;
        sin_sign_z2 <= sin_sign_z1;
        sin_sign_z1 <= sign;
        sinn <= (sin_sign_z2 & sin_tmp);
      end if;
    end if;
end process sin_proc;

agen : process(clk,ce,phase_addr)
begin
    if clk'event and clk = '1' then
      if ce = '1' then
        if phase_addr(log2_nfft-2) = '1' then
           phase_addr_omega <= not phase_addr(log2_nfft-3 downto 0) + 1; 
        else
           phase_addr_omega <= phase_addr(log2_nfft-3 downto 0);
        end if;   
      end if;
    end if;
end process agen;

    logic0 <= '0';
    logic1 <= '1';
        	
end phase_factors_arch;
-- Virtex FFT
-- data re-ordering buffer 

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;

library xilinxcorelib;
	use xilinxcorelib.fft_defsx_1024.all;
			
entity fft_dbl_bufr_1024 is
	port (
		clk		: in std_logic;				-- system clock
		rs		: in std_logic;				-- reset
		start		: in std_logic;				-- start transform
		ce		: in std_logic;				-- clk enable
		dr		: in std_logic_vector(B-1 downto 0);
		di		: in std_logic_vector(B-1 downto 0);
		qr		: out std_logic_vector(B-1 downto 0);
		qi		: out std_logic_vector(B-1 downto 0)
	      );
end fft_dbl_bufr_1024;

architecture struct of fft_dbl_bufr_1024 is
	
	-- definitions for input double buffer
	signal	c			: std_logic_vector(4 downto 0);
	signal	addr_a			: std_logic_vector(3 downto 0);
	signal	addr_b			: std_logic_vector(3 downto 0);
	signal	addr_ram0		: std_logic_vector(3 downto 0);
	signal	addr_ram1		: std_logic_vector(3 downto 0);
	signal	reg_addr_ram0		: std_logic_vector(3 downto 0);
	signal	reg_addr_ram1		: std_logic_vector(3 downto 0);
	signal	ram0_addr_mux_sel	: std_logic;
	signal	ram1_addr_mux_sel	: std_logic;
	-- write enables for ram0 and ram1
	signal	ram0_we			: std_logic;
	signal	ram1_we			: std_logic;
	signal	ram0_we_z		: std_logic;
	signal	ram1_we_z		: std_logic;	
	signal	ram0q_r			: std_logic_vector(B-1 downto 0);
	signal	ram0q_i			: std_logic_vector(B-1 downto 0);
	signal	ram1q_r			: std_logic_vector(B-1 downto 0);
	signal	ram1q_i			: std_logic_vector(B-1 downto 0);
	signal	odmux_sel		: std_logic;
	signal	odmux_sel_z		: std_logic; 	
	signal	odmux_sel_z1		: std_logic; 	 
	signal	strt			: std_logic;
	
component xdsp_ramd16a4
  port (a	: IN STD_LOGIC_VECTOR(4-1 DOWNTO 0);
        d	: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);
        we	: IN STD_LOGIC;
        clk	: IN STD_LOGIC;
        qspo_ce	: IN STD_LOGIC;
        qspo	: OUT STD_LOGIC_VECTOR(B-1 DOWNTO 0));
end component;

component xdsp_mux2w4r
  port( ma 	: IN  std_logic_vector( 4 - 1 DOWNTO 0 );
        mb 	: IN  std_logic_vector( 4 - 1 DOWNTO 0 );
        clk	: in  std_logic;
        ce	: in  std_logic;
        s 	: IN  std_logic_vector(0 downto 0);
        q  	: OUT std_logic_vector( 4 - 1 DOWNTO 0 ) );
end component;

component xdsp_mux2w16r
  port( ma 	: IN  std_logic_vector( B - 1 DOWNTO 0 );
        mb 	: IN  std_logic_vector( B - 1 DOWNTO 0 );
        clk	: in  std_logic;
        ce	: in  std_logic;        
        s 	: IN  std_logic_vector(0 downto 0);
        q  	: OUT std_logic_vector( B - 1 DOWNTO 0 ) );
end component;

attribute RLOC : string;
attribute RLOC of ram0_r : label is "R0C0";
attribute RLOC of ram0_i : label is "R0C1";
attribute RLOC of ram1_r : label is "R0C2";
attribute RLOC of ram1_i : label is "R0C3";
attribute RLOC of odmux_r : label is "R0C2";
attribute RLOC of odmux_i : label is "R0C3";
attribute RLOC of ram0_addr_mux : label is "R0C0";
attribute RLOC of ram1_addr_mux : label is "R0C1";

begin

ram0_r : xdsp_ramd16a4
	port map (
		a		=> reg_addr_ram0,
		d		=> dr,
		we		=> ram0_we,
		clk		=> clk,
		qspo_ce		=> ce,
		qspo		=> ram0q_r
	);
	
ram0_i : xdsp_ramd16a4
	port map (
		a		=> reg_addr_ram0,
		d		=> di,
		we		=> ram0_we,
		clk		=> clk,
		qspo_ce		=> ce,
		qspo		=> ram0q_i
	);
	
ram1_r : xdsp_ramd16a4
	port map (
		a		=> reg_addr_ram1,
		d		=> dr,
		we		=> ram1_we,
		clk		=> clk,
		qspo_ce		=> ce,
		qspo		=> ram1q_r
	);
	
ram1_i : xdsp_ramd16a4
	port map (
		a		=> reg_addr_ram1,
		d		=> di,
		we		=> ram1_we,
		clk		=> clk,
		qspo_ce		=> ce,
		qspo		=> ram1q_i
	);
		
ram0_addr_mux : xdsp_mux2w4r
	port map (
		ma		=> addr_b,
		mb		=> addr_a,
		clk		=> clk,
		ce		=> ce,
		s(0)		=> ram0_addr_mux_sel,
		q		=> reg_addr_ram0
	);
	
ram1_addr_mux : xdsp_mux2w4r
	port map (
		ma		=> addr_b,
		mb		=> addr_a,
		clk		=> clk,
		ce		=> ce,		
		s(0)		=> ram1_addr_mux_sel,
		q		=> reg_addr_ram1
	);
	
odmux_r : xdsp_mux2w16r
	port map (
		ma		=> ram0q_r,
		mb		=> ram1q_r,
		clk		=> clk,
		ce		=> ce,		
		s(0)		=> odmux_sel,
		q		=> qr
	);
	
odmux_i : xdsp_mux2w16r
	port map (
		ma		=> ram0q_i,
		mb		=> ram1q_i,
		clk		=> clk,
		ce		=> ce,		
		s(0)		=> odmux_sel,
		q		=> qi
	);		 
	
addr_gen : process(clk,ce,rs,strt)
begin
	if clk'event and clk = '1' then
		if rs = '1' or strt = '1' then
			c <= (others => '0');
		elsif ce = '1' then
			c <= c + 1;	
			addr_a <= c(3 downto 0);
			addr_b <= (c(1),c(0),c(3),c(2));
			ram0_addr_mux_sel <= c(4);
			ram1_addr_mux_sel <= not c(4);			
	    	end if;
	end if;
end process;

ram_we : process(clk,rs,start)
begin
	if clk'event and clk = '1' then
		if rs = '1' then
			ram0_we <= '0';
			ram1_we <= '0';
		elsif ce = '1' then
			ram0_we_z <= c(4);
			ram1_we_z <= not c(4);
			ram0_we <= ram0_we_z;	-- compensate for dly through registered mux
			ram1_we <= ram1_we_z;
			odmux_sel_z1 <= c(4);
			odmux_sel_z <= odmux_sel_z1;			
			odmux_sel <= odmux_sel_z;
		end if;
	end if;
end process;
	
strt_proc : process(clk,ce,start)
begin
	if clk'event and clk = '1' then
		if ce = '1' then
			strt <= start;
		end if;
	end if;
end process;
	
end struct;

-- Virtex FFT
-- final DIF butterfly + input data sequencing

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;

library xilinxcorelib;
	use xilinxcorelib.fft_defsx_1024.all;
	
entity fft4_engine is
	port (
		clk		: in std_logic;				-- system clock
		rs		: in std_logic;				-- reset
		start		: in std_logic;				-- start transform
		ce		: in std_logic;				-- clk enable
		fwd_inv		: in std_logic;
		fwd_inv_ce	: in std_logic;
		xnr		: in std_logic_vector(B-1 downto 0);
		xni		: in std_logic_vector(B-1 downto 0);
		xkr		: out std_logic_vector(B-1 downto 0);
		xki		: out std_logic_vector(B-1 downto 0)
	      );
end fft4_engine;


architecture struct of fft4_engine is

	signal	logic0			: std_logic;
	signal	logic1			: std_logic;
	signal	xar			: std_logic_vector(B-1 downto 0);
	signal	xai			: std_logic_vector(B-1 downto 0);	
	-- 4-point FFT output samples
	signal	y0r			: std_logic_vector(B-1 downto 0);
	signal	y0i			: std_logic_vector(B-1 downto 0);
	signal	y1r			: std_logic_vector(B-1 downto 0);
	signal	y1i			: std_logic_vector(B-1 downto 0);
	signal	y2r			: std_logic_vector(B-1 downto 0);
	signal	y2i			: std_logic_vector(B-1 downto 0);
	signal	y3r			: std_logic_vector(B-1 downto 0);
	signal	y3i			: std_logic_vector(B-1 downto 0);
	signal	tr			: std_logic_vector(B-1 downto 0);
	signal	ti			: std_logic_vector(B-1 downto 0);		
	signal	fwd_inv_i		: std_logic;
	signal	fft4_omux_state_cntr	: std_logic_vector(1 downto 0);
	signal	fft4_omux_s0		: std_logic;
	signal	fft4_omux_s1		: std_logic;

-- srl16/FF based delay
component z47w1
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		din		: in std_logic;
		dout		: out std_logic
	);
end component;
					
component fft_dbl_bufr_1024
	port (
		clk		: in std_logic;				-- system clock
		rs		: in std_logic;				-- reset
		start		: in std_logic;				-- start transform
		ce		: in std_logic;				-- clk enable
		dr		: in std_logic_vector(B-1 downto 0);
		di		: in std_logic_vector(B-1 downto 0);
		qr		: out std_logic_vector(B-1 downto 0);
		qi		: out std_logic_vector(B-1 downto 0)
	      );
end component;

component fft4
	port (
		clk		: in std_logic;				-- system clock
		rs		: in std_logic;				-- reset
		start		: in std_logic;				-- global start
		ce		: in std_logic;
		conj		: in std_logic;
		dr		: in std_logic_vector(B-1 downto 0);
		di		: in std_logic_vector(B-1 downto 0);
		y0r		: out std_logic_vector(B-1 downto 0);
		y0i		: out std_logic_vector(B-1 downto 0);
		y1r		: out std_logic_vector(B-1 downto 0);
		y1i		: out std_logic_vector(B-1 downto 0);
		y2r		: out std_logic_vector(B-1 downto 0);
		y2i		: out std_logic_vector(B-1 downto 0);
		y3r		: out std_logic_vector(B-1 downto 0);
		y3i		: out std_logic_vector(B-1 downto 0)
	      );
end component;

component xmux4w16rb
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		s0		: in std_logic;				-- mux select inputs
		s1		: in std_logic;
		x0r		: in std_logic_vector(B-1 downto 0);	-- mux inputs Re and Im
		x0i		: in std_logic_vector(B-1 downto 0);
		x1r		: in std_logic_vector(B-1 downto 0);	
		x1i		: in std_logic_vector(B-1 downto 0);
		x2r		: in std_logic_vector(B-1 downto 0);	
		x2i		: in std_logic_vector(B-1 downto 0);
		x3r		: in std_logic_vector(B-1 downto 0);	
		x3i		: in std_logic_vector(B-1 downto 0);
		yr		: out std_logic_vector(B-1 downto 0);	-- mux outputs
		yi		: out std_logic_vector(B-1 downto 0)
	      );
end component;

component cmplx_reg16_conjc
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
end component;		   

attribute RLOC : string;
attribute RLOC of fft_bufr : label is "R0C0"; 
attribute RLOC of xfft4 : label is "R0C4";
attribute RLOC of fft4_omux : label is "R0C10";	
attribute RLOC of oreg : label is "R0C10";	   

begin

fft_bufr : fft_dbl_bufr_1024
	port map(
		clk		=> clk,				
		rs		=> rs,
		start		=> start,
		ce		=> ce,
		dr		=> xnr,
		di		=> xni,
		qr		=> xar,
		qi		=> xai
	       );
	       
xfft4 : fft4
	port map (
		clk		=> clk,				
		rs		=> rs,				
		start		=> start,			
		ce		=> ce,				
		conj		=> fwd_inv_i,
		dr		=> xar,				
		di		=> xai,
		y0r		=> y0r,				
		y0i		=> y0i,
		y1r		=> y1r,
		y1i		=> y1i,
		y2r		=> y2r,
		y2i		=> y2i,
		y3r		=> y3r,
		y3i		=> y3i		
	);

fft4_omux : xmux4w16rb
	port map (
		clk		=> clk,			-- system clock
		ce		=> ce,			-- global clk enable
		s0		=> fft4_omux_s0,	-- mux select inputs
		s1		=> fft4_omux_s1,
		x0r		=> y2r,	
		x0i		=> y2i,
		x1r		=> y3r,	
		x1i		=> y3i,
		x2r		=> y0r,	
		x2i		=> y0i,
		x3r		=> y1r,	
		x3i		=> y1i,
		yr		=> tr,			
		yi		=> ti
	);

oreg : cmplx_reg16_conjc
	port map(
		clk		=> clk,
		ce		=> ce,
		conj		=> fwd_inv_i,
		dr		=> tr,
		di		=> ti,
		qr		=> xkr,			
		qi		=> xki			
	);
	
fft4_omux_state_mach : process(clk,rs,ce,start)
begin
	if clk'event and clk = '1' then
		if rs = '1' or start = '1' then
			fft4_omux_state_cntr <= (others => '0');
		elsif ce = '1' then		
			fft4_omux_state_cntr <= fft4_omux_state_cntr + 1;
		end if;	
	end if;
end process;

fwd_inv_balance : z47w1 
	port map (
		clk	=> clk,
		ce	=> ce,
		rs	=> rs,
		din	=> fwd_inv,
		dout	=> fwd_inv_i
	);
	
	fft4_omux_s0 <= fft4_omux_state_cntr(0);
	fft4_omux_s1 <= fft4_omux_state_cntr(1);
			
	logic0 <= '0';
	logic1 <= '1';
		       
end struct;
	      
-- 1024-point FFT operand read address generator

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;

library xilinxcorelib;
    	use xilinxcorelib.fft_defsx_1024.all;
    	
entity index_map_1024 is
	port(
		clk		: in std_logic;		-- global clock
		ce		: in std_logic;		-- master clock enable
		rs		: in std_logic;		-- master reset
		index		: out std_logic_vector(log2_nfft-1 downto 0) -- outp. index bus
	);
end index_map_1024;

architecture behv of index_map_1024 is

	-- state counter for re-ordering address generator
	signal	b		: std_logic_vector(12 downto 0);
	
begin

indx_agen : process(clk, ce, rs)
	variable cen	: std_logic;
begin
	if clk'event and clk = '1' then
	    if rs = '1' then
		b <= (others => '0');
	    elsif ce = '1' then
		b <= b + 1;
	    end if;
	end if;
end process;

	-- define output re-ordering address bus
	index <= (b(1),b(0),b(3),b(2),b(5),b(4),b(7),b(6),b(9),b(8));
	
end behv;
-- Virtex FFT
-- control signal generation

-- Modification History:

-- ************************************************************************
--  Copyright 1996-2000 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;
    use ieee.std_logic_unsigned.all;
    
library xilinxcorelib;
    use xilinxcorelib.fft_defsx_1024.all;
	
entity fft_cntrlx_1024 is
	port(
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		mode		: in std_logic;		
		start		: in std_logic;
		dma		: in std_logic;
		mwr		: in std_logic;
		addrw		: in std_logic_vector(log2_nfft-1 downto 0);
		busy		: out std_logic;
		wren		: out std_logic;	
		wrenx		: out std_logic;
		wreny		: out std_logic;
		web_x		: out std_logic;
		web_y		: out std_logic;		
		enax		: out std_logic;
		enay		: out std_logic;
		rank_eq_0	: out std_logic;
		rank_eq_nm1	: out std_logic;			
		result		: out std_logic;
		eresult		: out std_logic;		
		io		: out std_logic;
		eio		: out std_logic;
		mode_ce		: out std_logic;		
		done		: out std_logic;
		edone		: out std_logic;
		bank		: out std_logic;
		ebank		: out std_logic;
		nxt_addr	: out std_logic
	);
end fft_cntrlx_1024;

architecture behv of fft_cntrlx_1024 is
    
    --alias log2_nfft is work.fft_defsx.log2_nfft;
    --alias n    is work.fft_defsx.nfft;
    --alias L    is work.fft_defsx.latency;
    constant L2			: natural  := 30; 				    
    constant reset_state	: natural  := (log2_nfft/2-1) * nfft - 1; 
    constant reset_state_dma	: natural  := (log2_nfft/2-0) * nfft - 1;     	
    constant reset_outp_state	: natural  := (log2_nfft/2-1) * nfft - 1 + L2;  
    constant reset_bbb		: natural  := (log2_nfft/2-1) * nfft - 1;  
    constant reset_bbb_dma	: natural  := log2_nfft/2 * nfft - 1;       	
    constant reset_bbbb		: natural  := (log2_nfft/2) * nfft - 1; 
    constant reset_bbbb_dma	: natural  := log2_nfft/2 * nfft - 1;     	
    constant begin_result	: positive := (log2_nfft/2-2) * nfft - 1;	 	
    constant end_result		: positive := (log2_nfft/2-1) * nfft - 1;		
    constant begin_io		: positive := (log2_nfft/2-1) * nfft - L2; 			
    constant end_io		: positive := (log2_nfft/2-0) * nfft - L2; 				
    constant done_cnt		: positive := (log2_nfft/2-1) * nfft - 2;
    
    -- mode_ce_cnt = (log2_nfft/2-1) * n - 1 when the scaling mux is registered
    -- and = (log2_nfft/2-1) * n - 2 when not registered		
    constant mode_ce_cnt	: positive := (log2_nfft/2-1) * nfft - 1;  
    constant mode_ce_cnt_dma	: positive := (log2_nfft/2-0) * nfft - 1;    
    constant edone_cnt		: positive := (log2_nfft/2-2) * nfft - 2;
    constant fft_busy_ticks	: natural  := (log2_nfft/2-1) * nfft + latency + L2-1;   
    -- controls when wren[1] is asserted 
    constant assert_wren	: natural := latency;	  	
    constant wren1_nticks	: natural := (log2_nfft/2-1) * nfft - 1;
    constant fin_rankm_nticks	: natural := (log2_nfft/2-1) * nfft;
    
    -- start_rank0 is used by the scaling mux.
    -- when this mux is registered start_rank0 = L-1 to allow for the mux reg
    -- when it is not registered this value is L
    -- when the final output xk_mux is in the path the val. is L-2
    
    constant start_rank0	: natural := latency-2;    
    constant end_rank0		: natural := nfft+start_rank0; 
    constant bank_switch_cnt	: natural := (log2_nfft/2-1) * nfft - 1;
        	
    -- counts num. I/O clock cycles
    signal io_cycle_cntr	: std_logic_vector(log2_nfft+2 downto 0);
    signal wren1_cntr		: std_logic_vector(log2_nfft+log2_nfft/4 downto 0);    
    -- indicates FFT processing status
    signal fft_active		: boolean;
    signal ostart		: std_logic;
    signal strt2		: std_logic;    
    
    -- state counter
    signal b			: std_logic_vector(log2_nfft+2 downto 0);
    signal bb			: std_logic_vector(log2_nfft+2 downto 0);   
    signal bbb			: std_logic_vector(log2_nfft+2 downto 0);    
    signal bbbb			: std_logic_vector(log2_nfft+2 downto 0);         
    signal rank_eq_0_i		: std_logic;
    signal busy_i		: std_logic;
    signal bank_i		: std_logic;
    signal bank_iz		: std_logic;    
    signal ebank_i		: std_logic;
    --signal eebank		: std_logic;    
    signal ewren1		: std_logic;
    signal new_xn_cnt		: std_logic_vector(log2_nfft/2-1 downto 0);
    signal ld_xn		: std_logic;
    signal enax_i		: std_logic;
               
-- srl16/FF based delay
        
component z19w1
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		din		: in std_logic;
		dout		: out std_logic
	);
end component;  

component z49w1
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		din		: in std_logic;
		dout		: out std_logic
	);
end component;   

begin

out_proc_init : z19w1 
	port map (
		clk	=> clk,
		ce	=> ce,
		rs	=> rs,
		din	=> start,
		dout	=> ostart
	);		

strt2_pipe : z49w1 
	port map (
		clk	=> clk,
		ce	=> ce,
		rs	=> rs,
		din	=> start,
		dout	=> strt2
	);
	
wren_proc : process(clk,rs,start,mwr)
begin
    if clk'event and clk = '1' then
        if rs = '1' then
            io_cycle_cntr <= (others => '0');
            wren <= '0';
            busy_i <= '0';
        elsif start = '1' then
            busy_i <= '1';
            wren <= '0';
            io_cycle_cntr <= (others => '0');
        elsif ce = '1' then
            if busy_i = '0' then
	        if mwr = '1' and mode = '1' then
		    wren <= '1';
		elsif addrw = nfft-1 then
		    wren <= '0';    
		end if;               
            else        
                io_cycle_cntr <= io_cycle_cntr + 1;
                if io_cycle_cntr = assert_wren and fft_active = true then
                    wren <= '1';
                elsif io_cycle_cntr = fft_busy_ticks and mode = '0' then
                    wren <= '0';
                    busy_i <= '0';
                end if;
            end if;    
        end if;
    end if;
end process wren_proc;

ewren1_proc : process(clk,ce,rs,start,wren1_cntr)
variable	r : std_logic;
begin
    r := rs or start;
    if clk'event and clk = '1' then
        if r = '1' or wren1_cntr = wren1_nticks then
            ewren1 <= '0';
            wren1_cntr <= (others => '0');
        elsif ce = '1' then
            if wren1_cntr = assert_wren-1 and fft_active = true then
                ewren1 <= '1';
            elsif wren1_cntr = fin_rankm_nticks-3 then
                ewren1 <= '0';
            end if;
            wren1_cntr <= wren1_cntr + 1;
        end if;
    end if;
end process ewren1_proc;

wrenx_proc : process(clk,ce,rs,start,mwr,b,enax_i,ebank_i)
	variable r	: std_logic;
	variable cen	: std_logic;
begin
	r := rs;
	cen := ce and busy_i;
	if clk'event and clk = '1' then
		if r = '1' then
			wrenx <= '0';
		elsif ce = '1' then 		
		    if busy_i = '0' then
		        --if mwr = '1' then
		        --    wrenx <= '1';
		        --elsif (addrw = n-1) and enax_i = '1' then
		        --    wrenx <= '0';    
		        --end if;     
		    elsif ebank_i = '0' then
			wrenx <= '0';
	            else
	            	wrenx <= ewren1;
		    end if;
		end if;
	end if;
end process;

wreny_proc : process(clk,ce,rs,start,ebank_i)
	variable r	: std_logic;
	variable cen	: std_logic;
begin
	r := rs;
	cen := ce and busy_i;
	if clk'event and clk = '1' then
		if r = '1' then
			wreny <= '0';
		elsif cen = '1' then 
		    if ebank_i = '1' then
			wreny <= '0';
	            else
	            	wreny <= ewren1;
		    end if;
		end if;
	end if;
end process;

web_x_proc : process(clk,ce,rs,start,mwr,b,enax_i,ebank_i)
	variable r	: std_logic;
	variable cen	: std_logic;
begin
	r := rs;
	cen := ce and busy_i;
	if clk'event and clk = '1' then
		if r = '1' then
			web_x <= '0';
		elsif ce = '1' then 		
		    if busy_i = '0' then
		        if mwr = '1' then
		            web_x <= '1';
		        elsif (addrw = nfft-1) and enax_i = '1' then
		            web_x <= '0';    
		        end if;     
		    elsif ebank_i = '0' then
			web_x <= '1';
	            else
	            	web_x <= '0';
		    end if;
		end if;
	end if;
end process;

web_y_proc : process(clk,ce,rs,start,enax_i,busy_i,ebank_i)
	variable r	: std_logic;
	variable cen	: std_logic;
begin
	r := rs;
	cen := ce and busy_i;
	if clk'event and clk = '1' then
		if r = '1' then
			web_y <= '0';
		elsif ce = '1' then 		
		    if busy_i = '1' then   
		        if ebank_i = '1' then
			    web_y <= '1';
			else
			    web_y <= '0';
			end if;
		    end if;
		end if;
	end if;
end process;

status : process(clk,ce,rs,start)
begin
    if clk'event and clk = '1' then
        if rs = '1' then
            fft_active <= false;
        elsif ce = '1' then
            if start = '1' then
                fft_active <= true;
            end if;
        end if;
    end if;
end process status;

rank0_proc : process(clk,ce,rs,start)
begin
    if clk'event and clk = '1' then
        if ce = '1' then
            if b = start_rank0 then
                rank_eq_0_i <= '1';
            elsif rank_eq_0_i = '1' and b = end_rank0 then
                rank_eq_0_i <= '0';
            end if;
        end if;        
    end if;
end process rank0_proc;

state_proc : process(clk,ce,rs,start,dma)
     variable	r1 : std_logic;
begin

    if dma = '0' and (b = reset_state) then
	r1 := '1';
    elsif dma = '1' and (b = reset_state_dma) then
	r1 := '1';	
    else
	r1 := '0';
    end if;
	
    if clk'event and clk = '1' then
        if ce = '1' then
            if rs = '1' or start = '1' or r1 = '1' then 
                b <= (others => '0');
            elsif ce = '1' then
                b <= b + 1;
            end if;
        end if;
    end if;    
end process state_proc;

outp_state_proc : process(clk,ce,rs,ostart,start)
begin
    if clk'event and clk = '1' then
        if rs = '1' or ostart = '1' or start = '1' or bb = reset_outp_state then
            bb <= (others => '0');
        elsif ce = '1' then
            bb <= bb + 1;
        end if;      
    end if;
end process outp_state_proc;

outp_state_proc2 : process(clk,ce,rs,strt2,start,dma)
     variable	r1 : std_logic;
begin

    if dma = '0' and (bbb = reset_bbb) then
	r1 := '1';
    elsif dma = '1' and (bbb = reset_bbb_dma) then
	r1 := '1';	
    else
	r1 := '0';
    end if;
    
    -- ***** 'or start' added by chd 7/1/00
    
    if clk'event and clk = '1' then
        if rs = '1' or strt2 = '1' or  r1 = '1' or start = '1' then 
            bbb <= (others => '0');
        elsif ce = '1' then
            bbb <= bbb + 1;
        end if;      
    end if;
end process outp_state_proc2;

outp_state_proc3 : process(clk,ce,rs,strt2,start,dma,mwr)
     variable	r1 : std_logic;
begin

    if dma = '0' and (bbbb = reset_bbbb) then
	r1 := '1';
    elsif dma = '1' and (bbbb = reset_bbbb_dma) then
	r1 := '1';	
    else
	r1 := '0';
    end if;

    if clk'event and clk = '1' then
        if mwr = '1' or rs = '1' or strt2 = '1' or  r1 = '1' then -- bbbb = reset_bbbb then
            bbbb <= (others => '0');
        elsif ce = '1' then
            bbbb <= bbbb + 1;
        end if;      
    end if;
end process outp_state_proc3;

done_proc : process(clk,ce,rs,busy_i)
	variable r	: std_logic;
begin
	r := rs;
	if clk'event and clk = '1' then
		if r = '1' then
			done <= '0';
		elsif bbb = done_cnt and busy_i = '1' then
			done <= '1';
		else
			done <= '0';
		end if;
	end if;
end process;

edone_proc : process(clk,ce,rs,busy_i)
	variable r	: std_logic;
begin
	r := rs;
	if clk'event and clk = '1' then
		if r = '1' then
			edone <= '0';
		elsif bbb = edone_cnt and busy_i = '1' then
			edone <= '1';
		else
			edone <= '0';
		end if;
	end if;
end process;

result_proc : process(clk,ce,rs,start,busy_i)
	variable r	: std_logic;
begin
	r := rs or start;
	if clk'event and clk = '1' then
		if r = '1' then
			result <= '0';
		elsif bbb = begin_result and busy_i = '1' then
			result <= '1';
		elsif bbb = end_result then
			result <= '0';
		end if;
	end if;
end process;

eresult_proc : process(clk,ce,rs,start,busy_i)
	variable r	: std_logic;
begin
	r := rs or start;
	if clk'event and clk = '1' then
		if r = '1' then
			eresult <= '0';
		elsif bbb = begin_result-1 and busy_i = '1' then
			eresult <= '1';
		elsif bbb = end_result-1 then
			eresult <= '0';
		end if;
	end if;
end process;

io_proc : process(clk,ce,rs,start,busy_i,mwr)
	variable r	: std_logic;
begin
	r := rs or start;
	if clk'event and clk = '1' then
		if r = '1' then
			io <= '0';
		elsif ce = '1' then
            	    if busy_i = '0' then
	                if mwr = '1' then
		            io <= '1';
		        elsif addrw = nfft-1 then
		            io <= '0';  
		        end if; 			
		    elsif (bbbb = begin_io+1 and busy_i = '1' and mode = '1') then
			io <= '1';
		    elsif bbbb = end_io+1 then
			io <= '0';
		    end if;
		end if;
	end if;
end process;

eio_proc : process(clk,ce,rs,start,busy_i,mwr)
	variable r	: std_logic;
begin
	r := rs or start;
	if clk'event and clk = '1' then
		if r = '1' then
			eio <= '0';
		elsif ce = '1' then
            	    if busy_i = '0' then
	                if mwr = '1' then
		            eio <= '1';
		        elsif addrw = nfft-1 then
		            eio <= '0';  
		        end if; 			
		    elsif (bbbb = begin_io-1 and busy_i = '1') then
			eio <= '1';
		    elsif bbbb = end_io-1 then
			eio <= '0';
		    end if;
                end if;
	end if;
end process;

fftstart_proc : process(clk,ce,rs,busy_i)
	variable r		: std_logic;
	variable assert_mode_ce	: std_logic;
begin
	r := rs; 
    	if dma = '0' and (b = mode_ce_cnt) then
		assert_mode_ce := '1';
    	elsif dma = '1' and (b = mode_ce_cnt_dma) then
		assert_mode_ce := '1';	
    	else
		assert_mode_ce := '0';
    	end if;	
    	
	if clk'event and clk = '1' then
		if r = '1' then
			mode_ce <= '0';
		elsif ce = '1' then 
		    if assert_mode_ce = '1' and busy_i = '1' then 
			mode_ce <= '1';
		    else
			mode_ce <= '0';
		    end if;
		end if;
	end if;
end process;

bank_proc : process(clk,ce,rs,start,busy_i,b)
	variable r	: std_logic;
begin
	r := rs;
	if clk'event and clk = '1' then
		if r = '1' then
			bank_iz <= '0';
			bank_i <= '0';
		elsif ce = '1' then 
		    if (b = bank_switch_cnt and busy_i = '1') or start = '1' then
			bank_iz <= bank_iz xor '1';
		    end if;
		    bank_i <= bank_iz;
		end if;
	end if;
end process;

ebank_proc : process(clk,ce,rs,start,busy_i,b)
	variable r	: std_logic;
begin
	r := rs;
	if clk'event and clk = '1' then
		if r = '1' then
			ebank_i <= '0';
		elsif ce = '1' then 
		    if (b = bank_switch_cnt-1 and busy_i = '1') or start = '1' then
			ebank_i <= ebank_i xor '1';
		    end if;
		end if;
	end if;
end process;

ld_xn_proc : process(clk,rs,ce,mwr,start)
    variable	nxt_xn  : std_logic;
    variable	r	: std_logic;
begin
    
    r := rs or mwr or start;
    
    if clk'event and clk = '1' then
        if r = '1' then
            new_xn_cnt <= (others => '0');
            ld_xn <= '0';
        elsif ce = '1' then 
            if new_xn_cnt = log2_nfft/2 - 2 then
                new_xn_cnt <= (others => '0');
            else
                new_xn_cnt <= new_xn_cnt + 1;
            end if;
            if new_xn_cnt = log2_nfft/2 - 4 then
                ld_xn <= '1';
            else
                ld_xn <= '0';
            end if;
        end if;   
    end if;
end process;

enaxy_proc : process(clk,rs,ce,start,ld_xn, ebank_i)
begin
    if clk'event and clk = '1' then
        if rs = '1' then
	   enax_i <= '0';
	   enay <= '0';
        elsif ebank_i = '0' then
            enax_i <= ld_xn;
            enay <= '1';
        else
            enay <= ld_xn;
            enax_i <= '1';
        end if;
    end if;
end process;

	rank_eq_0 <= rank_eq_0_i;
	busy <= busy_i;
	bank <= bank_i;
	nxt_addr <= ld_xn;
	enax <= enax_i;	
	ebank <= ebank_i;
end behv;	
-- FFT operand read address generator

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;
	
library xilinxcorelib;
    	use xilinxcorelib.fft_defsx_1024.all;
    	
entity fft_rd_agenx_1024 is
	port(
		clk		: in std_logic;		-- global clock
		ce		: in std_logic;		-- master clock enable
		rs		: in std_logic;		-- master reset
		start		: in std_logic;		-- xform start
		mrd		: in std_logic;
		mwr		: in std_logic;
		io_mode0	: in std_logic;
		io_mode1	: in std_logic;
		bank		: in std_logic;
		nxt_addr	: in std_logic;
		fft_rd_addr	: out std_logic_vector(log2_nfft-1 downto 0);
		fft_rd_addr_y	: out std_logic_vector(log2_nfft-1 downto 0)		
	);
end fft_rd_agenx_1024;

architecture fft_rd_agen1 of fft_rd_agenx_1024 is

	constant reset_rd_agen		: natural := (log2_nfft/2-1) * nfft - 1;
	constant reset_rd_agen_dma	: natural := log2_nfft/2 * nfft - 1;	
	constant rank_init		: natural := log2_max_nfft/2 - log2_nfft/2;
	constant m			: natural := 13;  -- max state bits
	constant mr			: natural := 3;   -- max rank cntr state bits
	-- state counter for operand read address generator
	signal	b		: std_logic_vector(m-1 downto 0);
	signal	bb		: std_logic_vector(m-1 downto 0);
		
	-- mux selects
	signal	a2a3_s0		: std_logic;
	signal	a4a5_s0		: std_logic;
	signal	a4a5_s1		: std_logic;
	signal	a6a7_s1		: std_logic;
	signal	a8a9_s0		: std_logic;	
	signal	fft_rd_addr_u	: std_logic_vector(log2_max_nfft-1 downto 0);
	signal	rank		: std_logic_vector(mr-1 downto 0);	
	signal 	unload		: std_logic;
	signal	ld_addr		: std_logic_vector(log2_nfft-1 downto 0);
				
component xdsp_mux3w1
	port (
		a		: in std_logic;	-- mux operand inputs
		b		: in std_logic;
		c		: in std_logic;
		s0		: in std_logic;	-- mux selects
		s1		: in std_logic;	-- mux selects
		y		: out std_logic	-- mux output signal
	);
end component;

component xdsp_mux2w1
	port (
		a		: in std_logic;	-- mux operand inputs
		b		: in std_logic;
		s0		: in std_logic;	-- mux sel
		y		: out std_logic	-- mux output signal
	);
end component;

begin

a0_mux : xdsp_mux2w1
	port map (
		a	=>	bb(2),
		b	=>	bb(0),
		s0	=>	rank(2),
		y	=>	fft_rd_addr_u(0) 
	);

a1_mux : xdsp_mux2w1
	port map (
		a	=>	bb(3),
		b	=>	bb(1),
		s0	=>	rank(2),
		y	=>	fft_rd_addr_u(1) 
	);
	
a2_mux : xdsp_mux3w1
	port map (
		a	=>	bb(4),
		b	=>	bb(0),
		c	=>	bb(2),
		s0	=>	a2a3_s0,
		s1	=>	rank(2),
		y	=>	fft_rd_addr_u(2) 
	);
	
a3_mux : xdsp_mux3w1
	port map (
		a	=>	bb(5),
		b	=>	bb(1),
		c	=>	bb(3),
		s0	=>	a2a3_s0,
		s1	=>	rank(2),
		y	=>	fft_rd_addr_u(3) 
	);
	
a4_mux : xdsp_mux3w1
	port map (
		a	=>	bb(6),
		b	=>	bb(0),
		c	=>	bb(4),
		s0	=>	a4a5_s0,
		s1	=>	a4a5_s1,
		y	=>	fft_rd_addr_u(4) 
	);
	
a5_mux : xdsp_mux3w1
	port map (
		a	=>	bb(7),
		b	=>	bb(1),
		c	=>	bb(5),
		s0	=>	a4a5_s0,
		s1	=>	a4a5_s1,
		y	=>	fft_rd_addr_u(5) 
	);
	
a6_mux : xdsp_mux3w1
	port map (
		a	=>	bb(8),
		b	=>	bb(0),
		c	=>	bb(6),
		s0	=>	rank(0),
		s1	=>	a6a7_s1,
		y	=>	fft_rd_addr_u(6) 
	);
	
a7_mux : xdsp_mux3w1
	port map (
		a	=>	bb(9),
		b	=>	bb(1),
		c	=>	bb(7),
		s0	=>	rank(0),
		s1	=>	a6a7_s1,
		y	=>	fft_rd_addr_u(7) 
	);
	
a8_mux : xdsp_mux2w1
	port map (
		a	=>	bb(0),
		b	=>	bb(8),
		s0	=>	a8a9_s0,
		y	=>	fft_rd_addr_u(8) 
	);		

a9_mux : xdsp_mux2w1
	port map (
		a	=>	bb(1),
		b	=>	bb(9),
		s0	=>	a8a9_s0,
		y	=>	fft_rd_addr_u(9) 
	);	
		
operand_rd_agen : process(clk,ce,rs,start,mrd,io_mode1)
	variable r,r1	: std_logic;	
	variable init	: std_logic;
begin
	r := rs;
	init := start or mrd;	
	if io_mode1 = '0' and (b = reset_rd_agen) then
	    r1 := '1';
	elsif io_mode1 = '1' and (b = reset_rd_agen_dma) then
	    r1 := '1';	
	else
	    r1 := '0';
	end if;
						
	if clk'event and clk = '1' then
		if init = '1' then
			b <= conv_std_logic_vector(1,m);
		elsif r = '1' or r1 = '1' then
			b <= (others => '0');
		elsif ce = '1' then
			b <= b + 1;
		end if;
	end if;
end process;

operand_rd_agenb : process(clk,ce,rs,start,mwr)
	variable cen	: std_logic;
	variable r,r1	: std_logic;
	variable ld	: std_logic;	
begin

	r := rs;	
		
	if clk'event and clk = '1' then
	    if ce = '1' then
	        if start = '1' or mwr = '1' then
	            bb <= conv_std_logic_vector(1,m);
	        elsif r = '1' or bb = nfft-1 then
                    bb <= (others => '0');
	        else 
		    bb <= bb + 1;
		end if;
	    end if;
	end if;
	
end process;

rank_proc : process(clk,ce,rs,start,io_mode1,mwr)
	variable r,r1	: std_logic;	
begin

	r := rs or start;	
	  	
	if io_mode1 = '0' and (b = reset_rd_agen) then
	    r1 := '1';
	elsif io_mode1 = '1' and (b = reset_rd_agen_dma) then
	    r1 := '1';	
	else
	    r1 := '0';
	end if;
	
	if clk'event and clk = '1' then
	    if ce = '1' then 
		if r = '1' or r1 = '1' then
		    rank <= conv_std_logic_vector(rank_init,mr); 
		elsif mwr = '1' then
		    rank <= "101";		--conv_std_logic_vector(log2_nfft/2,mr);     
		elsif bb = nfft-1 then
		    rank <= rank + 1;
		end if;
	    end if;
	end if;
end process;

reg_rd_addr: process(clk,ce,rs,start,mrd,mwr)
	variable r	: std_logic;
begin
	r := rs or start or mrd or mwr;
	if clk'event and clk = '1' then
		if r = '1' then
			fft_rd_addr <= (others => '0');
		elsif ce = '1' then
		    if unload = '1' then
			fft_rd_addr <= (b(1),b(0),b(3),b(2),b(5),b(4),b(7),b(6),b(9),b(8));		
		    elsif bank = '0' and io_mode1 = '0' then
	    		fft_rd_addr <= ld_addr;		    
		    else	    
			fft_rd_addr <= fft_rd_addr_u(log2_nfft-1 downto 0);
		    end if;
		end if;
	end if;
end process;

reg_rd_addry: process(clk,ce,rs,start,mwr,bank,io_mode1)
	variable r	: std_logic;
begin
	r := rs or start or mwr;
	if clk'event and clk = '1' then
		if r = '1' then
			fft_rd_addr_y <= (others => '0');
		elsif ce = '1' then	
		    if bank = '1' and io_mode1 = '0' then
	    		fft_rd_addr_y <= ld_addr;
	    	    else	    
			fft_rd_addr_y <= fft_rd_addr_u(log2_nfft-1 downto 0);
		    end if;
		end if;
	end if;
end process;

result_rd_proc : process(clk,ce,rs,start,mrd,mwr)
	variable r 	: std_logic;
begin
	r := rs or start or mwr;
	if clk'event and clk = '1' then
		if r = '1' then
			unload <= '0';
		elsif ce = '1' then
			if mrd = '1' then
				unload <= '1';
			end if;	
		end if;
	end if;
end process;

addrx_proc : process(clk,ce,rs,start,nxt_addr,io_mode1,ld_addr)
	variable	cen		: std_logic;
	variable	r		: std_logic;		
begin
	cen := ce and ((nxt_addr and not io_mode1) or io_mode1);
	r := (start or mwr) and not io_mode1;
	if clk'event and clk = '1' then
		if r = '1' then
			ld_addr <= (others => '0');
		elsif cen = '1' then
			ld_addr <= ld_addr + 1;
		end if;
	end if;

end process;

a2a3_s0 <= not ((not rank(0) and not rank(1)) or (rank(1) and not rank(0)) or 
           (rank(0) and not rank(1)));
           
a4a5_s0 <= not ((not rank(0) and not rank(1)) or (rank(0) and not rank(1)));  

a4a5_s1 <= (rank(0) and rank(1)) or rank(2);

a6a7_s1 <= rank(1) or rank(2);

a8a9_s0 <= rank(0) or rank(1) or rank(2);


end fft_rd_agen1;
-- FFT operand write address generator

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;
	
library xilinxcorelib;
    	use xilinxcorelib.fft_defsx_1024.all;
    	
entity fft_wr_agenx_1024 is
	port(
		clk		: in std_logic;		-- global clock
		ce		: in std_logic;		-- master clock enable
		rs		: in std_logic;		-- master reset
		start		: in std_logic;		-- xform start
		gstart		: in std_logic;
		io_mode0	: in std_logic;
		io_mode1	: in std_logic;
		dma		: in std_logic;
		result		: in std_logic;
		nxt_addr	: in std_logic;
		bank		: in std_logic;
		mwr		: in std_logic;
		--fft_wr_addr	: out std_logic_vector(log2_nfft-1 downto 0);
		fft_wr_addrx	: out std_logic_vector(log2_nfft-1 downto 0);
		fft_wr_addry	: out std_logic_vector(log2_nfft-1 downto 0)
	);
end fft_wr_agenx_1024;

architecture fft_wr_agen1 of fft_wr_agenx_1024 is

	constant reset_wr_agen		: natural := (log2_nfft/2-1) * nfft - 1; 
	constant reset_wr_agen_dma	: natural := (log2_nfft/2) * nfft - 1; 			
	constant b_init			: natural := 0; --(log2_max_nfft/2 - log2_nfft/2) * max_fft;
	constant rank_init		: natural := log2_max_nfft/2 - log2_nfft/2;
	constant m			: natural := 13;  -- max state bits
	constant mr			: natural := 3;   -- max rank cntr state bits	
	-- state counter for operand read address generator
	signal	b		: std_logic_vector(m-1 downto 0);
	signal	bb		: std_logic_vector(m-1 downto 0);	
	
	-- mux selects
	signal	a2a3_s0		: std_logic;
	signal	a4a5_s0		: std_logic;
	signal	a4a5_s1		: std_logic;
	signal	a6a7_s1		: std_logic;
	signal	a8a9_s0		: std_logic;	
	--signal	resultd		: std_logic;
	signal	fft_wr_addr_u	: std_logic_vector(log2_max_nfft-1 downto 0);	
	signal	fft_wr_addr_i	: std_logic_vector(log2_nfft-1 downto 0);		
	signal	rank		: std_logic_vector(mr-1 downto 0);	
	signal	ld_addr		: std_logic_vector(log2_nfft-1 downto 0);
		
component xdsp_mux3w1
	port (
		a		: in std_logic;	-- mux operand inputs
		b		: in std_logic;
		c		: in std_logic;
		s0		: in std_logic;	-- mux selects
		s1		: in std_logic;	-- mux selects
		y		: out std_logic	-- mux output signal
	);
end component;

component xdsp_mux2w1
	port (
		a		: in std_logic;	-- mux operand inputs
		b		: in std_logic;
		s0		: in std_logic;	-- mux sel
		y		: out std_logic	-- mux output signal
	);
end component;

begin

a0_mux : xdsp_mux2w1
	port map (
		a	=>	bb(2),
		b	=>	bb(0),
		s0	=>	rank(2),
		y	=>	fft_wr_addr_u(0) 
	);

a1_mux : xdsp_mux2w1
	port map (
		a	=>	bb(3),
		b	=>	bb(1),
		s0	=>	rank(2),
		y	=>	fft_wr_addr_u(1) 
	);
	
a2_mux : xdsp_mux3w1
	port map (
		a	=>	bb(4),
		b	=>	bb(0),
		c	=>	bb(2),
		s0	=>	a2a3_s0,
		s1	=>	rank(2),
		y	=>	fft_wr_addr_u(2) 
	);
	
a3_mux : xdsp_mux3w1
	port map (
		a	=>	bb(5),
		b	=>	bb(1),
		c	=>	bb(3),
		s0	=>	a2a3_s0,
		s1	=>	rank(2),
		y	=>	fft_wr_addr_u(3) 
	);
	
a4_mux : xdsp_mux3w1
	port map (
		a	=>	bb(6),
		b	=>	bb(0),
		c	=>	bb(4),
		s0	=>	a4a5_s0,
		s1	=>	a4a5_s1,
		y	=>	fft_wr_addr_u(4) 
	);
	
a5_mux : xdsp_mux3w1
	port map (
		a	=>	bb(7),
		b	=>	bb(1),
		c	=>	bb(5),
		s0	=>	a4a5_s0,
		s1	=>	a4a5_s1,
		y	=>	fft_wr_addr_u(5) 
	);
	
a6_mux : xdsp_mux3w1
	port map (
		a	=>	bb(8),
		b	=>	bb(0),
		c	=>	bb(6),
		s0	=>	rank(0),
		s1	=>	a6a7_s1,
		y	=>	fft_wr_addr_u(6) 
	);
	
a7_mux : xdsp_mux3w1
	port map (
		a	=>	bb(9),
		b	=>	bb(1),
		c	=>	bb(7),
		s0	=>	rank(0),
		s1	=>	a6a7_s1,
		y	=>	fft_wr_addr_u(7) 
	);
	
a8_mux : xdsp_mux2w1
	port map (
		a	=>	bb(0),
		b	=>	bb(8),
		s0	=>	a8a9_s0,
		y	=>	fft_wr_addr_u(8) 
	);		

a9_mux : xdsp_mux2w1
	port map (
		a	=>	bb(1),
		b	=>	bb(9),
		s0	=>	a8a9_s0,
		y	=>	fft_wr_addr_u(9) 
	);	

--register the write memory address

process(clk,ce,fft_wr_addr_u,mwr,result)
begin
	if clk'event and clk = '1' then
		if ce = '1' then
		    if result = '1' then
		       fft_wr_addr_i <= (others => '0');  
		    elsif mwr = '1' then
		       fft_wr_addr_i <= conv_std_logic_vector(1,log2_nfft);  
		    else
	    		fft_wr_addr_i <= fft_wr_addr_u(log2_nfft-1 downto 0); 
	    	    end if;	
	    	end if;
	end if;
end process;
		
operand_wr_agen : process(clk,ce,rs,start,io_mode0,result,dma)
	variable cen	: std_logic;
	variable ld	: std_logic;
	variable r,r1	: std_logic;
begin
	-- the ld signal handles the final rank processing when only
	-- a single memory bank is used
	
	-- DMA
	-- When dma = 1 the host interface employs a DMA data load process
	  
	ld := not io_mode0 and result;-- and not dma;
	r := rs or start;
	
	if dma = '0' and (b = reset_wr_agen) then
	    r1 := '1';
	elsif dma = '1' and (b = reset_wr_agen_dma) then
	    r1 := '1';	
	else
	    r1 := '0';
	end if;
	
	cen := ce; 
	if clk'event and clk = '1' then
	    if r = '1' or r1 = '1' then
                b <= conv_std_logic_vector(b_init,13); 
	    elsif cen = '1' then
	        if ld = '1' then
	            b <= "1000000000000"; 
	        else
		    b <= b + 1;
		end if;
	    end if;
	end if;
end process;

operand_wr_agenb : process(clk,ce,rs,start,io_mode0,result,dma,mwr)
	variable cen	: std_logic;
	variable r,r1	: std_logic;
	variable ld	: std_logic;	
begin

	r := rs or start;
	
	ld := not io_mode0 and result;
		
	if clk'event and clk = '1' then
	    if ce = '1' then
	        if ld = '1' then
	            bb <= conv_std_logic_vector(1,m);
	        elsif mwr = '1' then
	            bb <= conv_std_logic_vector(2,m);
	        elsif r = '1' or bb = nfft-1 then    
	        --elsif r = '1' or ld = '1' or bb = nfft-1 then
                    bb <= (others => '0');
	        else 
		    bb <= bb + 1;
		end if;
	    end if;
	end if;
	
end process;

rank_proc : process(clk,ce,rs,start,dma,mwr)
	variable r,r1	: std_logic;
	variable ld	: std_logic;	
begin

	-- the ld signal handles the final rank processing when only
	-- a single memory bank is used
	
	-- DMA
	-- When dma = 1 the host interface employs a DMA data load process
	r := rs or start;	
	  
	ld := (not io_mode0 and result) or mwr;
	
	if dma = '0' and (b = reset_wr_agen) then
	    r1 := '1';
	elsif dma = '1' and (b = reset_wr_agen_dma) then
	    r1 := '1';	
	else
	    r1 := '0';
	end if;
	
	if clk'event and clk = '1' then
	    if ce = '1' then 
		if r = '1' or r1 = '1' then
		    rank <= conv_std_logic_vector(rank_init,mr);
		elsif ld = '1' then
		    rank <= "100";		--conv_std_logic_vector(log2_max_nfft/2-1,mr);     
		elsif bb = nfft-1 then
		    rank <= rank + 1;
		end if;
	    end if;
	end if;
end process;

addrx_proc : process(clk,ce,rs,gstart,nxt_addr,io_mode1,ld_addr)
	variable	cen		: std_logic;
	variable	r		: std_logic;		
begin
	cen := ce and ((nxt_addr and not io_mode1) or io_mode1);
	r := (gstart or mwr) and not io_mode1;
	if clk'event and clk = '1' then
		if r = '1' then
			ld_addr <= (others => '0');
		elsif cen = '1' then
			ld_addr <= ld_addr + 1;
		end if;
	end if;

end process;

addrx_mux_proc : process(clk,ce,rs,ld_addr,fft_wr_addr_i,bank,io_mode1,mwr)
begin
    if clk'event and clk = '1' then
  	if ce = '1' then
  	    if mwr = '1' then
  	        fft_wr_addrx <= (others => '0');
  	    elsif bank = '0' and io_mode1 = '0' then
    		fft_wr_addrx <= ld_addr;
    	    else
    	        fft_wr_addrx <= fft_wr_addr_i;
  	    end if;
  	end if;
    end if;
end process;

addry_mux_proc : process(clk,ce,rs,ld_addr,fft_wr_addr_i,bank)
begin
    if clk'event and clk = '1' then
  	if ce = '1' then
  	    if bank = '0' then
    		fft_wr_addry <= fft_wr_addr_i;
    	    else
    	        fft_wr_addry <= ld_addr;
  	    end if;
  	end if;
    end if;
end process;

	a2a3_s0 <= not ((not rank(0) and not rank(1)) or (rank(1) and not rank(0)) or 
           (rank(0) and not rank(1)));
           
	a4a5_s0 <= not ((not rank(0) and not rank(1)) or (rank(0) and not rank(1)));  

	a4a5_s1 <= (rank(0) and rank(1)) or rank(2);

	a6a7_s1 <= rank(1) or rank(2);

	a8a9_s0 <= rank(0) or rank(1) or rank(2);

	--fft_wr_addr <= fft_wr_addr_i;
	
end fft_wr_agen1;
-- Synopsis: FFT constants and other definitions
-- Modification History

library ieee;
use ieee.std_logic_1164.all;
package fft_defs_64 is
    constant	B	: positive := 16;		-- word precision of FFT
    constant nfft	: natural := 64;    
    constant log2_nfft	: natural := 6;
    constant latency	: natural := 17;		-- latency through datapath
    constant max_sint	: natural := 2**(B-1) - 1;	-- max positive signed int.
    constant max_uint	: natural := 2**B;		-- max positive signed int.      
end fft_defs_64;
-- SRL16/FF based 1-bit wide 17 stage delay line

-- din -> srl16_1 -> FF1
-- srl16_1 provides 15 bits of delay and a FF procides the final 1 bit of delay 

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;

-- synopsys translate_off
library unisim;
	use unisim.vcomponents.all;
-- synopsys translate_on
		
entity z16w1 is
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		din		: in std_logic;
		dout		: out std_logic
	);
end z16w1;

architecture struct of z16w1 is

	signal	u1	: std_logic;
	signal	logic0	: std_logic;
	signal	logic1	: std_logic;
	
	
component SRL16E 
	port (
		q		: out std_logic;	
		d		: in std_logic;
		ce		: in std_logic;
		clk   		: in std_logic;
 		a0		: in std_logic;			
 		a1		: in std_logic;
 		a2		: in std_logic;
 		a3		: in std_logic
	);
end component;

begin

srl16_1 : SRL16E 
	port map(
		q		=> u1,	
		d		=> din,
		ce		=> ce,
		clk   		=> clk,
		a0		=> logic0,	-- 15 stage delay line (addr = dec 14)
 		a1		=> logic1,
 		a2		=> logic1,
 		a3		=> logic1
 	);
 	
ff1 : process (clk,ce,u1)
begin
	if clk'event and clk = '1' then
		if ce = '1' then
			dout <= u1;	
		end if;
	end if;
end process;
 
	logic0 <= '0';
	logic1 <= '1';
		 	
end struct;		   

-- SRL16/FF based 1-bit wide 18 stage delay line

-- din -> srl16_1 -> FF1  -> FF2
-- srl16_1 provides 16 bits of delay and the 2 FFs provide the additional 2 bits
-- of delay

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;

-- synopsys translate_off
library unisim;
	use unisim.vcomponents.all;
-- synopsys translate_on
		
entity z18w1 is
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		din		: in std_logic;
		dout		: out std_logic
	);
end z18w1;

architecture struct of z18w1 is

	signal	u1	: std_logic;
	signal	u2	: std_logic;
	signal	ff1_q	: std_logic;
	signal	logic0	: std_logic;
	signal	logic1	: std_logic;
	
	
component SRL16E 
	port (
		q		: out std_logic;	
		d		: in std_logic;
		ce		: in std_logic;
		clk   		: in std_logic;
 		a0		: in std_logic;			
 		a1		: in std_logic;
 		a2		: in std_logic;
 		a3		: in std_logic
	);
end component;

begin

srl16_1 : SRL16E 
	port map(
		q		=> u1,	
		d		=> din,
		ce		=> ce,
		clk   		=> clk,
		a0		=> logic1,	-- 16 stage delay line (addr = dec 15)
 		a1		=> logic1,
 		a2		=> logic1,
 		a3		=> logic1
 	);
 	
ff1 : process (clk,ce,u1)
begin
	if clk'event and clk = '1' then
		if ce = '1' then
			ff1_q <= u1;	
		end if;
	end if;
end process;


ff2 : process (clk,ce,u1)
begin
	if clk'event and clk = '1' then
		if ce = '1' then
			dout <= ff1_q;	
		end if;
	end if;
end process;
 
	logic0 <= '0';
	logic1 <= '1';
		 	
end struct;		   
-- complex multiplier
-- This module implements a 16 x 17 bit complex multiplier. The real 
-- and imaginary components of the input operands are kept to a 
-- precision of 16 bits. A 16-bit complex number is returned, again 
-- 16 bits is allocated for each of the real and imaginary components.
-- The product is perfomed as

--	(ar + jai) x (br + jbi) = e + jf
--	where
--	e = (ar - ai)bi + ar(br - bi) and
--	f = (ar - ai)bi + ar(br + bi)

-- Creation Date: 2/18/1999 

-- 4/22/99	baseblox 16-bit adder integration
-- 4/27/99	changed pin names to baseblox compliant naming convention
-- 16/6/99	Modified 'xmul16x17z' design to generate a complex mult.
--		with 1 clk. cycles less latency. The multipliers were changed from
--		'mul16x17z' components to 'mul16x17zz4' modules.

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;

entity xmul16x17z is
	port (
		clk		: in std_logic;		-- system clock
		rs		: in std_logic;		-- reset
		ce		: in std_logic;		-- master clk enable
		ar		: in std_logic_vector(15 downto 0);  	-- Re(operand 1)
		ai		: in std_logic_vector(15 downto 0);	-- Im(operand 1)
		br		: in std_logic_vector(15 downto 0);	-- Re(operand 2)
		bi		: in std_logic_vector(15 downto 0);	-- Im(operand 2)
		pr		: out std_logic_vector(16 downto 0);	-- Re( a x b)
		pi		: out std_logic_vector(16 downto 0)	-- Im( a x b)
	      );
end xmul16x17z;

architecture struct of xmul16x17z is

	-- temp for holding (ar - ai)
	signal	ar_min_ai	: std_logic_vector(16 downto 0);
	
	-- temp for holding (br - bi)
	signal	br_min_bi	: std_logic_vector(16 downto 0);
	
	-- temp for holding (br + bi)
	signal	br_plus_bi	: std_logic_vector(16 downto 0);
	
	-- pipeline balancing registers for input operands
	-- These compensate for the delay through the pre-add stage
	signal	biz		: std_logic_vector(15 downto 0);
	signal	arz		: std_logic_vector(15 downto 0);
	signal	aiz		: std_logic_vector(15 downto 0);
	signal	proda		: std_logic_vector(32 downto 0); 	-- (ar-ai)*bi
	signal	prodb		: std_logic_vector(32 downto 0); 	-- (br-bi)*ar
	signal	prodc		: std_logic_vector(32 downto 0); 	-- (br+bi)*ai
	
	-- signals for holding full precision outputs
	signal	pr_full_precision	: std_logic_vector(17 downto 0);	-- Re(product)
	signal	pi_full_precision	: std_logic_vector(17 downto 0);	-- Im(product)
	
	-- constants for supplying logic levels to unused component pins
	signal	logic_1		: std_logic;
	signal	logic_0		: std_logic;
	
	signal	tmpa,tmpc	: std_logic_vector(15 downto 0);
	signal	null0		: std_logic_vector(15 downto 0);
	signal	null1		: std_logic_vector(15 downto 0);

component xdsp_reg16
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		d		: in std_logic_vector(15 downto 0);	-- data in
		q		: out std_logic_vector(15 downto 0)	-- data out
	      );
end component;

component xdsp_radd16
  PORT( a 	: IN  std_logic_vector( 16 - 1 DOWNTO 0 );
        b 	: IN  std_logic_vector( 16 - 1 DOWNTO 0 );
        clk 	: IN  std_logic;
        ce 	: IN  std_logic;
        c_in 	: IN  std_logic;
        --clr 	: IN  std_logic;
        q 	: OUT std_logic_vector( 16 DOWNTO 0 ));
END component;

component xdsp_radd17
  PORT( a 	: IN  std_logic_vector( 16  DOWNTO 0 );
        b 	: IN  std_logic_vector( 16  DOWNTO 0 );
        clk 	: IN  std_logic;
        ce 	: IN  std_logic;
        c_in 	: IN  std_logic;
        --clr 	: IN  std_logic;
        q 	: OUT std_logic_vector( 17 DOWNTO 0 ));
END component;

component xdsp_rsub16
  PORT( a 	: IN  std_logic_vector( 16 - 1 DOWNTO 0 );
        b 	: IN  std_logic_vector( 16 - 1 DOWNTO 0 );
        clk 	: IN  std_logic;
        ce 	: IN  std_logic;
        b_in 	: IN  std_logic;
        --clr 	: IN  std_logic;
        q 	: OUT std_logic_vector( 16 DOWNTO 0 ));
END component;

component xdsp_mul16x17z4
  port( a        : in  std_logic_vector( 16 downto 0 );
        b        : in  std_logic_vector( 15 downto 0 );     
        clk      : in  std_logic;
        ce       : in  std_logic;
        p	 : out std_logic_vector( (16 + 16) downto 0));
end component;

attribute RLOC : string;	
attribute RLOC of ar_min_ai_sub : label is "R0C0";
attribute RLOC of biz_reg : label is "R0C0";
attribute RLOC of mula: label is "R0C1";   
attribute RLOC of br_min_bi_sub : label is "R0C10";
attribute RLOC of arz_reg : label is "R0C10";
attribute RLOC of mulb: label is "R0C11";  
attribute RLOC of br_plus_bi_sub : label is "R14C1";
attribute RLOC of aiz_reg : label is "R14C1";
attribute RLOC of mulc: label is "R14C2";
attribute RLOC of pr_add : label is "R0C19";
attribute RLOC of pi_add : label is "R6C9";

begin

ar_min_ai_sub : xdsp_rsub16
	port map(
	a		=> ar,
	b		=> ai,
	clk		=> clk,
	ce		=> ce,
	b_in		=> logic_1,
	--clr		=> logic_0,
	q		=> ar_min_ai
	);
	
br_min_bi_sub : xdsp_rsub16
	port map(
	a		=> br,
	b		=> bi,
	clk		=> clk,
	ce		=> ce,
	b_in		=> logic_1,
	--clr		=> logic_0,
	q		=> br_min_bi
	);
	 
br_plus_bi_sub : xdsp_radd16
	port map(
	a		=> br,
	b		=> bi,
	clk		=> clk,
	ce		=> ce,
	c_in		=> logic_0,
	--clr		=> logic_0,
	q		=> br_plus_bi
	);
	
-- component computes (ar - ai) x bi
mula : xdsp_mul16x17z4
	port map(
	a		=> ar_min_ai(16 downto 0),
	b		=> biz,
	clk		=> clk,
	ce		=> ce,
	p		=> proda
	);
	
-- component computes (br - bi) x ar
mulb : xdsp_mul16x17z4
	port map(
	a		=> br_min_bi(16 downto 0),
	b		=> arz,
	clk		=> clk,
	ce		=> ce,
	p		=> prodb
	);

-- component computes (br + bi) x ai
mulc : xdsp_mul16x17z4
	port map(
	a		=> br_plus_bi(16 downto 0),
	b		=> aiz,
	clk		=> clk,
	ce		=> ce,
	p		=> prodc
	);
		
-- pipeline balancing registers to compensate for latency through pre-addition stage
biz_reg : xdsp_reg16
	port map(
		clk	=> clk,			-- master clock
		ce	=> ce,			-- master ce
		d	=> bi,			-- data input
		q	=> biz			-- delayed input sample
	);
	
-- pipeline balancing registers to compensate for latency through pre-addition stage
arz_reg : xdsp_reg16
	port map(
		clk	=> clk,			-- master clock
		ce	=> ce,			-- master ce
		d	=> ar,			-- data input
		q	=> arz			-- delayed input sample
	);

-- pipeline balancing registers to compensate for latency through pre-addition stage
aiz_reg : xdsp_reg16
	port map(
		clk	=> clk,			-- master clock
		ce	=> ce,			-- master ce
		d	=> ai,			-- data input
		q	=> aiz			-- delayed input sample
	);	
	
-- final output post-adds to form Re/Im components of output product

pr_add : xdsp_radd17					-- real part
	port map (
	a 		=> prodb(31 downto 15),
        b 		=> proda(31 downto 15),
        clk 		=> clk,
        ce 		=> ce,
        c_in 		=> logic_0,
        --clr 		=> rs,
        q		=> pr_full_precision
	);
	
pi_add : xdsp_radd17					-- imag. part
	port map (
	a 		=> prodc(31 downto 15),
        b 		=> proda(31 downto 15),
        clk 		=> clk,
        ce 		=> ce,
        c_in 		=> logic_0,
        --clr 		=> rs,
        q 		=> pi_full_precision
	);
	 
	tmpa <= proda(30 downto 15);
	tmpc <= prodc(30 downto 15);
	pr <= pr_full_precision(16 downto 0);	 
	pi <= pi_full_precision(16 downto 0);	
	logic_1 <= '1';
	logic_0 <= '0';
	 
end struct;




-- Virtex  FFT
-- complex 2:1 16-bit registered multiplexor

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;
	
entity xmux2w16 is
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		s0		: in std_logic;				-- mux select inputs
		x0r		: in std_logic_vector(15 downto 0);	-- mux inputs Re and Im
		x0i		: in std_logic_vector(15 downto 0);
		x1r		: in std_logic_vector(15 downto 0);	
		x1i		: in std_logic_vector(15 downto 0);
		yr		: out std_logic_vector(15 downto 0);	-- mux outputs
		yi		: out std_logic_vector(15 downto 0)
	      );
end xmux2w16;

architecture struct of xmux2w16 is

	signal	omuxr		: std_logic_vector(15 downto 0);
	signal	omuxi		: std_logic_vector(15 downto 0);
	
component xdsp_mux2w16
  PORT( ma : IN  std_logic_vector( 16 -1 DOWNTO 0 );
        mb : IN  std_logic_vector( 16 -1 DOWNTO 0 );
        sel : IN  std_logic;
        o : OUT std_logic_vector( 16 -1 DOWNTO 0 ) );
END component;

attribute RLOC : string;
attribute RLOC of mux2w16_r : label is "R0C0";
attribute RLOC of mux2w16_i : label is "R8C0";

begin

mux2w16_r : xdsp_mux2w16
	port map(
		ma		=> x0r,
		mb		=> x1r,
		sel		=> s0,
		o		=> yr
	);
	
mux2w16_i : xdsp_mux2w16
	port map(
		ma		=> x0i,
		mb		=> x1i,
		sel		=> s0,
		o		=> yi
	);	
	
end struct;
-- Virtex 16-point FFT
-- complex 4:1 16-bit registered multiplexor

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;
		
entity xmux4w16 is
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		s0		: in std_logic;				-- mux select inputs
		s1		: in std_logic;
		x0r		: in std_logic_vector(15 downto 0);	-- mux inputs Re and Im
		x0i		: in std_logic_vector(15 downto 0);
		x1r		: in std_logic_vector(15 downto 0);	
		x1i		: in std_logic_vector(15 downto 0);
		x2r		: in std_logic_vector(15 downto 0);	
		x2i		: in std_logic_vector(15 downto 0);
		x3r		: in std_logic_vector(15 downto 0);	
		x3i		: in std_logic_vector(15 downto 0);
		yr		: out std_logic_vector(15 downto 0);	-- mux outputs
		yi		: out std_logic_vector(15 downto 0)
	      );
end xmux4w16;

architecture struct of xmux4w16 is

	signal	omuxr		: std_logic_vector(15 downto 0);
	signal	omuxi		: std_logic_vector(15 downto 0);
	
component xdsp_mux4w16
  PORT( ma 		: IN  std_logic_vector( 16 -1 DOWNTO 0 );
        mb 		: IN  std_logic_vector( 16 -1 DOWNTO 0 );
        mc 		: IN  std_logic_vector( 16 -1 DOWNTO 0 );
        md 		: IN  std_logic_vector( 16 -1 DOWNTO 0 );
        sel 		: IN  std_logic_vector(1 downto 0);
        o 		: OUT std_logic_vector( 16 -1 DOWNTO 0 ) );
END component;

component xdsp_reg16l
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		d		: in std_logic_vector(15 downto 0);	-- data in
		q		: out std_logic_vector(15 downto 0)	-- data out
	      );
end component;

--attribute RLOC : string;
--attribute RLOC of mux4w16_r : label is "R0C0";
--attribute RLOC of mux4w16_i : label is "R13C9";
--attribute RLOC of muxreg_r  : label is "R0C0";
--attribute RLOC of muxreg_i  : label is "R13C9";

begin

mux4w16_r : xdsp_mux4w16
	port map(
		ma		=> x0r,
		mb		=> x1r,
		mc		=> x2r,
		md		=> x3r,
		sel(0)		=> s0,
		sel(1)		=> s1,
		o		=> omuxr
	);
	
mux4w16_i : xdsp_mux4w16
	port map(
		ma		=> x0i,
		mb		=> x1i,
		mc		=> x2i,
		md		=> x3i,
		sel(0)		=> s0,
		sel(1)		=> s1,
		o		=> omuxi
	);
	
muxreg_r : xdsp_reg16l
	port map(
		clk		=> clk,				-- global clk
		ce		=> ce,				-- register ce
		d		=> omuxr,			-- data input
		q		=> yr				-- registered data output		
	);	

muxreg_i : xdsp_reg16l
	port map(
		clk		=> clk,				-- global clk
		ce		=> ce,				-- register ce
		d		=> omuxi,			-- data input
		q		=> yi				-- registered data output		
	);
	
end struct;
-- dragonfly processor

-- Modification History:
-- 16/06/99	The complex multiplier was replaced with a unit that provides
--		one clk. cycle less latency. This involved replacing
--		'xmul16x17' with 'xmul16x17z'.
-- 16/06/99	Removed the 'rd_stall' signal from the 4-point FFT module 'fft4'.
-- 16/06/99	Reomoved the output multiplexor stall signal 'fft4_omux_state_stall'
--		from the process 'fft4_omux_state_mach'.

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;

library xilinxcorelib;
	use xilinxcorelib.fft_defs_64.all;	
	
entity dragonfly_64 is
	port (
		clk		: in std_logic;		-- system clock
		rs		: in std_logic;		-- reset
		start		: in std_logic;		-- start transform
		ce		: in std_logic;		-- master clk enable
		conj		: in std_logic;		-- conjugation control
		xnr		: in std_logic_vector(B-1 downto 0);
		xni		: in std_logic_vector(B-1 downto 0);
		wr		: in std_logic_vector(B-1 downto 0);	-- phase factors
		wi		: in std_logic_vector(B-1 downto 0);
		xk_r		: out std_logic_vector(B downto 0);
		xk_i		: out std_logic_vector(B downto 0)
	      );
end dragonfly_64;

architecture struct of dragonfly_64 is

	-- fft4 output mux selects
	signal	fft4_omux_s0		: std_logic;
	signal	fft4_omux_s1		: std_logic;
	signal	fft4_omux_state_cntr	: std_logic_vector(1 downto 0);
	
	-- 4-point FFT output samples
	signal	y0r			: std_logic_vector(B-1 downto 0);
	signal	y0i			: std_logic_vector(B-1 downto 0);
	signal	y1r			: std_logic_vector(B-1 downto 0);
	signal	y1i		     	: std_logic_vector(B-1 downto 0);
	signal	y2r			: std_logic_vector(B-1 downto 0);
	signal	y2i			: std_logic_vector(B-1 downto 0);
	signal	y3r			: std_logic_vector(B-1 downto 0);
	signal	y3i			: std_logic_vector(B-1 downto 0);
	
	-- output of multiplexor that selects the output samples from the 4-point FFT
	signal	tr			: std_logic_vector(B-1 downto 0);
	signal	ti			: std_logic_vector(B-1 downto 0);
	signal	fft4_omux_state_stall	: std_logic;
	signal	r			: std_logic;
		
	--signal cen			: std_logic;
	
component fft4
	port (
		clk		: in std_logic;				-- system clock
		rs		: in std_logic;				-- reset
		start		: in std_logic;				-- global start
		ce		: in std_logic;
		conj		: in std_logic;
		dr		: in std_logic_vector(B-1 downto 0);
		di		: in std_logic_vector(B-1 downto 0);
		y0r		: out std_logic_vector(B-1 downto 0);
		y0i		: out std_logic_vector(B-1 downto 0);
		y1r		: out std_logic_vector(B-1 downto 0);
		y1i		: out std_logic_vector(B-1 downto 0);
		y2r		: out std_logic_vector(B-1 downto 0);
		y2i		: out std_logic_vector(B-1 downto 0);
		y3r		: out std_logic_vector(B-1 downto 0);
		y3i		: out std_logic_vector(B-1 downto 0)
	      );
end component;

component xmux4w16
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		s0		: in std_logic;				-- mux select inputs
		s1		: in std_logic;
		x0r		: in std_logic_vector(B-1 downto 0);	-- mux inputs Re and Im
		x0i		: in std_logic_vector(B-1 downto 0);
		x1r		: in std_logic_vector(B-1 downto 0);	
		x1i		: in std_logic_vector(B-1 downto 0);
		x2r		: in std_logic_vector(B-1 downto 0);	
		x2i		: in std_logic_vector(B-1 downto 0);
		x3r		: in std_logic_vector(B-1 downto 0);	
		x3i		: in std_logic_vector(B-1 downto 0);
		yr		: out std_logic_vector(B-1 downto 0);	-- mux outputs
		yi		: out std_logic_vector(B-1 downto 0)
	      );
end component;

-- B x 17 complex multiplier
component xmul16x17z
	port (
		clk		: in std_logic;		-- system clock
		rs		: in std_logic;		-- reset
		ce		: in std_logic;		-- master clk enable
		ar		: in std_logic_vector(B-1 downto 0);  	-- Re(operand 1)
		ai		: in std_logic_vector(B-1 downto 0);	-- Im(operand 1)
		br		: in std_logic_vector(B-1 downto 0);	-- Re(operand 2)
		bi		: in std_logic_vector(B-1 downto 0);	-- Im(operand 2)
		pr		: out std_logic_vector(B downto 0);	-- Re( a x b)
		pi		: out std_logic_vector(B downto 0)	-- Im( a x b)
	      );
end component;

component z10w1
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		din		: in std_logic;
		dout		: out std_logic
	);
end component;

attribute RLOC : string;
attribute RLOC of xfft4 : label is "R0C0"; 
attribute RLOC of xmul : label is "R0C7";

begin

-- 4-point FFT port mappings
-- This small transform is applied to the input data prior to processing by the
-- complex multiplier
	
xfft4 : fft4
	port map (
		clk		=> clk,				-- system clock
		rs		=> rs,				-- reset
		start		=> start,			-- global start
		ce		=> ce,				-- master clk enable
		conj		=> conj,
		dr		=> xnr,				-- Re/Im input sample
		di		=> xni,
		y0r		=> y0r,				-- output samples
		y0i		=> y0i,
		y1r		=> y1r,
		y1i		=> y1i,
		y2r		=> y2r,
		y2i		=> y2i,
		y3r		=> y3r,
		y3i		=> y3i		
	);

fft4_omux : xmux4w16 
	port map (
		clk		=> clk,			-- system clock
		ce		=> ce,			-- global clk enable
		s0		=> fft4_omux_s0,	-- mux select inputs
		s1		=> fft4_omux_s1,
		x0r		=> y2r,	
		x0i		=> y2i,
		x1r		=> y3r,	
		x1i		=> y3i,
		x2r		=> y0r,	
		x2i		=> y0i,
		x3r		=> y1r,	
		x3i		=> y1i,
		yr		=> tr,			-- sample presented to cmplx mul
		yi		=> ti
	);

-- complex product 
-- This module accepts outputs from the 4-point FFT 'xfft4' and applies
-- the phase rotations read from the phase factor trig LUT
-- The complex samples from the xfft4 unit are presented to the complex multiplier
-- via the 4:1 complex mutliplexor 'fft4_omux'.

xmul : xmul16x17z 
	port map(
		clk		=> clk,		-- system clock
		rs		=> rs,		-- reset
		ce		=> ce,		-- master clk enable
		ar		=> tr, 		-- Re(operand 1)
		ai		=> ti,		-- Im(operand 1)
		br		=> wr,		-- Re(operand 2)
		bi		=> wi,		-- Im(operand 2)
		pr		=> xk_r,	-- output: Re( a x b)
		pi		=> xk_i		-- output: Im( a x b)
	      );
	      
-- rank-0 4-point FFT state machine

fft4_omux_state_mach : process(clk,rs,ce,start)
    variable cen	: std_logic;
begin
	cen := ce; 
	if rs = '1' or start = '1' then
		fft4_omux_state_cntr <= (others => '0');
	elsif clk'event and clk='1' then
		if cen = '1' then
			fft4_omux_state_cntr <= fft4_omux_state_cntr + 1;
		end if;	
	end if;
end process;

	fft4_omux_s0 <= fft4_omux_state_cntr(0);
	fft4_omux_s1 <= fft4_omux_state_cntr(1);
	r <= rs or start;
	
end struct;
-- 64-point FFT operand read/write address generator

-- Modification History

-- 15/06/99	The signal 'bb' was removed from the design along with the
--		process 'operand_rd_state'
-- 15/06/99	The process 'operand_rd_agen' was modifed to provide a sync.
--		reset. This process previsously used an async. reset.
--		The state counter 'b' now rolls over at the completion of a
--		transform to start the operand fetch for a new FFT, so avoiding the
--		need for the 'start' signal to be applied to the core.
-- 16/06/99	Read stall operation removed from 'operand_rd_agen' process.

-- ************************************************************************
--  Copyright 1996-2000 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;
	
library xilinxcorelib;
	use xilinxcorelib.fft_defs_64.all;

entity fft_rd_agen_64 is
	port(
		clk		: in std_logic;		-- global clock
		ce		: in std_logic;		-- master clock enable
		rs		: in std_logic;		-- master reset
		start		: in std_logic;		-- xform start
		mrd		: in std_logic;
		mwr		: in std_logic;	
		io_mode0	: in std_logic;
		io_mode1	: in std_logic;	
		bank		: in std_logic;
		nxt_addr	: in std_logic;
		fft_rd_addr	: out std_logic_vector(log2_nfft-1 downto 0);
		fft_rd_addry	: out std_logic_vector(log2_nfft-1 downto 0)
	);
end fft_rd_agen_64;

architecture struct of fft_rd_agen_64 is

	constant reset_rd_agen	: natural := log2_nfft/2 * nfft - 1; 
	constant m			: natural := 8;  -- max state bits	
	-- state counter for operand read address generator
	signal	b		: std_logic_vector(m-1 downto 0);
	
	-- mux select
	signal	a0a1_s0		: std_logic;
	signal	a4a5_s0		: std_logic;
	signal 	fft_rd_addr_u	: std_logic_vector(log2_nfft-1 downto 0);	
	signal 	unload		: std_logic;
	signal	ld_addr		: std_logic_vector(log2_nfft-1 downto 0);
		
component xdsp_mux3w1
	port (
		a		: in std_logic;	-- mux operand inputs
		b		: in std_logic;
		c		: in std_logic;
		s0		: in std_logic;	-- mux selects
		s1		: in std_logic;	-- mux selects
		y		: out std_logic	-- mux output signal
	);
end component;

component xdsp_mux2w1
	port (
		a		: in std_logic;	-- mux operand inputs
		b		: in std_logic;
		s0		: in std_logic;	-- mux sel
		y		: out std_logic	-- mux output signal
	);
end component;

begin

a0_mux : xdsp_mux2w1
	port map (
		a	=>	b(2),
		b	=>	b(0),
		s0	=>	a0a1_s0,
		y	=>	fft_rd_addr_u(0) 
	);

a1_mux : xdsp_mux2w1
	port map (
		a	=>	b(3),
		b	=>	b(1),
		s0	=>	a0a1_s0,
		y	=>	fft_rd_addr_u(1) 
	);
			
a2_mux : xdsp_mux3w1
	port map (
		a	=>	b(4),
		b	=>	b(0),
		c	=>	b(2),
		s0	=>	b(6),
		s1	=>	b(7),
		y	=>	fft_rd_addr_u(2) 
	);
	
a3_mux : xdsp_mux3w1
	port map (
		a	=>	b(5),
		b	=>	b(1),
		c	=>	b(3),
		s0	=>	b(6),
		s1	=>	b(7),
		y	=>	fft_rd_addr_u(3) 
	);
	
a4_mux : xdsp_mux2w1
	port map (
		a	=>	b(0),
		b	=>	b(4),
		s0	=>	a4a5_s0,
		y	=>	fft_rd_addr_u(4) 
	);
	
a5_mux : xdsp_mux2w1
	port map (
		a	=>	b(1),
		b	=>	b(5),
		s0	=>	a4a5_s0,
		y	=>	fft_rd_addr_u(5) 
	);	


reg_rd_addr: process(clk,ce,rs,start,mrd,mwr,bank,io_mode1)
	variable r	: std_logic;
begin
	r := rs or start or mrd or mwr;
	if clk'event and clk = '1' then
		if r = '1' then
			fft_rd_addr <= (others => '0');
		elsif ce = '1' then
		    if unload = '1' then
			fft_rd_addr <= (b(1),b(0),b(3),b(2),b(5),b(4));		
		    elsif bank = '0' and io_mode1 = '0' then
	    		fft_rd_addr <= ld_addr;
	    	    else	    
			fft_rd_addr <= fft_rd_addr_u;
		    end if;
		end if;
	end if;
end process;

reg_rd_addry: process(clk,ce,rs,start,mwr,bank,io_mode1)
	variable r	: std_logic;
begin
	r := rs or start or mwr;
	if clk'event and clk = '1' then
		if r = '1' then
			fft_rd_addry <= (others => '0');
		elsif ce = '1' then	
		    if bank = '1' and io_mode1 = '0' then
	    		fft_rd_addry <= ld_addr;
	    	    else	    
			fft_rd_addry <= fft_rd_addr_u;
		    end if;
		end if;
	end if;
end process;
			
operand_rd_agen : process(clk,ce,rs,start,mrd,mwr)
	variable cen	: std_logic;
	variable init	: std_logic;
begin
	cen := ce;
	init := start or mrd or mwr;				
	if clk'event and clk = '1' then
	    	if mwr = '1' then
	            b <= "10000001";	
		elsif init = '1' then
			b <= conv_std_logic_vector(1,m);
		elsif rs = '1' or b = reset_rd_agen then
			b <= (others => '0');
		elsif cen = '1' then
			b <= b + 1;
		end if;
	end if;
end process;

result_rd_proc : process(clk,ce,rs,start,mrd,mwr)
	variable r 	: std_logic;
begin
	r := rs or start or mwr;
	if clk'event and clk = '1' then
		if r = '1' then
			unload <= '0';
		elsif ce = '1' then
			if mrd = '1' then
				unload <= '1';
			end if;	
		end if;
	end if;
end process;

addrx_proc : process(clk,ce,rs,start,nxt_addr,io_mode1,ld_addr)
	variable	cen		: std_logic;
	variable	r		: std_logic;		
begin
	cen := ce and ((nxt_addr and not io_mode1) or io_mode1);
	r := (start or mwr);						-- and not io_mode1;
	if clk'event and clk = '1' then
		if r = '1' then
			ld_addr <= (others => '0');
		elsif cen = '1' then
			ld_addr <= ld_addr + 1;
		end if;
	end if;

end process;

--addrx_mux_proc : process(clk,ce,rs,ld_addr,fft_rd_addr_u,bank,io_mode1,mwr)
--begin
--    if clk'event and clk = '1' then
--  	if ce = '1' then
--  	    if mwr = '1' then
--  	        fft_rd_addrx <= (others => '0');
--  	    elsif bank = '0' and io_mode1 = '0' then
--    		fft_rd_addrx <= ld_addr;
--    	    else
--    	        fft_rd_addrx <= fft_rd_addr_u;
--  	    end if;
--  	end if;
--    end if;
--end process;

	a0a1_s0 <= not b(6) and b(7);
	a4a5_s0 <= b(6) or b(7);

end struct;
-- 64-point FFT result write address generator
-- Modification History: 
-- 12/06/99	The io signal was added. This signal is used to indicate the start of an 
--		IO cycle.
-- 15/06/99	The process 'operand_wr_agen' was changed to employ a sync, rather than
--		an async. reset. The signal 'b' is now reset at the end of an FFT and
--		so is automatically set-up to start a new FFT without requiring 
--		assertion of the primary 'start' signal.
--		
-- 16/06/99	The write address generator had the stall signal removed.		
-- 23/06/99	'io' is now a function of 'busy'


-- ************************************************************************
--  Copyright 1996-2000 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;
	
library xilinxcorelib;
	use xilinxcorelib.fft_defs_64.all;

entity fft_wr_agen_64 is
	port(
		clk		: in std_logic;		-- global clock
		ce		: in std_logic;		-- master clock enable
		rs		: in std_logic;		-- master reset
		start		: in std_logic;		-- addr gen start
		gstart		: in std_logic;		-- primary FFT start		
		busy		: in std_logic;
		nxt_addr	: in std_logic;
		io_mode1	: in std_logic;
		mwr		: in std_logic;
		bank		: in std_logic;
		fft_wr_addr	: out std_logic_vector(log2_nfft-1 downto 0);
		fft_wr_addrx	: out std_logic_vector(log2_nfft-1 downto 0);
		fft_wr_addry	: out std_logic_vector(log2_nfft-1 downto 0);		
		index		: out std_logic_vector(log2_nfft-1 downto 0) -- outp. index bus
	);
end fft_wr_agen_64;

architecture struct of fft_wr_agen_64 is

    	constant reset_wr_agen	: natural := log2_nfft/2 * nfft - 1; 	
	constant mr		: natural := 3;   -- max rank cntr state bits   
	 		
	-- state counter for operand read address generator
	signal	b		: std_logic_vector(7 downto 0);
	
	-- mux select
	signal	a0a1_s0		: std_logic;
	signal	a4a5_s0		: std_logic;
	signal	fft_wr_addr_u	: std_logic_vector(log2_nfft-1 downto 0);
	signal	ld_addr		: std_logic_vector(log2_nfft-1 downto 0);	
	signal	fft_wr_addr_i	: std_logic_vector(log2_nfft-1 downto 0);
	signal	index_z		: std_logic_vector(log2_nfft-1 downto 0);	
	signal	rank		: std_logic_vector(mr-1 downto 0);
			
component xdsp_mux3w1
	port (
		a		: in std_logic;	-- mux operand inputs
		b		: in std_logic;
		c		: in std_logic;
		s0		: in std_logic;	-- mux selects
		s1		: in std_logic;	-- mux selects
		y		: out std_logic	-- mux output signal
	);
end component;

component xdsp_mux2w1
	port (
		a		: in std_logic;	-- mux operand inputs
		b		: in std_logic;
		s0		: in std_logic;	-- mux sel
		y		: out std_logic	-- mux output signal
	);
end component;

begin

a0_mux : xdsp_mux2w1
	port map (
		a	=>	b(2),
		b	=>	b(0),
		s0	=>	a0a1_s0,
		y	=>	fft_wr_addr_u(0) 
	);

a1_mux : xdsp_mux2w1
	port map (
		a	=>	b(3),
		b	=>	b(1),
		s0	=>	a0a1_s0,
		y	=>	fft_wr_addr_u(1) 
	);
			
a2_mux : xdsp_mux3w1
	port map (
		a	=>	b(4),
		b	=>	b(0),
		c	=>	b(2),
		s0	=>	b(6),
		s1	=>	b(7),
		y	=>	fft_wr_addr_u(2) 
	);
	
a3_mux : xdsp_mux3w1
	port map (
		a	=>	b(5),
		b	=>	b(1),
		c	=>	b(3),
		s0	=>	b(6),
		s1	=>	b(7),
		y	=>	fft_wr_addr_u(3) 
	);
	
a4_mux : xdsp_mux2w1
	port map (
		a	=>	b(0),
		b	=>	b(4),
		s0	=>	a4a5_s0,
		y	=>	fft_wr_addr_u(4) 
	);
	
a5_mux : xdsp_mux2w1
	port map (
		a	=>	b(1),
		b	=>	b(5),
		s0	=>	a4a5_s0,
		y	=>	fft_wr_addr_u(5) 
	);	
	      
			
operand_wr_agen : process(clk,ce,rs,start,mwr)
	variable cen	: std_logic;
begin
	cen := ce; 
	if clk'event and clk = '1' then
	    if mwr = '1' then
	            b <= "10000010";
	    elsif rs = '1' or start = '1' or b = reset_wr_agen then
		b <= (others => '0');
	    elsif cen = '1' then
		b <= b + 1;
	    end if;
	end if;
end process;

reg_wr_addr_proc : process(clk,ce,fft_wr_addr_u,mwr)
begin
	if clk'event and clk = '1' then
	    if mwr = '1' then
	        fft_wr_addr_i <= conv_std_logic_vector(1,log2_nfft);
	    elsif ce = '1' then
	        fft_wr_addr_i <= fft_wr_addr_u;
	    end if;
	end if;
end process;

reg_index_proc : process(clk,ce,b)
begin
	if clk'event and clk = '1' then
	    if ce = '1' then
	        index_z <= (b(1),b(0),b(3),b(2),b(5),b(4));
	        index <= index_z;
	    end if;
	end if;
end process;

addrx_proc : process(clk,ce,rs,gstart,nxt_addr,io_mode1,ld_addr)
	variable	cen		: std_logic;
	variable	r		: std_logic;		
begin
	cen := ce and ((nxt_addr and not io_mode1) or io_mode1);
	r := (gstart or mwr);						-- and not io_mode1;
	if clk'event and clk = '1' then
		if r = '1' then
			ld_addr <= (others => '0');
		elsif cen = '1' then
			ld_addr <= ld_addr + 1;
		end if;
	end if;

end process;

addrx_mux_proc : process(clk,ce,rs,ld_addr,fft_wr_addr_i,bank,io_mode1,mwr)
begin
    if clk'event and clk = '1' then
  	if ce = '1' then
  	    if mwr = '1' then
  	        fft_wr_addrx <= (others => '0');
  	    elsif bank = '0' and io_mode1 = '0' then
    		fft_wr_addrx <= ld_addr;
    	    else
    	        fft_wr_addrx <= fft_wr_addr_i;
  	    end if;
  	end if;
    end if;
end process;

addry_mux_proc : process(clk,ce,rs,ld_addr,fft_wr_addr_i,bank)
begin
    if clk'event and clk = '1' then
  	if ce = '1' then
  	    if bank = '0' then
    		fft_wr_addry <= fft_wr_addr_i;
    	    else
    	        fft_wr_addry <= ld_addr;
  	    end if;
  	end if;
    end if;
end process;
  
	a0a1_s0 <= not b(6) and b(7);
	a4a5_s0 <= b(6) or b(7);
	fft_wr_addr <= fft_wr_addr_i;
end struct;
-- FFT, N=64 phase factor address generator

-- Modification History

-- 15/06/99	The entity declaration was modifed to include 'result'. When result=1,
--		this indicates that the final processing rank is being performed. This,
--		along with the 'nxt_rank' signal is used to reset the address generator.
--		The reset is performed by loading the two shift registers 'sr1' and 'sr2'
--		with the appropriate initial values.

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;
    --use ieee.std_logic_unsigned.all;
    use ieee.std_logic_unsigned."+";
    
library xilinxcorelib;
	use xilinxcorelib.fft_defs_64.all;
	
entity phase_agen_64 is
    port (
    	    clk			: in std_logic;		-- global clock
    	    ce			: in std_logic;		-- global clock enable
    	    start		: in std_logic;		-- system start
    	    rs			: in std_logic;		-- master reset
    	    result		: in std_logic;		-- result=1 indicates the
    	    						-- final rank is being processed
    	    phase_addr		: inout std_logic_vector(log2_nfft-1 downto 0)	-- phase angle
    );
end phase_agen_64;

architecture behv of phase_agen_64 is

    signal kinc			: std_logic_vector(log2_nfft-2 downto 0);
    signal kincm		: std_logic_vector(log2_nfft-1 downto 0);
    signal tmp_kincm		: std_logic_vector(B-1 downto 0);
    signal tmp_kinc		: std_logic_vector(B-1 downto 0);
    
    -- butterfly counter
    signal bfli			: std_logic_vector(log2_nfft-1 downto 0);
    signal nxt_rank		: std_logic;	-- indicates the start of a new rank
    signal bfly			: std_logic_vector(log2_nfft-1 downto 0);   
    signal reset_bfly		: std_logic;
    signal pinco		: std_logic_vector(log2_nfft-2 downto 0);
    signal nxt_bfly		: std_logic;
    signal k1,k2		: std_logic_vector(B-1 downto 0);
    signal logic0		: std_logic;
    signal load_sr		: std_logic;
        
component shift_reg2b
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		load		: in std_logic;
		din		: in std_logic_vector(B-1 downto 0);
		ser_data_in0	: in std_logic;
		ser_data_in1	: in std_logic;
		par_data	: inout std_logic_vector(B-1 downto 0)
	);
end component;

begin

sr1 : shift_reg2b
	port map(
	 	clk		=> clk,
	 	ce		=> nxt_rank,
	 	rs		=> rs,
	 	load		=> load_sr,		--start,
	 	din		=> k1,
	 	ser_data_in0	=> logic0,
	 	ser_data_in1	=> logic0,
	 	par_data	=> tmp_kinc
	);
	
sr2 : shift_reg2b
	port map(
	 	clk		=> clk,
	 	ce		=> nxt_rank,
	 	rs		=> rs,
	 	load		=> load_sr,		--start,
	 	din		=> k2,
	 	ser_data_in0	=> logic0,
	 	ser_data_in1	=> logic0,
	 	par_data	=> tmp_kincm
	);


bfli_update : process(clk,ce,start,rs)
begin	
	if clk'event and clk = '1' then
	    if ce = '1' then
	        if start = '1' or rs = '1' then
	            bfli <= (others => '0');
	        else
	            bfli <= bfli + 1;
	        end if; 
	    end if;
	end if;
end process bfli_update;

bfly_update : process(clk,ce,start,rs,reset_bfly)
begin	
	if clk'event and clk = '1' then
	    if ce = '1' then
	        if start = '1' or rs = '1' or reset_bfly = '1' then
	            bfly <= (others => '0');
	        else
	            bfly <= bfly + 1;
	        end if; 
	    end if;
	end if;
end process bfly_update;

new_rank : process(clk,start,rs,ce)
begin
	if clk'event and clk = '1' then
	    if start = '1' or rs = '1' then
	        nxt_rank <= '0';
	    elsif ce = '1' then 
	    	if bfli = "111110" then
	            nxt_rank <= '1';
	        else
	            nxt_rank <= '0';
	        end if;    
	    end if;
	end if;
end process new_rank;

rs_bfly : process(clk,ce,rs,start,kincm,bfly)
begin
    if clk'event and clk = '1' then
        if start = '1' or rs = '1' then
            reset_bfly <= '0';			
        elsif ce = '1' then 
            if kincm = bfly then
                reset_bfly <= '1';
            else
                reset_bfly <= '0';    
            end if;    
        end if;
    end if;
end process rs_bfly;

pinco_proc : process(clk,ce,start,reset_bfly,nxt_bfly,rs)
    variable r	: std_logic;
begin
    r := (ce and reset_bfly) or start or rs; 
    if clk'event and clk = '1' then
          if r = '1' then
            pinco <= (others => '0');
        elsif ce='1' and nxt_bfly='1' then
            pinco <= pinco + kinc;
        end if;
    end if;
end process pinco_proc;

nxt_bfly_proc : process(clk,ce,start,bfli)
begin
    if clk'event and clk = '1' then
        if ce = '1' then
            if start = '1' then
                nxt_bfly <= '0';
            elsif bfli(0) = '0' and bfli(1) = '1' then
                nxt_bfly <= '1';
            else nxt_bfly <= '0';
            end if;
        end if;
    end if;
end process nxt_bfly_proc;

phase_addr_proc : process(clk,ce,start,rs)
begin
    if clk'event and clk = '1' then
        if rs = '1' or start = '1' then
        	phase_addr <= (others => '0');
        elsif ce = '1' then
            if nxt_bfly = '1' then
                phase_addr <= (others => '0');
            else
                phase_addr <= phase_addr + pinco;
            end if;
        end if;
    end if;
end process phase_addr_proc;

    load_sr <= start or (result and nxt_rank);   
    kinc <= tmp_kinc(4 downto 0);
    kincm <= (tmp_kincm(0),tmp_kincm(1),tmp_kincm(2),tmp_kincm(3),tmp_kincm(4),'0');
    k1 <= "0000000000000001";
    k2 <= "1111111111111111";
    logic0 <= '0';
    
end behv;
-- Virtex FFT
-- control signal generation
-- Modification History:
-- 12/06/99	The 'cntr' process was modifed so that the 'wren' signal is
--		reset when 'start' is applied. Previously, 'wren' was only reset
--		when 'rs' was asserted.
-- 15/06/99	Added a new process, 'wren1_proc' to generate a memory write strobe
--		for use with an input ping-pong memory arrangment
-- 15/06/99	'ce' was added to the sensitivity list of the the process cntr.
--		THIS MUST BE ADDED TO THE RElatencyEASE SOURCE.

-- 16/06/99	The 'assert_wren' value was reduced from 0x12 to 0x11 to match
--		the reduced latency through the core.
-- 17/06/99	Both memory write enables 'wren' and 'wren1' are gated from the same
--		start value - 'assert_wren'.
-- 17/6/99	'fft_busy_ticks' was changed - ths controls when the memory
--		strobe is removed by the core.

-- ************************************************************************
--  Copyright 1996-2000 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;

library xilinxcorelib;
	use xilinxcorelib.fft_defs_64.all;
	
entity fft_cntrl_64 is
	port(
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		start		: in std_logic;
		mode		: in std_logic;
		mwr		: in std_logic;
		addrw		: in std_logic_vector(log2_nfft-1 downto 0);
		busy		: out std_logic;
		wren		: out std_logic;
		wren1		: out std_logic;
		wrenx		: out std_logic;
		wreny		: out std_logic;		
		web_x		: out std_logic;
		web_y		: out std_logic;
		enax		: out std_logic;
		enay		: out std_logic;
		io		: out std_logic;
		eio		: out std_logic;		
		result		: out std_logic;
		mode_ce		: out std_logic;
		done		: out std_logic;
		edone		: out std_logic;	-- early done strobe
		bank		: out std_logic;
		ebank		: out std_logic;
		nxt_addr	: out std_logic;
		rank_eq_0	: out std_logic		-- true when rank == 0
							-- *** FROM THE MEMORY WRITE
							-- PERSPECTIVE ***
								
	);
end fft_cntrl_64;

architecture virtex_fft_cntrl of fft_cntrl_64 is

    --alias log2_nfft is work.fft_defs.log2_nfft;
    --alias n    is work.fft_defs.nfft;
    --alias latency    is work.fft_defs.latency;  
      
    constant fft_busy_ticks	: natural := log2_nfft/2 * nfft + latency; 	--209;
    -- ranks are numbered 0,1,2
    constant fin_rank1_nticks	: natural := (log2_nfft/2-1) * nfft + latency;	--145;	
    constant wren1_nticks	: natural := log2_nfft/2 * nfft - 1; 		--191;
    -- controls when wren[1] is asserted
    constant assert_wren	: natural := latency;				--17;	
    constant start_rank0	: natural := latency; 				--17;    
    constant end_rank0		: natural := nfft + latency;			--81;
    constant end_fft_cnt	: natural := log2_nfft/2 * nfft - 1; 		--191;
    constant reset_wr_agen	: natural := log2_nfft/2 * nfft - 1; 		--191;
    constant begin_result	: natural := (log2_nfft/2-1) * nfft - 1;	--127;
    constant end_result		: natural := log2_nfft/2 * nfft - 1; 		--191;
    constant begin_io		: natural := (log2_nfft/2-1) * nfft - 2;	--126;
    constant end_io		: natural := log2_nfft/2 * nfft - 2;		--190;
    constant done_cnt		: natural := log2_nfft/2 * nfft - 2;		--190;
    constant mode_ce_cnt	: natural := log2_nfft/2 * nfft - latency - 2;	--173; 
    constant edone_cnt		: natural := (log2_nfft/2-1) * nfft - 2;	--126;  
    constant bank_switch_cnt	: natural := log2_nfft/2 * nfft - 2 - 16;	--190;
          
    -- counts num. I/O clock cycles
    
    signal io_cycle_cntr	: std_logic_vector(8 downto 0);
    signal wren1_cntr		: std_logic_vector(7 downto 0);
    -- indicates FFT processing status
    signal fft_active		: boolean;
    
    signal b			: std_logic_vector(8 downto 0);
    signal bb			: std_logic_vector(8 downto 0);
    signal bb_tmp		: std_logic_vector(8 downto 0);    
    signal ostart		: std_logic;
    signal rank_eq_0_i		: std_logic;
    signal busy_i		: std_logic;
    signal bank_i		: std_logic;
    signal ebank_i		: std_logic;
    signal eebank_i		: std_logic;
    signal ewren1		: std_logic;
    signal new_xn_cnt		: std_logic_vector(log2_nfft/2-1 downto 0);
    signal ld_xn		: std_logic;
    signal enax_i		: std_logic;
    signal sclr_a 		: std_logic;
    signal sclr_aa		: std_logic;
    signal sclr_b 		: std_logic;
    signal sclr_bb		: std_logic;
    	     
component z18w1
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		din		: in std_logic;
		dout		: out std_logic
	);
end component;

component xdsp_cnt9
  port( clk 	: in  std_logic;
        ce 	: in  std_logic;
        sclr 	: in  std_logic;        
        q 	: out std_logic_vector(8 downto 0));
end component;
	    	
begin

outp_start_up : z18w1 
	port map (
		clk	=> clk,
		ce	=> ce,
		rs	=> rs,
		din	=> start,
		dout	=> ostart
	);
	
wren_proc : process(clk,ce,rs,start,mwr,busy_i,mode)
variable	r : std_logic;
begin
    r := rs; -- or start;
    if clk'event and clk = '1' then
        if r = '1' then
            io_cycle_cntr <= (others => '0');
            wren <= '0';
            busy_i <= '0';
        elsif start = '1' then
            busy_i <= '1';
            wren <= '0';
            io_cycle_cntr <= (others => '0');
        elsif ce = '1' then
            if busy_i = '0' then
	        if mwr = '1' and mode = '1' then
		    wren <= '1';
		elsif addrw = nfft-1 then
		    wren <= '0';    
		end if;               
            else
                io_cycle_cntr <= io_cycle_cntr + 1;
                if io_cycle_cntr = assert_wren and fft_active = true then
                    wren <= '1';
                elsif io_cycle_cntr = fft_busy_ticks and mode = '0' then
                    wren <= '0';
                    busy_i <= '0';
                end if;
            end if;
        end if;
    end if;
end process;

-- This process generates the memory write stobe for the input memory pig-pong
-- mode of operation

ewren1_proc : process(clk,ce,rs,start,wren1_cntr)
variable	r : std_logic;
begin
    r := rs or start;
    if clk'event and clk = '1' then
        if r = '1' or wren1_cntr = wren1_nticks then
            ewren1 <= '0';
            wren1_cntr <= (others => '0');
        elsif ce = '1' then
            if wren1_cntr = assert_wren-1 and fft_active = true then
                ewren1 <= '1';
            elsif wren1_cntr = fin_rank1_nticks-1 then
                ewren1 <= '0';
            end if;
            wren1_cntr <= wren1_cntr + 1;
        end if;
    end if;
end process ewren1_proc;

wren1_proc : process(clk,ce,rs,start,ewren1)
begin
	if clk'event and clk = '1' then
		if rs = '1' then
			wren1 <= '0';
		elsif ce = '1' then
			wren1 <= ewren1;
		end if;
	end if;
	
end process;

wrenx_proc : process(clk,ce,rs,start,mwr,b,enax_i)
	variable r	: std_logic;
	variable cen	: std_logic;
begin
	r := rs;
	cen := ce and busy_i;
	if clk'event and clk = '1' then
		if r = '1' then
			wrenx <= '0';
		elsif ce = '1' then 		
		    if busy_i = '0' then
		        --if mwr = '1' then
		        --    wrenx <= '1';
		        --elsif (addrw = n-1) and enax_i = '1' then
		        --    wrenx <= '0';    
		        --end if;     
		    elsif ebank_i = '0' then
		    	wrenx <= '0';
	            else
	            	wrenx <= ewren1;
		    end if;
		end if;
	end if;
end process;

wreny_proc : process(clk,ce,rs,start)
	variable r	: std_logic;
	variable cen	: std_logic;
begin
	r := rs;
	cen := ce and busy_i;
	if clk'event and clk = '1' then
		if r = '1' then
			wreny <= '0';
		elsif cen = '1' then 
		    if ebank_i = '1' then
		    	wreny <= '0';
	            else
	            	wreny <= ewren1;
		    end if;
		end if;
	end if;
end process;

web_x_proc : process(clk,ce,rs,start,mwr,b,enax_i,eebank_i)
	variable r	: std_logic;
	variable cen	: std_logic;
begin
	r := rs;
	cen := ce and busy_i;
	if clk'event and clk = '1' then
		if r = '1' then
			web_x <= '0';
		elsif ce = '1' then 		
		    if busy_i = '0' then
		        if mwr = '1' then
		            web_x <= '1';
		        elsif (addrw = nfft-1) and enax_i = '1' then
		            web_x <= '0';    
		        end if;     
		    elsif eebank_i = '0' then
			web_x <= '1';
	            else
	            	web_x <= '0';
		    end if;
		end if;
	end if;
end process;

web_y_proc : process(clk,ce,rs,start,enax_i,busy_i,eebank_i)
	variable r	: std_logic;
	variable cen	: std_logic;
begin
	r := rs;
	cen := ce and busy_i;
	if clk'event and clk = '1' then
		if r = '1' then
			web_y <= '0';
		elsif ce = '1' then 		
		    if busy_i = '1' then   
		        if eebank_i = '1' then
			    web_y <= '1';
			else
			    web_y <= '0';
			end if;
		    end if;
		end if;
	end if;
end process;

status : process(clk,ce,rs,start)
begin
    if clk'event and clk = '1' then
        if rs = '1' then
            fft_active <= false;
        elsif ce = '1' then
            if start = '1' then
                fft_active <= true;
            end if;
        end if;
    end if;
end process status;

b_rs : process(clk)
begin
    if clk'event and clk = '1' then
		if b = end_fft_cnt-1 then
			sclr_bb <= '1';
		else
			sclr_bb <= '0';
		end if;	
	end if;
end process;

sclr_b <= rs or start or mwr or sclr_bb;

b_cntr : xdsp_cnt9
	port map (clk		=> clk,
		  q		=> b,
		  ce		=> ce,
		  sclr    	=> sclr_b);
				    		
rank0_proc : process(clk,ce,rs,start,mwr)
begin
    if clk'event and clk = '1' then
    	-- 11-21-99
        --if rs = '1' or start = '1' or mwr = '1' or b=end_fft_cnt then
        --    b <= (others => '0');
        --elsif ce = '1' then
        --    b <= b + 1;
        --end if;
        if b = start_rank0 then
            rank_eq_0_i <= '1';
        elsif rank_eq_0_i = '1' and b = end_rank0 then
            rank_eq_0_i <= '0';
        end if;
    end if;
end process rank0_proc;

result_proc : process(clk,ce,rs,start)
	variable r	: std_logic;
begin
	r := rs or start;
	if clk'event and clk = '1' then
		if r = '1' then
			result <= '0';
		elsif bb = begin_result and busy_i = '1' then
			result <= '1';
		elsif bb = end_result then
			result <= '0';
		end if;
	end if;
end process;

io_proc : process(clk,ce,rs,start,mwr,addrw,busy_i)
	variable r	: std_logic;
begin
	r := rs or start;
	if clk'event and clk = '1' then
		if r = '1' then
			io <= '0';
		elsif ce = '1' then 
            	    if busy_i = '0' then
	                if mwr = '1' then
		            io <= '1';
		        elsif addrw = nfft-1 then
		            io <= '0';  
		        end if;  		
		    elsif (bb = begin_io+1 and busy_i = '1' and mode = '1') then
			io <= '1';
		    elsif bb = end_io+1 then
			io <= '0';
	            end if;
		end if;
	end if;
end process;

eio_proc : process(clk,ce,rs,start,mwr,addrw,busy_i)
	variable r	: std_logic;
begin
	r := rs or start;
	if clk'event and clk = '1' then
		if r = '1' then
			eio <= '0';
		elsif ce = '1' then 
            	    if busy_i = '0' then
	                if mwr = '1' then
		            eio <= '1';
		        elsif addrw = nfft-1 then
		            eio <= '0';  
		        end if;  		
		    elsif bb = begin_io-1 and busy_i = '1' then
			eio <= '1';
		    elsif bb = end_io-1 then
			eio <= '0';
	            end if;
		end if;
	end if;
end process;

done_proc : process(clk,ce,rs)
	variable r	: std_logic;
begin
	r := rs;
	if clk'event and clk = '1' then
		if r = '1' then
			done <= '0';
		elsif bb = done_cnt and busy_i = '1' then
			done <= '1';
		else
			done <= '0';
		end if;
	end if;
end process;

edone_proc : process(clk,ce,rs)
	variable r	: std_logic;
begin
	r := rs;
	if clk'event and clk = '1' then
		if r = '1' then
			edone <= '0';
		elsif bb = edone_cnt and busy_i = '1' then
			edone <= '1';
		else
			edone <= '0';
		end if;
	end if;
end process;

fftstart_proc : process(clk,ce,rs)
	variable r	: std_logic;
begin
	r := rs;
	if clk'event and clk = '1' then
		if r = '1' then
			mode_ce <= '0';
		elsif ce = '1' and busy_i = '1' then 
		    if bb = mode_ce_cnt then
			mode_ce <= '1';
		    else
			mode_ce <= '0';
		    end if;
		end if;
	end if;
end process;

bb_rs: process(clk)
begin
	 if clk'event and clk = '1' then
		if bb = reset_wr_agen-1 then
			sclr_aa <= '1';
		else
			sclr_aa <= '0';
		end if;	   	  
	end if;
end process;

-- ***** or start added by chd 7/1/00

sclr_a <= rs or ostart or sclr_aa or start;

bb_cntr: xdsp_cnt9
	port map (clk		=> clk,
		  q		=> bb,
		  ce		=> ce,
	          sclr    	=> sclr_a);
			    
--process(clk, ce, rs, ostart)
--	variable cen	: std_logic;
--begin
--	cen := ce; 
--	if clk'event and clk = '1' then
--	    if rs = '1' or ostart = '1' or bb_tmp = reset_wr_agen then
--		bb_tmp <= (others => '0');
--	    elsif cen = '1' then
--		bb_tmp <= bb_tmp + 1;
--	    end if;
--	end if;
--end process;

bank_proc : process(clk,ce,rs,start,busy_i,bb)
	variable r	: std_logic;
begin
	r := rs;
	if clk'event and clk = '1' then
		if r = '1' then
			bank_i <= '0';
		elsif ce = '1' then 
		    if (bb = bank_switch_cnt and busy_i = '1') or start = '1' then
			bank_i <= bank_i xor '1';
		    end if;
		end if;
	end if;
end process;

ebank_proc : process(clk,ce,rs,start,busy_i,bb)
	variable r	: std_logic;
begin
	r := rs;
	if clk'event and clk = '1' then
		if r = '1' then
			ebank_i <= '0';
		elsif ce = '1' then 
		    if (bb = bank_switch_cnt-1 and busy_i = '1') or start = '1' then
			ebank_i <= ebank_i xor '1';
		    end if;
		end if;
	end if;
end process;

eebank_proc : process(clk,ce,rs,start,busy_i,bb)
	variable r	: std_logic;
begin
	r := rs;
	if clk'event and clk = '1' then
		if r = '1' then
			eebank_i <= '0';
		elsif ce = '1' then 
		    if (bb = bank_switch_cnt-2 and busy_i = '1') or start = '1' then
			eebank_i <= eebank_i xor '1';
		    end if;
		end if;
	end if;
end process;

ld_xn_proc : process(clk,rs,ce,mwr,start)
    variable	nxt_xn  : std_logic;
    variable	r	: std_logic;
begin
    
    r := rs or mwr or start;
    
    if clk'event and clk = '1' then
        if r = '1' then
            new_xn_cnt <= (others => '0');
            ld_xn <= '0';
        elsif ce = '1' then 
            if new_xn_cnt = log2_nfft/2 - 1 then
                new_xn_cnt <= (others => '0');
            else
                new_xn_cnt <= new_xn_cnt + 1;
            end if;
            if new_xn_cnt = log2_nfft/2 - 3 then
                ld_xn <= '1';
            else
                ld_xn <= '0';
            end if;
        end if;   
    end if;
end process;

enaxy_proc : process(clk,rs,ce,start,ld_xn, ebank_i)
begin
    if clk'event and clk = '1' then
        if rs = '1' then
	   enax_i <= '0';
	   enay <= '0';
        elsif ebank_i = '0' then
            enax_i <= ld_xn;
            enay <= '1';
        else
            enay <= ld_xn;
            enax_i <= '1';
        end if;
    end if;
end process;

	rank_eq_0 <= rank_eq_0_i;
	busy <= busy_i;
	bank <= bank_i;
	nxt_addr <= ld_xn;
	enax <= enax_i;
	ebank <= ebank_i;
	
end virtex_fft_cntrl;	
-- Modification History

-- 15/06/99	The entity declaration was modifed to include 'result'. When result=1,
--		this indicates that the final processing rank is being performed. 
-- 16/06/99	The delay that generates 'comp' was reduced from 8 cycles to 7
--		cycles to allow for the reduced datapath latency.

-- ************************************************************************
--  Copyright 1996-2000 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;
    use ieee.std_logic_unsigned.all;

library xilinxcorelib;
    use xilinxcorelib.fft_defs_64.all;
	
-- synopsys translate_off 	
library unisim;
	use unisim.vcomponents.all;
-- synopsys translate_on
	
entity phase_factors_64 is
    port (
    	    clk			: in std_logic;		-- global clock
    	    ce			: in std_logic;		-- global clock enable
    	    start		: in std_logic;		-- system start
    	    rs			: in std_logic;		-- master reset
    	    result		: in std_logic;		
    	    sinn		: out std_logic_vector(B-1 downto 0);	-- cos()
    	    coss		: out std_logic_vector(B-1 downto 0);	-- sin()
    	    comp		: out std_logic		-- comp. mult product
    );
end phase_factors_64;

architecture phase_factors_arch of phase_factors_64 is

    -- transform size dependent constants
    
    constant nfft		: natural := 64;
    --signal nfft_on_4		: std_logic_vector(log2_nfft-1 downto 0) := x"10";
    
    -- phase angle
    signal phase_addr		: std_logic_vector(log2_nfft-1 downto 0);
    signal phase_addr_omega	: std_logic_vector(log2_nfft-3 downto 0);
    signal cos_val		: std_logic_vector(B-2 downto 0);
    signal sin_val		: std_logic_vector(B-2 downto 0);
    signal cos_sign_z1		: std_logic;
    signal cos_sign_z2		: std_logic;
    signal comp_cos_z1		: std_logic;
    signal comp_cos_z2		: std_logic;
    signal sin_sign_z1		: std_logic;
    signal sin_sign_z2		: std_logic;
    signal comp_sin_z1		: std_logic;
    signal comp_sin_z2		: std_logic;
    signal comp_tmp		: std_logic;
    signal logic0		: std_logic;
    signal logic1		: std_logic;
        
    -- start for phase factor address (i.e. phase angle) generator
    signal phase_start		: std_logic;
    signal compx		: std_logic;
    
component phase_agen_64
    port (
    	    clk			: in std_logic;		-- global clock
    	    ce			: in std_logic;		-- global clock enable
    	    start		: in std_logic;		-- system start
    	    rs			: in std_logic;
    	    result		: in std_logic;		-- result=1 indicates the
    	    						-- final rank is being processed    	    
    	    phase_addr		: inout std_logic_vector(log2_nfft-1 downto 0)	-- phase angle
    );
end component;

component SRL16E
	port (
		q		: out std_logic;	
		d		: in std_logic;
		ce		: in std_logic;
		clk   		: in std_logic;
 		a0		: in std_logic;			
 		a1		: in std_logic;
 		a2		: in std_logic;
 		a3		: in std_logic
	);
end component;

-- distributed RAM cos() LUT

component xdsp_cos64 port (
	a	: IN std_logic_VECTOR(3 downto 0);
	rclk	: IN std_logic;
	rd_ce	: IN std_logic;
	qspo	: OUT std_logic_VECTOR(B-2 downto 0));
end component;

-- distributed RAM cos() LUT

component xdsp_sin64 port (
	a	: IN std_logic_VECTOR(3 downto 0);
	rclk	: IN std_logic;
	rd_ce	: IN std_logic;
	qspo	: OUT std_logic_VECTOR(B-2 downto 0));
end component;

attribute RLOC : string;
attribute RLOC of cos_lut : label is "R0C0";
attribute RLOC of sin_lut : label is "R0C0";

begin

phase_addr_gen : phase_agen_64
	port map(
		clk		=> clk,
		ce		=> ce,
		start		=> phase_start,
		rs		=> rs,
		result		=> result,
		phase_addr	=> phase_addr
	); 
	
cos_lut : xdsp_cos64 
	port map (
		a 	=> phase_addr_omega,
		rclk 	=> clk,
		rd_ce 	=> ce,
		--clr 	=> '0',
		qspo 	=> cos_val
	);
	
sin_lut : xdsp_sin64 
	port map (
		a 	=> phase_addr_omega,
		rclk 	=> clk,
		rd_ce 	=> ce,
		--clr 	=> '0',
		qspo 	=> sin_val
	);

-- phase factor address generator start-up sequencer
phastart : SRL16E 
	port map(
		q		=> phase_start,	
		d		=> start,
		ce		=> ce,
		clk   		=> clk,
		a0		=> logic1,	-- 8 stage delay line (addr = dec 7)
 		a1		=> logic1,
 		a2		=> logic1,
 		a3		=> logic0
 	);	
 	
comp_pipex : SRL16E 
	port map(
		q		=> comp,	
		d		=> comp_tmp,
		ce		=> ce,		--logic1,
		clk   		=> clk,
		a0		=> logic1,	-- 8 stage delay line (addr = dec 7)
 		a1		=> logic1,
		a2		=> logic1,
 		a3		=> logic0
 	);	
 		
cos_proc : process(clk,ce,phase_addr)
variable comp_cos : std_logic;
variable cos_tmp : std_logic_vector(B-2 downto 0);
variable sign,sign0,sign1,sign2 : std_logic;
begin
    comp_cos := not( phase_addr(log2_nfft-1) xor phase_addr(log2_nfft-2));
    
    if clk'event and clk = '1' then
      if ce = '1' then
        comp_cos_z2 <= comp_cos_z1;
        comp_cos_z1 <= comp_cos;
        if comp_cos_z2 = '1' then
            cos_tmp := not cos_val + 1;
        else
            cos_tmp := cos_val;
        end if;
        if phase_addr = 0 then
            sign0 := '1';
            comp_tmp <= '1';
        else
            sign0 := '0';
            comp_tmp <= '0';
        end if;
        sign1 := phase_addr(log2_nfft-1) xor phase_addr(log2_nfft-2);
        if phase_addr = nfft/4 then		--x"10" then
            sign2 := '0';
        else
            sign2 := '1';
        end if;
        
        sign := (sign0 or sign1) and sign2;
        cos_sign_z2 <= cos_sign_z1;
        cos_sign_z1 <= sign;
        coss <= (cos_sign_z2 & cos_tmp);
      end if;
    end if;
end process cos_proc;

sin_proc : process(clk,ce,phase_addr)
variable comp_sin : std_logic;
variable sin_tmp : std_logic_vector(14 downto 0);
variable sign,sign0,sign1 : std_logic;
begin
    comp_sin := phase_addr(log2_nfft-1);
    
    if clk'event and clk = '1' then
      if ce = '1' then
        comp_sin_z2 <= comp_sin_z1;
        comp_sin_z1 <= comp_sin;
        if comp_sin_z2 = '1' then
            sin_tmp := not sin_val + 1;
        else
            sin_tmp := sin_val;
        end if;
        if phase_addr = 0 then
            sign0 := '1';
        else
            sign0 := '0';
        end if;
        sign1 := phase_addr(log2_nfft-1);     
        sign := not sign0 and not sign1;
        sin_sign_z2 <= sin_sign_z1;
        sin_sign_z1 <= sign;
        sinn <= (sin_sign_z2 & sin_tmp);
      end if;
    end if;
end process sin_proc;

agen : process(clk,ce,phase_addr)
begin
    if clk'event and clk = '1' then
      if ce = '1' then
        if phase_addr(log2_nfft-2) = '1' then
           phase_addr_omega <= not phase_addr(log2_nfft-3 downto 0) + 1; 
        else
           phase_addr_omega <= phase_addr(log2_nfft-3 downto 0);
        end if;   
      end if;
    end if;
end process agen;

    logic0 <= '0';
    logic1 <= '1';
    
end phase_factors_arch;
-- Synopsis: FFT constants and other definitions
-- Modification History

library ieee;
use ieee.std_logic_1164.all;
package fft_defsx_256 is
    constant B			: positive := 16;		-- word precision of FFT
    constant nfft		: natural := 256;    
    constant max_fft		: natural := 1024;      
    constant log2_nfft		: natural := 8;
    constant log2_max_nfft	: natural := 10;    
    constant latency		: natural := 20;		-- latency through datapath
    constant max_sint		: natural := 2**(B-1) - 1;	-- max positive signed int.
    constant max_uint		: natural := 2**B;		-- max positive signed int.   
end fft_defsx_256;
-- dragonfly processor

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;
	
	
entity dragonfly_256 is
	port (
		clk		: in std_logic;		-- system clock
		rs		: in std_logic;		-- reset
		start		: in std_logic;		-- start transform
		ce		: in std_logic;		-- master clk enable
		conj		: in std_logic;		-- conjugation control
		xnr		: in std_logic_vector(15 downto 0);
		xni		: in std_logic_vector(15 downto 0);
		wr		: in std_logic_vector(15 downto 0);	-- phase factors
		wi		: in std_logic_vector(15 downto 0);
		xk_r		: out std_logic_vector(16 downto 0);
		xk_i		: out std_logic_vector(16 downto 0)
	      );
end dragonfly_256;

architecture struct of dragonfly_256 is

	-- fft4 output mux selects
	signal	fft4_omux_s0		: std_logic;
	signal	fft4_omux_s1		: std_logic;
	signal	fft4_omux_state_cntr	: std_logic_vector(1 downto 0);
	
	-- 4-point FFT output samples
	signal	y0r			: std_logic_vector(15 downto 0);
	signal	y0i			: std_logic_vector(15 downto 0);
	signal	y1r			: std_logic_vector(15 downto 0);
	signal	y1i			: std_logic_vector(15 downto 0);
	signal	y2r			: std_logic_vector(15 downto 0);
	signal	y2i			: std_logic_vector(15 downto 0);
	signal	y3r			: std_logic_vector(15 downto 0);
	signal	y3i			: std_logic_vector(15 downto 0);
	
	-- output of multiplexor that selects the output samples from the 4-point FFT
	signal	tr			: std_logic_vector(15 downto 0);
	signal	ti			: std_logic_vector(15 downto 0);
	
component fft4
	port (
		clk		: in std_logic;				-- system clock
		rs		: in std_logic;				-- reset
		start		: in std_logic;				-- global start
		ce		: in std_logic;
		conj		: in std_logic;
		dr		: in std_logic_vector(15 downto 0);
		di		: in std_logic_vector(15 downto 0);
		y0r		: out std_logic_vector(15 downto 0);
		y0i		: out std_logic_vector(15 downto 0);
		y1r		: out std_logic_vector(15 downto 0);
		y1i		: out std_logic_vector(15 downto 0);
		y2r		: out std_logic_vector(15 downto 0);
		y2i		: out std_logic_vector(15 downto 0);
		y3r		: out std_logic_vector(15 downto 0);
		y3i		: out std_logic_vector(15 downto 0)
	      );
end component;

component xmux4w16r
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		s0		: in std_logic;				-- mux select inputs
		s1		: in std_logic;
		x0r		: in std_logic_vector(15 downto 0);	-- mux inputs Re and Im
		x0i		: in std_logic_vector(15 downto 0);
		x1r		: in std_logic_vector(15 downto 0);	
		x1i		: in std_logic_vector(15 downto 0);
		x2r		: in std_logic_vector(15 downto 0);	
		x2i		: in std_logic_vector(15 downto 0);
		x3r		: in std_logic_vector(15 downto 0);	
		x3i		: in std_logic_vector(15 downto 0);
		yr		: out std_logic_vector(15 downto 0);	-- mux outputs
		yi		: out std_logic_vector(15 downto 0)
	      );
end component;

-- 16 x 17 complex multiplier
component xmul16x17
	port (
		clk		: in std_logic;		-- system clock
		rs		: in std_logic;		-- reset
		ce		: in std_logic;		-- master clk enable
		ar		: in std_logic_vector(15 downto 0);  	-- Re(operand 1)
		ai		: in std_logic_vector(15 downto 0);	-- Im(operand 1)
		br		: in std_logic_vector(15 downto 0);	-- Re(operand 2)
		bi		: in std_logic_vector(15 downto 0);	-- Im(operand 2)
		pr		: out std_logic_vector(16 downto 0);	-- Re( a x b)
		pi		: out std_logic_vector(16 downto 0)	-- Im( a x b)
	      );
end component;

attribute RLOC : string;
attribute RLOC of xfft4 : label is "R0C0"; 
attribute RLOC of fft4_omux : label is "R0C6";
attribute RLOC of xmul : label is "R0C7";

-- 4-point FFT port mappings
-- This small transform is applied to the input data prior to processing by the
-- complex multiplier

begin

xfft4 : fft4
	port map (
		clk		=> clk,				-- system clock
		rs		=> rs,				-- reset
		start		=> start,			-- global start
		ce		=> ce,				-- master clk enable
		conj		=> conj,
		dr		=> xnr,				-- Re/Im input sample
		di		=> xni,
		y0r		=> y0r,				-- output samples
		y0i		=> y0i,
		y1r		=> y1r,
		y1i		=> y1i,
		y2r		=> y2r,
		y2i		=> y2i,
		y3r		=> y3r,
		y3i		=> y3i		
	);

fft4_omux : xmux4w16r 
	port map (
		clk		=> clk,			-- system clock
		ce		=> ce,			-- global clk enable
		s0		=> fft4_omux_s0,	-- mux select inputs
		s1		=> fft4_omux_s1,
		x0r		=> y2r,	
		x0i		=> y2i,
		x1r		=> y3r,	
		x1i		=> y3i,
		x2r		=> y0r,	
		x2i		=> y0i,
		x3r		=> y1r,	
		x3i		=> y1i,
		yr		=> tr,			-- sample presented to cmplx mul
		yi		=> ti
	);

-- complex product 
-- This module accepts outputs from the 4-point FFT 'xfft4' and applies
-- the phase rotations read from the phase factor trig LUT
-- The complex samples from the xfft4 unit are presented to the complex multiplier
-- via the 4:1 complex mutliplexor 'fft4_omux'.

xmul : xmul16x17 
	port map(
		clk		=> clk,	-- system clock
		rs		=> rs,		-- reset
		ce		=> ce,		-- master clk enable
		ar		=> tr, 		-- Re(operand 1)
		ai		=> ti,		-- Im(operand 1)
		br		=> wr,		-- Re(operand 2)
		bi		=> wi,		-- Im(operand 2)
		pr		=> xk_r,	-- output: Re( a x b)
		pi		=> xk_i		-- output: Im( a x b)
	      );
	      
-- rank-0 4-point FFT state machine

fft4_omux_state_mach : process(clk,rs,ce,start)
begin
	if (rs = '1' or start = '1') then
		fft4_omux_state_cntr <= "00";
	elsif (clk'event and clk='1') then
		if (ce = '1') then
			fft4_omux_state_cntr <= fft4_omux_state_cntr + 1;
		end if;	
	end if;
end process;

	fft4_omux_s0 <= fft4_omux_state_cntr(0);
	fft4_omux_s1 <= fft4_omux_state_cntr(1);
	
end struct;
-- Synopsis: phase factor address generator for N=256 FFT

-- ************************************************************************
--  Copyright (C) 1998, 1999 - Xilinx, Inc.
-- ************************************************************************
-- This file is (c) Xilinx, Inc. 1998.  No part of this file may be modified, 
-- transmitted to any third party (other than as intended by Xilinx) or used 
-- without a Xilinx programmable or hardwire device without Xilinx's prior 
-- written permission.
--

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;
    use ieee.std_logic_unsigned."+";			
    
library xilinxcorelib;
    use xilinxcorelib.fft_defsx_256.all;	
    
entity phase_agen_256 is
    port (
    	    clk			: in std_logic;		-- global clock
    	    ce			: in std_logic;		-- global clock enable
    	    start		: in std_logic;		-- system start
    	    rs			: in std_logic;		-- master reset
    	    result		: in std_logic;		-- result=1 indicates the
    	    						-- final rank is being processed  
    	    dma			: in std_logic;
    	    io			: in std_logic;						  	    
    	    phase_addr		: out std_logic_vector(log2_nfft-1 downto 0)	-- phase angle
    );
end phase_agen_256;

architecture phase_agen_arch of phase_agen_256 is

    signal kinc		: std_logic_vector(log2_nfft-2 downto 0);
    signal kincm		: std_logic_vector(log2_nfft-1 downto 0);
    signal tmp_kincm		: std_logic_vector(B-1 downto 0);
    signal tmp_kinc		: std_logic_vector(B-1 downto 0);
    
    -- butterfly counter
    signal bfli		: std_logic_vector(log2_nfft-1 downto 0);
    signal nxt_rank		: std_logic;	-- indicates the start of a new rank
    signal bfly		: std_logic_vector(log2_nfft-1 downto 0);   
    signal reset_bfly		: std_logic;
    signal pinco		: std_logic_vector(log2_nfft-2 downto 0);
    signal nxt_bfly		: std_logic;
    signal k1,k2               : std_logic_vector(B-1 downto 0);    
    signal logic0		: std_logic;
    signal load_sr		: std_logic;
    signal phase_addr_i		: std_logic_vector(log2_nfft-1 downto 0);
            	
component shift_reg2b
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		load		: in std_logic;
		din		: in std_logic_vector(B-1 downto 0);
		ser_data_in0	: in std_logic;
		ser_data_in1	: in std_logic;
		par_data	: inout std_logic_vector(B-1 downto 0)
	);
end component;

begin

sr1 : shift_reg2b
	port map(
	 	clk		=> clk,
	 	ce		=> nxt_rank,
	 	rs		=> rs,
	 	load		=> load_sr,
	 	din		=> k1,
	 	ser_data_in0	=> logic0,
	 	ser_data_in1	=> logic0,
	 	par_data	=> tmp_kinc
	);
	
sr2 : shift_reg2b
	port map(
	 	clk		=> clk,
	 	ce		=> nxt_rank,
	 	rs		=> rs,
	 	load		=> load_sr,
	 	din		=> k2,
	 	ser_data_in0	=> logic0,
	 	ser_data_in1	=> logic0,
	 	par_data	=> tmp_kincm
	);


bfli_update : process(clk,ce,start,rs)
begin	
	if clk'event and clk = '1' then
	    if ce = '1' then
	        if start = '1' or rs = '1' then
	            bfli <= (others => '0');
	        else
	            bfli <= bfli + 1;
	        end if; 
	    end if;
	end if;
end process bfli_update;

bfly_update : process(clk,ce,start,rs,reset_bfly)
begin	
	if clk'event and clk = '1' then
	    if ce = '1' then
	        if start = '1' or rs = '1' or reset_bfly = '1' then
	            bfly <= (others => '0');
	        else
	            bfly <= bfly + 1;
	        end if; 
	    end if;
	end if;
end process bfly_update;

new_rank : process(clk,start,rs)
begin
	if clk'event and clk = '1' then
	    if start = '1' or rs = '1' then
	        nxt_rank <= '0';
	    elsif bfli = "11111110" then	--nfft-2 then
	        nxt_rank <= '1';
	    else
	        nxt_rank <= '0';
	    end if;
	end if;
end process new_rank;

rs_bfly : process(clk,ce,rs,start,kincm,bfly)
begin
    if clk'event and clk = '1' then
        if start = '1' or rs = '1' then
            reset_bfly <= '0';			
        elsif ce = '1' then 
            if kincm = bfly then
                reset_bfly <= '1';
            else
                reset_bfly <= '0';    
            end if;    
        end if;
    end if;
end process rs_bfly;

pinco_proc : process(clk,ce,start,reset_bfly,nxt_bfly)
begin
    if clk'event and clk = '1' then
        if start = '1' or reset_bfly = '1' then
            pinco <= (others => '0');
        elsif ce='1' and nxt_bfly='1' then
            pinco <= pinco + kinc;
        end if;
    end if;
end process pinco_proc;

nxt_bfly_proc : process(clk,ce,start,bfli)
begin
    if clk'event and clk = '1' then
        if ce = '1' then
            if start = '1' then
                nxt_bfly <= '0';
            elsif bfli(0) = '0' and bfli(1) = '1' then
                nxt_bfly <= '1';
            else nxt_bfly <= '0';
            end if;
        end if;
    end if;
end process nxt_bfly_proc;

phase_addr_proc : process(clk,ce,start)
begin
    if clk'event and clk = '1' then
        if ce = '1' then
            if start = '1' then
                phase_addr_i <= (others => '0');
            elsif nxt_bfly = '1' then
                phase_addr_i <= (others => '0');
            else
                phase_addr_i <= phase_addr_i + pinco;
            end if;
        end if;
    end if;
end process phase_addr_proc;

    load_sr <= start or (not dma and result and nxt_rank) or (dma and io and nxt_rank);   
    kinc <= tmp_kinc(log2_nfft-2 downto 0);
    kincm <= (tmp_kincm(0),tmp_kincm(1),tmp_kincm(2),tmp_kincm(3),tmp_kincm(4),
    tmp_kincm(5),tmp_kincm(6),'0');
 
    kincm(0) <= '0';
    k1 <= "0000000000000001"; 		--conv_std_logic_vector(1,B); 
    k2 <= "1111111111111111"; 		--conv_std_logic_vector(2**B - 1,B); 
    phase_addr <= phase_addr_i;
    logic0 <= '0';
    
end phase_agen_arch;
-- Synopsis: FFT phase factor address generator

-- ************************************************************************
--  Copyright (C) 1998, 1999 - Xilinx, Inc.
-- ************************************************************************
-- This file is (c) Xilinx, Inc. 1998.  No part of this file may be modified, 
-- transmitted to any third party (other than as intended by Xilinx) or used 
-- without a Xilinx programmable or hardwire device without Xilinx's prior 
-- written permission.
--

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;

library xilinxcorelib;
    use xilinxcorelib.fft_defsx_256.all;
    
-- synopsys translate_off
library unisim;
	use unisim.vcomponents.all;
-- synopsys translate_on
        	
entity phase_factors_256 is
    port (
    	    clk			: in std_logic;		-- global clock
    	    ce			: in std_logic;		-- global clock enable
    	    start		: in std_logic;		-- system start
    	    rs			: in std_logic;		-- master reset
    	    result		: in std_logic;	
    	    dma			: in std_logic;
    	    io			: in std_logic;	    	    
    	    sinn		: out std_logic_vector(B-1 downto 0);	-- cos()
    	    coss		: out std_logic_vector(B-1 downto 0);	-- sin()
    	    comp		: out std_logic		-- comp. mult product
    );
end phase_factors_256;

architecture phase_factors_arch of phase_factors_256 is

    -- phase angle
    signal phase_addr		: std_logic_vector(log2_nfft-1 downto 0);
    signal phase_addr_omega	: std_logic_vector(log2_nfft-3 downto 0);
    signal cos_val		: std_logic_vector(B-2 downto 0);
    signal sin_val		: std_logic_vector(B-2 downto 0);
    signal cos_sign_z1		: std_logic;
    signal cos_sign_z2		: std_logic;
    signal comp_cos_z1		: std_logic;
    signal comp_cos_z2		: std_logic;
    signal sin_sign_z1		: std_logic;
    signal sin_sign_z2		: std_logic;
    signal comp_sin_z1		: std_logic;
    signal comp_sin_z2		: std_logic;
    signal comp_tmp		: std_logic;
    signal logic0		: std_logic;
    signal logic1		: std_logic;
        
    -- start for phase factor address (i.e. phase angle) generator
    signal phase_start		: std_logic;
    
component phase_agen_256
    port (
    	    clk			: in std_logic;		-- global clock
    	    ce			: in std_logic;		-- global clock enable
    	    start		: in std_logic;		-- system start
    	    rs			: in std_logic;
    	    result		: in std_logic;
    	    dma			: in std_logic;
    	    io			: in std_logic;	
    	    phase_addr		: out std_logic_vector(log2_nfft-1 downto 0)	-- phase angle
    );
end component;

component SRL16E
	port (
		q		: out std_logic;	
		d		: in std_logic;
		ce		: in std_logic;
		clk   		: in std_logic;
 		a0		: in std_logic;			
 		a1		: in std_logic;
 		a2		: in std_logic;
 		a3		: in std_logic
	);
end component;

-- distributed RAM cos() LUT

component xdsp_cos256 port (
	a	: IN std_logic_VECTOR(log2_nfft-3 downto 0);
	clk	: IN std_logic;
	qspo_ce	: IN std_logic;
	qspo	: OUT std_logic_VECTOR(B-2 downto 0));
end component;

-- distributed RAM cos() LUT

component xdsp_sin256 port (
	a	: IN std_logic_VECTOR(log2_nfft-3 downto 0);
	clk	: IN std_logic;
	qspo_ce	: IN std_logic;
	qspo	: OUT std_logic_VECTOR(B-2 downto 0));
end component;

attribute RLOC : string;
attribute RLOC of cos_lut : label is "R0C0"; 
attribute RLOC of sin_lut : label is "R0C1";

begin

phase_addr_gen : phase_agen_256
	port map(
		clk		=> clk,
		ce		=> ce,
		start		=> phase_start,
		rs		=> rs,
		result          => result,
		dma		=> dma,
		io		=> io,
		phase_addr	=> phase_addr
	); 
	
cos_lut : xdsp_cos256
	port map (
		a 	=> phase_addr_omega,
		clk 	=> clk,
		qspo_ce => ce,
		qspo 	=> cos_val
	);
	
sin_lut : xdsp_sin256
	port map (
		a 	=> phase_addr_omega,
		clk 	=> clk,
		qspo_ce => ce,
		qspo 	=> sin_val
	);
	
-- phase factor address generator start-up sequencer
phastart : SRL16E 
	port map(
		q		=> phase_start,	
		d		=> start,
		ce		=> ce,
		clk   		=> clk,
		a0		=> logic1,	-- 8 stage delay line (addr = dec 7)
 		a1		=> logic1,
 		a2		=> logic1,
 		a3		=> logic0
 	);	
 	
comp_pipex : SRL16E 
	port map(
		q		=> comp,	
		d		=> comp_tmp,
		ce		=> ce,
		clk   		=> clk,
		a0		=> logic0,	-- 9 stage delay line (addr = dec 8)
 		a1		=> logic0,
		a2		=> logic0,
 		a3		=> logic1
 	);	
 		
cos_proc : process(clk,ce,phase_addr)
variable comp_cos : std_logic;
variable cos_tmp : std_logic_vector(B-2 downto 0);
variable sign,sign0,sign1,sign2 : std_logic;

begin
    comp_cos := not(phase_addr(log2_nfft-1) xor phase_addr(log2_nfft-2));

    
    if clk'event and clk = '1' then
      if ce = '1' then
        comp_cos_z2 <= comp_cos_z1;
        comp_cos_z1 <= comp_cos;
        if comp_cos_z2 = '1' then
            cos_tmp := not cos_val + 1;
        else
            cos_tmp := cos_val;
        end if;
        if phase_addr = 0 then
            sign0 := '1';
            comp_tmp <= '1';
        else
            sign0 := '0';
            comp_tmp <= '0';
        end if;
        sign1 := phase_addr(log2_nfft-1) xor phase_addr(log2_nfft-2);
        if phase_addr = nfft/4 then
            sign2 := '0';
        else
            sign2 := '1';
        end if;
        
        sign := (sign0 or sign1) and sign2;
        cos_sign_z2 <= cos_sign_z1;
        cos_sign_z1 <= sign;
        coss <= (cos_sign_z2 & cos_tmp);
      end if;
    end if;
end process cos_proc;

sin_proc : process(clk,ce,phase_addr)
variable comp_sin : std_logic;
variable sin_tmp : std_logic_vector(B-2 downto 0);
variable sign,sign0,sign1 : std_logic;
begin
    comp_sin := phase_addr(log2_nfft-1);
    
    if clk'event and clk = '1' then
      if ce = '1' then
        comp_sin_z2 <= comp_sin_z1;
        comp_sin_z1 <= comp_sin;
        if comp_sin_z2 = '1' then
            sin_tmp := not sin_val + 1;
        else
            sin_tmp := sin_val;
        end if;
        if phase_addr = 0 then
            sign0 := '1';
        else
            sign0 := '0';
        end if;
        sign1 := phase_addr(log2_nfft-1);     
        sign := not sign0 and not sign1;
        sin_sign_z2 <= sin_sign_z1;
        sin_sign_z1 <= sign;
        sinn <= (sin_sign_z2 & sin_tmp);
      end if;
    end if;
end process sin_proc;

agen : process(clk,ce,phase_addr)
begin
    if clk'event and clk = '1' then
      if ce = '1' then
        if phase_addr(log2_nfft-2) = '1' then
           phase_addr_omega <= not phase_addr(log2_nfft-3 downto 0) + 1; 
        else
           phase_addr_omega <= phase_addr(log2_nfft-3 downto 0);
        end if;   
      end if;
    end if;
end process agen;

    logic0 <= '0';
    logic1 <= '1';
        	
end phase_factors_arch;
-- Virtex FFT
-- data re-ordering buffer 

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;

library xilinxcorelib;
	use xilinxcorelib.fft_defsx_256.all;
			
entity fft_dbl_bufr is
	port (
		clk		: in std_logic;				-- system clock
		rs		: in std_logic;				-- reset
		start		: in std_logic;				-- start transform
		ce		: in std_logic;				-- clk enable
		dr		: in std_logic_vector(B-1 downto 0);
		di		: in std_logic_vector(B-1 downto 0);
		qr		: out std_logic_vector(B-1 downto 0);
		qi		: out std_logic_vector(B-1 downto 0)
	      );
end fft_dbl_bufr;

architecture struct of fft_dbl_bufr is
	
	-- definitions for input double buffer
	signal	c			: std_logic_vector(4 downto 0);
	signal	addr_a			: std_logic_vector(3 downto 0);
	signal	addr_b			: std_logic_vector(3 downto 0);
	signal	addr_ram0		: std_logic_vector(3 downto 0);
	signal	addr_ram1		: std_logic_vector(3 downto 0);
	signal	reg_addr_ram0		: std_logic_vector(3 downto 0);
	signal	reg_addr_ram1		: std_logic_vector(3 downto 0);
	signal	ram0_addr_mux_sel	: std_logic;
	signal	ram1_addr_mux_sel	: std_logic;
	-- write enables for ram0 and ram1
	signal	ram0_we			: std_logic;
	signal	ram1_we			: std_logic;
	signal	ram0_we_z		: std_logic;
	signal	ram1_we_z		: std_logic;	
	signal	ram0q_r			: std_logic_vector(B-1 downto 0);
	signal	ram0q_i			: std_logic_vector(B-1 downto 0);
	signal	ram1q_r			: std_logic_vector(B-1 downto 0);
	signal	ram1q_i			: std_logic_vector(B-1 downto 0);
	signal	odmux_sel		: std_logic;
	signal	odmux_sel_z		: std_logic; 	
	signal	odmux_sel_z1		: std_logic; 	 
	signal	strt			: std_logic;

component xdsp_ramd16a4
  port (a		: IN STD_LOGIC_VECTOR(4-1 DOWNTO 0);
        d		: IN STD_LOGIC_VECTOR(B-1 DOWNTO 0);
        we		: IN STD_LOGIC;
        clk		: IN STD_LOGIC;
        qspo_ce	: IN STD_LOGIC;
        qspo		: OUT STD_LOGIC_VECTOR(B-1 DOWNTO 0));
end component;	


component xdsp_mux2w4r
  port( ma 	: IN  std_logic_vector( 4 - 1 DOWNTO 0 );
        mb 	: IN  std_logic_vector( 4 - 1 DOWNTO 0 );
        clk	: std_logic;
        ce	: std_logic;
        s 	: IN  std_logic_vector(0 downto 0);
        q  	: OUT std_logic_vector( 4 - 1 DOWNTO 0 ) );
end component;

component xdsp_mux2w16r
  port( ma 	: IN  std_logic_vector( B - 1 DOWNTO 0 );
        mb 	: IN  std_logic_vector( B - 1 DOWNTO 0 );
        clk	: std_logic;
        ce	: std_logic;        
        s 	: IN  std_logic_vector(0 downto 0);
        q  	: OUT std_logic_vector( B - 1 DOWNTO 0 ) );
end component;

attribute RLOC : string;
attribute RLOC of ram0_r : label is "R0C0";
attribute RLOC of ram0_i : label is "R0C1";
attribute RLOC of ram1_r : label is "R0C2";
attribute RLOC of ram1_i : label is "R0C3";
attribute RLOC of odmux_r : label is "R0C2";
attribute RLOC of odmux_i : label is "R0C3";
attribute RLOC of ram0_addr_mux : label is "R0C0";
attribute RLOC of ram1_addr_mux : label is "R0C1";

begin

ram0_r : xdsp_ramd16a4
	port map (
		a		=> reg_addr_ram0,
		d		=> dr,
		we		=> ram0_we,
		clk		=> clk,
		qspo_ce		=> ce,
		qspo		=> ram0q_r
	);
	
ram0_i : xdsp_ramd16a4
	port map (
		a		=> reg_addr_ram0,
		d		=> di,
		we		=> ram0_we,
		clk		=> clk,
		qspo_ce		=> ce,
		qspo		=> ram0q_i
	);
	
ram1_r : xdsp_ramd16a4
	port map (
		a		=> reg_addr_ram1,
		d		=> dr,
		we		=> ram1_we,
		clk		=> clk,
		qspo_ce		=> ce,
		qspo		=> ram1q_r
	);
	
ram1_i : xdsp_ramd16a4
	port map (
		a		=> reg_addr_ram1,
		d		=> di,
		we		=> ram1_we,
		clk		=> clk,
		qspo_ce		=> ce,
		qspo		=> ram1q_i
	);
		
ram0_addr_mux : xdsp_mux2w4r
	port map (
		ma		=> addr_b,
		mb		=> addr_a,
		clk		=> clk,
		ce		=> ce,
		s(0)		=> ram0_addr_mux_sel,
		q		=> reg_addr_ram0
	);
	
ram1_addr_mux : xdsp_mux2w4r
	port map (
		ma		=> addr_b,
		mb		=> addr_a,
		clk		=> clk,
		ce		=> ce,		
		s(0)		=> ram1_addr_mux_sel,
		q		=> reg_addr_ram1
	);
	
odmux_r : xdsp_mux2w16r
	port map (
		ma		=> ram0q_r,
		mb		=> ram1q_r,
		clk		=> clk,
		ce		=> ce,		
		s(0)		=> odmux_sel,
		q		=> qr
	);
	
odmux_i : xdsp_mux2w16r
	port map (
		ma		=> ram0q_i,
		mb		=> ram1q_i,
		clk		=> clk,
		ce		=> ce,		
		s(0)		=> odmux_sel,
		q		=> qi
	);		 
	
addr_gen : process(clk,ce,rs,strt)
begin
	if clk'event and clk = '1' then
		if rs = '1' or strt = '1' then
			c <= (others => '0');
		elsif ce = '1' then
			c <= c + 1;	
			addr_a <= c(3 downto 0);
			addr_b <= (c(1),c(0),c(3),c(2));
			ram0_addr_mux_sel <= c(4);
			ram1_addr_mux_sel <= not c(4);			
	    	end if;
	end if;
end process;

ram_we : process(clk,rs,ce,start)
begin
	if clk'event and clk = '1' then
		if rs = '1' then
			ram0_we <= '0';
			ram1_we <= '0';
		elsif ce = '1' then
			ram0_we_z <= c(4);
			ram1_we_z <= not c(4);
			ram0_we <= ram0_we_z;	-- compensate for dly through registered mux
			ram1_we <= ram1_we_z;
			odmux_sel_z1 <= c(4);
			odmux_sel_z <= odmux_sel_z1;			
			odmux_sel <= odmux_sel_z;
		end if;
	end if;
end process;
	
strt_proc : process(clk,ce,start)
begin
	if clk'event and clk = '1' then
		if ce = '1' then
			strt <= start;
		end if;
	end if;
end process;
	
end struct;

-- 1024-point FFT operand read address generator

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;

library xilinxcorelib;
    	use xilinxcorelib.fft_defsx_256.all;
    	
entity index_map_256 is
	port(
		clk		: in std_logic;		-- global clock
		ce		: in std_logic;		-- master clock enable
		rs		: in std_logic;		-- master reset
		index		: out std_logic_vector(log2_nfft-1 downto 0) -- outp. index bus
	);
end index_map_256;

architecture behv of index_map_256 is

	-- state counter for re-ordering address generator
	signal	b		: std_logic_vector(12 downto 0);
	
begin

indx_agen : process(clk, ce, rs)
	variable cen	: std_logic;
begin
	if clk'event and clk = '1' then
	    if rs = '1' then
		b <= (others => '0');
	    elsif ce = '1' then
		b <= b + 1;
	    end if;
	end if;
end process;

	-- define output re-ordering address bus
	index <= (b(1),b(0),b(3),b(2),b(5),b(4),b(7),b(6));
	
end behv;
-- Virtex FFT
-- control signal generation

-- Modification History:

-- ************************************************************************
--  Copyright 1996-2000 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;
    use ieee.std_logic_unsigned.all;
    
library xilinxcorelib;
    use xilinxcorelib.fft_defsx_256.all;
	
entity fft_cntrlx_256 is
	port(
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		mode		: in std_logic;		
		start		: in std_logic;
		dma		: in std_logic;
		mwr		: in std_logic;
		addrw		: in std_logic_vector(log2_nfft-1 downto 0);
		busy		: out std_logic;
		wren		: out std_logic;	
		wrenx		: out std_logic;
		wreny		: out std_logic;
		web_x		: out std_logic;
		web_y		: out std_logic;		
		enax		: out std_logic;
		enay		: out std_logic;
		rank_eq_0	: out std_logic;
		rank_eq_nm1	: out std_logic;			
		result		: out std_logic;
		eresult		: out std_logic;		
		io		: out std_logic;
		eio		: out std_logic;
		mode_ce		: out std_logic;		
		done		: out std_logic;
		edone		: out std_logic;
		bank		: out std_logic;
		ebank		: out std_logic;
		nxt_addr	: out std_logic
	);
end fft_cntrlx_256;

architecture behv of fft_cntrlx_256 is
    
    --alias log2_nfft is work.fft_defsx.log2_nfft;
    --alias n    is work.fft_defsx.nfft;
    --alias L    is work.fft_defsx.latency;
    constant L2			: natural  := 30; 				    
    constant reset_state	: natural  := (log2_nfft/2-1) * nfft - 1; 
    constant reset_state_dma	: natural  := (log2_nfft/2-0) * nfft - 1;     	
    constant reset_outp_state	: natural  := (log2_nfft/2-1) * nfft - 1 + L2;  
    constant reset_bbb		: natural  := (log2_nfft/2-1) * nfft - 1;  
    constant reset_bbb_dma	: natural  := log2_nfft/2 * nfft - 1;       	
    constant reset_bbbb		: natural  := (log2_nfft/2) * nfft - 1; 
    constant reset_bbbb_dma	: natural  := log2_nfft/2 * nfft - 1;     	
    constant begin_result	: positive := (log2_nfft/2-2) * nfft - 1;	 	
    constant end_result		: positive := (log2_nfft/2-1) * nfft - 1;		
    constant begin_io		: positive := (log2_nfft/2-1) * nfft - L2; 			
    constant end_io		: positive := (log2_nfft/2-0) * nfft - L2; 				
    constant done_cnt		: positive := (log2_nfft/2-1) * nfft - 2;
    
    -- mode_ce_cnt = (log2_nfft/2-1) * n - 1 when the scaling mux is registered
    -- and = (log2_nfft/2-1) * n - 2 when not registered		
    constant mode_ce_cnt	: positive := (log2_nfft/2-1) * nfft - 1;  
    constant mode_ce_cnt_dma	: positive := (log2_nfft/2-0) * nfft - 1;    
    constant edone_cnt		: positive := (log2_nfft/2-2) * nfft - 2;
    constant fft_busy_ticks	: natural  := (log2_nfft/2-1) * nfft + latency + L2-1;   
    -- controls when wren[1] is asserted 
    constant assert_wren	: natural := latency;	  	
    constant wren1_nticks	: natural := (log2_nfft/2-1) * nfft - 1;
    constant fin_rankm_nticks	: natural := (log2_nfft/2-1) * nfft;
    
    -- start_rank0 is used by the scaling mux.
    -- when this mux is registered start_rank0 = L-1 to allow for the mux reg
    -- when it is not registered this value is L
    -- when the final output xk_mux is in the path the val. is L-2
    
    constant start_rank0	: natural := latency-2;    
    constant end_rank0		: natural := nfft+start_rank0; 
    constant bank_switch_cnt	: natural := (log2_nfft/2-1) * nfft - 1;
        	
    -- counts num. I/O clock cycles
    signal io_cycle_cntr	: std_logic_vector(log2_nfft+2 downto 0);
    signal wren1_cntr		: std_logic_vector(log2_nfft+log2_nfft/4 downto 0);    
    -- indicates FFT processing status
    signal fft_active		: boolean;
    signal ostart		: std_logic;
    signal strt2		: std_logic;    
    
    -- state counter
    signal b			: std_logic_vector(log2_nfft+2 downto 0);
    signal bb			: std_logic_vector(log2_nfft+2 downto 0);   
    signal bbb			: std_logic_vector(log2_nfft+2 downto 0);    
    signal bbbb			: std_logic_vector(9 downto 0);         
    signal rank_eq_0_i		: std_logic;
    signal busy_i		: std_logic;
    signal bank_i		: std_logic;
    signal bank_iz		: std_logic;    
    signal ebank_i		: std_logic;
    --signal eebank		: std_logic;    
    signal ewren1		: std_logic;
    signal new_xn_cnt		: std_logic_vector(log2_nfft/2-1 downto 0);
    signal ld_xn		: std_logic;
    signal enax_i		: std_logic;
    signal sclr_a  		: std_logic;
	signal sclr_aa		: std_logic;   
    signal sclr_b  		: std_logic;
	signal sclr_bb		: std_logic; 
    signal sclr_c  		: std_logic;
	signal sclr_cc		: std_logic; 
    signal sclr_d  		: std_logic;
	signal sclr_dd		: std_logic;
	signal sclr_e       : std_logic;
	signal sclr_f       : std_logic;
	signal ce_a 		: std_logic;
	signal ce_b			: std_logic;
	signal comp_value_a : std_logic;
-- srl16/FF based delay
        
component z19w1
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		din		: in std_logic;
		dout		: out std_logic
	);
end component;  

component z49w1
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		din		: in std_logic;
		dout		: out std_logic
	);
end component;    

component xdsp_cnt11
	port (clk		: in std_logic;		
		  ce	: in std_logic;		   
	      q		: out std_logic_vector(10 downto 0);
		  sclr 	: in std_logic);
end component;	  

component xdsp_cnt10
	port (clk		: in std_logic;		
		  ce	: in std_logic;		   
	      q		: out std_logic_vector(9 downto 0);
		  sclr 	: in std_logic);
end component;	  

attribute RLOC : string;
attribute RLOC of state_proc_b : label is "R0C1"; 
attribute RLOC of outp_state_proc2_bbb : label is "R0C3";
attribute RLOC of outp_state_proc : label is "R0C2";
attribute RLOC of outp_state_proc3_bbbb	: label is "R0C4";	   	
attribute RLOC of out_proc_init : label is "R0C0";
attribute RLOC of strt2_pipe : label is "R1C0";	
attribute RLOC of wren_proc_b : label is "R0C6";
attribute RLOC of ewren1_proc_b : label is "R0C7";
begin

out_proc_init : z19w1 
	port map (
		clk	=> clk,
		ce	=> ce,
		rs	=> rs,
		din	=> start,
		dout	=> ostart
	);		

strt2_pipe : z49w1 
	port map (
		clk	=> clk,
		ce	=> ce,
		rs	=> rs,
		din	=> start,
		dout	=> strt2
	);
	
wren_proc : process(clk,rs,start,mwr)
begin
    if clk'event and clk = '1' then
        if rs = '1' then
--            io_cycle_cntr <= (others => '0');
            wren <= '0';
            busy_i <= '0';
          elsif start = '1' then
            busy_i <= '1';
            wren <= '0';
--            io_cycle_cntr <= (others => '0');		   
          elsif ce = '1' then
               if busy_i = '0' then
	                    if mwr = '1' and mode = '1' then
		                  wren <= '1';
		                elsif addrw = nfft-1 then
		                  wren <= '0';    
		                end if;               
               else        
--                        io_cycle_cntr <= io_cycle_cntr + 1;
                        if io_cycle_cntr = assert_wren and fft_active = true then
                           wren <= '1';
                        elsif io_cycle_cntr = fft_busy_ticks and mode = '0' then
                           wren <= '0';
                           busy_i <= '0';
                        end if;
                end if; -- busy_i ?   
          end if;	 -- ce start rs ?
     end if;	  -- clk'event
end process wren_proc;

ce_a <= ce and busy_i;
sclr_e <= rs or start;
wren_proc_b :  xdsp_cnt11
			 port map ( clk	=> clk,
				        q	=> io_cycle_cntr,
				        ce	=> ce_a,
						sclr    => sclr_e);	

ewren1_proc : process(clk,ce,rs,start,wren1_cntr)
variable	r : std_logic;
begin
    r := rs or start;
    if clk'event and clk = '1' then
        if r = '1' or wren1_cntr = wren1_nticks then
            ewren1 <= '0';
--            wren1_cntr <= (others => '0');
        elsif ce = '1' then
            if wren1_cntr = assert_wren-1 and fft_active = true then
                ewren1 <= '1';
            elsif wren1_cntr = fin_rankm_nticks-3 then
                ewren1 <= '0';
            end if;
--            wren1_cntr <= wren1_cntr + 1;
        end if;
    end if;
end process ewren1_proc;

ce_b <= ce and busy_i;	 		
new_wren_proc: process(clk)
 begin 
 if wren1_cntr = wren1_nticks then
	comp_value_a <= '1';
 else
	comp_value_a <= '0';
 end if;
end process new_wren_proc;

sclr_f <= rs or start or comp_value_a;
ewren1_proc_b :  xdsp_cnt11
			 port map ( clk	=> clk,
				        q	=> wren1_cntr,
				        ce	=> ce_b,
					sclr    => sclr_f);	

wrenx_proc : process(clk,ce,rs,start,mwr,b,enax_i,ebank_i)
	variable r	: std_logic;
	variable cen	: std_logic;
begin
	r := rs;
	cen := ce and busy_i;
	if clk'event and clk = '1' then
		if r = '1' then
			wrenx <= '0';
		elsif ce = '1' then 		
		    if busy_i = '0' then
		        --if mwr = '1' then
		        --    wrenx <= '1';
		        --elsif (addrw = n-1) and enax_i = '1' then
		        --    wrenx <= '0';    
		        --end if;     
		    elsif ebank_i = '0' then
			wrenx <= '0';
	            else
	            	wrenx <= ewren1;
		    end if;
		end if;
	end if;
end process;

wreny_proc : process(clk,ce,rs,start,ebank_i)
	variable r	: std_logic;
	variable cen	: std_logic;
begin
	r := rs;
	cen := ce and busy_i;
	if clk'event and clk = '1' then
		if r = '1' then
			wreny <= '0';
		elsif cen = '1' then 
		    if ebank_i = '1' then
			wreny <= '0';
	            else
	            	wreny <= ewren1;
		    end if;
		end if;
	end if;
end process;

web_x_proc : process(clk,ce,rs,start,mwr,b,enax_i,ebank_i)
	variable r	: std_logic;
	variable cen	: std_logic;
begin
	r := rs;
	cen := ce and busy_i;
	if clk'event and clk = '1' then
		if r = '1' then
			web_x <= '0';
		elsif ce = '1' then 		
		    if busy_i = '0' then
		        if mwr = '1' then
		            web_x <= '1';
		        elsif (addrw = nfft-1) and enax_i = '1' then
		            web_x <= '0';    
		        end if;     
		    elsif ebank_i = '0' then
			web_x <= '1';
	            else
	            	web_x <= '0';
		    end if;
		end if;
	end if;
end process;

web_y_proc : process(clk,ce,rs,start,enax_i,busy_i,ebank_i)
	variable r	: std_logic;
	variable cen	: std_logic;
begin
	r := rs;
	cen := ce and busy_i;
	if clk'event and clk = '1' then
		if r = '1' then
			web_y <= '0';
		elsif ce = '1' then 		
		    if busy_i = '1' then   
		        if ebank_i = '1' then
			    web_y <= '1';
			else
			    web_y <= '0';
			end if;
		    end if;
		end if;
	end if;
end process;

status : process(clk,ce,rs,start)
begin
    if clk'event and clk = '1' then
        if rs = '1' then
            fft_active <= false;
        elsif ce = '1' then
            if start = '1' then
                fft_active <= true;
            end if;
        end if;
    end if;
end process status;

rank0_proc : process(clk,ce,rs,start)
begin
    if clk'event and clk = '1' then
        if ce = '1' then
            if b = start_rank0 then
                rank_eq_0_i <= '1';
            elsif rank_eq_0_i = '1' and b = end_rank0 then
                rank_eq_0_i <= '0';
            end if;
        end if;        
    end if;
end process rank0_proc;

state_proc : process(clk,dma)
     --variable	r1 : std_logic;
begin
	if dma = '0' and (b = reset_state) then
	sclr_aa <= '1';
    elsif dma = '1' and (b = reset_state_dma) then
	sclr_aa <= '1';	
    else
	sclr_aa <= '0';
    end if;
    --if dma = '0' and (b = reset_state) then
--	r1 := '1';
--    elsif dma = '1' and (b = reset_state_dma) then
--	r1 := '1';	
--    else
--	r1 := '0';
--    end if;
	
   -- if clk'event and clk = '1' then
--        if ce = '1' then
--            if rs = '1' or start = '1' or r1 = '1' then 
--                b <= (others => '0');
--            elsif ce = '1' then
--                b <= b + 1;
--            end if;
--        end if;
--    end if;    
end process state_proc;

sclr_a <= rs or start or sclr_aa;
state_proc_b : xdsp_cnt11
			port map ( 	clk	=> clk,
				        q	=> b,
				        ce	=> ce,
						sclr    => sclr_a);	 
state_process_bb: process(clk)
begin
	if clk'event and clk='1' then
		if bb = reset_outp_state then
			sclr_bb<='1';
		else
			sclr_bb<='0';
		end if;
	end if;
end process state_process_bb;

sclr_b <= rs or ostart or start or sclr_bb;						
outp_state_proc :  xdsp_cnt11
			 port map ( clk	=> clk,
				        q	=> bb,
				        ce	=> ce,
						sclr    => sclr_b);	 

--process(clk,ce,rs,ostart,start)
--begin
--    if clk'event and clk = '1' then
--        if rs = '1' or ostart = '1' or start = '1' or bb = reset_outp_state then
--            bb <= (others => '0');
--        elsif ce = '1' then
--            bb <= bb + 1;
--        end if;      
--    end if;
--end process outp_state_proc;

outp_state_proc2 : process(clk,dma)
  --   variable	r1 : std_logic;
begin
     if dma = '0' and (bbb = reset_bbb) then
	sclr_cc <= '1';
    elsif dma = '1' and (bbb = reset_bbb_dma) then
	sclr_cc <= '1';	
    else
	sclr_cc <= '0';
    end if;
   -- if dma = '0' and (bbb = reset_bbb) then
--	r1 := '1';
--    elsif dma = '1' and (bbb = reset_bbb_dma) then
--	r1 := '1';	
--    else
--	r1 := '0';
--    end if;
    
--    if clk'event and clk = '1' then
--        if rs = '1' or strt2 = '1' or  r1 = '1' then --  bbb = reset_bbb then
--            bbb <= (others => '0');
--        elsif ce = '1' then
--            bbb <= bbb + 1;
--        end if;      
--    end if;
end process outp_state_proc2;

sclr_c <= rs or strt2 or sclr_cc or start;
						
outp_state_proc2_bbb :  xdsp_cnt11
			 port map ( clk	=> clk,
				    q	=> bbb,
				    ce	=> ce,
				    sclr    => sclr_c);	 

--outp_state_proc3 : process(clk, dma)
--   --  variable	r1 : std_logic;
--begin
--	if dma = '0' and (bbbb = reset_bbbb) then
--	sclr_dd <= '1';
--    elsif dma = '1' and (bbbb = reset_bbbb_dma) then
--	sclr_dd <= '1';	
--    else
--	sclr_dd <= '0';
--    end if;
--    --if dma = '0' and (bbbb = reset_bbbb) then
----	r1 := '1';
----    elsif dma = '1' and (bbbb = reset_bbbb_dma) then
----	r1 := '1';	
----    else
----	r1 := '0';
----    end if;
--
-- --   if clk'event and clk = '1' then
----        if mwr = '1' or rs = '1' or strt2 = '1' or  r1 = '1' then -- bbbb = reset_bbbb then
----            bbbb <= (others => '0');
----        elsif ce = '1' then
----            bbbb <= bbbb + 1;
----        end if;      
----    end if;
--end process outp_state_proc3;

sclr_d <= rs or mwr or strt2;						
outp_state_proc3_bbbb :  xdsp_cnt10
			 port map ( clk	=> clk,
				        q	=> bbbb(9 downto 0),
				        ce	=> ce,
						sclr    => sclr_d);	 


done_proc : process(clk,ce,rs,busy_i)
	variable r	: std_logic;
begin
	r := rs;
	if clk'event and clk = '1' then
		if r = '1' then
			done <= '0';
		elsif bbb = done_cnt and busy_i = '1' then
			done <= '1';
		else
			done <= '0';
		end if;
	end if;
end process;

edone_proc : process(clk,ce,rs,busy_i)
	variable r	: std_logic;
begin
	r := rs;
	if clk'event and clk = '1' then
		if r = '1' then
			edone <= '0';
		elsif bbb = edone_cnt and busy_i = '1' then
			edone <= '1';
		else
			edone <= '0';
		end if;
	end if;
end process;

result_proc : process(clk,ce,rs,start,busy_i)
	variable r	: std_logic;
begin
	r := rs or start;
	if clk'event and clk = '1' then
		if r = '1' then
			result <= '0';
		elsif bbb = begin_result and busy_i = '1' then
			result <= '1';
		elsif bbb = end_result then
			result <= '0';
		end if;
	end if;
end process;

eresult_proc : process(clk,ce,rs,start,busy_i)
	variable r	: std_logic;
begin
	r := rs or start;
	if clk'event and clk = '1' then
		if r = '1' then
			eresult <= '0';
		elsif bbb = begin_result-1 and busy_i = '1' then
			eresult <= '1';
		elsif bbb = end_result-1 then
			eresult <= '0';
		end if;
	end if;
end process;

io_proc : process(clk,ce,rs,start,busy_i,mwr)
	variable r	: std_logic;
begin
	r := rs or start;
	if clk'event and clk = '1' then
		if r = '1' then
			io <= '0';
		elsif ce = '1' then
            	    if busy_i = '0' then
	                if mwr = '1' then
		            io <= '1';
		        elsif addrw = nfft-1 then
		            io <= '0';  
		        end if; 			
		    elsif (bbbb = begin_io+1 and busy_i = '1' and mode = '1') then
			io <= '1';
		    elsif bbbb = end_io+1 then
			io <= '0';
		    end if;
		end if;
	end if;
end process;

eio_proc : process(clk,ce,rs,start,busy_i,mwr)
	variable r	: std_logic;
begin
	r := rs or start;
	if clk'event and clk = '1' then
		if r = '1' then
			eio <= '0';
		elsif ce = '1' then
            	    if busy_i = '0' then
	                if mwr = '1' then
		            eio <= '1';
		        elsif addrw = nfft-1 then
		            eio <= '0';  
		        end if; 			
		    elsif (bbbb = begin_io-1 and busy_i = '1') then
			eio <= '1';
		    elsif bbbb = end_io-1 then
			eio <= '0';
		    end if;
                end if;
	end if;
end process;

fftstart_proc : process(clk,ce,rs,busy_i)
	variable r		: std_logic;
	variable assert_mode_ce	: std_logic;
begin
	r := rs; 
    	if dma = '0' and (b = mode_ce_cnt) then
		assert_mode_ce := '1';
    	elsif dma = '1' and (b = mode_ce_cnt_dma) then
		assert_mode_ce := '1';	
    	else
		assert_mode_ce := '0';
    	end if;	
    	
	if clk'event and clk = '1' then
		if r = '1' then
			mode_ce <= '0';
		elsif ce = '1' then 
		    if assert_mode_ce = '1' and busy_i = '1' then 
			mode_ce <= '1';
		    else
			mode_ce <= '0';
		    end if;
		end if;
	end if;
end process;

bank_proc : process(clk,ce,rs,start,busy_i,b)
	variable r	: std_logic;
begin
	r := rs;
	if clk'event and clk = '1' then
		if r = '1' then
			bank_iz <= '0';
			bank_i <= '0';
		elsif ce = '1' then 
		    if (b = bank_switch_cnt and busy_i = '1') or start = '1' then
			bank_iz <= bank_iz xor '1';
		    end if;
		    bank_i <= bank_iz;
		end if;
	end if;
end process;

ebank_proc : process(clk,ce,rs,start,busy_i,b)
	variable r	: std_logic;
begin
	r := rs;
	if clk'event and clk = '1' then
		if r = '1' then
			ebank_i <= '0';
		elsif ce = '1' then 
		    if (b = bank_switch_cnt-1 and busy_i = '1') or start = '1' then
			ebank_i <= ebank_i xor '1';
		    end if;
		end if;
	end if;
end process;

ld_xn_proc : process(clk,rs,ce,mwr,start)
    variable	nxt_xn  : std_logic;
    variable	r	: std_logic;
begin
    
    r := rs or mwr or start;
    
    if clk'event and clk = '1' then
        if r = '1' then
            new_xn_cnt <= (others => '0');
            ld_xn <= '0';
        elsif ce = '1' then 
            if new_xn_cnt = log2_nfft/2 - 2 then
                new_xn_cnt <= (others => '0');
            else
                new_xn_cnt <= new_xn_cnt + 1;
            end if;
            if new_xn_cnt = log2_nfft/2 - 4 then
                ld_xn <= '1';
            else
                ld_xn <= '0';
            end if;
        end if;   
    end if;
end process;

enaxy_proc : process(clk,rs,ce,start,ld_xn, ebank_i)
begin
    if clk'event and clk = '1' then
        if rs = '1' then
	   enax_i <= '0';
	   enay <= '0';
        elsif ebank_i = '0' then
            enax_i <= ld_xn;
            enay <= '1';
        else
            enay <= ld_xn;
            enax_i <= '1';
        end if;
    end if;
end process;

	rank_eq_0 <= rank_eq_0_i;
	busy <= busy_i;
	bank <= bank_i;
	nxt_addr <= ld_xn;
	enax <= enax_i;	
	ebank <= ebank_i;
end behv;	
-- FFT operand read address generator

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	
library xilinxcorelib;
    	use xilinxcorelib.fft_defsx_256.all;
    	
entity fft_rd_agenx_256 is
	port(
		clk		: in std_logic;		-- global clock
		ce		: in std_logic;		-- master clock enable
		rs		: in std_logic;		-- master reset
		start		: in std_logic;		-- xform start
		mrd		: in std_logic;
		mwr		: in std_logic;
		io_mode0	: in std_logic;
		io_mode1	: in std_logic;
		bank		: in std_logic;
		nxt_addr	: in std_logic;
		fft_rd_addr	: out std_logic_vector(log2_nfft-1 downto 0);
		fft_rd_addr_y	: out std_logic_vector(log2_nfft-1 downto 0)		
	);
end fft_rd_agenx_256;

architecture fft_rd_agen_256 of fft_rd_agenx_256 is

	constant reset_rd_agen		: natural := (log2_nfft/2-1) * nfft - 1;
	constant reset_rd_agen_dma	: natural := log2_nfft/2 * nfft - 1;	
	constant rank_init		: natural := log2_max_nfft/2 - log2_nfft/2;
	constant m			: natural := 13;  -- max state bits
	constant mr			: natural := 3;   -- max rank cntr state bits
	-- state counter for operand read address generator
	signal	b		: std_logic_vector(m-1 downto 0);
	signal	bb		: std_logic_vector(m-1 downto 0);
		
	-- mux selects
	signal	a2a3_s0		: std_logic;
	signal	a4a5_s0		: std_logic;
	signal	a4a5_s1		: std_logic;
	signal	a6a7_s1		: std_logic;
	signal	a8a9_s0		: std_logic;	
	signal	fft_rd_addr_u	: std_logic_vector(log2_max_nfft-1 downto 0);
	signal	rank		: std_logic_vector(mr-1 downto 0);	
	signal 	unload		: std_logic;
	signal	ld_addr		: std_logic_vector(log2_nfft-1 downto 0);
				
component xdsp_mux3w1
	port (
		a		: in std_logic;	-- mux operand inputs
		b		: in std_logic;
		c		: in std_logic;
		s0		: in std_logic;	-- mux selects
		s1		: in std_logic;	-- mux selects
		y		: out std_logic	-- mux output signal
	);
end component;

component xdsp_mux2w1
	port (
		a		: in std_logic;	-- mux operand inputs
		b		: in std_logic;
		s0		: in std_logic;	-- mux sel
		y		: out std_logic	-- mux output signal
	);
end component;

begin

a0_mux : xdsp_mux2w1
	port map (
		a	=>	bb(2),
		b	=>	bb(0),
		s0	=>	rank(2),
		y	=>	fft_rd_addr_u(0) 
	);

a1_mux : xdsp_mux2w1
	port map (
		a	=>	bb(3),
		b	=>	bb(1),
		s0	=>	rank(2),
		y	=>	fft_rd_addr_u(1) 
	);
	
a2_mux : xdsp_mux3w1
	port map (
		a	=>	bb(4),
		b	=>	bb(0),
		c	=>	bb(2),
		s0	=>	a2a3_s0,
		s1	=>	rank(2),
		y	=>	fft_rd_addr_u(2) 
	);
	
a3_mux : xdsp_mux3w1
	port map (
		a	=>	bb(5),
		b	=>	bb(1),
		c	=>	bb(3),
		s0	=>	a2a3_s0,
		s1	=>	rank(2),
		y	=>	fft_rd_addr_u(3) 
	);
	
a4_mux : xdsp_mux3w1
	port map (
		a	=>	bb(6),
		b	=>	bb(0),
		c	=>	bb(4),
		s0	=>	a4a5_s0,
		s1	=>	a4a5_s1,
		y	=>	fft_rd_addr_u(4) 
	);
	
a5_mux : xdsp_mux3w1
	port map (
		a	=>	bb(7),
		b	=>	bb(1),
		c	=>	bb(5),
		s0	=>	a4a5_s0,
		s1	=>	a4a5_s1,
		y	=>	fft_rd_addr_u(5) 
	);
	
a6_mux : xdsp_mux3w1
	port map (
		a	=>	bb(8),
		b	=>	bb(0),
		c	=>	bb(6),
		s0	=>	rank(0),
		s1	=>	a6a7_s1,
		y	=>	fft_rd_addr_u(6) 
	);
	
a7_mux : xdsp_mux3w1
	port map (
		a	=>	bb(9),
		b	=>	bb(1),
		c	=>	bb(7),
		s0	=>	rank(0),
		s1	=>	a6a7_s1,
		y	=>	fft_rd_addr_u(7) 
	);
	
a8_mux : xdsp_mux2w1
	port map (
		a	=>	bb(0),
		b	=>	bb(8),
		s0	=>	a8a9_s0,
		y	=>	fft_rd_addr_u(8) 
	);		

a9_mux : xdsp_mux2w1
	port map (
		a	=>	bb(1),
		b	=>	bb(9),
		s0	=>	a8a9_s0,
		y	=>	fft_rd_addr_u(9) 
	);	
		
operand_rd_agen : process(clk,ce,rs,start,mrd,io_mode1)
	variable r,r1	: std_logic;	
	variable init	: std_logic;
begin
	r := rs;
	init := start or mrd;	
	if io_mode1 = '0' and (b = reset_rd_agen) then
	    r1 := '1';
	elsif io_mode1 = '1' and (b = reset_rd_agen_dma) then
	    r1 := '1';	
	else
	    r1 := '0';
	end if;
						
	if clk'event and clk = '1' then
		if init = '1' then
			b <= conv_std_logic_vector(1,m);
		elsif r = '1' or r1 = '1' then
			b <= (others => '0');
		elsif ce = '1' then
			b <= b + 1;
		end if;
	end if;
end process;

operand_rd_agenb : process(clk,ce,rs,start,mwr)
	variable cen	: std_logic;
	variable r,r1	: std_logic;
	variable ld	: std_logic;	
begin

	r := rs;	
		
	if clk'event and clk = '1' then
	    if ce = '1' then
	        if start = '1' or mwr = '1' then
	            bb <= conv_std_logic_vector(1,m);
	        elsif r = '1' or bb = nfft-1 then
                    bb <= (others => '0');
	        else 
		    bb <= bb + 1;
		end if;
	    end if;
	end if;
	
end process;

rank_proc : process(clk,ce,rs,start,io_mode1,mwr)
	variable r,r1	: std_logic;	
begin

	r := rs or start;	
	  	
	if io_mode1 = '0' and (b = reset_rd_agen) then
	    r1 := '1';
	elsif io_mode1 = '1' and (b = reset_rd_agen_dma) then
	    r1 := '1';	
	else
	    r1 := '0';
	end if;
	
	if clk'event and clk = '1' then
	    if ce = '1' then 
		if r = '1' or r1 = '1' then
		    rank <= conv_std_logic_vector(rank_init,mr); 
		elsif mwr = '1' then
		    rank <= "100";				--conv_std_logic_vector(log2_nfft/2,mr);     
		elsif bb = nfft-1 then
		    rank <= rank + 1;
		end if;
	    end if;
	end if;
end process;

reg_rd_addr: process(clk,ce,rs,start,mrd,mwr)
	variable r	: std_logic;
begin
	r := rs or start or mrd or mwr;
	if clk'event and clk = '1' then
		if r = '1' then
			fft_rd_addr <= (others => '0');
		elsif ce = '1' then
		    if unload = '1' then
			fft_rd_addr <= (b(1),b(0),b(3),b(2),b(5),b(4),b(7),b(6));		
		    elsif bank = '0' and io_mode1 = '0' then
	    		fft_rd_addr <= ld_addr;		    
		    else	    
			fft_rd_addr <= fft_rd_addr_u(log2_nfft-1 downto 0);
		    end if;
		end if;
	end if;
end process;

reg_rd_addry: process(clk,ce,rs,start,mwr,bank,io_mode1)
	variable r	: std_logic;
begin
	r := rs or start or mwr;
	if clk'event and clk = '1' then
		if r = '1' then
			fft_rd_addr_y <= (others => '0');
		elsif ce = '1' then	
		    if bank = '1' and io_mode1 = '0' then
	    		fft_rd_addr_y <= ld_addr;
	    	    else	    
			fft_rd_addr_y <= fft_rd_addr_u(log2_nfft-1 downto 0);
		    end if;
		end if;
	end if;
end process;

result_rd_proc : process(clk,ce,rs,start,mrd,mwr)
	variable r 	: std_logic;
begin
	r := rs or start or mwr;
	if clk'event and clk = '1' then
		if r = '1' then
			unload <= '0';
		elsif ce = '1' then
			if mrd = '1' then
				unload <= '1';
			end if;	
		end if;
	end if;
end process;

addrx_proc : process(clk,ce,rs,start,nxt_addr,io_mode1,ld_addr)
	variable	cen		: std_logic;
	variable	r		: std_logic;		
begin
	cen := ce and ((nxt_addr and not io_mode1) or io_mode1);
	r := (start or mwr) and not io_mode1;
	if clk'event and clk = '1' then
		if r = '1' then
			ld_addr <= (others => '0');
		elsif cen = '1' then
			ld_addr <= ld_addr + 1;
		end if;
	end if;

end process;

a2a3_s0 <= not ((not rank(0) and not rank(1)) or (rank(1) and not rank(0)) or 
           (rank(0) and not rank(1)));
           
a4a5_s0 <= not ((not rank(0) and not rank(1)) or (rank(0) and not rank(1)));  

a4a5_s1 <= (rank(0) and rank(1)) or rank(2);

a6a7_s1 <= rank(1) or rank(2);

a8a9_s0 <= rank(0) or rank(1) or rank(2);


end fft_rd_agen_256;
-- FFT operand write address generator

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	
library xilinxcorelib;
    	use xilinxcorelib.fft_defsx_256.all;
    	
entity fft_wr_agenx_256 is
	port(
		clk		: in std_logic;		-- global clock
		ce		: in std_logic;		-- master clock enable
		rs		: in std_logic;		-- master reset
		start		: in std_logic;		-- xform start
		gstart		: in std_logic;
		io_mode0	: in std_logic;
		io_mode1	: in std_logic;
		dma		: in std_logic;
		result		: in std_logic;
		nxt_addr	: in std_logic;
		bank		: in std_logic;
		mwr		: in std_logic;
		fft_wr_addrx	: out std_logic_vector(log2_nfft-1 downto 0);
		fft_wr_addry	: out std_logic_vector(log2_nfft-1 downto 0)
	);
end fft_wr_agenx_256;

architecture fft_wr_agen_256 of fft_wr_agenx_256 is

	constant reset_wr_agen		: natural := (log2_nfft/2-1) * nfft - 1; 
	constant reset_wr_agen_dma	: natural := (log2_nfft/2) * nfft - 1; 			
	constant b_init			: natural := 0; --(log2_max_nfft/2 - log2_nfft/2) * max_fft;
	constant rank_init		: natural := log2_max_nfft/2 - log2_nfft/2;
	constant m			: natural := 13;  -- max state bits
	constant mr			: natural := 3;   -- max rank cntr state bits	
	-- state counter for operand read address generator
	signal	b		: std_logic_vector(9 downto 0);
	signal	bb		: std_logic_vector(7 downto 0);	
	
	-- mux selects
	signal	a2a3_s0		: std_logic;
	signal	a4a5_s0		: std_logic;
	signal	a4a5_s1		: std_logic;
	signal	a6a7_s1		: std_logic;
	signal	a8a9_s0		: std_logic;	
	--signal	resultd		: std_logic;
	signal	fft_wr_addr_u	: std_logic_vector(7 downto 0);	
	signal	fft_wr_addr_i	: std_logic_vector(7 downto 0);		
	signal	rank		: std_logic_vector(mr-1 downto 0);	
	signal	ld_addr		: std_logic_vector(log2_nfft-1 downto 0);
		
component xdsp_mux3w1
	port (
		a		: in std_logic;	-- mux operand inputs
		b		: in std_logic;
		c		: in std_logic;
		s0		: in std_logic;	-- mux selects
		s1		: in std_logic;	-- mux selects
		y		: out std_logic	-- mux output signal
	);
end component;

component xdsp_mux2w1
	port (
		a		: in std_logic;	-- mux operand inputs
		b		: in std_logic;
		s0		: in std_logic;	-- mux sel
		y		: out std_logic	-- mux output signal
	);
end component;

begin

a0_mux : xdsp_mux2w1
	port map (
		a	=>	bb(2),
		b	=>	bb(0),
		s0	=>	rank(2),
		y	=>	fft_wr_addr_u(0) 
	);

a1_mux : xdsp_mux2w1
	port map (
		a	=>	bb(3),
		b	=>	bb(1),
		s0	=>	rank(2),
		y	=>	fft_wr_addr_u(1) 
	);
	
a2_mux : xdsp_mux3w1
	port map (
		a	=>	bb(4),
		b	=>	bb(0),
		c	=>	bb(2),
		s0	=>	a2a3_s0,
		s1	=>	rank(2),
		y	=>	fft_wr_addr_u(2) 
	);
	
a3_mux : xdsp_mux3w1
	port map (
		a	=>	bb(5),
		b	=>	bb(1),
		c	=>	bb(3),
		s0	=>	a2a3_s0,
		s1	=>	rank(2),
		y	=>	fft_wr_addr_u(3) 
	);
	
a4_mux : xdsp_mux3w1
	port map (
		a	=>	bb(6),
		b	=>	bb(0),
		c	=>	bb(4),
		s0	=>	a4a5_s0,
		s1	=>	a4a5_s1,
		y	=>	fft_wr_addr_u(4) 
	);
	
a5_mux : xdsp_mux3w1
	port map (
		a	=>	bb(7),
		b	=>	bb(1),
		c	=>	bb(5),
		s0	=>	a4a5_s0,
		s1	=>	a4a5_s1,
		y	=>	fft_wr_addr_u(5) 
	);
	
a6_mux : xdsp_mux2w1
	port map (
		a	=>	bb(0),
		b	=>	bb(6),
		s0	=>	a6a7_s1,
		y	=>	fft_wr_addr_u(6) 
	);

a7_mux : xdsp_mux2w1
	port map (
		a	=>	bb(1),
		b	=>	bb(7),
		s0	=>	a6a7_s1,
		y	=>	fft_wr_addr_u(7) 
	);
	
--register the write memory address

process(clk,ce,fft_wr_addr_u,mwr,result)
begin
	if clk'event and clk = '1' then
		if ce = '1' then
		    if result = '1' then
		       fft_wr_addr_i <= (others => '0');  
		    elsif mwr = '1' then
		       fft_wr_addr_i <= conv_std_logic_vector(1,log2_nfft);  
		    else
	    		fft_wr_addr_i <= fft_wr_addr_u(log2_nfft-1 downto 0); 
	    	    end if;	
	    	end if;
	end if;
end process;
		
operand_wr_agen : process(clk,ce,rs,start,io_mode0,result,dma)

	variable ld	: std_logic;
	variable r,r1	: std_logic;
	
begin
	-- the ld signal handles the final rank processing when only
	-- a single memory bank is used
	
	-- DMA
	-- When dma = 1 the host interface employs a DMA data load process
	  
	ld := (not io_mode0 and result) and ce;
	r := rs or start;
	
	if dma = '0' and (b = reset_wr_agen) then
	    r1 := '1';	
	else
	    r1 := '0';
	end if;
	
	if clk'event and clk = '1' then
	    if r = '1' or r1 = '1' or ld = '1' then
                b <= (others => '0'); 
	    elsif ce = '1' then
		    b <= b + 1;
	    end if;
	end if;
end process;

operand_wr_agenb : process(clk,ce,rs,start,io_mode0,result,dma,mwr)
	variable cen	: std_logic;
	variable r,r1	: std_logic;
	variable ld	: std_logic;	
begin

	r := rs or start;
	
	ld := not io_mode0 and result;
		
	if clk'event and clk = '1' then
	    if ce = '1' then
	        if ld = '1' then
	            bb <= conv_std_logic_vector(1,8);
	        elsif mwr = '1' then
	            bb <= conv_std_logic_vector(2,8);
	        elsif r = '1' then	 
                    bb <= (others => '0');
	        else 
		    bb <= bb + 1;
		end if;
	    end if;
	end if;
	
end process;

rank_proc : process(clk,ce,rs,start,dma,mwr)
	variable r,r1	: std_logic;
	variable ld	: std_logic;	
begin

	-- the ld signal handles the final rank processing when only
	-- a single memory bank is used
	
	-- DMA
	-- When dma = 1 the host interface employs a DMA data load process
	r := rs or start;	
	  
	ld := (not io_mode0 and result) or mwr;
	
	if dma = '0' and (b = reset_wr_agen) then
	    r1 := '1';
	elsif dma = '1' and (b = reset_wr_agen_dma) then
	    r1 := '1';	
	else
	    r1 := '0';
	end if;
	
	if clk'event and clk = '1' then
	    if ce = '1' then 
		if r = '1' or r1 = '1' then
		    rank <= conv_std_logic_vector(rank_init,mr);
		elsif ld = '1' then
		    rank <= "100";	--conv_std_logic_vector(log2_max_nfft/2-1,mr);     
		elsif bb = nfft-1 then
		    rank <= rank + 1;
		end if;
	    end if;
	end if;
end process;

addrx_proc : process(clk,ce,rs,gstart,nxt_addr,io_mode1,ld_addr)
	variable	cen		: std_logic;
	variable	r		: std_logic;		
begin
	cen := ce and ((nxt_addr and not io_mode1) or io_mode1);
	r := (gstart or mwr) and not io_mode1;
	if clk'event and clk = '1' then
		if r = '1' then
			ld_addr <= (others => '0');
		elsif cen = '1' then
			ld_addr <= ld_addr + 1;
		end if;
	end if;

end process;

addrx_mux_proc : process(clk,ce,rs,ld_addr,fft_wr_addr_i,bank,io_mode1,mwr)
begin
    if clk'event and clk = '1' then
  	if ce = '1' then
  	    if mwr = '1' then
  	        fft_wr_addrx <= (others => '0');
  	    elsif bank = '0' and io_mode1 = '0' then
    		fft_wr_addrx <= ld_addr;
    	    else
    	        fft_wr_addrx <= fft_wr_addr_i;
  	    end if;
  	end if;
    end if;
end process;

addry_mux_proc : process(clk,ce,rs,ld_addr,fft_wr_addr_i,bank)
begin
    if clk'event and clk = '1' then
  	if ce = '1' then
  	    if bank = '0' then
    		fft_wr_addry <= fft_wr_addr_i;
    	    else
    	        fft_wr_addry <= ld_addr;
  	    end if;
  	end if;
    end if;
end process;

	a2a3_s0 <= not ((not rank(0) and not rank(1)) or (rank(1) and not rank(0)) or 
           (rank(0) and not rank(1)));
           
	a4a5_s0 <= not ((not rank(0) and not rank(1)) or (rank(0) and not rank(1)));  

	a4a5_s1 <= (rank(0) and rank(1)) or rank(2);

	a6a7_s1 <= rank(1) or rank(2);

	a8a9_s0 <= rank(0) or rank(1) or rank(2);
	
end fft_wr_agen_256;
-- Synopsis: FFT constants and other definitions
-- Modification History

library ieee;
use ieee.std_logic_1164.all;
package fft_defs_16 is
    constant	B	: positive := 16;		-- word precision of FFT
    constant nfft	: natural := 16;    
    constant log2_nfft	: natural := 4;		
    constant max_sint	: natural := 2**(B-1) - 1;	-- max positive signed int.
    constant max_uint	: natural := 2**B;		-- max positive signed int.      
end fft_defs_16;
-- SRL16/FF based 1-bit wide 4 stage delay line

-- din -> srl16_1 -> FF1
-- srl16_1 provides 3 bits of delay and a FF procides the final 1 bit of delay 

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;

-- synopsys translate_off
library unisim;
	use unisim.vcomponents.all;
-- synopsys translate_on
		
entity z4w1 is
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		din		: in std_logic;
		dout		: out std_logic
	);
end z4w1;

architecture struct of z4w1 is

	signal	u1	: std_logic;
	signal	logic0	: std_logic;
	signal	logic1	: std_logic;
	
	
component SRL16E
	port (
		q		: out std_logic;	
		d		: in std_logic;
		ce		: in std_logic;
		clk   		: in std_logic;
 		a0		: in std_logic;			
 		a1		: in std_logic;
 		a2		: in std_logic;
 		a3		: in std_logic
	);
end component;

begin

srl16_1 : SRL16E 
	port map(
		q		=> u1,	
		d		=> din,
		ce		=> ce,
		clk   		=> clk,
		a0		=> logic0,	-- 3 stage delay line (addr = dec 2)
 		a1		=> logic1,
 		a2		=> logic0,
 		a3		=> logic0
 	);
 	
ff1 : process (clk,ce,u1)
begin
	if clk'event and clk = '1' then
		if ce = '1' then
			dout <= u1;	
		end if;
	end if;
end process;
 
	logic0 <= '0';
	logic1 <= '1';
		 	
end struct;		   
-- SRL16/FF based 1-bit wide 6 stage delay line

-- din -> srl16_1 -> FF1 -> srl16_22 -> FF2 -> srl16 -> FF3

-- srl16_1 provides 16 bits of delay, srl16_2 provides 16 bit of delay,
-- srl16_3 provides 1 bits of delay 
-- ... the 3 FFs provide the additional 3 bits of delay

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;

-- synopsys translate_off
library unisim;
	use unisim.vcomponents.all;
-- synopsys translate_on
		
entity z36w1 is
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		din		: in std_logic;
		dout		: out std_logic
	);
end z36w1;

architecture struct of z36w1 is

	signal	u1	: std_logic;
	signal	u2	: std_logic;
	signal	u3	: std_logic;	
	signal	ff1_q	: std_logic;
	signal	ff2_q	: std_logic;	
	signal	logic0	: std_logic;
	signal	logic1	: std_logic;
	
	
component SRL16E 
	port (
		q		: out std_logic;	
		d		: in std_logic;
		ce		: in std_logic;
		clk   		: in std_logic;
 		a0		: in std_logic;			
 		a1		: in std_logic;
 		a2		: in std_logic;
 		a3		: in std_logic
	);
end component;

begin

srl16_1 : SRL16E 
	port map(
		q		=> u1,	
		d		=> din,
		ce		=> ce,
		clk   		=> clk,
		a0		=> logic1,	-- 16 stage delay line (addr = dec 15)
 		a1		=> logic1,
 		a2		=> logic1,
 		a3		=> logic1
 	);
 	
ff1 : process (clk,ce,u1)
begin
	if clk'event and clk = '1' then
		if ce = '1' then
			ff1_q <= u1;	
		end if;
	end if;
end process;

srl16_2 : SRL16E 
	port map(
		q		=> u2,	
		d		=> ff1_q,
		ce		=> ce,
		clk   		=> clk,
		a0		=> logic1,	-- 16 stage delay line (addr = dec 15)
 		a1		=> logic1,
 		a2		=> logic1,
 		a3		=> logic1
 	);

ff2 : process (clk,ce,u1)
begin
	if clk'event and clk = '1' then
		if ce = '1' then
			ff2_q <= u2;	
		end if;
	end if;
end process;

srl16_3 : SRL16E 
	port map(
		q		=> u3,	
		d		=> ff2_q,
		ce		=> ce,
		clk   		=> clk,
		a0		=> logic0,	-- 1 stage delay line (addr = dec 0)
 		a1		=> logic0,
 		a2		=> logic0,
 		a3		=> logic0
 	);

ff3 : process (clk,ce,u1)
begin
	if clk'event and clk = '1' then
		if ce = '1' then
			dout <= u3;	
		end if;
	end if;
end process;
 
	logic0 <= '0';
	logic1 <= '1';
		 	
end struct;		   
-- SRL16/FF based 1-bit wide 47 stage delay line

-- din -> srl16_1 -> FF1 -> srl16_22 -> FF2 -> srl16 -> FF3

-- srl16_1 provides 16 bits of delay, srl16_2 provides 16 bit of delay,
-- srl16_3 provides 11 bits of delay 
-- ... the 3 FFs provide the additional 3 bits of delay

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;

-- synopsys translate_off
library unisim;
	use unisim.vcomponents.all;
-- synopsys translate_on
		
entity z46w1 is
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		din		: in std_logic;
		dout		: out std_logic
	);
end z46w1;

architecture struct of z46w1 is

	signal	u1	: std_logic;
	signal	u2	: std_logic;
	signal	u3	: std_logic;	
	signal	ff1_q	: std_logic;
	signal	ff2_q	: std_logic;	
	signal	logic0	: std_logic;
	signal	logic1	: std_logic;
	
	
component SRL16E 
	port (
		q		: out std_logic;	
		d		: in std_logic;
		ce		: in std_logic;
		clk   		: in std_logic;
 		a0		: in std_logic;			
 		a1		: in std_logic;
 		a2		: in std_logic;
 		a3		: in std_logic
	);
end component;

begin

srl16_1 : SRL16E 
	port map(
		q		=> u1,	
		d		=> din,
		ce		=> ce,
		clk   		=> clk,
		a0		=> logic1,	-- 16 stage delay line (addr = dec 15)
 		a1		=> logic1,
 		a2		=> logic1,
 		a3		=> logic1
 	);
 	
ff1 : process (clk,ce,u1)
begin
	if clk'event and clk = '1' then
		if ce = '1' then
			ff1_q <= u1;	
		end if;
	end if;
end process;

srl16_2 : SRL16E 
	port map(
		q		=> u2,	
		d		=> ff1_q,
		ce		=> ce,
		clk   		=> clk,
		a0		=> logic1,	-- 16 stage delay line (addr = dec 15)
 		a1		=> logic1,
 		a2		=> logic1,
 		a3		=> logic1
 	);

ff2 : process (clk,ce,u1)
begin
	if clk'event and clk = '1' then
		if ce = '1' then
			ff2_q <= u2;	
		end if;
	end if;
end process;

srl16_3 : SRL16E 
	port map(
		q		=> u3,	
		d		=> ff2_q,
		ce		=> ce,
		clk   		=> clk,
		a0		=> logic0,	-- 11 stage delay line (addr = dec 10)
 		a1		=> logic1,
 		a2		=> logic0,
 		a3		=> logic1
 	);

ff3 : process (clk,ce,u1)
begin
	if clk'event and clk = '1' then
		if ce = '1' then
			dout <= u3;	
		end if;
	end if;
end process;
 
	logic0 <= '0';
	logic1 <= '1';
		 	
end struct;		   
-- Virtex FFT
-- complex 4:1 16-bit registered multiplexor

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
		
entity xmux4w16br is
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		s0		: in std_logic;				-- mux select inputs
		s1		: in std_logic;
		x0r		: in std_logic_vector(15 downto 0);	-- mux inputs Re and Im
		x0i		: in std_logic_vector(15 downto 0);
		x1r		: in std_logic_vector(15 downto 0);	
		x1i		: in std_logic_vector(15 downto 0);
		x2r		: in std_logic_vector(15 downto 0);	
		x2i		: in std_logic_vector(15 downto 0);
		x3r		: in std_logic_vector(15 downto 0);	
		x3i		: in std_logic_vector(15 downto 0);
		yr		: out std_logic_vector(15 downto 0);	-- mux outputs
		yi		: out std_logic_vector(15 downto 0)
	      );
end xmux4w16br;

architecture behv of xmux4w16br is

	signal	omuxr		: std_logic_vector(15 downto 0);
	signal	omuxi		: std_logic_vector(15 downto 0);
	
component xdsp_mux4w16r
  port( ma 	: in  std_logic_vector( 16 -1 DOWNTO 0 );
        mb 	: in  std_logic_vector( 16 -1 DOWNTO 0 );
        mc 	: in  std_logic_vector( 16 -1 DOWNTO 0 );
        md 	: in  std_logic_vector( 16 -1 DOWNTO 0 );
        clk	: in std_logic;
        ce	: in std_logic;
 	s	: in std_logic_vector(1 downto 0);
        q 	: out std_logic_vector( 16 -1 DOWNTO 0 ) );
end component;

attribute RLOC : string;
attribute RLOC of mux4w16_r : label is "R0C0";
attribute RLOC of mux4w16_i : label is "R0C1";
--attribute RLOC of muxreg_r  : label is "R0C0";
--attribute RLOC of muxreg_i  : label is "R13C9";

begin

mux4w16_r : xdsp_mux4w16r
	port map(
		ma		=> x0r,
		mb		=> x1r,
		mc		=> x2r,
		md		=> x3r,
		clk		=> clk,
		ce		=> ce,
		s(0)		=> s0,
		s(1)		=> s1,
		q		=> yr		
	);
	
mux4w16_i : xdsp_mux4w16r
	port map(
		ma		=> x0i,
		mb		=> x1i,
		mc		=> x2i,
		md		=> x3i,
	       	clk		=> clk,
	       	ce 		=> ce,	
		s(0)		=> s0,
		s(1)		=> s1,
		q		=> yi		
	);
		
end behv;
-- Virtex B-point FFT
-- 4-point FFT module

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;

library xilinxcorelib;
	use xilinxcorelib.fft_defs_16.all;
		
-- synopsys translate_off
library xilinxcorelib;
	use xilinxcorelib.ul_utils.all;
-- synopsys translate_on
	
entity fft4_16 is
	port (
		clk		: in std_logic;				-- system clock
		rs		: in std_logic;				-- reset
		start		: in std_logic;				-- global start
		ce		: in std_logic;
		conj		: in std_logic;				-- conjugation control
									-- conjugates when == 0
		dr		: in std_logic_vector(B-1 downto 0);	-- data input
		di		: in std_logic_vector(B-1 downto 0);
		y0r		: out std_logic_vector(B-1 downto 0);	-- transform outp. samples
		y0i		: out std_logic_vector(B-1 downto 0);
		y1r		: out std_logic_vector(B-1 downto 0);
		y1i		: out std_logic_vector(B-1 downto 0);
		y2r		: out std_logic_vector(B-1 downto 0);
		y2i		: out std_logic_vector(B-1 downto 0);
		y3r		: out std_logic_vector(B-1 downto 0);
		y3i		: out std_logic_vector(B-1 downto 0)
	      );
end fft4_16;

architecture struct of fft4_16 is

		signal ce0		: std_logic;		-- sample reg. ld enables
		signal ce1		: std_logic;
		signal ce2		: std_logic;
		signal ce3		: std_logic;
		signal cex0		: std_logic;		-- sample reg. ld enables
		signal cex1		: std_logic;
		signal cex2		: std_logic;
		signal cex3		: std_logic;
		signal start_fft4	: std_logic;		-- start 4-point FFT
		-- registered samples presented to 4-point FFT
		signal x0r		: std_logic_vector(B-1 downto 0); 
		signal x0i		: std_logic_vector(B-1 downto 0); 
		signal x1r		: std_logic_vector(B-1 downto 0); 
		signal x1i		: std_logic_vector(B-1 downto 0); 
		signal x2r		: std_logic_vector(B-1 downto 0); 
		signal x2i		: std_logic_vector(B-1 downto 0); 
		signal x3r		: std_logic_vector(B-1 downto 0); 
		signal x3i		: std_logic_vector(B-1 downto 0); 
		-- registered outputs for butterfly #0
		signal	b0_y0r		: std_logic_vector(B downto 0);
		signal	b0_y0i		: std_logic_vector(B downto 0);
		signal	b0_y1r		: std_logic_vector(B downto 0);
		signal	b0_y1i		: std_logic_vector(B downto 0);
		-- registered output for butterfly #1
		signal	b1_y0r		: std_logic_vector(B downto 0);
		signal	b1_y0i		: std_logic_vector(B downto 0);
		signal	b1_y1r		: std_logic_vector(B downto 0);
		signal	b1_y1i		: std_logic_vector(B downto 0);
		-- registered output for butterfly #2
		signal	b2_y0r		: std_logic_vector(B+1 downto 0);
		signal	b2_y0i		: std_logic_vector(B+1 downto 0);
		signal	b2_y1r		: std_logic_vector(B+1 downto 0);
		signal	b2_y1i		: std_logic_vector(B+1 downto 0);
		-- registered output for butterfly #3
		signal	b3_y0r		: std_logic_vector(B+1 downto 0);
		signal	b3_y0i		: std_logic_vector(B+1 downto 0);
		signal	b3_y1r		: std_logic_vector(B+1 downto 0);
		signal	b3_y1i		: std_logic_vector(B+1 downto 0);
		signal	conji		: std_logic;

component cmplx_reg16_conj
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
end component;

component cmplx_reg16_conjb
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
end component;


component state_mach
	port (
		clk		: in std_logic;				-- system clock
		rs		: in std_logic;				-- reset
		start		: in std_logic;				-- global start 
		ce		: in std_logic;				-- global clk enable
		s0		: out std_logic;			-- state outputs
		s1		: out std_logic;
		s2		: out std_logic;
		s3		: out std_logic
	      );
end component;

component bflyw0_16
	port (
		clk		: std_logic;		-- mast clock
		ce		: std_logic;		-- master clock enable
		start_fft4	: std_logic;		-- start 4-point FFT
		x0r		: in std_logic_vector(B-1 downto 0); -- Re operand 0
		x0i		: in std_logic_vector(B-1 downto 0); -- Im operand 0	
		x1r		: in std_logic_vector(B-1 downto 0); -- Re operand 1
		x1i		: in std_logic_vector(B-1 downto 0); -- Im operand 1	
		y0r		: out std_logic_vector(B downto 0); -- Re result 0
		y0i		: out std_logic_vector(B downto 0); -- Im result 0	
		y1r		: out std_logic_vector(B downto 0); -- Re result 1
		y1i		: out std_logic_vector(B downto 0)  -- Im result 1		
	);
end component;

component bflywj_16
	port (
		clk		: std_logic;		-- mast clock
		ce		: std_logic;		-- master clock enable
		start_fft4	: std_logic;		-- start 4-point FFT
		x0r		: in std_logic_vector(B-1 downto 0); -- Re operand 0
		x0i		: in std_logic_vector(B-1 downto 0); -- Im operand 0	
		x1r		: in std_logic_vector(B-1 downto 0); -- Re operand 1
		x1i		: in std_logic_vector(B-1 downto 0); -- Im operand 1	
		y0r		: out std_logic_vector(B downto 0); -- Re result 0
		y0i		: out std_logic_vector(B downto 0); -- Im result 0	
		y1r		: out std_logic_vector(B downto 0); -- Re result 1
		y1i		: out std_logic_vector(B downto 0)  -- Im result 1		
	);
end component;

component bflyw0_17
	port (
		clk		: std_logic;		-- mast clock
		ce		: std_logic;		-- master clock enable
		start_fft4	: std_logic;		-- start 4-point FFT
		x0r		: in std_logic_vector(B downto 0); -- Re operand 0
		x0i		: in std_logic_vector(B downto 0); -- Im operand 0	
		x1r		: in std_logic_vector(B downto 0); -- Re operand 1
		x1i		: in std_logic_vector(B downto 0); -- Im operand 1	
		y0r		: out std_logic_vector(B+1 downto 0); -- Re result 0
		y0i		: out std_logic_vector(B+1 downto 0); -- Im result 0	
		y1r		: out std_logic_vector(B+1 downto 0); -- Re result 1
		y1i		: out std_logic_vector(B+1 downto 0)  -- Im result 1		
	);
end component;

attribute RLOC : string;
attribute RLOC of x0_reg : label is "R0C0";
attribute RLOC of x1_reg : label is "R0C0";
attribute RLOC of x2_reg : label is "R0C1";
attribute RLOC of x3_reg : label is "R0C1";
attribute RLOC of b0 : label is "R0C2";
attribute RLOC of b1 : label is "R0C3";
attribute RLOC of b2 : label is "R0C4";
attribute RLOC of b3 : label is "R0C5";

begin

smach : state_mach
	port map(
		clk		=> clk,
		rs		=> rs,
		start		=> start,
		ce		=> ce,
		s0		=> cex0,
		s1		=> cex1,
		s2		=> cex2,
		s3		=> cex3
	);

x0_reg : cmplx_reg16_conj
	port map(
		clk		=> clk,
		ce		=> ce0,
		conj		=> conji,
		dr		=> dr,
		di		=> di,
		qr		=> x0r,			-- Re(x(0))
		qi		=> x0i			-- Im(x(0))
	);

x1_reg : cmplx_reg16_conjb
	port map(
		clk		=> clk,
		ce		=> ce1,
		conj		=> conji,
		dr		=> dr,
		di		=> di,
		qr		=> x1r,			-- Re(x(1))
		qi		=> x1i			-- Im(x(1))
	);
	
x2_reg : cmplx_reg16_conj
	port map(
		clk		=> clk,
		ce		=> ce2,
		conj		=> conji,
		dr		=> dr,
		di		=> di,
		qr		=> x2r,			-- Re(x(2))
		qi		=> x2i			-- Im(x(2))
	);

x3_reg : cmplx_reg16_conjb
	port map(
		clk		=> clk,
		ce		=> ce3,
		conj		=> conji,
		dr		=> dr,
		di		=> di,
		qr		=> x3r,			-- Re(x(3))
		qi		=> x3i			-- Im(x(3))
	);
	
b0 : bflyw0_16
	port map (
		clk		=> clk,			-- mast clock
		ce		=> ce,			-- master clock enable
		start_fft4	=> start_fft4,
		x0r		=> x0r,
		x0i		=> x0i,	
		x1r		=> x2r,
		x1i		=> x2i,	
		y0r		=> b0_y0r,
		y0i		=> b0_y0i,	
		y1r		=> b0_y1r,	
		y1i		=> b0_y1i
	);
	
b1 : bflywj_16
	port map (
		clk		=> clk,			-- mast clock
		ce		=> ce,			-- master clock enable
		start_fft4	=> start_fft4,
		x0r		=> x1r,
		x0i		=> x1i,	
		x1r		=> x3r,
		x1i		=> x3i,	
		y0r		=> b1_y0r,
		y0i		=> b1_y0i,	
		y1r		=> b1_y1r,	
		y1i		=> b1_y1i
	);

b2 : bflyw0_17
	port map (
		clk		=> clk,			-- mast clock
		ce		=> ce,			-- master clock enable
		start_fft4	=> start_fft4,
		x0r		=> b0_y0r,
		x0i		=> b0_y0i,	
		x1r		=> b1_y0r,
		x1i		=> b1_y0i,	
		y0r		=> b2_y0r,
		y0i		=> b2_y0i,	
		y1r		=> b2_y1r,	
		y1i		=> b2_y1i
	);	
b3 : bflyw0_17
	port map (
		clk		=> clk,			-- mast clock
		ce		=> ce,			-- master clock enable
		start_fft4	=> start_fft4,
		x0r		=> b0_y1r,
		x0i		=> b0_y1i,	
		x1r		=> b1_y1r,
		x1i		=> b1_y1i,	
		y0r		=> b3_y0r,
		y0i		=> b3_y0i,	
		y1r		=> b3_y1r,	
		y1i		=> b3_y1i
	);	
			
	start_fft4 <= ce and cex1;
	ce0 <= ce and cex1;	
	ce1 <= ce and cex2;
	ce2 <= ce and cex3;
	ce3 <= ce and cex0;
	y0r <= b2_y0r(B+1 downto 2);
	y0i <= b2_y0i(B+1 downto 2);
	y1r <= b3_y0r(B+1 downto 2);
	y1i <= b3_y0i(B+1 downto 2);
	y2r <= b2_y1r(B+1 downto 2);
	y2i <= b2_y1i(B+1 downto 2);
	y3r <= b3_y1r(B+1 downto 2);
	y3i <= b3_y1i(B+1 downto 2);
	conji <= conj;	
			
end struct;





-- Virtex 16-point FFT
-- 4-point FFT module

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
		
entity fft4b is
	port (
		clk		: in std_logic;				-- system clock
		rs		: in std_logic;				-- reset
		start		: in std_logic;				-- global start
		ce		: in std_logic;
		conj		: in std_logic;				-- conjugation control
									-- conjugates when == 0
		dr		: in std_logic_vector(15 downto 0);	-- data input
		di		: in std_logic_vector(15 downto 0);
		y0r		: out std_logic_vector(15 downto 0);	-- transform outp. samples
		y0i		: out std_logic_vector(15 downto 0);
		y1r		: out std_logic_vector(15 downto 0);
		y1i		: out std_logic_vector(15 downto 0);
		y2r		: out std_logic_vector(15 downto 0);
		y2i		: out std_logic_vector(15 downto 0);
		y3r		: out std_logic_vector(15 downto 0);
		y3i		: out std_logic_vector(15 downto 0)
	      );
end fft4b;

architecture struct of fft4b is

		signal ce0		: std_logic;		-- sample reg. ld enables
		signal ce1		: std_logic;
		signal ce2		: std_logic;
		signal ce3		: std_logic;
		signal cex0		: std_logic;		-- sample reg. ld enables
		signal cex1		: std_logic;
		signal cex2		: std_logic;
		signal cex3		: std_logic;
		signal start_fft4	: std_logic;		-- start 4-point FFT
		-- registered samples presented to 4-point FFT
		signal x0r		: std_logic_vector(15 downto 0); 
		signal x0i		: std_logic_vector(15 downto 0); 
		signal x1r		: std_logic_vector(15 downto 0); 
		signal x1i		: std_logic_vector(15 downto 0); 
		signal x2r		: std_logic_vector(15 downto 0); 
		signal x2i		: std_logic_vector(15 downto 0); 
		signal x3r		: std_logic_vector(15 downto 0); 
		signal x3i		: std_logic_vector(15 downto 0); 
		-- registered outputs for butterfly #0
		signal	b0_y0r		: std_logic_vector(16 downto 0);
		signal	b0_y0i		: std_logic_vector(16 downto 0);
		signal	b0_y1r		: std_logic_vector(16 downto 0);
		signal	b0_y1i		: std_logic_vector(16 downto 0);
		-- registered output for butterfly #1
		signal	b1_y0r		: std_logic_vector(16 downto 0);
		signal	b1_y0i		: std_logic_vector(16 downto 0);
		signal	b1_y1r		: std_logic_vector(16 downto 0);
		signal	b1_y1i		: std_logic_vector(16 downto 0);
		-- registered output for butterfly #2
		signal	b2_y0r		: std_logic_vector(17 downto 0);
		signal	b2_y0i		: std_logic_vector(17 downto 0);
		signal	b2_y1r		: std_logic_vector(17 downto 0);
		signal	b2_y1i		: std_logic_vector(17 downto 0);
		-- registered output for butterfly #3
		signal	b3_y0r		: std_logic_vector(17 downto 0);
		signal	b3_y0i		: std_logic_vector(17 downto 0);
		signal	b3_y1r		: std_logic_vector(17 downto 0);
		signal	b3_y1i		: std_logic_vector(17 downto 0);
		signal	conji		: std_logic;

component cmplx_reg16_conj
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		conj		: in std_logic;				-- conjugation control
									-- forms conjugation when ==1
		dr		: in std_logic_vector(15 downto 0);	-- Re/Im data in
		di		: in std_logic_vector(15 downto 0);
		qr		: out std_logic_vector(15 downto 0);	-- Re/Im data out
		qi		: out std_logic_vector(15 downto 0)
	      );
end component;

component cmplx_reg16_conjb
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		conj		: in std_logic;				-- conjugation control
									-- forms conjugation when ==1
		dr		: in std_logic_vector(15 downto 0);	-- Re/Im data in
		di		: in std_logic_vector(15 downto 0);
		qr		: out std_logic_vector(15 downto 0);	-- Re/Im data out
		qi		: out std_logic_vector(15 downto 0)
	      );
end component;

component state_mach
	port (
		clk		: in std_logic;				-- system clock
		rs		: in std_logic;				-- reset
		start		: in std_logic;				-- global start 
		ce		: in std_logic;				-- global clk enable
		s0		: out std_logic;			-- state outputs
		s1		: out std_logic;
		s2		: out std_logic;
		s3		: out std_logic
	      );
end component;

component bflyw0_16
	port (
		clk		: std_logic;		-- mast clock
		ce		: std_logic;		-- master clock enable
		start_fft4	: std_logic;		-- start 4-point FFT
		x0r		: in std_logic_vector(15 downto 0); -- Re operand 0
		x0i		: in std_logic_vector(15 downto 0); -- Im operand 0	
		x1r		: in std_logic_vector(15 downto 0); -- Re operand 1
		x1i		: in std_logic_vector(15 downto 0); -- Im operand 1	
		y0r		: out std_logic_vector(16 downto 0); -- Re result 0
		y0i		: out std_logic_vector(16 downto 0); -- Im result 0	
		y1r		: out std_logic_vector(16 downto 0); -- Re result 1
		y1i		: out std_logic_vector(16 downto 0)  -- Im result 1		
	);
end component;

component bflywj_16
	port (
		clk		: std_logic;		-- mast clock
		ce		: std_logic;		-- master clock enable
		start_fft4	: std_logic;		-- start 4-point FFT
		x0r		: in std_logic_vector(15 downto 0); -- Re operand 0
		x0i		: in std_logic_vector(15 downto 0); -- Im operand 0	
		x1r		: in std_logic_vector(15 downto 0); -- Re operand 1
		x1i		: in std_logic_vector(15 downto 0); -- Im operand 1	
		y0r		: out std_logic_vector(16 downto 0); -- Re result 0
		y0i		: out std_logic_vector(16 downto 0); -- Im result 0	
		y1r		: out std_logic_vector(16 downto 0); -- Re result 1
		y1i		: out std_logic_vector(16 downto 0)  -- Im result 1		
	);
end component;

component bflyw0_17
	port (
		clk		: std_logic;		-- mast clock
		ce		: std_logic;		-- master clock enable
		start_fft4	: std_logic;		-- start 4-point FFT
		x0r		: in std_logic_vector(16 downto 0); -- Re operand 0
		x0i		: in std_logic_vector(16 downto 0); -- Im operand 0	
		x1r		: in std_logic_vector(16 downto 0); -- Re operand 1
		x1i		: in std_logic_vector(16 downto 0); -- Im operand 1	
		y0r		: out std_logic_vector(17 downto 0); -- Re result 0
		y0i		: out std_logic_vector(17 downto 0); -- Im result 0	
		y1r		: out std_logic_vector(17 downto 0); -- Re result 1
		y1i		: out std_logic_vector(17 downto 0)  -- Im result 1		
	);
end component;

attribute RLOC : string;
attribute RLOC of x0_reg : label is "R0C0";
attribute RLOC of x1_reg : label is "R0C0";
attribute RLOC of x2_reg : label is "R0C1";
attribute RLOC of x3_reg : label is "R0C1";
attribute RLOC of b0 : label is "R0C2";
attribute RLOC of b1 : label is "R0C3";
attribute RLOC of b2 : label is "R0C4";
attribute RLOC of b3 : label is "R0C5";
attribute RLOC of smach : label is "R9C3";

begin

smach : state_mach
	port map(
		clk		=> clk,
		rs		=> rs,
		start		=> start,
		ce		=> ce,
		s0		=> cex0,
		s1		=> cex1,
		s2		=> cex2,
		s3		=> cex3
	);

x0_reg : cmplx_reg16_conj
	port map(
		clk		=> clk,
		ce		=> ce0,
		conj		=> conji,
		dr		=> dr,
		di		=> di,
		qr		=> x0r,			-- Re(x(0))
		qi		=> x0i			-- Im(x(0))
	);

x1_reg : cmplx_reg16_conjb
	port map(
		clk		=> clk,
		ce		=> ce1,
		conj		=> conji,
		dr		=> dr,
		di		=> di,
		qr		=> x1r,			-- Re(x(1))
		qi		=> x1i			-- Im(x(1))
	);
	
x2_reg : cmplx_reg16_conj
	port map(
		clk		=> clk,
		ce		=> ce2,
		conj		=> conji,
		dr		=> dr,
		di		=> di,
		qr		=> x2r,			-- Re(x(2))
		qi		=> x2i			-- Im(x(2))
	);

x3_reg : cmplx_reg16_conjb
	port map(
		clk		=> clk,
		ce		=> ce3,
		conj		=> conji,
		dr		=> dr,
		di		=> di,
		qr		=> x3r,			-- Re(x(3))
		qi		=> x3i			-- Im(x(3))
	);
	
b0 : bflyw0_16
	port map (
		clk		=> clk,			-- mast clock
		ce		=> ce,			-- master clock enable
		start_fft4	=> start_fft4,
		x0r		=> x0r,
		x0i		=> x0i,	
		x1r		=> x2r,
		x1i		=> x2i,	
		y0r		=> b0_y0r,
		y0i		=> b0_y0i,	
		y1r		=> b0_y1r,	
		y1i		=> b0_y1i
	);
	
b1 : bflywj_16
	port map (
		clk		=> clk,			-- mast clock
		ce		=> ce,			-- master clock enable
		start_fft4	=> start_fft4,
		x0r		=> x1r,
		x0i		=> x1i,	
		x1r		=> x3r,
		x1i		=> x3i,	
		y0r		=> b1_y0r,
		y0i		=> b1_y0i,	
		y1r		=> b1_y1r,	
		y1i		=> b1_y1i
	);

b2 : bflyw0_17
	port map (
		clk		=> clk,			-- mast clock
		ce		=> ce,			-- master clock enable
		start_fft4	=> start_fft4,
		x0r		=> b0_y0r,
		x0i		=> b0_y0i,	
		x1r		=> b1_y0r,
		x1i		=> b1_y0i,	
		y0r		=> b2_y0r,
		y0i		=> b2_y0i,	
		y1r		=> b2_y1r,	
		y1i		=> b2_y1i
	);	
b3 : bflyw0_17
	port map (
		clk		=> clk,			-- mast clock
		ce		=> ce,			-- master clock enable
		start_fft4	=> start_fft4,
		x0r		=> b0_y1r,
		x0i		=> b0_y1i,	
		x1r		=> b1_y1r,
		x1i		=> b1_y1i,	
		y0r		=> b3_y0r,
		y0i		=> b3_y0i,	
		y1r		=> b3_y1r,	
		y1i		=> b3_y1i
	);	
			
--	start_fft4 <= ce and cex1;
	start_fft4 <= cex1;
	ce0 <= ce and cex1;	
	ce1 <= ce and cex2;
	ce2 <= ce and cex3;
	ce3 <= ce and cex0;
	y0r <= b2_y0r(17 downto 2);
	y0i <= b2_y0i(17 downto 2);
	y1r <= b3_y0r(17 downto 2);
	y1i <= b3_y0i(17 downto 2);
	y2r <= b2_y1r(17 downto 2);
	y2i <= b2_y1i(17 downto 2);
	y3r <= b3_y1r(17 downto 2);
	y3i <= b3_y1i(17 downto 2);
	conji <= conj;	
			
end struct;





-- dragonfly processor

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	
entity dragonfly_16 is
	port (
		clk		: in std_logic;		-- system clock
		rs		: in std_logic;		-- reset
		start		: in std_logic;		-- start transform
		ce		: in std_logic;		-- master clk enable
		conj		: in std_logic;		-- conjugation control
		xnr		: in std_logic_vector(15 downto 0);
		xni		: in std_logic_vector(15 downto 0);
		wr		: in std_logic_vector(15 downto 0);	-- phase factors
		wi		: in std_logic_vector(15 downto 0);
		xk_r		: out std_logic_vector(16 downto 0);
		xk_i		: out std_logic_vector(16 downto 0)
	      );
end dragonfly_16;

architecture struct of dragonfly_16 is

	-- fft4 output mux selects
	signal	fft4_omux_s0		: std_logic;
	signal	fft4_omux_s1		: std_logic;
	signal	fft4_omux_state_cntr	: std_logic_vector(1 downto 0);
	
	-- 4-point FFT output samples
	signal	y0r			: std_logic_vector(15 downto 0);
	signal	y0i			: std_logic_vector(15 downto 0);
	signal	y1r			: std_logic_vector(15 downto 0);
	signal	y1i			: std_logic_vector(15 downto 0);
	signal	y2r			: std_logic_vector(15 downto 0);
	signal	y2i			: std_logic_vector(15 downto 0);
	signal	y3r			: std_logic_vector(15 downto 0);
	signal	y3i			: std_logic_vector(15 downto 0);
	
	-- output of multiplexor that selects the output samples from the 4-point FFT
	signal	tr			: std_logic_vector(15 downto 0);
	signal	ti			: std_logic_vector(15 downto 0);
	signal  vcc 			: std_logic;
	signal  gnd 			: std_logic;
	signal  sclr_a			: std_logic;
	
component fft4b
	port (
		clk		: in std_logic;				-- system clock
		rs		: in std_logic;				-- reset
		start		: in std_logic;				-- global start
		ce		: in std_logic;
		conj		: in std_logic;
		dr		: in std_logic_vector(15 downto 0);
		di		: in std_logic_vector(15 downto 0);
		y0r		: out std_logic_vector(15 downto 0);
		y0i		: out std_logic_vector(15 downto 0);
		y1r		: out std_logic_vector(15 downto 0);
		y1i		: out std_logic_vector(15 downto 0);
		y2r		: out std_logic_vector(15 downto 0);
		y2i		: out std_logic_vector(15 downto 0);
		y3r		: out std_logic_vector(15 downto 0);
		y3i		: out std_logic_vector(15 downto 0)
	      );
end component;

component xmux4w16r
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		s0		: in std_logic;				-- mux select inputs
		s1		: in std_logic;
		x0r		: in std_logic_vector(15 downto 0);	-- mux inputs Re and Im
		x0i		: in std_logic_vector(15 downto 0);
		x1r		: in std_logic_vector(15 downto 0);	
		x1i		: in std_logic_vector(15 downto 0);
		x2r		: in std_logic_vector(15 downto 0);	
		x2i		: in std_logic_vector(15 downto 0);
		x3r		: in std_logic_vector(15 downto 0);	
		x3i		: in std_logic_vector(15 downto 0);
		yr		: out std_logic_vector(15 downto 0);	-- mux outputs
		yi		: out std_logic_vector(15 downto 0)
	      );
end component;

-- 16 x 17 complex multiplier
component xmul16x17
	port (
		clk		: in std_logic;		-- system clock
		rs		: in std_logic;		-- reset
		ce		: in std_logic;		-- master clk enable
		ar		: in std_logic_vector(15 downto 0);  	-- Re(operand 1)
		ai		: in std_logic_vector(15 downto 0);	-- Im(operand 1)
		br		: in std_logic_vector(15 downto 0);	-- Re(operand 2)
		bi		: in std_logic_vector(15 downto 0);	-- Im(operand 2)
		pr		: out std_logic_vector(16 downto 0);	-- Re( a x b)
		pi		: out std_logic_vector(16 downto 0)	-- Im( a x b)
	      );
end component;

component xdsp_cnt2
	port (clk	: in std_logic;		
	      ce	: in std_logic;		   
	      q		: out std_logic_vector(1 downto 0);
	      sclr 	: in std_logic);
end component;	  

attribute RLOC : string;
attribute RLOC of xfft4 : label is "R0C0"; 
attribute RLOC of fft4_omux : label is "R0C6";
attribute RLOC of xmul : label is "R0C7";
attribute RLOC of fft4_omux_state_mach : label is "R10C7";

-- 4-point FFT port mappings
-- This small transform is applied to the input data prior to processing by the
-- complex multiplier

begin

vcc <= '1';
gnd <= '0';

xfft4 : fft4b
	port map (
		clk		=> clk,				-- system clock
		rs		=> rs,				-- reset
		start		=> start,			-- global start
		ce		=> ce,				-- master clk enable
		conj		=> conj,
		dr		=> xnr,				-- Re/Im input sample
		di		=> xni,
		y0r		=> y0r,				-- output samples
		y0i		=> y0i,
		y1r		=> y1r,
		y1i		=> y1i,
		y2r		=> y2r,
		y2i		=> y2i,
		y3r		=> y3r,
		y3i		=> y3i		
	);

fft4_omux : xmux4w16r 
	port map (
		clk		=> clk,			-- system clock
		ce		=> ce,			-- global clk enable
		s0		=> fft4_omux_s0,	-- mux select inputs
		s1		=> fft4_omux_s1,
		x0r		=> y1r,	
		x0i		=> y1i,
		x1r		=> y2r,	
		x1i		=> y2i,
		x2r		=> y3r,	
		x2i		=> y3i,
		x3r		=> y0r,	
		x3i		=> y0i,
		yr		=> tr,			-- sample presented to cmplx mul
		yi		=> ti
	);

-- complex product 
-- This module accepts outputs from the 4-point FFT 'xfft4' and applies
-- the phase rotations read from the phase factor trig LUT
-- The complex samples from the xfft4 unit are presented to the complex multiplier
-- via the 4:1 complex mutliplexor 'fft4_omux'.

xmul : xmul16x17 
	port map(
		clk		=> clk,		-- system clock
		rs		=> rs,		-- reset
		ce		=> ce,		-- master clk enable
		ar		=> tr, 		-- Re(operand 1)
		ai		=> ti,		-- Im(operand 1)
		br		=> wr,		-- Re(operand 2)
		bi		=> wi,		-- Im(operand 2)
		pr		=> xk_r,	-- output: Re( a x b)
		pi		=> xk_i		-- output: Im( a x b)
	      );
	      
-- rank-0 4-point FFT state machine

--fft4_omux_state_mach : process(clk,rs,ce,start)
--begin
--	if (rs = '1' or start = '1') then
--		fft4_omux_state_cntr <= "00";
--	elsif (clk'event and clk='1') then
--		if (ce = '1') then
--			fft4_omux_state_cntr <= fft4_omux_state_cntr + 1;
--		end if;	
--	end if;
--end process; 
sclr_a <= rs or start;
fft4_omux_state_mach : xdsp_cnt2
		port map ( 	clk	=> clk,
				q	=> fft4_omux_state_cntr,
				ce	=> ce,
				sclr    => sclr_a);	
				
	fft4_omux_s0 <= fft4_omux_state_cntr(0);
	fft4_omux_s1 <= fft4_omux_state_cntr(1);
	
end struct;
-- Virtex 16-point FFT
-- input double buffer and data re-ordering

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	
-- synopsys translate_off
library xilinxcorelib;
	use xilinxcorelib.ul_utils.all;
-- synopsys translate_on
	
entity input_dbl_bufr is
	port (
		clk		: in std_logic;				-- system clock
		rs		: in std_logic;				-- reset
		start		: in std_logic;				-- start transform
		ce		: in std_logic;				-- clk enable
		dr		: in std_logic_vector(15 downto 0);
		di		: in std_logic_vector(15 downto 0);
		qr		: out std_logic_vector(15 downto 0);
		qi		: out std_logic_vector(15 downto 0)
	      );
end input_dbl_bufr;

architecture struct of input_dbl_bufr is
	
	-- definitions for input double buffer
	signal	state_cntr		: std_logic_vector(4 downto 0);
	signal	addr_a			: std_logic_vector(3 downto 0);
	signal	addr_b			: std_logic_vector(3 downto 0);
	signal	addr_ram0		: std_logic_vector(3 downto 0);
	signal	addr_ram1		: std_logic_vector(3 downto 0);
	signal	reg_addr_ram0		: std_logic_vector(3 downto 0);
	signal	reg_addr_ram1		: std_logic_vector(3 downto 0);
	signal	ram0_addr_mux_sel	: std_logic;
	signal	ram1_addr_mux_sel	: std_logic;
	-- write enables for ram0 and ram1
	signal	ram0_we			: std_logic;
	signal	ram1_we			: std_logic;
	signal	ram0q_r			: std_logic_vector(15 downto 0);
	signal	ram0q_i			: std_logic_vector(15 downto 0);
	signal	ram1q_r			: std_logic_vector(15 downto 0);
	signal	ram1q_i			: std_logic_vector(15 downto 0);
	signal	odmux_sel		: std_logic; 
	signal	odmux_sel0		: std_logic; 
	signal  sclr_a			: std_logic;
	signal  sclr_b			: std_logic;
	signal  n_state_cntr    	: std_logic;
				
component xdsp_ramd16a4
  port (a	: IN STD_LOGIC_VECTOR(4-1 DOWNTO 0);
        d	: IN STD_LOGIC_VECTOR(16-1 DOWNTO 0);
        we	: IN STD_LOGIC;
        clk	: IN STD_LOGIC;
        qspo_ce	: IN STD_LOGIC;
        qspo	: OUT STD_LOGIC_VECTOR(16-1 DOWNTO 0));
end component;

component xdsp_mux2w4
  port( ma 	: IN  std_logic_vector( 4 - 1 DOWNTO 0 );
        mb 	: IN  std_logic_vector( 4 - 1 DOWNTO 0 );
        sel 	: IN  std_logic;
        o  	: OUT std_logic_vector( 4 - 1 DOWNTO 0 ) );
end component;

component xdsp_mux2w16
  port( ma 	: IN  std_logic_vector( 16 - 1 DOWNTO 0 );
        mb 	: IN  std_logic_vector( 16 - 1 DOWNTO 0 );
        sel 	: IN  std_logic;
        o  	: OUT std_logic_vector( 16 - 1 DOWNTO 0 ) );
end component;

component xdsp_cnt5
  port( clk 	: in  std_logic;
        ce 	: in  std_logic;
        sclr 	: IN  std_logic;        
        q 	: out std_logic_vector(4 downto 0));
end component;

component xdsp_reg4
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		sclr		: in std_logic;
		d		: in std_logic_vector(3 downto 0);	-- data in
		q		: out std_logic_vector(3 downto 0)	-- data out
	      );
end component;

attribute RLOC : string;
attribute RLOC of ram0_r : label is "R0C0";
attribute RLOC of ram0_i : label is "R0C1";
attribute RLOC of ram1_r : label is "R0C2";
attribute RLOC of ram1_i : label is "R0C3";
attribute RLOC of odmux_r : label is "R0C2";
attribute RLOC of odmux_i : label is "R0C3";
attribute RLOC of ram0_addr_mux : label is "R3C0";
attribute RLOC of ram1_addr_mux : label is "R3C1";
attribute RLOC of addr_gen : label is "R0C1";
attribute RLOC of reg_addr_a : label is "R3C0";
attribute RLOC of reg_addr_b : label is "R3C1";
--attribute RLOC of ram_we : label is "R6C1";

begin

ram0_r : xdsp_ramd16a4
	port map (
		a		=> reg_addr_ram0,
		d		=> dr,
		we		=> ram0_we,
		clk		=> clk,
		qspo_ce		=> ce,
		qspo		=> ram0q_r
	);
	
ram0_i : xdsp_ramd16a4
	port map (
		a		=> reg_addr_ram0,
		d		=> di,
		we		=> ram0_we,
		clk		=> clk,
		qspo_ce		=> ce,
		qspo		=> ram0q_i
	);
	
ram1_r : xdsp_ramd16a4
	port map (
		a		=> reg_addr_ram1,
		d		=> dr,
		we		=> ram1_we,
		clk		=> clk,
		qspo_ce		=> ce,
		qspo		=> ram1q_r
	);
	
ram1_i : xdsp_ramd16a4
	port map (
		a		=> reg_addr_ram1,
		d		=> di,
		we		=> ram1_we,
		clk		=> clk,
		qspo_ce		=> ce,
		qspo		=> ram1q_i
	);
		
ram0_addr_mux : xdsp_mux2w4
	port map (
		ma		=> addr_a,
		mb		=> addr_b,
		sel		=> ram0_addr_mux_sel,
		o		=> addr_ram0
	);
	
ram1_addr_mux : xdsp_mux2w4
	port map (
		ma		=> addr_a,
		mb		=> addr_b,
		sel		=> ram1_addr_mux_sel,
		o		=> addr_ram1
	);
	
odmux_r : xdsp_mux2w16
	port map (
		ma		=> ram0q_r,
		mb		=> ram1q_r,
		sel		=> odmux_sel,
		o		=> qr
	);
	
odmux_i : xdsp_mux2w16
	port map (
		ma		=> ram0q_i,
		mb		=> ram1q_i,
		sel		=> odmux_sel,
		o		=> qi
	);		 

--addr_gen : process(clk,rs,ce,start)
--begin
--	if rs = '1' or start = '1' then
--		state_cntr <= (others => '0');
--	elsif clk'event and clk = '1' then
--	    if ce = '1' then
--		state_cntr <= state_cntr + 1;	
--	    end if;
--	end if;
--end process;

sclr_a <= rs or start;

addr_gen : xdsp_cnt5
		port map ( 	clk	=> clk,
				q	=> state_cntr,
				ce	=> ce,
				sclr    => sclr_a);
				
--reg_addr : process(clk,rs,ce,start)
--begin
--	if rs = '1' or start = '1' then
--		reg_addr_ram0 <= (others => '0');
--		reg_addr_ram1 <= (others => '0');
--	elsif clk'event and clk = '1' then
--	    if ce = '1' then
--		reg_addr_ram0 <= addr_ram0;
--		reg_addr_ram1 <= addr_ram1;
--	    end if;
--	end if;
--end process;

sclr_b <= rs or start;

reg_addr_a : xdsp_reg4
	port map(
		clk		=> clk,				
		ce		=> ce,				
		d		=> addr_ram0,			
		q		=> reg_addr_ram0, 			
		sclr    	=> sclr_b
	);

reg_addr_b : xdsp_reg4
	port map(
		clk		=> clk,				
		ce		=> ce,				
		d		=> addr_ram1,		
		q		=> reg_addr_ram1,
		sclr    	=> sclr_b 		
	);
		
ram_we : process(clk,rs,ce,start)
begin
	if rs = '1' then
		ram0_we <= '0';
		ram1_we <= '0';
		odmux_sel0 <= '0';
		odmux_sel <= '0';
	elsif clk'event and clk = '1' then
	    if ce = '1' then
		ram0_we <= not state_cntr(4);
		ram1_we <= state_cntr(4);
		odmux_sel0 <= state_cntr(4);
		odmux_sel <= not odmux_sel0;
	    end if;
	end if;
end process;

n_state_cntr <= not state_cntr(4);

--ram_we : xdsp_reg4
--	port map(
--		clk	=> clk,				
--		ce	=> ce,				
--		d(0)	=> n_state_cntr,
--		d(1)    => state_cntr(4),
--		d(2)    => state_cntr(4),		--n_state_cntr,
--		d(3)    => n_state_cntr,
--		q(0)	=> ram0_we,
--		q(1)    => ram1_we,
--		q(2)    => odmux_sel0,
--		q(3)    => odmux_sel,
--		sclr    => rs 		
--	);
	
addr_a <= state_cntr(3 downto 0);
ram0_addr_mux_sel <= state_cntr(4);
ram1_addr_mux_sel <= not state_cntr(4);
addr_b <= (state_cntr(1),state_cntr(0),state_cntr(3),state_cntr(2));
	
end struct;

-- Virtex 16-point FFT
-- input double buffer and data re-ordering

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	
entity fft_dbl_bufr_16 is
	port (
		clk		: in std_logic;				-- system clock
		rs		: in std_logic;				-- reset
		start		: in std_logic;				-- start transform
		ce		: in std_logic;				-- clk enable
		dr		: in std_logic_vector(15 downto 0);
		di		: in std_logic_vector(15 downto 0);
		qr		: out std_logic_vector(15 downto 0);
		qi		: out std_logic_vector(15 downto 0)
	      );
end fft_dbl_bufr_16;

architecture struct of fft_dbl_bufr_16 is
	
	-- definitions for input double buffer
	signal	state_cntr		: std_logic_vector(4 downto 0);
	signal	addr_a			: std_logic_vector(3 downto 0);
	signal	addr_b			: std_logic_vector(3 downto 0);
	signal	addr_ram0		: std_logic_vector(3 downto 0);
	signal	addr_ram1		: std_logic_vector(3 downto 0);
	signal	reg_addr_ram0		: std_logic_vector(3 downto 0);
	signal	reg_addr_ram1		: std_logic_vector(3 downto 0);
	signal	ram0_addr_mux_sel	: std_logic;
	signal	ram1_addr_mux_sel	: std_logic;
	-- write enables for ram0 and ram1
	signal	ram0_we			: std_logic;
	signal	ram1_we			: std_logic;
	signal	ram0q_r			: std_logic_vector(15 downto 0);
	signal	ram0q_i			: std_logic_vector(15 downto 0);
	signal	ram1q_r			: std_logic_vector(15 downto 0);
	signal	ram1q_i			: std_logic_vector(15 downto 0);
	signal	odmux_sel		: std_logic; 
	signal	odmux_sel0		: std_logic; 
	signal  sclr_a			: std_logic;
	signal  sclr_b			: std_logic;
	signal  n_state_cntr    	: std_logic;
				
component xdsp_ramd16a4
  port (a	: IN STD_LOGIC_VECTOR(4-1 DOWNTO 0);
        d	: IN STD_LOGIC_VECTOR(16-1 DOWNTO 0);
        we	: IN STD_LOGIC;
        clk	: IN STD_LOGIC;
        qspo_ce	: IN STD_LOGIC;
        qspo	: OUT STD_LOGIC_VECTOR(16-1 DOWNTO 0));
end component;

component xdsp_mux2w4
  port( ma 	: IN  std_logic_vector( 4 - 1 DOWNTO 0 );
        mb 	: IN  std_logic_vector( 4 - 1 DOWNTO 0 );
        sel 	: IN  std_logic;
        o  	: OUT std_logic_vector( 4 - 1 DOWNTO 0 ) );
end component;

component xdsp_mux2w16
  port( ma 	: IN  std_logic_vector( 16 - 1 DOWNTO 0 );
        mb 	: IN  std_logic_vector( 16 - 1 DOWNTO 0 );
        sel 	: IN  std_logic;
        o  	: OUT std_logic_vector( 16 - 1 DOWNTO 0 ) );
end component;

component xdsp_cnt5
  port( clk 	: in  std_logic;
        ce 	: in  std_logic;
        sclr 	: IN  std_logic;        
        q 	: out std_logic_vector(4 downto 0));
end component;

component xdsp_reg4
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		sclr		: in std_logic;
		d		: in std_logic_vector(3 downto 0);	-- data in
		q		: out std_logic_vector(3 downto 0)	-- data out
	      );
end component;

attribute RLOC : string;
attribute RLOC of ram0_r : label is "R0C0";
attribute RLOC of ram0_i : label is "R0C1";
attribute RLOC of ram1_r : label is "R0C2";
attribute RLOC of ram1_i : label is "R0C3";
attribute RLOC of odmux_r : label is "R0C2";
attribute RLOC of odmux_i : label is "R0C3";
attribute RLOC of ram0_addr_mux : label is "R3C0";
attribute RLOC of ram1_addr_mux : label is "R3C1";
attribute RLOC of addr_gen : label is "R0C0";
attribute RLOC of reg_addr_a : label is "R5C0";
attribute RLOC of reg_addr_b : label is "R2C1";
--attribute RLOC of ram_we : label is "R4C1";

begin

ram0_r : xdsp_ramd16a4
	port map (
		a		=> reg_addr_ram0,
		d		=> dr,
		we		=> ram0_we,
		clk		=> clk,
		qspo_ce		=> ce,
		qspo		=> ram0q_r
	);
	
ram0_i : xdsp_ramd16a4
	port map (
		a		=> reg_addr_ram0,
		d		=> di,
		we		=> ram0_we,
		clk		=> clk,
		qspo_ce		=> ce,
		qspo		=> ram0q_i
	);
	
ram1_r : xdsp_ramd16a4
	port map (
		a		=> reg_addr_ram1,
		d		=> dr,
		we		=> ram1_we,
		clk		=> clk,
		qspo_ce		=> ce,
		qspo		=> ram1q_r
	);
	
ram1_i : xdsp_ramd16a4
	port map (
		a		=> reg_addr_ram1,
		d		=> di,
		we		=> ram1_we,
		clk		=> clk,
		qspo_ce		=> ce,
		qspo		=> ram1q_i
	);
		
ram0_addr_mux : xdsp_mux2w4
	port map (
		ma		=> addr_a,
		mb		=> addr_b,
		sel		=> ram0_addr_mux_sel,
		o		=> addr_ram0
	);
	
ram1_addr_mux : xdsp_mux2w4
	port map (
		ma		=> addr_a,
		mb		=> addr_b,
		sel		=> ram1_addr_mux_sel,
		o		=> addr_ram1
	);
	
odmux_r : xdsp_mux2w16
	port map (
		ma		=> ram0q_r,
		mb		=> ram1q_r,
		sel		=> odmux_sel,
		o		=> qr
	);
	
odmux_i : xdsp_mux2w16
	port map (
		ma		=> ram0q_i,
		mb		=> ram1q_i,
		sel		=> odmux_sel,
		o		=> qi
	);		 

--addr_gen : process(clk,rs,ce,start)
--begin
--	if rs = '1' or start = '1' then
--		state_cntr <= (others => '0');
--	elsif clk'event and clk = '1' then
--	    if ce = '1' then
--		state_cntr <= state_cntr + 1;	
--	    end if;
--	end if;
--end process;

sclr_a <= rs or start;

addr_gen : xdsp_cnt5
		port map ( 	clk	=> clk,
				q	=> state_cntr,
				ce	=> ce,
				sclr    => sclr_a);
				
--reg_addr : process(clk,rs,ce,start)
--begin
--	if rs = '1' or start = '1' then
--		reg_addr_ram0 <= (others => '0');
--		reg_addr_ram1 <= (others => '0');
--	elsif clk'event and clk = '1' then
--	    if ce = '1' then
--		reg_addr_ram0 <= addr_ram0;
--		reg_addr_ram1 <= addr_ram1;
--	    end if;
--	end if;
--end process;

sclr_b <= rs or start;

reg_addr_a : xdsp_reg4
	port map(
		clk		=> clk,				
		ce		=> ce,				
		d		=> addr_ram0,			
		q		=> reg_addr_ram0, 			
		sclr    	=> sclr_b
	);

reg_addr_b : xdsp_reg4
	port map(
		clk		=> clk,				
		ce		=> ce,				
		d		=> addr_ram1,		
		q		=> reg_addr_ram1,
		sclr    	=> sclr_b 		
	);
		
ram_we : process(clk,rs,ce,start)
begin
	if rs = '1' then
		ram0_we <= '0';
		ram1_we <= '0';
		odmux_sel0 <= '0';
	elsif clk'event and clk = '1' then
	    if ce = '1' then
		ram0_we <= not state_cntr(4);
		ram1_we <= state_cntr(4);
		odmux_sel0 <= state_cntr(4);
		odmux_sel <= not odmux_sel0;
	    end if;
	end if;
end process;

n_state_cntr <= not state_cntr(4);

--ram_we : xdsp_reg4
--	port map(
--		clk	=> clk,				
--		ce	=> ce,				
--		d(0)	=> n_state_cntr,
--		d(1)    => state_cntr(4),
--		d(2)    => state_cntr(4),		--n_state_cntr,
--		d(3)    => n_state_cntr,
--		q(0)	=> ram0_we,
--		q(1)    => ram1_we,
--		q(2)    => odmux_sel0,
--		q(3)    => odmux_sel,
--		sclr    => rs 		
--	);
	
addr_a <= state_cntr(3 downto 0);
ram0_addr_mux_sel <= state_cntr(4);
ram1_addr_mux_sel <= not state_cntr(4);
addr_b <= (state_cntr(1),state_cntr(0),state_cntr(3),state_cntr(2));
	
end struct;

-- Virtex 16-point FFT
-- input double buffer and data re-ordering

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	
entity bitrev_bufr is
	port (
		clk		: in std_logic;				-- system clock
		rs		: in std_logic;				-- reset
		start		: in std_logic;				-- start transform
		ce		: in std_logic;				-- clk enable
		dr		: in std_logic_vector(15 downto 0);
		di		: in std_logic_vector(15 downto 0);
		qr		: out std_logic_vector(15 downto 0);
		qi		: out std_logic_vector(15 downto 0)
	      );
end bitrev_bufr;

architecture struct of bitrev_bufr is
	
	-- definitions for input double buffer
	signal	state_cntr		: std_logic_vector(4 downto 0);
	signal	addr_a			: std_logic_vector(3 downto 0);
	signal	addr_b			: std_logic_vector(3 downto 0);
	signal	addr_ram0		: std_logic_vector(3 downto 0);
	signal	addr_ram1		: std_logic_vector(3 downto 0);
	signal	reg_addr_ram0		: std_logic_vector(3 downto 0);
	signal	reg_addr_ram1		: std_logic_vector(3 downto 0);
	signal	ram0_addr_mux_sel	: std_logic;
	signal	ram1_addr_mux_sel	: std_logic;
	-- write enables for ram0 and ram1
	signal	ram0_we			: std_logic;
	signal	ram1_we			: std_logic;
	signal	ram0q_r			: std_logic_vector(15 downto 0);
	signal	ram0q_i			: std_logic_vector(15 downto 0);
	signal	ram1q_r			: std_logic_vector(15 downto 0);
	signal	ram1q_i			: std_logic_vector(15 downto 0);
	signal	odmux_sel		: std_logic; 
	signal	odmux_sel0		: std_logic; 
	signal  sclr_a			: std_logic;
	signal  sclr_b			: std_logic;
	signal  n_state_cntr    	: std_logic;
				
component xdsp_ramd16a4
  port (a	: IN STD_LOGIC_VECTOR(4-1 DOWNTO 0);
        d	: IN STD_LOGIC_VECTOR(16-1 DOWNTO 0);
        we	: IN STD_LOGIC;
        clk	: IN STD_LOGIC;
        qspo_ce	: IN STD_LOGIC;
        qspo	: OUT STD_LOGIC_VECTOR(16-1 DOWNTO 0));
end component;

component xdsp_mux2w4
  port( ma 	: IN  std_logic_vector( 4 - 1 DOWNTO 0 );
        mb 	: IN  std_logic_vector( 4 - 1 DOWNTO 0 );
        sel 	: IN  std_logic;
        o  	: OUT std_logic_vector( 4 - 1 DOWNTO 0 ) );
end component;

component xdsp_mux2w16
  port( ma 	: IN  std_logic_vector( 16 - 1 DOWNTO 0 );
        mb 	: IN  std_logic_vector( 16 - 1 DOWNTO 0 );
        sel 	: IN  std_logic;
        o  	: OUT std_logic_vector( 16 - 1 DOWNTO 0 ) );
end component;

component xdsp_cnt5
  port( clk 	: in  std_logic;
        ce 	: in  std_logic;
        sclr 	: IN  std_logic;        
        q 	: out std_logic_vector(4 downto 0));
end component;

component xdsp_reg4
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		sclr		: in std_logic;
		d		: in std_logic_vector(3 downto 0);	-- data in
		q		: out std_logic_vector(3 downto 0)	-- data out
	      );
end component;

attribute RLOC : string;
attribute RLOC of ram0_r : label is "R0C0";
attribute RLOC of ram0_i : label is "R0C1";
attribute RLOC of ram1_r : label is "R0C2";
attribute RLOC of ram1_i : label is "R0C3";
attribute RLOC of odmux_r : label is "R0C2";
attribute RLOC of odmux_i : label is "R0C3";
attribute RLOC of ram0_addr_mux : label is "R3C0";
attribute RLOC of ram1_addr_mux : label is "R3C1";
attribute RLOC of addr_gen : label is "R0C0";
attribute RLOC of reg_addr_a : label is "R3C0";
attribute RLOC of reg_addr_b : label is "R3C2";
--attribute RLOC of ram_we : label is "R3C1";

begin

ram0_r : xdsp_ramd16a4
	port map (
		a		=> reg_addr_ram0,
		d		=> dr,
		we		=> ram0_we,
		clk		=> clk,
		qspo_ce		=> ce,
		qspo		=> ram0q_r
	);
	
ram0_i : xdsp_ramd16a4
	port map (
		a		=> reg_addr_ram0,
		d		=> di,
		we		=> ram0_we,
		clk		=> clk,
		qspo_ce		=> ce,
		qspo		=> ram0q_i
	);
	
ram1_r : xdsp_ramd16a4
	port map (
		a		=> reg_addr_ram1,
		d		=> dr,
		we		=> ram1_we,
		clk		=> clk,
		qspo_ce		=> ce,
		qspo		=> ram1q_r
	);
	
ram1_i : xdsp_ramd16a4
	port map (
		a		=> reg_addr_ram1,
		d		=> di,
		we		=> ram1_we,
		clk		=> clk,
		qspo_ce		=> ce,
		qspo		=> ram1q_i
	);
		
ram0_addr_mux : xdsp_mux2w4
	port map (
		ma		=> addr_a,
		mb		=> addr_b,
		sel		=> ram0_addr_mux_sel,
		o		=> addr_ram0
	);
	
ram1_addr_mux : xdsp_mux2w4
	port map (
		ma		=> addr_a,
		mb		=> addr_b,
		sel		=> ram1_addr_mux_sel,
		o		=> addr_ram1
	);
	
odmux_r : xdsp_mux2w16
	port map (
		ma		=> ram0q_r,
		mb		=> ram1q_r,
		sel		=> odmux_sel,
		o		=> qr
	);
	
odmux_i : xdsp_mux2w16
	port map (
		ma		=> ram0q_i,
		mb		=> ram1q_i,
		sel		=> odmux_sel,
		o		=> qi
	);		 

--addr_gen : process(clk,rs,ce,start)
--begin
--	if rs = '1' or start = '1' then
--		state_cntr <= (others => '0');
--	elsif clk'event and clk = '1' then
--	    if ce = '1' then
--		state_cntr <= state_cntr + 1;	
--	    end if;
--	end if;
--end process;

sclr_a <= rs or start;

addr_gen : xdsp_cnt5
		port map ( 	clk	=> clk,
				q	=> state_cntr,
				ce	=> ce,
				sclr    => sclr_a);
				
--reg_addr : process(clk,rs,ce,start)
--begin
--	if rs = '1' or start = '1' then
--		reg_addr_ram0 <= (others => '0');
--		reg_addr_ram1 <= (others => '0');
--	elsif clk'event and clk = '1' then
--	    if ce = '1' then
--		reg_addr_ram0 <= addr_ram0;
--		reg_addr_ram1 <= addr_ram1;
--	    end if;
--	end if;
--end process;

sclr_b <= rs or start;

reg_addr_a : xdsp_reg4
	port map(
		clk		=> clk,				
		ce		=> ce,				
		d		=> addr_ram0,			
		q		=> reg_addr_ram0, 			
		sclr    	=> sclr_b
	);

reg_addr_b : xdsp_reg4
	port map(
		clk		=> clk,				
		ce		=> ce,				
		d		=> addr_ram1,		
		q		=> reg_addr_ram1,
		sclr    	=> sclr_b 		
	);
		
ram_we : process(clk,rs,ce,start)
begin
	if rs = '1' then
		ram0_we <= '0';
		ram1_we <= '0';
		odmux_sel0 <= '0';
	elsif clk'event and clk = '1' then
	    if ce = '1' then
		ram0_we <= not state_cntr(4);
		ram1_we <= state_cntr(4);
		odmux_sel0 <= state_cntr(4);
		odmux_sel <= not odmux_sel0;
	    end if;
	end if;
end process;

n_state_cntr <= not state_cntr(4);

--ram_we : xdsp_reg4
--	port map(
--		clk	=> clk,				
--		ce	=> ce,				
--		d(0)	=> n_state_cntr,
--		d(1)    => state_cntr(4),
--		d(2)    => state_cntr(4),		--n_state_cntr,
--		d(3)    => n_state_cntr,
--		q(0)	=> ram0_we,
--		q(1)    => ram1_we,
--		q(2)    => odmux_sel0,
--		q(3)    => odmux_sel,
--		sclr    => rs 		
--	);
	
addr_a <= state_cntr(3 downto 0);
ram0_addr_mux_sel <= state_cntr(4);
ram1_addr_mux_sel <= not state_cntr(4);
addr_b <= (state_cntr(1),state_cntr(0),state_cntr(3),state_cntr(2));
	
end struct;

-- Virtex FFT
-- control signal generation


library ieee;
	use ieee.std_logic_1164.all;
	--use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;

-- synopsys translate_off
library unisim;
	use unisim.vcomponents.all;
-- synopsys translate_on
	
entity fft_cntrl_16 is
	port(
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		start		: in std_logic;
		done		: in std_logic;
		done_valid	: out std_logic	
	);
end fft_cntrl_16;

architecture virtex_fft_cntrl of fft_cntrl_16 is	

component LUT4
  --  generic (INIT : std_logic_vector);
    port (O : out std_logic;
	      I0 : in std_logic;
		  I1 : in std_logic;
		  I2 : in std_logic;
		  I3 : in std_logic);
end component;				   

component xdsp_cnt4
	port (clk	: in std_logic;		
	      ce	: in std_logic;		   
	      q		: out std_logic_vector(3 downto 0);
	      sclr 	: in std_logic);
end component;	  

signal b      		: std_logic_vector(3 downto 0);
signal cen    		: std_logic;
signal r      		: std_logic;	  
signal logic0 		: std_logic;
signal done_valid_i	: std_logic;


attribute RLOC : string;
--attribute INIT : string;
--attribute RLOC of and1 : label is "R0C0.S0";
--attribute INIT of and1 : label is "8888";
--attribute RLOC of or1 : label is "R0C0.S0";
--attribute INIT of or1 : label is "eeee";
attribute RLOC of counter : label is "R0C0";  
--attribute RLOC of five : label is "R0C0.S1";
--attribute INIT of five : label is "0020";

begin

	logic0 <= '0';
	cen <= ce and done;
	r <= rs or start;

--and1 : 	LUT4
--		port map (i0 => ce,
--				  i1 => done, 
--	  			  i2 => logic0,
--				  i3 => logic0,
--	  			  o => cen);
--or1 : LUT4
--		port map (i0 => rs,
--				  i1 => start, 
--	  			  i2 => logic0,
--				  i3 => logic0,
--	  			  o => r);
							

--five : LUT4
--		port map (i0 => b(0),
--				 i1 => b(1), 
--	  			 i2 => b(2),
--				 i3 => b(3),
--	  			 o => done_valid);


counter : xdsp_cnt4
		port map ( 	clk	=> clk,
				q	=> b,
				ce	=> cen,
				sclr    => r);

--done_valid <= (b(0) and b(2)) and (b(1) nor b(3));

done_valid_proc : process( clk, r )

    variable done_valid_tmp : std_logic;

begin

    done_valid_tmp := (b(0) and b(2)) and (b(1) nor b(3));
    
    if clk'event and clk = '1' then
        if r = '1' then
	     done_valid <= '0';
        elsif ce = '1' and done_valid_tmp = '1' then    
	    done_valid <= '1';
	end if;
    end if;

end process;
	
--rank0_proc : process(clk,ce,rs,start,done)
--	variable cen : std_logic; 
--	variable r   : std_logic;
--begin
--    cen := ce and done;
--    r := rs or start;
--    if clk'event and clk = '1' then
--        if r = '1' then
--            done_valid <= '0';
--            b <= "0000";       
--        elsif cen = '1' then
--            b <= b + 1;
--            if b = x"5" then
--                done_valid <= '1';
--            end if; 
--        end if;
--    end if;
--end process rank0_proc;

end virtex_fft_cntrl;	
