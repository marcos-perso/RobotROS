-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- 
-- Controls the output to the motors
-- 
-- NOTES:
-- 
-- REGISTERS:
--     BASE_ADDRESS + 0 : 
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
use work.zpu_config.all;
use work.zpupkg.all;
use work.RegisterMapPackage.all;
use work.MotorControlPackage.all;
-- synopsys translate off
use work.txt_util.all;
-- synopsys translate on
use std.textio.all;

-- synopsys translate_off
use work.stringfkt.all;
-- synopsys translate_on
   
-----------------------------
-- ARCHITECTURE DEFINITION --
-----------------------------
 
architecture RTL of MotorControl is


  -- CONSTANTS DEFINITION --

  -- SIGNAL DEFINITION --

  -- Motor control
  signal reg_Motor0   : std_logic_vector(15 downto 0);  -- Motor 0 commands
  signal reg_MOTOR0_TRIGGER : std_logic;                 -- MOTOR0 Enable
  signal reg_MOTOR0_STEP : std_logic_vector(15 downto 0);  -- Motor 0 steps to be done
  signal reg_Motor0Counter : unsigned(C_NBBITS_MOTORCOUNTER - 1 downto 0); -- Triggers Phase changes
  signal reg_MOTOR0_Direction : std_logic;
  signal reg_PhaseCounter0 : unsigned(C_NBBITS_PHASECOUNTER -1 downto 0);  -- Phase counter
  signal reg_Motor0SpeedCounter : unsigned(C_NBBITS_SPEEDCOUNTER - 1 downto 0); -- Triggers Phase changes

  signal reg_Motor1   : std_logic_vector(15 downto 0);  -- Motor commands
  signal reg_MOTOR1_TRIGGER : std_logic;                 -- MOTOR Enable
  signal reg_MOTOR1_STEP : std_logic_vector(15 downto 0);  -- Motor steps to be done
  signal reg_Motor1Counter : unsigned(C_NBBITS_MOTORCOUNTER - 1 downto 0); -- Triggers Phase changes
  signal reg_MOTOR1_Direction : std_logic;
  signal reg_PhaseCounter1 : unsigned(C_NBBITS_PHASECOUNTER -1 downto 0);  -- Phase counter
  signal reg_Motor1SpeedCounter : unsigned(C_NBBITS_SPEEDCOUNTER - 1 downto 0); -- Triggers Phase changes

  signal reg_Motor2   : std_logic_vector(15 downto 0);  -- Motor commands
  signal reg_MOTOR2_TRIGGER : std_logic;                 -- MOTOR Enable
  signal reg_MOTOR2_STEP : std_logic_vector(15 downto 0);  -- Motor steps to be done
  signal reg_Motor2Counter : unsigned(C_NBBITS_MOTORCOUNTER - 1 downto 0); -- Triggers Phase changes
  signal reg_MOTOR2_Direction : std_logic;
  signal reg_PhaseCounter2 : unsigned(C_NBBITS_PHASECOUNTER -1 downto 0);  -- Phase counter
  signal reg_Motor2SpeedCounter : unsigned(C_NBBITS_SPEEDCOUNTER - 1 downto 0); -- Triggers Phase changes

  -- Internal signals

  -- Wishbone interface
  signal reg_ACK          : std_logic;

  -- DEBUG
  -- synopsys translate_off
  file l_file : TEXT open write_mode is g_log_file;
  -- synopsys translate_on

