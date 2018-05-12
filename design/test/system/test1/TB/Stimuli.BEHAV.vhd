-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- Creates stimuli for the simulation
-- 
-- NOTES:
-- 
-- $Author: mmartinez $
-- $Date: 2010-07-01 16:59:25 $
-- $Name:  $
-- $Revision: 1.2 $
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
use std.textio.all;
   
-----------------------------
-- ARCHITECTURE DEFINITION --
-----------------------------
 
architecture BEHAV of Stimuli is


  -- CONSTANTS DEFINITION --
  constant c_CommandSymbol  : integer := 1000;
  constant c_Address1Symbol : integer := 3000;
  constant c_Address2Symbol : integer := 6000;
  constant c_Address3Symbol : integer := 9000;
  constant c_Address4Symbol : integer := 12000;
  constant c_Data1Symbol    : integer := 15000;
  constant c_Data2Symbol    : integer := 18000;
  constant c_Data3Symbol    : integer := 21000;
  constant c_Data4Symbol    : integer := 24000;

  -- SIGNAL DEFINITION --
  signal counter : unsigned(63 downto 0);  

  -- DEBUG

  -- ARCHITECTURE --

begin

  p_ButtonCaption1 <= '0',              -- +
                      '0' after 4  us,
                      '0' after 5  us,
                      '0' after 104 us,
                      '0' after 105 us,
                      '0' after 204 us,
                      '0' after 205 us,
                      '0' after 304 us,
                      '0' after 305 us,
                      '0' after 404 us,
                      '0' after 405 us,
                      '0' after 504 us,
                      '0' after 505 us,
                      '1' after 604 us,
                      '0' after 605 us;

  p_ButtonCaption2 <= '0',              -- -
                      '0' after 4  us,
                      '0' after 5  us,
                      '0' after 104 us,
                      '0' after 105 us,
                      '1' after 204 us,
                      '0' after 205 us,
                      '0' after 304 us,
                      '0' after 305 us,
                      '1' after 404 us,
                      '0' after 405 us,
                      '0' after 504 us,
                      '0' after 505 us,
                      '0' after 604 us,
                      '0' after 605 us;

  p_ButtonCaption3 <= '0',
                      '1' after 44  us,
                      '0' after 45  us,
                      '0' after 49 us;

--  process(clk, reset)
--  begin
--    if reset = '1' then
--      counter <= to_unsigned(0, 64);

