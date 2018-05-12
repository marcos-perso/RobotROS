--------------------------------------------------------------------------------
-- $Header: /local/Projects/CVS/P1/zpu_SoC/sources/xilinx/XilinxCoreLib/addr_gen_802_16e_v2_0_xst.vhd,v 1.1 2010-07-10 21:42:30 mmartinez Exp $
--------------------------------------------------------------------------------
-- Copyright (c) 2004-2005 Xilinx, Inc.
-- All Rights Reserved
--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor: Xilinx
-- \   \   \/    Version: 1.1
--  \   \        Filename: addr_gen_802_16_v1_1_xst.vhd
--  /   /        Date Last Modified: 
-- /___/   /\    Date Created: 09/May/2005
-- \   \  /  \
--  \___\/\___\
-- 
--Device: Xilinx
--Library: none
--Purpose: Component declaration package
--Revision History:
--    Rev 1 : Dummy model creation
--------------------------------------------------------------------------------
-- 
-- This text contains proprietary, confidential information of Xilinx, Inc.,
-- is distributed under license from Xilinx, Inc., and may be used, copied
-- and/or disclosed only pursuant to the terms of a valid license agreement
-- with Xilinx, Inc.
-- This copyright notice must be retained as part of this text at all times.
--
-------------------------------------------------------------------------------
-- Authors : Richard Geddes
-------------------------------------------------------------------------------
-- Description:
-- 
-- VHDL behavioral model
--
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY xilinxcorelib;
USE xilinxcorelib.addr_gen_802_16e_v2_0_comp.ALL;

entity addr_gen_802_16e_v2_0_xst is
  generic
  (
    C_ADDR_WIDTH    : integer := 12;
    C_HAS_ACLR      : integer := 0;
    C_HAS_CE        : integer := 1;
    C_HAS_OP_NEXT   : integer := 1;
    C_HAS_SCLR      : integer := 1;
    C_HAS_START_ENC : integer := 1;
    C_MODE          : integer := 0;--CONST_PKG_mixed_2cycle;
    C_USE_BASEBLOX  : integer := 0
  );
  port
  (
    -- System CLK, ACLR, SCLR and CE
    CLK             : in  std_logic;
    ACLR            : in  std_logic;
    SCLR            : in  std_logic;
    CE              : in  std_logic;

    -- Input
    START           : in  std_logic;
    BLK_SEL         : in  std_logic_vector(4 downto 0);

    -- Output
    OP_NEXT         : out std_logic;
    START_ENC       : out std_logic;
    ADDR            : out std_logic_vector(c_addr_width-1 downto 0)

  );

end entity addr_gen_802_16e_v2_0_xst;

architecture behavioral of addr_gen_802_16e_v2_0_xst is
begin

  ag1 : addr_gen_802_16e_v2_0
  generic map
  (
    C_ADDR_WIDTH    => C_ADDR_WIDTH,
    C_HAS_ACLR      => C_HAS_ACLR,
    C_HAS_OP_NEXT   => C_HAS_OP_NEXT,
    C_HAS_START_ENC => C_HAS_START_ENC,
    C_HAS_CE        => C_HAS_CE,
    C_HAS_SCLR      => C_HAS_SCLR,
    C_MODE          => C_MODE,
    C_USE_BASEBLOX  => C_USE_BASEBLOX
  )
  port map
  (
    CLK             => CLK,
    ACLR            => ACLR,
    SCLR            => SCLR,
    CE              => CE,
    START           => START,
    BLK_SEL         => BLK_SEL,
    OP_NEXT			=> OP_NEXT,
    START_ENC       => START_ENC,
    ADDR            => ADDR         
  );

end architecture behavioral;
