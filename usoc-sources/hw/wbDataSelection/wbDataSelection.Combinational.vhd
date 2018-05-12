-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- 
-- Wishbone data selection block
-- 
-- NOTES:
-- 
-- $Author: mmartinez $
-- $Date: 2010-07-10 21:55:14 $
-- $Name:  $
-- $Revision: 1.1 $
-- 
-------------------------------------------------------------------------------


---------------
-- LIBRARIES --
---------------


-- IEEE libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Project libraries
library work;
use work.zpu_config.all;
use work.zpupkg.all;
use work.WishboneConstantsPackage.all;


-----------------------------
-- ARCHITECTURE DEFINITION --
-----------------------------
 
architecture combinational of wbDataSelection is


  -- CONSTANTS DEFINITION --

  -- SIGNAL DEFINITION --

  -- DEBUG

  -- ARCHITECTURE --

begin

  -- purpose: Select the data to be sent to the master
  -- type   : combinational
  -- inputs : DATA_SLAVE_X, ACTIVATE_X
  -- outputs: Data to the master
  p_DataSelection: process (
    DATA_SLAVE_7, ACTIVATE_7,
    DATA_SLAVE_6, ACTIVATE_6,
    DATA_SLAVE_5, ACTIVATE_5,
    DATA_SLAVE_4, ACTIVATE_4,
    DATA_SLAVE_3, ACTIVATE_3,
    DATA_SLAVE_2, ACTIVATE_2,
    DATA_SLAVE_1, ACTIVATE_1,
    DATA_SLAVE_0, ACTIVATE_0
                            )
  begin  -- process p_DataSelection

    -- TBD: Replace this by a multiplexer (case statement)

    DATA_MASTER <= (others => '0');     -- To avoid latch

    if (ACTIVATE_0 = '1') then
      DATA_MASTER <= DATA_SLAVE_0;
    elsif ACTIVATE_1 = '1' then
      DATA_MASTER <= DATA_SLAVE_1;
    elsif ACTIVATE_2 = '1' then
      DATA_MASTER <= DATA_SLAVE_2;
    elsif ACTIVATE_3 = '1' then
      DATA_MASTER <= DATA_SLAVE_3;
    elsif ACTIVATE_4 = '1' then
      DATA_MASTER <= DATA_SLAVE_4;
    elsif ACTIVATE_5 = '1' then
      DATA_MASTER <= DATA_SLAVE_5;
    elsif ACTIVATE_6 = '1' then
      DATA_MASTER <= DATA_SLAVE_6;
    elsif ACTIVATE_7 = '1' then
      DATA_MASTER <= DATA_SLAVE_7;
    end if;

  end process p_DataSelection;

end combinational;

-------------------------------------------------------------------------------
-- $Log: wbDataSelection.vhd,v $
-- Revision 1.1  2010-07-10 21:55:14  mmartinez
-- Files imported
--
-- Revision 1.4  2010-07-10 08:20:40  mmartinez
-- Separation between FLASH and DRAM
--
-- Revision 1.3  2010-07-08 14:58:10  mmartinez
-- Addition of the single port external RAM to the WB system
--
-- Revision 1.2  2010-06-17 22:41:34  mmartinez
-- Basic behaviour completed
--
-- Revision 1.1  2010-06-11 20:42:59  mmartinez
-- File creation
--
-------------------------------------------------------------------------------

