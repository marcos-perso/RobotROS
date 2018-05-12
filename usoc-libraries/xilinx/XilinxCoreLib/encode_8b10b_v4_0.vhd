---------------------------------------------------------------------------
-- $RCSfile: encode_8b10b_v4_0.vhd,v $ $Revision: 1.1 $ $Date: 2010-07-10 21:43:07 $
---------------------------------------------------------------------------
-- 8b/10b Encoder - Behavioral Model
---------------------------------------------------------------------------
--                                                                       


--  Copyright(C) 2003 by Xilinx, Inc. All rights reserved.
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
--  of this text at all times. (c) Copyright 1995-2003 Xilinx, Inc.
--  All rights reserved.

--NOTICE:
-- This byte oriented DC balanced 8b/10b partitioned block
-- transmission code may contain material covered by patents
-- owned by other third parties including International Business
-- Machines Corporation.  By providing this core as one possible
-- implementation of this standard, Xilinx is making no representation
-- that the provided implementation of this standard is free
-- from any claims of infringement by any third party.  Xilinx 
-- expressly disclaims any warranty with respect to the adequacy 
-- of the implementation, including, but not limited to any warranty 
-- or representation that the implementation is free from claims of
-- any third party.  Furthermore, Xilinx is providing this core as
-- a courtesy to you and suggests that you contact all third parties
-- including IBM to obtain the necessary rights to use this implementation.
---------------------------------------------------------------------------
-- Filename:    encode_8b10b_v4_0.vhd
--
-- Description: The behavioral model for the 8b/10b Encoder     
--                      
---------------------------------------------------------------------------





---------------------------------------------------------------------------
-- 8b/10b Encoder - Behavioral Model (single encoder)
---------------------------------------------------------------------------
-- Structure:
--       encode_8b10b_v4_0
--               |
--               +- >>> encode_8b10b_v4_0_base <<<
--
---------------------------------------------------------------------------


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.iputils_conv.bint_2_sl;
USE XilinxCoreLib.iputils_conv.str_to_slv_0;

-------------------------------------------------------------------------------
-- Definition of Generics
-------------------------------------------------------------------------------
--  c_has_ce                            --1 indicates CE port is present
--  c_has_disp_in                       --1 indicates FORCE_DISP and DISPIN
--                                      -- ports are present
--  c_has_force_code                    --1 indicates FORCE_CODE port is
--                                      -- present
--  c_force_code_val                    --String is the encoded symbol for a
--                                      --  specific code point
--  c_force_code_disp                   --Initializes the running disparity of
--                                      -- the encoder if FORCE_CODE input is
--                                      -- active. Must be consistent with
--                                      -- FORCE_CODE_VAL
--  c_has_nd                            --1 indicates the ND port is present
--  c_has_kerr                          --1 indicates KERR port is present
--  c_has_disp_out                      --1 indicates DISPOUT port is present
-------------------------------------------------------------------------------
ENTITY encode_8b10b_v4_0_base IS
  GENERIC (
    c_has_ce          :     integer                      := 1;
    c_has_disp_in     :     integer                      := 1;
    c_has_force_code  :     integer                      := 1;
    c_force_code_val  :     string                       := "1010101010" ;
    c_force_code_disp :     integer                      := 0;
    c_has_nd          :     integer                      := 1;
    c_has_kerr        :     integer                      := 1;
    c_has_disp_out    :     integer                      := 1
    );
  PORT (
    din               : IN  std_logic_vector(7 DOWNTO 0) ;
    kin               : IN  std_logic ;
    clk               : IN  std_logic ;
    ce                : IN  std_logic ;
    force_code        : IN  std_logic ;
    force_disp        : IN  std_logic ;
    disp_in           : IN  std_logic ;
    dout              : OUT std_logic_vector(9 DOWNTO 0) := str_to_slv_0(c_force_code_val, 10);
    disp_out          : OUT std_logic ;
    kerr              : OUT std_logic;
    nd                : OUT std_logic                    := '0'
    );
