-------------------------------------------------------------------------------
-- DESCRIPTION: 
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

----------------------------------
-- COMPONENT PACKAGE DEFINITION --
----------------------------------

package wbMemoryWrapperMuxesComponentPackage is

--------------------------
-- COMPONENT DEFINITION --
--------------------------

  component wbMemoryWrapperMuxes is

    generic (
      c_NbAddressBits : integer;
      c_NbDataBits    : integer );

    port(

      i_Control          : in std_logic;
      i_InDirectAddress  : in std_logic_vector(c_NbAddressBits -1 downto 0);
      i_InDirectData     : in std_logic_vector(c_NbDataBits -1 downto 0);
      i_InDirectWE       : in std_logic_vector(0 downto 0);
      i_WBAddress        : in std_logic_vector(c_NbAddressBits -1 downto 0);
      i_WBData           : in std_logic_vector(c_NbDataBits -1 downto 0);
      i_WBWE             : in std_logic_vector(0 downto 0);
      o_InAddress        : out std_logic_vector(c_NbAddressBits -1 downto 0);
      o_InData           : out std_logic_vector(c_NbDataBits -1 downto 0);
      o_InWE             : out std_logic_vector(0 downto 0);
      i_OutDirectAddress : in std_logic_vector(c_NbAddressBits -1 downto 0);
      i_OutWBAddress     : in std_logic_vector(c_NbAddressBits -1 downto 0);
      o_OutAddress       : out std_logic_vector(c_NbAddressBits -1 downto 0)

    );      
  end component;

end wbMemoryWrapperMuxesComponentPackage;
   
-------------------------------------------------------------------------------
-- $Log: wbMemoryWrapperMuxesComponentPackage.vhd,v $
-- Revision 1.1  2010-07-10 21:55:14  mmartinez
-- Files imported
--
-- Revision 1.4  2010-07-10 08:20:59  mmartinez
-- Separation between FLASH and DRAM
--
-- Revision 1.3  2010-07-08 14:58:11  mmartinez
-- Addition of the single port external RAM to the WB system
--
-- Revision 1.2  2010-06-17 22:41:34  mmartinez
-- Basic behaviour completed
--
-- Revision 1.1  2010-06-11 20:42:59  mmartinez
-- File creation
--
-------------------------------------------------------------------------------