begin

  -- purpose: Interface with wishbone
  -- type   : sequential

  p_register: process (CLK_I, RST_I)

  begin  -- process p_register


    if RST_I = '1' then

      -- =============
      -- === RESET ===
      -- =============

      -- GENERAL
      reg_ACK            <= '0';

      -- MOTOR 0
      reg_MOTOR0_STEP    <= (others => '0');
      reg_MOTOR0         <= "1001010101101010";
      reg_Motor0Counter  <= to_unsigned(0, C_NBBITS_MOTORCOUNTER);
      reg_MOTOR0_TRIGGER  <= '0';
      reg_MOTOR0_Direction <= '1';
      reg_PhaseCounter0  <= to_unsigned(C_PHASECOUNTERMAX_INIT-1, C_NBBITS_PHASECOUNTER);
      reg_Motor0SpeedCounter <= to_unsigned(C_MOTOR_SPEEDCOUNTER_MAX-1,C_NBBITS_SPEEDCOUNTER);

      -- MOTOR 1
      reg_MOTOR1_STEP    <= (others => '0');
      reg_MOTOR1         <= "1001010101101010";
      reg_Motor1Counter  <= to_unsigned(0, C_NBBITS_MOTORCOUNTER);
      reg_MOTOR1_TRIGGER  <= '0';
      reg_MOTOR1_Direction <= '1';
      reg_PhaseCounter1  <= to_unsigned(C_PHASECOUNTERMAX_INIT-1, C_NBBITS_PHASECOUNTER);
      reg_Motor1SpeedCounter <= to_unsigned(C_MOTOR_SPEEDCOUNTER_MAX-1,C_NBBITS_SPEEDCOUNTER);

      -- MOTOR 2
      reg_MOTOR2_STEP    <= (others => '0');
      reg_MOTOR2         <= "1001010101101010";
      reg_Motor2Counter  <= to_unsigned(0, C_NBBITS_MOTORCOUNTER);
      reg_MOTOR2_TRIGGER  <= '0';
      reg_MOTOR2_Direction <= '1';
      reg_PhaseCounter2  <= to_unsigned(C_PHASECOUNTERMAX_INIT-1, C_NBBITS_PHASECOUNTER);
      reg_Motor2SpeedCounter <= to_unsigned(C_MOTOR_SPEEDCOUNTER_MAX-1,C_NBBITS_SPEEDCOUNTER);
      
    elsif CLK_I'event and CLK_I = '1' then

      -- =====================
      -- === LOAD COUNTERS ===
      -- =====================

      -- =======================
      -- === UPDATE COUNTERS ===
      -- =======================

      -- *** MOTOR 0 counter ***
      if (reg_Motor0Counter /= 0)
      then 

        if (reg_Motor0SpeedCounter /= 0) then
          -- reg_MotorXSpeedCounter regulates the speed of teh movement. Default
          reg_Motor0SpeedCounter <= reg_Motor0SpeedCounter - 1;
        else
          reg_Motor0SpeedCounter <= to_unsigned(C_MOTOR_SPEEDCOUNTER_MAX-1,C_NBBITS_SPEEDCOUNTER);
          if (reg_PhaseCounter0 =0) then
            reg_PhaseCounter0 <= to_unsigned(C_PHASECOUNTERMAX_INIT-1,C_NBBITS_PHASECOUNTER);
            reg_Motor0Counter <= reg_Motor0Counter - 1;
          else
            reg_PhaseCounter0 <= reg_PhaseCounter0-1;
          end if;

        end if;
        
      else
        reg_Motor0Counter <= to_unsigned(0,C_NBBITS_MOTORCOUNTER);
      end if;

      -- *** MOTOR 1 counter ***
      if (reg_Motor1Counter /= 0)
      then 

        if (reg_Motor1SpeedCounter /= 0) then
          -- reg_MotorXSpeedCounter regulates the speed of teh movement. Default
          reg_Motor1SpeedCounter <= reg_Motor1SpeedCounter - 1;
        else
          reg_Motor1SpeedCounter <= to_unsigned(C_MOTOR_SPEEDCOUNTER_MAX-1,C_NBBITS_SPEEDCOUNTER);
          if (reg_PhaseCounter1 =0) then
            reg_PhaseCounter1 <= to_unsigned(C_PHASECOUNTERMAX_INIT-1,C_NBBITS_PHASECOUNTER);
            reg_Motor1Counter <= reg_Motor1Counter - 1;
          else
            reg_PhaseCounter1 <= reg_PhaseCounter1-1;
          end if;

        end if;
        
      else
        reg_Motor1Counter <= to_unsigned(0,C_NBBITS_MOTORCOUNTER);
      end if;

      -- *** MOTOR 2 counter ***
      if (reg_Motor2Counter /= 0)
      then 

        if (reg_Motor2SpeedCounter /= 0) then
          -- reg_MotorXSpeedCounter regulates the speed of teh movement. Default
          reg_Motor2SpeedCounter <= reg_Motor2SpeedCounter - 1;
        else
          reg_Motor2SpeedCounter <= to_unsigned(C_MOTOR_SPEEDCOUNTER_MAX-1,C_NBBITS_SPEEDCOUNTER);
          if (reg_PhaseCounter2 =0) then
            reg_PhaseCounter2 <= to_unsigned(C_PHASECOUNTERMAX_INIT-1,C_NBBITS_PHASECOUNTER);
            reg_Motor2Counter <= reg_Motor2Counter - 1;
          else
            reg_PhaseCounter2 <= reg_PhaseCounter2-1;
          end if;

        end if;
        
      else
        reg_Motor2Counter <= to_unsigned(2,C_NBBITS_MOTORCOUNTER);
      end if;


      -- ====================
      -- === WISHBONE ACK ===
      -- ====================

      if (reg_ACK = '0') and (STB_I = '1') then
        reg_ACK <= '1';
      else
        reg_ACK <= '0';
      end if;

      -- ======================
      -- === WISHBONE WRITE ===
      -- ======================

      if (STB_I = '1') then

        -- synopsys translate off
        assert false report "Motor Control addressed: ADDR_I: " & slv2hexS(std_logic_vector'(ADDR_I)) & " DAT_I = " & slv2hexS(std_logic_vector'(DAT_I(31 downto 0))) severity note;
        -- synopsys translate on

        -- If Strobe in is activated, treat the data
        if (to_integer(unsigned(ADDR_I)) <= (g_base_address + C_MOTORCONTROL_MAX_OFFSET)) then

          if WE_I = '1' then

            -- STEPS to be counted for motor 0
            if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_STEP_MOTOR0)) then
              -- synopsys translate off
              assert false report "MOTORCONTROL_STEP_MOTOR0 addressed (W)" severity note;
              -- synopsys translate on
              reg_MOTOR0_STEP <= DAT_I(15 downto 0);
            end if;

            -- MOTOR 0 STEP 1
            if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR0_STEP1)) then
              -- synopsys translate off
              assert false report "MOTORCONTROL_MOTOR0_STEP1 addressed (W)" severity note;
              -- synopsys translate on
              reg_MOTOR0(3 downto 0) <= DAT_I(3 downto 0);
            end if;

            -- MOTOR 0 STEP 2
            if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR0_STEP2)) then
              -- synopsys translate off
              assert false report "MOTORCONTROL_MOTOR0_STEP2 addressed (W)" severity note;
              -- synopsys translate on
              reg_MOTOR0(7 downto 4) <= DAT_I(3 downto 0);
            end if;

            -- MOTOR 0 STEP 3
            if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR0_STEP3)) then
              -- synopsys translate off
              assert false report "MOTORCONTROL_MOTOR0_STEP3 addressed (W)" severity note;
              -- synopsys translate on
              reg_MOTOR0(11 downto 8) <= DAT_I(3 downto 0);
            end if;

            -- MOTOR 0 STEP 4
            if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR0_STEP4)) then
              -- synopsys translate off
              assert false report "MOTORCONTROL_MOTOR0_STEP4 addressed (W)" severity note;
              -- synopsys translate on
              reg_MOTOR0(15 downto 12) <= DAT_I(3 downto 0);
            end if;

            -- MOTOR 0 TRIGGER
            if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR0_TRIGGER)) then
              -- synopsys translate off
              assert false report "MOTORCONTROL_MOTOR0_TRIGGER addressed (W)" severity note;
              -- synopsys translate on
              reg_MOTOR0_TRIGGER <= DAT_I(0);
              reg_MOTOR0Counter <= unsigned(reg_MOTOR0_STEP); 
            end if;

            -- MOTOR 0 DIRECTION
            if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR0_DIRECTION)) then
              -- synopsys translate off
              assert false report "MOTORCONTROL_MOTOR0_DIRECTION addressed (W)" severity note;
              -- synopsys translate on
              reg_MOTOR0_Direction <= DAT_I(0);
            end if;

            -- STEPS to be counted for motor 1
            if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_STEP_MOTOR1)) then
              -- synopsys translate off
              assert false report "MOTORCONTROL_STEP_MOTOR1 addressed (W)" severity note;
              -- synopsys translate on
              reg_MOTOR1_STEP <= DAT_I(15 downto 0);
            end if;

            -- MOTOR 1 STEP 1
            if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR1_STEP1)) then
              -- synopsys translate off
              assert false report "MOTORCONTROL_MOTOR1_STEP1 addressed (W)" severity note;
              -- synopsys translate on
              reg_MOTOR1(3 downto 0) <= DAT_I(3 downto 0);
            end if;

            -- MOTOR 1 STEP 2
            if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR1_STEP2)) then
              -- synopsys translate off
              assert false report "MOTORCONTROL_MOTOR1_STEP2 addressed (W)" severity note;
              -- synopsys translate on
              reg_MOTOR1(7 downto 4) <= DAT_I(3 downto 0);
            end if;

            -- MOTOR 1 STEP 3
            if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR1_STEP3)) then
              -- synopsys translate off
              assert false report "MOTORCONTROL_MOTOR1_STEP3 addressed (W)" severity note;
              -- synopsys translate on
              reg_MOTOR1(11 downto 8) <= DAT_I(3 downto 0);
            end if;

            -- MOTOR 1 STEP 4
            if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR1_STEP4)) then
              -- synopsys translate off
              assert false report "MOTORCONTROL_MOTOR1_STEP4 addressed (W)" severity note;
              -- synopsys translate on
              reg_MOTOR1(15 downto 12) <= DAT_I(3 downto 0);
            end if;

            -- MOTOR 1 TRIGGER
            if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR1_TRIGGER)) then
              -- synopsys translate off
              assert false report "MOTORCONTROL_MOTOR1_TRIGGER addressed (W)" severity note;
              -- synopsys translate on
              reg_MOTOR1_TRIGGER <= DAT_I(0);
              reg_MOTOR1Counter <= unsigned(reg_MOTOR1_STEP); 
            end if;

            -- MOTOR 1 DIRECTION
            if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR1_DIRECTION)) then
              -- synopsys translate off
              assert false report "MOTORCONTROL_MOTOR1_DIRECTION addressed (W)" severity note;
              -- synopsys translate on
              reg_MOTOR1_Direction <= DAT_I(0);
            end if;

            -- STEPS to be counted for motor 2
            if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_STEP_MOTOR2)) then
              -- synopsys translate off
              assert false report "MOTORCONTROL_STEP_MOTOR2 addressed (W)" severity note;
              -- synopsys translate on
              reg_MOTOR2_STEP <= DAT_I(15 downto 0);
            end if;

            -- MOTOR 2 STEP 1
            if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR2_STEP1)) then
              -- synopsys translate off
              assert false report "MOTORCONTROL_MOTOR2_STEP1 addressed (W)" severity note;
              -- synopsys translate on
              reg_MOTOR2(3 downto 0) <= DAT_I(3 downto 0);
            end if;

            -- MOTOR 2 STEP 2
            if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR2_STEP2)) then
              -- synopsys translate off
              assert false report "MOTORCONTROL_MOTOR2_STEP2 addressed (W)" severity note;
              -- synopsys translate on
              reg_MOTOR2(7 downto 4) <= DAT_I(3 downto 0);
            end if;

            -- MOTOR 2 STEP 3
            if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR2_STEP3)) then
              -- synopsys translate off
              assert false report "MOTORCONTROL_MOTOR2_STEP3 addressed (W)" severity note;
              -- synopsys translate on
              reg_MOTOR2(11 downto 8) <= DAT_I(3 downto 0);
            end if;

            -- MOTOR 2 STEP 4
            if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR2_STEP4)) then
              -- synopsys translate off
              assert false report "MOTORCONTROL_MOTOR2_STEP4 addressed (W)" severity note;
              -- synopsys translate on
              reg_MOTOR2(15 downto 12) <= DAT_I(3 downto 0);
            end if;

            -- MOTOR 2 TRIGGER
            if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR2_TRIGGER)) then
              -- synopsys translate off
              assert false report "MOTORCONTROL_MOTOR2_TRIGGER addressed (W)" severity note;
              -- synopsys translate on
              reg_MOTOR2_TRIGGER <= DAT_I(0);
              reg_MOTOR2Counter <= unsigned(reg_MOTOR2_STEP); 
            end if;

            -- MOTOR 2 DIRECTION
            if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR2_DIRECTION)) then
              -- synopsys translate off
              assert false report "MOTORCONTROL_MOTOR2_DIRECTION addressed (W)" severity note;
              -- synopsys translate on
              reg_MOTOR2_Direction <= DAT_I(0);
            end if;

          end if;


        end if;
      
      end if;

    end if;

  end process;

  -- purpose: Selects the correct outputs
  -- type   : combinational
  -- inputs : ADDR_I,DAT_I, v_FSM
  -- outputs: 
  p_Select: process (ADDR_I,DAT_I, STB_I, WE_I,
                     reg_MOTOR0_STEP,
                     reg_MOTOR0,
                     reg_MOTOR0_TRIGGER,
                     reg_MOTOR0_DIRECTION,
                     reg_MOTOR1_STEP,
                     reg_MOTOR1,
                     reg_MOTOR1_TRIGGER,
                     reg_MOTOR1_DIRECTION,
                     reg_MOTOR2_STEP,
                     reg_MOTOR2,
                     reg_MOTOR2_TRIGGER,
                     reg_MOTOR2_DIRECTION
                     )

  begin  -- process p_Select

    -- ======================
    -- === WISHBONE READ ===
    -- ======================

    DAT_O(31 downto 0) <= (others => '0');
    
    if (STB_I = '1') then

      -- If Strobe in is activated, treat the data
      if (to_integer(unsigned(ADDR_I)) <= (g_base_address + C_MOTORCONTROL_MAX_OFFSET)) then

        -- synopsys translate off
        assert false report "Motor Control addressed: ADDR_I: " & slv2hexS(std_logic_vector'(ADDR_I)) & " DAT_I = " & slv2hexS(std_logic_vector'(DAT_I(31 downto 0))) severity note;
        -- synopsys translate on

        -- MOTOR 0 step (LSB)
        if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_STEP_MOTOR0)) then
          DAT_O(31 downto 0) <= (others => '0');
          DAT_O(15 downto 0) <= reg_MOTOR0_STEP;
        end if;

        -- MOTOR 0 STEP 1
        if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR0_STEP1)) then
          DAT_O(31 downto 0) <= (others => '0');
          DAT_O(3 downto 0) <= reg_MOTOR0(3 downto 0);
        end if;

        -- MOTOR 0 STEP 2
        if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR0_STEP2)) then
          DAT_O(31 downto 0) <= (others => '0');
          DAT_O(3 downto 0) <= reg_MOTOR0(7 downto 4);
        end if;

        -- MOTOR 0 STEP 3
        if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR0_STEP3)) then
          DAT_O(31 downto 0) <= (others => '0');
          DAT_O(3 downto 0) <= reg_MOTOR0(11 downto 8);
        end if;

        -- MOTOR 0 STEP 4
        if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR0_STEP4)) then
          DAT_O(31 downto 0) <= (others => '0');
          DAT_O(3 downto 0) <= reg_MOTOR0(15 downto 12);
        end if;

        -- MOTOR 0 TRIGGER
        if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR0_TRIGGER)) then
          DAT_O(31 downto 0) <= (others => '0');
          DAT_O(0) <= reg_MOTOR0_TRIGGER;
        end if;

        -- MOTOR 0 DIRECTION
        if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR0_DIRECTION)) then
          DAT_O(31 downto 0) <= (others => '0');
          DAT_O(0) <= reg_MOTOR0_Direction;
        end if;

        -- MOTOR 1 step (LSB)
        if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_STEP_MOTOR1)) then
          DAT_O(31 downto 0) <= (others => '0');
          DAT_O(15 downto 0) <= reg_MOTOR1_STEP;
        end if;

        -- MOTOR 1 STEP 1
        if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR1_STEP1)) then
          DAT_O(31 downto 0) <= (others => '0');
          DAT_O(3 downto 0) <= reg_MOTOR1(3 downto 0);
        end if;

        -- MOTOR 1 STEP 2
        if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR1_STEP2)) then
          DAT_O(31 downto 0) <= (others => '0');
          DAT_O(3 downto 0) <= reg_MOTOR1(7 downto 4);
        end if;

        -- MOTOR 1 STEP 3
        if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR1_STEP3)) then
          DAT_O(31 downto 0) <= (others => '0');
          DAT_O(3 downto 0) <= reg_MOTOR1(11 downto 8);
        end if;

        -- MOTOR 1 STEP 4
        if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR1_STEP4)) then
          DAT_O(31 downto 0) <= (others => '0');
          DAT_O(3 downto 0) <= reg_MOTOR1(15 downto 12);
        end if;

        -- MOTOR 1 TRIGGER
        if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR1_TRIGGER)) then
          DAT_O(31 downto 0) <= (others => '0');
          DAT_O(0) <= reg_MOTOR1_TRIGGER;
        end if;

        -- MOTOR 1 DIRECTION
        if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR1_DIRECTION)) then
          DAT_O(31 downto 0) <= (others => '0');
          DAT_O(0) <= reg_MOTOR1_Direction;
        end if;

        -- MOTOR 2 step (LSB)
        if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_STEP_MOTOR2)) then
          DAT_O(31 downto 0) <= (others => '0');
          DAT_O(15 downto 0) <= reg_MOTOR2_STEP;
        end if;

        -- MOTOR 2 STEP 1
        if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR2_STEP1)) then
          DAT_O(31 downto 0) <= (others => '0');
          DAT_O(3 downto 0) <= reg_MOTOR2(3 downto 0);
        end if;

        -- MOTOR 2 STEP 2
        if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR2_STEP2)) then
          DAT_O(31 downto 0) <= (others => '0');
          DAT_O(3 downto 0) <= reg_MOTOR2(7 downto 4);
        end if;

        -- MOTOR 2 STEP 3
        if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR2_STEP3)) then
          DAT_O(31 downto 0) <= (others => '0');
          DAT_O(3 downto 0) <= reg_MOTOR2(11 downto 8);
        end if;

        -- MOTOR 2 STEP 4
        if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR2_STEP4)) then
          DAT_O(31 downto 0) <= (others => '0');
          DAT_O(3 downto 0) <= reg_MOTOR2(15 downto 12);
        end if;

        -- MOTOR 2 TRIGGER
        if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR2_TRIGGER)) then
          DAT_O(31 downto 0) <= (others => '0');
          DAT_O(0) <= reg_MOTOR2_TRIGGER;
        end if;

        -- MOTOR 2 DIRECTION
        if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_MOTORCONTROL_MOTOR2_DIRECTION)) then
          DAT_O(31 downto 0) <= (others => '0');
          DAT_O(0) <= reg_MOTOR2_Direction;
        end if;

      end if;

    end if;

  end process p_Select;


  -- Continuous assignments
  ACK_O         <= reg_ACK;
  p_MOTOR0_ENABLE <= '1';
  p_MOTOR1_ENABLE <= '1';
  p_MOTOR2_ENABLE <= '1';

  --p_PWM_H       <= reg_PWM;
