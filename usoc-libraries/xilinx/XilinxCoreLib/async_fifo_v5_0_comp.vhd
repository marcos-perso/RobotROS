-- Copyright(C) 2002 by Xilinx, Inc. All rights reserved.
-- This text contains proprietary, confidential
-- information of Xilinx, Inc., is distributed
-- under license from Xilinx, Inc., and may be used,
-- copied and/or disclosed only pursuant to the terms
-- of a valid license agreement with Xilinx, Inc. This copyright
-- notice must be retained as part of this text at all times.

--
-------------------------------------------------------------------------------
-- $RCSfile: async_fifo_v5_0_comp.vhd,v $ $Revision: 1.1 $ $Date: 2010-07-10 21:42:30 $
-------------------------------------------------------------------------------
--
-- Async Fifo - VHDL Behavioral Model Component Declaration
--
-------------------------------------------------------------------------------
--                                                                       
-- Copyright(C) 2002 by Xilinx, Inc. All rights reserved.
-- This text contains proprietary, confidential
-- information of Xilinx, Inc., is distributed
-- under license from Xilinx, Inc., and may be used,
-- copied and/or disclosed only pursuant to the terms
-- of a valid license agreement with Xilinx, Inc. This copyright
-- notice must be retained as part of this text at all times.
--
-------------------------------------------------------------------------------
--
-- Filename: async_fifo_v5_0_comp.vhd
--
-- Description: 
--  The behavioral model for the asynchronous FIFO core.
--                      
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE async_fifo_v5_0_comp IS

 COMPONENT async_fifo_v5_0 
    GENERIC (c_enable_rlocs         : INTEGER := 0;
             c_data_width           : INTEGER := 16;
             c_fifo_depth           : INTEGER := 63;
             c_has_almost_full      : INTEGER := 1;
             c_has_almost_empty     : INTEGER := 1;
             c_has_wr_count         : INTEGER := 1;
             c_has_rd_count         : INTEGER := 1;             
             c_wr_count_width       : INTEGER := 2;
	     c_rd_count_width       : INTEGER := 2;
	     c_has_rd_ack	    : INTEGER := 0;
	     c_rd_ack_low	    : INTEGER := 0;
	     c_has_rd_err	    : INTEGER := 0;
             c_rd_err_low	    : INTEGER := 0;
	     c_has_wr_ack	    : INTEGER := 0;
	     c_wr_ack_low	    : INTEGER := 0;
	     c_has_wr_err	    : INTEGER := 0;
	     c_wr_err_low	    : INTEGER := 0;
             c_use_blockmem         : INTEGER := 1   
            );
       PORT (din            : IN STD_LOGIC_VECTOR(c_data_width-1 DOWNTO 0) := (OTHERS => '0');
             wr_en          : IN STD_LOGIC := '1';
             wr_clk         : IN STD_LOGIC := '1';
             rd_en          : IN STD_LOGIC := '0';
             rd_clk         : IN STD_LOGIC := '1';
             ainit          : IN STD_LOGIC := '1';   
             dout           : OUT STD_LOGIC_VECTOR(c_data_width-1 DOWNTO 0);
             full           : OUT STD_LOGIC; 
             empty          : OUT STD_LOGIC; 
             almost_full    : OUT STD_LOGIC;  --optional. default=false
             almost_empty   : OUT STD_LOGIC;  --optional. default=false
             wr_count       : OUT STD_LOGIC_VECTOR(c_wr_count_width-1 DOWNTO 0);
                              --optional. default=true
             rd_count       : OUT STD_LOGIC_VECTOR(c_rd_count_width-1 DOWNTO 0);
                              --optional. default=false
             rd_ack	    : OUT STD_LOGIC;
             rd_err  	    : OUT STD_LOGIC;
             wr_ack	    : OUT STD_LOGIC;
             wr_err         : OUT STD_LOGIC
             ); 
 END COMPONENT;

END async_fifo_v5_0_comp;
