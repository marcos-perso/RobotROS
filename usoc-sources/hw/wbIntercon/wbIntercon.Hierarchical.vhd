-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- Wishbone interconnection system
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

library work;
-- Packages
use work.SoCConstantsPackage.all;
use work.WishboneConstantsPackage.all;
-- Components
use work.wbArbiterComponentPackage.all;
use work.wbDataSelectionComponentPackage.all;
use work.wbAddressComparatorComponentPackage.all;
-- Generators

-----------------------------
-- ARCHITECTURE DEFINITION --
-----------------------------
   
architecture Hierarchical of wbIntercon is

  -- SIGNAL DEFINITION --
  signal s_GRANT_1           : std_logic;           -- Grant to MASTER 1
  signal s_GRANT_2           : std_logic;           -- Grant to MASTER 2
  signal s_CYC_FROM_ARBITER  : std_logic; -- Master CYC (OR of all master's CYC)
  signal s_ADDR_FROM_MUX     : std_logic_vector(c_WishboneAddrWidth - 1 downto 0); -- Arbitered address
  signal s_DATA_TO_MUX       : std_logic_vector(c_WishboneDataWidth - 1 downto 0); -- DATA to be arbitered
  signal s_ACK_TO_MUX        : std_logic;      -- ACK to be arbitered

  signal s_ACTIVATE_0 : std_logic;  -- ACTIVATE BANK 0
  signal s_ACTIVATE_1 : std_logic;  -- ACTIVATE BANK 1
  signal s_ACTIVATE_2 : std_logic;  -- ACTIVATE BANK 2
  signal s_ACTIVATE_3 : std_logic;  -- ACTIVATE BANK 3
  signal s_ACTIVATE_4 : std_logic;  -- ACTIVATE BANK 3
  signal s_ACTIVATE_5 : std_logic;  -- ACTIVATE BANK 3
  signal s_ACTIVATE_6 : std_logic;  -- ACTIVATE BANK 3
  signal s_ACTIVATE_7 : std_logic;  -- ACTIVATE BANK 3

  -- Reset

  -- Clock

  -- DEBUG
  
begin


  -- INSTANCES
  i_wbArbiter : wbArbiter
    generic map (
    log_file => "wbArbiter.txt" )
    port map (
      -- MASTER 1 interface
      MASTER_1_CYC  => MASTER_1_CYC_O,
      -- MASTER 2 interface
      MASTER_2_CYC  => MASTER_2_CYC_O,
      -- GRANTS
      p_GRANT_1     => s_GRANT_1,
      p_GRANT_2     => s_GRANT_2,
      -- ARBITER INTERFACE
      p_CYC         => s_CYC_FROM_ARBITER
      );

  i_wbAddressComparator : wbAddressComparator
    port map(

      -- WISHBONE ARBITER interface
      ADDR_I     => s_ADDR_FROM_MUX,
      -- ACTIVATE signals to different slaves
      ACTIVATE_0 => s_ACTIVATE_0,
      ACTIVATE_1 => s_ACTIVATE_1,
      ACTIVATE_2 => s_ACTIVATE_2,
      ACTIVATE_3 => s_ACTIVATE_3,
      ACTIVATE_4 => s_ACTIVATE_4,
      ACTIVATE_5 => s_ACTIVATE_5,
      ACTIVATE_6 => s_ACTIVATE_6,
      ACTIVATE_7 => s_ACTIVATE_7
      );      
  
  i_wbDataSelection : wbDataSelection
    port map(
      -- WISHBONE DATA from the different slaves
      DATA_SLAVE_0 => SLAVE_DATA_FROM_SLAVE_0,
      DATA_SLAVE_1 => SLAVE_DATA_FROM_SLAVE_1,
      DATA_SLAVE_2 => SLAVE_DATA_FROM_SLAVE_2,
      DATA_SLAVE_3 => SLAVE_DATA_FROM_SLAVE_3,
      DATA_SLAVE_4 => SLAVE_DATA_FROM_SLAVE_4,
      DATA_SLAVE_5 => SLAVE_DATA_FROM_SLAVE_5,
      DATA_SLAVE_6 => SLAVE_DATA_FROM_SLAVE_6,
      DATA_SLAVE_7 => SLAVE_DATA_FROM_SLAVE_7,
      -- ACTIVATION signals for each slave
      ACTIVATE_0   => s_ACTIVATE_0,
      ACTIVATE_1   => s_ACTIVATE_1,
      ACTIVATE_2   => s_ACTIVATE_2,
      ACTIVATE_3   => s_ACTIVATE_3,
      ACTIVATE_4   => s_ACTIVATE_4,
      ACTIVATE_5   => s_ACTIVATE_5,
      ACTIVATE_6   => s_ACTIVATE_6,
      ACTIVATE_7   => s_ACTIVATE_7,
      -- WISHBONE DATA to the master
      DATA_MASTER  => s_DATA_TO_MUX
      );      

  -- Path multiplexers

  s_ACK_TO_MUX <= SLAVE_ACK_FROM_SLAVE_0
                  or SLAVE_ACK_FROM_SLAVE_1
                  or SLAVE_ACK_FROM_SLAVE_2
                  or SLAVE_ACK_FROM_SLAVE_3
                  or SLAVE_ACK_FROM_SLAVE_4
                  or SLAVE_ACK_FROM_SLAVE_5
                  or SLAVE_ACK_FROM_SLAVE_6
                  or SLAVE_ACK_FROM_SLAVE_7
                  ;

  p_STB: process (s_ACTIVATE_0,
                  s_ACTIVATE_1,
                  s_ACTIVATE_2,
                  s_ACTIVATE_3,
                  s_ACTIVATE_4,
                  s_ACTIVATE_5,
                  s_ACTIVATE_6,
                  s_ACTIVATE_7,
                  s_GRANT_1,
                  s_GRANT_2,
                  MASTER_1_STB_O,
                  MASTER_2_STB_O
                  )
  begin  -- process p_STB

    SLAVE_STB_0 <= '0';
    SLAVE_STB_1 <= '0';
    SLAVE_STB_2 <= '0';
    SLAVE_STB_3 <= '0';
    SLAVE_STB_4 <= '0';
    SLAVE_STB_5 <= '0';
    SLAVE_STB_6 <= '0';
    SLAVE_STB_7 <= '0';

    if (s_GRANT_1 = '1') then

      if (s_ACTIVATE_0 = '1') then SLAVE_STB_0 <= MASTER_1_STB_O; end if;
      if (s_ACTIVATE_1 = '1') then SLAVE_STB_1 <= MASTER_1_STB_O; end if;
      if (s_ACTIVATE_2 = '1') then SLAVE_STB_2 <= MASTER_1_STB_O; end if;
      if (s_ACTIVATE_3 = '1') then SLAVE_STB_3 <= MASTER_1_STB_O; end if;
      if (s_ACTIVATE_4 = '1') then SLAVE_STB_4 <= MASTER_1_STB_O; end if;
      if (s_ACTIVATE_5 = '1') then SLAVE_STB_5 <= MASTER_1_STB_O; end if;
      if (s_ACTIVATE_6 = '1') then SLAVE_STB_6 <= MASTER_1_STB_O; end if;
      if (s_ACTIVATE_7 = '1') then SLAVE_STB_7 <= MASTER_1_STB_O; end if;
      
    end if;

    if (s_GRANT_2 = '1') then

      if (s_ACTIVATE_0 = '1') then SLAVE_STB_0 <= MASTER_2_STB_O; end if;
      if (s_ACTIVATE_1 = '1') then SLAVE_STB_1 <= MASTER_2_STB_O; end if;
      if (s_ACTIVATE_2 = '1') then SLAVE_STB_2 <= MASTER_2_STB_O; end if;
      if (s_ACTIVATE_3 = '1') then SLAVE_STB_3 <= MASTER_2_STB_O; end if;
      if (s_ACTIVATE_4 = '1') then SLAVE_STB_4 <= MASTER_2_STB_O; end if;
      if (s_ACTIVATE_5 = '1') then SLAVE_STB_5 <= MASTER_2_STB_O; end if;
      if (s_ACTIVATE_6 = '1') then SLAVE_STB_6 <= MASTER_2_STB_O; end if;
      if (s_ACTIVATE_7 = '1') then SLAVE_STB_7 <= MASTER_2_STB_O; end if;
      
    end if;
    
  end process p_STB;

  p_TO_SLAVE: process (MASTER_1_ADDR_O, MASTER_1_DAT_O, MASTER_1_WE_O,
                       MASTER_2_ADDR_O, MASTER_2_DAT_O, MASTER_2_WE_O,
                       s_GRANT_1, s_GRANT_2)
  begin  -- process p_ADDRESS


    -- Default assignments
    s_ADDR_FROM_MUX <= (others => '0');
    SLAVE_DATA_TO_SLAVE <= (others => '0');
    SLAVE_WE <= '0';

    if (s_GRANT_1 = '1') then
      s_ADDR_FROM_MUX <= MASTER_1_ADDR_O;
      SLAVE_DATA_TO_SLAVE <= MASTER_1_DAT_O;
      SLAVE_WE <= MASTER_1_WE_O;
    end if;
    if (s_GRANT_2 = '1') then
      s_ADDR_FROM_MUX <= MASTER_2_ADDR_O;
      SLAVE_DATA_TO_SLAVE <= MASTER_2_DAT_O;
      SLAVE_WE <= MASTER_2_WE_O;
    end if;
    
  end process p_TO_SLAVE;

  SLAVE_ADDR <= s_ADDR_FROM_MUX;
  
  p_DATA: process (s_DATA_TO_MUX, s_GRANT_1, s_GRANT_2, s_ACK_TO_MUX)
  begin  -- process p_DATA


    if (s_GRANT_1 = '1') then
      MASTER_1_DAT_I <= s_DATA_TO_MUX;
      MASTER_1_ACK_I <= s_ACK_TO_MUX;
    else
      MASTER_1_DAT_I <= (others => '0');
      MASTER_1_ACK_I <= '0';
    end if;

    if (s_GRANT_2 = '1') then
      MASTER_2_DAT_I <= s_DATA_TO_MUX;
      MASTER_2_ACK_I <= s_ACK_TO_MUX;
    else
      MASTER_2_DAT_I <= (others => '0');
      MASTER_2_ACK_I <= '0';
    end if;
    
  end process p_DATA;


  SLAVE_ACTIVATE_0 <= s_ACTIVATE_0;
  SLAVE_ACTIVATE_1 <= s_ACTIVATE_1;
  SLAVE_ACTIVATE_2 <= s_ACTIVATE_2;
  SLAVE_ACTIVATE_3 <= s_ACTIVATE_3;
  SLAVE_ACTIVATE_4 <= s_ACTIVATE_4;
  SLAVE_ACTIVATE_5 <= s_ACTIVATE_5;
  SLAVE_ACTIVATE_6 <= s_ACTIVATE_6;
  SLAVE_ACTIVATE_7 <= s_ACTIVATE_7;


end Hierarchical;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------
 
