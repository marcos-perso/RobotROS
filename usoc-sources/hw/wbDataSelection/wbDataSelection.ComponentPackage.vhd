-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- Wishbone data selection block
--
-- NOTES:
--
-- $Author: mmartinez $
-- $Date: 2010-07-10 21:55:14 $
-- $Name:  $
-- $Revision: 1.1 $
--
-------------------------------------------------------------------------------

---------------
-- LIBRARIES --
---------------

-- IEEE libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Project libraries
library work;
use work.zpu_config.all;
use work.zpupkg.all;
use work.WishboneConstantsPackage.all;

----------------------------------
-- COMPONENT PACKAGE DEFINITION --
----------------------------------

package wbDataSelectionComponentPackage is

--------------------------
-- COMPONENT DEFINITION --
--------------------------

  component wbDataSelection is
    port(

      -- WISHBONE DATA from the different slaves
      DATA_SLAVE_0 : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0);
      DATA_SLAVE_1 : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0);
      DATA_SLAVE_2 : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0);
      DATA_SLAVE_3 : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0);
      DATA_SLAVE_4 : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0);
      DATA_SLAVE_5 : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0);
      DATA_SLAVE_6 : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0);
      DATA_SLAVE_7 : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0);
      -- ACTIVATION signals for each slave
      ACTIVATE_0   : in  std_logic;
      ACTIVATE_1   : in  std_logic;
      ACTIVATE_2   : in  std_logic;
      ACTIVATE_3   : in  std_logic;
      ACTIVATE_4   : in  std_logic;
      ACTIVATE_5   : in  std_logic;
      ACTIVATE_6   : in  std_logic;
      ACTIVATE_7   : in  std_logic;
      -- WISHBONE DATA to the master
      DATA_MASTER  : out std_logic_vector(c_WishboneDataWidth - 1 downto 0)

    );      
  end component;

end wbDataSelectionComponentPackage;
   
-------------------------------------------------------------------------------
-- $Log: wbDataSelectionComponentPackage.vhd,v $
-- Revision 1.1  2010-07-10 21:55:14  mmartinez
-- Files imported
--
-- Revision 1.4  2010-07-10 08:20:59  mmartinez
-- Separation between FLASH and DRAM
--
-- Revision 1.3  2010-07-08 14:58:11  mmartinez
-- Addition of the single port external RAM to the WB system
--
-- Revision 1.2  2010-06-17 22:41:34  mmartinez
-- Basic behaviour completed
--
-- Revision 1.1  2010-06-11 20:42:59  mmartinez
-- File creation
--
-------------------------------------------------------------------------------
