
---------------
-- LIBRARIES --
---------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SOCConstantsPackage.all;
use work.WishboneConstantsPackage.all;

----------------------------------
-- COMPONENT PACKAGE DEFINITION --
----------------------------------

package MotorControlComponentPackage is

--------------------------
-- COMPONENT DEFINITION --
--------------------------
 
  component MotorControl is
    generic (
      g_log_file     : string;
      g_base_address : integer
      );
    port(

      CLK_I  : in  std_logic;
      RST_I  : in  std_logic;
      ACK_O  : out std_logic;
      ADDR_I : in  std_logic_vector(c_WishboneAddrWidth - 1 downto 0);
      DAT_I  : in  std_logic_vector(c_WishboneDataWidth - 1 downto 0);
      DAT_O  : out std_logic_vector(c_WishboneDataWidth - 1 downto 0);
      STB_I  : in  std_logic;
      WE_I   : in  std_logic;

      -- Interface to Motors
      p_MOTOR0_ENABLE  : out std_logic;
      p_MOTOR0_OUT0    : out std_logic;
      p_MOTOR0_OUT1    : out std_logic;
      p_MOTOR0_OUT2    : out std_logic;
      p_MOTOR0_OUT3    : out std_logic;
      p_MOTOR1_ENABLE  : out std_logic;
      p_MOTOR1_OUT0    : out std_logic;
      p_MOTOR1_OUT1    : out std_logic;
      p_MOTOR1_OUT2    : out std_logic;
      p_MOTOR1_OUT3    : out std_logic;
      p_MOTOR2_ENABLE  : out std_logic;
      p_MOTOR2_OUT0    : out std_logic;
      p_MOTOR2_OUT1    : out std_logic;
      p_MOTOR2_OUT2    : out std_logic;
      p_MOTOR2_OUT3    : out std_logic

      );

  end component;

end MotorControlComponentPackage;
