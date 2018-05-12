-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- 
-- ZPU Bus
-- 
-- NOTES:
--   * It is not wishbone compliant ==> To be changed
--
-- TBD: Make it wishbone
-- TBD: Change architecture from combinational to RTL
-- 
-- $Author:$
-- $Date:$
-- $Name:$
-- $Revision:$
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
-- synopsys translate off
use work.txt_util.all;
-- synopsys translate on
use work.WishboneConstantsPackage.all;
use work.RegisterMapPackage.all;
   
-----------------------------
-- ARCHITECTURE DEFINITION --
-----------------------------
 
architecture RTL of ZPUBus is


  -- CONSTANTS DEFINITION --

  -- SIGNAL DEFINITION --
  signal STB_O_int : std_logic;         -- Strobe Out (Intermediate signal)
  signal reg_Data  : std_logic_vector(c_WishboneDataWidth - 1 downto 0);  -- Stores data 
  signal in_mem_busy_int_flash : std_logic;
  signal in_mem_busy_int_stack : std_logic;
  signal ram_ready             : std_logic;
  signal rom_ready             : std_logic;
  signal WB_ready              : std_logic;

  signal int_ram_WE : std_logic;
  signal int_rom_WE : std_logic;
  signal int_WB_WE  : std_logic;
  signal int_WB_RE  : std_logic;

  signal s_SelectROM : std_logic;
  signal s_SelectRAM : std_logic;
  signal s_SelectWB  : std_logic;

  signal waiting   : std_logic;           -- Wait for ack from FLASH
  signal WBZPU_busy : std_logic;

  -- DEBUG

  -- ARCHITECTURE --

begin

  p_Waiting: process (clk, reset)
  begin  -- process p_Waiting
    if reset = '1' then 

      waiting <= '0';
      
    elsif clk'event and clk = '1' then  -- rising clock edge

      -- Waiting
      if (ACK_I = '1') then

        -- resetted by incoming ACK
        waiting <= '0';

      elsif (zpu_readEnable = '1' or zpu_writeEnable = '1') and (s_SelectROM = '1') then

        -- Set by a request
        waiting <= '1';

      end if;
      
    end if;
  end process p_Waiting;
  

  -- purpose: Selects one of the memories
  -- type   : combinational
  -- inputs : zpu_mem_addr
  -- outputs: s_SelectRAM, s_SelectROM
  p_Selection: process (zpu_mem_addr)
  begin  -- process p_Selection

      s_SelectRAM <= '0';
      s_SelectROM <= '0';
      s_SelectWB <= '0';

    if (( to_integer(unsigned(zpu_mem_addr(maxAddrBitIncIO downto 0))) >= C_INSTRBUS_WB_MIN_ADDRESS) and
        ( to_integer(unsigned(zpu_mem_addr(maxAddrBitIncIO downto 0))) <= C_INSTRBUS_WB_MIN_ADDRESS + C_INSTRBUS_WB_SIZE - 1 )) then

      s_SelectWB <= '1';

    end if;

    if (( to_integer(unsigned(zpu_mem_addr(maxAddrBitIncIO downto 2))) >= C_INSTRBUS_PROGRAM_MIN_ADDRESS) and
        ( to_integer(unsigned(zpu_mem_addr(maxAddrBitIncIO downto 2))) <= C_INSTRBUS_PROGRAM_MIN_ADDRESS + C_INSTRBUS_PROGRAM_SIZE - 1 )) then

      s_SelectROM <= '1';

    end if;

    if (( to_integer(unsigned(zpu_mem_addr(maxAddrBitIncIO downto 2))) >= C_INSTRBUS_STACK_MIN_ADDRESS) and
        ( to_integer(unsigned(zpu_mem_addr(maxAddrBitIncIO downto 2))) <= C_INSTRBUS_STACK_MIN_ADDRESS + C_INSTRBUS_PROGRAM_SIZE - 1 )) then

      s_SelectRAM <= '1';

    end if;
    
  end process p_Selection;
    

  p_ZPUBus: process (s_SelectWB,s_SelectROM, s_SelectRAM , zpu_writeEnable, zpu_readEnable, ram_busy, WB_busy, WBZPU_busy,zpu_mem_addr)
  begin  -- process p_ZPUBus

    ADDR_O <= (others => '0');
    int_rom_WE          <= s_SelectROM and zpu_writeEnable;
    int_ram_WE          <= s_SelectRAM and zpu_writeEnable;
    int_WB_WE           <= s_SelectWB  and zpu_writeEnable;
    int_WB_RE           <= s_SelectWB  and zpu_readEnable;
 --   rom_address         <= zpu_mem_addr(14 downto 2);
    ADDR_O(12 downto 0) <= zpu_mem_addr(14 downto 2);
    ram_address         <= zpu_mem_addr(11 downto 2);
    WB_address          <= zpu_mem_addr(maxAddrBitIncIO downto 0);
    zpu_mem_busy        <= ram_busy or WB_busy or WBZPU_busy;
  end process p_ZPUBus;

  -- Memory reads either come from RAM, WOM or WB. We need to pick the right one.
  memorycontrol: process(ram_DataRead, s_SelectRAM,
                         DAT_I, s_SelectROM,
                         WB_DataRead, s_SelectWB
                         )

  begin

    zpu_mem_read <= (others => '0');

    if s_SelectROM='1' then
--      zpu_mem_read <= rom_DataRead;
      zpu_mem_read <= DAT_I;
    elsif s_SelectRAM='1' then
      zpu_mem_read <= ram_DataRead;
    elsif s_SelectWB='1' then
      zpu_mem_read <= WB_DataRead;
    end if;
             
  end process;

  memoryControlSync: process(clk, reset)
  begin
    if reset = '1' then
      ram_ready <= '0';
      rom_ready <= '0';
      WB_ready  <= '0';
    elsif rising_edge(clk) then
      ram_ready <= int_ram_WE;
      rom_ready <= int_rom_WE;
      WB_ready  <= int_WB_WE;
    end if;
  end process;

  WBZPU_busy <= zpu_ReadEnable or waiting;
--  rom_WE <= int_rom_WE;
  STB_O  <= s_SelectROM and (zpu_ReadEnable or zpu_WriteEnable);                 -- This means that we cannot write
  WE_O   <= int_rom_WE;
  ram_WE <= int_ram_WE;
  WB_WE  <= int_WB_WE;
  WB_RE  <= int_WB_RE;

  ram_DataWrite <= zpu_mem_write;
  WB_DataWrite  <= zpu_mem_write;
  DAT_O <= zpu_mem_write;

  -- ------------- --
  -- ZPU INTERFACE --
  -- ------------- --

end rtl;

-------------------------------------------------------------------------------
-- $Log:$
-------------------------------------------------------------------------------

