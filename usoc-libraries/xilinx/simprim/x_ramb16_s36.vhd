-- $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/vhdsclibs/data/simprims/simprim/VITAL/Attic/x_ramb16_s36.vhd,v 1.13 2007/07/13 20:37:50 wloo Exp $
-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  16K-Bit Data and 2K-Bit Parity Single Port Block RAM
-- /___/   /\     Filename : X_RAMB16_S36.vhd
-- \   \  /  \    Timestamp : Thu Apr  8 10:57:15 PDT 2004
--  \___\/\___\
--
-- Revision:
--    03/23/04 - Initial version.
--    CR#208761 - Removed GSR port.
--    07/09/07 - Changed generic write_mode to uppercase (CR 441954).
-- End Revision

----- CELL X_RAMB16_S36 -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library IEEE;
use IEEE.Vital_Primitives.all;
use IEEE.Vital_Timing.all;

library simprim;
use simprim.VPACKAGE.all;
use simprim.VCOMPONENTS.all;

entity X_RAMB16_S36 is
  generic (
    TimingChecksOn : boolean := true;
    Xon            : boolean := true;
    MsgOn          : boolean := true;
    LOC            : string  := "UNPLACED";

    tipd_ADDR : VitalDelayArrayType01(8 downto 0)  := (others => (0 ps, 0 ps));
    tipd_CLK : VitalDelayType01 := (0.000 ns, 0.000 ns);
    tipd_DI   : VitalDelayArrayType01(31 downto 0) := (others => (0 ps, 0 ps));
    tipd_DIP  : VitalDelayArrayType01(3 downto 0)  := (others => (0 ps, 0 ps));
    tipd_EN : VitalDelayType01 := (0.000 ns, 0.000 ns);
    tipd_GSR : VitalDelayType01 := (0.000 ns, 0.000 ns);
    tipd_SSR : VitalDelayType01 := (0.000 ns, 0.000 ns);
    tipd_WE : VitalDelayType01 := (0.000 ns, 0.000 ns);

    tpd_CLK_DO  : VitalDelayArrayType01(31 downto 0) := (others => (100 ps, 100 ps));
    tpd_CLK_DOP : VitalDelayArrayType01(3 downto 0)  := (others => (100 ps, 100 ps));
    tpd_GSR_DO  : VitalDelayArrayType01(31 downto 0) := (others => (0 ps, 0 ps));
    tpd_GSR_DOP : VitalDelayArrayType01(3 downto 0)  := (others => (0 ps, 0 ps));

    trecovery_GSR_CLK_negedge_posedge : VitalDelayType := 0.000 ns;
    tsetup_ADDR_CLK_negedge_posedge : VitalDelayArrayType(8 downto 0)  := (others => 0 ps);
    tsetup_ADDR_CLK_posedge_posedge : VitalDelayArrayType(8 downto 0)  := (others => 0 ps);
    tsetup_DIP_CLK_negedge_posedge  : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    tsetup_DIP_CLK_posedge_posedge  : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    tsetup_DI_CLK_negedge_posedge   : VitalDelayArrayType(31 downto 0) := (others => 0 ps);
    tsetup_DI_CLK_posedge_posedge   : VitalDelayArrayType(31 downto 0) := (others => 0 ps);
    tsetup_EN_CLK_negedge_posedge : VitalDelayType := 0.000 ns;
    tsetup_EN_CLK_posedge_posedge : VitalDelayType := 0.000 ns;
    tsetup_SSR_CLK_negedge_posedge : VitalDelayType := 0.000 ns;
    tsetup_SSR_CLK_posedge_posedge : VitalDelayType := 0.000 ns;
    tsetup_WE_CLK_negedge_posedge : VitalDelayType := 0.000 ns;
    tsetup_WE_CLK_posedge_posedge : VitalDelayType := 0.000 ns;

    thold_ADDR_CLK_negedge_posedge : VitalDelayArrayType(8 downto 0)  := (others => 0 ps);
    thold_ADDR_CLK_posedge_posedge : VitalDelayArrayType(8 downto 0)  := (others => 0 ps);
    thold_DIP_CLK_negedge_posedge  : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    thold_DIP_CLK_posedge_posedge  : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    thold_DI_CLK_negedge_posedge   : VitalDelayArrayType(31 downto 0) := (others => 0 ps);
    thold_DI_CLK_posedge_posedge   : VitalDelayArrayType(31 downto 0) := (others => 0 ps);
    thold_EN_CLK_negedge_posedge : VitalDelayType := 0.000 ns;
    thold_EN_CLK_posedge_posedge : VitalDelayType := 0.000 ns;
    thold_GSR_CLK_negedge_posedge : VitalDelayType := 0.000 ns;
    thold_SSR_CLK_negedge_posedge : VitalDelayType := 0.000 ns;
    thold_SSR_CLK_posedge_posedge : VitalDelayType := 0.000 ns;
    thold_WE_CLK_negedge_posedge : VitalDelayType := 0.000 ns;
    thold_WE_CLK_posedge_posedge : VitalDelayType := 0.000 ns;

    ticd_CLK : VitalDelayType := 0.000 ns;
    tisd_ADDR_CLK : VitalDelayArrayType(8 downto 0)  := (others => 0 ps);
    tisd_DI_CLK  : VitalDelayArrayType(31 downto 0) := (others => 0 ps);
    tisd_DIP_CLK : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    tisd_EN_CLK : VitalDelayType := 0.000 ns;
    tisd_GSR_CLK : VitalDelayType := 0.000 ns;
    tisd_SSR_CLK : VitalDelayType := 0.000 ns;
    tisd_WE_CLK : VitalDelayType := 0.000 ns;

    tpw_CLK_negedge : VitalDelayType := 0.000 ns;
    tpw_CLK_posedge : VitalDelayType := 0.000 ns;
    tpw_GSR_posedge : VitalDelayType := 0.000 ns;
    
    INIT       : bit_vector := X"000000000";
    SRVAL      : bit_vector := X"000000000";
    WRITE_MODE : string     := "WRITE_FIRST";

    INITP_00 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_01 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_02 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_03 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_04 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_05 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_06 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_07 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_00  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_01  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_02  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_03  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_04  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_05  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_06  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_07  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_08  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_09  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0A  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0B  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0C  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0D  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0E  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0F  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_10  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_11  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_12  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_13  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_14  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_15  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_16  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_17  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_18  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_19  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1A  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1B  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1C  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1D  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1E  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1F  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_20  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_21  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_22  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_23  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_24  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_25  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_26  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_27  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_28  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_29  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2A  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2B  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2C  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2D  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2E  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2F  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_30  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_31  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_32  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_33  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_34  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_35  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_36  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_37  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_38  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_39  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3A  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3B  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3C  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3D  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3E  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3F  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000"
    );

  port (
    DO                                   : out std_logic_vector(31 downto 0);
    DOP                                  : out std_logic_vector(3 downto 0);
    
    ADDR                                 : in  std_logic_vector(8 downto 0);
    CLK                                  : in  std_ulogic;
    DI                                   : in  std_logic_vector(31 downto 0);
    DIP                                  : in  std_logic_vector(3 downto 0);
    EN                                   : in  std_ulogic;
    SSR                                  : in  std_ulogic;
    WE                                   : in  std_ulogic
    );
  
  attribute VITAL_LEVEL0 of
    X_RAMB16_S36 :     entity is true;
end X_RAMB16_S36;

architecture X_RAMB16_S36_V of X_RAMB16_S36 is
  attribute VITAL_LEVEL0 of
    X_RAMB16_S36_V : architecture is true;

  signal ADDR_ipd : std_logic_vector(8 downto 0)  := (others => 'X');
  signal CLK_ipd : std_ulogic := 'X';
  signal DIP_ipd  : std_logic_vector(3 downto 0)  := (others => 'X');
  signal DI_ipd   : std_logic_vector(31 downto 0) := (others => 'X');
  signal EN_ipd  : std_ulogic := 'X';
  signal GSR_ipd : std_ulogic := 'X';
  signal SSR_ipd : std_ulogic := 'X';
  signal WE_ipd  : std_ulogic := 'X';

  signal ADDR_dly : std_logic_vector(8 downto 0)  := (others => 'X');
  signal CLK_dly : std_ulogic := 'X';
  signal DIP_dly  : std_logic_vector(3 downto 0)  := (others => 'X');
  signal DI_dly   : std_logic_vector(31 downto 0) := (others => 'X');
  signal EN_dly  : std_ulogic := 'X';
  signal GSR_dly : std_ulogic := 'X';
  signal SSR_dly : std_ulogic := 'X';
  signal WE_dly  : std_ulogic := 'X';

  constant length : integer := 512;
  constant width : integer := 32;

  constant parity_width : integer := 4;
  
  type Two_D_array_type is array ((length -  1) downto 0) of std_logic_vector((width - 1) downto 0);
  type Two_D_parity_array_type is array ((length -  1) downto 0) of std_logic_vector((parity_width - 1) downto 0);    

  function slv_to_two_D_array(
    slv_length : integer;
    slv_width : integer;
    SLV : in std_logic_vector
    )
    return two_D_array_type is
    variable two_D_array : two_D_array_type;
    variable intermediate : std_logic_vector((slv_width - 1) downto 0);
  begin
    for i in 0 to (slv_length - 1)loop
      intermediate := SLV(((i*slv_width) + (slv_width - 1)) downto (i* slv_width));
      two_D_array(i) := intermediate; 
    end loop;
    return two_D_array;
  end;

  function slv_to_two_D_parity_array(
    slv_length : integer;
    slv_width : integer;
    SLV : in std_logic_vector
    )
    return two_D_parity_array_type is
    variable two_D_parity_array : two_D_parity_array_type;
    variable intermediate : std_logic_vector((slv_width - 1) downto 0);
  begin
    for i in 0 to (slv_length - 1)loop
      intermediate := SLV(((i*slv_width) + (slv_width - 1)) downto (i* slv_width));
      two_D_parity_array(i) := intermediate; 
    end loop;
    return two_D_parity_array;
  end;        

begin
  WireDelay : block
  begin
    ADDR_DELAY       : for i in 8 downto 0 generate
      VitalWireDelay (ADDR_ipd(i), ADDR(i), tipd_ADDR(i));
    end generate ADDR_DELAY;
    VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
    DI_DELAY       : for i in 31 downto 0 generate    
      VitalWireDelay (DI_ipd(i), DI(i), tipd_DI(i));
    end generate DI_DELAY;
    DIP_DELAY       : for i in 3 downto 0 generate    
      VitalWireDelay (DIP_ipd(i), DIP(i), tipd_DIP(i));
    end generate DIP_DELAY;    
    VitalWireDelay (EN_ipd, EN, tipd_EN);
    VitalWireDelay (GSR_ipd, GSR, tipd_GSR);
    VitalWireDelay (SSR_ipd, SSR, tipd_SSR);
    VitalWireDelay (WE_ipd, WE, tipd_WE);
  end block;

  SignalDelay : block
  begin
    ADDR_DELAY       : for i in 8 downto 0 generate
    VitalSignalDelay (ADDR_dly(i), ADDR_ipd(i), tisd_ADDR_CLK(i));
    end generate ADDR_DELAY;    
    VitalSignalDelay (CLK_dly, CLK_ipd, ticd_CLK);
    DI_DELAY       : for i in 31 downto 0 generate    
    VitalSignalDelay (DI_dly(i), DI_ipd(i), tisd_DI_CLK(i));
    end generate DI_DELAY;
    DIP_DELAY       : for i in 3 downto 0 generate    
    VitalSignalDelay (DIP_dly(i), DIP_ipd(i), tisd_DIP_CLK(i));
    end generate DIP_DELAY;        
    VitalSignalDelay (EN_dly, EN_ipd, tisd_EN_CLK);
    VitalSignalDelay (GSR_dly, GSR_ipd, tisd_GSR_CLK);
    VitalSignalDelay (SSR_dly, SSR_ipd, tisd_SSR_CLK);
    VitalSignalDelay (WE_dly, WE_ipd, tisd_WE_CLK);
  end block;

  VITALBehavior : process
    variable Tviol_ADDR0_CLK_posedge : std_ulogic := '0';
    variable Tviol_ADDR1_CLK_posedge : std_ulogic := '0';
    variable Tviol_ADDR2_CLK_posedge : std_ulogic := '0';
    variable Tviol_ADDR3_CLK_posedge : std_ulogic := '0';
    variable Tviol_ADDR4_CLK_posedge : std_ulogic := '0';
    variable Tviol_ADDR5_CLK_posedge : std_ulogic := '0';
    variable Tviol_ADDR6_CLK_posedge : std_ulogic := '0';
    variable Tviol_ADDR7_CLK_posedge : std_ulogic := '0';
    variable Tviol_ADDR8_CLK_posedge : std_ulogic := '0';
    variable Tviol_DI0_CLK_posedge   : std_ulogic := '0';
    variable Tviol_DI10_CLK_posedge  : std_ulogic := '0';
    variable Tviol_DI11_CLK_posedge  : std_ulogic := '0';
    variable Tviol_DI12_CLK_posedge  : std_ulogic := '0';
    variable Tviol_DI13_CLK_posedge  : std_ulogic := '0';
    variable Tviol_DI14_CLK_posedge  : std_ulogic := '0';
    variable Tviol_DI15_CLK_posedge  : std_ulogic := '0';
    variable Tviol_DI16_CLK_posedge  : std_ulogic := '0';
    variable Tviol_DI17_CLK_posedge  : std_ulogic := '0';
    variable Tviol_DI18_CLK_posedge  : std_ulogic := '0';
    variable Tviol_DI19_CLK_posedge  : std_ulogic := '0';
    variable Tviol_DI1_CLK_posedge   : std_ulogic := '0';
    variable Tviol_DI20_CLK_posedge  : std_ulogic := '0';
    variable Tviol_DI21_CLK_posedge  : std_ulogic := '0';
    variable Tviol_DI22_CLK_posedge  : std_ulogic := '0';
    variable Tviol_DI23_CLK_posedge  : std_ulogic := '0';
    variable Tviol_DI24_CLK_posedge  : std_ulogic := '0';
    variable Tviol_DI25_CLK_posedge  : std_ulogic := '0';
    variable Tviol_DI26_CLK_posedge  : std_ulogic := '0';
    variable Tviol_DI27_CLK_posedge  : std_ulogic := '0';
    variable Tviol_DI28_CLK_posedge  : std_ulogic := '0';
    variable Tviol_DI29_CLK_posedge  : std_ulogic := '0';
    variable Tviol_DI2_CLK_posedge   : std_ulogic := '0';
    variable Tviol_DI30_CLK_posedge  : std_ulogic := '0';
    variable Tviol_DI31_CLK_posedge  : std_ulogic := '0';
    variable Tviol_DI3_CLK_posedge   : std_ulogic := '0';
    variable Tviol_DI4_CLK_posedge   : std_ulogic := '0';
    variable Tviol_DI5_CLK_posedge   : std_ulogic := '0';
    variable Tviol_DI6_CLK_posedge   : std_ulogic := '0';
    variable Tviol_DI7_CLK_posedge   : std_ulogic := '0';
    variable Tviol_DI8_CLK_posedge   : std_ulogic := '0';
    variable Tviol_DI9_CLK_posedge   : std_ulogic := '0';
    variable Tviol_DIP0_CLK_posedge  : std_ulogic := '0';
    variable Tviol_DIP1_CLK_posedge  : std_ulogic := '0';
    variable Tviol_DIP2_CLK_posedge  : std_ulogic := '0';
    variable Tviol_DIP3_CLK_posedge  : std_ulogic := '0';
    variable Tviol_EN_CLK_posedge    : std_ulogic := '0';
    variable Tviol_GSR_CLK_posedge   : std_ulogic := '0';
    variable Tviol_SSR_CLK_posedge   : std_ulogic := '0';
    variable Tviol_WE_CLK_posedge    : std_ulogic := '0';

    variable Tmkr_ADDR0_CLK_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDR1_CLK_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDR2_CLK_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDR3_CLK_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDR4_CLK_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDR5_CLK_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDR6_CLK_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDR7_CLK_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDR8_CLK_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI0_CLK_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI10_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI11_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI12_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI13_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI14_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI15_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI16_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI17_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI18_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI19_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI1_CLK_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI20_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI21_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI22_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI23_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI24_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI25_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI26_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI27_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI28_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI29_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI2_CLK_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI30_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI31_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI3_CLK_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI4_CLK_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI5_CLK_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI6_CLK_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI7_CLK_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI8_CLK_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DI9_CLK_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIP0_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIP1_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIP2_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIP3_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_EN_CLK_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_GSR_CLK_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_SSR_CLK_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_WE_CLK_posedge    : VitalTimingDataType := VitalTimingDataInit;

    variable PInfo_CLK : VitalPeriodDataType := VitalPeriodDataInit;
    variable PInfo_GSR : VitalPeriodDataType := VitalPeriodDataInit;
    
    variable PViol_CLK : std_ulogic          := '0';
    variable PViol_GSR : std_ulogic          := '0';

    variable DO_GlitchData0  : VitalGlitchDataType;
    variable DO_GlitchData1  : VitalGlitchDataType;
    variable DO_GlitchData2  : VitalGlitchDataType;
    variable DO_GlitchData3  : VitalGlitchDataType;
    variable DO_GlitchData4  : VitalGlitchDataType;
    variable DO_GlitchData5  : VitalGlitchDataType;
    variable DO_GlitchData6  : VitalGlitchDataType;
    variable DO_GlitchData7  : VitalGlitchDataType;
    variable DO_GlitchData8  : VitalGlitchDataType;
    variable DO_GlitchData9  : VitalGlitchDataType;
    variable DO_GlitchData10 : VitalGlitchDataType;
    variable DO_GlitchData11 : VitalGlitchDataType;
    variable DO_GlitchData12 : VitalGlitchDataType;
    variable DO_GlitchData13 : VitalGlitchDataType;
    variable DO_GlitchData14 : VitalGlitchDataType;
    variable DO_GlitchData15 : VitalGlitchDataType;
    variable DO_GlitchData16 : VitalGlitchDataType;
    variable DO_GlitchData17 : VitalGlitchDataType;
    variable DO_GlitchData18 : VitalGlitchDataType;
    variable DO_GlitchData19 : VitalGlitchDataType;
    variable DO_GlitchData20 : VitalGlitchDataType;
    variable DO_GlitchData21 : VitalGlitchDataType;
    variable DO_GlitchData22 : VitalGlitchDataType;
    variable DO_GlitchData23 : VitalGlitchDataType;
    variable DO_GlitchData24 : VitalGlitchDataType;
    variable DO_GlitchData25 : VitalGlitchDataType;
    variable DO_GlitchData26 : VitalGlitchDataType;
    variable DO_GlitchData27 : VitalGlitchDataType;
    variable DO_GlitchData28 : VitalGlitchDataType;
    variable DO_GlitchData29 : VitalGlitchDataType;
    variable DO_GlitchData30 : VitalGlitchDataType;
    variable DO_GlitchData31 : VitalGlitchDataType;
    variable DOP_GlitchData0 : VitalGlitchDataType;
    variable DOP_GlitchData1 : VitalGlitchDataType;
    variable DOP_GlitchData2 : VitalGlitchDataType;
    variable DOP_GlitchData3 : VitalGlitchDataType;

    variable address : integer;
    variable valid_addr : boolean := FALSE;
    variable mem_slv : std_logic_vector(16383 downto 0) := To_StdLogicVector(INIT_3F & INIT_3E & INIT_3D & INIT_3C &
                                                                             INIT_3B & INIT_3A & INIT_39 & INIT_38 &
                                                                             INIT_37 & INIT_36 & INIT_35 & INIT_34 &
                                                                             INIT_33 & INIT_32 & INIT_31 & INIT_30 &
                                                                             INIT_2F & INIT_2E & INIT_2D & INIT_2C &
                                                                             INIT_2B & INIT_2A & INIT_29 & INIT_28 &
                                                                             INIT_27 & INIT_26 & INIT_25 & INIT_24 &
                                                                             INIT_23 & INIT_22 & INIT_21 & INIT_20 &
                                                                             INIT_1F & INIT_1E & INIT_1D & INIT_1C &
                                                                             INIT_1B & INIT_1A & INIT_19 & INIT_18 &
                                                                             INIT_17 & INIT_16 & INIT_15 & INIT_14 &
                                                                             INIT_13 & INIT_12 & INIT_11 & INIT_10 &
                                                                             INIT_0F & INIT_0E & INIT_0D & INIT_0C &
                                                                             INIT_0B & INIT_0A & INIT_09 & INIT_08 &
                                                                             INIT_07 & INIT_06 & INIT_05 & INIT_04 &
                                                                             INIT_03 & INIT_02 & INIT_01 & INIT_00);

    variable memp_slv : std_logic_vector(2047 downto 0) := To_StdLogicVector(INITP_07 & INITP_06 & INITP_05 & INITP_04 &
                                                                              INITP_03 & INITP_02 & INITP_01 & INITP_00);    
    variable mem : Two_D_array_type := slv_to_two_D_array(length, width, mem_slv);
    variable memp : Two_D_parity_array_type := slv_to_two_D_parity_array(length, parity_width, memp_slv);
    variable wr_mode : integer := 0;                
    

    variable FIRST_TIME      : boolean                                    := true;
    variable INI             : std_logic_vector (INIT'length-1 downto 0)  := TO_StdLogicVector(INIT);
    variable SRVA            : std_logic_vector (SRVAL'length-1 downto 0) := TO_StdLogicVector(SRVAL );
    variable Violation : std_ulogic                      := '0';

    variable DOP_zd          : std_logic_vector(3 downto 0)               := INI(35 downto 32 );
    variable DO_zd           : std_logic_vector(31 downto 0)              := INI(31 downto 0 );    

  begin
    if (FIRST_TIME) then
      if ((WRITE_MODE = "write_first") or (WRITE_MODE = "WRITE_FIRST")) then
        wr_mode := 0;
      elsif ((WRITE_MODE = "read_first") or (WRITE_MODE = "READ_FIRST")) then
        wr_mode := 1;
      elsif ((WRITE_MODE = "no_change") or (WRITE_MODE = "NO_CHANGE")) then
        wr_mode := 2;
      else
        GenericValueCheckMessage
          (HeaderMsg            => " Attribute Syntax Error ",
           GenericName          => " WRITE_MODE ",
           EntityName           => "/X_RAMB16_S36",
           GenericValue         => WRITE_MODE,
           Unit                 => "",
           ExpectedValueMsg     => " The Legal values for this attribute are ",
           ExpectedGenericValue => " WRITE_FIRST, READ_FIRST or NO_CHANGE ",
           TailMsg              => "",
           MsgSeverity          => error
           );
      end if;      
      DO  <= DO_zd;
      DOP <= DOP_zd;
      wait until (GSR_dly = '1' or CLK_dly'last_value = '0' or CLK_dly'last_value = '1');
      FIRST_TIME := false;
    end if;

    if (TimingChecksOn) then
      VitalSetupHoldCheck (
        Violation      => Tviol_DI31_CLK_posedge,
        TimingData     => Tmkr_DI31_CLK_posedge,
        TestSignal     => DI_dly(31),
        TestSignalName => "DI(31)",
        TestDelay      => tisd_DI_CLK(31),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(31),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(31),
        HoldLow        => thold_DI_CLK_posedge_posedge(31),
        HoldHigh       => thold_DI_CLK_negedge_posedge(31),
        CheckEnabled   => TO_X01(EN_dly and WE_dly ) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI30_CLK_posedge,
        TimingData     => Tmkr_DI30_CLK_posedge,
        TestSignal     => DI_dly(30),
        TestSignalName => "DI(30)",
        TestDelay      => tisd_DI_CLK(30),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(30),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(30),
        HoldLow        => thold_DI_CLK_posedge_posedge(30),
        HoldHigh       => thold_DI_CLK_negedge_posedge(30),
        CheckEnabled   => TO_X01(EN_dly and WE_dly ) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI29_CLK_posedge,
        TimingData     => Tmkr_DI29_CLK_posedge,
        TestSignal     => DI_dly(29),
        TestSignalName => "DI(29)",
        TestDelay      => tisd_DI_CLK(29),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(29),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(29),
        HoldLow        => thold_DI_CLK_posedge_posedge(29),
        HoldHigh       => thold_DI_CLK_negedge_posedge(29),
        CheckEnabled   => TO_X01(EN_dly and WE_dly ) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI28_CLK_posedge,
        TimingData     => Tmkr_DI28_CLK_posedge,
        TestSignal     => DI_dly(28),
        TestSignalName => "DI(28)",
        TestDelay      => tisd_DI_CLK(28),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(28),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(28),
        HoldLow        => thold_DI_CLK_posedge_posedge(28),
        HoldHigh       => thold_DI_CLK_negedge_posedge(28),
        CheckEnabled   => TO_X01(EN_dly and WE_dly ) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI27_CLK_posedge,
        TimingData     => Tmkr_DI27_CLK_posedge,
        TestSignal     => DI_dly(27),
        TestSignalName => "DI(27)",
        TestDelay      => tisd_DI_CLK(27),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(27),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(27),
        HoldLow        => thold_DI_CLK_posedge_posedge(27),
        HoldHigh       => thold_DI_CLK_negedge_posedge(27),
        CheckEnabled   => TO_X01(EN_dly and WE_dly ) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI26_CLK_posedge,
        TimingData     => Tmkr_DI26_CLK_posedge,
        TestSignal     => DI_dly(26),
        TestSignalName => "DI(26)",
        TestDelay      => tisd_DI_CLK(26),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(26),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(26),
        HoldLow        => thold_DI_CLK_posedge_posedge(26),
        HoldHigh       => thold_DI_CLK_negedge_posedge(26),
        CheckEnabled   => TO_X01(EN_dly and WE_dly ) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI25_CLK_posedge,
        TimingData     => Tmkr_DI25_CLK_posedge,
        TestSignal     => DI_dly(25),
        TestSignalName => "DI(25)",
        TestDelay      => tisd_DI_CLK(25),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(25),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(25),
        HoldLow        => thold_DI_CLK_posedge_posedge(25),
        HoldHigh       => thold_DI_CLK_negedge_posedge(25),
        CheckEnabled   => TO_X01(EN_dly and WE_dly ) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI24_CLK_posedge,
        TimingData     => Tmkr_DI24_CLK_posedge,
        TestSignal     => DI_dly(24),
        TestSignalName => "DI(24)",
        TestDelay      => tisd_DI_CLK(24),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(24),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(24),
        HoldLow        => thold_DI_CLK_posedge_posedge(24),
        HoldHigh       => thold_DI_CLK_negedge_posedge(24),
        CheckEnabled   => TO_X01(EN_dly and WE_dly ) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI23_CLK_posedge,
        TimingData     => Tmkr_DI23_CLK_posedge,
        TestSignal     => DI_dly(23),
        TestSignalName => "DI(23)",
        TestDelay      => tisd_DI_CLK(23),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(23),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(23),
        HoldLow        => thold_DI_CLK_posedge_posedge(23),
        HoldHigh       => thold_DI_CLK_negedge_posedge(23),
        CheckEnabled   => TO_X01(EN_dly and WE_dly ) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI22_CLK_posedge,
        TimingData     => Tmkr_DI22_CLK_posedge,
        TestSignal     => DI_dly(22),
        TestSignalName => "DI(22)",
        TestDelay      => tisd_DI_CLK(22),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(22),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(22),
        HoldLow        => thold_DI_CLK_posedge_posedge(22),
        HoldHigh       => thold_DI_CLK_negedge_posedge(22),
        CheckEnabled   => TO_X01(EN_dly and WE_dly ) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI21_CLK_posedge,
        TimingData     => Tmkr_DI21_CLK_posedge,
        TestSignal     => DI_dly(21),
        TestSignalName => "DI(21)",
        TestDelay      => tisd_DI_CLK(21),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(21),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(21),
        HoldLow        => thold_DI_CLK_posedge_posedge(21),
        HoldHigh       => thold_DI_CLK_negedge_posedge(21),
        CheckEnabled   => TO_X01(EN_dly and WE_dly ) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI20_CLK_posedge,
        TimingData     => Tmkr_DI20_CLK_posedge,
        TestSignal     => DI_dly(20),
        TestSignalName => "DI(20)",
        TestDelay      => tisd_DI_CLK(20),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(20),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(20),
        HoldLow        => thold_DI_CLK_posedge_posedge(20),
        HoldHigh       => thold_DI_CLK_negedge_posedge(20),
        CheckEnabled   => TO_X01(EN_dly and WE_dly ) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI19_CLK_posedge,
        TimingData     => Tmkr_DI19_CLK_posedge,
        TestSignal     => DI_dly(19),
        TestSignalName => "DI(19)",
        TestDelay      => tisd_DI_CLK(19),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(19),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(19),
        HoldLow        => thold_DI_CLK_posedge_posedge(19),
        HoldHigh       => thold_DI_CLK_negedge_posedge(19),
        CheckEnabled   => TO_X01(EN_dly and WE_dly ) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI18_CLK_posedge,
        TimingData     => Tmkr_DI18_CLK_posedge,
        TestSignal     => DI_dly(18),
        TestSignalName => "DI(18)",
        TestDelay      => tisd_DI_CLK(18),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(18),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(18),
        HoldLow        => thold_DI_CLK_posedge_posedge(18),
        HoldHigh       => thold_DI_CLK_negedge_posedge(18),
        CheckEnabled   => TO_X01(EN_dly and WE_dly ) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI17_CLK_posedge,
        TimingData     => Tmkr_DI17_CLK_posedge,
        TestSignal     => DI_dly(17),
        TestSignalName => "DI(17)",
        TestDelay      => tisd_DI_CLK(17),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(17),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(17),
        HoldLow        => thold_DI_CLK_posedge_posedge(17),
        HoldHigh       => thold_DI_CLK_negedge_posedge(17),
        CheckEnabled   => TO_X01(EN_dly and WE_dly ) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI16_CLK_posedge,
        TimingData     => Tmkr_DI16_CLK_posedge,
        TestSignal     => DI_dly(16),
        TestSignalName => "DI(16)",
        TestDelay      => tisd_DI_CLK(16),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(16),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(16),
        HoldLow        => thold_DI_CLK_posedge_posedge(16),
        HoldHigh       => thold_DI_CLK_negedge_posedge(16),
        CheckEnabled   => TO_X01(EN_dly and WE_dly ) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI15_CLK_posedge,
        TimingData     => Tmkr_DI15_CLK_posedge,
        TestSignal     => DI_dly(15),
        TestSignalName => "DI(15)",
        TestDelay      => tisd_DI_CLK(15),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(15),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(15),
        HoldLow        => thold_DI_CLK_posedge_posedge(15),
        HoldHigh       => thold_DI_CLK_negedge_posedge(15),
        CheckEnabled   => TO_X01(EN_dly and WE_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI14_CLK_posedge,
        TimingData     => Tmkr_DI14_CLK_posedge,
        TestSignal     => DI_dly(14),
        TestSignalName => "DI(14)",
        TestDelay      => tisd_DI_CLK(14),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(14),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(14),
        HoldLow        => thold_DI_CLK_posedge_posedge(14),
        HoldHigh       => thold_DI_CLK_negedge_posedge(14),
        CheckEnabled   => TO_X01(EN_dly and WE_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI13_CLK_posedge,
        TimingData     => Tmkr_DI13_CLK_posedge,
        TestSignal     => DI_dly(13),
        TestSignalName => "DI(13)",
        TestDelay      => tisd_DI_CLK(13),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(13),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(13),
        HoldLow        => thold_DI_CLK_posedge_posedge(13),
        HoldHigh       => thold_DI_CLK_negedge_posedge(13),
        CheckEnabled   => TO_X01(EN_dly and WE_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI12_CLK_posedge,
        TimingData     => Tmkr_DI12_CLK_posedge,
        TestSignal     => DI_dly(12),
        TestSignalName => "DI(12)",
        TestDelay      => tisd_DI_CLK(12),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(12),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(12),
        HoldLow        => thold_DI_CLK_posedge_posedge(12),
        HoldHigh       => thold_DI_CLK_negedge_posedge(12),
        CheckEnabled   => TO_X01(EN_dly and WE_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI11_CLK_posedge,
        TimingData     => Tmkr_DI11_CLK_posedge,
        TestSignal     => DI_dly(11),
        TestSignalName => "DI(11)",
        TestDelay      => tisd_DI_CLK(11),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(11),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(11),
        HoldLow        => thold_DI_CLK_posedge_posedge(11),
        HoldHigh       => thold_DI_CLK_negedge_posedge(11),
        CheckEnabled   => TO_X01(EN_dly and WE_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI10_CLK_posedge,
        TimingData     => Tmkr_DI10_CLK_posedge,
        TestSignal     => DI_dly(10),
        TestSignalName => "DI(10)",
        TestDelay      => tisd_DI_CLK(10),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(10),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(10),
        HoldLow        => thold_DI_CLK_posedge_posedge(10),
        HoldHigh       => thold_DI_CLK_negedge_posedge(10),
        CheckEnabled   => TO_X01(EN_dly and WE_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI9_CLK_posedge,
        TimingData     => Tmkr_DI9_CLK_posedge,
        TestSignal     => DI_dly(9),
        TestSignalName => "DI(9)",
        TestDelay      => tisd_DI_CLK(9),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(9),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(9),
        HoldLow        => thold_DI_CLK_posedge_posedge(9),
        HoldHigh       => thold_DI_CLK_negedge_posedge(9),
        CheckEnabled   => TO_X01(EN_dly and WE_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI8_CLK_posedge,
        TimingData     => Tmkr_DI8_CLK_posedge,
        TestSignal     => DI_dly(8),
        TestSignalName => "DI(8)",
        TestDelay      => tisd_DI_CLK(8),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(8),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(8),
        HoldLow        => thold_DI_CLK_posedge_posedge(8),
        HoldHigh       => thold_DI_CLK_negedge_posedge(8),
        CheckEnabled   => TO_X01(EN_dly and WE_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI7_CLK_posedge,
        TimingData     => Tmkr_DI7_CLK_posedge,
        TestSignal     => DI_dly(7),
        TestSignalName => "DI(7)",
        TestDelay      => tisd_DI_CLK(7),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(7),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(7),
        HoldLow        => thold_DI_CLK_posedge_posedge(7),
        HoldHigh       => thold_DI_CLK_negedge_posedge(7),
        CheckEnabled   => TO_X01(EN_dly and WE_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI6_CLK_posedge,
        TimingData     => Tmkr_DI6_CLK_posedge,
        TestSignal     => DI_dly(6),
        TestSignalName => "DI(6)",
        TestDelay      => tisd_DI_CLK(6),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(6),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(6),
        HoldLow        => thold_DI_CLK_posedge_posedge(6),
        HoldHigh       => thold_DI_CLK_negedge_posedge(6),
        CheckEnabled   => TO_X01(EN_dly and WE_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI5_CLK_posedge,
        TimingData     => Tmkr_DI5_CLK_posedge,
        TestSignal     => DI_dly(5),
        TestSignalName => "DI(5)",
        TestDelay      => tisd_DI_CLK(5),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(5),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(5),
        HoldLow        => thold_DI_CLK_posedge_posedge(5),
        HoldHigh       => thold_DI_CLK_negedge_posedge(5),
        CheckEnabled   => TO_X01(EN_dly and WE_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI4_CLK_posedge,
        TimingData     => Tmkr_DI4_CLK_posedge,
        TestSignal     => DI_dly(4),
        TestSignalName => "DI(4)",
        TestDelay      => tisd_DI_CLK(4),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(4),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(4),
        HoldLow        => thold_DI_CLK_posedge_posedge(4),
        HoldHigh       => thold_DI_CLK_negedge_posedge(4),
        CheckEnabled   => TO_X01(EN_dly and WE_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI3_CLK_posedge,
        TimingData     => Tmkr_DI3_CLK_posedge,
        TestSignal     => DI_dly(3),
        TestSignalName => "DI(3)",
        TestDelay      => tisd_DI_CLK(3),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(3),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(3),
        HoldLow        => thold_DI_CLK_posedge_posedge(3),
        HoldHigh       => thold_DI_CLK_negedge_posedge(3),
        CheckEnabled   => TO_X01(EN_dly and WE_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI2_CLK_posedge,
        TimingData     => Tmkr_DI2_CLK_posedge,
        TestSignal     => DI_dly(2),
        TestSignalName => "DI(2)",
        TestDelay      => tisd_DI_CLK(2),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(2),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(2),
        HoldLow        => thold_DI_CLK_posedge_posedge(2),
        HoldHigh       => thold_DI_CLK_negedge_posedge(2),
        CheckEnabled   => TO_X01(EN_dly and WE_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI1_CLK_posedge,
        TimingData     => Tmkr_DI1_CLK_posedge,
        TestSignal     => DI_dly(1),
        TestSignalName => "DI(1)",
        TestDelay      => tisd_DI_CLK(1),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(1),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(1),
        HoldLow        => thold_DI_CLK_posedge_posedge(1),
        HoldHigh       => thold_DI_CLK_negedge_posedge(1),
        CheckEnabled   => TO_X01(EN_dly and WE_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DI0_CLK_posedge,
        TimingData     => Tmkr_DI0_CLK_posedge,
        TestSignal     => DI_dly(0),
        TestSignalName => "DI(0)",
        TestDelay      => tisd_DI_CLK(0),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DI_CLK_posedge_posedge(0),
        SetupLow       => tsetup_DI_CLK_negedge_posedge(0),
        HoldLow        => thold_DI_CLK_posedge_posedge(0),
        HoldHigh       => thold_DI_CLK_negedge_posedge(0),
        CheckEnabled   => TO_X01(EN_dly and WE_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIP3_CLK_posedge,
        TimingData     => Tmkr_DIP3_CLK_posedge,
        TestSignal     => DIP_dly(3),
        TestSignalName => "DIP(3)",
        TestDelay      => tisd_DIP_CLK(3),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DIP_CLK_posedge_posedge(3),
        SetupLow       => tsetup_DIP_CLK_negedge_posedge(3),
        HoldLow        => thold_DIP_CLK_posedge_posedge(3),
        HoldHigh       => thold_DIP_CLK_negedge_posedge(3),
        CheckEnabled   => TO_X01(EN_dly and WE_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIP2_CLK_posedge,
        TimingData     => Tmkr_DIP2_CLK_posedge,
        TestSignal     => DIP_dly(2),
        TestSignalName => "DIP(2)",
        TestDelay      => tisd_DIP_CLK(2),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DIP_CLK_posedge_posedge(2),
        SetupLow       => tsetup_DIP_CLK_negedge_posedge(2),
        HoldLow        => thold_DIP_CLK_posedge_posedge(2),
        HoldHigh       => thold_DIP_CLK_negedge_posedge(2),
        CheckEnabled   => TO_X01(EN_dly and WE_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIP1_CLK_posedge,
        TimingData     => Tmkr_DIP1_CLK_posedge,
        TestSignal     => DIP_dly(1),
        TestSignalName => "DIP(1)",
        TestDelay      => tisd_DIP_CLK(1),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_DIP_CLK_posedge_posedge(1),
        SetupLow       => tsetup_DIP_CLK_negedge_posedge(1),
        HoldLow        => thold_DIP_CLK_posedge_posedge(1),
        HoldHigh       => thold_DIP_CLK_negedge_posedge(1),
        CheckEnabled   => TO_X01(EN_dly and WE_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIP0_CLK_posedge,
        TimingData     => Tmkr_DIP0_CLK_posedge,
        TestSignal     => DIP_dly(0),
        TestSignalName => "DIP(0)",
        TestDelay      => tisd_DIP_CLK(0),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => 0 ps,
        SetupHigh      => tsetup_DIP_CLK_posedge_posedge(0),
        SetupLow       => tsetup_DIP_CLK_negedge_posedge(0),
        HoldLow        => thold_DIP_CLK_posedge_posedge(0),
        HoldHigh       => thold_DIP_CLK_negedge_posedge(0),
        CheckEnabled   => TO_X01(EN_dly and WE_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_WE_CLK_posedge,
        TimingData     => Tmkr_WE_CLK_posedge,
        TestSignal     => WE_dly,
        TestSignalName => "WE",
        TestDelay      => tisd_WE_CLK,
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_WE_CLK_posedge_posedge,
        SetupLow       => tsetup_WE_CLK_negedge_posedge,
        HoldLow        => thold_WE_CLK_posedge_posedge,
        HoldHigh       => thold_WE_CLK_negedge_posedge,
        CheckEnabled   => TO_X01(EN_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_EN_CLK_posedge,
        TimingData     => Tmkr_EN_CLK_posedge,
        TestSignal     => EN_dly,
        TestSignalName => "EN",
        TestDelay      => tisd_EN_CLK,
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_EN_CLK_posedge_posedge,
        SetupLow       => tsetup_EN_CLK_negedge_posedge,
        HoldLow        => thold_EN_CLK_posedge_posedge,
        HoldHigh       => thold_EN_CLK_negedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_SSR_CLK_posedge,
        TimingData     => Tmkr_SSR_CLK_posedge,
        TestSignal     => SSR_dly,
        TestSignalName => "SSR",
        TestDelay      => tisd_SSR_CLK,
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_SSR_CLK_posedge_posedge,
        SetupLow       => tsetup_SSR_CLK_negedge_posedge,
        HoldLow        => thold_SSR_CLK_posedge_posedge,
        HoldHigh       => thold_SSR_CLK_negedge_posedge,
        CheckEnabled   => TO_X01(EN_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);

      VitalRecoveryRemovalCheck (
        Violation      => Tviol_GSR_CLK_posedge,
        TimingData     => Tmkr_GSR_CLK_posedge,
        TestSignal     => GSR_dly,
        TestSignalName => "GSR",
        TestDelay      => tisd_GSR_CLK,
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        Recovery       => trecovery_GSR_CLK_negedge_posedge,
        Removal        => thold_GSR_CLK_negedge_posedge,
        ActiveLow      => false,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDR8_CLK_posedge,
        TimingData     => Tmkr_ADDR8_CLK_posedge,
        TestSignal     => ADDR_dly(8),
        TestSignalName => "ADDR(8)",
        TestDelay      => tisd_ADDR_CLK(8),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_ADDR_CLK_posedge_posedge(8),
        SetupLow       => tsetup_ADDR_CLK_negedge_posedge(8),
        HoldLow        => thold_ADDR_CLK_posedge_posedge(8),
        HoldHigh       => thold_ADDR_CLK_negedge_posedge(8),
        CheckEnabled   => TO_X01(EN_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDR7_CLK_posedge,
        TimingData     => Tmkr_ADDR7_CLK_posedge,
        TestSignal     => ADDR_dly(7),
        TestSignalName => "ADDR(7)",
        TestDelay      => tisd_ADDR_CLK(7),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_ADDR_CLK_posedge_posedge(7),
        SetupLow       => tsetup_ADDR_CLK_negedge_posedge(7),
        HoldLow        => thold_ADDR_CLK_posedge_posedge(7),
        HoldHigh       => thold_ADDR_CLK_negedge_posedge(7),
        CheckEnabled   => TO_X01(EN_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDR6_CLK_posedge,
        TimingData     => Tmkr_ADDR6_CLK_posedge,
        TestSignal     => ADDR_dly(6),
        TestSignalName => "ADDR(6)",
        TestDelay      => tisd_ADDR_CLK(6),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_ADDR_CLK_posedge_posedge(6),
        SetupLow       => tsetup_ADDR_CLK_negedge_posedge(6),
        HoldLow        => thold_ADDR_CLK_posedge_posedge(6),
        HoldHigh       => thold_ADDR_CLK_negedge_posedge(6),
        CheckEnabled   => TO_X01(EN_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDR5_CLK_posedge,
        TimingData     => Tmkr_ADDR5_CLK_posedge,
        TestSignal     => ADDR_dly(5),
        TestSignalName => "ADDR(5)",
        TestDelay      => tisd_ADDR_CLK(5),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_ADDR_CLK_posedge_posedge(5),
        SetupLow       => tsetup_ADDR_CLK_negedge_posedge(5),
        HoldLow        => thold_ADDR_CLK_posedge_posedge(5),
        HoldHigh       => thold_ADDR_CLK_negedge_posedge(5),
        CheckEnabled   => TO_X01(EN_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDR4_CLK_posedge,
        TimingData     => Tmkr_ADDR4_CLK_posedge,
        TestSignal     => ADDR_dly(4),
        TestSignalName => "ADDR(4)",
        TestDelay      => tisd_ADDR_CLK(4),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_ADDR_CLK_posedge_posedge(4),
        SetupLow       => tsetup_ADDR_CLK_negedge_posedge(4),
        HoldLow        => thold_ADDR_CLK_posedge_posedge(4),
        HoldHigh       => thold_ADDR_CLK_negedge_posedge(4),
        CheckEnabled   => TO_X01(EN_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDR3_CLK_posedge,
        TimingData     => Tmkr_ADDR3_CLK_posedge,
        TestSignal     => ADDR_dly(3),
        TestSignalName => "ADDR(3)",
        TestDelay      => tisd_ADDR_CLK(3),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_ADDR_CLK_posedge_posedge(3),
        SetupLow       => tsetup_ADDR_CLK_negedge_posedge(3),
        HoldLow        => thold_ADDR_CLK_posedge_posedge(3),
        HoldHigh       => thold_ADDR_CLK_negedge_posedge(3),
        CheckEnabled   => TO_X01(EN_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDR2_CLK_posedge,
        TimingData     => Tmkr_ADDR2_CLK_posedge,
        TestSignal     => ADDR_dly(2),
        TestSignalName => "ADDR(2)",
        TestDelay      => tisd_ADDR_CLK(2),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_ADDR_CLK_posedge_posedge(2),
        SetupLow       => tsetup_ADDR_CLK_negedge_posedge(2),
        HoldLow        => thold_ADDR_CLK_posedge_posedge(2),
        HoldHigh       => thold_ADDR_CLK_negedge_posedge(2),
        CheckEnabled   => TO_X01(EN_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDR1_CLK_posedge,
        TimingData     => Tmkr_ADDR1_CLK_posedge,
        TestSignal     => ADDR_dly(1),
        TestSignalName => "ADDR(1)",
        TestDelay      => tisd_ADDR_CLK(1),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_ADDR_CLK_posedge_posedge(1),
        SetupLow       => tsetup_ADDR_CLK_negedge_posedge(1),
        HoldLow        => thold_ADDR_CLK_posedge_posedge(1),
        HoldHigh       => thold_ADDR_CLK_negedge_posedge(1),
        CheckEnabled   => TO_X01(EN_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDR0_CLK_posedge,
        TimingData     => Tmkr_ADDR0_CLK_posedge,
        TestSignal     => ADDR_dly(0),
        TestSignalName => "ADDR(0)",
        TestDelay      => tisd_ADDR_CLK(0),
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_ADDR_CLK_posedge_posedge(0),
        SetupLow       => tsetup_ADDR_CLK_negedge_posedge(0),
        HoldLow        => thold_ADDR_CLK_posedge_posedge(0),
        HoldHigh       => thold_ADDR_CLK_negedge_posedge(0),
        CheckEnabled   => TO_X01(EN_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalPeriodPulseCheck (
        Violation      => Pviol_CLK,
        PeriodData     => PInfo_CLK,
        TestSignal     => CLK_dly,
        TestSignalName => "CLK",
        TestDelay      => 0 ps,
        Period         => 0 ps,
        PulseWidthHigh => tpw_CLK_posedge,
        PulseWidthLow  => tpw_CLK_negedge,
        CheckEnabled   => TO_X01(EN_dly) /= '0',
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalPeriodPulseCheck (
        Violation      => Pviol_GSR,
        PeriodData     => PInfo_GSR,
        TestSignal     => GSR_dly,
        TestSignalName => "GSR",
        TestDelay      => 0 ps,
        Period         => 0 ps,
        PulseWidthHigh => tpw_GSR_posedge,
        PulseWidthLow  => 0 ps,
        CheckEnabled   => true,
        HeaderMsg      => "/X_RAMB16_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
    end if;

    Violation :=
      Pviol_CLK or
      Tviol_ADDR0_CLK_posedge or
      Tviol_ADDR1_CLK_posedge or
      Tviol_ADDR2_CLK_posedge or
      Tviol_ADDR3_CLK_posedge or
      Tviol_ADDR4_CLK_posedge or
      Tviol_ADDR5_CLK_posedge or
      Tviol_ADDR6_CLK_posedge or
      Tviol_ADDR7_CLK_posedge or
      Tviol_ADDR8_CLK_posedge or
      Tviol_DI0_CLK_posedge or
      Tviol_DI10_CLK_posedge or
      Tviol_DI11_CLK_posedge or
      Tviol_DI12_CLK_posedge or
      Tviol_DI13_CLK_posedge or
      Tviol_DI14_CLK_posedge or
      Tviol_DI15_CLK_posedge or
      Tviol_DI16_CLK_posedge or
      Tviol_DI17_CLK_posedge or
      Tviol_DI18_CLK_posedge or
      Tviol_DI19_CLK_posedge or
      Tviol_DI1_CLK_posedge or
      Tviol_DI20_CLK_posedge or
      Tviol_DI21_CLK_posedge or
      Tviol_DI22_CLK_posedge or
      Tviol_DI23_CLK_posedge or
      Tviol_DI24_CLK_posedge or
      Tviol_DI25_CLK_posedge or
      Tviol_DI26_CLK_posedge or
      Tviol_DI27_CLK_posedge or
      Tviol_DI28_CLK_posedge or
      Tviol_DI29_CLK_posedge or
      Tviol_DI2_CLK_posedge or
      Tviol_DI30_CLK_posedge or
      Tviol_DI31_CLK_posedge or
      Tviol_DI3_CLK_posedge or
      Tviol_DI4_CLK_posedge or
      Tviol_DI5_CLK_posedge or
      Tviol_DI6_CLK_posedge or
      Tviol_DI7_CLK_posedge or
      Tviol_DI8_CLK_posedge or
      Tviol_DI9_CLK_posedge or
      Tviol_DIP0_CLK_posedge or
      Tviol_DIP1_CLK_posedge or
      Tviol_DIP2_CLK_posedge or
      Tviol_DIP3_CLK_posedge or
      Tviol_EN_CLK_posedge or
      Tviol_SSR_CLK_posedge or
      Tviol_WE_CLK_posedge;

    VALID_ADDR := ADDR_IS_VALID(ADDR_dly);

    if (VALID_ADDR) then
      ADDRESS := SLV_TO_INT(ADDR_dly);
    end if;

    if (GSR_dly = '1') then
      DO_zd                                                         := INI(31 downto 0 );
      DOP_zd                                                        := INI (35 downto 32 );
      
    elsif (GSR_dly = '0') then
      if (rising_edge(CLK_dly)) then
        if (EN_dly = '1') then
          if (SSR_dly = '1') then
            DO_zd := To_StdLogicVector(SRVAL)(31 downto 0);
            DOP_zd := To_StdLogicVector(SRVAL)(35 downto 32);          
          else    
            if (WE_dly = '1') then
              if (wr_mode = 0) then
                DO_zd := DI_dly;
                DOP_zd := DIP_dly;              
              elsif (wr_mode = 1) then
                DO_zd := mem(address);
                DOP_zd := memp(address);                
              end if;
            else 
              if (valid_addr) then
                DO_zd := mem(address);
                DOP_zd := memp(address);              
              end if;
            end if;
          end if;
          if (WE_dly = '1') then
            if (valid_addr) then
              mem(address) := DI_dly;
              memp(address) := DIP_dly;            
            end if;
          end if;  
        end if;
      end if;
    end if;

    DO_zd(31) := Violation xor DO_zd(31);
    DO_zd(30) := Violation xor DO_zd(30);
    DO_zd(29) := Violation xor DO_zd(29);
    DO_zd(28) := Violation xor DO_zd(28);
    DO_zd(27) := Violation xor DO_zd(27);
    DO_zd(26) := Violation xor DO_zd(26);
    DO_zd(25) := Violation xor DO_zd(25);
    DO_zd(24) := Violation xor DO_zd(24);
    DO_zd(23) := Violation xor DO_zd(23);
    DO_zd(22) := Violation xor DO_zd(22);
    DO_zd(21) := Violation xor DO_zd(21);
    DO_zd(20) := Violation xor DO_zd(20);
    DO_zd(19) := Violation xor DO_zd(19);
    DO_zd(18) := Violation xor DO_zd(18);
    DO_zd(17) := Violation xor DO_zd(17);
    DO_zd(16) := Violation xor DO_zd(16);
    DO_zd(15) := Violation xor DO_zd(15);
    DO_zd(14) := Violation xor DO_zd(14);
    DO_zd(13) := Violation xor DO_zd(13);
    DO_zd(12) := Violation xor DO_zd(12);
    DO_zd(11) := Violation xor DO_zd(11);
    DO_zd(10) := Violation xor DO_zd(10);
    DO_zd(9)  := Violation xor DO_zd(9);
    DO_zd(8)  := Violation xor DO_zd(8);
    DO_zd(7)  := Violation xor DO_zd(7);
    DO_zd(6)  := Violation xor DO_zd(6);
    DO_zd(5)  := Violation xor DO_zd(5);
    DO_zd(4)  := Violation xor DO_zd(4);
    DO_zd(3)  := Violation xor DO_zd(3);
    DO_zd(2)  := Violation xor DO_zd(2);
    DO_zd(1)  := Violation xor DO_zd(1);
    DO_zd(0)  := Violation xor DO_zd(0);
    DOP_zd(3) := Violation xor DOP_zd(3);
    DOP_zd(2) := Violation xor DOP_zd(2);
    DOP_zd(1) := Violation xor DOP_zd(1);
    DOP_zd(0) := Violation xor DOP_zd(0);

    VitalPathDelay01 (
      OutSignal     => DOP(3),
      GlitchData    => DOP_GlitchData3,
      OutSignalName => "DOP(3)",
      OutTemp       => DOP_zd(3),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DOP(3), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DOP(3), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOP(2),
      GlitchData    => DOP_GlitchData2,
      OutSignalName => "DOP(2)",
      OutTemp       => DOP_zd(2),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DOP(2), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DOP(2), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOP(1),
      GlitchData    => DOP_GlitchData1,
      OutSignalName => "DOP(1)",
      OutTemp       => DOP_zd(1),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DOP(1), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DOP(1), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOP(0),
      GlitchData    => DOP_GlitchData0,
      OutSignalName => "DOP(0)",
      OutTemp       => DOP_zd(0),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DOP(0), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DOP(0), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(31),
      GlitchData    => DO_GlitchData31,
      OutSignalName => "DO(31)",
      OutTemp       => DO_zd(31),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(31), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(31), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(30),
      GlitchData    => DO_GlitchData30,
      OutSignalName => "DO(30)",
      OutTemp       => DO_zd(30),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(30), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(30), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(29),
      GlitchData    => DO_GlitchData29,
      OutSignalName => "DO(29)",
      OutTemp       => DO_zd(29),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(29), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(29), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(28),
      GlitchData    => DO_GlitchData28,
      OutSignalName => "DO(28)",
      OutTemp       => DO_zd(28),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(28), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(28), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(27),
      GlitchData    => DO_GlitchData27,
      OutSignalName => "DO(27)",
      OutTemp       => DO_zd(27),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(27), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(27), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(26),
      GlitchData    => DO_GlitchData26,
      OutSignalName => "DO(26)",
      OutTemp       => DO_zd(26),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(26), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(26), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(25),
      GlitchData    => DO_GlitchData25,
      OutSignalName => "DO(25)",
      OutTemp       => DO_zd(25),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(25), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(25), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(24),
      GlitchData    => DO_GlitchData24,
      OutSignalName => "DO(24)",
      OutTemp       => DO_zd(24),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(24), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(24), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(23),
      GlitchData    => DO_GlitchData23,
      OutSignalName => "DO(23)",
      OutTemp       => DO_zd(23),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(23), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(23), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(22),
      GlitchData    => DO_GlitchData22,
      OutSignalName => "DO(22)",
      OutTemp       => DO_zd(22),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(22), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(22), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(21),
      GlitchData    => DO_GlitchData21,
      OutSignalName => "DO(21)",
      OutTemp       => DO_zd(21),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(21), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(21), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(20),
      GlitchData    => DO_GlitchData20,
      OutSignalName => "DO(20)",
      OutTemp       => DO_zd(20),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(20), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(20), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(19),
      GlitchData    => DO_GlitchData19,
      OutSignalName => "DO(19)",
      OutTemp       => DO_zd(19),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(19), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(19), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(18),
      GlitchData    => DO_GlitchData18,
      OutSignalName => "DO(18)",
      OutTemp       => DO_zd(18),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(18), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(18), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(17),
      GlitchData    => DO_GlitchData17,
      OutSignalName => "DO(17)",
      OutTemp       => DO_zd(17),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(17), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(17), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(16),
      GlitchData    => DO_GlitchData16,
      OutSignalName => "DO(16)",
      OutTemp       => DO_zd(16),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(16), (EN_dly /= '0' and GSR_dly
                                                             /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(16), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(15),
      GlitchData    => DO_GlitchData15,
      OutSignalName => "DO(15)",
      OutTemp       => DO_zd(15),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(15), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(15), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(14),
      GlitchData    => DO_GlitchData14,
      OutSignalName => "DO(14)",
      OutTemp       => DO_zd(14),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(14), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(14), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(13),
      GlitchData    => DO_GlitchData13,
      OutSignalName => "DO(13)",
      OutTemp       => DO_zd(13),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(13), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(13), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(12),
      GlitchData    => DO_GlitchData12,
      OutSignalName => "DO(12)",
      OutTemp       => DO_zd(12),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(12), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(12), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(11),
      GlitchData    => DO_GlitchData11,
      OutSignalName => "DO(11)",
      OutTemp       => DO_zd(11),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(11), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(11), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(10),
      GlitchData    => DO_GlitchData10,
      OutSignalName => "DO(10)",
      OutTemp       => DO_zd(10),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(10), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(10), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(9),
      GlitchData    => DO_GlitchData9,
      OutSignalName => "DO(9)",
      OutTemp       => DO_zd(9),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(9), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(9), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(8),
      GlitchData    => DO_GlitchData8,
      OutSignalName => "DO(8)",
      OutTemp       => DO_zd(8),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(8), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(8), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(7),
      GlitchData    => DO_GlitchData7,
      OutSignalName => "DO(7)",
      OutTemp       => DO_zd(7),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(7), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(7), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(6),
      GlitchData    => DO_GlitchData6,
      OutSignalName => "DO(6)",
      OutTemp       => DO_zd(6),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(6), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(6), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(5),
      GlitchData    => DO_GlitchData5,
      OutSignalName => "DO(5)",
      OutTemp       => DO_zd(5),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(5), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(5), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(4),
      GlitchData    => DO_GlitchData4,
      OutSignalName => "DO(4)",
      OutTemp       => DO_zd(4),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(4), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(4), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(3),
      GlitchData    => DO_GlitchData3,
      OutSignalName => "DO(3)",
      OutTemp       => DO_zd(3),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(3), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(3), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(2),
      GlitchData    => DO_GlitchData2,
      OutSignalName => "DO(2)",
      OutTemp       => DO_zd(2),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(2), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(2), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(1),
      GlitchData    => DO_GlitchData1,
      OutSignalName => "DO(1)",
      OutTemp       => DO_zd(1),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(1), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(1), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DO(0),
      GlitchData    => DO_GlitchData0,
      OutSignalName => "DO(0)",
      OutTemp       => DO_zd(0),
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_DO(0), (EN_dly /= '0' and GSR_dly /= '1')),
                1   => (GSR_dly'last_event, tpd_GSR_DO(0), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    wait on ADDR_dly, CLK_dly, DI_dly, DIP_dly, EN_dly, GSR_dly, SSR_dly, WE_dly;
  end process VITALBehavior;
end X_RAMB16_S36_V;
-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  16K-Bit Data and 2K-Bit Parity Dual Port Block RAM
-- /___/   /\     Filename : X_RAMB16_S4_S18.vhd
-- \   \  /  \    Timestamp : Thu Apr  8 10:56:56 PDT 2004
--  \___\/\___\
--
-- Revision:
--    03/23/04 - Initial version.
----- CELL x_ramb16_s4_s18 -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;

library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.VPACKAGE.all;
use simprim.VCOMPONENTS.all;

entity X_RAMB16_S4_S18 is
  generic (
    TimingChecksOn : boolean := true;
    Xon            : boolean := true;
    MsgOn          : boolean := true;

    LOC            : string  := "UNPLACED";

    tipd_ADDRA : VitalDelayArrayType01(11 downto 0)  := (others => (0 ps, 0 ps));
    tipd_CLKA  : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_DIA   : VitalDelayArrayType01(3 downto 0) := (others => (0 ps, 0 ps));
    tipd_ENA   : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_SSRA  : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_WEA   : VitalDelayType01                   := ( 0 ps, 0 ps);

    tipd_ADDRB : VitalDelayArrayType01(9 downto 0)  := (others => (0 ps, 0 ps));
    tipd_CLKB  : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_DIB   : VitalDelayArrayType01(15 downto 0) := (others => (0 ps, 0 ps));
    tipd_DIPB  : VitalDelayArrayType01(1 downto 0)  := (others => (0 ps, 0 ps));
    tipd_ENB   : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_SSRB  : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_WEB   : VitalDelayType01                   := ( 0 ps, 0 ps);

    tipd_GSR : VitalDelayType01 := ( 0 ps, 0 ps);

    tpd_GSR_DOA  : VitalDelayArrayType01(3 downto 0) := (others => (0 ps, 0 ps));
    tpd_GSR_DOB  : VitalDelayArrayType01(15 downto 0) := (others => (0 ps, 0 ps));
    tpd_GSR_DOPB : VitalDelayArrayType01(1 downto 0)  := (others => (0 ps, 0 ps));

    tpd_CLKA_DOA  : VitalDelayArrayType01(3 downto 0) := (others => (100 ps, 100 ps));
    tpd_CLKB_DOB  : VitalDelayArrayType01(15 downto 0) := (others => (100 ps, 100 ps));
    tpd_CLKB_DOPB : VitalDelayArrayType01(1 downto 0)  := (others => (100 ps, 100 ps));

    trecovery_GSR_CLKA_negedge_posedge : VitalDelayType                   := 0 ps;
    tsetup_ADDRA_CLKA_negedge_posedge  : VitalDelayArrayType(11 downto 0)  := (others => 0 ps);
    tsetup_ADDRA_CLKA_posedge_posedge  : VitalDelayArrayType(11 downto 0)  := (others => 0 ps);
    tsetup_DIA_CLKA_negedge_posedge    : VitalDelayArrayType(3 downto 0) := (others => 0 ps);
    tsetup_DIA_CLKA_posedge_posedge    : VitalDelayArrayType(3 downto 0) := (others => 0 ps);
    tsetup_ENA_CLKA_negedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_ENA_CLKA_posedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_SSRA_CLKA_negedge_posedge   : VitalDelayType                   := 0 ps;
    tsetup_SSRA_CLKA_posedge_posedge   : VitalDelayType                   := 0 ps;
    tsetup_WEA_CLKA_negedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_WEA_CLKA_posedge_posedge    : VitalDelayType                   := 0 ps;

    trecovery_GSR_CLKB_negedge_posedge : VitalDelayType                   := 0 ps;
    tsetup_ADDRB_CLKB_negedge_posedge  : VitalDelayArrayType(9 downto 0)  := (others => 0 ps);
    tsetup_ADDRB_CLKB_posedge_posedge  : VitalDelayArrayType(9 downto 0)  := (others => 0 ps);
    tsetup_DIB_CLKB_negedge_posedge    : VitalDelayArrayType(15 downto 0) := (others => 0 ps);
    tsetup_DIB_CLKB_posedge_posedge    : VitalDelayArrayType(15 downto 0) := (others => 0 ps);
    tsetup_DIPB_CLKB_negedge_posedge   : VitalDelayArrayType(1 downto 0)  := (others => 0 ps);
    tsetup_DIPB_CLKB_posedge_posedge   : VitalDelayArrayType(1 downto 0)  := (others => 0 ps);
    tsetup_ENB_CLKB_negedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_ENB_CLKB_posedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_SSRB_CLKB_negedge_posedge   : VitalDelayType                   := 0 ps;
    tsetup_SSRB_CLKB_posedge_posedge   : VitalDelayType                   := 0 ps;
    tsetup_WEB_CLKB_negedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_WEB_CLKB_posedge_posedge    : VitalDelayType                   := 0 ps;

    thold_ADDRA_CLKA_negedge_posedge : VitalDelayArrayType(11 downto 0)  := (others => 0 ps);
    thold_ADDRA_CLKA_posedge_posedge : VitalDelayArrayType(11 downto 0)  := (others => 0 ps);
    thold_DIA_CLKA_negedge_posedge   : VitalDelayArrayType(3 downto 0) := (others => 0 ps);
    thold_DIA_CLKA_posedge_posedge   : VitalDelayArrayType(3 downto 0) := (others => 0 ps);
    thold_ENA_CLKA_negedge_posedge   : VitalDelayType                   := 0 ps;
    thold_ENA_CLKA_posedge_posedge   : VitalDelayType                   := 0 ps;
    thold_GSR_CLKA_negedge_posedge   : VitalDelayType                   := 0 ps;
    thold_SSRA_CLKA_negedge_posedge  : VitalDelayType                   := 0 ps;
    thold_SSRA_CLKA_posedge_posedge  : VitalDelayType                   := 0 ps;
    thold_WEA_CLKA_negedge_posedge   : VitalDelayType                   := 0 ps;
    thold_WEA_CLKA_posedge_posedge   : VitalDelayType                   := 0 ps;

    thold_ADDRB_CLKB_negedge_posedge : VitalDelayArrayType(9 downto 0)  := (others => 0 ps);
    thold_ADDRB_CLKB_posedge_posedge : VitalDelayArrayType(9 downto 0)  := (others => 0 ps);
    thold_DIB_CLKB_negedge_posedge   : VitalDelayArrayType(15 downto 0) := (others => 0 ps);
    thold_DIB_CLKB_posedge_posedge   : VitalDelayArrayType(15 downto 0) := (others => 0 ps);
    thold_DIPB_CLKB_negedge_posedge  : VitalDelayArrayType(1 downto 0)  := (others => 0 ps);
    thold_DIPB_CLKB_posedge_posedge  : VitalDelayArrayType(1 downto 0)  := (others => 0 ps);
    thold_ENB_CLKB_negedge_posedge   : VitalDelayType                   := 0 ps;
    thold_ENB_CLKB_posedge_posedge   : VitalDelayType                   := 0 ps;
    thold_GSR_CLKB_negedge_posedge   : VitalDelayType                   := 0 ps;
    thold_SSRB_CLKB_negedge_posedge  : VitalDelayType                   := 0 ps;
    thold_SSRB_CLKB_posedge_posedge  : VitalDelayType                   := 0 ps;
    thold_WEB_CLKB_negedge_posedge   : VitalDelayType                   := 0 ps;
    thold_WEB_CLKB_posedge_posedge   : VitalDelayType                   := 0 ps;

    tbpd_GSR_DOA_CLKA  : VitalDelayArrayType01(3 downto 0) := (others => (0 ps, 0 ps));
    ticd_CLKA          : VitalDelayType                     := 0 ps;
    tisd_ADDRA_CLKA    : VitalDelayArrayType(11 downto 0)    := (others => 0 ps);
    tisd_DIA_CLKA      : VitalDelayArrayType(3 downto 0)   := (others => 0 ps);
    tisd_ENA_CLKA      : VitalDelayType                     := 0 ps;
    tisd_GSR_CLKA      : VitalDelayType                     := 0 ps;
    tisd_SSRA_CLKA     : VitalDelayType                     := 0 ps;
    tisd_WEA_CLKA      : VitalDelayType                     := 0 ps;

    tbpd_GSR_DOB_CLKB  : VitalDelayArrayType01(15 downto 0) := (others => (0 ps, 0 ps));
    tbpd_GSR_DOPB_CLKB : VitalDelayArrayType01(1 downto 0)  := (others => (0 ps, 0 ps));
    ticd_CLKB          : VitalDelayType                     := 0 ps;
    tisd_ADDRB_CLKB    : VitalDelayArrayType(9 downto 0)    := (others => 0 ps);
    tisd_DIB_CLKB      : VitalDelayArrayType(15 downto 0)   := (others => 0 ps);
    tisd_DIPB_CLKB     : VitalDelayArrayType(1 downto 0)    := (others => 0 ps);
    tisd_ENB_CLKB      : VitalDelayType                     := 0 ps;
    tisd_GSR_CLKB      : VitalDelayType                     := 0 ps;
    tisd_SSRB_CLKB     : VitalDelayType                     := 0 ps;
    tisd_WEB_CLKB      : VitalDelayType                     := 0 ps;

    tpw_CLKA_negedge : VitalDelayType := 0 ps;
    tpw_CLKA_posedge : VitalDelayType := 0 ps;
    tpw_CLKB_negedge : VitalDelayType := 0 ps;
    tpw_CLKB_posedge : VitalDelayType := 0 ps;
    tpw_GSR_posedge  : VitalDelayType := 0 ps;

    INITP_00 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_01 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_02 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_03 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_04 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_05 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_06 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_07 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";

    INIT_00  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_01  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_02  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_03  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_04  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_05  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_06  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_07  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_08  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_09  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0A  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0B  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0C  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0D  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0E  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0F  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_10  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_11  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_12  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_13  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_14  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_15  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_16  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_17  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_18  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_19  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1A  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1B  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1C  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1D  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1E  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1F  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_20  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_21  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_22  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_23  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_24  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_25  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_26  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_27  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_28  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_29  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2A  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2B  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2C  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2D  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2E  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2F  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_30  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_31  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_32  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_33  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_34  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_35  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_36  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_37  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_38  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_39  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3A  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3B  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3C  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3D  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3E  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3F  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_A : bit_vector := X"0";
    INIT_B : bit_vector := X"00000";

    SRVAL_A : bit_vector := X"0";
    SRVAL_B : bit_vector := X"00000";

    SETUP_ALL        : VitalDelayType := 1000 ps;
    SETUP_READ_FIRST : VitalDelayType := 3000 ps;

    SIM_COLLISION_CHECK : string := "ALL";

    WRITE_MODE_A : string := "WRITE_FIRST";
    WRITE_MODE_B : string := "WRITE_FIRST"

    );

  port(
    DOA   : out std_logic_vector (3 downto 0);
    DOB   : out std_logic_vector (15 downto 0);
    DOPB  : out std_logic_vector (1 downto 0);

    ADDRA : in  std_logic_vector (11 downto 0);
    ADDRB : in  std_logic_vector (9 downto 0);
    CLKA  : in  std_ulogic;
    CLKB  : in  std_ulogic;
    DIA   : in  std_logic_vector (3 downto 0);
    DIB   : in  std_logic_vector (15 downto 0);
    DIPB  : in  std_logic_vector (1 downto 0);
    ENA   : in  std_ulogic;
    ENB   : in  std_ulogic;
    SSRA  : in  std_ulogic;
    SSRB  : in  std_ulogic;
    WEA   : in  std_ulogic;
    WEB   : in  std_ulogic
    );

  attribute VITAL_LEVEL0 of
    X_RAMB16_S4_S18 : entity is true;
end x_ramb16_s4_s18;

architecture X_RAMB16_S4_S18_V of X_RAMB16_S4_S18 is

  attribute VITAL_LEVEL0 of
    X_RAMB16_S4_S18_V : architecture is true;

  signal ADDRA_ipd : std_logic_vector(11 downto 0)  := (others => 'X');
  signal CLKA_ipd  : std_ulogic                    := 'X';
  signal DIA_ipd   : std_logic_vector(3 downto 0) := (others => 'X');
  signal ENA_ipd   : std_ulogic                    := 'X';
  signal SSRA_ipd  : std_ulogic                    := 'X';
  signal WEA_ipd   : std_ulogic                    := 'X';

  signal ADDRB_ipd : std_logic_vector(9 downto 0)  := (others => 'X');
  signal CLKB_ipd  : std_ulogic                    := 'X';
  signal DIB_ipd   : std_logic_vector(15 downto 0) := (others => 'X');
  signal DIPB_ipd  : std_logic_vector(1 downto 0)  := (others => 'X');
  signal ENB_ipd   : std_ulogic                    := 'X';
  signal SSRB_ipd  : std_ulogic                    := 'X';
  signal WEB_ipd   : std_ulogic                    := 'X';

  signal GSR_ipd : std_ulogic := 'X';

  signal ADDRA_dly    : std_logic_vector(11 downto 0)  := (others => 'X');
  signal CLKA_dly     : std_ulogic                    := 'X';
  signal DIA_dly      : std_logic_vector(3 downto 0) := (others => 'X');
  signal ENA_dly      : std_ulogic                    := 'X';
  signal GSR_CLKA_dly : std_ulogic                    := 'X';
  signal SSRA_dly     : std_ulogic                    := 'X';
  signal WEA_dly      : std_ulogic                    := 'X';

  signal ADDRB_dly    : std_logic_vector(9 downto 0)  := (others => 'X');
  signal CLKB_dly     : std_ulogic                    := 'X';
  signal DIB_dly      : std_logic_vector(15 downto 0) := (others => 'X');
  signal DIPB_dly     : std_logic_vector(1 downto 0)  := (others => 'X');
  signal ENB_dly      : std_ulogic                    := 'X';
  signal GSR_CLKB_dly : std_ulogic                    := 'X';
  signal SSRB_dly     : std_ulogic                    := 'X';
  signal WEB_dly      : std_ulogic                    := 'X';
  constant length_a : integer := 4096;
  constant length_b : integer := 1024;  
  constant width_a : integer := 4;
  constant width_b : integer := 16;  

  constant parity_width_a : integer := 0;
  constant parity_width_b : integer := 2;
  
  type Two_D_array_type is array ((length_b -  1) downto 0) of std_logic_vector((width_b - 1) downto 0);
  type Two_D_parity_array_type is array ((length_b - 1) downto 0) of std_logic_vector((parity_width_b - 1)downto 0);    

  function slv_to_two_D_array(
    slv_length : integer;
    slv_width : integer;
    SLV : in std_logic_vector
    )
    return two_D_array_type is
    variable two_D_array : two_D_array_type;
    variable intermediate : std_logic_vector((slv_width - 1) downto 0);
  begin
    for i in 0 to (slv_length - 1)loop
      intermediate := SLV(((i*slv_width) + (slv_width - 1)) downto (i* slv_width));
      two_D_array(i) := intermediate; 
    end loop;
    return two_D_array;
  end;

  function slv_to_two_D_parity_array(
    slv_length : integer;
    slv_width : integer;
    SLV : in std_logic_vector
    )
    return two_D_parity_array_type is
    variable two_D_parity_array : two_D_parity_array_type;
    variable intermediate : std_logic_vector((slv_width - 1) downto 0);
  begin
    for i in 0 to (slv_length - 1)loop
      intermediate := SLV(((i*slv_width) + (slv_width - 1)) downto (i* slv_width));
      two_D_parity_array(i) := intermediate; 
    end loop;
    return two_D_parity_array;
  end;          
begin
  WireDelay     : block
  begin
    ADDRA_DELAY : for i in 11 downto 0 generate
      VitalWireDelay (ADDRA_ipd(i), ADDRA(i), tipd_ADDRA(i));
    end generate ADDRA_DELAY;
    VitalWireDelay (CLKA_ipd, CLKA, tipd_CLKA);
    DIA_DELAY   : for i in 3 downto 0 generate
      VitalWireDelay (DIA_ipd(i), DIA(i), tipd_DIA(i));
    end generate DIA_DELAY;
    VitalWireDelay (ENA_ipd, ENA, tipd_ENA);
    VitalWireDelay (SSRA_ipd, SSRA, tipd_SSRA);
    VitalWireDelay (WEA_ipd, WEA, tipd_WEA);
    ADDRB_DELAY : for i in 9 downto 0 generate
      VitalWireDelay (ADDRB_ipd(i), ADDRB(i), tipd_ADDRB(i));
    end generate ADDRB_DELAY;
    VitalWireDelay (CLKB_ipd, CLKB, tipd_CLKB);
    DIB_DELAY   : for i in 15 downto 0 generate
      VitalWireDelay (DIB_ipd(i), DIB(i), tipd_DIB(i));
    end generate DIB_DELAY;
    DIPB_DELAY  : for i in 1 downto 0 generate
      VitalWireDelay (DIPB_ipd(i), DIPB(i), tipd_DIPB(i));
    end generate DIPB_DELAY;
    VitalWireDelay (ENB_ipd, ENB, tipd_ENB);
    VitalWireDelay (SSRB_ipd, SSRB, tipd_SSRB);
    VitalWireDelay (WEB_ipd, WEB, tipd_WEB);
    VitalWireDelay (GSR_ipd, GSR, tipd_GSR);
  end block;

  SignalDelay   : block
  begin
    ADDRA_DELAY : for i in 11 downto 0 generate
      VitalSignalDelay (ADDRA_dly(i), ADDRA_ipd(i), tisd_ADDRA_CLKA(i));
    end generate ADDRA_DELAY;
    VitalSignalDelay (CLKA_dly, CLKA_ipd, ticd_CLKA);
    DIA_DELAY   : for i in 3 downto 0 generate
      VitalSignalDelay (DIA_dly(i), DIA_ipd(i), tisd_DIA_CLKA(i));
    end generate DIA_DELAY;
    VitalSignalDelay (ENA_dly, ENA_ipd, tisd_ENA_CLKA);
    VitalSignalDelay (GSR_CLKA_dly, GSR_ipd, tisd_GSR_CLKA);
    VitalSignalDelay (SSRA_dly, SSRA_ipd, tisd_SSRA_CLKA);
    VitalSignalDelay (WEA_dly, WEA_ipd, tisd_WEA_CLKA);

    ADDRB_DELAY : for i in 9 downto 0 generate
      VitalSignalDelay (ADDRB_dly(i), ADDRB_ipd(i), tisd_ADDRB_CLKB(i));
    end generate ADDRB_DELAY;
    VitalSignalDelay (CLKB_dly, CLKB_ipd, ticd_CLKB);
    DIB_DELAY   : for i in 15 downto 0 generate
      VitalSignalDelay (DIB_dly(i), DIB_ipd(i), tisd_DIB_CLKB(i));
    end generate DIB_DELAY;
    DIPB_DELAY  : for i in 1 downto 0 generate
      VitalSignalDelay (DIPB_dly(i), DIPB_ipd(i), tisd_DIPB_CLKB(i));
    end generate DIPB_DELAY;
    VitalSignalDelay (ENB_dly, ENB_ipd, tisd_ENB_CLKB);
    VitalSignalDelay (GSR_CLKB_dly, GSR_ipd, tisd_GSR_CLKB);
    VitalSignalDelay (SSRB_dly, SSRB_ipd, tisd_SSRB_CLKB);
    VitalSignalDelay (WEB_dly, WEB_ipd, tisd_WEB_CLKB);
  end block;

  VITALBehavior                        : process
    variable Tviol_ADDRA0_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA1_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA2_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA3_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA4_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA5_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA6_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA7_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA8_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA9_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA10_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA11_CLKA_posedge : std_ulogic := '0';
    variable Tviol_DIA0_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA1_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA2_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA3_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_ENA_CLKA_posedge    : std_ulogic := '0';
    variable Tviol_GSR_CLKA_posedge    : std_ulogic := '0';
    variable Tviol_SSRA_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_WEA_CLKA_posedge    : std_ulogic := '0';

    variable Tviol_ADDRB0_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB1_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB2_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB3_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB4_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB5_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB6_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB7_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB8_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB9_CLKB_posedge : std_ulogic := '0';
    variable Tviol_DIB0_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB1_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB2_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB3_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB4_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB5_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB6_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB7_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB8_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB9_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB10_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB11_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB12_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB13_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB14_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB15_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIPB0_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIPB1_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_ENB_CLKB_posedge    : std_ulogic := '0';
    variable Tviol_GSR_CLKB_posedge    : std_ulogic := '0';
    variable Tviol_SSRB_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_WEB_CLKB_posedge    : std_ulogic := '0';

    variable Tviol_CLKA_CLKB_all        : std_ulogic := '0';
    variable Tviol_CLKA_CLKB_read_first : std_ulogic := '0';
    variable Tviol_CLKB_CLKA_all        : std_ulogic := '0';
    variable Tviol_CLKB_CLKA_read_first : std_ulogic := '0';

    variable Tmkr_ADDRA0_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA1_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA2_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA3_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA4_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA5_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA6_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA7_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA8_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA9_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA10_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA11_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA0_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA1_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA2_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA3_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ENA_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_GSR_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_SSRA_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_WEA_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;

    variable Tmkr_ADDRB0_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB1_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB2_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB3_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB4_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB5_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB6_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB7_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB8_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB9_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB0_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB1_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB2_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB3_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB4_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB5_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB6_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB7_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB8_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB9_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB10_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB11_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB12_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB13_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB14_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB15_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIPB0_CLKB_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIPB1_CLKB_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ENB_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_GSR_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_SSRB_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_WEB_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;

    variable Tmkr_CLKA_CLKB_all        : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_CLKA_CLKB_read_first : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_CLKB_CLKA_all        : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_CLKB_CLKA_read_first : VitalTimingDataType := VitalTimingDataInit;

    variable PViol_GSR : std_ulogic          := '0';
    variable PInfo_GSR : VitalPeriodDataType := VitalPeriodDataInit;

    variable PViol_CLKA, PViol_CLKB : std_ulogic          := '0';
    variable PInfo_CLKA, PInfo_CLKB : VitalPeriodDataType := VitalPeriodDataInit;

    variable DOA_GlitchData0  : VitalGlitchDataType;
    variable DOA_GlitchData1  : VitalGlitchDataType;
    variable DOA_GlitchData2  : VitalGlitchDataType;
    variable DOA_GlitchData3  : VitalGlitchDataType;

    variable DOB_GlitchData0  : VitalGlitchDataType;
    variable DOB_GlitchData1  : VitalGlitchDataType;
    variable DOB_GlitchData2  : VitalGlitchDataType;
    variable DOB_GlitchData3  : VitalGlitchDataType;
    variable DOB_GlitchData4  : VitalGlitchDataType;
    variable DOB_GlitchData5  : VitalGlitchDataType;
    variable DOB_GlitchData6  : VitalGlitchDataType;
    variable DOB_GlitchData7  : VitalGlitchDataType;
    variable DOB_GlitchData8  : VitalGlitchDataType;
    variable DOB_GlitchData9  : VitalGlitchDataType;
    variable DOB_GlitchData10  : VitalGlitchDataType;
    variable DOB_GlitchData11  : VitalGlitchDataType;
    variable DOB_GlitchData12  : VitalGlitchDataType;
    variable DOB_GlitchData13  : VitalGlitchDataType;
    variable DOB_GlitchData14  : VitalGlitchDataType;
    variable DOB_GlitchData15  : VitalGlitchDataType;
    variable DOPB_GlitchData0 : VitalGlitchDataType;
    variable DOPB_GlitchData1 : VitalGlitchDataType;

    variable mem_slv : std_logic_vector(16383 downto 0) := To_StdLogicVector(INIT_3F) &
                                                       To_StdLogicVector(INIT_3E) &
                                                       To_StdLogicVector(INIT_3D) &
                                                       To_StdLogicVector(INIT_3C) &
                                                       To_StdLogicVector(INIT_3B) &
                                                       To_StdLogicVector(INIT_3A) &
                                                       To_StdLogicVector(INIT_39) &
                                                       To_StdLogicVector(INIT_38) &
                                                       To_StdLogicVector(INIT_37) &
                                                       To_StdLogicVector(INIT_36) &
                                                       To_StdLogicVector(INIT_35) &
                                                       To_StdLogicVector(INIT_34) &
                                                       To_StdLogicVector(INIT_33) &
                                                       To_StdLogicVector(INIT_32) &
                                                       To_StdLogicVector(INIT_31) &
                                                       To_StdLogicVector(INIT_30) &
                                                       To_StdLogicVector(INIT_2F) &
                                                       To_StdLogicVector(INIT_2E) &
                                                       To_StdLogicVector(INIT_2D) &
                                                       To_StdLogicVector(INIT_2C) &
                                                       To_StdLogicVector(INIT_2B) &
                                                       To_StdLogicVector(INIT_2A) &
                                                       To_StdLogicVector(INIT_29) &
                                                       To_StdLogicVector(INIT_28) &
                                                       To_StdLogicVector(INIT_27) &
                                                       To_StdLogicVector(INIT_26) &
                                                       To_StdLogicVector(INIT_25) &
                                                       To_StdLogicVector(INIT_24) &
                                                       To_StdLogicVector(INIT_23) &
                                                       To_StdLogicVector(INIT_22) &
                                                       To_StdLogicVector(INIT_21) &
                                                       To_StdLogicVector(INIT_20) &
                                                       To_StdLogicVector(INIT_1F) &
                                                       To_StdLogicVector(INIT_1E) &
                                                       To_StdLogicVector(INIT_1D) &
                                                       To_StdLogicVector(INIT_1C) &
                                                       To_StdLogicVector(INIT_1B) &
                                                       To_StdLogicVector(INIT_1A) &
                                                       To_StdLogicVector(INIT_19) &
                                                       To_StdLogicVector(INIT_18) &
                                                       To_StdLogicVector(INIT_17) &
                                                       To_StdLogicVector(INIT_16) &
                                                       To_StdLogicVector(INIT_15) &
                                                       To_StdLogicVector(INIT_14) &
                                                       To_StdLogicVector(INIT_13) &
                                                       To_StdLogicVector(INIT_12) &
                                                       To_StdLogicVector(INIT_11) &
                                                       To_StdLogicVector(INIT_10) &
                                                       To_StdLogicVector(INIT_0F) &
                                                       To_StdLogicVector(INIT_0E) &
                                                       To_StdLogicVector(INIT_0D) &
                                                       To_StdLogicVector(INIT_0C) &
                                                       To_StdLogicVector(INIT_0B) &
                                                       To_StdLogicVector(INIT_0A) &
                                                       To_StdLogicVector(INIT_09) &
                                                       To_StdLogicVector(INIT_08) &
                                                       To_StdLogicVector(INIT_07) &
                                                       To_StdLogicVector(INIT_06) &
                                                       To_StdLogicVector(INIT_05) &
                                                       To_StdLogicVector(INIT_04) &
                                                       To_StdLogicVector(INIT_03) &
                                                       To_StdLogicVector(INIT_02) &
                                                       To_StdLogicVector(INIT_01) &
                                                       To_StdLogicVector(INIT_00);
    variable memp_slv : std_logic_vector(2047 downto 0) := To_StdLogicVector(INITP_07) &
                                                       To_StdLogicVector(INITP_06) &
                                                       To_StdLogicVector(INITP_05) &
                                                       To_StdLogicVector(INITP_04) &
                                                       To_StdLogicVector(INITP_03) &
                                                       To_StdLogicVector(INITP_02) &
                                                       To_StdLogicVector(INITP_01) &
                                                       To_StdLogicVector(INITP_00);
    variable mem : Two_D_array_type := slv_to_two_D_array(length_b, width_b, mem_slv);
    variable memp : Two_D_parity_array_type := slv_to_two_D_parity_array(length_b, parity_width_b, memp_slv);
    variable INIT_A_reg         : std_logic_vector (3 downto 0) := "0000";
    variable INIT_B_reg         : std_logic_vector (17 downto 0) := "000000000000000000";
    variable ADDRA_dly_sampled : std_logic_vector(11 downto 0)   := (others => 'X');
    variable ADDRB_dly_sampled : std_logic_vector(9 downto 0)   := (others => 'X');
    variable ADDRESS_A         : integer;
    variable ADDRESS_B         : integer;
    variable DOA_OV_LSB        : integer;
    variable DOA_OV_MSB        : integer;
    variable DOA_zd            : std_logic_vector(3 downto 0);
    variable DOB_OV_LSB        : integer;
    variable DOB_OV_MSB        : integer;
    variable DOB_zd            : std_logic_vector(15 downto 0);
    variable DOPA_OV_LSB       : integer;
    variable DOPA_OV_MSB       : integer;
    variable DOPB_OV_LSB       : integer;
    variable DOPB_OV_MSB       : integer;
    variable DOPB_zd           : std_logic_vector(1 downto 0);
    variable ENA_dly_sampled   : std_ulogic                      := 'X';
    variable ENB_dly_sampled   : std_ulogic                      := 'X';
    variable FIRST_TIME        : boolean                        := true;
    variable HAS_OVERLAP       : boolean                        := false;
    variable HAS_OVERLAP_P     : boolean                        := false;
    variable OLPP_LSB          : integer;
    variable OLPP_MSB          : integer;
    variable OLP_LSB           : integer;
    variable OLP_MSB           : integer;
    variable SRVAL_A_reg            : std_logic_vector (3 downto 0) := "0000";
    variable SRVAL_B_reg            : std_logic_vector (17 downto 0) := "000000000000000000";
    variable SSRA_dly_sampled  : std_ulogic                      := 'X';
    variable SSRB_dly_sampled  : std_ulogic                      := 'X';
    variable VALID_ADDRA       : boolean                        := false;
    variable VALID_ADDRB       : boolean                        := false;
    variable WR_A_LATER        : boolean                        := false;
    variable WR_B_LATER        : boolean                        := false;
    variable ViolationA        : std_ulogic                     := '0';
    variable ViolationB        : std_ulogic                     := '0';
    variable ViolationCLKAB    : std_ulogic                     := '0';
    variable ViolationCLKAB_S0 : boolean                        := false;
    variable Violation_S1      : boolean                        := false;
    variable Violation_S3      : boolean                        := false;
    variable WEA_dly_sampled   : std_ulogic                      := 'X';
    variable WEB_dly_sampled   : std_ulogic                      := 'X';
    variable wr_mode_a         : integer                        := 0;
    variable wr_mode_b         : integer                        := 0;
    variable collision_type : integer := 3;

  begin
    if (FIRST_TIME) then
      if ((SIM_COLLISION_CHECK = "none") or (SIM_COLLISION_CHECK = "NONE"))  then
        collision_type := 0;
      elsif ((SIM_COLLISION_CHECK = "warning_only") or (SIM_COLLISION_CHECK = "WARNING_ONLY"))  then
        collision_type := 1;
      elsif ((SIM_COLLISION_CHECK = "generate_x_only") or (SIM_COLLISION_CHECK = "GENERATE_X_ONLY"))  then
        collision_type := 2;
      elsif ((SIM_COLLISION_CHECK = "all") or (SIM_COLLISION_CHECK = "ALL"))  then        
        collision_type := 3;
      else
        GenericValueCheckMessage
          (HeaderMsg => "Attribute Syntax Error",
           GenericName => "SIM_COLLISION_CHECK",
           EntityName => "X_RAMB16_S4_S18",
           GenericValue => SIM_COLLISION_CHECK,
           Unit => "",
           ExpectedValueMsg => "Legal Values for this attribute are ALL, NONE, WARNING_ONLY or GENERATE_X_ONLY",
           ExpectedGenericValue => "",
           TailMsg => "",
           MsgSeverity => error
           );
      end if;
      if (INIT_A'length > 4) then
        INIT_A_reg(3 downto 0)        := To_StdLogicVector(INIT_A)(3 downto 0);
      else
        INIT_A_reg(INIT_A'length-1 downto 0)         := To_StdLogicVector(INIT_A);
      end if;
      DOA_zd(3 downto 0)                       := INIT_A_reg(3 downto 0);
      DOA  <= DOA_zd;

      if (INIT_B'length > 18) then
        INIT_B_reg(17 downto 0)        := To_StdLogicVector(INIT_B)(17 downto 0);
      else
        INIT_B_reg(INIT_B'length-1 downto 0)         := To_StdLogicVector(INIT_B);
      end if;
      DOB_zd(15 downto 0)                       := INIT_B_reg(15 downto 0);
      DOPB_zd(1 downto 0)                       := INIT_B_reg(17 downto 16);
      DOB  <= DOB_zd;
      DOPB <= DOPB_zd;

      if (SRVAL_A'length > 4) then
        SRVAL_A_reg(3 downto 0)        := To_StdLogicVector(SRVAL_A)(3 downto 0);
      else
        SRVAL_A_reg(SRVAL_A'length-1 downto 0)         := To_StdLogicVector(SRVAL_A);
      end if;
      if (SRVAL_B'length > 18) then
        SRVAL_B_reg(17 downto 0)        := To_StdLogicVector(SRVAL_B)(17 downto 0);
      else
        SRVAL_B_reg(SRVAL_B'length-1 downto 0)         := To_StdLogicVector(SRVAL_B);
      end if;
      if ((WRITE_MODE_A = "write_first") or (WRITE_MODE_A = "WRITE_FIRST")) then
        wr_mode_a := 0;
      elsif ((WRITE_MODE_A = "read_first") or (WRITE_MODE_A = "READ_FIRST")) then
        wr_mode_a := 1;
      elsif ((WRITE_MODE_A = "no_change") or (WRITE_MODE_A = "NO_CHANGE")) then
        wr_mode_a := 2;
      else
        GenericValueCheckMessage
          ( HeaderMsg            => " Attribute Syntax Error ",
            GenericName          => " WRITE_MODE_A ",
            EntityName           => "/X_RAMB16_S4_S18",
            GenericValue         => WRITE_MODE_A,
            Unit                 => "",
            ExpectedValueMsg     => " The Legal values for this attribute are ",
            ExpectedGenericValue => " WRITE_FIRST, READ_FIRST or NO_CHANGE ",
            TailMsg              => "",
            MsgSeverity          => error
            );
      end if;

      if ((WRITE_MODE_B = "write_first") or (WRITE_MODE_B = "WRITE_FIRST")) then
        wr_mode_b := 0;
      elsif ((WRITE_MODE_B = "read_first") or (WRITE_MODE_B = "READ_FIRST")) then
        wr_mode_b := 1;
      elsif ((WRITE_MODE_B = "no_change") or (WRITE_MODE_B = "NO_CHANGE")) then
        wr_mode_b := 2;
      else
        GenericValueCheckMessage
          ( HeaderMsg            => " Attribute Syntax Error ",
            GenericName          => " WRITE_MODE_B ",
            EntityName           => "/X_RAMB16_S4_S18",
            GenericValue         => WRITE_MODE_B,
            Unit                 => "",
            ExpectedValueMsg     => " The Legal values for this attribute are ",
            ExpectedGenericValue => " WRITE_FIRST, READ_FIRST or NO_CHANGE ",
            TailMsg              => "",
            MsgSeverity          => error
            );
      end if;
      FIRST_TIME  := false;
    end if;

    if (CLKA_dly'event) then
      ENA_dly_sampled   := ENA_dly;
      SSRA_dly_sampled  := SSRA_dly;
      WEA_dly_sampled   := WEA_dly;
      ADDRA_dly_sampled := ADDRA_dly;
    end if;

    if (CLKB_dly'event) then
      ENB_dly_sampled   := ENB_dly;
      SSRB_dly_sampled  := SSRB_dly;
      WEB_dly_sampled   := WEB_dly;
      ADDRB_dly_sampled := ADDRB_dly;
    end if;
    if (TimingChecksOn) then
      VitalRecoveryRemovalCheck (
        Violation      => Tviol_GSR_CLKA_posedge,
        TimingData     => Tmkr_GSR_CLKA_posedge,
        TestSignal     => GSR_CLKA_dly,
        TestSignalName => "GSR",
        TestDelay      => tisd_GSR_CLKA,
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        Recovery       => trecovery_GSR_CLKA_negedge_posedge,
        Removal        => thold_GSR_CLKA_negedge_posedge,
        ActiveLow      => false,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ENA_CLKA_posedge,
        TimingData     => Tmkr_ENA_CLKA_posedge,
        TestSignal     => ENA_dly,
        TestSignalName => "ENA",
        TestDelay      => tisd_ENA_CLKA,
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ENA_CLKA_posedge_posedge,
        SetupLow       => tsetup_ENA_CLKA_negedge_posedge,
        HoldLow        => thold_ENA_CLKA_negedge_posedge,
        HoldHigh       => thold_ENA_CLKA_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_SSRA_CLKA_posedge,
        TimingData     => Tmkr_SSRA_CLKA_posedge,
        TestSignal     => SSRA_dly,
        TestSignalName => "SSRA",
        TestDelay      => tisd_SSRA_CLKA,
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_SSRA_CLKA_posedge_posedge,
        SetupLow       => tsetup_SSRA_CLKA_negedge_posedge,
        HoldLow        => thold_SSRA_CLKA_negedge_posedge,
        HoldHigh       => thold_SSRA_CLKA_posedge_posedge,
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_WEA_CLKA_posedge,
        TimingData     => Tmkr_WEA_CLKA_posedge,
        TestSignal     => WEA_dly,
        TestSignalName => "WEA",
        TestDelay      => tisd_WEA_CLKA,
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_WEA_CLKA_posedge_posedge,
        SetupLow       => tsetup_WEA_CLKA_negedge_posedge,
        HoldLow        => thold_WEA_CLKA_negedge_posedge,
        HoldHigh       => thold_WEA_CLKA_posedge_posedge,
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA0_CLKA_posedge,
        TimingData     => Tmkr_ADDRA0_CLKA_posedge,
        TestSignal     => ADDRA_dly(0),
        TestSignalName => "ADDRA(0)",
        TestDelay      => tisd_ADDRA_CLKA(0),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(0),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(0),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(0),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(0),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA1_CLKA_posedge,
        TimingData     => Tmkr_ADDRA1_CLKA_posedge,
        TestSignal     => ADDRA_dly(1),
        TestSignalName => "ADDRA(1)",
        TestDelay      => tisd_ADDRA_CLKA(1),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(1),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(1),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(1),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(1),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA2_CLKA_posedge,
        TimingData     => Tmkr_ADDRA2_CLKA_posedge,
        TestSignal     => ADDRA_dly(2),
        TestSignalName => "ADDRA(2)",
        TestDelay      => tisd_ADDRA_CLKA(2),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(2),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(2),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(2),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(2),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA3_CLKA_posedge,
        TimingData     => Tmkr_ADDRA3_CLKA_posedge,
        TestSignal     => ADDRA_dly(3),
        TestSignalName => "ADDRA(3)",
        TestDelay      => tisd_ADDRA_CLKA(3),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(3),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(3),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(3),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(3),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA4_CLKA_posedge,
        TimingData     => Tmkr_ADDRA4_CLKA_posedge,
        TestSignal     => ADDRA_dly(4),
        TestSignalName => "ADDRA(4)",
        TestDelay      => tisd_ADDRA_CLKA(4),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(4),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(4),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(4),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(4),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA5_CLKA_posedge,
        TimingData     => Tmkr_ADDRA5_CLKA_posedge,
        TestSignal     => ADDRA_dly(5),
        TestSignalName => "ADDRA(5)",
        TestDelay      => tisd_ADDRA_CLKA(5),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(5),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(5),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(5),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(5),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA6_CLKA_posedge,
        TimingData     => Tmkr_ADDRA6_CLKA_posedge,
        TestSignal     => ADDRA_dly(6),
        TestSignalName => "ADDRA(6)",
        TestDelay      => tisd_ADDRA_CLKA(6),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(6),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(6),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(6),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(6),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA7_CLKA_posedge,
        TimingData     => Tmkr_ADDRA7_CLKA_posedge,
        TestSignal     => ADDRA_dly(7),
        TestSignalName => "ADDRA(7)",
        TestDelay      => tisd_ADDRA_CLKA(7),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(7),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(7),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(7),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(7),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA8_CLKA_posedge,
        TimingData     => Tmkr_ADDRA8_CLKA_posedge,
        TestSignal     => ADDRA_dly(8),
        TestSignalName => "ADDRA(8)",
        TestDelay      => tisd_ADDRA_CLKA(8),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(8),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(8),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(8),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(8),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA9_CLKA_posedge,
        TimingData     => Tmkr_ADDRA9_CLKA_posedge,
        TestSignal     => ADDRA_dly(9),
        TestSignalName => "ADDRA(9)",
        TestDelay      => tisd_ADDRA_CLKA(9),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(9),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(9),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(9),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(9),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA10_CLKA_posedge,
        TimingData     => Tmkr_ADDRA10_CLKA_posedge,
        TestSignal     => ADDRA_dly(10),
        TestSignalName => "ADDRA(10)",
        TestDelay      => tisd_ADDRA_CLKA(10),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(10),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(10),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(10),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(10),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA11_CLKA_posedge,
        TimingData     => Tmkr_ADDRA11_CLKA_posedge,
        TestSignal     => ADDRA_dly(11),
        TestSignalName => "ADDRA(11)",
        TestDelay      => tisd_ADDRA_CLKA(11),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(11),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(11),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(11),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(11),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA0_CLKA_posedge,
        TimingData     => Tmkr_DIA0_CLKA_posedge,
        TestSignal     => DIA_dly(0),
        TestSignalName => "DIA(0)",
        TestDelay      => tisd_DIA_CLKA(0),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(0),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(0),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(0),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(0),
        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA1_CLKA_posedge,
        TimingData     => Tmkr_DIA1_CLKA_posedge,
        TestSignal     => DIA_dly(1),
        TestSignalName => "DIA(1)",
        TestDelay      => tisd_DIA_CLKA(1),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(1),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(1),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(1),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(1),
        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA2_CLKA_posedge,
        TimingData     => Tmkr_DIA2_CLKA_posedge,
        TestSignal     => DIA_dly(2),
        TestSignalName => "DIA(2)",
        TestDelay      => tisd_DIA_CLKA(2),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(2),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(2),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(2),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(2),
        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA3_CLKA_posedge,
        TimingData     => Tmkr_DIA3_CLKA_posedge,
        TestSignal     => DIA_dly(3),
        TestSignalName => "DIA(3)",
        TestDelay      => tisd_DIA_CLKA(3),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(3),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(3),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(3),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(3),
        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalRecoveryRemovalCheck (
        Violation      => Tviol_GSR_CLKB_posedge,
        TimingData     => Tmkr_GSR_CLKB_posedge,
        TestSignal     => GSR_CLKB_dly,
        TestSignalName => "GSR",
        TestDelay      => tisd_GSR_CLKB,
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        Recovery       => trecovery_GSR_CLKB_negedge_posedge,
        Removal        => thold_GSR_CLKB_negedge_posedge,
        ActiveLow      => false,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ENB_CLKB_posedge,
        TimingData     => Tmkr_ENB_CLKB_posedge,
        TestSignal     => ENB_dly,
        TestSignalName => "ENB",
        TestDelay      => tisd_ENB_CLKB,
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ENB_CLKB_posedge_posedge,
        SetupLow       => tsetup_ENB_CLKB_negedge_posedge,
        HoldLow        => thold_ENB_CLKB_negedge_posedge,
        HoldHigh       => thold_ENB_CLKB_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_SSRB_CLKB_posedge,
        TimingData     => Tmkr_SSRB_CLKB_posedge,
        TestSignal     => SSRB_dly,
        TestSignalName => "SSRB",
        TestDelay      => tisd_SSRB_CLKB,
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_SSRB_CLKB_posedge_posedge,
        SetupLow       => tsetup_SSRB_CLKB_negedge_posedge,
        HoldLow        => thold_SSRB_CLKB_negedge_posedge,
        HoldHigh       => thold_SSRB_CLKB_posedge_posedge,
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_WEB_CLKB_posedge,
        TimingData     => Tmkr_WEB_CLKB_posedge,
        TestSignal     => WEB_dly,
        TestSignalName => "WEB",
        TestDelay      => tisd_WEB_CLKB,
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_WEB_CLKB_posedge_posedge,
        SetupLow       => tsetup_WEB_CLKB_negedge_posedge,
        HoldLow        => thold_WEB_CLKB_negedge_posedge,
        HoldHigh       => thold_WEB_CLKB_posedge_posedge,
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB0_CLKB_posedge,
        TimingData     => Tmkr_ADDRB0_CLKB_posedge,
        TestSignal     => ADDRB_dly(0),
        TestSignalName => "ADDRB(0)",
        TestDelay      => tisd_ADDRB_CLKB(0),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(0),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(0),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(0),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(0),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB1_CLKB_posedge,
        TimingData     => Tmkr_ADDRB1_CLKB_posedge,
        TestSignal     => ADDRB_dly(1),
        TestSignalName => "ADDRB(1)",
        TestDelay      => tisd_ADDRB_CLKB(1),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(1),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(1),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(1),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(1),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB2_CLKB_posedge,
        TimingData     => Tmkr_ADDRB2_CLKB_posedge,
        TestSignal     => ADDRB_dly(2),
        TestSignalName => "ADDRB(2)",
        TestDelay      => tisd_ADDRB_CLKB(2),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(2),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(2),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(2),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(2),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB3_CLKB_posedge,
        TimingData     => Tmkr_ADDRB3_CLKB_posedge,
        TestSignal     => ADDRB_dly(3),
        TestSignalName => "ADDRB(3)",
        TestDelay      => tisd_ADDRB_CLKB(3),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(3),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(3),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(3),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(3),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB4_CLKB_posedge,
        TimingData     => Tmkr_ADDRB4_CLKB_posedge,
        TestSignal     => ADDRB_dly(4),
        TestSignalName => "ADDRB(4)",
        TestDelay      => tisd_ADDRB_CLKB(4),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(4),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(4),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(4),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(4),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB5_CLKB_posedge,
        TimingData     => Tmkr_ADDRB5_CLKB_posedge,
        TestSignal     => ADDRB_dly(5),
        TestSignalName => "ADDRB(5)",
        TestDelay      => tisd_ADDRB_CLKB(5),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(5),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(5),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(5),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(5),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB6_CLKB_posedge,
        TimingData     => Tmkr_ADDRB6_CLKB_posedge,
        TestSignal     => ADDRB_dly(6),
        TestSignalName => "ADDRB(6)",
        TestDelay      => tisd_ADDRB_CLKB(6),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(6),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(6),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(6),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(6),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB7_CLKB_posedge,
        TimingData     => Tmkr_ADDRB7_CLKB_posedge,
        TestSignal     => ADDRB_dly(7),
        TestSignalName => "ADDRB(7)",
        TestDelay      => tisd_ADDRB_CLKB(7),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(7),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(7),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(7),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(7),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB8_CLKB_posedge,
        TimingData     => Tmkr_ADDRB8_CLKB_posedge,
        TestSignal     => ADDRB_dly(8),
        TestSignalName => "ADDRB(8)",
        TestDelay      => tisd_ADDRB_CLKB(8),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(8),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(8),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(8),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(8),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB9_CLKB_posedge,
        TimingData     => Tmkr_ADDRB9_CLKB_posedge,
        TestSignal     => ADDRB_dly(9),
        TestSignalName => "ADDRB(9)",
        TestDelay      => tisd_ADDRB_CLKB(9),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(9),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(9),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(9),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(9),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIPB0_CLKB_posedge,
        TimingData     => Tmkr_DIPB0_CLKB_posedge,
        TestSignal     => DIPB_dly(0),
        TestSignalName => "DIPB(0)",
        TestDelay      => tisd_DIPB_CLKB(0),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIPB_CLKB_posedge_posedge(0),
        SetupLow       => tsetup_DIPB_CLKB_negedge_posedge(0),
        HoldLow        => thold_DIPB_CLKB_negedge_posedge(0),
        HoldHigh       => thold_DIPB_CLKB_posedge_posedge(0),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIPB1_CLKB_posedge,
        TimingData     => Tmkr_DIPB1_CLKB_posedge,
        TestSignal     => DIPB_dly(1),
        TestSignalName => "DIPB(1)",
        TestDelay      => tisd_DIPB_CLKB(1),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIPB_CLKB_posedge_posedge(1),
        SetupLow       => tsetup_DIPB_CLKB_negedge_posedge(1),
        HoldLow        => thold_DIPB_CLKB_negedge_posedge(1),
        HoldHigh       => thold_DIPB_CLKB_posedge_posedge(1),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB0_CLKB_posedge,
        TimingData     => Tmkr_DIB0_CLKB_posedge,
        TestSignal     => DIB_dly(0),
        TestSignalName => "DIB(0)",
        TestDelay      => tisd_DIB_CLKB(0),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(0),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(0),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(0),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(0),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB1_CLKB_posedge,
        TimingData     => Tmkr_DIB1_CLKB_posedge,
        TestSignal     => DIB_dly(1),
        TestSignalName => "DIB(1)",
        TestDelay      => tisd_DIB_CLKB(1),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(1),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(1),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(1),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(1),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB2_CLKB_posedge,
        TimingData     => Tmkr_DIB2_CLKB_posedge,
        TestSignal     => DIB_dly(2),
        TestSignalName => "DIB(2)",
        TestDelay      => tisd_DIB_CLKB(2),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(2),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(2),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(2),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(2),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB3_CLKB_posedge,
        TimingData     => Tmkr_DIB3_CLKB_posedge,
        TestSignal     => DIB_dly(3),
        TestSignalName => "DIB(3)",
        TestDelay      => tisd_DIB_CLKB(3),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(3),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(3),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(3),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(3),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB4_CLKB_posedge,
        TimingData     => Tmkr_DIB4_CLKB_posedge,
        TestSignal     => DIB_dly(4),
        TestSignalName => "DIB(4)",
        TestDelay      => tisd_DIB_CLKB(4),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(4),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(4),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(4),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(4),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB5_CLKB_posedge,
        TimingData     => Tmkr_DIB5_CLKB_posedge,
        TestSignal     => DIB_dly(5),
        TestSignalName => "DIB(5)",
        TestDelay      => tisd_DIB_CLKB(5),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(5),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(5),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(5),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(5),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB6_CLKB_posedge,
        TimingData     => Tmkr_DIB6_CLKB_posedge,
        TestSignal     => DIB_dly(6),
        TestSignalName => "DIB(6)",
        TestDelay      => tisd_DIB_CLKB(6),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(6),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(6),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(6),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(6),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB7_CLKB_posedge,
        TimingData     => Tmkr_DIB7_CLKB_posedge,
        TestSignal     => DIB_dly(7),
        TestSignalName => "DIB(7)",
        TestDelay      => tisd_DIB_CLKB(7),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(7),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(7),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(7),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(7),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB8_CLKB_posedge,
        TimingData     => Tmkr_DIB8_CLKB_posedge,
        TestSignal     => DIB_dly(8),
        TestSignalName => "DIB(8)",
        TestDelay      => tisd_DIB_CLKB(8),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(8),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(8),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(8),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(8),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB9_CLKB_posedge,
        TimingData     => Tmkr_DIB9_CLKB_posedge,
        TestSignal     => DIB_dly(9),
        TestSignalName => "DIB(9)",
        TestDelay      => tisd_DIB_CLKB(9),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(9),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(9),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(9),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(9),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB10_CLKB_posedge,
        TimingData     => Tmkr_DIB10_CLKB_posedge,
        TestSignal     => DIB_dly(10),
        TestSignalName => "DIB(10)",
        TestDelay      => tisd_DIB_CLKB(10),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(10),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(10),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(10),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(10),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB11_CLKB_posedge,
        TimingData     => Tmkr_DIB11_CLKB_posedge,
        TestSignal     => DIB_dly(11),
        TestSignalName => "DIB(11)",
        TestDelay      => tisd_DIB_CLKB(11),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(11),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(11),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(11),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(11),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB12_CLKB_posedge,
        TimingData     => Tmkr_DIB12_CLKB_posedge,
        TestSignal     => DIB_dly(12),
        TestSignalName => "DIB(12)",
        TestDelay      => tisd_DIB_CLKB(12),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(12),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(12),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(12),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(12),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB13_CLKB_posedge,
        TimingData     => Tmkr_DIB13_CLKB_posedge,
        TestSignal     => DIB_dly(13),
        TestSignalName => "DIB(13)",
        TestDelay      => tisd_DIB_CLKB(13),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(13),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(13),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(13),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(13),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB14_CLKB_posedge,
        TimingData     => Tmkr_DIB14_CLKB_posedge,
        TestSignal     => DIB_dly(14),
        TestSignalName => "DIB(14)",
        TestDelay      => tisd_DIB_CLKB(14),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(14),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(14),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(14),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(14),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB15_CLKB_posedge,
        TimingData     => Tmkr_DIB15_CLKB_posedge,
        TestSignal     => DIB_dly(15),
        TestSignalName => "DIB(15)",
        TestDelay      => tisd_DIB_CLKB(15),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(15),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(15),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(15),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(15),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalPeriodPulseCheck (
        Violation      => Pviol_CLKA,
        PeriodData     => PInfo_CLKA,
        TestSignal     => CLKA_dly,
        TestSignalName => "CLKA",
        TestDelay      => 0 ps,
        Period         => 0 ps,
        PulseWidthHigh => tpw_CLKA_posedge,
        PulseWidthLow  => tpw_CLKA_negedge,
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalPeriodPulseCheck (
        Violation      => Pviol_CLKB,
        PeriodData     => PInfo_CLKB,
        TestSignal     => CLKB_dly,
        TestSignalName => "CLKB",
        TestDelay      => 0 ps,
        Period         => 0 ps,
        PulseWidthHigh => tpw_CLKB_posedge,
        PulseWidthLow  => tpw_CLKB_negedge,
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalPeriodPulseCheck (
        Violation      => Pviol_GSR,
        PeriodData     => PInfo_GSR,
        TestSignal     => GSR_ipd,
        TestSignalName => "GSR",
        TestDelay      => 0 ps,
        Period         => 0 ps,
        PulseWidthHigh => tpw_GSR_posedge,
        PulseWidthLow  => 0 ps,
        CheckEnabled   => true,
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
    end if;
    ViolationA          :=
      Tviol_ADDRA0_CLKA_posedge or
      Tviol_ADDRA1_CLKA_posedge or
      Tviol_ADDRA2_CLKA_posedge or
      Tviol_ADDRA3_CLKA_posedge or
      Tviol_ADDRA4_CLKA_posedge or
      Tviol_ADDRA5_CLKA_posedge or
      Tviol_ADDRA6_CLKA_posedge or
      Tviol_ADDRA7_CLKA_posedge or
      Tviol_ADDRA8_CLKA_posedge or
      Tviol_ADDRA9_CLKA_posedge or
      Tviol_ADDRA10_CLKA_posedge or
      Tviol_ADDRA11_CLKA_posedge or
      Tviol_DIA0_CLKA_posedge or
      Tviol_DIA1_CLKA_posedge or
      Tviol_DIA2_CLKA_posedge or
      Tviol_DIA3_CLKA_posedge or
      Tviol_ENA_CLKA_posedge or
      Tviol_SSRA_CLKA_posedge or
      Tviol_WEA_CLKA_posedge or
      Pviol_CLKA ;
    ViolationB          :=
      Tviol_ADDRB0_CLKB_posedge or
      Tviol_ADDRB1_CLKB_posedge or
      Tviol_ADDRB2_CLKB_posedge or
      Tviol_ADDRB3_CLKB_posedge or
      Tviol_ADDRB4_CLKB_posedge or
      Tviol_ADDRB5_CLKB_posedge or
      Tviol_ADDRB6_CLKB_posedge or
      Tviol_ADDRB7_CLKB_posedge or
      Tviol_ADDRB8_CLKB_posedge or
      Tviol_ADDRB9_CLKB_posedge or
      Tviol_DIB0_CLKB_posedge or
      Tviol_DIB1_CLKB_posedge or
      Tviol_DIB2_CLKB_posedge or
      Tviol_DIB3_CLKB_posedge or
      Tviol_DIB4_CLKB_posedge or
      Tviol_DIB5_CLKB_posedge or
      Tviol_DIB6_CLKB_posedge or
      Tviol_DIB7_CLKB_posedge or
      Tviol_DIB8_CLKB_posedge or
      Tviol_DIB9_CLKB_posedge or
      Tviol_DIB10_CLKB_posedge or
      Tviol_DIB11_CLKB_posedge or
      Tviol_DIB12_CLKB_posedge or
      Tviol_DIB13_CLKB_posedge or
      Tviol_DIB14_CLKB_posedge or
      Tviol_DIB15_CLKB_posedge or
      Tviol_DIPB0_CLKB_posedge or
      Tviol_DIPB1_CLKB_posedge or
      Tviol_ENB_CLKB_posedge or
      Tviol_SSRB_CLKB_posedge or
      Tviol_WEB_CLKB_posedge or
      Pviol_CLKB ;

    VALID_ADDRA           := ADDR_IS_VALID(addra_dly_sampled);
    if (VALID_ADDRA) then
      ADDRESS_A           := SLV_TO_INT(addra_dly_sampled);
    end if;
    VALID_ADDRB           := ADDR_IS_VALID(addrb_dly_sampled);
    if (VALID_ADDRB) then
      ADDRESS_B           := SLV_TO_INT(addrb_dly_sampled);
    end if;
    if (VALID_ADDRA and VALID_ADDRB) then
      ADDR_OVERLAP (ADDRESS_A, ADDRESS_B, WIDTH_A, WIDTH_B, HAS_OVERLAP, OLP_LSB, OLP_MSB, DOA_OV_LSB, DOA_OV_MSB, DOB_OV_LSB, DOB_OV_MSB);
    end if;
    ViolationCLKAB        := '0';
    ViolationCLKAB_S0     := false;
    Violation_S1          := false;
    Violation_S3          := false;
    if ((collision_type = 1) or (collision_type = 2) or (collision_type = 3)) then    
      VitalRecoveryRemovalCheck (
        Violation      => Tviol_CLKB_CLKA_all,
        TimingData     => Tmkr_CLKB_CLKA_all,
        TestSignal     => CLKB_dly,
        TestSignalName => "CLKB",
        TestDelay      => 0 ps,
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => 0 ps,
        Recovery       => SETUP_ALL,
        Removal       => 1 ps,
        ActiveLow      => true,
        CheckEnabled   => (HAS_OVERLAP = true and ena_dly_sampled = '1' and enb_dly_sampled = '1' and ((web_dly_sampled = '1' and wr_mode_b /= 1) or (wea_dly_sampled = '1' and wr_mode_a /= 1 and web_dly_sampled = '0'))),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => true,
        MsgOn          => false,
        MsgSeverity    => warning);

      VitalRecoveryRemovalCheck (
        Violation      => Tviol_CLKA_CLKB_all,
        TimingData     => Tmkr_CLKA_CLKB_all,
        TestSignal     => CLKA_dly,
        TestSignalName => "CLKA",
        TestDelay      => 0 ps,
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => 0 ps,
        Recovery       => SETUP_ALL,
        Removal       => 1 ps,
        ActiveLow      => true,
        CheckEnabled   => (HAS_OVERLAP = true and ena_dly_sampled = '1' and enb_dly_sampled = '1' and ((wea_dly_sampled = '1' and wr_mode_a /= 1) or (web_dly_sampled = '1' and wea_dly_sampled = '0' and wr_mode_b /= 1))),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => true,
        MsgOn          => false,
        MsgSeverity    => warning);

      VitalRecoveryRemovalCheck (
        Violation      => Tviol_CLKB_CLKA_read_first,
        TimingData     => Tmkr_CLKB_CLKA_read_first,
        TestSignal     => CLKB_dly,
        TestSignalName => "CLKB",
        TestDelay      => 0 ps,
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => 0 ps,
        Recovery       => SETUP_READ_FIRST,
        Removal       => 1 ps,
        ActiveLow      => true,
        CheckEnabled   => (HAS_OVERLAP = true and ena_dly_sampled = '1' and enb_dly_sampled = '1' and web_dly_sampled = '1' and wr_mode_b = 1 and (CLKA_dly'last_event /= CLKB_dly'last_event)),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => true,
        MsgOn          => false,
        MsgSeverity    => warning);

      VitalRecoveryRemovalCheck (
        Violation      => Tviol_CLKA_CLKB_read_first,
        TimingData     => Tmkr_CLKA_CLKB_read_first,
        TestSignal     => CLKA_dly,
        TestSignalName => "CLKA",
        TestDelay      => 0 ps,
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => 0 ps,
        Recovery       => SETUP_READ_FIRST,
        Removal       => 1 ps,
        ActiveLow      => true,
        CheckEnabled   => (HAS_OVERLAP = true and ena_dly_sampled = '1' and enb_dly_sampled = '1' and wea_dly_sampled = '1' and wr_mode_a = 1 and (CLKA_dly'last_event /= CLKB_dly'last_event)),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S18",
        Xon            => true,
        MsgOn          => false,
        MsgSeverity    => warning);        
    end if;
    ViolationCLKAB := Tviol_CLKB_CLKA_all or Tviol_CLKA_CLKB_all or Tviol_CLKB_CLKA_read_first or Tviol_CLKA_CLKB_read_first;        



    WR_A_LATER := false;
    WR_B_LATER := false;

    if (GSR_CLKA_dly = '1') then
      DOA_zd  := INIT_A_reg ( 3 downto 0);

    elsif (GSR_CLKA_dly = '0') then
      if (ena_dly_sampled = '1') then
        if (rising_edge(CLKA_dly)) then
          if (wea_dly_sampled = '1') then
            case wr_mode_a is
              when 0 =>
                DOA_zd  := DIA_dly;

                if (ViolationCLKAB = 'X') then
                  if (web_dly_sampled /= '0') then
                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Write_A_Write_B,
                         EntityName => "/X_RAMB16_S4_S18",
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      MEM(ADDRESS_A/(length_a/length_b))(DOB_OV_MSB downto DOB_OV_LSB) := (others => 'X');
                      DOA_zd := (others => 'X');
                      if (wr_mode_b /= 2 ) then
                        DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)    := (others => 'X');
                      end if;
                    end if;
                  else

                    if ((collision_type = 1) or (collision_type = 3)) then                
                      Memory_Collision_Msg
                        (collision_type => Read_B_Write_A,
                         EntityName => "/X_RAMB16_S4_S18",
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a))):= DIA_dly;
                    if ((collision_type = 2) or (collision_type = 3)) then                
                      DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)                      := (others => 'X');
                    end if;
                  end if;
                else

                  if (VALID_ADDRA) then
                    MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a))):= DIA_dly;
                  end if;
                end if;
              when 1 =>

                if (VALID_ADDRA) then
                  DOA_zd  := MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a)));
                  WR_A_LATER := true;
                end if;

                if (ViolationCLKAB = 'X') then

                  if (web_dly_sampled /= '0') then
                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Write_A_Write_B,
                         EntityName => "/X_RAMB16_S4_S18",
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      MEM(ADDRESS_A/(length_a/length_b))(DOB_OV_MSB downto DOB_OV_LSB) := (others => 'X');
                      DOA_zd := (others => 'X');
                      if (wr_mode_b /= 2 ) then
                        DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)    := (others => 'X');
                      end if;
                    end if;
                  else

                    if ((collision_type = 1) or (collision_type = 3)) then                
                      Memory_Collision_Msg
                        (collision_type => Read_B_Write_A,
                         EntityName => "/X_RAMB16_S4_S18",
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a))):= DIA_dly;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)                      := (others => 'X');
                    end if;
                  end if;
                end if;
              when 2 =>
                if (ViolationCLKAB = 'X') then

                  if (web_dly_sampled /= '0') then
                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Write_A_Write_B,
                         EntityName => "/X_RAMB16_S4_S18",
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      MEM(ADDRESS_A/(length_a/length_b))(DOB_OV_MSB downto DOB_OV_LSB) := (others => 'X');
                      if (wr_mode_b /= 2 ) then

                        DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)    := (others => 'X');
                      end if;
                    end if;
                  else

                    if ((collision_type = 1) or (collision_type = 3)) then                
                      Memory_Collision_Msg
                        (collision_type => Read_B_Write_A,
                         EntityName => "/X_RAMB16_S4_S18",
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then                
                      DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)                      := (others => 'X');
                    end if;
                    MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a))):= DIA_dly;
                  end if;
                else

                  if (VALID_ADDRA) then
                    MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a))):= DIA_dly;
                  end if;
                end if;
              when others => null;
            end case;
          else

            if (VALID_ADDRA) then
                  DOA_zd  := MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a)));
            end if;
            if (ViolationCLKAB = 'X') then

              if ((collision_type = 1) or (collision_type = 3)) then                
                Memory_Collision_Msg
                  (collision_type => Read_A_Write_B,
                   EntityName => "/X_RAMB16_S4_S18",
                   address_a => addra_dly_sampled,
                   address_b => addrb_dly_sampled
                   );
              end if;
              if ((collision_type = 2) or (collision_type = 3)) then                
                DOA_zd := (others => 'X');
              end if;
            end if;
          end if;
          if (ssra_dly_sampled = '1') then

            DOA_zd  := SRVAL_A_reg(3 downto 0);
          end if;
        end if;
      end if;
    end if;

    if (GSR_CLKB_dly = '1') then

      DOB_zd  := INIT_B_reg(15 downto 0);
      DOPB_zd := INIT_B_reg(17 downto 16);
    elsif (GSR_CLKB_dly = '0') then
      if (enb_dly_sampled = '1') then
        if (rising_edge(CLKB_dly)) then
          if (web_dly_sampled = '1') then
            case wr_mode_b is
              when 0 =>

                DOB_zd  := DIB_dly;
                DOPB_zd := DIPB_dly;
                if (VALID_ADDRB) then
                  MEM(ADDRESS_B)     := DIB_dly;
                  MEMP(ADDRESS_B) := DIPB_dly;
                end if;
                if (ViolationCLKAB = 'X') then
                  if (wea_dly_sampled /= '0') then

                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Write_A_Write_B,
                         EntityName => "X_RAMB16_S4_S18",
                         InstanceName => x_ramb16_s4_s18'path_name,
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      MEM(ADDRESS_B)(DOB_OV_MSB downto DOB_OV_LSB) := (others => 'X');

                      DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)    := (others => 'X');
                      if (wr_mode_a /= 2 ) then

                        DOA_zd := (others => 'X');
                      end if;
                    end if;
                  else
                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Read_A_Write_B,
                         EntityName => "X_RAMB16_S4_S18",
                         InstanceName => x_ramb16_s4_s18'path_name,
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      DOA_zd := (others => 'X');
                    end if;
                  end if;
                end if;
              when 1 =>

                if (VALID_ADDRB) then
                  DOB_zd  := MEM(ADDRESS_B);
                  DOPB_zd := MEMP(ADDRESS_B);
                  WR_B_LATER := true;
                  MEM(ADDRESS_B)     := DIB_dly ;
                  MEMP(ADDRESS_B) := DIPB_dly;
                end if;
                if (ViolationCLKAB = 'X') then
                  if (wea_dly_sampled /= '0') then

                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Write_A_Write_B,
                         EntityName => "X_RAMB16_S4_S18",
                         InstanceName => x_ramb16_s4_s18'path_name,
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      MEM(ADDRESS_B)(DOB_OV_MSB downto DOB_OV_LSB) := (others => 'X');

                      DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)    := (others => 'X');
                      if (wr_mode_a /= 2 ) then
                        DOA_zd := (others => 'X');
                      end if;
                    end if;
                  else

                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Read_A_Write_B,
                         EntityName => "X_RAMB16_S4_S18",
                         InstanceName => x_ramb16_s4_s18'path_name,
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      DOA_zd := (others => 'X');
                    end if;
                  end if;
                end if;
              when 2 =>
                if (VALID_ADDRB) then
                  MEM(ADDRESS_B) := DIB_dly;
                  MEMP(ADDRESS_B) := DIPB_dly;
                end if;
                if (ViolationCLKAB = 'X') then
                  if (wea_dly_sampled /= '0') then

                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Write_A_Write_B,
                         EntityName => "X_RAMB16_S4_S18",
                         InstanceName => x_ramb16_s4_s18'path_name,
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      MEM(ADDRESS_B)(DOB_OV_MSB downto DOB_OV_LSB) := (others => 'X');
                      if (wr_mode_a /= 2 ) then

                        DOA_zd := (others => 'X');
                      end if;
                    end if;
                  else

                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Read_A_Write_B,
                         EntityName => "X_RAMB16_S4_S18",
                         InstanceName => x_ramb16_s4_s18'path_name,
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      DOA_zd := (others => 'X');
                    end if;
                  end if;
                end if;
              when others => null;
            end case;
          else

            if (VALID_ADDRB) then
              DOB_zd  := MEM(ADDRESS_B);
              DOPB_zd := MEMP(ADDRESS_B);
            end if;
            if (ViolationCLKAB = 'X') then

              if ((collision_type = 1) or (collision_type = 3)) then                
                Memory_Collision_Msg
                  (collision_type => Read_B_Write_A,
                   EntityName => "X_RAMB16_S4_S18",
                   InstanceName => x_ramb16_s4_s18'path_name,
                   address_a => addra_dly_sampled,
                   address_b => addrb_dly_sampled
                   );
              end if;
              if ((collision_type = 2) or (collision_type = 3)) then                
                DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)    := (others => 'X');
              end if;
            end if;
          end if;
          if (ssrb_dly_sampled = '1') then

            DOB_zd  := SRVAL_B_reg(15 downto 0);
            DOPB_zd := SRVAL_B_reg(17 downto 16);
          end if;
        end if;
      end if;
    end if;

    if ((WR_A_LATER = true ) and (VALID_ADDRA)) then
      MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a))):= DIA_dly;                    
    end if;

    if ((WR_B_LATER = true ) and (VALID_ADDRB)) then
        MEM(ADDRESS_B) := DIB_dly;
        MEMP(ADDRESS_B) := DIPB_dly;
    end if;

    DOA_zd(0)  := ViolationA xor DOA_zd(0);
    DOA_zd(1)  := ViolationA xor DOA_zd(1);
    DOA_zd(2)  := ViolationA xor DOA_zd(2);
    DOA_zd(3)  := ViolationA xor DOA_zd(3);
    DOB_zd(0)  := ViolationB xor DOB_zd(0);
    DOB_zd(1)  := ViolationB xor DOB_zd(1);
    DOB_zd(2)  := ViolationB xor DOB_zd(2);
    DOB_zd(3)  := ViolationB xor DOB_zd(3);
    DOB_zd(4)  := ViolationB xor DOB_zd(4);
    DOB_zd(5)  := ViolationB xor DOB_zd(5);
    DOB_zd(6)  := ViolationB xor DOB_zd(6);
    DOB_zd(7)  := ViolationB xor DOB_zd(7);
    DOB_zd(8)  := ViolationB xor DOB_zd(8);
    DOB_zd(9)  := ViolationB xor DOB_zd(9);
    DOB_zd(10)  := ViolationB xor DOB_zd(10);
    DOB_zd(11)  := ViolationB xor DOB_zd(11);
    DOB_zd(12)  := ViolationB xor DOB_zd(12);
    DOB_zd(13)  := ViolationB xor DOB_zd(13);
    DOB_zd(14)  := ViolationB xor DOB_zd(14);
    DOB_zd(15)  := ViolationB xor DOB_zd(15);
    DOPB_zd(0) := ViolationB xor DOPB_zd(0);
    DOPB_zd(1) := ViolationB xor DOPB_zd(1);

    VitalPathDelay01 (
      OutSignal     => DOA(0),
      GlitchData    => DOA_GlitchData0,
      OutSignalName => "DOA(0)",
      OutTemp       => DOA_zd(0),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(0), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(0), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(1),
      GlitchData    => DOA_GlitchData1,
      OutSignalName => "DOA(1)",
      OutTemp       => DOA_zd(1),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(1), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(1), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(2),
      GlitchData    => DOA_GlitchData2,
      OutSignalName => "DOA(2)",
      OutTemp       => DOA_zd(2),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(2), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(2), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(3),
      GlitchData    => DOA_GlitchData3,
      OutSignalName => "DOA(3)",
      OutTemp       => DOA_zd(3),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(3), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(3), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(0),
      GlitchData    => DOB_GlitchData0,
      OutSignalName => "DOB(0)",
      OutTemp       => DOB_zd(0),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(0), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(0), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(1),
      GlitchData    => DOB_GlitchData1,
      OutSignalName => "DOB(1)",
      OutTemp       => DOB_zd(1),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(1), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(1), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(2),
      GlitchData    => DOB_GlitchData2,
      OutSignalName => "DOB(2)",
      OutTemp       => DOB_zd(2),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(2), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(2), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(3),
      GlitchData    => DOB_GlitchData3,
      OutSignalName => "DOB(3)",
      OutTemp       => DOB_zd(3),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(3), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(3), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(4),
      GlitchData    => DOB_GlitchData4,
      OutSignalName => "DOB(4)",
      OutTemp       => DOB_zd(4),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(4), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(4), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(5),
      GlitchData    => DOB_GlitchData5,
      OutSignalName => "DOB(5)",
      OutTemp       => DOB_zd(5),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(5), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(5), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(6),
      GlitchData    => DOB_GlitchData6,
      OutSignalName => "DOB(6)",
      OutTemp       => DOB_zd(6),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(6), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(6), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(7),
      GlitchData    => DOB_GlitchData7,
      OutSignalName => "DOB(7)",
      OutTemp       => DOB_zd(7),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(7), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(7), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(8),
      GlitchData    => DOB_GlitchData8,
      OutSignalName => "DOB(8)",
      OutTemp       => DOB_zd(8),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(8), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(8), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(9),
      GlitchData    => DOB_GlitchData9,
      OutSignalName => "DOB(9)",
      OutTemp       => DOB_zd(9),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(9), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(9), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(10),
      GlitchData    => DOB_GlitchData10,
      OutSignalName => "DOB(10)",
      OutTemp       => DOB_zd(10),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(10), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(10), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(11),
      GlitchData    => DOB_GlitchData11,
      OutSignalName => "DOB(11)",
      OutTemp       => DOB_zd(11),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(11), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(11), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(12),
      GlitchData    => DOB_GlitchData12,
      OutSignalName => "DOB(12)",
      OutTemp       => DOB_zd(12),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(12), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(12), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(13),
      GlitchData    => DOB_GlitchData13,
      OutSignalName => "DOB(13)",
      OutTemp       => DOB_zd(13),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(13), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(13), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(14),
      GlitchData    => DOB_GlitchData14,
      OutSignalName => "DOB(14)",
      OutTemp       => DOB_zd(14),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(14), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(14), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(15),
      GlitchData    => DOB_GlitchData15,
      OutSignalName => "DOB(15)",
      OutTemp       => DOB_zd(15),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(15), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(15), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOPB(0),
      GlitchData    => DOPB_GlitchData0,
      OutSignalName => "DOPB(0)",
      OutTemp       => DOPB_zd(0),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOPB(0), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(0), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOPB(1),
      GlitchData    => DOPB_GlitchData1,
      OutSignalName => "DOPB(1)",
      OutTemp       => DOPB_zd(1),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOPB(1), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(1), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    wait on ADDRA_dly, ADDRB_dly, CLKA_dly, CLKB_dly, DIA_dly, DIB_dly, DIPB_dly, ENA_dly, ENB_dly, GSR_ipd, GSR_CLKA_dly, GSR_CLKB_dly, SSRA_dly, SSRB_dly, WEA_dly, WEB_dly;
  end process VITALBehavior;
end X_RAMB16_S4_S18_V;
-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  16K-Bit Data and 2K-Bit Parity Dual Port Block RAM
-- /___/   /\     Filename : X_RAMB16_S4_S36.vhd
-- \   \  /  \    Timestamp : Thu Apr  8 10:56:56 PDT 2004
--  \___\/\___\
--
-- Revision:
--    03/23/04 - Initial version.
----- CELL x_ramb16_s4_s36 -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;

library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.VPACKAGE.all;
use simprim.VCOMPONENTS.all;

entity X_RAMB16_S4_S36 is
  generic (
    TimingChecksOn : boolean := true;
    Xon            : boolean := true;
    MsgOn          : boolean := true;

    LOC            : string  := "UNPLACED";

    tipd_ADDRA : VitalDelayArrayType01(11 downto 0)  := (others => (0 ps, 0 ps));
    tipd_CLKA  : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_DIA   : VitalDelayArrayType01(3 downto 0) := (others => (0 ps, 0 ps));
    tipd_ENA   : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_SSRA  : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_WEA   : VitalDelayType01                   := ( 0 ps, 0 ps);

    tipd_ADDRB : VitalDelayArrayType01(8 downto 0)  := (others => (0 ps, 0 ps));
    tipd_CLKB  : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_DIB   : VitalDelayArrayType01(31 downto 0) := (others => (0 ps, 0 ps));
    tipd_DIPB  : VitalDelayArrayType01(3 downto 0)  := (others => (0 ps, 0 ps));
    tipd_ENB   : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_SSRB  : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_WEB   : VitalDelayType01                   := ( 0 ps, 0 ps);

    tipd_GSR : VitalDelayType01 := ( 0 ps, 0 ps);

    tpd_GSR_DOA  : VitalDelayArrayType01(3 downto 0) := (others => (0 ps, 0 ps));
    tpd_GSR_DOB  : VitalDelayArrayType01(31 downto 0) := (others => (0 ps, 0 ps));
    tpd_GSR_DOPB : VitalDelayArrayType01(3 downto 0)  := (others => (0 ps, 0 ps));

    tpd_CLKA_DOA  : VitalDelayArrayType01(3 downto 0) := (others => (100 ps, 100 ps));
    tpd_CLKB_DOB  : VitalDelayArrayType01(31 downto 0) := (others => (100 ps, 100 ps));
    tpd_CLKB_DOPB : VitalDelayArrayType01(3 downto 0)  := (others => (100 ps, 100 ps));

    trecovery_GSR_CLKA_negedge_posedge : VitalDelayType                   := 0 ps;
    tsetup_ADDRA_CLKA_negedge_posedge  : VitalDelayArrayType(11 downto 0)  := (others => 0 ps);
    tsetup_ADDRA_CLKA_posedge_posedge  : VitalDelayArrayType(11 downto 0)  := (others => 0 ps);
    tsetup_DIA_CLKA_negedge_posedge    : VitalDelayArrayType(3 downto 0) := (others => 0 ps);
    tsetup_DIA_CLKA_posedge_posedge    : VitalDelayArrayType(3 downto 0) := (others => 0 ps);
    tsetup_ENA_CLKA_negedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_ENA_CLKA_posedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_SSRA_CLKA_negedge_posedge   : VitalDelayType                   := 0 ps;
    tsetup_SSRA_CLKA_posedge_posedge   : VitalDelayType                   := 0 ps;
    tsetup_WEA_CLKA_negedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_WEA_CLKA_posedge_posedge    : VitalDelayType                   := 0 ps;

    trecovery_GSR_CLKB_negedge_posedge : VitalDelayType                   := 0 ps;
    tsetup_ADDRB_CLKB_negedge_posedge  : VitalDelayArrayType(8 downto 0)  := (others => 0 ps);
    tsetup_ADDRB_CLKB_posedge_posedge  : VitalDelayArrayType(8 downto 0)  := (others => 0 ps);
    tsetup_DIB_CLKB_negedge_posedge    : VitalDelayArrayType(31 downto 0) := (others => 0 ps);
    tsetup_DIB_CLKB_posedge_posedge    : VitalDelayArrayType(31 downto 0) := (others => 0 ps);
    tsetup_DIPB_CLKB_negedge_posedge   : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    tsetup_DIPB_CLKB_posedge_posedge   : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    tsetup_ENB_CLKB_negedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_ENB_CLKB_posedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_SSRB_CLKB_negedge_posedge   : VitalDelayType                   := 0 ps;
    tsetup_SSRB_CLKB_posedge_posedge   : VitalDelayType                   := 0 ps;
    tsetup_WEB_CLKB_negedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_WEB_CLKB_posedge_posedge    : VitalDelayType                   := 0 ps;

    thold_ADDRA_CLKA_negedge_posedge : VitalDelayArrayType(11 downto 0)  := (others => 0 ps);
    thold_ADDRA_CLKA_posedge_posedge : VitalDelayArrayType(11 downto 0)  := (others => 0 ps);
    thold_DIA_CLKA_negedge_posedge   : VitalDelayArrayType(3 downto 0) := (others => 0 ps);
    thold_DIA_CLKA_posedge_posedge   : VitalDelayArrayType(3 downto 0) := (others => 0 ps);
    thold_ENA_CLKA_negedge_posedge   : VitalDelayType                   := 0 ps;
    thold_ENA_CLKA_posedge_posedge   : VitalDelayType                   := 0 ps;
    thold_GSR_CLKA_negedge_posedge   : VitalDelayType                   := 0 ps;
    thold_SSRA_CLKA_negedge_posedge  : VitalDelayType                   := 0 ps;
    thold_SSRA_CLKA_posedge_posedge  : VitalDelayType                   := 0 ps;
    thold_WEA_CLKA_negedge_posedge   : VitalDelayType                   := 0 ps;
    thold_WEA_CLKA_posedge_posedge   : VitalDelayType                   := 0 ps;

    thold_ADDRB_CLKB_negedge_posedge : VitalDelayArrayType(8 downto 0)  := (others => 0 ps);
    thold_ADDRB_CLKB_posedge_posedge : VitalDelayArrayType(8 downto 0)  := (others => 0 ps);
    thold_DIB_CLKB_negedge_posedge   : VitalDelayArrayType(31 downto 0) := (others => 0 ps);
    thold_DIB_CLKB_posedge_posedge   : VitalDelayArrayType(31 downto 0) := (others => 0 ps);
    thold_DIPB_CLKB_negedge_posedge  : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    thold_DIPB_CLKB_posedge_posedge  : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    thold_ENB_CLKB_negedge_posedge   : VitalDelayType                   := 0 ps;
    thold_ENB_CLKB_posedge_posedge   : VitalDelayType                   := 0 ps;
    thold_GSR_CLKB_negedge_posedge   : VitalDelayType                   := 0 ps;
    thold_SSRB_CLKB_negedge_posedge  : VitalDelayType                   := 0 ps;
    thold_SSRB_CLKB_posedge_posedge  : VitalDelayType                   := 0 ps;
    thold_WEB_CLKB_negedge_posedge   : VitalDelayType                   := 0 ps;
    thold_WEB_CLKB_posedge_posedge   : VitalDelayType                   := 0 ps;

    tbpd_GSR_DOA_CLKA  : VitalDelayArrayType01(3 downto 0) := (others => (0 ps, 0 ps));
    ticd_CLKA          : VitalDelayType                     := 0 ps;
    tisd_ADDRA_CLKA    : VitalDelayArrayType(11 downto 0)    := (others => 0 ps);
    tisd_DIA_CLKA      : VitalDelayArrayType(3 downto 0)   := (others => 0 ps);
    tisd_ENA_CLKA      : VitalDelayType                     := 0 ps;
    tisd_GSR_CLKA      : VitalDelayType                     := 0 ps;
    tisd_SSRA_CLKA     : VitalDelayType                     := 0 ps;
    tisd_WEA_CLKA      : VitalDelayType                     := 0 ps;

    tbpd_GSR_DOB_CLKB  : VitalDelayArrayType01(31 downto 0) := (others => (0 ps, 0 ps));
    tbpd_GSR_DOPB_CLKB : VitalDelayArrayType01(3 downto 0)  := (others => (0 ps, 0 ps));
    ticd_CLKB          : VitalDelayType                     := 0 ps;
    tisd_ADDRB_CLKB    : VitalDelayArrayType(8 downto 0)    := (others => 0 ps);
    tisd_DIB_CLKB      : VitalDelayArrayType(31 downto 0)   := (others => 0 ps);
    tisd_DIPB_CLKB     : VitalDelayArrayType(3 downto 0)    := (others => 0 ps);
    tisd_ENB_CLKB      : VitalDelayType                     := 0 ps;
    tisd_GSR_CLKB      : VitalDelayType                     := 0 ps;
    tisd_SSRB_CLKB     : VitalDelayType                     := 0 ps;
    tisd_WEB_CLKB      : VitalDelayType                     := 0 ps;

    tpw_CLKA_negedge : VitalDelayType := 0 ps;
    tpw_CLKA_posedge : VitalDelayType := 0 ps;
    tpw_CLKB_negedge : VitalDelayType := 0 ps;
    tpw_CLKB_posedge : VitalDelayType := 0 ps;
    tpw_GSR_posedge  : VitalDelayType := 0 ps;

    INITP_00 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_01 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_02 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_03 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_04 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_05 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_06 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_07 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";

    INIT_00  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_01  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_02  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_03  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_04  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_05  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_06  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_07  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_08  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_09  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0A  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0B  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0C  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0D  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0E  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0F  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_10  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_11  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_12  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_13  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_14  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_15  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_16  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_17  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_18  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_19  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1A  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1B  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1C  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1D  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1E  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1F  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_20  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_21  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_22  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_23  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_24  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_25  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_26  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_27  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_28  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_29  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2A  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2B  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2C  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2D  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2E  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2F  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_30  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_31  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_32  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_33  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_34  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_35  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_36  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_37  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_38  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_39  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3A  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3B  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3C  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3D  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3E  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3F  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_A : bit_vector := X"0";
    INIT_B : bit_vector := X"000000000";

    SRVAL_A : bit_vector := X"0";
    SRVAL_B : bit_vector := X"000000000";

    SETUP_ALL        : VitalDelayType := 1000 ps;
    SETUP_READ_FIRST : VitalDelayType := 3000 ps;

    SIM_COLLISION_CHECK : string := "ALL";

    WRITE_MODE_A : string := "WRITE_FIRST";
    WRITE_MODE_B : string := "WRITE_FIRST"

    );

  port(
    DOA   : out std_logic_vector (3 downto 0);
    DOB   : out std_logic_vector (31 downto 0);
    DOPB  : out std_logic_vector (3 downto 0);

    ADDRA : in  std_logic_vector (11 downto 0);
    ADDRB : in  std_logic_vector (8 downto 0);
    CLKA  : in  std_ulogic;
    CLKB  : in  std_ulogic;
    DIA   : in  std_logic_vector (3 downto 0);
    DIB   : in  std_logic_vector (31 downto 0);
    DIPB  : in  std_logic_vector (3 downto 0);
    ENA   : in  std_ulogic;
    ENB   : in  std_ulogic;
    SSRA  : in  std_ulogic;
    SSRB  : in  std_ulogic;
    WEA   : in  std_ulogic;
    WEB   : in  std_ulogic
    );

  attribute VITAL_LEVEL0 of
    X_RAMB16_S4_S36 : entity is true;
end x_ramb16_s4_s36;

architecture X_RAMB16_S4_S36_V of X_RAMB16_S4_S36 is

  attribute VITAL_LEVEL0 of
    X_RAMB16_S4_S36_V : architecture is true;

  signal ADDRA_ipd : std_logic_vector(11 downto 0)  := (others => 'X');
  signal CLKA_ipd  : std_ulogic                    := 'X';
  signal DIA_ipd   : std_logic_vector(3 downto 0) := (others => 'X');
  signal ENA_ipd   : std_ulogic                    := 'X';
  signal SSRA_ipd  : std_ulogic                    := 'X';
  signal WEA_ipd   : std_ulogic                    := 'X';

  signal ADDRB_ipd : std_logic_vector(8 downto 0)  := (others => 'X');
  signal CLKB_ipd  : std_ulogic                    := 'X';
  signal DIB_ipd   : std_logic_vector(31 downto 0) := (others => 'X');
  signal DIPB_ipd  : std_logic_vector(3 downto 0)  := (others => 'X');
  signal ENB_ipd   : std_ulogic                    := 'X';
  signal SSRB_ipd  : std_ulogic                    := 'X';
  signal WEB_ipd   : std_ulogic                    := 'X';

  signal GSR_ipd : std_ulogic := 'X';

  signal ADDRA_dly    : std_logic_vector(11 downto 0)  := (others => 'X');
  signal CLKA_dly     : std_ulogic                    := 'X';
  signal DIA_dly      : std_logic_vector(3 downto 0) := (others => 'X');
  signal ENA_dly      : std_ulogic                    := 'X';
  signal GSR_CLKA_dly : std_ulogic                    := 'X';
  signal SSRA_dly     : std_ulogic                    := 'X';
  signal WEA_dly      : std_ulogic                    := 'X';

  signal ADDRB_dly    : std_logic_vector(8 downto 0)  := (others => 'X');
  signal CLKB_dly     : std_ulogic                    := 'X';
  signal DIB_dly      : std_logic_vector(31 downto 0) := (others => 'X');
  signal DIPB_dly     : std_logic_vector(3 downto 0)  := (others => 'X');
  signal ENB_dly      : std_ulogic                    := 'X';
  signal GSR_CLKB_dly : std_ulogic                    := 'X';
  signal SSRB_dly     : std_ulogic                    := 'X';
  signal WEB_dly      : std_ulogic                    := 'X';
  constant length_a : integer := 4096;
  constant length_b : integer := 512;  
  constant width_a : integer := 4;
  constant width_b : integer := 32;  

  constant parity_width_a : integer := 0;
  constant parity_width_b : integer := 4;
  
  type Two_D_array_type is array ((length_b -  1) downto 0) of std_logic_vector((width_b - 1) downto 0);
  type Two_D_parity_array_type is array ((length_b - 1) downto 0) of std_logic_vector((parity_width_b - 1)downto 0);    

  function slv_to_two_D_array(
    slv_length : integer;
    slv_width : integer;
    SLV : in std_logic_vector
    )
    return two_D_array_type is
    variable two_D_array : two_D_array_type;
    variable intermediate : std_logic_vector((slv_width - 1) downto 0);
  begin
    for i in 0 to (slv_length - 1)loop
      intermediate := SLV(((i*slv_width) + (slv_width - 1)) downto (i* slv_width));
      two_D_array(i) := intermediate; 
    end loop;
    return two_D_array;
  end;

  function slv_to_two_D_parity_array(
    slv_length : integer;
    slv_width : integer;
    SLV : in std_logic_vector
    )
    return two_D_parity_array_type is
    variable two_D_parity_array : two_D_parity_array_type;
    variable intermediate : std_logic_vector((slv_width - 1) downto 0);
  begin
    for i in 0 to (slv_length - 1)loop
      intermediate := SLV(((i*slv_width) + (slv_width - 1)) downto (i* slv_width));
      two_D_parity_array(i) := intermediate; 
    end loop;
    return two_D_parity_array;
  end;          
begin
  WireDelay     : block
  begin
    ADDRA_DELAY : for i in 11 downto 0 generate
      VitalWireDelay (ADDRA_ipd(i), ADDRA(i), tipd_ADDRA(i));
    end generate ADDRA_DELAY;
    VitalWireDelay (CLKA_ipd, CLKA, tipd_CLKA);
    DIA_DELAY   : for i in 3 downto 0 generate
      VitalWireDelay (DIA_ipd(i), DIA(i), tipd_DIA(i));
    end generate DIA_DELAY;
    VitalWireDelay (ENA_ipd, ENA, tipd_ENA);
    VitalWireDelay (SSRA_ipd, SSRA, tipd_SSRA);
    VitalWireDelay (WEA_ipd, WEA, tipd_WEA);
    ADDRB_DELAY : for i in 8 downto 0 generate
      VitalWireDelay (ADDRB_ipd(i), ADDRB(i), tipd_ADDRB(i));
    end generate ADDRB_DELAY;
    VitalWireDelay (CLKB_ipd, CLKB, tipd_CLKB);
    DIB_DELAY   : for i in 31 downto 0 generate
      VitalWireDelay (DIB_ipd(i), DIB(i), tipd_DIB(i));
    end generate DIB_DELAY;
    DIPB_DELAY  : for i in 3 downto 0 generate
      VitalWireDelay (DIPB_ipd(i), DIPB(i), tipd_DIPB(i));
    end generate DIPB_DELAY;
    VitalWireDelay (ENB_ipd, ENB, tipd_ENB);
    VitalWireDelay (SSRB_ipd, SSRB, tipd_SSRB);
    VitalWireDelay (WEB_ipd, WEB, tipd_WEB);
    VitalWireDelay (GSR_ipd, GSR, tipd_GSR);
  end block;

  SignalDelay   : block
  begin
    ADDRA_DELAY : for i in 11 downto 0 generate
      VitalSignalDelay (ADDRA_dly(i), ADDRA_ipd(i), tisd_ADDRA_CLKA(i));
    end generate ADDRA_DELAY;
    VitalSignalDelay (CLKA_dly, CLKA_ipd, ticd_CLKA);
    DIA_DELAY   : for i in 3 downto 0 generate
      VitalSignalDelay (DIA_dly(i), DIA_ipd(i), tisd_DIA_CLKA(i));
    end generate DIA_DELAY;
    VitalSignalDelay (ENA_dly, ENA_ipd, tisd_ENA_CLKA);
    VitalSignalDelay (GSR_CLKA_dly, GSR_ipd, tisd_GSR_CLKA);
    VitalSignalDelay (SSRA_dly, SSRA_ipd, tisd_SSRA_CLKA);
    VitalSignalDelay (WEA_dly, WEA_ipd, tisd_WEA_CLKA);

    ADDRB_DELAY : for i in 8 downto 0 generate
      VitalSignalDelay (ADDRB_dly(i), ADDRB_ipd(i), tisd_ADDRB_CLKB(i));
    end generate ADDRB_DELAY;
    VitalSignalDelay (CLKB_dly, CLKB_ipd, ticd_CLKB);
    DIB_DELAY   : for i in 31 downto 0 generate
      VitalSignalDelay (DIB_dly(i), DIB_ipd(i), tisd_DIB_CLKB(i));
    end generate DIB_DELAY;
    DIPB_DELAY  : for i in 3 downto 0 generate
      VitalSignalDelay (DIPB_dly(i), DIPB_ipd(i), tisd_DIPB_CLKB(i));
    end generate DIPB_DELAY;
    VitalSignalDelay (ENB_dly, ENB_ipd, tisd_ENB_CLKB);
    VitalSignalDelay (GSR_CLKB_dly, GSR_ipd, tisd_GSR_CLKB);
    VitalSignalDelay (SSRB_dly, SSRB_ipd, tisd_SSRB_CLKB);
    VitalSignalDelay (WEB_dly, WEB_ipd, tisd_WEB_CLKB);
  end block;

  VITALBehavior                        : process
    variable Tviol_ADDRA0_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA1_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA2_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA3_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA4_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA5_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA6_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA7_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA8_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA9_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA10_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA11_CLKA_posedge : std_ulogic := '0';
    variable Tviol_DIA0_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA1_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA2_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA3_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_ENA_CLKA_posedge    : std_ulogic := '0';
    variable Tviol_GSR_CLKA_posedge    : std_ulogic := '0';
    variable Tviol_SSRA_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_WEA_CLKA_posedge    : std_ulogic := '0';

    variable Tviol_ADDRB0_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB1_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB2_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB3_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB4_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB5_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB6_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB7_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB8_CLKB_posedge : std_ulogic := '0';
    variable Tviol_DIB0_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB1_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB2_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB3_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB4_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB5_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB6_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB7_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB8_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB9_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB10_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB11_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB12_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB13_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB14_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB15_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB16_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB17_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB18_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB19_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB20_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB21_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB22_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB23_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB24_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB25_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB26_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB27_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB28_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB29_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB30_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB31_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIPB0_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIPB1_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIPB2_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIPB3_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_ENB_CLKB_posedge    : std_ulogic := '0';
    variable Tviol_GSR_CLKB_posedge    : std_ulogic := '0';
    variable Tviol_SSRB_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_WEB_CLKB_posedge    : std_ulogic := '0';

    variable Tviol_CLKA_CLKB_all        : std_ulogic := '0';
    variable Tviol_CLKA_CLKB_read_first : std_ulogic := '0';
    variable Tviol_CLKB_CLKA_all        : std_ulogic := '0';
    variable Tviol_CLKB_CLKA_read_first : std_ulogic := '0';

    variable Tmkr_ADDRA0_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA1_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA2_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA3_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA4_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA5_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA6_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA7_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA8_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA9_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA10_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA11_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA0_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA1_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA2_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA3_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ENA_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_GSR_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_SSRA_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_WEA_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;

    variable Tmkr_ADDRB0_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB1_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB2_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB3_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB4_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB5_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB6_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB7_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB8_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB0_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB1_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB2_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB3_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB4_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB5_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB6_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB7_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB8_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB9_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB10_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB11_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB12_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB13_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB14_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB15_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB16_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB17_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB18_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB19_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB20_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB21_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB22_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB23_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB24_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB25_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB26_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB27_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB28_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB29_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB30_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB31_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIPB0_CLKB_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIPB1_CLKB_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIPB2_CLKB_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIPB3_CLKB_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ENB_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_GSR_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_SSRB_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_WEB_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;

    variable Tmkr_CLKA_CLKB_all        : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_CLKA_CLKB_read_first : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_CLKB_CLKA_all        : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_CLKB_CLKA_read_first : VitalTimingDataType := VitalTimingDataInit;

    variable PViol_GSR : std_ulogic          := '0';
    variable PInfo_GSR : VitalPeriodDataType := VitalPeriodDataInit;

    variable PViol_CLKA, PViol_CLKB : std_ulogic          := '0';
    variable PInfo_CLKA, PInfo_CLKB : VitalPeriodDataType := VitalPeriodDataInit;

    variable DOA_GlitchData0  : VitalGlitchDataType;
    variable DOA_GlitchData1  : VitalGlitchDataType;
    variable DOA_GlitchData2  : VitalGlitchDataType;
    variable DOA_GlitchData3  : VitalGlitchDataType;

    variable DOB_GlitchData0  : VitalGlitchDataType;
    variable DOB_GlitchData1  : VitalGlitchDataType;
    variable DOB_GlitchData2  : VitalGlitchDataType;
    variable DOB_GlitchData3  : VitalGlitchDataType;
    variable DOB_GlitchData4  : VitalGlitchDataType;
    variable DOB_GlitchData5  : VitalGlitchDataType;
    variable DOB_GlitchData6  : VitalGlitchDataType;
    variable DOB_GlitchData7  : VitalGlitchDataType;
    variable DOB_GlitchData8  : VitalGlitchDataType;
    variable DOB_GlitchData9  : VitalGlitchDataType;
    variable DOB_GlitchData10  : VitalGlitchDataType;
    variable DOB_GlitchData11  : VitalGlitchDataType;
    variable DOB_GlitchData12  : VitalGlitchDataType;
    variable DOB_GlitchData13  : VitalGlitchDataType;
    variable DOB_GlitchData14  : VitalGlitchDataType;
    variable DOB_GlitchData15  : VitalGlitchDataType;
    variable DOB_GlitchData16  : VitalGlitchDataType;
    variable DOB_GlitchData17  : VitalGlitchDataType;
    variable DOB_GlitchData18  : VitalGlitchDataType;
    variable DOB_GlitchData19  : VitalGlitchDataType;
    variable DOB_GlitchData20  : VitalGlitchDataType;
    variable DOB_GlitchData21  : VitalGlitchDataType;
    variable DOB_GlitchData22  : VitalGlitchDataType;
    variable DOB_GlitchData23  : VitalGlitchDataType;
    variable DOB_GlitchData24  : VitalGlitchDataType;
    variable DOB_GlitchData25  : VitalGlitchDataType;
    variable DOB_GlitchData26  : VitalGlitchDataType;
    variable DOB_GlitchData27  : VitalGlitchDataType;
    variable DOB_GlitchData28  : VitalGlitchDataType;
    variable DOB_GlitchData29  : VitalGlitchDataType;
    variable DOB_GlitchData30  : VitalGlitchDataType;
    variable DOB_GlitchData31  : VitalGlitchDataType;
    variable DOPB_GlitchData0 : VitalGlitchDataType;
    variable DOPB_GlitchData1 : VitalGlitchDataType;
    variable DOPB_GlitchData2 : VitalGlitchDataType;
    variable DOPB_GlitchData3 : VitalGlitchDataType;

    variable mem_slv : std_logic_vector(16383 downto 0) := To_StdLogicVector(INIT_3F) &
                                                       To_StdLogicVector(INIT_3E) &
                                                       To_StdLogicVector(INIT_3D) &
                                                       To_StdLogicVector(INIT_3C) &
                                                       To_StdLogicVector(INIT_3B) &
                                                       To_StdLogicVector(INIT_3A) &
                                                       To_StdLogicVector(INIT_39) &
                                                       To_StdLogicVector(INIT_38) &
                                                       To_StdLogicVector(INIT_37) &
                                                       To_StdLogicVector(INIT_36) &
                                                       To_StdLogicVector(INIT_35) &
                                                       To_StdLogicVector(INIT_34) &
                                                       To_StdLogicVector(INIT_33) &
                                                       To_StdLogicVector(INIT_32) &
                                                       To_StdLogicVector(INIT_31) &
                                                       To_StdLogicVector(INIT_30) &
                                                       To_StdLogicVector(INIT_2F) &
                                                       To_StdLogicVector(INIT_2E) &
                                                       To_StdLogicVector(INIT_2D) &
                                                       To_StdLogicVector(INIT_2C) &
                                                       To_StdLogicVector(INIT_2B) &
                                                       To_StdLogicVector(INIT_2A) &
                                                       To_StdLogicVector(INIT_29) &
                                                       To_StdLogicVector(INIT_28) &
                                                       To_StdLogicVector(INIT_27) &
                                                       To_StdLogicVector(INIT_26) &
                                                       To_StdLogicVector(INIT_25) &
                                                       To_StdLogicVector(INIT_24) &
                                                       To_StdLogicVector(INIT_23) &
                                                       To_StdLogicVector(INIT_22) &
                                                       To_StdLogicVector(INIT_21) &
                                                       To_StdLogicVector(INIT_20) &
                                                       To_StdLogicVector(INIT_1F) &
                                                       To_StdLogicVector(INIT_1E) &
                                                       To_StdLogicVector(INIT_1D) &
                                                       To_StdLogicVector(INIT_1C) &
                                                       To_StdLogicVector(INIT_1B) &
                                                       To_StdLogicVector(INIT_1A) &
                                                       To_StdLogicVector(INIT_19) &
                                                       To_StdLogicVector(INIT_18) &
                                                       To_StdLogicVector(INIT_17) &
                                                       To_StdLogicVector(INIT_16) &
                                                       To_StdLogicVector(INIT_15) &
                                                       To_StdLogicVector(INIT_14) &
                                                       To_StdLogicVector(INIT_13) &
                                                       To_StdLogicVector(INIT_12) &
                                                       To_StdLogicVector(INIT_11) &
                                                       To_StdLogicVector(INIT_10) &
                                                       To_StdLogicVector(INIT_0F) &
                                                       To_StdLogicVector(INIT_0E) &
                                                       To_StdLogicVector(INIT_0D) &
                                                       To_StdLogicVector(INIT_0C) &
                                                       To_StdLogicVector(INIT_0B) &
                                                       To_StdLogicVector(INIT_0A) &
                                                       To_StdLogicVector(INIT_09) &
                                                       To_StdLogicVector(INIT_08) &
                                                       To_StdLogicVector(INIT_07) &
                                                       To_StdLogicVector(INIT_06) &
                                                       To_StdLogicVector(INIT_05) &
                                                       To_StdLogicVector(INIT_04) &
                                                       To_StdLogicVector(INIT_03) &
                                                       To_StdLogicVector(INIT_02) &
                                                       To_StdLogicVector(INIT_01) &
                                                       To_StdLogicVector(INIT_00);
    variable memp_slv : std_logic_vector(2047 downto 0) := To_StdLogicVector(INITP_07) &
                                                       To_StdLogicVector(INITP_06) &
                                                       To_StdLogicVector(INITP_05) &
                                                       To_StdLogicVector(INITP_04) &
                                                       To_StdLogicVector(INITP_03) &
                                                       To_StdLogicVector(INITP_02) &
                                                       To_StdLogicVector(INITP_01) &
                                                       To_StdLogicVector(INITP_00);
    variable mem : Two_D_array_type := slv_to_two_D_array(length_b, width_b, mem_slv);
    variable memp : Two_D_parity_array_type := slv_to_two_D_parity_array(length_b, parity_width_b, memp_slv);
    variable INIT_A_reg         : std_logic_vector (3 downto 0) := "0000";
    variable INIT_B_reg         : std_logic_vector (35 downto 0) := "000000000000000000000000000000000000";
    variable ADDRA_dly_sampled : std_logic_vector(11 downto 0)   := (others => 'X');
    variable ADDRB_dly_sampled : std_logic_vector(8 downto 0)   := (others => 'X');
    variable ADDRESS_A         : integer;
    variable ADDRESS_B         : integer;
    variable DOA_OV_LSB        : integer;
    variable DOA_OV_MSB        : integer;
    variable DOA_zd            : std_logic_vector(3 downto 0);
    variable DOB_OV_LSB        : integer;
    variable DOB_OV_MSB        : integer;
    variable DOB_zd            : std_logic_vector(31 downto 0);
    variable DOPA_OV_LSB       : integer;
    variable DOPA_OV_MSB       : integer;
    variable DOPB_OV_LSB       : integer;
    variable DOPB_OV_MSB       : integer;
    variable DOPB_zd           : std_logic_vector(3 downto 0);
    variable ENA_dly_sampled   : std_ulogic                      := 'X';
    variable ENB_dly_sampled   : std_ulogic                      := 'X';
    variable FIRST_TIME        : boolean                        := true;
    variable HAS_OVERLAP       : boolean                        := false;
    variable HAS_OVERLAP_P     : boolean                        := false;
    variable OLPP_LSB          : integer;
    variable OLPP_MSB          : integer;
    variable OLP_LSB           : integer;
    variable OLP_MSB           : integer;
    variable SRVAL_A_reg            : std_logic_vector (3 downto 0) := "0000";
    variable SRVAL_B_reg            : std_logic_vector (35 downto 0) := "000000000000000000000000000000000000";
    variable SSRA_dly_sampled  : std_ulogic                      := 'X';
    variable SSRB_dly_sampled  : std_ulogic                      := 'X';
    variable VALID_ADDRA       : boolean                        := false;
    variable VALID_ADDRB       : boolean                        := false;
    variable WR_A_LATER        : boolean                        := false;
    variable WR_B_LATER        : boolean                        := false;
    variable ViolationA        : std_ulogic                     := '0';
    variable ViolationB        : std_ulogic                     := '0';
    variable ViolationCLKAB    : std_ulogic                     := '0';
    variable ViolationCLKAB_S0 : boolean                        := false;
    variable Violation_S1      : boolean                        := false;
    variable Violation_S3      : boolean                        := false;
    variable WEA_dly_sampled   : std_ulogic                      := 'X';
    variable WEB_dly_sampled   : std_ulogic                      := 'X';
    variable wr_mode_a         : integer                        := 0;
    variable wr_mode_b         : integer                        := 0;
    variable collision_type : integer := 3;

  begin
    if (FIRST_TIME) then
      if ((SIM_COLLISION_CHECK = "none") or (SIM_COLLISION_CHECK = "NONE"))  then
        collision_type := 0;
      elsif ((SIM_COLLISION_CHECK = "warning_only") or (SIM_COLLISION_CHECK = "WARNING_ONLY"))  then
        collision_type := 1;
      elsif ((SIM_COLLISION_CHECK = "generate_x_only") or (SIM_COLLISION_CHECK = "GENERATE_X_ONLY"))  then
        collision_type := 2;
      elsif ((SIM_COLLISION_CHECK = "all") or (SIM_COLLISION_CHECK = "ALL"))  then        
        collision_type := 3;
      else
        GenericValueCheckMessage
          (HeaderMsg => "Attribute Syntax Error",
           GenericName => "SIM_COLLISION_CHECK",
           EntityName => "X_RAMB16_S4_S36",
           GenericValue => SIM_COLLISION_CHECK,
           Unit => "",
           ExpectedValueMsg => "Legal Values for this attribute are ALL, NONE, WARNING_ONLY or GENERATE_X_ONLY",
           ExpectedGenericValue => "",
           TailMsg => "",
           MsgSeverity => error
           );
      end if;
      if (INIT_A'length > 4) then
        INIT_A_reg(3 downto 0)        := To_StdLogicVector(INIT_A)(3 downto 0);
      else
        INIT_A_reg(INIT_A'length-1 downto 0)         := To_StdLogicVector(INIT_A);
      end if;
      DOA_zd(3 downto 0)                       := INIT_A_reg(3 downto 0);
      DOA  <= DOA_zd;

      if (INIT_B'length > 36) then
        INIT_B_reg(35 downto 0)        := To_StdLogicVector(INIT_B)(35 downto 0);
      else
        INIT_B_reg(INIT_B'length-1 downto 0)         := To_StdLogicVector(INIT_B);
      end if;
      DOB_zd(31 downto 0)                       := INIT_B_reg(31 downto 0);
      DOPB_zd(3 downto 0)                       := INIT_B_reg(35 downto 32);
      DOB  <= DOB_zd;
      DOPB <= DOPB_zd;

      if (SRVAL_A'length > 4) then
        SRVAL_A_reg(3 downto 0)        := To_StdLogicVector(SRVAL_A)(3 downto 0);
      else
        SRVAL_A_reg(SRVAL_A'length-1 downto 0)         := To_StdLogicVector(SRVAL_A);
      end if;
      if (SRVAL_B'length > 36) then
        SRVAL_B_reg(35 downto 0)        := To_StdLogicVector(SRVAL_B)(35 downto 0);
      else
        SRVAL_B_reg(SRVAL_B'length-1 downto 0)         := To_StdLogicVector(SRVAL_B);
      end if;
      if ((WRITE_MODE_A = "write_first") or (WRITE_MODE_A = "WRITE_FIRST")) then
        wr_mode_a := 0;
      elsif ((WRITE_MODE_A = "read_first") or (WRITE_MODE_A = "READ_FIRST")) then
        wr_mode_a := 1;
      elsif ((WRITE_MODE_A = "no_change") or (WRITE_MODE_A = "NO_CHANGE")) then
        wr_mode_a := 2;
      else
        GenericValueCheckMessage
          ( HeaderMsg            => " Attribute Syntax Error ",
            GenericName          => " WRITE_MODE_A ",
            EntityName           => "/X_RAMB16_S4_S36",
            GenericValue         => WRITE_MODE_A,
            Unit                 => "",
            ExpectedValueMsg     => " The Legal values for this attribute are ",
            ExpectedGenericValue => " WRITE_FIRST, READ_FIRST or NO_CHANGE ",
            TailMsg              => "",
            MsgSeverity          => error
            );
      end if;

      if ((WRITE_MODE_B = "write_first") or (WRITE_MODE_B = "WRITE_FIRST")) then
        wr_mode_b := 0;
      elsif ((WRITE_MODE_B = "read_first") or (WRITE_MODE_B = "READ_FIRST")) then
        wr_mode_b := 1;
      elsif ((WRITE_MODE_B = "no_change") or (WRITE_MODE_B = "NO_CHANGE")) then
        wr_mode_b := 2;
      else
        GenericValueCheckMessage
          ( HeaderMsg            => " Attribute Syntax Error ",
            GenericName          => " WRITE_MODE_B ",
            EntityName           => "/X_RAMB16_S4_S36",
            GenericValue         => WRITE_MODE_B,
            Unit                 => "",
            ExpectedValueMsg     => " The Legal values for this attribute are ",
            ExpectedGenericValue => " WRITE_FIRST, READ_FIRST or NO_CHANGE ",
            TailMsg              => "",
            MsgSeverity          => error
            );
      end if;
      FIRST_TIME  := false;
    end if;

    if (CLKA_dly'event) then
      ENA_dly_sampled   := ENA_dly;
      SSRA_dly_sampled  := SSRA_dly;
      WEA_dly_sampled   := WEA_dly;
      ADDRA_dly_sampled := ADDRA_dly;
    end if;

    if (CLKB_dly'event) then
      ENB_dly_sampled   := ENB_dly;
      SSRB_dly_sampled  := SSRB_dly;
      WEB_dly_sampled   := WEB_dly;
      ADDRB_dly_sampled := ADDRB_dly;
    end if;
    if (TimingChecksOn) then
      VitalRecoveryRemovalCheck (
        Violation      => Tviol_GSR_CLKA_posedge,
        TimingData     => Tmkr_GSR_CLKA_posedge,
        TestSignal     => GSR_CLKA_dly,
        TestSignalName => "GSR",
        TestDelay      => tisd_GSR_CLKA,
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        Recovery       => trecovery_GSR_CLKA_negedge_posedge,
        Removal        => thold_GSR_CLKA_negedge_posedge,
        ActiveLow      => false,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ENA_CLKA_posedge,
        TimingData     => Tmkr_ENA_CLKA_posedge,
        TestSignal     => ENA_dly,
        TestSignalName => "ENA",
        TestDelay      => tisd_ENA_CLKA,
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ENA_CLKA_posedge_posedge,
        SetupLow       => tsetup_ENA_CLKA_negedge_posedge,
        HoldLow        => thold_ENA_CLKA_negedge_posedge,
        HoldHigh       => thold_ENA_CLKA_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_SSRA_CLKA_posedge,
        TimingData     => Tmkr_SSRA_CLKA_posedge,
        TestSignal     => SSRA_dly,
        TestSignalName => "SSRA",
        TestDelay      => tisd_SSRA_CLKA,
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_SSRA_CLKA_posedge_posedge,
        SetupLow       => tsetup_SSRA_CLKA_negedge_posedge,
        HoldLow        => thold_SSRA_CLKA_negedge_posedge,
        HoldHigh       => thold_SSRA_CLKA_posedge_posedge,
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_WEA_CLKA_posedge,
        TimingData     => Tmkr_WEA_CLKA_posedge,
        TestSignal     => WEA_dly,
        TestSignalName => "WEA",
        TestDelay      => tisd_WEA_CLKA,
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_WEA_CLKA_posedge_posedge,
        SetupLow       => tsetup_WEA_CLKA_negedge_posedge,
        HoldLow        => thold_WEA_CLKA_negedge_posedge,
        HoldHigh       => thold_WEA_CLKA_posedge_posedge,
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA0_CLKA_posedge,
        TimingData     => Tmkr_ADDRA0_CLKA_posedge,
        TestSignal     => ADDRA_dly(0),
        TestSignalName => "ADDRA(0)",
        TestDelay      => tisd_ADDRA_CLKA(0),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(0),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(0),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(0),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(0),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA1_CLKA_posedge,
        TimingData     => Tmkr_ADDRA1_CLKA_posedge,
        TestSignal     => ADDRA_dly(1),
        TestSignalName => "ADDRA(1)",
        TestDelay      => tisd_ADDRA_CLKA(1),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(1),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(1),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(1),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(1),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA2_CLKA_posedge,
        TimingData     => Tmkr_ADDRA2_CLKA_posedge,
        TestSignal     => ADDRA_dly(2),
        TestSignalName => "ADDRA(2)",
        TestDelay      => tisd_ADDRA_CLKA(2),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(2),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(2),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(2),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(2),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA3_CLKA_posedge,
        TimingData     => Tmkr_ADDRA3_CLKA_posedge,
        TestSignal     => ADDRA_dly(3),
        TestSignalName => "ADDRA(3)",
        TestDelay      => tisd_ADDRA_CLKA(3),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(3),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(3),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(3),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(3),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA4_CLKA_posedge,
        TimingData     => Tmkr_ADDRA4_CLKA_posedge,
        TestSignal     => ADDRA_dly(4),
        TestSignalName => "ADDRA(4)",
        TestDelay      => tisd_ADDRA_CLKA(4),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(4),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(4),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(4),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(4),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA5_CLKA_posedge,
        TimingData     => Tmkr_ADDRA5_CLKA_posedge,
        TestSignal     => ADDRA_dly(5),
        TestSignalName => "ADDRA(5)",
        TestDelay      => tisd_ADDRA_CLKA(5),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(5),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(5),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(5),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(5),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA6_CLKA_posedge,
        TimingData     => Tmkr_ADDRA6_CLKA_posedge,
        TestSignal     => ADDRA_dly(6),
        TestSignalName => "ADDRA(6)",
        TestDelay      => tisd_ADDRA_CLKA(6),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(6),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(6),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(6),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(6),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA7_CLKA_posedge,
        TimingData     => Tmkr_ADDRA7_CLKA_posedge,
        TestSignal     => ADDRA_dly(7),
        TestSignalName => "ADDRA(7)",
        TestDelay      => tisd_ADDRA_CLKA(7),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(7),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(7),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(7),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(7),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA8_CLKA_posedge,
        TimingData     => Tmkr_ADDRA8_CLKA_posedge,
        TestSignal     => ADDRA_dly(8),
        TestSignalName => "ADDRA(8)",
        TestDelay      => tisd_ADDRA_CLKA(8),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(8),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(8),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(8),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(8),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA9_CLKA_posedge,
        TimingData     => Tmkr_ADDRA9_CLKA_posedge,
        TestSignal     => ADDRA_dly(9),
        TestSignalName => "ADDRA(9)",
        TestDelay      => tisd_ADDRA_CLKA(9),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(9),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(9),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(9),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(9),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA10_CLKA_posedge,
        TimingData     => Tmkr_ADDRA10_CLKA_posedge,
        TestSignal     => ADDRA_dly(10),
        TestSignalName => "ADDRA(10)",
        TestDelay      => tisd_ADDRA_CLKA(10),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(10),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(10),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(10),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(10),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA11_CLKA_posedge,
        TimingData     => Tmkr_ADDRA11_CLKA_posedge,
        TestSignal     => ADDRA_dly(11),
        TestSignalName => "ADDRA(11)",
        TestDelay      => tisd_ADDRA_CLKA(11),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(11),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(11),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(11),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(11),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA0_CLKA_posedge,
        TimingData     => Tmkr_DIA0_CLKA_posedge,
        TestSignal     => DIA_dly(0),
        TestSignalName => "DIA(0)",
        TestDelay      => tisd_DIA_CLKA(0),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(0),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(0),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(0),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(0),
        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA1_CLKA_posedge,
        TimingData     => Tmkr_DIA1_CLKA_posedge,
        TestSignal     => DIA_dly(1),
        TestSignalName => "DIA(1)",
        TestDelay      => tisd_DIA_CLKA(1),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(1),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(1),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(1),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(1),
        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA2_CLKA_posedge,
        TimingData     => Tmkr_DIA2_CLKA_posedge,
        TestSignal     => DIA_dly(2),
        TestSignalName => "DIA(2)",
        TestDelay      => tisd_DIA_CLKA(2),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(2),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(2),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(2),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(2),
        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA3_CLKA_posedge,
        TimingData     => Tmkr_DIA3_CLKA_posedge,
        TestSignal     => DIA_dly(3),
        TestSignalName => "DIA(3)",
        TestDelay      => tisd_DIA_CLKA(3),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(3),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(3),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(3),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(3),
        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalRecoveryRemovalCheck (
        Violation      => Tviol_GSR_CLKB_posedge,
        TimingData     => Tmkr_GSR_CLKB_posedge,
        TestSignal     => GSR_CLKB_dly,
        TestSignalName => "GSR",
        TestDelay      => tisd_GSR_CLKB,
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        Recovery       => trecovery_GSR_CLKB_negedge_posedge,
        Removal        => thold_GSR_CLKB_negedge_posedge,
        ActiveLow      => false,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ENB_CLKB_posedge,
        TimingData     => Tmkr_ENB_CLKB_posedge,
        TestSignal     => ENB_dly,
        TestSignalName => "ENB",
        TestDelay      => tisd_ENB_CLKB,
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ENB_CLKB_posedge_posedge,
        SetupLow       => tsetup_ENB_CLKB_negedge_posedge,
        HoldLow        => thold_ENB_CLKB_negedge_posedge,
        HoldHigh       => thold_ENB_CLKB_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_SSRB_CLKB_posedge,
        TimingData     => Tmkr_SSRB_CLKB_posedge,
        TestSignal     => SSRB_dly,
        TestSignalName => "SSRB",
        TestDelay      => tisd_SSRB_CLKB,
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_SSRB_CLKB_posedge_posedge,
        SetupLow       => tsetup_SSRB_CLKB_negedge_posedge,
        HoldLow        => thold_SSRB_CLKB_negedge_posedge,
        HoldHigh       => thold_SSRB_CLKB_posedge_posedge,
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_WEB_CLKB_posedge,
        TimingData     => Tmkr_WEB_CLKB_posedge,
        TestSignal     => WEB_dly,
        TestSignalName => "WEB",
        TestDelay      => tisd_WEB_CLKB,
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_WEB_CLKB_posedge_posedge,
        SetupLow       => tsetup_WEB_CLKB_negedge_posedge,
        HoldLow        => thold_WEB_CLKB_negedge_posedge,
        HoldHigh       => thold_WEB_CLKB_posedge_posedge,
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB0_CLKB_posedge,
        TimingData     => Tmkr_ADDRB0_CLKB_posedge,
        TestSignal     => ADDRB_dly(0),
        TestSignalName => "ADDRB(0)",
        TestDelay      => tisd_ADDRB_CLKB(0),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(0),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(0),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(0),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(0),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB1_CLKB_posedge,
        TimingData     => Tmkr_ADDRB1_CLKB_posedge,
        TestSignal     => ADDRB_dly(1),
        TestSignalName => "ADDRB(1)",
        TestDelay      => tisd_ADDRB_CLKB(1),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(1),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(1),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(1),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(1),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB2_CLKB_posedge,
        TimingData     => Tmkr_ADDRB2_CLKB_posedge,
        TestSignal     => ADDRB_dly(2),
        TestSignalName => "ADDRB(2)",
        TestDelay      => tisd_ADDRB_CLKB(2),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(2),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(2),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(2),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(2),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB3_CLKB_posedge,
        TimingData     => Tmkr_ADDRB3_CLKB_posedge,
        TestSignal     => ADDRB_dly(3),
        TestSignalName => "ADDRB(3)",
        TestDelay      => tisd_ADDRB_CLKB(3),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(3),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(3),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(3),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(3),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB4_CLKB_posedge,
        TimingData     => Tmkr_ADDRB4_CLKB_posedge,
        TestSignal     => ADDRB_dly(4),
        TestSignalName => "ADDRB(4)",
        TestDelay      => tisd_ADDRB_CLKB(4),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(4),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(4),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(4),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(4),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB5_CLKB_posedge,
        TimingData     => Tmkr_ADDRB5_CLKB_posedge,
        TestSignal     => ADDRB_dly(5),
        TestSignalName => "ADDRB(5)",
        TestDelay      => tisd_ADDRB_CLKB(5),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(5),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(5),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(5),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(5),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB6_CLKB_posedge,
        TimingData     => Tmkr_ADDRB6_CLKB_posedge,
        TestSignal     => ADDRB_dly(6),
        TestSignalName => "ADDRB(6)",
        TestDelay      => tisd_ADDRB_CLKB(6),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(6),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(6),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(6),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(6),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB7_CLKB_posedge,
        TimingData     => Tmkr_ADDRB7_CLKB_posedge,
        TestSignal     => ADDRB_dly(7),
        TestSignalName => "ADDRB(7)",
        TestDelay      => tisd_ADDRB_CLKB(7),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(7),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(7),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(7),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(7),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB8_CLKB_posedge,
        TimingData     => Tmkr_ADDRB8_CLKB_posedge,
        TestSignal     => ADDRB_dly(8),
        TestSignalName => "ADDRB(8)",
        TestDelay      => tisd_ADDRB_CLKB(8),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(8),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(8),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(8),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(8),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIPB0_CLKB_posedge,
        TimingData     => Tmkr_DIPB0_CLKB_posedge,
        TestSignal     => DIPB_dly(0),
        TestSignalName => "DIPB(0)",
        TestDelay      => tisd_DIPB_CLKB(0),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIPB_CLKB_posedge_posedge(0),
        SetupLow       => tsetup_DIPB_CLKB_negedge_posedge(0),
        HoldLow        => thold_DIPB_CLKB_negedge_posedge(0),
        HoldHigh       => thold_DIPB_CLKB_posedge_posedge(0),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIPB1_CLKB_posedge,
        TimingData     => Tmkr_DIPB1_CLKB_posedge,
        TestSignal     => DIPB_dly(1),
        TestSignalName => "DIPB(1)",
        TestDelay      => tisd_DIPB_CLKB(1),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIPB_CLKB_posedge_posedge(1),
        SetupLow       => tsetup_DIPB_CLKB_negedge_posedge(1),
        HoldLow        => thold_DIPB_CLKB_negedge_posedge(1),
        HoldHigh       => thold_DIPB_CLKB_posedge_posedge(1),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIPB2_CLKB_posedge,
        TimingData     => Tmkr_DIPB2_CLKB_posedge,
        TestSignal     => DIPB_dly(2),
        TestSignalName => "DIPB(2)",
        TestDelay      => tisd_DIPB_CLKB(2),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIPB_CLKB_posedge_posedge(2),
        SetupLow       => tsetup_DIPB_CLKB_negedge_posedge(2),
        HoldLow        => thold_DIPB_CLKB_negedge_posedge(2),
        HoldHigh       => thold_DIPB_CLKB_posedge_posedge(2),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIPB3_CLKB_posedge,
        TimingData     => Tmkr_DIPB3_CLKB_posedge,
        TestSignal     => DIPB_dly(3),
        TestSignalName => "DIPB(3)",
        TestDelay      => tisd_DIPB_CLKB(3),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIPB_CLKB_posedge_posedge(3),
        SetupLow       => tsetup_DIPB_CLKB_negedge_posedge(3),
        HoldLow        => thold_DIPB_CLKB_negedge_posedge(3),
        HoldHigh       => thold_DIPB_CLKB_posedge_posedge(3),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB0_CLKB_posedge,
        TimingData     => Tmkr_DIB0_CLKB_posedge,
        TestSignal     => DIB_dly(0),
        TestSignalName => "DIB(0)",
        TestDelay      => tisd_DIB_CLKB(0),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(0),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(0),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(0),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(0),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB1_CLKB_posedge,
        TimingData     => Tmkr_DIB1_CLKB_posedge,
        TestSignal     => DIB_dly(1),
        TestSignalName => "DIB(1)",
        TestDelay      => tisd_DIB_CLKB(1),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(1),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(1),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(1),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(1),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB2_CLKB_posedge,
        TimingData     => Tmkr_DIB2_CLKB_posedge,
        TestSignal     => DIB_dly(2),
        TestSignalName => "DIB(2)",
        TestDelay      => tisd_DIB_CLKB(2),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(2),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(2),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(2),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(2),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB3_CLKB_posedge,
        TimingData     => Tmkr_DIB3_CLKB_posedge,
        TestSignal     => DIB_dly(3),
        TestSignalName => "DIB(3)",
        TestDelay      => tisd_DIB_CLKB(3),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(3),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(3),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(3),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(3),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB4_CLKB_posedge,
        TimingData     => Tmkr_DIB4_CLKB_posedge,
        TestSignal     => DIB_dly(4),
        TestSignalName => "DIB(4)",
        TestDelay      => tisd_DIB_CLKB(4),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(4),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(4),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(4),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(4),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB5_CLKB_posedge,
        TimingData     => Tmkr_DIB5_CLKB_posedge,
        TestSignal     => DIB_dly(5),
        TestSignalName => "DIB(5)",
        TestDelay      => tisd_DIB_CLKB(5),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(5),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(5),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(5),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(5),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB6_CLKB_posedge,
        TimingData     => Tmkr_DIB6_CLKB_posedge,
        TestSignal     => DIB_dly(6),
        TestSignalName => "DIB(6)",
        TestDelay      => tisd_DIB_CLKB(6),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(6),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(6),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(6),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(6),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB7_CLKB_posedge,
        TimingData     => Tmkr_DIB7_CLKB_posedge,
        TestSignal     => DIB_dly(7),
        TestSignalName => "DIB(7)",
        TestDelay      => tisd_DIB_CLKB(7),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(7),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(7),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(7),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(7),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB8_CLKB_posedge,
        TimingData     => Tmkr_DIB8_CLKB_posedge,
        TestSignal     => DIB_dly(8),
        TestSignalName => "DIB(8)",
        TestDelay      => tisd_DIB_CLKB(8),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(8),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(8),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(8),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(8),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB9_CLKB_posedge,
        TimingData     => Tmkr_DIB9_CLKB_posedge,
        TestSignal     => DIB_dly(9),
        TestSignalName => "DIB(9)",
        TestDelay      => tisd_DIB_CLKB(9),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(9),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(9),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(9),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(9),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB10_CLKB_posedge,
        TimingData     => Tmkr_DIB10_CLKB_posedge,
        TestSignal     => DIB_dly(10),
        TestSignalName => "DIB(10)",
        TestDelay      => tisd_DIB_CLKB(10),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(10),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(10),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(10),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(10),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB11_CLKB_posedge,
        TimingData     => Tmkr_DIB11_CLKB_posedge,
        TestSignal     => DIB_dly(11),
        TestSignalName => "DIB(11)",
        TestDelay      => tisd_DIB_CLKB(11),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(11),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(11),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(11),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(11),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB12_CLKB_posedge,
        TimingData     => Tmkr_DIB12_CLKB_posedge,
        TestSignal     => DIB_dly(12),
        TestSignalName => "DIB(12)",
        TestDelay      => tisd_DIB_CLKB(12),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(12),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(12),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(12),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(12),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB13_CLKB_posedge,
        TimingData     => Tmkr_DIB13_CLKB_posedge,
        TestSignal     => DIB_dly(13),
        TestSignalName => "DIB(13)",
        TestDelay      => tisd_DIB_CLKB(13),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(13),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(13),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(13),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(13),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB14_CLKB_posedge,
        TimingData     => Tmkr_DIB14_CLKB_posedge,
        TestSignal     => DIB_dly(14),
        TestSignalName => "DIB(14)",
        TestDelay      => tisd_DIB_CLKB(14),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(14),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(14),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(14),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(14),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB15_CLKB_posedge,
        TimingData     => Tmkr_DIB15_CLKB_posedge,
        TestSignal     => DIB_dly(15),
        TestSignalName => "DIB(15)",
        TestDelay      => tisd_DIB_CLKB(15),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(15),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(15),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(15),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(15),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB16_CLKB_posedge,
        TimingData     => Tmkr_DIB16_CLKB_posedge,
        TestSignal     => DIB_dly(16),
        TestSignalName => "DIB(16)",
        TestDelay      => tisd_DIB_CLKB(16),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(16),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(16),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(16),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(16),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB17_CLKB_posedge,
        TimingData     => Tmkr_DIB17_CLKB_posedge,
        TestSignal     => DIB_dly(17),
        TestSignalName => "DIB(17)",
        TestDelay      => tisd_DIB_CLKB(17),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(17),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(17),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(17),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(17),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB18_CLKB_posedge,
        TimingData     => Tmkr_DIB18_CLKB_posedge,
        TestSignal     => DIB_dly(18),
        TestSignalName => "DIB(18)",
        TestDelay      => tisd_DIB_CLKB(18),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(18),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(18),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(18),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(18),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB19_CLKB_posedge,
        TimingData     => Tmkr_DIB19_CLKB_posedge,
        TestSignal     => DIB_dly(19),
        TestSignalName => "DIB(19)",
        TestDelay      => tisd_DIB_CLKB(19),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(19),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(19),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(19),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(19),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB20_CLKB_posedge,
        TimingData     => Tmkr_DIB20_CLKB_posedge,
        TestSignal     => DIB_dly(20),
        TestSignalName => "DIB(20)",
        TestDelay      => tisd_DIB_CLKB(20),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(20),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(20),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(20),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(20),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB21_CLKB_posedge,
        TimingData     => Tmkr_DIB21_CLKB_posedge,
        TestSignal     => DIB_dly(21),
        TestSignalName => "DIB(21)",
        TestDelay      => tisd_DIB_CLKB(21),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(21),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(21),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(21),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(21),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB22_CLKB_posedge,
        TimingData     => Tmkr_DIB22_CLKB_posedge,
        TestSignal     => DIB_dly(22),
        TestSignalName => "DIB(22)",
        TestDelay      => tisd_DIB_CLKB(22),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(22),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(22),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(22),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(22),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB23_CLKB_posedge,
        TimingData     => Tmkr_DIB23_CLKB_posedge,
        TestSignal     => DIB_dly(23),
        TestSignalName => "DIB(23)",
        TestDelay      => tisd_DIB_CLKB(23),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(23),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(23),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(23),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(23),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB24_CLKB_posedge,
        TimingData     => Tmkr_DIB24_CLKB_posedge,
        TestSignal     => DIB_dly(24),
        TestSignalName => "DIB(24)",
        TestDelay      => tisd_DIB_CLKB(24),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(24),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(24),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(24),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(24),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB25_CLKB_posedge,
        TimingData     => Tmkr_DIB25_CLKB_posedge,
        TestSignal     => DIB_dly(25),
        TestSignalName => "DIB(25)",
        TestDelay      => tisd_DIB_CLKB(25),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(25),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(25),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(25),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(25),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB26_CLKB_posedge,
        TimingData     => Tmkr_DIB26_CLKB_posedge,
        TestSignal     => DIB_dly(26),
        TestSignalName => "DIB(26)",
        TestDelay      => tisd_DIB_CLKB(26),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(26),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(26),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(26),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(26),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB27_CLKB_posedge,
        TimingData     => Tmkr_DIB27_CLKB_posedge,
        TestSignal     => DIB_dly(27),
        TestSignalName => "DIB(27)",
        TestDelay      => tisd_DIB_CLKB(27),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(27),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(27),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(27),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(27),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB28_CLKB_posedge,
        TimingData     => Tmkr_DIB28_CLKB_posedge,
        TestSignal     => DIB_dly(28),
        TestSignalName => "DIB(28)",
        TestDelay      => tisd_DIB_CLKB(28),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(28),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(28),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(28),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(28),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB29_CLKB_posedge,
        TimingData     => Tmkr_DIB29_CLKB_posedge,
        TestSignal     => DIB_dly(29),
        TestSignalName => "DIB(29)",
        TestDelay      => tisd_DIB_CLKB(29),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(29),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(29),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(29),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(29),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB30_CLKB_posedge,
        TimingData     => Tmkr_DIB30_CLKB_posedge,
        TestSignal     => DIB_dly(30),
        TestSignalName => "DIB(30)",
        TestDelay      => tisd_DIB_CLKB(30),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(30),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(30),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(30),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(30),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB31_CLKB_posedge,
        TimingData     => Tmkr_DIB31_CLKB_posedge,
        TestSignal     => DIB_dly(31),
        TestSignalName => "DIB(31)",
        TestDelay      => tisd_DIB_CLKB(31),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(31),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(31),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(31),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(31),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalPeriodPulseCheck (
        Violation      => Pviol_CLKA,
        PeriodData     => PInfo_CLKA,
        TestSignal     => CLKA_dly,
        TestSignalName => "CLKA",
        TestDelay      => 0 ps,
        Period         => 0 ps,
        PulseWidthHigh => tpw_CLKA_posedge,
        PulseWidthLow  => tpw_CLKA_negedge,
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalPeriodPulseCheck (
        Violation      => Pviol_CLKB,
        PeriodData     => PInfo_CLKB,
        TestSignal     => CLKB_dly,
        TestSignalName => "CLKB",
        TestDelay      => 0 ps,
        Period         => 0 ps,
        PulseWidthHigh => tpw_CLKB_posedge,
        PulseWidthLow  => tpw_CLKB_negedge,
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalPeriodPulseCheck (
        Violation      => Pviol_GSR,
        PeriodData     => PInfo_GSR,
        TestSignal     => GSR_ipd,
        TestSignalName => "GSR",
        TestDelay      => 0 ps,
        Period         => 0 ps,
        PulseWidthHigh => tpw_GSR_posedge,
        PulseWidthLow  => 0 ps,
        CheckEnabled   => true,
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
    end if;
    ViolationA          :=
      Tviol_ADDRA0_CLKA_posedge or
      Tviol_ADDRA1_CLKA_posedge or
      Tviol_ADDRA2_CLKA_posedge or
      Tviol_ADDRA3_CLKA_posedge or
      Tviol_ADDRA4_CLKA_posedge or
      Tviol_ADDRA5_CLKA_posedge or
      Tviol_ADDRA6_CLKA_posedge or
      Tviol_ADDRA7_CLKA_posedge or
      Tviol_ADDRA8_CLKA_posedge or
      Tviol_ADDRA9_CLKA_posedge or
      Tviol_ADDRA10_CLKA_posedge or
      Tviol_ADDRA11_CLKA_posedge or
      Tviol_DIA0_CLKA_posedge or
      Tviol_DIA1_CLKA_posedge or
      Tviol_DIA2_CLKA_posedge or
      Tviol_DIA3_CLKA_posedge or
      Tviol_ENA_CLKA_posedge or
      Tviol_SSRA_CLKA_posedge or
      Tviol_WEA_CLKA_posedge or
      Pviol_CLKA ;
    ViolationB          :=
      Tviol_ADDRB0_CLKB_posedge or
      Tviol_ADDRB1_CLKB_posedge or
      Tviol_ADDRB2_CLKB_posedge or
      Tviol_ADDRB3_CLKB_posedge or
      Tviol_ADDRB4_CLKB_posedge or
      Tviol_ADDRB5_CLKB_posedge or
      Tviol_ADDRB6_CLKB_posedge or
      Tviol_ADDRB7_CLKB_posedge or
      Tviol_ADDRB8_CLKB_posedge or
      Tviol_DIB0_CLKB_posedge or
      Tviol_DIB1_CLKB_posedge or
      Tviol_DIB2_CLKB_posedge or
      Tviol_DIB3_CLKB_posedge or
      Tviol_DIB4_CLKB_posedge or
      Tviol_DIB5_CLKB_posedge or
      Tviol_DIB6_CLKB_posedge or
      Tviol_DIB7_CLKB_posedge or
      Tviol_DIB8_CLKB_posedge or
      Tviol_DIB9_CLKB_posedge or
      Tviol_DIB10_CLKB_posedge or
      Tviol_DIB11_CLKB_posedge or
      Tviol_DIB12_CLKB_posedge or
      Tviol_DIB13_CLKB_posedge or
      Tviol_DIB14_CLKB_posedge or
      Tviol_DIB15_CLKB_posedge or
      Tviol_DIB16_CLKB_posedge or
      Tviol_DIB17_CLKB_posedge or
      Tviol_DIB18_CLKB_posedge or
      Tviol_DIB19_CLKB_posedge or
      Tviol_DIB20_CLKB_posedge or
      Tviol_DIB21_CLKB_posedge or
      Tviol_DIB22_CLKB_posedge or
      Tviol_DIB23_CLKB_posedge or
      Tviol_DIB24_CLKB_posedge or
      Tviol_DIB25_CLKB_posedge or
      Tviol_DIB26_CLKB_posedge or
      Tviol_DIB27_CLKB_posedge or
      Tviol_DIB28_CLKB_posedge or
      Tviol_DIB29_CLKB_posedge or
      Tviol_DIB30_CLKB_posedge or
      Tviol_DIB31_CLKB_posedge or
      Tviol_DIPB0_CLKB_posedge or
      Tviol_DIPB1_CLKB_posedge or
      Tviol_DIPB2_CLKB_posedge or
      Tviol_DIPB3_CLKB_posedge or
      Tviol_ENB_CLKB_posedge or
      Tviol_SSRB_CLKB_posedge or
      Tviol_WEB_CLKB_posedge or
      Pviol_CLKB ;

    VALID_ADDRA           := ADDR_IS_VALID(addra_dly_sampled);
    if (VALID_ADDRA) then
      ADDRESS_A           := SLV_TO_INT(addra_dly_sampled);
    end if;
    VALID_ADDRB           := ADDR_IS_VALID(addrb_dly_sampled);
    if (VALID_ADDRB) then
      ADDRESS_B           := SLV_TO_INT(addrb_dly_sampled);
    end if;
    if (VALID_ADDRA and VALID_ADDRB) then
      ADDR_OVERLAP (ADDRESS_A, ADDRESS_B, WIDTH_A, WIDTH_B, HAS_OVERLAP, OLP_LSB, OLP_MSB, DOA_OV_LSB, DOA_OV_MSB, DOB_OV_LSB, DOB_OV_MSB);
    end if;
    ViolationCLKAB        := '0';
    ViolationCLKAB_S0     := false;
    Violation_S1          := false;
    Violation_S3          := false;
    if ((collision_type = 1) or (collision_type = 2) or (collision_type = 3)) then    
      VitalRecoveryRemovalCheck (
        Violation      => Tviol_CLKB_CLKA_all,
        TimingData     => Tmkr_CLKB_CLKA_all,
        TestSignal     => CLKB_dly,
        TestSignalName => "CLKB",
        TestDelay      => 0 ps,
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => 0 ps,
        Recovery       => SETUP_ALL,
        Removal       => 1 ps,
        ActiveLow      => true,
        CheckEnabled   => (HAS_OVERLAP = true and ena_dly_sampled = '1' and enb_dly_sampled = '1' and ((web_dly_sampled = '1' and wr_mode_b /= 1) or (wea_dly_sampled = '1' and wr_mode_a /= 1 and web_dly_sampled = '0'))),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => true,
        MsgOn          => false,
        MsgSeverity    => warning);

      VitalRecoveryRemovalCheck (
        Violation      => Tviol_CLKA_CLKB_all,
        TimingData     => Tmkr_CLKA_CLKB_all,
        TestSignal     => CLKA_dly,
        TestSignalName => "CLKA",
        TestDelay      => 0 ps,
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => 0 ps,
        Recovery       => SETUP_ALL,
        Removal       => 1 ps,
        ActiveLow      => true,
        CheckEnabled   => (HAS_OVERLAP = true and ena_dly_sampled = '1' and enb_dly_sampled = '1' and ((wea_dly_sampled = '1' and wr_mode_a /= 1) or (web_dly_sampled = '1' and wea_dly_sampled = '0' and wr_mode_b /= 1))),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => true,
        MsgOn          => false,
        MsgSeverity    => warning);

      VitalRecoveryRemovalCheck (
        Violation      => Tviol_CLKB_CLKA_read_first,
        TimingData     => Tmkr_CLKB_CLKA_read_first,
        TestSignal     => CLKB_dly,
        TestSignalName => "CLKB",
        TestDelay      => 0 ps,
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => 0 ps,
        Recovery       => SETUP_READ_FIRST,
        Removal       => 1 ps,
        ActiveLow      => true,
        CheckEnabled   => (HAS_OVERLAP = true and ena_dly_sampled = '1' and enb_dly_sampled = '1' and web_dly_sampled = '1' and wr_mode_b = 1 and (CLKA_dly'last_event /= CLKB_dly'last_event)),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => true,
        MsgOn          => false,
        MsgSeverity    => warning);

      VitalRecoveryRemovalCheck (
        Violation      => Tviol_CLKA_CLKB_read_first,
        TimingData     => Tmkr_CLKA_CLKB_read_first,
        TestSignal     => CLKA_dly,
        TestSignalName => "CLKA",
        TestDelay      => 0 ps,
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => 0 ps,
        Recovery       => SETUP_READ_FIRST,
        Removal       => 1 ps,
        ActiveLow      => true,
        CheckEnabled   => (HAS_OVERLAP = true and ena_dly_sampled = '1' and enb_dly_sampled = '1' and wea_dly_sampled = '1' and wr_mode_a = 1 and (CLKA_dly'last_event /= CLKB_dly'last_event)),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S36",
        Xon            => true,
        MsgOn          => false,
        MsgSeverity    => warning);        
    end if;
    ViolationCLKAB := Tviol_CLKB_CLKA_all or Tviol_CLKA_CLKB_all or Tviol_CLKB_CLKA_read_first or Tviol_CLKA_CLKB_read_first;        



    WR_A_LATER := false;
    WR_B_LATER := false;

    if (GSR_CLKA_dly = '1') then
      DOA_zd  := INIT_A_reg ( 3 downto 0);

    elsif (GSR_CLKA_dly = '0') then
      if (ena_dly_sampled = '1') then
        if (rising_edge(CLKA_dly)) then
          if (wea_dly_sampled = '1') then
            case wr_mode_a is
              when 0 =>
                DOA_zd  := DIA_dly;

                if (ViolationCLKAB = 'X') then
                  if (web_dly_sampled /= '0') then
                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Write_A_Write_B,
                         EntityName => "/X_RAMB16_S4_S36",
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      MEM(ADDRESS_A/(length_a/length_b))(DOB_OV_MSB downto DOB_OV_LSB) := (others => 'X');
                      DOA_zd := (others => 'X');
                      if (wr_mode_b /= 2 ) then
                        DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)    := (others => 'X');
                      end if;
                    end if;
                  else

                    if ((collision_type = 1) or (collision_type = 3)) then                
                      Memory_Collision_Msg
                        (collision_type => Read_B_Write_A,
                         EntityName => "/X_RAMB16_S4_S36",
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a))):= DIA_dly;
                    if ((collision_type = 2) or (collision_type = 3)) then                
                      DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)                      := (others => 'X');
                    end if;
                  end if;
                else

                  if (VALID_ADDRA) then
                    MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a))):= DIA_dly;
                  end if;
                end if;
              when 1 =>

                if (VALID_ADDRA) then
                  DOA_zd  := MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a)));
                  WR_A_LATER := true;
                end if;

                if (ViolationCLKAB = 'X') then

                  if (web_dly_sampled /= '0') then
                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Write_A_Write_B,
                         EntityName => "/X_RAMB16_S4_S36",
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      MEM(ADDRESS_A/(length_a/length_b))(DOB_OV_MSB downto DOB_OV_LSB) := (others => 'X');
                      DOA_zd := (others => 'X');
                      if (wr_mode_b /= 2 ) then
                        DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)    := (others => 'X');
                      end if;
                    end if;
                  else

                    if ((collision_type = 1) or (collision_type = 3)) then                
                      Memory_Collision_Msg
                        (collision_type => Read_B_Write_A,
                         EntityName => "/X_RAMB16_S4_S36",
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a))):= DIA_dly;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)                      := (others => 'X');
                    end if;
                  end if;
                end if;
              when 2 =>
                if (ViolationCLKAB = 'X') then

                  if (web_dly_sampled /= '0') then
                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Write_A_Write_B,
                         EntityName => "/X_RAMB16_S4_S36",
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      MEM(ADDRESS_A/(length_a/length_b))(DOB_OV_MSB downto DOB_OV_LSB) := (others => 'X');
                      if (wr_mode_b /= 2 ) then

                        DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)    := (others => 'X');
                      end if;
                    end if;
                  else

                    if ((collision_type = 1) or (collision_type = 3)) then                
                      Memory_Collision_Msg
                        (collision_type => Read_B_Write_A,
                         EntityName => "/X_RAMB16_S4_S36",
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then                
                      DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)                      := (others => 'X');
                    end if;
                    MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a))):= DIA_dly;
                  end if;
                else

                  if (VALID_ADDRA) then
                    MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a))):= DIA_dly;
                  end if;
                end if;
              when others => null;
            end case;
          else

            if (VALID_ADDRA) then
                  DOA_zd  := MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a)));
            end if;
            if (ViolationCLKAB = 'X') then

              if ((collision_type = 1) or (collision_type = 3)) then                
                Memory_Collision_Msg
                  (collision_type => Read_A_Write_B,
                   EntityName => "/X_RAMB16_S4_S36",
                   address_a => addra_dly_sampled,
                   address_b => addrb_dly_sampled
                   );
              end if;
              if ((collision_type = 2) or (collision_type = 3)) then                
                DOA_zd := (others => 'X');
              end if;
            end if;
          end if;
          if (ssra_dly_sampled = '1') then

            DOA_zd  := SRVAL_A_reg(3 downto 0);
          end if;
        end if;
      end if;
    end if;

    if (GSR_CLKB_dly = '1') then

      DOB_zd  := INIT_B_reg(31 downto 0);
      DOPB_zd := INIT_B_reg(35 downto 32);
    elsif (GSR_CLKB_dly = '0') then
      if (enb_dly_sampled = '1') then
        if (rising_edge(CLKB_dly)) then
          if (web_dly_sampled = '1') then
            case wr_mode_b is
              when 0 =>

                DOB_zd  := DIB_dly;
                DOPB_zd := DIPB_dly;
                if (VALID_ADDRB) then
                  MEM(ADDRESS_B)     := DIB_dly;
                  MEMP(ADDRESS_B) := DIPB_dly;
                end if;
                if (ViolationCLKAB = 'X') then
                  if (wea_dly_sampled /= '0') then

                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Write_A_Write_B,
                         EntityName => "X_RAMB16_S4_S36",
                         InstanceName => x_ramb16_s4_s36'path_name,
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      MEM(ADDRESS_B)(DOB_OV_MSB downto DOB_OV_LSB) := (others => 'X');

                      DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)    := (others => 'X');
                      if (wr_mode_a /= 2 ) then

                        DOA_zd := (others => 'X');
                      end if;
                    end if;
                  else
                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Read_A_Write_B,
                         EntityName => "X_RAMB16_S4_S36",
                         InstanceName => x_ramb16_s4_s36'path_name,
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      DOA_zd := (others => 'X');
                    end if;
                  end if;
                end if;
              when 1 =>

                if (VALID_ADDRB) then
                  DOB_zd  := MEM(ADDRESS_B);
                  DOPB_zd := MEMP(ADDRESS_B);
                  WR_B_LATER := true;
                  MEM(ADDRESS_B)     := DIB_dly ;
                  MEMP(ADDRESS_B) := DIPB_dly;
                end if;
                if (ViolationCLKAB = 'X') then
                  if (wea_dly_sampled /= '0') then

                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Write_A_Write_B,
                         EntityName => "X_RAMB16_S4_S36",
                         InstanceName => x_ramb16_s4_s36'path_name,
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      MEM(ADDRESS_B)(DOB_OV_MSB downto DOB_OV_LSB) := (others => 'X');

                      DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)    := (others => 'X');
                      if (wr_mode_a /= 2 ) then
                        DOA_zd := (others => 'X');
                      end if;
                    end if;
                  else

                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Read_A_Write_B,
                         EntityName => "X_RAMB16_S4_S36",
                         InstanceName => x_ramb16_s4_s36'path_name,
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      DOA_zd := (others => 'X');
                    end if;
                  end if;
                end if;
              when 2 =>
                if (VALID_ADDRB) then
                  MEM(ADDRESS_B) := DIB_dly;
                  MEMP(ADDRESS_B) := DIPB_dly;
                end if;
                if (ViolationCLKAB = 'X') then
                  if (wea_dly_sampled /= '0') then

                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Write_A_Write_B,
                         EntityName => "X_RAMB16_S4_S36",
                         InstanceName => x_ramb16_s4_s36'path_name,
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      MEM(ADDRESS_B)(DOB_OV_MSB downto DOB_OV_LSB) := (others => 'X');
                      if (wr_mode_a /= 2 ) then

                        DOA_zd := (others => 'X');
                      end if;
                    end if;
                  else

                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Read_A_Write_B,
                         EntityName => "X_RAMB16_S4_S36",
                         InstanceName => x_ramb16_s4_s36'path_name,
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      DOA_zd := (others => 'X');
                    end if;
                  end if;
                end if;
              when others => null;
            end case;
          else

            if (VALID_ADDRB) then
              DOB_zd  := MEM(ADDRESS_B);
              DOPB_zd := MEMP(ADDRESS_B);
            end if;
            if (ViolationCLKAB = 'X') then

              if ((collision_type = 1) or (collision_type = 3)) then                
                Memory_Collision_Msg
                  (collision_type => Read_B_Write_A,
                   EntityName => "X_RAMB16_S4_S36",
                   InstanceName => x_ramb16_s4_s36'path_name,
                   address_a => addra_dly_sampled,
                   address_b => addrb_dly_sampled
                   );
              end if;
              if ((collision_type = 2) or (collision_type = 3)) then                
                DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)    := (others => 'X');
              end if;
            end if;
          end if;
          if (ssrb_dly_sampled = '1') then

            DOB_zd  := SRVAL_B_reg(31 downto 0);
            DOPB_zd := SRVAL_B_reg(35 downto 32);
          end if;
        end if;
      end if;
    end if;

    if ((WR_A_LATER = true ) and (VALID_ADDRA)) then
      MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a))):= DIA_dly;                    
    end if;

    if ((WR_B_LATER = true ) and (VALID_ADDRB)) then
        MEM(ADDRESS_B) := DIB_dly;
        MEMP(ADDRESS_B) := DIPB_dly;
    end if;

    DOA_zd(0)  := ViolationA xor DOA_zd(0);
    DOA_zd(1)  := ViolationA xor DOA_zd(1);
    DOA_zd(2)  := ViolationA xor DOA_zd(2);
    DOA_zd(3)  := ViolationA xor DOA_zd(3);
    DOB_zd(0)  := ViolationB xor DOB_zd(0);
    DOB_zd(1)  := ViolationB xor DOB_zd(1);
    DOB_zd(2)  := ViolationB xor DOB_zd(2);
    DOB_zd(3)  := ViolationB xor DOB_zd(3);
    DOB_zd(4)  := ViolationB xor DOB_zd(4);
    DOB_zd(5)  := ViolationB xor DOB_zd(5);
    DOB_zd(6)  := ViolationB xor DOB_zd(6);
    DOB_zd(7)  := ViolationB xor DOB_zd(7);
    DOB_zd(8)  := ViolationB xor DOB_zd(8);
    DOB_zd(9)  := ViolationB xor DOB_zd(9);
    DOB_zd(10)  := ViolationB xor DOB_zd(10);
    DOB_zd(11)  := ViolationB xor DOB_zd(11);
    DOB_zd(12)  := ViolationB xor DOB_zd(12);
    DOB_zd(13)  := ViolationB xor DOB_zd(13);
    DOB_zd(14)  := ViolationB xor DOB_zd(14);
    DOB_zd(15)  := ViolationB xor DOB_zd(15);
    DOB_zd(16)  := ViolationB xor DOB_zd(16);
    DOB_zd(17)  := ViolationB xor DOB_zd(17);
    DOB_zd(18)  := ViolationB xor DOB_zd(18);
    DOB_zd(19)  := ViolationB xor DOB_zd(19);
    DOB_zd(20)  := ViolationB xor DOB_zd(20);
    DOB_zd(21)  := ViolationB xor DOB_zd(21);
    DOB_zd(22)  := ViolationB xor DOB_zd(22);
    DOB_zd(23)  := ViolationB xor DOB_zd(23);
    DOB_zd(24)  := ViolationB xor DOB_zd(24);
    DOB_zd(25)  := ViolationB xor DOB_zd(25);
    DOB_zd(26)  := ViolationB xor DOB_zd(26);
    DOB_zd(27)  := ViolationB xor DOB_zd(27);
    DOB_zd(28)  := ViolationB xor DOB_zd(28);
    DOB_zd(29)  := ViolationB xor DOB_zd(29);
    DOB_zd(30)  := ViolationB xor DOB_zd(30);
    DOB_zd(31)  := ViolationB xor DOB_zd(31);
    DOPB_zd(0) := ViolationB xor DOPB_zd(0);
    DOPB_zd(1) := ViolationB xor DOPB_zd(1);
    DOPB_zd(2) := ViolationB xor DOPB_zd(2);
    DOPB_zd(3) := ViolationB xor DOPB_zd(3);

    VitalPathDelay01 (
      OutSignal     => DOA(0),
      GlitchData    => DOA_GlitchData0,
      OutSignalName => "DOA(0)",
      OutTemp       => DOA_zd(0),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(0), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(0), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(1),
      GlitchData    => DOA_GlitchData1,
      OutSignalName => "DOA(1)",
      OutTemp       => DOA_zd(1),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(1), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(1), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(2),
      GlitchData    => DOA_GlitchData2,
      OutSignalName => "DOA(2)",
      OutTemp       => DOA_zd(2),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(2), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(2), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(3),
      GlitchData    => DOA_GlitchData3,
      OutSignalName => "DOA(3)",
      OutTemp       => DOA_zd(3),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(3), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(3), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(0),
      GlitchData    => DOB_GlitchData0,
      OutSignalName => "DOB(0)",
      OutTemp       => DOB_zd(0),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(0), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(0), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(1),
      GlitchData    => DOB_GlitchData1,
      OutSignalName => "DOB(1)",
      OutTemp       => DOB_zd(1),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(1), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(1), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(2),
      GlitchData    => DOB_GlitchData2,
      OutSignalName => "DOB(2)",
      OutTemp       => DOB_zd(2),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(2), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(2), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(3),
      GlitchData    => DOB_GlitchData3,
      OutSignalName => "DOB(3)",
      OutTemp       => DOB_zd(3),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(3), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(3), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(4),
      GlitchData    => DOB_GlitchData4,
      OutSignalName => "DOB(4)",
      OutTemp       => DOB_zd(4),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(4), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(4), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(5),
      GlitchData    => DOB_GlitchData5,
      OutSignalName => "DOB(5)",
      OutTemp       => DOB_zd(5),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(5), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(5), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(6),
      GlitchData    => DOB_GlitchData6,
      OutSignalName => "DOB(6)",
      OutTemp       => DOB_zd(6),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(6), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(6), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(7),
      GlitchData    => DOB_GlitchData7,
      OutSignalName => "DOB(7)",
      OutTemp       => DOB_zd(7),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(7), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(7), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(8),
      GlitchData    => DOB_GlitchData8,
      OutSignalName => "DOB(8)",
      OutTemp       => DOB_zd(8),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(8), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(8), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(9),
      GlitchData    => DOB_GlitchData9,
      OutSignalName => "DOB(9)",
      OutTemp       => DOB_zd(9),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(9), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(9), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(10),
      GlitchData    => DOB_GlitchData10,
      OutSignalName => "DOB(10)",
      OutTemp       => DOB_zd(10),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(10), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(10), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(11),
      GlitchData    => DOB_GlitchData11,
      OutSignalName => "DOB(11)",
      OutTemp       => DOB_zd(11),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(11), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(11), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(12),
      GlitchData    => DOB_GlitchData12,
      OutSignalName => "DOB(12)",
      OutTemp       => DOB_zd(12),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(12), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(12), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(13),
      GlitchData    => DOB_GlitchData13,
      OutSignalName => "DOB(13)",
      OutTemp       => DOB_zd(13),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(13), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(13), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(14),
      GlitchData    => DOB_GlitchData14,
      OutSignalName => "DOB(14)",
      OutTemp       => DOB_zd(14),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(14), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(14), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(15),
      GlitchData    => DOB_GlitchData15,
      OutSignalName => "DOB(15)",
      OutTemp       => DOB_zd(15),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(15), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(15), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(16),
      GlitchData    => DOB_GlitchData16,
      OutSignalName => "DOB(16)",
      OutTemp       => DOB_zd(16),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(16), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(16), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(17),
      GlitchData    => DOB_GlitchData17,
      OutSignalName => "DOB(17)",
      OutTemp       => DOB_zd(17),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(17), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(17), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(18),
      GlitchData    => DOB_GlitchData18,
      OutSignalName => "DOB(18)",
      OutTemp       => DOB_zd(18),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(18), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(18), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(19),
      GlitchData    => DOB_GlitchData19,
      OutSignalName => "DOB(19)",
      OutTemp       => DOB_zd(19),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(19), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(19), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(20),
      GlitchData    => DOB_GlitchData20,
      OutSignalName => "DOB(20)",
      OutTemp       => DOB_zd(20),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(20), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(20), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(21),
      GlitchData    => DOB_GlitchData21,
      OutSignalName => "DOB(21)",
      OutTemp       => DOB_zd(21),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(21), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(21), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(22),
      GlitchData    => DOB_GlitchData22,
      OutSignalName => "DOB(22)",
      OutTemp       => DOB_zd(22),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(22), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(22), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(23),
      GlitchData    => DOB_GlitchData23,
      OutSignalName => "DOB(23)",
      OutTemp       => DOB_zd(23),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(23), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(23), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(24),
      GlitchData    => DOB_GlitchData24,
      OutSignalName => "DOB(24)",
      OutTemp       => DOB_zd(24),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(24), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(24), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(25),
      GlitchData    => DOB_GlitchData25,
      OutSignalName => "DOB(25)",
      OutTemp       => DOB_zd(25),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(25), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(25), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(26),
      GlitchData    => DOB_GlitchData26,
      OutSignalName => "DOB(26)",
      OutTemp       => DOB_zd(26),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(26), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(26), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(27),
      GlitchData    => DOB_GlitchData27,
      OutSignalName => "DOB(27)",
      OutTemp       => DOB_zd(27),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(27), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(27), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(28),
      GlitchData    => DOB_GlitchData28,
      OutSignalName => "DOB(28)",
      OutTemp       => DOB_zd(28),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(28), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(28), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(29),
      GlitchData    => DOB_GlitchData29,
      OutSignalName => "DOB(29)",
      OutTemp       => DOB_zd(29),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(29), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(29), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(30),
      GlitchData    => DOB_GlitchData30,
      OutSignalName => "DOB(30)",
      OutTemp       => DOB_zd(30),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(30), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(30), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(31),
      GlitchData    => DOB_GlitchData31,
      OutSignalName => "DOB(31)",
      OutTemp       => DOB_zd(31),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(31), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(31), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOPB(0),
      GlitchData    => DOPB_GlitchData0,
      OutSignalName => "DOPB(0)",
      OutTemp       => DOPB_zd(0),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOPB(0), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(0), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOPB(1),
      GlitchData    => DOPB_GlitchData1,
      OutSignalName => "DOPB(1)",
      OutTemp       => DOPB_zd(1),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOPB(1), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(1), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOPB(2),
      GlitchData    => DOPB_GlitchData2,
      OutSignalName => "DOPB(2)",
      OutTemp       => DOPB_zd(2),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOPB(2), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(2), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOPB(3),
      GlitchData    => DOPB_GlitchData3,
      OutSignalName => "DOPB(3)",
      OutTemp       => DOPB_zd(3),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOPB(3), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(3), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    wait on ADDRA_dly, ADDRB_dly, CLKA_dly, CLKB_dly, DIA_dly, DIB_dly, DIPB_dly, ENA_dly, ENB_dly, GSR_ipd, GSR_CLKA_dly, GSR_CLKB_dly, SSRA_dly, SSRB_dly, WEA_dly, WEB_dly;
  end process VITALBehavior;
end X_RAMB16_S4_S36_V;
-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  16K-Bit Data and 2K-Bit Parity Dual Port Block RAM
-- /___/   /\     Filename : X_RAMB16_S4_S4.vhd
-- \   \  /  \    Timestamp : Thu Apr  8 10:56:56 PDT 2004
--  \___\/\___\
--
-- Revision:
--    03/23/04 - Initial version.
----- CELL x_ramb16_s4_s4 -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;

library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.VPACKAGE.all;
use simprim.VCOMPONENTS.all;

entity X_RAMB16_S4_S4 is
  generic (
    TimingChecksOn : boolean := true;
    Xon            : boolean := true;
    MsgOn          : boolean := true;

    LOC            : string  := "UNPLACED";

    tipd_ADDRA : VitalDelayArrayType01(11 downto 0)  := (others => (0 ps, 0 ps));
    tipd_CLKA  : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_DIA   : VitalDelayArrayType01(3 downto 0) := (others => (0 ps, 0 ps));
    tipd_ENA   : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_SSRA  : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_WEA   : VitalDelayType01                   := ( 0 ps, 0 ps);

    tipd_ADDRB : VitalDelayArrayType01(11 downto 0)  := (others => (0 ps, 0 ps));
    tipd_CLKB  : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_DIB   : VitalDelayArrayType01(3 downto 0) := (others => (0 ps, 0 ps));
    tipd_ENB   : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_SSRB  : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_WEB   : VitalDelayType01                   := ( 0 ps, 0 ps);

    tipd_GSR : VitalDelayType01 := ( 0 ps, 0 ps);

    tpd_GSR_DOA  : VitalDelayArrayType01(3 downto 0) := (others => (0 ps, 0 ps));
    tpd_GSR_DOB  : VitalDelayArrayType01(3 downto 0) := (others => (0 ps, 0 ps));

    tpd_CLKA_DOA  : VitalDelayArrayType01(3 downto 0) := (others => (100 ps, 100 ps));
    tpd_CLKB_DOB  : VitalDelayArrayType01(3 downto 0) := (others => (100 ps, 100 ps));

    trecovery_GSR_CLKA_negedge_posedge : VitalDelayType                   := 0 ps;
    tsetup_ADDRA_CLKA_negedge_posedge  : VitalDelayArrayType(11 downto 0)  := (others => 0 ps);
    tsetup_ADDRA_CLKA_posedge_posedge  : VitalDelayArrayType(11 downto 0)  := (others => 0 ps);
    tsetup_DIA_CLKA_negedge_posedge    : VitalDelayArrayType(3 downto 0) := (others => 0 ps);
    tsetup_DIA_CLKA_posedge_posedge    : VitalDelayArrayType(3 downto 0) := (others => 0 ps);
    tsetup_ENA_CLKA_negedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_ENA_CLKA_posedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_SSRA_CLKA_negedge_posedge   : VitalDelayType                   := 0 ps;
    tsetup_SSRA_CLKA_posedge_posedge   : VitalDelayType                   := 0 ps;
    tsetup_WEA_CLKA_negedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_WEA_CLKA_posedge_posedge    : VitalDelayType                   := 0 ps;

    trecovery_GSR_CLKB_negedge_posedge : VitalDelayType                   := 0 ps;
    tsetup_ADDRB_CLKB_negedge_posedge  : VitalDelayArrayType(11 downto 0)  := (others => 0 ps);
    tsetup_ADDRB_CLKB_posedge_posedge  : VitalDelayArrayType(11 downto 0)  := (others => 0 ps);
    tsetup_DIB_CLKB_negedge_posedge    : VitalDelayArrayType(3 downto 0) := (others => 0 ps);
    tsetup_DIB_CLKB_posedge_posedge    : VitalDelayArrayType(3 downto 0) := (others => 0 ps);
    tsetup_ENB_CLKB_negedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_ENB_CLKB_posedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_SSRB_CLKB_negedge_posedge   : VitalDelayType                   := 0 ps;
    tsetup_SSRB_CLKB_posedge_posedge   : VitalDelayType                   := 0 ps;
    tsetup_WEB_CLKB_negedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_WEB_CLKB_posedge_posedge    : VitalDelayType                   := 0 ps;

    thold_ADDRA_CLKA_negedge_posedge : VitalDelayArrayType(11 downto 0)  := (others => 0 ps);
    thold_ADDRA_CLKA_posedge_posedge : VitalDelayArrayType(11 downto 0)  := (others => 0 ps);
    thold_DIA_CLKA_negedge_posedge   : VitalDelayArrayType(3 downto 0) := (others => 0 ps);
    thold_DIA_CLKA_posedge_posedge   : VitalDelayArrayType(3 downto 0) := (others => 0 ps);
    thold_ENA_CLKA_negedge_posedge   : VitalDelayType                   := 0 ps;
    thold_ENA_CLKA_posedge_posedge   : VitalDelayType                   := 0 ps;
    thold_GSR_CLKA_negedge_posedge   : VitalDelayType                   := 0 ps;
    thold_SSRA_CLKA_negedge_posedge  : VitalDelayType                   := 0 ps;
    thold_SSRA_CLKA_posedge_posedge  : VitalDelayType                   := 0 ps;
    thold_WEA_CLKA_negedge_posedge   : VitalDelayType                   := 0 ps;
    thold_WEA_CLKA_posedge_posedge   : VitalDelayType                   := 0 ps;

    thold_ADDRB_CLKB_negedge_posedge : VitalDelayArrayType(11 downto 0)  := (others => 0 ps);
    thold_ADDRB_CLKB_posedge_posedge : VitalDelayArrayType(11 downto 0)  := (others => 0 ps);
    thold_DIB_CLKB_negedge_posedge   : VitalDelayArrayType(3 downto 0) := (others => 0 ps);
    thold_DIB_CLKB_posedge_posedge   : VitalDelayArrayType(3 downto 0) := (others => 0 ps);
    thold_ENB_CLKB_negedge_posedge   : VitalDelayType                   := 0 ps;
    thold_ENB_CLKB_posedge_posedge   : VitalDelayType                   := 0 ps;
    thold_GSR_CLKB_negedge_posedge   : VitalDelayType                   := 0 ps;
    thold_SSRB_CLKB_negedge_posedge  : VitalDelayType                   := 0 ps;
    thold_SSRB_CLKB_posedge_posedge  : VitalDelayType                   := 0 ps;
    thold_WEB_CLKB_negedge_posedge   : VitalDelayType                   := 0 ps;
    thold_WEB_CLKB_posedge_posedge   : VitalDelayType                   := 0 ps;

    tbpd_GSR_DOA_CLKA  : VitalDelayArrayType01(3 downto 0) := (others => (0 ps, 0 ps));
    ticd_CLKA          : VitalDelayType                     := 0 ps;
    tisd_ADDRA_CLKA    : VitalDelayArrayType(11 downto 0)    := (others => 0 ps);
    tisd_DIA_CLKA      : VitalDelayArrayType(3 downto 0)   := (others => 0 ps);
    tisd_ENA_CLKA      : VitalDelayType                     := 0 ps;
    tisd_GSR_CLKA      : VitalDelayType                     := 0 ps;
    tisd_SSRA_CLKA     : VitalDelayType                     := 0 ps;
    tisd_WEA_CLKA      : VitalDelayType                     := 0 ps;

    tbpd_GSR_DOB_CLKB  : VitalDelayArrayType01(3 downto 0) := (others => (0 ps, 0 ps));
    ticd_CLKB          : VitalDelayType                     := 0 ps;
    tisd_ADDRB_CLKB    : VitalDelayArrayType(11 downto 0)    := (others => 0 ps);
    tisd_DIB_CLKB      : VitalDelayArrayType(3 downto 0)   := (others => 0 ps);
    tisd_ENB_CLKB      : VitalDelayType                     := 0 ps;
    tisd_GSR_CLKB      : VitalDelayType                     := 0 ps;
    tisd_SSRB_CLKB     : VitalDelayType                     := 0 ps;
    tisd_WEB_CLKB      : VitalDelayType                     := 0 ps;

    tpw_CLKA_negedge : VitalDelayType := 0 ps;
    tpw_CLKA_posedge : VitalDelayType := 0 ps;
    tpw_CLKB_negedge : VitalDelayType := 0 ps;
    tpw_CLKB_posedge : VitalDelayType := 0 ps;
    tpw_GSR_posedge  : VitalDelayType := 0 ps;

    INIT_00  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_01  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_02  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_03  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_04  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_05  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_06  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_07  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_08  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_09  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0A  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0B  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0C  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0D  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0E  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0F  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_10  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_11  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_12  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_13  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_14  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_15  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_16  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_17  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_18  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_19  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1A  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1B  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1C  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1D  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1E  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1F  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_20  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_21  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_22  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_23  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_24  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_25  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_26  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_27  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_28  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_29  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2A  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2B  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2C  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2D  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2E  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2F  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_30  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_31  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_32  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_33  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_34  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_35  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_36  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_37  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_38  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_39  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3A  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3B  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3C  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3D  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3E  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3F  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_A : bit_vector := X"0";
    INIT_B : bit_vector := X"0";

    SRVAL_A : bit_vector := X"0";
    SRVAL_B : bit_vector := X"0";

    SETUP_ALL        : VitalDelayType := 1000 ps;
    SETUP_READ_FIRST : VitalDelayType := 3000 ps;

    SIM_COLLISION_CHECK : string := "ALL";

    WRITE_MODE_A : string := "WRITE_FIRST";
    WRITE_MODE_B : string := "WRITE_FIRST"

    );

  port(
    DOA   : out std_logic_vector (3 downto 0);
    DOB   : out std_logic_vector (3 downto 0);

    ADDRA : in  std_logic_vector (11 downto 0);
    ADDRB : in  std_logic_vector (11 downto 0);
    CLKA  : in  std_ulogic;
    CLKB  : in  std_ulogic;
    DIA   : in  std_logic_vector (3 downto 0);
    DIB   : in  std_logic_vector (3 downto 0);
    ENA   : in  std_ulogic;
    ENB   : in  std_ulogic;
    SSRA  : in  std_ulogic;
    SSRB  : in  std_ulogic;
    WEA   : in  std_ulogic;
    WEB   : in  std_ulogic
    );

  attribute VITAL_LEVEL0 of
    X_RAMB16_S4_S4 : entity is true;
end x_ramb16_s4_s4;

architecture X_RAMB16_S4_S4_V of X_RAMB16_S4_S4 is

  attribute VITAL_LEVEL0 of
    X_RAMB16_S4_S4_V : architecture is true;

  signal ADDRA_ipd : std_logic_vector(11 downto 0)  := (others => 'X');
  signal CLKA_ipd  : std_ulogic                    := 'X';
  signal DIA_ipd   : std_logic_vector(3 downto 0) := (others => 'X');
  signal ENA_ipd   : std_ulogic                    := 'X';
  signal SSRA_ipd  : std_ulogic                    := 'X';
  signal WEA_ipd   : std_ulogic                    := 'X';

  signal ADDRB_ipd : std_logic_vector(11 downto 0)  := (others => 'X');
  signal CLKB_ipd  : std_ulogic                    := 'X';
  signal DIB_ipd   : std_logic_vector(3 downto 0) := (others => 'X');
  signal ENB_ipd   : std_ulogic                    := 'X';
  signal SSRB_ipd  : std_ulogic                    := 'X';
  signal WEB_ipd   : std_ulogic                    := 'X';

  signal GSR_ipd : std_ulogic := 'X';

  signal ADDRA_dly    : std_logic_vector(11 downto 0)  := (others => 'X');
  signal CLKA_dly     : std_ulogic                    := 'X';
  signal DIA_dly      : std_logic_vector(3 downto 0) := (others => 'X');
  signal ENA_dly      : std_ulogic                    := 'X';
  signal GSR_CLKA_dly : std_ulogic                    := 'X';
  signal SSRA_dly     : std_ulogic                    := 'X';
  signal WEA_dly      : std_ulogic                    := 'X';

  signal ADDRB_dly    : std_logic_vector(11 downto 0)  := (others => 'X');
  signal CLKB_dly     : std_ulogic                    := 'X';
  signal DIB_dly      : std_logic_vector(3 downto 0) := (others => 'X');
  signal ENB_dly      : std_ulogic                    := 'X';
  signal GSR_CLKB_dly : std_ulogic                    := 'X';
  signal SSRB_dly     : std_ulogic                    := 'X';
  signal WEB_dly      : std_ulogic                    := 'X';
  constant length_a : integer := 4096;
  constant length_b : integer := 4096;  
  constant width_a : integer := 4;
  constant width_b : integer := 4;  

  constant parity_width_a : integer := 0;
  constant parity_width_b : integer := 0;
  
  type Two_D_array_type is array ((length_b -  1) downto 0) of std_logic_vector((width_b - 1) downto 0);

  function slv_to_two_D_array(
    slv_length : integer;
    slv_width : integer;
    SLV : in std_logic_vector
    )
    return two_D_array_type is
    variable two_D_array : two_D_array_type;
    variable intermediate : std_logic_vector((slv_width - 1) downto 0);
  begin
    for i in 0 to (slv_length - 1)loop
      intermediate := SLV(((i*slv_width) + (slv_width - 1)) downto (i* slv_width));
      two_D_array(i) := intermediate; 
    end loop;
    return two_D_array;
  end;

begin
  WireDelay     : block
  begin
    ADDRA_DELAY : for i in 11 downto 0 generate
      VitalWireDelay (ADDRA_ipd(i), ADDRA(i), tipd_ADDRA(i));
    end generate ADDRA_DELAY;
    VitalWireDelay (CLKA_ipd, CLKA, tipd_CLKA);
    DIA_DELAY   : for i in 3 downto 0 generate
      VitalWireDelay (DIA_ipd(i), DIA(i), tipd_DIA(i));
    end generate DIA_DELAY;
    VitalWireDelay (ENA_ipd, ENA, tipd_ENA);
    VitalWireDelay (SSRA_ipd, SSRA, tipd_SSRA);
    VitalWireDelay (WEA_ipd, WEA, tipd_WEA);
    ADDRB_DELAY : for i in 11 downto 0 generate
      VitalWireDelay (ADDRB_ipd(i), ADDRB(i), tipd_ADDRB(i));
    end generate ADDRB_DELAY;
    VitalWireDelay (CLKB_ipd, CLKB, tipd_CLKB);
    DIB_DELAY   : for i in 3 downto 0 generate
      VitalWireDelay (DIB_ipd(i), DIB(i), tipd_DIB(i));
    end generate DIB_DELAY;
    VitalWireDelay (ENB_ipd, ENB, tipd_ENB);
    VitalWireDelay (SSRB_ipd, SSRB, tipd_SSRB);
    VitalWireDelay (WEB_ipd, WEB, tipd_WEB);
    VitalWireDelay (GSR_ipd, GSR, tipd_GSR);
  end block;

  SignalDelay   : block
  begin
    ADDRA_DELAY : for i in 11 downto 0 generate
      VitalSignalDelay (ADDRA_dly(i), ADDRA_ipd(i), tisd_ADDRA_CLKA(i));
    end generate ADDRA_DELAY;
    VitalSignalDelay (CLKA_dly, CLKA_ipd, ticd_CLKA);
    DIA_DELAY   : for i in 3 downto 0 generate
      VitalSignalDelay (DIA_dly(i), DIA_ipd(i), tisd_DIA_CLKA(i));
    end generate DIA_DELAY;
    VitalSignalDelay (ENA_dly, ENA_ipd, tisd_ENA_CLKA);
    VitalSignalDelay (GSR_CLKA_dly, GSR_ipd, tisd_GSR_CLKA);
    VitalSignalDelay (SSRA_dly, SSRA_ipd, tisd_SSRA_CLKA);
    VitalSignalDelay (WEA_dly, WEA_ipd, tisd_WEA_CLKA);

    ADDRB_DELAY : for i in 11 downto 0 generate
      VitalSignalDelay (ADDRB_dly(i), ADDRB_ipd(i), tisd_ADDRB_CLKB(i));
    end generate ADDRB_DELAY;
    VitalSignalDelay (CLKB_dly, CLKB_ipd, ticd_CLKB);
    DIB_DELAY   : for i in 3 downto 0 generate
      VitalSignalDelay (DIB_dly(i), DIB_ipd(i), tisd_DIB_CLKB(i));
    end generate DIB_DELAY;
    VitalSignalDelay (ENB_dly, ENB_ipd, tisd_ENB_CLKB);
    VitalSignalDelay (GSR_CLKB_dly, GSR_ipd, tisd_GSR_CLKB);
    VitalSignalDelay (SSRB_dly, SSRB_ipd, tisd_SSRB_CLKB);
    VitalSignalDelay (WEB_dly, WEB_ipd, tisd_WEB_CLKB);
  end block;

  VITALBehavior                        : process
    variable Tviol_ADDRA0_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA1_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA2_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA3_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA4_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA5_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA6_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA7_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA8_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA9_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA10_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA11_CLKA_posedge : std_ulogic := '0';
    variable Tviol_DIA0_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA1_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA2_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA3_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_ENA_CLKA_posedge    : std_ulogic := '0';
    variable Tviol_GSR_CLKA_posedge    : std_ulogic := '0';
    variable Tviol_SSRA_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_WEA_CLKA_posedge    : std_ulogic := '0';

    variable Tviol_ADDRB0_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB1_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB2_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB3_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB4_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB5_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB6_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB7_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB8_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB9_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB10_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB11_CLKB_posedge : std_ulogic := '0';
    variable Tviol_DIB0_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB1_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB2_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB3_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_ENB_CLKB_posedge    : std_ulogic := '0';
    variable Tviol_GSR_CLKB_posedge    : std_ulogic := '0';
    variable Tviol_SSRB_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_WEB_CLKB_posedge    : std_ulogic := '0';

    variable Tviol_CLKA_CLKB_all        : std_ulogic := '0';
    variable Tviol_CLKA_CLKB_read_first : std_ulogic := '0';
    variable Tviol_CLKB_CLKA_all        : std_ulogic := '0';
    variable Tviol_CLKB_CLKA_read_first : std_ulogic := '0';

    variable Tmkr_ADDRA0_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA1_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA2_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA3_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA4_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA5_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA6_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA7_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA8_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA9_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA10_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA11_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA0_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA1_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA2_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA3_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ENA_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_GSR_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_SSRA_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_WEA_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;

    variable Tmkr_ADDRB0_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB1_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB2_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB3_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB4_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB5_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB6_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB7_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB8_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB9_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB10_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB11_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB0_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB1_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB2_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB3_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ENB_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_GSR_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_SSRB_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_WEB_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;

    variable Tmkr_CLKA_CLKB_all        : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_CLKA_CLKB_read_first : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_CLKB_CLKA_all        : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_CLKB_CLKA_read_first : VitalTimingDataType := VitalTimingDataInit;

    variable PViol_GSR : std_ulogic          := '0';
    variable PInfo_GSR : VitalPeriodDataType := VitalPeriodDataInit;

    variable PViol_CLKA, PViol_CLKB : std_ulogic          := '0';
    variable PInfo_CLKA, PInfo_CLKB : VitalPeriodDataType := VitalPeriodDataInit;

    variable DOA_GlitchData0  : VitalGlitchDataType;
    variable DOA_GlitchData1  : VitalGlitchDataType;
    variable DOA_GlitchData2  : VitalGlitchDataType;
    variable DOA_GlitchData3  : VitalGlitchDataType;

    variable DOB_GlitchData0  : VitalGlitchDataType;
    variable DOB_GlitchData1  : VitalGlitchDataType;
    variable DOB_GlitchData2  : VitalGlitchDataType;
    variable DOB_GlitchData3  : VitalGlitchDataType;

    variable mem_slv : std_logic_vector(16383 downto 0) := To_StdLogicVector(INIT_3F) &
                                                       To_StdLogicVector(INIT_3E) &
                                                       To_StdLogicVector(INIT_3D) &
                                                       To_StdLogicVector(INIT_3C) &
                                                       To_StdLogicVector(INIT_3B) &
                                                       To_StdLogicVector(INIT_3A) &
                                                       To_StdLogicVector(INIT_39) &
                                                       To_StdLogicVector(INIT_38) &
                                                       To_StdLogicVector(INIT_37) &
                                                       To_StdLogicVector(INIT_36) &
                                                       To_StdLogicVector(INIT_35) &
                                                       To_StdLogicVector(INIT_34) &
                                                       To_StdLogicVector(INIT_33) &
                                                       To_StdLogicVector(INIT_32) &
                                                       To_StdLogicVector(INIT_31) &
                                                       To_StdLogicVector(INIT_30) &
                                                       To_StdLogicVector(INIT_2F) &
                                                       To_StdLogicVector(INIT_2E) &
                                                       To_StdLogicVector(INIT_2D) &
                                                       To_StdLogicVector(INIT_2C) &
                                                       To_StdLogicVector(INIT_2B) &
                                                       To_StdLogicVector(INIT_2A) &
                                                       To_StdLogicVector(INIT_29) &
                                                       To_StdLogicVector(INIT_28) &
                                                       To_StdLogicVector(INIT_27) &
                                                       To_StdLogicVector(INIT_26) &
                                                       To_StdLogicVector(INIT_25) &
                                                       To_StdLogicVector(INIT_24) &
                                                       To_StdLogicVector(INIT_23) &
                                                       To_StdLogicVector(INIT_22) &
                                                       To_StdLogicVector(INIT_21) &
                                                       To_StdLogicVector(INIT_20) &
                                                       To_StdLogicVector(INIT_1F) &
                                                       To_StdLogicVector(INIT_1E) &
                                                       To_StdLogicVector(INIT_1D) &
                                                       To_StdLogicVector(INIT_1C) &
                                                       To_StdLogicVector(INIT_1B) &
                                                       To_StdLogicVector(INIT_1A) &
                                                       To_StdLogicVector(INIT_19) &
                                                       To_StdLogicVector(INIT_18) &
                                                       To_StdLogicVector(INIT_17) &
                                                       To_StdLogicVector(INIT_16) &
                                                       To_StdLogicVector(INIT_15) &
                                                       To_StdLogicVector(INIT_14) &
                                                       To_StdLogicVector(INIT_13) &
                                                       To_StdLogicVector(INIT_12) &
                                                       To_StdLogicVector(INIT_11) &
                                                       To_StdLogicVector(INIT_10) &
                                                       To_StdLogicVector(INIT_0F) &
                                                       To_StdLogicVector(INIT_0E) &
                                                       To_StdLogicVector(INIT_0D) &
                                                       To_StdLogicVector(INIT_0C) &
                                                       To_StdLogicVector(INIT_0B) &
                                                       To_StdLogicVector(INIT_0A) &
                                                       To_StdLogicVector(INIT_09) &
                                                       To_StdLogicVector(INIT_08) &
                                                       To_StdLogicVector(INIT_07) &
                                                       To_StdLogicVector(INIT_06) &
                                                       To_StdLogicVector(INIT_05) &
                                                       To_StdLogicVector(INIT_04) &
                                                       To_StdLogicVector(INIT_03) &
                                                       To_StdLogicVector(INIT_02) &
                                                       To_StdLogicVector(INIT_01) &
                                                       To_StdLogicVector(INIT_00);
    variable mem : Two_D_array_type := slv_to_two_D_array(length_b, width_b, mem_slv);
    variable INIT_A_reg         : std_logic_vector (3 downto 0) := "0000";
    variable INIT_B_reg         : std_logic_vector (3 downto 0) := "0000";
    variable ADDRA_dly_sampled : std_logic_vector(11 downto 0)   := (others => 'X');
    variable ADDRB_dly_sampled : std_logic_vector(11 downto 0)   := (others => 'X');
    variable ADDRESS_A         : integer;
    variable ADDRESS_B         : integer;
    variable DOA_OV_LSB        : integer;
    variable DOA_OV_MSB        : integer;
    variable DOA_zd            : std_logic_vector(3 downto 0);
    variable DOB_OV_LSB        : integer;
    variable DOB_OV_MSB        : integer;
    variable DOB_zd            : std_logic_vector(3 downto 0);
    variable DOPA_OV_LSB       : integer;
    variable DOPA_OV_MSB       : integer;
    variable DOPB_OV_LSB       : integer;
    variable DOPB_OV_MSB       : integer;
    variable ENA_dly_sampled   : std_ulogic                      := 'X';
    variable ENB_dly_sampled   : std_ulogic                      := 'X';
    variable FIRST_TIME        : boolean                        := true;
    variable HAS_OVERLAP       : boolean                        := false;
    variable HAS_OVERLAP_P     : boolean                        := false;
    variable OLPP_LSB          : integer;
    variable OLPP_MSB          : integer;
    variable OLP_LSB           : integer;
    variable OLP_MSB           : integer;
    variable SRVAL_A_reg            : std_logic_vector (3 downto 0) := "0000";
    variable SRVAL_B_reg            : std_logic_vector (3 downto 0) := "0000";
    variable SSRA_dly_sampled  : std_ulogic                      := 'X';
    variable SSRB_dly_sampled  : std_ulogic                      := 'X';
    variable VALID_ADDRA       : boolean                        := false;
    variable VALID_ADDRB       : boolean                        := false;
    variable WR_A_LATER        : boolean                        := false;
    variable WR_B_LATER        : boolean                        := false;
    variable ViolationA        : std_ulogic                     := '0';
    variable ViolationB        : std_ulogic                     := '0';
    variable ViolationCLKAB    : std_ulogic                     := '0';
    variable ViolationCLKAB_S0 : boolean                        := false;
    variable Violation_S1      : boolean                        := false;
    variable Violation_S3      : boolean                        := false;
    variable WEA_dly_sampled   : std_ulogic                      := 'X';
    variable WEB_dly_sampled   : std_ulogic                      := 'X';
    variable wr_mode_a         : integer                        := 0;
    variable wr_mode_b         : integer                        := 0;
    variable collision_type : integer := 3;

  begin
    if (FIRST_TIME) then
      if ((SIM_COLLISION_CHECK = "none") or (SIM_COLLISION_CHECK = "NONE"))  then
        collision_type := 0;
      elsif ((SIM_COLLISION_CHECK = "warning_only") or (SIM_COLLISION_CHECK = "WARNING_ONLY"))  then
        collision_type := 1;
      elsif ((SIM_COLLISION_CHECK = "generate_x_only") or (SIM_COLLISION_CHECK = "GENERATE_X_ONLY"))  then
        collision_type := 2;
      elsif ((SIM_COLLISION_CHECK = "all") or (SIM_COLLISION_CHECK = "ALL"))  then        
        collision_type := 3;
      else
        GenericValueCheckMessage
          (HeaderMsg => "Attribute Syntax Error",
           GenericName => "SIM_COLLISION_CHECK",
           EntityName => "X_RAMB16_S4_S4",
           GenericValue => SIM_COLLISION_CHECK,
           Unit => "",
           ExpectedValueMsg => "Legal Values for this attribute are ALL, NONE, WARNING_ONLY or GENERATE_X_ONLY",
           ExpectedGenericValue => "",
           TailMsg => "",
           MsgSeverity => error
           );
      end if;
      if (INIT_A'length > 4) then
        INIT_A_reg(3 downto 0)        := To_StdLogicVector(INIT_A)(3 downto 0);
      else
        INIT_A_reg(INIT_A'length-1 downto 0)         := To_StdLogicVector(INIT_A);
      end if;
      DOA_zd(3 downto 0)                       := INIT_A_reg(3 downto 0);
      DOA  <= DOA_zd;

      if (INIT_B'length > 4) then
        INIT_B_reg(3 downto 0)        := To_StdLogicVector(INIT_B)(3 downto 0);
      else
        INIT_B_reg(INIT_B'length-1 downto 0)         := To_StdLogicVector(INIT_B);
      end if;
      DOB_zd(3 downto 0)                       := INIT_B_reg(3 downto 0);
      DOB  <= DOB_zd;

      if (SRVAL_A'length > 4) then
        SRVAL_A_reg(3 downto 0)        := To_StdLogicVector(SRVAL_A)(3 downto 0);
      else
        SRVAL_A_reg(SRVAL_A'length-1 downto 0)         := To_StdLogicVector(SRVAL_A);
      end if;
      if (SRVAL_B'length > 4) then
        SRVAL_B_reg(3 downto 0)        := To_StdLogicVector(SRVAL_B)(3 downto 0);
      else
        SRVAL_B_reg(SRVAL_B'length-1 downto 0)         := To_StdLogicVector(SRVAL_B);
      end if;
      if ((WRITE_MODE_A = "write_first") or (WRITE_MODE_A = "WRITE_FIRST")) then
        wr_mode_a := 0;
      elsif ((WRITE_MODE_A = "read_first") or (WRITE_MODE_A = "READ_FIRST")) then
        wr_mode_a := 1;
      elsif ((WRITE_MODE_A = "no_change") or (WRITE_MODE_A = "NO_CHANGE")) then
        wr_mode_a := 2;
      else
        GenericValueCheckMessage
          ( HeaderMsg            => " Attribute Syntax Error ",
            GenericName          => " WRITE_MODE_A ",
            EntityName           => "/X_RAMB16_S4_S4",
            GenericValue         => WRITE_MODE_A,
            Unit                 => "",
            ExpectedValueMsg     => " The Legal values for this attribute are ",
            ExpectedGenericValue => " WRITE_FIRST, READ_FIRST or NO_CHANGE ",
            TailMsg              => "",
            MsgSeverity          => error
            );
      end if;

      if ((WRITE_MODE_B = "write_first") or (WRITE_MODE_B = "WRITE_FIRST")) then
        wr_mode_b := 0;
      elsif ((WRITE_MODE_B = "read_first") or (WRITE_MODE_B = "READ_FIRST")) then
        wr_mode_b := 1;
      elsif ((WRITE_MODE_B = "no_change") or (WRITE_MODE_B = "NO_CHANGE")) then
        wr_mode_b := 2;
      else
        GenericValueCheckMessage
          ( HeaderMsg            => " Attribute Syntax Error ",
            GenericName          => " WRITE_MODE_B ",
            EntityName           => "/X_RAMB16_S4_S4",
            GenericValue         => WRITE_MODE_B,
            Unit                 => "",
            ExpectedValueMsg     => " The Legal values for this attribute are ",
            ExpectedGenericValue => " WRITE_FIRST, READ_FIRST or NO_CHANGE ",
            TailMsg              => "",
            MsgSeverity          => error
            );
      end if;
      FIRST_TIME  := false;
    end if;

    if (CLKA_dly'event) then
      ENA_dly_sampled   := ENA_dly;
      SSRA_dly_sampled  := SSRA_dly;
      WEA_dly_sampled   := WEA_dly;
      ADDRA_dly_sampled := ADDRA_dly;
    end if;

    if (CLKB_dly'event) then
      ENB_dly_sampled   := ENB_dly;
      SSRB_dly_sampled  := SSRB_dly;
      WEB_dly_sampled   := WEB_dly;
      ADDRB_dly_sampled := ADDRB_dly;
    end if;
    if (TimingChecksOn) then
      VitalRecoveryRemovalCheck (
        Violation      => Tviol_GSR_CLKA_posedge,
        TimingData     => Tmkr_GSR_CLKA_posedge,
        TestSignal     => GSR_CLKA_dly,
        TestSignalName => "GSR",
        TestDelay      => tisd_GSR_CLKA,
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        Recovery       => trecovery_GSR_CLKA_negedge_posedge,
        Removal        => thold_GSR_CLKA_negedge_posedge,
        ActiveLow      => false,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ENA_CLKA_posedge,
        TimingData     => Tmkr_ENA_CLKA_posedge,
        TestSignal     => ENA_dly,
        TestSignalName => "ENA",
        TestDelay      => tisd_ENA_CLKA,
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ENA_CLKA_posedge_posedge,
        SetupLow       => tsetup_ENA_CLKA_negedge_posedge,
        HoldLow        => thold_ENA_CLKA_negedge_posedge,
        HoldHigh       => thold_ENA_CLKA_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_SSRA_CLKA_posedge,
        TimingData     => Tmkr_SSRA_CLKA_posedge,
        TestSignal     => SSRA_dly,
        TestSignalName => "SSRA",
        TestDelay      => tisd_SSRA_CLKA,
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_SSRA_CLKA_posedge_posedge,
        SetupLow       => tsetup_SSRA_CLKA_negedge_posedge,
        HoldLow        => thold_SSRA_CLKA_negedge_posedge,
        HoldHigh       => thold_SSRA_CLKA_posedge_posedge,
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_WEA_CLKA_posedge,
        TimingData     => Tmkr_WEA_CLKA_posedge,
        TestSignal     => WEA_dly,
        TestSignalName => "WEA",
        TestDelay      => tisd_WEA_CLKA,
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_WEA_CLKA_posedge_posedge,
        SetupLow       => tsetup_WEA_CLKA_negedge_posedge,
        HoldLow        => thold_WEA_CLKA_negedge_posedge,
        HoldHigh       => thold_WEA_CLKA_posedge_posedge,
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA0_CLKA_posedge,
        TimingData     => Tmkr_ADDRA0_CLKA_posedge,
        TestSignal     => ADDRA_dly(0),
        TestSignalName => "ADDRA(0)",
        TestDelay      => tisd_ADDRA_CLKA(0),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(0),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(0),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(0),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(0),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA1_CLKA_posedge,
        TimingData     => Tmkr_ADDRA1_CLKA_posedge,
        TestSignal     => ADDRA_dly(1),
        TestSignalName => "ADDRA(1)",
        TestDelay      => tisd_ADDRA_CLKA(1),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(1),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(1),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(1),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(1),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA2_CLKA_posedge,
        TimingData     => Tmkr_ADDRA2_CLKA_posedge,
        TestSignal     => ADDRA_dly(2),
        TestSignalName => "ADDRA(2)",
        TestDelay      => tisd_ADDRA_CLKA(2),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(2),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(2),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(2),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(2),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA3_CLKA_posedge,
        TimingData     => Tmkr_ADDRA3_CLKA_posedge,
        TestSignal     => ADDRA_dly(3),
        TestSignalName => "ADDRA(3)",
        TestDelay      => tisd_ADDRA_CLKA(3),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(3),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(3),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(3),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(3),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA4_CLKA_posedge,
        TimingData     => Tmkr_ADDRA4_CLKA_posedge,
        TestSignal     => ADDRA_dly(4),
        TestSignalName => "ADDRA(4)",
        TestDelay      => tisd_ADDRA_CLKA(4),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(4),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(4),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(4),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(4),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA5_CLKA_posedge,
        TimingData     => Tmkr_ADDRA5_CLKA_posedge,
        TestSignal     => ADDRA_dly(5),
        TestSignalName => "ADDRA(5)",
        TestDelay      => tisd_ADDRA_CLKA(5),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(5),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(5),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(5),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(5),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA6_CLKA_posedge,
        TimingData     => Tmkr_ADDRA6_CLKA_posedge,
        TestSignal     => ADDRA_dly(6),
        TestSignalName => "ADDRA(6)",
        TestDelay      => tisd_ADDRA_CLKA(6),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(6),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(6),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(6),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(6),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA7_CLKA_posedge,
        TimingData     => Tmkr_ADDRA7_CLKA_posedge,
        TestSignal     => ADDRA_dly(7),
        TestSignalName => "ADDRA(7)",
        TestDelay      => tisd_ADDRA_CLKA(7),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(7),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(7),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(7),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(7),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA8_CLKA_posedge,
        TimingData     => Tmkr_ADDRA8_CLKA_posedge,
        TestSignal     => ADDRA_dly(8),
        TestSignalName => "ADDRA(8)",
        TestDelay      => tisd_ADDRA_CLKA(8),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(8),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(8),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(8),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(8),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA9_CLKA_posedge,
        TimingData     => Tmkr_ADDRA9_CLKA_posedge,
        TestSignal     => ADDRA_dly(9),
        TestSignalName => "ADDRA(9)",
        TestDelay      => tisd_ADDRA_CLKA(9),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(9),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(9),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(9),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(9),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA10_CLKA_posedge,
        TimingData     => Tmkr_ADDRA10_CLKA_posedge,
        TestSignal     => ADDRA_dly(10),
        TestSignalName => "ADDRA(10)",
        TestDelay      => tisd_ADDRA_CLKA(10),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(10),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(10),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(10),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(10),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA11_CLKA_posedge,
        TimingData     => Tmkr_ADDRA11_CLKA_posedge,
        TestSignal     => ADDRA_dly(11),
        TestSignalName => "ADDRA(11)",
        TestDelay      => tisd_ADDRA_CLKA(11),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(11),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(11),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(11),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(11),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA0_CLKA_posedge,
        TimingData     => Tmkr_DIA0_CLKA_posedge,
        TestSignal     => DIA_dly(0),
        TestSignalName => "DIA(0)",
        TestDelay      => tisd_DIA_CLKA(0),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(0),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(0),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(0),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(0),
        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA1_CLKA_posedge,
        TimingData     => Tmkr_DIA1_CLKA_posedge,
        TestSignal     => DIA_dly(1),
        TestSignalName => "DIA(1)",
        TestDelay      => tisd_DIA_CLKA(1),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(1),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(1),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(1),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(1),
        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA2_CLKA_posedge,
        TimingData     => Tmkr_DIA2_CLKA_posedge,
        TestSignal     => DIA_dly(2),
        TestSignalName => "DIA(2)",
        TestDelay      => tisd_DIA_CLKA(2),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(2),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(2),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(2),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(2),
        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA3_CLKA_posedge,
        TimingData     => Tmkr_DIA3_CLKA_posedge,
        TestSignal     => DIA_dly(3),
        TestSignalName => "DIA(3)",
        TestDelay      => tisd_DIA_CLKA(3),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(3),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(3),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(3),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(3),
        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalRecoveryRemovalCheck (
        Violation      => Tviol_GSR_CLKB_posedge,
        TimingData     => Tmkr_GSR_CLKB_posedge,
        TestSignal     => GSR_CLKB_dly,
        TestSignalName => "GSR",
        TestDelay      => tisd_GSR_CLKB,
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        Recovery       => trecovery_GSR_CLKB_negedge_posedge,
        Removal        => thold_GSR_CLKB_negedge_posedge,
        ActiveLow      => false,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ENB_CLKB_posedge,
        TimingData     => Tmkr_ENB_CLKB_posedge,
        TestSignal     => ENB_dly,
        TestSignalName => "ENB",
        TestDelay      => tisd_ENB_CLKB,
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ENB_CLKB_posedge_posedge,
        SetupLow       => tsetup_ENB_CLKB_negedge_posedge,
        HoldLow        => thold_ENB_CLKB_negedge_posedge,
        HoldHigh       => thold_ENB_CLKB_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_SSRB_CLKB_posedge,
        TimingData     => Tmkr_SSRB_CLKB_posedge,
        TestSignal     => SSRB_dly,
        TestSignalName => "SSRB",
        TestDelay      => tisd_SSRB_CLKB,
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_SSRB_CLKB_posedge_posedge,
        SetupLow       => tsetup_SSRB_CLKB_negedge_posedge,
        HoldLow        => thold_SSRB_CLKB_negedge_posedge,
        HoldHigh       => thold_SSRB_CLKB_posedge_posedge,
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_WEB_CLKB_posedge,
        TimingData     => Tmkr_WEB_CLKB_posedge,
        TestSignal     => WEB_dly,
        TestSignalName => "WEB",
        TestDelay      => tisd_WEB_CLKB,
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_WEB_CLKB_posedge_posedge,
        SetupLow       => tsetup_WEB_CLKB_negedge_posedge,
        HoldLow        => thold_WEB_CLKB_negedge_posedge,
        HoldHigh       => thold_WEB_CLKB_posedge_posedge,
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB0_CLKB_posedge,
        TimingData     => Tmkr_ADDRB0_CLKB_posedge,
        TestSignal     => ADDRB_dly(0),
        TestSignalName => "ADDRB(0)",
        TestDelay      => tisd_ADDRB_CLKB(0),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(0),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(0),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(0),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(0),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB1_CLKB_posedge,
        TimingData     => Tmkr_ADDRB1_CLKB_posedge,
        TestSignal     => ADDRB_dly(1),
        TestSignalName => "ADDRB(1)",
        TestDelay      => tisd_ADDRB_CLKB(1),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(1),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(1),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(1),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(1),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB2_CLKB_posedge,
        TimingData     => Tmkr_ADDRB2_CLKB_posedge,
        TestSignal     => ADDRB_dly(2),
        TestSignalName => "ADDRB(2)",
        TestDelay      => tisd_ADDRB_CLKB(2),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(2),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(2),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(2),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(2),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB3_CLKB_posedge,
        TimingData     => Tmkr_ADDRB3_CLKB_posedge,
        TestSignal     => ADDRB_dly(3),
        TestSignalName => "ADDRB(3)",
        TestDelay      => tisd_ADDRB_CLKB(3),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(3),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(3),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(3),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(3),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB4_CLKB_posedge,
        TimingData     => Tmkr_ADDRB4_CLKB_posedge,
        TestSignal     => ADDRB_dly(4),
        TestSignalName => "ADDRB(4)",
        TestDelay      => tisd_ADDRB_CLKB(4),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(4),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(4),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(4),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(4),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB5_CLKB_posedge,
        TimingData     => Tmkr_ADDRB5_CLKB_posedge,
        TestSignal     => ADDRB_dly(5),
        TestSignalName => "ADDRB(5)",
        TestDelay      => tisd_ADDRB_CLKB(5),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(5),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(5),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(5),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(5),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB6_CLKB_posedge,
        TimingData     => Tmkr_ADDRB6_CLKB_posedge,
        TestSignal     => ADDRB_dly(6),
        TestSignalName => "ADDRB(6)",
        TestDelay      => tisd_ADDRB_CLKB(6),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(6),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(6),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(6),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(6),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB7_CLKB_posedge,
        TimingData     => Tmkr_ADDRB7_CLKB_posedge,
        TestSignal     => ADDRB_dly(7),
        TestSignalName => "ADDRB(7)",
        TestDelay      => tisd_ADDRB_CLKB(7),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(7),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(7),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(7),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(7),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB8_CLKB_posedge,
        TimingData     => Tmkr_ADDRB8_CLKB_posedge,
        TestSignal     => ADDRB_dly(8),
        TestSignalName => "ADDRB(8)",
        TestDelay      => tisd_ADDRB_CLKB(8),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(8),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(8),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(8),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(8),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB9_CLKB_posedge,
        TimingData     => Tmkr_ADDRB9_CLKB_posedge,
        TestSignal     => ADDRB_dly(9),
        TestSignalName => "ADDRB(9)",
        TestDelay      => tisd_ADDRB_CLKB(9),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(9),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(9),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(9),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(9),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB10_CLKB_posedge,
        TimingData     => Tmkr_ADDRB10_CLKB_posedge,
        TestSignal     => ADDRB_dly(10),
        TestSignalName => "ADDRB(10)",
        TestDelay      => tisd_ADDRB_CLKB(10),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(10),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(10),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(10),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(10),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB11_CLKB_posedge,
        TimingData     => Tmkr_ADDRB11_CLKB_posedge,
        TestSignal     => ADDRB_dly(11),
        TestSignalName => "ADDRB(11)",
        TestDelay      => tisd_ADDRB_CLKB(11),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(11),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(11),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(11),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(11),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB0_CLKB_posedge,
        TimingData     => Tmkr_DIB0_CLKB_posedge,
        TestSignal     => DIB_dly(0),
        TestSignalName => "DIB(0)",
        TestDelay      => tisd_DIB_CLKB(0),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(0),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(0),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(0),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(0),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB1_CLKB_posedge,
        TimingData     => Tmkr_DIB1_CLKB_posedge,
        TestSignal     => DIB_dly(1),
        TestSignalName => "DIB(1)",
        TestDelay      => tisd_DIB_CLKB(1),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(1),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(1),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(1),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(1),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB2_CLKB_posedge,
        TimingData     => Tmkr_DIB2_CLKB_posedge,
        TestSignal     => DIB_dly(2),
        TestSignalName => "DIB(2)",
        TestDelay      => tisd_DIB_CLKB(2),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(2),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(2),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(2),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(2),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB3_CLKB_posedge,
        TimingData     => Tmkr_DIB3_CLKB_posedge,
        TestSignal     => DIB_dly(3),
        TestSignalName => "DIB(3)",
        TestDelay      => tisd_DIB_CLKB(3),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(3),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(3),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(3),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(3),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalPeriodPulseCheck (
        Violation      => Pviol_CLKA,
        PeriodData     => PInfo_CLKA,
        TestSignal     => CLKA_dly,
        TestSignalName => "CLKA",
        TestDelay      => 0 ps,
        Period         => 0 ps,
        PulseWidthHigh => tpw_CLKA_posedge,
        PulseWidthLow  => tpw_CLKA_negedge,
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalPeriodPulseCheck (
        Violation      => Pviol_CLKB,
        PeriodData     => PInfo_CLKB,
        TestSignal     => CLKB_dly,
        TestSignalName => "CLKB",
        TestDelay      => 0 ps,
        Period         => 0 ps,
        PulseWidthHigh => tpw_CLKB_posedge,
        PulseWidthLow  => tpw_CLKB_negedge,
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalPeriodPulseCheck (
        Violation      => Pviol_GSR,
        PeriodData     => PInfo_GSR,
        TestSignal     => GSR_ipd,
        TestSignalName => "GSR",
        TestDelay      => 0 ps,
        Period         => 0 ps,
        PulseWidthHigh => tpw_GSR_posedge,
        PulseWidthLow  => 0 ps,
        CheckEnabled   => true,
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
    end if;
    ViolationA          :=
      Tviol_ADDRA0_CLKA_posedge or
      Tviol_ADDRA1_CLKA_posedge or
      Tviol_ADDRA2_CLKA_posedge or
      Tviol_ADDRA3_CLKA_posedge or
      Tviol_ADDRA4_CLKA_posedge or
      Tviol_ADDRA5_CLKA_posedge or
      Tviol_ADDRA6_CLKA_posedge or
      Tviol_ADDRA7_CLKA_posedge or
      Tviol_ADDRA8_CLKA_posedge or
      Tviol_ADDRA9_CLKA_posedge or
      Tviol_ADDRA10_CLKA_posedge or
      Tviol_ADDRA11_CLKA_posedge or
      Tviol_DIA0_CLKA_posedge or
      Tviol_DIA1_CLKA_posedge or
      Tviol_DIA2_CLKA_posedge or
      Tviol_DIA3_CLKA_posedge or
      Tviol_ENA_CLKA_posedge or
      Tviol_SSRA_CLKA_posedge or
      Tviol_WEA_CLKA_posedge or
      Pviol_CLKA ;
    ViolationB          :=
      Tviol_ADDRB0_CLKB_posedge or
      Tviol_ADDRB1_CLKB_posedge or
      Tviol_ADDRB2_CLKB_posedge or
      Tviol_ADDRB3_CLKB_posedge or
      Tviol_ADDRB4_CLKB_posedge or
      Tviol_ADDRB5_CLKB_posedge or
      Tviol_ADDRB6_CLKB_posedge or
      Tviol_ADDRB7_CLKB_posedge or
      Tviol_ADDRB8_CLKB_posedge or
      Tviol_ADDRB9_CLKB_posedge or
      Tviol_ADDRB10_CLKB_posedge or
      Tviol_ADDRB11_CLKB_posedge or
      Tviol_DIB0_CLKB_posedge or
      Tviol_DIB1_CLKB_posedge or
      Tviol_DIB2_CLKB_posedge or
      Tviol_DIB3_CLKB_posedge or
      Tviol_ENB_CLKB_posedge or
      Tviol_SSRB_CLKB_posedge or
      Tviol_WEB_CLKB_posedge or
      Pviol_CLKB ;

    VALID_ADDRA           := ADDR_IS_VALID(addra_dly_sampled);
    if (VALID_ADDRA) then
      ADDRESS_A           := SLV_TO_INT(addra_dly_sampled);
    end if;
    VALID_ADDRB           := ADDR_IS_VALID(addrb_dly_sampled);
    if (VALID_ADDRB) then
      ADDRESS_B           := SLV_TO_INT(addrb_dly_sampled);
    end if;
    if (VALID_ADDRA and VALID_ADDRB) then
      ADDR_OVERLAP (ADDRESS_A, ADDRESS_B, WIDTH_A, WIDTH_B, HAS_OVERLAP, OLP_LSB, OLP_MSB, DOA_OV_LSB, DOA_OV_MSB, DOB_OV_LSB, DOB_OV_MSB);
    end if;
    ViolationCLKAB        := '0';
    ViolationCLKAB_S0     := false;
    Violation_S1          := false;
    Violation_S3          := false;
    if ((collision_type = 1) or (collision_type = 2) or (collision_type = 3)) then    
      VitalRecoveryRemovalCheck (
        Violation      => Tviol_CLKB_CLKA_all,
        TimingData     => Tmkr_CLKB_CLKA_all,
        TestSignal     => CLKB_dly,
        TestSignalName => "CLKB",
        TestDelay      => 0 ps,
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => 0 ps,
        Recovery       => SETUP_ALL,
        Removal       => 1 ps,
        ActiveLow      => true,
        CheckEnabled   => (HAS_OVERLAP = true and ena_dly_sampled = '1' and enb_dly_sampled = '1' and ((web_dly_sampled = '1' and wr_mode_b /= 1) or (wea_dly_sampled = '1' and wr_mode_a /= 1 and web_dly_sampled = '0'))),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => true,
        MsgOn          => false,
        MsgSeverity    => warning);

      VitalRecoveryRemovalCheck (
        Violation      => Tviol_CLKA_CLKB_all,
        TimingData     => Tmkr_CLKA_CLKB_all,
        TestSignal     => CLKA_dly,
        TestSignalName => "CLKA",
        TestDelay      => 0 ps,
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => 0 ps,
        Recovery       => SETUP_ALL,
        Removal       => 1 ps,
        ActiveLow      => true,
        CheckEnabled   => (HAS_OVERLAP = true and ena_dly_sampled = '1' and enb_dly_sampled = '1' and ((wea_dly_sampled = '1' and wr_mode_a /= 1) or (web_dly_sampled = '1' and wea_dly_sampled = '0' and wr_mode_b /= 1))),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => true,
        MsgOn          => false,
        MsgSeverity    => warning);

      VitalRecoveryRemovalCheck (
        Violation      => Tviol_CLKB_CLKA_read_first,
        TimingData     => Tmkr_CLKB_CLKA_read_first,
        TestSignal     => CLKB_dly,
        TestSignalName => "CLKB",
        TestDelay      => 0 ps,
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => 0 ps,
        Recovery       => SETUP_READ_FIRST,
        Removal       => 1 ps,
        ActiveLow      => true,
        CheckEnabled   => (HAS_OVERLAP = true and ena_dly_sampled = '1' and enb_dly_sampled = '1' and web_dly_sampled = '1' and wr_mode_b = 1 and (CLKA_dly'last_event /= CLKB_dly'last_event)),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => true,
        MsgOn          => false,
        MsgSeverity    => warning);

      VitalRecoveryRemovalCheck (
        Violation      => Tviol_CLKA_CLKB_read_first,
        TimingData     => Tmkr_CLKA_CLKB_read_first,
        TestSignal     => CLKA_dly,
        TestSignalName => "CLKA",
        TestDelay      => 0 ps,
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => 0 ps,
        Recovery       => SETUP_READ_FIRST,
        Removal       => 1 ps,
        ActiveLow      => true,
        CheckEnabled   => (HAS_OVERLAP = true and ena_dly_sampled = '1' and enb_dly_sampled = '1' and wea_dly_sampled = '1' and wr_mode_a = 1 and (CLKA_dly'last_event /= CLKB_dly'last_event)),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S4",
        Xon            => true,
        MsgOn          => false,
        MsgSeverity    => warning);        
    end if;
    ViolationCLKAB := Tviol_CLKB_CLKA_all or Tviol_CLKA_CLKB_all or Tviol_CLKB_CLKA_read_first or Tviol_CLKA_CLKB_read_first;        



    WR_A_LATER := false;
    WR_B_LATER := false;

    if (GSR_CLKA_dly = '1') then
      DOA_zd  := INIT_A_reg ( 3 downto 0);

    elsif (GSR_CLKA_dly = '0') then
      if (ena_dly_sampled = '1') then
        if (rising_edge(CLKA_dly)) then
          if (wea_dly_sampled = '1') then
            case wr_mode_a is
              when 0 =>
                DOA_zd  := DIA_dly;

                if (ViolationCLKAB = 'X') then
                  if (web_dly_sampled /= '0') then
                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Write_A_Write_B,
                         EntityName => "/X_RAMB16_S4_S4",
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      MEM(ADDRESS_A/(length_a/length_b))(DOB_OV_MSB downto DOB_OV_LSB) := (others => 'X');
                      DOA_zd := (others => 'X');
                      if (wr_mode_b /= 2 ) then
                        DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)    := (others => 'X');
                      end if;
                    end if;
                  else

                    if ((collision_type = 1) or (collision_type = 3)) then                
                      Memory_Collision_Msg
                        (collision_type => Read_B_Write_A,
                         EntityName => "/X_RAMB16_S4_S4",
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a))):= DIA_dly;
                    if ((collision_type = 2) or (collision_type = 3)) then                
                      DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)                      := (others => 'X');
                    end if;
                  end if;
                else

                  if (VALID_ADDRA) then
                    MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a))):= DIA_dly;
                  end if;
                end if;
              when 1 =>

                if (VALID_ADDRA) then
                  DOA_zd  := MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a)));
                  WR_A_LATER := true;
                end if;

                if (ViolationCLKAB = 'X') then

                  if (web_dly_sampled /= '0') then
                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Write_A_Write_B,
                         EntityName => "/X_RAMB16_S4_S4",
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      MEM(ADDRESS_A/(length_a/length_b))(DOB_OV_MSB downto DOB_OV_LSB) := (others => 'X');
                      DOA_zd := (others => 'X');
                      if (wr_mode_b /= 2 ) then
                        DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)    := (others => 'X');
                      end if;
                    end if;
                  else

                    if ((collision_type = 1) or (collision_type = 3)) then                
                      Memory_Collision_Msg
                        (collision_type => Read_B_Write_A,
                         EntityName => "/X_RAMB16_S4_S4",
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a))):= DIA_dly;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)                      := (others => 'X');
                    end if;
                  end if;
                end if;
              when 2 =>
                if (ViolationCLKAB = 'X') then

                  if (web_dly_sampled /= '0') then
                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Write_A_Write_B,
                         EntityName => "/X_RAMB16_S4_S4",
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      MEM(ADDRESS_A/(length_a/length_b))(DOB_OV_MSB downto DOB_OV_LSB) := (others => 'X');
                      if (wr_mode_b /= 2 ) then

                        DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)    := (others => 'X');
                      end if;
                    end if;
                  else

                    if ((collision_type = 1) or (collision_type = 3)) then                
                      Memory_Collision_Msg
                        (collision_type => Read_B_Write_A,
                         EntityName => "/X_RAMB16_S4_S4",
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then                
                      DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)                      := (others => 'X');
                    end if;
                    MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a))):= DIA_dly;
                  end if;
                else

                  if (VALID_ADDRA) then
                    MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a))):= DIA_dly;
                  end if;
                end if;
              when others => null;
            end case;
          else

            if (VALID_ADDRA) then
                  DOA_zd  := MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a)));
            end if;
            if (ViolationCLKAB = 'X') then

              if ((collision_type = 1) or (collision_type = 3)) then                
                Memory_Collision_Msg
                  (collision_type => Read_A_Write_B,
                   EntityName => "/X_RAMB16_S4_S4",
                   address_a => addra_dly_sampled,
                   address_b => addrb_dly_sampled
                   );
              end if;
              if ((collision_type = 2) or (collision_type = 3)) then                
                DOA_zd := (others => 'X');
              end if;
            end if;
          end if;
          if (ssra_dly_sampled = '1') then

            DOA_zd  := SRVAL_A_reg(3 downto 0);
          end if;
        end if;
      end if;
    end if;

    if (GSR_CLKB_dly = '1') then

      DOB_zd  := INIT_B_reg(3 downto 0);
    elsif (GSR_CLKB_dly = '0') then
      if (enb_dly_sampled = '1') then
        if (rising_edge(CLKB_dly)) then
          if (web_dly_sampled = '1') then
            case wr_mode_b is
              when 0 =>

                DOB_zd  := DIB_dly;
                if (VALID_ADDRB) then
                  MEM(ADDRESS_B)     := DIB_dly;
                end if;
                if (ViolationCLKAB = 'X') then
                  if (wea_dly_sampled /= '0') then

                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Write_A_Write_B,
                         EntityName => "X_RAMB16_S4_S4",
                         InstanceName => x_ramb16_s4_s4'path_name,
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      MEM(ADDRESS_B)(DOB_OV_MSB downto DOB_OV_LSB) := (others => 'X');

                      DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)    := (others => 'X');
                      if (wr_mode_a /= 2 ) then

                        DOA_zd := (others => 'X');
                      end if;
                    end if;
                  else
                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Read_A_Write_B,
                         EntityName => "X_RAMB16_S4_S4",
                         InstanceName => x_ramb16_s4_s4'path_name,
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      DOA_zd := (others => 'X');
                    end if;
                  end if;
                end if;
              when 1 =>

                if (VALID_ADDRB) then
                  DOB_zd  := MEM(ADDRESS_B);
                  WR_B_LATER := true;
                  MEM(ADDRESS_B)     := DIB_dly ;
                end if;
                if (ViolationCLKAB = 'X') then
                  if (wea_dly_sampled /= '0') then

                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Write_A_Write_B,
                         EntityName => "X_RAMB16_S4_S4",
                         InstanceName => x_ramb16_s4_s4'path_name,
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      MEM(ADDRESS_B)(DOB_OV_MSB downto DOB_OV_LSB) := (others => 'X');

                      DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)    := (others => 'X');
                      if (wr_mode_a /= 2 ) then
                        DOA_zd := (others => 'X');
                      end if;
                    end if;
                  else

                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Read_A_Write_B,
                         EntityName => "X_RAMB16_S4_S4",
                         InstanceName => x_ramb16_s4_s4'path_name,
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      DOA_zd := (others => 'X');
                    end if;
                  end if;
                end if;
              when 2 =>
                if (VALID_ADDRB) then
                  MEM(ADDRESS_B) := DIB_dly;
                end if;
                if (ViolationCLKAB = 'X') then
                  if (wea_dly_sampled /= '0') then

                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Write_A_Write_B,
                         EntityName => "X_RAMB16_S4_S4",
                         InstanceName => x_ramb16_s4_s4'path_name,
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      MEM(ADDRESS_B)(DOB_OV_MSB downto DOB_OV_LSB) := (others => 'X');
                      if (wr_mode_a /= 2 ) then

                        DOA_zd := (others => 'X');
                      end if;
                    end if;
                  else

                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Read_A_Write_B,
                         EntityName => "X_RAMB16_S4_S4",
                         InstanceName => x_ramb16_s4_s4'path_name,
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      DOA_zd := (others => 'X');
                    end if;
                  end if;
                end if;
              when others => null;
            end case;
          else

            if (VALID_ADDRB) then
              DOB_zd  := MEM(ADDRESS_B);
            end if;
            if (ViolationCLKAB = 'X') then

              if ((collision_type = 1) or (collision_type = 3)) then                
                Memory_Collision_Msg
                  (collision_type => Read_B_Write_A,
                   EntityName => "X_RAMB16_S4_S4",
                   InstanceName => x_ramb16_s4_s4'path_name,
                   address_a => addra_dly_sampled,
                   address_b => addrb_dly_sampled
                   );
              end if;
              if ((collision_type = 2) or (collision_type = 3)) then                
                DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)    := (others => 'X');
              end if;
            end if;
          end if;
          if (ssrb_dly_sampled = '1') then

            DOB_zd  := SRVAL_B_reg(3 downto 0);
          end if;
        end if;
      end if;
    end if;

    if ((WR_A_LATER = true ) and (VALID_ADDRA)) then
      MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a))):= DIA_dly;                    
    end if;

    if ((WR_B_LATER = true ) and (VALID_ADDRB)) then
        MEM(ADDRESS_B) := DIB_dly;
    end if;

    DOA_zd(0)  := ViolationA xor DOA_zd(0);
    DOA_zd(1)  := ViolationA xor DOA_zd(1);
    DOA_zd(2)  := ViolationA xor DOA_zd(2);
    DOA_zd(3)  := ViolationA xor DOA_zd(3);
    DOB_zd(0)  := ViolationB xor DOB_zd(0);
    DOB_zd(1)  := ViolationB xor DOB_zd(1);
    DOB_zd(2)  := ViolationB xor DOB_zd(2);
    DOB_zd(3)  := ViolationB xor DOB_zd(3);

    VitalPathDelay01 (
      OutSignal     => DOA(0),
      GlitchData    => DOA_GlitchData0,
      OutSignalName => "DOA(0)",
      OutTemp       => DOA_zd(0),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(0), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(0), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(1),
      GlitchData    => DOA_GlitchData1,
      OutSignalName => "DOA(1)",
      OutTemp       => DOA_zd(1),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(1), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(1), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(2),
      GlitchData    => DOA_GlitchData2,
      OutSignalName => "DOA(2)",
      OutTemp       => DOA_zd(2),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(2), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(2), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(3),
      GlitchData    => DOA_GlitchData3,
      OutSignalName => "DOA(3)",
      OutTemp       => DOA_zd(3),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(3), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(3), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(0),
      GlitchData    => DOB_GlitchData0,
      OutSignalName => "DOB(0)",
      OutTemp       => DOB_zd(0),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(0), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(0), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(1),
      GlitchData    => DOB_GlitchData1,
      OutSignalName => "DOB(1)",
      OutTemp       => DOB_zd(1),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(1), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(1), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(2),
      GlitchData    => DOB_GlitchData2,
      OutSignalName => "DOB(2)",
      OutTemp       => DOB_zd(2),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(2), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(2), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(3),
      GlitchData    => DOB_GlitchData3,
      OutSignalName => "DOB(3)",
      OutTemp       => DOB_zd(3),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(3), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(3), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    wait on ADDRA_dly, ADDRB_dly, CLKA_dly, CLKB_dly, DIA_dly, DIB_dly, ENA_dly, ENB_dly, GSR_ipd, GSR_CLKA_dly, GSR_CLKB_dly, SSRA_dly, SSRB_dly, WEA_dly, WEB_dly;
  end process VITALBehavior;
end X_RAMB16_S4_S4_V;
-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  16K-Bit Data and 2K-Bit Parity Dual Port Block RAM
-- /___/   /\     Filename : X_RAMB16_S4_S9.vhd
-- \   \  /  \    Timestamp : Thu Apr  8 10:56:56 PDT 2004
--  \___\/\___\
--
-- Revision:
--    03/23/04 - Initial version.
----- CELL x_ramb16_s4_s9 -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;

library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.VPACKAGE.all;
use simprim.VCOMPONENTS.all;

entity X_RAMB16_S4_S9 is
  generic (
    TimingChecksOn : boolean := true;
    Xon            : boolean := true;
    MsgOn          : boolean := true;

    LOC            : string  := "UNPLACED";

    tipd_ADDRA : VitalDelayArrayType01(11 downto 0)  := (others => (0 ps, 0 ps));
    tipd_CLKA  : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_DIA   : VitalDelayArrayType01(3 downto 0) := (others => (0 ps, 0 ps));
    tipd_ENA   : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_SSRA  : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_WEA   : VitalDelayType01                   := ( 0 ps, 0 ps);

    tipd_ADDRB : VitalDelayArrayType01(10 downto 0)  := (others => (0 ps, 0 ps));
    tipd_CLKB  : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_DIB   : VitalDelayArrayType01(7 downto 0) := (others => (0 ps, 0 ps));
    tipd_DIPB  : VitalDelayArrayType01(0 downto 0)  := (others => (0 ps, 0 ps));
    tipd_ENB   : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_SSRB  : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_WEB   : VitalDelayType01                   := ( 0 ps, 0 ps);

    tipd_GSR : VitalDelayType01 := ( 0 ps, 0 ps);

    tpd_GSR_DOA  : VitalDelayArrayType01(3 downto 0) := (others => (0 ps, 0 ps));
    tpd_GSR_DOB  : VitalDelayArrayType01(7 downto 0) := (others => (0 ps, 0 ps));
    tpd_GSR_DOPB : VitalDelayArrayType01(0 downto 0)  := (others => (0 ps, 0 ps));

    tpd_CLKA_DOA  : VitalDelayArrayType01(3 downto 0) := (others => (100 ps, 100 ps));
    tpd_CLKB_DOB  : VitalDelayArrayType01(7 downto 0) := (others => (100 ps, 100 ps));
    tpd_CLKB_DOPB : VitalDelayArrayType01(0 downto 0)  := (others => (100 ps, 100 ps));

    trecovery_GSR_CLKA_negedge_posedge : VitalDelayType                   := 0 ps;
    tsetup_ADDRA_CLKA_negedge_posedge  : VitalDelayArrayType(11 downto 0)  := (others => 0 ps);
    tsetup_ADDRA_CLKA_posedge_posedge  : VitalDelayArrayType(11 downto 0)  := (others => 0 ps);
    tsetup_DIA_CLKA_negedge_posedge    : VitalDelayArrayType(3 downto 0) := (others => 0 ps);
    tsetup_DIA_CLKA_posedge_posedge    : VitalDelayArrayType(3 downto 0) := (others => 0 ps);
    tsetup_ENA_CLKA_negedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_ENA_CLKA_posedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_SSRA_CLKA_negedge_posedge   : VitalDelayType                   := 0 ps;
    tsetup_SSRA_CLKA_posedge_posedge   : VitalDelayType                   := 0 ps;
    tsetup_WEA_CLKA_negedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_WEA_CLKA_posedge_posedge    : VitalDelayType                   := 0 ps;

    trecovery_GSR_CLKB_negedge_posedge : VitalDelayType                   := 0 ps;
    tsetup_ADDRB_CLKB_negedge_posedge  : VitalDelayArrayType(10 downto 0)  := (others => 0 ps);
    tsetup_ADDRB_CLKB_posedge_posedge  : VitalDelayArrayType(10 downto 0)  := (others => 0 ps);
    tsetup_DIB_CLKB_negedge_posedge    : VitalDelayArrayType(7 downto 0) := (others => 0 ps);
    tsetup_DIB_CLKB_posedge_posedge    : VitalDelayArrayType(7 downto 0) := (others => 0 ps);
    tsetup_DIPB_CLKB_negedge_posedge   : VitalDelayArrayType(0 downto 0)  := (others => 0 ps);
    tsetup_DIPB_CLKB_posedge_posedge   : VitalDelayArrayType(0 downto 0)  := (others => 0 ps);
    tsetup_ENB_CLKB_negedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_ENB_CLKB_posedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_SSRB_CLKB_negedge_posedge   : VitalDelayType                   := 0 ps;
    tsetup_SSRB_CLKB_posedge_posedge   : VitalDelayType                   := 0 ps;
    tsetup_WEB_CLKB_negedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_WEB_CLKB_posedge_posedge    : VitalDelayType                   := 0 ps;

    thold_ADDRA_CLKA_negedge_posedge : VitalDelayArrayType(11 downto 0)  := (others => 0 ps);
    thold_ADDRA_CLKA_posedge_posedge : VitalDelayArrayType(11 downto 0)  := (others => 0 ps);
    thold_DIA_CLKA_negedge_posedge   : VitalDelayArrayType(3 downto 0) := (others => 0 ps);
    thold_DIA_CLKA_posedge_posedge   : VitalDelayArrayType(3 downto 0) := (others => 0 ps);
    thold_ENA_CLKA_negedge_posedge   : VitalDelayType                   := 0 ps;
    thold_ENA_CLKA_posedge_posedge   : VitalDelayType                   := 0 ps;
    thold_GSR_CLKA_negedge_posedge   : VitalDelayType                   := 0 ps;
    thold_SSRA_CLKA_negedge_posedge  : VitalDelayType                   := 0 ps;
    thold_SSRA_CLKA_posedge_posedge  : VitalDelayType                   := 0 ps;
    thold_WEA_CLKA_negedge_posedge   : VitalDelayType                   := 0 ps;
    thold_WEA_CLKA_posedge_posedge   : VitalDelayType                   := 0 ps;

    thold_ADDRB_CLKB_negedge_posedge : VitalDelayArrayType(10 downto 0)  := (others => 0 ps);
    thold_ADDRB_CLKB_posedge_posedge : VitalDelayArrayType(10 downto 0)  := (others => 0 ps);
    thold_DIB_CLKB_negedge_posedge   : VitalDelayArrayType(7 downto 0) := (others => 0 ps);
    thold_DIB_CLKB_posedge_posedge   : VitalDelayArrayType(7 downto 0) := (others => 0 ps);
    thold_DIPB_CLKB_negedge_posedge  : VitalDelayArrayType(0 downto 0)  := (others => 0 ps);
    thold_DIPB_CLKB_posedge_posedge  : VitalDelayArrayType(0 downto 0)  := (others => 0 ps);
    thold_ENB_CLKB_negedge_posedge   : VitalDelayType                   := 0 ps;
    thold_ENB_CLKB_posedge_posedge   : VitalDelayType                   := 0 ps;
    thold_GSR_CLKB_negedge_posedge   : VitalDelayType                   := 0 ps;
    thold_SSRB_CLKB_negedge_posedge  : VitalDelayType                   := 0 ps;
    thold_SSRB_CLKB_posedge_posedge  : VitalDelayType                   := 0 ps;
    thold_WEB_CLKB_negedge_posedge   : VitalDelayType                   := 0 ps;
    thold_WEB_CLKB_posedge_posedge   : VitalDelayType                   := 0 ps;

    tbpd_GSR_DOA_CLKA  : VitalDelayArrayType01(3 downto 0) := (others => (0 ps, 0 ps));
    ticd_CLKA          : VitalDelayType                     := 0 ps;
    tisd_ADDRA_CLKA    : VitalDelayArrayType(11 downto 0)    := (others => 0 ps);
    tisd_DIA_CLKA      : VitalDelayArrayType(3 downto 0)   := (others => 0 ps);
    tisd_ENA_CLKA      : VitalDelayType                     := 0 ps;
    tisd_GSR_CLKA      : VitalDelayType                     := 0 ps;
    tisd_SSRA_CLKA     : VitalDelayType                     := 0 ps;
    tisd_WEA_CLKA      : VitalDelayType                     := 0 ps;

    tbpd_GSR_DOB_CLKB  : VitalDelayArrayType01(7 downto 0) := (others => (0 ps, 0 ps));
    tbpd_GSR_DOPB_CLKB : VitalDelayArrayType01(0 downto 0)  := (others => (0 ps, 0 ps));
    ticd_CLKB          : VitalDelayType                     := 0 ps;
    tisd_ADDRB_CLKB    : VitalDelayArrayType(10 downto 0)    := (others => 0 ps);
    tisd_DIB_CLKB      : VitalDelayArrayType(7 downto 0)   := (others => 0 ps);
    tisd_DIPB_CLKB     : VitalDelayArrayType(0 downto 0)    := (others => 0 ps);
    tisd_ENB_CLKB      : VitalDelayType                     := 0 ps;
    tisd_GSR_CLKB      : VitalDelayType                     := 0 ps;
    tisd_SSRB_CLKB     : VitalDelayType                     := 0 ps;
    tisd_WEB_CLKB      : VitalDelayType                     := 0 ps;

    tpw_CLKA_negedge : VitalDelayType := 0 ps;
    tpw_CLKA_posedge : VitalDelayType := 0 ps;
    tpw_CLKB_negedge : VitalDelayType := 0 ps;
    tpw_CLKB_posedge : VitalDelayType := 0 ps;
    tpw_GSR_posedge  : VitalDelayType := 0 ps;

    INITP_00 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_01 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_02 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_03 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_04 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_05 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_06 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_07 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";

    INIT_00  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_01  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_02  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_03  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_04  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_05  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_06  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_07  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_08  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_09  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0A  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0B  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0C  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0D  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0E  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0F  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_10  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_11  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_12  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_13  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_14  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_15  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_16  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_17  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_18  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_19  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1A  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1B  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1C  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1D  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1E  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1F  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_20  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_21  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_22  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_23  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_24  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_25  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_26  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_27  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_28  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_29  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2A  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2B  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2C  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2D  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2E  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2F  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_30  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_31  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_32  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_33  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_34  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_35  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_36  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_37  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_38  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_39  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3A  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3B  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3C  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3D  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3E  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3F  : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_A : bit_vector := X"0";
    INIT_B : bit_vector := X"000";

    SRVAL_A : bit_vector := X"0";
    SRVAL_B : bit_vector := X"000";

    SETUP_ALL        : VitalDelayType := 1000 ps;
    SETUP_READ_FIRST : VitalDelayType := 3000 ps;

    SIM_COLLISION_CHECK : string := "ALL";

    WRITE_MODE_A : string := "WRITE_FIRST";
    WRITE_MODE_B : string := "WRITE_FIRST"

    );

  port(
    DOA   : out std_logic_vector (3 downto 0);
    DOB   : out std_logic_vector (7 downto 0);
    DOPB  : out std_logic_vector (0 downto 0);

    ADDRA : in  std_logic_vector (11 downto 0);
    ADDRB : in  std_logic_vector (10 downto 0);
    CLKA  : in  std_ulogic;
    CLKB  : in  std_ulogic;
    DIA   : in  std_logic_vector (3 downto 0);
    DIB   : in  std_logic_vector (7 downto 0);
    DIPB  : in  std_logic_vector (0 downto 0);
    ENA   : in  std_ulogic;
    ENB   : in  std_ulogic;
    SSRA  : in  std_ulogic;
    SSRB  : in  std_ulogic;
    WEA   : in  std_ulogic;
    WEB   : in  std_ulogic
    );

  attribute VITAL_LEVEL0 of
    X_RAMB16_S4_S9 : entity is true;
end x_ramb16_s4_s9;

architecture X_RAMB16_S4_S9_V of X_RAMB16_S4_S9 is

  attribute VITAL_LEVEL0 of
    X_RAMB16_S4_S9_V : architecture is true;

  signal ADDRA_ipd : std_logic_vector(11 downto 0)  := (others => 'X');
  signal CLKA_ipd  : std_ulogic                    := 'X';
  signal DIA_ipd   : std_logic_vector(3 downto 0) := (others => 'X');
  signal ENA_ipd   : std_ulogic                    := 'X';
  signal SSRA_ipd  : std_ulogic                    := 'X';
  signal WEA_ipd   : std_ulogic                    := 'X';

  signal ADDRB_ipd : std_logic_vector(10 downto 0)  := (others => 'X');
  signal CLKB_ipd  : std_ulogic                    := 'X';
  signal DIB_ipd   : std_logic_vector(7 downto 0) := (others => 'X');
  signal DIPB_ipd  : std_logic_vector(0 downto 0)  := (others => 'X');
  signal ENB_ipd   : std_ulogic                    := 'X';
  signal SSRB_ipd  : std_ulogic                    := 'X';
  signal WEB_ipd   : std_ulogic                    := 'X';

  signal GSR_ipd : std_ulogic := 'X';

  signal ADDRA_dly    : std_logic_vector(11 downto 0)  := (others => 'X');
  signal CLKA_dly     : std_ulogic                    := 'X';
  signal DIA_dly      : std_logic_vector(3 downto 0) := (others => 'X');
  signal ENA_dly      : std_ulogic                    := 'X';
  signal GSR_CLKA_dly : std_ulogic                    := 'X';
  signal SSRA_dly     : std_ulogic                    := 'X';
  signal WEA_dly      : std_ulogic                    := 'X';

  signal ADDRB_dly    : std_logic_vector(10 downto 0)  := (others => 'X');
  signal CLKB_dly     : std_ulogic                    := 'X';
  signal DIB_dly      : std_logic_vector(7 downto 0) := (others => 'X');
  signal DIPB_dly     : std_logic_vector(0 downto 0)  := (others => 'X');
  signal ENB_dly      : std_ulogic                    := 'X';
  signal GSR_CLKB_dly : std_ulogic                    := 'X';
  signal SSRB_dly     : std_ulogic                    := 'X';
  signal WEB_dly      : std_ulogic                    := 'X';
  constant length_a : integer := 4096;
  constant length_b : integer := 2048;  
  constant width_a : integer := 4;
  constant width_b : integer := 8;  

  constant parity_width_a : integer := 0;
  constant parity_width_b : integer := 1;
  
  type Two_D_array_type is array ((length_b -  1) downto 0) of std_logic_vector((width_b - 1) downto 0);
  type Two_D_parity_array_type is array ((length_b - 1) downto 0) of std_logic_vector((parity_width_b - 1)downto 0);    

  function slv_to_two_D_array(
    slv_length : integer;
    slv_width : integer;
    SLV : in std_logic_vector
    )
    return two_D_array_type is
    variable two_D_array : two_D_array_type;
    variable intermediate : std_logic_vector((slv_width - 1) downto 0);
  begin
    for i in 0 to (slv_length - 1)loop
      intermediate := SLV(((i*slv_width) + (slv_width - 1)) downto (i* slv_width));
      two_D_array(i) := intermediate; 
    end loop;
    return two_D_array;
  end;

  function slv_to_two_D_parity_array(
    slv_length : integer;
    slv_width : integer;
    SLV : in std_logic_vector
    )
    return two_D_parity_array_type is
    variable two_D_parity_array : two_D_parity_array_type;
    variable intermediate : std_logic_vector((slv_width - 1) downto 0);
  begin
    for i in 0 to (slv_length - 1)loop
      intermediate := SLV(((i*slv_width) + (slv_width - 1)) downto (i* slv_width));
      two_D_parity_array(i) := intermediate; 
    end loop;
    return two_D_parity_array;
  end;          
begin
  WireDelay     : block
  begin
    ADDRA_DELAY : for i in 11 downto 0 generate
      VitalWireDelay (ADDRA_ipd(i), ADDRA(i), tipd_ADDRA(i));
    end generate ADDRA_DELAY;
    VitalWireDelay (CLKA_ipd, CLKA, tipd_CLKA);
    DIA_DELAY   : for i in 3 downto 0 generate
      VitalWireDelay (DIA_ipd(i), DIA(i), tipd_DIA(i));
    end generate DIA_DELAY;
    VitalWireDelay (ENA_ipd, ENA, tipd_ENA);
    VitalWireDelay (SSRA_ipd, SSRA, tipd_SSRA);
    VitalWireDelay (WEA_ipd, WEA, tipd_WEA);
    ADDRB_DELAY : for i in 10 downto 0 generate
      VitalWireDelay (ADDRB_ipd(i), ADDRB(i), tipd_ADDRB(i));
    end generate ADDRB_DELAY;
    VitalWireDelay (CLKB_ipd, CLKB, tipd_CLKB);
    DIB_DELAY   : for i in 7 downto 0 generate
      VitalWireDelay (DIB_ipd(i), DIB(i), tipd_DIB(i));
    end generate DIB_DELAY;
    DIPB_DELAY  : for i in 0 downto 0 generate
      VitalWireDelay (DIPB_ipd(i), DIPB(i), tipd_DIPB(i));
    end generate DIPB_DELAY;
    VitalWireDelay (ENB_ipd, ENB, tipd_ENB);
    VitalWireDelay (SSRB_ipd, SSRB, tipd_SSRB);
    VitalWireDelay (WEB_ipd, WEB, tipd_WEB);
    VitalWireDelay (GSR_ipd, GSR, tipd_GSR);
  end block;

  SignalDelay   : block
  begin
    ADDRA_DELAY : for i in 11 downto 0 generate
      VitalSignalDelay (ADDRA_dly(i), ADDRA_ipd(i), tisd_ADDRA_CLKA(i));
    end generate ADDRA_DELAY;
    VitalSignalDelay (CLKA_dly, CLKA_ipd, ticd_CLKA);
    DIA_DELAY   : for i in 3 downto 0 generate
      VitalSignalDelay (DIA_dly(i), DIA_ipd(i), tisd_DIA_CLKA(i));
    end generate DIA_DELAY;
    VitalSignalDelay (ENA_dly, ENA_ipd, tisd_ENA_CLKA);
    VitalSignalDelay (GSR_CLKA_dly, GSR_ipd, tisd_GSR_CLKA);
    VitalSignalDelay (SSRA_dly, SSRA_ipd, tisd_SSRA_CLKA);
    VitalSignalDelay (WEA_dly, WEA_ipd, tisd_WEA_CLKA);

    ADDRB_DELAY : for i in 10 downto 0 generate
      VitalSignalDelay (ADDRB_dly(i), ADDRB_ipd(i), tisd_ADDRB_CLKB(i));
    end generate ADDRB_DELAY;
    VitalSignalDelay (CLKB_dly, CLKB_ipd, ticd_CLKB);
    DIB_DELAY   : for i in 7 downto 0 generate
      VitalSignalDelay (DIB_dly(i), DIB_ipd(i), tisd_DIB_CLKB(i));
    end generate DIB_DELAY;
    DIPB_DELAY  : for i in 0 downto 0 generate
      VitalSignalDelay (DIPB_dly(i), DIPB_ipd(i), tisd_DIPB_CLKB(i));
    end generate DIPB_DELAY;
    VitalSignalDelay (ENB_dly, ENB_ipd, tisd_ENB_CLKB);
    VitalSignalDelay (GSR_CLKB_dly, GSR_ipd, tisd_GSR_CLKB);
    VitalSignalDelay (SSRB_dly, SSRB_ipd, tisd_SSRB_CLKB);
    VitalSignalDelay (WEB_dly, WEB_ipd, tisd_WEB_CLKB);
  end block;

  VITALBehavior                        : process
    variable Tviol_ADDRA0_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA1_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA2_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA3_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA4_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA5_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA6_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA7_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA8_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA9_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA10_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA11_CLKA_posedge : std_ulogic := '0';
    variable Tviol_DIA0_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA1_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA2_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA3_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_ENA_CLKA_posedge    : std_ulogic := '0';
    variable Tviol_GSR_CLKA_posedge    : std_ulogic := '0';
    variable Tviol_SSRA_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_WEA_CLKA_posedge    : std_ulogic := '0';

    variable Tviol_ADDRB0_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB1_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB2_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB3_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB4_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB5_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB6_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB7_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB8_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB9_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB10_CLKB_posedge : std_ulogic := '0';
    variable Tviol_DIB0_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB1_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB2_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB3_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB4_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB5_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB6_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIB7_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_DIPB0_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_ENB_CLKB_posedge    : std_ulogic := '0';
    variable Tviol_GSR_CLKB_posedge    : std_ulogic := '0';
    variable Tviol_SSRB_CLKB_posedge   : std_ulogic := '0';
    variable Tviol_WEB_CLKB_posedge    : std_ulogic := '0';

    variable Tviol_CLKA_CLKB_all        : std_ulogic := '0';
    variable Tviol_CLKA_CLKB_read_first : std_ulogic := '0';
    variable Tviol_CLKB_CLKA_all        : std_ulogic := '0';
    variable Tviol_CLKB_CLKA_read_first : std_ulogic := '0';

    variable Tmkr_ADDRA0_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA1_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA2_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA3_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA4_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA5_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA6_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA7_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA8_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA9_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA10_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA11_CLKA_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA0_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA1_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA2_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA3_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ENA_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_GSR_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_SSRA_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_WEA_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;

    variable Tmkr_ADDRB0_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB1_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB2_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB3_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB4_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB5_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB6_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB7_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB8_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB9_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB10_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB0_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB1_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB2_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB3_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB4_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB5_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB6_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB7_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIPB0_CLKB_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ENB_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_GSR_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_SSRB_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_WEB_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;

    variable Tmkr_CLKA_CLKB_all        : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_CLKA_CLKB_read_first : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_CLKB_CLKA_all        : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_CLKB_CLKA_read_first : VitalTimingDataType := VitalTimingDataInit;

    variable PViol_GSR : std_ulogic          := '0';
    variable PInfo_GSR : VitalPeriodDataType := VitalPeriodDataInit;

    variable PViol_CLKA, PViol_CLKB : std_ulogic          := '0';
    variable PInfo_CLKA, PInfo_CLKB : VitalPeriodDataType := VitalPeriodDataInit;

    variable DOA_GlitchData0  : VitalGlitchDataType;
    variable DOA_GlitchData1  : VitalGlitchDataType;
    variable DOA_GlitchData2  : VitalGlitchDataType;
    variable DOA_GlitchData3  : VitalGlitchDataType;

    variable DOB_GlitchData0  : VitalGlitchDataType;
    variable DOB_GlitchData1  : VitalGlitchDataType;
    variable DOB_GlitchData2  : VitalGlitchDataType;
    variable DOB_GlitchData3  : VitalGlitchDataType;
    variable DOB_GlitchData4  : VitalGlitchDataType;
    variable DOB_GlitchData5  : VitalGlitchDataType;
    variable DOB_GlitchData6  : VitalGlitchDataType;
    variable DOB_GlitchData7  : VitalGlitchDataType;
    variable DOPB_GlitchData0 : VitalGlitchDataType;

    variable mem_slv : std_logic_vector(16383 downto 0) := To_StdLogicVector(INIT_3F) &
                                                       To_StdLogicVector(INIT_3E) &
                                                       To_StdLogicVector(INIT_3D) &
                                                       To_StdLogicVector(INIT_3C) &
                                                       To_StdLogicVector(INIT_3B) &
                                                       To_StdLogicVector(INIT_3A) &
                                                       To_StdLogicVector(INIT_39) &
                                                       To_StdLogicVector(INIT_38) &
                                                       To_StdLogicVector(INIT_37) &
                                                       To_StdLogicVector(INIT_36) &
                                                       To_StdLogicVector(INIT_35) &
                                                       To_StdLogicVector(INIT_34) &
                                                       To_StdLogicVector(INIT_33) &
                                                       To_StdLogicVector(INIT_32) &
                                                       To_StdLogicVector(INIT_31) &
                                                       To_StdLogicVector(INIT_30) &
                                                       To_StdLogicVector(INIT_2F) &
                                                       To_StdLogicVector(INIT_2E) &
                                                       To_StdLogicVector(INIT_2D) &
                                                       To_StdLogicVector(INIT_2C) &
                                                       To_StdLogicVector(INIT_2B) &
                                                       To_StdLogicVector(INIT_2A) &
                                                       To_StdLogicVector(INIT_29) &
                                                       To_StdLogicVector(INIT_28) &
                                                       To_StdLogicVector(INIT_27) &
                                                       To_StdLogicVector(INIT_26) &
                                                       To_StdLogicVector(INIT_25) &
                                                       To_StdLogicVector(INIT_24) &
                                                       To_StdLogicVector(INIT_23) &
                                                       To_StdLogicVector(INIT_22) &
                                                       To_StdLogicVector(INIT_21) &
                                                       To_StdLogicVector(INIT_20) &
                                                       To_StdLogicVector(INIT_1F) &
                                                       To_StdLogicVector(INIT_1E) &
                                                       To_StdLogicVector(INIT_1D) &
                                                       To_StdLogicVector(INIT_1C) &
                                                       To_StdLogicVector(INIT_1B) &
                                                       To_StdLogicVector(INIT_1A) &
                                                       To_StdLogicVector(INIT_19) &
                                                       To_StdLogicVector(INIT_18) &
                                                       To_StdLogicVector(INIT_17) &
                                                       To_StdLogicVector(INIT_16) &
                                                       To_StdLogicVector(INIT_15) &
                                                       To_StdLogicVector(INIT_14) &
                                                       To_StdLogicVector(INIT_13) &
                                                       To_StdLogicVector(INIT_12) &
                                                       To_StdLogicVector(INIT_11) &
                                                       To_StdLogicVector(INIT_10) &
                                                       To_StdLogicVector(INIT_0F) &
                                                       To_StdLogicVector(INIT_0E) &
                                                       To_StdLogicVector(INIT_0D) &
                                                       To_StdLogicVector(INIT_0C) &
                                                       To_StdLogicVector(INIT_0B) &
                                                       To_StdLogicVector(INIT_0A) &
                                                       To_StdLogicVector(INIT_09) &
                                                       To_StdLogicVector(INIT_08) &
                                                       To_StdLogicVector(INIT_07) &
                                                       To_StdLogicVector(INIT_06) &
                                                       To_StdLogicVector(INIT_05) &
                                                       To_StdLogicVector(INIT_04) &
                                                       To_StdLogicVector(INIT_03) &
                                                       To_StdLogicVector(INIT_02) &
                                                       To_StdLogicVector(INIT_01) &
                                                       To_StdLogicVector(INIT_00);
    variable memp_slv : std_logic_vector(2047 downto 0) := To_StdLogicVector(INITP_07) &
                                                       To_StdLogicVector(INITP_06) &
                                                       To_StdLogicVector(INITP_05) &
                                                       To_StdLogicVector(INITP_04) &
                                                       To_StdLogicVector(INITP_03) &
                                                       To_StdLogicVector(INITP_02) &
                                                       To_StdLogicVector(INITP_01) &
                                                       To_StdLogicVector(INITP_00);
    variable mem : Two_D_array_type := slv_to_two_D_array(length_b, width_b, mem_slv);
    variable memp : Two_D_parity_array_type := slv_to_two_D_parity_array(length_b, parity_width_b, memp_slv);
    variable INIT_A_reg         : std_logic_vector (3 downto 0) := "0000";
    variable INIT_B_reg         : std_logic_vector (8 downto 0) := "000000000";
    variable ADDRA_dly_sampled : std_logic_vector(11 downto 0)   := (others => 'X');
    variable ADDRB_dly_sampled : std_logic_vector(10 downto 0)   := (others => 'X');
    variable ADDRESS_A         : integer;
    variable ADDRESS_B         : integer;
    variable DOA_OV_LSB        : integer;
    variable DOA_OV_MSB        : integer;
    variable DOA_zd            : std_logic_vector(3 downto 0);
    variable DOB_OV_LSB        : integer;
    variable DOB_OV_MSB        : integer;
    variable DOB_zd            : std_logic_vector(7 downto 0);
    variable DOPA_OV_LSB       : integer;
    variable DOPA_OV_MSB       : integer;
    variable DOPB_OV_LSB       : integer;
    variable DOPB_OV_MSB       : integer;
    variable DOPB_zd           : std_logic_vector(0 downto 0);
    variable ENA_dly_sampled   : std_ulogic                      := 'X';
    variable ENB_dly_sampled   : std_ulogic                      := 'X';
    variable FIRST_TIME        : boolean                        := true;
    variable HAS_OVERLAP       : boolean                        := false;
    variable HAS_OVERLAP_P     : boolean                        := false;
    variable OLPP_LSB          : integer;
    variable OLPP_MSB          : integer;
    variable OLP_LSB           : integer;
    variable OLP_MSB           : integer;
    variable SRVAL_A_reg            : std_logic_vector (3 downto 0) := "0000";
    variable SRVAL_B_reg            : std_logic_vector (8 downto 0) := "000000000";
    variable SSRA_dly_sampled  : std_ulogic                      := 'X';
    variable SSRB_dly_sampled  : std_ulogic                      := 'X';
    variable VALID_ADDRA       : boolean                        := false;
    variable VALID_ADDRB       : boolean                        := false;
    variable WR_A_LATER        : boolean                        := false;
    variable WR_B_LATER        : boolean                        := false;
    variable ViolationA        : std_ulogic                     := '0';
    variable ViolationB        : std_ulogic                     := '0';
    variable ViolationCLKAB    : std_ulogic                     := '0';
    variable ViolationCLKAB_S0 : boolean                        := false;
    variable Violation_S1      : boolean                        := false;
    variable Violation_S3      : boolean                        := false;
    variable WEA_dly_sampled   : std_ulogic                      := 'X';
    variable WEB_dly_sampled   : std_ulogic                      := 'X';
    variable wr_mode_a         : integer                        := 0;
    variable wr_mode_b         : integer                        := 0;
    variable collision_type : integer := 3;

  begin
    if (FIRST_TIME) then
      if ((SIM_COLLISION_CHECK = "none") or (SIM_COLLISION_CHECK = "NONE"))  then
        collision_type := 0;
      elsif ((SIM_COLLISION_CHECK = "warning_only") or (SIM_COLLISION_CHECK = "WARNING_ONLY"))  then
        collision_type := 1;
      elsif ((SIM_COLLISION_CHECK = "generate_x_only") or (SIM_COLLISION_CHECK = "GENERATE_X_ONLY"))  then
        collision_type := 2;
      elsif ((SIM_COLLISION_CHECK = "all") or (SIM_COLLISION_CHECK = "ALL"))  then        
        collision_type := 3;
      else
        GenericValueCheckMessage
          (HeaderMsg => "Attribute Syntax Error",
           GenericName => "SIM_COLLISION_CHECK",
           EntityName => "X_RAMB16_S4_S9",
           GenericValue => SIM_COLLISION_CHECK,
           Unit => "",
           ExpectedValueMsg => "Legal Values for this attribute are ALL, NONE, WARNING_ONLY or GENERATE_X_ONLY",
           ExpectedGenericValue => "",
           TailMsg => "",
           MsgSeverity => error
           );
      end if;
      if (INIT_A'length > 4) then
        INIT_A_reg(3 downto 0)        := To_StdLogicVector(INIT_A)(3 downto 0);
      else
        INIT_A_reg(INIT_A'length-1 downto 0)         := To_StdLogicVector(INIT_A);
      end if;
      DOA_zd(3 downto 0)                       := INIT_A_reg(3 downto 0);
      DOA  <= DOA_zd;

      if (INIT_B'length > 9) then
        INIT_B_reg(8 downto 0)        := To_StdLogicVector(INIT_B)(8 downto 0);
      else
        INIT_B_reg(INIT_B'length-1 downto 0)         := To_StdLogicVector(INIT_B);
      end if;
      DOB_zd(7 downto 0)                       := INIT_B_reg(7 downto 0);
      DOPB_zd(0 downto 0)                       := INIT_B_reg(8 downto 8);
      DOB  <= DOB_zd;
      DOPB <= DOPB_zd;

      if (SRVAL_A'length > 4) then
        SRVAL_A_reg(3 downto 0)        := To_StdLogicVector(SRVAL_A)(3 downto 0);
      else
        SRVAL_A_reg(SRVAL_A'length-1 downto 0)         := To_StdLogicVector(SRVAL_A);
      end if;
      if (SRVAL_B'length > 9) then
        SRVAL_B_reg(8 downto 0)        := To_StdLogicVector(SRVAL_B)(8 downto 0);
      else
        SRVAL_B_reg(SRVAL_B'length-1 downto 0)         := To_StdLogicVector(SRVAL_B);
      end if;
      if ((WRITE_MODE_A = "write_first") or (WRITE_MODE_A = "WRITE_FIRST")) then
        wr_mode_a := 0;
      elsif ((WRITE_MODE_A = "read_first") or (WRITE_MODE_A = "READ_FIRST")) then
        wr_mode_a := 1;
      elsif ((WRITE_MODE_A = "no_change") or (WRITE_MODE_A = "NO_CHANGE")) then
        wr_mode_a := 2;
      else
        GenericValueCheckMessage
          ( HeaderMsg            => " Attribute Syntax Error ",
            GenericName          => " WRITE_MODE_A ",
            EntityName           => "/X_RAMB16_S4_S9",
            GenericValue         => WRITE_MODE_A,
            Unit                 => "",
            ExpectedValueMsg     => " The Legal values for this attribute are ",
            ExpectedGenericValue => " WRITE_FIRST, READ_FIRST or NO_CHANGE ",
            TailMsg              => "",
            MsgSeverity          => error
            );
      end if;

      if ((WRITE_MODE_B = "write_first") or (WRITE_MODE_B = "WRITE_FIRST")) then
        wr_mode_b := 0;
      elsif ((WRITE_MODE_B = "read_first") or (WRITE_MODE_B = "READ_FIRST")) then
        wr_mode_b := 1;
      elsif ((WRITE_MODE_B = "no_change") or (WRITE_MODE_B = "NO_CHANGE")) then
        wr_mode_b := 2;
      else
        GenericValueCheckMessage
          ( HeaderMsg            => " Attribute Syntax Error ",
            GenericName          => " WRITE_MODE_B ",
            EntityName           => "/X_RAMB16_S4_S9",
            GenericValue         => WRITE_MODE_B,
            Unit                 => "",
            ExpectedValueMsg     => " The Legal values for this attribute are ",
            ExpectedGenericValue => " WRITE_FIRST, READ_FIRST or NO_CHANGE ",
            TailMsg              => "",
            MsgSeverity          => error
            );
      end if;
      FIRST_TIME  := false;
    end if;

    if (CLKA_dly'event) then
      ENA_dly_sampled   := ENA_dly;
      SSRA_dly_sampled  := SSRA_dly;
      WEA_dly_sampled   := WEA_dly;
      ADDRA_dly_sampled := ADDRA_dly;
    end if;

    if (CLKB_dly'event) then
      ENB_dly_sampled   := ENB_dly;
      SSRB_dly_sampled  := SSRB_dly;
      WEB_dly_sampled   := WEB_dly;
      ADDRB_dly_sampled := ADDRB_dly;
    end if;
    if (TimingChecksOn) then
      VitalRecoveryRemovalCheck (
        Violation      => Tviol_GSR_CLKA_posedge,
        TimingData     => Tmkr_GSR_CLKA_posedge,
        TestSignal     => GSR_CLKA_dly,
        TestSignalName => "GSR",
        TestDelay      => tisd_GSR_CLKA,
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        Recovery       => trecovery_GSR_CLKA_negedge_posedge,
        Removal        => thold_GSR_CLKA_negedge_posedge,
        ActiveLow      => false,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ENA_CLKA_posedge,
        TimingData     => Tmkr_ENA_CLKA_posedge,
        TestSignal     => ENA_dly,
        TestSignalName => "ENA",
        TestDelay      => tisd_ENA_CLKA,
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ENA_CLKA_posedge_posedge,
        SetupLow       => tsetup_ENA_CLKA_negedge_posedge,
        HoldLow        => thold_ENA_CLKA_negedge_posedge,
        HoldHigh       => thold_ENA_CLKA_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_SSRA_CLKA_posedge,
        TimingData     => Tmkr_SSRA_CLKA_posedge,
        TestSignal     => SSRA_dly,
        TestSignalName => "SSRA",
        TestDelay      => tisd_SSRA_CLKA,
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_SSRA_CLKA_posedge_posedge,
        SetupLow       => tsetup_SSRA_CLKA_negedge_posedge,
        HoldLow        => thold_SSRA_CLKA_negedge_posedge,
        HoldHigh       => thold_SSRA_CLKA_posedge_posedge,
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_WEA_CLKA_posedge,
        TimingData     => Tmkr_WEA_CLKA_posedge,
        TestSignal     => WEA_dly,
        TestSignalName => "WEA",
        TestDelay      => tisd_WEA_CLKA,
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_WEA_CLKA_posedge_posedge,
        SetupLow       => tsetup_WEA_CLKA_negedge_posedge,
        HoldLow        => thold_WEA_CLKA_negedge_posedge,
        HoldHigh       => thold_WEA_CLKA_posedge_posedge,
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA0_CLKA_posedge,
        TimingData     => Tmkr_ADDRA0_CLKA_posedge,
        TestSignal     => ADDRA_dly(0),
        TestSignalName => "ADDRA(0)",
        TestDelay      => tisd_ADDRA_CLKA(0),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(0),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(0),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(0),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(0),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA1_CLKA_posedge,
        TimingData     => Tmkr_ADDRA1_CLKA_posedge,
        TestSignal     => ADDRA_dly(1),
        TestSignalName => "ADDRA(1)",
        TestDelay      => tisd_ADDRA_CLKA(1),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(1),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(1),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(1),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(1),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA2_CLKA_posedge,
        TimingData     => Tmkr_ADDRA2_CLKA_posedge,
        TestSignal     => ADDRA_dly(2),
        TestSignalName => "ADDRA(2)",
        TestDelay      => tisd_ADDRA_CLKA(2),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(2),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(2),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(2),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(2),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA3_CLKA_posedge,
        TimingData     => Tmkr_ADDRA3_CLKA_posedge,
        TestSignal     => ADDRA_dly(3),
        TestSignalName => "ADDRA(3)",
        TestDelay      => tisd_ADDRA_CLKA(3),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(3),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(3),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(3),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(3),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA4_CLKA_posedge,
        TimingData     => Tmkr_ADDRA4_CLKA_posedge,
        TestSignal     => ADDRA_dly(4),
        TestSignalName => "ADDRA(4)",
        TestDelay      => tisd_ADDRA_CLKA(4),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(4),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(4),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(4),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(4),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA5_CLKA_posedge,
        TimingData     => Tmkr_ADDRA5_CLKA_posedge,
        TestSignal     => ADDRA_dly(5),
        TestSignalName => "ADDRA(5)",
        TestDelay      => tisd_ADDRA_CLKA(5),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(5),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(5),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(5),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(5),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA6_CLKA_posedge,
        TimingData     => Tmkr_ADDRA6_CLKA_posedge,
        TestSignal     => ADDRA_dly(6),
        TestSignalName => "ADDRA(6)",
        TestDelay      => tisd_ADDRA_CLKA(6),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(6),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(6),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(6),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(6),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA7_CLKA_posedge,
        TimingData     => Tmkr_ADDRA7_CLKA_posedge,
        TestSignal     => ADDRA_dly(7),
        TestSignalName => "ADDRA(7)",
        TestDelay      => tisd_ADDRA_CLKA(7),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(7),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(7),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(7),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(7),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA8_CLKA_posedge,
        TimingData     => Tmkr_ADDRA8_CLKA_posedge,
        TestSignal     => ADDRA_dly(8),
        TestSignalName => "ADDRA(8)",
        TestDelay      => tisd_ADDRA_CLKA(8),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(8),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(8),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(8),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(8),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA9_CLKA_posedge,
        TimingData     => Tmkr_ADDRA9_CLKA_posedge,
        TestSignal     => ADDRA_dly(9),
        TestSignalName => "ADDRA(9)",
        TestDelay      => tisd_ADDRA_CLKA(9),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(9),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(9),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(9),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(9),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA10_CLKA_posedge,
        TimingData     => Tmkr_ADDRA10_CLKA_posedge,
        TestSignal     => ADDRA_dly(10),
        TestSignalName => "ADDRA(10)",
        TestDelay      => tisd_ADDRA_CLKA(10),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(10),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(10),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(10),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(10),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRA11_CLKA_posedge,
        TimingData     => Tmkr_ADDRA11_CLKA_posedge,
        TestSignal     => ADDRA_dly(11),
        TestSignalName => "ADDRA(11)",
        TestDelay      => tisd_ADDRA_CLKA(11),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_ADDRA_CLKA_posedge_posedge(11),
        SetupLow       => tsetup_ADDRA_CLKA_negedge_posedge(11),
        HoldLow        => thold_ADDRA_CLKA_negedge_posedge(11),
        HoldHigh       => thold_ADDRA_CLKA_posedge_posedge(11),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA0_CLKA_posedge,
        TimingData     => Tmkr_DIA0_CLKA_posedge,
        TestSignal     => DIA_dly(0),
        TestSignalName => "DIA(0)",
        TestDelay      => tisd_DIA_CLKA(0),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(0),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(0),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(0),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(0),
        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA1_CLKA_posedge,
        TimingData     => Tmkr_DIA1_CLKA_posedge,
        TestSignal     => DIA_dly(1),
        TestSignalName => "DIA(1)",
        TestDelay      => tisd_DIA_CLKA(1),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(1),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(1),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(1),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(1),
        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA2_CLKA_posedge,
        TimingData     => Tmkr_DIA2_CLKA_posedge,
        TestSignal     => DIA_dly(2),
        TestSignalName => "DIA(2)",
        TestDelay      => tisd_DIA_CLKA(2),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(2),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(2),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(2),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(2),
        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA3_CLKA_posedge,
        TimingData     => Tmkr_DIA3_CLKA_posedge,
        TestSignal     => DIA_dly(3),
        TestSignalName => "DIA(3)",
        TestDelay      => tisd_DIA_CLKA(3),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(3),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(3),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(3),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(3),
        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalRecoveryRemovalCheck (
        Violation      => Tviol_GSR_CLKB_posedge,
        TimingData     => Tmkr_GSR_CLKB_posedge,
        TestSignal     => GSR_CLKB_dly,
        TestSignalName => "GSR",
        TestDelay      => tisd_GSR_CLKB,
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        Recovery       => trecovery_GSR_CLKB_negedge_posedge,
        Removal        => thold_GSR_CLKB_negedge_posedge,
        ActiveLow      => false,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ENB_CLKB_posedge,
        TimingData     => Tmkr_ENB_CLKB_posedge,
        TestSignal     => ENB_dly,
        TestSignalName => "ENB",
        TestDelay      => tisd_ENB_CLKB,
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ENB_CLKB_posedge_posedge,
        SetupLow       => tsetup_ENB_CLKB_negedge_posedge,
        HoldLow        => thold_ENB_CLKB_negedge_posedge,
        HoldHigh       => thold_ENB_CLKB_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_SSRB_CLKB_posedge,
        TimingData     => Tmkr_SSRB_CLKB_posedge,
        TestSignal     => SSRB_dly,
        TestSignalName => "SSRB",
        TestDelay      => tisd_SSRB_CLKB,
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_SSRB_CLKB_posedge_posedge,
        SetupLow       => tsetup_SSRB_CLKB_negedge_posedge,
        HoldLow        => thold_SSRB_CLKB_negedge_posedge,
        HoldHigh       => thold_SSRB_CLKB_posedge_posedge,
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_WEB_CLKB_posedge,
        TimingData     => Tmkr_WEB_CLKB_posedge,
        TestSignal     => WEB_dly,
        TestSignalName => "WEB",
        TestDelay      => tisd_WEB_CLKB,
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_WEB_CLKB_posedge_posedge,
        SetupLow       => tsetup_WEB_CLKB_negedge_posedge,
        HoldLow        => thold_WEB_CLKB_negedge_posedge,
        HoldHigh       => thold_WEB_CLKB_posedge_posedge,
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB0_CLKB_posedge,
        TimingData     => Tmkr_ADDRB0_CLKB_posedge,
        TestSignal     => ADDRB_dly(0),
        TestSignalName => "ADDRB(0)",
        TestDelay      => tisd_ADDRB_CLKB(0),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(0),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(0),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(0),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(0),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB1_CLKB_posedge,
        TimingData     => Tmkr_ADDRB1_CLKB_posedge,
        TestSignal     => ADDRB_dly(1),
        TestSignalName => "ADDRB(1)",
        TestDelay      => tisd_ADDRB_CLKB(1),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(1),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(1),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(1),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(1),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB2_CLKB_posedge,
        TimingData     => Tmkr_ADDRB2_CLKB_posedge,
        TestSignal     => ADDRB_dly(2),
        TestSignalName => "ADDRB(2)",
        TestDelay      => tisd_ADDRB_CLKB(2),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(2),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(2),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(2),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(2),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB3_CLKB_posedge,
        TimingData     => Tmkr_ADDRB3_CLKB_posedge,
        TestSignal     => ADDRB_dly(3),
        TestSignalName => "ADDRB(3)",
        TestDelay      => tisd_ADDRB_CLKB(3),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(3),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(3),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(3),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(3),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB4_CLKB_posedge,
        TimingData     => Tmkr_ADDRB4_CLKB_posedge,
        TestSignal     => ADDRB_dly(4),
        TestSignalName => "ADDRB(4)",
        TestDelay      => tisd_ADDRB_CLKB(4),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(4),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(4),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(4),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(4),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB5_CLKB_posedge,
        TimingData     => Tmkr_ADDRB5_CLKB_posedge,
        TestSignal     => ADDRB_dly(5),
        TestSignalName => "ADDRB(5)",
        TestDelay      => tisd_ADDRB_CLKB(5),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(5),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(5),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(5),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(5),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB6_CLKB_posedge,
        TimingData     => Tmkr_ADDRB6_CLKB_posedge,
        TestSignal     => ADDRB_dly(6),
        TestSignalName => "ADDRB(6)",
        TestDelay      => tisd_ADDRB_CLKB(6),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(6),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(6),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(6),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(6),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB7_CLKB_posedge,
        TimingData     => Tmkr_ADDRB7_CLKB_posedge,
        TestSignal     => ADDRB_dly(7),
        TestSignalName => "ADDRB(7)",
        TestDelay      => tisd_ADDRB_CLKB(7),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(7),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(7),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(7),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(7),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB8_CLKB_posedge,
        TimingData     => Tmkr_ADDRB8_CLKB_posedge,
        TestSignal     => ADDRB_dly(8),
        TestSignalName => "ADDRB(8)",
        TestDelay      => tisd_ADDRB_CLKB(8),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(8),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(8),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(8),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(8),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB9_CLKB_posedge,
        TimingData     => Tmkr_ADDRB9_CLKB_posedge,
        TestSignal     => ADDRB_dly(9),
        TestSignalName => "ADDRB(9)",
        TestDelay      => tisd_ADDRB_CLKB(9),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(9),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(9),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(9),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(9),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_ADDRB10_CLKB_posedge,
        TimingData     => Tmkr_ADDRB10_CLKB_posedge,
        TestSignal     => ADDRB_dly(10),
        TestSignalName => "ADDRB(10)",
        TestDelay      => tisd_ADDRB_CLKB(10),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_ADDRB_CLKB_posedge_posedge(10),
        SetupLow       => tsetup_ADDRB_CLKB_negedge_posedge(10),
        HoldLow        => thold_ADDRB_CLKB_negedge_posedge(10),
        HoldHigh       => thold_ADDRB_CLKB_posedge_posedge(10),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIPB0_CLKB_posedge,
        TimingData     => Tmkr_DIPB0_CLKB_posedge,
        TestSignal     => DIPB_dly(0),
        TestSignalName => "DIPB(0)",
        TestDelay      => tisd_DIPB_CLKB(0),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIPB_CLKB_posedge_posedge(0),
        SetupLow       => tsetup_DIPB_CLKB_negedge_posedge(0),
        HoldLow        => thold_DIPB_CLKB_negedge_posedge(0),
        HoldHigh       => thold_DIPB_CLKB_posedge_posedge(0),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB0_CLKB_posedge,
        TimingData     => Tmkr_DIB0_CLKB_posedge,
        TestSignal     => DIB_dly(0),
        TestSignalName => "DIB(0)",
        TestDelay      => tisd_DIB_CLKB(0),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(0),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(0),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(0),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(0),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB1_CLKB_posedge,
        TimingData     => Tmkr_DIB1_CLKB_posedge,
        TestSignal     => DIB_dly(1),
        TestSignalName => "DIB(1)",
        TestDelay      => tisd_DIB_CLKB(1),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(1),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(1),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(1),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(1),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB2_CLKB_posedge,
        TimingData     => Tmkr_DIB2_CLKB_posedge,
        TestSignal     => DIB_dly(2),
        TestSignalName => "DIB(2)",
        TestDelay      => tisd_DIB_CLKB(2),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(2),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(2),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(2),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(2),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB3_CLKB_posedge,
        TimingData     => Tmkr_DIB3_CLKB_posedge,
        TestSignal     => DIB_dly(3),
        TestSignalName => "DIB(3)",
        TestDelay      => tisd_DIB_CLKB(3),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(3),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(3),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(3),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(3),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB4_CLKB_posedge,
        TimingData     => Tmkr_DIB4_CLKB_posedge,
        TestSignal     => DIB_dly(4),
        TestSignalName => "DIB(4)",
        TestDelay      => tisd_DIB_CLKB(4),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(4),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(4),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(4),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(4),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB5_CLKB_posedge,
        TimingData     => Tmkr_DIB5_CLKB_posedge,
        TestSignal     => DIB_dly(5),
        TestSignalName => "DIB(5)",
        TestDelay      => tisd_DIB_CLKB(5),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(5),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(5),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(5),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(5),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB6_CLKB_posedge,
        TimingData     => Tmkr_DIB6_CLKB_posedge,
        TestSignal     => DIB_dly(6),
        TestSignalName => "DIB(6)",
        TestDelay      => tisd_DIB_CLKB(6),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(6),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(6),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(6),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(6),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIB7_CLKB_posedge,
        TimingData     => Tmkr_DIB7_CLKB_posedge,
        TestSignal     => DIB_dly(7),
        TestSignalName => "DIB(7)",
        TestDelay      => tisd_DIB_CLKB(7),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_DIB_CLKB_posedge_posedge(7),
        SetupLow       => tsetup_DIB_CLKB_negedge_posedge(7),
        HoldLow        => thold_DIB_CLKB_negedge_posedge(7),
        HoldHigh       => thold_DIB_CLKB_posedge_posedge(7),
        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalPeriodPulseCheck (
        Violation      => Pviol_CLKA,
        PeriodData     => PInfo_CLKA,
        TestSignal     => CLKA_dly,
        TestSignalName => "CLKA",
        TestDelay      => 0 ps,
        Period         => 0 ps,
        PulseWidthHigh => tpw_CLKA_posedge,
        PulseWidthLow  => tpw_CLKA_negedge,
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalPeriodPulseCheck (
        Violation      => Pviol_CLKB,
        PeriodData     => PInfo_CLKB,
        TestSignal     => CLKB_dly,
        TestSignalName => "CLKB",
        TestDelay      => 0 ps,
        Period         => 0 ps,
        PulseWidthHigh => tpw_CLKB_posedge,
        PulseWidthLow  => tpw_CLKB_negedge,
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalPeriodPulseCheck (
        Violation      => Pviol_GSR,
        PeriodData     => PInfo_GSR,
        TestSignal     => GSR_ipd,
        TestSignalName => "GSR",
        TestDelay      => 0 ps,
        Period         => 0 ps,
        PulseWidthHigh => tpw_GSR_posedge,
        PulseWidthLow  => 0 ps,
        CheckEnabled   => true,
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
    end if;
    ViolationA          :=
      Tviol_ADDRA0_CLKA_posedge or
      Tviol_ADDRA1_CLKA_posedge or
      Tviol_ADDRA2_CLKA_posedge or
      Tviol_ADDRA3_CLKA_posedge or
      Tviol_ADDRA4_CLKA_posedge or
      Tviol_ADDRA5_CLKA_posedge or
      Tviol_ADDRA6_CLKA_posedge or
      Tviol_ADDRA7_CLKA_posedge or
      Tviol_ADDRA8_CLKA_posedge or
      Tviol_ADDRA9_CLKA_posedge or
      Tviol_ADDRA10_CLKA_posedge or
      Tviol_ADDRA11_CLKA_posedge or
      Tviol_DIA0_CLKA_posedge or
      Tviol_DIA1_CLKA_posedge or
      Tviol_DIA2_CLKA_posedge or
      Tviol_DIA3_CLKA_posedge or
      Tviol_ENA_CLKA_posedge or
      Tviol_SSRA_CLKA_posedge or
      Tviol_WEA_CLKA_posedge or
      Pviol_CLKA ;
    ViolationB          :=
      Tviol_ADDRB0_CLKB_posedge or
      Tviol_ADDRB1_CLKB_posedge or
      Tviol_ADDRB2_CLKB_posedge or
      Tviol_ADDRB3_CLKB_posedge or
      Tviol_ADDRB4_CLKB_posedge or
      Tviol_ADDRB5_CLKB_posedge or
      Tviol_ADDRB6_CLKB_posedge or
      Tviol_ADDRB7_CLKB_posedge or
      Tviol_ADDRB8_CLKB_posedge or
      Tviol_ADDRB9_CLKB_posedge or
      Tviol_ADDRB10_CLKB_posedge or
      Tviol_DIB0_CLKB_posedge or
      Tviol_DIB1_CLKB_posedge or
      Tviol_DIB2_CLKB_posedge or
      Tviol_DIB3_CLKB_posedge or
      Tviol_DIB4_CLKB_posedge or
      Tviol_DIB5_CLKB_posedge or
      Tviol_DIB6_CLKB_posedge or
      Tviol_DIB7_CLKB_posedge or
      Tviol_DIPB0_CLKB_posedge or
      Tviol_ENB_CLKB_posedge or
      Tviol_SSRB_CLKB_posedge or
      Tviol_WEB_CLKB_posedge or
      Pviol_CLKB ;

    VALID_ADDRA           := ADDR_IS_VALID(addra_dly_sampled);
    if (VALID_ADDRA) then
      ADDRESS_A           := SLV_TO_INT(addra_dly_sampled);
    end if;
    VALID_ADDRB           := ADDR_IS_VALID(addrb_dly_sampled);
    if (VALID_ADDRB) then
      ADDRESS_B           := SLV_TO_INT(addrb_dly_sampled);
    end if;
    if (VALID_ADDRA and VALID_ADDRB) then
      ADDR_OVERLAP (ADDRESS_A, ADDRESS_B, WIDTH_A, WIDTH_B, HAS_OVERLAP, OLP_LSB, OLP_MSB, DOA_OV_LSB, DOA_OV_MSB, DOB_OV_LSB, DOB_OV_MSB);
    end if;
    ViolationCLKAB        := '0';
    ViolationCLKAB_S0     := false;
    Violation_S1          := false;
    Violation_S3          := false;
    if ((collision_type = 1) or (collision_type = 2) or (collision_type = 3)) then    
      VitalRecoveryRemovalCheck (
        Violation      => Tviol_CLKB_CLKA_all,
        TimingData     => Tmkr_CLKB_CLKA_all,
        TestSignal     => CLKB_dly,
        TestSignalName => "CLKB",
        TestDelay      => 0 ps,
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => 0 ps,
        Recovery       => SETUP_ALL,
        Removal       => 1 ps,
        ActiveLow      => true,
        CheckEnabled   => (HAS_OVERLAP = true and ena_dly_sampled = '1' and enb_dly_sampled = '1' and ((web_dly_sampled = '1' and wr_mode_b /= 1) or (wea_dly_sampled = '1' and wr_mode_a /= 1 and web_dly_sampled = '0'))),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => true,
        MsgOn          => false,
        MsgSeverity    => warning);

      VitalRecoveryRemovalCheck (
        Violation      => Tviol_CLKA_CLKB_all,
        TimingData     => Tmkr_CLKA_CLKB_all,
        TestSignal     => CLKA_dly,
        TestSignalName => "CLKA",
        TestDelay      => 0 ps,
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => 0 ps,
        Recovery       => SETUP_ALL,
        Removal       => 1 ps,
        ActiveLow      => true,
        CheckEnabled   => (HAS_OVERLAP = true and ena_dly_sampled = '1' and enb_dly_sampled = '1' and ((wea_dly_sampled = '1' and wr_mode_a /= 1) or (web_dly_sampled = '1' and wea_dly_sampled = '0' and wr_mode_b /= 1))),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => true,
        MsgOn          => false,
        MsgSeverity    => warning);

      VitalRecoveryRemovalCheck (
        Violation      => Tviol_CLKB_CLKA_read_first,
        TimingData     => Tmkr_CLKB_CLKA_read_first,
        TestSignal     => CLKB_dly,
        TestSignalName => "CLKB",
        TestDelay      => 0 ps,
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => 0 ps,
        Recovery       => SETUP_READ_FIRST,
        Removal       => 1 ps,
        ActiveLow      => true,
        CheckEnabled   => (HAS_OVERLAP = true and ena_dly_sampled = '1' and enb_dly_sampled = '1' and web_dly_sampled = '1' and wr_mode_b = 1 and (CLKA_dly'last_event /= CLKB_dly'last_event)),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => true,
        MsgOn          => false,
        MsgSeverity    => warning);

      VitalRecoveryRemovalCheck (
        Violation      => Tviol_CLKA_CLKB_read_first,
        TimingData     => Tmkr_CLKA_CLKB_read_first,
        TestSignal     => CLKA_dly,
        TestSignalName => "CLKA",
        TestDelay      => 0 ps,
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => 0 ps,
        Recovery       => SETUP_READ_FIRST,
        Removal       => 1 ps,
        ActiveLow      => true,
        CheckEnabled   => (HAS_OVERLAP = true and ena_dly_sampled = '1' and enb_dly_sampled = '1' and wea_dly_sampled = '1' and wr_mode_a = 1 and (CLKA_dly'last_event /= CLKB_dly'last_event)),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16_S4_S9",
        Xon            => true,
        MsgOn          => false,
        MsgSeverity    => warning);        
    end if;
    ViolationCLKAB := Tviol_CLKB_CLKA_all or Tviol_CLKA_CLKB_all or Tviol_CLKB_CLKA_read_first or Tviol_CLKA_CLKB_read_first;        



    WR_A_LATER := false;
    WR_B_LATER := false;

    if (GSR_CLKA_dly = '1') then
      DOA_zd  := INIT_A_reg ( 3 downto 0);

    elsif (GSR_CLKA_dly = '0') then
      if (ena_dly_sampled = '1') then
        if (rising_edge(CLKA_dly)) then
          if (wea_dly_sampled = '1') then
            case wr_mode_a is
              when 0 =>
                DOA_zd  := DIA_dly;

                if (ViolationCLKAB = 'X') then
                  if (web_dly_sampled /= '0') then
                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Write_A_Write_B,
                         EntityName => "/X_RAMB16_S4_S9",
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      MEM(ADDRESS_A/(length_a/length_b))(DOB_OV_MSB downto DOB_OV_LSB) := (others => 'X');
                      DOA_zd := (others => 'X');
                      if (wr_mode_b /= 2 ) then
                        DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)    := (others => 'X');
                      end if;
                    end if;
                  else

                    if ((collision_type = 1) or (collision_type = 3)) then                
                      Memory_Collision_Msg
                        (collision_type => Read_B_Write_A,
                         EntityName => "/X_RAMB16_S4_S9",
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a))):= DIA_dly;
                    if ((collision_type = 2) or (collision_type = 3)) then                
                      DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)                      := (others => 'X');
                    end if;
                  end if;
                else

                  if (VALID_ADDRA) then
                    MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a))):= DIA_dly;
                  end if;
                end if;
              when 1 =>

                if (VALID_ADDRA) then
                  DOA_zd  := MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a)));
                  WR_A_LATER := true;
                end if;

                if (ViolationCLKAB = 'X') then

                  if (web_dly_sampled /= '0') then
                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Write_A_Write_B,
                         EntityName => "/X_RAMB16_S4_S9",
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      MEM(ADDRESS_A/(length_a/length_b))(DOB_OV_MSB downto DOB_OV_LSB) := (others => 'X');
                      DOA_zd := (others => 'X');
                      if (wr_mode_b /= 2 ) then
                        DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)    := (others => 'X');
                      end if;
                    end if;
                  else

                    if ((collision_type = 1) or (collision_type = 3)) then                
                      Memory_Collision_Msg
                        (collision_type => Read_B_Write_A,
                         EntityName => "/X_RAMB16_S4_S9",
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a))):= DIA_dly;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)                      := (others => 'X');
                    end if;
                  end if;
                end if;
              when 2 =>
                if (ViolationCLKAB = 'X') then

                  if (web_dly_sampled /= '0') then
                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Write_A_Write_B,
                         EntityName => "/X_RAMB16_S4_S9",
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      MEM(ADDRESS_A/(length_a/length_b))(DOB_OV_MSB downto DOB_OV_LSB) := (others => 'X');
                      if (wr_mode_b /= 2 ) then

                        DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)    := (others => 'X');
                      end if;
                    end if;
                  else

                    if ((collision_type = 1) or (collision_type = 3)) then                
                      Memory_Collision_Msg
                        (collision_type => Read_B_Write_A,
                         EntityName => "/X_RAMB16_S4_S9",
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then                
                      DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)                      := (others => 'X');
                    end if;
                    MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a))):= DIA_dly;
                  end if;
                else

                  if (VALID_ADDRA) then
                    MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a))):= DIA_dly;
                  end if;
                end if;
              when others => null;
            end case;
          else

            if (VALID_ADDRA) then
                  DOA_zd  := MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a)));
            end if;
            if (ViolationCLKAB = 'X') then

              if ((collision_type = 1) or (collision_type = 3)) then                
                Memory_Collision_Msg
                  (collision_type => Read_A_Write_B,
                   EntityName => "/X_RAMB16_S4_S9",
                   address_a => addra_dly_sampled,
                   address_b => addrb_dly_sampled
                   );
              end if;
              if ((collision_type = 2) or (collision_type = 3)) then                
                DOA_zd := (others => 'X');
              end if;
            end if;
          end if;
          if (ssra_dly_sampled = '1') then

            DOA_zd  := SRVAL_A_reg(3 downto 0);
          end if;
        end if;
      end if;
    end if;

    if (GSR_CLKB_dly = '1') then

      DOB_zd  := INIT_B_reg(7 downto 0);
      DOPB_zd := INIT_B_reg(8 downto 8);
    elsif (GSR_CLKB_dly = '0') then
      if (enb_dly_sampled = '1') then
        if (rising_edge(CLKB_dly)) then
          if (web_dly_sampled = '1') then
            case wr_mode_b is
              when 0 =>

                DOB_zd  := DIB_dly;
                DOPB_zd := DIPB_dly;
                if (VALID_ADDRB) then
                  MEM(ADDRESS_B)     := DIB_dly;
                  MEMP(ADDRESS_B) := DIPB_dly;
                end if;
                if (ViolationCLKAB = 'X') then
                  if (wea_dly_sampled /= '0') then

                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Write_A_Write_B,
                         EntityName => "X_RAMB16_S4_S9",
                         InstanceName => x_ramb16_s4_s9'path_name,
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      MEM(ADDRESS_B)(DOB_OV_MSB downto DOB_OV_LSB) := (others => 'X');

                      DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)    := (others => 'X');
                      if (wr_mode_a /= 2 ) then

                        DOA_zd := (others => 'X');
                      end if;
                    end if;
                  else
                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Read_A_Write_B,
                         EntityName => "X_RAMB16_S4_S9",
                         InstanceName => x_ramb16_s4_s9'path_name,
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      DOA_zd := (others => 'X');
                    end if;
                  end if;
                end if;
              when 1 =>

                if (VALID_ADDRB) then
                  DOB_zd  := MEM(ADDRESS_B);
                  DOPB_zd := MEMP(ADDRESS_B);
                  WR_B_LATER := true;
                  MEM(ADDRESS_B)     := DIB_dly ;
                  MEMP(ADDRESS_B) := DIPB_dly;
                end if;
                if (ViolationCLKAB = 'X') then
                  if (wea_dly_sampled /= '0') then

                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Write_A_Write_B,
                         EntityName => "X_RAMB16_S4_S9",
                         InstanceName => x_ramb16_s4_s9'path_name,
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      MEM(ADDRESS_B)(DOB_OV_MSB downto DOB_OV_LSB) := (others => 'X');

                      DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)    := (others => 'X');
                      if (wr_mode_a /= 2 ) then
                        DOA_zd := (others => 'X');
                      end if;
                    end if;
                  else

                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Read_A_Write_B,
                         EntityName => "X_RAMB16_S4_S9",
                         InstanceName => x_ramb16_s4_s9'path_name,
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      DOA_zd := (others => 'X');
                    end if;
                  end if;
                end if;
              when 2 =>
                if (VALID_ADDRB) then
                  MEM(ADDRESS_B) := DIB_dly;
                  MEMP(ADDRESS_B) := DIPB_dly;
                end if;
                if (ViolationCLKAB = 'X') then
                  if (wea_dly_sampled /= '0') then

                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Write_A_Write_B,
                         EntityName => "X_RAMB16_S4_S9",
                         InstanceName => x_ramb16_s4_s9'path_name,
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      MEM(ADDRESS_B)(DOB_OV_MSB downto DOB_OV_LSB) := (others => 'X');
                      if (wr_mode_a /= 2 ) then

                        DOA_zd := (others => 'X');
                      end if;
                    end if;
                  else

                    if ((collision_type = 1) or (collision_type = 3)) then
                      Memory_Collision_Msg
                        (collision_type => Read_A_Write_B,
                         EntityName => "X_RAMB16_S4_S9",
                         InstanceName => x_ramb16_s4_s9'path_name,
                         address_a => addra_dly_sampled,
                         address_b => addrb_dly_sampled
                         );
                    end if;
                    if ((collision_type = 2) or (collision_type = 3)) then
                      DOA_zd := (others => 'X');
                    end if;
                  end if;
                end if;
              when others => null;
            end case;
          else

            if (VALID_ADDRB) then
              DOB_zd  := MEM(ADDRESS_B);
              DOPB_zd := MEMP(ADDRESS_B);
            end if;
            if (ViolationCLKAB = 'X') then

              if ((collision_type = 1) or (collision_type = 3)) then                
                Memory_Collision_Msg
                  (collision_type => Read_B_Write_A,
                   EntityName => "X_RAMB16_S4_S9",
                   InstanceName => x_ramb16_s4_s9'path_name,
                   address_a => addra_dly_sampled,
                   address_b => addrb_dly_sampled
                   );
              end if;
              if ((collision_type = 2) or (collision_type = 3)) then                
                DOB_zd (DOB_OV_MSB downto DOB_OV_LSB)    := (others => 'X');
              end if;
            end if;
          end if;
          if (ssrb_dly_sampled = '1') then

            DOB_zd  := SRVAL_B_reg(7 downto 0);
            DOPB_zd := SRVAL_B_reg(8 downto 8);
          end if;
        end if;
      end if;
    end if;

    if ((WR_A_LATER = true ) and (VALID_ADDRA)) then
      MEM(ADDRESS_A/(length_a/length_b))(((((address_a)rem(length_a/length_b))*(width_a)) + (width_a - 1)) downto (((address_a)rem(length_a/length_b))*(width_a))):= DIA_dly;                    
    end if;

    if ((WR_B_LATER = true ) and (VALID_ADDRB)) then
        MEM(ADDRESS_B) := DIB_dly;
        MEMP(ADDRESS_B) := DIPB_dly;
    end if;

    DOA_zd(0)  := ViolationA xor DOA_zd(0);
    DOA_zd(1)  := ViolationA xor DOA_zd(1);
    DOA_zd(2)  := ViolationA xor DOA_zd(2);
    DOA_zd(3)  := ViolationA xor DOA_zd(3);
    DOB_zd(0)  := ViolationB xor DOB_zd(0);
    DOB_zd(1)  := ViolationB xor DOB_zd(1);
    DOB_zd(2)  := ViolationB xor DOB_zd(2);
    DOB_zd(3)  := ViolationB xor DOB_zd(3);
    DOB_zd(4)  := ViolationB xor DOB_zd(4);
    DOB_zd(5)  := ViolationB xor DOB_zd(5);
    DOB_zd(6)  := ViolationB xor DOB_zd(6);
    DOB_zd(7)  := ViolationB xor DOB_zd(7);
    DOPB_zd(0) := ViolationB xor DOPB_zd(0);

    VitalPathDelay01 (
      OutSignal     => DOA(0),
      GlitchData    => DOA_GlitchData0,
      OutSignalName => "DOA(0)",
      OutTemp       => DOA_zd(0),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(0), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(0), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(1),
      GlitchData    => DOA_GlitchData1,
      OutSignalName => "DOA(1)",
      OutTemp       => DOA_zd(1),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(1), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(1), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(2),
      GlitchData    => DOA_GlitchData2,
      OutSignalName => "DOA(2)",
      OutTemp       => DOA_zd(2),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(2), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(2), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(3),
      GlitchData    => DOA_GlitchData3,
      OutSignalName => "DOA(3)",
      OutTemp       => DOA_zd(3),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(3), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(3), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(0),
      GlitchData    => DOB_GlitchData0,
      OutSignalName => "DOB(0)",
      OutTemp       => DOB_zd(0),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(0), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(0), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(1),
      GlitchData    => DOB_GlitchData1,
      OutSignalName => "DOB(1)",
      OutTemp       => DOB_zd(1),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(1), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(1), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(2),
      GlitchData    => DOB_GlitchData2,
      OutSignalName => "DOB(2)",
      OutTemp       => DOB_zd(2),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(2), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(2), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(3),
      GlitchData    => DOB_GlitchData3,
      OutSignalName => "DOB(3)",
      OutTemp       => DOB_zd(3),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(3), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(3), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(4),
      GlitchData    => DOB_GlitchData4,
      OutSignalName => "DOB(4)",
      OutTemp       => DOB_zd(4),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(4), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(4), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(5),
      GlitchData    => DOB_GlitchData5,
      OutSignalName => "DOB(5)",
      OutTemp       => DOB_zd(5),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(5), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(5), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(6),
      GlitchData    => DOB_GlitchData6,
      OutSignalName => "DOB(6)",
      OutTemp       => DOB_zd(6),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(6), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(6), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOB(7),
      GlitchData    => DOB_GlitchData7,
      OutSignalName => "DOB(7)",
      OutTemp       => DOB_zd(7),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOB(7), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(7), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOPB(0),
      GlitchData    => DOPB_GlitchData0,
      OutSignalName => "DOPB(0)",
      OutTemp       => DOPB_zd(0),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOPB(0), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(0), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    wait on ADDRA_dly, ADDRB_dly, CLKA_dly, CLKB_dly, DIA_dly, DIB_dly, DIPB_dly, ENA_dly, ENB_dly, GSR_ipd, GSR_CLKA_dly, GSR_CLKB_dly, SSRA_dly, SSRB_dly, WEA_dly, WEB_dly;
  end process VITALBehavior;
end X_RAMB16_S4_S9_V;
