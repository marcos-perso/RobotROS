-------------------------------------------------------------------------------
-- $RCSfile: fifo_generator_v1_0.vhd,v $ $Revision: 1.1 $ $Date: 2010-07-10 21:43:07 $
-------------------------------------------------------------------------------
--
-- FIFO Generator v1_0 - VHDL Behavioral Model
--
-------------------------------------------------------------------------------
--                                                                       
-- Copyright(C) 2004 by Xilinx, Inc. All rights reserved.
-- This text contains propritary confidential information
-- of Xilinx, Inc., is distributed by and under license from
-- Xilinx, Inc., and may be used, copied and/or disclosed
-- only pursuant to the terms of a valid license agreement
-- with Xilinx, Inc.
--
-- Unmodified source code will substantially conform to the
-- datasheet specifications, and is guaranteed to place
-- and route, and function according to the datasheet
-- specification. There may be discrepancies in the
-- performance of the source code vs the netlist. Source
-- code is provided "as is", with no obligation on the
-- part of Xilinx to provide support.
--
-- Xilinx Hotline support of source code IP shall only
-- include standard level Xilinx Hotline support, and
-- will only address issues and questions related to the
-- standard released Netlist version of the core (and
-- thus indirectly, the original core source).
--
-- This copyright and support notice must be retained as
-- part of this text at all times.
--
-----------------------------------------------------------------------------
--
-- Filename: fifo_generator_v1_0_bhv.vhd
--
-- Description: 
--  The behavioral model for the FIFO Generator.
--                      
-------------------------------------------------------------------------------




-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--  Asynchronous FIFO Behavioral Model                                   
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Library Declaration
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

-- LIBRARY work;                        --SIM
-- USE work.iputils_conv.ALL;           --SIM
-- USE work.iputils_misc.ALL;           --SIM

LIBRARY XilinxCoreLib;                  --XCC
USE XilinxCoreLib.iputils_conv.ALL;     --XCC
USE XilinxCoreLib.iputils_misc.ALL;     --XCC

-------------------------------------------------------------------------------
-- Entity Declaration
-------------------------------------------------------------------------------
ENTITY fifo_generator_v1_0_bhv_as IS

  GENERIC (
    --------------------------------------------------------------------------------
    -- Generic Declarations
    --------------------------------------------------------------------------------
    --C_COMMON_CLOCK            :     integer := DEFAULT_COMMON_CLOCK;
    --C_COUNT_TYPE              :     integer := DEFAULT_COUNT_TYPE;
    --C_DATA_COUNT_WIDTH        :     integer := DEFAULT_DATA_COUNT_WIDTH;
    --C_DEFAULT_VALUE           :     string  := DEFAULT_DEFAULT_VALUE;
    C_DIN_WIDTH                    :    integer := 8;
    C_DOUT_RST_VAL                 :    string  := "";
    C_DOUT_WIDTH                   :    integer := 8;
    C_ENABLE_RLOCS                 :    integer := 0;
    C_FAMILY                       :    string  := "";
    C_HAS_ALMOST_FULL              :    integer := 0;
    C_HAS_ALMOST_EMPTY             :    integer := 0;
    --C_HAS_BACKUP              :     integer := DEFAULT_HAS_BACKUP;
    --C_HAS_DATA_COUNT          :     integer := DEFAULT_HAS_DATA_COUNT;
    --C_HAS_MEMINIT_FILE        :     integer := DEFAULT_HAS_MEMINIT_FILE;
    C_HAS_OVERFLOW                 :    integer := 0;
    --C_HAS_PROG_EMPTY          :     integer := DEFAULT_HAS_PROG_EMPTY;
    --C_HAS_PROG_EMPTY_THRESH   :     integer := DEFAULT_HAS_PROG_EMPTY_THRESH;
    --C_HAS_PROG_FULL           :     integer := DEFAULT_HAS_PROG_FULL;
    --C_HAS_PROG_FULL_THRESH    :     integer := DEFAULT_HAS_PROG_FULL_THRESH;
    C_HAS_RD_DATA_COUNT            :    integer := 2;
    C_HAS_VALID                    :    integer := 0;
    --C_HAS_RD_RST              :     integer := DEFAULT_HAS_RD_RST;
    C_HAS_RST                      :    integer := 1;
    C_HAS_UNDERFLOW                :    integer := 0;
    C_HAS_WR_ACK                   :    integer := 0;
    C_HAS_WR_DATA_COUNT            :    integer := 2;
    --C_HAS_WR_RST              :     integer := DEFAULT_HAS_WR_RST;
    --C_INIT_WR_PNTR_VAL        :     integer := DEFAULT_INIT_WR_PNTR_VAL;
    C_MEMORY_TYPE                  :    integer := 1;
    --C_MIF_FILE_NAME           :     string  := DEFAULT_MIF_FILE_NAME;
    C_OPTIMIZATION_MODE            :    integer := 0;
    C_WR_RESPONSE_LATENCY          :    integer := 1;
    C_OVERFLOW_LOW                 :    integer := 0;
    C_PRELOAD_REGS                 :    integer := 0;
    C_PRELOAD_LATENCY              :    integer := 1;
    --C_PROG_EMPTY_ASSERT       :     integer := DEFAULT_PROG_EMPTY_ASSERT;
    --C_PROG_EMPTY_NEGATE       :     integer := DEFAULT_PROG_EMPTY_NEGATE;
    --C_PROG_FULL_ASSERT        :     integer := DEFAULT_PROG_FULL_ASSERT;
    --C_PROG_FULL_NEGATE        :     integer := DEFAULT_PROG_FULL_NEGATE;
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
    C_WR_PNTR_WIDTH                :    integer := 8
    );
  PORT(
--------------------------------------------------------------------------------
-- Input and Output Declarations
--------------------------------------------------------------------------------
    --CLK                       : IN  std_logic;
    --BACKUP                    : IN  std_logic;
    --BACKUP_MARKER             : IN  std_logic;
    DIN                            : IN std_logic_vector(C_DIN_WIDTH-1 DOWNTO 0);
    PROG_EMPTY_THRESH              : IN std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
    PROG_EMPTY_THRESH_ASSERT       : IN std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
    PROG_EMPTY_THRESH_NEGATE       : IN std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
    PROG_FULL_THRESH               : IN std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
    PROG_FULL_THRESH_ASSERT        : IN std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
    PROG_FULL_THRESH_NEGATE        : IN std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
    RD_CLK                         : IN std_logic;
    RD_EN                          : IN std_logic;
    --RD_RST                    : IN  std_logic;
    RST                            : IN std_logic;
    WR_CLK                         : IN std_logic;
    WR_EN                          : IN std_logic;
    --WR_RST                    : IN  std_logic;

    ALMOST_EMPTY  : OUT std_logic;
    ALMOST_FULL   : OUT std_logic;
    --DATA_COUNT                : OUT STD_LOGIC_VECTOR(C_DATA_COUNT_WIDTH-1 DOWNTO 0);
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
    WR_DATA_COUNT : OUT std_logic_vector(C_WR_DATA_COUNT_WIDTH-1 DOWNTO 0);

    DEBUG_WR_PNTR         : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
    DEBUG_RD_PNTR         : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
    DEBUG_RAM_WR_EN       : OUT std_logic;
    DEBUG_RAM_RD_EN       : OUT std_logic;
    debug_wr_pntr_w       : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
    debug_wr_pntr_plus1_w : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
    debug_wr_pntr_plus2_w : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
    debug_wr_pntr_r       : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
    debug_rd_pntr_r       : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
    debug_rd_pntr_plus1_r : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
    debug_rd_pntr_w       : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
    DEBUG_RAM_EMPTY       : OUT std_logic;
    DEBUG_RAM_FULL        : OUT std_logic
    );



END fifo_generator_v1_0_bhv_as;

-------------------------------------------------------------------------------
-- Definition of Ports
-- DIN : Input data bus for the fifo.
-- DOUT : Output data bus for the fifo.
-- AINIT : Asynchronous Reset for the fifo.
-- WR_EN : Write enable signal.
-- WR_CLK : Write Clock.
-- FULL : Full signal.
-- ALMOST_FULL : One space left.
-- WR_ACK : Last write acknowledged.
-- WR_ERR : Last write rejected.
-- WR_COUNT : Number of data words in fifo(synchronous to WR_CLK)
-- Rd_EN : Read enable signal.
-- RD_CLK : Read Clock.
-- EMPTY : Empty signal.
-- ALMOST_EMPTY: One sapce left
-- VALID : Last read acknowledged.
-- RD_ERR : Last read rejected.
-- RD_COUNT : Number of data words in fifo(synchronous to RD_CLK)
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Architecture Heading
-------------------------------------------------------------------------------
ARCHITECTURE behavioral OF fifo_generator_v1_0_bhv_as IS



-------------------------------------------------------------------------------
-- actual_fifo_depth
-- Returns the actual depth of the FIFO (may differ from what the user specified)
--
-- The FIFO depth is always represented as 2^n (16,32,64,128,256)
-- However, the ACTUAL fifo depth may be 2^n or (2^n - 1) depending on certain
-- options. This function returns the ACTUAL depth of the fifo, as seen by
-- the user.
--
-- The FIFO depth remains as 2^n when any of the following conditions are true:
-- *C_PRELOAD_REGS=1 AND C_PRELOAD_LATENCY=1 (preload output register adds 1
-- word of depth to the FIFO)
-------------------------------------------------------------------------------
  FUNCTION actual_fifo_depth(c_fifo_depth : integer; C_PRELOAD_REGS : integer; C_PRELOAD_LATENCY : integer) RETURN integer IS
  BEGIN
    IF (C_PRELOAD_REGS = 1 AND C_PRELOAD_LATENCY = 1) THEN
      RETURN c_fifo_depth;
    ELSE
      RETURN c_fifo_depth-1;
    END IF;
  END actual_fifo_depth;

-------------------------------------------------------------------------------
-- actual_mem_depth
-- This is the depth of the memory used in the FIFO, and may differ from the
-- depth of the FIFO itself.
--
-- The FIFO depth is always represented as 2^n (16,32,64,128,256)
-- However, the depth of the memory used in the FIFO may be 2^n or (2^n - 1)
-- depending on certain options. This function returns the actual depth of
-- the memory (AND the pointers used to address it!)
--
-- The FIFO depth remains as 2^n when any of the following conditions are true:
-------------------------------------------------------------------------------
  FUNCTION actual_mem_depth(c_fifo_depth : integer; C_PRELOAD_REGS : integer; C_PRELOAD_LATENCY : integer) RETURN integer IS
  BEGIN
    RETURN c_fifo_depth-1;
  END actual_mem_depth;

--------------------------------------------------------------------------------
-- Derived Constants
--------------------------------------------------------------------------------
  CONSTANT C_FULL_RESET_VAL        : std_logic := '1';
  CONSTANT C_ALMOST_FULL_RESET_VAL : std_logic := '1';
  CONSTANT C_PROG_FULL_RESET_VAL   : std_logic := '1';

  CONSTANT C_FIFO_WR_DEPTH : integer := actual_fifo_depth(C_WR_DEPTH, C_PRELOAD_REGS, C_PRELOAD_LATENCY);
  CONSTANT C_FIFO_RD_DEPTH : integer := actual_fifo_depth(C_RD_DEPTH, C_PRELOAD_REGS, C_PRELOAD_LATENCY);

  CONSTANT C_SMALLER_PNTR_WIDTH : integer := get_lesser(C_WR_PNTR_WIDTH, C_RD_PNTR_WIDTH);
  CONSTANT C_SMALLER_DEPTH      : integer := get_lesser(C_FIFO_WR_DEPTH, C_FIFO_RD_DEPTH);
  CONSTANT C_SMALLER_DATA_WIDTH : integer := get_lesser(C_DIN_WIDTH, C_DOUT_WIDTH);
  CONSTANT C_LARGER_PNTR_WIDTH  : integer := get_greater(C_WR_PNTR_WIDTH, C_RD_PNTR_WIDTH);
  CONSTANT C_LARGER_DEPTH       : integer := get_greater(C_FIFO_WR_DEPTH, C_FIFO_RD_DEPTH);
  CONSTANT C_LARGER_DATA_WIDTH  : integer := get_greater(C_DIN_WIDTH, C_DOUT_WIDTH);

  --The write depth to read depth ratio is   C_RATIO_W : C_RATIO_R
  CONSTANT C_RATIO_W : integer := if_then_else( (C_WR_DEPTH > C_RD_DEPTH), (C_WR_DEPTH/C_RD_DEPTH), 1);
  CONSTANT C_RATIO_R : integer := if_then_else( (C_RD_DEPTH > C_WR_DEPTH), (C_RD_DEPTH/C_WR_DEPTH), 1);

  CONSTANT C_PROG_FULL_REG  : integer := 1;
  CONSTANT C_PROG_EMPTY_REG : integer := 1;

  --CONSTANT c_data_width : integer := C_DIN_WIDTH;
  --CONSTANT c_fifo_depth : integer := C_FIFO_WR_DEPTH;
  --CONSTANT actual_depth  : integer := c_fifo_depth;
  --CONSTANT counter_depth : integer := c_fifo_depth + 1;
  CONSTANT counter_depth_wr : integer := C_FIFO_WR_DEPTH + 1;
  CONSTANT counter_depth_rd : integer := C_FIFO_RD_DEPTH + 1;

  SIGNAL wr_point : integer   := 0;
  SIGNAL rd_point : integer   := 0;
  SIGNAL rd_reg0  : integer   := 0;
  SIGNAL rd_reg1  : integer   := 0;
  SIGNAL wr_reg0  : integer   := 0;
  SIGNAL wr_reg1  : integer   := 0;
  SIGNAL empty_i  : std_logic := '0';
  SIGNAL FULL_i   : std_logic := '0';

  SIGNAL rd_clk_i : std_logic;
  SIGNAL wr_clk_i : std_logic;
  SIGNAL rd_rst_i : std_logic;
  SIGNAL wr_rst_i : std_logic;

  SIGNAL rd_data_count_i : std_logic_vector(C_RD_DATA_COUNT_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL wr_data_count_i : std_logic_vector(C_WR_DATA_COUNT_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL wr_diff_count   : std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0)       := (OTHERS => '0');
  SIGNAL rd_diff_count   : std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0)       := (OTHERS => '0');

  SIGNAL wr_ack_i    : std_logic := '0';
  SIGNAL wr_ack_q    : std_logic := '0';
  SIGNAL wr_ack_q2   : std_logic := '0';
  SIGNAL overflow_i  : std_logic := '0';
  SIGNAL overflow_q  : std_logic := '0';
  SIGNAL overflow_q2 : std_logic := '0';

  SIGNAL valid_i     : std_logic := '0';
  SIGNAL underflow_i : std_logic := '0';

  SIGNAL output_regs_valid : std_logic := '0';

  SIGNAL prog_full_noreg   : std_logic := '0';
  SIGNAL prog_full_reg     : std_logic := '0';
  SIGNAL prog_empty_noreg  : std_logic := '0';
  SIGNAL prog_empty_reg    : std_logic := '0';

-------------------------------------------------------------------------------
-- Linked List types
-------------------------------------------------------------------------------
  TYPE listtyp;
  TYPE listptr IS ACCESS listtyp;
  TYPE listtyp IS RECORD
                    data  : std_logic_vector(C_SMALLER_DATA_WIDTH - 1 DOWNTO 0);
                    older : listptr;
                    newer : listptr;
                  END RECORD;


-------------------------------------------------------------------------------
-- Processes for linked list implementation
-------------------------------------------------------------------------------
  --Create a new linked list
  PROCEDURE newlist (head : INOUT listptr; tail : INOUT listptr) IS
  BEGIN
    head := NULL;
    tail := NULL;
  END;  -- procedure newlist;

  --Add a data element to a linked list
  PROCEDURE add (head : INOUT listptr; tail : INOUT listptr; data : IN std_logic_vector) IS
    VARIABLE oldhead  :       listptr;
    VARIABLE newhead  :       listptr;
  BEGIN
    --Create a pointer to the existing head, if applicable
    IF (head /= NULL) THEN
      oldhead       := head;
    END IF;
    --Create a new node for the list
    newhead         := NEW listtyp;
    --Make the new node point to the old head
    newhead.older   := oldhead;
    --Make the old head point back to the new node (for doubly-linked list)
    IF (head /= NULL) THEN
      oldhead.newer := newhead;
    END IF;
    --Put the data into the new head node
    newhead.data    := data;
    --If the new head we just created is the only node in the list, make the tail point to it
    IF (newhead.older = NULL) THEN
      tail          := newhead;
    END IF;
    --Return the new head pointer
    head            := newhead;
  END;  -- procedure; -- add;


  --Read the data from the tail of the linked list
  PROCEDURE read (tail : INOUT listptr; data : OUT std_logic_vector) IS
  BEGIN
    data := tail.data;
  END;  -- procedure; -- read;


  --Remove the tail from the linked list
  PROCEDURE remove (head : INOUT listptr; tail : INOUT listptr) IS
    VARIABLE oldtail     :       listptr;
    VARIABLE newtail     :       listptr;
  BEGIN
    --Make a copy of the old tail pointer
    oldtail         := tail;
    --If there is no newer node, then set the tail pointer to nothing (list is empty)
    IF (oldtail.newer = NULL) THEN
      newtail       := NULL;
      --otherwise, make the next newer node the new tail, and make it point to nothing older
    ELSE
      newtail       := oldtail.newer;
      newtail.older := NULL;
    END IF;
    --Clean up the memory for the old tail node
    DEALLOCATE(oldtail);
    --If the new tail is nothing, then we have an empty list, and head should also be set to nothing
    IF (newtail = NULL) THEN
      head          := NULL;
    END IF;
    --Return the new tail
    tail            := newtail;
  END;  -- procedure; -- remove;


  --Calculate the size of the linked list
  PROCEDURE sizeof (head : INOUT listptr; size : OUT integer) IS
    VARIABLE curlink     :       listptr;
    VARIABLE tmpsize     :       integer := 0;
  BEGIN
    --If head is null, then there is nothing in the list to traverse
    IF (head /= NULL) THEN
      --start with the head node (which implies at least one node exists)
      curlink                            := head;
      tmpsize                            := 1;
      --Loop through each node until you find the one that points to nothing (the tail)
      WHILE (curlink.older /= NULL) LOOP
        tmpsize                          := tmpsize + 1;
        curlink                          := curlink.older;
      END LOOP;
    END IF;
    --Return the number of nodes
    size                                 := tmpsize;
  END;  -- procedure; -- sizeof;


  -- converts integer to std_logic_vector
  FUNCTION conv_to_std_logic_vector( arg  : IN integer;
                                     size : IN integer
                                     ) RETURN std_logic_vector IS
    VARIABLE result                       :    std_logic_vector(size-1 DOWNTO 0);
    VARIABLE temp                         :    integer;

  BEGIN

    temp          := arg;
    FOR i IN 0 TO size-1 LOOP
      IF (temp MOD 2) = 1 THEN
        result(i) := '1';
      ELSE
        result(i) := '0';
      END IF;
      IF temp > 0 THEN
        temp      := temp / 2;
      ELSE
        temp      := (temp - 1) / 2;
      END IF;
    END LOOP;  -- i

    RETURN result;
  END conv_to_std_logic_vector;

  -- converts integer to specified length std_logic_vector : dropping least
  -- significant bits if integer is bigger than what can be represented by
  -- the vector
  FUNCTION count( fifo_count    : IN integer;
                  fifo_depth    : IN integer;
                  counter_width : IN integer
                  ) RETURN std_logic_vector IS
    VARIABLE temp               :    std_logic_vector(fifo_depth-1 DOWNTO 0)      := (OTHERS => '0');
    VARIABLE output             :    std_logic_vector(counter_width - 1 DOWNTO 0) := (OTHERS => '0');
    VARIABLE power              :    integer                                      := 1;
    VARIABLE bits               :    integer                                      := 0;

  BEGIN

    WHILE power       <= fifo_depth LOOP
      power  := power * 2;
      bits   := bits + 1;
    END LOOP;
    temp     := conv_to_std_logic_vector(fifo_count, fifo_depth);
    IF (counter_width <= bits) THEN
      output := temp(bits - 1 DOWNTO bits - counter_width);
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
-- Prepare input signals
-------------------------------------------------------------------------------
  rd_clk_i <= RD_CLK;
  wr_clk_i <= WR_CLK;

  rd_rst_i <= RST;
  wr_rst_i <= RST;



  --Calculate WR_ACK based on C_WR_RESPONSE_LATENCY and C_WR_ACK_LOW parameters
  gwalat0  : IF (C_WR_RESPONSE_LATENCY = 0) GENERATE
    gwalow : IF (C_WR_ACK_LOW = 0) GENERATE
      WR_ACK <= WR_EN AND NOT full_i;
    END GENERATE gwalow;
    gwahgh : IF (C_WR_ACK_LOW = 1) GENERATE
      WR_ACK <= NOT (WR_EN AND NOT full_i);
    END GENERATE gwahgh;
  END GENERATE gwalat0;

  gwalat1  : IF (C_WR_RESPONSE_LATENCY = 1) GENERATE
    gwalow : IF (C_WR_ACK_LOW = 0) GENERATE
      --WR_ACK <= wr_ack_q;
      WR_ACK <= wr_ack_i;
    END GENERATE gwalow;
    gwahgh : IF (C_WR_ACK_LOW = 1) GENERATE
      --WR_ACK <= NOT wr_ack_q;
      WR_ACK <= NOT wr_ack_i;
    END GENERATE gwahgh;
  END GENERATE gwalat1;

  gwalat2  : IF (C_WR_RESPONSE_LATENCY = 2) GENERATE
    gwalow : IF (C_WR_ACK_LOW = 0) GENERATE
      --WR_ACK <= wr_ack_q2;
      WR_ACK <= wr_ack_q;
    END GENERATE gwalow;
    gwahgh : IF (C_WR_ACK_LOW = 1) GENERATE
      --WR_ACK <= NOT wr_ack_q2;
      WR_ACK <= NOT wr_ack_q;
    END GENERATE gwahgh;
  END GENERATE gwalat2;

  --Calculate OVERFLOW based on C_WR_RESPONSE_LATENCY and C_OVERFLOW_LOW parameters
  govlat0  : IF (C_WR_RESPONSE_LATENCY = 0) GENERATE
    govlow : IF (C_OVERFLOW_LOW = 0) GENERATE
      OVERFLOW <= WR_EN AND full_i;
    END GENERATE govlow;
    govhgh : IF (C_OVERFLOW_LOW = 1) GENERATE
      OVERFLOW <= NOT (WR_EN AND full_i);
    END GENERATE govhgh;
  END GENERATE govlat0;

  govlat1  : IF (C_WR_RESPONSE_LATENCY = 1) GENERATE
    govlow : IF (C_OVERFLOW_LOW = 0) GENERATE
      --OVERFLOW <= overflow_q;
      OVERFLOW <= overflow_i;
    END GENERATE govlow;
    govhgh : IF (C_OVERFLOW_LOW = 1) GENERATE
      --OVERFLOW <= NOT overflow_q;
      OVERFLOW <= NOT overflow_i;
    END GENERATE govhgh;
  END GENERATE govlat1;

  govlat2  : IF (C_WR_RESPONSE_LATENCY = 2) GENERATE
    govlow : IF (C_OVERFLOW_LOW = 0) GENERATE
      --OVERFLOW <= overflow_q2;
      OVERFLOW <= overflow_q;
    END GENERATE govlow;
    govhgh : IF (C_OVERFLOW_LOW = 1) GENERATE
      --OVERFLOW <= NOT overflow_q2;
      OVERFLOW <= NOT overflow_q;
    END GENERATE govhgh;
  END GENERATE govlat2;

  --Calculate VALID based on C_PRELOAD_LATENCY and C_VALID_LOW settings
  gvlat1 : IF (C_PRELOAD_LATENCY = 1) GENERATE
    gnvl : IF (C_VALID_LOW = 0) GENERATE
      VALID <= valid_i;
    END GENERATE gnvl;
    gnvh : IF (C_VALID_LOW = 1) GENERATE
      VALID <= NOT valid_i;
    END GENERATE gnvh;
  END GENERATE gvlat1;

  --Calculate UNDERFLOW based on C_PRELOAD_LATENCY and C_VALID_LOW settings
  guflat1 : IF (C_PRELOAD_LATENCY = 1) GENERATE
    gnul  : IF (C_UNDERFLOW_LOW = 0) GENERATE
      UNDERFLOW <= underflow_i;
    END GENERATE gnul;
    gnuh  : IF (C_UNDERFLOW_LOW = 1) GENERATE
      UNDERFLOW <= NOT underflow_i;
    END GENERATE gnuh;
  END GENERATE guflat1;

  --Insert registered delay based on C_PROG_FULL_REG setting
  gpfnreg: IF (C_PROG_FULL_REG = 0) GENERATE
    PROG_FULL <= prog_full_noreg;
  END GENERATE gpfnreg;

  gpfreg: IF (C_PROG_FULL_REG = 1) GENERATE
    PROG_FULL <= prog_full_reg;
  END GENERATE gpfreg;

  --Insert registered delay based on C_PROG_EMPTY_REG setting
  gpenreg: IF (C_PROG_EMPTY_REG = 0) GENERATE
    PROG_EMPTY <= prog_empty_noreg;
  END GENERATE gpenreg;

  gpereg: IF (C_PROG_EMPTY_REG = 1) GENERATE
    PROG_EMPTY <= prog_empty_reg;
  END GENERATE gpereg;  
  
  RD_DATA_COUNT <= rd_diff_count(C_RD_PNTR_WIDTH-1 DOWNTO C_RD_PNTR_WIDTH-C_RD_DATA_COUNT_WIDTH);  --rd_data_count_i;
  WR_DATA_COUNT <= wr_diff_count(C_WR_PNTR_WIDTH-1 DOWNTO C_WR_PNTR_WIDTH-C_WR_DATA_COUNT_WIDTH);  --wr_data_count_i;
  FULL          <= FULL_i;
  EMPTY         <= empty_i;