--    elsif (clk'event and clk = '1') then

--      -- Default values
--      WB_ADR_O <= (others => '0');
--      WB_DAT_O <= (others => '0');
--      WB_RST_O <= '0';
--      WB_WE_O  <= '0';
--      WB_STB_O <= '0';
      
--      -- Increment counter
--      counter <= counter + 1;

--      -- If we are in the correct value of the counter, send a byte through the
--      -- UART
--      if (counter = to_unsigned(c_CommandSymbol,64)) then
--        report "Sending READ COMMAND through the UART" severity note;
--        WB_ADR_O <= "00";
--        WB_DAT_O <= "00000010";
--        WB_WE_O  <= '1';
--        WB_STB_O <= '1';
--      end if;

--      if (counter = to_unsigned(c_CommandSymbol+2,64)) then
--        WB_STB_O <= '0';
--        WB_WE_O  <= '0';
--        WB_ADR_O <= "00";
--        WB_DAT_O <= "00000000";
--      end if;

--      -- If we are in the correct value of the counter, send a byte through the
--      -- UART
--      if (counter = to_unsigned(c_Address1Symbol,64)) then
--        report "Sending LED REGISTER address (1) indication the UART" severity note;
--        WB_ADR_O <= "00";
--        WB_DAT_O <= "00000100";         -- WRITE to LED register
--        WB_WE_O  <= '1';
--        WB_STB_O <= '1';
--      end if;

--      if (counter = to_unsigned(c_Address1Symbol+2,64)) then
--        WB_STB_O <= '0';
--        WB_WE_O  <= '0';
--        WB_ADR_O <= "00";
--        WB_DAT_O <= "00000000";
--      end if;

--      -- If we are in the correct value of the counter, send a byte through the
--      -- UART
--      if (counter = to_unsigned(c_Address2Symbol,64)) then
--        report "Sending LED REGISTER address (2) indication the UART" severity note;
--        WB_ADR_O <= "00";
--        WB_DAT_O <= "00000000";         -- WRITE to LED register
--        WB_WE_O  <= '1';
--        WB_STB_O <= '1';
--      end if;

--      if (counter = to_unsigned(c_Address2Symbol+2,64)) then
--        WB_STB_O <= '0';
--        WB_WE_O  <= '0';
--        WB_ADR_O <= "00";
--        WB_DAT_O <= "00000000";
--      end if;

--      -- If we are in the correct value of the counter, send a byte through the
--      -- UART
--      if (counter = to_unsigned(c_Address3Symbol,64)) then
--        report "Sending LED REGISTER address (3) indication the UART" severity note;
--        WB_ADR_O <= "00";
--        WB_DAT_O <= "00000000";         -- WRITE to LED register
--        WB_WE_O  <= '1';
--        WB_STB_O <= '1';
--      end if;

--      if (counter = to_unsigned(c_Address3Symbol+2,64)) then
--        WB_STB_O <= '0';
--        WB_WE_O  <= '0';
--        WB_ADR_O <= "00";
--        WB_DAT_O <= "00000000";
--      end if;

--      -- If we are in the correct value of the counter, send a byte through the
--      -- UART
--      if (counter = to_unsigned(c_Address4Symbol,64)) then
--        report "Sending LED REGISTER address (4) indication the UART" severity note;
--        WB_ADR_O <= "00";
--        WB_DAT_O <= "00010000";         -- WRITE to LED register
--        WB_WE_O  <= '1';
--        WB_STB_O <= '1';
--      end if;

--      if (counter = to_unsigned(c_Address4Symbol+2,64)) then
--        WB_STB_O <= '0';
--        WB_WE_O  <= '0';
--        WB_ADR_O <= "00";
--        WB_DAT_O <= "00000000";
--      end if;

----      -- If we are in the correct value of the counter, send a byte through the
----      -- UART
----      if (counter = to_unsigned(c_Data1Symbol,64)) then
----        report "Sending LED REGISTER DATA (1) indication the UART" severity note;
----        WB_ADR_O <= "00";
----        WB_DAT_O <= "00000000";         -- WRITE to LED register
----        WB_WE_O  <= '1';
----        WB_STB_O <= '1';
----      end if;

----      if (counter = to_unsigned(c_Data1Symbol+2,64)) then
----        WB_STB_O <= '0';
----        WB_WE_O  <= '0';
----        WB_ADR_O <= "00";
----        WB_DAT_O <= "00000000";
----      end if;

----      -- If we are in the correct value of the counter, send a byte through the
----      -- UART
----      if (counter = to_unsigned(c_Data2Symbol,64)) then
----        report "Sending LED REGISTER DATA (2) indication the UART" severity note;
----        WB_ADR_O <= "00";
----        WB_DAT_O <= "00000000";         -- WRITE to LED register
----        WB_WE_O  <= '1';
----        WB_STB_O <= '1';
----      end if;

----      if (counter = to_unsigned(c_Data2Symbol+2,64)) then
----        WB_STB_O <= '0';
----        WB_WE_O  <= '0';
----        WB_ADR_O <= "00";
----        WB_DAT_O <= "00000000";
----      end if;

----      -- If we are in the correct value of the counter, send a byte through the
----      -- UART
----      if (counter = to_unsigned(c_Data3Symbol,64)) then
----        report "Sending LED REGISTER DATA (3) indication the UART" severity note;
----        WB_ADR_O <= "00";
----        WB_DAT_O <= "00000000";         -- WRITE to LED register
----        WB_WE_O  <= '1';
----        WB_STB_O <= '1';
----      end if;

----      if (counter = to_unsigned(c_Data3Symbol+2,64)) then
----        WB_STB_O <= '0';
----        WB_WE_O  <= '0';
----        WB_ADR_O <= "00";
----        WB_DAT_O <= "00000000";
----      end if;

----      -- If we are in the correct value of the counter, send a byte through the
----      -- UART
----      if (counter = to_unsigned(c_Data4Symbol,64)) then
----        report "Sending LED REGISTER DATA (4) indication the UART" severity note;
----        WB_ADR_O <= "00";
----        WB_DAT_O <= "00000101";         -- WRITE to LED register
----        WB_WE_O  <= '1';
----        WB_STB_O <= '1';
----      end if;

----      if (counter = to_unsigned(c_Data4Symbol+2,64)) then
----        WB_STB_O <= '0';
----        WB_WE_O  <= '0';
----        WB_ADR_O <= "00";
----        WB_DAT_O <= "00000000";
----      end if;

--    end if;     

--  end process;


end BEHAV;

-------------------------------------------------------------------------------
-- $Log: Stimuli.BEHAV.vhd,v $
-- Revision 1.2  2010-07-01 16:59:25  mmartinez
-- File changes
--
-- Revision 1.1  2010-06-13 19:07:15  mmartinez
-- File creation
--
-------------------------------------------------------------------------------

