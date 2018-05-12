-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- Utility functions
--
-- NOTES:
--
-- $Author$
-- $Date$
-- $Name$
-- $Revision$
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

-- Other libraries
-- synopsys translate off
use work.stringfkt.all;
-- synopsys translate on

----------------------------------
-- COMPONENT PACKAGE DEFINITION --
----------------------------------

package body FileIOUtilsPackage is

  -- synopsys translate off
  -- read variable length string from input file
     
  procedure ReadString(in_line: inout line; 
                       res_string: out string) is

    variable c : character;
    variable in_string : boolean;

  begin

    for i in res_string'range loop
      res_string(i) := ' ';
    end loop;

    for i in res_string'range loop
      read(in_line, c, in_string);
      res_string(i) := c;
      if (c = ' ') then -- found end of word 
        exit;
      end if;
    end loop;
       
  end ReadString;

  procedure ReadSpace(in_line: inout line) is

    variable c : character;

  begin

    read(in_line, c);
       
  end ReadSpace;

  procedure ReadHex2(in_line: inout line; 
                    value: out integer) is

    variable value_s : string(1 to 2);
    
    begin
      ReadString(in_line,value_s);
--      assert false report value_s severity note;
      value := HexString2integer(value_s);
    end ReadHex2;

  procedure ReadHex1(in_line: inout line; 
                    value: out integer) is

    variable value_s : string(1 to 1);
    
    begin
      ReadString(in_line,value_s);
--      assert false report value_s severity note;
      value := HexString2integer(value_s);
    end ReadHex1;


  procedure ReadHex4(in_line: inout line; 
                    value: out integer) is

    variable value_s : string(1 to 4);
    
    begin
      ReadString(in_line,value_s);
--      assert false report value_s severity note;
      value := HexString2integer(value_s);
    end ReadHex4;

  procedure ReadHex7(in_line: inout line; 
                    value: out integer) is

    variable value_s : string(1 to 7);
    
    begin
      ReadString(in_line,value_s);
--      assert false report value_s severity note;
      value := HexString2integer(value_s);
    end ReadHex7;

  procedure ReadHex8(in_line: inout line; 
                      value: out integer) is

    variable value_s : string(1 to 8);
    
    begin
      ReadString(in_line,value_s);
 --     assert false report value_s severity note;
      value := HexString2integer(value_s);
    end ReadHex8;

  procedure ReadHex8AsString(in_line: inout line; 
                             value: out string(1 to 8)) is

    variable value_s : string(1 to 8);
    
    begin
      ReadString(in_line,value_s);
      value := value_s;
      assert false report value_s severity note;
    --  value := HexString2integer(value_s);
    end ReadHex8AsString;

  procedure ReadHex10(in_line: inout line; 
                    value: out integer) is

    variable value_s : string(1 to 10);
    
    begin
      ReadString(in_line,value_s);
--      assert false report value_s severity note;
      value := HexString2integer(value_s);
    end ReadHex10;

  -- synopsys translate on
  
end FileIOUtilsPackage;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------
   
