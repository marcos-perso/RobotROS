-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- Console to connect the PC to the platform
-- It acts as a wishbone master
--
-- NOTES:
--
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
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use std.textio.all;
-- synopsys translate_off
use work.stringfkt.all;
-- synopsys translate_on

library work;
use work.SoCConstantsPackage.all;
use work.WishboneConstantsPackage.all;
use work.ConsolePackage.all;
use work.RegisterMapPackage.all;

-----------------------------
-- ARCHITECTURE DEFINITION --
-----------------------------
   
architecture RTL of Console is


  --  FSM REGISTERS
  signal v_FSM_Itf : t_FSM_Itf;
  signal v_FSM_WB  : t_FSM_WB;

  -- Registers
  signal s_Command : t_Command;
  signal s_Address : std_logic_vector(7 downto 0);
  signal s_Data    : std_logic_vector(7 downto 0);

  -- Indirection registers
  signal reg_Command  : std_logic_vector(7 downto 0);
  signal reg_Address1 : std_logic_vector(7 downto 0);
  signal reg_Address2 : std_logic_vector(7 downto 0);
  signal reg_Address3 : std_logic_vector(7 downto 0);
  signal reg_Address4 : std_logic_vector(7 downto 0);
  signal reg_Data1    : std_logic_vector(7 downto 0);
  signal reg_Data2    : std_logic_vector(7 downto 0);
  signal reg_Data3    : std_logic_vector(7 downto 0);
  signal reg_Data4    : std_logic_vector(7 downto 0);
  signal reg_Program  : std_logic_vector(31 downto 0);



  
  signal s_AddressFieldToSoC      : std_logic_vector(c_WishboneAddrWidth-1 downto 0);
  signal s_DataFieldFromSoC       : std_logic_vector(c_WishboneDataWidth-1 downto 0);
  signal s_Response           : std_logic_vector(7 downto 0);

  signal s_SendByteToUART : std_logic;        -- Send a byte through the UART
  signal s_SendByteToSoC  : std_logic;        -- Send a byte through the UART
  signal s_ReadByte : std_logic;        -- Byte read through the UART
  signal s_WBDone   : std_logic;        -- Wishbone transaction achieved

  signal s_RisingEdgeTxInterrupt : std_logic;
  signal s_UARTTxInterruptDelayed : std_logic;

  signal s_ProgramFlashMode : std_logic;
  signal s_NbProgramBytes   : unsigned(4 downto 0);


  signal s_WEToConsoleRAM      : std_logic_vector(0 downto 0);

  signal reg_DoProgram : std_logic;

  -- FSM

  -- OTHER

  -- DEBUG
  file l_file : TEXT open write_mode is log_file;
  signal s_Debug : std_logic_vector(7 downto 0);
  