END encode_8b10b_v4_0_base;


-------------------------------------------------------------------------------
-- Architecture Heading
-------------------------------------------------------------------------------
ARCHITECTURE behavioral OF encode_8b10b_v4_0_base IS


-------------------------------------------------------------------------------
-- Constant Declarations
-------------------------------------------------------------------------------
  CONSTANT D_10_2 : std_logic_vector(9 DOWNTO 0) := "0101010101" ;
  CONSTANT D_21_5 : std_logic_vector(9 DOWNTO 0) := "1010101010" ;
  CONSTANT yes    : std_logic                    := '1' ;
  CONSTANT no     : std_logic                    := '0' ;
  CONSTANT pos    : std_logic                    := '1' ;
  CONSTANT neg    : std_logic                    := '0' ;

-------------------------------------------------------------------------------
-- Signal Declarations
-------------------------------------------------------------------------------
  SIGNAL b6       : std_logic_vector(5 DOWNTO 0) ;
  SIGNAL b4       : std_logic_vector(3 DOWNTO 0) ;
  SIGNAL pdes6    : std_logic ;
  SIGNAL pdes4    : std_logic ;
  SIGNAL k28      : boolean ;
  SIGNAL l13      : std_logic ;
  SIGNAL l31      : std_logic ;
  SIGNAL a7       : std_logic ;
  SIGNAL idisp_in : std_logic ;
  SIGNAL disp_run : std_logic := bint_2_sl(c_force_code_disp) ;
  SIGNAL ce_int   : std_logic ;

  ALIAS a  : std_logic IS din(0) ;
  ALIAS b  : std_logic IS din(1) ;
  ALIAS c  : std_logic IS din(2) ;
  ALIAS d  : std_logic IS din(3) ;
  ALIAS e  : std_logic IS din(4) ;
-- ALIAS f : STD_LOGIC IS din(5) ;
-- ALIAS g : STD_LOGIC IS din(6) ;
-- ALIAS h : STD_LOGIC IS din(7) ;
  ALIAS b5 : std_logic_vector(4 DOWNTO 0) IS din(4 DOWNTO 0) ;
  ALIAS b3 : std_logic_vector(2 DOWNTO 0) IS din(7 DOWNTO 5) ;

---------------------------------------------------------------------------
-- Signals required due to internal signal not matching port name
---------------------------------------------------------------------------
  SIGNAL idisp_out : std_logic ;
  SIGNAL k_invalid : std_logic := '0';


-------------------------------------------------------------------------------
-- Architecture Begin
-------------------------------------------------------------------------------
BEGIN


-------------------------------------------------------------------------------
-- Map internal signals to proper port names
-------------------------------------------------------------------------------
  disp_out  <= idisp_out ;
  kerr      <= k_invalid ;
  idisp_out <= disp_run ;


-------------------------------------------------------------------------------
-- ce_int is '1' if c_has_ce is FALSE
-------------------------------------------------------------------------------
  PROCESS (ce)
  BEGIN
    IF (c_has_ce = 1) THEN
      ce_int <= ce ;
    ELSE
      ce_int <= '1' ;
    END IF ;
  END PROCESS ;


-------------------------------------------------------------------------------
-- Calculate some intermediate terms
-------------------------------------------------------------------------------
  k28 <= ((kin = '1') AND (b5 = "11100")) ;

  l13 <=
    (
      ((a XOR b) AND NOT(c OR d))
      OR
      ((c XOR d) AND NOT(a OR b))
      );

  l31 <=
    (
      ((a XOR b) AND (c AND d))
      OR
      ((c XOR d) AND (a AND b))
      );

  a7 <=
    (
      kin
      OR
      (
        (l31 AND D AND NOT(e) AND idisp_in)
        OR
        (l13 AND NOT(d) AND e AND NOT(idisp_in))
        )
      );

