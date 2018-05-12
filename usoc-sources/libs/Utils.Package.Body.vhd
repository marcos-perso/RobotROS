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

-- Standard pàckages
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

-- SoC constants
use work.zpu_config.all;
use work.zpupkg.all;
use work.SoCConstantsPackage.all;

-- Other libraries
-- synopsys translate off
use work.stringfkt.all;
-- synopsys translate on

----------------------------------
-- COMPONENT PACKAGE DEFINITION --
----------------------------------

package body UtilsPackage is

  -- synopsys translate off

  impure function init_rom(content_file_in : string; content_file_out: string) return ram_type is
  
    variable l : line;
    variable l1 : line;
    variable s : string(1 to 8);
    variable value_read : std_logic_vector(31 downto 0);
    variable ram_content : ram_type;
    variable i : natural;               -- Loop variable

    file content_in  : TEXT open read_mode  is content_file_in;
    file content_out : TEXT open write_mode is content_file_out;

  

  begin

    -- Reset iterator variable
    i:=0;
    ram_content := (others => x"00000000");
    
    report "Start reading memory contents from " & content_file_in severity note;

    -- Loop through the file getting its contents
    while not endfile(content_in) loop

      -- read digital data from input file 
      readline(content_in, l);
      read(l, s);

      -- Convert to a hexadecimal value
      value_read := HexString2slv(s);

      -- Store the content in the ram
      ram_content(i) := value_read;

      -- Go to the next position in the memory
      i := i +1;

    end loop;

    report "Reading done..." severity note;

    for j in 0 to i loop
      -- Only for debug. Write back memory contents in a file
--      write(l1, slv2hexS(ram_content(j)));
--      writeline(content_out, l1);
    end loop;  -- j

    return ram_content;

  end function;

  impure function init_rom_256x16(content_file_in : string; content_file_out: string) return ram_type_256x16 is
  
    variable l : line;
    variable l1 : line;
    variable s : string(1 to 4);
    variable value_read : std_logic_vector(15 downto 0);
    variable ram_content : ram_type_256x16;
    variable i : natural;               -- Loop variable

    file content_in  : TEXT open read_mode  is content_file_in;
    file content_out : TEXT open write_mode is content_file_out;

  

  begin

    -- Reset iterator variable
    i:=0;
    ram_content := (others => x"0000");
    
    report "Start reading memory contents from " & content_file_in severity note;

    -- Loop through the file getting its contents
    while not endfile(content_in) loop

      -- read digital data from input file 
      readline(content_in, l);
      read(l, s);

      -- Convert to a hexadecimal value
      value_read := HexString2slv(s);

      -- Store the content in the ram
      ram_content(i) := value_read;

      -- Go to the next position in the memory
      i := i +1;

    end loop;

    report "Reading done..." severity note;

    for j in 0 to i loop
      -- Only for debug. Write back memory contents in a file
--      write(l1, slv2hexS(ram_content(j)));
--      writeline(content_out, l1);
    end loop;  -- j

    return ram_content;

  end function;

  impure function init_rom_256x32(content_file_in : string; content_file_out: string) return ram_type_256x32 is
  
    variable l : line;
    variable l1 : line;
    variable s : string(1 to 8);
    variable value_read : std_logic_vector(31 downto 0);
    variable ram_content : ram_type_256x32;
    variable i : natural;               -- Loop variable

    file content_in  : TEXT open read_mode  is content_file_in;
    file content_out : TEXT open write_mode is content_file_out;

  

  begin

    -- Reset iterator variable
    i:=0;
    ram_content := (others => x"00000000");
    
    report "Start reading memory contents from " & content_file_in severity note;

    -- Loop through the file getting its contents
    while not endfile(content_in) loop

      -- read digital data from input file 
      readline(content_in, l);
      read(l, s);

      -- Convert to a hexadecimal value
      value_read := HexString2slv(s);

      -- Store the content in the ram
      ram_content(i) := value_read;

      -- Go to the next position in the memory
      i := i +1;

    end loop;

    report "Reading done..." severity note;

    for j in 0 to i loop
      -- Only for debug. Write back memory contents in a file
