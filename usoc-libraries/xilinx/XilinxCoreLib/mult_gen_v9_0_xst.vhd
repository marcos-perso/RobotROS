-- $RCSfile: mult_gen_v9_0_xst.vhd,v $ $Revision: 1.1 $ $Date: 2010-07-10 21:43:16 $
--------------------------------------------------------------------------------
--  Copyright(C) 2005 by Xilinx, Inc. All rights reserved.
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
--  of this text at all times. (c) Copyright 1995-2005 Xilinx, Inc.
--  All rights reserved.
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY xilinxcorelib;
USE xilinxcorelib.mult_gen_v9_0_comp.ALL;

ENTITY mult_gen_v9_0_xst IS
  GENERIC (
    c_xdevicefamily     : STRING  := "virtex4";  -- specifies target Xilinx FPGA name
    c_a_width           : INTEGER := 18;  -- width of A port
    c_a_type            : INTEGER := 0;   -- datatype of A port
    c_b_width           : INTEGER := 18;  -- width of B port
    c_b_type            : INTEGER := 0;   -- datatype of B port
    c_out_high          : INTEGER := 35;  -- MSB of P output port (N-1 downto 0 convention)
    c_out_low           : INTEGER := 0;  -- LSB of P output port (N-1 downto 0 convention)
    c_mult_type         : INTEGER := 1;  -- Type of multiplier to implement
    c_opt_goal          : INTEGER := 1;  -- Optimization of multiplier
    c_has_ce            : INTEGER := 0;  -- Use clock enable on all registers
    c_has_sclr          : INTEGER := 0;  -- Use Synchronous clear on all registers
    c_ce_overrides_sclr : INTEGER := 1;  -- Priority of CE and SCLR
    c_pipe_stages       : INTEGER := 1;  -- Number of register stages required
    c_ccm_imp           : INTEGER := 0;  -- Implementation of CCM (if selected by c_mult_type)
    c_b_value           : STRING  := "111111111111111111";  -- Value for (initial) B port constant for CCM
    c_elaboration_dir   : STRING  := "./";     -- CoreGen-specific generic
    c_has_load_done     : INTEGER := 0;  -- Offer load_done flag pin on output (reloadable CCMs only)
    c_has_zero_detect   : INTEGER := 0;  -- Offer zero detection of W-2 LSB bits on WxW multiplier
    c_round_output      : INTEGER := 0;  -- Specifies if P output should be symmetrically rounded
    c_round_pt          : INTEGER := 0;  -- Specifies the bit of the full-width product below which rounding should occur
    c_mem_init_prefix   : STRING  := "mult");  -- MIF file prefix for multiple CCM instantiations
  PORT (
    clk         : IN  STD_LOGIC                              := '1';
    a           : IN  STD_LOGIC_VECTOR(c_a_width-1 DOWNTO 0) := (OTHERS => '0');
    b           : IN  STD_LOGIC_VECTOR(c_b_width-1 DOWNTO 0) := (OTHERS => '0');
    loadb       : IN  STD_LOGIC                              := '0';
    swapb       : IN  STD_LOGIC                              := '0';
    ce          : IN  STD_LOGIC                              := '1';
    sclr        : IN  STD_LOGIC                              := '0';
    load_done   : OUT STD_LOGIC;
    zero_detect : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    p           : OUT STD_LOGIC_VECTOR(c_out_high-c_out_low DOWNTO 0)); 
END mult_gen_v9_0_xst;
--
-- behavior describing a parameterized multiplier
--
ARCHITECTURE behavioral OF mult_gen_v9_0_xst IS
BEGIN

  i_behv : mult_gen_v9_0
    GENERIC MAP(
      c_xdevicefamily     => c_xdevicefamily,
      c_a_width           => c_a_width,
      c_a_type            => c_a_type,
      c_b_width           => c_b_width,
      c_b_type            => c_b_type,
      c_out_high          => c_out_high,
      c_out_low           => c_out_low,
      c_mult_type         => c_mult_type,
      c_opt_goal          => c_opt_goal,
      c_has_ce            => c_has_ce,
      c_has_sclr          => c_has_sclr,
      c_ce_overrides_sclr => c_ce_overrides_sclr,
      c_pipe_stages       => c_pipe_stages,
      c_ccm_imp           => c_ccm_imp,
      c_b_value           => c_b_value,
      c_elaboration_dir   => c_elaboration_dir,
      c_has_load_done     => c_has_load_done,
      c_has_zero_detect   => c_has_zero_detect,
      c_round_output      => c_round_output,
      c_round_pt          => c_round_pt,
      c_mem_init_prefix   => c_mem_init_prefix)
    PORT MAP(
      clk         => clk,
      a           => a,
      b           => b,
      loadb       => loadb,
      swapb       => swapb,
      ce          => ce,
      sclr        => sclr,
      load_done   => load_done,
      zero_detect => zero_detect,
      p           => p); 

END behavioral;
