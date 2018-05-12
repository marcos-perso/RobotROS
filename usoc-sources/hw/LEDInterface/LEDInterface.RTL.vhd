-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- 
-- LED interface controlled through wishbone bus
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
-- synopsys translate off
use work.txt_util.all;
-- synopsys translate on
use std.textio.all;

use work.LEDInterfacePackage.all;
-- synopsys translate_off
use work.stringfkt.all;
-- synopsys translate_on
   
-----------------------------
-- ARCHITECTURE DEFINITION --
-----------------------------
 
architecture RTL of LEDInterface is


  -- CONSTANTS DEFINITION --

  -- SIGNAL DEFINITION --
  signal reg_LEDS : std_logic_vector(c_WishboneDataWidth - 1 downto 0);
  signal reg_InputSelection : std_logic_vector(c_WishboneDataWidth - 1 downto 0); -- TBC
  signal reg_ByteSelection : std_logic_vector(c_WishboneDataWidth - 1 downto 0);  -- TBC

  -- DEBUG
-- synopsys translate_off
  file l_file : TEXT open write_mode is log_file;
-- synopsys translate_on

  -- ARCHITECTURE --

begin

  -- purpose: Register the data coming from the bus
  -- type   : sequential
  p_register: process (CLK_I, RST_I)
  begin  -- process p_register
    if RST_I = '1' then                 -- asynchronous reset (active high)

      reg_LEDS <= (others => '0');
      reg_InputSelection <= (others => '0');
      reg_ByteSelection <= (others => '0');
      
    elsif CLK_I'event and CLK_I = '1' then  -- rising clock edge

      
      if (STB_I = '1') then

        -- synopsys translate off
        assert false report "LED Interface addressed" severity note;
        -- synopsys translate on

        -- If Strobe in is activated, treat the data

        if (WE_I = '1') then
          -- Read operation
          -- synopsys translate_off
          print(l_file,time'image(now) & string'(" ") & string'("WRITE: ADDRESS = ") & slv2hexS(std_logic_vector'(ADDR_I)) & string'("DATA = x") & slv2hexS(std_logic_vector'(DAT_I)));
          assert false report "Writing in LED register: " & slv2hexS(std_logic_vector'(DAT_I)) severity note;

            -- synopsys translate_on

          if (to_integer(unsigned(ADDR_I)) = (base_address + C_LEDS)) then
            reg_LEDS <= DAT_I;
          end if;

          if (to_integer(unsigned(ADDR_I)) = (base_address + C_LED_SELECTINPUT)) then
            reg_InputSelection <= DAT_I;
          end if;

          if (to_integer(unsigned(ADDR_I)) = (base_address + C_BYTE_SELECTION)) then
            reg_ByteSelection <= DAT_I;
          end if;

        end if;

      
      end if;

    end if;

  end process p_register;

  -- purpose: Non-registered outputs
  -- type   : combinational
  -- inputs : WE_I, ADDR_I, reg_LEDS, reg_InputSelection, reg_ByteSelection
  -- outputs: 
  p_Outputs: process (STB_I,WE_I, ADDR_I, reg_LEDS, reg_InputSelection, reg_ByteSelection)
  begin  -- process p_Outputs

    -- Defaults
    DAT_O <= (others => '0'); 
    
      if (STB_I = '1') then

        if (WE_I = '0') then

          -- synopsys translate_off
          assert false report "Reading in LED register: " severity note;
          -- synopsys translate_on
      
          if (to_integer(unsigned(ADDR_I)) = (base_address + C_LEDS)) then
            -- synopsys translate_off
            print(l_file,time'image(now) & string'(" ") & string'("READ: ADDRESS = ") & slv2hexS(std_logic_vector'(ADDR_I)) & string'("DATA = x") & slv2hexS(std_logic_vector'(reg_LEDS)));
                                        -- synopsys translate_on
            DAT_O <= reg_LEDS;
          end if;

          if (to_integer(unsigned(ADDR_I)) = (base_address + C_LED_SELECTINPUT)) then
            -- synopsys translate_off
            print(l_file,time'image(now) & string'(" ") & string'("READ: ADDRESS = ") & slv2hexS(std_logic_vector'(ADDR_I)) & string'("DATA = x") & slv2hexS(std_logic_vector'(reg_InputSelection)));
            -- synopsys translate_on
            DAT_O <= reg_InputSelection;
          end if;

          if (to_integer(unsigned(ADDR_I)) = (base_address + C_BYTE_SELECTION)) then
            -- synopsys translate_off
            print(l_file,time'image(now) & string'(" ") & string'("READ: ADDRESS = ") & slv2hexS(std_logic_vector'(ADDR_I)) & string'("DATA = x") & slv2hexS(std_logic_vector'(reg_ByteSelection)));
            -- synopsys translate_on
            DAT_O <= reg_ByteSelection;
          end if;

        end if;

      end if;

  end process p_Outputs;

  ACK_O  <= STB_I;

  -- purpose: Selects the correct oututs for the LEDS
  -- type   : combinational
  -- inputs : reg_LEDS
  -- outputs: 
  p_Selection: process (reg_LEDS, reg_InputSelection, reg_ByteSelection, p_InLeds)

    variable v_Data : std_logic_vector(31 downto 0);
    
  begin  -- process p_Selection


    v_Data := (others => '0');

    if (reg_InputSelection(0) = '0')
    then 
      --sWe select the LED registers
      v_Data := reg_LEDS;
    else
      -- We select the Direct input
      v_Data := p_InLeds;
    end if;

    case reg_ByteSelection(2 downto 0) is

      when "000" => p_LEDS <= v_Data(3 downto 0);
      when "001" => p_LEDS <= v_Data(7 downto 4);
      when "010" => p_LEDS <= v_Data(11 downto 8);
      when "011" => p_LEDS <= v_Data(15 downto 12);
      when "100" => p_LEDS <= v_Data(19 downto 16);
      when "101" => p_LEDS <= v_Data(23 downto 20);
      when "110" => p_LEDS <= v_Data(27 downto 24);
      when "111" => p_LEDS <= v_Data(31 downto 28);
                   
      when others => null;

    end case;
    
  end process p_Selection;


end RTL;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------

