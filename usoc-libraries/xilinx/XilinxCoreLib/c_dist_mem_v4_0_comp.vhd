-- $Id: c_dist_mem_v4_0_comp.vhd,v 1.1 2010-07-10 21:42:43 mmartinez Exp $
--
-- Filename - c_dist_mem_v4_0_comp.vhd
-- Author - Xilinx
-- Creation - 24 Mar 1999
--
-- Description - This file contains the component declaration for
--				 the C_DIST_MEM_V4_0 core

Library IEEE;
Use IEEE.std_logic_1164.all;

Library XilinxCoreLib;
Use XilinxCoreLib.prims_constants_v4_0.all;

package c_dist_mem_v4_0_comp is


----- Component C_DIST_MEM_V4_0 -----
-- Short Description
--
-- Distributed memory
--

component C_DIST_MEM_V4_0
	GENERIC (
            C_ADDR_WIDTH     : integer := 6;
            C_DEFAULT_DATA   : string  := "0";
	    C_DEFAULT_DATA_RADIX : integer := 1;
            C_DEPTH          : integer := 64;
            C_ENABLE_RLOCS   : integer := 1;   -- Unused by the behavioural model
            C_GENERATE_MIF   : integer := 0;   -- Unused by the behavioural model
            C_HAS_CLK        : integer := 1;
            C_HAS_D          : integer := 1;
            C_HAS_DPO        : integer := 0;
            C_HAS_DPRA       : integer := 0;
            C_HAS_I_CE       : integer := 0;
            C_HAS_QDPO       : integer := 0;
            C_HAS_QDPO_CE    : integer := 0;
            C_HAS_QDPO_CLK   : integer := 0;
            C_HAS_QDPO_RST   : integer := 0;    -- RSTA
	    C_HAS_QDPO_SRST	: integer := 0;
            C_HAS_QSPO       : integer := 0;
            C_HAS_QSPO_CE    : integer := 0;
            C_HAS_QSPO_RST   : integer := 0;    --RSTB
	    C_HAS_QSPO_SRST	: integer := 0;
            C_HAS_RD_EN      : integer := 0;
            C_HAS_SPO        : integer := 1;
            C_HAS_SPRA       : integer := 0;
            C_HAS_WE         : integer := 1;
            C_LATENCY    : integer := 0;
            C_MEM_INIT_FILE  : string  := "null.mif";
            C_MEM_TYPE       : integer := c_sp_ram;
            C_MUX_TYPE       : integer := c_lut_based;
            C_QUALIFY_WE     : integer := 0;
            C_QCE_JOINED     : integer := 0;
            C_READ_MIF       : integer := 0;
            C_REG_A_D_INPUTS : integer := 0;
            C_REG_DPRA_INPUT : integer := 0;
	    C_SYNC_ENABLE    : integer := 0;
            C_WIDTH          : integer := 16;
	    C_RAM32_FIX      : integer := 0	-- should not be passed in to simulation model
  );
  
  PORT (A        : in  std_logic_vector(C_ADDR_WIDTH-1-(4*C_HAS_SPRA*boolean'pos(C_ADDR_WIDTH>4)) downto 0) := (OTHERS => '0');
        D        : in  std_logic_vector(C_WIDTH-1 downto 0) := (OTHERS => '0');
        DPRA     : in  std_logic_vector(C_ADDR_WIDTH-1 downto 0) := (OTHERS => '0');
        SPRA     : in  std_logic_vector(C_ADDR_WIDTH-1 downto 0) := (OTHERS => '0');
        CLK      : in  std_logic := '0';
        WE       : in  std_logic := '0';
        I_CE     : in  std_logic := '1';
        RD_EN    : in  std_logic := '0';
        QSPO_CE  : in  std_logic := '1';
        QDPO_CE  : in  std_logic := '1';
        QDPO_CLK : in  std_logic := '0';
        QSPO_RST : in std_logic := '0';
        QDPO_RST : in std_logic := '0';
	QSPO_SRST : in std_logic := '0';
	QDPO_SRST : in std_logic := '0';
        SPO      : out std_logic_vector(C_WIDTH-1 downto 0);
        DPO      : out std_logic_vector(C_WIDTH-1 downto 0);
        QSPO     : out std_logic_vector(C_WIDTH-1 downto 0);
        QDPO     : out std_logic_vector(C_WIDTH-1 downto 0)
	); 
end component;

end c_dist_mem_v4_0_comp;
