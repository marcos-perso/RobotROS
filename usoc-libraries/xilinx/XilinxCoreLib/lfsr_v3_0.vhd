-------------------------------------------------------------------------------
-- $RCSfile: lfsr_v3_0.vhd,v $ $Revision: 1.1 $ $Date: 2010-07-10 21:43:13 $
-------------------------------------------------------------------------------
--
-- LFSR - VHDL Behavioral Model
--
-------------------------------------------------------------------------------
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

-------------------------------------------------------------------------------
--
-- Filename: lfsr_v3_0.vhd
--
-- Description: 
--  The behavioral model for the LFSR core.
--
-------------------------------------------------------------------------------





library ieee;
USE IEEE.STD_LOGIC_1164.all;

--LIBRARY XilinxCoreLib;
--USE XilinxCoreLib.ul_utils.ALL;

entity lfsr_v3_0_dvunit_bhv is
  generic (
    c_size : integer;
    c_load_type : integer --0=ser, 1=pseudo-par, 2=par
    );
  port (
    load : IN std_logic;
    clk : IN std_logic;
    ce : IN std_logic;
    ainit : IN std_logic;
    sinit : IN std_logic;
    new_seed : OUT std_logic;
    data_valid : OUT std_logic
    );
end lfsr_v3_0_dvunit_bhv;


architecture xilinx of lfsr_v3_0_dvunit_bhv is

  signal cnt_val_i :  integer := 0;
  SIGNAL cnt_ov_i : std_logic := '0';
  signal cnt_val_i2 :  integer := 0;
  SIGNAL cnt_ov_i2 : std_logic := '0';
  SIGNAL data_valid_i : std_logic := '0';
  SIGNAL new_seed_i : std_logic := '1';
  SIGNAL loading_q : std_logic := '0';
  SIGNAL markinit : std_logic := '1';
  SIGNAL loading_d : std_logic := '0';
  SIGNAL ppar_q : std_logic := '1';

  SIGNAL a : std_logic := '0';
  SIGNAL b : std_logic := '0';
  SIGNAL c : std_logic := '0';
  SIGNAL d : std_logic := '0';
  SIGNAL e : std_logic := '0';
  SIGNAL f : std_logic := '0';
  SIGNAL g : std_logic := '0';
  SIGNAL cur_state : integer := 2;

