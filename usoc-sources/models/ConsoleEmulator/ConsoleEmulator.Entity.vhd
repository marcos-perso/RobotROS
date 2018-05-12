-------------------------------------------------------------------------------
-- ConsoleEmulator to connect the PC to the platform
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
use work.ConsoleEmulatorPackage.all;

-----------------------
-- ENTITY DEFINITION --
-----------------------
 
entity ConsoleEmulator is
  generic (
    stimuli_file:       string -- Debug file
    );
  port(

    -- Wishbone interface (CONTROL)
    CLK_I  : in  std_logic;
    RST_I  : in  std_logic;

    -- Wishbone interface (MASTER)
    ADDR_O : out std_logic_vector(c_WishboneAddrWidth - 1 downto 0);
    DAT_O  : out std_logic_vector(c_WishboneDataWidth - 1 downto 0);
    SEL_O  : out std_logic_vector(c_WishBoneSelWidth - 1 downto 0);
    WE_O   : out std_logic;
    CYC_O  : out std_logic;
    STB_O  : out std_logic;
    DAT_I  : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0);
    ACK_I  : in  std_logic;                                     
    ERR_I  : in  std_logic;
    RTY_I  : in  std_logic;
    -- Buttons
    p_Buttons : out std_logic_vector(2 downto 0);
    -- UART interface
    p_UARTRxInterrupt : in  std_logic;
    p_UARTTxInterrupt : in  std_logic
    );  

end ConsoleEmulator;
