-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- 
-- Wishbone master wrapper
-- 
-- NOTES:
--   * TGD to be defined
--   * TGA to be defined
--   * TGC to be defined
--   * writeMask is not implemented
--   * We assume that in the system there is only one master
--   * We assume 32 bit granularity. No selection is needed
--
-- TBD:
--    -> Change the name of the architecture RTL -> Combinational
-- 
-- $Author: mmartinez $
-- $Date: 2010-07-10 21:48:16 $
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
-- synopsys translate off
use work.txt_util.all;
-- synopsys translate on
use work.WishboneConstantsPackage.all;
   
-----------------------------
-- ARCHITECTURE DEFINITION --
-----------------------------
 
architecture RTL of wbMaster is


  -- CONSTANTS DEFINITION --

  -- SIGNAL DEFINITION --
  signal STB_O_int : std_logic;         -- Strobe Out (Intermediate signal)
  signal waiting   : std_logic;           -- Wait for ack
  signal reg_Data  : std_logic_vector(c_WishboneDataWidth - 1 downto 0);  -- Stores data 
  signal in_mem_busy_int : std_logic;

  -- DEBUG

  -- ARCHITECTURE --

begin

  -- --------------- --
  -- TEMP CONTROL --
  -- --------------- --
  p_Waiting: process (CLK_I, RST_I)
  begin  -- process p_Waiting
    if RST_I = '1' then 

      waiting <= '0';
      reg_Data <= (others => '0');
      
    elsif CLK_I'event and CLK_I = '1' then  -- rising clock edge

      -- Data
      if (in_mem_busy_int = '1') then
        reg_Data <= DAT_I;
      end if;
      
      -- Waiting
      if (ACK_I = '1') then

        -- resetted by incoming ACK
        waiting <= '0';

      elsif (ZPU_readEnable = '1' or ZPU_writeEnable = '1') then

        -- Set by a request
        waiting <= '1';

      end if;
      
    end if;
  end process p_Waiting;

  -- ------------------ --
  -- WISHBONE INTERFACE --
  -- ------------------ --

  -- Connect tha DATA lines: Directly connected to DATA lines of the wishbone
  DAT_O <= ZPU_write;

  -- Connect the ADDRESS lines: Directly connected to ADDRESS lines of the wishbone
  -- We divide by 4
  ADDR_O <= "00" & ZPU_addr(maxAddrBitIncIO downto 2);

  -- A cycle is asserted when either writeEnable or readEnable are asserted
  CYC_O <= ZPU_writeEnable or ZPU_readEnable or waiting;

  -- Wishbone bus is always LOCKED when there is a transaction from ZPU
  LOCK_O <= ZPU_writeEnable or ZPU_readEnable;

  -- We use 32 bit granularity... so no selection of data is done
  SEL_O <= (others => '1');

  -- Strobe is asserted when either there is a read or write
  STB_O <= ZPU_writeEnable or ZPU_readEnable;


  -- Write Enable is taken from ZPU enable signals
  p_WE: process (ZPU_writeEnable, ZPU_readEnable)
  begin 
    if ZPU_writeEnable = '1' then
      WE_O <= '1';                         -- WRITE CYCLE
    elsif ZPU_readEnable = '1' then
      WE_O <= '0';                         -- READ CYCLE
    else
      WE_O <= '0';                         -- Default
    end if;
  end process p_WE;
    

  -- These signals are dummy
  TGD_O <= (others => '0');
  TGA_O <= (others => '0');
  TGC_O <= (others => '0');


  -- ------------- --
  -- ZPU INTERFACE --
  -- ------------- --

  p_Outs: process (ZPU_readEnable, ACK_I, waiting)
  begin  -- process p_Outs

    in_mem_busy_int <= '0';
    
    if (ZPU_readEnable = '1') or (waiting='1')
    then
      in_mem_busy_int <= '1';
      
    else
      in_mem_busy_int <= '0';
    end if;

  
  end process p_Outs;

  ZPU_busy <= ZPU_readEnable or waiting;
  ZPU_read <= reg_Data;

end rtl;

-------------------------------------------------------------------------------
-- $Log: wbMaster.vhd,v $
-- Revision 1.1  2010-07-10 21:48:16  mmartinez
-- Files imported
--
-- Revision 1.5  2010-07-10 14:16:23  mmartinez
-- Memory reads can take now several cycles in order to use 16-bit wide flash
--
-- Revision 1.4  2010-07-08 14:59:31  mmartinez
-- * Corrected bug: Reset was always active
-- * Changes in the mem_busy port to include external single port RAM in WB system
--
-- Revision 1.3  2010-06-17 22:41:36  mmartinez
-- Basic behaviour completed
--
-- Revision 1.2  2010-06-10 21:10:43  mmartinez
-- *** empty log message ***
--
-- Revision 1.1  2010-06-06 20:23:22  mmartinez
-- File creation
--
-------------------------------------------------------------------------------