--      write(l1, slv2hexS(ram_content(j)));
--      writeline(content_out, l1);
    end loop;  -- j

    return ram_content;

  end function;

  impure function init_rom_1024x32(content_file_in : string; content_file_out: string) return ram_type_1024x32 is
  
    variable l : line;
    variable l1 : line;
    variable s : string(1 to 8);
    variable value_read : std_logic_vector(31 downto 0);
    variable ram_content : ram_type_1024x32;
    variable i : natural;               -- Loop variable

    file content_in  : TEXT open read_mode  is content_file_in;
    file content_out : TEXT open write_mode is content_file_out;

  

  begin

    -- Reset iterator variable
    i:=0;
    ram_content := (others => x"00000000");
    
    report "Start reading memory contents from " & content_file_in severity note;

    -- Loop through the file getting its contents
    while not endfile(content_in) loop

      -- read digital data from input file 
      readline(content_in, l);
      read(l, s);

      -- Convert to a hexadecimal value
      value_read := HexString2slv(s);

      -- Store the content in the ram
      ram_content(i) := value_read;

      -- Go to the next position in the memory
      i := i +1;

    end loop;

    report "Reading done..." severity note;

    for j in 0 to i loop
      -- Only for debug. Write back memory contents in a file
      write(l1, slv2hexS(ram_content(j)));
      writeline(content_out, l1);
    end loop;  -- j

    return ram_content;

  end function;

  impure function init_rom_8196x32(content_file_in : string; content_file_out: string) return ram_type_8196x32 is
  
    variable l : line;
    variable l1 : line;
    variable s : string(1 to 8);
    variable value_read : std_logic_vector(31 downto 0);
    variable ram_content : ram_type_8196x32;
    variable i : natural;               -- Loop variable

    file content_in  : TEXT open read_mode  is content_file_in;
    file content_out : TEXT open write_mode is content_file_out;

  

  begin

    -- Reset iterator variable
    i:=0;
    ram_content := (others => x"00000000");
    
    report "Start reading memory contents from " & content_file_in severity note;

    -- Loop through the file getting its contents
    while not endfile(content_in) loop

      -- read digital data from input file 
      readline(content_in, l);
      read(l, s);

      -- Convert to a hexadecimal value
      value_read := HexString2slv(s);

      -- Store the content in the ram
      ram_content(i) := value_read;

      -- Go to the next position in the memory
      i := i +1;

    end loop;

    report "Reading done..." severity note;

    for j in 0 to i loop
      -- Only for debug. Write back memory contents in a file
      write(l1, slv2hexS(ram_content(j)));
      writeline(content_out, l1);
    end loop;  -- j

    return ram_content;

  end function;

  impure function init_rom_4800x16(content_file_in : string; content_file_out: string) return ram_type_4800x16 is
  
    variable l : line;
    variable l1 : line;
    variable s : string(1 to 4);
    variable value_read : std_logic_vector(15 downto 0);
    variable ram_content : ram_type_4800x16;
    variable i : natural;               -- Loop variable

    file content_in  : TEXT open read_mode  is content_file_in;
    file content_out : TEXT open write_mode is content_file_out;

  

  begin

    -- Reset iterator variable
    i:=0;
    ram_content := (others => x"0000");
    
    report "Start reading memory contents from " & content_file_in severity note;

    -- Loop through the file getting its contents
    while not endfile(content_in) loop

      -- read digital data from input file 
      readline(content_in, l);
      read(l, s);

      -- Convert to a hexadecimal value
      value_read := HexString2slv(s);

      -- Store the content in the ram
      ram_content(i) := value_read;

      -- Go to the next position in the memory
      i := i +1;

    end loop;

    report "Reading done..." severity note;

    for j in 0 to i loop
      -- Only for debug. Write back memory contents in a file
--      write(l1, slv2hexS(ram_content(j)));
--      writeline(content_out, l1);
    end loop;  -- j

    return ram_content;

  end function;

  impure function init_rom_8x32(content_file_in : string; content_file_out: string) return ram_type_8x32 is
  
    variable l : line;
    variable l1 : line;
    variable s : string(1 to 8);
    variable value_read : std_logic_vector(31 downto 0);
    variable ram_content : ram_type_8x32;
    variable i : natural;               -- Loop variable

    file content_in  : TEXT open read_mode  is content_file_in;
    file content_out : TEXT open write_mode is content_file_out;

  

  begin

    -- Reset iterator variable
    i:=0;
    ram_content := (others => x"00000000");
    
    report "Start reading memory contents from " & content_file_in severity note;

    -- Loop through the file getting its contents
    while not endfile(content_in) loop

      -- read digital data from input file 
      readline(content_in, l);
      read(l, s);

      -- Convert to a hexadecimal value
      value_read := HexString2slv(s);

      -- Store the content in the ram
      ram_content(i) := value_read;

      -- Go to the next position in the memory
      i := i +1;

    end loop;

    report "Reading done..." severity note;

    for j in 0 to i-1 loop
      -- Only for debug. Write back memory contents in a file
--      write(l1, slv2hexS(ram_content(j)));
--      writeline(content_out, l1);
    end loop;  -- j

    return ram_content;

  end function;
  -- synopsys translate on

end UtilsPackage;

-------------------------------------------------------------------------------
-- $Log: Utils.Package.Body.vhd,v $
-- Revision 1.1  2010-07-10 21:46:21  mmartinez
-- Files imported
--
-- Revision 1.2  2010-07-01 17:27:23  mmartinez
-- Function added
--
-- Revision 1.1  2010-06-20 14:01:49  mmartinez
-- File creation
--
-------------------------------------------------------------------------------
   
