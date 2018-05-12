--------------------------------------------------------------------------------
-- $Header: /local/Projects/CVS/P1/zpu_SoC/sources/xilinx/XilinxCoreLib/sim_pkg.vhd,v 1.1 2010-07-10 21:43:23 mmartinez Exp $
--------------------------------------------------------------------------------
-- Copyright (c) 2006 Xilinx, Inc.
-- All Rights Reserved
--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor: Xilinx
-- \   \   \/    Version:
--  \   \        Filename: pkg_template.vhd
--  /   /        Date Created:
-- /___/   /\
-- \   \  /  \
--  \___\/\___\
--
--------------------------------------------------------------------------------
-- 
-- This text contains proprietary, confidential information of Xilinx, Inc.,
-- is distributed under license from Xilinx, Inc., and may be used, copied
-- and/or disclosed only pursuant to the terms of a valid license agreement
-- with Xilinx, Inc.
-- This copyright notice must be retained as part of this text at all times.
--
-------------------------------------------------------------------------------
-- Author   : Auto created
-------------------------------------------------------------------------------
-- Description:
--     This file is to be populated to the auto_gen perl script
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

library unisim;
use unisim.vcomponents.all;

library XilinxCoreLib;
use XilinxCoreLib.prims_utils_v9_0.all;

-------------------------------------------------------------------------------
package sim_pkg is

--------------------------------------------------------------------------------
--From:  ../hdl/toolbox/toolbox_pkg.vhd

type t_int_array is array (integer range <>) of integer;

function ext_bus(input_bus: std_logic_vector; width:integer; sign: integer) return std_logic_vector;

function select_integer (
         i0  : integer;
         i1  : integer;
         sel : boolean)
         return integer;

function select_string (
         i0  : string;
         i1  : string;
         sel : boolean)
         return string;

function select_slv (
         i0  : std_logic_vector;
         i1  : std_logic_vector;
         sel : boolean)
         return std_logic_vector;

function select_sl (
         i0  : std_logic;
         i1  : std_logic;
         sel : boolean)
         return std_logic;

function bmg2v1_bram_prim_sel(width:integer;depth:integer) return integer;

function str_ext(src:string;dest_len:integer) return string;

function split_bus( index:integer; bus_in:std_logic_vector; bus_width:t_int_array) return std_logic_vector;

function is_pow_of_2(val:integer) return boolean;

function slv_to_string (
         bitsin : std_logic_vector;
         nbits  : integer)
         return string;

function string_to_slv (
         bitsin : string;
         nbits  : integer)
         return std_logic_vector;

type t_bram_depth is array (integer range <>)
     of integer;

constant v4_bram_depth : t_bram_depth(1 to 48)
         := ( 2**14,                                        -- 1-bit
              2**13,                                        -- 2-bit
              2**12,2**12,                                  -- 4-bit
              2**11,2**11,2**11,2**11,2**11,                -- 9-bit
              2**10,2**10,2**10,2**10,                      -- 18-bit
              2**10,2**10,2**10,2**10,2**10,                -- 18-bit
              2**9,2**9,2**9,2**9,2**9,2**9,2**9,2**9,2**9, -- 36-bit
              2**9,2**9,2**9,2**9,2**9,2**9,2**9,2**9,2**9, -- 36-bit
              0,0,0,0,0,0,0,0,0,0,0,0);

type t_bram_prim_bmg2v1 is array (integer range <>)
     of integer;

constant bmg2v1_bram_prim : t_bram_prim_bmg2v1 (1 to 36) := (
              0,                                      -- 1-bit
              1,                                      -- 2-bit
              2,2,                                    -- 4-bit
              3,3,3,3,3,                              -- 9-bit
              4,4,4,4,4,4,4,4,4,                      -- 18-bit
              5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5     -- 36-bit
             --,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,    -- 72-bit
             -- 6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6     -- 72-bit
              );

type t_family is (
      v2,
      v4,
      v5,
      s3ax );

function family_str( family:t_family) return string;

function family_val( c_family: string) return t_family;

function get_adder_max( family: t_family) return integer;

constant c_signed   : integer:=0;

constant c_unsigned : integer:=1;

constant c_area   : integer:=1;

constant c_speed  : integer:=0;--default, to achieve best speed results

constant c_srl16  :integer:=0;

constant c_bram   :integer:=1;

constant c_dram   :integer:=2;

constant c_regs   :integer:=3;--primarily for the delay blocks to implement as individual regsters, for multicolumn

constant c_preadd_add         : integer:=0;

constant c_preadd_sub         : integer:=1;

constant c_preadd_addsub      : integer:=2;

constant c_preadd_subadd      : integer:=3;

constant c_preadd_add_swapped : integer:=4;--Currently only for Sandia sr halfband

function lat_addsub(has_pre_reg:integer;has_mid_reg:integer;num_mid_reg:integer) return integer;

type t_filt_arm_add_casc_outputs is ( p_P_OUT,
                                      p_PC_OUT,
                                      p_D_OUT,
                                      p_D_SYM_OUT,
                                      p_C_OUT,
                                      p_WE_OUT,
                                      p_WE_SYM_OUT,
                                      p_WE_SYM_OUT_2,
                                      p_ADDSUB_OUT,
                                      p_ADDSUP_OUT );

type t_filt_arm_add_casc_output_index is array (t_filt_arm_add_casc_outputs) of integer;

constant max_dsp_columns: integer:=10;

type t_col_len is array (max_dsp_columns-1 downto 0) of integer;

type t_filt_arm_add_casc is
record
  family          : t_family;
  implementation  : integer;
  num_taps        : integer;
  inter_we_cycles : integer;
  inter_tap_delay : integer;
  inter_sym_tap_delay : integer;
  symmetric       : integer;
  pre_add_func    : integer; --0=add,1=sub,2=addsub,3=subadd
  data_mem_type   : integer;
  coef_mem_type   : integer;
  data_comb       : integer;
  data_coef_comb  : integer;
  data_cascade    : integer;
  no_data_mem     : integer;
  coef_mem_depth  : integer;
  p_src           : integer;
  data_sign       : integer;
  coef_sign       : integer;
  has_ce          : integer;
  --has_nd          : integer;

  reload          : integer;
  reload_strms    : integer;
  reload_depth    : integer;

  output_index    : t_filt_arm_add_casc_output_index;
  output_src      : t_filt_arm_add_casc_output_index;
  
  num_independant_col : integer;
  num_split_col       : integer;
  inter_split_col_dly : integer;
  col_len             : t_col_len;
  dynamic_opcode      : integer;
  sym_para_struct     : integer;
  para_casc_we_src    : integer;
  resource_opt        : integer;
  data_width          : integer;
  datapath_mem_type   : integer;
  odd_symmetry        : integer;
end record;

type t_lat_filt_arm_add_casc is
record
  --latched : integer;--not feasable, filt arm has no knowledge of actual taps implements, just number of tap elemement
  cascaded: integer;
  tap     : integer;
  sym_inter_buff_depth: integer;
  pre_add_ipreg : integer;
  pre_add_midreg : integer;
  coef_addr_extra_delay : integer;
  para_sym_slice_est    : integer;
end record;

function lat_filt_arm_add_casc( param: t_filt_arm_add_casc) return t_lat_filt_arm_add_casc;

function count_col(cur_col:integer;col_len:t_col_len) return integer;

function calc_num_split_col(num_taps:integer;col_len:t_col_len) return integer;

type t_ram is
record
  family          : t_family;
  implementation  : integer;
  mem_type        : integer;--srl16=0 bram=1 dram=2
  write_mode      : integer;--only for bram/dram
  has_ce          : integer;--for subcores
  use_mif         : integer;
end record;

function lat_ram( param: t_ram; num_ports:integer) return integer;

type ramTypeMax is array (integer range <>) of std_logic_vector(255 downto 0);

function ram_content(depth: integer; width: integer; use_mif: integer; mif_file:string) return ramTypeMax;

type t_lat_tap_memory_add_casc is
record
  data: integer;
  coef: integer;
end record;

type t_tap_memory_add_casc is
record
  family          : t_family;
  implementation  : integer;
  data_mem_type   : integer;
  coef_mem_type   : integer;
  data_comb       : integer;
  data_coef_comb  : integer;
  no_data_mem     : integer;
  coef_mem_depth  : integer;
  has_ce          : integer;
  coef_reload     : integer;
  coef_reload_depth : integer;
  symmetric       : integer;
end record;

function lat_tap_memory_add_casc( param: t_tap_memory_add_casc) return t_lat_tap_memory_add_casc;

type t_emb_calc is
record
  family          : t_family;
  implementation  : integer;
  pre_add         : integer;
  pre_add_func    : integer;
  pre_add_ipreg   : integer;--only for when fabric adder
  pre_add_midreg  : integer;
  a_delay         : integer;
  b_delay         : integer;
  a_src           : integer;
  --c_src           : integer;
  a_sign          : integer;
  b_sign          : integer;
  d_sign          : integer;
  reg_opcode      : integer;
  implement_extra_b_dly: integer;
end record;

type t_emb_calc_func is (
                      PCIN,
                      PCIN_add_P,
                      PCIN_add_C,
                      NOP,
                      PCIN_add_A_mult_B,
                      A_mult_B,
                      P_add_A_mult_B,
                      C_add_A_mult_B,
                      P_add_A_concat_B,
                      P_add_P,
                      C_add_C,
                      PCIN_add_A_concat_B,
                      P_add_C,
                      A_concat_B,
                      C_add_A_concat_B,
                      C );

type t_emb_calc_details is
record
  op_code_width:integer;
  pre_add_ipreg: integer;
  pre_add_midreg: integer;
  extra_b_dly   : integer;
  latency: integer;
end record;

function dtls_emb_calc(param:t_emb_calc) return t_emb_calc_details;

function opcode_emb_calc(func:t_emb_calc_func;param:t_emb_calc) return std_logic_vector;

type t_counter_priority is (
          p_C0,
          p_C1,
          p_C2,
          p_not_C0_and_not_C1,
          p_C0_and_C1,
          p_C0_and_not_C1,
          p_C1_and_C2,
          p_C0_and_C2,
          p_C0_and_not_C2,
          p_C0_and_C1_and_C2,
          p_C0_and_C1_and_not_C2,
          p_C0_or_C1,
          p_C1_or_C2,
          p_C0_or_C2,
          p_C0_or_C1_or_C2,
          p_not_C1_or_C2,
          p_decode );--can add more as required

type t_counter_operation is (
          add_constant,
          sub_x_val,
          add_x_val);

type t_counter_clause is
record
  condition: t_counter_priority;
  operation: t_counter_operation;
  const_val: integer;
end record;

type t_counter_clause_array is array (integer range <>) of t_counter_clause;

function add_c( condition:t_counter_priority) return t_counter_clause;

function add_x( condition:t_counter_priority) return t_counter_clause;

function sub_x( condition:t_counter_priority) return t_counter_clause;

type t_casc_counters is
record
  cnt1_max_val    : integer;
  cnt2_max_val    : integer;
  cnt3_max_val    : integer;
  cnt2_max_qual   : integer;
  family          : t_family;
  implementation  : integer;
end record;

type t_data_address is
record
  family          : t_family;
  implementation  : integer;
  mem_type        : integer;
  base_cnt        : integer;
  block_cnt       : integer;
  symmetric       : integer;
  addr_width      : integer;
  sym_addr_width  : integer;
  combined        : integer;
  addr_packed     : integer;
  srl16_sequence  : integer;
  use_sym_cntrl   : integer;
  resource_opt    : integer;

  en_dly          : integer;
  block_end_dly   : integer;
  last_block_dly  : integer;
  write_phase_dly : integer;
  sub_block_end_dly: integer;
end record;

function lat_data_address(param:t_data_address) return integer;

type t_rfd_gen is
record
  family          : t_family;
  implementation  : integer;
  cnt             : integer;
  has_nd          : integer;
end record;

type t_coef_address is
record
  family          : t_family;
  implementation  : integer;
  base_cnt        : integer;
  block_cnt       : integer;
  addr_packed     : integer;
  addr_width      : integer;
  num_filters     : integer;
  multi_page_reload : integer;
  offset          : integer;
  has_ce          : integer;
  use_count_src   : integer;
  en_dly          : integer;
  base_max_dly      : integer;
  skip_base_max_dly : integer;
  count_max_dly     : integer;
  filt_sel_dly      : integer;
  resource_opt      : integer;
end record;

function lat_coef_address(param:t_coef_address) return integer;

type t_twopage_address is
record
  family          : t_family;
  implementation  : integer;
  addr_width      : integer;
  page_size       : integer;
  num_enables     : integer;
end record;

type t_mod_counter is
record
  family          : t_family;
  implementation  : integer;
  base_val        : integer;
  step_val        : integer;
  latch_cnt_wrap  : integer;
  has_clr         : integer;
  has_init        : integer;
  init_val        : integer;
  clr_point       : integer;
end record;

type t_coef_reload_cntrl is
record
  family          : t_family;
  implementation  : integer;
  reload_base_cnt : integer;
  coef_addr_packed: integer;
  num_filts       : integer;
  coef_mem_depth  : integer;
  num_macs        : integer;
  has_hb          : integer;

  has_ce          : integer;
  coef_width      : integer;
  filt_sel_width  : integer;
  filt_sel_width_out : integer;
  reload_width    : integer;
  resource_opt    : integer;
  latch_filt_sel  : integer;
  coef_mem_lat    : integer;
  num_reload_strms: integer;
end record;

type t_coef_reload_cntrl_lat is
record
  filt_sel_lat: integer;
  reload_lat  : integer;
end record;

function lat_coef_reload_cntrl(param:t_coef_reload_cntrl) return t_coef_reload_cntrl_lat;

--------------------------------------------------------------------------------
--From:  ../hdl/mif_file/mif_file_pkg.vhd

constant max_coef_width      : integer := 32;

constant max_num_taps        : integer := 1024;

constant max_rate            : integer := 1024;

constant max_frac_q_rate     : integer := 32;

constant max_num_taps_calced : integer := max_num_taps * max_frac_q_rate;

type t_coefficients is array (natural range <>)
     of std_logic_vector (max_coef_width-1 downto 0);

type t_multi_coefficients is array (natural range <>)
     of t_coefficients (max_num_taps_calced-1 downto 0);

function convert_bin_mif_to_hex (
         elab_dir   : string;
         mif_file   : string;
         num_taps   : integer;
         coef_width : integer;
         num_filts  : integer )
         return integer;

function read_coef_data (
         filename         : string;
         number_of_values : integer;
         coef_width       : integer;
         offset           : integer )
         return t_coefficients;

function read_coef_data_bin (
         filename         : string;
         number_of_values : integer;
         coef_width       : integer;
         offset           : integer )
         return t_coefficients;

function write_coef_data_hex (
         filename         : string;
         number_of_values : integer;
         coef_width       : integer;
         coef_data        : t_coefficients )
         return integer;

function write_coef_data (
         filename         : string;
         number_of_values : integer;
         coef_width       : integer;
         coef_data        : t_coefficients )
         return integer;

function get_number_of_inputs (
         filename: string )
         return integer;

function hex_to_std_logic_vector (
         hexstring : string;
         width     : integer )
         return std_logic_vector;

function std_logic_vector_to_hex (
         slv : std_logic_vector )
         return string;

function read_mem_mif_file (
         filename         : string;
         number_of_values : integer;
         coef_width       : integer;
         offset           : integer )
         return t_coefficients;

--------------------------------------------------------------------------------
--From:  ../hdl/da_elements/da_elements_pkg.vhd

--------------------------------------------------------------------------------
--From:  ../hdl/da_elements/da_elements_pkg.vhd

--------------------------------------------------------------------------------
--From:  ../hdl/da_elements/da_elements_pkg.vhd

function map_da_type ( type_in  : integer ) return integer;

function get_da_baat (
         filt_type    : integer;
         databits     : integer;
         clk_per_samp : integer;
         symmetry     : integer)
         return integer;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_elements_pkg.vhd

constant c_single_rate                : integer := 0;

constant c_polyphase_decimating       : integer := 1;

constant c_polyphase_interpolating    : integer := 2;

constant c_hilbert_transform          : integer := 3;

constant c_interpolated_transform     : integer := 4;

constant c_halfband_transform         : integer := 5;

constant c_decimating_half_band       : integer := 6;

constant c_interpolating_half_band    : integer := 7;

constant c_polyphase_pq               : integer := 9;--8;

constant c_interpolating_symmetry     : integer := 10;--9;

constant c_mem_auto       : integer:=0;

constant c_mem_forced_dist : integer:=1;--dram or srl16

constant c_mem_forced_bram : integer:=2;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_elements_pkg.vhd

type t_reqs is
record
  family              : t_family;
  filter_type         : integer;
  deci_rate           : integer;
  inter_rate          : integer;
  rate_type           : integer;
  num_taps            : integer;
  clk_per_samp        : integer;
  num_channels        : integer;
  num_filts           : integer;
  symmetry            : integer;
  neg_symmetry        : integer;
  zero_packing_factor : integer;
  coef_reload         : integer;
  data_width          : integer;
  coef_width          : integer;
  filt_sel_width      : integer;
  chan_width          : integer;
  output_width        : integer;
  data_mem_type       : integer;--0=auto 1=srl16/dram 2=bram
  coef_mem_type       : integer;
  ipbuff_mem_type     : integer;
  opbuff_mem_type     : integer;
  datapath_mem_type   : integer;
  data_sign           : integer;--1=unsigned 0=signed
  coef_sign           : integer;
  reg_output          : integer;
  has_nd              : integer;
  has_ce              : integer;
  has_sclr            : integer;
  col_mode            : integer;
  col_1st_len         : integer;
  col_wrap_len        : integer;
  col_pipe_len        : integer;
  resource_opt        : integer;
end record;

type t_param is
record
  family              : t_family;
  filter_type         : integer;
  deci_rate           : integer;
  inter_rate          : integer;
  num_taps            : integer;
  clk_per_samp        : integer;
  num_channels        : integer;
  num_filts           : integer;
  symmetry            : integer;
  odd_symmetry        : integer;
  neg_symmetry        : integer;
  zero_packing_factor : integer;
  coef_reload         : integer;
  data_sign           : integer;--1=unsigned 0=signed
  coef_sign           : integer;
  single_mac          : integer;
  centre_mac          : integer;
  
  num_taps_calced     : integer;
  clk_per_chan        : integer;
  num_macs            : integer;
  base_count          : integer;
  base_data_space     : integer;
  base_coef_space     : integer;

  data_width          : integer;
  coef_width          : integer;
  data_mem_depth      : integer;
  data_mem_type       : integer; --0=srl16 1=bram 2=dram
  datasym_mem_depth   : integer;
  datasym_mem_type    : integer;
  datasym_mem_offset  : integer;

  data_combined       : integer;
  data_packed         : integer;
  no_data_mem         : integer;

  coef_mem_depth      : integer;
  coef_mem_type       : integer;
  coef_mem_offset     : integer;
  coef_packed         : integer;

  data_coef_combined  : integer;

end record;

type t_polyphase_decimation_sym_wrap is
record
  family            : t_family;
  implementation    : integer;
  base_count        : integer;
  num_phases        : integer;
  num_channels      : integer;
  sym_type          : integer;--0=even 1=odd
  driving_mem_type  : integer;
  driving_mem_lat   : integer;
  force_srl16_mem   : integer;
  has_ce            : integer;
  has_nd            : integer;
end record;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_elements_pkg.vhd

function memory_calcs(reqs:t_reqs;
                      ip_param:t_param;
                      data_depth_unpacked: integer;
                      data_depth_packed: integer;
                      coef_depth_unpacked: integer;
                      coef_depth_packed: integer) return t_param;

function lat_polyphase_decimation_sym_wrap(param :  t_polyphase_decimation_sym_wrap) return integer;

function gen_mif_files ( elab_dir   : string;
                         gen_mif_prefix : string;
                         mif_file   : string;
                         param      : t_param )
                         return integer;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_single_rate.vhd

  type t_define_single_rate is
  record
    param               : t_param;
    
    --blocks used in structure
    filt_arm            : t_filt_arm_add_casc;
    filt_arm_lat        : t_lat_filt_arm_add_casc;
    accum               : t_emb_calc;
    accum_lat           : t_emb_calc_details;
    accum_req           : boolean;
    base_chan_phase_param : t_casc_counters;
    data_addr_param       : t_data_address;
    data_addr_lat         : integer;
    coef_addr_param       : t_coef_address;
    coef_addr_lat         : integer;
    rfd_param             : t_rfd_gen;
    --addr_reset_dly        : integer;
    addr_cntrl_lat        : integer;
    shorter_px_time       : boolean;
    data_dly_modifier     : integer;
    first_tap_extra_dly   : integer;

    --symmetric structure control
    mem_param           : t_tap_memory_add_casc;
    memory_path_lat     : t_lat_tap_memory_add_casc;
  	cyc_to_data_out     : integer;
    cyc_to_write        : integer;
    num_cyc_read_earily : integer;
    extra_dly           : integer;
    change_src          : integer;
    add_sup_dly         : integer;
    we_sym_dly          : integer;

    --reload
    reload_cntrl_param  :t_coef_reload_cntrl;
    reload_cntrl_param_lat: t_coef_reload_cntrl_lat;

    --Core latency values
    latency             : integer;
    buffer_page_size    : integer;
    buffer_type         : integer; --0=none,1=ip,2=op

  end record;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_single_rate.vhd

  function define_single_rate(reqs:t_reqs) return t_define_single_rate ;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_polyphase_decimation.vhd

  type t_define_decimation is
  record
    param               : t_param;
    
    --blocks used in structure
    filt_arm            : t_filt_arm_add_casc;
    filt_arm_lat        : t_lat_filt_arm_add_casc;
    accum               : t_emb_calc;
    accum_lat           : t_emb_calc_details;
    accum_req           : boolean;
    base_chan_phase_param : t_casc_counters;
    data_addr_param       : t_data_address;
    data_addr_lat         : integer;
    coef_addr_param       : t_coef_address;
    coef_addr_lat         : integer;
    rfd_param             : t_rfd_gen;
    addr_cntrl_lat        : integer;
    output_buffer         : t_ram;
    output_buffer_in_addr : t_twopage_address;
    output_buffer_out_addr: t_twopage_address;
    output_rate_counter   : t_casc_counters;
    output_buffer_depth   : integer;
    output_buffer_lat     : integer;
    extra_opb_reg         : integer;
    has_output_buffer     : boolean;
    output_rate           : integer;
    shorter_px_time       : boolean;
    data_dly_modifier     : integer;
    first_tap_extra_dly   : integer;
    use_c_port_as_storage : boolean;
    filter_sel_lat        : integer;

    --symmetric structure control
    mem_param           : t_tap_memory_add_casc;
    memory_path_lat     : t_lat_tap_memory_add_casc;
    wrap_over_param     : t_polyphase_decimation_sym_wrap;
    wrap_over_lat       : integer;
    para_sym_delay      : integer;
    para_sym_struct     : integer;
    para_sym_addr_delay : integer;
    add_sup_dly         : integer;

    --reload
    reload_cntrl_param  :t_coef_reload_cntrl;
    reload_cntrl_param_lat: t_coef_reload_cntrl_lat;

    --Core latency values
    latency             : integer;
    sample_latency      : integer;
    buffer_page_size    : integer;
    buffer_type         : integer; --0=none,1=ip,2=op

  end record;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_polyphase_decimation.vhd

  function define_decimation(reqs:t_reqs) return t_define_decimation ;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_halfband.vhd

  type t_define_halfband is
  record
    param               : t_param;
    
    --blocks used in structure
    filt_arm            : t_filt_arm_add_casc;
    filt_arm_lat        : t_lat_filt_arm_add_casc;
    accum               : t_emb_calc;
    accum_lat           : t_emb_calc_details;
    accum_req           : boolean;
    base_chan_phase_param : t_casc_counters;
    data_addr_param       : t_data_address;
    data_addr_lat         : integer;
    coef_addr_param       : t_coef_address;
    coef_addr_lat         : integer;
    rfd_param             : t_rfd_gen;
--    addr_reset_dly        : integer;
    addr_cntrl_lat        : integer;
    centre_tap_coef       : t_ram;
    centre_tap_coef_lat   : integer;
    shorter_px_time       : boolean;
    data_dly_modifier     : integer;
    first_tap_extra_dly   : integer;
    
    --symmetric structure control
    mem_param           : t_tap_memory_add_casc;
    memory_path_lat     : t_lat_tap_memory_add_casc;
  	cyc_to_data_out     : integer;
    cyc_to_write        : integer;
    num_cyc_read_earily : integer;
    extra_dly           : integer;
    change_src          : integer;
    add_sup_dly         : integer;
    we_sym_dly          : integer;

    --reload
    reload_cntrl_param  :t_coef_reload_cntrl;
    reload_cntrl_param_lat: t_coef_reload_cntrl_lat;

    --Core latency values
    latency             : integer;
    buffer_page_size    : integer;
    buffer_type         : integer; --0=none,1=ip,2=op

  end record;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_halfband.vhd

  function define_halfband(reqs:t_reqs) return t_define_halfband ;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_interpolated.vhd

  type t_define_interpolated is
  record
    param               : t_param;

    --blocks used in structure
    filt_arm            : t_filt_arm_add_casc;
    filt_arm_lat        : t_lat_filt_arm_add_casc;
    accum               : t_emb_calc;
    accum_lat           : t_emb_calc_details;
    accum_req           : boolean;
    base_chan_phase_param : t_casc_counters;
    data_addr_param       : t_data_address;
    data_addr_lat         : integer;
    coef_addr_param       : t_coef_address;
    coef_addr_lat         : integer;
    rfd_param             : t_rfd_gen;
--    addr_reset_dly        : integer;
    addr_cntrl_lat        : integer;
    shorter_px_time       : boolean;
    data_dly_modifier     : integer;
    first_tap_extra_dly   : integer;
    
    --symmetric structure control
    mem_param           : t_tap_memory_add_casc;
    memory_path_lat     : t_lat_tap_memory_add_casc;
  	cyc_to_data_out     : integer;
    cyc_to_write        : integer;
    num_cyc_read_earily : integer;
    extra_dly           : integer;
    change_src          : integer;
    add_sup_dly         : integer;
    we_sym_dly          : integer;

    --reload
    reload_cntrl_param  :t_coef_reload_cntrl;
    reload_cntrl_param_lat: t_coef_reload_cntrl_lat;

    --Core latency values
    latency             : integer;
    buffer_page_size    : integer;
    buffer_type         : integer; --0=none,1=ip,2=op

  end record;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_interpolated.vhd

  function define_interpolated(reqs:t_reqs) return t_define_interpolated ;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_hilbert.vhd

  type t_define_hilbert is
  record
    param               : t_param;
    
    --blocks used in structure
    filt_arm            : t_filt_arm_add_casc;
    filt_arm_lat        : t_lat_filt_arm_add_casc;
    accum               : t_emb_calc;
    accum_lat           : t_emb_calc_details;
    accum_req           : boolean;
    base_chan_phase_param : t_casc_counters;
    data_addr_param       : t_data_address;
    data_addr_lat         : integer;
    coef_addr_param       : t_coef_address;
    coef_addr_lat         : integer;
    rfd_param             : t_rfd_gen;
--    addr_reset_dly        : integer;
    addr_cntrl_lat        : integer;
    shorter_px_time       : boolean;
    data_dly_modifier     : integer;
    first_tap_extra_dly   : integer;
    
    --symmetric structure control
    mem_param           : t_tap_memory_add_casc;
    memory_path_lat     : t_lat_tap_memory_add_casc;
  	cyc_to_data_out     : integer;
    cyc_to_write        : integer;
    num_cyc_read_earily : integer;
    extra_dly           : integer;
    change_src          : integer;
    add_sup_dly         : integer;
    we_sym_dly          : integer;

    --reload
    reload_cntrl_param  :t_coef_reload_cntrl;
    reload_cntrl_param_lat: t_coef_reload_cntrl_lat;

    --Core latency values
    latency             : integer;
    buffer_page_size    : integer;
    buffer_type         : integer; --0=none,1=ip,2=op

  end record;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_hilbert.vhd

  function define_hilbert(reqs:t_reqs) return t_define_hilbert ;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_polyphase_interpolation.vhd

  type t_define_interpolation is
  record
    param               : t_param;
    
    --blocks used in structure
    filt_arm            : t_filt_arm_add_casc;
    filt_arm_lat        : t_lat_filt_arm_add_casc;
    accum               : t_emb_calc;
    accum_lat           : t_emb_calc_details;
    accum_req           : boolean;
    base_chan_phase_param : t_casc_counters;
    data_addr_param       : t_data_address;
    data_addr_lat         : integer;
    coef_addr_param       : t_coef_address;
    coef_addr_lat         : integer;
    rfd_param             : t_rfd_gen;
    addr_cntrl_lat        : integer;

    --input buffer
    has_input_buffer      : boolean;
    input_buffer          : t_ram;
    input_buffer_in_addr  : t_twopage_address;
    input_buffer_depth    : integer;
    input_buffer_cntrl_dly: integer;
    input_buffer_lat      : integer;
    
    --symmetric structure control
    mem_param           : t_tap_memory_add_casc;
    memory_path_lat     : t_lat_tap_memory_add_casc;
  	add_sup_dly         : integer;
    
    --General control values
    base_count_op_rate  : integer;
    shorter_px_time     : boolean;
    data_dly            : integer;
    addr_dly            : integer;
    filt_dly            : integer;
    data_dly_modifier   : integer;
    first_tap_extra_dly : integer;
    sing_chan_short_block: boolean;

    --reload
    reload_cntrl_param  :t_coef_reload_cntrl;
    reload_cntrl_param_lat: t_coef_reload_cntrl_lat;

    --Core latency values
    latency             : integer;
    buffer_page_size    : integer;
    buffer_type         : integer; --0=none,1=ip,2=op

  end record;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_polyphase_interpolation.vhd

  function define_interpolation(reqs:t_reqs) return t_define_interpolation ;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_halfband_decimation.vhd

  type t_define_halfband_decimation is
  record
    param               : t_param;
    
    --blocks used in structure
    filt_arm            : t_filt_arm_add_casc;
    filt_arm_lat        : t_lat_filt_arm_add_casc;
    accum               : t_emb_calc;
    accum_lat           : t_emb_calc_details;
    accum_req           : boolean;
    base_chan_phase_param : t_casc_counters;
    data_addr_param       : t_data_address;
    data_addr_lat         : integer;
    coef_addr_param       : t_coef_address;
    coef_addr_lat         : integer;
    rfd_param             : t_rfd_gen;
    addr_cntrl_lat        : integer;

    --Center coef tap ram
    centre_tap_coef       : t_ram;
    centre_tap_coef_lat   : integer;

    --input buffer
    input_buffer          : t_ram;
    input_buffer_in_addr  : t_twopage_address;
    input_buffer_depth    : integer;
    input_buffer_lat      : integer;

    --symmetric structure control
    mem_param           : t_tap_memory_add_casc;
    memory_path_lat     : t_lat_tap_memory_add_casc;
  	cyc_to_data_out     : integer;
    cyc_to_write        : integer;
    num_cyc_read_earily : integer;
    extra_dly           : integer;
    change_src          : integer;
    add_sup_dly         : integer;
    we_sym_dly          : integer;
    
    --General control values
    base_count_op_rate  : integer;
    shorter_px_time     : boolean;
    data_dly            : integer;
    addr_dly            : integer;
    filt_dly            : integer;

    --reload
    reload_cntrl_param  :t_coef_reload_cntrl;
    reload_cntrl_param_lat: t_coef_reload_cntrl_lat;

    --Core latency values
    latency             : integer;
    buffer_page_size    : integer;
    buffer_type         : integer; --0=none,1=ip,2=op

  end record;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_halfband_decimation.vhd

  function define_halfband_decimation(reqs:t_reqs) return t_define_halfband_decimation ;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_halfband_interpolation.vhd

  type t_define_halfband_interpolation is
  record
    param               : t_param;
    
    --blocks used in structure
    filt_arm            : t_filt_arm_add_casc;
    filt_arm_lat        : t_lat_filt_arm_add_casc;
    accum               : t_emb_calc;
    accum_details       : t_emb_calc_details;
    accum_req           : boolean;
    add_partial_prod    : t_emb_calc;
    add_partial_prod_dtls : t_emb_calc_details;
    accum_extra_dly     : integer;
    base_chan_phase_param : t_casc_counters;
    data_addr_param       : t_data_address;
    data_addr_lat         : integer;
    coef_addr_param       : t_coef_address;
    coef_addr_lat         : integer;
    rfd_param             : t_rfd_gen;
--    addr_reset_dly        : integer;
    addr_cntrl_lat        : integer;
    centre_tap_coef       : t_ram;
    centre_tap_coef_lat   : integer;
    
    output_buffer         : t_ram;
    output_rate_counter   : t_casc_counters;
    output_buffer_depth   : integer;
    output_buffer_lat     : integer;
    output_rate           : integer;

    addr_hold_struct      : boolean;

    --symmetric structure control
    mem_param           : t_tap_memory_add_casc;
    memory_path_lat     : t_lat_tap_memory_add_casc;
  	cyc_to_data_out     : integer;
    cyc_to_write        : integer;
    num_cyc_read_earily : integer;
    extra_dly           : integer;
    change_src          : integer;
    add_sup_dly         : integer;
    we_sym_dly          : integer;

    --reload
    reload_cntrl_param  :t_coef_reload_cntrl;
    reload_cntrl_param_lat: t_coef_reload_cntrl_lat;

    --Core latency values
    latency             : integer;
    buffer_page_size    : integer;
    buffer_type         : integer; --0=none,1=ip,2=op

  end record;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_halfband_interpolation.vhd

  function define_halfband_interpolation(reqs:t_reqs) return t_define_halfband_interpolation ;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_polyphase_sympair_interpolation.vhd

  type t_define_sympair_interpolation is
  record
    param               : t_param;
    
    --blocks used in structure
    filt_arm            : t_filt_arm_add_casc;
    filt_arm_lat        : t_lat_filt_arm_add_casc;
    accum               : t_emb_calc;
    accum_details       : t_emb_calc_details;
    accum_lat           : integer;
    has_accum           : boolean;
    base_chan_phase_param : t_casc_counters;
    data_addr_param       : t_data_address;
    data_addr_lat         : integer;
    data_addr_odd_phase_param : t_data_address;
    data_addr_odd_phase_lat   : integer;
    coef_addr_param       : t_coef_address;
    coef_addr_lat         : integer;
    rfd_param             : t_rfd_gen;
    addr_cntrl_lat        : integer;
    output_buffer         : t_ram;
    output_rate_counter   : t_casc_counters;
    output_buffer_depth   : integer;
    output_buffer_lat     : integer;
    output_rate           : integer;
    has_output_buffer     : boolean;
    shorter_px_time       : boolean;
    data_dly_modifier     : integer;
    first_tap_extra_dly   : integer;
    use_dsp_reg_as_storage : boolean;

    --symmetric structure control
    mem_param           : t_tap_memory_add_casc;
    memory_path_lat     : t_lat_tap_memory_add_casc;
  	cyc_to_data_out     : integer;
    cyc_to_write        : integer;
    num_cyc_read_earily : integer;
    extra_dly           : integer;
    change_src          : integer;
    add_sup_dly         : integer;
    odd_and_even        : integer;
    sym_calc_odd_sym    : integer;
    we_sym_dly          : integer;

    --reload
    reload_cntrl_param  :t_coef_reload_cntrl;
    reload_cntrl_param_lat: t_coef_reload_cntrl_lat;

    --Core latency values
    latency             : integer;
    buffer_page_size    : integer;
    buffer_type         : integer; --0=none,1=ip,2=op

  end record;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_polyphase_sympair_interpolation.vhd

  function define_sympair_interpolation(reqs:t_reqs) return t_define_sympair_interpolation ;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_polyphase_pq_interpolation.vhd

  type t_define_pq_interpolation is
  record
    param               : t_param;
    
    --blocks used in structure
    filt_arm            : t_filt_arm_add_casc;
    filt_arm_lat        : t_lat_filt_arm_add_casc;
    accum               : t_emb_calc;
    accum_lat           : t_emb_calc_details;
    accum_req           : boolean;
    base_chan_param     : t_casc_counters;
    inter_param           : t_mod_counter;
    data_addr_param       : t_data_address;
    data_addr_lat         : integer;
    coef_addr_param       : t_coef_address;
    coef_addr_lat         : integer;
    rfd_param             : t_rfd_gen;
    addr_cntrl_lat        : integer;

    --input buffer
    has_input_buffer      : boolean;
    input_buffer          : t_ram;
    input_buffer_in_addr  : t_twopage_address;
    input_buffer_depth    : integer;
    input_buffer_cntrl_dly: integer;
    input_buffer_lat      : integer;

    --symmetric structure control
    mem_param           : t_tap_memory_add_casc;
    memory_path_lat     : t_lat_tap_memory_add_casc;
  	-- cyc_to_data_out     : integer;
--     cyc_to_write        : integer;
--     num_cyc_read_earily : integer;
--     extra_dly           : integer;
--     change_src          : integer;
    add_sup_dly         : integer;
    
    --General control values
    base_count_op_rate  : integer;
    shorter_px_time     : boolean;
    data_dly            : integer;
    addr_dly            : integer;
    filt_dly            : integer;
    data_dly_modifier   : integer;
    first_tap_extra_dly : integer;
    pipeline_addr_en    : integer;
    no_addr_latch       : integer;

    --reload
    reload_cntrl_param  :t_coef_reload_cntrl;
    reload_cntrl_param_lat: t_coef_reload_cntrl_lat;

    --Core latency values
    latency             : integer;
    buffer_page_size    : integer;
    buffer_type         : integer; --0=none,1=ip,2=op

  end record;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_polyphase_pq_interpolation.vhd

  function define_pq_interpolation(reqs:t_reqs) return t_define_pq_interpolation ;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_polyphase_pq_decimation.vhd

  type t_define_pq_decimation is
  record
    param               : t_param;
    
    --blocks used in structure
    filt_arm            : t_filt_arm_add_casc;
    filt_arm_lat        : t_lat_filt_arm_add_casc;
    accum               : t_emb_calc;
    accum_lat           : t_emb_calc_details;
    accum_req           : boolean;
    base_inter_chan_param : t_casc_counters;
--    inter_chan_param    : t_casc_counters;

    --deci_param            : t_mod_counter;
    --deci_param            : t_casc_counters;
    data_addr_param       : t_data_address;
    data_addr_lat         : integer;
    coef_addr_param       : t_coef_address;
    coef_addr_lat         : integer;
    rfd_param             : t_rfd_gen;
    addr_cntrl_lat        : integer;
    output_buffer         : t_ram;
    output_buffer_in_addr : t_twopage_address;
    output_buffer_out_addr: t_twopage_address;
    output_rate_counter   : t_casc_counters;
    output_buffer_depth   : integer;
    output_buffer_lat     : integer;
    extra_opb_reg         : integer;
    has_output_buffer     : boolean;
    output_rate           : integer;
    shorter_px_time       : boolean;
    data_dly_modifier     : integer;
    first_tap_extra_dly   : integer;
    use_c_port_as_storage : boolean;
    filter_sel_lat        : integer;
    
    --symmetric structure control
    mem_param           : t_tap_memory_add_casc;
    memory_path_lat     : t_lat_tap_memory_add_casc;
  	cyc_to_data_out     : integer;
    cyc_to_write        : integer;
    num_cyc_read_earily : integer;
    extra_dly           : integer;
    change_src          : integer;
    add_sup_dly         : integer;
    
    --reload
    reload_cntrl_param  :t_coef_reload_cntrl;
    reload_cntrl_param_lat: t_coef_reload_cntrl_lat;

    --Core latency values
    latency             : integer;
    sample_latency      : integer;
    buffer_page_size    : integer;
    buffer_type         : integer; --0=none,1=ip,2=op

  end record;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_polyphase_pq_decimation.vhd

  function define_pq_decimation(reqs:t_reqs) return t_define_pq_decimation ;


end sim_pkg;

-------------------------------------------------------------------------------
package body sim_pkg is

--------------------------------------------------------------------------------
--From:  ../hdl/toolbox/toolbox_pkg.vhd

function lat_addsub(has_pre_reg:integer;has_mid_reg:integer;num_mid_reg:integer) return integer is
  variable latency:integer:=1;
begin

  if has_pre_reg=1 then
    latency:=latency+1;
  end if;

  if has_mid_reg=1 then
    latency:=latency+num_mid_reg;
  end if;
  
  return latency;

end;

function lat_filt_arm_add_casc( param: t_filt_arm_add_casc) return t_lat_filt_arm_add_casc is

  constant mem_x: t_tap_memory_add_casc:=(
                  family           =>param.family,
                  implementation   =>param.implementation,
                  data_mem_type    =>param.data_mem_type,
                  coef_mem_type    =>param.coef_mem_type,
                  data_comb        =>param.data_comb,
                  data_coef_comb   =>param.data_coef_comb,
                  no_data_mem      =>param.no_data_mem,
                  coef_mem_depth   =>param.coef_mem_depth,
                  has_ce           =>param.has_ce,
                  coef_reload      =>param.reload,
                  coef_reload_depth=>param.reload_depth,
                  symmetric        =>param.symmetric );

  constant memory_path_lat :t_lat_tap_memory_add_casc:=lat_tap_memory_add_casc(mem_x);

  constant tap_x: t_emb_calc:=( family         => param.family,
                                implementation => param.implementation,
                                pre_add        => param.symmetric,
                                pre_add_func   => param.pre_add_func,
                                pre_add_ipreg  => select_integer(0,1,param.resource_opt=c_speed and param.data_mem_type=c_bram and param.no_data_mem=0),--0,
                                pre_add_midreg => select_integer(0,1,param.resource_opt=c_speed and param.data_width>get_adder_max(param.family)),--0,
                                a_delay        => select_integer( 0,
                                                                  1,
                                                                  -- (memory_path_lat.coef-memory_path_lat.data>0) or
--                                                                   (param.data_cascade=1) ),
                                                                  (memory_path_lat.coef-memory_path_lat.data>0) and
                                                                  (param.data_cascade=0) ),
                                b_delay        => select_integer( 0,
                                                                  1,
                                                                  memory_path_lat.coef-memory_path_lat.data<0),
                                a_src          => param.data_cascade,
                                --c_src          => 1, --alway from another DSP
                                a_sign         => param.data_sign,
                                b_sign         => param.coef_sign,
                                d_sign         => param.data_sign,
                                reg_opcode     => 0,
                                implement_extra_b_dly => 0 );
  
  constant tap_x_dtls :t_emb_calc_details:=dtls_emb_calc(tap_x);
  --should use the first tap as a guide to latency for output so need to consider when data cascade is used.

  variable latency:t_lat_filt_arm_add_casc;
  
  constant num_split_col:integer:=param.num_split_col;--calc_num_split_col(param.num_taps,param.col_len);

  constant srl16base_depth:integer:=select_integer(17,33,param.family=v5);
  variable tap_slices: integer;
begin

  --latency.latched:=0;--param.num_taps*param.base_data_space;
  latency.cascaded:=param.num_taps-1+((num_split_col-1)*(param.inter_split_col_dly+1));
  --latency.tap:=get_min(memory_path_lat.data,memory_path_lat.coef)+dtls_emb_calc(tap_x).latency;
  latency.tap:=get_min(memory_path_lat.data,memory_path_lat.coef)+tap_x_dtls.latency;
  latency.sym_inter_buff_depth:=1;--this needs populated when nd parallel sym.
  if (param.no_data_mem=1 and param.sym_para_struct=1 and param.symmetric=1) then
    latency.sym_inter_buff_depth:=(param.num_taps-1)*(param.inter_tap_delay-1);
  end if;
  if (param.no_data_mem=1 and param.sym_para_struct=3 and param.symmetric=1) then
    latency.sym_inter_buff_depth:=(2*(param.num_taps-1)*(param.inter_tap_delay-1))+select_integer(0,param.inter_sym_tap_delay-1,param.odd_symmetry=0);
  end if;

  latency.pre_add_ipreg:=tap_x_dtls.pre_add_ipreg;
  latency.pre_add_midreg:=tap_x_dtls.pre_add_midreg;
  latency.coef_addr_extra_delay:=tap_x_dtls.extra_b_dly;
  
  latency.para_sym_slice_est:=0;
  if (param.no_data_mem=1 and param.symmetric=1) then
    for tap in 1 to param.num_taps loop
      --other para structures est not supported.
      if param.sym_para_struct=1 then
        tap_slices:=((param.num_taps-tap)*(param.inter_sym_tap_delay-1));
        tap_slices:=(tap_slices/srl16base_depth)+select_integer(0,1,tap_slices rem srl16base_depth > 0);
        --above is LUT/MEM per bit for delay
        tap_slices:=tap_slices+1;--plus 1 for latch reg
        tap_slices:=tap_slices*param.data_width;
        latency.para_sym_slice_est:=latency.para_sym_slice_est+tap_slices;
        --report "SLICE EST: tap: "&int_to_str(tap)&" est: "&int_to_str(tap_slices)&" accumed: "&int_to_str(latency.para_sym_slice_est);
      elsif param.sym_para_struct=3 then
        tap_slices:=(2*((param.num_taps-tap)*(param.inter_sym_tap_delay-1)))+select_integer(0,param.inter_sym_tap_delay-1,param.odd_symmetry=0);
        tap_slices:=(tap_slices/srl16base_depth)+select_integer(0,1,tap_slices rem srl16base_depth > 0);
        --above is LUT/MEM per bit for delay
        tap_slices:=tap_slices*param.data_width;
        latency.para_sym_slice_est:=latency.para_sym_slice_est+tap_slices;
        --report "SLICE EST: tap: "&int_to_str(tap)&" est: "&int_to_str(tap_slices)&" accumed: "&int_to_str(latency.para_sym_slice_est);
      end if;
    end loop;
  end if;

  return latency;
end;

function count_col(cur_col:integer;col_len:t_col_len) return integer is
  variable total:integer:=0;
begin
  if (cur_col>0) then
    for i in 0 to cur_col-1 loop
      total:=total+col_len(i);
    end loop;
  end if;
  
  return total;
end;

function calc_num_split_col(num_taps:integer;col_len:t_col_len) return integer is
  variable num_cols:integer:=0;
  variable tap_count:integer:=col_len(0);
begin
  --report "FIR:calc_num_split_col:num_taps: "&int_to_str(num_taps);
  while tap_count<num_taps loop
    --report "FIR:calc_num_split_col:tap_count: "&int_to_str(tap_count);
    num_cols:=num_cols+1;
    tap_count:=tap_count+col_len(num_cols);
  end loop;
  -- report "FIR:calc_num_split_col:tap_count: "&int_to_str(tap_count);
--   report "FIR:calc_num_split_col:num_cols: "&int_to_str(num_cols);
  return num_cols+1;
end;

function lat_ram( param: t_ram; num_ports:integer) return integer is
begin
  if (param.mem_type=c_srl16) then
    return 1;--srl16, from address to dataout but from we to data out is really 2 cycles
  else
    if (num_ports=2) then
      if (param.mem_type=c_dram) then
        return 1;  --dram
      else
        return 2;  --bram
      end if;
    else
      if (param.mem_type=c_bram) then
        return 2;  --bram
      else
        --dram
        if (param.write_mode=1) then
          return 2;
        else
          return 1;
        end if;
      end if;
    end if;
  end if;
end;

function lat_tap_memory_add_casc( param: t_tap_memory_add_casc) return t_lat_tap_memory_add_casc is
  variable latency: t_lat_tap_memory_add_casc;
  constant data_ram_param: t_ram:=( family              => param.family,
                                    implementation      => param.implementation,
                                    mem_type            => param.data_mem_type,--select_integer(param.data_mem_type,1,param.data_coef_comb=1),
                                    write_mode          => 1,--write first
                                    has_ce              => param.has_ce,
                                    use_mif             => 0 );

  constant coef_ram_param: t_ram:=( family              => param.family,
                                    implementation      => param.implementation,
                                    mem_type            => param.coef_mem_type,--select_integer(param.coef_mem_type,1,param.data_coef_comb=1),
                                    write_mode          => select_integer(0,1,
                                                              --(param.coef_reload=1 and param.coef_mem_type=c_bram) or
                                                              (param.data_coef_comb=1) ),
                                    has_ce              => param.has_ce,
                                    use_mif             => 1 );
begin

  -- if param.data_comb=1 then
--     --dp data ram
--     latency.data:=lat_ram(data_ram_param,2);
--     --sp coef ram
--     latency.coef:=lat_ram(coef_ram_param,1);
--
--   elsif param.data_coef_comb=1 then
--     --dp data and coef ram
--     latency.data:=lat_ram(coef_ram_param,2);
--     latency.coef:=lat_ram(coef_ram_param,2);
--   else
--     --sp data and coef ram
--     latency.data:=lat_ram(data_ram_param,1);
--     latency.coef:=lat_ram(coef_ram_param,1);
--   end if;
  
  --Data
  if param.no_data_mem=1 then
    latency.data:=0;
  elsif param.data_comb=1 then
    --dp data ram
    latency.data:=lat_ram(data_ram_param,2);
  elsif param.data_coef_comb=1 then
    --dp data ram
    --latency.data:=lat_ram(coef_ram_param,2);
    latency.data:=lat_ram(data_ram_param,2);
  else
     --sp data ram
    latency.data:=lat_ram(data_ram_param,1);
  end if;
  
  --Coef
  if param.coef_reload=1 then
    if param.coef_mem_type=c_dram then
      --effectively sp
      --latency.coef:=lat_ram(coef_ram_param,1);
      latency.coef:=lat_ram(coef_ram_param,2);
    else
      --dp ram
      latency.coef:=lat_ram(coef_ram_param,2);
    end if;
  elsif param.data_coef_comb=1 then
    --dp coef ram
    latency.coef:=lat_ram(coef_ram_param,2);
  else
    --sp coef ram
    if param.coef_mem_depth>1 then
      latency.coef:=lat_ram(coef_ram_param,1);
    else
      --constant
      latency.coef:=0;
    end if;
  end if;

  return latency;
end;

function dtls_emb_calc(param:t_emb_calc) return t_emb_calc_details is
  variable details : t_emb_calc_details;
  variable a_dly: integer:=0;
begin
  --Latency
  details.latency:=0;
  details.pre_add_ipreg:=0;
  details.pre_add_midreg:=0;
  details.extra_b_dly:=0;

  case param.family is
  when v4 | v5 =>
    if (param.pre_add=1) then
      --fabric pre add
      details.latency:=details.latency+lat_addsub(param.pre_add_ipreg,param.pre_add_midreg,1);--lat_addsub(0);
      details.pre_add_ipreg:=param.pre_add_ipreg;
      details.pre_add_midreg:=param.pre_add_midreg;
    end if;
    details.latency:=details.latency+get_max(
                                      select_integer(
                                        0,
                                        param.a_delay,
                                        param.pre_add=0),
                                      param.b_delay);
    details.latency:=details.latency+3;--standard dly in dsp48
    
    a_dly:=select_integer(0,lat_addsub(param.pre_add_ipreg,param.pre_add_midreg,1)-param.a_delay,
                          param.pre_add=1);
    details.extra_b_dly:=get_max(0,param.b_delay+a_dly-1);

  when s3ax =>
    if (param.pre_add=1) then
      details.latency:=details.latency+1;
    end if;
    --details.latency:=details.latency+get_max(param.a_delay,param.b_delay);
    details.latency:=details.latency+get_max(
                                      select_integer(
                                        0,
                                        param.a_delay,
                                        param.pre_add=0),
                                      param.b_delay);
    details.latency:=details.latency+3;

    if param.b_delay=1 and param.pre_add=1 then
      details.extra_b_dly:=1;
    end if;

  when others =>
    null;
  end case;

  --Opcode width
  case param.family is
  when v4 | v5 =>
    details.op_code_width:=7;
  when s3ax =>
    details.op_code_width:=4;
  when others =>
    details.op_code_width:=1;
  end case;

  return details;
end;

function opcode_emb_calc(func:t_emb_calc_func;param:t_emb_calc) return std_logic_vector is
  constant details:t_emb_calc_details:=dtls_emb_calc(param);
  variable opcode:std_logic_vector(details.op_code_width-1 downto 0);
begin

  case param.family is
  when v4 | v5 =>
    case func is
      when PCIN =>
        opcode:="0010000";
      when PCIN_add_P =>
        opcode:="0010010";
      when PCIN_add_C =>
        opcode:="0011100";
      when NOP =>
        opcode:="0000010";--hold P
      when PCIN_add_A_mult_B =>
        opcode:="0010101";
      when A_mult_B =>
        opcode:="0000101";
      when P_add_A_mult_B =>
        opcode:="0100101";
      when C_add_A_mult_B =>
        opcode:="0110101";
      when P_add_A_concat_B =>
        opcode:="0100011";
      when P_add_P =>
        opcode:="0100010";
      when C_add_C =>
        opcode:="0111100";
      when PCIN_add_A_concat_B =>
        opcode:="0010011";
      when P_add_C =>
        opcode:="0101100";
      when A_concat_B =>
        opcode:="0000011";
      when C_add_A_concat_B =>
        opcode:="0110011";
      when C =>
        opcode:="0110000";
    end case;
  when s3ax =>   --muxZ(3:2) & muxX(1:0)   ( does Z - X )
     case func is
      when PCIN =>
        opcode:="0100";
      when PCIN_add_P =>
        opcode:="0110";
      when PCIN_add_C =>
        opcode:="0000";--not supported
        report "FIR: Unsupported opcode for family" severity failure;
      when NOP =>
        opcode:="0010";
      when PCIN_add_A_mult_B =>
        opcode:="0101";
      when A_mult_B =>
        opcode:="0001";
      when P_add_A_mult_B =>
        opcode:="1001";
      when C_add_A_mult_B =>
        opcode:="1101";
      when P_add_A_concat_B =>
        opcode:="1011";
      when P_add_P =>
        opcode:="1010";
      when C_add_C =>
        opcode:="0000";--not supported
        report "FIR: Unsupported opcode for family" severity failure;
      when PCIN_add_A_concat_B =>
        opcode:="0111";
      when P_add_C =>
        opcode:="1110";
      when A_concat_B =>
        opcode:="0011";
      when C_add_A_concat_B =>
        opcode:="1111";
      when C =>
        opcode:="1100";
    end case;
  when others =>
    opcode:=(others=>'0');
  end case;
  
  return opcode;

end;

function add_c( condition:t_counter_priority) return t_counter_clause is
  variable return_val:t_counter_clause;
begin
  return_val.condition:=condition;
  return_val.operation:=add_constant;
  return return_val;
end;

function add_x( condition:t_counter_priority) return t_counter_clause is
  variable return_val:t_counter_clause;
begin
  return_val.condition:=condition;
  return_val.operation:=add_x_val;
  return return_val;
end;

function sub_x( condition:t_counter_priority) return t_counter_clause is
  variable return_val:t_counter_clause;
begin
  return_val.condition:=condition;
  return_val.operation:=sub_x_val;
  return return_val;
end;

function lat_data_address(param:t_data_address) return integer is
  constant no_base:integer:=select_integer(0,1,param.base_cnt*param.block_cnt = 1);
  variable latency:integer;
begin
  if no_base=1 then
    --addr is not used in this scenario?
    if param.block_cnt>1 and param.srl16_sequence=1 then
      if param.mem_type=c_srl16 then
        --return 2;
        latency:=2;
      else
        --return 1;
        latency:=1;
      end if;
    else
      --return 0;
      latency:=0;
    end if;
  elsif param.symmetric=1 then
    if param.mem_type>c_srl16 then
      if param.block_cnt>1 and (param.addr_packed=1 and not
                                                            ((is_pow_of_2(param.base_cnt) and param.combined=0) or
                                                             (is_pow_of_2(param.base_cnt) and
                                                              is_pow_of_2(param.block_cnt*param.base_cnt) and
                                                              param.combined=1)) ) then
        --return 3;
        latency:=3;
      else
        --return 2;
        latency:=2;
      end if;
    else
      --return 1;
      latency:=1;
    end if;
  else
    if param.block_cnt>1 and (param.addr_packed=1 and not is_pow_of_2(param.base_cnt) and param.mem_type>c_srl16) then
      --return 2;
      latency:=2;
    else
      if param.mem_type=c_srl16 and param.srl16_sequence=1 then
        --return 2;
        latency:=2;
      else
        --return 1;
        latency:=1;
      end if;
    end if;
  end if;

  if param.resource_opt=c_speed and param.family=s3ax then
    latency:=latency+1;
  end if;

  return latency;

end;

function lat_coef_address(param:t_coef_address) return integer is

  constant max_depth:integer:=select_integer(32,64,param.family=v5);

  constant effective_num_filters: integer:=(2**log2roundup(param.num_filters))*select_integer(1,2,param.multi_page_reload=1);

  constant decode_rom_param: t_ram:=( family              => param.family,
                                      implementation      => param.implementation,
                                      mem_type            => c_dram,--select_integer(c_dram,c_bram,effective_num_filters>max_depth),
                                      write_mode          => 0,--read first
                                      has_ce              => param.has_ce,
                                      use_mif             => 1 );

  constant decode_rom_lat:integer:=lat_ram(decode_rom_param,1);--sp ram
  
  constant no_base:integer:=select_integer(0,1,param.base_cnt*param.block_cnt = 1);
  variable latency:integer;
begin
  if (effective_num_filters>1 and param.addr_packed=1) then
    if no_base=0 then
      --return decode_rom_lat+2;--1 for normal address generation and 1 for adder to combine offset and base
      latency:=decode_rom_lat+2;
    else
      --return decode_rom_lat;
      latency:=decode_rom_lat+1;
    end if;
  else
    if no_base=0 then
      --return 1;
      latency:=1;
    else
      --return 0;
      latency:=0;
    end if;
  end if;
  
  if (param.resource_opt=c_speed and param.family=s3ax and not(effective_num_filters>1 and param.addr_packed=1)) then
    latency:=latency+1;
    if effective_num_filters>1 and no_base=1 then
      --special delay to get correct effect
      latency:=latency+1;
    end if;
  end if;

  return latency;
end;

function lat_coef_reload_cntrl(param:t_coef_reload_cntrl) return t_coef_reload_cntrl_lat is
  variable latency:t_coef_reload_cntrl_lat;
  
  constant srl16_mem_depth_thres: integer:=select_integer(32,64,
                                                          param.family=v5);
  constant dram_mem_depth_thres: integer:=select_integer(16,32,
                                                         param.family=v5);

  constant reload_base_cnt_param: t_casc_counters:=(
      cnt1_max_val    => 1,
      cnt2_max_val    => param.reload_base_cnt,
      cnt3_max_val    => 1,
      cnt2_max_qual   => 0,
      family          => param.family,
      implementation  => param.implementation );

  constant coef_reload_addr_param: t_coef_address:=(
      family          => param.family,
      implementation  => param.implementation,
      base_cnt        => param.reload_base_cnt,
      block_cnt       => 1,
      addr_packed     => param.coef_addr_packed,
      addr_width      => get_max(1,log2roundup( param.coef_mem_depth )),
      num_filters     => param.num_filts,--*2,
      multi_page_reload => 1,
      offset          => 0,
      has_ce          => param.has_ce,
      use_count_src   => 1,
      en_dly            => 0,
      base_max_dly      => 0,
      skip_base_max_dly => 0,
      count_max_dly     => 0,
      filt_sel_dly      => 0,
      resource_opt      => param.resource_opt);

  constant coef_reload_addr_lat: integer:=lat_coef_address(coef_reload_addr_param);

  constant coef_reload_page_ram: t_ram:=(
          family              => param.family,
          implementation      => param.implementation,
          mem_type            => c_dram,--select_integer(c_dram,c_bram,param.num_filts>dram_mem_depth_thres),
          write_mode          => 0,--read first
          has_ce              => param.has_ce,
          use_mif             => 0 );


  constant coef_reload_page_ram_lat:integer:=lat_ram(coef_reload_page_ram,2);

begin
  if param.num_filts=1 then
    latency.filt_sel_lat:=1;  --not sure about putting 1 here
    latency.reload_lat:=coef_reload_addr_lat+2;--1; --extra 1 for generation of reload_we
  else
    latency.filt_sel_lat:=coef_reload_page_ram_lat+1;--+1 for latching of page
    latency.reload_lat:=coef_reload_page_ram_lat+coef_reload_addr_lat+2+1;--1; --extra 1 for generation of reload_we, another 1 for latching coef_filt_sel
  end if;

  return latency;
end;

function ram_content(depth: integer; width: integer; use_mif: integer; mif_file:string) return ramTypeMax is
  variable ram_init    : ramTypeMax(0 to depth-1):=(others=>(others=>'0'));
  file     filepointer : text;-- open read_mode is filename;
  variable mif_status  : file_open_status;
  variable lines       : integer := 0;
  variable dataline    : line;
  variable binstring   : string(1 to width);
  --variable binvector   : bit_vector(width-1 downto 0);
  --variable dataline_len:integer;
  variable read_from_line_OK : boolean;
begin
  if use_mif=0 then
    ram_init:=(others=>(others=>'0'));
  else
    file_open(mif_status,filepointer,mif_file,read_mode);

    while (not(endfile(filepointer)) and (lines < depth)) loop
    --for i in 0 to depth-1 loop --assume enough content in file
      readline(filepointer, dataline);
      exit when endfile(filepointer);
      read(dataline, binstring);
      ram_init(lines)(width-1 downto 0):=string_to_slv(binstring,width);
      lines:=lines+1;
    end loop;

--     loop
--       if lines < depth then
--         readline(filepointer, dataline);
--         
--         report "FIR: ram_content: line "&int_to_str(lines)&" depth "&int_to_str(depth);
-- 
--         --read(dataline, binstring,read_from_line_OK);
--         read(dataline, binvector,read_from_line_OK);
-- 
--         -- report "FIR: ram_content: binstring "&binstring severity warning;
-- --
--         if read_from_line_OK = true then
--           ram_init(lines)(width-1 downto 0):=bv_to_slv(binvector);--string_to_slv(binstring,width);
--           lines:=lines+1;
--         else
--           report "FIR: ram_content: read from line failed";
--           exit;
--         end if;
-- 
--       else
--         report "FIR: ram_content: read all lines";
--         exit;
--       end if;
-- 
--       if endfile(filepointer) then
--         report "FIR: ram_content: exit eof";
--         exit;
--       end if;
--     end loop;

    file_close(filepointer);
  end if;

  return ram_init;
end;

function family_str( family:t_family) return string is
begin
  case family is
    when v2  =>
      return "virtex2";
    when v4  =>
      return "virtex4";
    when v5  =>
      return "virtex5";
    when s3ax  =>
      --return "spartan3adsp";
      return "spartan3";
      --currently no support for spartan3adsp, only need for shift_ram baseblock
    when others =>
      report "ERROR: unknown family type";
      return "";
  end case;
end;

function ext_bus(input_bus: std_logic_vector; width:integer; sign: integer) return std_logic_vector is
variable return_bus: std_logic_vector(width-1 downto 0);
constant input_width:integer:=input_bus'high + 1 - input_bus'low;
begin

  if ( input_width< width ) then
    --extend or pad
    return_bus(input_width-1 downto 0):=input_bus;
    
    if (sign=c_signed) then --signed
      --extend remaing bits with sign
      return_bus((width-1) downto input_width) := (others=>input_bus(input_bus'high));
    else            --unsigned
      --pad remaing bits with 0
      return_bus((width-1) downto input_width) := (others=>'0');
    end if;

  elsif (input_width=width) then
    --same width
    return_bus := input_bus;
  else
    --larger
    return_bus := input_bus((width-1)+input_bus'low downto input_bus'low);
  end if;

  return return_bus;
end;

function select_integer (
         i0  : integer;
         i1  : integer;
         sel : boolean)
         return integer is
begin
  if sel then
    return i1;
  else
    return i0;
  end if; -- sel
end select_integer;

function select_string (
         i0  : string;
         i1  : string;
         sel : boolean)
         return string is
begin
  if sel then
    return i1;
  else
    return i0;
  end if; -- sel
end select_string;

function select_slv (
         i0  : std_logic_vector;
         i1  : std_logic_vector;
         sel : boolean)
         return std_logic_vector is
begin
  if sel then
    return i1;
  else
    return i0;
  end if; -- sel
end select_slv;

function select_sl (
         i0  : std_logic;
         i1  : std_logic;
         sel : boolean)
         return std_logic is
begin
  if sel then
    return i1;
  else
    return i0;
  end if; -- sel
end select_sl;

function bmg2v1_bram_prim_sel(width:integer;depth:integer) return integer is
variable widthOK: integer;
begin
  
  widthOK:=width;
  while widthOK>0 loop

    if (v4_bram_depth(widthOK)>=depth) then
      return bmg2v1_bram_prim(widthOK);
    else
      widthOK:=widthOK-1;
    end if;
  end loop;
  
  report "MEMORY PRIMITIVE WARNING: unable to find deep enough memory primative" severity WARNING;
  return bmg2v1_bram_prim(1);--return deepest primative

end bmg2v1_bram_prim_sel;

function str_ext(src:string;dest_len:integer) return string is
  --constant dest_len:integer:=dest'HIGH;
  variable fill_str:string(dest_len downto 1);
begin
  fill_str(src'HIGH downto 0):=src;
  return fill_str;
end str_ext;

function split_bus( index:integer; bus_in:std_logic_vector; bus_width:t_int_array) return std_logic_vector is
  variable return_bus:std_logic_vector(bus_width(index+bus_width'LOW)-1 downto 0);
  variable index_bottom:integer:=0;
begin
  -- report "FIR: split_bus: index: "&int_to_str(index);
--   report "FIR: split_bus: num_buses: "&int_to_str(bus_width'HIGH-bus_width'LOW+1);
  if (index<=bus_width'HIGH-bus_width'LOW+1) then

    if (index>0) then
      for i in 0 to index-1 loop
        index_bottom:=index_bottom+bus_width(i+bus_width'LOW);
      end loop;
    end if;
    
    return_bus:=bus_in(bus_width(index+bus_width'LOW)+index_bottom-1+bus_in'LOW downto index_bottom+bus_in'LOW);

  else
    report "split_bus: invalid bus index" severity failure;
  end if;
  
  return return_bus;
end;

function is_pow_of_2(val:integer) return boolean is
  variable pow:integer:=0;
begin
  while 2**pow <= val loop
    if 2**pow = val then
      return true;
    end if;
    pow:=pow+1;
  end loop;
  return false;
end;

function slv_to_string (
         bitsin : std_logic_vector;
         nbits  : integer)
         return string is
  variable ret     : string(1 to nbits);
  variable bit_num : integer;
begin
  ret := (others => '0');

  bit_num := 1;

  for i in bitsin'range loop

    if bitsin(i) = '1' then
      ret(bit_num) := '1';
    elsif bitsin(i) = '0' then
      ret(bit_num) := '0';
    elsif (bitsin(i) = 'L') then
      ret(bit_num) := 'L';
    elsif (bitsin(i) = 'H') then
      ret(bit_num) := 'H';
    elsif (bitsin(i) = 'Z') then
      ret(bit_num) := 'Z';
    elsif (bitsin(i) = 'W') then
      ret(bit_num) := 'W';
    elsif (bitsin(i) = 'U') then
      ret(bit_num) := 'U';
    elsif (bitsin(i) = 'X') then
      ret(bit_num) := 'X';
    elsif (bitsin(i) = '-') then
      ret(bit_num) := '-';
    else
      assert false
        report "ERROR: fir_compiler_v3_0 : invalid character passed to ";-- &
        report "slv_to_string function."-- & UTILS_PKG_new_line
        severity failure;
    end if;

    bit_num := bit_num + 1;

    if bit_num > nbits then
      EXIT; -- Ignore ms bits in SLV if SLV is longer than string
    end if;
  end loop;

  return ret;

end;

function string_to_slv (
         bitsin : string;
         nbits  : integer)
         return std_logic_vector is

  -- string types range from 1 to len!!!
  variable ret     : std_logic_vector(nbits-1 downto 0);
  variable bit_num : integer;
begin

  ret := (others => '0');

  if (bitsin'LENGTH = 0) then -- Make all '0's
    return ret;
  end if;

  bit_num := 0;

  for i in bitsin'high downto bitsin'low loop

    if bitsin(i) = '1' then
      ret(bit_num) := '1';
    elsif bitsin(i) = '0' then
      ret(bit_num) := '0';
    elsif (bitsin(i) = 'U' or bitsin(i) = 'u') then
      ret(bit_num) := 'U';
    elsif (bitsin(i) = 'X' or bitsin(i) = 'x') then
      ret(bit_num) := 'X';
    elsif (bitsin(i) = 'Z' or bitsin(i) = 'z') then
      ret(bit_num) := 'Z';
    elsif (bitsin(i) = 'W' or bitsin(i) = 'w') then
      ret(bit_num) := 'W';
    elsif (bitsin(i) = 'L' or bitsin(i) = 'l') then
      ret(bit_num) := 'L';
    elsif (bitsin(i) = 'H' or bitsin(i) = 'h') then
      ret(bit_num) := 'H';
    elsif (bitsin(i) = '-') then
      ret(bit_num) := '-';
    else
      assert false
        report "ERROR: invalid character passed to string_to_std_logic_vector function.";
        report " string passed in was: " & bitsin
        severity failure;
    end if;

    bit_num := bit_num + 1;

    if bit_num >= nbits then
      EXIT; -- Ignore ms characters in string if string is longer than BV
    end if;
  end loop;

  return ret;

end;

function family_val( c_family: string) return t_family is
begin
  if c_family="virtex5" then
    return v5;
  elsif c_family="virtex4" or c_family="avirtex4" then
    return v4;
  elsif c_family="spartan3adsp" then
    return s3ax;
  else
    return v2;
  end if;
end;

function get_adder_max( family: t_family) return integer is
begin
  if family/=s3ax then
    return 12;
  else
    return 8;
  end if;
end;

--------------------------------------------------------------------------------
--From:  ../hdl/mif_file/mif_file_pkg.vhd

function convert_bin_mif_to_hex (
         elab_dir   : string;
         mif_file   : string;
         num_taps   : integer;
         coef_width : integer;
         num_filts  : integer )
         return integer is
         
variable coefficients : t_coefficients(num_filts*num_taps-1 downto 0);

variable write_res : integer;

constant elab_mif_file : string := elab_dir & mif_file;

begin

  -- Check number of entries in input mif file
  if (get_number_of_inputs(elab_mif_file) < num_taps*num_filts) then
  -- Changed for XST, getnuminput seemed to return one more than in file
    
    report "input binary mif file has incorrect number of values" severity note;
    --report UTILS_PKG_int_to_string(get_number_of_inputs(mif_file)) severity note;
    --report UTILS_PKG_int_to_string(num_taps*num_filts ) severity note;
  
  else
    
    -- Fetch all the binary coefficients from the mif file
    coefficients(num_filts*num_taps-1 downto 0) :=
                     read_coef_data_bin( elab_mif_file,
                                         num_taps*num_filts,
                                         coef_width,
                                         0);

    -- Create filenames for mac mif files and mif files
    write_res := write_coef_data_hex( elab_dir
                                    & "hex_" 
                                    & mif_file,
                                      num_taps*num_filts,
                                      coef_width,
                                      coefficients         );

  end if;

  return 1; -- convert_bin_mif_to_hex;
end;

function read_coef_data ( filename         : string;
                          number_of_values : integer;
                          coef_width       : integer;
                          offset           : integer )
                          return t_coefficients is

  variable data        : t_coefficients(number_of_values-1 downto 0);
  file     filepointer : text;-- open read_mode is filename;
  variable dataline    : line;
  constant width       : integer := (coef_width + 3)/4;
                       -- Number of hex values, this will cause any extra
                       -- characters to be ignored if more than need for
  variable hexstring   : string(1 to width);
  variable lines       : integer := 0;
  variable mif_status  : file_open_status;

begin

  -- report "*** read_coef_data ***" severity note;
--   report "MIF_FILE   : " & filename severity note;
--   report "COEF_WIDTH : " & int_to_str(coef_width) severity note;
--   report "OFFSET     : " & int_to_str(offset) severity note;
    
  file_open(mif_status,filepointer,filename,read_mode);

  while (not(endfile(filepointer)) and (lines < number_of_values+offset)) loop
    readline(filepointer, dataline);
    read(dataline, hexstring);
--     report "Read hex value - " & hexstring;
    if (lines>(offset-1)) then
      data(lines-offset)(coef_width-1 downto 0) := hex_to_std_logic_vector(hexstring,coef_width);
      -- report "Wrote binary value - " &
--              slv_to_string(data(lines-offset)(coef_width-1 downto 0),coef_width)
--              severity note;
    end if;
    lines := lines + 1;
  end loop;
  
  file_close(filepointer);

  -- for taps in 0 to number_of_values-1 loop
--     report "Return data: "&slv_to_string(data(taps)(coef_width-1 downto 0),coef_width);
--   end loop;

  return data;

end read_coef_data;

function read_coef_data_bin ( filename         : string;
                              number_of_values : integer;
                              coef_width       : integer;
                              offset           : integer )
                              return t_coefficients is

  variable data        : t_coefficients(number_of_values-1 downto 0);
  file     filepointer : text;-- open read_mode is filename;
  variable dataline    : line;
  variable binstring   : string(1 to coef_width);
  variable bitval      : std_logic_vector((coef_width-1) downto 0);
  variable lines       : integer := 0;
  variable mif_status  : file_open_status;

begin

  file_open(mif_status,filepointer,filename,read_mode);
  
  while (not(endfile(filepointer)) and (lines < number_of_values+offset)) loop
    readline(filepointer, dataline);
    read(dataline, binstring);
    
    if (lines>(offset-1)) then
      data(lines-offset)(coef_width-1 downto 0) := string_to_slv(binstring,coef_width);
    end if;
    lines := lines + 1;
    --report filename;
    --report UTILS_PKG_int_to_string(lines);
  end loop;
  
  file_close(filepointer);
  
  return data;
end read_coef_data_bin;

function write_coef_data_hex ( filename         : string;
                               number_of_values : integer;
                               coef_width       : integer;
                               coef_data        : t_coefficients )
                               return integer is

  file     filepointer : text;
  variable mif_status  : file_open_status;
  constant hexlength   : integer := (coef_width+3)/4;
  variable hex_string  : string(1 to hexlength);
  variable write_line  : line;
  --variable write_line_bv: bit_vector((coef_width - 1) downto 0);
  variable bitchar     : character;

begin

  file_open(mif_status,filepointer,filename,write_mode); 
  --Rewritten to work with XST, copied Bill's function

  for loc in 0 to number_of_values-1 loop
    hex_string := std_logic_vector_to_hex(coef_data(loc)(coef_width-1 downto 0));
    --report "WRITE_COEF_DATA_HEX :" severity note;
    --report UTILS_PKG_int_to_string(loc) severity note;
    --report hex_string;
    write(write_line,hex_string);
    writeline(filepointer,write_line);
  end loop;

  file_close(filepointer);

  return 0;
end write_coef_data_hex;

function write_coef_data ( filename         : string;
                           number_of_values : integer;
                           coef_width       : integer;
                           coef_data        : t_coefficients )
                           return integer is

  file     filepointer: text;
  variable mif_status  : file_open_status;
  variable write_line: line;
  variable write_line_slv: std_logic_vector((coef_width - 1) downto 0);
  --variable write_line_bv: bit_vector((coef_width - 1) downto 0);
  variable bitchar: character;

begin

  file_open(mif_status,filepointer,filename,write_mode);
  --Rewritten to work with XST, copied Bill's function

  for loc in 0 to number_of_values-1 loop
    write_line_slv:=std_logic_vector'(coef_data(loc)(coef_width-1 downto 0));
    -- report UTILS_PKG_int_to_string(to_integer(unsigned(write_line_slv)) ) severity note;
    -- write(write_line,slv_to_bv(write_line_slv));
    for bitloop in 0 to coef_width-1 loop
      if (write_line_slv((coef_width-1)-bitloop)='1') then
        --write_line_bv(bitloop):='1';
        bitchar:='1';
      else
        --write_line_bv(bitloop):='0';
        bitchar:='0';
      end if;
      write(write_line,bitchar);
    end loop;
    --write(write_line,write_line_bv);
    writeline(filepointer,write_line);
  end loop;

  file_close(filepointer);

  return 0;
end write_coef_data;

function read_mem_mif_file(filename: string; number_of_values: integer; coef_width: integer; offset:integer) return t_coefficients is

variable data       : t_coefficients(number_of_values-1 downto 0);
file     filepointer: text;-- open read_mode is filename;
variable dataline   : line;
variable width      : integer := (coef_width + 3)/4;     -- number of hex values, this will cause any extra characters to be ignored if more than need for
variable binstring  : string(1 to coef_width);--width);
variable read_result:boolean;
variable bitval     : std_logic_vector((coef_width - 1) downto 0);
variable lines      : integer := 0;
variable mif_status  : file_open_status;

begin

        file_open(mif_status,filepointer,filename,read_mode);

        --report int_to_str(coef_width) severity note;

        while (not(endfile(filepointer)) and (lines < number_of_values+offset)) loop
                
                -- report int_to_str(lines) severity note;
                -- report int_to_str(number_of_values+offset) severity note;

                readline(filepointer, dataline);
                read(dataline, binstring,read_result);

                ASSERT read_result
                REPORT "Error: problem reading memory initialization file"
                SEVERITY FAILURE;
                
                for bitloop in 1 to coef_width loop
                        if (binstring(bitloop)='1') then
                                bitval(coef_width-bitloop):='1';
                        else
                                bitval(coef_width-bitloop):='0';
                        end if;
                end loop;

                if (lines>(offset-1)) then
                        data(lines-offset)(coef_width-1 downto 0) := bitval;
                        --hex_to_std_logic_vector(hexstring,coef_width);
                end if;
                lines := lines + 1;
        end loop;
        
        file_close(filepointer);
        
        return data;
end read_mem_mif_file;

function get_number_of_inputs(filename: string) return integer is
file     inpfile    : text;-- open read_mode is filename;
variable oneline    : line;
variable decvalue   : integer;
variable count      : integer := 0;
variable mif_status  : file_open_status;

begin
        report "*** get_number_of_inputs ***" severity note;
        report "MIF_FILE : " & filename severity note;
        
        file_open(mif_status,inpfile,filename,read_mode);

        while (not(endfile(inpfile))) loop
                readline(inpfile, oneline);
                count := count + 1;
        end loop;
        
        file_close(inpfile);
        return count;
end get_number_of_inputs;

function hex_to_std_logic_vector( hexstring: string; width: integer) RETURN std_logic_vector IS

constant length   : integer := hexstring'length;
--variable bitval   : std_logic_vector((max_width - 1) downto 0);
variable bitval   : std_logic_vector(((length*4) - 1) downto 0);
variable posn     : integer := ((length * 4) - 1);
variable ch       : character;

begin
  -- initialize the return std_logic_vector to all 0's
  bitval := (others => '0');
  -- loop through each character and convert to the equivalent hex bits
  for i in 1 to length loop
    ch := hexstring(i);
    case ch is
      when '0'        => bitval(posn downto posn - 3) := "0000";
      when '1'        => bitval(posn downto posn - 3) := "0001";
      when '2'        => bitval(posn downto posn - 3) := "0010";
      when '3'        => bitval(posn downto posn - 3) := "0011";
      when '4'        => bitval(posn downto posn - 3) := "0100";
      when '5'        => bitval(posn downto posn - 3) := "0101";
      when '6'        => bitval(posn downto posn - 3) := "0110";
      when '7'        => bitval(posn downto posn - 3) := "0111";
      when '8'        => bitval(posn downto posn - 3) := "1000";
      when '9'        => bitval(posn downto posn - 3) := "1001";
      when 'A' | 'a'  => bitval(posn downto posn - 3) := "1010";
      when 'B' | 'b'  => bitval(posn downto posn - 3) := "1011";
      when 'C' | 'c'  => bitval(posn downto posn - 3) := "1100";
      when 'D' | 'd'  => bitval(posn downto posn - 3) := "1101";
      when 'E' | 'e'  => bitval(posn downto posn - 3) := "1110";
      when 'F' | 'f'  => bitval(posn downto posn - 3) := "1111";
      when others     => assert false
        report "invalid hex value." severity error;
        bitval(posn downto posn - 3) := "XXXX";
     end case;
     posn := posn - 4;
  end loop;

  return bitval(width-1 downto 0);--for when width not divable by 4 get lower bits

end hex_to_std_logic_vector;

function std_logic_vector_to_hex( slv: std_logic_vector ) RETURN string IS

constant hexlength : integer := (slv'length+3)/4;
variable hexval    : string(1 to hexlength);
variable bitval    : std_logic_vector((4*hexlength - 1) downto 0);
variable posn      : integer := 4*hexlength-1;
variable slv4      : std_logic_vector(3 downto 0);
variable nibble    : string(1 to 4);

begin

  -- Initialize the temporary std_logic_vector to all 0's
  bitval := (others => '0');
  -- then overload slv to LSBs
  bitval(slv'length-1 downto 0) := slv;
  
  -- loop through each nibble and convert to the equivalent hex char
  for i in 1 to hexlength loop
    slv4   := bitval(posn downto posn-3);
    nibble := slv_to_string(slv4,4);
    case nibble is
      when "0000" => hexval(i):= '0';
      when "0001" => hexval(i):= '1';
      when "0010" => hexval(i):= '2';
      when "0011" => hexval(i):= '3';
      when "0100" => hexval(i):= '4';
      when "0101" => hexval(i):= '5';
      when "0110" => hexval(i):= '6';
      when "0111" => hexval(i):= '7';
      when "1000" => hexval(i):= '8';
      when "1001" => hexval(i):= '9';
      when "1010" => hexval(i):= 'A';
      when "1011" => hexval(i):= 'B';
      when "1100" => hexval(i):= 'C';
      when "1101" => hexval(i):= 'D';
      when "1110" => hexval(i):= 'E';
      when "1111" => hexval(i):= 'F';
      when others => assert false
        report "invalid binary value." severity error;
        hexval(i) := 'X';
     end case;
     posn := posn-4;
  end loop;

  return hexval;

end std_logic_vector_to_hex;

--------------------------------------------------------------------------------
--From:  ../hdl/da_elements/da_elements_pkg.vhd

function map_da_type ( type_in  : integer ) return integer is
  variable type_out : integer;
begin

  type_out := type_in; -- Generally its a direct mapping

  -- Swap round interpolating and decimating cases
  -- This is only being done for safety, should be synchronized in future
  -- releases after VHDL DA FIR core is developed
  if type_in = c_polyphase_interpolating then
    type_out := c_polyphase_decimating;
  elsif type_in = c_polyphase_decimating then
    type_out := c_polyphase_interpolating;
  end if;
  
  return type_out;
  
end map_da_type;

function get_da_baat (
         filt_type    : integer;
         databits     : integer;
         clk_per_samp : integer;
         symmetry     : integer)
         return integer is

  variable bits : integer := 0;
  variable baat : integer := 0;

begin
  
  if symmetry = 0
  or filt_type = c_polyphase_interpolating
  or filt_type = c_interpolating_half_band  then
    bits := databits;
  else
    bits := databits + 1;
  end if;
  
  if ( clk_per_samp = 1 ) then
    baat := databits; -- PDA case
  else
    baat := ( bits + (clk_per_samp - 1) ) / clk_per_samp;
  end if;
  
  return baat;
  
end get_da_baat;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_elements_pkg.vhd

function memory_calcs(reqs:t_reqs;
                      ip_param:t_param;
                      data_depth_unpacked: integer;
                      data_depth_packed: integer;
                      coef_depth_unpacked: integer;
                      coef_depth_packed: integer) return t_param is
  variable param:t_param;
  constant srl16_mem_depth_thres: integer:=select_integer(32,64,
                                                          reqs.family=v5);
  constant dram_mem_depth_thres: integer:=select_integer(16,32,
                                                         reqs.family=v5);
begin
  param:=ip_param;
  
  --Data

  if (reqs.data_mem_type=c_mem_auto) then --auto

    if (data_depth_packed<=srl16_mem_depth_thres) then
      param.data_mem_type:=c_srl16; --srl16
      param.data_mem_depth:=data_depth_packed;
      param.data_packed:=1;
    else
      param.data_mem_type:=c_bram; --bram
      param.data_mem_depth:=data_depth_unpacked;
      param.data_packed:=0;
    end if;

  elsif (reqs.data_mem_type=c_mem_forced_dist) then --dist mem
    if (data_depth_packed>1024) then
      param.data_mem_type:=c_dram; --dram
    else
      param.data_mem_type:=c_srl16; --srl16
    end if;
    param.data_mem_depth:=data_depth_packed;
    param.data_packed:=1;
  else --bram
    param.data_mem_type:=c_bram; --bram
    if (  data_depth_unpacked>v4_bram_depth(reqs.data_width) and
          data_depth_packed<=v4_bram_depth(reqs.data_width)) then
      param.data_mem_depth:=data_depth_packed;
      param.data_packed:=1;
    else
      param.data_mem_depth:=data_depth_unpacked;
      param.data_packed:=0;
    end if;

  end if;

  --Symmetric Data
  param.data_combined := 0;
  param.datasym_mem_depth:=0;
  param.datasym_mem_type:=param.data_mem_type;
  param.datasym_mem_offset:=0;

  if (param.symmetry=1) then

    if (param.data_mem_type=c_bram) then --BRAM

      if (2*2**log2roundup(data_depth_unpacked) <= v4_bram_depth(reqs.data_width)) then
        report "will fit both data and symmetrical data into 1 ram" severity note;
        param.data_combined := 1;
        param.datasym_mem_depth:=data_depth_unpacked;
        param.datasym_mem_offset:=2**log2roundup(data_depth_unpacked);--2*2**log2roundup(data_depth_unpacked);
        param.data_packed:=0;
      elsif (2*data_depth_packed <= v4_bram_depth(reqs.data_width)) then
        report "will fit both data and symmetrical data into 1 ram" severity note;
        param.data_combined := 1;
        param.datasym_mem_depth:=data_depth_packed;
        param.datasym_mem_offset:=data_depth_packed;
        param.data_packed:=1;
      else
        report "unable to fit data and symmetrical data into 1 ram" severity note;
        param.datasym_mem_depth:=param.data_mem_depth;
        param.datasym_mem_offset:=0;
      end if;
    else
      param.datasym_mem_depth:=param.data_mem_depth;
    end if;
  end if;

  --Coef
  param.coef_mem_offset:=0;
  param.data_coef_combined:=0;

  if reqs.coef_reload=1 then

    if (reqs.coef_mem_type=c_mem_auto) then -- or param.no_data_mem=1) then --auto
      if ( 2**log2roundup(coef_depth_unpacked)<=dram_mem_depth_thres) then
        param.coef_mem_type:=c_dram;--dram
        param.coef_mem_depth:=2**log2roundup(coef_depth_unpacked);
        param.coef_packed:=0;
      elsif ( 2**log2roundup(coef_depth_packed)<=dram_mem_depth_thres) then
        param.coef_mem_type:=c_dram;--dram
        param.coef_mem_depth:=2**log2roundup(coef_depth_packed);
        param.coef_packed:=1;
      else --bram
        param.coef_mem_type:=c_bram;
        if ( 2**log2roundup(coef_depth_unpacked)<= v4_bram_depth(reqs.coef_width)) then
          param.coef_mem_depth:=2**log2roundup(coef_depth_unpacked);
          param.coef_packed:=0;
        elsif ( 2**log2roundup(coef_depth_packed)<= v4_bram_depth(reqs.coef_width)) then
          param.coef_mem_depth:=2**log2roundup(coef_depth_packed);
          param.coef_packed:=1;
        else
          param.coef_mem_depth:=2**log2roundup(coef_depth_unpacked);
          param.coef_packed:=0;
        end if;
      end if;
    elsif (reqs.coef_mem_type=c_mem_forced_dist) then --dram
      param.coef_mem_type:=c_dram;
      param.coef_mem_depth:=2**log2roundup(coef_depth_packed);
      param.coef_packed:=1;
    elsif (reqs.coef_mem_type=c_mem_forced_bram) then --bram
      param.coef_mem_type:=c_bram;
      if ( 2**log2roundup(coef_depth_unpacked)<= v4_bram_depth(reqs.coef_width)) then
        param.coef_mem_depth:=2**log2roundup(coef_depth_unpacked);
        param.coef_packed:=0;
      elsif ( 2**log2roundup(coef_depth_packed)<= v4_bram_depth(reqs.coef_width)) then
        param.coef_mem_depth:=2**log2roundup(coef_depth_packed);
        param.coef_packed:=1;
      else
        param.coef_mem_depth:=2**log2roundup(coef_depth_unpacked);
        param.coef_packed:=0;
      end if;
    end if;
  else --Normal
    
    if (reqs.coef_mem_type=c_mem_auto) then -- or param.no_data_mem=1) then --auto

      if (coef_depth_unpacked<=srl16_mem_depth_thres) then  --dram
        param.coef_mem_depth:=coef_depth_unpacked;
        param.coef_mem_type:=c_dram;
        param.coef_packed:=0;
      elsif (coef_depth_packed<=srl16_mem_depth_thres) then --dram
        param.coef_mem_depth:=coef_depth_packed;
        param.coef_mem_type:=c_dram;
        param.coef_packed:=1;
      else --bram
        param.coef_mem_type:=c_bram;
        if ( coef_depth_unpacked<= v4_bram_depth(reqs.coef_width)) then
          param.coef_mem_depth:=coef_depth_unpacked;
          param.coef_packed:=0;
        elsif ( coef_depth_packed<= v4_bram_depth(reqs.coef_width)) then
          param.coef_mem_depth:=coef_depth_packed;
          param.coef_packed:=1;
        else
          param.coef_mem_depth:=coef_depth_unpacked;
          param.coef_packed:=0;
        end if;
      end if;

    elsif (reqs.coef_mem_type=c_mem_forced_dist) then --forced dram
      
      if (coef_depth_unpacked<=srl16_mem_depth_thres) then
        param.coef_mem_depth:=coef_depth_unpacked;
        param.coef_mem_type:=c_dram;
        param.coef_packed:=0;
      else
        param.coef_mem_depth:=coef_depth_packed;
        param.coef_mem_type:=c_dram;
        param.coef_packed:=1;
      end if;

    else --forced bram
      param.coef_mem_type:=c_bram;
      if ( coef_depth_unpacked<= v4_bram_depth(reqs.coef_width)) then
        param.coef_mem_depth:=coef_depth_unpacked;
        param.coef_packed:=0;
      elsif ( coef_depth_packed<= v4_bram_depth(reqs.coef_width)) then
        param.coef_mem_depth:=coef_depth_packed;
        param.coef_packed:=1;
      else
        param.coef_mem_depth:=coef_depth_unpacked;
        param.coef_packed:=0;
      end if;
    end if;

    --if either coef ram in bram and data not or vice versa, try to fit into one ram
    if ( (param.data_mem_type=c_bram or param.coef_mem_type=c_bram) and param.data_combined=0 and param.no_data_mem=0 and param.symmetry=0 and coef_depth_packed>1) then

      if (coef_depth_unpacked+2**log2roundup(get_max(data_depth_unpacked,coef_depth_unpacked)) <= v4_bram_depth(get_max(reqs.data_width,reqs.coef_width))) then
        param.coef_mem_offset:=2**log2roundup(get_max(data_depth_unpacked,coef_depth_unpacked));
        param.data_coef_combined:=1;
        param.coef_mem_depth:=coef_depth_unpacked;
        param.data_mem_depth:=data_depth_unpacked;
        param.coef_packed:=0;
        param.data_packed:=0;
        param.coef_mem_type:=c_bram;
        param.data_mem_type:=c_bram;
      elsif (coef_depth_packed+data_depth_packed <= v4_bram_depth(get_max(reqs.data_width,reqs.coef_width))) then
        param.coef_mem_offset:=data_depth_unpacked;
        param.data_coef_combined:=1;
        param.coef_mem_depth:=coef_depth_packed;
        param.data_mem_depth:=data_depth_packed;
        param.coef_packed:=1;
        param.data_packed:=1;
        param.coef_mem_type:=c_bram;
        param.data_mem_type:=c_bram;
      end if;
    end if;

  end if;

  return param;
end;

function lat_polyphase_decimation_sym_wrap(param :  t_polyphase_decimation_sym_wrap) return integer is
  variable ram_param: t_ram;
  variable ram_lat,
           srl16_mem_depth_thres,
           parallel_depth
           : integer;
begin
  if param.base_count>1 then
    --currently not supported, latency not required to be reported
    return 0;
  else
    srl16_mem_depth_thres:=select_integer(32,64,param.family=v5);

    parallel_depth:=param.num_phases+select_integer(0,1,param.sym_type=1);
    parallel_depth:=param.num_channels*(2**log2roundup(parallel_depth));

    ram_param:=(family              => param.family,
                implementation      => param.implementation,
                mem_type            => select_integer(c_bram,c_dram,parallel_depth<=srl16_mem_depth_thres or param.force_srl16_mem=1),
                write_mode          => 0,--read first
                has_ce              => param.has_ce,
                use_mif             => 0 );
    ram_lat:=lat_ram(ram_param,1);
    if param.sym_type=0 and param.has_nd=0 then
      return ram_lat;
    else
      return ram_lat+1;
    end if;
  end if;
end;

function gen_mif_files (
         elab_dir   : string;
         gen_mif_prefix : string;
         mif_file   : string;
         param      : t_param )
         return integer is

variable coefficients : t_multi_coefficients(param.num_filts-1 downto 0);

type t_mac_coefficients is array (param.num_macs-1 downto 0)
     of t_coefficients(param.coef_mem_depth+param.coef_mem_offset+1-1 downto 0);
                                                         --extra plus 1 for extra output location

variable mac_coefficients : t_mac_coefficients;
variable mod_coefficients : t_coefficients (max_num_taps_calced-1 downto 0);

variable half_band_centre_value : t_coefficients(
                                    select_integer(param.num_filts,
                                                   param.num_filts*2,
                                                   param.coef_reload=1)+1-1 downto 0):=(others=>(others=>'0'));
                                                   --extra plus 1 for extra output location

variable local_req_num_taps,
         tap_difference,
         mac_mem_pos,
         tap_pos,
         string_range,
         write_res,
         local_deci_rate,
         phase,
         phase_loop_dir,
         phase_loop_end,
         tap,
         phase_offset,
         temp_diff,
         mod_phase,
         pq_deci_start_phase,
         pq_deci_phase,
         phase_last_mod,
         inter_sym_loop_len,
         pq_deci_count_ips
         : integer;

variable pq_deci_first_phase:t_int_array(param.deci_rate-1 downto 0);

begin

  -- Check number of entries in input mif file
  if (get_number_of_inputs(elab_dir&mif_file)<param.num_taps*param.num_filts) then
  -- Changed for XST, getnuminput seem to return one more than in file
    
    report "*** gen_mif_files ***" severity note;
    report "input mif file has incorrect number of values" severity note;
    report int_to_str(get_number_of_inputs(elab_dir&mif_file) ) severity note;
    report int_to_str(param.num_taps*param.num_filts ) severity note;
  
  else
    
    report "*** gen_mif_files ***" severity note;
    report "MIF_FILE : " & elab_dir&mif_file severity note;
    report "TAPS     : " & int_to_string(param.num_taps) severity note;
    report "FILTS    : " & int_to_string(param.num_filts ) severity note;

    -- Fetch all the coefficients from the mif file
    for filter in 0 to param.num_filts-1 loop
      coefficients(filter)(param.num_taps-1 downto 0) :=
                     read_coef_data( elab_dir&mif_file,
                                     param.num_taps,
                                     param.coef_width,
                                     filter*param.num_taps);
      report "Filter - " & int_to_string(filter) severity note;
      for taps in 0 to param.num_taps-1 loop
        report "READ TAPS: "&slv_to_string( coefficients(filter)(taps)(param.coef_width-1 downto 0),param.coef_width);

      end loop;
    end loop;

    -- Check if symmtric and modify num taps
    tap_difference:=0;
    if (param.symmetry=1) then
      local_req_num_taps:=param.num_taps/2;

      if ( param.num_taps rem 2 > 0 ) then -- Odd symmetry
        local_req_num_taps:=local_req_num_taps+1;
      end if;

      -- Reorder coefficients and remove sym coefficients, middle will be put
      -- at loc 0 as mac will be filled downto position 0
      --tap_difference:=param.num_taps_calced-1-local_req_num_taps;
      tap_difference:=param.num_taps_calced-local_req_num_taps;

      if (param.filter_type=c_interpolating_symmetry and param.odd_symmetry=1 and param.inter_rate rem 2 >0 ) then
        temp_diff:=param.inter_rate/2;
        -- if (param.inter_rate rem 2 >0) then
--           temp_diff:=temp_diff+1;
--         end if;

        tap_difference:=tap_difference-temp_diff;
      end if;

      -- if (param.num_macs=1 and param.single_mac=1 and
--          (param.filter_type=c_halfband_transform )) then
--          -- Modify tap difference so centre tap can be inserted in end location
--          tap_difference:=tap_difference-2;--sub effective deci rate
--       end if;

--        or
--          param.filter_type=c_decimating_half_band

      report "tap diff: "&int_to_str(tap_difference);

      for filter in 0 to param.num_filts-1 loop
        for get_taps in 0 to param.num_taps_calced-1 loop

          if get_taps>=tap_difference then

--             report "src coeff: "& UTILS_PKG_slv_to_string(coefficients(filter)(get_taps-tap_difference)(param.coef_width-1 downto 0),param.coef_width);

            mod_coefficients(get_taps):=coefficients(filter)(get_taps-tap_difference);

            -- if ( (get_taps=param.num_taps_calced-2)
--                  and param.num_macs=1 and param.single_mac=1 and
--                  (param.filter_type=c_halfband_transform )) then
--                -- Modify last value assigned, give it centre value.
--                mod_coefficients(get_taps):=coefficients(filter)(get_taps-tap_difference-1);
-- 
--             -- elsif ( ( get_taps = param.num_taps_calced-1)
--             --       and param.num_macs = 1 and param.single_mac_modifier = 0
--             --       and param.filter_type = c_interpolating_half_band) then
--             --   mod_coefficients(0) := coefficients(filter)(get_taps-tap_difference);
--             end if;

            if ( (get_taps=param.num_taps_calced-1)
                 and param.num_macs=1 and param.single_mac=1 and
                 (param.filter_type=c_decimating_half_band  or
                  param.filter_type=c_interpolating_half_band or
                  param.filter_type=c_halfband_transform)) then
               -- Modify last value assigned, give it centre value.
               mod_coefficients(get_taps+1):=coefficients(filter)(get_taps-tap_difference);

            end if;

          else
            mod_coefficients(get_taps) := (others=>'0'); -- pad
          end if;

--           report "padded location:"&int_to_str(get_taps)& " value: "& UTILS_PKG_slv_to_string( mod_coefficients(get_taps)(param.coef_width-1 downto 0),param.coef_width);
          
          report "PADDED VECTOR("&int_to_str(get_taps)&"): "&slv_to_string(mod_coefficients(get_taps)(param.coef_width-1 downto 0),param.coef_width);

        end loop;

        coefficients(filter) := mod_coefficients;

      end loop;

    else

      report "param.num_taps = " & int_to_str(param.num_taps)
        severity note;

      local_req_num_taps:=param.num_taps;

      -- Pad input coefficients with zeros to match actual number of taps
      for filter in 0 to param.num_filts-1 loop
        report "local_req_num_taps = " & int_to_str(local_req_num_taps)
          severity note;
        report "param.num_taps_calced = " & int_to_str(param.num_taps_calced)
          severity note;

        if (param.num_taps_calced-1>local_req_num_taps) then -- pad
          for pad in local_req_num_taps to param.num_taps_calced-1 loop
            coefficients(filter)(pad):=(others=>'0');
          end loop;
        end if;
      end loop;

    end if;

    --------------------------------------------------------------------------
    --Generate symmetric pairs
    --if (param.filter_type=c_polyphase_interpolating and param.symmetry=1) then
    if (param.filter_type=c_interpolating_symmetry) then

      for filter in 0 to param.num_filts-1 loop
        tap:=0;
        while tap<=param.num_taps_calced-1 loop

          phase_last_mod:=0;
          phase_offset:=0;
          if (param.inter_rate rem 2 /=0) then
            --get centre phase as it will be symmetric
            mod_coefficients(tap):=coefficients(filter)(tap+((param.inter_rate/2)));
            phase_offset:=1;
          end if;

          phase:=0;

          inter_sym_loop_len:=(param.inter_rate/2);

          if (param.inter_rate rem 2 =0) and (param.odd_symmetry=1) then
            -- if param.inter_rate>2 then
--               mod_coefficients(tap+1):=coefficients(filter)(tap+((param.inter_rate/2)-1));
--               mod_coefficients(tap):=coefficients(filter)(tap+((param.inter_rate)-1));
--               --swapped to odd phase is first phase
--             else
--               mod_coefficients(tap):=coefficients(filter)(tap+((param.inter_rate/2)-1));
--               mod_coefficients(tap+1):=coefficients(filter)(tap+((param.inter_rate)-1));
--             end if;
--             phase_offset:=2;
--             phase_last_mod:=1;
            mod_coefficients(tap):=coefficients(filter)(tap+((param.inter_rate/2)-1));
            mod_coefficients(tap+param.inter_rate-1):=coefficients(filter)(tap+((param.inter_rate)-1));
            phase_offset:=1;
            phase_last_mod:=1;
            inter_sym_loop_len:=(param.inter_rate-2)/2;--shorten loop so don't overwrite last phase
            --report "phase_offset: "&int_to_str(phase_offset)&" phase_last_mod: "&int_to_str(phase_last_mod);
          end if;

          --while phase<((param.inter_rate/2)) loop-- gen missing middle phase when odd
          for phase_loop in 0 to inter_sym_loop_len-1 loop

            --report "tap: "&int_to_str(tap)& "phase: "&int_to_str(phase);

            mod_coefficients(tap+(2*phase)+1+phase_offset)(param.coef_width-1 downto 0):= std_logic_vector(signed(coefficients(filter)(tap+phase)(param.coef_width-1 downto 0))
                                                                        +signed(coefficients(filter)( (param.inter_rate+tap-1-phase_last_mod)-(phase) )(param.coef_width-1 downto 0)));

            mod_coefficients(tap+(2*phase)+phase_offset)(param.coef_width-1 downto 0):= std_logic_vector(signed(coefficients(filter)(tap+phase)(param.coef_width-1 downto 0))
                                                                          -signed(coefficients(filter)( (param.inter_rate+tap-1-phase_last_mod)-(phase) )(param.coef_width-1 downto 0)));


            report "index1: "&int_to_str(tap+(2*phase)+1+phase_offset);
            report "index2: "&int_to_str(tap+(2*phase)+phase_offset);


            phase:=phase+1;
          end loop;

          --put back into src coefficient array
          phase:=0;
          while phase<=param.inter_rate-1 loop
            coefficients(filter)(tap+phase):=mod_coefficients(tap+phase);
            --report "Reordered: "&int_to_str(to_integer(signed(mod_coefficients(tap+phase)(param.coef_width-1 downto 0))));
            phase:=phase+1;

          end loop;

          tap:=tap+param.inter_rate;
        end loop;
      end loop;

    end if;

    --------------------------------------------------------------------------
    -- Initialise mac mem struct with zeros
    for mac in 0 to  param.num_macs-1 loop
       for mac_mem_loc in 0 to param.coef_mem_depth+param.coef_mem_offset-1+1 loop
                                                      --extra plus 1 for extra output location
         mac_coefficients(mac)(mac_mem_loc):=(others=>'0');
       end loop;
    end loop;


    --------------------------------------------------------------------------
    -- Fill up mac memories structure
    --------------------------------------------------------------------------

    -- if ( param.filter_type = c_channelizer) then
--       local_deci_rate:=param.num_channels;
--     els
    if ( param.filter_type = c_decimating_half_band
      or param.filter_type = c_interpolating_half_band ) then
      -- Generate local decirate so c_decimating_half_band can override
            local_deci_rate:=2;
    elsif (param.filter_type = c_interpolated_transform) then
            local_deci_rate:=1;
    else
            local_deci_rate:=param.deci_rate;
    end if;

    for mac in 0 to  param.num_macs-1 loop
      mac_mem_pos:=0; -- Put the offset here when packed with data

      if (param.data_coef_combined=1) then
              mac_mem_pos:=param.coef_mem_offset; -- 2**log2roundup(param.data_mem_depth);
      end if;
      
      report "--------------------";
      report "mac: "&int_to_str(mac);
      report "--------------------";

      for filters in 0 to param.num_filts-1 loop
        --report int_to_str(filters) severity note;
        --report int_to_str(mac_mem_pos) severity note;

        pq_deci_first_phase:=(others=>0);

        phase:=0;
        mod_phase:=0;
        --phase_loop_end:=local_deci_rate-1;--
        phase_loop_end := get_max(local_deci_rate,param.inter_rate)-1;
        phase_loop_dir := 1;

        -- if (param.filter_type = c_polyphase_pq and param.inter_rate>param.deci_rate) then
--           --pq interpolating
--           phase_loop_dir := param.deci_rate;
--         end if;

        if (param.filter_type = c_polyphase_decimating)
          or (param.filter_type = c_polyphase_pq and param.inter_rate<param.deci_rate) then
          phase := get_max(local_deci_rate,param.inter_rate)-1;--0;
          mod_phase:= get_max(local_deci_rate,param.inter_rate)-1;
          pq_deci_start_phase:=param.inter_rate-1;
          phase_loop_end := 0;  --get_max(local_deci_rate,param.inter_rate)-1;
          phase_loop_dir := -1;
        end if;

        while  not(phase=phase_loop_end+phase_loop_dir) loop
        --for phase in 0 to get_max(local_deci_rate,param.inter_rate)-1 loop--reorder data for into phases for inter or deci filters
          --report "phase"&int_to_str(phase) severity note;

          if not ( param.filter_type = c_hilbert_transform
                or param.filter_type = c_interpolated_transform
                or param.filter_type = c_halfband_transform
                or param.filter_type = c_decimating_half_band
                or param.filter_type = c_interpolating_half_band ) then


            if (param.filter_type = c_polyphase_pq and param.inter_rate<param.deci_rate) then
            --for new structure of pq, very different.
            
              pq_deci_phase:=0;
              pq_deci_count_ips:=0;

              for pq_reorder in 0 to param.inter_rate-1 loop
                
                tap_pos := (mac*param.base_coef_space)+
                           ((mod_phase-pq_reorder) mod param.deci_rate)+
                           --(pq_deci_phase*param.deci_rate);
                           select_integer(
                            (param.inter_rate-(((pq_deci_phase)*param.inter_rate)/param.deci_rate))*param.deci_rate,
                            0,
                            pq_deci_phase=0);

                report "--------------------";
                report "mod phase: "&int_to_str(mod_phase);
                report "pq_deci_phase: "&int_to_str(pq_deci_phase);
                report "pq_reorder: "&int_to_str(pq_reorder);
                report "mac_mem_pos: "&int_to_str(mac_mem_pos);

                pq_deci_first_phase(mod_phase):=1;

                while tap_pos<((mac+1)*param.base_coef_space) loop
                  
                  report "tap_pos: "&int_to_str(tap_pos);

                  if param.data_mem_type/=c_srl16 and pq_deci_first_phase( ((mod_phase-pq_reorder) mod param.deci_rate) ) = 0 then
                    --need to shift coefficients as the data address has been shifted but new data has not been writen
                    -- mac_coefficients(mac)(mac_mem_pos) := coefficients(filters)(
--                                                               ((tap_pos+(param.inter_rate*param.deci_rate))
--                                                               mod (param.base_count*param.inter_rate*param.deci_rate)));
--                                                               -- (mac*param.base_coef_space)
-- --                                                               +( ((tap_pos-(mac*param.base_coef_space))
-- --                                                                  *(param.inter_rate*param.deci_rate))
-- --                                                                  mod (param.base_count*param.inter_rate*param.deci_rate) ) );
--                     report "tap_pos moded: "&int_to_str((tap_pos+(param.inter_rate*param.deci_rate))
--                                                               mod (param.base_count*param.inter_rate*param.deci_rate));
                                                              
                    mac_coefficients(mac)(mac_mem_pos) := coefficients(filters)(
                                                            (mac*param.base_count*param.inter_rate*param.deci_rate)
                                                            +( (tap_pos-(param.base_count*param.inter_rate*param.deci_rate)
                                                                + ((param.base_count-1)*param.inter_rate*param.deci_rate))
                                                                mod (param.base_count*param.inter_rate*param.deci_rate)));
                                                                
                    report "tap_pos moded: "&int_to_str( (mac*param.base_count*param.inter_rate*param.deci_rate)
                                                            +( (tap_pos-(param.base_count*param.inter_rate*param.deci_rate)
                                                                + ((param.base_count-1)*param.inter_rate*param.deci_rate))
                                                                mod (param.base_count*param.inter_rate*param.deci_rate)) );
                  else
                    mac_coefficients(mac)(mac_mem_pos) := coefficients(filters)(tap_pos);
                  end if;
                  
                  report "coef value: "&int_to_str(to_integer(signed(mac_coefficients(mac)(mac_mem_pos)(param.coef_width-1 downto 0))));
                  --report "coef value: "&slv_to_str(mac_coefficients(mac)(mac_mem_pos));

                  mac_mem_pos := mac_mem_pos+1;

                  tap_pos := tap_pos+ (param.inter_rate*param.deci_rate);

                end loop;

                --pq_deci_phase:=(pq_deci_phase-1) mod param.inter_rate;
                --pq_deci_phase:=(pq_deci_phase+param.deci_rate) mod param.inter_rate;
                --pq_deci_phase:=(pq_deci_phase+(param.inter_rate-1)) mod param.deci_rate;

                while pq_deci_count_ips/= pq_reorder+1 loop
                  pq_deci_count_ips:=(pq_deci_count_ips+param.inter_rate) mod param.deci_rate;
                  pq_deci_phase:=(pq_deci_phase+1) mod param.deci_rate;
                end loop;

              end loop;

            --below is orig structure
            -- if (param.filter_type = c_polyphase_pq and param.inter_rate<param.deci_rate) then
--             --if pq decimation, different re-order is required
-- 
--               pq_deci_phase:=pq_deci_start_phase;
--
--               for pq_reorder in 0 to param.inter_rate-1 loop
-- 
--                 --report "mod phase: "&int_to_str(mod_phase);
--                 --report "pq_deci_phase: "&int_to_str(pq_deci_phase);
-- 
--                 tap_pos := (mac*param.base_coef_space)+(pq_deci_phase*param.deci_rate)+mod_phase;
-- 
--                 while tap_pos<((mac+1)*param.base_coef_space) loop
--
--                   mac_coefficients(mac)(mac_mem_pos) := coefficients(filters)(tap_pos);
-- 
--                   mac_mem_pos := mac_mem_pos+1;
--     
--                   tap_pos := tap_pos+ (param.inter_rate*param.deci_rate);
-- 
--                 end loop;
--                 
--                 pq_deci_phase:=(pq_deci_phase-1) mod param.inter_rate;
-- 
--               end loop;

            else
              --normal re-order

              if (param.filter_type = c_polyphase_pq) then -- and param.inter_rate>param.deci_rate) then
                --pq interpolating change order
                --tap_pos := (mac*param.base_coef_space)+(mod_phase mod param.inter_rate);
                tap_pos := (mac*param.base_coef_space)+mod_phase;
              else
                tap_pos := (mac*param.base_coef_space)+phase;
              end if;
  
              while tap_pos<((mac+1)*param.base_coef_space) loop

                --report "mac :"&int_to_str(mac)& " mac_mem_pos: "&int_to_str(mac_mem_pos)&"  =  filter: "&int_to_str(filters)&" tap_pos: "&int_to_str(tap_pos);

                mac_coefficients(mac)(mac_mem_pos) := coefficients(filters)(tap_pos);
  
                mac_mem_pos := mac_mem_pos+1;
  
                tap_pos := tap_pos+get_max(local_deci_rate,param.inter_rate);
                --tap_pos:=tap_pos+local_deci_rate;
              end loop;
            
            end if;

          else   -- Special case for hilbert, interpolated, halfband,....

            tap_pos:=(mac*param.base_coef_space*local_deci_rate)+phase;

            while ((tap_pos<((mac+1)*param.base_coef_space*local_deci_rate))and phase=0) loop
    
              report "tap_pos: "&int_to_str(tap_pos);

              mac_coefficients(mac)(mac_mem_pos):=coefficients(filters)(tap_pos);
    
              mac_mem_pos:=mac_mem_pos+1;

              tap_pos := tap_pos+local_deci_rate;
            end loop;

          end if;

          phase := phase+phase_loop_dir;
          
          if (param.inter_rate>param.deci_rate) then
            --interpolation
            mod_phase :=(mod_phase+ param.deci_rate) mod param.inter_rate;
          else
            --decimation
            -- if (mod_phase-param.inter_rate<0) then
--               pq_deci_start_phase:=pq_deci_start_phase-1;
--             end if;
-- 
--             mod_phase :=(mod_phase- param.inter_rate) mod param.deci_rate;
            --above is original method
            
            mod_phase:=(mod_phase-param.inter_rate) mod param.deci_rate;
          end if;

        end loop;


        if ( param.filter_type = c_halfband_transform
          or param.filter_type = c_decimating_half_band
          or param.filter_type = c_interpolating_half_band ) then

          if ( param.num_macs = param.centre_mac ) then
            half_band_centre_value(filters) :=
                    coefficients(filters)(tap_difference+local_req_num_taps-1);
          else
            --symmetry disabled, only on fully parallel
            half_band_centre_value(filters) :=
                    coefficients(filters)( (param.num_taps/2) );
          end if;

        end if;

        if (param.coef_packed=0) then -- not packed memory, add binary offset
          mac_mem_pos:=((2**log2roundup(param.base_coef_space))*(filters+1))+param.coef_mem_offset;
          --mac_mem_pos:=(2**log2roundup(param.base_coef_space))*(filters);
        end if;

      end loop;
    end loop;

    -- Create filenames for mac mif files and mif files
    for mac in 0 to  param.num_macs-1 loop
      
      if (mac<10) then
        string_range:=15;
      else
        string_range:=16;
      end if;
      
      --extend coefficient values if signed coeff and memory packed and data width > coef width
      if (  param.data_coef_combined=1
          and param.data_width > param.coef_width
          and param.coef_sign = c_signed ) then

        for tap in 0 to param.base_count loop
          mac_coefficients(mac)(tap)(param.data_width-1 downto 0):=
                              ext_bus(mac_coefficients(mac)(tap)(param.coef_width-1 downto 0),param.data_width,param.coef_sign);
        end loop;
      end if;

      --output mif file
      write_res := write_coef_data( elab_dir
                                  & gen_mif_prefix
                                  & "COEFF_auto"
                                  & int_to_str(mac) 
                                  & ".mif",
                                    param.coef_mem_depth+param.coef_mem_offset+1,
                                    select_integer( param.coef_width,
                                                    get_max(param.coef_width,param.data_width),
                                                    param.data_coef_combined=1),
                                    mac_coefficients(mac)                  );
      ------------------------------------------------------------------------
      -- Note : To use BRAM with data and coefficients together, need to make
      -- baseblock both ports same width, this means need to output the
      -- larger into the mif files.  The type t_coefficients is set to 18 get_max
      ------------------------------------------------------------------------

    end loop;
    
    if ( param.filter_type = c_halfband_transform
      or param.filter_type = c_decimating_half_band
      or param.filter_type = c_interpolating_half_band) then
      write_res := write_coef_data( elab_dir
                                  & gen_mif_prefix
                                  & "COEFF_auto_HALFBAND_CENTRE.mif",
                                    select_integer(param.num_filts,
                                                   param.num_filts*2,
                                                   param.coef_reload=1)+1,
                                    param.coef_width,
                                    half_band_centre_value);
      --fixed depth memory
    end if;

  end if;

  ---------------------------------
  --NOTE: Have added on an extra loction to the auto mif files, this is
  --so the same code will work in XST and Modelsim. XST does not deal with
  --the eof character correctly. So when code is changed to work for XST
  --it does not work correctly with Modelsim

  return 1; -- gen_mif_files;
end;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_single_rate.vhd

  function define_single_rate(reqs:t_reqs) return t_define_single_rate is
  ------------------------------------------------------------------------------

    variable struct: t_define_single_rate;
    --variable mem_param: t_tap_memory_add_casc;
    --variable memory_path_lat: t_lat_tap_memory_add_casc;
    constant srl16_mem_depth_thres: integer:=select_integer(32,64,
                                                            reqs.family=v5);
    constant dram_mem_depth_thres: integer:=select_integer(16,32,
                                                           reqs.family=v5);
    variable implementation:integer:=1;--structural
    variable  data_depth_unpacked,
              data_depth_packed,
              coef_depth_unpacked,
              coef_depth_packed,
              num_col,
              pass,
              filter_sel_dly,
              addr_dly,
              pre_sym_delay,
              sym_param_est_orig :integer;
  begin
    --Defaults and direct copies
    struct.param.family:=reqs.family;
    struct.param.filter_type:=reqs.filter_type;
    struct.param.coef_reload:=reqs.coef_reload;
    struct.param.data_sign:=reqs.data_sign;
    struct.param.coef_sign:=reqs.coef_sign;
    struct.param.data_width:=reqs.data_width;
    struct.param.coef_width:=reqs.coef_width;
    struct.param.clk_per_samp:=reqs.clk_per_samp;
    struct.param.num_channels:=reqs.num_channels;
    struct.param.num_taps:=reqs.num_taps;
    struct.param.num_filts:=reqs.num_filts;
    struct.param.zero_packing_factor:=reqs.zero_packing_factor;

    struct.param.symmetry:=reqs.symmetry;
    struct.param.neg_symmetry:=reqs.neg_symmetry;
    struct.param.odd_symmetry:=select_integer(0,reqs.num_taps rem 2,struct.param.symmetry=1);
    struct.param.num_taps_calced:=(reqs.num_taps/2**struct.param.symmetry)+struct.param.odd_symmetry;

    --loop round here once checked depth of inter tap buffer depth
     pass:=0;
     while pass<2 loop
      --Calculate details of the filter-------------------------------------------
      --Number of macs and number of taps per mac
      if ( reqs.clk_per_samp/reqs.num_channels = 0 ) then
        report "FIR: not enough clock cycles per sample to process all channels, must have a minimum of 1 clk cycle per channel" severity error;
      elsif ( reqs.clk_per_samp rem reqs.num_channels > 0 ) then
        report "FIR: number of channels does not fit fully into clock cycles per sample, there will be unused clock cycles" severity note;
      end if;

      struct.param.clk_per_chan := reqs.clk_per_samp / reqs.num_channels;
          
      struct.param.base_count := struct.param.clk_per_chan;

      struct.param.num_macs := struct.param.num_taps_calced/struct.param.base_count;

      if ( struct.param.num_taps_calced rem struct.param.base_count > 0 ) then
      -- Add extra mac, this mac will need the filter coefficients padded out.
        struct.param.num_macs:=struct.param.num_macs+1;
      end if;

      --Adjust for unused cycles
      struct.param.base_count:=struct.param.num_taps_calced/struct.param.num_macs;
      if (struct.param.num_taps_calced rem struct.param.num_macs >0) then
        struct.param.base_count:=struct.param.base_count+1;
      end if;

      if struct.param.base_count<struct.param.clk_per_chan then
        struct.shorter_px_time:=true;
      else
        struct.shorter_px_time:=false;
      end if;

      if pass=0 then
        struct.param.centre_mac:=struct.param.num_macs;
      end if;

      struct.param.base_data_space := struct.param.base_count;
      struct.param.base_coef_space := struct.param.base_count;

      -- Modify and update so get actual filter size
      struct.param.num_taps_calced:=struct.param.num_macs*struct.param.base_count;

      struct.param.inter_rate := 1;
      struct.param.deci_rate  := 1;

      struct.param.no_data_mem:= 0;
      if (struct.param.base_count = 1) then
        struct.param.no_data_mem:= 1;
      end if;

      if (struct.param.clk_per_chan=1 and struct.param.num_channels=1 and struct.param.symmetry=0) then
        --use data cascade
        
        struct.param.data_sign:=c_signed;
        --clear sign for filt_arm as will be extended at this level
        if (reqs.family=v5) then
          struct.param.data_width:=30;
          if reqs.coef_width+reqs.coef_sign > 18 then
            if reqs.data_width+reqs.data_width > 18 then
              report "FIR: ERROR: coef and data buses are greater than 18 bits" severity failure;
            else
              struct.param.data_width:=18;
            end if;
          end if;
        else
          struct.param.data_width:=18;
        end if;
      end if;

      --Structural decisions------------------------------------------------------
      struct.param.single_mac:=0;
      if struct.param.num_macs=1 then
        struct.param.single_mac:=1;
      end if;

      --Memory calculations-------------------------------------
      data_depth_unpacked:=2**log2roundup(struct.param.base_data_space)*reqs.num_channels;
      data_depth_packed:=struct.param.base_data_space*reqs.num_channels;

      coef_depth_unpacked:=2**log2roundup( 2**log2roundup(struct.param.base_coef_space)*struct.param.num_filts)*2**struct.param.coef_reload;
      coef_depth_packed:=struct.param.base_coef_space*struct.param.num_filts*2**struct.param.coef_reload;
  
      struct.param:=memory_calcs( reqs,
                                  struct.param,
                                  data_depth_unpacked,
                                  data_depth_packed,
                                  coef_depth_unpacked,
                                  coef_depth_packed);

      --Symmetric wrap over calculations-------------------------
      --need to know latency of memory implmented
      struct.mem_param:=( family           =>reqs.family,
                          implementation   =>implementation,
                          data_mem_type    =>struct.param.data_mem_type,
                          coef_mem_type    =>struct.param.coef_mem_type,
                          data_comb        =>struct.param.data_combined,
                          data_coef_comb   =>struct.param.data_coef_combined,
                          no_data_mem      =>struct.param.no_data_mem,
                          coef_mem_depth  => struct.param.coef_mem_depth,
                          has_ce           =>reqs.has_ce,
                          coef_reload      =>reqs.coef_reload,
                          coef_reload_depth=>struct.param.base_coef_space,
                          symmetric        =>struct.param.symmetry );

      struct.memory_path_lat:=lat_tap_memory_add_casc(struct.mem_param);

      struct.cyc_to_data_out:=struct.memory_path_lat.data+1;--plus one for the latch (min depth of 1 in delay)
      
      struct.cyc_to_write:=0;
      if (struct.mem_param.data_mem_type/=c_srl16) then -- =c_bram) then
        struct.cyc_to_write:=struct.param.base_count; --inter_we_cycles
      end if;

      struct.num_cyc_read_earily:= select_integer(0,1,struct.cyc_to_write+struct.param.odd_symmetry-struct.cyc_to_data_out<0)
                                  +select_integer(0,1,struct.param.odd_symmetry=1);
      --add odd sym when calc if need earily read as when odd sym will read data earily this gives longer to get
      --data out of memory. So then check if still don't have enough time to get data out of memory

      struct.change_src:=select_integer(0,1,struct.num_cyc_read_earily>=struct.param.base_count);

      struct.extra_dly:=select_integer(
                          0,
                          select_integer(
                            reqs.num_channels-1,
                            reqs.num_channels,
                            struct.cyc_to_data_out-struct.num_cyc_read_earily<=struct.cyc_to_write),
                            --test is moved past another WE pulse by reading earily
                          struct.num_cyc_read_earily-struct.param.odd_symmetry>0 and
                          struct.change_src=0);

      --------------------------------------------------------------------------
      struct.add_sup_dly:=struct.memory_path_lat.data;

      struct.first_tap_extra_dly:=0;

      if struct.param.data_mem_type=c_srl16 and struct.param.no_data_mem=0 then
        struct.data_dly_modifier:=-1;
      else
        struct.data_dly_modifier:=0;
      end if;

      if struct.param.no_data_mem=1 then
        if  struct.param.clk_per_chan=1 and
            struct.param.num_channels=1 and
            struct.param.symmetry=0 then
          --data cascade used
          struct.first_tap_extra_dly:=struct.memory_path_lat.coef;
          struct.data_dly_modifier:=struct.memory_path_lat.coef;
        elsif struct.memory_path_lat.coef>1 then
          --filt casc can direct emb_calc to compensate  for a difference of 1, any more
          --and need extra delay.
          struct.data_dly_modifier:=struct.data_dly_modifier+struct.memory_path_lat.coef-1;
          struct.add_sup_dly:=struct.add_sup_dly+struct.memory_path_lat.coef-1;
          struct.first_tap_extra_dly:=struct.memory_path_lat.coef-1;
        end if;
      end if;

      --Filter arm settings-------------------------------------
      if (reqs.col_mode=1) then
        -- if (struct.param.num_macs>reqs.col_1st_len) then
--           num_col:=1+(struct.param.num_macs-reqs.col_1st_len)/reqs.col_wrap_len;
--         else
--           num_col:=1;
--         end if;
        num_col:=calc_num_split_col(struct.param.num_macs,t_col_len'(
                                   0 => select_integer(reqs.col_wrap_len,reqs.col_1st_len,reqs.col_mode=1),
                                   others=>reqs.col_wrap_len));
      elsif (reqs.col_mode=2) then
        -- no generic for this mode yet
        num_col:=1;
      else
        num_col:=1;
      end if;

      struct.filt_arm:= (
          family          => reqs.family,
          implementation  => implementation,
          num_taps        => struct.param.num_macs,
          inter_we_cycles => struct.param.base_count,
          inter_tap_delay => struct.param.num_channels+1,
          inter_sym_tap_delay => struct.param.num_channels+1,
          symmetric       => struct.param.symmetry,
          pre_add_func    => select_integer(c_preadd_add,c_preadd_sub,struct.param.neg_symmetry=1),
          data_mem_type   => struct.param.data_mem_type,
          coef_mem_type   => struct.param.coef_mem_type,
          data_comb       => struct.param.data_combined,
          data_coef_comb  => struct.param.data_coef_combined,
          data_cascade    => select_integer(0,1,
                                            struct.param.clk_per_chan=1 and
                                            struct.param.num_channels=1 and
                                            struct.param.symmetry=0),
          no_data_mem     => struct.param.no_data_mem,
          coef_mem_depth  => struct.param.coef_mem_depth,
          p_src           => 0,--fabric
          data_sign       => struct.param.data_sign,--reqs.data_sign,
          coef_sign       => reqs.coef_sign,
          has_ce          => reqs.has_ce,
          --has_nd          => reqs.has_nd,
          reload          => reqs.coef_reload,
          reload_strms    => select_integer(1,2,struct.param.coef_mem_type=c_bram),
          reload_depth    => struct.param.base_coef_space,
          output_index    => (
                            p_P_OUT       => struct.param.num_macs+1,
                            p_PC_OUT      => struct.param.num_macs+1,
                            p_D_OUT       => struct.param.num_macs,-- -struct.change_src,
                            p_D_SYM_OUT   => struct.param.num_macs,
                            p_C_OUT       => struct.param.num_macs,
                            p_WE_OUT      => struct.param.num_macs,-- +1,
                            p_WE_SYM_OUT  => struct.param.num_macs+(struct.cyc_to_data_out-1)-struct.num_cyc_read_earily,
                            p_ADDSUB_OUT  => struct.param.num_macs+1,
                            p_ADDSUP_OUT  => struct.param.num_macs+1,
                            p_WE_SYM_OUT_2    => struct.param.num_macs ),
          output_src      => (
                            p_P_OUT       => 0,
                            p_PC_OUT       => 0,
                            p_D_OUT       => select_integer(1,0,struct.change_src=1),
                            p_D_SYM_OUT   => 0,
                            p_C_OUT       => 0,
                            p_WE_OUT      => 0,
                            p_WE_SYM_OUT  => 0,
                            p_ADDSUB_OUT  => 0,
                            p_ADDSUP_OUT  => 0,
                            p_WE_SYM_OUT_2    => 0 ),
          num_independant_col => select_integer(1,num_col,reqs.col_mode=2),
          num_split_col       => select_integer(1,num_col,reqs.col_mode=1),
          inter_split_col_dly => reqs.col_pipe_len,
          col_len             => ( 0 => select_integer(reqs.col_wrap_len,reqs.col_1st_len,reqs.col_mode=1),
                                   others=>reqs.col_wrap_len),
          dynamic_opcode  => select_integer(0,1,struct.param.num_macs=1),
          sym_para_struct => reqs.has_nd,
          para_casc_we_src=> reqs.has_nd,
          resource_opt    => reqs.resource_opt,
          data_width      => reqs.data_width,
          datapath_mem_type => reqs.datapath_mem_type,
          odd_symmetry    => struct.param.odd_symmetry );

      struct.filt_arm_lat:=lat_filt_arm_add_casc(struct.filt_arm);

      if struct.param.no_data_mem=1 and struct.param.symmetry=1 and struct.filt_arm.sym_para_struct=1 then
        pre_sym_delay:=(struct.param.num_macs-struct.param.odd_symmetry)*(struct.filt_arm.inter_tap_delay-1);
        if reqs.family=v5 then
          pre_sym_delay:=(pre_sym_delay/33)+select_integer(0,1,pre_sym_delay rem 33 > 0);
        else
          pre_sym_delay:=(pre_sym_delay/17)+select_integer(0,1,pre_sym_delay rem 17 > 0);
        end if;
        pre_sym_delay:=pre_sym_delay*reqs.data_width;
        
        sym_param_est_orig:=pre_sym_delay+struct.filt_arm_lat.para_sym_slice_est;
        
        struct.filt_arm.sym_para_struct:=3;
        struct.filt_arm_lat:=lat_filt_arm_add_casc(struct.filt_arm);
        --change to fully delay sym structure

        if struct.filt_arm_lat.para_sym_slice_est >= sym_param_est_orig then
          --revert back to predelay structure
          struct.filt_arm.sym_para_struct:=1;
          struct.filt_arm_lat:=lat_filt_arm_add_casc(struct.filt_arm);
        end if;
      end if;

      if (  struct.param.symmetry=1 and
            pass=0 and
            struct.filt_arm_lat.sym_inter_buff_depth>1089 and
            reqs.data_mem_type=c_mem_forced_dist ) then

        --disable symmetry as srl16 will be forced for the delay and its is not able to support >1089
        struct.param.symmetry:=0;
        struct.param.neg_symmetry:=0;
        struct.param.odd_symmetry:=0;
        struct.param.num_taps_calced:=reqs.num_taps;
        pass:=1;
      else
        pass:=2;
      end if;

    end loop;

    --Accumulator settings---------------------------------------
    struct.accum:=(
        family         => reqs.family,
        implementation => implementation,
        pre_add        => 0,
        pre_add_func   => c_preadd_add,
        pre_add_ipreg  => 0,
        pre_add_midreg => 0,
        a_delay        => 1,
        b_delay        => 1,
        a_src          => 0,--fabric
        --c_src          => 1, --alway from another DSP
        a_sign         => struct.param.data_sign,--reqs.data_sign,
        b_sign         => reqs.coef_sign,--not used in single rate
        d_sign         => reqs.data_sign,
        reg_opcode     => 1,
        implement_extra_b_dly => 1 );

    struct.accum_lat:=dtls_emb_calc(struct.accum);

    struct.accum_req:=true;

    if (struct.param.base_count=1 and struct.param.num_macs>1) or
       (struct.param.num_macs=1) then
      struct.accum_req:=false;
    end if;

    --Address generator block settings---------------------------
    struct.base_chan_phase_param:=(
        cnt1_max_val    => struct.param.base_count,
        cnt2_max_val    => reqs.num_channels,
        cnt3_max_val    => 1,
        cnt2_max_qual   => 1,
        family          => reqs.family,
        implementation  => implementation );
        
    struct.data_addr_param:=(
        family          => reqs.family,
        implementation  => implementation,
        mem_type        => struct.param.data_mem_type,
        base_cnt        => struct.param.base_count,
        block_cnt       => reqs.num_channels,
        symmetric       => struct.param.symmetry,
        addr_width      => get_max(1,log2roundup(struct.param.data_mem_depth)),
        sym_addr_width  => get_max(1,log2roundup(struct.param.datasym_mem_depth+struct.param.datasym_mem_offset)),
        combined        => struct.param.data_combined,
        addr_packed     => struct.param.data_packed,
        srl16_sequence  => 0,--uses standard address sequence
        en_dly          => select_integer(0,1,(reqs.has_nd=1 and struct.param.no_data_mem=0) or
                                               struct.shorter_px_time),
        block_end_dly   => 0,  --delay of one due to the generation of addr_en
        last_block_dly  => 0,
        write_phase_dly => 0,
        sub_block_end_dly => 0,
        use_sym_cntrl   => 0,
        resource_opt => reqs.resource_opt  );

    struct.data_addr_lat:=lat_data_address(struct.data_addr_param);

    struct.data_addr_lat:=get_max(0,struct.data_addr_lat-1);
    --sub 1 as only interested in the first location of the count, 
    --this occurs with 0 latency when latency is 1

    struct.coef_addr_param:=(
        family          => reqs.family,
        implementation  => implementation,
        base_cnt        => struct.param.base_count,
        block_cnt       => 1,
        addr_packed     => struct.param.coef_packed,
        addr_width      => get_max(1,log2roundup( struct.param.coef_mem_depth
                                                  +struct.param.coef_mem_offset )),
        num_filters     => reqs.num_filts,--*select_integer(1,2,struct.param.coef_reload=1),
        multi_page_reload => struct.param.coef_reload,
        offset          => struct.param.coef_mem_offset,
        has_ce          => reqs.has_ce,
        use_count_src   => 0,
        en_dly            => select_integer(0,1,(reqs.has_nd=1 and struct.param.no_data_mem=0) or
                                                struct.shorter_px_time),
        base_max_dly      => 0,
        skip_base_max_dly => 0,
        count_max_dly     => 0,
        filt_sel_dly      => 0,
        resource_opt => reqs.resource_opt);-- select_integer(1,2,(reqs.has_nd=1 and struct.param.no_data_mem=0) or
--                                                 struct.shorter_px_time));

    struct.coef_addr_lat:=lat_coef_address(struct.coef_addr_param);

    struct.coef_addr_lat:=get_max(0,struct.coef_addr_lat-1);

    struct.reload_cntrl_param:=(
      family          => reqs.family,
      implementation  => implementation,
      reload_base_cnt => struct.param.base_count,
      coef_addr_packed=> struct.param.coef_packed,
      num_filts       => reqs.num_filts,
      coef_mem_depth  => struct.param.coef_mem_depth,
      num_macs        => struct.param.num_macs,
    
      has_ce          => reqs.has_ce,
      coef_width      => reqs.coef_width,
      filt_sel_width  => reqs.filt_sel_width,
      filt_sel_width_out => select_integer(1,reqs.filt_sel_width+1, reqs.num_filts>1),
      reload_width    => get_max(1,log2roundup( struct.param.coef_mem_depth)),
      resource_opt => reqs.resource_opt,
      has_hb       => 0,
      latch_filt_sel => 1,
      coef_mem_lat => struct.memory_path_lat.coef,
      num_reload_strms => select_integer(1,2,struct.param.coef_mem_type=c_bram) );

    struct.reload_cntrl_param_lat:=lat_coef_reload_cntrl(struct.reload_cntrl_param);

    struct.addr_cntrl_lat:=select_integer(
                                1,
                                2,
                                (reqs.has_nd=1 and struct.param.no_data_mem=0) or
                                struct.shorter_px_time);

    if reqs.coef_reload=1 then
      if struct.reload_cntrl_param_lat.filt_sel_lat-1 < struct.addr_cntrl_lat then
        filter_sel_dly:=struct.addr_cntrl_lat-(struct.reload_cntrl_param_lat.filt_sel_lat-1);
        addr_dly:=0;
      else
        filter_sel_dly:=0;
        addr_dly:=(struct.reload_cntrl_param_lat.filt_sel_lat-1)-struct.addr_cntrl_lat;
        struct.addr_cntrl_lat:=struct.addr_cntrl_lat+addr_dly;
      end if;
    else
      addr_dly:=0;
      filter_sel_dly:=struct.addr_cntrl_lat;
    end if;

    --Check delays for latching signal for sym wrap over-----
    struct.we_sym_dly:=struct.addr_cntrl_lat
                       +get_max(struct.data_addr_lat,struct.coef_addr_lat);

    if struct.filt_arm.output_index(p_WE_SYM_OUT)<=0 and struct.param.symmetry=1 then
      --will not be able to get latching signal for wrap over as not enough mac in filt arm
      if struct.we_sym_dly-1+struct.filt_arm.output_index(p_WE_SYM_OUT)<0 then
        --not enough latency to read earily from generation delay so add latency to addr gen.
        addr_dly:=addr_dly+abs(struct.we_sym_dly-1+struct.filt_arm.output_index(p_WE_SYM_OUT));
        filter_sel_dly:=filter_sel_dly+abs(struct.we_sym_dly-1+struct.filt_arm.output_index(p_WE_SYM_OUT));
        struct.addr_cntrl_lat:=struct.addr_cntrl_lat+abs(struct.we_sym_dly-1+struct.filt_arm.output_index(p_WE_SYM_OUT));
        struct.we_sym_dly:=struct.addr_cntrl_lat
                           +get_max(struct.data_addr_lat,struct.coef_addr_lat);
      end if;
    end if;

    --Balance delays
    struct.data_addr_param.en_dly         :=struct.data_addr_param.en_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat)
                                            +addr_dly;
    struct.data_addr_param.block_end_dly  :=struct.data_addr_param.block_end_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat)
                                            +addr_dly;
    struct.data_addr_param.last_block_dly :=struct.data_addr_param.last_block_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat)
                                            +addr_dly;
    struct.data_addr_param.write_phase_dly :=struct.data_addr_param.write_phase_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat)
                                            +addr_dly;
    struct.data_addr_param.sub_block_end_dly :=struct.data_addr_param.sub_block_end_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat)
                                            +addr_dly;

    struct.coef_addr_param.en_dly         :=struct.coef_addr_param.en_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.base_max_dly  :=struct.coef_addr_param.base_max_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.skip_base_max_dly :=struct.coef_addr_param.skip_base_max_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.count_max_dly :=struct.coef_addr_param.count_max_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.filt_sel_dly :=struct.coef_addr_param.filt_sel_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +filter_sel_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;

    struct.rfd_param:=(
        family          => reqs.family,
        implementation  => implementation,
        cnt             => struct.param.clk_per_chan,
        has_nd          => reqs.has_nd );


    --Latency Calculation
    struct.buffer_type:=0;
    struct.buffer_page_size:=0;
    struct.latency:=struct.param.base_count
                    +struct.addr_cntrl_lat-- -1
                    +get_max(struct.data_addr_lat,struct.coef_addr_lat)
                    +struct.first_tap_extra_dly
                    +struct.filt_arm_lat.cascaded
                    +struct.filt_arm_lat.tap
                    +select_integer(0,1,struct.accum_req)
                    +reqs.reg_output;

    return struct;

  end;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_polyphase_decimation.vhd

  function define_decimation(reqs:t_reqs) return t_define_decimation is
  ------------------------------------------------------------------------------

    variable struct: t_define_decimation;
    --variable mem_param: t_tap_memory_add_casc;
    --variable memory_path_lat: t_lat_tap_memory_add_casc;
    constant srl16_mem_depth_thres: integer:=select_integer(32,64,
                                                            reqs.family=v5);
    constant dram_mem_depth_thres: integer:=select_integer(16,32,
                                                           reqs.family=v5);
    variable implementation:integer:=1;--structural
    variable  taps_per_phase,
              data_depth_unpacked,
              data_depth_packed,
              coef_depth_unpacked,
              coef_depth_packed,
              num_col,
              pass,
              filter_sel_dly,
              addr_dly :integer;
  begin
    --Defaults and direct copies
    struct.param.family:=reqs.family;
    struct.param.filter_type:=reqs.filter_type;
    struct.param.coef_reload:=reqs.coef_reload;
    struct.param.data_sign:=reqs.data_sign;
    struct.param.coef_sign:=reqs.coef_sign;
    struct.param.data_width:=reqs.data_width;
    struct.param.coef_width:=reqs.coef_width;
    struct.param.clk_per_samp:=reqs.clk_per_samp;
    struct.param.num_channels:=reqs.num_channels;
    struct.param.num_taps:=reqs.num_taps;
    struct.param.num_filts:=reqs.num_filts;
    struct.param.zero_packing_factor:=reqs.zero_packing_factor;

    struct.param.symmetry:=reqs.symmetry;
    struct.param.neg_symmetry:=reqs.neg_symmetry;
    struct.param.odd_symmetry:=select_integer(0,reqs.num_taps rem 2,struct.param.symmetry=1);
    struct.param.num_taps_calced:=(reqs.num_taps/2**struct.param.symmetry)+struct.param.odd_symmetry;

    --loop round here once checked depth of inter tap buffer depth
     pass:=0;
     while pass<2 loop
      --Calculate details of the filter-------------------------------------------
      --Number of macs and number of taps per mac
      if ( reqs.clk_per_samp/reqs.num_channels = 0 ) then
        report "FIR: not enough clock cycles per sample to process all channels, must have a minimum of 1 clk cycle per channel" severity error;
      elsif ( reqs.clk_per_samp rem reqs.num_channels > 0 ) then
        report "FIR: number of channels does not fit fully into clock cycles per sample, there will be unused clock cycles" severity note;
      end if;
          
      struct.param.clk_per_chan := reqs.clk_per_samp / reqs.num_channels;

      struct.param.base_count := struct.param.clk_per_chan;

      taps_per_phase:= struct.param.num_taps_calced / reqs.deci_rate;
      if ( struct.param.num_taps_calced rem reqs.deci_rate > 0) then
        taps_per_phase:=taps_per_phase+1;
      end if;

      struct.param.num_macs := taps_per_phase/struct.param.base_count;

      if ( taps_per_phase rem struct.param.base_count > 0 ) then
      -- Add extra mac, this mac will need the filter coefficients padded out.
        struct.param.num_macs:=struct.param.num_macs+1;
      end if;

      --Adjust for unused cycles
      struct.param.base_count:=taps_per_phase/struct.param.num_macs;
      if (taps_per_phase rem struct.param.num_macs >0) then
        struct.param.base_count:=struct.param.base_count+1;
      end if;

      if struct.param.base_count<struct.param.clk_per_chan and struct.param.base_count>1 then
        struct.shorter_px_time:=true;
      else
        struct.shorter_px_time:=false;
      end if;

      if pass=0 then
        struct.param.centre_mac:=struct.param.num_macs;
      end if;

      --struct.param.base_data_space := struct.param.base_count*reqs.deci_rate;
      struct.param.base_coef_space := struct.param.base_count*reqs.deci_rate;

      -- Modify and update so get actual filter size
      struct.param.num_taps_calced:=struct.param.num_macs*struct.param.base_count*reqs.deci_rate;

      struct.param.inter_rate := 1;
      struct.param.deci_rate  := reqs.deci_rate;

      struct.param.no_data_mem:= 0;
      if (struct.param.base_count = 1) then
        struct.param.no_data_mem:= 1;
      end if;

      struct.output_rate:=struct.param.clk_per_chan*reqs.deci_rate;

      --Structural decisions------------------------------------------------------
      struct.param.single_mac:=0;
      if reqs.family/=s3ax then
        --Virtex
        if struct.param.num_macs=1 then
          struct.param.single_mac:=1;
        end if;
      else
        --Sandia
        if struct.param.num_macs=1 then -- and
--            (reqs.num_channels=1 or
--             struct.shorter_px_time) then
          --when shorter_px_time can uses a load on a spare cycle
          struct.param.single_mac:=1;
        end if;
      end if;


      --Memory calculations-------------------------------------
      data_depth_unpacked:=2**log2roundup(struct.param.base_count)*(reqs.num_channels*reqs.deci_rate);
      data_depth_packed:=struct.param.base_count*reqs.num_channels*reqs.deci_rate;

      -- coef_depth_unpacked:=2**log2roundup(struct.param.base_coef_space)*struct.param.num_filts;
--       coef_depth_packed:=struct.param.base_coef_space*struct.param.num_filts;

      coef_depth_unpacked:=2**log2roundup( 2**log2roundup(struct.param.base_coef_space)*struct.param.num_filts)*2**struct.param.coef_reload;
      coef_depth_packed:=struct.param.base_coef_space*struct.param.num_filts*2**struct.param.coef_reload;

      struct.param:=memory_calcs( reqs,
                                  struct.param,
                                  data_depth_unpacked,
                                  data_depth_packed,
                                  coef_depth_unpacked,
                                  coef_depth_packed);

      --Symmetric wrap over calculations-------------------------
      --need to know latency of memory implmented
      struct.mem_param:=( family           =>reqs.family,
                          implementation   =>implementation,
                          data_mem_type    =>struct.param.data_mem_type,
                          coef_mem_type    =>struct.param.coef_mem_type,
                          data_comb        =>struct.param.data_combined,
                          data_coef_comb   =>struct.param.data_coef_combined,
                          no_data_mem      =>struct.param.no_data_mem,
                          coef_mem_depth  => struct.param.coef_mem_depth,
                          has_ce           =>reqs.has_ce,
                          coef_reload      =>reqs.coef_reload,
                          coef_reload_depth=>struct.param.base_coef_space,
                          symmetric        =>struct.param.symmetry );
  
      struct.memory_path_lat:=lat_tap_memory_add_casc(struct.mem_param);

      struct.wrap_over_param:=(
        family            =>struct.param.family,
        implementation    =>1,
        base_count        =>struct.param.base_count,
        num_phases        =>struct.param.deci_rate,
        num_channels      =>struct.param.num_channels,
        sym_type          =>struct.param.odd_symmetry,
        driving_mem_type  =>struct.param.data_mem_type,
        driving_mem_lat   =>struct.memory_path_lat.data,
        force_srl16_mem   =>select_integer(0,1,reqs.datapath_mem_type=c_mem_forced_dist),
        has_ce            =>reqs.has_ce,
        has_nd            =>reqs.has_nd );

      struct.wrap_over_lat:=lat_polyphase_decimation_sym_wrap(struct.wrap_over_param);

      if reqs.has_nd=0 and struct.param.base_count=1 and struct.param.symmetry=1 then

        if struct.wrap_over_lat>=struct.param.num_macs then
          struct.para_sym_struct:=1;
        else
          struct.para_sym_struct:=2;
        end if;

      elsif reqs.has_nd=1 and struct.param.base_count=1 and struct.param.symmetry=1 then
        struct.para_sym_struct:=1;
      else
        struct.para_sym_struct:=0;
      end if;

--       struct.cyc_to_data_out:=struct.memory_path_lat.data+1;--plus one for the latch (min depth of 1 in delay)
--       
--       struct.cyc_to_write:=0;
--       if (struct.mem_param.data_mem_type=1) then
--         struct.cyc_to_write:=struct.param.base_count; --inter_we_cycles
--       end if;
-- 
--       -- struct.num_cyc_read_earily:= select_integer(0,1,struct.cyc_to_write-struct.cyc_to_data_out<0)
-- --                                   +select_integer(0,1,struct.param.odd_symmetry=1);
--
--       struct.num_cyc_read_earily:= select_integer(0,1,struct.cyc_to_write+struct.param.odd_symmetry-struct.cyc_to_data_out<0)
--                                   +select_integer(0,1,struct.param.odd_symmetry=1);
--       --add odd sym when calc if need earily read as when odd sym will read data earily this gives longer to get
--       --data out of memory. So then check if still don't have enough time to get data out of memory
--
--       struct.change_src:=select_integer(0,1,struct.num_cyc_read_earily>=struct.param.base_count);
--
--       struct.extra_dly:=select_integer(0,1,(struct.cyc_to_data_out-struct.num_cyc_read_earily<=struct.cyc_to_write and
--                                             struct.num_cyc_read_earily-struct.param.odd_symmetry>0 and
--                                             struct.change_src=0) or
--                                            (struct.param.no_data_mem=1 and struct.param.odd_symmetry=1) );

      struct.add_sup_dly:=struct.memory_path_lat.data;
      
      struct.first_tap_extra_dly:=0;

      if struct.param.data_mem_type=c_srl16 and struct.param.no_data_mem=0 then
        struct.data_dly_modifier:=-1;
      else
        struct.data_dly_modifier:=0;
      end if;

      if struct.param.no_data_mem=1 then
        if struct.memory_path_lat.coef>1 then
          --filt casc can direct emb_calc to compensate  for a difference of 1, any more
          --and need extra delay.
          struct.data_dly_modifier:=struct.data_dly_modifier+struct.memory_path_lat.coef-1;
          struct.add_sup_dly:=struct.add_sup_dly+struct.memory_path_lat.coef-1;
          struct.first_tap_extra_dly:=struct.memory_path_lat.coef-1;
        end if;
      end if;

      --Filter arm settings-------------------------------------
      if (reqs.col_mode=1) then
        -- if (struct.param.num_macs>reqs.col_1st_len) then
--           num_col:=1+(struct.param.num_macs-reqs.col_1st_len)/reqs.col_wrap_len;
--         else
--           num_col:=1;
--         end if;
        num_col:=calc_num_split_col(struct.param.num_macs,t_col_len'(
                                   0 => select_integer(reqs.col_wrap_len,reqs.col_1st_len,reqs.col_mode=1),
                                   others=>reqs.col_wrap_len));
      elsif (reqs.col_mode=2) then
        -- no generic for this mode yet
        num_col:=1;
      else
        num_col:=1;
      end if;

      struct.filt_arm:= (
          family          => reqs.family,
          implementation  => implementation,
          num_taps        => struct.param.num_macs,
          inter_we_cycles => struct.param.base_count,
          inter_tap_delay => (struct.param.num_channels*reqs.deci_rate)+1,
          inter_sym_tap_delay => (struct.param.num_channels*reqs.deci_rate)+1,
          symmetric       => struct.param.symmetry,
          pre_add_func    => select_integer(c_preadd_add,c_preadd_sub,struct.param.neg_symmetry=1),
          data_mem_type   => struct.param.data_mem_type,
          coef_mem_type   => struct.param.coef_mem_type,
          data_comb       => struct.param.data_combined,
          data_coef_comb  => struct.param.data_coef_combined,
          data_cascade    => 0,
          no_data_mem     => struct.param.no_data_mem,
          coef_mem_depth  => struct.param.coef_mem_depth,
          p_src           => 0,--fabric
          data_sign       => reqs.data_sign,
          coef_sign       => reqs.coef_sign,
          has_ce          => reqs.has_ce,
          --has_nd          => reqs.has_nd,
          reload          => reqs.coef_reload,
          reload_strms    => select_integer(1,2,struct.param.coef_mem_type=c_bram),
          reload_depth    => struct.param.base_coef_space,
          output_index    => (
                            p_P_OUT       => struct.param.num_macs+1,
                            p_PC_OUT      => struct.param.num_macs+1,
                            p_D_OUT       => struct.param.num_macs
                                             +select_integer(
                                                0,
                                                -1,--1-struct.wrap_over_lat,
                                                struct.para_sym_struct=2),
                            p_D_SYM_OUT   => struct.param.num_macs,
                            p_C_OUT       => struct.param.num_macs,
                            p_WE_OUT      => struct.param.num_macs
                                             +select_integer(
                                                0,
                                                -1,--1-struct.wrap_over_lat,
                                                struct.para_sym_struct=2),
                            p_WE_SYM_OUT  => struct.param.num_macs,
                            p_ADDSUB_OUT  => struct.param.num_macs+1,
                            p_ADDSUP_OUT  => struct.param.num_macs+1,
                            p_WE_SYM_OUT_2    => --select_integer(
                                                  struct.param.num_macs-1--,
                                                  -- 1,
--                                                   struct.param.no_data_mem=0 and
--                                                   struct.param.num_macs=1)
                                                  ),
          output_src      => (
                            p_P_OUT       => 0,
                            p_PC_OUT       => 0,
                            p_D_OUT       => 1,
                            p_D_SYM_OUT   => 0,
                            p_C_OUT       => 0,
                            p_WE_OUT      => 0,
                            p_WE_SYM_OUT  => 0,
                            p_ADDSUB_OUT  => 0,
                            p_ADDSUP_OUT  => 0,
                            p_WE_SYM_OUT_2    => 0 ),
          num_independant_col => select_integer(1,num_col,reqs.col_mode=2),
          num_split_col       => select_integer(1,num_col,reqs.col_mode=1),
          inter_split_col_dly => reqs.col_pipe_len,
          col_len             => ( 0 => select_integer(reqs.col_wrap_len,reqs.col_1st_len,reqs.col_mode=1),
                                   others=>reqs.col_wrap_len),
          dynamic_opcode  => select_integer(0,1,struct.param.single_mac=1),
          sym_para_struct => select_integer(0,1,struct.para_sym_struct=1),--reqs.has_nd,
          para_casc_we_src=> select_integer(0,1, reqs.has_nd=1 or struct.shorter_px_time),
          resource_opt    => reqs.resource_opt,
          data_width      => reqs.data_width,
          datapath_mem_type => reqs.datapath_mem_type,
          odd_symmetry    => struct.param.odd_symmetry );
          --para_casc_we_src selects if a constant we is used which is OK but the parallel structure can be a long delay line
          --even when no ND when there is not enough taps to to look forward enough. The struct.para_sym_struct parammeter
          --controls the symmetric structure used

      struct.filt_arm_lat:=lat_filt_arm_add_casc(struct.filt_arm);

      if (  struct.param.symmetry=1 and
            pass=0 and
            struct.filt_arm_lat.sym_inter_buff_depth>1089 and
            reqs.data_mem_type=c_mem_forced_dist ) then

        --disable symmetry as srl16 will be forced for the delay and its is not able to support >1089
        struct.param.symmetry:=0;
        struct.param.neg_symmetry:=0;
        struct.param.odd_symmetry:=0;
        struct.param.num_taps_calced:=reqs.num_taps;
        pass:=1;
      else
        pass:=2;
      end if;

    end loop;

    --Accumulator settings---------------------------------------
    struct.accum:=(
        family         => reqs.family,
        implementation => implementation,
        pre_add        => 0,
        pre_add_func   => c_preadd_add,
        pre_add_ipreg  => 0,
        pre_add_midreg => 0,
        a_delay        => 0,--1,
        b_delay        => 0,--1,
        a_src          => 0,--fabric
        --c_src          => 1, --alway from another DSP
        a_sign         => c_signed,--reqs.data_sign,
        b_sign         => c_signed,--reqs.coef_sign,--not used in single rate
        d_sign         => c_signed,--reqs.data_sign,
        reg_opcode     => 1,
        implement_extra_b_dly => 1 );

    struct.accum_lat:=dtls_emb_calc(struct.accum);

    struct.accum_req:=true;

    if (struct.param.single_mac=1) then
      struct.accum_req:=false;
    end if;

    struct.use_c_port_as_storage:=true;
    if reqs.resource_opt=c_speed and reqs.has_ce=1 and struct.param.no_data_mem=0 then
      struct.use_c_port_as_storage:=false;
    end if;

    --Output buffer ram settings---------------------------------
    struct.output_buffer_depth:=2*reqs.num_channels;

    struct.has_output_buffer:=false;
    if reqs.num_channels>1 then
      struct.has_output_buffer:=true;
    end if;

    struct.output_buffer:=(
      family              => reqs.family,
      implementation      => implementation,
      mem_type            => select_integer(
                              c_dram,--dram
                              c_bram,--bram
                              (struct.output_buffer_depth>dram_mem_depth_thres and reqs.opbuff_mem_type/=c_mem_forced_dist) or
                               reqs.opbuff_mem_type=c_mem_forced_bram ),
      write_mode          => 0,--read first
      has_ce              => reqs.has_ce,
      use_mif             => 0 );

    struct.output_buffer_in_addr:=(
      family => reqs.family,
      implementation => implementation,
      addr_width => get_max(1,log2roundup(struct.output_buffer_depth)),
      page_size => reqs.num_channels,
      num_enables => 1 );
    
    struct.output_buffer_out_addr:=struct.output_buffer_in_addr;

    struct.output_rate_counter:=(
        cnt1_max_val    => struct.output_rate,
        cnt2_max_val    => 1,
        cnt3_max_val    => 1,
        cnt2_max_qual   => 1,
        family          => reqs.family,
        implementation  => implementation );

    struct.extra_opb_reg:=0;
    if struct.has_output_buffer and reqs.resource_opt=c_speed and struct.output_buffer.mem_type=c_dram then
        struct.extra_opb_reg:=1;
    end if;

    if struct.has_output_buffer then
      struct.output_buffer_lat:=lat_ram(struct.output_buffer,2);
    else
      struct.output_buffer_lat:=0;
    end if;

    --Address generator block settings---------------------------
    struct.base_chan_phase_param:=(
        cnt1_max_val    => struct.param.base_count,
        cnt2_max_val    => reqs.num_channels,
        cnt3_max_val    => reqs.deci_rate,
        cnt2_max_qual   => 1,
        family          => reqs.family,
        implementation  => implementation );
        
    struct.data_addr_param:=(
        family          => reqs.family,
        implementation  => implementation,
        mem_type        => struct.param.data_mem_type,
        base_cnt        => struct.param.base_count,
        block_cnt       => reqs.num_channels*reqs.deci_rate,
        symmetric       => struct.param.symmetry,
        addr_width      => get_max(1,log2roundup(struct.param.data_mem_depth)),
        sym_addr_width  => get_max(1,log2roundup(struct.param.datasym_mem_depth+struct.param.datasym_mem_offset)),
        combined        => struct.param.data_combined,
        addr_packed     => struct.param.data_packed,
        srl16_sequence  => 0,--uses standard address sequence
        en_dly          => select_integer(0,1,(reqs.has_nd=1 and struct.param.no_data_mem=0) or
                                               struct.shorter_px_time),
        block_end_dly   => 0,  --delay of one due to the generation of addr_en
        last_block_dly  => 0,
        write_phase_dly => 0,
        sub_block_end_dly => 0,
        use_sym_cntrl   => 0,
        resource_opt => reqs.resource_opt  );

    struct.data_addr_lat:=lat_data_address(struct.data_addr_param);

    struct.data_addr_lat:=get_max(0,struct.data_addr_lat-1);
    --sub 1 as only interested in the first location of the count, 
    --this occurs with 0 latency when latency is 1

    struct.coef_addr_param:=(
        family          => reqs.family,
        implementation  => implementation,
        base_cnt        => struct.param.base_count,
        block_cnt       => reqs.deci_rate,
        addr_packed     => struct.param.coef_packed,
        addr_width      => get_max(1,log2roundup( struct.param.coef_mem_depth
                                                  +struct.param.coef_mem_offset )),
        num_filters     => reqs.num_filts,--*select_integer(1,2,struct.param.coef_reload=1),
        multi_page_reload => struct.param.coef_reload,
        offset          => struct.param.coef_mem_offset,
        has_ce          => reqs.has_ce,
        use_count_src   => 0,
        en_dly            => select_integer(0,1,(reqs.has_nd=1 and struct.param.no_data_mem=0) or
                                                struct.shorter_px_time),
        base_max_dly      => 0,
        skip_base_max_dly => 0,
        count_max_dly     => 0,
        filt_sel_dly      => 0,
        resource_opt => reqs.resource_opt);-- select_integer(1,2,(reqs.has_nd=1 and struct.param.no_data_mem=0) or
--                                                 struct.shorter_px_time));

    struct.coef_addr_lat:=lat_coef_address(struct.coef_addr_param);
    
    struct.coef_addr_lat:=get_max(0,struct.coef_addr_lat-1);

    struct.reload_cntrl_param:=(
      family          => reqs.family,
      implementation  => implementation,
      reload_base_cnt => struct.param.base_count*reqs.deci_rate,
      coef_addr_packed=> struct.param.coef_packed,
      num_filts       => reqs.num_filts,
      coef_mem_depth  => struct.param.coef_mem_depth,
      num_macs        => struct.param.num_macs,

      has_ce          => reqs.has_ce,
      coef_width      => reqs.coef_width,
      filt_sel_width  => reqs.filt_sel_width,
      filt_sel_width_out => select_integer(1,reqs.filt_sel_width+1, reqs.num_filts>1),
      reload_width    => get_max(1,log2roundup( struct.param.coef_mem_depth)),
      resource_opt => reqs.resource_opt,
      has_hb       => 0,
      latch_filt_sel => 0,
      coef_mem_lat => struct.memory_path_lat.coef,
      num_reload_strms => select_integer(1,2,struct.param.coef_mem_type=c_bram) );

    struct.reload_cntrl_param_lat:=lat_coef_reload_cntrl(struct.reload_cntrl_param);
    struct.reload_cntrl_param_lat.filt_sel_lat:=struct.reload_cntrl_param_lat.filt_sel_lat+1;-- +2;--1;
    --add one as filter sel latch is done using we_gen_dly , rather than nd_rfd. This is    --we_gen
    --to allign correctly with first_phase   
    --UPDATE: the delay struct.filter_sel_lat generates the delay of one cycle, only need to account
    --for an extra delay

    struct.addr_cntrl_lat:=select_integer(
                                1,
                                2,
                                (reqs.has_nd=1 and struct.param.no_data_mem=0) or
                                struct.shorter_px_time);

    if reqs.num_filts>1 or reqs.coef_reload=1 then --same delay effects reload
      struct.filter_sel_lat:=1;
      --have added a delay to filter sel as need to recycle value
    else
      struct.filter_sel_lat:=0;
    end if;

    if reqs.coef_reload=1 then
      if struct.reload_cntrl_param_lat.filt_sel_lat-1+struct.filter_sel_lat < struct.addr_cntrl_lat then
        filter_sel_dly:=struct.addr_cntrl_lat-(struct.reload_cntrl_param_lat.filt_sel_lat-1+struct.filter_sel_lat);
        addr_dly:=0;
      else
        filter_sel_dly:=0;
        addr_dly:=(struct.reload_cntrl_param_lat.filt_sel_lat-1+struct.filter_sel_lat)-struct.addr_cntrl_lat;
        struct.addr_cntrl_lat:=struct.addr_cntrl_lat+addr_dly;
      end if;
    else
      addr_dly:=0;
      filter_sel_dly:=struct.addr_cntrl_lat-struct.filter_sel_lat;
    end if;

    --Balance delays
    struct.data_addr_param.en_dly         :=struct.data_addr_param.en_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat)
                                            +addr_dly;
    struct.data_addr_param.block_end_dly  :=struct.data_addr_param.block_end_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat)
                                            +addr_dly;
    struct.data_addr_param.last_block_dly :=struct.data_addr_param.last_block_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat)
                                            +addr_dly;

    struct.coef_addr_param.en_dly         :=struct.coef_addr_param.en_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.base_max_dly  :=struct.coef_addr_param.base_max_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.skip_base_max_dly :=struct.coef_addr_param.skip_base_max_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.count_max_dly :=struct.coef_addr_param.count_max_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.filt_sel_dly :=struct.coef_addr_param.filt_sel_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +filter_sel_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    
    struct.para_sym_addr_delay:=0;
    if struct.para_sym_struct=2 then

      struct.para_sym_delay:=(struct.param.deci_rate*reqs.num_channels)+1
                             -struct.wrap_over_lat;
                             --+struct.data_dly_modifier;

    elsif struct.para_sym_struct=1 then

      report "FIR: addr gen delay: "&int_to_str(get_max(struct.data_addr_lat,struct.coef_addr_lat)+struct.addr_cntrl_lat);---1);
      report "FIR: wrap buffer delay: "&int_to_str(struct.wrap_over_lat);

      if (get_max(struct.data_addr_lat,struct.coef_addr_lat)+struct.addr_cntrl_lat-- -1
          +struct.data_dly_modifier) > struct.wrap_over_lat then
        -- struct.para_sym_delay:= (get_max(struct.data_addr_lat,struct.coef_addr_lat)+struct.addr_cntrl_lat-1+struct.data_dly_modifier) -
--                                 struct.wrap_over_lat;
        struct.para_sym_delay:= (get_max(struct.data_addr_lat,struct.coef_addr_lat)+struct.addr_cntrl_lat+struct.data_dly_modifier) -
                                struct.wrap_over_lat;
      else
        struct.para_sym_delay:=0;
        struct.para_sym_addr_delay:=struct.wrap_over_lat -
                                    (get_max(struct.data_addr_lat,struct.coef_addr_lat)+struct.addr_cntrl_lat-- -1
                                     +struct.data_dly_modifier);

        struct.data_addr_param.en_dly         :=struct.data_addr_param.en_dly         +struct.para_sym_addr_delay;
        struct.data_addr_param.block_end_dly  :=struct.data_addr_param.block_end_dly  +struct.para_sym_addr_delay;
        struct.data_addr_param.last_block_dly :=struct.data_addr_param.last_block_dly +struct.para_sym_addr_delay;
        struct.coef_addr_param.en_dly             :=struct.coef_addr_param.en_dly             +struct.para_sym_addr_delay;
        struct.coef_addr_param.base_max_dly       :=struct.coef_addr_param.base_max_dly       +struct.para_sym_addr_delay;
        struct.coef_addr_param.skip_base_max_dly  :=struct.coef_addr_param.skip_base_max_dly  +struct.para_sym_addr_delay;
        struct.coef_addr_param.count_max_dly      :=struct.coef_addr_param.count_max_dly      +struct.para_sym_addr_delay;
        struct.coef_addr_param.filt_sel_dly       :=struct.coef_addr_param.filt_sel_dly       +struct.para_sym_addr_delay;
      end if;
    end if;

    struct.rfd_param:=(
        family          => reqs.family,
        implementation  => implementation,
        cnt             => struct.param.clk_per_chan,
        has_nd          => reqs.has_nd );


    --Latency Calculation
    struct.buffer_type:=select_integer(0,2,struct.has_output_buffer);
    struct.buffer_page_size:=reqs.num_channels;
    struct.sample_latency:=(reqs.num_channels*(reqs.deci_rate-1))+1;
    struct.latency:=struct.param.base_count
                    +struct.addr_cntrl_lat-- -1
                    +get_max(struct.data_addr_lat,struct.coef_addr_lat)
                    +struct.para_sym_addr_delay
                    +struct.first_tap_extra_dly
                    +struct.filt_arm_lat.cascaded
                    +struct.filt_arm_lat.tap
                    +select_integer(0,1,struct.accum_req)
                    +select_integer(0,struct.output_buffer_lat+
                                      struct.output_rate+
                                      struct.extra_opb_reg,
                                    struct.has_output_buffer)
                    +reqs.reg_output;

    return struct;

  end;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_halfband.vhd

  function define_halfband(reqs:t_reqs) return t_define_halfband is
  ------------------------------------------------------------------------------

    variable struct: t_define_halfband;
    --variable mem_param: t_tap_memory_add_casc;
    --variable memory_path_lat: t_lat_tap_memory_add_casc;
    constant srl16_mem_depth_thres: integer:=select_integer(32,64,
                                                            reqs.family=v5);
    constant dram_mem_depth_thres: integer:=select_integer(16,32,
                                                           reqs.family=v5);
    variable implementation:integer:=1;--structural
    variable  taps_per_phase,
              data_depth_unpacked,
              data_depth_packed,
              coef_depth_unpacked,
              coef_depth_packed,
              num_col,
              pass,
              filter_sel_dly,
              addr_dly,
              pre_sym_delay,
              sym_param_est_orig :integer;
  begin
    --Defaults and direct copies
    struct.param.family:=reqs.family;
    struct.param.filter_type:=reqs.filter_type;
    struct.param.coef_reload:=reqs.coef_reload;
    struct.param.data_sign:=reqs.data_sign;
    struct.param.coef_sign:=reqs.coef_sign;
    struct.param.data_width:=reqs.data_width;
    struct.param.coef_width:=reqs.coef_width;
    struct.param.clk_per_samp:=reqs.clk_per_samp;
    struct.param.num_channels:=reqs.num_channels;
    struct.param.num_taps:=reqs.num_taps;
    struct.param.num_filts:=reqs.num_filts;
    struct.param.zero_packing_factor:=reqs.zero_packing_factor;

    struct.param.symmetry:=1;--reqs.symmetry;
    struct.param.neg_symmetry:=0;--reqs.neg_symmetry;
    struct.param.odd_symmetry:=0;--select_integer(0,reqs.num_taps rem 2,struct.param.symmetry=1);
    struct.param.num_taps_calced:=(reqs.num_taps/2**struct.param.symmetry)+1;--struct.param.odd_symmetry;

    --loop round here once checked depth of inter tap buffer depth
     pass:=0;
     while pass<2 loop
      --Calculate details of the filter-------------------------------------------
      --Number of macs and number of taps per mac
      if ( reqs.clk_per_samp/reqs.num_channels = 0 ) then
        report "FIR: not enough clock cycles per sample to process all channels, must have a minimum of 1 clk cycle per channel" severity error;
      elsif ( reqs.clk_per_samp rem reqs.num_channels > 0 ) then
        report "FIR: number of channels does not fit fully into clock cycles per sample, there will be unused clock cycles" severity note;
      end if;
          
      struct.param.clk_per_chan := reqs.clk_per_samp / reqs.num_channels;
          
      struct.param.base_count := struct.param.clk_per_chan;

      taps_per_phase:= struct.param.num_taps_calced/ 2;
      if ( struct.param.num_taps_calced rem 2 > 0) then
        taps_per_phase:=taps_per_phase+1;
      end if;

      struct.param.num_macs :=taps_per_phase/ struct.param.base_count;

      struct.param.single_mac:=0;
      if struct.param.num_macs=0 then
        struct.param.single_mac:=1;
      end if;

      if ( taps_per_phase rem struct.param.base_count > 0 ) then
      -- Add extra mac, this mac will need the filter coefficients padded out.
        struct.param.num_macs:=struct.param.num_macs+1;
      end if;

      --Adjust for unused cycles
      if struct.param.single_mac=1 then
        --SMAC
        struct.param.base_count:=taps_per_phase+1;
      else
        --Normal
        struct.param.base_count:=taps_per_phase/struct.param.num_macs;
        if (taps_per_phase rem struct.param.num_macs >0) then
          struct.param.base_count:=struct.param.base_count+1;
        end if;
      end if;

      if struct.param.base_count<struct.param.clk_per_chan then
        struct.shorter_px_time:=true;
      else
        struct.shorter_px_time:=false;
      end if;

      if pass=0 then
        struct.param.centre_mac:=struct.param.num_macs;
      end if;

      struct.param.base_data_space := struct.param.base_count;
      struct.param.base_coef_space := struct.param.base_count;

      -- Modify and update so get actual filter size
      struct.param.num_taps_calced:=struct.param.num_macs*(struct.param.base_count-struct.param.single_mac)*2;
      --base count is extended by one for single mac but the multiply by 2 shouldn't be applied to that
      --extra value as the *2 is to insert the zero phase which the centre tap is one off.

      struct.param.inter_rate := 1;
      struct.param.deci_rate  := 2;

      struct.param.no_data_mem:= 0;
      if (struct.param.base_count = 1) then
        struct.param.no_data_mem:= 1;
      end if;

      --Structural decisions------------------------------------------------------


      --Memory calculations-------------------------------------
      data_depth_unpacked:=2**log2roundup(struct.param.base_data_space)*(reqs.num_channels*2);
      data_depth_packed:=struct.param.base_data_space*reqs.num_channels*2;

      -- coef_depth_unpacked:=2**log2roundup(struct.param.base_coef_space)*struct.param.num_filts;
--       coef_depth_packed:=struct.param.base_coef_space*struct.param.num_filts;
  
      coef_depth_unpacked:=2**log2roundup( 2**log2roundup(struct.param.base_coef_space)*struct.param.num_filts)*2**struct.param.coef_reload;
      coef_depth_packed:=struct.param.base_coef_space*struct.param.num_filts*2**struct.param.coef_reload;

      struct.param:=memory_calcs( reqs,
                                  struct.param,
                                  data_depth_unpacked,
                                  data_depth_packed,
                                  coef_depth_unpacked,
                                  coef_depth_packed);

      --Symmetric wrap over calculations-------------------------
      --need to know latency of memory implmented
      struct.mem_param:=( family           =>reqs.family,
                          implementation   =>implementation,
                          data_mem_type    =>struct.param.data_mem_type,
                          coef_mem_type    =>struct.param.coef_mem_type,
                          data_comb        =>struct.param.data_combined,
                          data_coef_comb   =>struct.param.data_coef_combined,
                          no_data_mem      =>struct.param.no_data_mem,
                          coef_mem_depth  => struct.param.coef_mem_depth,
                          has_ce           =>reqs.has_ce,
                          coef_reload      =>reqs.coef_reload,
                          coef_reload_depth=>struct.param.base_coef_space,
                          symmetric        =>struct.param.symmetry );

      struct.memory_path_lat:=lat_tap_memory_add_casc(struct.mem_param);
  
      struct.cyc_to_data_out:=struct.memory_path_lat.data+1;--plus one for the latch (min depth of 1 in delay)

      struct.cyc_to_write:=0;
      if (struct.mem_param.data_mem_type/=c_srl16) then -- =c_bram) then
        struct.cyc_to_write:=struct.param.base_count; --inter_we_cycles
      end if;
      
      -- struct.cyc_to_write:=2*reqs.num_channels*struct.param.base_count;
--       if (struct.mem_param.data_mem_type=0) then
--         struct.cyc_to_write:=struct.cyc_to_write-struct.param.base_count;
--       end if;

      -- struct.num_cyc_read_earily:= select_integer(0,1,struct.cyc_to_write-struct.cyc_to_data_out<0)
--                                   +select_integer(0,1,struct.param.odd_symmetry=1);

      struct.num_cyc_read_earily:= select_integer(0,1,struct.cyc_to_write+struct.param.odd_symmetry-struct.cyc_to_data_out<0)
                                  +select_integer(0,1,struct.param.odd_symmetry=1);
      --add odd sym when calc if need earily read as when odd sym will read data earily this gives longer to get
      --data out of memory. So then check if still don't have enough time to get data out of memory

      struct.change_src:=select_integer(0,1,struct.num_cyc_read_earily>=struct.param.base_count);

      -- struct.extra_dly:=select_integer(
--                           select_integer(0,2,struct.cyc_to_data_out-struct.num_cyc_read_earily<=struct.cyc_to_write and
--                                              struct.num_cyc_read_earily-struct.param.odd_symmetry>0 and
--                                              struct.change_src=0),
--                                           --extra dly is 2 in this case because of the effective two phases
--                           select_integer(0,1,struct.num_cyc_read_earily=1),
--                           struct.param.data_mem_type=0);
--                                           --only need a delay by 1 for srl16's as the write to mem is a cycle earlier
      struct.extra_dly:=select_integer(
                          0,
                          select_integer(
                            (2*reqs.num_channels)-1,--1,
                            (2*reqs.num_channels),--2,
                            struct.cyc_to_data_out-struct.num_cyc_read_earily<=struct.cyc_to_write),
                            --test is moved past another WE pulse by reading earily
                          struct.num_cyc_read_earily-struct.param.odd_symmetry>0 and
                          struct.change_src=0);

      struct.add_sup_dly:=struct.memory_path_lat.data;

      struct.first_tap_extra_dly:=0;

      if struct.param.data_mem_type=c_srl16 and struct.param.no_data_mem=0 then
        struct.data_dly_modifier:=-1;
      else
        struct.data_dly_modifier:=0;
      end if;

      if struct.param.no_data_mem=1 then
        if struct.memory_path_lat.coef>1 then
          --filt casc can direct emb_calc to compensate  for a difference of 1, any more
          --and need extra delay.
          struct.data_dly_modifier:=struct.data_dly_modifier+struct.memory_path_lat.coef-1;
          struct.add_sup_dly:=struct.add_sup_dly+struct.memory_path_lat.coef-1;
          struct.first_tap_extra_dly:=struct.memory_path_lat.coef-1;
        end if;
      end if;

      --Filter arm settings-------------------------------------
      if (reqs.col_mode=1) then
        -- if (struct.param.num_macs>reqs.col_1st_len) then
--           num_col:=1+(struct.param.num_macs-reqs.col_1st_len)/reqs.col_wrap_len;
--         else
--           num_col:=1;
--         end if;
        num_col:=calc_num_split_col(struct.param.num_macs,t_col_len'(
                                   0 => select_integer(reqs.col_wrap_len,reqs.col_1st_len,reqs.col_mode=1),
                                   others=>reqs.col_wrap_len));
      elsif (reqs.col_mode=2) then
        -- no generic for this mode yet
        num_col:=1;
      else
        num_col:=1;
      end if;

      struct.filt_arm:= (
          family          => reqs.family,
          implementation  => implementation,
          num_taps        => struct.param.num_macs,
          inter_we_cycles => struct.param.base_count,
          inter_tap_delay => (struct.param.num_channels*2)+1,
          inter_sym_tap_delay => (struct.param.num_channels*2)+1,
          symmetric       => struct.param.symmetry,
          pre_add_func    => select_integer(c_preadd_add,c_preadd_add_swapped,reqs.family=s3ax and struct.param.single_mac=1),--add
          data_mem_type   => struct.param.data_mem_type,
          coef_mem_type   => struct.param.coef_mem_type,
          data_comb       => struct.param.data_combined,
          data_coef_comb  => struct.param.data_coef_combined,
          data_cascade    => 0,
          no_data_mem     => struct.param.no_data_mem,
          coef_mem_depth  => struct.param.coef_mem_depth,
          p_src           => 0,--fabric
          data_sign       => reqs.data_sign,
          coef_sign       => reqs.coef_sign,
          has_ce          => reqs.has_ce,
          --has_nd          => reqs.has_nd,
          reload          => reqs.coef_reload,
          reload_strms    => select_integer(1,2,struct.param.coef_mem_type=c_bram),
          reload_depth    => struct.param.base_coef_space,
          output_index    => (
                            p_P_OUT       => struct.param.num_macs+1,
                            p_PC_OUT      => struct.param.num_macs+1,
                            p_D_OUT       => select_integer(
                                                struct.param.num_macs,
                                                struct.param.centre_mac,
                                                struct.param.symmetry=0),-- -struct.change_src,
                                              --when sym=0 then sym has been disable, sym=1 is default
                            p_D_SYM_OUT   => struct.param.num_macs,
                            p_C_OUT       => struct.param.num_macs,
                            p_WE_OUT      => struct.param.num_macs,-- +1,
                            p_WE_SYM_OUT  => struct.param.num_macs+(struct.cyc_to_data_out-1)-struct.num_cyc_read_earily,
                            p_ADDSUB_OUT  => struct.param.num_macs+1,
                            p_ADDSUP_OUT  => struct.param.num_macs+1,
                            p_WE_SYM_OUT_2=> select_integer(
                                                struct.param.num_macs,
                                                struct.param.centre_mac,
                                                struct.param.symmetry=0)
                                              +struct.memory_path_lat.data ),
          output_src      => (
                            p_P_OUT       => 0,
                            p_PC_OUT       => 0,
                            p_D_OUT       => select_integer(1,0,struct.change_src=1),
                            p_D_SYM_OUT   => 0,
                            p_WE_OUT      => 0,
                            p_WE_SYM_OUT  => 0,
                            p_C_OUT       => 0,
                            p_ADDSUB_OUT  => 0,
                            p_ADDSUP_OUT  => 0,
                            p_WE_SYM_OUT_2=> 0 ),
          num_independant_col => select_integer(1,num_col,reqs.col_mode=2),
          num_split_col       => select_integer(1,num_col,reqs.col_mode=1),
          inter_split_col_dly => reqs.col_pipe_len,
          col_len             => ( 0 => select_integer(reqs.col_wrap_len,reqs.col_1st_len,reqs.col_mode=1),
                                   others=>reqs.col_wrap_len),
          dynamic_opcode  => select_integer(0,1,struct.param.single_mac=1),
          sym_para_struct => reqs.has_nd,
          para_casc_we_src=> reqs.has_nd,
          resource_opt    => reqs.resource_opt,
          data_width      => reqs.data_width,
          datapath_mem_type => reqs.datapath_mem_type,
          odd_symmetry    => struct.param.odd_symmetry );

      struct.filt_arm_lat:=lat_filt_arm_add_casc(struct.filt_arm);

      if struct.param.no_data_mem=1 and struct.param.symmetry=1 and struct.filt_arm.sym_para_struct=1 then
        pre_sym_delay:=(struct.param.num_macs-struct.param.odd_symmetry)*(struct.filt_arm.inter_tap_delay-1);
        if reqs.family=v5 then
          pre_sym_delay:=(pre_sym_delay/33)+select_integer(0,1,pre_sym_delay rem 33 > 0);
        else
          pre_sym_delay:=(pre_sym_delay/17)+select_integer(0,1,pre_sym_delay rem 17 > 0);
        end if;
        pre_sym_delay:=pre_sym_delay*reqs.data_width;
        
        sym_param_est_orig:=pre_sym_delay+struct.filt_arm_lat.para_sym_slice_est;
        
        struct.filt_arm.sym_para_struct:=3;
        struct.filt_arm_lat:=lat_filt_arm_add_casc(struct.filt_arm);
        --change to fully delay sym structure

        if struct.filt_arm_lat.para_sym_slice_est >= sym_param_est_orig then
          --revert back to predelay structure
          struct.filt_arm.sym_para_struct:=1;
          struct.filt_arm_lat:=lat_filt_arm_add_casc(struct.filt_arm);
        end if;
      end if;

      if (  struct.param.symmetry=1 and
            pass=0 and
            struct.filt_arm_lat.sym_inter_buff_depth>1089 and
            reqs.data_mem_type=c_mem_forced_dist ) then

        --disable symmetry as srl16 will be forced for the delay and its is not able to support >1089
        struct.param.symmetry:=0;
        struct.param.neg_symmetry:=0;
        struct.param.odd_symmetry:=0;
        struct.param.num_taps_calced:=reqs.num_taps;
        pass:=1;
      else
        pass:=2;
      end if;

    end loop;

    --Accumulator settings---------------------------------------
    struct.accum:=(
        family         => reqs.family,
        implementation => implementation,
        pre_add        => 0,
        pre_add_func   => c_preadd_add,
        pre_add_ipreg  => 0,
        pre_add_midreg => 0,
        a_delay        => 1,
        b_delay        => 1,
        a_src          => 0,--fabric
        --c_src          => 1, --alway from another DSP
        a_sign         => reqs.data_sign,
        b_sign         => reqs.coef_sign,--not used in single rate
        d_sign         => reqs.data_sign,
        reg_opcode     => 1,
        implement_extra_b_dly => 1 );

    struct.accum_lat:=dtls_emb_calc(struct.accum);

    struct.accum_req:=true;

    if (struct.param.single_mac=1) then
      struct.accum_req:=false;
    end if;
    
    --Centre tap coefficient store-------------------------------
    struct.centre_tap_coef:=(
      family              => reqs.family,
      implementation      => implementation,
      mem_type            => select_integer(
                                select_integer(
                                  c_dram,
                                  c_bram,
                                  reqs.num_filts > srl16_mem_depth_thres),
                                select_integer(
                                  c_dram,
                                  c_bram,
                                  reqs.num_filts*2 >dram_mem_depth_thres),
                                reqs.coef_reload=1 ),
      write_mode          => 0,-- select_integer(0,1,
--                                 reqs.coef_reload=1 and struct.centre_tap_coef.mem_type=1 ),
      has_ce              => reqs.has_ce,
      use_mif             => 1 );

    if reqs.coef_reload=1 then
      struct.centre_tap_coef_lat:=lat_ram(struct.centre_tap_coef,2);
    else
      struct.centre_tap_coef_lat:=lat_ram(struct.centre_tap_coef,1);
    end if;

    --Address generator block settings---------------------------
    struct.base_chan_phase_param:=(
        cnt1_max_val    => struct.param.base_count,
        cnt2_max_val    => reqs.num_channels,
        cnt3_max_val    => 2,
        cnt2_max_qual   => 1,
        family          => reqs.family,
        implementation  => implementation );
        
    struct.data_addr_param:=(
        family          => reqs.family,
        implementation  => implementation,
        mem_type        => struct.param.data_mem_type,
        base_cnt        => struct.param.base_count,
        block_cnt       => reqs.num_channels*2,
        symmetric       => struct.param.symmetry,
        addr_width      => get_max(1,log2roundup(struct.param.data_mem_depth)),
        sym_addr_width  => get_max(1,log2roundup(struct.param.datasym_mem_depth+struct.param.datasym_mem_offset)),
        combined        => struct.param.data_combined,
        addr_packed     => struct.param.data_packed,
        srl16_sequence  => 0,--uses standard address sequence
        en_dly          => select_integer(0,1,(reqs.has_nd=1 and struct.param.no_data_mem=0) or
                                               struct.shorter_px_time),
        block_end_dly   => 0,  --delay of one due to the generation of addr_en
        last_block_dly  => 0,
        write_phase_dly => 0,
        sub_block_end_dly => 0,
        use_sym_cntrl   => 0,
        resource_opt => select_integer(reqs.resource_opt,c_area,struct.param.single_mac=1)  );
        --for SMAC the data address is modified with an add, does not need extra
        --register for Sandia.

    struct.data_addr_lat:=lat_data_address(struct.data_addr_param);

    struct.data_addr_lat:=get_max(0,struct.data_addr_lat-1);
    --sub 1 as only interested in the first location of the count,
    --this occurs with 0 latency when latency is 1

    struct.coef_addr_param:=(
        family          => reqs.family,
        implementation  => implementation,
        base_cnt        => struct.param.base_count,
        block_cnt       => 1,
        addr_packed     => struct.param.coef_packed,
        addr_width      => get_max(1,log2roundup( struct.param.coef_mem_depth
                                                  +struct.param.coef_mem_offset )),
        num_filters     => reqs.num_filts,--*select_integer(1,2,struct.param.coef_reload=1),
        multi_page_reload => struct.param.coef_reload,
        offset          => struct.param.coef_mem_offset,
        has_ce          => reqs.has_ce,
        use_count_src   => 0,
        en_dly            => select_integer(0,1,(reqs.has_nd=1 and struct.param.no_data_mem=0) or
                                                struct.shorter_px_time),
        base_max_dly      => 0,
        skip_base_max_dly => 0,
        count_max_dly     => 0,
        filt_sel_dly      => 0,
        resource_opt => reqs.resource_opt);-- select_integer(1,2,(reqs.has_nd=1 and struct.param.no_data_mem=0) or
--                                                 struct.shorter_px_time));

    struct.coef_addr_lat:=lat_coef_address(struct.coef_addr_param);
    
    struct.coef_addr_lat:=get_max(0,struct.coef_addr_lat-1);

    struct.reload_cntrl_param:=(
      family          => reqs.family,
      implementation  => implementation,
      reload_base_cnt => struct.param.base_count,
      coef_addr_packed=> struct.param.coef_packed,
      num_filts       => reqs.num_filts,
      coef_mem_depth  => struct.param.coef_mem_depth,
      num_macs        => struct.param.num_macs,

      has_ce          => reqs.has_ce,
      coef_width      => reqs.coef_width,
      filt_sel_width  => reqs.filt_sel_width,
      filt_sel_width_out => select_integer(1,reqs.filt_sel_width+1, reqs.num_filts>1),
      reload_width    => get_max(1,log2roundup( struct.param.coef_mem_depth)),
      resource_opt => reqs.resource_opt,
      has_hb       => select_integer(1,0,struct.param.single_mac=1),
      latch_filt_sel => 1,
      coef_mem_lat => struct.memory_path_lat.coef,
      num_reload_strms => select_integer(1,2,struct.param.coef_mem_type=c_bram) );

    struct.reload_cntrl_param_lat:=lat_coef_reload_cntrl(struct.reload_cntrl_param);

    struct.addr_cntrl_lat:=select_integer(
                                1,
                                2,
                                (reqs.has_nd=1 and struct.param.no_data_mem=0) or
                                struct.shorter_px_time);
                           --+struct.param.single_mac;
                           --single mac extra delay should be added on once the delay calculation have been
                           --done as the delay is post data address gen block. The effect is added on to the
                           --coef address gen delay below

    if reqs.coef_reload=1 then
      if struct.reload_cntrl_param_lat.filt_sel_lat-1 < struct.addr_cntrl_lat then
        filter_sel_dly:=struct.addr_cntrl_lat-(struct.reload_cntrl_param_lat.filt_sel_lat-1);
        addr_dly:=0;
      else
        filter_sel_dly:=0;
        addr_dly:=(struct.reload_cntrl_param_lat.filt_sel_lat-1)-struct.addr_cntrl_lat;
        struct.addr_cntrl_lat:=struct.addr_cntrl_lat+addr_dly;
      end if;
    else
      addr_dly:=0;
      filter_sel_dly:=struct.addr_cntrl_lat;
    end if;

    --Check delays for latching signal for sym wrap over-----
    struct.we_sym_dly:=struct.addr_cntrl_lat
                       +get_max(struct.data_addr_lat,struct.coef_addr_lat)
                       -1;

    if struct.filt_arm.output_index(p_WE_SYM_OUT)<=0 and struct.param.symmetry=1 then
      --will not be able to get latching signal for wrap over as not enough mac in filt arm
      if struct.we_sym_dly-1+struct.filt_arm.output_index(p_WE_SYM_OUT)<0 then
        --not enough latency to read earily from generation delay so add latency to addr gen.
        addr_dly:=addr_dly+abs(struct.we_sym_dly-1+struct.filt_arm.output_index(p_WE_SYM_OUT));
        filter_sel_dly:=filter_sel_dly+abs(struct.we_sym_dly-1+struct.filt_arm.output_index(p_WE_SYM_OUT));
        struct.addr_cntrl_lat:=struct.addr_cntrl_lat+abs(struct.we_sym_dly-1+struct.filt_arm.output_index(p_WE_SYM_OUT));
        struct.we_sym_dly:=struct.addr_cntrl_lat
                          +get_max(struct.data_addr_lat,struct.coef_addr_lat)
                          -1;
      end if;
    end if;

    --Balance delays
    struct.data_addr_param.en_dly         :=struct.data_addr_param.en_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat)
                                            +addr_dly;
    struct.data_addr_param.block_end_dly  :=struct.data_addr_param.block_end_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat)
                                            +addr_dly;
    struct.data_addr_param.last_block_dly :=struct.data_addr_param.last_block_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat)
                                            +addr_dly;
    
    struct.coef_addr_param.en_dly         :=struct.coef_addr_param.en_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +struct.param.single_mac
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.base_max_dly  :=struct.coef_addr_param.base_max_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +struct.param.single_mac
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.skip_base_max_dly :=struct.coef_addr_param.skip_base_max_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +struct.param.single_mac
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.count_max_dly :=struct.coef_addr_param.count_max_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +struct.param.single_mac
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.filt_sel_dly :=struct.coef_addr_param.filt_sel_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +struct.param.single_mac
                                            +filter_sel_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;

    struct.addr_cntrl_lat:=struct.addr_cntrl_lat+struct.param.single_mac;

    struct.rfd_param:=(
        family          => reqs.family,
        implementation  => implementation,
        cnt             => struct.param.clk_per_chan,
        has_nd          => reqs.has_nd );


    --Latency Calculation
    struct.buffer_type:=0;
    struct.buffer_page_size:=0;
    struct.latency:=struct.param.base_count
                    +struct.addr_cntrl_lat-- -1
                    +get_max(struct.data_addr_lat,struct.coef_addr_lat)
                    +struct.first_tap_extra_dly
                    +struct.filt_arm_lat.cascaded
                    +struct.filt_arm_lat.tap
                    +select_integer(0,1,struct.accum_req)
                    +reqs.reg_output;

    return struct;

  end;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_interpolated.vhd

  function define_interpolated(reqs:t_reqs) return t_define_interpolated is
  ------------------------------------------------------------------------------

    variable struct: t_define_interpolated;
    --variable mem_param: t_tap_memory_add_casc;
    --variable memory_path_lat: t_lat_tap_memory_add_casc;
    constant srl16_mem_depth_thres: integer:=select_integer(32,64,
                                                            reqs.family=v5);
    constant dram_mem_depth_thres: integer:=select_integer(16,32,
                                                           reqs.family=v5);
    variable implementation:integer:=1;--structural
    variable  data_depth_unpacked,
              data_depth_packed,
              coef_depth_unpacked,
              coef_depth_packed,
              num_col,
              pass,
              filter_sel_dly,
              addr_dly,
              pre_sym_delay,
              sym_param_est_orig :integer;
  begin
    --Defaults and direct copies
    struct.param.family:=reqs.family;
    struct.param.filter_type:=reqs.filter_type;
    struct.param.coef_reload:=reqs.coef_reload;
    struct.param.data_sign:=reqs.data_sign;
    struct.param.coef_sign:=reqs.coef_sign;
    struct.param.data_width:=reqs.data_width;
    struct.param.coef_width:=reqs.coef_width;
    struct.param.clk_per_samp:=reqs.clk_per_samp;
    struct.param.num_channels:=reqs.num_channels;
    struct.param.num_taps:=reqs.num_taps;
    struct.param.num_filts:=reqs.num_filts;
    struct.param.zero_packing_factor:=reqs.zero_packing_factor;

    struct.param.symmetry:=reqs.symmetry;
    struct.param.neg_symmetry:=reqs.neg_symmetry;
    struct.param.odd_symmetry:=select_integer(0,reqs.num_taps rem 2,struct.param.symmetry=1);
    struct.param.num_taps_calced:=(reqs.num_taps/2**struct.param.symmetry)+struct.param.odd_symmetry;

    --loop round here once checked depth of inter tap buffer depth
     pass:=0;
     while pass<2 loop
      --Calculate details of the filter-------------------------------------------
      --Number of macs and number of taps per mac
      if ( reqs.clk_per_samp/reqs.num_channels = 0 ) then
        report "FIR: not enough clock cycles per sample to process all channels, must have a minimum of 1 clk cycle per channel" severity error;
      elsif ( reqs.clk_per_samp rem reqs.num_channels > 0 ) then
        report "FIR: number of channels does not fit fully into clock cycles per sample, there will be unused clock cycles" severity note;
      end if;
          
      struct.param.clk_per_chan := reqs.clk_per_samp / reqs.num_channels;
          
      struct.param.base_count := struct.param.clk_per_chan;
          
      struct.param.num_macs := struct.param.num_taps_calced/struct.param.base_count;

      if ( struct.param.num_taps_calced rem struct.param.base_count > 0 ) then
      -- Add extra mac, this mac will need the filter coefficients padded out.
        struct.param.num_macs:=struct.param.num_macs+1;
      end if;

      --Adjust for unused cycles
      struct.param.base_count:=struct.param.num_taps_calced/struct.param.num_macs;
      if (struct.param.num_taps_calced rem struct.param.num_macs >0) then
        struct.param.base_count:=struct.param.base_count+1;
      end if;
      
      if struct.param.base_count<struct.param.clk_per_chan then
        struct.shorter_px_time:=true;
      else
        struct.shorter_px_time:=false;
      end if;

      if pass=0 then
        struct.param.centre_mac:=struct.param.num_macs;
      end if;

      struct.param.base_data_space := struct.param.base_count;
      struct.param.base_coef_space := struct.param.base_count;

      -- Modify and update so get actual filter size
      struct.param.num_taps_calced:=struct.param.num_macs*struct.param.base_count;

      struct.param.inter_rate := 1;
      struct.param.deci_rate  := reqs.zero_packing_factor;

      struct.param.no_data_mem:= 0;
      if (struct.param.base_count = 1) then
        struct.param.no_data_mem:= 1;
      end if;

      -- if (struct.param.clk_per_chan=1 and struct.param.num_channels=1 and struct.param.symmetry=0) then
--         --use data cascade
--         if (reqs.family=v5) then
--           struct.param.data_width:=30;
--         else
--           struct.param.data_width:=18;
--         end if;
--       end if;

      --Structural decisions------------------------------------------------------
      struct.param.single_mac:=0;
      if struct.param.num_macs=1 then
        struct.param.single_mac:=1;
      end if;

      --Memory calculations-------------------------------------
      data_depth_unpacked:=2**log2roundup(struct.param.base_data_space)*(reqs.num_channels*reqs.zero_packing_factor);
      data_depth_packed:=struct.param.base_data_space*reqs.num_channels*reqs.zero_packing_factor;

      -- coef_depth_unpacked:=2**log2roundup(struct.param.base_coef_space)*struct.param.num_filts;
--       coef_depth_packed:=struct.param.base_coef_space*struct.param.num_filts;
  
      coef_depth_unpacked:=2**log2roundup( 2**log2roundup(struct.param.base_coef_space)*struct.param.num_filts)*2**struct.param.coef_reload;
      coef_depth_packed:=struct.param.base_coef_space*struct.param.num_filts*2**struct.param.coef_reload;

      struct.param:=memory_calcs( reqs,
                                  struct.param,
                                  data_depth_unpacked,
                                  data_depth_packed,
                                  coef_depth_unpacked,
                                  coef_depth_packed);

      --Symmetric wrap over calculations-------------------------
      --need to know latency of memory implmented
      struct.mem_param:=( family           =>reqs.family,
                          implementation   =>implementation,
                          data_mem_type    =>struct.param.data_mem_type,
                          coef_mem_type    =>struct.param.coef_mem_type,
                          data_comb        =>struct.param.data_combined,
                          data_coef_comb   =>struct.param.data_coef_combined,
                          no_data_mem      =>struct.param.no_data_mem,
                          coef_mem_depth  => struct.param.coef_mem_depth,
                          has_ce           =>reqs.has_ce,
                          coef_reload      =>reqs.coef_reload,
                          coef_reload_depth=>struct.param.base_coef_space,
                          symmetric        =>struct.param.symmetry );

      struct.memory_path_lat:=lat_tap_memory_add_casc(struct.mem_param);
  
      struct.cyc_to_data_out:=struct.memory_path_lat.data+1;--plus one for the latch (min depth of 1 in delay)
      
      struct.cyc_to_write:=0;
      if (struct.mem_param.data_mem_type/=c_srl16) then -- =c_bram) then
        struct.cyc_to_write:=struct.param.base_count; --inter_we_cycles
      end if;

      struct.num_cyc_read_earily:= select_integer(0,1,struct.cyc_to_write+struct.param.odd_symmetry-struct.cyc_to_data_out<0)
                                  +select_integer(0,1,struct.param.odd_symmetry=1);
      --add odd sym when calc if need earily read as when odd sym will read data earily this gives longer to get
      --data out of memory. So then check if still don't have enough time to get data out of memory

      struct.change_src:=select_integer(0,1,struct.num_cyc_read_earily>=struct.param.base_count);

--       struct.extra_dly:=select_integer(0,1,(struct.cyc_to_data_out-struct.num_cyc_read_earily<=struct.cyc_to_write and
--                                             struct.num_cyc_read_earily-struct.param.odd_symmetry>0 and
--                                             struct.change_src=0) or
--                                            (struct.param.no_data_mem=1 and struct.param.odd_symmetry=1) );
      
--       struct.extra_dly:=select_integer(
--                           select_integer(0,reqs.zero_packing_factor,struct.cyc_to_data_out-struct.num_cyc_read_earily<=struct.cyc_to_write and
--                                                                     struct.num_cyc_read_earily-struct.param.odd_symmetry>0 and
--                                                                     struct.change_src=0),
--                           select_integer(0,reqs.zero_packing_factor-1,struct.num_cyc_read_earily-struct.param.odd_symmetry>0 and
--                                                                       struct.change_src=0),
--                           struct.param.data_mem_type=0);

      struct.extra_dly:=select_integer(
                          0,
                          select_integer(
                            (reqs.zero_packing_factor*reqs.num_channels)-1,
                            (reqs.zero_packing_factor*reqs.num_channels),
                            struct.cyc_to_data_out-struct.num_cyc_read_earily<=struct.cyc_to_write),
                            --test is moved past another WE pulse by reading earily
                          struct.num_cyc_read_earily-struct.param.odd_symmetry>0 and
                          struct.change_src=0);

      struct.add_sup_dly:=struct.memory_path_lat.data;
      
      struct.first_tap_extra_dly:=0;
      
      if struct.param.data_mem_type=c_srl16 and struct.param.no_data_mem=0 then
        struct.data_dly_modifier:=-1;
      else
        struct.data_dly_modifier:=0;
      end if;

      if struct.param.no_data_mem=1 then
        if struct.memory_path_lat.coef>1 then
          --filt casc can direct emb_calc to compensate  for a difference of 1, any more
          --and need extra delay.
          struct.data_dly_modifier:=struct.data_dly_modifier+struct.memory_path_lat.coef-1;
          struct.add_sup_dly:=struct.add_sup_dly+struct.memory_path_lat.coef-1;
          struct.first_tap_extra_dly:=struct.memory_path_lat.coef-1;
        end if;
      end if;

      --Filter arm settings-------------------------------------
      if (reqs.col_mode=1) then
        -- if (struct.param.num_macs>reqs.col_1st_len) then
--           num_col:=1+(struct.param.num_macs-reqs.col_1st_len)/reqs.col_wrap_len;
--         else
--           num_col:=1;
--         end if;
        num_col:=calc_num_split_col(struct.param.num_macs,t_col_len'(
                                   0 => select_integer(reqs.col_wrap_len,reqs.col_1st_len,reqs.col_mode=1),
                                   others=>reqs.col_wrap_len));
      elsif (reqs.col_mode=2) then
        -- no generic for this mode yet
        num_col:=1;
      else
        num_col:=1;
      end if;
  
      struct.filt_arm:= (
          family          => reqs.family,
          implementation  => implementation,
          num_taps        => struct.param.num_macs,
          inter_we_cycles => struct.param.base_count,
          inter_tap_delay => (struct.param.num_channels*reqs.zero_packing_factor)+1,
          inter_sym_tap_delay => (struct.param.num_channels*reqs.zero_packing_factor)+1,
          symmetric       => struct.param.symmetry,
          pre_add_func    => select_integer(c_preadd_add,c_preadd_sub,struct.param.neg_symmetry=1),
          data_mem_type   => struct.param.data_mem_type,
          coef_mem_type   => struct.param.coef_mem_type,
          data_comb       => struct.param.data_combined,
          data_coef_comb  => struct.param.data_coef_combined,
          data_cascade    => 0,
          no_data_mem     => struct.param.no_data_mem,
          coef_mem_depth  => struct.param.coef_mem_depth,
          p_src           => 0,--fabric
          data_sign       => reqs.data_sign,
          coef_sign       => reqs.coef_sign,
          has_ce          => reqs.has_ce,
          --has_nd          => reqs.has_nd,
          reload          => reqs.coef_reload,
          reload_strms    => select_integer(1,2,struct.param.coef_mem_type=c_bram),
          reload_depth    => struct.param.base_coef_space,
          output_index    => (
                            p_P_OUT       => struct.param.num_macs+1,
                            p_PC_OUT      => struct.param.num_macs+1,
                            p_D_OUT       => struct.param.num_macs,-- -struct.change_src,
                            p_D_SYM_OUT   => struct.param.num_macs,
                            p_C_OUT       => struct.param.num_macs,
                            p_WE_OUT      => struct.param.num_macs,-- +1,
                            p_WE_SYM_OUT  => struct.param.num_macs+(struct.cyc_to_data_out-1)-struct.num_cyc_read_earily,
                            p_ADDSUB_OUT  => struct.param.num_macs+1,
                            p_ADDSUP_OUT  => struct.param.num_macs+1,
                            p_WE_SYM_OUT_2    => struct.param.num_macs ),
          output_src      => (
                            p_P_OUT       => 0,
                            p_PC_OUT       => 0,
                            p_D_OUT       => select_integer(1,0,struct.change_src=1),
                            p_D_SYM_OUT   => 0,
                            p_C_OUT       => 0,
                            p_WE_OUT      => 0,
                            p_WE_SYM_OUT  => 0,
                            p_ADDSUB_OUT  => 0,
                            p_ADDSUP_OUT  => 0,
                            p_WE_SYM_OUT_2    => 0 ),
          num_independant_col => select_integer(1,num_col,reqs.col_mode=2),
          num_split_col       => select_integer(1,num_col,reqs.col_mode=1),
          inter_split_col_dly => reqs.col_pipe_len,
          col_len             => ( 0 => select_integer(reqs.col_wrap_len,reqs.col_1st_len,reqs.col_mode=1),
                                   others=>reqs.col_wrap_len),
          dynamic_opcode  => select_integer(0,1,struct.param.num_macs=1),
          sym_para_struct => reqs.has_nd,
          para_casc_we_src=> reqs.has_nd,
          resource_opt    => reqs.resource_opt,
          data_width      => reqs.data_width,
          datapath_mem_type => reqs.datapath_mem_type,
          odd_symmetry    => struct.param.odd_symmetry  );
  
      struct.filt_arm_lat:=lat_filt_arm_add_casc(struct.filt_arm);

      if struct.param.no_data_mem=1 and struct.param.symmetry=1 and struct.filt_arm.sym_para_struct=1 then
        pre_sym_delay:=(struct.param.num_macs-struct.param.odd_symmetry)*(struct.filt_arm.inter_tap_delay-1);
        if reqs.family=v5 then
          pre_sym_delay:=(pre_sym_delay/33)+select_integer(0,1,pre_sym_delay rem 33 > 0);
        else
          pre_sym_delay:=(pre_sym_delay/17)+select_integer(0,1,pre_sym_delay rem 17 > 0);
        end if;
        pre_sym_delay:=pre_sym_delay*reqs.data_width;
        
        sym_param_est_orig:=pre_sym_delay+struct.filt_arm_lat.para_sym_slice_est;
        
        struct.filt_arm.sym_para_struct:=3;
        struct.filt_arm_lat:=lat_filt_arm_add_casc(struct.filt_arm);
        --change to fully delay sym structure

        if struct.filt_arm_lat.para_sym_slice_est >= sym_param_est_orig then
          --revert back to predelay structure
          struct.filt_arm.sym_para_struct:=1;
          struct.filt_arm_lat:=lat_filt_arm_add_casc(struct.filt_arm);
        end if;
      end if;

      if (  struct.param.symmetry=1 and
            pass=0 and
            struct.filt_arm_lat.sym_inter_buff_depth>1089 and
            reqs.data_mem_type=c_mem_forced_dist ) then

        --disable symmetry as srl16 will be forced for the delay and its is not able to support >1089
        struct.param.symmetry:=0;
        struct.param.neg_symmetry:=0;
        struct.param.odd_symmetry:=0;
        struct.param.num_taps_calced:=reqs.num_taps;
        pass:=1;
      else
        pass:=2;
      end if;

    end loop;

    --Accumulator settings---------------------------------------
    struct.accum:=(
        family         => reqs.family,
        implementation => implementation,
        pre_add        => 0,
        pre_add_func   => c_preadd_add,
        pre_add_ipreg  => 0,
        pre_add_midreg => 0,
        a_delay        => 1,
        b_delay        => 1,
        a_src          => 0,--fabric
        --c_src          => 1, --alway from another DSP
        a_sign         => reqs.data_sign,
        b_sign         => reqs.coef_sign,--not used in single rate
        d_sign         => reqs.data_sign,
        reg_opcode     => 1,
        implement_extra_b_dly => 1 );

    struct.accum_lat:=dtls_emb_calc(struct.accum);

    struct.accum_req:=true;

    if (struct.param.base_count=1 and struct.param.num_macs>1) or
       (struct.param.num_macs=1) then
      struct.accum_req:=false;
    end if;

    --Address generator block settings---------------------------
    struct.base_chan_phase_param:=(
        cnt1_max_val    => struct.param.base_count,
        cnt2_max_val    => reqs.num_channels,
        cnt3_max_val    => reqs.zero_packing_factor,
        cnt2_max_qual   => 1,
        family          => reqs.family,
        implementation  => implementation );
        
    struct.data_addr_param:=(
        family          => reqs.family,
        implementation  => implementation,
        mem_type        => struct.param.data_mem_type,
        base_cnt        => struct.param.base_count,
        block_cnt       => reqs.num_channels*reqs.zero_packing_factor,
        symmetric       => struct.param.symmetry,
        addr_width      => get_max(1,log2roundup(struct.param.data_mem_depth)),
        sym_addr_width  => get_max(1,log2roundup(struct.param.datasym_mem_depth+struct.param.datasym_mem_offset)),
        combined        => struct.param.data_combined,
        addr_packed     => struct.param.data_packed,
        srl16_sequence  => 0,--uses standard address sequence
        en_dly          => select_integer(0,1,(reqs.has_nd=1 and struct.param.no_data_mem=0) or
                                               struct.shorter_px_time),
        block_end_dly   => 0,  --delay of one due to the generation of addr_en
        last_block_dly  => 0,
        write_phase_dly => 0,
        sub_block_end_dly => 0,
        use_sym_cntrl   => 0,
        resource_opt => reqs.resource_opt  );

    struct.data_addr_lat:=lat_data_address(struct.data_addr_param);

    struct.data_addr_lat:=get_max(0,struct.data_addr_lat-1);
    --sub 1 as only interested in the first location of the count, 
    --this occurs with 0 latency when latency is 1

    struct.coef_addr_param:=(
        family          => reqs.family,
        implementation  => implementation,
        base_cnt        => struct.param.base_count,
        block_cnt       => 1,
        addr_packed     => struct.param.coef_packed,
        addr_width      => get_max(1,log2roundup( struct.param.coef_mem_depth
                                                  +struct.param.coef_mem_offset )),
        num_filters     => reqs.num_filts,--*select_integer(1,2,struct.param.coef_reload=1),
        multi_page_reload => struct.param.coef_reload,
        offset          => struct.param.coef_mem_offset,
        has_ce          => reqs.has_ce,
        use_count_src   => 0,
        en_dly            => select_integer(0,1,(reqs.has_nd=1 and struct.param.no_data_mem=0) or
                                                 struct.shorter_px_time),
        base_max_dly      => 0,
        skip_base_max_dly => 0,
        count_max_dly     => 0,
        filt_sel_dly      => 0,
        resource_opt => reqs.resource_opt);-- select_integer(1,2,(reqs.has_nd=1 and struct.param.no_data_mem=0) or
--                                                 struct.shorter_px_time));

    struct.coef_addr_lat:=lat_coef_address(struct.coef_addr_param);

    struct.coef_addr_lat:=get_max(0,struct.coef_addr_lat-1);

    struct.reload_cntrl_param:=(
      family          => reqs.family,
      implementation  => implementation,
      reload_base_cnt => struct.param.base_count,
      coef_addr_packed=> struct.param.coef_packed,
      num_filts       => reqs.num_filts,
      coef_mem_depth  => struct.param.coef_mem_depth,
      num_macs        => struct.param.num_macs,

      has_ce          => reqs.has_ce,
      coef_width      => reqs.coef_width,
      filt_sel_width  => reqs.filt_sel_width,
      filt_sel_width_out => select_integer(1,reqs.filt_sel_width+1, reqs.num_filts>1),
      reload_width    => get_max(1,log2roundup( struct.param.coef_mem_depth)),
      resource_opt => reqs.resource_opt,
      has_hb       => 0,
      latch_filt_sel => 1,
      coef_mem_lat => struct.memory_path_lat.coef,
      num_reload_strms => select_integer(1,2,struct.param.coef_mem_type=c_bram) );

    struct.reload_cntrl_param_lat:=lat_coef_reload_cntrl(struct.reload_cntrl_param);

    struct.addr_cntrl_lat:=select_integer(
                                -- select_integer(
--                                   0,
--                                   1,
--                                   reqs.coef_reload=1),
                                1,
                                2,
                                (reqs.has_nd=1 and struct.param.no_data_mem=0) or
                                struct.shorter_px_time);

    if reqs.coef_reload=1 then
      if struct.reload_cntrl_param_lat.filt_sel_lat-1 < struct.addr_cntrl_lat then
        filter_sel_dly:=struct.addr_cntrl_lat-(struct.reload_cntrl_param_lat.filt_sel_lat-1);
        addr_dly:=0;
      else
        filter_sel_dly:=0;
        addr_dly:=(struct.reload_cntrl_param_lat.filt_sel_lat-1)-struct.addr_cntrl_lat;
        struct.addr_cntrl_lat:=struct.addr_cntrl_lat+addr_dly;
      end if;
    else
      addr_dly:=0;
      filter_sel_dly:=struct.addr_cntrl_lat;
    end if;

    --Check delays for latching signal for sym wrap over-----
    struct.we_sym_dly:=struct.addr_cntrl_lat
                       +get_max(struct.data_addr_lat,struct.coef_addr_lat);

    if struct.filt_arm.output_index(p_WE_SYM_OUT)<=0 and struct.param.symmetry=1 then
      --will not be able to get latching signal for wrap over as not enough mac in filt arm
      if struct.we_sym_dly-1+struct.filt_arm.output_index(p_WE_SYM_OUT)<0 then
        --not enough latency to read earily from generation delay so add latency to addr gen.
        addr_dly:=addr_dly+abs(struct.we_sym_dly-1+struct.filt_arm.output_index(p_WE_SYM_OUT));
        filter_sel_dly:=filter_sel_dly+abs(struct.we_sym_dly-1+struct.filt_arm.output_index(p_WE_SYM_OUT));
        struct.addr_cntrl_lat:=struct.addr_cntrl_lat+abs(struct.we_sym_dly-1+struct.filt_arm.output_index(p_WE_SYM_OUT));
        struct.we_sym_dly:=struct.addr_cntrl_lat
                           +get_max(struct.data_addr_lat,struct.coef_addr_lat);
      end if;
    end if;

    --Balance delays
    struct.data_addr_param.en_dly         :=struct.data_addr_param.en_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat)
                                            +addr_dly;
    struct.data_addr_param.block_end_dly  :=struct.data_addr_param.block_end_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat)
                                            +addr_dly;
    struct.data_addr_param.last_block_dly :=struct.data_addr_param.last_block_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat)
                                            +addr_dly;
    
    struct.coef_addr_param.en_dly         :=struct.coef_addr_param.en_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.base_max_dly  :=struct.coef_addr_param.base_max_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.skip_base_max_dly :=struct.coef_addr_param.skip_base_max_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.count_max_dly :=struct.coef_addr_param.count_max_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.filt_sel_dly :=struct.coef_addr_param.filt_sel_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +filter_sel_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;

    struct.rfd_param:=(
        family          => reqs.family,
        implementation  => implementation,
        cnt             => struct.param.clk_per_chan,
        has_nd          => reqs.has_nd );

    --Latency Calculation
    struct.buffer_type:=0;
    struct.buffer_page_size:=0;
    struct.latency:=struct.param.base_count
                    +struct.addr_cntrl_lat-- -1
                    +get_max(struct.data_addr_lat,struct.coef_addr_lat)
                    +struct.first_tap_extra_dly
                    +struct.filt_arm_lat.cascaded
                    +struct.filt_arm_lat.tap
                    +select_integer(0,1,struct.accum_req)
                    +reqs.reg_output;

    return struct;

  end;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_hilbert.vhd

  function define_hilbert(reqs:t_reqs) return t_define_hilbert is
  ------------------------------------------------------------------------------

    variable struct: t_define_hilbert;
    --variable mem_param: t_tap_memory_add_casc;
    --variable memory_path_lat: t_lat_tap_memory_add_casc;
    constant srl16_mem_depth_thres: integer:=select_integer(32,64,
                                                            reqs.family=v5);
    constant dram_mem_depth_thres: integer:=select_integer(16,32,
                                                           reqs.family=v5);
    variable implementation:integer:=1;--structural
    variable  taps_per_phase,
              data_depth_unpacked,
              data_depth_packed,
              coef_depth_unpacked,
              coef_depth_packed,
              num_col,
              pass,
              filter_sel_dly,
              addr_dly,
              pre_sym_delay,
              sym_param_est_orig  :integer;
  begin
    --Defaults and direct copies
    struct.param.family:=reqs.family;
    struct.param.filter_type:=reqs.filter_type;
    struct.param.coef_reload:=reqs.coef_reload;
    struct.param.data_sign:=reqs.data_sign;
    struct.param.coef_sign:=reqs.coef_sign;
    struct.param.data_width:=reqs.data_width;
    struct.param.coef_width:=reqs.coef_width;
    struct.param.clk_per_samp:=reqs.clk_per_samp;
    struct.param.num_channels:=reqs.num_channels;
    struct.param.num_taps:=reqs.num_taps;
    struct.param.num_filts:=reqs.num_filts;
    struct.param.zero_packing_factor:=reqs.zero_packing_factor;

    struct.param.symmetry:=1;--reqs.symmetry;
    struct.param.neg_symmetry:=1;--reqs.neg_symmetry;
    struct.param.odd_symmetry:=0;--select_integer(0,reqs.num_taps rem 2,struct.param.symmetry=1);
    struct.param.num_taps_calced:=(reqs.num_taps/2**struct.param.symmetry)+1;--struct.param.odd_symmetry;

    --loop round here once checked depth of inter tap buffer depth
     pass:=0;
     while pass<2 loop
      --Calculate details of the filter-------------------------------------------
      --Number of macs and number of taps per mac
      if ( reqs.clk_per_samp/reqs.num_channels = 0 ) then
        report "FIR: not enough clock cycles per sample to process all channels, must have a minimum of 1 clk cycle per channel" severity error;
      elsif ( reqs.clk_per_samp rem reqs.num_channels > 0 ) then
        report "FIR: number of channels does not fit fully into clock cycles per sample, there will be unused clock cycles" severity note;
      end if;

      struct.param.clk_per_chan := reqs.clk_per_samp / reqs.num_channels;
          
      struct.param.base_count := struct.param.clk_per_chan;
      
      taps_per_phase:= struct.param.num_taps_calced/ 2;
      if ( struct.param.num_taps_calced rem 2 > 0) then
        taps_per_phase:=taps_per_phase+1;
      end if;

      struct.param.num_macs := taps_per_phase/struct.param.base_count;

      if ( taps_per_phase rem struct.param.base_count > 0 ) then
      -- Add extra mac, this mac will need the filter coefficients padded out.
        struct.param.num_macs:=struct.param.num_macs+1;
      end if;

      --Adjust for unused cycles
      struct.param.base_count:=taps_per_phase/struct.param.num_macs;
      if (taps_per_phase rem struct.param.num_macs >0) then
        struct.param.base_count:=struct.param.base_count+1;
      end if;
      
      if struct.param.base_count<struct.param.clk_per_chan then
        struct.shorter_px_time:=true;
      else
        struct.shorter_px_time:=false;
      end if;

      if pass=0 then
        struct.param.centre_mac:=struct.param.num_macs;
      end if;

      struct.param.base_data_space := struct.param.base_count;
      struct.param.base_coef_space := struct.param.base_count;

      -- Modify and update so get actual filter size
      struct.param.num_taps_calced:=struct.param.num_macs*struct.param.base_count*2;

      struct.param.inter_rate := 1;
      struct.param.deci_rate  := 2;

      struct.param.no_data_mem:= 0;
      if (struct.param.base_count = 1) then
        struct.param.no_data_mem:= 1;
      end if;

      --Structural decisions------------------------------------------------------
      struct.param.single_mac:=0;
      if struct.param.num_macs=1 then
        struct.param.single_mac:=1;
      end if;

      --Memory calculations-------------------------------------
      data_depth_unpacked:=2**log2roundup(struct.param.base_data_space)*(reqs.num_channels*2);
      data_depth_packed:=struct.param.base_data_space*reqs.num_channels*2;

      -- coef_depth_unpacked:=2**log2roundup(struct.param.base_coef_space)*struct.param.num_filts;
--       coef_depth_packed:=struct.param.base_coef_space*struct.param.num_filts;

      coef_depth_unpacked:=2**log2roundup( 2**log2roundup(struct.param.base_coef_space)*struct.param.num_filts)*2**struct.param.coef_reload;
      coef_depth_packed:=struct.param.base_coef_space*struct.param.num_filts*2**struct.param.coef_reload;

      struct.param:=memory_calcs( reqs,
                                  struct.param,
                                  data_depth_unpacked,
                                  data_depth_packed,
                                  coef_depth_unpacked,
                                  coef_depth_packed);

      --Symmetric wrap over calculations-------------------------
      --need to know latency of memory implmented
      struct.mem_param:=( family           =>reqs.family,
                          implementation   =>implementation,
                          data_mem_type    =>struct.param.data_mem_type,
                          coef_mem_type    =>struct.param.coef_mem_type,
                          data_comb        =>struct.param.data_combined,
                          data_coef_comb   =>struct.param.data_coef_combined,
                          no_data_mem      =>struct.param.no_data_mem,
                          coef_mem_depth  => struct.param.coef_mem_depth,
                          has_ce           =>reqs.has_ce,
                          coef_reload      =>reqs.coef_reload,
                          coef_reload_depth=>struct.param.base_coef_space,
                          symmetric        =>struct.param.symmetry );

      struct.memory_path_lat:=lat_tap_memory_add_casc(struct.mem_param);
  
      struct.cyc_to_data_out:=struct.memory_path_lat.data+1;--plus one for the latch (min depth of 1 in delay)

      struct.cyc_to_write:=0;
      if (struct.mem_param.data_mem_type/=c_srl16) then -- =c_bram) then
        struct.cyc_to_write:=struct.param.base_count; --inter_we_cycles
      end if;

      -- struct.num_cyc_read_earily:= select_integer(0,1,struct.cyc_to_write-struct.cyc_to_data_out<0)
--                                   +select_integer(0,1,struct.param.odd_symmetry=1);

      struct.num_cyc_read_earily:= select_integer(0,1,struct.cyc_to_write+struct.param.odd_symmetry-struct.cyc_to_data_out<0)
                                  +select_integer(0,1,struct.param.odd_symmetry=1);
      --add odd sym when calc if need earily read as when odd sym will read data earily this gives longer to get
      --data out of memory. So then check if still don't have enough time to get data out of memory

      struct.change_src:=select_integer(0,1,struct.num_cyc_read_earily>=struct.param.base_count);

      -- struct.extra_dly:=select_integer(0,1,(struct.cyc_to_data_out-struct.num_cyc_read_earily<=struct.cyc_to_write and
--                                             struct.num_cyc_read_earily-struct.param.odd_symmetry>0 and
--                                             struct.change_src=0) or
--                                            (struct.param.no_data_mem=1 and struct.param.odd_symmetry=1) );
      struct.extra_dly:=select_integer(
                          0,
                          select_integer(
                            (2*reqs.num_channels)-1,--1,
                            (2*reqs.num_channels),--2,
                            struct.cyc_to_data_out-struct.num_cyc_read_earily<=struct.cyc_to_write),
                            --test is moved past another WE pulse by reading earily
                          struct.num_cyc_read_earily-struct.param.odd_symmetry>0 and
                          struct.change_src=0);

      struct.add_sup_dly:=struct.memory_path_lat.data;
      
      struct.first_tap_extra_dly:=0;

      if struct.param.data_mem_type=c_srl16 and struct.param.no_data_mem=0 then
        struct.data_dly_modifier:=-1;
      else
        struct.data_dly_modifier:=0;
      end if;

      if struct.param.no_data_mem=1 then
        if struct.memory_path_lat.coef>1 then
          --filt casc can direct emb_calc to compensate  for a difference of 1, any more
          --and need extra delay.
          struct.data_dly_modifier:=struct.data_dly_modifier+struct.memory_path_lat.coef-1;
          struct.add_sup_dly:=struct.add_sup_dly+struct.memory_path_lat.coef-1;
          struct.first_tap_extra_dly:=struct.memory_path_lat.coef-1;
        end if;
      end if;

      --Filter arm settings-------------------------------------
      if (reqs.col_mode=1) then
        -- if (struct.param.num_macs>reqs.col_1st_len) then
--           num_col:=1+(struct.param.num_macs-reqs.col_1st_len)/reqs.col_wrap_len;
--         else
--           num_col:=1;
--         end if;
        num_col:=calc_num_split_col(struct.param.num_macs,t_col_len'(
                                   0 => select_integer(reqs.col_wrap_len,reqs.col_1st_len,reqs.col_mode=1),
                                   others=>reqs.col_wrap_len));
      elsif (reqs.col_mode=2) then
        -- no generic for this mode yet
        num_col:=1;
      else
        num_col:=1;
      end if;
  
      struct.filt_arm:= (
          family          => reqs.family,
          implementation  => implementation,
          num_taps        => struct.param.num_macs,
          inter_we_cycles => struct.param.base_count,
          inter_tap_delay => (struct.param.num_channels*2)+1,
          inter_sym_tap_delay => (struct.param.num_channels*2)+1,
          symmetric       => struct.param.symmetry,
          pre_add_func    => select_integer(c_preadd_add,c_preadd_sub,struct.param.neg_symmetry=1),
          data_mem_type   => struct.param.data_mem_type,
          coef_mem_type   => struct.param.coef_mem_type,
          data_comb       => struct.param.data_combined,
          data_coef_comb  => struct.param.data_coef_combined,
          data_cascade    => 0,
          no_data_mem     => struct.param.no_data_mem,
          coef_mem_depth  => struct.param.coef_mem_depth,
          p_src           => 0,--fabric
          data_sign       => reqs.data_sign,
          coef_sign       => reqs.coef_sign,
          has_ce          => reqs.has_ce,
          --has_nd          => reqs.has_nd,
          reload          => reqs.coef_reload,
          reload_strms    => select_integer(1,2,struct.param.coef_mem_type=c_bram),
          reload_depth    => struct.param.base_coef_space,
          output_index    => (
                            p_P_OUT       => struct.param.num_macs+1,
                            p_PC_OUT      => struct.param.num_macs+1,
                            p_D_OUT       => select_integer(
                                                struct.param.num_macs,
                                                struct.param.centre_mac,
                                                struct.param.symmetry=0),-- -struct.change_src,
                                              --when sym=0 then sym has been disable, sym=1 is default
                            p_D_SYM_OUT   => struct.param.num_macs,
                            p_C_OUT       => struct.param.num_macs,
                            p_WE_OUT      => struct.param.num_macs,-- +1,
                            p_WE_SYM_OUT  => struct.param.num_macs+(struct.cyc_to_data_out-1)-struct.num_cyc_read_earily,
                            p_ADDSUB_OUT  => struct.param.num_macs+1,
                            p_ADDSUP_OUT  => struct.param.num_macs+1,
                            p_WE_SYM_OUT_2    => select_integer(
                                                  struct.param.num_macs,
                                                  struct.param.centre_mac,
                                                  struct.param.symmetry=0)
                                                +struct.memory_path_lat.data ),
          output_src      => (
                            p_P_OUT       => 0,
                            p_PC_OUT       => 0,
                            p_D_OUT       => select_integer(1,0,struct.change_src=1),
                            p_D_SYM_OUT   => 0,
                            p_WE_OUT      => 0,
                            p_WE_SYM_OUT  => 0,
                            p_C_OUT       => 0,
                            p_ADDSUB_OUT  => 0,
                            p_ADDSUP_OUT  => 0,
                            p_WE_SYM_OUT_2    => 0 ),
          num_independant_col => select_integer(1,num_col,reqs.col_mode=2),
          num_split_col       => select_integer(1,num_col,reqs.col_mode=1),
          inter_split_col_dly => reqs.col_pipe_len,
          col_len             => ( 0 => select_integer(reqs.col_wrap_len,reqs.col_1st_len,reqs.col_mode=1),
                                   others=>reqs.col_wrap_len),
          dynamic_opcode  => select_integer(0,1,struct.param.num_macs=1),
          sym_para_struct => reqs.has_nd,
          para_casc_we_src=> reqs.has_nd,
          resource_opt    => reqs.resource_opt,
          data_width      => reqs.data_width,
          datapath_mem_type => reqs.datapath_mem_type,
          odd_symmetry    => struct.param.odd_symmetry  );
  
      struct.filt_arm_lat:=lat_filt_arm_add_casc(struct.filt_arm);

      if struct.param.no_data_mem=1 and struct.param.symmetry=1 and struct.filt_arm.sym_para_struct=1 then
        pre_sym_delay:=(struct.param.num_macs-struct.param.odd_symmetry)*(struct.filt_arm.inter_tap_delay-1);
        if reqs.family=v5 then
          pre_sym_delay:=(pre_sym_delay/33)+select_integer(0,1,pre_sym_delay rem 33 > 0);
        else
          pre_sym_delay:=(pre_sym_delay/17)+select_integer(0,1,pre_sym_delay rem 17 > 0);
        end if;
        pre_sym_delay:=pre_sym_delay*reqs.data_width;
        
        sym_param_est_orig:=pre_sym_delay+struct.filt_arm_lat.para_sym_slice_est;
        
        struct.filt_arm.sym_para_struct:=3;
        struct.filt_arm_lat:=lat_filt_arm_add_casc(struct.filt_arm);
        --change to fully delay sym structure

        if struct.filt_arm_lat.para_sym_slice_est >= sym_param_est_orig then
          --revert back to predelay structure
          struct.filt_arm.sym_para_struct:=1;
          struct.filt_arm_lat:=lat_filt_arm_add_casc(struct.filt_arm);
        end if;
      end if;

      if (  struct.param.symmetry=1 and
            pass=0 and
            struct.filt_arm_lat.sym_inter_buff_depth>1089 and
            reqs.data_mem_type=c_mem_forced_dist ) then

        --disable symmetry as srl16 will be forced for the delay and its is not able to support >1089
        struct.param.symmetry:=0;
        struct.param.neg_symmetry:=0;
        struct.param.odd_symmetry:=0;
        struct.param.num_taps_calced:=reqs.num_taps;
        pass:=1;
      else
        pass:=2;
      end if;

    end loop;

    --Accumulator settings---------------------------------------
    struct.accum:=(
        family         => reqs.family,
        implementation => implementation,
        pre_add        => 0,
        pre_add_func   => c_preadd_add,
        pre_add_ipreg  => 0,
        pre_add_midreg => 0,
        a_delay        => 1,
        b_delay        => 1,
        a_src          => 0,--fabric
        --c_src          => 1, --alway from another DSP
        a_sign         => reqs.data_sign,
        b_sign         => reqs.coef_sign,--not used in single rate
        d_sign         => reqs.data_sign,
        reg_opcode     => 1,
        implement_extra_b_dly => 1 );

    struct.accum_lat:=dtls_emb_calc(struct.accum);

    struct.accum_req:=true;

    if (struct.param.base_count=1 and struct.param.num_macs>1) or
       (struct.param.num_macs=1) then
      struct.accum_req:=false;
    end if;

    --Address generator block settings---------------------------
    struct.base_chan_phase_param:=(
        cnt1_max_val    => struct.param.base_count,
        cnt2_max_val    => reqs.num_channels,
        cnt3_max_val    => 2,
        cnt2_max_qual   => 1,
        family          => reqs.family,
        implementation  => implementation );
        
    struct.data_addr_param:=(
        family          => reqs.family,
        implementation  => implementation,
        mem_type        => struct.param.data_mem_type,
        base_cnt        => struct.param.base_count,
        block_cnt       => reqs.num_channels*2,
        symmetric       => struct.param.symmetry,
        addr_width      => get_max(1,log2roundup(struct.param.data_mem_depth)),
        sym_addr_width  => get_max(1,log2roundup(struct.param.datasym_mem_depth+struct.param.datasym_mem_offset)),
        combined        => struct.param.data_combined,
        addr_packed     => struct.param.data_packed,
        srl16_sequence  => 0,--uses standard address sequence
        en_dly          => select_integer(0,1,(reqs.has_nd=1 and struct.param.no_data_mem=0) or
                                               struct.shorter_px_time),
        block_end_dly   => 0,  --delay of one due to the generation of addr_en
        last_block_dly  => 0,
        write_phase_dly => 0,
        sub_block_end_dly => 0,
        use_sym_cntrl   => 0,
        resource_opt => reqs.resource_opt  );

    struct.data_addr_lat:=lat_data_address(struct.data_addr_param);

    struct.data_addr_lat:=get_max(0,struct.data_addr_lat-1);
    --sub 1 as only interested in the first location of the count, 
    --this occurs with 0 latency when latency is 1

    struct.coef_addr_param:=(
        family          => reqs.family,
        implementation  => implementation,
        base_cnt        => struct.param.base_count,
        block_cnt       => 1,
        addr_packed     => struct.param.coef_packed,
        addr_width      => get_max(1,log2roundup( struct.param.coef_mem_depth
                                                  +struct.param.coef_mem_offset )),
        num_filters     => reqs.num_filts,--*select_integer(1,2,struct.param.coef_reload=1),
        multi_page_reload => struct.param.coef_reload,
        offset          => struct.param.coef_mem_offset,
        has_ce          => reqs.has_ce,
        use_count_src   => 0,
        en_dly            => select_integer(0,1,(reqs.has_nd=1 and struct.param.no_data_mem=0) or
                                                 struct.shorter_px_time),
        base_max_dly      => 0,
        skip_base_max_dly => 0,
        count_max_dly     => 0,
        filt_sel_dly      => 0,
        resource_opt => reqs.resource_opt);-- select_integer(1,2,(reqs.has_nd=1 and struct.param.no_data_mem=0) or
--                                                 struct.shorter_px_time));

    struct.coef_addr_lat:=lat_coef_address(struct.coef_addr_param);
    
    struct.coef_addr_lat:=get_max(0,struct.coef_addr_lat-1);

    struct.reload_cntrl_param:=(
      family          => reqs.family,
      implementation  => implementation,
      reload_base_cnt => struct.param.base_count,
      coef_addr_packed=> struct.param.coef_packed,
      num_filts       => reqs.num_filts,
      coef_mem_depth  => struct.param.coef_mem_depth,
      num_macs        => struct.param.num_macs,

      has_ce          => reqs.has_ce,
      coef_width      => reqs.coef_width,
      filt_sel_width  => reqs.filt_sel_width,
      filt_sel_width_out => select_integer(1,reqs.filt_sel_width+1, reqs.num_filts>1),
      reload_width    => get_max(1,log2roundup( struct.param.coef_mem_depth)),
      resource_opt => reqs.resource_opt,
      has_hb       => 0,
      latch_filt_sel => 1,
      coef_mem_lat => struct.memory_path_lat.coef,
      num_reload_strms => select_integer(1,2,struct.param.coef_mem_type=c_bram) );

    struct.reload_cntrl_param_lat:=lat_coef_reload_cntrl(struct.reload_cntrl_param);

    struct.addr_cntrl_lat:=select_integer(
                                -- select_integer(
--                                   0,
--                                   1,
--                                   reqs.coef_reload=1),
                                1,
                                2,
                                (reqs.has_nd=1 and struct.param.no_data_mem=0) or
                                struct.shorter_px_time);

    if reqs.coef_reload=1 then
      if struct.reload_cntrl_param_lat.filt_sel_lat-1 < struct.addr_cntrl_lat then
        filter_sel_dly:=struct.addr_cntrl_lat-(struct.reload_cntrl_param_lat.filt_sel_lat-1);
        addr_dly:=0;
      else
        filter_sel_dly:=0;
        addr_dly:=(struct.reload_cntrl_param_lat.filt_sel_lat-1)-struct.addr_cntrl_lat;
        struct.addr_cntrl_lat:=struct.addr_cntrl_lat+addr_dly;
      end if;
    else
      addr_dly:=0;
      filter_sel_dly:=struct.addr_cntrl_lat;
    end if;

    --Check delays for latching signal for sym wrap over-----
    struct.we_sym_dly:=struct.addr_cntrl_lat
                       +get_max(struct.data_addr_lat,struct.coef_addr_lat);

    if struct.filt_arm.output_index(p_WE_SYM_OUT)<=0 and struct.param.symmetry=1 then
      --will not be able to get latching signal for wrap over as not enough mac in filt arm
      if struct.we_sym_dly-1+struct.filt_arm.output_index(p_WE_SYM_OUT)<0 then
        --not enough latency to read earily from generation delay so add latency to addr gen.
        addr_dly:=addr_dly+abs(struct.we_sym_dly-1+struct.filt_arm.output_index(p_WE_SYM_OUT));
        filter_sel_dly:=filter_sel_dly+abs(struct.we_sym_dly-1+struct.filt_arm.output_index(p_WE_SYM_OUT));
        struct.addr_cntrl_lat:=struct.addr_cntrl_lat+abs(struct.we_sym_dly-1+struct.filt_arm.output_index(p_WE_SYM_OUT));
        struct.we_sym_dly:=struct.addr_cntrl_lat
                           +get_max(struct.data_addr_lat,struct.coef_addr_lat);
      end if;
    end if;

    --Balance delays
    struct.data_addr_param.en_dly         :=struct.data_addr_param.en_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat)
                                            +addr_dly;
    struct.data_addr_param.block_end_dly  :=struct.data_addr_param.block_end_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat)
                                            +addr_dly;
    struct.data_addr_param.last_block_dly :=struct.data_addr_param.last_block_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat)
                                            +addr_dly;
    
    struct.coef_addr_param.en_dly         :=struct.coef_addr_param.en_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.base_max_dly  :=struct.coef_addr_param.base_max_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.skip_base_max_dly :=struct.coef_addr_param.skip_base_max_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.count_max_dly :=struct.coef_addr_param.count_max_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.filt_sel_dly :=struct.coef_addr_param.filt_sel_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +filter_sel_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;

    struct.rfd_param:=(
        family          => reqs.family,
        implementation  => implementation,
        cnt             => struct.param.clk_per_chan,
        has_nd          => reqs.has_nd );

    --Latency Calculation
    struct.buffer_type:=0;
    struct.buffer_page_size:=0;
    struct.latency:=struct.param.base_count
                    +struct.addr_cntrl_lat-- -1
                    +get_max(struct.data_addr_lat,struct.coef_addr_lat)
                    +struct.first_tap_extra_dly
                    +struct.filt_arm_lat.cascaded
                    +struct.filt_arm_lat.tap
                    +select_integer(0,1,struct.accum_req)
                    +reqs.reg_output;

    return struct;

  end;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_polyphase_interpolation.vhd

  function define_interpolation(reqs:t_reqs) return t_define_interpolation is
  ------------------------------------------------------------------------------

    variable struct: t_define_interpolation;
    --variable mem_param: t_tap_memory_add_casc;
    --variable memory_path_lat: t_lat_tap_memory_add_casc;
    constant srl16_mem_depth_thres: integer:=select_integer(32,64,
                                                            reqs.family=v5);
    constant dram_mem_depth_thres: integer:=select_integer(16,32,
                                                           reqs.family=v5);
    variable implementation:integer:=1;--structural
    variable  taps_per_phase,
              data_depth_unpacked,
              data_depth_packed,
              coef_depth_unpacked,
              coef_depth_packed,
              num_col,
              pass,
              data_addr_dly,
              coef_addr_dly
              :integer;
  begin
    --Defaults and direct copies
    struct.param.family:=reqs.family;
    struct.param.filter_type:=reqs.filter_type;
    struct.param.coef_reload:=reqs.coef_reload;
    struct.param.data_sign:=reqs.data_sign;
    struct.param.coef_sign:=reqs.coef_sign;
    struct.param.data_width:=reqs.data_width;
    struct.param.coef_width:=reqs.coef_width;
    struct.param.clk_per_samp:=reqs.clk_per_samp;
    struct.param.num_channels:=reqs.num_channels;
    struct.param.num_taps:=reqs.num_taps;
    struct.param.num_filts:=reqs.num_filts;
    struct.param.zero_packing_factor:=reqs.zero_packing_factor;
    
    struct.param.symmetry:=0;
    struct.param.neg_symmetry:=0;
    struct.param.odd_symmetry:=0;
    struct.param.num_taps_calced:=(reqs.num_taps/2**struct.param.symmetry)+struct.param.odd_symmetry;

    --loop round here once checked depth of inter tap buffer depth
--      pass:=0;
--      while pass<2 loop
      --Calculate details of the filter-------------------------------------------
      --Number of macs and number of taps per mac
      if ( reqs.clk_per_samp/reqs.num_channels = 0 ) then
        report "FIR: not enough clock cycles per sample to process all channels, must have a minimum of 1 clk cycle per channel" severity error;
      elsif ( reqs.clk_per_samp rem reqs.num_channels > 0 ) then
        report "FIR: number of channels does not fit fully into clock cycles per sample, there will be unused clock cycles" severity note;
      end if;

      struct.param.clk_per_chan := reqs.clk_per_samp / reqs.num_channels;

      if (struct.param.clk_per_chan rem reqs.inter_rate > 0) then
        report "FIR: the available clock cycles is not evenly divisable by the interpolation rate, this means there will be unused clock cycles" severity note;
      end if;

      struct.param.base_count := struct.param.clk_per_chan / reqs.inter_rate;
      
      taps_per_phase:= struct.param.num_taps_calced/ reqs.inter_rate;
      if ( struct.param.num_taps_calced rem reqs.inter_rate > 0) then
        taps_per_phase:=taps_per_phase+1;
      end if;

      struct.param.num_macs := taps_per_phase/struct.param.base_count;

      if ( taps_per_phase rem struct.param.base_count > 0 ) then
      -- Add extra mac, this mac will need the filter coefficients padded out.
        struct.param.num_macs:=struct.param.num_macs+1;
      end if;

      struct.base_count_op_rate:=struct.param.base_count;

      --Adjust for unused cycles
      struct.param.base_count:=taps_per_phase/struct.param.num_macs;
      if (taps_per_phase rem struct.param.num_macs >0) then
        struct.param.base_count:=struct.param.base_count+1;
      end if;
      
      struct.shorter_px_time:=false;
      if struct.base_count_op_rate>struct.param.base_count then
        struct.shorter_px_time:=true;
      end if;
      
      struct.sing_chan_short_block:=false;
      if reqs.num_channels=1 and struct.shorter_px_time=false and
         (struct.param.clk_per_chan > struct.param.base_count*reqs.inter_rate) then
        struct.sing_chan_short_block:=true;
      end if;

      --if pass=0 then
        struct.param.centre_mac:=struct.param.num_macs;
      --end if;

      struct.param.base_data_space := struct.param.base_count;
      struct.param.base_coef_space := struct.param.base_count*reqs.inter_rate;

      -- Modify and update so get actual filter size
      struct.param.num_taps_calced:=struct.param.num_macs*struct.param.base_count*reqs.inter_rate;

      struct.param.inter_rate := reqs.inter_rate;
      struct.param.deci_rate  := 1;

      struct.param.no_data_mem:= 0;
      if (struct.param.base_count = 1 and reqs.num_channels=1) then
        struct.param.no_data_mem:= 1;
      end if;

      --Structural decisions------------------------------------------------------
      struct.param.single_mac:=0;
      if struct.param.num_macs=1 then
        struct.param.single_mac:=1;
      end if;

      --Memory calculations-------------------------------------
      data_depth_unpacked:=2**log2roundup(struct.param.base_data_space)*reqs.num_channels;
      data_depth_packed:=struct.param.base_data_space*reqs.num_channels;

      -- coef_depth_unpacked:=2**log2roundup(struct.param.base_coef_space)*struct.param.num_filts;
--       coef_depth_packed:=struct.param.base_coef_space*struct.param.num_filts;
      
      coef_depth_unpacked:=2**log2roundup( 2**log2roundup(struct.param.base_coef_space)*struct.param.num_filts)*2**struct.param.coef_reload;
      coef_depth_packed:=struct.param.base_coef_space*struct.param.num_filts*2**struct.param.coef_reload;

      struct.param:=memory_calcs( reqs,
                                  struct.param,
                                  data_depth_unpacked,
                                  data_depth_packed,
                                  coef_depth_unpacked,
                                  coef_depth_packed);

      --Symmetric wrap over calculations-------------------------
      --need to know latency of memory implmented
      struct.mem_param:=( family           =>reqs.family,
                          implementation   =>implementation,
                          data_mem_type    =>struct.param.data_mem_type,
                          coef_mem_type    =>struct.param.coef_mem_type,
                          data_comb        =>struct.param.data_combined,
                          data_coef_comb   =>struct.param.data_coef_combined,
                          no_data_mem      =>struct.param.no_data_mem,
                          coef_mem_depth  => struct.param.coef_mem_depth,
                          has_ce           =>reqs.has_ce,
                          coef_reload      =>reqs.coef_reload,
                          coef_reload_depth=>struct.param.base_coef_space,
                          symmetric        =>struct.param.symmetry );

      struct.memory_path_lat:=lat_tap_memory_add_casc(struct.mem_param);

      struct.add_sup_dly:=struct.memory_path_lat.data;

      struct.first_tap_extra_dly:=0;

      if struct.param.data_mem_type=c_srl16 and struct.param.no_data_mem=0 then
        struct.data_dly_modifier:=-1;
      else
        struct.data_dly_modifier:=0;
      end if;

      if struct.param.no_data_mem=1 then
        if struct.memory_path_lat.coef>1 then
          --filt casc can direct emb_calc to compensate  for a difference of 1, any more
          --and need extra delay.
          struct.data_dly_modifier:=struct.data_dly_modifier+struct.memory_path_lat.coef-1;
          struct.add_sup_dly:=struct.add_sup_dly+struct.memory_path_lat.coef-1;
          struct.first_tap_extra_dly:=struct.memory_path_lat.coef-1;
        end if;
      end if;

      --Filter arm settings-------------------------------------
      if (reqs.col_mode=1) then
        -- if (struct.param.num_macs>reqs.col_1st_len) then
--           num_col:=1+(struct.param.num_macs-reqs.col_1st_len)/reqs.col_wrap_len;
--         else
--           num_col:=1;
--         end if;
        num_col:=calc_num_split_col(struct.param.num_macs,t_col_len'(
                                   0 => select_integer(reqs.col_wrap_len,reqs.col_1st_len,reqs.col_mode=1),
                                   others=>reqs.col_wrap_len));
      elsif (reqs.col_mode=2) then
        -- no generic for this mode yet
        num_col:=1;
      else
        num_col:=1;
      end if;
  
      struct.filt_arm:= (
          family          => reqs.family,
          implementation  => implementation,
          num_taps        => struct.param.num_macs,
          inter_we_cycles => struct.param.base_count,
          inter_tap_delay => struct.param.num_channels+1,
          inter_sym_tap_delay => 0,
          --no symmetry support in this structure
          symmetric       => struct.param.symmetry,
          pre_add_func    => select_integer(c_preadd_add,c_preadd_sub,struct.param.neg_symmetry=1),
          data_mem_type   => struct.param.data_mem_type,
          coef_mem_type   => struct.param.coef_mem_type,
          data_comb       => struct.param.data_combined,
          data_coef_comb  => struct.param.data_coef_combined,
          data_cascade    => 0,
          no_data_mem     => struct.param.no_data_mem,
          coef_mem_depth  => struct.param.coef_mem_depth,
          p_src           => 0,--fabric
          data_sign       => reqs.data_sign,
          coef_sign       => reqs.coef_sign,
          has_ce          => reqs.has_ce,
          --has_nd          => reqs.has_nd,
          reload          => reqs.coef_reload,
          reload_strms    => select_integer(1,2,struct.param.coef_mem_type=c_bram),
          reload_depth    => struct.param.base_coef_space,
          output_index    => (
                            p_P_OUT       => struct.param.num_macs+1,
                            p_PC_OUT      => struct.param.num_macs+1,
                            p_D_OUT       => struct.param.num_macs,-- -struct.change_src,
                            p_D_SYM_OUT   => struct.param.num_macs,
                            p_C_OUT       => struct.param.num_macs,
                            p_WE_OUT      => struct.param.num_macs,-- +1,
                            p_WE_SYM_OUT  => struct.param.num_macs,--+(struct.cyc_to_data_out-1)-struct.num_cyc_read_earily,
                            p_ADDSUB_OUT  => struct.param.num_macs+1,
                            p_ADDSUP_OUT  => struct.param.num_macs+1,
                            p_WE_SYM_OUT_2    => struct.param.num_macs ),
          output_src      => (
                            p_P_OUT       => 0,
                            p_PC_OUT       => 0,
                            p_D_OUT       => 0,--select_integer(1,0,struct.change_src=1),
                            p_D_SYM_OUT   => 0,
                            p_WE_OUT      => 0,
                            p_WE_SYM_OUT  => 0,
                            p_C_OUT       => 0,
                            p_ADDSUB_OUT  => 0,
                            p_ADDSUP_OUT  => 0,
                            p_WE_SYM_OUT_2    => 0 ),
          num_independant_col => select_integer(1,num_col,reqs.col_mode=2),
          num_split_col       => select_integer(1,num_col,reqs.col_mode=1),
          inter_split_col_dly => reqs.col_pipe_len,
          col_len             => ( 0 => select_integer(reqs.col_wrap_len,reqs.col_1st_len,reqs.col_mode=1),
                                   others=>reqs.col_wrap_len),
          dynamic_opcode  => select_integer(0,1,struct.param.num_macs=1),
          sym_para_struct => reqs.has_nd,
          para_casc_we_src=> 1,--reqs.has_nd,
          resource_opt    => reqs.resource_opt,
          data_width      => reqs.data_width,
          datapath_mem_type => reqs.datapath_mem_type,
          odd_symmetry    => struct.param.odd_symmetry  );

      struct.filt_arm_lat:=lat_filt_arm_add_casc(struct.filt_arm);

    --Accumulator settings---------------------------------------
    struct.accum:=(
        family         => reqs.family,
        implementation => implementation,
        pre_add        => 0,
        pre_add_func   => c_preadd_add,
        pre_add_ipreg  => 0,
        pre_add_midreg => 0,
        a_delay        => 1,
        b_delay        => 1,
        a_src          => 0,--fabric
        --c_src          => 1, --alway from another DSP
        a_sign         => reqs.data_sign,
        b_sign         => reqs.coef_sign,--not used in single rate
        d_sign         => reqs.data_sign,
        reg_opcode     => 1,
        implement_extra_b_dly => 1 );

    struct.accum_lat:=dtls_emb_calc(struct.accum);

    struct.accum_req:=true;

    if (struct.param.base_count=1 and struct.param.num_macs>1) or
       (struct.param.num_macs=1) then
      struct.accum_req:=false;
    end if;

    --Input buffer settings--------------------------------------
    struct.has_input_buffer:=false;
    struct.input_buffer_lat:=0;
    struct.input_buffer_depth:=2*reqs.num_channels;
    struct.input_buffer_cntrl_dly:=0;

    if struct.shorter_px_time then
      struct.input_buffer_cntrl_dly:=1;
    end if;

    struct.input_buffer:=(
      family              => reqs.family,
      implementation      => implementation,
      mem_type            => select_integer(
                              c_dram,--dram
                              c_bram,--bram
                              (struct.input_buffer_depth>dram_mem_depth_thres and reqs.ipbuff_mem_type/=c_mem_forced_dist) or
                               reqs.ipbuff_mem_type=c_mem_forced_bram ),
      write_mode          => 0,--read first
      has_ce              => reqs.has_ce,
      use_mif             => 0 );

    struct.input_buffer_in_addr:=(
      family => reqs.family,
      implementation => implementation,
      addr_width => get_max(1,log2roundup(struct.input_buffer_depth)),
      page_size => reqs.num_channels,
      num_enables => 2 );

    if reqs.num_channels>1 then
      struct.has_input_buffer:=true;
      struct.input_buffer_lat:=lat_ram(struct.input_buffer,2);

      if struct.shorter_px_time then
        struct.input_buffer_lat:=struct.input_buffer_lat+1;
        --need to qualify chan_max in this case to push out input buffer latency by a cycle
        --will it tolerate a delay on starting the read, ie will the addresses over lap,
        --maybe prob in fully parallel.
      end if;

    end if;

    --Address generator block settings---------------------------
    struct.base_chan_phase_param:=(
        cnt1_max_val    => select_integer(
                              struct.param.base_count,
                              struct.base_count_op_rate,
                              struct.shorter_px_time),
        cnt2_max_val    => reqs.num_channels,
        cnt3_max_val    => reqs.inter_rate,
        cnt2_max_qual   => select_integer(1,0,struct.shorter_px_time),
        family          => reqs.family,
        implementation  => implementation );
        
    struct.data_addr_param:=(
        family          => reqs.family,
        implementation  => implementation,
        mem_type        => struct.param.data_mem_type,
        base_cnt        => struct.param.base_count,
        block_cnt       => reqs.num_channels,
        symmetric       => struct.param.symmetry,
        addr_width      => get_max(1,log2roundup(struct.param.data_mem_depth)),
        sym_addr_width  => get_max(1,log2roundup(struct.param.datasym_mem_depth+struct.param.datasym_mem_offset)),
        combined        => struct.param.data_combined,
        addr_packed     => struct.param.data_packed,
        srl16_sequence  => 1,--use the repeat address structure
        en_dly          => select_integer(0,1,(reqs.has_nd=1 and struct.param.no_data_mem=0) or
                                                struct.shorter_px_time or
                                                struct.sing_chan_short_block),
        block_end_dly   => select_integer(0,1, struct.param.base_count=1 and reqs.num_channels>1 and
                                                ((reqs.has_nd=1 and struct.param.no_data_mem=0) or
                                                struct.shorter_px_time) ),
        last_block_dly  => 0,
        write_phase_dly => 0,
        sub_block_end_dly => 0,
        use_sym_cntrl   => 0,
        resource_opt => reqs.resource_opt);

    struct.data_addr_lat:=lat_data_address(struct.data_addr_param);

    struct.data_addr_lat:=get_max(0,struct.data_addr_lat-1);
    --sub 1 as only interested in the first location of the count, 
    --this occurs with 0 latency when latency is 1

    struct.coef_addr_param:=(
        family          => reqs.family,
        implementation  => implementation,
        base_cnt        => struct.param.base_count,
        block_cnt       => reqs.inter_rate,
        addr_packed     => struct.param.coef_packed,
        addr_width      => get_max(1,log2roundup( struct.param.coef_mem_depth
                                                  +struct.param.coef_mem_offset )),
        num_filters     => reqs.num_filts,--*select_integer(1,2,struct.param.coef_reload=1),
        multi_page_reload => struct.param.coef_reload,
        offset          => struct.param.coef_mem_offset,
        has_ce          => reqs.has_ce,
        use_count_src   => 0,
        en_dly            => select_integer(0,1,(reqs.has_nd=1 and struct.param.no_data_mem=0) or
                                                struct.shorter_px_time or
                                                struct.sing_chan_short_block),
        base_max_dly      => select_integer(0,1, struct.param.base_count=1 and reqs.num_channels>1 and
                                                ((reqs.has_nd=1 and struct.param.no_data_mem=0) or
                                                struct.shorter_px_time) ),
        skip_base_max_dly => 0,
        count_max_dly     => 0,
        filt_sel_dly      => 0,
        resource_opt => reqs.resource_opt);

    struct.coef_addr_lat:=lat_coef_address(struct.coef_addr_param);

    struct.coef_addr_lat:=get_max(0,struct.coef_addr_lat-1);

    struct.reload_cntrl_param:=(
      family          => reqs.family,
      implementation  => implementation,
      reload_base_cnt => struct.param.base_count*struct.param.inter_rate,
      coef_addr_packed=> struct.param.coef_packed,
      num_filts       => reqs.num_filts,
      coef_mem_depth  => struct.param.coef_mem_depth,
      num_macs        => struct.param.num_macs,

      has_ce          => reqs.has_ce,
      coef_width      => reqs.coef_width,
      filt_sel_width  => reqs.filt_sel_width,
      filt_sel_width_out => select_integer(1,reqs.filt_sel_width+1, reqs.num_filts>1),
      reload_width    => get_max(1,log2roundup( struct.param.coef_mem_depth)),
      resource_opt => reqs.resource_opt,
      has_hb       => 0,
      latch_filt_sel => 0,
      coef_mem_lat => struct.memory_path_lat.coef,
      num_reload_strms => select_integer(1,2,struct.param.coef_mem_type=c_bram) );

    struct.reload_cntrl_param_lat:=lat_coef_reload_cntrl(struct.reload_cntrl_param);

    struct.addr_cntrl_lat:=select_integer(
                                1,
                                2,
                                (reqs.has_nd=1 and struct.param.no_data_mem=0) or
                                struct.shorter_px_time or
                                struct.sing_chan_short_block) ;

    --Balance delays
    
    if struct.has_input_buffer then
      if struct.input_buffer_lat>(struct.addr_cntrl_lat) then
        struct.data_dly:=0;
        struct.filt_dly:=0;
        struct.addr_dly:=struct.input_buffer_lat-(struct.addr_cntrl_lat);
      else
        struct.data_dly:=(struct.addr_cntrl_lat)-struct.input_buffer_lat;
        struct.filt_dly:=(struct.addr_cntrl_lat)-struct.input_buffer_lat;
        struct.addr_dly:=0;
      end if;
    else
      struct.filt_dly:=struct.addr_cntrl_lat;--get_max(0,struct.addr_cntrl_lat-1);
      struct.data_dly:=struct.addr_cntrl_lat;--get_max(0,struct.addr_cntrl_lat-1);
      struct.addr_dly:=0;
    end if;

    -- report "FIR: struct.filt_dly: "&int_to_str(struct.filt_dly);
--     report "FIR: struct.data_dly: "&int_to_str(struct.data_dly);
--     report "FIR: struct.addr_dly: "&int_to_str(struct.addr_dly);

    if reqs.coef_reload=1 then

      if struct.filt_dly - (struct.reload_cntrl_param_lat.filt_sel_lat) <= 0 then
        --need to delay address generation
        struct.addr_dly:=struct.addr_dly+abs( (struct.filt_dly - (struct.reload_cntrl_param_lat.filt_sel_lat)) );
        struct.data_dly:=struct.data_dly+abs( (struct.filt_dly - (struct.reload_cntrl_param_lat.filt_sel_lat)) );
        --also need to delay data to allign correctly
        struct.filt_dly:=0;
      else
        --subtract some delay from filt dly
        struct.filt_dly:=struct.filt_dly - (struct.reload_cntrl_param_lat.filt_sel_lat);
      end if;

    end if;

    -- report "FIR: struct.filt_dly: "&int_to_str(struct.filt_dly);
--     report "FIR: struct.data_dly: "&int_to_str(struct.data_dly);
--     report "FIR: struct.addr_dly: "&int_to_str(struct.addr_dly);

    data_addr_dly:=select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat);

    struct.data_addr_param.en_dly         :=struct.data_addr_param.en_dly+
                                            data_addr_dly+
                                            struct.addr_dly;
    struct.data_addr_param.block_end_dly  :=struct.data_addr_param.block_end_dly+
                                            data_addr_dly+
                                            struct.addr_dly;
    struct.data_addr_param.last_block_dly :=struct.data_addr_param.last_block_dly+
                                            data_addr_dly+
                                            struct.addr_dly;
    struct.data_addr_param.write_phase_dly :=struct.data_addr_param.write_phase_dly+
                                            data_addr_dly+
                                            struct.addr_dly;
    struct.data_addr_param.sub_block_end_dly :=struct.data_addr_param.sub_block_end_dly+
                                            data_addr_dly+
                                            struct.addr_dly;

    coef_addr_dly:=select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat);

    struct.coef_addr_param.en_dly         :=struct.coef_addr_param.en_dly+
                                            coef_addr_dly+
                                            struct.addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.base_max_dly  := struct.coef_addr_param.base_max_dly+
                                            coef_addr_dly+
                                            struct.addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.skip_base_max_dly := struct.coef_addr_param.skip_base_max_dly+
                                                coef_addr_dly+
                                                struct.addr_dly
                                                +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.count_max_dly := struct.coef_addr_param.count_max_dly+
                                            coef_addr_dly+
                                            struct.addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.filt_sel_dly :=  struct.coef_addr_param.filt_sel_dly+
                                            coef_addr_dly+
                                            struct.filt_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;

    struct.rfd_param:=(
        family          => reqs.family,
        implementation  => implementation,
        cnt             => struct.param.clk_per_chan,
        has_nd          => reqs.has_nd );


    --Latency Calculation
    struct.buffer_type:=select_integer(0,1,struct.has_input_buffer);
    struct.buffer_page_size:=reqs.num_channels;
    struct.latency:=--select_integer(0,struct.input_buffer_lat,struct.has_input_buffer)
                    select_integer(0,1,struct.has_input_buffer)
                    --only have latency of 1 to gen the ipb_start_op signal as the memory latency gets reflected in addr_dly
                    +struct.base_count_op_rate
                    +struct.addr_cntrl_lat-- -1
                    +struct.addr_dly
                    +get_max(struct.data_addr_lat,struct.coef_addr_lat)
                    +struct.first_tap_extra_dly
                    +struct.filt_arm_lat.cascaded
                    +struct.filt_arm_lat.tap
                    +select_integer(0,1,struct.accum_req)
                    +reqs.reg_output;

    return struct;

  end;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_halfband_decimation.vhd

  function define_halfband_decimation(reqs:t_reqs) return t_define_halfband_decimation is
  ------------------------------------------------------------------------------

    variable struct: t_define_halfband_decimation;
    --variable mem_param: t_tap_memory_add_casc;
    --variable memory_path_lat: t_lat_tap_memory_add_casc;
    constant srl16_mem_depth_thres: integer:=select_integer(32,64,
                                                            reqs.family=v5);
    constant dram_mem_depth_thres: integer:=select_integer(16,32,
                                                           reqs.family=v5);
    variable implementation:integer:=1;--structural
    variable  taps_per_phase,
              data_depth_unpacked,
              data_depth_packed,
              coef_depth_unpacked,
              coef_depth_packed,
              num_col,
              pass,
              data_addr_dly,
              coef_addr_dly,
              pre_sym_delay,
              sym_param_est_orig :integer;
  begin
    --Defaults and direct copies
    struct.param.family:=reqs.family;
    struct.param.filter_type:=reqs.filter_type;
    struct.param.coef_reload:=reqs.coef_reload;
    struct.param.data_sign:=reqs.data_sign;
    struct.param.coef_sign:=reqs.coef_sign;
    struct.param.data_width:=reqs.data_width;
    struct.param.coef_width:=reqs.coef_width;
    struct.param.clk_per_samp:=reqs.clk_per_samp;
    struct.param.num_channels:=reqs.num_channels;
    struct.param.num_taps:=reqs.num_taps;
    struct.param.num_filts:=reqs.num_filts;
    struct.param.zero_packing_factor:=reqs.zero_packing_factor;

    struct.param.symmetry:=1;--reqs.symmetry;
    struct.param.neg_symmetry:=0;--reqs.neg_symmetry;
    struct.param.odd_symmetry:=0;--select_integer(0,reqs.num_taps rem 2,struct.param.symmetry=1);
    struct.param.num_taps_calced:=(reqs.num_taps/2**struct.param.symmetry)+1;--struct.param.odd_symmetry;

    --loop round here once checked depth of inter tap buffer depth
     pass:=0;
     while pass<2 loop
      --Calculate details of the filter-------------------------------------------
      --Number of macs and number of taps per mac
      if ( reqs.clk_per_samp/reqs.num_channels = 0 ) then
        report "FIR: not enough clock cycles per sample to process all channels, must have a minimum of 1 clk cycle per channel" severity error;
      elsif ( reqs.clk_per_samp rem reqs.num_channels > 0 ) then
        report "FIR: number of channels does not fit fully into clock cycles per sample, there will be unused clock cycles" severity note;
      end if;
          
      struct.param.clk_per_chan := reqs.clk_per_samp / reqs.num_channels;
          
      struct.param.base_count := struct.param.clk_per_chan*2;

      taps_per_phase:= struct.param.num_taps_calced/ 2;
      if ( struct.param.num_taps_calced rem 2 > 0) then
        taps_per_phase:=taps_per_phase+1;
      end if;

      struct.param.num_macs := taps_per_phase/struct.param.base_count;

      struct.param.single_mac:=0;
      if struct.param.num_macs=0 then
        struct.param.single_mac:=1;
      end if;

      if ( taps_per_phase rem struct.param.base_count > 0 ) then
      -- Add extra mac, this mac will need the filter coefficients padded out.
        struct.param.num_macs:=struct.param.num_macs+1;
      end if;

      struct.base_count_op_rate:=struct.param.base_count;

      --Adjust for unused cycles
      if struct.param.single_mac=1 then
        --in this case the px time will always be shorter than the output rate as the input rate is mutliplied by two
        --this always gives an even time available and in a single mac case will only ever need odd num cycles for
        --calculations so cal assume it will generate the shorter_px_time structure
        struct.param.base_count:=taps_per_phase;

      else
        struct.param.base_count:=taps_per_phase/struct.param.num_macs;
        if (taps_per_phase rem struct.param.num_macs >0) then
          struct.param.base_count:=struct.param.base_count+1;
        end if;
      end if;
      
      struct.shorter_px_time:=false;
      if struct.base_count_op_rate>struct.param.base_count then
        struct.shorter_px_time:=true;
      end if;

      if pass=0 then
        struct.param.centre_mac:=struct.param.num_macs;
      end if;

      struct.param.base_data_space := struct.param.base_count;
      struct.param.base_coef_space := struct.param.base_count+struct.param.single_mac;--(2*struct.param.single_mac);

      -- Modify and update so get actual filter size
      struct.param.num_taps_calced:=struct.param.num_macs*struct.param.base_count*2;

      struct.param.inter_rate := 1;
      struct.param.deci_rate  := 1;

      struct.param.no_data_mem:= 0;
      if (struct.param.base_count = 1) then
        struct.param.no_data_mem:= 1;
      end if;


      --Structural decisions------------------------------------------------------


      --Memory calculations-------------------------------------
      data_depth_unpacked:=2**log2roundup(struct.param.base_data_space)*reqs.num_channels;
      data_depth_packed:=struct.param.base_data_space*reqs.num_channels;

      -- coef_depth_unpacked:=2**log2roundup(struct.param.base_coef_space)*struct.param.num_filts;
--       coef_depth_packed:=(struct.param.base_coef_space)*struct.param.num_filts;

      coef_depth_unpacked:=2**log2roundup( 2**log2roundup(struct.param.base_coef_space)*struct.param.num_filts)*2**struct.param.coef_reload;
      coef_depth_packed:=struct.param.base_coef_space*struct.param.num_filts*2**struct.param.coef_reload;

      struct.param:=memory_calcs( reqs,
                                  struct.param,
                                  data_depth_unpacked,
                                  data_depth_packed,
                                  coef_depth_unpacked,
                                  coef_depth_packed);

      --Symmetric wrap over calculations-------------------------
      --need to know latency of memory implmented
      struct.mem_param:=( family           =>reqs.family,
                          implementation   =>implementation,
                          data_mem_type    =>struct.param.data_mem_type,
                          coef_mem_type    =>struct.param.coef_mem_type,
                          data_comb        =>struct.param.data_combined,
                          data_coef_comb   =>struct.param.data_coef_combined,
                          no_data_mem      =>struct.param.no_data_mem,
                          coef_mem_depth  => struct.param.coef_mem_depth,
                          has_ce           =>reqs.has_ce,
                          coef_reload      =>reqs.coef_reload,
                          coef_reload_depth=>struct.param.base_coef_space,
                          symmetric        =>struct.param.symmetry );

      struct.memory_path_lat:=lat_tap_memory_add_casc(struct.mem_param);

      struct.cyc_to_data_out:=struct.memory_path_lat.data+1;--plus one for the latch (min depth of 1 in delay)

      struct.cyc_to_write:=0;--struct.base_count_op_rate-struct.param.base_count;
      --need to account for when has a short px time
      if (struct.mem_param.data_mem_type/=c_srl16) then -- =c_bram) then
        struct.cyc_to_write:=struct.cyc_to_write+struct.param.base_count; --inter_we_cycles
      end if;

      -- struct.num_cyc_read_earily:= select_integer(0,1,struct.cyc_to_write-struct.cyc_to_data_out<0)
--                                   +select_integer(0,1,struct.param.odd_symmetry=1);

      struct.num_cyc_read_earily:= select_integer(0,1,struct.cyc_to_write+struct.param.odd_symmetry-struct.cyc_to_data_out<0)
                                  +select_integer(0,1,struct.param.odd_symmetry=1);
      --add odd sym when calc if need earily read as when odd sym will read data earily this gives longer to get
      --data out of memory. So then check if still don't have enough time to get data out of memory

      struct.change_src:=select_integer(0,1,struct.num_cyc_read_earily>=struct.param.base_count);

      -- struct.extra_dly:=select_integer(0,1,(struct.cyc_to_data_out-struct.num_cyc_read_earily<=struct.cyc_to_write and
--                                             struct.num_cyc_read_earily-struct.param.odd_symmetry>0 and
--                                             struct.change_src=0) or
--                                            (struct.param.no_data_mem=1 and struct.param.odd_symmetry=1) );
                                           
      struct.extra_dly:=select_integer(
                          0,
                          select_integer(
                            reqs.num_channels-1,
                            reqs.num_channels,
                            struct.cyc_to_data_out-struct.num_cyc_read_earily<=struct.cyc_to_write),
                            --test is moved past another WE pulse by reading earily
                          struct.num_cyc_read_earily-struct.param.odd_symmetry>0 and
                          struct.change_src=0);

      struct.add_sup_dly:=struct.memory_path_lat.data
                          +(2*struct.param.single_mac);

      --Filter arm settings-------------------------------------
      if (reqs.col_mode=1) then
        -- if (struct.param.num_macs>reqs.col_1st_len) then
--           num_col:=1+(struct.param.num_macs-reqs.col_1st_len)/reqs.col_wrap_len;
--         else
--           num_col:=1;
--         end if;
        num_col:=calc_num_split_col(struct.param.num_macs,t_col_len'(
                                   0 => select_integer(reqs.col_wrap_len,reqs.col_1st_len,reqs.col_mode=1),
                                   others=>reqs.col_wrap_len));
      elsif (reqs.col_mode=2) then
        -- no generic for this mode yet
        num_col:=1;
      else
        num_col:=1;
      end if;
  
      struct.filt_arm:= (
          family          => reqs.family,
          implementation  => implementation,
          num_taps        => struct.param.num_macs,
          inter_we_cycles => struct.param.base_count,
          inter_tap_delay => struct.param.num_channels+1,
          inter_sym_tap_delay => struct.param.num_channels+1,
          symmetric       => struct.param.symmetry,
          pre_add_func    => c_preadd_add,
          data_mem_type   => struct.param.data_mem_type,
          coef_mem_type   => struct.param.coef_mem_type,
          data_comb       => struct.param.data_combined,
          data_coef_comb  => struct.param.data_coef_combined,
          data_cascade    => 0,
          no_data_mem     => struct.param.no_data_mem,
          coef_mem_depth  => struct.param.coef_mem_depth,
          p_src           => 0,--fabric
          data_sign       => reqs.data_sign,
          coef_sign       => reqs.coef_sign,
          has_ce          => reqs.has_ce,
          --has_nd          => reqs.has_nd,
          reload          => reqs.coef_reload,
          reload_strms    => select_integer(1,2,struct.param.coef_mem_type=c_bram),
          reload_depth    => struct.param.base_coef_space,
          output_index    => (
                            p_P_OUT       => select_integer(
                                              struct.param.num_macs+1,
                                              struct.param.num_macs,
                                              struct.param.single_mac=1),--so accum not attached to any other dsp48's
                            p_PC_OUT      => select_integer(
                                              struct.param.num_macs+1,
                                              struct.param.num_macs,
                                              struct.param.single_mac=1),
                            p_D_OUT       => struct.param.num_macs,-- -struct.change_src,
                            p_D_SYM_OUT   => struct.param.num_macs,
                            p_C_OUT       => struct.param.num_macs,
                            p_WE_OUT      => struct.param.num_macs,-- +1,
                            p_WE_SYM_OUT  => struct.param.num_macs+(struct.cyc_to_data_out-1)-struct.num_cyc_read_earily,
                            p_ADDSUB_OUT  => struct.param.num_macs+1,
                            p_ADDSUP_OUT  => struct.param.num_macs+1,
                            p_WE_SYM_OUT_2    => struct.param.num_macs ),
          output_src      => (
                            p_P_OUT       => 0,
                            p_PC_OUT      => 0,
                            p_D_OUT       => select_integer(1,0,struct.change_src=1 and struct.param.single_mac=0),
                            --when smac will do the src change at this level as need output of ram on the d_out port
                            p_D_SYM_OUT   => 1,--0,
                            p_C_OUT       => 0,
                            p_WE_OUT      => 0,
                            p_WE_SYM_OUT  => 0,
                            p_ADDSUB_OUT  => 0,
                            p_ADDSUP_OUT  => 0,
                            p_WE_SYM_OUT_2    => 0 ),
          num_independant_col => select_integer(1,num_col,reqs.col_mode=2),
          num_split_col       => select_integer(1,num_col,reqs.col_mode=1),
          inter_split_col_dly => reqs.col_pipe_len,
          col_len             => ( 0 => select_integer(reqs.col_wrap_len,reqs.col_1st_len,reqs.col_mode=1),
                                   others=>reqs.col_wrap_len),
          dynamic_opcode  => 0,
          sym_para_struct => reqs.has_nd,
          para_casc_we_src=> reqs.has_nd,
          resource_opt    => reqs.resource_opt,
          data_width      => reqs.data_width,
          datapath_mem_type => reqs.datapath_mem_type,
          odd_symmetry    => struct.param.odd_symmetry );
  
      struct.filt_arm_lat:=lat_filt_arm_add_casc(struct.filt_arm);

      if struct.param.no_data_mem=1 and struct.param.symmetry=1 and struct.filt_arm.sym_para_struct=1 then
        pre_sym_delay:=(struct.param.num_macs-struct.param.odd_symmetry)*(struct.filt_arm.inter_tap_delay-1);
        if reqs.family=v5 then
          pre_sym_delay:=(pre_sym_delay/33)+select_integer(0,1,pre_sym_delay rem 33 > 0);
        else
          pre_sym_delay:=(pre_sym_delay/17)+select_integer(0,1,pre_sym_delay rem 17 > 0);
        end if;
        pre_sym_delay:=pre_sym_delay*reqs.data_width;
        
        sym_param_est_orig:=pre_sym_delay+struct.filt_arm_lat.para_sym_slice_est;
        
        struct.filt_arm.sym_para_struct:=3;
        struct.filt_arm_lat:=lat_filt_arm_add_casc(struct.filt_arm);
        --change to fully delay sym structure

        if struct.filt_arm_lat.para_sym_slice_est >= sym_param_est_orig then
          --revert back to predelay structure
          struct.filt_arm.sym_para_struct:=1;
          struct.filt_arm_lat:=lat_filt_arm_add_casc(struct.filt_arm);
        end if;
      end if;

      if (  struct.param.symmetry=1 and
            pass=0 and
            struct.filt_arm_lat.sym_inter_buff_depth>1089 and
            reqs.data_mem_type=c_mem_forced_dist ) then

        --disable symmetry as srl16 will be forced for the delay and its is not able to support >1089
        struct.param.symmetry:=0;
        struct.param.neg_symmetry:=0;
        struct.param.odd_symmetry:=0;
        struct.param.num_taps_calced:=reqs.num_taps;
        pass:=1;
      else
        pass:=2;
      end if;

    end loop;

    --Accumulator settings---------------------------------------
    struct.accum:=(
        family         => reqs.family,
        implementation => implementation,
        pre_add        => 0,
        pre_add_func   => c_preadd_add,
        pre_add_ipreg  => 0,
        pre_add_midreg => 0,
        a_delay        => 1,
        b_delay        => 1,
        a_src          => 0,--fabric
        --c_src          => 1, --alway from another DSP
        a_sign         => reqs.data_sign,
        b_sign         => reqs.coef_sign,--not used in single rate
        d_sign         => reqs.data_sign,
        reg_opcode     => 1,
        implement_extra_b_dly => 1 );
        
    if struct.param.single_mac=1 then
      struct.accum:=(
        family         => reqs.family,
        implementation => implementation,
        pre_add        => 1,
        pre_add_func   => select_integer(c_preadd_add,c_preadd_add_swapped,reqs.family=s3ax),--c_preadd_add,
        pre_add_ipreg  => select_integer(0,1,reqs.resource_opt=c_speed and struct.param.data_mem_type=c_bram and struct.param.no_data_mem=0),
        pre_add_midreg => select_integer(0,1,reqs.resource_opt=c_speed and reqs.data_width>get_adder_max(reqs.family)),
        a_delay        => select_integer( 0,
                                          1,
                                          struct.memory_path_lat.coef-struct.memory_path_lat.data>0),
        b_delay        => select_integer( 0,
                                          1,
                                          struct.memory_path_lat.coef-struct.memory_path_lat.data<0),
        a_src          => 0,  --alway from fabric
        a_sign         => struct.param.data_sign,
        b_sign         => struct.param.coef_sign,
        d_sign         => struct.param.data_sign,
        reg_opcode     => 1,
        implement_extra_b_dly => 0 );
    end if;

    struct.accum_lat:=dtls_emb_calc(struct.accum);

    struct.accum_req:=true;

    
    --Input buffer settings--------------------------------------
    struct.input_buffer_lat:=0;
    struct.input_buffer_depth:=4*reqs.num_channels;

    struct.input_buffer:=(
      family              => reqs.family,
      implementation      => implementation,
      mem_type            => select_integer(
                              c_dram,--dram
                              c_bram,--bram
                              (struct.input_buffer_depth>dram_mem_depth_thres and reqs.ipbuff_mem_type/=c_mem_forced_dist) or
                               reqs.ipbuff_mem_type=c_mem_forced_bram),
      write_mode          => 0,--read first
      has_ce              => reqs.has_ce,
      use_mif             => 0 );

    struct.input_buffer_lat:=lat_ram(struct.input_buffer,2);

    struct.input_buffer_in_addr:=(
      family => reqs.family,
      implementation => implementation,
      addr_width => get_max(1,log2roundup(struct.input_buffer_depth)),
      page_size => 2*reqs.num_channels,
      num_enables => 2 );
      
    --Centre tap coefficient store-------------------------------
    struct.centre_tap_coef:=(
      family              => reqs.family,
      implementation      => implementation,
      mem_type            => select_integer(
                                select_integer(c_dram,c_bram,reqs.num_filts>srl16_mem_depth_thres),
                                select_integer(c_dram,c_bram,reqs.num_filts>dram_mem_depth_thres),
                                reqs.coef_reload=1 ),
      write_mode          => 0,
      has_ce              => reqs.has_ce,
      use_mif             => 1 );

    if reqs.coef_reload=1 then
      struct.centre_tap_coef_lat:=lat_ram(struct.centre_tap_coef,2);
    else
      struct.centre_tap_coef_lat:=lat_ram(struct.centre_tap_coef,1);
    end if;

    --Address generator block settings---------------------------
    struct.base_chan_phase_param:=(
        cnt1_max_val    => select_integer(
                              struct.param.base_count,
                              struct.base_count_op_rate,
                              struct.shorter_px_time),
        cnt2_max_val    => reqs.num_channels,
        cnt3_max_val    => 1,
        cnt2_max_qual   => select_integer(1,0,struct.shorter_px_time and struct.param.data_mem_type/=c_srl16),
        --need unqualified so chan_max alligns with base_max_px
        family          => reqs.family,
        implementation  => implementation );
        
    struct.data_addr_param:=(
        family          => reqs.family,
        implementation  => implementation,
        mem_type        => struct.param.data_mem_type,
        base_cnt        => struct.param.base_count,
        block_cnt       => reqs.num_channels,
        symmetric       => struct.param.symmetry,
        addr_width      => get_max(1,log2roundup(struct.param.data_mem_depth)),
        sym_addr_width  => get_max(1,log2roundup(struct.param.datasym_mem_depth+struct.param.datasym_mem_offset)),
        combined        => struct.param.data_combined,
        addr_packed     => struct.param.data_packed,
        srl16_sequence  => 0,--uses standard address sequence
        en_dly          => select_integer(0,1,(reqs.has_nd=1 and struct.param.no_data_mem=0) or
                                                struct.shorter_px_time),
        block_end_dly   => 0,  --delay of one due to the generation of addr_en
        last_block_dly  => 0,
        write_phase_dly => 0,
        sub_block_end_dly => 0,
        use_sym_cntrl   => 0,
        resource_opt => reqs.resource_opt  );

    struct.data_addr_lat:=lat_data_address(struct.data_addr_param);

    struct.data_addr_lat:=get_max(0,struct.data_addr_lat-1);
    --sub 1 as only interested in the first location of the count, 
    --this occurs with 0 latency when latency is 1

    struct.coef_addr_param:=(
        family          => reqs.family,
        implementation  => implementation,
        base_cnt        => struct.param.base_count+struct.param.single_mac,
        block_cnt       => 1,
        addr_packed     => struct.param.coef_packed,
        addr_width      => get_max(1,log2roundup( struct.param.coef_mem_depth
                                                  +struct.param.coef_mem_offset )),
        num_filters     => reqs.num_filts,--*select_integer(1,2,struct.param.coef_reload=1),
        multi_page_reload => struct.param.coef_reload,
        offset          => struct.param.coef_mem_offset,
        has_ce          => reqs.has_ce,
        use_count_src   => 0,
        en_dly            => select_integer(0,1,((reqs.has_nd=1 and struct.param.no_data_mem=0) or
                                                struct.shorter_px_time) and
                                                struct.param.single_mac=0),
        base_max_dly      => 0,
        skip_base_max_dly => 0,
        count_max_dly     => 0,
        filt_sel_dly      => 0,
        resource_opt => reqs.resource_opt);--select_integer(0,2,reqs.has_nd=1 and struct.param.no_data_mem=0));

    struct.coef_addr_lat:=lat_coef_address(struct.coef_addr_param);

    struct.coef_addr_lat:=get_max(0,struct.coef_addr_lat-1);
    
    struct.reload_cntrl_param:=(
      family          => reqs.family,
      implementation  => implementation,
      reload_base_cnt => struct.param.base_count+struct.param.single_mac,
      coef_addr_packed=> struct.param.coef_packed,
      num_filts       => reqs.num_filts,
      coef_mem_depth  => struct.param.coef_mem_depth,
      num_macs        => struct.param.num_macs,

      has_ce          => reqs.has_ce,
      coef_width      => reqs.coef_width,
      filt_sel_width  => reqs.filt_sel_width,
      filt_sel_width_out => select_integer(1,reqs.filt_sel_width+1, reqs.num_filts>1),
      reload_width    => get_max(1,log2roundup( struct.param.coef_mem_depth)),
      resource_opt => reqs.resource_opt,
      has_hb       => select_integer(1,0,struct.param.single_mac=1),
      latch_filt_sel => 0,
      coef_mem_lat => struct.memory_path_lat.coef,
      num_reload_strms => select_integer(1,2,struct.param.coef_mem_type=c_bram) );

    struct.reload_cntrl_param_lat:=lat_coef_reload_cntrl(struct.reload_cntrl_param);

    struct.addr_cntrl_lat:=select_integer(
                                -- select_integer(
--                                   0,
--                                   1,
--                                   reqs.coef_reload=1),
                                1,
                                2,
                                (reqs.has_nd=1 and struct.param.no_data_mem=0) or
                                struct.shorter_px_time );

    --Balance delays
    -- +1 is added to the input buffer latency as it takes 2 cycles to generate the input buffer read address
    if (struct.input_buffer_lat+1)>(struct.addr_cntrl_lat) then
      struct.data_dly:=0;
      struct.filt_dly:=0;
      struct.addr_dly:=(struct.input_buffer_lat+1)-(struct.addr_cntrl_lat);
    else
      struct.data_dly:=(struct.addr_cntrl_lat)-(struct.input_buffer_lat+1);
      struct.filt_dly:=(struct.addr_cntrl_lat)-(struct.input_buffer_lat+1);
      struct.addr_dly:=0;
    end if;
    
    if struct.data_dly=0 and struct.param.data_mem_type=c_srl16 then
    --delay will be modifed so data and WE are earily of the address,
    --in this case it will not be able to make it any earily so
    --add a delay to everything
      struct.data_dly:=struct.data_dly+1;
      struct.filt_dly:=struct.filt_dly+1;
      struct.addr_dly:=struct.addr_dly+1;
    end if;

    -- report "FIR: struct.filt_dly: "&int_to_str(struct.filt_dly);
--     report "FIR: struct.data_dly: "&int_to_str(struct.data_dly);
--     report "FIR: struct.addr_dly: "&int_to_str(struct.addr_dly);

    if reqs.coef_reload=1 then

      if struct.filt_dly - (struct.reload_cntrl_param_lat.filt_sel_lat) <= 0 then
        --need to delay address generation
        struct.addr_dly:=struct.addr_dly+abs( (struct.filt_dly - (struct.reload_cntrl_param_lat.filt_sel_lat)) );
        struct.data_dly:=struct.data_dly+abs( (struct.filt_dly - (struct.reload_cntrl_param_lat.filt_sel_lat)) );
        struct.filt_dly:=0;
      else
        --subtract some delay from filt dly
        struct.filt_dly:=struct.filt_dly - (struct.reload_cntrl_param_lat.filt_sel_lat);
      end if;

    end if;
    
    -- report "FIR: struct.filt_dly: "&int_to_str(struct.filt_dly);
--     report "FIR: struct.data_dly: "&int_to_str(struct.data_dly);
--     report "FIR: struct.addr_dly: "&int_to_str(struct.addr_dly);

    --Check delays for latching signal for sym wrap over-----
    struct.we_sym_dly:=struct.addr_cntrl_lat
                       +struct.addr_dly
                       +get_max(struct.data_addr_lat,struct.coef_addr_lat);

    if struct.filt_arm.output_index(p_WE_SYM_OUT)<=0 and struct.param.symmetry=1 then
      --will not be able to get latching signal for wrap over as not enough mac in filt arm
      if struct.we_sym_dly-1+struct.filt_arm.output_index(p_WE_SYM_OUT)<0 then
        --not enough latency to read earily from generation delay so add latency to addr gen.
        struct.addr_dly:=struct.addr_dly+abs(struct.we_sym_dly-1+struct.filt_arm.output_index(p_WE_SYM_OUT));
        struct.filt_dly:=struct.filt_dly+abs(struct.we_sym_dly-1+struct.filt_arm.output_index(p_WE_SYM_OUT));
        --struct.addr_cntrl_lat:=struct.addr_cntrl_lat+abs(struct.we_sym_dly-1+struct.filt_arm.output_index(p_WE_SYM_OUT));
        struct.we_sym_dly:=struct.addr_cntrl_lat
                           +struct.addr_dly
                           +get_max(struct.data_addr_lat,struct.coef_addr_lat);
      end if;
    end if;

    data_addr_dly:=select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat);

    struct.data_addr_param.en_dly         :=struct.data_addr_param.en_dly+
                                            data_addr_dly+
                                            struct.addr_dly;
    struct.data_addr_param.block_end_dly  :=struct.data_addr_param.block_end_dly+
                                            data_addr_dly+
                                            struct.addr_dly;
    struct.data_addr_param.last_block_dly :=struct.data_addr_param.last_block_dly+
                                            data_addr_dly+
                                            struct.addr_dly;

    coef_addr_dly:=select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat);

    struct.coef_addr_param.en_dly         :=struct.coef_addr_param.en_dly+
                                            coef_addr_dly+
                                            struct.addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.base_max_dly  := struct.coef_addr_param.base_max_dly+
                                            coef_addr_dly+
                                            struct.addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.skip_base_max_dly := struct.coef_addr_param.skip_base_max_dly+
                                                coef_addr_dly+
                                                struct.addr_dly
                                                +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.count_max_dly := struct.coef_addr_param.count_max_dly+
                                            coef_addr_dly+
                                            struct.addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.filt_sel_dly :=  struct.coef_addr_param.filt_sel_dly+
                                            coef_addr_dly+
                                            struct.filt_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;

    struct.rfd_param:=(
        family          => reqs.family,
        implementation  => implementation,
        cnt             => struct.param.clk_per_chan,
        has_nd          => reqs.has_nd );

    --Latency Calculation
    struct.buffer_type:=1;
    struct.buffer_page_size:=2*reqs.num_channels;
    struct.latency:=1--struct.input_buffer_lat
                    --only need a delay of 1 for input buffer and mem access time accounted for in addr_dly
                    +struct.base_count_op_rate--struct.param.base_count
                    +struct.addr_cntrl_lat-- -1
                    +struct.addr_dly
                    +get_max(struct.data_addr_lat,struct.coef_addr_lat)
                    +struct.filt_arm_lat.cascaded
                    +struct.filt_arm_lat.tap
                    +select_integer(0,1,struct.accum_req)
                    +reqs.reg_output;

    return struct;

  end;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_halfband_interpolation.vhd

  function define_halfband_interpolation(reqs:t_reqs) return t_define_halfband_interpolation is
  ------------------------------------------------------------------------------

    variable struct: t_define_halfband_interpolation;
    --variable mem_param: t_tap_memory_add_casc;
    --variable memory_path_lat: t_lat_tap_memory_add_casc;
    constant srl16_mem_depth_thres: integer:=select_integer(32,64,
                                                            reqs.family=v5);
    constant dram_mem_depth_thres: integer:=select_integer(16,32,
                                                           reqs.family=v5);
    variable implementation:integer:=1;--structural
    variable  data_depth_unpacked,
              data_depth_packed,
              coef_depth_unpacked,
              coef_depth_packed,
              num_col,
              pass,
              taps_per_phase,
              filter_sel_dly,
              addr_dly,
              pre_sym_delay,
              sym_param_est_orig :integer;
  begin
    --Defaults and direct copies
    struct.param.family:=reqs.family;
    struct.param.filter_type:=reqs.filter_type;
    struct.param.coef_reload:=reqs.coef_reload;
    struct.param.data_sign:=reqs.data_sign;
    struct.param.coef_sign:=reqs.coef_sign;
    struct.param.data_width:=reqs.data_width;
    struct.param.coef_width:=reqs.coef_width;
    struct.param.clk_per_samp:=reqs.clk_per_samp;
    struct.param.num_channels:=reqs.num_channels;
    struct.param.num_taps:=reqs.num_taps;
    struct.param.num_filts:=reqs.num_filts;
    struct.param.zero_packing_factor:=reqs.zero_packing_factor;

    struct.param.symmetry:=1;
    struct.param.neg_symmetry:=0;
    struct.param.odd_symmetry:=0;
    struct.param.num_taps_calced:=(reqs.num_taps/2**struct.param.symmetry)+1;

    --loop round here once checked depth of inter tap buffer depth
     pass:=0;
     while pass<2 loop
      --Calculate details of the filter-------------------------------------------
      --Number of macs and number of taps per mac
      if ( reqs.clk_per_samp/reqs.num_channels = 0 ) then
        report "FIR: not enough clock cycles per sample to process all channels, must have a minimum of 1 clk cycle per channel" severity error;
      elsif ( reqs.clk_per_samp rem reqs.num_channels > 0 ) then
        report "FIR: number of channels does not fit fully into clock cycles per sample, there will be unused clock cycles" severity note;
      end if;
          
      struct.param.clk_per_chan := reqs.clk_per_samp / reqs.num_channels;

      if (struct.param.clk_per_chan rem 2 > 0) then
        report "FIR: the available clock cycles is not evenly divisable by the interpolation rate, this means there will be unused clock cycles" severity note;
      end if;

      struct.param.base_count := struct.param.clk_per_chan;--(struct.param.clk_per_chan / 2)*2; --not sure if this is necessary now
      --use all avaiable cycles

      taps_per_phase:= struct.param.num_taps_calced/ 2;
      if ( struct.param.num_taps_calced rem 2 > 0) then
        taps_per_phase:=taps_per_phase+1;
      end if;

      struct.param.num_macs :=taps_per_phase/ struct.param.base_count;
      
      struct.param.single_mac:=0;
      if struct.param.num_macs=0 then
        struct.param.single_mac:=1;
      end if;

      if ( taps_per_phase rem struct.param.base_count > 0 ) then
      -- Add extra mac, this mac will need the filter coefficients padded out.
        struct.param.num_macs:=struct.param.num_macs+1;
      end if;

      --Adjust for unused cycles
      if struct.param.single_mac=1 then
        --SMAC
        struct.param.base_count:=taps_per_phase;--+1;
      else
        --Normal
        struct.param.base_count:=taps_per_phase/struct.param.num_macs;
        if (taps_per_phase rem struct.param.num_macs >0) then
          struct.param.base_count:=struct.param.base_count+1;
        end if;
      end if;

      if pass=0 then
        struct.param.centre_mac:=struct.param.num_macs;
      end if;
      
      struct.output_rate:=struct.param.clk_per_chan/2;

      struct.param.base_data_space := struct.param.base_count;
      struct.param.base_coef_space := struct.param.base_count+struct.param.single_mac;

      -- Modify and update so get actual filter size
      struct.param.num_taps_calced:=struct.param.num_macs*struct.param.base_count*2;

      struct.param.inter_rate := 1;
      struct.param.deci_rate  := 1;

      struct.param.no_data_mem:= 0;
      if (struct.param.base_count = 1) then --should never occur
        struct.param.no_data_mem:= 1;
      end if;

      --Structural decisions------------------------------------------------------

      --Memory calculations-------------------------------------
      data_depth_unpacked:=2**log2roundup(struct.param.base_data_space)*reqs.num_channels;
      data_depth_packed:=struct.param.base_data_space*reqs.num_channels;

      -- coef_depth_unpacked:=2**log2roundup(struct.param.base_coef_space)*struct.param.num_filts;
--       coef_depth_packed:=struct.param.base_coef_space*struct.param.num_filts;

      coef_depth_unpacked:=2**log2roundup( 2**log2roundup(struct.param.base_coef_space)*struct.param.num_filts)*2**struct.param.coef_reload;
      coef_depth_packed:=struct.param.base_coef_space*struct.param.num_filts*2**struct.param.coef_reload;

      struct.param:=memory_calcs( reqs,
                                  struct.param,
                                  data_depth_unpacked,
                                  data_depth_packed,
                                  coef_depth_unpacked,
                                  coef_depth_packed);

      --Symmetric wrap over calculations-------------------------
      --need to know latency of memory implmented
      struct.mem_param:=( family           =>reqs.family,
                          implementation   =>implementation,
                          data_mem_type    =>struct.param.data_mem_type,
                          coef_mem_type    =>struct.param.coef_mem_type,
                          data_comb        =>struct.param.data_combined,
                          data_coef_comb   =>struct.param.data_coef_combined,
                          no_data_mem      =>struct.param.no_data_mem,
                          coef_mem_depth  => struct.param.coef_mem_depth,
                          has_ce           =>reqs.has_ce,
                          coef_reload      =>reqs.coef_reload,
                          coef_reload_depth=>struct.param.base_coef_space,
                          symmetric        =>struct.param.symmetry );

      struct.memory_path_lat:=lat_tap_memory_add_casc(struct.mem_param);
  
      struct.cyc_to_data_out:=struct.memory_path_lat.data+1;--plus one for the latch (min depth of 1 in delay)
      
      struct.cyc_to_write:=0;
      if (struct.mem_param.data_mem_type/=c_srl16) then -- =c_bram) then
        struct.cyc_to_write:=struct.param.base_count; --inter_we_cycles
      end if;

      -- struct.num_cyc_read_earily:= select_integer(0,1,struct.cyc_to_write-struct.cyc_to_data_out<0)
--                                   +select_integer(0,1,struct.param.odd_symmetry=1);

      struct.num_cyc_read_earily:= select_integer(0,1,struct.cyc_to_write+struct.param.odd_symmetry-struct.cyc_to_data_out<0)
                                  +select_integer(0,1,struct.param.odd_symmetry=1);
      --add odd sym when calc if need earily read as when odd sym will read data earily this gives longer to get
      --data out of memory. So then check if still don't have enough time to get data out of memory

      struct.change_src:=select_integer(0,1,struct.num_cyc_read_earily>=struct.param.base_count);

      -- struct.extra_dly:=select_integer(0,1,(struct.cyc_to_data_out-struct.num_cyc_read_earily<=struct.cyc_to_write and
--                                             struct.num_cyc_read_earily-struct.param.odd_symmetry>0 and
--                                             struct.change_src=0) or
--                                            (struct.param.no_data_mem=1 and struct.param.odd_symmetry=1) );

      struct.extra_dly:=select_integer(
                          0,
                          select_integer(
                            reqs.num_channels-1,
                            reqs.num_channels,
                            struct.cyc_to_data_out-struct.num_cyc_read_earily<=struct.cyc_to_write),
                            --test is moved past another WE pulse by reading earily
                          struct.num_cyc_read_earily-struct.param.odd_symmetry>0 and
                          struct.change_src=0);

      struct.add_sup_dly:=struct.memory_path_lat.data+1;

      --Filter arm settings-------------------------------------
      if (reqs.col_mode=1) then
        -- if (struct.param.num_macs>reqs.col_1st_len) then
--           num_col:=1+(struct.param.num_macs-reqs.col_1st_len)/reqs.col_wrap_len;
--         else
--           num_col:=1;
--         end if;
        num_col:=calc_num_split_col(struct.param.num_macs,t_col_len'(
                                   0 => select_integer(reqs.col_wrap_len,reqs.col_1st_len,reqs.col_mode=1),
                                   others=>reqs.col_wrap_len));
      elsif (reqs.col_mode=2) then
        -- no generic for this mode yet
        num_col:=1;
      else
        num_col:=1;
      end if;
  
      struct.filt_arm:= (
          family          => reqs.family,
          implementation  => implementation,
          num_taps        => struct.param.num_macs,
          inter_we_cycles => struct.param.base_count,
          inter_tap_delay => struct.param.num_channels+1,
          inter_sym_tap_delay => struct.param.num_channels+1,
          symmetric       => struct.param.symmetry,
          pre_add_func    => select_integer(c_preadd_add,c_preadd_add_swapped,reqs.family=s3ax and struct.param.single_mac=1),--select_integer(c_preadd_add,c_preadd_sub,struct.param.neg_symmetry=1),
          data_mem_type   => struct.param.data_mem_type,
          coef_mem_type   => struct.param.coef_mem_type,
          data_comb       => struct.param.data_combined,
          data_coef_comb  => struct.param.data_coef_combined,
          data_cascade    => select_integer(0,1,
                                            struct.param.clk_per_chan=1 and
                                            struct.param.num_channels=1 and 
                                            struct.param.symmetry=0),
          no_data_mem     => struct.param.no_data_mem,
          coef_mem_depth  => struct.param.coef_mem_depth,
          p_src           => 0,--fabric
          data_sign       => reqs.data_sign,
          coef_sign       => reqs.coef_sign,
          has_ce          => reqs.has_ce,
          --has_nd          => reqs.has_nd,
          reload          => reqs.coef_reload,
          reload_strms    => select_integer(1,2,struct.param.coef_mem_type=c_bram),
          reload_depth    => struct.param.base_coef_space,
          output_index    => (
                            p_P_OUT       => struct.param.num_macs+1,
                            p_PC_OUT      => struct.param.num_macs+1,
                            p_D_OUT       => struct.param.num_macs,-- -struct.change_src,
                            p_D_SYM_OUT   => struct.param.num_macs,
                            p_C_OUT       => struct.param.num_macs,
                            p_WE_OUT      => struct.param.num_macs,-- +1,
                            p_WE_SYM_OUT  => struct.param.num_macs+(struct.cyc_to_data_out-1)-struct.num_cyc_read_earily,
                            p_ADDSUB_OUT  => struct.param.num_macs+1,
                            p_ADDSUP_OUT  => struct.param.num_macs+1,
                            p_WE_SYM_OUT_2    => struct.param.num_macs+struct.memory_path_lat.data ),
          output_src      => (
                            p_P_OUT       => 0,
                            p_PC_OUT       => 0,
                            p_D_OUT       => select_integer(1,0,struct.change_src=1),
                            p_D_SYM_OUT   => 0,
                            p_C_OUT       => 0,
                            p_WE_OUT      => 0,
                            p_WE_SYM_OUT  => 0,
                            p_ADDSUB_OUT  => 0,
                            p_ADDSUP_OUT  => 0,
                            p_WE_SYM_OUT_2    => 0 ),
          num_independant_col => select_integer(1,num_col,reqs.col_mode=2),
          num_split_col       => select_integer(1,num_col,reqs.col_mode=1),
          inter_split_col_dly => reqs.col_pipe_len,
          col_len             => ( 0 => select_integer(reqs.col_wrap_len,reqs.col_1st_len,reqs.col_mode=1),
                                   others=>reqs.col_wrap_len),
          dynamic_opcode  => select_integer(0,1,struct.param.single_mac=1),
          sym_para_struct => reqs.has_nd,
          para_casc_we_src=> reqs.has_nd,
          resource_opt    => reqs.resource_opt,
          data_width      => reqs.data_width,
          datapath_mem_type => reqs.datapath_mem_type,
          odd_symmetry    => struct.param.odd_symmetry  );
  
      struct.filt_arm_lat:=lat_filt_arm_add_casc(struct.filt_arm);

      if struct.param.no_data_mem=1 and struct.param.symmetry=1 and struct.filt_arm.sym_para_struct=1 then
        pre_sym_delay:=(struct.param.num_macs-struct.param.odd_symmetry)*(struct.filt_arm.inter_tap_delay-1);
        if reqs.family=v5 then
          pre_sym_delay:=(pre_sym_delay/33)+select_integer(0,1,pre_sym_delay rem 33 > 0);
        else
          pre_sym_delay:=(pre_sym_delay/17)+select_integer(0,1,pre_sym_delay rem 17 > 0);
        end if;
        pre_sym_delay:=pre_sym_delay*reqs.data_width;
        
        sym_param_est_orig:=pre_sym_delay+struct.filt_arm_lat.para_sym_slice_est;
        
        struct.filt_arm.sym_para_struct:=3;
        struct.filt_arm_lat:=lat_filt_arm_add_casc(struct.filt_arm);
        --change to fully delay sym structure

        if struct.filt_arm_lat.para_sym_slice_est >= sym_param_est_orig then
          --revert back to predelay structure
          struct.filt_arm.sym_para_struct:=1;
          struct.filt_arm_lat:=lat_filt_arm_add_casc(struct.filt_arm);
        end if;
      end if;

      if (  struct.param.symmetry=1 and
            pass=0 and
            struct.filt_arm_lat.sym_inter_buff_depth>1089 and
            reqs.data_mem_type=c_mem_forced_dist ) then

        --disable symmetry as srl16 will be forced for the delay and its is not able to support >1089
        struct.param.symmetry:=0;
        struct.param.neg_symmetry:=0;
        struct.param.odd_symmetry:=0;
        struct.param.num_taps_calced:=reqs.num_taps;
        pass:=1;
      else
        pass:=2;
      end if;

    end loop;

    --Accumulator settings---------------------------------------
    struct.accum:=(
        family         => reqs.family,
        implementation => implementation,
        pre_add        => 0,
        pre_add_func   => c_preadd_add,
        pre_add_ipreg  => 0,
        pre_add_midreg => 0,
        a_delay        => 1,--select_integer(1,0,reqs.family=s3ax), --for v4/5 I think use extra delay for compensation
        b_delay        => 1,--select_integer(1,0,reqs.family=s3ax),
        a_src          => 0,--fabric
        --c_src          => 1, --alway from another DSP
        a_sign         => reqs.data_sign,
        b_sign         => reqs.coef_sign,--not used in single rate
        d_sign         => reqs.data_sign,
        reg_opcode     => 1,
        implement_extra_b_dly => 1 );

    struct.accum_details:=dtls_emb_calc(struct.accum);

    struct.accum_req:=true;

    if (struct.param.single_mac=1) then
      struct.accum_req:=false;
    end if;

    struct.accum_extra_dly:=0;
    if reqs.family=s3ax and struct.param.single_mac=0 then
      struct.add_partial_prod:=(
        family         => reqs.family,
        implementation => 1,
        pre_add        => 0,
        pre_add_func   => c_preadd_add,
        pre_add_ipreg  => 0,
        pre_add_midreg => 0,
        a_delay        => 0,
        b_delay        => 0,
        a_src          => 0,--fabric
        a_sign         => c_unsigned,
        b_sign         => c_unsigned,
        d_sign         => c_unsigned,
        reg_opcode     => 1,
        implement_extra_b_dly => 1 );
      
      struct.add_partial_prod_dtls:=dtls_emb_calc(struct.add_partial_prod);
      
      --this is to account for the extra dsp48 to do the pre-add
      --of the first and second partial product that can't be
      --done on the accumulator normally.
      struct.accum_extra_dly:=1;
    end if;
    
    --Centre tap coefficient store-------------------------------
    struct.centre_tap_coef:=(
      family              => reqs.family,
      implementation      => implementation,
      mem_type            => select_integer(
                                select_integer(c_dram,c_bram,reqs.num_filts>srl16_mem_depth_thres),
                                select_integer(c_dram,c_bram,reqs.num_filts>dram_mem_depth_thres),
                                reqs.coef_reload=1 ),
      write_mode          => 0,
      has_ce              => reqs.has_ce,
      use_mif             => 1 );

    if reqs.coef_reload=1 then
      struct.centre_tap_coef_lat:=lat_ram(struct.centre_tap_coef,2);
    else
      struct.centre_tap_coef_lat:=lat_ram(struct.centre_tap_coef,1);
    end if;
    
    --Output buffer ram settings---------------------------------
    struct.output_buffer_depth:=2*2**log2roundup(2*reqs.num_channels);

    struct.output_buffer:=(
      family              => reqs.family,
      implementation      => implementation,
      mem_type            => select_integer(
                              c_dram,--dram
                              c_bram,--bram
                              (struct.output_buffer_depth>dram_mem_depth_thres and reqs.opbuff_mem_type/=c_mem_forced_dist) or
                              reqs.opbuff_mem_type=c_mem_forced_bram),
      write_mode          => 0,--read first
      has_ce              => reqs.has_ce,
      use_mif             => 0 );

    struct.output_rate_counter:=(
        cnt1_max_val    => struct.output_rate,
        cnt2_max_val    => 2*reqs.num_channels,
        cnt3_max_val    => 1,
        cnt2_max_qual   => 1,
        family          => reqs.family,
        implementation  => implementation );

    struct.output_buffer_lat:=lat_ram(struct.output_buffer,2);

    --Address generator block settings---------------------------
    
    if (reqs.has_nd=1 and struct.param.no_data_mem=0) or
       (struct.param.base_count<struct.param.clk_per_chan) then
      struct.addr_hold_struct:=true;
    else
      struct.addr_hold_struct:=false;
    end if;

    struct.base_chan_phase_param:=(
        cnt1_max_val    => struct.param.base_count,
        cnt2_max_val    => reqs.num_channels,
        cnt3_max_val    => 1,
        cnt2_max_qual   => 1,
        family          => reqs.family,
        implementation  => implementation );
        
    struct.data_addr_param:=(
        family          => reqs.family,
        implementation  => implementation,
        mem_type        => struct.param.data_mem_type,
        base_cnt        => struct.param.base_count,
        block_cnt       => reqs.num_channels,
        symmetric       => struct.param.symmetry,
        addr_width      => get_max(1,log2roundup(struct.param.data_mem_depth)),
        sym_addr_width  => get_max(1,log2roundup(struct.param.datasym_mem_depth+struct.param.datasym_mem_offset)),
        combined        => struct.param.data_combined,
        addr_packed     => struct.param.data_packed,
        srl16_sequence  => 0,--uses standard address sequence
        en_dly          => select_integer(0,1,struct.addr_hold_struct),
        block_end_dly   => 0,  --delay of one due to the generation of addr_en
        last_block_dly  => 0,
        write_phase_dly => 0,
        sub_block_end_dly => 0,
        use_sym_cntrl   => 0,
        resource_opt => reqs.resource_opt  );

    struct.data_addr_lat:=lat_data_address(struct.data_addr_param);

    struct.data_addr_lat:=get_max(0,struct.data_addr_lat-1);
    --sub 1 as only interested in the first location of the count, 
    --this occurs with 0 latency when latency is 1

    struct.coef_addr_param:=(
        family          => reqs.family,
        implementation  => implementation,
        base_cnt        => struct.param.base_count+struct.param.single_mac,
        block_cnt       => 1,
        addr_packed     => struct.param.coef_packed,
        addr_width      => get_max(1,log2roundup( struct.param.coef_mem_depth
                                                  +struct.param.coef_mem_offset )),
        num_filters     => reqs.num_filts,--*select_integer(1,2,struct.param.coef_reload=1),
        multi_page_reload => struct.param.coef_reload,
        offset          => struct.param.coef_mem_offset,
        has_ce          => reqs.has_ce,
        use_count_src   => 0,
        en_dly            => select_integer(0,1,struct.addr_hold_struct and struct.param.single_mac=0),
        base_max_dly      => 0,
        skip_base_max_dly => 0,
        count_max_dly     => 0,
        filt_sel_dly      => 0,
        resource_opt => reqs.resource_opt);--select_integer(1,2,struct.addr_hold_struct));

    struct.coef_addr_lat:=lat_coef_address(struct.coef_addr_param);

    struct.coef_addr_lat:=get_max(0,struct.coef_addr_lat-1);

    struct.reload_cntrl_param:=(
      family          => reqs.family,
      implementation  => implementation,
      reload_base_cnt => struct.param.base_count+struct.param.single_mac,
      coef_addr_packed=> struct.param.coef_packed,
      num_filts       => reqs.num_filts,
      coef_mem_depth  => struct.param.coef_mem_depth,
      num_macs        => struct.param.num_macs,

      has_ce          => reqs.has_ce,
      coef_width      => reqs.coef_width,
      filt_sel_width  => reqs.filt_sel_width,
      filt_sel_width_out => select_integer(1,reqs.filt_sel_width+1, reqs.num_filts>1),
      reload_width    => get_max(1,log2roundup( struct.param.coef_mem_depth)),
      resource_opt => reqs.resource_opt,
      has_hb       => select_integer(1,0,struct.param.single_mac=1),
      latch_filt_sel => 1,
      coef_mem_lat => struct.memory_path_lat.coef,
      num_reload_strms => select_integer(1,2,struct.param.coef_mem_type=c_bram) );

    struct.reload_cntrl_param_lat:=lat_coef_reload_cntrl(struct.reload_cntrl_param);

    struct.addr_cntrl_lat:=select_integer(
                                -- select_integer(
--                                   0,
--                                   1,
--                                   reqs.coef_reload=1),
                                1,
                                2,
                                struct.addr_hold_struct);

    if reqs.coef_reload=1 then
      if struct.reload_cntrl_param_lat.filt_sel_lat-1 < struct.addr_cntrl_lat then
        filter_sel_dly:=struct.addr_cntrl_lat-(struct.reload_cntrl_param_lat.filt_sel_lat-1);
        addr_dly:=0;
      else
        filter_sel_dly:=0;
        addr_dly:=(struct.reload_cntrl_param_lat.filt_sel_lat-1)-struct.addr_cntrl_lat;
        struct.addr_cntrl_lat:=struct.addr_cntrl_lat+addr_dly;
      end if;
    else
      addr_dly:=0;
      filter_sel_dly:=struct.addr_cntrl_lat;
    end if;

    --Check delays for latching signal for sym wrap over-----
    struct.we_sym_dly:=struct.addr_cntrl_lat
                       +get_max(struct.data_addr_lat,struct.coef_addr_lat);

    if struct.filt_arm.output_index(p_WE_SYM_OUT)<=0 and struct.param.symmetry=1 then
      --will not be able to get latching signal for wrap over as not enough mac in filt arm
      if struct.we_sym_dly-1+struct.filt_arm.output_index(p_WE_SYM_OUT)<0 then
        --not enough latency to read earily from generation delay so add latency to addr gen.
        addr_dly:=addr_dly+abs(struct.we_sym_dly-1+struct.filt_arm.output_index(p_WE_SYM_OUT));
        filter_sel_dly:=filter_sel_dly+abs(struct.we_sym_dly-1+struct.filt_arm.output_index(p_WE_SYM_OUT));
        struct.addr_cntrl_lat:=struct.addr_cntrl_lat+abs(struct.we_sym_dly-1+struct.filt_arm.output_index(p_WE_SYM_OUT));
        struct.we_sym_dly:=struct.addr_cntrl_lat
                           +get_max(struct.data_addr_lat,struct.coef_addr_lat);
      end if;
    end if;

    --Balance delays
    struct.data_addr_param.en_dly         :=struct.data_addr_param.en_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat)
                                            +addr_dly;
    struct.data_addr_param.block_end_dly  :=struct.data_addr_param.block_end_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat)
                                            +addr_dly;
    struct.data_addr_param.last_block_dly :=struct.data_addr_param.last_block_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat)
                                            +addr_dly;

    struct.coef_addr_param.en_dly         :=struct.coef_addr_param.en_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.base_max_dly  :=struct.coef_addr_param.base_max_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.skip_base_max_dly :=struct.coef_addr_param.skip_base_max_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.count_max_dly :=struct.coef_addr_param.count_max_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.filt_sel_dly :=struct.coef_addr_param.filt_sel_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +filter_sel_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;

    struct.rfd_param:=(
        family          => reqs.family,
        implementation  => implementation,
        cnt             => struct.param.clk_per_chan,
        has_nd          => reqs.has_nd );

    
    --Latency Calculation
    struct.buffer_type:=2;
    struct.buffer_page_size:=2*reqs.num_channels;
    struct.latency:=struct.param.base_count
                    +struct.addr_cntrl_lat-- -1
                    +get_max(struct.data_addr_lat,struct.coef_addr_lat)
                    +struct.filt_arm_lat.cascaded
                    +struct.filt_arm_lat.tap
                    +select_integer(0,1+struct.accum_extra_dly,struct.accum_req)
                    +1 --for 2nd value generated
                    +struct.output_buffer_lat
                    +struct.output_rate
                    +reqs.reg_output;

    return struct;

  end;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_polyphase_sympair_interpolation.vhd

  function define_sympair_interpolation(reqs:t_reqs) return t_define_sympair_interpolation is
  ------------------------------------------------------------------------------

    variable struct: t_define_sympair_interpolation;
    --variable mem_param: t_tap_memory_add_casc;
    --variable memory_path_lat: t_lat_tap_memory_add_casc;
    constant srl16_mem_depth_thres: integer:=select_integer(32,64,
                                                            reqs.family=v5);
    constant dram_mem_depth_thres: integer:=select_integer(16,32,
                                                           reqs.family=v5);
    variable implementation:integer:=1;--structural
    variable  taps_per_phase,
              data_depth_unpacked,
              data_depth_packed,
              coef_depth_unpacked,
              coef_depth_packed,
              num_col,
              pass,
              filter_sel_dly,
              addr_dly
              :integer;
  begin
    --Defaults and direct copies
    struct.param.family:=reqs.family;
    struct.param.filter_type:=reqs.filter_type;
    struct.param.coef_reload:=reqs.coef_reload;
    struct.param.data_sign:=reqs.data_sign;
    struct.param.coef_sign:=reqs.coef_sign;
    struct.param.data_width:=reqs.data_width;
    struct.param.coef_width:=reqs.coef_width;
    struct.param.clk_per_samp:=reqs.clk_per_samp;
    struct.param.num_channels:=reqs.num_channels;
    struct.param.num_taps:=reqs.num_taps;
    struct.param.num_filts:=reqs.num_filts;
    struct.param.zero_packing_factor:=reqs.zero_packing_factor;

    struct.param.symmetry:=reqs.symmetry;
    struct.param.neg_symmetry:=reqs.neg_symmetry;
    struct.param.odd_symmetry:=select_integer(0,reqs.num_taps rem 2,struct.param.symmetry=1);
    
    --struct.dual_sym_structure:=0;
    struct.odd_and_even:=0;
    if (reqs.inter_rate rem 2 = 0 and struct.param.odd_symmetry=1) then
      --struct.dual_sym_structure:=1;
      struct.odd_and_even:=1;
    end if;

    struct.param.num_taps_calced:=(reqs.num_taps/2**struct.param.symmetry)
                                  +select_integer(0,(reqs.inter_rate/2)+1,struct.param.odd_symmetry=1 and struct.odd_and_even=0)
                                  +select_integer(0,1,reqs.num_taps rem 2**struct.param.symmetry > 0 and struct.odd_and_even=1);

    -- if struct.odd_and_even=1 then
--       struct.param.odd_symmetry:=0;
--     end if;

    --loop round here once checked depth of inter tap buffer depth
     pass:=0;
     while pass<2 loop
      --Calculate details of the filter-------------------------------------------
      --Number of macs and number of taps per mac
      if ( reqs.clk_per_samp/reqs.num_channels = 0 ) then
        report "FIR: not enough clock cycles per sample to process all channels, must have a minimum of 1 clk cycle per channel" severity error;
      elsif ( reqs.clk_per_samp rem reqs.num_channels > 0 ) then
        report "FIR: number of channels does not fit fully into clock cycles per sample, there will be unused clock cycles" severity note;
      end if;

      struct.param.clk_per_chan := reqs.clk_per_samp / reqs.num_channels;

      if (struct.param.clk_per_chan rem reqs.inter_rate > 0) then
        report "FIR: the available clock cycles is not evenly divisable by the interpolation rate, this means there will be unused clock cycles" severity note;
      end if;

      struct.param.base_count := struct.param.clk_per_chan / reqs.inter_rate;
      
      taps_per_phase:= struct.param.num_taps_calced/ reqs.inter_rate;
      if ( struct.param.num_taps_calced rem reqs.inter_rate > 0) then
        taps_per_phase:=taps_per_phase+1;
      end if;

      struct.param.num_macs := taps_per_phase/struct.param.base_count;

      if ( taps_per_phase rem struct.param.base_count > 0 ) then
      -- Add extra mac, this mac will need the filter coefficients padded out.
        struct.param.num_macs:=struct.param.num_macs+1;
      end if;

      --Adjust for unused cycles
      struct.param.base_count:=taps_per_phase/struct.param.num_macs;
      if (taps_per_phase rem struct.param.num_macs >0) then
        struct.param.base_count:=struct.param.base_count+1;
      end if;
      --In v2 made base count multi of interrate but in v3 base count is per phase so always do a calc for each phase

      if (struct.param.base_count*reqs.inter_rate)<struct.param.clk_per_chan then
        struct.shorter_px_time:=true;
      else
        struct.shorter_px_time:=false;
      end if;

      if pass=0 then
        struct.param.centre_mac:=struct.param.num_macs;
      end if;

      struct.param.base_coef_space := struct.param.base_count*reqs.inter_rate;

      -- Modify and update so get actual filter size
      struct.param.num_taps_calced:=struct.param.num_macs*struct.param.base_count*reqs.inter_rate;

      struct.param.inter_rate := reqs.inter_rate;
      struct.param.deci_rate  := 1;

      struct.param.no_data_mem:= 0;
      if (struct.param.base_count = 1) then
        struct.param.no_data_mem:= 1;
      end if;

      struct.output_rate:=struct.param.clk_per_chan/reqs.inter_rate;

      --Structural decisions------------------------------------------------------
      struct.param.single_mac:=0;
      --never a single mac structure as need accumulator to process phase results

      --Memory calculations-------------------------------------
      data_depth_unpacked:=2**log2roundup(struct.param.base_count)*(reqs.num_channels);
      data_depth_packed:=struct.param.base_count*reqs.num_channels;

      -- coef_depth_unpacked:=2**log2roundup(struct.param.base_coef_space)*struct.param.num_filts;
--       coef_depth_packed:=struct.param.base_coef_space*struct.param.num_filts;

      coef_depth_unpacked:=2**log2roundup( 2**log2roundup(struct.param.base_coef_space)*struct.param.num_filts)*2**struct.param.coef_reload;
      coef_depth_packed:=struct.param.base_coef_space*struct.param.num_filts*2**struct.param.coef_reload;

      struct.param:=memory_calcs( reqs,
                                  struct.param,
                                  data_depth_unpacked,
                                  data_depth_packed,
                                  coef_depth_unpacked,
                                  coef_depth_packed);

      --Symmetric wrap over calculations-------------------------
      --need to know latency of memory implmented
      struct.mem_param:=( family           =>reqs.family,
                          implementation   =>implementation,
                          data_mem_type    =>struct.param.data_mem_type,
                          coef_mem_type    =>struct.param.coef_mem_type,
                          data_comb        =>struct.param.data_combined,
                          data_coef_comb   =>struct.param.data_coef_combined,
                          no_data_mem      =>struct.param.no_data_mem,
                          coef_mem_depth  => struct.param.coef_mem_depth,
                          has_ce           =>reqs.has_ce,
                          coef_reload      =>reqs.coef_reload,
                          coef_reload_depth=>struct.param.base_coef_space,
                          symmetric        =>struct.param.symmetry );
  
      struct.memory_path_lat:=lat_tap_memory_add_casc(struct.mem_param);

      --local odd sym variable so can be disabled. When implementing the earily shift
      --for when even rate odd sym the actual effect is a even filter that is shifted earily
      struct.sym_calc_odd_sym:=struct.param.odd_symmetry;
      -- if struct.odd_and_even=1 and struct.param.data_mem_type=0 then
--         sym_calc_odd_sym:=0;
--       end if;

      struct.cyc_to_data_out:=struct.memory_path_lat.data+1;--plus one for the latch (min depth of 1 in delay)
      
      struct.cyc_to_write:=0;
      if (struct.mem_param.data_mem_type/=c_srl16) then -- =c_bram) then
        struct.cyc_to_write:=(struct.param.base_count); --inter_we_cycles
      end if;

      if struct.param.no_data_mem=0 then
        struct.num_cyc_read_earily:= select_integer(0,1,struct.cyc_to_write+struct.sym_calc_odd_sym-struct.cyc_to_data_out<0)
                                    +select_integer(0,1,struct.sym_calc_odd_sym=1);
        --add odd sym when calc if need earily read as when odd sym will read data earily this gives longer to get
        --data out of memory. So then check if still don't have enough time to get data out of memory
  
        struct.change_src:=select_integer(0,1,struct.num_cyc_read_earily>=(struct.param.base_count) );
  
        struct.extra_dly:=select_integer(
                            0,
                            select_integer(
                              (reqs.num_channels)-1,
                              (reqs.num_channels),
                              struct.cyc_to_data_out-struct.num_cyc_read_earily<=struct.cyc_to_write),
                              --test is moved past another WE pulse by reading earily
                            struct.num_cyc_read_earily-struct.sym_calc_odd_sym>0 and
                            struct.change_src=0);

        if struct.odd_and_even=1 and struct.param.data_mem_type=c_srl16 then
        --different extra dly values
          struct.extra_dly:=select_integer(
                            0,
                            select_integer(
                              reqs.num_channels,
                              reqs.num_channels+1,
                              struct.cyc_to_data_out-struct.num_cyc_read_earily<=struct.cyc_to_write),
                              --test is moved past another WE pulse by reading earily
                            struct.num_cyc_read_earily-struct.sym_calc_odd_sym>0 and
                            struct.change_src=0);
        end if;

        if (struct.change_src=1) then
          -- struct.extra_dly:=1;-- ((struct.param.base_count-struct.param.odd_symmetry)
--   --                           *reqs.num_channels)
--   --                           -select_integer(0,1,struct.mem_param.data_mem_type=0);
--           if reqs.num_channels=1 then
--             struct.extra_dly:=2;
--           end if;
--
--           if struct.odd_and_even=1 and struct.param.data_mem_type=c_srl16 then
--           --different extra dly values
--             struct.extra_dly:=1+1;
-- 
--             if reqs.num_channels=1 then
--               struct.extra_dly:=2+1;
--             end if;
--           end if;

          struct.extra_dly:=((struct.param.base_count-struct.sym_calc_odd_sym)
                             *reqs.num_channels)
                             ---select_integer(0,1,struct.mem_param.data_mem_type=0)
                             -reqs.num_channels; --this is what intertap delay will be, this is used on sym wrap buffer

          if struct.odd_and_even=1 and struct.param.data_mem_type=c_srl16 then
            struct.extra_dly:=struct.extra_dly+1;
          end if;

        end if;
      else

        if struct.odd_and_even=1 and (reqs.num_channels=1) then
          struct.sym_calc_odd_sym:=0;
        end if;

        struct.change_src:=0;
        struct.extra_dly:=0;
        struct.num_cyc_read_earily:=select_integer(0,1,struct.sym_calc_odd_sym=1);
        -- if struct.dual_sym_structure=1 and reqs.has_nd=0 then
--           struct.num_cyc_read_earily:=struct.num_cyc_read_earily+1;
--         end if;

      end if;

      struct.add_sup_dly:=struct.memory_path_lat.data;

      struct.first_tap_extra_dly:=0;

      if struct.param.data_mem_type=c_srl16 and struct.param.no_data_mem=0 then
        struct.data_dly_modifier:=-1;
      else
        struct.data_dly_modifier:=0;
      end if;

      if struct.param.no_data_mem=1 then
        if struct.memory_path_lat.coef>1 then
          --filt casc can direct emb_calc to compensate  for a difference of 1, any more
          --and need extra delay.
          struct.data_dly_modifier:=struct.data_dly_modifier+struct.memory_path_lat.coef-1;
          struct.add_sup_dly:=struct.add_sup_dly+struct.memory_path_lat.coef-1;
          struct.first_tap_extra_dly:=struct.memory_path_lat.coef-1;
        end if;
      end if;

      --Filter arm settings-------------------------------------
      if (reqs.col_mode=1) then
        -- if (struct.param.num_macs>reqs.col_1st_len) then
--           num_col:=1+(struct.param.num_macs-reqs.col_1st_len)/reqs.col_wrap_len;
--         else
--           num_col:=1;
--         end if;
        num_col:=calc_num_split_col(struct.param.num_macs,t_col_len'(
                                   0 => select_integer(reqs.col_wrap_len,reqs.col_1st_len,reqs.col_mode=1),
                                   others=>reqs.col_wrap_len));
      elsif (reqs.col_mode=2) then
        -- no generic for this mode yet
        num_col:=1;
      else
        num_col:=1;
      end if;

      struct.filt_arm:= (
          family          => reqs.family,
          implementation  => implementation,
          num_taps        => struct.param.num_macs,
          inter_we_cycles => struct.param.base_count*
                                select_integer(
                                  select_integer(
                                    1,
                                    reqs.inter_rate,
                                    struct.param.data_mem_type=c_srl16),
                                    --when bram can't increase processing time as will get an extra delay
                                  --1,--reqs.inter_rate-1,
                                  select_integer(
                                    1,
                                    reqs.inter_rate-1,
                                    struct.param.data_mem_type=c_srl16),
                                  struct.odd_and_even=1),
          inter_tap_delay => (struct.param.num_channels)+1,
          inter_sym_tap_delay =>select_integer(
                                  (struct.param.num_channels)+1,
                                  select_integer(
                                    (1)+1,
                                    (struct.param.num_channels)+1,
                                    struct.param.no_data_mem=1),
                                    --dual phase parallel structure is expecting the original depth
                                    --for the inter_sym_tap_delay
                                  struct.odd_and_even=1),
          --the plus 1 is because the filt_arm was block was changed to have the variable and I keep the expection of an extra 1
          --present so it is simpler to change all the other structures.
          symmetric       => struct.param.symmetry,
          pre_add_func    => select_integer(
                              c_preadd_addsub,--addsub
                              c_preadd_subadd,--subadd
                              reqs.neg_symmetry=1),
          data_mem_type   => struct.param.data_mem_type,
          coef_mem_type   => struct.param.coef_mem_type,
          data_comb       => struct.param.data_combined,
          data_coef_comb  => struct.param.data_coef_combined,
          data_cascade    => 0,
          no_data_mem     => struct.param.no_data_mem,
          coef_mem_depth  => struct.param.coef_mem_depth,
          p_src           => 0,--fabric
          data_sign       => reqs.data_sign,
          coef_sign       => c_signed,--always signed with symmetric pairs  reqs.coef_sign,
          has_ce          => reqs.has_ce,
          --has_nd          => reqs.has_nd,
          para_casc_we_src=> 1,--always need write pulse on data casc
          reload          => reqs.coef_reload,
          reload_strms    => select_integer(1,2,struct.param.coef_mem_type=c_bram),
          reload_depth    => struct.param.base_coef_space,
          output_index    => (
                            p_P_OUT       => struct.param.num_macs+1,
                            p_PC_OUT      => struct.param.num_macs+1,
                            p_D_OUT       => struct.param.num_macs,
                            p_D_SYM_OUT   => struct.param.num_macs,
                            p_C_OUT       => struct.param.num_macs,
                            p_WE_OUT      => struct.param.num_macs,-- +1,
                            p_WE_SYM_OUT  => struct.param.num_macs+(struct.cyc_to_data_out-1)-struct.num_cyc_read_earily,
                            p_ADDSUB_OUT  => struct.param.num_macs+1,
                            p_ADDSUP_OUT  => struct.param.num_macs+1,
                            p_WE_SYM_OUT_2    => struct.param.num_macs ),
          output_src      => (
                            p_P_OUT       => 0,
                            p_PC_OUT       => 0,
                            p_D_OUT       => select_integer(1,0,struct.change_src=1),
                            p_D_SYM_OUT   => 0,
                            p_C_OUT       => 0,
                            p_WE_OUT      => 0,
                            p_WE_SYM_OUT  => 0,
                            p_ADDSUB_OUT  => 0,
                            p_ADDSUP_OUT  => 0,
                            p_WE_SYM_OUT_2    => 0 ),
          num_independant_col => select_integer(1,num_col,reqs.col_mode=2),
          num_split_col       => select_integer(1,num_col,reqs.col_mode=1),
          inter_split_col_dly => reqs.col_pipe_len,
          col_len             => ( 0 => select_integer(reqs.col_wrap_len,reqs.col_1st_len,reqs.col_mode=1),
                                   others=>reqs.col_wrap_len),
          dynamic_opcode  => select_integer(0,1,struct.odd_and_even=1 and reqs.inter_rate=2 and struct.param.num_macs=1),
          --sym_para_struct => select_integer(0,2,struct.odd_and_even=1 and struct.param.no_data_mem=1 and reqs.num_channels>1),
          sym_para_struct => select_integer(0,2,struct.odd_and_even=1 and 
                                                 ( (struct.param.no_data_mem=1 and  reqs.num_channels>1) or
                                                   (struct.param.no_data_mem=0) ) ),
          resource_opt    => reqs.resource_opt,
          data_width      => reqs.data_width,
          datapath_mem_type => reqs.datapath_mem_type,
          odd_symmetry    => struct.param.odd_symmetry  );

      struct.filt_arm_lat:=lat_filt_arm_add_casc(struct.filt_arm);

      if (  struct.param.symmetry=1 and
            pass=0 and
            struct.filt_arm_lat.sym_inter_buff_depth>1089 and
            reqs.data_mem_type=c_mem_forced_dist ) then

        --disable symmetry as srl16 will be forced for the delay and its is not able to support >1089
        struct.param.symmetry:=0;
        struct.param.neg_symmetry:=0;
        struct.param.odd_symmetry:=0;
        struct.param.num_taps_calced:=reqs.num_taps;
        pass:=1;
      else
        pass:=2;
      end if;

    end loop;

    --Accumulator settings---------------------------------------
    struct.accum:=(
        family         => reqs.family,
        implementation => implementation,
        pre_add        => 0,
        pre_add_func   => c_preadd_add,
        pre_add_ipreg  => 0,
        pre_add_midreg => 0,
        a_delay        => 0,--1,
        b_delay        => 0,--1,
        a_src          => 0,--fabric
        --c_src          => 1, --alway from another DSP
        a_sign         => c_signed,--reqs.data_sign,
        b_sign         => c_signed,--reqs.coef_sign,--not used in single rate
        d_sign         => c_signed,--reqs.data_sign,
        reg_opcode     => 1,
        implement_extra_b_dly => 1 );

    struct.accum_details:=dtls_emb_calc(struct.accum);

    struct.accum_lat:=1+select_integer(
                          0,
                          1,
                          (reqs.family=v4 and reqs.output_width+1>35 and not(struct.odd_and_even=1 and reqs.inter_rate=2) ) or
                          (reqs.family=s3ax and struct.param.no_data_mem=1 and (reqs.inter_rate rem 2 > 0 or (struct.odd_and_even=1 and reqs.inter_rate/=2)))  );

    struct.has_accum:=true;
    if struct.odd_and_even=1 and reqs.inter_rate=2 and struct.param.num_macs=1 then
      struct.has_accum:=false;
    end if;

    struct.use_dsp_reg_as_storage:=true;
    if reqs.resource_opt=c_speed and reqs.has_ce=1 then
      struct.use_dsp_reg_as_storage:=false;
    end if;
    --Output buffer ram settings---------------------------------
    struct.output_buffer_depth:=2*reqs.num_channels*reqs.inter_rate;

    struct.output_buffer:=(
      family              => reqs.family,
      implementation      => implementation,
      mem_type            => select_integer(
                              c_dram,--dram
                              c_bram,--bram
                              (struct.output_buffer_depth>dram_mem_depth_thres and reqs.opbuff_mem_type/=c_mem_forced_dist) or
                              reqs.opbuff_mem_type=c_mem_forced_bram),
      write_mode          => 0,--read first
      has_ce              => reqs.has_ce,
      use_mif             => 0 );

    struct.output_rate_counter:=(
        cnt1_max_val    => struct.output_rate,
        cnt2_max_val    => 1,
        cnt3_max_val    => 1,
        cnt2_max_qual   => 1,
        family          => reqs.family,
        implementation  => implementation );

    struct.output_buffer_lat:=lat_ram(struct.output_buffer,2);
    
    struct.has_output_buffer:=true;
    
    if struct.odd_and_even=1 and reqs.inter_rate=2 and reqs.num_channels=1 and not struct.shorter_px_time then
      struct.has_output_buffer:=false;
    end if;

    --Address generator block settings---------------------------
    struct.base_chan_phase_param:=(
        cnt1_max_val    => struct.param.base_count,
        cnt2_max_val    => reqs.inter_rate,
        cnt3_max_val    => reqs.num_channels,
        cnt2_max_qual   => 1,
        family          => reqs.family,
        implementation  => implementation );

    struct.data_addr_param:=(
        family          => reqs.family,
        implementation  => implementation,
        mem_type        => struct.param.data_mem_type,
        base_cnt        => struct.param.base_count,
        block_cnt       => reqs.num_channels,
        symmetric       => struct.param.symmetry,
        addr_width      => get_max(1,log2roundup(struct.param.data_mem_depth)),
        sym_addr_width  => get_max(1,log2roundup(struct.param.datasym_mem_depth+struct.param.datasym_mem_offset)),
        combined        => struct.param.data_combined,
        addr_packed     => struct.param.data_packed,
        srl16_sequence  => 0,--uses standard address sequence
        en_dly          => select_integer(0,1,(reqs.has_nd=1 and struct.param.no_data_mem=0) or
                                                          struct.shorter_px_time),
        block_end_dly   => 0,
        last_block_dly  => 0,
        write_phase_dly => 0,
        sub_block_end_dly => 0,
        use_sym_cntrl   => select_integer(0,1,struct.odd_and_even=1 and struct.param.data_mem_type/=c_srl16 and reqs.num_channels=1),
        resource_opt => reqs.resource_opt  );

    struct.data_addr_lat:=lat_data_address(struct.data_addr_param);
    
    struct.data_addr_odd_phase_param:=struct.data_addr_param;-- (
--         family          => reqs.family,
--         implementation  => implementation,
--         mem_type        => struct.param.data_mem_type,
--         base_cnt        => struct.param.base_count,
--         block_cnt       => reqs.num_channels,
--         symmetric       => struct.param.symmetry,
--         addr_width      => get_max(1,log2roundup(struct.param.data_mem_depth)),
--         sym_addr_width  => get_max(1,log2roundup(struct.param.datasym_mem_depth+struct.param.datasym_mem_offset)),
--         combined        => struct.param.data_combined,
--         addr_packed     => struct.param.data_packed,
--         srl16_sequence  => 0,--uses standard address sequence
--         en_dly          => select_integer(0,1,(reqs.has_nd=1 and struct.param.no_data_mem=0) or
--                                                           struct.shorter_px_time),
--         block_end_dly   => 0,
--         last_block_dly  => 0,
--         write_phase_dly => 0,
--         sub_block_end_dly => 0,
--         use_sym_cntrl   => 1 );
    struct.data_addr_odd_phase_param.use_sym_cntrl:=1;

    struct.data_addr_odd_phase_lat:=lat_data_address(struct.data_addr_odd_phase_param);

    if struct.odd_and_even=1 and reqs.num_channels>1 then
      --increase latency to generate data addr as there will be a mux or a constant address
      struct.data_addr_lat:=struct.data_addr_lat+1;
      struct.data_addr_odd_phase_lat:=struct.data_addr_odd_phase_lat+1;
    end if;

    struct.data_addr_lat:=get_max(0,struct.data_addr_lat-1);
    --sub 1 as only interested in the first location of the count, 
    --this occurs with 0 latency when latency is 1

    struct.coef_addr_param:=(
        family          => reqs.family,
        implementation  => implementation,
        base_cnt        => struct.param.base_count*reqs.inter_rate,
        block_cnt       => 1,--reqs.inter_rate,
        addr_packed     => struct.param.coef_packed,
        addr_width      => get_max(1,log2roundup( struct.param.coef_mem_depth
                                                  +struct.param.coef_mem_offset )),
        num_filters     => reqs.num_filts,--*select_integer(1,2,struct.param.coef_reload=1),
        multi_page_reload => struct.param.coef_reload,
        offset          => struct.param.coef_mem_offset,
        has_ce          => reqs.has_ce,
        use_count_src   => 0,
        en_dly            => select_integer(0,1,(reqs.has_nd=1 and struct.param.no_data_mem=0) or
                                                            struct.shorter_px_time),
        base_max_dly      => 0,
        skip_base_max_dly => 0,
        count_max_dly     => 0,
        filt_sel_dly      => 0,
        resource_opt => reqs.resource_opt);-- select_integer(1,2,(reqs.has_nd=1 and struct.param.no_data_mem=0) or
--                                                             struct.shorter_px_time));

    struct.coef_addr_lat:=lat_coef_address(struct.coef_addr_param);

    struct.coef_addr_lat:=get_max(0,struct.coef_addr_lat-1);

    struct.reload_cntrl_param:=(
      family          => reqs.family,
      implementation  => implementation,
      reload_base_cnt => struct.param.base_count*reqs.inter_rate,
      coef_addr_packed=> struct.param.coef_packed,
      num_filts       => reqs.num_filts,
      coef_mem_depth  => struct.param.coef_mem_depth,
      num_macs        => struct.param.num_macs,

      has_ce          => reqs.has_ce,
      coef_width      => reqs.coef_width,
      filt_sel_width  => reqs.filt_sel_width,
      filt_sel_width_out => select_integer(1,reqs.filt_sel_width+1, reqs.num_filts>1),
      reload_width    => get_max(1,log2roundup( struct.param.coef_mem_depth)),
      resource_opt => reqs.resource_opt,
      has_hb       => 0,
      latch_filt_sel => 1,
      coef_mem_lat => struct.memory_path_lat.coef,
      num_reload_strms => select_integer(1,2,struct.param.coef_mem_type=c_bram) );

    struct.reload_cntrl_param_lat:=lat_coef_reload_cntrl(struct.reload_cntrl_param);

    struct.addr_cntrl_lat:=select_integer(
                                1,
                                2,
                                (reqs.has_nd=1 and struct.param.no_data_mem=0) or
                                struct.shorter_px_time);

    if reqs.coef_reload=1 then
      if struct.reload_cntrl_param_lat.filt_sel_lat-1 < struct.addr_cntrl_lat then
        filter_sel_dly:=struct.addr_cntrl_lat-(struct.reload_cntrl_param_lat.filt_sel_lat-1);
        addr_dly:=0;
      else
        filter_sel_dly:=0;
        addr_dly:=(struct.reload_cntrl_param_lat.filt_sel_lat-1)-struct.addr_cntrl_lat;
        struct.addr_cntrl_lat:=struct.addr_cntrl_lat+addr_dly;
      end if;
    else
      addr_dly:=0;
      filter_sel_dly:=struct.addr_cntrl_lat;
    end if;

    --Check delays for latching signal for sym wrap over-----
    struct.we_sym_dly:=struct.addr_cntrl_lat
                       +struct.first_tap_extra_dly
                       +get_max(struct.data_addr_lat,struct.coef_addr_lat)
                       -1;

    if struct.filt_arm.output_index(p_WE_SYM_OUT)<=0 and struct.param.symmetry=1 then
      --will not be able to get latching signal for wrap over as not enough mac in filt arm
      if struct.we_sym_dly-1+struct.filt_arm.output_index(p_WE_SYM_OUT)<0 then
        --not enough latency to read earily from generation delay so add latency to addr gen.
        addr_dly:=addr_dly+abs(struct.we_sym_dly-1+struct.filt_arm.output_index(p_WE_SYM_OUT));
        filter_sel_dly:=filter_sel_dly+abs(struct.we_sym_dly-1+struct.filt_arm.output_index(p_WE_SYM_OUT));
        struct.addr_cntrl_lat:=struct.addr_cntrl_lat+abs(struct.we_sym_dly-1+struct.filt_arm.output_index(p_WE_SYM_OUT));
        struct.we_sym_dly:=struct.addr_cntrl_lat
                          +struct.first_tap_extra_dly
                          +get_max(struct.data_addr_lat,struct.coef_addr_lat)
                          -1;
      end if;
    end if;

    --Balance delays
    struct.data_addr_param.en_dly         :=struct.data_addr_param.en_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat)
                                            +addr_dly;
    struct.data_addr_param.block_end_dly  :=struct.data_addr_param.block_end_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat)
                                            +addr_dly;
    struct.data_addr_param.last_block_dly :=struct.data_addr_param.last_block_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat)
                                            +addr_dly;

    --had forgot to apply the same delays to the data_addr odd phase generator.
    struct.data_addr_odd_phase_param:=struct.data_addr_param;
    struct.data_addr_odd_phase_param.use_sym_cntrl:=1;

    struct.coef_addr_param.en_dly         :=struct.coef_addr_param.en_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.base_max_dly  :=struct.coef_addr_param.base_max_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.skip_base_max_dly :=struct.coef_addr_param.skip_base_max_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.count_max_dly :=struct.coef_addr_param.count_max_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.filt_sel_dly :=struct.coef_addr_param.filt_sel_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +filter_sel_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;

    struct.rfd_param:=(
        family          => reqs.family,
        implementation  => implementation,
        cnt             => struct.param.clk_per_chan,
        has_nd          => reqs.has_nd );

    
    --Latency Calculation
    struct.buffer_type:=select_integer(0,2,struct.has_output_buffer);
    struct.buffer_page_size:=reqs.inter_rate*reqs.num_channels;
    struct.latency:=struct.param.base_count*select_integer(struct.param.inter_rate,1,not struct.has_output_buffer)
                                                            --this case is currenlty only when there is no op buffer
                    +struct.addr_cntrl_lat---1
                    +get_max(struct.data_addr_lat,struct.coef_addr_lat)
                    +struct.first_tap_extra_dly
                    +struct.filt_arm_lat.cascaded
                    +struct.filt_arm_lat.tap
                    +select_integer(0,struct.accum_lat,struct.has_accum)--select_integer(1,struct.accum_lat,struct.has_accum)
                    +select_integer(0,1
                                      --1 because of the way data is writen, always in blocks of 2
                                      +select_integer(
                                          struct.output_buffer_lat+1,
                                          struct.output_buffer_lat,
                                          --not writen in block of 2 in this structure
                                          struct.odd_and_even=1 and reqs.inter_rate=2)
                                      --plus one on buffer that generates latch_op
                                      +struct.output_rate,
                                      struct.has_output_buffer)
                    +reqs.reg_output;

    return struct;

  end;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_polyphase_pq_interpolation.vhd

  function define_pq_interpolation(reqs:t_reqs) return t_define_pq_interpolation is
  ------------------------------------------------------------------------------

    variable struct: t_define_pq_interpolation;
    --variable mem_param: t_tap_memory_add_casc;
    --variable memory_path_lat: t_lat_tap_memory_add_casc;
    constant srl16_mem_depth_thres: integer:=select_integer(32,64,
                                                            reqs.family=v5);
    constant dram_mem_depth_thres: integer:=select_integer(16,32,
                                                           reqs.family=v5);
    variable implementation:integer:=1;--structural
    variable  taps_per_phase,
              data_depth_unpacked,
              data_depth_packed,
              coef_depth_unpacked,
              coef_depth_packed,
              num_col,
              pass,
              data_addr_dly,
              coef_addr_dly
              --ram_matching_dly
              :integer;
  begin
    --Defaults and direct copies
    struct.param.family:=reqs.family;
    struct.param.filter_type:=reqs.filter_type;
    struct.param.coef_reload:=reqs.coef_reload;
    struct.param.data_sign:=reqs.data_sign;
    struct.param.coef_sign:=reqs.coef_sign;
    struct.param.data_width:=reqs.data_width;
    struct.param.coef_width:=reqs.coef_width;
    struct.param.clk_per_samp:=reqs.clk_per_samp;
    struct.param.num_channels:=reqs.num_channels;
    struct.param.num_taps:=reqs.num_taps;
    struct.param.num_filts:=reqs.num_filts;
    struct.param.zero_packing_factor:=reqs.zero_packing_factor;
    
    struct.param.symmetry:=0;
    struct.param.neg_symmetry:=0;
    struct.param.odd_symmetry:=0;
    struct.param.num_taps_calced:=(reqs.num_taps/2**struct.param.symmetry)+struct.param.odd_symmetry;

    --Calculate details of the filter-------------------------------------------
    --Number of macs and number of taps per mac
    if ( reqs.clk_per_samp/reqs.num_channels = 0 ) then
      report "FIR: not enough clock cycles per sample to process all channels, must have a minimum of 1 clk cycle per channel" severity error;
    elsif ( reqs.clk_per_samp rem reqs.num_channels > 0 ) then
      report "FIR: number of channels does not fit fully into clock cycles per sample, there will be unused clock cycles" severity note;
    end if;

    struct.param.clk_per_chan := reqs.clk_per_samp / reqs.num_channels;

    if (struct.param.clk_per_chan rem reqs.inter_rate > 0) then
      report "FIR: the available clock cycles is not evenly divisable by the interpolation rate, this means there will be unused clock cycles" severity note;
    end if;

    struct.param.base_count := (struct.param.clk_per_chan * reqs.deci_rate)/ reqs.inter_rate;

    --Below gives constant output rate only
    --struct.param.base_count := (struct.param.clk_per_chan / reqs.inter_rate)*reqs.deci_rate;

    taps_per_phase:= struct.param.num_taps_calced/ reqs.inter_rate;
    if ( struct.param.num_taps_calced rem reqs.inter_rate > 0) then
      taps_per_phase:=taps_per_phase+1;
    end if;

    struct.param.num_macs := taps_per_phase/struct.param.base_count;

    if ( taps_per_phase rem struct.param.base_count > 0 ) then
    -- Add extra mac, this mac will need the filter coefficients padded out.
      struct.param.num_macs:=struct.param.num_macs+1;
    end if;

    struct.base_count_op_rate:=struct.param.base_count;

    --Adjust for unused cycles
    struct.param.base_count:=taps_per_phase/struct.param.num_macs;
    if (taps_per_phase rem struct.param.num_macs >0) then
      struct.param.base_count:=struct.param.base_count+1;
    end if;

    struct.shorter_px_time:=false;
    if struct.base_count_op_rate>struct.param.base_count then
      struct.shorter_px_time:=true;
    end if;

    --if pass=0 then
      struct.param.centre_mac:=struct.param.num_macs;
    --end if;

    struct.param.base_data_space := struct.param.base_count;
    struct.param.base_coef_space := struct.param.base_count*reqs.inter_rate;

    -- Modify and update so get actual filter size
    struct.param.num_taps_calced:=struct.param.num_macs*struct.param.base_count*reqs.inter_rate;

    struct.param.inter_rate := reqs.inter_rate;
    struct.param.deci_rate  := reqs.deci_rate;

    struct.param.no_data_mem:= 0;
    if (struct.param.base_count = 1 and reqs.num_channels=1) then
      struct.param.no_data_mem:= 1;
    end if;

    --Structural decisions------------------------------------------------------
    struct.param.single_mac:=0;
    if struct.param.num_macs=1 then
      struct.param.single_mac:=1;
    end if;

    --Memory calculations-------------------------------------
    data_depth_unpacked:=2**log2roundup(struct.param.base_data_space)*reqs.num_channels;
    data_depth_packed:=struct.param.base_data_space*reqs.num_channels;

    -- coef_depth_unpacked:=2**log2roundup(struct.param.base_coef_space)*struct.param.num_filts;
--       coef_depth_packed:=struct.param.base_coef_space*struct.param.num_filts;

    coef_depth_unpacked:=2**log2roundup( 2**log2roundup(struct.param.base_coef_space)*struct.param.num_filts)*2**struct.param.coef_reload;
    coef_depth_packed:=struct.param.base_coef_space*struct.param.num_filts*2**struct.param.coef_reload;

    struct.param:=memory_calcs( reqs,
                                struct.param,
                                data_depth_unpacked,
                                data_depth_packed,
                                coef_depth_unpacked,
                                coef_depth_packed);

    --Symmetric wrap over calculations-------------------------
    --need to know latency of memory implmented
    struct.mem_param:=( family           =>reqs.family,
                        implementation   =>implementation,
                        data_mem_type    =>struct.param.data_mem_type,
                        coef_mem_type    =>struct.param.coef_mem_type,
                        data_comb        =>struct.param.data_combined,
                        data_coef_comb   =>struct.param.data_coef_combined,
                        no_data_mem      =>struct.param.no_data_mem,
                        coef_mem_depth  => struct.param.coef_mem_depth,
                        has_ce           =>reqs.has_ce,
                        coef_reload      =>reqs.coef_reload,
                        coef_reload_depth=>struct.param.base_coef_space,
                        symmetric        =>struct.param.symmetry );

    struct.memory_path_lat:=lat_tap_memory_add_casc(struct.mem_param);

    struct.add_sup_dly:=struct.memory_path_lat.data;

    struct.first_tap_extra_dly:=0;

    if struct.param.data_mem_type=c_srl16 and struct.param.no_data_mem=0 then
      struct.data_dly_modifier:=-1;
    else
      struct.data_dly_modifier:=0;
    end if;

    if struct.param.no_data_mem=1 then
      if struct.memory_path_lat.coef>1 then
        --filt casc can direct emb_calc to compensate  for a difference of 1, any more
        --and need extra delay.
        struct.data_dly_modifier:=struct.data_dly_modifier+struct.memory_path_lat.coef-1;
        struct.add_sup_dly:=struct.add_sup_dly+struct.memory_path_lat.coef-1;
        struct.first_tap_extra_dly:=struct.memory_path_lat.coef-1;
      end if;
    end if;

    --Filter arm settings-------------------------------------
    if (reqs.col_mode=1) then
      -- if (struct.param.num_macs>reqs.col_1st_len) then
--         num_col:=1+(struct.param.num_macs-reqs.col_1st_len)/reqs.col_wrap_len;
--       else
--         num_col:=1;
--       end if;  
      num_col:=calc_num_split_col(struct.param.num_macs,t_col_len'(
                                   0 => select_integer(reqs.col_wrap_len,reqs.col_1st_len,reqs.col_mode=1),
                                   others=>reqs.col_wrap_len));
    elsif (reqs.col_mode=2) then
      -- no generic for this mode yet
      num_col:=1;
    else
      num_col:=1;
    end if;

    struct.filt_arm:= (
        family          => reqs.family,
        implementation  => implementation,
        num_taps        => struct.param.num_macs,
        inter_we_cycles => struct.param.base_count,
        inter_tap_delay => struct.param.num_channels+1,
        inter_sym_tap_delay => 0,
        --no symmetric support in this structure
        symmetric       => struct.param.symmetry,
        pre_add_func    => select_integer(c_preadd_add,c_preadd_sub,struct.param.neg_symmetry=1),
        data_mem_type   => struct.param.data_mem_type,
        coef_mem_type   => struct.param.coef_mem_type,
        data_comb       => struct.param.data_combined,
        data_coef_comb  => struct.param.data_coef_combined,
        data_cascade    => 0,
        no_data_mem     => struct.param.no_data_mem,
        coef_mem_depth  => struct.param.coef_mem_depth,
        p_src           => 0,--fabric
        data_sign       => reqs.data_sign,
        coef_sign       => reqs.coef_sign,
        has_ce          => reqs.has_ce,
        --has_nd          => reqs.has_nd,
        reload          => reqs.coef_reload,
        reload_strms    => select_integer(1,2,struct.param.coef_mem_type=c_bram),
        reload_depth    => struct.param.base_coef_space,
        output_index    => (
                          p_P_OUT       => struct.param.num_macs+1,
                          p_PC_OUT      => struct.param.num_macs+1,
                          p_D_OUT       => struct.param.num_macs,-- -struct.change_src,
                          p_D_SYM_OUT   => struct.param.num_macs,
                          p_C_OUT       => struct.param.num_macs,
                          p_WE_OUT      => struct.param.num_macs,-- +1,
                          p_WE_SYM_OUT  => struct.param.num_macs,--+(struct.cyc_to_data_out-1)-struct.num_cyc_read_earily,
                          p_ADDSUB_OUT  => struct.param.num_macs+1,
                          p_ADDSUP_OUT  => struct.param.num_macs+1,
                          p_WE_SYM_OUT_2    => struct.param.num_macs ),
        output_src      => (
                          p_P_OUT       => 0,
                          p_PC_OUT       => 0,
                          p_D_OUT       => 0,--select_integer(1,0,struct.change_src=1),
                          p_D_SYM_OUT   => 0,
                          p_WE_OUT      => 0,
                          p_WE_SYM_OUT  => 0,
                          p_C_OUT       => 0,
                          p_ADDSUB_OUT  => 0,
                          p_ADDSUP_OUT  => 0,
                          p_WE_SYM_OUT_2    => 0 ),
        num_independant_col => select_integer(1,num_col,reqs.col_mode=2),
        num_split_col       => select_integer(1,num_col,reqs.col_mode=1),
        inter_split_col_dly => reqs.col_pipe_len,
        col_len             => ( 0 => select_integer(reqs.col_wrap_len,reqs.col_1st_len,reqs.col_mode=1),
                                 others=>reqs.col_wrap_len),
        dynamic_opcode  => select_integer(0,1,struct.param.num_macs=1),
        sym_para_struct => reqs.has_nd,
        para_casc_we_src=> 1,--reqs.has_nd,
        resource_opt    => reqs.resource_opt,
        data_width      => reqs.data_width,
        datapath_mem_type => reqs.datapath_mem_type,
        odd_symmetry    => struct.param.odd_symmetry  );

    struct.filt_arm_lat:=lat_filt_arm_add_casc(struct.filt_arm);

    --Accumulator settings---------------------------------------
    struct.accum:=(
        family         => reqs.family,
        implementation => implementation,
        pre_add        => 0,
        pre_add_func   => c_preadd_add,
        pre_add_ipreg  => 0,
        pre_add_midreg => 0,
        a_delay        => 1,
        b_delay        => 1,
        a_src          => 0,--fabric
        --c_src          => 1, --alway from another DSP
        a_sign         => reqs.data_sign,
        b_sign         => reqs.coef_sign,--not used in single rate
        d_sign         => reqs.data_sign,
        reg_opcode     => 1,
        implement_extra_b_dly => 1 );

    struct.accum_lat:=dtls_emb_calc(struct.accum);

    struct.accum_req:=true;

    if (struct.param.base_count=1 and struct.param.num_macs>1) or
       (struct.param.num_macs=1) then
      struct.accum_req:=false;
    end if;

    --Input buffer settings--------------------------------------
    struct.has_input_buffer:=false;
    struct.input_buffer_lat:=0;
    struct.input_buffer_depth:=2*reqs.num_channels;
    struct.input_buffer_cntrl_dly:=0;

    if struct.shorter_px_time then
      struct.input_buffer_cntrl_dly:=1;
    end if;

    struct.input_buffer:=(
      family              => reqs.family,
      implementation      => implementation,
      mem_type            => select_integer(
                              c_dram,--dram
                              c_bram,--bram
                              (struct.input_buffer_depth>dram_mem_depth_thres and reqs.ipbuff_mem_type/=c_mem_forced_dist) or
                              reqs.ipbuff_mem_type=c_mem_forced_bram),
      write_mode          => 0,--read first
      has_ce              => reqs.has_ce,
      use_mif             => 0 );

    struct.input_buffer_in_addr:=(
      family => reqs.family,
      implementation => implementation,
      addr_width => get_max(1,log2roundup(struct.input_buffer_depth)),
      page_size => reqs.num_channels,
      num_enables => 2 );

    if reqs.num_channels>1 then
      struct.has_input_buffer:=true;
      struct.input_buffer_lat:=lat_ram(struct.input_buffer,2);

      if struct.shorter_px_time then
        struct.input_buffer_lat:=struct.input_buffer_lat+1;
        --need to qualify chan_max in this case to push out input buffer latency by a cycle
        --will it tolerate a delay on starting the read, ie will the addresses over lap,
        --maybe prob in fully parallel.
      end if;

    end if;
    
    --
    struct.no_addr_latch:=0;
    if (struct.param.base_count=1 and struct.param.data_mem_type=c_srl16 and reqs.num_channels>1) then
    --in this case shouldn't need to latch address to get last data location as always 0
      struct.no_addr_latch:=1;
    end if;

    --Address generator block settings---------------------------
    struct.base_chan_param:=(
        cnt1_max_val    => select_integer(
                              struct.param.base_count,
                              struct.base_count_op_rate,
                              struct.shorter_px_time),
        cnt2_max_val    => reqs.num_channels,
        cnt3_max_val    => 1,--reqs.inter_rate,
        cnt2_max_qual   => select_integer(1,0,struct.shorter_px_time),
        family          => reqs.family,
        implementation  => implementation );
        
    struct.inter_param :=(
        family          => reqs.family,
        implementation  => implementation,
        base_val        => reqs.inter_rate,
        step_val        => reqs.deci_rate,
        latch_cnt_wrap  => 0,-- select_integer(0,1,
--                              struct.param.base_count=1),
        has_clr         => 0,
        has_init        => 0,
        init_val        => 0,
        clr_point       => 0 );
        
    struct.data_addr_param:=(
        family          => reqs.family,
        implementation  => implementation,
        mem_type        => struct.param.data_mem_type,
        base_cnt        => struct.param.base_count,
        block_cnt       => reqs.num_channels,
        symmetric       => struct.param.symmetry,
        addr_width      => get_max(1,log2roundup(struct.param.data_mem_depth)),
        sym_addr_width  => get_max(1,log2roundup(struct.param.datasym_mem_depth+struct.param.datasym_mem_offset)),
        combined        => struct.param.data_combined,
        addr_packed     => struct.param.data_packed,
        srl16_sequence  => 1,--use the repeat address structure
        en_dly          => select_integer(0,1,(reqs.has_nd=1 and struct.param.no_data_mem=0 and struct.no_addr_latch=0) or
                                                struct.shorter_px_time), --delay of one due to the generation of addr_en
        block_end_dly   => select_integer(0,1, struct.param.base_count=1 and reqs.num_channels>1 and
                                                ((reqs.has_nd=1 and struct.param.no_data_mem=0 and struct.no_addr_latch=0) or
                                                struct.shorter_px_time) ),--0,
        last_block_dly  => 0,
        write_phase_dly => 0,
        sub_block_end_dly => 0,
        use_sym_cntrl   => 0,
        resource_opt    => reqs.resource_opt );

    struct.data_addr_lat:=lat_data_address(struct.data_addr_param);

    struct.data_addr_lat:=get_max(0,struct.data_addr_lat-1);
    --sub 1 as only interested in the first location of the count, 
    --this occurs with 0 latency when latency is 1

    struct.coef_addr_param:=(
        family          => reqs.family,
        implementation  => implementation,
        base_cnt        => struct.param.base_count,
        block_cnt       => reqs.inter_rate,
        addr_packed     => struct.param.coef_packed,
        addr_width      => get_max(1,log2roundup( struct.param.coef_mem_depth
                                                  +struct.param.coef_mem_offset )),
        num_filters     => reqs.num_filts,--*select_integer(1,2,struct.param.coef_reload=1),
        multi_page_reload => struct.param.coef_reload,
        offset          => struct.param.coef_mem_offset,
        has_ce          => reqs.has_ce,
        use_count_src   => 0,
        en_dly            => select_integer(0,1,(reqs.has_nd=1 and struct.param.no_data_mem=0 and struct.no_addr_latch=0) or
                                                struct.shorter_px_time),
        base_max_dly      => select_integer(0,1, struct.param.base_count=1 and reqs.num_channels>1 and
                                                ((reqs.has_nd=1 and struct.param.no_data_mem=0 and struct.no_addr_latch=0) or
                                                struct.shorter_px_time) ),--0,
        skip_base_max_dly => 0,
        count_max_dly     => 0,
        filt_sel_dly      => 0,
        resource_opt => reqs.resource_opt);--select_integer(0,2,reqs.has_nd=1));

    struct.coef_addr_lat:=lat_coef_address(struct.coef_addr_param);
    
    struct.coef_addr_lat:=get_max(0,struct.coef_addr_lat-1);

    struct.reload_cntrl_param:=(
      family          => reqs.family,
      implementation  => implementation,
      reload_base_cnt => (struct.param.base_count*struct.param.inter_rate),
      coef_addr_packed=> struct.param.coef_packed,
      num_filts       => reqs.num_filts,
      coef_mem_depth  => struct.param.coef_mem_depth,
      num_macs        => struct.param.num_macs,

      has_ce          => reqs.has_ce,
      coef_width      => reqs.coef_width,
      filt_sel_width  => reqs.filt_sel_width,
      filt_sel_width_out => select_integer(1,reqs.filt_sel_width+1, reqs.num_filts>1),
      reload_width    => get_max(1,log2roundup( struct.param.coef_mem_depth)),
      resource_opt => reqs.resource_opt,
      has_hb       => 0,
      latch_filt_sel => 0,
      coef_mem_lat => struct.memory_path_lat.coef,
      num_reload_strms => select_integer(1,2,struct.param.coef_mem_type=c_bram) );

    struct.reload_cntrl_param_lat:=lat_coef_reload_cntrl(struct.reload_cntrl_param);

    struct.pipeline_addr_en:=0;
    if (reqs.has_nd=1 and struct.param.no_data_mem=0 and struct.no_addr_latch=0) and not struct.shorter_px_time then
      struct.pipeline_addr_en:=1;
    end if;

    struct.addr_cntrl_lat:=select_integer(
                                1,
                                2+struct.pipeline_addr_en,
                                (reqs.has_nd=1 and struct.param.no_data_mem=0 and struct.no_addr_latch=0) or
                                struct.shorter_px_time);

    --Balance delays

    if struct.has_input_buffer then
      if struct.input_buffer_lat>(struct.addr_cntrl_lat) then
        struct.data_dly:=0;
        struct.filt_dly:=0;
        struct.addr_dly:=struct.input_buffer_lat-(struct.addr_cntrl_lat);
      else
        struct.data_dly:=(struct.addr_cntrl_lat)-struct.input_buffer_lat;
        struct.filt_dly:=(struct.addr_cntrl_lat)-struct.input_buffer_lat;
        struct.addr_dly:=0;
      end if;
    else
      struct.filt_dly:=struct.addr_cntrl_lat;--get_max(0,struct.addr_cntrl_lat-1);
      struct.data_dly:=struct.addr_cntrl_lat;--get_max(0,struct.addr_cntrl_lat-1);
      struct.addr_dly:=0;
    end if;

    if not struct.has_input_buffer and reqs.num_filts>1 then
      --extra delay on filter sel generation
      struct.filt_dly:=struct.filt_dly-1;
    end if;

    if reqs.coef_reload=1 then
      if struct.filt_dly - (struct.reload_cntrl_param_lat.filt_sel_lat) <= 0 then
        --need to delay address generation
        struct.addr_dly:=struct.addr_dly+abs( (struct.filt_dly - (struct.reload_cntrl_param_lat.filt_sel_lat)) );
        struct.data_dly:=struct.data_dly+abs( (struct.filt_dly - (struct.reload_cntrl_param_lat.filt_sel_lat)) );
        --also need to delay data to allign correctly
        struct.filt_dly:=0;
      else
        --subtract some delay from filt dly
        struct.filt_dly:=struct.filt_dly - (struct.reload_cntrl_param_lat.filt_sel_lat);
      end if;
    end if;

    data_addr_dly:=select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat);

    struct.data_addr_param.en_dly         :=struct.data_addr_param.en_dly+
                                            data_addr_dly+
                                            struct.addr_dly;
    struct.data_addr_param.block_end_dly  :=struct.data_addr_param.block_end_dly+
                                            data_addr_dly+
                                            struct.addr_dly;
    struct.data_addr_param.last_block_dly :=struct.data_addr_param.last_block_dly+
                                            data_addr_dly+
                                            struct.addr_dly;
    struct.data_addr_param.write_phase_dly :=struct.data_addr_param.write_phase_dly+
                                            data_addr_dly+
                                            struct.addr_dly;
    struct.data_addr_param.sub_block_end_dly :=struct.data_addr_param.sub_block_end_dly+
                                            data_addr_dly+
                                            struct.addr_dly;

    coef_addr_dly:=select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat);

    struct.coef_addr_param.en_dly         :=struct.coef_addr_param.en_dly+
                                            coef_addr_dly+
                                            struct.addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.base_max_dly  := struct.coef_addr_param.base_max_dly+
                                            coef_addr_dly+
                                            struct.addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.skip_base_max_dly := struct.coef_addr_param.skip_base_max_dly+
                                                coef_addr_dly+
                                                struct.addr_dly
                                                +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.count_max_dly := struct.coef_addr_param.count_max_dly+
                                            coef_addr_dly+
                                            struct.addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.filt_sel_dly :=  struct.coef_addr_param.filt_sel_dly+
                                            coef_addr_dly+
                                            struct.filt_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;

    struct.rfd_param:=(
        family          => reqs.family,
        implementation  => implementation,
        cnt             => struct.param.clk_per_chan,
        has_nd          => reqs.has_nd );

    --Latency Calculation
    struct.buffer_type:=select_integer(0,1,struct.has_input_buffer);
    struct.buffer_page_size:=reqs.num_channels;
    struct.latency:=--select_integer(0,struct.input_buffer_lat,struct.has_input_buffer)
                    select_integer(0,1,struct.has_input_buffer)
                    +struct.base_count_op_rate--struct.param.base_count
                    +struct.addr_cntrl_lat---1
                    +struct.addr_dly
                    +get_max(struct.data_addr_lat,struct.coef_addr_lat)
                    +struct.first_tap_extra_dly
                    +struct.filt_arm_lat.cascaded
                    +struct.filt_arm_lat.tap
                    +select_integer(0,1,struct.accum_req)
                    +reqs.reg_output;

    return struct;

  end;

--------------------------------------------------------------------------------
--From:  ../hdl/mac_elements/mac_fir_polyphase_pq_decimation.vhd

  function define_pq_decimation(reqs:t_reqs) return t_define_pq_decimation is
  ------------------------------------------------------------------------------

    variable struct: t_define_pq_decimation;
    --variable mem_param: t_tap_memory_add_casc;
    --variable memory_path_lat: t_lat_tap_memory_add_casc;
    constant srl16_mem_depth_thres: integer:=select_integer(32,64,
                                                            reqs.family=v5);
    constant dram_mem_depth_thres: integer:=select_integer(16,32,
                                                           reqs.family=v5);
    variable implementation:integer:=1;--structural
    variable  taps_per_phase,
              data_depth_unpacked,
              data_depth_packed,
              coef_depth_unpacked,
              coef_depth_packed,
              num_col,
              pass,
              filter_sel_dly,
              addr_dly :integer;
  begin
    --Defaults and direct copies
    struct.param.family:=reqs.family;
    struct.param.filter_type:=reqs.filter_type;
    struct.param.coef_reload:=reqs.coef_reload;
    struct.param.data_sign:=reqs.data_sign;
    struct.param.coef_sign:=reqs.coef_sign;
    struct.param.data_width:=reqs.data_width;
    struct.param.coef_width:=reqs.coef_width;
    struct.param.clk_per_samp:=reqs.clk_per_samp;
    struct.param.num_channels:=reqs.num_channels;
    struct.param.num_taps:=reqs.num_taps;
    struct.param.num_filts:=reqs.num_filts;
    struct.param.zero_packing_factor:=reqs.zero_packing_factor;

    struct.param.symmetry:=0;--reqs.symmetry;
    struct.param.neg_symmetry:=0;--reqs.neg_symmetry;
    struct.param.odd_symmetry:=0;--select_integer(0,reqs.num_taps rem 2,struct.param.symmetry=1);
    struct.param.num_taps_calced:=(reqs.num_taps/2**struct.param.symmetry)+struct.param.odd_symmetry;

--     --loop round here once checked depth of inter tap buffer depth
--      pass:=0;
--      while pass<2 loop
      --Calculate details of the filter-------------------------------------------
      --Number of macs and number of taps per mac
      if ( reqs.clk_per_samp/reqs.num_channels = 0 ) then
        report "FIR: not enough clock cycles per sample to process all channels, must have a minimum of 1 clk cycle per channel" severity error;
      elsif ( reqs.clk_per_samp rem reqs.num_channels > 0 ) then
        report "FIR: number of channels does not fit fully into clock cycles per sample, there will be unused clock cycles" severity note;
      end if;

      struct.param.clk_per_chan := reqs.clk_per_samp / reqs.num_channels;
          
      struct.param.base_count := struct.param.clk_per_chan / reqs.inter_rate;

      taps_per_phase:= struct.param.num_taps_calced / reqs.deci_rate;
      if ( struct.param.num_taps_calced rem reqs.deci_rate > 0) then
        taps_per_phase:=taps_per_phase+1;
      end if;

      struct.param.num_macs := taps_per_phase/(struct.param.base_count*reqs.inter_rate);

      if ( taps_per_phase rem (struct.param.base_count*reqs.inter_rate) > 0 ) then
      -- Add extra mac, this mac will need the filter coefficients padded out.
        struct.param.num_macs:=struct.param.num_macs+1;
      end if;

      --Adjust for unused cycles
      struct.param.base_count:=taps_per_phase/struct.param.num_macs;
      if (taps_per_phase rem struct.param.num_macs >0) then
        struct.param.base_count:=struct.param.base_count+1;
      end if;
      if ( struct.param.base_count rem reqs.inter_rate > 0 ) then
        struct.param.base_count:= ((struct.param.base_count/reqs.inter_rate)+1);-- * reqs.inter_rate;
      else
        struct.param.base_count:= (struct.param.base_count/reqs.inter_rate);-- * reqs.inter_rate;
      end if;

      if struct.param.base_count<(struct.param.clk_per_chan/reqs.inter_rate) then
        struct.shorter_px_time:=true;
      else
        struct.shorter_px_time:=false;
      end if;

      if pass=0 then
        struct.param.centre_mac:=struct.param.num_macs;
      end if;

      --struct.param.base_data_space := struct.param.base_count*reqs.deci_rate;
      struct.param.base_coef_space := struct.param.base_count*reqs.inter_rate*reqs.deci_rate;

      -- Modify and update so get actual filter size
      struct.param.num_taps_calced:=struct.param.num_macs*struct.param.base_count*reqs.inter_rate*reqs.deci_rate;

      struct.param.inter_rate := reqs.inter_rate;
      struct.param.deci_rate  := reqs.deci_rate;

      struct.param.no_data_mem:= 0;
      -- if (struct.param.base_count = 1 and reqs.num_channels=1) then
--         struct.param.no_data_mem:= 1;
--       end if;
      
      struct.output_rate:=struct.param.clk_per_chan / reqs.inter_rate*reqs.deci_rate;

      --Structural decisions------------------------------------------------------
      -- struct.param.single_mac:=0;
--       if struct.param.num_macs=1 then
--         struct.param.single_mac:=1;
--       end if;

      struct.param.single_mac:=0;
      if reqs.family/=s3ax then
        --Virtex
        if struct.param.num_macs=1 then
          struct.param.single_mac:=1;
        end if;
      else
        --Sandia
        if struct.param.num_macs=1 then--  and
--            (reqs.num_channels=1 or
--             struct.shorter_px_time) then
          --when shorter_px_time can uses a load on a spare cycle
          struct.param.single_mac:=1;
        end if;
      end if;

      --Memory calculations-------------------------------------
      data_depth_unpacked:=2**log2roundup(struct.param.base_count)*(reqs.num_channels*reqs.deci_rate);
      data_depth_packed:=struct.param.base_count*reqs.num_channels*reqs.deci_rate;

      -- coef_depth_unpacked:=2**log2roundup(struct.param.base_coef_space)*struct.param.num_filts;
--       coef_depth_packed:=struct.param.base_coef_space*struct.param.num_filts;

      coef_depth_unpacked:=2**log2roundup( 2**log2roundup(struct.param.base_coef_space)*struct.param.num_filts)*2**struct.param.coef_reload;
      coef_depth_packed:=struct.param.base_coef_space*struct.param.num_filts*2**struct.param.coef_reload;

      struct.param:=memory_calcs( reqs,
                                  struct.param,
                                  data_depth_unpacked,
                                  data_depth_packed,
                                  coef_depth_unpacked,
                                  coef_depth_packed);

      --Symmetric wrap over calculations-------------------------
      --need to know latency of memory implmented
      struct.mem_param:=( family           =>reqs.family,
                          implementation   =>implementation,
                          data_mem_type    =>struct.param.data_mem_type,
                          coef_mem_type    =>struct.param.coef_mem_type,
                          data_comb        =>struct.param.data_combined,
                          data_coef_comb   =>struct.param.data_coef_combined,
                          no_data_mem      =>struct.param.no_data_mem,
                          coef_mem_depth  => struct.param.coef_mem_depth,
                          has_ce           =>reqs.has_ce,
                          coef_reload      =>reqs.coef_reload,
                          coef_reload_depth=>struct.param.base_coef_space,
                          symmetric        =>struct.param.symmetry );

      struct.memory_path_lat:=lat_tap_memory_add_casc(struct.mem_param);

--       struct.cyc_to_data_out:=struct.memory_path_lat.data+1;--plus one for the latch (min depth of 1 in delay)
--       
--       struct.cyc_to_write:=0;
--       if (struct.mem_param.data_mem_type=1) then
--         struct.cyc_to_write:=struct.param.base_count; --inter_we_cycles
--       end if;
-- 
--       -- struct.num_cyc_read_earily:= select_integer(0,1,struct.cyc_to_write-struct.cyc_to_data_out<0)
-- --                                   +select_integer(0,1,struct.param.odd_symmetry=1);
--
--       struct.num_cyc_read_earily:= select_integer(0,1,struct.cyc_to_write+struct.param.odd_symmetry-struct.cyc_to_data_out<0)
--                                   +select_integer(0,1,struct.param.odd_symmetry=1);
--       --add odd sym when calc if need earily read as when odd sym will read data earily this gives longer to get
--       --data out of memory. So then check if still don't have enough time to get data out of memory
-- 
--       struct.change_src:=select_integer(0,1,struct.num_cyc_read_earily>=struct.param.base_count);
-- 
--       struct.extra_dly:=select_integer(0,1,(struct.cyc_to_data_out-struct.num_cyc_read_earily<=struct.cyc_to_write and
--                                             struct.num_cyc_read_earily-struct.param.odd_symmetry>0 and
--                                             struct.change_src=0) or
--                                            (struct.param.no_data_mem=1 and struct.param.odd_symmetry=1) );

      struct.add_sup_dly:=struct.memory_path_lat.data;
      
      struct.first_tap_extra_dly:=0;

      if struct.param.data_mem_type=c_srl16 and struct.param.no_data_mem=0 then
        struct.data_dly_modifier:=-1;
      else
        struct.data_dly_modifier:=0;
      end if;

      if struct.param.no_data_mem=1 then
        if struct.memory_path_lat.coef>1 then
          --filt casc can direct emb_calc to compensate  for a difference of 1, any more
          --and need extra delay.
          struct.data_dly_modifier:=struct.data_dly_modifier+struct.memory_path_lat.coef-1;
          struct.add_sup_dly:=struct.add_sup_dly+struct.memory_path_lat.coef-1;
          struct.first_tap_extra_dly:=struct.memory_path_lat.coef-1;
        end if;
      end if;

      --Filter arm settings-------------------------------------
      if (reqs.col_mode=1) then
        -- if (struct.param.num_macs>reqs.col_1st_len) then
--           num_col:=1+(struct.param.num_macs-reqs.col_1st_len)/reqs.col_wrap_len;
--         else
--           num_col:=1;
--         end if;
        num_col:=calc_num_split_col(struct.param.num_macs,t_col_len'(
                                   0 => select_integer(reqs.col_wrap_len,reqs.col_1st_len,reqs.col_mode=1),
                                   others=>reqs.col_wrap_len));
      elsif (reqs.col_mode=2) then
        -- no generic for this mode yet
        num_col:=1;
      else
        num_col:=1;
      end if;
  
      struct.filt_arm:= (
          family          => reqs.family,
          implementation  => implementation,
          num_taps        => struct.param.num_macs,
          inter_we_cycles => struct.param.base_count,
          inter_tap_delay => (struct.param.num_channels*reqs.deci_rate)+2,--(struct.param.num_channels*(reqs.deci_rate-reqs.inter_rate))+2,
          --normally +1 have put in +2 maybe need set dependant on rates but I don't think it should be
          inter_sym_tap_delay => 0,
          --no symmetric support in this structure
          symmetric       => struct.param.symmetry,
          pre_add_func    => select_integer(c_preadd_add,c_preadd_sub,struct.param.neg_symmetry=1),
          data_mem_type   => struct.param.data_mem_type,
          coef_mem_type   => struct.param.coef_mem_type,
          data_comb       => struct.param.data_combined,
          data_coef_comb  => struct.param.data_coef_combined,
          data_cascade    => 0,
          no_data_mem     => struct.param.no_data_mem,
          coef_mem_depth  => struct.param.coef_mem_depth,
          p_src           => 0,--fabric
          data_sign       => reqs.data_sign,
          coef_sign       => reqs.coef_sign,
          has_ce          => reqs.has_ce,
          --has_nd          => reqs.has_nd,
          reload          => reqs.coef_reload,
          reload_strms    => select_integer(1,2,struct.param.coef_mem_type=c_bram),
          reload_depth    => struct.param.base_coef_space,
          output_index    => (
                            p_P_OUT       => struct.param.num_macs+1,
                            p_PC_OUT      => struct.param.num_macs+1,
                            p_D_OUT       => struct.param.num_macs,-- -struct.change_src,
                            p_D_SYM_OUT   => struct.param.num_macs,
                            p_C_OUT       => struct.param.num_macs,
                            p_WE_OUT      => struct.param.num_macs,-- +1,
                            p_WE_SYM_OUT  => struct.param.num_macs,--+(struct.cyc_to_data_out-1)-struct.num_cyc_read_earily,
                            p_ADDSUB_OUT  => struct.param.num_macs+1,
                            p_ADDSUP_OUT  => struct.param.num_macs+1,
                            p_WE_SYM_OUT_2    => struct.param.num_macs ),
          output_src      => (
                            p_P_OUT       => 0,
                            p_PC_OUT       => 0,
                            p_D_OUT       => 0,--select_integer(1,0,struct.change_src=1),
                            p_D_SYM_OUT   => 0,
                            p_C_OUT       => 0,
                            p_WE_OUT      => 0,
                            p_WE_SYM_OUT  => 0,
                            p_ADDSUB_OUT  => 0,
                            p_ADDSUP_OUT  => 0,
                            p_WE_SYM_OUT_2    => 0 ),
          num_independant_col => select_integer(1,num_col,reqs.col_mode=2),
          num_split_col       => select_integer(1,num_col,reqs.col_mode=1),
          inter_split_col_dly => reqs.col_pipe_len,
          col_len             => ( 0 => select_integer(reqs.col_wrap_len,reqs.col_1st_len,reqs.col_mode=1),
                                   others=>reqs.col_wrap_len),
          dynamic_opcode  => select_integer(0,1,struct.param.single_mac=1),
          sym_para_struct => reqs.has_nd,
          para_casc_we_src=> 2,--structure where we_sym is used to latch data into the data_casc buffers
          resource_opt    => reqs.resource_opt,
          data_width      => reqs.data_width,
          datapath_mem_type => reqs.datapath_mem_type,
          odd_symmetry    => struct.param.odd_symmetry  );

      struct.filt_arm_lat:=lat_filt_arm_add_casc(struct.filt_arm);

--       if (  struct.param.symmetry=1 and
--             pass=0 and
--             struct.filt_arm_lat.sym_inter_buff_depth>1089 and
--             reqs.data_mem_type=1 ) then
--
--         --disable symmetry as srl16 will be forced for the delay and its is not able to support >1089
--         struct.param.symmetry:=0;
--         struct.param.neg_symmetry:=0;
--         struct.param.odd_symmetry:=0;
--         struct.param.num_taps_calced:=reqs.num_taps;
--         pass:=1;
--       else
--         pass:=2;
--       end if;
--
--     end loop;

    --Accumulator settings---------------------------------------
    struct.accum:=(
        family         => reqs.family,
        implementation => implementation,
        pre_add        => 0,
        pre_add_func   => c_preadd_add,
        pre_add_ipreg  => 0,
        pre_add_midreg => 0,
        a_delay        => 0,--1,
        b_delay        => 0,--1,
        a_src          => 0,--fabric
        --c_src          => 1, --alway from another DSP
        a_sign         => c_signed,--reqs.data_sign,
        b_sign         => c_signed,--reqs.coef_sign,--not used in single rate
        d_sign         => c_signed,--reqs.data_sign,
        reg_opcode     => 1,
        implement_extra_b_dly => 1 );

    struct.accum_lat:=dtls_emb_calc(struct.accum);

    struct.accum_req:=true;

    if --(struct.param.base_count=1 and struct.param.num_macs>1) or
       (struct.param.single_mac=1) then
      struct.accum_req:=false;
    end if;

    struct.use_c_port_as_storage:=true;
    if reqs.resource_opt=c_speed and reqs.has_ce=1 and struct.param.no_data_mem=0 then
      struct.use_c_port_as_storage:=false;
    end if;

    --Output buffer ram settings---------------------------------
    struct.output_buffer_depth:=2*reqs.num_channels*reqs.inter_rate;
    
    struct.has_output_buffer:=false;
    if reqs.num_channels>1 or
       (reqs.num_channels=1 and (struct.param.clk_per_chan rem reqs.inter_rate > 0)) or
       struct.shorter_px_time then
      struct.has_output_buffer:=true;
    end if;

    struct.output_buffer:=(
      family              => reqs.family,
      implementation      => implementation,
      mem_type            => select_integer(
                              c_dram,--dram
                              c_bram,--bram
                              (struct.output_buffer_depth>dram_mem_depth_thres and reqs.opbuff_mem_type/=c_mem_forced_dist) or
                              reqs.opbuff_mem_type=c_mem_forced_bram),
      write_mode          => 0,--read first
      has_ce              => reqs.has_ce,
      use_mif             => 0 );

    struct.output_buffer_in_addr:=(
      family => reqs.family,
      implementation => implementation,
      addr_width => get_max(1,log2roundup(struct.output_buffer_depth)),
      page_size => reqs.num_channels*reqs.inter_rate,
      num_enables => 1 );

    struct.output_buffer_out_addr:=struct.output_buffer_in_addr;
    
    struct.output_rate_counter:=(
        cnt1_max_val    => struct.output_rate,
        cnt2_max_val    => 1,
        cnt3_max_val    => 1,
        cnt2_max_qual   => 1,
        family          => reqs.family,
        implementation  => implementation );

    struct.extra_opb_reg:=0;
    if struct.has_output_buffer and reqs.resource_opt=c_speed and struct.output_buffer.mem_type=c_dram then
        struct.extra_opb_reg:=1;
    end if;

    if struct.has_output_buffer then
      struct.output_buffer_lat:=lat_ram(struct.output_buffer,2);
    else
      struct.output_buffer_lat:=0;
    end if;

    --Address generator block settings---------------------------
    struct.base_inter_chan_param:=(
        cnt1_max_val    => struct.param.base_count,
        cnt2_max_val    => reqs.inter_rate,
        cnt3_max_val    => reqs.num_channels,
        cnt2_max_qual   => 1,
        family          => reqs.family,
        implementation  => implementation );

    struct.data_addr_param:=(
        family          => reqs.family,
        implementation  => implementation,
        mem_type        => struct.param.data_mem_type,
        base_cnt        => struct.param.base_count,
        block_cnt       => select_integer(
                            select_integer(1,reqs.deci_rate,reqs.num_channels=1),
                            reqs.num_channels*reqs.deci_rate,
                            struct.param.data_mem_type=c_srl16),
        symmetric       => struct.param.symmetry,
        addr_width      => get_max(1,log2roundup(struct.param.data_mem_depth)),
        sym_addr_width  => get_max(1,log2roundup(struct.param.datasym_mem_depth+struct.param.datasym_mem_offset)),
        combined        => struct.param.data_combined,
        addr_packed     => struct.param.data_packed,
        srl16_sequence  => select_integer(1,0,struct.param.data_mem_type=c_srl16),
        --need to repeat addresses before shift, not sure about srl16 reqs yet but for packed data address, single channel need to set this signal
        en_dly          => 0,-- select_integer(0,1,(reqs.has_nd=1 and struct.param.no_data_mem=0) or
--                                                struct.shorter_px_time),
        block_end_dly   => 0,  --delay of one due to the generation of addr_en
        last_block_dly  => 0,
        write_phase_dly => 0,
        sub_block_end_dly => 0,
        use_sym_cntrl   => 0,
        resource_opt    => select_integer(reqs.resource_opt,c_area,
                                  (struct.param.data_mem_type/=c_srl16 and struct.param.data_packed=1 and reqs.num_channels>1) or
                                  struct.param.data_mem_type=c_srl16)  );
          --don't need speed optimisation, buffer register, as will be feeding another adder

    struct.data_addr_lat:=lat_data_address(struct.data_addr_param);

    struct.data_addr_lat:=get_max(0,struct.data_addr_lat-1);
    --sub 1 as only interested in the first location of the count,
    --this occurs with 0 latency when latency is 1

    if reqs.num_channels>1 or struct.param.data_mem_type=c_srl16 then
      --add delay on for external generation
      if struct.param.data_mem_type/=c_srl16 then
        struct.data_addr_param.en_dly:=struct.data_addr_param.en_dly+1;
        struct.data_addr_param.block_end_dly:=struct.data_addr_param.block_end_dly+1;
        struct.data_addr_param.last_block_dly:=struct.data_addr_param.last_block_dly+1;
        struct.data_addr_param.sub_block_end_dly:=struct.data_addr_param.sub_block_end_dly+1;
        struct.data_addr_param.write_phase_dly:=struct.data_addr_param.write_phase_dly+1;
        if struct.param.data_packed=0 or struct.param.base_count=1 then
          struct.data_addr_lat:=struct.data_addr_lat+1;
        else
          struct.data_addr_lat:=struct.data_addr_lat+2;
        end if;
      else
        struct.data_addr_lat:=struct.data_addr_lat+1;
        --don't need to delay the generation of the address but need to increase
        --latency by 1
--         if struct.param.base_count=1 then
--           struct.data_addr_lat:=struct.data_addr_lat+1;
--         end if;

      end if;
    end if;

    --special case where the delay for data address is not correct, the extra for speed opt is
    --not being added on correctly
    if reqs.resource_opt=c_speed and
       reqs.family=s3ax and 
       struct.param.base_count=1 and
       struct.param.data_mem_type/=c_srl16 and
       reqs.num_channels>1 then
      struct.data_addr_lat:=struct.data_addr_lat+1;
    end if;

    struct.coef_addr_param:=(
        family          => reqs.family,
        implementation  => implementation,
        base_cnt        => struct.param.base_count*reqs.inter_rate,
        block_cnt       => reqs.deci_rate,
        addr_packed     => struct.param.coef_packed,
        addr_width      => get_max(1,log2roundup( struct.param.coef_mem_depth
                                                  +struct.param.coef_mem_offset )),
        num_filters     => reqs.num_filts,--*select_integer(1,2,struct.param.coef_reload=1),
        multi_page_reload => struct.param.coef_reload,
        offset          => struct.param.coef_mem_offset,
        has_ce          => reqs.has_ce,
        use_count_src   => 0,
        en_dly            => 0,-- select_integer(0,1,(reqs.has_nd=1 and struct.param.no_data_mem=0) or
--                                                 struct.shorter_px_time),
        base_max_dly      => 0,
        skip_base_max_dly => 0,
        count_max_dly     => 0,
        filt_sel_dly      => 0,
        resource_opt    => reqs.resource_opt);-- select_integer(1,2,(reqs.has_nd=1 and struct.param.no_data_mem=0) or
--                                                 struct.shorter_px_time));

    struct.coef_addr_lat:=lat_coef_address(struct.coef_addr_param);

    struct.coef_addr_lat:=get_max(0,struct.coef_addr_lat-1);

    struct.reload_cntrl_param:=(
      family          => reqs.family,
      implementation  => implementation,
      reload_base_cnt => struct.param.base_count*reqs.inter_rate*reqs.deci_rate,
      coef_addr_packed=> struct.param.coef_packed,
      num_filts       => reqs.num_filts,
      coef_mem_depth  => struct.param.coef_mem_depth,
      num_macs        => struct.param.num_macs,

      has_ce          => reqs.has_ce,
      coef_width      => reqs.coef_width,
      filt_sel_width  => reqs.filt_sel_width,
      filt_sel_width_out => select_integer(1,reqs.filt_sel_width+1, reqs.num_filts>1),
      reload_width    => get_max(1,log2roundup( struct.param.coef_mem_depth)),
      resource_opt    => reqs.resource_opt,
      has_hb       => 0,
      latch_filt_sel => 0,
      coef_mem_lat => struct.memory_path_lat.coef,
      num_reload_strms => select_integer(1,2,struct.param.coef_mem_type=c_bram) );

    struct.reload_cntrl_param_lat:=lat_coef_reload_cntrl(struct.reload_cntrl_param);
    struct.reload_cntrl_param_lat.filt_sel_lat:=struct.reload_cntrl_param_lat.filt_sel_lat+1;
    --add one as filter sel latch is done using we_gen, rather than nd_rfd. This is
    --to allign correctly with first_phase

    struct.addr_cntrl_lat:=2;-- select_integer(
--                                 2,
--                                 3,
--                                 (reqs.has_nd=1 and struct.param.no_data_mem=0) or
--                                 struct.shorter_px_time);
    --if reqs.num_filts>1 then
      struct.filter_sel_lat:=2;--1;
      --have added a delay to filter sel as need to recycle value
      --need extra cyle to allign with first_phase generation, it occurs 2 cycles after , not sure about this
    -- else
--       struct.filter_sel_lat:=0;
--     end if;

    if reqs.coef_reload=1 then
      if struct.reload_cntrl_param_lat.filt_sel_lat-1+struct.filter_sel_lat < struct.addr_cntrl_lat then
        filter_sel_dly:=struct.addr_cntrl_lat-(struct.reload_cntrl_param_lat.filt_sel_lat-1+struct.filter_sel_lat);
        addr_dly:=0;
      else
        filter_sel_dly:=0;
        addr_dly:=(struct.reload_cntrl_param_lat.filt_sel_lat-1+struct.filter_sel_lat)-struct.addr_cntrl_lat;
        struct.addr_cntrl_lat:=struct.addr_cntrl_lat+addr_dly;
      end if;
    else
      addr_dly:=0;
      filter_sel_dly:=struct.addr_cntrl_lat-struct.filter_sel_lat;
    end if;

    --Balance delays
    struct.data_addr_param.en_dly         :=struct.data_addr_param.en_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat)
                                            +addr_dly;
    struct.data_addr_param.block_end_dly  :=struct.data_addr_param.block_end_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat)
                                            +addr_dly;
    struct.data_addr_param.last_block_dly :=struct.data_addr_param.last_block_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat)
                                            +addr_dly;
    struct.data_addr_param.sub_block_end_dly :=struct.data_addr_param.sub_block_end_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat)
                                            +addr_dly;
    struct.data_addr_param.write_phase_dly :=struct.data_addr_param.write_phase_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat>struct.data_addr_lat)
                                            +addr_dly;

    
    struct.coef_addr_param.en_dly         :=struct.coef_addr_param.en_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.base_max_dly  :=struct.coef_addr_param.base_max_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.skip_base_max_dly :=struct.coef_addr_param.skip_base_max_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.count_max_dly :=struct.coef_addr_param.count_max_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +addr_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;
    struct.coef_addr_param.filt_sel_dly :=struct.coef_addr_param.filt_sel_dly+
                                            select_integer(0,abs(struct.data_addr_lat-struct.coef_addr_lat),struct.coef_addr_lat<struct.data_addr_lat)
                                            +filter_sel_dly
                                            +struct.filt_arm_lat.coef_addr_extra_delay;

    struct.rfd_param:=(
        family          => reqs.family,
        implementation  => implementation,
        cnt             => struct.param.clk_per_chan,
        has_nd          => reqs.has_nd);

    --Latency Calculation
    struct.buffer_type:=2;
    if struct.has_output_buffer then
      struct.buffer_page_size:=reqs.num_channels*reqs.inter_rate;
      struct.sample_latency:=(reqs.num_channels*(reqs.deci_rate-1))+1;
      struct.latency:=struct.param.base_count*reqs.inter_rate
                      --the point in the sequence that final latch_accum is generated for a block of results
                      --will be when the deci phase finished at the end of a base block of base * interrate
                      +struct.addr_cntrl_lat---1
                      +get_max(struct.data_addr_lat,struct.coef_addr_lat)
                      +struct.first_tap_extra_dly
                      +struct.filt_arm_lat.cascaded
                      +struct.filt_arm_lat.tap
                      +select_integer(0,1,struct.accum_req)
                      --+struct.output_buffer_lat
                      --the output is not delayed for the output buffer latency
                      +select_integer(0,struct.output_rate+
                                      struct.extra_opb_reg,struct.has_output_buffer)
                      +reqs.reg_output;
    else
      struct.buffer_page_size:=0;
      struct.sample_latency:=(reqs.deci_rate/reqs.inter_rate)+select_integer(0,1,reqs.deci_rate rem reqs.inter_rate > 0);
      struct.latency:=struct.param.base_count*(reqs.deci_rate rem reqs.inter_rate)
                      --need to calculate last phase of current output
                      +struct.addr_cntrl_lat---1
                      +get_max(struct.data_addr_lat,struct.coef_addr_lat)
                      +struct.first_tap_extra_dly
                      +struct.filt_arm_lat.cascaded
                      +struct.filt_arm_lat.tap
                      +select_integer(0,1,struct.accum_req)
                      +reqs.reg_output;
    end if;

    return struct;

  end;


end sim_pkg;
