-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- 
-- Flash memory wrapper to connect the memory to wishbone system
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
use work.FlashWrapperPackage.all;
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
 
architecture RTL of FlashWrapper is


  -- CONSTANTS DEFINITION --

  -- SIGNAL DEFINITION --
  signal reg_ACK : std_logic;
  signal s_CENeg : std_logic;
  signal s_OENeg : std_logic;
  signal s_WENeg : std_logic;
  signal reg_CENeg : std_logic;
  signal reg_OENeg : std_logic;
  signal reg_WENeg : std_logic;
  signal s_InDataInv : std_logic_vector(15 downto 0);
  signal reg_DataFromMem : std_logic_vector(31 downto 0);
  signal s_SelectedByte : std_logic;
  signal s_FSM : t_FlashFSM;

  signal Debug : std_logic_vector(7 downto 0);

  signal s_ACK_O  : std_logic;                                       -- Acknowdledge
  signal s_ADDR_I : std_logic_vector(c_WishboneAddrWidth - 1 downto 0);
  signal s_DAT_I  : std_logic_vector(c_WishboneDataWidth - 1 downto 0); -- Data Input
  signal s_DAT_O  : std_logic_vector(c_WishboneDataWidth - 1 downto 0); -- Data Output
  signal s_STB_I  : std_logic;                                       -- Strobe In
  signal s_WE_I  : std_logic;                                       -- Write Enable
  

  -- DEBUG
-- synopsys translate_off
  file l_file : TEXT open write_mode is log_file;
-- synopsys translate_on

  -- ARCHITECTURE --

begin

  -- purpose: Adapt to the real memory
  -- type   : sequential
  p_register: process (CLK_I, RST_I)
  begin  -- process p_register
    if RST_I = '1' then                 -- asynchronous reset (active high)

      reg_ACK <= '0';
      s_FSM   <= e_Idle;
      reg_OENeg <= '1';
      reg_WENeg <= '1';
      reg_CENeg <= '1';
      s_SelectedByte <= '0';
      reg_DataFromMem <= (others => '0');
      Debug <= (others => '0');
      
    elsif CLK_I'event and CLK_I = '1' then  -- rising clock edge

      case s_FSM is

        -- IDLE case. We wait for a request
        when e_Idle =>

          Debug <= "00000000";

          reg_ACK <= '0';
          s_SelectedByte <= '0';

          if (s_STB_I = '1') and (reg_ACK = '0') then

            -- If Strobe in is activated, treat the data
            if (to_integer(unsigned(s_ADDR_I)) <= (base_address + C_FLASH_MAX_OFFSET)) then

        
              if (s_WE_I = '0') then
                -- Read operation
                -- synopsys translate_off
                print(l_file,time'image(now) & string'(" ") & string'("READ: ADDRESS = ") & slv2hexS(std_logic_vector'(s_ADDR_I)) );
--                assert false report "Reading in FLASH Memory: " & slv2hexS(std_logic_vector'(DAT_I)) severity note;
                -- synopsys translate_on

                s_FSM <= e_ReadState1;

              else -- WRITE

                -- synopsys translate off
                print(l_file,time'image(now) & string'(" ") & string'("WRITE: ADDRESS = ") & slv2hexS(std_logic_vector'(s_ADDR_I)) & string'("DATA = x") & slv2hexS(std_logic_vector'(s_DAT_I)));
