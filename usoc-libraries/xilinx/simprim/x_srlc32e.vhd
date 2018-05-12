-- $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/vhdsclibs/data/simprims/rainier/VITAL/Attic/x_srlc32e.vhd,v 1.6 2007/06/01 22:56:56 yanx Exp $
-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /           32-Bit Shift Register Look-Up-Table with Carry and Clock Enable
-- /___/   /\     Filename : X_SRLC32E.vhd
-- \   \  /  \    Timestamp : Thu Apr  8 10:57:20 PDT 2004
--  \___\/\___\
--
-- Revision:
--    03/15/05 - Initial version.
--    11/11/05 - Use SLV_TO_INT to decode the address.
--               Add Q31_zd to pathdelay block (CR 218909).
--    01/07/06 - Add LOC (CR 222733)
--    05/10/07 - Add violation to VITALPathDelay process (CR 438179).
-- End Revision

----- CELL X_SRLC32E -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library IEEE;
use IEEE.Vital_Primitives.all;
use IEEE.Vital_Timing.all;

library simprim;
use simprim.VPACKAGE.all;

entity X_SRLC32E is

  generic (
    TimingChecksOn : boolean := true;
    Xon            : boolean := true;
    MsgOn          : boolean := true;
   LOC            : string  := "UNPLACED";

      tipd_A : VitalDelayArrayType01(4 downto 0) := (others => (0.000 ns, 0.000 ns));
      tipd_CE : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CLK : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_D : VitalDelayType01 := (0.000 ns, 0.000 ns);

      tpd_A_Q : VitalDelayArrayType01(4 downto 0) := (others => (0.000 ns, 0.000 ns));
      tpd_CLK_Q : VitalDelayType01 := (0.100 ns, 0.100 ns);
      tpd_CLK_Q31 : VitalDelayType01 := (0.100 ns, 0.100 ns);

      tsetup_CE_CLK_negedge_posedge : VitalDelayType := 0.000 ns;
      tsetup_CE_CLK_posedge_posedge : VitalDelayType := 0.000 ns;
      tsetup_D_CLK_negedge_posedge : VitalDelayType := 0.000 ns;
      tsetup_D_CLK_posedge_posedge : VitalDelayType := 0.000 ns;

      thold_CE_CLK_negedge_posedge : VitalDelayType := 0.000 ns;
      thold_CE_CLK_posedge_posedge : VitalDelayType := 0.000 ns;
      thold_D_CLK_negedge_posedge : VitalDelayType := 0.000 ns;
      thold_D_CLK_posedge_posedge : VitalDelayType := 0.000 ns;

      ticd_CLK : VitalDelayType := 0.000 ns;
      tisd_CE_CLK : VitalDelayType := 0.000 ns;
      tisd_D_CLK : VitalDelayType := 0.000 ns;

      tperiod_CLK_posedge : VitalDelayType := 0.000 ns;

    INIT : bit_vector := X"00000000"
    );

  port (
    Q   : out std_ulogic;
    Q31 : out std_ulogic;
    A   : in  std_logic_vector(4 downto 0);
    CE  : in  std_ulogic;
    CLK : in  std_ulogic;
    D   : in  std_ulogic
    );

  attribute VITAL_LEVEL0 of
    X_SRLC32E : entity is true;
end X_SRLC32E;

architecture X_SRLC32E_V of X_SRLC32E is
  attribute VITAL_LEVEL0 of
    X_SRLC32E_V : architecture is true;

  signal A_ipd  : std_logic_vector(4 downto 0) := "XXXXX";
  signal CE_ipd  : std_ulogic := 'X';
  signal CLK_ipd : std_ulogic := 'X';
  signal D_ipd   : std_ulogic := 'X';

  signal CE_dly  : std_ulogic := 'X';
  signal CLK_dly : std_ulogic := 'X';
  signal D_dly   : std_ulogic := 'X';

  signal Q_zd      : std_ulogic                     := 'X';
  signal Q31_zd    : std_ulogic                     := 'X';
  signal SHIFT_REG : std_logic_vector (31 downto 0) :=  To_StdLogicVector(INIT);
  signal Violation : std_ulogic := '0';
begin
  WireDelay        : block
  begin
    A_DELAY       : for i in 4 downto 0 generate
    VitalWireDelay (A_ipd(i), A(i), tipd_A(i));
    end generate A_DELAY;
    VitalWireDelay (CE_ipd, CE, tipd_CE);
    VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
    VitalWireDelay (D_ipd, D, tipd_D);
  end block;

  SignalDelay : block
  begin
    VitalSignalDelay (CE_dly, CE_ipd, tisd_CE_CLK);
    VitalSignalDelay (CLK_dly, CLK_ipd, ticd_CLK);
    VitalSignalDelay (D_dly, D_ipd, tisd_D_CLK);
  end block;

    Q_zd   <= SHIFT_REG(SLV_TO_INT(SLV =>A));
    Q31_zd   <= SHIFT_REG(31);

  WriteBehavior : process(CLK_dly)
  begin
    if (CLK_dly'event AND CLK_dly = '1') then
      if (CE_dly = '1') then
        SHIFT_REG(31 downto 0) <= (SHIFT_REG(30 downto 0) & D_dly);
      end if;
    end if;
  end process WriteBehavior;

  VITALTiming                     : process (CLK_dly, CE_dly, D_dly)
    variable Tviol_D_CLK_posedge  : std_ulogic := '0';
    variable Tviol_CE_CLK_posedge : std_ulogic := '0';

    variable Tmkr_D_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_CE_CLK_posedge : VitalTimingDataType := VitalTimingDataInit;

    variable PViol_CLK : std_ulogic          := '0';
    variable PInfo_CLK : VitalPeriodDataType := VitalPeriodDataInit;
  begin
    if (TimingChecksOn) then
      VitalSetupHoldCheck (
        Violation      => Tviol_D_CLK_posedge,
        TimingData     => Tmkr_D_CLK_posedge,
        TestSignal     => D_dly,
        TestSignalName => "D",
        TestDelay      => tisd_D_CLK,
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_D_CLK_posedge_posedge,
        SetupLow       => tsetup_D_CLK_negedge_posedge,
        HoldLow        => thold_D_CLK_posedge_posedge,
        HoldHigh       => thold_D_CLK_negedge_posedge,
        CheckEnabled   => TO_X01(CE_dly) /= '0',
        RefTransition  => 'R',
        HeaderMsg      => "/X_SRLC32E",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_CE_CLK_posedge,
        TimingData     => Tmkr_CE_CLK_posedge,
        TestSignal     => CE_dly,
        TestSignalName => "CE",
        TestDelay      => tisd_CE_CLK,
        RefSignal      => CLK_dly,
        RefSignalName  => "CLK",
        RefDelay       => ticd_CLK,
        SetupHigh      => tsetup_CE_CLK_posedge_posedge,
        SetupLow       => tsetup_CE_CLK_negedge_posedge,
        HoldLow        => thold_CE_CLK_posedge_posedge,
        HoldHigh       => thold_CE_CLK_negedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/X_SRLC32E",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
      VitalPeriodPulseCheck (
        Violation      => Pviol_CLK,
        PeriodData     => PInfo_CLK,
        TestSignal     => CLK_dly,
        TestSignalName => "CLK",
        TestDelay      => 0 ps,
        Period         => tperiod_CLK_posedge,
        PulseWidthHigh => 0 ps,
        PulseWidthLow  => 0 ps,
        CheckEnabled   => true,
        HeaderMsg      => "/X_SRLC32E",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
    end if;
    Violation                       <= Tviol_D_CLK_posedge or Tviol_CE_CLK_posedge or
                                       Pviol_CLK;
  end process VITALTiming;

  VITALPathDelay            : process (Q_zd, Q31_zd, Violation)
    variable Q_zdt          : std_ulogic := '0';
    variable Q31_zdt        : std_ulogic := '0';
    variable Q_GlitchData   : VitalGlitchDataType;
    variable Q31_GlitchData : VitalGlitchDataType;
  begin
    Q_zdt                                := Q_zd;
    Q31_zdt                              := Q31_zd;
    Q_zdt                                := Violation xor Q_zdt;
    Q31_zdt                              := Violation xor Q31_zdt;
    VitalPathDelay01 (
      OutSignal     => Q,
      GlitchData    => Q_GlitchData,
      OutSignalName => "Q",
      OutTemp       => Q_zdt,
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_Q, (CE_dly /= '0')),
                        1  => (A_ipd(0)'last_event, tpd_A_Q(0), true),
                        2  => (A_ipd(1)'last_event, tpd_A_Q(1), true),
                        3  => (A_ipd(2)'last_event, tpd_A_Q(2), true),
                        4  => (A_ipd(3)'last_event, tpd_A_Q(3), true),
                        5  => (A_ipd(4)'last_event, tpd_A_Q(4), true)),
      Mode          => VitalInertial,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => Q31,
      GlitchData    => Q31_GlitchData,
      OutSignalName => "Q31",
      OutTemp       => Q31_zdt,
      Paths         => (0 => (CLK_dly'last_event, tpd_CLK_Q31, (CE_dly /= '0'))),
      Mode          => VitalInertial,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
  end process VITALPathDelay;
end X_SRLC32E_V;

------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  
-- /___/   /\     Filename : X_SYSMON.vhd
-- \   \  /  \    Timestamp : 
--  \___\/\___\
-- Revision:
--    03/24/06 - Initial version.
--    06/26/06 - remove SIM_MONITOR_FILE from file definition (CR 234006).
--    08/04/06 - Change tmp_dr_ram_out out range from 83 to 87 (CR235676).
--               Add 100 ps delay to output (CR235566).
--    08/30/06 - GSR only reset DRP port (CR 422678).
--    09/06/06 - Add internal 1 ns reset at time 0 (422678).
--    09/07/06 - Match verilog model: alarm_update pulse etc. (CR 424061).
--    09/26/06 - Update error messages; Make unipolar same as bipolar for external channels;
--             - etc. (CR426629).
--    10/26/06 - Add tipd for analog channel although not used (CR423564).
--    10/30/06 - Match HW timing (CR 428185)
--    12/13/06 - Reset eoc_out_temp1 when calibration channel (CR430923)
--               Change INIT_42 to 0800 (CR 429642).
-- End Revision

----- CELL X_SYSMON -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_SIGNED.all;
use IEEE.NUMERIC_STD.all;

library STD;
use STD.TEXTIO.all;

library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.VPACKAGE.all;
use simprim.VCOMPONENTS.all;

entity X_SYSMON is

generic (

-- begining timing generic

        TimingChecksOn : boolean := TRUE;
        InstancePath   : string  := "*";
        Xon            : boolean := TRUE;
        MsgOn          : boolean := FALSE;
        LOC            : string  := "UNPLACED";

        tperiod_DCLK_posedge : VitalDelayType := 0.0 ns;
        tperiod_CONVSTCLK_posedge : VitalDelayType := 0.0 ns;
        tperiod_CONVST_posedge : VitalDelayType := 0.0 ns;

        tipd_DI : VitalDelayArrayType01 (15 downto 0) := (others => (0.0 ns, 0.0 ns));
        tipd_DADDR : VitalDelayArrayType01 (6 downto 0) := (others => (0.0 ns, 0.0 ns));
        tipd_DEN : VitalDelayType01 :=  (0.0 ns, 0.0 ns);
        tipd_DWE : VitalDelayType01 :=  (0.0 ns, 0.0 ns);
        tipd_DCLK : VitalDelayType01 :=  (0.0 ns, 0.0 ns);
        tipd_CONVSTCLK : VitalDelayType01 :=  (0.0 ns, 0.0 ns);
        tipd_RESET : VitalDelayType01 :=  (0.0 ns, 0.0 ns);
        tipd_CONVST : VitalDelayType01 :=  (0.0 ns, 0.0 ns);
        tipd_VAUXN : VitalDelayArrayType01 (15 downto 0) := (others => (0.0 ns, 0.0 ns));
        tipd_VAUXP : VitalDelayArrayType01 (15 downto 0) := (others => (0.0 ns, 0.0 ns));
        tipd_VN : VitalDelayType01 :=  (0.0 ns, 0.0 ns);
        tipd_VP : VitalDelayType01 :=  (0.0 ns, 0.0 ns);
        

        tpd_DCLK_DO : VitalDelayArrayType01(15 downto 0) := (others => (0.1 ns, 0.1 ns));
        tpd_DCLK_DRDY : VitalDelayType01 := (0.1 ns, 0.1 ns);
        tpd_DCLK_JTAGBUSY : VitalDelayType01 := (0.0 ns, 0.0 ns);
        tpd_DCLK_JTAGMODIFIED : VitalDelayType01 := (0.0 ns, 0.0 ns);
        tpd_DCLK_JTAGLOCKED : VitalDelayType01 := (0.0 ns, 0.0 ns);
        tpd_DCLK_OT : VitalDelayType01 := (0.1 ns, 0.1 ns);
        tpd_DCLK_ALM : VitalDelayArrayType01(2 downto 0) := (others => (0.1 ns, 0.1 ns));
        tpd_DCLK_CHANNEL : VitalDelayArrayType01(4 downto 0) := (others => (0.1 ns, 0.1 ns));
        tpd_DCLK_EOC : VitalDelayType01 := (0.1 ns, 0.1 ns);
        tpd_DCLK_EOS : VitalDelayType01 := (0.1 ns, 0.1 ns);
        tpd_DCLK_BUSY : VitalDelayType01 := (0.1 ns, 0.1 ns);

        thold_DADDR_DCLK_negedge_posedge : VitalDelayArrayType(6 downto 0) := (others => 0.0 ns);
        thold_DADDR_DCLK_posedge_posedge : VitalDelayArrayType(6 downto 0) := (others => 0.0 ns);
        thold_DEN_DCLK_negedge_posedge : VitalDelayType := 0.0 ns;
        thold_DEN_DCLK_posedge_posedge : VitalDelayType := 0.0 ns;
        thold_DI_DCLK_negedge_posedge : VitalDelayArrayType(15 downto 0) := (others => 0.0 ns);
        thold_DI_DCLK_posedge_posedge : VitalDelayArrayType(15 downto 0) := (others => 0.0 ns);
        thold_DWE_DCLK_negedge_posedge : VitalDelayType := 0.0 ns;
        thold_DWE_DCLK_posedge_posedge : VitalDelayType := 0.0 ns;
        tsetup_DADDR_DCLK_negedge_posedge : VitalDelayArrayType(6 downto 0) := (others => 0.0 ns);
        tsetup_DADDR_DCLK_posedge_posedge : VitalDelayArrayType(6 downto 0) := (others => 0.0 ns);
        tsetup_DEN_DCLK_negedge_posedge : VitalDelayType := 0.0 ns;
        tsetup_DEN_DCLK_posedge_posedge : VitalDelayType := 0.0 ns;
        tsetup_DI_DCLK_negedge_posedge : VitalDelayArrayType(15 downto 0) := (others => 0.0 ns);
        tsetup_DI_DCLK_posedge_posedge : VitalDelayArrayType(15 downto 0) := (others => 0.0 ns);
        tsetup_DWE_DCLK_negedge_posedge : VitalDelayType := 0.0 ns;
        tsetup_DWE_DCLK_posedge_posedge : VitalDelayType := 0.0 ns;


        ticd_DCLK : VitalDelayType := 0.000 ns;

        tisd_DI : VitalDelayArrayType(15 downto 0) := (others => 0.000 ns);
        tisd_DADDR : VitalDelayArrayType(6 downto 0) := (others => 0.000 ns);
        tisd_DEN : VitalDelayType := 0.000 ns;
        tisd_DWE : VitalDelayType := 0.000 ns;

-- end_timing generic

                INIT_40 : bit_vector := X"0000";
                INIT_41 : bit_vector := X"0000";
                INIT_42 : bit_vector := X"0800";
                INIT_43 : bit_vector := X"0000";
                INIT_44 : bit_vector := X"0000";
                INIT_45 : bit_vector := X"0000";
                INIT_46 : bit_vector := X"0000";
                INIT_47 : bit_vector := X"0000";
                INIT_48 : bit_vector := X"0000";
                INIT_49 : bit_vector := X"0000";
                INIT_4A : bit_vector := X"0000";
                INIT_4B : bit_vector := X"0000";
                INIT_4C : bit_vector := X"0000";
                INIT_4D : bit_vector := X"0000";
                INIT_4E : bit_vector := X"0000";
                INIT_4F : bit_vector := X"0000";
                INIT_50 : bit_vector := X"0000";
                INIT_51 : bit_vector := X"0000";
                INIT_52 : bit_vector := X"0000";
                INIT_53 : bit_vector := X"0000";
                INIT_54 : bit_vector := X"0000";
                INIT_55 : bit_vector := X"0000";
                INIT_56 : bit_vector := X"0000";
                INIT_57 : bit_vector := X"0000";
                SIM_MONITOR_FILE : string := "design.txt"
  );

port (
                ALM : out std_logic_vector(2 downto 0);
                BUSY : out std_ulogic;
                CHANNEL : out std_logic_vector(4 downto 0);
                DO : out std_logic_vector(15 downto 0);
                DRDY : out std_ulogic;
                EOC : out std_ulogic;
                EOS : out std_ulogic;
                JTAGBUSY : out std_ulogic;
                JTAGLOCKED : out std_ulogic;
                JTAGMODIFIED : out std_ulogic;
                OT : out std_ulogic;

                CONVST : in std_ulogic;
                CONVSTCLK : in std_ulogic;
                DADDR : in std_logic_vector(6 downto 0);
                DCLK : in std_ulogic;
                DEN : in std_ulogic;
                DI : in std_logic_vector(15 downto 0);
                DWE : in std_ulogic;
                RESET : in std_ulogic;
                VAUXN : in std_logic_vector(15 downto 0);
                VAUXP : in std_logic_vector(15 downto 0);
                VN : in std_ulogic;
                VP : in std_ulogic
     );

  attribute VITAL_LEVEL0 of X_SYSMON : entity is true;

end X_SYSMON;


architecture X_SYSMON_V of X_SYSMON is
 
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

  ---------------------------------------------------------------------------
  -- Function SLV_TO_STR returns a string version of the std_logic_vector
  -- argument.
  ---------------------------------------------------------------------------
  function SLV_TO_STR (
    SLV : in std_logic_vector
    ) return string is

    variable j : integer := SLV'length;
    variable STR : string (SLV'length downto 1);
  begin
    for I in SLV'high downto SLV'low loop
      case SLV(I) is
        when '0' => STR(J) := '0';
        when '1' => STR(J) := '1';
        when 'X' => STR(J) := 'X';
        when 'U' => STR(J) := 'U';
        when others => STR(J) := 'X';
      end case;
      J := J - 1;
    end loop;
    return STR;
  end SLV_TO_STR;

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
    variable tmpt : time;
    variable tmpt1 : time;
    variable tmpa : real;
    variable tmpr : real;
    variable int_out : integer;
  begin
    tmpa := abs(real_in);
    tmpt := tmpa * 1 ps;
    int_value := (tmpt / 1 ps ) * 1;
    tmpt1 := int_value * 1 ps;
      tmpr := int2real(int_value);  

    if ( real_in < 0.0000) then
       if (tmpr > tmpa) then
           int_out := 1 - int_value;
       else
           int_out := -int_value;
       end if;
    else
      if (tmpr > tmpa) then 
           int_out := int_value - 1;
      else
           int_out := int_value;
      end if;
    end if;
    return int_out;
  end real2int;


    FUNCTION  To_Upper  ( CONSTANT  val    : IN String
                         ) RETURN STRING IS
        VARIABLE result   : string (1 TO val'LENGTH) := val;
        VARIABLE ch       : character;
    BEGIN
        FOR i IN 1 TO val'LENGTH LOOP
            ch := result(i);
            EXIT WHEN ((ch = NUL) OR (ch = nul));
            IF ( ch >= 'a' and ch <= 'z') THEN
                  result(i) := CHARACTER'VAL( CHARACTER'POS(ch)
                                       - CHARACTER'POS('a')
                                       + CHARACTER'POS('A') );
            END IF;
        END LOOP;
        RETURN result;
    END To_Upper;

    procedure get_token(buf : inout LINE; token : out string;
                            token_len : out integer) 
    is
       variable index : integer := buf'low;
       variable tk_index : integer := 0;
       variable old_buf : LINE := buf; 
    BEGIN
         while ((index <= buf' high) and ((buf(index) = ' ') or
                                         (buf(index) = HT))) loop
              index := index + 1; 
         end loop;
        
         while((index <= buf'high) and ((buf(index) /= ' ') and 
                                    (buf(index) /= HT))) loop 
              tk_index := tk_index + 1;
              token(tk_index) := buf(index);
              index := index + 1; 
         end loop;
   
         token_len := tk_index;
        
         buf := new string'(old_buf(index to old_buf'high));
           old_buf := NULL;
    END;

    procedure skip_blanks(buf : inout LINE) 
    is
         variable index : integer := buf'low;
         variable old_buf : LINE := buf; 
    BEGIN
         while ((index <= buf' high) and ((buf(index) = ' ') or 
                                       (buf(index) = HT))) loop
              index := index + 1; 
         end loop;
         buf := new string'(old_buf(index to old_buf'high));
           old_buf := NULL;
    END;

    procedure infile_format
    is
         variable message_line : line;
    begin

    write(message_line, string'("***** SYSMON Simulation Analog Data File Format ******"));
    writeline(output, message_line);
    write(message_line, string'("NAME: design.txt or user file name passed with generic sim_monitor_file"));
    writeline(output, message_line);
    write(message_line, string'("FORMAT: First line is header line. Valid column name are: TIME TEMP VCCINT VCCAUX VP VN VAUXP[0] VAUXN[0] ...."));
    writeline(output, message_line);
    write(message_line, string'("TIME must be in first column."));
    writeline(output, message_line);
    write(message_line, string'("Time value need to be integer in ns scale"));
    writeline(output, message_line);
    write(message_line, string'("Analog  value need to be real and contain a decimal  point '.', zero should be 0.0, 3 should be 3.0"));
    writeline(output, message_line);
    write(message_line, string'("Each line including header line can not have extra space after the last character/digit."));
    writeline(output, message_line);
    write(message_line, string'("Each data line must have same number of columns as the header line."));
    writeline(output, message_line);
    write(message_line, string'("Comment line start with -- or //"));
    writeline(output, message_line);
    write(message_line, string'("Example:"));
    writeline(output, message_line);
    write(message_line, string'("TIME TEMP VCCINT  VP VN VAUXP[0] VAUXN[0]"));
    writeline(output, message_line);
    write(message_line, string'("000  125.6  1.0  0.7  0.4  0.3  0.6"));
    writeline(output, message_line);
    write(message_line, string'("200  25.6   0.8  0.5  0.3  0.8  0.2"));
    writeline(output, message_line);

    end infile_format;

    type     REG_FILE   is  array (integer range <>) of 
                            std_logic_vector(15 downto 0);
    signal   dr_sram     :  REG_FILE(16#40# to 16#57#) := 
               ( 
                  16#40# => TO_STDLOGICVECTOR(INIT_40),
                  16#41# => TO_STDLOGICVECTOR(INIT_41),
                  16#42# => TO_STDLOGICVECTOR(INIT_42),
                  16#43# => TO_STDLOGICVECTOR(INIT_43),
                  16#44# => TO_STDLOGICVECTOR(INIT_44),
                  16#45# => TO_STDLOGICVECTOR(INIT_45),
                  16#46# => TO_STDLOGICVECTOR(INIT_46),
                  16#47# => TO_STDLOGICVECTOR(INIT_47),
                  16#48# => TO_STDLOGICVECTOR(INIT_48),
                  16#49# => TO_STDLOGICVECTOR(INIT_49),
                  16#4A# => TO_STDLOGICVECTOR(INIT_4A),
                  16#4B# => TO_STDLOGICVECTOR(INIT_4B),
                  16#4C# => TO_STDLOGICVECTOR(INIT_4C),
                  16#4D# => TO_STDLOGICVECTOR(INIT_4D),
                  16#4E# => TO_STDLOGICVECTOR(INIT_4E),
                  16#4F# => TO_STDLOGICVECTOR(INIT_4F),
                  16#50# => TO_STDLOGICVECTOR(INIT_50),
                  16#51# => TO_STDLOGICVECTOR(INIT_51),
                  16#52# => TO_STDLOGICVECTOR(INIT_52),
                  16#53# => TO_STDLOGICVECTOR(INIT_53),
                  16#54# => TO_STDLOGICVECTOR(INIT_54),
                  16#55# => TO_STDLOGICVECTOR(INIT_55),
                  16#56# => TO_STDLOGICVECTOR(INIT_56),
                  16#57# => TO_STDLOGICVECTOR(INIT_57)
               );

       signal ot_sf_limit_low_reg : unsigned(15 downto 0) := "1010111001000000";  --X"AE40";
       type     adc_statetype    is (INIT_STATE, ACQ_STATE, CONV_STATE, 
                                   ADC_PRE_END, END_STATE, SINGLE_SEQ_STATE);
       type     ANALOG_DATA    is array (0 to 31) of real;
       type     DR_data_reg    is array (0 to 63) of 
                                  std_logic_vector(15 downto 0);
       type     ACC_ARRAY      is array (0 to 31) of integer;
       type     int_array      is array(0 to 31) of integer;
       type     seq_array      is array(32 downto 0 ) of integer;

       signal   ot_limit_reg     : UNSIGNED(15 downto 0) := "1100011110000000";
       signal   adc_state         : adc_statetype := CONV_STATE;
       signal   next_state        : adc_statetype;
       signal   cfg_reg0         : std_logic_vector(15 downto 0) := "0000000000000000";
       signal   cfg_reg0_adc     : std_logic_vector(15 downto 0) := "0000000000000000";
       signal   cfg_reg0_seq     : std_logic_vector(15 downto 0) := "0000000000000000";
       signal   cfg_reg1         : std_logic_vector(15 downto 0) := "0000000000000000";
       signal   cfg_reg1_init    : std_logic_vector(15 downto 0) := "0000000000000000";
       signal   cfg_reg2         : std_logic_vector(15 downto 0) := "0000000000000000";
       signal   seq1_0           : std_logic_vector(1 downto 0) := "00";
       signal   curr_seq1_0      : std_logic_vector(1 downto 0) := "00";
       signal   curr_seq1_0_lat  : std_logic_vector(1 downto 0) := "00";
       signal   busy_r           : std_ulogic := '0';
       signal   busy_r_rst       : std_ulogic := '0';
       signal   busy_rst         : std_ulogic := '0';
       signal   busy_conv        : std_ulogic := '0';
       signal   busy_out_tmp     : std_ulogic := '0';
       signal   busy_out_dly     : std_ulogic := '0';
       signal   busy_out_sync    : std_ulogic := '0';
       signal   busy_out_low_edge : std_ulogic := '0';
       signal   shorten_acq      : integer := 1;
       signal   busy_seq_rst     : std_ulogic := '0';
       signal   busy_sync1       : std_ulogic := '0';
       signal   busy_sync2       : std_ulogic := '0';
       signal   busy_sync_fall   : std_ulogic := '0';
       signal   busy_sync_rise   : std_ulogic := '0';
       signal   cal_chan_update  : std_ulogic := '0';
       signal   first_cal_chan   : std_ulogic := '0';
       signal   seq_reset_flag   : std_ulogic := '0';
       signal   seq_reset_flag_dly   : std_ulogic := '0';
       signal   seq_reset_dly   : std_ulogic := '0';
       signal   seq_reset_busy_out  : std_ulogic := '0';
       signal   rst_in_not_seq   : std_ulogic := '0';
       signal   rst_in_out       : std_ulogic := '0';
       signal   rst_lock_early   : std_ulogic := '0';
       signal   conv_count       : integer := 0;
       signal   acq_count       : integer := 1;
       signal   do_out_rdtmp     : std_logic_vector(15 downto 0);
       signal   rst_in1          : std_ulogic := '0';
       signal   rst_in2          : std_ulogic := '0';
       signal   int_rst          : std_ulogic := '1';
       signal   rst_input_t      : std_ulogic := '0';
       signal   rst_in           : std_ulogic := '0';
       signal   ot_en            : std_logic := '1';
       signal   curr_clkdiv_sel  : std_logic_vector(7 downto 0) 
                                                  := "00000000";
       signal   curr_clkdiv_sel_int : integer := 0;
       signal   adcclk           : std_ulogic := '0';
       signal   adcclk_div1      : std_ulogic := '0';
       signal   sysclk           : std_ulogic := '0';
       signal   curr_adc_resl    : std_logic_vector(2 downto 0) := "010";
       signal   nx_seq           : std_logic_vector(15 downto 0) := "0000000000000000";
       signal   curr_seq         : std_logic_vector(15 downto 0) := "0000000000000000";
       signal   acq_cnt          : integer := 0;
       signal   acq_chan         : std_logic_vector(4 downto 0) := "00000";
       signal   acq_chan_index   : integer := 0;
       signal   acq_chan_lat     : std_logic_vector(4 downto 0) := "00000";
       signal   curr_chan        : std_logic_vector(4 downto 0) := "00000";
       signal   curr_chan_dly    : std_logic_vector(4 downto 0) := "00000";
       signal   curr_chan_lat    : std_logic_vector(4 downto 0) := "00000";
       signal   curr_avg_set     : std_logic_vector(1 downto 0) := "00";
       signal   acq_avg          : std_logic_vector(1 downto 0) := "00";
       signal   curr_e_c         : std_logic:= '0';
       signal   acq_e_c          : std_logic:= '0';
       signal   acq_b_u          : std_logic:= '0';
       signal   curr_b_u         : std_logic:= '0';
       signal   acq_acqsel       : std_logic:= '0';
       signal   curr_acq         : std_logic:= '0';
       signal   seq_cnt          : integer := 0;
       signal   busy_rst_cnt     : integer := 0;
       signal   adc_s1_flag      : std_ulogic := '0';
       signal   adc_convst       : std_ulogic := '0';
       signal   conv_start       : std_ulogic := '0';
       signal   conv_end         : std_ulogic := '0'; 
       signal   eos_en           : std_ulogic := '0';
       signal   eos_tmp_en       : std_ulogic := '0';
       signal   seq_cnt_en       : std_ulogic := '0'; 
       signal   eoc_en           : std_ulogic := '0';
       signal   eoc_en_delay       : std_ulogic := '0';
       signal   eoc_out_tmp     : std_ulogic := '0';
       signal   eos_out_tmp     : std_ulogic := '0';
       signal   eoc_out_tmp1     : std_ulogic := '0';
       signal   eos_out_tmp1     : std_ulogic := '0';
       signal   eoc_up_data      : std_ulogic := '0';
       signal   eoc_up_alarm    : std_ulogic := '0';
       signal   conv_time        : integer := 17;
       signal   conv_time_cal_1  : integer := 69;
       signal   conv_time_cal    : integer := 69;
       signal   conv_result      : std_logic_vector(15 downto 0) := "0000000000000000";
       signal   conv_result_reg  : std_logic_vector(15 downto 0) := "0000000000000000";
       signal   data_written     : std_logic_vector(15 downto 0) := "0000000000000000";
       signal   conv_result_int  : integer := 0;
       signal   conv_result_int_resl  : integer := 0;
       signal   analog_in_uni    : ANALOG_DATA :=(others=>0.0); 
       signal   analog_in_diff   : ANALOG_DATA :=(others=>0.0); 
       signal   analog_in        : ANALOG_DATA :=(others=>0.0); 
       signal   analog_in_comm   : ANALOG_DATA :=(others=>0.0); 
       signal   chan_val_tmp   : ANALOG_DATA :=(others=>0.0); 
       signal   chan_valn_tmp   : ANALOG_DATA :=(others=>0.0); 
       signal   data_reg         : DR_data_reg
                                  :=( 36 to 39 => "1111111111111111",
                                     others=>"0000000000000000");
       signal   tmp_data_reg_out : std_logic_vector(15 downto 0) := "0000000000000000";
       signal   tmp_dr_sram_out  : std_logic_vector(15 downto 0) := "0000000000000000";
       signal   seq_chan_reg1    : std_logic_vector(15 downto 0) := "0000000000000000";
       signal   seq_chan_reg2    : std_logic_vector(15 downto 0) := "0000000000000000";
       signal   seq_acq_reg1     : std_logic_vector(15 downto 0) := "0000000000000000";
       signal   seq_acq_reg2     : std_logic_vector(15 downto 0) := "0000000000000000";
       signal   seq_avg_reg1     : std_logic_vector(15 downto 0) := "0000000000000000";
       signal   seq_avg_reg2     : std_logic_vector(15 downto 0) := "0000000000000000";
       signal   seq_du_reg1      : std_logic_vector(15 downto 0) := "0000000000000000";
       signal   seq_du_reg2      : std_logic_vector(15 downto 0) := "0000000000000000";
       signal   seq_count        : integer := 1;
       signal   seq_count_en     : std_ulogic := '0';
       signal   conv_acc         : ACC_ARRAY :=(others=>0);
       signal   conv_avg_count   : ACC_ARRAY :=(others=>0);
       signal   conv_acc_vec     : std_logic_vector (20 downto 1);
       signal   conv_acc_result  : std_logic_vector(15 downto 0);
       signal   seq_status_avg   : integer := 0;
       signal   curr_chan_index       : integer := 0;
       signal   curr_chan_index_lat   : integer := 0;
       signal   conv_avg_cnt     : int_array :=(others=>0);
       signal   analog_mux_in    : real := 0.0;
       signal   adc_temp_result  : real := 0.0;
       signal   adc_intpwr_result : real := 0.0;
       signal   adc_ext_result    : real := 0.0;
       signal   seq_reset        : std_ulogic := '0';
       signal   seq_en           : std_ulogic := '0';
       signal   seq_en_drp       : std_ulogic := '0';
       signal   seq_en_init      : std_ulogic := '0';
       signal   seq_en_dly       : std_ulogic := '0';
       signal   seq_num          : integer := 0;
       signal   seq_mem          : seq_array :=(others=>0);
       signal   adc_seq_reset       : std_ulogic := '0';
       signal   adc_seq_en          : std_ulogic := '0';
       signal   adc_seq_reset_dly   : std_ulogic := '0';
       signal   adc_seq_en_dly      : std_ulogic := '0';
       signal   adc_seq_reset_hold  : std_ulogic := '0';
       signal   adc_seq_en_hold     : std_ulogic := '0';
       signal   rst_lock            : std_ulogic := '1';
       signal   sim_file_flag       : std_ulogic := '0';
       signal   gsr_in              : std_ulogic := '0';
       signal   convstclk_in       : std_ulogic := '0';
       signal   convst_raw_in      : std_ulogic := '0';
       signal   convst_in          : std_ulogic := '0';
       signal   dclk_in            : std_ulogic := '0';
       signal   den_in             : std_ulogic := '0';
       signal   rst_input          : std_ulogic := '0';
       signal   dwe_in             : std_ulogic := '0';
       signal   di_in              : std_logic_vector(15 downto 0) := "0000000000000000";
       signal   daddr_in           : std_logic_vector(6 downto 0) := "0000000";
       signal   daddr_in_lat       : std_logic_vector(6 downto 0) := "0000000";
       signal   daddr_in_lat_int   : integer := 0;
       signal   drdy_out_tmp1      : std_ulogic := '0';
       signal   drdy_out_tmp2      : std_ulogic := '0';
       signal   drdy_out_tmp3      : std_ulogic := '0';
       signal   drp_update         : std_ulogic := '0';
       signal   alarm_en           : std_logic_vector(2 downto 0) := "111";
       signal   alarm_update       : std_ulogic := '0';
       signal   adcclk_tmp         : std_ulogic := '0';
       signal   ot_out_reg         : std_ulogic := '0';
       signal   alarm_out_reg      : std_logic_vector(2 downto 0) := "000";
       signal   conv_end_reg_read  :  std_logic_vector(3 downto 0) := "0000";
       signal   busy_reg_read      : std_ulogic := '0';
       signal   single_chan_conv_end : std_ulogic := '0';
       signal   first_acq          : std_ulogic := '1';
       signal   conv_start_cont    : std_ulogic := '0';
       signal   conv_start_sel     : std_ulogic := '0';
       signal   reset_conv_start   : std_ulogic := '0';
       signal   reset_conv_start_tmp   : std_ulogic := '0';
       signal   busy_r_rst_done    : std_ulogic := '0';
       signal   op_count           : integer := 15;
      

-- Input/Output Pin signals

        signal   DI_ipd  :  std_logic_vector(15 downto 0);
        signal   DADDR_ipd  :  std_logic_vector(6 downto 0);
        signal   DEN_ipd  :  std_ulogic;
        signal   DWE_ipd  :  std_ulogic;
        signal   DCLK_ipd  :  std_ulogic;
        signal   CONVSTCLK_ipd  :  std_ulogic;
        signal   RESET_ipd  :  std_ulogic;
        signal   CONVST_ipd  :  std_ulogic;

        signal   do_out  :  std_logic_vector(15 downto 0) := "0000000000000000";
        signal   drdy_out  :  std_ulogic := '0';
        signal   ot_out  :  std_ulogic := '0';
        signal   alarm_out  :  std_logic_vector(2 downto 0) := "000";
        signal   channel_out  :  std_logic_vector(4 downto 0) := "00000";
        signal   eoc_out  :  std_ulogic := '0';
        signal   eos_out  :  std_ulogic := '0';
        signal   busy_out  :  std_ulogic := '0';

        signal   DI_dly  :  std_logic_vector(15 downto 0);
        signal   DADDR_dly  :  std_logic_vector(6 downto 0);
        signal   DEN_dly  :  std_ulogic;
        signal   DWE_dly  :  std_ulogic;
        signal   DCLK_dly  :  std_ulogic;
        signal   CONVSTCLK_dly  :  std_ulogic;
        signal   RESET_dly  :  std_ulogic;
        signal   CONVST_dly  :  std_ulogic;

begin 

        WireDelay : block
        begin
           DI_DELAY : for i in 15 downto 0 generate
              VitalWireDelay (DI_ipd(i),DI(i),tipd_DI(i));
           end generate DI_DELAY;
           DADDR_DELAY : for i in 6 downto 0 generate
              VitalWireDelay (DADDR_ipd(i),DADDR(i),tipd_DADDR(i));
           end generate DADDR_DELAY;
              VitalWireDelay (DEN_ipd,DEN,tipd_DEN);
              VitalWireDelay (DWE_ipd,DWE,tipd_DWE);
              VitalWireDelay (DCLK_ipd,DCLK,tipd_DCLK);
              VitalWireDelay (CONVSTCLK_ipd,CONVSTCLK,tipd_CONVSTCLK);
              VitalWireDelay (RESET_ipd,RESET,tipd_RESET);
              VitalWireDelay (CONVST_ipd,CONVST,tipd_CONVST);
        end block;

        SignalDelay : block
        begin
        DI_DELAY : for i in 15 downto 0 generate
        VitalSignalDelay (DI_dly(i),DI_ipd(i),tisd_DI(i));
        end generate DI_DELAY;
        DADDR_DELAY : for i in 6 downto 0 generate
        VitalSignalDelay (DADDR_dly(i),DADDR_ipd(i),tisd_DADDR(i));
        end generate DADDR_DELAY;
        VitalSignalDelay (DEN_dly,DEN_ipd,tisd_DEN);
        VitalSignalDelay (DWE_dly,DWE_ipd,tisd_DWE);
        VitalSignalDelay (DCLK_dly,DCLK_ipd,ticd_DCLK);
        end block;

-- for simprim assign
   CONVST_dly <= CONVST_ipd;
   CONVSTCLK_dly <= CONVSTCLK_ipd;
   RESET_dly <= RESET_ipd;
   convst_raw_in <= CONVST_dly;
   convstclk_in <= CONVSTCLK_dly;
   dclk_in <= DCLK_dly;
   den_in <= DEN_dly;
   rst_input <= RESET_dly;
   dwe_in <= DWE_dly;
   di_in <= Di_dly;
   daddr_in <= DADDR_dly;
-- end simprim assign
   


   gsr_in <= GSR;
   convst_in <= '1' when (convst_raw_in = '1' or convstclk_in = '1') else  '0';
   JTAGLOCKED <= '0';
   JTAGMODIFIED <= '0';
   JTAGBUSY <= '0';

   DEFAULT_CHECK : process
       variable init40h_tmp : std_logic_vector(15 downto 0);
       variable init41h_tmp : std_logic_vector(15 downto 0);
       variable init42h_tmp : std_logic_vector(15 downto 0);
       variable init4eh_tmp : std_logic_vector(15 downto 0);
       variable init40h_tmp_chan : integer;
       variable init42h_tmp_clk : integer;
       variable tmp_value : std_logic_vector(7 downto 0);
   begin
        init40h_tmp := TO_STDLOGICVECTOR(INIT_40);
        init40h_tmp_chan := SLV_TO_INT(SLV=>init40h_tmp(4 downto 0));
        init41h_tmp := TO_STDLOGICVECTOR(INIT_41);
        init42h_tmp := TO_STDLOGICVECTOR(INIT_42);
        tmp_value :=  init42h_tmp(15 downto 8);
        init42h_tmp_clk := SLV_TO_INT(SLV=>tmp_value);
        init4eh_tmp := TO_STDLOGICVECTOR(INIT_4E);
 
        if ((init41h_tmp(13 downto 12)="11") and (init40h_tmp(8)='1') and (init40h_tmp_chan /= 3 ) and (init40h_tmp_chan < 16)) then
          assert false report " Attribute Syntax warning : The attribute INIT_40 bit[8] must be set to 0 on X_SYSMON. Long acquistion mode is only allowed for external channels."
          severity warning;
        end if;

        if ((init41h_tmp(13 downto 12) /="11") and (init4eh_tmp(10 downto 0) /= "00000000000") and (init4eh_tmp(15 downto 12) /= "0000")) then
           assert false report " Attribute Syntax warning : The attribute INIT_4E Bit[15:12] and bit[10:0] must be set to 0. Long acquistion mode is only allowed for external channels."
          severity warning;
        end if;

        if ((init41h_tmp(13 downto 12)="11") and (init40h_tmp(9) = '1') and (init40h_tmp(4 downto 0) /= "00011") and (init40h_tmp_chan < 16)) then 
          assert false report " Attribute Syntax warning : The attribute INIT_40 bit[9] must be set to 0 on X_SYSMON. Event mode timing can only be used with external channels, and only in single channel mode."
          severity warning;
        end if;

        if ((init41h_tmp(13 downto 12)="11") and (init40h_tmp(13 downto 12) /= "00") and (INIT_48 /=X"0000") and (INIT_49 /= X"0000")) then
           assert false report " Attribute Syntax warning : The attribute INIT_48 and INIT_49 must be set to 0000h in single channel mode and averaging enabled."
          severity warning;
        end if;

        if (init42h_tmp(1 downto 0) /= "00") then
             assert false report
             " Attribute Syntax Error : The attribute INIT_42 Bit[1:0] must be set to 00."
              severity Error;
        end if;

        if (init42h_tmp_clk < 8) then
             assert false report
             " Attribute Syntax Error : The attribute INIT_42 Bit[15:8] is the ADC Clock divider and must be equal or greater than 8."
              severity failure;
        end if;

        if (INIT_43 /= "0000000000000000") then
             assert false report
             " Warning : The attribute INIT_43 must   be set to 0000."
             severity warning;
        end if;

        if (INIT_44 /= "0000000000000000") then
             assert false report
             " Warning : The attribute INIT_44 must   be set to 0000."
             severity warning;
        end if;

        if (INIT_45 /= "0000000000000000") then
             assert false report
             " Warning : The attribute INIT_45 must   be set to 0000."
             severity warning;
        end if;

        if (INIT_46 /= "0000000000000000") then
             assert false report
             " Warning : The attribute INIT_46 must   be set to 0000."
             severity warning;
        end if;

        if (INIT_47 /= "0000000000000000") then
             assert false report
             " Warning : The attribute INIT_47 must   be set to 0000."
             severity warning;
        end if;

         wait;
   end process;


   curr_chan_index <= SLV_TO_INT(curr_chan);
   curr_chan_index_lat <= SLV_TO_INT(curr_chan_lat);

  CHEK_COMM_P : process( busy_r )
       variable Message : line;
  begin 
  if (busy_r'event and busy_r = '1' ) then
   if (rst_in = '0' and acq_b_u = '0' and ((acq_chan_index = 3) or (acq_chan_index >= 16 and acq_chan_index <= 31))) then
      if ( chan_valn_tmp(acq_chan_index) > chan_val_tmp(acq_chan_index)) then
       Write ( Message, string'("Input File Warning: The N input for external channel "));
       Write ( Message, acq_chan_index);
       Write ( Message, string'(" must be smaller than P input when in unipolar mode (P="));
       Write ( Message, chan_val_tmp(acq_chan_index));
       Write ( Message, string'(" N="));
       Write ( Message, chan_valn_tmp(acq_chan_index));
       Write ( Message, string'(") for X_SYSMON."));
      assert false report Message.all severity warning;
      DEALLOCATE (Message);
    end if;

     if (( chan_valn_tmp(acq_chan_index) > 0.5) or  (chan_valn_tmp(acq_chan_index) < 0.0)) then
       Write ( Message, string'("Input File Warning: The N input for external channel "));
       Write ( Message, acq_chan_index);
       Write ( Message, string'(" should be between 0V to 0.5V when in unipolar mode (N="));
       Write ( Message, chan_valn_tmp(acq_chan_index));
      Write ( Message, string'(") for X_SYSMON."));
      assert false report Message.all severity warning;
      DEALLOCATE (Message);
    end if;

   end if;
  end if;
  end process;

  busy_mkup_p : process( dclk_in, rst_in_out)
  begin
    if (rst_in_out = '1') then
       busy_rst <= '1';
       rst_lock <= '1';
       rst_lock_early <= '1';
       busy_rst_cnt <= 0;
    elsif (rising_edge(dclk_in)) then
       if (rst_lock = '1') then
          if (busy_rst_cnt < 29) then
               busy_rst_cnt <= busy_rst_cnt + 1;
               if ( busy_rst_cnt = 26) then
                    rst_lock_early <= '0';
               end if;
          else
               busy_rst <= '0';
               rst_lock <= '0';
          end if;
       end if;
    end if;
  end process;

  busy_out_p : process (busy_rst, busy_conv, rst_lock)
  begin
     if (rst_lock = '1') then
         busy_out <= busy_rst;
     else
         busy_out <= busy_conv;
     end if;
  end process;      

  busy_conv_p : process (dclk_in, rst_in)
  begin
    if (rst_in = '1') then
       busy_conv <= '0';
       cal_chan_update <= '0';
    elsif (rising_edge(dclk_in)) then
        if (seq_reset_flag = '1'  and curr_clkdiv_sel_int <= 3)  then
             busy_conv <= busy_seq_rst;
        elsif (busy_sync_fall = '1') then
            busy_conv <= '0';
        elsif (busy_sync_rise = '1') then
            busy_conv <= '1';
        end if;

        if (conv_count = 21 and curr_chan = "01000" ) then
              cal_chan_update  <= '1';
         else
              cal_chan_update  <= '0';
         end if;
    end if;
  end process;

  busy_sync_p : process (dclk_in, rst_lock)
  begin
     if (rst_lock = '1') then 
        busy_sync1 <= '0';
        busy_sync2 <= '0';
     elsif (rising_edge (dclk_in)) then 
         busy_sync1 <= busy_r;
         busy_sync2 <= busy_sync1;
     end if;
  end process;

  busy_sync_fall <= '1' when (busy_r = '0' and busy_sync1 = '1') else '0';
  busy_sync_rise <= '1' when (busy_sync1 = '1' and busy_sync2 = '0') else '0';

  busy_seq_rst_p : process
    variable tmp_uns_div : unsigned(7 downto 0);
  begin
     if (falling_edge(busy_out) or rising_edge(busy_r)) then
        if (seq_reset_flag = '1' and seq1_0 = "00" and curr_clkdiv_sel_int <= 3) then
           wait until (rising_edge(dclk_in));
           wait  until (rising_edge(dclk_in));
           wait  until (rising_edge(dclk_in));
           wait  until (rising_edge(dclk_in));
           wait  until (rising_edge(dclk_in));
           busy_seq_rst <= '1';
        elsif (seq_reset_flag = '1' and seq1_0 /= "00" and curr_clkdiv_sel_int <= 3) then
            wait  until (rising_edge(dclk_in));
            wait  until (rising_edge(dclk_in));
            wait  until (rising_edge(dclk_in));
            wait  until (rising_edge(dclk_in));
            wait  until (rising_edge(dclk_in));
            wait  until (rising_edge(dclk_in));
            wait  until (rising_edge(dclk_in));
           busy_seq_rst <= '1';
        else
           busy_seq_rst <= '0';
        end if;
     end if;
    wait on busy_out, busy_r;
   end process;

  chan_out_p : process(busy_out, rst_in_out, cal_chan_update)
  begin
   if (rst_in_out = '1') then
         channel_out <= "00000";
   elsif (rising_edge(busy_out) or rising_edge(cal_chan_update)) then
           if ( busy_out = '1' and cal_chan_update = '1') then
                channel_out <= "01000";
           end if;
   elsif (falling_edge(busy_out)) then
                channel_out <= curr_chan;
                curr_chan_lat <= curr_chan;
   end if;
  end process;

  INT_RST_GEN_P : process
  begin
    int_rst <= '1';
    wait until (rising_edge(dclk_in));
    wait until (rising_edge(dclk_in));
    int_rst <= '0';
    wait;
  end process;

  rst_input_t <= rst_input or int_rst;

  RST_DE_SYNC_P: process(dclk_in, rst_input_t)
  begin
      if (rst_input_t = '1') then
              rst_in2 <= '1';
              rst_in1 <= '1';
      elsif (dclk_in'event and dclk_in='1') then
              rst_in2 <= rst_in1;
              rst_in1 <= rst_input_t;
     end if;
  end process;

    rst_in_not_seq <= rst_in2;
    rst_in <= rst_in2 or seq_reset_dly;
    rst_in_out <= rst_in2 or seq_reset_busy_out;

  seq_reset_dly_p : process
  begin
   if (rising_edge(seq_reset)) then
    wait until rising_edge(dclk_in);
    wait until rising_edge(dclk_in);
       seq_reset_dly <= '1';
    wait until rising_edge(dclk_in);
    wait until falling_edge(dclk_in);
       seq_reset_busy_out <= '1';
    wait until rising_edge(dclk_in);
    wait until rising_edge(dclk_in);
    wait until rising_edge(dclk_in);
       seq_reset_dly <= '0';
       seq_reset_busy_out <= '0';
   end if;
    wait on seq_reset, dclk_in;
  end process;


  seq_reset_flag_p : process (seq_reset_dly, busy_r)
    begin
       if (rising_edge(seq_reset_dly)) then
          seq_reset_flag <= '1';
       elsif (rising_edge(busy_r)) then
          seq_reset_flag <= '0';
       end if;
    end process;

  seq_reset_flag_dly_p : process (seq_reset_flag, busy_out)
    begin
       if (rising_edge(seq_reset_flag)) then
          seq_reset_flag_dly <= '1';
       elsif (rising_edge(busy_out)) then
           seq_reset_flag_dly <= '0';
       end if;
    end process;

  first_cal_chan_p : process ( busy_out)
    begin
      if (rising_edge(busy_out )) then
          if (seq_reset_flag_dly = '1' and  acq_chan = "01000" and seq1_0 = "00") then
                  first_cal_chan <= '1';
          else 
                  first_cal_chan <= '0';
          end if;
      end if;
    end process;


  ADC_SM: process (adcclk, rst_in, sim_file_flag)
  begin
     if (sim_file_flag = '1') then
        adc_state <= INIT_STATE;
     elsif (rst_in = '1' or rst_lock_early = '1') then
        adc_state <= INIT_STATE;
     elsif (adcclk'event and adcclk = '1') then
         adc_state <= next_state;
     end if;
  end process;

  next_state_p : process (adc_state, eos_en, conv_start , conv_end, curr_seq1_0_lat)
  begin
      case (adc_state) is
      when INIT_STATE => next_state <= ACQ_STATE;

      when  ACQ_STATE => if (conv_start = '1') then
                                  next_state <= CONV_STATE;
                              else
                                  next_state <= ACQ_STATE;
                              end if;

      when  CONV_STATE => if (conv_end = '1') then
                                   next_state <= END_STATE;
                               else
                                   next_state <= CONV_STATE;
                                end if;

      when  END_STATE => if (curr_seq1_0_lat = "01")  then
                                if (eos_en = '1') then
                                    next_state <= SINGLE_SEQ_STATE;
                                else
                                    next_state <= ACQ_STATE;
                                end if;
                            else
                                next_state <= ACQ_STATE;
                            end if;

      when  SINGLE_SEQ_STATE => next_state <= INIT_STATE;

      when  others => next_state <= INIT_STATE;
    end case;
  end process;

  seq_en_init_p : process
  begin
      seq_en_init <= '0';
      if (cfg_reg1_init(13 downto 12) /= "11" ) then
          wait for 20 ps;
          seq_en_init <= '1';
          wait for 150 ps;
          seq_en_init <= '0';
      end if;
      wait;
  end process;

  
      seq_en <= seq_en_init or  seq_en_drp;

  DRPORT_DO_OUT_P : process(dclk_in, gsr_in)
       variable message : line;
       variable di_str : string (16 downto 1);
       variable daddr_str : string (7 downto  1);
       variable di_40 : std_logic_vector(4 downto 0);
       variable valid_daddr : boolean := false;
       variable address : integer;
       variable tmp_value : integer := 0;
       variable tmp_value1 : std_logic_vector (7 downto 0);
  begin
       
     if (gsr_in = '1') then 
         drdy_out <= '0';
         daddr_in_lat  <= "0000000";
         do_out <= "0000000000000000";
     elsif (rising_edge(dclk_in)) then
        if (den_in = '1') then
           valid_daddr := addr_is_valid(daddr_in);
           if (valid_daddr) then
               address := slv_to_int(daddr_in);
               if (  (address > 88 or
                   (address >= 13 and address <= 15)
                    or (address >= 39 and address <= 63))) then
                 Write ( Message, string'(" Invalid Input Warning : The DADDR "));
                 Write ( Message, string'(SLV_TO_STR(daddr_in)));
                 Write ( Message, string'("  is not defined. The data in this location is invalid."));
                 assert false report Message.all  severity warning;
                 DEALLOCATE(Message);
               end if;
            end if;

            if (drdy_out_tmp1 = '1' or drdy_out_tmp2 = '1' or drdy_out_tmp3 = '1') then
                drdy_out_tmp1 <= '0';
            else
                drdy_out_tmp1 <= '1';
            end if;
            daddr_in_lat  <= daddr_in;
        else
           drdy_out_tmp1 <= '0';
        end if;

        drdy_out_tmp2 <= drdy_out_tmp1;
        drdy_out_tmp3 <= drdy_out_tmp2;
        drdy_out <= drdy_out_tmp3;

        if (drdy_out_tmp3 = '1') then
            do_out <= do_out_rdtmp;
        end if;

-- write  all available daddr addresses

        if (dwe_in = '1' and den_in = '1') then  
           if (valid_daddr) then
               dr_sram(address) <= di_in;
           end if;
          
           if ( address = 42 and  di_in( 1 downto 0) /= "00") then
             Write ( Message, string'(" Invalid Input Error : The DI bit[1:0] "));
             Write ( Message, bit_vector'(TO_BITVECTOR(di_in(1 downto 0))));
             Write ( Message, string'("  at DADDR "));
             Write ( Message, bit_vector'(TO_BITVECTOR(daddr_in)));
             Write ( Message, string'(" of X_SYSMON is invalid. These must be set to 00."));
             assert false report Message.all  severity error;
           end if;

           tmp_value1 := di_in(15 downto 8) ; 
           tmp_value := SLV_TO_INT(SLV=>tmp_value1);

           if ( address = 42 and  tmp_value < 8) then
             Write ( Message, string'(" Invalid Input Error : The DI bit[15:8] "));
             Write ( Message, bit_vector'(TO_BITVECTOR(di_in(15 downto 8))));
             Write ( Message, string'("  at DADDR "));
             Write ( Message, bit_vector'(TO_BITVECTOR(daddr_in)));
             Write ( Message, string'(" of X_SYSMON is invalid. Bit[15:8] of Control Register 42h is the ADC Clock divider and must be equal or greater than 8."));
             assert false report Message.all  severity failure;
           end if;

           if ( (address >= 43 and  address <= 47) and di_in(15 downto 0) /= "0000000000000000") then
             Write ( Message, string'(" Invalid Input Error : The DI value "));
             Write ( Message, bit_vector'(TO_BITVECTOR(di_in)));
             Write ( Message, string'("  at DADDR "));
             Write ( Message, bit_vector'(TO_BITVECTOR(daddr_in)));
             Write ( Message, string'(" of X_SYSMON is invalid. These must be set to 0000."));
             assert false report Message.all  severity error;
             DEALLOCATE(Message);
           end if;

          tmp_value := SLV_TO_INT(SLV=>di_in(4 downto 0));
      
          if (address = 40) then

           if (((tmp_value = 6) or ( tmp_value = 7) or ((tmp_value >= 10) and (tmp_value <= 15)))) then
             Write ( Message, string'(" Invalid Input Warning : The DI bit[4:0] at DADDR "));
             Write ( Message, bit_vector'(TO_BITVECTOR(daddr_in)));
             Write ( Message, string'(" is  "));
            Write ( Message, bit_vector'(TO_BITVECTOR(di_in(4 downto 0))));
             Write ( Message, string'(", which is invalid analog channel."));
             assert false report Message.all  severity warning;
             DEALLOCATE(Message);
           end if;

           if ((cfg_reg1(13 downto 12)="11") and (di_in(8)='1') and (tmp_value /= 3) and (tmp_value < 16)) then
             Write ( Message, string'(" Invalid Input Warning : The DI value is "));
             Write ( Message, bit_vector'(TO_BITVECTOR(di_in)));
             Write ( Message, string'(" at DADDR "));
             Write ( Message, bit_vector'(TO_BITVECTOR(daddr_in)));
             Write ( Message, string'(". Bit[8] of DI must be set to 0. Long acquistion mode is only allowed for external channels."));
             assert false report Message.all  severity warning;
             DEALLOCATE(Message);
           end if;

           if ((cfg_reg1(13 downto 12)="11") and (di_in(9)='1') and (tmp_value /= 3) and (tmp_value < 16)) then
             Write ( Message, string'(" Invalid Input Warning : The DI value is "));
             Write ( Message, bit_vector'(TO_BITVECTOR(di_in)));
             Write ( Message, string'(" at DADDR "));
             Write ( Message, bit_vector'(TO_BITVECTOR(daddr_in)));
             Write ( Message, string'(". Bit[9] of DI must be set to 0. Event mode timing can only be used with external channels."));
             assert false report Message.all  severity warning;
             DEALLOCATE(Message);
           end if;

           if ((cfg_reg1(13 downto 12)="11") and (di_in(13 downto 12)/="00") and (seq_chan_reg1 /= X"0000") and (seq_chan_reg2 /= X"0000")) then
             Write ( Message, string'(" Invalid Input Warning : The Control Regiter 48h and 49h are "));
             Write ( Message, bit_vector'(TO_BITVECTOR(seq_chan_reg1)));
             Write ( Message, string'(" and  "));
             Write ( Message, bit_vector'(TO_BITVECTOR(seq_chan_reg2)));
             Write ( Message, string'(". Those registers should be set to 0000h in single channel mode and averaging enabled."));
             assert false report Message.all  severity warning;
             DEALLOCATE(Message);
           end if;
        end if;

          tmp_value := SLV_TO_INT(SLV=>cfg_reg0(4 downto 0));

          if (address = 41) then

           if ((di_in(13 downto 12)="11") and (cfg_reg0(8)='1') and (tmp_value /= 3) and (tmp_value < 16)) then
             Write ( Message, string'(" Invalid Input Warning : The Control Regiter 40h value is "));
             Write ( Message, bit_vector'(TO_BITVECTOR(cfg_reg0)));
             Write ( Message, string'(". Bit[8] of Control Regiter 40h must be set to 0. Long acquistion mode is only allowed for external channels."));
             assert false report Message.all  severity warning;
             DEALLOCATE(Message);
           end if;

           if ((di_in(13 downto 12)="11") and (cfg_reg0(9)='1') and (tmp_value /= 3) and (tmp_value < 16)) then
             Write ( Message, string'(" Invalid Input Warning : The Control Regiter 40h value is "));
             Write ( Message, bit_vector'(TO_BITVECTOR(cfg_reg0)));
             Write ( Message, string'(". Bit[9] of Control Regiter 40h must be set to 0. Event mode timing can only be used with external channels."));
             assert false report Message.all  severity warning;
             DEALLOCATE(Message);
           end if;

           if ((di_in(13 downto 12) /= "11") and (seq_acq_reg1(10 downto 0) /= "00000000000") and (seq_acq_reg1(15 downto 12) /= "0000")) then
             Write ( Message, string'(" Invalid Input Warning : The Control Regiter 4Eh is "));
             Write ( Message, bit_vector'(TO_BITVECTOR(seq_acq_reg1)));
             Write ( Message, string'(". Bit[15:12] and bit[10:0] of this register must be set to 0. Long acquistion mode is only allowed for external channels."));
             assert false report Message.all  severity warning;
             DEALLOCATE(Message);
           end if;

           if ((di_in(13 downto 12) = "11") and (cfg_reg0(13 downto 12) /= "00") and (seq_chan_reg1 /= X"0000") and (seq_chan_reg2 /= X"0000")) then
             Write ( Message, string'(" Invalid Input Warning : The Control Regiter 48h and 49h are "));
             Write ( Message, bit_vector'(TO_BITVECTOR(seq_chan_reg1)));
             Write ( Message, string'(" and  "));
             Write ( Message, bit_vector'(TO_BITVECTOR(seq_chan_reg2)));
             Write ( Message, string'(". Those registers should be set to 0000h in single channel mode and averaging enabled."));
             assert false report Message.all  severity warning;
             DEALLOCATE(Message);
           end if;
        end if;
       end if;



        if (daddr_in = "1000001" ) then
           if (dwe_in = '1' and den_in = '1') then

                if (di_in(13 downto 12) /= cfg_reg1(13 downto 12)) then
                            seq_reset <= '1';
                else
                            seq_reset <= '0';
                end if;

                if (di_in(13 downto 12) /= "11" ) then
                            seq_en_drp <= '1';
                else
                            seq_en_drp <= '0';
                end if;
             else  
                        seq_reset <= '0';
                        seq_en_drp <= '0';
             end if;
        else 
            seq_reset <= '0';
            seq_en_drp <= '0';
        end if;
     end if;
  end process;

  tmp_dr_sram_out <= dr_sram(daddr_in_lat_int) when (daddr_in_lat_int >= 64 and
                daddr_in_lat_int <= 87) else "0000000000000000";

  tmp_data_reg_out <= data_reg(daddr_in_lat_int) when (daddr_in_lat_int >= 0 and
                daddr_in_lat_int <= 38) else "0000000000000000";

  do_out_rdtmp_p : process( daddr_in_lat, tmp_data_reg_out, tmp_dr_sram_out ) 
      variable Message : line;
      variable valid_daddr : boolean := false;
  begin
           valid_daddr := addr_is_valid(daddr_in_lat);
           daddr_in_lat_int <= slv_to_int(daddr_in_lat);
           if (valid_daddr) then
              if ((daddr_in_lat_int > 88) or 
                               (daddr_in_lat_int >= 13 and daddr_in_lat_int <= 15)
                or (daddr_in_lat_int >= 39 and daddr_in_lat_int <= 63)) then 
                    do_out_rdtmp <= "XXXXXXXXXXXXXXXX";
              end if;
        
              if ((daddr_in_lat_int >= 0 and  daddr_in_lat_int <= 12) or 
              (daddr_in_lat_int >= 16 and daddr_in_lat_int <= 38)) then

                   do_out_rdtmp <= tmp_data_reg_out;

               elsif (daddr_in_lat_int >= 64 and daddr_in_lat_int <= 87) then
 
                    do_out_rdtmp <= tmp_dr_sram_out;
             end if;
          end if;
   end process;

-- end DRP RAM


  cfg_reg0 <= dr_sram(16#40#);
  cfg_reg1 <= dr_sram(16#41#);
  cfg_reg2 <= dr_sram(16#42#);
  seq_chan_reg1 <= dr_sram(16#48#);
  seq_chan_reg2 <= dr_sram(16#49#);
  seq_avg_reg1 <= dr_sram(16#4A#);
  seq_avg_reg2 <= dr_sram(16#4B#);
  seq_du_reg1 <= dr_sram(16#4C#);
  seq_du_reg2 <= dr_sram(16#4D#);
  seq_acq_reg1 <= dr_sram(16#4E#);
  seq_acq_reg2 <= dr_sram(16#4F#);

  seq1_0 <= cfg_reg1(13 downto 12);

  drp_update_p : process 
    variable seq_bits : std_logic_vector( 1 downto 0);
   begin
    if (rst_in = '1') then
       wait until (rising_edge(dclk_in));
       wait until (rising_edge(dclk_in));
           seq_bits := seq1_0;
    elsif (rising_edge(drp_update)) then
       seq_bits := curr_seq1_0;
    end if;

    if (rising_edge(drp_update) or (rst_in = '1')) then
       if (seq_bits = "00") then 
         alarm_en <= "000";
         ot_en <= '1';
       else 
         ot_en  <= not cfg_reg1(0);
         alarm_en <= not cfg_reg1(3 downto 1);
       end if;
    end if;
      wait on drp_update, rst_in;
   end process;


-- Clock divider, generate  and adcclk

    sysclk_p : process(dclk_in)
    begin
      if (rising_edge(dclk_in)) then
          sysclk <= not sysclk;
      end if;
    end process;


    curr_clkdiv_sel_int_p : process (curr_clkdiv_sel)
    begin
        curr_clkdiv_sel_int <= SLV_TO_INT(curr_clkdiv_sel);
    end process;

    clk_count_p : process(dclk_in)
       variable clk_count : integer := -1;
    begin
     
       if (rising_edge(dclk_in)) then
        if (curr_clkdiv_sel_int > 2 ) then 
            if (clk_count >= curr_clkdiv_sel_int - 1) then
                clk_count := 0;
            else
                clk_count := clk_count + 1;
            end if;

            if (clk_count > (curr_clkdiv_sel_int/2) - 1) then
               adcclk_tmp <= '1';
            else
               adcclk_tmp <= '0';
            end if;
        else
             adcclk_tmp <= not adcclk_tmp;
         end if;
      end if;
   end process;

        curr_clkdiv_sel <= cfg_reg2(15 downto 8);
        adcclk_div1 <= '0' when (curr_clkdiv_sel_int > 1) else '1';
        adcclk <=  not sysclk when adcclk_div1 = '1' else adcclk_tmp;

-- end clock divider

-- latch configuration registers
    acq_latch_p : process ( seq1_0, adc_s1_flag, curr_seq, cfg_reg0_adc, rst_in)
    begin
        if ((seq1_0 = "01" and adc_s1_flag = '0') or seq1_0 = "10") then
            acq_acqsel <= curr_seq(8);
        elsif (seq1_0 = "11") then
            acq_acqsel <= cfg_reg0_adc(8);
        else
            acq_acqsel <= '0';
        end if;

        if (rst_in = '0') then
          if (seq1_0 /= "11" and  adc_s1_flag = '0') then
            acq_avg <= curr_seq(13 downto 12);
            acq_chan <= curr_seq(4 downto 0);
            acq_b_u <= curr_seq(10);
          else 
            acq_avg <= cfg_reg0_adc(13 downto 12);
            acq_chan <= cfg_reg0_adc(4 downto 0);
            acq_b_u <= cfg_reg0_adc(10);
          end if;
        end if;
    end process;

    acq_chan_index <= SLV_TO_INT(acq_chan);

    conv_end_reg_read_P : process ( adcclk, rst_in)
    begin
       if (rst_in = '1') then
           conv_end_reg_read <= "0000";
       elsif (rising_edge(adcclk)) then
           conv_end_reg_read(3 downto 1) <= conv_end_reg_read(2 downto 0);  
           conv_end_reg_read(0) <= single_chan_conv_end or conv_end;
       end if;
   end process;

-- synch to DCLK
       busy_reg_read_P : process ( dclk_in, rst_in)
    begin
       if (rst_in = '1') then
           busy_reg_read <= '1';
       elsif (rising_edge(dclk_in)) then
           busy_reg_read <= not conv_end_reg_read(2);
       end if;
   end process;

   cfg_reg0_adc_P : process
      variable  first_after_reset : std_ulogic := '1';
   begin
       if (rst_in='1') then
          cfg_reg0_seq <= X"0000";
          cfg_reg0_adc  <= X"0000";
          acq_e_c <= '0';
          first_after_reset := '1';
       elsif (falling_edge(busy_reg_read) or falling_edge(rst_in)) then
          wait until (rising_edge(dclk_in));
          wait until (rising_edge(dclk_in));
          wait until (rising_edge(dclk_in));
          if (first_after_reset = '1') then
             first_after_reset := '0';
             cfg_reg0_adc <= cfg_reg0;
             cfg_reg0_seq <= cfg_reg0;
          else
             cfg_reg0_adc <= cfg_reg0_seq;
             cfg_reg0_seq <= cfg_reg0;
          end if;
          acq_e_c <= cfg_reg0(9);
       end if;
       wait on busy_reg_read, rst_in;
   end process;

   busy_r_p : process(conv_start, busy_r_rst, rst_in)
   begin
      if (rst_in = '1') then
         busy_r <= '0';
      elsif (rising_edge(conv_start) and rst_lock = '0') then
          busy_r <= '1';
      elsif (rising_edge(busy_r_rst)) then
          busy_r <= '0';
      end if;
   end process;

   curr_seq1_0_p : process( busy_out)
   begin
     if (falling_edge( busy_out)) then
        if (adc_s1_flag = '1') then
            curr_seq1_0 <= "00";
        else
            curr_seq1_0 <= seq1_0;
        end if;
     end if;
   end process;

   start_conv_p : process ( conv_start, rst_in)
      variable       Message : line;
   begin
     if (rst_in = '1') then
        analog_mux_in <= 0.0;
        curr_chan <= "00000";
     elsif (rising_edge(conv_start)) then
        if ( ((acq_chan_index = 3) or (acq_chan_index >= 16 and acq_chan_index <= 31))) then
            analog_mux_in <= analog_in_diff(acq_chan_index);
        else
             analog_mux_in <= analog_in_uni(acq_chan_index);
        end if;
        curr_chan <= acq_chan;
        curr_seq1_0_lat <= curr_seq1_0;
          
        if (acq_chan_index = 6 or acq_chan_index = 7 or (acq_chan_index >= 10 and acq_chan_index <= 15)) then
            Write ( Message, string'(" Invalid Input Warning : The analog channel  "));
            Write ( Message, acq_chan_index);
            Write ( Message, string'(" to X_SYSMON is invalid."));
            assert false report Message.all severity warning;
        end if;
           
        if ((seq1_0 = "01" and adc_s1_flag = '0') or seq1_0 = "10" or seq1_0 = "00") then
                curr_avg_set <= curr_seq(13 downto 12);
                curr_b_u <= curr_seq(10);
                curr_e_c <= '0';
                curr_acq <= curr_seq(8);
            else 
                curr_avg_set <= acq_avg;
                curr_b_u <= acq_b_u;
                curr_e_c <= cfg_reg0(9);
                curr_acq <= cfg_reg0(8);
        end if;
      end if; 

    end  process;

-- end latch configuration registers

-- sequence control

     seq_en_dly <= seq_en after 1 ps;

    seq_num_p : process(seq_en_dly)
       variable seq_num_tmp : integer := 0;
       variable si_tmp : integer := 0;
       variable si : integer := 0;
    begin
     if (rising_edge(seq_en_dly)) then
       if (seq1_0  = "01" or seq1_0 = "10") then
          seq_num_tmp := 0;
          for I in 0 to 15 loop
              si := I;
              if (seq_chan_reg1(si) = '1') then
                 seq_num_tmp := seq_num_tmp + 1;
                 seq_mem(seq_num_tmp) <= si;
              end if;
          end loop;
          for I in 16 to 31 loop
              si := I;
              si_tmp := si-16;
              if (seq_chan_reg2(si_tmp) = '1') then
                   seq_num_tmp := seq_num_tmp + 1;
                   seq_mem(seq_num_tmp) <= si;
              end if;
          end loop;
          seq_num <= seq_num_tmp;
        elsif (seq1_0  = "00") then
           seq_num <= 4;
           seq_mem(1) <= 0;
           seq_mem(2) <= 8;
           seq_mem(3) <= 9;
           seq_mem(4) <= 10;
         end if;
     end if;
   end process;


   curr_seq_p : process(seq_count, seq_en_dly)
      variable seq_curr_i : std_logic_vector(4 downto 0);
      variable seq_curr_index : integer;
      variable tmp_value : integer;
      variable curr_seq_tmp : std_logic_vector(15  downto 0);
    begin
    if (seq_count'event or falling_edge(seq_en_dly)) then
      seq_curr_index := seq_mem(seq_count);
      seq_curr_i := STD_LOGIC_VECTOR(TO_UNSIGNED(seq_curr_index, 5));
      curr_seq_tmp := "0000000000000000";
      if (seq_curr_index >= 0 and seq_curr_index <= 15) then
          curr_seq_tmp(2 downto 0) := seq_curr_i(2 downto 0);
          curr_seq_tmp(4 downto 3) := "01";
          curr_seq_tmp(8) := seq_acq_reg1(seq_curr_index);
          curr_seq_tmp(10) := seq_du_reg1(seq_curr_index);
          if (seq1_0 = "00") then
             curr_seq_tmp(13 downto 12) := "01";
          elsif (seq_avg_reg1(seq_curr_index) = '1') then
             curr_seq_tmp(13 downto 12) := cfg_reg0(13 downto 12);
          else
             curr_seq_tmp(13 downto 12) := "00";
          end if;
          if (seq_curr_index >= 0 and seq_curr_index <= 7) then
             curr_seq_tmp(4 downto 3) := "01";
          else
             curr_seq_tmp(4 downto 3) := "00";
          end if;
      elsif (seq_curr_index >= 16 and seq_curr_index <= 31) then
          tmp_value := seq_curr_index -16;
          curr_seq_tmp(4 downto 0) := seq_curr_i;
          curr_seq_tmp(8) := seq_acq_reg2(tmp_value);
          curr_seq_tmp(10) := seq_du_reg2(tmp_value);
          if (seq_avg_reg2(tmp_value) = '1') then
             curr_seq_tmp(13 downto 12) := cfg_reg0(13 downto 12);
          else
             curr_seq_tmp(13 downto 12) := "00";
          end if;
      end if;
      curr_seq <= curr_seq_tmp;
   end if;
   end process;

   eos_en_p : process (adcclk, rst_in)
   begin
        if (rst_in = '1') then 
            seq_count <= 1;
            eos_en <= '0';
        elsif (rising_edge(adcclk)) then
            if ((seq_count = seq_num  ) and (adc_state = CONV_STATE and next_state = END_STATE)
                 and  (curr_seq1_0_lat /= "11") and rst_lock = '0') then
                eos_tmp_en <= '1';
            else
                eos_tmp_en <= '0';
            end if;

            if ((eos_tmp_en = '1') and (seq_status_avg = 0))  then
                eos_en <= '1';
            else
                eos_en <= '0';
            end if;

            if (eos_tmp_en = '1' or curr_seq1_0_lat = "11") then
                seq_count <= 1;
            elsif (seq_count_en = '1' ) then
               if (seq_count >= 32) then
                  seq_count <= 1;
               else
                seq_count <= seq_count +1;
               end if;
            end if;
        end if; 
   end process;

-- end sequence control

-- Acquisition

   busy_out_dly <= busy_out after 10 ps;

   short_acq_p : process(adc_state, rst_in, first_acq)
   begin
       if (rst_in = '1') then
           shorten_acq <= 0;
       elsif (adc_state'event or first_acq'event) then
         if  ((busy_out_dly = '0') and (adc_state=ACQ_STATE) and (first_acq='1')) then
           shorten_acq <= 1;
         else
           shorten_acq <= 0;
         end if;
       end if;
   end process;

   acq_count_p : process (adcclk, rst_in)
   begin
        if (rst_in = '1') then
            acq_count <= 1;
            first_acq <= '1';
        elsif (rising_edge(adcclk)) then
            if (adc_state = ACQ_STATE and rst_lock = '0' and acq_e_c = '0') then 
                first_acq <= '0';

                if (acq_acqsel = '1') then
                    if (acq_count <= 11) then
                        acq_count <= acq_count + 1 + shorten_acq;
                    end if;
                else 
                    if (acq_count <= 4) then
                        acq_count <= acq_count + 1 + shorten_acq;
                    end if;
                end if;

                if (next_state = CONV_STATE) then
                    if ((acq_acqsel = '1' and acq_count < 10) or (acq_acqsel = '0' and acq_count < 4)) then
                    assert false report "Warning: Acquisition time not enough for X_SYSMON."
                    severity warning;
                    end if;
                end if;
            else
                if (first_acq = '1') then
                    acq_count <= 1;
                else
                    acq_count <= 0;
                end if;
            end if;
        end if; 
    end process;

    conv_start_con_p: process(adc_state, acq_acqsel, acq_count)
    begin
      if (adc_state = ACQ_STATE) then
        if (rst_lock = '0') then
         if ((seq_reset_flag = '0' or (seq_reset_flag = '1' and curr_clkdiv_sel_int > 3))
           and ((acq_acqsel = '1' and acq_count > 10) or (acq_acqsel = '0' and acq_count > 4))) then
                 conv_start_cont <= '1';
         else
                 conv_start_cont <= '0';
         end if;
       end if;
     else
         conv_start_cont <= '0';
     end if;
   end process;
 
   conv_start_sel <= convst_in when (acq_e_c = '1') else conv_start_cont;
   reset_conv_start_tmp <= '1' when (conv_count=2) else '0';
   reset_conv_start <= rst_in or reset_conv_start_tmp;
  
   conv_start_p : process(conv_start_sel, reset_conv_start)
   begin
      if (reset_conv_start ='1') then
          conv_start <= '0';
      elsif (rising_edge(conv_start_sel)) then
          conv_start <= '1';
      end if;
   end process;

-- end acquisition


-- Conversion
    conv_result_p : process (adc_state, next_state, curr_chan, curr_chan_index, analog_mux_in, curr_b_u)
       variable conv_result_int_i : integer := 0;
       variable conv_result_int_tmp : integer := 0;
       variable conv_result_int_tmp_rl : real := 0.0;
       variable adc_analog_tmp : real := 0.0;
    begin
        if ((adc_state = CONV_STATE and next_state = END_STATE) or adc_state = END_STATE) then
            if (curr_chan = "00000") then    -- temperature conversion
                    adc_analog_tmp := (analog_mux_in + 273.0) * 130.0382;
                    adc_temp_result <= adc_analog_tmp;
                    if (adc_analog_tmp >= 65535.0) then
                        conv_result_int_i := 65535;
                    elsif (adc_analog_tmp < 0.0) then
                        conv_result_int_i := 0;
                    else 
                        conv_result_int_tmp := real2int(adc_analog_tmp);
                        conv_result_int_tmp_rl := int2real(conv_result_int_tmp);
                        if (adc_analog_tmp - conv_result_int_tmp_rl > 0.9999) then
                            conv_result_int_i := conv_result_int_tmp + 1;
                        else
                            conv_result_int_i := conv_result_int_tmp;
                        end if;
                    end if;
                    conv_result_int <= conv_result_int_i;
                    conv_result <= STD_LOGIC_VECTOR(TO_UNSIGNED(conv_result_int_i, 16));
            elsif (curr_chan = "00001" or curr_chan = "00010") then     -- internal power conversion
                    adc_analog_tmp := analog_mux_in * 65536.0 / 3.0;
                    adc_intpwr_result <= adc_analog_tmp;
                    if (adc_analog_tmp >= 65535.0) then
                        conv_result_int_i := 65535;
                    elsif (adc_analog_tmp < 0.0) then
                        conv_result_int_i := 0;
                    else 
                       conv_result_int_tmp := real2int(adc_analog_tmp);
                        conv_result_int_tmp_rl := int2real(conv_result_int_tmp);
                        if (adc_analog_tmp - conv_result_int_tmp_rl > 0.9999) then
                            conv_result_int_i := conv_result_int_tmp + 1;
                        else
                            conv_result_int_i := conv_result_int_tmp;
                        end if;
                    end if;
                    conv_result_int <= conv_result_int_i;
                    conv_result <= STD_LOGIC_VECTOR(TO_UNSIGNED(conv_result_int_i, 16));
            elsif ((curr_chan = "00011") or ((curr_chan_index >= 16) and  (curr_chan_index <= 31))) then
                    adc_analog_tmp :=  (analog_mux_in) * 65536.0;
                    adc_ext_result <= adc_analog_tmp;
                    if (curr_b_u = '1')  then
                        if (adc_analog_tmp > 32767.0) then
                             conv_result_int_i := 32767;
                        elsif (adc_analog_tmp < -32768.0) then
                             conv_result_int_i := -32768;
                        else 
                            conv_result_int_tmp := real2int(adc_analog_tmp);
                            conv_result_int_tmp_rl := int2real(conv_result_int_tmp);
                            if (adc_analog_tmp - conv_result_int_tmp_rl > 0.9999) then
                                conv_result_int_i := conv_result_int_tmp + 1;
                            else
                                conv_result_int_i := conv_result_int_tmp;
                            end if;
                        end if;
                    conv_result_int <= conv_result_int_i;
                    conv_result <= STD_LOGIC_VECTOR(TO_SIGNED(conv_result_int_i, 16));
                    else
                       if (adc_analog_tmp  > 65535.0) then
                             conv_result_int_i := 65535;
                        elsif (adc_analog_tmp  < 0.0) then
                             conv_result_int_i := 0;
                        else
                            conv_result_int_tmp := real2int(adc_analog_tmp);
                            conv_result_int_tmp_rl := int2real(conv_result_int_tmp);
                            if (adc_analog_tmp - conv_result_int_tmp_rl > 0.9999) then
                                conv_result_int_i := conv_result_int_tmp + 1;
                            else
                                conv_result_int_i := conv_result_int_tmp;
                            end if;
                        end if;
                    conv_result_int <= conv_result_int_i;
                    conv_result <= STD_LOGIC_VECTOR(TO_UNSIGNED(conv_result_int_i, 16));
                    end if;
            else 
                conv_result_int <= 0;
                conv_result <= "0000000000000000";
            end if;
         end if;

    end process;


    conv_count_p : process (adcclk, rst_in)
    begin
        if (rst_in = '1') then
            conv_count <= 6;
            conv_end <= '0';
            seq_status_avg <= 0;
            busy_r_rst <= '0';
            busy_r_rst_done <= '0';
            for i in 0 to 31 loop
                conv_avg_count(i) <= 0;     -- array of integer
            end loop;
            single_chan_conv_end <= '0';
        elsif (rising_edge(adcclk)) then
            if (adc_state = ACQ_STATE) then
               if (busy_r_rst_done = '0') then
                    busy_r_rst <= '1';
               else
                    busy_r_rst <= '0';
               end if;
               busy_r_rst_done <= '1';
            end if;

            if (adc_state = ACQ_STATE and conv_start = '1') then
                conv_count <= 0;
                conv_end <= '0';
            elsif (adc_state = CONV_STATE ) then
                busy_r_rst_done <= '0';
                conv_count <= conv_count + 1;

                if (((curr_chan /= "01000" ) and (conv_count = conv_time )) or 
              ((curr_chan = "01000") and (conv_count = conv_time_cal_1) and (first_cal_chan = '1'))
              or ((curr_chan = "01000") and (conv_count = conv_time_cal) and (first_cal_chan = '0'))) then
                    conv_end <= '1';
                else
                    conv_end <= '0';
                end if;
            else  
                conv_end <= '0';
                conv_count <= 0;
            end if;

           single_chan_conv_end <= '0';
           if ( (conv_count = conv_time) or (conv_count = 44)) then
                   single_chan_conv_end <= '1';
           end if;

            if (adc_state = CONV_STATE and next_state = END_STATE and rst_lock = '0') then
                case curr_avg_set is
                    when "00" => eoc_en <= '1';
                                conv_avg_count(curr_chan_index) <= 0;
                    when "01" =>
                                if (conv_avg_count(curr_chan_index) = 15) then
                                  eoc_en <= '1';
                                  conv_avg_count(curr_chan_index) <= 0;
                                  seq_status_avg <= seq_status_avg - 1;
                                else 
                                  eoc_en <= '0';
                                  if (conv_avg_count(curr_chan_index) = 0) then
                                      seq_status_avg <= seq_status_avg + 1;
                                  end if;
                                  conv_avg_count(curr_chan_index) <= conv_avg_count(curr_chan_index) + 1;
                                end if;
                   when "10" =>
                                if (conv_avg_count(curr_chan_index) = 63) then
                                    eoc_en <= '1';
                                    conv_avg_count(curr_chan_index) <= 0;
                                    seq_status_avg <= seq_status_avg - 1;
                                else 
                                    eoc_en <= '0';
                                    if (conv_avg_count(curr_chan_index) = 0) then
                                        seq_status_avg <= seq_status_avg + 1;
                                    end if;
                                    conv_avg_count(curr_chan_index) <= conv_avg_count(curr_chan_index) + 1;
                                end if;
                    when "11" => 
                                if (conv_avg_count(curr_chan_index) = 255) then
                                    eoc_en <= '1';
                                    conv_avg_count(curr_chan_index) <= 0;
                                    seq_status_avg <= seq_status_avg - 1;
                                else 
                                    eoc_en <= '0';
                                    if (conv_avg_count(curr_chan_index) = 0) then
                                        seq_status_avg <= seq_status_avg + 1;
                                    end if;
                                    conv_avg_count(curr_chan_index) <= conv_avg_count(curr_chan_index) + 1;
                                end if;
                   when  others => eoc_en <= '0';
                end case;
            else
                eoc_en <= '0';
            end if;

            if (adc_state = END_STATE) then
                   conv_result_reg <= conv_result;
            end if;
        end if;
   end process;

-- end conversion

   
-- average
    
    conv_acc_result_p : process(adcclk, rst_in)
       variable conv_acc_vec : std_logic_vector(23 downto 0);
       variable conv_acc_vec_int  : integer;
    begin
        if (rst_in = '1') then 
            for j in 0 to 31 loop
                conv_acc(j) <= 0;
            end loop;
            conv_acc_result <= "0000000000000000";
        elsif (rising_edge(adcclk)) then
            if (adc_state = CONV_STATE and  next_state = END_STATE) then
                if (curr_avg_set /= "00" and rst_lock /= '1') then
                    conv_acc(curr_chan_index) <= conv_acc(curr_chan_index) + conv_result_int;
                else
                    conv_acc(curr_chan_index) <= 0;
                end if;
            elsif (eoc_en = '1') then
                conv_acc_vec_int := conv_acc(curr_chan_index);
                if ((curr_b_u = '1') and (((curr_chan_index >= 16) and (curr_chan_index <= 31))
                   or (curr_chan_index = 3))) then
                    conv_acc_vec := STD_LOGIC_VECTOR(TO_SIGNED(conv_acc_vec_int, 24));
                else
                    conv_acc_vec := STD_LOGIC_VECTOR(TO_UNSIGNED(conv_acc_vec_int, 24));
                end if;
                case curr_avg_set(1 downto 0) is
                  when "00" => conv_acc_result <= "0000000000000000";
                  when "01" => conv_acc_result <= conv_acc_vec(19 downto 4);
                  when "10" => conv_acc_result <= conv_acc_vec(21 downto 6);
                  when "11" => conv_acc_result <= conv_acc_vec(23 downto 8);
                  when others => conv_acc_result <= "0000000000000000";
                end case;
                conv_acc(curr_chan_index) <= 0;
            end if;
        end if;
    end process;

-- end average   

-- single sequence
    adc_s1_flag_p : process(adcclk, rst_in)
    begin
        if (rst_in = '1') then
            adc_s1_flag <= '0';
        elsif (rising_edge(adcclk)) then 
            if (adc_state = SINGLE_SEQ_STATE) then
                adc_s1_flag <= '1';
            end if;
        end if;
    end process;


--  end state
    eos_eoc_p: process(adcclk, rst_in)
    begin
        if (rst_in = '1') then
            seq_count_en <= '0';
            eos_out_tmp <= '0';
            eoc_out_tmp <= '0';
        elsif (rising_edge(adcclk)) then
            if ((adc_state = CONV_STATE and next_state = END_STATE) and (curr_seq1_0_lat /= "11")
                  and (rst_lock = '0')) then
                seq_count_en <= '1';
            else
                seq_count_en <= '0';
            end if;

            if (rst_lock = '0') then
                 eos_out_tmp <= eos_en;
                 eoc_en_delay <= eoc_en;
                 eoc_out_tmp <= eoc_en_delay;
            else 
                 eos_out_tmp <= '0';
                 eoc_en_delay <= '0';
                 eoc_out_tmp <= '0';
            end if;
        end if;
   end process;

    data_reg_p : process(eoc_out, rst_in_not_seq)
       variable tmp_uns1 : unsigned(15 downto 0);
       variable tmp_uns2 : unsigned(15 downto 0);
       variable tmp_uns3 : unsigned(15 downto 0);
    begin
        if (rst_in_not_seq = '1') then
            for k in  32 to  39 loop
                if (k >= 36) then
                    data_reg(k) <= "1111111111111111";
                else
                    data_reg(k) <= "0000000000000000";
                end if;
            end loop;
        elsif (rising_edge(eoc_out)) then
            if ( rst_lock = '0') then
                if ((curr_chan_index >= 0 and curr_chan_index <= 3) or 
                          (curr_chan_index >= 16 and curr_chan_index <= 31)) then
                    if (curr_avg_set = "00") then
                        data_reg(curr_chan_index) <= conv_result_reg;
                    else
                        data_reg(curr_chan_index) <= conv_acc_result;
                    end if;
                end if;
                if (curr_chan_index = 4) then
                    data_reg(curr_chan_index) <= X"D555";
                end if;
                if (curr_chan_index = 5) then
                    data_reg(curr_chan_index) <= X"0000";
                end if;
                if (curr_chan_index = 0 or curr_chan_index = 1 or curr_chan_index = 2) then
                    tmp_uns2 := UNSIGNED(data_reg(32 + curr_chan_index));
                    tmp_uns3 := UNSIGNED(data_reg(36 + curr_chan_index));
                    if (curr_avg_set = "00") then
                        tmp_uns1 := UNSIGNED(conv_result_reg);
                        if (tmp_uns1 > tmp_uns2) then
                            data_reg(32 + curr_chan_index) <= conv_result_reg;
                         end if;
                        if (tmp_uns1 < tmp_uns3) then
                            data_reg(36 + curr_chan_index) <= conv_result_reg;
                        end if;
                    else 
                        tmp_uns1 := UNSIGNED(conv_acc_result);
                        if (tmp_uns1 > tmp_uns2) then
                            data_reg(32 + curr_chan_index) <= conv_acc_result;
                        end if;
                        if (tmp_uns1 < tmp_uns3) then
                            data_reg(36 + curr_chan_index) <= conv_acc_result;
                        end if;
                    end if;
                end if;
           end if;
       end if;
     end process;

    data_written_p : process(busy_r, rst_in_not_seq)
    begin
       if (rst_in_not_seq = '1') then
            data_written <= X"0000";
       elsif (falling_edge(busy_r)) then
          if (curr_avg_set = "00") then
               data_written <= conv_result_reg;
           else
              data_written <= conv_acc_result;
           end if;
       end if;
    end process;

-- eos and eoc

    eoc_out_tmp1_p : process (eoc_out_tmp, eoc_out, rst_in)
    begin
           if (rst_in = '1') then
              eoc_out_tmp1 <= '0';
           elsif (rising_edge(eoc_out)) then
               eoc_out_tmp1 <= '0';
           elsif (rising_edge(eoc_out_tmp)) then
               if (curr_chan /= "01000") then
                  eoc_out_tmp1 <= '1';
               else
                  eoc_out_tmp1 <= '0';
               end if;
           end if;
    end process;

    eos_out_tmp1_p : process (eos_out_tmp, eos_out, rst_in)
    begin
           if (rst_in = '1') then
              eos_out_tmp1 <= '0';
           elsif (rising_edge(eos_out)) then
               eos_out_tmp1 <= '0';
           elsif (rising_edge(eos_out_tmp)) then
               eos_out_tmp1 <= '1';
           end if;
    end process;

    busy_out_low_edge <= '1' when (busy_out='0' and busy_out_sync='1') else '0';

    eoc_eos_out_p : process (dclk_in, rst_in)
    begin
      if (rst_in = '1') then
          op_count <= 15;
          busy_out_sync <= '0';
          drp_update <= '0';
          alarm_update <= '0';
          eoc_out <= '0';
          eos_out <= '0';
      elsif ( rising_edge(dclk_in)) then
         busy_out_sync <= busy_out;   
         if (op_count = 3) then
            drp_update <= '1';
          else 
            drp_update <= '0';
          end if;
          if (op_count = 5 and eoc_out_tmp1 = '1') then
             alarm_update <= '1';
          else
             alarm_update <= '0';
          end if;
          if (op_count = 9 ) then
             eoc_out <= eoc_out_tmp1;
          else
             eoc_out <= '0';
          end if;
          if (op_count = 9) then
             eos_out <= eos_out_tmp1;
          else
             eos_out <= '0';
          end if;
          if (busy_out_low_edge = '1') then
              op_count <= 0;
          elsif (op_count < 15) then
              op_count <= op_count +1;
          end if;
      end if;
   end process;

-- end eos and eoc


-- alarm

    alm_reg_p : process(alarm_update, rst_in_not_seq )
       variable  tmp_unsig1 : unsigned(15 downto 0);
       variable  tmp_unsig2 : unsigned(15 downto 0);
       variable  tmp_unsig3 : unsigned(15 downto 0);
    begin
     if (rst_in_not_seq = '1') then
        ot_out_reg <= '0';
        alarm_out_reg <= "000";
     elsif (rising_edge(alarm_update)) then
       if (rst_lock = '0') then
          if (curr_chan_lat = "00000") then
            tmp_unsig1 := UNSIGNED(data_written);
            tmp_unsig2 := UNSIGNED(dr_sram(16#57#));
            if (tmp_unsig1 >= ot_limit_reg) then
                ot_out_reg <= '1';
            elsif (((tmp_unsig1 < tmp_unsig2) and (curr_seq1_0_lat /= "00")) or
                           ((curr_seq1_0_lat = "00") and (tmp_unsig1 < ot_sf_limit_low_reg))) then
                ot_out_reg <= '0';
            end if;
            tmp_unsig2 := UNSIGNED(dr_sram(16#50#));
            tmp_unsig3 := UNSIGNED(dr_sram(16#54#));
            if ( tmp_unsig1 > tmp_unsig2) then
                     alarm_out_reg(0) <= '1';
            elsif (tmp_unsig1 <= tmp_unsig3) then
                     alarm_out_reg(0) <= '0';
            end if;
          end if;
          tmp_unsig1 := UNSIGNED(data_written);
          tmp_unsig2 := UNSIGNED(dr_sram(16#51#));
          tmp_unsig3 := UNSIGNED(dr_sram(16#55#));
          if (curr_chan_lat = "00001") then
             if ((tmp_unsig1 > tmp_unsig2) or (tmp_unsig1 < tmp_unsig3)) then
                      alarm_out_reg(1) <= '1';
             else
                      alarm_out_reg(1) <= '0';
             end if;
          end if;
          tmp_unsig1 := UNSIGNED(data_written);
          tmp_unsig2 := UNSIGNED(dr_sram(16#52#));
          tmp_unsig3 := UNSIGNED(dr_sram(16#56#));
          if (curr_chan_lat = "00010") then
              if ((tmp_unsig1 > tmp_unsig2) or (tmp_unsig1 < tmp_unsig3)) then
                      alarm_out_reg(2) <= '1';
                 else
                      alarm_out_reg(2) <= '0';
              end if;
          end if;
     end if;
    end if;
   end process;


    alm_p : process(ot_out_reg, ot_en, alarm_out_reg, alarm_en)
    begin
             ot_out <= ot_out_reg and ot_en;
             alarm_out(0) <= alarm_out_reg(0) and alarm_en(0);
             alarm_out(1) <= alarm_out_reg(1) and alarm_en(1);
             alarm_out(2) <= alarm_out_reg(2) and alarm_en(2);
      end process;

-- end alarm


  READFILE_P : process
      file in_file : text;
      variable open_status : file_open_status;
      variable in_buf    : line;
      variable str_token : string(1 to 12);
      variable str_token_in : string(1 to 12);
      variable str_token_tmp : string(1 to 12);
      variable next_time     : time := 0 ps; 
      variable pre_time : time := 0 ps; 
      variable time_val : integer := 0;
      variable a1   : real;

      variable commentline : boolean := false;
      variable HeaderFound : boolean := false;
      variable read_ok : boolean := false;
      variable token_len : integer;
      variable HeaderCount : integer := 0;

      variable vals : ANALOG_DATA := (others => 0.0);
      variable valsn : ANALOG_DATA := (others => 0.0);
      variable inchannel : integer := 0 ;
      type int_a is array (0 to 41) of integer;
      variable index_to_channel : int_a := (others => -1);
      variable low : integer := -1;
      variable low2 : integer := -1;
      variable sim_file_flag1 : std_ulogic := '0';
      variable file_line : integer := 0;

      type channm_array is array (0 to 31 ) of string(1 to  12);
      constant chanlist_p : channm_array := (
       0 => "TEMP" & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL,
       1 => "VCCINT" & NUL & NUL & NUL & NUL & NUL & NUL,
       2 => "VCCAUX" & NUL & NUL & NUL & NUL & NUL & NUL,	
       3 => "VP" & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL,
       4 => NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL &
             NUL & NUL,
       5 => NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL &
             NUL & NUL,
       6 => "xxxxxxxxxxxx",
       7 => "xxxxxxxxxxxx",
       8 => NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL &
             NUL & NUL,
       9 => NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL &
             NUL & NUL,
       10 => "xxxxxxxxxxxx",
       11 => "xxxxxxxxxxxx",
       12 => "xxxxxxxxxxxx",
       13 => "xxxxxxxxxxxx",
       14 => "xxxxxxxxxxxx",
       15 => "xxxxxxxxxxxx",
       16 => "VAUXP[0]" & NUL & NUL & NUL & NUL,
       17 => "VAUXP[1]" & NUL & NUL & NUL & NUL,
       18 => "VAUXP[2]" & NUL & NUL & NUL & NUL,
       19 => "VAUXP[3]" & NUL & NUL & NUL & NUL,
       20 => "VAUXP[4]" & NUL & NUL & NUL & NUL,
       21 => "VAUXP[5]" & NUL & NUL & NUL & NUL,
       22 => "VAUXP[6]" & NUL & NUL & NUL & NUL,
       23 => "VAUXP[7]" & NUL & NUL & NUL & NUL,
       24 => "VAUXP[8]" & NUL & NUL & NUL & NUL,
       25 => "VAUXP[9]" & NUL & NUL & NUL & NUL,
       26 => "VAUXP[10]" & NUL & NUL & NUL,
       27 => "VAUXP[11]" & NUL & NUL & NUL,
       28 => "VAUXP[12]" & NUL & NUL & NUL,
       29 => "VAUXP[13]" & NUL & NUL & NUL,
       30 => "VAUXP[14]" & NUL & NUL & NUL,
       31 => "VAUXP[15]" & NUL & NUL & NUL
      );
       
      constant chanlist_n : channm_array := (
       0 => "xxxxxxxxxxxx",
       1 => "xxxxxxxxxxxx",
       2 => "xxxxxxxxxxxx",
       3 => "VN" & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL,
       4 => NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL &
             NUL & NUL,
       5 => NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL &
             NUL & NUL,
       6 => "xxxxxxxxxxxx",
       7 => "xxxxxxxxxxxx",
       8 => NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL &
             NUL & NUL,
       9 => NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL &
             NUL & NUL,
       10 => "xxxxxxxxxxxx",
       11 => "xxxxxxxxxxxx",
       12 => "xxxxxxxxxxxx",
       13 => "xxxxxxxxxxxx",
       14 => "xxxxxxxxxxxx",
       15 => "xxxxxxxxxxxx",
       16 => "VAUXN[0]" & NUL & NUL & NUL & NUL,
       17 => "VAUXN[1]" & NUL & NUL & NUL & NUL,
       18 => "VAUXN[2]" & NUL & NUL & NUL & NUL,
       19 => "VAUXN[3]" & NUL & NUL & NUL & NUL,
       20 => "VAUXN[4]" & NUL & NUL & NUL & NUL,
       21 => "VAUXN[5]" & NUL & NUL & NUL & NUL,
       22 => "VAUXN[6]" & NUL & NUL & NUL & NUL,
       23 => "VAUXN[7]" & NUL & NUL & NUL & NUL,
       24 => "VAUXN[8]" & NUL & NUL & NUL & NUL,
       25 => "VAUXN[9]" & NUL & NUL & NUL & NUL,
       26 => "VAUXN[10]" & NUL & NUL & NUL,
       27 => "VAUXN[11]" & NUL & NUL & NUL,
       28 => "VAUXN[12]" & NUL & NUL & NUL,
       29 => "VAUXN[13]" & NUL & NUL & NUL,
       30 => "VAUXN[14]" & NUL & NUL & NUL,
       31 => "VAUXN[15]" & NUL & NUL & NUL
           );

  begin
 
    file_open(open_status, in_file, SIM_MONITOR_FILE, read_mode);
    if (open_status /= open_ok) then
         assert false report
         "*** Warning: The analog data file for SYSMON was not found. Use the SIM_MONITOR_FILE generic to specify the input analog data file name or use default name: design.txt. "
         severity warning; 
         sim_file_flag1 := '1';
         sim_file_flag <= '1';
    end if;

   if ( sim_file_flag1 = '0') then
      while (not endfile(in_file) and (not HeaderFound)) loop
        commentline := false;
        readline(in_file, in_buf);
        file_line := file_line + 1;
        if (in_buf'LENGTH > 0 ) then
          skip_blanks(in_buf);
        
          low := in_buf'low;
          low2 := in_buf'low+2;
           if ( low2 <= in_buf'high) then
              if ((in_buf(in_buf'low to in_buf'low+1) = "//" ) or 
                  (in_buf(in_buf'low to in_buf'low+1) = "--" )) then
                 commentline := true;
               end if;

               while((in_buf'LENGTH > 0 ) and (not commentline)) loop
                   HeaderFound := true;
                   get_token(in_buf, str_token_in, token_len);
                   str_token_tmp := To_Upper(str_token_in);
                   if (str_token_tmp(1 to 4) = "TEMP") then
                      str_token := "TEMP" & NUL & NUL & NUL & NUL & NUL 
                                                  & NUL & NUL & NUL;
                   else
                      str_token := str_token_tmp;
                   end if;

                   if(token_len > 0) then
                    HeaderCount := HeaderCount + 1;
                   end if;
       
                   if (HeaderCount=1) then
                      if (str_token(1 to token_len) /= "TIME") then
                         infile_format;
                         assert false report
                  " Analog Data File Error : No TIME label is found in the input file for X_SYSMON."
                         severity failure;
                      end if;
                   elsif (HeaderCount > 1) then
                      inchannel := -1;
                      for i in 0 to 31 loop
                          if (chanlist_p(i) = str_token) then
                             inchannel := i;
                             index_to_channel(headercount) := i;
                           end if;
                       end loop;
                       if (inchannel = -1) then
                         for i in 0 to 31 loop
                           if ( chanlist_n(i) = str_token) then
                             inchannel := i;
                             index_to_channel(headercount) := i+32;
                           end if;
                         end loop;
                       end if;
                       if (inchannel = -1 and token_len >0) then
                           infile_format;
                           assert false report
                    "Analog Data File Error : No valid channel name in the input file for X_SYSMON. Valid names: TEMP VCCINT VCCAUX VP VN VAUXP[1] VAUXN[1] ....."
                           severity failure;
                       end if;
                  else
                       infile_format;
                       assert false report
                    "Analog Data File Error : NOT found header in the input file for X_SYSMON. The header is: TIME TEMP VCCINT VCCAUX VP VN VAUXP[1] VAUXN[1] ..."
                           severity failure;
                  end if;

           str_token_in := NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL &
                           NUL & NUL & NUL & NUL;
        end loop;
        end if;
       end if;
      end loop;

-----  Read Values
      while (not endfile(in_file)) loop
        commentline := false;
        readline(in_file, in_buf);
        file_line := file_line + 1;
        if (in_buf'length > 0) then
           skip_blanks(in_buf);
        
           if (in_buf'low < in_buf'high) then
             if((in_buf(in_buf'low to in_buf'low+1) = "//" ) or 
                    (in_buf(in_buf'low to in_buf'low+1) = "--" )) then
              commentline := true;
             end if;
 
          if(not commentline and in_buf'length > 0) then
            for i IN 1 to HeaderCount Loop
              if ( i=1) then
                 read(in_buf, time_val, read_ok);
                if (not read_ok) then
                  infile_format;
                  assert false report
                   " Analog Data File Error : The time value should be integer in ns scale and the last time value needs bigger than simulation time."
                  severity failure;
                 end if;
                 next_time := time_val * 1 ns; 
              else
               read(in_buf, a1, read_ok);
               if (not read_ok) then
                  assert false report
                    "*** Analog Data File Error: The data type should be REAL, e.g. 3.0  0.0  -0.5 "
                  severity failure;
               end if;
               inchannel:= index_to_channel(i);
              if (inchannel >= 32) then
                valsn(inchannel-32):=a1;
              else
                vals(inchannel):=a1;
              end if;
            end if;
           end loop;  -- i loop

           if ( now < next_time) then
               wait for ( next_time - now ); 
           end if;
           for i in 0 to 31 loop
                 chan_val_tmp(i) <= vals(i);
                 chan_valn_tmp(i) <= valsn(i);
                 analog_in_diff(i) <= vals(i)-valsn(i);
                 analog_in_uni(i) <= vals(i);
           end loop;
        end if;
        end if;
       end if;
      end loop;  -- while loop
      file_close(in_file);
    end if;
    wait;
  end process READFILE_P;



  TIMING : process

--  Pin timing violations (clock input pins)

--  Pin Timing Violations (all input pins)
	variable  Tmkr_CONVST_CONVST_posedge : VitalTimingDataType := VitalTimingDataInit;
	variable  Tmkr_DADDR0_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
	variable  Tmkr_DADDR1_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
	variable  Tmkr_DADDR2_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
	variable  Tmkr_DADDR3_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
	variable  Tmkr_DADDR4_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
	variable  Tmkr_DADDR5_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
	variable  Tmkr_DADDR6_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
	variable  Tmkr_DEN_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
	variable  Tmkr_DI0_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
	variable  Tmkr_DI10_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
	variable  Tmkr_DI11_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
	variable  Tmkr_DI12_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
	variable  Tmkr_DI13_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
	variable  Tmkr_DI14_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
	variable  Tmkr_DI15_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
	variable  Tmkr_DI1_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
	variable  Tmkr_DI2_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
	variable  Tmkr_DI3_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
	variable  Tmkr_DI4_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
	variable  Tmkr_DI5_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
	variable  Tmkr_DI6_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
	variable  Tmkr_DI7_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
	variable  Tmkr_DI8_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
	variable  Tmkr_DI9_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
	variable  Tmkr_DWE_DCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
	variable Tviol_CONVST_CONVST_posedge : STD_ULOGIC := '0';
	variable Tviol_DADDR0_DCLK_posedge : STD_ULOGIC := '0';
	variable Tviol_DADDR1_DCLK_posedge : STD_ULOGIC := '0';
	variable Tviol_DADDR2_DCLK_posedge : STD_ULOGIC := '0';
	variable Tviol_DADDR3_DCLK_posedge : STD_ULOGIC := '0';
	variable Tviol_DADDR4_DCLK_posedge : STD_ULOGIC := '0';
	variable Tviol_DADDR5_DCLK_posedge : STD_ULOGIC := '0';
	variable Tviol_DADDR6_DCLK_posedge : STD_ULOGIC := '0';
	variable Tviol_DEN_DCLK_posedge : STD_ULOGIC := '0';
	variable Tviol_DI0_DCLK_posedge : STD_ULOGIC := '0';
	variable Tviol_DI10_DCLK_posedge : STD_ULOGIC := '0';
	variable Tviol_DI11_DCLK_posedge : STD_ULOGIC := '0';
	variable Tviol_DI12_DCLK_posedge : STD_ULOGIC := '0';
	variable Tviol_DI13_DCLK_posedge : STD_ULOGIC := '0';
	variable Tviol_DI14_DCLK_posedge : STD_ULOGIC := '0';
	variable Tviol_DI15_DCLK_posedge : STD_ULOGIC := '0';
	variable Tviol_DI1_DCLK_posedge : STD_ULOGIC := '0';
	variable Tviol_DI2_DCLK_posedge : STD_ULOGIC := '0';
	variable Tviol_DI3_DCLK_posedge : STD_ULOGIC := '0';
	variable Tviol_DI4_DCLK_posedge : STD_ULOGIC := '0';
	variable Tviol_DI5_DCLK_posedge : STD_ULOGIC := '0';
	variable Tviol_DI6_DCLK_posedge : STD_ULOGIC := '0';
	variable Tviol_DI7_DCLK_posedge : STD_ULOGIC := '0';
	variable Tviol_DI8_DCLK_posedge : STD_ULOGIC := '0';
	variable Tviol_DI9_DCLK_posedge : STD_ULOGIC := '0';
	variable Tviol_DWE_DCLK_posedge : STD_ULOGIC := '0';

--  Output Pin glitch declaration
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
	variable  DRDY_GlitchData : VitalGlitchDataType;
	variable  OT_GlitchData : VitalGlitchDataType;
	variable  ALM0_GlitchData : VitalGlitchDataType;
	variable  ALM1_GlitchData : VitalGlitchDataType;
	variable  ALM2_GlitchData : VitalGlitchDataType;
	variable  CHANNEL0_GlitchData : VitalGlitchDataType;
	variable  CHANNEL1_GlitchData : VitalGlitchDataType;
	variable  CHANNEL2_GlitchData : VitalGlitchDataType;
	variable  CHANNEL3_GlitchData : VitalGlitchDataType;
	variable  CHANNEL4_GlitchData : VitalGlitchDataType;
	variable  EOC_GlitchData : VitalGlitchDataType;
	variable  EOS_GlitchData : VitalGlitchDataType;
	variable  BUSY_GlitchData : VitalGlitchDataType;
begin

--  Setup/Hold Check Violations (all input pins)

     if (TimingChecksOn) then
	VitalSetupHoldCheck
	(
	Violation => Tviol_DI0_DCLK_posedge,
	TimingData => Tmkr_DI0_DCLK_posedge,
	TestSignal => DI_dly(0),
	TestSignalName => "DI(0)",
	TestDelay => tisd_DI(0),
	RefSignal => DCLK_dly,
	RefSignalName => "DCLK",
	RefDelay => ticd_DCLK,
	SetupHigh => tsetup_DI_DCLK_posedge_posedge(0),
	SetupLow => tsetup_DI_DCLK_negedge_posedge(0),
	HoldLow => thold_DI_DCLK_posedge_posedge(0),
	HoldHigh => thold_DI_DCLK_negedge_posedge(0),
	CheckEnabled   => TRUE,
	RefTransition  => 'R',
	HeaderMsg      => InstancePath & "/X_SYSMON",
	Xon            => Xon,
	MsgOn          => MsgOn,
	MsgSeverity    => WARNING
	);
	VitalSetupHoldCheck
	(
	Violation => Tviol_DI1_DCLK_posedge,
	TimingData => Tmkr_DI1_DCLK_posedge,
	TestSignal => DI_dly(1),
	TestSignalName => "DI(1)",
	TestDelay => tisd_DI(1),
	RefSignal => DCLK_dly,
	RefSignalName => "DCLK",
	RefDelay => ticd_DCLK,
	SetupHigh => tsetup_DI_DCLK_posedge_posedge(1),
	SetupLow => tsetup_DI_DCLK_negedge_posedge(1),
	HoldLow => thold_DI_DCLK_posedge_posedge(1),
	HoldHigh => thold_DI_DCLK_negedge_posedge(1),
	CheckEnabled   => TRUE,
	RefTransition  => 'R',
	HeaderMsg      => InstancePath & "/X_SYSMON",
	Xon            => Xon,
	MsgOn          => MsgOn,
	MsgSeverity    => WARNING
	);
	VitalSetupHoldCheck
	(
	Violation => Tviol_DI2_DCLK_posedge,
	TimingData => Tmkr_DI2_DCLK_posedge,
	TestSignal => DI_dly(2),
	TestSignalName => "DI(2)",
	TestDelay => tisd_DI(2),
	RefSignal => DCLK_dly,
	RefSignalName => "DCLK",
	RefDelay => ticd_DCLK,
	SetupHigh => tsetup_DI_DCLK_posedge_posedge(2),
	SetupLow => tsetup_DI_DCLK_negedge_posedge(2),
	HoldLow => thold_DI_DCLK_posedge_posedge(2),
	HoldHigh => thold_DI_DCLK_negedge_posedge(2),
	CheckEnabled   => TRUE,
	RefTransition  => 'R',
	HeaderMsg      => InstancePath & "/X_SYSMON",
	Xon            => Xon,
	MsgOn          => MsgOn,
	MsgSeverity    => WARNING
	);
	VitalSetupHoldCheck
	(
	Violation => Tviol_DI3_DCLK_posedge,
	TimingData => Tmkr_DI3_DCLK_posedge,
	TestSignal => DI_dly(3),
	TestSignalName => "DI(3)",
	TestDelay => tisd_DI(3),
	RefSignal => DCLK_dly,
	RefSignalName => "DCLK",
	RefDelay => ticd_DCLK,
	SetupHigh => tsetup_DI_DCLK_posedge_posedge(3),
	SetupLow => tsetup_DI_DCLK_negedge_posedge(3),
	HoldLow => thold_DI_DCLK_posedge_posedge(3),
	HoldHigh => thold_DI_DCLK_negedge_posedge(3),
	CheckEnabled   => TRUE,
	RefTransition  => 'R',
	HeaderMsg      => InstancePath & "/X_SYSMON",
	Xon            => Xon,
	MsgOn          => MsgOn,
	MsgSeverity    => WARNING
	);
	VitalSetupHoldCheck
	(
	Violation => Tviol_DI4_DCLK_posedge,
	TimingData => Tmkr_DI4_DCLK_posedge,
	TestSignal => DI_dly(4),
	TestSignalName => "DI(4)",
	TestDelay => tisd_DI(4),
	RefSignal => DCLK_dly,
	RefSignalName => "DCLK",
	RefDelay => ticd_DCLK,
	SetupHigh => tsetup_DI_DCLK_posedge_posedge(4),
	SetupLow => tsetup_DI_DCLK_negedge_posedge(4),
	HoldLow => thold_DI_DCLK_posedge_posedge(4),
	HoldHigh => thold_DI_DCLK_negedge_posedge(4),
	CheckEnabled   => TRUE,
	RefTransition  => 'R',
	HeaderMsg      => InstancePath & "/X_SYSMON",
	Xon            => Xon,
	MsgOn          => MsgOn,
	MsgSeverity    => WARNING
	);
	VitalSetupHoldCheck
	(
	Violation => Tviol_DI5_DCLK_posedge,
	TimingData => Tmkr_DI5_DCLK_posedge,
	TestSignal => DI_dly(5),
	TestSignalName => "DI(5)",
	TestDelay => tisd_DI(5),
	RefSignal => DCLK_dly,
	RefSignalName => "DCLK",
	RefDelay => ticd_DCLK,
	SetupHigh => tsetup_DI_DCLK_posedge_posedge(5),
	SetupLow => tsetup_DI_DCLK_negedge_posedge(5),
	HoldLow => thold_DI_DCLK_posedge_posedge(5),
	HoldHigh => thold_DI_DCLK_negedge_posedge(5),
	CheckEnabled   => TRUE,
	RefTransition  => 'R',
	HeaderMsg      => InstancePath & "/X_SYSMON",
	Xon            => Xon,
	MsgOn          => MsgOn,
	MsgSeverity    => WARNING
	);
	VitalSetupHoldCheck
	(
	Violation => Tviol_DI6_DCLK_posedge,
	TimingData => Tmkr_DI6_DCLK_posedge,
	TestSignal => DI_dly(6),
	TestSignalName => "DI(6)",
	TestDelay => tisd_DI(6),
	RefSignal => DCLK_dly,
	RefSignalName => "DCLK",
	RefDelay => ticd_DCLK,
	SetupHigh => tsetup_DI_DCLK_posedge_posedge(6),
	SetupLow => tsetup_DI_DCLK_negedge_posedge(6),
	HoldLow => thold_DI_DCLK_posedge_posedge(6),
	HoldHigh => thold_DI_DCLK_negedge_posedge(6),
	CheckEnabled   => TRUE,
	RefTransition  => 'R',
	HeaderMsg      => InstancePath & "/X_SYSMON",
	Xon            => Xon,
	MsgOn          => MsgOn,
	MsgSeverity    => WARNING
	);
	VitalSetupHoldCheck
	(
	Violation => Tviol_DI7_DCLK_posedge,
	TimingData => Tmkr_DI7_DCLK_posedge,
	TestSignal => DI_dly(7),
	TestSignalName => "DI(7)",
	TestDelay => tisd_DI(7),
	RefSignal => DCLK_dly,
	RefSignalName => "DCLK",
	RefDelay => ticd_DCLK,
	SetupHigh => tsetup_DI_DCLK_posedge_posedge(7),
	SetupLow => tsetup_DI_DCLK_negedge_posedge(7),
	HoldLow => thold_DI_DCLK_posedge_posedge(7),
	HoldHigh => thold_DI_DCLK_negedge_posedge(7),
	CheckEnabled   => TRUE,
	RefTransition  => 'R',
	HeaderMsg      => InstancePath & "/X_SYSMON",
	Xon            => Xon,
	MsgOn          => MsgOn,
	MsgSeverity    => WARNING
	);
	VitalSetupHoldCheck
	(
	Violation => Tviol_DI8_DCLK_posedge,
	TimingData => Tmkr_DI8_DCLK_posedge,
	TestSignal => DI_dly(8),
	TestSignalName => "DI(8)",
	TestDelay => tisd_DI(8),
	RefSignal => DCLK_dly,
	RefSignalName => "DCLK",
	RefDelay => ticd_DCLK,
	SetupHigh => tsetup_DI_DCLK_posedge_posedge(8),
	SetupLow => tsetup_DI_DCLK_negedge_posedge(8),
	HoldLow => thold_DI_DCLK_posedge_posedge(8),
	HoldHigh => thold_DI_DCLK_negedge_posedge(8),
	CheckEnabled   => TRUE,
	RefTransition  => 'R',
	HeaderMsg      => InstancePath & "/X_SYSMON",
	Xon            => Xon,
	MsgOn          => MsgOn,
	MsgSeverity    => WARNING
	);
	VitalSetupHoldCheck
	(
	Violation => Tviol_DI9_DCLK_posedge,
	TimingData => Tmkr_DI9_DCLK_posedge,
	TestSignal => DI_dly(9),
	TestSignalName => "DI(9)",
	TestDelay => tisd_DI(9),
	RefSignal => DCLK_dly,
	RefSignalName => "DCLK",
	RefDelay => ticd_DCLK,
	SetupHigh => tsetup_DI_DCLK_posedge_posedge(9),
	SetupLow => tsetup_DI_DCLK_negedge_posedge(9),
	HoldLow => thold_DI_DCLK_posedge_posedge(9),
	HoldHigh => thold_DI_DCLK_negedge_posedge(9),
	CheckEnabled   => TRUE,
	RefTransition  => 'R',
	HeaderMsg      => InstancePath & "/X_SYSMON",
	Xon            => Xon,
	MsgOn          => MsgOn,
	MsgSeverity    => WARNING
	);
	VitalSetupHoldCheck
	(
	Violation => Tviol_DI10_DCLK_posedge,
	TimingData => Tmkr_DI10_DCLK_posedge,
	TestSignal => DI_dly(10),
	TestSignalName => "DI(10)",
	TestDelay => tisd_DI(10),
	RefSignal => DCLK_dly,
	RefSignalName => "DCLK",
	RefDelay => ticd_DCLK,
	SetupHigh => tsetup_DI_DCLK_posedge_posedge(10),
	SetupLow => tsetup_DI_DCLK_negedge_posedge(10),
	HoldLow => thold_DI_DCLK_posedge_posedge(10),
	HoldHigh => thold_DI_DCLK_negedge_posedge(10),
	CheckEnabled   => TRUE,
	RefTransition  => 'R',
	HeaderMsg      => InstancePath & "/X_SYSMON",
	Xon            => Xon,
	MsgOn          => MsgOn,
	MsgSeverity    => WARNING
	);
	VitalSetupHoldCheck
	(
	Violation => Tviol_DI11_DCLK_posedge,
	TimingData => Tmkr_DI11_DCLK_posedge,
	TestSignal => DI_dly(11),
	TestSignalName => "DI(11)",
	TestDelay => tisd_DI(11),
	RefSignal => DCLK_dly,
	RefSignalName => "DCLK",
	RefDelay => ticd_DCLK,
	SetupHigh => tsetup_DI_DCLK_posedge_posedge(11),
	SetupLow => tsetup_DI_DCLK_negedge_posedge(11),
	HoldLow => thold_DI_DCLK_posedge_posedge(11),
	HoldHigh => thold_DI_DCLK_negedge_posedge(11),
	CheckEnabled   => TRUE,
	RefTransition  => 'R',
	HeaderMsg      => InstancePath & "/X_SYSMON",
	Xon            => Xon,
	MsgOn          => MsgOn,
	MsgSeverity    => WARNING
	);
	VitalSetupHoldCheck
	(
	Violation => Tviol_DI12_DCLK_posedge,
	TimingData => Tmkr_DI12_DCLK_posedge,
	TestSignal => DI_dly(12),
	TestSignalName => "DI(12)",
	TestDelay => tisd_DI(12),
	RefSignal => DCLK_dly,
	RefSignalName => "DCLK",
	RefDelay => ticd_DCLK,
	SetupHigh => tsetup_DI_DCLK_posedge_posedge(12),
	SetupLow => tsetup_DI_DCLK_negedge_posedge(12),
	HoldLow => thold_DI_DCLK_posedge_posedge(12),
	HoldHigh => thold_DI_DCLK_negedge_posedge(12),
	CheckEnabled   => TRUE,
	RefTransition  => 'R',
	HeaderMsg      => InstancePath & "/X_SYSMON",
	Xon            => Xon,
	MsgOn          => MsgOn,
	MsgSeverity    => WARNING
	);
	VitalSetupHoldCheck
	(
	Violation => Tviol_DI13_DCLK_posedge,
	TimingData => Tmkr_DI13_DCLK_posedge,
	TestSignal => DI_dly(13),
	TestSignalName => "DI(13)",
	TestDelay => tisd_DI(13),
	RefSignal => DCLK_dly,
	RefSignalName => "DCLK",
	RefDelay => ticd_DCLK,
	SetupHigh => tsetup_DI_DCLK_posedge_posedge(13),
	SetupLow => tsetup_DI_DCLK_negedge_posedge(13),
	HoldLow => thold_DI_DCLK_posedge_posedge(13),
	HoldHigh => thold_DI_DCLK_negedge_posedge(13),
	CheckEnabled   => TRUE,
	RefTransition  => 'R',
	HeaderMsg      => InstancePath & "/X_SYSMON",
	Xon            => Xon,
	MsgOn          => MsgOn,
	MsgSeverity    => WARNING
	);
	VitalSetupHoldCheck
	(
	Violation => Tviol_DI14_DCLK_posedge,
	TimingData => Tmkr_DI14_DCLK_posedge,
	TestSignal => DI_dly(14),
	TestSignalName => "DI(14)",
	TestDelay => tisd_DI(14),
	RefSignal => DCLK_dly,
	RefSignalName => "DCLK",
	RefDelay => ticd_DCLK,
	SetupHigh => tsetup_DI_DCLK_posedge_posedge(14),
	SetupLow => tsetup_DI_DCLK_negedge_posedge(14),
	HoldLow => thold_DI_DCLK_posedge_posedge(14),
	HoldHigh => thold_DI_DCLK_negedge_posedge(14),
	CheckEnabled   => TRUE,
	RefTransition  => 'R',
	HeaderMsg      => InstancePath & "/X_SYSMON",
	Xon            => Xon,
	MsgOn          => MsgOn,
	MsgSeverity    => WARNING
	);
	VitalSetupHoldCheck
	(
	Violation => Tviol_DI15_DCLK_posedge,
	TimingData => Tmkr_DI15_DCLK_posedge,
	TestSignal => DI_dly(15),
	TestSignalName => "DI(15)",
	TestDelay => tisd_DI(15),
	RefSignal => DCLK_dly,
	RefSignalName => "DCLK",
	RefDelay => ticd_DCLK,
	SetupHigh => tsetup_DI_DCLK_posedge_posedge(15),
	SetupLow => tsetup_DI_DCLK_negedge_posedge(15),
	HoldLow => thold_DI_DCLK_posedge_posedge(15),
	HoldHigh => thold_DI_DCLK_negedge_posedge(15),
	CheckEnabled   => TRUE,
	RefTransition  => 'R',
	HeaderMsg      => InstancePath & "/X_SYSMON",
	Xon            => Xon,
	MsgOn          => MsgOn,
	MsgSeverity    => WARNING
	);
	VitalSetupHoldCheck
	(
	Violation => Tviol_DADDR0_DCLK_posedge,
	TimingData => Tmkr_DADDR0_DCLK_posedge,
	TestSignal => DADDR_dly(0),
	TestSignalName => "DADDR(0)",
	TestDelay => tisd_DADDR(0),
	RefSignal => DCLK_dly,
	RefSignalName => "DCLK",
	RefDelay => ticd_DCLK,
	SetupHigh => tsetup_DADDR_DCLK_posedge_posedge(0),
	SetupLow => tsetup_DADDR_DCLK_negedge_posedge(0),
	HoldLow => thold_DADDR_DCLK_posedge_posedge(0),
	HoldHigh => thold_DADDR_DCLK_negedge_posedge(0),
	CheckEnabled   => TRUE,
	RefTransition  => 'R',
	HeaderMsg      => InstancePath & "/X_SYSMON",
	Xon            => Xon,
	MsgOn          => MsgOn,
	MsgSeverity    => WARNING
	);
	VitalSetupHoldCheck
	(
	Violation => Tviol_DADDR1_DCLK_posedge,
	TimingData => Tmkr_DADDR1_DCLK_posedge,
	TestSignal => DADDR_dly(1),
	TestSignalName => "DADDR(1)",
	TestDelay => tisd_DADDR(1),
	RefSignal => DCLK_dly,
	RefSignalName => "DCLK",
	RefDelay => ticd_DCLK,
	SetupHigh => tsetup_DADDR_DCLK_posedge_posedge(1),
	SetupLow => tsetup_DADDR_DCLK_negedge_posedge(1),
	HoldLow => thold_DADDR_DCLK_posedge_posedge(1),
	HoldHigh => thold_DADDR_DCLK_negedge_posedge(1),
	CheckEnabled   => TRUE,
	RefTransition  => 'R',
	HeaderMsg      => InstancePath & "/X_SYSMON",
	Xon            => Xon,
	MsgOn          => MsgOn,
	MsgSeverity    => WARNING
	);
	VitalSetupHoldCheck
	(
	Violation => Tviol_DADDR2_DCLK_posedge,
	TimingData => Tmkr_DADDR2_DCLK_posedge,
	TestSignal => DADDR_dly(2),
	TestSignalName => "DADDR(2)",
	TestDelay => tisd_DADDR(2),
	RefSignal => DCLK_dly,
	RefSignalName => "DCLK",
	RefDelay => ticd_DCLK,
	SetupHigh => tsetup_DADDR_DCLK_posedge_posedge(2),
	SetupLow => tsetup_DADDR_DCLK_negedge_posedge(2),
	HoldLow => thold_DADDR_DCLK_posedge_posedge(2),
	HoldHigh => thold_DADDR_DCLK_negedge_posedge(2),
	CheckEnabled   => TRUE,
	RefTransition  => 'R',
	HeaderMsg      => InstancePath & "/X_SYSMON",
	Xon            => Xon,
	MsgOn          => MsgOn,
	MsgSeverity    => WARNING
	);
	VitalSetupHoldCheck
	(
	Violation => Tviol_DADDR3_DCLK_posedge,
	TimingData => Tmkr_DADDR3_DCLK_posedge,
	TestSignal => DADDR_dly(3),
	TestSignalName => "DADDR(3)",
	TestDelay => tisd_DADDR(3),
	RefSignal => DCLK_dly,
	RefSignalName => "DCLK",
	RefDelay => ticd_DCLK,
	SetupHigh => tsetup_DADDR_DCLK_posedge_posedge(3),
	SetupLow => tsetup_DADDR_DCLK_negedge_posedge(3),
	HoldLow => thold_DADDR_DCLK_posedge_posedge(3),
	HoldHigh => thold_DADDR_DCLK_negedge_posedge(3),
	CheckEnabled   => TRUE,
	RefTransition  => 'R',
	HeaderMsg      => InstancePath & "/X_SYSMON",
	Xon            => Xon,
	MsgOn          => MsgOn,
	MsgSeverity    => WARNING
	);
	VitalSetupHoldCheck
	(
	Violation => Tviol_DADDR4_DCLK_posedge,
	TimingData => Tmkr_DADDR4_DCLK_posedge,
	TestSignal => DADDR_dly(4),
	TestSignalName => "DADDR(4)",
	TestDelay => tisd_DADDR(4),
	RefSignal => DCLK_dly,
	RefSignalName => "DCLK",
	RefDelay => ticd_DCLK,
	SetupHigh => tsetup_DADDR_DCLK_posedge_posedge(4),
	SetupLow => tsetup_DADDR_DCLK_negedge_posedge(4),
	HoldLow => thold_DADDR_DCLK_posedge_posedge(4),
	HoldHigh => thold_DADDR_DCLK_negedge_posedge(4),
	CheckEnabled   => TRUE,
	RefTransition  => 'R',
	HeaderMsg      => InstancePath & "/X_SYSMON",
	Xon            => Xon,
	MsgOn          => MsgOn,
	MsgSeverity    => WARNING
	);
	VitalSetupHoldCheck
	(
	Violation => Tviol_DADDR5_DCLK_posedge,
	TimingData => Tmkr_DADDR5_DCLK_posedge,
	TestSignal => DADDR_dly(5),
	TestSignalName => "DADDR(5)",
	TestDelay => tisd_DADDR(5),
	RefSignal => DCLK_dly,
	RefSignalName => "DCLK",
	RefDelay => ticd_DCLK,
	SetupHigh => tsetup_DADDR_DCLK_posedge_posedge(5),
	SetupLow => tsetup_DADDR_DCLK_negedge_posedge(5),
	HoldLow => thold_DADDR_DCLK_posedge_posedge(5),
	HoldHigh => thold_DADDR_DCLK_negedge_posedge(5),
	CheckEnabled   => TRUE,
	RefTransition  => 'R',
	HeaderMsg      => InstancePath & "/X_SYSMON",
	Xon            => Xon,
	MsgOn          => MsgOn,
	MsgSeverity    => WARNING
	);
	VitalSetupHoldCheck
	(
	Violation => Tviol_DADDR6_DCLK_posedge,
	TimingData => Tmkr_DADDR6_DCLK_posedge,
	TestSignal => DADDR_dly(6),
	TestSignalName => "DADDR(6)",
	TestDelay => tisd_DADDR(6),
	RefSignal => DCLK_dly,
	RefSignalName => "DCLK",
	RefDelay => ticd_DCLK,
	SetupHigh => tsetup_DADDR_DCLK_posedge_posedge(6),
	SetupLow => tsetup_DADDR_DCLK_negedge_posedge(6),
	HoldLow => thold_DADDR_DCLK_posedge_posedge(6),
	HoldHigh => thold_DADDR_DCLK_negedge_posedge(6),
	CheckEnabled   => TRUE,
	RefTransition  => 'R',
	HeaderMsg      => InstancePath & "/X_SYSMON",
	Xon            => Xon,
	MsgOn          => MsgOn,
	MsgSeverity    => WARNING
	);
	VitalSetupHoldCheck
	(
	Violation      => Tviol_DEN_DCLK_posedge,
	TimingData     => Tmkr_DEN_DCLK_posedge,
	TestSignal     => DEN,
	TestSignalName => "DEN",
	TestDelay      => 0 ns,
	RefSignal => DCLK_dly,
	RefSignalName  => "DCLK",
	RefDelay       => 0 ns,
	SetupHigh      => tsetup_DEN_DCLK_posedge_posedge,
	SetupLow       => tsetup_DEN_DCLK_negedge_posedge,
	HoldLow        => thold_DEN_DCLK_posedge_posedge,
	HoldHigh       => thold_DEN_DCLK_negedge_posedge,
	CheckEnabled   => TRUE,
	RefTransition  => 'R',
	HeaderMsg      => InstancePath & "/X_SYSMON",
	Xon            => Xon,
	MsgOn          => MsgOn,
	MsgSeverity    => WARNING
	);
	VitalSetupHoldCheck
	(
	Violation      => Tviol_DWE_DCLK_posedge,
	TimingData     => Tmkr_DWE_DCLK_posedge,
	TestSignal     => DWE,
	TestSignalName => "DWE",
	TestDelay      => 0 ns,
	RefSignal => DCLK_dly,
	RefSignalName  => "DCLK",
	RefDelay       => 0 ns,
	SetupHigh      => tsetup_DWE_DCLK_posedge_posedge,
	SetupLow       => tsetup_DWE_DCLK_negedge_posedge,
	HoldLow        => thold_DWE_DCLK_posedge_posedge,
	HoldHigh       => thold_DWE_DCLK_negedge_posedge,
	CheckEnabled   => TRUE,
	RefTransition  => 'R',
	HeaderMsg      => InstancePath & "/X_SYSMON",
	Xon            => Xon,
	MsgOn          => MsgOn,
	MsgSeverity    => WARNING
	);
     end if;
-- End of (TimingChecksOn)

--  Output-to-Clock path delay
	VitalPathDelay01
	(
	OutSignal     => DO(0),
	GlitchData    => DO0_GlitchData,
	OutSignalName => "DO(0)",
	OutTemp       => DO_OUT(0),
	Paths       => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(0),TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);
	VitalPathDelay01
	(
	OutSignal     => DO(1),
	GlitchData    => DO1_GlitchData,
	OutSignalName => "DO(1)",
	OutTemp       => DO_OUT(1),
	Paths       => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(1),TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);
	VitalPathDelay01
	(
	OutSignal     => DO(2),
	GlitchData    => DO2_GlitchData,
	OutSignalName => "DO(2)",
	OutTemp       => DO_OUT(2),
	Paths       => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(2),TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);
	VitalPathDelay01
	(
	OutSignal     => DO(3),
	GlitchData    => DO3_GlitchData,
	OutSignalName => "DO(3)",
	OutTemp       => DO_OUT(3),
	Paths       => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(3),TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);
	VitalPathDelay01
	(
	OutSignal     => DO(4),
	GlitchData    => DO4_GlitchData,
	OutSignalName => "DO(4)",
	OutTemp       => DO_OUT(4),
	Paths       => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(4),TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);
	VitalPathDelay01
	(
	OutSignal     => DO(5),
	GlitchData    => DO5_GlitchData,
	OutSignalName => "DO(5)",
	OutTemp       => DO_OUT(5),
	Paths       => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(5),TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);
	VitalPathDelay01
	(
	OutSignal     => DO(6),
	GlitchData    => DO6_GlitchData,
	OutSignalName => "DO(6)",
	OutTemp       => DO_OUT(6),
	Paths       => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(6),TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);
	VitalPathDelay01
	(
	OutSignal     => DO(7),
	GlitchData    => DO7_GlitchData,
	OutSignalName => "DO(7)",
	OutTemp       => DO_OUT(7),
	Paths       => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(7),TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);
	VitalPathDelay01
	(
	OutSignal     => DO(8),
	GlitchData    => DO8_GlitchData,
	OutSignalName => "DO(8)",
	OutTemp       => DO_OUT(8),
	Paths       => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(8),TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);
	VitalPathDelay01
	(
	OutSignal     => DO(9),
	GlitchData    => DO9_GlitchData,
	OutSignalName => "DO(9)",
	OutTemp       => DO_OUT(9),
	Paths       => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(9),TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);
	VitalPathDelay01
	(
	OutSignal     => DO(10),
	GlitchData    => DO10_GlitchData,
	OutSignalName => "DO(10)",
	OutTemp       => DO_OUT(10),
	Paths       => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(10),TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);
	VitalPathDelay01
	(
	OutSignal     => DO(11),
	GlitchData    => DO11_GlitchData,
	OutSignalName => "DO(11)",
	OutTemp       => DO_OUT(11),
	Paths       => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(11),TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);
	VitalPathDelay01
	(
	OutSignal     => DO(12),
	GlitchData    => DO12_GlitchData,
	OutSignalName => "DO(12)",
	OutTemp       => DO_OUT(12),
	Paths       => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(12),TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);
	VitalPathDelay01
	(
	OutSignal     => DO(13),
	GlitchData    => DO13_GlitchData,
	OutSignalName => "DO(13)",
	OutTemp       => DO_OUT(13),
	Paths       => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(13),TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);
	VitalPathDelay01
	(
	OutSignal     => DO(14),
	GlitchData    => DO14_GlitchData,
	OutSignalName => "DO(14)",
	OutTemp       => DO_OUT(14),
	Paths       => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(14),TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);
	VitalPathDelay01
	(
	OutSignal     => DO(15),
	GlitchData    => DO15_GlitchData,
	OutSignalName => "DO(15)",
	OutTemp       => DO_OUT(15),
	Paths       => (0 => (DCLK_dly'last_event, tpd_DCLK_DO(15),TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);
	VitalPathDelay01
	(
	OutSignal     => DRDY,
	GlitchData    => DRDY_GlitchData,
	OutSignalName => "DRDY",
	OutTemp       => DRDY_OUT,
	Paths         => (0 => (DCLK_dly'last_event, tpd_DCLK_DRDY,TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);
	VitalPathDelay01
	(
	OutSignal     => OT,
	GlitchData    => OT_GlitchData,
	OutSignalName => "OT",
	OutTemp       => OT_OUT,
	Paths         => (0 => (DCLK_dly'last_event, tpd_DCLK_OT,TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);
	VitalPathDelay01
	(
	OutSignal     => ALM(0),
	GlitchData    => ALM0_GlitchData,
	OutSignalName => "ALM(0)",
	OutTemp       => alarm_out(0),
	Paths       => (0 => (DCLK_dly'last_event, tpd_DCLK_ALM(0),TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);
	VitalPathDelay01
	(
	OutSignal     => ALM(1),
	GlitchData    => ALM1_GlitchData,
	OutSignalName => "ALM(1)",
	OutTemp       => alarm_out(1),
	Paths       => (0 => (DCLK_dly'last_event, tpd_DCLK_ALM(1),TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);
	VitalPathDelay01
	(
	OutSignal     => ALM(2),
	GlitchData    => ALM2_GlitchData,
	OutSignalName => "ALM(2)",
	OutTemp       => alarm_out(2),
	Paths       => (0 => (DCLK_dly'last_event, tpd_DCLK_ALM(2),TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);
	VitalPathDelay01
	(
	OutSignal     => CHANNEL(0),
	GlitchData    => CHANNEL0_GlitchData,
	OutSignalName => "CHANNEL(0)",
	OutTemp       => CHANNEL_OUT(0),
	Paths       => (0 => (DCLK_dly'last_event, tpd_DCLK_CHANNEL(0),TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);
	VitalPathDelay01
	(
	OutSignal     => CHANNEL(1),
	GlitchData    => CHANNEL1_GlitchData,
	OutSignalName => "CHANNEL(1)",
	OutTemp       => CHANNEL_OUT(1),
	Paths       => (0 => (DCLK_dly'last_event, tpd_DCLK_CHANNEL(1),TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);
	VitalPathDelay01
	(
	OutSignal     => CHANNEL(2),
	GlitchData    => CHANNEL2_GlitchData,
	OutSignalName => "CHANNEL(2)",
	OutTemp       => CHANNEL_OUT(2),
	Paths       => (0 => (DCLK_dly'last_event, tpd_DCLK_CHANNEL(2),TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);
	VitalPathDelay01
	(
	OutSignal     => CHANNEL(3),
	GlitchData    => CHANNEL3_GlitchData,
	OutSignalName => "CHANNEL(3)",
	OutTemp       => CHANNEL_OUT(3),
	Paths       => (0 => (DCLK_dly'last_event, tpd_DCLK_CHANNEL(3),TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);
	VitalPathDelay01
	(
	OutSignal     => CHANNEL(4),
	GlitchData    => CHANNEL4_GlitchData,
	OutSignalName => "CHANNEL(4)",
	OutTemp       => CHANNEL_OUT(4),
	Paths       => (0 => (DCLK_dly'last_event, tpd_DCLK_CHANNEL(4),TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);
	VitalPathDelay01
	(
	OutSignal     => EOC,
	GlitchData    => EOC_GlitchData,
	OutSignalName => "EOC",
	OutTemp       => EOC_OUT,
	Paths         => (0 => (DCLK_dly'last_event, tpd_DCLK_EOC,TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);
	VitalPathDelay01
	(
	OutSignal     => EOS,
	GlitchData    => EOS_GlitchData,
	OutSignalName => "EOS",
	OutTemp       => EOS_OUT,
	Paths         => (0 => (DCLK_dly'last_event, tpd_DCLK_EOS,TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);
	VitalPathDelay01
	(
	OutSignal     => BUSY,
	GlitchData    => BUSY_GlitchData,
	OutSignalName => "BUSY",
	OutTemp       => BUSY_OUT,
	Paths         => (0 => (DCLK_dly'last_event, tpd_DCLK_BUSY,TRUE)),
	Mode          => VitalTransport,
	Xon           => false,
	MsgOn         => false,
	MsgSeverity   => WARNING
	);

--  Wait signal (input/output pins)
   wait on
	DI_dly,
	DADDR_dly,
	DEN_dly,
	DWE_dly,
	DO_OUT,
	DRDY_OUT,
	DCLK_dly,
	CONVSTCLK_dly,
	RESET_dly,
	CONVST_dly,
	OT_OUT,
	alarm_out,
	CHANNEL_OUT,
	EOC_OUT,
	EOS_OUT,
	BUSY_OUT;

	end process; 


end X_SYSMON_V;
-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  Boundary Scan Logic Control Circuit for SPARTAN3A
-- /___/   /\     Filename : X_BSCAN_SPARTAN3A.vhd
-- \   \  /  \    Timestamp : Tue Jul  5 16:58:04 PDT 2005
--  \___\/\___\
--
-- Revision:
--    07/05/05 - Initial version.
--    01/24/06 - CR 224623, added TCK and TMS ports
-- End Revision

----- CELL X_BSCAN_SPARTAN3A -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.Vcomponents.all;
use simprim.VPACKAGE.all;

entity X_BSCAN_SPARTAN3A is

  generic(
      TimingChecksOn : boolean := true;
      InstancePath   : string  := "*";
      Xon            : boolean := true;
      MsgOn          : boolean := true;
      LOC            : string  := "UNPLACED"
      );

  port(
      CAPTURE : out std_ulogic := 'H';
      DRCK1   : out std_ulogic := 'L';
      DRCK2   : out std_ulogic := 'L';
      RESET   : out std_ulogic := 'L';
      SEL1    : out std_ulogic := 'L';
      SEL2    : out std_ulogic := 'L';
      SHIFT   : out std_ulogic := 'L';
      TCK     : out std_ulogic := 'L';
      TDI     : out std_ulogic := 'L';
      TMS     : out std_ulogic := 'L';
      UPDATE  : out std_ulogic := 'L';

      TDO1 : in std_ulogic := 'X';
      TDO2 : in std_ulogic := 'X'
      );
end X_BSCAN_SPARTAN3A;



-- architecture body  

architecture X_BSCAN_SPARTAN3A_V of X_BSCAN_SPARTAN3A is




  signal        TDO1_dly         : std_ulogic := '0';
  signal        TDO2_dly         : std_ulogic := '0';

begin



  --------------------
  --  BEHAVIOR SECTION
  --------------------



-- synopsys translate_off

      CAPTURE <= JTAG_CAPTURE_GLBL ;

--####################################################################
--#####                        jtag_select                         ###
--####################################################################
      DRCK1  <= ((JTAG_SEL1_GLBL and not JTAG_SHIFT_GLBL and not JTAG_CAPTURE_GLBL)
                                     or
                 (JTAG_SEL1_GLBL and JTAG_SHIFT_GLBL and JTAG_TCK_GLBL)
                                     or
                 (JTAG_SEL1_GLBL and JTAG_CAPTURE_GLBL and JTAG_TCK_GLBL));
      DRCK2  <= ((JTAG_SEL2_GLBL and not JTAG_SHIFT_GLBL and not JTAG_CAPTURE_GLBL)
                                     or
                 (JTAG_SEL2_GLBL and JTAG_SHIFT_GLBL and JTAG_TCK_GLBL)
                                     or
                 (JTAG_SEL2_GLBL and JTAG_CAPTURE_GLBL and JTAG_TCK_GLBL));
      RESET  <= JTAG_RESET_GLBL ;
      SEL1   <= JTAG_SEL1_GLBL;
      SEL2   <= JTAG_SEL2_GLBL;
      SHIFT  <= JTAG_SHIFT_GLBL;
      TCK    <= JTAG_TCK_GLBL;
      TDI    <= JTAG_TDI_GLBL;
      TMS    <= JTAG_TMS_GLBL;
      UPDATE <= JTAG_UPDATE_GLBL;

      JTAG_USER_TDO1_GLBL <=  TDO1;
      JTAG_USER_TDO2_GLBL <=  TDO2;

-- synopsys translate_on


end X_BSCAN_SPARTAN3A_V;

-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                       Device DNA Data Access Port
-- /___/   /\     Filename : X_DNA_PORT.vhd
-- \   \  /  \    Timestamp : Mon Oct 10 15:21:52 PDT 2005
--  \___\/\___\
--
-- Revision:
--    10/10/05 - Initial version
--    06/04/08 - CR 472697 -- added check for SIM_DNA_VALUE
-- End Revision

----- CELL X_DNA_PORT -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.Vcomponents.all;
use simprim.VPACKAGE.all;

entity X_DNA_PORT is

  generic(

      TimingChecksOn : boolean := true;
      InstancePath   : string  := "*";
      Xon            : boolean := true;
      MsgOn          : boolean := true;
      LOC            : string  := "UNPLACED";
--  VITAL input Pin path delay variables
      tipd_CLK : VitalDelayType01 := (0 ps, 0 ps);
      tipd_DIN : VitalDelayType01 := (0 ps, 0 ps);
      tipd_GSR : VitalDelayType01 := (0 ps, 0 ps);
      tipd_READ  : VitalDelayType01 := (0 ps, 0 ps);
      tipd_SHIFT : VitalDelayType01 := (0 ps, 0 ps);

--  VITAL clk-to-output path delay variables
      tpd_CLK_DOUT : VitalDelayType01 := (100 ps, 100 ps);

--  VITAL tisd & tisd variables
      ticd_CLK       : VitalDelayType   := 0 ps;
      tisd_DIN_CLK   : VitalDelayType   := 0 ps;
      tisd_GSR_CLK   : VitalDelayType   := 0 ps;
      tisd_READ_CLK  : VitalDelayType   := 0 ps;
      tisd_SHIFT_CLK : VitalDelayType   := 0 ps;

--  VITAL Setup/Hold delay variables
      tsetup_DIN_CLK_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_DIN_CLK_negedge_posedge : VitalDelayType := 0 ps;
      thold_DIN_CLK_posedge_posedge : VitalDelayType := 0 ps;
      thold_DIN_CLK_negedge_posedge : VitalDelayType := 0 ps;

      tsetup_READ_CLK_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_READ_CLK_negedge_posedge : VitalDelayType := 0 ps;
      thold_READ_CLK_posedge_posedge : VitalDelayType := 0 ps;
      thold_READ_CLK_negedge_posedge : VitalDelayType := 0 ps;

      tsetup_SHIFT_CLK_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_SHIFT_CLK_negedge_posedge : VitalDelayType := 0 ps;
      thold_SHIFT_CLK_posedge_posedge : VitalDelayType := 0 ps;
      thold_SHIFT_CLK_negedge_posedge : VitalDelayType := 0 ps;

      SIM_DNA_VALUE : bit_vector := X"000000000000000"
      );

  port(
    DOUT  : out std_ulogic;

    CLK   : in std_ulogic;
    DIN   : in std_ulogic;
    READ  : in std_ulogic;
    SHIFT : in std_ulogic
    );

  attribute VITAL_LEVEL0 of
    X_DNA_PORT : entity is true;

end X_DNA_PORT;

architecture X_DNA_PORT_V of X_DNA_PORT is

  attribute VITAL_LEVEL0 of
    X_DNA_PORT_V : architecture is true;

-----------------------------------------------------------
-----------------------------------------------------------
  function eval_init (
                         sim_dna_val : in  bit_vector;
                         msb         : in integer
              ) return std_logic_vector is
  variable ret_sim_dna_val : std_logic_vector (msb downto 0);
  variable tmp_sim_dna_val : std_logic_vector ((sim_dna_val'length-1) downto 0);
  begin
    if (sim_dna_val'length >= msb ) then
--        ret_sim_dna_val(msb downto 0)  := To_stdLogicVector(sim_dna_val((sim_dna_val'length-msb-1) to (sim_dna_val'length-1)));
        tmp_sim_dna_val((sim_dna_val'length-1) downto 0) := To_stdLogicVector(sim_dna_val);
        ret_sim_dna_val(msb downto 0) := tmp_sim_dna_val(msb downto 0);

    else
        ret_sim_dna_val := (others => '0');
        ret_sim_dna_val((sim_dna_val'length-1) downto 0) := To_stdLogicVector(sim_dna_val);
    end if;

    return ret_sim_dna_val(msb downto 0);
  end;
-----------------------------------------------------------
-----------------------------------------------------------

  constant MAX_DNA_BITS     : integer := 57;
  constant MSB_DNA_BITS     : integer := (MAX_DNA_BITS - 1);

  constant SYNC_PATH_DELAY      : time := 100 ps;

  signal        CLK_ipd          : std_ulogic := 'X';
  signal        DIN_ipd          : std_ulogic := 'X';
  signal        GSR_ipd          : std_ulogic := '0';
  signal        READ_ipd         : std_ulogic := 'X';
  signal        SHIFT_ipd        : std_ulogic := 'X';

  signal        CLK_dly          : std_ulogic := 'X';
  signal        DIN_dly          : std_ulogic := 'X';
  signal        GSR_dly          : std_ulogic := '0';
  signal        READ_dly         : std_ulogic := 'X';
  signal        SHIFT_dly        : std_ulogic := 'X';

  signal        DOUT_zd          : std_ulogic := 'X';

  signal        dna_val          : std_logic_vector(MSB_DNA_BITS downto 0) := eval_init(SIM_DNA_VALUE, MSB_DNA_BITS);

  signal	Violation        : std_ulogic := '0';

begin
  ---------------------
  --  INPUT PATH DELAYs
  --------------------

  WireDelay : block
  begin
    VitalWireDelay (CLK_ipd,   CLK,   tipd_CLK);
    VitalWireDelay (DIN_ipd,   DIN,   tipd_DIN);
    VitalWireDelay (GSR_ipd,   GSR,   tipd_GSR);
    VitalWireDelay (READ_ipd,  READ,  tipd_READ);
    VitalWireDelay (SHIFT_ipd, SHIFT, tipd_SHIFT);
  end block;

  SignalDelay : block
  begin
    VitalSignalDelay (CLK_dly,   CLK_ipd,   ticd_CLK);
    VitalSignalDelay (DIN_dly,   DIN_ipd,   tisd_DIN_CLK);
    VitalSignalDelay (GSR_dly,   GSR_ipd,   tisd_GSR_CLK);
    VitalSignalDelay (READ_dly,  READ_ipd,  tisd_READ_CLK);
    VitalSignalDelay (SHIFT_dly, SHIFT_ipd, tisd_SHIFT_CLK);

  end block;

  --------------------
  --  BEHAVIOR SECTION
  --------------------

--####################################################################
--#####                        Initialization                      ###
--####################################################################
  prcs_init:process
  begin
    if(dna_val(MSB_DNA_BITS downto (MSB_DNA_BITS -1)) /= "10") then
       assert false
       report "Attribute Syntax Warning: SIM_DNA_VALUE bits [56:55] on component X_DNA_PORT do not match the expected value ""10"". The simulation will not exactly model the hardware behavior, as detailed in the Spartan-3 Generation FPGA User Guide." 
       severity warning;
    end if;
    wait;
  end process prcs_init;

--####################################################################
--#####                            READ                            ###
--####################################################################
  prcs_read:process(CLK_dly, GSR_dly, READ_dly, SHIFT_dly)
  begin
     if(GSR_dly = '1') then
        dna_val(0) <= '0';
     elsif(GSR_dly = '0') then
        if(rising_edge(CLK_dly)) then
           if(READ_dly = '1') then
              dna_val(MSB_DNA_BITS downto 0) <= eval_init(SIM_DNA_VALUE, MSB_DNA_BITS);
              dna_val(0) <= '1';
           elsif(READ_dly = '0') then
               if(SHIFT_dly = '1') then
                  dna_val <= DIN_dly & dna_val(MSB_DNA_BITS downto 1);
               end if; -- SHIFT_dly = '1'   
           end if;  -- READ_dly = '1'  
        end if; -- rising_edge(CLK_dly)   
     end if; -- GSR_dly = '1'   
  end process prcs_read;

--####################################################################
--#####             Update Zero Delay Output                     #####
--####################################################################

DOUT_zd <= dna_val(0);




--####################################################################
--#####                   TIMING CHECKS & OUTPUT                 #####
--####################################################################
  prcs_tmngchk:process
  variable Tmkr_DIN_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_DIN_CLK_posedge : std_ulogic          := '0';
  variable Tmkr_READ_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_READ_CLK_posedge : std_ulogic          := '0';
  variable Tmkr_SHIFT_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_SHIFT_CLK_posedge : std_ulogic          := '0';

  variable Pviol_CLK : std_ulogic          := '0';
  variable PInfo_CLK : VitalPeriodDataType := VitalPeriodDataInit;

  begin
    if(TimingChecksOn) then

--======================== DIN =============================
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DIN_CLK_posedge,
         TimingData     => Tmkr_DIN_CLK_posedge,
         TestSignal     => DIN_dly,
         TestSignalName => "DIN",
         TestDelay      => tisd_DIN_CLK,
         RefSignal      => CLK_dly,
         RefSignalName  => "CLK",
         RefDelay       => ticd_CLK,
         SetupHigh      => tsetup_DIN_CLK_posedge_posedge,
         SetupLow       => tsetup_DIN_CLK_negedge_posedge,
         HoldLow        => thold_DIN_CLK_posedge_posedge,
         HoldHigh       => thold_DIN_CLK_negedge_posedge,
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_DNA_PORT",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING);

--======================= READ ==============================
     VitalSetupHoldCheck
       (
         Violation      => Tviol_READ_CLK_posedge,
         TimingData     => Tmkr_READ_CLK_posedge,
         TestSignal     => READ_dly,
         TestSignalName => "READ",
         TestDelay      => tisd_READ_CLK,
         RefSignal      => CLK_dly,
         RefSignalName  => "CLK",
         RefDelay       => ticd_CLK,
         SetupHigh      => tsetup_READ_CLK_posedge_posedge,
         SetupLow       => tsetup_READ_CLK_negedge_posedge,
         HoldLow        => thold_READ_CLK_posedge_posedge,
         HoldHigh       => thold_READ_CLK_negedge_posedge,
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_DNA_PORT",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING);

--======================= SHIFT ==============================
     VitalSetupHoldCheck
       (
         Violation      => Tviol_SHIFT_CLK_posedge,
         TimingData     => Tmkr_SHIFT_CLK_posedge,
         TestSignal     => SHIFT_dly,
         TestSignalName => "SHIFT",
         TestDelay      => tisd_SHIFT_CLK,
         RefSignal      => CLK_dly,
         RefSignalName  => "CLK",
         RefDelay       => ticd_CLK,
         SetupHigh      => tsetup_SHIFT_CLK_posedge_posedge,
         SetupLow       => tsetup_SHIFT_CLK_negedge_posedge,
         HoldLow        => thold_SHIFT_CLK_posedge_posedge,
         HoldHigh       => thold_SHIFT_CLK_negedge_posedge,
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_DNA_PORT",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING);
--=====================================================
    end if;

    Violation <= Tviol_DIN_CLK_posedge or Tviol_READ_CLK_posedge or
                 Tviol_SHIFT_CLK_posedge  or Pviol_CLK;

    wait on CLK_dly, GSR_dly;
  end process prcs_tmngchk;
--####################################################################
--#####                           OUTPUT                         #####
--####################################################################
  prcs_output:process
  variable DOUT_GlitchData     : VitalGlitchDataType;

  variable DOUT_zd_viol : std_ulogic := '0';

  begin

    DOUT_zd_viol := Violation xor DOUT_zd; 

    VitalPathDelay01 (
      OutSignal  => DOUT,
      GlitchData => DOUT_GlitchData,
      OutSignalName => "DOUT",
      OutTemp => DOUT_zd_viol,
      Paths => (0 => (CLK_dly'last_event, tpd_CLK_DOUT, true)),
      Mode => VitalTransport,
      Xon => Xon,
      MsgOn => True,
      MsgSeverity => WARNING
      );
     wait on DOUT_zd, Violation;
  end process prcs_output;


end X_DNA_PORT_V;

-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                       Dynamically Adjustable Input Delay Buffer
-- /___/   /\     Filename : X_IBUF_DLY_ADJ.vhd
-- \   \  /  \    Timestamp : Tue Apr 19 08:18:20 PST 2005
--  \___\/\___\
--
-- Revision:
--    04/19/05 - Initial version.
--    06/30/06 - CR 233887 -- Corrected generic ordering
--    08/08/07 - CR 439320 -- Simprim fix -- Added attributes SIM_DELAY0, ... SIM_DELAY16 to fix timing issues
--    09/11/07 - CR 447604 -- When S[2:0]=0, it should correlate to 1 tap
-- End Revision


----- CELL X_IBUF_DLY_ADJ -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;


library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.VPACKAGE.all;

entity X_IBUF_DLY_ADJ is

  generic(

      TimingChecksOn : boolean := true;
      InstancePath   : string  := "*";
      Xon            : boolean := true;
      MsgOn          : boolean := true;
      LOC            : string  := "UNPLACED";
      

--  VITAL input Pin path delay variables
      tipd_I      : VitalDelayType01 := (0 ps, 0 ps);
      tipd_S      : VitalDelayArrayType01 (2 downto 0 ) := (others => (0 ps, 0 ps));

--  VITAL clk-to-output path delay variables
      tpd_I_O   : VitalDelayType01 := (0 ps, 0 ps);
      tpd_S_O   : VitalDelayArrayType01 (2 downto 0 ) := (others => (0 ps, 0 ps));


      DELAY_OFFSET : string := "OFF";
      IOSTANDARD : string := "DEFAULT";
      SIM_DELAY0 : integer := 0;
      SIM_DELAY1 : integer := 0;
      SIM_DELAY2 : integer := 0;
      SIM_DELAY3 : integer := 0;
      SIM_DELAY4 : integer := 0;
      SIM_DELAY5 : integer := 0;
      SIM_DELAY6 : integer := 0;
      SIM_DELAY7 : integer := 0;
      SIM_DELAY8 : integer := 0;
      SIM_DELAY9 : integer := 0;
      SIM_DELAY10 : integer := 0;
      SIM_DELAY11 : integer := 0;
      SIM_DELAY12 : integer := 0;
      SIM_DELAY13 : integer := 0;
      SIM_DELAY14 : integer := 0;
      SIM_DELAY15 : integer := 0;
      SIM_DELAY16 : integer := 0;
      SIM_TAPDELAY_VALUE  : integer := 200;
      SPECTRUM_OFFSET_DELAY : time := 1600 ps
      );

  port(
      O      : out std_ulogic;

      I      : in  std_ulogic;
      S      : in  std_logic_vector (2 downto 0)
      );

  attribute VITAL_LEVEL0 of
    X_IBUF_DLY_ADJ : entity is true;

end X_IBUF_DLY_ADJ;

architecture X_IBUF_DLY_ADJ_V OF X_IBUF_DLY_ADJ is

  attribute VITAL_LEVEL0 of
    X_IBUF_DLY_ADJ_V : architecture is true;

  ---------------------------------------------------------
  -- Function  str_2_int converts string to integer
  ---------------------------------------------------------
  function str_2_int(str: in string ) return integer is
  variable int : integer;
  variable val : integer := 0;
  variable neg_flg   : boolean := false;
  variable is_it_int : boolean := true;
  begin
    int := 0;
    val := 0;
    is_it_int := true;
    neg_flg   := false;

    for i in  1 to str'length loop
      case str(i) is
         when  '-'
           =>
             if(i = 1) then
                neg_flg := true;
                val := -1;
             end if;
         when  '1'
           =>  val := 1;
         when  '2'
           =>   val := 2;
         when  '3'
           =>   val := 3;
         when  '4'
           =>   val := 4;
         when  '5'
           =>   val := 5;
         when  '6'
           =>   val := 6;
         when  '7'
           =>   val := 7;
         when  '8'
           =>   val := 8;
         when  '9'
           =>   val := 9;
         when  '0'
           =>   val := 0;
         when others
           => is_it_int := false;
        end case;
        if(val /= -1) then
          int := int *10  + val;
        end if;
        val := 0;
    end loop;
    if(neg_flg) then
      int := int * (-1);
    end if;

    if(NOT is_it_int) then
      int := -9999;
    end if;
    return int;
  end;
-----------------------------------------------------------

  constant      MAX_S		: integer := 3;
  constant      MAX_TAP		: integer := 7;
  constant      MIN_TAP		: integer := 0;

  constant      MSB_S		: integer := MAX_S -1;
  constant      LSB_S		: integer := 0;

  constant	SYNC_PATH_DELAY	: time := 0 ps;


  signal	O_zd		: std_ulogic := 'X';
  signal	O_viol		: std_ulogic := 'X';

  signal	I_ipd		: std_ulogic := 'X';
  signal        S_ipd           : std_logic_vector(MSB_S downto LSB_S);

  signal	INITIAL_DELAY	: time  := 0 ps;
  signal	DELAY   	: time  := 0 ps;

begin

  ---------------------
  --  INPUT PATH DELAYs
  --------------------

  WireDelay : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
    S_WireDelay: for i in MSB_S downto LSB_S generate
       VitalWireDelay (S_ipd(i), S(i), tipd_S(i));
    end generate S_WireDelay;
  end block;


  --------------------
  --  BEHAVIOR SECTION
  --------------------


--####################################################################
--#####                     Initialize                           #####
--####################################################################
  prcs_init:process
  variable TapCount_var   : integer := 0;
  variable IsTapDelay_var : boolean := true; 
  variable IsTapFixed_var : boolean := false; 
  variable IsTapDefault_var : boolean := false; 
  begin
     if((DELAY_OFFSET /= "ON") and (DELAY_OFFSET /= "on") and 
        (DELAY_OFFSET /= "OFF") and (DELAY_OFFSET /= "off")) then
           GenericValueCheckMessage
           (  HeaderMsg  => " Attribute Syntax Warning ",
              GenericName => " DELAY_OFFSET ",
              EntityName => "/X_IBUF_DLY_ADJ",
              GenericValue => DELAY_OFFSET,
              Unit => "",
              ExpectedValueMsg => " The Legal values for this attribute are ",
              ExpectedGenericValue => " ON or  OFF ",
              TailMsg => "",
              MsgSeverity => failure 
           );
     end if; 

     if((DELAY_OFFSET = "ON") or (DELAY_OFFSET = "on")) then  
-- CR 447604
--        INITIAL_DELAY <= SPECTRUM_OFFSET_DELAY;
        INITIAL_DELAY <= SPECTRUM_OFFSET_DELAY + (SIM_TAPDELAY_VALUE * 1 ps);
     else
--        INITIAL_DELAY <=  0 ps;
        INITIAL_DELAY <=  SIM_TAPDELAY_VALUE * 1 ps;
     end if;
     wait;
  end process prcs_init;
--####################################################################
--#####                  CALCULATE DELAY                         #####
--####################################################################
  prcs_s:process(S_ipd)
  variable TapCount_var : integer := 0;
  variable FIRST_TIME   : boolean :=true;
  variable BaseTime_var : time    := 1 ps ;
  variable delay_var    : time    := 0 ps ;
  variable S_int_var    : integer := 0;
  begin
     S_int_var := SLV_TO_INT(S_ipd);

     if((S_int_var >= MIN_TAP) and (S_int_var <= MAX_TAP)) then
         Delay        <= S_int_var * SIM_TAPDELAY_VALUE * BaseTime_var + INITIAL_DELAY;
     end if;
  end process prcs_s;

--####################################################################
--#####                      DELAY INPUT                         #####
--####################################################################
  prcs_i:process(I_ipd)
  begin
      O_zd <= transport I_ipd after delay; 
  end process prcs_i;


--####################################################################
--#####                   TIMING CHECKS & OUTPUT                 #####
--####################################################################
  prcs_tmngchk:process
  variable   Tviol_CE_C_posedge      : std_ulogic := '0';
  variable   Tmkr_CE_C_posedge       : VitalTimingDataType := VitalTimingDataInit;
  variable   Violation               : std_ulogic          := '0';

  begin
--  Setup/Hold Check Violations (all input pins)


     O_viol <= Violation xor O_zd;

     wait on I_ipd, S_ipd, O_zd;

  end process prcs_tmngchk;
--####################################################################
--#####                           OUTPUT                         #####
--####################################################################
  prcs_output:process
  variable tpd_I_O_var : VitalDelayType01 := (SIM_DELAY0 * 1.0 ps, SIM_DELAY0 * 1.0 ps);
  variable  O_GlitchData : VitalGlitchDataType;
  begin
    if(DELAY_OFFSET = "OFF") then 
      case S_ipd is
        when "000" => tpd_I_O_var := (SIM_DELAY1 * 1.0 ps, SIM_DELAY1 * 1.0 ps); 
        when "001" => tpd_I_O_var := (SIM_DELAY2 * 1.0 ps, SIM_DELAY2 * 1.0 ps); 
        when "010" => tpd_I_O_var := (SIM_DELAY3 * 1.0 ps, SIM_DELAY3 * 1.0 ps); 
        when "011" => tpd_I_O_var := (SIM_DELAY4 * 1.0 ps, SIM_DELAY4 * 1.0 ps); 
        when "100" => tpd_I_O_var := (SIM_DELAY5 * 1.0 ps, SIM_DELAY5 * 1.0 ps); 
        when "101" => tpd_I_O_var := (SIM_DELAY6 * 1.0 ps, SIM_DELAY6 * 1.0 ps); 
        when "110" => tpd_I_O_var := (SIM_DELAY7 * 1.0 ps, SIM_DELAY7 * 1.0 ps); 
        when "111" => tpd_I_O_var := (SIM_DELAY8 * 1.0 ps, SIM_DELAY8 * 1.0 ps); 
        when others => null;
      end case;
    elsif (DELAY_OFFSET = "ON") then
      case S_ipd is
        when "000" => tpd_I_O_var := (SIM_DELAY9 * 1.0 ps, SIM_DELAY9 * 1.0 ps); 
        when "001" => tpd_I_O_var := (SIM_DELAY10 * 1.0 ps, SIM_DELAY10 * 1.0 ps); 
        when "010" => tpd_I_O_var := (SIM_DELAY11 * 1.0 ps, SIM_DELAY11 * 1.0 ps); 
        when "011" => tpd_I_O_var := (SIM_DELAY12 * 1.0 ps, SIM_DELAY12 * 1.0 ps); 
        when "100" => tpd_I_O_var := (SIM_DELAY13 * 1.0 ps, SIM_DELAY13 * 1.0 ps); 
        when "101" => tpd_I_O_var := (SIM_DELAY14 * 1.0 ps, SIM_DELAY14 * 1.0 ps); 
        when "110" => tpd_I_O_var := (SIM_DELAY15 * 1.0 ps, SIM_DELAY15 * 1.0 ps); 
        when "111" => tpd_I_O_var := (SIM_DELAY16 * 1.0 ps, SIM_DELAY16 * 1.0 ps); 
        when others => null;
      end case;
    end if;


     VitalPathDelay01
       (
         OutSignal     => O,
         GlitchData    => O_GlitchData,
         OutSignalName => "O",
         OutTemp       => O_viol,
         Paths         => (0 => (S_ipd'last_event, tpd_I_O_var, TRUE)),
         Mode          => VitalTransport,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );

     wait on O_viol;
  end process prcs_output;


end X_IBUF_DLY_ADJ_V;

-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                       Dynamically Adjustable Differential Input Delay Buffer
-- /___/   /\     Filename :    X_IBUFDS_DLY_ADJ.vhd
-- \   \  /  \    Timestamp :   Tue Apr 19 08:18:20 PST 2005
--  \___\/\___\
--
-- Revision:
--    04/19/05 - Initial version.
--    06/30/06 - CR 233887 -- Corrected generic ordering
--    08/08/07 - CR 439320 -- Simprim fix -- Added attributes SIM_DELAY0, ... SIM_DELAY16 to fix timing issues
--    09/11/07 - CR 447604 -- When S[2:0]=0, it should correlate to 1 tap
-- End Revision
----- CELL X_IBUFDS_DLY_ADJ -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;


library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.VPACKAGE.all;

entity X_IBUFDS_DLY_ADJ is

  generic(

      TimingChecksOn : boolean := true;
      InstancePath   : string  := "*";
      Xon            : boolean := true;
      MsgOn          : boolean := true;
      LOC            : string  := "UNPLACED";
      

--  VITAL input Pin path delay variables
      tipd_I      : VitalDelayType01 := (0 ps, 0 ps);
      tipd_IB     : VitalDelayType01 := (0 ps, 0 ps);
      tipd_S      : VitalDelayArrayType01 (2 downto 0 ) := (others => (0 ps, 0 ps));

--  VITAL clk-to-output path delay variables
      tpd_I_O   : VitalDelayType01 := (0 ps, 0 ps);
      tpd_IB_O  : VitalDelayType01 := (0 ps, 0 ps);
      tpd_S_O   : VitalDelayArrayType01 (2 downto 0 ) := (others => (0 ps, 0 ps));


--  VITAL tisd & tisd variables

--  VITAL Setup/Hold delay variables

-- VITAL pulse width variables

-- VITAL period variables

-- VITAL recovery time variables

-- VITAL removal time variables

      DELAY_OFFSET : string := "OFF";
      DIFF_TERM   : boolean :=  FALSE;
      IOSTANDARD : string := "DEFAULT";
      SIM_DELAY0 : integer := 0;
      SIM_DELAY1 : integer := 0;
      SIM_DELAY2 : integer := 0;
      SIM_DELAY3 : integer := 0;
      SIM_DELAY4 : integer := 0;
      SIM_DELAY5 : integer := 0;
      SIM_DELAY6 : integer := 0;
      SIM_DELAY7 : integer := 0;
      SIM_DELAY8 : integer := 0;
      SIM_DELAY9 : integer := 0;
      SIM_DELAY10 : integer := 0;
      SIM_DELAY11 : integer := 0;
      SIM_DELAY12 : integer := 0;
      SIM_DELAY13 : integer := 0;
      SIM_DELAY14 : integer := 0;
      SIM_DELAY15 : integer := 0;
      SIM_DELAY16 : integer := 0;
      SIM_TAPDELAY_VALUE  : integer := 200;
      SPECTRUM_OFFSET_DELAY : time := 1600 ps
      );

  port(
      O      : out std_ulogic;

      I      : in  std_ulogic;
      IB     : in  std_ulogic;
      S      : in  std_logic_vector (2 downto 0)
      );

  attribute VITAL_LEVEL0 of
    X_IBUFDS_DLY_ADJ : entity is true;

end X_IBUFDS_DLY_ADJ;

architecture X_IBUFDS_DLY_ADJ_V OF X_IBUFDS_DLY_ADJ is

  attribute VITAL_LEVEL0 of
    X_IBUFDS_DLY_ADJ_V : architecture is true;

  ---------------------------------------------------------
  -- Function  str_2_int converts string to integer
  ---------------------------------------------------------
  function str_2_int(str: in string ) return integer is
  variable int : integer;
  variable val : integer := 0;
  variable neg_flg   : boolean := false;
  variable is_it_int : boolean := true;
  begin
    int := 0;
    val := 0;
    is_it_int := true;
    neg_flg   := false;

    for i in  1 to str'length loop
      case str(i) is
         when  '-'
           =>
             if(i = 1) then
                neg_flg := true;
                val := -1;
             end if;
         when  '1'
           =>  val := 1;
         when  '2'
           =>   val := 2;
         when  '3'
           =>   val := 3;
         when  '4'
           =>   val := 4;
         when  '5'
           =>   val := 5;
         when  '6'
           =>   val := 6;
         when  '7'
           =>   val := 7;
         when  '8'
           =>   val := 8;
         when  '9'
           =>   val := 9;
         when  '0'
           =>   val := 0;
         when others
           => is_it_int := false;
        end case;
        if(val /= -1) then
          int := int *10  + val;
        end if;
        val := 0;
    end loop;
    if(neg_flg) then
      int := int * (-1);
    end if;

    if(NOT is_it_int) then
      int := -9999;
    end if;
    return int;
  end;
-----------------------------------------------------------

  
  constant      MAX_S		: integer := 3;
  constant      MAX_TAP		: integer := 7;
  constant      MIN_TAP		: integer := 0;

  constant      MSB_S		: integer := MAX_S -1;
  constant      LSB_S		: integer := 0;

  constant	SYNC_PATH_DELAY	: time := 0 ps;


  signal	O_zd		: std_ulogic := 'X';
  signal	O_viol		: std_ulogic := 'X';

  signal	I_int		: std_ulogic := 'X';

  signal	I_ipd		: std_ulogic := 'X';
  signal	IB_ipd		: std_ulogic := 'X';
  signal        S_ipd           : std_logic_vector(MSB_S downto LSB_S);

  signal	INITIAL_DELAY	: time  := 0 ps;
  signal	DELAY   	: time  := 0 ps;

begin

  ---------------------
  --  INPUT PATH DELAYs
  --------------------

  WireDelay : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
    VitalWireDelay (IB_ipd, IB, tipd_IB);
    S_WireDelay: for i in MSB_S downto LSB_S generate
       VitalWireDelay (S_ipd(i), S(i), tipd_S(i));
    end generate S_WireDelay;
  end block;


  --------------------
  --  BEHAVIOR SECTION
  --------------------


--####################################################################
--#####                     Initialize                           #####
--####################################################################
  prcs_init:process
  variable TapCount_var   : integer := 0;
  variable IsTapDelay_var : boolean := true; 
  variable IsTapFixed_var : boolean := false; 
  variable IsTapDefault_var : boolean := false; 
  begin
     if((DELAY_OFFSET /= "ON") and (DELAY_OFFSET /= "on") and 
        (DELAY_OFFSET /= "OFF") and (DELAY_OFFSET /= "off")) then
           GenericValueCheckMessage
           (  HeaderMsg  => " Attribute Syntax Warning ",
              GenericName => " DELAY_OFFSET ",
              EntityName => "/X_IBUFDS_DLY_ADJ",
              GenericValue => DELAY_OFFSET,
              Unit => "",
              ExpectedValueMsg => " The Legal values for this attribute are ",
              ExpectedGenericValue => " ON or  OFF ",
              TailMsg => "",
              MsgSeverity => failure 
           );
     end if; 

     if((DELAY_OFFSET = "ON") or (DELAY_OFFSET = "on")) then  
-- CR 447604
--        INITIAL_DELAY <= SPECTRUM_OFFSET_DELAY;
        INITIAL_DELAY <= SPECTRUM_OFFSET_DELAY + (SIM_TAPDELAY_VALUE * 1 ps);
     else
--        INITIAL_DELAY <= 0 ps;
        INITIAL_DELAY <=  SIM_TAPDELAY_VALUE * 1 ps;
     end if;
     wait;
  end process prcs_init;
--####################################################################
--#####                  CALCULATE DELAY                         #####
--####################################################################
  prcs_s:process(S_ipd)
  variable TapCount_var : integer := 0;
  variable FIRST_TIME   : boolean :=true;
  variable BaseTime_var : time    := 1 ps ;
  variable delay_var    : time    := 0 ps ;
  variable S_int_var    : integer := 0;
  begin
     S_int_var := SLV_TO_INT(S_ipd);

     if((S_int_var >= MIN_TAP) and (S_int_var <= MAX_TAP)) then
         Delay        <= S_int_var * SIM_TAPDELAY_VALUE * BaseTime_var + INITIAL_DELAY;
     end if;
  end process prcs_s;

  VitalBehavior : process (I_ipd, IB_ipd)
  begin
    if ((I_ipd = '1') and (IB_ipd = '0')) then
      I_int <= TO_X01(I_ipd);
    elsif ((I_ipd = '0') and (IB_ipd = '1')) then
      I_int <= TO_X01(I_ipd);
    end if;
  end process;

--####################################################################
--#####                      DELAY INPUT                         #####
--####################################################################
  prcs_i:process(I_int)
  begin
      O_zd <= transport I_int after delay; 
  end process prcs_i;


--####################################################################
--#####                   TIMING CHECKS & OUTPUT                 #####
--####################################################################
  prcs_tmngchk:process
  variable   Tviol_CE_C_posedge      : std_ulogic := '0';
  variable   Tmkr_CE_C_posedge       : VitalTimingDataType := VitalTimingDataInit;
  variable   Violation               : std_ulogic          := '0';

  begin
--  Setup/Hold Check Violations (all input pins)


     O_viol <= Violation xor O_zd;

     wait on I_ipd, S_ipd, O_zd;

  end process prcs_tmngchk;
--####################################################################
--#####                           OUTPUT                         #####
--####################################################################
  prcs_output:process
  variable tpd_I_O_var : VitalDelayType01 := (SIM_DELAY0 * 1.0 ps, SIM_DELAY0 * 1.0 ps);
  variable tpd_IB_O_var : VitalDelayType01 := (SIM_DELAY0 * 1.0 ps, SIM_DELAY0 * 1.0 ps);
  variable  O_GlitchData : VitalGlitchDataType;
  begin
    if(DELAY_OFFSET = "OFF") then
      case S_ipd is
        when "000" => tpd_I_O_var := (SIM_DELAY1 * 1.0 ps, SIM_DELAY1 * 1.0 ps);
        when "001" => tpd_I_O_var := (SIM_DELAY2 * 1.0 ps, SIM_DELAY2 * 1.0 ps);
        when "010" => tpd_I_O_var := (SIM_DELAY3 * 1.0 ps, SIM_DELAY3 * 1.0 ps);
        when "011" => tpd_I_O_var := (SIM_DELAY4 * 1.0 ps, SIM_DELAY4 * 1.0 ps);
        when "100" => tpd_I_O_var := (SIM_DELAY5 * 1.0 ps, SIM_DELAY5 * 1.0 ps);
        when "101" => tpd_I_O_var := (SIM_DELAY6 * 1.0 ps, SIM_DELAY6 * 1.0 ps);
        when "110" => tpd_I_O_var := (SIM_DELAY7 * 1.0 ps, SIM_DELAY7 * 1.0 ps);
        when "111" => tpd_I_O_var := (SIM_DELAY8 * 1.0 ps, SIM_DELAY8 * 1.0 ps);
        when others => null;
      end case;
    elsif (DELAY_OFFSET = "ON") then
      case S_ipd is
        when "000" => tpd_I_O_var := (SIM_DELAY9  * 1.0 ps, SIM_DELAY9  * 1.0 ps);
        when "001" => tpd_I_O_var := (SIM_DELAY10 * 1.0 ps, SIM_DELAY10 * 1.0 ps);
        when "010" => tpd_I_O_var := (SIM_DELAY11 * 1.0 ps, SIM_DELAY11 * 1.0 ps);
        when "011" => tpd_I_O_var := (SIM_DELAY12 * 1.0 ps, SIM_DELAY12 * 1.0 ps);
        when "100" => tpd_I_O_var := (SIM_DELAY13 * 1.0 ps, SIM_DELAY13 * 1.0 ps);
        when "101" => tpd_I_O_var := (SIM_DELAY14 * 1.0 ps, SIM_DELAY14 * 1.0 ps);
        when "110" => tpd_I_O_var := (SIM_DELAY15 * 1.0 ps, SIM_DELAY15 * 1.0 ps);
        when "111" => tpd_I_O_var := (SIM_DELAY16 * 1.0 ps, SIM_DELAY16 * 1.0 ps);
        when others => null;
      end case;
    end if;

     VitalPathDelay01
       (
         OutSignal     => O,
         GlitchData    => O_GlitchData,
         OutSignalName => "O",
         OutTemp       => O_viol,
         Paths         => (0 => (I_ipd'last_event, tpd_I_O_var, true),
                           1 => (IB_ipd'last_event, tpd_I_O_var, true)),
         Mode          => VitalTransport,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );

     wait on O_viol;
  end process prcs_output;


end X_IBUFDS_DLY_ADJ_V;

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
-- /___/   /\     Filename : X_RAMB16BWE.vhd
-- \   \  /  \    Timestamp : Fri Mar 26 08:18:21 PST 2004
--  \___\/\___\
--
-- Revision:
--    03/23/04 - Initial version.

----- CELL X_RAMB16BWE -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library STD;
use STD.TEXTIO.all;



library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.Vcomponents.all;
use simprim.VPACKAGE.all;

entity X_RAMB16BWE is

  generic (
    TimingChecksOn : boolean := true;
    InstancePath   : string  := "*";
    Xon            : boolean := true;
    MsgOn          : boolean := true;
    LOC            : string  := "UNPLACED";


--- VITAL input wire delays

    tipd_ADDRA   : VitalDelayArrayType01(13 downto 0) := (others => (0 ps, 0 ps));
    tipd_CLKA    : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_DIA     : VitalDelayArrayType01(31 downto 0) := (others => (0 ps, 0 ps));
    tipd_DIPA    : VitalDelayArrayType01(3 downto 0)  := (others => (0 ps, 0 ps));
    tipd_ENA     : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_SSRA    : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_WEA     : VitalDelayArrayType01 (3 downto 0) := (others => (0 ps, 0 ps));

    tipd_ADDRB   : VitalDelayArrayType01(13 downto 0) := (others => (0 ps, 0 ps));
    tipd_CLKB    : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_DIB     : VitalDelayArrayType01(31 downto 0) := (others => (0 ps, 0 ps));
    tipd_DIPB    : VitalDelayArrayType01(3 downto 0)  := (others => (0 ps, 0 ps));
    tipd_ENB     : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_SSRB    : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_WEB     : VitalDelayArrayType01 (3 downto 0) := (others => (0 ps, 0 ps));

    tipd_GSR : VitalDelayType01 := ( 0 ps, 0 ps);

--- VITAL pin-to-pin propagation delays

    tpd_GSR_DOA  : VitalDelayArrayType01(31 downto 0) := (others => (0 ps, 0 ps));
    tpd_GSR_DOPA : VitalDelayArrayType01(3 downto 0)  := (others => (0 ps, 0 ps));

    tpd_GSR_DOB  : VitalDelayArrayType01(31 downto 0) := (others => (0 ps, 0 ps));
    tpd_GSR_DOPB : VitalDelayArrayType01(3 downto 0)  := (others => (0 ps, 0 ps));

    tpd_CLKA_DOA  : VitalDelayArrayType01(31 downto 0) := (others => (100 ps, 100 ps));
    tpd_CLKA_DOPA : VitalDelayArrayType01(3 downto 0)  := (others => (100 ps, 100 ps));

    tpd_CLKB_DOB  : VitalDelayArrayType01(31 downto 0) := (others => (100 ps, 100 ps));
    tpd_CLKB_DOPB : VitalDelayArrayType01(3 downto 0)  := (others => (100 ps, 100 ps));

--- VITAL recovery time 

    trecovery_GSR_CLKA_negedge_posedge : VitalDelayType                   := 0 ps;
    trecovery_GSR_CLKB_negedge_posedge : VitalDelayType                   := 0 ps;

--- VITAL setup time 

    tsetup_ADDRA_CLKA_negedge_posedge  : VitalDelayArrayType(13 downto 0) := (others => 0 ps);
    tsetup_ADDRA_CLKA_posedge_posedge  : VitalDelayArrayType(13 downto 0) := (others => 0 ps);
    tsetup_DIA_CLKA_negedge_posedge    : VitalDelayArrayType(31 downto 0) := (others => 0 ps);
    tsetup_DIA_CLKA_posedge_posedge    : VitalDelayArrayType(31 downto 0) := (others => 0 ps);
    tsetup_DIPA_CLKA_negedge_posedge   : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    tsetup_DIPA_CLKA_posedge_posedge   : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    tsetup_ENA_CLKA_negedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_ENA_CLKA_posedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_SSRA_CLKA_negedge_posedge   : VitalDelayType                   := 0 ps;
    tsetup_SSRA_CLKA_posedge_posedge   : VitalDelayType                   := 0 ps;
    tsetup_WEA_CLKA_negedge_posedge    : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    tsetup_WEA_CLKA_posedge_posedge    : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);

    tsetup_ADDRB_CLKB_negedge_posedge  : VitalDelayArrayType(13 downto 0) := (others => 0 ps);
    tsetup_ADDRB_CLKB_posedge_posedge  : VitalDelayArrayType(13 downto 0) := (others => 0 ps);
    tsetup_DIB_CLKB_negedge_posedge    : VitalDelayArrayType(31 downto 0) := (others => 0 ps);
    tsetup_DIB_CLKB_posedge_posedge    : VitalDelayArrayType(31 downto 0) := (others => 0 ps);
    tsetup_DIPB_CLKB_negedge_posedge   : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    tsetup_DIPB_CLKB_posedge_posedge   : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    tsetup_ENB_CLKB_negedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_ENB_CLKB_posedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_SSRB_CLKB_negedge_posedge   : VitalDelayType                   := 0 ps;
    tsetup_SSRB_CLKB_posedge_posedge   : VitalDelayType                   := 0 ps;
    tsetup_WEB_CLKB_negedge_posedge    : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    tsetup_WEB_CLKB_posedge_posedge    : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);

--- VITAL hold time 

    thold_ADDRA_CLKA_negedge_posedge  : VitalDelayArrayType(13 downto 0) := (others => 0 ps);
    thold_ADDRA_CLKA_posedge_posedge  : VitalDelayArrayType(13 downto 0) := (others => 0 ps);
    thold_DIA_CLKA_negedge_posedge    : VitalDelayArrayType(31 downto 0) := (others => 0 ps);
    thold_DIA_CLKA_posedge_posedge    : VitalDelayArrayType(31 downto 0) := (others => 0 ps);
    thold_DIPA_CLKA_negedge_posedge   : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    thold_DIPA_CLKA_posedge_posedge   : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    thold_ENA_CLKA_negedge_posedge    : VitalDelayType                   := 0 ps;
    thold_ENA_CLKA_posedge_posedge    : VitalDelayType                   := 0 ps;
    thold_GSR_CLKA_negedge_posedge    : VitalDelayType                   := 0 ps;
    thold_SSRA_CLKA_negedge_posedge   : VitalDelayType                   := 0 ps;
    thold_SSRA_CLKA_posedge_posedge   : VitalDelayType                   := 0 ps;
    thold_WEA_CLKA_negedge_posedge    : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    thold_WEA_CLKA_posedge_posedge    : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);

    thold_ADDRB_CLKB_negedge_posedge  : VitalDelayArrayType(13 downto 0) := (others => 0 ps);
    thold_ADDRB_CLKB_posedge_posedge  : VitalDelayArrayType(13 downto 0) := (others => 0 ps);
    thold_DIB_CLKB_negedge_posedge    : VitalDelayArrayType(31 downto 0) := (others => 0 ps);
    thold_DIB_CLKB_posedge_posedge    : VitalDelayArrayType(31 downto 0) := (others => 0 ps);
    thold_DIPB_CLKB_negedge_posedge   : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    thold_DIPB_CLKB_posedge_posedge   : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    thold_ENB_CLKB_negedge_posedge    : VitalDelayType                   := 0 ps;
    thold_ENB_CLKB_posedge_posedge    : VitalDelayType                   := 0 ps;
    thold_GSR_CLKB_negedge_posedge    : VitalDelayType                   := 0 ps;
    thold_SSRB_CLKB_negedge_posedge   : VitalDelayType                   := 0 ps;
    thold_SSRB_CLKB_posedge_posedge   : VitalDelayType                   := 0 ps;
    thold_WEB_CLKB_negedge_posedge    : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    thold_WEB_CLKB_posedge_posedge    : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);

    tbpd_GSR_DOA_CLKA  : VitalDelayArrayType01(31 downto 0) := (others => (0 ps, 0 ps));
    tbpd_GSR_DOPA_CLKA : VitalDelayArrayType01(3 downto 0)  := (others => (0 ps, 0 ps));

    ticd_CLKA          : VitalDelayType                     := 0 ps;
    tisd_ADDRA_CLKA    : VitalDelayArrayType(13 downto 0)   := (others => 0 ps);
    tisd_DIA_CLKA      : VitalDelayArrayType(31 downto 0)   := (others => 0 ps);
    tisd_DIPA_CLKA     : VitalDelayArrayType(3 downto 0)    := (others => 0 ps);
    tisd_ENA_CLKA      : VitalDelayType                     := 0 ps;
    tisd_GSR_CLKA      : VitalDelayType                     := 0 ps;
    tisd_SSRA_CLKA     : VitalDelayType                     := 0 ps;
    tisd_WEA_CLKA      : VitalDelayArrayType(3 downto 0)    := (others => 0 ps);

    tbpd_GSR_DOB_CLKB  : VitalDelayArrayType01(31 downto 0) := (others => (0 ps, 0 ps));
    tbpd_GSR_DOPB_CLKB : VitalDelayArrayType01(3 downto 0)  := (others => (0 ps, 0 ps));

    ticd_CLKB          : VitalDelayType                     := 0 ps;
    tisd_ADDRB_CLKB    : VitalDelayArrayType(13 downto 0)   := (others => 0 ps);
    tisd_DIB_CLKB      : VitalDelayArrayType(31 downto 0)   := (others => 0 ps);
    tisd_DIPB_CLKB     : VitalDelayArrayType(3 downto 0)    := (others => 0 ps);
    tisd_ENB_CLKB      : VitalDelayType                     := 0 ps;
    tisd_GSR_CLKB      : VitalDelayType                     := 0 ps;
    tisd_SSRB_CLKB     : VitalDelayType                     := 0 ps;
    tisd_WEB_CLKB      : VitalDelayArrayType(3 downto 0)    := (others => 0 ps);

    tperiod_clka_posedge : VitalDelayType := 0 ps;
    tperiod_clkb_posedge : VitalDelayType := 0 ps;

    tpw_CLKA_negedge : VitalDelayType := 0 ps;
    tpw_CLKA_posedge : VitalDelayType := 0 ps;
    tpw_CLKB_negedge : VitalDelayType := 0 ps;
    tpw_CLKB_posedge : VitalDelayType := 0 ps;
    tpw_GSR_posedge  : VitalDelayType := 0 ps;

    DATA_WIDTH_A : integer := 0;
    DATA_WIDTH_B : integer := 0;

    INIT_00 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_01 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_02 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_03 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_04 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_05 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_06 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_07 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_08 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_09 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0A : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0B : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0C : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0D : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0E : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0F : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_10 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_11 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_12 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_13 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_14 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_15 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_16 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_17 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_18 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_19 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1A : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1B : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1C : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1D : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1E : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1F : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_20 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_21 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_22 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_23 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_24 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_25 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_26 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_27 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_28 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_29 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2A : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2B : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2C : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2D : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2E : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2F : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_30 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_31 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_32 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_33 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_34 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_35 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_36 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_37 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_38 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_39 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3A : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3B : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3C : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3D : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3E : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3F : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";

    INIT_A : bit_vector := X"000000000";
    INIT_B : bit_vector := X"000000000";

    INITP_00 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_01 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_02 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_03 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_04 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_05 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_06 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_07 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";


    SETUP_ALL : VitalDelayType := 1000 ps;
    SETUP_READ_FIRST : VitalDelayType := 3000 ps;

    SIM_COLLISION_CHECK : string := "ALL";

    SRVAL_A : bit_vector := X"000000000";
    SRVAL_B : bit_vector := X"000000000";

    WRITE_MODE_A : string := "WRITE_FIRST";
    WRITE_MODE_B : string := "WRITE_FIRST"

    );

  port(
    DOA          : out std_logic_vector (31 downto 0);
    DOB          : out std_logic_vector (31 downto 0);
    DOPA         : out std_logic_vector (3 downto 0);
    DOPB         : out std_logic_vector (3 downto 0);

    ADDRA        : in  std_logic_vector (13 downto 0);
    ADDRB        : in  std_logic_vector (13 downto 0);
    CLKA         : in  std_ulogic;
    CLKB         : in  std_ulogic;
    DIA          : in  std_logic_vector (31 downto 0);
    DIB          : in  std_logic_vector (31 downto 0);
    DIPA         : in  std_logic_vector (3 downto 0);
    DIPB         : in  std_logic_vector (3 downto 0);
    ENA          : in  std_ulogic;
    ENB          : in  std_ulogic;
    SSRA         : in  std_ulogic;
    SSRB         : in  std_ulogic;
    WEA          : in  std_logic_vector (3 downto 0);
    WEB          : in  std_logic_vector (3 downto 0)
    );

  attribute VITAL_LEVEL0 of
    X_RAMB16BWE : entity is true;

end X_RAMB16BWE;

architecture X_RAMB16BWE_V of X_RAMB16BWE is

  attribute VITAL_LEVEL0 of
    X_RAMB16BWE_V : architecture is true;


-- Constants

  constant MAX_ADDR: integer := 13;

  constant MAX_DI:   integer := 31;
  constant MAX_DIP:  integer := 3;
  constant MAX_WE:   integer := 3;

  constant SYNC_PATH_DELAY : time  := 100 ps;

  TYPE CollisionFlagType IS RECORD
     active_port : integer; 
     read_write  : boolean; 
     write_read  : boolean; 
     write_write : boolean; 
     we          : std_logic_vector(MAX_WE downto 0);
  END RECORD;

  TYPE DataWidthType IS RECORD
     diaw  : integer; 
     dipaw : integer; 
     doaw  : integer; 
     dopaw : integer; 
     dibw  : integer; 
     dipbw : integer; 
     dobw  : integer; 
     dopbw : integer; 
  END RECORD;

  TYPE ClsnXbufType IS RECORD
     DO1_clsn   : std_logic_vector(31 downto 0);
     DOP1_clsn  : std_logic_vector(3 downto 0);
     MEM1_clsn  : std_logic_vector(31 downto 0);
     MEMP1_clsn : std_logic_vector(3 downto 0);

     DO2_clsn   : std_logic_vector(31 downto 0);
     DOP2_clsn  : std_logic_vector(3 downto 0);
     MEM2_clsn  : std_logic_vector(31 downto 0);
     MEMP2_clsn : std_logic_vector(3 downto 0);
  END RECORD;

  TYPE memory_collision_type is (Read_A_Write_B,
                                 Write_A_Read_B,
                                 Write_A_Write_B,
                                 Read_B_Write_A,
                                 Write_B_Read_A,
                                 Write_B_Write_A);

-- Procedures and Functions

------------------------------------------------
-- procedure ClkCollisionCheck
------------------------------------------------
--
--  Checks whether the time duration of rising
--  clka and clkb violates required setup time
--  between these clocks.
--
   procedure ClkCollisionCheck(
             variable violation        : out integer;
             constant CheckEnabled     : in boolean := false;
             variable CLK1_time        : in time := 0 ns;
             variable CLK2_time        : in time := 0 ns;
             constant SETUP_ALL        : in time := 0 ns;
             constant SETUP_READ_FIRST : in time := 0 ns
   ) is

   begin

     violation := 0;
     if(CheckEnabled) then
        if((CLK1_time > 0 ns ) and (CLK2_time > 0 ns )) then
           if((CLK1_time - CLK2_time) = 0 ns ) then
              violation := 3;
           elsif ((CLK1_time - CLK2_time) < SETUP_ALL) then
              violation := 11;
           elsif ((CLK1_time - CLK2_time) < SETUP_READ_FIRST) then
              violation := 12;
           end if;
        end if;
     end if;
   end ClkCollisionCheck;

------------------------------------------------
-- function AddrOverlapCheck
------------------------------------------------
--

   function AddrOverlapCheck(
                   d1w         : in integer := 0;
                   d2w         : in integer := 0;
                   addr1       : in  std_logic_vector(MAX_ADDR downto 0)   := (others => 'X');
                   addr2       : in  std_logic_vector(MAX_ADDR downto 0)   := (others => 'X');
                   zero_addr1  : in  std_logic_vector(MAX_ADDR downto 0)   := (others => 'X');
                   zero_addr2  : in  std_logic_vector(MAX_ADDR downto 0)   := (others => 'X');
                   we_segment  : in integer := 0
   ) return boolean is 
   variable collision, port1_overlap, port2_overlap : boolean := false;
   variable addr1_zero_int, addr2_zero_int, wea_index, INDEX1, INDEX2 : integer := -1;
   variable tmp_addr1_zero, tmp_addr2_zero : std_logic_vector(MAX_ADDR downto 0) := (others => 'X');
   variable zero_out                       : std_logic_vector(MAX_ADDR downto 0)   := (others => 'X');
   variable tmp_we                         : std_logic_vector(1 downto 0)          := (others => '0');


   
   
   begin
     INDEX1 := SLV_TO_INT(addr1(4 downto 0));
     INDEX2 := SLV_TO_INT(addr2(4 downto 0));

     if(D1W >= D2W) then  
        zero_out := zero_addr1;
     elsif(D1W < D2W) then
        zero_out := zero_addr2;
     end if;

     tmp_addr1_zero := (addr1(MAX_ADDR downto 0) and zero_out);
     tmp_addr2_zero := (addr2(MAX_ADDR downto 0) and zero_out);

     addr1_zero_int := SLV_TO_INT(tmp_addr1_zero); 
     addr2_zero_int := SLV_TO_INT(tmp_addr2_zero); 
   
--     if((addr1_zero_int = addr2_zero_int) and ((INDEX1 + D1W) > we_segment * 8 ) and ((INDEX2 + D2W) > we_segment * 8 )) then
     if(addr1_zero_int = addr2_zero_int) then

        case D1W is
           ---------
           when 1|2|4|8 =>
           ---------
              tmp_we(1 downto 0) := addr1( 4 downto 3);
              wea_index := SLV_TO_INT(tmp_we);
              if(wea_index = we_segment) then
                port1_overlap := true;
              end if;

           ---------
           when 16 =>
           ---------

              tmp_we(1) := addr1(4);
              tmp_we(0) := '0';
              wea_index := SLV_TO_INT(tmp_we);
              if(wea_index = we_segment) then
                port1_overlap := true;
              end if;
   
              tmp_we(1) := addr1(4);
              tmp_we(0) := '1';
              wea_index := SLV_TO_INT(tmp_we);
              if(wea_index = we_segment) then
                port1_overlap := true;
              end if;
            
           ---------
           when 32 =>
           ---------

                port1_overlap := true;

           ---------
           when others => null;
           ---------
        end case;



        case D2W is
           ---------
           when 1|2|4|8 =>
           ---------
              tmp_we(1 downto 0) := addr2( 4 downto 3);
              wea_index := SLV_TO_INT(tmp_we);
              if(wea_index = we_segment) then
                port2_overlap := true;
              end if;

           ---------
           when 16 =>
           ---------

              tmp_we(1) := addr2(4);
              tmp_we(0) := '0';
              wea_index := SLV_TO_INT(tmp_we);
              if(wea_index = we_segment) then
                port2_overlap := true;
              end if;
   
              tmp_we(1) := addr2(4);
              tmp_we(0) := '1';
              wea_index := SLV_TO_INT(tmp_we);
              if(wea_index = we_segment) then
                port2_overlap := true;
              end if;
            
           ---------
           when 32 =>
           ---------

                port2_overlap := true;

           ---------
           when others => null;
           ---------
        end case;

     end if;

     collision :=  (port1_overlap and port2_overlap);
     return collision;
   end;
------------------------------------------------
-- procedure QkAddrOverlapChk
------------------------------------------------
--

   procedure QkAddrOverlapChk(
                   variable addr_overlap : out boolean;
                   variable data_widths  : in DataWidthType;
                   variable addra        : in  std_logic_vector(MAX_ADDR downto 0) := (others => 'X');
                   variable addrb        : in  std_logic_vector(MAX_ADDR downto 0) := (others => 'X')
   ) is
   variable addra_int, addrb_int, max_width : integer := -1;
   variable tmp_addra_zero, tmp_addrb_zero  : std_logic_vector(MAX_ADDR downto 0) := (others => 'X');
   variable zero_data_out                   : std_logic_vector(MAX_ADDR downto 0) := (others => 'X');
   variable zero_parity_out                 : std_logic_vector((MAX_ADDR-3) downto 0) := (others => 'X');
 
   begin
     addr_overlap := false;
     zero_data_out   := (others => '1');
     zero_parity_out := (others => '1');

     max_width := data_widths.diaw;

     if(data_widths.doaw > max_width) then
        max_width := data_widths.doaw;
     end if;
   
     if(data_widths.dibw > max_width) then
        max_width := data_widths.dibw;
     end if;

     if(data_widths.dobw > max_width) then
        max_width := data_widths.dobw;
     end if;

    
     case max_width is

        -------
        when 32 =>
        -------
            zero_data_out(4 downto 0) := (others => '0'); 
            zero_parity_out(1 downto 0) := (others => '0'); 

        -------
        when 16 =>
        -------
            zero_data_out(3 downto 0) := (others => '0'); 
            zero_parity_out(0 downto 0) := (others => '0'); 

        -------
        when 8 =>
        -------
            zero_data_out(2 downto 0) := (others => '0'); 

        -------
        when 4 =>
        -------
            zero_data_out(1 downto 0) := (others => '0'); 

        -------
        when 2 =>
        -------
            zero_data_out(0 downto 0) := (others => '0'); 

        -------
        when others =>
        -------
           null;


     end case;

     tmp_addra_zero := (addra(MAX_ADDR downto 0) and zero_data_out);
     tmp_addrb_zero := (addrb(MAX_ADDR downto 0) and zero_data_out);

     addra_int := SLV_TO_INT(tmp_addra_zero); 
     addrb_int := SLV_TO_INT(tmp_addrb_zero); 
   
     if(addra_int = addrb_int) then
          addr_overlap := true;
     end if;

   end QkAddrOverlapChk;

------------------------------------------------
-- procedure SameDataChk 
------------------------------------------------
--
--  Checks whether the data written is the same
--  as in the memory, or in the case of both ports
--  writing whether the inputs are the same.
--  If true, then there is no collision
--
   procedure SameDataChk(
             variable same_data  : out boolean;
             variable same_datap : out boolean;
             constant MEM        : in std_logic_vector(18431 downto 0); 
             constant di1        : in std_logic_vector(31 downto 0);
             constant di2        : in std_logic_vector(31 downto 0);
             constant dip1       : in std_logic_vector(3 downto 0);
             constant dip2       : in std_logic_vector(3 downto 0);
             variable addr1      : in std_logic_vector(13 downto 0) := (others => 'X');
             variable addr2      : in std_logic_vector(13 downto 0) := (others => 'X');
             variable addrp1     : in std_logic_vector(10 downto 0) := (others => 'X');
             variable addrp2     : in std_logic_vector(10 downto 0) := (others => 'X');
             variable wr_mode_1  : in std_logic_vector(1 downto 0) := "00";
             variable wr_mode_2  : in std_logic_vector(1 downto 0) := "00";
             constant we_segment : in integer := -1;
             variable we1        : in std_ulogic := 'X';
             variable we2        : in std_ulogic := 'X';
             variable D1W       : in integer := -1;
             variable D1PW      : in integer := -1;
             variable D2W       : in integer := -1;
             variable D2PW      : in integer := -1
   ) is
   variable REM1 : integer := -1;
   variable REM2 : integer := -1;
   variable XOUT_BITS : integer := -1;
   variable XOUT_BITS_1 : integer := -1;
   variable XOUT_PBITS_1 : integer := 0;
   variable INDEX, INDEXP, DATA_INDEX : integer := -1;
   variable ADDRESS, ADDRESS_P, ADDRESS32_1, ADDRESS32P_1, ADDRESS32_2, ADDRESS32P_2 : integer := -1;
   variable SMALL_ADDRESS32, SMALL_ADDRESS32P : integer := -1;
   variable SMALL_DW : integer := -1;

  
   variable TableRow : std_logic_vector(1 downto 0) := (others => '0');

   variable cmp_d1_buf   : std_logic_vector(7 downto 0) := (others => '0');
   variable cmp_d1p_buf  : std_logic_vector(0 downto 0) := (others => '0');
   variable cmp_d2_buf   : std_logic_vector(7 downto 0) := (others => '0');
   variable cmp_d2p_buf  : std_logic_vector(0 downto 0) := (others => '0');
   variable cmp_mem_buf  : std_logic_vector(7 downto 0) := (others => '0');
   variable cmp_memp_buf : std_logic_vector(0 downto 0) := (others => '0');

   variable cmp_d1_buf32 : std_logic_vector(31 downto 0) := (others => '0');
   variable cmp_d1p_buf4 : std_logic_vector(3 downto 0)  := (others => '0');
   variable cmp_d2_buf32 : std_logic_vector(31 downto 0) := (others => '0');
   variable cmp_d2p_buf4 : std_logic_vector(3 downto 0)  := (others => '0');

   variable tmp_cmp_d1_buf  : std_logic_vector(7 downto 0) := (others => '0');
   variable tmp_cmp_d1p_buf : std_logic_vector(0 downto 0) := (others => '0');
   variable tmp_cmp_d2_buf  : std_logic_vector(7 downto 0) := (others => '0');
   variable tmp_cmp_d2p_buf : std_logic_vector(0 downto 0) := (others => '0');

   variable memp_fp      :  std_logic_vector(3 downto 0)  := (others => '0');

   begin

-- ##################################################################
-----------------------------------------------------------------------
------------ Port 1  Active Clock -------------------------------------
-----------------------------------------------------------------------

      same_data  := false;
      same_datap := false;

      if((D1W >= D2W) and (D2W < 8)) then
         INDEX := SLV_TO_INT(addr2(4 downto 0));
      elsif((D2W >= D1W) and (D1W < 8)) then
         INDEX := SLV_TO_INT(addr1(4 downto 0));
      else
         INDEX := we_segment * 8;
      end if;


      ---  Data Bits ---

      REM1 := D1W REM 8;
      REM2 := D2W REM 8;

      -- find the minimum data bits to overlap
      if((REM1 = 0) and (REM2 = 0)) then
          XOUT_BITS := 8 ;
      elsif(REM1 = 0) then
          XOUT_BITS := REM2;
      elsif(REM2 = 0) then
          XOUT_BITS := REM1;
      elsif(REM1 > REM2) then
          XOUT_BITS := REM2 ;
      elsif (REM1 <= REM2) then
          XOUT_BITS := REM1 ;
      end if;

      XOUT_BITS_1 := XOUT_BITS - 1 ;


      if(D1W <= D2W) then
         SMALL_DW := D1W;
         ADDRESS  := SLV_TO_INT(addr1);
         SMALL_ADDRESS32:= SLV_TO_INT(addr1(4 downto 0));
      elsif(D1W > D2W) then
         SMALL_DW := D2W;
         ADDRESS  := SLV_TO_INT(addr2);
         SMALL_ADDRESS32:= SLV_TO_INT(addr2(4 downto 0));
      end if;

      if(D1PW <= D2PW) then
         ADDRESS_P := SLV_TO_INT(addrp1);
         SMALL_ADDRESS32P:= SLV_TO_INT(addrp1(1 downto 0));
      elsif(D1PW > D2PW) then
         ADDRESS_P := SLV_TO_INT(addrp2);
         SMALL_ADDRESS32P:= SLV_TO_INT(addrp2(1 downto 0));
      end if;
  
      INDEXP  := we_segment;
 
      TableRow := (we1 & we2);

      cmp_d1_buf   := (others => '0'); 
      cmp_d1p_buf  := (others => '0'); 
      cmp_d2_buf   := (others => '0'); 
      cmp_d2p_buf  := (others => '0'); 
      cmp_mem_buf  := (others => '0'); 
      cmp_memp_buf := (others => '0'); 

--==================================================================================================
      ADDRESS32_1  := SLV_TO_INT(addr1(4 downto 0));
      ADDRESS32P_1 := SLV_TO_INT(addrp1(1 downto 0));
      cmp_d1_buf32(((D1W - 1) + ADDRESS32_1) downto ADDRESS32_1)   :=  di1((D1W - 1) downto 0);
      cmp_d1p_buf4(((D1PW - 1) + ADDRESS32P_1) downto ADDRESS32P_1) :=  dip1((D1PW - 1) downto 0);

      ADDRESS32_2  := SLV_TO_INT(addr2(4 downto 0));
      ADDRESS32P_2 := SLV_TO_INT(addrp2(1 downto 0));
      cmp_d2_buf32(((D2W - 1) + ADDRESS32_2) downto ADDRESS32_2)    :=  di2((D2W - 1) downto 0);
      cmp_d2p_buf4(((D2PW - 1) + ADDRESS32P_2) downto ADDRESS32P_2) :=  dip2((D2PW - 1 ) downto 0);

      case SMALL_DW is
         when 1|2|4 =>
            cmp_mem_buf(XOUT_BITS_1 downto 0)      := MEM((XOUT_BITS_1 + ADDRESS ) downto (ADDRESS)); 
               
            tmp_cmp_d1_buf(XOUT_BITS_1 downto 0)   :=  cmp_d1_buf32((XOUT_BITS_1 + SMALL_ADDRESS32 ) downto SMALL_ADDRESS32);
            tmp_cmp_d2_buf(XOUT_BITS_1 downto 0)   :=  cmp_d2_buf32((XOUT_BITS_1 + SMALL_ADDRESS32 ) downto SMALL_ADDRESS32);

         when 8 =>
            cmp_mem_buf(XOUT_BITS_1 downto 0)      := MEM((XOUT_BITS_1 + ADDRESS ) downto (ADDRESS)); 
            cmp_memp_buf(XOUT_PBITS_1 downto 0)    := MEM((XOUT_PBITS_1 + 16384 + ADDRESS_P) downto (ADDRESS_P + 16384)); 

            tmp_cmp_d1_buf(XOUT_BITS_1 downto 0)   := cmp_d1_buf32((XOUT_BITS_1 + SMALL_ADDRESS32 ) downto SMALL_ADDRESS32);
            tmp_cmp_d1p_buf(XOUT_PBITS_1 downto 0) := cmp_d1p_buf4((XOUT_PBITS_1 + SMALL_ADDRESS32P) downto SMALL_ADDRESS32P);  

            tmp_cmp_d2_buf(XOUT_BITS_1 downto 0)   := cmp_d2_buf32((XOUT_BITS_1 + SMALL_ADDRESS32 ) downto SMALL_ADDRESS32);
            tmp_cmp_d2p_buf(XOUT_PBITS_1 downto 0) := cmp_d2p_buf4((XOUT_PBITS_1 + SMALL_ADDRESS32P) downto SMALL_ADDRESS32P);  

         when 16 =>
            if((we_segment = 0) or (we_segment = 2)) then
                DATA_INDEX := 0;
            elsif((we_segment = 1) or (we_segment = 3))then
                DATA_INDEX := 1;
            end if;

            cmp_mem_buf(XOUT_BITS_1 downto 0)   := MEM((XOUT_BITS_1 + ADDRESS + DATA_INDEX*8 ) downto (DATA_INDEX*8 + ADDRESS)); 
            cmp_memp_buf(XOUT_PBITS_1 downto 0) := MEM((XOUT_PBITS_1 + 16384 + DATA_INDEX + ADDRESS_P) downto (DATA_INDEX + ADDRESS_P + 16384)); 
            tmp_cmp_d1_buf(XOUT_BITS_1 downto 0)   := cmp_d1_buf32((XOUT_BITS_1 + we_segment*8 ) downto we_segment*8);
            tmp_cmp_d1p_buf(XOUT_PBITS_1 downto 0) := cmp_d1p_buf4((XOUT_PBITS_1 + we_segment*1) downto we_segment*1);  

            tmp_cmp_d2_buf(XOUT_BITS_1 downto 0)   := cmp_d2_buf32((XOUT_BITS_1 + we_segment*8 ) downto we_segment*8);
            tmp_cmp_d2p_buf(XOUT_PBITS_1 downto 0) := cmp_d2p_buf4((XOUT_PBITS_1 + we_segment*1) downto we_segment*1);  

         when 32 =>
            cmp_mem_buf(XOUT_BITS_1 downto 0)   := MEM((XOUT_BITS_1 + INDEX + ADDRESS ) downto (INDEX + ADDRESS)); 
            cmp_memp_buf(XOUT_PBITS_1 downto 0) := MEM((XOUT_PBITS_1 + 16384 + INDEXP + ADDRESS_P) downto (INDEXP + ADDRESS_P + 16384)); 

            tmp_cmp_d1_buf(XOUT_BITS_1 downto 0)   := cmp_d1_buf32((XOUT_BITS_1 + we_segment*8 ) downto we_segment*8);
            tmp_cmp_d1p_buf(XOUT_PBITS_1 downto 0) := cmp_d1p_buf4((XOUT_PBITS_1 + we_segment*1) downto we_segment*1);  

            tmp_cmp_d2_buf(XOUT_BITS_1 downto 0)   := cmp_d2_buf32((XOUT_BITS_1 + we_segment*8 ) downto we_segment*8);
            tmp_cmp_d2p_buf(XOUT_PBITS_1 downto 0) := cmp_d2p_buf4((XOUT_PBITS_1 + we_segment*1) downto we_segment*1);  

         when  others => null; 

      end case;

      case TableRow is
---===============================================================================
---                           wea&web = 11
---===============================================================================
          ----
          when "11" =>
          ----
              
               memp_fp := MEM(( 3 + 16384 + ADDRESS_P) downto (16384 + ADDRESS_P)); 


               if((tmp_cmp_d1_buf = tmp_cmp_d2_buf) and (tmp_cmp_d2_buf = cmp_mem_buf)) then
                   same_data := true;
               end if;

           -- Parity
               if((D1PW /= 0) and (D2PW /= 0)) then
                  if((tmp_cmp_d1p_buf = tmp_cmp_d2p_buf) and (tmp_cmp_d2p_buf = cmp_memp_buf)) then
                      same_datap := true;
                  end if;
               end if;
---===============================================================================
---                           wea&web = 01
---===============================================================================
          ----
          when "01" =>
          ----

               if(tmp_cmp_d2_buf = cmp_mem_buf) then
                   same_data := true;
               end if;

               -- Parity
               if((D1PW /= 0) and (D2PW /= 0)) then
                  if(tmp_cmp_d2p_buf = cmp_memp_buf) then
                      same_datap := true;
                  end if;
               end if;
---===============================================================================
---                           wea&web = 10
---===============================================================================
          ----
          when "10" =>
          ----
               if(tmp_cmp_d1_buf = cmp_mem_buf) then
                   same_data := true;
               end if;

               -- Parity
               if((D1PW /= 0) and (D2PW /= 0)) then
                  if(tmp_cmp_d1p_buf = cmp_memp_buf) then
                      same_datap := true;
                  end if;
               end if;
---===============================================================================
---                           others 
---===============================================================================

          ---------
          when others =>
          ---------
                null;
      end case;

   end SameDataChk;

------------------------------------------------
-- procedure CollisionTableRest
------------------------------------------------
--
--  Checks whether the time duration of rising
--  clka and clkb violates required setup time
--  between these clocks.
--
   procedure CollisionTableRest(
             variable clsn_bufs      : out ClsnXbufType;
             variable same_data_flg  : out boolean;
             variable same_datap_flg : out boolean;
             constant MEM            : in std_logic_vector(18431 downto 0);
             constant di1            : in std_logic_vector(31 downto 0);
             constant di2            : in std_logic_vector(31 downto 0);
             constant dip1           : in std_logic_vector(3 downto 0);
             constant dip2           : in std_logic_vector(3 downto 0);
             variable addr1          : in std_logic_vector(13 downto 0) := (others => 'X');
             variable addr2          : in std_logic_vector(13 downto 0) := (others => 'X');
             variable addrp1         : in std_logic_vector(10 downto 0) := (others => 'X');
             variable addrp2         : in std_logic_vector(10 downto 0) := (others => 'X');
             variable wr_mode_1      : in std_logic_vector(1 downto 0) := "00";
             variable wr_mode_2      : in std_logic_vector(1 downto 0) := "00";
             constant we_segment     : in integer := -1;
             constant violation      : in integer := -1;
             variable we1            : in std_ulogic := 'X';
             variable we2            : in std_ulogic := 'X';
             variable D1W            : in integer := -1;
             variable D1PW           : in integer := -1;
             variable D2W            : in integer := -1;
             variable D2PW           : in integer := -1
   ) is
   variable REM1 : integer := -1;
   variable REM2 : integer := -1;
   variable XOUT_BITS : integer := -1;
   variable XOUT_BITS_1 : integer := -1;
   variable INDEX, INDEX_P : integer := -1;
  
   variable TableRow :  std_logic_vector(5 downto 0) := (others => '0');
   variable we1we2   :  std_logic_vector(1 downto 0) := (others => '0');

   variable same_data                : boolean    := false;
   variable same_datap               : boolean    := false;
   variable SAME_DATA_CHECK_DISABLED : boolean    := true;

   begin

-- ##################################################################
-----------------------------------------------------------------------
------------ Port 1  Active Clock -------------------------------------
-----------------------------------------------------------------------


   if((D1W >= D2W) and (D2W < 8)) then
      INDEX := SLV_TO_INT(addr2(4 downto 0));
   elsif((D2W >= D1W) and (D1W < 8)) then
      INDEX := SLV_TO_INT(addr1(4 downto 0));
   else
      INDEX := we_segment * 8;
   end if;


   ---  Data Bits ---

   REM1 := D1W REM 8;
   REM2 := D2W REM 8;

   -- find the minimum data bits to overlap
   if((REM1 = 0) and (REM2 = 0)) then
       XOUT_BITS := 8 ;
   elsif(REM1 = 0) then
       XOUT_BITS := REM2;
   elsif(REM2 = 0) then
       XOUT_BITS := REM1;
   elsif(REM1 > REM2) then
       XOUT_BITS := REM2 ;
   elsif (REM1 <= REM2) then
       XOUT_BITS := REM1 ;
   end if;

   XOUT_BITS_1 := XOUT_BITS - 1 ;



   ---  Parity Bits ---

   -- find the minimum parity bits to overlap

   if(D1PW >= D2PW) then
      INDEX_P := SLV_TO_INT(addrp2(1 downto 0));
   else
      INDEX_P := SLV_TO_INT(addrp1(1 downto 0));
   end if;
--===============================================================================
--   Same Data Check for both Data and Parity 
--   If Data/Parity_Data are the same in Ports A and B, and the contents of the 
--   Memory/Parity_memory are the same as the Data, then here is no collision
--===============================================================================


   SameDataChk(
      same_data  => same_data,
      same_datap => same_datap,
      mem        => mem,
      di1        => di1,
      di2        => di2,
      dip1       => dip1,
      dip2       => dip2,
      addr1      => addr1,
      addr2      => addr2,
      addrp1     => addrp1,
      addrp2     => addrp2,
      wr_mode_1  => wr_mode_1,
      wr_mode_2  => wr_mode_2,
      we_segment => we_segment,
      we1        => we1,
      we2        => we2,
      D1W        => D1W,
      D1PW       => D1PW,
      D2W        => D2W,
      D2PW       => D2PW
    );

---===============================================================================
---===============================================================================
-- DEBUG                    
if(SAME_DATA_CHECK_DISABLED) then
  same_data  := false;
  same_datap := false;
end if;

  same_data_flg  := same_data;
  same_datap_flg := same_datap;
 
   TableRow := (wr_mode_1 & wr_mode_2 & we1 & we2);
   case TableRow is
---===============================================================================
---                           wea&web = 11
---===============================================================================
          ----
          when "000011" | "010011"  =>
          ----
            if((violation = 3) or (violation = 11)) then
                if(not same_data) then
                   -- port 1
                   clsn_bufs.DO1_clsn((INDEX + XOUT_BITS_1 ) downto INDEX) := (others => 'X');
                   clsn_bufs.MEM1_clsn((INDEX + XOUT_BITS_1) downto INDEX ) := (others => 'X');
                   -- port 2
                   clsn_bufs.DO2_clsn((INDEX + XOUT_BITS_1 ) downto INDEX) := (others => 'X');
                   clsn_bufs.MEM2_clsn((INDEX + XOUT_BITS_1) downto INDEX ) := (others => 'X');
                end if;
                if(not same_datap) then
                   -- parity port 1
                   if((D1PW /= 0) and (D2PW /= 0)) then
--                       clsn_bufs.DOP1_clsn((INDEX_P + (we_segment * 1))  downto (INDEX_P + (we_segment * 1))) := (others => 'X');
                       clsn_bufs.DOP1_clsn((we_segment * 1)  downto (we_segment * 1)) := (others => 'X');
                       clsn_bufs.MEMP1_clsn((we_segment * 1) downto (we_segment * 1)) := (others => 'X');
                   end if;
                   -- parity port 2
                   if((D1PW /= 0) and (D2PW /= 0)) then
--                       clsn_bufs.DOP2_clsn((INDEX_P + (we_segment * 1))  downto (INDEX_P + (we_segment * 1))) := (others => 'X');
                       clsn_bufs.DOP2_clsn((we_segment * 1)  downto (we_segment * 1)) := (others => 'X');
                       clsn_bufs.MEMP2_clsn((we_segment * 1) downto (we_segment * 1)) := (others => 'X');
                   end if;
                end if;

            end if;

          ----
          when "001011" | "011011" =>
          ----
            if((violation = 3) or (violation = 11)) then
                if(not same_data) then
                   -- port 1
                   clsn_bufs.DO1_clsn((INDEX + XOUT_BITS_1 ) downto INDEX) := (others => 'X');
                   clsn_bufs.MEM1_clsn((INDEX + XOUT_BITS_1) downto INDEX ) := (others => 'X');
                   -- port 2
                   clsn_bufs.MEM2_clsn((INDEX + XOUT_BITS_1) downto INDEX ) := (others => 'X');
                end if;
                if(not same_datap) then
                   -- parity port 1
                   if((D1PW /= 0) and (D2PW /= 0)) then
                       clsn_bufs.DOP1_clsn((we_segment * 1)  downto (we_segment * 1)) := (others => 'X');
                       clsn_bufs.MEMP1_clsn((we_segment * 1) downto (we_segment * 1)) := (others => 'X');
                   end if;

                   if((D1PW /= 0) and (D2PW /= 0)) then
                       clsn_bufs.MEMP2_clsn((we_segment * 1) downto (we_segment * 1)) := (others => 'X');
                   end if;
                end if;
            end if;
          ----
          when "000111" | "010111"  =>
          ----
            if((violation = 3) or (violation = 11) or (violation = 12)) then
                if(not same_data) then
                   -- port 1
                   clsn_bufs.DO1_clsn((INDEX + XOUT_BITS_1 ) downto INDEX) := (others => 'X');
                   clsn_bufs.MEM1_clsn((INDEX + XOUT_BITS_1) downto INDEX ) := (others => 'X');
                   -- port 2
                   clsn_bufs.DO2_clsn((INDEX + XOUT_BITS_1 ) downto INDEX) := (others => 'X');
                   clsn_bufs.MEM2_clsn((INDEX + XOUT_BITS_1) downto INDEX ) := (others => 'X');
                end if;
                if(not same_datap) then
                   -- parity port 1
                   if((D1PW /= 0) and (D2PW /= 0)) then
                       clsn_bufs.DOP1_clsn((we_segment * 1)  downto (we_segment * 1)) := (others => 'X');
                       clsn_bufs.MEMP1_clsn((we_segment * 1) downto (we_segment * 1)) := (others => 'X');
                   end if;
                   -- parity port 2
                   if((D1PW /= 0) and (D2PW /= 0)) then
                       clsn_bufs.DOP2_clsn((we_segment * 1)  downto (we_segment * 1)) := (others => 'X');
                       clsn_bufs.MEMP2_clsn((we_segment * 1) downto (we_segment * 1)) := (others => 'X');
                   end if;
                end if;
            end if;

          ----
          when "100011" =>
          ----
             if((violation = 3) or (violation = 11)) then
                if(not same_data) then
                   -- port 1
                   clsn_bufs.MEM1_clsn((INDEX + XOUT_BITS_1) downto INDEX ) := (others => 'X');
                   -- port 2
                   clsn_bufs.DO2_clsn((INDEX + XOUT_BITS_1 ) downto INDEX) := (others => 'X');
                   clsn_bufs.MEM2_clsn((INDEX + XOUT_BITS_1) downto INDEX ) := (others => 'X');
                end if;

                if(not same_datap) then
                   -- parity port 1
                   if((D1PW /= 0) and (D2PW /= 0)) then
                       clsn_bufs.MEMP1_clsn((we_segment * 1) downto (we_segment * 1)) := (others => 'X');
                   end if;
                   -- parity port 2
                   if((D1PW /= 0) and (D2PW /= 0)) then
                       clsn_bufs.DOP2_clsn((we_segment * 1)  downto (we_segment * 1)) := (others => 'X');
                       clsn_bufs.MEMP2_clsn((we_segment * 1) downto (we_segment * 1)) := (others => 'X');
                   end if;
                end if;

             end if;

          ----
          when "100111" =>
          ----
             if((violation = 3) or (violation = 11) or (violation = 12) ) then
                if(not same_data) then
                   -- port 1
                   clsn_bufs.MEM1_clsn((INDEX + XOUT_BITS_1) downto INDEX ) := (others => 'X');
                   -- port 2
                   clsn_bufs.DO2_clsn((INDEX + XOUT_BITS_1 ) downto INDEX) := (others => 'X');
                   clsn_bufs.MEM2_clsn((INDEX + XOUT_BITS_1) downto INDEX ) := (others => 'X');
                end if;

                if(not same_datap) then
                   -- parity port 1
                   if((D1PW /= 0) and (D2PW /= 0)) then
                       clsn_bufs.MEMP1_clsn((we_segment * 1) downto (we_segment * 1)) := (others => 'X');
                   end if;
                   -- parity port 2
                   if((D1PW /= 0) and (D2PW /= 0)) then
                       clsn_bufs.DOP2_clsn((we_segment * 1)  downto (we_segment * 1)) := (others => 'X');
                       clsn_bufs.MEMP2_clsn((we_segment * 1) downto (we_segment * 1)) := (others => 'X');
                   end if;
                end if;

             end if;
          ----
          when "101011" =>
          ----
             if((violation = 3) or (violation = 11)) then
                if(not same_data) then
                   -- port 1
                   clsn_bufs.MEM1_clsn((INDEX + XOUT_BITS_1) downto INDEX ) := (others => 'X');
                   -- port 2
                   clsn_bufs.MEM2_clsn((INDEX + XOUT_BITS_1) downto INDEX ) := (others => 'X');
                end if;
                if(not same_datap) then
                   if((D1PW /= 0) and (D2PW /= 0)) then
                        -- parity port 1
                       clsn_bufs.MEMP1_clsn((we_segment * 1) downto (we_segment * 1)) := (others => 'X');
                        -- parity port 2
                       clsn_bufs.MEMP2_clsn((we_segment * 1) downto (we_segment * 1)) := (others => 'X');
                   end if;
                end if;
             end if;

---===============================================================================
---                           wea&web = 01
---===============================================================================
          ----
          when "000001" | "010001" | "100001"  =>
          ----
             if((violation = 3) or (violation = 11)) then
                if(not same_data) then
                   -- port 1
                   clsn_bufs.DO1_clsn((INDEX + XOUT_BITS_1 ) downto INDEX) := (others => 'X');
                end if;
                if(not same_datap) then
                   if((D1PW /= 0) and (D2PW /= 0)) then
                       clsn_bufs.DOP1_clsn((we_segment * 1)  downto (we_segment * 1)) := (others => 'X');
                   end if;
                end if;
             end if;
          ----
          when "000101" | "010101" | "100101"  =>
          ----
             if((violation = 11)  or (violation = 12)) then
                if(not same_data) then
                   -- port 1
                   clsn_bufs.DO1_clsn((INDEX + XOUT_BITS_1 ) downto INDEX) := (others => 'X');
                end if;
                if(not same_datap) then
                   -- parity port 1
                   if((D1PW /= 0) and (D2PW /= 0)) then
                      clsn_bufs.DOP1_clsn((we_segment * 1)  downto (we_segment * 1)) := (others => 'X');
                   end if;
                end if;

             end if;
          ----
          when "001001" | "011001" | "101001"  =>
          ----
             if((violation = 3) or (violation = 11)) then
                if(not same_data) then
                   -- port 1
                   clsn_bufs.DO1_clsn((INDEX + XOUT_BITS_1 ) downto INDEX) := (others => 'X');
                end if;
                if(not same_datap) then
                   -- parity port 1
                   if((D1PW /= 0) and (D2PW /= 0)) then
                       clsn_bufs.DOP1_clsn((we_segment * 1)  downto (we_segment * 1)) := (others => 'X');
                   end if;
                end if;
             end if;

---===============================================================================
---                           wea&web = 10
---===============================================================================

          ----
          when "000010" | "000110" | "001010"  =>
          ----
             if((violation = 3) or (violation = 11)) then
                if(not same_data) then
                   --  port 1
                   clsn_bufs.DO2_clsn((INDEX + XOUT_BITS_1 ) downto INDEX) := (others => 'X');
                end if;
                if(not same_datap) then
                   -- parity port 1
                   if((D1PW /= 0) and (D2PW /= 0)) then
                       clsn_bufs.DOP2_clsn((we_segment * 1)  downto (we_segment * 1)) := (others => 'X');
                   end if;
                end if;
             end if;
          ----
          when "100010" | "100110" | "101010"  =>
          ----
             if((violation = 3) or (violation = 11)) then
                if(not same_data) then
                   --  port 1
                   clsn_bufs.DO2_clsn((INDEX + XOUT_BITS_1 ) downto INDEX) := (others => 'X');
                end if;
                if(not same_datap) then
                   -- parity port 1
                   if((D1PW /= 0) and (D2PW /= 0)) then
                       clsn_bufs.DOP2_clsn((we_segment * 1)  downto (we_segment * 1)) := (others => 'X');
                   end if;
                end if;

             end if;

---===============================================================================
---                           others 
---===============================================================================

          ---------
          when others =>
          ---------
                null;
   end case;

   end CollisionTableRest;

------------------------------------------------
-- procedure PreProcessWe1We2
------------------------------------------------
--
--  Checks whether the time duration of rising
--  clka and clkb violates required setup time
--  between these clocks.
--
   procedure PreProcessWe1We2(
             variable clsn_bufs     : out ClsnXbufType;
             variable clsn_Type     : out CollisionFlagType;
             constant memory        : in std_logic_vector(18431 downto 0);
             constant di1           : in std_logic_vector(31 downto 0)   := (others => 'X');
             constant di2           : in std_logic_vector(31 downto 0)   := (others => 'X');
             constant dip1          : in std_logic_vector(3 downto 0)    := (others => 'X');
             constant dip2          : in std_logic_vector(3 downto 0)    := (others => 'X');
             variable addr1         : in std_logic_vector(13 downto 0)   := (others => 'X');
             variable addr2         : in std_logic_vector(13 downto 0)   := (others => 'X');
             variable we1           : in std_logic_vector(3 downto 0)    := (others => 'X');
             variable we2           : in std_logic_vector(3 downto 0)    := (others => 'X');
             variable zero_read_1   : in std_logic_vector(13 downto 0)   := (others => 'X');
             variable zero_readp_1  : in std_logic_vector(10 downto 0)   := (others => 'X');
             variable zero_write_1  : in std_logic_vector(13 downto 0)   := (others => 'X');
             variable zero_writep_1 : in std_logic_vector(10 downto 0)   := (others => 'X');
             variable zero_read_2   : in std_logic_vector(13 downto 0)   := (others => 'X');
             variable zero_readp_2  : in std_logic_vector(10 downto 0)   := (others => 'X');
             variable zero_write_2  : in std_logic_vector(13 downto 0)   := (others => 'X');
             variable zero_writep_2 : in std_logic_vector(10 downto 0)   := (others => 'X');
             variable wr_mode_1     : in std_logic_vector(1 downto 0)    := "00";
             variable wr_mode_2     : in std_logic_vector(1 downto 0)    := "00";
             constant violation     : in integer := -1;
             variable DI1W          : in integer := -1;
             variable DIP1W         : in integer := -1;
             variable DI2W          : in integer := -1;
             variable DIP2W         : in integer := -1;
             variable DO1W          : in integer := -1;
             variable DOP1W         : in integer := -1;
             variable DO2W          : in integer := -1;
             variable DOP2W         : in integer := -1
   ) is

   variable we1we2 : std_logic_vector(1 downto 0) := "XX";
   variable zero_addr1        : std_logic_vector(13 downto 0) := (others => 'X');
   variable zero_addr2        : std_logic_vector(13 downto 0) := (others => 'X');
   variable zero_parity_addr1 : std_logic_vector(10 downto 0) := (others => 'X');
   variable zero_parity_addr2 : std_logic_vector(10 downto 0) := (others => 'X');
   variable tmp_addr1_zero    : std_logic_vector(13 downto 0) := (others => 'X');
   variable tmp_addr2_zero    : std_logic_vector(13 downto 0) := (others => 'X');
   variable tmp_parity_addr1_zero    : std_logic_vector(10 downto 0) := (others => 'X');
   variable tmp_parity_addr2_zero    : std_logic_vector(10 downto 0) := (others => 'X');


   variable tmp_we1                  : std_ulogic := 'X';
   variable tmp_we2                  : std_ulogic := 'X';
   variable j                        : integer    := 0;

   variable same_data_flg            : boolean    := false;
   variable same_datap_flg           : boolean    := false;

   begin
      
      clsn_type.read_write  := false;
      clsn_type.write_read  := false;
      clsn_type.write_write := false;

      for i in  0 to 3 loop
         we1we2 := we1(i)&we2(i);
         clsn_type.we(i)  := '0';
         case we1we2 is
             ---------
             when "00" =>
             ---------
                null;
   
             ---------
             when "01" =>
             ---------
                same_data_flg  := false;
                same_datap_flg := false;

                zero_addr1 := zero_read_1;
                zero_addr2 := zero_write_2;
             
                zero_parity_addr1 := zero_readp_1;
                zero_parity_addr2 := zero_writep_2;

                tmp_we1 := '0';
                tmp_we2 := '1';

                if(AddrOverlapCheck(DO1W, DI2W, addr1, addr2, zero_addr1, zero_addr2,i)) then

                   tmp_addr1_zero := (addr1(MAX_ADDR downto 0) and zero_addr1);
                   tmp_addr2_zero := (addr2(MAX_ADDR downto 0) and zero_addr2);

                   tmp_parity_addr1_zero := addr1(13 downto 3) and zero_parity_addr1;
                   tmp_parity_addr2_zero := addr2(13 downto 3) and zero_parity_addr2;

-- FP fixed false message for DSP group 12/06/04

                      clsn_type.read_write := true;
                      clsn_type.we(i)  := '1';

                      if((wr_mode_2 = "01")) then
                        clsn_type.read_write := false;
                        clsn_type.we(i)  := '0';
                      end if;

	
                      CollisionTableRest(
                        same_data_flg  => same_data_flg,
                        same_datap_flg => same_datap_flg,
                        clsn_bufs      => clsn_bufs,
                        mem            => memory,
                        di1            => di1,
                        di2            => di2,
                        dip1           => dip1,
                        dip2           => dip2,
                        addr1          => tmp_addr1_zero,
                        addr2          => tmp_addr2_zero,
                        addrp1         => tmp_parity_addr1_zero,
                        addrp2         => tmp_parity_addr2_zero,
                        wr_mode_1      => wr_mode_1,
                        wr_mode_2      => wr_mode_2,
                        violation      => violation,
                        we_segment     => i,
                        we1            => tmp_we1,
                        we2            => tmp_we2,
                        D1W            => DO1W,
                        D1PW           => DOP1W,
                        D2W            => DI2W,
                        D2PW           => DIP2W
                      );
                end if;
             ---------
             when "10" =>
             ---------
                same_data_flg  := false;
                same_datap_flg := false;

                zero_addr1 := zero_write_1;
                zero_addr2 := zero_read_2;

                zero_parity_addr1 := zero_writep_1;
                zero_parity_addr2 := zero_readp_2;

                tmp_we1 := '1';
                tmp_we2 := '0';


                if(AddrOverlapCheck(DI1W, DO2W, addr1, addr2, zero_addr1, zero_addr2,i)) then

                   tmp_addr1_zero := (addr1(MAX_ADDR downto 0) and zero_addr1);
                   tmp_addr2_zero := (addr2(MAX_ADDR downto 0) and zero_addr2);

                   tmp_parity_addr1_zero := addr1(13 downto 3) and zero_parity_addr1;
                   tmp_parity_addr2_zero := addr2(13 downto 3) and zero_parity_addr2;

                      clsn_type.write_read := true;
                      clsn_type.we(i)  := '1';

-- FP fixed false message for DSP group 12/06/04
--                      if((violation = 12) or (wr_mode_1 = "01")) then
                      if((wr_mode_1 = "01")) then
                        clsn_type.write_read := false;
                        clsn_type.we(i)  := '0';
                      end if; 

                      CollisionTableRest(
                        same_data_flg  => same_data_flg,
                        same_datap_flg => same_datap_flg,
                        clsn_bufs      => clsn_bufs,
                        mem            => memory,
                        di1            => di1,
                        di2            => di2,
                        dip1           => dip1,
                        dip2           => dip2,
                        addr1          => tmp_addr1_zero,
                        addr2          => tmp_addr2_zero,
                        addrp1         => tmp_parity_addr1_zero,
                        addrp2         => tmp_parity_addr2_zero,
                        wr_mode_1      => wr_mode_1,
                        wr_mode_2      => wr_mode_2,
                        violation      => violation,
                        we_segment     => i,
                        we1            => tmp_we1,
                        we2            => tmp_we2,
                        D1W            => DI1W,
                        D1PW           => DIP1W,
                        D2W            => DO2W,
                        D2PW           => DOP2W
                      );
                end if;
             ---------
             when "11" =>
             ---------
                same_data_flg  := false;
                same_datap_flg := false;

                zero_addr1 := zero_write_1;
                zero_addr2 := zero_write_2;

                zero_parity_addr1 := zero_writep_1;
                zero_parity_addr2 := zero_writep_2;

                tmp_we1 := '1';
                tmp_we2 := '1';

                if(AddrOverlapCheck(DI1W, DI2W, addr1, addr2, zero_addr1, zero_addr2,i)) then

                   tmp_addr1_zero := (addr1(MAX_ADDR downto 0) and zero_addr1);
                   tmp_addr2_zero := (addr2(MAX_ADDR downto 0) and zero_addr2);

                   tmp_parity_addr1_zero := addr1(13 downto 3) and zero_parity_addr1;
                   tmp_parity_addr2_zero := addr2(13 downto 3) and zero_parity_addr2;

                      if(violation = 12) then
                         if(wr_mode_2 = "01") then
                            clsn_type.write_write := true;
                            clsn_type.we(i)  := '1';
                         end if; 
                      else 
                         clsn_type.write_write := true;
                         clsn_type.we(i)  := '1';
                      end if;

                      CollisionTableRest(
                        same_data_flg  => same_data_flg,
                        same_datap_flg => same_datap_flg,
                        clsn_bufs      => clsn_bufs,
                        mem            => memory,
                        di1            => di1,
                        di2            => di2,
                        dip1           => dip1,
                        dip2           => dip2,
                        addr1          => tmp_addr1_zero,
                        addr2          => tmp_addr2_zero,
                        addrp1         => tmp_parity_addr1_zero,
                        addrp2         => tmp_parity_addr2_zero,
                        wr_mode_1      => wr_mode_1,
                        wr_mode_2      => wr_mode_2,
                        violation      => violation,
                        we_segment     => i,
                        we1            => tmp_we1,
                        we2            => tmp_we2,
                        D1W            => DI1W,
                        D1PW           => DIP1W,
                        D2W            => DI2W,
                        D2PW           => DIP2W
                      );
                end if;

                if((DI1W /= DO1W) or (DI2W /= DO2W)) then
--FP disabled the cross check call
--                   tmp_we1 := '1';
--                   tmp_we2 := '0';
                   tmp_we1 := '0';
                   tmp_we2 := '0';

                   zero_addr1 := zero_write_1;
                   zero_addr2 := zero_read_2;

                   zero_parity_addr1 := zero_writep_1;
                   zero_parity_addr2 := zero_readp_2;

                   if(AddrOverlapCheck(DI1W, DO2W, addr1, addr2, zero_addr1, zero_addr2,i)) then

                      tmp_addr1_zero := (addr1(MAX_ADDR downto 0) and zero_addr1);
                      tmp_addr2_zero := (addr2(MAX_ADDR downto 0) and zero_addr2);

                      tmp_parity_addr1_zero := addr1(13 downto 3) and zero_parity_addr1;
                      tmp_parity_addr2_zero := addr2(13 downto 3) and zero_parity_addr2;

                      CollisionTableRest(
                        same_data_flg  => same_data_flg,
                        same_datap_flg => same_datap_flg,
                        clsn_bufs      => clsn_bufs,
                        mem            => memory,
                        di1            => di1,
                        di2            => di2,
                        dip1           => dip1,
                        dip2           => dip2,
                        addr1          => tmp_addr1_zero,
                        addr2          => tmp_addr2_zero,
                        addrp1         => tmp_parity_addr1_zero,
                        addrp2         => tmp_parity_addr2_zero,
                        wr_mode_1      => wr_mode_1,
                        wr_mode_2      => wr_mode_2,
                        violation      => violation,
                        we_segment     => i,
                        we1            => tmp_we1,
                        we2            => tmp_we2,
                        D1W            => DI1W,
                        D1PW           => DIP1W,
                        D2W            => DO2W,
                        D2PW           => DOP2W
                      );
                   end if;

--FP disabled the cross check call
--                   tmp_we1 := '0';
--                   tmp_we2 := '1';
                   tmp_we1 := '0';
                   tmp_we2 := '0';

                   zero_addr1 := zero_read_1;
                   zero_addr2 := zero_write_2;

                   zero_parity_addr1 := zero_readp_1;
                   zero_parity_addr2 := zero_writep_2;

                   if(AddrOverlapCheck(DO1W, DI2W, addr1, addr2, zero_addr1, zero_addr2,i)) then

                      tmp_addr1_zero := (addr1(MAX_ADDR downto 0) and zero_addr1);
                      tmp_addr2_zero := (addr2(MAX_ADDR downto 0) and zero_addr2);

                      tmp_parity_addr1_zero := addr1(13 downto 3) and zero_parity_addr1;
                      tmp_parity_addr2_zero := addr2(13 downto 3) and zero_parity_addr2;

                      CollisionTableRest(
                        same_data_flg  => same_data_flg,
                        same_datap_flg => same_datap_flg,
                        clsn_bufs      => clsn_bufs,
                        mem            => memory,
                        di1            => di1,
                        di2            => di2,
                        dip1           => dip1,
                        dip2           => dip2,
                        addr1          => tmp_addr1_zero,
                        addr2          => tmp_addr2_zero,
                        addrp1         => tmp_parity_addr1_zero,
                        addrp2         => tmp_parity_addr2_zero,
                        wr_mode_1      => wr_mode_1,
                        wr_mode_2      => wr_mode_2,
                        violation      => violation,
                        we_segment     => i,
                        we1            => tmp_we1,
                        we2            => tmp_we2,
                        D1W            => DO1W,
                        D1PW           => DOP1W,
                        D2W            => DI2W,
                        D2PW           => DIP2W
                      );

                   end if;
                end if;
  
             when others =>
                null;

         end case;

      end loop;

   end PreProcessWe1We2;
------------------------------------------------
-- procedure Memory_Collision_Msg_ramb16
------------------------------------------------
-- This is almost the same procedure as the procedure for V2 ram collision 
-- except that is is local to the model (since this is the only one that 
-- calls this procedure
  Procedure Memory_Collision_Msg_ramb16 (
    CONSTANT HeaderMsg      : IN STRING := " Memory Collision Error on ";        
    CONSTANT EntityName : IN STRING := "";
    CONSTANT InstanceName : IN STRING := "";
    constant collision_type : in memory_collision_type;
    constant address_1 : in std_logic_vector; 
    constant address_2 : in std_logic_vector; 
    CONSTANT MsgSeverity    : IN SEVERITY_LEVEL := Error
    
    
    ) IS
    variable current_time : time := NOW;
    variable string_length_1 : integer;
    variable string_length_2 : integer;    

    VARIABLE Message : LINE;
  BEGIN
    if ((address_1'length mod 4) = 0) then
      string_length_1 := address_1'length/4;
    elsif ((address_1'length mod 4) > 0) then
      string_length_1 := address_1'length/4 + 1;      
    end if;
    if ((address_2'length mod 4) = 0) then
      string_length_2 := address_2'length/4;
    elsif ((address_2'length mod 4) > 0) then
      string_length_2 := address_2'length/4 + 1;      
    end if;    
--    if ((collision_type = Read_A_Write_B) or (collision_type = Read_B_Write_A)) then
    if ((collision_type = Read_A_Write_B) or (collision_type = Write_A_Read_B) or
        (collision_type = Read_B_Write_A) or (collision_type = Write_B_Read_A)) then
      Write ( Message, HeaderMsg);
      Write ( Message, EntityName);    
      Write ( Message, STRING'(": "));
      Write ( Message, InstanceName);
      Write ( Message, STRING'(" at simulation time "));
      Write ( Message, current_time);
      Write ( Message, STRING'("."));
      Write ( Message, LF );            
      Write ( Message, STRING'(" A read was performed on address "));
      Write ( Message, SLV_TO_HEX(address_1, string_length_1));
      Write ( Message, STRING'(" (hex) "));            
--      if (collision_type = Read_A_Write_B) then
      if ((collision_type = Read_A_Write_B) or (collision_type = Write_B_Read_A))then
         Write ( Message, STRING'("of port A while a write was requested to the same address on Port B "));
         Write ( Message, STRING'(" The write will be successful however the read value is unknown until the next CLKA cycle  "));
--      elsif(collision_type = Read_B_Write_A) then
      elsif((collision_type = Read_B_Write_A) or (collision_type = Write_A_Read_B)) then
         Write ( Message, STRING'("of port B while a write was requested to the same address on Port A "));
         Write ( Message, STRING'(" The write will be successful however the read value is unknown until the next CLKB cycle  "));
      end if;
    elsif ((collision_type = Write_A_Write_B) or (collision_type = Write_B_Write_A)) then
      Write ( Message, HeaderMsg);
      Write ( Message, EntityName);    
      Write ( Message, STRING'(": "));
      Write ( Message, InstanceName);
      Write ( Message, STRING'(" at simulation time "));
      Write ( Message, current_time);
      Write ( Message, STRING'("."));
      Write ( Message, LF );            
      Write ( Message, STRING'(" A write was requested to the same address simultaneously at both Port A and Port B of the RAM."));
      Write ( Message, STRING'(" The contents written to the RAM at address location "));      
      Write ( Message, SLV_TO_HEX(address_1, string_length_1));
      Write ( Message, STRING'(" (hex) "));            
      Write ( Message, STRING'("of Port A and address location "));
      Write ( Message, SLV_TO_HEX(address_2, string_length_2));
      Write ( Message, STRING'(" (hex) "));            
      Write ( Message, STRING'("of Port B are unknown. "));
    end if;      
    ASSERT FALSE REPORT Message.ALL SEVERITY MsgSeverity;

    DEALLOCATE (Message);
  END Memory_Collision_Msg_ramb16;      

------------------ END Procedures/Functions ------------------------------

  signal ADDRA_ipd    : std_logic_vector(MAX_ADDR downto 0) := (others => 'X');
  signal CLKA_ipd     : std_ulogic                          := 'X';
  signal DIA_ipd      : std_logic_vector(MAX_DI  downto 0)  := (others => 'X');
  signal DIPA_ipd     : std_logic_vector(MAX_DIP downto 0)  := (others => 'X');
  signal ENA_ipd      : std_ulogic                          := 'X';
  signal SSRA_ipd     : std_ulogic                          := 'X';
  signal WEA_ipd      : std_logic_vector(MAX_WE downto 0)   := (others => 'X');

  signal ADDRB_ipd    : std_logic_vector(MAX_ADDR downto 0) := (others => 'X');
  signal CLKB_ipd     : std_ulogic                          := 'X';
  signal DIB_ipd      : std_logic_vector(MAX_DI  downto 0)  := (others => 'X');
  signal DIPB_ipd     : std_logic_vector(MAX_DIP downto 0)  := (others => 'X');
  signal ENB_ipd      : std_ulogic                          := 'X';
  signal SSRB_ipd     : std_ulogic                          := 'X';
  signal WEB_ipd      : std_logic_vector(MAX_WE downto 0)   := (others => 'X');

  signal GSR_ipd      : std_ulogic                          := 'X';

  signal GSR_dly      : std_ulogic                          := 'X';

  signal ADDRA_dly    : std_logic_vector(MAX_ADDR downto 0) := (others => 'X');
  signal CLKA_dly     : std_ulogic                          := 'X';
  signal DIA_dly      : std_logic_vector(MAX_DI downto 0) := (others => 'X');
  signal DIPA_dly     : std_logic_vector(MAX_DIP downto 0)  := (others => 'X');
  signal ENA_dly      : std_ulogic                          := 'X';
  signal GSR_CLKA_dly : std_ulogic                          := 'X';
  signal SSRA_dly     : std_ulogic                          := 'X';
  signal WEA_dly      : std_logic_vector(MAX_WE downto 0)   := (others => 'X');

  signal ADDRB_dly    : std_logic_vector(MAX_ADDR downto 0) := (others => 'X');
  signal CLKB_dly     : std_ulogic                          := 'X';
  signal DIB_dly      : std_logic_vector(MAX_DI downto 0) := (others => 'X');
  signal DIPB_dly     : std_logic_vector(MAX_DIP downto 0)  := (others => 'X');
  signal ENB_dly      : std_ulogic                          := 'X';
  signal GSR_CLKB_dly : std_ulogic                          := 'X';
  signal SSRB_dly     : std_ulogic                          := 'X';
  signal WEB_dly      : std_logic_vector(MAX_WE downto 0)   := (others => 'X');

  signal DOA_viol     : std_logic_vector(MAX_DI downto 0);
  signal DOPA_viol    : std_logic_vector(3 downto 0);
  signal DOB_viol     : std_logic_vector(MAX_DI downto 0);
  signal DOPB_viol    : std_logic_vector(3 downto 0);

  signal DIAW              : integer;
  signal DIAW_1            : integer;
  signal DIBW              : integer;
  signal DIBW_1            : integer;
  signal DIPAW             : integer;
  signal DIPAW_1           : integer;
  signal DIPBW             : integer;
  signal DIPBW_1           : integer;

  signal DOAW              : integer;
  signal DOAW_1            : integer;
  signal DOBW              : integer;
  signal DOBW_1            : integer;
  signal DOPAW             : integer;
  signal DOPAW_1           : integer;
  signal DOPBW             : integer;
  signal DOPBW_1           : integer;

  signal INI_A_sig         : std_logic_vector (35 downto 0) :=  (others => 'X');
  signal INI_B_sig         : std_logic_vector (35 downto 0) :=  (others => 'X');

  signal SRVA_A_sig         : std_logic_vector (35 downto 0) :=  (others => 'X');
  signal SRVA_B_sig         : std_logic_vector (35 downto 0) :=  (others => 'X');

begin
  ---------------------
  --  INPUT PATH DELAYs
  --------------------

  WireDelay     : block
  begin

-----  Port A

    ADDRA_DELAY : for i in MAX_ADDR downto 0 generate
      VitalWireDelay (ADDRA_ipd(i), ADDRA(i), tipd_ADDRA(i));
    end generate ADDRA_DELAY;

    DIA_DELAY   : for i in MAX_DI downto 0 generate
      VitalWireDelay (DIA_ipd(i), DIA(i), tipd_DIA(i));
    end generate DIA_DELAY;

    DIPA_DELAY  : for i in MAX_DIP downto 0 generate
      VitalWireDelay (DIPA_ipd(i), DIPA(i), tipd_DIPA(i));
    end generate DIPA_DELAY;

    WEA_DELAY : for i in  MAX_WE downto 0 GENERATE
      VitalWireDelay (WEA_ipd(i) , WEA(i), tipd_WEA(i));
    end generate WEA_DELAY;

    VitalWireDelay (CLKA_ipd, CLKA, tipd_CLKA);
    VitalWireDelay (ENA_ipd, ENA, tipd_ENA);
    VitalWireDelay (SSRA_ipd, SSRA, tipd_SSRA);

-----  Port B

    ADDRB_DELAY : for i in MAX_ADDR downto 0 generate
      VitalWireDelay (ADDRB_ipd(i), ADDRB(i), tipd_ADDRB(i));
    end generate ADDRB_DELAY;

    DIB_DELAY   : for i in MAX_DI downto 0 generate
      VitalWireDelay (DIB_ipd(i), DIB(i), tipd_DIB(i));
    end generate DIB_DELAY;

    DIPB_DELAY  : for i in MAX_DIP downto 0 generate
      VitalWireDelay (DIPB_ipd(i), DIPB(i), tipd_DIPB(i));
    end generate DIPB_DELAY;

    WEB_DELAY : for i in  MAX_WE downto 0 GENERATE
      VitalWireDelay (WEB_ipd(i) , WEB(i), tipd_WEB(i));
    end generate WEB_DELAY;

    VitalWireDelay (CLKB_ipd, CLKB, tipd_CLKB);
    VitalWireDelay (ENB_ipd, ENB, tipd_ENB);
    VitalWireDelay (SSRB_ipd, SSRB, tipd_SSRB);

----- GSR

    VitalWireDelay (GSR_ipd, GSR, tipd_GSR);

  end block;

  SignalDelay   : block
  begin

-----  Port A

    ADDRA_DELAY : for i in MAX_ADDR downto 0 generate
      VitalSignalDelay (ADDRA_dly(i), ADDRA_ipd(i), tisd_ADDRA_CLKA(i));
    end generate ADDRA_DELAY;

    DIA_DELAY   : for i in MAX_DI downto 0 generate
      VitalSignalDelay (DIA_dly(i), DIA_ipd(i), tisd_DIA_CLKA(i));
    end generate DIA_DELAY;

    DIPA_DELAY  : for i in MAX_DIP downto 0 generate
      VitalSignalDelay (DIPA_dly(i), DIPA_ipd(i), tisd_DIPA_CLKA(i));
    end generate DIPA_DELAY;

    WEA_DELAY   : for i in MAX_WE downto 0 generate
      VitalSignalDelay (WEA_dly(i), WEA_ipd(i), tisd_WEA_CLKA(i));
    end generate WEA_DELAY;

    VitalSignalDelay (CLKA_dly, CLKA_ipd, ticd_CLKA);
    VitalSignalDelay (ENA_dly, ENA_ipd, tisd_ENA_CLKA);
    VitalSignalDelay (GSR_CLKA_dly, GSR_ipd, tisd_GSR_CLKA);
    VitalSignalDelay (SSRA_dly, SSRA_ipd, tisd_SSRA_CLKA);

-----  Port B   

    ADDRB_DELAY : for i in MAX_ADDR downto 0 generate
      VitalSignalDelay (ADDRB_dly(i), ADDRB_ipd(i), tisd_ADDRB_CLKB(i));
    end generate ADDRB_DELAY;


    DIB_DELAY   : for i in MAX_DI downto 0 generate
      VitalSignalDelay (DIB_dly(i), DIB_ipd(i), tisd_DIB_CLKB(i));
    end generate DIB_DELAY;

    DIPB_DELAY  : for i in MAX_DIP downto 0 generate
      VitalSignalDelay (DIPB_dly(i), DIPB_ipd(i), tisd_DIPB_CLKB(i));
    end generate DIPB_DELAY;

    WEB_DELAY   : for i in MAX_WE downto 0 generate
      VitalSignalDelay (WEB_dly(i), WEB_ipd(i), tisd_WEB_CLKB(i));
    end generate WEB_DELAY;

    VitalSignalDelay (CLKB_dly, CLKB_ipd, ticd_CLKB);
    VitalSignalDelay (ENB_dly, ENB_ipd, tisd_ENB_CLKB);
    VitalSignalDelay (GSR_CLKB_dly, GSR_ipd, tisd_GSR_CLKB);
    VitalSignalDelay (SSRB_dly, SSRB_ipd, tisd_SSRB_CLKB);

  end block;

  --------------------
  --  BEHAVIOR SECTION
  --------------------

   prcs_initialize:process
    variable INI_A         : std_logic_vector (35 downto 0) :=  (others => 'X');
    variable INI_A_UNBOUND : std_logic_vector (INIT_A'length-1 downto 0);
    variable INI_B         : std_logic_vector (35 downto 0) :=  (others => 'X');
    variable INI_B_UNBOUND : std_logic_vector (INIT_B'length-1 downto 0);

    variable SRVA_A            : std_logic_vector (35 downto 0) :=  (others => 'X');
    variable SRVA_A_UNBOUND    : std_logic_vector (SRVAL_A'length-1 downto 0);
    variable SRVA_B            : std_logic_vector (35 downto 0) :=  (others => 'X');
    variable SRVA_B_UNBOUND    : std_logic_vector (SRVAL_B'length-1 downto 0);

    variable DIAW_var              : integer;
    variable DIAW_1_var            : integer;
    variable DIBW_var              : integer;
    variable DIBW_1_var            : integer;
    variable DIPAW_var             : integer;
    variable DIPAW_1_var           : integer;
    variable DIPBW_var             : integer;
    variable DIPBW_1_var           : integer;

    variable DOAW_var              : integer;
    variable DOAW_1_var            : integer;
    variable DOBW_var              : integer;
    variable DOBW_1_var            : integer;
    variable DOPAW_var             : integer;
    variable DOPAW_1_var           : integer;
    variable DOPBW_var             : integer;
    variable DOPBW_1_var           : integer;

   begin
      DIPAW_var   := 0;
      DIPAW_1_var := -1;
      DIPBW_var   := 0;
      DIPBW_1_var := -1;

      DOPAW_var   := 0;
      DOPAW_1_var := -1;
      DOPBW_var   := 0;
      DOPBW_1_var := -1;

     
--------------------------------------------------------------------
--    Additional Checks Added Later
--------------------------------------------------------------------
      if((DATA_WIDTH_A = 0) and (DATA_WIDTH_B = 0 )) then
        assert false
        report "Attribute Syntax Error: Both DATA_WIDTH_A and DATA_WIDTH_B can not be 0."
        severity Failure;
      end if;

      case DATA_WIDTH_A is

            when 0 =>
                 DOAW_var    := 1;
                 DOAW_1_var  := DOAW_var -1;
                 DIAW_var    := 1;
                 DIAW_1_var  := DIAW_var -1;

            when 1 =>
                 DOAW_var    := 1;
                 DOAW_1_var  := DOAW_var -1;
                 DIAW_var    := 1;
                 DIAW_1_var  := DIAW_var -1;

            when 2 =>
                 DOAW_var    := 2;
                 DOAW_1_var  := DOAW_var -1;
                 DIAW_var    := 2;
                 DIAW_1_var  := DIAW_var -1;

            when 4 =>
                 DOAW_var    := 4;
                 DOAW_1_var  := DOAW_var -1;
                 DIAW_var    := 4;
                 DIAW_1_var  := DIAW_var -1;

            when 9 =>
                 DOAW_var    := 8;
                 DOAW_1_var  := DOAW_var -1;
                 DOPAW_var   := 1;
                 DOPAW_1_var := DOPAW_var -1;
                 DIAW_var    := 8;
                 DIAW_1_var  := DIAW_var -1;
                 DIPAW_var   := 1;
                 DIPAW_1_var := DIPAW_var -1;

            when 18  =>
                 DOAW_var    := 16;
                 DOAW_1_var  := DOAW_var -1;
                 DOPAW_var   := 2;
                 DOPAW_1_var := DOPAW_var -1;
                 DIAW_var    := 16;
                 DIAW_1_var  := DIAW_var -1;
                 DIPAW_var   := 2;
                 DIPAW_1_var := DIPAW_var -1;

            when 36  =>
                 DOAW_var    := 32;
                 DOAW_1_var  := DOAW_var -1;
                 DOPAW_var   := 4;
                 DOPAW_1_var := DOPAW_var -1;
                 DIAW_var    := 32;
                 DIAW_1_var  := DIAW_var -1;
                 DIPAW_var   := 4;
                 DIPAW_1_var := DIPAW_var -1;

            when others =>
                 GenericValueCheckMessage
                 (  HeaderMsg            => " Attribute Syntax Error : ",
                    GenericName          => " DATA_WIDTH_A ",
                    EntityName           => "/X_RAMB16BWE",
                    GenericValue         => DATA_WIDTH_A,
                    Unit                 => "",
                    ExpectedValueMsg     => " The Legal values for this attribute are ",
                    ExpectedGenericValue => " 0, 1, 2, 4, 9, 18 or 36.",
                    TailMsg              => "",
                    MsgSeverity          => failure
                 );
      end case;


      case DATA_WIDTH_B is

            when 0 =>
                 DOBW_var    := 1;
                 DOBW_1_var  := DOBW_var -1;
                 DIBW_var    := 1;
                 DIBW_1_var  := DIBW_var -1;

            when 1 =>
                 DOBW_var    := 1;
                 DOBW_1_var  := DOBW_var -1;
                 DIBW_var    := 1;
                 DIBW_1_var  := DIBW_var -1;

            when 2 =>
                 DOBW_var    := 2;
                 DOBW_1_var  := DOBW_var -1;
                 DIBW_var    := 2;
                 DIBW_1_var  := DIBW_var -1;

            when 4 =>
                 DOBW_var    := 4;
                 DOBW_1_var  := DOBW_var -1;
                 DIBW_var    := 4;
                 DIBW_1_var  := DIBW_var -1;

            when 9 =>
                 DOBW_var    := 8;
                 DOBW_1_var  := DOBW_var -1;
                 DOPBW_var   := 1;
                 DOPBW_1_var := DOPBW_var -1;
                 DIBW_var    := 8;
                 DIBW_1_var  := DIBW_var -1;
                 DIPBW_var   := 1;
                 DIPBW_1_var := DIPBW_var -1;

            when 18  =>
                 DOBW_var    := 16;
                 DOBW_1_var  := DOBW_var -1;
                 DOPBW_var   := 2;
                 DOPBW_1_var := DOPBW_var -1;
                 DIBW_var    := 16;
                 DIBW_1_var  := DIBW_var -1;
                 DIPBW_var   := 2;
                 DIPBW_1_var := DIPBW_var -1;

            when 36  =>
                 DOBW_var    := 32;
                 DOBW_1_var  := DOBW_var -1;
                 DOPBW_var   := 4;
                 DOPBW_1_var := DOPBW_var -1;
                 DIBW_var    := 32;
                 DIBW_1_var  := DIBW_var -1;
                 DIPBW_var   := 4;
                 DIPBW_1_var := DIPBW_var -1;

            when others =>
                 GenericValueCheckMessage
                 (  HeaderMsg            => " Attribute Syntax Error : ",
                    GenericName          => " DATA_WIDTH_B ",
                    EntityName           => "/X_RAMB16BWE",
                    GenericValue         => DATA_WIDTH_B,
                    Unit                 => "",
                    ExpectedValueMsg     => " The Legal values for this attribute are ",
                    ExpectedGenericValue => " 0, 1, 2, 4, 9, 18 or 36.",
                    TailMsg              => "",
                    MsgSeverity          => failure
                 );
                 null;

      end case;


      if (INIT_A'length > 36) then
        INI_A_UNBOUND(INIT_A'length-1 downto 0) := To_StdLogicVector(INIT_A );
        INI_A(35 downto 0)                      := INI_A_UNBOUND(35 downto 0);
      elsif (INIT_A'length < 36) then
        INI_A(INIT_A'length-1 downto 0)         := To_StdLogicVector(INIT_A );
      elsif (INIT_A'length = 36) then
        INI_A(INIT_A'length-1 downto 0)         := To_StdLogicVector(INIT_A );
      end if;

      if (INIT_B'length > 36) then
        INI_B_UNBOUND(INIT_B'length-1 downto 0) := To_StdLogicVector(INIT_B );
        INI_B(35 downto 0)                      := INI_B_UNBOUND(35 downto 0);
      elsif (INIT_B'length < 36) then
        INI_B(INIT_B'length-1 downto 0)         := To_StdLogicVector(INIT_B );
      elsif (INIT_B'length = 36) then
        INI_B(INIT_B'length-1 downto 0)         := To_StdLogicVector(INIT_B );
      end if;

      if (SRVAL_A'length > 36) then
        SRVA_A_UNBOUND(SRVAL_A'length-1 downto 0) := To_StdLogicVector(SRVAL_A );
        SRVA_A(35 downto 0)                       := SRVA_A_UNBOUND(35 downto 0);
      elsif (SRVAL_A'length < 36) then
        SRVA_A(SRVAL_A'length-1 downto 0)         := To_StdLogicVector(SRVAL_A );
      elsif (SRVAL_A'length = 36) then
        SRVA_A(SRVAL_A'length-1 downto 0)         := To_StdLogicVector(SRVAL_A );
      end if;

      if (SRVAL_B'length > 36) then
        SRVA_B_UNBOUND(SRVAL_B'length-1 downto 0) := To_StdLogicVector(SRVAL_B );
        SRVA_B(35 downto 0)                       := SRVA_B_UNBOUND(35 downto 0);
      elsif (SRVAL_B'length < 36) then
        SRVA_B(SRVAL_B'length-1 downto 0)         := To_StdLogicVector(SRVAL_B );
      elsif (SRVAL_B'length = 36) then
        SRVA_B(SRVAL_B'length-1 downto 0)         := To_StdLogicVector(SRVAL_B );
      end if;

      DIAW     <= DIAW_var;
      DIAW_1   <= DIAW_1_var;
      DIBW     <= DIBW_var;
      DIBW_1   <= DIBW_1_var;
      DIPAW    <= DIPAW_var;
      DIPAW_1  <= DIPAW_1_var;
      DIPBW    <= DIPBW_var;
      DIPBW_1  <= DIPBW_1_var;

      DOAW     <= DOAW_var;
      DOAW_1   <= DOAW_1_var;
      DOBW     <= DOBW_var;
      DOBW_1   <= DOBW_1_var;
      DOPAW    <= DOPAW_var;
      DOPAW_1  <= DOPAW_1_var;
      DOPBW    <= DOPBW_var;
      DOPBW_1  <= DOPBW_1_var;

      SRVA_A_sig <= SRVA_A;
      SRVA_B_sig <= SRVA_B;
      INI_A_sig  <= INI_A;
      INI_B_sig  <= INI_B;

      wait;
  end process prcs_initialize;
---------------------------------------------------------------------------------------
  VITALBehavior                         : process

    variable Tviol_ADDRA0_CLKA_posedge  : std_ulogic := '0';
    variable Tviol_ADDRA1_CLKA_posedge  : std_ulogic := '0';
    variable Tviol_ADDRA2_CLKA_posedge  : std_ulogic := '0';
    variable Tviol_ADDRA3_CLKA_posedge  : std_ulogic := '0';
    variable Tviol_ADDRA4_CLKA_posedge  : std_ulogic := '0';
    variable Tviol_ADDRA5_CLKA_posedge  : std_ulogic := '0';
    variable Tviol_ADDRA6_CLKA_posedge  : std_ulogic := '0';
    variable Tviol_ADDRA7_CLKA_posedge  : std_ulogic := '0';
    variable Tviol_ADDRA8_CLKA_posedge  : std_ulogic := '0';
    variable Tviol_ADDRA9_CLKA_posedge  : std_ulogic := '0';
    variable Tviol_ADDRA10_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA11_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA12_CLKA_posedge : std_ulogic := '0';
    variable Tviol_ADDRA13_CLKA_posedge : std_ulogic := '0';
    variable Tviol_DIA0_CLKA_posedge    : std_ulogic := '0';
    variable Tviol_DIA1_CLKA_posedge    : std_ulogic := '0';
    variable Tviol_DIA2_CLKA_posedge    : std_ulogic := '0';
    variable Tviol_DIA3_CLKA_posedge    : std_ulogic := '0';
    variable Tviol_DIA4_CLKA_posedge    : std_ulogic := '0';
    variable Tviol_DIA5_CLKA_posedge    : std_ulogic := '0';
    variable Tviol_DIA6_CLKA_posedge    : std_ulogic := '0';
    variable Tviol_DIA7_CLKA_posedge    : std_ulogic := '0';
    variable Tviol_DIA8_CLKA_posedge    : std_ulogic := '0';
    variable Tviol_DIA9_CLKA_posedge    : std_ulogic := '0';
    variable Tviol_DIA10_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA11_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA12_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA13_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA14_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA15_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA16_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA17_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA18_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA19_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA20_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA21_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA22_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA23_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA24_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA25_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA26_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA27_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA28_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA29_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA30_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIA31_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIPA0_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIPA1_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIPA2_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_DIPA3_CLKA_posedge   : std_ulogic := '0';
    variable Tviol_ENA_CLKA_posedge     : std_ulogic := '0';
    variable Tviol_GSR_CLKA_posedge     : std_ulogic := '0';
    variable Tviol_SSRA_CLKA_posedge    : std_ulogic := '0';
    variable Tviol_WEA0_CLKA_posedge    : std_ulogic := '0';
    variable Tviol_WEA1_CLKA_posedge    : std_ulogic := '0';
    variable Tviol_WEA2_CLKA_posedge    : std_ulogic := '0';
    variable Tviol_WEA3_CLKA_posedge    : std_ulogic := '0';

    variable Tviol_ADDRB0_CLKB_posedge  : std_ulogic := '0';
    variable Tviol_ADDRB1_CLKB_posedge  : std_ulogic := '0';
    variable Tviol_ADDRB2_CLKB_posedge  : std_ulogic := '0';
    variable Tviol_ADDRB3_CLKB_posedge  : std_ulogic := '0';
    variable Tviol_ADDRB4_CLKB_posedge  : std_ulogic := '0';
    variable Tviol_ADDRB5_CLKB_posedge  : std_ulogic := '0';
    variable Tviol_ADDRB6_CLKB_posedge  : std_ulogic := '0';
    variable Tviol_ADDRB7_CLKB_posedge  : std_ulogic := '0';
    variable Tviol_ADDRB8_CLKB_posedge  : std_ulogic := '0';
    variable Tviol_ADDRB9_CLKB_posedge  : std_ulogic := '0';
    variable Tviol_ADDRB10_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB11_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB12_CLKB_posedge : std_ulogic := '0';
    variable Tviol_ADDRB13_CLKB_posedge : std_ulogic := '0';
    variable Tviol_DIB0_CLKB_posedge    : std_ulogic := '0';
    variable Tviol_DIB1_CLKB_posedge    : std_ulogic := '0';
    variable Tviol_DIB2_CLKB_posedge    : std_ulogic := '0';
    variable Tviol_DIB3_CLKB_posedge    : std_ulogic := '0';
    variable Tviol_DIB4_CLKB_posedge    : std_ulogic := '0';
    variable Tviol_DIB5_CLKB_posedge    : std_ulogic := '0';
    variable Tviol_DIB6_CLKB_posedge    : std_ulogic := '0';
    variable Tviol_DIB7_CLKB_posedge    : std_ulogic := '0';
    variable Tviol_DIB8_CLKB_posedge    : std_ulogic := '0';
    variable Tviol_DIB9_CLKB_posedge    : std_ulogic := '0';
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
    variable Tviol_ENB_CLKB_posedge     : std_ulogic := '0';
    variable Tviol_GSR_CLKB_posedge     : std_ulogic := '0';
    variable Tviol_SSRB_CLKB_posedge    : std_ulogic := '0';
    variable Tviol_WEB0_CLKB_posedge    : std_ulogic := '0';
    variable Tviol_WEB1_CLKB_posedge    : std_ulogic := '0';
    variable Tviol_WEB2_CLKB_posedge    : std_ulogic := '0';
    variable Tviol_WEB3_CLKB_posedge    : std_ulogic := '0';

    variable Tviol_CLKA_CLKB_all        : std_ulogic := '0';
    variable Tviol_CLKA_CLKB_read_first : std_ulogic := '0';
    variable Tviol_CLKB_CLKA_all        : std_ulogic := '0';
    variable Tviol_CLKB_CLKA_read_first : std_ulogic := '0';

    variable Tmkr_ADDRA0_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA1_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA2_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA3_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA4_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA5_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA6_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA7_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA8_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA9_CLKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA10_CLKA_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA11_CLKA_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA12_CLKA_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRA13_CLKA_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA0_CLKA_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA1_CLKA_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA2_CLKA_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA3_CLKA_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA4_CLKA_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA5_CLKA_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA6_CLKA_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA7_CLKA_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA8_CLKA_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA9_CLKA_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA10_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA11_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA12_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA13_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA14_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA15_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA16_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA17_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA18_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA19_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA20_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA21_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA22_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA23_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA24_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA25_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA26_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA27_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA28_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA29_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA30_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIA31_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIPA0_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIPA1_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIPA2_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIPA3_CLKA_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ENA_CLKA_posedge      : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_GSR_CLKA_posedge      : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_SSRA_CLKA_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_WEA0_CLKA_posedge      : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_WEA1_CLKA_posedge      : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_WEA2_CLKA_posedge      : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_WEA3_CLKA_posedge      : VitalTimingDataType := VitalTimingDataInit;

    variable Tmkr_ADDRB0_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB1_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB2_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB3_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB4_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB5_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB6_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB7_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB8_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB9_CLKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB10_CLKB_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB11_CLKB_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB12_CLKB_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ADDRB13_CLKB_posedge  : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB0_CLKB_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB1_CLKB_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB2_CLKB_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB3_CLKB_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB4_CLKB_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB5_CLKB_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB6_CLKB_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB7_CLKB_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB8_CLKB_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB9_CLKB_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB10_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB11_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB12_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB13_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB14_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB15_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB16_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB17_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB18_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB19_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB20_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB21_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB22_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB23_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB24_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB25_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB26_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB27_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB28_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB29_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB30_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIB31_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIPB0_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIPB1_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIPB2_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DIPB3_CLKB_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ENB_CLKB_posedge      : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_GSR_CLKB_posedge      : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_SSRB_CLKB_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_WEB0_CLKB_posedge      : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_WEB1_CLKB_posedge      : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_WEB2_CLKB_posedge      : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_WEB3_CLKB_posedge      : VitalTimingDataType := VitalTimingDataInit;

    variable Tmkr_CLKA_CLKB_all        : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_CLKA_CLKB_read_first : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_CLKB_CLKA_all        : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_CLKB_CLKA_read_first : VitalTimingDataType := VitalTimingDataInit;

    variable PViol_GSR : std_ulogic          := '0';
    variable PInfo_GSR : VitalPeriodDataType := VitalPeriodDataInit;

    variable PViol_CLKA, PViol_CLKB : std_ulogic          := '0';
    variable PInfo_CLKA, PInfo_CLKB : VitalPeriodDataType := VitalPeriodDataInit;


    variable MEM : std_logic_vector(18431 downto 0) := To_StdLogicVector(INITP_07) &
                                                       To_StdLogicVector(INITP_06) &
                                                       To_StdLogicVector(INITP_05) &
                                                       To_StdLogicVector(INITP_04) &
                                                       To_StdLogicVector(INITP_03) &
                                                       To_StdLogicVector(INITP_02) &
                                                       To_StdLogicVector(INITP_01) &
                                                       To_StdLogicVector(INITP_00) & 

                                                       To_StdLogicVector(INIT_3F)  &
                                                       To_StdLogicVector(INIT_3E)  &
                                                       To_StdLogicVector(INIT_3D)  &
                                                       To_StdLogicVector(INIT_3C)  &
                                                       To_StdLogicVector(INIT_3B)  &
                                                       To_StdLogicVector(INIT_3A)  &
                                                       To_StdLogicVector(INIT_39)  &
                                                       To_StdLogicVector(INIT_38)  &
                                                       To_StdLogicVector(INIT_37)  &
                                                       To_StdLogicVector(INIT_36)  &
                                                       To_StdLogicVector(INIT_35)  &
                                                       To_StdLogicVector(INIT_34)  &
                                                       To_StdLogicVector(INIT_33)  &
                                                       To_StdLogicVector(INIT_32)  &
                                                       To_StdLogicVector(INIT_31)  &
                                                       To_StdLogicVector(INIT_30)  &
                                                       To_StdLogicVector(INIT_2F)  &
                                                       To_StdLogicVector(INIT_2E)  &
                                                       To_StdLogicVector(INIT_2D)  &
                                                       To_StdLogicVector(INIT_2C)  &
                                                       To_StdLogicVector(INIT_2B)  &
                                                       To_StdLogicVector(INIT_2A)  &
                                                       To_StdLogicVector(INIT_29)  &
                                                       To_StdLogicVector(INIT_28)  &
                                                       To_StdLogicVector(INIT_27)  &
                                                       To_StdLogicVector(INIT_26)  &
                                                       To_StdLogicVector(INIT_25)  &
                                                       To_StdLogicVector(INIT_24)  &
                                                       To_StdLogicVector(INIT_23)  &
                                                       To_StdLogicVector(INIT_22)  &
                                                       To_StdLogicVector(INIT_21)  &
                                                       To_StdLogicVector(INIT_20)  &
                                                       To_StdLogicVector(INIT_1F)  &
                                                       To_StdLogicVector(INIT_1E)  &
                                                       To_StdLogicVector(INIT_1D)  &
                                                       To_StdLogicVector(INIT_1C)  &
                                                       To_StdLogicVector(INIT_1B)  &
                                                       To_StdLogicVector(INIT_1A)  &
                                                       To_StdLogicVector(INIT_19)  &
                                                       To_StdLogicVector(INIT_18)  &
                                                       To_StdLogicVector(INIT_17)  &
                                                       To_StdLogicVector(INIT_16)  &
                                                       To_StdLogicVector(INIT_15)  &
                                                       To_StdLogicVector(INIT_14)  &
                                                       To_StdLogicVector(INIT_13)  &
                                                       To_StdLogicVector(INIT_12)  &
                                                       To_StdLogicVector(INIT_11)  &
                                                       To_StdLogicVector(INIT_10)  &
                                                       To_StdLogicVector(INIT_0F)  &
                                                       To_StdLogicVector(INIT_0E)  &
                                                       To_StdLogicVector(INIT_0D)  &
                                                       To_StdLogicVector(INIT_0C)  &
                                                       To_StdLogicVector(INIT_0B)  &
                                                       To_StdLogicVector(INIT_0A)  &
                                                       To_StdLogicVector(INIT_09)  &
                                                       To_StdLogicVector(INIT_08)  &
                                                       To_StdLogicVector(INIT_07)  &
                                                       To_StdLogicVector(INIT_06)  &
                                                       To_StdLogicVector(INIT_05)  &
                                                       To_StdLogicVector(INIT_04)  &
                                                       To_StdLogicVector(INIT_03)  &
                                                       To_StdLogicVector(INIT_02)  &
                                                       To_StdLogicVector(INIT_01)  &
                                                       To_StdLogicVector(INIT_00) ;
 
    variable INI_A         : std_logic_vector (35 downto 0) := (others => 'X');
    variable INI_A_UNBOUND : std_logic_vector (INIT_A'length-1 downto 0);
    variable INI_B         : std_logic_vector (35 downto 0) := (others => 'X');
    variable INI_B_UNBOUND : std_logic_vector (INIT_B'length-1 downto 0);

    variable DIAW              : integer;
    variable DIAW_1            : integer;
    variable DIBW              : integer;
    variable DIBW_1            : integer;
    variable DIPAW             : integer;
    variable DIPAW_1           : integer;
    variable DIPBW             : integer;
    variable DIPBW_1           : integer;

    variable DOAW              : integer;
    variable DOAW_1            : integer;
    variable DOBW              : integer;
    variable DOBW_1            : integer;
    variable DOPAW             : integer;
    variable DOPAW_1           : integer;
    variable DOPBW             : integer;
    variable DOPBW_1           : integer;

    variable ADDRA_dly_sampled : std_logic_vector(MAX_ADDR downto 0)   := (others => 'X');
    variable ADDRB_dly_sampled : std_logic_vector(MAX_ADDR downto 0)   := (others => 'X');
    variable ADDRESS_A         : integer;
    variable ADDRESS_B         : integer;

    variable ADDRESS_READ_A, ADDRESS_WRITE_A, ADDRESS_READ_B, ADDRESS_WRITE_B : integer;
    variable ADDRESS_PARITY_READ_A, ADDRESS_PARITY_WRITE_A, ADDRESS_PARITY_READ_B, ADDRESS_PARITY_WRITE_B : integer;

    variable DOA_INDEX, DOPA_INDEX : integer := -1;
    variable DOB_INDEX, DOPB_INDEX : integer := -1;

    variable DOA_OV_LSB        : integer;
    variable DOA_OV_MSB        : integer;
    variable DOA_zd            : std_logic_vector(MAX_DI downto 0)  := INI_A(MAX_DI downto 0);
    variable DOA_zd_buf        : std_logic_vector(MAX_DI downto 0)  := INI_A(MAX_DI downto 0);
    variable DOB_OV_LSB        : integer;
    variable DOB_OV_MSB        : integer;
    variable DOB_zd            : std_logic_vector(MAX_DI downto 0)  := INI_B(MAX_DI downto 0);
    variable DOB_zd_buf        : std_logic_vector(MAX_DI downto 0)  := INI_B(MAX_DI downto 0);
    variable DOPA_OV_LSB       : integer;
    variable DOPA_OV_MSB       : integer;
    variable DOPA_zd           : std_logic_vector(3 downto 0)   := INI_A(35 downto 32);
    variable DOPA_zd_buf       : std_logic_vector(3 downto 0)   := INI_A(35 downto 32);
    variable DOPB_OV_LSB       : integer;
    variable DOPB_OV_MSB       : integer;
    variable DOPB_zd           : std_logic_vector(3 downto 0)   := INI_B(35 downto 32);
    variable DOPB_zd_buf       : std_logic_vector(3 downto 0)   := INI_B(35 downto 32);
    variable ENA_dly_sampled   : std_ulogic                      := 'X';
    variable ENB_dly_sampled   : std_ulogic                      := 'X';
    variable FIRST_TIME        : boolean                        := true;
    variable HAS_OVERLAP       : boolean                        := false;
    variable HAS_OVERLAP_P     : boolean                        := false;
    variable OLPP_LSB          : integer;
    variable OLPP_MSB          : integer;
    variable OLP_LSB           : integer;
    variable OLP_MSB           : integer;
    variable SRVA_A            : std_logic_vector (35 downto 0) := (others => 'X');
    variable SRVA_A_UNBOUND    : std_logic_vector (SRVAL_A'length-1 downto 0);
    variable SRVA_B            : std_logic_vector (35 downto 0) := (others => 'X');
    variable SRVA_B_UNBOUND    : std_logic_vector (SRVAL_B'length-1 downto 0);
    variable SSRA_dly_sampled  : std_ulogic                      := 'X';
    variable SSRB_dly_sampled  : std_ulogic                      := 'X';
    variable VALID_ADDRA       : boolean                        := true;
    variable VALID_ADDRB       : boolean                        := true;
    variable ViolationA        : std_ulogic                     := '0';
    variable ViolationB        : std_ulogic                     := '0';
    variable ViolationCLKAB    : std_ulogic                     := '0';
    variable ViolationCLKAB_S0 : boolean                        := false;
    variable Violation_S1      : boolean                        := false;
    variable Violation_S3      : boolean                        := false;
    variable WEA_dly_sampled   : std_logic_vector(MAX_WE downto 0) := (others => 'X');
    variable WEB_dly_sampled   : std_logic_vector(MAX_WE downto 0) := (others => 'X');
    variable wr_mode_a         : std_logic_vector(1 downto 0)   := "00";
    variable wr_mode_b         : std_logic_vector(1 downto 0)   := "00";

--FP
    variable wea_index          : integer                       := -1;
    variable web_index          : integer                       := -1;

    variable tmp_we                  : std_logic_vector(1 downto 0)             := (others => '1');
    variable xout_we_seg1            : std_logic_vector(1 downto 0)             := (others => '0');
    variable xout_we_seg2            : std_logic_vector(1 downto 0)             := (others => '0');

    variable tmp_zero_write_a        : std_logic_vector(MAX_ADDR downto 0)      := (others => '1');
    variable tmp_zero_read_a         : std_logic_vector(MAX_ADDR downto 0)      := (others => '1');
    variable tmp_zero_parity_write_a : std_logic_vector((MAX_ADDR-3) downto 0)  := (others => '0');
    variable tmp_zero_parity_read_a  : std_logic_vector((MAX_ADDR-3) downto 0)  := (others => '0');

    variable tmp_zero_write_b        : std_logic_vector(MAX_ADDR downto 0)      := (others => '1');
    variable tmp_zero_read_b         : std_logic_vector(MAX_ADDR downto 0)      := (others => '1');
    variable tmp_zero_parity_write_b : std_logic_vector((MAX_ADDR-3) downto 0)  := (others => '0');
    variable tmp_zero_parity_read_b  : std_logic_vector((MAX_ADDR-3) downto 0)  := (others => '0');

    variable zero_write_a        : std_logic_vector(MAX_ADDR downto 0)      := (others => '1');
    variable zero_read_a         : std_logic_vector(MAX_ADDR downto 0)      := (others => '1');
    variable zero_parity_write_a : std_logic_vector((MAX_ADDR-3) downto 0)  := (others => '1');
    variable zero_parity_read_a  : std_logic_vector((MAX_ADDR-3) downto 0)  := (others => '1');

    variable zero_write_b        : std_logic_vector(MAX_ADDR downto 0)      := (others => '1');
    variable zero_read_b         : std_logic_vector(MAX_ADDR downto 0)      := (others => '1');
    variable zero_parity_write_b : std_logic_vector((MAX_ADDR-3) downto 0)  := (others => '1');
    variable zero_parity_read_b  : std_logic_vector((MAX_ADDR-3) downto 0)  := (others => '1');


    variable addra_in_14 : std_ulogic := '0';
    variable addrb_in_14 : std_ulogic := '0';

    variable SimCollisionCheck_var : integer := 3;
    variable collision_clka_clkb   : integer := 0;
    variable addr_overlap          : boolean := false;

    variable CLKA_time             : time := 0 ps;
    variable CLKB_time             : time := 0 ps;

    variable DOA_clsn              : std_logic_vector(31 downto 0) := (others => '0');
    variable DOPA_clsn             : std_logic_vector(3 downto 0) := (others => '0');
    variable DOA_clsn_sav          : std_logic_vector(31 downto 0) := (others => '0');
    variable DOPA_clsn_sav         : std_logic_vector(3 downto 0) := (others => '0');
    variable DOA_clsn_zero         : std_logic_vector(31 downto 0) := (others => '0');
    variable DOPA_clsn_zero        : std_logic_vector(3 downto 0) := (others => '0');

    variable DOB_clsn              : std_logic_vector(31 downto 0) := (others => '0');
    variable DOPB_clsn             : std_logic_vector(3 downto 0) := (others => '0');
    variable DOB_clsn_sav          : std_logic_vector(31 downto 0) := (others => '0');
    variable DOPB_clsn_sav         : std_logic_vector(3 downto 0) := (others => '0');
    variable DOB_clsn_zero         : std_logic_vector(31 downto 0) := (others => '0');
    variable DOPB_clsn_zero        : std_logic_vector(3 downto 0) := (others => '0');

    variable DOA_clsn_slice        : std_logic_vector(31 downto 0) := (others => '0');
    variable DOPA_clsn_slice       : std_logic_vector(3 downto 0) := (others => '0');
    variable DOB_clsn_slice        : std_logic_vector(31 downto 0) := (others => '0');
    variable DOPB_clsn_slice       : std_logic_vector(3 downto 0) := (others => '0');

    variable tmp_membuf            : std_logic_vector(31 downto 0) := (others => '0');

    variable DOA_clsn_read_index, DOPA_clsn_read_index : integer := -1;
    variable DOB_clsn_read_index, DOPB_clsn_read_index : integer := -1;

    variable DOA_clsn_write_index, DOPA_clsn_write_index : integer := -1;
    variable DOB_clsn_write_index, DOPB_clsn_write_index : integer := -1;

    variable clsn_type       : CollisionFlagType;
    variable data_widths     : DataWidthType;
    variable clsn_xbufs      : ClsnXbufType;

    variable collision_msg   : memory_collision_type;


    variable msg_addr1       : std_logic_vector(MAX_ADDR downto 0)      := (others => '0');
    variable msg_addr2       : std_logic_vector(MAX_ADDR downto 0)      := (others => '0');

  begin


    if (FIRST_TIME) then

      DIPAW   := 0;
      DIPAW_1 := -1;
      DIPBW   := 0;
      DIPBW_1 := -1;

      DOPAW   := 0;
      DOPAW_1 := -1;
      DOPBW   := 0;
      DOPBW_1 := -1;

      case DATA_WIDTH_A is

            when 0 =>
                 DOAW    := 1;
                 DOAW_1  := DOAW -1;
                 DIAW    := 1;
                 DIAW_1  := DIAW -1;

            when 1 =>
                 zero_read_a(13 downto 0) := (others => '1');
                 DOAW    := 1;
                 DOAW_1  := DOAW -1;
                 zero_write_a(13 downto 0) := (others => '1');
                 DIAW    := 1;
                 DIAW_1  := DIAW -1;

            when 2 =>
                 zero_read_a(0 downto 0) := (others => '0');
                 DOAW    := 2;
                 DOAW_1  := DOAW -1;
                 zero_write_a(0 downto 0) := (others => '0');
                 DIAW    := 2;
                 DIAW_1  := DIAW -1;

            when 4 =>
                 zero_read_a(1 downto 0) := (others => '0');
                 DOAW    := 4;
                 DOAW_1  := DOAW -1;
                 zero_write_a(1 downto 0) := (others => '0');
                 DIAW    := 4;
                 DIAW_1  := DIAW -1;

            when 9 =>
                 zero_read_a(2 downto 0) := (others => '0');
                 DOAW    := 8;
                 DOAW_1  := DOAW -1;
                 DOPAW   := 1;
                 DOPAW_1 := DOPAW -1;
                 zero_write_a(2 downto 0) := (others => '0');
                 DIAW    := 8;
                 DIAW_1  := DIAW -1;
                 DIPAW   := 1;
                 DIPAW_1 := DIPAW -1;

            when 18  =>
                 zero_read_a(3 downto 0) := (others => '0');
                 zero_parity_read_a(0 downto 0) := (others => '0');
                 DOAW    := 16;
                 DOAW_1  := DOAW -1;
                 DOPAW   := 2;
                 DOPAW_1 := DOPAW -1;
                 zero_write_a(3 downto 0) := (others => '0');
                 zero_parity_write_a(0 downto 0) := (others => '0');
                 DIAW    := 16;
                 DIAW_1  := DIAW -1;
                 DIPAW   := 2;
                 DIPAW_1 := DIPAW -1;

            when 36  =>
                 zero_read_a(4 downto 0) := (others => '0');
                 zero_parity_read_a(1 downto 0) := (others => '0');
                 DOAW    := 32;
                 DOAW_1  := DOAW -1;
                 DOPAW   := 4;
                 DOPAW_1 := DOPAW -1;
                 zero_write_a(4 downto 0) := (others => '0');
                 zero_parity_write_a(1 downto 0) := (others => '0');
                 DIAW    := 32;
                 DIAW_1  := DIAW -1;
                 DIPAW   := 4;
                 DIPAW_1 := DIPAW -1;

            when others =>
                 null;

      end case;

      case DATA_WIDTH_B is

            when 0 =>
                 DOBW    := 1;
                 DOBW_1  := DOBW -1;
                 DIBW    := 1;
                 DIBW_1  := DIBW -1;

            when 1 =>
                 zero_read_b(13 downto 0) := (others => '1');
                 DOBW    := 1;
                 DOBW_1  := DOBW -1;
                 zero_write_b(13 downto 0) := (others => '1');
                 DIBW    := 1;
                 DIBW_1  := DIBW -1;

            when 2 =>
                 zero_read_b(0 downto 0) := (others => '0');
                 DOBW    := 2;
                 DOBW_1  := DOBW -1;
                 zero_write_b(0 downto 0) := (others => '0');
                 DIBW    := 2;
                 DIBW_1  := DIBW -1;

            when 4 =>
                 zero_read_b(1 downto 0) := (others => '0');
                 DOBW    := 4;
                 DOBW_1  := DOBW -1;
                 zero_write_b(1 downto 0) := (others => '0');
                 DIBW    := 4;
                 DIBW_1  := DIBW -1;

            when 9 =>
                 zero_read_b(2 downto 0) := (others => '0');
                 DOBW    := 8;
                 DOBW_1  := DOBW -1;
                 DOPBW   := 1;
                 DOPBW_1 := DOPBW -1;
                 zero_write_b(2 downto 0) := (others => '0');
                 DIBW    := 8;
                 DIBW_1  := DIBW -1;
                 DIPBW   := 1;
                 DIPBW_1 := DIPBW -1;

            when 18  =>
                 zero_read_b(3 downto 0) := (others => '0');
                 zero_parity_read_b(0 downto 0) := (others => '0');
                 DOBW    := 16;
                 DOBW_1  := DOBW -1;
                 DOPBW   := 2;
                 DOPBW_1 := DOPBW -1;
                 zero_write_b(3 downto 0) := (others => '0');
                 zero_parity_write_b(0 downto 0) := (others => '0');
                 DIBW    := 16;
                 DIBW_1  := DIBW -1;
                 DIPBW   := 2;
                 DIPBW_1 := DIPBW -1;

            when 36  =>
                 zero_read_b(4 downto 0) := (others => '0');
                 zero_parity_read_b(1 downto 0) := (others => '0');
                 DOBW    := 32;
                 DOBW_1  := DOBW -1;
                 DOPBW   := 4;
                 DOPBW_1 := DOPBW -1;
                 zero_write_b(4 downto 0) := (others => '0');
                 zero_parity_write_b(1 downto 0) := (others => '0');
                 DIBW    := 32;
                 DIBW_1  := DIBW -1;
                 DIPBW   := 4;
                 DIPBW_1 := DIPBW -1;

            when others =>
                 null;

      end case;

      if (INIT_A'length > 36) then
        INI_A_UNBOUND(INIT_A'length-1 downto 0) := To_StdLogicVector(INIT_A );
        INI_A(35 downto 0)                      := INI_A_UNBOUND(35 downto 0);
      elsif (INIT_A'length < 36) then
        INI_A(INIT_A'length-1 downto 0)         := To_StdLogicVector(INIT_A );
      elsif (INIT_A'length = 36) then
        INI_A(INIT_A'length-1 downto 0)         := To_StdLogicVector(INIT_A );
      end if;

      if (INIT_B'length > 36) then
        INI_B_UNBOUND(INIT_B'length-1 downto 0) := To_StdLogicVector(INIT_B );
        INI_B(35 downto 0)                      := INI_B_UNBOUND(35 downto 0);
      elsif (INIT_B'length < 36) then
        INI_B(INIT_B'length-1 downto 0)         := To_StdLogicVector(INIT_B );
      elsif (INIT_B'length = 36) then
        INI_B(INIT_B'length-1 downto 0)         := To_StdLogicVector(INIT_B );
      end if;

      if (SRVAL_A'length > 36) then
        SRVA_A_UNBOUND(SRVAL_A'length-1 downto 0) := To_StdLogicVector(SRVAL_A );
        SRVA_A(35 downto 0)                       := SRVA_A_UNBOUND(35 downto 0);
      elsif (SRVAL_A'length < 36) then
        SRVA_A(SRVAL_A'length-1 downto 0)         := To_StdLogicVector(SRVAL_A );
      elsif (SRVAL_A'length = 36) then
        SRVA_A(SRVAL_A'length-1 downto 0)         := To_StdLogicVector(SRVAL_A );
      end if;

      if (SRVAL_B'length > 36) then
        SRVA_B_UNBOUND(SRVAL_B'length-1 downto 0) := To_StdLogicVector(SRVAL_B );
        SRVA_B(35 downto 0)                       := SRVA_B_UNBOUND(35 downto 0);
      elsif (SRVAL_B'length < 36) then
        SRVA_B(SRVAL_B'length-1 downto 0)         := To_StdLogicVector(SRVAL_B );
      elsif (SRVAL_B'length = 36) then
        SRVA_B(SRVAL_B'length-1 downto 0)         := To_StdLogicVector(SRVAL_B );
      end if;

      if ((WRITE_MODE_A = "write_first") or (WRITE_MODE_A = "WRITE_FIRST")) then
        wr_mode_a := "00";
      elsif ((WRITE_MODE_A = "read_first") or (WRITE_MODE_A = "READ_FIRST")) then
        wr_mode_a := "01";
      elsif ((WRITE_MODE_A = "no_change") or (WRITE_MODE_A = "NO_CHANGE")) then
        wr_mode_a := "10";
      else
        GenericValueCheckMessage
          ( HeaderMsg            => " Attribute Syntax Error : ",
            GenericName          => " WRITE_MODE_A ",
            EntityName           => "/X_RAMB16BWE",
            GenericValue         => WRITE_MODE_A,
            Unit                 => "",
            ExpectedValueMsg     => " The Legal values for this attribute are ",
            ExpectedGenericValue => " WRITE_FIRST, READ_FIRST or NO_CHANGE ",
            TailMsg              => "",
            MsgSeverity          => error
            );
      end if;

      if ((WRITE_MODE_B = "write_first") or (WRITE_MODE_B = "WRITE_FIRST")) then
        wr_mode_b := "00";
      elsif ((WRITE_MODE_B = "read_first") or (WRITE_MODE_B = "READ_FIRST")) then
        wr_mode_b := "01";
      elsif ((WRITE_MODE_B = "no_change") or (WRITE_MODE_B = "NO_CHANGE")) then
        wr_mode_b := "10";
      else
        GenericValueCheckMessage
          ( HeaderMsg            => " Attribute Syntax Error : ",
            GenericName          => " WRITE_MODE_B ",
            EntityName           => "/X_RAMB16BWE",
            GenericValue         => WRITE_MODE_B,
            Unit                 => "",
            ExpectedValueMsg     => " The Legal values for this attribute are ",
            ExpectedGenericValue => " WRITE_FIRST, READ_FIRST or NO_CHANGE ",
            TailMsg              => "",
            MsgSeverity          => error
            );
      end if;

      if((SIM_COLLISION_CHECK = "ALL") or (SIM_COLLISION_CHECK = "all")) then
          SimCollisionCheck_var := 3;
      elsif((SIM_COLLISION_CHECK = "NONE") or (SIM_COLLISION_CHECK = "none")) then
          SimCollisionCheck_var := 0;
      elsif((SIM_COLLISION_CHECK = "WARNING_ONLY") or (SIM_COLLISION_CHECK = "warning_only")) then
          SimCollisionCheck_var := 1;
      elsif((SIM_COLLISION_CHECK = "GENERATE_X_ONLY") or (SIM_COLLISION_CHECK = "generate_x_only")) then
          SimCollisionCheck_var := 2;
     else
        GenericValueCheckMessage
         ( HeaderMsg            => " Attribute Syntax Error : ",
           GenericName          => " SIM_COLLISION_CHECK ",
           EntityName           => "/X_RAMB16BWE",
           GenericValue         => SIM_COLLISION_CHECK,
           Unit                 => "",
           ExpectedValueMsg     => " The Legal values for this attribute are ",
           ExpectedGenericValue => " ALL, NONE, WARNING_ONLY or GENERATE_X_ONLY ",
           TailMsg              => "",
           MsgSeverity          => error
           );
     end if;


      wait until (GSR_CLKA_dly = '1' or GSR_CLKB_dly = '1' or ((CLKA_dly = '0' or CLKA_dly = '1') or (CLKB_dly = '0' or CLKB_dly = '1')));
---################################################################################
        DOA_zd(DOAW_1 downto 0) := INI_A(DOAW_1 downto 0);
        DOB_zd(DOBW_1 downto 0) := INI_B(DOBW_1 downto 0);

        if(DOPAW_1 /= -1) then
           DOPA_zd(DOPAW_1 downto 0) := INI_A((DOPAW_1 + DOAW) downto DOAW);
        end if;

        if(DOPBW_1 /= -1) then
           DOPB_zd(DOPBW_1 downto 0) := INI_B((DOPBW_1 + DOBW) downto DOBW);
        end if;

----- Port A
--        DOA <= DOA_zd;
--        if(DOPAW_1 /= -1) then
--           DOPA <= DOPA_zd;
--        end if;

----- Port B
--        DOB <= DOB_zd;
--        if(DOPBW_1 /= -1) then
--           DOPB <= DOPB_zd;
--        end if;

      data_widths.diaw  := DIAW; 
      data_widths.dipaw := DIPAW; 
      data_widths.doaw  := DOAW; 
      data_widths.dopaw := DOPAW; 

      data_widths.dibw  := DIBW; 
      data_widths.dipbw := DIPBW; 
      data_widths.dobw  := DOBW; 
      data_widths.dopbw := DOPBW; 

      FIRST_TIME  := false;
    end if;
----------------  END FIRST_TIME

--    addra_in_14 := ADDRA_dly(14);

    if (CLKA_dly'event) then
      ENA_dly_sampled   := ENA_dly;
      SSRA_dly_sampled  := SSRA_dly;
      WEA_dly_sampled   := WEA_dly;
      ADDRA_dly_sampled := ADDRA_dly;
    end if;

-------------------------------------------------------------

--    addrb_in_14 := ADDRB_dly(14);

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
        HeaderMsg      => "/X_RAMB16BWE",
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
        HeaderMsg      => "/X_RAMB16BWE",
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
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
 -- FP
      VitalSetupHoldCheck (
        Violation      => Tviol_WEA0_CLKA_posedge,
        TimingData     => Tmkr_WEA0_CLKA_posedge,
        TestSignal     => WEA_dly(0),
        TestSignalName => "WEA(0)",
        TestDelay      => tisd_WEA_CLKA(0),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_WEA_CLKA_posedge_posedge(0),
        SetupLow       => tsetup_WEA_CLKA_negedge_posedge(0),
        HoldLow        => thold_WEA_CLKA_negedge_posedge(0),
        HoldHigh       => thold_WEA_CLKA_posedge_posedge(0),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_WEA1_CLKA_posedge,
        TimingData     => Tmkr_WEA1_CLKA_posedge,
        TestSignal     => WEA_dly(1),
        TestSignalName => "WEA(1)",
        TestDelay      => tisd_WEA_CLKA(1),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_WEA_CLKA_posedge_posedge(1),
        SetupLow       => tsetup_WEA_CLKA_negedge_posedge(1),
        HoldLow        => thold_WEA_CLKA_negedge_posedge(1),
        HoldHigh       => thold_WEA_CLKA_posedge_posedge(1),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_WEA2_CLKA_posedge,
        TimingData     => Tmkr_WEA2_CLKA_posedge,
        TestSignal     => WEA_dly(2),
        TestSignalName => "WEA(2)",
        TestDelay      => tisd_WEA_CLKA(2),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_WEA_CLKA_posedge_posedge(2),
        SetupLow       => tsetup_WEA_CLKA_negedge_posedge(2),
        HoldLow        => thold_WEA_CLKA_negedge_posedge(2),
        HoldHigh       => thold_WEA_CLKA_posedge_posedge(2),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_WEA3_CLKA_posedge,
        TimingData     => Tmkr_WEA3_CLKA_posedge,
        TestSignal     => WEA_dly(3),
        TestSignalName => "WEA(3)",
        TestDelay      => tisd_WEA_CLKA(3),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_WEA_CLKA_posedge_posedge(3),
        SetupLow       => tsetup_WEA_CLKA_negedge_posedge(3),
        HoldLow        => thold_WEA_CLKA_negedge_posedge(3),
        HoldHigh       => thold_WEA_CLKA_posedge_posedge(3),
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
        HeaderMsg      => "/X_RAMB16BWE",
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
        HeaderMsg      => "/X_RAMB16BWE",
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
        HeaderMsg      => "/X_RAMB16BWE",
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
        HeaderMsg      => "/X_RAMB16BWE",
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
        HeaderMsg      => "/X_RAMB16BWE",
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
        HeaderMsg      => "/X_RAMB16BWE",
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
        HeaderMsg      => "/X_RAMB16BWE",
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
        HeaderMsg      => "/X_RAMB16BWE",
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
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIPA0_CLKA_posedge,
        TimingData     => Tmkr_DIPA0_CLKA_posedge,
        TestSignal     => DIPA_dly(0),
        TestSignalName => "DIPA(0)",
        TestDelay      => tisd_DIPA_CLKA(0),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIPA_CLKA_posedge_posedge(0),
        SetupLow       => tsetup_DIPA_CLKA_negedge_posedge(0),
        HoldLow        => thold_DIPA_CLKA_negedge_posedge(0),
        HoldHigh       => thold_DIPA_CLKA_posedge_posedge(0),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIPA1_CLKA_posedge,
        TimingData     => Tmkr_DIPA1_CLKA_posedge,
        TestSignal     => DIPA_dly(1),
        TestSignalName => "DIPA(1)",
        TestDelay      => tisd_DIPA_CLKA(1),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIPA_CLKA_posedge_posedge(1),
        SetupLow       => tsetup_DIPA_CLKA_negedge_posedge(1),
        HoldLow        => thold_DIPA_CLKA_negedge_posedge(1),
        HoldHigh       => thold_DIPA_CLKA_posedge_posedge(1),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIPA2_CLKA_posedge,
        TimingData     => Tmkr_DIPA2_CLKA_posedge,
        TestSignal     => DIPA_dly(2),
        TestSignalName => "DIPA(2)",
        TestDelay      => tisd_DIPA_CLKA(2),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIPA_CLKA_posedge_posedge(2),
        SetupLow       => tsetup_DIPA_CLKA_negedge_posedge(2),
        HoldLow        => thold_DIPA_CLKA_negedge_posedge(2),
        HoldHigh       => thold_DIPA_CLKA_posedge_posedge(2),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIPA3_CLKA_posedge,
        TimingData     => Tmkr_DIPA3_CLKA_posedge,
        TestSignal     => DIPA_dly(3),
        TestSignalName => "DIPA(3)",
        TestDelay      => tisd_DIPA_CLKA(3),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIPA_CLKA_posedge_posedge(3),
        SetupLow       => tsetup_DIPA_CLKA_negedge_posedge(3),
        HoldLow        => thold_DIPA_CLKA_negedge_posedge(3),
        HoldHigh       => thold_DIPA_CLKA_posedge_posedge(3),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA4_CLKA_posedge,
        TimingData     => Tmkr_DIA4_CLKA_posedge,
        TestSignal     => DIA_dly(4),
        TestSignalName => "DIA(4)",
        TestDelay      => tisd_DIA_CLKA(4),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(4),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(4),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(4),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(4),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA5_CLKA_posedge,
        TimingData     => Tmkr_DIA5_CLKA_posedge,
        TestSignal     => DIA_dly(5),
        TestSignalName => "DIA(5)",
        TestDelay      => tisd_DIA_CLKA(5),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(5),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(5),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(5),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(5),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA6_CLKA_posedge,
        TimingData     => Tmkr_DIA6_CLKA_posedge,
        TestSignal     => DIA_dly(6),
        TestSignalName => "DIA(6)",
        TestDelay      => tisd_DIA_CLKA(6),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(6),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(6),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(6),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(6),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA7_CLKA_posedge,
        TimingData     => Tmkr_DIA7_CLKA_posedge,
        TestSignal     => DIA_dly(7),
        TestSignalName => "DIA(7)",
        TestDelay      => tisd_DIA_CLKA(7),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(7),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(7),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(7),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(7),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA8_CLKA_posedge,
        TimingData     => Tmkr_DIA8_CLKA_posedge,
        TestSignal     => DIA_dly(8),
        TestSignalName => "DIA(8)",
        TestDelay      => tisd_DIA_CLKA(8),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(8),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(8),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(8),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(8),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA9_CLKA_posedge,
        TimingData     => Tmkr_DIA9_CLKA_posedge,
        TestSignal     => DIA_dly(9),
        TestSignalName => "DIA(9)",
        TestDelay      => tisd_DIA_CLKA(9),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(9),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(9),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(9),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(9),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA10_CLKA_posedge,
        TimingData     => Tmkr_DIA10_CLKA_posedge,
        TestSignal     => DIA_dly(10),
        TestSignalName => "DIA(10)",
        TestDelay      => tisd_DIA_CLKA(10),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(10),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(10),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(10),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(10),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA11_CLKA_posedge,
        TimingData     => Tmkr_DIA11_CLKA_posedge,
        TestSignal     => DIA_dly(11),
        TestSignalName => "DIA(11)",
        TestDelay      => tisd_DIA_CLKA(11),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(11),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(11),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(11),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(11),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA12_CLKA_posedge,
        TimingData     => Tmkr_DIA12_CLKA_posedge,
        TestSignal     => DIA_dly(12),
        TestSignalName => "DIA(12)",
        TestDelay      => tisd_DIA_CLKA(12),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(12),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(12),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(12),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(12),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA13_CLKA_posedge,
        TimingData     => Tmkr_DIA13_CLKA_posedge,
        TestSignal     => DIA_dly(13),
        TestSignalName => "DIA(13)",
        TestDelay      => tisd_DIA_CLKA(13),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(13),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(13),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(13),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(13),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA14_CLKA_posedge,
        TimingData     => Tmkr_DIA14_CLKA_posedge,
        TestSignal     => DIA_dly(14),
        TestSignalName => "DIA(14)",
        TestDelay      => tisd_DIA_CLKA(14),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(14),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(14),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(14),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(14),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA15_CLKA_posedge,
        TimingData     => Tmkr_DIA15_CLKA_posedge,
        TestSignal     => DIA_dly(15),
        TestSignalName => "DIA(15)",
        TestDelay      => tisd_DIA_CLKA(15),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(15),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(15),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(15),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(15),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA16_CLKA_posedge,
        TimingData     => Tmkr_DIA16_CLKA_posedge,
        TestSignal     => DIA_dly(16),
        TestSignalName => "DIA(16)",
        TestDelay      => tisd_DIA_CLKA(16),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(16),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(16),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(16),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(16),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA17_CLKA_posedge,
        TimingData     => Tmkr_DIA17_CLKA_posedge,
        TestSignal     => DIA_dly(17),
        TestSignalName => "DIA(17)",
        TestDelay      => tisd_DIA_CLKA(17),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(17),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(17),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(17),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(17),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA18_CLKA_posedge,
        TimingData     => Tmkr_DIA18_CLKA_posedge,
        TestSignal     => DIA_dly(18),
        TestSignalName => "DIA(18)",
        TestDelay      => tisd_DIA_CLKA(18),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(18),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(18),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(18),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(18),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA19_CLKA_posedge,
        TimingData     => Tmkr_DIA19_CLKA_posedge,
        TestSignal     => DIA_dly(19),
        TestSignalName => "DIA(19)",
        TestDelay      => tisd_DIA_CLKA(19),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(19),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(19),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(19),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(19),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA20_CLKA_posedge,
        TimingData     => Tmkr_DIA20_CLKA_posedge,
        TestSignal     => DIA_dly(20),
        TestSignalName => "DIA(20)",
        TestDelay      => tisd_DIA_CLKA(20),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(20),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(20),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(20),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(20),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA21_CLKA_posedge,
        TimingData     => Tmkr_DIA21_CLKA_posedge,
        TestSignal     => DIA_dly(21),
        TestSignalName => "DIA(21)",
        TestDelay      => tisd_DIA_CLKA(21),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(21),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(21),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(21),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(21),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA22_CLKA_posedge,
        TimingData     => Tmkr_DIA22_CLKA_posedge,
        TestSignal     => DIA_dly(22),
        TestSignalName => "DIA(22)",
        TestDelay      => tisd_DIA_CLKA(22),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(22),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(22),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(22),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(22),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA23_CLKA_posedge,
        TimingData     => Tmkr_DIA23_CLKA_posedge,
        TestSignal     => DIA_dly(23),
        TestSignalName => "DIA(23)",
        TestDelay      => tisd_DIA_CLKA(23),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(23),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(23),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(23),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(23),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA24_CLKA_posedge,
        TimingData     => Tmkr_DIA24_CLKA_posedge,
        TestSignal     => DIA_dly(24),
        TestSignalName => "DIA(24)",
        TestDelay      => tisd_DIA_CLKA(24),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(24),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(24),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(24),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(24),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA25_CLKA_posedge,
        TimingData     => Tmkr_DIA25_CLKA_posedge,
        TestSignal     => DIA_dly(25),
        TestSignalName => "DIA(25)",
        TestDelay      => tisd_DIA_CLKA(25),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(25),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(25),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(25),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(25),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA26_CLKA_posedge,
        TimingData     => Tmkr_DIA26_CLKA_posedge,
        TestSignal     => DIA_dly(26),
        TestSignalName => "DIA(26)",
        TestDelay      => tisd_DIA_CLKA(26),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(26),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(26),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(26),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(26),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA27_CLKA_posedge,
        TimingData     => Tmkr_DIA27_CLKA_posedge,
        TestSignal     => DIA_dly(27),
        TestSignalName => "DIA(27)",
        TestDelay      => tisd_DIA_CLKA(27),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(27),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(27),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(27),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(27),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA28_CLKA_posedge,
        TimingData     => Tmkr_DIA28_CLKA_posedge,
        TestSignal     => DIA_dly(28),
        TestSignalName => "DIA(28)",
        TestDelay      => tisd_DIA_CLKA(28),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(28),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(28),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(28),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(28),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA29_CLKA_posedge,
        TimingData     => Tmkr_DIA29_CLKA_posedge,
        TestSignal     => DIA_dly(29),
        TestSignalName => "DIA(29)",
        TestDelay      => tisd_DIA_CLKA(29),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(29),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(29),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(29),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(29),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA30_CLKA_posedge,
        TimingData     => Tmkr_DIA30_CLKA_posedge,
        TestSignal     => DIA_dly(30),
        TestSignalName => "DIA(30)",
        TestDelay      => tisd_DIA_CLKA(30),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(30),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(30),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(30),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(30),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_DIA31_CLKA_posedge,
        TimingData     => Tmkr_DIA31_CLKA_posedge,
        TestSignal     => DIA_dly(31),
        TestSignalName => "DIA(31)",
        TestDelay      => tisd_DIA_CLKA(31),
        RefSignal      => CLKA_dly,
        RefSignalName  => "CLKA",
        RefDelay       => ticd_CLKA,
        SetupHigh      => tsetup_DIA_CLKA_posedge_posedge(31),
        SetupLow       => tsetup_DIA_CLKA_negedge_posedge(31),
        HoldLow        => thold_DIA_CLKA_negedge_posedge(31),
        HoldHigh       => thold_DIA_CLKA_posedge_posedge(31),
--        CheckEnabled   => (TO_X01(ena_dly_sampled) = '1' and TO_X01(wea_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(ena_dly_sampled)    = '1' and
                           TO_X01(wea_dly_sampled(0)) = '1' and
                           TO_X01(wea_dly_sampled(1)) = '1' and
                           TO_X01(wea_dly_sampled(2)) = '1' and
                           TO_X01(wea_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
        HeaderMsg      => "/X_RAMB16BWE",
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
        HeaderMsg      => "/X_RAMB16BWE",
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
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_WEB0_CLKB_posedge,
        TimingData     => Tmkr_WEB0_CLKB_posedge,
        TestSignal     => WEB_dly(0),
        TestSignalName => "WEB(0)",
        TestDelay      => tisd_WEB_CLKB(0),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_WEB_CLKB_posedge_posedge(0),
        SetupLow       => tsetup_WEB_CLKB_negedge_posedge(0),
        HoldLow        => thold_WEB_CLKB_negedge_posedge(0),
        HoldHigh       => thold_WEB_CLKB_posedge_posedge(0),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_WEB1_CLKB_posedge,
        TimingData     => Tmkr_WEB1_CLKB_posedge,
        TestSignal     => WEB_dly(1),
        TestSignalName => "WEB(1)",
        TestDelay      => tisd_WEB_CLKB(1),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_WEB_CLKB_posedge_posedge(1),
        SetupLow       => tsetup_WEB_CLKB_negedge_posedge(1),
        HoldLow        => thold_WEB_CLKB_negedge_posedge(1),
        HoldHigh       => thold_WEB_CLKB_posedge_posedge(1),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_WEB2_CLKB_posedge,
        TimingData     => Tmkr_WEB2_CLKB_posedge,
        TestSignal     => WEB_dly(2),
        TestSignalName => "WEB(2)",
        TestDelay      => tisd_WEB_CLKB(2),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_WEB_CLKB_posedge_posedge(2),
        SetupLow       => tsetup_WEB_CLKB_negedge_posedge(2),
        HoldLow        => thold_WEB_CLKB_negedge_posedge(2),
        HoldHigh       => thold_WEB_CLKB_posedge_posedge(2),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalSetupHoldCheck (
        Violation      => Tviol_WEB3_CLKB_posedge,
        TimingData     => Tmkr_WEB3_CLKB_posedge,
        TestSignal     => WEB_dly(3),
        TestSignalName => "WEB(3)",
        TestDelay      => tisd_WEB_CLKB(3),
        RefSignal      => CLKB_dly,
        RefSignalName  => "CLKB",
        RefDelay       => ticd_CLKB,
        SetupHigh      => tsetup_WEB_CLKB_posedge_posedge(3),
        SetupLow       => tsetup_WEB_CLKB_negedge_posedge(3),
        HoldLow        => thold_WEB_CLKB_negedge_posedge(3),
        HoldHigh       => thold_WEB_CLKB_posedge_posedge(3),
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
        HeaderMsg      => "/X_RAMB16BWE",
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
        HeaderMsg      => "/X_RAMB16BWE",
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
        HeaderMsg      => "/X_RAMB16BWE",
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
        HeaderMsg      => "/X_RAMB16BWE",
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
        HeaderMsg      => "/X_RAMB16BWE",
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
        HeaderMsg      => "/X_RAMB16BWE",
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
        HeaderMsg      => "/X_RAMB16BWE",
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
        HeaderMsg      => "/X_RAMB16BWE",
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
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
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
--        CheckEnabled   => (TO_X01(enb_dly_sampled) = '1' and TO_X01(web_dly_sampled) = '1'),
        CheckEnabled   => (TO_X01(enb_dly_sampled)    = '1' and
                           TO_X01(web_dly_sampled(0)) = '1' and
                           TO_X01(web_dly_sampled(1)) = '1' and
                           TO_X01(web_dly_sampled(2)) = '1' and
                           TO_X01(web_dly_sampled(3)) = '1'
                           ),
        RefTransition  => 'R',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalPeriodPulseCheck (
        Violation      => Pviol_CLKA,
        PeriodData     => PInfo_CLKA,
        TestSignal     => CLKA_dly,
        TestSignalName => "CLKA",
        TestDelay      => 0 ps,
        Period         => tperiod_clka_posedge,
        PulseWidthHigh => tpw_CLKA_posedge,
        PulseWidthLow  => tpw_CLKA_negedge,
        CheckEnabled   => TO_X01(ena_dly_sampled) = '1',
        HeaderMsg      => "/X_RAMB16BWE",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
      VitalPeriodPulseCheck (
        Violation      => Pviol_CLKB,
        PeriodData     => PInfo_CLKB,
        TestSignal     => CLKB_dly,
        TestSignalName => "CLKB",
        TestDelay      => 0 ps,
        Period         => tperiod_clkb_posedge,
        PulseWidthHigh => tpw_CLKB_posedge,
        PulseWidthLow  => tpw_CLKB_negedge,
        CheckEnabled   => TO_X01(enb_dly_sampled) = '1',
        HeaderMsg      => "/X_RAMB16BWE",
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
        HeaderMsg      => "/X_RAMB16BWE",
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
      Tviol_DIA0_CLKA_posedge or
      Tviol_DIA1_CLKA_posedge or
      Tviol_DIA2_CLKA_posedge or
      Tviol_DIA3_CLKA_posedge or
      Tviol_DIA4_CLKA_posedge or
      Tviol_DIA5_CLKA_posedge or
      Tviol_DIA6_CLKA_posedge or
      Tviol_DIA7_CLKA_posedge or
      Tviol_DIA8_CLKA_posedge or
      Tviol_DIA9_CLKA_posedge or
      Tviol_DIA10_CLKA_posedge or
      Tviol_DIA11_CLKA_posedge or
      Tviol_DIA12_CLKA_posedge or
      Tviol_DIA13_CLKA_posedge or
      Tviol_DIA14_CLKA_posedge or
      Tviol_DIA15_CLKA_posedge or
      Tviol_DIA16_CLKA_posedge or
      Tviol_DIA17_CLKA_posedge or
      Tviol_DIA18_CLKA_posedge or
      Tviol_DIA19_CLKA_posedge or
      Tviol_DIA20_CLKA_posedge or
      Tviol_DIA21_CLKA_posedge or
      Tviol_DIA22_CLKA_posedge or
      Tviol_DIA23_CLKA_posedge or
      Tviol_DIA24_CLKA_posedge or
      Tviol_DIA25_CLKA_posedge or
      Tviol_DIA26_CLKA_posedge or
      Tviol_DIA27_CLKA_posedge or
      Tviol_DIA28_CLKA_posedge or
      Tviol_DIA29_CLKA_posedge or
      Tviol_DIA30_CLKA_posedge or
      Tviol_DIA31_CLKA_posedge or
      Tviol_DIPA0_CLKA_posedge or
      Tviol_DIPA1_CLKA_posedge or
      Tviol_DIPA2_CLKA_posedge or
      Tviol_DIPA3_CLKA_posedge or
      Tviol_ENA_CLKA_posedge or
      Tviol_SSRA_CLKA_posedge or
      Tviol_WEA0_CLKA_posedge or
      Tviol_WEA1_CLKA_posedge or
      Tviol_WEA2_CLKA_posedge or
      Tviol_WEA3_CLKA_posedge or
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
      Tviol_WEB0_CLKB_posedge or
      Tviol_WEB1_CLKB_posedge or
      Tviol_WEB2_CLKB_posedge or
      Tviol_WEB3_CLKB_posedge or
      Pviol_CLKB ;


--------------------------------    A    ----------------------------------------
        tmp_zero_write_a  := (addra_dly_sampled(13 downto 0) and zero_write_a);
        ADDRESS_WRITE_A := SLV_TO_INT(tmp_zero_write_a);

        tmp_zero_read_a  := (addra_dly_sampled(13 downto 0) and zero_read_a);
        ADDRESS_READ_A  := SLV_TO_INT(tmp_zero_read_a);

        tmp_zero_parity_write_a(10 downto 0) := addra_dly_sampled( 13 downto 3) and zero_parity_write_a;
        ADDRESS_PARITY_WRITE_A := SLV_TO_INT(tmp_zero_parity_write_a);

        tmp_zero_parity_read_a(10 downto 0) := addra_dly_sampled( 13 downto 3) and zero_parity_read_a;
        ADDRESS_PARITY_READ_A := SLV_TO_INT(tmp_zero_parity_read_a);
--------------------------------    B    ----------------------------------------
        tmp_zero_write_b  := (addrb_dly_sampled(13 downto 0) and zero_write_b);
        ADDRESS_WRITE_B := SLV_TO_INT(tmp_zero_write_b);

        tmp_zero_read_b  := (addrb_dly_sampled(13 downto 0) and zero_read_b);
        ADDRESS_READ_B  := SLV_TO_INT(tmp_zero_read_b);

        tmp_zero_parity_write_b(10 downto 0) := addrb_dly_sampled( 13 downto 3) and zero_parity_write_b;
        ADDRESS_PARITY_WRITE_B := SLV_TO_INT(tmp_zero_parity_write_b);

        tmp_zero_parity_read_b(10 downto 0) := addrb_dly_sampled( 13 downto 3) and zero_parity_read_b;
        ADDRESS_PARITY_READ_B := SLV_TO_INT(tmp_zero_parity_read_b);


--    VALID_ADDRA           := ADDR_IS_VALID(addra_dly_sampled);
--    if (VALID_ADDRA) then
--    end if;

--    VALID_ADDRB           := ADDR_IS_VALID(addrb_dly_sampled);
--    if (VALID_ADDRB) then
--    end if;

--  DOA_INDEX /  DOPA_INDEX

    if(DIAW <= DOAW) then
       case DIAW is
          when 1 =>
             case DOAW is
                when 1  => DOA_INDEX := 0;
                when 2  => DOA_INDEX := SLV_TO_INT(tmp_zero_write_a(0 downto 0));
                when 4  => DOA_INDEX := SLV_TO_INT(tmp_zero_write_a(1 downto 0));
                when 8  => DOA_INDEX := SLV_TO_INT(tmp_zero_write_a(2 downto 0));
                when 16 => DOA_INDEX := SLV_TO_INT(tmp_zero_write_a(3 downto 0));
                when 32 => DOA_INDEX := SLV_TO_INT(tmp_zero_write_a(4 downto 0));
                when others => null;
             end case;

          when 2 =>
             case DOAW is
                when 2  => DOA_INDEX := 0;
                when 4  => DOA_INDEX := SLV_TO_INT(tmp_zero_write_a(1 downto 1));
                when 8  => DOA_INDEX := SLV_TO_INT(tmp_zero_write_a(2 downto 1));
                when 16 => DOA_INDEX := SLV_TO_INT(tmp_zero_write_a(3 downto 1));
                when 32 => DOA_INDEX := SLV_TO_INT(tmp_zero_write_a(4 downto 1));
                when others => null;
             end case;

          when 4 =>
             case DOAW is
                when 4  => DOA_INDEX := 0;
                when 8  => DOA_INDEX := SLV_TO_INT(tmp_zero_write_a(2 downto 2));
                when 16 => DOA_INDEX := SLV_TO_INT(tmp_zero_write_a(3 downto 2));
                when 32 => DOA_INDEX := SLV_TO_INT(tmp_zero_write_a(4 downto 2));
                when others => null;
             end case;

          when 8 =>
             case DOAW is
                when 8  => DOA_INDEX := 0;
                           DOPA_INDEX := 0;
                when 16 => DOA_INDEX := SLV_TO_INT(tmp_zero_write_a(3 downto 3));
                           DOPA_INDEX := SLV_TO_INT(tmp_zero_parity_write_a(0 downto 0));
                when 32 => DOA_INDEX := SLV_TO_INT(tmp_zero_write_a(4 downto 3));
                           DOPA_INDEX := SLV_TO_INT(tmp_zero_parity_write_a(1 downto 0));
                when others => null;
             end case;

          when 16 =>
             case DOAW is
                when 16 => DOA_INDEX := 0;
                           DOPA_INDEX := 0;
                when 32 => DOA_INDEX := SLV_TO_INT(tmp_zero_write_a(4 downto 4));
                           DOPA_INDEX := SLV_TO_INT(tmp_zero_parity_write_a(1 downto 1));
                when others => null;
             end case;

          when 32 =>
             case DOAW is
                when 32 => DOA_INDEX := 0;
                           DOPA_INDEX := 0;
                when others => null;
             end case;
       
          when others => null;
       end case;

    elsif(DIAW > DOAW) then
       case DOAW is
          when 1 =>
             case DIAW is
                when 2  => DOA_INDEX := SLV_TO_INT(tmp_zero_read_a(0 downto 0));
                when 4  => DOA_INDEX := SLV_TO_INT(tmp_zero_read_a(1 downto 0));
                when 8  => DOA_INDEX := SLV_TO_INT(tmp_zero_read_a(2 downto 0));
                when 16 => DOA_INDEX := SLV_TO_INT(tmp_zero_read_a(3 downto 0));
                when 32 => DOA_INDEX := SLV_TO_INT(tmp_zero_read_a(4 downto 0));
                when others => null;
             end case;
          when 2 =>
             case DIAW is
                when 4  => DOA_INDEX := SLV_TO_INT(tmp_zero_read_a(1 downto 1));
                when 8  => DOA_INDEX := SLV_TO_INT(tmp_zero_read_a(2 downto 1));
                when 16 => DOA_INDEX := SLV_TO_INT(tmp_zero_read_a(3 downto 1));
                when 32 => DOA_INDEX := SLV_TO_INT(tmp_zero_read_a(4 downto 1));
                when others => null;
             end case;

          when 4 =>
             case DIAW is
                when 8  => DOA_INDEX := SLV_TO_INT(tmp_zero_read_a(2 downto 2));
                when 16 => DOA_INDEX := SLV_TO_INT(tmp_zero_read_a(3 downto 2));
                when 32 => DOA_INDEX := SLV_TO_INT(tmp_zero_read_a(4 downto 2));
                when others => null;
             end case;
          when 8 =>
             case DIAW is
                when 16 => DOA_INDEX := SLV_TO_INT(tmp_zero_read_a(3 downto 3));
                           DOPA_INDEX := SLV_TO_INT(tmp_zero_parity_read_a(0 downto 0));
                when 32 => DOA_INDEX := SLV_TO_INT(tmp_zero_read_a(4 downto 3));
                           DOPA_INDEX := SLV_TO_INT(tmp_zero_parity_read_a(1 downto 0));
                when others => null;
             end case;

          when 16 =>
             case DIAW is
                when 32 => DOA_INDEX := SLV_TO_INT(tmp_zero_read_a(4 downto 4));
                           DOPA_INDEX := SLV_TO_INT(tmp_zero_parity_read_a(1 downto 1));
                when others => null;
             end case;

          when others => null;
       end case;
    end if;

--  DOB_INDEX /  DOPB_INDEX

    if(DIBW <= DOBW) then
       case DIBW is
          when 1 =>
             case DOBW is
                when 1  => DOB_INDEX := 0;
                when 2  => DOB_INDEX := SLV_TO_INT(tmp_zero_write_b(0 downto 0));
                when 4  => DOB_INDEX := SLV_TO_INT(tmp_zero_write_b(1 downto 0));
                when 8  => DOB_INDEX := SLV_TO_INT(tmp_zero_write_b(2 downto 0));
                when 16 => DOB_INDEX := SLV_TO_INT(tmp_zero_write_b(3 downto 0));
                when 32 => DOB_INDEX := SLV_TO_INT(tmp_zero_write_b(4 downto 0));
                when others => null;
             end case;

          when 2 =>
             case DOBW is
                when 2  => DOB_INDEX := 0;
                when 4  => DOB_INDEX := SLV_TO_INT(tmp_zero_write_b(1 downto 1));
                when 8  => DOB_INDEX := SLV_TO_INT(tmp_zero_write_b(2 downto 1));
                when 16 => DOB_INDEX := SLV_TO_INT(tmp_zero_write_b(3 downto 1));
                when 32 => DOB_INDEX := SLV_TO_INT(tmp_zero_write_b(4 downto 1));
                when others => null;
             end case;

          when 4 =>
             case DOBW is
                when 4  => DOB_INDEX := 0;
                when 8  => DOB_INDEX := SLV_TO_INT(tmp_zero_write_b(2 downto 2));
                when 16 => DOB_INDEX := SLV_TO_INT(tmp_zero_write_b(3 downto 2));
                when 32 => DOB_INDEX := SLV_TO_INT(tmp_zero_write_b(4 downto 2));
                when others => null;
             end case;

          when 8 =>
             case DOBW is
                when 8  => DOB_INDEX := 0;
                           DOPB_INDEX := 0;
                when 16 => DOB_INDEX := SLV_TO_INT(tmp_zero_write_b(3 downto 3));
                           DOPB_INDEX := SLV_TO_INT(tmp_zero_parity_write_b(0 downto 0));
                when 32 => DOB_INDEX := SLV_TO_INT(tmp_zero_write_b(4 downto 3));
                           DOPB_INDEX := SLV_TO_INT(tmp_zero_parity_write_b(1 downto 0));
                when others => null;
             end case;

          when 16 =>
             case DOBW is
                when 16 => DOB_INDEX := 0;
                           DOPB_INDEX := 0;
                when 32 => DOB_INDEX := SLV_TO_INT(tmp_zero_write_b(4 downto 4));
                           DOPB_INDEX := SLV_TO_INT(tmp_zero_parity_write_b(1 downto 1));
                when others => null;
             end case;

          when 32 =>
             case DOBW is
                when 32 => DOB_INDEX := 0;
                           DOPB_INDEX := 0;
                when others => null;
             end case;
       
          when others => null;
       end case;

    elsif(DIBW > DOBW) then
       case DOBW is
          when 1 =>
             case DIBW is
                when 2  => DOB_INDEX := SLV_TO_INT(tmp_zero_read_b(0 downto 0));
                when 4  => DOB_INDEX := SLV_TO_INT(tmp_zero_read_b(1 downto 0));
                when 8  => DOB_INDEX := SLV_TO_INT(tmp_zero_read_b(2 downto 0));
                when 16 => DOB_INDEX := SLV_TO_INT(tmp_zero_read_b(3 downto 0));
                when 32 => DOB_INDEX := SLV_TO_INT(tmp_zero_read_b(4 downto 0));
                when others => null;
             end case;
          when 2 =>
             case DIBW is
                when 4  => DOB_INDEX := SLV_TO_INT(tmp_zero_read_b(1 downto 1));
                when 8  => DOB_INDEX := SLV_TO_INT(tmp_zero_read_b(2 downto 1));
                when 16 => DOB_INDEX := SLV_TO_INT(tmp_zero_read_b(3 downto 1));
                when 32 => DOB_INDEX := SLV_TO_INT(tmp_zero_read_b(4 downto 1));
                when others => null;
             end case;

          when 4 =>
             case DIBW is
                when 8  => DOB_INDEX := SLV_TO_INT(tmp_zero_read_b(2 downto 2));
                when 16 => DOB_INDEX := SLV_TO_INT(tmp_zero_read_b(3 downto 2));
                when 32 => DOB_INDEX := SLV_TO_INT(tmp_zero_read_b(4 downto 2));
                when others => null;
             end case;
          when 8 =>
             case DIBW is
                when 16 => DOB_INDEX := SLV_TO_INT(tmp_zero_read_b(3 downto 3));
                           DOPB_INDEX := SLV_TO_INT(tmp_zero_parity_read_b(0 downto 0));
                when 32 => DOB_INDEX := SLV_TO_INT(tmp_zero_read_b(4 downto 3));
                           DOPB_INDEX := SLV_TO_INT(tmp_zero_parity_read_b(1 downto 0));
                when others => null;
             end case;

          when 16 =>
             case DIBW is
                when 32 => DOB_INDEX := SLV_TO_INT(tmp_zero_read_b(4 downto 4));
                           DOPB_INDEX := SLV_TO_INT(tmp_zero_parity_read_b(1 downto 1));
                when others => null;
             end case;

          when others => null;
       end case;
    end if;


----- ######################################################################################################

        if(rising_edge(CLKA_dly)) then
           CLKA_time := now;
        end if;

        if(rising_edge(CLKB_dly)) then
           CLKB_time := now;
        end if;


----- ######################################################################################################
------------------------------------------------------------------------                       
------------ Port A ----------------------------------------------------
------------------------------------------------------------------------                       
    if(GSR_CLKA_dly = '1') then
       DOA_zd(DOAW_1 downto 0) := INI_A(DOAW_1 downto 0);
       if(DOPAW_1 /= -1) then
         DOPA_zd(DOPAW_1 downto 0) := INI_A((DOPAW_1 + DOAW) downto DOAW);
       end if;
    elsif(CLKA_dly'event AND CLKA_dly'last_value = '0') then

        if (ena_dly_sampled = '1') then
            if (ssra_dly_sampled = '1') then
                   DOA_zd(DOAW_1 downto 0) := SRVA_A(DOAW_1 downto 0);
                   DOA_clsn_zero := (others => '0');
                   DOA_clsn := (others => '0');
                   if(DOPAW_1 /= -1) then
                      DOPA_zd(DOPAW_1 downto 0) := SRVA_A((DOPAW_1 + DOAW) downto DOAW);
                      DOPA_clsn_zero := (others => '0');
                      DOPA_clsn := (others => '0');
                   end if;
            else
-----------------------  Start COLLISION A ------------------------------

        if(SimCollisionCheck_var /= 0) then
           DOA_clsn_sav          := DOA_clsn;
           DOPA_clsn_sav         := DOPA_clsn;

           DOA_clsn              := (others => '0');
           DOPA_clsn             := (others => '0');
           clsn_xbufs.DO1_clsn   := (others => '0');
           clsn_xbufs.DOP1_clsn  := (others => '0');
           clsn_xbufs.MEM1_clsn  := (others => '0');
           clsn_xbufs.MEMP1_clsn := (others => '0');

           clsn_xbufs.DO2_clsn   := (others => '0');
           clsn_xbufs.DOP2_clsn  := (others => '0');
           clsn_xbufs.MEM2_clsn  := (others => '0');
           clsn_xbufs.MEMP2_clsn := (others => '0');
        
           clsn_type.active_port := 1;
           addr_overlap := false;
           clsn_type.read_write  := false;
           clsn_type.write_read  := false;
           clsn_type.write_write := false;

--           CLKA_time := now;

           ClkCollisionCheck(
              violation => collision_clka_clkb,
              CheckEnabled => ((TO_X01(ena_dly_sampled) = '1') and (TO_X01(enb_dly_sampled) = '1')), 
              CLK1_time => CLKA_time,
              CLK2_time => CLKB_time,
              SETUP_All => SETUP_ALL,
              SETUP_READ_FIRST => SETUP_READ_FIRST
           );

           if(collision_clka_clkb /= 0) then
              QkAddrOverlapChk(
                addr_overlap => addr_overlap,
                data_widths  => data_widths,
                addra        => addra_dly_sampled,
                addrb        => addrb_dly_sampled
              );
           end if;
        
           if(addr_overlap) then
              PreProcessWe1We2(
                clsn_bufs     => clsn_xbufs,
                clsn_type     => clsn_type,
                memory        => MEM,
                di1           => dia_dly,
                di2           => dib_dly,
                dip1          => dipa_dly,
                dip2          => dipb_dly,
                addr1         => addra_dly_sampled,
                addr2         => addrb_dly_sampled,
                we1           => wea_dly_sampled,
                we2           => web_dly_sampled,
                zero_read_1   => zero_read_a,
                zero_readp_1  => zero_parity_read_a,
                zero_write_1  => zero_write_a,
                zero_writep_1 => zero_parity_write_a,
                zero_read_2   => zero_read_b,
                zero_readp_2  => zero_parity_read_b,
                zero_write_2  => zero_write_b,
                zero_writep_2 => zero_parity_write_b,
                wr_mode_1     => wr_mode_a,
                wr_mode_2     => wr_mode_b,
                violation     => collision_clka_clkb,
                DI1W          => DIAW,
                DIP1W         => DIPAW,
                DI2W          => DIBW,
                DIP2W         => DIPBW,
                DO1W          => DOAW,
                DOP1W         => DOPAW,
                DO2W          => DOBW,
                DOP2W         => DOPBW
              );
           end if;
           
           if(clsn_type.read_write or clsn_type.write_write or clsn_type.write_read) then
               
              if(clsn_type.write_write) then
                  collision_msg := Write_A_Write_B; 
                  msg_addr1 := tmp_zero_write_a; 
                  msg_addr2 := tmp_zero_write_b; 
              elsif(clsn_type.read_write) then
                  collision_msg :=  Read_A_Write_B; 
                  msg_addr1 := tmp_zero_read_a; 
                  msg_addr2 := tmp_zero_write_b; 
              elsif(clsn_type.write_read) then
                  collision_msg :=  Write_A_Read_B; 
--                  msg_addr1 := tmp_zero_write_a; 
--                  msg_addr2 := tmp_zero_read_b; 
                  msg_addr1 := tmp_zero_read_b;
                  msg_addr2 := tmp_zero_write_a;
              end if;

              if(SimCollisionCheck_var = 1) then
                 --- Message 
                 Memory_Collision_Msg_ramb16
                 (  collision_type => collision_msg,
                   EntityName => "X_RAMB16BWE",
                   InstanceName => X_RAMB16BWE'path_name,
                   address_1 => msg_addr1,
                   address_2 => msg_addr2
                 );

              DOA_clsn  := (others => '0');
              DOPA_clsn := (others => '0');
              DOA_clsn_sav  := DOA_clsn;
              DOPA_clsn_sav := DOPA_clsn;

              elsif(SimCollisionCheck_var = 2) then

                 DOA_clsn_read_index  := SLV_TO_INT(tmp_zero_read_a(4 downto 0));
                 DOB_clsn_read_index := SLV_TO_INT(tmp_zero_read_b(4 downto 0));
                 DOA_clsn(DOAW_1 downto 0) := clsn_xbufs.DO1_clsn((DOA_clsn_read_index+DOAW_1) downto DOA_clsn_read_index);
                 DOB_clsn(DOBW_1 downto 0) := clsn_xbufs.DO2_clsn((DOB_clsn_read_index+DOBW_1) downto DOB_clsn_read_index);
                 if(DOPAW_1 /= -1) then
                    DOPA_clsn_read_index := SLV_TO_INT(tmp_zero_parity_read_a(1 downto 0));
                    DOPA_clsn(DOPAW_1 downto 0) := clsn_xbufs.DOP1_clsn((DOPA_clsn_read_index+DOPAW_1) downto DOPA_clsn_read_index);
                 end if;

                 if(DOPBW_1 /= -1) then
                    DOPB_clsn_read_index := SLV_TO_INT(tmp_zero_parity_read_b(1 downto 0));
                    DOPB_clsn(DOPBW_1 downto 0) := clsn_xbufs.DOP2_clsn((DOPB_clsn_read_index+DOPBW_1) downto DOPB_clsn_read_index);
                 end if;

                 if(wr_mode_a = "10") then
                    DOA_clsn(DOAW_1 downto 0) := DOA_clsn(DOAW_1 downto 0) xor DOA_clsn_sav(DOAW_1 downto 0);
                    if(DOPAW_1 /= -1) then
                       DOPA_clsn(DOPAW_1 downto 0) := DOPA_clsn(DOPAW_1 downto 0) xor DOPA_clsn_sav(DOPAW_1 downto 0);
                    end if;
                 end if;

                 if(wr_mode_b = "10") then
                    DOB_clsn(DOBW_1 downto 0) := DOB_clsn(DOBW_1 downto 0) xor DOB_clsn_sav(DOBW_1 downto 0);
                    if(DOPBW_1 /= -1) then
                       DOPB_clsn(DOPBW_1 downto 0) := DOPB_clsn(DOPBW_1 downto 0) xor DOPB_clsn_sav(DOPBW_1 downto 0);
                    end if;
                 end if;

              elsif(SimCollisionCheck_var = 3) then
                 --- Message 
                 Memory_Collision_Msg_ramb16
                 (  collision_type => collision_msg,
                   EntityName => "X_RAMB16BWE",
                   InstanceName => X_RAMB16BWE'path_name,
                   address_1 => msg_addr1,
                   address_2 => msg_addr2
                 );

                 DOA_clsn_read_index := SLV_TO_INT(tmp_zero_read_a(4 downto 0));
                 DOB_clsn_read_index := SLV_TO_INT(tmp_zero_read_b(4 downto 0));
                 DOA_clsn(DOAW_1 downto 0) := clsn_xbufs.DO1_clsn((DOA_clsn_read_index+DOAW_1) downto DOA_clsn_read_index);
                 DOB_clsn(DOBW_1 downto 0) := clsn_xbufs.DO2_clsn((DOB_clsn_read_index+DOBW_1) downto DOB_clsn_read_index);
                 if(DOPAW_1 /= -1) then
                    DOPA_clsn_read_index := SLV_TO_INT(tmp_zero_parity_read_a(1 downto 0));
                    DOPA_clsn(DOPAW_1 downto 0) := clsn_xbufs.DOP1_clsn((DOPA_clsn_read_index+DOPAW_1) downto DOPA_clsn_read_index);
                 end if;

                 if(DOPBW_1 /= -1) then
                    DOPB_clsn_read_index := SLV_TO_INT(tmp_zero_parity_read_b(1 downto 0));
                    DOPB_clsn(DOPBW_1 downto 0) := clsn_xbufs.DOP2_clsn((DOPB_clsn_read_index+DOPBW_1) downto DOPB_clsn_read_index);
                 end if;

                 if(wr_mode_a = "10") then
                    DOA_clsn(DOAW_1 downto 0) := DOA_clsn(DOAW_1 downto 0) xor DOA_clsn_sav(DOAW_1 downto 0);
                    if(DOPAW_1 /= -1) then
                       DOPA_clsn(DOPAW_1 downto 0) := DOPA_clsn(DOPAW_1 downto 0) xor DOPA_clsn_sav(DOPAW_1 downto 0);
                    end if;
                 end if;

                 if(wr_mode_b = "10") then
                    DOB_clsn(DOBW_1 downto 0) := DOB_clsn(DOBW_1 downto 0) xor DOB_clsn_sav(DOBW_1 downto 0);
                    if(DOPBW_1 /= -1) then
                       DOPB_clsn(DOPBW_1 downto 0) := DOPB_clsn(DOPBW_1 downto 0) xor DOPB_clsn_sav(DOPBW_1 downto 0);
                    end if;
                 end if;


              end if;

           end if;

           DOA_clsn_zero  := DOA_clsn;
           DOPA_clsn_zero := DOPA_clsn;
           if(ssrb_dly_sampled = '0') then
              DOB_clsn_zero  := DOB_clsn;
              DOPB_clsn_zero := DOPB_clsn;
           end if;

        end if;

----------------  END COLLISION A ------------------------------
            if  (wr_mode_a = "00") then

               case DIAW is
               ---------
               when 1|2|4|8 =>
               ---------
                  tmp_we(1 downto 0) := addra_dly_sampled( 4 downto 3);
                  wea_index := SLV_TO_INT(tmp_we);
                  if(wea_dly_sampled(wea_index) = '1') then
                     if(DOAW > DIAW) then
                        DOA_zd_buf(DOAW_1 downto 0) := MEM((ADDRESS_READ_A + DOAW_1) downto  ADDRESS_READ_A);
                        DOA_zd_buf(((DOA_INDEX *DIAW) + DIAW_1) downto (DOA_INDEX *DIAW)) := DIA_dly(DIAW_1 downto 0);
                        DOA_zd(DOAW_1 downto 0) := DOA_zd_buf(DOAW_1 downto 0);
                              
                        if(DOPAW_1 /= -1) then
                          DOPA_zd_buf(DOPAW_1 downto 0) := MEM((16384 + ADDRESS_PARITY_READ_A + DOPAW_1) downto  (16384 + ADDRESS_PARITY_READ_A));
                          DOPA_zd_buf(((DOPA_INDEX *DIPAW) + DIPAW_1) downto (DOPA_INDEX *DIPAW)) := DIPA_dly(DIPAW_1 downto 0);
                          DOPA_zd(DOPAW_1 downto 0) := DOPA_zd_buf(DOPAW_1 downto 0);
                        end if;
                     elsif(DOAW <= DIAW) then
--FP                        DOA_zd(DOAW_1 downto 0)   := DIA_dly(DOAW_1 downto 0);
                        DOA_zd(DOAW_1 downto 0)   := DIA_dly((((DOA_INDEX)*DOAW)+ DOAW_1) downto ((DOA_INDEX)*DOAW));
                        if(DOPAW_1 /= -1) then
                           DOPA_zd(DOPAW_1 downto 0)   := DIPA_dly(DOPAW_1 downto 0);
                        end if;
                     end if;
                  elsif(wea_dly_sampled(wea_index) = '0') then
                     DOA_zd(DOAW_1 downto 0) := MEM((ADDRESS_READ_A + DOAW_1) downto (ADDRESS_READ_A));
                     if(DOPAW_1 /= -1) then
                        DOPA_zd(DOPAW_1 downto 0) := MEM((16384 + ADDRESS_PARITY_READ_A + DOPAW_1) downto (16384 + ADDRESS_PARITY_READ_A));
                     end if;
                  end if;
                     
               ---------
               when 16 =>
               ---------
                  if(DOAW > DIAW) then
                     DOA_zd_buf(DOAW_1 downto 0) := MEM((ADDRESS_READ_A + DOAW_1) downto  ADDRESS_READ_A);
                     DOPA_zd_buf(DOPAW_1 downto 0) := MEM((16384 + ADDRESS_PARITY_READ_A + DOPAW_1) downto  (16384 + ADDRESS_PARITY_READ_A));
                     
-- The following code was added to "X" the output in WRITE_FIRST_MODE when DO /= DI and the WE[--] segments are not all 0's or all 1's    
                     
                     xout_we_seg1(1) := addra_dly_sampled(4);
                     xout_we_seg1(0) := '0';
                     xout_we_seg2(1) := addra_dly_sampled(4);
                     xout_we_seg2(0) := '1';

                     if(wea_dly_sampled(SLV_TO_INT(xout_we_seg1)) /= wea_dly_sampled(SLV_TO_INT(xout_we_seg2))) then 
                        DOA_zd_buf(DOAW_1 downto 0) := (others => 'X');
                        DOPA_zd_buf(DOPAW_1 downto 0) := (others => 'X');
                     else
                        tmp_we(1) := addra_dly_sampled(4);
                        tmp_we(0) := '0';
                        wea_index := SLV_TO_INT(tmp_we);
                        if(wea_dly_sampled(wea_index) = '1') then
                           DOA_zd_buf(((DOA_INDEX *DIAW) + (DIAW/2 - 1)) downto (DOA_INDEX *DIAW)) := DIA_dly((DIAW/2 - 1) downto 0);
                           DOPA_zd_buf(((DOPA_INDEX *DIPAW) + (DIPAW/2 - 1)) downto (DOPA_INDEX *DIPAW)) := DIPA_dly((DIPAW/2 - 1) downto 0);
                        end if;

                        tmp_we(1) := addra_dly_sampled(4);
                        tmp_we(0) := '1';
                        wea_index := SLV_TO_INT(tmp_we);
                        if(wea_dly_sampled(wea_index) = '1') then
                          DOA_zd_buf(((DOA_INDEX *DIAW) + DIAW_1) downto ((DOA_INDEX *DIAW) + DIAW/2 )) := DIA_dly(DIAW_1 downto DIAW/2);
                          DOPA_zd_buf(((DOPA_INDEX *DIPAW) + DIPAW_1) downto ((DOPA_INDEX *DIPAW) + DIPAW/2 )) := DIPA_dly(DIPAW_1 downto DIPAW/2);
                        end if;

                     end if;

                     DOA_zd(DOAW_1 downto 0)   := DOA_zd_buf(DOAW_1 downto 0);
                     DOPA_zd(DOPAW_1 downto 0) := DOPA_zd_buf(DOPAW_1 downto 0);

                  end if;

-------------------
                  if(DOAW <= DIAW) then
                     DOA_zd_buf(DIAW_1 downto 0) := MEM((ADDRESS_WRITE_A + DIAW_1) downto  ADDRESS_WRITE_A);
                     if(DOPAW_1 /= -1) then
                       DOPA_zd_buf(DIPAW_1 downto 0) := MEM((16384 + ADDRESS_PARITY_WRITE_A + DIPAW_1) downto  (16384 + ADDRESS_PARITY_WRITE_A));
                     end if;
-- The following code was added to "X" the output in WRITE_FIRST_MODE when DO /= DI and the WE[--] segments are not all 0's or all 1's    
                     
                     xout_we_seg1(1) := addra_dly_sampled(4);
                     xout_we_seg1(0) := '0';
                     xout_we_seg2(1) := addra_dly_sampled(4);
                     xout_we_seg2(0) := '1';

                     tmp_we(1) := addra_dly_sampled(4);
                     tmp_we(0) := '0';
                     wea_index := SLV_TO_INT(tmp_we);
                     if(wea_dly_sampled(wea_index) = '1') then
                        DOA_zd_buf((DIAW/2 - 1) downto 0)   := DIA_dly((DIAW/2 -1 ) downto 0);
                        if(DOPAW_1 /= -1) then
                           DOPA_zd_buf((DIPAW/2 - 1) downto 0)   := DIPA_dly((DIPAW/2 -1 ) downto 0);
                        end if;
                     elsif(wea_dly_sampled(wea_index) = '0') then
                        if(wea_dly_sampled(SLV_TO_INT(xout_we_seg1)) /= wea_dly_sampled(SLV_TO_INT(xout_we_seg2))) then
                           DOA_zd_buf((DIAW/2 - 1) downto 0)   := (others => 'X');
                           if(DOPAW_1 /= -1) then
                              DOPA_zd_buf((DIPAW/2 - 1) downto 0)   := (others => 'X');
                           end if;
                        end if;
                     end if;

                     tmp_we(1) := addra_dly_sampled(4);
                     tmp_we(0) := '1';
                     wea_index := SLV_TO_INT(tmp_we);
                     if(wea_dly_sampled(wea_index) = '1') then
                        DOA_zd_buf(DIAW_1 downto DIAW/2 )   := DIA_dly(DIAW_1 downto DIAW/2);
                        if(DOPAW_1 /= -1) then
                           DOPA_zd_buf(DIPAW_1 downto DIPAW/2 )   := DIPA_dly(DIPAW_1 downto DIPAW/2);
                        end if;
                     elsif(wea_dly_sampled(wea_index) = '0') then
                        if(wea_dly_sampled(SLV_TO_INT(xout_we_seg1)) /= wea_dly_sampled(SLV_TO_INT(xout_we_seg2))) then
                           DOA_zd_buf(DIAW_1 downto DIAW/2 )   := (others => 'X');
                           if(DOPAW_1 /= -1) then
                              DOPA_zd_buf(DIPAW_1 downto DIPAW/2 )   := (others => 'X');
                           end if;
                        end if;
                     end if;

-- The following code was added to "X" the output in WRITE_FIRST_MODE when DO /= DI and the WE[--] segments are not all 0's or all 1's    
                     if((wea_dly_sampled(SLV_TO_INT(xout_we_seg1)) /= wea_dly_sampled(SLV_TO_INT(xout_we_seg2))) and (DOAW /= DIAW)) then 
                        DOA_zd_buf(DIAW_1 downto 0) := (others => 'X');
                        DOPA_zd_buf(DIPAW_1 downto 0) := (others => 'X');
                     end if;

                     DOA_zd(DOAW_1 downto 0)   := DOA_zd_buf(((DOA_INDEX * DOAW) + DOAW_1) downto (DOA_INDEX * DOAW));
                     if(DOPAW_1 /= -1) then
                        DOPA_zd(DOPAW_1 downto 0) :=  DOPA_zd_buf(((DOPA_INDEX * DOPAW) + DOPAW_1) downto (DOPA_INDEX * DOPAW));
                     end if;

                  end if;

               ---------
               when 32 =>
               ---------

                  for i in 0 to 3 loop
                     if (wea_dly_sampled(i) = '1') then
                        DOA_zd_buf(((DIAW/4)*(i+1) - 1) downto (DIAW/4)*i)   := DIA_dly(((DIAW/4)*(i+1) - 1) downto (DIAW/4)*i);
                        if(DOPAW_1 /= -1) then
                           DOPA_zd_buf(((DIPAW/4)*(i+1) - 1) downto (DIPAW/4)*i) := DIPA_dly(((DIPAW/4)*(i+1) - 1) downto (DIPAW/4)*i);
                        end if;
                     elsif (wea_dly_sampled(i) = '0') then
-- The following code was added to "X" the output in WRITE_FIRST_MODE when DO /= DI and the WE[--] segments are not all 0's or all 1's    
                        DOA_zd_buf(((DIAW/4)*(i+1) - 1) downto (DIAW/4)*i)   := (others => 'X');
                        if(DOPAW_1 /= -1) then
                           DOPA_zd_buf(((DIPAW/4)*(i+1) - 1) downto (DIPAW/4)*i) := (others => 'X');
                        end if;
                     end if;
                  end loop;

-- The following code was added to "X" the output in WRITE_FIRST_MODE when DO /= DI and the WE[--] segments are not all 0's or all 1's    
                  if((wea_dly_sampled(0) = '0') and (wea_dly_sampled(1) = '0') and (wea_dly_sampled(2) = '0') and  (wea_dly_sampled(3) = '0')) then 
                     DOA_zd_buf(DIAW_1 downto 0) := MEM((ADDRESS_WRITE_A + DIAW_1) downto  ADDRESS_WRITE_A);
                     if(DOPAW_1 /= -1) then
                        DOPA_zd_buf(DIPAW_1 downto 0) := MEM((16384 + ADDRESS_PARITY_WRITE_A + DIPAW_1) downto  (16384 + ADDRESS_PARITY_WRITE_A));
                     end if;
                  
                  elsif(not((wea_dly_sampled(0) = '1') and (wea_dly_sampled(1) = '1') and (wea_dly_sampled(2) = '1') and  (wea_dly_sampled(3) = '1'))) then 
                      if(DOAW /= DIAW) then
                         DOA_zd_buf(DIAW_1 downto 0) := (others => 'X');
                         if(DOPAW_1 /= -1) then
                            DOPA_zd_buf(DIPAW_1 downto 0) := (others => 'X');
                         end if;
                      end if;
                  end if;

                  DOA_zd(DOAW_1 downto 0)   := DOA_zd_buf(((DOA_INDEX * DOAW) + DOAW_1) downto (DOA_INDEX * DOAW));
                  if(DOPAW_1 /= -1) then
                     DOPA_zd(DOPAW_1 downto 0) :=  DOPA_zd_buf(((DOPA_INDEX * DOPAW) + DOPAW_1) downto (DOPA_INDEX * DOPAW));
                  end if;

                  when others =>
                     null;
               end case;

            elsif(wr_mode_a = "01") then
              DOA_zd(DOAW_1 downto 0) := MEM((ADDRESS_READ_A + DOAW_1) downto (ADDRESS_READ_A));
              if(DOPAW_1 /= -1) then
                  DOPA_zd(DOPAW_1 downto 0) := MEM((16384 + ADDRESS_PARITY_READ_A + DOPAW_1) downto (16384 + ADDRESS_PARITY_READ_A));
              end if;
            elsif(wr_mode_a = "10") then
              case DIAW is
                 when 1|2|4|8 =>
                    tmp_we(1 downto 0) := addra_dly_sampled( 4 downto 3);
                    wea_index := SLV_TO_INT(tmp_we);
                    if (wea_dly_sampled(wea_index) = '0') then
                       DOA_zd(DOAW_1 downto 0) := MEM((ADDRESS_READ_A + DOAW_1) downto (ADDRESS_READ_A));
                       if(DOPAW_1 /= -1) then
                           DOPA_zd(DOPAW_1 downto 0) := MEM((16384 + ADDRESS_PARITY_READ_A + DOPAW_1) downto (16384 + ADDRESS_PARITY_READ_A));
                       end if;
                    end if;
                 ----------
                 when 16|32 =>
                 ----------
                    if ((wea_dly_sampled(0) = '0') and (wea_dly_sampled(1) = '0') and (wea_dly_sampled(2) = '0') and (wea_dly_sampled(3) = '0'))then
                       DOA_zd(DOAW_1 downto 0) := MEM((ADDRESS_READ_A + DOAW_1) downto (ADDRESS_READ_A));
                       if(DOPAW_1 /= -1) then
                           DOPA_zd(DOPAW_1 downto 0) := MEM((16384 + ADDRESS_PARITY_READ_A + DOPAW_1) downto (16384 + ADDRESS_PARITY_READ_A));
                       end if;
                    end if;
                 ----------
                 when others =>
                 ----------
                    null;
               end case;
          end if;
          end if;
            end if; -- /* end ena_dly_sampled = '1' */
      end if;

------------------------------------------------------------------------                       
------------ Port B ----------------------------------------------------
------------------------------------------------------------------------                       
    if(GSR_CLKB_dly = '1') then
       DOB_zd(DOBW_1 downto 0) := INI_B(DOBW_1 downto 0);
       if(DOPBW_1 /= -1) then
         DOPB_zd(DOPBW_1 downto 0) := INI_B((DOPBW_1 + DOBW) downto DOBW);
       end if;
    elsif(CLKB_dly'event AND CLKB_dly'last_value = '0') then
        if (enb_dly_sampled = '1') then
            if (ssrb_dly_sampled = '1') then
                   DOB_zd(DOBW_1 downto 0) := SRVA_B(DOBW_1 downto 0);
                   DOB_clsn_zero := (others => '0');
                   DOB_clsn := (others => '0');
                   if(DOPBW_1 /= -1) then
                      DOPB_zd(DOPBW_1 downto 0) := SRVA_B((DOPBW_1 + DOBW) downto DOBW);
                      DOPB_clsn_zero := (others => '0');
                      DOPB_clsn := (others => '0');
                   end if;
            else
-----------------------  Start COLLISION B ------------------------------
        if(SimCollisionCheck_var /= 0) then
           DOB_clsn_sav          := DOB_clsn;
           DOPB_clsn_sav         := DOPB_clsn;

           DOB_clsn              := (others => '0');
           DOPB_clsn             := (others => '0');
           clsn_xbufs.DO1_clsn   := (others => '0');
           clsn_xbufs.DOP1_clsn  := (others => '0');
           clsn_xbufs.MEM1_clsn  := (others => '0');
           clsn_xbufs.MEMP1_clsn := (others => '0');

           clsn_xbufs.DO2_clsn   := (others => '0');
           clsn_xbufs.DOP2_clsn  := (others => '0');
           clsn_xbufs.MEM2_clsn  := (others => '0');
           clsn_xbufs.MEMP2_clsn := (others => '0');
        
           clsn_type.active_port := 2;
           addr_overlap := false;
           clsn_type.read_write  := false;
           clsn_type.write_read  := false;
           clsn_type.write_write := false;

--           CLKB_time := now;

           ClkCollisionCheck(
              violation => collision_clka_clkb,
              CheckEnabled => ((TO_X01(ena_dly_sampled) = '1') and (TO_X01(enb_dly_sampled) = '1')), 
              CLK1_time => CLKB_time,
              CLK2_time => CLKA_time,
              SETUP_All => SETUP_ALL,
              SETUP_READ_FIRST => SETUP_READ_FIRST
           );

           if(collision_clka_clkb /= 0) then
              QkAddrOverlapChk(
                addr_overlap => addr_overlap,
                data_widths  => data_widths,
                addra        => addra_dly_sampled,
                addrb        => addrb_dly_sampled
              );
           end if;
        
           if(addr_overlap) then
              PreProcessWe1We2(
                clsn_bufs     => clsn_xbufs,
                clsn_type     => clsn_type,
                memory        => MEM,
                di1           => dib_dly,
                di2           => dia_dly,
                dip1          => dipb_dly,
                dip2          => dipa_dly,
                addr1         => addrb_dly_sampled,
                addr2         => addra_dly_sampled,
                we1           => web_dly_sampled,
                we2           => wea_dly_sampled,
                zero_read_1   => zero_read_b,
                zero_readp_1  => zero_parity_read_b,
                zero_write_1  => zero_write_b,
                zero_writep_1 => zero_parity_write_b,
                zero_read_2   => zero_read_a,
                zero_readp_2  => zero_parity_read_a,
                zero_write_2  => zero_write_a,
                zero_writep_2 => zero_parity_write_a,
                wr_mode_1     => wr_mode_b,
                wr_mode_2     => wr_mode_a,
                violation     => collision_clka_clkb,
                DI1W          => DIBW,
                DIP1W         => DIPBW,
                DI2W          => DIAW,
                DIP2W         => DIPAW,
                DO1W          => DOBW,
                DOP1W         => DOPBW,
                DO2W          => DOAW,
                DOP2W         => DOPAW
              );
           end if;
           
           if(clsn_type.read_write or clsn_type.write_write or clsn_type.write_read) then
               
              if(clsn_type.write_write) then
                  collision_msg := Write_B_Write_A; 
--                  msg_addr1 := tmp_zero_write_b; 
--                  msg_addr2 := tmp_zero_write_a; 
                  msg_addr1 := tmp_zero_write_a; 
                  msg_addr2 := tmp_zero_write_b; 
              elsif(clsn_type.read_write) then
                  collision_msg :=  Read_B_Write_A; 
                  msg_addr1 := tmp_zero_read_b; 
                  msg_addr2 := tmp_zero_write_a; 
              elsif(clsn_type.write_read) then
                  collision_msg :=  Write_B_Read_A; 
--                  msg_addr1 := tmp_zero_write_b; 
--                  msg_addr2 := tmp_zero_read_a; 
                  msg_addr1 := tmp_zero_read_a;
                  msg_addr2 := tmp_zero_write_b;
              end if;

              if(SimCollisionCheck_var = 1) then
                 --- Message 
                 Memory_Collision_Msg_ramb16
                 (  collision_type => collision_msg,
                   EntityName => "X_RAMB16BWE",
                   InstanceName => X_RAMB16BWE'path_name,
                   address_1 => msg_addr1,
                   address_2 => msg_addr2
                 );

              DOB_clsn  := (others => '0');
              DOPB_clsn := (others => '0');
              DOB_clsn_sav  := DOB_clsn;
              DOPB_clsn_sav := DOPB_clsn;

              elsif(SimCollisionCheck_var = 2) then

                 DOB_clsn_read_index := SLV_TO_INT(tmp_zero_read_b(4 downto 0));
                 DOA_clsn_read_index := SLV_TO_INT(tmp_zero_read_a(4 downto 0));

                 DOB_clsn(DOBW_1 downto 0) := clsn_xbufs.DO1_clsn((DOB_clsn_read_index+DOBW_1) downto DOB_clsn_read_index);
                 DOA_clsn(DOAW_1 downto 0) := clsn_xbufs.DO2_clsn((DOA_clsn_read_index+DOAW_1) downto DOA_clsn_read_index);

                 if(DOPBW_1 /= -1) then
                    DOPB_clsn_read_index := SLV_TO_INT(tmp_zero_parity_read_b(1 downto 0));
                    DOPB_clsn(DOPBW_1 downto 0) := clsn_xbufs.DOP1_clsn((DOPB_clsn_read_index+DOPBW_1) downto DOPB_clsn_read_index);
                 end if;

                 if(DOPAW_1 /= -1) then
                    DOPA_clsn_read_index := SLV_TO_INT(tmp_zero_parity_read_a(1 downto 0));
                    DOPA_clsn(DOPAW_1 downto 0) := clsn_xbufs.DOP2_clsn((DOPA_clsn_read_index+DOPAW_1) downto DOPA_clsn_read_index);
                 end if;

                 if(wr_mode_b = "10") then
                    DOB_clsn(DOBW_1 downto 0) := DOB_clsn(DOBW_1 downto 0) xor DOB_clsn_sav(DOBW_1 downto 0);
                    if(DOPBW_1 /= -1) then
                       DOPB_clsn(DOPBW_1 downto 0) := DOPB_clsn(DOPBW_1 downto 0) xor DOPB_clsn_sav(DOPBW_1 downto 0);
                    end if;
                 end if;

                 if(wr_mode_a = "10") then
                    DOA_clsn(DOAW_1 downto 0) := DOA_clsn(DOAW_1 downto 0) xor DOA_clsn_sav(DOAW_1 downto 0);
                    if(DOPAW_1 /= -1) then
                       DOPA_clsn(DOPAW_1 downto 0) := DOPA_clsn(DOPAW_1 downto 0) xor DOPA_clsn_sav(DOPAW_1 downto 0);
                    end if;
                 end if;


              elsif(SimCollisionCheck_var = 3) then
                 --- Message 
                 Memory_Collision_Msg_ramb16
                 (  collision_type => collision_msg,
                   EntityName => "X_RAMB16BWE",
                   InstanceName => X_RAMB16BWE'path_name,
                   address_1 => msg_addr1,
                   address_2 => msg_addr2
                 );


                 DOB_clsn_read_index := SLV_TO_INT(tmp_zero_read_b(4 downto 0));
                 DOA_clsn_read_index := SLV_TO_INT(tmp_zero_read_a(4 downto 0));

                 DOB_clsn(DOBW_1 downto 0) := clsn_xbufs.DO1_clsn((DOB_clsn_read_index+DOBW_1) downto DOB_clsn_read_index);
                 DOA_clsn(DOAW_1 downto 0) := clsn_xbufs.DO2_clsn((DOA_clsn_read_index+DOAW_1) downto DOA_clsn_read_index);

                 if(DOPBW_1 /= -1) then
                    DOPB_clsn_read_index := SLV_TO_INT(tmp_zero_parity_read_b(1 downto 0));
                    DOPB_clsn(DOPBW_1 downto 0) := clsn_xbufs.DOP1_clsn((DOPB_clsn_read_index+DOPBW_1) downto DOPB_clsn_read_index);
                 end if;

                 if(DOPAW_1 /= -1) then
                    DOPA_clsn_read_index := SLV_TO_INT(tmp_zero_parity_read_a(1 downto 0));
                    DOPA_clsn(DOPAW_1 downto 0) := clsn_xbufs.DOP2_clsn((DOPA_clsn_read_index+DOPAW_1) downto DOPA_clsn_read_index);
                 end if;

                 if(wr_mode_b = "10") then
                    DOB_clsn(DOBW_1 downto 0) := DOB_clsn(DOBW_1 downto 0) xor DOB_clsn_sav(DOBW_1 downto 0);
                    if(DOPBW_1 /= -1) then
                       DOPB_clsn(DOPBW_1 downto 0) := DOPB_clsn(DOPBW_1 downto 0) xor DOPB_clsn_sav(DOPBW_1 downto 0);
                    end if;
                 end if;

                 if(wr_mode_a = "10") then
                    DOA_clsn(DOAW_1 downto 0) := DOA_clsn(DOAW_1 downto 0) xor DOA_clsn_sav(DOAW_1 downto 0);
                    if(DOPAW_1 /= -1) then
                       DOPA_clsn(DOPAW_1 downto 0) := DOPA_clsn(DOPAW_1 downto 0) xor DOPA_clsn_sav(DOPAW_1 downto 0);
                    end if;
                 end if;

              end if;

           end if;

           DOB_clsn_zero  := DOB_clsn;
           DOPB_clsn_zero := DOPB_clsn;
           if(ssra_dly_sampled = '0') then
             DOA_clsn_zero  := DOA_clsn;
             DOPA_clsn_zero := DOPA_clsn;
           end if;

        end if;

----------------  END COLLISION B ------------------------------
            if (wr_mode_b = "00") then

               case DIBW is
               ---------
               when 1|2|4|8 =>
               ---------
                  tmp_we(1 downto 0) := addrb_dly_sampled( 4 downto 3);
                  web_index := SLV_TO_INT(tmp_we);
                  if(web_dly_sampled(web_index) = '1') then
                     if(DOBW > DIBW) then
                        DOB_zd_buf(DOBW_1 downto 0) := MEM((ADDRESS_READ_B + DOBW_1) downto  ADDRESS_READ_B);
                        DOB_zd_buf(((DOB_INDEX *DIBW) + DIBW_1) downto (DOB_INDEX *DIBW)) := DIB_dly(DIBW_1 downto 0);
                        DOB_zd(DOBW_1 downto 0) := DOB_zd_buf(DOBW_1 downto 0);
                              
                        if(DOPBW_1 /= -1) then
                          DOPB_zd_buf(DOPBW_1 downto 0) := MEM((16384 + ADDRESS_PARITY_READ_B + DOPBW_1) downto  (16384 + ADDRESS_PARITY_READ_B));
                          DOPB_zd_buf(((DOPB_INDEX *DIPBW) + DIPBW_1) downto (DOPB_INDEX *DIPBW)) := DIPB_dly(DIPBW_1 downto 0);
                          DOPB_zd(DOPBW_1 downto 0) := DOPB_zd_buf(DOPBW_1 downto 0);
                        end if;
                     elsif(DOBW <= DIBW) then
--FP                        DOB_zd(DOBW_1 downto 0)   := DIB_dly(DOBW_1 downto 0);
                        DOB_zd(DOBW_1 downto 0)   := DIB_dly((((DOB_INDEX)*DOBW)+ DOBW_1) downto ((DOB_INDEX)*DOBW));
                        if(DOPBW_1 /= -1) then
                           DOPB_zd(DOPBW_1 downto 0)   := DIPB_dly(DOPBW_1 downto 0);
                        end if;
                     end if;
                  elsif(web_dly_sampled(web_index) = '0') then
                     DOB_zd(DOBW_1 downto 0) := MEM((ADDRESS_READ_B + DOBW_1) downto (ADDRESS_READ_B));
                     if(DOPBW_1 /= -1) then
                        DOPB_zd(DOPBW_1 downto 0) := MEM((16384 + ADDRESS_PARITY_READ_B + DOPBW_1) downto (16384 + ADDRESS_PARITY_READ_B));
                     end if;
                  end if;
                     
               ---------
               when 16 =>
               ---------
                  if(DOBW > DIBW) then
                     DOB_zd_buf(DOBW_1 downto 0) := MEM((ADDRESS_READ_B + DOBW_1) downto  ADDRESS_READ_B);
                     DOPB_zd_buf(DOPBW_1 downto 0) := MEM((16384 + ADDRESS_PARITY_READ_B + DOPBW_1) downto  (16384 + ADDRESS_PARITY_READ_B));
-- The following code was added to "X" the output in WRITE_FIRST_MODE when DO /= DI and the WE[--] segments are not all 0's  or all 1's

                     xout_we_seg1(1) := addrb_dly_sampled(4);
                     xout_we_seg1(0) := '0';
                     xout_we_seg2(1) := addrb_dly_sampled(4);
                     xout_we_seg2(0) := '1';

                     if(web_dly_sampled(SLV_TO_INT(xout_we_seg1)) /= web_dly_sampled(SLV_TO_INT(xout_we_seg2))) then
                        DOB_zd_buf(DOBW_1 downto 0) := (others => 'X');
                        DOPB_zd_buf(DOPBW_1 downto 0) := (others => 'X');
                     else
                        tmp_we(1) := addrb_dly_sampled(4);
                        tmp_we(0) := '0';
                        web_index := SLV_TO_INT(tmp_we);
                        if(web_dly_sampled(web_index) = '1') then
                           DOB_zd_buf(((DOB_INDEX *DIBW) + (DIBW/2 - 1)) downto (DOB_INDEX *DIBW)) := DIB_dly((DIBW/2 - 1) downto 0);
                           DOPB_zd_buf(((DOPB_INDEX *DIPBW) + (DIPBW/2 - 1)) downto (DOPB_INDEX *DIPBW)) := DIPB_dly((DIPBW/2 - 1) downto 0);
                        end if;

                        tmp_we(1) := addrb_dly_sampled(4);
                        tmp_we(0) := '1';
                        web_index := SLV_TO_INT(tmp_we);
                        if(web_dly_sampled(web_index) = '1') then
                          DOB_zd_buf(((DOB_INDEX *DIBW) + DIBW_1) downto ((DOB_INDEX *DIBW) + DIBW/2 )) := DIB_dly(DIBW_1 downto DIBW/2);
                          DOPB_zd_buf(((DOPB_INDEX *DIPBW) + DIPBW_1) downto ((DOPB_INDEX *DIPBW) + DIPBW/2 )) := DIPB_dly(DIPBW_1 downto DIPBW/2);
                        end if;

                     end if;

                     DOB_zd(DOBW_1 downto 0)   := DOB_zd_buf(DOBW_1 downto 0);
                     DOPB_zd(DOPBW_1 downto 0) := DOPB_zd_buf(DOPBW_1 downto 0);

                  end if;

-------------------
                  if(DOBW <= DIBW) then
                     DOB_zd_buf(DIBW_1 downto 0) := MEM((ADDRESS_WRITE_B + DIBW_1) downto  ADDRESS_WRITE_B);
                     if(DOPBW_1 /= -1) then
                        DOPB_zd_buf(DIPBW_1 downto 0) := MEM((16384 + ADDRESS_PARITY_WRITE_B + DIPBW_1) downto  (16384 + ADDRESS_PARITY_WRITE_B));
                     end if;
-- The following code was added to "X" the output in WRITE_FIRST_MODE when DO /= DI and the WE[--] segments are not all 0's  or all 1's
                          
                     xout_we_seg1(1) := addrb_dly_sampled(4);
                     xout_we_seg1(0) := '0';
                     xout_we_seg2(1) := addrb_dly_sampled(4);
                     xout_we_seg2(0) := '1';

                     tmp_we(1) := addrb_dly_sampled(4);
                     tmp_we(0) := '0';
                     web_index := SLV_TO_INT(tmp_we);
                     if(web_dly_sampled(web_index) = '1') then
                        DOB_zd_buf((DIBW/2 - 1) downto 0)   := DIB_dly((DIBW/2 -1 ) downto 0);
                        if(DOPBW_1 /= -1) then
                           DOPB_zd_buf((DIPBW/2 - 1) downto 0)   := DIPB_dly((DIPBW/2 -1 ) downto 0);
                        end if;
                     elsif(web_dly_sampled(web_index) = '0') then
                        if(web_dly_sampled(SLV_TO_INT(xout_we_seg1)) /= web_dly_sampled(SLV_TO_INT(xout_we_seg2))) then
                           DOB_zd_buf((DIBW/2 - 1) downto 0)   := (others => 'X');
                           if(DOPBW_1 /= -1) then
                              DOPB_zd_buf((DIPBW/2 - 1) downto 0)   := (others => 'X');
                           end if;
                        end if;
                     end if;

                     tmp_we(1) := addrb_dly_sampled(4);
                     tmp_we(0) := '1';
                     web_index := SLV_TO_INT(tmp_we);
                     if(web_dly_sampled(web_index) = '1') then
                        DOB_zd_buf(DIBW_1 downto DIBW/2 )   := DIB_dly(DIBW_1 downto DIBW/2);
                        if(DOPBW_1 /= -1) then
                           DOPB_zd_buf(DIPBW_1 downto DIPBW/2 )   := DIPB_dly(DIPBW_1 downto DIPBW/2);
                        end if;
                     elsif(web_dly_sampled(web_index) = '0') then
                        if(web_dly_sampled(SLV_TO_INT(xout_we_seg1)) /= web_dly_sampled(SLV_TO_INT(xout_we_seg2))) then
                           DOB_zd_buf(DIBW_1 downto DIBW/2 )   := (others => 'X');
                           if(DOPBW_1 /= -1) then
                              DOPB_zd_buf(DIPBW_1 downto DIPBW/2 )   := (others => 'X');
                           end if;
                        end if;
                     end if;

-- The following code was added to "X" the output in WRITE_FIRST_MODE when DO /= DI and the WE[--] segments are not all 0's  or all 1's
                     if((web_dly_sampled(SLV_TO_INT(xout_we_seg1)) /= web_dly_sampled(SLV_TO_INT(xout_we_seg2))) and (DOBW /= DIBW)) then
                        DOB_zd_buf(DIBW_1 downto 0) := (others => 'X');
                        DOPB_zd_buf(DIPBW_1 downto 0) := (others => 'X');
                     end if;

                     DOB_zd(DOBW_1 downto 0)   := DOB_zd_buf(((DOB_INDEX * DOBW) + DOBW_1) downto (DOB_INDEX * DOBW));
                     if(DOPBW_1 /= -1) then
                        DOPB_zd(DOPBW_1 downto 0) :=  DOPB_zd_buf(((DOPB_INDEX * DOPBW) + DOPBW_1) downto (DOPB_INDEX * DOPBW));
                     end if;

                  end if;

               ---------
               when 32 =>
               ---------
                  for i in 0 to 3 loop
                     if (web_dly_sampled(i) = '1') then
                        DOB_zd_buf(((DIBW/4)*(i+1) - 1) downto (DIBW/4)*i)   := DIB_dly(((DIBW/4)*(i+1) - 1) downto (DIBW/4)*i);
                        if(DOPBW_1 /= -1) then
                           DOPB_zd_buf(((DIPBW/4)*(i+1) - 1) downto (DIPBW/4)*i) := DIPB_dly(((DIPBW/4)*(i+1) - 1) downto (DIPBW/4)*i);
                        end if;
                     elsif (web_dly_sampled(i) = '0') then
-- The following code was added to "X" the output in WRITE_FIRST_MODE when DO /= DI and the WE[--] segments are not all 0's  or all 1's
                        DOB_zd_buf(((DIBW/4)*(i+1) - 1) downto (DIBW/4)*i)   := (others => 'X');
                        if(DOPBW_1 /= -1) then
                           DOPB_zd_buf(((DIPBW/4)*(i+1) - 1) downto (DIPBW/4)*i) := (others => 'X');
                        end if;
                     end if;
                  end loop;
-- The following code was added to "X" the output in WRITE_FIRST_MODE when DO /= DI and the WE[--] segments are not all 0's  or all 1's
                  if((web_dly_sampled(0) = '0') and (web_dly_sampled(1) = '0') and (web_dly_sampled(2) = '0') and  (web_dly_sampled(3) = '0')) then
                     DOB_zd_buf(DIBW_1 downto 0) := MEM((ADDRESS_WRITE_B + DIBW_1) downto  ADDRESS_WRITE_B);
                     if(DOPBW_1 /= -1) then
                        DOPB_zd_buf(DIPBW_1 downto 0) := MEM((16384 + ADDRESS_PARITY_WRITE_B + DIPBW_1) downto  (16384 + ADDRESS_PARITY_WRITE_B));
                     end if;
                  elsif(not((web_dly_sampled(0) = '1') and (web_dly_sampled(1) = '1') and (web_dly_sampled(2) = '1') and  (web_dly_sampled(3) = '1'))) then
                      if(DOBW /= DIBW) then
                         DOB_zd_buf(DIBW_1 downto 0) := (others => 'X');
                         if(DOPBW_1 /= -1) then
                            DOPB_zd_buf(DIPBW_1 downto 0) := (others => 'X');
                         end if;
                      end if;
                  end if;

                  DOB_zd(DOBW_1 downto 0)   := DOB_zd_buf(((DOB_INDEX * DOBW) + DOBW_1) downto (DOB_INDEX * DOBW));
                  if(DOPBW_1 /= -1) then
                     DOPB_zd(DOPBW_1 downto 0) :=  DOPB_zd_buf(((DOPB_INDEX * DOPBW) + DOPBW_1) downto (DOPB_INDEX * DOPBW));
                  end if;

                  when others =>
                     null;
               end case;

            elsif(wr_mode_b = "01") then
              DOB_zd(DOBW_1 downto 0) := MEM((ADDRESS_READ_B + DOBW_1) downto (ADDRESS_READ_B));
              if(DOPBW_1 /= -1) then
                  DOPB_zd(DOPBW_1 downto 0) := MEM((16384 + ADDRESS_PARITY_READ_B + DOPBW_1) downto (16384 + ADDRESS_PARITY_READ_B));
              end if;
            elsif(wr_mode_b = "10") then
              case DIBW is
                 when 1|2|4|8 =>
                    tmp_we(1 downto 0) := addrb_dly_sampled( 4 downto 3);
                    web_index := SLV_TO_INT(tmp_we);
                    if (web_dly_sampled(web_index) = '0') then
                       DOB_zd(DOBW_1 downto 0) := MEM((ADDRESS_READ_B + DOBW_1) downto (ADDRESS_READ_B));
                       if(DOPBW_1 /= -1) then
                           DOPB_zd(DOPBW_1 downto 0) := MEM((16384 + ADDRESS_PARITY_READ_B + DOPBW_1) downto (16384 + ADDRESS_PARITY_READ_B));
                       end if;
                    end if;
                 ----------
                 when 16|32 =>
                 ----------
                    if ((web_dly_sampled(0) = '0') and (web_dly_sampled(1) = '0') and (web_dly_sampled(2) = '0') and (web_dly_sampled(3) = '0'))then
                       DOB_zd(DOBW_1 downto 0) := MEM((ADDRESS_READ_B + DOBW_1) downto (ADDRESS_READ_B));
                       if(DOPBW_1 /= -1) then
                           DOPB_zd(DOPBW_1 downto 0) := MEM((16384 + ADDRESS_PARITY_READ_B + DOPBW_1) downto (16384 + ADDRESS_PARITY_READ_B));
                       end if;
                    end if;
                 ----------
                 when others =>
                 ----------
                    null;
               end case;
          end if;
          end if;
            end if; -- /* end enb_dly_sampled = '1' */
      end if;

------------------------------------------------------------------------                       
------------ Port A  -- Memory Update ----------------------------------
------------------------------------------------------------------------                       

    if((GSR_CLKA_dly = '0') and rising_edge(CLKA_dly)) then
        if (ena_dly_sampled = '1') then
                case DIAW is
                  --------------
                  when 1|2|4|8 =>
                  --------------
                      tmp_we(1 downto 0) := addra_dly_sampled( 4 downto 3);
                      wea_index := SLV_TO_INT(tmp_we);
                      if (wea_dly_sampled(wea_index) = '1') then
                         if (VALID_ADDRA) then
                            MEM((ADDRESS_WRITE_A + DIAW_1) downto (ADDRESS_WRITE_A)) := DIA_dly(DIAW_1 downto 0);
                            if(DIPAW_1 /= -1) then
                               MEM((16384 + ADDRESS_PARITY_WRITE_A + DIPAW_1) downto (16384 + ADDRESS_PARITY_WRITE_A)) := DIPA_dly(DIPAW_1 downto 0);
                            end if;
                         else
                          DOA_zd(DOAW_1 downto 0) := (others => 'X');
                          if(DOPAW_1 /= -1) then
                             DOPA_zd(DOPAW_1 downto 0) := (others => 'X');
                          end if;
                         end if; -- /* VAILD ADDRA */
                      end if; -- /*  wea_dly_sampled = '1' */ 

                  ---------
                  when 16 =>
                  ---------
                      tmp_we(1) := addra_dly_sampled(4);
                      tmp_we(0) := '0';
                      wea_index := SLV_TO_INT(tmp_we);
                      if (wea_dly_sampled(wea_index) = '1') then
                         if (VALID_ADDRA) then
                            MEM((ADDRESS_WRITE_A + DIAW/2 -1) downto (ADDRESS_WRITE_A)) := DIA_dly((DIAW/2 - 1) downto 0);
                            if(DIPAW_1 /= -1) then
                               MEM((16384 + ADDRESS_PARITY_WRITE_A + DIPAW/2 - 1) downto (16384 + ADDRESS_PARITY_WRITE_A)) := DIPA_dly((DIPAW/2 -1) downto 0);
                            end if;
                         end if; -- /* VAILD ADDRA */
                      end if; -- /*  wea_dly_sampled = '1' */ 

                      tmp_we(0) := '1';
                      wea_index := SLV_TO_INT(tmp_we);
                      if (wea_dly_sampled(wea_index) = '1') then
                         if (VALID_ADDRA) then
                            MEM((ADDRESS_WRITE_A + DIAW_1) downto (ADDRESS_WRITE_A + DIAW/2)) := DIA_dly(DIAW_1 downto DIAW/2);
                            if(DIPAW_1 /= -1) then
                               MEM((16384 + ADDRESS_PARITY_WRITE_A + DIPAW_1) downto (16384 + ADDRESS_PARITY_WRITE_A + DIPAW/2)) := DIPA_dly(DIPAW_1 downto DIPAW/2);
                            end if;
                         end if; -- /* VAILD ADDRA */
                      end if; -- /*  wea_dly_sampled = '1' */ 

                  ---------
                  when 32 =>
                  ---------
                      wea_index := 0;
                      if (wea_dly_sampled(wea_index) = '1') then
                         if (VALID_ADDRA) then
                            MEM((ADDRESS_WRITE_A + (DIAW/4)*1 -1) downto (ADDRESS_WRITE_A)) := DIA_dly((((DIAW/4)*1) - 1) downto 0);
                            if(DIPAW_1 /= -1) then
                               MEM((16384 + ADDRESS_PARITY_WRITE_A + (DIPAW/4)*1 - 1) downto (16384 + ADDRESS_PARITY_WRITE_A)) := DIPA_dly(((DIPAW/4)*1 -1) downto 0);
                            end if;
                         end if; -- /* VAILD ADDRA */
                      end if; -- /*  wea_dly_sampled = '1' */ 

                      wea_index := 1;
                      if (wea_dly_sampled(wea_index) = '1') then
                         if (VALID_ADDRA) then
                            MEM((ADDRESS_WRITE_A + (DIAW/4)*2 -1) downto (ADDRESS_WRITE_A + (DIAW/4)*1)) := DIA_dly((((DIAW/4)*2) - 1) downto (DIAW/4)*1);
                            if(DIPAW_1 /= -1) then
                               MEM((16384 + ADDRESS_PARITY_WRITE_A + (DIPAW/4)*2 - 1) downto (16384 + ADDRESS_PARITY_WRITE_A  + (DIPAW/4)*1)) := DIPA_dly(((DIPAW/4)*2 -1) downto ((DIPAW/4)*1));
                            end if;
                         end if; -- /* VAILD ADDRA */
                      end if; -- /*  wea_dly_sampled = '1' */ 

                      wea_index := 2;
                      if (wea_dly_sampled(wea_index) = '1') then
                         if (VALID_ADDRA) then
                            MEM((ADDRESS_WRITE_A + (DIAW/4)*3 -1) downto (ADDRESS_WRITE_A + (DIAW/4)*2)) := DIA_dly((((DIAW/4)*3) - 1) downto (DIAW/4)*2);
                            if(DIPAW_1 /= -1) then
                               MEM((16384 + ADDRESS_PARITY_WRITE_A + (DIPAW/4)*3 - 1) downto (16384 + ADDRESS_PARITY_WRITE_A  + (DIPAW/4)*2)) := DIPA_dly(((DIPAW/4)*3 -1) downto ((DIPAW/4)*2));
                            end if;
                         end if; -- /* VAILD ADDRA */
                      end if; -- /*  wea_dly_sampled = '1' */ 

                      wea_index := 3;
                      if (wea_dly_sampled(wea_index) = '1') then
                         if (VALID_ADDRA) then
                            MEM((ADDRESS_WRITE_A + (DIAW/4)*4 -1) downto (ADDRESS_WRITE_A + (DIAW/4)*3)) := DIA_dly((((DIAW/4)*4) - 1) downto (DIAW/4)*3);
                            if(DIPAW_1 /= -1) then
                               MEM((16384 + ADDRESS_PARITY_WRITE_A + (DIPAW/4)*4 - 1) downto (16384 + ADDRESS_PARITY_WRITE_A  + (DIPAW/4)*3)) := DIPA_dly(((DIPAW/4)*4 -1) downto ((DIPAW/4)*3));
                            end if;
                         end if; -- /* VAILD ADDRA */
                      end if; -- /*  wea_dly_sampled = '1' */ 
                  when others =>
                     null;
                end case;

-----------------------  Start COLLISION MEMORY UPDATE A ------------------------------

        if(SimCollisionCheck_var /= 0) then
           if(clsn_type.write_write) then
              tmp_membuf := (others => '0');
              DOA_clsn_write_index := SLV_TO_INT(tmp_zero_write_a(4 downto 0));
              tmp_membuf(DIAW_1 downto 0) := MEM((ADDRESS_WRITE_A + DIAW_1) downto (ADDRESS_WRITE_A));
              MEM((ADDRESS_WRITE_A + DIAW_1) downto (ADDRESS_WRITE_A)) := tmp_membuf(DIAW_1 downto 0) xor clsn_xbufs.MEM1_clsn((DOA_clsn_write_index+DIAW_1) downto DOA_clsn_write_index);

             if((DIPAW_1 /= -1) and (DIPBW_1 /= -1)) then
                tmp_membuf := (others => '0');
                DOPA_clsn_write_index := SLV_TO_INT(tmp_zero_parity_write_a(1 downto 0));
                tmp_membuf(DIPAW_1 downto 0) :=  MEM((16384 + ADDRESS_PARITY_WRITE_A + DIPAW_1) downto (16384 + ADDRESS_PARITY_WRITE_A));
                MEM((16384 + ADDRESS_PARITY_WRITE_A + DIPAW_1) downto (16384 + ADDRESS_PARITY_WRITE_A)) := tmp_membuf(DIPAW_1 downto 0) xor clsn_xbufs.MEMP1_clsn((DOPA_clsn_write_index + DIPAW_1) downto DOPA_clsn_write_index);
              end if;
           end if;
        end if;
                
-----------------------  END COLLISION MEMORY UPDATE A   ------------------------------
                 
            end if; -- /* end ena_dly_sampled = '1' */
      end if;
------------------------------------------------------------------------                       
------------ Port B  -- Memory Update ----------------------------------
------------------------------------------------------------------------                       

    if((GSR_CLKB_dly = '0') and rising_edge(CLKB_dly)) then
        if (enb_dly_sampled = '1') then
                case DIBW is
                  --------------
                  when 1|2|4|8 =>
                  --------------
                      tmp_we(1 downto 0) := addrb_dly_sampled( 4 downto 3);
                      web_index := SLV_TO_INT(tmp_we);
                      if (web_dly_sampled(web_index) = '1') then
                         if (VALID_ADDRB) then
                            MEM((ADDRESS_WRITE_B + DIBW_1) downto (ADDRESS_WRITE_B)) := DIB_dly(DIBW_1 downto 0);
                            if(DIPBW_1 /= -1) then
                               MEM((16384 + ADDRESS_PARITY_WRITE_B + DIPBW_1) downto (16384 + ADDRESS_PARITY_WRITE_B)) := DIPB_dly(DIPBW_1 downto 0);
                            end if;
                         else
                          DOB_zd(DOBW_1 downto 0) := (others => 'X');
                          if(DOPBW_1 /= -1) then
                             DOPB_zd(DOPBW_1 downto 0) := (others => 'X');
                          end if;
                         end if; -- /* VAILD ADDRB */
                      end if; -- /*  web_dly_sampled = '1' */ 

                  ---------
                  when 16 =>
                  ---------
                      tmp_we(1) := addrb_dly_sampled(4);
                      tmp_we(0) := '0';
                      web_index := SLV_TO_INT(tmp_we);
                      if (web_dly_sampled(web_index) = '1') then
                         if (VALID_ADDRB) then
                            MEM((ADDRESS_WRITE_B + DIBW/2 -1) downto (ADDRESS_WRITE_B)) := DIB_dly((DIBW/2 - 1) downto 0);
                            if(DIPBW_1 /= -1) then
                               MEM((16384 + ADDRESS_PARITY_WRITE_B + DIPBW/2 - 1) downto (16384 + ADDRESS_PARITY_WRITE_B)) := DIPB_dly((DIPBW/2 -1) downto 0);
                            end if;
                         end if; -- /* VAILD ADDRB */
                      end if; -- /*  web_dly_sampled = '1' */ 

                      tmp_we(0) := '1';
                      web_index := SLV_TO_INT(tmp_we);
                      if (web_dly_sampled(web_index) = '1') then
                         if (VALID_ADDRB) then
                            MEM((ADDRESS_WRITE_B + DIBW_1) downto (ADDRESS_WRITE_B + DIBW/2)) := DIB_dly(DIBW_1 downto DIBW/2);
                            if(DIPBW_1 /= -1) then
                               MEM((16384 + ADDRESS_PARITY_WRITE_B + DIPBW_1) downto (16384 + ADDRESS_PARITY_WRITE_B + DIPBW/2)) := DIPB_dly(DIPBW_1 downto DIPBW/2);
                            end if;
                         end if; -- /* VAILD ADDRB */
                      end if; -- /*  web_dly_sampled = '1' */ 

                  ---------
                  when 32 =>
                  ---------
                      web_index := 0;
                      if (web_dly_sampled(web_index) = '1') then
                         if (VALID_ADDRB) then
                            MEM((ADDRESS_WRITE_B + (DIBW/4)*1 -1) downto (ADDRESS_WRITE_B)) := DIB_dly((((DIBW/4)*1) - 1) downto 0);
                            if(DIPBW_1 /= -1) then
                               MEM((16384 + ADDRESS_PARITY_WRITE_B + (DIPBW/4)*1 - 1) downto (16384 + ADDRESS_PARITY_WRITE_B)) := DIPB_dly(((DIPBW/4)*1 -1) downto 0);
                            end if;
                         end if; -- /* VAILD ADDRB */
                      end if; -- /*  web_dly_sampled = '1' */ 

                      web_index := 1;
                      if (web_dly_sampled(web_index) = '1') then
                         if (VALID_ADDRB) then
                            MEM((ADDRESS_WRITE_B + (DIBW/4)*2 -1) downto (ADDRESS_WRITE_B + (DIBW/4)*1)) := DIB_dly((((DIBW/4)*2) - 1) downto (DIBW/4)*1);
                            if(DIPBW_1 /= -1) then
                               MEM((16384 + ADDRESS_PARITY_WRITE_B + (DIPBW/4)*2 - 1) downto (16384 + ADDRESS_PARITY_WRITE_B  + (DIPBW/4)*1)) := DIPB_dly(((DIPBW/4)*2 -1) downto ((DIPBW/4)*1));
                            end if;
                         end if; -- /* VAILD ADDRB */
                      end if; -- /*  web_dly_sampled = '1' */ 

                      web_index := 2;
                      if (web_dly_sampled(web_index) = '1') then
                         if (VALID_ADDRB) then
                            MEM((ADDRESS_WRITE_B + (DIBW/4)*3 -1) downto (ADDRESS_WRITE_B + (DIBW/4)*2)) := DIB_dly((((DIBW/4)*3) - 1) downto (DIBW/4)*2);
                            if(DIPBW_1 /= -1) then
                               MEM((16384 + ADDRESS_PARITY_WRITE_B + (DIPBW/4)*3 - 1) downto (16384 + ADDRESS_PARITY_WRITE_B  + (DIPBW/4)*2)) := DIPB_dly(((DIPBW/4)*3 -1) downto ((DIPBW/4)*2));
                            end if;
                         end if; -- /* VAILD ADDRB */
                      end if; -- /*  web_dly_sampled = '1' */ 

                      web_index := 3;
                      if (web_dly_sampled(web_index) = '1') then
                         if (VALID_ADDRB) then
                            MEM((ADDRESS_WRITE_B + (DIBW/4)*4 -1) downto (ADDRESS_WRITE_B + (DIBW/4)*3)) := DIB_dly((((DIBW/4)*4) - 1) downto (DIBW/4)*3);
                            if(DIPBW_1 /= -1) then
                               MEM((16384 + ADDRESS_PARITY_WRITE_B + (DIPBW/4)*4 - 1) downto (16384 + ADDRESS_PARITY_WRITE_B  + (DIPBW/4)*3)) := DIPB_dly(((DIPBW/4)*4 -1) downto ((DIPBW/4)*3));
                            end if;
                         end if; -- /* VAILD ADDRB */
                      end if; -- /*  web_dly_sampled = '1' */ 
                  when others =>
                     null;
                end case;
                 
-----------------------  Start COLLISION MEMORY UPDATE B ------------------------------

        if(SimCollisionCheck_var /= 0) then
           if(clsn_type.write_write) then
              tmp_membuf := (others => '0');
              DOB_clsn_write_index := SLV_TO_INT(tmp_zero_write_b(4 downto 0));
              tmp_membuf(DIBW_1 downto 0) := MEM((ADDRESS_WRITE_B + DIBW_1) downto (ADDRESS_WRITE_B));
              MEM((ADDRESS_WRITE_B + DIBW_1) downto (ADDRESS_WRITE_B)) := tmp_membuf(DIBW_1 downto 0) xor clsn_xbufs.MEM1_clsn((DOB_clsn_write_index+DIBW_1) downto DOB_clsn_write_index);

             if((DIPBW_1 /= -1) and (DIPAW_1 /= -1)) then
                tmp_membuf := (others => '0');
                DOPB_clsn_write_index := SLV_TO_INT(tmp_zero_parity_write_b(1 downto 0));
                tmp_membuf(DIPBW_1 downto 0) :=  MEM((16384 + ADDRESS_PARITY_WRITE_B + DIPBW_1) downto (16384 + ADDRESS_PARITY_WRITE_B));
                MEM((16384 + ADDRESS_PARITY_WRITE_B + DIPBW_1) downto (16384 + ADDRESS_PARITY_WRITE_B)) := tmp_membuf(DIPBW_1 downto 0) xor clsn_xbufs.MEMP1_clsn((DOPB_clsn_write_index + DIPBW_1) downto DOPB_clsn_write_index);
              end if;
           end if;
        end if;
                
-----------------------  END COLLISION MEMORY UPDATE B   ------------------------------

            end if; -- /* end enb_dly_sampled = '1' */
      end if;
--=======================================================================================
----- Port A

    DOA_viol(0)  <= ViolationA xor DOA_zd(0) xor DOA_clsn_zero(0);
    DOA_viol(1)  <= ViolationA xor DOA_zd(1) xor DOA_clsn_zero(1);
    DOA_viol(2)  <= ViolationA xor DOA_zd(2) xor DOA_clsn_zero(2);
    DOA_viol(3)  <= ViolationA xor DOA_zd(3) xor DOA_clsn_zero(3);
    DOA_viol(4)  <= ViolationA xor DOA_zd(4) xor DOA_clsn_zero(4);
    DOA_viol(5)  <= ViolationA xor DOA_zd(5) xor DOA_clsn_zero(5);
    DOA_viol(6)  <= ViolationA xor DOA_zd(6) xor DOA_clsn_zero(6);
    DOA_viol(7)  <= ViolationA xor DOA_zd(7) xor DOA_clsn_zero(7);
    DOA_viol(8)  <= ViolationA xor DOA_zd(8) xor DOA_clsn_zero(8);
    DOA_viol(9)  <= ViolationA xor DOA_zd(9) xor DOA_clsn_zero(9);
    DOA_viol(10) <= ViolationA xor DOA_zd(10) xor DOA_clsn_zero(10);
    DOA_viol(11) <= ViolationA xor DOA_zd(11) xor DOA_clsn_zero(11);
    DOA_viol(12) <= ViolationA xor DOA_zd(12) xor DOA_clsn_zero(12);
    DOA_viol(13) <= ViolationA xor DOA_zd(13) xor DOA_clsn_zero(13);
    DOA_viol(14) <= ViolationA xor DOA_zd(14) xor DOA_clsn_zero(14);
    DOA_viol(15) <= ViolationA xor DOA_zd(15) xor DOA_clsn_zero(15);
    DOA_viol(16) <= ViolationA xor DOA_zd(16) xor DOA_clsn_zero(16);
    DOA_viol(17) <= ViolationA xor DOA_zd(17) xor DOA_clsn_zero(17);
    DOA_viol(18) <= ViolationA xor DOA_zd(18) xor DOA_clsn_zero(18);
    DOA_viol(19) <= ViolationA xor DOA_zd(19) xor DOA_clsn_zero(19);
    DOA_viol(20) <= ViolationA xor DOA_zd(20) xor DOA_clsn_zero(20);
    DOA_viol(21) <= ViolationA xor DOA_zd(21) xor DOA_clsn_zero(21);
    DOA_viol(22) <= ViolationA xor DOA_zd(22) xor DOA_clsn_zero(22);
    DOA_viol(23) <= ViolationA xor DOA_zd(23) xor DOA_clsn_zero(23);
    DOA_viol(24) <= ViolationA xor DOA_zd(24) xor DOA_clsn_zero(24);
    DOA_viol(25) <= ViolationA xor DOA_zd(25) xor DOA_clsn_zero(25);
    DOA_viol(26) <= ViolationA xor DOA_zd(26) xor DOA_clsn_zero(26);
    DOA_viol(27) <= ViolationA xor DOA_zd(27) xor DOA_clsn_zero(27);
    DOA_viol(28) <= ViolationA xor DOA_zd(28) xor DOA_clsn_zero(28);
    DOA_viol(29) <= ViolationA xor DOA_zd(29) xor DOA_clsn_zero(29);
    DOA_viol(30) <= ViolationA xor DOA_zd(30) xor DOA_clsn_zero(30);
    DOA_viol(31) <= ViolationA xor DOA_zd(31) xor DOA_clsn_zero(31);
    DOPA_viol(0) <= ViolationA xor DOPA_zd(0) xor DOPA_clsn_zero(0);
    DOPA_viol(1) <= ViolationA xor DOPA_zd(1) xor DOPA_clsn_zero(1);
    DOPA_viol(2) <= ViolationA xor DOPA_zd(2) xor DOPA_clsn_zero(2);
    DOPA_viol(3) <= ViolationA xor DOPA_zd(3) xor DOPA_clsn_zero(3);

----- Port B

    DOB_viol(0)  <= ViolationB xor DOB_zd(0) xor DOB_clsn_zero(0);
    DOB_viol(1)  <= ViolationB xor DOB_zd(1) xor DOB_clsn_zero(1);
    DOB_viol(2)  <= ViolationB xor DOB_zd(2) xor DOB_clsn_zero(2);
    DOB_viol(3)  <= ViolationB xor DOB_zd(3) xor DOB_clsn_zero(3);
    DOB_viol(4)  <= ViolationB xor DOB_zd(4) xor DOB_clsn_zero(4);
    DOB_viol(5)  <= ViolationB xor DOB_zd(5) xor DOB_clsn_zero(5);
    DOB_viol(6)  <= ViolationB xor DOB_zd(6) xor DOB_clsn_zero(6);
    DOB_viol(7)  <= ViolationB xor DOB_zd(7) xor DOB_clsn_zero(7);
    DOB_viol(8)  <= ViolationB xor DOB_zd(8) xor DOB_clsn_zero(8);
    DOB_viol(9)  <= ViolationB xor DOB_zd(9) xor DOB_clsn_zero(9);
    DOB_viol(10) <= ViolationB xor DOB_zd(10) xor DOB_clsn_zero(10);
    DOB_viol(11) <= ViolationB xor DOB_zd(11) xor DOB_clsn_zero(11);
    DOB_viol(12) <= ViolationB xor DOB_zd(12) xor DOB_clsn_zero(12);
    DOB_viol(13) <= ViolationB xor DOB_zd(13) xor DOB_clsn_zero(13);
    DOB_viol(14) <= ViolationB xor DOB_zd(14) xor DOB_clsn_zero(14);
    DOB_viol(15) <= ViolationB xor DOB_zd(15) xor DOB_clsn_zero(15);
    DOB_viol(16) <= ViolationB xor DOB_zd(16) xor DOB_clsn_zero(16);
    DOB_viol(17) <= ViolationB xor DOB_zd(17) xor DOB_clsn_zero(17);
    DOB_viol(18) <= ViolationB xor DOB_zd(18) xor DOB_clsn_zero(18);
    DOB_viol(19) <= ViolationB xor DOB_zd(19) xor DOB_clsn_zero(19);
    DOB_viol(20) <= ViolationB xor DOB_zd(20) xor DOB_clsn_zero(20);
    DOB_viol(21) <= ViolationB xor DOB_zd(21) xor DOB_clsn_zero(21);
    DOB_viol(22) <= ViolationB xor DOB_zd(22) xor DOB_clsn_zero(22);
    DOB_viol(23) <= ViolationB xor DOB_zd(23) xor DOB_clsn_zero(23);
    DOB_viol(24) <= ViolationB xor DOB_zd(24) xor DOB_clsn_zero(24);
    DOB_viol(25) <= ViolationB xor DOB_zd(25) xor DOB_clsn_zero(25);
    DOB_viol(26) <= ViolationB xor DOB_zd(26) xor DOB_clsn_zero(26);
    DOB_viol(27) <= ViolationB xor DOB_zd(27) xor DOB_clsn_zero(27);
    DOB_viol(28) <= ViolationB xor DOB_zd(28) xor DOB_clsn_zero(28);
    DOB_viol(29) <= ViolationB xor DOB_zd(29) xor DOB_clsn_zero(29);
    DOB_viol(30) <= ViolationB xor DOB_zd(30) xor DOB_clsn_zero(30);
    DOB_viol(31) <= ViolationB xor DOB_zd(31) xor DOB_clsn_zero(31);
    DOPB_viol(0) <= ViolationB xor DOPB_zd(0) xor DOPB_clsn_zero(0);
    DOPB_viol(1) <= ViolationB xor DOPB_zd(1) xor DOPB_clsn_zero(1);
    DOPB_viol(2) <= ViolationB xor DOPB_zd(2) xor DOPB_clsn_zero(2);
    DOPB_viol(3) <= ViolationB xor DOPB_zd(3) xor DOPB_clsn_zero(3);

    wait on ADDRA_dly, ADDRB_dly, CLKA_dly, CLKB_dly, DIA_dly, DIB_dly, DIPA_dly, DIPB_dly, ENA_dly, ENB_dly, GSR_ipd, GSR_CLKA_dly, GSR_CLKB_dly, SSRA_dly, SSRB_dly, WEA_dly, WEB_dly;
  end process VITALBehavior;
----- ###############################################################################

----- Port A
   prcs_output:process (DOA_viol, DOPA_viol, DOB_viol, DOPB_viol)

    variable ENA_dly_sampled   : std_ulogic                      := 'X';
    variable ENB_dly_sampled   : std_ulogic                      := 'X';


    variable DOA_GlitchData0  : VitalGlitchDataType;
    variable DOA_GlitchData1  : VitalGlitchDataType;
    variable DOA_GlitchData2  : VitalGlitchDataType;
    variable DOA_GlitchData3  : VitalGlitchDataType;
    variable DOA_GlitchData4  : VitalGlitchDataType;
    variable DOA_GlitchData5  : VitalGlitchDataType;
    variable DOA_GlitchData6  : VitalGlitchDataType;
    variable DOA_GlitchData7  : VitalGlitchDataType;
    variable DOA_GlitchData8  : VitalGlitchDataType;
    variable DOA_GlitchData9  : VitalGlitchDataType;
    variable DOA_GlitchData10  : VitalGlitchDataType;
    variable DOA_GlitchData11  : VitalGlitchDataType;
    variable DOA_GlitchData12  : VitalGlitchDataType;
    variable DOA_GlitchData13  : VitalGlitchDataType;
    variable DOA_GlitchData14  : VitalGlitchDataType;
    variable DOA_GlitchData15  : VitalGlitchDataType;
    variable DOA_GlitchData16  : VitalGlitchDataType;
    variable DOA_GlitchData17  : VitalGlitchDataType;
    variable DOA_GlitchData18  : VitalGlitchDataType;
    variable DOA_GlitchData19  : VitalGlitchDataType;
    variable DOA_GlitchData20  : VitalGlitchDataType;
    variable DOA_GlitchData21  : VitalGlitchDataType;
    variable DOA_GlitchData22  : VitalGlitchDataType;
    variable DOA_GlitchData23  : VitalGlitchDataType;
    variable DOA_GlitchData24  : VitalGlitchDataType;
    variable DOA_GlitchData25  : VitalGlitchDataType;
    variable DOA_GlitchData26  : VitalGlitchDataType;
    variable DOA_GlitchData27  : VitalGlitchDataType;
    variable DOA_GlitchData28  : VitalGlitchDataType;
    variable DOA_GlitchData29  : VitalGlitchDataType;
    variable DOA_GlitchData30  : VitalGlitchDataType;
    variable DOA_GlitchData31  : VitalGlitchDataType;
    variable DOPA_GlitchData0 : VitalGlitchDataType;
    variable DOPA_GlitchData1 : VitalGlitchDataType;
    variable DOPA_GlitchData2 : VitalGlitchDataType;
    variable DOPA_GlitchData3 : VitalGlitchDataType;

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

   begin

    ENA_dly_sampled   := ENA_dly;
    ENB_dly_sampled   := ENB_dly;

    VitalPathDelay01 (
      OutSignal     => DOA(0),
      GlitchData    => DOA_GlitchData0,
      OutSignalName => "DOA(0)",
      OutTemp       => DOA_viol(0),
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
      OutTemp       => DOA_viol(1),
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
      OutTemp       => DOA_viol(2),
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
      OutTemp       => DOA_viol(3),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(3), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(3), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(4),
      GlitchData    => DOA_GlitchData4,
      OutSignalName => "DOA(4)",
      OutTemp       => DOA_viol(4),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(4), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(4), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(5),
      GlitchData    => DOA_GlitchData5,
      OutSignalName => "DOA(5)",
      OutTemp       => DOA_viol(5),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(5), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(5), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(6),
      GlitchData    => DOA_GlitchData6,
      OutSignalName => "DOA(6)",
      OutTemp       => DOA_viol(6),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(6), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(6), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(7),
      GlitchData    => DOA_GlitchData7,
      OutSignalName => "DOA(7)",
      OutTemp       => DOA_viol(7),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(7), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(7), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(8),
      GlitchData    => DOA_GlitchData8,
      OutSignalName => "DOA(8)",
      OutTemp       => DOA_viol(8),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(8), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(8), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(9),
      GlitchData    => DOA_GlitchData9,
      OutSignalName => "DOA(9)",
      OutTemp       => DOA_viol(9),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(9), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(9), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(10),
      GlitchData    => DOA_GlitchData10,
      OutSignalName => "DOA(10)",
      OutTemp       => DOA_viol(10),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(10), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(10), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(11),
      GlitchData    => DOA_GlitchData11,
      OutSignalName => "DOA(11)",
      OutTemp       => DOA_viol(11),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(11), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(11), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(12),
      GlitchData    => DOA_GlitchData12,
      OutSignalName => "DOA(12)",
      OutTemp       => DOA_viol(12),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(12), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(12), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(13),
      GlitchData    => DOA_GlitchData13,
      OutSignalName => "DOA(13)",
      OutTemp       => DOA_viol(13),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(13), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(13), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(14),
      GlitchData    => DOA_GlitchData14,
      OutSignalName => "DOA(14)",
      OutTemp       => DOA_viol(14),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(14), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(14), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(15),
      GlitchData    => DOA_GlitchData15,
      OutSignalName => "DOA(15)",
      OutTemp       => DOA_viol(15),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(15), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(15), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(16),
      GlitchData    => DOA_GlitchData16,
      OutSignalName => "DOA(16)",
      OutTemp       => DOA_viol(16),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(16), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(16), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(17),
      GlitchData    => DOA_GlitchData17,
      OutSignalName => "DOA(17)",
      OutTemp       => DOA_viol(17),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(17), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(17), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(18),
      GlitchData    => DOA_GlitchData18,
      OutSignalName => "DOA(18)",
      OutTemp       => DOA_viol(18),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(18), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(18), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(19),
      GlitchData    => DOA_GlitchData19,
      OutSignalName => "DOA(19)",
      OutTemp       => DOA_viol(19),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(19), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(19), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(20),
      GlitchData    => DOA_GlitchData20,
      OutSignalName => "DOA(20)",
      OutTemp       => DOA_viol(20),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(20), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(20), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(21),
      GlitchData    => DOA_GlitchData21,
      OutSignalName => "DOA(21)",
      OutTemp       => DOA_viol(21),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(21), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(21), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(22),
      GlitchData    => DOA_GlitchData22,
      OutSignalName => "DOA(22)",
      OutTemp       => DOA_viol(22),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(22), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(22), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(23),
      GlitchData    => DOA_GlitchData23,
      OutSignalName => "DOA(23)",
      OutTemp       => DOA_viol(23),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(23), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(23), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(24),
      GlitchData    => DOA_GlitchData24,
      OutSignalName => "DOA(24)",
      OutTemp       => DOA_viol(24),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(24), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(24), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(25),
      GlitchData    => DOA_GlitchData25,
      OutSignalName => "DOA(25)",
      OutTemp       => DOA_viol(25),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(25), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(25), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(26),
      GlitchData    => DOA_GlitchData26,
      OutSignalName => "DOA(26)",
      OutTemp       => DOA_viol(26),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(26), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(26), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(27),
      GlitchData    => DOA_GlitchData27,
      OutSignalName => "DOA(27)",
      OutTemp       => DOA_viol(27),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(27), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(27), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(28),
      GlitchData    => DOA_GlitchData28,
      OutSignalName => "DOA(28)",
      OutTemp       => DOA_viol(28),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(28), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(28), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(29),
      GlitchData    => DOA_GlitchData29,
      OutSignalName => "DOA(29)",
      OutTemp       => DOA_viol(29),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(29), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(29), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(30),
      GlitchData    => DOA_GlitchData30,
      OutSignalName => "DOA(30)",
      OutTemp       => DOA_viol(30),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(30), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(30), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOA(31),
      GlitchData    => DOA_GlitchData31,
      OutSignalName => "DOA(31)",
      OutTemp       => DOA_viol(31),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOA(31), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOA(31), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOPA(0),
      GlitchData    => DOPA_GlitchData0,
      OutSignalName => "DOPA(0)",
      OutTemp       => DOPA_viol(0),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOPA(0), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1' )),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOPA(0), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOPA(1),
      GlitchData    => DOPA_GlitchData1,
      OutSignalName => "DOPA(1)",
      OutTemp       => DOPA_viol(1),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOPA(1), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1' )),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOPA(1), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOPA(2),
      GlitchData    => DOPA_GlitchData2,
      OutSignalName => "DOPA(2)",
      OutTemp       => DOPA_viol(2),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOPA(2), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1' )),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOPA(2), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
    VitalPathDelay01 (
      OutSignal     => DOPA(3),
      GlitchData    => DOPA_GlitchData3,
      OutSignalName => "DOPA(3)",
      OutTemp       => DOPA_viol(3),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOPA(3), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1' )),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOPA(3), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);

----- Port B
    VitalPathDelay01 (
      OutSignal     => DOB(0),
      GlitchData    => DOB_GlitchData0,
      OutSignalName => "DOB(0)",
      OutTemp       => DOB_viol(0),
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
      OutTemp       => DOB_viol(1),
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
      OutTemp       => DOB_viol(2),
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
      OutTemp       => DOB_viol(3),
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
      OutTemp       => DOB_viol(4),
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
      OutTemp       => DOB_viol(5),
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
      OutTemp       => DOB_viol(6),
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
      OutTemp       => DOB_viol(7),
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
      OutTemp       => DOB_viol(8),
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
      OutTemp       => DOB_viol(9),
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
      OutTemp       => DOB_viol(10),
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
      OutTemp       => DOB_viol(11),
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
      OutTemp       => DOB_viol(12),
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
      OutTemp       => DOB_viol(13),
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
      OutTemp       => DOB_viol(14),
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
      OutTemp       => DOB_viol(15),
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
      OutTemp       => DOB_viol(16),
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
      OutTemp       => DOB_viol(17),
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
      OutTemp       => DOB_viol(18),
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
      OutTemp       => DOB_viol(19),
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
      OutTemp       => DOB_viol(20),
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
      OutTemp       => DOB_viol(21),
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
      OutTemp       => DOB_viol(22),
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
      OutTemp       => DOB_viol(23),
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
      OutTemp       => DOB_viol(24),
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
      OutTemp       => DOB_viol(25),
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
      OutTemp       => DOB_viol(26),
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
      OutTemp       => DOB_viol(27),
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
      OutTemp       => DOB_viol(28),
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
      OutTemp       => DOB_viol(29),
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
      OutTemp       => DOB_viol(30),
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
      OutTemp       => DOB_viol(31),
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
      OutTemp       => DOPB_viol(0),
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
      OutTemp       => DOPB_viol(1),
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
      OutTemp       => DOPB_viol(2),
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
      OutTemp       => DOPB_viol(3),
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_DOPB(3), (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_DOB(3), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
   end process prcs_output;

end X_RAMB16BWE_V;

-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  Configuration Simulation Model
-- /___/   /\     Filename : x_sim_config_s3a.vhd
-- \   \  /  \    Timestamp : 
--  \___\/\___\
--
-- Revision:
--    03/07/07 - Initial version.
--    06/11/07 - Change DEVICE_ID to bit vector (CR441606).
-- End Revision

----- CELL X_SIM_CONFIG_S3A  -----
library IEEE;
use IEEE.std_logic_1164.all;

library IEEE;
use IEEE.VITAL_Timing.all;

library STD;
use STD.TEXTIO.all;

library simprim;
use simprim.VPACKAGE.all;
use simprim.VCOMPONENTS.all;

entity X_SIM_CONFIG_S3A is
  generic (
-- begining timing generic
    TimingChecksOn : boolean := true;
    InstancePath : string := "*";
    Xon : boolean := true;
    MsgOn : boolean := false;
    LOC : string  := "UNPLACED";    

-- end_timing generic

    DEVICE_ID : bit_vector := X"00000000"

    );

  port (
                   CSOB : out std_ulogic := '1';
                   DONE : inout std_ulogic;
                   CCLK : in  std_ulogic := '0';
                   D : inout std_logic_vector(7 downto 0);
                   DCMLOCK : in  std_ulogic := '0';
                   CSIB : in  std_ulogic := '0';
                   INITB : inout std_ulogic := 'H';
                   M : in  std_logic_vector(2 downto 0) := "000";
                   PROGB : in  std_ulogic := '0';
                   RDWRB : in  std_ulogic := '0'
                   );
 
  attribute VITAL_LEVEL0 of X_SIM_CONFIG_S3A : entity is true;

end X_SIM_CONFIG_S3A;

architecture X_SIM_CONFIG_S3A_V of X_SIM_CONFIG_S3A is

  function crc_next (
      crc_currf : in std_logic_vector(21 downto 0);
      crc_inputf : in std_logic_vector(21 downto 0)
      ) return  std_logic_vector 
   is
      variable i_crc : integer;
      variable crc_next_v : std_logic_vector(21 downto 0);
  begin
    i_crc := 21;
    for i in 21 downto 16 loop
       crc_next_v(i_crc) := crc_currf(i_crc-1) xor crc_inputf(i_crc);
        i_crc := i_crc -1;
    end loop;

    crc_next_v(15) := crc_currf(14) xor crc_inputf(15) xor crc_currf(21);

    i_crc := 14;
   for i in 14 downto 13 loop
       crc_next_v(i_crc) := crc_currf(i_crc-1) xor crc_inputf(i_crc);
       i_crc := i_crc -1;
   end loop;

   crc_next_v(12) := crc_currf(11) xor crc_inputf(12) xor crc_currf(21);

   i_crc := 11;
   for i in 11 downto 8 loop 
       crc_next_v(i_crc) := crc_currf(i_crc-1) xor crc_inputf(i_crc);
       i_crc := i_crc -1;
   end loop;

   crc_next_v(7) := crc_currf(6) xor crc_inputf(7) xor crc_currf(21);

   i_crc := 6;
   for i in 6 downto 1 loop 
       crc_next_v(i_crc) := crc_currf(i_crc-1) xor crc_inputf(i_crc);
       i_crc := i_crc -1;
   end loop;

   crc_next_v(0) :=  crc_inputf(0) xor crc_currf(21);

   return crc_next_v;
  end crc_next;

function bit_revers8 ( din8 : in std_logic_vector(7 downto 0)) 
                   return  std_logic_vector is 
  variable bit_rev8 : std_logic_vector(7 downto 0);
  begin
      bit_rev8(0) := din8(7);
      bit_rev8(1) := din8(6);
      bit_rev8(2) := din8(5);
      bit_rev8(3) := din8(4);
      bit_rev8(4) := din8(3);
      bit_rev8(5) := din8(2);
      bit_rev8(6) := din8(1);
      bit_rev8(7) := din8(0);

     return bit_rev8;
  end bit_revers8;


  constant cfg_Tprog : time := 300000 ps;   -- min PROG must be low, 300 ns
  constant cfg_Tpl : time :=   100000 ps;  -- max program latency us.
  constant STARTUP_PH0 : std_logic_vector(2 downto 0) := "000";
  constant STARTUP_PH1 : std_logic_vector(2 downto 0) := "001";
  constant STARTUP_PH2 : std_logic_vector(2 downto 0) := "010";
  constant STARTUP_PH3 : std_logic_vector(2 downto 0) := "011";
  constant STARTUP_PH4 : std_logic_vector(2 downto 0) := "100";
  constant STARTUP_PH5 : std_logic_vector(2 downto 0) := "101";
  constant STARTUP_PH6 : std_logic_vector(2 downto 0) := "110";
  constant STARTUP_PH7 : std_logic_vector(2 downto 0) := "111";
  signal GSR : std_ulogic := '1';
  signal GTS : std_ulogic := '1';
  signal GWE : std_ulogic := '0';
  signal cclk_in : std_ulogic;
  signal csi_b_in : std_ulogic;
  signal prog_b_in : std_ulogic;
  signal rdwr_b_in : std_ulogic;
  signal crc_err_flag_reg : std_ulogic := '0';
  signal crc_err_flag_tot : std_ulogic;
  signal mode_sample_flag : std_ulogic := '0';
  signal init_b_p : std_ulogic := '1';
  signal done_o : std_ulogic := '0';
  signal done_in : std_ulogic ;
  signal por_b : std_ulogic := '0';
  signal prog_b_t : std_ulogic;
  signal m_in : std_logic_vector(2 downto 0);
  signal mode_pin_in : std_logic_vector(2 downto 0) := "000";
  signal d_in : std_logic_vector(7 downto 0) := "00000000";
  signal d_out : std_logic_vector(7 downto 0) := "00000000";
  signal prog_pulse_low_edge : time := 0 ps;
  signal prog_pulse_low : time := 0 ps;
  signal wr_cnt : integer := 0;
  signal conti_data_cnt : integer := 0; 
  signal rd_data_cnt : integer := 0;
  signal abort_cnt : integer := 0;
  signal csbo_flag : std_ulogic := '0';
  signal pack_in_reg : std_logic_vector(15 downto 0) := X"0000";
  signal reg_addr : std_logic_vector(5 downto 0) := "000000";
  signal rd_reg_addr : std_logic_vector(5 downto 0) := "000000";
  signal  new_data_in_flag : std_ulogic := '0';
  signal wr_flag : std_ulogic := '0';
  signal rd_flag : std_ulogic := '0';
  signal cmd_wr_flag : std_ulogic := '0';
  signal cmd_rd_flag : std_ulogic := '0';
  signal bus_sync_flag : std_ulogic := '0';
  signal csi_sync : std_ulogic := '0';
  signal rd_sw_en : std_ulogic := '0';
  signal conti_data_flag : std_ulogic := '0';
  signal conti_data_flag_set : std_ulogic := '0';
  signal st_state :  std_logic_vector(2 downto 0) := STARTUP_PH0;
  signal nx_st_state :  std_logic_vector(2 downto 0) := STARTUP_PH0;
  signal startup_begin_flag : std_ulogic := '0';
  signal startup_end_flag : std_ulogic := '0';
  signal cmd_reg_new_flag : std_ulogic := '0'; 
  signal far_maj_min_flag : std_ulogic := '0';
  signal crc_reset : std_ulogic := '0';
  signal crc_rst : std_ulogic := '0';
  signal crc_ck : std_ulogic := '0';
  signal crc_err_flag : std_ulogic := '0';
  signal crc_en : std_ulogic := '0';
  signal desync_flag : std_ulogic := '0';
  signal  crc_curr : std_logic_vector(21 downto 0) := "0000000000000000000000";
  signal gwe_out : std_ulogic := '0';
  signal gts_out : std_ulogic := '1';
  signal d_o : std_logic_vector(7 downto 0) := "00000000";
  signal outbus : std_logic_vector(7 downto 0) := "00000000";
  signal reboot_set : std_ulogic := '0';
  signal gsr_set : std_ulogic := '0';
  signal  gts_usr_b : std_ulogic := '1';
  signal done_pin_drv : std_ulogic := '0';
  signal crc_bypass : std_ulogic := '0';
  signal reset_on_err : std_ulogic := '0';
  signal sync_timeout : std_ulogic := '0';
  signal crc_reg : std_logic_vector (31 downto 0); 
  signal idcode_reg : std_logic_vector (31 downto 0); 
  signal idcode_tmp : std_logic_vector (31 downto 0); 
  signal far_min_reg : std_logic_vector (15 downto 0);
  signal far_maj_reg : std_logic_vector (15 downto 0);
  signal fdri_reg    : std_logic_vector (15 downto 0);
  signal fdro_reg    : std_logic_vector (15 downto 0);
  signal ctl_reg     : std_logic_vector (15 downto 0);
  signal cmd_reg     : std_logic_vector (4 downto 0);
  signal general1_reg : std_logic_vector (15 downto 0);
  signal mask_reg    : std_logic_vector (15 downto 0);
  signal lout_reg    : std_logic_vector (15 downto 0);
  signal cor1_reg    : std_logic_vector (15 downto 0);
  signal cor2_reg    : std_logic_vector (15 downto 0);
  signal pwrdn_reg   : std_logic_vector (15 downto 0);
  signal flr_reg     : std_logic_vector (15 downto 0);
  signal snowplow_reg : std_logic_vector (15 downto 0);
  signal hc_opt_reg  : std_logic_vector (15 downto 0);
  signal csbo_reg    : std_logic_vector (15 downto 0);
  signal general2_reg : std_logic_vector (15 downto 0);
  signal mode_reg    : std_logic_vector (15 downto 0);
  signal pu_gwe_reg  : std_logic_vector (15 downto 0);
  signal pu_gts_reg  : std_logic_vector (15 downto 0);
  signal mfwr_reg    : std_logic_vector (15 downto 0);
  signal cclk_freq_reg : std_logic_vector (15 downto 0);
  signal seu_opt_reg : std_logic_vector (15 downto 0);
  signal exp_sign_reg : std_logic_vector (31 downto 0);
  signal rdbk_sign_reg : std_logic_vector (31 downto 0);
  signal shutdown_set : std_ulogic := '0';
  signal desynch_set : std_ulogic := '0';
  signal done_cycle_reg : std_logic_vector (2 downto 0) := "100";
  signal gts_cycle_reg : std_logic_vector (2 downto 0) := "101";
  signal gwe_cycle_reg : std_logic_vector (2 downto 0) := "110";
  signal ghigh_b : std_ulogic := '0';
  signal eos_startup : std_ulogic := '0';
  signal startup_set : std_ulogic := '0';
  signal startup_set_pulse  : std_logic_vector (1 downto 0) := "00";
  signal abort_out_en : std_ulogic := '0';
  signal id_error_flag : std_ulogic := '0';
  signal iprog_b : std_ulogic := '1';
  signal abort_flag_wr : std_ulogic := '0';
  signal abort_flag_rd : std_ulogic := '0';
  signal abort_status : std_logic_vector (7 downto 0) := "00000000";
  signal persist_en : std_ulogic := '0';
  signal rst_sync : std_ulogic := '0';
  signal  abort_dis: std_ulogic := '0';
  signal lock_cycle_reg : std_logic_vector (2 downto 0) := "000";
  signal rbcrc_no_pin : std_ulogic := '0';
  signal abort_flag_rst : std_ulogic := '0';
  signal gsr_st_out : std_ulogic := '1';
  signal gsr_cmd_out : std_ulogic := '0';
  signal d_o_en : std_ulogic := '0';
  signal stat_reg : std_logic_vector (15 downto 0) := X"0000";
  signal rst_intl : std_ulogic := '0';
  signal rw_en : std_ulogic := '0';
  signal gsr_out : std_ulogic;
  signal cfgerr_b_flag : std_ulogic;
  signal abort_flag : std_ulogic := '0';
  signal  downcont : std_logic_vector (27 downto 0)  := "0000000000000000000000000000";
  signal  downcont_int : integer := 0;
  signal type2_flag : std_ulogic := '0';
  signal rst_en : std_ulogic := '1';
  signal prog_b_a : std_ulogic := '1';
  signal csbo_b_out : std_ulogic := '1';
  signal dcm_locked : std_ulogic;
  signal d_out_en : std_ulogic := '0';
  signal device_id_reg : std_logic_vector (31 downto 0)  := TO_STDLOGICVECTOR(DEVICE_ID);


begin

    CSOB <= csbo_b_out;
    INITB <=  (not crc_err_flag_tot) when mode_sample_flag = '1' else init_b_p when init_b_p ='0' else 'H';
    DONE <= done_o;
    done_in <= DONE;


    cclk_in <= CCLK;
    dcm_locked <= DCMLOCK;
    csi_b_in <= CSIB;
    d_in <= D;
    D <=  d_out when d_out_en = '1' else "ZZZZZZZZ";

    m_in <= M;
    prog_b_in <= PROGB;
    rdwr_b_in <= RDWRB;
    

        INIPROC : process
        begin
          if (DEVICE_ID = X"00000000") then
             assert FALSE report "Attribute Syntax Error : The attribute DEVICE_ID on  X_SIM_CONFIG_S3A is not set." severity error;
          end if;
          wait;
        end process;



    GSR <= gsr_out;
    GTS <= gts_out;
    GWE <= gwe_out;
    csbo_b_out <= '0' when (csbo_flag= '1') else '1';
    cfgerr_b_flag <= rw_en and (not id_error_flag) and (not crc_err_flag_reg);
    crc_err_flag_tot <= id_error_flag or crc_err_flag_reg;
    d_out <= abort_status when (abort_out_en = '1') else outbus;
    d_out_en <= d_o_en;
    crc_en <=  '1';

    process (abort_out_en, csi_b_in, rdwr_b_in, rd_flag) begin
    if (abort_out_en='1') then
       d_o_en <= '1';
    else
       d_o_en <= rdwr_b_in and (not csi_b_in) and rd_flag;
    end if;
    end process;


    process  begin
      if (prog_b_in'event and prog_b_in = '0') then 
         rst_en <= '0';
         wait for cfg_Tprog;
         wait for 1 ps;
         rst_en <= '1';
      end if;
      wait on prog_b_in;
    end process;

  process  begin
   if (rising_edge(rst_en)) then
             init_b_p <= '0';
             wait until (rising_edge (prog_b_in));
             init_b_p <= '1' after cfg_Tpl;
   end if;
   wait on rst_en;
  end process;
      

  process  begin
    if (rst_en = '0') then
       prog_b_a <= '1';
    elsif (rising_edge(rst_en)) then 
       if (prog_b_in = '1' and prog_pulse_low=cfg_Tprog) then 
           prog_b_a <= '0';
           wait for 500 ps;
           prog_b_a <= '1';
       elsif (prog_b_in = '0') then
          prog_b_a <= '0';
          wait until (rising_edge(prog_b_in));
          prog_b_a <= '1';
       end if;
    end if;
   wait on rst_en, prog_b_in;
  end process;

  process 
  begin
    por_b <= '0';
    por_b <=  '1' after 400 ns;
  wait;
  end process;

  prog_b_t <= prog_b_a  and iprog_b  and  por_b;

  rst_intl <=  '0' when (prog_b_t='0') else '1';

  process (INITB, prog_b_t)
    variable Message : line;
  begin
   if (falling_edge (prog_b_t)) then
      mode_sample_flag <= '0';
   elsif (rising_edge(INITB)) then
      if (mode_sample_flag = '0') then
        if(prog_b_t = '1') then
           mode_pin_in <= m_in;
           mode_sample_flag <= '1' after 1 ps;
           if (m_in /= "110") then
              Write ( Message, string'(" Error: input M is "));
              Write ( Message, string'(SLV_TO_STR(m_in)));
              Write ( Message, string'(" . Only Slave SelectMAP mode M=110 supported on X_SIM_CONFIG_S3A."));
              assert false report Message.all severity error;
              DEALLOCATE (Message);
           end if;   
        elsif (NOW > 0 ps) then
            assert false report "Error: PROGB is not high when INITB goes high on X_SIM_CONFIG_S3A." severity error;
       end if;
    end if;
   end if;
  end process;
           

  process (m_in) begin
    if (mode_sample_flag = '1' and persist_en = '1') then
       assert false report "Error : Mode pine M[2:0] changed after rising edge of INITB on X_SIM_CONFIG_S3A." severity error;
    end if;
  end process;

  prog_pulse_P : process (prog_b_in)
     variable prog_pulse_low : time;
     variable Message : line;
  begin
    if (falling_edge (prog_b_in)) then
       prog_pulse_low_edge <= NOW;
    else
      if (NOW > 0 ps ) then
         prog_pulse_low := NOW - prog_pulse_low_edge;
         if (prog_pulse_low < cfg_Tprog ) then
             Write ( Message, string'(" Error: Low time of PROGB is less than required minimum Tprogram time "));
             Write ( Message, prog_pulse_low);
             Write ( Message, string'(" ."));
             assert false report Message.all severity error;
         end if;
      end if;
    end if;
  end process;


     rw_en <= '1' when ((mode_sample_flag = '1') and  (csi_b_in = '0')) else  '0';
     desync_flag <= (not rst_intl) or desynch_set or crc_err_flag or id_error_flag;
 
   process (cclk_in) begin
   if (rising_edge(cclk_in)) then
       csi_sync <= csi_b_in;
     end if;
   end process;
 
   process (cclk_in, rdwr_b_in) begin
      if (rdwr_b_in = '0') then
           rd_sw_en <= '0';
      elsif (rising_edge(cclk_in)) then
           if (csi_sync = '1' and rdwr_b_in = '1') then
              rd_sw_en <= '1';
           end if;
      end if;
   end process;


    bus_sync_p : process (cclk_in, desync_flag)
      variable tmp_byte  : std_logic_vector (7 downto 0);
    begin
      if (desync_flag = '1') then
          pack_in_reg <= "0000000000000000";
          new_data_in_flag <= '0';
          bus_sync_flag <= '0';
          wr_cnt <= 0;
          wr_flag <= '0';
          rd_flag <= '0';
      elsif (rising_edge(cclk_in)) then
       if (rw_en  =  '1' ) then
         if (rdwr_b_in  =  '0') then
           wr_flag <= '1';
           rd_flag <= '0';
               tmp_byte := bit_revers8(d_in(7 downto 0));
               if (bus_sync_flag  =  '0') then
                  if (pack_in_reg(7 downto 0) = "10101010" and tmp_byte = "10011001") then
                          bus_sync_flag <= '1';
                          new_data_in_flag <= '0';
                          wr_cnt <= 0;
                   else 
                      pack_in_reg(7 downto 0) <= tmp_byte;
                   end if;
               else 
                 if (wr_cnt  =  0) then
                    pack_in_reg(15 downto 8) <= tmp_byte;
                     new_data_in_flag <= '0';
                     wr_cnt <=  1;
                 elsif (wr_cnt  =  1) then
                     pack_in_reg(7 downto 0) <= tmp_byte;
                     new_data_in_flag <= '1';
                     wr_cnt <= 0;
                 end if;
             end if;
        else                      --rdwr_b_in <= '1'
            wr_flag <= '0';
            new_data_in_flag <= '0';
            if (rd_sw_en = '1') then
               rd_flag <= '1';
            end if;
       end if;
     else                        --rw_en <= '0'
            wr_flag <= '0';
            rd_flag <= '0';
            new_data_in_flag <= '0';
     end if;
    end if;
   end process;
           
   pack_decode_p :  process (cclk_in, rst_intl) 
      variable tmp_v : std_logic_vector(5 downto 0);
      variable tmp_v28 : std_logic_vector(27 downto 0);
      variable idcode_tmp : std_logic_vector(31 downto 0);
      variable message_line : line;
      variable csbo_cnt : integer := 0;
      variable crc_new : std_logic_vector(21 downto 0) := "0000000000000000000000";
      variable crc_input : std_logic_vector(21 downto 0) := "0000000000000000000000";
   begin
      if (rst_intl  =  '0') then
         conti_data_flag <= '0';
         conti_data_cnt <= 0;
         cmd_wr_flag <= '0';
         cmd_rd_flag <= '0';
         id_error_flag <= '0';
         far_maj_min_flag <= '0';
         cmd_reg_new_flag <= '0';
         crc_curr(21 downto 0) <= "0000000000000000000000";
         crc_ck <= '0';
         csbo_cnt := 0;
         csbo_flag <= '0';
         downcont <= "0000000000000000000000000000";
         downcont_int <= 0;
         rd_data_cnt <= 0;
      elsif (falling_edge(cclk_in)) then 
        if (crc_reset  =  '1' ) then
            crc_reg(31 downto 0) <= X"00000000";
            exp_sign_reg(31 downto 0) <= X"00000000";
            crc_ck <= '0';
            crc_curr(21 downto 0) <= "0000000000000000000000";
        end if;
        if (desynch_set = '1'  or  crc_err_flag = '1') then
           conti_data_flag <= '0';
           conti_data_cnt <= 0;
           cmd_wr_flag <= '0';
           cmd_rd_flag <= '0';
           far_maj_min_flag <= '0';
           cmd_reg_new_flag <= '0';
           crc_ck <= '0';
           csbo_cnt := 0;
           csbo_flag <= '0';
         downcont <= "0000000000000000000000000000";
         downcont_int <= 0;
           rd_data_cnt <= 0;
        end if;

        if (new_data_in_flag = '1'  and  wr_flag = '1') then
           if (conti_data_flag  =  '1' ) then
             if (type2_flag  =  '0') then
               case (reg_addr) is
               when "000000"  =>      if (conti_data_cnt = 1) then
                             crc_reg(15 downto 0) <= pack_in_reg;
                             crc_ck <= '1';
                          elsif (conti_data_cnt = 2) then
                             crc_reg(31 downto 16) <= pack_in_reg;
                             crc_ck <= '0';
                          end if;
               when "000001"  =>      if (conti_data_cnt = 2) then
                              far_maj_reg <= pack_in_reg;
                              far_maj_min_flag <= '1';
                           elsif (conti_data_cnt = 1) then
                               if (far_maj_min_flag  = '1') then
                                  far_min_reg <= pack_in_reg;
                                  far_maj_min_flag <= '0';
                               else
                                  far_maj_reg <= pack_in_reg;
                               end if;
                           end if;
               when "000010"  =>      far_min_reg <= pack_in_reg;
               when "000011"  =>      fdri_reg <= pack_in_reg;
               when "000101"  =>      cmd_reg <= pack_in_reg(4 downto 0);
               when "000110"  =>      ctl_reg <= (pack_in_reg and  (not mask_reg)) or (ctl_reg and mask_reg);
               when "000111"  =>      mask_reg <= pack_in_reg;
               when "001001"  =>      lout_reg <= pack_in_reg;
               when "001010"  =>      cor1_reg <= pack_in_reg;
               when "001011"  =>      cor2_reg <= pack_in_reg;
               when "001100"  =>      pwrdn_reg <= pack_in_reg;
               when "001101"  =>      flr_reg <= pack_in_reg;
               when "001110"  =>      
                          if (conti_data_cnt = 1) then
                             idcode_reg(15 downto 0) <= pack_in_reg;
                             idcode_tmp := (idcode_reg(31 downto 16) & pack_in_reg); 
                             if (idcode_tmp(27 downto 0)  /=  device_id_reg(27 downto 0)) then
                                id_error_flag <= '1';
                                write(message_line, string'("Error : written value to IDCODE register is "));
                                write(message_line, string'(SLV_TO_STR(idcode_tmp)));
                                write(message_line, string'(" which does not match DEVICE ID "));
                                write(message_line, string'(SLV_TO_STR(device_id_reg)));
                                write(message_line, string'("."));
                                assert false report message_line.all  severity error;
                                DEALLOCATE(message_line);
                             else
                                id_error_flag <= '0';
                             end if;
                          elsif (conti_data_cnt = 2) then
                             idcode_reg(31 downto 16) <= pack_in_reg;
                          end if;
                          
               when "001111"  =>      snowplow_reg <= pack_in_reg;
               when "010000"  =>      hc_opt_reg <= pack_in_reg;
               when "010010"  =>      csbo_reg <= pack_in_reg; 
               when "010011"  =>      general1_reg <= pack_in_reg;
               when "010100"  =>      general2_reg <= pack_in_reg;
               when "010101"  =>      mode_reg <= pack_in_reg;
               when "010110"  =>      pu_gwe_reg <= pack_in_reg;
               when "010111"  =>      pu_gts_reg <= pack_in_reg;
               when "011000"  =>      mfwr_reg <= pack_in_reg;
               when "011001"  =>      cclk_freq_reg <= pack_in_reg;
               when "011010"  =>      seu_opt_reg <= pack_in_reg;
               when "011011"  =>      if (conti_data_cnt = 1) then
                                        exp_sign_reg(15 downto 0) <= pack_in_reg;
                                      elsif (conti_data_cnt = 2) then
                                        exp_sign_reg(31 downto 16) <= pack_in_reg;
                                      end if;
               when others => NULL;
               end case;

             if (reg_addr  =  "000101") then
                 cmd_reg_new_flag <= '1';
             else
                 cmd_reg_new_flag <= '0';
             end if;

             if (crc_en  =  '1') then
               if ((reg_addr  =  "000101") and  (pack_in_reg(4 downto 0)  =  "00111")) then
                    
                   crc_curr(21 downto 0) <= "0000000000000000000000";
               else 
                  if ((reg_addr /= "000100") and (reg_addr /= "001000") and (reg_addr /= "011100") and 
                  (reg_addr /= "000000") and (reg_addr /= "001001") and  (reg_addr  /= "010010")) then
                     crc_input(21 downto 0) := (reg_addr(5 downto 0) & pack_in_reg); 
                     crc_new(21 downto 0) := crc_next(crc_curr, crc_input);
                     crc_curr(21 downto 0) <= crc_new;
                   end if;
               end if;
             end if;
             else      -- type2_flag
                if (conti_data_cnt  = 2) then
                   downcont(27 downto 16) <= pack_in_reg(11 downto 0);
                elsif (conti_data_cnt  = 1) then
                   downcont(15 downto 0) <= pack_in_reg;
                   tmp_v28 := (downcont(27 downto 16) & pack_in_reg );
                   downcont_int <= SLV_TO_INT(tmp_v28);
                end if;
             end if;

             if (conti_data_cnt <= 1) then
                conti_data_cnt <= 0;
                type2_flag <= '0';
             else
                conti_data_cnt <= conti_data_cnt - 1;
             end if;
           else               --if (conti_data_flag  =  '0' )
             if ( downcont_int >= 1) then
                   if (crc_en  =  '1') then
                     crc_input(21 downto 0) := ("000011" & pack_in_reg);  --FDRI address plus data
                     crc_new(21 downto 0) := crc_next(crc_curr, crc_input);
                     crc_curr(21 downto 0) <= crc_new;
                   end if;
             end if;

             if ((pack_in_reg(15 downto 13) /= "001") and  (downcont_int  =  0)) then
--                assert false report "Warning : only Type 1 Packet supported on X_SIM_CONFIG_S3A." 
--                 severity warning;
                cmd_wr_flag <= '0';
                type2_flag <= '1';
                conti_data_flag <= '1';
                conti_data_cnt <= 2;
             else
                if ((pack_in_reg(12 downto 11) = "01") and  (downcont_int = 0)) then
                    if (pack_in_reg(4 downto 0) /= "00000") then
                       cmd_rd_flag <= '1';
                       cmd_wr_flag <= '0';
                       tmp_v := (pack_in_reg(4 downto 0) & '0');
--                       rd_data_cnt <= SLV_TO_INT(SLV=>tmp_v);
                       rd_data_cnt <= 4;
                       conti_data_cnt <= 0;
                       conti_data_flag <= '0';
                       rd_reg_addr <= pack_in_reg(10 downto 5);
                    end if;
                elsif ((pack_in_reg(12 downto 11) = "10") and (downcont_int = 0)) then
                    if (pack_in_reg(15 downto 5)  =  "00110010010") then
                           csbo_reg <= pack_in_reg;
                           csbo_cnt := SLV_TO_INT(SLV=>pack_in_reg(4 downto 0));
                           csbo_flag <= '1';
                           conti_data_flag <= '0';
                           reg_addr <= pack_in_reg(10 downto 5);
                           cmd_wr_flag <= '1';
                           conti_data_cnt <= 0;
                    elsif (pack_in_reg(4 downto 0)  /=  "00000") then
                       cmd_wr_flag <= '1';
                       conti_data_flag <= '1';
                       conti_data_cnt <= SLV_TO_INT(SLV=>pack_in_reg(4 downto 0));
                       reg_addr <= pack_in_reg(10 downto 5);
                    end if;
                else 
                    cmd_wr_flag <= '0';
                    conti_data_flag <= '0';
                    conti_data_cnt <= 0;
                end if;
             end if;
             cmd_reg_new_flag <= '0';
             crc_ck <= '0';
          end if;   -- if (conti_data_flag  =  '0' ) 

         if (csbo_cnt /= 0 ) then 
             if (csbo_flag = '1') then
              csbo_cnt := csbo_cnt - 1;
              end if;
          else
              csbo_flag <= '0';
         end if;


          if (conti_data_cnt  =  1) then
                conti_data_flag <= '0';
          end if; 
      end if;

      if (rw_en  = '1') then
         if (rd_data_cnt  =  1) then
            rd_data_cnt <= 0;
         elsif (rd_data_cnt = 0 and  rd_flag = '1') then
               cmd_rd_flag <= '0';        
         elsif ((cmd_rd_flag = '1')  and  (rd_flag = '1')) then
             rd_data_cnt <= rd_data_cnt - 1;
         end if;
 
         if ((downcont_int >= 1) and (conti_data_flag  =  '0') and (new_data_in_flag = '1') and (wr_flag = '1')) then
              downcont_int <= downcont_int - 1;
         end if;
     end if;
   end if;
   end process;

   rd_back_p : process ( cclk_in, rst_intl) begin
    if (rst_intl  = '0') then
         outbus <= "00000000";
    elsif (rising_edge(cclk_in)) then
        if (cmd_rd_flag  =  '1'  and  rdwr_b_in  =  '1') then
               case (rd_reg_addr) is
               when "000000" =>      if (rd_data_cnt = 1) then
                             outbus <= crc_reg(7 downto 0);
                          elsif (rd_data_cnt = 2) then
                             outbus <= crc_reg(15 downto 8);
                          elsif (rd_data_cnt = 3) then
                             outbus <= crc_reg(23 downto 16);
                          elsif (rd_data_cnt = 4) then
                             outbus <= crc_reg(31 downto 24);
                          end if;
               when "001000" =>      if (rd_data_cnt = 1) then
                             outbus <= stat_reg(7 downto 0);
                          elsif (rd_data_cnt = 2) then
                             outbus <= stat_reg(15 downto 8);
                          elsif (rd_data_cnt = 3) then
                             outbus <= stat_reg(7 downto 0);
                          elsif (rd_data_cnt = 4) then
                             outbus <= stat_reg(15 downto 8);
                          end if;
               when "001110" =>      if (rd_data_cnt = 1) then
                             outbus <= idcode_reg(7 downto 0);
                          elsif (rd_data_cnt = 2) then
                             outbus <= idcode_reg(15 downto 8);
                          elsif (rd_data_cnt = 3) then
                             outbus <= idcode_reg(23 downto 16);
                          elsif (rd_data_cnt = 4) then
                             outbus <= idcode_reg(31 downto 24);
                          end if;
               when "011011" =>      if (rd_data_cnt = 1) then
                             outbus <= exp_sign_reg(7 downto 0);
                          elsif (rd_data_cnt = 2) then
                             outbus <= exp_sign_reg(15 downto 8);
                          elsif (rd_data_cnt = 3) then
                             outbus <= exp_sign_reg(23 downto 16);
                          elsif (rd_data_cnt = 4) then
                             outbus <= exp_sign_reg(31 downto 24);
                          end if;
               when others => NULL;
               end case;

       else
          outbus <= "00000000";
       end if;
     
   end if;
   end process;

        
     crc_rst <= crc_reset or (not rst_intl);

    process ( cclk_in,  crc_rst ) begin
     if (crc_rst = '1') then
         crc_err_flag <= '0';
     elsif (rising_edge(cclk_in)) then
        if (crc_ck = '1') then
          if (crc_bypass = '1') then
             if (crc_reg(31 downto 0)  /=  X"9876defc") then
                 crc_err_flag <= '1';
             else
                 crc_err_flag <= '0';
             end if;
          else 
            if (crc_curr(21 downto 0)  /=  crc_reg(21 downto 0)) then
                crc_err_flag <= '1';
            else
                 crc_err_flag <= '0';
            end if;
          end if;
       else
           crc_err_flag <= '0';
       end if;
    end if;
   end process;

    process ( crc_err_flag,  rst_intl,  bus_sync_flag) begin
     if (rst_intl  =  '0') then
         crc_err_flag_reg <= '0';
     elsif (rising_edge(crc_err_flag)) then
         crc_err_flag_reg <= '1';
     elsif (rising_edge(bus_sync_flag)) then
         crc_err_flag_reg <= '0';
     end if;
    end process;

    process ( cclk_in,  rst_intl) begin
    if (rst_intl  = '0') then
         startup_set <= '0';
         crc_reset  <= '0';
         gsr_set <= '0';
         shutdown_set <= '0';
         desynch_set <= '0';
         reboot_set <= '0';
         ghigh_b <= '0';
    elsif (rising_edge(cclk_in)) then
      if (cmd_reg_new_flag  = '1') then
         if (cmd_reg  =  "00011") then
             ghigh_b <= '1';
         elsif (cmd_reg  =  "01000") then
             ghigh_b <= '0';
         end if;

         if (cmd_reg  =  "00101") then
             startup_set <= '1';
         end if;
         if (cmd_reg  =  "00111") then
              crc_reset <= '1';
         end if;
         if (cmd_reg  =  "01010") then
              gsr_set <= '1';
         end if;
         if (cmd_reg  =  "01011") then
              shutdown_set <= '1';
         end if;
         if (cmd_reg  =  "01101") then
              desynch_set <= '1';
         end if;
         if (cmd_reg  =  "01110") then
             reboot_set <= '1';
         end if;
      else  
             startup_set <= '0';
              crc_reset <= '0';
              gsr_set <= '0';
              shutdown_set <= '0';
              desynch_set <= '0';
             reboot_set <= '0';
      end if;
    end if;
    end process;


   startup_set_pulse_p : process  begin
    if (rw_en  =  '0') then
       startup_set_pulse <= "00";
    elsif (rising_edge(startup_set)) then
      if (startup_set_pulse  =  "00") then
         startup_set_pulse <= "01";
      end if;
    elsif (rising_edge(desynch_set)) then
      if (startup_set_pulse  =  "01") then
          startup_set_pulse <= "11";
          wait until (rising_edge(cclk_in ));
          startup_set_pulse <= "00";
      end if;
    end if;
      wait on startup_set, desynch_set, rw_en;
    end process;


    process (ctl_reg) begin
      if (ctl_reg(3)  =  '1') then
         persist_en <= '1';
      else
         persist_en <= '0';
      end if;

      if (ctl_reg(0)  =  '1') then
         gts_usr_b <= '1';
      else
         gts_usr_b <= '0';
      end if;
    end process;

    process (cor1_reg) begin
      if (cor1_reg(2)  = '1') then
         done_pin_drv <= '1';
      else
         done_pin_drv <= '0';
      end if;

      if (cor1_reg(4)  =  '1') then
         crc_bypass <= '1';
      else
         crc_bypass <= '0';
      end if;
    end process;
    
    process (cor2_reg) begin
      if (cor2_reg(15)  = '1') then
        reset_on_err <= '1';
      else
        reset_on_err <= '0';
      end if;

      done_cycle_reg <= cor2_reg(11 downto 9);
      lock_cycle_reg <= cor2_reg(8 downto 6);
      gts_cycle_reg <= cor2_reg(5 downto 3);
      gwe_cycle_reg <= cor2_reg(2 downto 0);
    end process;


     stat_reg(15) <= sync_timeout;
     stat_reg(14) <= '0';
     stat_reg(13) <= DONE;
     stat_reg(12) <= INITB;
     stat_reg(11 downto 9) <= mode_pin_in;
     stat_reg(5) <= ghigh_b;
     stat_reg(4) <= gwe_out;
     stat_reg(3) <= gts_out;
     stat_reg(2) <= dcm_locked;
     stat_reg(1) <= id_error_flag;
     stat_reg(0) <= crc_err_flag_reg; 


    st_state_p : process ( cclk_in, rst_intl) begin
      if (rst_intl  =  '0') then
        st_state <= STARTUP_PH0;
        startup_begin_flag <= '0';
        startup_end_flag <= '0';
      elsif (rising_edge(cclk_in)) then
           if (nx_st_state  =  STARTUP_PH1) then
              startup_begin_flag <= '1';
              startup_end_flag <= '0';
           elsif (st_state  =  STARTUP_PH7) then
              startup_end_flag <= '1';
              startup_begin_flag <= '0';
           end if;
           if  ((lock_cycle_reg = "111") or (dcm_locked  =  '1') or (st_state /= lock_cycle_reg)) then
                st_state <= nx_st_state;
           else
              st_state <= st_state;
           end if;
      end if;
    end process;

    nx_st_state_p : process (st_state, startup_set_pulse, done_in ) begin
    if ((( st_state  =  done_cycle_reg) and (done_in /= '0')) or ( st_state /= done_cycle_reg)) then
      case (st_state) is
      when STARTUP_PH0  =>      if (startup_set_pulse  =  "11" ) then
                                     nx_st_state <= STARTUP_PH1;
                                else
                                     nx_st_state <= STARTUP_PH0;
                                end if;
      when STARTUP_PH1  =>      nx_st_state <= STARTUP_PH2;

      when STARTUP_PH2  =>      nx_st_state <= STARTUP_PH3;

      when STARTUP_PH3  =>      nx_st_state <= STARTUP_PH4;

      when STARTUP_PH4  =>      nx_st_state <= STARTUP_PH5;

      when STARTUP_PH5  =>      nx_st_state <= STARTUP_PH6;

      when STARTUP_PH6  =>      nx_st_state <= STARTUP_PH7;

      when STARTUP_PH7  =>      nx_st_state <= STARTUP_PH0;
      when others => NULL;
      end case;
   end if;
   end process;

    start_out_p : process ( cclk_in, rst_intl ) begin
      if (rst_intl  =  '0') then
          gwe_out <= '0';
          gts_out <= '1';
          eos_startup <= '0';
          gsr_st_out <= '1';
          done_o <= '0';
      elsif (rising_edge(cclk_in)) then

         if (nx_st_state  =  done_cycle_reg) then
            if (done_in  /=  '0' or done_pin_drv = '1') then
               done_o <= '1';
            else
               done_o <= 'H';
            end if;
         else
             if (done_in  /=  '0') then
                     done_o <= '1';
             end if;
         end if;

         if (nx_st_state  =  gwe_cycle_reg) then
             gwe_out <= '1';
         end if;

         if (nx_st_state  =  gts_cycle_reg) then
             gts_out <= '0';
         end if;

         if (nx_st_state  =  STARTUP_PH6) then
             gsr_st_out <= '0';
         end if;

         if (nx_st_state  =  STARTUP_PH7) then
            eos_startup <= '1';
         end if;

      end if;
    end process;


    gsr_out <= gsr_st_out or gsr_cmd_out;
     

    process (rdwr_b_in ,  rst_intl, abort_flag_rst , csi_b_in)
    begin
      if (rst_intl = '0'  or  abort_flag_rst = '1'  or  csi_b_in  =  '1') then
          abort_flag_wr <= '0';
      elsif (rising_edge(rdwr_b_in)) then 
        if (abort_dis  =  '0'  and  csi_b_in  =  '0') then
             if (NOW  /=  0 ps) then
               abort_flag_wr <= '1';
               assert false report " Warning : RDWRB changes when CS_B low, which causes Configuration abort on X_SIM_CONFIG_S3A."
               severity warning;
             end if;
        else
           abort_flag_wr <= '0';
        end if;
     end if;
    end process;

    process ( rdwr_b_in,  rst_intl,  abort_flag_rst,  csi_b_in) begin
      if (rst_intl = '0'  or   csi_b_in  =  '1'  or  abort_flag_rst = '1') then
          abort_flag_rd <= '0';
      elsif (falling_edge(rdwr_b_in)) then 
       if (abort_dis  =  '0'  and  csi_b_in  =  '0') then
         if (NOW  /=  0 ps) then
          abort_flag_rd <= '1';
          assert false report " Warning :  RDWRB changes when CS_B low, which causes Configuration abort on X_SIM_CONFIG_S3A."
          severity warning;
         end if;
       else
         abort_flag_rd <= '0';
       end if;
     end if;
    end process;

     abort_flag <= abort_flag_wr or abort_flag_rd;


    process ( cclk_in,  rst_intl) begin
      if (rst_intl  =  '0') then
         abort_cnt <= 0;
         abort_out_en <= '0';
      elsif (rising_edge(cclk_in)) then
         if ( abort_flag  = '1' ) then
             if (abort_cnt < 4) then
                 abort_cnt <= abort_cnt + 1;
                 abort_out_en <= '1';
             else 
                abort_flag_rst <= '1';
             end if;
         else 
                abort_cnt <=  0;
                abort_out_en <= '0';
                abort_flag_rst <= '0';
         end if;
    
         if (abort_cnt =  0) then
            abort_status <= (cfgerr_b_flag & bus_sync_flag &  "011111");
         elsif (abort_cnt =  1) then
            abort_status <= (cfgerr_b_flag & "1001111");
         elsif (abort_cnt =  2) then
            abort_status <= (cfgerr_b_flag & "0001111");
         elsif (abort_cnt =  3) then
            abort_status <= (cfgerr_b_flag & "0011111");
         end if;
      end if;
    end process;

end X_SIM_CONFIG_S3A_V;
