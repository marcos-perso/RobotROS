-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- Configuration 1 for the simulation
-- This configuration includes all behavioural models
--
-- NOTES:
--
-- $Author$
-- $Date$
-- $Name$
-- $Revision$
--
-------------------------------------------------------------------------------

-- *****************
-- *** LIBRARIES ***
-- *****************

library IEEE;
library work;

-- Standard
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- ZPU related

-- SoC packages

-- Components

-- *********************
-- *** CONFIGURATION ***
-- *********************
configuration SimulationPost of TB is

  for BEHAV -- of fpga_top

    for all: ClockResetGenerator
      use entity work.ClockResetGenerator(BEHAV);
    end for;

    for all: ConsoleEmulator
      use entity work.ConsoleEmulator(RTL);
    end for;

    for all: Stimuli
      use entity work.Stimuli(BEHAV);
    end for;

    for all: MoSoC

      use entity work.MoSoC(Structure);

    end for;


  end for;

end SimulationPost;
