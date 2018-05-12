-------------------------------------------------------------------------------
-- DESCRIPTION: 
--
-- NOTES:
--
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
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use std.textio.all;

library work;
-- Packages
use work.SoCConstantsPackage.all;
-- Components
use work.wbMemoryWrapperControlComponentPackage.all;
use work.wbMemoryWrapperMuxesComponentPackage.all;
-- Generators
use work.generatorsComponentPackage.all;

-----------------------------
-- ARCHITECTURE DEFINITION --
-----------------------------
   
architecture Hierarchical of wbMemoryWrapper is

  -- SIGNAL DEFINITION --
  signal s_Control                 : std_logic;         -- Controls sthe behaviour of the MUXes
  signal s_DataFromControlToRAM    : std_logic_vector(c_NbDataBits -1 downto 0);
  signal s_DataFromRAMToControl    : std_logic_vector(c_NbDataBits -1 downto 0);
  signal s_AddressFromControlToRAM : std_logic_vector(c_NbAddressBits - 1 downto 0);
  
  signal s_WEFromControlToRAM      : std_logic_vector(0 downto 0);

  -- Reset

  -- Clock

  -- Other

  -- DEBUG
  
begin


  -- INSTANCES
  i_wbMemoryWrapperControl : wbMemoryWrapperControl
    generic map (
      c_NbAddressBits => c_NbAddressBits,
      c_NbDataBits    => c_NbDataBits,
      g_base_address  => g_base_address,
      g_offset        => g_offset )
    
    port map (
      CLK_I        => CLK_I,
      RST_I        => RST_I,
      ACK_O        => ACK_O,
      ADDR_I       => ADDR_I,
      DAT_I        => DAT_I,
      DAT_O        => DAT_O,
      STB_I        => STB_I,
      WE_I         => WE_I,

      o_Control    => s_Control,
      o_Data       => s_DataFromControlToRAM,
      i_Data       => i_DataFromRAMToControl,
      o_Address    => s_AddressFromControlToRAM,
      o_WE         => s_WEFromControlToRAM
      
      );

  i_Muxs : wbMemoryWrapperMuxes

    generic map (
      c_NbAddressBits => c_NbAddressBits,
      c_NbDataBits    => c_NbDataBits )

    port map (

      -- Control
      i_Control       => s_Control,

      -- In MUX
      i_InDirectAddress => i_AddrToMemIn,
      i_InDirectData    => i_DataToMem,
      i_InDirectWE      => i_WEToMemIn,
      i_WBAddress       => s_AddressFromControlToRAM,
      i_WBData          => s_DataFromControlToRAM,
      i_WBWE            => s_WEFromControlToRAM,
      o_InAddress       => o_AddressFromInMuxToRAM,
      o_InData          => o_DataFromInMuxToRAM,
      o_InWE            => o_WEFromInMuxToRAM,

      -- OUT MUX
      i_OutDirectAddress => i_AddrToMemOut,
      i_OutWBAddress     => s_AddressFromControlToRAM,
      o_OutAddress       => o_AddressFromOutMuxToRAM

      );


  -- CONTINUOUS AASSIGNMENTS

  o_DataFromMem <= i_DataFromRAMToControl;

  o_Debug <= s_Control;

end Hierarchical;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------
 
