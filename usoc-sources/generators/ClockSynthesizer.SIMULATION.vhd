--------------------------------------------------------------------------------
-- Copyright (c) 1995-2008 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  Simple simulation model for ClockSynhesizer (not including Xilinx
--  primitives and thus speeding up the simulation

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity ClockSynthesizer is
   port ( CLKIN_IN        : in    std_logic; 
          RST_IN          : in    std_logic; 
          CLKFX_OUT       : out   std_logic; 
          CLKIN_IBUFG_OUT : out   std_logic; 
          CLK0_OUT        : out   std_logic; 
          CLK2X_OUT       : out   std_logic; 
          CLK180_OUT      : out   std_logic; 
          LOCKED_OUT      : out   std_logic; 
          STATUS_OUT      : out   std_logic_vector (7 downto 0));
end ClockSynthesizer;


architecture SIMULATION of ClockSynthesizer is

   signal CLKFX_OUT_i  : std_logic;
   signal CLKFX_ENABLE : std_logic;
   constant clock_half_period_clkfx_out : time := 10 ns;
   constant clock_half_period_clk2x_out : time := 15625 ps;

begin

  CLKFX_ENABLE <= '0',
                  '1' after 906250 ps;

  LOCKED_OUT <= '0',
                  '1' after 906250 ps;

  STATUS_OUT <= (others => '0');

  CLKIN_IBUFG_OUT <= CLKIN_IN;
  CLK0_OUT        <= CLKIN_IN;
  CLK180_OUT      <= not CLKIN_IN;

  clock_clkfx_out : PROCESS
  begin

    CLKFX_OUT_i <= '0';
    wait for clock_half_period_clkfx_out; 
    CLKFX_OUT_i <= '1';
    wait for clock_half_period_clkfx_out; 
      
  end PROCESS clock_clkfx_out;

  clock_clk2x_out : PROCESS
  begin

    CLK2X_OUT <= '0';
    wait for clock_half_period_clk2x_out; 
    CLK2X_OUT <= '1';
    wait for clock_half_period_clk2x_out; 
      
  end PROCESS clock_clk2x_out;

  process (CLKFX_OUT_i, CLKFX_ENABLE)
  begin  -- process
    if (CLKFX_ENABLE = '1') then
      CLKFX_OUT <= CLKFX_OUT_i;
    else
      CLKFX_OUT <= '0';
    end if;
  end process;

end SIMULATION;


