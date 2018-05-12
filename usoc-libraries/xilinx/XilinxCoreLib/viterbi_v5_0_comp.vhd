--  Copyright(C) 2004 by Xilinx, Inc. All rights reserved.
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

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

Library XilinxCoreLib;
USE XilinxCoreLib.prims_constants_v7_0.ALL;


PACKAGE viterbi_v5_0_comp IS

   COMPONENT viterbi_v5_0
      GENERIC (
         c_mem_init_prefix       : STRING  :="vitv5";
		   c_ber_rate              : INTEGER := 0;
		   c_best_state_bwr        : INTEGER := 2;
		   c_channel_count         : INTEGER := 1;
		   c_constraint_length     : INTEGER := 3;
		   c_convcode0_radix       : INTEGER := 0;
		   c_convcode1_radix       : INTEGER := 2;
		   c_convolution0_code0    : INTEGER := 7;
		   c_convolution0_code1    : INTEGER := 5;
		   c_convolution0_code2    : INTEGER := 0;
		   c_convolution0_code3    : INTEGER := 0;
		   c_convolution0_code4    : INTEGER := 0;
		   c_convolution0_code5    : INTEGER := 0;
		   c_convolution0_code6    : INTEGER := 0;
		   c_convolution1_code0    : INTEGER := 0;
		   c_convolution1_code1    : INTEGER := 0;
		   c_convolution1_code2    : INTEGER := 0;
		   c_convolution1_code3    : INTEGER := 0;
		   c_convolution1_code4    : INTEGER := 0;
		   c_convolution1_code5    : INTEGER := 0;
		   c_convolution1_code6    : INTEGER := 0;
		   c_direct_tb_max         : INTEGER := 0;
		   c_dual_decoder          : INTEGER := 0;
		   c_has_aclr              : INTEGER := 0;
		   c_has_ber               : INTEGER := 0;
		   c_has_best_state        : INTEGER := 0;
		   c_has_block_valid       : INTEGER := 0;
         c_has_ce                : INTEGER := 0;
		   c_has_erased            : INTEGER := 0;
		   c_has_fd                : INTEGER := 0;
		   c_has_norm              : INTEGER := 0;
		   c_has_rdy               : INTEGER := 0;
		   c_has_rffd              : INTEGER := 0;
		   c_has_sclr              : INTEGER := 0;
		   c_has_sync              : INTEGER := 0;
		   c_has_sync_thresh       : INTEGER := 0;
		   c_max_rate              : INTEGER := 2;
		   c_output_rate0          : INTEGER := 2;
		   c_output_rate1          : INTEGER := 0;
         c_ps_state              : INTEGER := 0;
		   c_punctured             : INTEGER := 0;
		   c_punc_code0            : INTEGER := 0;
		   c_punc_code1            : INTEGER := 0;
		   c_punc_input_rate       : INTEGER := 0;
		   c_radix4                : INTEGER := 0;
		   c_red_latency           : INTEGER := 0;
		   c_serial                : INTEGER := 0;
		   c_soft_code             : INTEGER := 0;
		   c_soft_coding           : INTEGER := 1;
		   c_soft_width            : INTEGER := 3;
		   c_sync_ber_thresh       : INTEGER := 0;
		   c_sync_norm_thresh      : INTEGER := 0;
         c_tb_state              : INTEGER := 0;
		   c_traceback_length      : INTEGER := 18;
		   c_trellis_mode          : INTEGER := 0;

         c_family                : STRING  := "virtex2"
      );   
      PORT (
         DATA_IN0       : IN STD_LOGIC_VECTOR(c_soft_width-1 DOWNTO 0):= (OTHERS => '0');
         DATA_IN1       : IN STD_LOGIC_VECTOR(c_soft_width-1 DOWNTO 0):= (OTHERS => '0');
         DATA_IN2       : IN STD_LOGIC_VECTOR(c_soft_width-1 DOWNTO 0):= (OTHERS => '0');
         DATA_IN3       : IN STD_LOGIC_VECTOR(c_soft_width-1 DOWNTO 0):= (OTHERS => '0');
         DATA_IN4       : IN STD_LOGIC_VECTOR(c_soft_width-1 DOWNTO 0):= (OTHERS => '0');
         DATA_IN5       : IN STD_LOGIC_VECTOR(c_soft_width-1 DOWNTO 0):= (OTHERS => '0');
         DATA_IN6       : IN STD_LOGIC_VECTOR(c_soft_width-1 DOWNTO 0):= (OTHERS => '0');

         TCM00          : IN STD_LOGIC_VECTOR(c_soft_width DOWNTO 0):= (OTHERS => '0');
         TCM01          : IN STD_LOGIC_VECTOR(c_soft_width DOWNTO 0):= (OTHERS => '0');
         TCM10          : IN STD_LOGIC_VECTOR(c_soft_width DOWNTO 0):= (OTHERS => '0');
         TCM11          : IN STD_LOGIC_VECTOR(c_soft_width DOWNTO 0):= (OTHERS => '0');

         SECTOR_IN      : IN STD_LOGIC_VECTOR(3 DOWNTO 0):= (OTHERS => '0');
         BLOCK_IN       : IN STD_LOGIC:= '0';
      
         packet_start   : IN STD_LOGIC:= '0';
         tb_block       : IN STD_LOGIC:= '0';
         ps_state       : IN STD_LOGIC_VECTOR(c_constraint_length-2 DOWNTO 0):= (OTHERS => '0');
         tb_state       : IN STD_LOGIC_VECTOR(c_constraint_length-2 DOWNTO 0):= (OTHERS => '0'); 
         
         BIT_ERROR_THRESH : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
         NORM_THRESH    : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
      
         ERASE          : IN STD_LOGIC_VECTOR(c_max_rate-1 DOWNTO 0):= (OTHERS => '0');

         DATA_OUT       : OUT STD_LOGIC;
         
         DATA_OUT_DIRECT  : OUT STD_LOGIC;
         DATA_OUT_REVERSE : OUT STD_LOGIC;
         PACKET_START_O : OUT STD_LOGIC;
         TB_BLOCK_O     : OUT STD_LOGIC;
         DIRECT_RDY     : OUT STD_LOGIC;
         REVERSE_RDY    : OUT STD_LOGIC;
      
         BER            : OUT STD_LOGIC_VECTOR(16-1 DOWNTO 0);
         BER_DONE       : OUT STD_LOGIC;
         NORM           : OUT STD_LOGIC;
      
         SECTOR_OUT     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
         BLOCK_OUT      : OUT STD_LOGIC;
         OUT_OF_SYNC    : OUT STD_LOGIC;
         
         SEL            : IN STD_LOGIC := '0';
         SEL_O          : OUT STD_LOGIC := '0';
            
         ND             : IN STD_LOGIC := '0';
         FD             : IN STD_LOGIC := '0';
         RFFD           : OUT STD_LOGIC;
         RFD            : OUT STD_LOGIC;
         RDY            : OUT STD_LOGIC;
         CE             : IN STD_LOGIC := '0';
         ACLR           : IN STD_LOGIC := '0';
         SCLR           : IN STD_LOGIC := '0';
         CLK            : IN STD_LOGIC
      );
   END COMPONENT;
-- The following tells XST that viterbi_v5_0 is a black box which  
-- should be generated command given by the value of this attribute 
-- Note the fully qualified SIM (JAVA class) name that forms the 
-- basis of the core 
attribute box_type : string; 
attribute box_type of VITERBI_v5_0 : component is "black_box"; 
attribute GENERATOR_DEFAULT : string; 
attribute GENERATOR_DEFAULT of VITERBI_v5_0 : component is 
          "generatecore com.xilinx.ip.viterbi_v5_0.viterbi_v5_0"; 
END viterbi_v5_0_comp;
