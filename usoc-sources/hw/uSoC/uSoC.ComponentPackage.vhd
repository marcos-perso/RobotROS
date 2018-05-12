-------------------------------------------------------------------------------
-- My Own SoC top level
-------------------------------------------------------------------------------

---------------
-- LIBRARIES --
---------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SOCConstantsPackage.all;

----------------------------------
-- COMPONENT PACKAGE DEFINITION --
----------------------------------

package uSoCComponentPackage is

--------------------------
-- COMPONENT DEFINITION --
--------------------------
 
  component uSoC is
    port(
      clk           : in std_logic;
      reset         : in std_logic;
      p_LED0        : out std_ulogic;
      p_LED1        : out std_ulogic;
      p_LED2        : out std_ulogic;
      p_LED3        : out std_ulogic;
      p_FromButton1 : in  std_logic;
      p_FromButton2 : in  std_logic;
      p_FromButton3 : in  std_logic;
      p_UART_TX     : out std_logic;
      p_UART_RX     : in  std_logic;
      p_MOTOR0_ENABLE : out std_logic;
      p_MOTOR0_OUT0 : out std_logic;
      p_MOTOR0_OUT1 : out std_logic;
      p_MOTOR0_OUT2 : out std_logic;
      p_MOTOR0_OUT3 : out std_logic;
      p_MOTOR1_ENABLE : out std_logic;
      p_MOTOR1_OUT0 : out std_logic;
      p_MOTOR1_OUT1 : out std_logic;
      p_MOTOR1_OUT2 : out std_logic;
      p_MOTOR1_OUT3 : out std_logic;
      p_MOTOR2_ENABLE : out std_logic;
      p_MOTOR2_OUT0 : out std_logic;
      p_MOTOR2_OUT1 : out std_logic;
      p_MOTOR2_OUT2 : out std_logic;
      p_MOTOR2_OUT3 : out std_logic;
      p_PWM0_P      : out std_logic;
      p_PWM0_N      : out std_logic;
      p_PWM1_P      : out std_logic;
      p_PWM1_N      : out std_logic;
      p_FL_ADDR20   : out std_logic;
      p_FL_ADDR19   : out std_logic;
      p_FL_ADDR18   : out std_logic;
      p_FL_ADDR17   : out std_logic;
      p_FL_ADDR16   : out std_logic;
      p_FL_ADDR15   : out std_logic;
      p_FL_ADDR14   : out std_logic;
      p_FL_ADDR13   : out std_logic;
      p_FL_ADDR12   : out std_logic;
      p_FL_ADDR11   : out std_logic;
      p_FL_ADDR10   : out std_logic;
      p_FL_ADDR9    : out std_logic;
      p_FL_ADDR8    : out std_logic;
      p_FL_ADDR7    : out std_logic;
      p_FL_ADDR6    : out std_logic;
      p_FL_ADDR5    : out std_logic;
      p_FL_ADDR4    : out std_logic;
      p_FL_ADDR3    : out std_logic;
      p_FL_ADDR2    : out std_logic;
      p_FL_ADDR1    : out std_logic;
      p_FL_ADDR0    : out std_logic;
      p_FL_DQ15     : inout std_logic;
      p_FL_DQ14     : inout std_logic;
      p_FL_DQ13     : inout std_logic;
      p_FL_DQ12     : inout std_logic;
      p_FL_DQ11     : inout std_logic;
      p_FL_DQ10     : inout std_logic;
      p_FL_DQ9      : inout std_logic;
      p_FL_DQ8      : inout std_logic;
      p_FL_DQ7      : inout std_logic;
      p_FL_DQ6      : inout std_logic;
      p_FL_DQ5      : inout std_logic;
      p_FL_DQ4      : inout std_logic;
      p_FL_DQ3      : inout std_logic;
      p_FL_DQ2      : inout std_logic;
      p_FL_DQ1      : inout std_logic;
      p_FL_DQ0      : inout std_logic;
      p_FL_CENeg    : out std_logic;
      p_FL_OENeg    : out std_logic;
      p_FL_WENeg    : out std_logic;
      p_FL_ResetNeg : out std_logic;
      p_FL_ByteNeg  : out std_logic;
      p_FL_RY       : in std_logic;
      p_Debug1      : out std_logic;
      p_Debug2      : out std_logic
      );
  end component;

end uSoCComponentPackage;
