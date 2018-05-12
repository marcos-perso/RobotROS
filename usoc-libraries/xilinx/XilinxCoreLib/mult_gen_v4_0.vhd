----------------------------------------------------------------------------
-- MULTIPLY COMPILER  :  VHDL Behavioral Model 
----------------------------------------------------------------------------
--
--    **************************
--    * Copyright Xilinx, Inc. *
--    * All rights reserved.   *
--    * March 3, 2000          *
--    **************************
--
----------------------------------------------------------------------------
-- Filename:  mult_gen_v4_0.vhd
--                                   
-- Description:  
--      This is the VHDL behavioral description of a Multiply Compiler
--      Core.  It simulates the the behavior of the entire core including each
--      of the following sub-cores:
--                                  0- lut based parallel
--                                  1- Virtex II parallel
--                                  2- parallel CCM
--                                  3- static RCCM
--                                  4- dynamic RCCM
----------------------------------------------------------------------------
-- Structure:
--    mult_gen_v4_0
----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library std;
use std.textio.all;

library xilinxcorelib;
use xilinxcorelib.prims_constants_v5_0.all;
use XilinxCoreLib.mult_const_pkg_v4_0.all;
use xilinxcorelib.mult_pkg_v4_0.all;

use XilinxCoreLib.mult_gen_v4_0_services.all;

----------------------------------------------------------------------------
-- PORT DECLARATION
----------------------------------------------------------------------------

entity mult_gen_v4_0 is
   generic (
      c_a_width         : integer := A_DEFAULT_WIDTH;
      -- vector width of operand A
      c_b_width         : integer := B_DEFAULT_WIDTH;
      -- vector width of operand B
      c_out_width       : integer := OUT_DEFAULT_WIDTH;
      -- vector width of the output
      c_has_q           : integer := DEFAULT_HAS_Q;
      -- generate a registered output- dout 
      c_has_o           : integer := DEFAULT_HAS_0;
      -- generate a non-registered output
      -- NOTE: core can produce both a
      -- registered and a non-registered
      -- output.
      c_reg_a_b_inputs  : integer := DEFAULT_REG_A_B_INPUTS;
      -- inputs A and B are registered
      c_a_type          : integer := DEFAULT_A_TYPE;
      -- determines whether the operand A
      -- is signed, unsigned
      c_b_type          : integer := DEFAULT_B_TYPE;
      -- determines whether the operand B
      -- is signed, unsigned
      c_b_constant      : integer := DEFAULT_CONSTANT_B;
      -- operand B is a constant
      c_b_value         : string  := DEFAULT_CONSTANT_B_VAL;
      -- value of operand B when constant
      c_has_aclr        : integer := DEFAULT_HAS_ACLR;
      -- generate an asynchronous clear
      c_has_sclr        : integer := DEFAULT_HAS_SCLR;
      -- generate a synchronous clear
      c_has_ce          : integer := DEFAULT_HAS_CE;
      -- generate a clock enable
      c_has_a_signed    : integer := DEFAULT_HAS_A_SIGNED;
      -- generate a signal to control the
      -- sign of operand A
      c_enable_rlocs    : integer := DEFAULT_ENABLE_RLOCS;
      -- enable relative placement
      c_has_loadb       : integer := DEFAULT_HAS_LOADB;
      -- generate a signal to control the
      -- loading of constant operand B
      c_mem_type        : integer := DEFAULT_MEM_TYPE;
      -- defines whether the multiplier
      -- implementation uses single port
      -- block mem, dual port block mem,
      -- distributed mem
      c_mult_type       : integer := DEFAULT_MULT_TYPE;
      -- determines which kind of multiplier
      -- to instantiate:
      -- 0- lut based parallel
      -- 1- Virtex II parallel
      -- 2- parallel CCM
      -- 3- static RCCM
      -- 4- dynamic RCCM
      c_baat            : integer := DEFAULT_BAAT;
      c_has_swapb       : integer := DEFAULT_HAS_SWAPB;
      -- generate a multiplier busy signal
      c_has_nd          : integer := DEFAULT_HAS_ND;
      -- generate a new data signal
      c_has_rdy         : integer := DEFAULT_HAS_RDY;
      -- generate a output ready signal
      c_has_rfd         : integer := DEFAULT_HAS_RFD;
      -- generate a ready for data signal
      c_pipeline        : integer := 0;  --DEFAULT_PIPELINED ;       
      c_sync_enable     : integer := DEFAULT_SYNC_ENABLE;
      c_has_load_done   : integer := DEFAULT_HAS_LOAD_DONE;
      -- signal is generated in GUI whenever
      c_output_hold     : integer := DEFAULT_OUTPUT_HOLD;
      c_sqm_type        : integer := 0;
      -- 0 = parallel input, 1 = serial input
      c_has_b           : integer := 1;
      -- generate a b input port (not used in behavioural model)
      c_stack_adders    : integer := 0;
      -- Placement (not used in behavioural model)
      bram_addr_width   : integer := 8;
      -- Block RAM address width. 8 in virtex, 9 in virtex2
      c_mem_init_prefix : string  := "mem";
      c_standalone      : integer := 0;
      -- Prefix for the memory initialisation file.
      c_use_luts        : integer := 1
      -- 1 if using LUT based parallel multiplier, 0 if 
      -- using the virtex2 multiplier blocks. (Ignored by behavioural model)
      );
   port (
      clk : in  std_logic := '0';  -- clk must be present for all non-
                                   -- combinatorial implementation
                                   -- (i.e. if c_has_pipeline = 1)
      
      a   : in  std_logic_vector(((c_a_width-1)-((c_a_width-1)*c_sqm_type)) downto 0)
         := (others => '0');
      -- operand A
      b   : in  std_logic_vector(c_b_width-1 downto 0) := (others => '0');
      -- operand B
      o   : out std_logic_vector(c_out_width-1 downto 0) := (others => '0');
      -- non-registered output
      q   : out std_logic_vector(c_out_width-1 downto 0);
      -- registered output
      a_signed : in  std_logic := '0';
                                        -- determines the sign of operand A
                                        -- dynamically. (1 = signed) 
      loadb    : in  std_logic := '0';
                                        -- load operand B is used to reload
                                        -- the coefficient mem, active high-
                                        -- used when B is a constant that is
                                        -- reloadable.
      load_done : out std_logic;
                                        -- indicates that the mult. has
                                        -- finished reloading the new operand
                                        -- B into memory.
      swapb     : in  std_logic := '0';
                                        -- causes the multiplier to use the
                                        -- latest loaded B value.
      ce        : in  std_logic := '0';
      -- clock enable
      aclr      : in  std_logic := '0';
      -- asynchronous clear
      sclr      : in  std_logic := '0';  -- synchronous clear
      rfd       : out std_logic;        -- ready for data- signals that the
                                        -- multiplier can accept and process
                                        -- new operands
      nd        : in  std_logic                                                             := '1';  -- new data- signals that operands A
                                                                                                     -- or B have new data.
      rdy       : out std_logic         -- output ready- indicates that the
                                        -- output is valid.
      );
end mult_gen_v4_0;


architecture behavioral of mult_gen_v4_0 is