-- purpose: Creates the outputs for Motor 0
-- type   : combinational
-- inputs : reg_MOTOR0, reg_MotorCounter
-- outputs: 
p_MOTOR0: process (reg_MOTOR0,reg_PhaseCounter0, reg_MOTOR0_Direction)
begin  -- process p_MOTOR0

  -- Default assignments
  p_MOTOR0_OUT0 <= '0';
  p_MOTOR0_OUT1 <= '0';
  p_MOTOR0_OUT2 <= '0';
  p_MOTOR0_OUT3 <= '0';

  case reg_PhaseCounter0(1 downto 0) is
    when "00" =>
      if reg_MOTOR0_Direction = '0' then       -- Forward
        p_MOTOR0_OUT0 <= reg_Motor0(0);
        p_MOTOR0_OUT1 <= reg_Motor0(1);
        p_MOTOR0_OUT2 <= reg_Motor0(2);
        p_MOTOR0_OUT3 <= reg_Motor0(3);
      else                              -- Backwards
        p_MOTOR0_OUT0 <= reg_Motor0(12);
        p_MOTOR0_OUT1 <= reg_Motor0(13);
        p_MOTOR0_OUT2 <= reg_Motor0(14);
        p_MOTOR0_OUT3 <= reg_Motor0(15);
      end if;
    when "01" =>
      if reg_MOTOR0_Direction = '0' then       -- Forward
        p_MOTOR0_OUT0 <= reg_Motor0(4);
        p_MOTOR0_OUT1 <= reg_Motor0(5);
        p_MOTOR0_OUT2 <= reg_Motor0(6);
        p_MOTOR0_OUT3 <= reg_Motor0(7);
      else                              -- Backwards
        p_MOTOR0_OUT0 <= reg_Motor0(8);
        p_MOTOR0_OUT1 <= reg_Motor0(9);
        p_MOTOR0_OUT2 <= reg_Motor0(10);
        p_MOTOR0_OUT3 <= reg_Motor0(11);
      end if;
    when "10" =>
      if reg_MOTOR0_Direction = '0' then       -- Forward
        p_MOTOR0_OUT0 <= reg_Motor0(8);
        p_MOTOR0_OUT1 <= reg_Motor0(9);
        p_MOTOR0_OUT2 <= reg_Motor0(10);
        p_MOTOR0_OUT3 <= reg_Motor0(11);
      else                              -- Backwards
        p_MOTOR0_OUT0 <= reg_Motor0(4);
        p_MOTOR0_OUT1 <= reg_Motor0(5);
        p_MOTOR0_OUT2 <= reg_Motor0(6);
        p_MOTOR0_OUT3 <= reg_Motor0(7);
      end if;
    when "11" =>
      if reg_MOTOR0_Direction = '0' then       -- Forward
        p_MOTOR0_OUT0 <= reg_Motor0(12);
        p_MOTOR0_OUT1 <= reg_Motor0(13);
        p_MOTOR0_OUT2 <= reg_Motor0(14);
        p_MOTOR0_OUT3 <= reg_Motor0(15);
      else                              -- Backwards
        p_MOTOR0_OUT0 <= reg_Motor0(0);
        p_MOTOR0_OUT1 <= reg_Motor0(1);
        p_MOTOR0_OUT2 <= reg_Motor0(2);
        p_MOTOR0_OUT3 <= reg_Motor0(3);
      end if;
    when others => null;
                   
  end case;
    

