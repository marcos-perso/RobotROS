
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

package wbMemoryWrapperControlComponentPackage is

--------------------------
-- COMPONENT DEFINITION --
--------------------------
 
  component wbMemoryWrapperControl is
    generic (
      c_NbAddressBits : integer;
      c_NbDataBits    : integer;
      g_base_address  : integer;     -- Base address
      g_offset        : integer      -- Max offset
      );
    port(

      -- Wishbone interface
      CLK_I  : in  std_logic;                                        -- Input clock
      RST_I  : in  std_logic;                                       -- Input reset

      ACK_O  : out std_logic;                                       -- Acknowdledge
      ADDR_I : in  std_logic_vector(c_WishboneAddrWidth - 1 downto 0);
      DAT_I  : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0);  -- Data Input
      DAT_O  : out std_logic_vector(c_WishboneDataWidth - 1 downto 0);  -- Data Output
      STB_I  : in  std_logic;                                       -- Strobe In
      WE_I   : in  std_logic;                                       -- Write Enable

      -- Interface to the real memory
      o_Control : out std_logic;          -- Control the muxes
      o_Data    : out std_logic_VECTOR(c_NbDataBits - 1 downto 0);  -- Data to the memory
      i_Data    : in  std_logic_VECTOR(c_NbDataBits - 1 downto 0);  -- Data from the memory
      o_Address : out std_logic_VECTOR(c_NbAddressBits - 1 downto 0);  -- Address to the memory
      o_WE      : out std_logic_VECTOR(0 downto 0)   -- WE to the memory

      );
  end component;

end wbMemoryWrapperControlComponentPackage;