-------------------------------------------------------------------------------
-- Asynchrounous FIFO using linked lists
-------------------------------------------------------------------------------
  FIFO_PROC : PROCESS (wr_clk_i, rd_clk_i, rd_rst_i, wr_rst_i, FULL_i, WR_EN)

    VARIABLE head : listptr;
    VARIABLE tail : listptr;
    VARIABLE size : integer                                     := 0;
    VARIABLE data : std_logic_vector(c_dout_width - 1 DOWNTO 0) := (OTHERS => '0');

  BEGIN

    --Calculate the current contents of the FIFO (size)
    -- Warning: This value should only be calculated once each time this
    -- process is entered. It is updated instantaneously.
    sizeof(head, size);


    -- RESET CONDITIONS
    IF wr_rst_i = '1' THEN
      overflow_i  <= '0';
      overflow_q  <= '0';
      overflow_q2 <= '0';
      wr_ack_q    <= '0';
      wr_ack_q2   <= '0';
      wr_ack_i    <= '0';

      wr_data_count_i <= (OTHERS => '0');
      FULL_i          <= C_FULL_RESET_VAL;         --'1';
      ALMOST_FULL     <= C_ALMOST_FULL_RESET_VAL;  --'1';

      wr_point <= 0;
      rd_reg0  <= 0;
      rd_reg1  <= 0;

      prog_full_noreg <= C_PROG_FULL_RESET_VAL;
      prog_full_reg <= C_PROG_FULL_RESET_VAL;

      --Create new linked list
      newlist(head, tail);

      --Clear data output queue
      data := hexstr_to_std_logic_vec(C_DOUT_RST_VAL, C_DOUT_WIDTH);

      ---------------------------------------------------------------------------
      -- Write to FIFO
      ---------------------------------------------------------------------------
    ELSIF wr_clk_i'event AND wr_clk_i = '1' THEN

      --Create registered versions of these internal signals
      wr_ack_q    <= wr_ack_i;
      wr_ack_q2   <= wr_ack_q;
      overflow_q  <= overflow_i;
      overflow_q2 <= overflow_q;

      rd_reg0 <= rd_point;
      rd_reg1 <= rd_reg0;

      prog_full_reg <= prog_full_noreg;

      IF rd_reg1/C_RATIO_W = wr_point/C_RATIO_R THEN
        wr_data_count_i <= (OTHERS => '0');
      ELSIF rd_reg1/C_RATIO_W < wr_point/C_RATIO_R THEN
        wr_data_count_i <= count((wr_point/C_RATIO_R - rd_reg1/C_RATIO_W), C_FIFO_WR_DEPTH, C_WR_DATA_COUNT_WIDTH);
      ELSE
        wr_data_count_i <= count((C_FIFO_WR_DEPTH-rd_reg1/C_RATIO_W+wr_point/C_RATIO_R), C_FIFO_WR_DEPTH, C_WR_DATA_COUNT_WIDTH);
      END IF;

      wr_diff_count <= int_2_std_logic_vector((size/C_RATIO_R), C_WR_PNTR_WIDTH);


      --Set the current state of FULL and ALMOST_FULL values
      -- (these may be overwritten later in this process        if the user is writing to the FIFO)
      IF (C_RATIO_R = 1) THEN
        IF (size = C_FIFO_WR_DEPTH) THEN
          FULL_i      <= '1';
          ALMOST_FULL <= '1';
        ELSIF size >= C_FIFO_WR_DEPTH - 1 THEN
          FULL_i      <= '0';
          ALMOST_FULL <= '1';
        ELSE
          FULL_i      <= '0';
          ALMOST_FULL <= '0';
        END IF;
      ELSE

        IF (WR_EN = '0') THEN

          --If not writing, then use the actual number of words in the FIFO
          -- to determine if the FIFO should be reporting FULL or not.
          IF (size >= C_FIFO_WR_DEPTH*C_RATIO_R-C_RATIO_R+1) THEN
            FULL_i      <= '1';
            ALMOST_FULL <= '1';
          ELSIF (size >= C_FIFO_WR_DEPTH*C_RATIO_R-(2*C_RATIO_R)+1) THEN
            FULL_i      <= '0';
            ALMOST_FULL <= '1';
          ELSE
            FULL_i      <= '0';
            ALMOST_FULL <= '0';
          END IF;

        ELSE                            --IF (WR_EN='1')

          --If writing, then it is not possible to predict how many
          --words will actually be in the FIFO after the write concludes
          --(because the number of reads which happen in this time can
          -- not be determined).
          --Therefore, treat it pessimistically and always assume that
          -- the write will happen without a read (assume the FIFO is
          -- C_RATIO_R fuller than it is).
          IF (size+C_RATIO_R >= C_FIFO_WR_DEPTH*C_RATIO_R-C_RATIO_R+1) THEN
            FULL_i      <= '1';
            ALMOST_FULL <= '1';
          ELSIF (size+C_RATIO_R >= C_FIFO_WR_DEPTH*C_RATIO_R-(2*C_RATIO_R)+1) THEN
            FULL_i      <= '0';
            ALMOST_FULL <= '1';
          ELSE
            FULL_i      <= '0';
            ALMOST_FULL <= '0';
          END IF;

        END IF;  --WR_EN

      END IF;  --C_RATIO_R



      -- User is writing to the FIFO
      IF WR_EN = '1' THEN
        -- User is writing to a FIFO which is NOT reporting FULL
        IF FULL_i /= '1' THEN

          -- FIFO really is Full        
          IF size/C_RATIO_R = C_FIFO_WR_DEPTH THEN
            --Report Overflow and do not acknowledge the write
            overflow_i <= '1';
            wr_ack_i   <= '0';

            -- FIFO is almost full
          ELSIF size/C_RATIO_R + 1 = C_FIFO_WR_DEPTH THEN
            -- This write will succeed, and FIFO will go FULL
            overflow_i <= '0';
            wr_ack_i   <= '1';
            FULL_i     <= '1';
            FOR h IN C_RATIO_R DOWNTO 1 LOOP
              add(head, tail, DIN( (C_SMALLER_DATA_WIDTH*h)-1 DOWNTO C_SMALLER_DATA_WIDTH*(h-1) ) );
            END LOOP;
            wr_point   <= (wr_point + 1) MOD C_FIFO_WR_DEPTH;

            -- FIFO is one away from almost full
          ELSIF size/C_RATIO_R + 2 = C_FIFO_WR_DEPTH THEN
            -- This write will succeed, and FIFO will go ALMOST_FULL
            overflow_i  <= '0';
            wr_ack_i    <= '1';
            ALMOST_FULL <= '1';
            FOR h IN C_RATIO_R DOWNTO 1 LOOP
              add(head, tail, DIN( (C_SMALLER_DATA_WIDTH*h)-1 DOWNTO C_SMALLER_DATA_WIDTH*(h-1) ) );
            END LOOP;
            wr_point    <= (wr_point + 1) MOD C_FIFO_WR_DEPTH;

            -- FIFO is no where near FULL
          ELSE
            --Write will succeed, no change in status
            overflow_i <= '0';
            wr_ack_i   <= '1';
            FOR h IN C_RATIO_R DOWNTO 1 LOOP
              add(head, tail, DIN( (C_SMALLER_DATA_WIDTH*h)-1 DOWNTO C_SMALLER_DATA_WIDTH*(h-1) ) );
            END LOOP;
            wr_point   <= (wr_point + 1) MOD C_FIFO_WR_DEPTH;
          END IF;

          -- User is writing to a FIFO which IS reporting FULL
        ELSE                            --IF FULL_i = '1'
          --Write will fail
          overflow_i <= '1';
          wr_ack_i   <= '0';
        END IF;  --FULL_i

      ELSE                              --WR_EN/='1'
        --No write attempted, so neither overflow or acknowledge
        overflow_i <= '0';
        wr_ack_i   <= '0';
      END IF;  --WR_EN

      -------------------------------------------------------------------------
      -- Programmable FULL flags
      -------------------------------------------------------------------------

      --Single Constant Threshold
      IF (C_PROG_FULL_TYPE = 1) THEN

        -- If we are at or above the PROG_FULL_THRESH, or we will be 
        --  next clock cycle, then assert PROG_FULL
        IF ((size/C_RATIO_R >= C_PROG_FULL_THRESH_ASSERT_VAL) OR ((size/C_RATIO_R = C_PROG_FULL_THRESH_ASSERT_VAL-1) AND WR_EN = '1')) THEN
          prog_full_noreg <= '1';
        ELSE
          prog_full_noreg <= '0';
        END IF;  -- C_HAS_PROG_FULL_THRESH = 1


        --Dual Constant Thresholds
      ELSIF (C_PROG_FULL_TYPE = 2) THEN

        -- If we will be going at or above the C_PROG_FULL_ASSERT threshold
        -- on the next clock cycle, then assert PROG_FULL

        -- WARNING: For the fifo with separate clocks, it is possible that
        -- the core could be both reading and writing simultaneously, with
        -- the writes occuring faster. This means that the number of words
        -- in the FIFO is increasing, and PROG_FULL should be asserted. So,
        -- we assume the worst and assert PROG_FULL if we are close and
        -- writing, since RD_EN may or may not have an impact on the number
        -- of words in the FIFO.
        IF ((size/C_RATIO_R = C_PROG_FULL_THRESH_ASSERT_VAL-1) AND WR_EN = '1') THEN
          prog_full_noreg <= '1';

          -- If we will be going below C_PROG_FULL_NEGATE on the next clock
          -- cycle, then de-assert PROG_FULL
          -- Note: In this case, we will assume reading and not writing
          -- will cause the number of words in the FIFO to decrease by one.
          -- It is possible that the number of words in the FIFO could
          -- decrease when reading and writing simultaneously, but the
          -- negate condition need not occur exactly when we cross below the
          -- negate threshold.
          -- ELSIF ((size/C_RATIO_R = C_PROG_FULL_NEGATE) AND RD_EN = '1'
          --        AND WR_EN='0') THEN
          --   PROG_FULL <= '0';

          -- If we are at or above the C_PROG_FULL_ASSERT, then assert
          -- PROG_FULL
        ELSIF (size/C_RATIO_R >= C_PROG_FULL_THRESH_ASSERT_VAL) THEN
          prog_full_noreg <= '1';
          --If we are below the C_PROG_FULL_NEGATE, then de-assert PROG_FULL 
        ELSIF (size/C_RATIO_R < C_PROG_FULL_THRESH_NEGATE_VAL) THEN
          prog_full_noreg <= '0';
        END IF;

        --Single threshold input port
      ELSIF (C_PROG_FULL_TYPE = 3) THEN

        -- If we are at or above the PROG_FULL_THRESH, or we will be 
        --  next clock cycle, then assert PROG_FULL
        IF ((size/C_RATIO_R >= std_logic_vector_2_posint(PROG_FULL_THRESH)) OR ((size/C_RATIO_R = std_logic_vector_2_posint(PROG_FULL_THRESH)-1) AND WR_EN = '1')) THEN
          prog_full_noreg <= '1';
        ELSE
          prog_full_noreg <= '0';
        END IF;  -- C_HAS_PROG_FULL_THRESH = 1

        --Dual threshold input ports
      ELSIF (C_PROG_FULL_TYPE = 4) THEN


        -- If we will be going at or above the C_PROG_FULL_ASSERT threshold
        -- on the next clock cycle, then assert PROG_FULL
        IF ((size/C_RATIO_R = std_logic_vector_2_posint(PROG_FULL_THRESH_ASSERT)-1) AND WR_EN = '1') THEN
          prog_full_noreg <= '1';
          -- If we are at or above the C_PROG_FULL_ASSERT, then assert
          -- PROG_FULL
        ELSIF (size/C_RATIO_R >= std_logic_vector_2_posint(PROG_FULL_THRESH_ASSERT)) THEN
          prog_full_noreg <= '1';
          --If we are below the C_PROG_FULL_NEGATE, then de-assert PROG_FULL 
        ELSIF (size/C_RATIO_R < std_logic_vector_2_posint(PROG_FULL_THRESH_NEGATE)) THEN
          prog_full_noreg <= '0';
        END IF;


      END IF;  --C_PROG_FULL_TYPE


    END IF;  --wr_clk_i

    ---------------------------------------------------------------------------
    -- Read from FIFO
    ---------------------------------------------------------------------------
    IF rd_rst_i = '1' THEN
      underflow_i       <= '0';
      valid_i           <= '0';
      output_regs_valid <= '0';
      rd_data_count_i   <= (OTHERS => '0');
      empty_i           <= '1';
      ALMOST_EMPTY      <= '1';

      rd_point <= 0;
      wr_reg0  <= 0;
      wr_reg1  <= 0;

      prog_empty_noreg <= '1';
      prog_empty_reg <= '1';

      --Clear data output queue
      data := hexstr_to_std_logic_vec(C_DOUT_RST_VAL, C_DOUT_WIDTH);

    ELSIF rd_clk_i'event AND rd_clk_i = '1' THEN

      underflow_i <= '0';
      valid_i     <= '0';
      
      prog_empty_reg <= prog_empty_noreg;
      --Default
      wr_reg0           <= wr_point;
      wr_reg1           <= wr_reg0;
      IF wr_reg1/C_RATIO_R = rd_point/C_RATIO_W THEN
        rd_data_count_i <= (OTHERS => '0');
      ELSIF wr_reg1/C_RATIO_R > rd_point/C_RATIO_W THEN
        rd_data_count_i <= count((wr_reg1/C_RATIO_R - rd_point/C_RATIO_W), C_FIFO_RD_DEPTH, C_RD_DATA_COUNT_WIDTH);
      ELSE
        rd_data_count_i <= count((C_FIFO_RD_DEPTH-rd_point/C_RATIO_W+wr_reg1/C_RATIO_R), C_FIFO_RD_DEPTH, C_RD_DATA_COUNT_WIDTH);
      END IF;

      rd_diff_count <= int_2_std_logic_vector((size/C_RATIO_W), C_RD_PNTR_WIDTH);

      ---------------------------------------------------------------------------
      -- Read Latency 1
      ---------------------------------------------------------------------------
      IF (C_PRELOAD_LATENCY = 1) THEN

        IF size/C_RATIO_W = 0 THEN
          empty_i      <= '1';
          ALMOST_EMPTY <= '1';
        ELSIF size/C_RATIO_W = 1 THEN
          empty_i      <= '0';
          ALMOST_EMPTY <= '1';
        ELSE
          empty_i      <= '0';
          ALMOST_EMPTY <= '0';
        END IF;

        IF RD_EN = '1' THEN

          IF empty_i /= '1' THEN
            -- FIFO full
            IF size/C_RATIO_W = 2 THEN
              ALMOST_EMPTY <= '1';
              valid_i      <= '1';
              FOR h IN C_RATIO_W DOWNTO 1 LOOP
                read(tail, data( (C_SMALLER_DATA_WIDTH*h)-1 DOWNTO C_SMALLER_DATA_WIDTH*(h-1) ) );
                remove(head, tail);
              END LOOP;
              rd_point     <= (rd_point + 1) MOD C_FIFO_RD_DEPTH;
              -- almost empty
            ELSIF size/C_RATIO_W = 1 THEN
              ALMOST_EMPTY <= '1';
              empty_i      <= '1';
              valid_i      <= '1';
              FOR h IN C_RATIO_W DOWNTO 1 LOOP
                read(tail, data( (C_SMALLER_DATA_WIDTH*h)-1 DOWNTO C_SMALLER_DATA_WIDTH*(h-1) ) );
                remove(head, tail);
              END LOOP;
              rd_point     <= (rd_point + 1) MOD C_FIFO_RD_DEPTH;
              -- fifo empty
            ELSIF size/C_RATIO_W = 0 THEN
              underflow_i  <= '1';
              -- middle counts
            ELSE
              valid_i      <= '1';
              FOR h IN C_RATIO_W DOWNTO 1 LOOP
                read(tail, data( (C_SMALLER_DATA_WIDTH*h)-1 DOWNTO C_SMALLER_DATA_WIDTH*(h-1) ) );
                remove(head, tail);
              END LOOP;
              rd_point     <= (rd_point + 1) MOD C_FIFO_RD_DEPTH;
            END IF;
          ELSE
            underflow_i    <= '1';
          END IF;
        END IF;  --RD_EN
      END IF;  --C_PRELOAD_LATENCY


      ---------------------------------------------------------------------------
      -- Programmable EMPTY Flags
      ---------------------------------------------------------------------------

      --Single Constant Threshold
      IF (C_PROG_EMPTY_TYPE = 1) THEN

        -- If we are at or below the PROG_EMPTY_THRESH, or we will be 
        -- the next clock cycle, then assert PROG_EMPTY
        IF (
          (size/C_RATIO_W <= C_PROG_EMPTY_THRESH_ASSERT_VAL) OR
          ((size/C_RATIO_W = C_PROG_EMPTY_THRESH_ASSERT_VAL+1) AND RD_EN = '1')
          ) THEN
          prog_empty_noreg      <= '1';
        ELSE
          prog_empty_noreg      <= '0';
        END IF;

        --Dual constant thresholds
      ELSIF (C_PROG_EMPTY_TYPE = 2) THEN


        -- If we will be going at or below the C_PROG_EMPTY_ASSERT threshold
        -- on the next clock cycle, then assert PROG_EMPTY
        --
        -- WARNING: For the fifo with separate clocks, it is possible that
        -- the core could be both reading and writing simultaneously, with
        -- the reads occuring faster. This means that the number of words
        -- in the FIFO is decreasing, and PROG_EMPTY should be asserted. So,
        -- we assume the worst and assert PROG_EMPTY if we are close and
        -- reading, since WR_EN may or may not have an impact on the number
        -- of words in the FIFO.
        IF ((size/C_RATIO_W = C_PROG_EMPTY_THRESH_ASSERT_VAL+1) AND RD_EN = '1') THEN
          prog_empty_noreg <= '1';
          -- If we will be going above C_PROG_EMPTY_NEGATE on the next clock
          -- cycle, then de-assert PROG_EMPTY
          --
          -- Note: In this case, we will assume writing and not reading
          -- will cause the number of words in the FIFO to increase by one.
          -- It is possible that the number of words in the FIFO could
          -- increase when reading and writing simultaneously, but the negate
          -- condition need not occur exactly when we cross below the negate
          -- threshold.
          -- ELSIF ((size/C_RATIO_W = C_PROG_EMPTY_NEGATE) AND WR_EN = '1'
          -- AND RD_EN = '0') THEN
          --   PROG_EMPTY          <= '0';

          -- If we are at or below the C_PROG_EMPTY_ASSERT, then assert
          -- PROG_EMPTY
        ELSIF (size/C_RATIO_W <= C_PROG_EMPTY_THRESH_ASSERT_VAL) THEN
          prog_empty_noreg          <= '1';

          --If we are above the C_PROG_EMPTY_NEGATE, then de-assert PROG_EMPTY
        ELSIF (size/C_RATIO_W > C_PROG_EMPTY_THRESH_NEGATE_VAL) THEN
          prog_empty_noreg <= '0';
        END IF;

        --Single threshold input port
      ELSIF (C_PROG_EMPTY_TYPE = 3) THEN

        -- If we are at or below the PROG_EMPTY_THRESH, or we will be 
        -- the next clock cycle, then assert PROG_EMPTY
        IF (
          (size/C_RATIO_W <= std_logic_vector_2_posint(PROG_EMPTY_THRESH)) OR
          ((size/C_RATIO_W = std_logic_vector_2_posint(PROG_EMPTY_THRESH)+1) AND RD_EN = '1')
          ) THEN
          prog_empty_noreg      <= '1';
        ELSE
          prog_empty_noreg      <= '0';
        END IF;


        --Dual threshold input ports
      ELSIF (C_PROG_EMPTY_TYPE = 4) THEN

        -- If we will be going at or below the C_PROG_EMPTY_ASSERT threshold
        -- on the next clock cycle, then assert PROG_EMPTY
        IF ((size/C_RATIO_W = std_logic_vector_2_posint(PROG_EMPTY_THRESH_ASSERT)+1) AND RD_EN = '1') THEN
          prog_empty_noreg          <= '1';
          -- If we are at or below the C_PROG_EMPTY_ASSERT, then assert
          -- PROG_EMPTY
        ELSIF (size/C_RATIO_W <= std_logic_vector_2_posint(PROG_EMPTY_THRESH_ASSERT)) THEN
          prog_empty_noreg          <= '1';

          --If we are above the C_PROG_EMPTY_NEGATE, then de-assert PROG_EMPTY
        ELSIF (size/C_RATIO_W > std_logic_vector_2_posint(PROG_EMPTY_THRESH_NEGATE)) THEN
          prog_empty_noreg <= '0';
        END IF;


      END IF;





    END IF;  --rd_clk_i

    DOUT <= data;

  END PROCESS;


END behavioral;



-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--  Synchronous FIFO Behavioral Model                                   
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Library Declaration
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

-- LIBRARY work; --SIM
-- USE work.iputils_conv.ALL; --SIM
-- USE work.iputils_misc.ALL; --SIM

LIBRARY XilinxCoreLib; --XCC
USE XilinxCoreLib.iputils_conv.ALL; --XCC
USE XilinxCoreLib.iputils_misc.ALL; --XCC

