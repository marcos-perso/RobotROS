-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- 
-- Wishbone address comparator
-- 
-- NOTES:
--   * It activates a block
--   * the block boundaries are selected by programmer and hard-coded here
-- 
-- $Author: mmartinez $
-- $Date: 2010-07-10 21:56:03 $
-- $Name:  $
-- $Revision: 1.1 $
-- 
-------------------------------------------------------------------------------


---------------
-- LIBRARIES --
---------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library work;
use work.zpu_config.all;
use work.zpupkg.all;
use work.WishboneConstantsPackage.all;
use work.RegisterMapPackage.all;

-----------------------------
-- ARCHITECTURE DEFINITION --
-----------------------------
 
architecture combinational of wbAddressComparator is


  -- CONSTANTS DEFINITION --

  -- SIGNAL DEFINITION --

  -- DEBUG

  -- ARCHITECTURE --

begin

  -- purpose: Compare addresses and select the correct group of 8 bits
  -- type   : combinational
  -- inputs : ADDR_I
  -- outputs: ACTIVATE_x
  p_compare: process (ADDR_I)
  begin  -- process p_compare

    -- Default condition
    ACTIVATE_0 <= '0';
    ACTIVATE_1 <= '0';
    ACTIVATE_2 <= '0';
    ACTIVATE_3 <= '0';
    ACTIVATE_4 <= '0';
    ACTIVATE_5 <= '0';
    ACTIVATE_6 <= '0';
    ACTIVATE_7 <= '0';

    if (( to_integer(unsigned(ADDR_I)) >= C_MINIUART_BASE_ADDRESS) and
        ( to_integer(unsigned(ADDR_I)) <= C_MINIUART_BASE_ADDRESS + C_MINIUART_MAX_OFFSET )) then

      ACTIVATE_0 <= '1'; 
      
    end if;

    if (( to_integer(unsigned(ADDR_I)) >= C_LEDINTERFACE_BASE_ADDRESS) and
        ( to_integer(unsigned(ADDR_I)) <= C_LEDINTERFACE_BASE_ADDRESS + C_LEDINTERFACE_MAX_OFFSET )) then

      ACTIVATE_1 <= '1'; 
      
    end if;

   if (( to_integer(unsigned(ADDR_I)) >= C_USOCCONTROLLER_BASE_ADDRESS) and
        ( to_integer(unsigned(ADDR_I)) <= C_USOCCONTROLLER_BASE_ADDRESS + C_USOCCONTROLLER_MAX_OFFSET )) then

      ACTIVATE_2 <= '1'; 
      
    end if;

    if (( to_integer(unsigned(ADDR_I)) >= C_FLASHCONTROLLER_BASE_ADDRESS) and
        ( to_integer(unsigned(ADDR_I)) <= C_FLASHCONTROLLER_BASE_ADDRESS + C_FLASHCONTROLLER_MAX_OFFSET )) then

      ACTIVATE_3 <= '1'; 
      
    end if;

    if (( to_integer(unsigned(ADDR_I)) >= C_FLASH_BASE_ADDRESS) and
        ( to_integer(unsigned(ADDR_I)) <= C_FLASH_BASE_ADDRESS + C_FLASH_MAX_OFFSET )) then

      ACTIVATE_4 <= '1'; 
      
    end if;

    if (( to_integer(unsigned(ADDR_I)) >= C_FLASHPROGRAMCACHE_BASE_ADDRESS) and
        ( to_integer(unsigned(ADDR_I)) <= C_FLASHPROGRAMCACHE_BASE_ADDRESS + C_FLASHPROGRAMCACHE_MAX_OFFSET )) then

      ACTIVATE_5 <= '1'; 
      
    end if;

    if (( to_integer(unsigned(ADDR_I)) >= C_MOTORCONTROL_BASE_ADDRESS) and
        ( to_integer(unsigned(ADDR_I)) <= C_MOTORCONTROL_BASE_ADDRESS + C_MOTORCONTROL_MAX_OFFSET )) then

      ACTIVATE_6 <= '1'; 
      
    end if;

    if (( to_integer(unsigned(ADDR_I)) >= C_PWMGENERATOR_BASE_ADDRESS) and
        ( to_integer(unsigned(ADDR_I)) <= C_PWMGENERATOR_BASE_ADDRESS + C_PWMGENERATOR_MAX_OFFSET )) then

      ACTIVATE_7 <= '1'; 
      
    end if;

  end process p_compare;

end combinational;

-------------------------------------------------------------------------------
-- $Log: wbAddressComparator.vhd,v $
-- Revision 1.1  2010-07-10 21:56:03  mmartinez
-- Files imported
--
-- Revision 1.5  2010-07-10 08:21:10  mmartinez
-- Separation between FLASH and DRAM
--
-- Revision 1.4  2010-07-08 14:57:14  mmartinez
-- Addition to WB system of the external single port ram
--
-- Revision 1.3  2010-06-17 22:41:32  mmartinez
-- Basic behaviour completed
--
-- Revision 1.2  2010-06-10 21:10:34  mmartinez
-- *** empty log message ***
--
-- Revision 1.1  2010-06-07 20:58:30  mmartinez
-- Module creation
--
-------------------------------------------------------------------------------

