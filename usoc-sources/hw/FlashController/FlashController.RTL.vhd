-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- 
-- Controls the external FLASH memory operation
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
use work.FlashControllerPackage.all;
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
 
architecture RTL of FlashController is


  -- CONSTANTS DEFINITION --

  -- SIGNAL DEFINITION --
  signal reg_Command        : std_logic_vector(3 downto 0);
  signal v_FlashFSM         : t_FlashFSM;
  signal v_FSM              : t_FSM_FlashProgram;
  signal reg_Address        : std_logic_vector(20 downto 0);
  signal reg_AddressStart : unsigned(20 downto 0);
  signal reg_Data           : std_logic_vector(15 downto 0);
  signal reg_PosCounter     : unsigned(4 downto 0);
  signal reg_ProgramMode    : std_logic;
  signal reg_OENeg : std_logic;
  signal reg_WENeg : std_logic;
  signal reg_CENeg : std_logic;
  signal reg_Manufacturer   : std_logic_vector(2 downto 0);
  signal reg_DeviceIdCycle1 : std_logic_vector(15 downto 0);
  signal reg_DeviceIdCycle2 : std_logic_vector(15 downto 0);
  signal reg_DeviceIdCycle3 : std_logic_vector(15 downto 0);
  signal reg_WriteFlash     : std_logic;
  signal reg_ReadFlash      : std_logic;
  signal reg_ProgramDone    : std_logic;   -- Signals the console that the programming on the flash is finished
  signal reg_FixedAddress   : std_logic_vector(31 downto 0);
  signal reg_FixedData      : std_logic_vector(15 downto 0);
  signal s_Debug            : std_logic_vector(3 downto 0);

  signal reg_Interrupt      : std_logic_vector(7 downto 0);  -- Interrupt register
  signal reg_FlashResetCounter : unsigned(15 downto 0);
  signal reg_ResetFlash_n      : std_logic;
  signal reg_PollData : std_logic;

  -- REGISERS DEFINITION --

  signal reg_Access         : std_logic;
              -- [0] Normal access
              -- [1]: Whishbone access
  signal reg_WBAccess       : std_logic;

  -- INTERRUPTS
  -- 0 ==> FlashController control addressed
  -- 1 ==> One shot program done
  -- 2 ==> Get information from Flash
  -- 3 ==> Sector erased
  -- 4 ==> Sector programming
  -- 5 ==> 
  -- 6 ==> 
  -- 7 ==> 

  -- DEBUG
-- synopsys translate_off
  file l_file : TEXT open write_mode is log_file;
-- synopsys translate_on