end process p_MOTOR0;

  --p_PWM_H       <= reg_PWM;
-- purpose: Creates the outputs for Motor 1
-- type   : combinational
-- inputs : reg_MOTOR1, reg_MotorCounter
-- outputs: 
p_MOTOR1: process (reg_MOTOR1,reg_PhaseCounter1, reg_MOTOR1_Direction)
begin  -- process p_MOTOR1

  -- Default assignments
  p_MOTOR1_OUT0 <= '0';
  p_MOTOR1_OUT1 <= '0';
  p_MOTOR1_OUT2 <= '0';
  p_MOTOR1_OUT3 <= '0';

  case reg_PhaseCounter1(1 downto 0) is
    when "00" =>
      if reg_MOTOR1_Direction = '0' then       -- Forward
        p_MOTOR1_OUT0 <= reg_Motor1(0);
        p_MOTOR1_OUT1 <= reg_Motor1(1);
        p_MOTOR1_OUT2 <= reg_Motor1(2);
        p_MOTOR1_OUT3 <= reg_Motor1(3);
      else                              -- Backwards
        p_MOTOR1_OUT0 <= reg_Motor1(12);
        p_MOTOR1_OUT1 <= reg_Motor1(13);
        p_MOTOR1_OUT2 <= reg_Motor1(14);
        p_MOTOR1_OUT3 <= reg_Motor1(15);
      end if;
    when "01" =>
      if reg_MOTOR1_Direction = '0' then       -- Forward
        p_MOTOR1_OUT0 <= reg_Motor1(4);
        p_MOTOR1_OUT1 <= reg_Motor1(5);
        p_MOTOR1_OUT2 <= reg_Motor1(6);
        p_MOTOR1_OUT3 <= reg_Motor1(7);
      else                              -- Backwards
        p_MOTOR1_OUT0 <= reg_Motor1(8);
        p_MOTOR1_OUT1 <= reg_Motor1(9);
        p_MOTOR1_OUT2 <= reg_Motor1(10);
        p_MOTOR1_OUT3 <= reg_Motor1(11);
      end if;
    when "10" =>
      if reg_MOTOR1_Direction = '0' then       -- Forward
        p_MOTOR1_OUT0 <= reg_Motor1(8);
        p_MOTOR1_OUT1 <= reg_Motor1(9);
        p_MOTOR1_OUT2 <= reg_Motor1(10);
        p_MOTOR1_OUT3 <= reg_Motor1(11);
      else                              -- Backwards
        p_MOTOR1_OUT0 <= reg_Motor1(4);
        p_MOTOR1_OUT1 <= reg_Motor1(5);
        p_MOTOR1_OUT2 <= reg_Motor1(6);
        p_MOTOR1_OUT3 <= reg_Motor1(7);
      end if;
    when "11" =>
      if reg_MOTOR1_Direction = '0' then       -- Forward
        p_MOTOR1_OUT0 <= reg_Motor1(12);
        p_MOTOR1_OUT1 <= reg_Motor1(13);
        p_MOTOR1_OUT2 <= reg_Motor1(14);
        p_MOTOR1_OUT3 <= reg_Motor1(15);
      else                              -- Backwards
        p_MOTOR1_OUT0 <= reg_Motor1(0);
        p_MOTOR1_OUT1 <= reg_Motor1(1);
        p_MOTOR1_OUT2 <= reg_Motor1(2);
        p_MOTOR1_OUT3 <= reg_Motor1(3);
      end if;
    when others => null;
                   
  end case;   
                   
