-- $Id: xfft_v4_0_xst_comp.vhd,v 1.1 2010-07-10 21:43:30 mmartinez Exp $
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
------------------------------------------------------------------------------
-- Component statement for wrapper of behavioural model
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

PACKAGE xfft_v4_0_xst_comp IS

  --core_if on component xst
  COMPONENT xfft_v4_0_xst
    GENERIC (
      C_FAMILY             : STRING  := "virtex4";
      C_XDEVICEFAMILY      : STRING  := "virtex4";
      C_CHANNELS           : INTEGER := 1;          -- Number of channels: 1-12 (ignored unless C_ARCH=4)
      C_NFFT_MAX           : INTEGER := 10;         -- log2(maximum point size): 3-16
      C_ARCH               : INTEGER := 1;          -- Architecture: 1=radix4, 2=radix2, 3=pipelined, 4=single output
      C_HAS_NFFT           : INTEGER := 0;          -- Run-time configurable point size: 0=no, 1=yes
      C_INPUT_WIDTH        : INTEGER := 16;         -- Input data width: 8-24 bits
      C_TWIDDLE_WIDTH      : INTEGER := 16;         -- Twiddle factor width: 8-24 bits
      C_OUTPUT_WIDTH       : INTEGER := 16;         -- Output data width: must be C_INPUT_WIDTH+C_NFFT_MAX+1 if C_HAS_SCALING=0, C_INPUT_WIDTH otherwise
      C_HAS_SCALING        : INTEGER := 1;          -- Data is scaled after the butterfly: 0=no, 1=yes
      C_HAS_BFP            : INTEGER := 0;          -- Type of scaling if C_HAS_SCALING=1: 0=set by SCALE_SCH input, 1=block floating point
      C_HAS_ROUNDING       : INTEGER := 0;          -- Type of data rounding: 0=truncation, 1=unbiased rounding
      C_HAS_CE             : INTEGER := 0;          -- Clock enable input present: 0=no, 1=yes
      C_HAS_SCLR           : INTEGER := 0;          -- Synchronous clear input present: 0=no, 1=yes
      C_HAS_OVFLO          : INTEGER := 0;          -- Overflow output present: 0=no, 1=yes (ignored unless C_HAS_SCALING=1 and C_HAS_BFP=0)
      C_HAS_NATURAL_OUTPUT : INTEGER := 0;          -- Output ordering: 0=bit/digit reversed order output, 1=natural order output
      C_DATA_MEM_TYPE      : INTEGER := 1;          -- Type of data memory: 0=distributed memory, 1=BRAM (ignored if C_ARCH=3)
      C_TWIDDLE_MEM_TYPE   : INTEGER := 1;          -- Type of twiddle factor memory: 0=distributed memory, 1=BRAM (ignored if C_ARCH=3)
      C_BRAM_STAGES        : INTEGER := 0;          -- Number of pipeline stages using BRAM for data and twiddle memories (C_ARCH=3 only)
      C_FAST_CMPY          : INTEGER := 0;          -- Optimize complex multiplier for speed using DSP48s: 0=no, 1=yes
      C_OPTIMIZE           : INTEGER := 0;          -- Optimize butterfly arithmetic for speed using DSP48s: 0=no, 1=yes
      C_FAST_SINCOS        : INTEGER := 0;          -- Deprecated, ignored
      C_HAS_BYPASS         : INTEGER := 1;          -- Deprecated, ignored
      C_ENABLE_RLOCS       : INTEGER := 0           -- Deprecated, ignored
      );

    PORT (
      -- Ports differ significantly for single channel (C_CHANNELS = 1) and multichannel (C_CHANNELS > 1).
      -- This includes differently named ports for the first channel for single and multichannel.
      -- The reason for this is partly backward compatibility and partly user convenience and intuitive behaviour:
      -- single channel (backward compatible) has always had non-numbered ports (e.g. XN_RE not XN0_RE)
      -- so we want to retain that convention for single channel versions here;
      -- but for multichannel where ports for channels 1-11 are numbered 1-11, it is most intuitive for the ports
      -- for channel 0 to be numbered 0, rather than have no number.

      -- The SCALE_SCH input's width is determined as follows:
      -- arch 1 and 3 : width = C_NFFT_MAX rounded up to next even number
      -- arch 2 and 4 : width = C_NFFT_MAX * 2
      -- To avoid using a function to calculate this (which causes problems with
      -- package names or internal tools flows) we use a complex expression:
      -- (C_NFFT_MAX*2)-((C_NFFT_MAX/2*2)*(C_ARCH MOD 2))
      --      |               |               |
      --   width for      adjust width     this evaluates to 0 when arch=2,4
      --   arch=2,4       for arch=1,3      and to 1 when arch=1,3

      -- Inputs independent of number of channels
      CLK        : IN STD_LOGIC;                                        -- Clock
      CE         : IN STD_LOGIC                    := '1';              -- Clock enable (present if C_HAS_CE=1)
      SCLR       : IN STD_LOGIC                    := '0';              -- Synchronous clear (present if C_HAS_SCLR=1)
      NFFT       : IN STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');  -- log2(new point size) (present if C_HAS_NFFT=1)
      NFFT_WE    : IN STD_LOGIC                    := '0';              -- Write enable for NFFT input (present if C_HAS_NFFT=1)
      FWD_INV    : IN STD_LOGIC;                                        -- Transform direction: 0=inverse, 1=forward
      FWD_INV_WE : IN STD_LOGIC;                                        -- Write enable for FWD_INV input
      START      : IN STD_LOGIC;                                        -- Start data loading and the FFT transform
      UNLOAD     : IN STD_LOGIC                    := '0';              -- Start data unloading (present if C_HAS_NATURAL_OUTPUT=1)

      -- Inputs for single channel (C_CHANNELS = 1)
      XN_RE        : IN STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 DOWNTO 0)                                    := (OTHERS => '0');  -- Input data, real part
      XN_IM        : IN STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 DOWNTO 0)                                    := (OTHERS => '0');  -- Input data, imaginary part
      SCALE_SCH    : IN STD_LOGIC_VECTOR((C_NFFT_MAX*2)-((C_NFFT_MAX/2*2)*(C_ARCH MOD 2))-1 DOWNTO 0) := (OTHERS => '0');  -- Scaling schedule
      SCALE_SCH_WE : IN STD_LOGIC                                                                     := '0';              -- Write enable for SCALE_SCH

      -- Inputs for multichannel (C_CHANNELS > 1)
      XN0_RE         : IN STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 DOWNTO 0)                                    := (OTHERS => '0');  -- Channel 0 input data, real part
      XN0_IM         : IN STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 DOWNTO 0)                                    := (OTHERS => '0');  -- Channel 0 input data, imaginary part
      XN1_RE         : IN STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 DOWNTO 0)                                    := (OTHERS => '0');  -- Channel 1 input data, real part
      XN1_IM         : IN STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 DOWNTO 0)                                    := (OTHERS => '0');  -- Channel 1 input data, imaginary part
      XN2_RE         : IN STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 DOWNTO 0)                                    := (OTHERS => '0');  -- Channel 2 input data, real part
      XN2_IM         : IN STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 DOWNTO 0)                                    := (OTHERS => '0');  -- Channel 2 input data, imaginary part
      XN3_RE         : IN STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 DOWNTO 0)                                    := (OTHERS => '0');  -- Channel 3 input data, real part
      XN3_IM         : IN STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 DOWNTO 0)                                    := (OTHERS => '0');  -- Channel 3 input data, imaginary part
      XN4_RE         : IN STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 DOWNTO 0)                                    := (OTHERS => '0');  -- Channel 4 input data, real part
      XN4_IM         : IN STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 DOWNTO 0)                                    := (OTHERS => '0');  -- Channel 4 input data, imaginary part
      XN5_RE         : IN STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 DOWNTO 0)                                    := (OTHERS => '0');  -- Channel 5 input data, real part
      XN5_IM         : IN STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 DOWNTO 0)                                    := (OTHERS => '0');  -- Channel 5 input data, imaginary part
      XN6_RE         : IN STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 DOWNTO 0)                                    := (OTHERS => '0');  -- Channel 6 input data, real part
      XN6_IM         : IN STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 DOWNTO 0)                                    := (OTHERS => '0');  -- Channel 6 input data, imaginary part
      XN7_RE         : IN STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 DOWNTO 0)                                    := (OTHERS => '0');  -- Channel 7 input data, real part
      XN7_IM         : IN STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 DOWNTO 0)                                    := (OTHERS => '0');  -- Channel 7 input data, imaginary part
      XN8_RE         : IN STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 DOWNTO 0)                                    := (OTHERS => '0');  -- Channel 8 input data, real part
      XN8_IM         : IN STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 DOWNTO 0)                                    := (OTHERS => '0');  -- Channel 8 input data, imaginary part
      XN9_RE         : IN STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 DOWNTO 0)                                    := (OTHERS => '0');  -- Channel 9 input data, real part
      XN9_IM         : IN STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 DOWNTO 0)                                    := (OTHERS => '0');  -- Channel 9 input data, imaginary part
      XN10_RE        : IN STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 DOWNTO 0)                                    := (OTHERS => '0');  -- Channel 10 input data, real part
      XN10_IM        : IN STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 DOWNTO 0)                                    := (OTHERS => '0');  -- Channel 10 input data, imaginary part
      XN11_RE        : IN STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 DOWNTO 0)                                    := (OTHERS => '0');  -- Channel 11 input data, real part
      XN11_IM        : IN STD_LOGIC_VECTOR(C_INPUT_WIDTH-1 DOWNTO 0)                                    := (OTHERS => '0');  -- Channel 11 input data, imaginary part
      SCALE_SCH0     : IN STD_LOGIC_VECTOR((C_NFFT_MAX*2)-((C_NFFT_MAX/2*2)*(C_ARCH MOD 2))-1 DOWNTO 0) := (OTHERS => '0');  -- Channel 0 scaling schedule
      SCALE_SCH0_WE  : IN STD_LOGIC                                                                     := '0';              -- Channel 0 write enable for SCALE_SCH
      SCALE_SCH1     : IN STD_LOGIC_VECTOR((C_NFFT_MAX*2)-((C_NFFT_MAX/2*2)*(C_ARCH MOD 2))-1 DOWNTO 0) := (OTHERS => '0');  -- Channel 1 scaling schedule
      SCALE_SCH1_WE  : IN STD_LOGIC                                                                     := '0';              -- Channel 1 write enable for SCALE_SCH
      SCALE_SCH2     : IN STD_LOGIC_VECTOR((C_NFFT_MAX*2)-((C_NFFT_MAX/2*2)*(C_ARCH MOD 2))-1 DOWNTO 0) := (OTHERS => '0');  -- Channel 2 scaling schedule
      SCALE_SCH2_WE  : IN STD_LOGIC                                                                     := '0';              -- Channel 2 write enable for SCALE_SCH
      SCALE_SCH3     : IN STD_LOGIC_VECTOR((C_NFFT_MAX*2)-((C_NFFT_MAX/2*2)*(C_ARCH MOD 2))-1 DOWNTO 0) := (OTHERS => '0');  -- Channel 3 scaling schedule
      SCALE_SCH3_WE  : IN STD_LOGIC                                                                     := '0';              -- Channel 3 write enable for SCALE_SCH
      SCALE_SCH4     : IN STD_LOGIC_VECTOR((C_NFFT_MAX*2)-((C_NFFT_MAX/2*2)*(C_ARCH MOD 2))-1 DOWNTO 0) := (OTHERS => '0');  -- Channel 4 scaling schedule
      SCALE_SCH4_WE  : IN STD_LOGIC                                                                     := '0';              -- Channel 4 write enable for SCALE_SCH
      SCALE_SCH5     : IN STD_LOGIC_VECTOR((C_NFFT_MAX*2)-((C_NFFT_MAX/2*2)*(C_ARCH MOD 2))-1 DOWNTO 0) := (OTHERS => '0');  -- Channel 5 scaling schedule
      SCALE_SCH5_WE  : IN STD_LOGIC                                                                     := '0';              -- Channel 5 write enable for SCALE_SCH
      SCALE_SCH6     : IN STD_LOGIC_VECTOR((C_NFFT_MAX*2)-((C_NFFT_MAX/2*2)*(C_ARCH MOD 2))-1 DOWNTO 0) := (OTHERS => '0');  -- Channel 6 scaling schedule
      SCALE_SCH6_WE  : IN STD_LOGIC                                                                     := '0';              -- Channel 6 write enable for SCALE_SCH
      SCALE_SCH7     : IN STD_LOGIC_VECTOR((C_NFFT_MAX*2)-((C_NFFT_MAX/2*2)*(C_ARCH MOD 2))-1 DOWNTO 0) := (OTHERS => '0');  -- Channel 7 scaling schedule
      SCALE_SCH7_WE  : IN STD_LOGIC                                                                     := '0';              -- Channel 7 write enable for SCALE_SCH
      SCALE_SCH8     : IN STD_LOGIC_VECTOR((C_NFFT_MAX*2)-((C_NFFT_MAX/2*2)*(C_ARCH MOD 2))-1 DOWNTO 0) := (OTHERS => '0');  -- Channel 8 scaling schedule
      SCALE_SCH8_WE  : IN STD_LOGIC                                                                     := '0';              -- Channel 8 write enable for SCALE_SCH
      SCALE_SCH9     : IN STD_LOGIC_VECTOR((C_NFFT_MAX*2)-((C_NFFT_MAX/2*2)*(C_ARCH MOD 2))-1 DOWNTO 0) := (OTHERS => '0');  -- Channel 9 scaling schedule
      SCALE_SCH9_WE  : IN STD_LOGIC                                                                     := '0';              -- Channel 9 write enable for SCALE_SCH
      SCALE_SCH10    : IN STD_LOGIC_VECTOR((C_NFFT_MAX*2)-((C_NFFT_MAX/2*2)*(C_ARCH MOD 2))-1 DOWNTO 0) := (OTHERS => '0');  -- Channel 10 scaling schedule
      SCALE_SCH10_WE : IN STD_LOGIC                                                                     := '0';              -- Channel 10 write enable for SCALE_SCH
      SCALE_SCH11    : IN STD_LOGIC_VECTOR((C_NFFT_MAX*2)-((C_NFFT_MAX/2*2)*(C_ARCH MOD 2))-1 DOWNTO 0) := (OTHERS => '0');  -- Channel 11 scaling schedule
      SCALE_SCH11_WE : IN STD_LOGIC                                                                     := '0';              -- Channel 11 write enable for SCALE_SCH

      -- Outputs independent of number of channels
      RFD      : OUT STD_LOGIC;                                -- Ready for data: XN_INDEX is valid
      XN_INDEX : OUT STD_LOGIC_VECTOR(C_NFFT_MAX-1 DOWNTO 0);  -- Input data sample number (precedes input data by 3 clock cycles)
      BUSY     : OUT STD_LOGIC;                                -- Transform is in progress
      EDONE    : OUT STD_LOGIC;                                -- Early indication of end of transform, 1 clock cycle before DONE
      DONE     : OUT STD_LOGIC;                                -- Indicates the end of the transform, so data can be unloaded
      DV       : OUT STD_LOGIC;                                -- Data valid: XK_RE, XK_IM and XK_INDEX are valid
      XK_INDEX : OUT STD_LOGIC_VECTOR(C_NFFT_MAX-1 DOWNTO 0);  -- Output data sample number

      -- Outputs for single channel (C_CHANNELS = 1)
      XK_RE   : OUT STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 DOWNTO 0);  -- Output data, real part
      XK_IM   : OUT STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 DOWNTO 0);  -- Output data, imaginary part
      BLK_EXP : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);                 -- Block exponent
      OVFLO   : OUT STD_LOGIC;                                    -- Overflow occurred

      -- Outputs for multichannel (C_CHANNELS > 1)
      XK0_RE    : OUT STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 DOWNTO 0);  -- Channel 0 output data, real part
      XK0_IM    : OUT STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 DOWNTO 0);  -- Channel 0 output data, imaginary part
      XK1_RE    : OUT STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 DOWNTO 0);  -- Channel 1 output data, real part
      XK1_IM    : OUT STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 DOWNTO 0);  -- Channel 1 output data, imaginary part
      XK2_RE    : OUT STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 DOWNTO 0);  -- Channel 2 output data, real part
      XK2_IM    : OUT STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 DOWNTO 0);  -- Channel 2 output data, imaginary part
      XK3_RE    : OUT STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 DOWNTO 0);  -- Channel 3 output data, real part
      XK3_IM    : OUT STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 DOWNTO 0);  -- Channel 3 output data, imaginary part
      XK4_RE    : OUT STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 DOWNTO 0);  -- Channel 4 output data, real part
      XK4_IM    : OUT STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 DOWNTO 0);  -- Channel 4 output data, imaginary part
      XK5_RE    : OUT STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 DOWNTO 0);  -- Channel 5 output data, real part
      XK5_IM    : OUT STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 DOWNTO 0);  -- Channel 5 output data, imaginary part
      XK6_RE    : OUT STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 DOWNTO 0);  -- Channel 6 output data, real part
      XK6_IM    : OUT STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 DOWNTO 0);  -- Channel 6 output data, imaginary part
      XK7_RE    : OUT STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 DOWNTO 0);  -- Channel 7 output data, real part
      XK7_IM    : OUT STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 DOWNTO 0);  -- Channel 7 output data, imaginary part
      XK8_RE    : OUT STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 DOWNTO 0);  -- Channel 8 output data, real part
      XK8_IM    : OUT STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 DOWNTO 0);  -- Channel 8 output data, imaginary part
      XK9_RE    : OUT STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 DOWNTO 0);  -- Channel 9 output data, real part
      XK9_IM    : OUT STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 DOWNTO 0);  -- Channel 9 output data, imaginary part
      XK10_RE   : OUT STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 DOWNTO 0);  -- Channel 10 output data, real part
      XK10_IM   : OUT STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 DOWNTO 0);  -- Channel 10 output data, imaginary part
      XK11_RE   : OUT STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 DOWNTO 0);  -- Channel 11 output data, real part
      XK11_IM   : OUT STD_LOGIC_VECTOR(C_OUTPUT_WIDTH-1 DOWNTO 0);  -- Channel 11 output data, imaginary part
      BLK_EXP0  : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);                 -- Channel 0 block exponent
      BLK_EXP1  : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);                 -- Channel 1 block exponent
      BLK_EXP2  : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);                 -- Channel 2 block exponent
      BLK_EXP3  : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);                 -- Channel 3 block exponent
      BLK_EXP4  : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);                 -- Channel 4 block exponent
      BLK_EXP5  : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);                 -- Channel 5 block exponent
      BLK_EXP6  : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);                 -- Channel 6 block exponent
      BLK_EXP7  : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);                 -- Channel 7 block exponent
      BLK_EXP8  : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);                 -- Channel 8 block exponent
      BLK_EXP9  : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);                 -- Channel 9 block exponent
      BLK_EXP10 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);                 -- Channel 10 block exponent
      BLK_EXP11 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);                 -- Channel 11 block exponent
      OVFLO0    : OUT STD_LOGIC;                                    -- Channel 0 overflow occurred
      OVFLO1    : OUT STD_LOGIC;                                    -- Channel 1 overflow occurred
      OVFLO2    : OUT STD_LOGIC;                                    -- Channel 2 overflow occurred
      OVFLO3    : OUT STD_LOGIC;                                    -- Channel 3 overflow occurred
      OVFLO4    : OUT STD_LOGIC;                                    -- Channel 4 overflow occurred
      OVFLO5    : OUT STD_LOGIC;                                    -- Channel 5 overflow occurred
      OVFLO6    : OUT STD_LOGIC;                                    -- Channel 6 overflow occurred
      OVFLO7    : OUT STD_LOGIC;                                    -- Channel 7 overflow occurred
      OVFLO8    : OUT STD_LOGIC;                                    -- Channel 8 overflow occurred
      OVFLO9    : OUT STD_LOGIC;                                    -- Channel 9 overflow occurred
      OVFLO10   : OUT STD_LOGIC;                                    -- Channel 10 overflow occurred
      OVFLO11   : OUT STD_LOGIC                                     -- Channel 11 overflow occurred
      );
    --core_if off
  END COMPONENT;

END xfft_v4_0_xst_comp;