begin

  -- purpose: Interface with wishbone
  -- type   : sequential
  p_register: process (CLK_I, RST_I)
  begin  -- process p_register
    if RST_I = '1' then                 -- asynchronous reset (active high)

      reg_Interrupt         <= (others => '0');
      reg_Command           <= (others => '0');
      reg_Address           <= (others => '0');
      reg_AddressStart      <= to_unsigned(0,21);
      reg_PosCounter        <= to_unsigned(0,5);
      v_FSM                 <= e_Idle;
      v_FlashFSM            <= e_Idle;
      reg_ProgramMode       <= '0';
      reg_Data              <= (others => '0');
      reg_OENeg             <= '1';
      reg_WENeg             <= '1';
      reg_CENeg             <= '1';
      reg_Manufacturer      <= (others => '0');
      reg_DeviceIdCycle1    <= (others => '0');
      reg_DeviceIdCycle2    <= (others => '0');
      reg_DeviceIdCycle3    <= (others => '0');
      reg_WriteFlash        <= '0';
      reg_ReadFlash         <= '0';
      reg_ProgramDone       <= '0';
      s_Debug               <= (others => '0');
      reg_FixedAddress      <= (others => '0');
      reg_FixedData         <= (others => '0');
      reg_Access            <= '0';
      reg_WBAccess          <= '0';     -- Should be 0
      reg_FlashResetCounter <= to_unsigned(0,16);
      reg_ResetFlash_n      <= '1';
      reg_PollData          <= '0';
      
    elsif CLK_I'event and CLK_I = '1' then  -- rising clock edge

      -- Programming done last one cycle
      reg_ProgramDone    <= '0';

      if (STB_I = '1') then

        -- synopsys translate off
        assert false report "Flash controller addressed: ADDR_I: " & slv2hexS(std_logic_vector'(ADDR_I)) & " DAT_I = " & slv2hexS(std_logic_vector'(DAT_I(7 downto 0))) severity note;
        -- synopsys translate on

        -- If Strobe in is activated, treat the data
        if (to_integer(unsigned(ADDR_I)) <= (base_address + C_FLASHCONTROLLER_MAX_OFFSET)) then

          if WE_I = '1' then
            -- WRITE
            if (to_integer(unsigned(ADDR_I)) = (base_address + C_FLASHCONTROLLER_COMMAND)) then
              -- synopsys translate off
              assert false report "FLASHCONTROLLER_COMMAND addressed (W)" severity note;
              -- synopsys translate on
              reg_Command <= DAT_I(3 downto 0);
              reg_PosCounter <= to_unsigned(0,5);
            end if;
            if (to_integer(unsigned(ADDR_I)) = (base_address + C_FLASHCONTROLLER_STARTADDRESS_LSB)) then
              -- synopsys translate off
              assert false report "FLASHCONTROLLER_STARTADDRESS_LSB addressed (W)" severity note;
              -- synopsys translate on
              reg_AddressStart(15 downto 0) <= unsigned(DAT_I(15 downto 0));
            end if;
            if (to_integer(unsigned(ADDR_I)) = (base_address + C_FLASHCONTROLLER_STARTADDRESS_MSB)) then
              -- synopsys translate off
              assert false report "FLASHCONTROLLER_STARTADDRESS_MSB addressed (W)" severity note;
              -- synopsys translate on
              reg_AddressStart(20 downto 16) <= unsigned(DAT_I(4 downto 0));
            end if;
            if (to_integer(unsigned(ADDR_I)) = (base_address + C_FLASHCONTROLLER_FIXEDADDRESS)) then
              -- synopsys translate off
              assert false report "FLASHCONTROLLER_FIXEDADDRESS addressed (W)" severity note;
              -- synopsys translate on
              reg_FixedAddress(31 downto 0) <= DAT_I(31 downto 0);
            end if;
            if (to_integer(unsigned(ADDR_I)) = (base_address + C_FLASHCONTROLLER_ACCESS)) then
              -- synopsys translate off
              assert false report "FLASHCONTROLLER_FIXEDADDRESS addressed (W)" severity note;
              -- synopsys translate on
              reg_Access   <= DAT_I(0);
              reg_WBAccess <= DAT_I(1);
            end if;
            if (to_integer(unsigned(ADDR_I)) = (base_address + C_FLASHCONTROLLER_FIXEDDATA)) then
              -- synopsys translate off
              assert false report "FLASHCONTROLLER_FIXEDDATA addressed (W)" severity note;
              -- synopsys translate on
              reg_FixedData(15 downto 0) <= DAT_I(15 downto 0);
            end if;
            if (to_integer(unsigned(ADDR_I)) = (base_address + C_FLASHCONTROLLER_INTERRUPT)) then
              -- synopsys translate off
              assert false report "FLASHCONTROLLER_INTERRUPT addressed (W)" severity note;
              -- synopsys translate on
              reg_Interrupt(7 downto 0) <= DAT_I(7 downto 0);
            end if;

            
          end if;


        end if;
      
      end if;

      case v_FlashFSM is

        when e_Idle =>

          
          reg_OENeg <= '1';
          reg_WENeg <= '1';
          reg_CENeg <= '1';

          if (reg_WriteFlash = '1') then
            v_FlashFSM <= e_WriteState1;
          end if;
          if (reg_ReadFlash = '1') then
            v_FlashFSM <= e_ReadState1;
          end if;
          if (reg_PollData = '1') then
            v_FlashFSM <= e_Poll1;
          end if;

        when e_Poll1 =>

          reg_OENeg <= '1';
          reg_WENeg <= '1';
          reg_CENeg <= '0';

          v_FlashFSM <= e_Poll2;

        when e_Poll2 =>

          reg_OENeg <= '0';
          reg_WENeg <= '1';
          reg_CENeg <= '0';

          reg_PollData <= '0';
          v_FlashFSM <= e_Idle;

        when e_WriteState1 =>


          reg_OENeg <= '1';
          reg_WENeg <= '0';
          reg_CENeg <= '0';
          v_FlashFSM <= e_WriteState2;

        when e_WriteState2 =>


          v_FlashFSM <= e_WriteState3;

        when e_WriteState3 =>


          v_FlashFSM <= e_WriteState4;

        when e_WriteState4 =>

          reg_WENeg <= '1';
          reg_OENeg <= '1';
          reg_WENeg <= '1';
          reg_CENeg <= '1';
          v_FlashFSM <= e_Idle;
          reg_WriteFlash <= '0';

        when e_ReadState1 =>


          reg_OENeg <= '1';
          reg_WENeg <= '1';
          reg_CENeg <= '0';
          v_FlashFSM <= e_ReadState2;

        when e_ReadState2 =>


          reg_WENeg <= '1';
          reg_OENeg <= '0';
          v_FlashFSM <= e_ReadState3;

        when e_ReadState3 =>


          reg_WENeg <= '1';
          reg_OENeg <= '0';
          v_FlashFSM <= e_ReadState4;

        when e_ReadState4 =>


          reg_WENeg <= '1';
          reg_OENeg <= '0';
          v_FlashFSM <= e_ReadState5;

        when e_ReadState5 =>


          reg_OENeg <= '1';
          reg_WENeg <= '1';
          reg_CENeg <= '1';
          v_FlashFSM <= e_Idle;
          reg_ReadFlash <= '0';

        when others => null;

      end case;

      case v_FSM is
        when e_Idle =>

          -- Remove the program Mode
            reg_ProgramMode <= '0';     -- NOTE We deactivate this... but the memory is still being programmed

          -- Get Information (0x1)
          if (reg_Command = "0001") then
            reg_Address <= std_logic_vector(to_unsigned(16#555#,21)); 
            reg_Data    <= std_logic_vector(to_unsigned(16#aa#,16)); 
            reg_PosCounter <= (others => '0');
            reg_ProgramMode <= '1';
            reg_WriteFlash <= '1';
            v_FSM <= e_GetInfo_Cycle1; 
            reg_Interrupt(0) <= '1';
          end if;
          -- Get Device ID (0x2)
          if (reg_Command = "0010") then
            reg_Interrupt(0) <= '1';
          end if;
          -- Program from buffer (0x3)
          if (reg_Command = "0011") then
            reg_Address <= std_logic_vector(to_unsigned(16#555#,21)); 
            reg_Data    <= std_logic_vector(to_unsigned(16#aa#,16)); 
            --reg_AddressStart <= (others => '0');
            reg_PosCounter <= (others => '0');
            reg_ProgramMode <= '1';
            reg_WriteFlash <= '1';
            reg_Interrupt(0) <= '1';
            reg_Interrupt(4) <= '1';
            s_Debug(3 downto 0) <= "0001";
            v_FSM <= e_Program_Cycle1; 
          end if;
          -- Program 'one shot' (0x4)
          if (reg_Command = "0100") then
            reg_Address <= std_logic_vector(to_unsigned(16#555#,21)); 
            reg_Data    <= std_logic_vector(to_unsigned(16#aa#,16)); 
            --reg_AddressStart <= (others => '0');
            reg_ProgramMode <= '1';
            reg_WriteFlash <= '1';
            reg_Interrupt(0) <= '1';
            v_FSM <= e_ProgramOneShot_Cycle1; 
          end if;
          -- Reset (0x5)
          if (reg_Command = "0101") then
            reg_ResetFlash_n <= '0';
            reg_FlashResetCounter <= reg_FlashResetCounter+1;
            reg_Interrupt(0) <= '1';
            if (reg_FlashResetCounter = "1111111111111111") then
              reg_ResetFlash_n <= '1';
              v_FSM <= e_Idle; 
              reg_FlashResetCounter <= to_unsigned(0,16);
              reg_Command <= "0000";
            else
              
            end if;
          end if;
          -- Erase (0x6)
          if (reg_Command = "0110") then

            reg_Address <= std_logic_vector(to_unsigned(16#555#,21)); 
            reg_Data    <= std_logic_vector(to_unsigned(16#aa#,16)); 
            reg_ProgramMode <= '1';
            reg_WriteFlash <= '1';
            v_FSM <= e_EraseSector_Cycle1; 

          end if;

        when e_EraseSector_Cycle1 =>

          if (reg_WriteFlash = '0') then
            reg_Address <= std_logic_vector(to_unsigned(16#2aa#,21)); 
            reg_Data    <= std_logic_vector(to_unsigned(16#55#,16)); 
            reg_WriteFlash <= '1';
            v_FSM <= e_EraseSector_Cycle2;
          end if;

        when e_EraseSector_Cycle2 =>

          if (reg_WriteFlash = '0') then
            reg_Address <= std_logic_vector(to_unsigned(16#555#,21)); 
            reg_Data    <= std_logic_vector(to_unsigned(16#80#,16)); 
            reg_WriteFlash <= '1';
            v_FSM <= e_EraseSector_Cycle3;
          end if;

        when e_EraseSector_Cycle3 =>

          if (reg_WriteFlash = '0') then
            reg_Address <= std_logic_vector(to_unsigned(16#555#,21)); 
            reg_Data    <= std_logic_vector(to_unsigned(16#aa#,16)); 
            reg_WriteFlash <= '1';
            v_FSM <= e_EraseSector_Cycle4;
          end if;

        when e_EraseSector_Cycle4 =>

          if (reg_WriteFlash = '0') then
            reg_Address <= std_logic_vector(to_unsigned(16#2aa#,21)); 
            reg_Data    <= std_logic_vector(to_unsigned(16#55#,16)); 
            reg_WriteFlash <= '1';
            v_FSM <= e_EraseSector_Cycle5;
          end if;

        when e_EraseSector_Cycle5 =>

          if (reg_WriteFlash = '0') then
            reg_Address <= std_logic_vector(to_unsigned(16#0#,21));  -- TBC
            reg_Address(14 downto 0) <= (others => '0');
            reg_Address(20 downto 15) <= std_logic_vector(reg_AddressStart(5 downto 0));
            reg_Data    <= std_logic_vector(to_unsigned(16#30#,16)); 
            reg_WriteFlash <= '1';
            v_FSM <= e_EraseSector_Cycle6;
          end if;

        when e_EraseSector_Cycle6 =>

          if (reg_WriteFlash = '0') then
            reg_WriteFlash <= '0';
            v_FSM <= e_Idle;
            -- Reset the command
            reg_Command <= (others => '0');
            reg_Interrupt(3) <= '0';
          end if;

        when e_Program_Cycle1 =>


          if (reg_WriteFlash = '0') then

            reg_Address <= std_logic_vector(to_unsigned(16#2aa#,21)); 
            reg_Data    <= std_logic_vector(to_unsigned(16#55#,16)); 
            reg_WriteFlash <= '1';
            v_FSM <= e_Program_Cycle2;
            
          end if;

        when e_ProgramOneShot_Cycle1 =>


          if (reg_WriteFlash = '0') then
            
            reg_Address <= std_logic_vector(to_unsigned(16#2aa#,21)); 
            reg_Data    <= std_logic_vector(to_unsigned(16#55#,16)); 
            reg_WriteFlash <= '1';
            v_FSM <= e_ProgramOneShot_Cycle2;
            
          end if;

        when e_Program_Cycle2 =>


          if (reg_WriteFlash = '0') then

            reg_Address <= std_logic_vector(to_unsigned(16#5a#,21)); 
            reg_Data    <= std_logic_vector(to_unsigned(16#25#,16)); 
            reg_WriteFlash <= '1';
            v_FSM <= e_Program_Cycle3;
            
          end if;

        when e_ProgramOneShot_Cycle2 =>


          if (reg_WriteFlash = '0') then

            reg_Address <= std_logic_vector(to_unsigned(16#555#,21)); 
            reg_Data    <= std_logic_vector(to_unsigned(16#A0#,16)); 
            reg_WriteFlash <= '1';
            v_FSM <= e_ProgramOneShot_Cycle3;
            
          end if;

        when e_ProgramOneShot_Cycle3 =>


          if (reg_WriteFlash = '0') then

            reg_Address <= std_logic_vector(to_unsigned(16#0#,21)); 
            reg_Data    <= std_logic_vector(to_unsigned(16#AA#,16));
            v_FSM <= e_ProgramOneShot_Cycle4;
            reg_WriteFlash <= '1';
            
          end if;

        when e_ProgramOneShot_Cycle4 =>


          if (reg_WriteFlash = '0') then

            reg_Address <= (others => '0');
            reg_Data    <= (others => '0');
            v_FSM <= e_WaitRY0;
            -- Reset the command
            reg_Command <= (others => '0');
            
          end if;

        when e_WaitRY0 =>

          if (i_RY = '0') then
            v_FSM <= e_WaitRY1;
            reg_CENeg <= '0';
            reg_OENeg <= '0';
          end if;

        when e_WaitRY1 =>

            reg_CENeg <= '0';
            reg_OENeg <= '0';

            -- Polling algorithm

          if (i_RY = '1') then
            v_FSM <= e_Idle;
            reg_ProgramMode <= '0';     -- NOTE We deactivate this... but the memory is still being programmed
            reg_Interrupt(1) <= '1';
          end if;


        when e_Program_Cycle3 =>


          if (reg_WriteFlash = '0') then

            reg_Address <= std_logic_vector(to_unsigned(16#00#,21)); 
            reg_Data    <= std_logic_vector(to_unsigned(16#F#,16));  -- Number of words -1
            reg_WriteFlash <= '1';
            v_FSM <= e_Program_Cycle4;
            
          end if;

--        when e_Program_Cycle4 =>

--          if (reg_WriteFlash = '0') then

--            reg_WriteFlash <= '1';
--            reg_Address <= std_logic_vector(to_unsigned(to_integer(reg_AddressStart),21)); 
--           -- reg_Data <= std_logic_vector(to_unsigned(to_integer(reg_AddressStart),16)); 
--            if (reg_AddressStart(0) = '0') then
--              reg_Data    <= p_DataFromConsole(15 downto 0);
--            else
--              reg_Data    <= p_DataFromConsole(31 downto 16);
--            end if;
--            v_FSM <= e_Program_Cycle5;
            
--          end if;

        when e_Program_Cycle4 =>


          if (reg_WriteFlash = '0') then
            reg_WriteFlash <= '1';
            reg_Address <= std_logic_vector(to_unsigned(to_integer(reg_AddressStart),21)); 
            reg_AddressStart <= reg_AddressStart + 1;
            --reg_Data    <= std_logic_vector(to_unsigned(16#3#,16));
            if (reg_AddressStart(0) = '0') then
              reg_Data    <= p_DataFromConsole(15 downto 0);
              --reg_Data    <= std_logic_vector(to_unsigned(16#AB#,16));  -- Number of words -1
              --reg_Data    <= reg_Address(15 downto 0);
            else
              reg_Data    <= p_DataFromConsole(31 downto 16);
              --reg_Data    <= std_logic_vector(to_unsigned(16#9C#,16));  -- Number of words -1
            end if;
            v_FSM <= e_Program_Cycle4;

            if (unsigned(reg_AddressStart(3 downto 0)) = 15) then  -- 15 to be changed
              v_FSM <= e_Program_Cycle5;
            end if;
            
          end if;

        when e_Program_Cycle5 =>


          if (reg_WriteFlash = '0') then
            reg_WriteFlash <= '1';
            v_FSM <= e_Program_Cycle6;
            reg_Address <= std_logic_vector(to_unsigned(16#0#,21)); 
            reg_Data    <= std_logic_vector(to_unsigned(16#29#,16));
            
          end if;

        when e_Program_Cycle6 =>


          if (reg_WriteFlash = '0') then

            reg_Address <= std_logic_vector(to_unsigned(16#F#,21)); 
            reg_Data    <= std_logic_vector(to_unsigned(16#29#,16));

            -- Send the commands to the flash
            reg_WriteFlash <= '0';
            -- Come back to idle state
            v_FSM <= e_Program_Cycle_DataPolling;
            -- Reset the command
            reg_Command <= (others => '0');
            --reg_AddressStart <= reg_AddressStart + 1;
            -- Indicate the console that the programming is done
            reg_ProgramDone    <= '1';
            reg_PollData <= '1';

          end if;

        when e_Program_Cycle_DataPolling =>

          --if (i_RY = '1') then
         -- if (p_dataFrommem(7) = '1') then
            v_FSM <= e_Idle;
            reg_ProgramMode <= '0';     -- NOTE We deactivate this... but the memory is still being programmed
            reg_Interrupt(1) <= '1';
        --  else

        --    if (reg_PollData = '0') then

        --      reg_PollData <= '1';

        --  end if;


          --end if;
            
        when e_GetInfo_Cycle1 =>

          if (reg_WriteFlash = '0') then

            reg_Address <= std_logic_vector(to_unsigned(16#2aa#,21)); 
            reg_Data    <= std_logic_vector(to_unsigned(16#55#,16)); 
            reg_WriteFlash <= '1';
            v_FSM <= e_GetInfo_Cycle2;
            reg_Interrupt(2) <= '1';
            
          end if;

        when e_GetInfo_Cycle2 =>

          if (reg_WriteFlash = '0') then
            reg_Address <= std_logic_vector(to_unsigned(16#555#,21)); 
            reg_Data    <= std_logic_vector(to_unsigned(16#90#,16)); 
            reg_WriteFlash <= '1';
            v_FSM <= e_GetInfo_Cycle3;
          end if;

        when e_GetInfo_Cycle3 =>

          if (reg_WriteFlash = '0') then
            reg_Address <= std_logic_vector(to_unsigned(16#0#,21)); 
            reg_Data    <= std_logic_vector(to_unsigned(16#0#,16)); 
            reg_ReadFlash <= '1';
            v_FSM <= e_GetInfo_Cycle4;
          end if;

        when e_GetInfo_Cycle4 =>

          if (reg_ReadFlash = '1') then
            reg_Manufacturer(2 downto 0) <= p_DataFromMem(2 downto 0);
            else 
            reg_Address <= std_logic_vector(to_unsigned(16#01#,21)); 
            reg_ReadFlash <= '1';
            v_FSM <= e_GetInfo_Cycle5;
          end if;

        when e_GetInfo_Cycle5 =>

          if (reg_ReadFlash = '1') then
            reg_DeviceIdCycle1(15 downto 0) <= p_DataFromMem(15 downto 0);
            else 
            reg_Address <= std_logic_vector(to_unsigned(16#0#,21)); 
            reg_Command <= (others => '0');
            v_FSM <= e_Idle;
            reg_Interrupt(2) <= '1';
          end if;

        when others => null;

      end case;
      
    end if;
  end process;

  -- purpose: READ part of the wishbone interface
  -- type   : combinational
  -- inputs : ADDR_I,reg_Command, reg_Manufacturer, reg_DeviceIdCycle1, reg_DeviceIdCycle2, reg_DeviceIdCycle3, reg_AddressStart, reg_FixedAddress, reg_Access, reg_Interrupt
  -- outputs: 
  process (STB_I, WE_I, ADDR_I,
           reg_Command,
           reg_Manufacturer,
           reg_DeviceIdCycle1, reg_DeviceIdCycle2, reg_DeviceIdCycle3,
           reg_AddressStart,
           reg_FixedAddress, reg_FixedData,
           reg_WBAccess, reg_Access,
           reg_Interrupt)
  begin  -- process

    -- Default
    DAT_O <= (others => '0');

    if (STB_I = '1') then

      -- If Strobe in is activated, treat the data
      if (to_integer(unsigned(ADDR_I)) <= (base_address + C_FLASHCONTROLLER_MAX_OFFSET)) then

        if WE_I = '0' then

          if (to_integer(unsigned(ADDR_I)) = (base_address + C_FLASHCONTROLLER_COMMAND)) then
            DAT_O(3 downto 0) <= reg_Command;
          end if;
          if (to_integer(unsigned(ADDR_I)) = (base_address + C_FLASHCONTROLLER_MANUFACTURERID)) then
            DAT_O(2 downto 0) <= reg_Manufacturer;
          end if;
          if (to_integer(unsigned(ADDR_I)) = (base_address + C_FLASHCONTROLLER_DEVICEIDCYCLE1)) then
            DAT_O(15 downto 0) <= reg_DeviceIdCycle1;
          end if;
          if (to_integer(unsigned(ADDR_I)) = (base_address + C_FLASHCONTROLLER_DEVICEIDCYCLE2)) then
            DAT_O(15 downto 0) <= reg_DeviceIdCycle2;
          end if;
          if (to_integer(unsigned(ADDR_I)) = (base_address + C_FLASHCONTROLLER_DEVICEIDCYCLE3)) then
            DAT_O(15 downto 0) <= reg_DeviceIdCycle3;
          end if;
          if (to_integer(unsigned(ADDR_I)) = (base_address + C_FLASHCONTROLLER_STARTADDRESS_LSB)) then
            -- synopsys translate off
            assert false report "FLASHCONTROLLER_STARTADDRESS_LSB addressed (R)" severity note;
            -- synopsys translate on
            DAT_O(15 downto 0) <= std_logic_vector(reg_AddressStart(15 downto 0));
          end if;
          if (to_integer(unsigned(ADDR_I)) = (base_address + C_FLASHCONTROLLER_STARTADDRESS_MSB)) then
            -- synopsys translate off
            assert false report "FLASHCONTROLLER_STARTADDRESS_MSB addressed (R)" severity note;
            -- synopsys translate on
            DAT_O(15 downto 0) <= (others => '0');
            DAT_O(4  downto 0) <= std_logic_vector(reg_AddressStart(20 downto 16));
          end if;
          if (to_integer(unsigned(ADDR_I)) = (base_address + C_FLASHCONTROLLER_FIXEDADDRESS)) then
            -- synopsys translate off
            assert false report "FLASHCONTROLLER_FIXEDADDRESS addressed (R)" severity note;
            -- synopsys translate on
            DAT_O <= std_logic_vector(reg_FixedAddress);
          end if;
          if (to_integer(unsigned(ADDR_I)) = (base_address + C_FLASHCONTROLLER_ACCESS)) then
            -- synopsys translate off
            assert false report "FLASHCONTROLLER_ACCESS addressed (R)" severity note;
            -- synopsys translate on
            DAT_O(31 downto 0) <= (others => '0');
            DAT_O(1) <= reg_WBAccess;
            DAT_O(0) <= reg_Access;
          end if;
          if (to_integer(unsigned(ADDR_I)) = (base_address + C_FLASHCONTROLLER_FIXEDDATA)) then
            -- synopsys translate off
            assert false report "FLASHCONTROLLER_FIXEDDATA addressed (R)" severity note;
            -- synopsys translate on
            DAT_O(31 downto 0) <= (others => '0');
            DAT_O(15 downto 0) <= std_logic_vector(reg_FixedData(15 downto 0));
          end if;
          if (to_integer(unsigned(ADDR_I)) = (base_address + C_FLASHCONTROLLER_INTERRUPT)) then
            -- synopsys translate off
            assert false report "FLASHCONTROLLER_INTERRUPT addressed (R)" severity note;
            -- synopsys translate on
            DAT_O(31 downto 0) <= (others => '0');
            DAT_O(7 downto 0)  <= std_logic_vector(reg_Interrupt(7 downto 0));
          end if;
            
        end if;

      end if;

    end if;

  end process;

  -----------------------------------------------------------------------------
  -- OUTPUTS --
  -----------------------------------------------------------------------------

  --s_Debug(3) <= reg_ProgramMode;
  p_Debug               <= s_Debug(3 downto 0);
  ACK_O                 <= STB_I;
  p_ProgramMode         <= reg_ProgramMode;
  p_ProgramDone         <= reg_ProgramDone;
  p_DataToMem           <= reg_Data;
  p_WENegFromController <= reg_WENeg;
  p_OENegFromController <= reg_OENeg;
  p_CENegFromController <= reg_CENeg;
  p_AddrToConsole       <= std_logic_vector(reg_AddressStart(3 downto 1));
  p_Access              <= reg_Access;
  p_WBAccess            <= reg_WBAccess;
  o_ResetFlash_n        <= reg_ResetFlash_n;

  -- purpose: Selects the data depending of the mode of operation
  -- type   : combinational
  -- inputs : p_Access
  -- outputs: p_DataToMem
  p_Outputs: process (reg_Access,reg_Address,reg_FixedAddress)
  begin  -- process p_Outputs


    if (reg_Access = '0') then
      p_AddrToMem   <= reg_Address;
    else
      p_AddrToMem   <= reg_FixedAddress(20 downto 0);
    end if;

  end process p_Outputs;

  -- IRQs
  o_Interrupt <= reg_Interrupt(0) or
                 reg_Interrupt(1) or
                 reg_Interrupt(2) or
                 reg_Interrupt(3) or
                 reg_Interrupt(4) or
                 reg_Interrupt(5) or
                 reg_Interrupt(6) or
                 reg_Interrupt(7);

end RTL;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------

