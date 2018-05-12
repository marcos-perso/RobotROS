-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- Generators component package
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

-- Standard
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- synthesis translate_off
Library XilinxCoreLib;
library UNISIM;
use UNISIM.Vcomponents.ALL;
-- synthesis translate_on

-- SoC Constants

-- ZPU related

-- Other

----------------------------------
-- COMPONENT PACKAGE DEFINITION --
----------------------------------

package generatorsComponentPackage is

--------------------------
-- COMPONENT DEFINITION --
--------------------------

  component ClockSynthesizer
    port ( CLKIN_IN        : in    std_logic; 
           RST_IN          : in    std_logic; 
           CLKFX_OUT       : out   std_logic; 
           CLKIN_IBUFG_OUT : out   std_logic; 
           CLK0_OUT        : out   std_logic; 
           CLK2X_OUT       : out   std_logic; 
           CLK180_OUT      : out   std_logic; 
           LOCKED_OUT      : out   std_logic; 
           STATUS_OUT      : out   std_logic_vector (7 downto 0));
  end component;

  component RAM1024x32
    port (
      clka  : IN std_logic;
      dina  : IN std_logic_VECTOR(31 downto 0);
      addra : IN std_logic_VECTOR(9 downto 0);
      wea   : IN std_logic_VECTOR(0 downto 0);
      douta : OUT std_logic_VECTOR(31 downto 0));
  end component;

  component DualRAM_8x32
    port (
      clka  : IN  std_logic;
      dina  : IN  std_logic_VECTOR(31 downto 0);
      addra : IN  std_logic_VECTOR(2 downto 0);
      wea   : IN  std_logic_VECTOR(0 downto 0);
      clkb  : IN  std_logic;
      addrb : IN  std_logic_VECTOR(2 downto 0);
      doutb : OUT std_logic_VECTOR(31 downto 0));
  end component;

 
end generatorsComponentPackage;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------