begin


  a <= NOT ce;
  b <= sinit;
  c <= ainit;
  d <= ce AND NOT load;
  e <= ce AND load AND NOT cnt_ov_i2;
  f <= ce AND load;
  g <= ce AND load AND cnt_ov_i2;
  

  next_state : PROCESS (clk, c)
  BEGIN  -- PROCESS next_state
    IF c = '1' THEN
      cur_state <= 2;
    ELSE
      IF (clk'event AND clk = '1') THEN
        IF (b ='1') THEN
          cur_state <= 2;
        ELSE
          
          CASE cur_state IS
            WHEN 0 => IF a = '1' THEN cur_state <= 1; END IF;
                      IF d = '1' THEN cur_state <= 0; END IF;
                      IF e = '1' THEN cur_state <= 3; END IF;
                      IF g = '1' THEN cur_state <= 2; END IF;
                      
            WHEN 1 => IF a = '1' THEN cur_state <= 1; END IF;
                      IF d = '1' THEN cur_state <= 0; END IF;
                      IF f = '1' THEN cur_state <= 3; END IF;
                      
            WHEN 2 => IF a = '1' THEN cur_state <= 1; END IF;
                      IF d = '1' THEN cur_state <= 0; END IF;
                      IF e = '1' THEN cur_state <= 3; END IF;
                      IF g = '1' THEN cur_state <= 2; END IF;

            WHEN 3 => IF a = '1' THEN cur_state <= 6; END IF;
                      IF d = '1' THEN cur_state <= 7; END IF;
                      IF e = '1' THEN cur_state <= 3; END IF;
                      IF g = '1' THEN cur_state <= 2; END IF;

            WHEN 6 => IF a = '1' THEN cur_state <= 6; END IF;
                      IF d = '1' THEN cur_state <= 7; END IF;
                      IF f = '1' THEN cur_state <= 3; END IF;

            WHEN 7 => IF a = '1' THEN cur_state <= 7; END IF;
                      IF d = '1' THEN cur_state <= 7; END IF;
                      IF e = '1' THEN cur_state <= 7; END IF;
                      IF g = '1' THEN cur_state <= 2; END IF;

                      
            WHEN OTHERS => cur_state <= 8;
          END CASE;
        END IF;
      END IF;
    END IF;
  END PROCESS next_state;

  WITH cur_state SELECT
    new_seed_i <=
    '1' WHEN  2,
    '0' WHEN OTHERS;
  ser_dv : IF c_load_type = 0 GENERATE
    WITH cur_state SELECT
      data_valid_i <=
      '1' WHEN 0,
      '0' WHEN OTHERS;
  END GENERATE ser_dv;

  ppar_dv : IF c_load_type /= 0 GENERATE
    WITH cur_state SELECT
      data_valid_i <=
      '1' WHEN 0,
      '1' WHEN 3,
      '0' WHEN OTHERS;
  END GENERATE ppar_dv;  

  new_seed <=  new_seed_i;
  data_valid <= data_valid_i;
  

  non_par : IF c_load_type /= 2 GENERATE

    cnt_proc : PROCESS (clk, ainit)
    BEGIN
      IF (ainit='1') THEN
        cnt_val_i <= 0;
      else
        if (clk'event AND clk='1') THEN
          cnt_ov_i <= '0';
          IF (sinit='1') THEN
            cnt_val_i <= 0;
          ELSIF (ce='1') then
            IF (cnt_val_i = c_size-1)  THEN
              cnt_ov_i <= '1';
            END IF;

            IF (load = '0') THEN
              cnt_val_i <= 0;
            ELSIF (cnt_val_i=c_size) THEN 
              cnt_val_i <= 0;
            ELSE
              cnt_val_i <= cnt_val_i + 1;
            END IF;  
            
          END IF;
        END IF;
      END IF;  
    END PROCESS cnt_proc;


    cnt_val_proc: PROCESS (cnt_val_i)
    BEGIN  -- PROCESS cnt_val_proc
      IF (cnt_val_i=c_size-1) THEN
        cnt_ov_i2 <= '1';
      ELSE
        cnt_ov_i2 <= '0';
      END IF;
    END PROCESS cnt_val_proc;

    
  END GENERATE non_par;

  par : IF c_load_type = 2 GENERATE
    WITH cnt_val_i SELECT
      cnt_ov_i2 <=
      '1' WHEN 0,
      '0' WHEN OTHERS;

    cnt_ov_i2 <= '1';
  END GENERATE par;

  
end xilinx;

























-------------------------------------------------------------------------------
-- Library Declarations
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.iputils_conv.str_to_slv_0;
USE XilinxCoreLib.iputils_misc.cond_string;



-------------------------------------------------------------------------------
-- Entity Declaration
-------------------------------------------------------------------------------
ENTITY lfsr_v3_0 IS 
  GENERIC (
    c_ainit_val          : string  := "11111111";
    c_enable_rlocs       : integer := 0;
    c_gate               : integer := 0;
    c_has_ainit          : integer := 0;
    c_has_ce             : integer := 0;
    c_has_data_valid     : integer := 0;
    c_has_load           : integer := 0;
    c_has_load_taps      : integer := 0;
    c_has_new_seed       : integer := 0;
    c_has_pd_in          : integer := 0;
    c_has_pd_out         : integer := 0;
    c_has_sd_in          : integer := 0;
    c_has_sd_out         : integer := 1;
    c_has_sinit          : integer := 0;
    c_has_taps_in        : integer := 0;
    c_has_term_cnt       : integer := 0;
    c_implementation     : integer := 0;
    c_max_len_logic      : integer := 0;
    c_max_len_logic_type : integer := 0;
    c_sinit_val          : string  := "11111111";
    c_size               : integer := 8;
    c_tap_pos            : string  := "00011101";
    c_type               : integer := 0
    );
  PORT (
    clk         : IN  std_logic;
    sd_out      : OUT std_logic;
    pd_out      : OUT std_logic_vector(c_size-1 DOWNTO 0);
    load        : IN  std_logic := '0';
    pd_in       : IN  std_logic_vector(c_size-1 DOWNTO 0) := (OTHERS => '0');
    sd_in       : IN  std_logic := '0';
    ce          : IN  std_logic := '1';
    data_valid  : OUT std_logic;
    load_taps   : IN  std_logic := '0';
    taps_in     : IN  std_logic_vector(c_size-1 DOWNTO 0) := (OTHERS => '1');
    sinit       : IN  std_logic := '0';
    ainit       : IN  std_logic := '0';
    new_seed    : OUT std_logic;
    term_cnt    : OUT std_logic
    );
END lfsr_v3_0;



-------------------------------------------------------------------------------
-- Definition of Generics:

-- c_enable_rlocs       : 1=enable placement directives
-- c_has_load           : 0=no load, 1=load is enabled
-- c_has_load_taps      : 1=allow programmable taps (not a valid option for
--                        the current version)
-- c_has_new_seed       : 1=had a new seed output pin
-- c_has_pd_out         : 1=has parallel output (only if c_has_sd_out = 0)
-- c_has_sd_out         : 1=has serial output (only if c_has_pd_out = 0)
-- c_has_taps_in        : 1=has the programmable taps port (not a valid option for
--                        the current version)
-- c_has_term_cnt       : 1=has the term_cnt output pin (must have max
--                        length logic enabled)
-- c_max_len_logic_type : 0=Gate 1=Counter for Maximum Length Logic
-- c_ainit_val          : asychronous init value (also serves as GSR value, and
--                        dominates over sinit value.)
-- c_gate               : 0=XOR gates, 1=XNOR gates
-- c_has_ainit          : 1=has asynchronous initialization pin
-- c_has_ce             : 1=has clock enable pin
-- c_has_data_valid     : 1=has data valid output pin
-- c_has_pd_in          : 1=has fill_select and pd_in
-- c_has_sd_in          : 1=has fill_select and sd_in
-- c_has_sinit          : 1=has synchronous initialization pin
-- c_implementation     : 0=SRL16, 1=Registers
-- c_max_len_logic      : 1=Include logic to allow all-zeros or all-ones cases.
-- c_sinit_val          : synchronous init value
-- c_size               : length of lfsr (1 to 256)
-- c_tap_pos            : initial tap positions
-- c_type               : 0=Fibonacci, 1=Galois implementation
-------------------------------------------------------------------------------
-- Definition of Ports
-- sd_out       : the serial output port
-- pd_out       : the parallel output port
-- load         : the load enable signal, loads data on pd_in or sd_in
-- load_taps    : the enable signal to load the taps (not a valid option for
--                the current version)
-- taps_in      : the input port for the loadable taps (not a valid option for
--                the current version)
-- sinit        : synchronous initialization port
-- new_seed     : high if there is a new seed
-- term_cnt     : high for 2 clock cycles of the sequence
-- clk          : Clock
-- pn_out       : Output (width=1 for serial output, width=c_size for
--                parallel output)
-- ainit        : asynchronous init
-- ce           : clock enable
-- load_taps    : reprogram taps
-- pd_in        : parallel data input
-- sd_in        : serial data input
-- data_valid   : high if output data is valid
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- Architecture Heading
-------------------------------------------------------------------------------
ARCHITECTURE behavioral OF lfsr_v3_0 IS


-------------------------------------------------------------------------------
-- Function Declarations
-------------------------------------------------------------------------------
  FUNCTION polybit(poly : string; polysize : integer; bitnum : integer) RETURN std_logic IS
  BEGIN
    --string index range from 1 (MSB) to polysize (LSB)
    --bitnum can be any number 255 (MSB) downto 0 (LSB)
    IF bitnum < polysize THEN
      IF poly(polysize-bitnum)='0' THEN
        RETURN '0';
      ELSE
        RETURN '1';
      END IF;
    ELSE
      RETURN '0';
    END IF;
    
    
    RETURN '1';
  END polybit;

  FUNCTION zerocheck (bitvect : std_logic_vector; length : integer) RETURN std_logic IS
    VARIABLE accum_v : std_logic := '0';
  BEGIN
    FOR i IN 0 TO length-1 LOOP
      accum_v := accum_v OR bitvect(i);
    END LOOP;  -- i
    RETURN NOT accum_v;
  END zerocheck;
  
  FUNCTION onecheck (bitvect : std_logic_vector; length : integer) RETURN std_logic IS
    VARIABLE accum_v : std_logic := '1';
  BEGIN
    FOR i IN 0 TO length-1 LOOP
      accum_v := accum_v AND bitvect(i);
    END LOOP;  -- i
    RETURN accum_v;
  END onecheck;

  FUNCTION zerocheck_special (bitvect : std_logic_vector; length : integer) RETURN std_logic IS
    VARIABLE accum_v : std_logic := '0';
  BEGIN
    FOR i IN 0 TO length-1-1 LOOP
      accum_v := accum_v OR bitvect(i);
    END LOOP;  -- i
    RETURN NOT accum_v;
  END zerocheck_special;
  
  FUNCTION onecheck_special (bitvect : std_logic_vector; length : integer) RETURN std_logic IS
    VARIABLE accum_v : std_logic := '1';
  BEGIN
    FOR i IN 0 TO length-1-1 LOOP
      accum_v := accum_v AND bitvect(i);
    END LOOP;  -- i
    RETURN accum_v;
  END onecheck_special;




  FUNCTION load_type (
    c_pd_in  : integer;  
    c_sd_in  : integer;
    c_type   : integer;
    c_taps   : integer;
    c_sd_out : integer)
    RETURN integer IS
    VARIABLE ret : integer := 0;
  BEGIN  -- load_type
    IF c_pd_in =1 AND c_sd_in=0 THEN
      ret := 2;
    ELSIF c_pd_in =0 AND c_sd_in =1 THEN
      IF c_type =0 AND c_taps=0 AND c_sd_out =1 THEN
        ret := 1;
      END IF;
    END IF;
    RETURN ret;
  END load_type;





  
-------------------------------------------------------------------------------
-- Constant Declarations
-------------------------------------------------------------------------------
  CONSTANT yes : std_logic := '1' ;
  CONSTANT no  : std_logic := '0' ;

-------------------------------------------------------------------------------
-- Type Declarations
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Signal Declarations
-------------------------------------------------------------------------------
  SIGNAL d : std_logic_vector(c_size-1 DOWNTO 0) := str_to_slv_0(cond_string(c_has_ainit=1, c_ainit_val, cond_string(c_has_sinit=1, c_sinit_val, c_ainit_val)), c_size);

  SIGNAL ainit_i : std_logic := '0';
  SIGNAL ce_i : std_logic := '0';
  SIGNAL load_i : std_logic := '0';
  SIGNAL load_taps_i : std_logic := '0';
  SIGNAL pd_in_i : std_logic_vector(c_size-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL sinit_i : std_logic := '0';
  SIGNAL sd_in_i : std_logic := '0';
  SIGNAL data_valid_i : std_logic := '1';
  SIGNAL term_cnt_i : std_logic := '0';
  SIGNAL new_seed_i : std_logic := '0';

-------------------------------------------------------------------------------
-- Component Declarations
-------------------------------------------------------------------------------


  component lfsr_v3_0_dvunit_bhv
    generic (
      c_size : integer;
      c_load_type : integer --0=ser, 1=pseudo-par, 2=par
      );
    port (
      load : IN std_logic;
      clk : IN std_logic;
      ce : IN std_logic;
      ainit : IN std_logic;
      sinit : IN std_logic;
      new_seed : OUT std_logic;
      data_valid : OUT std_logic
      );
  end component;     

-------------------------------------------------------------------------------
-- Architecture Begin
-------------------------------------------------------------------------------
BEGIN


  ainit_port : IF (c_has_ainit=1) GENERATE
    ainit_i <= ainit;
  END GENERATE ainit_port;
  ainit_no_port : IF (c_has_ainit/=1) GENERATE
    ainit_i <= '0';
  END GENERATE ainit_no_port;


  ce_port : IF (c_has_ce=1) GENERATE
    ce_i <= ce;
  END GENERATE ce_port;
  ce_no_port : IF (c_has_ce/=1) GENERATE
    ce_i <= '1';
  END GENERATE ce_no_port;


  load_port : IF (c_has_load=1) GENERATE
    load_i <= load;
  END GENERATE load_port;
  load_no_port : IF (c_has_load/=1) GENERATE
    load_i <= '0';
  END GENERATE load_no_port;


  load_taps_port : IF (c_has_load_taps=1) GENERATE
    load_taps_i <= load_taps;
  END GENERATE load_taps_port;
  load_taps_no_port : IF (c_has_load_taps/=1) GENERATE
    load_taps_i <= '0';
  END GENERATE load_taps_no_port;


  pd_in_port : IF (c_has_pd_in=1) GENERATE
    pd_in_i <= pd_in;
  END GENERATE pd_in_port;
  pd_in_no_port : IF (c_has_pd_in/=1) GENERATE
    pd_in_i <= (OTHERS => '0');
  END GENERATE pd_in_no_port;


  sinit_port : IF (c_has_sinit=1) GENERATE
    sinit_i <= sinit;
  END GENERATE sinit_port;
  sinit_no_port : IF (c_has_sinit/=1) GENERATE
    sinit_i <= '0';
  END GENERATE sinit_no_port;


  sd_in_port : IF (c_has_sd_in=1) GENERATE
    sd_in_i <=sd_in;
  END GENERATE sd_in_port;
  sd_in_no_port : IF (c_has_sd_in/=1) GENERATE
    sd_in_i <= '0';
  END GENERATE sd_in_no_port;


  data_valid_port : IF (c_has_data_valid=1) GENERATE
    data_valid <=data_valid_i ;
  END GENERATE data_valid_port;
  data_valid_no_port : IF (c_has_data_valid/=1) GENERATE
    data_valid <= 'X';
  END GENERATE data_valid_no_port;

  term_cnt_port : IF (c_has_term_cnt=1) GENERATE
    term_cnt <= term_cnt_i;
  END GENERATE term_cnt_port;
  term_cnt_no_port : IF (c_has_term_cnt/=1) GENERATE
    term_cnt <= 'X';
  END GENERATE term_cnt_no_port;

  pd_out_port : IF (c_has_pd_out=1) GENERATE
    pd_out <= d;
  END GENERATE pd_out_port;
  sd_out_port : IF (c_has_sd_out=1) GENERATE
    sd_out <= d(c_size-1);
  END GENERATE sd_out_port;

  new_seed_port : IF (c_has_new_seed=1) GENERATE
    new_seed <=new_seed_i ;
  END GENERATE new_seed_port;
  new_seed_no_port : IF (c_has_new_seed/=1) GENERATE
    new_seed <= 'X';
  END GENERATE new_seed_no_port;
  
-------------------------------------------------------------------------------
-- Clock Process
-------------------------------------------------------------------------------

  fibonacci : IF c_type=0 GENERATE
    
    PROCESS (clk, ainit_i)
      VARIABLE d_v : std_logic := '0';
    BEGIN  -- PROCESS
      IF (ainit_i = '1') THEN                  -- asynchronous reset (active high)
        d <= str_to_slv_0(c_ainit_val, c_size);
        
      ELSIF (clk'event AND clk = '1') THEN  -- rising clock edge

        IF (sinit_i='1') THEN            --if sinit_i = 1

          d <= str_to_slv_0(c_sinit_val, c_size);

        ELSIF (ce_i = '1') THEN
          
          ------Calculate next-states for all bits except bit 0-----------------
          FOR reg_idx IN c_size-1 DOWNTO 1 LOOP
            IF c_has_load=1 AND c_has_pd_in=1 AND load_i='1' THEN
              d(reg_idx) <= pd_in(reg_idx);
            ELSE  
              d(reg_idx) <= d(reg_idx-1);
            END IF;
          END LOOP;  -- reg_idx

          ------Calculate the XOR of all the feedback values (where polynomial=1)
          d_v := '0';
          FOR reg_idx IN c_size-1 DOWNTO 0 LOOP
            IF (polybit(c_tap_pos, c_size, c_size-reg_idx-1)='1') THEN
              d_v := d_v XOR d(reg_idx);
            ELSE
              d_v := d_v;
            END IF;
          END LOOP;  -- reg_idx
          
          IF c_gate/=0 THEN
            d_v := NOT d_v;                 --convert XOR to XNOR
          END IF;
          
          IF c_has_load=1 AND load_i='1' THEN
            IF c_has_pd_in=1 THEN
              ------Parallel Load case for D0 bit            
              d(0) <= pd_in(0);
            ELSE
              ------Serial Load case for D0 bit
              d(0) <= sd_in;
            END IF;

            
          ELSE
            ------Normal case for D0 bit
            IF c_max_len_logic=1 THEN

              IF c_gate=0 THEN
                d(0) <= d_v XOR zerocheck_special(d,c_size);
              ELSE
                d(0) <= d_v XOR onecheck_special(d,c_size);
              END IF;

            ELSE

              d(0) <= d_v;

            END IF;                         --end c_max_len_logic

          END IF;                         --end load case

        END IF;                           --end sinit_i

      END IF;                             --end clk
    END PROCESS;

  END GENERATE fibonacci;


  

  galois : IF c_type/=0 GENERATE
    
    PROCESS (clk, ainit_i)
      VARIABLE feedback_v : std_logic := '0';
    BEGIN  -- PROCESS
      IF (ainit_i = '1') THEN                  -- asynchronous reset (active high)
        d <= str_to_slv_0(c_ainit_val, c_size);
      ELSIF (clk'event AND clk = '1') THEN  -- rising clock edge

        IF (sinit_i ='1') THEN                --if sinit_i = 1
          
          d <= str_to_slv_0(c_sinit_val, c_size);  

        ELSIF ( ce_i = '1') THEN

          ------Calculate feedback value-----------------------------------------------------------------
          IF c_max_len_logic=1 THEN
            IF c_gate=0 THEN
              feedback_v := d(c_size-1) XOR zerocheck_special(d,c_size);
            ELSE
              feedback_v := d(c_size-1) XOR onecheck_special(d,c_size);
            END IF;
          ELSE
            feedback_v := d(c_size-1);
          END IF;
          
          FOR reg_idx IN c_size-1 DOWNTO 1 LOOP
            
            IF c_has_load=1 AND load_i='1' THEN
              IF c_has_pd_in=1 THEN     --parallel load
                d(reg_idx) <= pd_in(reg_idx);
              ELSE                      --serial load
                d(reg_idx) <= d(reg_idx-1);
              END IF;
            ELSE  

              ------Normal
              IF c_gate=0 THEN
                IF polybit(c_tap_pos, c_size, reg_idx)='1' THEN
                  d(reg_idx) <= d(reg_idx-1) XOR feedback_v;
                ELSE
                  d(reg_idx) <= d(reg_idx-1);
                END IF;
              ELSE
                IF polybit(c_tap_pos, c_size, reg_idx)='1' THEN
                  d(reg_idx) <= NOT (d(reg_idx-1) XOR feedback_v);
                ELSE
                  d(reg_idx) <= d(reg_idx-1);
                END IF;
              END IF;
              
            END IF;
          END LOOP;  --end loop reg_idx

          --Bit D0
          IF c_has_load=1 AND load_i='1' THEN
            IF c_has_pd_in=1 THEN
              d(0) <= pd_in(0);
            ELSE
              IF c_has_sd_in=1 THEN
                d(0) <= sd_in;
              END IF;
            END IF;

          ELSE

            IF polybit(c_tap_pos, c_size, 0)='1' THEN
              d(0) <= feedback_v;
            ELSE
              IF c_gate=0 THEN
                d(0)<='0';
              ELSE
                d(0)<='1';
              END IF;
            END IF;
            
          END IF;

        END IF;                           --end sinit_i
        
      END IF;                             --end clk
    END PROCESS;
  END GENERATE galois;             
  

  term_cnt_proc : PROCESS (d)
  BEGIN  -- PROCESS term
    IF c_gate=0 THEN
      term_cnt_i <= zerocheck_special(d,c_size);
    ELSE
      term_cnt_i <= onecheck_special(d,c_size);
    END IF;
  END PROCESS term_cnt_proc;


  

  d_valid:  lfsr_v3_0_dvunit_bhv
    GENERIC MAP (
      c_size =>  c_size,
      c_load_type =>  load_type(c_has_pd_in, c_has_sd_in, c_type, c_has_load_taps, c_has_sd_out)
      )
    PORT MAP (
      load => load_i,
      clk => clk,
      ce => ce_i,
      ainit => ainit_i,
      sinit => sinit_i,
      new_seed => new_seed_i,
      data_valid => data_valid_i
      );
  


END behavioral ;




