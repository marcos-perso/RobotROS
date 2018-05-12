---------------------------------------------------------------------------
-- $RCSfile: decode_8b10b_v7_0.vhd,v $
---------------------------------------------------------------------------
-- 8b/10b Decoder - Behavioral Model
---------------------------------------------------------------------------
--                                                                       --


--  Copyright(C) 2004 by Xilinx, Inc. All rights reserved.
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
--  of this text at all times. (c) Copyright 1995-2004 Xilinx, Inc.
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
-- Filename:    decode_8b10b_v7_0.vhd
--
-- Description: The behavioral model for the 8b/10b Decoder     
--                      
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- 8b/10b Decoder - Behavioral Model (single decoder)
---------------------------------------------------------------------------
-- Structure:
--
--   decode_8b10b_v7_0
--           |
--           +-  >> decode_8b10b_v7_0_base <<
--
---------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- Package containing functions used in the Decoder Behavioral Model
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;


-------------------------------------------------------------------------------
-- Package/function declarations
-------------------------------------------------------------------------------
PACKAGE decode_8b10b_v7_0_pkg IS

  CONSTANT const_zero : std_logic_vector(1 DOWNTO 0) := "10";
  CONSTANT const_err : std_logic_vector(1 DOWNTO 0) := "11";
  CONSTANT const_neg : std_logic_vector(1 DOWNTO 0) := "00";
  CONSTANT const_pos : std_logic_vector(1 DOWNTO 0) := "01";
  FUNCTION calc_sym_disp (sinit_run_disp : integer) RETURN std_logic_vector;
  FUNCTION calc_run_disp_init_val (sinit_run_disp : integer) RETURN std_logic;

END decode_8b10b_v7_0_pkg;

-------------------------------------------------------------------------------
-- Package Body and code for functions
-------------------------------------------------------------------------------
PACKAGE BODY decode_8b10b_v7_0_pkg IS
  

  ----Calculate the symbol disparity (std_logic_vector) for sinit values-------
  FUNCTION calc_sym_disp (sinit_run_disp : integer) RETURN std_logic_vector IS
  VARIABLE tmp_sym_disp : std_logic_vector(1 DOWNTO 0);
  BEGIN
    IF (sinit_run_disp = 1) THEN
      tmp_sym_disp := const_pos;         -- D0.0+ has sym_disp of pos 
    ELSE
      tmp_sym_disp := const_neg;         -- D0.0- has sym_disp of neg
    END IF;
    RETURN tmp_sym_disp;
  END calc_sym_disp;

  ----Calculate the internal running disparity for sinit case----------------
  FUNCTION calc_run_disp_init_val (sinit_run_disp : integer) RETURN std_logic IS
  VARIABLE tmp_run_disp_init_val : std_logic;
  BEGIN
    IF (sinit_run_disp = 1) THEN
      tmp_run_disp_init_val := '1';
    ELSE                           
      tmp_run_disp_init_val := '0';
    END IF;
    RETURN tmp_run_disp_init_val;
  END calc_run_disp_init_val;
  

END decode_8b10b_v7_0_pkg;
----End Package------------------------------------------------------------



-------------------------------------------------------------------------------
-- Start Behavioral Code
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.decode_8b10b_v7_0_pkg.ALL;
USE XilinxCoreLib.iputils_conv.bint_2_sl;
USE XilinxCoreLib.iputils_conv.str_to_slv_0;
-- LIBRARY work;
-- USE work.decode_8b10b_v7_0_pkg.ALL;
-- USE work.iputils_conv.bint_2_sl;
-- USE work.iputils_conv.str_to_slv_0;



-------------------------------------------------------------------------------
-- Entity declaration for single-port base decoder
-------------------------------------------------------------------------------
ENTITY decode_8b10b_v7_0_base IS
  GENERIC (
    -------------------------------------------------------------------------
    -- Generic Parameters
    --  c_has_ce           : 1 indicates ce port is present
    --  c_has_code_err     : 1 indicates code_err port is present
    --  c_has_disp_err     : 1 indicates disp_err port is present
    --  c_has_disp_in      : 1 indicates disp_in port is present
    --  c_has_nd           : 1 indicates nd port is present
    --  c_has_run_disp     : 1 indicates run_disp port is present
    --  c_has_sinit        : 1 indicates sinit port is present
    --  c_has_sym_disp     : 1 indicates sym_disp port is present
    --  c_sinit_dout       : 8-bit binary string, dout value when sinit is active
    --  c_sinit_kout       : controls kout output when sinit is active
    --  c_sinit_run_disp   : Initializes run_disp value to positive(1) or negative(0)
    -------------------------------------------------------------------------
    c_has_ce         :     integer := 0;
    c_has_code_err   :     integer := 1;
    c_has_disp_err   :     integer := 1;
    c_has_disp_in     :     integer := 0;
    c_has_nd         :     integer := 1;
    c_has_run_disp   :     integer := 0;
    c_has_sinit      :     integer := 0;
    c_has_sym_disp   :     integer := 0;
    c_sinit_dout     :     string  := "00000000";
    c_sinit_kout     :     integer := 0;
    c_sinit_run_disp :     integer := 0
    );
  PORT (
    -------------------------------------------------------------------------
    -- Mandatory Pins
    --  clk  : Clock Input
    --  din  : Encoded Symbol Input
    --  dout : Data Output, decoded data byte
    --  kout : Command Output
    -------------------------------------------------------------------------
    clk              : IN  std_logic;
    din              : IN  std_logic_vector(9 DOWNTO 0);
    dout             : OUT std_logic_vector(7 DOWNTO 0) := str_to_slv_0(c_sinit_dout,8);
    kout             : OUT std_logic := bint_2_sl(c_sinit_kout);

    -------------------------------------------------------------------------
    -- Optional Pins
    --  ce         : Clock Enable
    --  disp_in    : Disparity Input (running disparity in)
    --  sinit      : Synchronous Initialization. Resets core to known state.
    --  code_err   : Code Err_or, indicates that input symbol did not correspond
    --                to a valid member of the code set.
    --  disp_err   : Disparity Err_or
    --  nd         : New Data
    --  run_disp   : Running Disparity
    --  sym_disp   : Symbol Disparity
    -------------------------------------------------------------------------
    ce               : IN  std_logic;
    disp_in          : IN  std_logic;
    sinit            : IN  std_logic;
    code_err         : OUT std_logic := '0';
    disp_err         : OUT std_logic;
    nd               : OUT std_logic := '0';
    run_disp         : OUT std_logic := calc_run_disp_init_val(c_sinit_run_disp);
    sym_disp         : OUT std_logic_vector(1 DOWNTO 0)
    );
END decode_8b10b_v7_0_base;




-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------
ARCHITECTURE behavioral OF decode_8b10b_v7_0_base IS

  -----------------------------------------------------------------------------
  -- Type Declarations
  -----------------------------------------------------------------------------
  TYPE disparity IS (neg, pos, zero, invalid, specneg, specpos) ;

  -----------------------------------------------------------------------------
  -- Constant Declarations
  -----------------------------------------------------------------------------
  CONSTANT yes       : std_logic                    := '1' ;
  CONSTANT no        : std_logic                    := '0' ;
  CONSTANT defaultb5 : std_logic_vector(4 DOWNTO 0) := "11111" ;
  CONSTANT defaultb3 : std_logic_vector(2 DOWNTO 0) := "111" ;

  -----------------------------------------------------------------------------
  -- Signal Declarations
  -----------------------------------------------------------------------------
  SIGNAL sym_disp_int: std_logic_vector(1 DOWNTO 0) := calc_sym_disp(c_sinit_run_disp);
  SIGNAL ce_int     : std_logic := '1' ;
  SIGNAL b6_disp    : disparity ;
  SIGNAL b6_disp_q  : disparity ;
  SIGNAL b4_disp    : disparity ;
  SIGNAL disp_out   : disparity ;
  SIGNAL disp_last  : std_logic := calc_run_disp_init_val(c_sinit_run_disp);

  SIGNAL b6_err     : boolean ;
  SIGNAL b4_err     : boolean ;
  SIGNAL sym_err    : boolean ;

  SIGNAL b5  : std_logic_vector(4 DOWNTO 0) ;
  SIGNAL b3  : std_logic_vector(7 DOWNTO 5) ;
  SIGNAL k   : std_logic ;
  SIGNAL k28 : std_logic ;

  ALIAS b6   : std_logic_vector(5 DOWNTO 0) IS din(5 DOWNTO 0) ; --iedcba
  ALIAS b4   : std_logic_vector(3 DOWNTO 0) IS din(9 DOWNTO 6) ; --jhgf
  ALIAS a    : STD_LOGIC IS din(0) ;
  ALIAS b    : STD_LOGIC IS din(1) ;
  ALIAS c    : std_logic IS din(2) ;
  ALIAS d    : std_logic IS din(3) ;
  ALIAS e    : std_logic IS din(4) ;
  ALIAS i    : std_logic IS din(5) ;
  ALIAS f    : STD_LOGIC IS din(6) ;
  ALIAS g    : std_logic IS din(7) ;
  ALIAS h    : std_logic IS din(8) ;
  ALIAS j    : std_logic IS din(9) ;

