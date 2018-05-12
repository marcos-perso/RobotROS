-- ZPU

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.UtilsPackage.all;

architecture Simulation of RAM1024x32 is


constant content_file_in  : string := "/home/mmarttinez/Projects/Perso/Robot/design/test/system/test1/RAM1024x32.in";
constant content_file_out : string := "/home/mmarttinez/Projects/Perso/Robot/design/test/system/test1/RAM1024x32.out";

shared variable ram : ram_type_1024x32 := init_rom_1024x32(content_file_in,content_file_out);

begin

process (clka)
begin
	if (clka'event and clka = '1') then
          
          if (wea(0) = '1') then
            ram(to_integer(unsigned(addra))) := dina;
            douta <= dina;
          else
            douta <= ram(to_integer(unsigned(addra)));
          end if;
	end if;
end process;

end Simulation;
