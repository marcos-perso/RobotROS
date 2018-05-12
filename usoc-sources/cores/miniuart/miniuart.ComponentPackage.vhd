-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- miniuart component package
--
-- $Author: mmartinez $
-- $Date: 2010-07-11 16:36:16 $
-- $Name:  $
-- $Revision: 1.1 $
--
-------------------------------------------------------------------------------

---------------
-- LIBRARIES --
---------------

library ieee;
library work;

-- Standard
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- SoC Constants
use work.SOCConstantsPackage.all;
use work.WishboneConstantsPackage.all;

-- Other

----------------------------------
-- COMPONENT PACKAGE DEFINITION --
----------------------------------

package miniuartComponentPackage is

--------------------------
-- COMPONENT DEFINITION --
--------------------------
 
  component miniuart is

    generic(BRDIVISOR: INTEGER range 0 to 65535 := 130); -- Baud rate divisor

    port (
      -- Wishbone signals
      WB_CLK_I : in  std_logic;  -- clock
      WB_RST_I : in  std_logic;  -- Reset input
      WB_ADR_I : in  std_logic_vector(1 downto 0); -- Adress bus          
      WB_DAT_I : in  std_logic_vector(7 downto 0); -- DataIn Bus
      WB_DAT_O : out std_logic_vector(7 downto 0); -- DataOut Bus
      WB_WE_I  : in  std_logic;  -- Write Enable
      WB_STB_I : in  std_logic;  -- Strobe
      WB_ACK_O : out std_logic;	-- Acknowledge
      -- process signals     
      IntTx_O  : out std_logic;  -- Transmit interrupt: indicate waiting for Byte
      IntRx_O  : out std_logic;  -- Receive interrupt: indicate Byte received
      BR_Clk_I : in  std_logic;  -- Clock used for Transmit/Receive
      TxD_PAD_O: out std_logic;  -- Tx RS232 Line
      RxD_PAD_I: in  std_logic;  -- Rx RS232 Line     
      p_Debug  : out std_logic_vector(3 downto 0)

      );
  end component;

end miniuartComponentPackage;


-------------------------------------------------------------------------------
-- $Log: miniuart.ComponentPackage.vhd,v $
-- Revision 1.1  2010-07-11 16:36:16  mmartinez
-- File created
--
-------------------------------------------------------------------------------
