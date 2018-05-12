-------------------------------------------------------------------------------
-- $RCSfile: fifo_generator_v4_1.vhd,v $ $Revision: 1.1 $ $Date: 2010-07-10 21:43:09 $
-------------------------------------------------------------------------------
--
-- FIFO Generator v4.1 - VHDL Behavioral Model
--
-------------------------------------------------------------------------------
--
-- Copyright(C) 2006 by Xilinx, Inc. All rights reserved.
-- This text/file contains proprietary, confidential
-- information of Xilinx, Inc., is distributed under
-- license from Xilinx, Inc., and may be used, copied
-- and/or disclosed only pursuant to the terms of a valid
-- license agreement with Xilinx, Inc. Xilinx hereby
-- grants you a license to use this text/file solely for
-- design, simulation, implementation and creation of
-- design files limited to Xilinx devices or technologies.
-- Use with non-Xilinx devices or technologies is expressly
-- prohibited and immediately terminates your license unless
-- covered by a separate agreement.
--
-- Xilinx is providing theis design, code, or information
-- "as-is" solely for use in developing programs and
-- solutions for Xilinx devices, with no obligation on the
-- part of Xilinx to provide support. By providing this design,
-- code, or information as one possible implementation of
-- this feature, application or standard. Xilinx is making no
-- representation that this implementation is free from any
-- claims of infringement. You are responsible for obtaining
-- any rights you may require for your implementation.
-- Xilinx expressly disclaims any warranty whatsoever with
-- respect to the adequacy of the implementation, including
-- but not limited to any warranties or representations that this
-- implementation is free from claims of infringement, implied
-- warranties of merchantability or fitness for a particular
-- purpose.
--
-- Xilinx products are not intended for use in life support
-- appliances, devices, or systems. Use in such applications is
-- expressly prohibited.
--
-- This copyright and support notice must be retained as part
-- of this text at all times. (c)Copyright 1995-2006 Xilinx, Inc.
-- All rights reserved.
--
-----------------------------------------------------------------------------
--
-- Filename   : fifo_generator_v4_1.vhd
-- Author     : Xilinx
-------------------------------------------------------------------------------
-- Structure:
-- fifo_generator_v4_1.vhd
--    |
--    +-fifo_generator_v4_1_bhv_as
--    |
--    +-fifo_generator_v4_1_bhv_ss
--    |
--    +-fifo_generator_v4_1_bhv_preload0
-------------------------------------------------------------------------------
-- Description:
-- The behavioral model for the FIFO Generator.
-------------------------------------------------------------------------------
-- History:
-- claireh  14 May 2007 - Update internal reset logics.
--                        Correct FWFT offsets.
--                        Fix PROG_FULL/EMPTY latency.
--                        Add comments.
-------------------------------------------------------------------------------


--#############################################################################
--  Asynchronous FIFO Behavioral Model
--#############################################################################

-------------------------------------------------------------------------------
-- Library Declaration
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.iputils_std_logic_unsigned.ALL;
USE XilinxCoreLib.iputils_std_logic_arith.ALL;
USE XilinxCoreLib.iputils_conv.ALL;
USE XilinxCoreLib.iputils_misc.ALL;

-------------------------------------------------------------------------------
-- Entity Declaration
-------------------------------------------------------------------------------
ENTITY fifo_generator_v4_1_bhv_as IS

  GENERIC (
    ---------------------------------------------------------------------------
    -- Generic Declarations
    ---------------------------------------------------------------------------
    C_MEMORY_TYPE                  :    integer := 1;
    C_HAS_RST                      :    integer := 1;
    C_DIN_WIDTH                    :    integer := 8;
    C_DOUT_RST_VAL                 :    string  := "";
    C_DOUT_WIDTH                   :    integer := 8;
    C_RD_DEPTH                     :    integer := 256;
    C_RD_PNTR_WIDTH                :    integer := 8;
    C_WR_DEPTH                     :    integer := 256;
    C_WR_PNTR_WIDTH                :    integer := 8;
    C_PRELOAD_REGS                 :    integer := 0;
    C_PRELOAD_LATENCY              :    integer := 1;
    C_HAS_ALMOST_FULL              :    integer := 0;
    C_HAS_ALMOST_EMPTY             :    integer := 0;
    C_PROG_EMPTY_TYPE              :    integer := 0;
    C_PROG_EMPTY_THRESH_ASSERT_VAL :    integer := 0;
    C_PROG_EMPTY_THRESH_NEGATE_VAL :    integer := 0;
    C_PROG_FULL_TYPE               :    integer := 0;
    C_PROG_FULL_THRESH_ASSERT_VAL  :    integer := 0;
    C_PROG_FULL_THRESH_NEGATE_VAL  :    integer := 0;
    C_HAS_VALID                    :    integer := 0;
    C_VALID_LOW                    :    integer := 0;
    C_HAS_WR_ACK                   :    integer := 0;
    C_WR_ACK_LOW                   :    integer := 0;
    C_HAS_UNDERFLOW                :    integer := 0;
    C_UNDERFLOW_LOW                :    integer := 0;
    C_HAS_OVERFLOW                 :    integer := 0;
    C_OVERFLOW_LOW                 :    integer := 0;
    C_HAS_RD_DATA_COUNT            :    integer := 2;
    C_RD_DATA_COUNT_WIDTH          :    integer := 0;
    C_HAS_WR_DATA_COUNT            :    integer := 2;
    C_WR_DATA_COUNT_WIDTH          :    integer := 0;
    C_FULL_FLAGS_RST_VAL           :    integer := 1;

    --obselete or redundant sim-parameters
    C_FAMILY                       :    string  := "";
    C_PRIM_FIFO_TYPE               :    string  := "4kx4";
    C_WR_RESPONSE_LATENCY          :    integer := 1;
    C_ENABLE_RLOCS                 :    integer := 0;
    C_OPTIMIZATION_MODE            :    integer := 0;
    C_USE_EMBEDDED_REG             :    integer := 0;
    C_USE_FWFT_DATA_COUNT          :    integer := 0
    );
  PORT(
    ---------------------------------------------------------------------------
    -- Input and Output Declarations
    ---------------------------------------------------------------------------
    --ALMOST_FULL was '1' in v3.1. Changed the start-up value to '0' 
    --in v3.2(IP2_Im) 
    --FULL was '1' in v3.1. Changed the start-up value to '0' in v3.2(IP2_Im) 
    --PROG_FULL was '1' in v3.1. Changed the start-up value to '0' 
    --in v3.2(IP2_Im) 
    RST                      : IN std_logic;
    DIN                      : IN std_logic_vector(C_DIN_WIDTH-1 DOWNTO 0);
    RD_CLK                   : IN std_logic;
    RD_EN                    : IN std_logic;
    WR_CLK                   : IN std_logic;
    WR_EN                    : IN std_logic;
    PROG_EMPTY_THRESH        : IN std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
    PROG_EMPTY_THRESH_ASSERT : IN std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
    PROG_EMPTY_THRESH_NEGATE : IN std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
    PROG_FULL_THRESH         : IN std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
    PROG_FULL_THRESH_ASSERT  : IN std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
    PROG_FULL_THRESH_NEGATE  : IN std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
    EMPTY                    : OUT std_logic := '1';
    FULL                     : OUT std_logic := '0'; 
    ALMOST_EMPTY             : OUT std_logic := '1';
    ALMOST_FULL              : OUT std_logic := '0'; 
    PROG_EMPTY               : OUT std_logic := '1';
    PROG_FULL                : OUT std_logic := '0'; 
    DOUT                     : OUT std_logic_vector(C_DOUT_WIDTH-1 DOWNTO 0);
    VALID                    : OUT std_logic := '0';
    WR_ACK                   : OUT std_logic := '0';
    UNDERFLOW                : OUT std_logic := '0';
    OVERFLOW                 : OUT std_logic := '0';
    RD_DATA_COUNT            : OUT std_logic_vector(C_RD_DATA_COUNT_WIDTH-1 DOWNTO 0)
                             := (OTHERS => '0');
    WR_DATA_COUNT            : OUT std_logic_vector(C_WR_DATA_COUNT_WIDTH-1 DOWNTO 0)
                             := (OTHERS => '0')
    );



END fifo_generator_v4_1_bhv_as;

-------------------------------------------------------------------------------
-- Definition of Ports
-- DIN          : Input data bus for the fifo.
-- DOUT         : Output data bus for the fifo.
-- AINIT        : Asynchronous Reset for the fifo.
-- WR_EN        : Write enable signal.
-- WR_CLK       : Write Clock.
-- FULL         : Full signal.
-- ALMOST_FULL  : One space left.
-- WR_ACK       : Last write acknowledged.
-- WR_ERR       : Last write rejected.
-- WR_COUNT     : Number of data words in fifo(synchronous to WR_CLK)
-- Rd_EN        : Read enable signal.
-- RD_CLK       : Read Clock.
-- EMPTY        : Empty signal.
-- ALMOST_EMPTY : One sapce left
-- VALID        : Last read acknowledged.
-- RD_ERR       : Last read rejected.
-- RD_COUNT     : Number of data words in fifo(synchronous to RD_CLK)
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Architecture Heading
-------------------------------------------------------------------------------
ARCHITECTURE behavioral OF fifo_generator_v4_1_bhv_as IS

  -----------------------------------------------------------------------------
  -- FUNCTION actual_fifo_depth
  -- Returns the actual depth of the FIFO (may differ from what the user 
  -- specified)
  --
  -- The FIFO depth is always represented as 2^n (16,32,64,128,256)
  -- However, the ACTUAL fifo depth may be 2^n+1 or 2^n-1 depending on certain
  -- options. This function returns the actual depth of the fifo, as seen by
  -- the user.
  -------------------------------------------------------------------------------
  FUNCTION actual_fifo_depth(
    C_FIFO_DEPTH : integer; 
    C_PRELOAD_REGS : integer; 
    C_PRELOAD_LATENCY : integer) 
  RETURN integer IS
  BEGIN
    RETURN C_FIFO_DEPTH - 1;
  END actual_fifo_depth;


  FUNCTION divroundup (
    data_value : integer;
    divisor : integer)
  RETURN integer IS
    VARIABLE div                   : integer;
  BEGIN
    div   := data_value/divisor;
    IF ( (data_value MOD divisor) /= 0) THEN
      div := div+1;
    END IF;
    RETURN div;
  END divroundup;


  FUNCTION int_2_std_logic(value : integer) RETURN std_logic IS
  BEGIN
    IF (value=1) THEN
      RETURN '1';
    ELSE
      RETURN '0';
    END IF;
  END int_2_std_logic; 

  -----------------------------------------------------------------------------
  -- Derived Constants
  -----------------------------------------------------------------------------
  CONSTANT C_FIFO_WR_DEPTH      : integer 
    := actual_fifo_depth(C_WR_DEPTH, C_PRELOAD_REGS, C_PRELOAD_LATENCY);
  CONSTANT C_FIFO_RD_DEPTH      : integer 
    := actual_fifo_depth(C_RD_DEPTH, C_PRELOAD_REGS, C_PRELOAD_LATENCY);
  CONSTANT C_SMALLER_DATA_WIDTH : integer 
    := get_lesser(C_DIN_WIDTH, C_DOUT_WIDTH);
  CONSTANT C_DEPTH_RATIO_WR     : integer 
    := if_then_else( (C_WR_DEPTH > C_RD_DEPTH), (C_WR_DEPTH/C_RD_DEPTH), 1);
  CONSTANT C_DEPTH_RATIO_RD     : integer 
    := if_then_else( (C_RD_DEPTH > C_WR_DEPTH), (C_RD_DEPTH/C_WR_DEPTH), 1);
  -- EXTRA_WORDS = 2 * C_DEPTH_RATIO_WR / C_DEPTH_RATIO_RD
  -- WR_DEPTH : RD_DEPTH = 1:2 => EXTRA_WORDS = 1
  -- WR_DEPTH : RD_DEPTH = 1:4 => EXTRA_WORDS = 1 (rounded to ceiling)
  -- WR_DEPTH : RD_DEPTH = 2:1 => EXTRA_WORDS = 4
  -- WR_DEPTH : RD_DEPTH = 4:1 => EXTRA_WORDS = 8
  CONSTANT EXTRA_WORDS          : integer := divroundup(2 * C_DEPTH_RATIO_WR, C_DEPTH_RATIO_RD);
  -- extra_words_dc = 2 * C_DEPTH_RATIO_WR / C_DEPTH_RATIO_RD
  --  C_DEPTH_RATIO_WR | C_DEPTH_RATIO_RD | C_PNTR_WIDTH    | EXTRA_WORDS_DC
  --  -----------------|------------------|-----------------|---------------
  --  1                | 8                | C_RD_PNTR_WIDTH | 2
  --  1                | 4                | C_RD_PNTR_WIDTH | 2
  --  1                | 2                | C_RD_PNTR_WIDTH | 2
  --  1                | 1                | C_WR_PNTR_WIDTH | 2
  --  2                | 1                | C_WR_PNTR_WIDTH | 4
  --  4                | 1                | C_WR_PNTR_WIDTH | 8
  --  8                | 1                | C_WR_PNTR_WIDTH | 16
  SIGNAL EXTRA_WORDS_DC    : integer
                           := if_then_else ((C_DEPTH_RATIO_WR=1),2
                              ,(2 * C_DEPTH_RATIO_WR/C_DEPTH_RATIO_RD));


  -------------------------------------------------------------------------------
  -- Signals Declaration
  -------------------------------------------------------------------------------
  SIGNAL wr_point       : integer   := 0;
  SIGNAL rd_point       : integer   := 0;
  SIGNAL wr_point_d1    : integer   := 0;
  SIGNAL rd_point_d1    : integer   := 0;
  SIGNAL num_wr_words   : integer   := 0;
  SIGNAL num_rd_words   : integer   := 0;
  SIGNAL adj_wr_point   : integer   := 0;
  SIGNAL adj_rd_point   : integer   := 0;
  SIGNAL adj_wr_point_d1: integer   := 0;
  SIGNAL adj_rd_point_d1: integer   := 0;

  SIGNAL empty_i        : std_logic := '1';
  SIGNAL full_i         : std_logic := '0';
  SIGNAL almost_empty_i : std_logic := '1';
  SIGNAL almost_full_i  : std_logic := '0';

  SIGNAL rd_rst_asreg    : std_logic:= '0';
  SIGNAL rd_rst_asreg_d1 : std_logic:= '0';
  SIGNAL rd_rst_asreg_d2 : std_logic:= '0';
  SIGNAL rd_rst_comb     : std_logic:= '0';
  SIGNAL rd_rst_reg      : std_logic:= '0';
  SIGNAL rd_rst_i        : std_logic:= '0';
  SIGNAL wr_rst_asreg    : std_logic:= '0';
  SIGNAL wr_rst_asreg_d1 : std_logic:= '0';
  SIGNAL wr_rst_asreg_d2 : std_logic:= '0';
  SIGNAL wr_rst_comb     : std_logic:= '0';
  SIGNAL wr_rst_reg      : std_logic:= '0';
  SIGNAL wr_rst_i        : std_logic:= '0';
  SIGNAL wr_rst_d1       : std_logic:= '0';

  SIGNAL wr_diff_count   : std_logic_vector(C_WR_PNTR_WIDTH DOWNTO 0) 
                         := (OTHERS => '0');
  SIGNAL rd_diff_count   : std_logic_vector(C_RD_PNTR_WIDTH DOWNTO 0) 
                         := (OTHERS => '0');

  SIGNAL wr_ack_i        : std_logic := '0';
  SIGNAL overflow_i      : std_logic := '0';
  SIGNAL valid_i         : std_logic := '0';
  SIGNAL valid_d1        : std_logic := '0';
  SIGNAL valid_out       : std_logic := '0';
  SIGNAL underflow_i     : std_logic := '0';


  SIGNAL prog_full_noreg   : std_logic := '0'; 
  SIGNAL prog_full_reg     : std_logic := '0';
  SIGNAL prog_empty_noreg  : std_logic := '1';
  SIGNAL prog_empty_reg    : std_logic := '1';
  SIGNAL dout_i            : std_logic_vector(C_DOUT_WIDTH-1 DOWNTO 0) 
                           := (OTHERS => '0');

  -------------------------------------------------------------------------------
  --Linked List types
  -------------------------------------------------------------------------------
  TYPE listtyp;
  TYPE listptr IS ACCESS listtyp;
  TYPE listtyp IS RECORD
      data  : std_logic_vector(C_SMALLER_DATA_WIDTH - 1 DOWNTO 0);
      older : listptr;
      newer : listptr;
    END RECORD;

  -------------------------------------------------------------------------------
  --Processes for linked list implementation. The functions are
  --1. Create a new linked list
  --2. Add a data element to a linked list
  --3. Read the data from the tail of the linked list
  --4. Remove the tail from the linked list
  --5. Calculate the size of the linked list
  -------------------------------------------------------------------------------
  --1. Create a new linked list
  PROCEDURE newlist (
    head : INOUT listptr; 
    tail : INOUT listptr) IS
  BEGIN
    head := NULL;
    tail := NULL;
  END;  

  --2. Add a data element to a linked list
  PROCEDURE add (
    head : INOUT listptr; 
    tail : INOUT listptr; 
    data : IN std_logic_vector) IS
    VARIABLE oldhead  :       listptr;
    VARIABLE newhead  :       listptr;
  BEGIN
    --------------------------------------------------------------------------
    --a. Create a pointer to the existing head, if applicable
    --b. Create a new node for the list
    --c. Make the new node point to the old head
    --d. Make the old head point back to the new node (for doubly-linked list)
    --e. Put the data into the new head node
    --f. If the new head we just created is the only node in the list, 
    --   make the tail point to it
    --g. Return the new head pointer
    --------------------------------------------------------------------------
    IF (head /= NULL) THEN
      oldhead       := head;
    END IF;
    newhead         := NEW listtyp;
    newhead.older   := oldhead;
    IF (head /= NULL) THEN
      oldhead.newer := newhead;
    END IF;
    newhead.data    := data;
    IF (newhead.older = NULL) THEN
      tail          := newhead;
    END IF;
    head            := newhead;
  END;  

  --3. Read the data from the tail of the linked list
  PROCEDURE read (
    tail : INOUT listptr; 
    data : OUT std_logic_vector) IS
  BEGIN
    data := tail.data;
  END;  

  --4. Remove the tail from the linked list
  PROCEDURE remove (
    head : INOUT listptr; 
    tail : INOUT listptr) IS
    VARIABLE oldtail     :       listptr;
    VARIABLE newtail     :       listptr;
  BEGIN
    --------------------------------------------------------------------------
    --Make a copy of the old tail pointer
    --a. If there is no newer node, then set the tail pointer to nothing 
    --   (list is empty)
    --   otherwise, make the next newer node the new tail, and make it point 
    --   to nothing older
    --b. Clean up the memory for the old tail node
    --c. If the new tail is nothing, then we have an empty list, and head 
    --   should also be set to nothing
    --d. Return the new tail
    --------------------------------------------------------------------------
    oldtail         := tail;
    IF (oldtail.newer = NULL) THEN
      newtail       := NULL;
    ELSE
      newtail       := oldtail.newer;
      newtail.older := NULL;
    END IF;
    DEALLOCATE(oldtail);
    IF (newtail = NULL) THEN
      head          := NULL;
    END IF;
    tail            := newtail;
  END; 


  --5. Calculate the size of the linked list
  PROCEDURE sizeof (head : INOUT listptr; size : OUT integer) IS
    VARIABLE curlink     :       listptr;
    VARIABLE tmpsize     :       integer := 0;
  BEGIN
    --------------------------------------------------------------------------
    --a. If head is null, then there is nothing in the list to traverse
    --   start with the head node (which implies at least one node exists)
    --   Loop through each node until you find the one that points to nothing 
    --   (the tail)
    --b. Return the number of nodes
    --------------------------------------------------------------------------
    IF (head /= NULL) THEN
      curlink                            := head;
      tmpsize                            := 1;
      WHILE (curlink.older /= NULL) LOOP
        tmpsize                          := tmpsize + 1;
        curlink                          := curlink.older;
      END LOOP;
    END IF;
    size                                 := tmpsize;
  END;  


  -----------------------------------------------------------------------------
  -- converts integer to specified length std_logic_vector : dropping least
  -- significant bits if integer is bigger than what can be represented by
  -- the vector
  -----------------------------------------------------------------------------
  FUNCTION count( 
    fifo_count    : IN integer;
    pointer_width : IN integer;
    counter_width : IN integer)
  RETURN std_logic_vector IS
    VARIABLE temp   :    std_logic_vector(pointer_width-1 DOWNTO 0)   
                    := (OTHERS => '0');
    VARIABLE output :    std_logic_vector(counter_width - 1 DOWNTO 0) 
                    := (OTHERS => '0');
  BEGIN
    temp     := CONV_STD_LOGIC_VECTOR(fifo_count, pointer_width);
    IF (counter_width <= pointer_width) THEN
      output := temp(pointer_width - 1 DOWNTO pointer_width - counter_width);
    ELSE
      output := temp(counter_width - 1 DOWNTO 0);
    END IF;
    RETURN output;
  END count;

