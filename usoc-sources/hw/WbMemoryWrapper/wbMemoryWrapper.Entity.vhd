-------------------------------------------------------------------------------
-- Wrapper around a memory that allow both WB operation or direct operation
-- TBD:
-------------------------------------------------------------------------------

---------------
-- LIBRARIES --
---------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.SOCConstantsPackage.all;
use work.WishboneConstantsPackage.all;

-----------------------
-- ENTITY DEFINITION --
-----------------------
 
entity wbMemoryWrapper is
  generic (
    c_NbAddressBits : integer;
    c_NbDataBits    : integer;
    g_base_address  : integer;      -- Base address
    g_offset        : integer      -- Base address
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

    -- Interface to direct memory
    i_AddrToMemIn  : in  std_logic_VECTOR(c_NbAddressBits - 1 downto 0);  -- Address to the memory
    i_AddrToMemOut : in  std_logic_VECTOR(c_NbAddressBits - 1 downto 0);  -- Address to the memory
    i_WEToMemIn    : in  std_logic_vector(0 downto 0);
    i_DataToMem    : in  std_logic_VECTOR(c_NbDataBits - 1 downto 0);     -- Data to the memory
    o_DataFromMem  : out std_logic_VECTOR(c_NbDataBits - 1 downto 0);     -- Data to the memory

    -- Interface to the real memory
    o_DataFromInMuxToRAM     : out std_logic_vector(c_NbDataBits -1 downto 0);
    o_AddressFromInMuxToRAM  : out std_logic_vector(c_NbAddressBits -1 downto 0);
    o_WEFromInMuxToRAM       : out std_logic_vector(0 downto 0);
    o_AddressFromOutMuxToRAM : out std_logic_vector(c_NbAddressBits -1 downto 0);
    i_DataFromRAMToControl   : in std_logic_vector(c_NbDataBits - 1 downto 0);

    -- Debug
    o_Debug                  : out std_logic

    );  
end wbMemoryWrapper;