-------------------------------------------------------------------------------
-- Check for invalid K codes
-------------------------------------------------------------------------------
  PROCESS (clk)
  BEGIN
    IF clk'event AND clk = '1' AND ce_int = '1' THEN
      IF ((c_has_force_code = 1) AND (force_code = '1')) THEN
        k_invalid <= no ;
      ELSIF (b5 = "11100") THEN
        k_invalid <= no ;
      ELSIF (b3 /= "111") THEN
        k_invalid <= kin ;
      ELSIF ((b5 /= "10111") AND (b5 /= "11011") AND (b5 /= "11101") AND (b5 /= "11110")) THEN
        k_invalid <= kin ;
      ELSE
        k_invalid <= no ;
      END IF ;
    END IF ;
  END PROCESS;


-------------------------------------------------------------------------------
-- Do the 5B/6B conversion (calculate the 6b symbol)
-------------------------------------------------------------------------------
  PROCESS (b5, k28, idisp_in)
  BEGIN
    IF (k28) THEN                       --K.28

      IF (idisp_in = neg) THEN
        b6 <= "111100" ;
      ELSE
        b6 <= "000011" ;
      END IF;

    ELSE

      CASE b5 IS
        WHEN "00000" =>                   --D.0
          IF (idisp_in = pos)
          THEN b6          <= "000110" ;
          ELSE b6          <= "111001" ;
          END IF ;
        WHEN "00001" =>                   --D.1
          IF (idisp_in = pos)
          THEN b6          <= "010001" ;
          ELSE b6          <= "101110" ;
          END IF ;
        WHEN "00010" =>                   --D.2
          IF (idisp_in = pos)
          THEN b6          <= "010010" ;
          ELSE b6          <= "101101" ;
          END IF ;
        WHEN "00011" => b6 <= "100011" ;  --D.3
        WHEN "00100" =>                   --D.4
          IF (idisp_in = pos)
          THEN b6          <= "010100" ;
          ELSE b6          <= "101011" ;
          END IF ;
        WHEN "00101" => b6 <= "100101" ;  --D.5
        WHEN "00110" => b6 <= "100110" ;  --D.6
        WHEN "00111" =>                   --D.7   
          IF (idisp_in = neg)
          THEN b6          <= "000111" ;
          ELSE b6          <= "111000" ;
          END IF ;
        WHEN "01000" =>                   --D.8
          IF (idisp_in = pos)
          THEN b6          <= "011000" ;
          ELSE b6          <= "100111" ;
          END IF ;
        WHEN "01001" => b6 <= "101001" ;  --D.9
        WHEN "01010" => b6 <= "101010" ;  --D.10
        WHEN "01011" => b6 <= "001011" ;  --D.11
        WHEN "01100" => b6 <= "101100" ;  --D.12
        WHEN "01101" => b6 <= "001101" ;  --D.13
        WHEN "01110" => b6 <= "001110" ;  --D.14
        WHEN "01111" =>                   --D.15
          IF (idisp_in = pos)
          THEN b6          <= "000101" ;
          ELSE b6          <= "111010" ;
          END IF ;

        WHEN "10000" =>                   --D.16
          IF (idisp_in = neg)
          THEN b6          <= "110110" ;
          ELSE b6          <= "001001" ;
          END IF ;
        WHEN "10001" => b6 <= "110001" ;  --D.17
        WHEN "10010" => b6 <= "110010" ;  --D.18
        WHEN "10011" => b6 <= "010011" ;  --D.19
        WHEN "10100" => b6 <= "110100" ;  --D.20
        WHEN "10101" => b6 <= "010101" ;  --D.21
        WHEN "10110" => b6 <= "010110" ;  --D.22
        WHEN "10111" =>                   --D/K.23
          IF (idisp_in = neg)
          THEN b6          <= "010111" ;
          ELSE b6          <= "101000" ;
          END IF ;
        WHEN "11000" =>                   --D.24
          IF (idisp_in = pos)
          THEN b6          <= "001100" ;
          ELSE b6          <= "110011" ;
          END IF ;
        WHEN "11001" => b6 <= "011001" ;  --D.25
        WHEN "11010" => b6 <= "011010" ;  --D.26
        WHEN "11011" =>                   --D/K.27
          IF (idisp_in = neg)
          THEN b6          <= "011011" ;
          ELSE b6          <= "100100" ;
          END IF ;
        WHEN "11100" => b6 <= "011100" ;  --D.28
        WHEN "11101" =>                   --D/K.29
          IF (idisp_in = neg)
          THEN b6          <= "011101" ;
          ELSE b6          <= "100010" ;
          END IF ;
        WHEN "11110" =>                   --D/K.30
          IF (idisp_in = neg)
          THEN b6          <= "011110" ;
          ELSE b6          <= "100001" ;
          END IF ;
        WHEN "11111" =>                   --D.31
          IF (idisp_in = neg)
          THEN b6          <= "110101" ;
          ELSE b6          <= "001010" ;
          END IF ;
        WHEN OTHERS  => b6 <= "UUUUUU";
      END CASE ;

    END IF ;
  END PROCESS ;