--Signals for calculating code_error
SIGNAL P04 : std_logic := '0';
SIGNAL P13 : std_logic := '0';
SIGNAL P22 : std_logic := '0';
SIGNAL P31 : std_logic := '0';
SIGNAL P40 : std_logic := '0';
SIGNAL fghj : std_logic := '0';
SIGNAL eifgh : std_logic := '0';
SIGNAL sK28 : std_logic := '0';
SIGNAL e_i : std_logic := '0';
SIGNAL ighj : std_logic := '0';
SIGNAL i_ghj : std_logic := '0';
SIGNAL Kx7 : std_logic := '0';
SIGNAL INVR6 : std_logic := '0';
SIGNAL PDBR6 : std_logic := '0';
SIGNAL NDBR6 : std_logic := '0';
SIGNAL PDUR6 : std_logic := '0';
SIGNAL PDBR4 : std_logic := '0';
SIGNAL NDRR4 : std_logic := '0';
SIGNAL NDUR6 : std_logic := '0';
SIGNAL PDRR6 : std_logic := '0';
SIGNAL NDBR4 : std_logic := '0'; 
SIGNAL PDRR4 : std_logic := '0'; 
SIGNAL fgh : std_logic := '0';
SIGNAL invby_a : std_logic := '0';
SIGNAL invby_b : std_logic := '0';
SIGNAL invby_c : std_logic := '0';
SIGNAL invby_d : std_logic := '0';
SIGNAL invby_e : std_logic := '0';
SIGNAL invby_f : std_logic := '0';
SIGNAL invby_g : std_logic := '0';
SIGNAL invby_h : std_logic := '0';

SIGNAL code_err_i : std_logic := '0'; 


--Signals for calculating spec_err
SIGNAL mid_disp : std_logic;

SIGNAL spec_err_a : std_logic;
SIGNAL spec_err_b : std_logic;
SIGNAL spec_err_c : std_logic;
SIGNAL spec_err_d : std_logic;
SIGNAL spec_err_e : std_logic;
SIGNAL spec_err_f : std_logic;
SIGNAL spec_err_g : std_logic;
SIGNAL spec_err_h : std_logic;
SIGNAL spec_err_i : std_logic;
SIGNAL spec_err_j : std_logic;
SIGNAL spec_err_k : std_logic;
SIGNAL spec_err_l : std_logic;
SIGNAL spec_err_m : std_logic;
SIGNAL spec_err_n : std_logic;
SIGNAL spec_err_o : std_logic;
SIGNAL spec_err_p : std_logic;
SIGNAL spec_err_q : std_logic;
SIGNAL spec_err_r : std_logic;
SIGNAL spec_err_dl : std_logic;
SIGNAL spec_err_dl_q : std_logic;
SIGNAL spec_err_ndl : std_logic;
SIGNAL spec_err_ndl_q : std_logic;
SIGNAL spec_err_md : std_logic;
SIGNAL spec_err_md_q : std_logic;
SIGNAL spec_err_nmd : std_logic;
SIGNAL spec_err_nmd_q : std_logic;

SIGNAL spec_err : std_logic;


signal SYMRD : std_logic_vector(3 downto 0);
signal SYMRD_Q : std_logic_vector(3 downto 0);
signal new_run_disp : std_logic := calc_run_disp_init_val(c_sinit_run_disp);
signal new_disp_err : std_logic;
signal D_SYMRD : string (1 to 5);

  
-------------------------------------------------------------------------------
-- Begin Architecture
-------------------------------------------------------------------------------
BEGIN

  -----------------------------------------------------------------------------
  -- Conditionally Tie Optional ports to internal signals
  -----------------------------------------------------------------------------

  ----Internal Clock Enable----------------------------------------------------
  ce0 : IF (c_has_ce /= 1) GENERATE
    ce_int <= '1' ;
  END GENERATE ce0 ;

  ce1 : IF (c_has_ce = 1) GENERATE
    ce_int <= ce ;
  END GENERATE ce1 ;

  ----Symbol Disparity---------------------------------------------------------
