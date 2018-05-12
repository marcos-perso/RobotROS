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

--
--$Revision: 1.1 $ $Date: 2010-07-10 21:42:42 $

library ieee;
use ieee.std_logic_1164.all;

package c_dds_v4_2_comp is
	
	component C_DDS_V4_2
		generic(
			C_ACCUMULATOR_LATENCY : integer     := 1; --ONE_CYCLE;
			C_ACCUMULATOR_WIDTH : integer       := 16;
			C_CHANNELS	: integer	:= 1;
			C_DATA_WIDTH : integer          := 16;
			C_ENABLE_RLOCS : integer  := 0;
			C_FREQ_RESOLUTION : string	:= "0.0";
			C_HAS_ACLR : integer    := 0;
			C_HAS_CE : integer   := 0;
			C_HAS_CHANNEL_INDEX : integer := 0;
			C_HAS_RDY : integer  := 1;
			C_HAS_RFD : integer  := 0;
			C_HAS_SCLR : integer    := 0;
			C_LATENCY : integer  := 0;
			C_MEM_TYPE : integer   := 0; --DIST_ROM;
			C_NEGATIVE_COSINE : integer    := 0;
			C_NEGATIVE_SINE : integer  := 0;
			C_NOISE_SHAPING : integer := 0;
			C_OUTPUTS_REQUIRED : integer    := 2; --SINE_AND_COSINE;
			C_OUTPUT_FREQUENCIES : string := "0";
			C_OUTPUT_WIDTH : integer     := 16;
			C_PHASE_ANGLE_WIDTH : integer     := 4;
			C_PHASE_INCREMENT : integer        := 1; --REG;
			C_PHASE_INCREMENT_VALUE : string      := "0";
			C_PHASE_OFFSET : integer      := 2; --CONST;
			C_PHASE_OFFSET_ANGLES : string	:= "0";
			C_PHASE_OFFSET_VALUE : string        := "0";
			C_PIPELINED : integer     := 1;
			C_REF_CLK_RATE : string	:= "0.0";
			C_SFDR : string := "0.0";
			useSystemParameters : integer := 0
			);
		port(
			a : in STD_LOGIC := '0';
			aclr : in STD_LOGIC := '0';
			ce : in STD_LOGIC := '0';
			clk : in STD_LOGIC;
			sclr : in STD_LOGIC := '0';
			we : in STD_LOGIC := '0';
			data : in STD_LOGIC_VECTOR (C_DATA_WIDTH-1 downto 0)
			:= (others=>'0');
			rdy : out STD_LOGIC;
			rfd : out STD_LOGIC;
			cosine : out STD_LOGIC_VECTOR (C_OUTPUT_WIDTH-1 downto 0);
			sine : out STD_LOGIC_VECTOR (C_OUTPUT_WIDTH-1 downto 0)
			);
	end component;
	
end c_dds_v4_2_comp;