-------------------------------------------------------------------------------
-- Calculate the running disparity -after- the 6B symbol
-------------------------------------------------------------------------------
  PROCESS (b5, k28, idisp_in)
  BEGIN
    IF (k28) THEN
      pdes6                   <= NOT(idisp_in) ;
    ELSE
      CASE b5 IS
        WHEN "00000" => pdes6 <= NOT(idisp_in) ;
        WHEN "00001" => pdes6 <= NOT(idisp_in) ;
        WHEN "00010" => pdes6 <= NOT(idisp_in) ;
        WHEN "00011" => pdes6 <= idisp_in ;
        WHEN "00100" => pdes6 <= NOT(idisp_in) ;
        WHEN "00101" => pdes6 <= idisp_in ;
        WHEN "00110" => pdes6 <= idisp_in ;
        WHEN "00111" => pdes6 <= idisp_in ;

        WHEN "01000" => pdes6 <= NOT(idisp_in) ;
        WHEN "01001" => pdes6 <= idisp_in ;
        WHEN "01010" => pdes6 <= idisp_in ;
        WHEN "01011" => pdes6 <= idisp_in ;
        WHEN "01100" => pdes6 <= idisp_in ;
        WHEN "01101" => pdes6 <= idisp_in ;
        WHEN "01110" => pdes6 <= idisp_in ;
        WHEN "01111" => pdes6 <= NOT(idisp_in) ;

        WHEN "10000" => pdes6 <= NOT(idisp_in) ;
        WHEN "10001" => pdes6 <= idisp_in ;
        WHEN "10010" => pdes6 <= idisp_in ;
        WHEN "10011" => pdes6 <= idisp_in ;
        WHEN "10100" => pdes6 <= idisp_in ;
        WHEN "10101" => pdes6 <= idisp_in ;
        WHEN "10110" => pdes6 <= idisp_in ;
        WHEN "10111" => pdes6 <= NOT(idisp_in) ;

        WHEN "11000" => pdes6 <= NOT(idisp_in) ;
        WHEN "11001" => pdes6 <= idisp_in ;
        WHEN "11010" => pdes6 <= idisp_in ;
        WHEN "11011" => pdes6 <= NOT(idisp_in) ;
        WHEN "11100" => pdes6 <= idisp_in ;
        WHEN "11101" => pdes6 <= NOT(idisp_in) ;
        WHEN "11110" => pdes6 <= NOT(idisp_in) ;
        WHEN "11111" => pdes6 <= NOT(idisp_in) ;
        WHEN OTHERS  => pdes6 <= idisp_in;
      END CASE ;
    END IF ;
  END PROCESS ;


