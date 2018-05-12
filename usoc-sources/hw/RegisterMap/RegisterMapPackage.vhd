-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- Register Map for this SoC
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

-- Standard
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

-- SoC Constants

-- ZPU related
use work.zpu_config.all;

-- Other

----------------------------------
-- COMPONENT PACKAGE DEFINITION --
----------------------------------

package RegisterMapPackage is

  -----------------------------------------------------
  --                  WISHBONE BUS                   --
  -----------------------------------------------------

  -- FLASH
  constant C_FLASH_BASE_ADDRESS : integer := 16#000000#;
  constant C_FLASH_MAX_OFFSET   : integer := 16#1FFFFF#;

  -- INTERNAL MEMORY
  constant C_STACK_BASE_ADDRESS : integer := 16#400000#;
  constant C_STACK_MAX_OFFSET   : integer := 16#0007FF#;

  -- FLASH CONTROLLER 
  constant C_FLASHCONTROLLER_BASE_ADDRESS     : integer := 16#2000020#;
  constant C_FLASHCONTROLLER_COMMAND          : integer := 16#00#;
  constant C_FLASHCONTROLLER_MANUFACTURERID   : integer := 16#01#;
  constant C_FLASHCONTROLLER_DEVICEIDCYCLE1   : integer := 16#02#;
  constant C_FLASHCONTROLLER_DEVICEIDCYCLE2   : integer := 16#03#;
  constant C_FLASHCONTROLLER_DEVICEIDCYCLE3   : integer := 16#04#;
  constant C_FLASHCONTROLLER_STARTADDRESS_LSB : integer := 16#05#;
  constant C_FLASHCONTROLLER_STARTADDRESS_MSB : integer := 16#06#;
  constant C_FLASHCONTROLLER_ACCESS           : integer := 16#07#;
  constant C_FLASHCONTROLLER_FIXEDADDRESS     : integer := 16#08#;
  constant C_FLASHCONTROLLER_FIXEDDATA        : integer := 16#09#;
  constant C_FLASHCONTROLLER_INTERRUPT        : integer := 16#0A#;
  constant C_FLASHCONTROLLER_MAX_OFFSET       : integer := 16#0F#;


  -- LED interface Controller
  constant C_LEDINTERFACE_BASE_ADDRESS : integer := 16#2000010#;
  constant C_ZPUCONTROL                : integer := 16#00#;
  constant C_LEDINTERFACE_MAX_OFFSET   : integer := 16#2#;

  -- uSoC Controller
  constant C_USOCCONTROLLER_BASE_ADDRESS : integer := 16#2000040#;
  constant C_USOCCONTROLLER_MAX_OFFSET   : integer := 16#2#;

  -- MINIUART
  constant C_MINIUART_BASE_ADDRESS     : integer := 16#2000000#;
  constant C_MINUART_READ              : integer := 16#00#;
  constant C_MINUART_WRITE             : integer := 16#00#;
  constant C_MINIUART_MAX_OFFSET       : integer := 16#2#;

  -- FLASH PROGRAM CACHE 
  constant C_FLASHPROGRAMCACHE_BASE_ADDRESS     : integer := 16#2000030#;
  constant C_FLASHPROGRAMCACHE_CONTROL          : integer := 16#08#;
  constant C_FLASHPROGRAMCACHE_MAX_OFFSET       : integer := 16#10#;

  --  PWM GENERATOR
  constant C_PWMGENERATOR_BASE_ADDRESS          : integer := 16#2000400#;
  constant C_PWMGENERATOR_PWM0CYCLE             : integer := 16#00#;
  constant C_PWMGENERATOR_PWM1CYCLE             : integer := 16#01#;
  constant C_PWMGENERATOR_MAX_OFFSET            : integer := 16#2#;

  --  MOTOR CONTROL
  constant C_MOTORCONTROL_BASE_ADDRESS           : integer := 16#2000100#;
  constant C_MOTORCONTROL_STEP_MOTOR0            : integer := 16#00#;
  constant C_MOTORCONTROL_MOTOR0_STEP1           : integer := 16#01#;
  constant C_MOTORCONTROL_MOTOR0_STEP2           : integer := 16#02#;
  constant C_MOTORCONTROL_MOTOR0_STEP3           : integer := 16#03#;
  constant C_MOTORCONTROL_MOTOR0_STEP4           : integer := 16#04#;
  constant C_MOTORCONTROL_MOTOR0_TRIGGER          : integer := 16#05#;
  constant C_MOTORCONTROL_MOTOR0_DIRECTION       : integer := 16#06#;
  constant C_MOTORCONTROL_STEP_MOTOR1            : integer := 16#10#;
  constant C_MOTORCONTROL_MOTOR1_STEP1           : integer := 16#11#;
  constant C_MOTORCONTROL_MOTOR1_STEP2           : integer := 16#12#;
  constant C_MOTORCONTROL_MOTOR1_STEP3           : integer := 16#13#;
  constant C_MOTORCONTROL_MOTOR1_STEP4           : integer := 16#14#;
  constant C_MOTORCONTROL_MOTOR1_TRIGGER          : integer := 16#15#;
  constant C_MOTORCONTROL_MOTOR1_DIRECTION       : integer := 16#16#;
  constant C_MOTORCONTROL_STEP_MOTOR2            : integer := 16#20#;
  constant C_MOTORCONTROL_MOTOR2_STEP1           : integer := 16#21#;
  constant C_MOTORCONTROL_MOTOR2_STEP2           : integer := 16#22#;
  constant C_MOTORCONTROL_MOTOR2_STEP3           : integer := 16#23#;
  constant C_MOTORCONTROL_MOTOR2_STEP4           : integer := 16#24#;
  constant C_MOTORCONTROL_MOTOR2_TRIGGER          : integer := 16#25#;
  constant C_MOTORCONTROL_MOTOR2_DIRECTION       : integer := 16#26#;
  constant C_MOTORCONTROL_MAX_OFFSET             : integer := 16#2FF#;

  -----------------------------------------------------
  --               INSTRUCTION BUS                   --
  -----------------------------------------------------

  constant C_INSTRBUS_PROGRAM_MIN_ADDRESS   : integer := 16#0000#;
  constant C_INSTRBUS_PROGRAM_SIZE          : integer := 16#8000#;

  constant C_INSTRBUS_STACK_MIN_ADDRESS   : integer := 16#8000#;
  constant C_INSTRBUS_STACK_SIZE          : integer := 16#3FFD#;

  constant C_INSTRBUS_WB_MIN_ADDRESS   : integer := 16#8000000#;
  constant C_INSTRBUS_WB_SIZE          : integer := 16#43C#;

end RegisterMapPackage;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------
   
