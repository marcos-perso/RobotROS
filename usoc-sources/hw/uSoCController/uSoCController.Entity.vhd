-------------------------------------------------------------------------------
-- Controls the ZPU operation
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
 
entity uSoCController is

  generic (
    g_log_file     : string;     -- Debug file
    g_base_address : integer      -- Base address
    );

  port(

    -- Wishbone interface
    CLK_I  : in  std_logic;                                          -- Input clock
    RST_I  : in  std_logic;                                          -- Input reset
    ACK_O  : out std_logic;                                          -- Acknowdledge
    ADDR_I : in  std_logic_vector(c_WishboneAddrWidth - 1 downto 0);
    DAT_I  : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0); -- Data Input
    DAT_O  : out std_logic_vector(c_WishboneDataWidth - 1 downto 0); -- Data Output
    STB_I  : in  std_logic;                                          -- Strobe In
    WE_I   : in  std_logic;                                          -- Write Enable

    -- Interface to ZPU
    p_enable   : out std_logic; -- Enables ZPU
    p_ResetZPU : out std_logic

    );  
end uSoCController;
