-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- 
-- Control block for the wrapper around a memory allowing direct and access
-- through WB
-- Wishbone subsystem
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
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.zpu_config.all;
use work.zpupkg.all;
use work.RegisterMapPackage.all;
-- synopsys translate off
use work.txt_util.all;
-- synopsys translate on
use std.textio.all;

-- synopsys translate_off
use work.stringfkt.all;
-- synopsys translate_on
   
-----------------------------
-- ARCHITECTURE DEFINITION --
-----------------------------
 
architecture RTL of wbMemoryWrapperControl is


  -- CONSTANTS DEFINITION --

  -- SIGNAL DEFINITION --
  signal reg_ACK : std_logic;
  signal reg_ACK1 : std_logic;
  signal reg_Control : std_logic_vector(c_WishboneDataWidth-1 downto 0);

  -- DEBUG

  -- ARCHITECTURE --

begin

  -- purpose: Adapt to the real memory
  -- type   : sequential
  p_register: process (CLK_I, RST_I)
  begin  -- process p_register

    if RST_I = '1' then                 -- asynchronous reset (active high)

      reg_ACK <= '0';
      reg_ACK1 <= '0';
      reg_Control <= (others => '0');
      
    elsif CLK_I'event and CLK_I = '1' then  -- rising clock edge

      reg_ACK1 <= reg_ACK;

      if ((STB_I='1') and (reg_ACK='0')) then
        reg_ACK <= '1';
      else
        reg_ACK <= '0';
      end if;

      if (STB_I = '1') then

        -- synopsys translate off
--        assert false report "Memory addressed: ADDR_I: " & slv2hexS(std_logic_vector'(ADDR_I)) & " DAT_I = " & slv2hexS(std_logic_vector'(DAT_I(7 downto 0))) severity note;
        -- synopsys translate on

        -- If Strobe in is activated, treat the data
        if (to_integer(unsigned(ADDR_I)) <= (g_base_address + g_offset)) then

          if WE_I = '1' then
              
            -- WRITE
            if (to_integer(unsigned(ADDR_I)) = (g_base_address + 2**c_NbAddressBits)) then
              -- synopsys translate off
              assert false report "CONTROL Register addressed (W)" severity note;
              -- synopsys translate on
              reg_Control <= DAT_I;
            end if;                     -- ok

            if (to_integer(unsigned(ADDR_I)) < (g_base_address + 2**c_NbAddressBits)) then

              -- synopsys translate off
              assert false report "MEMORY addressed. (W)" severity note;
              -- synopsys translate on

            end if;                     -- ok

          else

            -- READ

            DAT_O <= (others => '0');
            if (to_integer(unsigned(ADDR_I)) = (g_base_address + 2**c_NbAddressBits)) then
              DAT_O <= reg_Control;
              -- synopsys translate off
              assert false report "CONTROL Register addressed (R)" severity note;
              -- synopsys translate on
            end if; -- ok

            if (to_integer(unsigned(ADDR_I)) < (g_base_address + 2**c_NbAddressBits)) then

              DAT_O <= i_Data;
              -- synopsys translate off
              assert false report "MEMORY addressed. (TBD)" & slv2hexS(std_logic_vector'(i_Data)) severity note;
              -- synopsys translate on

            end if;
            
          end if;


        end if;
      
      end if; 

    end if;

  end process p_register;

  process (ADDR_I,STB_I,WE_I)
  begin  -- process

    -- default values
    o_WE <= (others => '0');

    if (STB_I = '1') then

      -- synopsys translate off
      assert false report "wbMemoryWrapper addressed" severity note;
      -- synopsys translate on

      -- If Strobe in is activated, treat the data
      if (to_integer(unsigned(ADDR_I)) < (g_base_address + 16#08#)) then


        if (WE_I = '0') then
          -- Read operation
          -- synopsys translate_off
          assert false report "Reading in memory: " & slv2hexS(std_logic_vector'(DAT_I)) severity note;
          -- synopsys translate_on
          o_WE <= (others => '0');

        else -- WRITE

          -- synopsys translate off
          assert false report "Writing in memory: " & slv2hexS(std_logic_vector'(DAT_I)) severity note;
          -- synopsys translate on
          o_WE <= (others => '1');

        end if;


      end if;
      
    end if;
    
  end process;

  o_Data <= DAT_I;
  o_Address <= ADDR_I(c_NbAddressBits-1 downto 0);
  ACK_O <= reg_ACK1;
  o_Control <= reg_Control(0);

end RTL;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------