----------------------------------------------------------------------------
-- FUNCTIONS
----------------------------------------------------------------------------

   -- This function calculates the output width of the multiplier.
   -- For the unreloadable ccm this is caluculated by taking the maximum possible 
   -- a value and multiplying it by the constant. For the two input multipliers it
   -- is simply the a width plus the b width.
   -- The sequential is slightly different and the output width calculation ignores 
   -- the type of multiplier that is instantiated in the sqm.
   function find_ccm_out_width (bin : std_logic_vector; non_ccm_width : integer; a_width : integer) return integer is
      variable ccm_max_a_val             : std_logic_vector(a_width-1 downto 0);
      variable max_result                : std_logic_vector((a_width+bin'length)-1 downto 0);
      variable max_result_negated        : std_logic_vector((a_width+bin'length)-1 downto 0);
      variable ccm_output_width          : integer;
      variable ccm_negative_output_width : integer;
      variable index                     : integer;
      variable cin                       : std_logic;
      variable value                     : std_logic;
      variable b_in                      : std_logic_vector((bin'length-1) downto 0) := bin;
      variable a_signed                  : integer                                   := 0;
      variable a_negative                : integer                                   := 0;
      variable b_negative                : integer                                   := 0;
   begin
      ccm_output_width          := 0;
      ccm_negative_output_width := 0;
      if (c_mult_type = 2 and anyX(bin)) then
         return non_ccm_width;
      end if;
      if (c_a_type = c_signed and not(c_baat < c_a_width)) then
         ccm_max_a_val            := (others => '0');
         ccm_max_a_val(a_width-1) := '1';
         a_negative               := 1;
      else
         ccm_max_a_val := (others => '1');
         a_negative    := 0;
      end if;
      max_result         := (others => '0');
      max_result_negated := (others => '0');
      if (c_b_type = c_signed and (bin(bin'length-1) = '1')) then
         b_in       := two_comp(bin);
         b_negative := 1;
      end if;
      for i in 0 to (b_in'length-1) loop
         if (b_in(i) = '1') then
            index := i;
            cin   := '0';
            for j in 0 to a_width-1 loop   -- add a to prod 
               value := max_result(index) xor ccm_max_a_val(j) xor cin;  -- sum
               cin   := (max_result(index) and ccm_max_a_val(j)) or (max_result(index) and cin) or
                        (ccm_max_a_val(j) and cin);            -- carry
               max_result(index) := value;
               index             := index + 1;
            end loop;
            max_result(index) := max_result(index) xor cin;  -- last carry 
         else
            cin := '0';
         end if;
      end loop;
      for i in 0 to (max_result'length-1) loop
         if (max_result(i) = '1') then
            ccm_output_width := i+1;
         end if;
      end loop;
      if (a_negative = 1 and b_negative = 1) then
         ccm_output_width := ccm_output_width + 1;
      elsif ((a_negative = 1 and b_negative = 0) or (a_negative = 0 and b_negative = 1)) then
         max_result_negated := two_comp(max_result);
         for i in 0 to ccm_output_width-1 loop
            if(max_result_negated(i) = '0') then
               ccm_negative_output_width := i + 2;
            end if;
         end loop;
         ccm_output_width := ccm_negative_output_width;
      end if;
      -- This is the code for calculating the sequential multiplier output width.
      -- Throughout the code the sequential multiplier is indicated by the value of 
      -- c_baat being less than the value of c_a_width. This indicates that the 
      -- number of bits at a time is less than the a width and so the multiplication 
      -- must be carried out sequentially.
      if (c_baat < c_a_width) then
         if (c_a_type = c_signed or c_has_a_signed = 1) then
            a_signed := 1;
         else
            a_signed := 0;
         end if;
         if (bin'length = 1) then
            if (c_b_type = c_signed) then  --dlunn added here 2/11/2000
               return c_baat + 1;
            else
               return c_baat + a_signed;
            end if;
         elsif (bin'length = 2 and c_b_type = c_signed and c_mult_type > 1) then
            return c_baat + 2;
         elsif (bin'length = 2 and c_b_type = c_signed and c_mult_type < 2) then
            return c_baat + 2;
         else
            if (c_b_type = c_unsigned) then
               return non_ccm_width + a_signed;
            else
               return non_ccm_width;
            end if;
         end if;
      elsif (c_mult_type > 1) and (c_has_loadb = 0) then
         --if (((c_b_type = c_signed) or (c_a_type = c_signed or c_has_a_signed=1)) and not(c_b_type = c_unsigned and c_a_type = c_signed)) then 
         if(bin'length = 1 and c_b_type = c_unsigned and bin(bin'high) = '1') then
            ccm_output_width := a_width;
         elsif (c_has_a_signed = 1 and c_b_type = c_unsigned) then
            ccm_output_width := ccm_output_width + 1;
         else
            ccm_output_width := ccm_output_width;
         end if;
         return ccm_output_width;
      else
         if (c_has_a_signed = 1) and (c_b_type = c_unsigned) then
            return non_ccm_width + 1;
         else
            return non_ccm_width;
         end if;
      end if;
   end find_ccm_out_width;

   function find_actual_a_width(a_width : integer)
      return integer is
   begin
      if (c_has_a_signed = 1) then
         return a_width+1;
      else
         return a_width;
      end if;
   end find_actual_a_width;

   function find_b_width(ccm_b_width, non_ccm_b_width, mult_type : integer)
      return integer is
   begin
      if (mult_type < 2) then
         return non_ccm_b_width;
      else
         return ccm_b_width;
      end if;
   end find_b_width;

-- Muliplier function that handles all signed/unsigned combinations and
-- correctly handles when any of the input bits are an 'X'.
   function mult(a, b : std_logic_vector; a_sign : std_logic; sign, out_width : integer)
      return std_logic_vector is
      constant a_width                      : integer                              := a'length;
      constant b_width                      : integer                              := b'length;
      variable la                           : std_logic_vector(a_width-1 downto 0) := a;
      variable lb                           : std_logic_vector(b_width-1 downto 0) := b;
      variable lsigna                       : std_logic;
      constant ccm_out_width                : integer                              := find_ccm_out_width(b, (a_width + b_width), a_width);
      variable product                      : std_logic_vector((ccm_out_width-1) downto 0);
      variable negative                     : boolean;
      variable a_value, b_value, prod_value : integer;
      variable index                        : integer;
      variable cin, value                   : std_logic;
      constant diff                         : integer                              := ccm_out_width - out_width;
      variable product_o                    : std_logic_vector(out_width-1 downto 0);
      variable a_type                       : integer;
   begin
      if (sign = c_signed) then
         lsigna := a_sign;
      else
         lsigna := '0';
      end if;
      if (sign = c_signed and c_a_type = c_signed) then
         a_type := c_signed;
      else
         a_type := c_unsigned;
      end if;
      if (all0(la) or all0(lb)) and (c_mult_type = 2 or c_mult_type = 0) then
         product := (others => '0');
      elsif (c_mult_type = 2 or c_mult_type = 0) and (a_width > out_width) and (all0(la((a_width-1) downto (a_width-out_width)))) and not((c_b_type = c_signed) and ((lb(b_width-1) = '1') or (lb(b_width-1) = 'X') or (lb(b_width-1) = 'U'))) then
         product := (others => '0');
      elsif (c_mult_type = 2 or c_mult_type = 0) and (b_width > out_width) and ((all0(lb((b_width-1) downto (b_width-out_width)))) and not((c_a_type = c_signed and c_has_a_signed = 0 and (la(a_width-1) = '1' or la(a_width-1) = 'X')) or (c_has_a_signed = 1 and lsigna = '1' and (la(a_width-1) = '1' or la(a_width-1) = 'X' or la(a_width -1) = 'U')))) then
         product := (others => '0');
      elsif (anyX(la) or anyX(lb) or (c_has_a_signed = 1 and sign = c_signed and lsigna = 'X')) then
         product := (others => 'X');
      else
         negative := false;
         if (c_b_type = c_unsigned) then
            if ((c_has_a_signed = 0 and a_type = c_signed and (la(a_width-1) = '1')) or
                (c_has_a_signed = 1 and lsigna = '1' and (la(a_width-1) = '1'))) then
               negative := true;
            end if;
         elsif (c_has_a_signed = 0 and a_type = c_unsigned) or
            (c_has_a_signed = 1 and lsigna = '0') then
            if (c_b_type = c_signed and (lb(b_width-1) = '1')) then
               negative := true;
            end if;
         elsif (c_b_type = c_signed and (
            ((c_has_a_signed = 0 and a_type = c_signed) or
             (c_has_a_signed = 1 and lsigna = '1')))) then
            if ((la(a_width-1) = '0') and (lb(b_width-1) = '1')) or
               ((la(a_width-1) = '1') and (lb(b_width-1) = '0')) then
               negative := true;
            end if;
         end if;
         if (((c_has_a_signed = 0 and a_type = c_signed and (la(a_width-1) = '1')) or
              (c_has_a_signed = 1 and lsigna = '1' and (la(a_width-1) = '1')))) then
            la := two_comp(la);
         end if;
         if ((c_b_type = c_signed and (lb(b_width-1) = '1'))) then
            lb := two_comp(lb);
         end if;
         product := (others => '0');
         for i in 0 to b_width -1 loop  -- b width
            if (lb(i) = '1') then
               index := i;
               cin   := '0';
               for j in 0 to a_width-1 loop  -- add a to prod 
                  if index < ccm_out_width then
                     value := product(index) xor la(j) xor cin;  -- sum
                     cin   := (product(index) and la(j)) or (product(index) and cin) or
                            (la(j) and cin);                     -- carry
                     product(index) := value;
                     index          := index + 1;
                  end if;
               end loop;
               if index < ccm_out_width then
                  product(index) := product(index) xor cin;      -- last carry 
               end if;
            else
               cin := '0';
            end if;
         end loop;
         if (negative) then
            product := two_comp(product);
         end if;
      end if;
      if (out_width < ccm_out_width) then
         for i in 0 to out_width-1 loop
            product_o(i) := product(i+diff);
         end loop;  -- n
      elsif (out_width > ccm_out_width) then
         product_o(ccm_out_width-1 downto 0) := product;
         for i in ccm_out_width to out_width-1 loop
            if(b_width > 1) then
               if (((a_type = c_signed and c_has_a_signed = 0) or c_b_type = c_signed or (c_has_a_signed = 1 and lsigna = '1')) and ccm_out_width /= 0) then
                  --if (c_has_a_signed = 1 and c_b_type = c_unsigned) then
                  product_o(i) := product(ccm_out_width-1);
               else product_o(i) := '0';
               end if;
            else
               if negative and (((a_type = c_signed and c_has_a_signed = 0) or c_b_type = c_signed or (c_has_a_signed = 1 and lsigna = '1')) and ccm_out_width /= 0) then
                  product_o(i) := '1';
               else product_o(i) := '0';
               end if;
            end if;
         end loop;
      else product_o := product;
           return product_o;
      end if;
      return product_o;
   end mult;

   -- These are wee helper functions.
   function max (a, b : integer) return integer is
      variable maximum_value : integer := 0;
   begin
      if (a >= b) then
         maximum_value := a;
      else
         maximum_value := b;
      end if;
      return maximum_value;
   end max;

   function inc_if_sig (a_type, a_sign : integer) return integer is
      variable return_value : integer := 0;
   begin
      if ((a_type = 0 or a_sign = 1) and c_b_type = 1) then return_value := 1;
      else return_value                                                  := 0;
      end if;
      return return_value;
   end inc_if_sig;

   function inc_if_no_sign (a_type, b_type : integer) return integer is
      variable return_value : integer := 0;
   begin
      if ((a_type = c_unsigned and b_type = c_unsigned)) then return_value := 1;
      else return_value                                                    := 0;
      end if;
      return return_value;
   end inc_if_no_sign;

   function inc_if_sign (a_type, b_type : integer) return integer is
      variable return_value : integer := 0;
   begin
      if ((a_type = c_unsigned and b_type = c_unsigned)) then return_value := 0;
      else return_value                                                    := 1;
      end if;
      return return_value;
   end inc_if_sign;

   function inc_baat (baat : integer) return integer is
   begin
      if (baat > 1 or c_mult_type /= 2) then return 1;
      else return 0;
      end if;
   end inc_baat;

   function inc_if_serial (mult_type, sqm_type : integer) return integer is
   begin
      if (mult_type > 1 and sqm_type = 1) then return 1;
      else return 0;
      end if;
   end inc_if_serial;

   function has_a_sign (has_a_signed, a_type, baat, a_width : integer) return integer is
   begin
      if ((has_a_signed = 1 or a_type = c_signed) and (baat < a_width)) then
         return 1;
      else
         return has_a_signed;
      end if;
   end has_a_sign;

   --Sets the b value for a constant co-efficient multiplier.
   function set_b_value return std_logic_vector is
      variable b_tmp   : std_logic_vector(c_b_width-1 downto 0);
      variable ret_val : std_logic_vector((find_ccm_b_width(str_to_slv(c_b_value, c_b_width), c_b_width, c_mult_type, c_has_loadb)-1) downto 0);
      variable msb     : integer := 0;
   begin
      if (c_mult_type > 1) then
         b_tmp := str_to_slv(c_b_value, c_b_width);
         if(c_b_type = c_signed and c_has_loadb = 1 and c_b_value(1) = '1') then
            for i in c_b_width-1 downto 0 loop
               if (b_tmp(i) = '1') then
                  msb := i;
                  exit;
               end if;
            end loop;
            for i in msb to c_b_width-1 loop
               b_tmp(i) := '1';
            end loop;
            ret_val := b_tmp;
         elsif (c_has_loadb = 1) then
            ret_val := b_tmp;
         else
            ret_val := str_to_slv(c_b_value, find_ccm_b_width(b_tmp, c_b_width, c_mult_type, c_has_loadb));
         end if;
         return ret_val;
      else
         return b_tmp;
      end if;
   end set_b_value;

----------------------------------------------------------------------------
-- SIGNAL DECLARATION
----------------------------------------------------------------------------

   signal b_input : std_logic_vector((find_ccm_b_width(str_to_slv(c_b_value, c_b_width), c_b_width, c_mult_type, c_has_loadb)-1) downto 0) := set_b_value;
   signal bconst0 : std_logic_vector((find_ccm_b_width(str_to_slv(c_b_value, c_b_width), c_b_width, c_mult_type, c_has_loadb)-1) downto 0) := set_b_value;
   signal bconst1 : std_logic_vector((find_ccm_b_width(str_to_slv(c_b_value, c_b_width), c_b_width, c_mult_type, c_has_loadb)-1) downto 0) := set_b_value;

   constant out_size : integer := find_ccm_out_width(set_b_value, c_baat+c_b_width, c_baat);

   signal full_out_size : integer := find_ccm_out_width(set_b_value, c_a_width+c_b_width, c_a_width);

   constant ccm_b_width    : integer := select_val(bitstorep_string(c_b_value, c_b_type), c_b_width, c_has_loadb /= 0);
   constant real_a_width   : integer := (c_a_width-1) - ((c_a_width-1)*c_sqm_type) + 1;
   constant b_is_0         : boolean := b_input'length = 1 and set_b_value(0) = '0' and c_mult_type = 2;
   constant rom_addr_width : integer := get_rom_addr_width(c_mem_type, bram_addr_width);
   constant a_input_width  : integer := calc_a_input_width(real_a_width, c_has_a_signed, rom_addr_width, c_baat, c_has_loadb);
   constant need_addsub    : boolean := c_has_loadb = 1 and (c_a_type /= c_unsigned or c_has_a_signed /= 0);
   constant ccm_num_pps    : integer := calc_num_pps(a_input_width, rom_addr_width);

   constant shift_bits         : integer := select_val(calc_shift_bits(c_b_value, c_b_constant, c_b_type), 0, c_mult_type /= 2);
   constant actual_ccm_b_width : integer := select_val((ccm_b_width - shift_bits), c_b_width, c_has_loadb /= 0);
   constant actual_b_width     : integer := find_b_width(actual_ccm_b_width, c_b_width, c_mult_type);

   constant a_sig : integer := has_a_sign(c_has_a_signed, c_a_type, c_baat, c_a_width);
    type     multiplier_stages is array (0 to ((calc_latency(c_a_width, actual_b_width, c_b_type, a_sig, c_reg_a_b_inputs, c_mem_type, c_pipeline, c_mult_type, c_has_loadb, c_baat, c_b_value, c_a_type, c_has_swapb, c_sqm_type, bram_addr_width)))) of
       std_logic_vector((c_out_width-1) downto 0);

--     type     multiplier_stages is array (0 to ((get_mult_gen_v4_0_latency(c_a_width, actual_b_width, c_b_type, a_sig, c_reg_a_b_inputs, c_mem_type, c_pipeline, c_mult_type, c_has_loadb, c_baat, c_b_value, c_a_type, c_has_swapb, c_sqm_type, bram_addr_width)))) of
--        std_logic_vector((c_out_width-1) downto 0);

   signal regND          : std_logic;
   signal clk_i          : std_logic;
   signal last_clk       : std_logic                                                                                                                                                                                                                        := '0';
   signal ce_i           : std_logic;
   signal aclr_i         : std_logic;
   signal sclr_i         : std_logic;
   signal nd_i           : std_logic                                                                                                                                                                                                                        := '0';
   signal nd_q           : std_logic                                                                                                                                                                                                                        := '0';
   signal nd_int         : std_logic;
   signal loadb_i        : std_logic;
   signal loadb_q        : std_logic;
   signal loadb_int      : std_logic;
   signal load_done_i    : std_logic                                                                                                                                                                                                                        := '1';
   signal load_done_q    : std_logic                                                                                                                                                                                                                        := '1';
   signal swapb_i        : std_logic;
   signal swapb_q        : std_logic;
   signal bank_sel       : std_logic                                                                                                                                                                                                                        := '0';
   signal loadb_count    : integer;
   signal new_data       : std_logic                                                                                                                                                                                                                        := '0';
   signal rfd_i          : std_logic                                                                                                                                                                                                                        := '1';
   signal rfd_f          : std_logic                                                                                                                                                                                                                        := '1';
   signal rfd_q          : std_logic                                                                                                                                                                                                                        := '1';
   signal rfd_q_seq      : std_logic                                                                                                                                                                                                                        := '1';
   signal ready_for_data : std_logic                                                                                                                                                                                                                        := '1';
   signal rdy_i          : std_logic                                                                                                                                                                                                                        := '0';
   signal rdy_q          : std_logic                                                                                                                                                                                                                        := '0';
   signal ld_i           : std_logic;
   signal asign_i        : std_logic;
   signal asign_q        : std_logic;
   signal asign_int      : std_logic;
   signal seq_ready      : std_logic                                                                                                                                                                                                                        := '0';
   signal sub_rdy        : std_logic_vector((calc_latency(c_a_width, actual_b_width, c_b_type, a_sig, c_reg_a_b_inputs, c_mem_type, c_pipeline, c_mult_type, c_has_loadb, c_baat, c_b_value, c_a_type, c_has_swapb, c_sqm_type, bram_addr_width)) downto 0) := (others => '0');
   signal a_i            : std_logic_vector((real_a_width-1) downto 0);
   signal dina_q         : std_logic_vector((real_a_width-1) downto 0)                                                                                                                                                                                      := (others => '0');
   signal dinb_q         : std_logic_vector((find_ccm_b_width(str_to_slv(c_b_value, c_b_width), c_b_width, c_mult_type, c_has_loadb)-1) downto 0)                                                                                                           := (others => '0');
   signal dina_int       : std_logic_vector((real_a_width-1) downto 0);
   signal dinb_int       : std_logic_vector((find_ccm_b_width(str_to_slv(c_b_value, c_b_width), c_b_width, c_mult_type, c_has_loadb)-1) downto 0);
   signal dina_seq       : std_logic_vector((real_a_width-1) downto 0);
   signal dinb_seq       : std_logic_vector((find_ccm_b_width(str_to_slv(c_b_value, c_b_width), c_b_width, c_mult_type, c_has_loadb)-1) downto 0);
   signal din_a_seq      : std_logic_vector((c_baat-1) downto 0);
   signal din_b_seq      : std_logic_vector((find_ccm_b_width(str_to_slv(c_b_value, c_b_width), c_b_width, c_mult_type, c_has_loadb)-1) downto 0)                                                                                                           := set_b_value;
   signal load_b_value   : std_logic_vector((find_ccm_b_width(str_to_slv(c_b_value, c_b_width), c_b_width, c_mult_type, c_has_loadb)-1) downto 0);

   signal product_i     : std_logic_vector((c_out_width-1) downto 0) := (others => '0');
   signal product_f     : std_logic_vector((c_out_width-1) downto 0) := (others => '0');
   signal temp1         : std_logic_vector((c_out_width-1) downto 0);
   signal sub_product   : multiplier_stages                          := (others => (others => '0'));
   signal sub_product_o : multiplier_stages                          := (others => (others => '0'));
   signal product       : std_logic_vector((c_out_width-1) downto 0) := (others => '0');
   signal product_o     : std_logic_vector((c_out_width-1) downto 0) := (others => '0');
   signal product_out   : std_logic_vector((c_out_width-1) downto 0);
   signal q_i           : std_logic_vector((c_out_width-1) downto 0) := (others => '0');

   constant no_of_cycles : integer := find_no_of_cycles(c_a_width, c_baat, c_mult_type);

   signal padding              : integer := (c_baat * (no_of_cycles-1)) - c_a_width;
   signal cycle                : integer := no_of_cycles+1;  --1;
   signal loading              : integer := 0;
   signal sign_this_cycle      : integer := 0;
   signal mult_sign_this_cycle : integer := 0;
   signal stored_asign         : std_logic;
   signal increment            : integer := 0;

   constant no_sign : integer := inc_if_no_sign(c_a_type, c_b_type);

   signal not_loaded       : integer := 1;
   signal inc_baat_1       : integer := inc_baat(c_baat);
   signal new_data_present : integer := 0;
   signal c_latency        : integer := calc_latency(c_a_width, actual_b_width, c_b_type, a_sig, c_reg_a_b_inputs, c_mem_type, c_pipeline, c_mult_type, c_has_loadb, c_baat, c_b_value, c_a_type, c_has_swapb, c_sqm_type, bram_addr_width);

   constant mult_length : integer := calc_latency(c_a_width, actual_b_width, c_b_type, a_sig, 0, c_mem_type, c_pipeline, c_mult_type, c_has_loadb, 1, c_b_value, c_a_type, c_has_swapb, c_sqm_type, bram_addr_width) - 1;

   constant ccm_serial : integer := inc_if_serial(c_mult_type, c_sqm_type);

   signal rfd_f_pipe : std_logic_vector((1 + c_reg_a_b_inputs - ccm_serial) downto 0) := (others => '1');
   type   sub_mult is array (0 to calc_latency(c_a_width, actual_b_width, c_b_type, a_sig, 0, c_mem_type, c_pipeline, c_mult_type, c_has_loadb, 1, c_b_value, c_a_type, c_has_swapb, c_sqm_type, bram_addr_width) - 1) of
      std_logic_vector (out_size-no_sign downto 0);
   signal started : std_logic := '0';


   signal intRFD_delay : std_logic_vector((no_of_cycles-c_reg_a_b_inputs-1) downto 0) := (others => '0');
   signal intRFD_noreg : std_logic                                                    := '0';
   signal intRFD       : std_logic                                                    := '1';
   signal regRFD       : std_logic                                                    := '0';
   signal intND        : std_logic                                                    := '0';

   signal swapb_pipe : std_logic_vector(1 downto 0) := (others => '0');
   signal ld_pipe    : std_logic_vector(1 downto 0) := (others => '0');
   signal nd_q_tmp   : std_logic;

----------------------------------------------------------------------------
-- COMPONENT DECLARATION
---------------------------------------------------------------------------- 

begin

----------------------------------------------------------------------------
-- COMPONENT INSTANTIATION
---------------------------------------------------------------------------- 

----------------------------------------------------------------------------
-- PROCESS DECLARATION
---------------------------------------------------------------------------- 

   -- This just makes sure that the parameters are valid.
   check_inputs : process
   begin
      if (c_baat = c_a_width) then
         if (c_latency = 0) and (c_reg_a_b_inputs = 0) and (c_has_q = 0) then
            if (c_has_ce = 1) or (c_has_aclr = 1) or (c_has_sclr = 1) then
               assert false
                  report "No registers yet one or more register control signals are selected" severity warning;
            end if;
         end if;
         if (c_has_loadb = 1) or (c_has_swapb = 1) then
            if (c_mult_type < 2) then
               assert false
                  report "A parallel multiplier has no need for a load or a swapb" severity warning;
            end if;
         end if;
      end if;
      if ((c_has_a_signed = 1) or (c_a_type = c_signed)) and (c_a_width = 1) then
         assert false
            report "Cannot have a 1 bit signed value (A Port)" severity warning;
      end if;
      if (c_b_type = c_signed) and (c_b_width = 1) then
         assert false
            report "Cannot have a 1 bit signed value (B Port)" severity warning;
      end if;
      if (c_b_constant = 1) and (c_mult_type < 2) then
         assert false
            report "The multiplier type is not compatible with a constant B input" severity warning;
      end if;
      wait;
   end process check_inputs;

   -- Purpose : Generate Control Signals using IP variables.
   -- Type    : Combinational
   generate_inputs : process (clk, a, aclr, sclr, ce, nd, rfd_i, b, swapb, loadb, a_signed, load_done_i)
   begin  -- process generate_inputs
      if (c_reg_a_b_inputs = 1 or c_has_q = 1 or c_latency > 0 or c_has_loadb = 1 or c_baat < c_a_width) then
         clk_i <= clk;
      else
         clk_i <= '0';
      end if;
      a_i <= a;
      if (c_has_aclr = 1) and not(c_baat = c_a_width and c_latency = 0 and c_reg_a_b_inputs = 0 and c_has_q = 0) then
         aclr_i <= aclr;
      else
         aclr_i <= '0';
      end if;
      if (c_has_sclr = 1) and not(c_baat = c_a_width and c_latency = 0 and c_reg_a_b_inputs = 0 and c_has_q = 0) then
         sclr_i <= sclr;
      else
         sclr_i <= '0';
      end if;
      if (c_has_ce = 1) and not(c_baat = c_a_width and c_has_q = 0 and c_latency = 0 and c_reg_a_b_inputs = 0 and c_has_loadb = 0) then
         ce_i <= ce;
      else
         ce_i <= '1';
      end if;
      if (c_has_nd = 1) then
         nd_i <= nd;
      else
         nd_i <= '1';
      end if;
      if (c_has_loadb = 1) then
         loadb_i <= loadb;
      else
         loadb_i <= '0';
      end if;
      if (c_has_swapb = 1) then
         swapb_i <= swapb;
      else
         swapb_i <= '0';
      end if;
      if (c_has_a_signed = 1) then
         asign_i <= a_signed;
      else
         asign_i <= '1';
      end if;
   end process generate_inputs;

   -- Purpose : Register Inputs => a, b, nd.  Generate 'Ready for Data'- rfd.
   --           For the non-sequential case rfd_i is always '1' unless there is a aclr
   --           ,sclr or loadb. This signal is fed to the rfd output. For the sequential 
   --           multiplier the intRFD signal is used.
   -- Type    : Sequential
   register_inputs : process (clk_i, aclr_i, sclr_i, swapb_i, rfd_f)
   begin  -- process register_inputs
      if (aclr_i'event and aclr_i = '1') then
         dina_q   <= (others => '0');
         dinb_q   <= (others => '0');
         dina_seq <= (others => '0');
         dinb_seq <= (others => '0');
         nd_q     <= '0';
         loadb_q  <= '0';
         intRFD   <= '0';
         regRFD   <= '0';
         rfd_i    <= '0';
         swapb_q  <= '0';
         regND    <= '0';
         nd_q_tmp <= '0';
      elsif (c_baat < c_a_width and ((swapb_i'event and swapb_i = '1') or (rfd_f'event and rfd_f = '0'))) then
         intRFD <= '0';
         rfd_i  <= '0';
      elsif (sclr_i'event and sclr_i = '1') then
         intRFD <= '0';
         rfd_i  <= '0';
      elsif (aclr_i'event and aclr_i = '0') or (c_baat < c_a_width and ((swapb_i'event and swapb_i = '0') or (rfd_f'event and rfd_f = '1'))) then
         intRFD <= '1';
         rfd_i  <= '1';
      elsif (sclr_i'event and sclr_i = '0') then
         intRFD <= '1';
         rfd_i  <= '1';
      elsif (clk_i'event and clk_i = '1' and aclr_i = '0') then
         if (sclr_i = '1') then
            dina_q   <= (others => '0');
            dinb_q   <= (others => '0');
            dina_seq <= (others => '0');
            dinb_seq <= (others => '0');
            nd_q     <= '0';
            loadb_q  <= '0';
            intRFD   <= '0';
            regRFD   <= '0';
            swapb_q  <= '0';
            regND    <= '0';
            nd_q_tmp <= '0';
         elsif ((rfd_f = '0') and c_baat < c_a_width) then
            intRFD <= '0';
            regRFD <= '0';
         elsif (ce_i = '1') then
            dina_q  <= a_i;
            dinb_q  <= b_input;
            nd_q    <= nd_i;
            asign_q <= asign_i;
            loadb_q <= loadb_i;
            regRFD  <= intRFD;
            intRFD  <= intRFD_noreg and not swapb_i;
            swapb_q <= swapb_i;
            regND   <= intND;
            nd_q_tmp <= nd_i;
         elsif (ce_i = '1') and (nd_i = '0') then
            nd_q <= '0';
         else
            nd_q_tmp <= nd_i;
         end if;
      end if;
      
   end process register_inputs;

   -- In a sequential multiplier with a signed a input the input to the multiplier is only signed 
   -- on the last cycle (cycle = no_of_cycles). This generates the multiplier sign (sign_this_cycle). 
   -- mult_sign_this_cycle is no longer used and should have been removed.
   calc_sign : process (cycle)
   begin
      if (c_baat < c_a_width) then
         if ((c_a_type = c_signed) or (c_has_a_signed = 1 and stored_asign = '1')) and (cycle < no_of_cycles) and swapb_pipe(1) = '0' then
            sign_this_cycle <= c_unsigned;
         elsif ((c_a_type = c_signed) or (c_has_a_signed = 1 and stored_asign = '1')) and (cycle = no_of_cycles) and swapb_pipe(1) = '0' then
            sign_this_cycle <= c_signed;
         else
            sign_this_cycle <= c_unsigned;
         end if;
         if ((c_a_type = c_signed) or (c_has_a_signed = 1 and stored_asign = '1')) and (cycle < no_of_cycles-mult_length) then
            mult_sign_this_cycle <= c_unsigned;
         elsif ((c_a_type = c_signed) or (c_has_a_signed = 1 and stored_asign = '1')) and (cycle = no_of_cycles-mult_length) then
            mult_sign_this_cycle <= c_signed;
         else
            mult_sign_this_cycle <= c_unsigned;
         end if;
      end if;
   end process calc_sign;

   -- This generates the signal that indicates that the sequential multiplier is ready for data.
   rfd_gen : process (intRFD, regRFD)
   begin
      if (c_reg_a_b_inputs = 1) then
         ready_for_data <= regRFD;
      else
         ready_for_data <= intRFD;
      end if;
   end process rfd_gen;

   -- intRFD_noreg is the signal that intRFD (the sequential multiplier's ready for data signal) is
   -- generated from. 
   rfd_gen2 : process (clk_i, aclr_i, nd_i, intRFD, intRFD_delay(0))
   begin
      if (c_a_width > c_baat) then
         if ((no_of_cycles-1) > 2 and aclr_i = '0' and sclr_i = '0' and swapb_i = '0' and rfd_f = '1') then
            if (c_has_nd = 1) then
               intRFD_noreg <= (intRFD_delay(0) and not intRFD) or (intRFD and not nd_i);
            else
               intRFD_noreg <= (intRFD_delay(0) and not intRFD);
            end if;
         elsif ((no_of_cycles-1) = 2 and aclr_i = '0' and sclr_i = '0' and swapb_i = '0' and rfd_f = '1') then
            if (c_has_nd = 1) then
               intRFD_noreg <= (not intRFD) or (intRFD and not nd_i);
            else
               intRFD_noreg <= not intRFD;
            end if;
         end if;
      else
         intRFD_noreg <= '1';
      end if;
   end process rfd_gen2;

   -- The new data signal is only fed to the circuit when the sequential multiplier is ready for 
   -- data and the multiplier is not reloading or swapping. If there is no ND present then the 
   -- rfd is used.
   ndgen : process (nd_i, nd_q, intRFD, regRFD)
   begin
      if (c_reg_a_b_inputs = 1 and c_has_nd = 1) then
         intND <= nd_q and regRFD and not swapb_i;
      elsif (c_reg_a_b_inputs = 1 and c_has_nd = 0) then
         intND <= regRFD and not swapb_i;
      elsif (c_reg_a_b_inputs = 0 and c_has_nd = 1) then
         intND <= nd_i and intRFD and not swapb_i;
      elsif (c_reg_a_b_inputs = 0 and c_has_nd = 0) then
         intND <= intRFD and not swapb_i;
      end if;
   end process ndgen;

   lastclkgen : process (clk_i)
   begin
      if (clk_i'event and clk_i = '1') then
         last_clk <= '1';
      end if;
   end process lastclkgen;

   -- Purpose : Split up the A input for the sequential multiplier. 
   -- The a input is split into sections. This process calculates the inputs to the multiplier 
   -- within the sequential multiplier, din_a_seq, din_b_seq and stored_asign.
   split_inputs : process(a_i, aclr_i, sclr_i, intND, dina_q, dinb_q, clk_i, ready_for_data, b_input)
      variable a_int  : std_logic_vector ((c_a_width-1) downto 0);
      variable a_nded : std_logic_vector ((c_a_width-1) downto 0);
      variable a_sign : std_logic;
      variable ready  : std_logic := '1';
   begin

      if (c_baat < c_a_width) then

        -- if c_baat and c_a_width are not the same, then this must
        -- be a sequential multiplier
        -- for other multipliers this process is meaningless

         if (aclr_i = '1') or (sclr_i = '1') then
         -- ** fix rdy problem 
            cycle <= no_of_cycles + 1;
         -- **
            new_data_present <= 0;
         elsif (rfd_f = '0' and clk_i'event and clk_i = '1' and ce_i = '1') then
            loading <= 1;
            cycle   <= no_of_cycles+1;
         elsif (c_sqm_type = 1 and cycle <= no_of_cycles+1 and c_mult_type > 1) then
            if (c_reg_a_b_inputs = 0) then
               din_a_seq <= a_i;
               if (intND = '1' and ((c_has_nd = 0 and intRFD = '1') or (c_has_nd = 1 and nd_i = '1'))) then
                  stored_asign <= asign_i;
                  started      <= '1';
               end if;
               if((swapb_i = '1' and b_input'event) or (intND = '1')) then
                  din_b_seq <= b_input;
                  started   <= '1';
               end if;
            elsif (c_reg_a_b_inputs = 1) then
               din_a_seq <= dina_q;
               if (intND = '1' and ((c_has_nd = 0 and regRFD = '1') or (c_has_nd = 1 and nd_q = '1'))) then
                  stored_asign <= asign_q;
                  started      <= '1';
               end if;
               if((swapb_i = '1' and dinb_q'event) or (intND = '1')) then
                  din_b_seq <= dinb_q;
                  started   <= '1';
               end if;
            end if;
            if (clk_i'event and clk_i = '1' and ce_i = '1') then
               if (intND = '0' and cycle < no_of_cycles+1) then
                  cycle <= cycle + 1;
               elsif (intND = '1') then
                  cycle   <= 3;
                  started <= '1';
               end if;
               new_data_present <= 1;
               loading          <= 0;
            end if;
         elsif ((intND = '1' and clk_i'event and clk_i = '1' and ce_i = '1') and ready_for_data = '1') then
            if (c_reg_a_b_inputs = 0) then
               if (c_sqm_type = 0) then
                  din_a_seq <= a((c_baat-1) downto 0);
                  a_int     := a_i;
               else
                  din_a_seq <= a_i;
               end if;
               stored_asign <= asign_i;
               din_b_seq    <= b_input;
            elsif (c_reg_a_b_inputs = 1) then
               if (c_sqm_type = 0) then
                  din_a_seq <= dina_q((c_baat-1) downto 0);
                  a_int     := dina_q;
               else
                  din_a_seq <= dina_q;
               end if;
               stored_asign <= asign_q;
               din_b_seq    <= dinb_q;
            end if;
            cycle            <= 2;
            new_data_present <= 1;
            started          <= '1';
            loading          <= 0;
         elsif (cycle > 1) and (clk_i'event and clk_i = '1' and ce_i = '1') and (c_a_width >= cycle*c_baat) and (loading = 0) then
            din_a_seq <= (others => '0');
            if (c_sqm_type = 0) then
               din_a_seq <= a_int(((cycle*c_baat)-1) downto ((cycle-1)*c_baat));
            elsif (c_reg_a_b_inputs = 0) then
               din_a_seq <= a_i;
            else
               din_a_seq <= dina_q;
            end if;
            cycle <= cycle + 1;
            if (c_reg_a_b_inputs = 0 and swapb_i = '1') then
               din_b_seq <= b_input;
            elsif (c_reg_a_b_inputs = 1 and swapb_i = '1') then
               din_b_seq <= dinb_q;
            end if;
         elsif (clk_i'event and clk_i = '1' and ce_i = '1') and (c_a_width < cycle*c_baat) and (cycle < no_of_cycles) and (loading = 0) then
            din_a_seq <= (others => '0');
            if (c_sqm_type = 0) then
               din_a_seq(((c_a_width-((cycle-1)*c_baat))-1) downto 0) <= a_int(c_a_width-1 downto ((cycle-1)*c_baat));
            elsif (c_reg_a_b_inputs = 0) then
               din_a_seq <= a_i;
            else
               din_a_seq <= dina_q;
            end if;
            if (c_sqm_type = 0) then
               if (c_a_type = c_signed and c_has_a_signed = 0) or (c_has_a_signed = 1 and stored_asign = '1') then
                  for i in (c_a_width-((cycle-1)*c_baat)) to (c_baat-1) loop
                     din_a_seq(i) <= a_int(c_a_width-1);
                  end loop;
               elsif (c_a_type = c_unsigned) or (stored_asign = '0') then
                  for i in (c_a_width-((cycle-1)*c_baat)) to (c_baat-1) loop
                     din_a_seq(i) <= '0';
                  end loop;
               end if;
            end if;
            cycle <= cycle + 1;
         elsif (clk_i'event and clk_i = '1' and ce_i = '1') and (cycle >= no_of_cycles) then
            if (c_sqm_type = 0) then
               if ((c_has_a_signed = 1 and stored_asign = '1') or (c_a_type = 0 and c_has_a_signed = 0)) and (din_a_seq(c_baat-1) = '1') then
                  din_a_seq <= (others => '1');
               elsif (din_a_seq(c_baat-1) = 'X') then
                  din_a_seq <= (others => 'X');
               else
                  din_a_seq <= (others => '0');
               end if;
            elsif (c_reg_a_b_inputs = 0) then
               din_a_seq <= a_i;
            else
               din_a_seq <= dina_q;
            end if;
            if (cycle = no_of_cycles) then
               cycle <= cycle + 1;
            end if;
            new_data_present <= 0;
         end if;
      end if;
   end process split_inputs;

   --Purpose : Calculate the output from the sequential multipier.
   -- This process takes the inputs generated in the previous process, multiplies them and adds them 
   -- to the fedback output of the previous multiplication. The product_f signa is produced and this is 
   -- fed to the output.
   seq_test : process (clk_i, aclr_i, din_a_seq, din_b_seq)
      variable ser_prod         : sub_mult;
      variable product          : std_logic_vector((out_size-no_sign) downto 0);
      variable feedback         : std_logic_vector((out_size-no_sign) downto 0);
      variable all0s            : std_logic_vector((out_size-no_sign) downto 0) := (others => '0');
      variable store            : std_logic_vector(((c_baat*(no_of_cycles-2))-1) downto 0) := (others => '0');
      variable accum_out        : std_logic_vector(out_size downto 0) := (others => '0');
      variable total_output     : std_logic_vector((out_size + 1 + (c_baat*(no_of_cycles-2)) - 1) downto 0);
      variable diff             : integer                                                  := c_a_width+c_b_width+c_has_a_signed-c_out_width;   --full_out_size-c_out_width;    --(out_size + 1 + (c_baat*(no_of_cycles-2))) - (((no_of_cycles-1)*c_baat) - c_a_width) - c_out_width;
      variable inc              : integer                                                  := inc_if_sign(c_a_type, c_b_type);
      variable dec              : integer                                                  := inc_if_no_sign(c_a_type, c_b_type);
      variable difference       : integer;
      variable stored_mult_sign : integer                                                  := 1;
      variable intNDpipe        : std_logic_vector(mult_length downto 0)                   := (others => '0');
      variable bitsToDiscard    : integer                                                  := ((no_of_cycles - 1) * c_baat) - c_a_width;
      variable real_out_width   : integer                                                  := c_a_width+c_b_width+c_has_a_signed;

   begin
      if (c_out_width < real_out_width) then
         real_out_width := c_out_width;
      end if;
      if (c_baat < c_a_width) then
         if (cycle = 1) then
            product      := (others => '0');
            feedback     := (others => '0');
            total_output := (others => '0');
            store        := (others => '0');
            accum_out    := (others => '0');
            seq_ready    <= '0';
         end if;

         if (clk_i'event and clk_i = '1' and ce_i = '1' and no_of_cycles > 3) then
            if(c_reg_a_b_inputs = 0) then
               swapb_pipe(0) <= swapb_i;
            else
               swapb_pipe(0) <= swapb_q;
            end if;
            swapb_pipe(1) <= swapb_pipe(0);
            ld_pipe(0)    <= load_done_i;
            ld_pipe(1)    <= ld_pipe(0);
         end if;

         for i in 0 to mult_length-1 loop
            ser_prod(i) := ser_prod(i+1);
         end loop;

         if (c_baat < c_a_width and ce_i = '1' and clk_i'event and clk_i = '1' and aclr_i = '0' and sclr_i = '0' and swapb_i = '0' and rfd_f = '1') then
            for i in 0 to mult_length-1 loop
               ser_prod(i) := ser_prod(i+1);
            end loop;
            if ((no_of_cycles-1) > 2) then
               if (clk_i'event and clk_i = '1') then -- and last_clk = '1') then
                  if (cycle > 1) then
                     for i in 0 to ((no_of_cycles-1)-c_reg_a_b_inputs-3) loop
                        intRFD_delay(i) <= intRFD_delay(i + 1);
                     end loop;
                  end if;
                  --end if ;
                  if (c_reg_a_b_inputs = 1 and c_has_nd = 1) then
                     intRFD_delay(no_of_cycles-c_reg_a_b_inputs-3) <= regRFD and nd_q;
                  elsif (c_reg_a_b_inputs = 1 and c_has_nd = 0) then
                     intRFD_delay(no_of_cycles-c_reg_a_b_inputs-3) <= regRFD;
                  elsif (c_reg_a_b_inputs = 0 and c_has_nd = 1) then
                     intRFD_delay(no_of_cycles-c_reg_a_b_inputs-3) <= intRFD and nd_i;
                  elsif (c_reg_a_b_inputs = 0 and c_has_nd = 0) then
                     intRFD_delay(no_of_cycles-c_reg_a_b_inputs-3) <= intRFD;
                  end if;
               end if;
            end if;
         elsif (aclr_i = '1' or swapb_i = '1' or rfd_f = '0') or ((clk_i'event) and (clk_i = '1') and (ce_i = '1') and sclr_i = '1') then
            for i in 0 to ((no_of_cycles-1)-c_reg_a_b_inputs-2) loop
               intRFD_delay(i) <= '0';
            end loop;
         end if;

--        if ((din_a_seq'event or din_b_seq'event or (aclr_i'event and aclr_i = '0') or (sclr_i'event and sclr_i = '0') or (clk'event and clk = '1' and ce_i = '1')) and c_sqm_type = 1 and c_pipeline = 1 and c_mult_type > 1 and mult_length > 0) then

--                      if (clk'event and clk = '1' and ce_i = '1') then
--                              stored_mult_sign := mult_sign_this_cycle ;
--                      end if ;
--
--                      --intNDpipe(mult_length) := intND ;
--
--                      --if ((c_has_loadb=1 and c_has_swapb = 0) and (loadb_count /= -1 and not_loaded = 0)) or loading=1 then
--                      --      ser_prod(mult_length) := (others => 'X') ;
         --                     if (no_sign = 0) then
--                              ser_prod(mult_length) := mult(din_a_seq, din_b_seq, stored_asign, stored_mult_sign, out_size+1) ; --(c_baat+b_input'length+increment)) ;
--                      else
--                              ser_prod(mult_length) := mult(din_a_seq, din_b_seq, stored_asign, stored_mult_sign, out_size) ; --(c_baat+b_input'length+increment)) ;
--                      end if ;
--                      product := ser_prod(0) ;
--        else
--                      --intNDpipe(0) := intND ;
--        end if ;

         if (aclr_i = '1') then
            product_f <= (others => '0');
            product   := (others => '0');
            feedback  := (others => '0');
         elsif (clk_i'event) and (clk_i = '1') and (ce_i = '1') then
            if (sclr_i = '1') then
               product_f <= (others => '0');
               product   := (others => '0');
               feedback  := (others => '0');
            elsif (b_is_0) then
               if (cycle /= no_of_cycles) then
                  seq_ready <= '0';
               elsif (cycle = no_of_cycles) then
                  seq_ready <= '1';
               end if;
               product_f <= (others => '0');
            elsif (cycle > 1) or (c_sqm_type = 1 and c_mult_type > 1) then
               if ((c_has_loadb = 1 and c_has_swapb = 0) and (loadb_count /= -1 and not_loaded = 0)) or loading = 1 then
                  product := (others => 'X');
               else
                  if (no_sign = 0) then
                     product := mult(din_a_seq, din_b_seq, stored_asign, sign_this_cycle, out_size+1);
                  else
                     product := mult(din_a_seq, din_b_seq, stored_asign, sign_this_cycle, out_size);
                  end if;
               end if;
               if (no_sign = 0) then
                  if (c_sqm_type = 1 and intND = '1' and c_mult_type > 1) then
                     accum_out(product'length-1 downto 0) := add(product, all0s, sign_this_cycle, c_b_type);
                  elsif (c_sqm_type = 1 and intND = '0' and c_mult_type > 1) then
                     accum_out(product'length-1 downto 0) := add(product, feedback, sign_this_cycle, c_b_type);
                  elsif (cycle /= 2) then
                     --elsif (intND = '0') then
                     accum_out(product'length-1 downto 0) := add(product, feedback, sign_this_cycle, c_b_type);
                  else
                     --elsif (intND = '1') then
                     accum_out(product'length-1 downto 0) := add(product, all0s, sign_this_cycle, c_b_type);  --product ;
                  end if;
               elsif(no_sign = 1) then
                  if (c_sqm_type = 1 and intND = '1' and c_mult_type > 1) then
                     accum_out := add2(product, all0s, sign_this_cycle, c_b_type);
                  elsif (c_sqm_type = 1 and intND = '0' and c_mult_type > 1) then
                     accum_out := add2(product, feedback, sign_this_cycle, c_b_type);
                     --elsif (intND = '0') then
                  elsif (cycle /= 2) then
                     accum_out := add2(product, feedback, sign_this_cycle, c_b_type);
                     --elsif (intND = '1') then
                  else
                     accum_out := add2(product, all0s, sign_this_cycle, c_b_type);
                  end if;
               end if;
            end if;
            if not(b_is_0) then
               feedback((out_size-c_baat-1+inc+dec) downto 0) := accum_out((out_size-1+inc+dec) downto c_baat);
               for i in out_size-c_baat+inc+dec to (feedback'length-1) loop
                  if (c_b_type = c_signed) then
                     feedback(i) := feedback(out_size-c_baat-1+inc+dec);
                  else
                     feedback(i) := '0';
                  end if;
               end loop;
               total_output := accum_out((total_output'length-store'length)-1 downto 0) & store;
               if (cycle > 1) then
                  for i in c_baat to (store'length-1) loop
                     store(i-c_baat) := store(i);
                  end loop;
               end if;
               if (cycle /= no_of_cycles) then
                  store(((c_baat*(no_of_cycles-2))-1) downto (c_baat*(no_of_cycles-3))) := accum_out(c_baat-1 downto 0);
                  seq_ready                                                             <= '0';
               elsif (cycle = no_of_cycles) then
                  store(((c_baat*(no_of_cycles-2))-1) downto (c_baat*(no_of_cycles-3))) := accum_out(c_baat-1 downto 0);
                  --if(loading = 0 and started = '1' and (swapb_pipe(1) = '0' or no_of_cycles = 3)) then
                  if((c_has_swapb = 1 or ld_pipe(1) = '1' or no_of_cycles = 3) and started = '1' and (swapb_pipe(1) = '0' or no_of_cycles = 3)) then
                     seq_ready <= '1';
                  end if;
               end if;
               if --(c_out_width >= (total_output'length - bitsToDiscard)) then
                  (diff < 0) then
                  --product_f(total_output'length-padding-1 downto 0) <= total_output(total_output'length-padding-1 downto 0);
                  product_f(real_out_width-1 downto 0) <= total_output(real_out_width-1 downto 0);
                  --for i in total_output'length-padding to c_out_width-1 loop
                  for i in (real_out_width) to c_out_width-1 loop
                     if (c_b_type = c_signed) then
                        product_f(i) <= total_output(total_output'length-1);
                     elsif (sign_this_cycle = 0) then
                        product_f(i) <= product(product'length-1);
                     else
                        product_f(i) <= '0';
                     end if;
                  end loop;
               else
                  for i in 0 to c_out_width-1 loop
                     product_f(i) <= total_output(i+diff);
                  end loop;
               end if;
            end if;
         end if;
      end if;

      
   end process seq_test;

   -- Purpose : Multiply operands A and B. 
   --           And select 'New Data- nd' depending on whether the inputs are
   --           registered or not.
   --           This is only for the non-sequential implementation.
   multiply : process (clk_i, dina_q, dinb_q, a_i, b_input, nd_i, nd_q, asign_i, asign_q, product_f, swapb_i, swapb_q, seq_ready, aclr_i, sclr_i, rfd_i)
      variable a_in    : std_logic_vector (real_a_width-1 downto 0)   := (others => '0');
      variable b_in    : std_logic_vector (b_input'length-1 downto 0) := (others => '0');
      variable a_sign  : std_logic;
      variable rfd_int : std_logic;
      variable nd_clk  : std_logic;
   begin  -- process multiply
      if not(c_baat < c_a_width) then
         
         if (c_reg_a_b_inputs = 1 and c_has_loadb = 1 and c_has_swapb = 0 and load_done_q = '0' and not_loaded = 0) then
            rfd_int := '0';
         elsif (c_reg_a_b_inputs = 0 and c_has_loadb = 1 and c_has_swapb = 0 and loadb_count /= -1 and not_loaded = 0) then
            rfd_int := '0';
         else
            rfd_int := '1';
         end if;

         if (c_has_nd = 0) or (c_reg_a_b_inputs = 0 and c_latency = 0) then  --and c_has_q = 0) then
            if(c_reg_a_b_inputs = 0) then
               a_sign := asign_i;
               a_in   := a_i;
               b_in   := b_input;
            else
               a_sign := asign_q;
               a_in   := dina_q;
               b_in   := dinb_q;
            end if;
         elsif (c_reg_a_b_inputs = 0 and c_has_nd = 1 and nd_i = '1' and c_mult_type > 2 and clk_i'event and clk_i = '1' and ce_i = '1') then
            a_in   := a_i;
            a_sign := asign_i;
         elsif (c_reg_a_b_inputs = 0 and c_has_nd = 1 and nd_i = '1' and c_mult_type < 3 and rfd_int = '1') then -- and (c_mult_type < 3 or ce_i = '1')) then  --and clk_i'event and clk_i = '1' and ce_i = '1') then
            a_in   := a_i;
            a_sign := asign_i;
         elsif (c_reg_a_b_inputs = 1 and c_has_nd = 1 and nd_q = '1' and rfd_int = '1') then -- and (c_mult_type < 3 or ce_i = '1')) then  -- and clk_i'event and clk_i = '1' and ce_i = '1') then
            a_in   := dina_q;
            a_sign := asign_q;
         end if;

         if (c_latency > 1 and c_mult_type > 2 and c_baat = c_a_width and c_reg_a_b_inputs = 0 and c_has_nd = 1 and nd_q = '1' and load_done_i = '1') then
            b_in := b_input; 
         elsif (c_latency > 1 and c_mult_type > 2 and c_baat = c_a_width and c_reg_a_b_inputs = 0 and c_has_nd = 1 and nd_q = '1' and load_done_i = '0') then
            b_in := (others => 'X');
         elsif (c_reg_a_b_inputs = 0 and c_has_nd = 1 and nd_i = '1' and c_mult_type < 2) then
            b_in := b_input;
         elsif (c_reg_a_b_inputs = 1 and c_has_nd = 1 and nd_q = '1' and c_mult_type < 2) then
            b_in := dinb_q;
         end if;

         if (aclr_i = '1') and not((c_pipeline = 0 or c_latency = 0) and c_reg_a_b_inputs = 0) then
            product_i <= (others => '0');
            new_data  <= nd_i;
         elsif (sclr_i = '1' and clk_i = '1' and clk_i'event and ce_i = '1' and not((c_pipeline = 0 or c_latency = 0) and c_reg_a_b_inputs = 0)) then
            product_i <= (others => '0');
            new_data  <= nd_i;
         elsif (c_reg_a_b_inputs = 1) then
            if (c_has_loadb = 1 and c_has_swapb = 0) and (load_done_q = '0' and not_loaded = 0) then  --(loadb_count /= -1 and not_loaded = 0) then --and (loadb = '0') then
               product_i <= (others => 'X');
            else
               if (c_mult_type < 2) then
                  product_i <= mult(a_in, b_in, a_sign, 0, c_out_width);
               else
                  product_i <= mult(a_in, dinb_q, a_sign, 0, c_out_width);
               end if;
            end if;
            if(c_has_nd = 1 and b_is_0) then
               new_data <= nd_i;
            elsif (c_has_nd = 1 and c_has_swapb = 0) then
               new_data <= nd_q and load_done_q;
            else
               new_data <= nd_q;
            end if;
         elsif (c_reg_a_b_inputs = 0) and not(c_latency > 1 and c_mult_type > 2 and c_baat = c_a_width and c_has_nd = 1 and c_has_swapb = 0) then
            if (c_has_loadb = 1 and c_has_swapb = 0) and (loadb_count /= -1 and not_loaded = 0) then
               product_i <= (others => 'X');
            else
               if (c_mult_type < 2) then
                  product_i <= mult(a_in, b_in, a_sign, 0, c_out_width);
                  --elsif (c_has_nd = 1 and nd_i = '1' and nd_clk = '1') then
                  --    product_i <= mult(a_in, b_in, a_sign, 0, c_out_width) ;
               else
                  product_i <= mult(a_in, b_input, a_sign, 0, c_out_width);
               end if;
            end if;
            if (c_has_nd = 1 and c_has_swapb = 0) then
               new_data <= nd_i and load_done_i;
            else
               new_data <= nd_i;
            end if;
          elsif (c_reg_a_b_inputs = 0) then
            if (c_has_loadb = 1 and c_has_swapb = 0) and (load_done_q = '0' and not_loaded = 0) then
               product_i <= (others => 'X');
            else
               product_i <= mult(a_in, b_in, a_sign, 0, c_out_width);
            end if;
            if (c_has_nd = 1 and c_has_swapb = 0) then
               new_data <= nd_i and load_done_i;
            else
               new_data <= nd_i;
            end if;
         end if;
      else
         if (aclr_i = '0') then
            if (c_output_hold = 0) and not(clk_i'event and clk_i = '1' and ce_i = '1' and sclr_i = '1') then
               product_i <= product_f;
               new_data  <= nd_i;
            elsif (c_has_q = 1) and (c_output_hold = 1) and (seq_ready = '1') and not(clk_i'event and clk_i = '1' and ce_i = '1' and sclr_i = '1') then
               product_i <= product_f;
               new_data  <= nd_i;
            elsif (clk_i'event and clk_i = '1' and ce_i = '1' and sclr_i = '1') then
               product_i <= (others => '0');
            end if;
         elsif (aclr_i = '1') then
            product_i <= (others => '0');
         end if;
      end if;
   end process multiply;

   --------------------------------------------------------------------------------
-- loadb PROCESS
-- =============
--
-- If a reloadable multiplier is selected this process calculates the b input value at any one time 
-- and the rfd_f signal. rfd_f is combined with rfd_i or intRFD to create the overall ready for data signal.
   process (aclr_i, clk_i, b, rfd_i, intND, nd_i, nd_q)
      constant rom_addr_width : integer :=
         get_rom_addr_width(c_mem_type, bram_addr_width);
      constant sig_bits    : integer := select_val(c_baat, rom_addr_width, c_baat >= rom_addr_width);
      constant loadb_delay : integer := 2**sig_bits - 1;
   begin

      if (c_mult_type < 3) then
         load_done_i <= '1';
      elsif (c_has_loadb = 1) then
         if c_has_aclr /= 0 and aclr_i = '1' then
            loadb_count <= -1;
            load_done_i <= '1';
         elsif (clk_i'event and (clk_i = '1')) then
            
            if(c_baat < c_a_width) and (ccm_serial = 0 or c_reg_a_b_inputs = 1) then
               for i in 0 to (c_reg_a_b_inputs - ccm_serial) loop
                  rfd_f_pipe(i) <= rfd_f_pipe(i+1);
               end loop;
               if loadb_count /= 0 then
                  rfd_f <= rfd_f_pipe(0);
               end if;
            end if;

            if (c_sync_enable = c_override and c_has_sclr /= 0 and sclr_i = '1') or
               (c_has_sclr /= 0 and sclr_i = '1' and (c_has_ce = 0 or ce_i = '1')) then
               loadb_count <= -1;
               load_done_i <= '1';
            elsif c_has_ce = 0 or ce_i = '1' then
               if loadb = '1' then
                  loadb_count  <= loadb_delay;
                  load_b_value <= b;
                  load_done_i  <= '0';
                  if (c_baat = c_a_width) or (ccm_serial = 1 and c_reg_a_b_inputs = 0) then
                     if(c_has_swapb = 0) then
                        rfd_f <= '0';
                     else
                        rfd_f <= '1';
                     end if;
                  else
                     if(c_has_swapb = 0) then
                        rfd_f_pipe(1 + c_reg_a_b_inputs - ccm_serial) <= '0';
                     else
                        rfd_f_pipe(1 + c_reg_a_b_inputs - ccm_serial) <= '1';
                     end if;
                  end if;
                  not_loaded <= 0;
               else
                  if loadb_count > 0 then
                     loadb_count <= loadb_count-1;
                  elsif loadb_count = 0 then
                     -- Write opposite bank to the one we are currently reading
                     if c_has_swapb /= 0 and bank_sel = '0' then
                        bconst1 <= load_b_value;
                     else
                        bconst0 <= load_b_value;
                     end if;  -- bank_sel

                     loadb_count <= -1;
                     load_done_i <= '1';
                     not_loaded  <= 0;
                     if (c_baat = c_a_width) or (ccm_serial = 1 and c_reg_a_b_inputs = 0) then
                        rfd_f <= '1';
                     else
                        rfd_f_pipe <= (others => '1');
                        rfd_f      <= '1';
                     end if;
                  end if;  -- loadb_count
                  
               end if;  -- loadb
               
            end if;  -- c_has_ce

         end if;  -- aclr

      end if;
   end process;

   process (bconst0, bconst1, bank_sel, b, load_done_i, load_done_q, aclr_i, clk_i, rfd_i, intND, nd_i, nd_q)
      variable b_tmp  : std_logic_vector(c_b_width-1 downto 0) := (others => '0');
      variable b_tmp2 : std_logic_vector(c_b_width-1 downto 0) := (others => '0');
      variable msb    : integer                                := 0;
   begin
      if (c_mult_type < 2) then
         b_input <= b;
      elsif (c_mult_type < 3) or (not_loaded = 1 and loadb = '0') then
      else
         if(load_done_i = '1' or c_has_swapb = 1) then
            if(bank_sel = '0' and c_mult_type > 2 and not_loaded = 0) then
               b_input <= bconst0;
            elsif(bank_sel = '1' and c_mult_type > 2 and not_loaded = 0) then
               b_input <= bconst1;
            end if;
         end if;
      end if;
   end process;

-- If the multiplier has a swapb pin then this process is used to swap between the two
-- banks of memory.
   process (aclr_i, clk_i)
   begin
      if (c_has_swapb = 0) then
         bank_sel <= '0';
      elsif c_has_swapb /= 0 then
         if c_has_aclr /= 0 and aclr_i = '1' then
            bank_sel <= '0';
         elsif (clk_i'event and (clk_i = '1')) then
            
            if (c_sync_enable = c_override and c_has_sclr /= 0 and sclr_i = '1') or
               (c_has_sclr /= 0 and sclr_i = '1' and (c_has_ce = 0 or ce_i = '1')) then
               bank_sel <= '0';
            elsif c_has_ce = 0 or ce_i = '1' then
               if (c_latency > 1 and c_reg_a_b_inputs = 0 and c_baat = c_a_width and c_has_nd = 1 and swapb_q = '1' and load_done_q = '1') then
                   bank_sel <= not(bank_sel);
               elsif (c_latency < 2 or c_reg_a_b_inputs = 1 or c_baat < c_a_width or c_has_nd = 0) and swapb_i = '1' and load_done_i = '1' then
                  bank_sel <= not(bank_sel);  -- Toggle bank_sel
               end if;  -- swapb ...
            end if;  -- c_has_ce ...
            
         end if;  -- aclr
      end if;  -- c_has_swapb
      
   end process;

   -- This process models the pipeline. 
   pipeline_output : process (clk_i, aclr_i, sclr_i, product_i, product_f, new_data, nd_q_tmp, seq_ready)
   begin  -- process register_output
    if not(c_baat = c_a_width and c_mult_type < 2 and c_reg_a_b_inputs = 0 and c_has_nd = 1 and c_latency > 2) then
      if ((product_i'event) or (c_baat < c_a_width and product_f'event) or (c_baat = c_a_width and ((sclr_i'event and sclr_i = '0') or (aclr_i'event and aclr_i = '0')))) and (aclr_i = '0') and not(clk_i = '1' and clk_i'event and sclr_i = '1') then
         if (c_baat < c_a_width) then
            sub_product_o(0) <= product_f;
            sub_rdy(0)       <= seq_ready;
            sub_product(0)   <= product_i;
         else
            sub_product_o(0) <= product_i;
            sub_rdy(0)       <= new_data;
            sub_product(0)   <= product_i;
         end if;
      elsif (new_data'event or seq_ready'event) and (aclr_i = '0') and not(clk_i = '1' and clk_i'event and sclr_i = '1') then
         if (c_baat < c_a_width) then
            sub_rdy(0) <= seq_ready;
         else
            sub_rdy(0) <= new_data;
         end if;
      elsif (aclr_i = '1' and c_baat = c_a_width) and (c_mult_type < 2 or c_mem_type = 0) then
         for n in 0 to c_latency loop
            sub_product(n) <= (others => '0');
            if (c_latency /= 0 and (n > 0 or c_reg_a_b_inputs = 1)) then  --or (c_baat < c_a_width) then
               --sub_product(n) <= (others => '0');
               sub_product_o(n) <= (others => '0');
            end if;
         end loop;  -- n
      elsif (aclr_i = '1' and c_baat < c_a_width) and (c_mult_type < 2 or c_mem_type = 0 or c_latency > 1) then
         for n in 0 to c_latency loop
            --sub_product(n) <= (others => '0');
            if (c_latency /= 0) then  -- and (n > 0 or c_reg_a_b_inputs = 1)) then --or (c_baat < c_a_width) then
               sub_product(n)   <= (others => '0');
               sub_product_o(n) <= (others => '0');
            end if;
         end loop;  -- n
      elsif (clk_i'event and clk_i = '1') then
         if (c_pipeline = 1 or (c_latency > 0 and c_baat = c_a_width) or c_baat < c_a_width) then
            if (sclr_i = '1') then
               for n in 0 to c_latency loop
                  sub_rdy(n) <= '0';
                  if (c_latency /= 0 and (n > 0 or c_reg_a_b_inputs = 1)) or (c_baat < c_a_width) then
                     sub_product(n)   <= (others => '0');
                     sub_product_o(n) <= (others => '0');
                  end if;
               end loop;  -- n
            elsif (ce_i = '1') then
               for n in 1 to c_latency loop
                  sub_rdy(n) <= sub_rdy(n-1);
                  if (n > 1 or (c_reg_a_b_inputs = 0 and (c_mult_type > 2 or nd_i = '1' or swapb_i = '1' or (c_has_swapb = 0 and load_done_i = '0' and c_baat = c_a_width))) or (c_reg_a_b_inputs = 1 and (nd_q = '1' or swapb_q = '1' or (c_has_swapb = 0 and load_done_i = '0' and c_baat = c_a_width))) or c_baat < c_a_width) then
                     sub_product(n)   <= sub_product(n-1);
                     sub_product_o(n) <= sub_product_o(n-1);
                  end if;
               end loop;  -- n
            end if;
         end if;
      end if;
    else -- Special case.
      if ((product_i'event) or (nd_q_tmp'event) or (((sclr_i'event and sclr_i = '0') or (aclr_i'event and aclr_i = '0')))) and (aclr_i = '0') and not(clk_i = '1' and clk_i'event and sclr_i = '1') then
        for n in 1 to 1 loop
          sub_product_o(n) <= product_i;
          sub_rdy(n)       <= nd_q_tmp;
          sub_product(n)   <= product_i;
        end loop;
      --elsif nd_q_tmp'event then
      --  sub_rdy(1)       <= nd_q_tmp;
      elsif clk_i'event and clk_i = '1' then
        if (ce_i = '1') then
          for n in 2 to c_latency loop
            sub_rdy(n) <= sub_rdy(n-1);
            if (n = 2 and nd_q_tmp = '1') then
              sub_product(n)   <= sub_product(n-1);
              sub_product_o(n) <= sub_product_o(n-1);
            elsif (n > 2) then
              sub_product(n)   <= sub_product(n-1);
              sub_product_o(n) <= sub_product_o(n-1);
            end if;
          end loop;
        end if;
      end if;
    end if;
   end process pipeline_output;

   -- Purpose : Select pipelined or non-piplined Multiplier Output and pipelined
   -- or non-pipelined "rdy".
   -- Type    : Combinational
   select_product : process (aclr_i, product_f, product_i, sub_product, new_data, sub_rdy, clk_i)
   begin  -- process select_product
      if (c_latency = 0 and c_baat = c_a_width) and (aclr_i = '0') and not(clk_i'event and clk_i = '1' and sclr_i = '1') then
         product   <= product_i;
         product_o <= product_i;
         rdy_i     <= new_data;
      elsif (c_latency = 0 and c_baat = c_a_width) and (aclr_i = '1') then
         product_o <= product_i;
         if (c_has_nd = 1 and c_has_q = 0 and c_reg_a_b_inputs = 0) then
            rdy_i <= new_data;
         end if;
      elsif ((c_latency = 0 or (c_latency = 1 and (c_sqm_type = 0 or c_mult_type < 2))) and c_baat < c_a_width) and (product_f'event or sub_rdy'event) then
         product   <= product_f;
         product_o <= product_f;
         rdy_i     <= seq_ready;
      elsif (c_latency > 1 and c_baat < c_a_width) and (clk_i'event) and (clk_i = '1') and (ce_i = '1') then
         if(c_sqm_type = 0 or c_mult_type < 2) then
            product   <= sub_product(c_latency-2);
            product_o <= sub_product_o(c_latency-2);
            rdy_i     <= sub_rdy(c_latency-2);
         else
            product   <= sub_product(c_latency-1);
            product_o <= sub_product_o(c_latency-1);
            rdy_i     <= sub_rdy(c_latency-1);
         end if;
      elsif (c_latency = 1 and c_baat = c_a_width) and (c_has_nd = 1) and (sub_product'event or sub_rdy'event) then
         if (sclr_i = '0') then
            product   <= sub_product(1);
            product_o <= sub_product_o(1);
            rdy_i     <= sub_rdy(1);
         else
            product   <= (others => '0');
            product_o <= (others => '0');
            rdy_i     <= '0';
         end if;
      elsif (c_latency > 0) and (clk_i'event) and (clk_i = '1') and (ce_i = '1') and not((c_latency = 1 and c_baat = c_a_width) and (c_has_nd = 1)) then
         if (sclr_i = '0') then
            if (c_latency > 1 and c_mult_type > 2 and c_baat = c_a_width and c_reg_a_b_inputs = 0 and c_has_nd = 1) then
              product   <= sub_product(c_latency-2);
              product_o <= sub_product_o(c_latency-2);
              rdy_i     <= sub_rdy(c_latency-1);
            else
              product   <= sub_product(c_latency-1);
              product_o <= sub_product_o(c_latency-1);
              rdy_i     <= sub_rdy(c_latency-1);
            end if;
         else
            product   <= (others => '0');
            product_o <= (others => '0');
            rdy_i     <= '0';
         end if;
      end if;
   end process select_product;

   -- Purpose : Register all Output ports. 
   -- Type    : Sequential
   register_output : process (product_o, product_i, product, rdy_i, rfd_i, clk_i, aclr_i)
   begin  -- process register_output
      if (aclr_i = '1') and not(c_baat = c_a_width and c_mem_type = 2 and c_mult_type > 1 and ccm_num_pps = 1 and not(need_addsub)) then
         q_i         <= (others => '0');
         rfd_q       <= '0';
         load_done_q <= '0';
      elsif (clk_i'event and clk_i = '1') then
         if (sclr_i = '1') and ((c_sync_enable = 0) or (ce_i = '1')) then
            q_i         <= (others => '0');
            rfd_q       <= '0';
            load_done_q <= '0';
         elsif (ce_i = '1') and (c_a_width = c_baat) then
            if ((((c_pipeline = 0 and c_latency = 0) or c_latency = 0) and c_reg_a_b_inputs = 0) and ((nd_i = '1') or (c_has_swapb = 0 and load_done_i = '0'))) then  --and (load_done_i = '1') then
               q_i <= product_i;
            elsif (((c_pipeline = 1 or c_latency > 0) and c_latency /= 0) or (c_reg_a_b_inputs = 1) or c_baat < c_a_width) then
               q_i <= product;
            end if;
            rdy_q       <= rdy_i;
            rfd_q       <= rfd_i;
            load_done_q <= load_done_i;
         elsif (ce_i = '1') and (c_a_width > c_baat) then
            q_i         <= product;
            rdy_q       <= rdy_i;
            rfd_q       <= rfd_i;
            load_done_q <= load_done_i;
         end if;
      end if;
   end process register_output;

   -- Purpose : Drive combinatorial and registered output and select the
   -- registered version of the signal 'rdy' when the registered 
   -- Type    : Combinational
   drive_output : process (aclr_i, product_o, rdy_q, rdy_i, q_i, rfd_i, intRFD, load_done_i)
   begin  -- process non_registered_output
      if (c_has_o = 1) then
         o <= product_o;
      else
         o <= (others => 'X');
      end if;
      if (c_has_q = 1) then
         if (c_baat = c_a_width or c_output_hold = 0) then
            q <= q_i;
         elsif (rdy_q'event and rdy_q = '1') then
            q <= q_i;
         end if;
         if (c_a_width = c_baat) then
            if (c_has_nd = 1) then
               if ((c_has_rdy = 1) and ((c_pipeline = 0 or c_latency = 0) and c_reg_a_b_inputs = 0 and c_has_q = 0 and c_has_o = 1)) or (b_is_0) then
                  rdy <= rdy_i;
               elsif (c_has_rdy = 1) and ((c_pipeline = 1 and c_latency /= 0) or c_reg_a_b_inputs = 1 or c_has_q = 1) then
                  rdy <= rdy_q;
               end if;
            elsif (c_has_nd = 0) then
               rdy <= '1';
            else
               rdy <= 'X';
            end if;
         else
            if (c_has_rdy = 1) then
               rdy <= rdy_q;
            else
               rdy <= 'X';
            end if;
         end if;
         if (c_has_rfd = 1) then
            if (c_baat = c_a_width) then
               rfd <= rfd_i and rfd_f;
            elsif (c_has_swapb = 0) then
               rfd <= intRFD and load_done_i;
            else
               rfd <= intRFD;
            end if;
         else
            rfd <= 'X';
         end if;
         if (c_has_load_done = 1) then
            load_done <= load_done_i;
         else
            load_done <= 'X';
         end if;
      else
         q <= (others => 'X');
         if (c_has_rdy = 1) then
            if (c_baat = c_a_width and (c_has_nd = 0)) then
               rdy <= '1';
            else
               rdy <= rdy_i;
            end if;
         else
            rdy <= 'X';
         end if;
         if (c_has_rfd = 1) then
            if (c_baat = c_a_width) then
               rfd <= rfd_i and rfd_f;
            elsif (c_has_swapb = 0) then
               rfd <= intRFD and load_done_i;
            else
               rfd <= intRFD;
            end if;
         else
            rfd <= 'X';
         end if;
         if (c_has_load_done = 1) then
            load_done <= load_done_i;
         else
            load_done <= 'X';
         end if;
      end if;
   end process drive_output;
   

end behavioral;
