--------------------------------------------------------------------------------
-- $Header: /local/Projects/CVS/P1/zpu_SoC/sources/xilinx/XilinxCoreLib/fir_compiler_v1_0_comp.vhd,v 1.1 2010-07-10 21:43:10 mmartinez Exp $
--------------------------------------------------------------------------------
-- Copyright (c) 2005 Xilinx, Inc.
-- All Rights Reserved
--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor: Xilinx
-- \   \   \/    Version: 1.0
--  \   \        Filename: fir_compiler_v1_0_xst_comp.vhd
--  /   /        Date Last Modified: 
-- /___/   /\    Date Created: 21/May/2005
-- \   \  /  \
--  \___\/\___\
-- 
--Device: Xilinx
--Library: none
--Purpose: Component declarations
--Revision History:
--    Rev 1.0 : VHDL for V4 Cascade operation
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
-- Author   : Stephen Creaney
-------------------------------------------------------------------------------
-- Description:
-- 
-- Component declarations for the FIR COMPILER v1.0 core
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- library fir_compiler_v1_0;
-- use fir_compiler_v1_0.mac_fir_utils_pkg.all;

package fir_compiler_v1_0_comp is

  -----------------------------------------------------------------------------
  component fir_compiler_v1_0
  generic ( 
    C_FAMILY            : string  := "virtex4";
    C_XDEVICE           : string  := "xdevice";
    C_ELABORATION_DIR   : string  := "./";
    C_COMPONENT_NAME    : string  := "fir";
    C_MEM_INIT_FILE     : string  := "COEFF";
    FILTER_TYPE         : integer := 0;
    RATE                : integer := 1;
    ZERO_PACKING_FACTOR : integer := 0;
    NUM_CHANNELS        : integer := 1;
    CHAN_SEL_WIDTH      : integer := 4;
    NUM_TAPS            : integer := 16;
    CLOCK_FREQ          : integer := 400000000;
    SAMPLE_FREQ         : integer := 100000000;
    --CLK_PER_SAMP        : integer := 4;
    FILTER_ARCH         : integer := 1;
    DATA_TYPE           : integer := 0;
    DATA_WIDTH          : integer := 16;
    COEF_TYPE           : integer := 0;
    COEF_WIDTH          : integer := 16;
    OUTPUT_WIDTH        : integer := 48;
    OUTPUT_REG          : integer := 1;
    SYMMETRY            : integer := 0;
    ODD_SYMMETRY        : integer := 0;
    NEG_SYMMETRY        : integer := 0;
    COEF_RELOAD         : integer := 0;
    NUM_FILTS           : integer := 1;
    FILTER_SEL_WIDTH    : integer := 4;
    MEMORY_MODE         : integer := 0;
    DATA_MEMTYPE        : integer := 0;
    COEF_MEMTYPE        : integer := 0;
    MEMORY_PACK         : integer := 0;
    C_HAS_SCLR          : integer := 0;
    C_HAS_CE            : integer := 0;
    C_HAS_ND            : integer := 1;
    C_HAS_RFD           : integer := 1;
    C_HAS_RDY           : integer := 1;
    COL_MODE            : integer := 0;
    COL_1ST_LEN         : integer := 3;
    COL_WRAP_LEN        : integer := 4;
    COL_PIPE_LEN        : integer := 3;
    C_TAP_BALANCE       : integer := 0;
    C_ENABLE_RLOCS      : integer := 0
  );
  port (
    SCLR         : in  std_logic;
    CLK          : in  std_logic;
    CE           : in  std_logic;
    VIN          : in  std_logic;
    DIN          : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    FILTER_SEL   : in  std_logic_vector(FILTER_SEL_WIDTH-1 downto 0);
    COEF_LD      : in  std_logic;
    COEF_WE      : in  std_logic;
    COEF_DIN     : in  std_logic_vector(COEF_WIDTH-1 downto 0);

    RFD          : out std_logic;
    VOUT         : out std_logic;
    DOUT         : out std_logic_vector(OUTPUT_WIDTH-1 downto 0);
    CHAN_OUT     : out std_logic_vector(CHAN_SEL_WIDTH-1 downto 0);
    CHAN_IN      : out std_logic_vector(CHAN_SEL_WIDTH-1 downto 0);
    DOUT_I        : out std_logic_vector(DATA_WIDTH-1 downto 0);
    DOUT_Q        : out std_logic_vector(OUTPUT_WIDTH-1 downto 0)
  );
  end component;

  -----------------------------------------------------------------------------

end fir_compiler_v1_0_comp;
