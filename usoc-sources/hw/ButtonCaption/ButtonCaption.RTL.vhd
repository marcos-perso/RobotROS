-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- Creates a pulse indicating that the button has been pressed
-- when the button is pressed, the module detects a 0-1 transition
-- and generates:
--   * a pulse (1 TIC) [p_ButtonPressed]
--   * An interruption (16 TICs) (p_ButtonInterrupt)
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
use work.SoCConstantsPackage.all;
use work.ButtonCaptionGeneratorPackage.all;

-----------------------------
-- ARCHITECTURE DEFINITION --
-----------------------------
   
architecture RTL of ButtonCaption is

  -- SIGNAL DEFINITION --

  signal r_Step1 : std_logic;
  signal r_Step2 : std_logic;
  signal r_Step3 : std_logic;
  signal r_Step4 : std_logic;
  signal r_Step5 : std_logic;

  signal r_ButtonPressed   : std_logic;
  signal r_ButtonInterrupt : std_logic;

  signal interruptcounter : unsigned(4 downto 0);  -- This is absolutelly not

  -- OTHER --

  -- DEBUG
  file l_file : TEXT open write_mode is log_file;
  
begin

  process(clk, reset)
  begin
    if reset = '1' then

      r_step1 <= '0';
      r_step2 <= '0';
      r_step3 <= '0';
      r_step4 <= '0';
      r_step5 <= '0';
      interruptcounter <= to_unsigned(31, 5);

    elsif (clk'event and clk = '1') then

      -- Defaults
      r_ButtonInterrupt <= '0';

      -- Treat interrupt
      if (interruptcounter < to_unsigned(31,5))
      then
        interruptcounter <= interruptcounter + 1;
        r_ButtonInterrupt <= '1';
      end if;

      r_step5 <= r_step4;
      r_step4 <= r_step3;
      r_step3 <= r_step2;
      r_step2 <= r_step1;
      r_step1 <= p_FromButton;

      if ((r_step5 = '0')
          and (r_step4 = '0')
          and (r_step3 = '1')
          and (r_step2 = '1')
          and (r_step1 = '1')) then
        r_ButtonPressed  <= '1';
        -- Reset the counter that generates the interrup
        interruptcounter <= to_unsigned(0,5);

        -- synopsys translate off
        assert false report "Button pressed!" severity warning;
        -- synopsys translate on
      else
        r_ButtonPressed  <= '0';
      end if;
        
    end if;
  end process;

  -- Continuous assignements
  p_ButtonPressed   <= r_ButtonPressed;
  p_ButtonInterrupt <= r_ButtonInterrupt;


end RTL;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------
 
