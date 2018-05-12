-- $Header: /local/Projects/CVS/P1/zpu_SoC/sources/xilinx/XilinxCoreLib/dds_compiler_v2_0_xst_comp.vhd,v 1.1 2010-07-10 21:43:02 mmartinez Exp $
--
--  Copyright(C) 2006 by Xilinx, Inc. All rights reserved.
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
--  of this text at all times. (c) Copyright 1995-2006 Xilinx, Inc.
--  All rights reserved.

-------------------------------------------------------------------------------
-- Component statement for wrapper of behavioural model
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

library xilinxcorelib;
use xilinxcorelib.xcc_utils_v9_1.all;

package dds_compiler_v2_0_xst_comp is

----------------------------------------------------------
-- Insert component declaration of top level xst file here
----------------------------------------------------------
  --core_if on component dds_compiler_v2_0_xst
  component dds_compiler_v2_0_xst
    GENERIC (
      C_FAMILY                 : string  := "virtex4";
      C_XDEVICEFAMILY          : string  := "virtex4";
      C_ACCUMULATOR_LATENCY    : integer := 1;  --ONE_CYCLE;
      C_ACCUMULATOR_WIDTH      : integer := 16;
      C_CHANNELS               : integer := 1;
      C_DATA_WIDTH             : integer := 16;
      C_ENABLE_RLOCS           : integer := 0;
      C_HAS_CE                 : integer := 0;
      C_HAS_CHANNEL_INDEX      : integer := 0;
      C_HAS_RDY                : integer := 1;
      C_HAS_RFD                : integer := 0;
      C_HAS_SCLR               : integer := 0;
      C_LATENCY                : integer := 2;
      C_MEM_TYPE               : integer := 0;  --DIST_ROM;
      C_NEGATIVE_COSINE        : integer := 0;
      C_NEGATIVE_SINE          : integer := 0;
      C_NOISE_SHAPING          : integer := 0;
      C_OUTPUTS_REQUIRED       : integer := 2;  --SINE_AND_COSINE;
      C_OUTPUT_WIDTH           : integer := 16;
      C_PHASE_ANGLE_WIDTH      : integer := 12;
      C_PHASE_INCREMENT        : integer := 1;  --REG;
      C_PHASE_INCREMENT_VALUE  : string  := "0";
      C_PHASE_OFFSET           : integer := 2;  --CONST;
      C_PHASE_OFFSET_VALUE     : string  := "0";
      C_PIPELINED              : integer := 0;
      C_OPTIMISE_GOAL          : integer := 0;
      C_USE_DSP48              : integer := 0;
      C_POR_MODE               : integer := 0
      );
    PORT (
      addr       : in  std_logic_vector(sel_lines_reqd(C_CHANNELS)-1 downto 0) := (others => '0');
      reg_select : in  std_logic := '0';
      ce         : in  std_logic := '0';
      clk        : in  std_logic := '0';
      sclr       : in  std_logic := '0';
      we         : in  std_logic := '0';
      data       : in  std_logic_vector (C_DATA_WIDTH-1 downto 0) := (others => '0');
      rdy        : out std_logic;
      rfd        : out std_logic;
      channel    : out std_logic_vector(sel_lines_reqd(C_CHANNELS)-1 downto 0);
      cosine     : out std_logic_vector (C_OUTPUT_WIDTH-1 downto 0);
      sine       : out std_logic_vector (C_OUTPUT_WIDTH-1 downto 0)
      );
  --core_if off
  END COMPONENT;


end dds_compiler_v2_0_xst_comp;

