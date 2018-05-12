-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- Wishbone master wrapper
--
-- NOTES:
--
-- $Author: mmartinez $
-- $Date: 2010-07-10 21:48:16 $
-- $Name:  $
-- $Revision: 1.1 $
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
 
entity wbMaster is
  port(

    -- WISHBONE MASTER interface
    CLK_I  : in  std_logic;                                        
    RST_I  : in  std_logic;                                       
    DAT_I  : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0);
    DAT_O  : out std_logic_vector(c_WishboneDataWidth - 1 downto 0);
    ACK_I  : in  std_logic;                                     
    ADDR_O : out std_logic_vector(c_WishboneAddrWidth - 1 downto 0);
    CYC_O  : out std_logic;
    LOCK_O : out std_logic;
    ERR_I  : in  std_logic;
    RTY_I  : in  std_logic;
    SEL_O  : out std_logic_vector(c_WishBoneSelWidth - 1 downto 0);
    STB_O  : out std_logic;
    TGD_I  : in  std_logic_vector(c_WishboneTagDataWidth - 1 downto 0);
    TGD_O  : out std_logic_vector(c_WishboneTagDataWidth - 1 downto 0);
    TGA_O  : out std_logic_vector(c_WishboneTagAddrWidth - 1 downto 0);
    TGC_O  : out std_logic_vector(c_WishboneTagCycleWidth - 1 downto 0);
    WE_O   : out std_logic;

    -- ZPU Bus interface
    ZPU_busy        : out std_logic; 
    ZPU_read        : out std_logic_vector(wordSize-1 downto 0);
    ZPU_writeEnable : in  std_logic; 
    ZPU_readEnable  : in  std_logic;
    ZPU_addr        : in  std_logic_vector(maxAddrBitIncIO downto 0);
    ZPU_write       : in  std_logic_vector(wordSize-1 downto 0)

    );      
end wbMaster;
   

-------------------------------------------------------------------------------
-- $Log: wbMasterEntity.vhd,v $
-- Revision 1.1  2010-07-10 21:48:16  mmartinez
-- Files imported
--
-- Revision 1.2  2010-06-10 21:10:43  mmartinez
-- *** empty log message ***
--
-- Revision 1.1  2010-06-06 20:23:22  mmartinez
-- File creation
--
-------------------------------------------------------------------------------
