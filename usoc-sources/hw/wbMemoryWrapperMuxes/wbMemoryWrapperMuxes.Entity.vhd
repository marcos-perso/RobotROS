-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- Muxes (In and Out) for wbMemoryWrapper
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

-- IEEE libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Project libraries
library work;
use work.zpu_config.all;
use work.zpupkg.all;
use work.WishboneConstantsPackage.all;

-----------------------
-- ENTITY DEFINITION --
-----------------------
 
entity wbMemoryWrapperMuxes is

    generic (
      c_NbAddressBits : integer;
      c_NbDataBits    : integer );

    port(

      -- Control
      i_Control          : in std_logic;
      -- In MUX
      i_InDirectAddress  : in std_logic_vector(c_NbAddressBits -1 downto 0);
      i_InDirectData     : in std_logic_vector(c_NbDataBits -1 downto 0);
      i_InDirectWE       : in std_logic_vector(0 downto 0);
      i_WBAddress        : in std_logic_vector(c_NbAddressBits -1 downto 0);
      i_WBData           : in std_logic_vector(c_NbDataBits -1 downto 0);
      i_WBWE             : in std_logic_vector(0 downto 0);
      o_InAddress        : out std_logic_vector(c_NbAddressBits -1 downto 0);
      o_InData           : out std_logic_vector(c_NbDataBits -1 downto 0);
      o_InWE             : out std_logic_vector(0 downto 0);
      -- OUT MUX
      i_OutDirectAddress : in std_logic_vector(c_NbAddressBits -1 downto 0);
      i_OutWBAddress     : in std_logic_vector(c_NbAddressBits -1 downto 0);
      o_OutAddress       : out std_logic_vector(c_NbAddressBits -1 downto 0)

    );      

end wbMemoryWrapperMuxes;
   

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------
