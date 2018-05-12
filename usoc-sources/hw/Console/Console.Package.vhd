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
use work.SoCConstantsPackage.all;

----------------------------------
-- COMPONENT PACKAGE DEFINITION --
----------------------------------

package ConsolePackage is

  -- TYPES
  type t_FSM_Itf is (e_Idle, e_TreatCommand,
                     e_ReadAddress,
                     e_ReadData,
                     e_ProgramMode0,
                     e_ProgramMode1,
                     e_ProgramMode2,
                     e_ProgramMode3,
                     e_SendProgramConfirm0,
                     e_SendProgramConfirm1,
                     e_SendProgramConfirm2,
                     e_SendProgramConfirm3,
                     e_TriggerProgramming,
                     e_TriggerConfirm,
                     e_TriggerProgrammingDone,
                     e_dataHandling,
                     e_SendData);

  --CONSTANTS
  constant c_NB_STOP_BYTES : integer := 8; 

end ConsolePackage;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------
   