--  sym_disp1 : IF (c_has_sym_disp = 1) GENERATE
--    sym_disp <= sym_disp_int;
--  END GENERATE sym_disp1;

  ----New Data-----------------------------------------------------------------
  nd1 : IF (c_has_nd = 1) GENERATE
    
        ----Update the New Data output-------------------------------
        PROCESS (clk)
        BEGIN
          IF (clk'event AND clk = '1') THEN
            IF ((ce_int = '1') AND (c_has_sinit = 1) AND (SINIT = '1')) THEN
              nd <= '0' ;
            ELSE
              nd <= ce_int ;
            END IF ;
          END IF ;
        END PROCESS ;

  END GENERATE nd1 ;


  ----Code Error---------------------------------------------------------------
  code_err1 : IF (c_has_code_err = 1) GENERATE
    
        ----Update code_err output-------------------
        PROCESS (clk)
        BEGIN
          IF (clk'event AND clk = '1' AND ce_int = '1') THEN
            IF ((c_has_sinit = 1) AND (SINIT = '1')) THEN
              code_err <= '0';
            ELSE
              code_err <= code_err_i;
          END IF ;
	END IF ;
        END PROCESS ;
  
  END GENERATE code_err1 ;

  ----Running Disparity--------------------------------------------------------
--  run_disp_int1 : IF (c_has_run_disp = 1) GENERATE
--    PROCESS (sym_disp_int, disp_last)
--    BEGIN
--      IF (sym_disp_int(1) = '0') THEN
--        run_disp <= sym_disp_int(0) ;
--      ELSE
--        run_disp <= disp_last ;
--      END IF ;
--    END PROCESS ;
--  END GENERATE run_disp_int1 ;

  ----Disparity Error----------------------------------------------------------
--  disp_err1 : IF (c_has_disp_err = 1) GENERATE
--    PROCESS (sym_disp_int, disp_last, spec_err)
--    BEGIN
--        -- If the symbol disparity is positive or negative
--        --  (running disparity MUST change)
--	IF (sym_disp_int(1) = '0') THEN			  
--
--                -- If running disparity has NOT changed, throw a DISP error
--                IF (sym_disp_int(0) = disp_last) THEN
--			disp_err <= '1' ;
--		ELSE
--			disp_err <= '0' ;
--		END IF ;
--                
--        -- ELSE if the symbol disparity is ZERO or ERROR
--	ELSE
--
--                --If there are any special disparity errors, catch them
--                IF spec_err = '1' THEN
--                  disp_err <= '1';
--                --Otherwise, look at the LSB of sym_disp_int to determine
--                --whether this is a valid code or not
--                ELSE
--                  disp_err <= sym_disp_int(0);
--                END IF;
--
--	END IF ;
--    END PROCESS ;
--  END GENERATE disp_err1 ;

  ----Disp_Last (the internal running disparity, not externally visible)------
  disp_last1: IF ((c_has_run_disp = 1) OR (c_has_disp_err = 1)) GENERATE
	PROCESS (clk)
	BEGIN
	IF clk'event AND clk = '1' THEN
            IF ((c_has_sinit = 1) AND (SINIT = '1')) THEN
                disp_last <= calc_run_disp_init_val(c_sinit_run_disp);
                
            ELSIF (ce_int = '1') THEN   --NOTE: sinit works regardless of state
                                        --of ce. (C_SYNC_PRIORITY=0 in
                                        --structural code)
		IF (c_has_disp_in = 1) THEN
			disp_last <= disp_in ;
		ELSIF (sym_disp_int(1) = '0') THEN
			disp_last <= sym_disp_int(0) ;
		ELSE
			disp_last <= disp_last ;
		END IF ;
            --ELSE                      -- implied
            --  disp_last <= disp_last;
	    END IF ;
	END IF ;			
	END PROCESS ;
  END GENERATE disp_last1;

-------------------------------------------------------------------------------
-- Set the value of k28 signal
-------------------------------------------------------------------------------
        k28 <= NOT((c OR d OR e OR i) OR NOT(h XOR j)) ;

-------------------------------------------------------------------------------
-- Do the 6B/5B conversion
-------------------------------------------------------------------------------
        PROCESS (b6) --iedcba
        BEGIN
          CASE b6 IS
            WHEN "000110" => b5 <= "00000" ;  --D.0
            WHEN "111001" => b5 <= "00000" ;  --D.0
            WHEN "010001" => b5 <= "00001" ;  --D.1
            WHEN "101110" => b5 <= "00001" ;  --D.1
            WHEN "010010" => b5 <= "00010" ;  --D.2
            WHEN "101101" => b5 <= "00010" ;  --D.2
            WHEN "100011" => b5 <= "00011" ;  --D.3
            WHEN "010100" => b5 <= "00100" ;  --D.4
            WHEN "101011" => b5 <= "00100" ;  --D.4
            WHEN "100101" => b5 <= "00101" ;  --D.5
            WHEN "100110" => b5 <= "00110" ;  --D.6
            WHEN "000111" => b5 <= "00111" ;  --D.7
            WHEN "111000" => b5 <= "00111" ;  --D.7
            WHEN "011000" => b5 <= "01000" ;  --D.8
            WHEN "100111" => b5 <= "01000" ;  --D.8
            WHEN "101001" => b5 <= "01001" ;  --D.9
            WHEN "101010" => b5 <= "01010" ;  --D.10
            WHEN "001011" => b5 <= "01011" ;  --D.11
            WHEN "101100" => b5 <= "01100" ;  --D.12
            WHEN "001101" => b5 <= "01101" ;  --D.13
            WHEN "001110" => b5 <= "01110" ;  --D.14
            WHEN "000101" => b5 <= "01111" ;  --D.15
            WHEN "111010" => b5 <= "01111" ;  --D.15

            WHEN "110110" => b5 <= "10000" ;    --D.16
            WHEN "001001" => b5 <= "10000" ;    --D.16
            WHEN "110001" => b5 <= "10001" ;    --D.17
            WHEN "110010" => b5 <= "10010" ;    --D.18
            WHEN "010011" => b5 <= "10011" ;    --D.19
            WHEN "110100" => b5 <= "10100" ;    --D.20
            WHEN "010101" => b5 <= "10101" ;    --D.21
            WHEN "010110" => b5 <= "10110" ;    --D.22
            WHEN "010111" => b5 <= "10111" ;    --D/K.23
            WHEN "101000" => b5 <= "10111" ;    --D/K.23
            WHEN "001100" => b5 <= "11000" ;    --D.24
            WHEN "110011" => b5 <= "11000" ;    --D.24
            WHEN "011001" => b5 <= "11001" ;    --D.25
            WHEN "011010" => b5 <= "11010" ;    --D.26
            WHEN "011011" => b5 <= "11011" ;    --D/K.27
            WHEN "100100" => b5 <= "11011" ;    --D/K.27
            WHEN "011100" => b5 <= "11100" ;    --D.28
            WHEN "111100" => b5 <= "11100" ;    --K.28
            WHEN "000011" => b5 <= "11100" ;    --K.28
            WHEN "011101" => b5 <= "11101" ;    --D/K.29
            WHEN "100010" => b5 <= "11101" ;    --D/K.29
            WHEN "011110" => b5 <= "11110" ;    --D.30
            WHEN "100001" => b5 <= "11110" ;    --D.30
            WHEN "110101" => b5 <= "11111" ;    --D.31
            WHEN "001010" => b5 <= "11111" ;    --D.31
            WHEN OTHERS   => b5 <= defaultb5 ;  --CODE VIOLATION!
          END CASE ;
        END PROCESS ;

-------------------------------------------------------------------------------
-- Disparity for the 6B block
-------------------------------------------------------------------------------
        PROCESS (b6)	--iedcba
        BEGIN
          CASE b6 IS
            WHEN "000000" => b6_disp <= neg ;   --invalid ;
                             b6_err  <= true ;
            WHEN "000001" => b6_disp <= neg ;   --invalid ;
                             b6_err  <= true ;
            WHEN "000010" => b6_disp <= neg ;   --invalid ;
                             b6_err  <= true ;
            WHEN "000011" => b6_disp <= neg ;   --K.28
                             b6_err  <= false ;
            WHEN "000100" => b6_disp <= neg ;   --invalid ;
                             b6_err  <= true ;
            WHEN "000101" => b6_disp <= neg ;   --D.15
                             b6_err  <= false ;
            WHEN "000110" => b6_disp <= neg ;   --D.0
                             b6_err  <= false; --CHANGED FROM true DUE TO CR 130235;
            WHEN "000111" => b6_disp <= specneg; --james, cisco 6/10/04    zero ;  --D.7
                             b6_err  <= false ;
            WHEN "001000" => b6_disp <= neg ;   --invalid ;
                             b6_err  <= true ;
            WHEN "001001" => b6_disp <= neg ;   --D.16
                             b6_err  <= false ;
            WHEN "001010" => b6_disp <= neg ;   --D.31
                             b6_err  <= false ;
            WHEN "001011" => b6_disp <= zero ;  --D.11
                             b6_err  <= false ;
            WHEN "001100" => b6_disp <= neg ;   --D.24
                             b6_err  <= false ;
            WHEN "001101" => b6_disp <= zero ;  --D.13
                             b6_err  <= false ;
            WHEN "001110" => b6_disp <= zero ;  --D.14
                             b6_err  <= false ;
            WHEN "001111" => b6_disp <= pos ;   --invlaid ;
                             b6_err  <= true ;

            WHEN "010000" => b6_disp <= neg ;   --invalid ;
                             b6_err  <= true ;
            WHEN "010001" => b6_disp <= neg ;   --D.1
                             b6_err  <= false ;
            WHEN "010010" => b6_disp <= neg ;   --D.2
                             b6_err  <= false ;
            WHEN "010011" => b6_disp <= zero ;  --D.19
                             b6_err  <= false ;
            WHEN "010100" => b6_disp <= neg ;   --D.4
                             b6_err  <= false ;
            WHEN "010101" => b6_disp <= zero ;  --D.21
                             b6_err  <= false ;
            WHEN "010110" => b6_disp <= zero ;  --D.22
                             b6_err  <= false ;
            WHEN "010111" => b6_disp <= pos ;   --D.23
                             b6_err  <= false ;
            WHEN "011000" => b6_disp <= neg ;   --D.8
                             b6_err  <= false ;
            WHEN "011001" => b6_disp <= zero ;  --D.25
                             b6_err  <= false ;
            WHEN "011010" => b6_disp <= zero ;  --D.26
                             b6_err  <= false ;
            WHEN "011011" => b6_disp <= pos ;   --D.27
                             b6_err  <= false ;
            WHEN "011100" => b6_disp <= zero ;  --D.28
                             b6_err  <= false ;
            WHEN "011101" => b6_disp <= pos ;   --D.29
                             b6_err  <= false ;
            WHEN "011110" => b6_disp <= pos ;   --D.30
                             b6_err  <= false ;
            WHEN "011111" => b6_disp <= pos ;   --invalid ;
                             b6_err  <= true ;

            WHEN "100000" => b6_disp <= neg ;   --invalid ;
                             b6_err  <= true ;
            WHEN "100001" => b6_disp <= neg ;   --D.30 ;
                             b6_err  <= false ;
            WHEN "100010" => b6_disp <= neg ;   --D.29 ;
                             b6_err  <= false ;
            WHEN "100011" => b6_disp <= zero ;  --D.3
                             b6_err  <= false ;
            WHEN "100100" => b6_disp <= neg ;   --D.27
                             b6_err  <= false ;
            WHEN "100101" => b6_disp <= zero ;  --D.5
                             b6_err  <= false ;
            WHEN "100110" => b6_disp <= zero ;  --D.6
                             b6_err  <= false ;
            WHEN "100111" => b6_disp <= pos ;   --D.8
                             b6_err  <= false; --CHANGED FROM true DUE TO CR 130235;
            WHEN "101000" => b6_disp <= neg ;   --D.23
                             b6_err  <= false ;
            WHEN "101001" => b6_disp <= zero ;  --D.9
                             b6_err  <= false ;
            WHEN "101010" => b6_disp <= zero ;  --D.10
                             b6_err  <= false ;
            WHEN "101011" => b6_disp <= pos ;   --D.4
                             b6_err  <= false ;
            WHEN "101100" => b6_disp <= zero ;  --D.12
                             b6_err  <= false ;
            WHEN "101101" => b6_disp <= pos ;   --D.2
                             b6_err  <= false ;
            WHEN "101110" => b6_disp <= pos ;   --D.1
                             b6_err  <= false ;
            WHEN "101111" => b6_disp <= pos ;   --invalid ;
                             b6_err  <= true ;

            WHEN "110000" => b6_disp <= neg ;   --invalid ;
                             b6_err  <= true ;
            WHEN "110001" => b6_disp <= zero ;  --D.17
                             b6_err  <= false ;
            WHEN "110010" => b6_disp <= zero ;  --D.18
                             b6_err  <= false ;
            WHEN "110011" => b6_disp <= pos ; --CHANGED FROM neg DUE TO CR 130235;   --D.24
                             b6_err  <= false ;
            WHEN "110100" => b6_disp <= zero ;  --D.20
                             b6_err  <= false ;
            WHEN "110101" => b6_disp <= pos ;   --D.31
                             b6_err  <= false ;
            WHEN "110110" => b6_disp <= pos ;   --D.16
                             b6_err  <= false ;
            WHEN "110111" => b6_disp <= pos ;   --invalid ;
                             b6_err  <= true ;
            WHEN "111000" => b6_disp <= specpos; --james, cisco 6/10/04    zero ;  --D.7
                             b6_err  <= false ;
            WHEN "111001" => b6_disp <= pos ;   --D.0
                             b6_err  <= false ;
            WHEN "111010" => b6_disp <= pos ;   --D.15
                             b6_err  <= false ;
            WHEN "111011" => b6_disp <= pos ;   --invalid ;
                             b6_err  <= true ;
            WHEN "111100" => b6_disp <= pos ;   --K.28
                             b6_err  <= false ;
            WHEN "111101" => b6_disp <= pos ;   --invalid ;
                             b6_err  <= true ;
            WHEN "111110" => b6_disp <= pos ;   --invalid ;     
                             b6_err  <= true ;
            WHEN "111111" => b6_disp <= pos ;   --invalid ;
                             b6_err  <= true ;

            WHEN OTHERS => b6_disp     <= zero ;
                                b6_err <= true ;
          END CASE ;
        END PROCESS ;

-------------------------------------------------------------------------------
-- Do the 3B/4B conversion
-------------------------------------------------------------------------------
        PROCESS (b4, k28) --jhgf
        BEGIN
          CASE b4 IS
            WHEN "0010" => b3 <= "000" ;      --D/K.x.0
            WHEN "1101" => b3 <= "000" ;      --D/K.x.0
            WHEN "1001" =>
              IF (k28 = '0')
              THEN b3         <= "001" ;      --D/K.x.1
              ELSE b3         <= "110" ;      --K28.6
              END IF ;
            WHEN "0110" =>
              IF (k28 = '1')
              THEN b3         <= "001" ;      --K.28.1
              ELSE b3         <= "110" ;      --D/K.x.6
              END IF ;
            WHEN "1010" =>
              IF (k28 = '0')
              THEN b3         <= "010" ;      --D/K.x.2
              ELSE b3         <= "101" ;      --K28.5
              END IF ;
            WHEN "0101" =>
              IF (k28 = '1')
              THEN b3         <= "010" ;      --K28.2
              ELSE b3         <= "101" ;      --D/K.x.5
              END IF ;
            WHEN "0011" => b3 <= "011" ;      --D/K.x.3
            WHEN "1100" => b3 <= "011" ;      --D/K.x.3
            WHEN "0100" => b3 <= "100" ;      --D/K.x.4
            WHEN "1011" => b3 <= "100" ;      --D/K.x.4
            WHEN "0111" => b3 <= "111" ;      --D.x.7
            WHEN "1000" => b3 <= "111" ;      --D.x.7
            WHEN "1110" => b3 <= "111" ;      --D/K.x.7
            WHEN "0001" => b3 <= "111" ;      --D/K.x.7
            WHEN OTHERS => b3 <= defaultb3 ;  --CODE VIOLATION!
          END CASE ;
        END PROCESS ;

-------------------------------------------------------------------------------
-- Disparity for the 4B block
-------------------------------------------------------------------------------
        PROCESS (b4) --jhgf
        BEGIN
          CASE b4 IS
            WHEN "0000" => b4_disp     <= neg ;
										  b4_err <= true ;
            WHEN "0001" => b4_disp     <= neg ;
										  b4_err <= false ;
            WHEN "0010" => b4_disp     <= neg ;
										  b4_err <= false ;
            WHEN "0011" => b4_disp     <= specneg; --james, cisco 6/10/04    zero ;
										  b4_err <= false ;
            WHEN "0100" => b4_disp     <= neg ;
										  b4_err <= false ;
            WHEN "0101" => b4_disp     <= zero ;
										  b4_err <= false ;
            WHEN "0110" => b4_disp     <= zero ;
										  b4_err <= false ;
            WHEN "0111" => b4_disp     <= pos ;
										  b4_err <= false ;
            WHEN "1000" => b4_disp     <= neg ;
										  b4_err <= false ;
            WHEN "1001" => b4_disp     <= zero ;
										  b4_err <= false ;
            WHEN "1010" => b4_disp     <= zero ;
										  b4_err <= false ;
            WHEN "1011" => b4_disp     <= pos ;
										  b4_err <= false ;
            WHEN "1100" => b4_disp     <= specpos; --james, cisco 6/10/04    zero ;
										  b4_err <= false ;
            WHEN "1101" => b4_disp     <= pos ;
										  b4_err <= false ;
            WHEN "1110" => b4_disp     <= pos ;
										  b4_err <= false ;
            WHEN "1111" => b4_disp     <= pos ;
										  b4_err <= true ;
            WHEN OTHERS => b4_disp     <= zero ;
									b4_err     <= true ;
          END CASE ;
        END PROCESS ;


-------------------------------------------------------------------------------
-- Special Code for calculating SYMRD[3:0] 
--  Added by James 6-10-04 for CISCO fix
--
--                        |                  SYMRD                  |
--    |         |         |   + Start Disp     |   - Start Disp     |
--    | b6_disp | b4_disp | Error | NewRunDisp | Error | NewRunDisp |
--    +---------+---------+-------+------------+-------+------------+
--    |    +    |    +    |   1   |	    1      |   1	 |	 1	  |
--    |    +    |    -    |   1   |	    0	     |   0	 |	 0	  |
--    |    +    |    0    |   1   |	    1	     |   0	 |	 1	  |
--    |    -    |    +    |   0   |	    1      |   1	 |	 1	  |
--    |    -    |    -    |   1   |     0	     |   1	 |	 0	  |
--    |    -    |    0    |   0   |	    0	     |   1	 |	 0	  |
--    |    0    |    +    |   1   |	    1      |   0	 |	 1	  |
--    |    0    |    -    |   0   |	    0      |   1	 |	 0	  |
--    |    0    |    0    |   0   |	    1      |   0	 |	 0	  |
--    +---------+---------+-------+------------+-------+------------+
--  
-------------------------------------------------------------------------------
   process (b4_disp, b6_disp)
	begin
	  case b6_disp IS
	    when pos =>
		    case b4_disp IS					
			   when pos    => SYMRD(3 downto 0) <= "1111";
			   when neg    => SYMRD(3 downto 0) <= "1000";
			   when specpos=> SYMRD(3 downto 0) <= "1101"; --Ex: D1.3-
			   when specneg=> SYMRD(3 downto 0) <= "1000";
			   when zero   => SYMRD(3 downto 0) <= "1101";
				when others => SYMRD(3 downto 0) <= "XXXX";
          end case;
	    when neg =>
		    case b4_disp IS
			   when pos    => SYMRD(3 downto 0) <= "0111";
			   when neg    => SYMRD(3 downto 0) <= "1010";
			   when specpos=> SYMRD(3 downto 0) <= "0111";
			   when specneg=> SYMRD(3 downto 0) <= "0010"; --Ex: D1.3+
			   when zero   => SYMRD(3 downto 0) <= "0010";
				when others => SYMRD(3 downto 0) <= "XXXX";
          end case;
	    when zero =>
		    case b4_disp IS
			   when pos    => SYMRD(3 downto 0) <= "1101";
			   when neg    => SYMRD(3 downto 0) <= "0010";
			   when specpos=> SYMRD(3 downto 0) <= "0111"; --Ex: D11.3+
			   when specneg=> SYMRD(3 downto 0) <= "1000"; --Ex: D11.3-
			   when zero   => SYMRD(3 downto 0) <= "0100";
				when others => SYMRD(3 downto 0) <= "XXXX";
          end case;
	    when specpos =>
		    case b4_disp IS							
			   when pos    => SYMRD(3 downto 0) <= "1111";
			   when neg    => SYMRD(3 downto 0) <= "0010"; --Ex: D7.0+
			   when specpos=> SYMRD(3 downto 0) <= "0111"; --Ex: D7.3+
			   when specneg=> SYMRD(3 downto 0) <= "1010";
			   when zero   => SYMRD(3 downto 0) <= "0111"; --Ex: D7.5+
				when others => SYMRD(3 downto 0) <= "XXXX";
          end case;
	    when specneg =>
		    case b4_disp IS
			   when pos    => SYMRD(3 downto 0) <= "1101"; --Ex: D7.0-
			   when neg    => SYMRD(3 downto 0) <= "1010";
			   when specpos=> SYMRD(3 downto 0) <= "1111";
			   when specneg=> SYMRD(3 downto 0) <= "1000"; --Ex: D7.3-
			   when zero   => SYMRD(3 downto 0) <= "1000"; --Ex: D7.5-
				when others => SYMRD(3 downto 0) <= "XXXX";
          end case;
       when others => SYMRD(3 downto 0) <= "XXXX";
    end case;
  end process;

   process (b4_disp, b6_disp)
	begin
	  case b6_disp IS
	    when pos =>
		    case b4_disp IS							
			   when pos    => D_SYMRD <= "E+/E+";
			   when neg    => D_SYMRD <= "E-/ -";
			   when zero   => D_SYMRD <= "E+/ +";
				when others => D_SYMRD <= "EE/EE";
          end case;
	    when neg =>
		    case b4_disp IS
			   when pos    => D_SYMRD <= " +/E+";
			   when neg    => D_SYMRD <= "E-/E-";
			   when zero   => D_SYMRD <= " -/E-";
				when others => D_SYMRD <= "EE/EE";
          end case;
	    when zero =>
		    case b4_disp IS
			   when pos    => D_SYMRD <= "E+/ +";
			   when neg    => D_SYMRD <= " -/E-";
			   when zero   => D_SYMRD <= " +/ -";
				when others => D_SYMRD <= "EE/EE";
          end case;
       when others => D_SYMRD <= "EE/EE";
    end case;
	  case b6_disp IS
	    when pos =>
		    case b4_disp IS							
			   when pos    => D_SYMRD <= "E+/E+";
			   when neg    => D_SYMRD <= "E-/ -";
			   when specpos=> D_SYMRD <= "E+/ +"; --Ex: D1.3-
			   when specneg=> D_SYMRD <= "E-/ -";
			   when zero   => D_SYMRD <= "E+/ +";
				when others => D_SYMRD <= "EE/EE";
          end case;
	    when neg =>
		    case b4_disp IS
			   when pos    => D_SYMRD <= " +/E+";
			   when neg    => D_SYMRD <= "E-/E-";
		   when specpos=> D_SYMRD <= " +/E+";
			   when specneg=> D_SYMRD <= " -/E-"; --Ex: D1.3+
			   when zero   => D_SYMRD <= " -/E-";
				when others => D_SYMRD <= "EE/EE";
          end case;
	    when zero =>
		    case b4_disp IS
			   when pos    => D_SYMRD <= "E+/ +";
			   when neg    => D_SYMRD <= " -/E-";
			   when specpos=> D_SYMRD <= " +/E+"; --Ex: D11.3+
			   when specneg=> D_SYMRD <= "E-/ -"; --Ex: D11.3-
			   when zero   => D_SYMRD <= " +/ -";
				when others => D_SYMRD <= "EE/EE";
          end case;
	    when specpos =>
		    case b4_disp IS							
			   when pos    => D_SYMRD <= "E+/E+";
			   when neg    => D_SYMRD <= " -/E-"; --Ex: D7.0+
			   when specpos=> D_SYMRD <= " +/E+"; --Ex: D7.3+
			   when specneg=> D_SYMRD <= "E-/E-";
			   when zero   => D_SYMRD <= " +/E+"; --Ex: D7.5+
				when others => D_SYMRD <= "EE/EE";
          end case;
	    when specneg =>
		    case b4_disp IS
			   when pos    => D_SYMRD <= "E+/ +"; --Ex: D7.0-
			   when neg    => D_SYMRD <= "E-/E-";
			   when specpos=> D_SYMRD <= "E+/E+";
			   when specneg=> D_SYMRD <= "E-/ -"; --Ex: D7.3-
			   when zero   => D_SYMRD <= "E-/ -"; --Ex: D7.5-
				when others => D_SYMRD <= "EE/EE";
          end case;
       when others => D_SYMRD <= "EE/EE";
    end case;
  end process;

-------------------------------------------------------------------------------
-- Special Code for calculating RUN_DISP & DISP_ERR
--  Added by James 6-10-04 for CISCO fix
--
-- New running disparity is calculated from old running disparity,
--  and the disparity information from the 10-bit word.
--
-- New disparity error is calculated from old running disparity,
--  and the error information from the 10-bit word.
-------------------------------------------------------------------------------
  process (clk)
  begin
    if (clk'event and clk='1') then
       IF ((c_has_sinit = 1) AND (SINIT = '1')) THEN
          new_run_disp <= calc_run_disp_init_val(c_sinit_run_disp);              
        ELSIF (ce_int = '1') THEN   --NOTE: sinit works regardless of state
                                    --of ce. (C_SYNC_PRIORITY=0 in
                                    --structural code)
          if (C_HAS_DISP_IN=1) then
		      if (disp_in='1') then
		        new_run_disp <= SYMRD(2);
            else
		        new_run_disp <= SYMRD(0);
            end if; --new_run_disp
	       else
		      if (new_run_disp='1') then
		        new_run_disp <= SYMRD(2);
            else
		        new_run_disp <= SYMRD(0);
            end if; --new_run_disp
		    end if; --C_HAS_DISP_IN
       end if; --ce_int
    end if; --clk
  end process;

  process (clk)
  BEGIN
    if (clk'event and clk='1') then
      if ((c_has_sinit = 1) and (SINIT = '1')) then
	   new_disp_err <= '0';
      else
        if (C_HAS_DISP_IN=1) then
          if (disp_in='1') then
	     new_disp_err <= SYMRD(3);
	  else 
	     new_disp_err <= SYMRD(1);
          end if; --new_run_disp
	else
          if (new_run_disp='1') then
	    new_disp_err <= SYMRD(3);
	  else 
	    new_disp_err <= SYMRD(1);
          end if; --new_run_disp
        end if; --C_HAS_DISP_IN
      end if; --c_has_sinit
    end if;
  END PROCESS;

  process (clk)
  BEGIN
    if (clk'event and clk='1') then
      if ((c_has_sinit = 1) and (SINIT = '1')) then
        sym_disp_int <= calc_sym_disp(c_sinit_run_disp);
      else
        if (C_HAS_DISP_IN=1) then
          if (disp_in='1') then
            sym_disp_int <= SYMRD(3 downto 2);
          else
            sym_disp_int <= SYMRD(1 downto 0);
          end if;
        else
          if (new_run_disp='1') then
	    sym_disp_int <= SYMRD(3 downto 2);
	  else 
	    sym_disp_int <= SYMRD(1 downto 0);
          end if;
        end if;
      end if;
    end if;
  END PROCESS;

  run_disp_new1 : IF (c_has_run_disp = 1) GENERATE
    run_disp <= new_run_disp;
  END GENERATE run_disp_new1;

  disp_err_new1 : IF (c_has_disp_err = 1) GENERATE
    disp_err <= new_disp_err;
  END GENERATE disp_err_new1;	   

  sym_disp1 : IF (c_has_sym_disp = 1) GENERATE
    sym_disp <= sym_disp_int;
  END GENERATE sym_disp1;

 
-------------------------------------------------------------------------------
-- Decode the K codes
-------------------------------------------------------------------------------
        PROCESS (c, d, e, i, g, h, j)
        BEGIN
          k <= (c AND d AND e AND i) OR NOT(c OR d OR e OR i) OR
               ((e XOR i) AND ((i AND g AND h AND j) OR
                               NOT(i OR g OR h OR j))) ;
        END PROCESS ;





-------------------------------------------------------------------------------
-- Update the outputs on the clock
-------------------------------------------------------------------------------
  
        ----Update dout and kout outputs-------------------
        PROCESS (clk)
        BEGIN
          IF (clk'event AND clk = '1' AND ce_int = '1') THEN
            IF ((c_has_sinit = 1) AND (SINIT = '1')) THEN
              dout       <= str_to_slv_0(c_sinit_dout, 8) ;
              IF c_sinit_kout=1 THEN
                kout       <= '1' ;
              ELSE
                kout       <= '0';
              END IF;
            ELSE
              dout       <= (b3 & b5) ;
              kout       <= k ;
          END IF ;
	END IF ;
        END PROCESS ;
  
        ----Update the Special Error output-------------------------------
        PROCESS (clk)
        BEGIN
          IF (clk'event AND clk = '1') THEN
            IF ((ce_int = '1') AND (c_has_sinit = 1) AND (SINIT = '1')) THEN
              spec_err_dl_q <= '0' ;
              spec_err_ndl_q <= '0' ;
              spec_err_md_q <= '0' ;
              spec_err_nmd_q <= '0' ;
              b6_disp_q <= zero;
            ELSE
              spec_err_dl_q <= spec_err_dl ;
              spec_err_ndl_q <= spec_err_ndl ;
              spec_err_md_q <= spec_err_md ;
              spec_err_nmd_q <= spec_err_nmd ;
              b6_disp_q <= b6_disp;
            END IF ;
          END IF ;
        END PROCESS ;

  
-------------------------------------------------------------------------------
-- Calculate code_error (uses notation from IBM spec)
-------------------------------------------------------------------------------
bitcount: PROCESS (din)
BEGIN  -- PROCESS bitcount
  CASE din(3 DOWNTO 0) IS
    WHEN "0000" => P04 <= '1';
                   P13 <= '0';
                   P22 <= '0';
                   P31 <= '0';
                   P40 <= '0';
    WHEN "0001" => P04 <= '0';
                   P13 <= '1';
                   P22 <= '0';
                   P31 <= '0';
                   P40 <= '0';
    WHEN "0010" => P04 <= '0';
                   P13 <= '1';
                   P22 <= '0';
                   P31 <= '0';
                   P40 <= '0';
    WHEN "0011" => P04 <= '0';
                   P13 <= '0';
                   P22 <= '1';
                   P31 <= '0';
                   P40 <= '0';
    WHEN "0100" => P04 <= '0';
                   P13 <= '1';
                   P22 <= '0';
                   P31 <= '0';
                   P40 <= '0';
    WHEN "0101" => P04 <= '0';
                   P13 <= '0';
                   P22 <= '1';
                   P31 <= '0';
                   P40 <= '0';
    WHEN "0110" => P04 <= '0';
                   P13 <= '0';
                   P22 <= '1';
                   P31 <= '0';
                   P40 <= '0';
    WHEN "0111" => P04 <= '0';
                   P13 <= '0';
                   P22 <= '0';
                   P31 <= '1';
                   P40 <= '0';
    WHEN "1000" => P04 <= '0';
                   P13 <= '1';
                   P22 <= '0';
                   P31 <= '0';
                   P40 <= '0';
    WHEN "1001" => P04 <= '0';
                   P13 <= '0';
                   P22 <= '1';
                   P31 <= '0';
                   P40 <= '0';
    WHEN "1010" => P04 <= '0';
                   P13 <= '0';
                   P22 <= '1';
                   P31 <= '0';
                   P40 <= '0';
    WHEN "1011" => P04 <= '0';
                   P13 <= '0';
                   P22 <= '0';
                   P31 <= '1';
                   P40 <= '0';
    WHEN "1100" => P04 <= '0';
                   P13 <= '0';
                   P22 <= '1';
                   P31 <= '0';
                   P40 <= '0';
    WHEN "1101" => P04 <= '0';
                   P13 <= '0';
                   P22 <= '0';
                   P31 <= '1';
                   P40 <= '0';
    WHEN "1110" => P04 <= '0';
                   P13 <= '0';
                   P22 <= '0';
                   P31 <= '1';
                   P40 <= '0';
    WHEN "1111" => P04 <= '0';
                   P13 <= '0';
                   P22 <= '0';
                   P31 <= '0';
                   P40 <= '1';
    WHEN OTHERS => NULL;
  END CASE;
END PROCESS bitcount;



fghj <= (f AND g AND h AND j) OR (NOT f AND NOT g AND NOT h AND NOT j);
eifgh <= (e AND i AND f AND g AND h) OR (NOT e AND NOT i AND NOT f AND NOT g AND NOT h);
sK28 <= (c AND d AND e AND i) OR (NOT c AND NOT d AND NOT e AND NOT i);
e_i <= (e AND NOT i) OR (NOT e AND i);
ighj <= (i AND g AND h AND j) OR (NOT i AND NOT g AND NOT h AND NOT j);
i_ghj <= (NOT i AND g AND h AND j) OR (i AND NOT g AND NOT h AND NOT j);
Kx7 <= e_i AND ighj;
INVR6 <= P40 OR P04 OR (P31 AND e AND i) OR (P13 AND NOT e AND NOT i);
PDBR6 <= (P31 AND (e OR i)) OR (P22 AND e AND i) OR P40;
NDBR6 <= (P13 AND (NOT e OR NOT i)) OR (P22 AND NOT e AND NOT i) OR P04;
PDUR6 <= PDBR6 OR (d AND e AND i);
PDBR4 <= (f AND g AND (h OR j)) OR ((f OR g) AND h AND j);
NDRR4 <= PDBR4 OR (f AND g);
NDUR6 <=  NDBR6 OR (NOT d AND NOT e AND NOT i);
PDRR6 <= NDBR6 OR (NOT a AND NOT b AND NOT c);
fgh <= (f AND g AND h) OR (NOT f AND NOT g AND NOT h);
NDBR4 <= (NOT f AND NOT g AND (NOT h OR NOT j)) OR ((NOT f OR NOT g) AND NOT h AND NOT j);
PDRR4 <= NDBR4 OR (NOT f AND NOT g);

invby_a <= INVR6;
invby_b <= fghj;
invby_c <= eifgh;
invby_d <= (NOT sK28 AND i_ghj);
invby_e <= (sK28 AND fgh);
invby_f <= (Kx7 AND NOT PDBR6 AND NOT NDBR6);
invby_g <= (PDUR6 AND NDRR4);
invby_h <= (NDUR6 AND PDRR4);
  


--Update internal code error signal (combinational logic - not registered)
code_err_i <= invby_a OR invby_b OR invby_c OR invby_d OR invby_e OR invby_f OR invby_g OR invby_h;
       
-------------------------------------------------------------------------------
-- End of code_error calculation
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Calculate special disparity error
-------------------------------------------------------------------------------
spec_err_a <= (P22 AND NOT e AND NOT i);
spec_err_b <= (P22 AND e AND i);
spec_err_c <= (P13 AND NOT i);
spec_err_d <= (P31 AND i);
spec_err_e <= (P31 AND NOT d AND NOT e AND NOT i);
spec_err_f <= (P13 AND d AND e AND i);
spec_err_g <= (P31 AND e);
spec_err_h <= (P13 AND NOT e);

--Cases that, when disp_last=1 (pos), will produce an error
spec_err_dl <= spec_err_b OR spec_err_d OR spec_err_e OR spec_err_g;
--Cases that, when disp_last=0 (neg), will produce an error
spec_err_ndl <= spec_err_a OR spec_err_c OR spec_err_f OR spec_err_h;

--Calculate mid-code disparity for code input before the rising edge (disp_last
--is delayed one cycle, so we have to use a delayed version of b6_disp)
proc_mid_disp: PROCESS (b6_disp_q, disp_last)
BEGIN  -- PROCESS proc_mid_disp
  IF b6_disp_q=neg THEN
    mid_disp <= '0';
  ELSIF b6_disp_q=pos THEN
    mid_disp <= '1';
  ELSE --b6_disp_q=zero
    IF disp_last='0' THEN
      mid_disp <= '0';
    ELSE
      mid_disp <= '1';
    END IF;
  END IF;
END PROCESS proc_mid_disp;


spec_err_i <= (NOT f AND NOT h AND NOT j);
spec_err_j <= (f AND h AND j);
spec_err_k <= (f AND g AND NOT h AND NOT j);
spec_err_l <= (NOT f AND NOT g AND h AND j);
spec_err_m <= (NOT f AND NOT g AND NOT j);
spec_err_n <= (f AND g AND j);
spec_err_o <= (f AND g AND h);
spec_err_p <= (NOT f AND NOT g AND NOT h);
spec_err_q <= (g AND h AND j);
spec_err_r <= (NOT g AND NOT h AND NOT j);

--Cases that, when mid_disp=1 (pos), will produce an error
spec_err_md <= spec_err_j OR spec_err_k OR spec_err_n OR spec_err_o OR spec_err_q;
--Cases that, when mid_disp=0 (neg), will produce an error
spec_err_nmd <= spec_err_i OR spec_err_l OR spec_err_m OR spec_err_p OR spec_err_r;


spec_err <= (spec_err_dl_q AND disp_last) OR (spec_err_ndl_q AND NOT disp_last) OR (spec_err_md_q AND mid_disp) OR (spec_err_nmd_q AND NOT mid_disp);


END behavioral ;









---------------------------------------------------------------------------
-- Filename:    decode_8b10b_v7_0.vhd
--
-- Description: The behavioral model for the 8b/10b Decoder     
--                      
--
---------------------------------------------------------------------------
--  Structure:
--
--   >> decode_8b10b_v7_0 <<
--              |
--              +- decode_8b10b_v7_0_base      //single-port decoder
--              |
--              +- decode_8b10b_v7_0_base      //optional second decoder
--
---------------------------------------------------------------------------


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.decode_8b10b_v7_0_base;
-- LIBRARY work;
-- USE work.decode_8b10b_v7_0_base;

-------------------------------------------------------------------------------
-- Decoder Entity Declaration
-------------------------------------------------------------------------------
ENTITY decode_8b10b_v7_0 IS
    GENERIC (
      -------------------------------------------------------------------------
      -- Generic Parameters
      --  
      --  c_decode_type      : Implementation: 0=Slice based, 1=BlockRam, 2=LutRam
      --  c_enable_rlocs     : Enable Relative PLacement (T=1,F=0)
      --  c_has_bports       : 1 indicates second decoder should be generated
      --  c_has_ce           : 1 indicates ce port is present
      --  c_has_ce_b         : 1 indicates ce_b port is present (if c_has_bports=1)
      --  c_has_code_err     : 1 indicates code_err port is present
      --  c_has_code_err_b   : 1 indicates code_err_b port is present (if c_has_bports=1)
      --  c_has_disp_err     : 1 indicates disp_err port is present
      --  c_has_disp_err_b   : 1 indicates disp_err_b port is present (if c_has_bports=1)
      --  c_has_disp_in      : 1 indicates disp_in port is present
      --  c_has_disp_in_b    : 1 indicates disp_in_b port is present (if c_has_bports=1)
      --  c_has_nd           : 1 indicates nd port is present
      --  c_has_nd_b         : 1 indicates nd_b port is present (if c_has_bports=1)
      --  c_has_run_disp     : 1 indicates run_disp port is present
      --  c_has_run_disp_b   : 1 indicates run_disp_b port is present (if c_has_bports=1)
      --  c_has_sinit        : 1 indicates sinit port is present
      --  c_has_sinit_b      : 1 indicates sinit_b port is present (if c_has_bports=1)
      --  c_has_sym_disp     : 1 indicates sym_disp port is present
      --  c_has_sym_disp_b   : 1 indicates sym_disp_b port is present (if c_has_bports=1)
      --  c_sinit_dout       : 8-bit binary string, dout value when sinit is active
      --  c_sinit_dout_b     : 8-bit binary string, dout_b value when sinit_b is active
      --  c_sinit_kout       : controls kout output when sinit is active
      --  c_sinit_kout_b     : controls kout_b output when sinit_b is active
      --  c_sinit_run_disp   : Initializes run_disp value to positive(1) or negative(0)
      --  c_sinit_run_disp_b : Initializes run_disp_b value to positive(1) or negative(0)
      -------------------------------------------------------------------------
      c_decode_type    : integer := 1;
      c_enable_rlocs   : integer := 0;
      c_has_bports     : integer := 0;
      c_has_ce         : integer := 0;
      c_has_ce_b       : integer := 0;
      c_has_code_err   : integer := 1;
      c_has_code_err_b : integer := 0;
      c_has_disp_err   : integer := 1;
      c_has_disp_err_b : integer := 0;
      c_has_disp_in    : integer := 0;
      c_has_disp_in_b  : integer := 0;
      c_has_nd         : integer := 0;
      c_has_nd_b       : integer := 0; 
      c_has_run_disp   : integer := 0;
      c_has_run_disp_b : integer := 0;
      c_has_sinit      : integer := 0;
      c_has_sinit_b    : integer := 0;
      c_has_sym_disp   : integer := 0;
      c_has_sym_disp_b : integer := 0;
      c_sinit_dout       : string  := "00000000";
      c_sinit_dout_b     : string  := "00000000";
      c_sinit_kout       : integer := 0;
      c_sinit_kout_b     : integer := 0; 
      c_sinit_run_disp   : integer := 0;  
      c_sinit_run_disp_b : integer := 0 
      );



    PORT (
      -------------------------------------------------------------------------
      -- Mandatory Pins
      --  clk  : Clock Input
      --  din  : Encoded Symbol Input
      --  dout : Data Output, decoded data byte
      --  kout : Command Output
      -------------------------------------------------------------------------
      clk  : IN  std_logic;
      din  : IN  std_logic_vector(9 DOWNTO 0);
      dout : OUT std_logic_vector(7 DOWNTO 0);
      kout : OUT std_logic;

      -------------------------------------------------------------------------
      -- Optional Pins
      --  ce         : Clock Enable
      --  ce_b       : Clock Enable (B port)
      --  clk_b      : Clock Input (B port)
      --  din_b      : Encoded Symbol Input (B port)
      --  disp_in    : Disparity Input (running disparity in)
      --  disp_in_b  : Disparity Input (running disparity in) 
      --  sinit      : Synchronous Initialization. Resets core to known state.
      --  sinit_b    : Synchronous Initialization. Resets core to known state. (B port)
      --  code_err   : Code Error, indicates that input symbol did not correspond
      --                to a valid member of the code set.
      --  code_err_b : Code Error, indicates that input symbol did not correspond
      --                to a valid member of the code set. (B port)
      --  disp_err   : Disparity Error
      --  disp_err_b : Disparity Errort (B port)
      --  dout_b     : Data Output, decoded data byte (B port)
      --  kout_b     : Command Output (B port)
      --  nd         : New Data
      --  nd_b       : New Data (B port)
      --  run_disp   : Running Disparity
      --  run_disp_b : Running Disparity (B port)
      --  sym_disp   : Symbol Disparity
      --  sym_disp_b : Symbol Disparity (B port)
      -------------------------------------------------------------------------
      ce         : IN  std_logic := '0';
      ce_b       : IN  std_logic := '0';
      clk_b      : IN  std_logic := '0';
      din_b      : IN  std_logic_vector(9 DOWNTO 0) := "0000000000";
      disp_in    : IN  std_logic := '0';
      disp_in_b  : IN  std_logic := '0';
      sinit      : IN  std_logic := '0';
      sinit_b    : IN  std_logic := '0';
      code_err   : OUT std_logic;
      code_err_b : OUT std_logic;
      disp_err   : OUT std_logic;
      disp_err_b : OUT std_logic;
      dout_b     : OUT std_logic_vector(7 DOWNTO 0);
      kout_b     : OUT std_logic;
      nd         : OUT std_logic;
      nd_b       : OUT std_logic;
      run_disp   : OUT std_logic;
      run_disp_b : OUT std_logic;
      sym_disp   : OUT std_logic_vector(1 DOWNTO 0);
      sym_disp_b : OUT std_logic_vector(1 DOWNTO 0)
      );

END decode_8b10b_v7_0;

-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------
ARCHITECTURE behavioral OF decode_8b10b_v7_0 IS


-------------------------------------------------------------------------------
-- Declare the base decoder
-------------------------------------------------------------------------------
  COMPONENT decode_8b10b_v7_0_base
    GENERIC (
      -------------------------------------------------------------------------
      -- Generic Parameters
      --  c_has_ce           : 1 indicates ce port is present
      --  c_has_code_err     : 1 indicates code_err port is present
      --  c_has_disp_err     : 1 indicates disp_err port is present
      --  c_has_disp_in      : 1 indicates disp_in port is present
      --  c_has_nd           : 1 indicates nd port is present
      --  c_has_run_disp     : 1 indicates run_disp port is present
      --  c_has_sinit        : 1 indicates sinit port is present
      --  c_has_sym_disp     : 1 indicates sym_disp port is present
      --  c_sinit_dout       : 8-bit binary string, dout value when sinit is active
      --  c_sinit_kout       : controls kout output when sinit is active
      --  c_sinit_run_disp   : Initializes run_disp value to positive(1) or negative(0)
      -------------------------------------------------------------------------
      c_has_ce         :     integer := 0;
      c_has_code_err   :     integer := 1;
      c_has_disp_err   :     integer := 1;
      c_has_disp_in    :     integer := 0;
      c_has_nd         :     integer := 0;
      c_has_run_disp   :     integer := 0;
      c_has_sinit      :     integer := 0;
      c_has_sym_disp   :     integer := 0;
      c_sinit_dout     :     string  := "00000000";
      c_sinit_kout     :     integer := 0;
      c_sinit_run_disp :     integer := 0
      );
    PORT (
      -------------------------------------------------------------------------
      -- Mandatory Pins
      --  clk  : Clock Input
      --  din  : Encoded Symbol Input
      --  dout : Data Output, decoded data byte
      --  kout : Command Output
      -------------------------------------------------------------------------
      clk              : IN  std_logic;
      din              : IN  std_logic_vector(9 DOWNTO 0);
      dout             : OUT std_logic_vector(7 DOWNTO 0);
      kout             : OUT std_logic;

      -------------------------------------------------------------------------
      -- Optional Pins
      --  ce         : Clock Enable
      --  disp_in    : Disparity Input (running disparity in)
      --  sinit      : Synchronous Initialization. Resets core to known state.
      --  code_err   : Code Error, indicates that input symbol did not correspond
      --                to a valid member of the code set.
      --  disp_err   : Disparity Error
      --  nd         : New Data
      --  run_disp   : Running Disparity
      --  sym_disp   : Symbol Disparity
      -------------------------------------------------------------------------
      ce               : IN  std_logic;
      disp_in          : IN  std_logic;
      sinit            : IN  std_logic;
      code_err         : OUT std_logic;
      disp_err         : OUT std_logic;
      nd               : OUT std_logic;
      run_disp         : OUT std_logic;
      sym_disp         : OUT std_logic_vector(1 DOWNTO 0)
      );

  END COMPONENT;



-------------------------------------------------------------------------------
-- Begin Architecture
-------------------------------------------------------------------------------
BEGIN

  ----Instantiate the first decoder (A decoder)--------------------------------
  first_decoder : decode_8b10b_v7_0_base
    GENERIC MAP (
      c_has_ce         => c_has_ce,
      c_has_code_err   => c_has_code_err,
      c_has_disp_err   => c_has_disp_err,
      c_has_disp_in    => c_has_disp_in,
      c_has_nd         => c_has_nd,
      c_has_run_disp   => c_has_run_disp,
      c_has_sinit      => c_has_sinit,
      c_has_sym_disp   => c_has_sym_disp,
      c_sinit_dout     => c_sinit_dout,
      c_sinit_kout     => c_sinit_kout,
      c_sinit_run_disp => c_sinit_run_disp
      )
    PORT MAP (
      clk              => clk,
      din              => din,
      dout             => dout,
      kout             => kout,

      ce               => ce,
      disp_in          => disp_in,
      sinit            => sinit,
      code_err         => code_err,
      disp_err         => disp_err,
      nd               => nd,
      run_disp         => run_disp,
      sym_disp         => sym_disp
      );


make_second_decoder : IF (C_HAS_BPORTS=1) GENERATE

  ----Instantiate second decoder (B decoder, only if bports are present)------
  second_decoder : decode_8b10b_v7_0_base
    GENERIC MAP (
      c_has_ce         => c_has_ce_b,
      c_has_code_err   => c_has_code_err_b,
      c_has_disp_err   => c_has_disp_err_b,
      c_has_disp_in    => c_has_disp_in_b,
      c_has_nd         => c_has_nd_b,
      c_has_run_disp   => c_has_run_disp_b,
      c_has_sinit      => c_has_sinit_b,
      c_has_sym_disp   => c_has_sym_disp_b,
      c_sinit_dout     => c_sinit_dout_b,
      c_sinit_kout     => c_sinit_kout_b,
      c_sinit_run_disp => c_sinit_run_disp_b
      )
    PORT MAP (
      clk              => clk_b,
      din              => din_b,
      dout             => dout_b,
      kout             => kout_b,

      ce               => ce_b,
      disp_in          => disp_in_b,
      sinit            => sinit_b,
      code_err         => code_err_b,
      disp_err         => disp_err_b,
      nd               => nd_b,
      run_disp         => run_disp_b,
      sym_disp         => sym_disp_b
      );

  
END GENERATE make_second_decoder;

  

END behavioral ;


