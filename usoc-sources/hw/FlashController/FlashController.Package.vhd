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

package FlashControllerPackage is

  -- CONSTANTS
  constant C_LEDS : integer := 16#0#;  -- DATA Register

  -- TYPES
  type t_FlashFSM is (e_Idle,
                      e_Poll1,
                      e_Poll2,
                      e_WriteState1,
                      e_WriteState2,
                      e_WriteState3,
                      e_WriteState4,
                      e_ReadState1,
                      e_ReadState2,
                      e_ReadState3,
                      e_ReadState4,
                      e_ReadState5
                      );

  type t_FSM_FlashProgram is (e_Idle,
                              e_WaitRY0,
                              e_WaitRY1,
                              e_Program_Cycle_DataPolling,
                              e_ProgramOneShot_Cycle1,
                              e_ProgramOneShot_Cycle2,
                              e_ProgramOneShot_Cycle3,
                              e_ProgramOneShot_Cycle4,
                              e_EraseSector_Cycle1,
                              e_EraseSector_Cycle2,
                              e_EraseSector_Cycle3,
                              e_EraseSector_Cycle4,
                              e_EraseSector_Cycle5,
                              e_EraseSector_Cycle6,
                              e_Program_Cycle1,
                              e_Program_Cycle2,
                              e_Program_Cycle3,
                              e_Program_Cycle4,
                              e_Program_Cycle5,
                              e_Program_Cycle6,
                              e_GetInfo_Cycle1,
                              e_GetInfo_Cycle2,
                              e_GetInfo_Cycle3,
                              e_GetInfo_Cycle4,
                              e_GetInfo_Cycle5
                              );

end FlashControllerPackage;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------
   
