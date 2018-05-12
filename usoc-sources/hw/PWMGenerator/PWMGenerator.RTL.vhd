-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- 
-- Controls the PWM signal generation
-- 
-- NOTES:
-- 
-- REGISTERS:
--     BASE_ADDRESS + 0 : PWM_CYCLE: Cycle rate of the PWM (0-255). 255=100% on
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
use work.PWMGeneratorPackage.all;
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
 
architecture RTL of PWMGenerator is


  -- CONSTANTS DEFINITION --

  -- SIGNAL DEFINITION --

  signal reg_PWM0Cycle   : std_logic_vector(C_NB_BITS_PWM_COUNTER-1 downto 0);  -- PWM cycle
  signal reg_PWM1Cycle   : std_logic_vector(C_NB_BITS_PWM_COUNTER-1 downto 0);  -- PWM cycle

  signal reg_ACK          : std_logic;

  signal PWMCounter : unsigned(C_NB_BITS_PWM_COUNTER-1 downto 0);

  signal reg_PWM0 : std_logic;
  signal reg_PWM1 : std_logic;

  signal reg_Direction_PWM_0 : std_logic;  -- Direction of PWM 0
  signal reg_Direction_PWM_1 : std_logic;  -- Direction of PWM 0

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

      -- Reset
      reg_ACK             <= '0';
      reg_PWM0Cycle       <= (others => '0');
      reg_PWM1Cycle       <= (others => '0');
      PWMCounter          <= to_unsigned(0, C_NB_BITS_PWM_COUNTER);
      reg_PWM0            <= '0';
      reg_PWM1            <= '0';
      reg_Direction_PWM_0 <= '1';
      reg_Direction_PWM_1 <= '1';
      
    elsif CLK_I'event and CLK_I = '1' then

      -- Default

      -- PWM Generator
      -- keep interrupt signal high for 16 cycles
      if (PWMCounter < to_unsigned(C_PWMCOUNTER_MAX,C_NB_BITS_PWM_COUNTER))
      then
        PWMCounter <= PWMCounter + 1;
      else
        PWMCounter <= to_unsigned(0,C_NB_BITS_PWM_COUNTER);
      end if;

      -- Motor 0
      if (PWMCounter < to_unsigned(to_integer(unsigned(reg_PWM0Cycle)),C_NB_BITS_PWM_COUNTER)) then
        reg_PWM0 <= '0';
      else
        reg_PWM0 <= '1';
      end if;

      -- Motor 1
      if (PWMCounter < to_unsigned(to_integer(unsigned(reg_PWM1Cycle)),C_NB_BITS_PWM_COUNTER)) then
        reg_PWM1 <= '0';
      else
        reg_PWM1 <= '1';
      end if;

      -- Signal creation
      if (reg_ACK = '0') and (STB_I = '1') then
        reg_ACK <= '1';
      else
        reg_ACK <= '0';
      end if;


      if (STB_I = '1') then

        -- synopsys translate off
        assert false report "PWM Generator addressed: ADDR_I: " & slv2hexS(std_logic_vector'(ADDR_I)) & " DAT_I = " & slv2hexS(std_logic_vector'(DAT_I(31 downto 0))) severity note;
        -- synopsys translate on

        -- If Strobe in is activated, treat the data
        if (to_integer(unsigned(ADDR_I)) <= (g_base_address + C_PWMGENERATOR_MAX_OFFSET)) then

          if WE_I = '1' then
            -- === WRITE ===

            if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_PWMGENERATOR_PWM0CYCLE)) then

              -- synopsys translate off
              assert false report "PWMGENERATOR_PWM0CYCLE addressed (W)" severity note;
              -- synopsys translate on
              reg_PWM0Cycle <= DAT_I(C_NB_BITS_PWM_COUNTER-1 downto 0);
              reg_Direction_PWM_0 <= DAT_I(C_NB_BITS_PWM_COUNTER);

            if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_PWMGENERATOR_PWM1CYCLE)) then

              -- synopsys translate off
              assert false report "PWMGENERATOR_PWM1CYCLE addressed (W)" severity note;
              -- synopsys translate on
              reg_PWM1Cycle <= DAT_I(C_NB_BITS_PWM_COUNTER-1 downto 0);
              reg_Direction_PWM_1 <= DAT_I(C_NB_BITS_PWM_COUNTER);

            end if;

            end if;

          end if;


        end if;
      
      end if;

      -- Here comes PWM functionality
      
    end if;

  end process;

  -- purpose: Selects the correct outputs
  -- type   : combinational
  -- inputs : ADDR_I,DAT_I, v_FSM
  -- outputs: 
  p_Select: process (ADDR_I,DAT_I, STB_I, WE_I,reg_PWM0Cycle, reg_PWM1Cycle)

  begin  -- process p_Select

    DAT_O(31 downto 0) <= (others => '0');
    
    if (STB_I = '1') then

      -- If Strobe in is activated, treat the data
      if (to_integer(unsigned(ADDR_I)) <= (g_base_address + C_PWMGENERATOR_MAX_OFFSET)) then

        -- synopsys translate off
        assert false report "PWM Generator addressed: ADDR_I: " & slv2hexS(std_logic_vector'(ADDR_I)) & " DAT_I = " & slv2hexS(std_logic_vector'(DAT_I(31 downto 0))) severity note;
        -- synopsys translate on

        -- ** PWM0 Cycle
        if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_PWMGENERATOR_PWM0CYCLE)) then
          DAT_O(31 downto 0) <= (others => '0');
          DAT_O(C_NB_BITS_PWM_COUNTER-1 downto 0) <= reg_PWM0Cycle;
          DAT_O(C_NB_BITS_PWM_COUNTER) <= reg_Direction_PWM_0;
        end if;

        -- ** PWM1 Cycle
        if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_PWMGENERATOR_PWM1CYCLE)) then
          DAT_O(31 downto 0) <= (others => '0');
          DAT_O(C_NB_BITS_PWM_COUNTER-1 downto 0) <= reg_PWM1Cycle;
          DAT_O(C_NB_BITS_PWM_COUNTER) <= reg_Direction_PWM_1;
        end if;

      end if;

    end if;

  end process p_Select;


  -- Continuous assignments
  ACK_O         <= reg_ACK;

  -- purpose: Create motor outputs
  -- type   : combinational
  -- inputs : reg_PWM0, reg_PWM1
  -- outputs: 
  p_PWM_OUTPUTS: process (reg_PWM0, reg_PWM1,
                          reg_Direction_PWM_0,
                          reg_Direction_PWM_1
                          )
  begin  -- process p_PWM_OUTPUTS

    if (reg_Direction_PWM_0 = '1') then

      p_PWM0_P       <= reg_PWM0;
      p_PWM0_N       <= '0';

    else

      p_PWM0_P       <= '0';
      p_PWM0_N       <= reg_PWM0;
  
    end if;

    if (reg_Direction_PWM_1 = '1') then

      p_PWM1_P       <= reg_PWM1;
      p_PWM1_N       <= '0';

    else

      p_PWM1_P       <= '0';
      p_PWM1_N       <= reg_PWM1;
  
    end if;
    
  end process p_PWM_OUTPUTS;

end RTL;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------