-------------------------------------------------------------------------------
-- Do the 3B/4B conversion (calculate the 4b symbol)
-------------------------------------------------------------------------------
  PROCESS (b3, k28, pdes6, a7)
  BEGIN
    CASE b3 IS
      WHEN "000"  =>                    --D/K.x.0
        IF (pdes6 = pos)
        THEN b4         <= "0010" ;
        ELSE b4         <= "1101" ;
        END IF ;
      WHEN "001"  =>                    --D/K.x.1
        IF (k28 AND(pdes6 = neg))
        THEN b4         <= "0110" ;
        ELSE b4         <= "1001" ;
        END IF ;
      WHEN "010"  =>                    --D/K.x.2
        IF (k28 AND(pdes6 = neg))
        THEN b4         <= "0101" ;
        ELSE b4         <= "1010" ;
        END IF ;
      WHEN "011"  =>                    --D/K.x.3
        IF (pdes6 = neg)
        THEN b4         <= "0011" ;
        ELSE b4         <= "1100" ;
        END IF ;
      WHEN "100"  =>                    --D/K.x.4
        IF (pdes6 = pos)
        THEN b4         <= "0100" ;
        ELSE b4         <= "1011" ;
        END IF ;
      WHEN "101"  =>                    --D/K.x.5
        IF (k28 AND(pdes6 = neg))
        THEN b4         <= "1010" ;
        ELSE b4         <= "0101" ;
        END IF ;
      WHEN "110"  =>                    --D/K.x.6
        IF (k28 AND(pdes6 = neg))
        THEN b4         <= "1001" ;
        ELSE b4         <= "0110" ;
        END IF ;
      WHEN "111"  =>                    --D.x.P7
        IF (a7 /= '1') THEN
          IF (pdes6 = neg)
          THEN b4       <= "0111" ;
          ELSE b4       <= "1000" ;
          END IF ;
        ELSE                            --D/K.y.A7
          IF (pdes6 = neg)
          THEN b4       <= "1110" ;
          ELSE b4       <= "0001" ;
          END IF ;
        END IF ;
      WHEN OTHERS => b4 <= "UUUU";
    END CASE ;

  END PROCESS ;


-------------------------------------------------------------------------------
-- Calculate the running disparity -after- the 4B symbol
-------------------------------------------------------------------------------
  PROCESS (b3, pdes6)
  BEGIN
    CASE b3 IS
      WHEN "000"  => pdes4 <= NOT(pdes6) ;
      WHEN "001"  => pdes4 <= pdes6 ;
      WHEN "010"  => pdes4 <= pdes6 ;
      WHEN "011"  => pdes4 <= pdes6 ;
      WHEN "100"  => pdes4 <= NOT(pdes6) ;
      WHEN "101"  => pdes4 <= pdes6 ;
      WHEN "110"  => pdes4 <= pdes6 ;
      WHEN "111"  => pdes4 <= NOT(pdes6) ;
      WHEN OTHERS => pdes4 <= pdes6;
    END CASE ;
  END PROCESS ;


-------------------------------------------------------------------------------
-- Update the running disparity on the clock
-------------------------------------------------------------------------------
  PROCESS (clk)
  BEGIN
    IF clk'event AND clk = '1' AND ce_int = '1'THEN
      IF ((c_has_force_code = 1) AND (force_code = '1')) THEN
        IF ((c_force_code_disp = 1)) THEN
          disp_run <= '1' ;
        ELSE
          disp_run <= '0' ;
        END IF ;
      ELSE
        disp_run   <= pdes4 ;
      END IF ;

    END IF ;
  END PROCESS;

-------------------------------------------------------------------------------
-- Override the input disparity if required
-------------------------------------------------------------------------------
  PROCESS (force_disp, disp_in, disp_run)
  BEGIN
    IF ((c_has_disp_in = 1) AND (force_disp = '1')) THEN
      idisp_in <= disp_in ;
    ELSE
      idisp_in <= disp_run ;
    END IF ;
  END PROCESS ;

