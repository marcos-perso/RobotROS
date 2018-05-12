-------------------------------------------------------------------------------
-- DESCRIPTION: 
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

----------------------------------
-- COMPONENT PACKAGE DEFINITION --
----------------------------------

package FlashWrapperPackage is

  -- CONSTANTS

  -- TYPES
  type t_FlashFSM is (e_Idle,
                      e_WriteState1,
                      e_WriteState2,
                      e_WriteState3,
                      e_WriteState4,
                      e_ReadState1,
                      e_ReadState2,
                      e_ReadState3,
                      e_ReadState4,
                      e_ReadState2ndByte1,
                      e_ReadState2ndByte2,
                      e_ReadState2ndByte3,
                      e_ReadState2ndByte4,
                      e_ReadState5
                      );


end FlashWrapperPackage;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------
   
