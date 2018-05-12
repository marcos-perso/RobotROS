-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- Configuration 2 for the simulation
-- This configuration includes simulation (simlpiefied) models not including
-- XILINX primitives
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
configuration Simulation1 of TB is

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

    for all: uSoC

      use entity work.uSoC(Hierarchical);

      for Hierarchical
        
        for all : Console
          use entity work.Console(RTL);
        end for;
        
--        for all : InternalMemoryWrapper
--          use entity work.InternalMemoryWrapper(RTL);
--        end for;
        
        for all : FlashWrapper
          use entity work.FlashWrapper(RTL);
        end for;
        
        for all : FlashController
          use entity work.FlashController(RTL);
        end for;
        
        for all : RAM1024x32
          use entity work.RAM1024x32(RAM1024x32_a);
        end for;

        for all : DebugController
          use entity work.DebugController(RTL);
        end for;

        for all : DualRAM_8x32
          use entity work.DualRAM_8x32(DualRAM_8x32_a);
        end for;

        for all : wbMemoryWrapper
          use entity work.wbMemoryWrapper(Hierarchical);

          for Hierarchical

            for all : wbMemoryWrapperControl
              use entity work.wbMemoryWrapperControl(RTL);
            end for;

            for all : wbMemoryWrapperMuxes
              use entity work.wbMemoryWrapperMuxes(Combinational);
            end for;

          end for;

        end for;
        
        for all : TICTimer
          use entity work.TICTimer(RTL);
        end for;

        for all : ClockSynthesizer
          use entity work.ClockSynthesizer(SIMULATION);
        end for;

        for all : ResetGenerator
          use entity work.ResetGenerator(RTL);
        end for;

        for all : wbIntercon

          use entity work.wbIntercon(Hierarchical);

          for Hierarchical

            for all : wbArbiter
              use entity work.wbArbiter(Combinational);
            end for;                    -- For wbArbiter

            for all : wbAddressComparator
              use entity work.wbAddressComparator(Combinational);
            end for;                    -- For wbAddressComparator

            for all : wbDataSelection
              use entity work.wbDataSelection(Combinational);
            end for;                    -- For wbDataSelection
  
          end for;                      -- Hierarchical

        end for;                        -- For wbIntercon

        for all : ButtonCaption
          use entity work.ButtonCaption(RTL);
        end for;

        for all : SimpleCounter
          use entity work.SimpleCounter(RTL);
        end for;

        for all : wbMaster
          use entity work.wbMaster(RTL);
        end for;

        for all : zpu_core
          use entity work.zpu_core(behave);

          for behave

          end for;
            
        end for;

      end for;

    end for;

  end for;

end Simulation1;
