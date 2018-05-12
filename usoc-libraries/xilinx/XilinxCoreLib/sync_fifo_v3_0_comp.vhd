-- ************************************************************************
-- $Id: sync_fifo_v3_0_comp.vhd,v 1.1 2010-07-10 21:43:23 mmartinez Exp $
-- ************************************************************************
--  Copyright 2000 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************
--
--  Description:
--   Compontent declaration
--   Synchronous FIFO Simulation Model

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE sync_fifo_v3_0_comp IS


COMPONENT sync_fifo_v3_0 
    GENERIC (
              c_dcount_width       :    integer := 1;
              c_enable_rlocs       :    integer := 0;
              c_has_dcount         :    integer := 0 ;
              c_has_rd_ack         :    integer := 0 ;
              c_has_rd_err         :    integer := 0 ;
              c_has_wr_ack         :    integer := 0 ;
              c_has_wr_err         :    integer := 0 ;
              c_memory_type        :    integer := 0 ;
              c_ports_differ       :    integer := 0 ;
              c_rd_ack_low         :    integer := 0 ;
              c_read_data_width    :    integer := 0 ;
              c_read_depth         :    integer := 16 ;
              c_rd_err_low         :    integer := 0 ;
              c_wr_ack_low         :    integer := 0 ;
              c_wr_err_low         :    integer := 0 ;
              c_write_data_width   :    integer := 0 ;
              c_write_depth        :    integer := 16
              );
    port (  CLK          : in std_logic;
            SINIT        : in std_logic;
            DIN          : in  std_logic_vector(c_write_data_width-1 downto 0);
            WR_EN        : in std_logic;
            RD_EN        : in  std_logic;
            DOUT         : out std_logic_vector(c_read_data_width-1 downto 0);
            FULL         : out std_logic;
            EMPTY        : out std_logic;
            RD_ACK       : out std_logic;
            WR_ACK       : out std_logic;
            RD_ERR       : out std_logic;
            WR_ERR       : out std_logic;
            DATA_COUNT   : out std_logic_vector(c_dcount_width-1 downto 0)
           );
end COMPONENT;


END sync_fifo_v3_0_comp;