end process p_MOTOR1;

  --p_PWM_H       <= reg_PWM;
-- purpose: Creates the outputs for Motor 2
-- type   : combinational
-- inputs : reg_MOTOR2, reg_MotorCounter
-- outputs: 
p_MOTOR2: process (reg_MOTOR2,reg_PhaseCounter1, reg_MOTOR2_Direction)
begin  -- process p_MOTOR2

  -- Default assignments
  p_MOTOR2_OUT0 <= '0';
  p_MOTOR2_OUT1 <= '0';
  p_MOTOR2_OUT2 <= '0';
  p_MOTOR2_OUT3 <= '0';

  case reg_PhaseCounter1(1 downto 0) is
    when "00" =>
      if reg_MOTOR2_Direction = '0' then       -- Forward
        p_MOTOR2_OUT0 <= reg_Motor2(0);
        p_MOTOR2_OUT1 <= reg_Motor2(1);
        p_MOTOR2_OUT2 <= reg_Motor2(2);
        p_MOTOR2_OUT3 <= reg_Motor2(3);
      else                              -- Backwards
        p_MOTOR2_OUT0 <= reg_Motor2(12);
        p_MOTOR2_OUT1 <= reg_Motor2(13);
        p_MOTOR2_OUT2 <= reg_Motor2(14);
        p_MOTOR2_OUT3 <= reg_Motor2(15);
      end if;
    when "01" =>
      if reg_MOTOR2_Direction = '0' then       -- Forward
        p_MOTOR2_OUT0 <= reg_Motor2(4);
        p_MOTOR2_OUT1 <= reg_Motor2(5);
        p_MOTOR2_OUT2 <= reg_Motor2(6);
        p_MOTOR2_OUT3 <= reg_Motor2(7);
      else                              -- Backwards
        p_MOTOR2_OUT0 <= reg_Motor2(8);
        p_MOTOR2_OUT1 <= reg_Motor2(9);
        p_MOTOR2_OUT2 <= reg_Motor2(10);
        p_MOTOR2_OUT3 <= reg_Motor2(11);
      end if;
    when "10" =>
      if reg_MOTOR2_Direction = '0' then       -- Forward
        p_MOTOR2_OUT0 <= reg_Motor2(8);
        p_MOTOR2_OUT1 <= reg_Motor2(9);
        p_MOTOR2_OUT2 <= reg_Motor2(10);
        p_MOTOR2_OUT3 <= reg_Motor2(11);
      else                              -- Backwards
        p_MOTOR2_OUT0 <= reg_Motor2(4);
        p_MOTOR2_OUT1 <= reg_Motor2(5);
        p_MOTOR2_OUT2 <= reg_Motor2(6);
        p_MOTOR2_OUT3 <= reg_Motor2(7);
      end if;
    when "11" =>
      if reg_MOTOR2_Direction = '0' then       -- Forward
        p_MOTOR2_OUT0 <= reg_Motor2(12);
        p_MOTOR2_OUT1 <= reg_Motor2(13);
        p_MOTOR2_OUT2 <= reg_Motor2(14);
        p_MOTOR2_OUT3 <= reg_Motor2(15);
      else                              -- Backwards
        p_MOTOR2_OUT0 <= reg_Motor2(0);
        p_MOTOR2_OUT1 <= reg_Motor2(1);
        p_MOTOR2_OUT2 <= reg_Motor2(2);
        p_MOTOR2_OUT3 <= reg_Motor2(3);
      end if;
    when others => null;
                   
  end case;   
    
end process p_MOTOR2;


end RTL;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------

