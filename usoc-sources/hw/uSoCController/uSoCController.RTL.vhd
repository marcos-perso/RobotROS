-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- 
-- Controls the ZPU process
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
use work.uSoCControllerPackage.all;
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
 
architecture RTL of uSoCController is


  -- CONSTANTS DEFINITION --

  -- SIGNAL DEFINITION --

  signal reg_Enable   : std_logic;
  signal reg_ZPUReset : std_logic;

  -- DEBUG
  -- synopsys translate_off
  file l_file : TEXT open write_mode is g_log_file;
  -- synopsys translate_on

begin

  -- purpose: Register the data coming from the bus
  -- type   : sequential
  p_register: process (CLK_I, RST_I)
  begin  -- process p_register
    if RST_I = '1' then                 -- asynchronous reset (active high)

      reg_Enable   <= '0';
      reg_ZPUReset <= '0';
      
    elsif CLK_I'event and CLK_I = '1' then  -- rising clock edge

      -- Reset of the ZPU is just one pulse
      reg_ZPUReset <= '0';

      if (STB_I = '1') then

        -- synopsys translate off
        assert false report "uSoC Controller addressed" severity note;
        -- synopsys translate on

        -- If Strobe in is activated, treat the data

        if (WE_I = '1') then
          -- Read operation
          -- synopsys translate_off
          print(l_file,time'image(now) & string'(" ") & string'("WRITE: ADDRESS = ") & slv2hexS(std_logic_vector'(ADDR_I)) & string'("DATA = x") & slv2hexS(std_logic_vector'(DAT_I)));
          assert false report "Writing in uSoC Controller: " & slv2hexS(std_logic_vector'(DAT_I)) severity note;

            -- synopsys translate_on

          if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_ZPUCONTROL)) then
            reg_Enable   <= DAT_I(0);
            reg_ZPUReset <= DAT_I(1);
          end if;

        end if;

      
      end if;

    end if;

  end process p_register;

  -- purpose: Non-registered outputs
  -- type   : combinational
  -- inputs : WE_I, ADDR_I, reg_LEDS, reg_InputSelection, reg_ByteSelection
  -- outputs: 
  p_Outputs: process (STB_I,WE_I, ADDR_I,reg_Enable, reg_ZPUReset)
  begin  -- process p_Outputs

    -- Defaults
    DAT_O <= (others => '0'); 
    
      if (STB_I = '1') then

        if (WE_I = '0') then

          -- synopsys translate_off
          assert false report "Reading in uSoC Controller: " severity note;
          -- synopsys translate_on
      
          if (to_integer(unsigned(ADDR_I)) = (g_base_address + C_ZPUCONTROL)) then
            -- synopsys translate_off
            print(l_file,time'image(now) & string'(" ") & string'("READ: ADDRESS = ") & slv2hexS(std_logic_vector'(ADDR_I)) & string'("DATA = x") );
                                        -- synopsys translate_on
            DAT_O <= (others => '0');
            DAT_O(0) <= reg_Enable;
            DAT_O(1) <= reg_ZPUReset;
          end if;

        end if;

      end if;

  end process p_Outputs;


  -----------------------------
  -- Continuous assignments ---
  -----------------------------
  ACK_O      <= STB_I;
  p_Enable   <= reg_Enable;
  p_ResetZPU <= reg_ZPUReset;



end RTL;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------

