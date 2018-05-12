-------------------------------------------------------------------------------
-- Controls the PWM signal generation
-- TBD:
-------------------------------------------------------------------------------

---------------
-- LIBRARIES --
---------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.SOCConstantsPackage.all;
use work.WishboneConstantsPackage.all;

-----------------------
-- ENTITY DEFINITION --
-----------------------
 
entity MotorControl is

  generic (
    g_log_file     : string;     -- Debug file
    g_base_address : integer     -- Base address
    );

  port(

    -- Wishbone interface
    CLK_I  : in  std_logic;                                          -- Input clock
    RST_I  : in  std_logic;                                          -- Input reset
    ACK_O  : out std_logic;                                          -- Acknowdledge
    ADDR_I : in  std_logic_vector(c_WishboneAddrWidth - 1 downto 0);
    DAT_I  : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0); -- Data Input
    DAT_O  : out std_logic_vector(c_WishboneDataWidth - 1 downto 0); -- Data Output
    STB_I  : in  std_logic;                                          -- Strobe In
    WE_I   : in  std_logic;                                          -- Write Enable

    -- Interface to Motors (Motor 0)
    p_MOTOR0_ENABLE  : out std_logic;
    p_MOTOR0_OUT0    : out std_logic;
    p_MOTOR0_OUT1    : out std_logic;
    p_MOTOR0_OUT2    : out std_logic;
    p_MOTOR0_OUT3    : out std_logic;

    -- Interface to Motors (Motor 1)
    p_MOTOR1_ENABLE  : out std_logic;
    p_MOTOR1_OUT0    : out std_logic;
    p_MOTOR1_OUT1    : out std_logic;
    p_MOTOR1_OUT2    : out std_logic;
    p_MOTOR1_OUT3    : out std_logic;

    -- Interface to Motors (Motor 2)
    p_MOTOR2_ENABLE  : out std_logic;
    p_MOTOR2_OUT0    : out std_logic;
    p_MOTOR2_OUT1    : out std_logic;
    p_MOTOR2_OUT2    : out std_logic;
    p_MOTOR2_OUT3    : out std_logic

    );  
end MotorControl;
