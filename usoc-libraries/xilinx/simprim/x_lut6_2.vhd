-- $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/vhdsclibs/data/simprims/rainier/VITAL/Attic/x_lut6_2.vhd,v 1.1 2006/08/24 00:13:50 yanx Exp $
-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  6-input Look-Up-Table with Two General Outputs
-- /___/   /\     Filename : X_LUT6_2.vhd
-- \   \  /  \    Timestamp : 
--  \___\/\___\
--
-- Revision:
--    08/09/06 - Initial version.
-- End Revision

----- CELL X_LUT6_2 -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.VPACKAGE.all;
use simprim.Vcomponents.all;

entity X_LUT6_2 is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;
   LOC            : string  := "UNPLACED";

      tipd_I0 : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_I1 : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_I2 : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_I3 : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_I4 : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_I5 : VitalDelayType01 := (0.000 ns, 0.000 ns);

      tpd_I0_O5 : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tpd_I1_O5 : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tpd_I2_O5 : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tpd_I3_O5 : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tpd_I4_O5 : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tpd_I5_O5 : VitalDelayType01 := (0.000 ns, 0.000 ns);

      tpd_I0_O6 : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tpd_I1_O6 : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tpd_I2_O6 : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tpd_I3_O6 : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tpd_I4_O6 : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tpd_I5_O6 : VitalDelayType01 := (0.000 ns, 0.000 ns);

--    INIT : bit_vector := X"0000000000000000"
    INIT : bit_vector := X"5555555552222222"
    );

  port(
    O5 : out std_ulogic;
    O6 : out std_ulogic;

    I0 : in std_ulogic;
    I1 : in std_ulogic;
    I2 : in std_ulogic;
    I3 : in std_ulogic;
    I4 : in std_ulogic;
    I5 : in std_ulogic
    );

  attribute VITAL_LEVEL0 of
    X_LUT6_2 : entity is true;
end X_LUT6_2;

architecture X_LUT6_2_V of X_LUT6_2 is

function lut6_mux8 (d :  std_logic_vector(7 downto 0); s : std_logic_vector(2 downto 0)) 
                    return std_logic is

       variable lut6_mux8_o : std_logic;
       function lut4_mux4f (df :  std_logic_vector(3 downto 0); sf : std_logic_vector(1 downto 0) )
                    return std_logic is

            variable lut4_mux4_f : std_logic;
       begin

            if (((sf(1) xor sf(0)) = '1')  or  ((sf(1) xor sf(0)) = '0')) then
                lut4_mux4_f := df(SLV_TO_INT(sf));
            elsif ((df(0) xor df(1)) = '0' and (df(2) xor df(3)) = '0'
                    and (df(0) xor df(2)) = '0') then
                lut4_mux4_f := df(0);
            elsif ((sf(1) = '0') and (df(0) = df(1))) then
                lut4_mux4_f := df(0);
            elsif ((sf(1) = '1') and (df(2) = df(3))) then
                lut4_mux4_f := df(2);
            elsif ((sf(0) = '0') and (df(0) = df(2))) then
                lut4_mux4_f := df(0);
            elsif ((sf(0) = '1') and (df(1) = df(3))) then
                lut4_mux4_f := df(1);
            else
                lut4_mux4_f := 'X';
           end if;

           return (lut4_mux4_f);
    
       end function lut4_mux4f;
  begin
       
    if ((s(2) xor s(1) xor s(0)) = '1' or (s(2) xor s(1) xor s(0)) = '0') then
       lut6_mux8_o := d(SLV_TO_INT(s));
    else
       lut6_mux8_o := lut4_mux4f(('0' & '0' & lut4_mux4f(d(7 downto 4), s(1 downto 0)) &
            lut4_mux4f(d(3 downto 0), s(1 downto 0))), ('0' & s(2)));
    end if;

      return (lut6_mux8_o);
     
  end function lut6_mux8;

function lut4_mux4 (d :  std_logic_vector(3 downto 0); s : std_logic_vector(1 downto 0) )
                    return std_logic is

       variable lut4_mux4_o : std_logic;
  begin
       
       if (((s(1) xor s(0)) = '1')  or  ((s(1) xor s(0)) = '0')) then
           lut4_mux4_o := d(SLV_TO_INT(s));
       elsif ((d(0) xor d(1)) = '0' and (d(2) xor d(3)) = '0'
                    and (d(0) xor d(2)) = '0') then
           lut4_mux4_o := d(0);
       elsif ((s(1) = '0') and (d(0) = d(1))) then
           lut4_mux4_o := d(0);
       elsif ((s(1) = '1') and (d(2) = d(3))) then
           lut4_mux4_o := d(2);
       elsif ((s(0) = '0') and (d(0) = d(2))) then
           lut4_mux4_o := d(0);
       elsif ((s(0) = '1') and (d(1) = d(3))) then
           lut4_mux4_o := d(1);
       else
           lut4_mux4_o := 'X';
      end if;

      return (lut4_mux4_o);
     
  end function lut4_mux4;

  constant INIT_reg : std_logic_vector(63 downto 0) := To_StdLogicVector(INIT);    
  constant init_l : std_logic_vector(31 downto 0) := INIT_reg(31 downto 0);    
  constant init_h : std_logic_vector(31 downto 0) := INIT_reg(63 downto 32);    
  signal I0_ipd : std_ulogic := 'X';
  signal I1_ipd : std_ulogic := 'X';
  signal I2_ipd : std_ulogic := 'X';
  signal I3_ipd : std_ulogic := 'X';
  signal I4_ipd : std_ulogic := 'X';
  signal I5_ipd : std_ulogic := 'X';
  signal O5_zd     : std_ulogic;
  signal O6_zd     : std_ulogic;