-------------------------------------------------------------------------------
-- Update the outputs on the clock
-------------------------------------------------------------------------------
  PROCESS (clk)
  BEGIN
    IF clk'event AND clk = '1' THEN
      IF ((c_has_force_code = 1) AND (force_code = '1')) THEN
        -- dout <= D_10_2 ;
        dout <= str_to_slv_0(c_force_code_val, 10) ;
      ELSIF (ce_int = '1') THEN
        dout <= (b4 & b6) ;
      END IF ;
    END IF ;
  END PROCESS ;

-------------------------------------------------------------------------------
-- Update the ND output
------------------------------------------------------------------------------
  PROCESS (clk)
  BEGIN
    IF clk'event AND clk = '1' THEN
      IF (c_has_nd = 1) THEN
        IF (c_has_force_code = 1) AND (force_code = '1') THEN
          nd <= '0';
        ELSE
          nd <= ce_int;
        END IF;
      END IF;

    END IF ;
  END PROCESS ;

END behavioral ;










---------------------------------------------------------------------------
-- Structure:
--   >>> encode_8b10b_v4_0.vhd <<<
--               |
--               +- encode_8b10b_v4_0_base.vhd
--
---------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.encode_8b10b_v4_0_base;


-------------------------------------------------------------------------------
-- Definition of Generics
-------------------------------------------------------------------------------
--    c_enable_rlocs                    -- Enable relative placement
--    c_encode_type                     -- 0 slice, 1 blockRAM, 2 LUTRAM
--    c_has_ce                          -- 1 if CE port present
--    c_has_ce_b                        -- 1 if CE_B port present
--    c_has_bports                      -- 1 if second encoder
--    c_has_disp_in                     -- 1 if FORCE_DISP port present
--    c_has_disp_in_b                   -- 1 if FORCE_DISP_B port present
--    c_has_force_code                  -- 1 if FORCE_CODE port present
--    c_has_force_code_b                -- 1 if FORCE_CODE_B port present
--    c_force_code_val                  -- Force code value (10 bits)
--    c_force_code_val_b                -- Force code Value B (10 bits)
--    c_force_code_disp                 -- force code disparity
--    c_force_code_disp_b               -- Force code disparity B
--    c_has_nd                          -- 1 if ND port present
--    c_has_nd_b                        -- 1 if nd_b port present
--    c_has_kerr                        -- 1 if KERR port present
--    c_has_kerr_b                      -- 1 if KERR_B port present
--    c_has_disp_out                    -- 1 if DISPOUT port present
--    c_has_disp_out_b                  -- 1 if DISPOUT_B port present
-------------------------------------------------------------------------------

ENTITY encode_8b10b_v4_0 IS
  GENERIC (
    c_enable_rlocs      :     integer                      := 1;
    c_encode_type       :     integer                      := 0;
    c_has_ce            :     integer                      := 1;
    c_has_ce_b          :     integer                      := 0;
    c_has_bports        :     integer                      := 0;
    c_has_disp_in       :     integer                      := 1;
    c_has_disp_in_b     :     integer                      := 0;
    c_has_force_code    :     integer                      := 1;
    c_has_force_code_b  :     integer                      := 0;
    c_force_code_val    :     string                       := "0101010101";
    c_force_code_val_b  :     string                       := "0101010101";
    c_force_code_disp   :     integer                      := 0;
    c_force_code_disp_b :     integer                      := 0;
    c_has_nd            :     integer                      := 1;
    c_has_nd_b          :     integer                      := 0;
    c_has_kerr          :     integer                      := 1;
    c_has_kerr_b        :     integer                      := 0;
    c_has_disp_out      :     integer                      := 1;
    c_has_disp_out_b    :     integer                      := 0
    );
  PORT (
    din                 : IN  std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
    kin                 : IN  std_logic                    := '0';
    clk                 : IN  std_logic                    := '0';
    ce                  : IN  std_logic                    := '0';
    force_code          : IN  std_logic                    := '0';
    force_disp          : IN  std_logic                    := '0';
    disp_in             : IN  std_logic                    := '0';
    dout                : OUT std_logic_vector(9 DOWNTO 0);
    disp_out            : OUT std_logic;
    kerr                : OUT std_logic;
    nd                  : OUT std_logic;

    din_b        : IN  std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
    kin_b        : IN  std_logic                    := '0';
    clk_b        : IN  std_logic                    := '0';
    ce_b         : IN  std_logic                    := '0';
    force_code_b : IN  std_logic                    := '0';
    force_disp_b : IN  std_logic                    := '0';
    disp_in_b    : IN  std_logic                    := '0';
    dout_b       : OUT std_logic_vector(9 DOWNTO 0);
    disp_out_b   : OUT std_logic;
    kerr_b       : OUT std_logic;
    nd_b         : OUT std_logic
    );
