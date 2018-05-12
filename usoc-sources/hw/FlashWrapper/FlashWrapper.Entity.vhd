-------------------------------------------------------------------------------
-- Wrapper around the Flash in order to connect it to the
-- Wishbone subsystem
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
 
entity FlashWrapper is
  generic (
    log_file:       string; -- Debug file
    base_address : integer      -- Base address
    );
  port(

    -- Wishbone Control signals
    CLK_I  : in  std_logic;                                       -- Input clock
    RST_I  : in  std_logic;                                       -- Input reset

    -- Wishbone interface (WB1)
    ACK_O_WB1  : out std_logic;                                       -- Acknowdledge
    ADDR_I_WB1 : in  std_logic_vector(c_WishboneAddrWidth - 1 downto 0);
    DAT_I_WB1  : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0); -- Data Input
    DAT_O_WB1  : out std_logic_vector(c_WishboneDataWidth - 1 downto 0); -- Data Output
    STB_I_WB1  : in  std_logic;                                       -- Strobe In
    WE_I_WB1   : in  std_logic;                                       -- Write Enable

    -- Wishbone interface (WB2)
    ACK_O_WB2  : out std_logic;                                       -- Acknowdledge
    ADDR_I_WB2 : in  std_logic_vector(c_WishboneAddrWidth - 1 downto 0);
    DAT_I_WB2  : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0);  -- Data Input
    DAT_O_WB2  : out std_logic_vector(c_WishboneDataWidth - 1 downto 0);  -- Data Output
    STB_I_WB2  : in  std_logic;                                       -- Strobe In
    WE_I_WB2   : in  std_logic;                                       -- Write Enable

    -- Interface to the Flash controller
    p_AddressFromController  : in std_logic_VECTOR(20 downto 0);
    p_DataFromController     : in std_logic_VECTOR(15 downto 0);
    p_DataToController       : out std_logic_VECTOR(15 downto 0);
    p_WENegFromController    : in std_logic;
    p_OENegFromController    : in std_logic;
    p_CENegFromController    : in std_logic;
    p_ProgramMode            : in std_logic;
    p_Access                 : in std_logic;
    p_WBAccess               : in std_logic;

    -- Interface to the real memory
    o_DataToMem    : out std_logic_VECTOR(15 downto 0);  -- Data to the memory
    i_DataFromMem  : in  std_logic_VECTOR(15 downto 0);  -- Data to the memory
    o_BidirControl : out std_logic;
    o_AddrToMem    : out std_logic_VECTOR(20 downto 0);  -- Address to the memory
    o_CENeg        : out std_logic;
    o_OENeg        : out std_logic;
    o_WENeg        : out std_logic;
    o_WPNeg        : out std_logic;
    o_BYTENeg      : out std_logic;
    i_RY           : in std_logic;

    -- Debug
    p_Debug : out std_logic_vector(7 downto 0)
 
    );  
end FlashWrapper;
