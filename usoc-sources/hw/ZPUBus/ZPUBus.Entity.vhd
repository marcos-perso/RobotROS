-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- ZPU Bus
--
-- NOTES:
--
-- $Author:$
-- $Date:$
-- $Name:$
-- $Revision:$
--
-------------------------------------------------------------------------------


---------------
-- LIBRARIES --
---------------

library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.zpu_config.all;
use work.zpupkg.all;
-- synopsys translate off
use work.txt_util.all;
-- synopsys translate on
use work.WishboneConstantsPackage.all;

-----------------------
-- ENTITY DEFINITION --
-----------------------
 
entity ZPUBus is
  port(

    -- clock & reset
    clk   : in std_logic;
    reset : in std_logic;

    -- ROM interface (wishbone)
    ACK_I  : in  std_logic;
    ADDR_O : out std_logic_vector(c_WishboneAddrWidth - 1 downto 0);
    DAT_O  : out std_logic_vector(c_WishboneDataWidth - 1 downto 0);
    DAT_I  : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0);
    STB_O  : out std_logic;
    WE_O   : out std_logic;
    

    -- RAM interfac
    ram_busy      : in  std_logic;                                        
    ram_address   : out std_logic_vector(9 downto 0);
    ram_DataWrite : out std_logic_vector(wordSize-1 downto 0);
    ram_DataRead  : in  std_logic_vector(wordSize-1 downto 0);
    ram_WE        : out std_logic;

    -- WB interface
    WB_busy      : in  std_logic;                                        
    WB_address   : out std_logic_vector(maxAddrBitIncIO downto 0);
    WB_DataWrite : out std_logic_vector(wordSize-1 downto 0);
    WB_DataRead  : in  std_logic_vector(wordSize-1 downto 0);
    WB_WE        : out std_logic;
    WB_RE        : out std_logic;

    -- ZPU interface
    zpu_mem_busy      : out std_logic; 
    zpu_mem_read      : out std_logic_vector(wordSize-1 downto 0);
    zpu_writeEnable   : in  std_logic; 
    zpu_readEnable    : in  std_logic;
    zpu_mem_addr      : in  std_logic_vector(maxAddrBitIncIO downto 0);
    zpu_mem_write     : in  std_logic_vector(wordSize-1 downto 0);	  
    zpu_mem_writeMask : in  std_logic_vector(wordBytes-1 downto 0)


    );      
end ZPUBus;
   

-------------------------------------------------------------------------------
-- $Log:$
-------------------------------------------------------------------------------
