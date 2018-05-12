-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- LED interface controlled through wishbone bus
--
-- NOTES:
--
-- $Author$
-- $Date$
-- $Name$
-- $Revision$
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

----------------------------------
-- COMPONENT PACKAGE DEFINITION --
----------------------------------

package LEDInterfaceComponentPackage is

--------------------------
-- COMPONENT DEFINITION --
--------------------------

  component LEDInterface is
    generic (
      log_file     : string;      -- Debug file
      base_address : integer      -- Base address
      );
    port(

    -- WISHBONE SLAVE interface
    CLK_I  : in  std_logic;                                        -- Input clock
    RST_I  : in  std_logic;                                       -- Input reset

    ACK_O  : out std_logic;                                       -- Acknowdledge
    ADDR_I : in  std_logic_vector(c_WishboneAddrWidth - 1 downto 0);
    DAT_I  : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0);  -- Data Input
    DAT_O  : out std_logic_vector(c_WishboneDataWidth - 1 downto 0);  -- Data Output
    STB_I  : in  std_logic;                                       -- Strobe In
    WE_I   : in  std_logic;                                       -- Write Enable

    -- Specific interface
    p_InLeds : in std_logic_vector(31 downto 0);

    p_LEDS : out  std_logic_vector (3 downto 0)       -- Output port

    );      
  end component;

end LEDInterfaceComponentPackage;
   


-------------------------------------------------------------------------------
-- $Log: BusToIOComponentPackage.vhd,v $
-- Revision 1.1  2010-07-10 21:59:01  mmartinez
-- Files imported
--
-- Revision 1.3  2010-06-17 22:41:19  mmartinez
-- Basic behaviour completed
--
-- Revision 1.2  2010-06-10 21:10:04  mmartinez
-- *** empty log message ***
--
-- Revision 1.1  2010-06-06 15:01:15  mmartinez
-- Creation of the files
--
-------------------------------------------------------------------------------