-------------------------------------------------------------------------------
-- Entity Declaration
-------------------------------------------------------------------------------
ENTITY fifo_generator_v1_0_bhv_ss IS

  GENERIC (
    --------------------------------------------------------------------------------
    -- Generic Declarations (alphabetical)
    --------------------------------------------------------------------------------
    C_COMMON_CLOCK          : integer := 0;  --not yet supported        (synchronous FIFO)
    C_COUNT_TYPE            : integer := 0;  --not relevant to behavioral model 
    C_DATA_COUNT_WIDTH      : integer := 2;  --not yet supported
    C_DEFAULT_VALUE         : string  := "";  --not yet supported
    C_DIN_WIDTH             : integer := 8;  --asymmetric ports not yet supported. AsyncFifoParam=C_DATA_WIDTH       : integer := 32;
    C_DOUT_RST_VAL          : string  := "";  --not yet supported
    C_DOUT_WIDTH            : integer := 8;  --asymmetric ports not yet supported. AsyncFifoParam=C_DATA_WIDTH       : integer := 32;
    C_ENABLE_RLOCS          : integer := 0;  --not relevant to behavioral model
    C_FAMILY                : string  := "virtex2";  --not relevant to behavioral model
    C_HAS_ALMOST_FULL       : integer := 0;  --supported. AsyncFifoParam=C_HAS_ALMOST_FULL  : integer := 0;
    C_HAS_ALMOST_EMPTY      : integer := 0;  --supported. AsyncFifoParam=C_HAS_ALMOST_EMPTY : integer := 0;
    C_HAS_BACKUP            : integer := 0;  --not yet supported
    C_HAS_DATA_COUNT        : integer := 0;  --not yet supported
    C_HAS_MEMINIT_FILE      : integer := 0;  --not yet supported
    C_HAS_OVERFLOW          : integer := 0;  --not yet supported. AsyncFifoParam=C_HAS_WR_ERR       : integer := 0;
    C_HAS_RD_DATA_COUNT     : integer := 0;  --not yet supported. AsyncFifoParam=C_HAS_RD_COUNT     : integer := 0;
    C_HAS_RD_RST            : integer := 0;  --supported
    C_HAS_RST               : integer := 0;  --supported
    C_HAS_UNDERFLOW         : integer := 0;  --not yet supported. AsyncFifoParam=C_HAS_RD_ERR       : integer := 0;
    C_HAS_VALID             : integer := 0;  --not yet supported. AsyncFifoParam=C_HAS_VALID       : integer := 0;
    C_HAS_WR_ACK            : integer := 0;  --not yet supported. AsyncFifoParam=C_HAS_WR_ACK       : integer := 0;
    C_HAS_WR_DATA_COUNT     : integer := 0;  --not yet supported. AsyncFifoParam=C_HAS_WR_COUNT     : integer := 0;
    C_HAS_WR_RST            : integer := 0;  --supported
    C_INIT_WR_PNTR_VAL      : integer := 0;  --not yet supported
    C_MEMORY_TYPE           : integer := 1;  --not relevant to behavioral model. AsyncFifoParam=C_USE_BLOCKMEM     : integer := 1;
    C_MIF_FILE_NAME         : string  := "";  --not yet supported
    C_OPTIMIZATION_MODE     : integer := 0;  --not relevant to behavioral model
    C_OVERFLOW_LOW          : integer := 0;  --supported. AsyncFifoParam=C_WR_ERR_LOW       : integer := 0;
    C_PRELOAD_REGS          : integer := 0;  --not yet supported
    C_PRELOAD_LATENCY       : integer := 1;  --not yet supported
    C_PROG_EMPTY_THRESH_ASSERT_VAL : integer := 0;
    C_PROG_EMPTY_THRESH_NEGATE_VAL : integer := 0;
    C_PROG_EMPTY_TYPE              : integer := 0;  
    C_PROG_FULL_THRESH_ASSERT_VAL  : integer := 0;
    C_PROG_FULL_THRESH_NEGATE_VAL  : integer := 0;    
    C_PROG_FULL_TYPE               : integer := 0;  
    C_RD_DATA_COUNT_WIDTH   : integer := 2;  --supported. AsyncFifoParam=C_RD_COUNT_WIDTH   : integer := 2;
    C_RD_DEPTH              : integer := 256;  --asymmetric ports not yet supported. AsyncFifoParam=C_FIFO_DEPTH       : integer := 511;
    C_RD_PNTR_WIDTH         : integer := 8;  --not yet supported
    C_UNDERFLOW_LOW         : integer := 0;  --supported. AsyncFifoParam=C_RD_ERR_LOW       : integer := 0;
    C_VALID_LOW             : integer := 0;  --supported. AsyncFifoParam=C_VALID_LOW       : integer := 0;
    C_WR_ACK_LOW            : integer := 0;  --supported. AsyncFifoParam=C_WR_ACK_LOW       : integer := 0;
    C_WR_DATA_COUNT_WIDTH   : integer := 2;  --supported. AsyncFifoParam=C_WR_COUNT_WIDTH   : integer := 2;
    C_WR_DEPTH              : integer := 256;  --asymmetric ports not yet supported. AsyncFifoParam=C_FIFO_DEPTH       : integer := 511;
    C_WR_PNTR_WIDTH         : integer := 8;  --not yet supported
    C_WR_RESPONSE_LATENCY   : integer := 1  --not yet supported
    );


  PORT(
--------------------------------------------------------------------------------
-- Input and Output Declarations
--------------------------------------------------------------------------------
    CLK               : IN std_logic                                    := '0';
    BACKUP            : IN std_logic                                    := '0';
    BACKUP_MARKER     : IN std_logic                                    := '0';
    DIN               : IN std_logic_vector(C_DIN_WIDTH-1 DOWNTO 0)     := (OTHERS => '0');
    PROG_EMPTY_THRESH : IN std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    PROG_EMPTY_THRESH_ASSERT : IN std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    PROG_EMPTY_THRESH_NEGATE : IN std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    PROG_FULL_THRESH  : IN std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    PROG_FULL_THRESH_ASSERT  : IN std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    PROG_FULL_THRESH_NEGATE  : IN std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    RD_CLK            : IN std_logic                                    := '0'; 
    RD_EN             : IN std_logic                                    := '0'; 
    RD_RST            : IN std_logic                                    := '0';
    RST               : IN std_logic                                    := '0';
    WR_CLK            : IN std_logic                                    := '0';
    WR_EN             : IN std_logic                                    := '0';
    WR_RST            : IN std_logic                                    := '0';

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
    WR_DATA_COUNT : OUT std_logic_vector(C_WR_DATA_COUNT_WIDTH-1 DOWNTO 0); 

    DEBUG_WR_PNTR         : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0); 
    DEBUG_RD_PNTR         : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0); 
    DEBUG_RAM_WR_EN       : OUT std_logic; 
    DEBUG_RAM_RD_EN       : OUT std_logic; 
    debug_wr_pntr_w       : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0); 
    debug_wr_pntr_plus1_w : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0); 
    debug_wr_pntr_plus2_w : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0); 
    debug_wr_pntr_r       : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0); 
    debug_rd_pntr_r       : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0); 
    debug_rd_pntr_plus1_r : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0); 
    debug_rd_pntr_w       : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0); 
    DEBUG_RAM_EMPTY       : OUT std_logic; 
    DEBUG_RAM_FULL        : OUT std_logic 
    );

END fifo_generator_v1_0_bhv_ss;
-------------------------------------------------------------------------------
-- Definition of Ports
-- DIN : Input data bus for the fifo.
-- DOUT : Output data bus for the fifo.
-- AINIT : Asynchronous Reset for the fifo.
-- WR_EN : Write enable signal.
-- WR_CLK : Write Clock.
-- FULL : Full signal.
-- ALMOST_FULL : One space left.
-- WR_ACK : Last write acknowledged.
-- WR_ERR : Last write rejected.
-- WR_COUNT : Number of data words in fifo(synchronous to WR_CLK)
-- Rd_EN : Read enable signal.
-- RD_CLK : Read Clock.
-- EMPTY : Empty signal.
-- ALMOST_EMPTY: One sapce left
-- VALID : Last read acknowledged.
-- RD_ERR : Last read rejected.
-- RD_COUNT : Number of data words in fifo(synchronous to RD_CLK)
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Architecture Heading
-------------------------------------------------------------------------------
ARCHITECTURE behavioral OF fifo_generator_v1_0_bhv_ss IS

  CONSTANT C_HAS_FAST_FIFO  : integer := 0;  --DEFAULT_HAS_FAST_FIFO