begin

  process(CLK_I, RST_I)

  begin

    if RST_I = '1' then                 -- if#1

      -- Reset FSMs
      v_FSM_Itf <= e_Idle;
      v_FSM_WB  <= e_Idle;

      -- Reset signals
      s_Command <= e_NOP;
      s_Address <= (others => '0');
      s_Data    <= (others => '0');

      -- Reset registers
      reg_Command  <= (others => '0');
      reg_Address1 <= (others => '0');
      reg_Address2 <= (others => '0');
      reg_Address3 <= (others => '0');
      reg_Address4 <= (others => '0');
      reg_Data1    <= (others => '0');
      reg_Data2    <= (others => '0');
      reg_Data3    <= (others => '0');
      reg_Data4    <= (others => '0');
      reg_Program  <= (others => '0');
      WE_O   <= '0';
      s_AddressFieldToSoC    <= (others => '0');
      s_DataFieldFromSoC     <= (others => '0');
      s_Response             <= (others => '0');
      s_SendByteToUART <= '0';
      s_SendByteToSoC  <= '0';
      s_ReadByte <= '0';
      s_WBDone   <= '0';
      s_RisingEdgeTxInterrupt <= '0';
      s_UARTTxInterruptDelayed <= '0';
      s_Debug <= (others => '0');
      s_ProgramFlashMode <= '0';

      s_NbProgramBytes <= to_unsigned(31,5);

      s_WEToConsoleRAM      <= (others => '0');
      reg_DoProgram         <= '0';

    elsif (CLK_I'event and CLK_I = '1') then -- if#1


      -- Default
      s_SendByteToUART <= '0';
      s_SendByteToSoC  <= '0';
      s_WBDone         <= '0';
      s_ReadByte       <= '0';
      reg_DoProgram    <= '0';

      s_UARTTxInterruptDelayed <= p_UARTTxInterrupt;
      if (p_UARTTxInterrupt = '1') and (s_UARTTxInterruptDelayed = '0') then
        s_RisingEdgeTxInterrupt <= '1';
        else
        s_RisingEdgeTxInterrupt <= '0';
      end if;

      -- Generate control signals for the Console RAM
      if (std_logic_vector(s_NbProgramBytes(1 downto 0)) = "11") then
        s_WEToConsoleRAM      <= (others => '1');
      else
        s_WEToConsoleRAM      <= (others => '0');
      end if;

      -- --------------------------
      -- Change FSM state (WISHBONE)
      -- --------------------------
      case v_FSM_WB is
        when e_Idle =>

          DAT_O  <= (others => '0');
          ADDR_O <= (others => '0');
          WE_O   <= '0';
          CYC_O  <= '0';
          STB_O  <= '0';

          -- Case 1: Something arrived
          if (p_UartRxInterrupt = '1') then
            -- Read from UART
            -- Send a Read command through wishbone bus
            ADDR_O <= std_logic_vector(to_unsigned(c_MINIUART_BASE_ADDRESS + c_MINUART_READ,c_WishboneAddrWidth));
            DAT_O  <= (others => '0');
            SEL_O  <= (others => '0');
            WE_O   <= '0';
            CYC_O  <= '1';
            STB_O  <= '1';
            v_FSM_WB <= e_READ;
          end if;

          -- Case 2: Something to be sent
          if (s_SendByteToUART = '1') then
            -- Send through the UART
            ADDR_O <= std_logic_vector(to_unsigned(c_MINIUART_BASE_ADDRESS + c_MINUART_WRITE,c_WishboneAddrWidth));
            DAT_O(7 downto 0)  <= s_Response;
            SEL_O  <= (others => '0');
            WE_O   <= '1';
            CYC_O  <= '1';
            STB_O  <= '1';
            s_ReadByte <= '0';
            v_FSM_WB <= e_WRITE;
          end if;

          -- Case 3: Transaction to be sent to the SoC WB system
          if (s_SendByteToSoC = '1') then
            -- Send through the UART
            ADDR_O <= reg_Address1(3 downto 0) & reg_Address2 & reg_Address3 & reg_Address4;
            DAT_O  <= reg_Data1 & reg_Data2 & reg_Data3 & reg_Data4;
            SEL_O  <= (others => '0');
            if reg_Command(1 downto 0) = "01" then
              WE_O   <= '1';
            elsif reg_Command(1 downto 0) = "10" then
              WE_O   <= '0';
            else
              WE_O   <= '0';
            end if;
            CYC_O  <= '1';
            STB_O  <= '1';
            s_ReadByte <= '0';
            v_FSM_WB <= e_WRITE;
          end if;

        when e_READ =>

          if (ACK_I = '1') then
            DAT_O  <= (others => '0');
            ADDR_O <= (others => '0');
            WE_O   <= '0';
            CYC_O  <= '0';
            STB_O  <= '0';
            v_FSM_WB <= e_Idle;
            s_ReadByte <= '1';
          end if;

        when e_WRITE =>

          if (ACK_I = '1') then
            DAT_O  <= (others => '0');
            ADDR_O <= (others => '0');
            WE_O   <= '0';
            CYC_O  <= '0';
            STB_O  <= '0';
            v_FSM_WB <= e_Idle;
          end if;

        when others => null;
      end case;

      -- ----------------------
      -- Change FSM state (ITF)
      -- ----------------------

      case v_FSM_Itf is

        when e_Idle =>

          s_Debug <= "00001111";

          -- IDLE state
          -- We exit the Idle state when we receive an IRQ from the miniuart
          if (p_UARTRxInterrupt = '1') then
            v_FSM_Itf <= e_TreatCommand;
          end if;

          s_ProgramFlashMode <= '0';

        when e_TreatCommand =>

          s_Debug <= "00000000";


          v_FSM_Itf <= e_Idle;

          if (DAT_I(2 downto 0) = "000") then
            s_Command <= e_NOP;
          elsif (DAT_I(2 downto 0) = "001") then
            s_Command <= e_WRITE;
            v_FSM_Itf <= e_ReadAddress;
          elsif (DAT_I(2 downto 0) = "010") then
            s_Command <= e_READ;
            v_FSM_Itf <= e_ReadAddress;
          elsif (DAT_I(2 downto 0) = "011") then
            s_Command <= e_PROGRAM_FLASH;
            v_FSM_Itf <= e_ProgramMode0;
          elsif (DAT_I(2 downto 0) = "100") then
            s_Command <= e_NOP;
            v_FSM_Itf <= e_TriggerProgramming;
          else
            s_Command <= e_NOP;
          end if;

        when e_ReadAddress =>

          s_Debug <= "00000000";

          if (v_FSM_WB = e_READ and ACK_I = '1') then
            s_Address <= DAT_I(7 downto 0);

            case s_Command is
              when e_NOP   => v_FSM_Itf <= e_Idle;
              when e_READ  => v_FSM_Itf <= e_dataHandling;
              when e_WRITE => v_FSM_Itf <= e_ReadData;
              when others => null;
            end case;
          end if;

        when e_ReadData =>

          s_Debug <= "00000000";


          if (v_FSM_WB = e_READ and ACK_I = '1') then

            s_Data <= DAT_I(7 downto 0);
            v_FSM_Itf <= e_dataHandling;   -- WRITE

          end if;

        when e_TriggerConfirm =>

          if (s_RisingEdgeTxInterrupt = '1') then
            v_FSM_Itf <= e_Idle;
          else
            v_FSM_Itf <= e_TriggerConfirm;
          end if;

        when e_TriggerProgrammingDone =>

          s_Debug <= "00000000";


          if (ACK_I = '1') then
            -- We only send to UART when we receive the ACK from the flash
            s_Response <= "00000111";
            v_FSM_Itf <= e_SendData;
            s_SendByteToUART <= '1';
            v_FSM_Itf <= e_TriggerConfirm;   -- WRITE
          end if;

        when e_TriggerProgramming =>

          s_Debug <= "00000000";


          -- We send a command to the flash
          reg_Command <= "00000001";
          reg_Address1 <= (others => '0');
          reg_Address1(2 downto 0) <= "010";
          reg_Address2(7 downto 0) <= "00000000";
          reg_Address3(7 downto 0) <= "00000000";
          reg_Address4(7 downto 0) <= "00100000";
          reg_Data1(7 downto 0)    <= "00000000";
          reg_Data2(7 downto 0)    <= "00000000";
          reg_Data3(7 downto 0)    <= "00000000";
          reg_Data4(7 downto 0)    <= "00000011";
          s_SendByteToSoC <= '1';
          v_FSM_Itf <= e_TriggerProgrammingDone;
          
        when e_ProgramMode0 =>

          s_Debug <= "00000001";


          -- We wait for program codes
          if (p_UARTRxInterrupt = '1') then

            -- READ from UART the received byte
            --if (v_FSM_WB = e_READ and ACK_I = '1') then
            if (v_FSM_WB = e_READ and ACK_I = '1') then
              
--              reg_DoProgram <= '1';
--              s_ProgramFlashMode <= '1';
              s_NbProgramBytes <= s_NbProgramBytes + 1;

              -- we use a shift register
              reg_Program(31 downto 24) <= DAT_I(7 downto 0);

              s_Response <= DAT_I(7 downto 0);
              s_Response <= "00000001";
              s_SendByteToUART <= '1';

              v_FSM_Itf <= e_SendProgramConfirm0;
              
              -- synopsys translate off
              --assert false report "DAT_I = " & slv2hexS(std_logic_vector'(DAT_I(7 downto 0))) severity note;
              -- synopsys translate on
              
            end if;

          end if;

        when e_SendProgramConfirm0 =>

          s_Debug <= "00000010";

          if (s_RisingEdgeTxInterrupt = '1') then
            v_FSM_Itf <= e_ProgramMode1;
          else
            v_FSM_Itf <= e_SendProgramConfirm0;
          end if;

        when e_SendProgramConfirm1 =>

          s_Debug <= "00000100";

          if (s_RisingEdgeTxInterrupt = '1') then
            v_FSM_Itf <= e_ProgramMode2;
          else
            v_FSM_Itf <= e_SendProgramConfirm1;
          end if;

        when e_SendProgramConfirm2 =>

          s_Debug <= "00000110";

          if (s_RisingEdgeTxInterrupt = '1') then
            v_FSM_Itf <= e_ProgramMode3;
          else
            v_FSM_Itf <= e_SendProgramConfirm2;
          end if;

        when e_SendProgramConfirm3 =>

          s_Debug <= "00001000";

          if (s_RisingEdgeTxInterrupt = '1') then
            v_FSM_Itf <= e_Idle;
          else
            v_FSM_Itf <= e_SendProgramConfirm3;
          end if;


        when e_ProgramMode1 =>

          s_Debug <= "00000011";

          -- We wait for program codes
          if (p_UARTRxInterrupt = '1') then

            -- READ from UART the received byte
            if (v_FSM_WB = e_READ and ACK_I = '1') then
            --if (ACK_I = '1') then
              
--              reg_DoProgram <= '1';
--              s_ProgramFlashMode <= '1';
              s_NbProgramBytes <= s_NbProgramBytes + 1;

              -- we use a shift register
              reg_Program(23 downto 16) <= DAT_I(7 downto 0);

              s_Response <= "00000010";
              s_SendByteToUART <= '1';

              v_FSM_Itf <= e_SendProgramConfirm1;
              
              -- synopsys translate off
              --assert false report "DAT_I = " & slv2hexS(std_logic_vector'(DAT_I(7 downto 0))) severity note;
              -- synopsys translate on
              
            end if;

          end if;

        when e_ProgramMode2 =>

          s_Debug <= "00000101";

          -- We wait for program codes
          if (p_UARTRxInterrupt = '1') then

            -- READ from UART the received byte
            if (v_FSM_WB = e_READ and ACK_I = '1') then
            --if (ACK_I = '1') then
              
--              reg_DoProgram <= '1';
--              s_ProgramFlashMode <= '1';
              s_NbProgramBytes <= s_NbProgramBytes + 1;

              -- we use a shift register
              reg_Program(15 downto 8) <= DAT_I(7 downto 0);

              s_Response <= "00000011";
              s_SendByteToUART <= '1';

              v_FSM_Itf <= e_SendProgramConfirm2;
              
              -- synopsys translate off
              --assert false report "DAT_I = " & slv2hexS(std_logic_vector'(DAT_I(7 downto 0))) severity note;
              -- synopsys translate on
              
            end if;

          end if;

        when e_ProgramMode3 =>

          s_Debug <= "00000111";

          -- We wait for program codes
          if (p_UARTRxInterrupt = '1') then

            -- READ from UART the received byte
            if (v_FSM_WB = e_READ and ACK_I = '1') then
            --if (ACK_I = '1') then
              
--              reg_DoProgram <= '1';
--              s_ProgramFlashMode <= '1';
              s_NbProgramBytes <= s_NbProgramBytes + 1;

              -- we use a shift register
              reg_Program(7 downto 0) <= DAT_I(7 downto 0);

              s_Response <= "00000100";
              s_SendByteToUART <= '1';

              v_FSM_Itf <= e_SendProgramConfirm3;
              
              -- synopsys translate off
              --assert false report "DAT_I = " & slv2hexS(std_logic_vector'(DAT_I(7 downto 0))) severity note;
              -- synopsys translate on
              
            end if;

          end if;

        when e_dataHandling =>

          s_Debug <= "00000000";

          -- Depending of the address and the type of command we do an action
          -- or not
          case s_Command is     -- COMMAND
            when e_WRITE =>             -- WRITE

              -- synopsys translate off
--              assert false report "writing in register ADDRESS = " & slv2hexS(std_logic_vector'(s_Address)) & " ; DATA = " & slv2hexS(std_logic_vector'(s_Data))  severity note;
              -- synopsys translate on
              
              case s_Address is
                when "00000000" =>
                  reg_Command <= s_Data(7 downto 0);
                  if (ACK_I = '1') then
                    s_Response <= "00000001";
                    v_FSM_Itf <= e_SendData;
                    s_SendByteToUART <= '1';
                    -- Copy the results of the READING to the relevant DATA registers
                    if reg_Command(1 downto 0) = "10" then
                      reg_Data1 <= DAT_I(31 downto 24);
                      reg_Data2 <= DAT_I(23 downto 16);
                      reg_Data3 <= DAT_I(15 downto 8);
                      reg_Data4 <= DAT_I(7  downto 0);
                    end if;
                  else
                    v_FSM_Itf <= e_dataHandling;
                    s_SendByteToSoC <= '1';
                  end if;
                when "00000001" =>      -- ADDRESS 1
                  reg_Address1 <= s_Data(7 downto 0);
                  s_Response <= "00000001";
                  v_FSM_Itf <= e_SendData;
                  s_SendByteToUART <= '1';
                when "00000010" =>      -- ADDRESS 2
                  reg_Address2 <= s_Data(7 downto 0);
                  s_Response <= "00000001";
                  v_FSM_Itf <= e_SendData;
                  s_SendByteToUART <= '1';
                when "00000011" =>      -- ADDRESS 3
                  reg_Address3 <= s_Data(7 downto 0);
                  s_Response <= "00000001";
                  v_FSM_Itf <= e_SendData;
                  s_SendByteToUART <= '1';
                when "00000100" =>      -- ADDRESS 4
                  reg_Address4 <= s_Data(7 downto 0);
                  s_Response <= "00000001";
                  v_FSM_Itf <= e_SendData;
                  s_SendByteToUART <= '1';
                when "00000101" =>      -- ADDRESS 4
                  reg_Data1 <= s_Data(7 downto 0);
                  s_Response <= "00000001";
                  v_FSM_Itf <= e_SendData;
                  s_SendByteToUART <= '1';
                when "00000110" =>      -- ADDRESS 4
                  reg_Data2 <= s_Data(7 downto 0);
                  s_Response <= "00000001";
                  v_FSM_Itf <= e_SendData;
                  s_SendByteToUART <= '1';
                when "00000111" =>      -- ADDRESS 4
                  reg_Data3 <= s_Data(7 downto 0);
                  s_Response <= "00000001";
                  v_FSM_Itf <= e_SendData;
                  s_SendByteToUART <= '1';
                when "00001000" =>      -- ADDRESS 4
                  reg_Data4 <= s_Data(7 downto 0);
                  s_Response <= "00000001";
                  v_FSM_Itf <= e_SendData;
                  s_SendByteToUART <= '1';
                when others => null;

              end case;
            when e_READ =>             -- READ

              case s_Address is
                when "00000000" =>
                  s_Response <= reg_Command;
                when "00000001" =>      -- ADDRESS 1
                  s_Response <= reg_Address1;
                when "00000010" =>      -- ADDRESS 2
                  s_Response <= reg_Address2;
                when "00000011" =>      -- ADDRESS 3
                  s_Response <= reg_Address3;
                when "00000100" =>      -- ADDRESS 4
                  s_Response <= reg_Address4;
                when "00000101" =>      -- ADDRESS 4
                  s_Response <= reg_Data1;
                when "00000110" =>      -- ADDRESS 4
                  s_Response <= reg_Data2;
                when "00000111" =>      -- ADDRESS 4
                  s_Response <= reg_Data3;
                when "00001000" =>      -- ADDRESS 4
                  s_Response <= reg_Data4;
                when others => null;
                               
              end case;
              v_FSM_Itf <= e_SendData;
              s_SendByteToUART <= '1';

            when e_PROGRAM_FLASH =>             -- WRITE


            --  reg_Command <= "00000001"; -- Equal to a write

            when others => null;
          end case;

        when e_SendData =>

          s_Debug <= "00000000";



          if (s_RisingEdgeTxInterrupt = '1') then
            v_FSM_Itf <= e_Idle;
          else
            v_FSM_Itf <= e_SendData;
          end if;


        when others => null;

      end case;


    end if;

  end process;


  -- ==============================
  -- === CONTINUOUS ASSIGNMENTS ===
  -- ==============================
  --p_Debug <= std_logic_vector(s_NbProgramBytes(3 downto 0));
  --p_Debug <= reg_DoProgramPers & s_ProgramFlashMode & s_SendByteToUART & s_SendByteToSoC;
  p_Debug <= reg_Data1 & reg_Data2 & reg_Data3 & s_Debug;
  --p_Debug <= s_Debug;
  --s_Debug;

  p_DataToConsoleRAM    <= reg_Program;
  p_AddressToConsoleRAM <= std_logic_vector(s_NbProgramBytes(4 downto 2));
  p_WEToConsoleRAM      <= s_WEToConsoleRAM;
  p_DoProgram <= reg_DoProgram;

end RTL;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------
 
