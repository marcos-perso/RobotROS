-- $Id: c_shift_ram_v2_0.vhd,v 1.1 2010-07-10 21:42:55 mmartinez Exp $
--
-- Filename - c_shift_ram_v2_0.vhd
-- Author - Xilinx
-- Creation - 24 Mar 1999
--
-- Description
--  RAM based Shift Register Simulation Model
--   VHDL-87 compatable version
--   Also compatable with VHDL-93
--   User cannot generate a Memory Initialization file from the memory
--   contents, unless xilinxcorelib.mem_init_file pack is compiled from
--   either mem_init_file_pack_87.vhd or mem_init_file_pack_93.vhd.
--   Default compilation is mem_init_file_pack.vhd
--

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

LIBRARY xilinxcorelib;
USE xilinxcorelib.ul_utils.ALL;
USE xilinxcorelib.mem_init_file_pack_v5_0.ALL;
USE xilinxcorelib.prims_constants_v2_0.all;
USE xilinxcorelib.prims_utils_v2_0.all;
USE xilinxcorelib.c_reg_fd_v2_0_comp.all;

ENTITY C_SHIFT_RAM_V2_0 IS
	GENERIC (C_ADDR_WIDTH	 : integer := 4;
			 C_AINIT_VAL	 : string  := "";
			 C_DEFAULT_DATA  : string  := "0";
             C_DEFAULT_DATA_RADIX : integer := 1;
             C_DEPTH		 : integer := 16;
			 C_ENABLE_RLOCS	 : integer := 1;
			 C_GENERATE_MIF  : integer := 0;   -- Unused by the behavioural model
             C_HAS_ACLR 	 : integer := 0;
			 C_HAS_A       	 : integer := 0;
			 C_HAS_AINIT	 : integer := 0;
			 C_HAS_ASET 	 : integer := 0;
			 C_HAS_CE 		 : integer := 0;
			 C_HAS_SCLR 	 : integer := 0;
			 C_HAS_SINIT	 : integer := 0;
			 C_HAS_SSET		 : integer := 0;
			 C_MEM_INIT_FILE : string  := "null.mif";
             C_MEM_INIT_RADIX : integer := 1;   -- for backwards compatibility
             C_READ_MIF      : integer := 0;
             C_REG_LAST_BIT	 : integer := 0;
			 C_SHIFT_TYPE 	 : integer := c_fixed;
			 C_SINIT_VAL 	 : string  := "";
			 C_SYNC_PRIORITY : integer := c_clear;
			 C_SYNC_ENABLE	 : integer := c_override;
             C_WIDTH		 : integer := 16
			 ); 

    PORT (A     : IN std_logic_vector(C_ADDR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
          D     : IN std_logic_vector(C_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
		  CLK   : IN std_logic := '0';
		  CE    : IN std_logic := '1';
		  ACLR  : IN std_logic := '0';
		  ASET  : IN std_logic := '0';
		  AINIT : IN std_logic := '0';
		  SCLR  : IN std_logic := '0';
		  SSET  : IN std_logic := '0';
		  SINIT : IN std_logic := '0';
		  Q     : OUT std_logic_vector(C_WIDTH-1 DOWNTO 0)
	); 
END C_SHIFT_RAM_V2_0;
--
-- behavior describing a parameterized ram based shift register
--
ARCHITECTURE behavioral OF C_SHIFT_RAM_V2_0 IS
--
 SIGNAL shift_out : STD_LOGIC_VECTOR(C_WIDTH-1 DOWNTO 0);
 type T_PIPE_SIGNAL is array (0 to C_DEPTH) of STD_LOGIC_VECTOR(C_WIDTH-1 DOWNTO 0);
 SIGNAL d_pipe 	 : T_PIPE_SIGNAL := (others => (others => '0'));
 SIGNAL intA : std_logic_vector(C_ADDR_WIDTH-1 downto 0) := (others => '0');
 SIGNAL init : T_PIPE_SIGNAL := (others => (others => '0'));
 SIGNAL initclr : T_PIPE_SIGNAL := (others => (others => '0'));
 SIGNAL int_ce : STD_LOGIC := '0';
--
 FUNCTION getRealDepth(depth : INTEGER) RETURN INTEGER IS
 BEGIN
   IF((depth MOD 16) > 0) THEN
     return(((depth/16)+1)*16);
   ELSE
     return(depth);
   END IF;
 END getRealDepth;
 
 FUNCTION getRadix(C_DEFAULT_DATA_RADIX, C_MEM_INIT_RADIX : INTEGER) RETURN INTEGER IS
 BEGIN
    IF (C_DEFAULT_DATA_RADIX = 1) THEN
        RETURN C_MEM_INIT_RADIX;
    ELSE
        RETURN C_DEFAULT_DATA_RADIX;
    END IF;
 END getRadix;
--
 
 CONSTANT radix : INTEGER := getRadix(C_DEFAULT_DATA_RADIX, C_MEM_INIT_RADIX);
--
BEGIN
    
  cegen1 : IF (c_has_ce = 1) GENERATE
  cegen11 : int_ce <= ce;
  END GENERATE;
  
  cegen0 : IF (c_has_ce = 0) GENERATE
  cegen01 : int_ce <= '1';
  END GENERATE;
  
  -- The fixed length version can be modelled simply with a
  -- pipeline of FDs and a final output register if required
  fixed : IF (C_SHIFT_TYPE = c_fixed) GENERATE
	reged : IF (C_REG_LAST_BIT = 1) GENERATE
      qout1 : IF (C_DEPTH > 1) GENERATE
        qout11 : C_REG_FD_V2_0
            GENERIC MAP (C_AINIT_VAL     => C_AINIT_VAL,
                     C_HAS_ACLR      => C_HAS_ACLR,
                     C_HAS_AINIT     => C_HAS_AINIT,
                     C_HAS_ASET      => C_HAS_ASET,
                     C_HAS_CE        => C_HAS_CE,
                     C_HAS_SCLR      => C_HAS_SCLR,
                     C_HAS_SINIT     => C_HAS_SINIT,
                     C_HAS_SSET      => C_HAS_SSET,
                     C_SINIT_VAL     => C_SINIT_VAL,
                     C_SYNC_ENABLE   => C_SYNC_ENABLE,
                     C_SYNC_PRIORITY => C_SYNC_PRIORITY,
                     C_WIDTH         => C_WIDTH) 
            PORT MAP (D     => shift_out,
                  CLK   => CLK,
                  CE    => CE,
                  ACLR  => ACLR,
                  ASET  => ASET,
                  AINIT => AINIT,
                  SCLR  => SCLR,
                  SSET  => SSET,
                  SINIT => SINIT,
                  Q     => Q);     
      END GENERATE;
      qout2 : IF (C_DEPTH = 1) GENERATE
        qout21 : C_REG_FD_V2_0
            GENERIC MAP (C_AINIT_VAL     => C_AINIT_VAL,
                     C_HAS_ACLR      => C_HAS_ACLR,
                     C_HAS_AINIT     => C_HAS_AINIT,
                     C_HAS_ASET      => C_HAS_ASET,
                     C_HAS_CE        => C_HAS_CE,
                     C_HAS_SCLR      => C_HAS_SCLR,
                     C_HAS_SINIT     => C_HAS_SINIT,
                     C_HAS_SSET      => C_HAS_SSET,
                     C_SINIT_VAL     => C_SINIT_VAL,
                     C_SYNC_ENABLE   => C_SYNC_ENABLE,
                     C_SYNC_PRIORITY => C_SYNC_PRIORITY,
                     C_WIDTH         => C_WIDTH) 
            PORT MAP (D     => D,
                  CLK   => CLK,
                  CE    => CE,
                  ACLR  => ACLR,
                  ASET  => ASET,
                  AINIT => AINIT,
                  SCLR  => SCLR,
                  SSET  => SSET,
                  SINIT => SINIT,
                  Q     => Q);     
    END GENERATE;
  END GENERATE;
  unreg : IF NOT (C_REG_LAST_BIT = 1) GENERATE
    Q <= shift_out;
  END GENERATE;

-- Core Memory process
 PROCESS (CLK)
--   
   type     shifttype is array(0 to C_DEPTH-1-C_REG_LAST_BIT) of std_logic_vector(C_WIDTH-1 downto 0);
      variable shift : shifttype;
    
    CONSTANT mem_bits   : INTEGER := C_DEPTH * C_WIDTH;
   VARIABLE memdvect   : STD_LOGIC_VECTOR(mem_bits-1 DOWNTO 0);
   VARIABLE bits_good  : BOOLEAN;
   VARIABLE lineno     : INTEGER := 0;
   VARIABLE offset     : INTEGER := 0;
   VARIABLE def_data   : STD_LOGIC_VECTOR(C_WIDTH-1 DOWNTO 0);
   VARIABLE startup    : BOOLEAN := TRUE;
   VARIABLE spo_tmp    : STD_LOGIC_VECTOR(C_WIDTH-1 DOWNTO 0);
   VARIABLE dpo_tmp    : STD_LOGIC_VECTOR(C_WIDTH-1 DOWNTO 0);
   VARIABLE srl_start  : INTEGER := 0;
   VARIABLE srl_end    : INTEGER := 0;
--		

   FUNCTION add_std_logic_vec( arg1, arg2 : STD_LOGIC_VECTOR; size : INTEGER ) RETURN STD_LOGIC_VECTOR IS
     VARIABLE S   : STD_LOGIC_VECTOR(size-1 DOWNTO 0) := (OTHERS=>'0');
     VARIABLE C   : STD_LOGIC_VECTOR(size-1 DOWNTO 0) := (OTHERS=>'0');
     VARIABLE A   : STD_LOGIC;
     VARIABLE B   : STD_LOGIC;
   BEGIN
   	 FOR i IN 0 TO size-2 LOOP
       IF( i < arg1'LENGTH ) THEN
         A := arg1(i);
       ELSE
         A := '0';
       END IF;
       IF( i < arg2'LENGTH ) THEN
         B := arg2(i);
       ELSE
         B := '0';
       END IF;
       S(i)   := A XOR B;
       C(i+1) := (A AND B) OR (S(i) AND C(i));
       S(i)   := S(i) XOR C(i);
     END LOOP;
     RETURN S;
   END add_std_logic_vec;
-- 
   FUNCTION mul_std_logic_vec( arg1, arg2 : STD_LOGIC_VECTOR; size : INTEGER ) RETURN STD_LOGIC_VECTOR IS
     VARIABLE M   : STD_LOGIC_VECTOR(size-1 DOWNTO 0) := (OTHERS=>'0');
     VARIABLE A   : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
   BEGIN
     FOR i IN 0 TO arg2'LENGTH-1 LOOP
       IF arg2(i) = '1' THEN
         A := (OTHERS=>'0');
         FOR j IN 0 TO arg1'LENGTH-1 LOOP
           IF( i+j < size ) THEN
             A(i+j) := arg1(j);
           END IF;
         END LOOP;
         M := add_std_logic_vec( M, A, size );
       END IF;
     END LOOP;
     RETURN M;
   END mul_std_logic_vec;
--
   FUNCTION decstr_to_std_logic_vec( arg1 : STRING; size : INTEGER ) RETURN STD_LOGIC_VECTOR IS
     VARIABLE RESULT : STD_LOGIC_VECTOR(size-1 DOWNTO 0):= (OTHERS=>'0');
     VARIABLE BIN    : STD_LOGIC_VECTOR(3 DOWNTO 0);
     CONSTANT TEN    : STD_LOGIC_VECTOR(3 DOWNTO 0) := (3=>'1', 1=>'1', OTHERS=>'0');
     VARIABLE MULT10 : STD_LOGIC_VECTOR(size-1 DOWNTO 0) := conv_std_logic_vector(1, size);
     VARIABLE MULT   : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
   BEGIN 
     FOR i IN arg1'REVERSE_RANGE LOOP
       CASE arg1(i) IS
         WHEN '0' => BIN := (OTHERS=>'0');
         WHEN '1' => BIN := (0=>'1', OTHERS=>'0');
         WHEN '2' => BIN := (1=>'1', OTHERS=>'0');
         WHEN '3' => BIN := (0=>'1', 1=>'1', OTHERS=>'0');
         WHEN '4' => BIN := (2=>'1', OTHERS=>'0');
         WHEN '5' => BIN := (0=>'1', 2=>'1', OTHERS=>'0');
         WHEN '6' => BIN := (1=>'1', 2=>'1', OTHERS=>'0');
         WHEN '7' => BIN := (3=>'0', OTHERS=>'1');
         WHEN '8' => BIN := (3=>'1', OTHERS=>'0');
         WHEN '9' => BIN := (0=>'1', 3=>'1', OTHERS=>'0');
         WHEN OTHERS =>
           ASSERT FALSE 
             REPORT "NOT A DECIMAL CHARACTER" SEVERITY ERROR;
           RESULT := (OTHERS=>'X');
           RETURN RESULT;
       END CASE;
       MULT := mul_std_logic_vec( MULT10, BIN, size);
       RESULT := add_std_logic_vec( RESULT, MULT, size);
       MULT10 := mul_std_logic_vec( MULT10, TEN, size ); 
     END LOOP;
     RETURN RESULT;
   END decstr_to_std_logic_vec;
--
   FUNCTION binstr_to_std_logic_vec( arg1 : STRING; size : INTEGER ) RETURN STD_LOGIC_VECTOR IS
     VARIABLE RESULT : STD_LOGIC_VECTOR(size-1 DOWNTO 0):= (OTHERS=>'0');
     VARIABLE INDEX : INTEGER := 0;
   BEGIN
     FOR i IN arg1'REVERSE_RANGE LOOP
       CASE arg1(i) IS
         WHEN '0' => RESULT(INDEX) := '0';
         WHEN '1' => RESULT(INDEX) := '1';
         WHEN OTHERS =>
           ASSERT FALSE
             REPORT "NOT A BINARY CHARACTER" SEVERITY ERROR;
           RESULT(INDEX) := 'X';
       END CASE;
       INDEX := INDEX + 1;
     END LOOP;
     RETURN RESULT;
   END binstr_to_std_logic_vec; 
--
   FUNCTION hexstr_to_std_logic_vec( arg1 : STRING; size : INTEGER ) RETURN STD_LOGIC_VECTOR IS
     VARIABLE RESULT : STD_LOGIC_VECTOR(size-1 DOWNTO 0):= (OTHERS=> '0');
     VARIABLE BIN : STD_LOGIC_VECTOR(3 DOWNTO 0);
     VARIABLE INDEX : INTEGER := 0;
   BEGIN
     FOR i IN arg1'REVERSE_RANGE LOOP
       CASE arg1(i) IS
         WHEN '0' => BIN := (OTHERS=>'0');
         WHEN '1' => BIN := (0=>'1', OTHERS=>'0');
         WHEN '2' => BIN := (1=>'1', OTHERS=>'0');
         WHEN '3' => BIN := (0=>'1', 1=>'1', OTHERS=>'0');
         WHEN '4' => BIN := (2=>'1', OTHERS=>'0');
         WHEN '5' => BIN := (0=>'1', 2=>'1', OTHERS=>'0');
         WHEN '6' => BIN := (1=>'1', 2=>'1', OTHERS=>'0');
         WHEN '7' => BIN := (3=>'0', OTHERS=>'1');
         WHEN '8' => BIN := (3=>'1', OTHERS=>'0');
         WHEN '9' => BIN := (0=>'1', 3=>'1', OTHERS=>'0');
         WHEN 'A' => BIN := (0=>'0', 2=>'0', OTHERS=>'1');
         WHEN 'a' => BIN := (0=>'0', 2=>'0', OTHERS=>'1');
         WHEN 'B' => BIN := (2=>'0', OTHERS=>'1');
         WHEN 'b' => BIN := (2=>'0', OTHERS=>'1');
         WHEN 'C' => BIN := (0=>'0', 1=>'0', OTHERS=>'1');
         WHEN 'c' => BIN := (0=>'0', 1=>'0', OTHERS=>'1');
         WHEN 'D' => BIN := (1=>'0', OTHERS=>'1');
         WHEN 'd' => BIN := (1=>'0', OTHERS=>'1');
         WHEN 'E' => BIN := (0=>'0', OTHERS=>'1');
         WHEN 'e' => BIN := (0=>'0', OTHERS=>'1');
         WHEN 'F' => BIN := (OTHERS=>'1');
         WHEN 'f' => BIN := (OTHERS=>'1');
         WHEN OTHERS =>
           ASSERT FALSE
             REPORT "NOT A HEX CHARACTER" SEVERITY ERROR;
           FOR j IN 0 TO 3 LOOP
               BIN(j) := 'X';
           END LOOP;
       END CASE;
       FOR j IN 0 TO 3 LOOP
         IF (INDEX*4)+j < size THEN
           RESULT((INDEX*4)+j) := BIN(j);
         END IF;
       END LOOP;
       INDEX := INDEX + 1;
     END LOOP;
     RETURN RESULT;	
   END hexstr_to_std_logic_vec;
--
 BEGIN
 
 -- Startup section reads and/or writes mif file if necessary.
 
   IF (c_depth-c_reg_last_bit > 0) THEN
     IF (startup) THEN
     def_data(C_WIDTH-1 DOWNTO 0) := (OTHERS=>'0');
     CASE radix IS
       WHEN      3 =>
         def_data := decstr_to_std_logic_vec(C_DEFAULT_DATA, C_WIDTH);
       WHEN      2 => 
         def_data := binstr_to_std_logic_vec(C_DEFAULT_DATA, C_WIDTH);
       WHEN      1 => 
         def_data := hexstr_to_std_logic_vec(C_DEFAULT_DATA, C_WIDTH);
       WHEN OTHERS =>  
         ASSERT FALSE
           REPORT "BAD DATA RADIX" SEVERITY ERROR;
     END CASE;

     IF( C_READ_MIF = 1 ) THEN
       read_meminit_file(C_MEM_INIT_FILE, C_DEPTH, C_WIDTH, memdvect, lineno);
     END IF;
     offset := lineno*C_WIDTH;
     WHILE (lineno < C_DEPTH) LOOP
       FOR i IN 0 TO C_WIDTH-1 LOOP
         memdvect(offset+i) := def_data(i);
       END LOOP;
       lineno := lineno+1;
       offset := offset+C_WIDTH;
     END LOOP;
     spo_tmp := (OTHERS => '0');
     dpo_tmp := (OTHERS => '0');
	 
     IF (C_GENERATE_MIF = 1) THEN 
       write_meminit_file(C_MEM_INIT_FILE, C_DEPTH, C_WIDTH, memdvect, 0);
     END IF;
     
     FOR i in 0 to C_DEPTH -1-C_REG_LAST_BIT LOOP
        FOR j in 0 to C_WIDTH-1 LOOP
            shift(i)(j) := memdvect(j + i*C_WIDTH);
        END LOOP;
     END LOOP;
	 
     startup := FALSE;
      ELSE -- Not FIRST
        IF (CLK'event AND int_CE = '1' AND CLK'last_value = '0' AND CLK = '1') THEN -- rising edge!
            FOR i IN C_DEPTH-1-C_REG_LAST_BIT DOWNTO 1 LOOP
                shift(i) := shift(i-1);
            END LOOP;
            shift(0) := D;
        ELSIF (CLK'event AND (int_CE = 'X' OR 
                             (CLK'last_value = '0' AND CLK = 'X') OR 
                             (CLK'last_value = 'X' AND CLK = '1'))) THEN
            FOR i IN 0 TO C_DEPTH-1-C_REG_LAST_BIT LOOP
              shift(i) := (OTHERS => 'X');
            END LOOP;
        END IF;
        shift_out <= shift(C_DEPTH-1-C_REG_LAST_BIT);
      END IF;
    END IF;
  END PROCESS;
END GENERATE; 
  
  a1 : IF (C_HAS_A = 1) GENERATE
  	intA <= A;
  END GENERATE;
  a0 : IF (C_HAS_A = 0) GENERATE
  	intA <= conv_std_logic_vector(C_DEPTH-1, C_ADDR_WIDTH);
  END GENERATE;
  
  -- The lossless version is also fairly straight forward
  lossless : IF (C_SHIFT_TYPE = c_variable_lossless) GENERATE
      reged : IF (C_REG_LAST_BIT = 1) GENERATE
      qout : C_REG_FD_V2_0
        GENERIC MAP (C_AINIT_VAL     => C_AINIT_VAL,
                     C_HAS_ACLR      => C_HAS_ACLR,
                     C_HAS_AINIT     => C_HAS_AINIT,
                     C_HAS_ASET      => C_HAS_ASET,
                     C_HAS_CE        => C_HAS_CE,
                     C_HAS_SCLR      => C_HAS_SCLR,
                     C_HAS_SINIT     => C_HAS_SINIT,
                     C_HAS_SSET      => C_HAS_SSET,
                     C_SINIT_VAL     => C_SINIT_VAL,
                     C_SYNC_ENABLE   => C_SYNC_ENABLE,
                     C_SYNC_PRIORITY => C_SYNC_PRIORITY,
                     C_WIDTH         => C_WIDTH) 
        PORT MAP (D     => shift_out,
                  CLK   => CLK,
                  CE    => int_CE,
                  ACLR  => ACLR,
                  ASET  => ASET,
                  AINIT => AINIT,
                  SCLR  => SCLR,
                  SSET  => SSET,
                  SINIT => SINIT,
                  Q     => Q);     
    END GENERATE;
    unreg : IF NOT (C_REG_LAST_BIT = 1) GENERATE
      Q <= shift_out;
    END GENERATE;

    PROCESS (CLK, intA)
      variable rdeep : integer := getRealDepth(C_DEPTH);
      type     shifttype is array(0 to rdeep-1) of std_logic_vector(C_WIDTH-1 downto 0);
      variable first : boolean   := TRUE;
      variable shift : shifttype;
    
      CONSTANT mem_bits   : INTEGER := C_DEPTH * C_WIDTH;
   VARIABLE memdvect   : STD_LOGIC_VECTOR(mem_bits-1 DOWNTO 0);
   VARIABLE bits_good  : BOOLEAN;
   VARIABLE lineno     : INTEGER := 0;
   VARIABLE offset     : INTEGER := 0;
   VARIABLE def_data   : STD_LOGIC_VECTOR(C_WIDTH-1 DOWNTO 0);
   VARIABLE spo_tmp    : STD_LOGIC_VECTOR(C_WIDTH-1 DOWNTO 0);
   VARIABLE dpo_tmp    : STD_LOGIC_VECTOR(C_WIDTH-1 DOWNTO 0);
   VARIABLE srl_start  : INTEGER := 0;
   VARIABLE srl_end    : INTEGER := 0;
--		

   FUNCTION add_std_logic_vec( arg1, arg2 : STD_LOGIC_VECTOR; size : INTEGER ) RETURN STD_LOGIC_VECTOR IS
     VARIABLE S   : STD_LOGIC_VECTOR(size-1 DOWNTO 0) := (OTHERS=>'0');
     VARIABLE C   : STD_LOGIC_VECTOR(size-1 DOWNTO 0) := (OTHERS=>'0');
     VARIABLE A   : STD_LOGIC;
     VARIABLE B   : STD_LOGIC;
   BEGIN
   	 FOR i IN 0 TO size-2 LOOP
       IF( i < arg1'LENGTH ) THEN
         A := arg1(i);
       ELSE
         A := '0';
       END IF;
       IF( i < arg2'LENGTH ) THEN
         B := arg2(i);
       ELSE
         B := '0';
       END IF;
       S(i)   := A XOR B;
       C(i+1) := (A AND B) OR (S(i) AND C(i));
       S(i)   := S(i) XOR C(i);
     END LOOP;
     RETURN S;
   END add_std_logic_vec;
-- 
   FUNCTION mul_std_logic_vec( arg1, arg2 : STD_LOGIC_VECTOR; size : INTEGER ) RETURN STD_LOGIC_VECTOR IS
     VARIABLE M   : STD_LOGIC_VECTOR(size-1 DOWNTO 0) := (OTHERS=>'0');
     VARIABLE A   : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
   BEGIN
     FOR i IN 0 TO arg2'LENGTH-1 LOOP
       IF arg2(i) = '1' THEN
         A := (OTHERS=>'0');
         FOR j IN 0 TO arg1'LENGTH-1 LOOP
           IF( i+j < size ) THEN
             A(i+j) := arg1(j);
           END IF;
         END LOOP;
         M := add_std_logic_vec( M, A, size );
       END IF;
     END LOOP;
     RETURN M;
   END mul_std_logic_vec;
--
   FUNCTION decstr_to_std_logic_vec( arg1 : STRING; size : INTEGER ) RETURN STD_LOGIC_VECTOR IS
     VARIABLE RESULT : STD_LOGIC_VECTOR(size-1 DOWNTO 0):= (OTHERS=>'0');
     VARIABLE BIN    : STD_LOGIC_VECTOR(3 DOWNTO 0);
     CONSTANT TEN    : STD_LOGIC_VECTOR(3 DOWNTO 0) := (3=>'1', 1=>'1', OTHERS=>'0');
     VARIABLE MULT10 : STD_LOGIC_VECTOR(size-1 DOWNTO 0) := conv_std_logic_vector(1, size);
     VARIABLE MULT   : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
   BEGIN 
     FOR i IN arg1'REVERSE_RANGE LOOP
       CASE arg1(i) IS
         WHEN '0' => BIN := (OTHERS=>'0');
         WHEN '1' => BIN := (0=>'1', OTHERS=>'0');
         WHEN '2' => BIN := (1=>'1', OTHERS=>'0');
         WHEN '3' => BIN := (0=>'1', 1=>'1', OTHERS=>'0');
         WHEN '4' => BIN := (2=>'1', OTHERS=>'0');
         WHEN '5' => BIN := (0=>'1', 2=>'1', OTHERS=>'0');
         WHEN '6' => BIN := (1=>'1', 2=>'1', OTHERS=>'0');
         WHEN '7' => BIN := (3=>'0', OTHERS=>'1');
         WHEN '8' => BIN := (3=>'1', OTHERS=>'0');
         WHEN '9' => BIN := (0=>'1', 3=>'1', OTHERS=>'0');
         WHEN OTHERS =>
           ASSERT FALSE 
             REPORT "NOT A DECIMAL CHARACTER" SEVERITY ERROR;
           RESULT := (OTHERS=>'X');
           RETURN RESULT;
       END CASE;
       MULT := mul_std_logic_vec( MULT10, BIN, size);
       RESULT := add_std_logic_vec( RESULT, MULT, size);
       MULT10 := mul_std_logic_vec( MULT10, TEN, size ); 
     END LOOP;
     RETURN RESULT;
   END decstr_to_std_logic_vec;
--
   FUNCTION binstr_to_std_logic_vec( arg1 : STRING; size : INTEGER ) RETURN STD_LOGIC_VECTOR IS
     VARIABLE RESULT : STD_LOGIC_VECTOR(size-1 DOWNTO 0):= (OTHERS=>'0');
     VARIABLE INDEX : INTEGER := 0;
   BEGIN
     FOR i IN arg1'REVERSE_RANGE LOOP
       CASE arg1(i) IS
         WHEN '0' => RESULT(INDEX) := '0';
         WHEN '1' => RESULT(INDEX) := '1';
         WHEN OTHERS =>
           ASSERT FALSE
             REPORT "NOT A BINARY CHARACTER" SEVERITY ERROR;
           RESULT(INDEX) := 'X';
       END CASE;
       INDEX := INDEX + 1;
     END LOOP;
     RETURN RESULT;
   END binstr_to_std_logic_vec; 
--
   FUNCTION hexstr_to_std_logic_vec( arg1 : STRING; size : INTEGER ) RETURN STD_LOGIC_VECTOR IS
     VARIABLE RESULT : STD_LOGIC_VECTOR(size-1 DOWNTO 0):= (OTHERS=> '0');
     VARIABLE BIN : STD_LOGIC_VECTOR(3 DOWNTO 0);
     VARIABLE INDEX : INTEGER := 0;
   BEGIN
     FOR i IN arg1'REVERSE_RANGE LOOP
       CASE arg1(i) IS
         WHEN '0' => BIN := (OTHERS=>'0');
         WHEN '1' => BIN := (0=>'1', OTHERS=>'0');
         WHEN '2' => BIN := (1=>'1', OTHERS=>'0');
         WHEN '3' => BIN := (0=>'1', 1=>'1', OTHERS=>'0');
         WHEN '4' => BIN := (2=>'1', OTHERS=>'0');
         WHEN '5' => BIN := (0=>'1', 2=>'1', OTHERS=>'0');
         WHEN '6' => BIN := (1=>'1', 2=>'1', OTHERS=>'0');
         WHEN '7' => BIN := (3=>'0', OTHERS=>'1');
         WHEN '8' => BIN := (3=>'1', OTHERS=>'0');
         WHEN '9' => BIN := (0=>'1', 3=>'1', OTHERS=>'0');
         WHEN 'A' => BIN := (0=>'0', 2=>'0', OTHERS=>'1');
         WHEN 'a' => BIN := (0=>'0', 2=>'0', OTHERS=>'1');
         WHEN 'B' => BIN := (2=>'0', OTHERS=>'1');
         WHEN 'b' => BIN := (2=>'0', OTHERS=>'1');
         WHEN 'C' => BIN := (0=>'0', 1=>'0', OTHERS=>'1');
         WHEN 'c' => BIN := (0=>'0', 1=>'0', OTHERS=>'1');
         WHEN 'D' => BIN := (1=>'0', OTHERS=>'1');
         WHEN 'd' => BIN := (1=>'0', OTHERS=>'1');
         WHEN 'E' => BIN := (0=>'0', OTHERS=>'1');
         WHEN 'e' => BIN := (0=>'0', OTHERS=>'1');
         WHEN 'F' => BIN := (OTHERS=>'1');
         WHEN 'f' => BIN := (OTHERS=>'1');
         WHEN OTHERS =>
           ASSERT FALSE
             REPORT "NOT A HEX CHARACTER" SEVERITY ERROR;
           FOR j IN 0 TO 3 LOOP
               BIN(j) := 'X';
           END LOOP;
       END CASE;
       FOR j IN 0 TO 3 LOOP
         IF (INDEX*4)+j < size THEN
           RESULT((INDEX*4)+j) := BIN(j);
         END IF;
       END LOOP;
       INDEX := INDEX + 1;
     END LOOP;
     RETURN RESULT;	
   END hexstr_to_std_logic_vec;
--
 BEGIN
 
 -- Startup section reads and/or writes mif file if necessary.
 
   IF (first) THEN
     def_data(C_WIDTH-1 DOWNTO 0) := (OTHERS=>'0');
     CASE radix IS
       WHEN      3 =>
         def_data := decstr_to_std_logic_vec(C_DEFAULT_DATA, C_WIDTH);
       WHEN      2 => 
         def_data := binstr_to_std_logic_vec(C_DEFAULT_DATA, C_WIDTH);
       WHEN      1 => 
         def_data := hexstr_to_std_logic_vec(C_DEFAULT_DATA, C_WIDTH);
       WHEN OTHERS =>  
         ASSERT FALSE
           REPORT "BAD DATA RADIX" SEVERITY ERROR;
     END CASE;

     IF( C_READ_MIF = 1 ) THEN
       read_meminit_file(C_MEM_INIT_FILE, C_DEPTH, C_WIDTH, memdvect, lineno);
     END IF;
     offset := lineno*C_WIDTH;
     WHILE (lineno < C_DEPTH) LOOP
       FOR i IN 0 TO C_WIDTH-1 LOOP
         memdvect(offset+i) := def_data(i);
       END LOOP;
       lineno := lineno+1;
       offset := offset+C_WIDTH;
     END LOOP;
     spo_tmp := (OTHERS => '0');
     dpo_tmp := (OTHERS => '0');
	 
     IF (C_GENERATE_MIF = 1) THEN 
       write_meminit_file(C_MEM_INIT_FILE, C_DEPTH, C_WIDTH, memdvect, 0);
     END IF;
     
     FOR i in 0 to C_DEPTH -1 LOOP
        FOR j in 0 to C_WIDTH-1 LOOP
            shift(i)(j) := memdvect(j + i*C_WIDTH);
        END LOOP;
     END LOOP;
     IF (anyX(intA)) THEN
          shift_out <= (OTHERS => 'X');
        ELSIF (std_logic_vector_2_posint(intA) >= rdeep) THEN
          shift_out <= (OTHERS => 'X');	-- DLUNN MODIFIED FROM '0' FOR ILLEGAL ADDRESSING
        ELSE
          shift_out <= shift(std_logic_vector_2_posint(intA));
        END IF;
	 
     first := FALSE;
      ELSE -- Not FIRST
        IF (CLK'event AND int_CE = '1' AND CLK'last_value = '0' AND CLK = '1') THEN -- rising edge!
          FOR i IN rdeep-1 DOWNTO 1 LOOP
            shift(i) := shift(i-1);
          END LOOP;
          shift(0) := D;
        ELSIF (CLK'event AND (int_CE = 'X' OR 
                             (CLK'last_value = '0' AND CLK = 'X') OR 
                             (CLK'last_value = 'X' AND CLK = '1'))) THEN
          FOR i IN 0 TO rdeep-1 LOOP
            shift(i) := (OTHERS => 'X');
          END LOOP;
        END IF;
        IF (anyX(intA)) THEN
          shift_out <= (OTHERS => 'X');
        ELSIF (std_logic_vector_2_posint(intA) >= rdeep) THEN
          shift_out <= (OTHERS => 'X');	-- DLUNN MODIFIED FROM '0' FOR ILLEGAL ADDRESSING
        ELSE
          shift_out <= shift(std_logic_vector_2_posint(intA));
        END IF;
      END IF;
    END PROCESS;
  END GENERATE;
  
-- The lossy version requires some assesment of which value to
-- feed into the last sixteen locations.
  lossy : IF (C_SHIFT_TYPE = c_variable_lossy) GENERATE
      reged : IF (C_REG_LAST_BIT = 1) GENERATE
      qout : C_REG_FD_V2_0
        GENERIC MAP (C_AINIT_VAL     => C_AINIT_VAL,
                     C_HAS_ACLR      => C_HAS_ACLR,
                     C_HAS_AINIT     => C_HAS_AINIT,
                     C_HAS_ASET      => C_HAS_ASET,
                     C_HAS_CE        => C_HAS_CE,
                     C_HAS_SCLR      => C_HAS_SCLR,
                     C_HAS_SINIT     => C_HAS_SINIT,
                     C_HAS_SSET      => C_HAS_SSET,
                     C_SINIT_VAL     => C_SINIT_VAL,
                     C_SYNC_ENABLE   => C_SYNC_ENABLE,
                     C_SYNC_PRIORITY => C_SYNC_PRIORITY,
                     C_WIDTH         => C_WIDTH) 
        PORT MAP (D     => shift_out,
                  CLK   => CLK,
                  CE    => int_CE,
                  ACLR  => ACLR,
                  ASET  => ASET,
                  AINIT => AINIT,
                  SCLR  => SCLR,
                  SSET  => SSET,
                  SINIT => SINIT,
                  Q     => Q);     
    END GENERATE;
    unreg : IF NOT (C_REG_LAST_BIT = 1) GENERATE
      Q <= shift_out;
    END GENERATE;


    PROCESS (CLK, intA)
      variable rdeep : integer := getRealDepth(C_DEPTH);
      type     shifttype is array(0 to rdeep-1) of std_logic_vector(C_WIDTH-1 downto 0);
      variable first  : boolean   := TRUE;
      variable shift  : shifttype;
      variable last16 : integer;
      variable addtop : std_logic_vector(C_ADDR_WIDTH-1 DOWNTO 4*boolean'pos(C_ADDR_WIDTH>4));
      variable addlow : std_logic_vector(3 DOWNTO 0) := (others => '0');
      variable addti  : integer;
    CONSTANT mem_bits   : INTEGER := C_DEPTH * C_WIDTH;
   VARIABLE memdvect   : STD_LOGIC_VECTOR(mem_bits-1 DOWNTO 0);
   VARIABLE bits_good  : BOOLEAN;
   VARIABLE lineno     : INTEGER := 0;
   VARIABLE offset     : INTEGER := 0;
   VARIABLE def_data   : STD_LOGIC_VECTOR(C_WIDTH-1 DOWNTO 0);
   VARIABLE spo_tmp    : STD_LOGIC_VECTOR(C_WIDTH-1 DOWNTO 0);
   VARIABLE dpo_tmp    : STD_LOGIC_VECTOR(C_WIDTH-1 DOWNTO 0);
   VARIABLE srl_start  : INTEGER := 0;
   VARIABLE srl_end    : INTEGER := 0;
--		

   FUNCTION add_std_logic_vec( arg1, arg2 : STD_LOGIC_VECTOR; size : INTEGER ) RETURN STD_LOGIC_VECTOR IS
     VARIABLE S   : STD_LOGIC_VECTOR(size-1 DOWNTO 0) := (OTHERS=>'0');
     VARIABLE C   : STD_LOGIC_VECTOR(size-1 DOWNTO 0) := (OTHERS=>'0');
     VARIABLE A   : STD_LOGIC;
     VARIABLE B   : STD_LOGIC;
   BEGIN
   	 FOR i IN 0 TO size-2 LOOP
       IF( i < arg1'LENGTH ) THEN
         A := arg1(i);
       ELSE
         A := '0';
       END IF;
       IF( i < arg2'LENGTH ) THEN
         B := arg2(i);
       ELSE
         B := '0';
       END IF;
       S(i)   := A XOR B;
       C(i+1) := (A AND B) OR (S(i) AND C(i));
       S(i)   := S(i) XOR C(i);
     END LOOP;
     RETURN S;
   END add_std_logic_vec;
-- 
   FUNCTION mul_std_logic_vec( arg1, arg2 : STD_LOGIC_VECTOR; size : INTEGER ) RETURN STD_LOGIC_VECTOR IS
     VARIABLE M   : STD_LOGIC_VECTOR(size-1 DOWNTO 0) := (OTHERS=>'0');
     VARIABLE A   : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
   BEGIN
     FOR i IN 0 TO arg2'LENGTH-1 LOOP
       IF arg2(i) = '1' THEN
         A := (OTHERS=>'0');
         FOR j IN 0 TO arg1'LENGTH-1 LOOP
           IF( i+j < size ) THEN
             A(i+j) := arg1(j);
           END IF;
         END LOOP;
         M := add_std_logic_vec( M, A, size );
       END IF;
     END LOOP;
     RETURN M;
   END mul_std_logic_vec;
--
   FUNCTION decstr_to_std_logic_vec( arg1 : STRING; size : INTEGER ) RETURN STD_LOGIC_VECTOR IS
     VARIABLE RESULT : STD_LOGIC_VECTOR(size-1 DOWNTO 0):= (OTHERS=>'0');
     VARIABLE BIN    : STD_LOGIC_VECTOR(3 DOWNTO 0);
     CONSTANT TEN    : STD_LOGIC_VECTOR(3 DOWNTO 0) := (3=>'1', 1=>'1', OTHERS=>'0');
     VARIABLE MULT10 : STD_LOGIC_VECTOR(size-1 DOWNTO 0) := conv_std_logic_vector(1, size);
     VARIABLE MULT   : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
   BEGIN 
     FOR i IN arg1'REVERSE_RANGE LOOP
       CASE arg1(i) IS
         WHEN '0' => BIN := (OTHERS=>'0');
         WHEN '1' => BIN := (0=>'1', OTHERS=>'0');
         WHEN '2' => BIN := (1=>'1', OTHERS=>'0');
         WHEN '3' => BIN := (0=>'1', 1=>'1', OTHERS=>'0');
         WHEN '4' => BIN := (2=>'1', OTHERS=>'0');
         WHEN '5' => BIN := (0=>'1', 2=>'1', OTHERS=>'0');
         WHEN '6' => BIN := (1=>'1', 2=>'1', OTHERS=>'0');
         WHEN '7' => BIN := (3=>'0', OTHERS=>'1');
         WHEN '8' => BIN := (3=>'1', OTHERS=>'0');
         WHEN '9' => BIN := (0=>'1', 3=>'1', OTHERS=>'0');
         WHEN OTHERS =>
           ASSERT FALSE 
             REPORT "NOT A DECIMAL CHARACTER" SEVERITY ERROR;
           RESULT := (OTHERS=>'X');
           RETURN RESULT;
       END CASE;
       MULT := mul_std_logic_vec( MULT10, BIN, size);
       RESULT := add_std_logic_vec( RESULT, MULT, size);
       MULT10 := mul_std_logic_vec( MULT10, TEN, size ); 
     END LOOP;
     RETURN RESULT;
   END decstr_to_std_logic_vec;
--
   FUNCTION binstr_to_std_logic_vec( arg1 : STRING; size : INTEGER ) RETURN STD_LOGIC_VECTOR IS
     VARIABLE RESULT : STD_LOGIC_VECTOR(size-1 DOWNTO 0):= (OTHERS=>'0');
     VARIABLE INDEX : INTEGER := 0;
   BEGIN
     FOR i IN arg1'REVERSE_RANGE LOOP
       CASE arg1(i) IS
         WHEN '0' => RESULT(INDEX) := '0';
         WHEN '1' => RESULT(INDEX) := '1';
         WHEN OTHERS =>
           ASSERT FALSE
             REPORT "NOT A BINARY CHARACTER" SEVERITY ERROR;
           RESULT(INDEX) := 'X';
       END CASE;
       INDEX := INDEX + 1;
     END LOOP;
     RETURN RESULT;
   END binstr_to_std_logic_vec; 
--
   FUNCTION hexstr_to_std_logic_vec( arg1 : STRING; size : INTEGER ) RETURN STD_LOGIC_VECTOR IS
     VARIABLE RESULT : STD_LOGIC_VECTOR(size-1 DOWNTO 0):= (OTHERS=> '0');
     VARIABLE BIN : STD_LOGIC_VECTOR(3 DOWNTO 0);
     VARIABLE INDEX : INTEGER := 0;
   BEGIN
     FOR i IN arg1'REVERSE_RANGE LOOP
       CASE arg1(i) IS
         WHEN '0' => BIN := (OTHERS=>'0');
         WHEN '1' => BIN := (0=>'1', OTHERS=>'0');
         WHEN '2' => BIN := (1=>'1', OTHERS=>'0');
         WHEN '3' => BIN := (0=>'1', 1=>'1', OTHERS=>'0');
         WHEN '4' => BIN := (2=>'1', OTHERS=>'0');
         WHEN '5' => BIN := (0=>'1', 2=>'1', OTHERS=>'0');
         WHEN '6' => BIN := (1=>'1', 2=>'1', OTHERS=>'0');
         WHEN '7' => BIN := (3=>'0', OTHERS=>'1');
         WHEN '8' => BIN := (3=>'1', OTHERS=>'0');
         WHEN '9' => BIN := (0=>'1', 3=>'1', OTHERS=>'0');
         WHEN 'A' => BIN := (0=>'0', 2=>'0', OTHERS=>'1');
         WHEN 'a' => BIN := (0=>'0', 2=>'0', OTHERS=>'1');
         WHEN 'B' => BIN := (2=>'0', OTHERS=>'1');
         WHEN 'b' => BIN := (2=>'0', OTHERS=>'1');
         WHEN 'C' => BIN := (0=>'0', 1=>'0', OTHERS=>'1');
         WHEN 'c' => BIN := (0=>'0', 1=>'0', OTHERS=>'1');
         WHEN 'D' => BIN := (1=>'0', OTHERS=>'1');
         WHEN 'd' => BIN := (1=>'0', OTHERS=>'1');
         WHEN 'E' => BIN := (0=>'0', OTHERS=>'1');
         WHEN 'e' => BIN := (0=>'0', OTHERS=>'1');
         WHEN 'F' => BIN := (OTHERS=>'1');
         WHEN 'f' => BIN := (OTHERS=>'1');
         WHEN OTHERS =>
           ASSERT FALSE
             REPORT "NOT A HEX CHARACTER" SEVERITY ERROR;
           FOR j IN 0 TO 3 LOOP
               BIN(j) := 'X';
           END LOOP;
       END CASE;
       FOR j IN 0 TO 3 LOOP
         IF (INDEX*4)+j < size THEN
           RESULT((INDEX*4)+j) := BIN(j);
         END IF;
       END LOOP;
       INDEX := INDEX + 1;
     END LOOP;
     RETURN RESULT;	
   END hexstr_to_std_logic_vec;
--
 BEGIN
 
 -- Startup section reads and/or writes mif file if necessary.
 
   IF (first) THEN
     def_data(C_WIDTH-1 DOWNTO 0) := (OTHERS=>'0');
     CASE radix IS
       WHEN      3 =>
         def_data := decstr_to_std_logic_vec(C_DEFAULT_DATA, C_WIDTH);
       WHEN      2 => 
         def_data := binstr_to_std_logic_vec(C_DEFAULT_DATA, C_WIDTH);
       WHEN      1 => 
         def_data := hexstr_to_std_logic_vec(C_DEFAULT_DATA, C_WIDTH);
       WHEN OTHERS =>  
         ASSERT FALSE
           REPORT "BAD DATA RADIX" SEVERITY ERROR;
     END CASE;

     IF( C_READ_MIF = 1 ) THEN
       read_meminit_file(C_MEM_INIT_FILE, C_DEPTH, C_WIDTH, memdvect, lineno);
     END IF;
     offset := lineno*C_WIDTH;
     WHILE (lineno < C_DEPTH) LOOP
       FOR i IN 0 TO C_WIDTH-1 LOOP
         memdvect(offset+i) := def_data(i);
       END LOOP;
       lineno := lineno+1;
       offset := offset+C_WIDTH;
     END LOOP;
     spo_tmp := (OTHERS => '0');
     dpo_tmp := (OTHERS => '0');
	 
     IF (C_GENERATE_MIF = 1) THEN 
       write_meminit_file(C_MEM_INIT_FILE, C_DEPTH, C_WIDTH, memdvect, 0);
     END IF;
     
     FOR i in 0 to C_DEPTH -1 LOOP
        FOR j in 0 to C_WIDTH-1 LOOP
            shift(i)(j) := memdvect(j + i*C_WIDTH);
        END LOOP;
     END LOOP;
	 last16 := rdeep - 16;
      if(C_ADDR_WIDTH > 4) then
        	addlow := intA(3 DOWNTO 0);
      else
	        addlow(C_ADDR_WIDTH-1 DOWNTO 0) := intA;
      end if;
        IF (anyX(addlow)) THEN
          shift_out <= (OTHERS => 'X');
        ELSE
          shift_out <= shift(last16+std_logic_vector_2_posint(addlow));
        END IF;
     first := FALSE;
        ELSE -- Not FIRST
	    if(C_ADDR_WIDTH > 4) then
        	addtop := intA(C_ADDR_WIDTH-1 DOWNTO 4*boolean'pos(C_ADDR_WIDTH>4));
		addlow := intA(3 DOWNTO 0);
		else
	    		addlow(C_ADDR_WIDTH-1 DOWNTO 0) := intA;
			addtop := (others => '0');
		end if;
        IF (CLK'event AND int_CE = '1' AND CLK'last_value = '0' AND CLK = '1') THEN -- rising edge!
          FOR i IN rdeep-1 DOWNTO last16+1 LOOP
            shift(i) := shift(i-1);
          END LOOP;
          IF (anyX(addtop)) THEN
            shift(last16) := (OTHERS => 'X');
          ELSE
            addti := std_logic_vector_2_posint(addtop)*16;
            IF(addti >= rdeep) THEN
              shift(last16) := (OTHERS => 'X');	-- DLUNN MODIFIED FROM '0' FOR ILLEGAL ADDRESSING
            ELSIF(addti = 0) THEN
              shift(last16) := D;
            ELSE
              shift(last16) := shift(addti-1);
            END IF;
          END IF;
          FOR i IN last16-1 DOWNTO 1 LOOP
            shift(i) := shift(i-1);
          END LOOP;
          shift(0) := D;
        ELSIF (CLK'event AND (int_CE = 'X' OR 
                             (CLK'last_value = '0' AND CLK = 'X') OR 
                             (CLK'last_value = 'X' AND CLK = '1'))) THEN
          FOR i IN 0 TO rdeep-1 LOOP
            shift(i) := (OTHERS => 'X');
          END LOOP;
        END IF;
        IF (anyX(addlow)) THEN
          shift_out <= (OTHERS => 'X');
        ELSE
          shift_out <= shift(last16+std_logic_vector_2_posint(addlow));
        END IF;
      END IF;
    END PROCESS;
  END GENERATE;


END behavioral;