-------------------------------------------------------------------------------
-- actual_fifo_depth
-- Returns the actual depth of the FIFO (may differ from what the user specified)
--
-- The FIFO depth is always represented as 2^n (16,32,64,128,256)
-- However, the ACTUAL fifo depth may be 2^n or (2^n - 1) depending on certain
-- options. This function returns the ACTUAL depth of the fifo, as seen by
-- the user.
--
-- The FIFO depth remains as 2^n when any of the following conditions are true:
-- *C_HAS_FAST_FIFO=1 (using Peter Alfke's implementation)
-- *C_PRELOAD_REGS=1 AND C_PRELOAD_LATENCY=1 (preload output register adds 1
-- word of depth to the FIFO)
-- *C_COMMON_CLOCK=1 (sync fifo can use entire memory depth)
-------------------------------------------------------------------------------
  FUNCTION actual_fifo_depth(c_fifo_depth : integer; C_HAS_FAST_FIFO : integer; C_PRELOAD_REGS : integer; C_PRELOAD_LATENCY : integer; C_COMMON_CLOCK : integer) RETURN integer IS
  BEGIN
    IF (C_HAS_FAST_FIFO = 1 OR (C_PRELOAD_REGS = 1 AND C_PRELOAD_LATENCY = 1) OR C_COMMON_CLOCK = 1) THEN
      RETURN c_fifo_depth;
    ELSE
      RETURN c_fifo_depth-1;
    END IF;
  END actual_fifo_depth;

-------------------------------------------------------------------------------
-- actual_mem_depth
-- This is the depth of the memory used in the FIFO, and may differ from the
-- depth of the FIFO itself.
--
-- The FIFO depth is always represented as 2^n (16,32,64,128,256)
-- However, the depth of the memory used in the FIFO may be 2^n or (2^n - 1)
-- depending on certain options. This function returns the actual depth of
-- the memory (AND the pointers used to address it!)
--
-- The FIFO depth remains as 2^n when any of the following conditions are true:
-- *C_HAS_FAST_FIFO=1 (using Peter Alfke's implementation)
-- *C_COMMON_CLOCK=1 (sync fifo can use entire memory depth)
-------------------------------------------------------------------------------
  FUNCTION actual_mem_depth(c_fifo_depth : integer; C_HAS_FAST_FIFO : integer; C_PRELOAD_REGS : integer; C_PRELOAD_LATENCY : integer; C_COMMON_CLOCK : integer) RETURN integer IS
  BEGIN
    IF (C_HAS_FAST_FIFO = 1 OR C_COMMON_CLOCK = 1) THEN
      RETURN c_fifo_depth;
    ELSE
      RETURN c_fifo_depth-1;
    END IF;
  END actual_mem_depth;

--------------------------------------------------------------------------------
-- Derived Constants
--------------------------------------------------------------------------------
  CONSTANT C_FULL_RESET_VAL        : std_logic := '1';
  CONSTANT C_ALMOST_FULL_RESET_VAL : std_logic := '1';
  CONSTANT C_PROG_FULL_RESET_VAL   : std_logic := '1';

  CONSTANT C_FIFO_WR_DEPTH : integer := actual_fifo_depth(C_WR_DEPTH, C_HAS_FAST_FIFO, C_PRELOAD_REGS, C_PRELOAD_LATENCY, C_COMMON_CLOCK);
  CONSTANT C_FIFO_RD_DEPTH : integer := actual_fifo_depth(C_RD_DEPTH, C_HAS_FAST_FIFO, C_PRELOAD_REGS, C_PRELOAD_LATENCY, C_COMMON_CLOCK);

  CONSTANT C_SMALLER_PNTR_WIDTH : integer := get_lesser(C_WR_PNTR_WIDTH, C_RD_PNTR_WIDTH);
  CONSTANT C_SMALLER_DEPTH      : integer := get_lesser(C_FIFO_WR_DEPTH, C_FIFO_RD_DEPTH);
  CONSTANT C_SMALLER_DATA_WIDTH : integer := get_lesser(C_DIN_WIDTH, C_DOUT_WIDTH);
  CONSTANT C_LARGER_PNTR_WIDTH  : integer := get_greater(C_WR_PNTR_WIDTH, C_RD_PNTR_WIDTH);
  CONSTANT C_LARGER_DEPTH       : integer := get_greater(C_FIFO_WR_DEPTH, C_FIFO_RD_DEPTH);
  CONSTANT C_LARGER_DATA_WIDTH  : integer := get_greater(C_DIN_WIDTH, C_DOUT_WIDTH);

  --The write depth to read depth ratio is   C_RATIO_W : C_RATIO_R
  CONSTANT C_RATIO_W : integer := if_then_else( (C_WR_DEPTH > C_RD_DEPTH), (C_WR_DEPTH/C_RD_DEPTH), 1);
  CONSTANT C_RATIO_R : integer := if_then_else( (C_RD_DEPTH > C_WR_DEPTH), (C_RD_DEPTH/C_WR_DEPTH), 1);

  CONSTANT C_PROG_FULL_REG  : integer := 1;
  CONSTANT C_PROG_EMPTY_REG : integer := 1;

  --CONSTANT c_data_width : integer := C_DIN_WIDTH;
  --CONSTANT c_fifo_depth : integer := C_FIFO_WR_DEPTH;
  --CONSTANT actual_depth  : integer := c_fifo_depth;
  --CONSTANT counter_depth : integer := c_fifo_depth + 1;
  CONSTANT counter_depth_wr : integer := C_FIFO_WR_DEPTH + 1;
  CONSTANT counter_depth_rd : integer := C_FIFO_RD_DEPTH + 1;

  SIGNAL empty_i  : std_logic := '0';
  SIGNAL FULL_i   : std_logic := '0';

  SIGNAL rd_rst_i : std_logic;
  SIGNAL wr_rst_i : std_logic;

  SIGNAL diff_count   : std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0)       := (OTHERS => '0');  

  SIGNAL wr_ack_i    : std_logic := '0';
  SIGNAL wr_ack_q    : std_logic := '0';
  SIGNAL wr_ack_q2   : std_logic := '0';
  SIGNAL overflow_i  : std_logic := '0';
  SIGNAL overflow_q  : std_logic := '0';
  SIGNAL overflow_q2 : std_logic := '0';

  SIGNAL valid_i     : std_logic := '0';
  SIGNAL underflow_i : std_logic := '0';

  SIGNAL output_regs_valid : std_logic := '0';
  SIGNAL wr_rst_q          : std_logic := '0';

  SIGNAL prog_full_reg   : std_logic := '0';
  SIGNAL prog_full_noreg : std_logic := '0';
  SIGNAL prog_empty_reg  : std_logic := '0';
  SIGNAL prog_empty_noreg: std_logic := '0';

-------------------------------------------------------------------------------
-- Linked List types
-------------------------------------------------------------------------------
  TYPE listtyp;
  TYPE listptr IS ACCESS listtyp;
  TYPE listtyp IS RECORD
                    data  : std_logic_vector(C_SMALLER_DATA_WIDTH - 1 DOWNTO 0);
                    older : listptr;
                    newer : listptr;
                  END RECORD;

-------------------------------------------------------------------------------
-- Processes for linked list implementation
-------------------------------------------------------------------------------
  --Create a new linked list
  PROCEDURE newlist (head : INOUT listptr; tail : INOUT listptr) IS
  BEGIN
    head := NULL;
    tail := NULL;
  END;  -- procedure newlist;

  --Add a data element to a linked list
  PROCEDURE add (head : INOUT listptr; tail : INOUT listptr; data : IN std_logic_vector) IS
    VARIABLE oldhead  :       listptr;
    VARIABLE newhead  :       listptr;
  BEGIN
    --Create a pointer to the existing head, if applicable
    IF (head /= NULL) THEN
      oldhead       := head;
    END IF;
    --Create a new node for the list
    newhead         := NEW listtyp;
    --Make the new node point to the old head
    newhead.older   := oldhead;
    --Make the old head point back to the new node (for doubly-linked list)
    IF (head /= NULL) THEN
      oldhead.newer := newhead;
    END IF;
    --Put the data into the new head node
    newhead.data    := data;
    --If the new head we just created is the only node in the list, make the tail point to it
    IF (newhead.older = NULL) THEN
      tail          := newhead;
    END IF;
    --Return the new head pointer
    head            := newhead;
  END;  -- procedure; -- add;


  --Read the data from the tail of the linked list
  PROCEDURE read (tail : INOUT listptr; data : OUT std_logic_vector) IS
  BEGIN
    data := tail.data;
  END;  -- procedure; -- read;


  --Remove the tail from the linked list
  PROCEDURE remove (head : INOUT listptr; tail : INOUT listptr) IS
    VARIABLE oldtail     :       listptr;
    VARIABLE newtail     :       listptr;
  BEGIN
    --Make a copy of the old tail pointer
    oldtail         := tail;
    --If there is no newer node, then set the tail pointer to nothing (list is empty)
    IF (oldtail.newer = NULL) THEN
      newtail       := NULL;
      --otherwise, make the next newer node the new tail, and make it point to nothing older
    ELSE
      newtail       := oldtail.newer;
      newtail.older := NULL;
    END IF;
    --Clean up the memory for the old tail node
    DEALLOCATE(oldtail);
    --If the new tail is nothing, then we have an empty list, and head should also be set to nothing
    IF (newtail = NULL) THEN
      head          := NULL;
    END IF;
    --Return the new tail
    tail            := newtail;
  END;  -- procedure; -- remove;


  --Calculate the size of the linked list
  PROCEDURE sizeof (head : INOUT listptr; size : OUT integer) IS
    VARIABLE curlink     :       listptr;
    VARIABLE tmpsize     :       integer := 0;
  BEGIN
    --If head is null, then there is nothing in the list to traverse
    IF (head /= NULL) THEN
      --start with the head node (which implies at least one node exists)
      curlink                            := head;
      tmpsize                            := 1;
      --Loop through each node until you find the one that points to nothing (the tail)
      WHILE (curlink.older /= NULL) LOOP
        tmpsize                          := tmpsize + 1;
        curlink                          := curlink.older;
      END LOOP;
    END IF;
    --Return the number of nodes
    size                                 := tmpsize;
  END;  -- procedure; -- sizeof;


  -- converts integer to std_logic_vector
  FUNCTION conv_to_std_logic_vector( arg  : IN integer;
                                     size : IN integer
                                     ) RETURN std_logic_vector IS
    VARIABLE result                       :    std_logic_vector(size-1 DOWNTO 0);
    VARIABLE temp                         :    integer;

  BEGIN

    temp          := arg;
    FOR i IN 0 TO size-1 LOOP
      IF (temp MOD 2) = 1 THEN
        result(i) := '1';
      ELSE
        result(i) := '0';
      END IF;
      IF temp > 0 THEN
        temp      := temp / 2;
      ELSE
        temp      := (temp - 1) / 2;
      END IF;
    END LOOP;  -- i

    RETURN result;
  END conv_to_std_logic_vector;

  -- converts integer to specified length std_logic_vector : dropping least
  -- significant bits if integer is bigger than what can be represented by
  -- the vector
  FUNCTION count( fifo_count    : IN integer;
                  fifo_depth    : IN integer;
                  counter_width : IN integer
                  ) RETURN std_logic_vector IS
    VARIABLE temp               :    std_logic_vector(fifo_depth-1 DOWNTO 0)      := (OTHERS => '0');
    VARIABLE output             :    std_logic_vector(counter_width - 1 DOWNTO 0) := (OTHERS => '0');
    VARIABLE power              :    integer                                      := 1;
    VARIABLE bits               :    integer                                      := 0;

  BEGIN

    WHILE power       <= fifo_depth LOOP
      power  := power * 2;
      bits   := bits + 1;
    END LOOP;
    temp     := conv_to_std_logic_vector(fifo_count, fifo_depth);
    IF (counter_width <= bits) THEN
      output := temp(bits - 1 DOWNTO bits - counter_width);
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
-- Prepare input signals
-------------------------------------------------------------------------------
  gwr : IF (C_HAS_WR_RST = 1 AND C_HAS_RST = 0) GENERATE
    wr_rst_i <= WR_RST;
  END GENERATE;
  grr : IF (C_HAS_RD_RST = 1 AND C_HAS_RST = 0) GENERATE
    rd_rst_i <= RD_RST;
  END GENERATE;
  gr  : IF (C_HAS_RST = 1) GENERATE
    rd_rst_i <= RST;
    wr_rst_i <= RST;
  END GENERATE;


  gdc    : IF (C_HAS_DATA_COUNT = 1) GENERATE

    gdcb : IF (C_DATA_COUNT_WIDTH > C_RD_PNTR_WIDTH) GENERATE
      DATA_COUNT(C_RD_PNTR_WIDTH-1 DOWNTO 0)                  <= diff_count;
      DATA_COUNT(C_DATA_COUNT_WIDTH-1 DOWNTO C_DATA_COUNT_WIDTH-C_RD_PNTR_WIDTH) <= (OTHERS => '0');
    END GENERATE;

    gdcs : IF (C_DATA_COUNT_WIDTH <= C_RD_PNTR_WIDTH) GENERATE
      DATA_COUNT <= diff_count(C_RD_PNTR_WIDTH-1 DOWNTO C_RD_PNTR_WIDTH-C_DATA_COUNT_WIDTH);
    END GENERATE;
  END GENERATE;
 
  gndc    : IF (C_HAS_DATA_COUNT = 0) GENERATE
      DATA_COUNT <= (OTHERS => '0');
  END GENERATE;

  --Calculate WR_ACK based on C_WR_RESPONSE_LATENCY and C_WR_ACK_LOW parameters
  gwalat0  : IF (C_WR_RESPONSE_LATENCY = 0) GENERATE
    gwalow : IF (C_WR_ACK_LOW = 0) GENERATE
      WR_ACK <= WR_EN AND NOT full_i;
    END GENERATE gwalow;
    gwahgh : IF (C_WR_ACK_LOW = 1) GENERATE
      WR_ACK <= NOT (WR_EN AND NOT full_i);
    END GENERATE gwahgh;
  END GENERATE gwalat0;

  gwalat1  : IF (C_WR_RESPONSE_LATENCY = 1) GENERATE
    gwalow : IF (C_WR_ACK_LOW = 0) GENERATE
      --WR_ACK <= wr_ack_q;
      WR_ACK <= wr_ack_i;
    END GENERATE gwalow;
    gwahgh : IF (C_WR_ACK_LOW = 1) GENERATE
      --WR_ACK <= NOT wr_ack_q;
      WR_ACK <= NOT wr_ack_i;
    END GENERATE gwahgh;
  END GENERATE gwalat1;

  gwalat2  : IF (C_WR_RESPONSE_LATENCY = 2) GENERATE
    gwalow : IF (C_WR_ACK_LOW = 0) GENERATE
      --WR_ACK <= wr_ack_q2;
      WR_ACK <= wr_ack_q;
    END GENERATE gwalow;
    gwahgh : IF (C_WR_ACK_LOW = 1) GENERATE
      --WR_ACK <= NOT wr_ack_q2;
      WR_ACK <= NOT wr_ack_q;
    END GENERATE gwahgh;
  END GENERATE gwalat2;

  --Calculate OVERFLOW based on C_WR_RESPONSE_LATENCY and C_OVERFLOW_LOW parameters
  govlat0  : IF (C_WR_RESPONSE_LATENCY = 0) GENERATE
    govlow : IF (C_OVERFLOW_LOW = 0) GENERATE
      OVERFLOW <= WR_EN AND full_i;
    END GENERATE govlow;
    govhgh : IF (C_OVERFLOW_LOW = 1) GENERATE
      OVERFLOW <= NOT (WR_EN AND full_i);
    END GENERATE govhgh;
  END GENERATE govlat0;

  govlat1  : IF (C_WR_RESPONSE_LATENCY = 1) GENERATE
    govlow : IF (C_OVERFLOW_LOW = 0) GENERATE
      --OVERFLOW <= overflow_q;
      OVERFLOW <= overflow_i;
    END GENERATE govlow;
    govhgh : IF (C_OVERFLOW_LOW = 1) GENERATE
      --OVERFLOW <= NOT overflow_q;
      OVERFLOW <= NOT overflow_i;
    END GENERATE govhgh;
  END GENERATE govlat1;

  govlat2  : IF (C_WR_RESPONSE_LATENCY = 2) GENERATE
    govlow : IF (C_OVERFLOW_LOW = 0) GENERATE
      --OVERFLOW <= overflow_q2;
      OVERFLOW <= overflow_q;
    END GENERATE govlow;
    govhgh : IF (C_OVERFLOW_LOW = 1) GENERATE
      --OVERFLOW <= NOT overflow_q2;
      OVERFLOW <= NOT overflow_q;
    END GENERATE govhgh;
  END GENERATE govlat2;

  --Calculate VALID based on C_PRELOAD_LATENCY and C_VALID_LOW settings
  gvlat1 : IF (C_PRELOAD_LATENCY = 1) GENERATE
    gnvl : IF (C_VALID_LOW = 0) GENERATE
      VALID <= valid_i;
    END GENERATE gnvl;
    gnvh : IF (C_VALID_LOW = 1) GENERATE
      VALID <= NOT valid_i;
    END GENERATE gnvh;
  END GENERATE gvlat1;

  --Calculate UNDERFLOW based on C_PRELOAD_LATENCY and C_VALID_LOW settings
  guflat1 : IF (C_PRELOAD_LATENCY = 1) GENERATE
    gnul  : IF (C_UNDERFLOW_LOW = 0) GENERATE
      UNDERFLOW <= underflow_i;
    END GENERATE gnul;
    gnuh  : IF (C_UNDERFLOW_LOW = 1) GENERATE
      UNDERFLOW <= NOT underflow_i;
    END GENERATE gnuh;
  END GENERATE guflat1;

  --Insert registered delay based on C_PROG_FULL_REG setting
  gpfnreg: IF (C_PROG_FULL_REG = 0) GENERATE
    PROG_FULL <= prog_full_noreg;
  END GENERATE gpfnreg;

  gpfreg: IF (C_PROG_FULL_REG = 1) GENERATE
    PROG_FULL <= prog_full_reg;
  END GENERATE gpfreg;

  --Insert registered delay based on C_PROG_EMPTY_REG setting
  gpenreg: IF (C_PROG_EMPTY_REG = 0) GENERATE
    PROG_EMPTY <= prog_empty_noreg;
  END GENERATE gpenreg;

  gpereg: IF (C_PROG_EMPTY_REG = 1) GENERATE
    PROG_EMPTY <= prog_empty_reg;
  END GENERATE gpereg;  

  FULL          <= FULL_i;
  EMPTY         <= empty_i;

-------------------------------------------------------------------------------
-- Asynchrounous FIFO using linked lists
-------------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- Simulataneous Write and Read
  -- Write process will always happen before the read the process
  -----------------------------------------------------------------------------
  FIFO_PROC : PROCESS (CLK, RST, FULL_i, WR_EN)


  VARIABLE head : listptr;
  VARIABLE tail : listptr;
  VARIABLE size : integer                                     := 0;
  VARIABLE data : std_logic_vector(c_dout_width - 1 DOWNTO 0) := (OTHERS => '0');
    
  BEGIN

    ---------------------------------------------------------------------------
    --Calculate the current contents of the FIFO (size)
    -- Warning: This value should only be calculated once each time this
    -- process is entered. It is updated instantaneously.
    ---------------------------------------------------------------------------
    sizeof(head, size);


    -- RESET CONDITIONS
    IF (RST = '1') THEN
      overflow_i  <= '0';
      overflow_q  <= '0';
      overflow_q2 <= '0';
      wr_ack_q    <= '0';
      wr_ack_q2   <= '0';
      wr_ack_i    <= '0';
      wr_rst_q <= '1';

      FULL_i          <= C_FULL_RESET_VAL;         --'1';
      ALMOST_FULL     <= C_ALMOST_FULL_RESET_VAL;  --'1';
      prog_full_reg   <= C_PROG_FULL_RESET_VAL;    --'1';
      prog_full_noreg <= C_PROG_FULL_RESET_VAL;    --'1';

      --Create new linked list
      newlist(head, tail);

      --Clear data output queue
      data := hexstr_to_std_logic_vec(C_DOUT_RST_VAL, C_DOUT_WIDTH);
      underflow_i     <= '0';
      valid_i         <= '0';
      output_regs_valid <= '0';    
      empty_i         <= '1';
      ALMOST_EMPTY    <= '1';
      prog_empty_reg  <= '1';
      prog_empty_noreg<= '1';

      --Clear data output queue
      --data := (OTHERS => '0');
      
    ELSIF ((CLK'event AND CLK = '1')) THEN

      --------------------------------------------------------------------------
      -- Write to FIFO
      ------------------------------------------------------------------------- 
      --Create registered versions of these internal signals
      wr_ack_q    <= wr_ack_i;
      wr_ack_q2   <= wr_ack_q;
      overflow_q  <= overflow_i;
      overflow_q2 <= overflow_q;
      wr_rst_q <= wr_rst_i;

      --------------------------------------------------------------------------
      -- Read from FIFO
      --------------------------------------------------------------------------
      underflow_i <= '0';
      valid_i     <= '0';

      -------------------------------------------------------------------------
      -- Synchronous FIFO Condition #1 : Writing and not reading
      -------------------------------------------------------------------------
      IF ((WR_EN = '1') AND (RD_EN = '0')) THEN
      
        --------------------
        -- FIFO is FULL or reporting FULL
        --------------------
        IF ((size = C_FIFO_WR_DEPTH) OR (FULL_i = '1')) THEN
            --Report Overflow and do not acknowledge the write
            overflow_i <= '1';
            wr_ack_i   <= '0';

            --FIFO Remains FULL & ALMOST_FULL
            FULL_i      <= '1';
            ALMOST_FULL <= '1';
            
            --Report no underflow. Output not valid.
            underflow_i  <= '0';
            valid_i      <= '0';
            
            --FIFO is nowhere near EMPTY
            EMPTY_i <= '0';
            ALMOST_EMPTY <= '0';
    
            --No write, so do not update diff_count
            
        --------------------
        -- FIFO is one from FULL
        --------------------
        ELSIF (size + 1 = C_FIFO_WR_DEPTH) THEN
            -- This write will succeed, and FIFO will go FULL
            overflow_i <= '0';
            wr_ack_i   <= '1';
            FULL_i      <= '1';
            ALMOST_FULL <= '1';
            add(head, tail, DIN( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );
            
            --Report no underflow. Output not valid.
            underflow_i  <= '0';
            valid_i      <= '0';
            
            --FIFO is nowhere near EMPTY
            EMPTY_i <= '0';
            ALMOST_EMPTY <= '0';
     
            --Update count (for DATA_COUNT output)
            diff_count <= int_2_std_logic_vector((size+1),C_RD_PNTR_WIDTH);

          --------------------
          --FIFO is two from FULL
          --------------------
          ELSIF size + 2 = C_FIFO_WR_DEPTH THEN
            -- This write will succeed, and FIFO will go ALMOST_FULL
            overflow_i  <= '0';
            wr_ack_i    <= '1';
            FULL_i      <= '0';
            ALMOST_FULL <= '1';          
            add(head, tail, DIN( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );
            
            --Report no underflow. Output not valid.
            underflow_i  <= '0';
            valid_i      <= '0';
            
            --FIFO is nowhere near EMPTY
            EMPTY_i <= '0';
            ALMOST_EMPTY <= '0';
     
            --Update count (for DATA_COUNT output)
            diff_count <= int_2_std_logic_vector((size+1),C_RD_PNTR_WIDTH);

          --------------------
          --FIFO is ALMOST EMPTY
          --------------------
          ELSIF size = 1 THEN
            -- This write will succeed, and FIFO will no longer be ALMOST EMPTY
            overflow_i  <= '0';
            wr_ack_i    <= '1';
            FULL_i      <= '0';
            ALMOST_FULL <= '0';          
            add(head, tail, DIN( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );
            
            --Report no underflow. Output not valid.
            underflow_i  <= '0';
            valid_i      <= '0';
            
            --FIFO is leaving ALMOST_EMPTY
            EMPTY_i <= '0';
            ALMOST_EMPTY <= '0';
     
            --Update count (for DATA_COUNT output)
            diff_count <= int_2_std_logic_vector((size+1),C_RD_PNTR_WIDTH);

          --------------------
          --FIFO is EMPTY
          --------------------
          ELSIF size = 0 THEN
            -- This write will succeed, and FIFO will no longer be EMPTY
            overflow_i  <= '0';
            wr_ack_i    <= '1';
            FULL_i      <= '0';
            ALMOST_FULL <= '0';          
            add(head, tail, DIN( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );
            
            --Report no underflow. Output not valid.
            underflow_i  <= '0';
            valid_i      <= '0';
            
            --FIFO is leaving EMPTY, but is still ALMOST_EMPTY
            EMPTY_i <= '0';
            ALMOST_EMPTY <= '1';
     
             --Update count (for DATA_COUNT output)
            diff_count <= int_2_std_logic_vector((size+1),C_RD_PNTR_WIDTH);

         --------------------
          --FIFO has two or more words in the FIFO, but is not near FULL
          --------------------
          ELSE -- size>1 and size<C_FIFO_DEPTH-2
            -- This write will succeed, and FIFO will no longer be EMPTY
            overflow_i  <= '0';
            wr_ack_i    <= '1';
            FULL_i      <= '0';
            ALMOST_FULL <= '0';          
            add(head, tail, DIN( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );
            
            --Report no underflow. Output not valid.
            underflow_i  <= '0';
            valid_i      <= '0';
            
            --FIFO is no longer EMPTY or ALMOST_EMPTY
            EMPTY_i <= '0';
            ALMOST_EMPTY <= '0';
            
            --Update count (for DATA_COUNT output)
            diff_count <= int_2_std_logic_vector((size+1),C_RD_PNTR_WIDTH);

          END IF;
 
 
      -------------------------------------------------------------------------
      -- Synchronous FIFO Condition #2 : Reading and not writing
      -------------------------------------------------------------------------
      ELSIF ((WR_EN = '0') AND (RD_EN = '1')) THEN
      
          --------------------
          --FIFO is EMPTY or reporting EMPTY
          --------------------
          IF ((size = 0) OR (EMPTY_i = '1')) THEN
            --No write attempted, but a read will succeed
            overflow_i <= '0';
            wr_ack_i   <= '0';
            FULL_i      <= '0';
            ALMOST_FULL <= '0';
            
            --Successful read
            underflow_i  <= '1';
            valid_i      <= '0';
            --FIFO is going EMPTY
            EMPTY_i <= '1';
            ALMOST_EMPTY <= '1';
            
            --No read, so do not update diff_count

          --------------------
          --FIFO is ALMOST EMPTY
          --------------------
          ELSIF (size = 1) THEN
            --No write attempted, but a read will succeed
            overflow_i <= '0';
            wr_ack_i   <= '0';
            FULL_i      <= '0';
            ALMOST_FULL <= '0';
            
            --Successful read
            underflow_i  <= '0';
            valid_i      <= '1';
            --FIFO is going EMPTY
            EMPTY_i <= '1';
            ALMOST_EMPTY <= '1';
            
            --This read will succeed, but it's the last one
            read(tail, data( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );
            remove(head, tail);
            
            --Update count (for DATA_COUNT output)
            diff_count <= int_2_std_logic_vector((size-1),C_RD_PNTR_WIDTH);
            
        --------------------
        -- FIFO is two from EMPTY
        --------------------
        ELSIF (size = 2) THEN
            --No write attempted, but a read will succeed
            overflow_i <= '0';
            wr_ack_i   <= '0';
            FULL_i      <= '0';
            ALMOST_FULL <= '0';
            
            --Successful read 
            underflow_i  <= '0';
            valid_i      <= '1';
            --FIFO is going ALMOST_EMPTY
            EMPTY_i <= '0';
            ALMOST_EMPTY <= '1';
            
            --Update read
            read(tail, data( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );
            remove(head, tail);
            
            --Update count (for DATA_COUNT output)
            diff_count <= int_2_std_logic_vector((size-1),C_RD_PNTR_WIDTH);
            
        --------------------
        -- FIFO is one from FULL
        --------------------
        ELSIF (size + 1 = C_FIFO_WR_DEPTH) THEN
            --No write attempted, but a read will succeed
            overflow_i <= '0';
            wr_ack_i   <= '0';
            FULL_i      <= '0';
            ALMOST_FULL <= '0';
            
            --Successful read
            underflow_i  <= '0';
            valid_i      <= '1';
            --FIFO is nowhere near EMPTY
            EMPTY_i <= '0';
            ALMOST_EMPTY <= '0';
            
            --Update read
            read(tail, data( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );
            remove(head, tail);
            
            --Update count (for DATA_COUNT output)
            diff_count <= int_2_std_logic_vector((size-1),C_RD_PNTR_WIDTH);
            
        --------------------
        -- FIFO is FULL
        --------------------
        ELSIF (size = C_FIFO_WR_DEPTH) THEN
            --No write attempted, but a read will succeed
            overflow_i <= '0';
            wr_ack_i   <= '0';
            FULL_i      <= '0';
            ALMOST_FULL <= '1';
            
            --Successful read
            underflow_i  <= '0';
            valid_i      <= '1';
            --FIFO is nowhere near EMPTY
            EMPTY_i <= '0';
            ALMOST_EMPTY <= '0';
            
            --Update read
            read(tail, data( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );
            remove(head, tail);
            
            --Update count (for DATA_COUNT output)
            diff_count <= int_2_std_logic_vector((size-1),C_RD_PNTR_WIDTH);
            
            

          --------------------
          --FIFO has two or more words in the FIFO, but is not near FULL
          --------------------
          ELSE -- size>2 and size<C_FIFO_DEPTH-1
            --No write attempted, but a read will succeed
            overflow_i <= '0';
            wr_ack_i   <= '0';
            FULL_i      <= '0';
            ALMOST_FULL <= '0';
            
            --Successful read
            underflow_i  <= '0';
            valid_i      <= '1';
            --FIFO is going EMPTY
            EMPTY_i <= '0';
            ALMOST_EMPTY <= '0';
            
            --This read will succeed, but it's the last one
            read(tail, data( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );
            remove(head, tail);
                       
            --Update count (for DATA_COUNT output)
            diff_count <= int_2_std_logic_vector((size-1),C_RD_PNTR_WIDTH);
            
          END IF;
 
 
      -------------------------------------------------------------------------
      -- Synchronous FIFO Condition #3 : Reading and writing
      -------------------------------------------------------------------------
      ELSIF ((WR_EN = '1') AND (RD_EN = '1')) THEN
      
        --------------------
        -- FIFO is FULL (or reporting FULL)
        --------------------
        IF ((size = C_FIFO_WR_DEPTH) OR (FULL_i = '1')) THEN
            -- Write to FULL FIFO will fail
            overflow_i <= '1';
            wr_ack_i   <= '0';
            FULL_i      <= '0';
            ALMOST_FULL <= '1';

            -- Read will be successful.
            underflow_i  <= '0';
            valid_i      <= '1';
            
            --FIFO is nowhere near EMPTY
            EMPTY_i <= '0';
            ALMOST_EMPTY <= '0';
     
            --Update read
            read(tail, data( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );
            remove(head, tail);
            
            --Update count (for DATA_COUNT output)
            diff_count <= int_2_std_logic_vector((size-1),C_RD_PNTR_WIDTH);
            
        --------------------
        -- FIFO is one from FULL
        --------------------
        ELSIF (size + 1 = C_FIFO_WR_DEPTH) THEN
            -- Write will be successful
            overflow_i <= '0';
            wr_ack_i   <= '1';
            FULL_i      <= '0';
            ALMOST_FULL <= '1';
            add(head, tail, DIN( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );
                                    
            --Successful read
            underflow_i  <= '0';
            valid_i      <= '1';
            --FIFO is nowhere near EMPTY
            EMPTY_i <= '0';
            ALMOST_EMPTY <= '0';
            
            --Update read
            read(tail, data( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );
            remove(head, tail);
            
            --Simulaneous read and write, no change in diff_count

          --------------------
          --FIFO is ALMOST EMPTY
          --------------------
          ELSIF (size = 1) THEN
            -- Write will be successful
            overflow_i <= '0';
            wr_ack_i   <= '1';
            FULL_i      <= '0';
            ALMOST_FULL <= '0';
            add(head, tail, DIN( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );
            
            --Successful read
            underflow_i  <= '0';
            valid_i      <= '1';
            --FIFO is nowhere near EMPTY
            EMPTY_i <= '0';
            ALMOST_EMPTY <= '1';
            
            --Update read
            read(tail, data( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );
            remove(head, tail);
                        
            --Simulaneous read and write, no change in diff_count

          --------------------
          --FIFO is EMPTY
          --------------------
          ELSIF ((size = 0) OR (EMPTY_i = '1')) THEN
            -- Write will be successful
            overflow_i <= '0';
            wr_ack_i   <= '1';
            FULL_i      <= '0';
            ALMOST_FULL <= '0';
            add(head, tail, DIN( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );
            
            --Read will fail, because core is reporting EMPTY
            underflow_i  <= '1';
            valid_i      <= '0';
            --FIFO is no longer EMPTY
            EMPTY_i <= '0';
            ALMOST_EMPTY <= '1';
            
            --Update count (for DATA_COUNT output)
            diff_count <= int_2_std_logic_vector((size+1),C_RD_PNTR_WIDTH);
            

          --------------------
          --FIFO has two or more words in the FIFO, but is not near FULL
          --------------------
          ELSE -- size>1 and size<C_FIFO_DEPTH-1
            -- Write will be successful
            overflow_i <= '0';
            wr_ack_i   <= '1';
            FULL_i      <= '0';
            ALMOST_FULL <= '0';
            add(head, tail, DIN( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );
            
            --Successful read
            underflow_i  <= '0';
            valid_i      <= '1';
            --FIFO is nowhere near EMPTY
            EMPTY_i <= '0';
            ALMOST_EMPTY <= '0';
            
            --Update read
            read(tail, data( (C_SMALLER_DATA_WIDTH)-1 DOWNTO 0 ) );
            remove(head, tail);
            
            --Simulaneous read and write, no change in diff_count

          END IF;
 
      -------------------------------------------------------------------------
      -- Synchronous FIFO Condition #4 : Not reading or writing
      -------------------------------------------------------------------------
      ELSE -- ((WR_EN = '0') AND (RD_EN = '0'))
      
        IF (size = C_FIFO_WR_DEPTH) THEN  --FULL
           -- No write
           overflow_i <= '0';
           wr_ack_i   <= '0';
           FULL_i      <= '1';
           ALMOST_FULL <= '1';
           
           --No read
           underflow_i  <= '0';
           valid_i      <= '0';
           empty_i      <= '0';
           ALMOST_EMPTY <= '0';
           
        ELSIF (size >= C_FIFO_WR_DEPTH - 1) THEN  --ALMOST_FULL
           -- No write
           overflow_i <= '0';
           wr_ack_i   <= '0';
           FULL_i      <= '0';
           ALMOST_FULL <= '1';
           
           --No read
           underflow_i  <= '0';
           valid_i      <= '0';
           empty_i      <= '0';
           ALMOST_EMPTY <= '0';

        ELSIF (size = 1) THEN  -- ALMOST_EMPTY
           -- No write
           overflow_i <= '0';
           wr_ack_i   <= '0';
           FULL_i      <= '0';
           ALMOST_FULL <= '0';
           
           --No read
           underflow_i  <= '0';
           valid_i      <= '0';
           empty_i      <= '0';
           ALMOST_EMPTY <= '1';
           
        ELSIF (size = 0) THEN  -- EMPTY
           -- No write
           overflow_i <= '0';
           wr_ack_i   <= '0';
           FULL_i      <= '0';
           ALMOST_FULL <= '0';
           
           --No read
           underflow_i  <= '0';
           valid_i      <= '0';
           empty_i      <= '1';
           ALMOST_EMPTY <= '1';
          
        ELSE  -- Not near FULL or EMPTY
           -- No write
           overflow_i <= '0';
           wr_ack_i   <= '0';
           FULL_i      <= '0';
           ALMOST_FULL <= '0';
           
           --No read
           underflow_i  <= '0';
           valid_i      <= '0';
           empty_i      <= '0';
           ALMOST_EMPTY <= '0';

        END IF;

       
        
      END IF;  -- WR_EN, RD_EN
 


      -------------------------------------------------------------------------
      -- Programmable FULL flags
      -------------------------------------------------------------------------
        IF (C_PROG_FULL_TYPE /= 0) THEN
        
          --------------------------------
          -- Prog FULL Type 3 (single input port)
          --------------------------------
          IF (C_PROG_FULL_TYPE = 3) THEN
            --If we are at or above the PROG_FULL_THRESH, or we will be 
            --  next clock cycle, then assert PROG_FULL
            --Since this is a FIFO with common clocks, we can accurately
            --predict the outcome using WR_EN and RD_EN.
            IF (
              (size >= std_logic_vector_2_posint(PROG_FULL_THRESH)) OR
              ((size = std_logic_vector_2_posint(PROG_FULL_THRESH)-1) AND WR_EN = '1'
               AND RD_EN = '0')
              ) THEN
                prog_full_noreg <= '1';
            END IF;
                  
            IF (((size = std_logic_vector_2_posint(PROG_FULL_THRESH)) AND RD_EN = '1'
               AND WR_EN = '0') OR (wr_rst_q='1' AND wr_rst_i='0')) THEN
--                OR ((size = std_logic_vector_2_posint(PROG_FULL_THRESH)) AND RD_EN = '1'
--                AND WR_EN = '1')) THEN
                prog_full_noreg <= '0';
            END IF;
            
          --------------------------------
          -- Prog FULL Type 4 (dual input ports)
          --------------------------------
          ELSIF (C_PROG_FULL_TYPE = 4) THEN
            --If we are at or above the PROG_FULL_THRESH, or we will be 
            --  next clock cycle, then assert PROG_FULL
            --Since this is a FIFO with common clocks, we can accurately
            --predict the outcome using WR_EN and RD_EN.
             IF (
               --(size >= PROG_FULL_THRESH_ASSERT) OR
               ((size = std_logic_vector_2_posint(PROG_FULL_THRESH_ASSERT)-1) AND WR_EN = '1'
                AND RD_EN = '0')
               ) THEN
                 prog_full_noreg <= '1';
             END IF;
             IF (((size = std_logic_vector_2_posint(PROG_FULL_THRESH_NEGATE)) AND RD_EN = '1'
                AND WR_EN = '0') OR (wr_rst_q='1' AND wr_rst_i='0')) THEN
                 prog_full_noreg <= '0';
--              -- If we are at or above the C_PROG_FULL_ASSERT, then assert
--              -- PROG_FULL
--              ELSIF (size/C_RATIO_R >= PROG_FULL_THRESH_ASSERT) THEN
--                PROG_FULL <= '1';
--              --If we are below the C_PROG_FULL_NEGATE, then de-assert
--              --PROG_FULL
--              ELSIF (size/C_RATIO_R < PROG_FULL_THRESH_NEGATE) THEN
--                 PROG_FULL <= '0';                 
             END IF;
             
          --------------------------------
          -- Prog FULL Type 2 (dual constants)
          --------------------------------
          ELSIF (C_PROG_FULL_TYPE = 2) THEN
            --If we will be going at or above the C_PROG_FULL_ASSERT threshold
            -- on the next clock cycle, then assert PROG_FULL
            --Since this is a FIFO with common clocks, we can accurately
            --predict the outcome using WR_EN and RD_EN.
            IF ((size = C_PROG_FULL_THRESH_ASSERT_VAL-1) AND WR_EN = '1'
                AND RD_EN = '0') THEN
                prog_full_noreg <= '1';
            -- If we will be going below C_PROG_FULL_NEGATE on the next clock
            -- cycle, then de-assert PROG_FULL
            ELSIF ((size = C_PROG_FULL_THRESH_NEGATE_VAL) AND RD_EN = '1'
                   AND WR_EN = '0') THEN
                prog_full_noreg <= '0';
            -- If we are at or above the C_PROG_FULL_ASSERT, then assert
            -- PROG_FULL
            ELSIF (size >= C_PROG_FULL_THRESH_ASSERT_VAL) THEN
                prog_full_noreg <= '1';
            --If we are below the C_PROG_FULL_NEGATE, then de-assert PROG_FULL
            ELSIF (size < C_PROG_FULL_THRESH_NEGATE_VAL) THEN
                prog_full_noreg <= '0';
            END IF;

          --------------------------------
          -- Prog FULL Type 1 (single constant)
          --------------------------------
          ELSE
            IF (
              (size >= C_PROG_FULL_THRESH_ASSERT_VAL) OR
              ((size = C_PROG_FULL_THRESH_ASSERT_VAL-1) AND WR_EN = '1'
               AND RD_EN = '0')
              ) THEN
                prog_full_noreg <= '1';
            END IF;
                  
            IF (((size = C_PROG_FULL_THRESH_NEGATE_VAL) AND RD_EN = '1'
               AND WR_EN = '0') OR (wr_rst_q='1' AND wr_rst_i='0')) THEN
                prog_full_noreg <= '0';
            END IF;
                        
          END IF; --C_PROG_FULL_TYPE

          prog_full_reg <= prog_full_noreg;

        END IF;  --C_PROG_FULL_TYPE /= 0

    
    ----------------------------------------------------------------------------
    -- Programmable EMPTY Flags
    ----------------------------------------------------------------------------

        IF C_PROG_EMPTY_TYPE /= 0 THEN


          --------------------------------
          -- Prog EMPTY Type 3 (single input port)
          --------------------------------
          IF C_PROG_EMPTY_TYPE = 3 THEN
            --If we are at or below the PROG_EMPTY_THRESH, or we will be 
            --  the next clock cycle, then assert PROG_EMPTY
            IF (
              (size = std_logic_vector_2_posint(PROG_EMPTY_THRESH)+1) AND RD_EN = '1' AND WR_EN = '0') THEN
             -- (size <= PROG_EMPTY_THRESH) OR
             -- ((size = PROG_EMPTY_THRESH+1) AND RD_EN = '1'
             --  AND WR_EN = '0')
             -- ) THEN
              prog_empty_noreg      <= '1';
            ELSIF ((size = std_logic_vector_2_posint(PROG_EMPTY_THRESH)) AND WR_EN = '1' AND RD_EN = '0') THEN
              prog_empty_noreg      <= '0';
            ELSIF ((size <= std_logic_vector_2_posint(PROG_EMPTY_THRESH)) AND RD_EN = '1') THEN
              prog_empty_noreg  <= '1';           
            END IF; --C_PROG_EMPTY_TYPE = 3


          --------------------------------
          -- Prog EMPTY Type 4 (dual input ports)
          --------------------------------
          ELSIF C_PROG_EMPTY_TYPE = 4 THEN
            --If we are at or below the PROG_EMPTY_THRESH, or we will be 
            --  the next clock cycle, then assert PROG_EMPTY
            IF (
              ((size = std_logic_vector_2_posint(PROG_EMPTY_THRESH_ASSERT)+1) AND RD_EN = '1'
               AND WR_EN = '0')
              ) THEN
                prog_empty_noreg      <= '1';
            END IF;
            
            IF (
              ((size = std_logic_vector_2_posint(PROG_EMPTY_THRESH_NEGATE)) AND WR_EN = '1'
               AND RD_EN = '0')) THEN
                prog_empty_noreg      <= '0';   
            END IF; --C_PROG_EMPTY_TYPE = 4            


          --------------------------------
          -- Prog EMPTY Type 2 (dual constants)
          --------------------------------
          ELSIF C_PROG_EMPTY_TYPE = 2 THEN

            --If we will be going at or below the C_PROG_EMPTY_ASSERT threshold
            -- on the next clock cycle, then assert PROG_EMPTY
            IF ((size = C_PROG_EMPTY_THRESH_ASSERT_VAL+1) AND RD_EN = '1'
                AND WR_EN = '0') THEN
                prog_empty_noreg          <= '1';
            -- If we will be going above C_PROG_EMPTY_NEGATE on the next clock
            -- cycle, then de-assert PROG_EMPTY
            ELSIF ((size = C_PROG_EMPTY_THRESH_NEGATE_VAL) AND WR_EN = '1'
                   AND RD_EN = '0') THEN
                prog_empty_noreg          <= '0';
            -- If we are at or below the C_PROG_EMPTY_ASSERT, then assert
            -- PROG_EMPTY
            ELSIF (size <= C_PROG_EMPTY_THRESH_ASSERT_VAL) THEN
                prog_empty_noreg          <= '1';
            -- If we are above the C_PROG_EMPTY_THRESH_NEGATE, then de-assert
            -- PROG_EMPTY
            ELSIF (size > C_PROG_EMPTY_THRESH_NEGATE_VAL) THEN
                prog_empty_noreg          <= '0';
            END IF;


          --------------------------------
          -- Prog EMPTY Type 1 (single constant)
          --------------------------------
          ELSIF C_PROG_EMPTY_TYPE = 1 THEN
            --If we are at or below the PROG_EMPTY_THRESH, or we will be 
            --  the next clock cycle, then assert PROG_EMPTY
            IF (
              (size = C_PROG_EMPTY_THRESH_ASSERT_VAL+1) AND RD_EN = '1' AND WR_EN = '0') THEN
             -- (size/C_RATIO_W <= PROG_EMPTY_THRESH) OR
             -- ((size/C_RATIO_W = PROG_EMPTY_THRESH+1) AND RD_EN = '1'
             --  AND WR_EN = '0')
             -- ) THEN
                prog_empty_noreg      <= '1';
            END IF;
            IF ((size = C_PROG_EMPTY_THRESH_NEGATE_VAL) AND WR_EN = '1' AND RD_EN = '0') THEN
                prog_empty_noreg      <= '0';
            END IF;
            
          END IF; -- C_PROG_EMPTY_TYPE

          prog_empty_reg <= prog_empty_noreg;
          
        END IF; --C_PROG_EMPTY_TYPE /= 0

    END IF;	--CLK

    DOUT <= data;

  END PROCESS;
  
END behavioral;



-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--  Asynchronous FIFO Behavioral Model for FIFO16 Implementation
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Library Declaration
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

-- LIBRARY work;                        --SIM
-- USE work.iputils_conv.ALL;           --SIM
-- USE work.iputils_misc.ALL;           --SIM

LIBRARY XilinxCoreLib;                  --XCC
USE XilinxCoreLib.iputils_conv.ALL;     --XCC
USE XilinxCoreLib.iputils_misc.ALL;     --XCC

-------------------------------------------------------------------------------
-- Entity Declaration
-------------------------------------------------------------------------------
ENTITY fifo_generator_v1_0_bhv_fifo16 IS

  GENERIC (
    ----------------------------------------------------------------------------
    -- Generic Declarations
    ----------------------------------------------------------------------------
    C_DIN_WIDTH                    :    integer := 8;
    C_DOUT_RST_VAL                 :    string  := "";
    C_DOUT_WIDTH                   :    integer := 8;
    C_ENABLE_RLOCS                 :    integer := 0;
    C_FAMILY                       :    string  := "";
    C_HAS_ALMOST_FULL              :    integer := 0;
    C_HAS_ALMOST_EMPTY             :    integer := 0;
    --C_HAS_BACKUP              :     integer := DEFAULT_HAS_BACKUP;
    --C_HAS_DATA_COUNT          :     integer := DEFAULT_HAS_DATA_COUNT;
    --C_HAS_MEMINIT_FILE        :     integer := DEFAULT_HAS_MEMINIT_FILE;
    C_HAS_OVERFLOW                 :    integer := 0;
    C_HAS_RD_DATA_COUNT            :    integer := 2;
    C_HAS_VALID                    :    integer := 0;
    C_HAS_RST                      :    integer := 1;
    C_HAS_UNDERFLOW                :    integer := 0;
    C_HAS_WR_ACK                   :    integer := 0;
    C_HAS_WR_DATA_COUNT            :    integer := 2;
    C_MEMORY_TYPE                  :    integer := 1;
    --C_MIF_FILE_NAME           :     string  := DEFAULT_MIF_FILE_NAME;
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
    C_WR_PNTR_WIDTH                :    integer := 8
    );
  PORT(
--------------------------------------------------------------------------------
-- Input and Output Declarations
--------------------------------------------------------------------------------
    --BACKUP                    : IN  std_logic;
    --BACKUP_MARKER             : IN  std_logic;
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
    WR_DATA_COUNT : OUT std_logic_vector(C_WR_DATA_COUNT_WIDTH-1 DOWNTO 0);

    DEBUG_WR_PNTR         : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
    DEBUG_RD_PNTR         : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
    DEBUG_RAM_WR_EN       : OUT std_logic;
    DEBUG_RAM_RD_EN       : OUT std_logic;
    debug_wr_pntr_w       : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
    debug_wr_pntr_plus1_w : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
    debug_wr_pntr_plus2_w : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
    debug_wr_pntr_r       : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
    debug_rd_pntr_r       : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
    debug_rd_pntr_plus1_r : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
    debug_rd_pntr_w       : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
    DEBUG_RAM_EMPTY       : OUT std_logic;
    DEBUG_RAM_FULL        : OUT std_logic
    );



END fifo_generator_v1_0_bhv_fifo16;


-------------------------------------------------------------------------------
-- Definition of Ports
-- DIN : Input data bus for the fifo.
-- DOUT : Output data bus for the fifo.
-- AINIT : Asynchronous Reset for the fifo.
-- WR_EN : Write enable signal.
-- WR_CLK : Write Clock.
-- FULL : Full signal.
-- ALMOST_FULL : One space left.
-- WR_ACK : Last write acknowledged.
-- WR_ERR : Last write rejected.
-- WR_COUNT : Number of data words in fifo(synchronous to WR_CLK)
-- Rd_EN : Read enable signal.
-- RD_CLK : Read Clock.
-- EMPTY : Empty signal.
-- ALMOST_EMPTY: One sapce left
-- VALID : Last read acknowledged.
-- RD_ERR : Last read rejected.
-- RD_COUNT : Number of data words in fifo(synchronous to RD_CLK)
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Architecture Heading
-------------------------------------------------------------------------------
ARCHITECTURE behavioral OF fifo_generator_v1_0_bhv_fifo16 IS



-------------------------------------------------------------------------------
-- actual_fifo_depth
-- Returns the actual depth of the FIFO (may differ from what the user specified)
--
-- The FIFO depth is always represented as 2^n (16,32,64,128,256)
-- However, the ACTUAL fifo depth may be 2^n or (2^n - 1) depending on certain
-- options. This function returns the ACTUAL depth of the fifo, as seen by
-- the user.
--
-- The FIFO depth remains as 2^n when any of the following conditions are true:
-- *C_PRELOAD_REGS=1 AND C_PRELOAD_LATENCY=1 (preload output register adds 1
-- word of depth to the FIFO)
-------------------------------------------------------------------------------
  FUNCTION actual_fifo_depth(c_fifo_depth : integer; C_PRELOAD_REGS : integer; C_PRELOAD_LATENCY : integer) RETURN integer IS
  BEGIN
    IF (C_PRELOAD_REGS = 1 AND C_PRELOAD_LATENCY = 1) THEN
      RETURN c_fifo_depth;
    ELSE
      RETURN c_fifo_depth-1;
    END IF;
  END actual_fifo_depth;

-------------------------------------------------------------------------------
-- actual_mem_depth
-- This is the depth of the memory used in the FIFO, and may differ from the
-- depth of the FIFO itself.
--
-- The FIFO depth is always represented as 2^n (16,32,64,128,256)
-- However, the depth of the memory used in the FIFO may be 2^n or (2^n - 1)
-- depending on certain options. This function returns the actual depth of
-- the memory (AND the pointers used to address it!)
--
-- The FIFO depth remains as 2^n when any of the following conditions are true:
-------------------------------------------------------------------------------
  FUNCTION actual_mem_depth(c_fifo_depth : integer; C_PRELOAD_REGS : integer; C_PRELOAD_LATENCY : integer) RETURN integer IS
  BEGIN
    RETURN c_fifo_depth-1;
  END actual_mem_depth;

--------------------------------------------------------------------------------
-- Derived Constants
--------------------------------------------------------------------------------
  CONSTANT C_FULL_RESET_VAL        : std_logic := '0';
  CONSTANT C_ALMOST_FULL_RESET_VAL : std_logic := '0';
  CONSTANT C_PROG_FULL_RESET_VAL   : std_logic := '1';

  CONSTANT C_FIFO_WR_DEPTH : integer := actual_fifo_depth(C_WR_DEPTH, C_PRELOAD_REGS, C_PRELOAD_LATENCY);
  CONSTANT C_FIFO_RD_DEPTH : integer := actual_fifo_depth(C_RD_DEPTH, C_PRELOAD_REGS, C_PRELOAD_LATENCY);

  CONSTANT C_SMALLER_PNTR_WIDTH : integer := get_lesser(C_WR_PNTR_WIDTH, C_RD_PNTR_WIDTH);
  CONSTANT C_SMALLER_DEPTH      : integer := get_lesser(C_FIFO_WR_DEPTH, C_FIFO_RD_DEPTH);
  CONSTANT C_SMALLER_DATA_WIDTH : integer := get_lesser(C_DIN_WIDTH, C_DOUT_WIDTH);
  CONSTANT C_LARGER_PNTR_WIDTH  : integer := get_greater(C_WR_PNTR_WIDTH, C_RD_PNTR_WIDTH);
  CONSTANT C_LARGER_DEPTH       : integer := get_greater(C_FIFO_WR_DEPTH, C_FIFO_RD_DEPTH);
  CONSTANT C_LARGER_DATA_WIDTH  : integer := get_greater(C_DIN_WIDTH, C_DOUT_WIDTH);

  --The write depth to read depth ratio is   C_RATIO_W : C_RATIO_R
  CONSTANT C_RATIO_W : integer := if_then_else( (C_WR_DEPTH > C_RD_DEPTH), (C_WR_DEPTH/C_RD_DEPTH), 1);
  CONSTANT C_RATIO_R : integer := if_then_else( (C_RD_DEPTH > C_WR_DEPTH), (C_RD_DEPTH/C_WR_DEPTH), 1);



  --CONSTANT c_data_width : integer := C_DIN_WIDTH;
  --CONSTANT c_fifo_depth : integer := C_FIFO_WR_DEPTH;
  --CONSTANT actual_depth  : integer := c_fifo_depth;
  --CONSTANT counter_depth : integer := c_fifo_depth + 1;
  CONSTANT counter_depth_wr : integer := C_FIFO_WR_DEPTH + 1;
  CONSTANT counter_depth_rd : integer := C_FIFO_RD_DEPTH + 1;

  SIGNAL wr_point : integer   := 0;
  SIGNAL rd_point : integer   := 0;
  SIGNAL rd_reg0  : integer   := 0;
  SIGNAL rd_reg1  : integer   := 0;
  SIGNAL wr_reg0  : integer   := 0;
  SIGNAL wr_reg1  : integer   := 0;
  SIGNAL empty_i  : std_logic := '0';
  SIGNAL FULL_i   : std_logic := '0';

  SIGNAL rd_clk_i : std_logic;
  SIGNAL wr_clk_i : std_logic;
  SIGNAL rd_rst_i : std_logic;
  SIGNAL wr_rst_i : std_logic;

  SIGNAL rd_data_count_i : std_logic_vector(C_RD_DATA_COUNT_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL wr_data_count_i : std_logic_vector(C_WR_DATA_COUNT_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL wr_diff_count   : std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0)       := (OTHERS => '0');
  SIGNAL rd_diff_count   : std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0)       := (OTHERS => '0');

  SIGNAL wr_ack_i    : std_logic := '0';
  SIGNAL wr_ack_q    : std_logic := '0';
  SIGNAL wr_ack_q2   : std_logic := '0';
  SIGNAL overflow_i  : std_logic := '0';
  SIGNAL overflow_q  : std_logic := '0';
  SIGNAL overflow_q2 : std_logic := '0';

  SIGNAL valid_i     : std_logic := '0';
  SIGNAL underflow_i : std_logic := '0';

  SIGNAL output_regs_valid : std_logic := '0';

-------------------------------------------------------------------------------
-- Linked List types
-------------------------------------------------------------------------------
  TYPE listtyp;
  TYPE listptr IS ACCESS listtyp;
  TYPE listtyp IS RECORD
                    data  : std_logic_vector(C_SMALLER_DATA_WIDTH - 1 DOWNTO 0);
                    older : listptr;
                    newer : listptr;
                  END RECORD;


-------------------------------------------------------------------------------
-- Processes for linked list implementation
-------------------------------------------------------------------------------
  --Create a new linked list
  PROCEDURE newlist (head : INOUT listptr; tail : INOUT listptr) IS
  BEGIN
    head := NULL;
    tail := NULL;
  END;  -- procedure newlist;

  --Add a data element to a linked list
  PROCEDURE add (head : INOUT listptr; tail : INOUT listptr; data : IN std_logic_vector) IS
    VARIABLE oldhead  :       listptr;
    VARIABLE newhead  :       listptr;
  BEGIN
    --Create a pointer to the existing head, if applicable
    IF (head /= NULL) THEN
      oldhead       := head;
    END IF;
    --Create a new node for the list
    newhead         := NEW listtyp;
    --Make the new node point to the old head
    newhead.older   := oldhead;
    --Make the old head point back to the new node (for doubly-linked list)
    IF (head /= NULL) THEN
      oldhead.newer := newhead;
    END IF;
    --Put the data into the new head node
    newhead.data    := data;
    --If the new head we just created is the only node in the list, make the tail point to it
    IF (newhead.older = NULL) THEN
      tail          := newhead;
    END IF;
    --Return the new head pointer
    head            := newhead;
  END;  -- procedure; -- add;


  --Read the data from the tail of the linked list
  PROCEDURE read (tail : INOUT listptr; data : OUT std_logic_vector) IS
  BEGIN
    data := tail.data;
  END;  -- procedure; -- read;


  --Remove the tail from the linked list
  PROCEDURE remove (head : INOUT listptr; tail : INOUT listptr) IS
    VARIABLE oldtail     :       listptr;
    VARIABLE newtail     :       listptr;
  BEGIN
    --Make a copy of the old tail pointer
    oldtail         := tail;
    --If there is no newer node, then set the tail pointer to nothing (list is empty)
    IF (oldtail.newer = NULL) THEN
      newtail       := NULL;
      --otherwise, make the next newer node the new tail, and make it point to nothing older
    ELSE
      newtail       := oldtail.newer;
      newtail.older := NULL;
    END IF;
    --Clean up the memory for the old tail node
    DEALLOCATE(oldtail);
    --If the new tail is nothing, then we have an empty list, and head should also be set to nothing
    IF (newtail = NULL) THEN
      head          := NULL;
    END IF;
    --Return the new tail
    tail            := newtail;
  END;  -- procedure; -- remove;


  --Calculate the size of the linked list
  PROCEDURE sizeof (head : INOUT listptr; size : OUT integer) IS
    VARIABLE curlink     :       listptr;
    VARIABLE tmpsize     :       integer := 0;
  BEGIN
    --If head is null, then there is nothing in the list to traverse
    IF (head /= NULL) THEN
      --start with the head node (which implies at least one node exists)
      curlink                            := head;
      tmpsize                            := 1;
      --Loop through each node until you find the one that points to nothing (the tail)
      WHILE (curlink.older /= NULL) LOOP
        tmpsize                          := tmpsize + 1;
        curlink                          := curlink.older;
      END LOOP;
    END IF;
    --Return the number of nodes
    size                                 := tmpsize;
  END;  -- procedure; -- sizeof;


  -- converts integer to std_logic_vector
  FUNCTION conv_to_std_logic_vector( arg  : IN integer;
                                     size : IN integer
                                     ) RETURN std_logic_vector IS
    VARIABLE result                       :    std_logic_vector(size-1 DOWNTO 0);
    VARIABLE temp                         :    integer;

  BEGIN

    temp          := arg;
    FOR i IN 0 TO size-1 LOOP
      IF (temp MOD 2) = 1 THEN
        result(i) := '1';
      ELSE
        result(i) := '0';
      END IF;
      IF temp > 0 THEN
        temp      := temp / 2;
      ELSE
        temp      := (temp - 1) / 2;
      END IF;
    END LOOP;  -- i

    RETURN result;
  END conv_to_std_logic_vector;

  -- converts integer to specified length std_logic_vector : dropping least
  -- significant bits if integer is bigger than what can be represented by
  -- the vector
  FUNCTION count( fifo_count    : IN integer;
                  fifo_depth    : IN integer;
                  counter_width : IN integer
                  ) RETURN std_logic_vector IS
    VARIABLE temp               :    std_logic_vector(fifo_depth-1 DOWNTO 0)      := (OTHERS => '0');
    VARIABLE output             :    std_logic_vector(counter_width - 1 DOWNTO 0) := (OTHERS => '0');
    VARIABLE power              :    integer                                      := 1;
    VARIABLE bits               :    integer                                      := 0;

  BEGIN

    WHILE power       <= fifo_depth LOOP
      power  := power * 2;
      bits   := bits + 1;
    END LOOP;
    temp     := conv_to_std_logic_vector(fifo_count, fifo_depth);
    IF (counter_width <= bits) THEN
      output := temp(bits - 1 DOWNTO bits - counter_width);
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
-- Prepare input signals
-------------------------------------------------------------------------------
  rd_clk_i <= RD_CLK;
  wr_clk_i <= WR_CLK;

  rd_rst_i <= RST;
  wr_rst_i <= RST;



  --Calculate WR_ACK based on C_WR_RESPONSE_LATENCY and C_WR_ACK_LOW parameters
  gwalat0  : IF (C_WR_RESPONSE_LATENCY = 0) GENERATE
    gwalow : IF (C_WR_ACK_LOW = 0) GENERATE
      WR_ACK <= WR_EN AND NOT full_i;
    END GENERATE gwalow;
    gwahgh : IF (C_WR_ACK_LOW = 1) GENERATE
      WR_ACK <= NOT (WR_EN AND NOT full_i);
    END GENERATE gwahgh;
  END GENERATE gwalat0;

  gwalat1  : IF (C_WR_RESPONSE_LATENCY = 1) GENERATE
    gwalow : IF (C_WR_ACK_LOW = 0) GENERATE
      --WR_ACK <= wr_ack_q;
      WR_ACK <= wr_ack_i;
    END GENERATE gwalow;
    gwahgh : IF (C_WR_ACK_LOW = 1) GENERATE
      --WR_ACK <= NOT wr_ack_q;
      WR_ACK <= NOT wr_ack_i;
    END GENERATE gwahgh;
  END GENERATE gwalat1;

  gwalat2  : IF (C_WR_RESPONSE_LATENCY = 2) GENERATE
    gwalow : IF (C_WR_ACK_LOW = 0) GENERATE
      --WR_ACK <= wr_ack_q2;
      WR_ACK <= wr_ack_q;
    END GENERATE gwalow;
    gwahgh : IF (C_WR_ACK_LOW = 1) GENERATE
      --WR_ACK <= NOT wr_ack_q2;
      WR_ACK <= NOT wr_ack_q;
    END GENERATE gwahgh;
  END GENERATE gwalat2;

  --Calculate OVERFLOW based on C_WR_RESPONSE_LATENCY and C_OVERFLOW_LOW parameters
  govlat0  : IF (C_WR_RESPONSE_LATENCY = 0) GENERATE
    govlow : IF (C_OVERFLOW_LOW = 0) GENERATE
      OVERFLOW <= WR_EN AND full_i;
    END GENERATE govlow;
    govhgh : IF (C_OVERFLOW_LOW = 1) GENERATE
      OVERFLOW <= NOT (WR_EN AND full_i);
    END GENERATE govhgh;
  END GENERATE govlat0;

  govlat1  : IF (C_WR_RESPONSE_LATENCY = 1) GENERATE
    govlow : IF (C_OVERFLOW_LOW = 0) GENERATE
      --OVERFLOW <= overflow_q;
      OVERFLOW <= overflow_i;
    END GENERATE govlow;
    govhgh : IF (C_OVERFLOW_LOW = 1) GENERATE
      --OVERFLOW <= NOT overflow_q;
      OVERFLOW <= NOT overflow_i;
    END GENERATE govhgh;
  END GENERATE govlat1;

  govlat2  : IF (C_WR_RESPONSE_LATENCY = 2) GENERATE
    govlow : IF (C_OVERFLOW_LOW = 0) GENERATE
      --OVERFLOW <= overflow_q2;
      OVERFLOW <= overflow_q;
    END GENERATE govlow;
    govhgh : IF (C_OVERFLOW_LOW = 1) GENERATE
      --OVERFLOW <= NOT overflow_q2;
      OVERFLOW <= NOT overflow_q;
    END GENERATE govhgh;
  END GENERATE govlat2;

  --Calculate VALID based on C_PRELOAD_LATENCY and C_VALID_LOW settings
  gvlat1 : IF (C_PRELOAD_LATENCY = 1) GENERATE
    gnvl : IF (C_VALID_LOW = 0) GENERATE
      VALID <= valid_i;
    END GENERATE gnvl;
    gnvh : IF (C_VALID_LOW = 1) GENERATE
      VALID <= NOT valid_i;
    END GENERATE gnvh;
  END GENERATE gvlat1;

  --Calculate UNDERFLOW based on C_PRELOAD_LATENCY and C_VALID_LOW settings
  guflat1 : IF (C_PRELOAD_LATENCY = 1) GENERATE
    gnul  : IF (C_UNDERFLOW_LOW = 0) GENERATE
      UNDERFLOW <= underflow_i;
    END GENERATE gnul;
    gnuh  : IF (C_UNDERFLOW_LOW = 1) GENERATE
      UNDERFLOW <= NOT underflow_i;
    END GENERATE gnuh;
  END GENERATE guflat1;

  RD_DATA_COUNT <= rd_diff_count(C_RD_PNTR_WIDTH-1 DOWNTO C_RD_PNTR_WIDTH-C_RD_DATA_COUNT_WIDTH);  --rd_data_count_i;
  WR_DATA_COUNT <= wr_diff_count(C_WR_PNTR_WIDTH-1 DOWNTO C_WR_PNTR_WIDTH-C_WR_DATA_COUNT_WIDTH);  --wr_data_count_i;
  FULL          <= FULL_i;
  EMPTY         <= empty_i;

-------------------------------------------------------------------------------
-- Asynchrounous FIFO using linked lists
-------------------------------------------------------------------------------
  FIFO_PROC : PROCESS (wr_clk_i, rd_clk_i, rd_rst_i, wr_rst_i, FULL_i, WR_EN)

    VARIABLE head : listptr;
    VARIABLE tail : listptr;
    VARIABLE size : integer                                     := 0;
    VARIABLE data : std_logic_vector(c_dout_width - 1 DOWNTO 0) := (OTHERS => '0');

  BEGIN

    --Calculate the current contents of the FIFO (size)
    -- Warning: This value should only be calculated once each time this
    -- process is entered. It is updated instantaneously.
    sizeof(head, size);


    -- RESET CONDITIONS
    IF wr_rst_i = '1' THEN
      overflow_i  <= '0';
      overflow_q  <= '0';
      overflow_q2 <= '0';
      wr_ack_q    <= '0';
      wr_ack_q2   <= '0';
      wr_ack_i    <= '0';

      wr_data_count_i <= (OTHERS => '0');
      FULL_i          <= C_FULL_RESET_VAL;         --'1';
      ALMOST_FULL     <= C_ALMOST_FULL_RESET_VAL;  --'1';
      PROG_FULL       <= C_PROG_FULL_RESET_VAL;    --'1';

      wr_point <= 0;
      rd_reg0  <= 0;
      rd_reg1  <= 0;

      --Create new linked list
      newlist(head, tail);

      --Clear data output queue
--       data := hexstr_to_std_logic_vec(C_DOUT_RST_VAL, C_DOUT_WIDTH);
      data := (OTHERS => '0');      

      ---------------------------------------------------------------------------
      -- Write to FIFO
      ---------------------------------------------------------------------------
    ELSIF wr_clk_i'event AND wr_clk_i = '1' THEN

      --Create registered versions of these internal signals
      wr_ack_q    <= wr_ack_i;
      wr_ack_q2   <= wr_ack_q;
      overflow_q  <= overflow_i;
      overflow_q2 <= overflow_q;

      rd_reg0 <= rd_point;
      rd_reg1 <= rd_reg0;

      IF rd_reg1/C_RATIO_W = wr_point/C_RATIO_R THEN
        wr_data_count_i <= (OTHERS => '0');
      ELSIF rd_reg1/C_RATIO_W < wr_point/C_RATIO_R THEN
        wr_data_count_i <= count((wr_point/C_RATIO_R - rd_reg1/C_RATIO_W), C_FIFO_WR_DEPTH, C_WR_DATA_COUNT_WIDTH);
      ELSE
        wr_data_count_i <= count((C_FIFO_WR_DEPTH-rd_reg1/C_RATIO_W+wr_point/C_RATIO_R), C_FIFO_WR_DEPTH, C_WR_DATA_COUNT_WIDTH);
      END IF;

-- IF rd_reg1/C_RATIO_W = wr_point/C_RATIO_R THEN
-- wr_diff_count <= (OTHERS => '0');
-- ELSIF rd_reg1/C_RATIO_W < wr_point/C_RATIO_R THEN
-- wr_diff_count <= count((wr_point/C_RATIO_R - rd_reg1/C_RATIO_W), C_FIFO_WR_DEPTH, C_WR_PNTR_WIDTH);
-- ELSE
-- wr_diff_count <= count((C_FIFO_WR_DEPTH-rd_reg1/C_RATIO_W+wr_point/C_RATIO_R), C_FIFO_WR_DEPTH, C_WR_PNTR_WIDTH);
-- END IF;

      wr_diff_count <= int_2_std_logic_vector((size/C_RATIO_R), C_WR_PNTR_WIDTH);


      --Set the current state of FULL and ALMOST_FULL values
      -- (these may be overwritten later in this process        if the user is writing to the FIFO)
      IF (C_RATIO_R = 1) THEN
        IF (size = C_FIFO_WR_DEPTH) THEN
          FULL_i      <= '1';
          ALMOST_FULL <= '1';
        ELSIF size >= C_FIFO_WR_DEPTH - 1 THEN
          FULL_i      <= '0';
          ALMOST_FULL <= '1';
        ELSE
          FULL_i      <= '0';
          ALMOST_FULL <= '0';
        END IF;
      ELSE

        IF (WR_EN = '0') THEN

          --If not writing, then use the actual number of words in the FIFO
          -- to determine if the FIFO should be reporting FULL or not.
          IF (size >= C_FIFO_WR_DEPTH*C_RATIO_R-C_RATIO_R+1) THEN
            FULL_i      <= '1';
            ALMOST_FULL <= '1';
          ELSIF (size >= C_FIFO_WR_DEPTH*C_RATIO_R-(2*C_RATIO_R)+1) THEN
            FULL_i      <= '0';
            ALMOST_FULL <= '1';
          ELSE
            FULL_i      <= '0';
            ALMOST_FULL <= '0';
          END IF;

        ELSE                            --IF (WR_EN='1')

          --If writing, then it is not possible to predict how many
          --words will actually be in the FIFO after the write concludes
          --(because the number of reads which happen in this time can
          -- not be determined).
          --Therefore, treat it pessimistically and always assume that
          -- the write will happen without a read (assume the FIFO is
          -- C_RATIO_R fuller than it is).
          IF (size+C_RATIO_R >= C_FIFO_WR_DEPTH*C_RATIO_R-C_RATIO_R+1) THEN
            FULL_i      <= '1';
            ALMOST_FULL <= '1';
          ELSIF (size+C_RATIO_R >= C_FIFO_WR_DEPTH*C_RATIO_R-(2*C_RATIO_R)+1) THEN
            FULL_i      <= '0';
            ALMOST_FULL <= '1';
          ELSE
            FULL_i      <= '0';
            ALMOST_FULL <= '0';
          END IF;

        END IF;  --WR_EN

      END IF;  --C_RATIO_R



      -- User is writing to the FIFO
      IF WR_EN = '1' THEN
        -- User is writing to a FIFO which is NOT reporting FULL
        IF FULL_i /= '1' THEN

          -- FIFO really is Full        
          IF size/C_RATIO_R = C_FIFO_WR_DEPTH THEN
            --Report Overflow and do not acknowledge the write
            overflow_i <= '1';
            wr_ack_i   <= '0';

            -- FIFO is almost full
          ELSIF size/C_RATIO_R + 1 = C_FIFO_WR_DEPTH THEN
            -- This write will succeed, and FIFO will go FULL
            overflow_i <= '0';
            wr_ack_i   <= '1';
            FULL_i     <= '1';
            FOR h IN C_RATIO_R DOWNTO 1 LOOP
              add(head, tail, DIN( (C_SMALLER_DATA_WIDTH*h)-1 DOWNTO C_SMALLER_DATA_WIDTH*(h-1) ) );
            END LOOP;
            wr_point   <= (wr_point + 1) MOD C_FIFO_WR_DEPTH;

            -- FIFO is one away from almost full
          ELSIF size/C_RATIO_R + 2 = C_FIFO_WR_DEPTH THEN
            -- This write will succeed, and FIFO will go ALMOST_FULL
            overflow_i  <= '0';
            wr_ack_i    <= '1';
            ALMOST_FULL <= '1';
            FOR h IN C_RATIO_R DOWNTO 1 LOOP
              add(head, tail, DIN( (C_SMALLER_DATA_WIDTH*h)-1 DOWNTO C_SMALLER_DATA_WIDTH*(h-1) ) );
            END LOOP;
            wr_point    <= (wr_point + 1) MOD C_FIFO_WR_DEPTH;

            -- FIFO is no where near FULL
          ELSE
            --Write will succeed, no change in status
            overflow_i <= '0';
            wr_ack_i   <= '1';
            FOR h IN C_RATIO_R DOWNTO 1 LOOP
              add(head, tail, DIN( (C_SMALLER_DATA_WIDTH*h)-1 DOWNTO C_SMALLER_DATA_WIDTH*(h-1) ) );
            END LOOP;
            wr_point   <= (wr_point + 1) MOD C_FIFO_WR_DEPTH;
          END IF;

          -- User is writing to a FIFO which IS reporting FULL
        ELSE                            --IF FULL_i = '1'
          --Write will fail
          overflow_i <= '1';
          wr_ack_i   <= '0';
        END IF;  --FULL_i

      ELSE                              --WR_EN/='1'
        --No write attempted, so neither overflow or acknowledge
        overflow_i <= '0';
        wr_ack_i   <= '0';
      END IF;  --WR_EN

      -------------------------------------------------------------------------
      -- Programmable FULL flags
      -------------------------------------------------------------------------

      --Single Constant Threshold
      IF (C_PROG_FULL_TYPE = 1) THEN

        -- If we are at or above the PROG_FULL_THRESH, or we will be 
        --  next clock cycle, then assert PROG_FULL
        IF ((size/C_RATIO_R >= C_PROG_FULL_THRESH_ASSERT_VAL) OR ((size/C_RATIO_R = C_PROG_FULL_THRESH_ASSERT_VAL-1) AND WR_EN = '1')) THEN
          PROG_FULL <= '1';
        ELSE
          PROG_FULL <= '0';
        END IF;  -- C_HAS_PROG_FULL_THRESH = 1


        --Dual Constant Thresholds
      ELSIF (C_PROG_FULL_TYPE = 2) THEN

        -- If we will be going at or above the C_PROG_FULL_ASSERT threshold
        -- on the next clock cycle, then assert PROG_FULL

        -- WARNING: For the fifo with separate clocks, it is possible that
        -- the core could be both reading and writing simultaneously, with
        -- the writes occuring faster. This means that the number of words
        -- in the FIFO is increasing, and PROG_FULL should be asserted. So,
        -- we assume the worst and assert PROG_FULL if we are close and
        -- writing, since RD_EN may or may not have an impact on the number
        -- of words in the FIFO.
        IF ((size/C_RATIO_R = C_PROG_FULL_THRESH_ASSERT_VAL-1) AND WR_EN = '1') THEN
          PROG_FULL <= '1';

          -- If we will be going below C_PROG_FULL_NEGATE on the next clock
          -- cycle, then de-assert PROG_FULL
          -- Note: In this case, we will assume reading and not writing
          -- will cause the number of words in the FIFO to decrease by one.
          -- It is possible that the number of words in the FIFO could
          -- decrease when reading and writing simultaneously, but the
          -- negate condition need not occur exactly when we cross below the
          -- negate threshold.
          -- ELSIF ((size/C_RATIO_R = C_PROG_FULL_NEGATE) AND RD_EN = '1'
          --        AND WR_EN='0') THEN
          --   PROG_FULL <= '0';

          -- If we are at or above the C_PROG_FULL_ASSERT, then assert
          -- PROG_FULL
        ELSIF (size/C_RATIO_R >= C_PROG_FULL_THRESH_ASSERT_VAL) THEN
          PROG_FULL <= '1';
          --If we are below the C_PROG_FULL_NEGATE, then de-assert PROG_FULL 
        ELSIF (size/C_RATIO_R < C_PROG_FULL_THRESH_NEGATE_VAL) THEN
          PROG_FULL <= '0';
        END IF;

        --Single threshold input port
      ELSIF (C_PROG_FULL_TYPE = 3) THEN

        -- If we are at or above the PROG_FULL_THRESH, or we will be 
        --  next clock cycle, then assert PROG_FULL
        IF ((size/C_RATIO_R >= std_logic_vector_2_posint(PROG_FULL_THRESH)) OR ((size/C_RATIO_R = std_logic_vector_2_posint(PROG_FULL_THRESH)-1) AND WR_EN = '1')) THEN
          PROG_FULL <= '1';
        ELSE
          PROG_FULL <= '0';
        END IF;  -- C_HAS_PROG_FULL_THRESH = 1

        --Dual threshold input ports
      ELSIF (C_PROG_FULL_TYPE = 4) THEN


        -- If we will be going at or above the C_PROG_FULL_ASSERT threshold
        -- on the next clock cycle, then assert PROG_FULL
        IF ((size/C_RATIO_R = std_logic_vector_2_posint(PROG_FULL_THRESH_ASSERT)-1) AND WR_EN = '1') THEN
          PROG_FULL <= '1';
          -- If we are at or above the C_PROG_FULL_ASSERT, then assert
          -- PROG_FULL
        ELSIF (size/C_RATIO_R >= std_logic_vector_2_posint(PROG_FULL_THRESH_ASSERT)) THEN
          PROG_FULL <= '1';
          --If we are below the C_PROG_FULL_NEGATE, then de-assert PROG_FULL 
        ELSIF (size/C_RATIO_R < std_logic_vector_2_posint(PROG_FULL_THRESH_NEGATE)) THEN
          PROG_FULL <= '0';
        END IF;


      END IF;  --C_PROG_FULL_TYPE


    END IF;  --wr_clk_i

    ---------------------------------------------------------------------------
    -- Read from FIFO
    ---------------------------------------------------------------------------
    IF rd_rst_i = '1' THEN
      underflow_i       <= '0';
      valid_i           <= '0';
      output_regs_valid <= '0';
      rd_data_count_i   <= (OTHERS => '0');
      empty_i           <= '1';
      ALMOST_EMPTY      <= '1';
      PROG_EMPTY        <= '1';

      rd_point <= 0;
      wr_reg0  <= 0;
      wr_reg1  <= 0;

      --Clear data output queue
--       data := hexstr_to_std_logic_vec(C_DOUT_RST_VAL, C_DOUT_WIDTH);
      data := (OTHERS => '0');

    ELSIF rd_clk_i'event AND rd_clk_i = '1' THEN

      underflow_i <= '0';
      valid_i     <= '0';

      --Default
      wr_reg0           <= wr_point;
      wr_reg1           <= wr_reg0;
      IF wr_reg1/C_RATIO_R = rd_point/C_RATIO_W THEN
        rd_data_count_i <= (OTHERS => '0');
      ELSIF wr_reg1/C_RATIO_R > rd_point/C_RATIO_W THEN
        rd_data_count_i <= count((wr_reg1/C_RATIO_R - rd_point/C_RATIO_W), C_FIFO_RD_DEPTH, C_RD_DATA_COUNT_WIDTH);
      ELSE
        rd_data_count_i <= count((C_FIFO_RD_DEPTH-rd_point/C_RATIO_W+wr_reg1/C_RATIO_R), C_FIFO_RD_DEPTH, C_RD_DATA_COUNT_WIDTH);
      END IF;

-- IF wr_reg1/C_RATIO_R = rd_point/C_RATIO_W THEN
-- rd_diff_count <= (OTHERS => '0');
-- ELSIF wr_reg1/C_RATIO_R > rd_point/C_RATIO_W THEN
-- rd_diff_count <= count((wr_reg1/C_RATIO_R - rd_point/C_RATIO_W), C_FIFO_RD_DEPTH, C_RD_PNTR_WIDTH);
-- ELSE
-- rd_diff_count <= count((C_FIFO_RD_DEPTH-rd_point/C_RATIO_W+wr_reg1/C_RATIO_R), C_FIFO_RD_DEPTH, C_RD_PNTR_WIDTH);
-- END IF;

      rd_diff_count <= int_2_std_logic_vector((size/C_RATIO_W), C_RD_PNTR_WIDTH);

      ---------------------------------------------------------------------------
      -- Read Latency 1
      ---------------------------------------------------------------------------
      IF (C_PRELOAD_LATENCY = 1) THEN

        IF size/C_RATIO_W = 0 THEN
          empty_i      <= '1';
          ALMOST_EMPTY <= '1';
        ELSIF size/C_RATIO_W = 1 THEN
          empty_i      <= '0';
          ALMOST_EMPTY <= '1';
        ELSE
          empty_i      <= '0';
          ALMOST_EMPTY <= '0';
        END IF;

        IF RD_EN = '1' THEN

          IF empty_i /= '1' THEN
            -- FIFO full
            IF size/C_RATIO_W = 2 THEN
              ALMOST_EMPTY <= '1';
              valid_i      <= '1';
              FOR h IN C_RATIO_W DOWNTO 1 LOOP
                read(tail, data( (C_SMALLER_DATA_WIDTH*h)-1 DOWNTO C_SMALLER_DATA_WIDTH*(h-1) ) );
                remove(head, tail);
              END LOOP;
              rd_point     <= (rd_point + 1) MOD C_FIFO_RD_DEPTH;
              -- almost empty
            ELSIF size/C_RATIO_W = 1 THEN
              ALMOST_EMPTY <= '1';
              empty_i      <= '1';
              valid_i      <= '1';
              FOR h IN C_RATIO_W DOWNTO 1 LOOP
                read(tail, data( (C_SMALLER_DATA_WIDTH*h)-1 DOWNTO C_SMALLER_DATA_WIDTH*(h-1) ) );
                remove(head, tail);
              END LOOP;
              rd_point     <= (rd_point + 1) MOD C_FIFO_RD_DEPTH;
              -- fifo empty
            ELSIF size/C_RATIO_W = 0 THEN
              underflow_i  <= '1';
              -- middle counts
            ELSE
              valid_i      <= '1';
              FOR h IN C_RATIO_W DOWNTO 1 LOOP
                read(tail, data( (C_SMALLER_DATA_WIDTH*h)-1 DOWNTO C_SMALLER_DATA_WIDTH*(h-1) ) );
                remove(head, tail);
              END LOOP;
              rd_point     <= (rd_point + 1) MOD C_FIFO_RD_DEPTH;
            END IF;
          ELSE
            underflow_i    <= '1';
          END IF;
        END IF;  --RD_EN
      END IF;  --C_PRELOAD_LATENCY


      ---------------------------------------------------------------------------
      -- Programmable EMPTY Flags
      ---------------------------------------------------------------------------

      --Single Constant Threshold
      IF (C_PROG_EMPTY_TYPE = 1) THEN

        -- If we are at or below the PROG_EMPTY_THRESH, or we will be 
        -- the next clock cycle, then assert PROG_EMPTY
        IF (
          (size/C_RATIO_W <= C_PROG_EMPTY_THRESH_ASSERT_VAL) OR
          ((size/C_RATIO_W = C_PROG_EMPTY_THRESH_ASSERT_VAL+1) AND RD_EN = '1')
          ) THEN
          PROG_EMPTY      <= '1';
        ELSE
          PROG_EMPTY      <= '0';
        END IF;

        --Dual constant thresholds
      ELSIF (C_PROG_EMPTY_TYPE = 2) THEN


        -- If we will be going at or below the C_PROG_EMPTY_ASSERT threshold
        -- on the next clock cycle, then assert PROG_EMPTY
        --
        -- WARNING: For the fifo with separate clocks, it is possible that
        -- the core could be both reading and writing simultaneously, with
        -- the reads occuring faster. This means that the number of words
        -- in the FIFO is decreasing, and PROG_EMPTY should be asserted. So,
        -- we assume the worst and assert PROG_EMPTY if we are close and
        -- reading, since WR_EN may or may not have an impact on the number
        -- of words in the FIFO.
        IF ((size/C_RATIO_W = C_PROG_EMPTY_THRESH_ASSERT_VAL+1) AND RD_EN = '1') THEN
          PROG_EMPTY <= '1';
          -- If we will be going above C_PROG_EMPTY_NEGATE on the next clock
          -- cycle, then de-assert PROG_EMPTY
          --
          -- Note: In this case, we will assume writing and not reading
          -- will cause the number of words in the FIFO to increase by one.
          -- It is possible that the number of words in the FIFO could
          -- increase when reading and writing simultaneously, but the negate
          -- condition need not occur exactly when we cross below the negate
          -- threshold.
          -- ELSIF ((size/C_RATIO_W = C_PROG_EMPTY_NEGATE) AND WR_EN = '1'
          -- AND RD_EN = '0') THEN
          --   PROG_EMPTY          <= '0';

          -- If we are at or below the C_PROG_EMPTY_ASSERT, then assert
          -- PROG_EMPTY
        ELSIF (size/C_RATIO_W <= C_PROG_EMPTY_THRESH_ASSERT_VAL) THEN
          PROG_EMPTY          <= '1';

          --If we are above the C_PROG_EMPTY_NEGATE, then de-assert PROG_EMPTY
        ELSIF (size/C_RATIO_W > C_PROG_EMPTY_THRESH_NEGATE_VAL) THEN
          PROG_EMPTY <= '0';
        END IF;

        --Single threshold input port
      ELSIF (C_PROG_EMPTY_TYPE = 3) THEN

        -- If we are at or below the PROG_EMPTY_THRESH, or we will be 
        -- the next clock cycle, then assert PROG_EMPTY
        IF (
          (size/C_RATIO_W <= std_logic_vector_2_posint(PROG_EMPTY_THRESH)) OR
          ((size/C_RATIO_W = std_logic_vector_2_posint(PROG_EMPTY_THRESH)+1) AND RD_EN = '1')
          ) THEN
          PROG_EMPTY      <= '1';
        ELSE
          PROG_EMPTY      <= '0';
        END IF;


        --Dual threshold input ports
      ELSIF (C_PROG_EMPTY_TYPE = 4) THEN

        -- If we will be going at or below the C_PROG_EMPTY_ASSERT threshold
        -- on the next clock cycle, then assert PROG_EMPTY
        IF ((size/C_RATIO_W = std_logic_vector_2_posint(PROG_EMPTY_THRESH_ASSERT)+1) AND RD_EN = '1') THEN
          PROG_EMPTY          <= '1';
          -- If we are at or below the C_PROG_EMPTY_ASSERT, then assert
          -- PROG_EMPTY
        ELSIF (size/C_RATIO_W <= std_logic_vector_2_posint(PROG_EMPTY_THRESH_ASSERT)) THEN
          PROG_EMPTY          <= '1';

          --If we are above the C_PROG_EMPTY_NEGATE, then de-assert PROG_EMPTY
        ELSIF (size/C_RATIO_W > std_logic_vector_2_posint(PROG_EMPTY_THRESH_NEGATE)) THEN
          PROG_EMPTY <= '0';
        END IF;


      END IF;





    END IF;  --rd_clk_i

    DOUT <= data;

  END PROCESS;


END behavioral;







-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--  Top-level Behavioral Model                                   
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

-- LIBRARY work;                        --SIM
-- USE work.iputils_conv.ALL;           --SIM
-- USE work.iputils_misc.ALL;           --SIM
-- USE work.fifo_generator_v1_0_bhv_as; --SIM
-- USE work.fifo_generator_v1_0_bhv_ss; --SIM

LIBRARY XilinxCoreLib;                  --XCC
USE XilinxCoreLib.iputils_conv.ALL;     --XCC
USE XilinxCoreLib.iputils_misc.ALL;     --XCC
USE XilinxCoreLib.fifo_generator_v1_0_bhv_as; --XCC
USE XilinxCoreLib.fifo_generator_v1_0_bhv_ss; --XCC



-- ENTITY fifo_generator_v1_0_bhv IS    --SIM
ENTITY fifo_generator_v1_0 IS           --XCC
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
    C_PRELOAD_REGS                : integer := 0;
    C_PRELOAD_LATENCY             : integer := 1;
    C_PROG_EMPTY_THRESH_ASSERT_VAL: integer := 0;
    C_PROG_EMPTY_THRESH_NEGATE_VAL: integer := 0;
    C_PROG_EMPTY_TYPE             : integer := 0;
    C_PROG_FULL_THRESH_ASSERT_VAL : integer := 0;
    C_PROG_FULL_THRESH_NEGATE_VAL : integer := 0;
    C_PROG_FULL_TYPE              : integer := 0;
    C_RD_DATA_COUNT_WIDTH         : integer := 2;
    C_RD_DEPTH                    : integer := 256;
    C_RD_PNTR_WIDTH               : integer := 8;
    C_UNDERFLOW_LOW               : integer := 0;
    C_VALID_LOW                   : integer := 0;
    C_WR_ACK_LOW                  : integer := 0;
    C_WR_DATA_COUNT_WIDTH         : integer := 2;
    C_WR_DEPTH                    : integer := 256;
    C_WR_PNTR_WIDTH               : integer := 8;
    C_WR_RESPONSE_LATENCY         : integer := 1
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
    WR_CLK                    : IN  std_logic := '0';
    WR_EN                     : IN  std_logic;  --Mandatory input
    WR_RST                    : IN  std_logic := '0';

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
    WR_DATA_COUNT             : OUT std_logic_vector(C_WR_DATA_COUNT_WIDTH-1 DOWNTO 0)
--  ;                                     --SIM

    ---------------------------------------------------------------------------
    --DEBUG outputs
    -- These pins should be commented-out, but left in the code for future
    -- use when debugging.  To restore these pins, uncomment them from both
    -- this file and the fifo_generator_v1_0GUI.java file.
    -- When these lines are commented-out, they need to be declared as signals,
    -- so that the underlying XST module can still be properly instantiated.
    ---------------------------------------------------------------------------
--      DEBUG_WR_PNTR             : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);  --SIM
--      DEBUG_RD_PNTR             : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);  --SIM
--      DEBUG_RAM_WR_EN           : OUT std_logic;  --SIM
--      DEBUG_RAM_RD_EN           : OUT std_logic;  --SIM
--      debug_wr_pntr_w           : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);  --SIM
--      debug_wr_pntr_plus1_w     : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);  --SIM
--      debug_wr_pntr_plus2_w     : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);  --SIM
--      debug_wr_pntr_r           : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);  --SIM
--      debug_rd_pntr_r           : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);  --SIM
--      debug_rd_pntr_plus1_r     : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);  --SIM
--      debug_rd_pntr_w           : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);  --SIM
--      DEBUG_RAM_EMPTY           : OUT std_logic;  --SIM
--      DEBUG_RAM_FULL            : OUT std_logic  --SIM
    );

-- END fifo_generator_v1_0_bhv;         --SIM
END fifo_generator_v1_0;  --XCC



-- ARCHITECTURE behavioral OF fifo_generator_v1_0_bhv IS  --SIM
ARCHITECTURE behavioral OF fifo_generator_v1_0 IS         --XCC


  COMPONENT fifo_generator_v1_0_bhv_as

    GENERIC (
      --------------------------------------------------------------------------------
      -- Generic Declarations
      --------------------------------------------------------------------------------
      --C_COMMON_CLOCK            :     integer := DEFAULT_COMMON_CLOCK;
      --C_COUNT_TYPE              :     integer := DEFAULT_COUNT_TYPE;
      --C_DATA_COUNT_WIDTH        :     integer := DEFAULT_DATA_COUNT_WIDTH;
      --C_DEFAULT_VALUE           :     string  := DEFAULT_DEFAULT_VALUE;
      C_DIN_WIDTH                    :    integer := 8;
      C_DOUT_RST_VAL                 :    string  := "";
      C_DOUT_WIDTH                   :    integer := 8;
      C_ENABLE_RLOCS                 :    integer := 0;
      C_FAMILY                       :    string  := "";
      C_HAS_ALMOST_FULL              :    integer := 0;
      C_HAS_ALMOST_EMPTY             :    integer := 0;
      --C_HAS_BACKUP              :     integer := DEFAULT_HAS_BACKUP;
      --C_HAS_DATA_COUNT          :     integer := DEFAULT_HAS_DATA_COUNT;
      --C_HAS_MEMINIT_FILE        :     integer := DEFAULT_HAS_MEMINIT_FILE;
      C_HAS_OVERFLOW                 :    integer := 0;
      --C_HAS_PROG_EMPTY          :     integer := DEFAULT_HAS_PROG_EMPTY;
      --C_HAS_PROG_EMPTY_THRESH   :     integer := DEFAULT_HAS_PROG_EMPTY_THRESH;
      --C_HAS_PROG_FULL           :     integer := DEFAULT_HAS_PROG_FULL;
      --C_HAS_PROG_FULL_THRESH    :     integer := DEFAULT_HAS_PROG_FULL_THRESH;
      C_HAS_RD_DATA_COUNT            :    integer := 2;
      C_HAS_VALID                    :    integer := 0;
      --C_HAS_RD_RST              :     integer := DEFAULT_HAS_RD_RST;
      C_HAS_RST                      :    integer := 1;
      C_HAS_UNDERFLOW                :    integer := 0;
      C_HAS_WR_ACK                   :    integer := 0;
      C_HAS_WR_DATA_COUNT            :    integer := 2;
      --C_HAS_WR_RST              :     integer := DEFAULT_HAS_WR_RST;
      --C_INIT_WR_PNTR_VAL        :     integer := DEFAULT_INIT_WR_PNTR_VAL;
      C_MEMORY_TYPE                  :    integer := 1;
      --C_MIF_FILE_NAME           :     string  := DEFAULT_MIF_FILE_NAME;
      C_OPTIMIZATION_MODE            :    integer := 0;
      C_WR_RESPONSE_LATENCY          :    integer := 1;
      C_OVERFLOW_LOW                 :    integer := 0;
      C_PRELOAD_REGS                 :    integer := 0;
      C_PRELOAD_LATENCY              :    integer := 1;
      --C_PROG_EMPTY_ASSERT       :     integer := DEFAULT_PROG_EMPTY_ASSERT;
      --C_PROG_EMPTY_NEGATE       :     integer := DEFAULT_PROG_EMPTY_NEGATE;
      --C_PROG_FULL_ASSERT        :     integer := DEFAULT_PROG_FULL_ASSERT;
      --C_PROG_FULL_NEGATE        :     integer := DEFAULT_PROG_FULL_NEGATE;
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
      C_WR_PNTR_WIDTH                :    integer := 8
      );
    PORT(
--------------------------------------------------------------------------------
-- Input and Output Declarations
--------------------------------------------------------------------------------
      --CLK                       : IN  std_logic;
      --BACKUP                    : IN  std_logic;
      --BACKUP_MARKER             : IN  std_logic;
      DIN                            : IN std_logic_vector(C_DIN_WIDTH-1 DOWNTO 0);
      PROG_EMPTY_THRESH              : IN std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
      PROG_EMPTY_THRESH_ASSERT       : IN std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
      PROG_EMPTY_THRESH_NEGATE       : IN std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
      PROG_FULL_THRESH               : IN std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
      PROG_FULL_THRESH_ASSERT        : IN std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
      PROG_FULL_THRESH_NEGATE        : IN std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
      RD_CLK                         : IN std_logic;
      RD_EN                          : IN std_logic;
      --RD_RST                    : IN  std_logic;
      RST                            : IN std_logic;
      WR_CLK                         : IN std_logic;
      WR_EN                          : IN std_logic;
      --WR_RST                    : IN  std_logic;

      ALMOST_EMPTY  : OUT std_logic;
      ALMOST_FULL   : OUT std_logic;
      --DATA_COUNT                : OUT STD_LOGIC_VECTOR(C_DATA_COUNT_WIDTH-1 DOWNTO 0);
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
      WR_DATA_COUNT : OUT std_logic_vector(C_WR_DATA_COUNT_WIDTH-1 DOWNTO 0);

      DEBUG_WR_PNTR         : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
      DEBUG_RD_PNTR         : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
      DEBUG_RAM_WR_EN       : OUT std_logic;
      DEBUG_RAM_RD_EN       : OUT std_logic;
      debug_wr_pntr_w       : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
      debug_wr_pntr_plus1_w : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
      debug_wr_pntr_plus2_w : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
      debug_wr_pntr_r       : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
      debug_rd_pntr_r       : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
      debug_rd_pntr_plus1_r : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
      debug_rd_pntr_w       : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
      DEBUG_RAM_EMPTY       : OUT std_logic;
      DEBUG_RAM_FULL        : OUT std_logic
      );

  END COMPONENT;



  COMPONENT fifo_generator_v1_0_bhv_ss

    GENERIC (
    --------------------------------------------------------------------------------
    -- Generic Declarations (alphabetical)
    --------------------------------------------------------------------------------
    C_COMMON_CLOCK          : integer := 0;
    C_COUNT_TYPE            : integer := 0;
    C_DATA_COUNT_WIDTH      : integer := 2;
    C_DEFAULT_VALUE         : string  := "";
    C_DIN_WIDTH             : integer := 8;
    C_DOUT_RST_VAL          : string  := "";
    C_DOUT_WIDTH            : integer := 8; 
    C_ENABLE_RLOCS          : integer := 0;
    C_FAMILY                : string  := "virtex2"; 
    C_HAS_ALMOST_FULL       : integer := 0;
    C_HAS_ALMOST_EMPTY      : integer := 0;
    C_HAS_BACKUP            : integer := 0;
    C_HAS_DATA_COUNT        : integer := 0; 
    C_HAS_MEMINIT_FILE      : integer := 0;
    C_HAS_OVERFLOW          : integer := 0; 
    C_HAS_RD_DATA_COUNT     : integer := 0;
    C_HAS_RD_RST            : integer := 0;
    C_HAS_RST               : integer := 0;
    C_HAS_UNDERFLOW         : integer := 0; 
    C_HAS_VALID             : integer := 0;
    C_HAS_WR_ACK            : integer := 0;
    C_HAS_WR_DATA_COUNT     : integer := 0;
    C_HAS_WR_RST            : integer := 0;
    C_INIT_WR_PNTR_VAL      : integer := 0;
    C_MEMORY_TYPE           : integer := 1;
    C_MIF_FILE_NAME         : string  := "";
    C_OPTIMIZATION_MODE     : integer := 0;
    C_OVERFLOW_LOW          : integer := 0;
    C_PRELOAD_REGS          : integer := 0;
    C_PRELOAD_LATENCY       : integer := 1; 
    C_PROG_EMPTY_THRESH_ASSERT_VAL : integer := 0;
    C_PROG_EMPTY_THRESH_NEGATE_VAL : integer := 0;
    C_PROG_EMPTY_TYPE              : integer := 0;  
    C_PROG_FULL_THRESH_ASSERT_VAL  : integer := 0;
    C_PROG_FULL_THRESH_NEGATE_VAL  : integer := 0;    
    C_PROG_FULL_TYPE               : integer := 0;  
    C_RD_DATA_COUNT_WIDTH   : integer := 2;
    C_RD_DEPTH              : integer := 256;
    C_RD_PNTR_WIDTH         : integer := 8;
    C_UNDERFLOW_LOW         : integer := 0;
    C_VALID_LOW             : integer := 0;
    C_WR_ACK_LOW            : integer := 0;
    C_WR_DATA_COUNT_WIDTH   : integer := 2;
    C_WR_DEPTH              : integer := 256; 
    C_WR_PNTR_WIDTH         : integer := 8;
    C_WR_RESPONSE_LATENCY   : integer := 1
    );


  PORT(
--------------------------------------------------------------------------------
-- Input and Output Declarations
--------------------------------------------------------------------------------
    CLK               : IN std_logic                                    := '0';
    BACKUP            : IN std_logic                                    := '0';
    BACKUP_MARKER     : IN std_logic                                    := '0';
    DIN               : IN std_logic_vector(C_DIN_WIDTH-1 DOWNTO 0)     := (OTHERS => '0');
    PROG_EMPTY_THRESH : IN std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    PROG_EMPTY_THRESH_ASSERT : IN std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    PROG_EMPTY_THRESH_NEGATE : IN std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    PROG_FULL_THRESH  : IN std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    PROG_FULL_THRESH_ASSERT  : IN std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    PROG_FULL_THRESH_NEGATE  : IN std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    RD_CLK            : IN std_logic                                    := '0';
    RD_EN             : IN std_logic                                    := '0';
    RD_RST            : IN std_logic                                    := '0';
    RST               : IN std_logic                                    := '0';
    WR_CLK            : IN std_logic                                    := '0'; 
    WR_EN             : IN std_logic                                    := '0';
    WR_RST            : IN std_logic                                    := '0';

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
    WR_DATA_COUNT : OUT std_logic_vector(C_WR_DATA_COUNT_WIDTH-1 DOWNTO 0); 

    DEBUG_WR_PNTR         : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0); 
    DEBUG_RD_PNTR         : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0); 
    DEBUG_RAM_WR_EN       : OUT std_logic; 
    DEBUG_RAM_RD_EN       : OUT std_logic; 
    debug_wr_pntr_w       : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0); 
    debug_wr_pntr_plus1_w : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0); 
    debug_wr_pntr_plus2_w : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0); 
    debug_wr_pntr_r       : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0); 
    debug_rd_pntr_r       : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0); 
    debug_rd_pntr_plus1_r : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0); 
    debug_rd_pntr_w       : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0); 
    DEBUG_RAM_EMPTY       : OUT std_logic; 
    DEBUG_RAM_FULL        : OUT std_logic 
    );

  END COMPONENT;



  COMPONENT fifo_generator_v1_0_bhv_fifo16

    GENERIC (
      --------------------------------------------------------------------------------
      -- Generic Declarations
      --------------------------------------------------------------------------------
      --C_COMMON_CLOCK            :     integer := DEFAULT_COMMON_CLOCK;
      --C_COUNT_TYPE              :     integer := DEFAULT_COUNT_TYPE;
      --C_DATA_COUNT_WIDTH        :     integer := DEFAULT_DATA_COUNT_WIDTH;
      --C_DEFAULT_VALUE           :     string  := DEFAULT_DEFAULT_VALUE;
      C_DIN_WIDTH                    :    integer := 8;
      C_DOUT_RST_VAL                 :    string  := "";
      C_DOUT_WIDTH                   :    integer := 8;
      C_ENABLE_RLOCS                 :    integer := 0;
      C_FAMILY                       :    string  := "";
      C_HAS_ALMOST_FULL              :    integer := 0;
      C_HAS_ALMOST_EMPTY             :    integer := 0;
      --C_HAS_BACKUP              :     integer := DEFAULT_HAS_BACKUP;
      --C_HAS_DATA_COUNT          :     integer := DEFAULT_HAS_DATA_COUNT;
      --C_HAS_MEMINIT_FILE        :     integer := DEFAULT_HAS_MEMINIT_FILE;
      C_HAS_OVERFLOW                 :    integer := 0;
      --C_HAS_PROG_EMPTY          :     integer := DEFAULT_HAS_PROG_EMPTY;
      --C_HAS_PROG_EMPTY_THRESH   :     integer := DEFAULT_HAS_PROG_EMPTY_THRESH;
      --C_HAS_PROG_FULL           :     integer := DEFAULT_HAS_PROG_FULL;
      --C_HAS_PROG_FULL_THRESH    :     integer := DEFAULT_HAS_PROG_FULL_THRESH;
      C_HAS_RD_DATA_COUNT            :    integer := 2;
      C_HAS_VALID                    :    integer := 0;
      --C_HAS_RD_RST              :     integer := DEFAULT_HAS_RD_RST;
      C_HAS_RST                      :    integer := 1;
      C_HAS_UNDERFLOW                :    integer := 0;
      C_HAS_WR_ACK                   :    integer := 0;
      C_HAS_WR_DATA_COUNT            :    integer := 2;
      --C_HAS_WR_RST              :     integer := DEFAULT_HAS_WR_RST;
      --C_INIT_WR_PNTR_VAL        :     integer := DEFAULT_INIT_WR_PNTR_VAL;
      C_MEMORY_TYPE                  :    integer := 1;
      --C_MIF_FILE_NAME           :     string  := DEFAULT_MIF_FILE_NAME;
      C_OPTIMIZATION_MODE            :    integer := 0;
      C_WR_RESPONSE_LATENCY          :    integer := 1;
      C_OVERFLOW_LOW                 :    integer := 0;
      C_PRELOAD_REGS                 :    integer := 0;
      C_PRELOAD_LATENCY              :    integer := 1;
      --C_PROG_EMPTY_ASSERT       :     integer := DEFAULT_PROG_EMPTY_ASSERT;
      --C_PROG_EMPTY_NEGATE       :     integer := DEFAULT_PROG_EMPTY_NEGATE;
      --C_PROG_FULL_ASSERT        :     integer := DEFAULT_PROG_FULL_ASSERT;
      --C_PROG_FULL_NEGATE        :     integer := DEFAULT_PROG_FULL_NEGATE;
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
      C_WR_PNTR_WIDTH                :    integer := 8
      );
    PORT(
--------------------------------------------------------------------------------
-- Input and Output Declarations
--------------------------------------------------------------------------------
      --CLK                       : IN  std_logic;
      --BACKUP                    : IN  std_logic;
      --BACKUP_MARKER             : IN  std_logic;
      DIN                            : IN std_logic_vector(C_DIN_WIDTH-1 DOWNTO 0);
      PROG_EMPTY_THRESH              : IN std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
      PROG_EMPTY_THRESH_ASSERT       : IN std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
      PROG_EMPTY_THRESH_NEGATE       : IN std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
      PROG_FULL_THRESH               : IN std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
      PROG_FULL_THRESH_ASSERT        : IN std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
      PROG_FULL_THRESH_NEGATE        : IN std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
      RD_CLK                         : IN std_logic;
      RD_EN                          : IN std_logic;
      --RD_RST                    : IN  std_logic;
      RST                            : IN std_logic;
      WR_CLK                         : IN std_logic;
      WR_EN                          : IN std_logic;
      --WR_RST                    : IN  std_logic;

      ALMOST_EMPTY  : OUT std_logic;
      ALMOST_FULL   : OUT std_logic;
      --DATA_COUNT                : OUT STD_LOGIC_VECTOR(C_DATA_COUNT_WIDTH-1 DOWNTO 0);
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
      WR_DATA_COUNT : OUT std_logic_vector(C_WR_DATA_COUNT_WIDTH-1 DOWNTO 0);

      DEBUG_WR_PNTR         : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
      DEBUG_RD_PNTR         : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
      DEBUG_RAM_WR_EN       : OUT std_logic;
      DEBUG_RAM_RD_EN       : OUT std_logic;
      debug_wr_pntr_w       : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
      debug_wr_pntr_plus1_w : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
      debug_wr_pntr_plus2_w : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
      debug_wr_pntr_r       : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
      debug_rd_pntr_r       : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
      debug_rd_pntr_plus1_r : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
      debug_rd_pntr_w       : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
      DEBUG_RAM_EMPTY       : OUT std_logic;
      DEBUG_RAM_FULL        : OUT std_logic
      );

  END COMPONENT;

  SIGNAL zero : std_logic := '0';



  

  
  SIGNAL DEBUG_WR_PNTR         : std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0); --XCC
  SIGNAL DEBUG_RD_PNTR         : std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0); --XCC
  SIGNAL DEBUG_RAM_WR_EN       : std_logic; --XCC
  SIGNAL DEBUG_RAM_RD_EN       : std_logic; --XCC
  SIGNAL DEBUG_WR_PNTR_W       : std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0); --XCC
  SIGNAL DEBUG_WR_PNTR_PLUS1_W : std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0); --XCC
  SIGNAL DEBUG_WR_PNTR_PLUS2_W : std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0); --XCC
  SIGNAL DEBUG_WR_PNTR_R       : std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0); --XCC
  SIGNAL DEBUG_RD_PNTR_R       : std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0); --XCC
  SIGNAL DEBUG_RD_PNTR_PLUS1_R : std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0); --XCC
  SIGNAL DEBUG_RD_PNTR_W       : std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0); --XCC
  SIGNAL DEBUG_RAM_EMPTY       : std_logic; --XCC
  SIGNAL DEBUG_RAM_FULL        : std_logic; --XCC