-------------------------------------------------------------------------------
-- architecture begins here
-------------------------------------------------------------------------------
BEGIN
  -------------------------------------------------------------------------------
  -- If there is a reset input, generate internal reset signals
  -- The latency of reset will match the core behavior
  -------------------------------------------------------------------------------
  --Single RST
  grst : IF (C_HAS_RST=1) GENERATE
    PROCESS (WR_CLK, RST)
    BEGIN
      IF (RST = '1') THEN
        wr_rst_asreg <=   '1';
      ELSIF (WR_CLK'event and WR_CLK = '1') THEN
        IF (wr_rst_asreg_d1 = '1') THEN
          wr_rst_asreg <= '0';
        ELSE
          wr_rst_asreg <= wr_rst_asreg;
        END IF;
      END IF;
  
      IF (WR_CLK'event and WR_CLK = '1') THEN
        wr_rst_asreg_d1 <= wr_rst_asreg;
        wr_rst_asreg_d2 <= wr_rst_asreg_d1;
      END IF;
    END PROCESS;
    
    PROCESS (wr_rst_asreg, wr_rst_asreg_d2)
    BEGIN
      wr_rst_comb <= NOT wr_rst_asreg_d2 AND wr_rst_asreg;
    END PROCESS;
  
    PROCESS (WR_CLK, wr_rst_comb)
    BEGIN
      IF (wr_rst_comb = '1') THEN
        wr_rst_reg <= '1';
      ELSIF (WR_CLK'event and WR_CLK = '1') THEN
        wr_rst_reg <= '0';
      END IF;
    END PROCESS;
    
    PROCESS (RD_CLK, RST)
    BEGIN
      IF (RST = '1') THEN
        rd_rst_asreg <=   '1';
      ELSIF (RD_CLK'event and RD_CLK = '1') THEN
        IF (rd_rst_asreg_d1 = '1') THEN
          rd_rst_asreg <= '0';
        ELSE
          rd_rst_asreg <= rd_rst_asreg;
        END IF;
      END IF;
  
      IF (RD_CLK'event and RD_CLK = '1') THEN
        rd_rst_asreg_d1 <= rd_rst_asreg;
        rd_rst_asreg_d2 <= rd_rst_asreg_d1;
      END IF;
    END PROCESS;
    
    PROCESS (rd_rst_asreg, rd_rst_asreg_d2)
    BEGIN
      rd_rst_comb <= NOT rd_rst_asreg_d2 AND rd_rst_asreg;
    END PROCESS;
  
    PROCESS (RD_CLK, rd_rst_comb)
    BEGIN
      IF (rd_rst_comb = '1') THEN
        rd_rst_reg <= '1';
      ELSIF (RD_CLK'event and RD_CLK = '1') THEN
        rd_rst_reg <= '0';
      END IF;
    END PROCESS;
  
  
    wr_rst_i <= wr_rst_reg;
    rd_rst_i <= rd_rst_reg;

    PROCESS (WR_CLK, wr_rst_i)
    BEGIN
      IF (wr_rst_i='1') THEN
        wr_rst_d1 <= '1';
      ELSIF (WR_CLK'event AND WR_CLK = '1') THEN
        wr_rst_d1 <= wr_rst_i;
      END IF;
    END PROCESS;

  END GENERATE grst;
  
  -------------------------------------------------------------------------------
  -- No reset ports. Tie internal resets to zero.
  -------------------------------------------------------------------------------
  norst  : IF (C_HAS_RST=0) GENERATE
    rd_rst_i <= '0';
    wr_rst_i <= '0';
    wr_rst_d1<= '0';
  END GENERATE norst;
  
  -------------------------------------------------------------------------------
  -- calculate number of words in wr and rd domain according to the deepest port
  -------------------------------------------------------------------------------
  adj_wr_point   <= wr_point * C_DEPTH_RATIO_RD;
  adj_rd_point   <= rd_point * C_DEPTH_RATIO_WR;
  adj_wr_point_d1<= wr_point_d1 * C_DEPTH_RATIO_RD;
  adj_rd_point_d1<= rd_point_d1 * C_DEPTH_RATIO_WR;
  
  PROCESS (adj_wr_point, adj_wr_point_d1, adj_rd_point, adj_rd_point_d1)
  BEGIN
    IF (adj_wr_point >= adj_rd_point_d1) THEN
      num_wr_words <= adj_wr_point - adj_rd_point_d1;
    ELSE
      num_wr_words <= C_WR_DEPTH*C_DEPTH_RATIO_RD + adj_wr_point - adj_rd_point_d1;
    END IF;
    IF (adj_wr_point_d1 >= adj_rd_point) THEN
      num_rd_words <= adj_wr_point_d1 - adj_rd_point;
    ELSE
      num_rd_words <= C_RD_DEPTH*C_DEPTH_RATIO_WR + adj_wr_point_d1 - adj_rd_point;
    END IF;
  END PROCESS;
  -------------------------------------------------------------------------------
  --Calculate WR_ACK based on C_WR_ACK_LOW parameters
  -------------------------------------------------------------------------------
  gwalow : IF (C_WR_ACK_LOW = 0) GENERATE
    WR_ACK <= wr_ack_i;
  END GENERATE gwalow;
  
  gwahgh : IF (C_WR_ACK_LOW = 1) GENERATE
    WR_ACK <= NOT wr_ack_i;
  END GENERATE gwahgh;
  
  -------------------------------------------------------------------------------
  --Calculate OVERFLOW based on C_OVERFLOW_LOW parameters
  -------------------------------------------------------------------------------
  govlow : IF (C_OVERFLOW_LOW = 0) GENERATE
    OVERFLOW <= overflow_i;
  END GENERATE govlow;
  
  govhgh : IF (C_OVERFLOW_LOW = 1) GENERATE
    OVERFLOW <= NOT overflow_i;
  END GENERATE govhgh;
  
  -------------------------------------------------------------------------------
  --Calculate VALID based on C_VALID_LOW
  -------------------------------------------------------------------------------

  gnvl : IF (C_VALID_LOW = 0) GENERATE
    VALID <= valid_out;
  END GENERATE gnvl;
  
  gnvh : IF (C_VALID_LOW = 1) GENERATE
    VALID <= NOT valid_out;
  END GENERATE gnvh;
  
  -------------------------------------------------------------------------------
  --Calculate UNDERFLOW based on C_UNDERFLOW_LOW
  -------------------------------------------------------------------------------
  gnul  : IF (C_UNDERFLOW_LOW = 0) GENERATE
    UNDERFLOW <= underflow_i;
  END GENERATE gnul;
  
  gnuh  : IF (C_UNDERFLOW_LOW = 1) GENERATE
    UNDERFLOW <= NOT underflow_i;
  END GENERATE gnuh;
  
  -------------------------------------------------------------------------------
  --Assign PROG_FULL and PROG_EMPTY
  -------------------------------------------------------------------------------
  PROG_FULL <= prog_full_reg;
  PROG_EMPTY <= prog_empty_reg;
  
  -------------------------------------------------------------------------------
  --Assign RD_DATA_COUNT and WR_DATA_COUNT
  -------------------------------------------------------------------------------
  rdc: IF (C_HAS_RD_DATA_COUNT=1) GENERATE
    RD_DATA_COUNT <= rd_diff_count(C_RD_PNTR_WIDTH DOWNTO 
                                   C_RD_PNTR_WIDTH+1-C_RD_DATA_COUNT_WIDTH);
  END GENERATE rdc;

  nrdc: IF (C_HAS_RD_DATA_COUNT=0) GENERATE
    RD_DATA_COUNT <= (OTHERS=>'0');
  END GENERATE nrdc;
  
  wdc: IF (C_HAS_WR_DATA_COUNT=1) GENERATE
    WR_DATA_COUNT <= wr_diff_count(C_WR_PNTR_WIDTH DOWNTO 
                                   C_WR_PNTR_WIDTH+1-C_WR_DATA_COUNT_WIDTH);
  END GENERATE wdc;
  nwdc: IF (C_HAS_WR_DATA_COUNT=0) GENERATE
    WR_DATA_COUNT <= (OTHERS=>'0');
  END GENERATE nwdc;
  
  
  -------------------------------------------------------------------------------
  -- Assign FULL, EMPTY, ALMOST_FULL and ALMOST_EMPTY
  -------------------------------------------------------------------------------
  FULL          <= full_i;
  EMPTY         <= empty_i;
  ALMOST_FULL   <= almost_full_i;
  ALMOST_EMPTY  <= almost_empty_i;
  
  -------------------------------------------------------------------------------
  -- Asynchronous FIFO using linked lists
  -------------------------------------------------------------------------------
  FIFO_PROC : PROCESS (WR_CLK, RD_CLK, rd_rst_i, wr_rst_i)
  
    VARIABLE head : listptr;
    VARIABLE tail : listptr;
    VARIABLE size : integer                                     := 0;
  
    VARIABLE data : std_logic_vector(c_dout_width - 1 DOWNTO 0) 
      := hexstr_to_std_logic_vec( C_DOUT_RST_VAL, c_dout_width);
    VARIABLE prog_empty_actual_assert_thresh : integer := 0;
    VARIABLE prog_empty_actual_negate_thresh : integer := 0;
    VARIABLE prog_full_actual_assert_thresh : integer := 0;
    VARIABLE prog_full_actual_negate_thresh : integer := 0;
  
  BEGIN
  
    --Generate overflow_i because it doesn't support async rst
    IF WR_CLK'event AND WR_CLK = '1' THEN
      overflow_i  <= full_i AND WR_EN;
    END IF;

    --Calculate the current contents of the FIFO (size)
    -- Warning: This value should only be calculated once each time this
    -- process is entered. It is updated instantaneously.
    sizeof(head, size);
  
    -- RESET CONDITIONS
    IF wr_rst_i = '1' THEN
      wr_ack_i    <= '0';
  
      full_i          <= int_2_std_logic(C_FULL_FLAGS_RST_VAL);
      almost_full_i   <= int_2_std_logic(C_FULL_FLAGS_RST_VAL);
  
      wr_point    <= 0;
      wr_point_d1 <= 0;
      wr_diff_count <= (OTHERS => '0');
  
      prog_full_noreg <= int_2_std_logic(C_FULL_FLAGS_RST_VAL);
      prog_full_reg   <= int_2_std_logic(C_FULL_FLAGS_RST_VAL);
  
        --Create new linked list
      newlist(head, tail);
  
      --Clear data output queue
      data := hexstr_to_std_logic_vec(C_DOUT_RST_VAL, C_DOUT_WIDTH);
  
    ---------------------------------------------------------------------------
    -- Write to FIFO
    ---------------------------------------------------------------------------
    ELSIF WR_CLK'event AND WR_CLK = '1' THEN
  
      IF (wr_rst_d1='1' AND wr_rst_i='0') THEN
        prog_full_reg <= '0';
      ELSE
        prog_full_reg <= prog_full_noreg;
      END IF;

      wr_point_d1 <= wr_point;

      -------------------------------------------------------------------------
      --The following codes will genrate write data count without any clock
      --cross pointer latency.
      -------------------------------------------------------------------------
      --IF (C_USE_FWFT_DATA_COUNT=0) THEN
      --  wr_diff_count 
      --    <= conv_std_logic_vector((size/C_DEPTH_RATIO_RD), C_WR_PNTR_WIDTH) & '0';
      --ELSE
      --  wr_diff_count 
      --    <= conv_std_logic_vector(((size+EXTRA_WORDS_DC)/C_DEPTH_RATIO_RD), 
      --                             C_WR_PNTR_WIDTH+1);
      --END IF;
  
      -------------------------------------------------------------------------
      --The following codes will genrate write data count with one clock cycle
      --latency when read.
      -------------------------------------------------------------------------
      IF (C_USE_FWFT_DATA_COUNT=0) THEN
        IF (num_wr_words<1) THEN
          wr_diff_count<=(OTHERS=>'0');
        ELSE
          wr_diff_count 
          <= conv_std_logic_vector((1+(num_wr_words-1)/C_DEPTH_RATIO_RD), C_WR_PNTR_WIDTH) & '0';--do the roof of num_wr_words/C_DEPTH_RATIO_RD
        END IF;
      ELSE
        wr_diff_count 
          <= conv_std_logic_vector(((num_wr_words+EXTRA_WORDS_DC)/C_DEPTH_RATIO_RD), 
                                   C_WR_PNTR_WIDTH+1);
      END IF;
  
      --The following IF statement setup default values of full_i and almost_full_i.
      --The values might be overwritten in the next IF statement.
      IF (WR_EN = '1' and full_i = '0') THEN
        --If writing, then it is not possible to predict how many
        --words will actually be in the FIFO after the write concludes
        --(because the number of reads which happen in this time can
        -- not be determined).
        --Therefore, treat it pessimistically and always assume that
        -- the write will happen without a read (assume the FIFO is
        -- C_DEPTH_RATIO_RD fuller than it is).
        --Note:
        --1. size is the deepest depth between write depth and read depth
        --   size/C_DEPTH_RATIO_RD is number of words in the write domain.
        --2. size+C_DEPTH_RATIO_RD: number of write words in the next clock cycle
        --   if wr_en=1 (C_DEPTH_RATIO_RD=one write word)
        --3. For asymmetric FIFO, if write width is narrower than read width. Don't
        --   have to consider partial words.
        --4. For asymmetric FIFO, if read width is narrower than write width,
        --   the worse case that FIFO is going to full is depicted in the following 
        --   diagram. Both rd_pntr_a and rd_pntr_b will cause FIFO full. rd_pntr_a
        --   is the worse case. Therefore, in the calculation, actual FIFO depth is
        --   substarcted to one write word and added one read word.
        --              -------
        --              |  |  |
        --    wr_pntr-->|  |---
        --              |  |  |
        --              ---|---
        --              |  |  |
        --              |  |---
        --              |  |  |
        --              ---|---
        --              |  |  |<--rd_pntr_a
        --              |  |---
        --              |  |  |<--rd_pntr_b
        --              ---|---
        
        IF (size+C_DEPTH_RATIO_RD >= (C_FIFO_WR_DEPTH-1)*C_DEPTH_RATIO_RD+1) THEN
          full_i      <= '1';
          almost_full_i <= '1';
        ELSIF (size+C_DEPTH_RATIO_RD >= 
               (C_FIFO_WR_DEPTH-2)*C_DEPTH_RATIO_RD+1) THEN
          full_i      <= '0';
          almost_full_i <= '1';
        ELSE
          full_i      <= '0';
          almost_full_i <= '0';
        END IF;
  
      ELSE --IF (WR_EN='0' or full_i='1')
        --If not writing, then use the actual number of words in the FIFO
        -- to determine if the FIFO should be reporting FULL or not.
        IF (size >= (C_FIFO_WR_DEPTH-1)*C_DEPTH_RATIO_RD+1) THEN
          full_i      <= '1';
          almost_full_i <= '1';
        ELSIF (size >= (C_FIFO_WR_DEPTH-2)*C_DEPTH_RATIO_RD+1) THEN
          full_i      <= '0';
          almost_full_i <= '1';
        ELSE
          full_i      <= '0';
          almost_full_i <= '0';
        END IF;
  
      END IF;  --WR_EN
  
  
      -- Update full_i and almost_full_i if user is writing to the FIFO.
      -- Assign overflow and wr_ack.
      IF WR_EN = '1' THEN
  
        IF full_i /= '1' THEN
        -- User is writing to a FIFO which is NOT reporting FULL
  
          IF size/C_DEPTH_RATIO_RD = C_FIFO_WR_DEPTH THEN
            -- FIFO really is Full
            --Report Overflow and do not acknowledge the write
            wr_ack_i   <= '0';
  
          ELSIF size/C_DEPTH_RATIO_RD + 1 = C_FIFO_WR_DEPTH THEN
            -- FIFO is almost full
            -- This write will succeed, and FIFO will go FULL
            wr_ack_i   <= '1';
            full_i     <= '1';
            FOR h IN C_DEPTH_RATIO_RD DOWNTO 1 LOOP
              add(head, tail, 
              DIN((C_SMALLER_DATA_WIDTH*h)-1 DOWNTO C_SMALLER_DATA_WIDTH*(h-1)));
            END LOOP;
            wr_point   <= (wr_point + 1) MOD C_WR_DEPTH;
  
          ELSIF size/C_DEPTH_RATIO_RD + 2 = C_FIFO_WR_DEPTH THEN
            -- FIFO is one away from almost full
            -- This write will succeed, and FIFO will go almost_full_i
            wr_ack_i    <= '1';
            almost_full_i <= '1';
            FOR h IN C_DEPTH_RATIO_RD DOWNTO 1 LOOP
              add(head, tail, 
              DIN((C_SMALLER_DATA_WIDTH*h)-1 DOWNTO C_SMALLER_DATA_WIDTH*(h-1)));
            END LOOP;
            wr_point    <= (wr_point + 1) MOD C_WR_DEPTH;
  
          ELSE
            -- FIFO is no where near FULL
            --Write will succeed, no change in status
            wr_ack_i   <= '1';
            FOR h IN C_DEPTH_RATIO_RD DOWNTO 1 LOOP
              add(head, tail, 
              DIN((C_SMALLER_DATA_WIDTH*h)-1 DOWNTO C_SMALLER_DATA_WIDTH*(h-1)));
            END LOOP;
            wr_point   <= (wr_point + 1) MOD C_WR_DEPTH;
          END IF;
  
        ELSE --IF full_i = '1'
          -- User is writing to a FIFO which IS reporting FULL
          --Write will fail
          wr_ack_i   <= '0';
        END IF;  --full_i
  
      ELSE                              --WR_EN/='1'
        --No write attempted, so neither overflow or acknowledge
        wr_ack_i   <= '0';
      END IF;  --WR_EN
  
      -------------------------------------------------------------------------
      -- Programmable FULL flags
      -------------------------------------------------------------------------
      -- Determine the assert and negate thresholds for comparison
      -- (Subtract 2 read words when using Preload 0)
  
      --Single Constant Threshold
      IF (C_PROG_FULL_TYPE = 1) THEN
        --For FWFT FIFO
        IF (C_PRELOAD_REGS=1 AND C_PRELOAD_LATENCY=0) THEN
          prog_full_actual_assert_thresh := C_PROG_FULL_THRESH_ASSERT_VAL-EXTRA_WORDS;
          prog_full_actual_negate_thresh := C_PROG_FULL_THRESH_ASSERT_VAL-EXTRA_WORDS;
        ELSE
          prog_full_actual_assert_thresh := C_PROG_FULL_THRESH_ASSERT_VAL;
          prog_full_actual_negate_thresh := C_PROG_FULL_THRESH_ASSERT_VAL;
        END IF;
  
  
        --Dual Constant Thresholds
      ELSIF (C_PROG_FULL_TYPE = 2) THEN
        IF (C_PRELOAD_REGS=1 AND C_PRELOAD_LATENCY=0) THEN
          prog_full_actual_assert_thresh := C_PROG_FULL_THRESH_ASSERT_VAL-EXTRA_WORDS;
          prog_full_actual_negate_thresh := C_PROG_FULL_THRESH_NEGATE_VAL-EXTRA_WORDS;
        ELSE
          prog_full_actual_assert_thresh := C_PROG_FULL_THRESH_ASSERT_VAL;
          prog_full_actual_negate_thresh := C_PROG_FULL_THRESH_NEGATE_VAL;
        END IF;
  
        --Single threshold input port
      ELSIF (C_PROG_FULL_TYPE = 3) THEN
        IF (C_PRELOAD_REGS=1 AND C_PRELOAD_LATENCY=0) THEN
          prog_full_actual_assert_thresh := conv_integer(PROG_FULL_THRESH)-EXTRA_WORDS;
          prog_full_actual_negate_thresh := conv_integer(PROG_FULL_THRESH)-EXTRA_WORDS;
        ELSE
          prog_full_actual_assert_thresh := conv_integer(PROG_FULL_THRESH);
          prog_full_actual_negate_thresh := conv_integer(PROG_FULL_THRESH);
        END IF;
  
        --Dual threshold input ports
      ELSIF (C_PROG_FULL_TYPE = 4) THEN
        IF (C_PRELOAD_REGS=1 AND C_PRELOAD_LATENCY=0) THEN
          prog_full_actual_assert_thresh := conv_integer(PROG_FULL_THRESH_ASSERT)-EXTRA_WORDS;
          prog_full_actual_negate_thresh := conv_integer(PROG_FULL_THRESH_NEGATE)-EXTRA_WORDS;
        ELSE
          prog_full_actual_assert_thresh := conv_integer(PROG_FULL_THRESH_ASSERT);
          prog_full_actual_negate_thresh := conv_integer(PROG_FULL_THRESH_NEGATE);
        END IF;
  
      END IF;  --C_PROG_FULL_TYPE
  
  
      -- If we will be going at or above the prog_full_actual_assert_thresh threshold
      -- on the next clock cycle, then assert PROG_FULL
  
      -- WARNING: For the fifo with separate clocks, it is possible that
      -- the core could be both reading and writing simultaneously, with
      -- the writes occuring faster. This means that the number of words
      -- in the FIFO is increasing, and PROG_FULL should be asserted. So,
      -- we assume the worst and assert PROG_FULL if we are close and
      -- writing, since RD_EN may or may not have an impact on the number
      -- of words in the FIFO.
      IF (((1+(size-1)/C_DEPTH_RATIO_RD) = prog_full_actual_assert_thresh-1) AND WR_EN = '1') THEN
        prog_full_noreg <= '1';
  
      -- If we are at or above the prog_full_actual_assert_thresh, then assert
      -- PROG_FULL
      ELSIF ((1+(size-1)/C_DEPTH_RATIO_RD) >= prog_full_actual_assert_thresh) THEN
        prog_full_noreg <= '1';
  
      --If we are below the prog_full_actual_negate_thresh, then de-assert PROG_FULL
      ELSIF ((1+(size-1)/C_DEPTH_RATIO_RD) <prog_full_actual_negate_thresh) THEN
        prog_full_noreg <= '0';
      END IF;
  
    END IF;  --WR_CLK
  
    ---------------------------------------------------------------------------
    -- Read from FIFO
    ---------------------------------------------------------------------------
    --Generate underflow_i seperately. Because it doesn't have async. rst.
    IF RD_CLK'event AND RD_CLK = '1' THEN
      underflow_i       <= empty_i AND RD_EN;
    END IF;

    IF rd_rst_i = '1' THEN
      -- Whenever user is attempting to read from
      -- an EMPTY FIFO, the core should report an underflow error, even if
      -- the core is in a RESET condition.
      valid_i           <= '0';
      valid_d1          <= '0';
      empty_i           <= '1';
      almost_empty_i    <= '1';
  
      rd_point          <= 0;
      rd_point_d1       <= 0;
      rd_diff_count     <= (OTHERS => '0');
  
      prog_empty_noreg  <= '1';
      prog_empty_reg    <= '1';
  
      --Clear data output queue
      data := hexstr_to_std_logic_vec(C_DOUT_RST_VAL, C_DOUT_WIDTH);
  
    ELSIF RD_CLK'event AND RD_CLK = '1' THEN
  
      valid_i     <= '0';
      valid_d1    <= valid_i;
      prog_empty_reg <= prog_empty_noreg;
      rd_point_d1 <= rd_point;
      
      ------------------------------------------------------------------------- 
      --No cross clock signal latency
      ------------------------------------------------------------------------- 
      IF (C_USE_FWFT_DATA_COUNT=0) THEN
        rd_diff_count <= 
          conv_std_logic_vector((size/C_DEPTH_RATIO_WR), C_RD_PNTR_WIDTH)
          & '0'; --Pad 0 in LSB
      ELSE
        rd_diff_count <= 
          conv_std_logic_vector(((size/C_DEPTH_RATIO_WR)+2), C_RD_PNTR_WIDTH+1);
      END IF;
  
      ------------------------------------------------------------------------- 
      --One clock delay for write operation
      IF (C_USE_FWFT_DATA_COUNT=0) THEN
        rd_diff_count <= 
          conv_std_logic_vector((num_rd_words/C_DEPTH_RATIO_WR), C_RD_PNTR_WIDTH)
          & '0'; --Pad 0 in LSB
      ELSE
        rd_diff_count <= 
          conv_std_logic_vector(((num_rd_words/C_DEPTH_RATIO_WR)+2), C_RD_PNTR_WIDTH+1);
      END IF;
      ---------------------------------------------------------------------------
      -- Read Latency 1
      ---------------------------------------------------------------------------
  
      --The following IF statement setup default values of empty_i and 
      --almost_empty_i. The values might be overwritten in the next IF statement.
      --Note:
      --size/C_DEPTH_RATIO_WR : number of words in read domain.

      IF size/C_DEPTH_RATIO_WR = 0 THEN
        empty_i        <= '1';
        almost_empty_i <= '1';
      ELSIF size/C_DEPTH_RATIO_WR = 1 THEN
        empty_i        <= '0';
        almost_empty_i <= '1';
      ELSE
        empty_i        <= '0';
        almost_empty_i <= '0';
      END IF;
  
      IF RD_EN = '1' THEN
  
        IF empty_i /= '1' THEN
          IF size/C_DEPTH_RATIO_WR = 2 THEN
            --FIFO is going almost empty
            almost_empty_i <= '1';
            valid_i      <= '1';
            FOR h IN C_DEPTH_RATIO_WR DOWNTO 1 LOOP
              read(tail, 
              data((C_SMALLER_DATA_WIDTH*h)-1 DOWNTO C_SMALLER_DATA_WIDTH*(h-1)));
              remove(head, tail);
            END LOOP;
            rd_point     <= (rd_point + 1) MOD C_RD_DEPTH;
          
          ELSIF size/C_DEPTH_RATIO_WR = 1 THEN
            --FIFO is going empty
            almost_empty_i <= '1';
            empty_i      <= '1';
            valid_i      <= '1';
            FOR h IN C_DEPTH_RATIO_WR DOWNTO 1 LOOP
              read(tail, 
              data((C_SMALLER_DATA_WIDTH*h)-1 DOWNTO C_SMALLER_DATA_WIDTH*(h-1)));
              remove(head, tail);
            END LOOP;
            rd_point     <= (rd_point + 1) MOD C_RD_DEPTH;
  
          ELSIF size/C_DEPTH_RATIO_WR = 0 THEN
          --FIFO is empty
  
          ELSE
          --FIFO is not empty
            valid_i      <= '1';
            FOR h IN C_DEPTH_RATIO_WR DOWNTO 1 LOOP
              read(tail, 
              data((C_SMALLER_DATA_WIDTH*h)-1 DOWNTO C_SMALLER_DATA_WIDTH*(h-1)));
              remove(head, tail);
            END LOOP;
            rd_point     <= (rd_point + 1) MOD C_RD_DEPTH;
          END IF;
        ELSE
          --FIFO is empty
        END IF;
  
      END IF;  --RD_EN
  
      ---------------------------------------------------------------------------
      -- Programmable EMPTY Flags
      ---------------------------------------------------------------------------
      -- Determine the assert and negate thresholds for comparison
      -- (Subtract 2 read words when using Preload 0)
  
      --Single Constant Threshold
      IF (C_PROG_EMPTY_TYPE = 1) THEN
        --For FWFT FIFO
        IF (C_PRELOAD_REGS=1 AND C_PRELOAD_LATENCY=0) THEN
          prog_empty_actual_assert_thresh := C_PROG_EMPTY_THRESH_ASSERT_VAL - 2;
          prog_empty_actual_negate_thresh := C_PROG_EMPTY_THRESH_ASSERT_VAL - 2;
        ELSE
          prog_empty_actual_assert_thresh := C_PROG_EMPTY_THRESH_ASSERT_VAL;
          prog_empty_actual_negate_thresh := C_PROG_EMPTY_THRESH_ASSERT_VAL;
        END IF;
  
      --Dual constant thresholds
      ELSIF (C_PROG_EMPTY_TYPE = 2) THEN
        IF (C_PRELOAD_REGS=1 AND C_PRELOAD_LATENCY=0) THEN
          prog_empty_actual_assert_thresh := C_PROG_EMPTY_THRESH_ASSERT_VAL - 2;
          prog_empty_actual_negate_thresh := C_PROG_EMPTY_THRESH_NEGATE_VAL - 2;
        ELSE
          prog_empty_actual_assert_thresh := C_PROG_EMPTY_THRESH_ASSERT_VAL;
          prog_empty_actual_negate_thresh := C_PROG_EMPTY_THRESH_NEGATE_VAL;
        END IF;
  
      --Single threshold input port
      ELSIF (C_PROG_EMPTY_TYPE = 3) THEN
        IF (C_PRELOAD_REGS=1 AND C_PRELOAD_LATENCY=0) THEN
          prog_empty_actual_assert_thresh := conv_integer(PROG_EMPTY_THRESH) - 2;
          prog_empty_actual_negate_thresh := conv_integer(PROG_EMPTY_THRESH) - 2;
        ELSE
          prog_empty_actual_assert_thresh := conv_integer(PROG_EMPTY_THRESH);
          prog_empty_actual_negate_thresh := conv_integer(PROG_EMPTY_THRESH);
        END IF;
  
      --Dual threshold input ports
      ELSIF (C_PROG_EMPTY_TYPE = 4) THEN
        IF (C_PRELOAD_REGS=1 AND C_PRELOAD_LATENCY=0) THEN
          prog_empty_actual_assert_thresh := conv_integer(PROG_EMPTY_THRESH_ASSERT) - 2;
          prog_empty_actual_negate_thresh := conv_integer(PROG_EMPTY_THRESH_NEGATE) - 2;
        ELSE
          prog_empty_actual_assert_thresh := conv_integer(PROG_EMPTY_THRESH_ASSERT);
          prog_empty_actual_negate_thresh := conv_integer(PROG_EMPTY_THRESH_NEGATE);
        END IF;
  
      END IF;
  
  
      -- If we will be going at or below the prog_empty_actual_assert_thresh threshold
      -- on the next clock cycle, then assert PROG_EMPTY
      --
      -- WARNING: For the fifo with separate clocks, it is possible that
      -- the core could be both reading and writing simultaneously, with
      -- the reads occuring faster. This means that the number of words
      -- in the FIFO is decreasing, and PROG_EMPTY should be asserted. So,
      -- we assume the worst and assert PROG_EMPTY if we are close and
      -- reading, since WR_EN may or may not have an impact on the number
      -- of words in the FIFO.
      IF ((size/C_DEPTH_RATIO_WR = prog_empty_actual_assert_thresh+1) AND RD_EN = '1') THEN
        prog_empty_noreg <= '1';
  
        -- If we are at or below the prog_empty_actual_assert_thresh, then assert
        -- PROG_EMPTY
      ELSIF (size/C_DEPTH_RATIO_WR <= prog_empty_actual_assert_thresh) THEN
        prog_empty_noreg          <= '1';
  
        --If we are above the prog_empty_actual_negate_thresh, then de-assert PROG_EMPTY
      ELSIF (size/C_DEPTH_RATIO_WR > prog_empty_actual_negate_thresh) THEN
        prog_empty_noreg <= '0';
      END IF;
  
    END IF;  --RD_CLK
  
    dout_i <= data;
  
  END PROCESS;

  
  -----------------------------------------------------------------------------
  --Use delayed Valid AND DOUT 
  --if C_MEMORY_TYPE=0 or 1, C_PRELOAD_REGS=0, C_USE_EMBEDDED_REG=1
  -----------------------------------------------------------------------------
  gv0: IF (C_PRELOAD_LATENCY=2 
           AND (C_MEMORY_TYPE=0 OR C_MEMORY_TYPE=1)) GENERATE

    valid_out <= valid_d1;

    PROCESS (rd_rst_i  , RD_CLK  )
    BEGIN
      IF (rd_rst_i   = '1') THEN
        DOUT     <= hexstr_to_std_logic_vec(C_DOUT_RST_VAL, C_DOUT_WIDTH);
      ELSIF (RD_CLK  'event AND RD_CLK   = '1') THEN
        DOUT     <= dout_i;
      END IF;
    END PROCESS;
  END GENERATE gv0;
  gv1: IF NOT(C_PRELOAD_LATENCY=2 
              AND (C_MEMORY_TYPE=0 OR C_MEMORY_TYPE=1)) GENERATE
    valid_out<= valid_i;
    DOUT     <= dout_i;
  END GENERATE gv1;

END behavioral;


--#############################################################################
--  Synchronous FIFO Behavioral Model
--#############################################################################

-------------------------------------------------------------------------------
-- Library Declaration
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.iputils_std_logic_unsigned.ALL;
USE XilinxCoreLib.iputils_std_logic_arith.ALL;
USE XilinxCoreLib.iputils_conv.ALL;
USE XilinxCoreLib.iputils_misc.ALL;

-------------------------------------------------------------------------------
-- Entity Declaration
-------------------------------------------------------------------------------
ENTITY fifo_generator_v4_1_bhv_ss IS

  GENERIC (
    --------------------------------------------------------------------------------
    -- Generic Declarations (alphabetical)
    --------------------------------------------------------------------------------
    C_COMMON_CLOCK          : integer := 0;  
    C_FAMILY                : string  := "virtex2";  
    C_MEMORY_TYPE           : integer := 1;  
    C_HAS_RST               : integer := 0;  
    C_HAS_SRST              : integer := 0;  
    C_PRELOAD_REGS          : integer := 0;  
    C_PRELOAD_LATENCY       : integer := 1;  
    C_DIN_WIDTH             : integer := 8;  
    C_DOUT_WIDTH            : integer := 8;  
    C_DOUT_RST_VAL          : string  := ""; 
    C_RD_DEPTH              : integer := 256;
    C_RD_PNTR_WIDTH         : integer := 8;  
    C_WR_DEPTH              : integer := 256;
    C_WR_PNTR_WIDTH         : integer := 8;  
    C_HAS_ALMOST_EMPTY      : integer := 0;  
    C_HAS_ALMOST_FULL       : integer := 0;  
    C_PROG_EMPTY_TYPE              : integer := 0;
    C_PROG_EMPTY_THRESH_ASSERT_VAL : integer := 0;
    C_PROG_EMPTY_THRESH_NEGATE_VAL : integer := 0;
    C_PROG_FULL_TYPE               : integer := 0;
    C_PROG_FULL_THRESH_ASSERT_VAL  : integer := 0;
    C_PROG_FULL_THRESH_NEGATE_VAL  : integer := 0;
    C_HAS_WR_ACK            : integer := 0;  
    C_WR_ACK_LOW            : integer := 0;  
    C_HAS_OVERFLOW          : integer := 0;  
    C_OVERFLOW_LOW          : integer := 0;  
    C_HAS_VALID             : integer := 0;  
    C_VALID_LOW             : integer := 0;  
    C_HAS_UNDERFLOW         : integer := 0;  
    C_UNDERFLOW_LOW         : integer := 0;  
    C_HAS_DATA_COUNT        : integer := 0;  
    C_DATA_COUNT_WIDTH      : integer := 2;  
    C_FULL_FLAGS_RST_VAL    : integer := 1;
    C_USE_EMBEDDED_REG      : integer := 0;

    --obselete or redundant sim-parameters
    C_HAS_RD_RST            : integer := 0;  
    C_HAS_WR_RST            : integer := 0;  
    C_COUNT_TYPE            : integer := 0;  
    C_DEFAULT_VALUE         : string  := ""; 
    C_ENABLE_RLOCS          : integer := 0;  
    C_HAS_BACKUP            : integer := 0;  
    C_HAS_MEMINIT_FILE      : integer := 0;  
    C_HAS_RD_DATA_COUNT     : integer := 0;  
    C_RD_DATA_COUNT_WIDTH   : integer := 2;  
    C_HAS_WR_DATA_COUNT     : integer := 0;  
    C_WR_DATA_COUNT_WIDTH   : integer := 2;  
    C_INIT_WR_PNTR_VAL      : integer := 0;  
    C_OPTIMIZATION_MODE     : integer := 0;  
    C_MIF_FILE_NAME         : string  := ""; 
    C_WR_RESPONSE_LATENCY   : integer := 1  
    );


  PORT(
    --------------------------------------------------------------------------------
    -- Input and Output Declarations
    --------------------------------------------------------------------------------
    --ALMOST_FULL was '1' in v3.1. Changed the start-up value to '0' in v3.2 (IP2_Im)
    --FULL was '1' in v3.1. Changed the start-up value to '0' in v3.2 (IP2_Im)
    --PROG_FULL was '1' in v3.1. Changed the start-up value to '0' in v3.2 (IP2_Im)
    CLK                      : IN std_logic   := '0';
    RST                      : IN std_logic   := '0';
    SRST                     : IN std_logic   := '0';
    DIN                      : IN std_logic_vector(C_DIN_WIDTH-1 DOWNTO 0)     
                             := (OTHERS => '0');
    RD_EN                    : IN std_logic   := '0';
    WR_EN                    : IN std_logic   := '0';
    PROG_EMPTY_THRESH        : IN std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) 
                             := (OTHERS => '0');
    PROG_EMPTY_THRESH_ASSERT : IN std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) 
                             := (OTHERS => '0');
    PROG_EMPTY_THRESH_NEGATE : IN std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) 
                             := (OTHERS => '0');
    PROG_FULL_THRESH         : IN std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) 
                             := (OTHERS => '0');
    PROG_FULL_THRESH_ASSERT  : IN std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) 
                             := (OTHERS => '0');
    PROG_FULL_THRESH_NEGATE  : IN std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) 
                             := (OTHERS => '0');

    DOUT          : OUT std_logic_vector(C_DOUT_WIDTH-1 DOWNTO 0);
    EMPTY         : OUT std_logic := '1';
    FULL          : OUT std_logic := '0'; 
    ALMOST_EMPTY  : OUT std_logic := '1';
    ALMOST_FULL   : OUT std_logic := '0'; 
    PROG_EMPTY    : OUT std_logic := '1';
    PROG_FULL     : OUT std_logic := '0'; 
    OVERFLOW      : OUT std_logic := '0';
    WR_ACK        : OUT std_logic := '0';
    VALID         : OUT std_logic := '0';
    UNDERFLOW     : OUT std_logic := '0';
    DATA_COUNT    : OUT std_logic_vector(C_DATA_COUNT_WIDTH-1 DOWNTO 0) 
                  :=    (OTHERS => '0');

    --obselete or redundant ports
    RD_CLK        : IN std_logic  := '0';
    WR_CLK        : IN std_logic  := '0';
    RD_RST        : IN std_logic  := '0';
    WR_RST        : IN std_logic  := '0';
    RD_DATA_COUNT : OUT std_logic_vector(C_RD_DATA_COUNT_WIDTH-1 DOWNTO 0) 
                  :=   (OTHERS => '0');
    WR_DATA_COUNT : OUT std_logic_vector(C_WR_DATA_COUNT_WIDTH-1 DOWNTO 0)
                  :=   (OTHERS => '0');
    BACKUP        : IN std_logic  := '0';
    BACKUP_MARKER : IN std_logic  := '0'
    );

END fifo_generator_v4_1_bhv_ss;
-------------------------------------------------------------------------------
-- Definition of Ports
-- DIN          : Input data bus for the fifo.
-- DOUT         : Output data bus for the fifo.
-- AINIT        : Asynchronous Reset for the fifo.
-- WR_EN        : Write enable signal.
-- WR_CLK       : Write Clock.
-- FULL         : Full signal.
-- ALMOST_FULL  : One space left.
-- WR_ACK       : Last write acknowledged.
-- WR_ERR       : Last write rejected.
-- WR_COUNT     : Number of data words in fifo(synchronous to WR_CLK)
-- Rd_EN        : Read enable signal.
-- RD_CLK       : Read Clock.
-- EMPTY        : Empty signal.
-- ALMOST_EMPTY : One sapce left
-- VALID        : Last read acknowledged.
-- RD_ERR       : Last read rejected.
-- RD_COUNT     : Number of data words in fifo(synchronous to RD_CLK)
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Architecture Heading
-------------------------------------------------------------------------------
ARCHITECTURE behavioral OF fifo_generator_v4_1_bhv_ss IS


  -----------------------------------------------------------------------------
  -- actual_fifo_depth
  -- Returns the actual depth of the FIFO 
  -----------------------------------------------------------------------------
  FUNCTION actual_fifo_depth(
    C_FIFO_DEPTH : integer; 
    C_PRELOAD_REGS : integer; 
    C_PRELOAD_LATENCY : integer; 
    C_COMMON_CLOCK : integer) 
  RETURN integer IS
  BEGIN
    RETURN C_FIFO_DEPTH;
  END actual_fifo_depth;

  FUNCTION int_2_std_logic(value : integer) RETURN std_logic IS
  BEGIN
    IF (value=1) THEN
      RETURN '1';
    ELSE
      RETURN '0';
    END IF;
  END int_2_std_logic; 

  --------------------------------------------------------------------------------
  -- Constant Declaration
  --------------------------------------------------------------------------------
  CONSTANT C_FIFO_WR_DEPTH : integer 
    := actual_fifo_depth(C_WR_DEPTH, C_PRELOAD_REGS, C_PRELOAD_LATENCY, C_COMMON_CLOCK);
  CONSTANT C_SMALLER_DATA_WIDTH : integer := get_lesser(C_DIN_WIDTH, C_DOUT_WIDTH);

  -------------------------------------------------------------------------------
  -- Internal Signals
  -------------------------------------------------------------------------------
  SIGNAL empty_i        : std_logic := '1';
  SIGNAL full_i         : std_logic := '0'; 
  SIGNAL almost_empty_i : std_logic := '1';
  SIGNAL almost_full_i  : std_logic := '0'; --v3.2

  SIGNAL rst_asreg      : std_logic := '0';
  SIGNAL rst_asreg_d1   : std_logic := '0';
  SIGNAL rst_asreg_d2   : std_logic := '0';
  SIGNAL rst_comb       : std_logic := '0';
  SIGNAL rst_reg        : std_logic := '0';
  SIGNAL rst_i          : std_logic := '0';
  SIGNAL srst_i         : std_logic := '0';

  SIGNAL diff_count     : std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0)       
                        := (OTHERS => '0');

  SIGNAL wr_ack_i       : std_logic := '0';
  SIGNAL overflow_i     : std_logic := '0';

  SIGNAL valid_i        : std_logic := '0';
  SIGNAL valid_d1       : std_logic := '0';
  SIGNAL underflow_i    : std_logic := '0';

  --The delayed reset is used to deassert prog_full
  SIGNAL rst_q          : std_logic := '0';

  SIGNAL prog_full_reg   : std_logic := '0'; 
  SIGNAL prog_full_noreg : std_logic := '0'; 
  SIGNAL prog_empty_reg  : std_logic := '1';
  SIGNAL prog_empty_noreg: std_logic := '1';
  SIGNAL dout_i          : std_logic_vector(C_DOUT_WIDTH-1 DOWNTO 0) 
                         := (OTHERS => '0');

  -----------------------------------------------------------------------------
  -- Linked List types
  -----------------------------------------------------------------------------
  TYPE listtyp;
  TYPE listptr IS ACCESS listtyp;
  TYPE listtyp IS RECORD
                    data  : std_logic_vector(C_SMALLER_DATA_WIDTH - 1 DOWNTO 0);
                    older : listptr;
                    newer : listptr;
                  END RECORD;

  -------------------------------------------------------------------------------
  --Processes for linked list implementation. The functions are
  --1. Create a new linked list
  --2. Add a data element to a linked list
  --3. Read the data from the tail of the linked list
  --4. Remove the tail from the linked list
  --5. Calculate the size of the linked list
  -------------------------------------------------------------------------------
  --1. Create a new linked list
  PROCEDURE newlist (
    head : INOUT listptr; 
    tail : INOUT listptr) IS
  BEGIN
    head := NULL;
    tail := NULL;
  END;  

  --2. Add a data element to a linked list
  PROCEDURE add (
    head : INOUT listptr; 
    tail : INOUT listptr; 
    data : IN std_logic_vector) IS
    VARIABLE oldhead  :       listptr;
    VARIABLE newhead  :       listptr;
  BEGIN
    --------------------------------------------------------------------------
    --a. Create a pointer to the existing head, if applicable
    --b. Create a new node for the list
    --c. Make the new node point to the old head
    --d. Make the old head point back to the new node (for doubly-linked list)
    --e. Put the data into the new head node
    --f. If the new head we just created is the only node in the list, 
    --   make the tail point to it
    --g. Return the new head pointer
    --------------------------------------------------------------------------
    IF (head /= NULL) THEN
      oldhead       := head;
    END IF;
    newhead         := NEW listtyp;
    newhead.older   := oldhead;
    IF (head /= NULL) THEN
      oldhead.newer := newhead;
    END IF;
    newhead.data    := data;
    IF (newhead.older = NULL) THEN
      tail          := newhead;
    END IF;
    head            := newhead;
  END;  

  --3. Read the data from the tail of the linked list
  PROCEDURE read (
    tail : INOUT listptr; 
    data : OUT std_logic_vector) IS
  BEGIN
    data := tail.data;
  END;  

  --4. Remove the tail from the linked list
  PROCEDURE remove (
    head : INOUT listptr; 
    tail : INOUT listptr) IS
    VARIABLE oldtail     :       listptr;
    VARIABLE newtail     :       listptr;
  BEGIN
    --------------------------------------------------------------------------
    --Make a copy of the old tail pointer
    --a. If there is no newer node, then set the tail pointer to nothing 
    --   (list is empty)
    --   otherwise, make the next newer node the new tail, and make it point 
    --   to nothing older
    --b. Clean up the memory for the old tail node
    --c. If the new tail is nothing, then we have an empty list, and head 
    --   should also be set to nothing
    --d. Return the new tail
    --------------------------------------------------------------------------
    oldtail         := tail;
    IF (oldtail.newer = NULL) THEN
      newtail       := NULL;
    ELSE
      newtail       := oldtail.newer;
      newtail.older := NULL;
    END IF;
    DEALLOCATE(oldtail);
    IF (newtail = NULL) THEN
      head          := NULL;
    END IF;
    tail            := newtail;
  END; 


  --5. Calculate the size of the linked list
  PROCEDURE sizeof (head : INOUT listptr; size : OUT integer) IS
    VARIABLE curlink     :       listptr;
    VARIABLE tmpsize     :       integer := 0;
  BEGIN
    --------------------------------------------------------------------------
    --a. If head is null, then there is nothing in the list to traverse
    --   start with the head node (which implies at least one node exists)
    --   Loop through each node until you find the one that points to nothing 
    --   (the tail)
    --b. Return the number of nodes
    --------------------------------------------------------------------------
    IF (head /= NULL) THEN
      curlink                            := head;
      tmpsize                            := 1;
      WHILE (curlink.older /= NULL) LOOP
        tmpsize                          := tmpsize + 1;
        curlink                          := curlink.older;
      END LOOP;
    END IF;
    size                                 := tmpsize;
  END;  


  -----------------------------------------------------------------------------
  -- converts integer to specified length std_logic_vector : dropping least
  -- significant bits if integer is bigger than what can be represented by
  -- the vector
  -----------------------------------------------------------------------------
  FUNCTION count( 
    fifo_count    : IN integer;
    pointer_width : IN integer;
    counter_width : IN integer)
  RETURN std_logic_vector IS
    VARIABLE temp   :    std_logic_vector(pointer_width-1 DOWNTO 0)   
                    := (OTHERS => '0');
    VARIABLE output :    std_logic_vector(counter_width - 1 DOWNTO 0) 
                    := (OTHERS => '0');
  BEGIN
    temp     := CONV_STD_LOGIC_VECTOR(fifo_count, pointer_width);
    IF (counter_width <= pointer_width) THEN
      output := temp(pointer_width - 1 DOWNTO pointer_width - counter_width);
    ELSE
      output := temp(counter_width - 1 DOWNTO 0);
    END IF;
    RETURN output;
  END count;


-------------------------------------------------------------------------------
-- architecture begins here
-------------------------------------------------------------------------------
BEGIN


  -------------------------------------------------------------------------------
  -- If there is a reset input, generate internal reset signals
  -- The latency of reset will match the core behavior.
  -------------------------------------------------------------------------------
  --Single RST
  grst : IF (C_HAS_RST=1) GENERATE
    PROCESS (CLK, RST)
    BEGIN
      IF (RST = '1') THEN
        rst_asreg <=   '1';
      ELSIF (CLK'event and CLK = '1') THEN
        IF (rst_asreg_d1 = '1') THEN
          rst_asreg <= '0';
        ELSE
          rst_asreg <= rst_asreg;
        END IF;
      END IF;
  
      IF (CLK'event and CLK = '1') THEN
        rst_asreg_d1 <= rst_asreg;
        rst_asreg_d2 <= rst_asreg_d1;
      END IF;
    END PROCESS;
    
    PROCESS (rst_asreg, rst_asreg_d2)
    BEGIN
      rst_comb <= NOT rst_asreg_d2 AND rst_asreg;
    END PROCESS;
  
    PROCESS (CLK, rst_comb)
    BEGIN
      IF (rst_comb = '1') THEN
        rst_reg <= '1';
      ELSIF (CLK'event and CLK = '1') THEN
        rst_reg <= '0';
      END IF;
    END PROCESS;
  
    rst_i <= rst_reg;

  END GENERATE grst;

  --No RST
  norst  : IF (C_HAS_RST=0) GENERATE
    rst_i <= '0';
  END GENERATE norst;
  
  --SRST
  gsrst  : IF (C_HAS_SRST=1) GENERATE
    srst_i <= SRST;
  END GENERATE gsrst;
  
  --No SRST
  nosrst  : IF (C_HAS_SRST=0) GENERATE
    srst_i <= '0';
  END GENERATE nosrst;

  gdc : IF (C_HAS_DATA_COUNT = 1) GENERATE

    gdcb : IF (C_DATA_COUNT_WIDTH > C_RD_PNTR_WIDTH) GENERATE
      DATA_COUNT(C_RD_PNTR_WIDTH-1 DOWNTO 0)    <= diff_count;
      DATA_COUNT(C_DATA_COUNT_WIDTH-1 DOWNTO C_DATA_COUNT_WIDTH-C_RD_PNTR_WIDTH) 
        <= (OTHERS => '0');
    END GENERATE;

    gdcs : IF (C_DATA_COUNT_WIDTH <= C_RD_PNTR_WIDTH) GENERATE
      DATA_COUNT <= 
      diff_count(C_RD_PNTR_WIDTH-1 DOWNTO C_RD_PNTR_WIDTH-C_DATA_COUNT_WIDTH);
    END GENERATE;
  END GENERATE;

  gndc    : IF (C_HAS_DATA_COUNT = 0) GENERATE
      DATA_COUNT <= (OTHERS => '0');
  END GENERATE;

  --Calculate WR_ACK based on C_WR_ACK_LOW parameters
  gwalow : IF (C_WR_ACK_LOW = 0) GENERATE
    WR_ACK <= wr_ack_i;
  END GENERATE gwalow;
  gwahgh : IF (C_WR_ACK_LOW = 1) GENERATE
    WR_ACK <= NOT wr_ack_i;
  END GENERATE gwahgh;

  --Calculate OVERFLOW based on C_OVERFLOW_LOW parameters
  govlow : IF (C_OVERFLOW_LOW = 0) GENERATE
    OVERFLOW <= overflow_i;
  END GENERATE govlow;
  govhgh : IF (C_OVERFLOW_LOW = 1) GENERATE
    OVERFLOW <= NOT overflow_i;
  END GENERATE govhgh;

  --Calculate VALID based on C_PRELOAD_LATENCY and C_VALID_LOW settings
  gvlat1 : IF (C_PRELOAD_LATENCY = 1 OR C_PRELOAD_LATENCY=2) GENERATE
    gnvl : IF (C_VALID_LOW = 0) GENERATE
      VALID <= valid_d1;
    END GENERATE gnvl;
    gnvh : IF (C_VALID_LOW = 1) GENERATE
      VALID <= NOT valid_d1;
    END GENERATE gnvh;
  END GENERATE gvlat1;

  --Calculate UNDERFLOW based on C_PRELOAD_LATENCY and C_UNDERFLOW_LOW settings
  guflat1 : IF (C_PRELOAD_LATENCY = 1 OR C_PRELOAD_LATENCY=2) GENERATE
    gnul  : IF (C_UNDERFLOW_LOW = 0) GENERATE
      UNDERFLOW <= underflow_i;
    END GENERATE gnul;
    gnuh  : IF (C_UNDERFLOW_LOW = 1) GENERATE
      UNDERFLOW <= NOT underflow_i;
    END GENERATE gnuh;
  END GENERATE guflat1;

  PROG_FULL <= prog_full_reg;
  PROG_EMPTY <= prog_empty_reg;

  FULL <= full_i;
  ALMOST_FULL <= almost_full_i;
  EMPTY         <= empty_i;
  ALMOST_EMPTY  <= almost_empty_i;

  -------------------------------------------------------------------------------
  -- Synchrounous FIFO using linked lists
  -------------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- Simulataneous Write and Read
  -- Write process will always happen before the read the process
  -----------------------------------------------------------------------------
  FIFO_PROC : PROCESS (CLK, rst_i)

  VARIABLE data : std_logic_vector(c_dout_width - 1 DOWNTO 0) :=
    hexstr_to_std_logic_vec( C_DOUT_RST_VAL, c_dout_width);
  VARIABLE head : listptr;
  VARIABLE tail : listptr;
  VARIABLE size : integer                                     := 0;
  BEGIN

    ---------------------------------------------------------------------------
    --Calculate the current contents of the FIFO (size)
    -- Warning: This value should only be calculated once each time this
    -- process is entered. It is updated instantaneously.
    ---------------------------------------------------------------------------
    sizeof(head, size);
    
    --Generate overflow_i and underflow_i seperately because they don't
    --support async rst
    IF (CLK'event AND CLK = '1') THEN
      overflow_i  <= full_i AND WR_EN;
      underflow_i <= empty_i and RD_EN;
    END IF;

    -- RESET CONDITIONS
    IF (rst_i = '1') THEN
      wr_ack_i    <= '0';
      rst_q       <= '1';

      full_i          <= int_2_std_logic(C_FULL_FLAGS_RST_VAL);
      almost_full_i   <= int_2_std_logic(C_FULL_FLAGS_RST_VAL);
      prog_full_reg   <= int_2_std_logic(C_FULL_FLAGS_RST_VAL);
      prog_full_noreg <= int_2_std_logic(C_FULL_FLAGS_RST_VAL);

      --Create new linked list
      newlist(head, tail);

      --Most memories asynchronously reset
      IF (C_MEMORY_TYPE/=1) THEN         
        data := 
        hexstr_to_std_logic_vec(C_DOUT_RST_VAL, C_DOUT_WIDTH);
      END IF;

      --Block Memory Synchronously resets
      IF (C_MEMORY_TYPE=1) THEN         
        IF (CLK'event AND CLK = '1') THEN
          data := 
          hexstr_to_std_logic_vec(C_DOUT_RST_VAL, C_DOUT_WIDTH);
        END IF;
      END IF;

      --Clear data output queue
      -- Whenever user is attempting to read from
      -- an EMPTY FIFO, the core should report an underflow error, even if
      -- the core is in a RESET condition.
      valid_i           <= '0';
      empty_i           <= '1';
      almost_empty_i    <= '1';
      prog_empty_reg    <= '1';
      prog_empty_noreg  <= '1';

      diff_count        <= (OTHERS => '0');

    ELSIF (CLK'event AND CLK = '1') THEN
      
      --Synchronous Reset
      IF (srst_i = '1') THEN 
        wr_ack_i    <= '0';
        rst_q       <= '0'; 
 
        full_i          <= '0';
        almost_full_i   <= '0';
        prog_full_reg   <= '0';
        prog_full_noreg <= '0';

        --Create new linked list
        newlist(head, tail);

        IF (C_MEMORY_TYPE=1 or C_MEMORY_TYPE=2) THEN  
        --SRST is available only for BRAM and DRAM
          data := hexstr_to_std_logic_vec(C_DOUT_RST_VAL, C_DOUT_WIDTH);
        END IF;

        --Clear data output queue
        -- Whenever user is attempting to read from
        -- an EMPTY FIFO, the core should report an underflow error, even if
        -- the core is in a RESET condition.
        valid_i           <= '0';
        empty_i           <= '1';
        almost_empty_i    <= '1';
        prog_empty_reg    <= '1';
        prog_empty_noreg  <= '1';

        diff_count        <= (OTHERS => '0');
      
      ELSE --srst_i=0
        --Create registered versions of these internal signals
        --This signal is used to deassert PROG_EMPTY and PROG_FULL
        rst_q       <= rst_i;

        -- Setup default value for underflow and valid
        valid_i     <= '0';

        -------------------------------------------------------------------------
        -- Synchronous FIFO. There are four conditions. 
        -- 1 : Writing and not reading
        -- 2 : Reading and not writing
        -- 3 : Writing and Reading
        -- 4 : Not writing and not reading
        -------------------------------------------------------------------------
        -- Condition #1 : Writing and not reading
        IF ((WR_EN = '1') AND (RD_EN = '0')) THEN

          -- FIFO is FULL
          IF (size = C_FIFO_WR_DEPTH) THEN
            --Report Overflow and do not acknowledge the write
            wr_ack_i   <= '0';

            --FIFO Remains FULL & ALMOST_FULL
            full_i        <= '1';
            almost_full_i <= '1';

            --Report no underflow. Output not valid.
            valid_i      <= '0';

            --FIFO is nowhere near EMPTY
            empty_i        <= '0';
            almost_empty_i <= '0';

            --No write, so do not update diff_count

          --FIFO is reporting FULL (Start-up condition)
          --When C_FULL_FLAGS_RST_VAL=1 
          --and right after internal reset is deasserted.
          ELSIF ((size < C_FIFO_WR_DEPTH) AND (full_i = '1')) THEN
            --Report Overflow and do not acknowledge the write
            wr_ack_i   <= '0';

            --FIFO is not "really" FULL, so clear these values
            full_i        <= '0';
            almost_full_i <= '0';

            --Report no underflow. Output not valid.
            valid_i      <= '0';

            --FIFO EMPTY in this state can not be determined

            --No write, so do not update diff_count

          -- FIFO is one from FULL
          ELSIF (size + 1 = C_FIFO_WR_DEPTH) THEN
            -- This write will succeed, and FIFO will go FULL
            wr_ack_i      <= '1';
            full_i        <= '1';
            almost_full_i <= '1';
            add(head, tail, DIN( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );

            --Report no underflow. Output not valid.
            valid_i      <= '0';

            --FIFO is nowhere near EMPTY
            empty_i        <= '0';
            almost_empty_i <= '0';

            --Update count (for DATA_COUNT output)
            diff_count <= conv_std_logic_vector((size+1),C_RD_PNTR_WIDTH);

          --FIFO is two from FULL
          ELSIF size + 2 = C_FIFO_WR_DEPTH THEN
            -- This write will succeed, and FIFO will go ALMOST_FULL
            wr_ack_i      <= '1';
            full_i        <= '0';
            almost_full_i <= '1';
            add(head, tail, DIN( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );

            --Report no underflow. Output not valid.
            valid_i      <= '0';

            --FIFO is nowhere near EMPTY
            empty_i        <= '0';
            almost_empty_i <= '0';

            --Update count (for DATA_COUNT output)
            diff_count <= conv_std_logic_vector((size+1),C_RD_PNTR_WIDTH);

          --FIFO is ALMOST EMPTY
          ELSIF size = 1 THEN
            -- This write will succeed, and FIFO will no longer be ALMOST EMPTY
            wr_ack_i      <= '1';
            full_i        <= '0';
            almost_full_i <= '0';
            add(head, tail, DIN( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );

            --Report no underflow. Output not valid.
            valid_i      <= '0';

            --FIFO is leaving ALMOST_EMPTY
            empty_i        <= '0';
            almost_empty_i <= '0';

            --Update count (for DATA_COUNT output)
            diff_count <= conv_std_logic_vector((size+1),C_RD_PNTR_WIDTH);

          --FIFO is EMPTY
          ELSIF size = 0 THEN
            -- This write will succeed, and FIFO will no longer be EMPTY
            wr_ack_i      <= '1';
            full_i        <= '0';
            almost_full_i <= '0';
            add(head, tail, DIN( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );

            --Report no underflow. Output not valid.
            valid_i      <= '0';

            --FIFO is leaving EMPTY, but is still ALMOST_EMPTY
            empty_i        <= '0';
            almost_empty_i <= '1';

             --Update count (for DATA_COUNT output)
            diff_count <= conv_std_logic_vector((size+1),C_RD_PNTR_WIDTH);

          --FIFO has two or more words in the FIFO, but is not near FULL
          -- size>1 and size<C_FIFO_DEPTH-2
          ELSE 
            -- This write will succeed, and FIFO will no longer be EMPTY
            wr_ack_i      <= '1';
            full_i        <= '0';
            almost_full_i <= '0';
            add(head, tail, DIN( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );

            --Report no underflow. Output not valid.
            valid_i      <= '0';

            --FIFO is no longer EMPTY or ALMOST_EMPTY
            empty_i        <= '0';
            almost_empty_i <= '0';

            --Update count (for DATA_COUNT output)
            diff_count <= conv_std_logic_vector((size+1),C_RD_PNTR_WIDTH);

          END IF;


        -- Condition #2 : Reading and not writing
        ELSIF ((WR_EN = '0') AND (RD_EN = '1')) THEN

          --FIFO is EMPTY or reporting EMPTY
          IF ((size = 0) OR (EMPTY_i = '1')) THEN
            --No write attempted, but a read will succeed
            wr_ack_i      <= '0';
            full_i        <= '0';
            almost_full_i <= '0';

            --Successful read
            valid_i      <= '0';
            --FIFO is going EMPTY
            empty_i        <= '1';
            almost_empty_i <= '1';

            --No read, so do not update diff_count

          --FIFO is ALMOST EMPTY
          ELSIF (size = 1) THEN
            --No write attempted, but a read will succeed
            wr_ack_i      <= '0';
            full_i        <= '0';
            almost_full_i <= '0';

            --Successful read
            valid_i      <= '1';
            --FIFO is going EMPTY
            empty_i        <= '1';
            almost_empty_i <= '1';

            --This read will succeed, but it's the last one
            read(tail, data( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );
            remove(head, tail);

            --Update count (for DATA_COUNT output)
            diff_count <= conv_std_logic_vector((size-1),C_RD_PNTR_WIDTH);

          -- FIFO is two from EMPTY
          ELSIF (size = 2) THEN
            --No write attempted, but a read will succeed
            wr_ack_i      <= '0';
            full_i        <= '0';
            almost_full_i <= '0';

            --Successful read
            valid_i      <= '1';
            --FIFO is going ALMOST_EMPTY
            empty_i        <= '0';
            almost_empty_i <= '1';

            --Update read
            read(tail, data( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );
            remove(head, tail);

            --Update count (for DATA_COUNT output)
            diff_count <= conv_std_logic_vector((size-1),C_RD_PNTR_WIDTH);

          -- FIFO is one from FULL
          ELSIF (size + 1 = C_FIFO_WR_DEPTH) THEN
            --No write attempted, but a read will succeed
            wr_ack_i      <= '0';
            full_i        <= '0';
            almost_full_i <= '0';

            --Successful read
            valid_i      <= '1';
            --FIFO is nowhere near EMPTY
            empty_i        <= '0';
            almost_empty_i <= '0';

            --Update read
            read(tail, data( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );
            remove(head, tail);

            --Update count (for DATA_COUNT output)
            diff_count <= conv_std_logic_vector((size-1),C_RD_PNTR_WIDTH);

          -- FIFO is FULL
          ELSIF (size = C_FIFO_WR_DEPTH) THEN
            --No write attempted, but a read will succeed
            wr_ack_i      <= '0';
            full_i        <= '0';
            almost_full_i <= '1';

            --Successful read
            valid_i      <= '1';
            --FIFO is nowhere near EMPTY
            empty_i        <= '0';
            almost_empty_i <= '0';

            --Update read
            read(tail, data( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );
            remove(head, tail);

            --Update count (for DATA_COUNT output)
            diff_count <= conv_std_logic_vector((size-1),C_RD_PNTR_WIDTH);



          --FIFO has two or more words in the FIFO, but is not near FULL
          ELSE -- size>2 and size<C_FIFO_DEPTH-1
            --No write attempted, but a read will succeed
            wr_ack_i      <= '0';
            full_i        <= '0';
            almost_full_i <= '0';

            --Successful read
            valid_i      <= '1';
            --FIFO is going EMPTY
            empty_i        <= '0';
            almost_empty_i <= '0';

            --This read will succeed, but it's the last one
            read(tail, data( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );
            remove(head, tail);

            --Update count (for DATA_COUNT output)
            diff_count <= conv_std_logic_vector((size-1),C_RD_PNTR_WIDTH);

          END IF;


        -- Condition #3 : Reading and writing
        ELSIF ((WR_EN = '1') AND (RD_EN = '1')) THEN

          -- FIFO is FULL
          IF (size = C_FIFO_WR_DEPTH) THEN
            -- Write to FULL FIFO will fail
            wr_ack_i      <= '0';
            full_i        <= '0';
            almost_full_i <= '1';

            -- Read will be successful.
            valid_i      <= '1';

            --FIFO is nowhere near EMPTY
            empty_i        <= '0';
            almost_empty_i <= '0';

            --Update read
            read(tail, data( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );
            remove(head, tail);

            --Update count (for DATA_COUNT output)
            diff_count <= conv_std_logic_vector((size-1),C_RD_PNTR_WIDTH);

          -- FIFO is reporting FULL, but it is empty
          --  (this is a special case, when coming out of RST)
          ELSIF ((size = 0) AND (full_i = '1')) THEN
            -- Write to FULL FIFO will fail
            wr_ack_i      <= '0';

            --Clear the FULL flags for normal use
            full_i        <= '0';
            almost_full_i <= '0';

            -- Read will be unsuccessful, because we're empty
            valid_i      <= '0';

            --FIFO EMPTY in this state can not be determined
            empty_i        <= '1';
            almost_empty_i <= '1';

            --Do Not Read

            --No read or write, don't update data count

          -- FIFO is one from FULL
          ELSIF (size + 1 = C_FIFO_WR_DEPTH) THEN
            -- Write will be successful
            wr_ack_i      <= '1';
            full_i        <= '0';
            almost_full_i <= '1';
            add(head, tail, DIN( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );

            --Successful read
            valid_i      <= '1';
            --FIFO is nowhere near EMPTY
            empty_i        <= '0';
            almost_empty_i <= '0';

            --Update read
            read(tail, data( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );
            remove(head, tail);

            --Simulaneous read and write, no change in diff_count

          --FIFO is ALMOST EMPTY
          ELSIF (size = 1) THEN
            -- Write will be successful
            wr_ack_i      <= '1';
            full_i        <= '0';
            almost_full_i <= '0';
            add(head, tail, DIN( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );

            --Successful read
            valid_i      <= '1';
            --FIFO is nowhere near EMPTY
            empty_i        <= '0';
            almost_empty_i <= '1';

            --Update read
            read(tail, data( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );
            remove(head, tail);

            --Simulaneous read and write, no change in diff_count

          --FIFO is EMPTY
          ELSIF ((size = 0) OR (EMPTY_i = '1')) THEN
            -- Write will be successful
            wr_ack_i      <= '1';
            full_i        <= '0';
            almost_full_i <= '0';
            add(head, tail, DIN( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );

            --Read will fail, because core is reporting EMPTY
            valid_i      <= '0';
            --FIFO is no longer EMPTY
            empty_i        <= '0';
            almost_empty_i <= '1';

            --Update count (for DATA_COUNT output)
            diff_count <= conv_std_logic_vector((size+1),C_RD_PNTR_WIDTH);


          --FIFO has two or more words in the FIFO, but is not near FULL
          ELSE -- size>1 and size<C_FIFO_DEPTH-1
            -- Write will be successful
            wr_ack_i      <= '1';
            full_i        <= '0';
            almost_full_i <= '0';
            add(head, tail, DIN( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );

            --Successful read
            valid_i      <= '1';
            --FIFO is nowhere near EMPTY
            empty_i        <= '0';
            almost_empty_i <= '0';

            --Update read
            read(tail, data( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );
            remove(head, tail);

            --Simulaneous read and write, no change in diff_count

          END IF;

        -- Condition #4 : Not reading or writing
        ELSE -- ((WR_EN = '0') AND (RD_EN = '0'))

          --FULL
          IF (size = C_FIFO_WR_DEPTH) THEN  
            -- No write
            wr_ack_i      <= '0';
            full_i        <= '1';
            almost_full_i <= '1';

            --No read
            valid_i        <= '0';
            empty_i        <= '0';
            almost_empty_i <= '0';

          --ALMOST_FULL
          ELSIF (size >= C_FIFO_WR_DEPTH - 1) THEN  
            -- No write
            wr_ack_i      <= '0';
            full_i        <= '0';
            almost_full_i <= '1';

            --No read
            valid_i        <= '0';
            empty_i        <= '0';
            almost_empty_i <= '0';

          -- ALMOST_EMPTY
          ELSIF (size = 1) THEN  
            -- No write
            wr_ack_i      <= '0';
            full_i        <= '0';
            almost_full_i <= '0';

            --No read
            valid_i        <= '0';
            empty_i        <= '0';
            almost_empty_i <= '1';

          -- EMPTY
          ELSIF (size = 0) THEN  
            -- No write
            wr_ack_i      <= '0';
            full_i        <= '0';
            almost_full_i <= '0';

            --No read
            valid_i        <= '0';
            empty_i        <= '1';
            almost_empty_i <= '1';

          -- Not near FULL or EMPTY
          ELSE  
            -- No write
            wr_ack_i      <= '0';
            full_i        <= '0';
            almost_full_i <= '0';

            --No read
            valid_i        <= '0';
            empty_i        <= '0';
            almost_empty_i <= '0';

          END IF;

        END IF;  -- WR_EN, RD_EN


        ------------------------------------------------------------------------
        -- Programmable FULL flags
        ------------------------------------------------------------------------
        IF (C_PROG_FULL_TYPE /= 0) THEN

          -- single input threshold
          IF (C_PROG_FULL_TYPE = 3) THEN
            IF ((size = conv_integer(PROG_FULL_THRESH)-1) AND WR_EN = '1'
                   AND RD_EN = '0') THEN
                prog_full_noreg <= '1';
            ELSIF ((size = conv_integer(PROG_FULL_THRESH)) AND WR_EN = '0'
                 AND RD_EN = '1') THEN
                prog_full_noreg <= '0';
            ELSIF (size >= conv_integer(PROG_FULL_THRESH)) THEN
                prog_full_noreg <= '1';
            ELSIF (size < conv_integer(PROG_FULL_THRESH)) THEN
                prog_full_noreg <= '0';
            END IF;

          -- dual input thresholds
          ELSIF (C_PROG_FULL_TYPE = 4) THEN
            IF ((size = conv_integer(PROG_FULL_THRESH_ASSERT)-1)
                 AND WR_EN = '1' AND RD_EN = '0') THEN
                prog_full_noreg <= '1';
            ELSIF ((size = conv_integer(PROG_FULL_THRESH_NEGATE))
                 AND WR_EN = '0' AND RD_EN = '1') THEN
                prog_full_noreg <= '0';
            ELSIF (size >= conv_integer(PROG_FULL_THRESH_ASSERT)) THEN 
                prog_full_noreg <= '1';
            ELSIF (size < conv_integer(PROG_FULL_THRESH_NEGATE)) THEN 
                prog_full_noreg <= '0';
            END IF;

          -- dual constant thresholds
          ELSIF (C_PROG_FULL_TYPE = 2) THEN
            IF ((size = C_PROG_FULL_THRESH_ASSERT_VAL-1) AND WR_EN = '1'
                AND RD_EN = '0') THEN
                prog_full_noreg <= '1';
            ELSIF ((size = C_PROG_FULL_THRESH_NEGATE_VAL) AND RD_EN = '1'
                   AND WR_EN = '0') THEN
                prog_full_noreg <= '0';
            END IF;

          -- single constant thresholds
          ELSE
            IF ((size = C_PROG_FULL_THRESH_ASSERT_VAL-1) AND WR_EN = '1'
                AND RD_EN = '0') THEN
                prog_full_noreg <= '1';
            ELSIF (((size = C_PROG_FULL_THRESH_ASSERT_VAL) AND RD_EN = '1'
               AND WR_EN = '0')) THEN
                prog_full_noreg <= '0';
            END IF;

          END IF; --C_PROG_FULL_TYPE

          IF (rst_q='1' and rst_i='0') THEN
            prog_full_reg <= '0';
            prog_full_noreg <= '0';
          ELSE
            prog_full_reg <= prog_full_noreg;
          END IF;

        END IF;  --C_PROG_FULL_TYPE /= 0

        ------------------------------------------------------------------------
        -- Programmable EMPTY Flags
        ------------------------------------------------------------------------
        IF C_PROG_EMPTY_TYPE /= 0 THEN
          -- single input threshold
          IF C_PROG_EMPTY_TYPE = 3 THEN
            IF ((size = conv_integer(PROG_EMPTY_THRESH)+1) 
                 AND RD_EN = '1' AND WR_EN = '0') THEN
              prog_empty_noreg      <= '1';
            ELSIF ((size = conv_integer(PROG_EMPTY_THRESH)) 
                 AND RD_EN = '0' AND WR_EN = '1') THEN
              prog_empty_noreg      <= '0';
            ELSIF (size <= conv_integer(PROG_EMPTY_THRESH)) THEN
              prog_empty_noreg      <= '1';
            ELSIF (size > conv_integer(PROG_EMPTY_THRESH)) THEN
              prog_empty_noreg      <= '0';
            END IF;           

          -- dual input threshold
          ELSIF C_PROG_EMPTY_TYPE = 4 THEN
            IF ((size = conv_integer(PROG_EMPTY_THRESH_ASSERT)+1) 
                 AND RD_EN = '1' AND WR_EN = '0') THEN
                prog_empty_noreg      <= '1';
            ELSIF  ((size = conv_integer(PROG_EMPTY_THRESH_NEGATE)) 
                 AND RD_EN = '0' AND WR_EN = '1')  THEN
                prog_empty_noreg      <= '0';
            ELSIF (size <= conv_integer(PROG_EMPTY_THRESH_ASSERT)) THEN
                prog_empty_noreg      <= '1';
            ELSIF (size > conv_integer(PROG_EMPTY_THRESH_NEGATE)) THEN
                prog_empty_noreg      <= '0';
            END IF; 

          -- dual constant thresholds
          ELSIF C_PROG_EMPTY_TYPE = 2 THEN
            IF ((size = C_PROG_EMPTY_THRESH_ASSERT_VAL+1) AND RD_EN = '1'
                AND WR_EN = '0') THEN
                prog_empty_noreg          <= '1';
            ELSIF ((size = C_PROG_EMPTY_THRESH_NEGATE_VAL) AND WR_EN = '1'
                   AND RD_EN = '0') THEN
                prog_empty_noreg          <= '0';
            END IF;


          -- single constant threshold
          ELSIF C_PROG_EMPTY_TYPE = 1 THEN
            IF ((size = C_PROG_EMPTY_THRESH_ASSERT_VAL+1) 
                AND RD_EN = '1' AND WR_EN = '0') THEN
                prog_empty_noreg      <= '1';
            ELSIF ((size = C_PROG_EMPTY_THRESH_ASSERT_VAL) 
                   AND WR_EN = '1' AND RD_EN = '0') THEN
                prog_empty_noreg      <= '0';
            END IF;

          END IF; -- C_PROG_EMPTY_TYPE

          prog_empty_reg <= prog_empty_noreg;

        END IF; --C_PROG_EMPTY_TYPE /= 0
     
      END IF; --not SRST

    END IF;     --CLK

    dout_i <= data;

  END PROCESS;

  -----------------------------------------------------------------------------
  --Delay Valid AND DOUT 
  --if C_MEMORY_TYPE=0 or 1, C_PRELOAD_REGS=0, C_USE_EMBEDDED_REG=1
  -----------------------------------------------------------------------------
  gv0: IF (C_USE_EMBEDDED_REG=1
           AND (C_MEMORY_TYPE=0 OR C_MEMORY_TYPE=1)) GENERATE
    PROCESS (rst_i  , CLK  )
    BEGIN
      IF (rst_i   = '1') THEN
        valid_d1 <= '0';
        DOUT     <= hexstr_to_std_logic_vec(C_DOUT_RST_VAL, C_DOUT_WIDTH);
      ELSIF (CLK  'event AND CLK   = '1') THEN
        valid_d1 <= valid_i;
        DOUT     <= dout_i;
      END IF;
    END PROCESS;
  END GENERATE gv0;
  gv1: IF NOT(C_USE_EMBEDDED_REG=1
              AND (C_MEMORY_TYPE=0 OR C_MEMORY_TYPE=1)) GENERATE
    valid_d1 <= valid_i;
    DOUT     <= dout_i;
  END GENERATE gv1;
END behavioral;


--#############################################################################
--  Preload Latency 0 Module
--#############################################################################
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.iputils_std_logic_unsigned.ALL;
USE XilinxCoreLib.iputils_conv.ALL;
USE XilinxCoreLib.iputils_misc.ALL;

ENTITY fifo_generator_v4_1_bhv_preload0 IS

  GENERIC (
    C_DOUT_RST_VAL    : string  := "";
    C_DOUT_WIDTH      : integer := 8;
    C_HAS_RST         : integer := 0;
    C_USERVALID_LOW   : integer := 0;
    C_USERUNDERFLOW_LOW : integer := 0);
  PORT (
    RD_CLK          : IN  std_logic;
    RD_RST          : IN  std_logic;
    RD_EN           : IN  std_logic;
    FIFOEMPTY       : IN  std_logic;
    FIFODATA        : IN  std_logic_vector(C_DOUT_WIDTH-1 DOWNTO 0);
    USERDATA        : OUT std_logic_vector(C_DOUT_WIDTH-1 DOWNTO 0);
    USERVALID       : OUT std_logic;
    USERUNDERFLOW   : OUT std_logic;
    USEREMPTY       : OUT std_logic;
    USERALMOSTEMPTY : OUT std_logic;
    RAMVALID        : OUT std_logic;
    FIFORDEN        : OUT std_logic);

END fifo_generator_v4_1_bhv_preload0;

ARCHITECTURE behavioral OF fifo_generator_v4_1_bhv_preload0 IS


  SIGNAL preloadstage1     : std_logic := '0';
  SIGNAL preloadstage2     : std_logic := '0';
  SIGNAL ram_valid_i       : std_logic := '0';
  SIGNAL read_data_valid_i : std_logic := '0';
  SIGNAL ram_regout_en     : std_logic := '0';
  SIGNAL ram_rd_en         : std_logic := '0';
  SIGNAL empty_i           : std_logic := '1';
  SIGNAL empty_q           : std_logic := '1';
  SIGNAL rd_en_q           : std_logic := '0'; --Fix for CR:236270 in v3.2 --prasanna
  SIGNAL almost_empty_i    : std_logic := '1';
  SIGNAL almost_empty_q    : std_logic := '1';
  SIGNAL rd_rst_i          : std_logic := '0';


BEGIN  -- behavioral

  grst: IF (C_HAS_RST=1) GENERATE
    rd_rst_i <= RD_RST;
  end generate grst;
  
  ngrst: IF (C_HAS_RST=0) GENERATE
    rd_rst_i <= '0';
  END GENERATE ngrst;
  
  
  --------------------------------------------------------------------------------
  --  preloadstage2 indicates that stage2 needs to be updated. This is true
  --  whenever read_data_valid is false, and RAM_valid is true.
  --------------------------------------------------------------------------------
  preloadstage2 <= ram_valid_i AND (NOT read_data_valid_i OR RD_EN);
  
  --------------------------------------------------------------------------------
  --  preloadstage1 indicates that stage1 needs to be updated. This is true
  --  whenever the RAM has data (RAM_EMPTY is false), and either RAM_Valid is
  --  false (indicating that Stage1 needs updating), or preloadstage2 is active
  --  (indicating that Stage2 is going to update, so Stage1, therefore, must
  --  also be updated to keep it valid.
  --------------------------------------------------------------------------------
  preloadstage1 <= (((NOT ram_valid_i) OR preloadstage2) AND (NOT FIFOEMPTY));
  
  --------------------------------------------------------------------------------
  -- Calculate RAM_REGOUT_EN
  --  The output registers are controlled by the ram_regout_en signal.
  --  These registers should be updated either when the output in Stage2 is
  --  invalid (preloadstage2), OR when the user is reading, in which case the
  --  Stage2 value will go invalid unless it is replenished.
  --------------------------------------------------------------------------------
  ram_regout_en <= preloadstage2;
  
  --------------------------------------------------------------------------------
  -- Calculate RAM_RD_EN
  --   RAM_RD_EN will be asserted whenever the RAM needs to be read in order to
  --  update the value in Stage1.
  --   One case when this happens is when preloadstage1=true, which indicates
  --  that the data in Stage1 or Stage2 is invalid, and needs to automatically
  --  be updated.
  --   The other case is when the user is reading from the FIFO, which guarantees
  --  that Stage1 or Stage2 will be invalid on the next clock cycle, unless it is
  --  replinished by data from the memory. So, as long as the RAM has data in it,
  --  a read of the RAM should occur.
  --------------------------------------------------------------------------------
  ram_rd_en     <= (RD_EN AND NOT FIFOEMPTY) OR preloadstage1;
  
  --------------------------------------------------------------------------------
  -- Calculate ram_valid
  --   ram_valid indicates that the data in Stage1 is valid.
  --
  --   If the RAM is being read from on this clock cycle (ram_rd_en=1), then
  --   ram_valid is certainly going to be true.
  --   If the RAM is not being read from, but the output registers are being
  --   updated to fill Stage2 (ram_regout_en=1), then Stage1 will be emptying,
  --   therefore causing ram_valid to be false.
  --   Otherwise, ram_valid will remain unchanged.
  --------------------------------------------------------------------------------
  regout_valid: PROCESS (RD_CLK, rd_rst_i)
  BEGIN  -- PROCESS regout_valid
    IF rd_rst_i = '1' THEN                -- asynchronous reset (active high)
      ram_valid_i <= '0';
    ELSIF RD_CLK'event AND RD_CLK = '1' THEN  -- rising clock edge
      IF ram_rd_en = '1' THEN
        ram_valid_i <= '1';
      ELSE
        IF ram_regout_en = '1' THEN
          ram_valid_i <= '0';
        ELSE
          ram_valid_i <= ram_valid_i;
        END IF;
      END IF;
    END IF;
  END PROCESS regout_valid;
  
  --------------------------------------------------------------------------------
  -- Calculate READ_DATA_VALID
  --  READ_DATA_VALID indicates whether the value in Stage2 is valid or not.
  --  Stage2 has valid data whenever Stage1 had valid data and ram_regout_en_i=1,
  --  such that the data in Stage1 is propogated into Stage2.
  --------------------------------------------------------------------------------
  regout_dvalid : PROCESS (RD_CLK, rd_rst_i)
  BEGIN
    IF (rd_rst_i='1') THEN
      read_data_valid_i <= '0';
    ELSIF (RD_CLK'event AND RD_CLK='1') THEN
      read_data_valid_i <= ram_valid_i OR (read_data_valid_i AND NOT RD_EN);
    END IF; --RD_CLK
  END PROCESS regout_dvalid;
  
  -------------------------------------------------------------------------------
  -- Calculate EMPTY
  --  Defined as the inverse of READ_DATA_VALID
  --
  -- Description:
  --
  --  If read_data_valid_i indicates that the output is not valid,
  -- and there is no valid data on the output of the ram to preload it
  -- with, then we will report empty.
  --
  --  If there is no valid data on the output of the ram and we are
  -- reading, then the FIFO will go empty.
  --
  
  -------------------------------------------------------------------------------
  regout_empty :  PROCESS (RD_CLK, rd_rst_i)       --This is equivalent to (NOT read_data_valid_i)
  BEGIN
    IF (rd_rst_i='1') THEN
      empty_i <= '1';
      empty_q <= '1';
    ELSIF (RD_CLK'event AND RD_CLK='1') THEN
      empty_i  <= (NOT ram_valid_i AND NOT read_data_valid_i) OR (NOT ram_valid_i AND RD_EN);
      empty_q  <= empty_i;
    END IF; --RD_CLK
  END PROCESS regout_empty;
  
  --Fix for CR:236270 --prasanna
  --Register RD_EN from user to calculate USERUNDERFLOW. 
  regout_rd_en: PROCESS (RD_CLK, rd_rst_i)
  BEGIN  -- PROCESS regout_rd_en
    IF rd_rst_i = '1' THEN                -- asynchronous reset (active high)
      rd_en_q <= '0';
    ELSIF RD_CLK'event AND RD_CLK = '1' THEN  -- rising clock edge
      rd_en_q <= RD_EN;
    END IF;
  END PROCESS regout_rd_en;
  
  -------------------------------------------------------------------------------
  -- Calculate user_almost_empty
  --  user_almost_empty is defined such that, unless more words are written
  --  to the FIFO, the next read will cause the FIFO to go EMPTY.
  --
  --  In most cases, whenever the output registers are updated (due to a user
  -- read or a preload condition), then user_almost_empty will update to
  -- whatever RAM_EMPTY is.
  --
  --  The exception is when the output is valid, the user is not reading, and
  -- Stage1 is not empty. In this condition, Stage1 will be preloaded from the
  -- memory, so we need to make sure user_almost_empty deasserts properly under
  -- this condition.
  -------------------------------------------------------------------------------
  regout_aempty: PROCESS (RD_CLK, rd_rst_i)
  BEGIN  -- PROCESS regout_empty
    IF rd_rst_i = '1' THEN                -- asynchronous reset (active high)
      almost_empty_i <= '1';
      almost_empty_q <= '1';
    ELSIF RD_CLK'event AND RD_CLK = '1' THEN  -- rising clock edge
      IF ((ram_regout_en = '1') OR (FIFOEMPTY = '0' AND read_data_valid_i = '1' AND  RD_EN='0')) THEN
        almost_empty_i <= FIFOEMPTY;
      END IF;
      almost_empty_q   <= almost_empty_i;
    END IF;
  END PROCESS regout_aempty;
  
  USEREMPTY <= empty_i;
  USERALMOSTEMPTY <= almost_empty_i;
  FIFORDEN  <= ram_rd_en;
  RAMVALID  <= ram_valid_i;
  
  guvh: IF C_USERVALID_LOW=0 GENERATE
    USERVALID <= read_data_valid_i;
  END GENERATE guvh;
  guvl: if C_USERVALID_LOW=1 GENERATE
    USERVALID <= NOT read_data_valid_i;
  END GENERATE guvl;
  
  gufh: IF C_USERUNDERFLOW_LOW=0 GENERATE
    --USERUNDERFLOW <= empty_q AND RD_EN; --Bug in v3.1 (CR:236270)
    USERUNDERFLOW <= empty_q AND rd_en_q; --Fix for CR:236270 in v3.2 --prasanna 
  END GENERATE gufh;
  gufl: if C_USERUNDERFLOW_LOW=1 GENERATE
    --USERUNDERFLOW <= NOT (empty_q AND RD_EN); --Bug in v3.1 (CR:236270)
    USERUNDERFLOW <= NOT (empty_q AND rd_en_q); --Fix for CR:236270 in v3.2 --prasanna
  END GENERATE gufl;
  
  regout_lat0: PROCESS (RD_CLK, rd_rst_i)
  BEGIN  -- PROCESS regout_lat0
    IF rd_rst_i = '1' THEN              -- asynchronous reset (active high)
      USERDATA <= hexstr_to_std_logic_vec(C_DOUT_RST_VAL, C_DOUT_WIDTH);
    ELSIF RD_CLK'event AND RD_CLK = '1' THEN  -- rising clock edge
      IF (ram_regout_en = '1') THEN
        USERDATA <= FIFODATA;
      END IF;
    END IF;
  END PROCESS regout_lat0;
  

END behavioral;



-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--  Top-level Behavioral Model
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.iputils_std_logic_unsigned.ALL;
USE XilinxCoreLib.iputils_std_logic_arith.ALL;
USE XilinxCoreLib.iputils_conv.ALL;
USE XilinxCoreLib.iputils_misc.ALL;
USE XilinxCoreLib.fifo_generator_v4_1_bhv_as;
USE XilinxCoreLib.fifo_generator_v4_1_bhv_ss;


ENTITY fifo_generator_v4_1 IS
  GENERIC (
    --------------------------------------------------------------------------------
    -- Generic Declarations
    --------------------------------------------------------------------------------
    C_COMMON_CLOCK                : integer := 0;
    C_COUNT_TYPE                  : integer := 0;
    C_DATA_COUNT_WIDTH            : integer := 2;
    C_DEFAULT_VALUE               : string  := "";
    C_DIN_WIDTH                   : integer := 8;
    C_DOUT_RST_VAL                : string  := "";
    C_DOUT_WIDTH                  : integer := 8;
    C_ENABLE_RLOCS                : integer := 0;
    C_FAMILY                      : string  := "";
    C_HAS_ALMOST_EMPTY            : integer := 0;
    C_HAS_ALMOST_FULL             : integer := 0;
    C_HAS_BACKUP                  : integer := 0;
    C_HAS_DATA_COUNT              : integer := 0;
    C_HAS_MEMINIT_FILE            : integer := 0;
    C_HAS_OVERFLOW                : integer := 0;
    C_HAS_RD_DATA_COUNT           : integer := 0;
    C_HAS_RD_RST                  : integer := 0;
    C_HAS_RST                     : integer := 1;
    C_HAS_SRST                    : integer := 0;
    C_HAS_UNDERFLOW               : integer := 0;
    C_HAS_VALID                   : integer := 0;
    C_HAS_WR_ACK                  : integer := 0;
    C_HAS_WR_DATA_COUNT           : integer := 0;
    C_HAS_WR_RST                  : integer := 0;
    C_IMPLEMENTATION_TYPE         : integer := 0;
    C_INIT_WR_PNTR_VAL            : integer := 0;
    C_MEMORY_TYPE                 : integer := 1;
    C_MIF_FILE_NAME               : string  := "";
    C_OPTIMIZATION_MODE           : integer := 0;
    C_OVERFLOW_LOW                : integer := 0;
    C_PRELOAD_LATENCY             : integer := 1;
    C_PRELOAD_REGS                : integer := 0;
    C_PRIM_FIFO_TYPE              : string  := "4kx4";
    C_PROG_EMPTY_THRESH_ASSERT_VAL: integer := 0;
    C_PROG_EMPTY_THRESH_NEGATE_VAL: integer := 0;
    C_PROG_EMPTY_TYPE             : integer := 0;
    C_PROG_FULL_THRESH_ASSERT_VAL : integer := 0;
    C_PROG_FULL_THRESH_NEGATE_VAL : integer := 0;
    C_PROG_FULL_TYPE              : integer := 0;
    C_RD_DATA_COUNT_WIDTH         : integer := 2;
    C_RD_DEPTH                    : integer := 256;
    C_RD_FREQ                     : integer := 1;
    C_RD_PNTR_WIDTH               : integer := 8;
    C_UNDERFLOW_LOW               : integer := 0;
    C_USE_FIFO16_FLAGS            : integer := 0;
    C_VALID_LOW                   : integer := 0;
    C_WR_ACK_LOW                  : integer := 0;
    C_WR_DATA_COUNT_WIDTH         : integer := 2;
    C_WR_DEPTH                    : integer := 256;
    C_WR_FREQ                     : integer := 1;
    C_WR_PNTR_WIDTH               : integer := 8;
    C_WR_RESPONSE_LATENCY         : integer := 1;
    C_USE_ECC                     : integer := 0;
    C_FULL_FLAGS_RST_VAL          : integer := 1;
    C_HAS_INT_CLK                 : integer := 0;
    C_USE_EMBEDDED_REG            : integer := 0;
    C_USE_FWFT_DATA_COUNT         : integer := 0
    );
  PORT(
--------------------------------------------------------------------------------
-- Input and Output Declarations
--------------------------------------------------------------------------------
    CLK                       : IN  std_logic := '0';
    BACKUP                    : IN  std_logic := '0';
    BACKUP_MARKER             : IN  std_logic := '0';
    DIN                       : IN  std_logic_vector(C_DIN_WIDTH-1 DOWNTO 0); --
    --Mandatory input
    PROG_EMPTY_THRESH         : IN  std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    PROG_EMPTY_THRESH_ASSERT  : IN  std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    PROG_EMPTY_THRESH_NEGATE  : IN  std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    PROG_FULL_THRESH          : IN  std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    PROG_FULL_THRESH_ASSERT   : IN  std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    PROG_FULL_THRESH_NEGATE   : IN  std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    RD_CLK                    : IN  std_logic := '0';
    RD_EN                     : IN  std_logic;  --Mandatory input
    RD_RST                    : IN  std_logic := '0';
    RST                       : IN  std_logic := '0';
    SRST                      : IN  std_logic := '0';
    WR_CLK                    : IN  std_logic := '0';
    WR_EN                     : IN  std_logic;  --Mandatory input
    WR_RST                    : IN  std_logic := '0';
    INT_CLK                   : IN  std_logic := '0';

    ALMOST_EMPTY              : OUT std_logic;
    ALMOST_FULL               : OUT std_logic;
    DATA_COUNT                : OUT std_logic_vector(C_DATA_COUNT_WIDTH-1 DOWNTO 0);
    DOUT                      : OUT std_logic_vector(C_DOUT_WIDTH-1 DOWNTO 0);
    EMPTY                     : OUT std_logic;
    FULL                      : OUT std_logic;
    OVERFLOW                  : OUT std_logic;
    PROG_EMPTY                : OUT std_logic;
    PROG_FULL                 : OUT std_logic;
    VALID                     : OUT std_logic;
    RD_DATA_COUNT             : OUT std_logic_vector(C_RD_DATA_COUNT_WIDTH-1 DOWNTO 0);
    UNDERFLOW                 : OUT std_logic;
    WR_ACK                    : OUT std_logic;
    WR_DATA_COUNT             : OUT std_logic_vector(C_WR_DATA_COUNT_WIDTH-1 DOWNTO 0);
    SBITERR                   : OUT std_logic;
    DBITERR                   : OUT std_logic
    );

END fifo_generator_v4_1;



ARCHITECTURE behavioral OF fifo_generator_v4_1 IS

  COMPONENT fifo_generator_v4_1_bhv_as

    GENERIC (
      --------------------------------------------------------------------------------
      -- Generic Declarations
      --------------------------------------------------------------------------------
      C_DIN_WIDTH                    :    integer := 8;
      C_DOUT_RST_VAL                 :    string  := "";
      C_DOUT_WIDTH                   :    integer := 8;
      C_ENABLE_RLOCS                 :    integer := 0;
      C_FAMILY                       :    string  := "";
      C_HAS_ALMOST_FULL              :    integer := 0;
      C_HAS_ALMOST_EMPTY             :    integer := 0;
      C_HAS_OVERFLOW                 :    integer := 0;
      C_HAS_RD_DATA_COUNT            :    integer := 2;
      C_HAS_VALID                    :    integer := 0;
      C_HAS_RST                      :    integer := 1;
      C_HAS_UNDERFLOW                :    integer := 0;
      C_HAS_WR_ACK                   :    integer := 0;
      C_HAS_WR_DATA_COUNT            :    integer := 2;
      C_MEMORY_TYPE                  :    integer := 1;
      C_OPTIMIZATION_MODE            :    integer := 0;
      C_WR_RESPONSE_LATENCY          :    integer := 1;
      C_OVERFLOW_LOW                 :    integer := 0;
      C_PRELOAD_REGS                 :    integer := 0;
      C_PRELOAD_LATENCY              :    integer := 1;
      C_PROG_EMPTY_TYPE              :    integer := 0;
      C_PROG_EMPTY_THRESH_ASSERT_VAL :    integer := 0;
      C_PROG_EMPTY_THRESH_NEGATE_VAL :    integer := 0;
      C_PROG_FULL_TYPE               :    integer := 0;
      C_PROG_FULL_THRESH_ASSERT_VAL  :    integer := 0;
      C_PROG_FULL_THRESH_NEGATE_VAL  :    integer := 0;
      C_VALID_LOW                    :    integer := 0;
      C_RD_DATA_COUNT_WIDTH          :    integer := 0;
      C_RD_DEPTH                     :    integer := 256;
      C_RD_PNTR_WIDTH                :    integer := 8;
      C_UNDERFLOW_LOW                :    integer := 0;
      C_WR_ACK_LOW                   :    integer := 0;
      C_WR_DATA_COUNT_WIDTH          :    integer := 0;
      C_WR_DEPTH                     :    integer := 256;
      C_WR_PNTR_WIDTH                :    integer := 8;
      C_FULL_FLAGS_RST_VAL           :    integer := 1;
      C_USE_EMBEDDED_REG             :    integer := 0;
      C_USE_FWFT_DATA_COUNT          :    integer := 0
      );
    PORT(
--------------------------------------------------------------------------------
-- Input and Output Declarations
--------------------------------------------------------------------------------
      DIN                            : IN std_logic_vector(C_DIN_WIDTH-1 DOWNTO 0);
      PROG_EMPTY_THRESH              : IN std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
      PROG_EMPTY_THRESH_ASSERT       : IN std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
      PROG_EMPTY_THRESH_NEGATE       : IN std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
      PROG_FULL_THRESH               : IN std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
      PROG_FULL_THRESH_ASSERT        : IN std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
      PROG_FULL_THRESH_NEGATE        : IN std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
      RD_CLK                         : IN std_logic;
      RD_EN                          : IN std_logic;
      RST                            : IN std_logic;
      WR_CLK                         : IN std_logic;
      WR_EN                          : IN std_logic;

      ALMOST_EMPTY  : OUT std_logic;
      ALMOST_FULL   : OUT std_logic;
      DOUT          : OUT std_logic_vector(C_DOUT_WIDTH-1 DOWNTO 0);
      EMPTY         : OUT std_logic;
      FULL          : OUT std_logic;
      OVERFLOW      : OUT std_logic;
      PROG_EMPTY    : OUT std_logic;
      PROG_FULL     : OUT std_logic;
      VALID         : OUT std_logic;
      RD_DATA_COUNT : OUT std_logic_vector(C_RD_DATA_COUNT_WIDTH-1 DOWNTO 0);
      UNDERFLOW     : OUT std_logic;
      WR_ACK        : OUT std_logic;
      WR_DATA_COUNT : OUT std_logic_vector(C_WR_DATA_COUNT_WIDTH-1 DOWNTO 0)
      );

  END COMPONENT;



  COMPONENT fifo_generator_v4_1_bhv_ss

    GENERIC (
    --------------------------------------------------------------------------------
    -- Generic Declarations (alphabetical)
    --------------------------------------------------------------------------------
    C_COMMON_CLOCK                 : integer := 0;
    C_COUNT_TYPE                   : integer := 0;
    C_DATA_COUNT_WIDTH             : integer := 2;
    C_DEFAULT_VALUE                : string  := "";
    C_DIN_WIDTH                    : integer := 8;
    C_DOUT_RST_VAL                 : string  := "";
    C_DOUT_WIDTH                   : integer := 8;
    C_ENABLE_RLOCS                 : integer := 0;
    C_FAMILY                       : string  := "virtex2";
    C_HAS_ALMOST_FULL              : integer := 0;
    C_HAS_ALMOST_EMPTY             : integer := 0;
    C_HAS_BACKUP                   : integer := 0;
    C_HAS_DATA_COUNT               : integer := 0;
    C_HAS_MEMINIT_FILE             : integer := 0;
    C_HAS_OVERFLOW                 : integer := 0;
    C_HAS_RD_DATA_COUNT            : integer := 0;
    C_HAS_RD_RST                   : integer := 0;
    C_HAS_RST                      : integer := 0;
    C_HAS_SRST                     : integer := 0;
    C_HAS_UNDERFLOW                : integer := 0;
    C_HAS_VALID                    : integer := 0;
    C_HAS_WR_ACK                   : integer := 0;
    C_HAS_WR_DATA_COUNT            : integer := 0;
    C_HAS_WR_RST                   : integer := 0;
    C_INIT_WR_PNTR_VAL             : integer := 0;
    C_MEMORY_TYPE                  : integer := 1;
    C_MIF_FILE_NAME                : string  := "";
    C_OPTIMIZATION_MODE            : integer := 0;
    C_OVERFLOW_LOW                 : integer := 0;
    C_PRELOAD_REGS                 : integer := 0;
    C_PRELOAD_LATENCY              : integer := 1;
    C_PROG_EMPTY_THRESH_ASSERT_VAL : integer := 0;
    C_PROG_EMPTY_THRESH_NEGATE_VAL : integer := 0;
    C_PROG_EMPTY_TYPE              : integer := 0;
    C_PROG_FULL_THRESH_ASSERT_VAL  : integer := 0;
    C_PROG_FULL_THRESH_NEGATE_VAL  : integer := 0;
    C_PROG_FULL_TYPE               : integer := 0;
    C_RD_DATA_COUNT_WIDTH          : integer := 2;
    C_RD_DEPTH                     : integer := 256;
    C_RD_PNTR_WIDTH                : integer := 8;
    C_UNDERFLOW_LOW                : integer := 0;
    C_VALID_LOW                    : integer := 0;
    C_WR_ACK_LOW                   : integer := 0;
    C_WR_DATA_COUNT_WIDTH          : integer := 2;
    C_WR_DEPTH                     : integer := 256;
    C_WR_PNTR_WIDTH                : integer := 8;
    C_WR_RESPONSE_LATENCY          : integer := 1;
    C_FULL_FLAGS_RST_VAL           : integer := 1;
    C_USE_EMBEDDED_REG             : integer := 0
    );


  PORT(
--------------------------------------------------------------------------------
-- Input and Output Declarations
--------------------------------------------------------------------------------
    CLK                      : IN std_logic                                    := '0';
    BACKUP                   : IN std_logic                                    := '0';
    BACKUP_MARKER            : IN std_logic                                    := '0';
    DIN                      : IN std_logic_vector(C_DIN_WIDTH-1 DOWNTO 0)     := (OTHERS => '0');
    PROG_EMPTY_THRESH        : IN std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    PROG_EMPTY_THRESH_ASSERT : IN std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    PROG_EMPTY_THRESH_NEGATE : IN std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    PROG_FULL_THRESH         : IN std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    PROG_FULL_THRESH_ASSERT  : IN std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    PROG_FULL_THRESH_NEGATE  : IN std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    RD_CLK                   : IN std_logic                                    := '0';
    RD_EN                    : IN std_logic                                    := '0';
    RD_RST                   : IN std_logic                                    := '0';
    RST                      : IN std_logic                                    := '0';
    SRST                     : IN std_logic                                    := '0';
    WR_CLK                   : IN std_logic                                    := '0';
    WR_EN                    : IN std_logic                                    := '0';
    WR_RST                   : IN std_logic                                    := '0';

    ALMOST_EMPTY  : OUT std_logic;
    ALMOST_FULL   : OUT std_logic;
    DATA_COUNT    : OUT std_logic_vector(C_DATA_COUNT_WIDTH-1 DOWNTO 0);
    DOUT          : OUT std_logic_vector(C_DOUT_WIDTH-1 DOWNTO 0);
    EMPTY         : OUT std_logic;
    FULL          : OUT std_logic;
    OVERFLOW      : OUT std_logic;
    PROG_EMPTY    : OUT std_logic;
    PROG_FULL     : OUT std_logic;
    VALID         : OUT std_logic;
    RD_DATA_COUNT : OUT std_logic_vector(C_RD_DATA_COUNT_WIDTH-1 DOWNTO 0);
    UNDERFLOW     : OUT std_logic;
    WR_ACK        : OUT std_logic;
    WR_DATA_COUNT : OUT std_logic_vector(C_WR_DATA_COUNT_WIDTH-1 DOWNTO 0)
    );

  END COMPONENT;

  COMPONENT fifo_generator_v4_1_bhv_preload0
    GENERIC (
      C_DOUT_RST_VAL      : string;
      C_DOUT_WIDTH        : integer;
      C_HAS_RST           : integer;
      C_USERVALID_LOW     : integer := 0;
      C_USERUNDERFLOW_LOW : integer := 0);
    PORT (
      RD_CLK           : IN  std_logic;
      RD_RST           : IN  std_logic;
      RD_EN            : IN  std_logic;
      FIFOEMPTY        : IN  std_logic;
      FIFODATA         : IN  std_logic_vector(C_DOUT_WIDTH-1 DOWNTO 0);
      USERDATA         : OUT std_logic_vector(C_DOUT_WIDTH-1 DOWNTO 0);
      USERVALID        : OUT std_logic;
      USERUNDERFLOW    : OUT std_logic;
      USEREMPTY        : OUT std_logic;
      USERALMOSTEMPTY  : OUT std_logic;
      RAMVALID         : OUT std_logic;
      FIFORDEN         : OUT std_logic);
  END COMPONENT;



  SIGNAL zero : std_logic := '0';



  -----------------------------------------------------------------------------
  -- Internal Signals
  --  In the normal case, these signals tie directly to the FIFO's inputs and
  --  outputs.
  --  In the case of Preload Latency 0 or 1, these are the intermediate
  --  signals between the internal FIFO and the preload logic.
  -----------------------------------------------------------------------------
    SIGNAL rd_en_fifo_in          : std_logic;
    SIGNAL dout_fifo_out          : std_logic_vector(C_DOUT_WIDTH-1 DOWNTO 0);
    SIGNAL empty_fifo_out         : std_logic;
    SIGNAL almost_empty_fifo_out  : std_logic;
    SIGNAL valid_fifo_out         : std_logic;
    SIGNAL underflow_fifo_out     : std_logic;
    SIGNAL rd_data_count_fifo_out : std_logic_vector(C_RD_DATA_COUNT_WIDTH-1 DOWNTO 0);
    SIGNAL wr_data_count_fifo_out : std_logic_vector(C_WR_DATA_COUNT_WIDTH-1 DOWNTO 0);

    SIGNAL dout_p0_out            : std_logic_vector(C_DOUT_WIDTH-1 DOWNTO 0);
    signal valid_p0_out           : std_logic;
    signal empty_p0_out           : std_logic;
    signal underflow_p0_out       : std_logic;
    signal almost_empty_p0_out    : std_logic;

    signal empty_p0_out_q         : std_logic;
    signal almost_empty_p0_out_q  : std_logic;

    SIGNAL ram_valid              : std_logic;  --Internal signal used to monitor the
                                         --ram_valid state


BEGIN

  --Assign Ground Signal
  zero <= '0';
  
  --Fixed CR:422741 in v3.2 (IP2_Im) --prasanna
  ASSERT (C_IMPLEMENTATION_TYPE /= 3 and C_IMPLEMENTATION_TYPE /= 4) REPORT "FAILURE: Use of behavioral models for Virtex-4 and Virtex-5 built-in FIFO configurations is currently not supported. Please use the structural simulation model. You can enable this from CORE Generator by selecting Project -> Project Options -> Generation tab -> Structural Simulation. See the FIFO Generator User Guide for more information." SEVERITY FAILURE;
  
  --Fixed CR:422741 in v3.2 (IP2_Im) --prasanna
  ASSERT (C_IMPLEMENTATION_TYPE /= 2) REPORT "Warning in %m at time %t: When using an asynchronous configuration for the FIFO Generator, the behavioral model is not cycle-accurate. You may wish to choose the structural simulation model instead of the behavioral model. This will ensure accurate behavior and latencies during simulation. You can enable this from CORE Generator by selecting Project -> Project Options -> Generation tab -> Structural Simulation. See the FIFO Generator User Guide for more information." SEVERITY NOTE;


  gen_ss : IF ((C_IMPLEMENTATION_TYPE = 0) OR (C_IMPLEMENTATION_TYPE = 1)) GENERATE
    fgss : fifo_generator_v4_1_bhv_ss
      GENERIC MAP (
        C_COMMON_CLOCK                 => C_COMMON_CLOCK,
        C_COUNT_TYPE                   => C_COUNT_TYPE,
        C_DATA_COUNT_WIDTH             => C_DATA_COUNT_WIDTH,
        C_DEFAULT_VALUE                => C_DEFAULT_VALUE,
        C_DIN_WIDTH                    => C_DIN_WIDTH,
        C_DOUT_RST_VAL                 => C_DOUT_RST_VAL,
        C_DOUT_WIDTH                   => C_DOUT_WIDTH,
        C_ENABLE_RLOCS                 => C_ENABLE_RLOCS,
        C_FAMILY                       => C_FAMILY,
        C_HAS_ALMOST_EMPTY             => C_HAS_ALMOST_EMPTY,
        C_HAS_ALMOST_FULL              => C_HAS_ALMOST_FULL,
        C_HAS_BACKUP                   => C_HAS_BACKUP,
        C_HAS_DATA_COUNT               => C_HAS_DATA_COUNT,
        C_HAS_MEMINIT_FILE             => C_HAS_MEMINIT_FILE,
        C_HAS_OVERFLOW                 => C_HAS_OVERFLOW,
        C_HAS_RD_DATA_COUNT            => C_HAS_RD_DATA_COUNT,
        C_HAS_RD_RST                   => C_HAS_RD_RST,
        C_HAS_RST                      => C_HAS_RST,
        C_HAS_SRST                     => C_HAS_SRST,
        C_HAS_UNDERFLOW                => C_HAS_UNDERFLOW,
        C_HAS_VALID                    => C_HAS_VALID,
        C_HAS_WR_ACK                   => C_HAS_WR_ACK,
        C_HAS_WR_DATA_COUNT            => C_HAS_WR_DATA_COUNT,
        C_HAS_WR_RST                   => C_HAS_WR_RST,
        C_INIT_WR_PNTR_VAL             => C_INIT_WR_PNTR_VAL,
        C_MEMORY_TYPE                  => C_MEMORY_TYPE,
        C_MIF_FILE_NAME                => C_MIF_FILE_NAME,
        C_OPTIMIZATION_MODE            => C_OPTIMIZATION_MODE,
        C_OVERFLOW_LOW                 => C_OVERFLOW_LOW,
        C_PRELOAD_LATENCY              => C_PRELOAD_LATENCY,
        C_PRELOAD_REGS                 => C_PRELOAD_REGS,
        C_PROG_EMPTY_THRESH_ASSERT_VAL => C_PROG_EMPTY_THRESH_ASSERT_VAL,
        C_PROG_EMPTY_THRESH_NEGATE_VAL => C_PROG_EMPTY_THRESH_NEGATE_VAL,
        C_PROG_EMPTY_TYPE              => C_PROG_EMPTY_TYPE,
        C_PROG_FULL_THRESH_ASSERT_VAL  => C_PROG_FULL_THRESH_ASSERT_VAL,
        C_PROG_FULL_THRESH_NEGATE_VAL  => C_PROG_FULL_THRESH_NEGATE_VAL,
        C_PROG_FULL_TYPE               => C_PROG_FULL_TYPE,
        C_RD_DATA_COUNT_WIDTH          => C_RD_DATA_COUNT_WIDTH,
        C_RD_DEPTH                     => C_RD_DEPTH,
        C_RD_PNTR_WIDTH                => C_RD_PNTR_WIDTH,
        C_UNDERFLOW_LOW                => C_UNDERFLOW_LOW,
        C_VALID_LOW                    => C_VALID_LOW,
        C_WR_ACK_LOW                   => C_WR_ACK_LOW,
        C_WR_DATA_COUNT_WIDTH          => C_WR_DATA_COUNT_WIDTH,
        C_WR_DEPTH                     => C_WR_DEPTH,
        C_WR_PNTR_WIDTH                => C_WR_PNTR_WIDTH,
        C_WR_RESPONSE_LATENCY          => C_WR_RESPONSE_LATENCY,
        C_FULL_FLAGS_RST_VAL           => C_FULL_FLAGS_RST_VAL,
        C_USE_EMBEDDED_REG             => C_USE_EMBEDDED_REG
        )
      PORT MAP(
        --Inputs
        CLK                       => CLK,
        BACKUP                    => BACKUP,
        BACKUP_MARKER             => BACKUP_MARKER,
        DIN                       => DIN,
        PROG_EMPTY_THRESH         => PROG_EMPTY_THRESH,
        PROG_EMPTY_THRESH_ASSERT  => PROG_EMPTY_THRESH_ASSERT,
        PROG_EMPTY_THRESH_NEGATE  => PROG_EMPTY_THRESH_NEGATE,
        PROG_FULL_THRESH          => PROG_FULL_THRESH,
        PROG_FULL_THRESH_ASSERT   => PROG_FULL_THRESH_ASSERT,
        PROG_FULL_THRESH_NEGATE   => PROG_FULL_THRESH_NEGATE,
        RD_CLK                    => zero,
        RD_EN                     => RD_EN,
        RD_RST                    => RD_RST,
        RST                       => RST,
        SRST                      => SRST,
        WR_CLK                    => zero,
        WR_EN                     => WR_EN,
        WR_RST                    => WR_RST,

        --Outputs
        ALMOST_EMPTY          => almost_empty_fifo_out,
        ALMOST_FULL           => ALMOST_FULL,
        DATA_COUNT            => DATA_COUNT,
        DOUT                  => dout_fifo_out,
        EMPTY                 => empty_fifo_out,
        FULL                  => FULL,
        OVERFLOW              => OVERFLOW,
        PROG_EMPTY            => PROG_EMPTY,
        PROG_FULL             => PROG_FULL,
        RD_DATA_COUNT         => rd_data_count_fifo_out,
        UNDERFLOW             => underflow_fifo_out,
        VALID                 => valid_fifo_out,
        WR_ACK                => WR_ACK,
        WR_DATA_COUNT         => wr_data_count_fifo_out
        );
  END GENERATE gen_ss;



  gen_as : IF (C_IMPLEMENTATION_TYPE = 2) GENERATE

    fgas : fifo_generator_v4_1_bhv_as
      GENERIC MAP (
        C_DIN_WIDTH                    => C_DIN_WIDTH,
        C_DOUT_RST_VAL                 => C_DOUT_RST_VAL,
        C_DOUT_WIDTH                   => C_DOUT_WIDTH,
        C_ENABLE_RLOCS                 => C_ENABLE_RLOCS,
        C_FAMILY                       => C_FAMILY,
        C_HAS_ALMOST_EMPTY             => C_HAS_ALMOST_EMPTY,
        C_HAS_ALMOST_FULL              => C_HAS_ALMOST_FULL,
        C_HAS_OVERFLOW                 => C_HAS_OVERFLOW,
        C_PROG_EMPTY_TYPE              => C_PROG_EMPTY_TYPE,
        C_PROG_EMPTY_THRESH_ASSERT_VAL => C_PROG_EMPTY_THRESH_ASSERT_VAL,
        C_PROG_EMPTY_THRESH_NEGATE_VAL => C_PROG_EMPTY_THRESH_NEGATE_VAL,
        C_PROG_FULL_TYPE               => C_PROG_FULL_TYPE,
        C_PROG_FULL_THRESH_ASSERT_VAL  => C_PROG_FULL_THRESH_ASSERT_VAL,
        C_PROG_FULL_THRESH_NEGATE_VAL  => C_PROG_FULL_THRESH_NEGATE_VAL,
        C_HAS_VALID                    => C_HAS_VALID,
        C_HAS_RD_DATA_COUNT            => C_HAS_RD_DATA_COUNT,
        C_HAS_RST                      => C_HAS_RST,
        C_HAS_UNDERFLOW                => C_HAS_UNDERFLOW,
        C_HAS_WR_ACK                   => C_HAS_WR_ACK,
        C_HAS_WR_DATA_COUNT            => C_HAS_WR_DATA_COUNT,
        C_MEMORY_TYPE                  => C_MEMORY_TYPE,
        C_OPTIMIZATION_MODE            => C_OPTIMIZATION_MODE,
        C_OVERFLOW_LOW                 => C_OVERFLOW_LOW,
        C_PRELOAD_LATENCY              => C_PRELOAD_LATENCY,
        C_PRELOAD_REGS                 => C_PRELOAD_REGS,
        C_VALID_LOW                    => C_VALID_LOW,
        C_RD_DATA_COUNT_WIDTH          => C_RD_DATA_COUNT_WIDTH,
        C_RD_DEPTH                     => C_RD_DEPTH,
        C_RD_PNTR_WIDTH                => C_RD_PNTR_WIDTH,
        C_UNDERFLOW_LOW                => C_UNDERFLOW_LOW,
        C_WR_ACK_LOW                   => C_WR_ACK_LOW,
        C_WR_DATA_COUNT_WIDTH          => C_WR_DATA_COUNT_WIDTH,
        C_WR_DEPTH                     => C_WR_DEPTH,
        C_WR_PNTR_WIDTH                => C_WR_PNTR_WIDTH,
        C_WR_RESPONSE_LATENCY          => C_WR_RESPONSE_LATENCY,
        C_FULL_FLAGS_RST_VAL           => C_FULL_FLAGS_RST_VAL,
        C_USE_EMBEDDED_REG             => C_USE_EMBEDDED_REG,
        C_USE_FWFT_DATA_COUNT          => C_USE_FWFT_DATA_COUNT
        )
      PORT MAP(
        --Inputs
        WR_CLK                         => WR_CLK,
        RD_CLK                         => RD_CLK,
        RST                            => RST,
        DIN                            => DIN,
        WR_EN                          => WR_EN,
        RD_EN                          => rd_en_fifo_in,
        PROG_FULL_THRESH               => PROG_FULL_THRESH,
        PROG_EMPTY_THRESH_ASSERT       => PROG_EMPTY_THRESH_ASSERT,
        PROG_EMPTY_THRESH_NEGATE       => PROG_EMPTY_THRESH_NEGATE,
        PROG_EMPTY_THRESH              => PROG_EMPTY_THRESH,
        PROG_FULL_THRESH_ASSERT        => PROG_FULL_THRESH_ASSERT,
        PROG_FULL_THRESH_NEGATE        => PROG_FULL_THRESH_NEGATE,

        --Outputs
        DOUT                  => dout_fifo_out,
        FULL                  => FULL,
        ALMOST_FULL           => ALMOST_FULL,
        WR_ACK                => WR_ACK,
        OVERFLOW              => OVERFLOW,
        EMPTY                 => empty_fifo_out,
        ALMOST_EMPTY          => almost_empty_fifo_out,
        VALID                 => valid_fifo_out,
        UNDERFLOW             => underflow_fifo_out,
        RD_DATA_COUNT         => rd_data_count_fifo_out,
        WR_DATA_COUNT         => wr_data_count_fifo_out,
        PROG_FULL             => PROG_FULL,
        PROG_EMPTY            => PROG_EMPTY
        );

  END GENERATE gen_as;


  gen_other : IF (C_IMPLEMENTATION_TYPE = 4) GENERATE

    fgoth : fifo_generator_v4_1_bhv_as
      GENERIC MAP (
        C_DIN_WIDTH                    => C_DIN_WIDTH,
        C_DOUT_RST_VAL                 => C_DOUT_RST_VAL,
        C_DOUT_WIDTH                   => C_DOUT_WIDTH,
        C_ENABLE_RLOCS                 => C_ENABLE_RLOCS,
        C_FAMILY                       => C_FAMILY,
        C_HAS_ALMOST_EMPTY             => C_HAS_ALMOST_EMPTY,
        C_HAS_ALMOST_FULL              => C_HAS_ALMOST_FULL,
        C_HAS_OVERFLOW                 => C_HAS_OVERFLOW,
        C_PROG_EMPTY_TYPE              => C_PROG_EMPTY_TYPE,
        C_PROG_EMPTY_THRESH_ASSERT_VAL => C_PROG_EMPTY_THRESH_ASSERT_VAL,
        C_PROG_EMPTY_THRESH_NEGATE_VAL => C_PROG_EMPTY_THRESH_NEGATE_VAL,
        C_PROG_FULL_TYPE               => C_PROG_FULL_TYPE,
        C_PROG_FULL_THRESH_ASSERT_VAL  => C_PROG_FULL_THRESH_ASSERT_VAL,
        C_PROG_FULL_THRESH_NEGATE_VAL  => C_PROG_FULL_THRESH_NEGATE_VAL,
        C_HAS_VALID                    => C_HAS_VALID,
        C_HAS_RD_DATA_COUNT            => C_HAS_RD_DATA_COUNT,
        C_HAS_RST                      => C_HAS_RST,
        C_HAS_UNDERFLOW                => C_HAS_UNDERFLOW,
        C_HAS_WR_ACK                   => C_HAS_WR_ACK,
        C_HAS_WR_DATA_COUNT            => C_HAS_WR_DATA_COUNT,
        C_MEMORY_TYPE                  => C_MEMORY_TYPE,
        C_OPTIMIZATION_MODE            => C_OPTIMIZATION_MODE,
        C_OVERFLOW_LOW                 => C_OVERFLOW_LOW,
        C_PRELOAD_LATENCY              => C_PRELOAD_LATENCY,
        C_PRELOAD_REGS                 => C_PRELOAD_REGS,
        C_VALID_LOW                    => C_VALID_LOW,
        C_RD_DATA_COUNT_WIDTH          => C_RD_DATA_COUNT_WIDTH,
        C_RD_DEPTH                     => C_RD_DEPTH,
        C_RD_PNTR_WIDTH                => C_RD_PNTR_WIDTH,
        C_UNDERFLOW_LOW                => C_UNDERFLOW_LOW,
        C_WR_ACK_LOW                   => C_WR_ACK_LOW,
        C_WR_DATA_COUNT_WIDTH          => C_WR_DATA_COUNT_WIDTH,
        C_WR_DEPTH                     => C_WR_DEPTH,
        C_WR_PNTR_WIDTH                => C_WR_PNTR_WIDTH,
        C_WR_RESPONSE_LATENCY          => C_WR_RESPONSE_LATENCY,
        C_USE_EMBEDDED_REG             => C_USE_EMBEDDED_REG,
        C_USE_FWFT_DATA_COUNT          => C_USE_FWFT_DATA_COUNT
        )
      PORT MAP(
        --Inputs
        WR_CLK                         => WR_CLK,
        RD_CLK                         => RD_CLK,
        RST                            => RST,
        DIN                            => DIN,
        WR_EN                          => WR_EN,
        RD_EN                          => RD_EN,
        PROG_FULL_THRESH               => PROG_FULL_THRESH,
        PROG_EMPTY_THRESH_ASSERT       => PROG_EMPTY_THRESH_ASSERT,
        PROG_EMPTY_THRESH_NEGATE       => PROG_EMPTY_THRESH_NEGATE,
        PROG_EMPTY_THRESH              => PROG_EMPTY_THRESH,
        PROG_FULL_THRESH_ASSERT        => PROG_FULL_THRESH_ASSERT,
        PROG_FULL_THRESH_NEGATE        => PROG_FULL_THRESH_NEGATE,

        --Outputs
        DOUT                  => DOUT,
        FULL                  => FULL,
        ALMOST_FULL           => ALMOST_FULL,
        WR_ACK                => WR_ACK,
        OVERFLOW              => OVERFLOW,
        EMPTY                 => EMPTY,
        ALMOST_EMPTY          => ALMOST_EMPTY,
        VALID                 => VALID,
        UNDERFLOW             => UNDERFLOW,
        RD_DATA_COUNT         => rd_data_count_fifo_out,
        WR_DATA_COUNT         => wr_data_count_fifo_out,
        PROG_FULL             => PROG_FULL,
        PROG_EMPTY            => PROG_EMPTY
        );

  END GENERATE gen_other;


  -----------------------------------------------------------------------------
  -- Connect Internal Signals
  --  In the normal case, these signals tie directly to the FIFO's inputs and
  --  outputs.
  --  In the case of Preload Latency 0 or 1, these are the intermediate
  --  signals between the internal FIFO and the preload logic.
  -----------------------------------------------------------------------------
  latnrm: IF (C_PRELOAD_LATENCY=1 OR C_PRELOAD_LATENCY=2) GENERATE
     rd_en_fifo_in <= RD_EN;
     DOUT          <= dout_fifo_out;
     VALID         <= valid_fifo_out;
     EMPTY         <= empty_fifo_out;
     ALMOST_EMPTY  <= almost_empty_fifo_out;
     UNDERFLOW     <= underflow_fifo_out;
     RD_DATA_COUNT <= rd_data_count_fifo_out;
     WR_DATA_COUNT <= wr_data_count_fifo_out;
  END GENERATE latnrm;


  lat0: IF ((C_PRELOAD_REGS = 1) AND (C_PRELOAD_LATENCY = 0)) GENERATE

    lat0logic : fifo_generator_v4_1_bhv_preload0
      GENERIC MAP (
        C_DOUT_RST_VAL      => C_DOUT_RST_VAL,
        C_DOUT_WIDTH        => C_DOUT_WIDTH,
        C_HAS_RST           => C_HAS_RST,
        C_USERVALID_LOW     => C_VALID_LOW,
        C_USERUNDERFLOW_LOW => C_UNDERFLOW_LOW)
      PORT MAP (
        RD_CLK          => RD_CLK,
        RD_RST          => RST,
        RD_EN           => RD_EN,
        FIFOEMPTY       => empty_fifo_out,
        FIFODATA        => dout_fifo_out,
        USERDATA        => dout_p0_out,
        USERVALID       => valid_p0_out,
        USEREMPTY       => empty_p0_out,
        USERALMOSTEMPTY => almost_empty_p0_out,
        USERUNDERFLOW   => underflow_p0_out,
        RAMVALID        => ram_valid, --Used for observing the state of the ram_valid
        FIFORDEN        => rd_en_fifo_in);

    rdcg: IF (C_USE_FWFT_DATA_COUNT=1) GENERATE
      eclk: PROCESS (RD_CLK)
      BEGIN  -- process eclk
        IF (RST='1') THEN
          empty_p0_out_q        <= '1';
          almost_empty_p0_out_q <= '1';
        ELSIF RD_CLK'event AND RD_CLK = '1' THEN  -- rising clock edge
          empty_p0_out_q        <= empty_p0_out;
          almost_empty_p0_out_q <= almost_empty_p0_out;
        END IF;
      END PROCESS eclk;

      rcsproc: PROCESS (rd_data_count_fifo_out, empty_p0_out_q, 
                        almost_empty_p0_out_q)
      BEGIN  -- process rcsproc
        IF (empty_p0_out_q='1' OR RST='1') THEN
          RD_DATA_COUNT <= int_2_std_logic_vector(0, C_RD_DATA_COUNT_WIDTH);
        ELSIF (almost_empty_p0_out_q='1') THEN
          RD_DATA_COUNT <= int_2_std_logic_vector(1, C_RD_DATA_COUNT_WIDTH);
        ELSE
          RD_DATA_COUNT <= rd_data_count_fifo_out ;
        END IF;
      END PROCESS rcsproc;

    END GENERATE rdcg;
    nrdcg: IF (C_USE_FWFT_DATA_COUNT=0) GENERATE
      RD_DATA_COUNT <= rd_data_count_fifo_out;
    END GENERATE nrdcg;


    WR_DATA_COUNT <= wr_data_count_fifo_out;

    DOUT          <= dout_p0_out;
    VALID         <= valid_p0_out;
    EMPTY         <= empty_p0_out;
    ALMOST_EMPTY  <= almost_empty_p0_out;
    UNDERFLOW     <= underflow_p0_out;

  END GENERATE lat0;



  SBITERR       <= '0';
  DBITERR       <= '0';


END behavioral;



