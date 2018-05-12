-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- ConsoleEmulator to connect the PC to the platform
-- It acts as a wishbone master
--
-- NOTES:
--
-- Syntax of the input file
--       WAIT <cycles(dec)>
--       WRITE <ADDRESS(hex)> <DATA(hex)>
--       READ  <ADDRESS(hex)> <EXPECTED_DATA(hex)>   (EXPECTED_DATA = FFFFFFFFFF => don't care)
--       WRITE_ADDRESS <ADDRESS(hex)> <DATA(hex)>
--       READ_ADDRESS  <ADDRESS(hex)> <EXPECTED_DATA(hex)>   (EXPECTED_DATA = FFFFFFFFFF => don't care)
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

library work;
use work.SoCConstantsPackage.all;
use work.WishboneConstantsPackage.all;
use work.ConsoleEmulatorPackage.all;
use work.RegisterMapPackage.all;
-- synopsys translate_off
use work.FileIOUtilsPackage.all;
use work.stringfkt.all;
-- synopsys translate_on

-----------------------------
-- ARCHITECTURE DEFINITION --
-----------------------------
   
architecture RTL of ConsoleEmulator is


  -- REGISTERS
  signal v_FSM_Itf : t_FSM_Itf;
  signal v_FSM_WB  : t_FSM_WB;

  signal s_Command              : t_CommandEmulator;
  signal s_Address              : std_logic_vector(7 downto 0);
  signal s_Data                 : std_logic_vector(7 downto 0);
  signal s_Data32               : std_logic_vector(31 downto 0);
  signal s_Data32Expected       : std_logic_vector(31 downto 0);
  signal s_DataFieldFromUART    : std_logic_vector(7 downto 0);
  signal s_Response             : std_logic_vector(7 downto 0);
  signal s_Received             : std_logic_vector(7 downto 0);

  signal s_ReadByte             : std_logic;        -- Byte read through the UART
  signal s_WBDone               : std_logic;        -- Wishbone transaction achieved

  signal s_WaitCycles : integer:=0;
  signal s_Waiting : std_logic := '0';

  -- FSM

  -- OTHER

  -- DEBUG
  file l_file  : TEXT open read_mode is stimuli_file;
  file p_file  : TEXT;
  file c_file  : TEXT;
  
begin

  p_always: process

    variable v_MyLine          : line;
    variable v_ProgramLineRead : line;
    variable v_command         : t_CommandEmulator := e_NOP;
    variable v_MyCommandString : string(1 to 200);
    variable v_CyclesRead      : integer := 0;
    variable v_WaitCycles      : integer := 0;
    variable v_AddressRead     : integer := 0;
    variable v_Address         : std_logic_vector(7 downto 0);
    variable v_DataRead        : integer := 0;
    variable v_CodeRead        : integer := 0;
    variable v_Data            : std_logic_vector(7 downto 0);
    variable v_Data32          : std_logic_vector(31 downto 0);
    variable v_Data32Expected  : std_logic_vector(31 downto 0);
    variable v_Data32ExpectedString  : string(1 to 8);
    variable v_Data1           : std_logic_vector(7 downto 0);
    variable v_Data2           : std_logic_vector(7 downto 0);
    variable v_Data3           : std_logic_vector(7 downto 0);
    variable v_Data4           : std_logic_vector(7 downto 0);
    variable v_Code1           : std_logic_vector(7 downto 0);
    variable v_Code1_array     : t_CodeBlock;
    variable v_Code2           : std_logic_vector(7 downto 0);
    variable v_Code2_array     : t_CodeBlock;
    variable v_Code3           : std_logic_vector(7 downto 0);
    variable v_Code3_array     : t_CodeBlock;
    variable v_Code4           : std_logic_vector(7 downto 0);
    variable v_Code4_array     : t_CodeBlock;
    variable v_i               : integer := 0;
    variable v_LineNumber      : integer := 0;
    variable v_ButtonNumber    : integer;
    variable v_DifferentThanE3Found : boolean := false;
    variable v_Address32Bits : std_logic_vector(31 downto 0) := (others => '0');

  begin  -- process p_always

    -- Initial state
    ADDR_O    <= (others => '0');
    DAT_O     <= (others => '0');
    SEL_O     <= (others => '0');
    STB_O     <= '0';
    WE_O      <= '0';
    s_Address <= (others => '0');
    s_Data    <= (others => '0');

    p_Buttons <= (others => '0');

    -- Reading loop
    while not endfile(l_file) loop

      -- Read a line from the stimuli file
      readline(l_file, v_MyLine);
      ReadString(v_MyLine,v_MyCommandString);
      v_Command := String2Command(v_MyCommandString);
      s_Command <= v_Command;

--      assert false report "COMMAND : " & v_MyCommandString severity note;

      s_Waiting <= '0';

      -- synopsys translate off
--      assert false report "COMMAND FROM FILE" severity note;
      -- synopsys translate on


      case v_Command is

        when e_WAIT    =>              -- *** WAIT ***

          s_Waiting <= '1';

--          assert false report "Reading CYCLES to wait..." severity note;
          -- We read CYCLES
          ReadHex10(v_MyLine,v_CyclesRead);
          -- synopsys translate off
          assert false report "    COMMAND : e_WAIT" severity note;
          -- synopsys translate on

          -- We put the cycle counter to teh desired value 
          s_WaitCycles <= v_CyclesRead;

          WaitNCycles(v_CyclesRead,CLK_I);
--          assert false report "Waiting done..." severity note;

        when e_BUTTON    =>            -- *** PRESS a button ***

          s_WaitCycles <= 0;
--          assert false report "Reading which button is pressed..." severity note;

          ReadHex1(v_MyLine,v_ButtonNumber);
          ReadSpace(v_MyLine);

          -- We read CYCLES
--          assert false report "Reading number of cycles..." severity note;
          ReadHex10(v_MyLine,v_CyclesRead);

          assert false report "    COMMAND : e_BUTTON | " & " BUTTON    : " & i2s(v_ButtonNumber,2) severity note;

          s_Waiting <= '1';
          p_Buttons(v_ButtonNumber-1) <= '1';
          WaitNCycles(v_CyclesRead,CLK_I);
          p_Buttons(v_ButtonNumber-1) <= '0';
          s_Waiting <= '0';


        when e_WRITE   =>              -- *** WRITE ***

          s_WaitCycles <= 0;

          ReadHex2(v_MyLine,v_AddressRead);
          v_Address := std_logic_vector(to_unsigned(v_AddressRead,8));
          s_Address <= v_Address;
          ReadSpace(v_MyLine);
          ReadHex2(v_MyLine,v_DataRead);
          v_Data    := std_logic_vector(to_unsigned(v_DataRead,8));
          s_Data <= v_data;

          -- synopsys translate off
          assert false report "    COMMAND : e_WRITE | "
            & " ADDRESS : " & slv2hexS(std_logic_vector'(v_Address))
            & " | "
            & " DATA    : " & slv2hexS(std_logic_vector'(v_Data)) severity note;
          -- synopsys translate on

          -- First we write the command
          DAT_O(7 downto 0) <= "00000001" ;  -- WRITE COMMAND
          ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
          SEL_O  <= (others => '0');
          WE_O   <= '1';
          CYC_O  <= '1';
          STB_O  <= '1';
          v_WaitCycles := 1;
          s_Waiting <= '1';
          WaitNCycles(v_WaitCycles,CLK_I);
          s_Waiting <= '0';
          DAT_O  <= (others => '0');
          ADDR_O <= (others => '0');
          WE_O   <= '0';
          CYC_O  <= '0';
          STB_O  <= '0';
          s_Waiting <= '1';
          wait until (rising_edge(p_UARTTxInterrupt));
          s_Waiting <= '0';



          -- First we write the address
          ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
          DAT_O(7 downto 0)  <= v_Address;
          SEL_O  <= (others => '0');
          WE_O   <= '1';
          CYC_O  <= '1';
          STB_O  <= '1';
          v_WaitCycles := 1;
          s_Waiting <= '1';
          WaitNCycles(v_WaitCycles,CLK_I);
          s_Waiting <= '0';
          DAT_O  <= (others => '0');
          ADDR_O <= (others => '0');
          WE_O   <= '0';
          CYC_O  <= '0';
          STB_O  <= '0';
          s_Waiting <= '1';
          wait until (rising_edge(p_UARTTxInterrupt));
          s_Waiting <= '0';

          -- Write the data
          ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
          DAT_O(7 downto 0)  <= v_Data;
          SEL_O  <= (others => '0');
          WE_O   <= '1';
          CYC_O  <= '1';
          STB_O  <= '1';
          v_WaitCycles := 1;
          s_Waiting <= '1';
          WaitNCycles(v_WaitCycles,CLK_I);
          s_Waiting <= '0';
          DAT_O  <= (others => '0');
          ADDR_O <= (others => '0');
          WE_O   <= '0';
          CYC_O  <= '0';
          STB_O  <= '0';
          s_Waiting <= '1';
          wait until (rising_edge(p_UARTTxInterrupt));
          s_Waiting <= '0';

          -- Wait for the response
          wait until (rising_edge(p_UARTRxInterrupt));
          ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_READ,c_WishboneAddrWidth));
          DAT_O(7 downto 0)  <= (others => '0');
          SEL_O  <= (others => '0');
          WE_O   <= '0';
          CYC_O  <= '1';
          STB_O  <= '1';
          v_WaitCycles := 1;
          s_Waiting <= '1';
          WaitNCycles(v_WaitCycles,CLK_I);
          s_Waiting <= '0';
          DAT_O  <= (others => '0');
          ADDR_O <= (others => '0');
          WE_O   <= '0';
          CYC_O  <= '0';
          STB_O  <= '0';

        when e_WRITE_ADDRESS   =>              -- *** WRITE ADDRESS ***

          s_WaitCycles <= 0;

          -- Read the address where to write
          ReadHex8(v_MyLine,v_AddressRead);
          v_Address32Bits := std_logic_vector(to_unsigned(v_AddressRead,32));

          -- Read the space
          ReadSpace(v_MyLine);

          -- Read the data
          ReadHex8(v_MyLine,v_DataRead);
          v_Data32   := std_logic_vector(to_unsigned(v_DataRead,32));
          s_Data32 <= v_data32;

          -- synopsys translate off
          assert false report "    COMMAND : e_WRITE_ADDRESS | "
            & " ADDRESS : " & slv2hexS(std_logic_vector'(v_Address32Bits))
            & " | "
            & " DATA    : " & slv2hexS(std_logic_vector'(v_Data32)) severity note;
          -- synopsys translate on

          proc_SerialWriteAddress( CLK_I,
                                   DAT_O,
                                   ADDR_O,
                                   SEL_O,
                                   WE_O,
                                   CYC_O,
                                   STB_O,
                                   s_Waiting,
                                   p_UARTTxInterrupt,
                                   p_UARTRxInterrupt,
                                   v_Address32Bits,
                                   v_Data32,
                                   v_WaitCycles);

        when e_READ_ADDRESS   =>              -- *** WRITE ADDRESS ***

          s_WaitCycles <= 0;

          -- Read the address where to Read
          ReadHex8(v_MyLine,v_AddressRead);
          v_Address32Bits := std_logic_vector(to_unsigned(v_AddressRead,32));

          -- Read the space
          ReadSpace(v_MyLine);

          -- Read the expected data
          report "reading" severity note;
          --ReadHex8(v_MyLine,v_DataRead);
          ReadHex8AsString(v_MyLine,v_Data32ExpectedString);
          report "read" severity note;
          --v_Data32Expected   := std_logic_vector(to_unsigned(v_DataRead,32));
          --v_Data32ExpectedString   := std_logic_vector(to_unsigned(v_DataRead,32));
          report "converted" severity note;
          --s_Data32Expected <= v_data32Expected;


          proc_SerialReadAddress( CLK_I,
                                  DAT_O,
                                  DAT_I,
                                  ADDR_O,
                                  SEL_O,
                                  WE_O,
                                  CYC_O,
                                  STB_O,
                                  s_Waiting,
                                  p_UARTTxInterrupt,
                                  p_UARTRxInterrupt,
                                  v_Address32Bits,
                                  v_Data32,
                                  v_WaitCycles
                                  );

          -- synopsys translate off
          assert false report "    COMMAND : e_READ_ADDRESS | "
            & " ADDRESS : " & slv2hexS(std_logic_vector'(v_Address32Bits))
            & " | "
            --& " EXPECTED    : " & slv2hexS(std_logic_vector'(v_Data32Expected))
            & " EXPECTED    : " & v_Data32ExpectedString
            & " RECEIVED    : " & slv2hexS(std_logic_vector'(v_Data32))
            severity note;
          -- synopsys translate on

          if (v_Data32ExpectedString /= slv2hexS(std_logic_vector'(v_data32))) then
            assert false report "WRONG CHECK" severity failure;
          end if;

        when e_READ    =>              -- *** READ ***

          s_WaitCycles <= 0;

          ReadHex2(v_MyLine,v_AddressRead);
          v_Address := std_logic_vector(to_unsigned(v_AddressRead,8));
          s_Address <= v_Address;
          ReadSpace(v_MyLine);
          ReadHex2(v_MyLine,v_DataRead);
          v_Data    := std_logic_vector(to_unsigned(v_DataRead,8));
          s_Data <= v_data;

          -- synopsys translate off
          assert false report "    COMMAND : e_READ" severity note;
          assert false report "    ADDRESS : " & slv2hexS(std_logic_vector'(v_Address)) severity note;
          assert false report "    EXPECTED DATA    : " & slv2hexS(std_logic_vector'(v_Data)) severity note;
          -- synopsys translate on

          -- First we write the command
          DAT_O(7 downto 0) <= "00000010" ;  -- READ COMMAND
          ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
          SEL_O  <= (others => '0');
          WE_O   <= '1';
          CYC_O  <= '1';
          STB_O  <= '1';
          v_WaitCycles := 1;
          s_Waiting <= '1';
          WaitNCycles(v_WaitCycles,CLK_I);
          s_Waiting <= '0';
          DAT_O  <= (others => '0');
          ADDR_O <= (others => '0');
          WE_O   <= '0';
          CYC_O  <= '0';
          STB_O  <= '0';
          s_Waiting <= '1';
          wait until (rising_edge(p_UARTTxInterrupt));
          s_Waiting <= '0';

          -- First we write the address
          ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
          DAT_O(7 downto 0)  <= v_Address;
          SEL_O  <= (others => '0');
          WE_O   <= '1';
          CYC_O  <= '1';
          STB_O  <= '1';
          v_WaitCycles := 1;
          s_Waiting <= '1';
          WaitNCycles(v_WaitCycles,CLK_I);
          s_Waiting <= '0';
          DAT_O  <= (others => '0');
          ADDR_O <= (others => '0');
          WE_O   <= '0';
          CYC_O  <= '0';
          STB_O  <= '0';
          s_Waiting <= '1';
          wait until (rising_edge(p_UARTTxInterrupt));
          s_Waiting <= '0';

          -- Wait for the response
          wait until (rising_edge(p_UARTRxInterrupt));
          ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_READ,c_WishboneAddrWidth));
          DAT_O(7 downto 0)  <= (others => '0');
          SEL_O  <= (others => '0');
          WE_O   <= '0';
          CYC_O  <= '1';
          STB_O  <= '1';
          v_WaitCycles := 1;
          s_Waiting <= '1';
          WaitNCycles(v_WaitCycles,CLK_I);
          s_Waiting <= '0';
          DAT_O  <= (others => '0');
          ADDR_O <= (others => '0');
          WE_O   <= '0';
          CYC_O  <= '0';
          STB_O  <= '0';
          assert false report "    RECEIVED DATA    : " & slv2hexS(std_logic_vector'(DAT_I)) severity note;

        when e_CHECK =>              -- *** PROGRAM ***

          assert false report "    COMMAND : e_CHECK" severity note;

          s_WaitCycles <= 0;
          v_LineNumber := 0;

          file_open(c_file,"flash.in",READ_MODE);

          while not endfile(c_file) loop


            -- We need to read groups of 32 bytes
            v_i:= 0;
            v_DifferentThanE3Found := false;

            -- We read a group of 8x32 bits = 32 bytes
            while (v_i < 8) loop

              -- We read a value from the file and after we check it from the FPGA
              assert false report "Reading values from file"     severity note;

              readline(c_file, v_ProgramLineRead);
              ReadHex2(v_ProgramLineRead,v_CodeRead);
              v_Code1 := std_logic_vector(to_unsigned(v_CodeRead,8));
              v_Code1_array(v_i) := std_logic_vector(to_unsigned(v_CodeRead,8));
              ReadHex2(v_ProgramLineRead,v_CodeRead);
              v_Code2 := std_logic_vector(to_unsigned(v_CodeRead,8));
              v_Code2_array(v_i) := std_logic_vector(to_unsigned(v_CodeRead,8));
              ReadHex2(v_ProgramLineRead,v_CodeRead);
              v_Code3 := std_logic_vector(to_unsigned(v_CodeRead,8));
              v_Code3_array(v_i) := std_logic_vector(to_unsigned(v_CodeRead,8));
              ReadHex2(v_ProgramLineRead,v_CodeRead);
              v_Code4 := std_logic_vector(to_unsigned(v_CodeRead,8));
              v_Code4_array(v_i) := std_logic_vector(to_unsigned(v_CodeRead,8));
              assert false report "    CODE1: : " & slv2hexS(std_logic_vector'(v_Code1_array(v_i))) severity note;
              assert false report "    CODE2: : " & slv2hexS(std_logic_vector'(v_Code2_array(v_i))) severity note;
              assert false report "    CODE3: : " & slv2hexS(std_logic_vector'(v_Code3_array(v_i))) severity note;
              assert false report "    CODE4: : " & slv2hexS(std_logic_vector'(v_Code4_array(v_i))) severity note;

              if (to_integer(unsigned(v_Code1)) = 16#3E#)
                and (to_integer(unsigned(v_Code2)) = 16#3E#)
                and (to_integer(unsigned(v_Code3)) = 16#3E#)
                and (to_integer(unsigned(v_Code4)) = 16#3E#)
              then
                v_DifferentThanE3Found := v_DifferentThanE3Found;
              else
                v_DifferentThanE3Found := true;
              end if;
              
              v_i := v_i + 1;

            end loop;

            assert false report "    A block with 32 bytes has been read " severity note;

          
            if (v_DifferentThanE3Found) then

              -- Read the 32 values from the FPGA
              v_i := 0;

              while (v_i < 8) loop

                -- -----------------------------------
                -- First we write the address (4 bytes)
                -- -----------------------------------
                -- Convert the Line number in the 4 bytes of the address
                v_Address32Bits := std_logic_vector(to_unsigned(v_LineNumber,32));

                --> FIRST byte of the address
                assert false report "    READING ADDRESS : " & slv2hexS(std_logic_vector'(v_Address32Bits)) severity note;
                -- First we write the command
                DAT_O(7 downto 0) <= "00000001" ;  -- WRITE COMMAND
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
                SEL_O  <= (others => '0');
                WE_O   <= '1';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                s_Waiting <= '1';
                wait until (rising_edge(p_UARTTxInterrupt));
                s_Waiting <= '0';

                -- First we write the address
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
                DAT_O(7 downto 0)  <= "00000001";  -- Address 0x01 (MSB of the address)
                SEL_O  <= (others => '0');
                WE_O   <= '1';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                s_Waiting <= '1';
                wait until (rising_edge(p_UARTTxInterrupt));
                s_Waiting <= '0';

                -- Write the data
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
                DAT_O(7 downto 0)  <= v_Address32Bits(31 downto 24);
                SEL_O  <= (others => '0');
                WE_O   <= '1';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                s_Waiting <= '1';
                wait until (rising_edge(p_UARTTxInterrupt));
                s_Waiting <= '0';

                -- Wait for the response
                wait until (rising_edge(p_UARTRxInterrupt));
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_READ,c_WishboneAddrWidth));
                DAT_O(7 downto 0)  <= (others => '0');
                SEL_O  <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';

                --> SECOND byte of the address
                -- First we write the command
                DAT_O(7 downto 0) <= "00000001" ;  -- WRITE COMMAND
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
                SEL_O  <= (others => '0');
                WE_O   <= '1';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                s_Waiting <= '1';
                wait until (rising_edge(p_UARTTxInterrupt));
                s_Waiting <= '0';

                -- First we write the address
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
                DAT_O(7 downto 0)  <= "00000010";  -- Address 0x02 
                SEL_O  <= (others => '0');
                WE_O   <= '1';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                s_Waiting <= '1';
                wait until (rising_edge(p_UARTTxInterrupt));
                s_Waiting <= '0';

                -- Write the data
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
                DAT_O(7 downto 0)  <= v_Address32Bits(23 downto 16);
                SEL_O  <= (others => '0');
                WE_O   <= '1';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                s_Waiting <= '1';
                wait until (rising_edge(p_UARTTxInterrupt));
                s_Waiting <= '0';

                -- Wait for the response
                wait until (rising_edge(p_UARTRxInterrupt));
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_READ,c_WishboneAddrWidth));
                DAT_O(7 downto 0)  <= (others => '0');
                SEL_O  <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';

                --> THIRD byte of the address
                -- First we write the command
                DAT_O(7 downto 0) <= "00000001" ;  -- WRITE COMMAND
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
                SEL_O  <= (others => '0');
                WE_O   <= '1';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                s_Waiting <= '1';
                wait until (rising_edge(p_UARTTxInterrupt));
                s_Waiting <= '0';

                -- First we write the address
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
                DAT_O(7 downto 0)  <= "00000011";  -- Address 0x03 
                SEL_O  <= (others => '0');
                WE_O   <= '1';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                s_Waiting <= '1';
                wait until (rising_edge(p_UARTTxInterrupt));
                s_Waiting <= '0';

                -- Write the data
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
                DAT_O(7 downto 0)  <= v_Address32Bits(15 downto 8);
                SEL_O  <= (others => '0');
                WE_O   <= '1';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                s_Waiting <= '1';
                wait until (rising_edge(p_UARTTxInterrupt));
                s_Waiting <= '0';

                -- Wait for the response
                wait until (rising_edge(p_UARTRxInterrupt));
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_READ,c_WishboneAddrWidth));
                DAT_O(7 downto 0)  <= (others => '0');
                SEL_O  <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';

                --> FOURTH byte of the address
                -- First we write the command
                DAT_O(7 downto 0) <= "00000001" ;  -- WRITE COMMAND
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
                SEL_O  <= (others => '0');
                WE_O   <= '1';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                s_Waiting <= '1';
                wait until (rising_edge(p_UARTTxInterrupt));
                s_Waiting <= '0';

                -- First we write the address
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
                DAT_O(7 downto 0)  <= "00000100";  -- Address 0x04 
                SEL_O  <= (others => '0');
                WE_O   <= '1';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                s_Waiting <= '1';
                wait until (rising_edge(p_UARTTxInterrupt));
                s_Waiting <= '0';

                -- Write the data
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
                DAT_O(7 downto 0)  <= v_Address32Bits(7 downto 0);
                SEL_O  <= (others => '0');
                WE_O   <= '1';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                s_Waiting <= '1';
                wait until (rising_edge(p_UARTTxInterrupt));
                s_Waiting <= '0';

                -- Wait for the response
                wait until (rising_edge(p_UARTRxInterrupt));
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_READ,c_WishboneAddrWidth));
                DAT_O(7 downto 0)  <= (others => '0');
                SEL_O  <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';

                -- -----------------------------------------------------------
                -- Then we force a READ command to copy the results to console
                -- -----------------------------------------------------------

                --> FOURTH byte of the address
                -- First we write the command
                DAT_O(7 downto 0) <= "00000001" ;  -- WRITE COMMAND
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
                SEL_O  <= (others => '0');
                WE_O   <= '1';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                s_Waiting <= '1';
                wait until (rising_edge(p_UARTTxInterrupt));
                s_Waiting <= '0';

                -- First we write the address
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
                DAT_O(7 downto 0)  <= "00000000";  -- COMMAND address
                SEL_O  <= (others => '0');
                WE_O   <= '1';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                s_Waiting <= '1';
                wait until (rising_edge(p_UARTTxInterrupt));
                s_Waiting <= '0';

                -- Write the data
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
                DAT_O(7 downto 0)  <= "00000010";  -- READ COMMAND
                SEL_O  <= (others => '0');
                WE_O   <= '1';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                s_Waiting <= '1';
                wait until (rising_edge(p_UARTTxInterrupt));
                s_Waiting <= '0';

                -- Wait for the response
                wait until (rising_edge(p_UARTRxInterrupt));
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_READ,c_WishboneAddrWidth));
                DAT_O(7 downto 0)  <= (others => '0');
                SEL_O  <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';

                -- -------------------------------------------
                -- And then we READ the data registers 4 bytes
                -- -------------------------------------------

                --> We read the FIRST byte of the data
                -- First we write the command
                DAT_O(7 downto 0) <= "00000010" ;  -- READ COMMAND
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
                SEL_O  <= (others => '0');
                WE_O   <= '1';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                s_Waiting <= '1';
                wait until (rising_edge(p_UARTTxInterrupt));
                s_Waiting <= '0';

                -- First we write the address
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
                DAT_O(7 downto 0)  <= "00000101";  -- Address 0x05 (MSB of the data)
                SEL_O  <= (others => '0');
                WE_O   <= '1';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                s_Waiting <= '1';
                wait until (rising_edge(p_UARTTxInterrupt));
                s_Waiting <= '0';

                -- Wait for the response
                wait until (rising_edge(p_UARTRxInterrupt));
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_READ,c_WishboneAddrWidth));
                DAT_O(7 downto 0)  <= (others => '0');
                SEL_O  <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                v_Data1 := DAT_I(7 downto 0);
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';

                --> We read the SECOND byte of the data
                -- First we write the command
                DAT_O(7 downto 0) <= "00000010" ;  -- READ COMMAND
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
                SEL_O  <= (others => '0');
                WE_O   <= '1';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                s_Waiting <= '1';
                wait until (rising_edge(p_UARTTxInterrupt));
                s_Waiting <= '0';

                -- First we write the address
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
                DAT_O(7 downto 0)  <= "00000110";  -- Address 0x06
                SEL_O  <= (others => '0');
                WE_O   <= '1';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                s_Waiting <= '1';
                wait until (rising_edge(p_UARTTxInterrupt));
                s_Waiting <= '0';

                -- Wait for the response
                wait until (rising_edge(p_UARTRxInterrupt));
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_READ,c_WishboneAddrWidth));
                DAT_O(7 downto 0)  <= (others => '0');
                SEL_O  <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                v_Data2 := DAT_I(7 downto 0);
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';

                --> We read the THIRD byte of the data
                -- First we write the command
                DAT_O(7 downto 0) <= "00000010" ;  -- READ COMMAND
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
                SEL_O  <= (others => '0');
                WE_O   <= '1';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                s_Waiting <= '1';
                wait until (rising_edge(p_UARTTxInterrupt));
                s_Waiting <= '0';

                -- First we write the address
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
                DAT_O(7 downto 0)  <= "00000111";  -- Address 0x07
                SEL_O  <= (others => '0');
                WE_O   <= '1';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                s_Waiting <= '1';
                wait until (rising_edge(p_UARTTxInterrupt));
                s_Waiting <= '0';

                -- Wait for the response
                wait until (rising_edge(p_UARTRxInterrupt));
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_READ,c_WishboneAddrWidth));
                DAT_O(7 downto 0)  <= (others => '0');
                SEL_O  <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                v_Data3 := DAT_I(7 downto 0);
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';

                --> We read the FOURTH byte of the data
                -- First we write the command
                DAT_O(7 downto 0) <= "00000010" ;  -- READ COMMAND
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
                SEL_O  <= (others => '0');
                WE_O   <= '1';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                s_Waiting <= '1';
                wait until (rising_edge(p_UARTTxInterrupt));
                s_Waiting <= '0';

                -- First we write the address
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
                DAT_O(7 downto 0)  <= "00001000";  -- Address 0x08
                SEL_O  <= (others => '0');
                WE_O   <= '1';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                s_Waiting <= '1';
                wait until (rising_edge(p_UARTTxInterrupt));
                s_Waiting <= '0';

                -- Wait for the response
                wait until (rising_edge(p_UARTRxInterrupt));
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_READ,c_WishboneAddrWidth));
                DAT_O(7 downto 0)  <= (others => '0');
                SEL_O  <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                v_Data4 := DAT_I(7 downto 0);
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';

                assert false report "    DATA READ :"
                  & " " & slv2hexS(std_logic_vector'(v_Data1))
                  & " " & slv2hexS(std_logic_vector'(v_Data2))
                  & " " & slv2hexS(std_logic_vector'(v_Data3))
                  & " " & slv2hexS(std_logic_vector'(v_Data4))
                  severity note;
                assert false report "    DATA EXPECTED :"
                  & " " & slv2hexS(std_logic_vector'(v_Code1_array(v_i)))
                  & " " & slv2hexS(std_logic_vector'(v_Code2_array(v_i)))
                  & " " & slv2hexS(std_logic_vector'(v_Code3_array(v_i)))
                  & " " & slv2hexS(std_logic_vector'(v_Code4_array(v_i)))
                  severity note;


                -- -----------------------------------------------------
                -- We compare the received value with the expected value
                -- -----------------------------------------------------


                -- Update counters
                v_i := v_i + 1;
                v_LineNumber := v_LineNumber + 1;

              end loop;

            end if;

          end loop;

          file_close(c_file);

        when e_PROGRAM_FLASH =>              -- *** PROGRAM ***

          s_WaitCycles <= 0;

          -- Now we iterate through the file to send the data

          file_open(p_file,"flash.load",READ_MODE);
          
          while not endfile(p_file) loop

            -- We need to read groups of 32 bytes
            v_i:= 0;
            v_DifferentThanE3Found := false;

            -- We read a group of 8x32 bits = 32 bytes
            while (v_i < 8) loop
                  
              readline(p_file, v_ProgramLineRead);
              ReadHex2(v_ProgramLineRead,v_CodeRead);
              v_Code1 := std_logic_vector(to_unsigned(v_CodeRead,8));
              v_Code1_array(v_i) := std_logic_vector(to_unsigned(v_CodeRead,8));
              ReadHex2(v_ProgramLineRead,v_CodeRead);
              v_Code2 := std_logic_vector(to_unsigned(v_CodeRead,8));
              v_Code2_array(v_i) := std_logic_vector(to_unsigned(v_CodeRead,8));
              ReadHex2(v_ProgramLineRead,v_CodeRead);
              v_Code3 := std_logic_vector(to_unsigned(v_CodeRead,8));
              v_Code3_array(v_i) := std_logic_vector(to_unsigned(v_CodeRead,8));
              ReadHex2(v_ProgramLineRead,v_CodeRead);
              v_Code4 := std_logic_vector(to_unsigned(v_CodeRead,8));
              v_Code4_array(v_i) := std_logic_vector(to_unsigned(v_CodeRead,8));

              if (to_integer(unsigned(v_Code1)) = 16#3E#)
                and (to_integer(unsigned(v_Code2)) = 16#3E#)
                and (to_integer(unsigned(v_Code3)) = 16#3E#)
                and (to_integer(unsigned(v_Code4)) = 16#3E#)
              then
                v_DifferentThanE3Found := v_DifferentThanE3Found;
              else
                v_DifferentThanE3Found := true;
              end if;
              
              v_i := v_i + 1;

            end loop;

            if (v_DifferentThanE3Found) then
              

              v_i:= 0;
              
              -- If the group was correct (different from "all E3") we send
              -- it through the UART
              while (v_i < 8) loop

                -- First we need to enter in program mode (we send a command e_PROGRAM_FLASH
                assert false report "    COMMAND : e_PROGRAM_FLASH (" & i2s(v_i,3) & ")" severity note;
                DAT_O(7 downto 0) <= "00000011" ;  -- PROGRAM COMMAND
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
                SEL_O  <= (others => '0');
                WE_O   <= '1';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                s_Waiting <= '1';
                wait until (rising_edge(p_UARTTxInterrupt));
                s_Waiting <= '0';

                assert false report "    CODE1: : " & slv2hexS(std_logic_vector'(v_Code1_array(v_i))) severity note;
                DAT_O(7 downto 0) <=  v_Code1_array(v_i);  -- MSB
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
                SEL_O  <= (others => '0');
                WE_O   <= '1';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                s_Waiting <= '1';
                wait until (rising_edge(p_UARTTxInterrupt));
                s_Waiting <= '0';

                -- We wait for an answer from the circuit
                s_Waiting <= '1';
                assert false report "Waiting for the confirmation of a CODE"     severity note;
                wait until (rising_edge(p_UARTRxInterrupt));
                s_Waiting <= '0';
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_READ,c_WishboneAddrWidth));
                DAT_O(7 downto 0)  <= (others => '0');
                SEL_O  <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                assert false report "    CODE RX: " & slv2hexS(std_logic_vector'(DAT_I)) severity note;

                assert false report "    CODE2: : " & slv2hexS(std_logic_vector'(v_Code2_array(v_i))) severity note;
                DAT_O(7 downto 0) <=  v_Code2_array(v_i); 
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
                SEL_O  <= (others => '0');
                WE_O   <= '1';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                s_Waiting <= '1';
                wait until (rising_edge(p_UARTTxInterrupt));
                s_Waiting <= '0';
                -- We wait for an answer from the circuit
                s_Waiting <= '1';
                assert false report "Waiting for the confirmation of a CODE"     severity note;
                wait until (rising_edge(p_UARTRxInterrupt));
                s_Waiting <= '0';
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_READ,c_WishboneAddrWidth));
                DAT_O(7 downto 0)  <= (others => '0');
                SEL_O  <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                assert false report "    CODE RX: " & slv2hexS(std_logic_vector'(DAT_I)) severity note;
                
                assert false report "    CODE3: : " & slv2hexS(std_logic_vector'(v_Code3_array(v_i))) severity note;
                DAT_O(7 downto 0) <=  v_Code3_array(v_i);  -- MSB
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
                SEL_O  <= (others => '0');
                WE_O   <= '1';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                s_Waiting <= '1';
                wait until (rising_edge(p_UARTTxInterrupt));
                s_Waiting <= '0';
                -- We wait for an answer from the circuit

              s_Waiting <= '1';
                assert false report "Waiting for the confirmation of a CODE"     severity note;
                wait until (rising_edge(p_UARTRxInterrupt));
                s_Waiting <= '0';
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_READ,c_WishboneAddrWidth));
                DAT_O(7 downto 0)  <= (others => '0');
                SEL_O  <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                assert false report "    CODE RX: " & slv2hexS(std_logic_vector'(DAT_I)) severity note;
              
                assert false report "    CODE4: : " & slv2hexS(std_logic_vector'(v_Code4_array(v_i))) severity note;
                DAT_O(7 downto 0) <=  v_Code4_array(v_i);  -- MSB
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
                SEL_O  <= (others => '0');
                WE_O   <= '1';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                s_Waiting <= '1';
                wait until (rising_edge(p_UARTTxInterrupt));
                s_Waiting <= '0';

                -- We wait for an answer from the circuit
              s_Waiting <= '1';
                assert false report "Waiting for the confirmation of a CODE"     severity note;
                wait until (rising_edge(p_UARTRxInterrupt));
                s_Waiting <= '0';
                ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_READ,c_WishboneAddrWidth));
                DAT_O(7 downto 0)  <= (others => '0');
                SEL_O  <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '1';
                STB_O  <= '1';
                v_WaitCycles := 1;
                s_Waiting <= '1';
                WaitNCycles(v_WaitCycles,CLK_I);
                s_Waiting <= '0';
                DAT_O  <= (others => '0');
                ADDR_O <= (others => '0');
                WE_O   <= '0';
                CYC_O  <= '0';
                STB_O  <= '0';
                assert false report "    CODE RX: " & slv2hexS(std_logic_vector'(DAT_I)) severity note;
              
                v_i := v_i + 1;
                
              end loop;
            
              assert false report "Sending WRITE command to the console"     severity note;
              -- console RAM to flash
              DAT_O(7 downto 0) <= "00000100" ;  -- WRITE
              ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
              SEL_O  <= (others => '0');
              WE_O   <= '1';
              CYC_O  <= '1';
              STB_O  <= '1';
              v_WaitCycles := 1;
              s_Waiting <= '1';
              WaitNCycles(v_WaitCycles,CLK_I);
              s_Waiting <= '0';
              DAT_O  <= (others => '0');
              ADDR_O <= (others => '0');
              WE_O   <= '0';
              CYC_O  <= '0';
              STB_O  <= '0';
              s_Waiting <= '1';
              wait until (rising_edge(p_UARTTxInterrupt));
              s_Waiting <= '0';
            
              -- We wait for a confirmation of the writing
              s_Waiting <= '1';
              assert false report "Waiting for the confirmation of the writing"     severity note;
              wait until (rising_edge(p_UARTRxInterrupt));
              s_Waiting <= '0';
              ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_READ,c_WishboneAddrWidth));
              DAT_O(7 downto 0)  <= (others => '0');
              SEL_O  <= (others => '0');
              WE_O   <= '0';
              CYC_O  <= '1';
              STB_O  <= '1';
              v_WaitCycles := 1;
              s_Waiting <= '1';
              WaitNCycles(v_WaitCycles,CLK_I);
              s_Waiting <= '0';
              DAT_O  <= (others => '0');
              ADDR_O <= (others => '0');
              WE_O   <= '0';
              CYC_O  <= '0';
              STB_O  <= '0';
              assert false report "    RECEIVED DATA    : " & slv2hexS(std_logic_vector'(DAT_I)) severity note;

            end if;
            
          end loop;

          file_close(p_file);


        when others => null;

      end case;

      
    end loop;

    wait;

    assert false report "Reading line finished" severity note;
    
  end process p_always;

        

end RTL;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------
 
