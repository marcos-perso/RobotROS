
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

-- Other
use work.stringfkt.all;
use work.UtilsPackage.all;

architecture Simulation of DualRAM_8x32 is

-- Read from an ASCII file
constant content_file_in   : string := "/home/mmarttinez/Projects/Perso/Robot/design/test/system/test1/DualRAM_8x32.in";
constant content_file_out  : string := "/home/mmarttinez/Projects/Perso/Robot/design/test/system/test1/DualRAM_8x32.out";


--shared variable ram : ram_type_8x32;
shared variable ram : ram_type_8x32 := init_rom_8x32(content_file_in,content_file_out);

begin

process (clka)
begin
  if (clka'event and clka = '1') then
    
    if (wea(0) = '1') then
      ram(to_integer(unsigned(addra))) := dina;
    end if;

  end if;
  
end process;

process (clkb)
begin
  if (clkb'event and clkb = '1') then
    doutb <= ram(to_integer(unsigned(addrb)));
  end if;
end process;

end Simulation;