begin

  WireDelay       : block
  begin
    VitalWireDelay (I0_ipd, I0, tipd_I0);
    VitalWireDelay (I1_ipd, I1, tipd_I1);
    VitalWireDelay (I2_ipd, I2, tipd_I2);
    VitalWireDelay (I3_ipd, I3, tipd_I3);
    VitalWireDelay (I4_ipd, I4, tipd_I4);
    VitalWireDelay (I5_ipd, I5, tipd_I5);
  end block;

  lut_p   : process (I0, I1, I2, I3, I4, I5)
    variable I_reg : std_logic_vector(4 downto 0);
    variable o_l : std_ulogic;
    variable o_h : std_ulogic;
  begin

    I_reg := TO_STDLOGICVECTOR(I4 & I3 &  I2 & I1 & I0);

    if ((I4 xor I3 xor I2 xor I1 xor I0) = '1' or (I4 xor I3 xor I2 xor I1 xor I0) = '0') then
       o_l := init_l(SLV_TO_INT(I_reg));
       o_h := init_h(SLV_TO_INT(I_reg));
    else 
       o_l :=  lut4_mux4 ( 
           (lut6_mux8 ( init_l(31 downto 24), I_reg(2 downto 0)) &
            lut6_mux8 ( init_l(23 downto 16), I_reg(2 downto 0)) &
            lut6_mux8 ( init_l(15 downto 8), I_reg(2 downto 0)) &
            lut6_mux8 ( init_l(7 downto 0), I_reg(2 downto 0))),
                        I_reg(4 downto 3));

       o_h :=  lut4_mux4 (
           (lut6_mux8 ( init_h(31 downto 24), I_reg(2 downto 0)) &
            lut6_mux8 ( init_h(23 downto 16), I_reg(2 downto 0)) &
            lut6_mux8 ( init_h(15 downto 8), I_reg(2 downto 0)) &
            lut6_mux8 ( init_h(7 downto 0), I_reg(2 downto 0))),
                        I_reg(4 downto 3));
 
    end if;

    O5_zd <= o_l;
    if (I5 = '1') then
      O6_zd <= o_h;
    elsif (I5 = '0') then
      O6_zd <= O_l;
    else 
      if (o_h = '0' and  o_l = '0') then
         O6_zd <= '0';
      elsif (o_h = '1' and o_l = '1') then
         O6_zd <= '1';
      else
         O6_zd <= 'X';
      end if;
   end if;

  end process;


  VITALTIING           : process (I0_ipd, I1_ipd, I2_ipd, I3_ipd, I4_ipd, I5_ipd, O5_zd, O6_zd)
    variable O5_GlitchData : VitalGlitchDataType;
    variable O6_GlitchData : VitalGlitchDataType;
  begin

    VitalPathDelay01 (
      OutSignal           => O5,
      GlitchData          => O5_GlitchData,
      OutSignalName       => "O5",
      OutTemp             => O5_zd,
      Paths               => (0 => (I0_ipd'last_event, tpd_I0_O5, true),
                              1 => (I1_ipd'last_event, tpd_I1_O5, true),
                              2 => (I2_ipd'last_event, tpd_I2_O5, true),
                              3 => (I3_ipd'last_event, tpd_I3_O5, true),
                              4 => (I4_ipd'last_event, tpd_I4_O5, true),
                              5 => (I5_ipd'last_event, tpd_I5_O5, true)),
      Mode                => VitalTransport,
      Xon                 => Xon,
      MsgOn               => MsgOn,
      MsgSeverity         => warning);

    VitalPathDelay01 (
      OutSignal           => O6,
      GlitchData          => O6_GlitchData,
      OutSignalName       => "O6",
      OutTemp             => O6_zd,
      Paths               => (0 => (I0_ipd'last_event, tpd_I0_O6, true),
                              1 => (I1_ipd'last_event, tpd_I1_O6, true),
                              2 => (I2_ipd'last_event, tpd_I2_O6, true),
                              3 => (I3_ipd'last_event, tpd_I3_O6, true),
                              4 => (I4_ipd'last_event, tpd_I4_O6, true),
                              5 => (I5_ipd'last_event, tpd_I5_O6, true)),
      Mode                => VitalTransport,
      Xon                 => Xon,
      MsgOn               => MsgOn,
      MsgSeverity         => warning);
  end process;

end X_LUT6_2_V;
-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                 Phase Lock Loop Clock 
-- /___/   /\     Filename : X_PLL_ADV.vhd
-- \   \  /  \    Timestamp : Fri Mar 26 08:18:19 PST 2004
--  \___\/\___\
-- Revision:
--    07/11/05 - Initial version.
--    10/14/05 - Add REL pin.
--    11/16/05 - Add PMCD related generics.
--    12/02/05 - Change parameter default values.
--    01/03/06 - Change RST_DEASSER_CLK value to CLKIN1 and CLKFB (BT#735).
--    01/13/06 - Add DRP and PMCD logic. (CR 222944)
--    02/17/06 - Add support for -360.0 to +360.0 phase shift. (CR225765)
--    03/17/96 - Reduce lock time by MD (CR 224502).
--    07/19/06 - Remove first 4 clkvco_lk cycle generation (CR234931).
--    08/08/06 - Fix real2int when less than 1 (CR 236219).
--    08/23/06 - Use clkout_en_tmp to generate clkout_en0. (CR422250)
--    09/19/06 - Fix real2int with time method  and md_product update (CR 424286).
--    09/27/06 - Add error check for RESET_ON_LOSS_OF_LOCK (CR 425255)
--             - Check rst when generating clkfb_tst (CR 425185).
--    11/10/06 - Keep 3 digits for real in duty cycle check function. (CR 428703).
--    01/12/07 - Add CLKOUT_DESKEW_ADJUST parameters (CR 432189).
--    04/09/07 - Enhance error message for RESET_ON_LOSS_OF_LOCK (CR 437405).
--    05/22/07 - Add setup check for REL (438781).
--    06/8/07  - Generate clkfb_tst when GSR=0; Add clkx_edgei after DRP write(CR441293).
--             - Chang VCOCLK_FREQ_MAX and VCOCLK_FREQ_MIN to generic for simprim (BT1485).
--    06/20/07 - Add CLKFBIN pulse width check (BT1476).
--    06/28/07 - Initial DRP memory (CR 434042), Error message improve (CR 438250).
--    08/02/07 - Remove numbers from CLKOUT DESKEW_ADJUST check for unisim (CR443161).
--    08/21/07 - Not check CLKIN period when PMCD mode set (445101).
--               Fix DUTY_CYCLE_MAX formula in case of divider larger than O_MAX_HT_LT (CR445945).
--               Add warning if phase shift over pll ability (63 vco) (CR446037).
--    09/20/07 - Seperate fb_delay and delay_edge to handle 0 fb_delay (CR448938)
--    10/23/07 - Add warnings to initial phase shift calculation (CR448965)
--    11/01/07 - Remove zero check for CLKOUTx dly register bit15-8 (CR434042)
--    01/18/08 - Generate vco clk with period_vco/2 as high time and period_vco - high time as 
--               low time (CR458475).
--    03/06/08 - Change max vco freq from 1100Mhz to 1440 Mhz (CR469212).
--    03/11/08 - Not check clkinsel_in change with RST=0 if clkinsel_in change from X  to
--               handle the time 0 X value caused by sdf delay. (CR469589).
--    03/27/08 - Add period_vco_cmp_cnt and period_vco_md_rm to spread acuminated rounded error
--               of period_vco/2 during M*D CLKIN cycles instead of last cycle. (CR470494).
--    06/06/08 - Change default values of CLKIN_FREQ_MAX, CLKIN_FREQ_MIN,
--               CLKPFD_FREQ_MIN and REF_CLK_JITTER_MAX (CR469212).
--    06/23/08 - Assign clkind_ht with clkind_hti when DRP write. 
--               Same for clkind_lt. (CR475182)
--    07/10/08 - Calculate clklt first instead of clkht in clkout_hl_para_drp (CR476560).
-- End Revision

----- CELL X_PLL_ADV -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library STD;
use STD.TEXTIO.all;
library IEEE;
use IEEE.VITAL_Timing.all;
library simprim;
use simprim.VPACKAGE.all;
use simprim.VCOMPONENTS.all;

entity X_PLL_ADV is
generic (
-- begining timing generic
        TimingChecksOn : boolean := TRUE;
        InstancePath   : string  := "*";
        Xon            : boolean := TRUE;
        MsgOn          : boolean := FALSE;
        LOC            : string  := "UNPLACED";
        VCOCLK_FREQ_MAX : real := 1440.0;
        VCOCLK_FREQ_MIN : real := 400.0;

        tperiod_CLKIN1_posedge : VitalDelayType := 0 ps;
        tperiod_CLKIN2_posedge : VitalDelayType := 0 ps;

        tipd_CLKFBIN : VitalDelayType01 :=  (0 ps, 0 ps);
        tipd_CLKIN1 : VitalDelayType01 :=  (0 ps, 0 ps);
        tipd_CLKIN2 : VitalDelayType01 :=  (0 ps, 0 ps);
        tipd_CLKINSEL : VitalDelayType01 :=  (0 ps, 0 ps);
        tipd_DADDR : VitalDelayArrayType01 (4 downto 0) := (others => (0 ps, 0 ps));
        tipd_DCLK : VitalDelayType01 :=  (0 ps, 0 ps);
        tipd_DEN : VitalDelayType01 :=  (0 ps, 0 ps);
        tipd_DI : VitalDelayArrayType01 (15 downto 0) := (others => (0 ps, 0 ps));
        tipd_DWE : VitalDelayType01 :=  (0 ps, 0 ps);
        tipd_REL : VitalDelayType01 :=  (0 ps, 0 ps);
        tipd_RST : VitalDelayType01 :=  (0 ps, 0 ps);

        tpd_CLKIN1_LOCKED : VitalDelayType01 := (0.100 ns, 0.100 ns);
        tpd_CLKIN2_LOCKED : VitalDelayType01 := (0.100 ns, 0.100 ns);
        tpd_DCLK_DO : VitalDelayArrayType01(15 downto 0) := (others => (0 ps, 0 ps));
        tpd_DCLK_DRDY : VitalDelayType01 := (0 ps, 0 ps);

        thold_DADDR_DCLK_negedge_posedge : VitalDelayArrayType(4 downto 0) := (others => 0 ps);
        thold_DADDR_DCLK_posedge_posedge : VitalDelayArrayType(4 downto 0) := (others => 0 ps);
        thold_DEN_DCLK_negedge_posedge : VitalDelayType := 0 ps;
        thold_DEN_DCLK_posedge_posedge : VitalDelayType := 0 ps;
        thold_DI_DCLK_negedge_posedge : VitalDelayArrayType(15 downto 0) := (others => 0 ps);
        thold_DI_DCLK_posedge_posedge : VitalDelayArrayType(15 downto 0) := (others => 0 ps);
        thold_DWE_DCLK_negedge_posedge : VitalDelayType := 0 ps;
        thold_DWE_DCLK_posedge_posedge : VitalDelayType := 0 ps;
        thold_REL_CLKIN1_negedge_negedge : VitalDelayType := 0 ps;
        thold_REL_CLKIN1_posedge_negedge : VitalDelayType := 0 ps;
        tsetup_DADDR_DCLK_negedge_posedge : VitalDelayArrayType(4 downto 0) := (others => 0 ps);
        tsetup_DADDR_DCLK_posedge_posedge : VitalDelayArrayType(4 downto 0) := (others => 0 ps);
        tsetup_DEN_DCLK_negedge_posedge : VitalDelayType := 0 ps;
        tsetup_DEN_DCLK_posedge_posedge : VitalDelayType := 0 ps;
        tsetup_DI_DCLK_negedge_posedge : VitalDelayArrayType(15 downto 0) := (others => 0 ps);
        tsetup_DI_DCLK_posedge_posedge : VitalDelayArrayType(15 downto 0) := (others => 0 ps);
        tsetup_DWE_DCLK_negedge_posedge : VitalDelayType := 0 ps;
        tsetup_DWE_DCLK_posedge_posedge : VitalDelayType := 0 ps;
        tsetup_REL_CLKIN1_negedge_negedge : VitalDelayType := 0 ps;
        tsetup_REL_CLKIN1_posedge_negedge : VitalDelayType := 0 ps;

        ticd_CLKIN1 : VitalDelayType := 0 ps;
        ticd_DCLK : VitalDelayType := 0 ps;

        tisd_DADDR_DCLK : VitalDelayArrayType(4 downto 0) := (others => 0 ps);
        tisd_DEN_DCLK : VitalDelayType := 0 ps;
        tisd_DI_DCLK : VitalDelayArrayType(15 downto 0) := (others => 0 ps);
        tisd_DWE_DCLK : VitalDelayType := 0 ps;
        tisd_REL_CLKIN1 : VitalDelayType := 0 ps;

        tpw_CLKIN1_negedge : VitalDelayType := 0.000 ns;
        tpw_CLKIN1_posedge : VitalDelayType := 0.000 ns;
        tpw_CLKIN2_negedge : VitalDelayType := 0.000 ns;
        tpw_CLKIN2_posedge : VitalDelayType := 0.000 ns;
        tpw_CLKFBIN_negedge : VitalDelayType := 0.000 ns;
        tpw_CLKFBIN_posedge : VitalDelayType := 0.000 ns;
        tpw_RST_posedge : VitalDelayType := 0.000 ns;
        

-- end_timing generic

                BANDWIDTH : string := "OPTIMIZED";
                CLKFBOUT_DESKEW_ADJUST : string := "NONE";
                CLKFBOUT_MULT : integer := 1;
                CLKFBOUT_PHASE : real := 0.0;
                CLKIN1_PERIOD : real := 0.000;
                CLKIN2_PERIOD : real := 0.000;
                CLKOUT0_DESKEW_ADJUST : string := "NONE";
                CLKOUT0_DIVIDE : integer := 1;
                CLKOUT0_DUTY_CYCLE : real := 0.5;
                CLKOUT0_PHASE : real := 0.0;
                CLKOUT1_DESKEW_ADJUST : string := "NONE";
                CLKOUT1_DIVIDE : integer := 1;
                CLKOUT1_DUTY_CYCLE : real := 0.5;
                CLKOUT1_PHASE : real := 0.0;
                CLKOUT2_DESKEW_ADJUST : string := "NONE";
                CLKOUT2_DIVIDE : integer := 1;
                CLKOUT2_DUTY_CYCLE : real := 0.5;
                CLKOUT2_PHASE : real := 0.0;
                CLKOUT3_DESKEW_ADJUST : string := "NONE";
                CLKOUT3_DIVIDE : integer := 1;
                CLKOUT3_DUTY_CYCLE : real := 0.5;
                CLKOUT3_PHASE : real := 0.0;
                CLKOUT4_DESKEW_ADJUST : string := "NONE";
                CLKOUT4_DIVIDE : integer := 1;
                CLKOUT4_DUTY_CYCLE : real := 0.5;
                CLKOUT4_PHASE : real := 0.0;
                CLKOUT5_DESKEW_ADJUST : string := "NONE";
                CLKOUT5_DIVIDE : integer := 1;
                CLKOUT5_DUTY_CYCLE : real := 0.5;
                CLKOUT5_PHASE : real := 0.0;
                COMPENSATION : string := "SYSTEM_SYNCHRONOUS";
                DIVCLK_DIVIDE : integer := 1;
                EN_REL : boolean := FALSE;
                PLL_PMCD_MODE : boolean := FALSE;
                REF_JITTER : real := 0.100;
                RESET_ON_LOSS_OF_LOCK : boolean := FALSE;
                RST_DEASSERT_CLK : string := "CLKIN1"

  );
port (
                CLKFBDCM : out std_ulogic := '0';
                CLKFBOUT : out std_ulogic := '0';
                CLKOUT0 : out std_ulogic := '0';
                CLKOUT1 : out std_ulogic := '0';
                CLKOUT2 : out std_ulogic := '0';
                CLKOUT3 : out std_ulogic := '0';
                CLKOUT4 : out std_ulogic := '0';
                CLKOUT5 : out std_ulogic := '0';
                CLKOUTDCM0 : out std_ulogic := '0';
                CLKOUTDCM1 : out std_ulogic := '0';
                CLKOUTDCM2 : out std_ulogic := '0';
                CLKOUTDCM3 : out std_ulogic := '0';
                CLKOUTDCM4 : out std_ulogic := '0';
                CLKOUTDCM5 : out std_ulogic := '0';
                DO : out std_logic_vector(15 downto 0);
                DRDY : out std_ulogic := '0';
                LOCKED : out std_ulogic := '0';
                CLKFBIN : in std_ulogic;
                CLKIN1 : in std_ulogic;
                CLKIN2 : in std_ulogic;
                CLKINSEL : in std_ulogic;
                DADDR : in std_logic_vector(4 downto 0);
                DCLK : in std_ulogic;
                DEN : in std_ulogic;
                DI : in std_logic_vector(15 downto 0);
                DWE : in std_ulogic;
                REL : in std_ulogic;
                RST : in std_ulogic
     );
end X_PLL_ADV;


-- Architecture body --

architecture X_PLL_ADV_V of X_PLL_ADV is

  ---------------------------------------------------------------------------
  -- Function SLV_TO_INT converts a std_logic_vector TO INTEGER
  ---------------------------------------------------------------------------
  function SLV_TO_INT(SLV: in std_logic_vector
                      ) return integer is

    variable int : integer;
  begin
    int := 0;
    for i in SLV'high downto SLV'low loop
      int := int * 2;
      if SLV(i) = '1' then
        int := int + 1;
      end if;
    end loop;
    return int;
  end;

  ---------------------------------------------------------------------------
  -- Function ADDR_IS_VALID checks for the validity of the argument. A FALSE
  -- is returned if any argument bit is other than a '0' or '1'.
  ---------------------------------------------------------------------------
  function ADDR_IS_VALID (
    SLV : in std_logic_vector
    ) return boolean is

    variable IS_VALID : boolean := TRUE;

  begin
    for I in SLV'high downto SLV'low loop
      if (SLV(I) /= '0' AND SLV(I) /= '1') then
        IS_VALID := FALSE;
      end if;
    end loop;
    return IS_VALID;
  end ADDR_IS_VALID;

  function int2real( int_in : in integer) return real is
    variable conline1 : line;
    variable rl_value : real;
    variable tmpv1 : real;
    variable tmpv2 : real := 1.0;
    variable tmpi : integer;
  begin
    tmpi := int_in;
    write (conline1, tmpi);
    write (conline1, string'(".0 "));
    write (conline1, tmpv2);
    read (conline1, tmpv1);
    rl_value := tmpv1;
    return rl_value;
    DEALLOCATE(conline1);
  end int2real;

  function real2int( real_in : in real) return integer is
    variable int_value : integer;
    variable int_value1 : integer;
    variable tmps : time := 1 ps;
    variable tmps1 : real;
    
  begin
    if (real_in < 1.00000 and real_in > -1.00000) then
        int_value1 := 0;
    else
      tmps := real_in * 1 ns;
      int_value := tmps / 1 ns;
      tmps1 := int2real (int_value);
      if ( tmps1 > real_in) then
        int_value1 := int_value - 1 ;
      else
        int_value1 := int_value;
      end if;
    end if;
    return int_value1;
  end real2int;

  
  procedure clkout_dly_cal (clkout_dly : out std_logic_vector(5 downto 0);
                          clkpm_sel : out std_logic_vector(2 downto 0);
                          clkdiv : in integer;
                          clk_ps : in real;
                          clk_ps_name : in string )
  is
    variable clk_dly_rl : real;
    variable clk_dly_rem : real;
    variable clk_dly_int : integer;
    variable clk_dly_int_rl : real;
    variable clkdiv_real : real;
    variable clkpm_sel_rl : real;
    variable clk_ps_rl : real;
    variable  Message : line;
  begin

     clkdiv_real := int2real(clkdiv);
     if (clk_ps < 0.0) then
        clk_dly_rl := (360.0 + clk_ps) * clkdiv_real / 360.0;
     else
        clk_dly_rl := clk_ps * clkdiv_real / 360.0;
     end if;
     clk_dly_int := real2int (clk_dly_rl);

     if (clk_dly_int > 63) then
        Write ( Message, string'(" Warning : Attribute "));
        Write ( Message, clk_ps_name );
        Write ( Message, string'(" of X_PLL_ADV is set to "));
        Write ( Message, clk_ps);
        Write ( Message, string'(". Required phase shifting can not be reached since it is over the maximum phase shifting ability of X_PLL_ADV"));
        Write ( Message, '.' & LF );
        assert false report Message.all severity error;
        DEALLOCATE (Message);
        clkout_dly := "111111";
     else
       clkout_dly := STD_LOGIC_VECTOR(TO_UNSIGNED(clk_dly_int, 6));
     end if;

     clk_dly_int_rl := int2real (clk_dly_int);
     clk_dly_rem := clk_dly_rl - clk_dly_int_rl;

    if (clk_dly_rem < 0.125) then
        clkpm_sel :=  "000";
        clkpm_sel_rl := 0.0;
    elsif (clk_dly_rem >=  0.125 and  clk_dly_rem < 0.25) then
        clkpm_sel(2 downto 0) :=  "001";
        clkpm_sel_rl := 1.0;
    elsif (clk_dly_rem >=  0.25 and clk_dly_rem < 0.375) then
        clkpm_sel :=  "010";
        clkpm_sel_rl := 2.0;
    elsif (clk_dly_rem >=  0.375 and clk_dly_rem < 0.5) then
        clkpm_sel :=  "011";
        clkpm_sel_rl := 3.0;
    elsif (clk_dly_rem >=  0.5 and clk_dly_rem < 0.625) then
        clkpm_sel :=  "100";
        clkpm_sel_rl := 4.0;
    elsif (clk_dly_rem >=  0.625 and clk_dly_rem < 0.75) then
        clkpm_sel :=  "101";
        clkpm_sel_rl := 5.0;
    elsif (clk_dly_rem >=  0.75 and clk_dly_rem < 0.875) then
        clkpm_sel :=  "110";
        clkpm_sel_rl := 6.0;
    elsif (clk_dly_rem >=  0.875 ) then
        clkpm_sel :=  "111";
        clkpm_sel_rl := 7.0;
    end if;

    if (clk_ps < 0.0) then
       clk_ps_rl := (clk_dly_int_rl + 0.125 * clkpm_sel_rl) * 360.0 / clkdiv_real - 360.0;
    else
       clk_ps_rl := (clk_dly_int_rl + 0.125 * clkpm_sel_rl) * 360.0 / clkdiv_real;
    end if;

    if (((clk_ps_rl- clk_ps) > 0.001) or ((clk_ps_rl- clk_ps) < -0.001)) then
        Write ( Message, string'(" Warning : Attribute "));
        Write ( Message, clk_ps_name );
        Write ( Message, string'(" of X_PLL_ADV is set to "));
        Write ( Message, clk_ps);
        Write ( Message, string'(". Real phase shifting is "));
        Write ( Message, clk_ps_rl);
        Write ( Message, string'(". Required phase shifting can not be reached"));
        Write ( Message, '.' & LF );
        assert false report Message.all severity error;
        DEALLOCATE (Message);
    end if;
  end procedure clkout_dly_cal;

procedure clk_out_para_cal (clk_ht : out std_logic_vector(6 downto 0);
                            clk_lt : out std_logic_vector(6 downto 0);
                            clk_nocnt : out std_ulogic;
                            clk_edge : out std_ulogic;
                            CLKOUT_DIVIDE : in  integer;
                            CLKOUT_DUTY_CYCLE : in  real )
  is 
     variable tmp_value : real;
     variable tmp_value0 : real;
     variable tmp_value_l: real;
     variable tmp_value2 : real;
     variable tmp_value1 : integer;
     variable clk_lt_tmp : real;
     variable clk_ht_i : integer;
     variable clk_lt_i : integer;
     variable CLKOUT_DIVIDE_real : real;
     constant O_MAX_HT_LT_real : real := 64.0;
  begin
     CLKOUT_DIVIDE_real := int2real(CLKOUT_DIVIDE);
     tmp_value := CLKOUT_DIVIDE_real * CLKOUT_DUTY_CYCLE;
     tmp_value0 := tmp_value * 2.0;
     tmp_value1 := real2int(tmp_value0) mod 2;
     tmp_value2 := CLKOUT_DIVIDE_real - tmp_value;

     if ((tmp_value) >= O_MAX_HT_LT_real) then
       clk_lt_tmp := 64.0;
       clk_lt := "1000000";
     else
       if (tmp_value < 1.0) then
           clk_lt := "0000001";
           clk_lt_tmp := 1.0;
       else
           if (tmp_value1 /= 0) then
             clk_lt_i := real2int(tmp_value) + 1;
           else
             clk_lt_i := real2int(tmp_value);
           end if;
           clk_lt := STD_LOGIC_VECTOR(TO_UNSIGNED(clk_lt_i, 7));
           clk_lt_tmp := int2real(clk_lt_i);
       end if;
     end if;

   tmp_value_l := CLKOUT_DIVIDE_real -  clk_lt_tmp;

   if ( tmp_value_l >= O_MAX_HT_LT_real) then
       clk_ht := "1000000";
   else
      clk_ht_i := real2int(tmp_value_l);
      clk_ht :=  STD_LOGIC_VECTOR(TO_UNSIGNED(clk_ht_i, 7));
   end if;

   if (CLKOUT_DIVIDE = 1) then
      clk_nocnt := '1';
   else
      clk_nocnt := '0';
   end if;

   if (tmp_value < 1.0) then
      clk_edge := '1';
   elsif (tmp_value1 /= 0) then
      clk_edge := '1';
   else
      clk_edge := '0';
   end if;

  end procedure clk_out_para_cal;

 procedure clkout_pm_cal ( clk_ht1 : out integer ;
                           clk_div : out integer;
                           clk_div1 : out integer;
                           clk_ht : in std_logic_vector(6 downto 0);
                           clk_lt : in std_logic_vector(6 downto 0);
                           clk_nocnt : in std_ulogic;
                           clk_edge : in std_ulogic )
  is 
     variable clk_div_tmp : integer;
  begin
    if (clk_nocnt = '1') then
        clk_div := 1;
        clk_div1 := 1;
        clk_ht1 := 1;
    else 
      if (clk_edge = '1') then
           clk_ht1 := 2 * SLV_TO_INT(clk_ht) + 1;
      else
           clk_ht1 :=  2 * SLV_TO_INT(clk_ht);
      end if;
       clk_div_tmp := SLV_TO_INT(clk_ht) + SLV_TO_INT(clk_lt);
       clk_div := clk_div_tmp;
       clk_div1 :=  2 * clk_div_tmp - 1;
    end if;

  end procedure clkout_pm_cal;

 procedure clkout_delay_para_drp ( clkout_dly : out std_logic_vector(5 downto 0);
                           clk_nocnt : out std_ulogic;
                           clk_edge : out std_ulogic;
                           di_in : in std_logic_vector(15 downto 0);
                           daddr_in : in std_logic_vector(4 downto 0);
                           di_str : string ( 1 to 16);
                           daddr_str : string ( 1 to 5))
  is
     variable  Message : line;
  begin
     clkout_dly := di_in(5 downto 0);
     clk_nocnt := di_in(6);
     clk_edge := di_in(7);
 end procedure clkout_delay_para_drp;
                           
procedure clkout_hl_para_drp ( clk_lt : out std_logic_vector(6 downto 0) ;
                               clk_ht : out std_logic_vector(6 downto 0) ;
                               clkpm_sel : out std_logic_vector(2 downto 0) ;
                           di_in : in std_logic_vector(15 downto 0);
                           daddr_in : in std_logic_vector(4 downto 0);
                           di_str : string ( 1 to 16);
                           daddr_str : string ( 1 to 5))
  is
     variable  Message : line;
  begin
     if (di_in(12) /= '1')  then
      Write ( Message, string'(" Error : X_PLL_ADV input DI(15 downto 0) is set to"));
      Write ( Message, di_str);
      Write ( Message, string'(" at address DADDR = "));
      Write ( Message, daddr_str );
      Write ( Message, string'(". The bit 12 need to be set to 1."));
      Write ( Message, '.' & LF );
      assert false report Message.all severity error;
      DEALLOCATE (Message);
     end if;
  
    if ( di_in(5 downto 0) = "000000") then
       clk_lt := "1000000";
    else
       clk_lt := ( '0' & di_in(5 downto 0));
    end if;
    if (  di_in(11 downto 6) = "000000") then
      clk_ht := "1000000";
    else
      clk_ht := ( '0' & di_in(11 downto 6));
    end if;
    clkpm_sel := di_in(15 downto 13);
end procedure clkout_hl_para_drp;

  function clkout_duty_chk (CLKOUT_DIVIDE : in integer;
                            CLKOUT_DUTY_CYCLE : in real;
                            CLKOUT_DUTY_CYCLE_N : in string)
                          return std_ulogic is
   constant O_MAX_HT_LT_real : real := 64.0;
   variable CLKOUT_DIVIDE_real : real;
   variable CLK_DUTY_CYCLE_MIN : real;
   variable CLK_DUTY_CYCLE_MIN_rnd : real;
   variable CLK_DUTY_CYCLE_MAX : real;
   variable CLK_DUTY_CYCLE_STEP : real;
   variable clk_duty_tmp_int : integer;
   variable  duty_cycle_valid : std_ulogic;
   variable tmp_duty_value : real;
   variable  tmp_j : real; 
   variable Message : line;
   variable step_round_tmp : integer;
   variable step_round_tmp1 : real;

  begin
   CLKOUT_DIVIDE_real := int2real(CLKOUT_DIVIDE);
   step_round_tmp := 1000 /CLKOUT_DIVIDE;
   step_round_tmp1 := int2real(step_round_tmp);
   if (CLKOUT_DIVIDE_real > O_MAX_HT_LT_real) then 
      CLK_DUTY_CYCLE_MIN := (CLKOUT_DIVIDE_real - O_MAX_HT_LT_real)/CLKOUT_DIVIDE_real;
      CLK_DUTY_CYCLE_MAX := (O_MAX_HT_LT_real + 0.5)/CLKOUT_DIVIDE_real;
      CLK_DUTY_CYCLE_MIN_rnd := CLK_DUTY_CYCLE_MIN;
   else  
      if (CLKOUT_DIVIDE = 1) then
          CLK_DUTY_CYCLE_MIN_rnd := 0.0;
          CLK_DUTY_CYCLE_MIN := 0.0;
      else
          CLK_DUTY_CYCLE_MIN_rnd := step_round_tmp1 / 1000.00;
          CLK_DUTY_CYCLE_MIN := 1.0 / CLKOUT_DIVIDE_real;
      end if;
      CLK_DUTY_CYCLE_MAX := 1.0;
   end if;

   if ((CLKOUT_DUTY_CYCLE > CLK_DUTY_CYCLE_MAX) or (CLKOUT_DUTY_CYCLE < CLK_DUTY_CYCLE_MIN_rnd)) then 
     Write ( Message, string'(" Attribute Syntax Warning : "));
     Write ( Message, CLKOUT_DUTY_CYCLE_N);
     Write ( Message, string'(" is set to "));
     Write ( Message, CLKOUT_DUTY_CYCLE);
     Write ( Message, string'(" and is not in the allowed range "));
     Write ( Message, CLK_DUTY_CYCLE_MIN);
     Write ( Message, string'("  to "));
     Write ( Message, CLK_DUTY_CYCLE_MAX);
     Write ( Message, '.' & LF );
      assert false report Message.all severity warning;
      DEALLOCATE (Message);
     end if;

    CLK_DUTY_CYCLE_STEP := 0.5 / CLKOUT_DIVIDE_real;
    tmp_j := 0.0;
    duty_cycle_valid := '0';
    clk_duty_tmp_int := 0;
    for j in 0 to  (2 * CLKOUT_DIVIDE ) loop
      tmp_duty_value := CLK_DUTY_CYCLE_MIN + CLK_DUTY_CYCLE_STEP * tmp_j;
      if (abs(tmp_duty_value - CLKOUT_DUTY_CYCLE) < 0.001 and (tmp_duty_value <= CLK_DUTY_CYCLE_MAX)) then
          duty_cycle_valid := '1';
      end if;
      tmp_j := tmp_j + 1.0;
    end loop;

   if (duty_cycle_valid /= '1') then
    Write ( Message, string'(" Attribute Syntax Warning : "));
    Write ( Message, CLKOUT_DUTY_CYCLE_N);
    Write ( Message, string'(" =  "));
    Write ( Message, CLKOUT_DUTY_CYCLE);
    Write ( Message, string'(" which is  not an allowed value. Allowed value s are: "));
    Write ( Message,  LF );
    tmp_j := 0.0;
    for j in 0 to  (2 * CLKOUT_DIVIDE ) loop
      tmp_duty_value := CLK_DUTY_CYCLE_MIN + CLK_DUTY_CYCLE_STEP * tmp_j;
      if ( (tmp_duty_value <= CLK_DUTY_CYCLE_MAX) and (tmp_duty_value < 1.0)) then
       Write ( Message,  tmp_duty_value);
       Write ( Message,  LF );
      end if;
      tmp_j := tmp_j + 1.0;
    end loop;
      assert false report Message.all severity warning;
      DEALLOCATE (Message);
  end if;
    return duty_cycle_valid;
  end function clkout_duty_chk;

-- Input/Output Pin signals

--        constant VCOCLK_FREQ_MAX : real := 1440.0;
--        constant VCOCLK_FREQ_MIN : real := 400.0;
        constant VCOCLK_FREQ_TARGET : real := 800.0;
        constant CLKIN_FREQ_MAX : real := 710.0;
        constant CLKIN_FREQ_MIN : real := 19.0;
        constant CLKPFD_FREQ_MAX : real := 550.0;
        constant CLKPFD_FREQ_MIN : real := 19.0;
        constant O_MAX_HT_LT : integer := 64;
        constant REF_CLK_JITTER_MAX : time := 1000 ps;
        constant REF_CLK_JITTER_SCALE : real := 0.1;
        constant MAX_FEEDBACK_DELAY : time := 10 ns;
        constant MAX_FEEDBACK_DELAY_SCALE : real := 1.0;

        constant  PLL_LOCK_TIME : integer := 7;

        signal   CLKIN1_ipd  :  std_ulogic;
        signal   CLKIN2_ipd  :  std_ulogic;
        signal   CLKFBIN_ipd  :  std_ulogic;
        signal   RST_ipd  :  std_ulogic;
        signal   REL_ipd  :  std_ulogic;
        signal   CLKINSEL_ipd  :  std_ulogic;
        signal   DADDR_ipd  :  std_logic_vector(4 downto 0);
        signal   DI_ipd  :  std_logic_vector(15 downto 0);
        signal   DWE_ipd  :  std_ulogic;
        signal   DEN_ipd  :  std_ulogic;
        signal   DCLK_ipd  :  std_ulogic;

        signal   CLKOUT0_out  :  std_ulogic := '0';
        signal   CLKOUT1_out  :  std_ulogic := '0';
        signal   CLKOUT2_out  :  std_ulogic := '0';
        signal   CLKOUT3_out  :  std_ulogic := '0';
        signal   CLKOUT4_out  :  std_ulogic := '0';
        signal   CLKOUT5_out  :  std_ulogic := '0';
        signal   CLKFBOUT_out  :  std_ulogic := '0';
        signal   LOCKED_out  :  std_ulogic := '0';
        signal   do_out  :  std_logic_vector(15 downto 0);
        signal   DRDY_out  :  std_ulogic := '0';
        signal   CLKIN1_dly  :  std_ulogic;
        signal   CLKIN2_dly  :  std_ulogic;
        signal   CLKFBIN_dly  :  std_ulogic;
        signal   RST_dly  :  std_ulogic;
        signal   REL_dly  :  std_ulogic;
        signal   CLKINSEL_dly  :  std_ulogic;
        signal   DADDR_dly  :  std_logic_vector(4 downto 0);
        signal   DI_dly  :  std_logic_vector(15 downto 0);
        signal   DWE_dly  :  std_ulogic;
        signal   DEN_dly  :  std_ulogic;
        signal   DCLK_dly  :  std_ulogic;

        signal di_in : std_logic_vector (15 downto 0);
        signal dwe_in : std_ulogic := '0';
        signal den_in : std_ulogic := '0';
        signal dclk_in : std_ulogic := '0';
        signal rst_in : std_ulogic := '0';
        signal rst_input : std_ulogic := '0';
        signal rel_in : std_ulogic := '0';
        signal clkfb_in : std_ulogic := '0';
        signal clkin1_in : std_ulogic := '0';
        signal clkin1_in_dly : std_ulogic := '0';
        signal clkin2_in : std_ulogic := '0';
        signal clkinsel_in : std_ulogic := '0';
        signal clkinsel_tmp : std_ulogic := '0';
        signal daddr_in :  std_logic_vector(4 downto 0);
        signal daddr_in_lat :  integer := 0;
        signal drp_lock :  std_ulogic := '0';
        signal drp_lock1  :  std_ulogic := '0';
        type   drp_array is array (31 downto 0) of std_logic_vector(15 downto 0);
        signal dr_sram : drp_array;
        
        signal clk0in :  std_ulogic := '0';
        signal clk1in :  std_ulogic := '0';
        signal clk2in :  std_ulogic := '0';
        signal clk3in :  std_ulogic := '0';
        signal clk4in :  std_ulogic := '0';
        signal clk5in :  std_ulogic := '0';
        signal clkfbm1in :  std_ulogic := '0';
        signal clk0_out :  std_ulogic := '0';
        signal clk1_out :  std_ulogic := '0';
        signal clk2_out :  std_ulogic := '0';
        signal clk3_out :  std_ulogic := '0';
        signal clk4_out :  std_ulogic := '0';
        signal clk5_out :  std_ulogic := '0';
        signal clkfb_out :  std_ulogic := '0';
        signal clkfbm1_out :  std_ulogic := '0';
        signal clkout_en :  std_ulogic := '0';
        signal clkout_en1 :  std_ulogic := '0';
        signal clkout_en0 :  std_ulogic := '0';
        signal clkout_en0_tmp :  std_ulogic := '0';
        signal clkout_cnt : integer := 0;
        signal clkin_cnt : integer := 0;
        signal clkin_lock_cnt : integer := 0;
        signal clkout_en_time : integer := PLL_LOCK_TIME + 2;
        signal locked_en_time : integer := 0;
        signal lock_cnt_max : integer := 0;
        signal clkvco_lk :  std_ulogic := '0';
        signal clkvco_lk_rst :  std_ulogic := '0';
        signal clkvco_free :  std_ulogic := '0';
        signal clkvco :  std_ulogic := '0';
        signal fbclk_tmp :  std_ulogic := '0';

        signal rst_in1 :  std_ulogic := '0';
        signal rst_unlock :  std_ulogic := '0';
        signal rst_on_loss :  std_ulogic := '0';
        signal rst_edge : time := 0 ps;
        signal rst_ht : time := 0 ps;
        signal fb_delay_found :  std_ulogic := '0';
        signal fb_delay_found_tmp :  std_ulogic := '0';
        signal clkfb_tst :  std_ulogic := '0';
        constant fb_delay_max : time := MAX_FEEDBACK_DELAY * MAX_FEEDBACK_DELAY_SCALE;
        signal fb_delay : time := 0 ps;
        signal clkvco_delay : time := 0 ps;
        signal val_tmp : time := 0 ps;
        signal clkin_edge : time := 0 ps;
        signal delay_edge : time := 0 ps;

        type   real_array_usr is array (4 downto 0) of time;
        signal clkin_period : real_array_usr := (others => 2.0 ns);
        signal period_vco : time := 0.000 ns;
        signal period_vco_rm : integer := 0;
        signal period_vco_cmp_cnt : integer := 0;
        signal clkvco_tm_cnt : integer := 0;
        signal period_vco_cmp_flag : integer := 0;
        signal period_vco1 : time := 0.000 ns;
        signal period_vco2 : time := 0.000 ns;
        signal period_vco3 : time := 0.000 ns;
        signal period_vco4 : time := 0.000 ns;
        signal period_vco5 : time := 0.000 ns;
        signal period_vco6 : time := 0.000 ns;
        signal period_vco7 : time := 0.000 ns;
        signal period_vco_half : time := 0.000 ns;
        signal period_vco_half1 : time := 0.000 ns;
        signal period_vco_half_rm : time := 0.000 ns;
        constant period_vco_max : time := 1 ns * 1000 / VCOCLK_FREQ_MIN;
        constant period_vco_min : time := 1 ns * 1000 / VCOCLK_FREQ_MAX;
        constant period_vco_target : time := 1 ns * 1000 / VCOCLK_FREQ_TARGET;
        constant period_vco_target_half : time := 1 ns * 500 / VCOCLK_FREQ_TARGET;
        signal period_fb : time := 0.000 ns;
        signal period_avg : time := 0.000 ns;

        signal clkvco_freq_init_chk : real := 0.0;
        signal clkfb_stop_max : integer := 3;
        signal clkin_stop_max : integer := DIVCLK_DIVIDE + 1;
        signal md_product : integer := CLKFBOUT_MULT * DIVCLK_DIVIDE;
        signal m_product : integer := CLKFBOUT_MULT;
        signal m_product2 : integer := CLKFBOUT_MULT / 2;

        signal pll_locked_delay : time := 0 ps;
        signal clkin_dly_t : time := 0 ps;
        signal clkfb_dly_t : time := 0 ps;
        signal clkpll : std_ulogic := '0';
        signal clkpll_dly : std_ulogic := '0';
        signal clkfb_in_dly : std_ulogic := '0';
        signal pll_unlock : std_ulogic := '0';
        signal pll_locked_tm : std_ulogic := '0';
        signal pll_locked_tmp1 : std_ulogic := '0';
        signal pll_locked_tmp2 : std_ulogic := '0';
        signal lock_period : std_ulogic := '0';
        signal pll_lock_tm: std_ulogic := '0';
        signal unlock_recover : std_ulogic := '0';
        signal clkin_stopped : std_ulogic := '0';
        signal clkin_stopped_p : std_ulogic := '0';
        signal clkin_stopped_n : std_ulogic := '0';
        signal  clkstop_cnt_p : integer := 0;
        signal  clkstop_cnt_n : integer := 0;
        signal  clkfbstop_cnt_p : integer := 0;
        signal  clkfbstop_cnt_n : integer := 0;
        signal clkfb_stopped : std_ulogic := '0';
        signal clkfb_stopped_p : std_ulogic := '0';
        signal clkfb_stopped_n : std_ulogic := '0';
        signal clkpll_jitter_unlock : std_ulogic := '0';
        signal clkin_jit : time := 0 ps;
        constant ref_jitter_max_tmp : time := REF_CLK_JITTER_MAX;
        
        signal clka1_out : std_ulogic := '0';
        signal clkb1_out : std_ulogic := '0';
        signal clka1d2_out : std_ulogic := '0';
        signal clka1d4_out : std_ulogic := '0';
        signal clka1d8_out : std_ulogic := '0';
        signal clkdiv_rel_rst : std_ulogic := '0';
        signal qrel_o_reg1 : std_ulogic := '0';
        signal qrel_o_reg2 : std_ulogic := '0';
        signal qrel_o_reg3 : std_ulogic := '0';
        signal rel_o_mux_sel : std_ulogic := '0';
        signal pmcd_mode : std_ulogic := '0';
        signal rel_rst_o : std_ulogic := '0';
        signal rel_o_mux_clk : std_ulogic := '0';
        signal rel_o_mux_clk_tmp : std_ulogic := '0';
        signal clka1_in : std_ulogic := '0';
        signal clkb1_in : std_ulogic := '0';
        signal clkout0_out_out : std_ulogic := '0';
        signal clkout1_out_out : std_ulogic := '0';
        signal clkout2_out_out : std_ulogic := '0';
        signal clkout3_out_out : std_ulogic := '0';
        signal clkout4_out_out : std_ulogic := '0';
        signal clkout5_out_out : std_ulogic := '0';
        signal clkfbout_out_out : std_ulogic := '0';
        signal clk0ps_en : std_ulogic := '0';
        signal clk1ps_en : std_ulogic := '0';
        signal clk2ps_en : std_ulogic := '0';
        signal clk3ps_en : std_ulogic := '0';
        signal clk4ps_en : std_ulogic := '0';
        signal clk5ps_en : std_ulogic := '0';
        signal clkfbm1ps_en : std_ulogic := '0';
        signal clkout_mux : std_logic_vector (7 downto 0) := X"00";
        signal clk0pm_sel : integer := 0;
        signal clk1pm_sel : integer := 0;
        signal clk2pm_sel : integer := 0;
        signal clk3pm_sel : integer := 0; 
        signal clk4pm_sel : integer := 0;
        signal clk5pm_sel : integer := 0;
        signal clkfbm1pm_sel : integer := 0;
        signal clkfbm1pm_rl : real := 0.0;
        signal clk0_edge  : std_ulogic := '0';
        signal clk1_edge  : std_ulogic := '0';
        signal clk2_edge  : std_ulogic := '0';
        signal clk3_edge  : std_ulogic := '0';
        signal clk4_edge  : std_ulogic := '0';
        signal clk5_edge  : std_ulogic := '0';
        signal clkfbm1_edge  : std_ulogic := '0';
        signal clkind_edge  : std_ulogic := '0';
        signal clk0_nocnt  : std_ulogic := '0';
        signal clk1_nocnt  : std_ulogic := '0';
        signal clk2_nocnt  : std_ulogic := '0';
        signal clk3_nocnt  : std_ulogic := '0';
        signal clk4_nocnt  : std_ulogic := '0';
        signal clk5_nocnt  : std_ulogic := '0';
        signal clkfbm1_nocnt  : std_ulogic := '0';
        signal clkind_nocnt  : std_ulogic := '0';
        signal clk0_dly_cnt : integer := 0;
        signal clk1_dly_cnt : integer := 0;
        signal clk2_dly_cnt : integer := 0;
        signal clk3_dly_cnt : integer := 0;
        signal clk4_dly_cnt : integer := 0;
        signal clk5_dly_cnt : integer := 0;
        signal clkfbm1_dly_cnt : integer := 0;
        signal clk0_ht : std_logic_vector (6 downto 0) := "0000000";
        signal clk1_ht : std_logic_vector (6 downto 0) := "0000000";
        signal clk2_ht : std_logic_vector (6 downto 0) := "0000000";
        signal clk3_ht : std_logic_vector (6 downto 0) := "0000000";
        signal clk4_ht : std_logic_vector (6 downto 0) := "0000000";
        signal clk5_ht : std_logic_vector (6 downto 0) := "0000000";
        signal clkfbm1_ht : std_logic_vector (6 downto 0) := "0000000";
        signal clk0_lt : std_logic_vector (6 downto 0) := "0000000";
        signal clk1_lt : std_logic_vector (6 downto 0) := "0000000";
        signal clk2_lt : std_logic_vector (6 downto 0) := "0000000";
        signal clk3_lt : std_logic_vector (6 downto 0) := "0000000";
        signal clk4_lt : std_logic_vector (6 downto 0) := "0000000";
        signal clk5_lt : std_logic_vector (6 downto 0) := "0000000";
        signal clkfbm1_lt : std_logic_vector (6 downto 0) := "0000000";
        signal clkout0_dly : integer := 0;
        signal clkout1_dly : integer := 0;
        signal clkout2_dly : integer := 0;
        signal clkout3_dly : integer := 0;
        signal clkout4_dly : integer := 0;
        signal clkout5_dly : integer := 0;
        signal clkfbm1_dly : integer := 0;
        signal clkind_ht : std_logic_vector (6 downto 0) := "0000000";
        signal clkind_lt : std_logic_vector (6 downto 0) := "0000000";
        signal clk0_ht1 : integer := 0;
        signal clk1_ht1 : integer := 0;
        signal clk2_ht1 : integer := 0;
        signal clk3_ht1 : integer := 0;
        signal clk4_ht1 : integer := 0;
        signal clk5_ht1 : integer := 0;
        signal clkfbm1_ht1 : integer := 0;
        signal clk0_cnt : integer := 0;
        signal clk1_cnt : integer := 0;
        signal clk2_cnt : integer := 0;
        signal clk3_cnt : integer := 0;
        signal clk4_cnt : integer := 0;
        signal clk5_cnt : integer := 0;
        signal clkfbm1_cnt : integer := 0;
        signal clk0_div : integer := 0;
        signal clk1_div : integer := 0;
        signal clk2_div : integer := 0;
        signal clk3_div : integer := 0;
        signal clk4_div : integer := 0;
        signal clk5_div : integer := 0;
        signal clkfbm1_div : integer := 1;
        signal clk0_div1 : integer := 0;
        signal clk1_div1 : integer := 0;
        signal clk2_div1 : integer := 0;
        signal clk3_div1 : integer := 0;
        signal clk4_div1 : integer := 0;
        signal clk5_div1 : integer := 0;
        signal clkfbm1_div1 : integer := 0;
        signal clkind_div : integer := 0;

begin

        CLKOUT0 <=  clkout0_out_out;
        CLKOUT1 <=  clkout1_out_out;
        CLKOUT2 <=  clkout2_out_out;
        CLKOUT3 <=   clkout3_out_out;
        CLKOUT4 <=   clkout4_out_out;
        CLKOUT5 <=   clkout5_out_out;
        CLKFBOUT <=   clkfbout_out_out;
        CLKOUTDCM0 <=  clkout0_out_out;
        CLKOUTDCM1 <=  clkout1_out_out;
        CLKOUTDCM2 <=  clkout2_out_out;
        CLKOUTDCM3 <=  clkout3_out_out;
        CLKOUTDCM4 <=  clkout4_out_out;
        CLKOUTDCM5 <=  clkout5_out_out;
        CLKFBDCM <=   clkfbout_out_out;

        WireDelay : block
        begin
              VitalWireDelay (CLKIN1_ipd,CLKIN1,tipd_CLKIN1);
              VitalWireDelay (CLKIN2_ipd,CLKIN2,tipd_CLKIN2);
              VitalWireDelay (CLKFBIN_ipd,CLKFBIN,tipd_CLKFBIN);
              VitalWireDelay (RST_ipd,RST,tipd_RST);
              VitalWireDelay (REL_ipd,REL,tipd_REL);
              VitalWireDelay (CLKINSEL_ipd,CLKINSEL,tipd_CLKINSEL);
           DADDR_DELAY : for i in 4 downto 0 generate
              VitalWireDelay (DADDR_ipd(i),DADDR(i),tipd_DADDR(i));
           end generate DADDR_DELAY;
           DI_DELAY : for i in 15 downto 0 generate
              VitalWireDelay (DI_ipd(i),DI(i),tipd_DI(i));
           end generate DI_DELAY;
              VitalWireDelay (DWE_ipd,DWE,tipd_DWE);
              VitalWireDelay (DEN_ipd,DEN,tipd_DEN);
              VitalWireDelay (DCLK_ipd,DCLK,tipd_DCLK);
        end block;


        clkfb_in <= CLKFBIN_ipd;
        clkin1_in <= CLKIN1_ipd;
        clkin2_in <= CLKIN2_ipd;
        clkinsel_in <= CLKINSEL_ipd;
        rst_input <= RST_ipd;
--        rel_in <= REL_ipd;
        rel_in <= REL_dly;
        clkin1_in_dly <= CLKIN1_dly;
        daddr_in(4 downto 0) <= DADDR_dly(4 downto 0);
        dclk_in <= DCLK_dly;
        den_in <= DEN_dly;
        di_in(15 downto 0) <= DI_dly(15 downto 0);
        dwe_in <= DWE_dly;

        SignalDelay : block
        begin
              DADDR_DELAY : for i in 4 downto 0 generate
                VitalSignalDelay (DADDR_dly(i),DADDR_ipd(i),tisd_daddr_dclk(i));
              end generate DADDR_DELAY;
              DI_DELAY : for i in 15 downto 0 generate
                VitalSignalDelay (DI_dly(i),DI_ipd(i),tisd_di_dclk(i));
              end generate DI_DELAY;
              VitalSignalDelay (DWE_dly,DWE_ipd,tisd_dwe_dclk);
              VitalSignalDelay (DEN_dly,DEN_ipd,tisd_den_dclk);
              VitalSignalDelay (REL_dly,REL_ipd,tisd_REL_CLKIN1);
              VitalSignalDelay (DCLK_dly,DCLK_ipd,ticd_DCLK);
              VitalSignalDelay (CLKIN1_dly,CLKIN1_ipd,ticd_CLKIN1);
        end block;

        INIPROC : process
            variable Message : line;
            variable con_line : line;
            variable tmpvalue : real;
            variable chk_ok : std_ulogic;
            variable tmp_string : string(1 to 18);
            variable skipspace : character;
            variable CLK_DUTY_CYCLE_MIN : real;
            variable CLK_DUTY_CYCLE_MAX : real;
            variable  CLK_DUTY_CYCLE_STEP : real;
            variable O_MAX_HT_LT_real : real;
            variable duty_cycle_valid : std_ulogic;
            variable CLKOUT0_DIVIDE_real : real;
            variable CLKOUT1_DIVIDE_real : real;
            variable CLKOUT2_DIVIDE_real : real;
            variable CLKOUT3_DIVIDE_real : real;
            variable CLKOUT4_DIVIDE_real : real;
            variable CLKOUT5_DIVIDE_real : real;
            variable tmp_j : real;
            variable tmp_duty_value : real;
            variable clk_ht_i : std_logic_vector(5 downto 0);
            variable clk_lt_i : std_logic_vector(5 downto 0);
            variable clk_nocnt_i : std_ulogic;
            variable clk_edge_i : std_ulogic;
        begin
           if((COMPENSATION /= "INTERNAL") and (COMPENSATION /= "internal") and
                 (COMPENSATION /= "EXTERNAL") and (COMPENSATION /= "external") and
                 (COMPENSATION /= "SYSTEM_SYNCHRONOUS") and (COMPENSATION /= "system_synchronous") and
                 (COMPENSATION /= "SOURCE_SYNCHRONOUS") and (COMPENSATION /= "source_synchronous") and
                 (COMPENSATION /= "DCM2PLL") and (COMPENSATION /= "dcm2pll") and
                 (COMPENSATION /= "PLL2DCM") and (COMPENSATION /= "pll2dcm")) then 
             assert FALSE report "Attribute Syntax Error : COMPENSATION  is not INTERNAL, EXTERNAL, SYSTEM_SYNCHRONOUS, SOURCE_SYNCHRONOUS , DCM2PLL, PLL2DCM." severity error;
            end if;

           if((BANDWIDTH /= "HIGH") and (BANDWIDTH /= "high") and
                 (BANDWIDTH /= "LOW") and (BANDWIDTH /= "low") and
                 (BANDWIDTH /= "OPTIMIZED") and (BANDWIDTH /= "optimized")) then
             assert FALSE report "Attribute Syntax Error : BANDWIDTH  is not HIGH, LOW, OPTIMIZED." severity error;
            end if;

       if ((CLKOUT0_DESKEW_ADJUST /= "NONE") and (CLKOUT0_DESKEW_ADJUST /= "none")
            and (CLKOUT0_DESKEW_ADJUST /= "PPC") and (CLKOUT0_DESKEW_ADJUST /= "ppc")
            and (CLKOUT0_DESKEW_ADJUST /= "0") 
            and (CLKOUT0_DESKEW_ADJUST /= "1") 
            and (CLKOUT0_DESKEW_ADJUST /= "2") 
            and (CLKOUT0_DESKEW_ADJUST /= "3") 
            and (CLKOUT0_DESKEW_ADJUST /= "4") 
            and (CLKOUT0_DESKEW_ADJUST /= "5") 
            and (CLKOUT0_DESKEW_ADJUST /= "6") 
            and (CLKOUT0_DESKEW_ADJUST /= "7") 
            and (CLKOUT0_DESKEW_ADJUST /= "8") 
            and (CLKOUT0_DESKEW_ADJUST /= "9") 
            and (CLKOUT0_DESKEW_ADJUST /= "10")
            and (CLKOUT0_DESKEW_ADJUST /= "11")
            and (CLKOUT0_DESKEW_ADJUST /= "12")
            and (CLKOUT0_DESKEW_ADJUST /= "13")
            and (CLKOUT0_DESKEW_ADJUST /= "14")
            and (CLKOUT0_DESKEW_ADJUST /= "15")
            and (CLKOUT0_DESKEW_ADJUST /= "16")
            and (CLKOUT0_DESKEW_ADJUST /= "17")
            and (CLKOUT0_DESKEW_ADJUST /= "18")
            and (CLKOUT0_DESKEW_ADJUST /= "19")
            and (CLKOUT0_DESKEW_ADJUST /= "20")
            and (CLKOUT0_DESKEW_ADJUST /= "21")
            and (CLKOUT0_DESKEW_ADJUST /= "22")
            and (CLKOUT0_DESKEW_ADJUST /= "23")
            and (CLKOUT0_DESKEW_ADJUST /= "24")
            and (CLKOUT0_DESKEW_ADJUST /= "25")
            and (CLKOUT0_DESKEW_ADJUST /= "26")
            and (CLKOUT0_DESKEW_ADJUST /= "27")
            and (CLKOUT0_DESKEW_ADJUST /= "28")
            and (CLKOUT0_DESKEW_ADJUST /= "29")
            and (CLKOUT0_DESKEW_ADJUST /= "30")
            and (CLKOUT0_DESKEW_ADJUST /= "31" ) 
           ) then 
               assert FALSE report "Error : CLKOUT0_DESKEW_ADJUST is not NONE, PPC, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31." severity error;
       end if;  

       if ((CLKOUT1_DESKEW_ADJUST /= "NONE") and (CLKOUT1_DESKEW_ADJUST /= "none")
            and (CLKOUT1_DESKEW_ADJUST /= "PPC") and (CLKOUT1_DESKEW_ADJUST /= "ppc")
            and (CLKOUT1_DESKEW_ADJUST /= "0") 
            and (CLKOUT1_DESKEW_ADJUST /= "1") 
            and (CLKOUT1_DESKEW_ADJUST /= "2") 
            and (CLKOUT1_DESKEW_ADJUST /= "3") 
            and (CLKOUT1_DESKEW_ADJUST /= "4") 
            and (CLKOUT1_DESKEW_ADJUST /= "5") 
            and (CLKOUT1_DESKEW_ADJUST /= "6") 
            and (CLKOUT1_DESKEW_ADJUST /= "7") 
            and (CLKOUT1_DESKEW_ADJUST /= "8") 
            and (CLKOUT1_DESKEW_ADJUST /= "9") 
            and (CLKOUT1_DESKEW_ADJUST /= "10")
            and (CLKOUT1_DESKEW_ADJUST /= "11")
            and (CLKOUT1_DESKEW_ADJUST /= "12")
            and (CLKOUT1_DESKEW_ADJUST /= "13")
            and (CLKOUT1_DESKEW_ADJUST /= "14")
            and (CLKOUT1_DESKEW_ADJUST /= "15")
            and (CLKOUT1_DESKEW_ADJUST /= "16")
            and (CLKOUT1_DESKEW_ADJUST /= "17")
            and (CLKOUT1_DESKEW_ADJUST /= "18")
            and (CLKOUT1_DESKEW_ADJUST /= "19")
            and (CLKOUT1_DESKEW_ADJUST /= "20")
            and (CLKOUT1_DESKEW_ADJUST /= "21")
            and (CLKOUT1_DESKEW_ADJUST /= "22")
            and (CLKOUT1_DESKEW_ADJUST /= "23")
            and (CLKOUT1_DESKEW_ADJUST /= "24")
            and (CLKOUT1_DESKEW_ADJUST /= "25")
            and (CLKOUT1_DESKEW_ADJUST /= "26")
            and (CLKOUT1_DESKEW_ADJUST /= "27")
            and (CLKOUT1_DESKEW_ADJUST /= "28")
            and (CLKOUT1_DESKEW_ADJUST /= "29")
            and (CLKOUT1_DESKEW_ADJUST /= "30")
            and (CLKOUT1_DESKEW_ADJUST /= "31" ) ) then 
               assert FALSE report "Error : CLKOUT1_DESKEW_ADJUST is not NONE, PPC, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31." severity error;
       end if;  

       if ((CLKOUT2_DESKEW_ADJUST /= "NONE") and (CLKOUT2_DESKEW_ADJUST /= "none")
            and (CLKOUT2_DESKEW_ADJUST /= "PPC") and (CLKOUT2_DESKEW_ADJUST /= "ppc")
            and (CLKOUT2_DESKEW_ADJUST /= "0") 
            and (CLKOUT2_DESKEW_ADJUST /= "1") 
            and (CLKOUT2_DESKEW_ADJUST /= "2") 
            and (CLKOUT2_DESKEW_ADJUST /= "3") 
            and (CLKOUT2_DESKEW_ADJUST /= "4") 
            and (CLKOUT2_DESKEW_ADJUST /= "5") 
            and (CLKOUT2_DESKEW_ADJUST /= "6") 
            and (CLKOUT2_DESKEW_ADJUST /= "7") 
            and (CLKOUT2_DESKEW_ADJUST /= "8") 
            and (CLKOUT2_DESKEW_ADJUST /= "9") 
            and (CLKOUT2_DESKEW_ADJUST /= "10")
            and (CLKOUT2_DESKEW_ADJUST /= "11")
            and (CLKOUT2_DESKEW_ADJUST /= "12")
            and (CLKOUT2_DESKEW_ADJUST /= "13")
            and (CLKOUT2_DESKEW_ADJUST /= "14")
            and (CLKOUT2_DESKEW_ADJUST /= "15")
            and (CLKOUT2_DESKEW_ADJUST /= "16")
            and (CLKOUT2_DESKEW_ADJUST /= "17")
            and (CLKOUT2_DESKEW_ADJUST /= "18")
            and (CLKOUT2_DESKEW_ADJUST /= "19")
            and (CLKOUT2_DESKEW_ADJUST /= "20")
            and (CLKOUT2_DESKEW_ADJUST /= "21")
            and (CLKOUT2_DESKEW_ADJUST /= "22")
            and (CLKOUT2_DESKEW_ADJUST /= "23")
            and (CLKOUT2_DESKEW_ADJUST /= "24")
            and (CLKOUT2_DESKEW_ADJUST /= "25")
            and (CLKOUT2_DESKEW_ADJUST /= "26")
            and (CLKOUT2_DESKEW_ADJUST /= "27")
            and (CLKOUT2_DESKEW_ADJUST /= "28")
            and (CLKOUT2_DESKEW_ADJUST /= "29")
            and (CLKOUT2_DESKEW_ADJUST /= "30")
            and (CLKOUT2_DESKEW_ADJUST /= "31" ) ) then 
               assert FALSE report "Error : CLKOUT2_DESKEW_ADJUST is not NONE, PPC, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31." severity error;
       end if;  

       if ((CLKOUT3_DESKEW_ADJUST /= "NONE") and (CLKOUT3_DESKEW_ADJUST /= "none")
            and (CLKOUT3_DESKEW_ADJUST /= "PPC") and (CLKOUT3_DESKEW_ADJUST /= "ppc")
            and (CLKOUT3_DESKEW_ADJUST /= "0") 
            and (CLKOUT3_DESKEW_ADJUST /= "1") 
            and (CLKOUT3_DESKEW_ADJUST /= "2") 
            and (CLKOUT3_DESKEW_ADJUST /= "3") 
            and (CLKOUT3_DESKEW_ADJUST /= "4") 
            and (CLKOUT3_DESKEW_ADJUST /= "5") 
            and (CLKOUT3_DESKEW_ADJUST /= "6") 
            and (CLKOUT3_DESKEW_ADJUST /= "7") 
            and (CLKOUT3_DESKEW_ADJUST /= "8") 
            and (CLKOUT3_DESKEW_ADJUST /= "9") 
            and (CLKOUT3_DESKEW_ADJUST /= "10")
            and (CLKOUT3_DESKEW_ADJUST /= "11")
            and (CLKOUT3_DESKEW_ADJUST /= "12")
            and (CLKOUT3_DESKEW_ADJUST /= "13")
            and (CLKOUT3_DESKEW_ADJUST /= "14")
            and (CLKOUT3_DESKEW_ADJUST /= "15")
            and (CLKOUT3_DESKEW_ADJUST /= "16")
            and (CLKOUT3_DESKEW_ADJUST /= "17")
            and (CLKOUT3_DESKEW_ADJUST /= "18")
            and (CLKOUT3_DESKEW_ADJUST /= "19")
            and (CLKOUT3_DESKEW_ADJUST /= "20")
            and (CLKOUT3_DESKEW_ADJUST /= "21")
            and (CLKOUT3_DESKEW_ADJUST /= "22")
            and (CLKOUT3_DESKEW_ADJUST /= "23")
            and (CLKOUT3_DESKEW_ADJUST /= "24")
            and (CLKOUT3_DESKEW_ADJUST /= "25")
            and (CLKOUT3_DESKEW_ADJUST /= "26")
            and (CLKOUT3_DESKEW_ADJUST /= "27")
            and (CLKOUT3_DESKEW_ADJUST /= "28")
            and (CLKOUT3_DESKEW_ADJUST /= "29")
            and (CLKOUT3_DESKEW_ADJUST /= "30")
            and (CLKOUT3_DESKEW_ADJUST /= "31" ) ) then 
               assert FALSE report "Error : CLKOUT3_DESKEW_ADJUST is not NONE, PPC, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31." severity error;
       end if;  

       if ((CLKOUT4_DESKEW_ADJUST /= "NONE") and (CLKOUT4_DESKEW_ADJUST /= "none")
            and (CLKOUT4_DESKEW_ADJUST /= "PPC") and (CLKOUT4_DESKEW_ADJUST /= "ppc")
            and (CLKOUT4_DESKEW_ADJUST /= "0") 
            and (CLKOUT4_DESKEW_ADJUST /= "1") 
            and (CLKOUT4_DESKEW_ADJUST /= "2") 
            and (CLKOUT4_DESKEW_ADJUST /= "3") 
            and (CLKOUT4_DESKEW_ADJUST /= "4") 
            and (CLKOUT4_DESKEW_ADJUST /= "5") 
            and (CLKOUT4_DESKEW_ADJUST /= "6") 
            and (CLKOUT4_DESKEW_ADJUST /= "7") 
            and (CLKOUT4_DESKEW_ADJUST /= "8") 
            and (CLKOUT4_DESKEW_ADJUST /= "9") 
            and (CLKOUT4_DESKEW_ADJUST /= "10")
            and (CLKOUT4_DESKEW_ADJUST /= "11")
            and (CLKOUT4_DESKEW_ADJUST /= "12")
            and (CLKOUT4_DESKEW_ADJUST /= "13")
            and (CLKOUT4_DESKEW_ADJUST /= "14")
            and (CLKOUT4_DESKEW_ADJUST /= "15")
            and (CLKOUT4_DESKEW_ADJUST /= "16")
            and (CLKOUT4_DESKEW_ADJUST /= "17")
            and (CLKOUT4_DESKEW_ADJUST /= "18")
            and (CLKOUT4_DESKEW_ADJUST /= "19")
            and (CLKOUT4_DESKEW_ADJUST /= "20")
            and (CLKOUT4_DESKEW_ADJUST /= "21")
            and (CLKOUT4_DESKEW_ADJUST /= "22")
            and (CLKOUT4_DESKEW_ADJUST /= "23")
            and (CLKOUT4_DESKEW_ADJUST /= "24")
            and (CLKOUT4_DESKEW_ADJUST /= "25")
            and (CLKOUT4_DESKEW_ADJUST /= "26")
            and (CLKOUT4_DESKEW_ADJUST /= "27")
            and (CLKOUT4_DESKEW_ADJUST /= "28")
            and (CLKOUT4_DESKEW_ADJUST /= "29")
            and (CLKOUT4_DESKEW_ADJUST /= "30")
            and (CLKOUT4_DESKEW_ADJUST /= "31" ) ) then 
               assert FALSE report "Error : CLKOUT4_DESKEW_ADJUST  is not NONE, PPC, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31." severity error;
       end if;  

       if ((CLKOUT5_DESKEW_ADJUST /= "NONE") and (CLKOUT5_DESKEW_ADJUST /= "none")
            and (CLKOUT5_DESKEW_ADJUST /= "PPC") and (CLKOUT5_DESKEW_ADJUST /= "ppc")
            and (CLKOUT5_DESKEW_ADJUST /= "0") 
            and (CLKOUT5_DESKEW_ADJUST /= "1") 
            and (CLKOUT5_DESKEW_ADJUST /= "2") 
            and (CLKOUT5_DESKEW_ADJUST /= "3") 
            and (CLKOUT5_DESKEW_ADJUST /= "4") 
            and (CLKOUT5_DESKEW_ADJUST /= "5") 
            and (CLKOUT5_DESKEW_ADJUST /= "6") 
            and (CLKOUT5_DESKEW_ADJUST /= "7") 
            and (CLKOUT5_DESKEW_ADJUST /= "8") 
            and (CLKOUT5_DESKEW_ADJUST /= "9") 
            and (CLKOUT5_DESKEW_ADJUST /= "10")
            and (CLKOUT5_DESKEW_ADJUST /= "11")
            and (CLKOUT5_DESKEW_ADJUST /= "12")
            and (CLKOUT5_DESKEW_ADJUST /= "13")
            and (CLKOUT5_DESKEW_ADJUST /= "14")
            and (CLKOUT5_DESKEW_ADJUST /= "15")
            and (CLKOUT5_DESKEW_ADJUST /= "16")
            and (CLKOUT5_DESKEW_ADJUST /= "17")
            and (CLKOUT5_DESKEW_ADJUST /= "18")
            and (CLKOUT5_DESKEW_ADJUST /= "19")
            and (CLKOUT5_DESKEW_ADJUST /= "20")
            and (CLKOUT5_DESKEW_ADJUST /= "21")
            and (CLKOUT5_DESKEW_ADJUST /= "22")
            and (CLKOUT5_DESKEW_ADJUST /= "23")
            and (CLKOUT5_DESKEW_ADJUST /= "24")
            and (CLKOUT5_DESKEW_ADJUST /= "25")
            and (CLKOUT5_DESKEW_ADJUST /= "26")
            and (CLKOUT5_DESKEW_ADJUST /= "27")
            and (CLKOUT5_DESKEW_ADJUST /= "28")
            and (CLKOUT5_DESKEW_ADJUST /= "29")
            and (CLKOUT5_DESKEW_ADJUST /= "30")
            and (CLKOUT5_DESKEW_ADJUST /= "31" ) ) then 
               assert FALSE report "Error : CLKOUT5_DESKEW_ADJUST is not NONE, PPC, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31." severity error;
       end if;  

       if ((CLKFBOUT_DESKEW_ADJUST /= "NONE") and (CLKFBOUT_DESKEW_ADJUST /= "none")
            and (CLKFBOUT_DESKEW_ADJUST /= "PPC") and (CLKFBOUT_DESKEW_ADJUST /= "ppc")
            and (CLKFBOUT_DESKEW_ADJUST /= "0") 
            and (CLKFBOUT_DESKEW_ADJUST /= "1") 
            and (CLKFBOUT_DESKEW_ADJUST /= "2") 
            and (CLKFBOUT_DESKEW_ADJUST /= "3") 
            and (CLKFBOUT_DESKEW_ADJUST /= "4") 
            and (CLKFBOUT_DESKEW_ADJUST /= "5") 
            and (CLKFBOUT_DESKEW_ADJUST /= "6") 
            and (CLKFBOUT_DESKEW_ADJUST /= "7") 
            and (CLKFBOUT_DESKEW_ADJUST /= "8") 
            and (CLKFBOUT_DESKEW_ADJUST /= "9") 
            and (CLKFBOUT_DESKEW_ADJUST /= "10")
            and (CLKFBOUT_DESKEW_ADJUST /= "11")
            and (CLKFBOUT_DESKEW_ADJUST /= "12")
            and (CLKFBOUT_DESKEW_ADJUST /= "13")
            and (CLKFBOUT_DESKEW_ADJUST /= "14")
            and (CLKFBOUT_DESKEW_ADJUST /= "15")
            and (CLKFBOUT_DESKEW_ADJUST /= "16")
            and (CLKFBOUT_DESKEW_ADJUST /= "17")
            and (CLKFBOUT_DESKEW_ADJUST /= "18")
            and (CLKFBOUT_DESKEW_ADJUST /= "19")
            and (CLKFBOUT_DESKEW_ADJUST /= "20")
            and (CLKFBOUT_DESKEW_ADJUST /= "21")
            and (CLKFBOUT_DESKEW_ADJUST /= "22")
            and (CLKFBOUT_DESKEW_ADJUST /= "23")
            and (CLKFBOUT_DESKEW_ADJUST /= "24")
            and (CLKFBOUT_DESKEW_ADJUST /= "25")
            and (CLKFBOUT_DESKEW_ADJUST /= "26")
            and (CLKFBOUT_DESKEW_ADJUST /= "27")
            and (CLKFBOUT_DESKEW_ADJUST /= "28")
            and (CLKFBOUT_DESKEW_ADJUST /= "29")
            and (CLKFBOUT_DESKEW_ADJUST /= "30")
            and (CLKFBOUT_DESKEW_ADJUST /= "31" ) ) then 
               assert FALSE report "Error : CLKFBOUT_DESKEW_ADJUST is not NONE, PPC, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31." severity error;
       end if;  

       case PLL_PMCD_MODE is
          when TRUE => pmcd_mode <= '1';
          when FALSE => pmcd_mode <= '0';
           when others  =>  assert FALSE report "Attribute Syntax Error : PLL_PMCD_MODE is not TRUE or FALSE." severity error;
       end case;

       case CLKOUT0_DIVIDE is
           when   1 to 128 => NULL ;
           when others  =>  assert FALSE report "Attribute Syntax Error : CLKOUT0_DIVIDE is not in range 1...128." severity error;
       end case;

        if ((CLKOUT0_PHASE < -360.0) or (CLKOUT0_PHASE > 360.0)) then
            assert FALSE report "Attribute Syntax Error : CLKOUT0_PHASE is not in range -360.0 to 360.0" severity error;
        elsif (pmcd_mode = '1' and CLKOUT0_PHASE /= 0.0) then
           assert FALSE report "Attribute Syntax Error : CLKOUT0_PHASE need set to 0.0 when attribute PLL_PMCD_MODE is set to TRUE." severity error; 
        end if;

        if ((CLKOUT0_DUTY_CYCLE < 0.0) or (CLKOUT0_DUTY_CYCLE > 1.0)) then
             assert FALSE report "Attribute Syntax Error : CLKOUT0_DUTY_CYCLE is not real in range 0.0 to 1.0 pecentage."severity error;
        elsif (pmcd_mode = '1' and CLKOUT0_DUTY_CYCLE /= 0.5) then
             assert FALSE report "Attribute Syntax Error : CLKOUT0_DUTY_CYCLE need set to 0.5 when attribute PLL_PMCD_MODE is set to TRUE." severity error;
        end if;

       case CLKOUT1_DIVIDE is
           when   1 to 128 => NULL ;
           when others  =>  assert FALSE report "Attribute Syntax Error : CLKOUT1_DIVIDE is not in range 1...128." severity error;
       end case;

        if ((CLKOUT1_PHASE < -360.0) or (CLKOUT1_PHASE > 360.0)) then
            assert FALSE report "Attribute Syntax Error : CLKOUT1_PHASE is not in range -360.0 to 360.0" severity error;
        elsif (pmcd_mode = '1' and CLKOUT1_PHASE /= 0.0) then
           assert FALSE report "Attribute Syntax Error : CLKOUT1_PHASE need set to 0.0 when attribute PLL_PMCD_MODE is set to TRUE." severity error; 
        end if;

        if ((CLKOUT1_DUTY_CYCLE < 0.0) or (CLKOUT1_DUTY_CYCLE > 1.0)) then
             assert FALSE report "Attribute Syntax Error : CLKOUT1_DUTY_CYCLE is not real in range 0.0 to 1.0 pecentage."severity error;
        elsif (pmcd_mode = '1' and CLKOUT1_DUTY_CYCLE /= 0.5) then
             assert FALSE report "Attribute Syntax Error : CLKOUT1_DUTY_CYCLE need set to 0.5 when attribute PLL_PMCD_MODE is set to TRUE." severity error;
        end if;

       case CLKOUT2_DIVIDE is
           when   1 to 128 => NULL ;
           when others  =>  assert FALSE report "Attribute Syntax Error : CLKOUT2_DIVIDE is not in range 1...128." severity error;
       end case;

        if ((CLKOUT2_PHASE < -360.0) or (CLKOUT2_PHASE > 360.0)) then
            assert FALSE report "Attribute Syntax Error : CLKOUT2_PHASE is not in range -360.0 to 360.0" severity error;
        elsif (pmcd_mode = '1' and CLKOUT2_PHASE /= 0.0) then
           assert FALSE report "Attribute Syntax Error : CLKOUT2_PHASE need set to 0.0 when attribute PLL_PMCD_MODE is set to TRUE." severity error; 
        end if;

        if ((CLKOUT2_DUTY_CYCLE < 0.0) or (CLKOUT2_DUTY_CYCLE > 1.0)) then
             assert FALSE report "Attribute Syntax Error : CLKOUT2_DUTY_CYCLE is not real in range 0.0 to 1.0 pecentage."severity error;
        elsif (pmcd_mode = '1' and CLKOUT2_DUTY_CYCLE /= 0.5) then
             assert FALSE report "Attribute Syntax Error : CLKOUT2_DUTY_CYCLE need set to 0.5 when attribute PLL_PMCD_MODE is set to TRUE." severity error;
        end if;


       case CLKOUT3_DIVIDE is
           when   1 to 128 => NULL ;
           when others  =>  assert FALSE report "Attribute Syntax Error : CLKOUT3_DIVIDE is not in range 1...128." severity error;
       end case;

        if ((CLKOUT3_PHASE < -360.0) or (CLKOUT3_PHASE > 360.0)) then
            assert FALSE report "Attribute Syntax Error : CLKOUT3_PHASE is not in range -360.0 to 360.0" severity error;
        elsif (pmcd_mode = '1' and CLKOUT3_PHASE /= 0.0) then
           assert FALSE report "Attribute Syntax Error : CLKOUT3_PHASE need set to 0.0 when attribute PLL_PMCD_MODE is set to TRUE." severity error; 
        end if;

        if ((CLKOUT3_DUTY_CYCLE < 0.0) or (CLKOUT3_DUTY_CYCLE > 1.0)) then
             assert FALSE report "Attribute Syntax Error : CLKOUT3_DUTY_CYCLE is not real in range 0.0 to 1.0 pecentage."severity error;
        elsif (pmcd_mode = '1' and CLKOUT3_DUTY_CYCLE /= 0.5) then
             assert FALSE report "Attribute Syntax Error : CLKOUT3_DUTY_CYCLE need set to 0.5 when attribute PLL_PMCD_MODE is set to TRUE." severity error;
        end if;


       case CLKOUT4_DIVIDE is
           when   1 to 128 => NULL ;
           when others  =>  assert FALSE report "Attribute Syntax Error : CLKOUT4_DIVIDE is not in range 1...128." severity error;
       end case;

        if ((CLKOUT4_PHASE < -360.0) or (CLKOUT4_PHASE > 360.0)) then
            assert FALSE report "Attribute Syntax Error : CLKOUT4_PHASE is not in range -360.0 to 360.0" severity error;
        end if;

        if ((CLKOUT4_DUTY_CYCLE < 0.0) or (CLKOUT4_DUTY_CYCLE > 1.0)) then
             assert FALSE report "Attribute Syntax Error : CLKOUT4_DUTY_CYCLE is not real in range 0.0 to 1.0 pecentage."severity error;
        end if;

       case CLKOUT5_DIVIDE is
           when   1 to 128 => NULL ;
           when others  =>  assert FALSE report "Attribute Syntax Error : CLKOUT5_DIVIDE is not in range 1...128." severity error;
       end case;

        if ((CLKOUT5_PHASE < -360.0) or (CLKOUT5_PHASE > 360.0)) then
            assert FALSE report "Attribute Syntax Error : CLKOUT5_PHASE is not in range 360.0 to 360.0" severity error;
        end if;

        if ((CLKOUT5_DUTY_CYCLE < 0.0) or (CLKOUT5_DUTY_CYCLE > 1.0)) then
             assert FALSE report "Attribute Syntax Error : CLKOUT5_DUTY_CYCLE is not real in range 0.0 to 1.0 pecentage."severity error;
        end if;


       case CLKFBOUT_MULT is
           when   1 to 74 =>  NULL;
           when others  =>  assert FALSE report "Attribute Syntax Error : CLKFBOUT_MULT is not in range 1...74." severity error;
       end case;

       if ( CLKFBOUT_PHASE < -360.0 or CLKFBOUT_PHASE > 360.0 ) then
             assert FALSE report "Attribute Syntax Error : CLKFBOUT_PHASE is not in range -360.0 to 360.0" severity error;
        elsif (pmcd_mode = '1' and CLKFBOUT_PHASE /= 0.0) then
           assert FALSE report "Attribute Syntax Error : CLKFBOUT_PHASE need set to 0.0 when attribute PLL_PMCD_MODE is set to TRUE." severity error; 
       end if;

       case DIVCLK_DIVIDE is
       when    1  to 52 => NULL;

           when others  =>  assert FALSE report "Attribute Syntax Error : DIVCLK_DIVIDE is not in range 1...52." severity error;
       end case;

           if ((REF_JITTER < 0.0) or (REF_JITTER > 0.999)) then
             assert FALSE report "Attribute Syntax Error : REF_JITTER is not in range 0.0 ... 1.0." severity error;
           end if;

          if (((CLKIN1_PERIOD < 1.0) or (CLKIN1_PERIOD > 52.630)) and (pmcd_mode = '0') and (CLKINSEL = '1')) then
            assert FALSE report "Attribute Syntax Error : CLKIN1_PERIOD is not in range 1.0 ... 52.630" severity error;
          end if;

          if (((CLKIN2_PERIOD < 1.0) or (CLKIN2_PERIOD > 52.630)) and (pmcd_mode = '0') and (CLKINSEL = '0')) then
            assert FALSE report "Attribute Syntax Error : CLKIN2_PERIOD is not in range 1.0 ...  52.630" severity error;
          end if;

       case RESET_ON_LOSS_OF_LOCK is
           when FALSE   =>  rst_on_loss <= '0';
--           when TRUE    =>  rst_on_loss <= '1';
           when others  =>  assert FALSE report " Attribute Syntax Error : generic RESET_ON_LOSS_OF_LOCK must be set to FALSE for X_PLL_ADV to function correctly. Please correct the setting for the attribute and re-run the simulation." severity error;
       end case;

   write (con_line, O_MAX_HT_LT);
   write (con_line, string'(".0 "));
   write (con_line, CLKOUT0_DIVIDE);
   write (con_line, string'(".0 "));
   write (con_line, CLKOUT1_DIVIDE);
   write (con_line, string'(".0 "));
   write (con_line, CLKOUT2_DIVIDE);
   write (con_line, string'(".0 "));
   write (con_line, CLKOUT3_DIVIDE);
   write (con_line, string'(".0 "));
   write (con_line, CLKOUT4_DIVIDE);
   write (con_line, string'(".0 "));
   write (con_line, CLKOUT5_DIVIDE);
   write (con_line, string'(".0 "));
   read (con_line, tmpvalue);
   O_MAX_HT_LT_real := tmpvalue;
   read (con_line, skipspace);
   read (con_line, tmpvalue);
   CLKOUT0_DIVIDE_real := tmpvalue;
   read (con_line, skipspace);
   read (con_line, tmpvalue);
   CLKOUT1_DIVIDE_real := tmpvalue;
   read (con_line, skipspace);
   read (con_line, tmpvalue);
   CLKOUT2_DIVIDE_real := tmpvalue;
   read (con_line, skipspace);
   read (con_line, tmpvalue);
   CLKOUT3_DIVIDE_real := tmpvalue;
   read (con_line, skipspace);
   read (con_line, tmpvalue);
   CLKOUT4_DIVIDE_real := tmpvalue;
   read (con_line, skipspace);
   read (con_line, tmpvalue);
   CLKOUT5_DIVIDE_real := tmpvalue;
   DEALLOCATE (con_line);

    chk_ok := clkout_duty_chk (CLKOUT0_DIVIDE, CLKOUT0_DUTY_CYCLE, "CLKOUT0_DUTY_CYCLE");
    chk_ok := clkout_duty_chk (CLKOUT1_DIVIDE, CLKOUT1_DUTY_CYCLE, "CLKOUT1_DUTY_CYCLE");
    chk_ok := clkout_duty_chk (CLKOUT2_DIVIDE, CLKOUT2_DUTY_CYCLE, "CLKOUT2_DUTY_CYCLE");
    chk_ok := clkout_duty_chk (CLKOUT3_DIVIDE, CLKOUT3_DUTY_CYCLE, "CLKOUT3_DUTY_CYCLE");
    chk_ok := clkout_duty_chk (CLKOUT4_DIVIDE, CLKOUT4_DUTY_CYCLE, "CLKOUT4_DUTY_CYCLE");
    chk_ok := clkout_duty_chk (CLKOUT5_DIVIDE, CLKOUT5_DUTY_CYCLE, "CLKOUT5_DUTY_CYCLE");

   locked_en_time <= md_product +  clkout_en_time + 2;
   lock_cnt_max <= md_product +  clkout_en_time + 6 + 2;

--------PMCD --------------

    if (RST_DEASSERT_CLK = "CLKIN1") then
         rel_o_mux_sel <= '1';
    elsif (RST_DEASSERT_CLK = "CLKFBIN") then
         rel_o_mux_sel <= '0';
    else
     assert false report "Attribute Syntax Error : The attribute RST_DEASSERT_CLK on X_PLL_ADV should be CLKIN1 or CLKFBIN." severity error;
     end if;

        case EN_REL is
          when FALSE => clkdiv_rel_rst <= '0';
          when TRUE => clkdiv_rel_rst <= '1';
          when others   => assert false report "Attribute Syntax Error : The attribute EN_REL on X_PLL_ADV should be TRUE or FALSE." severity error;
        end case;

     wait;
  end process INIPROC;


--
-- PMCD function
--

-- *** Clocks MUX
--   rel_o_mux_clk_tmp <= clkin1_in when rel_o_mux_sel = '1' else clkfb_in;
   rel_o_mux_clk_tmp <= clkin1_in_dly when rel_o_mux_sel = '1' else clkfb_in;
   rel_o_mux_clk <= rel_o_mux_clk_tmp when (pmcd_mode = '1') else '0';
   clka1_in <= clkin1_in when (pmcd_mode = '1') else '0';
   clkb1_in <= clkfb_in when (pmcd_mode = '1')  else '0';

--*** Rel and Rst
    rel_rst_P : process(rel_o_mux_clk, rst_input)
    begin
      if (rst_input = '1') then
         qrel_o_reg1 <= '1';
         qrel_o_reg2 <= '1';
      else
         if (rising_edge(rel_o_mux_clk)) then
            qrel_o_reg1 <= '0';
         end if;

         if (falling_edge(rel_o_mux_clk)) then
            qrel_o_reg2 <= qrel_o_reg1;
          end if;
      end if;
   end process;

    qrel_o_reg3_P : process ( rel_in, rst_input)
    begin
      if (rst_input = '1') then
          qrel_o_reg3 <= '1';
      elsif (rising_edge(rel_in)) then
            qrel_o_reg3 <= '0';
      end if;
    end process;

    rel_rst_o <= (qrel_o_reg3 or qrel_o_reg1) when clkdiv_rel_rst = '1' else qrel_o_reg1;

--*** CLKA
    clka1_out_P : process (clka1_in, qrel_o_reg2)
    begin
        if (qrel_o_reg2 = '1') then
            clka1_out <= '0';
        elsif (qrel_o_reg2 = '0') then
            clka1_out <= clka1_in;
        end if;
    end process;

---** CLKB
    clkb1_out_P : process (clkb1_in, qrel_o_reg2)
    begin
        if (qrel_o_reg2 = '1') then
            clkb1_out <= '0';
        elsif (qrel_o_reg2 = '0') then
            clkb1_out <= clkb1_in;
        end if;
    end process;

--*** Clock divider
    clka1d2_out_P : process(clka1_in, rel_rst_o) 
    begin
        if (rel_rst_o = '1') then
            clka1d2_out <= '0';
        elsif (rising_edge(clka1_in)) then
            clka1d2_out <= not clka1d2_out;
       end if;
    end process;

    clka1d4_out_P : process (clka1d2_out, rel_rst_o) 
    begin
        if (rel_rst_o = '1') then
            clka1d4_out <= '0';
        elsif (rising_edge(clka1d2_out)) then
            clka1d4_out <= not clka1d4_out;
       end if;
    end process;

    clka1d8_out_P : process (clka1d4_out, rel_rst_o)
     begin
        if (rel_rst_o = '1') then
            clka1d8_out <= '0';
        elsif (rising_edge(clka1d4_out)) then
            clka1d8_out <= not clka1d8_out;
        end if;
    end process;

          clkout5_out_out <=  '0' when (pmcd_mode = '1') else clkout5_out;
          clkout4_out_out <= '0' when (pmcd_mode = '1') else clkout4_out;
          clkout3_out_out <= clka1_out  when (pmcd_mode = '1') else clkout3_out;
          clkout2_out_out <= clka1d2_out when (pmcd_mode = '1') else clkout2_out;
          clkout1_out_out <=  clka1d4_out when (pmcd_mode = '1') else  clkout1_out;
          clkout0_out_out <= clka1d8_out when (pmcd_mode = '1') else clkout0_out;
          clkfbout_out_out <=  clkb1_out when (pmcd_mode = '1') else clkfb_out;

--
-- PLL  function start
--  

    clkinsel_tmp <= clkinsel_in after 1 ps;

    clkinsel_p : process 
          variable period_clkin : real;
          variable clkvco_freq_init_chk : real;
          variable Message : line;
          variable tmpreal1 : real;
          variable tmpreal2 : real;
    begin
      if (NOW > 1 ps  and  rst_in = '0' and (clkinsel_tmp = '0' or clkinsel_tmp = '1')) then
          assert false report
            "Input Error : PLL input clock can only be switched when RST=1.  CLKINSEL is changed when RST low, should be changed at RST high." 
          severity error;
      end if;

      if (NOW = 0 ps) then
         wait for 1 ps;
      end if;

      if ( clkinsel_in='1') then
         period_clkin :=  CLKIN1_PERIOD;
      else
         period_clkin := CLKIN2_PERIOD;
      end if;
      
      tmpreal1 := int2real(CLKFBOUT_MULT);
      tmpreal2 := int2real(DIVCLK_DIVIDE);
      clkvco_freq_init_chk :=  (tmpreal1 / ( period_clkin * tmpreal2)) * 1000.0;
      
      if ((clkvco_freq_init_chk > VCOCLK_FREQ_MAX) or (clkvco_freq_init_chk < VCOCLK_FREQ_MIN)) then
         Write ( Message, string'(" Attribute Syntax Error : The calculation of VCO frequency="));
         Write ( Message, clkvco_freq_init_chk);
         Write ( Message, string'(" Mhz. This exceeds the permitted VCO frequency range of "));
         Write ( Message, VCOCLK_FREQ_MIN);
          Write ( Message, string'(" MHz to "));
          Write ( Message, VCOCLK_FREQ_MAX);
          Write ( Message, string'(" MHz. The VCO frequency is calculated with formula: VCO frequency =  CLKFBOUT_MULT / (DIVCLK_DIVIDE * CLKIN_PERIOD)."));
         Write ( Message, string'(" Please adjust the attributes to the permitted VCO frequency range."));
          assert false report Message.all severity error;
              DEALLOCATE (Message);
      end if;   

     wait on clkinsel_in;
     end process;

   clkpll <= clkin1_in when clkinsel_in = '1' else clkin2_in;
   
   RST_SYNC_P : process (clkpll, rst_input)
   begin
     if (rst_input = '1') then
        rst_in1 <= '1';
     elsif (rising_edge (clkpll)) then
        rst_in1 <= rst_input;
     end if;
   end process;

   rst_in <= rst_in1 or rst_unlock;

   RST_ON_LOSS_P : process (pll_unlock)
   begin
     if (rising_edge(pll_unlock)) then
      if (rst_on_loss = '1' and locked_out = '1') then
          rst_unlock <= '1', '0' after 10 ns;
      end if;
     end if;
   end process;

   RST_PW_P : process (rst_input)
      variable rst_edge : time := 0 ps;
      variable rst_ht : time := 0 ps;
   begin
      if (rising_edge(rst_input)) then
         rst_edge := NOW;
      elsif (falling_edge(rst_input)) then
         rst_ht := NOW - rst_edge;
         if (rst_ht < 10 ns and rst_ht > 0 ps) then
            assert false report
               "Input Error : RST must be asserted at least for 10 ns."
            severity error;
         end if;
      end if;
   end process;
     
---- 
----  DRP port read and write
----

   do_out <= dr_sram(daddr_in_lat);

  DRP_PROC : process
    variable address : integer;
    variable valid_daddr : boolean := false;
    variable Message : line;
    variable di_str : string (1 to 16);
    variable daddr_str : string ( 1 to 5);
    variable first_time : boolean := true;
    variable clk_ht : std_logic_vector (6 downto 0);
    variable tmp_ht : std_logic_vector (6 downto 0);
    variable clk_lt : std_logic_vector (6 downto 0);
    variable tmp_lt : std_logic_vector (6 downto 0);
    variable clk_nocnt : std_ulogic;
    variable clk_edge : std_ulogic;
    variable clkout_dly : std_logic_vector (5 downto 0);
    variable clkpm_sel : std_logic_vector (2 downto 0);
    variable tmpx : std_logic_vector (7 downto 0);
    variable clk0_hti : std_logic_vector (6 downto 0);
    variable clk1_hti : std_logic_vector (6 downto 0);
    variable clk2_hti : std_logic_vector (6 downto 0);
    variable clk3_hti : std_logic_vector (6 downto 0);
    variable clk4_hti : std_logic_vector (6 downto 0);
    variable clk5_hti : std_logic_vector (6 downto 0);
    variable clkfbm1_hti : std_logic_vector (6 downto 0);
    variable clk0_lti : std_logic_vector (6 downto 0);
    variable clk1_lti : std_logic_vector (6 downto 0);
    variable clk2_lti : std_logic_vector (6 downto 0);
    variable clk3_lti : std_logic_vector (6 downto 0);
    variable clk4_lti : std_logic_vector (6 downto 0);
    variable clk5_lti : std_logic_vector (6 downto 0);
    variable clkfbm1_lti : std_logic_vector (6 downto 0);
    variable clk0_nocnti : std_ulogic;
    variable clk1_nocnti : std_ulogic;
    variable clk2_nocnti : std_ulogic;
    variable clk3_nocnti : std_ulogic;
    variable clk4_nocnti : std_ulogic;
    variable clk5_nocnti : std_ulogic;
    variable clkfbm1_nocnti : std_ulogic;
    variable clk0_edgei  : std_ulogic;
    variable clk1_edgei  : std_ulogic;
    variable clk2_edgei  : std_ulogic;
    variable clk3_edgei  : std_ulogic;
    variable clk4_edgei  : std_ulogic;
    variable clk5_edgei  : std_ulogic;
    variable clkfbm1_edgei  : std_ulogic;
    variable clkout0_dlyi : std_logic_vector (5 downto 0);
    variable clkout1_dlyi : std_logic_vector (5 downto 0);
    variable clkout2_dlyi : std_logic_vector (5 downto 0);
    variable clkout3_dlyi : std_logic_vector (5 downto 0);
    variable clkout4_dlyi : std_logic_vector (5 downto 0);
    variable clkout5_dlyi : std_logic_vector (5 downto 0);
    variable clkfbm1_dlyi : std_logic_vector (5 downto 0);
    variable clk0pm_seli : std_logic_vector (2 downto 0);
    variable clk1pm_seli : std_logic_vector (2 downto 0);
    variable clk2pm_seli : std_logic_vector (2 downto 0);
    variable clk3pm_seli : std_logic_vector (2 downto 0);
    variable clk4pm_seli : std_logic_vector (2 downto 0);
    variable clk5pm_seli : std_logic_vector (2 downto 0);
    variable clkfbm1pm_seli : std_logic_vector (2 downto 0);
    variable clk_ht1 : integer;
    variable clk_div : integer;
    variable  clk_div1 : integer;
    variable clkind_hti : std_logic_vector (6 downto 0);
    variable clkind_lti : std_logic_vector (6 downto 0);
    variable clkind_nocnti : std_ulogic;
    variable clkind_edgei : std_ulogic;
    variable pll_cp : std_logic_vector (3 downto 0);
    variable pll_res : std_logic_vector (3 downto 0);
    variable pll_lfhf : std_logic_vector (1 downto 0);
    variable pll_cpres : std_logic_vector (1 downto 0) := "01";
    variable tmpadd : std_logic_vector (4 downto 0);
  begin

   if (first_time = true) then
   clk_out_para_cal (clk_ht, clk_lt, clk_nocnt, clk_edge, CLKOUT0_DIVIDE, CLKOUT0_DUTY_CYCLE);
   clk0_hti := clk_ht;
   clk0_lti := clk_lt;
   clk0_nocnti := clk_nocnt;
   clk0_edgei := clk_edge;
   clk0_ht <= clk0_hti;
   clk0_lt <= clk0_lti;
   clk0_nocnt <= clk0_nocnti;
   clk0_edge <= clk0_edgei;

   clk_out_para_cal (clk_ht, clk_lt, clk_nocnt, clk_edge, CLKOUT1_DIVIDE, CLKOUT1_DUTY_CYCLE);
   clk1_hti := clk_ht;
   clk1_lti := clk_lt;
   clk1_nocnti := clk_nocnt;
   clk1_edgei := clk_edge;
   clk1_ht <= clk1_hti;
   clk1_lt <= clk1_lti;
   clk1_nocnt <= clk1_nocnti;
   clk1_edge <= clk1_edgei;

   clk_out_para_cal (clk_ht, clk_lt, clk_nocnt, clk_edge, CLKOUT2_DIVIDE, CLKOUT2_DUTY_CYCLE);
   clk2_hti := clk_ht;
   clk2_lti := clk_lt;
   clk2_nocnti := clk_nocnt;
   clk2_edgei := clk_edge;
   clk2_ht <= clk2_hti;
   clk2_lt <= clk2_lti;
   clk2_nocnt <= clk2_nocnti;
   clk2_edge <= clk2_edgei;

   clk_out_para_cal (clk_ht, clk_lt, clk_nocnt, clk_edge, CLKOUT3_DIVIDE, CLKOUT3_DUTY_CYCLE);
   clk3_hti := clk_ht;
   clk3_lti := clk_lt;
   clk3_nocnti := clk_nocnt;
   clk3_edgei := clk_edge;
   clk3_ht <= clk3_hti;
   clk3_lt <= clk3_lti;
   clk3_nocnt <= clk3_nocnti;
   clk3_edge <= clk3_edgei;

   clk_out_para_cal (clk_ht, clk_lt, clk_nocnt, clk_edge, CLKOUT4_DIVIDE, CLKOUT4_DUTY_CYCLE);
   clk4_hti := clk_ht;
   clk4_lti := clk_lt;
   clk4_nocnti := clk_nocnt;
   clk4_edgei := clk_edge;
   clk4_ht <= clk4_hti;
   clk4_lt <= clk4_lti;
   clk4_nocnt <= clk4_nocnti;
   clk4_edge <= clk4_edgei;

   clk_out_para_cal (clk_ht, clk_lt, clk_nocnt, clk_edge, CLKOUT5_DIVIDE, CLKOUT5_DUTY_CYCLE);
   clk5_hti := clk_ht;
   clk5_lti := clk_lt;
   clk5_nocnti := clk_nocnt;
   clk5_edgei := clk_edge;
   clk5_ht <= clk5_hti;
   clk5_lt <= clk5_lti;
   clk5_nocnt <= clk5_nocnti;
   clk5_edge <= clk5_edgei;

   clk_out_para_cal (clk_ht, clk_lt, clk_nocnt, clk_edge, CLKFBOUT_MULT, 0.50);
   clkfbm1_hti := clk_ht;
   clkfbm1_lti := clk_lt;
   clkfbm1_nocnti := clk_nocnt;
   clkfbm1_edgei := clk_edge;
   clkfbm1_ht <= clkfbm1_hti;
   clkfbm1_lt <= clkfbm1_lti;
   clkfbm1_nocnt <= clkfbm1_nocnti;
   clkfbm1_edge <= clkfbm1_edgei;

   clk_out_para_cal (clk_ht, clk_lt, clk_nocnt, clk_edge, DIVCLK_DIVIDE, 0.50);
   clkind_hti := clk_ht;
   clkind_lti := clk_lt;
   clkind_nocnti := clk_nocnt;
   clkind_edgei := clk_edge;
   clkind_ht <= clkind_hti;
   clkind_lt <= clkind_lti;

   clkout_pm_cal(clk_ht1, clk_div, clk_div1, clk0_hti, clk0_lti, clk0_nocnti, clk0_edgei);
   clk0_ht1 <= clk_ht1;
   clk0_div <= clk_div;
   clk0_div1 <= clk_div1;
   clkout_pm_cal(clk_ht1, clk_div, clk_div1, clk1_hti, clk1_lti, clk1_nocnti, clk1_edgei);
   clk1_ht1 <= clk_ht1;
   clk1_div <= clk_div;
   clk1_div1 <= clk_div1;
   clkout_pm_cal(clk_ht1, clk_div, clk_div1, clk2_hti, clk2_lti, clk2_nocnti, clk2_edgei);
   clk2_ht1 <= clk_ht1;
   clk2_div <= clk_div;
   clk2_div1 <= clk_div1;
   clkout_pm_cal(clk_ht1, clk_div, clk_div1, clk3_hti, clk3_lti, clk3_nocnti, clk3_edgei);
   clk3_ht1 <= clk_ht1;
   clk3_div <= clk_div;
   clk3_div1 <= clk_div1;
   clkout_pm_cal(clk_ht1, clk_div, clk_div1, clk4_hti, clk4_lti, clk4_nocnti, clk4_edgei);
   clk4_ht1 <= clk_ht1;
   clk4_div <= clk_div;
   clk4_div1 <= clk_div1;
   clkout_pm_cal(clk_ht1, clk_div, clk_div1, clk5_hti, clk5_lti, clk5_nocnti, clk5_edgei);
   clk5_ht1 <= clk_ht1;
   clk5_div <= clk_div;
   clk5_div1 <= clk_div1;
   clkout_pm_cal(clk_ht1, clk_div, clk_div1, clkfbm1_hti, clkfbm1_lti, clkfbm1_nocnti, clkfbm1_edgei);
   clkfbm1_ht1 <= clk_ht1;
   clkfbm1_div <= clk_div;
   clkfbm1_div1 <= clk_div1;
   clkout_pm_cal(clk_ht1, clk_div, clk_div1, clkind_hti, clkind_lti, clkind_nocnti, '0');
   clkind_div <= clk_div;

   clkout_dly_cal (clkout_dly, clkpm_sel, CLKOUT0_DIVIDE, CLKOUT0_PHASE, "CLKOUT0_PHASE");
   clkout0_dly <= SLV_TO_INT(clkout_dly);
   clk0pm_sel <= SLV_TO_INT(clkpm_sel);
   clkout0_dlyi := clkout_dly;
   clk0pm_seli := clkpm_sel;
   
   clkout_dly_cal (clkout_dly, clkpm_sel, CLKOUT1_DIVIDE, CLKOUT1_PHASE, "CLKOUT1_PHASE");
   clkout1_dly <= SLV_TO_INT(clkout_dly);
   clk1pm_sel <= SLV_TO_INT(clkpm_sel);
   clkout1_dlyi := clkout_dly;
   clk1pm_seli := clkpm_sel;

   clkout_dly_cal (clkout_dly, clkpm_sel, CLKOUT2_DIVIDE, CLKOUT2_PHASE, "CLKOUT2_PHASE");
   clkout2_dly <= SLV_TO_INT(clkout_dly);
   clk2pm_sel <= SLV_TO_INT(clkpm_sel);
   clkout2_dlyi := clkout_dly;
   clk2pm_seli := clkpm_sel;
   clkout_dly_cal (clkout_dly, clkpm_sel, CLKOUT3_DIVIDE, CLKOUT3_PHASE, "CLKOUT3_PHASE");
   clkout3_dly <= SLV_TO_INT(clkout_dly);
   clk3pm_sel <= SLV_TO_INT(clkpm_sel);
   clkout3_dlyi := clkout_dly;
   clk3pm_seli := clkpm_sel;
   clkout_dly_cal (clkout_dly, clkpm_sel, CLKOUT4_DIVIDE, CLKOUT4_PHASE, "CLKOUT4_PHASE");
   clkout4_dly <= SLV_TO_INT(clkout_dly);
   clk4pm_sel <= SLV_TO_INT(clkpm_sel);
   clkout4_dlyi := clkout_dly;
   clk4pm_seli := clkpm_sel;
   clkout_dly_cal (clkout_dly, clkpm_sel, CLKOUT5_DIVIDE, CLKOUT5_PHASE, "CLKOUT5_PHASE");
   clkout5_dly <= SLV_TO_INT(clkout_dly);
   clk5pm_sel <= SLV_TO_INT(clkpm_sel);
   clkout5_dlyi := clkout_dly;
   clk5pm_seli := clkpm_sel;
   clkout_dly_cal (clkout_dly, clkpm_sel, CLKFBOUT_MULT, CLKFBOUT_PHASE, "CLKFBOUT_PHASE");
   clkfbm1_dly <= SLV_TO_INT(clkout_dly);
   clkfbm1pm_sel <= SLV_TO_INT(clkpm_sel);
   clkfbm1_dlyi := clkout_dly;
   clkfbm1pm_seli := clkpm_sel;
   
   case CLKFBOUT_MULT is
when  1   =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "1101"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0101"; pll_res := "1111"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0101"; pll_res := "1111"; pll_lfhf := "11"; end if;
when  2   =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "1110"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1110"; pll_res := "1111"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "1110"; pll_res := "1111"; pll_lfhf := "11"; end if;
when  3   =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "0110"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1111"; pll_res := "0111"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0110"; pll_res := "0101"; pll_lfhf := "11"; end if;
when  4   =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "1010"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1111"; pll_res := "1101"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0111"; pll_res := "1001"; pll_lfhf := "11"; end if;
when  5   =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "1100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1110"; pll_res := "0101"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "1101"; pll_res := "1001"; pll_lfhf := "11"; end if;
when  6   =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "1100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1111"; pll_res := "0101"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0111"; pll_res := "0001"; pll_lfhf := "11"; end if;
when  7   =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "1100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1111"; pll_res := "1001"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "1100"; pll_res := "0001"; pll_lfhf := "11"; end if;
when  8   =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "0010"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1111"; pll_res := "1110"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "1111"; pll_res := "1110"; pll_lfhf := "11"; end if;
when  9   =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "0010"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1111"; pll_res := "1110"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "1110"; pll_res := "0001"; pll_lfhf := "11"; end if;
when  10  =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1111"; pll_res := "0001"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "1111"; pll_res := "0001"; pll_lfhf := "11"; end if;
when  11  =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1111"; pll_res := "0001"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "1101"; pll_res := "0110"; pll_lfhf := "11"; end if;
when  12  =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1110"; pll_res := "0110"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "1110"; pll_res := "0110"; pll_lfhf := "11"; end if;
when  13  =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1110"; pll_res := "0110"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "1110"; pll_res := "0110"; pll_lfhf := "11"; end if;
when  14  =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1111"; pll_res := "0110"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "1111"; pll_res := "0110"; pll_lfhf := "11"; end if;
when  15  =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1110"; pll_res := "1010"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "1110"; pll_res := "1010"; pll_lfhf := "11"; end if;
when  16  =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1110"; pll_res := "1010"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "1110"; pll_res := "1010"; pll_lfhf := "11"; end if;
when  17  =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1111"; pll_res := "1010"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "1111"; pll_res := "1010"; pll_lfhf := "11"; end if;
when  18  =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1111"; pll_res := "1010"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "1111"; pll_res := "1010"; pll_lfhf := "11"; end if;
when  19  =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1111"; pll_res := "1010"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "1111"; pll_res := "1010"; pll_lfhf := "11"; end if;when  20  =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1111"; pll_res := "1010"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "1100"; pll_res := "1100"; pll_lfhf := "11"; end if;
when  21  =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1111"; pll_res := "1010"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "1100"; pll_res := "1100"; pll_lfhf := "11"; end if;
when  22  =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1101"; pll_res := "1100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "1101"; pll_res := "1100"; pll_lfhf := "11"; end if;
when  23  =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1101"; pll_res := "1100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "1101"; pll_res := "1100"; pll_lfhf := "11"; end if;
when  24  =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1101"; pll_res := "1100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0111"; pll_res := "0010"; pll_lfhf := "11"; end if;
when  25  =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1110"; pll_res := "1100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "1110"; pll_res := "1100"; pll_lfhf := "11"; end if;
when  26  =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1110"; pll_res := "1100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "1110"; pll_res := "1100"; pll_lfhf := "11"; end if;
when  27  =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1111"; pll_res := "1100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "1111"; pll_res := "1100"; pll_lfhf := "11"; end if;
when  28  =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1110"; pll_res := "1100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "1100"; pll_res := "0010"; pll_lfhf := "11"; end if;
when  29  =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1110"; pll_res := "1100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "1100"; pll_res := "0010"; pll_lfhf := "11"; end if;
when  30  =>    if (BANDWIDTH = "LOW") then pll_cp := "0001"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1110"; pll_res := "1100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "1100"; pll_res := "0010"; pll_lfhf := "11"; end if;
when  31  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1100"; pll_res := "0010"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "1100"; pll_res := "0010"; pll_lfhf := "11"; end if;
when  32  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1100"; pll_res := "0010"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "1100"; pll_res := "0010"; pll_lfhf := "11"; end if;
when  33  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "1111"; pll_res := "1010"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0100"; pll_res := "0100"; pll_lfhf := "11"; end if;
when  34  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0111"; pll_res := "0010"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0100"; pll_res := "0100"; pll_lfhf := "11"; end if;
when  35  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0111"; pll_res := "0010"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0100"; pll_res := "0100"; pll_lfhf := "11"; end if;
when  36  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0111"; pll_res := "0010"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0100"; pll_res := "0100"; pll_lfhf := "11"; end if;
when  37  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0110"; pll_res := "0010"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0100"; pll_res := "0100"; pll_lfhf := "11"; end if;
when  38  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0110"; pll_res := "0010"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0100"; pll_res := "0100"; pll_lfhf := "11"; end if;when  39  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0100"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0100"; pll_res := "0100"; pll_lfhf := "11"; end if;
when  40  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0100"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0011"; pll_res := "1000"; pll_lfhf := "11"; end if;
when  41  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0100"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0011"; pll_res := "1000"; pll_lfhf := "11"; end if;
when  42  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0100"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0011"; pll_res := "1000"; pll_lfhf := "11"; end if;
when  43  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0100"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0011"; pll_res := "1000"; pll_lfhf := "11"; end if;
when  44  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0100"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0011"; pll_res := "1000"; pll_lfhf := "11"; end if;
when  45  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0011"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0011"; pll_res := "1000"; pll_lfhf := "11"; end if;
when  46  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0011"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0011"; pll_res := "1000"; pll_lfhf := "11"; end if;
when  47  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0101"; pll_res := "0010"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11"; end if;
when  48  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0101"; pll_res := "0010"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11"; end if;
when  49  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0011"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11"; end if;
when  50  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0011"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11"; end if;
when  51  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0011"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11"; end if;
when  52  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0011"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11"; end if;
when  53  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0011"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11"; end if;
when  54  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0011"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11"; end if;
when  55  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0011"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0011"; pll_res := "0100"; pll_lfhf := "11"; end if;
when  56  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0011"; pll_res := "0100"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0011"; pll_res := "0100"; pll_lfhf := "11"; end if;
when  57  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11"; end if;when  58  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11"; end if;
when  59  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11"; end if;
when  60  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11"; end if;
when  61  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11"; end if;
when  62  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11"; end if;
when  63  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11"; end if;
when  64  =>    if (BANDWIDTH = "LOW") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "HIGH") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11";
 elsif (BANDWIDTH = "OPTIMIZED") then pll_cp := "0010"; pll_res := "1000"; pll_lfhf := "11"; end if;
when others => NULL;
  end case;

   tmpx := ('X' & 'X' & 'X' & 'X' & 'X' & 'X' & 'X' & 'X' );
   tmpadd := "11100";
   address := slv_to_int(tmpadd);
   dr_sram(address) <= (tmpx(7 downto 0) & clk0_edgei & clk0_nocnti & clkout0_dlyi(5 downto 0));
   tmpadd := "11011";
   address := slv_to_int(tmpadd);
   dr_sram(address) <= (clk0pm_seli(2 downto 0) & '1' & clk0_hti(5 downto 0) & clk0_lti(5 downto 0));
   tmpadd := "11010";
   address := slv_to_int(tmpadd);
   dr_sram(address) <= (tmpx(7 downto 0) & clk1_edgei & clk1_nocnti & clkout1_dlyi(5 downto 0));
   tmpadd := "11001";
   address := slv_to_int(tmpadd);
   dr_sram(address) <= (clk1pm_seli(2 downto 0) & '1' & clk1_hti(5 downto 0) & clk1_lti(5 downto 0));
   tmpadd := "10111";
   address := slv_to_int(tmpadd);
   dr_sram(address) <= (tmpx(7 downto 0) & clk2_edgei & clk2_nocnti & clkout2_dlyi(5 downto 0));
   tmpadd := "10110";
   address := slv_to_int(tmpadd);
   dr_sram(address) <= (clk2pm_seli(2 downto 0) & '1' & clk2_hti(5 downto 0) & clk2_lti(5 downto 0));
   tmpadd := "10101";
   address := slv_to_int(tmpadd);
   dr_sram(address) <= (tmpx(7 downto 0) & clk3_edgei & clk3_nocnti & clkout3_dlyi(5 downto 0));
   tmpadd := "10100";
   address := slv_to_int(tmpadd);
   dr_sram(address) <= (clk3pm_seli(2 downto 0) & '1' & clk3_hti(5 downto 0) & clk3_lti(5 downto 0));
   tmpadd := "10011";
   address := slv_to_int(tmpadd);
   dr_sram(address) <= (tmpx(7 downto 0) & clk4_edgei & clk4_nocnti & clkout4_dlyi(5 downto 0));
   tmpadd := "10010";
   address := slv_to_int(tmpadd);
   dr_sram(address) <= (clk4pm_seli(2 downto 0) & '1' & clk4_hti(5 downto 0) & clk4_lti(5 downto 0));
   tmpadd := "01111";
   address := slv_to_int(tmpadd);
   dr_sram(address) <= (tmpx(7 downto 0) & clk5_edgei & clk5_nocnti & clkout5_dlyi(5 downto 0));
   tmpadd := "01110";
   address := slv_to_int(tmpadd);
   dr_sram(address) <= (clk5pm_seli(2 downto 0) & '1' & clk5_hti(5 downto 0) & clk5_lti(5 downto 0));
   tmpadd := "01101";
   address := slv_to_int(tmpadd);
   dr_sram(address) <= (tmpx(7 downto 0) & clkfbm1_edgei & clkfbm1_nocnti & clkfbm1_dlyi(5 downto 0));
   tmpadd := "01100";
   address := slv_to_int(tmpadd);
   dr_sram(address) <= (clkfbm1pm_seli(2 downto 0) & '1' & clkfbm1_hti(5 downto 0) & clkfbm1_lti(5 downto 0));
   tmpadd := "00110";
   address := slv_to_int(tmpadd);
   dr_sram(address) <= (tmpx(1 downto 0) & clkind_edgei & clkind_nocnti & clkind_hti(5 downto 0) & clkind_lti(5 downto 0));
   tmpadd := "00001";
   address := slv_to_int(tmpadd);
   dr_sram(address) <= (tmpx(7 downto 0) & pll_lfhf & pll_cpres & pll_cp);
   tmpadd := "00000";
   address := slv_to_int(tmpadd);
   dr_sram(address) <= (tmpx(5 downto 0) & pll_res & tmpx(5 downto 0));

   first_time := false;

   end if;


    if (GSR = '1') then
       drp_lock <= '0';
    elsif (rising_edge(dclk_in)) then 
    if (den_in = '1') then
       valid_daddr := addr_is_valid(daddr_in);
       if (valid_daddr) then
         address := slv_to_int(daddr_in);
         daddr_in_lat <= address;
       end if;

        if (drp_lock = '1') then
          assert false report " Warning : DEN is high at X_PLL_ADV before DRDY high . Need wait for DRDY signal before next read/write operation through DRP. " severity  warning;
        else 
          drp_lock <= '1';
        end if;

        if (valid_daddr and ( address = 6  or address = 0 or address = 1 or ((address >= 12 and 
                                  address <= 28) and address /= 16 and address /= 17 and
                                  address /= 24))) then
              else 
      Write ( Message, string'(" Warning :  Address DADDR="));
      Write ( Message,  address);
      Write ( Message, string'(" on the X_PLL_ADV instance is unsupported") );
      Write ( Message, '.' & LF );
      assert false report Message.all severity warning;
      DEALLOCATE (Message);
             end if;

        if (dwe_in = '1')  then
          if (rst_input = '1') then
             if (valid_daddr and ( address = 6  or address = 0 or address = 1 or ((address >= 12 and 
                                  address <= 28) and address /= 16 and address /= 17 and
                                  address /= 24))) then
                  dr_sram(address) <= di_in;
                  di_str := SLV_TO_STR(di_in);
             end if;

             if (daddr_in = "11100") then
                 daddr_str := "11100";
                 clkout_delay_para_drp (clkout_dly, clk_nocnt, clk_edge, di_in, daddr_in, di_str, daddr_str);
                 clkout0_dly <= SLV_TO_INT(clkout_dly);
                 clk0_nocnt <= clk_nocnt;
                 clk0_nocnti := clk_nocnt;
                 clk0_edgei := clk_edge;
                 clk0_edge <= clk_edge;
             end if;

             if (daddr_in = "11011") then
                daddr_str := "11011";
                 clkout_hl_para_drp (clk_lt, clk_ht, clkpm_sel, di_in, daddr_in, di_str, daddr_str);
                 clk0_lt <= clk_lt;
                 clk0_ht <= clk_ht;
                 clk0_lti := clk_lt;
                 clk0_hti := clk_ht;
                 clk0pm_sel <=  SLV_TO_INT(clkpm_sel);
             end if;

             if (daddr_in = "11010") then
                 daddr_str := "11010";
                 clkout_delay_para_drp (clkout_dly, clk_nocnt, clk_edge, di_in, daddr_in, di_str, daddr_str);
                 clkout1_dly <= SLV_TO_INT(clkout_dly);
                 clk1_nocnt <= clk_nocnt;
                 clk1_nocnti := clk_nocnt;
                 clk1_edgei := clk_edge;
                 clk1_edge <= clk_edge;
             end if;


             if (daddr_in = "11001") then
                 daddr_str := "11001";
                 clkout_hl_para_drp (clk_lt, clk_ht, clkpm_sel, di_in, daddr_in, di_str, daddr_str);
                 clk1_lt <= clk_lt;
                 clk1_ht <= clk_ht;
                 clk1_lti := clk_lt;
                 clk1_hti := clk_ht;
                 clk1pm_sel <=  SLV_TO_INT(clkpm_sel);
             end if;

             if (daddr_in = "10111") then
                 daddr_str := "10111";
                 clkout_delay_para_drp (clkout_dly, clk_nocnt, clk_edge, di_in, daddr_in, di_str, daddr_str);
                 clkout2_dly <= SLV_TO_INT(clkout_dly);
                 clk2_nocnt <= clk_nocnt;
                 clk2_nocnti := clk_nocnt;
                 clk2_edgei := clk_edge;
                 clk2_edge <= clk_edge;
             end if;

             if (daddr_in = "10110") then
                 daddr_str := "10110";
                 clkout_hl_para_drp (clk_lt, clk_ht, clkpm_sel, di_in, daddr_in, di_str, daddr_str);
                 clk2_lt <= clk_lt;
                 clk2_ht <= clk_ht;
                 clk2_lti := clk_lt;
                 clk2_hti := clk_ht;
                 clk2pm_sel <=  SLV_TO_INT(clkpm_sel);
             end if;

             if (daddr_in = "10101") then
                 daddr_str := "10101";
                 clkout_delay_para_drp (clkout_dly, clk_nocnt, clk_edge, di_in, daddr_in, di_str, daddr_str);
                 clkout3_dly <= SLV_TO_INT(clkout_dly);
                 clk3_nocnt <= clk_nocnt;
                 clk3_nocnti := clk_nocnt;
                 clk3_edgei := clk_edge;
                 clk3_edge <= clk_edge;
             end if;

             if (daddr_in = "10100") then
                 daddr_str := "10100";
                 clkout_hl_para_drp (clk_lt, clk_ht, clkpm_sel, di_in, daddr_in, di_str, daddr_str);
                 clk3_lt <= clk_lt;
                 clk3_ht <= clk_ht;
                 clk3_lti := clk_lt;
                 clk3_hti := clk_ht;
                 clk3pm_sel <=  SLV_TO_INT(clkpm_sel);
             end if;

             if (daddr_in = "10011") then
                 daddr_str := "10011";
                 clkout_delay_para_drp (clkout_dly, clk_nocnt, clk_edge, di_in, daddr_in, di_str, daddr_str);
                 clkout4_dly <= SLV_TO_INT(clkout_dly);
                 clk4_nocnt <= clk_nocnt;
                 clk4_nocnti := clk_nocnt;
                 clk4_edgei := clk_edge;
                 clk4_edge <= clk_edge;
             end if;

             if (daddr_in = "10010") then
                 daddr_str := "10010";
                 clkout_hl_para_drp (clk_lt, clk_ht, clkpm_sel, di_in, daddr_in, di_str, daddr_str);
                 clk4_lt <= clk_lt;
                 clk4_ht <= clk_ht;
                 clk4_lti := clk_lt;
                 clk4_hti := clk_ht;
                 clk4pm_sel <=  SLV_TO_INT(clkpm_sel);
             end if;

             if (daddr_in = "01111") then
                 daddr_str := "01111";
                 clkout_delay_para_drp (clkout_dly, clk_nocnt, clk_edge, di_in, daddr_in, di_str, daddr_str);
                 clkout5_dly <= SLV_TO_INT(clkout_dly);
                 clk5_nocnt <= clk_nocnt;
                 clk5_nocnti := clk_nocnt;
                 clk5_edgei := clk_edge;
                 clk5_edge <= clk_edge;
             end if;

             if (daddr_in = "01110") then
                 daddr_str := "01110";
                 clkout_hl_para_drp (clk_lt, clk_ht, clkpm_sel, di_in, daddr_in, di_str, daddr_str);
                 clk5_lt <= clk_lt;
                 clk5_lti := clk_lt;
                 clk5_ht <= clk_ht;
                 clk5_hti := clk_ht;
                 clk5pm_sel <=  SLV_TO_INT(clkpm_sel);
             end if;

             if (daddr_in = "01101") then
                 daddr_str := "01101";
                 clkout_delay_para_drp (clkout_dly, clk_nocnt, clk_edge, di_in, daddr_in, di_str, daddr_str);
                 clkfbm1_dly <= SLV_TO_INT(clkout_dly);
                 clkfbm1_nocnt <= clk_nocnt;
                 clkfbm1_nocnti := clk_nocnt;
                 clkfbm1_edge <= clk_edge;
                 clkfbm1_edgei := clk_edge;
             end if;

             if (daddr_in = "01100") then
                 daddr_str := "01100";
                 clkout_hl_para_drp (clk_lt, clk_ht, clkpm_sel, di_in, daddr_in, di_str, daddr_str);
                 clkfbm1_lt <= clk_lt;
                 clkfbm1_lti := clk_lt;
                 clkfbm1_ht <= clk_ht;
                 clkfbm1_hti := clk_ht;
                 clkfbm1pm_sel <=  SLV_TO_INT(clkpm_sel);
             end if;

             if (daddr_in = "00110") then
                 clkind_lti := ('0' & di_in(11 downto 6));
                 clkind_hti := ('0' & di_in(5 downto 0));
                 clkind_lt <= clkind_lti;
                 clkind_ht <= clkind_hti;
                 clkind_nocnti := di_in(12);
                 clkind_edgei := di_in(13);
              end if;

   clkout_pm_cal(clk_ht1, clk_div, clk_div1, clk0_hti, clk0_lti, clk0_nocnti, clk0_edgei);
   clk0_ht1 <= clk_ht1;
   clk0_div <= clk_div;
   clk0_div1 <= clk_div1;
   clkout_pm_cal(clk_ht1, clk_div, clk_div1, clk1_hti, clk1_lti, clk1_nocnti, clk1_edgei);
   clk1_ht1 <= clk_ht1;
   clk1_div <= clk_div;
   clk1_div1 <= clk_div1;
   clkout_pm_cal(clk_ht1, clk_div, clk_div1, clk2_hti, clk2_lti, clk2_nocnti, clk2_edgei);
   clk2_ht1 <= clk_ht1;
   clk2_div <= clk_div;
   clk2_div1 <= clk_div1;
   clkout_pm_cal(clk_ht1, clk_div, clk_div1, clk3_hti, clk3_lti, clk3_nocnti, clk3_edgei);
   clk3_ht1 <= clk_ht1;
   clk3_div <= clk_div;
   clk3_div1 <= clk_div1;
   clkout_pm_cal(clk_ht1, clk_div, clk_div1, clk4_hti, clk4_lti, clk4_nocnti, clk4_edgei);
   clk4_ht1 <= clk_ht1;
   clk4_div <= clk_div;
   clk4_div1 <= clk_div1;
   clkout_pm_cal(clk_ht1, clk_div, clk_div1, clk5_hti, clk5_lti, clk5_nocnti, clk5_edgei);
   clk5_ht1 <= clk_ht1;
   clk5_div <= clk_div;
   clk5_div1 <= clk_div1;
   clkout_pm_cal(clk_ht1, clk_div, clk_div1, clkfbm1_hti, clkfbm1_lti, clkfbm1_nocnti, clkfbm1_edgei);
   clkfbm1_ht1 <= clk_ht1;
   clkfbm1_div <= clk_div;
   clkfbm1_div1 <= clk_div1;
   clkout_pm_cal(clk_ht1, clk_div, clk_div1, clkind_hti, clkind_lti, clkind_nocnti, '0');
   clkind_div <= clk_div;
   if (clk_div > 52 or (clk_div < 1 and clkind_nocnti = '0')) then
     assert false report " Input Error : The sum of DI[11:6] and DI[5:0] Address DADDR=00110 is input clock divider of X_PLL_ADV and over the 1 to 52 range." severity error;
   end if;

          else 
                 assert false report " Error : RST is low at X_PLL_ADV. RST need to be high when change X_PLL_ADV paramters through DRP. " severity error;
          end if; -- end rst

        end if; --DWE
    end if;  --DEN

    if ( drp_lock = '1') then
          drp_lock <= '0';
          drp_lock1 <= '1';
    end if;
    if (drp_lock1 = '1') then
         drp_lock1 <= '0';
         drdy_out <= '1';
    end if;
    if (drdy_out = '1') then
        drdy_out <= '0';
    end if;
 end if; -- end GSR

  wait on dclk_in, GSR;

end process;


   CLOCK_PERIOD_P : process (clkpll, rst_in)
      variable  clkin_edge_previous : time := 0 ps;
      variable  clkin_edge_current : time := 0 ps;
   begin
     if (rst_in = '1') then
        clkin_period(0) <= period_vco_target;
        clkin_period(1) <= period_vco_target;
        clkin_period(2) <= period_vco_target;
        clkin_period(3) <= period_vco_target;
        clkin_period(4) <= period_vco_target;
        clkin_jit <= 0 ps;
        clkin_lock_cnt <= 0;
        pll_locked_tm <= '0';
        pll_locked_tmp1 <= '0';
        lock_period <= '0';
        clkout_en0_tmp <= '0';
        unlock_recover <= '0';
        clkin_edge_previous := 0 ps;
     elsif (rising_edge(clkpll)) then
       clkin_edge_current := NOW;
       clkin_period(4) <= clkin_period(3);
       clkin_period(3) <= clkin_period(2);
       clkin_period(2) <= clkin_period(1);
       clkin_period(1) <= clkin_period(0);
       if (clkin_edge_previous /= 0 ps and  clkin_stopped_p = '0' and clkin_stopped_n = '0') then
          clkin_period(0) <= clkin_edge_current - clkin_edge_previous;
       end if;

       if (pll_unlock = '0') then
          clkin_jit <=  clkin_edge_current - clkin_edge_previous - clkin_period(0);
       else
          clkin_jit <= 0 ps;
       end if;

          clkin_edge_previous := clkin_edge_current;

      if ( pll_unlock = '0' and  (clkin_lock_cnt < lock_cnt_max) and fb_delay_found = '1' ) then
            clkin_lock_cnt <= clkin_lock_cnt + 1;
      elsif (pll_unlock = '1' and rst_on_loss = '0' and pll_locked_tmp1 = '1' ) then
            clkin_lock_cnt <= locked_en_time;
            unlock_recover <= '1';
      end if;

      if ( clkin_lock_cnt >= PLL_LOCK_TIME and pll_unlock = '0') then
        pll_locked_tm <= '1';
      end if;

      if ( clkin_lock_cnt = 6 ) then
        lock_period <= '1';
      end if;

      if (clkin_lock_cnt >= clkout_en_time) then
          clkout_en0_tmp <= '1';
      end if;
 
      if (clkin_lock_cnt >= locked_en_time) then
          pll_locked_tmp1 <= '1';
      end if;

      if (unlock_recover = '1' and clkin_lock_cnt  >= lock_cnt_max) then
          unlock_recover <= '0';
      end if;

    end if;
   end process;

   CLKOUT_EN_P : process 
   begin
      if (clkout_en0_tmp = '0') then
         clkout_en0 <= '0';
      else
        wait until (falling_edge(clkpll));
         clkout_en0 <= clkout_en0_tmp after (clkin_period(0)/2.0);
      end if;
     wait on clkout_en0_tmp;
   end process;

   PLL_LOCK_P1 : process (pll_locked_tmp1, rst_in)
   begin
     if (rst_in = '1') then
         pll_locked_tmp2 <= '0';
     elsif (pll_locked_tmp1 = '0') then
         pll_locked_tmp2 <=  pll_locked_tmp1;
     else 
--          wait until (rising_edge(clkvco));
          pll_locked_tmp2 <= pll_locked_tmp1 after pll_locked_delay;
     end if;
   end process;

   locked_out <= '1' when pll_locked_tm = '1' and pll_locked_tmp2 ='1' and pll_unlock = '0'
                         and unlock_recover = '0' else '0';

   CLOCK_PERIOD_AVG_P : process (clkin_period(0), clkin_period(1), clkin_period(2),
                                 clkin_period(3), clkin_period(4), period_avg)
      variable period_avg_tmp : time := 0.000 ps;
      variable clkin_period_tmp0 : time := 0.000 ps;
   begin
      clkin_period_tmp0 := clkin_period(0);
     if (clkin_period_tmp0 /= period_avg) then
         period_avg_tmp := (clkin_period(0) + clkin_period(1) + clkin_period(2)
                       + clkin_period(3) + clkin_period(4))/5.0;
         period_avg <= period_avg_tmp;
     end if;
   end process;

   CLOCK_PERIOD_UPDATE_P : process (period_avg, clkind_div, clkfbm1_div)
      variable period_fb_tmp : time;
      variable period_vco_tmp : time;
      variable tmpreal : real;
      variable tmpreal1: real;
      variable period_vco_rm_tmp : integer;
      variable period_vco_rm_tmp1 : integer;
   begin
       md_product <= clkfbm1_div * clkind_div;
       m_product <= clkfbm1_div;
       m_product2 <= clkfbm1_div / 2;
       period_fb_tmp :=  clkind_div * period_avg;
       period_vco_tmp := period_fb_tmp / clkfbm1_div;
       period_vco_rm_tmp1 := period_fb_tmp / 1 ps;
       period_vco_rm_tmp := period_vco_rm_tmp1 mod clkfbm1_div;
       period_vco_rm <= period_vco_rm_tmp;
   if (period_vco_rm > 1) then
      if (period_vco_rm > m_product2)  then
          period_vco_cmp_cnt <= (m_product / (m_product - period_vco_rm)) - 1;
          period_vco_cmp_flag <= 2;
      else 
         period_vco_cmp_cnt <= (m_product / period_vco_rm) - 1;
         period_vco_cmp_flag <= 1;
      end if;
   else 
      period_vco_cmp_cnt <= 0;
      period_vco_cmp_flag <= 0;
   end if;

       period_vco_half <= period_vco_tmp /2;
       period_vco_half1 <= ((period_vco_tmp /2) / 1 ps + 1) * 1 ps;
       period_vco_half_rm <= period_vco_tmp - (period_vco_tmp /2);
       pll_locked_delay <= period_fb_tmp * clkfbm1_div;
       clkin_dly_t <=  period_avg * clkind_div + period_avg * 1.25;
       clkfb_dly_t <= period_fb_tmp * 2.25; 
       period_fb <= period_fb_tmp;
       period_vco <= period_vco_tmp;
       period_vco1 <= period_vco_tmp / 8.0;
       period_vco2 <= period_vco_tmp / 4.0;
       period_vco3 <= period_vco_tmp * 3.0 / 8.0;
       period_vco4 <= period_vco_tmp / 2.0;
       period_vco5 <= period_vco_tmp * 5.0 / 8.0;
       period_vco6 <= period_vco_tmp * 3.0 / 4.0;
       period_vco7 <= period_vco_tmp * 7.0 / 8.0;
   end process;

   clkvco_lk_rst <=  '1' when ( rst_in = '1' or  pll_unlock = '1' or  pll_locked_tm = '0') else '0';

   CLKVCO_LK_P : process
       variable clkvco_rm_cnt : integer;
   begin
   if ( clkvco_lk_rst = '1') then
        clkvco_lk <= '0';
   else
     if (rising_edge(clkpll)) then
       if (pll_locked_tm = '1') then
          clkvco_lk <= '1';
          clkvco_rm_cnt := 0;
       if ( period_vco_cmp_flag = 1) then
          for I in 2 to m_product loop
               wait for (period_vco_half);
               clkvco_lk <=  '0';  
               if ( clkvco_rm_cnt = 1) then
                   wait for (period_vco_half1);
                   clkvco_lk <=  '1';  
               else
                   wait for (period_vco_half_rm);
                   clkvco_lk <=  '1';  
               end if;

               if ( clkvco_rm_cnt = period_vco_cmp_cnt) then
                  clkvco_rm_cnt := 0;
               else
                   clkvco_rm_cnt := clkvco_rm_cnt + 1;
               end if;
          end loop;
       elsif ( period_vco_cmp_flag = 2) then
          for I in 2 to m_product loop
               wait for (period_vco_half);
               clkvco_lk <=  '0';
               if ( clkvco_rm_cnt = 1) then
                   wait for (period_vco_half_rm);
                   clkvco_lk <=  '1';
               else
                   wait for (period_vco_half1);
                   clkvco_lk <=  '1';
               end if;

               if ( clkvco_rm_cnt = period_vco_cmp_cnt) then
                  clkvco_rm_cnt := 0;
               else
                   clkvco_rm_cnt := clkvco_rm_cnt + 1;
               end if;
          end loop;
       else
          for I in 2 to md_product loop
           wait for (period_vco_half);
           clkvco_lk <=  '0';

           wait for (period_vco_half_rm);
           clkvco_lk <=  '1';
          end loop;
       end if;
       wait for (period_vco_half);
       clkvco_lk <= '0';
      end if;
     end if;
   end if;
   wait on clkpll, rst_in ,  pll_unlock;
  end process;

  CLKVCO_DLY_CAL_P : process ( period_vco, fb_delay, clkfbm1_dly, clkfbm1pm_rl)
    variable val_tmp : integer;
    variable val_tmp2 : integer;
    variable val_tmp3 : integer;
    variable fbm1_comp_delay : integer;
    variable fbm1_comp_delay_rl : real;
    variable period_vco_i : integer;
    variable period_vco_rl : real;
    variable dly_tmp : integer;
    variable tmp_rl : real;
  begin
   if (fb_delay /= 0 ps and period_vco /= 0 ps) then
    period_vco_i := period_vco * 1 / 1 ps;
    period_vco_rl := int2real(period_vco_i);
    tmp_rl := int2real(clkfbm1_dly);
    val_tmp := period_vco_i * md_product;
    fbm1_comp_delay_rl := period_vco_rl *(tmp_rl  + clkfbm1pm_rl );
    fbm1_comp_delay := real2int(fbm1_comp_delay_rl);
    val_tmp2 := fb_delay * 1 / 1 ps;
    dly_tmp := val_tmp2 + fbm1_comp_delay;
    if ( dly_tmp < val_tmp) then
       clkvco_delay <= (val_tmp - dly_tmp) * 1 ps;
    else
       clkvco_delay <=  (val_tmp - dly_tmp mod val_tmp) * 1 ps;
    end if;
   end if;
  end process;

  CLKFB_PS_P : process (clkfbm1pm_sel)
  begin
    case (clkfbm1pm_sel) is
       when 0 => clkfbm1pm_rl <= 0.0;
       when 1 => clkfbm1pm_rl <= 0.125;
       when 2 => clkfbm1pm_rl <= 0.25;
       when 3 => clkfbm1pm_rl <= 0.375;
       when 4 => clkfbm1pm_rl <= 0.50;
       when 5 => clkfbm1pm_rl <= 0.625;
       when 6 => clkfbm1pm_rl <= 0.75;
       when 7 => clkfbm1pm_rl <= 0.875;
       when others => clkfbm1pm_rl <= 0.0;
    end case;
   end process;

   CLKVCO_FREE_P : process 
   begin
      if (pmcd_mode /= '1' and pll_locked_tm = '0') then
          wait for period_vco_target_half;
          clkvco_free <= not clkvco_free;
      end if;
      wait on clkvco_free;
   end process;
  
   CLKVCO_GEN_P : process ( pll_locked_tm, clkvco_lk, clkvco_free)
   begin
     if (pll_locked_tm = '1') then
          clkvco <= transport clkvco_lk after clkvco_delay;
     else
          clkvco <= transport clkvco_free after clkvco_delay;
     end if;
   end process;

   clkout_en <=  clkout_en0 after clkvco_delay;


  CLKOUT_MUX_P : process (clkvco, clkout_en, rst_in) 
  begin
   if (rst_in = '1') then
       clkout_mux <= "00000000";
   elsif (clkout_en = '1') then
       clkout_mux(0) <= clkvco;
       clkout_mux(1) <= transport clkvco after (period_vco1);
       clkout_mux(2) <= transport clkvco after (period_vco2);
       clkout_mux(3) <= transport clkvco after (period_vco3);
       clkout_mux(4) <= transport clkvco after (period_vco4);
       clkout_mux(5) <= transport clkvco after (period_vco5);
       clkout_mux(6) <= transport clkvco after (period_vco6);
       clkout_mux(7) <= transport clkvco after (period_vco7);
  end if;
  end process;

   clk0in <= clkout_mux(clk0pm_sel);
   clk1in <= clkout_mux(clk1pm_sel);
   clk2in <= clkout_mux(clk2pm_sel);
   clk3in <= clkout_mux(clk3pm_sel);
   clk4in <= clkout_mux(clk4pm_sel);
   clk5in <= clkout_mux(clk5pm_sel);
   clkfbm1in <= clkout_mux(clkfbm1pm_sel);

   clk0ps_en <= clkout_en when clk0_dly_cnt = clkout0_dly else '0';
   clk1ps_en <= clkout_en when clk1_dly_cnt = clkout1_dly else '0';
   clk2ps_en <= clkout_en when clk2_dly_cnt = clkout2_dly else '0';
   clk3ps_en <= clkout_en when clk3_dly_cnt = clkout3_dly else '0';
   clk4ps_en <= clkout_en when clk4_dly_cnt = clkout4_dly else '0';
   clk5ps_en <= clkout_en when clk5_dly_cnt = clkout5_dly else '0';
   clkfbm1ps_en <= clkout_en when clkfbm1_dly_cnt = clkfbm1_dly else '0';

   CLK_DLY_CNT_P : process(clk0in, clk1in, clk2in, clk3in, clk4in, clk5in, clkfbm1in,
                    rst_in)
   begin
     if (rst_in = '1') then
         clk0_dly_cnt <= 0;
         clk1_dly_cnt <= 0;
         clk2_dly_cnt <= 0;
         clk3_dly_cnt <= 0;
         clk4_dly_cnt <= 0;
         clk5_dly_cnt <= 0;
         clkfbm1_dly_cnt <= 0;
     else
       if (falling_edge(clk0in)) then
          if ((clk0_dly_cnt < clkout0_dly) and clkout_en = '1') then
            clk0_dly_cnt <= clk0_dly_cnt + 1;
          end if;
        end if;

       if (falling_edge(clk1in)) then
          if ((clk1_dly_cnt < clkout1_dly) and clkout_en = '1') then
            clk1_dly_cnt <= clk1_dly_cnt + 1;
          end if;
        end if;

       if (falling_edge(clk2in)) then
          if ((clk2_dly_cnt < clkout2_dly) and clkout_en = '1') then
            clk2_dly_cnt <= clk2_dly_cnt + 1;
          end if;
        end if;

       if (falling_edge(clk3in)) then
          if ((clk3_dly_cnt < clkout3_dly) and clkout_en = '1') then
            clk3_dly_cnt <= clk3_dly_cnt + 1;
          end if;
        end if;

       if (falling_edge(clk4in)) then
         if ((clk4_dly_cnt < clkout4_dly) and clkout_en = '1') then
            clk4_dly_cnt <= clk4_dly_cnt + 1;
         end if;
        end if;

       if (falling_edge(clk5in)) then
          if ((clk5_dly_cnt < clkout5_dly) and clkout_en = '1') then
            clk5_dly_cnt <= clk5_dly_cnt + 1;
          end if;
        end if;

       if (falling_edge(clkfbm1in)) then
          if ((clkfbm1_dly_cnt < clkfbm1_dly) and clkout_en = '1') then
            clkfbm1_dly_cnt <= clkfbm1_dly_cnt + 1;
          end if;
        end if;

    end if;
   end process;


   CLK0_GEN_P : process (clk0in, rst_in)
   begin
     if (rst_in = '1') then
         clk0_cnt <= 0;
         clk0_out <= '0';
     else
        if (rising_edge(clk0in) or falling_edge(clk0in)) then
            if (clk0ps_en = '1') then

              if (clk0_cnt < clk0_div1) then
                      clk0_cnt <= clk0_cnt + 1;
               else
                      clk0_cnt <= 0;
               end if;

               if  (clk0_cnt < clk0_ht1) then
                     clk0_out <= '1';
               else
                     clk0_out <= '0';
               end if;
          else
             clk0_out <= '0';
             clk0_cnt <= 0;
          end if;
        end if;
    end if;
   end process;
              
   CLK1_GEN_P : process (clk1in, rst_in)
   begin
     if (rst_in = '1') then
         clk1_cnt <= 0;
         clk1_out <= '0';
     else
        if (rising_edge(clk1in)  or falling_edge(clk1in)) then
            if (clk1ps_en = '1') then
              if (clk1_cnt < clk1_div1) then
                      clk1_cnt <= clk1_cnt + 1;
               else
                      clk1_cnt <= 0;
               end if;

               if  (clk1_cnt < clk1_ht1) then
                     clk1_out <= '1';
               else
                     clk1_out <= '0';
               end if;
          else
             clk1_out <= '0';
             clk1_cnt <= 0;
          end if;
        end if;
    end if;
   end process;


   CLK2_GEN_P : process (clk2in, rst_in)
   begin
     if (rst_in = '1') then
         clk2_cnt <= 0;
         clk2_out <= '0';
     else
        if (rising_edge(clk2in)  or falling_edge(clk2in)) then
            if (clk2ps_en = '1') then
              if (clk2_cnt < clk2_div1) then
                      clk2_cnt <= clk2_cnt + 1;
               else
                      clk2_cnt <= 0;
               end if;

               if  (clk2_cnt < clk2_ht1) then
                     clk2_out <= '1';
               else
                     clk2_out <= '0';
               end if;
          else
             clk2_out <= '0';
             clk2_cnt <= 0;
          end if;
        end if;
    end if;
   end process;


   CLK3_GEN_P : process (clk3in, rst_in)
   begin
     if (rst_in = '1') then
         clk3_cnt <= 0;
         clk3_out <= '0';
     else
        if (rising_edge(clk3in)  or falling_edge(clk3in)) then
            if (clk3ps_en = '1') then
               if  (clk3_cnt < clk3_ht1) then
                     clk3_out <= '1';
               else
                     clk3_out <= '0';
               end if;

              if (clk3_cnt < clk3_div1) then
                      clk3_cnt <= clk3_cnt + 1;
               else
                      clk3_cnt <= 0;
               end if;
          else
             clk3_out <= '0';
             clk3_cnt <= 0;
          end if;
        end if;
    end if;
   end process;


   CLK4_GEN_P : process (clk4in, rst_in)
   begin
     if (rst_in = '1') then
         clk4_cnt <= 0;
         clk4_out <= '0';
     else
        if (rising_edge(clk4in)  or falling_edge(clk4in)) then
            if (clk4ps_en = '1') then
              if (clk4_cnt < clk4_div1) then
                      clk4_cnt <= clk4_cnt + 1;
               else
                      clk4_cnt <= 0;
               end if;

               if  (clk4_cnt < clk4_ht1) then
                     clk4_out <= '1';
               else
                     clk4_out <= '0';
               end if;
          else
             clk4_out <= '0';
             clk4_cnt <= 0;
          end if;
        end if;
    end if;
   end process;


   CLK5_GEN_P : process (clk5in, rst_in)
   begin
     if (rst_in = '1') then
         clk5_cnt <= 0;
         clk5_out <= '0';
     else
        if (rising_edge(clk5in)  or falling_edge(clk5in)) then
            if (clk5ps_en = '1') then
              if (clk5_cnt < clk5_div1) then
                      clk5_cnt <= clk5_cnt + 1;
               else
                      clk5_cnt <= 0;
               end if;

               if  (clk5_cnt < clk5_ht1) then
                     clk5_out <= '1';
               else
                     clk5_out <= '0';
               end if;
          else
             clk5_out <= '0';
             clk5_cnt <= 0;
          end if;
        end if;
    end if;
   end process;


   CLKFB_GEN_P : process (clkfbm1in, rst_in)
   begin
     if (rst_in = '1') then
         clkfbm1_cnt <= 0;
         clkfbm1_out <= '0';
     else
        if (rising_edge(clkfbm1in)  or falling_edge(clkfbm1in)) then
            if (clkfbm1ps_en = '1') then
              if (clkfbm1_cnt < clkfbm1_div1) then
                      clkfbm1_cnt <= clkfbm1_cnt + 1;
               else
                      clkfbm1_cnt <= 0;
               end if;

               if  (clkfbm1_cnt < clkfbm1_ht1) then
                     clkfbm1_out <= '1';
               else
                     clkfbm1_out <= '0';
               end if;
          else
             clkfbm1_out <= '0';
             clkfbm1_cnt <= 0;
          end if;
        end if;
    end if;
   end process;

              
    clkout0_out <= transport clk0_out  when fb_delay_found = '1' else clkfb_tst;
    clkout1_out <= transport clk1_out  when fb_delay_found = '1' else clkfb_tst;
    clkout2_out <= transport clk2_out  when fb_delay_found = '1' else clkfb_tst;
    clkout3_out <= transport clk3_out  when fb_delay_found = '1' else clkfb_tst;
    clkout4_out <= transport clk4_out  when fb_delay_found = '1' else clkfb_tst;
    clkout5_out <= transport clk5_out  when fb_delay_found = '1' else clkfb_tst;
    clkfb_out <= transport clkfbm1_out  when fb_delay_found = '1' else clkfb_tst;

--
-- determine feedback delay
--

  CLKFB_TST_P : process (clkpll, rst_in1)
  begin
  if (rst_in1 = '1') then
       clkfb_tst <= '0';
  elsif (rising_edge(clkpll)) then
    if (fb_delay_found_tmp = '0' and GSR = '0') then
       clkfb_tst <=   '1';
     else
       clkfb_tst <=   '0';
    end if;
  end if;
  end process;

  FB_DELAY_CAL_P0 : process (clkfb_tst, rst_in1)
  begin
     if (rst_in1 = '1')  then
         delay_edge <= 0 ps;
     elsif (rising_edge(clkfb_tst)) then
        delay_edge <= NOW;
     end if;
  end process;

  FB_DELAY_CAL_P : process (clkfb_in, rst_in1)
      variable delay_edge1 : time := 0 ps;
      variable fb_delay_tmp : time := 0 ps;
      variable Message : line;
  begin
  if (rst_in1 = '1')  then
    fb_delay  <= 0 ps;
    fb_delay_found_tmp <= '0';
    delay_edge1 := 0 ps;
    fb_delay_tmp := 0 ps;
  elsif (clkfb_in'event and clkfb_in = '1') then
     if (fb_delay_found_tmp = '0') then
         if (delay_edge /= 0 ps) then
           delay_edge1 := NOW;
           fb_delay_tmp := delay_edge1 - delay_edge;
         else
           fb_delay_tmp := 0 ps;
        end if;
        fb_delay <= fb_delay_tmp;
        fb_delay_found_tmp <= '1';
        if (rst_in1 = '0' and fb_delay_tmp > fb_delay_max) then
            Write ( Message, string'(" Warning : The feedback delay is "));
            Write ( Message, fb_delay_tmp);
            Write ( Message, string'(". It is over the maximun value "));
            Write ( Message, fb_delay_max);
            Write ( Message, '.' & LF );
            assert false report Message.all severity warning;
            DEALLOCATE (Message);
         end if;
    end if;
  end if;
  end process;

   fb_delay_found <= fb_delay_found_tmp after clkvco_delay when rst_in1 = '0' else '0';

--
-- generate unlock signal
--

  clkpll_dly <= transport clkpll after clkin_dly_t;
  clkfb_in_dly <= transport clkfb_in after clkfb_dly_t when (pmcd_mode /= '1') else '0';

  CLKINSTOP_CNT_P : process (clkpll_dly,  clkpll, rst_in)
  begin

  if (rst_in = '1' or clkpll = '0') then
      clkstop_cnt_p <= 0;
      clkin_stopped_p <= '0';
  elsif ( rising_edge (clkpll_dly) ) then
   if (fb_delay_found = '1' and pll_locked_tmp2 = '1') then
      if (clkpll_jitter_unlock = '0' and clkpll = '1') then
         clkstop_cnt_p <=  clkstop_cnt_p + 1;
      else
         clkstop_cnt_p <= 0;
      end if;
      
      if (clkstop_cnt_p > clkin_stop_max) then
         clkin_stopped_p <= '1';
      else
         clkin_stopped_p <= '0';
      end if;
   else    
      clkstop_cnt_p <= 0;
      clkin_stopped_p <= '0';
   end if;
  end if;
  end process;

  CLKINSTOP_CNT_N : process (clkpll_dly,  clkpll, rst_in)
  begin

  if (rst_in = '1' or clkpll = '1') then
      clkstop_cnt_n <= 0;
      clkin_stopped_n <= '0';
  elsif ( rising_edge (clkpll_dly) ) then
   if (fb_delay_found = '1' and pll_locked_tmp2 = '1') then
      if (clkpll_jitter_unlock = '0' and clkpll = '0') then
         clkstop_cnt_n <=  clkstop_cnt_n + 1;
      else
         clkstop_cnt_n <= 0;
      end if;
      
      if (clkstop_cnt_n > clkin_stop_max) then
         clkin_stopped_n <= '1';
      else
         clkin_stopped_n <= '0';
      end if;
   else
      clkstop_cnt_n <= 0;
      clkin_stopped_n <= '0';
   end if;
  end if;
  end process;    

  CLKFBSTOP_CNT_PROC : process (clkfb_in_dly,  clkfb_in, rst_in)
  begin
  if (rst_in = '1' or clkfb_in = '0') then
      clkfbstop_cnt_p <= 0;
      clkfb_stopped_p <= '0';
  elsif ( rising_edge (clkfb_in_dly) ) then
   if (fb_delay_found = '1' and pll_locked_tmp2 = '1') then
      if (clkpll_jitter_unlock = '0' and clkfb_in = '1') then
         clkfbstop_cnt_p <=  clkfbstop_cnt_p + 1;
      else
         clkfbstop_cnt_p <= 0;
      end if;

      if (clkfbstop_cnt_p > clkfb_stop_max) then
         clkfb_stopped_p <= '1';
      else
         clkfb_stopped_p <= '0';
      end if;
   else
      clkfbstop_cnt_p <= 0;
      clkfb_stopped_p <= '0';
   end if;
  end if;
  end process;

  CLKFBSTOP_CNT_N_PROC : process (clkfb_in_dly,  clkfb_in, rst_in)
  begin

  if (rst_in = '1' or clkfb_in = '1') then
      clkfbstop_cnt_n <= 0;
      clkfb_stopped_n <= '0';
  elsif ( rising_edge (clkfb_in_dly) ) then
   if (fb_delay_found = '1' and pll_locked_tmp2 = '1') then
      if (clkpll_jitter_unlock = '0' and clkfb_in = '0') then
         clkfbstop_cnt_n <=  clkfbstop_cnt_n + 1;
      else
         clkfbstop_cnt_n <= 0;
      end if;

      if (clkfbstop_cnt_n > clkfb_stop_max) then
         clkfb_stopped_n <= '1';
      else
         clkfb_stopped_n <= '0';
      end if;
   else
      clkfbstop_cnt_n <= 0;
      clkfb_stopped_n <= '0';
   end if;
  end if;
  end process;

  CLK_JITTER_P : process (clkin_jit, rst_in)
  begin
  if (rst_in = '1') then
      clkpll_jitter_unlock <= '0';
  else
   if ( locked_out = '1' and clkfb_stopped = '0' and clkin_stopped = '0') then
      if  (ABS(clkin_jit) > ref_jitter_max_tmp) then
        clkpll_jitter_unlock <= '1';
      else
         clkpll_jitter_unlock <= '0';
      end if;
   else
         clkpll_jitter_unlock <= '0';
   end if;
  end if;
  end process;
     
   clkin_stopped <= '1' when (clkin_stopped_p = '1' or clkin_stopped_n = '1') else '0';
   clkfb_stopped <= '1' when (clkfb_stopped_p = '1' or clkfb_stopped_n = '1') else '0';

   pll_unlock <= clkin_stopped or clkfb_stopped or clkpll_jitter_unlock;

  schedule_outputs : process
    variable DRDY_GlitchData : VitalGlitchDataType;
      variable LOCKED_GlitchData : VitalGlitchDataType;
     variable  DO0_GlitchData : VitalGlitchDataType;
     variable  DO1_GlitchData : VitalGlitchDataType;
     variable  DO2_GlitchData : VitalGlitchDataType;
     variable  DO3_GlitchData : VitalGlitchDataType;
     variable  DO4_GlitchData : VitalGlitchDataType;
     variable  DO5_GlitchData : VitalGlitchDataType;
     variable  DO6_GlitchData : VitalGlitchDataType;
     variable  DO7_GlitchData : VitalGlitchDataType;
     variable  DO8_GlitchData : VitalGlitchDataType;
     variable  DO9_GlitchData : VitalGlitchDataType;
     variable  DO10_GlitchData : VitalGlitchDataType;
     variable  DO11_GlitchData : VitalGlitchDataType;
     variable  DO12_GlitchData : VitalGlitchDataType;
     variable  DO13_GlitchData : VitalGlitchDataType;
     variable  DO14_GlitchData : VitalGlitchDataType;
     variable  DO15_GlitchData : VitalGlitchDataType;
  begin

    VitalPathDelay01 (
      OutSignal  => LOCKED,
      GlitchData => LOCKED_GlitchData,
      OutSignalName => "LOCKED",
      OutTemp => locked_out,
      Paths => (0 => (locked_out'last_event, tpd_CLKIN1_LOCKED, true),
                1 => (locked_out'last_event, tpd_CLKIN2_LOCKED, true)),
      Mode => VitalTransport,
      Xon => Xon,
      MsgOn => MsgOn,
      MsgSeverity => warning
      );

    VitalPathDelay01 (
      OutSignal  => DRDY,
      GlitchData => DRDY_GlitchData,
      OutSignalName => "DRDY",
      OutTemp => drdy_out,
      Paths => (0 => (DCLK_dly'last_event, tpd_DCLK_DRDY, true)),
      Mode => VitalTransport,
      Xon => Xon,
      MsgOn => MsgOn,
      MsgSeverity => warning
      );
     VitalPathDelay01
       (
         OutSignal     => DO(0),
         GlitchData    => DO0_GlitchData,
         OutSignalName => "DO(0)",
         OutTemp       => DO_OUT(0),
         Paths         => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(0),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(1),
         GlitchData    => DO1_GlitchData,
         OutSignalName => "DO(1)",
         OutTemp       => DO_OUT(1),
         Paths         => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(1),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(2),
         GlitchData    => DO2_GlitchData,
         OutSignalName => "DO(2)",
         OutTemp       => DO_OUT(2),
         Paths         => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(2),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(3),
         GlitchData    => DO3_GlitchData,
         OutSignalName => "DO(3)",
         OutTemp       => DO_OUT(3),
         Paths         => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(3),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(4),
         GlitchData    => DO4_GlitchData,
         OutSignalName => "DO(4)",
         OutTemp       => DO_OUT(4),
         Paths         => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(4),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(5),
         GlitchData    => DO5_GlitchData,
         OutSignalName => "DO(5)",
         OutTemp       => DO_OUT(5),
         Paths         => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(5),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(6),
         GlitchData    => DO6_GlitchData,
         OutSignalName => "DO(6)",
         OutTemp       => DO_OUT(6),
         Paths         => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(6),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(7),
         GlitchData    => DO7_GlitchData,
         OutSignalName => "DO(7)",
         OutTemp       => DO_OUT(7),
         Paths         => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(7),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(8),
         GlitchData    => DO8_GlitchData,
         OutSignalName => "DO(8)",
         OutTemp       => DO_OUT(8),
         Paths         => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(8),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(9),
         GlitchData    => DO9_GlitchData,
         OutSignalName => "DO(9)",
         OutTemp       => DO_OUT(9),
         Paths         => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(9),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(10),
         GlitchData    => DO10_GlitchData,
         OutSignalName => "DO(10)",
         OutTemp       => DO_OUT(10),
         Paths         => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(10),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(11),
         GlitchData    => DO11_GlitchData,
         OutSignalName => "DO(11)",
         OutTemp       => DO_OUT(11),
         Paths         => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(11),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(12),
         GlitchData    => DO12_GlitchData,
         OutSignalName => "DO(12)",
         OutTemp       => DO_OUT(12),
         Paths         => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(12),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(13),
         GlitchData    => DO13_GlitchData,
         OutSignalName => "DO(13)",
         OutTemp       => DO_OUT(13),
         Paths         => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(13),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(14),
         GlitchData    => DO14_GlitchData,
         OutSignalName => "DO(14)",
         OutTemp       => DO_OUT(14),
         Paths         => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(14),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(15),
         GlitchData    => DO15_GlitchData,
         OutSignalName => "DO(15)",
         OutTemp       => DO_OUT(15),
         Paths         => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(15),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );

    wait on  drdy_out, locked_out, DO_OUT, DCLK_dly;
  end process schedule_outputs;


  VitalTimingCheck : process
    variable Pviol_CLKIN1  : std_ulogic := '0';
    variable PInfo_CLKIN1  : VitalPeriodDataType := VitalPeriodDataInit;   
    variable Pviol_CLKIN2  : std_ulogic := '0';
    variable PInfo_CLKIN2  : VitalPeriodDataType := VitalPeriodDataInit;   
    variable Pviol_CLKFBIN   : std_ulogic := '0';
    variable PInfo_CLKFBIN   : VitalPeriodDataType := VitalPeriodDataInit;
    variable Pviol_RST   : std_ulogic := '0';
    variable PInfo_RST   : VitalPeriodDataType := VitalPeriodDataInit;

     variable Tviol_DADDR0_DCLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DADDR0_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DADDR1_DCLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DADDR1_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DADDR2_DCLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DADDR2_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DADDR3_DCLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DADDR3_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DADDR4_DCLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DADDR4_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DADDR5_DCLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DADDR5_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DADDR6_DCLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DADDR6_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI0_DCLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI0_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI1_DCLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI1_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI2_DCLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI2_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI3_DCLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI3_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI4_DCLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI4_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI5_DCLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI5_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI6_DCLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI6_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI7_DCLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI7_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI8_DCLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI8_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI9_DCLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI9_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI10_DCLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI10_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI11_DCLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI11_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI12_DCLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI12_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI13_DCLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI13_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI14_DCLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI14_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI15_DCLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI15_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DWE_DCLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DWE_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DEN_DCLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DEN_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;    
     variable Tviol_REL_CLKIN1_negedge : STD_ULOGIC := '0';
     variable  Tmkr_REL_CLKIN1_negedge : VitalTimingDataType := VitalTimingDataInit;    
    
  begin
    if (TimingChecksOn) then

     VitalSetupHoldCheck
       (
         Violation      => Tviol_DADDR0_DCLK_posedge,
         TimingData     => Tmkr_DADDR0_DCLK_posedge,
         TestSignal     => DADDR_dly(0),
         TestSignalName => "DADDR(0)",
         TestDelay      => tisd_daddr_dclk(0),
         RefSignal      => DCLK_dly,
         RefSignalName  => "DCLK",
         RefDelay       => ticd_DCLK,
         SetupHigh      => tsetup_DADDR_DCLK_posedge_posedge(0),
         SetupLow       => tsetup_DADDR_DCLK_negedge_posedge(0),
         HoldLow        => thold_DADDR_DCLK_posedge_posedge(0),
         HoldHigh       => thold_DADDR_DCLK_negedge_posedge(0),
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_PLL_ADV",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DADDR1_DCLK_posedge,
         TimingData     => Tmkr_DADDR1_DCLK_posedge,
         TestSignal     => DADDR_dly(1),
         TestSignalName => "DADDR(1)",
         TestDelay      => tisd_daddr_dclk(1),
         RefSignal      => DCLK_dly,
         RefSignalName  => "DCLK",
         RefDelay       => ticd_DCLK,
         SetupHigh      => tsetup_DADDR_DCLK_posedge_posedge(1),
         SetupLow       => tsetup_DADDR_DCLK_negedge_posedge(1),
         HoldLow        => thold_DADDR_DCLK_posedge_posedge(1),
         HoldHigh       => thold_DADDR_DCLK_negedge_posedge(1),
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_PLL_ADV",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DADDR2_DCLK_posedge,
         TimingData     => Tmkr_DADDR2_DCLK_posedge,
         TestSignal     => DADDR_dly(2),
         TestSignalName => "DADDR(2)",
         TestDelay      => tisd_daddr_dclk(2),
         RefSignal      => DCLK_dly,
         RefSignalName  => "DCLK",
         RefDelay       => ticd_DCLK,
         SetupHigh      => tsetup_DADDR_DCLK_posedge_posedge(2),
         SetupLow       => tsetup_DADDR_DCLK_negedge_posedge(2),
         HoldLow        => thold_DADDR_DCLK_posedge_posedge(2),
         HoldHigh       => thold_DADDR_DCLK_negedge_posedge(2),
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_PLL_ADV",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DADDR3_DCLK_posedge,
         TimingData     => Tmkr_DADDR3_DCLK_posedge,
         TestSignal     => DADDR_dly(3),
         TestSignalName => "DADDR(3)",
         TestDelay      => tisd_daddr_dclk(3),
         RefSignal      => DCLK_dly,
         RefSignalName  => "DCLK",
         RefDelay       => ticd_DCLK,
         SetupHigh      => tsetup_DADDR_DCLK_posedge_posedge(3),
         SetupLow       => tsetup_DADDR_DCLK_negedge_posedge(3),
         HoldLow        => thold_DADDR_DCLK_posedge_posedge(3),
         HoldHigh       => thold_DADDR_DCLK_negedge_posedge(3),
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_PLL_ADV",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DADDR4_DCLK_posedge,
         TimingData     => Tmkr_DADDR4_DCLK_posedge,
         TestSignal     => DADDR_dly(4),
         TestSignalName => "DADDR(4)",
         TestDelay      => tisd_daddr_dclk(4),
         RefSignal      => DCLK_dly,
         RefSignalName  => "DCLK",
         RefDelay       => ticd_DCLK,
         SetupHigh      => tsetup_DADDR_DCLK_posedge_posedge(4),
         SetupLow       => tsetup_DADDR_DCLK_negedge_posedge(4),
         HoldLow        => thold_DADDR_DCLK_posedge_posedge(4),
         HoldHigh       => thold_DADDR_DCLK_negedge_posedge(4),
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_PLL_ADV",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI0_DCLK_posedge,
         TimingData     => Tmkr_DI0_DCLK_posedge,
         TestSignal     => DI_dly(0),
         TestSignalName => "DI(0)",
         TestDelay      => tisd_di_dclk(0),
         RefSignal      => DCLK_dly,
         RefSignalName  => "DCLK",
         RefDelay       => ticd_DCLK,
         SetupHigh      => tsetup_DI_DCLK_posedge_posedge(0),
         SetupLow       => tsetup_DI_DCLK_negedge_posedge(0),
         HoldLow        => thold_DI_DCLK_posedge_posedge(0),
         HoldHigh       => thold_DI_DCLK_negedge_posedge(0),
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_PLL_ADV",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI1_DCLK_posedge,
         TimingData     => Tmkr_DI1_DCLK_posedge,
         TestSignal     => DI_dly(1),
         TestSignalName => "DI(1)",
         TestDelay      => tisd_di_dclk(1),
         RefSignal      => DCLK_dly,
         RefSignalName  => "DCLK",
         RefDelay       => ticd_DCLK,
         SetupHigh      => tsetup_DI_DCLK_posedge_posedge(1),
         SetupLow       => tsetup_DI_DCLK_negedge_posedge(1),
         HoldLow        => thold_DI_DCLK_posedge_posedge(1),
         HoldHigh       => thold_DI_DCLK_negedge_posedge(1),
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_PLL_ADV",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI2_DCLK_posedge,
         TimingData     => Tmkr_DI2_DCLK_posedge,
         TestSignal     => DI_dly(2),
         TestSignalName => "DI(2)",
         TestDelay      => tisd_di_dclk(2),
         RefSignal      => DCLK_dly,
         RefSignalName  => "DCLK",
         RefDelay       => ticd_DCLK,
         SetupHigh      => tsetup_DI_DCLK_posedge_posedge(2),
         SetupLow       => tsetup_DI_DCLK_negedge_posedge(2),
         HoldLow        => thold_DI_DCLK_posedge_posedge(2),
         HoldHigh       => thold_DI_DCLK_negedge_posedge(2),
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_PLL_ADV",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI3_DCLK_posedge,
         TimingData     => Tmkr_DI3_DCLK_posedge,
         TestSignal     => DI_dly(3),
         TestSignalName => "DI(3)",
         TestDelay      => tisd_di_dclk(3),
         RefSignal      => DCLK_dly,
         RefSignalName  => "DCLK",
         RefDelay       => ticd_DCLK,
         SetupHigh      => tsetup_DI_DCLK_posedge_posedge(3),
         SetupLow       => tsetup_DI_DCLK_negedge_posedge(3),
         HoldLow        => thold_DI_DCLK_posedge_posedge(3),
         HoldHigh       => thold_DI_DCLK_negedge_posedge(3),
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_PLL_ADV",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI4_DCLK_posedge,
         TimingData     => Tmkr_DI4_DCLK_posedge,
         TestSignal     => DI_dly(4),
         TestSignalName => "DI(4)",
         TestDelay      => tisd_di_dclk(4),
         RefSignal      => DCLK_dly,
         RefSignalName  => "DCLK",
         RefDelay       => ticd_DCLK,
         SetupHigh      => tsetup_DI_DCLK_posedge_posedge(4),
         SetupLow       => tsetup_DI_DCLK_negedge_posedge(4),
         HoldLow        => thold_DI_DCLK_posedge_posedge(4),
         HoldHigh       => thold_DI_DCLK_negedge_posedge(4),
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_PLL_ADV",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI5_DCLK_posedge,
         TimingData     => Tmkr_DI5_DCLK_posedge,
         TestSignal     => DI_dly(5),
         TestSignalName => "DI(5)",
         TestDelay      => tisd_di_dclk(5),
         RefSignal      => DCLK_dly,
         RefSignalName  => "DCLK",
         RefDelay       => ticd_DCLK,
         SetupHigh      => tsetup_DI_DCLK_posedge_posedge(5),
         SetupLow       => tsetup_DI_DCLK_negedge_posedge(5),
         HoldLow        => thold_DI_DCLK_posedge_posedge(5),
         HoldHigh       => thold_DI_DCLK_negedge_posedge(5),
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_PLL_ADV",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI6_DCLK_posedge,
         TimingData     => Tmkr_DI6_DCLK_posedge,
         TestSignal     => DI_dly(6),
         TestSignalName => "DI(6)",
         TestDelay      => tisd_di_dclk(6),
         RefSignal      => DCLK_dly,
         RefSignalName  => "DCLK",
         RefDelay       => ticd_DCLK,
         SetupHigh      => tsetup_DI_DCLK_posedge_posedge(6),
         SetupLow       => tsetup_DI_DCLK_negedge_posedge(6),
         HoldLow        => thold_DI_DCLK_posedge_posedge(6),
         HoldHigh       => thold_DI_DCLK_negedge_posedge(6),
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_PLL_ADV",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI7_DCLK_posedge,
         TimingData     => Tmkr_DI7_DCLK_posedge,
         TestSignal     => DI_dly(7),
         TestSignalName => "DI(7)",
         TestDelay      => tisd_di_dclk(7),
         RefSignal      => DCLK_dly,
         RefSignalName  => "DCLK",
         RefDelay       => ticd_DCLK,
         SetupHigh      => tsetup_DI_DCLK_posedge_posedge(7),
         SetupLow       => tsetup_DI_DCLK_negedge_posedge(7),
         HoldLow        => thold_DI_DCLK_posedge_posedge(7),
         HoldHigh       => thold_DI_DCLK_negedge_posedge(7),
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_PLL_ADV",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI8_DCLK_posedge,
         TimingData     => Tmkr_DI8_DCLK_posedge,
         TestSignal     => DI_dly(8),
         TestSignalName => "DI(8)",
         TestDelay      => tisd_di_dclk(8),
         RefSignal      => DCLK_dly,
         RefSignalName  => "DCLK",
         RefDelay       => ticd_DCLK,
         SetupHigh      => tsetup_DI_DCLK_posedge_posedge(8),
         SetupLow       => tsetup_DI_DCLK_negedge_posedge(8),
         HoldLow        => thold_DI_DCLK_posedge_posedge(8),
         HoldHigh       => thold_DI_DCLK_negedge_posedge(8),
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_PLL_ADV",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI9_DCLK_posedge,
         TimingData     => Tmkr_DI9_DCLK_posedge,
         TestSignal     => DI_dly(9),
         TestSignalName => "DI(9)",
         TestDelay      => tisd_di_dclk(9),
         RefSignal      => DCLK_dly,
         RefSignalName  => "DCLK",
         RefDelay       => ticd_DCLK,
         SetupHigh      => tsetup_DI_DCLK_posedge_posedge(9),
         SetupLow       => tsetup_DI_DCLK_negedge_posedge(9),
         HoldLow        => thold_DI_DCLK_posedge_posedge(9),
         HoldHigh       => thold_DI_DCLK_negedge_posedge(9),
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_PLL_ADV",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI10_DCLK_posedge,
         TimingData     => Tmkr_DI10_DCLK_posedge,
         TestSignal     => DI_dly(10),
         TestSignalName => "DI(10)",
         TestDelay      => tisd_di_dclk(10),
         RefSignal      => DCLK_dly,
         RefSignalName  => "DCLK",
         RefDelay       => ticd_DCLK,
         SetupHigh      => tsetup_DI_DCLK_posedge_posedge(10),
         SetupLow       => tsetup_DI_DCLK_negedge_posedge(10),
         HoldLow        => thold_DI_DCLK_posedge_posedge(10),
         HoldHigh       => thold_DI_DCLK_negedge_posedge(10),
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_PLL_ADV",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI11_DCLK_posedge,
         TimingData     => Tmkr_DI11_DCLK_posedge,
         TestSignal     => DI_dly(11),
         TestSignalName => "DI(11)",
         TestDelay      => tisd_di_dclk(11),
         RefSignal      => DCLK_dly,
         RefSignalName  => "DCLK",
         RefDelay       => ticd_DCLK,
         SetupHigh      => tsetup_DI_DCLK_posedge_posedge(11),
         SetupLow       => tsetup_DI_DCLK_negedge_posedge(11),
         HoldLow        => thold_DI_DCLK_posedge_posedge(11),
         HoldHigh       => thold_DI_DCLK_negedge_posedge(11),
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_PLL_ADV",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI12_DCLK_posedge,
         TimingData     => Tmkr_DI12_DCLK_posedge,
         TestSignal     => DI_dly(12),
         TestSignalName => "DI(12)",
         TestDelay      => tisd_di_dclk(12),
         RefSignal      => DCLK_dly,
         RefSignalName  => "DCLK",
         RefDelay       => ticd_DCLK,
         SetupHigh      => tsetup_DI_DCLK_posedge_posedge(12),
         SetupLow       => tsetup_DI_DCLK_negedge_posedge(12),
         HoldLow        => thold_DI_DCLK_posedge_posedge(12),
         HoldHigh       => thold_DI_DCLK_negedge_posedge(12),
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_PLL_ADV",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI13_DCLK_posedge,
         TimingData     => Tmkr_DI13_DCLK_posedge,
         TestSignal     => DI_dly(13),
         TestSignalName => "DI(13)",
         TestDelay      => tisd_di_dclk(13),
         RefSignal      => DCLK_dly,
         RefSignalName  => "DCLK",
         RefDelay       => ticd_DCLK,
         SetupHigh      => tsetup_DI_DCLK_posedge_posedge(13),
         SetupLow       => tsetup_DI_DCLK_negedge_posedge(13),
         HoldLow        => thold_DI_DCLK_posedge_posedge(13),
         HoldHigh       => thold_DI_DCLK_negedge_posedge(13),
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_PLL_ADV",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI14_DCLK_posedge,
         TimingData     => Tmkr_DI14_DCLK_posedge,
         TestSignal     => DI_dly(14),
         TestSignalName => "DI(14)",
         TestDelay      => tisd_di_dclk(14),
         RefSignal      => DCLK_dly,
         RefSignalName  => "DCLK",
         RefDelay       => ticd_DCLK,
         SetupHigh      => tsetup_DI_DCLK_posedge_posedge(14),
         SetupLow       => tsetup_DI_DCLK_negedge_posedge(14),
         HoldLow        => thold_DI_DCLK_posedge_posedge(14),
         HoldHigh       => thold_DI_DCLK_negedge_posedge(14),
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_PLL_ADV",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI15_DCLK_posedge,
         TimingData     => Tmkr_DI15_DCLK_posedge,
         TestSignal     => DI_dly(15),
         TestSignalName => "DI(15)",
         TestDelay      => tisd_di_dclk(15),
         RefSignal      => DCLK_dly,
         RefSignalName  => "DCLK",
         RefDelay       => ticd_DCLK,
         SetupHigh      => tsetup_DI_DCLK_posedge_posedge(15),
         SetupLow       => tsetup_DI_DCLK_negedge_posedge(15),
         HoldLow        => thold_DI_DCLK_posedge_posedge(15),
         HoldHigh       => thold_DI_DCLK_negedge_posedge(15),
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_PLL_ADV",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DWE_DCLK_posedge,
         TimingData     => Tmkr_DWE_DCLK_posedge,
         TestSignal     => DWE_dly,
         TestSignalName => "DWE",
         TestDelay      => 0 ns,
         RefSignal      => DCLK_dly,
         RefSignalName  => "DCLK",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DWE_DCLK_posedge_posedge,
         SetupLow       => tsetup_DWE_DCLK_negedge_posedge,
         HoldLow        => thold_DWE_DCLK_posedge_posedge,
         HoldHigh       => thold_DWE_DCLK_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_PLL_ADV",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DEN_DCLK_posedge,
         TimingData     => Tmkr_DEN_DCLK_posedge,
         TestSignal     => DEN_dly,
         TestSignalName => "DEN",
         TestDelay      => 0 ns,
         RefSignal      => DCLK_dly,
         RefSignalName  => "DCLK",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DEN_DCLK_posedge_posedge,
         SetupLow       => tsetup_DEN_DCLK_negedge_posedge,
         HoldLow        => thold_DEN_DCLK_posedge_posedge,
         HoldHigh       => thold_DEN_DCLK_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_PLL_ADV",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );      

     VitalSetupHoldCheck
       (
         Violation      => Tviol_REL_CLKIN1_negedge,
         TimingData     => Tmkr_REL_CLKIN1_negedge,
         TestSignal     => REL_dly,
         TestSignalName => "REL",
         TestDelay      => 0 ns,
         RefSignal      => CLKIN1_dly,
         RefSignalName  => "CLKIN1",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_REL_CLKIN1_posedge_negedge,
         SetupLow       => tsetup_REL_CLKIN1_negedge_negedge,
         HoldLow        => thold_REL_CLKIN1_posedge_negedge,
         HoldHigh       => thold_REL_CLKIN1_negedge_negedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'F',
         HeaderMsg      => InstancePath & "/X_PLL_ADV",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );

      VitalPeriodPulseCheck (
        Violation               => Pviol_CLKIN1,
        PeriodData              => PInfo_CLKIN1,
        TestSignal              => CLKIN1_ipd, 
        TestSignalName          => "CLKIN1",
        TestDelay               => 0 ns,
        Period                  => tperiod_CLKIN1_POSEDGE,
        PulseWidthHigh          => tpw_CLKIN1_posedge,
        PulseWidthLow           => tpw_CLKIN1_negedge,
        CheckEnabled            => TO_X01(NOT RST_ipd)  /= '0',
        HeaderMsg               => InstancePath &"/X_PLL_ADV",
        Xon                     => Xon,
        MsgOn                   => MsgOn,
        MsgSeverity             => warning);         

      VitalPeriodPulseCheck (
        Violation               => Pviol_CLKIN2,
        PeriodData              => PInfo_CLKIN2,
        TestSignal              => CLKIN2_ipd,
        TestSignalName          => "CLKIN2",
        TestDelay               => 0 ns,
        Period                  => tperiod_CLKIN2_POSEDGE,
        PulseWidthHigh          => tpw_CLKIN2_posedge,
        PulseWidthLow           => tpw_CLKIN2_negedge,
        CheckEnabled            => TO_X01(NOT RST_ipd)  /= '0',
        HeaderMsg               => InstancePath &"/X_PLL_ADV",
        Xon                     => Xon,
        MsgOn                   => MsgOn,
        MsgSeverity             => warning);

      VitalPeriodPulseCheck (
        Violation               => Pviol_CLKFBIN,
        PeriodData              => PInfo_CLKFBIN,
        TestSignal              => CLKFBIN_ipd,
        TestSignalName          => "CLKFBIN",
        TestDelay               => 0 ns,
        Period                  => 0 ns,
        PulseWidthHigh          => tpw_CLKFBIN_posedge,
        PulseWidthLow           => tpw_CLKFBIN_negedge,
        CheckEnabled            => TO_X01(NOT RST_ipd)  /= '0',
        HeaderMsg               => InstancePath &"/X_PLL_ADV",
        Xon                     => Xon,
        MsgOn                   => MsgOn,
        MsgSeverity             => warning);


      VitalPeriodPulseCheck (
        Violation               => Pviol_RST,
        PeriodData              => PInfo_RST,
        TestSignal              => RST_ipd, 
        TestSignalName          => "RST",
        TestDelay               => 0 ns,
        Period                  => 0 ns,
        PulseWidthHigh          => tpw_RST_posedge,
        PulseWidthLow           => 0 ns,
        CheckEnabled            => true,
        HeaderMsg               => InstancePath &"/X_PLL_ADV",
        Xon                     => Xon,
        MsgOn                   => MsgOn,
        MsgSeverity             => warning);
    end if;
    wait on  CLKIN1_ipd, CLKIN2_ipd, RST_ipd, DCLK_dly, DEN_dly, DWE_dly, DI_dly, DADDR_dly;
  end process VITALTimingCheck;
  

end X_PLL_ADV_V;

