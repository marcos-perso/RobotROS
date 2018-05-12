-------------------------------------------------------------------------------
-- Wishbone interconnections
-------------------------------------------------------------------------------

---------------
-- LIBRARIES --
---------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SOCConstantsPackage.all;
use work.WishboneConstantsPackage.all;

----------------------------------
-- COMPONENT PACKAGE DEFINITION --
----------------------------------

package wbInterconComponentPackage is

--------------------------
-- COMPONENT DEFINITION --
--------------------------
 
  component wbIntercon is

    generic (
      log_file:       string -- Debug file
      );

    port(

      -- WISHBONE CONTROL SIGNALS
      CLK_I : std_logic;                  -- Clock
      RST_I : std_logic;                  -- Reset

      -- WISHBONE MASTER PORT 1
      MASTER_1_ADDR_O : in std_logic_vector(c_WishboneAddrWidth - 1 downto 0);
      MASTER_1_DAT_O  : in std_logic_vector(c_WishboneDataWidth - 1 downto 0);
      MASTER_1_SEL_O  : in std_logic_vector(c_WishBoneSelWidth - 1 downto 0);
      MASTER_1_WE_O   : in std_logic;
      MASTER_1_CYC_O  : in std_logic;
      MASTER_1_STB_O  : in std_logic;
      MASTER_1_DAT_I  : out  std_logic_vector(c_WishboneDataWidth - 1 downto 0);
      MASTER_1_ACK_I  : out  std_logic;                                     
      MASTER_1_ERR_I  : out  std_logic;
      MASTER_1_RTY_I  : out  std_logic;

      -- WISHBONE MASTER PORT 2
      MASTER_2_ADDR_O : in std_logic_vector(c_WishboneAddrWidth - 1 downto 0);
      MASTER_2_DAT_O  : in std_logic_vector(c_WishboneDataWidth - 1 downto 0);
      MASTER_2_SEL_O  : in std_logic_vector(c_WishBoneSelWidth - 1 downto 0);
      MASTER_2_WE_O   : in std_logic;
      MASTER_2_CYC_O  : in std_logic;
      MASTER_2_STB_O  : in std_logic;
      MASTER_2_DAT_I  : out  std_logic_vector(c_WishboneDataWidth - 1 downto 0);
      MASTER_2_ACK_I  : out  std_logic;                                     
      MASTER_2_ERR_I  : out  std_logic;
      MASTER_2_RTY_I  : out  std_logic;

      -- WISHBONE SLAVE PORT (COMMON)
      SLAVE_ADDR          : out std_logic_vector(c_WishboneAddrWidth - 1 downto 0);
      SLAVE_DATA_TO_SLAVE : out std_logic_vector(c_WishboneDataWidth - 1 downto 0);
      SLAVE_WE            : out std_logic;

      -- WISHBONE SLAVE PORT (BY SLAVE)
      SLAVE_DATA_FROM_SLAVE_0 : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0);
      SLAVE_ACK_FROM_SLAVE_0  : in  std_logic;                                     
      SLAVE_ACTIVATE_0        : out std_logic;                                     
      SLAVE_STB_0             : out std_logic;
      SLAVE_DATA_FROM_SLAVE_1 : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0);
      SLAVE_ACK_FROM_SLAVE_1  : in  std_logic;                                     
      SLAVE_ACTIVATE_1        : out std_logic;                                     
      SLAVE_STB_1             : out std_logic;
      SLAVE_DATA_FROM_SLAVE_2 : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0);
      SLAVE_ACK_FROM_SLAVE_2  : in  std_logic;                                     
      SLAVE_ACTIVATE_2        : out std_logic;                                     
      SLAVE_STB_2             : out std_logic;
      SLAVE_DATA_FROM_SLAVE_3 : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0);
      SLAVE_ACK_FROM_SLAVE_3  : in  std_logic;                                     
      SLAVE_ACTIVATE_3        : out std_logic;                                     
      SLAVE_STB_3             : out std_logic;
      SLAVE_DATA_FROM_SLAVE_4 : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0);
      SLAVE_ACK_FROM_SLAVE_4  : in  std_logic;                                     
      SLAVE_ACTIVATE_4        : out std_logic;
      SLAVE_STB_4             : out std_logic;
      SLAVE_DATA_FROM_SLAVE_5 : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0);
      SLAVE_ACK_FROM_SLAVE_5  : in  std_logic;                                     
      SLAVE_ACTIVATE_5        : out std_logic;
      SLAVE_STB_5             : out std_logic;
      SLAVE_DATA_FROM_SLAVE_6 : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0);
      SLAVE_ACK_FROM_SLAVE_6  : in  std_logic;                                     
      SLAVE_ACTIVATE_6        : out std_logic;
      SLAVE_STB_6             : out std_logic;
      SLAVE_DATA_FROM_SLAVE_7 : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0);
      SLAVE_ACK_FROM_SLAVE_7  : in  std_logic;                                     
      SLAVE_ACTIVATE_7        : out std_logic;
      SLAVE_STB_7             : out std_logic
      );

  end component;

end wbInterconComponentPackage;