END encode_8b10b_v4_0;


-------------------------------------------------------------------------------
-- Architecture Heading
-------------------------------------------------------------------------------
ARCHITECTURE behavioral OF encode_8b10b_v4_0 IS


-------------------------------------------------------------------------------
-- Component Declarations
-------------------------------------------------------------------------------
  COMPONENT encode_8b10b_v4_0_base
    GENERIC (
      c_has_ce          :     integer;
      c_has_disp_in     :     integer;
      c_has_force_code  :     integer;
      c_force_code_val  :     string;
      c_force_code_disp :     integer;
      c_has_nd          :     integer;
      c_has_kerr        :     integer;
      c_has_disp_out    :     integer
      );
    PORT (
      din               : IN  std_logic_vector(7 DOWNTO 0);
      kin               : IN  std_logic;
      clk               : IN  std_logic;
      ce                : IN  std_logic;
      force_code        : IN  std_logic;
      force_disp        : IN  std_logic;
      disp_in           : IN  std_logic;
      dout              : OUT std_logic_vector(9 DOWNTO 0);
      disp_out          : OUT std_logic;
      kerr              : OUT std_logic;
      nd                : OUT std_logic
      );
  END COMPONENT;



-------------------------------------------------------------------------------
-- Begin Architecture
-------------------------------------------------------------------------------
BEGIN


-------------------------------------------------------------------------------
-- Instantiate "A" Encoder
-------------------------------------------------------------------------------
  first_encoder : encode_8b10b_v4_0_base
    GENERIC MAP (
      c_has_ce          => c_has_ce,
      c_has_disp_in     => c_has_disp_in,
      c_has_force_code  => c_has_force_code,
      c_force_code_val  => c_force_code_val,
      c_force_code_disp => c_force_code_disp,
      c_has_nd          => c_has_nd,
      c_has_kerr        => c_has_kerr,
      c_has_disp_out    => c_has_disp_out
      )
    PORT MAP (
      din               => din,
      kin               => kin,
      force_disp        => force_disp,
      force_code        => force_code,
      disp_in           => disp_in,
      ce                => ce,
      clk               => clk,
      dout              => dout,
      kerr              => kerr,
      disp_out          => disp_out,
      nd                => nd
      );

-------------------------------------------------------------------------------
-- Instantiate "B" Encoder (if present)
-------------------------------------------------------------------------------
  make_second_encoder : IF (C_HAS_BPORTS = 1) GENERATE

    second_encoder : encode_8b10b_v4_0_base
      GENERIC MAP (
        c_has_ce          => c_has_ce_b,
        c_has_disp_in     => c_has_disp_in_b,
        c_has_force_code  => c_has_force_code_b,
        c_force_code_val  => c_force_code_val_b,
        c_force_code_disp => c_force_code_disp_b,
        c_has_nd          => c_has_nd_b,
        c_has_kerr        => c_has_kerr_b,
        c_has_disp_out    => c_has_disp_out_b
        )
      PORT MAP (
        din               => din_b,
        kin               => kin_b,
        force_disp        => force_disp_b,
        force_code        => force_code_b,
        disp_in           => disp_in_b,
        ce                => ce_b,
        clk               => clk_b,
        dout              => dout_b,
        kerr              => kerr_b,
        disp_out          => disp_out_b,
        nd                => nd_b
        );

  END GENERATE make_second_encoder;



END behavioral;

