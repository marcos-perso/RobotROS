-------------------------------------------------------------------------------
-- DESCRIPTION: 
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
use work.FileIOUtilsPackage.all;
use work.SoCConstantsPackage.all;
use work.RegisterMapPackage.all;
use work.WishboneConstantsPackage.all;
use work.stringfkt.all;

----------------------------------
-- COMPONENT PACKAGE DEFINITION --
----------------------------------

package body ConsoleEmulatorPackage is

  -------------------------------
  -- PROCEDURE to wait N cycles
  -------------------------------
  procedure WaitNCycles (

    variable NbCycles : in integer;
    signal   CLK_I    : in std_logic) is

  begin

    for i in 0 to NbCycles-1 loop

      wait until (CLK_I'event and CLK_I='1');
      
    end loop;  -- i

  end WaitNCycles;

  ------------------------------------------------
  -- FUNCTION to convert a string into a command
  ------------------------------------------------
  function String2Command(string_in: string) return t_CommandEmulator is

    variable tmp : t_CommandEmulator;

  begin

    tmp := e_NOP;

--    assert false report string_in severity note;

    -- TBD: Note that the commands have to be in increasign order... otherwise
    -- it will not work. this has to be corrected (no repetitions of a name)

    if (string_in(1 to 4) = "WAIT") then
      tmp := e_WAIT;
    end if;
    if (string_in(1 to 4) = "READ") then
      tmp := e_READ;
    end if;
    if (string_in(1 to 5) = "WRITE") then
      tmp := e_WRITE;
    end if;
    if (string_in(1 to 6) = "BUTTON") then
      tmp := e_BUTTON;
    end if;
    if (string_in(1 to 13) = "WRITE_ADDRESS") then
      tmp := e_WRITE_ADDRESS;
    end if;
    if (string_in(1 to 12) = "READ_ADDRESS") then
      tmp := e_READ_ADDRESS;
    end if;
    if (string_in(1 to 7) = "PROGRAM") then
      tmp := e_PROGRAM_FLASH;
    end if;
    if (string_in(1 to 5) = "CHECK") then
      tmp := e_CHECK;
    end if;

    return tmp;

  end function;

  -----------------------------------------------------------------------------
  -- Procedure to launch a Write Address transaction over the Serial interface
  -----------------------------------------------------------------------------
  procedure proc_SerialWriteAddress (
    signal CLK_I             : in    std_logic;
    signal DAT_O             : out   std_logic_vector(c_WishboneDataWidth -1 downto 0);
    signal ADDR_O            : out   std_logic_vector(c_WishboneAddrWidth -1 downto 0);
    signal SEL_O             : out   std_logic_vector(c_WishboneSelWidth -1 downto 0);
    signal WE_O              : out   std_logic;
    signal CYC_O             : out   std_logic;
    signal STB_O             : out   std_logic;
    signal s_Waiting         : out   std_logic;
    signal s_TxInterrupt     : in    std_logic;
    signal s_RxInterrupt     : in    std_logic;
    variable v_Address32Bits : in    std_logic_vector(31 downto 0);
    variable v_Data32Bits    : in    std_logic_vector(31 downto 0);
    variable v_WaitCycles    : inout integer

    ) is

    variable v_Reg :  integer;
    variable v_Data : std_logic_vector(7 downto 0);

    begin

      -- ADDRESS 1
      v_Reg := 1;
      v_Data := v_Address32Bits(31 downto 24);
      --assert false report "Writing ADDRESS 1" severity note;
      proc_SerialWriteRegister( CLK_I, DAT_O, ADDR_O, SEL_O, WE_O, CYC_O, STB_O,
                                s_Waiting, s_TxInterrupt, s_RxInterrupt,
                                v_Reg, v_Data,
                                v_WaitCycles);

      -- ADDRESS 2
      v_Reg := 2;
      v_Data := v_Address32Bits(23 downto 16);
      --assert false report "Writing ADDRESS 2" severity note;
      proc_SerialWriteRegister( CLK_I, DAT_O, ADDR_O, SEL_O, WE_O, CYC_O, STB_O,
                                s_Waiting, s_TxInterrupt, s_RxInterrupt,
                                v_Reg, v_Data,
                                v_WaitCycles);

      -- ADDRESS 3
      v_Reg := 3;
      v_Data := v_Address32Bits(15 downto 8);
      --assert false report "Writing ADDRESS 3" severity note;
      proc_SerialWriteRegister( CLK_I, DAT_O, ADDR_O, SEL_O, WE_O, CYC_O, STB_O,
                                s_Waiting, s_TxInterrupt, s_RxInterrupt,
                                v_Reg, v_Data,
                                v_WaitCycles);

      -- ADDRESS 4
      v_Reg := 4;
      v_Data := v_Address32Bits(7 downto 0);
      --assert false report "Writing ADDRESS 4" severity note;
      proc_SerialWriteRegister( CLK_I, DAT_O, ADDR_O, SEL_O, WE_O, CYC_O, STB_O,
                                s_Waiting, s_TxInterrupt, s_RxInterrupt,
                                v_Reg, v_Data,
                                v_WaitCycles);

      -- DATA 1
      v_Reg := 5;
      v_Data := v_Data32Bits(31 downto 24);
      --assert false report "Writing DATA 1" severity note;
      proc_SerialWriteRegister( CLK_I, DAT_O, ADDR_O, SEL_O, WE_O, CYC_O, STB_O,
                                s_Waiting, s_TxInterrupt, s_RxInterrupt,
                                v_Reg, v_Data,
                                v_WaitCycles);
      -- DATA 2
      v_Reg := 6;
      v_Data := v_Data32Bits(23 downto 16);
      --assert false report "Writing DATA 2" severity note;
      proc_SerialWriteRegister( CLK_I, DAT_O, ADDR_O, SEL_O, WE_O, CYC_O, STB_O,
                                s_Waiting, s_TxInterrupt, s_RxInterrupt,
                                v_Reg, v_Data,
                                v_WaitCycles);

      -- DATA 3
      v_Reg := 7;
      v_Data := v_Data32Bits(15 downto 8);
      --assert false report "Writing DATA 3" severity note;
      proc_SerialWriteRegister( CLK_I, DAT_O, ADDR_O, SEL_O, WE_O, CYC_O, STB_O,
                                s_Waiting, s_TxInterrupt, s_RxInterrupt,
                                v_Reg, v_Data,
                                v_WaitCycles);
      -- DATA 4
      v_Reg := 8;
      v_Data := v_Data32Bits(7 downto 0);
      --assert false report "Writing DATA 4" severity note;
      proc_SerialWriteRegister( CLK_I, DAT_O, ADDR_O, SEL_O, WE_O, CYC_O, STB_O,
                                s_Waiting, s_TxInterrupt, s_RxInterrupt,
                                v_Reg, v_Data,
                                v_WaitCycles);

      -- WRITE a Write command
      v_Reg := 0;
      v_Data := "00000001";
      --assert false report "Writing COMMAND" severity note;
      proc_SerialWriteRegister( CLK_I, DAT_O, ADDR_O, SEL_O, WE_O, CYC_O, STB_O,
                                s_Waiting, s_TxInterrupt, s_RxInterrupt,
                                v_Reg, v_Data,
                                v_WaitCycles);

  end proc_SerialWriteAddress;

  -----------------------------------------------------------------------------
  -- Procedure to launch a Read Address transaction over the Serial interface
  -----------------------------------------------------------------------------
  procedure proc_SerialReadAddress (
    signal CLK_I             : in    std_logic;
    signal DAT_O             : out   std_logic_vector(c_WishboneDataWidth -1 downto 0);
    signal DAT_I             : in   std_logic_vector(c_WishboneDataWidth -1 downto 0);
    signal ADDR_O            : out   std_logic_vector(c_WishboneAddrWidth -1 downto 0);
    signal SEL_O             : out   std_logic_vector(c_WishboneSelWidth -1 downto 0);
    signal WE_O              : out   std_logic;
    signal CYC_O             : out   std_logic;
    signal STB_O             : out   std_logic;
    signal s_Waiting         : out   std_logic;
    signal s_TxInterrupt     : in    std_logic;
    signal s_RxInterrupt     : in    std_logic;
    variable v_Address32Bits : in    std_logic_vector(31 downto 0);
    variable v_Data32Bits    : out    std_logic_vector(31 downto 0);
    variable v_WaitCycles    : inout integer

    ) is

    variable v_Reg :  integer;
    variable v_Data : std_logic_vector(7 downto 0);

    begin

      -- ADDRESS 1
      v_Reg := 1;
      v_Data := v_Address32Bits(31 downto 24);
--      assert false report "Writing ADDRESS 1" severity note;
      proc_SerialWriteRegister( CLK_I, DAT_O, ADDR_O, SEL_O, WE_O, CYC_O, STB_O,
                                s_Waiting, s_TxInterrupt, s_RxInterrupt,
                                v_Reg, v_Data,
                                v_WaitCycles);

      -- ADDRESS 2
      v_Reg := 2;
      v_Data := v_Address32Bits(23 downto 16);
--      assert false report "Writing ADDRESS 2" severity note;
      proc_SerialWriteRegister( CLK_I, DAT_O, ADDR_O, SEL_O, WE_O, CYC_O, STB_O,
                                s_Waiting, s_TxInterrupt, s_RxInterrupt,
                                v_Reg, v_Data,
                                v_WaitCycles);

      -- ADDRESS 3
      v_Reg := 3;
      v_Data := v_Address32Bits(15 downto 8);
--      assert false report "Writing ADDRESS 3" severity note;
      proc_SerialWriteRegister( CLK_I, DAT_O, ADDR_O, SEL_O, WE_O, CYC_O, STB_O,
                                s_Waiting, s_TxInterrupt, s_RxInterrupt,
                                v_Reg, v_Data,
                                v_WaitCycles);

      -- ADDRESS 4
      v_Reg := 4;
      v_Data := v_Address32Bits(7 downto 0);
--      assert false report "Writing ADDRESS 4" severity note;
      proc_SerialWriteRegister( CLK_I, DAT_O, ADDR_O, SEL_O, WE_O, CYC_O, STB_O,
                                s_Waiting, s_TxInterrupt, s_RxInterrupt,
                                v_Reg, v_Data,
                                v_WaitCycles);


      -- WRITE a Read command
      v_Reg := 0;
      v_Data := "00000010";
--      assert false report "Reading COMMAND" severity note;
      proc_SerialWriteRegister( CLK_I, DAT_O, ADDR_O, SEL_O, WE_O, CYC_O, STB_O,
                                s_Waiting, s_TxInterrupt, s_RxInterrupt,
                                v_Reg, v_Data,
                                v_WaitCycles);

      -- DATA 1
      v_Reg := 5;
--      assert false report "Reading DATA 1" severity note;
      proc_SerialReadRegister( CLK_I, DAT_O, DAT_I, ADDR_O, SEL_O, WE_O, CYC_O, STB_O,
                               s_Waiting, s_TxInterrupt, s_RxInterrupt,
                               v_Reg, v_Data,
                               v_WaitCycles
                               );
      v_Data32Bits(31 downto 24) := v_Data;

      -- DATA 2
      v_Reg := 6;
--      assert false report "Reading DATA 2" severity note;
      proc_SerialReadRegister( CLK_I, DAT_O, DAT_I, ADDR_O, SEL_O, WE_O, CYC_O, STB_O,
                               s_Waiting, s_TxInterrupt, s_RxInterrupt,
                               v_Reg, v_Data,
                               v_WaitCycles
                               );
      v_Data32Bits(23 downto 16) := v_Data;

      -- DATA 3
      v_Reg := 7;
--      assert false report "Reading DATA 3" severity note;
      proc_SerialReadRegister( CLK_I, DAT_O,DAT_I, ADDR_O, SEL_O, WE_O, CYC_O, STB_O,
                               s_Waiting, s_TxInterrupt, s_RxInterrupt,
                               v_Reg, v_Data,
                               v_WaitCycles
                               );
      v_Data32Bits(15 downto 8) := v_Data;
      -- DATA 4
      v_Reg := 8;
--      assert false report "Reading DATA 4" severity note;
      proc_SerialReadRegister( CLK_I, DAT_O,DAT_I, ADDR_O, SEL_O, WE_O, CYC_O, STB_O,
                               s_Waiting, s_TxInterrupt, s_RxInterrupt,
                               v_Reg, v_Data,
                               v_WaitCycles
                               );
      v_Data32Bits(7 downto 0) := v_Data;

  end proc_SerialReadAddress;

  -----------------------------------------------------------------------------
  -- Procedure to launch a Write Register transaction over the Serial interface
  -----------------------------------------------------------------------------
  procedure proc_SerialWriteRegister (
    signal CLK_I             : in    std_logic;
    signal DAT_O             : out   std_logic_vector(c_WishboneDataWidth -1 downto 0);
    signal ADDR_O            : out   std_logic_vector(c_WishboneAddrWidth -1 downto 0);
    signal SEL_O             : out   std_logic_vector(c_WishboneSelWidth -1 downto 0);
    signal WE_O              : out   std_logic;
    signal CYC_O             : out   std_logic;
    signal STB_O             : out   std_logic;
    signal s_Waiting         : out   std_logic;
    signal s_TxInterrupt     : in    std_logic;
    signal s_RxInterrupt     : in    std_logic;
    variable v_Register      : in    integer;
    variable v_Data          : in    std_logic_vector(7 downto 0);
    variable v_WaitCycles    : inout integer

    ) is

    begin

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
      wait until (rising_edge(s_TxInterrupt));
      s_Waiting <= '0';
      
      -- We write the address
      ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
      DAT_O(7 downto 0)  <= std_logic_vector(to_unsigned(v_Register,8));      -- LSB
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
      wait until (rising_edge(s_TxInterrupt));
      s_Waiting <= '0';
      
      -- Write the data
      ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
      DAT_O(7 downto 0)  <= v_Data(7 downto 0);
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
      wait until (rising_edge(s_TxInterrupt));
      s_Waiting <= '0';
      
      -- Wait for the response
      wait until (rising_edge(s_RxInterrupt));
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

  end proc_SerialWriteRegister;

  -----------------------------------------------------------------------------
  -- Procedure to launch a Read Register transaction over the Serial interface
  -----------------------------------------------------------------------------
  procedure proc_SerialReadRegister (
    signal CLK_I             : in    std_logic;
    signal DAT_O             : out   std_logic_vector(c_WishboneDataWidth -1 downto 0);
    signal DAT_I             : in   std_logic_vector(c_WishboneDataWidth -1 downto 0);
    signal ADDR_O            : out   std_logic_vector(c_WishboneAddrWidth -1 downto 0);
    signal SEL_O             : out   std_logic_vector(c_WishboneSelWidth -1 downto 0);
    signal WE_O              : out   std_logic;
    signal CYC_O             : out   std_logic;
    signal STB_O             : out   std_logic;
    signal s_Waiting         : out   std_logic;
    signal s_TxInterrupt     : in    std_logic;
    signal s_RxInterrupt     : in    std_logic;
    variable v_Register      : in    integer;
    variable v_Data          : out    std_logic_vector(7 downto 0);
    variable v_WaitCycles    : inout integer

    ) is

    begin

      -- First we write the command
      DAT_O(7 downto 0) <= "00000010" ;  -- WRITE COMMAND
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
      wait until (rising_edge(s_TxInterrupt));
      s_Waiting <= '0';
      
      -- We write the address
      ADDR_O <= std_logic_vector(to_unsigned(c_MINUART_WRITE,c_WishboneAddrWidth));
      DAT_O(7 downto 0)  <= std_logic_vector(to_unsigned(v_Register,8));      -- LSB
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
      wait until (rising_edge(s_TxInterrupt));
      s_Waiting <= '0';
      
      -- Wait for the response
      wait until (rising_edge(s_RxInterrupt));
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

      v_Data := DAT_I(7 downto 0);

      assert false report "    RECEIVED DATA    : " & slv2hexS(std_logic_vector'(DAT_I)) severity note;

  end proc_SerialReadRegister;

end ConsoleEmulatorPackage;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------
   
