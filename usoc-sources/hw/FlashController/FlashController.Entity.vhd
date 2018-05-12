-------------------------------------------------------------------------------
-- Controls the external FLASH memory operation
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
 
entity FlashController is
  generic (
    log_file:       string; -- Debug file
    base_address : integer      -- Base address
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

    -- Direct interface to console
    p_DataFromConsole : in  std_logic_vector(31 downto 0);
    p_AddrToConsole   : out std_logic_vector(2 downto 0);
    p_DoProgram       : in  std_logic;
    p_ProgramDone     : out std_logic;

    -- Interface to the Flash
    p_ProgramMode         : out std_logic;
    p_WENegFromController : out std_logic;
    p_OENegFromController : out std_logic;
    p_CENegFromController : out std_logic;
    p_AddrToMem           : out std_logic_VECTOR(20 downto 0);  -- Address to the memory
    p_DataToMem           : out std_logic_vector(15 downto 0);
    p_DataFromMem         : in  std_logic_vector(15 downto 0);
    p_Access              : out std_logic;  -- Controls the Flash mode of operation
    p_WBAccess            : out std_logic;  -- Controls the Flash WB mode of operation
    o_ResetFlash_n        : out std_logic;  -- Controls the Reset pin of the flash
    i_RY                  : in  std_logic;  -- RY/BY# signal

    -- IRQ
    o_Interrupt           : out std_logic;

    -- Debug
    p_Debug : out std_logic_vector(3 downto 0)

    );  
end FlashController;