BEGIN

  --Assign Ground Signal
  zero <= '0';


  
  gen_ss : IF ((C_IMPLEMENTATION_TYPE = 0) OR (C_IMPLEMENTATION_TYPE = 1)) GENERATE
    fgss : fifo_generator_v1_0_bhv_ss
      GENERIC MAP (
        C_COMMON_CLOCK            => C_COMMON_CLOCK,
        C_COUNT_TYPE              => C_COUNT_TYPE,
        C_DATA_COUNT_WIDTH        => C_DATA_COUNT_WIDTH,
        C_DEFAULT_VALUE           => C_DEFAULT_VALUE,
        C_DIN_WIDTH                    => C_DIN_WIDTH,
        C_DOUT_RST_VAL                 => C_DOUT_RST_VAL,
        C_DOUT_WIDTH                   => C_DOUT_WIDTH,
        C_ENABLE_RLOCS                 => C_ENABLE_RLOCS,
        C_FAMILY                       => C_FAMILY,
        C_HAS_ALMOST_EMPTY             => C_HAS_ALMOST_EMPTY,
        C_HAS_ALMOST_FULL              => C_HAS_ALMOST_FULL,
        C_HAS_BACKUP              => C_HAS_BACKUP,
        C_HAS_DATA_COUNT          => C_HAS_DATA_COUNT,
        C_HAS_MEMINIT_FILE        => C_HAS_MEMINIT_FILE,
        C_HAS_OVERFLOW                 => C_HAS_OVERFLOW,
        C_HAS_RD_DATA_COUNT            => C_HAS_RD_DATA_COUNT,
        C_HAS_RD_RST              => C_HAS_RD_RST,
        C_HAS_RST                      => C_HAS_RST,
        C_HAS_UNDERFLOW                => C_HAS_UNDERFLOW,
        C_HAS_VALID                    => C_HAS_VALID,
        C_HAS_WR_ACK                   => C_HAS_WR_ACK,
        C_HAS_WR_DATA_COUNT            => C_HAS_WR_DATA_COUNT,
        C_HAS_WR_RST              => C_HAS_WR_RST,
        C_INIT_WR_PNTR_VAL        => C_INIT_WR_PNTR_VAL,
        C_MEMORY_TYPE                  => C_MEMORY_TYPE,
        C_MIF_FILE_NAME           => C_MIF_FILE_NAME,
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
        C_WR_RESPONSE_LATENCY          => C_WR_RESPONSE_LATENCY
        )
      PORT MAP(
        --Inputs
        CLK                       => CLK,
        BACKUP                    => BACKUP,
        BACKUP_MARKER             => BACKUP_MARKER,
        DIN                            => DIN,
        PROG_EMPTY_THRESH              => PROG_EMPTY_THRESH,
        PROG_EMPTY_THRESH_ASSERT       => PROG_EMPTY_THRESH_ASSERT,
        PROG_EMPTY_THRESH_NEGATE       => PROG_EMPTY_THRESH_NEGATE,
        PROG_FULL_THRESH               => PROG_FULL_THRESH,
        PROG_FULL_THRESH_ASSERT        => PROG_FULL_THRESH_ASSERT,
        PROG_FULL_THRESH_NEGATE        => PROG_FULL_THRESH_NEGATE,
        RD_CLK                         => zero,
        RD_EN                          => RD_EN,
        RD_RST                    => RD_RST,
        RST                            => RST,
        WR_CLK                         => zero,
        WR_EN                          => WR_EN,
        WR_RST                    => WR_RST,

        --Outputs
        ALMOST_EMPTY          => ALMOST_EMPTY,
        ALMOST_FULL           => ALMOST_FULL,
        DATA_COUNT            => DATA_COUNT,
        DOUT                  => DOUT,
        EMPTY                 => EMPTY,
        FULL                  => FULL,
        OVERFLOW              => OVERFLOW,
        PROG_EMPTY            => PROG_EMPTY,
        PROG_FULL             => PROG_FULL,
        RD_DATA_COUNT         => RD_DATA_COUNT,
        UNDERFLOW             => UNDERFLOW,
        VALID                 => VALID,
        WR_ACK                => WR_ACK,
        WR_DATA_COUNT         => WR_DATA_COUNT,
        
        DEBUG_WR_PNTR         => DEBUG_WR_PNTR,
        DEBUG_RD_PNTR         => DEBUG_RD_PNTR,
        DEBUG_RAM_WR_EN       => DEBUG_RAM_WR_EN,
        DEBUG_RAM_RD_EN       => DEBUG_RAM_RD_EN,
        DEBUG_WR_PNTR_W       => DEBUG_WR_PNTR_W,
        DEBUG_WR_PNTR_PLUS1_W => DEBUG_WR_PNTR_PLUS1_W,
        DEBUG_WR_PNTR_PLUS2_W => DEBUG_WR_PNTR_PLUS2_W,
        DEBUG_WR_PNTR_R       => DEBUG_WR_PNTR_R,
        DEBUG_RD_PNTR_R       => DEBUG_RD_PNTR_R, 
        DEBUG_RD_PNTR_PLUS1_R => DEBUG_RD_PNTR_PLUS1_R, 
        DEBUG_RD_PNTR_W       => DEBUG_RD_PNTR_W, 
        DEBUG_RAM_EMPTY       => DEBUG_RAM_EMPTY, 
        DEBUG_RAM_FULL  => DEBUG_RAM_FULL 

        );
  END GENERATE gen_ss;



  gen_as : IF (C_IMPLEMENTATION_TYPE = 2) GENERATE

    fgas : fifo_generator_v1_0_bhv_as
      GENERIC MAP (
        --C_COMMON_CLOCK            => C_COMMON_CLOCK,
        --C_COUNT_TYPE              => C_COUNT_TYPE,
        --C_DATA_COUNT_WIDTH        => C_DATA_COUNT_WIDTH,
        --C_DEFAULT_VALUE           => C_DEFAULT_VALUE,
        C_DIN_WIDTH                    => C_DIN_WIDTH,
        C_DOUT_RST_VAL                 => C_DOUT_RST_VAL,
        C_DOUT_WIDTH                   => C_DOUT_WIDTH,
        C_ENABLE_RLOCS                 => C_ENABLE_RLOCS,
        C_FAMILY                       => C_FAMILY,
        --C_FIRST_WORD_FALL_THROUGH => C_FIRST_WORD_FALL_THROUGH,
        C_HAS_ALMOST_EMPTY             => C_HAS_ALMOST_EMPTY,
        C_HAS_ALMOST_FULL              => C_HAS_ALMOST_FULL,
        --C_HAS_BACKUP              => C_HAS_BACKUP,
        --C_HAS_DATA_COUNT          => C_HAS_DATA_COUNT,
        --C_HAS_MEMINIT_FILE        => C_HAS_MEMINIT_FILE,
        C_HAS_OVERFLOW                 => C_HAS_OVERFLOW,
        --C_HAS_PROG_EMPTY          => C_HAS_PROG_EMPTY,
        --C_HAS_PROG_EMPTY_THRESH   => C_HAS_PROG_EMPTY_THRESH,
        --C_HAS_PROG_FULL           => C_HAS_PROG_FULL,
        --C_HAS_PROG_FULL_THRESH    => C_HAS_PROG_FULL_THRESH,
        C_PROG_EMPTY_TYPE              => C_PROG_EMPTY_TYPE,
        C_PROG_EMPTY_THRESH_ASSERT_VAL => C_PROG_EMPTY_THRESH_ASSERT_VAL,
        C_PROG_EMPTY_THRESH_NEGATE_VAL => C_PROG_EMPTY_THRESH_NEGATE_VAL,
        C_PROG_FULL_TYPE               => C_PROG_FULL_TYPE,
        C_PROG_FULL_THRESH_ASSERT_VAL  => C_PROG_FULL_THRESH_ASSERT_VAL,
        C_PROG_FULL_THRESH_NEGATE_VAL  => C_PROG_FULL_THRESH_NEGATE_VAL,
        C_HAS_VALID                    => C_HAS_VALID,
        C_HAS_RD_DATA_COUNT            => C_HAS_RD_DATA_COUNT,
        --C_HAS_RD_RST              => C_HAS_RD_RST,
        C_HAS_RST                      => C_HAS_RST,
        C_HAS_UNDERFLOW                => C_HAS_UNDERFLOW,
        C_HAS_WR_ACK                   => C_HAS_WR_ACK,
        C_HAS_WR_DATA_COUNT            => C_HAS_WR_DATA_COUNT,
        --C_HAS_WR_RST              => C_HAS_WR_RST,
        --C_INIT_WR_PNTR_VAL        => C_INIT_WR_PNTR_VAL,
        C_MEMORY_TYPE                  => C_MEMORY_TYPE,
        --C_MIF_FILE_NAME           => C_MIF_FILE_NAME,
        C_OPTIMIZATION_MODE            => C_OPTIMIZATION_MODE,
        C_OVERFLOW_LOW                 => C_OVERFLOW_LOW,
        C_PRELOAD_LATENCY              => C_PRELOAD_LATENCY,
        C_PRELOAD_REGS                 => C_PRELOAD_REGS,
        --C_PROG_EMPTY_ASSERT       => C_PROG_EMPTY_ASSERT,
        --C_PROG_EMPTY_NEGATE       => C_PROG_EMPTY_NEGATE,
        --C_PROG_FULL_ASSERT        => C_PROG_FULL_ASSERT,
        --C_PROG_FULL_NEGATE        => C_PROG_FULL_NEGATE,
        C_VALID_LOW                    => C_VALID_LOW,
        C_RD_DATA_COUNT_WIDTH          => C_RD_DATA_COUNT_WIDTH,
        C_RD_DEPTH                     => C_RD_DEPTH,
        C_RD_PNTR_WIDTH                => C_RD_PNTR_WIDTH,
        C_UNDERFLOW_LOW                => C_UNDERFLOW_LOW,
        C_WR_ACK_LOW                   => C_WR_ACK_LOW,
        C_WR_DATA_COUNT_WIDTH          => C_WR_DATA_COUNT_WIDTH,
        C_WR_DEPTH                     => C_WR_DEPTH,
        C_WR_PNTR_WIDTH                => C_WR_PNTR_WIDTH,
        C_WR_RESPONSE_LATENCY          => C_WR_RESPONSE_LATENCY
        )
      PORT MAP(
        --Inputs
        --CLK                       => CLK,
        WR_CLK                         => WR_CLK,
        RD_CLK                         => RD_CLK,
        RST                            => RST,
        --WR_RST                    => WR_RST,
        --RD_RST                    => RD_RST,
        DIN                            => DIN,
        WR_EN                          => WR_EN,
        RD_EN                          => RD_EN,
        PROG_FULL_THRESH               => PROG_FULL_THRESH,
        PROG_EMPTY_THRESH_ASSERT       => PROG_EMPTY_THRESH_ASSERT,
        PROG_EMPTY_THRESH_NEGATE       => PROG_EMPTY_THRESH_NEGATE,
        PROG_EMPTY_THRESH              => PROG_EMPTY_THRESH,
        PROG_FULL_THRESH_ASSERT        => PROG_FULL_THRESH_ASSERT,
        PROG_FULL_THRESH_NEGATE        => PROG_FULL_THRESH_NEGATE,
        --BACKUP                    => BACKUP,
        --BACKUP_MARKER             => BACKUP_MARKER,

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
        --DATA_COUNT            => DATA_COUNT,
        RD_DATA_COUNT         => RD_DATA_COUNT,
        WR_DATA_COUNT         => WR_DATA_COUNT,
        PROG_FULL             => PROG_FULL,
        PROG_EMPTY            => PROG_EMPTY,
        DEBUG_WR_PNTR         => DEBUG_WR_PNTR,
        DEBUG_RD_PNTR         => DEBUG_RD_PNTR,
        DEBUG_RAM_WR_EN       => DEBUG_RAM_WR_EN,
        DEBUG_RAM_RD_EN       => DEBUG_RAM_RD_EN,
        DEBUG_WR_PNTR_W       => DEBUG_WR_PNTR_W,
        DEBUG_WR_PNTR_PLUS1_W => DEBUG_WR_PNTR_PLUS1_W,
        DEBUG_WR_PNTR_PLUS2_W => DEBUG_WR_PNTR_PLUS2_W,
        DEBUG_WR_PNTR_R       => DEBUG_WR_PNTR_R,
        DEBUG_RD_PNTR_R       => DEBUG_RD_PNTR_R, 
        DEBUG_RD_PNTR_PLUS1_R => DEBUG_RD_PNTR_PLUS1_R, 
        DEBUG_RD_PNTR_W       => DEBUG_RD_PNTR_W, 
        DEBUG_RAM_EMPTY       => DEBUG_RAM_EMPTY, 
        DEBUG_RAM_FULL  => DEBUG_RAM_FULL 

        );

  END GENERATE gen_as;

  
  gen_fifo16 : IF (C_IMPLEMENTATION_TYPE = 3) GENERATE

    fg16 : fifo_generator_v1_0_bhv_fifo16
      GENERIC MAP (
        --C_COMMON_CLOCK            => C_COMMON_CLOCK,
        --C_COUNT_TYPE              => C_COUNT_TYPE,
        --C_DATA_COUNT_WIDTH        => C_DATA_COUNT_WIDTH,
        --C_DEFAULT_VALUE           => C_DEFAULT_VALUE,
        C_DIN_WIDTH                    => C_DIN_WIDTH,
        C_DOUT_RST_VAL                 => C_DOUT_RST_VAL,
        C_DOUT_WIDTH                   => C_DOUT_WIDTH,
        C_ENABLE_RLOCS                 => C_ENABLE_RLOCS,
        C_FAMILY                       => C_FAMILY,
        --C_FIRST_WORD_FALL_THROUGH => C_FIRST_WORD_FALL_THROUGH,
        C_HAS_ALMOST_EMPTY             => C_HAS_ALMOST_EMPTY,
        C_HAS_ALMOST_FULL              => C_HAS_ALMOST_FULL,
        --C_HAS_BACKUP              => C_HAS_BACKUP,
        --C_HAS_DATA_COUNT          => C_HAS_DATA_COUNT,
        --C_HAS_MEMINIT_FILE        => C_HAS_MEMINIT_FILE,
        C_HAS_OVERFLOW                 => C_HAS_OVERFLOW,
        --C_HAS_PROG_EMPTY          => C_HAS_PROG_EMPTY,
        --C_HAS_PROG_EMPTY_THRESH   => C_HAS_PROG_EMPTY_THRESH,
        --C_HAS_PROG_FULL           => C_HAS_PROG_FULL,
        --C_HAS_PROG_FULL_THRESH    => C_HAS_PROG_FULL_THRESH,
        C_PROG_EMPTY_TYPE              => C_PROG_EMPTY_TYPE,
        C_PROG_EMPTY_THRESH_ASSERT_VAL => C_PROG_EMPTY_THRESH_ASSERT_VAL,
        C_PROG_EMPTY_THRESH_NEGATE_VAL => C_PROG_EMPTY_THRESH_NEGATE_VAL,
        C_PROG_FULL_TYPE               => C_PROG_FULL_TYPE,
        C_PROG_FULL_THRESH_ASSERT_VAL  => C_PROG_FULL_THRESH_ASSERT_VAL,
        C_PROG_FULL_THRESH_NEGATE_VAL  => C_PROG_FULL_THRESH_NEGATE_VAL,
        C_HAS_VALID                    => C_HAS_VALID,
        C_HAS_RD_DATA_COUNT            => C_HAS_RD_DATA_COUNT,
        --C_HAS_RD_RST              => C_HAS_RD_RST,
        C_HAS_RST                      => C_HAS_RST,
        C_HAS_UNDERFLOW                => C_HAS_UNDERFLOW,
        C_HAS_WR_ACK                   => C_HAS_WR_ACK,
        C_HAS_WR_DATA_COUNT            => C_HAS_WR_DATA_COUNT,
        --C_HAS_WR_RST              => C_HAS_WR_RST,
        --C_INIT_WR_PNTR_VAL        => C_INIT_WR_PNTR_VAL,
        C_MEMORY_TYPE                  => C_MEMORY_TYPE,
        --C_MIF_FILE_NAME           => C_MIF_FILE_NAME,
        C_OPTIMIZATION_MODE            => C_OPTIMIZATION_MODE,
        C_OVERFLOW_LOW                 => C_OVERFLOW_LOW,
        C_PRELOAD_LATENCY              => C_PRELOAD_LATENCY,
        C_PRELOAD_REGS                 => C_PRELOAD_REGS,
        --C_PROG_EMPTY_ASSERT       => C_PROG_EMPTY_ASSERT,
        --C_PROG_EMPTY_NEGATE       => C_PROG_EMPTY_NEGATE,
        --C_PROG_FULL_ASSERT        => C_PROG_FULL_ASSERT,
        --C_PROG_FULL_NEGATE        => C_PROG_FULL_NEGATE,
        C_VALID_LOW                    => C_VALID_LOW,
        C_RD_DATA_COUNT_WIDTH          => C_RD_DATA_COUNT_WIDTH,
        C_RD_DEPTH                     => C_RD_DEPTH,
        C_RD_PNTR_WIDTH                => C_RD_PNTR_WIDTH,
        C_UNDERFLOW_LOW                => C_UNDERFLOW_LOW,
        C_WR_ACK_LOW                   => C_WR_ACK_LOW,
        C_WR_DATA_COUNT_WIDTH          => C_WR_DATA_COUNT_WIDTH,
        C_WR_DEPTH                     => C_WR_DEPTH,
        C_WR_PNTR_WIDTH                => C_WR_PNTR_WIDTH,
        C_WR_RESPONSE_LATENCY          => C_WR_RESPONSE_LATENCY
        )
      PORT MAP(
        --Inputs
        --CLK                       => CLK,
        WR_CLK                         => WR_CLK,
        RD_CLK                         => RD_CLK,
        RST                            => RST,
        --WR_RST                    => WR_RST,
        --RD_RST                    => RD_RST,
        DIN                            => DIN,
        WR_EN                          => WR_EN,
        RD_EN                          => RD_EN,
        PROG_FULL_THRESH               => PROG_FULL_THRESH,
        PROG_EMPTY_THRESH_ASSERT       => PROG_EMPTY_THRESH_ASSERT,
        PROG_EMPTY_THRESH_NEGATE       => PROG_EMPTY_THRESH_NEGATE,
        PROG_EMPTY_THRESH              => PROG_EMPTY_THRESH,
        PROG_FULL_THRESH_ASSERT        => PROG_FULL_THRESH_ASSERT,
        PROG_FULL_THRESH_NEGATE        => PROG_FULL_THRESH_NEGATE,
        --BACKUP                    => BACKUP,
        --BACKUP_MARKER             => BACKUP_MARKER,

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
        --DATA_COUNT            => DATA_COUNT,
        RD_DATA_COUNT         => RD_DATA_COUNT,
        WR_DATA_COUNT         => WR_DATA_COUNT,
        PROG_FULL             => PROG_FULL,
        PROG_EMPTY            => PROG_EMPTY,
        DEBUG_WR_PNTR         => DEBUG_WR_PNTR,
        DEBUG_RD_PNTR         => DEBUG_RD_PNTR,
        DEBUG_RAM_WR_EN       => DEBUG_RAM_WR_EN,
        DEBUG_RAM_RD_EN       => DEBUG_RAM_RD_EN,
        DEBUG_WR_PNTR_W       => DEBUG_WR_PNTR_W,
        DEBUG_WR_PNTR_PLUS1_W => DEBUG_WR_PNTR_PLUS1_W,
        DEBUG_WR_PNTR_PLUS2_W => DEBUG_WR_PNTR_PLUS2_W,
        DEBUG_WR_PNTR_R       => DEBUG_WR_PNTR_R,
        DEBUG_RD_PNTR_R       => DEBUG_RD_PNTR_R, 
        DEBUG_RD_PNTR_PLUS1_R => DEBUG_RD_PNTR_PLUS1_R, 
        DEBUG_RD_PNTR_W       => DEBUG_RD_PNTR_W, 
        DEBUG_RAM_EMPTY       => DEBUG_RAM_EMPTY, 
        DEBUG_RAM_FULL  => DEBUG_RAM_FULL 

        );

  END GENERATE gen_fifo16;

  
  gen_other : IF (C_IMPLEMENTATION_TYPE = 4) GENERATE

    fgoth : fifo_generator_v1_0_bhv_as
      GENERIC MAP (
        --C_COMMON_CLOCK            => C_COMMON_CLOCK,
        --C_COUNT_TYPE              => C_COUNT_TYPE,
        --C_DATA_COUNT_WIDTH        => C_DATA_COUNT_WIDTH,
        --C_DEFAULT_VALUE           => C_DEFAULT_VALUE,
        C_DIN_WIDTH                    => C_DIN_WIDTH,
        C_DOUT_RST_VAL                 => C_DOUT_RST_VAL,
        C_DOUT_WIDTH                   => C_DOUT_WIDTH,
        C_ENABLE_RLOCS                 => C_ENABLE_RLOCS,
        C_FAMILY                       => C_FAMILY,
        --C_FIRST_WORD_FALL_THROUGH => C_FIRST_WORD_FALL_THROUGH,
        C_HAS_ALMOST_EMPTY             => C_HAS_ALMOST_EMPTY,
        C_HAS_ALMOST_FULL              => C_HAS_ALMOST_FULL,
        --C_HAS_BACKUP              => C_HAS_BACKUP,
        --C_HAS_DATA_COUNT          => C_HAS_DATA_COUNT,
        --C_HAS_MEMINIT_FILE        => C_HAS_MEMINIT_FILE,
        C_HAS_OVERFLOW                 => C_HAS_OVERFLOW,
        --C_HAS_PROG_EMPTY          => C_HAS_PROG_EMPTY,
        --C_HAS_PROG_EMPTY_THRESH   => C_HAS_PROG_EMPTY_THRESH,
        --C_HAS_PROG_FULL           => C_HAS_PROG_FULL,
        --C_HAS_PROG_FULL_THRESH    => C_HAS_PROG_FULL_THRESH,
        C_PROG_EMPTY_TYPE              => C_PROG_EMPTY_TYPE,
        C_PROG_EMPTY_THRESH_ASSERT_VAL => C_PROG_EMPTY_THRESH_ASSERT_VAL,
        C_PROG_EMPTY_THRESH_NEGATE_VAL => C_PROG_EMPTY_THRESH_NEGATE_VAL,
        C_PROG_FULL_TYPE               => C_PROG_FULL_TYPE,
        C_PROG_FULL_THRESH_ASSERT_VAL  => C_PROG_FULL_THRESH_ASSERT_VAL,
        C_PROG_FULL_THRESH_NEGATE_VAL  => C_PROG_FULL_THRESH_NEGATE_VAL,
        C_HAS_VALID                    => C_HAS_VALID,
        C_HAS_RD_DATA_COUNT            => C_HAS_RD_DATA_COUNT,
        --C_HAS_RD_RST              => C_HAS_RD_RST,
        C_HAS_RST                      => C_HAS_RST,
        C_HAS_UNDERFLOW                => C_HAS_UNDERFLOW,
        C_HAS_WR_ACK                   => C_HAS_WR_ACK,
        C_HAS_WR_DATA_COUNT            => C_HAS_WR_DATA_COUNT,
        --C_HAS_WR_RST              => C_HAS_WR_RST,
        --C_INIT_WR_PNTR_VAL        => C_INIT_WR_PNTR_VAL,
        C_MEMORY_TYPE                  => C_MEMORY_TYPE,
        --C_MIF_FILE_NAME           => C_MIF_FILE_NAME,
        C_OPTIMIZATION_MODE            => C_OPTIMIZATION_MODE,
        C_OVERFLOW_LOW                 => C_OVERFLOW_LOW,
        C_PRELOAD_LATENCY              => C_PRELOAD_LATENCY,
        C_PRELOAD_REGS                 => C_PRELOAD_REGS,
        --C_PROG_EMPTY_ASSERT       => C_PROG_EMPTY_ASSERT,
        --C_PROG_EMPTY_NEGATE       => C_PROG_EMPTY_NEGATE,
        --C_PROG_FULL_ASSERT        => C_PROG_FULL_ASSERT,
        --C_PROG_FULL_NEGATE        => C_PROG_FULL_NEGATE,
        C_VALID_LOW                    => C_VALID_LOW,
        C_RD_DATA_COUNT_WIDTH          => C_RD_DATA_COUNT_WIDTH,
        C_RD_DEPTH                     => C_RD_DEPTH,
        C_RD_PNTR_WIDTH                => C_RD_PNTR_WIDTH,
        C_UNDERFLOW_LOW                => C_UNDERFLOW_LOW,
        C_WR_ACK_LOW                   => C_WR_ACK_LOW,
        C_WR_DATA_COUNT_WIDTH          => C_WR_DATA_COUNT_WIDTH,
        C_WR_DEPTH                     => C_WR_DEPTH,
        C_WR_PNTR_WIDTH                => C_WR_PNTR_WIDTH,
        C_WR_RESPONSE_LATENCY          => C_WR_RESPONSE_LATENCY
        )
      PORT MAP(
        --Inputs
        --CLK                       => CLK,
        WR_CLK                         => WR_CLK,
        RD_CLK                         => RD_CLK,
        RST                            => RST,
        --WR_RST                    => WR_RST,
        --RD_RST                    => RD_RST,
        DIN                            => DIN,
        WR_EN                          => WR_EN,
        RD_EN                          => RD_EN,
        PROG_FULL_THRESH               => PROG_FULL_THRESH,
        PROG_EMPTY_THRESH_ASSERT       => PROG_EMPTY_THRESH_ASSERT,
        PROG_EMPTY_THRESH_NEGATE       => PROG_EMPTY_THRESH_NEGATE,
        PROG_EMPTY_THRESH              => PROG_EMPTY_THRESH,
        PROG_FULL_THRESH_ASSERT        => PROG_FULL_THRESH_ASSERT,
        PROG_FULL_THRESH_NEGATE        => PROG_FULL_THRESH_NEGATE,
        --BACKUP                    => BACKUP,
        --BACKUP_MARKER             => BACKUP_MARKER,

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
        --DATA_COUNT            => DATA_COUNT,
        RD_DATA_COUNT         => RD_DATA_COUNT,
        WR_DATA_COUNT         => WR_DATA_COUNT,
        PROG_FULL             => PROG_FULL,
        PROG_EMPTY            => PROG_EMPTY,
        DEBUG_WR_PNTR         => DEBUG_WR_PNTR,
        DEBUG_RD_PNTR         => DEBUG_RD_PNTR,
        DEBUG_RAM_WR_EN       => DEBUG_RAM_WR_EN,
        DEBUG_RAM_RD_EN       => DEBUG_RAM_RD_EN,
        DEBUG_WR_PNTR_W       => DEBUG_WR_PNTR_W,
        DEBUG_WR_PNTR_PLUS1_W => DEBUG_WR_PNTR_PLUS1_W,
        DEBUG_WR_PNTR_PLUS2_W => DEBUG_WR_PNTR_PLUS2_W,
        DEBUG_WR_PNTR_R       => DEBUG_WR_PNTR_R,
        DEBUG_RD_PNTR_R       => DEBUG_RD_PNTR_R, 
        DEBUG_RD_PNTR_PLUS1_R => DEBUG_RD_PNTR_PLUS1_R, 
        DEBUG_RD_PNTR_W       => DEBUG_RD_PNTR_W, 
        DEBUG_RAM_EMPTY       => DEBUG_RAM_EMPTY, 
        DEBUG_RAM_FULL  => DEBUG_RAM_FULL 

        );

  END GENERATE gen_other;




  
  
END behavioral;



