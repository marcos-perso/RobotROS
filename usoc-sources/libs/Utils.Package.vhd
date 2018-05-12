-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- Utility functions
--
-- NOTES:
--
-- $Author: mmartinez $
-- $Date: 2010-07-10 21:46:21 $
-- $Name:  $
-- $Revision: 1.1 $
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
use work.SoCConstantsPackage.all;

----------------------------------
-- COMPONENT PACKAGE DEFINITION --
----------------------------------

package UtilsPackage is

  -- synopsys translate off
  -- TYPE definition
  type ram_type         is array(natural range 0 to ((2**(maxAddrBitBRAM+1))/4)-1) of std_logic_vector(wordSize-1 downto 0);
  type ram_type_8x32    is array(natural range 0 to 7) of std_logic_vector(31 downto 0);
  type ram_type_256x16  is array(natural range 0 to 255) of std_logic_vector(15 downto 0);
  type ram_type_256x32  is array(natural range 0 to 255) of std_logic_vector(31 downto 0);
  type ram_type_1024x32 is array(natural range 0 to 1023) of std_logic_vector(31 downto 0);
  type ram_type_8196x32 is array(natural range 0 to 8195) of std_logic_vector(31 downto 0);
  type ram_type_4800x16 is array(natural range 0 to (4800-1)) of std_logic_vector(15 downto 0);
  --type ram_type is array(natural range 0 to ((2**(c_NbAddrBitsDRAM+1))/4)-1) of std_logic_vector(wordSize-1 downto 0);

  -- FUNCTION definition
  impure function init_rom(content_file_in : string; content_file_out: string) return ram_type;
  impure function init_rom_256x16(content_file_in : string; content_file_out: string) return ram_type_256x16;
  impure function init_rom_256x32(content_file_in : string; content_file_out: string) return ram_type_256x32;
  impure function init_rom_1024x32(content_file_in : string; content_file_out: string) return ram_type_1024x32;
  impure function init_rom_8196x32(content_file_in : string; content_file_out: string) return ram_type_8196x32;
  impure function init_rom_4800x16(content_file_in : string; content_file_out: string) return ram_type_4800x16;
  impure function init_rom_8x32(content_file_in : string; content_file_out: string) return ram_type_8x32;
  -- synopsys translate on

end UtilsPackage;

-------------------------------------------------------------------------------
-- $Log: Utils.Package.vhd,v $
-- Revision 1.1  2010-07-10 21:46:21  mmartinez
-- Files imported
--
-- Revision 1.3  2010-07-08 15:37:16  mmartinez
-- Internal dual port ram substituted by external single port RAM
--
-- Revision 1.2  2010-07-01 17:27:23  mmartinez
-- Function added
--
-- Revision 1.1  2010-06-20 14:01:49  mmartinez
-- File creation
--
-------------------------------------------------------------------------------
   
