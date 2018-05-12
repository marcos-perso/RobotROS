-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- 
-- Input/Output muxes for wbMamoryWrapper
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


-----------------------------
-- ARCHITECTURE DEFINITION --
-----------------------------
 
architecture combinational of wbMemoryWrapperMuxes is


  -- CONSTANTS DEFINITION --

  -- SIGNAL DEFINITION --

  -- DEBUG

  -- ARCHITECTURE --

begin

  -- Input MUX
  p_MuxIn: process (
    i_Control,
    i_InDirectAddress, i_InDirectData, i_InDirectWE,  -- Direct port
    i_WBAddress, i_WBData, i_WBWE                     -- WB port
    )

  begin  -- process p_MuxIn


    -- Default (avoid latches
    o_InAddress <= (others => '0');
    o_InData    <= (others => '0');
    o_InWE      <= (others => '0');

    if (i_Control = '0') then           -- DIRECT access to memory

      o_InAddress <= i_InDirectAddress;
      o_InData    <= i_InDirectData;
      o_InWE      <= i_InDirectWE;

    else                                -- WB access to memory

      o_InAddress <= i_WBAddress;
      o_InData    <= i_WBData;
      o_InWE      <= i_WBWE;
      
    end if;
    

  end process p_MuxIn;

  -- Output MUX
  p_MuxOut: process (
    i_Control,
    i_OutDirectAddress,  -- Direct port
    i_OutWBAddress       -- WB port
    )

  begin  -- process p_MuxIn


    -- Default (avoid latches
    o_OutAddress <= (others => '0');

    if (i_Control = '0') then           -- DIRECT access to memory

      o_OutAddress <= i_OutDirectAddress;

    else                                -- WB access to memory

      o_OutAddress <= i_OutWBAddress;
      
    end if;
    

  end process p_MuxOut;

end combinational;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------