--              assert false report "Writing in FLASH memory not possible!!!" severity note;
                -- synopsys translate on

              end if;

            end if;


          end if;

        when e_ReadState1 =>
          Debug <= "00000001";

          reg_OENeg <= '1';
          reg_WENeg <= '1';
          reg_CENeg <= '0';
          s_FSM <= e_ReadState2;

        when e_ReadState2 =>
          Debug <= "00000010";

          reg_WENeg <= '1';
          reg_OENeg <= '0';
          s_FSM <= e_ReadState3;

        when e_ReadState3 =>
          Debug <= "00000011";

          reg_WENeg <= '1';
          reg_OENeg <= '0';
          s_FSM <= e_ReadState4;

        when e_ReadState4 =>
          Debug <= "00000100";

          reg_OENeg <= '1';
          reg_WENeg <= '1';
          reg_CENeg <= '1';
          s_FSM <= e_ReadState2ndByte1;
          s_SelectedByte <= '1';
          reg_DataFromMem(15 downto 0) <= i_DataFromMem;

        when e_ReadState2ndByte1 =>
          Debug <= "00000101";

          reg_OENeg <= '1';
          reg_WENeg <= '1';
          reg_CENeg <= '0';
          s_FSM <= e_ReadState2ndByte2;

        when e_ReadState2ndByte2 =>
          Debug <= "00000110";

          reg_WENeg <= '1';
          reg_OENeg <= '0';
          s_FSM <= e_ReadState2ndByte3;

        when e_ReadState2ndByte3 =>
          Debug <= "00000111";

          reg_WENeg <= '1';
          reg_OENeg <= '0';
          s_FSM <= e_ReadState2ndByte4;
          --reg_DataFromMem(31 downto 16) <= i_DataFromMem;
          reg_ACK <= '0';

        when e_ReadState2ndByte4 =>
          Debug <= "00001000";

          reg_OENeg <= '1';
          reg_WENeg <= '1';
          reg_CENeg <= '1';
          s_FSM <= e_Idle;
          s_SelectedByte <= '0';
          reg_DataFromMem(31 downto 16) <= i_DataFromMem;
          reg_ACK <= '1';

        when others => null;

      end case;

    end if;

  end process p_register;

  p_inverse: process (CLK_I, RST_I)
  begin  -- process p_inverse
    if RST_I = '1' then                 -- asynchronous reset (active low)

      s_InDataInv <= (others => '0');
      s_InDataInv(1) <= '1';
      s_InDataInv(2) <= '1';
      s_InDataInv(3) <= '1';
      s_InDataInv(4) <= '1';
      
    elsif CLK_I'event and CLK_I = '1' then  -- falling clock edge

      s_InDataInv <= i_DataFromMem;
      
    end if;
  end process p_inverse;

  -- purpose: Multiplexes data and addresses towards/from flash
  -- type   : combinational
  -- inputs : p_ProgramMode
  -- outputs: 
  p_mux: process (p_Access,
                  p_ProgramMode,p_DataFromController,p_AddressFromController,
                  p_WENegFromController,
                  p_OENegFromController,
                  p_CENegFromController,
                  reg_WENeg, reg_OENeg, reg_CENeg,
                  s_ADDR_I,s_STB_I,s_WE_I,
                  s_SelectedByte)
  begin  -- process p_mux

    -- Default
    o_DataToMem <= (others => '0');
    o_AddrToMem <= (others => '0');
    s_CENeg     <= '1';
    s_OENeg     <= '1';
    s_WENeg     <= '1';

    if (p_Access = '0') then

      if (p_ProgramMode='1') then
        
        o_DataToMem <= p_DataFromController;
        o_AddrToMem <= p_AddressFromController;
        s_WENeg     <= p_WENegFromController;
        s_OENeg     <= p_OENegFromController;
        s_CENeg     <= p_CENegFromController;

      else

        o_DataToMem <= (others => '0');
        o_AddrToMem <= s_ADDR_I(19 downto 0) & s_SelectedByte;
        s_WENeg     <= reg_WENeg;
        s_OENeg     <= reg_OENeg;
        s_CENeg     <= reg_CENeg;

      end if;

    else

      o_DataToMem <= (others => '0');
      o_AddrToMem <= p_AddressFromController;
      s_WENeg     <= '1';
      s_OENeg     <= '0';
      s_CENeg     <= '0';

    end if;
    
  end process p_mux;

  s_ACK_O <= reg_ACK;
  o_CENeg <= s_CENeg;
  o_OENeg <= s_OENeg;
  o_WENeg <= s_WENeg;
  o_BidirControl <= not s_OENeg;
  p_DataToController <= s_InDataInv;
  --p_DataToController <= i_DataFromMem;
  o_BYTENeg <= '1';
  s_DAT_O <= reg_DataFromMem;
  --DAT_O <= i_DataFromMem & i_DataFromMem;

  p_Debug <= Debug;


  -- purpose: WB selection
  -- type   : combinational
  -- inputs : ADDR_I_WB1, ADDR_I_WB2, DAT_I_WB1, DAT_I_WB2, STB_I_WB1, STB_I_WB2, WE_I_WB1, WE_I_WB2)
  -- outputs: 
  p_WB: process (ADDR_I_WB1, ADDR_I_WB2,
                 DAT_I_WB1, DAT_I_WB2,
                 STB_I_WB1, STB_I_WB2,
                 WE_I_WB1, WE_I_WB2,
                 s_ACK_O,
                 s_DAT_O,
                 p_WBAccess)
  begin  -- process p_WB

    ACK_O_WB1 <= '0';
    ACK_O_WB2 <= '0';
    DAT_O_WB1 <= (others => '0');
    DAT_O_WB2 <= (others => '0');

    if p_WBAccess = '0' then           -- ZPU

      s_ADDR_I <= ADDR_I_WB2;
      s_DAT_I  <= DAT_I_WB2;
      s_STB_I  <= STB_I_WB2;
      s_WE_I   <= WE_I_WB2;
      ACK_O_WB2 <= s_ACK_O;
      DAT_O_WB2 <= s_DAT_O;

    else

      s_ADDR_I <= ADDR_I_WB1;
      s_DAT_I  <= DAT_I_WB1;
      s_STB_I  <= STB_I_WB1;
      s_WE_I   <= WE_I_WB1;
      ACK_O_WB1 <= s_ACK_O;
      DAT_O_WB1 <= s_DAT_O;
      
    end if;

    
    
  end process p_WB;

end RTL;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------

