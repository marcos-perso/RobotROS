-- $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/vhdsclibs/data/simprims/virtex4/VITAL/Attic/x_gt11clk.vhd,v 1.11 2005/07/23 00:03:51 sranade Exp $
-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  11-Gigabit Transceiver Clock
-- /___/   /\     Filename : X_GT11CLK.vhd
-- \   \  /  \    Timestamp : Fri Jun 18 10:57:24 PDT 2004
--  \___\/\___\
--
-- Revision:
--    03/23/04 - Initial version.

----- CELL X_GT11CLK -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library IEEE;
use IEEE.VITAL_Timing.all;


entity X_GT11CLK is
generic (
        TimingChecksOn : boolean := TRUE;
        InstancePath   : string  := "*";
        Xon            : boolean := TRUE;
        MsgOn          : boolean := FALSE;
   LOC            : string  := "UNPLACED";
        
		REFCLKSEL : string := "MGTCLK";
		SYNCLK1OUTEN : string := "ENABLE";
		SYNCLK2OUTEN : string := "DISABLE";

        tipd_MGTCLKP : VitalDelayType01 :=  (0.0 ns, 0.0 ns);
        tipd_MGTCLKN : VitalDelayType01 :=  (0.0 ns, 0.0 ns);
        tipd_SYNCLK1IN : VitalDelayType01 :=  (0.0 ns, 0.0 ns);
        tipd_SYNCLK2IN : VitalDelayType01 :=  (0.0 ns, 0.0 ns);
        tipd_REFCLK : VitalDelayType01 :=  (0.0 ns, 0.0 ns);
        tipd_RXBCLK : VitalDelayType01 :=  (0.0 ns, 0.0 ns);        
--  clk-to-output path delays
        tpd_MGTCLKP_SYNCLK1OUT : VitalDelayType01 := (0.0 ns, 0.0 ns);
        tpd_SYNCLK1IN_SYNCLK1OUT : VitalDelayType01 := (0.0 ns, 0.0 ns);
        tpd_SYNCLK2IN_SYNCLK1OUT : VitalDelayType01 := (0.0 ns, 0.0 ns);
        tpd_REFCLK_SYNCLK1OUT : VitalDelayType01 := (0.0 ns, 0.0 ns);
        tpd_RXBCLK_SYNCLK1OUT : VitalDelayType01 := (0.0 ns, 0.0 ns);        
        tpd_MGTCLKP_SYNCLK2OUT : VitalDelayType01 := (0.0 ns, 0.0 ns);
        tpd_SYNCLK1IN_SYNCLK2OUT : VitalDelayType01 := (0.0 ns, 0.0 ns);
        tpd_SYNCLK2IN_SYNCLK2OUT : VitalDelayType01 := (0.0 ns, 0.0 ns);
        tpd_REFCLK_SYNCLK2OUT : VitalDelayType01 := (0.0 ns, 0.0 ns);
        tpd_RXBCLK_SYNCLK2OUT : VitalDelayType01 := (0.0 ns, 0.0 ns)        
  );

port (
		SYNCLK1OUT : out std_ulogic;
		SYNCLK2OUT : out std_ulogic;

		REFCLK : in std_ulogic;
		MGTCLKN : in std_ulogic;
		MGTCLKP : in std_ulogic;
		RXBCLK : in std_ulogic;
		SYNCLK1IN : in std_ulogic;
		SYNCLK2IN : in std_ulogic

     );
end X_GT11CLK;

architecture X_GT11CLK_V of X_GT11CLK is
signal mgtclk_out : std_ulogic;
signal mux_out : std_ulogic;

-- Input/Output Pin signals

        signal   MGTCLKP_ipd  :  std_ulogic;
        signal   MGTCLKN_ipd  :  std_ulogic;
        signal   SYNCLK1IN_ipd  :  std_ulogic;
        signal   SYNCLK2IN_ipd  :  std_ulogic;
        signal   REFCLK_ipd  :  std_ulogic;
        signal   RXBCLK_ipd  :  std_ulogic;

        signal   MGTCLKP_dly  :  std_ulogic;
        signal   MGTCLKN_dly  :  std_ulogic;
        signal   SYNCLK1IN_dly  :  std_ulogic;
        signal   SYNCLK2IN_dly  :  std_ulogic;
        signal   REFCLK_dly  :  std_ulogic;
        signal   RXBCLK_dly  :  std_ulogic;
begin
   WireDelay : block
       begin
              VitalWireDelay (MGTCLKP_ipd,MGTCLKP,tipd_MGTCLKP);
              VitalWireDelay (MGTCLKN_ipd,MGTCLKN,tipd_MGTCLKN);
              VitalWireDelay (SYNCLK1IN_ipd,SYNCLK1IN,tipd_SYNCLK1IN);
              VitalWireDelay (SYNCLK2IN_ipd,SYNCLK2IN,tipd_SYNCLK2IN);
              VitalWireDelay (REFCLK_ipd,REFCLK,tipd_REFCLK);
              VitalWireDelay (RXBCLK_ipd,RXBCLK,tipd_RXBCLK);              
       end block;

   MGTCLKP_dly <= MGTCLKP_ipd;
   MGTCLKN_dly <= MGTCLKN_ipd;
   SYNCLK1IN_dly <= SYNCLK1IN_ipd;
   SYNCLK2IN_dly <= SYNCLK2IN_ipd;
   RXBCLK_dly <= RXBCLK_ipd;
       
  gen_mgtclk_out : process
  begin
    if ((MGTCLKP_dly = '1') and (MGTCLKN_dly = '0')) then
      mgtclk_out <= MGTCLKP_dly;
    elsif ((MGTCLKP_dly = '0') and (MGTCLKN_dly = '1')) then
      mgtclk_out <= MGTCLKP_dly;       
    end if;
    wait on MGTCLKN_dly, MGTCLKP_dly;
  end process;
  
  INITPROC : process
    variable first_time : boolean := true;
     
  begin
    if (first_time = true) then
      if((REFCLKSEL = "MGTCLK") or (REFCLKSEL = "mgtclk")) then
      elsif((REFCLKSEL = "SYNCLK1IN") or (REFCLKSEL = "synclk1in")) then
      elsif((REFCLKSEL = "SYNCLK2IN") or (REFCLKSEL = "synclk2in")) then
      elsif((REFCLKSEL = "REFCLK") or (REFCLKSEL = "grefclk")) then
      elsif((REFCLKSEL = "RXBCLK") or (REFCLKSEL = "rxbclk")) then
      else
        assert FALSE report "Error : REFCLKSEL = is not MGTCLK, SYNCLK1IN, SYNCLK2IN, REFCLK, RXBCLK." severity error;
      end if;
      
      if((SYNCLK1OUTEN = "ENABLE") or (SYNCLK1OUTEN = "enable")) then
      elsif((SYNCLK1OUTEN = "DISABLE") or (SYNCLK1OUTEN = "disable")) then
      else
        assert FALSE report "Error : SYNCLK1OUTEN = is not ENABLE, DISABLE." severity error;
      end if;

      if((SYNCLK2OUTEN = "ENABLE") or (SYNCLK2OUTEN = "enable")) then
      elsif((SYNCLK2OUTEN = "DISABLE") or (SYNCLK2OUTEN = "disable")) then
      else
        assert FALSE report "Error : SYNCLK2OUTEN = is not ENABLE, DISABLE." severity error;
      end if;
      first_time := false;
    end if;
    if (mgtclk_out'event) then
      if((REFCLKSEL = "MGTCLK") or (REFCLKSEL = "mgtclk")) then
        mux_out <= mgtclk_out;
      end if;          
    end if;

    if (SYNCLK1IN_dly'event) then
      if((REFCLKSEL = "SYNCLK1IN") or (REFCLKSEL = "synclk1in")) then
        mux_out <= SYNCLK1IN_dly;
      end if;          
    end if;

    if (SYNCLK2IN_dly'event) then
      if((REFCLKSEL = "SYNCLK2IN") or (REFCLKSEL = "synclk2in")) then
        mux_out <= SYNCLK2IN_dly;
      end if;          
    end if;    

    if (REFCLK_dly'event) then
      if((REFCLKSEL = "REFCLK") or (REFCLKSEL = "refclk")) then
        mux_out <= REFCLK_dly;
      end if;      
    end if;

    if (RXBCLK_dly'event) then
      if((REFCLKSEL = "RXBCLK") or (REFCLKSEL = "RXBCLK")) then
        mux_out <= RXBCLK_dly;
      end if;          
    end if;    
    wait on mgtclk_out, SYNCLK1IN_dly, SYNCLK2IN_dly, REFCLK_dly, RXBCLK_dly;    
  end process INITPROC;
       
   TIMING : process
     variable  SYNCLK1OUT_out  :  std_ulogic;
     variable  SYNCLK2OUT_out  :  std_ulogic;
     
     variable  SYNCLK1OUT_GlitchData : VitalGlitchDataType;
     variable  SYNCLK2OUT_GlitchData : VitalGlitchDataType;
begin
--  Output-to-Clock path delay
    if ((SYNCLK1OUTEN = "ENABLE") or (SYNCLK1OUTEN = "enable")) then
      SYNCLK1OUT_out := mux_out;
      VitalPathDelay01
        (
          OutSignal     => SYNCLK1OUT,
          GlitchData    => SYNCLK1OUT_GlitchData,
          OutSignalName => "SYNCLK1OUT",
          OutTemp       => SYNCLK1OUT_OUT,
          Paths         => (0 => (MGTCLKP_dly'last_event, tpd_MGTCLKP_SYNCLK1OUT, ((REFCLKSEL = "MGTCLK") or (REFCLKSEL = "mgtclk"))),
                            1 => (SYNCLK1IN_dly'last_event, tpd_SYNCLK1IN_SYNCLK1OUT, ((REFCLKSEL = "SYNCLK1IN") or (REFCLKSEL = "synclk1in"))),
                            2 => (SYNCLK2IN_dly'last_event, tpd_SYNCLK2IN_SYNCLK1OUT, ((REFCLKSEL = "SYNCLK2IN") or (REFCLKSEL = "synclk2in"))),
                            3 => (REFCLK_dly'last_event, tpd_REFCLK_SYNCLK1OUT, ((REFCLKSEL = "REFCLK") or (REFCLKSEL = "grefclk"))),
                            4 => (RXBCLK_dly'last_event, tpd_RXBCLK_SYNCLK1OUT, ((REFCLKSEL = "RXBCLK") or (REFCLKSEL = "rxbclk")))
                            ),
          Mode          => VitalTransport,
          Xon           => false,
          MsgOn         => false,
          MsgSeverity   => WARNING
          );
      else
        SYNCLK1OUT <= 'Z';
      end if;

      if ((SYNCLK2OUTEN = "ENABLE") or (SYNCLK2OUTEN = "enable")) then
      SYNCLK2OUT_out := mux_out;        
        VitalPathDelay01
          (
            OutSignal     => SYNCLK2OUT,
            GlitchData    => SYNCLK2OUT_GlitchData,
            OutSignalName => "SYNCLK2OUT",
            OutTemp       => SYNCLK2OUT_OUT,
            Paths         => (0 => (MGTCLKP_dly'last_event, tpd_MGTCLKP_SYNCLK2OUT, ((REFCLKSEL = "MGTCLK") or (REFCLKSEL = "mgtclk"))),
                            1 => (SYNCLK1IN_dly'last_event, tpd_SYNCLK1IN_SYNCLK2OUT, ((REFCLKSEL = "SYNCLK1IN") or (REFCLKSEL = "synclk1in"))),
                            2 => (SYNCLK2IN_dly'last_event, tpd_SYNCLK2IN_SYNCLK2OUT, ((REFCLKSEL = "SYNCLK2IN") or (REFCLKSEL = "synclk2in"))),
                            3 => (REFCLK_dly'last_event, tpd_REFCLK_SYNCLK2OUT, ((REFCLKSEL = "REFCLK") or (REFCLKSEL = "grefclk"))),
                            4 => (RXBCLK_dly'last_event, tpd_RXBCLK_SYNCLK2OUT, ((REFCLKSEL = "RXBCLK") or (REFCLKSEL = "rxbclk")))
                            ),
            Mode          => VitalTransport,
            Xon           => false,
            MsgOn         => false,
            MsgSeverity   => WARNING
            );
        else
          SYNCLK2OUT <= 'Z';
        end if;
--  Wait signal (input/output pins)
        wait on mux_out;
   end process TIMING;       
end X_GT11CLK_V;
-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  Dual Data Rate Input D Flip-Flop
-- /___/   /\     Filename : X_IDDR.vhd
-- \   \  /  \    Timestamp : Fri Mar 26 08:18:20 PST 2004
--  \___\/\___\
--
-- Revision:
--    03/23/04 - Initial version.
--    05/30/06 - CR 232324 -- Added  timing checks for S/R wrt negedge CLK
-- End Revision


----- CELL X_IDDR -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;


library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.Vcomponents.all;
use simprim.VPACKAGE.all;

entity X_IDDR is

  generic(

      TimingChecksOn : boolean := true;
      InstancePath   : string  := "*";
      Xon            : boolean := true;
      MsgOn          : boolean := true;
      LOC            : string  := "UNPLACED";

--  VITAL input Pin path delay variables
      tipd_C    : VitalDelayType01 := (0 ps, 0 ps);
      tipd_CE   : VitalDelayType01 := (0 ps, 0 ps);
      tipd_D    : VitalDelayType01 := (0 ps, 0 ps);
      tipd_GSR  : VitalDelayType01 := (0 ps, 0 ps);
      tipd_R    : VitalDelayType01 := (0 ps, 0 ps);
      tipd_S    : VitalDelayType01 := (0 ps, 0 ps);

--  VITAL clk-to-output path delay variables
      tpd_C_Q1  : VitalDelayType01 := (100 ps, 100 ps);
      tpd_C_Q2  : VitalDelayType01 := (100 ps, 100 ps);

--  VITAL async rest-to-output path delay variables
      tpd_R_Q1 : VitalDelayType01 := (0 ps, 0 ps);
      tpd_R_Q2 : VitalDelayType01 := (0 ps, 0 ps);

--  VITAL async set-to-output path delay variables
      tpd_S_Q1 : VitalDelayType01 := (0 ps, 0 ps);
      tpd_S_Q2 : VitalDelayType01 := (0 ps, 0 ps);

--  VITAL GSR-to-output path delay variable
      tpd_GSR_Q1 : VitalDelayType01 := (0 ps, 0 ps);
      tpd_GSR_Q2 : VitalDelayType01 := (0 ps, 0 ps);


--  VITAL ticd & tisd variables
      ticd_C     : VitalDelayType   := 0 ps;
      tisd_D_C   : VitalDelayType   := 0 ps;
      tisd_CE_C  : VitalDelayType   := 0 ps;
      tisd_GSR_C : VitalDelayType   := 0 ps;
      tisd_R_C   : VitalDelayType   := 0 ps;
      tisd_S_C   : VitalDelayType   := 0 ps;

--  VITAL Setup/Hold delay variables
      tsetup_CE_C_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_CE_C_negedge_posedge : VitalDelayType := 0 ps;
      tsetup_CE_C_posedge_negedge : VitalDelayType := 0 ps;
      tsetup_CE_C_negedge_negedge : VitalDelayType := 0 ps;
      thold_CE_C_posedge_posedge  : VitalDelayType := 0 ps;
      thold_CE_C_negedge_posedge  : VitalDelayType := 0 ps;
      thold_CE_C_posedge_negedge : VitalDelayType := 0 ps;
      thold_CE_C_negedge_negedge : VitalDelayType := 0 ps;

      tsetup_D_C_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_D_C_negedge_posedge : VitalDelayType := 0 ps;
      tsetup_D_C_posedge_negedge : VitalDelayType := 0 ps;
      tsetup_D_C_negedge_negedge : VitalDelayType := 0 ps;
      thold_D_C_posedge_posedge  : VitalDelayType := 0 ps;
      thold_D_C_negedge_posedge  : VitalDelayType := 0 ps;
      thold_D_C_posedge_negedge : VitalDelayType := 0 ps;
      thold_D_C_negedge_negedge : VitalDelayType := 0 ps;

      tsetup_R_C_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_R_C_negedge_posedge : VitalDelayType := 0 ps;
      tsetup_R_C_posedge_negedge : VitalDelayType := 0 ps;
      tsetup_R_C_negedge_negedge : VitalDelayType := 0 ps;
      thold_R_C_posedge_posedge  : VitalDelayType := 0 ps;
      thold_R_C_negedge_posedge  : VitalDelayType := 0 ps;
      thold_R_C_posedge_negedge : VitalDelayType := 0 ps;
      thold_R_C_negedge_negedge : VitalDelayType := 0 ps;

      tsetup_S_C_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_S_C_negedge_posedge : VitalDelayType := 0 ps;
      tsetup_S_C_posedge_negedge : VitalDelayType := 0 ps;
      tsetup_S_C_negedge_negedge : VitalDelayType := 0 ps;
      thold_S_C_posedge_posedge  : VitalDelayType := 0 ps;
      thold_S_C_negedge_posedge  : VitalDelayType := 0 ps;
      thold_S_C_posedge_negedge : VitalDelayType := 0 ps;
      thold_S_C_negedge_negedge : VitalDelayType := 0 ps;

-- VITAL pulse width variables
      tpw_C_posedge              : VitalDelayType := 0 ps;
      tpw_C_negedge              : VitalDelayType := 0 ps;
      tpw_GSR_posedge            : VitalDelayType := 0 ps;
      tpw_R_posedge              : VitalDelayType := 0 ps;
      tpw_S_posedge              : VitalDelayType := 0 ps;

-- VITAL period variables
      tperiod_C_posedge          : VitalDelayType := 0 ps;

-- VITAL recovery time variables
      trecovery_GSR_C_negedge_posedge : VitalDelayType := 0 ps;
      trecovery_R_C_posedge_posedge   : VitalDelayType := 0 ps;
      trecovery_R_C_negedge_posedge   : VitalDelayType := 0 ps;
      trecovery_R_C_posedge_negedge   : VitalDelayType := 0 ps;
      trecovery_R_C_negedge_negedge   : VitalDelayType := 0 ps;
      trecovery_S_C_posedge_posedge   : VitalDelayType := 0 ps;
      trecovery_S_C_negedge_posedge   : VitalDelayType := 0 ps;
      trecovery_S_C_posedge_negedge   : VitalDelayType := 0 ps;
      trecovery_S_C_negedge_negedge   : VitalDelayType := 0 ps;

-- VITAL removal time variables
      tremoval_GSR_C_negedge_posedge  : VitalDelayType := 0 ps;
      tremoval_R_C_posedge_posedge    : VitalDelayType := 0 ps;
      tremoval_R_C_negedge_posedge    : VitalDelayType := 0 ps;
      tremoval_R_C_posedge_negedge    : VitalDelayType := 0 ps;
      tremoval_R_C_negedge_negedge    : VitalDelayType := 0 ps;
      tremoval_S_C_posedge_posedge    : VitalDelayType := 0 ps;
      tremoval_S_C_negedge_posedge    : VitalDelayType := 0 ps;
      tremoval_S_C_posedge_negedge    : VitalDelayType := 0 ps;
      tremoval_S_C_negedge_negedge    : VitalDelayType := 0 ps;

      DDR_CLK_EDGE : string := "OPPOSITE_EDGE";
      INIT_Q1      : bit    := '0';
      INIT_Q2      : bit    := '0';
      SRTYPE       : string := "SYNC"
      );

  port(
      Q1          : out std_ulogic;
      Q2          : out std_ulogic;

      C           : in  std_ulogic;
      CE          : in  std_ulogic;
      D           : in  std_ulogic;
      R           : in  std_ulogic;
      S           : in  std_ulogic
    );

  attribute VITAL_LEVEL0 of
    X_IDDR : entity is true;

end X_IDDR;

architecture X_IDDR_V OF X_IDDR is

  attribute VITAL_LEVEL0 of
    X_IDDR_V : architecture is true;


  constant SYNC_PATH_DELAY : time := 100 ps;

  signal C_ipd	        : std_ulogic := 'X';
  signal CE_ipd	        : std_ulogic := 'X';
  signal D_ipd	        : std_ulogic := 'X';
  signal GSR_ipd	: std_ulogic := 'X';
  signal R_ipd		: std_ulogic := 'X';
  signal S_ipd		: std_ulogic := 'X';

  signal C_dly	        : std_ulogic := 'X';
  signal CE_dly	        : std_ulogic := 'X';
  signal D_dly	        : std_ulogic := 'X';
  signal GSR_dly	: std_ulogic := 'X';
  signal R_dly		: std_ulogic := 'X';
  signal S_dly		: std_ulogic := 'X';

  signal Q1_zd	        : std_ulogic := 'X';
  signal Q2_zd	        : std_ulogic := 'X';

  signal Q1_viol        : std_ulogic := 'X';
  signal Q2_viol        : std_ulogic := 'X';

  signal Q1_o_reg	: std_ulogic := 'X';
  signal Q2_o_reg	: std_ulogic := 'X';
  signal Q3_o_reg	: std_ulogic := 'X';
  signal Q4_o_reg	: std_ulogic := 'X';

  signal ddr_clk_edge_type	: integer := -999;
  signal sr_type		: integer := -999;
begin

  ---------------------
  --  INPUT PATH DELAYs
  --------------------

  WireDelay : block
  begin
    VitalWireDelay (C_ipd,   C,   tipd_C);
    VitalWireDelay (CE_ipd,  CE,  tipd_CE);
    VitalWireDelay (D_ipd,   D,   tipd_D);
    VitalWireDelay (GSR_ipd, GSR, tipd_GSR);
    VitalWireDelay (R_ipd,   R,   tipd_R);
    VitalWireDelay (S_ipd,   S,   tipd_S);
  end block;

  SignalDelay : block
  begin
    VitalSignalDelay (C_dly,   C_ipd,   ticd_C);
    VitalSignalDelay (CE_dly,  CE_ipd,  ticd_C);
    VitalSignalDelay (D_dly,   D_ipd,   ticd_C);
    VitalSignalDelay (GSR_dly, GSR_ipd, tisd_GSR_C);
    VitalSignalDelay (R_dly,   R_ipd,   tisd_R_C);
    VitalSignalDelay (S_dly,   S_ipd,   tisd_S_C);
  end block;

  --------------------
  --  BEHAVIOR SECTION
  --------------------


--####################################################################
--#####                     Initialize                           #####
--####################################################################
  prcs_init:process

  begin
      if((DDR_CLK_EDGE = "OPPOSITE_EDGE") or (DDR_CLK_EDGE = "opposite_edge")) then
         ddr_clk_edge_type <= 1;
      elsif((DDR_CLK_EDGE = "SAME_EDGE") or (DDR_CLK_EDGE = "same_edge")) then
         ddr_clk_edge_type <= 2;
      elsif((DDR_CLK_EDGE = "SAME_EDGE_PIPELINED") or (DDR_CLK_EDGE = "same_edge_pipelined")) then
         ddr_clk_edge_type <= 3;
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Warning ",
             GenericName => " DDR_CLK_EDGE ",
             EntityName => "/X_IDDR",
             GenericValue => DDR_CLK_EDGE,
             Unit => "",
             ExpectedValueMsg => " The Legal values for this attribute are ",
             ExpectedGenericValue => " OPPOSITE_EDGE or SAME_EDGE or  SAME_EDGE_PIPELINED.",
             TailMsg => "",
             MsgSeverity => ERROR 
         );
      end if;

      if((SRTYPE = "ASYNC") or (SRTYPE = "async")) then
         sr_type <= 1;
      elsif((SRTYPE = "SYNC") or (SRTYPE = "sync")) then
         sr_type <= 2;
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Warning ",
             GenericName => " SRTYPE ",
             EntityName => "/X_IDDR",
             GenericValue => SRTYPE,
             Unit => "",
             ExpectedValueMsg => " The Legal values for this attribute are ",
             ExpectedGenericValue => " ASYNC or SYNC. ",
             TailMsg => "",
             MsgSeverity => ERROR
         );
      end if;

     wait;
  end process prcs_init;
--####################################################################
--#####                    q1_q2_q3_q4 reg                       #####
--####################################################################
  prcs_q1q2q3q4_reg:process(C_dly, D_dly, GSR_dly, R_dly, S_dly)
  variable Q1_var : std_ulogic := TO_X01(INIT_Q1);
  variable Q2_var : std_ulogic := TO_X01(INIT_Q2);
  variable Q3_var : std_ulogic := TO_X01(INIT_Q1);
  variable Q4_var : std_ulogic := TO_X01(INIT_Q2);
  begin
     if(GSR_dly = '1') then
         Q1_var := TO_X01(INIT_Q1);
         Q3_var := TO_X01(INIT_Q1);
         Q2_var := TO_X01(INIT_Q2);
         Q4_var := TO_X01(INIT_Q2);
     elsif(GSR_dly = '0') then
        case sr_type is
           when 1 => 
                   if(R_dly = '1') then
                      Q1_var := '0';
                      Q2_var := '0';
                      Q3_var := '0';
                      Q4_var := '0';
                   elsif((R_dly = '0') and (S_dly = '1')) then
                      Q1_var := '1';
                      Q2_var := '1';
                      Q3_var := '1';
                      Q4_var := '1';
                   elsif((R_dly = '0') and (S_dly = '0')) then
                      if(CE_dly = '1') then
                         if(rising_edge(C_dly)) then
                            Q3_var := Q1_var;
                            Q1_var := D_dly;
                            Q4_var := Q2_var;
                         end if;
                         if(falling_edge(C_dly)) then
                            Q2_var := D_dly;
                         end if;
                      end if;
                   end if;

           when 2 => 
                   if(rising_edge(C_dly)) then
                      if(R_dly = '1') then
                         Q1_var := '0';
                         Q3_var := '0';
                         Q4_var := '0';
                      elsif((R_dly = '0') and (S_dly = '1')) then
                         Q1_var := '1';
                         Q3_var := '1';
                         Q4_var := '1';
                      elsif((R_dly = '0') and (S_dly = '0')) then
                         if(CE_dly = '1') then
                               Q3_var := Q1_var;
                               Q1_var := D_dly;
                               Q4_var := Q2_var;
                         end if;
                      end if;
                   end if;
                        
                   if(falling_edge(C_dly)) then
                      if(R_dly = '1') then
                         Q2_var := '0';
                      elsif((R_dly = '0') and (S_dly = '1')) then
                         Q2_var := '1';
                      elsif((R_dly = '0') and (S_dly = '0')) then
                         if(CE_dly = '1') then
                               Q2_var := D_dly;
                         end if;
                      end if;
                   end if;
 
           when others =>
                   null; 
        end case;
     end if;

     q1_o_reg <= Q1_var;
     q2_o_reg <= Q2_var;
     q3_o_reg <= Q3_var;
     q4_o_reg <= Q4_var;

  end process prcs_q1q2q3q4_reg;
--####################################################################
--#####                        q1 & q2  mux                      #####
--####################################################################
  prcs_q1q2_mux:process(q1_o_reg, q2_o_reg, q3_o_reg, q4_o_reg)
  begin
     case ddr_clk_edge_type is
        when 1 => 
                 Q1_zd <= q1_o_reg;
                 Q2_zd <= q2_o_reg;
        when 2 => 
                 Q1_zd <= q1_o_reg;
                 Q2_zd <= q4_o_reg;
       when 3 => 
                 Q1_zd <= q3_o_reg;
                 Q2_zd <= q4_o_reg;
       when others =>
                 null;
     end case;
  end process prcs_q1q2_mux;
--####################################################################

--####################################################################
--#####                   TIMING CHECKS & OUTPUT                 #####
--####################################################################
  prcs_tmngchk:process

  variable PInfo_C            : VitalPeriodDataType := VitalPeriodDataInit;
  variable Pviol_C            : std_ulogic          := '0';

  variable PInfo_R            : VitalPeriodDataType := VitalPeriodDataInit;
  variable Pviol_R            : std_ulogic          := '0';

  variable PInfo_S            : VitalPeriodDataType := VitalPeriodDataInit;
  variable Pviol_S            : std_ulogic          := '0';

  variable Tmkr_D_C_posedge   : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_D_C_posedge  : std_ulogic          := '0';

  variable Tmkr_CE_C_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_CE_C_posedge : std_ulogic          := '0';

  variable Tmkr_R_C_posedge   : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_R_C_posedge  : std_ulogic          := '0';
  variable Tmkr_R_C_negedge   : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_R_C_negedge  : std_ulogic          := '0';

  variable Tmkr_S_C_posedge   : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_S_C_posedge  : std_ulogic          := '0';
  variable Tmkr_S_C_negedge   : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_S_C_negedge  : std_ulogic          := '0';

  variable Violation          : std_ulogic          := '0';
  begin
    if (TimingChecksOn) then
      VitalSetupHoldCheck (
        Violation            => Tviol_D_C_posedge,
        TimingData           => Tmkr_D_C_posedge,
        TestSignal           => D_dly,
        TestSignalName       => "D",
        TestDelay            => tisd_D_C,
        RefSignal            => C_dly,
        RefSignalName        => "C",
        RefDelay             => ticd_C,
        SetupHigh            => tsetup_D_C_posedge_posedge,
        SetupLow             => tsetup_D_C_negedge_posedge,
        HoldLow              => thold_D_C_posedge_posedge,
        HoldHigh             => thold_D_C_negedge_posedge,
        CheckEnabled         => TO_X01(((not R_dly)) and (C_dly)
                                       and ((not S_dly))) /= '0',
        RefTransition        => 'R',
        HeaderMsg            => "/X_IDDR",
        Xon                  => Xon,
        MsgOn                => true,
        MsgSeverity          => warning);
      VitalSetupHoldCheck (
        Violation            => Tviol_CE_C_posedge,
        TimingData           => Tmkr_CE_C_posedge,
        TestSignal           => CE_dly,
        TestSignalName       => "CE",
        TestDelay            => tisd_CE_C,
        RefSignal            => C_dly,
        RefSignalName        => "C",
        RefDelay             => ticd_C,
        SetupHigh            => tsetup_CE_C_posedge_posedge,
        SetupLow             => tsetup_CE_C_negedge_posedge,
        HoldLow              => thold_CE_C_posedge_posedge,
        HoldHigh             => thold_CE_C_negedge_posedge,
        CheckEnabled         => TO_X01(((not R_dly)) and ((not S_dly))) /= '0',
        RefTransition        => 'R',
        HeaderMsg            => "/X_IDDR",
        Xon                  => Xon,
        MsgOn                => true,
        MsgSeverity          => warning);
      VitalPeriodPulseCheck (
        Violation            => Pviol_C,
        PeriodData           => PInfo_C,
        TestSignal           => C_dly,
        TestSignalName       => "C",
        TestDelay            => 0 ps,
        Period               => tperiod_C_posedge,
        PulseWidthHigh       => tpw_C_posedge,
        PulseWidthLow        => tpw_C_posedge,
        CheckEnabled         => TO_X01(CE_dly) /= '0',
        HeaderMsg            => "/X_IDDR",
        Xon                  => Xon,
        MsgOn                => true,
        MsgSeverity          => warning);
      VitalPeriodPulseCheck (
        Violation            => Pviol_R,
        PeriodData           => PInfo_R,
        TestSignal           => R_dly,
        TestSignalName       => "R",
        TestDelay            => 0 ps,
        Period               => 0 ps,
        PulseWidthHigh       => tpw_R_posedge,
        PulseWidthLow        => 0 ps,
        CheckEnabled         => true,
        HeaderMsg            => "/X_IDDR",
        Xon                  => Xon,
        MsgOn                => true,
        MsgSeverity          => warning);
      VitalPeriodPulseCheck (
        Violation            => Pviol_S,
        PeriodData           => PInfo_S,
        TestSignal           => S_dly,
        TestSignalName       => "S",
        TestDelay            => 0 ps,
        Period               => 0 ps,
        PulseWidthHigh       => tpw_S_posedge,
        PulseWidthLow        => 0 ps,
        CheckEnabled         => true,
        HeaderMsg            => "/X_IDDR",
        Xon                  => Xon,
        MsgOn                => true,
        MsgSeverity          => warning);

        if (SRTYPE = "ASYNC" ) then
           VitalRecoveryRemovalCheck (
              Violation            => Tviol_R_C_posedge,
              TimingData           => Tmkr_R_C_posedge,
              TestSignal           => R_dly,
              TestSignalName       => "R",
              TestDelay            => tisd_R_C,
              RefSignal            => C_dly,
              RefSignalName        => "C",
              RefDelay             => ticd_C,
              Recovery             => trecovery_R_C_negedge_posedge,
              Removal              => tremoval_R_C_negedge_posedge,
              ActiveLow            => false,
              CheckEnabled         => TO_X01(CE_dly) /= '0' and (D_dly /= '0' or Q1_zd /= '0'),
              RefTransition        => 'R',
              HeaderMsg            => "/X_IDDR",
              Xon                  => Xon,
              MsgOn                => true,
              MsgSeverity          => warning);
           if (DDR_CLK_EDGE = "OPPOSITE_EDGE" ) then
              VitalRecoveryRemovalCheck (
                 Violation            => Tviol_R_C_negedge,
                 TimingData           => Tmkr_R_C_negedge,
                 TestSignal           => R_dly,
                 TestSignalName       => "R",
                 TestDelay            => tisd_R_C,
                 RefSignal            => C_dly,
                 RefSignalName        => "C",
                 RefDelay             => ticd_C,
                 Recovery             => trecovery_R_C_negedge_negedge,
                 Removal              => tremoval_R_C_negedge_negedge,
                 ActiveLow            => false,
                 CheckEnabled         => TO_X01(CE_dly) /= '0' and (D_dly /= '0' or Q1_zd /= '0'),
                 RefTransition        => 'F',
                 HeaderMsg            => "/X_IDDR",
                 Xon                  => Xon,
                 MsgOn                => true,
                 MsgSeverity          => warning);
           end if;
           VitalRecoveryRemovalCheck (
              Violation            => Tviol_S_C_posedge,
              TimingData           => Tmkr_S_C_posedge,
              TestSignal           => S_dly,
              TestSignalName       => "S",
              TestDelay            => tisd_S_C,
              RefSignal            => C_dly,
              RefSignalName        => "C",
              RefDelay             => ticd_C,
              Recovery             => trecovery_S_C_negedge_posedge,
              Removal              => thold_S_C_negedge_posedge,
              ActiveLow            => false,
              CheckEnabled         => TO_X01((not R_dly) and CE_dly) /= '0' and D_dly /= '1' and Q2_zd /= '1',
              RefTransition        => 'R',
              HeaderMsg            => "/X_IDDR",
              Xon                  => Xon,
              MsgOn                => true,
              MsgSeverity          => warning);
           if (DDR_CLK_EDGE = "OPPOSITE_EDGE" ) then
              VitalRecoveryRemovalCheck (
                 Violation            => Tviol_S_C_negedge,
                 TimingData           => Tmkr_S_C_negedge,
                 TestSignal           => S_dly,
                 TestSignalName       => "S",
                 TestDelay            => tisd_S_C,
                 RefSignal            => C_dly,
                 RefSignalName        => "C",
                 RefDelay             => ticd_C,
                 Recovery             => trecovery_S_C_negedge_negedge,
                 Removal              => thold_S_C_negedge_negedge,
                 ActiveLow            => false,
                 CheckEnabled         => TO_X01((not R_dly) and CE_dly) /= '0' and D_dly /= '1' and Q2_zd /= '1',
                 RefTransition        => 'F',
                 HeaderMsg            => "/X_IDDR",
                 Xon                  => Xon,
                 MsgOn                => true,
                 MsgSeverity          => warning);
           end if;
        elsif (SRTYPE = "SYNC" ) then
           VitalSetupHoldCheck (
              Violation      => Tviol_R_C_posedge,
              TimingData     => Tmkr_R_C_posedge,
              TestSignal     => R_dly,
              TestSignalName => "R",
              TestDelay      => tisd_R_C,
              RefSignal      => C_dly,
              RefSignalName  => "C",
              RefDelay       => ticd_C,
              SetupHigh      => tsetup_R_C_posedge_posedge,
              SetupLow       => tsetup_R_C_negedge_posedge,
              HoldLow        => thold_R_C_posedge_posedge,
              HoldHigh       => thold_R_C_negedge_posedge,
              CheckEnabled   => TO_X01(((not S_dly)) and ((not R_dly))) /= '0',
              RefTransition  => 'R',
              HeaderMsg      => "/X_IDDR",
              Xon            => Xon,
              MsgOn          => true,
              MsgSeverity    => warning);
           VitalSetupHoldCheck (
              Violation      => Tviol_R_C_negedge,
              TimingData     => Tmkr_R_C_negedge,
              TestSignal     => R_dly,
              TestSignalName => "R",
              TestDelay      => tisd_R_C,
              RefSignal      => C_dly,
              RefSignalName  => "C",
              RefDelay       => ticd_C,
              SetupHigh      => tsetup_R_C_posedge_negedge,
              SetupLow       => tsetup_R_C_negedge_negedge,
              HoldLow        => thold_R_C_posedge_negedge,
              HoldHigh       => thold_R_C_negedge_negedge,
              CheckEnabled   => TO_X01(((not S_dly)) and ((not R_dly))) /= '0',
              RefTransition  => 'F',
              HeaderMsg      => "/X_IDDR",
              Xon            => Xon,
              MsgOn          => true,
              MsgSeverity    => warning);
           VitalSetupHoldCheck (
              Violation      => Tviol_S_C_posedge,
              TimingData     => Tmkr_S_C_posedge,
              TestSignal     => S_dly,
              TestSignalName => "S",
              TestDelay      => tisd_S_C,
              RefSignal      => C_dly,
              RefSignalName  => "C",
              RefDelay       => ticd_C,
              SetupHigh      => tsetup_S_C_posedge_posedge,
              SetupLow       => tsetup_S_C_negedge_posedge,
              HoldLow        => thold_S_C_posedge_posedge,
              HoldHigh       => thold_S_C_negedge_posedge,
              CheckEnabled   => TO_X01(not R_dly) /= '0',
              RefTransition  => 'R',
              HeaderMsg      => "/X_IDDR",
              Xon            => Xon,
              MsgOn          => true,
              MsgSeverity    => warning);
           VitalSetupHoldCheck (
              Violation      => Tviol_S_C_negedge,
              TimingData     => Tmkr_S_C_negedge,
              TestSignal     => S_dly,
              TestSignalName => "S",
              TestDelay      => tisd_S_C,
              RefSignal      => C_dly,
              RefSignalName  => "C",
              RefDelay       => ticd_C,
              SetupHigh      => tsetup_S_C_posedge_negedge,
              SetupLow       => tsetup_S_C_negedge_negedge,
              HoldLow        => thold_S_C_posedge_negedge,
              HoldHigh       => thold_S_C_negedge_negedge,
              CheckEnabled   => TO_X01(not R_dly) /= '0',
              RefTransition  => 'F',
              HeaderMsg      => "/X_IDDR",
              Xon            => Xon,
              MsgOn          => true,
              MsgSeverity    => warning);
          
        end if;
    end if;

    Violation := Pviol_C or Pviol_R or Pviol_S or 
                 Tviol_D_C_posedge  or 
                 Tviol_CE_C_posedge or
                 Tviol_R_C_posedge  or Tviol_R_C_negedge or
                 Tviol_S_C_posedge  or Tviol_R_C_negedge;

    Q1_viol     <= Violation xor Q1_zd;
    Q2_viol     <= Violation xor Q2_zd;

    wait on C_dly, CE_dly, D_dly, GSR_dly, R_dly, S_dly, Q1_zd, Q2_zd;
 
  end process prcs_tmngchk;
--####################################################################
--#####                           OUTPUT                         #####
--####################################################################
  prcs_output:process
  variable  Q1_GlitchData : VitalGlitchDataType;
  variable  Q2_GlitchData : VitalGlitchDataType;

  begin
     VitalPathDelay01
       (
         OutSignal     => Q1,
         GlitchData    => Q1_GlitchData,
         OutSignalName => "Q1",
         OutTemp       => Q1_viol,
         Paths         => (0 => (C_ipd'last_event, tpd_C_Q1,TRUE),
                           1 => (S_dly'last_event, tpd_S_Q1, (R_dly /= '1')),
                           2 => (R_dly'last_event, tpd_R_Q1, true)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => Q2,
         GlitchData    => Q2_GlitchData,
         OutSignalName => "Q2",
         OutTemp       => Q2_viol,
         Paths         => (0 => (C_ipd'last_event, tpd_C_Q2,TRUE),
                           1 => (S_dly'last_event, tpd_S_Q2, (R_dly /= '1')),
                           2 => (R_dly'last_event, tpd_R_Q2, true)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );

    wait on Q1_viol, Q2_viol;
  end process prcs_output;


end X_IDDR_V;

-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  Input Delay Controller
-- /___/   /\     Filename : X_IDELAYCTRL.vhd
-- \   \  /  \    Timestamp : Fri Mar 26 08:18:20 PST 2004
--  \___\/\___\
--
-- Revision:
--    03/23/04 - Initial version.
--    09/12/06 - intialized output # 234140
--    04/10/07 - CR 436682 fix, disable activity when rst is high
-- End Revision

----- CELL X_IDELAYCTRL -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;


library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.VPACKAGE.all;

entity X_IDELAYCTRL is

  generic(
      TimingChecksOn : boolean := true;
      InstancePath   : string  := "*";
      Xon            : boolean := true;
      MsgOn          : boolean := true;
      LOC            : string  := "UNPLACED";

--  VITAL input Pin path delay variables
      tipd_REFCLK   : VitalDelayType01 := (0 ps, 0 ps);
      tipd_RST      : VitalDelayType01 := (0 ps, 0 ps);

--  VITAL clock-to-output path delay variable
      tpd_REFCLK_RDY : VitalDelayType01 := (100 ps, 100 ps);

--  VITAL async rest-to-output path delay variables
      tpd_RST_RDY : VitalDelayType01 := (0 ps, 0 ps);

--  VITAL tisd & tisd variables
      tisd_RST_REFCLK : VitalDelayType   := 0.0 ps;
      ticd_REFCLK     : VitalDelayType   := 0.0 ps;

--  VITAL Setup/Hold delay variables
      tsetup_RST_REFCLK_posedge_posedge   : VitalDelayType := 0 ps;
      tsetup_RST_REFCLK_negedge_posedge   : VitalDelayType := 0 ps;
      thold_RST_REFCLK_posedge_posedge    : VitalDelayType := 0 ps;
      thold_RST_REFCLK_negedge_posedge    : VitalDelayType := 0 ps;


-- VITAL pulse width variables
      tpw_REFCLK_posedge	: VitalDelayType := 0 ps;

-- VITAL period variables
      tperiod_REFCLK_posedge	: VitalDelayType := 0 ps
  );


  port(
      RDY	: out std_ulogic;

      REFCLK	: in  std_ulogic;
      RST	: in  std_ulogic
  );

  attribute VITAL_LEVEL0 of
    X_IDELAYCTRL : entity is true;

end X_IDELAYCTRL;

architecture X_IDELAYCTRL_V OF X_IDELAYCTRL is

  attribute VITAL_LEVEL0 of
    X_IDELAYCTRL_V : architecture is true;


  constant SYNC_PATH_DELAY : time := 100 ps;

  signal REFCLK_ipd	: std_ulogic := 'X';
  signal RST_ipd	: std_ulogic := 'X';

  signal GSR_dly	: std_ulogic := '0';
  signal REFCLK_dly	: std_ulogic := 'X';
  signal RST_dly	: std_ulogic := 'X';

  signal RDY_zd		: std_ulogic := '0';
  signal RDY_viol	: std_ulogic := 'X';

-- taken from DCM_adv
  signal period : time := 0 ps;
-- CR 234140
  signal lost   : std_ulogic := '1';
  signal lost_r : std_ulogic := '0';
  signal lost_f : std_ulogic := '0';
  signal clock_negedge, clock_posedge, clock : std_ulogic;
  signal temp1 : boolean := false;
  signal temp2 : boolean := false;
  signal clock_low, clock_high : std_ulogic := '0';


begin

  ---------------------
  --  INPUT PATH DELAYs
  --------------------

  WireDelay : block
  begin
    VitalWireDelay (REFCLK_ipd, REFCLK, tipd_REFCLK);
    VitalWireDelay (RST_ipd, RST, tipd_RST);
  end block;

  SignalDelay : block
  begin
    VitalSignalDelay (REFCLK_dly, REFCLK_ipd, ticd_REFCLK);
    VitalSignalDelay (RST_dly, RST_ipd, tisd_RST_REFCLK);
  end block;

  --------------------
  --  BEHAVIOR SECTION
  --------------------


--####################################################################
--#####                             RDY                          #####
--####################################################################
   prcs_rdy:process(RST_dly, lost)
   begin
      if((RST_dly = '1') or (lost = '1')) then
         RDY_zd <= '0';
--    CR 436682 fix
--      elsif((RST_dly'event) and (RST_dly = '0') and (lost = '0')) then
      elsif((RST_dly = '0') and (lost = '0')) then
         RDY_zd <= '1';
      end if;
   end process prcs_rdy;
--####################################################################
--#####                prcs_determine_period                     #####
--####################################################################
  prcs_determine_period : process
    variable clock_edge_previous : time := 0 ps;
    variable clock_edge_current  : time := 0 ps;
  begin
    if (RST_dly = '0' ) then
      if (rising_edge(REFCLK_dly)) then
        clock_edge_previous := clock_edge_current;
        clock_edge_current := NOW;
        if (period /= 0 ps and ((clock_edge_current - clock_edge_previous) <= (1.5 * period))) then
          period <= NOW - clock_edge_previous;
        elsif (period /= 0 ps and ((NOW - clock_edge_previous) > (1.5 * period))) then
          period <= 0 ps;
        elsif ((period = 0 ps) and (clock_edge_previous /= 0 ps)) then
          period <= NOW - clock_edge_previous;
        end if;
      end if;
    end if;
    wait on REFCLK_dly;
  end process prcs_determine_period;

--####################################################################
--#####                prcs_clock_lost_checker                   #####
--####################################################################
  prcs_clock_lost_checker : process
    variable clock_low, clock_high : std_ulogic := '0';

  begin
    if (rising_edge(REFCLK_dly)) then
      clock_low := '0';
      clock_high := '1';
      clock_posedge <= '0';
      clock_negedge <= '1';
    end if;

    if (falling_edge(REFCLK_dly)) then
      clock_high := '0';
      clock_low := '1';
      clock_posedge <= '1';
      clock_negedge <= '0';
    end if;
    wait on REFCLK_dly;
  end process prcs_clock_lost_checker;

--####################################################################
--#####                prcs_set_reset_lost_r                     #####
--####################################################################
  prcs_set_reset_lost_r : process
    begin
    if (rising_edge(REFCLK_dly)) then
      if (period /= 0 ps) then
        lost_r <= '0';
      end if;
      wait for (period * 9.1)/10;
      if ((clock_low /= '1') and (clock_posedge /= '1')) then
        lost_r <= '1';
      end if;
    end if;
    wait on REFCLK_dly;
  end process prcs_set_reset_lost_r;

--####################################################################
--#####                     prcs_assign_lost                     #####
--####################################################################
  prcs_assign_lost : process
    begin
      if (lost_r'event) then
        lost <= lost_r;
      end if;
      if (lost_f'event) then
        lost <= lost_f;
      end if;
      wait on lost_r, lost_f;
    end process prcs_assign_lost;

--####################################################################
--#####                   TIMING CHECKS & OUTPUT                 #####
--####################################################################
  prcs_tmngchk:process
--  Pin Timing Violations (all input pins)
     variable	Tviol_RST_REFCLK_posedge	: STD_ULOGIC          := '0';
     variable	Tmkr_RST_REFCLK_posedge		: VitalTimingDataType := VitalTimingDataInit;
     variable   Violation			: std_ulogic          := '0';

     begin

--  Setup/Hold Check Violations (all input pins)

     if (TimingChecksOn) then
     VitalSetupHoldCheck
       (
         Violation      => Tviol_RST_REFCLK_posedge,
         TimingData     => Tmkr_RST_REFCLK_posedge,
         TestSignal     => RST,
         TestSignalName => "RST",
         TestDelay      => 0 ns,
         RefSignal      => REFCLK_dly,
         RefSignalName  => "REFCLK",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_RST_REFCLK_posedge_posedge,
         SetupLow       => tsetup_RST_REFCLK_negedge_posedge,
         HoldLow        => thold_RST_REFCLK_posedge_posedge,
         HoldHigh       => thold_RST_REFCLK_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_IDELAYCTRL",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     end if;  -- End of (TimingChecksOn)

     Violation :=  Tviol_RST_REFCLK_posedge;

     RDY_viol <= Violation xor RDY_zd; 

     wait on
       RDY_zd,
       REFCLK_dly;
  end process prcs_tmngchk;
--####################################################################
--#####                           OUTPUT                         #####
--####################################################################
  prcs_output:process
--  Output Pin glitch declaration
     variable  RDY_GlitchData : VitalGlitchDataType;
  begin

--  Output-to-Clock path delay
     VitalPathDelay01
       (
         OutSignal     => RDY,
         GlitchData    => RDY_GlitchData,
         OutSignalName => "RDY",
         OutTemp       => RDY_zd,
         Paths         => (0 => (RST_dly'last_event, tpd_RST_RDY,TRUE)),
         Mode          => VitalTransport,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     wait on RDY_zd;
  end process prcs_output;


end X_IDELAYCTRL_V;

-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  Input Delay Line
-- /___/   /\     Filename : X_IDELAY.vhd
-- \   \  /  \    Timestamp : Thu Mar 17 16:56:02 PST 2005
--  \___\/\___\
--
-- Revision:
--    03/23/04 - Initial version.
--    03/17/05 - Changed SIM_TAPDELAY_VALUE to 75 ps from 78 ps -- CR 204824 --FP
--    06/14/05 - Fixed VitalPathDelay constructs  -- CR 209786 --FP
--    08/08/05 - Made tap count to wrap around  -- CR 213995 --FP
--    07/18/06 - CR 234556 fix. Added SIM_DELAY_D --FP
--    12/29/06 - CR 430648 Simprim fix. For fixed/default, delay is annotated via sdf.
-- End Revision
----- CELL X_IDELAY -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;


library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.Vcomponents.all;
use simprim.VPACKAGE.all;

entity X_IDELAY is

  generic(

      TimingChecksOn : boolean := true;
      InstancePath   : string  := "*";
      Xon            : boolean := true;
      MsgOn          : boolean := true;
      LOC            : string  := "UNPLACED";

--  VITAL input Pin path delay variables
      tipd_CE     : VitalDelayType01 := (0 ps, 0 ps);
      tipd_C      : VitalDelayType01 := (0 ps, 0 ps);
      tipd_GSR    : VitalDelayType01 := (0 ps, 0 ps);
      tipd_I      : VitalDelayType01 := (0 ps, 0 ps);
      tipd_INC    : VitalDelayType01 := (0 ps, 0 ps);
      tipd_RST    : VitalDelayType01 := (0 ps, 0 ps);

--  VITAL clk-to-output path delay variables
      tpd_I_O   : VitalDelayType01 := (100 ps, 100 ps);
      tpd_C_O   : VitalDelayType01 := (100 ps, 100 ps);


--  VITAL GSR-to-output path delay variable
      tpd_GSR_O : VitalDelayType01 := (0 ps, 0 ps);


--  VITAL tisd & tisd variables
      tisd_GSR_C  : VitalDelayType  := 0.0 ps;
      ticd_C      : VitalDelayType  := 0.0 ps;

--  VITAL Setup/Hold delay variables
      tsetup_CE_C_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_CE_C_negedge_posedge : VitalDelayType := 0 ps;
      thold_CE_C_posedge_posedge  : VitalDelayType := 0 ps;
      thold_CE_C_negedge_posedge  : VitalDelayType := 0 ps;
      tsetup_I_C_posedge_posedge  : VitalDelayType := 0 ps;
      tsetup_I_C_negedge_posedge  : VitalDelayType := 0 ps;
      thold_I_C_posedge_posedge   : VitalDelayType := 0 ps;
      thold_I_C_negedge_posedge   : VitalDelayType := 0 ps;
      tsetup_INC_C_posedge_posedge  : VitalDelayType := 0 ps;
      tsetup_INC_C_negedge_posedge  : VitalDelayType := 0 ps;
      thold_INC_C_posedge_posedge   : VitalDelayType := 0 ps;
      thold_INC_C_negedge_posedge   : VitalDelayType := 0 ps;
      tsetup_RST_C_posedge_posedge  : VitalDelayType := 0 ps;
      tsetup_RST_C_negedge_posedge  : VitalDelayType := 0 ps;
      thold_RST_C_posedge_posedge   : VitalDelayType := 0 ps;
      thold_RST_C_negedge_posedge   : VitalDelayType := 0 ps;

-- VITAL pulse width variables
      tpw_C_posedge               : VitalDelayType := 0 ps;
      tpw_GSR_posedge             : VitalDelayType := 0 ps;

-- VITAL period variables
      tperiod_C_posedge           : VitalDelayType := 0 ps;

-- VITAL recovery time variables
      trecovery_GSR_C_negedge_posedge : VitalDelayType := 0 ps;

-- VITAL removal time variables
      tremoval_GSR_C_negedge_posedge : VitalDelayType := 0 ps;

      IOBDELAY_TYPE  : string := "DEFAULT";
      IOBDELAY_VALUE : integer := 0;
      SIM_DELAY_D    : integer := 0; 
      SIM_TAPDELAY_VALUE  : integer := 75
      );

  port(
      O      : out std_ulogic;

      C      : in  std_ulogic;
      CE     : in  std_ulogic;
      I      : in  std_ulogic;
      INC    : in  std_ulogic;
      RST    : in  std_ulogic
      );

  attribute VITAL_LEVEL0 of
    X_IDELAY : entity is true;

end X_IDELAY;

architecture X_IDELAY_V OF X_IDELAY is

  attribute VITAL_LEVEL0 of
    X_IDELAY_V : architecture is true;

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

  constant	SYNC_PATH_DELAY	: time := 0 ps;

  constant	MIN_TAP_COUNT	: integer := 0;
  constant	MAX_TAP_COUNT	: integer := 63;

  signal	C_ipd		: std_ulogic := 'X';
  signal	CE_ipd		: std_ulogic := 'X';
  signal	GSR_ipd		: std_ulogic := 'X';
  signal	I_ipd		: std_ulogic := 'X';
  signal	INC_ipd		: std_ulogic := 'X';
  signal	RST_ipd		: std_ulogic := 'X';

  signal	C_dly		: std_ulogic := 'X';
  signal	CE_dly		: std_ulogic := 'X';
  signal	GSR_dly		: std_ulogic := '0';
  signal	I_dly		: std_ulogic := 'X';
  signal	INC_dly		: std_ulogic := 'X';
  signal	RST_dly		: std_ulogic := 'X';

  signal	O_zd		: std_ulogic := 'X';
  signal	O_viol		: std_ulogic := 'X';

  signal	TapCount	: integer := 0;
  signal	IsTapDelay	: boolean := true; 
  signal	IsTapFixed	: boolean := false; 
  signal	IsTapDefault	: boolean := false; 
  signal	Delay		: time := 0 ps; 

begin

  ---------------------
  --  INPUT PATH DELAYs
  --------------------

  WireDelay : block
  begin
    VitalWireDelay (C_ipd,      C,      tipd_C);
    VitalWireDelay (CE_ipd,     CE,     tipd_CE);
    VitalWireDelay (GSR_ipd,    GSR,    tipd_GSR);
    VitalWireDelay (I_ipd,      I,      tipd_I);
    VitalWireDelay (INC_ipd,    INC,    tipd_INC);
    VitalWireDelay (RST_ipd,    RST,    tipd_RST);
  end block;

  SignalDelay : block
  begin
    VitalSignalDelay (C_dly,      C_ipd,      ticd_C);
    VitalSignalDelay (CE_dly,     CE_ipd,     ticd_C);
    VitalSignalDelay (GSR_dly,    GSR_ipd,    tisd_GSR_C);
    VitalSignalDelay (I_dly,      I_ipd,      ticd_C);
    VitalSignalDelay (INC_dly,    INC_ipd,    ticd_C);
    VitalSignalDelay (RST_dly,    RST_ipd,    ticd_C);
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
--     if((IOBDELAY_VALUE = "OFF") or (IOBDELAY_VALUE = "off")) then
--        IsTapDelay_var := false;
--     elsif((IOBDELAY_VALUE = "ON") or (IOBDELAY_VALUE = "on")) then
--        IsTapDelay_var := false;
--     else
--       TapCount_var := str_2_int(IOBDELAY_VALUE); 
       TapCount_var := IOBDELAY_VALUE; 
       If((TapCount_var >= 0) and (TapCount_var <= 63)) then 
         IsTapDelay_var := true;

       else
          GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Warning ",
             GenericName => " IOBDELAY_VALUE ",
             EntityName => "/IOBDELAY_VALUE",
             GenericValue => IOBDELAY_VALUE,
             Unit => "",
             ExpectedValueMsg => " The Legal values for this attribute are ",
             ExpectedGenericValue => " OFF, 1, 2, ..., 62, 63 ",
             TailMsg => "",
             MsgSeverity => failure 
          );
        end if;
--     end if;

     if(IsTapDelay_var) then
        if((IOBDELAY_TYPE = "FIXED") or (IOBDELAY_TYPE = "fixed")) then
           IsTapFixed_var := true;
        elsif((IOBDELAY_TYPE = "VARIABLE") or (IOBDELAY_TYPE = "variable")) then
           IsTapFixed_var := false;
        elsif((IOBDELAY_TYPE = "DEFAULT") or (IOBDELAY_TYPE = "default")) then
           IsTapDefault_var := true;
        else
          GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Warning ",
             GenericName => " IOBDELAY_TYPE ",
             EntityName => "/IOBDELAY_TYPE",
             GenericValue => IOBDELAY_TYPE,
             Unit => "",
             ExpectedValueMsg => " The Legal values for this attribute are ",
             ExpectedGenericValue => " FIXED or VARIABLE ",
             TailMsg => "",
             MsgSeverity => failure 
          );
        end if; 
     end if; 

     IsTapDelay   <= IsTapDelay_var;
     IsTapFixed   <= IsTapFixed_var;
     IsTapDefault <= IsTapDefault_var;
     TapCount     <= TapCount_var;

     wait;
  end process prcs_init;
--####################################################################
--#####                  CALCULATE DELAY                         #####
--####################################################################
  prcs_refclk:process(C_dly, GSR_dly, RST_dly)
  variable TapCount_var : integer :=0;
  variable FIRST_TIME   : boolean :=true;
  variable BaseTime_var : time    := 1 ps ;
  variable delay_var    : time    := 0 ps ;
  begin
     if(IsTapDelay) then
       if((GSR_dly = '1') or (FIRST_TIME))then
          TapCount_var := TapCount; 
          Delay        <= TapCount_var * SIM_TAPDELAY_VALUE * BaseTime_var; 
          FIRST_TIME   := false;
       elsif(GSR_dly = '0') then
          if(rising_edge(C_dly)) then
             if(RST_dly = '1') then
               TapCount_var := TapCount; 
             elsif((RST_dly = '0') and (CE_dly = '1')) then
-- CR fix CR 213995
                  if(INC_dly = '1') then
                     if (TapCount_var < MAX_TAP_COUNT) then
                        TapCount_var := TapCount_var + 1;
                     else 
                        TapCount_var := MIN_TAP_COUNT;
                     end if;
                  elsif(INC_dly = '0') then
                     if (TapCount_var > MIN_TAP_COUNT) then
                         TapCount_var := TapCount_var - 1;
                     else
                         TapCount_var := MAX_TAP_COUNT;
                     end if;
                         
                  end if; -- INC_dly
             end if; -- RST_dly
             Delay <= TapCount_var *  SIM_TAPDELAY_VALUE * BaseTime_var;
          end if; -- C_dly
       end if; -- GSR_dly

     end if; -- IsTapDelay 
  end process prcs_refclk;

--####################################################################
--#####                      DELAY INPUT                         #####
--####################################################################
  prcs_i:process(I_dly)
  begin
-- 430648 fix
     if((IsTapFixed) or (IsTapDefault)) then
        O_zd <= I_dly;
     else
        O_zd <= transport I_dly after delay;
     end if;
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

     if (TimingChecksOn) then
       VitalSetupHoldCheck
         (
           Violation      => Tviol_CE_C_posedge,
           TimingData     => Tmkr_CE_C_posedge,
           TestSignal     => CE,
           TestSignalName => "CE",
           TestDelay      => 0 ns,
           RefSignal      => C_dly,
           RefSignalName  => "C",
           RefDelay       => 0 ns,
           SetupHigh      => tsetup_CE_C_posedge_posedge,
           SetupLow       => tsetup_CE_C_negedge_posedge,
           HoldLow        => thold_CE_C_posedge_posedge,
           HoldHigh       => thold_CE_C_negedge_posedge,
           CheckEnabled   => TRUE,
           RefTransition  => 'R',
           HeaderMsg      => InstancePath & "/X_IDELAY",
           Xon            => Xon,
           MsgOn          => MsgOn,
           MsgSeverity    => WARNING
        );
     end if;

     Violation :=  Tviol_CE_C_posedge;

     O_viol <= Violation xor O_zd;

     wait on C_dly, GSR_dly, RST_dly, O_zd;

  end process prcs_tmngchk;
--####################################################################
--#####                           OUTPUT                         #####
--####################################################################
  prcs_output:process
  variable tpd_I_O_var : VitalDelayType01 := (SIM_DELAY_D * 1.0 ps, SIM_DELAY_D * 1.0 ps);
  variable  O_GlitchData : VitalGlitchDataType;
  begin 
        if((IOBDELAY_TYPE = "VARIABLE") or (IOBDELAY_TYPE = "variable")) then
          VitalPathDelay01
            (
              OutSignal     => O,
              GlitchData    => O_GlitchData,
              OutSignalName => "O",
              OutTemp       => O_viol,
              Paths         => (0 => (O_viol'last_event, tpd_I_O_var,TRUE)),
              Mode          => VitalTransport,
              Xon           => Xon,
              MsgOn         => MsgOn,
              MsgSeverity   => WARNING
          );
        else
          VitalPathDelay01
            (
              OutSignal     => O,
              GlitchData    => O_GlitchData,
              OutSignalName => "O",
              OutTemp       => O_viol,
              Paths         => (0 => (O_viol'last_event, tpd_I_O,TRUE)),
              Mode          => VitalTransport,
              Xon           => Xon,
              MsgOn         => MsgOn,
              MsgSeverity   => WARNING
          );
        end if;
     wait on O_viol;
  end process prcs_output;


end X_IDELAY_V;

-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  Source Synchronous Input Deserializer
-- /___/   /\     Filename : X_ISERDES.vhd
-- \   \  /  \    Timestamp : Fri Mar 26 08:18:20 PST 2004
--  \___\/\___\
--
-- Revision:
--    03/23/04 - Initial version.
--    05/29/06 - CR 232324 -- Added  timing checks for SR/REV wrt negedge CLKDIV
--    07/19/06 - CR 234556 fix. Added sim_DELAY_D, sim_SETUP_D_CLK and sim_HOLD_D_CLK --FP
--    10/13/06 - CR 426606 fix
--    08/29/07 - CR 447556 Fixed attribute INTERFACE_TYPE to be case insensitive 
--    09/10/07 - CR 447760 Added Strict DRC for BITSLIP and INTERFACE_TYPE combinations
-- End Revision
----- CELL X_ISERDES -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;


library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.Vcomponents.all;
use simprim.VPACKAGE.all;
use simprim.vcomponents.all;

--//////////////////////////////////////////////////////////// 
--////////////////////////// BSCNTRL /////////////////////////
--//////////////////////////////////////////////////////////// 
entity bscntrl is
  generic(
      SRTYPE        : string;
      INIT_BITSLIPCNT	: bit_vector(3 downto 0)
      );
  port(
      CLKDIV_INT	: out std_ulogic;
      MUXC		: out std_ulogic;

      BITSLIP		: in std_ulogic;
      C23		: in std_ulogic;
      C45		: in std_ulogic;
      C67		: in std_ulogic;
      CLK		: in std_ulogic;
      CLKDIV		: in std_ulogic;
      DATA_RATE		: in std_ulogic;
      R			: in std_ulogic;
      SEL		: in std_logic_vector (1 downto 0)
      );
           
end bscntrl;

architecture bscntrl_V of bscntrl is
--  constant DELAY_FFBSC		: time       := 300 ns;
--  constant DELAY_MXBSC		: time       := 60  ns;
  constant DELAY_FFBSC			: time       := 300 ps;
  constant DELAY_MXBSC			: time       := 60  ps;

  signal AttrSRtype		: integer := 0;

  signal q1			: std_ulogic := 'X';
  signal q2			: std_ulogic := 'X';
  signal q3			: std_ulogic := 'X';
  signal mux			: std_ulogic := 'X';
  signal qhc1			: std_ulogic := 'X';
  signal qhc2			: std_ulogic := 'X';
  signal qlc1			: std_ulogic := 'X';
  signal qlc2			: std_ulogic := 'X';
  signal qr1			: std_ulogic := 'X';
  signal qr2			: std_ulogic := 'X';
  signal mux1			: std_ulogic := 'X';
  signal clkdiv_zd		: std_ulogic := 'X';

begin
--####################################################################
--#####                     Initialize                           #####
--####################################################################
  prcs_init:process
  begin

     if((SRTYPE = "ASYNC") or (SRTYPE = "async")) then
        AttrSrtype <= 0;
     elsif((SRTYPE = "SYNC") or (SRTYPE = "sync")) then
        AttrSrtype <= 1;
     end if;

     wait;
  end process prcs_init;
--####################################################################
--#####              Divide by 2 - 8 counter                     #####
--####################################################################
  prcs_div_2_8_cntr:process(qr2, CLK, GSR)
  variable clkdiv_int_var	:  std_ulogic := TO_X01(INIT_BITSLIPCNT(0));
  variable q1_var		:  std_ulogic := TO_X01(INIT_BITSLIPCNT(1));
  variable q2_var		:  std_ulogic := TO_X01(INIT_BITSLIPCNT(2));
  variable q3_var		:  std_ulogic := TO_X01(INIT_BITSLIPCNT(3));
  begin
     if(GSR = '1') then
         clkdiv_int_var	:= TO_X01(INIT_BITSLIPCNT(0));
         q1_var		:= TO_X01(INIT_BITSLIPCNT(1));
         q2_var		:= TO_X01(INIT_BITSLIPCNT(2));
         q3_var		:= TO_X01(INIT_BITSLIPCNT(3));
     elsif(GSR = '0') then
        case AttrSRtype is
           when 0 => 
           --------------- // async SET/RESET
                   if(qr2 = '1') then
                      clkdiv_int_var := '0';
                      q1_var := '0';
                      q2_var := '0';
                      q3_var := '0';
                   elsif (qhc1 = '1') then
                      clkdiv_int_var := clkdiv_int_var;
                      q1_var := q1_var;
                      q2_var := q2_var;
                      q3_var := q3_var;
                   else
                      if(rising_edge(CLK)) then
                         q3_var := q2_var;
                         q2_var :=( NOT((NOT clkdiv_int_var) and (NOT q2_var)) and q1_var);
                         q1_var := clkdiv_int_var;
                         clkdiv_int_var := mux;
                      end if;
                   end if;

           when 1 => 
           --------------- // sync SET/RESET
                   if(rising_edge(CLK)) then
                      if(qr2 = '1') then
                         clkdiv_int_var := '0';
                         q1_var := '0';
                         q2_var := '0';
                         q3_var := '0';
                      elsif (qhc1 = '1') then
                         clkdiv_int_var := clkdiv_int_var;
                         q1_var := q1_var;
                         q2_var := q2_var;
                         q3_var := q3_var;
                      else
                         q3_var := q2_var;
                         q2_var :=( NOT((NOT clkdiv_int_var) and (NOT q2_var)) and q1_var);
                         q1_var := clkdiv_int_var;
                         clkdiv_int_var := mux;
                      end if;
                   end if;

           when others => 
                   null;
           end case;


     end if;

     q1 <= q1_var after DELAY_FFBSC;
     q2 <= q2_var after DELAY_FFBSC;
     q3 <= q3_var after DELAY_FFBSC;
     clkdiv_zd <= clkdiv_int_var after DELAY_FFBSC;

  end process prcs_div_2_8_cntr;
--####################################################################
--#####          Divider selections and 4:1 selector mux         #####
--####################################################################
  prcs_mux_sel:process(sel, c23 , c45 , c67 , clkdiv_zd , q1 , q2 , q3)
  begin
    case sel is
        when "00" =>
              mux <= NOT (clkdiv_zd or  (c23 and q1)) after DELAY_MXBSC;
        when "01" =>
              mux <= NOT (q1 or (c45 and q2)) after DELAY_MXBSC;
        when "10" =>
              mux <= NOT (q2 or (c67 and q3)) after DELAY_MXBSC;
        when "11" =>
              mux <= NOT (q3) after DELAY_MXBSC;
        when others =>
              mux <= NOT (clkdiv_zd or  (c23 and q1)) after DELAY_MXBSC;
    end case;
  end process prcs_mux_sel;
--####################################################################
--#####                  Bitslip control logic                   #####
--####################################################################
  prcs_logictrl:process(qr1, clkdiv)
  begin
      case AttrSRtype is
          when 0 => 
           --------------- // async SET/RESET
               if(qr1 = '1') then
                 qlc1        <= '0' after DELAY_FFBSC;
                 qlc2        <= '0' after DELAY_FFBSC;
               elsif(bitslip = '0') then
                 qlc1        <= qlc1 after DELAY_FFBSC;
                 qlc2        <= '0'  after DELAY_FFBSC;
               else 
                   if(rising_edge(clkdiv)) then
                      qlc1      <= NOT qlc1 after DELAY_FFBSC;
                      qlc2      <= (bitslip and mux1) after DELAY_FFBSC;
                   end if;
               end if;

          when 1 => 
           --------------- // sync SET/RESET
               if(rising_edge(clkdiv)) then
                  if(qr1 = '1') then
                    qlc1        <= '0' after DELAY_FFBSC;
                    qlc2        <= '0' after DELAY_FFBSC;
                  elsif(bitslip = '0') then
                    qlc1        <= qlc1 after DELAY_FFBSC;
                    qlc2        <= '0'  after DELAY_FFBSC;
                  else 
                    qlc1      <= NOT qlc1 after DELAY_FFBSC;
                    qlc2      <= (bitslip and mux1) after DELAY_FFBSC;
                  end if;
               end if;
          when others => 
                  null;
      end case;
  end process  prcs_logictrl;

--####################################################################
--#####        Mux to select between sdr "0" and ddr "1"         #####
--####################################################################
  prcs_sdr_ddr_mux:process(qlc1, DATA_RATE)
  begin
    case DATA_RATE is
        when '0' =>
             mux1 <= qlc1 after DELAY_MXBSC;
        when '1' =>
             mux1 <= '1' after DELAY_MXBSC;
        when others =>
             null;
    end case;
  end process  prcs_sdr_ddr_mux;

--####################################################################
--#####                       qhc1 and qhc2                      #####
--####################################################################
  prcs_qhc1_qhc2:process(qr2, CLK)
  begin
-- FP TMP -- should CLK and q2 have to be rising_edge
     case AttrSRtype is
        when 0 => 
         --------------- // async SET/RESET
             if(qr2 = '1') then
                qhc1 <= '0' after DELAY_FFBSC;
                qhc2 <= '0' after DELAY_FFBSC;
             elsif(rising_edge(CLK)) then
                qhc1 <= (qlc2 and (NOT qhc2)) after DELAY_FFBSC;
                qhc2 <= qlc2 after DELAY_FFBSC;
             end if;

        when 1 => 
         --------------- // sync SET/RESET
             if(rising_edge(CLK)) then
                if(qr2 = '1') then
                   qhc1 <= '0' after DELAY_FFBSC;
                   qhc2 <= '0' after DELAY_FFBSC;
                else
                   qhc1 <= (qlc2 and (NOT qhc2)) after DELAY_FFBSC;
                   qhc2 <= qlc2 after DELAY_FFBSC;
                end if;
             end if;

        when others =>
             null;
     end case;

  end process  prcs_qhc1_qhc2;

--####################################################################
--#####     Mux drives ctrl lines of mux in front of 2nd rnk FFs  ####
--####################################################################
  prcs_muxc:process(mux1, DATA_RATE)
  begin
    case DATA_RATE is
        when '0' =>
             muxc <= mux1 after DELAY_MXBSC;
        when '1' =>
             muxc <= '0'  after DELAY_MXBSC;
        when others =>
             null;
    end case;
  end process  prcs_muxc;

--####################################################################
--#####                       Asynchronous set flops             #####
--####################################################################
  prcs_qr1:process(R, CLKDIV)
  begin
-- FP TMP -- should CLKDIV and R have to be rising_edge
     case AttrSRtype is
        when 0 => 
         --------------- // async SET/RESET
             if(R = '1') then
                qr1        <= '1' after DELAY_FFBSC;
             elsif(rising_edge(CLKDIV)) then
                qr1        <= '0' after DELAY_FFBSC;
             end if;

        when 1 => 
         --------------- // sync SET/RESET
             if(rising_edge(CLKDIV)) then
                if(R = '1') then
                   qr1        <= '1' after DELAY_FFBSC;
                else
                   qr1        <= '0' after DELAY_FFBSC;
                end if;
             end if;

        when others => 
             null;
     end case;
  end process  prcs_qr1;
----------------------------------------------------------------------
  prcs_qr2:process(R, CLK)
  begin
-- FP TMP -- should CLK and R have to be rising_edge
     case AttrSRtype is
        when 0 => 
         --------------- // async SET/RESET
             if(R = '1') then
                qr2        <= '1' after DELAY_FFBSC;
             elsif(rising_edge(CLK)) then
                qr2        <= qr1 after DELAY_FFBSC;
             end if;

        when 1 => 
         --------------- // sync SET/RESET
             if(rising_edge(CLK)) then
                if(R = '1') then
                   qr2        <= '1' after DELAY_FFBSC;
                else
                   qr2        <= qr1 after DELAY_FFBSC;
                end if;
             end if;

        when others => 
             null;
     end case;
  end process  prcs_qr2;
--####################################################################
--#####                         OUTPUT                           #####
--####################################################################
  prcs_output:process(clkdiv_zd)
  begin
      CLKDIV_INT <= clkdiv_zd;
  end process prcs_output;
--####################################################################
end bscntrl_V;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;


library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.Vcomponents.all;
use simprim.VPACKAGE.all;
use simprim.vcomponents.all;

--//////////////////////////////////////////////////////////// 
--//////////////////////// ICE MODULE ////////////////////////
--//////////////////////////////////////////////////////////// 

entity ice_module is
  generic(
      SRTYPE  : string;
      INIT_CE : bit_vector(1 downto 0)
      );
  port(
      ICE		: out std_ulogic;

      CE1		: in std_ulogic;
      CE2		: in std_ulogic;
      NUM_CE		: in std_ulogic;
      CLKDIV		: in std_ulogic;
      R			: in std_ulogic
      );
end ice_module;

architecture ice_V of ice_module is
--  constant DELAY_FFICE		: time := 300 ns;
--  constant DELAY_MXICE		: time := 60 ns;
  constant DELAY_FFICE			: time := 300 ps;
  constant DELAY_MXICE			: time := 60 ps;

  signal AttrSRtype		: integer := 0;

  signal ce1r			: std_ulogic := 'X';
  signal ce2r			: std_ulogic := 'X';
  signal cesel			: std_logic_vector(1 downto 0) := (others => 'X');

  signal ice_zd			: std_ulogic := 'X';

begin

--####################################################################
--#####                     Initialize                           #####
--####################################################################
  prcs_init:process
  begin

     if((SRTYPE = "ASYNC") or (SRTYPE = "async")) then
        AttrSrtype <= 0;
     elsif((SRTYPE = "SYNC") or (SRTYPE = "sync")) then
        AttrSrtype <= 1;
     end if;

     wait;
  end process prcs_init;

--###################################################################
--#####                      update cesel                       #####
--###################################################################

  cesel  <= NUM_CE & CLKDIV; 

--####################################################################
--#####                         registers                        #####
--####################################################################
  prcs_reg:process(CLKDIV, GSR)
  variable ce1r_var		:  std_ulogic := TO_X01(INIT_CE(1));
  variable ce2r_var		:  std_ulogic := TO_X01(INIT_CE(0));
  begin
     if(GSR = '1') then
         ce1r_var		:= TO_X01(INIT_CE(1));
         ce2r_var		:= TO_X01(INIT_CE(0));
     elsif(GSR = '0') then
        case AttrSRtype is
           when 0 => 
            --------------- // async SET/RESET
                if(R = '1') then
                   ce1r_var := '0';
                   ce2r_var := '0';
                elsif(rising_edge(CLKDIV)) then
                   ce1r_var := ce1;
                   ce2r_var := ce2;
                end if;

           when 1 => 
            --------------- // sync SET/RESET
                if(rising_edge(CLKDIV)) then
                   if(R = '1') then
                      ce1r_var := '0';
                      ce2r_var := '0';
                   else
                      ce1r_var := ce1;
                      ce2r_var := ce2;
                   end if;
                end if;

           when others => 
                null;

        end case;
    end if;

   ce1r <= ce1r_var after DELAY_FFICE;
   ce2r <= ce2r_var after DELAY_FFICE;

  end process prcs_reg;
--####################################################################
--#####                        Output mux                        #####
--####################################################################
  prcs_mux:process(cesel, ce1, ce1r, ce2r)
  begin
    case cesel is
        when "00" =>
             ice_zd  <= ce1;
        when "01" =>
             ice_zd  <= ce1;
-- 426606
        when "10" =>
             ice_zd  <= ce2r;
        when "11" =>
             ice_zd  <= ce1r;
        when others =>
             null;
    end case;
  end process  prcs_mux;

--####################################################################
--#####                         OUTPUT                           #####
--####################################################################
  prcs_output:process(ice_zd)
  begin
      ICE <= ice_zd;
  end process prcs_output;
end ice_V;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;


library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.Vcomponents.all;
use simprim.VPACKAGE.all;
use simprim.vcomponents.all;
use simprim.vcomponents.all;

----- CELL X_ISERDES -----
--//////////////////////////////////////////////////////////// 
--////////////////////////// ISERDES /////////////////////////
--//////////////////////////////////////////////////////////// 

entity X_ISERDES is

  generic(

         TimingChecksOn	: boolean := true;
         InstancePath	: string  := "*";
         Xon		: boolean := true;
         MsgOn		: boolean := true;
         LOC            : string  := "UNPLACED";

--  VITAL input Pin path delay variables

      tipd_BITSLIP	: VitalDelayType01 := (0 ps, 0 ps);
      tipd_CE1		: VitalDelayType01 := (0 ps, 0 ps);
      tipd_CE2		: VitalDelayType01 := (0 ps, 0 ps);
      tipd_CLK		: VitalDelayType01 := (0 ps, 0 ps);
      tipd_CLKDIV	: VitalDelayType01 := (0 ps, 0 ps);
      tipd_D		: VitalDelayType01 := (0 ps, 0 ps);
      tipd_DLYCE	: VitalDelayType01 := (0 ps, 0 ps);
      tipd_DLYINC	: VitalDelayType01 := (0 ps, 0 ps);
      tipd_DLYRST	: VitalDelayType01 := (0 ps, 0 ps);
      tipd_GSR		: VitalDelayType01 := (0 ps, 0 ps);
      tipd_OCLK		: VitalDelayType01 := (0 ps, 0 ps);
      tipd_REV		: VitalDelayType01 := (0 ps, 0 ps);
      tipd_SR		: VitalDelayType01 := (0 ps, 0 ps);
      tipd_SHIFTIN1	: VitalDelayType01 := (0 ps, 0 ps);
      tipd_SHIFTIN2	: VitalDelayType01 := (0 ps, 0 ps);

--  VITAL clk-to-output path delay variables
      tpd_D_O		: VitalDelayType01 := (0 ps, 0 ps);
      tpd_CLKDIV_Q1	: VitalDelayType01 := (100 ps, 100 ps);
      tpd_CLKDIV_Q2	: VitalDelayType01 := (100 ps, 100 ps);
      tpd_CLKDIV_Q3	: VitalDelayType01 := (100 ps, 100 ps);
      tpd_CLKDIV_Q4	: VitalDelayType01 := (100 ps, 100 ps);
      tpd_CLKDIV_Q5	: VitalDelayType01 := (100 ps, 100 ps);
      tpd_CLKDIV_Q6	: VitalDelayType01 := (100 ps, 100 ps);

--  VITAL async set-to-output path delay variables
      tpd_SR_Q1		: VitalDelayType01 := (0 ps, 0 ps);
      tpd_SR_Q2		: VitalDelayType01 := (0 ps, 0 ps);
      tpd_SR_Q3		: VitalDelayType01 := (0 ps, 0 ps);
      tpd_SR_Q4		: VitalDelayType01 := (0 ps, 0 ps);
      tpd_SR_Q5		: VitalDelayType01 := (0 ps, 0 ps);
      tpd_SR_Q6		: VitalDelayType01 := (0 ps, 0 ps);

--  VITAL GSR-to-output path delay variable
      tpd_GSR_Q1	: VitalDelayType01 := (0 ps, 0 ps);
      tpd_GSR_Q2	: VitalDelayType01 := (0 ps, 0 ps);
      tpd_GSR_Q3	: VitalDelayType01 := (0 ps, 0 ps);
      tpd_GSR_Q4	: VitalDelayType01 := (0 ps, 0 ps);
      tpd_GSR_Q5	: VitalDelayType01 := (0 ps, 0 ps);
      tpd_GSR_Q6	: VitalDelayType01 := (0 ps, 0 ps);


--  VITAL ticd & tisd variables
      ticd_CLKDIV		: VitalDelayType := 0.0 ps;
      ticd_CLK			: VitalDelayType := 0.0 ps;
      ticd_OCLK			: VitalDelayType := 0.0 ps;

      tisd_BITSLIP_CLKDIV	: VitalDelayType := 0.0 ps;
      tisd_CE1_CLK		: VitalDelayType := 0.0 ps;
      tisd_CE1_CLKDIV		: VitalDelayType := 0.0 ps;
      tisd_CE2_CLKDIV		: VitalDelayType := 0.0 ps;
      tisd_D_CLK		: VitalDelayType := 0.0 ps;
      tisd_DLYCE_CLKDIV		: VitalDelayType := 0.0 ps;
      tisd_DLYINC_CLKDIV	: VitalDelayType := 0.0 ps;
      tisd_DLYRST_CLKDIV	: VitalDelayType := 0.0 ps;
      tisd_GSR			: VitalDelayType := 0.0 ps;
      tisd_REV_CLKDIV		: VitalDelayType := 0.0 ps;
      tisd_SR_CLKDIV		: VitalDelayType := 0.0 ps;
      tisd_SHIFTIN1		: VitalDelayType := 0.0 ps;
      tisd_SHIFTIN2		: VitalDelayType := 0.0 ps;

--  VITAL Setup/Hold delay variables

     tsetup_D_CLK_posedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_D_CLK_posedge_negedge : VitalDelayType := 0.0 ps;
     tsetup_D_CLK_negedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_D_CLK_negedge_negedge : VitalDelayType := 0.0 ps;
     thold_D_CLK_posedge_posedge : VitalDelayType := 0.0 ps;
     thold_D_CLK_posedge_negedge : VitalDelayType := 0.0 ps;
     thold_D_CLK_negedge_posedge : VitalDelayType := 0.0 ps;
     thold_D_CLK_negedge_negedge : VitalDelayType := 0.0 ps;

     tsetup_CE1_CLKDIV_posedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_CE1_CLKDIV_negedge_posedge : VitalDelayType := 0.0 ps;
     thold_CE1_CLKDIV_posedge_posedge  : VitalDelayType := 0.0 ps;
     thold_CE1_CLKDIV_negedge_posedge  : VitalDelayType := 0.0 ps;

     tsetup_CE1_CLK_posedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_CE1_CLK_posedge_negedge : VitalDelayType := 0.0 ps;
     tsetup_CE1_CLK_negedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_CE1_CLK_negedge_negedge : VitalDelayType := 0.0 ps;
     thold_CE1_CLK_posedge_posedge : VitalDelayType := 0.0 ps;
     thold_CE1_CLK_posedge_negedge : VitalDelayType := 0.0 ps;
     thold_CE1_CLK_negedge_posedge : VitalDelayType := 0.0 ps;
     thold_CE1_CLK_negedge_negedge : VitalDelayType := 0.0 ps;
--     tsetup_CE1_CLK_posedge_posedge : VitalDelayType := 0.0 ps;
--     tsetup_CE1_CLK_negedge_posedge : VitalDelayType := 0.0 ps;
--     thold_CE1_CLK_posedge_posedge  : VitalDelayType := 0.0 ps;
--     thold_CE1_CLK_negedge_posedge  : VitalDelayType := 0.0 ps;

     tsetup_CE2_CLKDIV_posedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_CE2_CLKDIV_negedge_posedge : VitalDelayType := 0.0 ps;
     thold_CE2_CLKDIV_posedge_posedge  : VitalDelayType := 0.0 ps;
     thold_CE2_CLKDIV_negedge_posedge  : VitalDelayType := 0.0 ps;

     tsetup_SR_CLKDIV_posedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_SR_CLKDIV_negedge_posedge : VitalDelayType := 0.0 ps;
     thold_SR_CLKDIV_posedge_posedge  : VitalDelayType := 0.0 ps;
     thold_SR_CLKDIV_negedge_posedge  : VitalDelayType := 0.0 ps;

     tsetup_SR_CLKDIV_posedge_negedge : VitalDelayType := 0.0 ps;
     tsetup_SR_CLKDIV_negedge_negedge : VitalDelayType := 0.0 ps;
     thold_SR_CLKDIV_posedge_negedge  : VitalDelayType := 0.0 ps;
     thold_SR_CLKDIV_negedge_negedge  : VitalDelayType := 0.0 ps;

     tsetup_REV_CLKDIV_posedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_REV_CLKDIV_negedge_posedge : VitalDelayType := 0.0 ps;
     thold_REV_CLKDIV_posedge_posedge  : VitalDelayType := 0.0 ps;
     thold_REV_CLKDIV_negedge_posedge  : VitalDelayType := 0.0 ps;

     tsetup_REV_CLKDIV_posedge_negedge : VitalDelayType := 0.0 ps;
     tsetup_REV_CLKDIV_negedge_negedge : VitalDelayType := 0.0 ps;
     thold_REV_CLKDIV_posedge_negedge  : VitalDelayType := 0.0 ps;
     thold_REV_CLKDIV_negedge_negedge  : VitalDelayType := 0.0 ps;

--     tsetup_REV_CLK_posedge_posedge : VitalDelayType := 0.0 ps;
--     tsetup_REV_CLK_negedge_posedge : VitalDelayType := 0.0 ps;
--     thold_REV_CLK_posedge_posedge  : VitalDelayType := 0.0 ps;
--     thold_REV_CLK_negedge_posedge  : VitalDelayType := 0.0 ps;

     tsetup_BITSLIP_CLKDIV_posedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_BITSLIP_CLKDIV_negedge_posedge : VitalDelayType := 0.0 ps;
     thold_BITSLIP_CLKDIV_posedge_posedge  : VitalDelayType := 0.0 ps;
     thold_BITSLIP_CLKDIV_negedge_posedge  : VitalDelayType := 0.0 ps;

     tsetup_DLYINC_CLKDIV_posedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_DLYINC_CLKDIV_negedge_posedge : VitalDelayType := 0.0 ps;
     thold_DLYINC_CLKDIV_posedge_posedge  : VitalDelayType := 0.0 ps;
     thold_DLYINC_CLKDIV_negedge_posedge  : VitalDelayType := 0.0 ps;

     tsetup_DLYCE_CLKDIV_posedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_DLYCE_CLKDIV_negedge_posedge : VitalDelayType := 0.0 ps;
     thold_DLYCE_CLKDIV_posedge_posedge  : VitalDelayType := 0.0 ps;
     thold_DLYCE_CLKDIV_negedge_posedge  : VitalDelayType := 0.0 ps;

     tsetup_DLYRST_CLKDIV_posedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_DLYRST_CLKDIV_negedge_posedge : VitalDelayType := 0.0 ps;
     thold_DLYRST_CLKDIV_posedge_posedge  : VitalDelayType := 0.0 ps;
     thold_DLYRST_CLKDIV_negedge_posedge  : VitalDelayType := 0.0 ps;

-- VITAL pulse width variables
      tpw_CLK_posedge	: VitalDelayType := 0 ps;
      tpw_GSR_posedge	: VitalDelayType := 0 ps;
      tpw_REV_posedge	: VitalDelayType := 0 ps;
      tpw_SR_posedge	: VitalDelayType := 0 ps;

-- VITAL period variables
      tperiod_CLK_posedge	: VitalDelayType := 0 ps;

-- VITAL recovery time variables
      trecovery_GSR_CLK_negedge_posedge : VitalDelayType := 0 ps;
      trecovery_REV_CLK_negedge_posedge : VitalDelayType := 0 ps;
      trecovery_SR_CLK_negedge_posedge  : VitalDelayType := 0 ps;

-- VITAL removal time variables
      tremoval_GSR_CLK_negedge_posedge  : VitalDelayType := 0 ps;
      tremoval_REV_CLK_negedge_posedge  : VitalDelayType := 0 ps;
      tremoval_SR_CLK_negedge_posedge   : VitalDelayType := 0 ps;

      DDR_CLK_EDGE	: string	:= "SAME_EDGE_PIPELINED";
      INIT_BITSLIPCNT	: bit_vector(3 downto 0) := "0000";
      INIT_CE		: bit_vector(1 downto 0) := "00";
      INIT_RANK1_PARTIAL: bit_vector(4 downto 0) := "00000";
      INIT_RANK2	: bit_vector(5 downto 0) := "000000";
      INIT_RANK3	: bit_vector(5 downto 0) := "000000";
      SERDES		: boolean	:= TRUE;
      SRTYPE		: string	:= "ASYNC";

      BITSLIP_ENABLE	: boolean	:= false;
      DATA_RATE		: string	:= "DDR";
      DATA_WIDTH	: integer	:= 4;
      INIT_Q1		: bit		:= '0';
      INIT_Q2		: bit		:= '0';
      INIT_Q3		: bit		:= '0';
      INIT_Q4		: bit		:= '0';
      INTERFACE_TYPE	: string	:= "MEMORY";
      IOBDELAY		: string	:= "NONE";
      IOBDELAY_TYPE	: string	:= "DEFAULT";
      IOBDELAY_VALUE	: integer	:= 0;
      NUM_CE		: integer	:= 2;
      SERDES_MODE	: string	:= "MASTER";
      SIM_DELAY_D       : integer	:= 0;
      SIM_HOLD_D_CLK    : integer	:= 0;
      SIM_SETUP_D_CLK   : integer	:= 0;
      SIM_TAPDELAY_VALUE: integer	:= 78;
      SRVAL_Q1		: bit		:= '0';
      SRVAL_Q2		: bit		:= '0';
      SRVAL_Q3		: bit		:= '0';
      SRVAL_Q4		: bit		:= '0'
      );
  port(
      O			: out std_ulogic;
      Q1		: out std_ulogic;
      Q2		: out std_ulogic;
      Q3		: out std_ulogic;
      Q4		: out std_ulogic;
      Q5		: out std_ulogic;
      Q6		: out std_ulogic;
      SHIFTOUT1		: out std_ulogic;
      SHIFTOUT2		: out std_ulogic;

      BITSLIP		: in std_ulogic;
      CE1		: in std_ulogic;
      CE2		: in std_ulogic;
      CLK		: in std_ulogic;
      CLKDIV		: in std_ulogic;
      D			: in std_ulogic;
      DLYCE		: in std_ulogic;
      DLYINC		: in std_ulogic;
      DLYRST		: in std_ulogic;
      OCLK		: in std_ulogic;
      REV		: in std_ulogic;
      SHIFTIN1		: in std_ulogic;
      SHIFTIN2		: in std_ulogic;
      SR		: in std_ulogic
    );

  attribute VITAL_LEVEL0 of
    X_ISERDES : entity is true;

end X_ISERDES;

architecture X_ISERDES_V OF X_ISERDES is

--  attribute VITAL_LEVEL0 of
--    X_ISERDES_V : architecture is true;

component bscntrl
  generic (
      SRTYPE            : string;
      INIT_BITSLIPCNT	: bit_vector(3 downto 0)
    );
  port(
      CLKDIV_INT        : out std_ulogic;
      MUXC              : out std_ulogic;

      BITSLIP           : in std_ulogic;
      C23               : in std_ulogic;
      C45               : in std_ulogic;
      C67               : in std_ulogic;
      CLK               : in std_ulogic;
      CLKDIV            : in std_ulogic;
      DATA_RATE         : in std_ulogic;
      R                 : in std_ulogic;
      SEL               : in std_logic_vector (1 downto 0)
      );
end component;

component ice_module
  generic(
      SRTYPE            : string;
      INIT_CE		: bit_vector(1 downto 0)
      );
  port(
      ICE		: out std_ulogic;

      CE1		: in std_ulogic;
      CE2		: in std_ulogic;
      NUM_CE		: in std_ulogic;
      CLKDIV		: in std_ulogic;
      R			: in std_ulogic
      );
end component;

component X_IDELAY
  generic(
      SIM_DELAY_D    : integer := 0;
      SIM_TAPDELAY_VALUE  : integer := 78;
      IOBDELAY_VALUE : integer := 0;
      IOBDELAY_TYPE  : string  := "DEFAULT"
    );

  port(
      O      : out std_ulogic;

      C      : in  std_ulogic;
      CE     : in  std_ulogic;
      I      : in  std_ulogic;
      INC    : in  std_ulogic;
      RST    : in  std_ulogic
    );
end component;

--  constant DELAY_FFINP          : time       := 300 ns; 
--  constant DELAY_MXINP1         : time       := 60  ns;
--  constant DELAY_MXINP2         : time       := 120 ns;
--  constant DELAY_OCLKDLY        : time       := 750 ns;

  constant SYNC_PATH_DELAY      : time       := 100 ps; 

  constant DELAY_FFINP          : time       := 300 ps; 
  constant DELAY_MXINP1         : time       := 60  ps;
  constant DELAY_MXINP2         : time       := 120 ps;
  constant DELAY_OCLKDLY        : time       := 750 ps;

  constant MAX_DATAWIDTH	: integer    := 4;

  signal BITSLIP_ipd	        : std_ulogic := 'X';
  signal CE1_ipd	        : std_ulogic := 'X';
  signal CE2_ipd	        : std_ulogic := 'X';
  signal CLK_ipd	        : std_ulogic := 'X';
  signal CLKDIV_ipd		: std_ulogic := 'X';
  signal D_ipd			: std_ulogic := 'X';
  signal DLYCE_ipd		: std_ulogic := 'X';
  signal DLYINC_ipd		: std_ulogic := 'X';
  signal DLYRST_ipd		: std_ulogic := 'X';
  signal GSR_ipd		: std_ulogic := 'X';
  signal OCLK_ipd		: std_ulogic := 'X';
  signal REV_ipd		: std_ulogic := 'X';
  signal SR_ipd			: std_ulogic := 'X';
  signal SHIFTIN1_ipd		: std_ulogic := 'X';
  signal SHIFTIN2_ipd		: std_ulogic := 'X';

  signal BITSLIP_dly	        : std_ulogic := 'X';
  signal CE1_dly	        : std_ulogic := 'X';
  signal CE2_dly	        : std_ulogic := 'X';
  signal CLK_dly	        : std_ulogic := 'X';
  signal CLKDIV_dly		: std_ulogic := 'X';
  signal D_dly			: std_ulogic := 'X';
  signal DLYCE_dly		: std_ulogic := 'X';
  signal DLYINC_dly		: std_ulogic := 'X';
  signal DLYRST_dly		: std_ulogic := 'X';
  signal GSR_dly		: std_ulogic := 'X';
  signal OCLK_dly		: std_ulogic := 'X';
  signal REV_dly		: std_ulogic := 'X';
  signal SR_dly			: std_ulogic := 'X';
  signal SHIFTIN1_dly		: std_ulogic := 'X';
  signal SHIFTIN2_dly		: std_ulogic := 'X';


  signal O_zd			: std_ulogic := 'X';
  signal Q1_zd			: std_ulogic := 'X';
  signal Q2_zd			: std_ulogic := 'X';
  signal Q3_zd			: std_ulogic := 'X';
  signal Q4_zd			: std_ulogic := 'X';
  signal Q5_zd			: std_ulogic := 'X';
  signal Q6_zd			: std_ulogic := 'X';
  signal SHIFTOUT1_zd		: std_ulogic := 'X';
  signal SHIFTOUT2_zd		: std_ulogic := 'X';

  signal O_viol			: std_ulogic := 'X';
  signal Q1_viol		: std_ulogic := 'X';
  signal Q2_viol		: std_ulogic := 'X';
  signal Q3_viol		: std_ulogic := 'X';
  signal Q4_viol		: std_ulogic := 'X';
  signal Q5_viol		: std_ulogic := 'X';
  signal Q6_viol		: std_ulogic := 'X';
  signal SHIFTOUT1_viol		: std_ulogic := 'X';
  signal SHIFTOUT2_viol		: std_ulogic := 'X';

  signal AttrSerdes		: std_ulogic := 'X';
  signal AttrMode		: std_ulogic := 'X';
  signal AttrDataRate		: std_ulogic := 'X';
  signal AttrDataWidth		: std_logic_vector(3 downto 0) := (others => 'X');
  signal AttrInterfaceType	: std_ulogic := 'X';
  signal AttrBitslipEnable	: std_ulogic := 'X';
  signal AttrNumCe		: std_ulogic := 'X';
  signal AttrDdrClkEdge		: std_logic_vector(1 downto 0) := (others => 'X');
  signal AttrSRtype		: integer := 0;
  signal AttrIobDelay		: integer := 0;

  signal sel1			: std_logic_vector(1 downto 0) := (others => 'X');
  signal selrnk3		: std_logic_vector(3 downto 0) := (others => 'X');
  signal bsmux			: std_logic_vector(2 downto 0) := (others => 'X');
  signal cntr			: std_logic_vector(4 downto 0) := (others => 'X');
  
  signal q1rnk1			: std_ulogic := 'X';
  signal q2nrnk1		: std_ulogic := 'X';
  signal q5rnk1			: std_ulogic := 'X';
  signal q6rnk1			: std_ulogic := 'X';
  signal q6prnk1		: std_ulogic := 'X';

  signal q1prnk1		: std_ulogic := 'X';
  signal q2prnk1		: std_ulogic := 'X';
  signal q3rnk1			: std_ulogic := 'X';
  signal q4rnk1			: std_ulogic := 'X';

  signal dataq5rnk1		: std_ulogic := 'X';
  signal dataq6rnk1		: std_ulogic := 'X';

  signal dataq3rnk1		: std_ulogic := 'X';
  signal dataq4rnk1		: std_ulogic := 'X';

  signal oclkmux		: std_ulogic := '0';
  signal memmux			: std_ulogic := '0';
  signal q2pmux			: std_ulogic := '0';

  signal clkdiv_int		: std_ulogic := '0';
  signal clkdivmux		: std_ulogic := '0';

  signal q1rnk2			: std_ulogic := 'X';
  signal q2rnk2			: std_ulogic := 'X';
  signal q3rnk2			: std_ulogic := 'X';
  signal q4rnk2			: std_ulogic := 'X';
  signal q5rnk2			: std_ulogic := 'X';
  signal q6rnk2			: std_ulogic := 'X';
  signal dataq1rnk2		: std_ulogic := 'X';
  signal dataq2rnk2		: std_ulogic := 'X';
  signal dataq3rnk2		: std_ulogic := 'X';
  signal dataq4rnk2		: std_ulogic := 'X';
  signal dataq5rnk2		: std_ulogic := 'X';
  signal dataq6rnk2		: std_ulogic := 'X';

  signal muxc			: std_ulogic := 'X';

  signal q1rnk3			: std_ulogic := 'X';
  signal q2rnk3			: std_ulogic := 'X';
  signal q3rnk3			: std_ulogic := 'X';
  signal q4rnk3			: std_ulogic := 'X';
  signal q5rnk3			: std_ulogic := 'X';
  signal q6rnk3			: std_ulogic := 'X';

  signal c23			: std_ulogic := 'X';
  signal c45			: std_ulogic := 'X';
  signal c67			: std_ulogic := 'X';
  signal sel			: std_logic_vector(1 downto 0) := (others => 'X');

  signal ice			: std_ulogic := 'X';
  signal datain			: std_ulogic := 'X';
  signal idelay_out		: std_ulogic := 'X';

  signal CLKN_dly		: std_ulogic := '0';

begin

  ---------------------
  --  INPUT PATH DELAYs
  --------------------

  WireDelay : block
  begin
    VitalWireDelay (BITSLIP_ipd,  BITSLIP,  tipd_BITSLIP);
    VitalWireDelay (CE1_ipd,      CE1,      tipd_CE1);
    VitalWireDelay (CE2_ipd,      CE2,      tipd_CE2);
    VitalWireDelay (CLK_ipd,      CLK,      tipd_CLK);
    VitalWireDelay (CLKDIV_ipd,   CLKDIV,   tipd_CLKDIV);
    VitalWireDelay (D_ipd,        D,        tipd_D);
    VitalWireDelay (DLYCE_ipd,    DLYCE,    tipd_DLYCE);
    VitalWireDelay (DLYINC_ipd,   DLYINC,   tipd_DLYINC);
    VitalWireDelay (DLYRST_ipd,   DLYRST,   tipd_DLYRST);
    VitalWireDelay (GSR_ipd,      GSR,      tipd_GSR);
    VitalWireDelay (OCLK_ipd,     OCLK,     tipd_OCLK);
    VitalWireDelay (REV_ipd,      REV,      tipd_REV);
    VitalWireDelay (SR_ipd,       SR,       tipd_SR);
    VitalWireDelay (SHIFTIN1_ipd, SHIFTIN1, tipd_SHIFTIN1);
    VitalWireDelay (SHIFTIN2_ipd, SHIFTIN2, tipd_SHIFTIN2);
  end block;

  SignalDelay : block
  begin
    VitalSignalDelay (BITSLIP_dly,  BITSLIP_ipd,  tisd_BITSLIP_CLKDIV);
    VitalSignalDelay (CE1_dly,      CE1_ipd,      tisd_CE1_CLKDIV);
    VitalSignalDelay (CE2_dly,      CE2_ipd,      tisd_CE2_CLKDIV);
    VitalSignalDelay (CLK_dly,      CLK_ipd,      ticd_CLK);
    VitalSignalDelay (CLKDIV_dly,   CLKDIV_ipd,   ticd_CLKDIV);
    VitalSignalDelay (D_dly,        D_ipd,        tisd_D_CLK);
    VitalSignalDelay (DLYCE_dly,    DLYCE_ipd,    tisd_DLYCE_CLKDIV);
    VitalSignalDelay (DLYINC_dly,   DLYINC_ipd,   tisd_DLYINC_CLKDIV);
    VitalSignalDelay (DLYRST_dly,   DLYRST_ipd,   tisd_DLYRST_CLKDIV);
    VitalSignalDelay (GSR_dly,      GSR_ipd,      tisd_GSR);
    VitalSignalDelay (OCLK_dly,     OCLK_ipd,     ticd_OCLK);
    VitalSignalDelay (REV_dly,      REV_ipd,      tisd_REV_CLKDIV);
    VitalSignalDelay (SR_dly,       SR_ipd,       tisd_SR_CLKDIV);
    VitalSignalDelay (SHIFTIN1_dly, SHIFTIN1_ipd, tisd_SHIFTIN1);
    VitalSignalDelay (SHIFTIN2_dly, SHIFTIN2_ipd, tisd_SHIFTIN2);
  end block;

  --------------------
  --  BEHAVIOR SECTION
  --------------------


--####################################################################
--#####                     Initialize                           #####
--####################################################################
  prcs_init:process
  variable AttrSerdes_var		: std_ulogic := 'X';
  variable AttrMode_var			: std_ulogic := 'X';
  variable AttrDataRate_var		: std_ulogic := 'X';
  variable AttrDataWidth_var		: std_logic_vector(3 downto 0) := (others => 'X');
  variable AttrInterfaceType_var	: std_ulogic := 'X';
  variable AttrBitslipEnable_var	: std_ulogic := 'X';
  variable AttrDdrClkEdge_var		: std_logic_vector(1 downto 0) := (others => 'X');
  variable AttrIobDelay_var		: integer := 0;

  begin

      --------CR 447760  DRC -- BITSLIP - INTERFACE_TYPE combination  ------------------

      if((INTERFACE_TYPE = "MEMORY") and (BITSLIP_ENABLE = TRUE)) then
        assert false
        report "Attribute Syntax Error: BITSLIP_ENABLE is currently set to TRUE when INTERFACE_TYPE is set to MEMORY. This is an invalid configuration."
        severity Failure;
     elsif((INTERFACE_TYPE = "NETWORKING") and (BITSLIP_ENABLE = FALSE)) then
        assert false
        report "Attribute Syntax Error: BITSLIP_ENABLE is currently set to FALSE when INTERFACE_TYPE is set to NETWORKING. If BITSLIP is not intended to be used, please set BITSLIP_ENABLE to TRUE and tie the BITSLIP port to ground."
        severity Failure;
     end if;

      -------------------- SERDES validity check --------------------
      if(SERDES = true) then
        AttrSerdes_var := '1';
      else
        AttrSerdes_var := '0';
      end if;

      ------------- SERDES_MODE validity check --------------------
      if((SERDES_MODE = "MASTER") or (SERDES_MODE = "master")) then
         AttrMode_var := '0';
      elsif((SERDES_MODE = "SLAVE") or (SERDES_MODE = "slave")) then
         AttrMode_var := '1';
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Warning ",
             GenericName => "SERDES_MODE ",
             EntityName => "/X_ISERDES",
             GenericValue => SERDES_MODE,
             Unit => "",
             ExpectedValueMsg => " The Legal values for this attribute are ",
             ExpectedGenericValue => " MASTER or SLAVE.",
             TailMsg => "",
             MsgSeverity => FAILURE 
         );
      end if;

      ------------------ DATA_RATE validity check ------------------
      if((DATA_RATE = "DDR") or (DATA_RATE = "ddr")) then
         AttrDataRate_var := '0';
      elsif((DATA_RATE = "SDR") or (DATA_RATE = "sdr")) then
         AttrDataRate_var := '1';
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Warning ",
             GenericName => " DATA_RATE ",
             EntityName => "/X_ISERDES",
             GenericValue => DATA_RATE,
             Unit => "",
             ExpectedValueMsg => " The Legal values for this attribute are ",
             ExpectedGenericValue => " DDR or SDR. ",
             TailMsg => "",
             MsgSeverity => Failure
         );
      end if;

      ------------------ DATA_WIDTH validity check ------------------
      if((DATA_WIDTH = 2) or (DATA_WIDTH = 3) or  (DATA_WIDTH = 4) or
         (DATA_WIDTH = 5) or (DATA_WIDTH = 6) or  (DATA_WIDTH = 7) or
         (DATA_WIDTH = 8) or (DATA_WIDTH = 10)) then
         AttrDataWidth_var := CONV_STD_LOGIC_VECTOR(DATA_WIDTH, MAX_DATAWIDTH); 
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Warning ",
             GenericName => " DATA_WIDTH ",
             EntityName => "/X_ISERDES",
             GenericValue => DATA_WIDTH,
             Unit => "",
             ExpectedValueMsg => " The Legal values for this attribute are ",
             ExpectedGenericValue => " 2, 3, 4, 5, 6, 7, 8, or 10 ",
             TailMsg => "",
             MsgSeverity => Failure
         );
      end if;
      ------------ DATA_WIDTH /DATA_RATE combination check ------------
      if((DATA_RATE = "DDR") or (DATA_RATE = "ddr")) then
         case (DATA_WIDTH) is
             when 4|6|8|10  => null;
             when others       =>
                GenericValueCheckMessage
                (  HeaderMsg  => " Attribute Syntax Warning ",
                   GenericName => " DATA_WIDTH ",
                   EntityName => "/X_ISERDES",
                   GenericValue => DATA_WIDTH,
                   Unit => "",
                   ExpectedValueMsg => " The Legal values for DDR mode are ",
                   ExpectedGenericValue => " 4, 6, 8, or 10 ",
                   TailMsg => "",
                   MsgSeverity => Failure
                );
          end case;
      end if;

      if((DATA_RATE = "SDR") or (DATA_RATE = "sdr")) then
         case (DATA_WIDTH) is
             when 2|3|4|5|6|7|8  => null;
             when others       =>
                GenericValueCheckMessage
                (  HeaderMsg  => " Attribute Syntax Warning ",
                   GenericName => " DATA_WIDTH ",
                   EntityName => "/X_ISERDES",
                   GenericValue => DATA_WIDTH,
                   Unit => "",
                   ExpectedValueMsg => " The Legal values for SDR mode are ",
                   ExpectedGenericValue => " 2, 3, 4, 5, 6, 7 or 8",
                   TailMsg => "",
                   MsgSeverity => Failure
                );
          end case;
      end if;
      ---------------- INTERFACE_TYPE validity check ---------------
      if((INTERFACE_TYPE = "MEMORY") or (INTERFACE_TYPE = "memory")) then
         AttrInterfaceType_var := '0';
      elsif((INTERFACE_TYPE = "NETWORKING") or (INTERFACE_TYPE = "networking")) then
         AttrInterfaceType_var := '1';
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Warning ",
             GenericName => "INTERFACE_TYPE ",
             EntityName => "/X_ISERDES",
             GenericValue => INTERFACE_TYPE,
             Unit => "",
             ExpectedValueMsg => " The Legal values for this attribute are ",
             ExpectedGenericValue => " MEMORY or NETWORKING.",
             TailMsg => "",
             MsgSeverity => FAILURE 
         );
      end if;

      ---------------- BITSLIP_ENABLE validity check -------------------
      if(BITSLIP_ENABLE = false) then
         AttrBitslipEnable_var := '0';
      elsif(BITSLIP_ENABLE = true) then
         AttrBitslipEnable_var := '1';
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Warning ",
             GenericName => " BITSLIP_ENABLE ",
             EntityName => "/X_ISERDES",
             GenericValue => BITSLIP_ENABLE,
             Unit => "",
             ExpectedValueMsg => " The Legal values for this attribute are ",
             ExpectedGenericValue => " TRUE or FALSE ",
             TailMsg => "",
             MsgSeverity => Failure
         );
      end if;

      ----------------     NUM_CE validity check    -------------------
      case NUM_CE is
         when 1 =>
                AttrNumCe <= '0';
         when 2 =>
                AttrNumCe <= '1';
         when others =>
                GenericValueCheckMessage
                  (  HeaderMsg  => " Attribute Syntax Warning ",
                     GenericName => " NUM_CE ",
                     EntityName => "/X_ISERDES",
                     GenericValue => NUM_CE,
                     Unit => "",
                     ExpectedValueMsg => " The Legal values for this attribute are ",
                     ExpectedGenericValue => " 1 or 2 ",
                     TailMsg => "",
                     MsgSeverity => Failure
                  );
      end case;
      ----------------     IOBDELAY validity check  -------------------
      if((IOBDELAY = "NONE") or (IOBDELAY = "none")) then
         AttrIobDelay_var := 0;
      elsif((IOBDELAY = "IBUF") or (IOBDELAY = "ibuf")) then
         AttrIobDelay_var := 1;
      elsif((IOBDELAY = "IFD") or (IOBDELAY = "ifd")) then
         AttrIobDelay_var := 2;
      elsif((IOBDELAY = "BOTH") or (IOBDELAY = "both")) then
         AttrIobDelay_var := 3;
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Warning ",
             GenericName => " IOBDELAY ",
             EntityName => "/X_ISERDES",
             GenericValue => IOBDELAY,
             Unit => "",
             ExpectedValueMsg => " The Legal values for this attribute are ",
             ExpectedGenericValue => " NONE or IBUF or IFD or BOTH ",
             TailMsg => "",
             MsgSeverity => Failure
         );
      end if;
      ------------     IOBDELAY_VALUE validity check  -----------------
      ------------     IOBDELAY_TYPE validity check   -----------------
--
--
--
      ------------------ DDR_CLK_EDGE validity check ------------------
      if((DDR_CLK_EDGE = "SAME_EDGE_PIPELINED") or (DDR_CLK_EDGE = "same_edge_pipelined")) then
         AttrDdrClkEdge_var := "00";
      elsif((DDR_CLK_EDGE = "SAME_EDGE") or (DDR_CLK_EDGE = "same_edge")) then
         AttrDdrClkEdge_var := "01";
      elsif((DDR_CLK_EDGE = "OPPOSITE_EDGE") or (DDR_CLK_EDGE = "opposite_edge")) then
         AttrDdrClkEdge_var := "10";
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Warning ",
             GenericName => " DDR_CLK_EDGE ",
             EntityName => "/X_ISERDES",
             GenericValue => DDR_CLK_EDGE,
             Unit => "",
             ExpectedValueMsg => " The Legal values for this attribute are ",
             ExpectedGenericValue => " SAME_EDGE_PIPELINED or SAME_EDGE or OPPOSITE_EDGE ",
             TailMsg => "",
             MsgSeverity => Failure
         );
      end if;
      ------------------ DATA_RATE validity check ------------------
      if((SRTYPE = "ASYNC") or (SRTYPE = "async")) then
         AttrSrtype <= 0;
      elsif((SRTYPE = "SYNC") or (SRTYPE = "sync")) then
         AttrSrtype <= 1;
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Warning ",
             GenericName => " SRTYPE ",
             EntityName => "/X_ISERDES",
             GenericValue => SRTYPE,
             Unit => "",
             ExpectedValueMsg => " The Legal values for this attribute are ",
             ExpectedGenericValue => " ASYNC or SYNC. ",
             TailMsg => "",
             MsgSeverity => ERROR
         );
      end if;
---------------------------------------------------------------------

     AttrSerdes		<= AttrSerdes_var;
     AttrMode		<= AttrMode_var;
     AttrDataRate	<= AttrDataRate_var;
     AttrDataWidth	<= AttrDataWidth_var;
     AttrInterfaceType	<= AttrInterfaceType_var;
     AttrBitslipEnable	<= AttrBitslipEnable_var;
     AttrDdrClkEdge	<= AttrDdrClkEdge_var;
     AttrIobDelay	<= AttrIobDelay_var;

     sel1     <= AttrMode_var & AttrDataRate_var; 
     selrnk3  <= AttrSerdes_var & AttrBitslipEnable_var & AttrDdrClkEdge_var; 
     cntr     <= AttrDataRate_var & AttrDataWidth_var;

     wait;
  end process prcs_init;

--###################################################################
--#####               SHIFTOUT1 and SHIFTOUT2                   #####
--###################################################################

  SHIFTOUT2_zd <= q5rnk1;
  SHIFTOUT1_zd <= q6rnk1;

--###################################################################
--#####                     q1rnk1 reg                          #####
--###################################################################
  prcs_Q1_rnk1:process(CLK_dly, GSR_dly, REV_dly, SR_dly)
  variable q1rnk1_var         : std_ulogic := TO_X01(INIT_Q1);
  begin
     if(GSR_dly = '1') then
         q1rnk1_var  :=  TO_X01(INIT_Q1);
     elsif(GSR_dly = '0') then
        case AttrSRtype is
           when 0 => 
           --------------- // async SET/RESET
                   if((SR_dly = '1') and (not ((REV_dly = '1') and (TO_X01(SRVAL_Q1) = '1')))) then
                      q1rnk1_var := TO_X01(SRVAL_Q1);
                   elsif(REV_dly = '1') then
                      q1rnk1_var := not TO_X01(SRVAL_Q1);
                   elsif((SR_dly = '0') and (REV_dly = '0')) then
                      if(ice = '1') then
                         if(rising_edge(CLK_dly)) then
                            q1rnk1_var := datain;
                         end if;
                      end if;
                   end if;

           when 1 => 
           --------------- // sync SET/RESET
                   if(rising_edge(CLK_dly)) then
                      if((SR_dly = '1') and (not ((REV_dly = '1') and (TO_X01(SRVAL_Q1) = '1')))) then
                         q1rnk1_var := TO_X01(SRVAL_Q1);
                      Elsif(REV_dly = '1') then
                         q1rnk1_var := not TO_X01(SRVAL_Q1);
                      elsif((SR_dly = '0') and (REV_dly = '0')) then
                         if(ice = '1') then
                            q1rnk1_var := datain;
                         end if;
                      end if;
                   end if;

           when others =>
                   null;
                        
        end case;
     end if;

     q1rnk1  <= q1rnk1_var  after DELAY_FFINP;

  end process prcs_Q1_rnk1;
--###################################################################
--#####              q5rnk1, q6rnk1 and q6prnk1 reg             #####
--###################################################################
  prcs_Q5Q6Q6p_rnk1:process(CLK_dly, GSR_dly, SR_dly)
  variable q5rnk1_var         : std_ulogic := TO_X01(INIT_RANK1_PARTIAL(2));
  variable q6rnk1_var         : std_ulogic := TO_X01(INIT_RANK1_PARTIAL(1));
  variable q6prnk1_var        : std_ulogic := TO_X01(INIT_RANK1_PARTIAL(0));
  begin
     if(GSR_dly = '1') then
         q5rnk1_var  := TO_X01(INIT_RANK1_PARTIAL(2));
         q6rnk1_var  := TO_X01(INIT_RANK1_PARTIAL(1));
         q6prnk1_var := TO_X01(INIT_RANK1_PARTIAL(0));
     elsif(GSR_dly = '0') then
        case AttrSRtype is
           when 0 => 
           --------- // async SET/RESET  -- Not full featured FFs
                   if(SR_dly = '1') then
                      q5rnk1_var  := '0';
                      q6rnk1_var  := '0';
                      q6prnk1_var := '0';
                   elsif(SR_dly = '0') then
                      if(rising_edge(CLK_dly)) then
                         q5rnk1_var  := dataq5rnk1;
                         q6rnk1_var  := dataq6rnk1;
                         q6prnk1_var := q6rnk1;
                      end if;
                   end if;

           when 1 => 
           --------- // sync SET/RESET  -- Not full featured FFs
                   if(rising_edge(CLK_dly)) then
                      if(SR_dly = '1') then
                         q5rnk1_var  := '0';
                         q6rnk1_var  := '0';
                         q6prnk1_var := '0';
                      elsif(SR_dly = '0') then
                         q5rnk1_var  := dataq5rnk1;
                         q6rnk1_var  := dataq6rnk1;
                         q6prnk1_var := q6rnk1;
                      end if;
                   end if;

           when others =>
                   null;
                        
        end case;
     end if;

     q5rnk1  <= q5rnk1_var  after DELAY_FFINP;
     q6rnk1  <= q6rnk1_var  after DELAY_FFINP;
     q6prnk1 <= q6prnk1_var after DELAY_FFINP;

  end process prcs_Q5Q6Q6p_rnk1;
--###################################################################
--#####                     q2nrnk1 reg                          #####
--###################################################################
  prcs_Q2_rnk1:process(CLK_dly, GSR_dly, SR_dly, REV_dly)
  variable q2nrnk1_var         : std_ulogic := TO_X01(INIT_Q2);
  begin
     if(GSR_dly = '1') then
         q2nrnk1_var  := TO_X01(INIT_Q2);
     elsif(GSR_dly = '0') then
        case AttrSRtype is
           when 0 => 
           --------------- // async SET/RESET
                   if((SR_dly = '1') and (not ((REV_dly = '1') and (TO_X01(SRVAL_Q2) = '1')))) then
                      q2nrnk1_var  := TO_X01(SRVAL_Q2);
                   elsif(REV_dly = '1') then
                      q2nrnk1_var  := not TO_X01(SRVAL_Q2);
                   elsif((SR_dly = '0') and (REV_dly = '0')) then
                      if(ice = '1') then
                         if(falling_edge(CLK_dly)) then
                            q2nrnk1_var     := datain;
                         end if;
                      end if;
                   end if;

           when 1 => 
           --------------- // sync SET/RESET
                   if(falling_edge(CLK_dly)) then
                      if((SR_dly = '1') and (not ((REV_dly = '1') and (TO_X01(SRVAL_Q2) = '1')))) then
                         q2nrnk1_var  := TO_X01(SRVAL_Q2);
                      elsif(REV_dly = '1') then
                         q2nrnk1_var  := not TO_X01(SRVAL_Q2);
                      elsif((SR_dly = '0') and (REV_dly = '0')) then
                         if(ice = '1') then
                            q2nrnk1_var := datain;
                         end if;
                      end if;
                   end if;

           when others =>
                   null;
                        
        end case;
     end if;

     q2nrnk1  <= q2nrnk1_var after DELAY_FFINP;

  end process prcs_Q2_rnk1;
--###################################################################
--#####                       q2prnk1 reg                       #####
--###################################################################
  prcs_Q2p_rnk1:process(q2pmux, GSR_dly, REV_dly, SR_dly)
  variable q2prnk1_var        : std_ulogic := TO_X01(INIT_Q4);
  begin
     if(GSR_dly = '1') then
         q2prnk1_var := TO_X01(INIT_Q4);
     elsif(GSR_dly = '0') then
        case AttrSRtype is
           when 0 => 
           --------------- // async SET/RESET
                   if((SR_dly = '1') and (not ((REV_dly = '1') and (TO_X01(SRVAL_Q4) = '1')))) then
                      q2prnk1_var := TO_X01(SRVAL_Q4);
                   elsif(REV_dly = '1') then
                      q2prnk1_var := not TO_X01(SRVAL_Q4);
                   elsif((SR_dly = '0') and (REV_dly = '0')) then
                      if(ice = '1') then
                         if(rising_edge(q2pmux)) then
                            q2prnk1_var := q2nrnk1;
                         end if;
                      end if;
                   end if;

           when 1 => 
           --------------- // sync SET/RESET
                   if(rising_edge(q2pmux)) then
                      if((SR_dly = '1') and (not ((REV_dly = '1') and (TO_X01(SRVAL_Q4) = '1')))) then
                         q2prnk1_var := TO_X01(SRVAL_Q4);
                      elsif(REV_dly = '1') then
                         q2prnk1_var := not TO_X01(SRVAL_Q4);
                      elsif((SR_dly = '0') and (REV_dly = '0')) then
                         if(ice = '1') then
                              q2prnk1_var := q2nrnk1;
                         end if;
                      end if;
                   end if;

           when others =>
                   null;
                        
        end case;
     end if;

     q2prnk1  <= q2prnk1_var after DELAY_FFINP;

  end process prcs_Q2p_rnk1;
--###################################################################
--#####                      q1prnk1  reg                       #####
--###################################################################
  prcs_Q1p_rnk1:process(memmux, GSR_dly, REV_dly, SR_dly)
  variable q1prnk1_var        : std_ulogic := TO_X01(INIT_Q3);
  begin
     if(GSR_dly = '1') then
         q1prnk1_var := TO_X01(INIT_Q3);
     elsif(GSR_dly = '0') then
        case AttrSRtype is
           when 0 => 
           --------------- // async SET/RESET
                   if((SR_dly = '1') and (not ((REV_dly = '1') and (TO_X01(SRVAL_Q3) = '1')))) then
                      q1prnk1_var := TO_X01(SRVAL_Q3);
                   elsif(REV_dly = '1') then
                      q1prnk1_var := not TO_X01(SRVAL_Q3);
                   elsif((SR_dly = '0') and (REV_dly = '0')) then
                      if(ice = '1') then
                         if(rising_edge(memmux)) then
                            q1prnk1_var := q1rnk1;
                         end if;
                      end if;
                   end if;


           when 1 => 
           --------------- // sync SET/RESET
                   if(rising_edge(memmux)) then
                      if((SR_dly = '1') and (not ((REV_dly = '1') and (TO_X01(SRVAL_Q3) = '1')))) then
                         q1prnk1_var := TO_X01(SRVAL_Q3);
                      elsif(REV_dly = '1') then
                         q1prnk1_var := not TO_X01(SRVAL_Q3);
                      elsif((SR_dly = '0') and (REV_dly = '0')) then
                         if(ice = '1') then
                            q1prnk1_var := q1rnk1;
                         end if;
                      end if;
                   end if;

           when others =>
                   null;
                        
        end case;
     end if;

     q1prnk1  <= q1prnk1_var after DELAY_FFINP;

  end process prcs_Q1p_rnk1;
--###################################################################
--#####                  q3rnk1 and q4rnk1 reg                  #####
--###################################################################
  prcs_Q3Q4_rnk1:process(memmux, GSR_dly, SR_dly)
  variable q3rnk1_var         : std_ulogic := TO_X01(INIT_RANK1_PARTIAL(4));
  variable q4rnk1_var         : std_ulogic := TO_X01(INIT_RANK1_PARTIAL(3));
  begin
     if(GSR_dly = '1') then
         q3rnk1_var  := TO_X01(INIT_RANK1_PARTIAL(4));
         q4rnk1_var  := TO_X01(INIT_RANK1_PARTIAL(3));
     elsif(GSR_dly = '0') then
        case AttrSRtype is
           when 0 => 
           -------- // async SET/RESET  -- not fully featured FFs
                   if(SR_dly = '1') then
                      q3rnk1_var  := '0';
                      q4rnk1_var  := '0';
                   elsif(SR_dly = '0') then
                      if(rising_edge(memmux)) then
                         q3rnk1_var  := dataq3rnk1;
                         q4rnk1_var  := dataq4rnk1;
                      end if;
                   end if;

           when 1 => 
           -------- // sync SET/RESET -- not fully featured FFs
                   if(rising_edge(memmux)) then
                      if(SR_dly = '1') then
                         q3rnk1_var  := '0';
                         q4rnk1_var  := '0';
                      elsif(SR_dly = '0') then
                         q3rnk1_var  := dataq3rnk1;
                         q4rnk1_var  := dataq4rnk1;
                      end if;
                   end if;

           when others =>
                   null;
                        
        end case;
     end if;

     q3rnk1   <= q3rnk1_var after DELAY_FFINP;
     q4rnk1   <= q4rnk1_var after DELAY_FFINP;

  end process prcs_Q3Q4_rnk1;
--###################################################################
--#####        clock mux --  oclkmux with delay element         #####
--###################################################################
--  prcs_oclkmux:process(OCLK_dly)
--  begin
--     case AttrOclkDelay is
--           when '0' => 
--                    oclkmux <= OCLK_dly after DELAY_MXINP1;
--           when '1' => 
--                    oclkmux <= OCLK_dly after DELAY_OCLKDLY;
--           when others =>
--                    oclkmux <= OCLK_dly after DELAY_MXINP1;
--     end case;
--  end process prcs_oclkmux;
--
--
--
--///////////////////////////////////////////////////////////////////
--// Mux elements for the 1st Rank
--///////////////////////////////////////////////////////////////////
--###################################################################
--#####              memmux -- 4 clock muxes in first rank      #####
--###################################################################
  prcs_memmux:process(CLK_dly, OCLK_dly)
  begin
     case AttrInterfaceType is
           when '0' => 
                    memmux <= OCLK_dly after DELAY_MXINP1;
           when '1' => 
                    memmux <= CLK_dly after DELAY_MXINP1;
           when others =>
                    memmux <= OCLK_dly after DELAY_MXINP1;
     end case;
  end process prcs_memmux;

--###################################################################
--#####      q2pmux -- Optional inverter for q2p (4th flop in rank1)
--###################################################################
  prcs_q2pmux:process(memmux)
  begin
     case AttrInterfaceType is
           when '0' => 
                    q2pmux <= not memmux after DELAY_MXINP1;
           when '1' => 
                    q2pmux <= memmux after DELAY_MXINP1;
           when others =>
                    q2pmux <= memmux after DELAY_MXINP1;
     end case;
  end process prcs_q2pmux;
--###################################################################
--#####                data input muxes for q3q4  and q5q6      #####
--###################################################################
  prcs_Q3Q4_mux:process(q1prnk1, q2prnk1, q3rnk1, SHIFTIN1_dly, SHIFTIN2_dly)
  begin
     case sel1 is
           when "00" =>
                    dataq3rnk1 <= q1prnk1 after DELAY_MXINP1;
                    dataq4rnk1 <= q2prnk1 after DELAY_MXINP1;
           when "01" =>
                    dataq3rnk1 <= q1prnk1 after DELAY_MXINP1;
                    dataq4rnk1 <= q3rnk1  after DELAY_MXINP1;
           when "10" =>
                    dataq3rnk1 <= SHIFTIN2_dly after DELAY_MXINP1;
                    dataq4rnk1 <= SHIFTIN1_dly after DELAY_MXINP1;
           when "11" =>
                    dataq3rnk1 <= SHIFTIN1_dly after DELAY_MXINP1;
                    dataq4rnk1 <= q3rnk1   after DELAY_MXINP1;
           when others =>
                    dataq3rnk1 <= q1prnk1 after DELAY_MXINP1;
                    dataq4rnk1 <= q2prnk1 after DELAY_MXINP1;
     end case;

  end process prcs_Q3Q4_mux;
----------------------------------------------------------------------
  prcs_Q5Q6_mux:process(q3rnk1, q4rnk1, q5rnk1)
  begin
     case AttrDataRate is 
           when '0' =>
                    dataq5rnk1 <= q3rnk1 after DELAY_MXINP1;
                    dataq6rnk1 <= q4rnk1 after DELAY_MXINP1;
           when '1' =>
                    dataq5rnk1 <= q4rnk1 after DELAY_MXINP1;
                    dataq6rnk1 <= q5rnk1 after DELAY_MXINP1;
           when others =>
                    dataq5rnk1 <= q4rnk1 after DELAY_MXINP1;
                    dataq6rnk1 <= q5rnk1 after DELAY_MXINP1;
     end case;
  end process prcs_Q5Q6_mux;



---////////////////////////////////////////////////////////////////////
---                       2nd rank of registors
---////////////////////////////////////////////////////////////////////

--###################################################################
--#####    clkdivmux to choose between clkdiv_int or CLKDIV     #####
--###################################################################
  prcs_clkdivmux:process(clkdiv_int, CLKDIV_dly)
  begin
     case AttrBitslipEnable is
           when '0' =>
                    clkdivmux <= CLKDIV_dly after DELAY_MXINP1;
           when '1' =>
                    clkdivmux <= clkdiv_int after DELAY_MXINP1;
           when others =>
                    clkdivmux <= CLKDIV_dly after DELAY_MXINP1;
     end case;
  end process prcs_clkdivmux;

--###################################################################
--#####  q1rnk2, q2rnk2, q3rnk2,q4rnk2 ,q5rnk2 and q6rnk2 reg   #####
--###################################################################
  prcs_Q1Q2Q3Q4Q5Q6_rnk2:process(clkdivmux, GSR_dly, SR_dly)
  variable q1rnk2_var         : std_ulogic := TO_X01(INIT_RANK2(0));
  variable q2rnk2_var         : std_ulogic := TO_X01(INIT_RANK2(1));
  variable q3rnk2_var         : std_ulogic := TO_X01(INIT_RANK2(2));
  variable q4rnk2_var         : std_ulogic := TO_X01(INIT_RANK2(3));
  variable q5rnk2_var         : std_ulogic := TO_X01(INIT_RANK2(4));
  variable q6rnk2_var         : std_ulogic := TO_X01(INIT_RANK2(5));
  begin
     if(GSR_dly = '1') then
         q1rnk2_var := TO_X01(INIT_RANK2(0));
         q2rnk2_var := TO_X01(INIT_RANK2(1));
         q3rnk2_var := TO_X01(INIT_RANK2(2));
         q4rnk2_var := TO_X01(INIT_RANK2(3));
         q5rnk2_var := TO_X01(INIT_RANK2(4));
         q6rnk2_var := TO_X01(INIT_RANK2(5));
     elsif(GSR_dly = '0') then
        case AttrSRtype is
           when 0 => 
           --------------- // async SET/RESET
                   if(SR_dly = '1') then
                      q1rnk2_var := '0';
                      q2rnk2_var := '0';
                      q3rnk2_var := '0';
                      q4rnk2_var := '0';
                      q5rnk2_var := '0';
                      q6rnk2_var := '0';
                   elsif(SR_dly = '0') then
                       if(rising_edge(clkdivmux)) then
                           q1rnk2_var := dataq1rnk2;
                           q2rnk2_var := dataq2rnk2;
                           q3rnk2_var := dataq3rnk2;
                           q4rnk2_var := dataq4rnk2;
                           q5rnk2_var := dataq5rnk2;
                           q6rnk2_var := dataq6rnk2;
                       end if;
                   end if;

           when 1 => 
           --------------- // sync SET/RESET
                   if(rising_edge(clkdivmux)) then
                      if(SR_dly = '1') then
                         q1rnk2_var := '0';
                         q2rnk2_var := '0';
                         q3rnk2_var := '0';
                         q4rnk2_var := '0';
                         q5rnk2_var := '0';
                         q6rnk2_var := '0';
                      elsif(SR_dly = '0') then
                         q1rnk2_var := dataq1rnk2;
                         q2rnk2_var := dataq2rnk2;
                         q3rnk2_var := dataq3rnk2;
                         q4rnk2_var := dataq4rnk2;
                         q5rnk2_var := dataq5rnk2;
                         q6rnk2_var := dataq6rnk2;
                      end if;
                   end if;
           when others =>
                   null;
        end case;
     end if;

     q1rnk2  <= q1rnk2_var after DELAY_FFINP;
     q2rnk2  <= q2rnk2_var after DELAY_FFINP;
     q3rnk2  <= q3rnk2_var after DELAY_FFINP;
     q4rnk2  <= q4rnk2_var after DELAY_FFINP;
     q5rnk2  <= q5rnk2_var after DELAY_FFINP;
     q6rnk2  <= q6rnk2_var after DELAY_FFINP;

  end process prcs_Q1Q2Q3Q4Q5Q6_rnk2;

--###################################################################
--#####                    update bitslip mux                   #####
--###################################################################

  bsmux  <= AttrBitslipEnable & AttrDataRate & muxc; 

--###################################################################
--#####    Data mux for 2nd rank of registers                  ######
--###################################################################
  prcs_Q1Q2Q3Q4Q5Q6_rnk2_mux:process(bsmux, q1rnk1, q1prnk1, q2prnk1, 
                           q3rnk1, q4rnk1, q5rnk1, q6rnk1, q6prnk1)
  begin
     case bsmux is
        when "000" | "001" =>
                 dataq1rnk2 <= q2prnk1 after DELAY_MXINP2;
                 dataq2rnk2 <= q1prnk1 after DELAY_MXINP2;
                 dataq3rnk2 <= q4rnk1  after DELAY_MXINP2;
                 dataq4rnk2 <= q3rnk1  after DELAY_MXINP2;
                 dataq5rnk2 <= q6rnk1  after DELAY_MXINP2;
                 dataq6rnk2 <= q5rnk1  after DELAY_MXINP2;
        when "100"  =>
                 dataq1rnk2 <= q2prnk1 after DELAY_MXINP2;
                 dataq2rnk2 <= q1prnk1 after DELAY_MXINP2;
                 dataq3rnk2 <= q4rnk1  after DELAY_MXINP2;
                 dataq4rnk2 <= q3rnk1  after DELAY_MXINP2;
                 dataq5rnk2 <= q6rnk1  after DELAY_MXINP2;
                 dataq6rnk2 <= q5rnk1  after DELAY_MXINP2;
        when "101"  =>
                 dataq1rnk2 <= q1prnk1 after DELAY_MXINP2;
                 dataq2rnk2 <= q4rnk1  after DELAY_MXINP2;
                 dataq3rnk2 <= q3rnk1  after DELAY_MXINP2;
                 dataq4rnk2 <= q6rnk1  after DELAY_MXINP2;
                 dataq5rnk2 <= q5rnk1  after DELAY_MXINP2;
                 dataq6rnk2 <= q6prnk1 after DELAY_MXINP2;
        when "010" | "011" | "110" | "111" =>
                 dataq1rnk2 <= q1rnk1  after DELAY_MXINP2;
                 dataq2rnk2 <= q1prnk1 after DELAY_MXINP2;
                 dataq3rnk2 <= q3rnk1  after DELAY_MXINP2;
                 dataq4rnk2 <= q4rnk1  after DELAY_MXINP2;
                 dataq5rnk2 <= q5rnk1  after DELAY_MXINP2;
                 dataq6rnk2 <= q6rnk1  after DELAY_MXINP2;
        when others =>
                 dataq1rnk2 <= q2prnk1 after DELAY_MXINP2;
                 dataq2rnk2 <= q1prnk1 after DELAY_MXINP2;
                 dataq3rnk2 <= q4rnk1  after DELAY_MXINP2;
                 dataq4rnk2 <= q3rnk1  after DELAY_MXINP2;
                 dataq5rnk2 <= q6rnk1  after DELAY_MXINP2;
                 dataq6rnk2 <= q5rnk1  after DELAY_MXINP2;
     end case;
  end process prcs_Q1Q2Q3Q4Q5Q6_rnk2_mux;

---////////////////////////////////////////////////////////////////////
---                       3rd rank of registors
---////////////////////////////////////////////////////////////////////

--###################################################################
--#####  q1rnk3, q2rnk3, q3rnk3, q4rnk3, q5rnk3 and q6rnk3 reg   #####
--###################################################################
  prcs_Q1Q2Q3Q4Q5Q6_rnk3:process(CLKDIV_dly, GSR_dly, SR_dly)
  variable q1rnk3_var         : std_ulogic := TO_X01(INIT_RANK3(0));
  variable q2rnk3_var         : std_ulogic := TO_X01(INIT_RANK3(1));
  variable q3rnk3_var         : std_ulogic := TO_X01(INIT_RANK3(2));
  variable q4rnk3_var         : std_ulogic := TO_X01(INIT_RANK3(3));
  variable q5rnk3_var         : std_ulogic := TO_X01(INIT_RANK3(4));
  variable q6rnk3_var         : std_ulogic := TO_X01(INIT_RANK3(5));
  begin
     if(GSR_dly = '1') then
         q1rnk3_var := TO_X01(INIT_RANK3(0));
         q2rnk3_var := TO_X01(INIT_RANK3(1));
         q3rnk3_var := TO_X01(INIT_RANK3(2));
         q4rnk3_var := TO_X01(INIT_RANK3(3));
         q5rnk3_var := TO_X01(INIT_RANK3(4));
         q6rnk3_var := TO_X01(INIT_RANK3(5));
     elsif(GSR_dly = '0') then
        case AttrSRtype is
           when 0 => 
           --------------- // async SET/RESET
                   if(SR_dly = '1') then
                      q1rnk3_var := '0';
                      q2rnk3_var := '0';
                      q3rnk3_var := '0';
                      q4rnk3_var := '0';
                      q5rnk3_var := '0';
                      q6rnk3_var := '0';
                   elsif(SR_dly = '0') then
                       if(rising_edge(CLKDIV_dly)) then
                           q1rnk3_var := q1rnk2;
                           q2rnk3_var := q2rnk2;
                           q3rnk3_var := q3rnk2;
                           q4rnk3_var := q4rnk2;
                           q5rnk3_var := q5rnk2;
                           q6rnk3_var := q6rnk2;
                        end if;
                   end if;

           when 1 => 
           --------------- // sync SET/RESET
                   if(rising_edge(CLKDIV_dly)) then
                      if(SR_dly = '1') then
                         q1rnk3_var := '0';
                         q2rnk3_var := '0';
                         q3rnk3_var := '0';
                         q4rnk3_var := '0';
                         q5rnk3_var := '0';
                         q6rnk3_var := '0';
                      elsif(SR_dly = '0') then
                         q1rnk3_var := q1rnk2;
                         q2rnk3_var := q2rnk2;
                         q3rnk3_var := q3rnk2;
                         q4rnk3_var := q4rnk2;
                         q5rnk3_var := q5rnk2;
                         q6rnk3_var := q6rnk2;
                      end if;
                   end if;
           when others =>
                   null;
        end case;
     end if;

     q1rnk3  <= q1rnk3_var after DELAY_FFINP;
     q2rnk3  <= q2rnk3_var after DELAY_FFINP;
     q3rnk3  <= q3rnk3_var after DELAY_FFINP;
     q4rnk3  <= q4rnk3_var after DELAY_FFINP;
     q5rnk3  <= q5rnk3_var after DELAY_FFINP;
     q6rnk3  <= q6rnk3_var after DELAY_FFINP;

  end process prcs_Q1Q2Q3Q4Q5Q6_rnk3;

---////////////////////////////////////////////////////////////////////
---                       Outputs
---////////////////////////////////////////////////////////////////////
  prcs_Q1Q2_rnk3_mux:process(q1rnk1, q1prnk1, q1rnk2, q1rnk3,  
                           q2nrnk1, q2prnk1, q2rnk2, q2rnk3)
  begin
     case selrnk3 is
        when "0000" | "0100" | "0X00" =>
                 Q1_zd <= q1prnk1 after DELAY_MXINP1;
                 Q2_zd <= q2prnk1 after DELAY_MXINP1;
        when "0001" | "0101" | "0X01" =>
                 Q1_zd <= q1rnk1  after DELAY_MXINP1;
                 Q2_zd <= q2prnk1 after DELAY_MXINP1;
        when "0010" | "0110" | "0X10" =>
                 Q1_zd <= q1rnk1  after DELAY_MXINP1;
                 Q2_zd <= q2nrnk1 after DELAY_MXINP1;
        when "1000" | "1001" | "1010" | "1011" | "10X0" | "10X1" |
             "100X" | "101X" | "10XX" =>
                 Q1_zd <= q1rnk2 after DELAY_MXINP1;
                 Q2_zd <= q2rnk2 after DELAY_MXINP1;
        when "1100" | "1101" | "1110" | "1111" | "11X0" | "11X1" |
             "110X" | "111X" | "11XX" =>
                 Q1_zd <= q1rnk3 after DELAY_MXINP1;
                 Q2_zd <= q2rnk3 after DELAY_MXINP1;
        when others =>
                 Q1_zd <= q1rnk2 after DELAY_MXINP1;
                 Q2_zd <= q2rnk2 after DELAY_MXINP1;
     end case;
  end process prcs_Q1Q2_rnk3_mux;
--------------------------------------------------------------------
  prcs_Q3Q4Q5Q6_rnk3_mux:process(q3rnk2, q3rnk3, q4rnk2, q4rnk3,  
                                 q5rnk2, q5rnk3, q6rnk2, q6rnk3)
  begin
     case AttrBitslipEnable is
        when '0'  =>
                 Q3_zd <= q3rnk2 after DELAY_MXINP1;
                 Q4_zd <= q4rnk2 after DELAY_MXINP1;
                 Q5_zd <= q5rnk2 after DELAY_MXINP1;
                 Q6_zd <= q6rnk2 after DELAY_MXINP1;
        when '1'  =>
                 Q3_zd <= q3rnk3 after DELAY_MXINP1;
                 Q4_zd <= q4rnk3 after DELAY_MXINP1;
                 Q5_zd <= q5rnk3 after DELAY_MXINP1;
                 Q6_zd <= q6rnk3 after DELAY_MXINP1;
        when others =>
                 Q3_zd <= q3rnk2 after DELAY_MXINP1;
                 Q4_zd <= q4rnk2 after DELAY_MXINP1;
                 Q5_zd <= q5rnk2 after DELAY_MXINP1;
                 Q6_zd <= q6rnk2 after DELAY_MXINP1;
     end case;
  end process prcs_Q3Q4Q5Q6_rnk3_mux;
----------------------------------------------------------------------
-----------    Inverted CLK  -----------------------------------------
----------------------------------------------------------------------

  CLKN_dly <= not CLK_dly;

----------------------------------------------------------------------
-----------    Instant BSCNTRL  --------------------------------------
----------------------------------------------------------------------
  INST_BSCNTRL : BSCNTRL
  generic map (
      SRTYPE => SRTYPE,
      INIT_BITSLIPCNT => INIT_BITSLIPCNT
     )
  port map (
      CLKDIV_INT => clkdiv_int,
      MUXC       => muxc,

      BITSLIP    => BITSLIP_dly,
      C23        => c23,
      C45        => c45,
      C67        => c67,
      CLK        => CLKN_dly,
      CLKDIV     => CLKDIV_dly,
      DATA_RATE  => AttrDataRate,
      R          => SR_dly,
      SEL        => sel
      );

--###################################################################
--#####           Set value of the counter in BSCNTRL           ##### 
--###################################################################
  prcs_bscntrl_cntr:process
  begin
     wait for 10 ps;
     case cntr is
        when "00100" =>
                 c23<='0'; c45<='0'; c67<='0'; sel<="00";
        when "00110" =>
                 c23<='1'; c45<='0'; c67<='0'; sel<="00";
        when "01000" =>
                 c23<='0'; c45<='0'; c67<='0'; sel<="01";
        when "01010" =>
                 c23<='0'; c45<='1'; c67<='0'; sel<="01";
        when "10010" =>
                 c23<='0'; c45<='0'; c67<='0'; sel<="00";
        when "10011" =>
                 c23<='1'; c45<='0'; c67<='0'; sel<="00";
        when "10100" =>
                 c23<='0'; c45<='0'; c67<='0'; sel<="01";
        when "10101" =>
                 c23<='0'; c45<='1'; c67<='0'; sel<="01";
        when "10110" =>
                 c23<='0'; c45<='0'; c67<='0'; sel<="10";
        when "10111" =>
                 c23<='0'; c45<='0'; c67<='1'; sel<="10";
        when "11000" =>
                 c23<='0'; c45<='0'; c67<='0'; sel<="11";
        when others =>
                assert FALSE 
                report "Error : DATA_WIDTH or DATA_RATE has illegal values."
                severity failure;
     end case;
     wait on cntr, c23, c45, c67, sel;

  end process prcs_bscntrl_cntr;
         
----------------------------------------------------------------------
-----------    Instant Clock Enable Circuit  ------------------------- 
----------------------------------------------------------------------
  INST_ICE : ICE_MODULE 
  generic map (
      SRTYPE => SRTYPE,
      INIT_CE => INIT_CE
     )
  port map (
      ICE	=> ice,

      CE1	=> CE1_dly,
      CE2	=> CE2_dly,
      NUM_CE	=> AttrNumCe,
      CLKDIV	=> CLKDIV_dly,
      R		=> SR_dly 
      );
----------------------------------------------------------------------
-----------    Instant IDELAY  --------------------------------------- 
----------------------------------------------------------------------
  INST_IDELAY : X_IDELAY 
  generic map (
      IOBDELAY_VALUE => IOBDELAY_VALUE,
      IOBDELAY_TYPE  => IOBDELAY_TYPE,
      SIM_DELAY_D    => SIM_DELAY_D,
      SIM_TAPDELAY_VALUE => SIM_TAPDELAY_VALUE
     )
  port map (
      O		=> idelay_out,

      C		=> CLKDIV_dly,
      CE	=> DLYCE_dly,
      I		=> D_dly,
      INC	=> DLYINC_dly,
      RST	=> DLYRST_dly
      );

--###################################################################
--#####           IOBDELAY -- Delay input Data                  ##### 
--###################################################################
  prcs_d_delay:process(D_dly, idelay_out)
  begin
     case AttrIobDelay is
        when 0 =>
               O_zd   <= D_dly;
               datain <= D_dly;
        when 1 =>
               O_zd   <= idelay_out; 
               datain <= D_dly;
        when 2 =>
               O_zd   <= D_dly; 
               datain <= idelay_out;
        when 3 =>
               O_zd   <= idelay_out; 
               datain <= idelay_out;
        when others =>
               null;
     end case;
  end process prcs_d_delay;

--####################################################################

--####################################################################
--#####                   TIMING CHECKS & OUTPUT                 #####
--####################################################################
  prcs_output:process
     variable ts_delay_CLK_pos_pos_var : VitalDelayType := (SIM_SETUP_D_CLK * 1.0 ps);
     variable ts_delay_CLK_neg_pos_var : VitalDelayType := (SIM_SETUP_D_CLK * 1.0 ps);
     variable th_delay_CLK_pos_pos_var : VitalDelayType := (SIM_HOLD_D_CLK  * 1.0 ps);
     variable th_delay_CLK_neg_pos_var : VitalDelayType := (SIM_HOLD_D_CLK  * 1.0 ps);

--  Pin Timing Violations (all input pins)
     variable Tviol_D_CLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_D_CLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_CE1_CLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_CE1_CLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_CE1_CLKDIV_posedge : STD_ULOGIC := '0';
     variable  Tmkr_CE1_CLKDIV_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_CE2_CLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_CE2_CLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_CE2_CLKDIV_posedge : STD_ULOGIC := '0';
     variable  Tmkr_CE2_CLKDIV_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_SR_CLKDIV_posedge : STD_ULOGIC := '0';
     variable  Tmkr_SR_CLKDIV_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_SR_CLKDIV_negedge : STD_ULOGIC := '0';
     variable  Tmkr_SR_CLKDIV_negedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_REV_CLKDIV_posedge : STD_ULOGIC := '0';
     variable  Tmkr_REV_CLKDIV_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_REV_CLKDIV_negedge : STD_ULOGIC := '0';
     variable  Tmkr_REV_CLKDIV_negedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_BITSLIP_CLKDIV_posedge : STD_ULOGIC := '0';
     variable  Tmkr_BITSLIP_CLKDIV_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DLYINC_CLKDIV_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DLYINC_CLKDIV_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DLYCE_CLKDIV_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DLYCE_CLKDIV_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DLYRST_CLKDIV_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DLYRST_CLKDIV_posedge : VitalTimingDataType := VitalTimingDataInit;

--  Output Pin glitch declaration
     variable  O_GlitchData : VitalGlitchDataType;
     variable  Q1_GlitchData : VitalGlitchDataType;
     variable  Q2_GlitchData : VitalGlitchDataType;
     variable  Q3_GlitchData : VitalGlitchDataType;
     variable  Q4_GlitchData : VitalGlitchDataType;
     variable  Q5_GlitchData : VitalGlitchDataType;
     variable  Q6_GlitchData : VitalGlitchDataType;
     variable  SHIFTOUT1_GlitchData : VitalGlitchDataType;
     variable  SHIFTOUT2_GlitchData : VitalGlitchDataType;
begin

--  Setup/Hold Check Violations (all input pins)

     if (TimingChecksOn) then
        if((IOBDELAY_TYPE = "VARIABLE") or (IOBDELAY_TYPE = "variable")) then
          VitalSetupHoldCheck
            (
              Violation      => Tviol_D_CLK_posedge,
              TimingData     => Tmkr_D_CLK_posedge,
              TestSignal     => idelay_out,
              TestSignalName => "D",
              TestDelay      => tisd_D_CLK,
              RefSignal      => CLK_dly,
              RefSignalName  => "CLK",
              RefDelay       => ticd_CLK,
              SetupHigh      => ts_delay_CLK_pos_pos_var,
              SetupLow       => ts_delay_CLK_neg_pos_var,
              HoldLow        => th_delay_CLK_pos_pos_var,
              HoldHigh       => th_delay_CLK_neg_pos_var,
              CheckEnabled   => TRUE,
              RefTransition  => 'R',
              HeaderMsg      => InstancePath & "/X_ISERDES",
              Xon            => Xon,
              MsgOn          => MsgOn,
              MsgSeverity    => Error
            );
        else	
          VitalSetupHoldCheck
            (
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
              CheckEnabled   => TRUE,
              RefTransition  => 'R',
              HeaderMsg      => InstancePath & "/X_ISERDES",
              Xon            => Xon,
              MsgOn          => MsgOn,
              MsgSeverity    => Error
            );
        end if;

     VitalSetupHoldCheck
       (
         Violation      => Tviol_CE1_CLK_posedge,
         TimingData     => Tmkr_CE1_CLK_posedge,
         TestSignal     => CE1_dly,
         TestSignalName => "CE1",
         TestDelay      => tisd_CE1_CLK,
         RefSignal      => CLK_dly,
         RefSignalName  => "CLK",
         RefDelay       => ticd_CLK,
         SetupHigh      => tsetup_CE1_CLK_posedge_posedge,
         SetupLow       => tsetup_CE1_CLK_negedge_posedge,
         HoldLow        => thold_CE1_CLK_posedge_posedge,
         HoldHigh       => thold_CE1_CLK_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_ISERDES",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Error
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_CE1_CLKDIV_posedge,
         TimingData     => Tmkr_CE1_CLKDIV_posedge,
         TestSignal     => CE1_dly,
         TestSignalName => "CE1",
         TestDelay      => tisd_CE1_CLKDIV,
         RefSignal      => CLKDIV_dly,
         RefSignalName  => "CLKDIV",
         RefDelay       => ticd_CLKDIV,
         SetupHigh      => tsetup_CE1_CLKDIV_posedge_posedge,
         SetupLow       => tsetup_CE1_CLKDIV_negedge_posedge,
         HoldLow        => thold_CE1_CLKDIV_posedge_posedge,
         HoldHigh       => thold_CE1_CLKDIV_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_ISERDES",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Error
       );
--     VitalSetupHoldCheck
--       (
--         Violation      => Tviol_CE2_CLK_posedge,
--         TimingData     => Tmkr_CE2_CLK_posedge,
--         TestSignal     => CE2_dly,
--         TestSignalName => "CE2",
--         TestDelay      => tisd_CE2_CLK,
--         RefSignal      => CLK_dly,
--         RefSignalName  => "CLK",
--         RefDelay       => ticd_CLK,
--         SetupHigh      => tsetup_CE2_CLK_posedge_posedge,
--         SetupLow       => tsetup_CE2_CLK_negedge_posedge,
--         HoldLow        => thold_CE2_CLK_posedge_posedge,
--         HoldHigh       => thold_CE2_CLK_negedge_posedge,
--         CheckEnabled   => TRUE,
--         RefTransition  => 'R',
--         HeaderMsg      => InstancePath & "/X_ISERDES",
--         Xon            => Xon,
--         MsgOn          => MsgOn,
--         MsgSeverity    => Error
--       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_CE2_CLKDIV_posedge,
         TimingData     => Tmkr_CE2_CLKDIV_posedge,
         TestSignal     => CE2_dly,
         TestSignalName => "CE2",
         TestDelay      => tisd_CE2_CLKDIV,
         RefSignal      => CLKDIV_dly,
         RefSignalName  => "CLKDIV",
         RefDelay       => ticd_CLKDIV,
         SetupHigh      => tsetup_CE2_CLKDIV_posedge_posedge,
         SetupLow       => tsetup_CE2_CLKDIV_negedge_posedge,
         HoldLow        => thold_CE2_CLKDIV_posedge_posedge,
         HoldHigh       => thold_CE2_CLKDIV_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_ISERDES",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Error
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_SR_CLKDIV_posedge,
         TimingData     => Tmkr_SR_CLKDIV_posedge,
         TestSignal     => SR_dly,
         TestSignalName => "SR",
         TestDelay      => tisd_SR_CLKDIV,
         RefSignal      => CLKDIV_dly,
         RefSignalName  => "CLKDIV",
         RefDelay       => ticd_CLKDIV,
         SetupHigh      => tsetup_SR_CLKDIV_posedge_posedge,
         SetupLow       => tsetup_SR_CLKDIV_negedge_posedge,
         HoldLow        => thold_SR_CLKDIV_posedge_posedge,
         HoldHigh       => thold_SR_CLKDIV_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_ISERDES",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Error
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_REV_CLKDIV_posedge,
         TimingData     => Tmkr_REV_CLKDIV_posedge,
         TestSignal     => REV_dly,
         TestSignalName => "REV",
         TestDelay      => tisd_REV_CLKDIV,
         RefSignal      => CLKDIV_dly,
         RefSignalName  => "CLKDIV",
         RefDelay       => ticd_CLKDIV,
         SetupHigh      => tsetup_REV_CLKDIV_posedge_posedge,
         SetupLow       => tsetup_REV_CLKDIV_negedge_posedge,
         HoldLow        => thold_REV_CLKDIV_posedge_posedge,
         HoldHigh       => thold_REV_CLKDIV_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_ISERDES",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Error
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_REV_CLKDIV_negedge,
         TimingData     => Tmkr_REV_CLKDIV_negedge,
         TestSignal     => REV_dly,
         TestSignalName => "REV",
         TestDelay      => tisd_REV_CLKDIV,
         RefSignal      => CLKDIV_dly,
         RefSignalName  => "CLKDIV",
         RefDelay       => ticd_CLKDIV,
         SetupHigh      => tsetup_REV_CLKDIV_posedge_negedge,
         SetupLow       => tsetup_REV_CLKDIV_negedge_negedge,
         HoldLow        => thold_REV_CLKDIV_posedge_negedge,
         HoldHigh       => thold_REV_CLKDIV_negedge_negedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'F',
         HeaderMsg      => InstancePath & "/X_ISERDES",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Error
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_BITSLIP_CLKDIV_posedge,
         TimingData     => Tmkr_BITSLIP_CLKDIV_posedge,
         TestSignal     => BITSLIP_dly,
         TestSignalName => "BITSLIP",
         TestDelay      => tisd_BITSLIP_CLKDIV,
         RefSignal      => CLKDIV_dly,
         RefSignalName  => "CLKDIV",
         RefDelay       => ticd_CLKDIV,
         SetupHigh      => tsetup_BITSLIP_CLKDIV_posedge_posedge,
         SetupLow       => tsetup_BITSLIP_CLKDIV_negedge_posedge,
         HoldLow        => thold_BITSLIP_CLKDIV_posedge_posedge,
         HoldHigh       => thold_BITSLIP_CLKDIV_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_ISERDES",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Error
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DLYINC_CLKDIV_posedge,
         TimingData     => Tmkr_DLYINC_CLKDIV_posedge,
         TestSignal     => DLYINC_dly,
         TestSignalName => "DLYINC",
         TestDelay      => tisd_DLYINC_CLKDIV,
         RefSignal      => CLKDIV_dly,
         RefSignalName  => "CLKDIV",
         RefDelay       => ticd_CLKDIV,
         SetupHigh      => tsetup_DLYINC_CLKDIV_posedge_posedge,
         SetupLow       => tsetup_DLYINC_CLKDIV_negedge_posedge,
         HoldLow        => thold_DLYINC_CLKDIV_posedge_posedge,
         HoldHigh       => thold_DLYINC_CLKDIV_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_ISERDES",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Error
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DLYCE_CLKDIV_posedge,
         TimingData     => Tmkr_DLYCE_CLKDIV_posedge,
         TestSignal     => DLYCE_dly,
         TestSignalName => "DLYCE",
         TestDelay      => tisd_DLYCE_CLKDIV,
         RefSignal      => CLKDIV_dly,
         RefSignalName  => "CLKDIV",
         RefDelay       => ticd_CLKDIV,
         SetupHigh      => tsetup_DLYCE_CLKDIV_posedge_posedge,
         SetupLow       => tsetup_DLYCE_CLKDIV_negedge_posedge,
         HoldLow        => thold_DLYCE_CLKDIV_posedge_posedge,
         HoldHigh       => thold_DLYCE_CLKDIV_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_ISERDES",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Error
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DLYRST_CLKDIV_posedge,
         TimingData     => Tmkr_DLYRST_CLKDIV_posedge,
         TestSignal     => DLYRST_dly,
         TestSignalName => "DLYRST",
         TestDelay      => tisd_DLYRST_CLKDIV,
         RefSignal      => CLKDIV_dly,
         RefSignalName  => "CLKDIV",
         RefDelay       => ticd_CLKDIV,
         SetupHigh      => tsetup_DLYRST_CLKDIV_posedge_posedge,
         SetupLow       => tsetup_DLYRST_CLKDIV_negedge_posedge,
         HoldLow        => thold_DLYRST_CLKDIV_posedge_posedge,
         HoldHigh       => thold_DLYRST_CLKDIV_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_ISERDES",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Error
       );
     end if;
-- End of (TimingChecksOn)

--  Output-to-Clock path delay
     if(O_zd'event) then
        VitalPathDelay01
          (
            OutSignal     => O,
            GlitchData    => O_GlitchData,
            OutSignalName => "O",
            OutTemp       => O_zd,
            Paths         => (0 => (D_dly'last_event, tpd_D_O,TRUE)),
            Mode          => VitalTransport,
            Xon           => Xon,
            MsgOn         => MsgOn,
            MsgSeverity   => WARNING
          );
     end if;
     if(Q1_zd'event) then
        VitalPathDelay01
          (
            OutSignal     => Q1,
            GlitchData    => Q1_GlitchData,
            OutSignalName => "Q1",
            OutTemp       => Q1_zd,
            Paths         => (0 => (CLKDIV_dly'last_event, tpd_CLKDIV_Q1,TRUE)),
            Mode          => VitalTransport,
            Xon           => Xon,
            MsgOn         => MsgOn,
            MsgSeverity   => WARNING
          );
     end if;
     if(Q2_zd'event) then
        VitalPathDelay01
          (
            OutSignal     => Q2,
            GlitchData    => Q2_GlitchData,
            OutSignalName => "Q2",
            OutTemp       => Q2_zd,
            Paths         => (0 => (CLKDIV_dly'last_event, tpd_CLKDIV_Q2,TRUE)),
            Mode          => VitalTransport,
            Xon           => Xon,
            MsgOn         => MsgOn,
            MsgSeverity   => WARNING
          );
     end if;
     if(Q3_zd'event) then
        VitalPathDelay01
          (
            OutSignal     => Q3,
            GlitchData    => Q3_GlitchData,
            OutSignalName => "Q3",
            OutTemp       => Q3_zd,
            Paths         => (0 => (CLKDIV_dly'last_event, tpd_CLKDIV_Q3,TRUE)),
            Mode          => VitalTransport,
            Xon           => Xon,
            MsgOn         => MsgOn,
            MsgSeverity   => WARNING
          );
     end if;
     if(Q4_zd'event) then
        VitalPathDelay01
          (
            OutSignal     => Q4,
            GlitchData    => Q4_GlitchData,
            OutSignalName => "Q4",
            OutTemp       => Q4_zd,
            Paths         => (0 => (CLKDIV_dly'last_event, tpd_CLKDIV_Q4,TRUE)),
            Mode          => VitalTransport,
            Xon           => Xon,
            MsgOn         => MsgOn,
            MsgSeverity   => WARNING
          );
     end if;
     if(Q5_zd'event) then
        VitalPathDelay01
          (
            OutSignal     => Q5,
            GlitchData    => Q5_GlitchData,
            OutSignalName => "Q5",
            OutTemp       => Q5_zd,
            Paths         => (0 => (CLKDIV_dly'last_event, tpd_CLKDIV_Q5,TRUE)),
            Mode          => VitalTransport,
            Xon           => Xon,
            MsgOn         => MsgOn,
            MsgSeverity   => WARNING
          );
     end if;
     if(Q6_zd'event) then
        VitalPathDelay01
          (
            OutSignal     => Q6,
            GlitchData    => Q6_GlitchData,
            OutSignalName => "Q6",
            OutTemp       => Q6_zd,
            Paths         => (0 => (CLKDIV_dly'last_event, tpd_CLKDIV_Q6,TRUE)),
            Mode          => VitalTransport,
            Xon           => Xon,
            MsgOn         => MsgOn,
            MsgSeverity   => WARNING
          );
     end if;

     if(SHIFTOUT1_zd'event) then
        SHIFTOUT1 <= SHIFTOUT1_zd;
     end if;

     if(SHIFTOUT2_zd'event) then
        SHIFTOUT2 <= SHIFTOUT2_zd;
     end if;

--  Wait signal (input/output pins)
   wait on
     D_dly,
     CE1_dly,
     CE2_dly,
     CLK_dly,
     SR_dly,
     REV_dly,
     CLKDIV_dly,
     OCLK_dly,
     BITSLIP_dly,
     DLYINC_dly,
     DLYCE_dly,
     DLYRST_dly,
     SHIFTIN1_dly,
     SHIFTIN2_dly,
     O_zd,
     Q1_zd,
     Q2_zd,
     Q3_zd,
     Q4_zd,
     Q5_zd,
     Q6_zd,
     SHIFTOUT1_zd,
     SHIFTOUT2_zd, 
     idelay_out;
  end process prcs_output;


end X_ISERDES_V;

-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  Dual Data Rate Output D Flip-Flop
-- /___/   /\     Filename : X_ODDR.vhd
-- \   \  /  \    Timestamp : Fri Mar 26 08:18:20 PST 2004
--  \___\/\___\
--
-- Revision:
--    03/23/04 - Initial version.
--    05/30/06 - CR 232324 -- Added  timing checks for S/R wrt negedge CLK
-- End Revision

----- CELL X_ODDR -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;


library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.Vcomponents.all;
use simprim.VPACKAGE.all;

entity X_ODDR is

  generic(

      TimingChecksOn : boolean := true;
      InstancePath   : string  := "*";
      Xon            : boolean := true;
      MsgOn          : boolean := true;
      LOC            : string  := "UNPLACED";

--  VITAL input Pin path delay variables
      tipd_C    : VitalDelayType01 := (0 ps, 0 ps);
      tipd_CE   : VitalDelayType01 := (0 ps, 0 ps);
      tipd_D1   : VitalDelayType01 := (0 ps, 0 ps);
      tipd_D2   : VitalDelayType01 := (0 ps, 0 ps);
      tipd_GSR  : VitalDelayType01 := (0 ps, 0 ps);
      tipd_R    : VitalDelayType01 := (0 ps, 0 ps);
      tipd_S    : VitalDelayType01 := (0 ps, 0 ps);

--  VITAL clk-to-output path delay variables
      tpd_C_Q   : VitalDelayType01 := (100 ps, 100 ps);

--  VITAL async rest-to-output path delay variables
      tpd_R_Q   : VitalDelayType01 := (0 ps, 0 ps);

--  VITAL async set-to-output path delay variables
      tpd_S_Q   : VitalDelayType01 := (0 ps, 0 ps);

--  VITAL GSR-to-output path delay variable
      tpd_GSR_Q : VitalDelayType01 := (0 ps, 0 ps);


--  VITAL ticd & tisd variables
      ticd_C     : VitalDelayType   := 0.0 ps;
      tisd_D1_C  : VitalDelayType   := 0.0 ps;
      tisd_D2_C  : VitalDelayType   := 0.0 ps;
      tisd_CE_C  : VitalDelayType   := 0.0 ps;
      tisd_GSR_C : VitalDelayType   := 0.0 ps;
      tisd_R_C   : VitalDelayType   := 0.0 ps;
      tisd_S_C   : VitalDelayType   := 0.0 ps;

--  VITAL Setup/Hold delay variables
      tsetup_CE_C_posedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_CE_C_negedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_CE_C_posedge_negedge : VitalDelayType := 0.0 ps;
      tsetup_CE_C_negedge_negedge : VitalDelayType := 0.0 ps;
      thold_CE_C_posedge_posedge  : VitalDelayType := 0.0 ps;
      thold_CE_C_negedge_posedge  : VitalDelayType := 0.0 ps;
      thold_CE_C_posedge_negedge : VitalDelayType := 0.0 ps;
      thold_CE_C_negedge_negedge : VitalDelayType := 0.0 ps;

      tsetup_D1_C_posedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_D1_C_negedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_D1_C_posedge_negedge : VitalDelayType := 0.0 ps;
      tsetup_D1_C_negedge_negedge : VitalDelayType := 0.0 ps;
      thold_D1_C_posedge_posedge  : VitalDelayType := 0.0 ps;
      thold_D1_C_negedge_posedge  : VitalDelayType := 0.0 ps;
      thold_D1_C_posedge_negedge : VitalDelayType := 0.0 ps;
      thold_D1_C_negedge_negedge : VitalDelayType := 0.0 ps;

      tsetup_D2_C_posedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_D2_C_negedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_D2_C_posedge_negedge : VitalDelayType := 0.0 ps;
      tsetup_D2_C_negedge_negedge : VitalDelayType := 0.0 ps;
      thold_D2_C_posedge_posedge  : VitalDelayType := 0.0 ps;
      thold_D2_C_negedge_posedge  : VitalDelayType := 0.0 ps;
      thold_D2_C_posedge_negedge : VitalDelayType := 0.0 ps;
      thold_D2_C_negedge_negedge : VitalDelayType := 0.0 ps;

      tsetup_R_C_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_R_C_negedge_posedge : VitalDelayType := 0 ps;
      tsetup_R_C_negedge_negedge : VitalDelayType := 0 ps;
      tsetup_R_C_posedge_negedge : VitalDelayType := 0 ps;
      thold_R_C_posedge_posedge  : VitalDelayType := 0 ps;
      thold_R_C_negedge_posedge  : VitalDelayType := 0 ps;
      thold_R_C_negedge_negedge  : VitalDelayType := 0 ps;
      thold_R_C_posedge_negedge  : VitalDelayType := 0 ps;

      tsetup_S_C_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_S_C_negedge_posedge : VitalDelayType := 0 ps;
      tsetup_S_C_negedge_negedge : VitalDelayType := 0 ps;
      tsetup_S_C_posedge_negedge : VitalDelayType := 0 ps;
      thold_S_C_posedge_posedge  : VitalDelayType := 0 ps;
      thold_S_C_negedge_posedge  : VitalDelayType := 0 ps;
      thold_S_C_negedge_negedge  : VitalDelayType := 0 ps;
      thold_S_C_posedge_negedge   : VitalDelayType := 0 ps;

-- VITAL pulse width variables
      tpw_C_negedge              : VitalDelayType := 0 ps;
      tpw_C_posedge              : VitalDelayType := 0 ps;

      tpw_GSR_negedge            : VitalDelayType := 0 ps;
      tpw_GSR_posedge            : VitalDelayType := 0 ps;

      tpw_R_negedge              : VitalDelayType := 0 ps;
      tpw_R_posedge              : VitalDelayType := 0 ps;

      tpw_S_negedge              : VitalDelayType := 0 ps;
      tpw_S_posedge              : VitalDelayType := 0 ps;

-- VITAL period variables
      tperiod_C_posedge          : VitalDelayType := 0 ps;

-- VITAL recovery time variables
      trecovery_GSR_C_negedge_posedge : VitalDelayType := 0 ps;
      trecovery_R_C_negedge_posedge   : VitalDelayType := 0 ps;
      trecovery_R_C_negedge_negedge   : VitalDelayType := 0 ps;
      trecovery_S_C_negedge_posedge   : VitalDelayType := 0 ps;
      trecovery_S_C_negedge_negedge   : VitalDelayType := 0 ps;

-- VITAL removal time variables
      tremoval_GSR_C_negedge_posedge  : VitalDelayType := 0 ps;
      tremoval_R_C_negedge_posedge    : VitalDelayType := 0 ps;
      tremoval_R_C_negedge_negedge    : VitalDelayType := 0 ps;
      tremoval_S_C_negedge_posedge    : VitalDelayType := 0 ps;
      tremoval_S_C_negedge_negedge    : VitalDelayType := 0 ps;

      DDR_CLK_EDGE : string := "OPPOSITE_EDGE";
      INIT         : bit    := '0';
      SRTYPE       : string := "SYNC"
      );

  port(
      Q           : out std_ulogic;

      C           : in  std_ulogic;
      CE          : in  std_ulogic;
      D1          : in  std_ulogic;
      D2          : in  std_ulogic;
      R           : in  std_ulogic;
      S           : in  std_ulogic
    );

  attribute VITAL_LEVEL0 of
    X_ODDR : entity is true;

end X_ODDR;

architecture X_ODDR_V OF X_ODDR is

  attribute VITAL_LEVEL0 of
    X_ODDR_V : architecture is true;


  constant SYNC_PATH_DELAY : time := 100 ps;

  signal C_ipd	        : std_ulogic := 'X';
  signal CE_ipd	        : std_ulogic := 'X';
  signal D1_ipd	        : std_ulogic := 'X';
  signal D2_ipd	        : std_ulogic := 'X';
  signal GSR_ipd	: std_ulogic := 'X';
  signal R_ipd		: std_ulogic := 'X';
  signal S_ipd		: std_ulogic := 'X';

  signal C_dly	        : std_ulogic := 'X';
  signal CE_dly	        : std_ulogic := 'X';
  signal D1_dly	        : std_ulogic := 'X';
  signal D2_dly	        : std_ulogic := 'X';
  signal GSR_dly	: std_ulogic := 'X';
  signal R_dly		: std_ulogic := 'X';
  signal S_dly		: std_ulogic := 'X';

  signal Q_zd		: std_ulogic := 'X';

  signal Q_viol		: std_ulogic := 'X';

  signal ddr_clk_edge_type	: integer := -999;
  signal sr_type		: integer := -999;

begin

  ---------------------
  --  INPUT PATH DELAYs
  --------------------

  WireDelay : block
  begin
    VitalWireDelay (C_ipd,   C,   tipd_C);
    VitalWireDelay (CE_ipd,  CE,  tipd_CE);
    VitalWireDelay (D1_ipd,  D1,  tipd_D1);
    VitalWireDelay (D2_ipd,  D2,  tipd_D2);
    VitalWireDelay (GSR_ipd, GSR, tipd_GSR);
    VitalWireDelay (R_ipd,   R,   tipd_R);
    VitalWireDelay (S_ipd,   S,   tipd_S);
  end block;

  SignalDelay : block
  begin
    VitalSignalDelay (C_dly,   C_ipd,   ticd_C);
    VitalSignalDelay (CE_dly,  CE_ipd,  ticd_C);
    VitalSignalDelay (D1_dly,  D1_ipd,  ticd_C);
    VitalSignalDelay (D2_dly,  D2_ipd,  ticd_C);
    VitalSignalDelay (GSR_dly, GSR_ipd, tisd_GSR_C);
    VitalSignalDelay (R_dly,   R_ipd,   tisd_R_C);
    VitalSignalDelay (S_dly,   S_ipd,   tisd_S_C);
  end block;

  --------------------
  --  BEHAVIOR SECTION
  --------------------


--####################################################################
--#####                     Initialize                           #####
--####################################################################
  prcs_init:process

  begin
      if((DDR_CLK_EDGE = "OPPOSITE_EDGE") or (DDR_CLK_EDGE = "opposite_edge")) then
         ddr_clk_edge_type <= 1;
      elsif((DDR_CLK_EDGE = "SAME_EDGE") or (DDR_CLK_EDGE = "same_edge")) then
         ddr_clk_edge_type <= 2;
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Warning ",
             GenericName => " DDR_CLK_EDGE ",
             EntityName => "/X_ODDR",
             GenericValue => DDR_CLK_EDGE,
             Unit => "",
             ExpectedValueMsg => " The Legal values for this attribute are ",
             ExpectedGenericValue => " OPPOSITE_EDGE or SAME_EDGE.",
             TailMsg => "",
             MsgSeverity => ERROR 
         );
      end if;

      if((SRTYPE = "ASYNC") or (SRTYPE = "async")) then
         sr_type <= 1;
      elsif((SRTYPE = "SYNC") or (SRTYPE = "sync")) then
         sr_type <= 2;
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Warning ",
             GenericName => " SRTYPE ",
             EntityName => "/X_ODDR",
             GenericValue => SRTYPE,
             Unit => "",
             ExpectedValueMsg => " The Legal values for this attribute are ",
             ExpectedGenericValue => " ASYNC or SYNC. ",
             TailMsg => "",
             MsgSeverity => ERROR
         );
      end if;

     wait;
  end process prcs_init;
--####################################################################
--#####                       q1_q2_q3 reg                       #####
--####################################################################
  prcs_q1q2q3_reg:process(C_dly, GSR_dly, R_dly, S_dly)
  variable Q1_var         : std_ulogic := TO_X01(INIT);
  variable Q2_posedge_var : std_ulogic := TO_X01(INIT);
  begin
     if(GSR_dly = '1') then
         Q1_var         := TO_X01(INIT);
         Q2_posedge_var := TO_X01(INIT);
     elsif(GSR_dly = '0') then
        case sr_type is
           when 1 => 
                   if(R_dly = '1') then
                      Q1_var := '0';
                      Q2_posedge_var := '0';
                   elsif((R_dly = '0') and (S_dly = '1')) then
                      Q1_var := '1';
                      Q2_posedge_var := '1';
                   elsif((R_dly = '0') and (S_dly = '0')) then
                      if(CE_dly = '1') then
                         if(rising_edge(C_dly)) then
                            Q1_var         := D1_dly;
                            Q2_posedge_var := D2_dly;
                         end if;
                         if(falling_edge(C_dly)) then
                             case ddr_clk_edge_type is
                                when 1 => 
                                       Q1_var :=  D2_dly;
                                when 2 => 
                                       Q1_var :=  Q2_posedge_var;
                                when others =>
                                          null;
                              end case;
                         end if;
                      end if;
                   end if;

           when 2 => 
                   if(rising_edge(C_dly)) then
                      if(R_dly = '1') then
                         Q1_var := '0';
                         Q2_posedge_var := '0';
                      elsif((R_dly = '0') and (S_dly = '1')) then
                         Q1_var := '1';
                         Q2_posedge_var := '1';
                      elsif((R_dly = '0') and (S_dly = '0')) then
                         if(CE_dly = '1') then
                            Q1_var         := D1_dly;
                            Q2_posedge_var := D2_dly;
                         end if;
                      end if;
                   end if;
                        
                   if(falling_edge(C_dly)) then
                      if(R_dly = '1') then
                         Q1_var := '0';
                      elsif((R_dly = '0') and (S_dly = '1')) then
                         Q1_var := '1';
                      elsif((R_dly = '0') and (S_dly = '0')) then
                         if(CE_dly = '1') then
                             case ddr_clk_edge_type is
                                when 1 => 
                                       Q1_var :=  D2_dly;
                                when 2 => 
                                       Q1_var :=  Q2_posedge_var;
                                when others =>
                                          null;
                              end case;
                         end if;
                      end if;
                   end if;
 
           when others =>
                   null; 
        end case;
     end if;

     Q_zd <= Q1_var;

  end process prcs_q1q2q3_reg;
--####################################################################

--####################################################################
--#####                   TIMING CHECKS & OUTPUT                 #####
--####################################################################
  prcs_tmngchk:process
  variable Tmkr_CE_C_posedge   : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_CE_C_posedge  : std_ulogic          := '0';
  variable Tmkr_D1_C_posedge   : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_D1_C_posedge  : std_ulogic          := '0';
  variable Tmkr_D2_C_posedge   : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_D2_C_posedge  : std_ulogic          := '0';
--
  variable Tmkr_R_C_posedge   : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_R_C_posedge  : std_ulogic          := '0';
  variable Tmkr_R_C_negedge   : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_R_C_negedge  : std_ulogic          := '0';

  variable Tmkr_S_C_posedge   : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_S_C_posedge  : std_ulogic          := '0';
  variable Tmkr_S_C_negedge   : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_S_C_negedge  : std_ulogic          := '0';


  variable PInfo_C : VitalPeriodDataType := VitalPeriodDataInit;
  variable Pviol_C : std_ulogic := '0';

  variable Violation           : std_ulogic          := '0';
  begin
    if (TimingChecksOn) then
      VitalSetupHoldCheck (
        Violation            => Tviol_CE_C_posedge,
        TimingData           => Tmkr_CE_C_posedge,
        TestSignal           => CE_dly,
        TestSignalName       => "CE",
        TestDelay            => tisd_CE_C,
        RefSignal            => C_dly,
        RefSignalName        => "C",
        RefDelay             => ticd_C,
        SetupHigh            => tsetup_CE_C_posedge_posedge,
        SetupLow             => tsetup_CE_C_negedge_posedge,
        HoldLow              => thold_CE_C_posedge_posedge,
        HoldHigh             => thold_CE_C_negedge_posedge,
        CheckEnabled         => TO_X01(((not R_dly)) and ((not S_dly))) /= '0',
        RefTransition        => 'R',
        HeaderMsg            => "/X_ODDR",
        Xon                  => Xon,
        MsgOn                => true,
        MsgSeverity          => Error
      );
      VitalSetupHoldCheck (
        Violation            => Tviol_D1_C_posedge,
        TimingData           => Tmkr_D1_C_posedge,
        TestSignal           => D1_dly,
        TestSignalName       => "D1",
        TestDelay            => tisd_D1_C,
        RefSignal            => C_dly,
        RefSignalName        => "C",
        RefDelay             => ticd_C,
        SetupHigh            => tsetup_D1_C_posedge_posedge,
        SetupLow             => tsetup_D1_C_negedge_posedge,
        HoldLow              => thold_D1_C_posedge_posedge,
        HoldHigh             => thold_D1_C_negedge_posedge,
        CheckEnabled         => TO_X01(((not R_dly)) and (C_dly)
                                       and ((not S_dly))) /= '0',
        RefTransition        => 'R',
        HeaderMsg            => "/X_ODDR",
        Xon                  => Xon,
        MsgOn                => true,
        MsgSeverity          => Error
      );
      VitalSetupHoldCheck (
        Violation            => Tviol_D2_C_posedge,
        TimingData           => Tmkr_D2_C_posedge,
        TestSignal           => D2_dly,
        TestSignalName       => "D2",
        TestDelay            => tisd_D2_C,
        RefSignal            => C_dly,
        RefSignalName        => "C",
        RefDelay             => ticd_C,
        SetupHigh            => tsetup_D2_C_posedge_posedge,
        SetupLow             => tsetup_D2_C_negedge_posedge,
        HoldLow              => thold_D2_C_posedge_posedge,
        HoldHigh             => thold_D2_C_negedge_posedge,
        CheckEnabled         => TO_X01(((not R_dly)) and (C_dly)
                                       and ((not S_dly))) /= '0',
        RefTransition        => 'R',
        HeaderMsg            => "/X_ODDR",
        Xon                  => Xon,
        MsgOn                => true,
        MsgSeverity          => Error
      );
      VitalPeriodPulseCheck (
        Violation            => Pviol_C,
        PeriodData           => PInfo_C,
        TestSignal           => C_dly,
        TestSignalName       => "C",
        TestDelay            => 0 ps,
        Period               => tperiod_C_posedge,
        PulseWidthHigh       => tpw_C_posedge,
        PulseWidthLow        => tpw_C_negedge,
        CheckEnabled         => TO_X01(CE_dly) /= '0',
        HeaderMsg            => "/X_ODDR",
        Xon                  => Xon,
        MsgOn                => MsgOn,
        MsgSeverity          => Error
      );

-- 
        if (SRTYPE = "ASYNC" ) then
           VitalRecoveryRemovalCheck (
              Violation            => Tviol_R_C_posedge,
              TimingData           => Tmkr_R_C_posedge,
              TestSignal           => R_dly,
              TestSignalName       => "R",
              TestDelay            => tisd_R_C,
              RefSignal            => C_dly,
              RefSignalName        => "C",
              RefDelay             => ticd_C,
              Recovery             => trecovery_R_C_negedge_posedge,
              Removal              => tremoval_R_C_negedge_posedge,
              ActiveLow            => false,
              CheckEnabled         => TO_X01(CE_dly) /= '0',
              RefTransition        => 'R',
              HeaderMsg            => "/X_ODDR",
              Xon                  => Xon,
              MsgOn                => true,
              MsgSeverity          => warning);
           if (DDR_CLK_EDGE = "OPPOSITE_EDGE" ) then
              VitalRecoveryRemovalCheck (
                 Violation            => Tviol_R_C_negedge,
                 TimingData           => Tmkr_R_C_negedge,
                 TestSignal           => R_dly,
                 TestSignalName       => "R",
                 TestDelay            => tisd_R_C,
                 RefSignal            => C_dly,
                 RefSignalName        => "C",
                 RefDelay             => ticd_C,
                 Recovery             => trecovery_R_C_negedge_negedge,
                 Removal              => tremoval_R_C_negedge_negedge,
                 ActiveLow            => false,
                 CheckEnabled         => TO_X01(CE_dly) /= '0',
                 RefTransition        => 'F',
                 HeaderMsg            => "/X_ODDR",
                 Xon                  => Xon,
                 MsgOn                => true,
                 MsgSeverity          => warning);
           end if;
           VitalRecoveryRemovalCheck (
              Violation            => Tviol_S_C_posedge,
              TimingData           => Tmkr_S_C_posedge,
              TestSignal           => S_dly,
              TestSignalName       => "S",
              TestDelay            => tisd_S_C,
              RefSignal            => C_dly,
              RefSignalName        => "C",
              RefDelay             => ticd_C,
              Recovery             => trecovery_S_C_negedge_posedge,
              Removal              => thold_S_C_negedge_posedge,
              ActiveLow            => false,
              CheckEnabled         => TO_X01((not R_dly) and CE_dly) /= '0',
              RefTransition        => 'R',
              HeaderMsg            => "/X_ODDR",
              Xon                  => Xon,
              MsgOn                => true,
              MsgSeverity          => warning);
           if (DDR_CLK_EDGE = "OPPOSITE_EDGE" ) then
              VitalRecoveryRemovalCheck (
                 Violation            => Tviol_S_C_negedge,
                 TimingData           => Tmkr_S_C_negedge,
                 TestSignal           => S_dly,
                 TestSignalName       => "S",
                 TestDelay            => tisd_S_C,
                 RefSignal            => C_dly,
                 RefSignalName        => "C",
                 RefDelay             => ticd_C,
                 Recovery             => trecovery_S_C_negedge_negedge,
                 Removal              => thold_S_C_negedge_negedge,
                 ActiveLow            => false,
                 CheckEnabled         => TO_X01((not R_dly) and CE_dly) /= '0',
                 RefTransition        => 'F',
                 HeaderMsg            => "/X_ODDR",
                 Xon                  => Xon,
                 MsgOn                => true,
                 MsgSeverity          => warning);
           end if;
        elsif (SRTYPE = "SYNC" ) then
           VitalSetupHoldCheck (
              Violation      => Tviol_R_C_posedge,
              TimingData     => Tmkr_R_C_posedge,
              TestSignal     => R_dly,
              TestSignalName => "R",
              TestDelay      => tisd_R_C,
              RefSignal      => C_dly,
              RefSignalName  => "C",
              RefDelay       => ticd_C,
              SetupHigh      => tsetup_R_C_posedge_posedge,
              SetupLow       => tsetup_R_C_negedge_posedge,
              HoldLow        => thold_R_C_posedge_posedge,
              HoldHigh       => thold_R_C_negedge_posedge,
              CheckEnabled   => TO_X01(((not S_dly)) and ((not R_dly))) /= '0',
              RefTransition  => 'R',
              HeaderMsg      => "/X_ODDR",
              Xon            => Xon,
              MsgOn          => true,
              MsgSeverity    => warning);
           VitalSetupHoldCheck (
              Violation      => Tviol_R_C_negedge,
              TimingData     => Tmkr_R_C_negedge,
              TestSignal     => R_dly,
              TestSignalName => "R",
              TestDelay      => tisd_R_C,
              RefSignal      => C_dly,
              RefSignalName  => "C",
              RefDelay       => ticd_C,
              SetupHigh      => tsetup_R_C_posedge_negedge,
              SetupLow       => tsetup_R_C_negedge_negedge,
              HoldLow        => thold_R_C_posedge_negedge,
              HoldHigh       => thold_R_C_negedge_negedge,
              CheckEnabled   => TO_X01(((not S_dly)) and ((not R_dly))) /= '0',
              RefTransition  => 'F',
              HeaderMsg      => "/X_ODDR",
              Xon            => Xon,
              MsgOn          => true,
              MsgSeverity    => warning);
           VitalSetupHoldCheck (
              Violation      => Tviol_S_C_posedge,
              TimingData     => Tmkr_S_C_posedge,
              TestSignal     => S_dly,
              TestSignalName => "S",
              TestDelay      => tisd_S_C,
              RefSignal      => C_dly,
              RefSignalName  => "C",
              RefDelay       => ticd_C,
              SetupHigh      => tsetup_S_C_posedge_posedge,
              SetupLow       => tsetup_S_C_negedge_posedge,
              HoldLow        => thold_S_C_posedge_posedge,
              HoldHigh       => thold_S_C_negedge_posedge,
              CheckEnabled   => TO_X01(not R_dly) /= '0',
              RefTransition  => 'R',
              HeaderMsg      => "/X_ODDR",
              Xon            => Xon,
              MsgOn          => true,
              MsgSeverity    => warning);
           VitalSetupHoldCheck (
              Violation      => Tviol_S_C_negedge,
              TimingData     => Tmkr_S_C_negedge,
              TestSignal     => S_dly,
              TestSignalName => "S",
              TestDelay      => tisd_S_C,
              RefSignal      => C_dly,
              RefSignalName  => "C",
              RefDelay       => ticd_C,
              SetupHigh      => tsetup_S_C_posedge_negedge,
              SetupLow       => tsetup_S_C_negedge_negedge,
              HoldLow        => thold_S_C_posedge_negedge,
              HoldHigh       => thold_S_C_negedge_negedge,
              CheckEnabled   => TO_X01(not R_dly) /= '0',
              RefTransition  => 'F',
              HeaderMsg      => "/X_ODDR",
              Xon            => Xon,
              MsgOn          => true,
              MsgSeverity    => warning);
          
        end if;
    end if;

    Violation := Tviol_CE_C_posedge or 
                 Tviol_D1_C_posedge or
                 Tviol_D2_C_posedge or
                 Pviol_C;

    Q_viol     <= Violation xor Q_zd;

    wait on C_dly, CE_dly, D1_dly, D2_dly, GSR_dly, R_dly, S_dly, Q_zd;
 
  end process prcs_tmngchk;
--####################################################################
--#####                           OUTPUT                         #####
--####################################################################
  prcs_output:process
  variable  Q_GlitchData : VitalGlitchDataType;

  begin
     VitalPathDelay01
       (
         OutSignal     => Q,
         GlitchData    => Q_GlitchData,
         OutSignalName => "Q",
         OutTemp       => Q_viol,
         Paths         => (0 => (C_ipd'last_event, tpd_C_Q,TRUE),
                           1 => (S_dly'last_event, tpd_S_Q, (R_dly /= '1')),
                           2 => (R_dly'last_event, tpd_R_Q, true)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => Error
       );

    wait on Q_viol;
  end process prcs_output;


end X_ODDR_V;

-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  Source Synchronous Output Serializer
-- /___/   /\     Filename : X_OSERDES.vhd
-- \   \  /  \    Timestamp : Fri Mar 26 08:18:21 PST 2004
--  \___\/\___\
--
-- Revision:
--    03/23/04 - Initial version.
--    01/23/06 - 223369 fixed Vital delays from CLK to OQ
--    05/29/06 - CR 232324 -- Added timing checks for REV/SR wrt negedge CLKDIV
--    08/08/06 - CR 225414 -- Added 100 ps delay to data inputs to resolve
--               race condition when data/clk change at the same time.
--    08/21/06 - CR 210819 -- Updated Timing
--    01/08/08 - CR 458156 -- enabled TRISTATE_WIDTH to be 1 in DDR mode. 
-- End Revision

----- CELL X_OSERDES -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;


library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.VPACKAGE.all;

entity X_PLG is

  generic(

         SRTYPE			: string;

         INIT_LOADCNT		: bit_vector(3 downto 0);

         TimingChecksOn		: boolean	:= true;
         InstancePath		: string	:= "*";
         Xon			: boolean	:= true;
         MsgOn			: boolean	:= false;

--  VITAL input Pin path delay variables

      tipd_CLK		: VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_CLKDIV	: VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_C23		: VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_C45		: VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_C67		: VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_GSR		: VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_RST		: VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_SEL		: VitalDelayArrayType01(1 downto 0)  := (others => (0.0 ns, 0.0 ns));

--  VITAL clk-to-output path delay variables

--  VITAL async rest-to-output path delay variables

--  VITAL async set-to-output path delay variables

--  VITAL GSR-to-output path delay variable


--  VITAL ticd & tisd variables
      ticd_CLKDIV	: VitalDelayType := 0.000 ns;
      ticd_CLK		: VitalDelayType := 0.000 ns;

      tisd_C23		: VitalDelayType := 0.000 ns;
      tisd_C45		: VitalDelayType := 0.000 ns;
      tisd_C67		: VitalDelayType := 0.000 ns;
      tisd_GSR		: VitalDelayType := 0.000 ns;
      tisd_RST		: VitalDelayType := 0.000 ns;
      tisd_SEL		: VitalDelayArrayType(1 downto 0) :=  (others => 0.000 ns);

--  VITAL Setup/Hold delay variables
--      thold_CE_C_posedge_posedge  : VitalDelayType := 0.000 ns;
--      thold_CE_C_negedge_posedge  : VitalDelayType := 0.000 ns;

-- VITAL pulse width variables
      tpw_CLK_posedge	: VitalDelayType := 0.0 ns;
      tpw_GSR_posedge	: VitalDelayType := 0.0 ns;
      tpw_R_posedge	: VitalDelayType := 0.0 ns;
      tpw_S_posedge	: VitalDelayType := 0.0 ns;

-- VITAL period variables
      tperiod_CLK_posedge	: VitalDelayType := 0.0 ns;

-- VITAL recovery time variables
      trecovery_GSR_CLK_negedge_posedge : VitalDelayType := 0.0 ns;
      trecovery_R_CLK_negedge_posedge   : VitalDelayType := 0.0 ns;
      trecovery_S_CLK_negedge_posedge   : VitalDelayType := 0.0 ns;

-- VITAL removal time variables
      tremoval_GSR_CLK_negedge_posedge  : VitalDelayType := 0.0 ns;
      tremoval_R_CLK_negedge_posedge    : VitalDelayType := 0.0 ns;
      tremoval_S_CLK_negedge_posedge    : VitalDelayType := 0.0 ns
      );

  port(
      LOAD		: out std_ulogic;

      C23		: in std_ulogic;
      C45		: in std_ulogic;
      C67		: in std_ulogic;
      CLK		: in std_ulogic;
      CLKDIV		: in std_ulogic;
      GSR		: in std_ulogic;
      RST		: in std_ulogic;
      SEL		: in std_logic_vector (1 downto 0)
    );

  attribute VITAL_LEVEL0 of
    X_PLG : entity is true;

end X_PLG;

architecture X_PLG_V OF X_PLG is

--  attribute VITAL_LEVEL0 of
--    X_PLG_V : architecture is true;


  constant DELAY_FFDCNT		: time       := 1 ps;
  constant DELAY_MXDCNT		: time       := 1 ps;
  constant DELAY_FFRST		: time       := 145 ps;

  constant MSB_SEL		: integer    := 1;

  signal CLK_ipd                : std_ulogic := 'X';
  signal CLKDIV_ipd             : std_ulogic := 'X';
  signal C23_ipd                : std_ulogic := 'X';
  signal C45_ipd                : std_ulogic := 'X';
  signal C67_ipd                : std_ulogic := 'X';
  signal GSR_ipd                : std_ulogic := 'X';
  signal RST_ipd                : std_ulogic := 'X';
  signal SEL_ipd                : std_logic_vector(1 downto 0) := (others => 'X');

  signal CLK_dly                : std_ulogic := 'X';
  signal CLKDIV_dly             : std_ulogic := 'X';
  signal C23_dly                : std_ulogic := 'X';
  signal C45_dly                : std_ulogic := 'X';
  signal C67_dly                : std_ulogic := 'X';
  signal GSR_dly                : std_ulogic := 'X';
  signal RST_dly                : std_ulogic := 'X';
  signal SEL_dly                : std_logic_vector(1 downto 0) := (others => 'X');

  signal q0			: std_ulogic := 'X';
  signal q1			: std_ulogic := 'X';
  signal q2			: std_ulogic := 'X';
  signal q3			: std_ulogic := 'X';

  signal qhr			: std_ulogic := 'X';
  signal qlr			: std_ulogic := 'X';

  signal mux			: std_ulogic := 'X';

  signal load_zd		: std_ulogic := 'X';

  signal AttrSRtype		: std_ulogic := 'X';

begin

  ---------------------
  --  INPUT PATH DELAYs
  --------------------

  WireDelay : block
  begin

    VitalWireDelay (CLK_ipd,      CLK,      tipd_CLK);
    VitalWireDelay (CLKDIV_ipd,   CLKDIV,   tipd_CLKDIV);
    VitalWireDelay (C23_ipd,      C23,      tipd_C23);
    VitalWireDelay (C45_ipd,      C45,      tipd_C45);
    VitalWireDelay (C67_ipd,      C67,      tipd_C67);
    VitalWireDelay (GSR_ipd,      GSR,      tipd_GSR);
    VitalWireDelay (RST_ipd,      RST,      tipd_RST);
    
    SEL_DELAY: for i in MSB_SEL downto 0 generate
       VitalWireDelay (SEL_ipd(i), SEL(i),      tipd_SEL(i));
    end generate SEL_DELAY;

  end block;

  SignalDelay : block
  begin
    VitalSignalDelay (CLKDIV_dly,   CLKDIV_ipd,   ticd_CLKDIV);
    VitalSignalDelay (CLK_dly,      CLK_ipd,      ticd_CLK);
    VitalSignalDelay (C23_dly,      C23_ipd,      tisd_C23);
    VitalSignalDelay (C45_dly,      C45_ipd,      tisd_C45);
    VitalSignalDelay (C67_dly,      C67_ipd,      tisd_C67);
    VitalSignalDelay (GSR_dly,      GSR_ipd,      tisd_GSR);
    VitalSignalDelay (RST_dly,      RST_ipd,      tisd_RST);

    SEL_DELAY: for i in MSB_SEL downto 0 generate
       VitalSignalDelay (SEL_dly(i),      SEL_ipd(i),      tisd_SEL(i));
    end generate SEL_DELAY;

  end block;

  --------------------
  --  BEHAVIOR SECTION
  --------------------



--####################################################################
--#####                     Initialize                           #####
--####################################################################
  prcs_init:process
  begin
     if((SRTYPE = "ASYNC") or (SRTYPE = "async")) then
        AttrSRtype <= '1';
     elsif((SRTYPE = "SYNC") or (SRTYPE = "sync")) then
        AttrSRtype <= '0';
     end if;

     wait;
  end process prcs_init;
--####################################################################
--#####                          Counter                         #####
--####################################################################
  prcs_ff_cntr:process(qhr, CLK, GSR)
  variable q3_var		:  std_ulogic := TO_X01(INIT_LOADCNT(3));
  variable q2_var		:  std_ulogic := TO_X01(INIT_LOADCNT(2));
  variable q1_var		:  std_ulogic := TO_X01(INIT_LOADCNT(1));
  variable q0_var		:  std_ulogic := TO_X01(INIT_LOADCNT(0));
  begin
     if(GSR = '1') then
         q3_var		:= TO_X01(INIT_LOADCNT(3));
         q2_var		:= TO_X01(INIT_LOADCNT(2));
         q1_var		:= TO_X01(INIT_LOADCNT(1));
         q0_var		:= TO_X01(INIT_LOADCNT(0));
     elsif(GSR = '0') then
        case AttrSRtype is
           when '1' => 
           --------------- // async SET/RESET
                   if(qhr = '1') then
                      q0_var := '0';
                      q1_var := '0';
                      q2_var := '0';
                      q3_var := '0';
                   else
                      if(rising_edge(CLK)) then
                         q3_var := q2_var;
                         q2_var :=( NOT((NOT q0_var) and (NOT q2_var)) and q1_var);
                         q1_var := q0_var;
                         q0_var := mux;
                      end if;
                   end if;

           when '0' => 
           --------------- // sync SET/RESET
                   if(rising_edge(CLK)) then
                      if(qhr = '1') then
                         q0_var := '0';
                         q1_var := '0';
                         q2_var := '0';
                         q3_var := '0';
                      else
                         q3_var := q2_var;
                         q2_var :=( NOT((NOT q0_var) and (NOT q2_var)) and q1_var);
                         q1_var := q0_var;
                         q0_var := mux;
                      end if;
                   end if;

           when others => 
                   null;
           end case;

           q0 <= q0_var after DELAY_FFDCNT;
           q1 <= q1_var after DELAY_FFDCNT;
           q2 <= q2_var after DELAY_FFDCNT;
           q3 <= q3_var after DELAY_FFDCNT;

     end if;
  end process prcs_ff_cntr;
--####################################################################
--#####                     mux signal                           #####
--####################################################################
  prcs_mux_sel:process(sel, c23, c45, c67, q0, q1, q2, q3)
  begin
    case sel is
        when "00" =>
              mux <=  ((not q0) and  (not(c23 and q1))) after DELAY_MXDCNT;
        when "01" =>
              mux <=  ((not q1) and  (not(c45 and q2))) after DELAY_MXDCNT;
        when "10" =>
              mux <=  ((not q2) and  (not(c67 and q3))) after DELAY_MXDCNT;
        when "11" =>
              mux <=  (not (q3)) after DELAY_MXDCNT;
        when others =>
              mux <=  '0' after DELAY_MXDCNT;
    end case;
  end process prcs_mux_sel;
--####################################################################
--#####                    load signal                           #####
--####################################################################
  prcs_load_sel:process(sel, c23, c45, c67, q0, q1, q2, q3)
  begin
    case sel is
        when "00" =>
              load_zd <=  q0 after DELAY_MXDCNT;
        when "01" =>
              load_zd <=  (q0 and q1) after DELAY_MXDCNT;
        when "10" =>
              load_zd <=  (q0 and q2) after DELAY_MXDCNT;
        when "11" =>
              load_zd <=  (q0 and q3) after DELAY_MXDCNT;
        when others =>
              load_zd <=  '0' after DELAY_MXDCNT;
    end case;
  end process prcs_load_sel;
--####################################################################
--#####                 Low/High speed  FFs                      #####
--####################################################################
  prcs_lowspeed:process(clkdiv, rst)
  begin
      case AttrSRtype is
          when '1' => 
           --------------- // async SET/RESET
               if(rst = '1') then
                  qlr        <= '1' after DELAY_FFRST;
               else 
                  if(rising_edge(clkdiv)) then
                     qlr      <= '0' after DELAY_FFRST;
                  end if;
               end if;

          when '0' => 
           --------------- // sync SET/RESET
               if(rising_edge(clkdiv)) then
                  if(rst = '1') then
                     qlr      <= '1' after DELAY_FFRST;
                  else 
                     qlr      <= '0' after DELAY_FFRST;
                  end if;
               end if;
          when others => 
                  null;
      end case;
  end process  prcs_lowspeed;
----------------------------------------------------------------------
  prcs_highspeed:process(clk, rst)
  begin
      case AttrSRtype is
          when '1' => 
           --------------- // async SET/RESET
               if(rst = '1') then
                  qhr <= '1' after DELAY_FFDCNT;
               else 
                  if(rising_edge(clk)) then
                     qhr <= qlr after DELAY_FFDCNT;
                  end if;
               end if;

          when '0' => 
           --------------- // sync SET/RESET
               if(rising_edge(clk)) then
                  if(rst = '1') then
                     qhr <= '1' after DELAY_FFDCNT;
                  else 
                     qhr <= qlr after DELAY_FFDCNT;
                  end if;
               end if;
          when others => 
                  null;
      end case;
  end process  prcs_highspeed;


--####################################################################
--#####                   TIMING CHECKS & OUTPUT                 #####
--####################################################################
  prcs_output:process(load_zd)
  begin
      load <= load_zd;
  end process prcs_output;



end X_PLG_V;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;


library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.VPACKAGE.all;
use simprim.vcomponents.all;

entity X_IOOUT is

  generic(

         SERDES			: boolean	:= TRUE;
         SERDES_MODE		: string	:= "MASTER";
         DATA_RATE_OQ		: string	:= "DDR";
         DATA_WIDTH		: integer	:= 4;
         DDR_CLK_EDGE		: string	:= "SAME_EDGE";
         INIT_OQ		: bit		:= '0';
         SRVAL_OQ		: bit		:= '1';
         INIT_ORANK1		: bit_vector(5 downto 0) := "000000";
         INIT_ORANK2_PARTIAL	: bit_vector(3 downto 0) := "0000";
         INIT_LOADCNT		: bit_vector(3 downto 0) := "0000";

         SRTYPE			: string	:= "ASYNC";

         TimingChecksOn		: boolean	:= true;
         InstancePath		: string	:= "*";
         Xon			: boolean	:= true;
         MsgOn			: boolean	:= false;

--  VITAL input Pin path delay variables
      tipd_C			: VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_CLKDIV		: VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_D1			: VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_D2			: VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_D3			: VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_D4			: VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_D5			: VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_D6			: VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_GSR			: VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_OCE			: VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_REV			: VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_SR			: VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_SHIFTIN1		: VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_SHIFTIN2		: VitalDelayType01 := (0.0 ns, 0.0 ns);

--  VITAL clk-to-output path delay variables
      tpd_C_OQ			: VitalDelayType01 := (0.0 ns, 0.0 ns);
      tpd_CLKDIV_OQ		: VitalDelayType01 := (0.0 ns, 0.0 ns);

--  VITAL async rest-to-output path delay variables
      tpd_REV_OQ		: VitalDelayType01 := (0.0 ns, 0.0 ns);

--  VITAL async set-to-output path delay variables
      tpd_SR_OQ			: VitalDelayType01 := (0.0 ns, 0.0 ns);

--  VITAL GSR-to-output path delay variable
      tpd_GSR_OQ		: VitalDelayType01 := (0.0 ns, 0.0 ns);


--  VITAL ticd & tisd variables
      ticd_CLKDIV		: VitalDelayType := 0.000 ns;
      ticd_C			: VitalDelayType := 0.000 ns;

      tisd_D1			: VitalDelayType := 0.000 ns;
      tisd_D2			: VitalDelayType := 0.000 ns;
      tisd_D3			: VitalDelayType := 0.000 ns;
      tisd_D4			: VitalDelayType := 0.000 ns;
      tisd_D5			: VitalDelayType := 0.000 ns;
      tisd_D6			: VitalDelayType := 0.000 ns;
      tisd_GSR			: VitalDelayType := 0.000 ns;
      tisd_OCE			: VitalDelayType := 0.000 ns;
      tisd_REV			: VitalDelayType := 0.000 ns;
      tisd_SR			: VitalDelayType := 0.000 ns;
      tisd_SHIFTIN1		: VitalDelayType := 0.000 ns;
      tisd_SHIFTIN2		: VitalDelayType := 0.000 ns;

--  VITAL Setup/Hold delay variables
--      thold_CE_C_posedge_posedge  : VitalDelayType := 0.000 ns;
--      thold_CE_C_negedge_posedge  : VitalDelayType := 0.000 ns;

-- VITAL pulse width variables
      tpw_C_posedge	: VitalDelayType := 0.0 ns;
      tpw_GSR_posedge	: VitalDelayType := 0.0 ns;
      tpw_REV_posedge	: VitalDelayType := 0.0 ns;
      tpw_SR_posedge	: VitalDelayType := 0.0 ns;

-- VITAL period variables
      tperiod_C_posedge	: VitalDelayType := 0.0 ns;

-- VITAL recovery time variables
      trecovery_GSR_C_negedge_posedge : VitalDelayType := 0.0 ns;
      trecovery_REV_C_negedge_posedge : VitalDelayType := 0.0 ns;
      trecovery_SR_C_negedge_posedge  : VitalDelayType := 0.0 ns;

-- VITAL removal time variables
      tremoval_GSR_C_negedge_posedge  : VitalDelayType := 0.0 ns;
      tremoval_REV_C_negedge_posedge  : VitalDelayType := 0.0 ns;
      tremoval_SR_C_negedge_posedge   : VitalDelayType := 0.0 ns
      );

  port(
      OQ		: out std_ulogic;
      LOAD		: out std_ulogic;
      SHIFTOUT1		: out std_ulogic;
      SHIFTOUT2		: out std_ulogic;

      C			: in std_ulogic;
      CLKDIV		: in std_ulogic;
      D1		: in std_ulogic;
      D2		: in std_ulogic;
      D3		: in std_ulogic;
      D4		: in std_ulogic;
      D5		: in std_ulogic;
      D6		: in std_ulogic;
      GSR		: in std_ulogic;
      OCE		: in std_ulogic;
      REV	        : in std_ulogic;
      SR	        : in std_ulogic;
      SHIFTIN1		: in std_ulogic;
      SHIFTIN2		: in std_ulogic
    );

  attribute VITAL_LEVEL0 of
    X_IOOUT : entity is true;

end X_IOOUT;

architecture X_IOOUT_V OF X_IOOUT is

--  attribute VITAL_LEVEL0 of
--    X_IOOUT_V : architecture is true;

component X_PLG
  generic(
      SRTYPE            : string;
      INIT_LOADCNT      : bit_vector(3 downto 0)
      );
  port(
      LOAD              : out std_ulogic;

      C23               : in std_ulogic;
      C45               : in std_ulogic;
      C67               : in std_ulogic;
      CLK               : in std_ulogic;
      CLKDIV            : in std_ulogic;
      GSR               : in std_ulogic;
      RST               : in std_ulogic;
      SEL               : in std_logic_vector (1 downto 0)
      );

end component;

  constant DELAY_FFD            : time       := 1 ps; 
  constant DELAY_FFCD           : time       := 1 ps; 
  constant DELAY_MXD	        : time       := 1 ps;
  constant DELAY_MXR1	        : time       := 1 ps;

  constant SWALLOW_PULSE        : time       := 2 ps;

  constant MAX_DATAWIDTH	: integer    := 4;

  signal C_ipd		        : std_ulogic := 'X';
  signal CLKDIV_ipd		: std_ulogic := 'X';
  signal D1_ipd			: std_ulogic := 'X';
  signal D2_ipd			: std_ulogic := 'X';
  signal D3_ipd			: std_ulogic := 'X';
  signal D4_ipd			: std_ulogic := 'X';
  signal D5_ipd			: std_ulogic := 'X';
  signal D6_ipd			: std_ulogic := 'X';
  signal GSR_ipd		: std_ulogic := 'X';
  signal OCE_ipd	        : std_ulogic := 'X';
  signal REV_ipd	        : std_ulogic := 'X';
  signal SR_ipd		        : std_ulogic := 'X';
  signal SHIFTIN1_ipd		: std_ulogic := 'X';
  signal SHIFTIN2_ipd		: std_ulogic := 'X';

  signal C_dly	                : std_ulogic := 'X';
  signal CLKDIV_dly		: std_ulogic := 'X';
  signal D1_dly			: std_ulogic := 'X';
  signal D2_dly			: std_ulogic := 'X';
  signal D3_dly			: std_ulogic := 'X';
  signal D4_dly			: std_ulogic := 'X';
  signal D5_dly			: std_ulogic := 'X';
  signal D6_dly			: std_ulogic := 'X';
  signal GSR_dly		: std_ulogic := 'X';
  signal OCE_dly	        : std_ulogic := 'X';
  signal REV_dly	        : std_ulogic := 'X';
  signal SR_dly		        : std_ulogic := 'X';
  signal SHIFTIN1_dly		: std_ulogic := 'X';
  signal SHIFTIN2_dly		: std_ulogic := 'X';

  signal OQ_zd			: std_ulogic := TO_X01(INIT_OQ);
  signal LOAD_zd		: std_ulogic := 'X';
  signal SHIFTOUT1_zd		: std_ulogic := 'X';
  signal SHIFTOUT2_zd		: std_ulogic := 'X';

  signal AttrDataRateOQ		: std_ulogic := 'X';
  signal AttrDataRateTQ		: std_logic_vector(1 downto 0) := (others => 'X');
  signal AttrDataWidth		: std_logic_vector(3 downto 0) := (others => 'X');
  signal AttrTriStateWidth	: std_logic_vector(1 downto 0) := (others => 'X');
  signal AttrMode		: std_ulogic := 'X';
  signal AttrDdrClkEdge		: std_ulogic := 'X';

  signal AttrSRtype		: std_logic_vector(5 downto 0) := (others => '1');

  signal AttrSerdes		: std_ulogic := 'X';

  signal d1r			: std_ulogic := 'X';
  signal d2r			: std_ulogic := 'X';
  signal d3r			: std_ulogic := 'X';
  signal d4r			: std_ulogic := 'X';
  signal d5r			: std_ulogic := 'X';
  signal d6r			: std_ulogic := 'X';

  signal d1rnk2			: std_ulogic := 'X';
  signal d2rnk2			: std_ulogic := 'X';
  signal d2nrnk2		: std_ulogic := 'X';
  signal d3rnk2			: std_ulogic := 'X';
  signal d4rnk2			: std_ulogic := 'X';
  signal d5rnk2			: std_ulogic := 'X';
  signal d6rnk2			: std_ulogic := 'X';

  signal data1			: std_ulogic := 'X';
  signal data2			: std_ulogic := 'X';
  signal data3			: std_ulogic := 'X';
  signal data4			: std_ulogic := 'X';
  signal data5			: std_ulogic := 'X';
  signal data6			: std_ulogic := 'X';

  signal ddr_data		: std_ulogic := 'X';
  signal odata_edge		: std_ulogic := 'X';
  signal sdata_edge		: std_ulogic := 'X';

  signal c23			: std_ulogic := 'X';
  signal c45			: std_ulogic := 'X';
  signal c67			: std_ulogic := 'X';

  signal sel			: std_logic_vector(1 downto 0) := (others => 'X');

  signal C2p			: std_ulogic := 'X';
  signal C3			: std_ulogic := 'X';

  signal loadint		: std_ulogic := 'X';

  signal seloq			: std_logic_vector(3 downto 0) := (others => 'X');

  signal oqsr			: std_ulogic := 'X';

  signal oqrev			: std_ulogic := 'X';

  signal sel1_4			: std_logic_vector(2 downto 0) := (others => 'X');
  signal sel5_6			: std_logic_vector(3 downto 0) := (others => 'X');

  signal plgcnt			: std_logic_vector(4 downto 0) := (others => 'X');

begin

  ---------------------
  --  INPUT PATH DELAYs
  --------------------

  WireDelay : block
  begin
    VitalWireDelay (C_ipd,        C,        tipd_C);
    VitalWireDelay (CLKDIV_ipd,   CLKDIV,   tipd_CLKDIV);
    VitalWireDelay (D1_ipd,       D1,       tipd_D1);
    VitalWireDelay (D2_ipd,       D2,       tipd_D2);
    VitalWireDelay (D3_ipd,       D3,       tipd_D3);
    VitalWireDelay (D4_ipd,       D4,       tipd_D4);
    VitalWireDelay (D5_ipd,       D5,       tipd_D5);
    VitalWireDelay (D6_ipd,       D6,       tipd_D6);
    VitalWireDelay (GSR_ipd,      GSR,      tipd_GSR);
    VitalWireDelay (OCE_ipd,      OCE,      tipd_OCE);
    VitalWireDelay (REV_ipd,      REV,      tipd_REV);
    VitalWireDelay (SR_ipd,       SR,       tipd_SR);
    VitalWireDelay (SHIFTIN1_ipd, SHIFTIN1, tipd_SHIFTIN1);
    VitalWireDelay (SHIFTIN2_ipd, SHIFTIN2, tipd_SHIFTIN2);
  end block;

  SignalDelay : block
  begin
    VitalSignalDelay (CLKDIV_dly,   CLKDIV_ipd,   ticd_CLKDIV);
    VitalSignalDelay (C_dly,       C_ipd,      ticd_C);
    VitalSignalDelay (D1_dly,       D1_ipd,       tisd_D1);
    VitalSignalDelay (D2_dly,       D2_ipd,       tisd_D2);
    VitalSignalDelay (D3_dly,       D3_ipd,       tisd_D3);
    VitalSignalDelay (D4_dly,       D4_ipd,       tisd_D4);
    VitalSignalDelay (D5_dly,       D5_ipd,       tisd_D5);
    VitalSignalDelay (D6_dly,       D6_ipd,       tisd_D6);
    VitalSignalDelay (GSR_dly,      GSR_ipd,      tisd_GSR);
    VitalSignalDelay (OCE_dly,      OCE_ipd,      tisd_OCE);
    VitalSignalDelay (REV_dly,      REV_ipd,      tisd_REV);
    VitalSignalDelay (SR_dly,       SR_ipd,       tisd_SR);
    VitalSignalDelay (SHIFTIN1_dly, SHIFTIN1_ipd, tisd_SHIFTIN1);
    VitalSignalDelay (SHIFTIN2_dly, SHIFTIN2_ipd, tisd_SHIFTIN2);
  end block;

  --------------------
  --  BEHAVIOR SECTION
  --------------------


--####################################################################
--#####                     Initialize                           #####
--####################################################################
  prcs_init:process
  variable AttrDataRateOQ_var		: std_ulogic := 'X';
  variable AttrDataWidth_var		: std_logic_vector(3 downto 0) := (others => 'X');
  variable AttrMode_var			: std_ulogic := 'X';
  variable AttrDdrClkEdge_var		: std_ulogic := 'X';
  variable AttrSerdes_var		: std_ulogic := 'X';

  begin
      -------------------- SERDES validity check --------------------
      if(SERDES = true) then
        AttrSerdes_var := '1';
      else
        AttrSerdes_var := '0';
      end if;

      ------------ SERDES_MODE validity check --------------------
      if((SERDES_MODE = "MASTER") or (SERDES_MODE = "master")) then
         AttrMode_var := '0';
      elsif((SERDES_MODE = "SLAVE") or (SERDES_MODE = "slave")) then
         AttrMode_var := '1';
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Warning ",
             GenericName => "SERDES_MODE ",
             EntityName => "/X_IOOUT",
             GenericValue => SERDES_MODE,
             Unit => "",
             ExpectedValueMsg => " The legal values for this attribute are ",
             ExpectedGenericValue => " MASTER or SLAVE.",
             TailMsg => "",
             MsgSeverity => FAILURE 
         );
      end if;

      ------------------ DATA_RATE validity check ------------------

      if((DATA_RATE_OQ = "DDR") or (DATA_RATE_OQ = "ddr")) then
         AttrDataRateOQ_var := '0';
      elsif((DATA_RATE_OQ = "SDR") or (DATA_RATE_OQ = "sdr")) then
         AttrDataRateOQ_var := '1';
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Warning ",
             GenericName => " DATA_RATE_OQ ",
             EntityName => "/X_IOOUT",
             GenericValue => DATA_RATE_OQ,
             Unit => "",
             ExpectedValueMsg => " The legal values for this attribute are ",
             ExpectedGenericValue => " DDR or SDR. ",
             TailMsg => "",
             MsgSeverity => Failure
         );
      end if;

      ------------------ DATA_WIDTH validity check ------------------
      if((DATA_WIDTH = 2) or (DATA_WIDTH = 3) or  (DATA_WIDTH = 4) or
         (DATA_WIDTH = 5) or (DATA_WIDTH = 6) or  (DATA_WIDTH = 7) or
         (DATA_WIDTH = 8) or (DATA_WIDTH = 10)) then
         AttrDataWidth_var := CONV_STD_LOGIC_VECTOR(DATA_WIDTH, MAX_DATAWIDTH); 
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Warning ",
             GenericName => " DATA_WIDTH ",
             EntityName => "/X_IOOUT",
             GenericValue => DATA_WIDTH,
             Unit => "",
             ExpectedValueMsg => " The legal values for this attribute are ",
             ExpectedGenericValue => " 2, 3, 4, 5, 6, 7, 8, or 10 ",
             TailMsg => "",
             MsgSeverity => Failure
         );
      end if;
      ------------ DATA_WIDTH /DATA_RATE combination check ------------
      if((DATA_RATE_OQ = "DDR") or (DATA_RATE_OQ = "ddr")) then
         case (DATA_WIDTH) is
             when 4|6|8|10  => null;
             when others       =>
                GenericValueCheckMessage
                (  HeaderMsg  => " Attribute Syntax Warning ",
                   GenericName => " DATA_WIDTH ",
                   EntityName => "/X_IOOUT",
                   GenericValue => DATA_WIDTH,
                   Unit => "",
                   ExpectedValueMsg => " The legal values for this attribute in DDR mode are ",
                   ExpectedGenericValue => " 4, 6, 8, or 10 ",
                   TailMsg => "",
                   MsgSeverity => Failure
                );
          end case;
      end if;

      if((DATA_RATE_OQ = "SDR") or (DATA_RATE_OQ = "sdr")) then
         case (DATA_WIDTH) is
             when 2|3|4|5|6|7|8  => null;
             when others       =>
                GenericValueCheckMessage
                (  HeaderMsg  => " Attribute Syntax Warning ",
                   GenericName => " DATA_WIDTH ",
                   EntityName => "/X_IOOUT",
                   GenericValue => DATA_WIDTH,
                   Unit => "",
                   ExpectedValueMsg => " The legal values for this attribute in SDR mode are ",
                   ExpectedGenericValue => " 2, 3, 4, 5, 6, 7 or 8.",
                   TailMsg => "",
                   MsgSeverity => Failure
                );
          end case;
      end if;

      ------------------ DDR_CLK_EDGE validity check ------------------

      if((DDR_CLK_EDGE = "SAME_EDGE") or (DDR_CLK_EDGE = "same_edge")) then
         AttrDdrClkEdge_var := '1';
      elsif((DDR_CLK_EDGE = "OPPOSITE_EDGE") or (DDR_CLK_EDGE = "opposite_edge")) then
         AttrDdrClkEdge_var := '0';
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Warning ",
             GenericName => " DDR_CLK_EDGE ",
             EntityName => "/X_IOOUT",
             GenericValue => DDR_CLK_EDGE,
             Unit => "",
             ExpectedValueMsg => " The legal values for this attribute are ",
             ExpectedGenericValue => " SAME_EDGE or OPPOSITE_EDGE ",
             TailMsg => "",
             MsgSeverity => Failure
         );
      end if;
      ------------------ DATA_RATE validity check ------------------
      if((SRTYPE = "ASYNC") or (SRTYPE = "async")) then
         AttrSRtype  <= (others => '1');
      elsif((SRTYPE = "SYNC") or (SRTYPE = "sync")) then
         AttrSRtype  <= (others => '0');
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Warning ",
             GenericName => " SRTYPE ",
             EntityName => "/X_IOOUT",
             GenericValue => SRTYPE,
             Unit => "",
             ExpectedValueMsg => " The legal values for this attribute are ",
             ExpectedGenericValue => " ASYNC or SYNC. ",
             TailMsg => "",
             MsgSeverity => ERROR
         );
      end if;

      AttrSerdes		<= AttrSerdes_var;
      AttrMode		<= AttrMode_var;
      AttrDataRateOQ	<= AttrDataRateOQ_var;
      AttrDataWidth	<= AttrDataWidth_var;
      AttrDdrClkEdge	<= AttrDdrClkEdge_var;

      plgcnt     <= AttrDataRateOQ_var & AttrDataWidth_var; 

      wait;
  end process prcs_init;
--###################################################################
--#####                   Concurrent exe                        #####
--###################################################################
   C2p    <= (C_dly and AttrDdrClkEdge) or 
             ((not C_dly) and (not AttrDdrClkEdge)); 
   C3     <= not C2p;
   sel1_4 <= AttrSerdes & loadint & AttrDataRateOQ;
   sel5_6 <= AttrSerdes & AttrMode & loadint & AttrDataRateOQ;
   LOAD_zd <= loadint;
   seloq   <= OCE_dly & AttrDataRateOQ & oqsr & oqrev;
   
   oqsr    <= ((AttrSRtype(1) and SR_dly and not (TO_X01(SRVAL_OQ)))
                               or
                (AttrSRtype(1) and REV_dly and (TO_X01(SRVAL_OQ))));

   oqrev   <= ((AttrSRtype(1) and SR_dly and (TO_X01(SRVAL_OQ)))
                               or
                (AttrSRtype(1) and REV_dly and not (TO_X01(SRVAL_OQ))));

   SHIFTOUT1_zd <= d3rnk2 and AttrMode;
   SHIFTOUT2_zd <= d4rnk2 and AttrMode;
--###################################################################
--#####                     q1rnk2 reg                          #####
--###################################################################
  prcs_D1_rnk2:process(C_dly, GSR_dly, REV_dly, SR_dly)
  variable d1rnk2_var         : std_ulogic := TO_X01(INIT_OQ);
  variable FIRST_TIME         : boolean    := true;
  begin
     if((GSR_dly = '1') or (FIRST_TIME)) then
         d1rnk2_var  :=  TO_X01(INIT_OQ);
         FIRST_TIME  := false;
     elsif(GSR_dly = '0') then
        case AttrSRtype(1) is
           when '1' => 
           --------------- // async SET/RESET
                   if((SR_dly = '1') and (not ((REV_dly = '1') and (TO_X01(SRVAL_OQ) = '1')))) then
                      d1rnk2_var := TO_X01(SRVAL_OQ);
                   elsif(REV_dly = '1') then
                      d1rnk2_var := not TO_X01(SRVAL_OQ);
                   elsif((SR_dly = '0') and (REV_dly = '0')) then
                      if(OCE = '1') then
                         if(rising_edge(C_dly)) then
                            d1rnk2_var := data1;
                         end if;
                      elsif(OCE = '0') then
                         if(rising_edge(C_dly)) then
                            d1rnk2_var := OQ_zd;
                         end if;
                      end if;
                   end if;

           when '0' => 
           --------------- // sync SET/RESET
                   if(rising_edge(C_dly)) then
                      if((SR_dly = '1') and (not ((REV_dly = '1') and (TO_X01(SRVAL_OQ) = '1')))) then
                         d1rnk2_var := TO_X01(SRVAL_OQ);
                      elsif(REV_dly = '1') then
                         d1rnk2_var := not TO_X01(SRVAL_OQ);
                      elsif((SR_dly = '0') and (REV_dly = '0')) then
                         if(OCE = '1') then
                            d1rnk2_var := data1;
                         elsif(OCE = '0') then
                            d1rnk2_var := OQ_zd;
                         end if;
                      end if;
                   end if;

           when others =>
                   null;
                        
        end case;
     end if;

     d1rnk2  <= d1rnk2_var  after DELAY_FFD;

  end process prcs_D1_rnk2;
--###################################################################
--#####                     d2rnk2 reg                          #####
--###################################################################
  prcs_D2_rnk2:process(C2p, GSR_dly, REV_dly, SR_dly)
  variable d2rnk2_var         : std_ulogic := TO_X01(INIT_OQ);
  variable FIRST_TIME         : boolean    := true;
  begin
     if((GSR_dly = '1') or (FIRST_TIME)) then
         d2rnk2_var  :=  TO_X01(INIT_OQ);
         FIRST_TIME  := false;
     elsif(GSR_dly = '0') then
        case AttrSRtype(1) is
           when '1' => 
           --------------- // async SET/RESET
                   if((SR_dly = '1') and (not ((REV_dly = '1') and (TO_X01(SRVAL_OQ) = '1')))) then
                      d2rnk2_var :=  TO_X01(SRVAL_OQ);
                   elsif(REV_dly = '1') then
                      d2rnk2_var :=  not TO_X01(SRVAL_OQ);
                   elsif((SR_dly = '0') and (REV_dly = '0')) then
                      if(OCE = '1') then
                         if(rising_edge(C2p)) then
                            d2rnk2_var := data2;
                         end if;
                      elsif(OCE = '0') then
                         if(rising_edge(C2p)) then
                            d2rnk2_var := OQ_zd;
                         end if;
                      end if;
                   end if;

           when '0' => 
           --------------- // sync SET/RESET
                   if(rising_edge(C2p)) then
                      if((SR_dly = '1') and (not ((REV_dly = '1') and (TO_X01(SRVAL_OQ) = '1')))) then
                         d2rnk2_var :=  TO_X01(SRVAL_OQ);
                      elsif(REV_dly = '1') then
                         d2rnk2_var :=  not TO_X01(SRVAL_OQ);
                      elsif((SR_dly = '0') and (REV_dly = '0')) then
                         if(OCE = '1') then
                            d2rnk2_var := data2;
                         elsif(OCE = '0') then
                            d2rnk2_var := OQ_zd;
                         end if;
                      end if;
                   end if;

           when others =>
                   null;
                        
        end case;
     end if;

     d2rnk2  <= d2rnk2_var  after DELAY_FFD;

  end process prcs_D2_rnk2;
--###################################################################
--#####                     d2nrnk2 reg                          #####
--###################################################################
  prcs_D2_nrnk2:process(C3, GSR_dly, REV_dly, SR_dly)
  variable d2nrnk2_var         : std_ulogic := TO_X01(INIT_OQ);
  variable FIRST_TIME          : boolean    := true;
  begin
     if((GSR_dly = '1') or (FIRST_TIME)) then
         d2nrnk2_var  := TO_X01(INIT_OQ);
         FIRST_TIME  := false;
     elsif(GSR_dly = '0') then
        case AttrSRtype(1) is
           when '1' => 
           --------------- // async SET/RESET
                   if((SR_dly = '1') and (not ((REV_dly = '1') and (TO_X01(SRVAL_OQ) = '1')))) then
                      d2nrnk2_var :=  TO_X01(SRVAL_OQ);
                   elsif(REV_dly = '1') then
                      d2nrnk2_var :=  not TO_X01(SRVAL_OQ);
                   elsif((SR_dly = '0') and (REV_dly = '0')) then
                      if(OCE = '1') then
                         if(rising_edge(C3)) then
                            d2nrnk2_var := d2rnk2;
                         end if;
                      elsif(OCE = '0') then
                         if(rising_edge(C3)) then
                            d2nrnk2_var := OQ_zd;
                         end if;
                      end if;
                   end if;

           when '0' => 
           --------------- // sync SET/RESET
                   if(rising_edge(C3)) then
                      if((SR_dly = '1') and (not ((REV_dly = '1') and (TO_X01(SRVAL_OQ) = '1')))) then
                         d2nrnk2_var :=  TO_X01(SRVAL_OQ);
                      elsif(REV_dly = '1') then
                         d2nrnk2_var :=  not TO_X01(SRVAL_OQ);
                      elsif((SR_dly = '0') and (REV_dly = '0')) then
                         if(OCE = '1') then
                            d2nrnk2_var := d2rnk2;
                         elsif(OCE = '0') then
                            d2nrnk2_var := OQ_zd;
                         end if;
                      end if;
                   end if;

           when others =>
                   null;
                        
        end case;
     end if;

     d2nrnk2  <= d2nrnk2_var  after DELAY_FFD;

  end process prcs_D2_nrnk2;
--###################################################################
--#####              d3rnk2, d4rnk2, d5rnk2 and d6rnk2          #####
--###################################################################
  prcs_D3D4D5D6_rnk2:process(C_dly, GSR_dly, SR_dly)
  variable d6rnk2_var         : std_ulogic := TO_X01(INIT_ORANK2_PARTIAL(3));
  variable d5rnk2_var         : std_ulogic := TO_X01(INIT_ORANK2_PARTIAL(2));
  variable d4rnk2_var         : std_ulogic := TO_X01(INIT_ORANK2_PARTIAL(1));
  variable d3rnk2_var         : std_ulogic := TO_X01(INIT_ORANK2_PARTIAL(0));
  variable FIRST_TIME         : boolean    := true;

  begin
     if((GSR_dly = '1') or (FIRST_TIME)) then
         d6rnk2_var  := TO_X01(INIT_ORANK2_PARTIAL(3));
         d5rnk2_var  := TO_X01(INIT_ORANK2_PARTIAL(2));
         d4rnk2_var  := TO_X01(INIT_ORANK2_PARTIAL(1));
         d3rnk2_var  := TO_X01(INIT_ORANK2_PARTIAL(0));
         FIRST_TIME  := false;
     elsif(GSR_dly = '0') then
        case AttrSRtype(2) is
           when '1' => 
           --------- // async SET/RESET  -- Not full featured FFs
                   if(SR_dly = '1') then
                      d6rnk2_var  := '0';
                      d5rnk2_var  := '0';
                      d4rnk2_var  := '0';
                      d3rnk2_var  := '0';
                   elsif(SR_dly = '0') then
                      if(rising_edge(C_dly)) then
                         d6rnk2_var  := data6;
                         d5rnk2_var  := data5;
                         d4rnk2_var  := data4;
                         d3rnk2_var  := data3;
                      end if;
                   end if;

           when '0' => 
           --------- // sync SET/RESET  -- Not full featured FFs
                   if(rising_edge(C_dly)) then
                      if(SR_dly = '1') then
                         d6rnk2_var  := '0';
                         d5rnk2_var  := '0';
                         d4rnk2_var  := '0';
                         d3rnk2_var  := '0';
                      elsif(SR_dly = '0') then
                         d6rnk2_var  := data6;
                         d5rnk2_var  := data5;
                         d4rnk2_var  := data4;
                         d3rnk2_var  := data3;
                      end if;
                   end if;

           when others =>
                   null;
                        
        end case;
     end if;

     d6rnk2  <= d6rnk2_var  after DELAY_FFD;
     d5rnk2  <= d5rnk2_var  after DELAY_FFD;
     d4rnk2  <= d4rnk2_var  after DELAY_FFD;
     d3rnk2  <= d3rnk2_var  after DELAY_FFD;

  end process prcs_D3D4D5D6_rnk2;

--//////////////////////////////////////////////////////////////////
--//                   First rank of FF for input data            //
--//////////////////////////////////////////////////////////////////

--###################################################################
--#####              d1r, d2r, d3r, d4r, d5r and d6r            #####
--###################################################################
  prcs_D1D2D3D4D5D6_r:process(CLKDIV_dly, GSR_dly, SR_dly)
  variable d6r_var            : std_ulogic := TO_X01(INIT_ORANK1(5));
  variable d5r_var            : std_ulogic := TO_X01(INIT_ORANK1(4));
  variable d4r_var            : std_ulogic := TO_X01(INIT_ORANK1(3));
  variable d3r_var            : std_ulogic := TO_X01(INIT_ORANK1(2));
  variable d2r_var            : std_ulogic := TO_X01(INIT_ORANK1(1));
  variable d1r_var            : std_ulogic := TO_X01(INIT_ORANK1(0));
  variable FIRST_TIME         : boolean    := true;

  begin
     if((GSR_dly = '1') or (FIRST_TIME)) then
         d6r_var     := TO_X01(INIT_ORANK1(5));
         d5r_var     := TO_X01(INIT_ORANK1(4));
         d4r_var     := TO_X01(INIT_ORANK1(3));
         d3r_var     := TO_X01(INIT_ORANK1(2));
         d2r_var     := TO_X01(INIT_ORANK1(1));
         d1r_var     := TO_X01(INIT_ORANK1(0));
         FIRST_TIME  := false;
     elsif(GSR_dly = '0') then
        case AttrSRtype(3) is
           when '1' => 
           --------- // async SET/RESET  -- Not full featured FFs
                   if(SR_dly = '1') then
                      d6r_var  := '0';
                      d5r_var  := '0';
                      d4r_var  := '0';
                      d3r_var  := '0';
                      d2r_var  := '0';
                      d1r_var  := '0';
                   elsif(SR_dly = '0') then
                      if(rising_edge(CLKDIV_dly)) then
                         d6r_var  := D6_dly;
                         d5r_var  := D5_dly;
                         d4r_var  := D4_dly;
                         d3r_var  := D3_dly;
                         d2r_var  := D2_dly;
                         d1r_var  := D1_dly;
                      end if;
                   end if;

           when '0' => 
           --------- // sync SET/RESET  -- Not full featured FFs
                   if(rising_edge(CLKDIV_dly)) then
                      if(SR_dly = '1') then
                         d6r_var  := '0';
                         d5r_var  := '0';
                         d4r_var  := '0';
                         d3r_var  := '0';
                         d2r_var  := '0';
                         d1r_var  := '0';
                      elsif(SR_dly = '0') then
                         d6r_var  := D6_dly;
                         d5r_var  := D5_dly;
                         d4r_var  := D4_dly;
                         d3r_var  := D3_dly;
                         d2r_var  := D2_dly;
                         d1r_var  := D1_dly;
                      end if;
                   end if;

           when others =>
                   null;
                        
        end case;
     end if;

     d6r  <= d6r_var  after DELAY_FFCD;
     d5r  <= d5r_var  after DELAY_FFCD;
     d4r  <= d4r_var  after DELAY_FFCD;
     d3r  <= d3r_var  after DELAY_FFCD;
     d2r  <= d2r_var  after DELAY_FFCD;
     d1r  <= d1r_var  after DELAY_FFCD;

  end process prcs_D1D2D3D4D5D6_r;

--###################################################################
--#####                Muxes for 2nd rank of FFS                #####
--###################################################################
  prcs_data1234_mux:process(sel1_4, d1r, d2r, d3r, d4r, d2rnk2,
                                d3rnk2, d4rnk2, d5rnk2, d6rnk2)

  begin
     case sel1_4 is
           when "100" =>
                    data1 <= d3rnk2 after DELAY_MXR1;
                    data2 <= d4rnk2 after DELAY_MXR1;
                    data3 <= d5rnk2 after DELAY_MXR1;
                    data4 <= d6rnk2 after DELAY_MXR1;
           when "110" =>
                    data1 <= d1r    after DELAY_MXR1;
                    data2 <= d2r    after DELAY_MXR1;
                    data3 <= d3r    after DELAY_MXR1;
                    data4 <= d4r    after DELAY_MXR1;
           when "101" =>
                    data1 <= d2rnk2 after DELAY_MXR1;
                    data2 <= d3rnk2 after DELAY_MXR1;
                    data3 <= d4rnk2 after DELAY_MXR1;
                    data4 <= d5rnk2 after DELAY_MXR1;
           when "111" =>
                    data1 <= d1r    after DELAY_MXR1;
                    data2 <= d2r    after DELAY_MXR1;
                    data3 <= d3r    after DELAY_MXR1;
                    data4 <= d4r    after DELAY_MXR1;
           when others =>
                    data1 <= d3rnk2 after DELAY_MXR1;
                    data2 <= d4rnk2 after DELAY_MXR1;
                    data3 <= d5rnk2 after DELAY_MXR1;
                    data4 <= d6rnk2 after DELAY_MXR1;
     end case;

  end process prcs_data1234_mux;

----------------------------------------------------------------------

  prcs_data56_mux:process(sel5_6, d5r, d6r, d6rnk2, SHIFTIN1_dly,
                                                    SHIFTIN2_dly )

  begin
     case sel5_6 is
           when "1000" =>
                    data5 <=  SHIFTIN1_dly after DELAY_MXR1;
                    data6 <=  SHIFTIN2_dly after DELAY_MXR1;
           when "1010" =>
                    data5 <=  d5r after DELAY_MXR1;
                    data6 <=  d6r after DELAY_MXR1;
           when "1001" =>
                    data5 <=  d6rnk2 after DELAY_MXR1;
                    data6 <=  SHIFTIN1_dly after DELAY_MXR1;
           when "1011" =>
                    data5 <=  d5r after DELAY_MXR1;
                    data6 <=  d6r after DELAY_MXR1;
           when "1100" =>
                    data5 <=  '0' after DELAY_MXR1;
                    data6 <=  '0' after DELAY_MXR1;
           when "1110" =>
                    data5 <=  d5r after DELAY_MXR1;
                    data6 <=  d6r after DELAY_MXR1;
           when "1101" =>
                    data5 <=  d6rnk2 after DELAY_MXR1;
                    data6 <=  '0' after DELAY_MXR1;
           when "1111" =>
                    data5 <=  d5r after DELAY_MXR1;
                    data6 <=  d6r after DELAY_MXR1;

           when others =>
                    data5 <=  SHIFTIN1_dly after DELAY_MXR1;
                    data6 <=  SHIFTIN2_dly after DELAY_MXR1;
     end case;

  end process prcs_data56_mux;
--###################################################################
--#####        sdata_edge                                      ######
--###################################################################
  prcs_sdata:process(C_dly, C3, d1rnk2, d2nrnk2)
  begin
     sdata_edge <= ((d1rnk2 and C_dly) or (d2nrnk2 and C3)) after DELAY_MXD;
  end process prcs_sdata;

--###################################################################
--#####             odata_edge                                  #####
--###################################################################
  prcs_odata:process(C_dly, d1rnk2, d2rnk2)
  begin
     case C_dly is
           when '0' => 
                    odata_edge <= d2rnk2 after DELAY_MXD;
           when '1' => 
                    odata_edge <= d1rnk2 after DELAY_MXD;
           when others =>
                    odata_edge <= d2rnk2 after DELAY_MXD;
     end case;
  end process prcs_odata;
--###################################################################
--#####                 ddr_data                               ######
--###################################################################
  prcs_ddrdata:process(ddr_data, sdata_edge, odata_edge, AttrDdrClkEdge)
  begin
     ddr_data <= ((odata_edge and (not AttrDdrClkEdge)) or 
                    (sdata_edge and AttrDdrClkEdge)) after DELAY_MXD;
  end process prcs_ddrdata;

---////////////////////////////////////////////////////////////////////
---                       Outputs
---////////////////////////////////////////////////////////////////////
  prcs_OQ_mux:process(seloq, d1rnk2, ddr_data, OQ_zd, GSR_dly)

  variable FIRST_TIME : boolean := true;

  begin
     if((GSR_dly = '1') or (FIRST_TIME)) then
       OQ_zd    <=  TO_X01(INIT_OQ);
       FIRST_TIME := false;
     elsif(GSR_dly = '0') then
        case seloq is
           when "0001" | "0101"| "1001" | "1101" |
                "0X01" | "1X01"| "XX01" | "X001" |
                "X101" 
                       => 
                       OQ_zd <= '1' after DELAY_MXD;

           when "0010" | "0110"| "1010" | "1110" |
                "0X10" | "1X10"| "XX10" | "X010" |
                "X110" 
                       => 
                       OQ_zd <= '0' after DELAY_MXD;
   
           when "0011" | "0111"| "1011" | "1111" |
                "0X11" | "1X11"| "XX11" | "X011" |
                "X111" 
                       => 
                       OQ_zd <= '0' after DELAY_MXD;
   
           when "0000" =>
                       OQ_zd <= OQ_zd after DELAY_MXD;
   
           when "0100" =>
                       OQ_zd <= OQ_zd after DELAY_MXD;
   
           when "1000" =>
                       OQ_zd <= ddr_data after DELAY_MXD;
   
           when "1100" =>
                       OQ_zd <= d1rnk2 after DELAY_MXD;
   
           when others =>
-- CR 192533 the below "now > DEALY_MXD" is added since 
-- the INIT value of OQ_zd is getting wiped off by ddr_data=X at time 0.
-- At time 0, seloq is XXXX
                       if(now > DELAY_MXD) then
                         OQ_zd <= ddr_data after DELAY_MXD;
                       end if;
   
        end case;

     end if; 

  end process prcs_OQ_mux;
----------------------------------------------------------------------
-----------    Instant X_PLG  --------------------------------------
----------------------------------------------------------------------
  INST_X_PLG : X_PLG
  generic map (
      SRTYPE => SRTYPE,
      INIT_LOADCNT => INIT_LOADCNT
     )
  port map (
      LOAD       => loadint,

      C23        => c23,
      C45        => c45,
      C67        => c67,
      CLK        => C_dly,
      CLKDIV     => CLKDIV_dly,
      GSR        => GSR_dly,
      RST        => SR_dly,
      SEL        => sel
      );

--###################################################################
--#####           Set value of the counter in X_PLG             ##### 
--###################################################################
  prcs_plg_plgcnt:process
  begin
     wait for 10 ps;
     case plgcnt is
        when "00100" =>
                 c23<='0'; c45<='0'; c67<='0'; sel<="00";
        when "00110" =>
                 c23<='1'; c45<='0'; c67<='0'; sel<="00";
        when "01000" =>
                 c23<='0'; c45<='0'; c67<='0'; sel<="01";
        when "01010" =>
                 c23<='0'; c45<='1'; c67<='0'; sel<="01";
        when "10010" =>
                 c23<='0'; c45<='0'; c67<='0'; sel<="00";
        when "10011" =>
                 c23<='1'; c45<='0'; c67<='0'; sel<="00";
        when "10100" =>
                 c23<='0'; c45<='0'; c67<='0'; sel<="01";
        when "10101" =>
                 c23<='0'; c45<='1'; c67<='0'; sel<="01";
        when "10110" =>
                 c23<='0'; c45<='0'; c67<='0'; sel<="10";
        when "10111" =>
                 c23<='0'; c45<='0'; c67<='1'; sel<="10";
        when "11000" =>
                 c23<='0'; c45<='0'; c67<='0'; sel<="11";
        when others =>
                assert FALSE 
                report "WARNING : DATA_WIDTH or DATA_RATE has illegal values."
                severity Warning;
     end case;
    wait;
  end process prcs_plg_plgcnt;
         

--####################################################################

--####################################################################
--#####                   TIMING CHECKS & OUTPUT                 #####
--####################################################################
  prcs_output:process(OQ_zd, LOAD_zd, SHIFTOUT1_zd, SHIFTOUT2_zd)
  begin
      OQ   <= OQ_zd after SWALLOW_PULSE;
      LOAD <= LOAD_zd;
      SHIFTOUT1 <= SHIFTOUT1_zd;
      SHIFTOUT2 <= SHIFTOUT2_zd;
  end process prcs_output;


end X_IOOUT_V;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;


library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.VPACKAGE.all;
use simprim.vcomponents.all;

entity X_IOT is

  generic(

         DATA_RATE_TQ		: string;
         TRISTATE_WIDTH		: integer	:= 1;
         DDR_CLK_EDGE		: string	:= "SAME_EDGE";
         INIT_TQ		: bit		:= '0';
         INIT_TRANK1		: bit_vector(3 downto 0) := "0000";
         SRVAL_TQ		: bit		:= '1';

         SRTYPE			: string	:= "ASYNC";

         TimingChecksOn		: boolean	:= true;
         InstancePath		: string	:= "*";
         Xon			: boolean	:= true;
         MsgOn			: boolean	:= false;


      tipd_C                    : VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_CLKDIV               : VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_GSR                  : VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_LOAD                 : VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_REV                  : VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_SR                   : VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_T1                   : VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_T2                   : VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_T3                   : VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_T4                   : VitalDelayType01 := (0.0 ns, 0.0 ns);
      tipd_TCE                  : VitalDelayType01 := (0.0 ns, 0.0 ns);

--  VITAL input Pin path delay variables


--  VITAL clk-to-output path delay variables

--  VITAL async rest-to-output path delay variables

--  VITAL async set-to-output path delay variables

--  VITAL GSR-to-output path delay variable


--  VITAL ticd & tisd variables

      ticd_C                    : VitalDelayType := 0.000 ns;
      ticd_CLKDIV               : VitalDelayType := 0.000 ns;
      tisd_GSR                  : VitalDelayType := 0.000 ns;
      tisd_LOAD                 : VitalDelayType := 0.000 ns;
      tisd_REV                  : VitalDelayType := 0.000 ns;
      tisd_SR                    : VitalDelayType := 0.000 ns;
      tisd_T1                   : VitalDelayType := 0.000 ns;
      tisd_T2                   : VitalDelayType := 0.000 ns;
      tisd_T3                   : VitalDelayType := 0.000 ns;
      tisd_T4                   : VitalDelayType := 0.000 ns;
      tisd_TCE                  : VitalDelayType := 0.000 ns;

--  VITAL Setup/Hold delay variables

-- VITAL pulse width variables
      tpw_CLK_posedge	: VitalDelayType := 0.0 ns;
      tpw_GSR_posedge	: VitalDelayType := 0.0 ns;
      tpw_REV_posedge	: VitalDelayType := 0.0 ns;
      tpw_SR_posedge	: VitalDelayType := 0.0 ns;

-- VITAL period variables
      tperiod_CLK_posedge	: VitalDelayType := 0.0 ns;

-- VITAL recovery time variables
      trecovery_GSR_CLK_negedge_posedge : VitalDelayType := 0.0 ns;
      trecovery_REV_CLK_negedge_posedge   : VitalDelayType := 0.0 ns;
      trecovery_SR_CLK_negedge_posedge   : VitalDelayType := 0.0 ns;

-- VITAL removal time variables
      tremoval_GSR_CLK_negedge_posedge  : VitalDelayType := 0.0 ns;
      tremoval_REV_CLK_negedge_posedge    : VitalDelayType := 0.0 ns;
      tremoval_SR_CLK_negedge_posedge    : VitalDelayType := 0.0 ns
      );

  port(
      TQ		: out std_ulogic;

      C			: in std_ulogic;
      CLKDIV		: in std_ulogic;
      GSR		: in std_ulogic; -- main
      LOAD		: in std_ulogic;
      REV	        : in std_ulogic;
      SR	        : in std_ulogic;
      T1		: in std_ulogic;
      T2		: in std_ulogic;
      T3		: in std_ulogic;
      T4		: in std_ulogic;
      TCE		: in std_ulogic
    );

  attribute VITAL_LEVEL0 of
    X_IOT : entity is true;

end X_IOT;

architecture X_IOT_V OF X_IOT is

--  attribute VITAL_LEVEL0 of
--    X_IOT_V : architecture is true;


  constant GSR_PULSE_TIME       : time       := 1 ns; 

  constant DELAY_FFD            : time       := 1 ps; 
  constant DELAY_MXD	        : time       := 1  ps;
  constant DELAY_ZERO	        : time       := 0  ps;
  constant DELAY_ONE	        : time       := 1  ps;
  constant SWALLOW_PULSE	: time       := 2  ps;

  constant MAX_DATAWIDTH	: integer    := 4;

  signal C_ipd			: std_ulogic := 'X';
  signal CLKDIV_ipd		: std_ulogic := 'X';
  signal GSR_ipd		: std_ulogic := 'X';
  signal LOAD_ipd		: std_ulogic := 'X';
  signal T1_ipd			: std_ulogic := 'X';
  signal T2_ipd			: std_ulogic := 'X';
  signal T3_ipd			: std_ulogic := 'X';
  signal T4_ipd			: std_ulogic := 'X';
  signal TCE_ipd	        : std_ulogic := 'X';
  signal REV_ipd	        : std_ulogic := 'X';
  signal SR_ipd		        : std_ulogic := 'X';

  signal C_dly			: std_ulogic := 'X';
  signal CLKDIV_dly		: std_ulogic := 'X';
  signal GSR_dly		: std_ulogic := 'X';
  signal LOAD_dly		: std_ulogic := 'X';
  signal T1_dly			: std_ulogic := 'X';
  signal T2_dly			: std_ulogic := 'X';
  signal T3_dly			: std_ulogic := 'X';
  signal T4_dly			: std_ulogic := 'X';
  signal TCE_dly	        : std_ulogic := 'X';
  signal REV_dly	        : std_ulogic := 'X';
  signal SR_dly		        : std_ulogic := 'X';

  signal TQ_zd			: std_ulogic := TO_X01(INIT_TQ);

  signal AttrDataRateTQ		: std_logic_vector(1 downto 0) := (others => 'X');
  signal AttrTriStateWidth	: std_logic_vector(1 downto 0) := (others => 'X');
  signal AttrDdrClkEdge		: std_ulogic := 'X';

  signal AttrSRtype		: std_logic_vector(1 downto 0) := (others => '1');

  signal t1r			: std_ulogic := 'X';
  signal t2r			: std_ulogic := 'X';
  signal t3r			: std_ulogic := 'X';
  signal t4r			: std_ulogic := 'X';

  signal qt1			: std_ulogic := 'X';
  signal qt2			: std_ulogic := 'X';
  signal qt2n			: std_ulogic := 'X';

  signal data1			: std_ulogic := 'X';
  signal data2			: std_ulogic := 'X';

  signal sdata_edge		: std_ulogic := 'X';
  signal odata_edge		: std_ulogic := 'X';
  signal ddr_data		: std_ulogic := 'X';

  signal C2p			: std_ulogic := 'X';
  signal C3			: std_ulogic := 'X';

  signal tqsel			: std_logic_vector(6 downto 0) := (others => 'X');
  signal tqsr			: std_ulogic := 'X';
  signal tqrev			: std_ulogic := 'X';

  signal sel			: std_logic_vector(4 downto 0) := (others => 'X');

begin

  ---------------------
  --  INPUT PATH DELAYs
  --------------------

  WireDelay : block
  begin
    VitalWireDelay (C_ipd,        C,        tipd_C);
    VitalWireDelay (CLKDIV_ipd,   CLKDIV,   tipd_CLKDIV);
    VitalWireDelay (GSR_ipd,      GSR,      tipd_GSR);
    VitalWireDelay (LOAD_ipd,     LOAD,     tipd_LOAD);
    VitalWireDelay (T1_ipd,       T1,       tipd_T1);
    VitalWireDelay (T2_ipd,       T2,       tipd_T2);
    VitalWireDelay (T3_ipd,       T3,       tipd_T3);
    VitalWireDelay (T4_ipd,       T4,       tipd_T4);
    VitalWireDelay (TCE_ipd,      TCE,      tipd_TCE);
    VitalWireDelay (REV_ipd,      REV,      tipd_REV);
    VitalWireDelay (SR_ipd,       SR,       tipd_SR);
  end block;

  SignalDelay : block
  begin
    VitalSignalDelay (C_dly,        C_ipd,        ticd_C);
    VitalSignalDelay (CLKDIV_dly,   CLKDIV_ipd,   ticd_CLKDIV);
    VitalSignalDelay (GSR_dly,      GSR_ipd,      tisd_GSR);
    VitalSignalDelay (LOAD_dly,     LOAD_ipd,     tisd_LOAD);
    VitalSignalDelay (T1_dly,       T1_ipd,       tisd_T1);
    VitalSignalDelay (T2_dly,       T2_ipd,       tisd_T2);
    VitalSignalDelay (T3_dly,       T3_ipd,       tisd_T3);
    VitalSignalDelay (T4_dly,       T4_ipd,       tisd_T4);
    VitalSignalDelay (TCE_dly,      TCE_ipd,      tisd_TCE);
    VitalSignalDelay (SR_dly,       SR_ipd,       tisd_SR);
    VitalSignalDelay (REV_dly,      REV_ipd,      tisd_REV);
  end block;

  --------------------
  --  BEHAVIOR SECTION
  --------------------


--####################################################################
--#####                     Initialize                           #####
--####################################################################
  prcs_init:process
  variable AttrDataRateTQ_var		: std_logic_vector(1 downto 0) := (others => 'X');
  variable AttrTriStateWidth_var	: std_logic_vector(1 downto 0) := (others => 'X');
  variable AttrDdrClkEdge_var		: std_ulogic := 'X';

  begin

      ------------------ DATA_RATE_TQ validity check ------------------
-- FP check with Paul
      if((DATA_RATE_TQ = "BUF") or (DATA_RATE_TQ = "buf")) then
         AttrDataRateTQ_var := "00";
      elsif((DATA_RATE_TQ = "SDR") or (DATA_RATE_TQ = "sdr")) then
         AttrDataRateTQ_var := "01";
      elsif((DATA_RATE_TQ = "DDR") or (DATA_RATE_TQ = "ddr")) then
         AttrDataRateTQ_var := "10";
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Warning ",
             GenericName => " DATA_RATE_TQ ",
             EntityName => "/X_IOOUT",
             GenericValue => DATA_RATE_TQ,
             Unit => "",
             ExpectedValueMsg => " The legal values for this attribute are ",
             ExpectedGenericValue => " BUF, SDR or DDR. ",
             TailMsg => "",
             MsgSeverity => Failure
         );
      end if;


      ------------------ TRISTATE_WIDTH validity check ------------------
      if((TRISTATE_WIDTH = 1) or (TRISTATE_WIDTH = 2) or  (TRISTATE_WIDTH = 4)) then
         case TRISTATE_WIDTH is
            when   1  =>  AttrTriStateWidth_var := "00";
            when   2  =>  AttrTriStateWidth_var := "01";
            when   4  =>  AttrTriStateWidth_var := "10";
            when others  =>
                   null;
         end case;
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Warning ",
             GenericName => " TRISTATE_WIDTH ",
             EntityName => "/X_IOT",
             GenericValue => TRISTATE_WIDTH,
             Unit => "",
             ExpectedValueMsg => " The legal values for this attribute are ",
             ExpectedGenericValue => " 1, 2 or 4 ",
             TailMsg => "",
             MsgSeverity => Failure
         );
      end if;

      ------------ TRISTATE_WIDTH /DATA_RATE combination check ------------
-- CR 458156 -- enabled TRISTATE_WIDTH to be 1 in DDR mode.
      if((DATA_RATE_TQ = "DDR") or (DATA_RATE_TQ = "ddr")) then
         case (TRISTATE_WIDTH) is
             when 1|2|4  => null;
             when others       =>
                GenericValueCheckMessage
                (  HeaderMsg  => " Attribute Syntax Warning ",
                   GenericName => " TRISTATE_WIDTH ",
                   EntityName => "/X_IOT",
                   GenericValue => TRISTATE_WIDTH,
                   Unit => "",
                   ExpectedValueMsg => " The legal values for this attribute in DDR mode are ",
                   ExpectedGenericValue => "1, 2 or 4",
                   TailMsg => "",
                   MsgSeverity => Failure
                );
          end case;
      end if;

      if((DATA_RATE_TQ = "SDR") or (DATA_RATE_TQ = "sdr")) then
         case (TRISTATE_WIDTH) is
             when 1  => null;
             when others       =>
                GenericValueCheckMessage
                (  HeaderMsg  => " Attribute Syntax Warning ",
                   GenericName => " TRISTATE_WIDTH ",
                   EntityName => "/X_IOT",
                   GenericValue => TRISTATE_WIDTH,
                   Unit => "",
                   ExpectedValueMsg => " The legal value for this attribute in SDR mode is",
                   ExpectedGenericValue => " 1. ",
                   TailMsg => "",
                   MsgSeverity => Failure
                );
          end case;
      end if;

      if((DATA_RATE_TQ = "BUF") or (DATA_RATE_TQ = "buf")) then
         case (TRISTATE_WIDTH) is
             when 1  => null;
             when others       =>
                GenericValueCheckMessage
                (  HeaderMsg  => " Attribute Syntax Warning ",
                   GenericName => " TRISTATE_WIDTH ",
                   EntityName => "/X_IOT",
                   GenericValue => TRISTATE_WIDTH,
                   Unit => "",
                   ExpectedValueMsg => " The legal value for this attribute in BUF mode is",
                   ExpectedGenericValue => " 1. ",
                   TailMsg => "",
                   MsgSeverity => Failure
                );
          end case;
      end if;

      ------------------ DDR_CLK_EDGE validity check ------------------

      if((DDR_CLK_EDGE = "SAME_EDGE") or (DDR_CLK_EDGE = "same_edge")) then
         AttrDdrClkEdge_var := '1';
      elsif((DDR_CLK_EDGE = "OPPOSITE_EDGE") or (DDR_CLK_EDGE = "opposite_edge")) then
         AttrDdrClkEdge_var := '0';
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Warning ",
             GenericName => " DDR_CLK_EDGE ",
             EntityName => "/X_IOT",
             GenericValue => DDR_CLK_EDGE,
             Unit => "",
             ExpectedValueMsg => " The legal values for this attribute are ",
             ExpectedGenericValue => " SAME_EDGE or OPPOSITE_EDGE ",
             TailMsg => "",
             MsgSeverity => Failure
         );
      end if;
      ------------------ DATA_RATE validity check ------------------
      if((SRTYPE = "ASYNC") or (SRTYPE = "async")) then
         AttrSRtype  <= (others => '1');
      elsif((SRTYPE = "SYNC") or (SRTYPE = "sync")) then
         AttrSRtype  <= (others => '0');
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Warning ",
             GenericName => " SRTYPE ",
             EntityName => "/X_IOT",
             GenericValue => SRTYPE,
             Unit => "",
             ExpectedValueMsg => " The legal values for this attribute are ",
             ExpectedGenericValue => " ASYNC or SYNC. ",
             TailMsg => "",
             MsgSeverity => ERROR
         );
      end if;
---------------------------------------------------------------------
     AttrDataRateTQ	<= AttrDataRateTQ_var;
     AttrTriStateWidth	<= AttrTriStateWidth_var;
     AttrDdrClkEdge	<= AttrDdrClkEdge_var;
     wait;
  end process prcs_init;
--###################################################################
--#####                   Concurrent exe                        #####
--###################################################################
   C2p    <= (C_dly and AttrDdrClkEdge) or 
             ((not C_dly) and (not AttrDdrClkEdge)); 
   C3     <= not C2p;

   tqsel  <= TCE & AttrDataRateTQ & AttrTriStateWidth & tqsr & tqrev;

   sel    <= load &  AttrDataRateTQ & AttrTriStateWidth;

   tqsr    <= ((AttrSRtype(1) and SR_dly and not (TO_X01(SRVAL_TQ)))
                               or
                (AttrSRtype(1) and REV_dly and (TO_X01(SRVAL_TQ))));

   tqrev   <= ((AttrSRtype(1) and SR_dly and (TO_X01(SRVAL_TQ)))
                               or
                (AttrSRtype(1) and REV_dly and not (TO_X01(SRVAL_TQ))));

--###################################################################
--#####                        qt1 reg                          #####
--###################################################################
  prcs_qt1_reg:process(C_dly, GSR_dly, REV_dly, SR_dly)
  variable qt1_var    : std_ulogic := TO_X01(INIT_TQ);
  variable FIRST_TIME : boolean    := true;
  begin
     if((GSR_dly = '1') or (FIRST_TIME)) then
         qt1_var    :=  TO_X01(INIT_TQ);
         FIRST_TIME := false;
     elsif(GSR_dly = '0') then
        case AttrSRtype(1) is
           when '1' => 
           --------------- // async SET/RESET
                   if((SR_dly = '1') and (not ((REV_dly = '1') and (TO_X01(SRVAL_TQ) = '1')))) then
                      qt1_var  :=  TO_X01(SRVAL_TQ);
                   elsif(REV_dly = '1') then
                      qt1_var  :=  not TO_X01(SRVAL_TQ);
                   elsif((SR_dly = '0') and (REV_dly = '0')) then
                      if(TCE_dly = '1') then
                         if(rising_edge(C_dly)) then
                            qt1_var := data1;
                         end if;
                      end if;
                   end if;

           when '0' => 
           --------------- // sync SET/RESET
                   if(rising_edge(C_dly)) then
                      if((SR_dly = '1') and (not ((REV_dly = '1') and (TO_X01(SRVAL_TQ) = '1')))) then
                         qt1_var  :=  TO_X01(SRVAL_TQ);
                      elsif(REV_dly = '1') then
                         qt1_var  :=  not TO_X01(SRVAL_TQ);
                      elsif((SR_dly = '0') and (REV_dly = '0')) then
                         if(TCE_dly = '1') then
                            qt1_var := data1;
                         end if;
                      end if;
                   end if;

           when others =>
                   null;
                        
        end case;
     end if;

     qt1  <= qt1_var  after DELAY_FFD;

  end process prcs_qt1_reg;
--###################################################################
--#####                        qt2 reg                          #####
--###################################################################
  prcs_qt2_reg:process(C2p, GSR_dly, REV_dly, SR_dly)
  variable qt2_var    : std_ulogic := TO_X01(INIT_TQ);
  variable FIRST_TIME : boolean    := true;
  begin
     if((GSR_dly = '1') or (FIRST_TIME)) then
         qt2_var    :=  TO_X01(INIT_TQ);
         FIRST_TIME := false;
     elsif(GSR_dly = '0') then
        case AttrSRtype(1) is
           when '1' => 
           --------------- // async SET/RESET
                   if((SR_dly = '1') and (not ((REV_dly = '1') and (TO_X01(SRVAL_TQ) = '1')))) then
                      qt2_var  :=  TO_X01(SRVAL_TQ);
                   elsif(REV_dly = '1') then
                      qt2_var  :=  not TO_X01(SRVAL_TQ);
                   elsif((SR_dly = '0') and (REV_dly = '0')) then
                      if(TCE_dly = '1') then
                         if(rising_edge(C2p)) then
                            qt2_var := data2;
                         end if;
                      end if;
                   end if;

           when '0' => 
           --------------- // sync SET/RESET
                   if(rising_edge(C2p)) then
                      if((SR_dly = '1') and (not ((REV_dly = '1') and (TO_X01(SRVAL_TQ) = '1')))) then
                         qt2_var  :=  TO_X01(SRVAL_TQ);
                      elsif(REV_dly = '1') then
                         qt2_var  :=  not TO_X01(SRVAL_TQ);
                      elsif((SR_dly = '0') and (REV_dly = '0')) then
                         if(TCE_dly = '1') then
                            qt2_var := data2;
                         end if;
                      end if;
                   end if;

           when others =>
                   null;
                        
        end case;
     end if;

     qt2  <= qt2_var  after DELAY_FFD;

  end process prcs_qt2_reg;

--###################################################################
--#####                        qt2n reg                          #####
--###################################################################
  prcs_qt2n_reg:process(C3, GSR_dly, REV_dly, SR_dly)
  variable qt2n_var   : std_ulogic := TO_X01(INIT_TQ);
  variable FIRST_TIME : boolean    := true;
  begin
     if((GSR_dly = '1') or (FIRST_TIME)) then
         qt2n_var    :=  TO_X01(INIT_TQ);
         FIRST_TIME := false;
     elsif(GSR_dly = '0') then
        case AttrSRtype(1) is
           when '1' => 
           --------------- // async SET/RESET
                   if((SR_dly = '1') and (not ((REV_dly = '1') and (TO_X01(SRVAL_TQ) = '1')))) then
                      qt2n_var  :=  TO_X01(SRVAL_TQ);
                   elsif(REV_dly = '1') then
                      qt2n_var  :=  not TO_X01(SRVAL_TQ);
                   elsif((SR_dly = '0') and (REV_dly = '0')) then
                      if(TCE_dly = '1') then
                         if(rising_edge(C3)) then
                            qt2n_var := qt2;
                         end if;
                      end if;
                   end if;

           when '0' => 
           --------------- // sync SET/RESET
                   if(rising_edge(C3)) then
                      if((SR_dly = '1') and (not ((REV_dly = '1') and (TO_X01(SRVAL_TQ) = '1')))) then
                         qt2n_var  :=  TO_X01(SRVAL_TQ);
                      elsif(REV_dly = '1') then
                         qt2n_var  :=  not TO_X01(SRVAL_TQ);
                      elsif((SR_dly = '0') and (REV_dly = '0')) then
                         if(TCE_dly = '1') then
                            qt2n_var := qt2;
                         end if;
                      end if;
                   end if;

           when others =>
                   null;
                        
        end case;
     end if;

     qt2n  <= qt2n_var  after DELAY_FFD;

  end process prcs_qt2n_reg;

--###################################################################
--#####               t1r, t2r, t3r and tr4                     #####
--###################################################################
  prcs_t1rt2rt3rt4r_rnk1:process(CLKDIV_dly, GSR_dly, SR_dly)
  variable t1r_var    : std_ulogic := TO_X01(INIT_TRANK1(0));
  variable t2r_var    : std_ulogic := TO_X01(INIT_TRANK1(1));
  variable t3r_var    : std_ulogic := TO_X01(INIT_TRANK1(2));
  variable t4r_var    : std_ulogic := TO_X01(INIT_TRANK1(3));
  variable FIRST_TIME : boolean    := true;

  begin
     if((GSR_dly = '1') or (FIRST_TIME)) then
         t1r_var    := TO_X01(INIT_TRANK1(0));
         t2r_var    := TO_X01(INIT_TRANK1(1));
         t3r_var    := TO_X01(INIT_TRANK1(2));
         t4r_var    := TO_X01(INIT_TRANK1(3));
         FIRST_TIME := false;
     elsif(GSR_dly = '0') then
        case AttrSRtype(1) is
           when '1' => 
           --------- // async SET/RESET  -- Not full featured FFs
                   if(SR_dly = '1') then
                      t1r_var  := '0';
                      t2r_var  := '0';
                      t3r_var  := '0';
                      t4r_var  := '0';
                   elsif(SR_dly = '0') then
                      if(rising_edge(CLKDIV_dly)) then
                         t1r_var  := T1_dly;
                         t2r_var  := T2_dly;
                         t3r_var  := T3_dly;
                         t4r_var  := T4_dly;
                      end if;
                   end if;

           when '0' => 
           --------- // sync SET/RESET  -- Not full featured FFs
                   if(rising_edge(C_dly)) then
                      if(SR_dly = '1') then
                         t1r_var  := '0';
                         t2r_var  := '0';
                         t3r_var  := '0';
                         t4r_var  := '0';
                      elsif(SR_dly = '0') then
                         t1r_var  := T1_dly;
                         t2r_var  := T2_dly;
                         t3r_var  := T3_dly;
                         t4r_var  := T4_dly;
                      end if;
                   end if;

           when others =>
                   null;
                        
        end case;
     end if;

     t1r  <= t1r_var  after DELAY_FFD;
     t2r  <= t2r_var  after DELAY_FFD;
     t3r  <= t3r_var  after DELAY_FFD;
     t4r  <= t4r_var  after DELAY_FFD;

  end process prcs_t1rt2rt3rt4r_rnk1;

--###################################################################
--#####                Muxes for tristate outputs               ##### 
--###################################################################
  prcs_data1_mux:process(sel, T1_dly, t1r, t3r)
  begin
    if (now > GSR_PULSE_TIME) then
       case sel is
          when "00000" | "10000" | "X0000" |
               "00100" | "10100" | "X0100" |
               "01001" | "11001" =>
                   data1 <= T1_dly after DELAY_MXD;
          when "01010" =>
                   data1 <= t3r after DELAY_MXD;
          when "11010" =>
                   data1 <= t1r after DELAY_MXD;
-- CR 458156 -- allow/enabled TRISTATE_WIDTH to be 1 in DDR mode. No func change, but removed warnings,
          when "01000" | "11000" | "X1000" => 
          when others =>
                  assert FALSE 
                  report "WARNING : DATA_RATE_TQ and/or  TRISTATE_WIDTH have illegal values."
                  severity Warning;
       end case;
    end if;
  end process prcs_data1_mux;
---------------------------------------------------------------
  prcs_data2_mux:process(sel, T2_dly, t2r, t4r)
  begin
    if (now > GSR_PULSE_TIME) then
       case sel is
          when "00000" | "00100" | "10000" |
               "10100" | "X0000" | "X0100" |
               "00X00" | "10X00" | "X0X00" |
               "01001" | "11001"  | "X1001"  =>
                   data2 <= T2_dly after DELAY_MXD;
          when "01010" =>
                   data2 <= t4r after DELAY_MXD;
          when "11010" =>
                   data2 <= t2r after DELAY_MXD;
-- CR 458156 -- allow/enabled TRISTATE_WIDTH to be 1 in DDR mode. No func change, but removed warnings,
          when "01000" | "11000" | "X1000" => 
          when others =>
                  assert FALSE 
                  report "WARNING : DATA_RATE_TQ and/or  TRISTATE_WIDTH have illegal values."
                  severity Warning;
       end case;
    end if;
  end process prcs_data2_mux;

--###################################################################
--#####        sdata_edge                                      ######
--###################################################################
  prcs_sdata:process(C_dly, C3, qt1, qt2n)
  begin
     sdata_edge <= ((qt1 and C_dly) or (qt2n and C3)) after DELAY_MXD;
  end process prcs_sdata;

--###################################################################
--#####             odata_edge                                  #####
--###################################################################
  prcs_odata:process(C_dly, qt1, qt2)
  begin
     case C_dly is
           when '0' => 
                    odata_edge <= qt2 after DELAY_MXD;
           when '1' => 
                    odata_edge <= qt1 after DELAY_MXD;
           when others =>
                    odata_edge <= '0' after DELAY_ZERO;
     end case;
  end process prcs_odata;
--###################################################################
--#####                 ddr_data                               ######
--###################################################################
  prcs_ddrdata:process(ddr_data, sdata_edge, odata_edge, AttrDdrClkEdge)
  begin
     ddr_data <= ((odata_edge and (not AttrDdrClkEdge)) or 
                    (sdata_edge and AttrDdrClkEdge)) after DELAY_ONE;
  end process prcs_ddrdata;

---////////////////////////////////////////////////////////////////////
---                       Outputs
---////////////////////////////////////////////////////////////////////
  prcs_TQ_mux:process(tqsel, data1, ddr_data, qt1, GSR_dly)

  variable FIRST_TIME : boolean := true;

  begin
     if((GSR_dly = '1') or (FIRST_TIME)) then
       TQ_zd    <=  TO_X01(INIT_TQ);
       FIRST_TIME := false;
     elsif(GSR_dly = '0') then
        if((tqsel(5 downto 4) = "01") and (tqsel(1 downto 0) = "01")) then
           TQ_zd <= '1' after DELAY_ONE;
        elsif((tqsel(5 downto 4) = "10") and (tqsel(1 downto 0) = "01")) then
           TQ_zd <= '1' after DELAY_ONE;
        elsif((tqsel(5 downto 4) = "01") and (tqsel(1 downto 0) = "10")) then
           TQ_zd <= '0' after DELAY_ONE;
        elsif((tqsel(5 downto 4) = "10") and (tqsel(1 downto 0) = "10")) then
           TQ_zd <= '0' after DELAY_ONE;
        elsif((tqsel(5 downto 4) = "01") and (tqsel(1 downto 0) = "11")) then
           TQ_zd <= '0' after DELAY_ONE;
        elsif((tqsel(5 downto 4) = "10") and (tqsel(1 downto 0) = "11")) then
           TQ_zd <= '0' after DELAY_ONE;
        elsif(tqsel(5 downto 2) = "0000") then
           TQ_zd <= data1 after DELAY_ONE;
        else

           case tqsel is
--              when "-01--01" | "-10--01" =>
--                    TQ_zd <= '1' after DELAY_ONE;
--              when "-01--10" | "-10--10" | "-01--11" | "-10--11" =>
--                    TQ_zd <= '0' after DELAY_ONE;
--              when "-----11" =>
--                    TQ_zd <= '0' after DELAY_ONE;
--              when "-0000--" =>
--                    TQ_zd <= data1 after DELAY_ONE;
              when "0010000" |  "0100100" |  "0101000" =>
                    TQ_zd <= TQ_zd after DELAY_ONE;
              when "1010000" =>
                    TQ_zd <= qt1 after DELAY_ONE;
              when "1100100" | "1101000" =>
                    TQ_zd <= ddr_data after DELAY_ONE;
              when others =>
                    TQ_zd <= ddr_data after DELAY_ONE;
           end case;
        end if;
     end if;
  end process prcs_TQ_mux;
--####################################################################

--####################################################################
--#####                   TIMING CHECKS & OUTPUT                 #####
--####################################################################
  prcs_output:process(TQ_zd)
  begin
      TQ <= TQ_zd;
  end process prcs_output;


end X_IOT_V;


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;


library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.VPACKAGE.all;
use simprim.vcomponents.all;

----- CELL X_OSERDES -----
-- //////////////////////////////////////////////////////////// 
-- //////////////////////// X_OSERDES /////////////////////////
-- //////////////////////////////////////////////////////////// 

entity X_OSERDES is

  generic(

      TimingChecksOn : boolean := true;
      InstancePath   : string  := "*";
      Xon            : boolean := true;
      MsgOn          : boolean := true;
      LOC            : string  := "UNPLACED";

      tipd_CLK			: VitalDelayType01 := (0 ps, 0 ps);
      tipd_CLKDIV		: VitalDelayType01 := (0 ps, 0 ps);
      tipd_D1			: VitalDelayType01 := (0 ps, 0 ps);
      tipd_D2			: VitalDelayType01 := (0 ps, 0 ps);
      tipd_D3			: VitalDelayType01 := (0 ps, 0 ps);
      tipd_D4			: VitalDelayType01 := (0 ps, 0 ps);
      tipd_D5			: VitalDelayType01 := (0 ps, 0 ps);
      tipd_D6			: VitalDelayType01 := (0 ps, 0 ps);
      tipd_GSR			: VitalDelayType01 := (0 ps, 0 ps);
      tipd_REV			: VitalDelayType01 := (0 ps, 0 ps);
      tipd_SR			: VitalDelayType01 := (0 ps, 0 ps);
      tipd_SHIFTIN1		: VitalDelayType01 := (0 ps, 0 ps);
      tipd_SHIFTIN2		: VitalDelayType01 := (0 ps, 0 ps);
      tipd_OCE			: VitalDelayType01 := (0 ps, 0 ps);
      tipd_T1			: VitalDelayType01 := (0 ps, 0 ps);
      tipd_T2			: VitalDelayType01 := (0 ps, 0 ps);
      tipd_T3			: VitalDelayType01 := (0 ps, 0 ps);
      tipd_T4			: VitalDelayType01 := (0 ps, 0 ps);
      tipd_TCE			: VitalDelayType01 := (0 ps, 0 ps);

--  VITAL clk-to-output path delay variables
      tpd_CLK_OQ		: VitalDelayType01 := (100 ps, 100 ps);
      tpd_CLK_SHIFTOUT1		: VitalDelayType01 := (100 ps, 100 ps);
      tpd_CLK_SHIFTOUT2		: VitalDelayType01 := (100 ps, 100 ps);
      tpd_CLK_TQ		: VitalDelayType01 := (100 ps, 100 ps);
      tpd_T1_TQ		        : VitalDelayType01 := (100 ps, 100 ps);
      tbpd_T1_TQ_CLK	        : VitalDelayType01 := (100 ps, 100 ps);

--  VITAL async rest-to-output path delay variables
      tpd_REV_OQ		: VitalDelayType01 := (0 ps, 0 ps);
      tpd_REV_TQ		: VitalDelayType01 := (0 ps, 0 ps);
      tbpd_REV_TQ_CLKDIV        : VitalDelayType01 := (0 ps, 0 ps);
      tbpd_REV_OQ_CLKDIV        : VitalDelayType01 := (0 ps, 0 ps);


--  VITAL async set-to-output path delay variables
      tpd_SR_OQ			: VitalDelayType01 := (0 ps, 0 ps);
      tpd_SR_TQ			: VitalDelayType01 := (0 ps, 0 ps);
      tbpd_SR_TQ_CLKDIV        : VitalDelayType01 := (0 ps, 0 ps);
      tbpd_SR_OQ_CLKDIV        : VitalDelayType01 := (0 ps, 0 ps);

--  VITAL GSR-to-output path delay variable
      tpd_GSR_OQ		: VitalDelayType01 := (0 ps, 0 ps);
      tpd_GSR_TQ		: VitalDelayType01 := (0 ps, 0 ps);

--  VITAL ticd & tisd variables

      ticd_CLK			: VitalDelayType := 0.0 ps;
      ticd_CLKDIV		: VitalDelayType := 0.0 ps;
      tisd_D1_CLKDIV		: VitalDelayType := 0.0 ps;
      tisd_D2_CLKDIV		: VitalDelayType := 0.0 ps;
      tisd_D3_CLKDIV		: VitalDelayType := 0.0 ps;
      tisd_D4_CLKDIV		: VitalDelayType := 0.0 ps;
      tisd_D5_CLKDIV		: VitalDelayType := 0.0 ps;
      tisd_D6_CLKDIV		: VitalDelayType := 0.0 ps;
      tisd_GSR			: VitalDelayType := 0.0 ps;
      tisd_OCE_CLK		: VitalDelayType := 0.0 ps;
      tisd_REV_CLK		: VitalDelayType := 0.0 ps;
      tisd_REV_CLKDIV		: VitalDelayType := 0.0 ps;
      tisd_SHIFTIN1		: VitalDelayType := 0.0 ps;
      tisd_SHIFTIN2		: VitalDelayType := 0.0 ps;
      tisd_SR_CLK		: VitalDelayType := 0.0 ps;
      tisd_SR_CLKDIV		: VitalDelayType := 0.0 ps;
      tisd_T1_CLK		: VitalDelayType := 0.0 ps;
      tisd_T2_CLK		: VitalDelayType := 0.0 ps;
      tisd_T1_CLKDIV		: VitalDelayType := 0.0 ps;
      tisd_T2_CLKDIV		: VitalDelayType := 0.0 ps;
      tisd_T3_CLKDIV		: VitalDelayType := 0.0 ps;
      tisd_T4_CLKDIV		: VitalDelayType := 0.0 ps;
      tisd_TCE_CLK		: VitalDelayType := 0.0 ps;

--  VITAL Setup/Hold delay variables

      tsetup_D1_CLKDIV_posedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_D1_CLKDIV_negedge_posedge : VitalDelayType := 0.0 ps;
      thold_D1_CLKDIV_posedge_posedge  : VitalDelayType := 0.0 ps;
      thold_D1_CLKDIV_negedge_posedge  : VitalDelayType := 0.0 ps;

      tsetup_D2_CLKDIV_posedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_D2_CLKDIV_negedge_posedge : VitalDelayType := 0.0 ps;
      thold_D2_CLKDIV_posedge_posedge  : VitalDelayType := 0.0 ps;
      thold_D2_CLKDIV_negedge_posedge  : VitalDelayType := 0.0 ps;

      tsetup_D3_CLKDIV_posedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_D3_CLKDIV_negedge_posedge : VitalDelayType := 0.0 ps;
      thold_D3_CLKDIV_posedge_posedge  : VitalDelayType := 0.0 ps;
      thold_D3_CLKDIV_negedge_posedge  : VitalDelayType := 0.0 ps;

      tsetup_D4_CLKDIV_posedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_D4_CLKDIV_negedge_posedge : VitalDelayType := 0.0 ps;
      thold_D4_CLKDIV_posedge_posedge  : VitalDelayType := 0.0 ps;
      thold_D4_CLKDIV_negedge_posedge  : VitalDelayType := 0.0 ps;

      tsetup_D5_CLKDIV_posedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_D5_CLKDIV_negedge_posedge : VitalDelayType := 0.0 ps;
      thold_D5_CLKDIV_posedge_posedge  : VitalDelayType := 0.0 ps;
      thold_D5_CLKDIV_negedge_posedge  : VitalDelayType := 0.0 ps;

      tsetup_D6_CLKDIV_posedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_D6_CLKDIV_negedge_posedge : VitalDelayType := 0.0 ps;
      thold_D6_CLKDIV_posedge_posedge  : VitalDelayType := 0.0 ps;
      thold_D6_CLKDIV_negedge_posedge  : VitalDelayType := 0.0 ps;

      tsetup_T1_CLK_posedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_T1_CLK_negedge_posedge : VitalDelayType := 0.0 ps;
      thold_T1_CLK_posedge_posedge  : VitalDelayType := 0.0 ps;
      thold_T1_CLK_negedge_posedge  : VitalDelayType := 0.0 ps;

      tsetup_T1_CLK_posedge_negedge : VitalDelayType := 0.0 ps;
      tsetup_T1_CLK_negedge_negedge : VitalDelayType := 0.0 ps;
      thold_T1_CLK_posedge_negedge  : VitalDelayType := 0.0 ps;
      thold_T1_CLK_negedge_negedge  : VitalDelayType := 0.0 ps;

      tsetup_T1_CLKDIV_posedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_T1_CLKDIV_negedge_posedge : VitalDelayType := 0.0 ps;
      thold_T1_CLKDIV_posedge_posedge  : VitalDelayType := 0.0 ps;
      thold_T1_CLKDIV_negedge_posedge  : VitalDelayType := 0.0 ps;

      tsetup_T2_CLK_posedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_T2_CLK_negedge_posedge : VitalDelayType := 0.0 ps;
      thold_T2_CLK_posedge_posedge  : VitalDelayType := 0.0 ps;
      thold_T2_CLK_negedge_posedge  : VitalDelayType := 0.0 ps;

      tsetup_T2_CLK_posedge_negedge : VitalDelayType := 0.0 ps;
      tsetup_T2_CLK_negedge_negedge : VitalDelayType := 0.0 ps;
      thold_T2_CLK_posedge_negedge  : VitalDelayType := 0.0 ps;
      thold_T2_CLK_negedge_negedge  : VitalDelayType := 0.0 ps;

      tsetup_T2_CLKDIV_posedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_T2_CLKDIV_negedge_posedge : VitalDelayType := 0.0 ps;
      thold_T2_CLKDIV_posedge_posedge  : VitalDelayType := 0.0 ps;
      thold_T2_CLKDIV_negedge_posedge  : VitalDelayType := 0.0 ps;

      tsetup_T3_CLKDIV_posedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_T3_CLKDIV_negedge_posedge : VitalDelayType := 0.0 ps;
      thold_T3_CLKDIV_posedge_posedge  : VitalDelayType := 0.0 ps;
      thold_T3_CLKDIV_negedge_posedge  : VitalDelayType := 0.0 ps;

      tsetup_T4_CLKDIV_posedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_T4_CLKDIV_negedge_posedge : VitalDelayType := 0.0 ps;
      thold_T4_CLKDIV_posedge_posedge  : VitalDelayType := 0.0 ps;
      thold_T4_CLKDIV_negedge_posedge  : VitalDelayType := 0.0 ps;

      tsetup_OCE_CLK_posedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_OCE_CLK_negedge_posedge : VitalDelayType := 0.0 ps;
      thold_OCE_CLK_posedge_posedge  : VitalDelayType := 0.0 ps;
      thold_OCE_CLK_negedge_posedge  : VitalDelayType := 0.0 ps;

      tsetup_TCE_CLK_posedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_TCE_CLK_negedge_posedge : VitalDelayType := 0.0 ps;
      thold_TCE_CLK_posedge_posedge  : VitalDelayType := 0.0 ps;
      thold_TCE_CLK_negedge_posedge  : VitalDelayType := 0.0 ps;

      tsetup_REV_CLKDIV_posedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_REV_CLKDIV_negedge_posedge : VitalDelayType := 0.0 ps;
      thold_REV_CLKDIV_posedge_posedge  : VitalDelayType := 0.0 ps;
      thold_REV_CLKDIV_negedge_posedge  : VitalDelayType := 0.0 ps;

      tsetup_REV_CLKDIV_posedge_negedge : VitalDelayType := 0.0 ps;
      tsetup_REV_CLKDIV_negedge_negedge : VitalDelayType := 0.0 ps;
      thold_REV_CLKDIV_posedge_negedge  : VitalDelayType := 0.0 ps;
      thold_REV_CLKDIV_negedge_negedge  : VitalDelayType := 0.0 ps;

      tsetup_SR_CLKDIV_posedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_SR_CLKDIV_negedge_posedge : VitalDelayType := 0.0 ps;
      thold_SR_CLKDIV_posedge_posedge  : VitalDelayType := 0.0 ps;
      thold_SR_CLKDIV_negedge_posedge  : VitalDelayType := 0.0 ps;

      tsetup_SR_CLKDIV_posedge_negedge : VitalDelayType := 0.0 ps;
      tsetup_SR_CLKDIV_negedge_negedge : VitalDelayType := 0.0 ps;
      thold_SR_CLKDIV_posedge_negedge  : VitalDelayType := 0.0 ps;
      thold_SR_CLKDIV_negedge_negedge  : VitalDelayType := 0.0 ps;

-- VITAL pulse width variables
      tpw_CLK_posedge		: VitalDelayType := 0 ps;
      tpw_CLK_negedge		: VitalDelayType := 0 ps;
      tpw_CLKDIV_posedge	: VitalDelayType := 0 ps;
      tpw_CLKDIV_negedge	: VitalDelayType := 0 ps;
      tpw_GSR_posedge		: VitalDelayType := 0 ps;
      tpw_REV_posedge		: VitalDelayType := 0 ps;
      tpw_SR_posedge		: VitalDelayType := 0 ps;

-- VITAL period variables
      tperiod_CLK_posedge	: VitalDelayType := 0 ps;
      tperiod_CLKDIV_posedge	: VitalDelayType := 0 ps;

-- VITAL recovery time variables
      trecovery_GSR_CLK_negedge_posedge		: VitalDelayType := 0 ps;
      trecovery_GSR_CLKDIV_negedge_posedge	: VitalDelayType := 0 ps;
      trecovery_REV_CLK_negedge_posedge		: VitalDelayType := 0 ps;
      trecovery_REV_CLK_negedge_negedge		: VitalDelayType := 0 ps;
      trecovery_SR_CLK_negedge_posedge		: VitalDelayType := 0 ps;
      trecovery_SR_CLK_negedge_negedge		: VitalDelayType := 0 ps;
      trecovery_SR_CLKDIV_negedge_posedge	: VitalDelayType := 0 ps;

-- VITAL removal time variables
      tremoval_GSR_CLK_negedge_posedge		: VitalDelayType := 0 ps;
      tremoval_GSR_CLKDIV_negedge_posedge	: VitalDelayType := 0 ps;
      tremoval_REV_CLK_negedge_posedge		: VitalDelayType := 0 ps;
      tremoval_REV_CLK_negedge_negedge		: VitalDelayType := 0 ps;
      tremoval_SR_CLK_negedge_posedge		: VitalDelayType := 0 ps;
      tremoval_SR_CLK_negedge_negedge		: VitalDelayType := 0 ps;
      tremoval_SR_CLKDIV_negedge_posedge	: VitalDelayType := 0 ps;

      DDR_CLK_EDGE		: string	:= "SAME_EDGE";
      INIT_LOADCNT		: bit_vector(3 downto 0) := "0000";
      INIT_ORANK1		: bit_vector(5 downto 0) := "000000";
      INIT_ORANK2_PARTIAL	: bit_vector(3 downto 0) := "0000";
      INIT_TRANK1		: bit_vector(3 downto 0) := "0000";
      SERDES			: boolean	:= TRUE;
      SRTYPE			: string	:= "ASYNC";

      DATA_RATE_OQ	: string	:= "DDR";
      DATA_RATE_TQ	: string	:= "DDR";
      DATA_WIDTH	: integer	:= 4;
      INIT_OQ		: bit		:= '0';
      INIT_TQ		: bit		:= '0';
      SERDES_MODE	: string	:= "MASTER";
      SRVAL_OQ		: bit		:= '0';
      SRVAL_TQ		: bit		:= '0';
      TRISTATE_WIDTH	: integer	:= 4
      );

  port(
      OQ		: out std_ulogic;
      SHIFTOUT1		: out std_ulogic;
      SHIFTOUT2		: out std_ulogic;
      TQ		: out std_ulogic;

      CLK		: in std_ulogic;
      CLKDIV		: in std_ulogic;
      D1		: in std_ulogic;
      D2		: in std_ulogic;
      D3		: in std_ulogic;
      D4		: in std_ulogic;
      D5		: in std_ulogic;
      D6		: in std_ulogic;
      OCE		: in std_ulogic;
      REV	        : in std_ulogic;
      SHIFTIN1		: in std_ulogic;
      SHIFTIN2		: in std_ulogic;
      SR	        : in std_ulogic;
      T1		: in std_ulogic;
      T2		: in std_ulogic;
      T3		: in std_ulogic;
      T4		: in std_ulogic;
      TCE		: in std_ulogic
      );

  attribute VITAL_LEVEL0 of
    X_OSERDES : entity is true;

end X_OSERDES;

architecture X_OSERDES_V OF X_OSERDES is

--  attribute VITAL_LEVEL0 of
--    X_OSERDES_V : architecture is true;


component X_IOOUT
  generic(
         SERDES                 : boolean;
         SERDES_MODE            : string;
         DATA_RATE_OQ           : string;
         DATA_WIDTH             : integer;
         DDR_CLK_EDGE           : string;
         INIT_OQ                : bit;
         SRVAL_OQ               : bit;
         INIT_ORANK1            : bit_vector(5 downto 0);
         INIT_ORANK2_PARTIAL    : bit_vector(3 downto 0);
         INIT_LOADCNT           : bit_vector(3 downto 0);
         SRTYPE                 : string

    );
  port(
      OQ                : out std_ulogic;
      LOAD              : out std_ulogic;
      SHIFTOUT1         : out std_ulogic;
      SHIFTOUT2         : out std_ulogic;

      C                 : in std_ulogic;
      CLKDIV            : in std_ulogic;
      GSR               : in std_ulogic;
      D1                : in std_ulogic;
      D2                : in std_ulogic;
      D3                : in std_ulogic;
      D4                : in std_ulogic;
      D5                : in std_ulogic;
      D6                : in std_ulogic;
      OCE               : in std_ulogic;
      REV               : in std_ulogic;
      SR                : in std_ulogic;
      SHIFTIN1          : in std_ulogic;
      SHIFTIN2          : in std_ulogic
    );

end component;

component X_IOT
  generic(
      DATA_RATE_TQ           : string;
      TRISTATE_WIDTH         : integer;
      DDR_CLK_EDGE           : string;
      INIT_TQ                : bit;
      INIT_TRANK1            : bit_vector(3 downto 0);
      SRVAL_TQ               : bit;
      SRTYPE                 : string
    );
  port(
      TQ                : out std_ulogic;

      C                 : in std_ulogic;
      CLKDIV            : in std_ulogic;
      GSR               : in std_ulogic;
      LOAD              : in std_ulogic;
      REV               : in std_ulogic;
      SR                 : in std_ulogic;
      T1                : in std_ulogic;
      T2                : in std_ulogic;
      T3                : in std_ulogic;
      T4                : in std_ulogic;
      TCE               : in std_ulogic
    );

end component;

  constant SYNC_PATH_DELAY	: time := 100 ps;

  signal load_int		: std_ulogic := 'X';

  signal CLK_ipd                : std_ulogic := 'X';
  signal CLKDIV_ipd             : std_ulogic := 'X';
  signal D1_ipd                 : std_ulogic := 'X';
  signal D2_ipd                 : std_ulogic := 'X';
  signal D3_ipd                 : std_ulogic := 'X';
  signal D4_ipd                 : std_ulogic := 'X';
  signal D5_ipd                 : std_ulogic := 'X';
  signal D6_ipd                 : std_ulogic := 'X';
  signal GSR_ipd                : std_ulogic := 'X';
  signal OCE_ipd                : std_ulogic := 'X';
  signal REV_ipd                : std_ulogic := 'X';
  signal SR_ipd                  : std_ulogic := 'X';
  signal SHIFTIN1_ipd           : std_ulogic := 'X';
  signal SHIFTIN2_ipd           : std_ulogic := 'X';
  signal TCE_ipd                : std_ulogic := 'X';
  signal T1_ipd                 : std_ulogic := 'X';
  signal T2_ipd                 : std_ulogic := 'X';
  signal T3_ipd                 : std_ulogic := 'X';
  signal T4_ipd                 : std_ulogic := 'X';

  signal CLK_dly                : std_ulogic := 'X';
  signal CLKDIV_dly             : std_ulogic := 'X';
  signal D1_dly                 : std_ulogic := 'X';
  signal D2_dly                 : std_ulogic := 'X';
  signal D3_dly                 : std_ulogic := 'X';
  signal D4_dly                 : std_ulogic := 'X';
  signal D5_dly                 : std_ulogic := 'X';
  signal D6_dly                 : std_ulogic := 'X';
  signal GSR_dly                : std_ulogic := 'X';
  signal OCE_dly                : std_ulogic := 'X';
  signal REV_dly                : std_ulogic := 'X';
  signal SR_dly                  : std_ulogic := 'X';
  signal SHIFTIN1_dly           : std_ulogic := 'X';
  signal SHIFTIN2_dly           : std_ulogic := 'X';
  signal TCE_dly                : std_ulogic := 'X';
  signal T1_dly                 : std_ulogic := 'X';
  signal T2_dly                 : std_ulogic := 'X';
  signal T3_dly                 : std_ulogic := 'X';
  signal T4_dly                 : std_ulogic := 'X';

  signal CLKD                   : std_ulogic := 'X';
  signal CLKDIVD                : std_ulogic := 'X';

  signal OQ_zd                  : std_ulogic := 'X';
  signal SHIFTOUT1_zd           : std_ulogic := 'X';
  signal SHIFTOUT2_zd           : std_ulogic := 'X';
  signal TQ_zd                  : std_ulogic := 'X';

begin

  ---------------------
  --  INPUT PATH DELAYs
  --------------------

  WireDelay : block
  begin
    VitalWireDelay (CLK_ipd,      CLK,      tipd_CLK);
    VitalWireDelay (CLKDIV_ipd,   CLKDIV,   tipd_CLKDIV);
    VitalWireDelay (D1_ipd,       D1,       tipd_D1);
    VitalWireDelay (D2_ipd,       D2,       tipd_D2);
    VitalWireDelay (D3_ipd,       D3,       tipd_D3);
    VitalWireDelay (D4_ipd,       D4,       tipd_D4);
    VitalWireDelay (D5_ipd,       D5,       tipd_D5);
    VitalWireDelay (D6_ipd,       D6,       tipd_D6);
    VitalWireDelay (GSR_ipd,      GSR,      tipd_GSR);
    VitalWireDelay (OCE_ipd,      OCE,      tipd_OCE);
    VitalWireDelay (REV_ipd,      REV,      tipd_REV);
    VitalWireDelay (SR_ipd,       SR,       tipd_SR);
    VitalWireDelay (SHIFTIN1_ipd, SHIFTIN1, tipd_SHIFTIN1);
    VitalWireDelay (SHIFTIN2_ipd, SHIFTIN2, tipd_SHIFTIN2);
    VitalWireDelay (T1_ipd,       T1,       tipd_T1);
    VitalWireDelay (T2_ipd,       T2,       tipd_T2);
    VitalWireDelay (T3_ipd,       T3,       tipd_T3);
    VitalWireDelay (T4_ipd,       T4,       tipd_T4);
    VitalWireDelay (TCE_ipd,      TCE,      tipd_TCE);
  end block;

  SignalDelay : block
  begin
    VitalSignalDelay (CLKDIV_dly,   CLKDIV_ipd,   ticd_CLKDIV);
    VitalSignalDelay (CLK_dly,      CLK_ipd,      ticd_CLK);
    VitalSignalDelay (D1_dly,       D1_ipd,       tisd_D1_CLKDIV);
    VitalSignalDelay (D2_dly,       D2_ipd,       tisd_D2_CLKDIV);
    VitalSignalDelay (D3_dly,       D3_ipd,       tisd_D3_CLKDIV);
    VitalSignalDelay (D4_dly,       D4_ipd,       tisd_D4_CLKDIV);
    VitalSignalDelay (D5_dly,       D5_ipd,       tisd_D5_CLKDIV);
    VitalSignalDelay (D6_dly,       D6_ipd,       tisd_D6_CLKDIV);
    VitalSignalDelay (GSR_dly,      GSR_ipd,      tisd_GSR);
    VitalSignalDelay (OCE_dly,      OCE_ipd,      tisd_OCE_CLK);
    VitalSignalDelay (REV_dly,      REV_ipd,      tisd_REV_CLKDIV);
    VitalSignalDelay (SR_dly,       SR_ipd,       tisd_SR_CLKDIV);
    VitalSignalDelay (SHIFTIN1_dly, SHIFTIN1_ipd, tisd_SHIFTIN1);
    VitalSignalDelay (SHIFTIN2_dly, SHIFTIN2_ipd, tisd_SHIFTIN2);
    VitalSignalDelay (T1_dly,       T1_ipd,       tisd_T1_CLKDIV);
    VitalSignalDelay (T2_dly,       T2_ipd,       tisd_T2_CLKDIV);
    VitalSignalDelay (T3_dly,       T3_ipd,       tisd_T3_CLKDIV);
    VitalSignalDelay (T4_dly,       T4_ipd,       tisd_T4_CLKDIV);
    VitalSignalDelay (TCE_dly,      TCE_ipd,      tisd_TCE_CLK);
  end block;




--  Delay the clock 100 ps to match the HW
  CLKD    <= CLK_dly after 0 ps;
  CLKDIVD <= CLKDIV_dly after 0 ps;
------------------------------------------------------------------
-----------    Instant X_IOOUT  -----------------------------------
------------------------------------------------------------------
  INST_X_IOOUT: X_IOOUT
  generic map (
      SERDES			=> SERDES,
      SERDES_MODE		=> SERDES_MODE,
      DATA_RATE_OQ		=> DATA_RATE_OQ,
      DATA_WIDTH                => DATA_WIDTH,
      DDR_CLK_EDGE		=> DDR_CLK_EDGE,
      INIT_OQ			=> INIT_OQ,
      SRVAL_OQ			=> SRVAL_OQ,
      INIT_ORANK1		=> INIT_ORANK1,
      INIT_ORANK2_PARTIAL	=> INIT_ORANK2_PARTIAL,
      INIT_LOADCNT		=> INIT_LOADCNT,
      SRTYPE			=> SRTYPE
     )
  port map (
      OQ			=> OQ_zd,
      LOAD			=> LOAD_int,
      SHIFTOUT1			=> SHIFTOUT1_zd,
      SHIFTOUT2			=> SHIFTOUT2_zd,
      C				=> CLKD,
      CLKDIV			=> CLKDIVD,
      GSR			=> GSR_dly,
      D1			=> D1_dly,
      D2			=> D2_dly,
      D3			=> D3_dly,
      D4			=> D4_dly,
      D5			=> D5_dly,
      D6			=> D6_dly,
      OCE			=> OCE_dly,
      REV			=> REV_dly,
      SR			=> SR_dly,
      SHIFTIN1			=> SHIFTIN1_dly,
      SHIFTIN2			=> SHIFTIN2_dly
      );
------------------------------------------------------------------
-----------    Instant TRI_OUT  ----------------------------------
------------------------------------------------------------------
  INST_X_IOT: X_IOT
  generic map (
      DATA_RATE_TQ		=> DATA_RATE_TQ,
      TRISTATE_WIDTH		=> TRISTATE_WIDTH,
      DDR_CLK_EDGE		=> DDR_CLK_EDGE,
      INIT_TQ			=> INIT_TQ,
      INIT_TRANK1		=> INIT_TRANK1,
      SRVAL_TQ			=> SRVAL_TQ,
      SRTYPE			=> SRTYPE
     )
  port map (
      TQ			=> TQ_zd,

      C				=> CLKD,
      CLKDIV			=> CLKDIVD,
      GSR			=> GSR_dly,
      LOAD			=> LOAD_int,
      REV			=> REV_dly,
      SR			=> SR_dly,
      T1			=> T1_dly,
      T2			=> T2_dly,
      T3			=> T3_dly,
      T4			=> T4_dly,
      TCE			=> TCE_dly
      );

--####################################################################

--####################################################################
--#####                   TIMING CHECKS & OUTPUT                 #####
--####################################################################

  prcs_output:process
--  Pin Timing Violations (all input pins)
     variable Tviol_D1_CLKDIV_posedge : STD_ULOGIC := '0';
     variable  Tmkr_D1_CLKDIV_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_D2_CLKDIV_posedge : STD_ULOGIC := '0';
     variable  Tmkr_D2_CLKDIV_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_D3_CLKDIV_posedge : STD_ULOGIC := '0';
     variable  Tmkr_D3_CLKDIV_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_D4_CLKDIV_posedge : STD_ULOGIC := '0';
     variable  Tmkr_D4_CLKDIV_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_D5_CLKDIV_posedge : STD_ULOGIC := '0';
     variable  Tmkr_D5_CLKDIV_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_D6_CLKDIV_posedge : STD_ULOGIC := '0';
     variable  Tmkr_D6_CLKDIV_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_T1_CLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_T1_CLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_T1_CLK_negedge : STD_ULOGIC := '0';
     variable  Tmkr_T1_CLK_negedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_T2_CLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_T2_CLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_T2_CLK_negedge : STD_ULOGIC := '0';
     variable  Tmkr_T2_CLK_negedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_T1_CLKDIV_posedge : STD_ULOGIC := '0';
     variable  Tmkr_T1_CLKDIV_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_T2_CLKDIV_posedge : STD_ULOGIC := '0';
     variable  Tmkr_T2_CLKDIV_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_T3_CLKDIV_posedge : STD_ULOGIC := '0';
     variable  Tmkr_T3_CLKDIV_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_T4_CLKDIV_posedge : STD_ULOGIC := '0';
     variable  Tmkr_T4_CLKDIV_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_OCE_CLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_OCE_CLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_TCE_CLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_TCE_CLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_REV_CLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_REV_CLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_REV_CLK_negedge : STD_ULOGIC := '0';
     variable  Tmkr_REV_CLK_negedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_REV_CLKDIV_posedge : STD_ULOGIC := '0';
     variable  Tmkr_REV_CLKDIV_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_REV_CLKDIV_negedge : STD_ULOGIC := '0';
     variable  Tmkr_REV_CLKDIV_negedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_SR_CLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_SR_CLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_SR_CLK_negedge : STD_ULOGIC := '0';
     variable  Tmkr_SR_CLK_negedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_SR_CLKDIV_posedge : STD_ULOGIC := '0';
     variable  Tmkr_SR_CLKDIV_negedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_SR_CLKDIV_negedge : STD_ULOGIC := '0';
     variable  Tmkr_SR_CLKDIV_posedge : VitalTimingDataType := VitalTimingDataInit;

--  Output Pin glitch declaration
     variable  OQ_GlitchData : VitalGlitchDataType;
     variable  SHIFTOUT1_GlitchData : VitalGlitchDataType;
     variable  SHIFTOUT2_GlitchData : VitalGlitchDataType;
     variable  TQ_GlitchData : VitalGlitchDataType;
begin

--  Setup/Hold Check Violations (all input pins)

     if (TimingChecksOn) then
     VitalSetupHoldCheck
       (
         Violation      => Tviol_D1_CLKDIV_posedge,
         TimingData     => Tmkr_D1_CLKDIV_posedge,
         TestSignal     => D1_dly,
         TestSignalName => "D1",
         TestDelay      => tisd_D1_CLKDIV,
         RefSignal      => CLKDIV_dly,
         RefSignalName  => "CLKDIV",
         RefDelay       => ticd_CLKDIV,
         SetupHigh      => tsetup_D1_CLKDIV_posedge_posedge,
         SetupLow       => tsetup_D1_CLKDIV_negedge_posedge,
         HoldLow        => thold_D1_CLKDIV_posedge_posedge,
         HoldHigh       => thold_D1_CLKDIV_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_OSERDES",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Error
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_D2_CLKDIV_posedge,
         TimingData     => Tmkr_D2_CLKDIV_posedge,
         TestSignal     => D2_dly,
         TestSignalName => "D2",
         TestDelay      => tisd_D2_CLKDIV,
         RefSignal      => CLKDIV_dly,
         RefSignalName  => "CLKDIV",
         RefDelay       => ticd_CLKDIV,
         SetupHigh      => tsetup_D2_CLKDIV_posedge_posedge,
         SetupLow       => tsetup_D2_CLKDIV_negedge_posedge,
         HoldLow        => thold_D2_CLKDIV_posedge_posedge,
         HoldHigh       => thold_D2_CLKDIV_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_OSERDES",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Error
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_D3_CLKDIV_posedge,
         TimingData     => Tmkr_D3_CLKDIV_posedge,
         TestSignal     => D3_dly,
         TestSignalName => "D3",
         TestDelay      => tisd_D3_CLKDIV,
         RefSignal      => CLKDIV_dly,
         RefSignalName  => "CLKDIV",
         RefDelay       => ticd_CLKDIV,
         SetupHigh      => tsetup_D3_CLKDIV_posedge_posedge,
         SetupLow       => tsetup_D3_CLKDIV_negedge_posedge,
         HoldLow        => thold_D3_CLKDIV_posedge_posedge,
         HoldHigh       => thold_D3_CLKDIV_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_OSERDES",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Error
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_D4_CLKDIV_posedge,
         TimingData     => Tmkr_D4_CLKDIV_posedge,
         TestSignal     => D4_dly,
         TestSignalName => "D4",
         TestDelay      => tisd_D4_CLKDIV,
         RefSignal      => CLKDIV_dly,
         RefSignalName  => "CLKDIV",
         RefDelay       => ticd_CLKDIV,
         SetupHigh      => tsetup_D4_CLKDIV_posedge_posedge,
         SetupLow       => tsetup_D4_CLKDIV_negedge_posedge,
         HoldLow        => thold_D4_CLKDIV_posedge_posedge,
         HoldHigh       => thold_D4_CLKDIV_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_OSERDES",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Error
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_D5_CLKDIV_posedge,
         TimingData     => Tmkr_D5_CLKDIV_posedge,
         TestSignal     => D5_dly,
         TestSignalName => "D5",
         TestDelay      => tisd_D5_CLKDIV,
         RefSignal      => CLKDIV_dly,
         RefSignalName  => "CLKDIV",
         RefDelay       => ticd_CLKDIV,
         SetupHigh      => tsetup_D5_CLKDIV_posedge_posedge,
         SetupLow       => tsetup_D5_CLKDIV_negedge_posedge,
         HoldLow        => thold_D5_CLKDIV_posedge_posedge,
         HoldHigh       => thold_D5_CLKDIV_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_OSERDES",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Error
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_D6_CLKDIV_posedge,
         TimingData     => Tmkr_D6_CLKDIV_posedge,
         TestSignal     => D6_dly,
         TestSignalName => "D6",
         TestDelay      => tisd_D6_CLKDIV,
         RefSignal      => CLKDIV_dly,
         RefSignalName  => "CLKDIV",
         RefDelay       => ticd_CLKDIV,
         SetupHigh      => tsetup_D6_CLKDIV_posedge_posedge,
         SetupLow       => tsetup_D6_CLKDIV_negedge_posedge,
         HoldLow        => thold_D6_CLKDIV_posedge_posedge,
         HoldHigh       => thold_D6_CLKDIV_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_OSERDES",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Error
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_T1_CLK_posedge,
         TimingData     => Tmkr_T1_CLK_posedge,
         TestSignal     => T1_dly,
         TestSignalName => "T1",
         TestDelay      => tisd_T1_CLK,
         RefSignal      => CLK_dly,
         RefSignalName  => "CLK",
         RefDelay       => ticd_CLK,
         SetupHigh      => tsetup_T1_CLK_posedge_posedge,
         SetupLow       => tsetup_T1_CLK_negedge_posedge,
         HoldLow        => thold_T1_CLK_posedge_posedge,
         HoldHigh       => thold_T1_CLK_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_OSERDES",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Error
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_T2_CLK_posedge,
         TimingData     => Tmkr_T2_CLK_posedge,
         TestSignal     => T2_dly,
         TestSignalName => "T2",
         TestDelay      => tisd_T2_CLK,
         RefSignal      => CLK_dly,
         RefSignalName  => "CLK",
         RefDelay       => ticd_CLK,
         SetupHigh      => tsetup_T2_CLK_posedge_posedge,
         SetupLow       => tsetup_T2_CLK_negedge_posedge,
         HoldLow        => thold_T2_CLK_posedge_posedge,
         HoldHigh       => thold_T2_CLK_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_OSERDES",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Error
       );
-- CR 210819 ---------------------
     if(DATA_RATE_TQ = "DDR") then
        VitalSetupHoldCheck
          (
            Violation      => Tviol_T1_CLK_negedge,
            TimingData     => Tmkr_T1_CLK_negedge,
            TestSignal     => T1_dly,
            TestSignalName => "T1",
            TestDelay      => tisd_T1_CLK,
            RefSignal      => CLK_dly,
            RefSignalName  => "CLK",
            RefDelay       => ticd_CLK,
            SetupHigh      => tsetup_T1_CLK_posedge_negedge,
            SetupLow       => tsetup_T1_CLK_negedge_negedge,
            HoldLow        => thold_T1_CLK_posedge_negedge,
            HoldHigh       => thold_T1_CLK_negedge_negedge,
            CheckEnabled   => TRUE,
            RefTransition  => 'F',
            HeaderMsg      => InstancePath & "/X_OSERDES",
            Xon            => Xon,
            MsgOn          => MsgOn,
            MsgSeverity    => Error
          );
        VitalSetupHoldCheck
          (
            Violation      => Tviol_T2_CLK_negedge,
            TimingData     => Tmkr_T2_CLK_negedge,
            TestSignal     => T2_dly,
            TestSignalName => "T2",
            TestDelay      => tisd_T2_CLK,
            RefSignal      => CLK_dly,
            RefSignalName  => "CLK",
            RefDelay       => ticd_CLK,
            SetupHigh      => tsetup_T2_CLK_posedge_negedge,
            SetupLow       => tsetup_T2_CLK_negedge_negedge,
            HoldLow        => thold_T2_CLK_posedge_negedge,
            HoldHigh       => thold_T2_CLK_negedge_negedge,
            CheckEnabled   => TRUE,
            RefTransition  => 'F',
            HeaderMsg      => InstancePath & "/X_OSERDES",
            Xon            => Xon,
            MsgOn          => MsgOn,
            MsgSeverity    => Error
          );

     end if;

     VitalRecoveryRemovalCheck (
       Violation      => Tviol_REV_CLK_posedge,
       TimingData     => Tmkr_REV_CLK_posedge,
       TestSignal     => REV_dly,
       TestSignalName => "REV",
       TestDelay      => tisd_REV_CLK,
       RefSignal      => CLK_dly,
       RefSignalName  => "CLK",
       RefDelay       => ticd_CLK,
       Recovery       => trecovery_REV_CLK_negedge_posedge,
       Removal        => tremoval_REV_CLK_negedge_posedge,
       ActiveLow      => false,
       CheckEnabled   => TO_X01(GSR_dly) /= '1',
       RefTransition  => 'R',
       HeaderMsg      => InstancePath & "/X_OSERDES",
       Xon            => Xon,
       MsgOn          => true,
       MsgSeverity    => Warning
     );

     VitalRecoveryRemovalCheck (
       Violation      => Tviol_SR_CLK_posedge,
       TimingData     => Tmkr_SR_CLK_posedge,
       TestSignal     => SR_dly,
       TestSignalName => "SR",
       TestDelay      => tisd_SR_CLK,
       RefSignal      => CLK_dly,
       RefSignalName  => "CLK",
       RefDelay       => ticd_CLK,
       Recovery       => trecovery_SR_CLK_negedge_posedge,
       Removal        => tremoval_SR_CLK_negedge_posedge,
       ActiveLow      => false,
       CheckEnabled   => TO_X01(GSR_dly) /= '1',
       RefTransition  => 'R',
       HeaderMsg      => InstancePath & "/X_OSERDES",
       Xon            => Xon,
       MsgOn          => true,
       MsgSeverity    => Warning
     );
     if(DATA_RATE_TQ = "DDR") then
        VitalRecoveryRemovalCheck (
          Violation      => Tviol_REV_CLK_negedge,
          TimingData     => Tmkr_REV_CLK_negedge,
          TestSignal     => REV_dly,
          TestSignalName => "REV",
          TestDelay      => tisd_REV_CLK,
          RefSignal      => CLK_dly,
          RefSignalName  => "CLK",
          RefDelay       => ticd_CLK,
          Recovery       => trecovery_REV_CLK_negedge_negedge,
          Removal        => tremoval_REV_CLK_negedge_negedge,
          ActiveLow      => false,
          CheckEnabled   => TO_X01(GSR_dly) /= '1',
          RefTransition  => 'F',
          HeaderMsg      => InstancePath & "/X_OSERDES",
          Xon            => Xon,
          MsgOn          => true,
          MsgSeverity    => Warning
        );
        VitalRecoveryRemovalCheck (
          Violation      => Tviol_SR_CLK_negedge,
          TimingData     => Tmkr_SR_CLK_negedge,
          TestSignal     => SR_dly,
          TestSignalName => "SR",
          TestDelay      => tisd_SR_CLK,
          RefSignal      => CLK_dly,
          RefSignalName  => "CLK",
          RefDelay       => ticd_CLK,
          Recovery       => trecovery_SR_CLK_negedge_negedge,
          Removal        => tremoval_SR_CLK_negedge_negedge,
          ActiveLow      => false,
          CheckEnabled   => TO_X01(GSR_dly) /= '1',
          RefTransition  => 'F',
          HeaderMsg      => InstancePath & "/X_OSERDES",
          Xon            => Xon,
          MsgOn          => true,
          MsgSeverity    => Warning
        );
     end if;
---------------------------
     VitalSetupHoldCheck
       (
         Violation      => Tviol_T1_CLKDIV_posedge,
         TimingData     => Tmkr_T1_CLKDIV_posedge,
         TestSignal     => T1_dly,
         TestSignalName => "T1",
         TestDelay      => tisd_T1_CLKDIV,
         RefSignal      => CLKDIV_dly,
         RefSignalName  => "CLKDIV",
         RefDelay       => ticd_CLKDIV,
         SetupHigh      => tsetup_T1_CLKDIV_posedge_posedge,
         SetupLow       => tsetup_T1_CLKDIV_negedge_posedge,
         HoldLow        => thold_T1_CLKDIV_posedge_posedge,
         HoldHigh       => thold_T1_CLKDIV_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_OSERDES",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Error
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_T2_CLKDIV_posedge,
         TimingData     => Tmkr_T2_CLKDIV_posedge,
         TestSignal     => T2_dly,
         TestSignalName => "T2",
         TestDelay      => tisd_T2_CLKDIV,
         RefSignal      => CLKDIV_dly,
         RefSignalName  => "CLKDIV",
         RefDelay       => ticd_CLKDIV,
         SetupHigh      => tsetup_T2_CLKDIV_posedge_posedge,
         SetupLow       => tsetup_T2_CLKDIV_negedge_posedge,
         HoldLow        => thold_T2_CLKDIV_posedge_posedge,
         HoldHigh       => thold_T2_CLKDIV_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_OSERDES",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Error
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_T3_CLKDIV_posedge,
         TimingData     => Tmkr_T3_CLKDIV_posedge,
         TestSignal     => T3_dly,
         TestSignalName => "T3",
         TestDelay      => tisd_T3_CLKDIV,
         RefSignal      => CLKDIV_dly,
         RefSignalName  => "CLKDIV",
         RefDelay       => ticd_CLKDIV,
         SetupHigh      => tsetup_T3_CLKDIV_posedge_posedge,
         SetupLow       => tsetup_T3_CLKDIV_negedge_posedge,
         HoldLow        => thold_T3_CLKDIV_posedge_posedge,
         HoldHigh       => thold_T3_CLKDIV_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_OSERDES",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Error
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_T4_CLKDIV_posedge,
         TimingData     => Tmkr_T4_CLKDIV_posedge,
         TestSignal     => T4_dly,
         TestSignalName => "T4",
         TestDelay      => tisd_T4_CLKDIV,
         RefSignal      => CLKDIV_dly,
         RefSignalName  => "CLKDIV",
         RefDelay       => ticd_CLKDIV,
         SetupHigh      => tsetup_T4_CLKDIV_posedge_posedge,
         SetupLow       => tsetup_T4_CLKDIV_negedge_posedge,
         HoldLow        => thold_T4_CLKDIV_posedge_posedge,
         HoldHigh       => thold_T4_CLKDIV_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_OSERDES",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Error
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_OCE_CLK_posedge,
         TimingData     => Tmkr_OCE_CLK_posedge,
         TestSignal     => OCE_dly,
         TestSignalName => "OCE",
         TestDelay      => tisd_OCE_CLK,
         RefSignal      => CLK_dly,
         RefSignalName  => "CLK",
         RefDelay       => ticd_CLK,
         SetupHigh      => tsetup_OCE_CLK_posedge_posedge,
         SetupLow       => tsetup_OCE_CLK_negedge_posedge,
         HoldLow        => thold_OCE_CLK_posedge_posedge,
         HoldHigh       => thold_OCE_CLK_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_OSERDES",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Error
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_TCE_CLK_posedge,
         TimingData     => Tmkr_TCE_CLK_posedge,
         TestSignal     => TCE_dly,
         TestSignalName => "TCE",
         TestDelay      => tisd_TCE_CLK,
         RefSignal      => CLK_dly,
         RefSignalName  => "CLK",
         RefDelay       => ticd_CLK,
         SetupHigh      => tsetup_TCE_CLK_posedge_posedge,
         SetupLow       => tsetup_TCE_CLK_negedge_posedge,
         HoldLow        => thold_TCE_CLK_posedge_posedge,
         HoldHigh       => thold_TCE_CLK_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_OSERDES",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Error
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_SR_CLKDIV_posedge,
         TimingData     => Tmkr_SR_CLKDIV_posedge,
         TestSignal     => SR_dly,
         TestSignalName => "SR",
         TestDelay      => tisd_SR_CLKDIV,
         RefSignal      => CLKDIV_dly,
         RefSignalName  => "CLKDIV",
         RefDelay       => ticd_CLKDIV,
         SetupHigh      => tsetup_SR_CLKDIV_posedge_posedge,
         SetupLow       => tsetup_SR_CLKDIV_negedge_posedge,
         HoldLow        => thold_SR_CLKDIV_posedge_posedge,
         HoldHigh       => thold_SR_CLKDIV_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_OSERDES",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Error
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_SR_CLKDIV_negedge,
         TimingData     => Tmkr_SR_CLKDIV_negedge,
         TestSignal     => SR_dly,
         TestSignalName => "SR",
         TestDelay      => tisd_SR_CLKDIV,
         RefSignal      => CLKDIV_dly,
         RefSignalName  => "CLKDIV",
         RefDelay       => ticd_CLKDIV,
         SetupHigh      => tsetup_SR_CLKDIV_posedge_negedge,
         SetupLow       => tsetup_SR_CLKDIV_negedge_negedge,
         HoldLow        => thold_SR_CLKDIV_posedge_negedge,
         HoldHigh       => thold_SR_CLKDIV_negedge_negedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'F',
         HeaderMsg      => InstancePath & "/X_OSERDES",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Error
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_REV_CLKDIV_posedge,
         TimingData     => Tmkr_REV_CLKDIV_posedge,
         TestSignal     => REV_dly,
         TestSignalName => "REV",
         TestDelay      => tisd_REV_CLKDIV,
         RefSignal      => CLKDIV_dly,
         RefSignalName  => "CLKDIV",
         RefDelay       => ticd_CLKDIV,
         SetupHigh      => tsetup_REV_CLKDIV_posedge_posedge,
         SetupLow       => tsetup_REV_CLKDIV_negedge_posedge,
         HoldLow        => thold_REV_CLKDIV_posedge_posedge,
         HoldHigh       => thold_REV_CLKDIV_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_OSERDES",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Error
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_REV_CLKDIV_negedge,
         TimingData     => Tmkr_REV_CLKDIV_negedge,
         TestSignal     => REV_dly,
         TestSignalName => "REV",
         TestDelay      => tisd_REV_CLKDIV,
         RefSignal      => CLKDIV_dly,
         RefSignalName  => "CLKDIV",
         RefDelay       => ticd_CLKDIV,
         SetupHigh      => tsetup_REV_CLKDIV_posedge_negedge,
         SetupLow       => tsetup_REV_CLKDIV_negedge_negedge,
         HoldLow        => thold_REV_CLKDIV_posedge_negedge,
         HoldHigh       => thold_REV_CLKDIV_negedge_negedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'F',
         HeaderMsg      => InstancePath & "/X_OSERDES",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Error
       );
     end if;
-- End of (TimingChecksOn)

--  Output-to-Clock path delay
     VitalPathDelay01
       (
         OutSignal     => OQ,
         GlitchData    => OQ_GlitchData,
         OutSignalName => "OQ",
         OutTemp       => OQ_zd,
         Paths         => (0 => (CLK_dly'last_event, tpd_CLK_OQ,TRUE),
                           1 => (GSR_dly'last_event, tpd_GSR_OQ,TRUE),
                           2 => (REV_dly'last_event, tpd_REV_OQ,TRUE),
                           3 => (SR_dly'last_event, tpd_SR_OQ,TRUE)),
         Mode          => VitalTransport,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => TQ,
         GlitchData    => TQ_GlitchData,
         OutSignalName => "TQ",
         OutTemp       => TQ_zd,
         Paths         => (0 => (CLK_dly'last_event, tpd_CLK_TQ,TRUE),
                           1 => (GSR_dly'last_event, tpd_GSR_TQ,TRUE),
                           2 => (REV_dly'last_event, tpd_REV_TQ,TRUE),
                           3 => (SR_dly'last_event, tpd_SR_TQ,TRUE),
                           4 => (T1_dly'last_event, tpd_T1_TQ,TRUE)),
         Mode          => VitalTransport,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );

--     VitalPathDelay01
--       (
--         OutSignal     => OQ,
--         GlitchData    => OQ_GlitchData,
--         OutSignalName => "OQ",
--         OutTemp       => OQ_zd,
--         Paths         => (0 => (SR_dly'last_event, tpd_SR_OQ,TRUE)),
--         Mode          => VitalTransport,
--         Xon           => Xon,
--         MsgOn         => MsgOn,
--         MsgSeverity   => WARNING
--       );
--     VitalPathDelay01
--       (
--         OutSignal     => TQ,
--         GlitchData    => TQ_GlitchData,
--         OutSignalName => "TQ",
--         OutTemp       => TQ_zd,
--         Paths         => (0 => (SR_dly'last_event, tpd_SR_TQ,TRUE)),
--         Mode          => VitalTransport,
--         Xon           => Xon,
--         MsgOn         => MsgOn,
--         MsgSeverity   => WARNING
--       );

--     VitalPathDelay01
--       (
--         OutSignal     => OQ,
--         GlitchData    => OQ_GlitchData,
--         OutSignalName => "OQ",
--         OutTemp       => OQ_zd,
--         Paths         => (0 => (GSR_dly'last_event, tpd_GSR_OQ,TRUE)),
--         Mode          => VitalTransport,
--         Xon           => Xon,
--         MsgOn         => MsgOn,
--         MsgSeverity   => WARNING
--       );
--     VitalPathDelay01
--       (
--         OutSignal     => TQ,
--         GlitchData    => TQ_GlitchData,
--         OutSignalName => "TQ",
--         OutTemp       => TQ_zd,
--         Paths         => (0 => (GSR_dly'last_event, tpd_GSR_TQ,TRUE)),
--         Mode          => VitalTransport,
--         Xon           => Xon,
--         MsgOn         => MsgOn,
--         MsgSeverity   => WARNING
--       );
     if(SHIFTOUT1_zd'event) then
        VitalPathDelay01
          (
            OutSignal     => SHIFTOUT1,
            GlitchData    => SHIFTOUT1_GlitchData,
            OutSignalName => "SHIFTOUT1",
            OutTemp       => SHIFTOUT1_zd,
            Paths         => (0 => (CLK_dly'last_event, tpd_CLK_SHIFTOUT1,TRUE)),
            Mode          => VitalTransport,
            Xon           => Xon,
            MsgOn         => MsgOn,
            MsgSeverity   => WARNING
          );
     end if;
     if(SHIFTOUT2_zd'event) then
        VitalPathDelay01
          (
            OutSignal     => SHIFTOUT2,
            GlitchData    => SHIFTOUT2_GlitchData,
            OutSignalName => "SHIFTOUT2",
            OutTemp       => SHIFTOUT2_zd,
            Paths         => (0 => (CLK_dly'last_event, tpd_CLK_SHIFTOUT2,TRUE)),
            Mode          => VitalTransport,
            Xon           => Xon,
            MsgOn         => MsgOn,
            MsgSeverity   => WARNING
          );
     end if;
--  Wait signal (input/output pins)
   wait on
     D1_dly,
     D2_dly,
     D3_dly,
     D4_dly,
     D5_dly,
     D6_dly,
     T1_dly,
     T2_dly,
     T3_dly,
     T4_dly,
     CLK_dly,
     OCE_dly,
     TCE_dly,
     SR_dly,
     REV_dly,
     CLKDIV_dly,
     SHIFTIN1_dly,
     SHIFTIN2_dly,
     OQ_zd,
     TQ_zd,
     SHIFTOUT1_zd,
     SHIFTOUT2_zd;
  end process prcs_output;

end X_OSERDES_V;

-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  Phase-Matched Clock Divider
-- /___/   /\     Filename : X_PMCD.vhd
-- \   \  /  \    Timestamp : Fri Mar 26 08:18:21 PST 2004
--  \___\/\___\
--
-- Revision:
--    03/23/04 - Initial version.
--    06/20/07 - generate clka1d2 clka1d4 clka1d8 in same block to remove delta delay (CR440337)
-- End Revision

----- CELL X_PMCD -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;


library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.VPACKAGE.all;

entity X_PMCD is

  generic(

      TimingChecksOn : boolean := true;
      InstancePath   : string  := "*";
      Xon            : boolean := true;
      MsgOn          : boolean := true;
      LOC            : string  := "UNPLACED";

--  VITAL input Pin path delay variables
      tipd_CLKA : VitalDelayType01 := (0 ps, 0 ps);
      tipd_CLKB : VitalDelayType01 := (0 ps, 0 ps);
      tipd_CLKC : VitalDelayType01 := (0 ps, 0 ps);
      tipd_CLKD : VitalDelayType01 := (0 ps, 0 ps);
      tipd_REL  : VitalDelayType01 := (0 ps, 0 ps);
      tipd_RST  : VitalDelayType01 := (0 ps, 0 ps);

--  VITAL clk-to-output path delay variables
      tpd_CLKA_CLKA1 : VitalDelayType01 := (100 ps, 100 ps);
      tpd_CLKA_CLKA1D2 : VitalDelayType01 := (100 ps, 100 ps);
      tpd_CLKA_CLKA1D4 : VitalDelayType01 := (100 ps, 100 ps);
      tpd_CLKA_CLKA1D8 : VitalDelayType01 := (100 ps, 100 ps);
      tpd_CLKB_CLKA1 : VitalDelayType01 := (100 ps, 100 ps);
      tpd_CLKC_CLKA1 : VitalDelayType01 := (100 ps, 100 ps);
      tpd_CLKD_CLKA1 : VitalDelayType01 := (100 ps, 100 ps);

      tpd_CLKA_CLKB1 : VitalDelayType01 := (100 ps, 100 ps);
      tpd_CLKB_CLKB1 : VitalDelayType01 := (100 ps, 100 ps);
      tpd_CLKC_CLKB1 : VitalDelayType01 := (100 ps, 100 ps);
      tpd_CLKD_CLKB1 : VitalDelayType01 := (100 ps, 100 ps);

      tpd_CLKA_CLKC1 : VitalDelayType01 := (100 ps, 100 ps);
      tpd_CLKB_CLKC1 : VitalDelayType01 := (100 ps, 100 ps);
      tpd_CLKC_CLKC1 : VitalDelayType01 := (100 ps, 100 ps);
      tpd_CLKD_CLKC1 : VitalDelayType01 := (100 ps, 100 ps);

      tpd_CLKA_CLKD1 : VitalDelayType01 := (100 ps, 100 ps);
      tpd_CLKB_CLKD1 : VitalDelayType01 := (100 ps, 100 ps);
      tpd_CLKC_CLKD1 : VitalDelayType01 := (100 ps, 100 ps);
      tpd_CLKD_CLKD1 : VitalDelayType01 := (100 ps, 100 ps);

      tpd_REL_CLKA1D2  : VitalDelayType01 := (0 ps, 0 ps);
      tpd_REL_CLKA1D4  : VitalDelayType01 := (0 ps, 0 ps);
      tpd_REL_CLKA1D8  : VitalDelayType01 := (0 ps, 0 ps);

--  VITAL async rest-to-output path delay variables
      tpd_RST_CLKA1 : VitalDelayType01 := (0 ps, 0 ps);
      tpd_RST_CLKA1D2 : VitalDelayType01 := (0 ps, 0 ps);
      tpd_RST_CLKA1D4 : VitalDelayType01 := (0 ps, 0 ps);
      tpd_RST_CLKA1D8 : VitalDelayType01 := (0 ps, 0 ps);

      tpd_RST_CLKB1 : VitalDelayType01 := (0 ps, 0 ps);

      tpd_RST_CLKC1 : VitalDelayType01 := (0 ps, 0 ps);

      tpd_RST_CLKD1 : VitalDelayType01 := (0 ps, 0 ps);


--  tbpd
      tbpd_RST_CLKD1_CLKD  : VitalDelayType01 := (0.0 ps, 0.0 ps);
      tbpd_RST_CLKC1_CLKC  : VitalDelayType01 := (0.0 ps, 0.0 ps);
      tbpd_RST_CLKB1_CLKB  : VitalDelayType01 := (0.0 ps, 0.0 ps);
      tbpd_RST_CLKA1_CLKA  : VitalDelayType01 := (0.0 ps, 0.0 ps);
      tbpd_RST_CLKA1D2_CLKA  : VitalDelayType01 := (0.0 ps, 0.0 ps);
      tbpd_RST_CLKA1D4_CLKA  : VitalDelayType01 := (0.0 ps, 0.0 ps);
      tbpd_RST_CLKA1D8_CLKA  : VitalDelayType01 := (0.0 ps, 0.0 ps);

--  VITAL tisd & tisd variables

      tisd_REL_CLKA       : VitalDelayType   := 0.0 ps;

      tisd_RST_CLKA  : VitalDelayType   := 0.0 ps;
      tisd_RST_CLKB  : VitalDelayType   := 0.0 ps;
      tisd_RST_CLKC  : VitalDelayType   := 0.0 ps;
      tisd_RST_CLKD  : VitalDelayType   := 0.0 ps;

      tisd_RST_REL   : VitalDelayType   := 0.0 ps;

      ticd_CLKA      : VitalDelayType   := 0.0 ps;
      ticd_CLKB      : VitalDelayType   := 0.0 ps;
      ticd_CLKC      : VitalDelayType   := 0.0 ps;
      ticd_CLKD      : VitalDelayType   := 0.0 ps;

      ticd_REL       : VitalDelayType   := 0.0 ps;

--  VITAL Setup/Hold delay variables
      tsetup_REL_CLKA_posedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_REL_CLKA_negedge_posedge : VitalDelayType := 0.0 ps;
      thold_REL_CLKA_posedge_posedge  : VitalDelayType := 0.0 ps;
      thold_REL_CLKA_negedge_posedge  : VitalDelayType := 0.0 ps;

-- VITAL pulse width variables
      tpw_CLKA_posedge              : VitalDelayType := 0 ps;
      tpw_CLKA_negedge              : VitalDelayType := 0 ps;

      tpw_CLKB_posedge              : VitalDelayType := 0 ps;
      tpw_CLKB_negedge              : VitalDelayType := 0 ps;

      tpw_CLKC_posedge              : VitalDelayType := 0 ps;
      tpw_CLKC_negedge              : VitalDelayType := 0 ps;

      tpw_CLKD_posedge              : VitalDelayType := 0 ps;
      tpw_CLKD_negedge              : VitalDelayType := 0 ps;

      tpw_REL_posedge               : VitalDelayType := 0 ps;
      tpw_REL_negedge               : VitalDelayType := 0 ps;

      tpw_RST_posedge               : VitalDelayType := 0 ps;
      tpw_RST_negedge               : VitalDelayType := 0 ps;

-- VITAL period variables
      tperiod_CLKA_posedge          : VitalDelayType := 0 ps;
      tperiod_CLKB_posedge          : VitalDelayType := 0 ps;
      tperiod_CLKC_posedge          : VitalDelayType := 0 ps;
      tperiod_CLKD_posedge          : VitalDelayType := 0 ps;

-- VITAL recovery time variables

      trecovery_RST_CLKA_negedge_posedge : VitalDelayType := 0 ps;
      trecovery_RST_CLKB_negedge_posedge : VitalDelayType := 0 ps;
      trecovery_RST_CLKC_negedge_posedge : VitalDelayType := 0 ps;
      trecovery_RST_CLKD_negedge_posedge : VitalDelayType := 0 ps;

      trecovery_RST_REL_negedge_posedge : VitalDelayType := 0 ps;

-- VITAL removal time variables

      tremoval_RST_CLKA_negedge_posedge : VitalDelayType := 0 ps;
      tremoval_RST_CLKB_negedge_posedge : VitalDelayType := 0 ps;
      tremoval_RST_CLKC_negedge_posedge : VitalDelayType := 0 ps;
      tremoval_RST_CLKD_negedge_posedge : VitalDelayType := 0 ps;

      tremoval_RST_REL_negedge_posedge : VitalDelayType := 0 ps;

      EN_REL           : boolean := FALSE;
      RST_DEASSERT_CLK : string  := "CLKA"
      );

  port(
      CLKA1   : out std_ulogic;
      CLKA1D2 : out std_ulogic;
      CLKA1D4 : out std_ulogic;
      CLKA1D8 : out std_ulogic;
      CLKB1   : out std_ulogic;
      CLKC1   : out std_ulogic;
      CLKD1   : out std_ulogic;

      CLKA    : in  std_ulogic;
      CLKB    : in  std_ulogic;
      CLKC    : in  std_ulogic;
      CLKD    : in  std_ulogic;
      REL     : in  std_ulogic;
      RST     : in  std_ulogic
      );

  attribute VITAL_LEVEL0 of
    X_PMCD : entity is true;

end X_PMCD;

architecture X_PMCD_V OF X_PMCD is

  attribute VITAL_LEVEL0 of
    X_PMCD_V : architecture is true;


  constant SYNC_PATH_DELAY	: time := 100 ps;

  signal CLKA_ipd		: std_ulogic := 'X';
  signal CLKB_ipd		: std_ulogic := 'X';
  signal CLKC_ipd		: std_ulogic := 'X';
  signal CLKD_ipd		: std_ulogic := 'X';

  signal REL_ipd		: std_ulogic := 'X';
  signal RST_ipd		: std_ulogic := 'X';

  signal CLKA_dly		: std_ulogic := 'X';
  signal CLKB_dly		: std_ulogic := 'X';
  signal CLKC_dly		: std_ulogic := 'X';
  signal CLKD_dly		: std_ulogic := 'X';

  signal REL_dly		: std_ulogic := 'X';
  signal RST_dly		: std_ulogic := 'X';

  signal CLKA1_zd		: std_ulogic := 'X';
  signal CLKA1D2_zd		: std_ulogic := 'X';
  signal CLKA1D4_zd		: std_ulogic := 'X';
  signal CLKA1D8_zd		: std_ulogic := 'X';
  signal CLKB1_zd		: std_ulogic := 'X';
  signal CLKC1_zd		: std_ulogic := 'X';
  signal CLKD1_zd		: std_ulogic := 'X';

  signal rel_clk_sel		: integer    := 0;
  signal rst_active    		: boolean    := true;
  signal r1_out        		: std_ulogic := '0';
  signal rdiv_out      		: std_ulogic := '0';
  signal active_clk    		: std_ulogic := 'X';

  signal Violation_CLKA1        : std_ulogic := '0';
  signal Violation_CLKB1        : std_ulogic := '0';
  signal Violation_CLKC1        : std_ulogic := '0';
  signal Violation_CLKD1        : std_ulogic := '0';

  signal GSR_dly		: std_ulogic := '0';

begin

  ---------------------
  --  INPUT PATH DELAYs
  --------------------

  WireDelay : block
  begin
    VitalWireDelay (CLKA_ipd, CLKA, tipd_CLKA);
    VitalWireDelay (CLKB_ipd, CLKB, tipd_CLKB);
    VitalWireDelay (CLKC_ipd, CLKC, tipd_CLKC);
    VitalWireDelay (CLKD_ipd, CLKD, tipd_CLKD);
    VitalWireDelay (REL_ipd,  REL,  tipd_REL);
    VitalWireDelay (RST_ipd,  RST,  tipd_RST);
  end block;

  SignalDelay : block
  begin
    VitalSignalDelay (CLKA_dly, CLKA_ipd, ticd_CLKA);
    VitalSignalDelay (CLKB_dly, CLKB_ipd, ticd_CLKB);
    VitalSignalDelay (CLKC_dly, CLKC_ipd, ticd_CLKC);
    VitalSignalDelay (CLKD_dly, CLKD_ipd, ticd_CLKD);
    VitalSignalDelay (REL_dly,  REL_ipd,  tisd_REL_CLKA);
    VitalSignalDelay (RST_dly,  RST_ipd,  tisd_RST_CLKA);
  end block;

  --------------------
  --  BEHAVIOR SECTION
  --------------------


--####################################################################
--#####                     Initialize                           #####
--####################################################################
  prcs_init:process
  variable FIRST_TIME : boolean := true;
  begin
      if((RST_DEASSERT_CLK = "clka") or (RST_DEASSERT_CLK = "CLKA")) then
         rel_clk_sel <= 1;
      elsif((RST_DEASSERT_CLK = "clkb") or (RST_DEASSERT_CLK = "CLKB")) then
         rel_clk_sel <= 2;
      elsif((RST_DEASSERT_CLK = "clkc") or (RST_DEASSERT_CLK = "CLKC")) then
         rel_clk_sel <= 3;
      elsif((RST_DEASSERT_CLK = "clkd") or (RST_DEASSERT_CLK = "CLKD")) then
         rel_clk_sel <= 4;
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Warning ",
             GenericName => " RST_DEASSERT_CLK ",
             EntityName => "/X_PMCD",
             GenericValue => RST_DEASSERT_CLK,
             Unit => "",
             ExpectedValueMsg => " The Legal values for this attribute are ",
             ExpectedGenericValue => " CLKA, CLKB, CLKC or CLKD ",
             TailMsg => "",
             MsgSeverity => ERROR
         );
      end if;

      if(EN_REL = true) then
         rst_active <= false;
      elsif(EN_REL = false) then
         rst_active <= true;
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Warning ",
             GenericName => " EN_REL ",
             EntityName => "/X_PMCD",
             GenericValue => EN_REL,
             Unit => "",
             ExpectedValueMsg => " The Legal values for this attribute are ",
             ExpectedGenericValue => "True or False",
             TailMsg => "",
             MsgSeverity => ERROR
         );
      end if;
     wait;
  end process prcs_init;
--####################################################################
--#####                           CLKA                           #####
--####################################################################
  prcs_clka:process(CLKA1_zd, CLKA1D2_zd, CLKA1D4_zd, CLKA1D8_zd,
                    CLKA_dly, r1_out, rdiv_out, GSR_dly)
  variable first_time : boolean := true;
  begin
     if(GSR_dly = '1') then
         CLKA1_zd <= '0';
         CLKA1D2_zd <= '0';
         CLKA1D4_zd <= '0';
         CLKA1D8_zd <= '0';
     elsif(GSR_dly = '0') then

        if((first_time) and ((CLKA_dly = '0') or CLKA_dly = '1')) then
          CLKA1_zd <= CLKA_dly;
          CLKA1D2_zd <= CLKA_dly;
          CLKA1D4_zd <= CLKA_dly;
          CLKA1D8_zd <= CLKA_dly;
          first_time := false;
        end if;

        if(r1_out = '0') then
            CLKA1_zd <= CLKA_dly;
        elsif (r1_out = '1') then
          CLKA1_zd <= '0';
        end if;

        if(rdiv_out = '1') then
           CLKA1D2_zd <= '0';
           CLKA1D4_zd <= '0';
           CLKA1D8_zd <= '0';
        elsif(rdiv_out = '0') then
          if(rising_edge(CLKA_dly)) then
            CLKA1D2_zd <= NOT CLKA1D2_zd;
            if (CLKA1D2_zd = '0') then
                CLKA1D4_zd <= NOT CLKA1D4_zd;
                if (CLKA1D4_zd = '0') then
                    CLKA1D8_zd <= NOT CLKA1D8_zd;
                end if;
             end if;
          end if;
        end if;
     end if;

  end process prcs_clka;
--####################################################################
--#####                           CLKB                           #####
--####################################################################
 prcs_clkb:process(CLKB_dly, r1_out, GSR_dly)
  variable first_time : boolean := true;
  begin
     if((GSR_dly = '1') or (r1_out = '1')) then
          CLKB1_zd <= '0';
     elsif ((GSR_dly = '0') and (r1_out = '0')) then
--         if(CLKB_dly'event) then
           CLKB1_zd <= CLKB_dly;
--         end if;
     end if;
  end process prcs_clkb;
--####################################################################
--#####                           CLKC                           #####
--####################################################################
 prcs_clkc:process(CLKC_dly, r1_out, GSR_dly)
  variable first_time : boolean := true;
  begin
     if((GSR_dly = '1') or (r1_out = '1')) then
          CLKC1_zd <= '0';
     elsif ((GSR_dly = '0') and (r1_out = '0')) then
--         if(CLKC_dly'event) then
           CLKC1_zd <= CLKC_dly;
--         end if;
     end if;
  end process prcs_clkc;
--####################################################################
--#####                           CLKD                           #####
--####################################################################
 prcs_clkd:process(CLKD_dly, r1_out, GSR_dly)
  variable first_time : boolean := true;
  begin
     if((GSR_dly = '1') or (r1_out = '1')) then
          CLKD1_zd <= '0';
     elsif ((GSR_dly = '0') and (r1_out = '0')) then
--         if(CLKD_dly'event) then
           CLKD1_zd <= CLKD_dly;
--         end if;
     end if;
  end process prcs_clkd;
--####################################################################
--#####                       RST CLK SEL                        #####
--####################################################################
  prcs_rel_clk_mux:process(CLKA_dly, CLKB_dly, CLKC_dly, CLKD_dly)
  begin
      case rel_clk_sel is
             when 1 => active_clk <= CLKA_dly;
             when 2 => active_clk <= CLKB_dly;
             when 3 => active_clk <= CLKC_dly;
             when 4 => active_clk <= CLKD_dly;
             when others => null;
      end case;
  end process prcs_rel_clk_mux;

--####################################################################
--#####                     RELEASE SIGNAL                       #####
--####################################################################
  prcs_act_rel:process(active_clk, REL_dly, RST_dly, GSR_dly)
  variable released      : boolean := false;
  variable r1_released   : boolean := false;
  variable rdiv_released : boolean := false;
  variable start_rel_clk_count : boolean := false;
  variable rel_clk_count : integer := 0;
  variable path_1_clk_count : integer := 0;
  variable path_1        : std_ulogic := '0';
  variable path_2        : std_ulogic := '0';

  begin
      if((GSR_dly = '1') or (RST_dly = '1')) then
          released      := false;
          r1_released   := false;
          rdiv_released := false;
          rel_clk_count := 0;
          start_rel_clk_count := false;
          r1_out   <= '1';
          rdiv_out <= '1';
          path_1_clk_count := 0;
          path_1 := '1';
          path_2 := '1';
      elsif ((GSR_dly = '0') and (RST_dly = '0')) then
         if(rst_active) then
           if(not released) then
             if(rising_edge(active_clk)) then
              start_rel_clk_count := true;
             end if;
             if(active_clk'event and start_rel_clk_count) then
               rel_clk_count := rel_clk_count + 1;
             end if;
             if(rel_clk_count >= 1) then
                rdiv_out <= '0';
             end if;
             if(rel_clk_count >= 2) then
                r1_out   <= '0';
                released := true;
             end if;
           end if;
         elsif(not rst_active) then
           if(not r1_released) then
             if(rising_edge(active_clk)) then
              start_rel_clk_count := true;
             end if;
             if(active_clk'event and start_rel_clk_count) then
               rel_clk_count := rel_clk_count + 1;
             end if;
             if(rel_clk_count >= 2) then
                r1_out <= '0';
                r1_released := true;
             end if;
           end if;
           if(not rdiv_released) then
             if(rising_edge(active_clk)) then
               path_1_clk_count := path_1_clk_count + 1;
               if(path_1_clk_count >=  1) then
                path_1 := '0';
               end if;
             end if;

             if(rising_edge(REL_dly)) then
                path_2 := '0';
             end if;

             if((path_1 = '0') and (path_2 = '0')) then
                rdiv_out <= '0';
                rdiv_released := true;
             end if;
           end if;
         end if;
      end if;
  end process prcs_act_rel;
--####################################################################

--####################################################################
--#####                   TIMING CHECKS & OUTPUT                 #####
--####################################################################
  prcs_tmngchk:process
  variable Tmkr_REL_CLKA_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_REL_CLKA_posedge : std_ulogic          := '0';
  variable Tmkr_RST_CLKA_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_RST_CLKA_posedge : std_ulogic          := '0';
  variable Tmkr_RST_CLKB_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_RST_CLKB_posedge : std_ulogic          := '0';
  variable Tmkr_RST_CLKC_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_RST_CLKC_posedge : std_ulogic          := '0';
  variable Tmkr_RST_CLKD_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_RST_CLKD_posedge : std_ulogic          := '0';
  variable Tmkr_RST_REL_posedge   : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_RST_REL_posedge  : std_ulogic          := '0';

  variable Pviol_CLKA : std_ulogic          := '0';
  variable PInfo_CLKA : VitalPeriodDataType := VitalPeriodDataInit;
  variable Pviol_CLKB : std_ulogic          := '0';
  variable PInfo_CLKB : VitalPeriodDataType := VitalPeriodDataInit;
  variable Pviol_CLKC : std_ulogic          := '0';
  variable PInfo_CLKC : VitalPeriodDataType := VitalPeriodDataInit;
  variable Pviol_CLKD : std_ulogic          := '0';
  variable PInfo_CLKD : VitalPeriodDataType := VitalPeriodDataInit;
  variable Pviol_REL  : std_ulogic          := '0';
  variable PInfo_REL  : VitalPeriodDataType := VitalPeriodDataInit;
  variable Pviol_RST  : std_ulogic          := '0';
  variable PInfo_RST  : VitalPeriodDataType := VitalPeriodDataInit;

  begin
    if(TimingChecksOn) then

     VitalSetupHoldCheck
       (
         Violation      => Tviol_REL_CLKA_posedge,
         TimingData     => Tmkr_REL_CLKA_posedge,
         TestSignal     => REL,
         TestSignalName => "REL",
         TestDelay      => 0 ns,
         RefSignal      => CLKA_dly,
         RefSignalName  => "CLKA",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_REL_CLKA_posedge_posedge,
         SetupLow       => tsetup_REL_CLKA_negedge_posedge,
         HoldLow        => thold_REL_CLKA_posedge_posedge,
         HoldHigh       => thold_REL_CLKA_negedge_posedge,
         CheckEnabled   => GSR_dly  /= '1',
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_PMCD",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING);
--===================================================== 
       VitalRecoveryRemovalCheck (
         Violation            => Tviol_RST_CLKA_posedge,
         TimingData           => Tmkr_RST_CLKA_posedge,
         TestSignal           => RST_dly,
         TestSignalName       => "RST",
         TestDelay            => tisd_RST_CLKA,
         RefSignal            => CLKA_dly,
         RefSignalName        => "CLKA",
         RefDelay             => ticd_CLKA,
         Recovery             => trecovery_RST_CLKA_negedge_posedge,
         Removal              => tremoval_RST_CLKA_negedge_posedge,
         ActiveLow            => FALSE,
         CheckEnabled         => GSR_dly  /= '1',
         RefTransition        => 'R',
         HeaderMsg            => "/X_PMCD",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => warning);
--===================================================== 
       VitalRecoveryRemovalCheck (
         Violation            => Tviol_RST_CLKB_posedge,
         TimingData           => Tmkr_RST_CLKB_posedge,
         TestSignal           => RST_dly,
         TestSignalName       => "RST",
         TestDelay            => tisd_RST_CLKB,
         RefSignal            => CLKB_dly,
         RefSignalName        => "CLKB",
         RefDelay             => ticd_CLKB,
         Recovery             => trecovery_RST_CLKB_negedge_posedge,
         Removal              => tremoval_RST_CLKB_negedge_posedge,
         ActiveLow            => FALSE,
         CheckEnabled         => GSR_dly  /= '1',
         RefTransition        => 'R',
         HeaderMsg            => "/X_PMCD",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => warning);
--===================================================== 
       VitalRecoveryRemovalCheck (
         Violation            => Tviol_RST_CLKC_posedge,
         TimingData           => Tmkr_RST_CLKC_posedge,
         TestSignal           => RST_dly,
         TestSignalName       => "RST",
         TestDelay            => tisd_RST_CLKC,
         RefSignal            => CLKC_dly,
         RefSignalName        => "CLKC",
         RefDelay             => ticd_CLKC,
         Recovery             => trecovery_RST_CLKC_negedge_posedge,
         Removal              => tremoval_RST_CLKC_negedge_posedge,
         ActiveLow            => FALSE,
         CheckEnabled         => GSR_dly  /= '1',
         RefTransition        => 'R',
         HeaderMsg            => "/X_PMCD",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => warning);
--===================================================== 
       VitalRecoveryRemovalCheck (
         Violation            => Tviol_RST_CLKD_posedge,
         TimingData           => Tmkr_RST_CLKD_posedge,
         TestSignal           => RST_dly,
         TestSignalName       => "RST",
         TestDelay            => tisd_RST_CLKD,
         RefSignal            => CLKD_dly,
         RefSignalName        => "CLKD",
         RefDelay             => ticd_CLKD,
         Recovery             => trecovery_RST_CLKD_negedge_posedge,
         Removal              => tremoval_RST_CLKD_negedge_posedge,
         ActiveLow            => FALSE,
         CheckEnabled         => GSR_dly  /= '1',
         RefTransition        => 'R',
         HeaderMsg            => "/X_PMCD",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => warning);
--===================================================== 
       VitalRecoveryRemovalCheck (
         Violation            => Tviol_RST_REL_posedge,
         TimingData           => Tmkr_RST_REL_posedge,
         TestSignal           => RST_dly,
         TestSignalName       => "RST",
         TestDelay            => tisd_RST_REL,
         RefSignal            => REL_dly,
         RefSignalName        => "REL",
         RefDelay             => ticd_REL,
         Recovery             => trecovery_RST_REL_negedge_posedge,
         Removal              => tremoval_RST_REL_negedge_posedge,
         ActiveLow            => FALSE,
         CheckEnabled         => GSR_dly  /= '1',
         RefTransition        => 'R',
         HeaderMsg            => "/X_PMCD",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => warning);
--===================================================== 
       VitalPeriodPulseCheck (
         Violation            => Pviol_CLKA,
         PeriodData           => PInfo_CLKA,
         TestSignal           => CLKA_dly,
         TestSignalName       => "CLKA",
         TestDelay            => 0 ps,
         Period               => tperiod_CLKA_posedge,
         PulseWidthHigh       => tpw_CLKA_posedge,
         PulseWidthLow        => tpw_CLKA_negedge,
         CheckEnabled         => (GSR_dly  /= '1' and RST_dly /= '1'),
         HeaderMsg            => "/X_PMCD",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => warning);
--===================================================== 
       VitalPeriodPulseCheck (
         Violation            => Pviol_CLKB,
         PeriodData           => PInfo_CLKB,
         TestSignal           => CLKB_dly,
         TestSignalName       => "CLKB",
         TestDelay            => 0 ps,
         Period               => tperiod_CLKB_posedge,
         PulseWidthHigh       => tpw_CLKB_posedge,
         PulseWidthLow        => tpw_CLKB_negedge,
         CheckEnabled         => (GSR_dly  /= '1' and RST_dly /= '1'),
         HeaderMsg            => "/X_PMCD",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => warning);
--===================================================== 
       VitalPeriodPulseCheck (
         Violation            => Pviol_CLKC,
         PeriodData           => PInfo_CLKC,
         TestSignal           => CLKC_dly,
         TestSignalName       => "CLKC",
         TestDelay            => 0 ps,
         Period               => tperiod_CLKC_posedge,
         PulseWidthHigh       => tpw_CLKC_posedge,
         PulseWidthLow        => tpw_CLKC_negedge,
         CheckEnabled         => (GSR_dly  /= '1' and RST_dly /= '1'),
         HeaderMsg            => "/X_PMCD",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => warning);
--===================================================== 
       VitalPeriodPulseCheck (
         Violation            => Pviol_CLKD,
         PeriodData           => PInfo_CLKD,
         TestSignal           => CLKD_dly,
         TestSignalName       => "CLKD",
         TestDelay            => 0 ps,
         Period               => tperiod_CLKD_posedge,
         PulseWidthHigh       => tpw_CLKD_posedge,
         PulseWidthLow        => tpw_CLKD_negedge,
         CheckEnabled         => (GSR_dly  /= '1' and RST_dly /= '1'),
         HeaderMsg            => "/X_PMCD",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => warning);
--===================================================== 
     VitalPeriodPulseCheck
       (
         Violation      => Pviol_REL,
         PeriodData     => PInfo_REL,
         TestSignal     => REL_dly,
         TestSignalName => "REL",
         TestDelay      => 0 ns,
         Period         => 0 ns,
         PulseWidthHigh => tpw_REL_posedge,
         PulseWidthLow  => tpw_REL_negedge,
         CheckEnabled   => TRUE,
         HeaderMsg      => "/X_PMCD",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING);
--===================================================== 
     VitalPeriodPulseCheck
       (
         Violation      => Pviol_RST,
         PeriodData     => PInfo_RST,
         TestSignal     => RST_dly,
         TestSignalName => "RST",
         TestDelay      => 0 ns,
         Period         => 0 ns,
         PulseWidthHigh => tpw_RST_posedge,
         PulseWidthLow  => tpw_RST_negedge,
         CheckEnabled   => TRUE,
         HeaderMsg      => "/X_PMCD",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING);
    end if;

    Violation_CLKA1 <= Tviol_REL_CLKA_posedge or Tviol_RST_CLKA_posedge or Pviol_CLKA or Pviol_RST;
    Violation_CLKB1 <= Tviol_RST_CLKB_posedge or Pviol_CLKB or Pviol_RST;
    Violation_CLKC1 <= Tviol_RST_CLKC_posedge or Pviol_CLKC or Pviol_RST;
    Violation_CLKD1 <= Tviol_RST_CLKD_posedge or Pviol_CLKD or Pviol_RST;

    wait on CLKA_dly, CLKB_dly, CLKC_dly, CLKD_dly,
            REL_dly, RST_dly, GSR_dly;
  end process prcs_tmngchk;
--####################################################################
--#####                           OUTPUT                         #####
--####################################################################
  prcs_output:process
  variable CLKA1_GlitchData	: VitalGlitchDataType;
  variable CLKA1D2_GlitchData	: VitalGlitchDataType;
  variable CLKA1D4_GlitchData	: VitalGlitchDataType;
  variable CLKA1D8_GlitchData	: VitalGlitchDataType;
  variable CLKB1_GlitchData	: VitalGlitchDataType;
  variable CLKC1_GlitchData	: VitalGlitchDataType;
  variable CLKD1_GlitchData	: VitalGlitchDataType;
  variable CLKA1_zd_viol_var	: std_ulogic := '0';
  variable CLKA1D2_zd_viol_var	: std_ulogic := '0';
  variable CLKA1D4_zd_viol_var	: std_ulogic := '0';
  variable CLKA1D8_zd_viol_var	: std_ulogic := '0';
  variable CLKB1_zd_viol_var	: std_ulogic := '0';
  variable CLKC1_zd_viol_var	: std_ulogic := '0';
  variable CLKD1_zd_viol_var	: std_ulogic := '0';
  begin

    CLKA1_zd_viol_var   := Violation_CLKA1  xor CLKA1_zd;
    CLKA1D2_zd_viol_var := Violation_CLKA1  xor CLKA1D2_zd;
    CLKA1D4_zd_viol_var := Violation_CLKA1  xor CLKA1D4_zd;
    CLKA1D8_zd_viol_var := Violation_CLKA1  xor CLKA1D8_zd;
    CLKB1_zd_viol_var   := Violation_CLKB1  xor CLKB1_zd;
    CLKC1_zd_viol_var   := Violation_CLKC1  xor CLKC1_zd;
    CLKD1_zd_viol_var   := Violation_CLKD1  xor CLKD1_zd;

    VitalPathDelay01 (
      OutSignal  => CLKA1,
      GlitchData => CLKA1_GlitchData,
      OutSignalName => "CLKA1",
      OutTemp => CLKA1_zd_viol_var,
      Paths => (0 => (CLKA1_zd'last_event, tpd_CLKA_CLKA1, RST_dly /= '1'),
                1 => (RST_dly'last_event,  tpd_RST_CLKA1,  RST_dly  = '1')),
      Mode => VitalTransport,
      Xon => Xon,
      MsgOn => True,
      MsgSeverity => WARNING
      );
    VitalPathDelay01 (
      OutSignal  => CLKB1,
      GlitchData => CLKB1_GlitchData,
      OutSignalName => "CLKB1",
      OutTemp => CLKB1_zd_viol_var,
      Paths => (0 => (CLKB1_zd'last_event, tpd_CLKB_CLKB1, RST_dly /= '1'),
                1 => (RST_dly'last_event,  tpd_RST_CLKB1,  RST_dly  = '1')),
      Mode => VitalTransport,
      Xon => Xon,
      MsgOn => True,
      MsgSeverity => WARNING
      );
    VitalPathDelay01 (
      OutSignal  => CLKC1,
      GlitchData => CLKC1_GlitchData,
      OutSignalName => "CLKC1",
      OutTemp => CLKC1_zd_viol_var,
      Paths => (0 => (CLKC1_zd'last_event, tpd_CLKC_CLKC1, RST_dly /= '1'),
                1 => (RST_dly'last_event,  tpd_RST_CLKC1,  RST_dly  = '1')),
      Mode => VitalTransport,
      Xon => Xon,
      MsgOn => True,
      MsgSeverity => WARNING
      );
    VitalPathDelay01 (
      OutSignal  => CLKD1,
      GlitchData => CLKD1_GlitchData,
      OutSignalName => "CLKD1",
      OutTemp => CLKD1_zd_viol_var,
      Paths => (0 => (CLKD1_zd'last_event, tpd_CLKD_CLKD1, RST_dly /= '1'),
                1 => (RST_dly'last_event,  tpd_RST_CLKD1,  RST_dly  = '1')),
      Mode => VitalTransport,
      Xon => Xon,
      MsgOn => True,
      MsgSeverity => WARNING
      );
    VitalPathDelay01 (
      OutSignal  => CLKA1D2,
      GlitchData => CLKA1D2_GlitchData,
      OutSignalName => "CLKA1D2",
      OutTemp => CLKA1D2_zd_viol_var,
      Paths => (0 => (CLKA1D2_zd'last_event, tpd_CLKA_CLKA1D2, RST_dly /= '1'),
                1 => (REL_dly'last_event,  tpd_REL_CLKA1D2,  RST_dly /= '1'),
                2 => (RST_dly'last_event,  tpd_RST_CLKA1D2,  RST_dly  = '1')),
      Mode => VitalTransport,
      Xon => Xon,
      MsgOn => True,
      MsgSeverity => WARNING
      );
    VitalPathDelay01 (
      OutSignal  => CLKA1D4,
      GlitchData => CLKA1D4_GlitchData,
      OutSignalName => "CLKA1D4",
      OutTemp => CLKA1D4_zd_viol_var,
      Paths => (0 => (CLKA1D4_zd'last_event, tpd_CLKA_CLKA1D4, RST_dly /= '1'),
                1 => (REL_dly'last_event,  tpd_REL_CLKA1D4,  RST_dly /= '1'),
                2 => (RST_dly'last_event,  tpd_RST_CLKA1D4,  RST_dly  = '1')),
      Mode => VitalTransport,
      Xon => Xon,
      MsgOn => True,
      MsgSeverity => WARNING
      );
    VitalPathDelay01 (
      OutSignal  => CLKA1D8,
      GlitchData => CLKA1D8_GlitchData,
      OutSignalName => "CLKA1D8",
      OutTemp => CLKA1D8_zd_viol_var,
      Paths => (0 => (CLKA1D8_zd'last_event, tpd_CLKA_CLKA1D8, RST_dly /= '1'),
                1 => (REL_dly'last_event,  tpd_REL_CLKA1D8,  RST_dly /= '1'),
                2 => (RST_dly'last_event,  tpd_RST_CLKA1D8,  RST_dly  = '1')),
      Mode => VitalTransport,
      Xon => Xon,
      MsgOn => True,
      MsgSeverity => WARNING
      );
     wait on CLKA1_zd, CLKA1D2_zd, CLKA1D4_zd, CLKA1D8_zd,
             CLKB1_zd, CLKC1_zd, CLKD1_zd;
  end process prcs_output;


end X_PMCD_V;

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
-- /___/   /\     Filename : X_RAMB16.vhd
-- \   \  /  \    Timestamp : Thu Mar 17 16:56:02 PST 2005
--  \___\/\___\
--
-- Revision:
--    03/23/04 - Initial version.
--    03/17/05 - Added EN_ECC_READ/WRITE -- affects tim sim model only  -- CR 204627 --FP
--    05/24/05 - Fixed CR 200506 --FP
--    08/25/05 - Fixed CR 215294 --FP -- Added Message for unequal WEs in WF mode
--    11/15/05 - Fixed CR 219497 --FP -- made collision functions inout -- ncsim issue
--    01/05/06 - Fixed CR 223161 --FP -- propagated INIT values.
--    02/06/06 - Fixed CR 223097 --FP -- CASCADE/NO_CHANGE message.
--    05/19/06 - Fixed CR 231750 --FP -- Added timing arcs for Cascadein to output.
--    06/30/06 - Fixed CR 231750 --FP -- Added timing checks for CLK to Cascadein.
--    07/10/06 - Added 2 dimensional memory array feature.
--    01/24/07 - Added support of memory file to initialize memory and parity (CR 431584).  
--    02/13/07 - Fixed register output in cascaded mode (CR 433819).
--    03/05/07 - Fixed inverted clock (CR 434198).
--    03/13/07 - Removed attribute INITP_FILE (CR 436003).
--    04/03/07 - Changed INIT_FILE = "NONE" as default (CR 436812). 
--    04/01/08 - Fixed delta delay problem on inputs (CR470144).
-- End Revision

----- CELL X_RAMB16 -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library STD;
use STD.TEXTIO.all;

library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.Vcomponents.all;
use simprim.VPACKAGE.all;

entity X_RAMB16 is

  generic (
    TimingChecksOn : boolean := true;
    InstancePath   : string  := "*";
    Xon            : boolean := true;
    MsgOn          : boolean := true;
    LOC            : string  := "UNPLACED";


--- VITAL input wire delays

    tipd_ADDRA   : VitalDelayArrayType01(14 downto 0) := (others => (0 ps, 0 ps));
    tipd_CLKA    : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_DIA     : VitalDelayArrayType01(31 downto 0) := (others => (0 ps, 0 ps));
    tipd_DIPA    : VitalDelayArrayType01(3 downto 0)  := (others => (0 ps, 0 ps));
    tipd_ENA     : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_REGCEA  : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_SSRA    : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_WEA     : VitalDelayArrayType01 (3 downto 0) := (others => (0 ps, 0 ps));
    tipd_CASCADEINA  : VitalDelayType01               := ( 0 ps, 0 ps);

    tipd_ADDRB   : VitalDelayArrayType01(14 downto 0) := (others => (0 ps, 0 ps));
    tipd_CLKB    : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_DIB     : VitalDelayArrayType01(31 downto 0) := (others => (0 ps, 0 ps));
    tipd_DIPB    : VitalDelayArrayType01(3 downto 0)  := (others => (0 ps, 0 ps));
    tipd_ENB     : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_REGCEB  : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_SSRB    : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_WEB     : VitalDelayArrayType01 (3 downto 0) := (others => (0 ps, 0 ps));
    tipd_CASCADEINB  : VitalDelayType01               := ( 0 ps, 0 ps);

    tipd_GSR : VitalDelayType01 := ( 0 ps, 0 ps);

--- VITAL pin-to-pin propagation delays

    tpd_GSR_DOA  : VitalDelayArrayType01(31 downto 0) := (others => (0 ps, 0 ps));
    tpd_GSR_DOPA : VitalDelayArrayType01(3 downto 0)  := (others => (0 ps, 0 ps));
    tpd_GSR_CASCADEOUTA : VitalDelayType01            := (0 ps, 0 ps);

    tpd_GSR_DOB  : VitalDelayArrayType01(31 downto 0) := (others => (0 ps, 0 ps));
    tpd_GSR_DOPB : VitalDelayArrayType01(3 downto 0)  := (others => (0 ps, 0 ps));
    tpd_GSR_CASCADEOUTB : VitalDelayType01            := (0 ps, 0 ps);

    tpd_CASCADEINA_DOA  : VitalDelayArrayType01(31 downto 0) := (others => (0 ps, 0 ps));
    tpd_CLKA_DOA  : VitalDelayArrayType01(31 downto 0) := (others => (100 ps, 100 ps));
    tpd_CLKA_DOPA : VitalDelayArrayType01(3 downto 0)  := (others => (100 ps, 100 ps));
    tpd_CLKA_CASCADEOUTA : VitalDelayType01            := (100 ps, 100 ps);

    tpd_CASCADEINB_DOB  : VitalDelayArrayType01(31 downto 0) := (others => (0 ps, 0 ps));
    tpd_CLKB_DOB  : VitalDelayArrayType01(31 downto 0) := (others => (100 ps, 100 ps));
    tpd_CLKB_DOPB : VitalDelayArrayType01(3 downto 0)  := (others => (100 ps, 100 ps));
    tpd_CLKB_CASCADEOUTB : VitalDelayType01            := (100 ps, 100 ps);

--- VITAL recovery time 

    trecovery_GSR_CLKA_negedge_posedge : VitalDelayType                   := 0 ps;
    trecovery_GSR_CLKB_negedge_posedge : VitalDelayType                   := 0 ps;

--- VITAL setup time 

    tsetup_CASCADEINA_CLKA_negedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_CASCADEINA_CLKA_posedge_posedge    : VitalDelayType                   := 0 ps;

    thold_CASCADEINA_CLKA_negedge_posedge    : VitalDelayType                   := 0 ps;
    thold_CASCADEINA_CLKA_posedge_posedge    : VitalDelayType                   := 0 ps;

    tsetup_ADDRA_CLKA_negedge_posedge  : VitalDelayArrayType(14 downto 0) := (others => 0 ps);
    tsetup_ADDRA_CLKA_posedge_posedge  : VitalDelayArrayType(14 downto 0) := (others => 0 ps);
    tsetup_DIA_CLKA_negedge_posedge    : VitalDelayArrayType(31 downto 0) := (others => 0 ps);
    tsetup_DIA_CLKA_posedge_posedge    : VitalDelayArrayType(31 downto 0) := (others => 0 ps);
    tsetup_DIPA_CLKA_negedge_posedge   : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    tsetup_DIPA_CLKA_posedge_posedge   : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    tsetup_ENA_CLKA_negedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_ENA_CLKA_posedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_REGCEA_CLKA_negedge_posedge : VitalDelayType                   := 0 ps;
    tsetup_REGCEA_CLKA_posedge_posedge : VitalDelayType                   := 0 ps;
    tsetup_REGCEA_CLKA_posedge_negedge : VitalDelayType                   := 0 ps;
    tsetup_REGCEA_CLKA_negedge_negedge : VitalDelayType                   := 0 ps;
    tsetup_SSRA_CLKA_negedge_posedge   : VitalDelayType                   := 0 ps;
    tsetup_SSRA_CLKA_posedge_posedge   : VitalDelayType                   := 0 ps;
    tsetup_WEA_CLKA_negedge_posedge    : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    tsetup_WEA_CLKA_posedge_posedge    : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);

    tsetup_CASCADEINB_CLKB_negedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_CASCADEINB_CLKB_posedge_posedge    : VitalDelayType                   := 0 ps;

    thold_CASCADEINB_CLKB_negedge_posedge    : VitalDelayType                   := 0 ps;
    thold_CASCADEINB_CLKB_posedge_posedge    : VitalDelayType                   := 0 ps;

    tsetup_ADDRB_CLKB_negedge_posedge  : VitalDelayArrayType(14 downto 0) := (others => 0 ps);
    tsetup_ADDRB_CLKB_posedge_posedge  : VitalDelayArrayType(14 downto 0) := (others => 0 ps);
    tsetup_DIB_CLKB_negedge_posedge    : VitalDelayArrayType(31 downto 0) := (others => 0 ps);
    tsetup_DIB_CLKB_posedge_posedge    : VitalDelayArrayType(31 downto 0) := (others => 0 ps);
    tsetup_DIPB_CLKB_negedge_posedge   : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    tsetup_DIPB_CLKB_posedge_posedge   : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    tsetup_ENB_CLKB_negedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_ENB_CLKB_posedge_posedge    : VitalDelayType                   := 0 ps;
    tsetup_REGCEB_CLKB_negedge_posedge : VitalDelayType                   := 0 ps;
    tsetup_REGCEB_CLKB_posedge_posedge : VitalDelayType                   := 0 ps;
    tsetup_REGCEB_CLKB_posedge_negedge : VitalDelayType                   := 0 ps;
    tsetup_REGCEB_CLKB_negedge_negedge : VitalDelayType                   := 0 ps;
    tsetup_SSRB_CLKB_negedge_posedge   : VitalDelayType                   := 0 ps;
    tsetup_SSRB_CLKB_posedge_posedge   : VitalDelayType                   := 0 ps;
    tsetup_WEB_CLKB_negedge_posedge    : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    tsetup_WEB_CLKB_posedge_posedge    : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);

--- VITAL hold time 

    thold_ADDRA_CLKA_negedge_posedge  : VitalDelayArrayType(14 downto 0) := (others => 0 ps);
    thold_ADDRA_CLKA_posedge_posedge  : VitalDelayArrayType(14 downto 0) := (others => 0 ps);
    thold_DIA_CLKA_negedge_posedge    : VitalDelayArrayType(31 downto 0) := (others => 0 ps);
    thold_DIA_CLKA_posedge_posedge    : VitalDelayArrayType(31 downto 0) := (others => 0 ps);
    thold_DIPA_CLKA_negedge_posedge   : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    thold_DIPA_CLKA_posedge_posedge   : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    thold_ENA_CLKA_negedge_posedge    : VitalDelayType                   := 0 ps;
    thold_ENA_CLKA_posedge_posedge    : VitalDelayType                   := 0 ps;
    thold_GSR_CLKA_negedge_posedge    : VitalDelayType                   := 0 ps;
    thold_REGCEA_CLKA_negedge_posedge : VitalDelayType                   := 0 ps;
    thold_REGCEA_CLKA_posedge_posedge : VitalDelayType                   := 0 ps;
    thold_REGCEA_CLKA_posedge_negedge : VitalDelayType                   := 0 ps;
    thold_REGCEA_CLKA_negedge_negedge : VitalDelayType                   := 0 ps;
    thold_SSRA_CLKA_negedge_posedge   : VitalDelayType                   := 0 ps;
    thold_SSRA_CLKA_posedge_posedge   : VitalDelayType                   := 0 ps;
    thold_WEA_CLKA_negedge_posedge    : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    thold_WEA_CLKA_posedge_posedge    : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);

    thold_ADDRB_CLKB_negedge_posedge  : VitalDelayArrayType(14 downto 0) := (others => 0 ps);
    thold_ADDRB_CLKB_posedge_posedge  : VitalDelayArrayType(14 downto 0) := (others => 0 ps);
    thold_DIB_CLKB_negedge_posedge    : VitalDelayArrayType(31 downto 0) := (others => 0 ps);
    thold_DIB_CLKB_posedge_posedge    : VitalDelayArrayType(31 downto 0) := (others => 0 ps);
    thold_DIPB_CLKB_negedge_posedge   : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    thold_DIPB_CLKB_posedge_posedge   : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    thold_ENB_CLKB_negedge_posedge    : VitalDelayType                   := 0 ps;
    thold_ENB_CLKB_posedge_posedge    : VitalDelayType                   := 0 ps;
    thold_GSR_CLKB_negedge_posedge    : VitalDelayType                   := 0 ps;
    thold_REGCEB_CLKB_negedge_posedge : VitalDelayType                   := 0 ps;
    thold_REGCEB_CLKB_posedge_posedge : VitalDelayType                   := 0 ps;
    thold_REGCEB_CLKB_posedge_negedge : VitalDelayType                   := 0 ps;
    thold_REGCEB_CLKB_negedge_negedge : VitalDelayType                   := 0 ps;
    thold_SSRB_CLKB_negedge_posedge   : VitalDelayType                   := 0 ps;
    thold_SSRB_CLKB_posedge_posedge   : VitalDelayType                   := 0 ps;
    thold_WEB_CLKB_negedge_posedge    : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    thold_WEB_CLKB_posedge_posedge    : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);

    tbpd_GSR_DOA_CLKA  : VitalDelayArrayType01(31 downto 0) := (others => (0 ps, 0 ps));
    tbpd_GSR_DOPA_CLKA : VitalDelayArrayType01(3 downto 0)  := (others => (0 ps, 0 ps));
    tbpd_GSR_CASCADEOUTA_CLKA : VitalDelayType01            := (0 ps, 0 ps);

    ticd_CLKA          : VitalDelayType                     := 0 ps;
    tisd_ADDRA_CLKA    : VitalDelayArrayType(14 downto 0)   := (others => 0 ps);
    tisd_CASCADEINA_CLKA      : VitalDelayType                     := 0 ps;
    tisd_DIA_CLKA      : VitalDelayArrayType(31 downto 0)   := (others => 0 ps);
    tisd_DIPA_CLKA     : VitalDelayArrayType(3 downto 0)    := (others => 0 ps);
    tisd_ENA_CLKA      : VitalDelayType                     := 0 ps;
    tisd_GSR_CLKA      : VitalDelayType                     := 0 ps;
    tisd_REGCEA_CLKA   : VitalDelayType                     := 0 ps;
    tisd_SSRA_CLKA     : VitalDelayType                     := 0 ps;
    tisd_WEA_CLKA      : VitalDelayArrayType(3 downto 0)    := (others => 0 ps);

    tbpd_GSR_DOB_CLKB  : VitalDelayArrayType01(31 downto 0) := (others => (0 ps, 0 ps));
    tbpd_GSR_DOPB_CLKB : VitalDelayArrayType01(3 downto 0)  := (others => (0 ps, 0 ps));
    tbpd_GSR_CASCADEOUTB_CLKB : VitalDelayType01            := (0 ps, 0 ps);

    ticd_CLKB          : VitalDelayType                     := 0 ps;
    tisd_ADDRB_CLKB    : VitalDelayArrayType(14 downto 0)   := (others => 0 ps);
    tisd_CASCADEINB_CLKB     : VitalDelayType               := 0 ps;
    tisd_DIB_CLKB      : VitalDelayArrayType(31 downto 0)   := (others => 0 ps);
    tisd_DIPB_CLKB     : VitalDelayArrayType(3 downto 0)    := (others => 0 ps);
    tisd_ENB_CLKB      : VitalDelayType                     := 0 ps;
    tisd_GSR_CLKB      : VitalDelayType                     := 0 ps;
    tisd_REGCEB_CLKB   : VitalDelayType                     := 0 ps;
    tisd_SSRB_CLKB     : VitalDelayType                     := 0 ps;
    tisd_WEB_CLKB      : VitalDelayArrayType(3 downto 0)    := (others => 0 ps);

    tperiod_clka_posedge : VitalDelayType := 0 ps;
    tperiod_clkb_posedge : VitalDelayType := 0 ps;

    tpw_CLKA_negedge : VitalDelayType := 0 ps;
    tpw_CLKA_posedge : VitalDelayType := 0 ps;
    tpw_CLKB_negedge : VitalDelayType := 0 ps;
    tpw_CLKB_posedge : VitalDelayType := 0 ps;
    tpw_GSR_posedge  : VitalDelayType := 0 ps;

    DOA_REG : integer := 0 ;
    DOB_REG : integer := 0 ;

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
    INIT_FILE : string := "NONE";
    
    INITP_00 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_01 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_02 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_03 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_04 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_05 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_06 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INITP_07 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    
    INVERT_CLK_DOA_REG : boolean := FALSE;
    INVERT_CLK_DOB_REG : boolean := FALSE;

    RAM_EXTENSION_A : string := "NONE";
    RAM_EXTENSION_B : string := "NONE";

    READ_WIDTH_A : integer := 0;
    READ_WIDTH_B : integer := 0;

    EN_ECC_READ    : boolean := FALSE;
    EN_ECC_WRITE   : boolean := FALSE;

    SETUP_ALL : time := 1000 ps;
    SETUP_READ_FIRST : time := 3000 ps;

    SIM_COLLISION_CHECK : string := "ALL";

    SRVAL_A : bit_vector := X"000000000";
    SRVAL_B : bit_vector := X"000000000";

    WRITE_MODE_A : string := "WRITE_FIRST";
    WRITE_MODE_B : string := "WRITE_FIRST";

    WRITE_WIDTH_A : integer := 0;
    WRITE_WIDTH_B : integer := 0
    );

  port(
    CASCADEOUTA  : out  std_ulogic;
    CASCADEOUTB  : out  std_ulogic;
    DOA          : out std_logic_vector (31 downto 0);
    DOB          : out std_logic_vector (31 downto 0);
    DOPA         : out std_logic_vector (3 downto 0);
    DOPB         : out std_logic_vector (3 downto 0);

    ADDRA        : in  std_logic_vector (14 downto 0);
    ADDRB        : in  std_logic_vector (14 downto 0);
    CASCADEINA   : in  std_ulogic;
    CASCADEINB   : in  std_ulogic;
    CLKA         : in  std_ulogic;
    CLKB         : in  std_ulogic;
    DIA          : in  std_logic_vector (31 downto 0);
    DIB          : in  std_logic_vector (31 downto 0);
    DIPA         : in  std_logic_vector (3 downto 0);
    DIPB         : in  std_logic_vector (3 downto 0);
    ENA          : in  std_ulogic;
    ENB          : in  std_ulogic;
    REGCEA       : in  std_ulogic;
    REGCEB       : in  std_ulogic;
    SSRA         : in  std_ulogic;
    SSRB         : in  std_ulogic;
    WEA          : in  std_logic_vector (3 downto 0);
    WEB          : in  std_logic_vector (3 downto 0)
    );

  attribute VITAL_LEVEL0 of
    X_RAMB16 : entity is true;

end X_RAMB16;

architecture X_RAMB16_V of X_RAMB16 is

  attribute VITAL_LEVEL0 of
    X_RAMB16_V : architecture is true;

  component X_ARAMB36_INTERNAL
	generic
	(
          BRAM_MODE : string := "TRUE_DUAL_PORT";
          BRAM_SIZE : integer := 36;
          DOA_REG : integer := 0;
          DOB_REG : integer := 0;
          INIT_A : bit_vector := X"000000000000000000";
          INIT_B : bit_vector := X"000000000000000000";
          RAM_EXTENSION_A : string := "NONE";
          RAM_EXTENSION_B : string := "NONE";
          READ_WIDTH_A : integer := 0;
          READ_WIDTH_B : integer := 0;
          SIM_COLLISION_CHECK : string := "ALL";
          SRVAL_A : bit_vector := X"000000000000000000";
          SRVAL_B : bit_vector := X"000000000000000000";
          WRITE_MODE_A : string := "WRITE_FIRST";
          WRITE_MODE_B : string := "WRITE_FIRST";
          WRITE_WIDTH_A : integer := 0;
          WRITE_WIDTH_B : integer := 0;
          SETUP_ALL : time := 1000 ps;
          SETUP_READ_FIRST : time := 3000 ps;
          EN_ECC_READ : boolean := FALSE;
          EN_ECC_SCRUB : boolean := FALSE;
          EN_ECC_WRITE : boolean := FALSE;
          INIT_FILE : string := "NONE";
          
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
          INIT_40 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_41 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_42 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_43 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_44 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_45 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_46 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_47 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_48 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_49 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_4A : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_4B : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_4C : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_4D : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_4E : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_4F : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_50 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_51 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_52 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_53 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_54 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_55 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_56 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_57 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_58 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_59 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_5A : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_5B : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_5C : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_5D : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_5E : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_5F : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_60 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_61 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_62 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_63 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_64 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_65 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_66 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_67 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_68 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_69 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_6A : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_6B : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_6C : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_6D : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_6E : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_6F : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_70 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_71 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_72 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_73 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_74 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_75 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_76 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_77 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_78 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_79 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_7A : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_7B : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_7C : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_7D : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_7E : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INIT_7F : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INITP_00 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INITP_01 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INITP_02 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INITP_03 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INITP_04 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INITP_05 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INITP_06 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INITP_07 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INITP_08 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INITP_09 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INITP_0A : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INITP_0B : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INITP_0C : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INITP_0D : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INITP_0E : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
          INITP_0F : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000"
           );
	port
	(
          CASCADEOUTLATA : out std_ulogic;
          CASCADEOUTLATB : out std_ulogic;
          CASCADEOUTREGA : out std_ulogic;
          CASCADEOUTREGB : out std_ulogic;
          DBITERR : out std_ulogic;
          DOA : out std_logic_vector(63 downto 0);
          DOB : out std_logic_vector(63 downto 0);
          DOPA : out std_logic_vector(7 downto 0);
          DOPB : out std_logic_vector(7 downto 0);
          ECCPARITY : out std_logic_vector(7 downto 0);
          SBITERR : out std_ulogic;
    
          ADDRA : in std_logic_vector(15 downto 0);
          ADDRB : in std_logic_vector(15 downto 0);
          CASCADEINLATA : in std_ulogic;
          CASCADEINLATB : in std_ulogic;
          CASCADEINREGA : in std_ulogic;
          CASCADEINREGB : in std_ulogic;
          CLKA : in std_ulogic;
          CLKB : in std_ulogic;
          DIA : in std_logic_vector(63 downto 0);
          DIB : in std_logic_vector(63 downto 0);
          DIPA : in std_logic_vector(7 downto 0);
          DIPB : in std_logic_vector(7 downto 0);
          ENA : in std_ulogic;
          ENB : in std_ulogic;
          REGCEA : in std_ulogic;
          REGCEB : in std_ulogic;
          REGCLKA : in std_ulogic;
          REGCLKB : in std_ulogic;
          SSRA : in std_ulogic;
          SSRB : in std_ulogic;
          WEA : in std_logic_vector(7 downto 0);
          WEB : in std_logic_vector(7 downto 0)
 	);
  end component;
  
  constant MAX_ADDR: integer := 13;

  constant MAX_DI:   integer := 31;
  constant MAX_DIP:  integer := 3;
  constant MAX_WE:   integer := 3;

  signal ADDRA_ipd    : std_logic_vector(MAX_ADDR+1 downto 0) := (others => 'X');
  signal CLKA_ipd     : std_ulogic                          := 'X';
  signal DIA_ipd      : std_logic_vector(MAX_DI  downto 0)  := (others => 'X');
  signal DIPA_ipd     : std_logic_vector(MAX_DIP downto 0)  := (others => 'X');
  signal ENA_ipd      : std_ulogic                          := 'X';
  signal REGCEA_ipd   : std_ulogic                          := 'X';
  signal SSRA_ipd     : std_ulogic                          := 'X';
  signal WEA_ipd      : std_logic_vector(MAX_WE downto 0)   := (others => 'X');
  signal CASCADEINA_ipd      : std_ulogic                   := 'X';

  signal ADDRB_ipd    : std_logic_vector(MAX_ADDR+1 downto 0) := (others => 'X');
  signal CLKB_ipd     : std_ulogic                          := 'X';
  signal DIB_ipd      : std_logic_vector(MAX_DI  downto 0)  := (others => 'X');
  signal DIPB_ipd     : std_logic_vector(MAX_DIP downto 0)  := (others => 'X');
  signal ENB_ipd      : std_ulogic                          := 'X';
  signal REGCEB_ipd   : std_ulogic                          := 'X';
  signal SSRB_ipd     : std_ulogic                          := 'X';
  signal WEB_ipd      : std_logic_vector(MAX_WE downto 0)   := (others => 'X');
  signal CASCADEINB_ipd      : std_ulogic                   := 'X';

  signal GSR_ipd      : std_ulogic                          := 'X';

  signal GSR_dly      : std_ulogic                          := 'X';

  signal ADDRA_dly    : std_logic_vector(MAX_ADDR+1 downto 0) := (others => 'X');
  signal CLKA_dly     : std_ulogic                          := 'X';
  signal CLKA_tmp      : std_ulogic                          := 'X';
  signal DIA_dly      : std_logic_vector(MAX_DI downto 0) := (others => 'X');
  signal DIPA_dly     : std_logic_vector(MAX_DIP downto 0)  := (others => 'X');
  signal ENA_dly      : std_ulogic                          := 'X';
  signal GSR_CLKA_dly : std_ulogic                          := 'X';
  signal REGCEA_dly   : std_ulogic                          := 'X';
  signal SSRA_dly     : std_ulogic                          := 'X';
  signal WEA_dly      : std_logic_vector(MAX_WE downto 0)   := (others => 'X');
  signal CASCADEINA_dly      : std_ulogic                   := 'X';

  signal ADDRB_dly    : std_logic_vector(MAX_ADDR+1 downto 0) := (others => 'X');
  signal CLKB_dly     : std_ulogic                          := 'X';
  signal CLKB_tmp     : std_ulogic                          := 'X';
  signal DIB_dly      : std_logic_vector(MAX_DI downto 0) := (others => 'X');
  signal DIPB_dly     : std_logic_vector(MAX_DIP downto 0)  := (others => 'X');
  signal ENB_dly      : std_ulogic                          := 'X';
  signal GSR_CLKB_dly : std_ulogic                          := 'X';
  signal REGCEB_dly   : std_ulogic                          := 'X';
  signal SSRB_dly     : std_ulogic                          := 'X';
  signal WEB_dly      : std_logic_vector(MAX_WE downto 0)   := (others => 'X');
  signal CASCADEINB_dly      : std_ulogic                   := 'X';

  
  signal GND_4 : std_logic_vector(3 downto 0) := (others => '0');
  signal GND_32 : std_logic_vector(31 downto 0) := (others => '0');
  signal OPEN_4 : std_logic_vector(3 downto 0);
  signal OPEN_32 : std_logic_vector(31 downto 0);
  signal doa_zd : std_logic_vector(31 downto 0) :=  (others => '0');
  signal dob_zd : std_logic_vector(31 downto 0) :=  (others => '0');
  signal dopa_zd : std_logic_vector(3 downto 0) :=  (others => '0');
  signal dopb_zd : std_logic_vector(3 downto 0) :=  (others => '0');
  signal doa_wire : std_logic_vector(31 downto 0) :=  (others => '0');
  signal dob_wire : std_logic_vector(31 downto 0) :=  (others => '0');
  signal dopa_wire : std_logic_vector(3 downto 0) :=  (others => '0');
  signal dopb_wire : std_logic_vector(3 downto 0) :=  (others => '0');
  signal doa_outreg : std_logic_vector(31 downto 0) :=  (others => '0');
  signal dob_outreg : std_logic_vector(31 downto 0) :=  (others => '0');
  signal dopa_outreg : std_logic_vector(3 downto 0) :=  (others => '0');
  signal dopb_outreg : std_logic_vector(3 downto 0) :=  (others => '0');
  signal cascadeouta_zd : std_ulogic := '0';
  signal cascadeoutb_zd : std_ulogic := '0';
  signal cascadeoutlata_out : std_ulogic := '0';
  signal cascadeoutlatb_out : std_ulogic := '0';
  signal cascadeoutrega_out : std_ulogic := '0';
  signal cascadeoutregb_out : std_ulogic := '0';
  signal addra_int : std_logic_vector(15 downto 0) := (others => '0');
  signal addrb_int : std_logic_vector(15 downto 0) := (others => '0');
  signal wea_int : std_logic_vector(7 downto 0) := (others => '0');
  signal web_int : std_logic_vector(7 downto 0) := (others => '0');
  signal regclka_tmp : std_ulogic := '0';
  signal regclkb_tmp : std_ulogic := '0';
  signal dia_tmp : std_logic_vector(31 downto 0) :=  (others => '0');
  signal dib_tmp : std_logic_vector(31 downto 0) :=  (others => '0');
  signal dipa_tmp : std_logic_vector(3 downto 0) :=  (others => '0');
  signal dipb_tmp : std_logic_vector(3 downto 0) :=  (others => '0');
  signal ena_tmp : std_ulogic := '0';
  signal enb_tmp : std_ulogic := '0';
  signal ssra_tmp : std_ulogic := '0';
  signal ssrb_tmp : std_ulogic := '0';
  signal cascadeina_tmp : std_ulogic := '0';
  signal cascadeinb_tmp : std_ulogic := '0';
  signal regcea_tmp : std_ulogic := '0';
  signal regceb_tmp : std_ulogic := '0';
  
  
  function Invert_CLK (
    invert_clk_do_reg : boolean;
    do_reg : integer;
    clk : std_ulogic)
    return std_ulogic is variable out_clk : std_ulogic;
  begin

    if (do_reg = 1 and invert_clk_do_reg = TRUE) then
      out_clk := not clk;
    else
      out_clk := clk;
    end if;

    return out_clk;  
                         
  end;

  
  function Temp_BIT (
    clk : std_ulogic)
    return std_ulogic is variable out_clk : std_ulogic;
  begin

    out_clk := clk;
    return out_clk;  
    
  end;

  
  function Temp_BUS (
    d_in : std_logic_vector)
    return std_logic_vector is variable d_out : std_logic_vector(d_in'length-1 downto 0);
  begin

    d_out := d_in;
    return d_out;  
    
  end;

  
begin

  ---------------------
  --  INPUT PATH DELAYs
  --------------------

  WireDelay     : block
  begin

-----  Port A

    ADDRA_DELAY : for i in MAX_ADDR+1 downto 0 generate
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
    VitalWireDelay (REGCEA_ipd, REGCEA, tipd_REGCEA);
    VitalWireDelay (SSRA_ipd, SSRA, tipd_SSRA);
    VitalWireDelay (CASCADEINA_ipd, CASCADEINA, tipd_CASCADEINA);

-----  Port B

    ADDRB_DELAY : for i in MAX_ADDR+1 downto 0 generate
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
    VitalWireDelay (REGCEB_ipd, REGCEB, tipd_REGCEB);
    VitalWireDelay (SSRB_ipd, SSRB, tipd_SSRB);
    VitalWireDelay (CASCADEINB_ipd, CASCADEINB, tipd_CASCADEINB);

----- GSR

    VitalWireDelay (GSR_ipd, GSR, tipd_GSR);

  end block;

  SignalDelay   : block
  begin

-----  Port A

    ADDRA_DELAY : for i in MAX_ADDR+1 downto 0 generate
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
    VitalSignalDelay (REGCEA_dly, REGCEA_ipd, tisd_REGCEA_CLKA);
    VitalSignalDelay (SSRA_dly, SSRA_ipd, tisd_SSRA_CLKA);
    VitalSignalDelay (CASCADEINA_dly, CASCADEINA_ipd, tisd_CASCADEINA_CLKA);

-----  Port B   

    ADDRB_DELAY : for i in MAX_ADDR+1 downto 0 generate
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
    VitalSignalDelay (REGCEB_dly, REGCEB_ipd, tisd_REGCEB_CLKB);
    VitalSignalDelay (SSRB_dly, SSRB_ipd, tisd_SSRB_CLKB);
    VitalSignalDelay (CASCADEINB_dly, CASCADEINB_ipd, tisd_CASCADEINB_CLKB);

  end block;

  --------------------
  --  BEHAVIOR SECTION
  --------------------

  prcs_clk : process (clka_dly, clkb_dly, doa_wire, dob_wire, dopa_wire, dopb_wire)
    
    variable FIRST_TIME : boolean := true;

    begin
      
      if (FIRST_TIME) then

        if((INVERT_CLK_DOA_REG = true) and (DOA_REG /= 1 )) then
          assert false
            report "Attribute Syntax Error:  When INVERT_CLK_DOA_REG is set to TRUE, then DOA_REG has to be set to 1."
          severity Failure;
        end if;

        if((INVERT_CLK_DOB_REG = true) and (DOB_REG /= 1 )) then
          assert false
            report "Attribute Syntax Error:  When INVERT_CLK_DOB_REG is set to TRUE, then DOB_REG has to be set to 1."
          severity Failure;
        end if;

        if((INVERT_CLK_DOA_REG /= TRUE) and (INVERT_CLK_DOA_REG /= FALSE)) then
          assert false
            report "Attribute Syntax Error : The allowed boolean values for INVERT_CLK_DOA_REG are TRUE or FALSE"
          severity Failure;
        end if;
        
        if((INVERT_CLK_DOB_REG /= TRUE) and (INVERT_CLK_DOB_REG /= FALSE)) then
          assert false
            report "Attribute Syntax Error : The allowed boolean values for INVERT_CLK_DOB_REG are TRUE or FALSE"
          severity Failure;
        end if;
        
        FIRST_TIME := false;

      end if;

      
      if (DOA_REG = 1 and INVERT_CLK_DOA_REG = TRUE) then

        if (falling_edge(clka_dly) or doa_wire'event or dopa_wire'event) then

          if (EN_ECC_READ = TRUE) then
	    
            doa_outreg <= doa_wire;
            doa_zd <= doa_outreg;
            dopa_outreg <= dopa_wire;
            dopa_zd <= dopa_outreg;

          else
            doa_zd <= doa_wire;
            dopa_zd <= dopa_wire;
          end if;

        end if;

      elsif (INVERT_CLK_DOA_REG = FALSE) then

        if (rising_edge(clka_dly) or doa_wire'event or dopa_wire'event) then

          if (EN_ECC_READ = TRUE) then
	    
            doa_outreg <= doa_wire;
	    doa_zd <= doa_outreg;
	    dopa_outreg <= dopa_wire;
	    dopa_zd <= dopa_outreg;

          else
	    doa_zd <= doa_wire;
	    dopa_zd <= dopa_wire;
          end if;

        end if;

      end if;

      
      if (DOB_REG = 1 and INVERT_CLK_DOB_REG = TRUE) then

        if (falling_edge(clkb_dly) or dob_wire'event or dopb_wire'event) then

          if (EN_ECC_READ = TRUE) then
	    
            dob_outreg <= dob_wire;
            dob_zd <= dob_outreg;
            dopb_outreg <= dopb_wire;
            dopb_zd <= dopb_outreg;

          else
            dob_zd <= dob_wire;
            dopb_zd <= dopb_wire;
          end if;

        end if;

      elsif (INVERT_CLK_DOB_REG = FALSE) then
          
        if (rising_edge(clkb_dly) or dob_wire'event or dopb_wire'event) then

          if (EN_ECC_READ = TRUE) then
	    
            dob_outreg <= dob_wire;
	    dob_zd <= dob_outreg;
	    dopb_outreg <= dopb_wire;
	    dopb_zd <= dopb_outreg;

          else
	    dob_zd <= dob_wire;
	    dopb_zd <= dopb_wire;
          end if;

        end if;

      end if;

    end process prcs_clk;


    prcs_cascadea: process (cascadeoutrega_out, cascadeoutlata_out)

      begin
        
        if (DOA_REG = 1) then
          CASCADEOUTA_zd <= cascadeoutrega_out;
        else
          CASCADEOUTA_zd <= cascadeoutlata_out;  
        end if;

    end process prcs_cascadea;

    
    prcs_cascadeb: process (cascadeoutregb_out, cascadeoutlatb_out)

      begin
        if (DOB_REG = 1) then
          CASCADEOUTB_zd <= cascadeoutregb_out;
        else
          CASCADEOUTB_zd <= cascadeoutlatb_out;  
        end if;

    end process prcs_cascadeb;
    
        
    addra_int <= ADDRA_dly(14) & '0' & ADDRA_dly(13 downto 0);
    addrb_int <= ADDRB_dly(14) & '0' & ADDRB_dly(13 downto 0);
    wea_int <= WEA_dly & WEA_dly;
    web_int <= WEB_dly & WEB_dly;
    regclka_tmp <= Invert_CLK(INVERT_CLK_DOA_REG, DOA_REG, CLKA_dly);
    regclkb_tmp <= Invert_CLK(INVERT_CLK_DOB_REG, DOB_REG, CLKB_dly);
    clka_tmp <= Temp_BIT(CLKA_dly);
    clkb_tmp <= Temp_BIT(CLKB_dly);
    dia_tmp <= Temp_BUS(DIA_dly);
    dib_tmp <= Temp_BUS(DIB_dly);
    dipa_tmp <= Temp_BUS(DIPA_dly);
    dipb_tmp <= Temp_BUS(DIPB_dly); 
    cascadeina_tmp <= Temp_BIT(CASCADEINA_dly);
    cascadeinb_tmp <= Temp_BIT(CASCADEINB_dly);
    ena_tmp <= Temp_BIT(ENA_dly);
    enb_tmp <= Temp_BIT(ENB_dly);
    ssra_tmp <= Temp_BIT(SSRA_dly);
    ssrb_tmp <= Temp_BIT(SSRB_dly);
    regcea_tmp <= Temp_BIT(REGCEA_dly);
    regceb_tmp <= Temp_BIT(REGCEB_dly);
    
    
X_RAMB16_inst : X_ARAMB36_INTERNAL
	generic map (

                DOA_REG => DOA_REG,
                DOB_REG => DOB_REG,
		INIT_A  => INIT_A,
		INIT_B  => INIT_B,
                INIT_FILE => INIT_FILE,
                
		INIT_00 => INIT_00,
		INIT_01 => INIT_01,
		INIT_02 => INIT_02,
		INIT_03 => INIT_03,
		INIT_04 => INIT_04,
		INIT_05 => INIT_05,
		INIT_06 => INIT_06,
		INIT_07 => INIT_07,
		INIT_08 => INIT_08,
		INIT_09 => INIT_09,
		INIT_0A => INIT_0A,
		INIT_0B => INIT_0B,
		INIT_0C => INIT_0C,
		INIT_0D => INIT_0D,
		INIT_0E => INIT_0E,
		INIT_0F => INIT_0F,
		INIT_10 => INIT_10,
		INIT_11 => INIT_11,
		INIT_12 => INIT_12,
		INIT_13 => INIT_13,
		INIT_14 => INIT_14,
		INIT_15 => INIT_15,
		INIT_16 => INIT_16,
		INIT_17 => INIT_17,
		INIT_18 => INIT_18,
		INIT_19 => INIT_19,
		INIT_1A => INIT_1A,
		INIT_1B => INIT_1B,
		INIT_1C => INIT_1C,
		INIT_1D => INIT_1D,
		INIT_1E => INIT_1E,
		INIT_1F => INIT_1F,
		INIT_20 => INIT_20,
		INIT_21 => INIT_21,
		INIT_22 => INIT_22,
		INIT_23 => INIT_23,
		INIT_24 => INIT_24,
		INIT_25 => INIT_25,
		INIT_26 => INIT_26,
		INIT_27 => INIT_27,
		INIT_28 => INIT_28,
		INIT_29 => INIT_29,
		INIT_2A => INIT_2A,
		INIT_2B => INIT_2B,
		INIT_2C => INIT_2C,
		INIT_2D => INIT_2D,
		INIT_2E => INIT_2E,
		INIT_2F => INIT_2F,
		INIT_30 => INIT_30,
		INIT_31 => INIT_31,
		INIT_32 => INIT_32,
		INIT_33 => INIT_33,
		INIT_34 => INIT_34,
		INIT_35 => INIT_35,
		INIT_36 => INIT_36,
		INIT_37 => INIT_37,
		INIT_38 => INIT_38,
		INIT_39 => INIT_39,
		INIT_3A => INIT_3A,
		INIT_3B => INIT_3B,
		INIT_3C => INIT_3C,
		INIT_3D => INIT_3D,
		INIT_3E => INIT_3E,
		INIT_3F => INIT_3F,
                
		INITP_00 => INITP_00,
		INITP_01 => INITP_01,
		INITP_02 => INITP_02,
		INITP_03 => INITP_03,
		INITP_04 => INITP_04,
		INITP_05 => INITP_05,
		INITP_06 => INITP_06,
		INITP_07 => INITP_07,

                EN_ECC_READ => EN_ECC_READ,
                EN_ECC_WRITE => EN_ECC_WRITE,
		SIM_COLLISION_CHECK => SIM_COLLISION_CHECK,
		SRVAL_A => SRVAL_A,
		SRVAL_B => SRVAL_B,
		WRITE_MODE_A => WRITE_MODE_A,
		WRITE_MODE_B => WRITE_MODE_B,                
                BRAM_MODE => "TRUE_DUAL_PORT",
                BRAM_SIZE => 16,
                RAM_EXTENSION_A => RAM_EXTENSION_A,
                RAM_EXTENSION_B => RAM_EXTENSION_B,                
                READ_WIDTH_A => READ_WIDTH_A,
                READ_WIDTH_B => READ_WIDTH_B,
                SETUP_ALL => SETUP_ALL,
                SETUP_READ_FIRST => SETUP_READ_FIRST,
                WRITE_WIDTH_A => WRITE_WIDTH_A,
                WRITE_WIDTH_B => WRITE_WIDTH_B
          
                )
        port map (
                ADDRA => addra_int,
                ADDRB => addrb_int,
                CLKA => clka_tmp,
                CLKB => clkb_tmp,
                DIA(31 downto 0)  => DIA_tmp,
                DIA(63 downto 32) => GND_32,
                DIB(31 downto 0) => DIB_tmp,
                DIB(63 downto 32) => GND_32,
                DIPA(3 downto 0) => DIPA_tmp,
                DIPA(7 downto 4) => GND_4,
                DIPB(3 downto 0) => DIPB_tmp,
                DIPB(7 downto 4) => GND_4,
                ENA => ENA_tmp,
                ENB => ENB_tmp,
                SSRA => SSRA_tmp,
                SSRB => SSRB_tmp,
                WEA => wea_int,
                WEB => web_int,
                DOA(31  downto 0) => doa_wire,
                DOA(63 downto 32) => OPEN_32,
                DOB(31 downto 0) => dob_wire,
                DOB(63 downto 32) => OPEN_32,
                DOPA(3 downto 0) => dopa_wire,
                DOPA(7 downto 4) => OPEN_4,
                DOPB(3 downto 0) => dopb_wire,
                DOPB(7 downto 4) => OPEN_4,
                CASCADEOUTLATA => cascadeoutlata_out,
                CASCADEOUTLATB => cascadeoutlatb_out,
                CASCADEOUTREGA => cascadeoutrega_out,
                CASCADEOUTREGB => cascadeoutregb_out,
                CASCADEINLATA => CASCADEINA_tmp,
                CASCADEINLATB => CASCADEINB_tmp,
                CASCADEINREGA => CASCADEINA_tmp,
                CASCADEINREGB => CASCADEINB_tmp,
                REGCLKA => regclka_tmp,
                REGCLKB => regclkb_tmp,
                REGCEA => REGCEA_tmp,
                REGCEB => REGCEB_tmp
        );


  
   prcs_output:process (CASCADEOUTA_zd, CASCADEOUTB_zd, DOA_zd, DOPA_zd, DOB_zd, DOPB_zd)

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
    variable CASCADEOUTA_GlitchData : VitalGlitchDataType;

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
    variable CASCADEOUTB_GlitchData : VitalGlitchDataType;

   begin

    ENA_dly_sampled   := ENA_dly;
    ENB_dly_sampled   := ENB_dly;

    VitalPathDelay01 (
      OutSignal     => CASCADEOUTA,
      GlitchData    => CASCADEOUTA_GlitchData,
      OutSignalName => "CASCADEOUTA",
      OutTemp       => CASCADEOUTA_zd,
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_CASCADEOUTA, (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1')),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_CASCADEOUTA, true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
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
      OutSignal     => DOA(4),
      GlitchData    => DOA_GlitchData4,
      OutSignalName => "DOA(4)",
      OutTemp       => DOA_zd(4),
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
      OutTemp       => DOA_zd(5),
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
      OutTemp       => DOA_zd(6),
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
      OutTemp       => DOA_zd(7),
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
      OutTemp       => DOA_zd(8),
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
      OutTemp       => DOA_zd(9),
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
      OutTemp       => DOA_zd(10),
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
      OutTemp       => DOA_zd(11),
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
      OutTemp       => DOA_zd(12),
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
      OutTemp       => DOA_zd(13),
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
      OutTemp       => DOA_zd(14),
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
      OutTemp       => DOA_zd(15),
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
      OutTemp       => DOA_zd(16),
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
      OutTemp       => DOA_zd(17),
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
      OutTemp       => DOA_zd(18),
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
      OutTemp       => DOA_zd(19),
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
      OutTemp       => DOA_zd(20),
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
      OutTemp       => DOA_zd(21),
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
      OutTemp       => DOA_zd(22),
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
      OutTemp       => DOA_zd(23),
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
      OutTemp       => DOA_zd(24),
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
      OutTemp       => DOA_zd(25),
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
      OutTemp       => DOA_zd(26),
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
      OutTemp       => DOA_zd(27),
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
      OutTemp       => DOA_zd(28),
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
      OutTemp       => DOA_zd(29),
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
      OutTemp       => DOA_zd(30),
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
      OutTemp       => DOA_zd(31),
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
      OutTemp       => DOPA_zd(0),
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
      OutTemp       => DOPA_zd(1),
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
      OutTemp       => DOPA_zd(2),
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
      OutTemp       => DOPA_zd(3),
      Paths         => (0 => (CLKA_dly'last_event, tpd_CLKA_DOPA(3), (ena_dly_sampled /= '0' and GSR_CLKA_dly /= '1' )),
                        1 => (GSR_CLKA_dly'last_event, tpd_GSR_DOPA(3), true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);

----- Port B
    VitalPathDelay01 (
      OutSignal     => CASCADEOUTB,
      GlitchData    => CASCADEOUTB_GlitchData,
      OutSignalName => "CASCADEOUTB",
      OutTemp       => CASCADEOUTB_zd,
      Paths         => (0 => (CLKB_dly'last_event, tpd_CLKB_CASCADEOUTB, (enb_dly_sampled /= '0' and GSR_CLKB_dly /= '1')),
                        1 => (GSR_CLKB_dly'last_event, tpd_GSR_CASCADEOUTB, true)),
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
   end process prcs_output;

end X_RAMB16_V;

-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  Dual Data Rate Input D Flip-Flop
-- /___/   /\     Filename : X_IDDR2.vhd
-- \   \  /  \    Timestamp : Fri Mar 26 08:18:20 PST 2004
--  \___\/\___\
--
-- Revision:
--    03/23/04 - Initial version.

----- CELL X_IDDR2 -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;


library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.Vcomponents.all;
use simprim.VPACKAGE.all;

entity X_IDDR2 is

  generic(

      TimingChecksOn : boolean := true;
      InstancePath   : string  := "*";
      Xon            : boolean := true;
      MsgOn          : boolean := true;
      LOC            : string  := "UNPLACED";

-- workaround for scirocco
      tbpd_GSR_Q0_C0 : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tbpd_R_Q0_C0 : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tbpd_S_Q0_C0 : VitalDelayType01 := (0.000 ns, 0.000 ns);

      tbpd_GSR_Q1_C1 : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tbpd_R_Q1_C1 : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tbpd_S_Q1_C1 : VitalDelayType01 := (0.000 ns, 0.000 ns);

--  VITAL input Pin path delay variables
      tipd_C0   : VitalDelayType01 := (0 ps, 0 ps);
      tipd_C1   : VitalDelayType01 := (0 ps, 0 ps);  
      tipd_CE   : VitalDelayType01 := (0 ps, 0 ps);
      tipd_D    : VitalDelayType01 := (0 ps, 0 ps);
      tipd_GSR  : VitalDelayType01 := (0 ps, 0 ps);
      tipd_R    : VitalDelayType01 := (0 ps, 0 ps);
      tipd_S    : VitalDelayType01 := (0 ps, 0 ps);

--  VITAL clk-to-output path delay variables
      tpd_C0_Q0  : VitalDelayType01 := (100 ps, 100 ps);
      tpd_C0_Q1  : VitalDelayType01 := (100 ps, 100 ps);
      tpd_C1_Q0  : VitalDelayType01 := (100 ps, 100 ps);
      tpd_C1_Q1  : VitalDelayType01 := (100 ps, 100 ps);
  
--  VITAL async rest-to-output path delay variables
      tpd_R_Q0 : VitalDelayType01 := (0 ps, 0 ps);
      tpd_R_Q1 : VitalDelayType01 := (0 ps, 0 ps);

--  VITAL async set-to-output path delay variables
      tpd_S_Q0 : VitalDelayType01 := (0 ps, 0 ps);
      tpd_S_Q1 : VitalDelayType01 := (0 ps, 0 ps);

--  VITAL GSR-to-output path delay variable
      tpd_GSR_Q0 : VitalDelayType01 := (0 ps, 0 ps);
      tpd_GSR_Q1 : VitalDelayType01 := (0 ps, 0 ps);


--  VITAL ticd & tisd variables
      ticd_C0     : VitalDelayType   := 0.0 ps;
      ticd_C1     : VitalDelayType   := 0.0 ps;
      tisd_D_C0   : VitalDelayType   := 0.0 ps;
      tisd_D_C1   : VitalDelayType   := 0.0 ps;
      tisd_CE_C0  : VitalDelayType   := 0.0 ps;
      tisd_CE_C1  : VitalDelayType   := 0.0 ps;
      tisd_GSR_C0 : VitalDelayType   := 0.0 ps;
      tisd_GSR_C1 : VitalDelayType   := 0.0 ps;
      tisd_R_C0   : VitalDelayType   := 0.0 ps;
      tisd_R_C1   : VitalDelayType   := 0.0 ps;
      tisd_S_C0   : VitalDelayType   := 0.0 ps;
      tisd_S_C1   : VitalDelayType   := 0.0 ps;

--  VITAL Setup/Hold delay variables
      tsetup_CE_C0_posedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_CE_C0_negedge_posedge : VitalDelayType := 0.0 ps;
      thold_CE_C0_posedge_posedge  : VitalDelayType := 0.0 ps;
      thold_CE_C0_negedge_posedge  : VitalDelayType := 0.0 ps;
      tsetup_CE_C1_posedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_CE_C1_negedge_posedge : VitalDelayType := 0.0 ps;
      thold_CE_C1_posedge_posedge  : VitalDelayType := 0.0 ps;
      thold_CE_C1_negedge_posedge  : VitalDelayType := 0.0 ps;

      tsetup_D_C0_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_D_C0_negedge_posedge : VitalDelayType := 0 ps;
      thold_D_C0_posedge_posedge  : VitalDelayType := 0 ps;
      thold_D_C0_negedge_posedge  : VitalDelayType := 0 ps;
      tsetup_D_C1_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_D_C1_negedge_posedge : VitalDelayType := 0 ps;
      thold_D_C1_posedge_posedge  : VitalDelayType := 0 ps;
      thold_D_C1_negedge_posedge  : VitalDelayType := 0 ps;

      tsetup_R_C0_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_R_C0_negedge_posedge : VitalDelayType := 0 ps;
      thold_R_C0_posedge_posedge  : VitalDelayType := 0 ps;
      thold_R_C0_negedge_posedge  : VitalDelayType := 0 ps;
      tsetup_R_C1_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_R_C1_negedge_posedge : VitalDelayType := 0 ps;
      thold_R_C1_posedge_posedge  : VitalDelayType := 0 ps;
      thold_R_C1_negedge_posedge  : VitalDelayType := 0 ps;
  
      tsetup_S_C0_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_S_C0_negedge_posedge : VitalDelayType := 0 ps;
      thold_S_C0_posedge_posedge  : VitalDelayType := 0 ps;
      thold_S_C0_negedge_posedge  : VitalDelayType := 0 ps;
      tsetup_S_C1_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_S_C1_negedge_posedge : VitalDelayType := 0 ps;
      thold_S_C1_posedge_posedge  : VitalDelayType := 0 ps;
      thold_S_C1_negedge_posedge  : VitalDelayType := 0 ps;

-- VITAL pulse width variables

      tpw_C0_negedge             : VitalDelayType := 0 ps;
      tpw_C0_posedge             : VitalDelayType := 0 ps;
      tpw_C1_negedge             : VitalDelayType := 0 ps;
      tpw_C1_posedge             : VitalDelayType := 0 ps;
      tpw_GSR_posedge            : VitalDelayType := 0 ps;
      tpw_R_posedge              : VitalDelayType := 0 ps;
      tpw_S_posedge              : VitalDelayType := 0 ps;

-- VITAL period variables
      tperiod_C0_posedge          : VitalDelayType := 0 ps;
      tperiod_C1_posedge          : VitalDelayType := 0 ps;  

-- VITAL recovery time variables
      trecovery_GSR_C0_negedge_posedge : VitalDelayType := 0 ps;
      trecovery_R_C0_negedge_posedge   : VitalDelayType := 0 ps;
      trecovery_S_C0_negedge_posedge   : VitalDelayType := 0 ps;
      trecovery_GSR_C1_negedge_posedge : VitalDelayType := 0 ps;
      trecovery_R_C1_negedge_posedge   : VitalDelayType := 0 ps;
      trecovery_S_C1_negedge_posedge   : VitalDelayType := 0 ps;

-- VITAL removal time variables
      tremoval_GSR_C0_negedge_posedge  : VitalDelayType := 0 ps;
      tremoval_R_C0_negedge_posedge    : VitalDelayType := 0 ps;
      tremoval_S_C0_negedge_posedge    : VitalDelayType := 0 ps;
      tremoval_GSR_C1_negedge_posedge  : VitalDelayType := 0 ps;
      tremoval_R_C1_negedge_posedge    : VitalDelayType := 0 ps;
      tremoval_S_C1_negedge_posedge    : VitalDelayType := 0 ps;
  

      DDR_ALIGNMENT : string := "NONE";
      INIT_Q0       : bit    := '0';
      INIT_Q1       : bit    := '0';
      SRTYPE        : string := "SYNC"
      );

  port(
      Q0          : out std_ulogic;
      Q1          : out std_ulogic;

      C0          : in  std_ulogic;
      C1          : in  std_ulogic;
      CE          : in  std_ulogic;
      D           : in  std_ulogic;
      R           : in  std_ulogic;
      S           : in  std_ulogic
    );

  attribute VITAL_LEVEL0 of
    X_IDDR2 : entity is true;

end X_IDDR2;

architecture X_IDDR2_V OF X_IDDR2 is

  attribute VITAL_LEVEL0 of
    X_IDDR2_V : architecture is true;


  constant SYNC_PATH_DELAY : time := 100 ps;

  signal C0_ipd	        : std_ulogic := 'X';
  signal C1_ipd	        : std_ulogic := 'X';
  signal CE_ipd	        : std_ulogic := 'X';
  signal D_ipd	        : std_ulogic := 'X';
  signal GSR_ipd	: std_ulogic := 'X';
  signal R_ipd		: std_ulogic := 'X';
  signal S_ipd		: std_ulogic := 'X';

  signal C0_dly	        : std_ulogic := 'X';
  signal C1_dly	        : std_ulogic := 'X';
  signal CE_dly	        : std_ulogic := 'X';
  signal D_dly	        : std_ulogic := 'X';
  signal GSR_dly	: std_ulogic := 'X';
  signal R_dly		: std_ulogic := 'X';
  signal S_dly		: std_ulogic := 'X';

  signal Q0_zd	        : std_ulogic := 'X';
  signal Q1_zd	        : std_ulogic := 'X';

  signal Q0_viol        : std_ulogic := 'X';
  signal Q1_viol        : std_ulogic := 'X';

  signal q0_o_reg	: std_ulogic := 'X';
  signal q0_c1_o_reg	: std_ulogic := 'X';
  signal q1_o_reg	: std_ulogic := 'X';
  signal q1_c0_o_reg	: std_ulogic := 'X';

  signal ddr_alignment_type	: integer := -999;
  signal sr_type		: integer := -999;
  
begin

  ---------------------
  --  INPUT PATH DELAYs
  --------------------

  WireDelay : block
  begin
    VitalWireDelay (C0_ipd,  C0,  tipd_C0);
    VitalWireDelay (C1_ipd,  C1,  tipd_C1);
    VitalWireDelay (CE_ipd,  CE,  tipd_CE);
    VitalWireDelay (D_ipd,   D,   tipd_D);
    VitalWireDelay (GSR_ipd, GSR, tipd_GSR);
    VitalWireDelay (R_ipd,   R,   tipd_R);
    VitalWireDelay (S_ipd,   S,   tipd_S);
  end block;

  SignalDelay : block
  begin
    VitalSignalDelay (C0_dly,  C0_ipd,  ticd_C0);
    VitalSignalDelay (C1_dly,  C1_ipd,  ticd_C1);
    VitalSignalDelay (CE_dly,  CE_ipd,  ticd_C0);
    VitalSignalDelay (D_dly,   D_ipd,  ticd_C0);
    VitalSignalDelay (GSR_dly, GSR_ipd, tisd_GSR_C0);
    VitalSignalDelay (R_dly,   R_ipd,   tisd_R_C0);
    VitalSignalDelay (S_dly,   S_ipd,   tisd_S_C0);
  end block;

  --------------------
  --  BEHAVIOR SECTION
  --------------------


--####################################################################
--#####                     Initialize                           #####
--####################################################################
  prcs_init:process

  begin
      if((DDR_ALIGNMENT = "NONE") or (DDR_ALIGNMENT = "none")) then
         ddr_alignment_type <= 1;
      elsif((DDR_ALIGNMENT = "C0") or (DDR_ALIGNMENT = "c0")) then
         ddr_alignment_type <= 2;
      elsif((DDR_ALIGNMENT = "C1") or (DDR_ALIGNMENT = "c1")) then
         ddr_alignment_type <= 3;
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Error ",
             GenericName => " DDR_ALIGNMENT ",
             EntityName => "/IDDR2",
             GenericValue => DDR_ALIGNMENT,
             Unit => "",
             ExpectedValueMsg => " The Legal values for this attribute are ",
             ExpectedGenericValue => " NONE or C0 or C1.",
             TailMsg => "",
             MsgSeverity => ERROR 
         );
      end if;

      if((SRTYPE = "ASYNC") or (SRTYPE = "async")) then
         sr_type <= 1;
      elsif((SRTYPE = "SYNC") or (SRTYPE = "sync")) then
         sr_type <= 2;
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Error ",
             GenericName => " SRTYPE ",
             EntityName => "/IDDR2",
             GenericValue => SRTYPE,
             Unit => "",
             ExpectedValueMsg => " The Legal values for this attribute are ",
             ExpectedGenericValue => " ASYNC or SYNC. ",
             TailMsg => "",
             MsgSeverity => ERROR
         );
      end if;

     wait;
  end process prcs_init;
--####################################################################
--#####                    functionality                         #####
--####################################################################
  prcs_func_reg:process(C0_dly, C1_dly, D_dly, GSR_dly, R_dly, S_dly)
  variable FIRST_TIME : boolean := true;
  variable q0_out_var : std_ulogic := TO_X01(INIT_Q0);
  variable q1_out_var : std_ulogic := TO_X01(INIT_Q1);
  variable q0_c1_out_var : std_ulogic := TO_X01(INIT_Q0);
  variable q1_c0_out_var : std_ulogic := TO_X01(INIT_Q1);
  begin
     if((GSR_dly = '1') or (FIRST_TIME)) then
       q0_out_var := TO_X01(INIT_Q0);
       q1_out_var := TO_X01(INIT_Q1);
       q0_c1_out_var := TO_X01(INIT_Q0);
       q1_c0_out_var := TO_X01(INIT_Q1);
       FIRST_TIME := false;
     else
        case sr_type is
           when 1 => 
                   if(R_dly = '1') then
                     q0_out_var := '0';
                     q1_out_var := '0';
                     q1_c0_out_var := '0';
                     q0_c1_out_var := '0';                     
                   elsif((R_dly = '0') and (S_dly = '1')) then
                     q0_out_var := '1';
                     q1_out_var := '1';
                     q1_c0_out_var := '1';
                     q0_c1_out_var := '1';
                   elsif((R_dly = '0') and (S_dly = '0')) then
                      if(CE_dly = '1') then
                         if(rising_edge(C0_dly)) then
                           q0_out_var := D_dly;
                           q1_c0_out_var := q1_out_var;
                         end if;
                         if(rising_edge(C1_dly)) then
                           q1_out_var := D_dly;
                           q0_c1_out_var := q0_out_var;
                         end if;
                      end if;
                   end if;

           when 2 => 
                   if(rising_edge(C0_dly)) then
                      if(R_dly = '1') then
                        q0_out_var := '0';
                        q1_c0_out_var := '0';
                      elsif((R_dly = '0') and (S_dly = '1')) then
                        q0_out_var := '1';
                        q1_c0_out_var := '1';
                      elsif((R_dly = '0') and (S_dly = '0')) then
                         if(CE_dly = '1') then
                           q0_out_var := D_dly;
                           q1_c0_out_var := q1_out_var;
                         end if;
                      end if;
                   end if;
                        
                   if(rising_edge(C1_dly)) then
                      if(R_dly = '1') then
                        q1_out_var := '0';
                        q0_c1_out_var := '0';
                      elsif((R_dly = '0') and (S_dly = '1')) then
                        q1_out_var := '1';
                        q0_c1_out_var := '1';
                      elsif((R_dly = '0') and (S_dly = '0')) then
                         if(CE_dly = '1') then
                           q1_out_var := D_dly;
                           q0_c1_out_var := q0_out_var;
                         end if;
                      end if;
                   end if;
 
           when others =>
                   null; 
        end case;
     end if;
         
     q0_o_reg <= q0_out_var;
     q1_o_reg <= q1_out_var;
     q0_c1_o_reg <= q0_c1_out_var;
     q1_c0_o_reg <= q1_c0_out_var;

  end process prcs_func_reg;
--####################################################################
--#####                        output mux                        #####
--####################################################################
  prcs_output_mux:process(q0_o_reg, q1_o_reg, q0_c1_o_reg, q1_c0_o_reg)
  begin
     case ddr_alignment_type is
       when 1 => 
                 Q0_zd <= q0_o_reg;
                 Q1_zd <= q1_o_reg;
       when 2 => 
                 Q0_zd <= q0_o_reg;
                 Q1_zd <= q1_c0_o_reg;
       when 3 => 
                 Q0_zd <= q0_c1_o_reg;
                 Q1_zd <= q1_o_reg;
       when others =>
                 null;
     end case;
  end process prcs_output_mux;
--####################################################################

--####################################################################
--#####                   TIMING CHECKS & OUTPUT                 #####
--####################################################################
  prcs_tmngchk:process

  variable PInfo_R : VitalPeriodDataType := VitalPeriodDataInit;
  variable Pviol_R : std_ulogic          := '0';

  variable PInfo_S : VitalPeriodDataType := VitalPeriodDataInit;
  variable Pviol_S : std_ulogic          := '0';

  variable Pviol_C0 :  std_ulogic          := '0';
  variable PInfo_C0 :  VitalPeriodDataType := VitalPeriodDataInit;
  variable Pviol_C1 :  std_ulogic          := '0';
  variable PInfo_C1 :  VitalPeriodDataType := VitalPeriodDataInit;
  
  variable Tmkr_CE_C0_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_CE_C0_posedge : std_ulogic := '0';

  variable Tmkr_CE_C1_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_CE_C1_posedge : std_ulogic := '0';

  variable Tmkr_D_C0_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_D_C0_posedge : std_ulogic := '0';

  variable Tmkr_D_C1_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_D_C1_posedge : std_ulogic := '0';

  variable Tmkr_R_C0_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_R_C0_posedge : std_ulogic := '0';

  variable Tmkr_R_C1_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_R_C1_posedge : std_ulogic := '0';

  variable Tmkr_S_C0_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_S_C0_posedge : std_ulogic := '0';

  variable Tmkr_S_C1_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_S_C1_posedge : std_ulogic := '0';

  variable Tmkr_GSR_C0_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_GSR_C0_posedge : std_ulogic := '0';

  variable Tmkr_GSR_C1_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_GSR_C1_posedge : std_ulogic := '0';

  variable Violation          : std_ulogic          := '0';

  begin
    if (TimingChecksOn) then
       VitalSetupHoldCheck (
         Violation            => Tviol_CE_C0_posedge,
         TimingData           => Tmkr_CE_C0_posedge,
         TestSignal           => CE_dly,
         TestSignalName       => "CE",
         TestDelay            => tisd_CE_C0,
         RefSignal            => C0_dly,
         RefSignalName        => "C0",
         RefDelay             => ticd_C0,
         SetupHigh            => tsetup_CE_C0_posedge_posedge,
         SetupLow             => tsetup_CE_C0_negedge_posedge,
         HoldHigh             => thold_CE_C0_posedge_posedge,
         HoldLow              => thold_CE_C0_negedge_posedge,
         CheckEnabled         => true,
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_IDDR2",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => Error);
--=====  Vital SetupHold Check for signal CE =====
       VitalSetupHoldCheck (
         Violation            => Tviol_CE_C1_posedge,
         TimingData           => Tmkr_CE_C1_posedge,
         TestSignal           => CE_dly,
         TestSignalName       => "CE",
         TestDelay            => tisd_CE_C1,
         RefSignal            => C1_dly,
         RefSignalName        => "C1",
         RefDelay             => ticd_C1,
         SetupHigh            => tsetup_CE_C1_posedge_posedge,
         SetupLow             => tsetup_CE_C1_negedge_posedge,
         HoldHigh             => thold_CE_C1_posedge_posedge,
         HoldLow              => thold_CE_C1_negedge_posedge,
         CheckEnabled         => true,
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_IDDR2",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => Error);
--=====  Vital SetupHold Check for signal D =====
       VitalSetupHoldCheck (
         Violation            => Tviol_D_C0_posedge,
         TimingData           => Tmkr_D_C0_posedge,
         TestSignal           => D_dly,
         TestSignalName       => "D",
         TestDelay            => tisd_D_C0,
         RefSignal            => C0_dly,
         RefSignalName        => "C0",
         RefDelay             => ticd_C0,
         SetupHigh            => tsetup_D_C0_posedge_posedge,
         SetupLow             => tsetup_D_C0_negedge_posedge,
         HoldHigh             => thold_D_C0_posedge_posedge,
         HoldLow              => thold_D_C0_negedge_posedge,
         CheckEnabled         => true,
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_IDDR2",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => Error);
--=====  Vital SetupHold Check for signal D =====
       VitalSetupHoldCheck (
         Violation            => Tviol_D_C1_posedge,
         TimingData           => Tmkr_D_C1_posedge,
         TestSignal           => D_dly,
         TestSignalName       => "D",
         TestDelay            => tisd_D_C1,
         RefSignal            => C1_dly,
         RefSignalName        => "C1",
         RefDelay             => ticd_C1,
         SetupHigh            => tsetup_D_C1_posedge_posedge,
         SetupLow             => tsetup_D_C1_negedge_posedge,
         HoldHigh             => thold_D_C1_posedge_posedge,
         HoldLow              => thold_D_C1_negedge_posedge,
         CheckEnabled         => true,
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_IDDR2",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => Error);

--=====  Vital Recovery/Removal Check for signal GSR =====
       VitalRecoveryRemovalCheck (
         Violation            => Tviol_GSR_C0_posedge,
         TimingData           => Tmkr_GSR_C0_posedge,
         TestSignal           => GSR_dly,
         TestSignalName       => "GSR",
         TestDelay            => tisd_GSR_C0,
         RefSignal            => C0_dly,
         RefSignalName        => "C0",
         RefDelay             => ticd_C0,
         Recovery             => trecovery_GSR_C0_negedge_posedge,
         Removal              => tremoval_GSR_C0_negedge_posedge,
         ActiveLow            => FALSE,
         CheckEnabled         => true,
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_IDDR2",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => Error);
--=====  Vital Recovery/Removal Check for signal GSR =====
       VitalRecoveryRemovalCheck (
         Violation            => Tviol_GSR_C1_posedge,
         TimingData           => Tmkr_GSR_C1_posedge,
         TestSignal           => GSR_dly,
         TestSignalName       => "GSR",
         TestDelay            => tisd_GSR_C1,
         RefSignal            => C1_dly,
         RefSignalName        => "C1",
         RefDelay             => ticd_C1,
         Recovery             => trecovery_GSR_C1_negedge_posedge,
         Removal              => tremoval_GSR_C1_negedge_posedge,
         ActiveLow            => FALSE,
         CheckEnabled         => true,
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_IDDR2",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => Error);

--=====  Vital Pulse Width Check for signal C0 =====
       VitalPeriodPulseCheck (
         Violation            => Pviol_C0,
         PeriodData           => PInfo_C0,
         TestSignal           => C0_dly,
         TestSignalName       => "C0",
         TestDelay            => 0 ps,
         Period               => tperiod_C0_posedge,
         PulseWidthHigh       => tpw_C0_posedge,
         PulseWidthLow        => tpw_C0_negedge,
         CheckEnabled         => true,
         HeaderMsg            => InstancePath & "/X_IDDR2",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => Error);
--=====  Vital Pulse Width Check for signal C1 =====
       VitalPeriodPulseCheck (
         Violation            => Pviol_C1,
         PeriodData           => PInfo_C1,
         TestSignal           => C1_dly,
         TestSignalName       => "C1",
         TestDelay            => 0 ps,
         Period               => tperiod_C1_posedge,
         PulseWidthHigh       => tpw_C1_posedge,
         PulseWidthLow        => tpw_C1_negedge,
         CheckEnabled         => true,
         HeaderMsg            => InstancePath & "/X_IDDR2",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => Error);

        VitalPeriodPulseCheck (
        Violation            => Pviol_R,
        PeriodData           => PInfo_R,
        TestSignal           => R_dly,
        TestSignalName       => "R",
        TestDelay            => 0 ps,
        Period               => 0 ps,
        PulseWidthHigh       => tpw_R_posedge,
        PulseWidthLow        => 0 ps,
        CheckEnabled         => true,
        HeaderMsg            => "/X_IDDR2",
        Xon                  => Xon,
        MsgOn                => true,
        MsgSeverity          => Error);
      VitalPeriodPulseCheck (
        Violation            => Pviol_S,
        PeriodData           => PInfo_S,
        TestSignal           => S_dly,
        TestSignalName       => "S",
        TestDelay            => 0 ps,
        Period               => 0 ps,
        PulseWidthHigh       => tpw_S_posedge,
        PulseWidthLow        => 0 ps,
        CheckEnabled         => true,
        HeaderMsg            => "/X_IDDR2",
        Xon                  => Xon,
        MsgOn                => true,
        MsgSeverity          => Error);
       
       if (SRTYPE = "ASYNC" ) then
--=====  Vital Recovery/Removal Check for signal R =====
         VitalRecoveryRemovalCheck (
           Violation            => Tviol_R_C0_posedge,
           TimingData           => Tmkr_R_C0_posedge,
           TestSignal           => R_dly,
           TestSignalName       => "R",
           TestDelay            => tisd_R_C0,
           RefSignal            => C0_dly,
           RefSignalName        => "C0",
           RefDelay             => ticd_C0,
           Recovery             => trecovery_R_C0_negedge_posedge,
           Removal              => tremoval_R_C0_negedge_posedge,
           ActiveLow            => FALSE,
           CheckEnabled         => true,
           RefTransition        => 'R',
           HeaderMsg            => InstancePath & "/X_IDDR2",
           Xon                  => Xon,
           MsgOn                => true,
           MsgSeverity          => Error);
--=====  Vital Recovery/Removal Check for signal R =====
         VitalRecoveryRemovalCheck (
           Violation            => Tviol_R_C1_posedge,
           TimingData           => Tmkr_R_C1_posedge,
           TestSignal           => R_dly,
           TestSignalName       => "R",
           TestDelay            => tisd_R_C1,
           RefSignal            => C1_dly,
           RefSignalName        => "C1",
           RefDelay             => ticd_C1,
           Recovery             => trecovery_R_C1_negedge_posedge,
           Removal              => tremoval_R_C1_negedge_posedge,
           ActiveLow            => FALSE,
           CheckEnabled         => true,
           RefTransition        => 'R',
           HeaderMsg            => InstancePath & "/X_IDDR2",
           Xon                  => Xon,
           MsgOn                => true,
           MsgSeverity          => Error);
--=====  Vital Recovery/Removal Check for signal S =====
         VitalRecoveryRemovalCheck (
           Violation            => Tviol_S_C0_posedge,
           TimingData           => Tmkr_S_C0_posedge,
           TestSignal           => S_dly,
           TestSignalName       => "S",
           TestDelay            => tisd_S_C0,
           RefSignal            => C0_dly,
           RefSignalName        => "C0",
           RefDelay             => ticd_C0,
           Recovery             => trecovery_S_C0_negedge_posedge,
           Removal              => tremoval_S_C0_negedge_posedge,
           ActiveLow            => FALSE,
           CheckEnabled         => true,
           RefTransition        => 'R',
           HeaderMsg            => InstancePath & "/X_IDDR2",
           Xon                  => Xon,
           MsgOn                => true,
           MsgSeverity          => Error);
--=====  Vital Recovery/Removal Check for signal S =====
         VitalRecoveryRemovalCheck (
           Violation            => Tviol_S_C1_posedge,
           TimingData           => Tmkr_S_C1_posedge,
           TestSignal           => S_dly,
           TestSignalName       => "S",
           TestDelay            => tisd_S_C1,
           RefSignal            => C1_dly,
           RefSignalName        => "C1",
           RefDelay             => ticd_C1,
           Recovery             => trecovery_S_C1_negedge_posedge,
           Removal              => tremoval_S_C1_negedge_posedge,
           ActiveLow            => FALSE,
           CheckEnabled         => true,
           RefTransition        => 'R',
           HeaderMsg            => InstancePath & "/X_IDDR2",
           Xon                  => Xon,
           MsgOn                => true,
           MsgSeverity          => Error);

       elsif (SRTYPE = "SYNC" ) then
--=====  Vital SetupHold Check for signal R =====
         VitalSetupHoldCheck (
           Violation            => Tviol_R_C0_posedge,
           TimingData           => Tmkr_R_C0_posedge,
           TestSignal           => R_dly,
           TestSignalName       => "R",
           TestDelay            => tisd_R_C0,
           RefSignal            => C0_dly,
           RefSignalName        => "C0",
           RefDelay             => ticd_C0,
           SetupHigh            => tsetup_R_C0_posedge_posedge,
           SetupLow             => tsetup_R_C0_negedge_posedge,
           HoldHigh             => thold_R_C0_posedge_posedge,
           HoldLow              => thold_R_C0_negedge_posedge,
           CheckEnabled         => true,
           RefTransition        => 'R',
           HeaderMsg            => InstancePath & "/X_IDDR2",
           Xon                  => Xon,
           MsgOn                => true,
           MsgSeverity          => Error);
--=====  Vital SetupHold Check for signal R =====
         VitalSetupHoldCheck (
            Violation            => Tviol_R_C1_posedge,
            TimingData           => Tmkr_R_C1_posedge,
            TestSignal           => R_dly,
            TestSignalName       => "R",
            TestDelay            => tisd_R_C1,
            RefSignal            => C1_dly,
            RefSignalName        => "C1",
            RefDelay             => ticd_C1,
            SetupHigh            => tsetup_R_C1_posedge_posedge,
            SetupLow             => tsetup_R_C1_negedge_posedge,
            HoldHigh             => thold_R_C1_posedge_posedge,
            HoldLow              => thold_R_C1_negedge_posedge,
            CheckEnabled         => true,
            RefTransition        => 'R',
            HeaderMsg            => InstancePath & "/X_IDDR2",
            Xon                  => Xon,
            MsgOn                => true,
            MsgSeverity          => Error);
--=====  Vital SetupHold Check for signal S =====
         VitalSetupHoldCheck (
           Violation            => Tviol_S_C0_posedge,
           TimingData           => Tmkr_S_C0_posedge,
           TestSignal           => S_dly,
           TestSignalName       => "S",
           TestDelay            => tisd_S_C0,
           RefSignal            => C0_dly,
           RefSignalName        => "C0",
           RefDelay             => ticd_C0,
           SetupHigh            => tsetup_S_C0_posedge_posedge,
           SetupLow             => tsetup_S_C0_negedge_posedge,
           HoldHigh             => thold_S_C0_posedge_posedge,
           HoldLow              => thold_S_C0_negedge_posedge,
           CheckEnabled         => true,
           RefTransition        => 'R',
           HeaderMsg            => InstancePath & "/X_IDDR2",
           Xon                  => Xon,
           MsgOn                => true,
           MsgSeverity          => Error);
--=====  Vital SetupHold Check for signal S =====
         VitalSetupHoldCheck (
           Violation            => Tviol_S_C1_posedge,
           TimingData           => Tmkr_S_C1_posedge,
           TestSignal           => S_dly,
           TestSignalName       => "S",
           TestDelay            => tisd_S_C1,
           RefSignal            => C1_dly,
           RefSignalName        => "C1",
           RefDelay             => ticd_C1,
           SetupHigh            => tsetup_S_C1_posedge_posedge,
           SetupLow             => tsetup_S_C1_negedge_posedge,
           HoldHigh             => thold_S_C1_posedge_posedge,
           HoldLow              => thold_S_C1_negedge_posedge,
           CheckEnabled         => true,
           RefTransition        => 'R',
           HeaderMsg            => InstancePath & "/X_IDDR2",
           Xon                  => Xon,
           MsgOn                => true,
           MsgSeverity          => Error);

        end if;
    end if;

    Violation := Pviol_C0 or Pviol_C1 or Pviol_R or Pviol_S or 
                 Tviol_D_C0_posedge or Tviol_D_C1_posedge or
                 Tviol_CE_C0_posedge or Tviol_CE_C1_posedge or
                 Tviol_R_C0_posedge or Tviol_R_C1_posedge or
                 Tviol_S_C0_posedge or Tviol_S_C1_posedge;

    Q0_viol     <= Violation xor Q0_zd;
    Q1_viol     <= Violation xor Q1_zd;

    wait on C0_dly, C1_dly, CE_dly, D_dly, GSR_dly, R_dly, S_dly, Q0_zd, Q1_zd;
 
  end process prcs_tmngchk;
--####################################################################
--#####                           OUTPUT                         #####
--####################################################################
  prcs_output:process
  variable  Q0_GlitchData : VitalGlitchDataType;
  variable  Q1_GlitchData : VitalGlitchDataType;

  begin
     VitalPathDelay01
       (
         OutSignal     => Q0,
         GlitchData    => Q0_GlitchData,
         OutSignalName => "Q0",
         OutTemp       => Q0_viol,
         Paths         => (0 => (C0_dly'last_event, tpd_C0_Q0, (C0_dly = '1')),
                           1 => (C1_dly'last_event, tpd_C1_Q0, (C1_dly = '1')),
                           2 => (GSR_dly'last_event, tpd_GSR_Q0, true),
                           3 => (S_dly'last_event, tpd_S_Q0, (R_dly /= '1')),
                           4 => (R_dly'last_event, tpd_R_Q0, true)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => Error
       );
     VitalPathDelay01
       (
         OutSignal     => Q1,
         GlitchData    => Q1_GlitchData,
         OutSignalName => "Q1",
         OutTemp       => Q1_viol,
         Paths         => (0 => (C0_dly'last_event, tpd_C0_Q1, (C0_dly = '1')),
                           1 => (C1_dly'last_event, tpd_C1_Q1, (C1_dly = '1')),
                           2 => (GSR_dly'last_event, tpd_GSR_Q1, true),
                           3 => (S_dly'last_event, tpd_S_Q1, (R_dly /= '1')),
                           4 => (R_dly'last_event, tpd_R_Q1, true)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => Error
       );

    wait on Q0_viol, Q1_viol;
  end process prcs_output;


end X_IDDR2_V;

-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  18X18 Signed Multiplier 
-- /___/   /\     Filename : X_MULT18X18SIO.vhd
-- \   \  /  \    Timestamp : Fri Mar 26 08:18:19 PST 2004
--  \___\/\___\
--
-- Revision:
--    03/23/04 - Initial version.
--    07/25/05 - Added CLK_dly to the sensitivity list
--    08/29/05 - Added rest of the signals to the sensitivity list to avoid false
--             - Setup/Hold violations at initial stages
--    11/22/05 - CR 221818, tpw CLK
-- End Revision

----- CELL X_MULT18X18SIO -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_SIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;


library IEEE;
use IEEE.Vital_Primitives.all;
use IEEE.Vital_Timing.all;

library simprim;
use simprim.Vcomponents.all;
use simprim.VPACKAGE.all;

entity X_MULT18X18SIO is

  generic (

	AREG            : integer       := 1;
	BREG            : integer       := 1;
	B_INPUT         : string        := "DIRECT";

	PREG            : integer       := 1;

	TimingChecksOn  : boolean       := true;
	InstancePath    : string        := "*";
	Xon             : boolean       := true;
	MsgOn           : boolean       := false;
        LOC             : string        := "UNPLACED";

----- VITAL input wire delays

	tipd_A		: VitalDelayArrayType01 (17 downto 0 ) := (others => (0 ps, 0 ps));
	tipd_B		: VitalDelayArrayType01 (17 downto 0 ) := (others => (0 ps, 0 ps));
	tipd_BCIN	: VitalDelayArrayType01 (17 downto 0 ) := (others => (0 ps, 0 ps));
	tipd_CEA	: VitalDelayType01 := (0 ps, 0 ps);
	tipd_CEB	: VitalDelayType01 := (0 ps, 0 ps);
	tipd_CEP	: VitalDelayType01 := (0 ps, 0 ps);
	tipd_CLK	: VitalDelayType01 := (0 ps, 0 ps);
	tipd_RSTA	: VitalDelayType01 := (0 ps, 0 ps);
	tipd_RSTB	: VitalDelayType01 := (0 ps, 0 ps);
	tipd_RSTP	: VitalDelayType01 := (0 ps, 0 ps);
	tipd_GSR	: VitalDelayType01 := (0 ps, 0 ps);

----- VITAL pin-to-pin propagation delays
           
	tpd_A_P		: VitalDelayArrayType01 (647 downto 0 ) := (others => (0 ps, 0 ps));
	tpd_B_P		: VitalDelayArrayType01 (647 downto 0 ) := (others => (0 ps, 0 ps));
	tpd_B_BCOUT	: VitalDelayArrayType01 (323 downto 0 ) := (others => (0 ps, 0 ps));
	tpd_BCIN_P	: VitalDelayArrayType01 (647 downto 0 ) := (others => (0 ps, 0 ps));
	tpd_BCIN_BCOUT	: VitalDelayArrayType01 (323 downto 0 ) := (others => (0 ps, 0 ps));

	tpd_CLK_P	: VitalDelayArrayType01 (35 downto 0) := (others => (0 ps, 0 ps));
	tpd_CLK_BCOUT	: VitalDelayArrayType01 (17 downto 0) := (others => (0 ps, 0 ps));
	tpd_GSR_P	: VitalDelayArrayType01 (35 downto 0) := (others => (0 ps, 0 ps));

----- VITAL clock ticd delays
           
	ticd_CLK	: VitalDelayType := 0 ps;

----- VITAL clock-to-pin tisd delays

        tisd_A_CLK	: VitalDelayArrayType(17 downto 0) := (others => 0 ps);
        tisd_B_CLK	: VitalDelayArrayType(17 downto 0) := (others => 0 ps);
        tisd_BCIN_CLK	: VitalDelayArrayType(17 downto 0) := (others => 0 ps);
        tisd_CEA_CLK	: VitalDelayType := 0 ps;
        tisd_CEB_CLK	: VitalDelayType := 0 ps;
        tisd_CEP_CLK	: VitalDelayType := 0 ps;
        tisd_GSR_CLK	: VitalDelayType := 0 ps;
        tisd_RSTA_CLK	: VitalDelayType := 0 ps;
        tisd_RSTB_CLK	: VitalDelayType := 0 ps;
        tisd_RSTP_CLK	: VitalDelayType := 0 ps;

----- VITAL setup and hold times

        tsetup_A_CLK_posedge_posedge : VitalDelayArrayType(17 downto 0) := (others => 0 ps);
        tsetup_A_CLK_negedge_posedge : VitalDelayArrayType(17 downto 0) := (others => 0 ps);

        tsetup_B_CLK_posedge_posedge : VitalDelayArrayType(17 downto 0) := (others => 0 ps);
        tsetup_B_CLK_negedge_posedge : VitalDelayArrayType(17 downto 0) := (others => 0 ps);

        tsetup_BCIN_CLK_posedge_posedge : VitalDelayArrayType(17 downto 0) := (others => 0 ps);
        tsetup_BCIN_CLK_negedge_posedge : VitalDelayArrayType(17 downto 0) := (others => 0 ps);

        tsetup_CEA_CLK_posedge_posedge : VitalDelayType := 0 ps;
        tsetup_CEA_CLK_negedge_posedge : VitalDelayType := 0 ps;

        tsetup_CEB_CLK_posedge_posedge : VitalDelayType := 0 ps;
        tsetup_CEB_CLK_negedge_posedge : VitalDelayType := 0 ps;

        tsetup_CEP_CLK_posedge_posedge : VitalDelayType := 0 ps;
        tsetup_CEP_CLK_negedge_posedge : VitalDelayType := 0 ps;

        tsetup_RSTA_CLK_posedge_posedge : VitalDelayType := 0 ps;
        tsetup_RSTA_CLK_negedge_posedge : VitalDelayType := 0 ps;

        tsetup_RSTB_CLK_posedge_posedge : VitalDelayType := 0 ps;
        tsetup_RSTB_CLK_negedge_posedge : VitalDelayType := 0 ps;

        tsetup_RSTP_CLK_posedge_posedge : VitalDelayType := 0 ps;
        tsetup_RSTP_CLK_negedge_posedge : VitalDelayType := 0 ps;

        thold_A_CLK_posedge_posedge : VitalDelayArrayType(17 downto 0) := (others => 0 ps);
        thold_A_CLK_negedge_posedge : VitalDelayArrayType(17 downto 0) := (others => 0 ps);

        thold_B_CLK_posedge_posedge : VitalDelayArrayType(17 downto 0) := (others => 0 ps);
        thold_B_CLK_negedge_posedge : VitalDelayArrayType(17 downto 0) := (others => 0 ps);

        thold_BCIN_CLK_posedge_posedge : VitalDelayArrayType(17 downto 0) := (others => 0 ps);
        thold_BCIN_CLK_negedge_posedge : VitalDelayArrayType(17 downto 0) := (others => 0 ps);

        thold_CEA_CLK_posedge_posedge : VitalDelayType := 0 ps;
        thold_CEA_CLK_negedge_posedge : VitalDelayType := 0 ps;

        thold_CEB_CLK_posedge_posedge : VitalDelayType := 0 ps;
        thold_CEB_CLK_negedge_posedge : VitalDelayType := 0 ps;

        thold_CEP_CLK_posedge_posedge : VitalDelayType := 0 ps;
        thold_CEP_CLK_negedge_posedge : VitalDelayType := 0 ps;

        thold_RSTA_CLK_posedge_posedge : VitalDelayType := 0 ps;
        thold_RSTA_CLK_negedge_posedge : VitalDelayType := 0 ps;

        thold_RSTB_CLK_posedge_posedge : VitalDelayType := 0 ps;
        thold_RSTB_CLK_negedge_posedge : VitalDelayType := 0 ps;

        thold_RSTP_CLK_posedge_posedge : VitalDelayType := 0 ps;
        thold_RSTP_CLK_negedge_posedge : VitalDelayType := 0 ps;

----- VITAL period check
        tperiod_CLK_posedge     : VitalDelayType := 0 ps;

----- VITAL pulse width
	tpw_CLK_posedge	: VitalDelayType := 0 ps;
	tpw_CLK_negedge	: VitalDelayType := 0 ps;
	tpw_GSR_posedge	: VitalDelayType := 0 ps;

----- VITAL Recovery
        trecovery_GSR_CLK_negedge_posedge : VitalDelayType := 0 ps

	);

  port (
	BCOUT	: out std_logic_vector (17 downto 0);
	P	: out std_logic_vector (35 downto 0);

	A	: in  std_logic_vector (17 downto 0);
	B	: in  std_logic_vector (17 downto 0);
	BCIN	: in  std_logic_vector (17 downto 0);
	CEA	: in  std_ulogic;
	CEB	: in  std_ulogic;
	CEP	: in  std_ulogic;
	CLK	: in  std_ulogic;
	RSTA	: in  std_ulogic;
	RSTB	: in  std_ulogic;
	RSTP	: in  std_ulogic
	);

  attribute VITAL_LEVEL0 of
    X_MULT18X18SIO : entity is true;

end X_MULT18X18SIO;


architecture X_MULT18X18SIO_V of X_MULT18X18SIO is

  attribute VITAL_LEVEL0 of
    X_MULT18X18SIO_V : architecture is true;

  TYPE VitalTimingDataArrayType IS ARRAY (NATURAL RANGE <>)
       OF VitalTimingDataType;

  constant MAX_P          : integer    := 36;
  constant MAX_BCOUT      : integer    := 36;
  constant MAX_BCIN       : integer    := 18;
  constant MAX_B          : integer    := 18;
  constant MAX_A          : integer    := 18;

  constant MSB_P          : integer    := 35;
  constant MSB_BCOUT      : integer    := 17;
  constant MSB_BCIN       : integer    := 17;
  constant MSB_B          : integer    := 17;
  constant MSB_A          : integer    := 17;

  signal A_ipd    : std_logic_vector(MSB_A downto 0) := (others => '0' );
  signal B_ipd    : std_logic_vector(MSB_B downto 0) := (others => '0' );
  signal BCIN_ipd : std_logic_vector(MSB_BCIN downto 0) := (others => '0' );
  signal CEA_ipd  : std_ulogic := 'X';
  signal CEB_ipd  : std_ulogic := 'X';
  signal CEP_ipd  : std_ulogic := 'X';
  signal CLK_ipd  : std_ulogic := 'X';
  signal GSR_ipd  : std_ulogic := 'X';
  signal RSTA_ipd : std_ulogic := 'X';
  signal RSTB_ipd : std_ulogic := 'X';
  signal RSTP_ipd : std_ulogic := 'X';

  signal A_dly    : std_logic_vector(MSB_A downto 0) := (others => '0' );
  signal B_dly    : std_logic_vector(MSB_B downto 0) := (others => '0' );
  signal BCIN_dly : std_logic_vector(MSB_BCIN downto 0) := (others => '0' );
  signal CEA_dly  : std_ulogic := 'X';
  signal CEB_dly  : std_ulogic := 'X';
  signal CEP_dly  : std_ulogic := 'X';
  signal CLK_dly  : std_ulogic := 'X';
  signal GSR_dly  : std_ulogic := 'X';
  signal RSTA_dly : std_ulogic := 'X';
  signal RSTB_dly : std_ulogic := 'X';
  signal RSTP_dly : std_ulogic := 'X';


  --- Internal Signal Declarations

  signal qa_o_reg1 : std_logic_vector(MSB_A downto 0) := (others => '0');
  signal qa_o_mux  : std_logic_vector(MSB_A downto 0) := (others => '0');

  signal b_o_mux   : std_logic_vector(MSB_B downto 0) := (others => '0');
  signal qb_o_reg1 : std_logic_vector(MSB_B downto 0) := (others => '0');
  signal qb_o_mux  : std_logic_vector(MSB_B downto 0) := (others => '0');

  signal mult_o_int : std_logic_vector((MSB_A + MSB_B + 1) downto 0) := (others => '0');

  signal qp_o_reg : std_logic_vector(MSB_P downto 0) := (others => '0');
  signal qp_o_mux : std_logic_vector(MSB_P downto 0) := (others => '0');

  signal BCOUT_zd : std_logic_vector(MSB_BCOUT downto 0) := (others => '0');
  signal P_zd : std_logic_vector(MSB_P downto 0) := (others => '0');

begin


  WireDelay : block
  begin
    A_Delay : for i in MSB_A downto 0 generate
        VitalWireDelay (A_ipd(i),    A(i),        tipd_A(i));
    end generate A_Delay;

    B_Delay : for i in MSB_B downto 0 generate
        VitalWireDelay (B_ipd(i),    B(i),        tipd_B(i));
    end generate B_Delay;

    BCIN_Delay : for i in MSB_BCIN downto 0 generate
        VitalWireDelay (BCIN_ipd(i),  BCIN(i),      tipd_BCIN(i));
    end generate BCIN_Delay;

    VitalWireDelay (CEA_ipd,	CEA,	tipd_CEA);
    VitalWireDelay (CEB_ipd,	CEB,	tipd_CEB);
    VitalWireDelay (CEP_ipd,	CEP,	tipd_CEP);
    VitalWireDelay (CLK_ipd,	CLK,	tipd_CLK);
    VitalWireDelay (GSR_ipd,	GSR,	tipd_GSR);
    VitalWireDelay (RSTA_ipd,	RSTA,	tipd_RSTA);
    VitalWireDelay (RSTB_ipd,	RSTB,	tipd_RSTB);
    VitalWireDelay (RSTP_ipd,	RSTP,	tipd_RSTP);
  end block;
  


  SignalDelay : block
  begin
    A_Delay : for i in MSB_A downto 0 generate
        VitalSignalDelay (A_dly(i),     A_ipd(i),    tisd_A_CLK(i));
    end generate A_Delay;

    B_Delay : for i in MSB_B downto 0 generate
        VitalSignalDelay (B_dly(i),     B_ipd(i),    tisd_B_CLK(i));
    end generate B_Delay;

    BCIN_Delay : for i in MSB_BCIN downto 0 generate
        VitalSignalDelay (BCIN_dly(i),     BCIN_ipd(i),    tisd_BCIN_CLK(i));
    end generate BCIN_Delay;

    VitalSignalDelay (CEA_dly,        CEA_ipd,        tisd_CEA_CLK);
    VitalSignalDelay (CEB_dly,        CEB_ipd,        tisd_CEB_CLK);
    VitalSignalDelay (CEP_dly,        CEP_ipd,        tisd_CEP_CLK);

    VitalSignalDelay (CLK_dly,        CLK_ipd,        ticd_CLK);
    VitalSignalDelay (GSR_dly,        GSR_ipd,        tisd_GSR_CLK);

    VitalSignalDelay (RSTA_dly,       RSTA_ipd,       tisd_RSTA_CLK);
    VitalSignalDelay (RSTB_dly,       RSTB_ipd,       tisd_RSTB_CLK);
    VitalSignalDelay (RSTP_dly,       RSTP_ipd,       tisd_RSTP_CLK);

  end block;



--####################################################################
--#####    Input Register A with 1 level of registers and a mux  #####
--####################################################################
  prcs_qa_1lvl:process(CLK_dly, GSR_dly)
  begin
      if(GSR_dly = '1') then
          qa_o_reg1 <= ( others => '0');
      elsif (GSR_dly = '0') then
         if(rising_edge(CLK_dly)) then
            if(RSTA_dly = '1') then
               qa_o_reg1 <= ( others => '0');
            elsif ((RSTA_dly = '0') and  (CEA_dly = '1')) then
               qa_o_reg1 <= A_dly;
            end if;
         end if;
      end if;
  end process prcs_qa_1lvl;

----------------------------------------------------------------------

  prcs_qa_o_mux:process(A_dly, qa_o_reg1)
  begin
     case AREG is
       when 0 => qa_o_mux <= A_dly;
       when 1 => qa_o_mux <= qa_o_reg1;
       when others =>
            assert false
            report "Attribute Syntax Error: The allowed values for AREG are 0 or 1"
            severity Failure;
     end case;
  end process prcs_qa_o_mux;

--####################################################################
--#####    Input Register B with two levels of registers and a mux ###
--####################################################################
  prcs_b_in:process(B_dly, BCIN_dly)
  begin
     if(B_INPUT ="DIRECT") then
        b_o_mux <= B_dly;
     elsif(B_INPUT ="CASCADE") then
        b_o_mux <= BCIN_dly;
     else
        assert false
        report "Attribute Syntax Error: The allowed values for B_INPUT are DIRECT or CASCADE."
        severity Failure;
     end if;
  end process prcs_b_in;
------------------------------------------------------------------
 prcs_qb_1lvl:process(CLK_dly, GSR_dly)
  begin
      if(GSR_dly = '1') then
          qb_o_reg1 <= ( others => '0');
      elsif (GSR_dly = '0') then
         if(rising_edge(CLK_dly)) then
            if(RSTB_dly = '1') then
               qb_o_reg1 <= ( others => '0');
            elsif ((RSTB_dly = '0') and  (CEB_dly = '1')) then
               qb_o_reg1 <= b_o_mux;
            end if;
         end if;
      end if;
  end process prcs_qb_1lvl;
------------------------------------------------------------------
  prcs_qb_o_mux:process(b_o_mux, qb_o_reg1)
  begin
     case BREG is
       when 0 => qb_o_mux <= b_o_mux;
       when 1 => qb_o_mux <= qb_o_reg1;
       when others =>
            assert false
            report "Attribute Syntax Error: The allowed values for BREG are 0 or 1 "
            severity Failure;
     end case;

  end process prcs_qb_o_mux;
--####################################################################
--#####                     Multiply                             #####
--####################################################################
  prcs_mult:process(qa_o_mux, qb_o_mux)
  begin
     mult_o_int <=  qa_o_mux * qb_o_mux;
  end process prcs_mult;
--####################################################################
--#####                    Output  P                             #####
--####################################################################
  prcs_qp_reg:process(CLK_dly, GSR_dly)
  begin
      if(GSR_dly = '1') then
         qp_o_reg <=  ( others => '0');
      elsif (GSR_dly = '0') then
         if(rising_edge(CLK_dly)) then
            if(RSTP_dly = '1') then
               qp_o_reg <= ( others => '0');
            elsif ((RSTP_dly = '0') and (CEP_dly = '1')) then
               qp_o_reg <= mult_o_int;
            end if;
         end if;
      end if;
  end process prcs_qp_reg;
------------------------------------------------------------------
  prcs_qp_mux:process(mult_o_int, qp_o_reg)
  begin
     case PREG is
       when 0 => qp_o_mux <= mult_o_int;
       when 1 => qp_o_mux <= qp_o_reg;
       when others =>
           assert false
           report "Attribute Syntax Error: The allowed values for PREG are 0 or 1"
           severity Failure;
     end case;

  end process prcs_qp_mux;
--####################################################################
--#####                   ZERO_DELAY_OUTPUTS                     #####
--####################################################################
  prcs_zero_delay_outputs:process(qb_o_mux, qp_o_mux)
  begin
    BCOUT_zd <= qb_o_mux;
    P_zd     <= qp_o_mux;
  end process prcs_zero_delay_outputs;


--####################################################################
--#####                   TIMING CHECKS                          #####
--####################################################################
  prcs_Timing : process

  variable P_GlitchData                 : VitalGlitchDataArrayType (35 downto 0 );
  variable BCOUT_GlitchData             : VitalGlitchDataArrayType (17 downto 0 );

--  Pin Timing Violations (all input pins)

  variable Tmkr_A_CLK_posedge     : VitalTimingDataArrayType(17 downto 0 );
  variable Tviol_A_CLK_posedge    : std_logic_vector(17 downto 0 ) := (others => '0');

  variable Tmkr_B_CLK_posedge     : VitalTimingDataArrayType(17 downto 0 );
  variable Tviol_B_CLK_posedge    : std_logic_vector(17 downto 0 ) := (others => '0');

  variable Tmkr_BCIN_CLK_posedge  : VitalTimingDataArrayType(17 downto 0 );
  variable Tviol_BCIN_CLK_posedge : std_logic_vector(17 downto 0 ) := (others => '0');

  variable Tmkr_CEA_CLK_posedge   : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_CEA_CLK_posedge  : std_ulogic := '0';
 
  variable Tmkr_CEB_CLK_posedge   : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_CEB_CLK_posedge  : std_ulogic := '0'; 

  variable Tmkr_CEP_CLK_posedge   : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_CEP_CLK_posedge  : std_ulogic := '0'; 

  variable Tmkr_RSTA_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_RSTA_CLK_posedge : std_ulogic := '0'; 

  variable Tmkr_RSTB_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_RSTB_CLK_posedge : std_ulogic := '0'; 

  variable Tmkr_RSTP_CLK_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_RSTP_CLK_posedge : std_ulogic := '0'; 

  variable PInfo_CLK             : VitalPeriodDataType := VitalPeriodDataInit;
  variable Pviol_CLK             : std_ulogic          := '0';

  begin 

    if (TimingChecksOn) then
--=====  Vital SetupHold Checks for Bus signal A =====
       VitalSetupHoldCheck (
         Violation            => Tviol_A_CLK_posedge(0),
         TimingData           => Tmkr_A_CLK_posedge(0),
         TestSignal           => A_dly(0),
         TestSignalName       => "A(0)",
         TestDelay            => tisd_A_CLK(0),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_A_CLK_posedge_posedge(0),
         SetupLow             => tsetup_A_CLK_negedge_posedge(0),
         HoldHigh             => thold_A_CLK_posedge_posedge(0),
         HoldLow              => thold_A_CLK_negedge_posedge(0),
         CheckEnabled         => (TO_X01((not RSTA_dly) and (CEA_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_A_CLK_posedge(1),
         TimingData           => Tmkr_A_CLK_posedge(1),
         TestSignal           => A_dly(1),
         TestSignalName       => "A(1)",
         TestDelay            => tisd_A_CLK(1),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_A_CLK_posedge_posedge(1),
         SetupLow             => tsetup_A_CLK_negedge_posedge(1),
         HoldHigh             => thold_A_CLK_posedge_posedge(1),
         HoldLow              => thold_A_CLK_negedge_posedge(1),
         CheckEnabled         => (TO_X01((not RSTA_dly) and (CEA_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_A_CLK_posedge(2),
         TimingData           => Tmkr_A_CLK_posedge(2),
         TestSignal           => A_dly(2),
         TestSignalName       => "A(2)",
         TestDelay            => tisd_A_CLK(2),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_A_CLK_posedge_posedge(2),
         SetupLow             => tsetup_A_CLK_negedge_posedge(2),
         HoldHigh             => thold_A_CLK_posedge_posedge(2),
         HoldLow              => thold_A_CLK_negedge_posedge(2),
         CheckEnabled         => (TO_X01((not RSTA_dly) and (CEA_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_A_CLK_posedge(3),
         TimingData           => Tmkr_A_CLK_posedge(3),
         TestSignal           => A_dly(3),
         TestSignalName       => "A(3)",
         TestDelay            => tisd_A_CLK(3),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_A_CLK_posedge_posedge(3),
         SetupLow             => tsetup_A_CLK_negedge_posedge(3),
         HoldHigh             => thold_A_CLK_posedge_posedge(3),
         HoldLow              => thold_A_CLK_negedge_posedge(3),
         CheckEnabled         => (TO_X01((not RSTA_dly) and (CEA_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_A_CLK_posedge(4),
         TimingData           => Tmkr_A_CLK_posedge(4),
         TestSignal           => A_dly(4),
         TestSignalName       => "A(4)",
         TestDelay            => tisd_A_CLK(4),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_A_CLK_posedge_posedge(4),
         SetupLow             => tsetup_A_CLK_negedge_posedge(4),
         HoldHigh             => thold_A_CLK_posedge_posedge(4),
         HoldLow              => thold_A_CLK_negedge_posedge(4),
         CheckEnabled         => (TO_X01((not RSTA_dly) and (CEA_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_A_CLK_posedge(5),
         TimingData           => Tmkr_A_CLK_posedge(5),
         TestSignal           => A_dly(5),
         TestSignalName       => "A(5)",
         TestDelay            => tisd_A_CLK(5),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_A_CLK_posedge_posedge(5),
         SetupLow             => tsetup_A_CLK_negedge_posedge(5),
         HoldHigh             => thold_A_CLK_posedge_posedge(5),
         HoldLow              => thold_A_CLK_negedge_posedge(5),
         CheckEnabled         => (TO_X01((not RSTA_dly) and (CEA_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_A_CLK_posedge(6),
         TimingData           => Tmkr_A_CLK_posedge(6),
         TestSignal           => A_dly(6),
         TestSignalName       => "A(6)",
         TestDelay            => tisd_A_CLK(6),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_A_CLK_posedge_posedge(6),
         SetupLow             => tsetup_A_CLK_negedge_posedge(6),
         HoldHigh             => thold_A_CLK_posedge_posedge(6),
         HoldLow              => thold_A_CLK_negedge_posedge(6),
         CheckEnabled         => (TO_X01((not RSTA_dly) and (CEA_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_A_CLK_posedge(7),
         TimingData           => Tmkr_A_CLK_posedge(7),
         TestSignal           => A_dly(7),
         TestSignalName       => "A(7)",
         TestDelay            => tisd_A_CLK(7),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_A_CLK_posedge_posedge(7),
         SetupLow             => tsetup_A_CLK_negedge_posedge(7),
         HoldHigh             => thold_A_CLK_posedge_posedge(7),
         HoldLow              => thold_A_CLK_negedge_posedge(7),
         CheckEnabled         => (TO_X01((not RSTA_dly) and (CEA_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_A_CLK_posedge(8),
         TimingData           => Tmkr_A_CLK_posedge(8),
         TestSignal           => A_dly(8),
         TestSignalName       => "A(8)",
         TestDelay            => tisd_A_CLK(8),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_A_CLK_posedge_posedge(8),
         SetupLow             => tsetup_A_CLK_negedge_posedge(8),
         HoldHigh             => thold_A_CLK_posedge_posedge(8),
         HoldLow              => thold_A_CLK_negedge_posedge(8),
         CheckEnabled         => (TO_X01((not RSTA_dly) and (CEA_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_A_CLK_posedge(9),
         TimingData           => Tmkr_A_CLK_posedge(9),
         TestSignal           => A_dly(9),
         TestSignalName       => "A(9)",
         TestDelay            => tisd_A_CLK(9),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_A_CLK_posedge_posedge(9),
         SetupLow             => tsetup_A_CLK_negedge_posedge(9),
         HoldHigh             => thold_A_CLK_posedge_posedge(9),
         HoldLow              => thold_A_CLK_negedge_posedge(9),
         CheckEnabled         => (TO_X01((not RSTA_dly) and (CEA_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_A_CLK_posedge(10),
         TimingData           => Tmkr_A_CLK_posedge(10),
         TestSignal           => A_dly(10),
         TestSignalName       => "A(10)",
         TestDelay            => tisd_A_CLK(10),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_A_CLK_posedge_posedge(10),
         SetupLow             => tsetup_A_CLK_negedge_posedge(10),
         HoldHigh             => thold_A_CLK_posedge_posedge(10),
         HoldLow              => thold_A_CLK_negedge_posedge(10),
         CheckEnabled         => (TO_X01((not RSTA_dly) and (CEA_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_A_CLK_posedge(11),
         TimingData           => Tmkr_A_CLK_posedge(11),
         TestSignal           => A_dly(11),
         TestSignalName       => "A(11)",
         TestDelay            => tisd_A_CLK(11),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_A_CLK_posedge_posedge(11),
         SetupLow             => tsetup_A_CLK_negedge_posedge(11),
         HoldHigh             => thold_A_CLK_posedge_posedge(11),
         HoldLow              => thold_A_CLK_negedge_posedge(11),
         CheckEnabled         => (TO_X01((not RSTA_dly) and (CEA_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_A_CLK_posedge(12),
         TimingData           => Tmkr_A_CLK_posedge(12),
         TestSignal           => A_dly(12),
         TestSignalName       => "A(12)",
         TestDelay            => tisd_A_CLK(12),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_A_CLK_posedge_posedge(12),
         SetupLow             => tsetup_A_CLK_negedge_posedge(12),
         HoldHigh             => thold_A_CLK_posedge_posedge(12),
         HoldLow              => thold_A_CLK_negedge_posedge(12),
         CheckEnabled         => (TO_X01((not RSTA_dly) and (CEA_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_A_CLK_posedge(13),
         TimingData           => Tmkr_A_CLK_posedge(13),
         TestSignal           => A_dly(13),
         TestSignalName       => "A(13)",
         TestDelay            => tisd_A_CLK(13),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_A_CLK_posedge_posedge(13),
         SetupLow             => tsetup_A_CLK_negedge_posedge(13),
         HoldHigh             => thold_A_CLK_posedge_posedge(13),
         HoldLow              => thold_A_CLK_negedge_posedge(13),
         CheckEnabled         => (TO_X01((not RSTA_dly) and (CEA_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_A_CLK_posedge(14),
         TimingData           => Tmkr_A_CLK_posedge(14),
         TestSignal           => A_dly(14),
         TestSignalName       => "A(14)",
         TestDelay            => tisd_A_CLK(14),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_A_CLK_posedge_posedge(14),
         SetupLow             => tsetup_A_CLK_negedge_posedge(14),
         HoldHigh             => thold_A_CLK_posedge_posedge(14),
         HoldLow              => thold_A_CLK_negedge_posedge(14),
         CheckEnabled         => (TO_X01((not RSTA_dly) and (CEA_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_A_CLK_posedge(15),
         TimingData           => Tmkr_A_CLK_posedge(15),
         TestSignal           => A_dly(15),
         TestSignalName       => "A(15)",
         TestDelay            => tisd_A_CLK(15),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_A_CLK_posedge_posedge(15),
         SetupLow             => tsetup_A_CLK_negedge_posedge(15),
         HoldHigh             => thold_A_CLK_posedge_posedge(15),
         HoldLow              => thold_A_CLK_negedge_posedge(15),
         CheckEnabled         => (TO_X01((not RSTA_dly) and (CEA_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_A_CLK_posedge(16),
         TimingData           => Tmkr_A_CLK_posedge(16),
         TestSignal           => A_dly(16),
         TestSignalName       => "A(16)",
         TestDelay            => tisd_A_CLK(16),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_A_CLK_posedge_posedge(16),
         SetupLow             => tsetup_A_CLK_negedge_posedge(16),
         HoldHigh             => thold_A_CLK_posedge_posedge(16),
         HoldLow              => thold_A_CLK_negedge_posedge(16),
         CheckEnabled         => (TO_X01((not RSTA_dly) and (CEA_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_A_CLK_posedge(17),
         TimingData           => Tmkr_A_CLK_posedge(17),
         TestSignal           => A_dly(17),
         TestSignalName       => "A(17)",
         TestDelay            => tisd_A_CLK(17),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_A_CLK_posedge_posedge(17),
         SetupLow             => tsetup_A_CLK_negedge_posedge(17),
         HoldHigh             => thold_A_CLK_posedge_posedge(17),
         HoldLow              => thold_A_CLK_negedge_posedge(17),
         CheckEnabled         => (TO_X01((not RSTA_dly) and (CEA_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
--=====  Vital SetupHold Checks for Bus signal B =====
       VitalSetupHoldCheck (
         Violation            => Tviol_B_CLK_posedge(0),
         TimingData           => Tmkr_B_CLK_posedge(0),
         TestSignal           => B_dly(0),
         TestSignalName       => "B(0)",
         TestDelay            => tisd_B_CLK(0),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_B_CLK_posedge_posedge(0),
         SetupLow             => tsetup_B_CLK_negedge_posedge(0),
         HoldHigh             => thold_B_CLK_posedge_posedge(0),
         HoldLow              => thold_B_CLK_negedge_posedge(0),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_B_CLK_posedge(1),
         TimingData           => Tmkr_B_CLK_posedge(1),
         TestSignal           => B_dly(1),
         TestSignalName       => "B(1)",
         TestDelay            => tisd_B_CLK(1),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_B_CLK_posedge_posedge(1),
         SetupLow             => tsetup_B_CLK_negedge_posedge(1),
         HoldHigh             => thold_B_CLK_posedge_posedge(1),
         HoldLow              => thold_B_CLK_negedge_posedge(1),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_B_CLK_posedge(2),
         TimingData           => Tmkr_B_CLK_posedge(2),
         TestSignal           => B_dly(2),
         TestSignalName       => "B(2)",
         TestDelay            => tisd_B_CLK(2),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_B_CLK_posedge_posedge(2),
         SetupLow             => tsetup_B_CLK_negedge_posedge(2),
         HoldHigh             => thold_B_CLK_posedge_posedge(2),
         HoldLow              => thold_B_CLK_negedge_posedge(2),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_B_CLK_posedge(3),
         TimingData           => Tmkr_B_CLK_posedge(3),
         TestSignal           => B_dly(3),
         TestSignalName       => "B(3)",
         TestDelay            => tisd_B_CLK(3),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_B_CLK_posedge_posedge(3),
         SetupLow             => tsetup_B_CLK_negedge_posedge(3),
         HoldHigh             => thold_B_CLK_posedge_posedge(3),
         HoldLow              => thold_B_CLK_negedge_posedge(3),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_B_CLK_posedge(4),
         TimingData           => Tmkr_B_CLK_posedge(4),
         TestSignal           => B_dly(4),
         TestSignalName       => "B(4)",
         TestDelay            => tisd_B_CLK(4),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_B_CLK_posedge_posedge(4),
         SetupLow             => tsetup_B_CLK_negedge_posedge(4),
         HoldHigh             => thold_B_CLK_posedge_posedge(4),
         HoldLow              => thold_B_CLK_negedge_posedge(4),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_B_CLK_posedge(5),
         TimingData           => Tmkr_B_CLK_posedge(5),
         TestSignal           => B_dly(5),
         TestSignalName       => "B(5)",
         TestDelay            => tisd_B_CLK(5),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_B_CLK_posedge_posedge(5),
         SetupLow             => tsetup_B_CLK_negedge_posedge(5),
         HoldHigh             => thold_B_CLK_posedge_posedge(5),
         HoldLow              => thold_B_CLK_negedge_posedge(5),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_B_CLK_posedge(6),
         TimingData           => Tmkr_B_CLK_posedge(6),
         TestSignal           => B_dly(6),
         TestSignalName       => "B(6)",
         TestDelay            => tisd_B_CLK(6),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_B_CLK_posedge_posedge(6),
         SetupLow             => tsetup_B_CLK_negedge_posedge(6),
         HoldHigh             => thold_B_CLK_posedge_posedge(6),
         HoldLow              => thold_B_CLK_negedge_posedge(6),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_B_CLK_posedge(7),
         TimingData           => Tmkr_B_CLK_posedge(7),
         TestSignal           => B_dly(7),
         TestSignalName       => "B(7)",
         TestDelay            => tisd_B_CLK(7),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_B_CLK_posedge_posedge(7),
         SetupLow             => tsetup_B_CLK_negedge_posedge(7),
         HoldHigh             => thold_B_CLK_posedge_posedge(7),
         HoldLow              => thold_B_CLK_negedge_posedge(7),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_B_CLK_posedge(8),
         TimingData           => Tmkr_B_CLK_posedge(8),
         TestSignal           => B_dly(8),
         TestSignalName       => "B(8)",
         TestDelay            => tisd_B_CLK(8),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_B_CLK_posedge_posedge(8),
         SetupLow             => tsetup_B_CLK_negedge_posedge(8),
         HoldHigh             => thold_B_CLK_posedge_posedge(8),
         HoldLow              => thold_B_CLK_negedge_posedge(8),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_B_CLK_posedge(9),
         TimingData           => Tmkr_B_CLK_posedge(9),
         TestSignal           => B_dly(9),
         TestSignalName       => "B(9)",
         TestDelay            => tisd_B_CLK(9),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_B_CLK_posedge_posedge(9),
         SetupLow             => tsetup_B_CLK_negedge_posedge(9),
         HoldHigh             => thold_B_CLK_posedge_posedge(9),
         HoldLow              => thold_B_CLK_negedge_posedge(9),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_B_CLK_posedge(10),
         TimingData           => Tmkr_B_CLK_posedge(10),
         TestSignal           => B_dly(10),
         TestSignalName       => "B(10)",
         TestDelay            => tisd_B_CLK(10),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_B_CLK_posedge_posedge(10),
         SetupLow             => tsetup_B_CLK_negedge_posedge(10),
         HoldHigh             => thold_B_CLK_posedge_posedge(10),
         HoldLow              => thold_B_CLK_negedge_posedge(10),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_B_CLK_posedge(11),
         TimingData           => Tmkr_B_CLK_posedge(11),
         TestSignal           => B_dly(11),
         TestSignalName       => "B(11)",
         TestDelay            => tisd_B_CLK(11),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_B_CLK_posedge_posedge(11),
         SetupLow             => tsetup_B_CLK_negedge_posedge(11),
         HoldHigh             => thold_B_CLK_posedge_posedge(11),
         HoldLow              => thold_B_CLK_negedge_posedge(11),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_B_CLK_posedge(12),
         TimingData           => Tmkr_B_CLK_posedge(12),
         TestSignal           => B_dly(12),
         TestSignalName       => "B(12)",
         TestDelay            => tisd_B_CLK(12),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_B_CLK_posedge_posedge(12),
         SetupLow             => tsetup_B_CLK_negedge_posedge(12),
         HoldHigh             => thold_B_CLK_posedge_posedge(12),
         HoldLow              => thold_B_CLK_negedge_posedge(12),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_B_CLK_posedge(13),
         TimingData           => Tmkr_B_CLK_posedge(13),
         TestSignal           => B_dly(13),
         TestSignalName       => "B(13)",
         TestDelay            => tisd_B_CLK(13),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_B_CLK_posedge_posedge(13),
         SetupLow             => tsetup_B_CLK_negedge_posedge(13),
         HoldHigh             => thold_B_CLK_posedge_posedge(13),
         HoldLow              => thold_B_CLK_negedge_posedge(13),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_B_CLK_posedge(14),
         TimingData           => Tmkr_B_CLK_posedge(14),
         TestSignal           => B_dly(14),
         TestSignalName       => "B(14)",
         TestDelay            => tisd_B_CLK(14),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_B_CLK_posedge_posedge(14),
         SetupLow             => tsetup_B_CLK_negedge_posedge(14),
         HoldHigh             => thold_B_CLK_posedge_posedge(14),
         HoldLow              => thold_B_CLK_negedge_posedge(14),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_B_CLK_posedge(15),
         TimingData           => Tmkr_B_CLK_posedge(15),
         TestSignal           => B_dly(15),
         TestSignalName       => "B(15)",
         TestDelay            => tisd_B_CLK(15),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_B_CLK_posedge_posedge(15),
         SetupLow             => tsetup_B_CLK_negedge_posedge(15),
         HoldHigh             => thold_B_CLK_posedge_posedge(15),
         HoldLow              => thold_B_CLK_negedge_posedge(15),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_B_CLK_posedge(16),
         TimingData           => Tmkr_B_CLK_posedge(16),
         TestSignal           => B_dly(16),
         TestSignalName       => "B(16)",
         TestDelay            => tisd_B_CLK(16),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_B_CLK_posedge_posedge(16),
         SetupLow             => tsetup_B_CLK_negedge_posedge(16),
         HoldHigh             => thold_B_CLK_posedge_posedge(16),
         HoldLow              => thold_B_CLK_negedge_posedge(16),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_B_CLK_posedge(17),
         TimingData           => Tmkr_B_CLK_posedge(17),
         TestSignal           => B_dly(17),
         TestSignalName       => "B(17)",
         TestDelay            => tisd_B_CLK(17),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_B_CLK_posedge_posedge(17),
         SetupLow             => tsetup_B_CLK_negedge_posedge(17),
         HoldHigh             => thold_B_CLK_posedge_posedge(17),
         HoldLow              => thold_B_CLK_negedge_posedge(17),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
--=====  Vital SetupHold Checks for Bus signal BCIN =====
       VitalSetupHoldCheck (
         Violation            => Tviol_BCIN_CLK_posedge(0),
         TimingData           => Tmkr_BCIN_CLK_posedge(0),
         TestSignal           => BCIN_dly(0),
         TestSignalName       => "BCIN(0)",
         TestDelay            => tisd_BCIN_CLK(0),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_BCIN_CLK_posedge_posedge(0),
         SetupLow             => tsetup_BCIN_CLK_negedge_posedge(0),
         HoldHigh             => thold_BCIN_CLK_posedge_posedge(0),
         HoldLow              => thold_BCIN_CLK_negedge_posedge(0),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_BCIN_CLK_posedge(1),
         TimingData           => Tmkr_BCIN_CLK_posedge(1),
         TestSignal           => BCIN_dly(1),
         TestSignalName       => "BCIN(1)",
         TestDelay            => tisd_BCIN_CLK(1),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_BCIN_CLK_posedge_posedge(1),
         SetupLow             => tsetup_BCIN_CLK_negedge_posedge(1),
         HoldHigh             => thold_BCIN_CLK_posedge_posedge(1),
         HoldLow              => thold_BCIN_CLK_negedge_posedge(1),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_BCIN_CLK_posedge(2),
         TimingData           => Tmkr_BCIN_CLK_posedge(2),
         TestSignal           => BCIN_dly(2),
         TestSignalName       => "BCIN(2)",
         TestDelay            => tisd_BCIN_CLK(2),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_BCIN_CLK_posedge_posedge(2),
         SetupLow             => tsetup_BCIN_CLK_negedge_posedge(2),
         HoldHigh             => thold_BCIN_CLK_posedge_posedge(2),
         HoldLow              => thold_BCIN_CLK_negedge_posedge(2),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_BCIN_CLK_posedge(3),
         TimingData           => Tmkr_BCIN_CLK_posedge(3),
         TestSignal           => BCIN_dly(3),
         TestSignalName       => "BCIN(3)",
         TestDelay            => tisd_BCIN_CLK(3),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_BCIN_CLK_posedge_posedge(3),
         SetupLow             => tsetup_BCIN_CLK_negedge_posedge(3),
         HoldHigh             => thold_BCIN_CLK_posedge_posedge(3),
         HoldLow              => thold_BCIN_CLK_negedge_posedge(3),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_BCIN_CLK_posedge(4),
         TimingData           => Tmkr_BCIN_CLK_posedge(4),
         TestSignal           => BCIN_dly(4),
         TestSignalName       => "BCIN(4)",
         TestDelay            => tisd_BCIN_CLK(4),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_BCIN_CLK_posedge_posedge(4),
         SetupLow             => tsetup_BCIN_CLK_negedge_posedge(4),
         HoldHigh             => thold_BCIN_CLK_posedge_posedge(4),
         HoldLow              => thold_BCIN_CLK_negedge_posedge(4),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_BCIN_CLK_posedge(5),
         TimingData           => Tmkr_BCIN_CLK_posedge(5),
         TestSignal           => BCIN_dly(5),
         TestSignalName       => "BCIN(5)",
         TestDelay            => tisd_BCIN_CLK(5),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_BCIN_CLK_posedge_posedge(5),
         SetupLow             => tsetup_BCIN_CLK_negedge_posedge(5),
         HoldHigh             => thold_BCIN_CLK_posedge_posedge(5),
         HoldLow              => thold_BCIN_CLK_negedge_posedge(5),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_BCIN_CLK_posedge(6),
         TimingData           => Tmkr_BCIN_CLK_posedge(6),
         TestSignal           => BCIN_dly(6),
         TestSignalName       => "BCIN(6)",
         TestDelay            => tisd_BCIN_CLK(6),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_BCIN_CLK_posedge_posedge(6),
         SetupLow             => tsetup_BCIN_CLK_negedge_posedge(6),
         HoldHigh             => thold_BCIN_CLK_posedge_posedge(6),
         HoldLow              => thold_BCIN_CLK_negedge_posedge(6),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_BCIN_CLK_posedge(7),
         TimingData           => Tmkr_BCIN_CLK_posedge(7),
         TestSignal           => BCIN_dly(7),
         TestSignalName       => "BCIN(7)",
         TestDelay            => tisd_BCIN_CLK(7),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_BCIN_CLK_posedge_posedge(7),
         SetupLow             => tsetup_BCIN_CLK_negedge_posedge(7),
         HoldHigh             => thold_BCIN_CLK_posedge_posedge(7),
         HoldLow              => thold_BCIN_CLK_negedge_posedge(7),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_BCIN_CLK_posedge(8),
         TimingData           => Tmkr_BCIN_CLK_posedge(8),
         TestSignal           => BCIN_dly(8),
         TestSignalName       => "BCIN(8)",
         TestDelay            => tisd_BCIN_CLK(8),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_BCIN_CLK_posedge_posedge(8),
         SetupLow             => tsetup_BCIN_CLK_negedge_posedge(8),
         HoldHigh             => thold_BCIN_CLK_posedge_posedge(8),
         HoldLow              => thold_BCIN_CLK_negedge_posedge(8),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_BCIN_CLK_posedge(9),
         TimingData           => Tmkr_BCIN_CLK_posedge(9),
         TestSignal           => BCIN_dly(9),
         TestSignalName       => "BCIN(9)",
         TestDelay            => tisd_BCIN_CLK(9),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_BCIN_CLK_posedge_posedge(9),
         SetupLow             => tsetup_BCIN_CLK_negedge_posedge(9),
         HoldHigh             => thold_BCIN_CLK_posedge_posedge(9),
         HoldLow              => thold_BCIN_CLK_negedge_posedge(9),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_BCIN_CLK_posedge(10),
         TimingData           => Tmkr_BCIN_CLK_posedge(10),
         TestSignal           => BCIN_dly(10),
         TestSignalName       => "BCIN(10)",
         TestDelay            => tisd_BCIN_CLK(10),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_BCIN_CLK_posedge_posedge(10),
         SetupLow             => tsetup_BCIN_CLK_negedge_posedge(10),
         HoldHigh             => thold_BCIN_CLK_posedge_posedge(10),
         HoldLow              => thold_BCIN_CLK_negedge_posedge(10),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_BCIN_CLK_posedge(11),
         TimingData           => Tmkr_BCIN_CLK_posedge(11),
         TestSignal           => BCIN_dly(11),
         TestSignalName       => "BCIN(11)",
         TestDelay            => tisd_BCIN_CLK(11),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_BCIN_CLK_posedge_posedge(11),
         SetupLow             => tsetup_BCIN_CLK_negedge_posedge(11),
         HoldHigh             => thold_BCIN_CLK_posedge_posedge(11),
         HoldLow              => thold_BCIN_CLK_negedge_posedge(11),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_BCIN_CLK_posedge(12),
         TimingData           => Tmkr_BCIN_CLK_posedge(12),
         TestSignal           => BCIN_dly(12),
         TestSignalName       => "BCIN(12)",
         TestDelay            => tisd_BCIN_CLK(12),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_BCIN_CLK_posedge_posedge(12),
         SetupLow             => tsetup_BCIN_CLK_negedge_posedge(12),
         HoldHigh             => thold_BCIN_CLK_posedge_posedge(12),
         HoldLow              => thold_BCIN_CLK_negedge_posedge(12),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_BCIN_CLK_posedge(13),
         TimingData           => Tmkr_BCIN_CLK_posedge(13),
         TestSignal           => BCIN_dly(13),
         TestSignalName       => "BCIN(13)",
         TestDelay            => tisd_BCIN_CLK(13),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_BCIN_CLK_posedge_posedge(13),
         SetupLow             => tsetup_BCIN_CLK_negedge_posedge(13),
         HoldHigh             => thold_BCIN_CLK_posedge_posedge(13),
         HoldLow              => thold_BCIN_CLK_negedge_posedge(13),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_BCIN_CLK_posedge(14),
         TimingData           => Tmkr_BCIN_CLK_posedge(14),
         TestSignal           => BCIN_dly(14),
         TestSignalName       => "BCIN(14)",
         TestDelay            => tisd_BCIN_CLK(14),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_BCIN_CLK_posedge_posedge(14),
         SetupLow             => tsetup_BCIN_CLK_negedge_posedge(14),
         HoldHigh             => thold_BCIN_CLK_posedge_posedge(14),
         HoldLow              => thold_BCIN_CLK_negedge_posedge(14),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_BCIN_CLK_posedge(15),
         TimingData           => Tmkr_BCIN_CLK_posedge(15),
         TestSignal           => BCIN_dly(15),
         TestSignalName       => "BCIN(15)",
         TestDelay            => tisd_BCIN_CLK(15),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_BCIN_CLK_posedge_posedge(15),
         SetupLow             => tsetup_BCIN_CLK_negedge_posedge(15),
         HoldHigh             => thold_BCIN_CLK_posedge_posedge(15),
         HoldLow              => thold_BCIN_CLK_negedge_posedge(15),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_BCIN_CLK_posedge(16),
         TimingData           => Tmkr_BCIN_CLK_posedge(16),
         TestSignal           => BCIN_dly(16),
         TestSignalName       => "BCIN(16)",
         TestDelay            => tisd_BCIN_CLK(16),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_BCIN_CLK_posedge_posedge(16),
         SetupLow             => tsetup_BCIN_CLK_negedge_posedge(16),
         HoldHigh             => thold_BCIN_CLK_posedge_posedge(16),
         HoldLow              => thold_BCIN_CLK_negedge_posedge(16),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
       VitalSetupHoldCheck (
         Violation            => Tviol_BCIN_CLK_posedge(17),
         TimingData           => Tmkr_BCIN_CLK_posedge(17),
         TestSignal           => BCIN_dly(17),
         TestSignalName       => "BCIN(17)",
         TestDelay            => tisd_BCIN_CLK(17),
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_BCIN_CLK_posedge_posedge(17),
         SetupLow             => tsetup_BCIN_CLK_negedge_posedge(17),
         HoldHigh             => thold_BCIN_CLK_posedge_posedge(17),
         HoldLow              => thold_BCIN_CLK_negedge_posedge(17),
         CheckEnabled         => (TO_X01((not RSTB_dly) and (CEB_dly)) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => True,
         MsgSeverity          => Error);
--=====  Vital SetupHold Checks signal CEA =====
       VitalSetupHoldCheck (
         Violation            => Tviol_CEA_CLK_posedge,
         TimingData           => Tmkr_CEA_CLK_posedge,
         TestSignal           => CEA_dly,
         TestSignalName       => "CEA",
         TestDelay            => tisd_CEA_CLK,
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_CEA_CLK_posedge_posedge,
         SetupLow             => tsetup_CEA_CLK_negedge_posedge,
         HoldHigh             => thold_CEA_CLK_posedge_posedge,
         HoldLow              => thold_CEA_CLK_negedge_posedge,
         CheckEnabled         => (TO_X01(not RSTA_dly) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => Error);
--=====  Vital SetupHold Checks signal CEB =====
       VitalSetupHoldCheck (
         Violation            => Tviol_CEB_CLK_posedge,
         TimingData           => Tmkr_CEB_CLK_posedge,
         TestSignal           => CEB_dly,
         TestSignalName       => "CEB",
         TestDelay            => tisd_CEB_CLK,
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_CEB_CLK_posedge_posedge,
         SetupLow             => tsetup_CEB_CLK_negedge_posedge,
         HoldHigh             => thold_CEB_CLK_posedge_posedge,
         HoldLow              => thold_CEB_CLK_negedge_posedge,
         CheckEnabled         => (TO_X01(not RSTB_dly) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => Error);
--=====  Vital SetupHold Checks signal CEP =====
       VitalSetupHoldCheck (
         Violation            => Tviol_CEP_CLK_posedge,
         TimingData           => Tmkr_CEP_CLK_posedge,
         TestSignal           => CEP_dly,
         TestSignalName       => "CEP",
         TestDelay            => tisd_CEP_CLK,
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_CEP_CLK_posedge_posedge,
         SetupLow             => tsetup_CEP_CLK_negedge_posedge,
         HoldHigh             => thold_CEP_CLK_posedge_posedge,
         HoldLow              => thold_CEP_CLK_negedge_posedge,
         CheckEnabled         => (TO_X01(not RSTP_dly) /= '0') and (TO_X01(GSR_dly) /= '1'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => Error);
--=====  Vital SetupHold Checks signal RSTA =====
       VitalSetupHoldCheck (
         Violation            => Tviol_RSTA_CLK_posedge,
         TimingData           => Tmkr_RSTA_CLK_posedge,
         TestSignal           => RSTA_dly,
         TestSignalName       => "RSTA",
         TestDelay            => tisd_RSTA_CLK,
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_RSTA_CLK_posedge_posedge,
         SetupLow             => tsetup_RSTA_CLK_negedge_posedge,
         HoldHigh             => thold_RSTA_CLK_posedge_posedge,
         HoldLow              => thold_RSTA_CLK_negedge_posedge,
         CheckEnabled         => (TO_X01(GSR_dly) = '0'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => Error);
--=====  Vital SetupHold Checks signal RSTB =====
       VitalSetupHoldCheck (
         Violation            => Tviol_RSTB_CLK_posedge,
         TimingData           => Tmkr_RSTB_CLK_posedge,
         TestSignal           => RSTB_dly,
         TestSignalName       => "RSTB",
         TestDelay            => tisd_RSTB_CLK,
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_RSTB_CLK_posedge_posedge,
         SetupLow             => tsetup_RSTB_CLK_negedge_posedge,
         HoldHigh             => thold_RSTB_CLK_posedge_posedge,
         HoldLow              => thold_RSTB_CLK_negedge_posedge,
         CheckEnabled         => (TO_X01(GSR_dly) = '0'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => Error);
--=====  Vital SetupHold Checks signal RSTP =====
       VitalSetupHoldCheck (
         Violation            => Tviol_RSTP_CLK_posedge,
         TimingData           => Tmkr_RSTP_CLK_posedge,
         TestSignal           => RSTP_dly,
         TestSignalName       => "RSTP",
         TestDelay            => tisd_RSTP_CLK,
         RefSignal            => CLK_dly,
         RefSignalName        => "CLK",
         RefDelay             => ticd_CLK,
         SetupHigh            => tsetup_RSTP_CLK_posedge_posedge,
         SetupLow             => tsetup_RSTP_CLK_negedge_posedge,
         HoldHigh             => thold_RSTP_CLK_posedge_posedge,
         HoldLow              => thold_RSTP_CLK_negedge_posedge,
         CheckEnabled         => (TO_X01(GSR_dly) = '0'),
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => Error);

       VitalPeriodPulseCheck (
         Violation            => Pviol_CLK,
         PeriodData           => PInfo_CLK,
         TestSignal           => CLK_dly,
         TestSignalName       => "CLK",
         TestDelay            => 0 ps,
         Period               => tperiod_CLK_posedge,
         PulseWidthHigh       => tpw_CLK_posedge,
         PulseWidthLow        => tpw_CLK_negedge,
         CheckEnabled         => (TO_X01(GSR_dly) = '0'),
         HeaderMsg            => InstancePath & "/X_MULT18X18SIO",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => Error);

    end if;
--======================  Path Delays  ======================
       VitalPathDelay01 (
         OutSignal	=> P(35),
         GlitchData	=> P_GlitchData(35),
         OutSignalName	=> "P(35)",
         OutTemp	=> P_zd(35),
         Paths		=> (
			0 => (A_dly(17)'last_event, tpd_A_P((647 - 0)- 36*0), true),
			1 => (A_dly(16)'last_event, tpd_A_P((647 - 0)- 36*1), true),
			2 => (A_dly(15)'last_event, tpd_A_P((647 - 0)- 36*2), true),
			3 => (A_dly(14)'last_event, tpd_A_P((647 - 0)- 36*3), true),
			4 => (A_dly(13)'last_event, tpd_A_P((647 - 0)- 36*4), true),
			5 => (A_dly(12)'last_event, tpd_A_P((647 - 0)- 36*5), true),
			6 => (A_dly(11)'last_event, tpd_A_P((647 - 0)- 36*6), true),
			7 => (A_dly(10)'last_event, tpd_A_P((647 - 0)- 36*7), true),
			8 => (A_dly(9)'last_event, tpd_A_P((647 - 0)- 36*8), true),
			9 => (A_dly(8)'last_event, tpd_A_P((647 - 0)- 36*9), true),
			10 => (A_dly(7)'last_event, tpd_A_P((647 - 0)- 36*10), true),
			11 => (A_dly(6)'last_event, tpd_A_P((647 - 0)- 36*11), true),
			12 => (A_dly(5)'last_event, tpd_A_P((647 - 0)- 36*12), true),
			13 => (A_dly(4)'last_event, tpd_A_P((647 - 0)- 36*13), true),
			14 => (A_dly(3)'last_event, tpd_A_P((647 - 0)- 36*14), true),
			15 => (A_dly(2)'last_event, tpd_A_P((647 - 0)- 36*15), true),
			16 => (A_dly(1)'last_event, tpd_A_P((647 - 0)- 36*16), true),
			17 => (A_dly(0)'last_event, tpd_A_P((647 - 0)- 36*17), true),
			18 => (B_dly(17)'last_event, tpd_B_P((647 - 0)- 36*0), true),
			19 => (B_dly(16)'last_event, tpd_B_P((647 - 0)- 36*1), true),
			20 => (B_dly(15)'last_event, tpd_B_P((647 - 0)- 36*2), true),
			21 => (B_dly(14)'last_event, tpd_B_P((647 - 0)- 36*3), true),
			22 => (B_dly(13)'last_event, tpd_B_P((647 - 0)- 36*4), true),
			23 => (B_dly(12)'last_event, tpd_B_P((647 - 0)- 36*5), true),
			24 => (B_dly(11)'last_event, tpd_B_P((647 - 0)- 36*6), true),
			25 => (B_dly(10)'last_event, tpd_B_P((647 - 0)- 36*7), true),
			26 => (B_dly(9)'last_event, tpd_B_P((647 - 0)- 36*8), true),
			27 => (B_dly(8)'last_event, tpd_B_P((647 - 0)- 36*9), true),
			28 => (B_dly(7)'last_event, tpd_B_P((647 - 0)- 36*10), true),
			29 => (B_dly(6)'last_event, tpd_B_P((647 - 0)- 36*11), true),
			30 => (B_dly(5)'last_event, tpd_B_P((647 - 0)- 36*12), true),
			31 => (B_dly(4)'last_event, tpd_B_P((647 - 0)- 36*13), true),
			32 => (B_dly(3)'last_event, tpd_B_P((647 - 0)- 36*14), true),
			33 => (B_dly(2)'last_event, tpd_B_P((647 - 0)- 36*15), true),
			34 => (B_dly(1)'last_event, tpd_B_P((647 - 0)- 36*16), true),
			35 => (B_dly(0)'last_event, tpd_B_P((647 - 0)- 36*17), true),
			36 => (BCIN_dly(17)'last_event, tpd_BCIN_P((647 - 0)- 36*0), true),
			37 => (BCIN_dly(16)'last_event, tpd_BCIN_P((647 - 0)- 36*1), true),
			38 => (BCIN_dly(15)'last_event, tpd_BCIN_P((647 - 0)- 36*2), true),
			39 => (BCIN_dly(14)'last_event, tpd_BCIN_P((647 - 0)- 36*3), true),
			40 => (BCIN_dly(13)'last_event, tpd_BCIN_P((647 - 0)- 36*4), true),
			41 => (BCIN_dly(12)'last_event, tpd_BCIN_P((647 - 0)- 36*5), true),
			42 => (BCIN_dly(11)'last_event, tpd_BCIN_P((647 - 0)- 36*6), true),
			43 => (BCIN_dly(10)'last_event, tpd_BCIN_P((647 - 0)- 36*7), true),
			44 => (BCIN_dly(9)'last_event, tpd_BCIN_P((647 - 0)- 36*8), true),
			45 => (BCIN_dly(8)'last_event, tpd_BCIN_P((647 - 0)- 36*9), true),
			46 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 0)- 36*10), true),
			47 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 0)- 36*11), true),
			48 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 0)- 36*12), true),
			49 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 0)- 36*13), true),
			50 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 0)- 36*14), true),
			51 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 0)- 36*15), true),
			52 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 0)- 36*16), true),
			53 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 0)- 36*17), true),
			54 => (CLK_dly'last_event, tpd_CLK_P(35), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(34),
         GlitchData	=> P_GlitchData(34),
         OutSignalName	=> "P(34)",
         OutTemp	=> P_zd(34),
         Paths		=> (
			0 => (A_dly(17)'last_event, tpd_A_P((647 - 1)- 36*0), true),
			1 => (A_dly(16)'last_event, tpd_A_P((647 - 1)- 36*1), true),
			2 => (A_dly(15)'last_event, tpd_A_P((647 - 1)- 36*2), true),
			3 => (A_dly(14)'last_event, tpd_A_P((647 - 1)- 36*3), true),
			4 => (A_dly(13)'last_event, tpd_A_P((647 - 1)- 36*4), true),
			5 => (A_dly(12)'last_event, tpd_A_P((647 - 1)- 36*5), true),
			6 => (A_dly(11)'last_event, tpd_A_P((647 - 1)- 36*6), true),
			7 => (A_dly(10)'last_event, tpd_A_P((647 - 1)- 36*7), true),
			8 => (A_dly(9)'last_event, tpd_A_P((647 - 1)- 36*8), true),
			9 => (A_dly(8)'last_event, tpd_A_P((647 - 1)- 36*9), true),
			10 => (A_dly(7)'last_event, tpd_A_P((647 - 1)- 36*10), true),
			11 => (A_dly(6)'last_event, tpd_A_P((647 - 1)- 36*11), true),
			12 => (A_dly(5)'last_event, tpd_A_P((647 - 1)- 36*12), true),
			13 => (A_dly(4)'last_event, tpd_A_P((647 - 1)- 36*13), true),
			14 => (A_dly(3)'last_event, tpd_A_P((647 - 1)- 36*14), true),
			15 => (A_dly(2)'last_event, tpd_A_P((647 - 1)- 36*15), true),
			16 => (A_dly(1)'last_event, tpd_A_P((647 - 1)- 36*16), true),
			17 => (A_dly(0)'last_event, tpd_A_P((647 - 1)- 36*17), true),
			18 => (B_dly(17)'last_event, tpd_B_P((647 - 1)- 36*0), true),
			19 => (B_dly(16)'last_event, tpd_B_P((647 - 1)- 36*1), true),
			20 => (B_dly(15)'last_event, tpd_B_P((647 - 1)- 36*2), true),
			21 => (B_dly(14)'last_event, tpd_B_P((647 - 1)- 36*3), true),
			22 => (B_dly(13)'last_event, tpd_B_P((647 - 1)- 36*4), true),
			23 => (B_dly(12)'last_event, tpd_B_P((647 - 1)- 36*5), true),
			24 => (B_dly(11)'last_event, tpd_B_P((647 - 1)- 36*6), true),
			25 => (B_dly(10)'last_event, tpd_B_P((647 - 1)- 36*7), true),
			26 => (B_dly(9)'last_event, tpd_B_P((647 - 1)- 36*8), true),
			27 => (B_dly(8)'last_event, tpd_B_P((647 - 1)- 36*9), true),
			28 => (B_dly(7)'last_event, tpd_B_P((647 - 1)- 36*10), true),
			29 => (B_dly(6)'last_event, tpd_B_P((647 - 1)- 36*11), true),
			30 => (B_dly(5)'last_event, tpd_B_P((647 - 1)- 36*12), true),
			31 => (B_dly(4)'last_event, tpd_B_P((647 - 1)- 36*13), true),
			32 => (B_dly(3)'last_event, tpd_B_P((647 - 1)- 36*14), true),
			33 => (B_dly(2)'last_event, tpd_B_P((647 - 1)- 36*15), true),
			34 => (B_dly(1)'last_event, tpd_B_P((647 - 1)- 36*16), true),
			35 => (B_dly(0)'last_event, tpd_B_P((647 - 1)- 36*17), true),
			36 => (BCIN_dly(17)'last_event, tpd_BCIN_P((647 - 1)- 36*0), true),
			37 => (BCIN_dly(16)'last_event, tpd_BCIN_P((647 - 1)- 36*1), true),
			38 => (BCIN_dly(15)'last_event, tpd_BCIN_P((647 - 1)- 36*2), true),
			39 => (BCIN_dly(14)'last_event, tpd_BCIN_P((647 - 1)- 36*3), true),
			40 => (BCIN_dly(13)'last_event, tpd_BCIN_P((647 - 1)- 36*4), true),
			41 => (BCIN_dly(12)'last_event, tpd_BCIN_P((647 - 1)- 36*5), true),
			42 => (BCIN_dly(11)'last_event, tpd_BCIN_P((647 - 1)- 36*6), true),
			43 => (BCIN_dly(10)'last_event, tpd_BCIN_P((647 - 1)- 36*7), true),
			44 => (BCIN_dly(9)'last_event, tpd_BCIN_P((647 - 1)- 36*8), true),
			45 => (BCIN_dly(8)'last_event, tpd_BCIN_P((647 - 1)- 36*9), true),
			46 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 1)- 36*10), true),
			47 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 1)- 36*11), true),
			48 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 1)- 36*12), true),
			49 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 1)- 36*13), true),
			50 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 1)- 36*14), true),
			51 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 1)- 36*15), true),
			52 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 1)- 36*16), true),
			53 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 1)- 36*17), true),
			54 => (CLK_dly'last_event, tpd_CLK_P(34), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(33),
         GlitchData	=> P_GlitchData(33),
         OutSignalName	=> "P(33)",
         OutTemp	=> P_zd(33),
         Paths		=> (
			0 => (A_dly(17)'last_event, tpd_A_P((647 - 2)- 36*0), true),
			1 => (A_dly(16)'last_event, tpd_A_P((647 - 2)- 36*1), true),
			2 => (A_dly(15)'last_event, tpd_A_P((647 - 2)- 36*2), true),
			3 => (A_dly(14)'last_event, tpd_A_P((647 - 2)- 36*3), true),
			4 => (A_dly(13)'last_event, tpd_A_P((647 - 2)- 36*4), true),
			5 => (A_dly(12)'last_event, tpd_A_P((647 - 2)- 36*5), true),
			6 => (A_dly(11)'last_event, tpd_A_P((647 - 2)- 36*6), true),
			7 => (A_dly(10)'last_event, tpd_A_P((647 - 2)- 36*7), true),
			8 => (A_dly(9)'last_event, tpd_A_P((647 - 2)- 36*8), true),
			9 => (A_dly(8)'last_event, tpd_A_P((647 - 2)- 36*9), true),
			10 => (A_dly(7)'last_event, tpd_A_P((647 - 2)- 36*10), true),
			11 => (A_dly(6)'last_event, tpd_A_P((647 - 2)- 36*11), true),
			12 => (A_dly(5)'last_event, tpd_A_P((647 - 2)- 36*12), true),
			13 => (A_dly(4)'last_event, tpd_A_P((647 - 2)- 36*13), true),
			14 => (A_dly(3)'last_event, tpd_A_P((647 - 2)- 36*14), true),
			15 => (A_dly(2)'last_event, tpd_A_P((647 - 2)- 36*15), true),
			16 => (A_dly(1)'last_event, tpd_A_P((647 - 2)- 36*16), true),
			17 => (A_dly(0)'last_event, tpd_A_P((647 - 2)- 36*17), true),
			18 => (B_dly(17)'last_event, tpd_B_P((647 - 2)- 36*0), true),
			19 => (B_dly(16)'last_event, tpd_B_P((647 - 2)- 36*1), true),
			20 => (B_dly(15)'last_event, tpd_B_P((647 - 2)- 36*2), true),
			21 => (B_dly(14)'last_event, tpd_B_P((647 - 2)- 36*3), true),
			22 => (B_dly(13)'last_event, tpd_B_P((647 - 2)- 36*4), true),
			23 => (B_dly(12)'last_event, tpd_B_P((647 - 2)- 36*5), true),
			24 => (B_dly(11)'last_event, tpd_B_P((647 - 2)- 36*6), true),
			25 => (B_dly(10)'last_event, tpd_B_P((647 - 2)- 36*7), true),
			26 => (B_dly(9)'last_event, tpd_B_P((647 - 2)- 36*8), true),
			27 => (B_dly(8)'last_event, tpd_B_P((647 - 2)- 36*9), true),
			28 => (B_dly(7)'last_event, tpd_B_P((647 - 2)- 36*10), true),
			29 => (B_dly(6)'last_event, tpd_B_P((647 - 2)- 36*11), true),
			30 => (B_dly(5)'last_event, tpd_B_P((647 - 2)- 36*12), true),
			31 => (B_dly(4)'last_event, tpd_B_P((647 - 2)- 36*13), true),
			32 => (B_dly(3)'last_event, tpd_B_P((647 - 2)- 36*14), true),
			33 => (B_dly(2)'last_event, tpd_B_P((647 - 2)- 36*15), true),
			34 => (B_dly(1)'last_event, tpd_B_P((647 - 2)- 36*16), true),
			35 => (B_dly(0)'last_event, tpd_B_P((647 - 2)- 36*17), true),
			36 => (BCIN_dly(17)'last_event, tpd_BCIN_P((647 - 2)- 36*0), true),
			37 => (BCIN_dly(16)'last_event, tpd_BCIN_P((647 - 2)- 36*1), true),
			38 => (BCIN_dly(15)'last_event, tpd_BCIN_P((647 - 2)- 36*2), true),
			39 => (BCIN_dly(14)'last_event, tpd_BCIN_P((647 - 2)- 36*3), true),
			40 => (BCIN_dly(13)'last_event, tpd_BCIN_P((647 - 2)- 36*4), true),
			41 => (BCIN_dly(12)'last_event, tpd_BCIN_P((647 - 2)- 36*5), true),
			42 => (BCIN_dly(11)'last_event, tpd_BCIN_P((647 - 2)- 36*6), true),
			43 => (BCIN_dly(10)'last_event, tpd_BCIN_P((647 - 2)- 36*7), true),
			44 => (BCIN_dly(9)'last_event, tpd_BCIN_P((647 - 2)- 36*8), true),
			45 => (BCIN_dly(8)'last_event, tpd_BCIN_P((647 - 2)- 36*9), true),
			46 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 2)- 36*10), true),
			47 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 2)- 36*11), true),
			48 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 2)- 36*12), true),
			49 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 2)- 36*13), true),
			50 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 2)- 36*14), true),
			51 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 2)- 36*15), true),
			52 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 2)- 36*16), true),
			53 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 2)- 36*17), true),
			54 => (CLK_dly'last_event, tpd_CLK_P(33), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(32),
         GlitchData	=> P_GlitchData(32),
         OutSignalName	=> "P(32)",
         OutTemp	=> P_zd(32),
         Paths		=> (
			0 => (A_dly(17)'last_event, tpd_A_P((647 - 3)- 36*0), true),
			1 => (A_dly(16)'last_event, tpd_A_P((647 - 3)- 36*1), true),
			2 => (A_dly(15)'last_event, tpd_A_P((647 - 3)- 36*2), true),
			3 => (A_dly(14)'last_event, tpd_A_P((647 - 3)- 36*3), true),
			4 => (A_dly(13)'last_event, tpd_A_P((647 - 3)- 36*4), true),
			5 => (A_dly(12)'last_event, tpd_A_P((647 - 3)- 36*5), true),
			6 => (A_dly(11)'last_event, tpd_A_P((647 - 3)- 36*6), true),
			7 => (A_dly(10)'last_event, tpd_A_P((647 - 3)- 36*7), true),
			8 => (A_dly(9)'last_event, tpd_A_P((647 - 3)- 36*8), true),
			9 => (A_dly(8)'last_event, tpd_A_P((647 - 3)- 36*9), true),
			10 => (A_dly(7)'last_event, tpd_A_P((647 - 3)- 36*10), true),
			11 => (A_dly(6)'last_event, tpd_A_P((647 - 3)- 36*11), true),
			12 => (A_dly(5)'last_event, tpd_A_P((647 - 3)- 36*12), true),
			13 => (A_dly(4)'last_event, tpd_A_P((647 - 3)- 36*13), true),
			14 => (A_dly(3)'last_event, tpd_A_P((647 - 3)- 36*14), true),
			15 => (A_dly(2)'last_event, tpd_A_P((647 - 3)- 36*15), true),
			16 => (A_dly(1)'last_event, tpd_A_P((647 - 3)- 36*16), true),
			17 => (A_dly(0)'last_event, tpd_A_P((647 - 3)- 36*17), true),
			18 => (B_dly(17)'last_event, tpd_B_P((647 - 3)- 36*0), true),
			19 => (B_dly(16)'last_event, tpd_B_P((647 - 3)- 36*1), true),
			20 => (B_dly(15)'last_event, tpd_B_P((647 - 3)- 36*2), true),
			21 => (B_dly(14)'last_event, tpd_B_P((647 - 3)- 36*3), true),
			22 => (B_dly(13)'last_event, tpd_B_P((647 - 3)- 36*4), true),
			23 => (B_dly(12)'last_event, tpd_B_P((647 - 3)- 36*5), true),
			24 => (B_dly(11)'last_event, tpd_B_P((647 - 3)- 36*6), true),
			25 => (B_dly(10)'last_event, tpd_B_P((647 - 3)- 36*7), true),
			26 => (B_dly(9)'last_event, tpd_B_P((647 - 3)- 36*8), true),
			27 => (B_dly(8)'last_event, tpd_B_P((647 - 3)- 36*9), true),
			28 => (B_dly(7)'last_event, tpd_B_P((647 - 3)- 36*10), true),
			29 => (B_dly(6)'last_event, tpd_B_P((647 - 3)- 36*11), true),
			30 => (B_dly(5)'last_event, tpd_B_P((647 - 3)- 36*12), true),
			31 => (B_dly(4)'last_event, tpd_B_P((647 - 3)- 36*13), true),
			32 => (B_dly(3)'last_event, tpd_B_P((647 - 3)- 36*14), true),
			33 => (B_dly(2)'last_event, tpd_B_P((647 - 3)- 36*15), true),
			34 => (B_dly(1)'last_event, tpd_B_P((647 - 3)- 36*16), true),
			35 => (B_dly(0)'last_event, tpd_B_P((647 - 3)- 36*17), true),
			36 => (BCIN_dly(17)'last_event, tpd_BCIN_P((647 - 3)- 36*0), true),
			37 => (BCIN_dly(16)'last_event, tpd_BCIN_P((647 - 3)- 36*1), true),
			38 => (BCIN_dly(15)'last_event, tpd_BCIN_P((647 - 3)- 36*2), true),
			39 => (BCIN_dly(14)'last_event, tpd_BCIN_P((647 - 3)- 36*3), true),
			40 => (BCIN_dly(13)'last_event, tpd_BCIN_P((647 - 3)- 36*4), true),
			41 => (BCIN_dly(12)'last_event, tpd_BCIN_P((647 - 3)- 36*5), true),
			42 => (BCIN_dly(11)'last_event, tpd_BCIN_P((647 - 3)- 36*6), true),
			43 => (BCIN_dly(10)'last_event, tpd_BCIN_P((647 - 3)- 36*7), true),
			44 => (BCIN_dly(9)'last_event, tpd_BCIN_P((647 - 3)- 36*8), true),
			45 => (BCIN_dly(8)'last_event, tpd_BCIN_P((647 - 3)- 36*9), true),
			46 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 3)- 36*10), true),
			47 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 3)- 36*11), true),
			48 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 3)- 36*12), true),
			49 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 3)- 36*13), true),
			50 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 3)- 36*14), true),
			51 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 3)- 36*15), true),
			52 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 3)- 36*16), true),
			53 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 3)- 36*17), true),
			54 => (CLK_dly'last_event, tpd_CLK_P(32), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(31),
         GlitchData	=> P_GlitchData(31),
         OutSignalName	=> "P(31)",
         OutTemp	=> P_zd(31),
         Paths		=> (
			0 => (A_dly(17)'last_event, tpd_A_P((647 - 4)- 36*0), true),
			1 => (A_dly(16)'last_event, tpd_A_P((647 - 4)- 36*1), true),
			2 => (A_dly(15)'last_event, tpd_A_P((647 - 4)- 36*2), true),
			3 => (A_dly(14)'last_event, tpd_A_P((647 - 4)- 36*3), true),
			4 => (A_dly(13)'last_event, tpd_A_P((647 - 4)- 36*4), true),
			5 => (A_dly(12)'last_event, tpd_A_P((647 - 4)- 36*5), true),
			6 => (A_dly(11)'last_event, tpd_A_P((647 - 4)- 36*6), true),
			7 => (A_dly(10)'last_event, tpd_A_P((647 - 4)- 36*7), true),
			8 => (A_dly(9)'last_event, tpd_A_P((647 - 4)- 36*8), true),
			9 => (A_dly(8)'last_event, tpd_A_P((647 - 4)- 36*9), true),
			10 => (A_dly(7)'last_event, tpd_A_P((647 - 4)- 36*10), true),
			11 => (A_dly(6)'last_event, tpd_A_P((647 - 4)- 36*11), true),
			12 => (A_dly(5)'last_event, tpd_A_P((647 - 4)- 36*12), true),
			13 => (A_dly(4)'last_event, tpd_A_P((647 - 4)- 36*13), true),
			14 => (A_dly(3)'last_event, tpd_A_P((647 - 4)- 36*14), true),
			15 => (A_dly(2)'last_event, tpd_A_P((647 - 4)- 36*15), true),
			16 => (A_dly(1)'last_event, tpd_A_P((647 - 4)- 36*16), true),
			17 => (A_dly(0)'last_event, tpd_A_P((647 - 4)- 36*17), true),
			18 => (B_dly(17)'last_event, tpd_B_P((647 - 4)- 36*0), true),
			19 => (B_dly(16)'last_event, tpd_B_P((647 - 4)- 36*1), true),
			20 => (B_dly(15)'last_event, tpd_B_P((647 - 4)- 36*2), true),
			21 => (B_dly(14)'last_event, tpd_B_P((647 - 4)- 36*3), true),
			22 => (B_dly(13)'last_event, tpd_B_P((647 - 4)- 36*4), true),
			23 => (B_dly(12)'last_event, tpd_B_P((647 - 4)- 36*5), true),
			24 => (B_dly(11)'last_event, tpd_B_P((647 - 4)- 36*6), true),
			25 => (B_dly(10)'last_event, tpd_B_P((647 - 4)- 36*7), true),
			26 => (B_dly(9)'last_event, tpd_B_P((647 - 4)- 36*8), true),
			27 => (B_dly(8)'last_event, tpd_B_P((647 - 4)- 36*9), true),
			28 => (B_dly(7)'last_event, tpd_B_P((647 - 4)- 36*10), true),
			29 => (B_dly(6)'last_event, tpd_B_P((647 - 4)- 36*11), true),
			30 => (B_dly(5)'last_event, tpd_B_P((647 - 4)- 36*12), true),
			31 => (B_dly(4)'last_event, tpd_B_P((647 - 4)- 36*13), true),
			32 => (B_dly(3)'last_event, tpd_B_P((647 - 4)- 36*14), true),
			33 => (B_dly(2)'last_event, tpd_B_P((647 - 4)- 36*15), true),
			34 => (B_dly(1)'last_event, tpd_B_P((647 - 4)- 36*16), true),
			35 => (B_dly(0)'last_event, tpd_B_P((647 - 4)- 36*17), true),
			36 => (BCIN_dly(17)'last_event, tpd_BCIN_P((647 - 4)- 36*0), true),
			37 => (BCIN_dly(16)'last_event, tpd_BCIN_P((647 - 4)- 36*1), true),
			38 => (BCIN_dly(15)'last_event, tpd_BCIN_P((647 - 4)- 36*2), true),
			39 => (BCIN_dly(14)'last_event, tpd_BCIN_P((647 - 4)- 36*3), true),
			40 => (BCIN_dly(13)'last_event, tpd_BCIN_P((647 - 4)- 36*4), true),
			41 => (BCIN_dly(12)'last_event, tpd_BCIN_P((647 - 4)- 36*5), true),
			42 => (BCIN_dly(11)'last_event, tpd_BCIN_P((647 - 4)- 36*6), true),
			43 => (BCIN_dly(10)'last_event, tpd_BCIN_P((647 - 4)- 36*7), true),
			44 => (BCIN_dly(9)'last_event, tpd_BCIN_P((647 - 4)- 36*8), true),
			45 => (BCIN_dly(8)'last_event, tpd_BCIN_P((647 - 4)- 36*9), true),
			46 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 4)- 36*10), true),
			47 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 4)- 36*11), true),
			48 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 4)- 36*12), true),
			49 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 4)- 36*13), true),
			50 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 4)- 36*14), true),
			51 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 4)- 36*15), true),
			52 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 4)- 36*16), true),
			53 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 4)- 36*17), true),
			54 => (CLK_dly'last_event, tpd_CLK_P(31), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(30),
         GlitchData	=> P_GlitchData(30),
         OutSignalName	=> "P(30)",
         OutTemp	=> P_zd(30),
         Paths		=> (
			0 => (A_dly(17)'last_event, tpd_A_P((647 - 5)- 36*0), true),
			1 => (A_dly(16)'last_event, tpd_A_P((647 - 5)- 36*1), true),
			2 => (A_dly(15)'last_event, tpd_A_P((647 - 5)- 36*2), true),
			3 => (A_dly(14)'last_event, tpd_A_P((647 - 5)- 36*3), true),
			4 => (A_dly(13)'last_event, tpd_A_P((647 - 5)- 36*4), true),
			5 => (A_dly(12)'last_event, tpd_A_P((647 - 5)- 36*5), true),
			6 => (A_dly(11)'last_event, tpd_A_P((647 - 5)- 36*6), true),
			7 => (A_dly(10)'last_event, tpd_A_P((647 - 5)- 36*7), true),
			8 => (A_dly(9)'last_event, tpd_A_P((647 - 5)- 36*8), true),
			9 => (A_dly(8)'last_event, tpd_A_P((647 - 5)- 36*9), true),
			10 => (A_dly(7)'last_event, tpd_A_P((647 - 5)- 36*10), true),
			11 => (A_dly(6)'last_event, tpd_A_P((647 - 5)- 36*11), true),
			12 => (A_dly(5)'last_event, tpd_A_P((647 - 5)- 36*12), true),
			13 => (A_dly(4)'last_event, tpd_A_P((647 - 5)- 36*13), true),
			14 => (A_dly(3)'last_event, tpd_A_P((647 - 5)- 36*14), true),
			15 => (A_dly(2)'last_event, tpd_A_P((647 - 5)- 36*15), true),
			16 => (A_dly(1)'last_event, tpd_A_P((647 - 5)- 36*16), true),
			17 => (A_dly(0)'last_event, tpd_A_P((647 - 5)- 36*17), true),
			18 => (B_dly(17)'last_event, tpd_B_P((647 - 5)- 36*0), true),
			19 => (B_dly(16)'last_event, tpd_B_P((647 - 5)- 36*1), true),
			20 => (B_dly(15)'last_event, tpd_B_P((647 - 5)- 36*2), true),
			21 => (B_dly(14)'last_event, tpd_B_P((647 - 5)- 36*3), true),
			22 => (B_dly(13)'last_event, tpd_B_P((647 - 5)- 36*4), true),
			23 => (B_dly(12)'last_event, tpd_B_P((647 - 5)- 36*5), true),
			24 => (B_dly(11)'last_event, tpd_B_P((647 - 5)- 36*6), true),
			25 => (B_dly(10)'last_event, tpd_B_P((647 - 5)- 36*7), true),
			26 => (B_dly(9)'last_event, tpd_B_P((647 - 5)- 36*8), true),
			27 => (B_dly(8)'last_event, tpd_B_P((647 - 5)- 36*9), true),
			28 => (B_dly(7)'last_event, tpd_B_P((647 - 5)- 36*10), true),
			29 => (B_dly(6)'last_event, tpd_B_P((647 - 5)- 36*11), true),
			30 => (B_dly(5)'last_event, tpd_B_P((647 - 5)- 36*12), true),
			31 => (B_dly(4)'last_event, tpd_B_P((647 - 5)- 36*13), true),
			32 => (B_dly(3)'last_event, tpd_B_P((647 - 5)- 36*14), true),
			33 => (B_dly(2)'last_event, tpd_B_P((647 - 5)- 36*15), true),
			34 => (B_dly(1)'last_event, tpd_B_P((647 - 5)- 36*16), true),
			35 => (B_dly(0)'last_event, tpd_B_P((647 - 5)- 36*17), true),
			36 => (BCIN_dly(17)'last_event, tpd_BCIN_P((647 - 5)- 36*0), true),
			37 => (BCIN_dly(16)'last_event, tpd_BCIN_P((647 - 5)- 36*1), true),
			38 => (BCIN_dly(15)'last_event, tpd_BCIN_P((647 - 5)- 36*2), true),
			39 => (BCIN_dly(14)'last_event, tpd_BCIN_P((647 - 5)- 36*3), true),
			40 => (BCIN_dly(13)'last_event, tpd_BCIN_P((647 - 5)- 36*4), true),
			41 => (BCIN_dly(12)'last_event, tpd_BCIN_P((647 - 5)- 36*5), true),
			42 => (BCIN_dly(11)'last_event, tpd_BCIN_P((647 - 5)- 36*6), true),
			43 => (BCIN_dly(10)'last_event, tpd_BCIN_P((647 - 5)- 36*7), true),
			44 => (BCIN_dly(9)'last_event, tpd_BCIN_P((647 - 5)- 36*8), true),
			45 => (BCIN_dly(8)'last_event, tpd_BCIN_P((647 - 5)- 36*9), true),
			46 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 5)- 36*10), true),
			47 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 5)- 36*11), true),
			48 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 5)- 36*12), true),
			49 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 5)- 36*13), true),
			50 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 5)- 36*14), true),
			51 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 5)- 36*15), true),
			52 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 5)- 36*16), true),
			53 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 5)- 36*17), true),
			54 => (CLK_dly'last_event, tpd_CLK_P(30), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(29),
         GlitchData	=> P_GlitchData(29),
         OutSignalName	=> "P(29)",
         OutTemp	=> P_zd(29),
         Paths		=> (
			0 => (A_dly(17)'last_event, tpd_A_P((647 - 6)- 36*0), true),
			1 => (A_dly(16)'last_event, tpd_A_P((647 - 6)- 36*1), true),
			2 => (A_dly(15)'last_event, tpd_A_P((647 - 6)- 36*2), true),
			3 => (A_dly(14)'last_event, tpd_A_P((647 - 6)- 36*3), true),
			4 => (A_dly(13)'last_event, tpd_A_P((647 - 6)- 36*4), true),
			5 => (A_dly(12)'last_event, tpd_A_P((647 - 6)- 36*5), true),
			6 => (A_dly(11)'last_event, tpd_A_P((647 - 6)- 36*6), true),
			7 => (A_dly(10)'last_event, tpd_A_P((647 - 6)- 36*7), true),
			8 => (A_dly(9)'last_event, tpd_A_P((647 - 6)- 36*8), true),
			9 => (A_dly(8)'last_event, tpd_A_P((647 - 6)- 36*9), true),
			10 => (A_dly(7)'last_event, tpd_A_P((647 - 6)- 36*10), true),
			11 => (A_dly(6)'last_event, tpd_A_P((647 - 6)- 36*11), true),
			12 => (A_dly(5)'last_event, tpd_A_P((647 - 6)- 36*12), true),
			13 => (A_dly(4)'last_event, tpd_A_P((647 - 6)- 36*13), true),
			14 => (A_dly(3)'last_event, tpd_A_P((647 - 6)- 36*14), true),
			15 => (A_dly(2)'last_event, tpd_A_P((647 - 6)- 36*15), true),
			16 => (A_dly(1)'last_event, tpd_A_P((647 - 6)- 36*16), true),
			17 => (A_dly(0)'last_event, tpd_A_P((647 - 6)- 36*17), true),
			18 => (B_dly(17)'last_event, tpd_B_P((647 - 6)- 36*0), true),
			19 => (B_dly(16)'last_event, tpd_B_P((647 - 6)- 36*1), true),
			20 => (B_dly(15)'last_event, tpd_B_P((647 - 6)- 36*2), true),
			21 => (B_dly(14)'last_event, tpd_B_P((647 - 6)- 36*3), true),
			22 => (B_dly(13)'last_event, tpd_B_P((647 - 6)- 36*4), true),
			23 => (B_dly(12)'last_event, tpd_B_P((647 - 6)- 36*5), true),
			24 => (B_dly(11)'last_event, tpd_B_P((647 - 6)- 36*6), true),
			25 => (B_dly(10)'last_event, tpd_B_P((647 - 6)- 36*7), true),
			26 => (B_dly(9)'last_event, tpd_B_P((647 - 6)- 36*8), true),
			27 => (B_dly(8)'last_event, tpd_B_P((647 - 6)- 36*9), true),
			28 => (B_dly(7)'last_event, tpd_B_P((647 - 6)- 36*10), true),
			29 => (B_dly(6)'last_event, tpd_B_P((647 - 6)- 36*11), true),
			30 => (B_dly(5)'last_event, tpd_B_P((647 - 6)- 36*12), true),
			31 => (B_dly(4)'last_event, tpd_B_P((647 - 6)- 36*13), true),
			32 => (B_dly(3)'last_event, tpd_B_P((647 - 6)- 36*14), true),
			33 => (B_dly(2)'last_event, tpd_B_P((647 - 6)- 36*15), true),
			34 => (B_dly(1)'last_event, tpd_B_P((647 - 6)- 36*16), true),
			35 => (B_dly(0)'last_event, tpd_B_P((647 - 6)- 36*17), true),
			36 => (BCIN_dly(17)'last_event, tpd_BCIN_P((647 - 6)- 36*0), true),
			37 => (BCIN_dly(16)'last_event, tpd_BCIN_P((647 - 6)- 36*1), true),
			38 => (BCIN_dly(15)'last_event, tpd_BCIN_P((647 - 6)- 36*2), true),
			39 => (BCIN_dly(14)'last_event, tpd_BCIN_P((647 - 6)- 36*3), true),
			40 => (BCIN_dly(13)'last_event, tpd_BCIN_P((647 - 6)- 36*4), true),
			41 => (BCIN_dly(12)'last_event, tpd_BCIN_P((647 - 6)- 36*5), true),
			42 => (BCIN_dly(11)'last_event, tpd_BCIN_P((647 - 6)- 36*6), true),
			43 => (BCIN_dly(10)'last_event, tpd_BCIN_P((647 - 6)- 36*7), true),
			44 => (BCIN_dly(9)'last_event, tpd_BCIN_P((647 - 6)- 36*8), true),
			45 => (BCIN_dly(8)'last_event, tpd_BCIN_P((647 - 6)- 36*9), true),
			46 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 6)- 36*10), true),
			47 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 6)- 36*11), true),
			48 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 6)- 36*12), true),
			49 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 6)- 36*13), true),
			50 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 6)- 36*14), true),
			51 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 6)- 36*15), true),
			52 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 6)- 36*16), true),
			53 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 6)- 36*17), true),
			54 => (CLK_dly'last_event, tpd_CLK_P(29), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(28),
         GlitchData	=> P_GlitchData(28),
         OutSignalName	=> "P(28)",
         OutTemp	=> P_zd(28),
         Paths		=> (
			0 => (A_dly(17)'last_event, tpd_A_P((647 - 7)- 36*0), true),
			1 => (A_dly(16)'last_event, tpd_A_P((647 - 7)- 36*1), true),
			2 => (A_dly(15)'last_event, tpd_A_P((647 - 7)- 36*2), true),
			3 => (A_dly(14)'last_event, tpd_A_P((647 - 7)- 36*3), true),
			4 => (A_dly(13)'last_event, tpd_A_P((647 - 7)- 36*4), true),
			5 => (A_dly(12)'last_event, tpd_A_P((647 - 7)- 36*5), true),
			6 => (A_dly(11)'last_event, tpd_A_P((647 - 7)- 36*6), true),
			7 => (A_dly(10)'last_event, tpd_A_P((647 - 7)- 36*7), true),
			8 => (A_dly(9)'last_event, tpd_A_P((647 - 7)- 36*8), true),
			9 => (A_dly(8)'last_event, tpd_A_P((647 - 7)- 36*9), true),
			10 => (A_dly(7)'last_event, tpd_A_P((647 - 7)- 36*10), true),
			11 => (A_dly(6)'last_event, tpd_A_P((647 - 7)- 36*11), true),
			12 => (A_dly(5)'last_event, tpd_A_P((647 - 7)- 36*12), true),
			13 => (A_dly(4)'last_event, tpd_A_P((647 - 7)- 36*13), true),
			14 => (A_dly(3)'last_event, tpd_A_P((647 - 7)- 36*14), true),
			15 => (A_dly(2)'last_event, tpd_A_P((647 - 7)- 36*15), true),
			16 => (A_dly(1)'last_event, tpd_A_P((647 - 7)- 36*16), true),
			17 => (A_dly(0)'last_event, tpd_A_P((647 - 7)- 36*17), true),
			18 => (B_dly(17)'last_event, tpd_B_P((647 - 7)- 36*0), true),
			19 => (B_dly(16)'last_event, tpd_B_P((647 - 7)- 36*1), true),
			20 => (B_dly(15)'last_event, tpd_B_P((647 - 7)- 36*2), true),
			21 => (B_dly(14)'last_event, tpd_B_P((647 - 7)- 36*3), true),
			22 => (B_dly(13)'last_event, tpd_B_P((647 - 7)- 36*4), true),
			23 => (B_dly(12)'last_event, tpd_B_P((647 - 7)- 36*5), true),
			24 => (B_dly(11)'last_event, tpd_B_P((647 - 7)- 36*6), true),
			25 => (B_dly(10)'last_event, tpd_B_P((647 - 7)- 36*7), true),
			26 => (B_dly(9)'last_event, tpd_B_P((647 - 7)- 36*8), true),
			27 => (B_dly(8)'last_event, tpd_B_P((647 - 7)- 36*9), true),
			28 => (B_dly(7)'last_event, tpd_B_P((647 - 7)- 36*10), true),
			29 => (B_dly(6)'last_event, tpd_B_P((647 - 7)- 36*11), true),
			30 => (B_dly(5)'last_event, tpd_B_P((647 - 7)- 36*12), true),
			31 => (B_dly(4)'last_event, tpd_B_P((647 - 7)- 36*13), true),
			32 => (B_dly(3)'last_event, tpd_B_P((647 - 7)- 36*14), true),
			33 => (B_dly(2)'last_event, tpd_B_P((647 - 7)- 36*15), true),
			34 => (B_dly(1)'last_event, tpd_B_P((647 - 7)- 36*16), true),
			35 => (B_dly(0)'last_event, tpd_B_P((647 - 7)- 36*17), true),
			36 => (BCIN_dly(17)'last_event, tpd_BCIN_P((647 - 7)- 36*0), true),
			37 => (BCIN_dly(16)'last_event, tpd_BCIN_P((647 - 7)- 36*1), true),
			38 => (BCIN_dly(15)'last_event, tpd_BCIN_P((647 - 7)- 36*2), true),
			39 => (BCIN_dly(14)'last_event, tpd_BCIN_P((647 - 7)- 36*3), true),
			40 => (BCIN_dly(13)'last_event, tpd_BCIN_P((647 - 7)- 36*4), true),
			41 => (BCIN_dly(12)'last_event, tpd_BCIN_P((647 - 7)- 36*5), true),
			42 => (BCIN_dly(11)'last_event, tpd_BCIN_P((647 - 7)- 36*6), true),
			43 => (BCIN_dly(10)'last_event, tpd_BCIN_P((647 - 7)- 36*7), true),
			44 => (BCIN_dly(9)'last_event, tpd_BCIN_P((647 - 7)- 36*8), true),
			45 => (BCIN_dly(8)'last_event, tpd_BCIN_P((647 - 7)- 36*9), true),
			46 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 7)- 36*10), true),
			47 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 7)- 36*11), true),
			48 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 7)- 36*12), true),
			49 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 7)- 36*13), true),
			50 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 7)- 36*14), true),
			51 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 7)- 36*15), true),
			52 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 7)- 36*16), true),
			53 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 7)- 36*17), true),
			54 => (CLK_dly'last_event, tpd_CLK_P(28), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(27),
         GlitchData	=> P_GlitchData(27),
         OutSignalName	=> "P(27)",
         OutTemp	=> P_zd(27),
         Paths		=> (
			0 => (A_dly(17)'last_event, tpd_A_P((647 - 8)- 36*0), true),
			1 => (A_dly(16)'last_event, tpd_A_P((647 - 8)- 36*1), true),
			2 => (A_dly(15)'last_event, tpd_A_P((647 - 8)- 36*2), true),
			3 => (A_dly(14)'last_event, tpd_A_P((647 - 8)- 36*3), true),
			4 => (A_dly(13)'last_event, tpd_A_P((647 - 8)- 36*4), true),
			5 => (A_dly(12)'last_event, tpd_A_P((647 - 8)- 36*5), true),
			6 => (A_dly(11)'last_event, tpd_A_P((647 - 8)- 36*6), true),
			7 => (A_dly(10)'last_event, tpd_A_P((647 - 8)- 36*7), true),
			8 => (A_dly(9)'last_event, tpd_A_P((647 - 8)- 36*8), true),
			9 => (A_dly(8)'last_event, tpd_A_P((647 - 8)- 36*9), true),
			10 => (A_dly(7)'last_event, tpd_A_P((647 - 8)- 36*10), true),
			11 => (A_dly(6)'last_event, tpd_A_P((647 - 8)- 36*11), true),
			12 => (A_dly(5)'last_event, tpd_A_P((647 - 8)- 36*12), true),
			13 => (A_dly(4)'last_event, tpd_A_P((647 - 8)- 36*13), true),
			14 => (A_dly(3)'last_event, tpd_A_P((647 - 8)- 36*14), true),
			15 => (A_dly(2)'last_event, tpd_A_P((647 - 8)- 36*15), true),
			16 => (A_dly(1)'last_event, tpd_A_P((647 - 8)- 36*16), true),
			17 => (A_dly(0)'last_event, tpd_A_P((647 - 8)- 36*17), true),
			18 => (B_dly(17)'last_event, tpd_B_P((647 - 8)- 36*0), true),
			19 => (B_dly(16)'last_event, tpd_B_P((647 - 8)- 36*1), true),
			20 => (B_dly(15)'last_event, tpd_B_P((647 - 8)- 36*2), true),
			21 => (B_dly(14)'last_event, tpd_B_P((647 - 8)- 36*3), true),
			22 => (B_dly(13)'last_event, tpd_B_P((647 - 8)- 36*4), true),
			23 => (B_dly(12)'last_event, tpd_B_P((647 - 8)- 36*5), true),
			24 => (B_dly(11)'last_event, tpd_B_P((647 - 8)- 36*6), true),
			25 => (B_dly(10)'last_event, tpd_B_P((647 - 8)- 36*7), true),
			26 => (B_dly(9)'last_event, tpd_B_P((647 - 8)- 36*8), true),
			27 => (B_dly(8)'last_event, tpd_B_P((647 - 8)- 36*9), true),
			28 => (B_dly(7)'last_event, tpd_B_P((647 - 8)- 36*10), true),
			29 => (B_dly(6)'last_event, tpd_B_P((647 - 8)- 36*11), true),
			30 => (B_dly(5)'last_event, tpd_B_P((647 - 8)- 36*12), true),
			31 => (B_dly(4)'last_event, tpd_B_P((647 - 8)- 36*13), true),
			32 => (B_dly(3)'last_event, tpd_B_P((647 - 8)- 36*14), true),
			33 => (B_dly(2)'last_event, tpd_B_P((647 - 8)- 36*15), true),
			34 => (B_dly(1)'last_event, tpd_B_P((647 - 8)- 36*16), true),
			35 => (B_dly(0)'last_event, tpd_B_P((647 - 8)- 36*17), true),
			36 => (BCIN_dly(17)'last_event, tpd_BCIN_P((647 - 8)- 36*0), true),
			37 => (BCIN_dly(16)'last_event, tpd_BCIN_P((647 - 8)- 36*1), true),
			38 => (BCIN_dly(15)'last_event, tpd_BCIN_P((647 - 8)- 36*2), true),
			39 => (BCIN_dly(14)'last_event, tpd_BCIN_P((647 - 8)- 36*3), true),
			40 => (BCIN_dly(13)'last_event, tpd_BCIN_P((647 - 8)- 36*4), true),
			41 => (BCIN_dly(12)'last_event, tpd_BCIN_P((647 - 8)- 36*5), true),
			42 => (BCIN_dly(11)'last_event, tpd_BCIN_P((647 - 8)- 36*6), true),
			43 => (BCIN_dly(10)'last_event, tpd_BCIN_P((647 - 8)- 36*7), true),
			44 => (BCIN_dly(9)'last_event, tpd_BCIN_P((647 - 8)- 36*8), true),
			45 => (BCIN_dly(8)'last_event, tpd_BCIN_P((647 - 8)- 36*9), true),
			46 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 8)- 36*10), true),
			47 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 8)- 36*11), true),
			48 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 8)- 36*12), true),
			49 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 8)- 36*13), true),
			50 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 8)- 36*14), true),
			51 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 8)- 36*15), true),
			52 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 8)- 36*16), true),
			53 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 8)- 36*17), true),
			54 => (CLK_dly'last_event, tpd_CLK_P(27), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(26),
         GlitchData	=> P_GlitchData(26),
         OutSignalName	=> "P(26)",
         OutTemp	=> P_zd(26),
         Paths		=> (
			0 => (A_dly(17)'last_event, tpd_A_P((647 - 9)- 36*0), true),
			1 => (A_dly(16)'last_event, tpd_A_P((647 - 9)- 36*1), true),
			2 => (A_dly(15)'last_event, tpd_A_P((647 - 9)- 36*2), true),
			3 => (A_dly(14)'last_event, tpd_A_P((647 - 9)- 36*3), true),
			4 => (A_dly(13)'last_event, tpd_A_P((647 - 9)- 36*4), true),
			5 => (A_dly(12)'last_event, tpd_A_P((647 - 9)- 36*5), true),
			6 => (A_dly(11)'last_event, tpd_A_P((647 - 9)- 36*6), true),
			7 => (A_dly(10)'last_event, tpd_A_P((647 - 9)- 36*7), true),
			8 => (A_dly(9)'last_event, tpd_A_P((647 - 9)- 36*8), true),
			9 => (A_dly(8)'last_event, tpd_A_P((647 - 9)- 36*9), true),
			10 => (A_dly(7)'last_event, tpd_A_P((647 - 9)- 36*10), true),
			11 => (A_dly(6)'last_event, tpd_A_P((647 - 9)- 36*11), true),
			12 => (A_dly(5)'last_event, tpd_A_P((647 - 9)- 36*12), true),
			13 => (A_dly(4)'last_event, tpd_A_P((647 - 9)- 36*13), true),
			14 => (A_dly(3)'last_event, tpd_A_P((647 - 9)- 36*14), true),
			15 => (A_dly(2)'last_event, tpd_A_P((647 - 9)- 36*15), true),
			16 => (A_dly(1)'last_event, tpd_A_P((647 - 9)- 36*16), true),
			17 => (A_dly(0)'last_event, tpd_A_P((647 - 9)- 36*17), true),
			18 => (B_dly(17)'last_event, tpd_B_P((647 - 9)- 36*0), true),
			19 => (B_dly(16)'last_event, tpd_B_P((647 - 9)- 36*1), true),
			20 => (B_dly(15)'last_event, tpd_B_P((647 - 9)- 36*2), true),
			21 => (B_dly(14)'last_event, tpd_B_P((647 - 9)- 36*3), true),
			22 => (B_dly(13)'last_event, tpd_B_P((647 - 9)- 36*4), true),
			23 => (B_dly(12)'last_event, tpd_B_P((647 - 9)- 36*5), true),
			24 => (B_dly(11)'last_event, tpd_B_P((647 - 9)- 36*6), true),
			25 => (B_dly(10)'last_event, tpd_B_P((647 - 9)- 36*7), true),
			26 => (B_dly(9)'last_event, tpd_B_P((647 - 9)- 36*8), true),
			27 => (B_dly(8)'last_event, tpd_B_P((647 - 9)- 36*9), true),
			28 => (B_dly(7)'last_event, tpd_B_P((647 - 9)- 36*10), true),
			29 => (B_dly(6)'last_event, tpd_B_P((647 - 9)- 36*11), true),
			30 => (B_dly(5)'last_event, tpd_B_P((647 - 9)- 36*12), true),
			31 => (B_dly(4)'last_event, tpd_B_P((647 - 9)- 36*13), true),
			32 => (B_dly(3)'last_event, tpd_B_P((647 - 9)- 36*14), true),
			33 => (B_dly(2)'last_event, tpd_B_P((647 - 9)- 36*15), true),
			34 => (B_dly(1)'last_event, tpd_B_P((647 - 9)- 36*16), true),
			35 => (B_dly(0)'last_event, tpd_B_P((647 - 9)- 36*17), true),
			36 => (BCIN_dly(17)'last_event, tpd_BCIN_P((647 - 9)- 36*0), true),
			37 => (BCIN_dly(16)'last_event, tpd_BCIN_P((647 - 9)- 36*1), true),
			38 => (BCIN_dly(15)'last_event, tpd_BCIN_P((647 - 9)- 36*2), true),
			39 => (BCIN_dly(14)'last_event, tpd_BCIN_P((647 - 9)- 36*3), true),
			40 => (BCIN_dly(13)'last_event, tpd_BCIN_P((647 - 9)- 36*4), true),
			41 => (BCIN_dly(12)'last_event, tpd_BCIN_P((647 - 9)- 36*5), true),
			42 => (BCIN_dly(11)'last_event, tpd_BCIN_P((647 - 9)- 36*6), true),
			43 => (BCIN_dly(10)'last_event, tpd_BCIN_P((647 - 9)- 36*7), true),
			44 => (BCIN_dly(9)'last_event, tpd_BCIN_P((647 - 9)- 36*8), true),
			45 => (BCIN_dly(8)'last_event, tpd_BCIN_P((647 - 9)- 36*9), true),
			46 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 9)- 36*10), true),
			47 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 9)- 36*11), true),
			48 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 9)- 36*12), true),
			49 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 9)- 36*13), true),
			50 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 9)- 36*14), true),
			51 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 9)- 36*15), true),
			52 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 9)- 36*16), true),
			53 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 9)- 36*17), true),
			54 => (CLK_dly'last_event, tpd_CLK_P(26), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(25),
         GlitchData	=> P_GlitchData(25),
         OutSignalName	=> "P(25)",
         OutTemp	=> P_zd(25),
         Paths		=> (
			0 => (A_dly(17)'last_event, tpd_A_P((647 - 10)- 36*0), true),
			1 => (A_dly(16)'last_event, tpd_A_P((647 - 10)- 36*1), true),
			2 => (A_dly(15)'last_event, tpd_A_P((647 - 10)- 36*2), true),
			3 => (A_dly(14)'last_event, tpd_A_P((647 - 10)- 36*3), true),
			4 => (A_dly(13)'last_event, tpd_A_P((647 - 10)- 36*4), true),
			5 => (A_dly(12)'last_event, tpd_A_P((647 - 10)- 36*5), true),
			6 => (A_dly(11)'last_event, tpd_A_P((647 - 10)- 36*6), true),
			7 => (A_dly(10)'last_event, tpd_A_P((647 - 10)- 36*7), true),
			8 => (A_dly(9)'last_event, tpd_A_P((647 - 10)- 36*8), true),
			9 => (A_dly(8)'last_event, tpd_A_P((647 - 10)- 36*9), true),
			10 => (A_dly(7)'last_event, tpd_A_P((647 - 10)- 36*10), true),
			11 => (A_dly(6)'last_event, tpd_A_P((647 - 10)- 36*11), true),
			12 => (A_dly(5)'last_event, tpd_A_P((647 - 10)- 36*12), true),
			13 => (A_dly(4)'last_event, tpd_A_P((647 - 10)- 36*13), true),
			14 => (A_dly(3)'last_event, tpd_A_P((647 - 10)- 36*14), true),
			15 => (A_dly(2)'last_event, tpd_A_P((647 - 10)- 36*15), true),
			16 => (A_dly(1)'last_event, tpd_A_P((647 - 10)- 36*16), true),
			17 => (A_dly(0)'last_event, tpd_A_P((647 - 10)- 36*17), true),
			18 => (B_dly(17)'last_event, tpd_B_P((647 - 10)- 36*0), true),
			19 => (B_dly(16)'last_event, tpd_B_P((647 - 10)- 36*1), true),
			20 => (B_dly(15)'last_event, tpd_B_P((647 - 10)- 36*2), true),
			21 => (B_dly(14)'last_event, tpd_B_P((647 - 10)- 36*3), true),
			22 => (B_dly(13)'last_event, tpd_B_P((647 - 10)- 36*4), true),
			23 => (B_dly(12)'last_event, tpd_B_P((647 - 10)- 36*5), true),
			24 => (B_dly(11)'last_event, tpd_B_P((647 - 10)- 36*6), true),
			25 => (B_dly(10)'last_event, tpd_B_P((647 - 10)- 36*7), true),
			26 => (B_dly(9)'last_event, tpd_B_P((647 - 10)- 36*8), true),
			27 => (B_dly(8)'last_event, tpd_B_P((647 - 10)- 36*9), true),
			28 => (B_dly(7)'last_event, tpd_B_P((647 - 10)- 36*10), true),
			29 => (B_dly(6)'last_event, tpd_B_P((647 - 10)- 36*11), true),
			30 => (B_dly(5)'last_event, tpd_B_P((647 - 10)- 36*12), true),
			31 => (B_dly(4)'last_event, tpd_B_P((647 - 10)- 36*13), true),
			32 => (B_dly(3)'last_event, tpd_B_P((647 - 10)- 36*14), true),
			33 => (B_dly(2)'last_event, tpd_B_P((647 - 10)- 36*15), true),
			34 => (B_dly(1)'last_event, tpd_B_P((647 - 10)- 36*16), true),
			35 => (B_dly(0)'last_event, tpd_B_P((647 - 10)- 36*17), true),
			36 => (BCIN_dly(17)'last_event, tpd_BCIN_P((647 - 10)- 36*0), true),
			37 => (BCIN_dly(16)'last_event, tpd_BCIN_P((647 - 10)- 36*1), true),
			38 => (BCIN_dly(15)'last_event, tpd_BCIN_P((647 - 10)- 36*2), true),
			39 => (BCIN_dly(14)'last_event, tpd_BCIN_P((647 - 10)- 36*3), true),
			40 => (BCIN_dly(13)'last_event, tpd_BCIN_P((647 - 10)- 36*4), true),
			41 => (BCIN_dly(12)'last_event, tpd_BCIN_P((647 - 10)- 36*5), true),
			42 => (BCIN_dly(11)'last_event, tpd_BCIN_P((647 - 10)- 36*6), true),
			43 => (BCIN_dly(10)'last_event, tpd_BCIN_P((647 - 10)- 36*7), true),
			44 => (BCIN_dly(9)'last_event, tpd_BCIN_P((647 - 10)- 36*8), true),
			45 => (BCIN_dly(8)'last_event, tpd_BCIN_P((647 - 10)- 36*9), true),
			46 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 10)- 36*10), true),
			47 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 10)- 36*11), true),
			48 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 10)- 36*12), true),
			49 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 10)- 36*13), true),
			50 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 10)- 36*14), true),
			51 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 10)- 36*15), true),
			52 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 10)- 36*16), true),
			53 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 10)- 36*17), true),
			54 => (CLK_dly'last_event, tpd_CLK_P(25), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(24),
         GlitchData	=> P_GlitchData(24),
         OutSignalName	=> "P(24)",
         OutTemp	=> P_zd(24),
         Paths		=> (
			0 => (A_dly(17)'last_event, tpd_A_P((647 - 11)- 36*0), true),
			1 => (A_dly(16)'last_event, tpd_A_P((647 - 11)- 36*1), true),
			2 => (A_dly(15)'last_event, tpd_A_P((647 - 11)- 36*2), true),
			3 => (A_dly(14)'last_event, tpd_A_P((647 - 11)- 36*3), true),
			4 => (A_dly(13)'last_event, tpd_A_P((647 - 11)- 36*4), true),
			5 => (A_dly(12)'last_event, tpd_A_P((647 - 11)- 36*5), true),
			6 => (A_dly(11)'last_event, tpd_A_P((647 - 11)- 36*6), true),
			7 => (A_dly(10)'last_event, tpd_A_P((647 - 11)- 36*7), true),
			8 => (A_dly(9)'last_event, tpd_A_P((647 - 11)- 36*8), true),
			9 => (A_dly(8)'last_event, tpd_A_P((647 - 11)- 36*9), true),
			10 => (A_dly(7)'last_event, tpd_A_P((647 - 11)- 36*10), true),
			11 => (A_dly(6)'last_event, tpd_A_P((647 - 11)- 36*11), true),
			12 => (A_dly(5)'last_event, tpd_A_P((647 - 11)- 36*12), true),
			13 => (A_dly(4)'last_event, tpd_A_P((647 - 11)- 36*13), true),
			14 => (A_dly(3)'last_event, tpd_A_P((647 - 11)- 36*14), true),
			15 => (A_dly(2)'last_event, tpd_A_P((647 - 11)- 36*15), true),
			16 => (A_dly(1)'last_event, tpd_A_P((647 - 11)- 36*16), true),
			17 => (A_dly(0)'last_event, tpd_A_P((647 - 11)- 36*17), true),
			18 => (B_dly(17)'last_event, tpd_B_P((647 - 11)- 36*0), true),
			19 => (B_dly(16)'last_event, tpd_B_P((647 - 11)- 36*1), true),
			20 => (B_dly(15)'last_event, tpd_B_P((647 - 11)- 36*2), true),
			21 => (B_dly(14)'last_event, tpd_B_P((647 - 11)- 36*3), true),
			22 => (B_dly(13)'last_event, tpd_B_P((647 - 11)- 36*4), true),
			23 => (B_dly(12)'last_event, tpd_B_P((647 - 11)- 36*5), true),
			24 => (B_dly(11)'last_event, tpd_B_P((647 - 11)- 36*6), true),
			25 => (B_dly(10)'last_event, tpd_B_P((647 - 11)- 36*7), true),
			26 => (B_dly(9)'last_event, tpd_B_P((647 - 11)- 36*8), true),
			27 => (B_dly(8)'last_event, tpd_B_P((647 - 11)- 36*9), true),
			28 => (B_dly(7)'last_event, tpd_B_P((647 - 11)- 36*10), true),
			29 => (B_dly(6)'last_event, tpd_B_P((647 - 11)- 36*11), true),
			30 => (B_dly(5)'last_event, tpd_B_P((647 - 11)- 36*12), true),
			31 => (B_dly(4)'last_event, tpd_B_P((647 - 11)- 36*13), true),
			32 => (B_dly(3)'last_event, tpd_B_P((647 - 11)- 36*14), true),
			33 => (B_dly(2)'last_event, tpd_B_P((647 - 11)- 36*15), true),
			34 => (B_dly(1)'last_event, tpd_B_P((647 - 11)- 36*16), true),
			35 => (B_dly(0)'last_event, tpd_B_P((647 - 11)- 36*17), true),
			36 => (BCIN_dly(17)'last_event, tpd_BCIN_P((647 - 11)- 36*0), true),
			37 => (BCIN_dly(16)'last_event, tpd_BCIN_P((647 - 11)- 36*1), true),
			38 => (BCIN_dly(15)'last_event, tpd_BCIN_P((647 - 11)- 36*2), true),
			39 => (BCIN_dly(14)'last_event, tpd_BCIN_P((647 - 11)- 36*3), true),
			40 => (BCIN_dly(13)'last_event, tpd_BCIN_P((647 - 11)- 36*4), true),
			41 => (BCIN_dly(12)'last_event, tpd_BCIN_P((647 - 11)- 36*5), true),
			42 => (BCIN_dly(11)'last_event, tpd_BCIN_P((647 - 11)- 36*6), true),
			43 => (BCIN_dly(10)'last_event, tpd_BCIN_P((647 - 11)- 36*7), true),
			44 => (BCIN_dly(9)'last_event, tpd_BCIN_P((647 - 11)- 36*8), true),
			45 => (BCIN_dly(8)'last_event, tpd_BCIN_P((647 - 11)- 36*9), true),
			46 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 11)- 36*10), true),
			47 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 11)- 36*11), true),
			48 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 11)- 36*12), true),
			49 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 11)- 36*13), true),
			50 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 11)- 36*14), true),
			51 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 11)- 36*15), true),
			52 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 11)- 36*16), true),
			53 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 11)- 36*17), true),
			54 => (CLK_dly'last_event, tpd_CLK_P(24), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(23),
         GlitchData	=> P_GlitchData(23),
         OutSignalName	=> "P(23)",
         OutTemp	=> P_zd(23),
         Paths		=> (
			0 => (A_dly(17)'last_event, tpd_A_P((647 - 12)- 36*0), true),
			1 => (A_dly(16)'last_event, tpd_A_P((647 - 12)- 36*1), true),
			2 => (A_dly(15)'last_event, tpd_A_P((647 - 12)- 36*2), true),
			3 => (A_dly(14)'last_event, tpd_A_P((647 - 12)- 36*3), true),
			4 => (A_dly(13)'last_event, tpd_A_P((647 - 12)- 36*4), true),
			5 => (A_dly(12)'last_event, tpd_A_P((647 - 12)- 36*5), true),
			6 => (A_dly(11)'last_event, tpd_A_P((647 - 12)- 36*6), true),
			7 => (A_dly(10)'last_event, tpd_A_P((647 - 12)- 36*7), true),
			8 => (A_dly(9)'last_event, tpd_A_P((647 - 12)- 36*8), true),
			9 => (A_dly(8)'last_event, tpd_A_P((647 - 12)- 36*9), true),
			10 => (A_dly(7)'last_event, tpd_A_P((647 - 12)- 36*10), true),
			11 => (A_dly(6)'last_event, tpd_A_P((647 - 12)- 36*11), true),
			12 => (A_dly(5)'last_event, tpd_A_P((647 - 12)- 36*12), true),
			13 => (A_dly(4)'last_event, tpd_A_P((647 - 12)- 36*13), true),
			14 => (A_dly(3)'last_event, tpd_A_P((647 - 12)- 36*14), true),
			15 => (A_dly(2)'last_event, tpd_A_P((647 - 12)- 36*15), true),
			16 => (A_dly(1)'last_event, tpd_A_P((647 - 12)- 36*16), true),
			17 => (A_dly(0)'last_event, tpd_A_P((647 - 12)- 36*17), true),
			18 => (B_dly(17)'last_event, tpd_B_P((647 - 12)- 36*0), true),
			19 => (B_dly(16)'last_event, tpd_B_P((647 - 12)- 36*1), true),
			20 => (B_dly(15)'last_event, tpd_B_P((647 - 12)- 36*2), true),
			21 => (B_dly(14)'last_event, tpd_B_P((647 - 12)- 36*3), true),
			22 => (B_dly(13)'last_event, tpd_B_P((647 - 12)- 36*4), true),
			23 => (B_dly(12)'last_event, tpd_B_P((647 - 12)- 36*5), true),
			24 => (B_dly(11)'last_event, tpd_B_P((647 - 12)- 36*6), true),
			25 => (B_dly(10)'last_event, tpd_B_P((647 - 12)- 36*7), true),
			26 => (B_dly(9)'last_event, tpd_B_P((647 - 12)- 36*8), true),
			27 => (B_dly(8)'last_event, tpd_B_P((647 - 12)- 36*9), true),
			28 => (B_dly(7)'last_event, tpd_B_P((647 - 12)- 36*10), true),
			29 => (B_dly(6)'last_event, tpd_B_P((647 - 12)- 36*11), true),
			30 => (B_dly(5)'last_event, tpd_B_P((647 - 12)- 36*12), true),
			31 => (B_dly(4)'last_event, tpd_B_P((647 - 12)- 36*13), true),
			32 => (B_dly(3)'last_event, tpd_B_P((647 - 12)- 36*14), true),
			33 => (B_dly(2)'last_event, tpd_B_P((647 - 12)- 36*15), true),
			34 => (B_dly(1)'last_event, tpd_B_P((647 - 12)- 36*16), true),
			35 => (B_dly(0)'last_event, tpd_B_P((647 - 12)- 36*17), true),
			36 => (BCIN_dly(17)'last_event, tpd_BCIN_P((647 - 12)- 36*0), true),
			37 => (BCIN_dly(16)'last_event, tpd_BCIN_P((647 - 12)- 36*1), true),
			38 => (BCIN_dly(15)'last_event, tpd_BCIN_P((647 - 12)- 36*2), true),
			39 => (BCIN_dly(14)'last_event, tpd_BCIN_P((647 - 12)- 36*3), true),
			40 => (BCIN_dly(13)'last_event, tpd_BCIN_P((647 - 12)- 36*4), true),
			41 => (BCIN_dly(12)'last_event, tpd_BCIN_P((647 - 12)- 36*5), true),
			42 => (BCIN_dly(11)'last_event, tpd_BCIN_P((647 - 12)- 36*6), true),
			43 => (BCIN_dly(10)'last_event, tpd_BCIN_P((647 - 12)- 36*7), true),
			44 => (BCIN_dly(9)'last_event, tpd_BCIN_P((647 - 12)- 36*8), true),
			45 => (BCIN_dly(8)'last_event, tpd_BCIN_P((647 - 12)- 36*9), true),
			46 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 12)- 36*10), true),
			47 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 12)- 36*11), true),
			48 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 12)- 36*12), true),
			49 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 12)- 36*13), true),
			50 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 12)- 36*14), true),
			51 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 12)- 36*15), true),
			52 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 12)- 36*16), true),
			53 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 12)- 36*17), true),
			54 => (CLK_dly'last_event, tpd_CLK_P(23), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(22),
         GlitchData	=> P_GlitchData(22),
         OutSignalName	=> "P(22)",
         OutTemp	=> P_zd(22),
         Paths		=> (
			0 => (A_dly(17)'last_event, tpd_A_P((647 - 13)- 36*0), true),
			1 => (A_dly(16)'last_event, tpd_A_P((647 - 13)- 36*1), true),
			2 => (A_dly(15)'last_event, tpd_A_P((647 - 13)- 36*2), true),
			3 => (A_dly(14)'last_event, tpd_A_P((647 - 13)- 36*3), true),
			4 => (A_dly(13)'last_event, tpd_A_P((647 - 13)- 36*4), true),
			5 => (A_dly(12)'last_event, tpd_A_P((647 - 13)- 36*5), true),
			6 => (A_dly(11)'last_event, tpd_A_P((647 - 13)- 36*6), true),
			7 => (A_dly(10)'last_event, tpd_A_P((647 - 13)- 36*7), true),
			8 => (A_dly(9)'last_event, tpd_A_P((647 - 13)- 36*8), true),
			9 => (A_dly(8)'last_event, tpd_A_P((647 - 13)- 36*9), true),
			10 => (A_dly(7)'last_event, tpd_A_P((647 - 13)- 36*10), true),
			11 => (A_dly(6)'last_event, tpd_A_P((647 - 13)- 36*11), true),
			12 => (A_dly(5)'last_event, tpd_A_P((647 - 13)- 36*12), true),
			13 => (A_dly(4)'last_event, tpd_A_P((647 - 13)- 36*13), true),
			14 => (A_dly(3)'last_event, tpd_A_P((647 - 13)- 36*14), true),
			15 => (A_dly(2)'last_event, tpd_A_P((647 - 13)- 36*15), true),
			16 => (A_dly(1)'last_event, tpd_A_P((647 - 13)- 36*16), true),
			17 => (A_dly(0)'last_event, tpd_A_P((647 - 13)- 36*17), true),
			18 => (B_dly(17)'last_event, tpd_B_P((647 - 13)- 36*0), true),
			19 => (B_dly(16)'last_event, tpd_B_P((647 - 13)- 36*1), true),
			20 => (B_dly(15)'last_event, tpd_B_P((647 - 13)- 36*2), true),
			21 => (B_dly(14)'last_event, tpd_B_P((647 - 13)- 36*3), true),
			22 => (B_dly(13)'last_event, tpd_B_P((647 - 13)- 36*4), true),
			23 => (B_dly(12)'last_event, tpd_B_P((647 - 13)- 36*5), true),
			24 => (B_dly(11)'last_event, tpd_B_P((647 - 13)- 36*6), true),
			25 => (B_dly(10)'last_event, tpd_B_P((647 - 13)- 36*7), true),
			26 => (B_dly(9)'last_event, tpd_B_P((647 - 13)- 36*8), true),
			27 => (B_dly(8)'last_event, tpd_B_P((647 - 13)- 36*9), true),
			28 => (B_dly(7)'last_event, tpd_B_P((647 - 13)- 36*10), true),
			29 => (B_dly(6)'last_event, tpd_B_P((647 - 13)- 36*11), true),
			30 => (B_dly(5)'last_event, tpd_B_P((647 - 13)- 36*12), true),
			31 => (B_dly(4)'last_event, tpd_B_P((647 - 13)- 36*13), true),
			32 => (B_dly(3)'last_event, tpd_B_P((647 - 13)- 36*14), true),
			33 => (B_dly(2)'last_event, tpd_B_P((647 - 13)- 36*15), true),
			34 => (B_dly(1)'last_event, tpd_B_P((647 - 13)- 36*16), true),
			35 => (B_dly(0)'last_event, tpd_B_P((647 - 13)- 36*17), true),
			36 => (BCIN_dly(17)'last_event, tpd_BCIN_P((647 - 13)- 36*0), true),
			37 => (BCIN_dly(16)'last_event, tpd_BCIN_P((647 - 13)- 36*1), true),
			38 => (BCIN_dly(15)'last_event, tpd_BCIN_P((647 - 13)- 36*2), true),
			39 => (BCIN_dly(14)'last_event, tpd_BCIN_P((647 - 13)- 36*3), true),
			40 => (BCIN_dly(13)'last_event, tpd_BCIN_P((647 - 13)- 36*4), true),
			41 => (BCIN_dly(12)'last_event, tpd_BCIN_P((647 - 13)- 36*5), true),
			42 => (BCIN_dly(11)'last_event, tpd_BCIN_P((647 - 13)- 36*6), true),
			43 => (BCIN_dly(10)'last_event, tpd_BCIN_P((647 - 13)- 36*7), true),
			44 => (BCIN_dly(9)'last_event, tpd_BCIN_P((647 - 13)- 36*8), true),
			45 => (BCIN_dly(8)'last_event, tpd_BCIN_P((647 - 13)- 36*9), true),
			46 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 13)- 36*10), true),
			47 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 13)- 36*11), true),
			48 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 13)- 36*12), true),
			49 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 13)- 36*13), true),
			50 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 13)- 36*14), true),
			51 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 13)- 36*15), true),
			52 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 13)- 36*16), true),
			53 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 13)- 36*17), true),
			54 => (CLK_dly'last_event, tpd_CLK_P(22), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(21),
         GlitchData	=> P_GlitchData(21),
         OutSignalName	=> "P(21)",
         OutTemp	=> P_zd(21),
         Paths		=> (
			0 => (A_dly(17)'last_event, tpd_A_P((647 - 14)- 36*0), true),
			1 => (A_dly(16)'last_event, tpd_A_P((647 - 14)- 36*1), true),
			2 => (A_dly(15)'last_event, tpd_A_P((647 - 14)- 36*2), true),
			3 => (A_dly(14)'last_event, tpd_A_P((647 - 14)- 36*3), true),
			4 => (A_dly(13)'last_event, tpd_A_P((647 - 14)- 36*4), true),
			5 => (A_dly(12)'last_event, tpd_A_P((647 - 14)- 36*5), true),
			6 => (A_dly(11)'last_event, tpd_A_P((647 - 14)- 36*6), true),
			7 => (A_dly(10)'last_event, tpd_A_P((647 - 14)- 36*7), true),
			8 => (A_dly(9)'last_event, tpd_A_P((647 - 14)- 36*8), true),
			9 => (A_dly(8)'last_event, tpd_A_P((647 - 14)- 36*9), true),
			10 => (A_dly(7)'last_event, tpd_A_P((647 - 14)- 36*10), true),
			11 => (A_dly(6)'last_event, tpd_A_P((647 - 14)- 36*11), true),
			12 => (A_dly(5)'last_event, tpd_A_P((647 - 14)- 36*12), true),
			13 => (A_dly(4)'last_event, tpd_A_P((647 - 14)- 36*13), true),
			14 => (A_dly(3)'last_event, tpd_A_P((647 - 14)- 36*14), true),
			15 => (A_dly(2)'last_event, tpd_A_P((647 - 14)- 36*15), true),
			16 => (A_dly(1)'last_event, tpd_A_P((647 - 14)- 36*16), true),
			17 => (A_dly(0)'last_event, tpd_A_P((647 - 14)- 36*17), true),
			18 => (B_dly(17)'last_event, tpd_B_P((647 - 14)- 36*0), true),
			19 => (B_dly(16)'last_event, tpd_B_P((647 - 14)- 36*1), true),
			20 => (B_dly(15)'last_event, tpd_B_P((647 - 14)- 36*2), true),
			21 => (B_dly(14)'last_event, tpd_B_P((647 - 14)- 36*3), true),
			22 => (B_dly(13)'last_event, tpd_B_P((647 - 14)- 36*4), true),
			23 => (B_dly(12)'last_event, tpd_B_P((647 - 14)- 36*5), true),
			24 => (B_dly(11)'last_event, tpd_B_P((647 - 14)- 36*6), true),
			25 => (B_dly(10)'last_event, tpd_B_P((647 - 14)- 36*7), true),
			26 => (B_dly(9)'last_event, tpd_B_P((647 - 14)- 36*8), true),
			27 => (B_dly(8)'last_event, tpd_B_P((647 - 14)- 36*9), true),
			28 => (B_dly(7)'last_event, tpd_B_P((647 - 14)- 36*10), true),
			29 => (B_dly(6)'last_event, tpd_B_P((647 - 14)- 36*11), true),
			30 => (B_dly(5)'last_event, tpd_B_P((647 - 14)- 36*12), true),
			31 => (B_dly(4)'last_event, tpd_B_P((647 - 14)- 36*13), true),
			32 => (B_dly(3)'last_event, tpd_B_P((647 - 14)- 36*14), true),
			33 => (B_dly(2)'last_event, tpd_B_P((647 - 14)- 36*15), true),
			34 => (B_dly(1)'last_event, tpd_B_P((647 - 14)- 36*16), true),
			35 => (B_dly(0)'last_event, tpd_B_P((647 - 14)- 36*17), true),
			36 => (BCIN_dly(17)'last_event, tpd_BCIN_P((647 - 14)- 36*0), true),
			37 => (BCIN_dly(16)'last_event, tpd_BCIN_P((647 - 14)- 36*1), true),
			38 => (BCIN_dly(15)'last_event, tpd_BCIN_P((647 - 14)- 36*2), true),
			39 => (BCIN_dly(14)'last_event, tpd_BCIN_P((647 - 14)- 36*3), true),
			40 => (BCIN_dly(13)'last_event, tpd_BCIN_P((647 - 14)- 36*4), true),
			41 => (BCIN_dly(12)'last_event, tpd_BCIN_P((647 - 14)- 36*5), true),
			42 => (BCIN_dly(11)'last_event, tpd_BCIN_P((647 - 14)- 36*6), true),
			43 => (BCIN_dly(10)'last_event, tpd_BCIN_P((647 - 14)- 36*7), true),
			44 => (BCIN_dly(9)'last_event, tpd_BCIN_P((647 - 14)- 36*8), true),
			45 => (BCIN_dly(8)'last_event, tpd_BCIN_P((647 - 14)- 36*9), true),
			46 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 14)- 36*10), true),
			47 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 14)- 36*11), true),
			48 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 14)- 36*12), true),
			49 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 14)- 36*13), true),
			50 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 14)- 36*14), true),
			51 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 14)- 36*15), true),
			52 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 14)- 36*16), true),
			53 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 14)- 36*17), true),
			54 => (CLK_dly'last_event, tpd_CLK_P(21), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(20),
         GlitchData	=> P_GlitchData(20),
         OutSignalName	=> "P(20)",
         OutTemp	=> P_zd(20),
         Paths		=> (
			0 => (A_dly(17)'last_event, tpd_A_P((647 - 15)- 36*0), true),
			1 => (A_dly(16)'last_event, tpd_A_P((647 - 15)- 36*1), true),
			2 => (A_dly(15)'last_event, tpd_A_P((647 - 15)- 36*2), true),
			3 => (A_dly(14)'last_event, tpd_A_P((647 - 15)- 36*3), true),
			4 => (A_dly(13)'last_event, tpd_A_P((647 - 15)- 36*4), true),
			5 => (A_dly(12)'last_event, tpd_A_P((647 - 15)- 36*5), true),
			6 => (A_dly(11)'last_event, tpd_A_P((647 - 15)- 36*6), true),
			7 => (A_dly(10)'last_event, tpd_A_P((647 - 15)- 36*7), true),
			8 => (A_dly(9)'last_event, tpd_A_P((647 - 15)- 36*8), true),
			9 => (A_dly(8)'last_event, tpd_A_P((647 - 15)- 36*9), true),
			10 => (A_dly(7)'last_event, tpd_A_P((647 - 15)- 36*10), true),
			11 => (A_dly(6)'last_event, tpd_A_P((647 - 15)- 36*11), true),
			12 => (A_dly(5)'last_event, tpd_A_P((647 - 15)- 36*12), true),
			13 => (A_dly(4)'last_event, tpd_A_P((647 - 15)- 36*13), true),
			14 => (A_dly(3)'last_event, tpd_A_P((647 - 15)- 36*14), true),
			15 => (A_dly(2)'last_event, tpd_A_P((647 - 15)- 36*15), true),
			16 => (A_dly(1)'last_event, tpd_A_P((647 - 15)- 36*16), true),
			17 => (A_dly(0)'last_event, tpd_A_P((647 - 15)- 36*17), true),
			18 => (B_dly(17)'last_event, tpd_B_P((647 - 15)- 36*0), true),
			19 => (B_dly(16)'last_event, tpd_B_P((647 - 15)- 36*1), true),
			20 => (B_dly(15)'last_event, tpd_B_P((647 - 15)- 36*2), true),
			21 => (B_dly(14)'last_event, tpd_B_P((647 - 15)- 36*3), true),
			22 => (B_dly(13)'last_event, tpd_B_P((647 - 15)- 36*4), true),
			23 => (B_dly(12)'last_event, tpd_B_P((647 - 15)- 36*5), true),
			24 => (B_dly(11)'last_event, tpd_B_P((647 - 15)- 36*6), true),
			25 => (B_dly(10)'last_event, tpd_B_P((647 - 15)- 36*7), true),
			26 => (B_dly(9)'last_event, tpd_B_P((647 - 15)- 36*8), true),
			27 => (B_dly(8)'last_event, tpd_B_P((647 - 15)- 36*9), true),
			28 => (B_dly(7)'last_event, tpd_B_P((647 - 15)- 36*10), true),
			29 => (B_dly(6)'last_event, tpd_B_P((647 - 15)- 36*11), true),
			30 => (B_dly(5)'last_event, tpd_B_P((647 - 15)- 36*12), true),
			31 => (B_dly(4)'last_event, tpd_B_P((647 - 15)- 36*13), true),
			32 => (B_dly(3)'last_event, tpd_B_P((647 - 15)- 36*14), true),
			33 => (B_dly(2)'last_event, tpd_B_P((647 - 15)- 36*15), true),
			34 => (B_dly(1)'last_event, tpd_B_P((647 - 15)- 36*16), true),
			35 => (B_dly(0)'last_event, tpd_B_P((647 - 15)- 36*17), true),
			36 => (BCIN_dly(17)'last_event, tpd_BCIN_P((647 - 15)- 36*0), true),
			37 => (BCIN_dly(16)'last_event, tpd_BCIN_P((647 - 15)- 36*1), true),
			38 => (BCIN_dly(15)'last_event, tpd_BCIN_P((647 - 15)- 36*2), true),
			39 => (BCIN_dly(14)'last_event, tpd_BCIN_P((647 - 15)- 36*3), true),
			40 => (BCIN_dly(13)'last_event, tpd_BCIN_P((647 - 15)- 36*4), true),
			41 => (BCIN_dly(12)'last_event, tpd_BCIN_P((647 - 15)- 36*5), true),
			42 => (BCIN_dly(11)'last_event, tpd_BCIN_P((647 - 15)- 36*6), true),
			43 => (BCIN_dly(10)'last_event, tpd_BCIN_P((647 - 15)- 36*7), true),
			44 => (BCIN_dly(9)'last_event, tpd_BCIN_P((647 - 15)- 36*8), true),
			45 => (BCIN_dly(8)'last_event, tpd_BCIN_P((647 - 15)- 36*9), true),
			46 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 15)- 36*10), true),
			47 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 15)- 36*11), true),
			48 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 15)- 36*12), true),
			49 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 15)- 36*13), true),
			50 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 15)- 36*14), true),
			51 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 15)- 36*15), true),
			52 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 15)- 36*16), true),
			53 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 15)- 36*17), true),
			54 => (CLK_dly'last_event, tpd_CLK_P(20), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(19),
         GlitchData	=> P_GlitchData(19),
         OutSignalName	=> "P(19)",
         OutTemp	=> P_zd(19),
         Paths		=> (
			0 => (A_dly(17)'last_event, tpd_A_P((647 - 16)- 36*0), true),
			1 => (A_dly(16)'last_event, tpd_A_P((647 - 16)- 36*1), true),
			2 => (A_dly(15)'last_event, tpd_A_P((647 - 16)- 36*2), true),
			3 => (A_dly(14)'last_event, tpd_A_P((647 - 16)- 36*3), true),
			4 => (A_dly(13)'last_event, tpd_A_P((647 - 16)- 36*4), true),
			5 => (A_dly(12)'last_event, tpd_A_P((647 - 16)- 36*5), true),
			6 => (A_dly(11)'last_event, tpd_A_P((647 - 16)- 36*6), true),
			7 => (A_dly(10)'last_event, tpd_A_P((647 - 16)- 36*7), true),
			8 => (A_dly(9)'last_event, tpd_A_P((647 - 16)- 36*8), true),
			9 => (A_dly(8)'last_event, tpd_A_P((647 - 16)- 36*9), true),
			10 => (A_dly(7)'last_event, tpd_A_P((647 - 16)- 36*10), true),
			11 => (A_dly(6)'last_event, tpd_A_P((647 - 16)- 36*11), true),
			12 => (A_dly(5)'last_event, tpd_A_P((647 - 16)- 36*12), true),
			13 => (A_dly(4)'last_event, tpd_A_P((647 - 16)- 36*13), true),
			14 => (A_dly(3)'last_event, tpd_A_P((647 - 16)- 36*14), true),
			15 => (A_dly(2)'last_event, tpd_A_P((647 - 16)- 36*15), true),
			16 => (A_dly(1)'last_event, tpd_A_P((647 - 16)- 36*16), true),
			17 => (A_dly(0)'last_event, tpd_A_P((647 - 16)- 36*17), true),
			18 => (B_dly(17)'last_event, tpd_B_P((647 - 16)- 36*0), true),
			19 => (B_dly(16)'last_event, tpd_B_P((647 - 16)- 36*1), true),
			20 => (B_dly(15)'last_event, tpd_B_P((647 - 16)- 36*2), true),
			21 => (B_dly(14)'last_event, tpd_B_P((647 - 16)- 36*3), true),
			22 => (B_dly(13)'last_event, tpd_B_P((647 - 16)- 36*4), true),
			23 => (B_dly(12)'last_event, tpd_B_P((647 - 16)- 36*5), true),
			24 => (B_dly(11)'last_event, tpd_B_P((647 - 16)- 36*6), true),
			25 => (B_dly(10)'last_event, tpd_B_P((647 - 16)- 36*7), true),
			26 => (B_dly(9)'last_event, tpd_B_P((647 - 16)- 36*8), true),
			27 => (B_dly(8)'last_event, tpd_B_P((647 - 16)- 36*9), true),
			28 => (B_dly(7)'last_event, tpd_B_P((647 - 16)- 36*10), true),
			29 => (B_dly(6)'last_event, tpd_B_P((647 - 16)- 36*11), true),
			30 => (B_dly(5)'last_event, tpd_B_P((647 - 16)- 36*12), true),
			31 => (B_dly(4)'last_event, tpd_B_P((647 - 16)- 36*13), true),
			32 => (B_dly(3)'last_event, tpd_B_P((647 - 16)- 36*14), true),
			33 => (B_dly(2)'last_event, tpd_B_P((647 - 16)- 36*15), true),
			34 => (B_dly(1)'last_event, tpd_B_P((647 - 16)- 36*16), true),
			35 => (B_dly(0)'last_event, tpd_B_P((647 - 16)- 36*17), true),
			36 => (BCIN_dly(17)'last_event, tpd_BCIN_P((647 - 16)- 36*0), true),
			37 => (BCIN_dly(16)'last_event, tpd_BCIN_P((647 - 16)- 36*1), true),
			38 => (BCIN_dly(15)'last_event, tpd_BCIN_P((647 - 16)- 36*2), true),
			39 => (BCIN_dly(14)'last_event, tpd_BCIN_P((647 - 16)- 36*3), true),
			40 => (BCIN_dly(13)'last_event, tpd_BCIN_P((647 - 16)- 36*4), true),
			41 => (BCIN_dly(12)'last_event, tpd_BCIN_P((647 - 16)- 36*5), true),
			42 => (BCIN_dly(11)'last_event, tpd_BCIN_P((647 - 16)- 36*6), true),
			43 => (BCIN_dly(10)'last_event, tpd_BCIN_P((647 - 16)- 36*7), true),
			44 => (BCIN_dly(9)'last_event, tpd_BCIN_P((647 - 16)- 36*8), true),
			45 => (BCIN_dly(8)'last_event, tpd_BCIN_P((647 - 16)- 36*9), true),
			46 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 16)- 36*10), true),
			47 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 16)- 36*11), true),
			48 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 16)- 36*12), true),
			49 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 16)- 36*13), true),
			50 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 16)- 36*14), true),
			51 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 16)- 36*15), true),
			52 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 16)- 36*16), true),
			53 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 16)- 36*17), true),
			54 => (CLK_dly'last_event, tpd_CLK_P(19), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(18),
         GlitchData	=> P_GlitchData(18),
         OutSignalName	=> "P(18)",
         OutTemp	=> P_zd(18),
         Paths		=> (
			0 => (A_dly(17)'last_event, tpd_A_P((647 - 17)- 36*0), true),
			1 => (A_dly(16)'last_event, tpd_A_P((647 - 17)- 36*1), true),
			2 => (A_dly(15)'last_event, tpd_A_P((647 - 17)- 36*2), true),
			3 => (A_dly(14)'last_event, tpd_A_P((647 - 17)- 36*3), true),
			4 => (A_dly(13)'last_event, tpd_A_P((647 - 17)- 36*4), true),
			5 => (A_dly(12)'last_event, tpd_A_P((647 - 17)- 36*5), true),
			6 => (A_dly(11)'last_event, tpd_A_P((647 - 17)- 36*6), true),
			7 => (A_dly(10)'last_event, tpd_A_P((647 - 17)- 36*7), true),
			8 => (A_dly(9)'last_event, tpd_A_P((647 - 17)- 36*8), true),
			9 => (A_dly(8)'last_event, tpd_A_P((647 - 17)- 36*9), true),
			10 => (A_dly(7)'last_event, tpd_A_P((647 - 17)- 36*10), true),
			11 => (A_dly(6)'last_event, tpd_A_P((647 - 17)- 36*11), true),
			12 => (A_dly(5)'last_event, tpd_A_P((647 - 17)- 36*12), true),
			13 => (A_dly(4)'last_event, tpd_A_P((647 - 17)- 36*13), true),
			14 => (A_dly(3)'last_event, tpd_A_P((647 - 17)- 36*14), true),
			15 => (A_dly(2)'last_event, tpd_A_P((647 - 17)- 36*15), true),
			16 => (A_dly(1)'last_event, tpd_A_P((647 - 17)- 36*16), true),
			17 => (A_dly(0)'last_event, tpd_A_P((647 - 17)- 36*17), true),
			18 => (B_dly(17)'last_event, tpd_B_P((647 - 17)- 36*0), true),
			19 => (B_dly(16)'last_event, tpd_B_P((647 - 17)- 36*1), true),
			20 => (B_dly(15)'last_event, tpd_B_P((647 - 17)- 36*2), true),
			21 => (B_dly(14)'last_event, tpd_B_P((647 - 17)- 36*3), true),
			22 => (B_dly(13)'last_event, tpd_B_P((647 - 17)- 36*4), true),
			23 => (B_dly(12)'last_event, tpd_B_P((647 - 17)- 36*5), true),
			24 => (B_dly(11)'last_event, tpd_B_P((647 - 17)- 36*6), true),
			25 => (B_dly(10)'last_event, tpd_B_P((647 - 17)- 36*7), true),
			26 => (B_dly(9)'last_event, tpd_B_P((647 - 17)- 36*8), true),
			27 => (B_dly(8)'last_event, tpd_B_P((647 - 17)- 36*9), true),
			28 => (B_dly(7)'last_event, tpd_B_P((647 - 17)- 36*10), true),
			29 => (B_dly(6)'last_event, tpd_B_P((647 - 17)- 36*11), true),
			30 => (B_dly(5)'last_event, tpd_B_P((647 - 17)- 36*12), true),
			31 => (B_dly(4)'last_event, tpd_B_P((647 - 17)- 36*13), true),
			32 => (B_dly(3)'last_event, tpd_B_P((647 - 17)- 36*14), true),
			33 => (B_dly(2)'last_event, tpd_B_P((647 - 17)- 36*15), true),
			34 => (B_dly(1)'last_event, tpd_B_P((647 - 17)- 36*16), true),
			35 => (B_dly(0)'last_event, tpd_B_P((647 - 17)- 36*17), true),
			36 => (BCIN_dly(17)'last_event, tpd_BCIN_P((647 - 17)- 36*0), true),
			37 => (BCIN_dly(16)'last_event, tpd_BCIN_P((647 - 17)- 36*1), true),
			38 => (BCIN_dly(15)'last_event, tpd_BCIN_P((647 - 17)- 36*2), true),
			39 => (BCIN_dly(14)'last_event, tpd_BCIN_P((647 - 17)- 36*3), true),
			40 => (BCIN_dly(13)'last_event, tpd_BCIN_P((647 - 17)- 36*4), true),
			41 => (BCIN_dly(12)'last_event, tpd_BCIN_P((647 - 17)- 36*5), true),
			42 => (BCIN_dly(11)'last_event, tpd_BCIN_P((647 - 17)- 36*6), true),
			43 => (BCIN_dly(10)'last_event, tpd_BCIN_P((647 - 17)- 36*7), true),
			44 => (BCIN_dly(9)'last_event, tpd_BCIN_P((647 - 17)- 36*8), true),
			45 => (BCIN_dly(8)'last_event, tpd_BCIN_P((647 - 17)- 36*9), true),
			46 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 17)- 36*10), true),
			47 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 17)- 36*11), true),
			48 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 17)- 36*12), true),
			49 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 17)- 36*13), true),
			50 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 17)- 36*14), true),
			51 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 17)- 36*15), true),
			52 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 17)- 36*16), true),
			53 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 17)- 36*17), true),
			54 => (CLK_dly'last_event, tpd_CLK_P(18), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(17),
         GlitchData	=> P_GlitchData(17),
         OutSignalName	=> "P(17)",
         OutTemp	=> P_zd(17),
         Paths		=> (
			0 => (A_dly(17)'last_event, tpd_A_P((647 - 18)- 36*0), true),
			1 => (A_dly(16)'last_event, tpd_A_P((647 - 18)- 36*1), true),
			2 => (A_dly(15)'last_event, tpd_A_P((647 - 18)- 36*2), true),
			3 => (A_dly(14)'last_event, tpd_A_P((647 - 18)- 36*3), true),
			4 => (A_dly(13)'last_event, tpd_A_P((647 - 18)- 36*4), true),
			5 => (A_dly(12)'last_event, tpd_A_P((647 - 18)- 36*5), true),
			6 => (A_dly(11)'last_event, tpd_A_P((647 - 18)- 36*6), true),
			7 => (A_dly(10)'last_event, tpd_A_P((647 - 18)- 36*7), true),
			8 => (A_dly(9)'last_event, tpd_A_P((647 - 18)- 36*8), true),
			9 => (A_dly(8)'last_event, tpd_A_P((647 - 18)- 36*9), true),
			10 => (A_dly(7)'last_event, tpd_A_P((647 - 18)- 36*10), true),
			11 => (A_dly(6)'last_event, tpd_A_P((647 - 18)- 36*11), true),
			12 => (A_dly(5)'last_event, tpd_A_P((647 - 18)- 36*12), true),
			13 => (A_dly(4)'last_event, tpd_A_P((647 - 18)- 36*13), true),
			14 => (A_dly(3)'last_event, tpd_A_P((647 - 18)- 36*14), true),
			15 => (A_dly(2)'last_event, tpd_A_P((647 - 18)- 36*15), true),
			16 => (A_dly(1)'last_event, tpd_A_P((647 - 18)- 36*16), true),
			17 => (A_dly(0)'last_event, tpd_A_P((647 - 18)- 36*17), true),
			18 => (B_dly(17)'last_event, tpd_B_P((647 - 18)- 36*0), true),
			19 => (B_dly(16)'last_event, tpd_B_P((647 - 18)- 36*1), true),
			20 => (B_dly(15)'last_event, tpd_B_P((647 - 18)- 36*2), true),
			21 => (B_dly(14)'last_event, tpd_B_P((647 - 18)- 36*3), true),
			22 => (B_dly(13)'last_event, tpd_B_P((647 - 18)- 36*4), true),
			23 => (B_dly(12)'last_event, tpd_B_P((647 - 18)- 36*5), true),
			24 => (B_dly(11)'last_event, tpd_B_P((647 - 18)- 36*6), true),
			25 => (B_dly(10)'last_event, tpd_B_P((647 - 18)- 36*7), true),
			26 => (B_dly(9)'last_event, tpd_B_P((647 - 18)- 36*8), true),
			27 => (B_dly(8)'last_event, tpd_B_P((647 - 18)- 36*9), true),
			28 => (B_dly(7)'last_event, tpd_B_P((647 - 18)- 36*10), true),
			29 => (B_dly(6)'last_event, tpd_B_P((647 - 18)- 36*11), true),
			30 => (B_dly(5)'last_event, tpd_B_P((647 - 18)- 36*12), true),
			31 => (B_dly(4)'last_event, tpd_B_P((647 - 18)- 36*13), true),
			32 => (B_dly(3)'last_event, tpd_B_P((647 - 18)- 36*14), true),
			33 => (B_dly(2)'last_event, tpd_B_P((647 - 18)- 36*15), true),
			34 => (B_dly(1)'last_event, tpd_B_P((647 - 18)- 36*16), true),
			35 => (B_dly(0)'last_event, tpd_B_P((647 - 18)- 36*17), true),
			36 => (BCIN_dly(17)'last_event, tpd_BCIN_P((647 - 18)- 36*0), true),
			37 => (BCIN_dly(16)'last_event, tpd_BCIN_P((647 - 18)- 36*1), true),
			38 => (BCIN_dly(15)'last_event, tpd_BCIN_P((647 - 18)- 36*2), true),
			39 => (BCIN_dly(14)'last_event, tpd_BCIN_P((647 - 18)- 36*3), true),
			40 => (BCIN_dly(13)'last_event, tpd_BCIN_P((647 - 18)- 36*4), true),
			41 => (BCIN_dly(12)'last_event, tpd_BCIN_P((647 - 18)- 36*5), true),
			42 => (BCIN_dly(11)'last_event, tpd_BCIN_P((647 - 18)- 36*6), true),
			43 => (BCIN_dly(10)'last_event, tpd_BCIN_P((647 - 18)- 36*7), true),
			44 => (BCIN_dly(9)'last_event, tpd_BCIN_P((647 - 18)- 36*8), true),
			45 => (BCIN_dly(8)'last_event, tpd_BCIN_P((647 - 18)- 36*9), true),
			46 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 18)- 36*10), true),
			47 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 18)- 36*11), true),
			48 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 18)- 36*12), true),
			49 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 18)- 36*13), true),
			50 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 18)- 36*14), true),
			51 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 18)- 36*15), true),
			52 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 18)- 36*16), true),
			53 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 18)- 36*17), true),
			54 => (CLK_dly'last_event, tpd_CLK_P(17), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(16),
         GlitchData	=> P_GlitchData(16),
         OutSignalName	=> "P(16)",
         OutTemp	=> P_zd(16),
         Paths		=> (
			0 => (A_dly(16)'last_event, tpd_A_P((647 - 19)- 36*1), true),
			1 => (A_dly(15)'last_event, tpd_A_P((647 - 19)- 36*2), true),
			2 => (A_dly(14)'last_event, tpd_A_P((647 - 19)- 36*3), true),
			3 => (A_dly(13)'last_event, tpd_A_P((647 - 19)- 36*4), true),
			4 => (A_dly(12)'last_event, tpd_A_P((647 - 19)- 36*5), true),
			5 => (A_dly(11)'last_event, tpd_A_P((647 - 19)- 36*6), true),
			6 => (A_dly(10)'last_event, tpd_A_P((647 - 19)- 36*7), true),
			7 => (A_dly(9)'last_event, tpd_A_P((647 - 19)- 36*8), true),
			8 => (A_dly(8)'last_event, tpd_A_P((647 - 19)- 36*9), true),
			9 => (A_dly(7)'last_event, tpd_A_P((647 - 19)- 36*10), true),
			10 => (A_dly(6)'last_event, tpd_A_P((647 - 19)- 36*11), true),
			11 => (A_dly(5)'last_event, tpd_A_P((647 - 19)- 36*12), true),
			12 => (A_dly(4)'last_event, tpd_A_P((647 - 19)- 36*13), true),
			13 => (A_dly(3)'last_event, tpd_A_P((647 - 19)- 36*14), true),
			14 => (A_dly(2)'last_event, tpd_A_P((647 - 19)- 36*15), true),
			15 => (A_dly(1)'last_event, tpd_A_P((647 - 19)- 36*16), true),
			16 => (A_dly(0)'last_event, tpd_A_P((647 - 19)- 36*17), true),
			17 => (B_dly(16)'last_event, tpd_B_P((647 - 19)- 36*1), true),
			18 => (B_dly(15)'last_event, tpd_B_P((647 - 19)- 36*2), true),
			19 => (B_dly(14)'last_event, tpd_B_P((647 - 19)- 36*3), true),
			20 => (B_dly(13)'last_event, tpd_B_P((647 - 19)- 36*4), true),
			21 => (B_dly(12)'last_event, tpd_B_P((647 - 19)- 36*5), true),
			22 => (B_dly(11)'last_event, tpd_B_P((647 - 19)- 36*6), true),
			23 => (B_dly(10)'last_event, tpd_B_P((647 - 19)- 36*7), true),
			24 => (B_dly(9)'last_event, tpd_B_P((647 - 19)- 36*8), true),
			25 => (B_dly(8)'last_event, tpd_B_P((647 - 19)- 36*9), true),
			26 => (B_dly(7)'last_event, tpd_B_P((647 - 19)- 36*10), true),
			27 => (B_dly(6)'last_event, tpd_B_P((647 - 19)- 36*11), true),
			28 => (B_dly(5)'last_event, tpd_B_P((647 - 19)- 36*12), true),
			29 => (B_dly(4)'last_event, tpd_B_P((647 - 19)- 36*13), true),
			30 => (B_dly(3)'last_event, tpd_B_P((647 - 19)- 36*14), true),
			31 => (B_dly(2)'last_event, tpd_B_P((647 - 19)- 36*15), true),
			32 => (B_dly(1)'last_event, tpd_B_P((647 - 19)- 36*16), true),
			33 => (B_dly(0)'last_event, tpd_B_P((647 - 19)- 36*17), true),
			34 => (BCIN_dly(16)'last_event, tpd_BCIN_P((647 - 19)- 36*1), true),
			35 => (BCIN_dly(15)'last_event, tpd_BCIN_P((647 - 19)- 36*2), true),
			36 => (BCIN_dly(14)'last_event, tpd_BCIN_P((647 - 19)- 36*3), true),
			37 => (BCIN_dly(13)'last_event, tpd_BCIN_P((647 - 19)- 36*4), true),
			38 => (BCIN_dly(12)'last_event, tpd_BCIN_P((647 - 19)- 36*5), true),
			39 => (BCIN_dly(11)'last_event, tpd_BCIN_P((647 - 19)- 36*6), true),
			40 => (BCIN_dly(10)'last_event, tpd_BCIN_P((647 - 19)- 36*7), true),
			41 => (BCIN_dly(9)'last_event, tpd_BCIN_P((647 - 19)- 36*8), true),
			42 => (BCIN_dly(8)'last_event, tpd_BCIN_P((647 - 19)- 36*9), true),
			43 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 19)- 36*10), true),
			44 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 19)- 36*11), true),
			45 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 19)- 36*12), true),
			46 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 19)- 36*13), true),
			47 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 19)- 36*14), true),
			48 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 19)- 36*15), true),
			49 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 19)- 36*16), true),
			50 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 19)- 36*17), true),
			51 => (CLK_dly'last_event, tpd_CLK_P(16), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(15),
         GlitchData	=> P_GlitchData(15),
         OutSignalName	=> "P(15)",
         OutTemp	=> P_zd(15),
         Paths		=> (
			0 => (A_dly(15)'last_event, tpd_A_P((647 - 20)- 36*2), true),
			1 => (A_dly(14)'last_event, tpd_A_P((647 - 20)- 36*3), true),
			2 => (A_dly(13)'last_event, tpd_A_P((647 - 20)- 36*4), true),
			3 => (A_dly(12)'last_event, tpd_A_P((647 - 20)- 36*5), true),
			4 => (A_dly(11)'last_event, tpd_A_P((647 - 20)- 36*6), true),
			5 => (A_dly(10)'last_event, tpd_A_P((647 - 20)- 36*7), true),
			6 => (A_dly(9)'last_event, tpd_A_P((647 - 20)- 36*8), true),
			7 => (A_dly(8)'last_event, tpd_A_P((647 - 20)- 36*9), true),
			8 => (A_dly(7)'last_event, tpd_A_P((647 - 20)- 36*10), true),
			9 => (A_dly(6)'last_event, tpd_A_P((647 - 20)- 36*11), true),
			10 => (A_dly(5)'last_event, tpd_A_P((647 - 20)- 36*12), true),
			11 => (A_dly(4)'last_event, tpd_A_P((647 - 20)- 36*13), true),
			12 => (A_dly(3)'last_event, tpd_A_P((647 - 20)- 36*14), true),
			13 => (A_dly(2)'last_event, tpd_A_P((647 - 20)- 36*15), true),
			14 => (A_dly(1)'last_event, tpd_A_P((647 - 20)- 36*16), true),
			15 => (A_dly(0)'last_event, tpd_A_P((647 - 20)- 36*17), true),
			16 => (B_dly(15)'last_event, tpd_B_P((647 - 20)- 36*2), true),
			17 => (B_dly(14)'last_event, tpd_B_P((647 - 20)- 36*3), true),
			18 => (B_dly(13)'last_event, tpd_B_P((647 - 20)- 36*4), true),
			19 => (B_dly(12)'last_event, tpd_B_P((647 - 20)- 36*5), true),
			20 => (B_dly(11)'last_event, tpd_B_P((647 - 20)- 36*6), true),
			21 => (B_dly(10)'last_event, tpd_B_P((647 - 20)- 36*7), true),
			22 => (B_dly(9)'last_event, tpd_B_P((647 - 20)- 36*8), true),
			23 => (B_dly(8)'last_event, tpd_B_P((647 - 20)- 36*9), true),
			24 => (B_dly(7)'last_event, tpd_B_P((647 - 20)- 36*10), true),
			25 => (B_dly(6)'last_event, tpd_B_P((647 - 20)- 36*11), true),
			26 => (B_dly(5)'last_event, tpd_B_P((647 - 20)- 36*12), true),
			27 => (B_dly(4)'last_event, tpd_B_P((647 - 20)- 36*13), true),
			28 => (B_dly(3)'last_event, tpd_B_P((647 - 20)- 36*14), true),
			29 => (B_dly(2)'last_event, tpd_B_P((647 - 20)- 36*15), true),
			30 => (B_dly(1)'last_event, tpd_B_P((647 - 20)- 36*16), true),
			31 => (B_dly(0)'last_event, tpd_B_P((647 - 20)- 36*17), true),
			32 => (BCIN_dly(15)'last_event, tpd_BCIN_P((647 - 20)- 36*2), true),
			33 => (BCIN_dly(14)'last_event, tpd_BCIN_P((647 - 20)- 36*3), true),
			34 => (BCIN_dly(13)'last_event, tpd_BCIN_P((647 - 20)- 36*4), true),
			35 => (BCIN_dly(12)'last_event, tpd_BCIN_P((647 - 20)- 36*5), true),
			36 => (BCIN_dly(11)'last_event, tpd_BCIN_P((647 - 20)- 36*6), true),
			37 => (BCIN_dly(10)'last_event, tpd_BCIN_P((647 - 20)- 36*7), true),
			38 => (BCIN_dly(9)'last_event, tpd_BCIN_P((647 - 20)- 36*8), true),
			39 => (BCIN_dly(8)'last_event, tpd_BCIN_P((647 - 20)- 36*9), true),
			40 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 20)- 36*10), true),
			41 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 20)- 36*11), true),
			42 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 20)- 36*12), true),
			43 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 20)- 36*13), true),
			44 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 20)- 36*14), true),
			45 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 20)- 36*15), true),
			46 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 20)- 36*16), true),
			47 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 20)- 36*17), true),
			48 => (CLK_dly'last_event, tpd_CLK_P(15), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(14),
         GlitchData	=> P_GlitchData(14),
         OutSignalName	=> "P(14)",
         OutTemp	=> P_zd(14),
         Paths		=> (
			0 => (A_dly(14)'last_event, tpd_A_P((647 - 21)- 36*3), true),
			1 => (A_dly(13)'last_event, tpd_A_P((647 - 21)- 36*4), true),
			2 => (A_dly(12)'last_event, tpd_A_P((647 - 21)- 36*5), true),
			3 => (A_dly(11)'last_event, tpd_A_P((647 - 21)- 36*6), true),
			4 => (A_dly(10)'last_event, tpd_A_P((647 - 21)- 36*7), true),
			5 => (A_dly(9)'last_event, tpd_A_P((647 - 21)- 36*8), true),
			6 => (A_dly(8)'last_event, tpd_A_P((647 - 21)- 36*9), true),
			7 => (A_dly(7)'last_event, tpd_A_P((647 - 21)- 36*10), true),
			8 => (A_dly(6)'last_event, tpd_A_P((647 - 21)- 36*11), true),
			9 => (A_dly(5)'last_event, tpd_A_P((647 - 21)- 36*12), true),
			10 => (A_dly(4)'last_event, tpd_A_P((647 - 21)- 36*13), true),
			11 => (A_dly(3)'last_event, tpd_A_P((647 - 21)- 36*14), true),
			12 => (A_dly(2)'last_event, tpd_A_P((647 - 21)- 36*15), true),
			13 => (A_dly(1)'last_event, tpd_A_P((647 - 21)- 36*16), true),
			14 => (A_dly(0)'last_event, tpd_A_P((647 - 21)- 36*17), true),
			15 => (B_dly(14)'last_event, tpd_B_P((647 - 21)- 36*3), true),
			16 => (B_dly(13)'last_event, tpd_B_P((647 - 21)- 36*4), true),
			17 => (B_dly(12)'last_event, tpd_B_P((647 - 21)- 36*5), true),
			18 => (B_dly(11)'last_event, tpd_B_P((647 - 21)- 36*6), true),
			19 => (B_dly(10)'last_event, tpd_B_P((647 - 21)- 36*7), true),
			20 => (B_dly(9)'last_event, tpd_B_P((647 - 21)- 36*8), true),
			21 => (B_dly(8)'last_event, tpd_B_P((647 - 21)- 36*9), true),
			22 => (B_dly(7)'last_event, tpd_B_P((647 - 21)- 36*10), true),
			23 => (B_dly(6)'last_event, tpd_B_P((647 - 21)- 36*11), true),
			24 => (B_dly(5)'last_event, tpd_B_P((647 - 21)- 36*12), true),
			25 => (B_dly(4)'last_event, tpd_B_P((647 - 21)- 36*13), true),
			26 => (B_dly(3)'last_event, tpd_B_P((647 - 21)- 36*14), true),
			27 => (B_dly(2)'last_event, tpd_B_P((647 - 21)- 36*15), true),
			28 => (B_dly(1)'last_event, tpd_B_P((647 - 21)- 36*16), true),
			29 => (B_dly(0)'last_event, tpd_B_P((647 - 21)- 36*17), true),
			30 => (BCIN_dly(14)'last_event, tpd_BCIN_P((647 - 21)- 36*3), true),
			31 => (BCIN_dly(13)'last_event, tpd_BCIN_P((647 - 21)- 36*4), true),
			32 => (BCIN_dly(12)'last_event, tpd_BCIN_P((647 - 21)- 36*5), true),
			33 => (BCIN_dly(11)'last_event, tpd_BCIN_P((647 - 21)- 36*6), true),
			34 => (BCIN_dly(10)'last_event, tpd_BCIN_P((647 - 21)- 36*7), true),
			35 => (BCIN_dly(9)'last_event, tpd_BCIN_P((647 - 21)- 36*8), true),
			36 => (BCIN_dly(8)'last_event, tpd_BCIN_P((647 - 21)- 36*9), true),
			37 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 21)- 36*10), true),
			38 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 21)- 36*11), true),
			39 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 21)- 36*12), true),
			40 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 21)- 36*13), true),
			41 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 21)- 36*14), true),
			42 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 21)- 36*15), true),
			43 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 21)- 36*16), true),
			44 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 21)- 36*17), true),
			45 => (CLK_dly'last_event, tpd_CLK_P(14), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(13),
         GlitchData	=> P_GlitchData(13),
         OutSignalName	=> "P(13)",
         OutTemp	=> P_zd(13),
         Paths		=> (
			0 => (A_dly(13)'last_event, tpd_A_P((647 - 22)- 36*4), true),
			1 => (A_dly(12)'last_event, tpd_A_P((647 - 22)- 36*5), true),
			2 => (A_dly(11)'last_event, tpd_A_P((647 - 22)- 36*6), true),
			3 => (A_dly(10)'last_event, tpd_A_P((647 - 22)- 36*7), true),
			4 => (A_dly(9)'last_event, tpd_A_P((647 - 22)- 36*8), true),
			5 => (A_dly(8)'last_event, tpd_A_P((647 - 22)- 36*9), true),
			6 => (A_dly(7)'last_event, tpd_A_P((647 - 22)- 36*10), true),
			7 => (A_dly(6)'last_event, tpd_A_P((647 - 22)- 36*11), true),
			8 => (A_dly(5)'last_event, tpd_A_P((647 - 22)- 36*12), true),
			9 => (A_dly(4)'last_event, tpd_A_P((647 - 22)- 36*13), true),
			10 => (A_dly(3)'last_event, tpd_A_P((647 - 22)- 36*14), true),
			11 => (A_dly(2)'last_event, tpd_A_P((647 - 22)- 36*15), true),
			12 => (A_dly(1)'last_event, tpd_A_P((647 - 22)- 36*16), true),
			13 => (A_dly(0)'last_event, tpd_A_P((647 - 22)- 36*17), true),
			14 => (B_dly(13)'last_event, tpd_B_P((647 - 22)- 36*4), true),
			15 => (B_dly(12)'last_event, tpd_B_P((647 - 22)- 36*5), true),
			16 => (B_dly(11)'last_event, tpd_B_P((647 - 22)- 36*6), true),
			17 => (B_dly(10)'last_event, tpd_B_P((647 - 22)- 36*7), true),
			18 => (B_dly(9)'last_event, tpd_B_P((647 - 22)- 36*8), true),
			19 => (B_dly(8)'last_event, tpd_B_P((647 - 22)- 36*9), true),
			20 => (B_dly(7)'last_event, tpd_B_P((647 - 22)- 36*10), true),
			21 => (B_dly(6)'last_event, tpd_B_P((647 - 22)- 36*11), true),
			22 => (B_dly(5)'last_event, tpd_B_P((647 - 22)- 36*12), true),
			23 => (B_dly(4)'last_event, tpd_B_P((647 - 22)- 36*13), true),
			24 => (B_dly(3)'last_event, tpd_B_P((647 - 22)- 36*14), true),
			25 => (B_dly(2)'last_event, tpd_B_P((647 - 22)- 36*15), true),
			26 => (B_dly(1)'last_event, tpd_B_P((647 - 22)- 36*16), true),
			27 => (B_dly(0)'last_event, tpd_B_P((647 - 22)- 36*17), true),
			28 => (BCIN_dly(13)'last_event, tpd_BCIN_P((647 - 22)- 36*4), true),
			29 => (BCIN_dly(12)'last_event, tpd_BCIN_P((647 - 22)- 36*5), true),
			30 => (BCIN_dly(11)'last_event, tpd_BCIN_P((647 - 22)- 36*6), true),
			31 => (BCIN_dly(10)'last_event, tpd_BCIN_P((647 - 22)- 36*7), true),
			32 => (BCIN_dly(9)'last_event, tpd_BCIN_P((647 - 22)- 36*8), true),
			33 => (BCIN_dly(8)'last_event, tpd_BCIN_P((647 - 22)- 36*9), true),
			34 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 22)- 36*10), true),
			35 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 22)- 36*11), true),
			36 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 22)- 36*12), true),
			37 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 22)- 36*13), true),
			38 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 22)- 36*14), true),
			39 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 22)- 36*15), true),
			40 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 22)- 36*16), true),
			41 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 22)- 36*17), true),
			42 => (CLK_dly'last_event, tpd_CLK_P(13), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(12),
         GlitchData	=> P_GlitchData(12),
         OutSignalName	=> "P(12)",
         OutTemp	=> P_zd(12),
         Paths		=> (
			0 => (A_dly(12)'last_event, tpd_A_P((647 - 23)- 36*5), true),
			1 => (A_dly(11)'last_event, tpd_A_P((647 - 23)- 36*6), true),
			2 => (A_dly(10)'last_event, tpd_A_P((647 - 23)- 36*7), true),
			3 => (A_dly(9)'last_event, tpd_A_P((647 - 23)- 36*8), true),
			4 => (A_dly(8)'last_event, tpd_A_P((647 - 23)- 36*9), true),
			5 => (A_dly(7)'last_event, tpd_A_P((647 - 23)- 36*10), true),
			6 => (A_dly(6)'last_event, tpd_A_P((647 - 23)- 36*11), true),
			7 => (A_dly(5)'last_event, tpd_A_P((647 - 23)- 36*12), true),
			8 => (A_dly(4)'last_event, tpd_A_P((647 - 23)- 36*13), true),
			9 => (A_dly(3)'last_event, tpd_A_P((647 - 23)- 36*14), true),
			10 => (A_dly(2)'last_event, tpd_A_P((647 - 23)- 36*15), true),
			11 => (A_dly(1)'last_event, tpd_A_P((647 - 23)- 36*16), true),
			12 => (A_dly(0)'last_event, tpd_A_P((647 - 23)- 36*17), true),
			13 => (B_dly(12)'last_event, tpd_B_P((647 - 23)- 36*5), true),
			14 => (B_dly(11)'last_event, tpd_B_P((647 - 23)- 36*6), true),
			15 => (B_dly(10)'last_event, tpd_B_P((647 - 23)- 36*7), true),
			16 => (B_dly(9)'last_event, tpd_B_P((647 - 23)- 36*8), true),
			17 => (B_dly(8)'last_event, tpd_B_P((647 - 23)- 36*9), true),
			18 => (B_dly(7)'last_event, tpd_B_P((647 - 23)- 36*10), true),
			19 => (B_dly(6)'last_event, tpd_B_P((647 - 23)- 36*11), true),
			20 => (B_dly(5)'last_event, tpd_B_P((647 - 23)- 36*12), true),
			21 => (B_dly(4)'last_event, tpd_B_P((647 - 23)- 36*13), true),
			22 => (B_dly(3)'last_event, tpd_B_P((647 - 23)- 36*14), true),
			23 => (B_dly(2)'last_event, tpd_B_P((647 - 23)- 36*15), true),
			24 => (B_dly(1)'last_event, tpd_B_P((647 - 23)- 36*16), true),
			25 => (B_dly(0)'last_event, tpd_B_P((647 - 23)- 36*17), true),
			26 => (BCIN_dly(12)'last_event, tpd_BCIN_P((647 - 23)- 36*5), true),
			27 => (BCIN_dly(11)'last_event, tpd_BCIN_P((647 - 23)- 36*6), true),
			28 => (BCIN_dly(10)'last_event, tpd_BCIN_P((647 - 23)- 36*7), true),
			29 => (BCIN_dly(9)'last_event, tpd_BCIN_P((647 - 23)- 36*8), true),
			30 => (BCIN_dly(8)'last_event, tpd_BCIN_P((647 - 23)- 36*9), true),
			31 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 23)- 36*10), true),
			32 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 23)- 36*11), true),
			33 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 23)- 36*12), true),
			34 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 23)- 36*13), true),
			35 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 23)- 36*14), true),
			36 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 23)- 36*15), true),
			37 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 23)- 36*16), true),
			38 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 23)- 36*17), true),
			39 => (CLK_dly'last_event, tpd_CLK_P(12), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(11),
         GlitchData	=> P_GlitchData(11),
         OutSignalName	=> "P(11)",
         OutTemp	=> P_zd(11),
         Paths		=> (
			0 => (A_dly(11)'last_event, tpd_A_P((647 - 24)- 36*6), true),
			1 => (A_dly(10)'last_event, tpd_A_P((647 - 24)- 36*7), true),
			2 => (A_dly(9)'last_event, tpd_A_P((647 - 24)- 36*8), true),
			3 => (A_dly(8)'last_event, tpd_A_P((647 - 24)- 36*9), true),
			4 => (A_dly(7)'last_event, tpd_A_P((647 - 24)- 36*10), true),
			5 => (A_dly(6)'last_event, tpd_A_P((647 - 24)- 36*11), true),
			6 => (A_dly(5)'last_event, tpd_A_P((647 - 24)- 36*12), true),
			7 => (A_dly(4)'last_event, tpd_A_P((647 - 24)- 36*13), true),
			8 => (A_dly(3)'last_event, tpd_A_P((647 - 24)- 36*14), true),
			9 => (A_dly(2)'last_event, tpd_A_P((647 - 24)- 36*15), true),
			10 => (A_dly(1)'last_event, tpd_A_P((647 - 24)- 36*16), true),
			11 => (A_dly(0)'last_event, tpd_A_P((647 - 24)- 36*17), true),
			12 => (B_dly(11)'last_event, tpd_B_P((647 - 24)- 36*6), true),
			13 => (B_dly(10)'last_event, tpd_B_P((647 - 24)- 36*7), true),
			14 => (B_dly(9)'last_event, tpd_B_P((647 - 24)- 36*8), true),
			15 => (B_dly(8)'last_event, tpd_B_P((647 - 24)- 36*9), true),
			16 => (B_dly(7)'last_event, tpd_B_P((647 - 24)- 36*10), true),
			17 => (B_dly(6)'last_event, tpd_B_P((647 - 24)- 36*11), true),
			18 => (B_dly(5)'last_event, tpd_B_P((647 - 24)- 36*12), true),
			19 => (B_dly(4)'last_event, tpd_B_P((647 - 24)- 36*13), true),
			20 => (B_dly(3)'last_event, tpd_B_P((647 - 24)- 36*14), true),
			21 => (B_dly(2)'last_event, tpd_B_P((647 - 24)- 36*15), true),
			22 => (B_dly(1)'last_event, tpd_B_P((647 - 24)- 36*16), true),
			23 => (B_dly(0)'last_event, tpd_B_P((647 - 24)- 36*17), true),
			24 => (BCIN_dly(11)'last_event, tpd_BCIN_P((647 - 24)- 36*6), true),
			25 => (BCIN_dly(10)'last_event, tpd_BCIN_P((647 - 24)- 36*7), true),
			26 => (BCIN_dly(9)'last_event, tpd_BCIN_P((647 - 24)- 36*8), true),
			27 => (BCIN_dly(8)'last_event, tpd_BCIN_P((647 - 24)- 36*9), true),
			28 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 24)- 36*10), true),
			29 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 24)- 36*11), true),
			30 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 24)- 36*12), true),
			31 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 24)- 36*13), true),
			32 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 24)- 36*14), true),
			33 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 24)- 36*15), true),
			34 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 24)- 36*16), true),
			35 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 24)- 36*17), true),
			36 => (CLK_dly'last_event, tpd_CLK_P(11), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(10),
         GlitchData	=> P_GlitchData(10),
         OutSignalName	=> "P(10)",
         OutTemp	=> P_zd(10),
         Paths		=> (
			0 => (A_dly(10)'last_event, tpd_A_P((647 - 25)- 36*7), true),
			1 => (A_dly(9)'last_event, tpd_A_P((647 - 25)- 36*8), true),
			2 => (A_dly(8)'last_event, tpd_A_P((647 - 25)- 36*9), true),
			3 => (A_dly(7)'last_event, tpd_A_P((647 - 25)- 36*10), true),
			4 => (A_dly(6)'last_event, tpd_A_P((647 - 25)- 36*11), true),
			5 => (A_dly(5)'last_event, tpd_A_P((647 - 25)- 36*12), true),
			6 => (A_dly(4)'last_event, tpd_A_P((647 - 25)- 36*13), true),
			7 => (A_dly(3)'last_event, tpd_A_P((647 - 25)- 36*14), true),
			8 => (A_dly(2)'last_event, tpd_A_P((647 - 25)- 36*15), true),
			9 => (A_dly(1)'last_event, tpd_A_P((647 - 25)- 36*16), true),
			10 => (A_dly(0)'last_event, tpd_A_P((647 - 25)- 36*17), true),
			11 => (B_dly(10)'last_event, tpd_B_P((647 - 25)- 36*7), true),
			12 => (B_dly(9)'last_event, tpd_B_P((647 - 25)- 36*8), true),
			13 => (B_dly(8)'last_event, tpd_B_P((647 - 25)- 36*9), true),
			14 => (B_dly(7)'last_event, tpd_B_P((647 - 25)- 36*10), true),
			15 => (B_dly(6)'last_event, tpd_B_P((647 - 25)- 36*11), true),
			16 => (B_dly(5)'last_event, tpd_B_P((647 - 25)- 36*12), true),
			17 => (B_dly(4)'last_event, tpd_B_P((647 - 25)- 36*13), true),
			18 => (B_dly(3)'last_event, tpd_B_P((647 - 25)- 36*14), true),
			19 => (B_dly(2)'last_event, tpd_B_P((647 - 25)- 36*15), true),
			20 => (B_dly(1)'last_event, tpd_B_P((647 - 25)- 36*16), true),
			21 => (B_dly(0)'last_event, tpd_B_P((647 - 25)- 36*17), true),
			22 => (BCIN_dly(10)'last_event, tpd_BCIN_P((647 - 25)- 36*7), true),
			23 => (BCIN_dly(9)'last_event, tpd_BCIN_P((647 - 25)- 36*8), true),
			24 => (BCIN_dly(8)'last_event, tpd_BCIN_P((647 - 25)- 36*9), true),
			25 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 25)- 36*10), true),
			26 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 25)- 36*11), true),
			27 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 25)- 36*12), true),
			28 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 25)- 36*13), true),
			29 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 25)- 36*14), true),
			30 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 25)- 36*15), true),
			31 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 25)- 36*16), true),
			32 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 25)- 36*17), true),
			33 => (CLK_dly'last_event, tpd_CLK_P(10), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(9),
         GlitchData	=> P_GlitchData(9),
         OutSignalName	=> "P(9)",
         OutTemp	=> P_zd(9),
         Paths		=> (
			0 => (A_dly(9)'last_event, tpd_A_P((647 - 26)- 36*8), true),
			1 => (A_dly(8)'last_event, tpd_A_P((647 - 26)- 36*9), true),
			2 => (A_dly(7)'last_event, tpd_A_P((647 - 26)- 36*10), true),
			3 => (A_dly(6)'last_event, tpd_A_P((647 - 26)- 36*11), true),
			4 => (A_dly(5)'last_event, tpd_A_P((647 - 26)- 36*12), true),
			5 => (A_dly(4)'last_event, tpd_A_P((647 - 26)- 36*13), true),
			6 => (A_dly(3)'last_event, tpd_A_P((647 - 26)- 36*14), true),
			7 => (A_dly(2)'last_event, tpd_A_P((647 - 26)- 36*15), true),
			8 => (A_dly(1)'last_event, tpd_A_P((647 - 26)- 36*16), true),
			9 => (A_dly(0)'last_event, tpd_A_P((647 - 26)- 36*17), true),
			10 => (B_dly(9)'last_event, tpd_B_P((647 - 26)- 36*8), true),
			11 => (B_dly(8)'last_event, tpd_B_P((647 - 26)- 36*9), true),
			12 => (B_dly(7)'last_event, tpd_B_P((647 - 26)- 36*10), true),
			13 => (B_dly(6)'last_event, tpd_B_P((647 - 26)- 36*11), true),
			14 => (B_dly(5)'last_event, tpd_B_P((647 - 26)- 36*12), true),
			15 => (B_dly(4)'last_event, tpd_B_P((647 - 26)- 36*13), true),
			16 => (B_dly(3)'last_event, tpd_B_P((647 - 26)- 36*14), true),
			17 => (B_dly(2)'last_event, tpd_B_P((647 - 26)- 36*15), true),
			18 => (B_dly(1)'last_event, tpd_B_P((647 - 26)- 36*16), true),
			19 => (B_dly(0)'last_event, tpd_B_P((647 - 26)- 36*17), true),
			20 => (BCIN_dly(9)'last_event, tpd_BCIN_P((647 - 26)- 36*8), true),
			21 => (BCIN_dly(8)'last_event, tpd_BCIN_P((647 - 26)- 36*9), true),
			22 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 26)- 36*10), true),
			23 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 26)- 36*11), true),
			24 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 26)- 36*12), true),
			25 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 26)- 36*13), true),
			26 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 26)- 36*14), true),
			27 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 26)- 36*15), true),
			28 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 26)- 36*16), true),
			29 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 26)- 36*17), true),
			30 => (CLK_dly'last_event, tpd_CLK_P(9), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(8),
         GlitchData	=> P_GlitchData(8),
         OutSignalName	=> "P(8)",
         OutTemp	=> P_zd(8),
         Paths		=> (
			0 => (A_dly(8)'last_event, tpd_A_P((647 - 27)- 36*9), true),
			1 => (A_dly(7)'last_event, tpd_A_P((647 - 27)- 36*10), true),
			2 => (A_dly(6)'last_event, tpd_A_P((647 - 27)- 36*11), true),
			3 => (A_dly(5)'last_event, tpd_A_P((647 - 27)- 36*12), true),
			4 => (A_dly(4)'last_event, tpd_A_P((647 - 27)- 36*13), true),
			5 => (A_dly(3)'last_event, tpd_A_P((647 - 27)- 36*14), true),
			6 => (A_dly(2)'last_event, tpd_A_P((647 - 27)- 36*15), true),
			7 => (A_dly(1)'last_event, tpd_A_P((647 - 27)- 36*16), true),
			8 => (A_dly(0)'last_event, tpd_A_P((647 - 27)- 36*17), true),
			9 => (B_dly(8)'last_event, tpd_B_P((647 - 27)- 36*9), true),
			10 => (B_dly(7)'last_event, tpd_B_P((647 - 27)- 36*10), true),
			11 => (B_dly(6)'last_event, tpd_B_P((647 - 27)- 36*11), true),
			12 => (B_dly(5)'last_event, tpd_B_P((647 - 27)- 36*12), true),
			13 => (B_dly(4)'last_event, tpd_B_P((647 - 27)- 36*13), true),
			14 => (B_dly(3)'last_event, tpd_B_P((647 - 27)- 36*14), true),
			15 => (B_dly(2)'last_event, tpd_B_P((647 - 27)- 36*15), true),
			16 => (B_dly(1)'last_event, tpd_B_P((647 - 27)- 36*16), true),
			17 => (B_dly(0)'last_event, tpd_B_P((647 - 27)- 36*17), true),
			18 => (BCIN_dly(8)'last_event, tpd_BCIN_P((647 - 27)- 36*9), true),
			19 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 27)- 36*10), true),
			20 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 27)- 36*11), true),
			21 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 27)- 36*12), true),
			22 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 27)- 36*13), true),
			23 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 27)- 36*14), true),
			24 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 27)- 36*15), true),
			25 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 27)- 36*16), true),
			26 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 27)- 36*17), true),
			27 => (CLK_dly'last_event, tpd_CLK_P(8), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(7),
         GlitchData	=> P_GlitchData(7),
         OutSignalName	=> "P(7)",
         OutTemp	=> P_zd(7),
         Paths		=> (
			0 => (A_dly(7)'last_event, tpd_A_P((647 - 28)- 36*10), true),
			1 => (A_dly(6)'last_event, tpd_A_P((647 - 28)- 36*11), true),
			2 => (A_dly(5)'last_event, tpd_A_P((647 - 28)- 36*12), true),
			3 => (A_dly(4)'last_event, tpd_A_P((647 - 28)- 36*13), true),
			4 => (A_dly(3)'last_event, tpd_A_P((647 - 28)- 36*14), true),
			5 => (A_dly(2)'last_event, tpd_A_P((647 - 28)- 36*15), true),
			6 => (A_dly(1)'last_event, tpd_A_P((647 - 28)- 36*16), true),
			7 => (A_dly(0)'last_event, tpd_A_P((647 - 28)- 36*17), true),
			8 => (B_dly(7)'last_event, tpd_B_P((647 - 28)- 36*10), true),
			9 => (B_dly(6)'last_event, tpd_B_P((647 - 28)- 36*11), true),
			10 => (B_dly(5)'last_event, tpd_B_P((647 - 28)- 36*12), true),
			11 => (B_dly(4)'last_event, tpd_B_P((647 - 28)- 36*13), true),
			12 => (B_dly(3)'last_event, tpd_B_P((647 - 28)- 36*14), true),
			13 => (B_dly(2)'last_event, tpd_B_P((647 - 28)- 36*15), true),
			14 => (B_dly(1)'last_event, tpd_B_P((647 - 28)- 36*16), true),
			15 => (B_dly(0)'last_event, tpd_B_P((647 - 28)- 36*17), true),
			16 => (BCIN_dly(7)'last_event, tpd_BCIN_P((647 - 28)- 36*10), true),
			17 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 28)- 36*11), true),
			18 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 28)- 36*12), true),
			19 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 28)- 36*13), true),
			20 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 28)- 36*14), true),
			21 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 28)- 36*15), true),
			22 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 28)- 36*16), true),
			23 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 28)- 36*17), true),
			24 => (CLK_dly'last_event, tpd_CLK_P(7), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(6),
         GlitchData	=> P_GlitchData(6),
         OutSignalName	=> "P(6)",
         OutTemp	=> P_zd(6),
         Paths		=> (
			0 => (A_dly(6)'last_event, tpd_A_P((647 - 29)- 36*11), true),
			1 => (A_dly(5)'last_event, tpd_A_P((647 - 29)- 36*12), true),
			2 => (A_dly(4)'last_event, tpd_A_P((647 - 29)- 36*13), true),
			3 => (A_dly(3)'last_event, tpd_A_P((647 - 29)- 36*14), true),
			4 => (A_dly(2)'last_event, tpd_A_P((647 - 29)- 36*15), true),
			5 => (A_dly(1)'last_event, tpd_A_P((647 - 29)- 36*16), true),
			6 => (A_dly(0)'last_event, tpd_A_P((647 - 29)- 36*17), true),
			7 => (B_dly(6)'last_event, tpd_B_P((647 - 29)- 36*11), true),
			8 => (B_dly(5)'last_event, tpd_B_P((647 - 29)- 36*12), true),
			9 => (B_dly(4)'last_event, tpd_B_P((647 - 29)- 36*13), true),
			10 => (B_dly(3)'last_event, tpd_B_P((647 - 29)- 36*14), true),
			11 => (B_dly(2)'last_event, tpd_B_P((647 - 29)- 36*15), true),
			12 => (B_dly(1)'last_event, tpd_B_P((647 - 29)- 36*16), true),
			13 => (B_dly(0)'last_event, tpd_B_P((647 - 29)- 36*17), true),
			14 => (BCIN_dly(6)'last_event, tpd_BCIN_P((647 - 29)- 36*11), true),
			15 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 29)- 36*12), true),
			16 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 29)- 36*13), true),
			17 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 29)- 36*14), true),
			18 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 29)- 36*15), true),
			19 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 29)- 36*16), true),
			20 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 29)- 36*17), true),
			21 => (CLK_dly'last_event, tpd_CLK_P(6), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(5),
         GlitchData	=> P_GlitchData(5),
         OutSignalName	=> "P(5)",
         OutTemp	=> P_zd(5),
         Paths		=> (
			0 => (A_dly(5)'last_event, tpd_A_P((647 - 30)- 36*12), true),
			1 => (A_dly(4)'last_event, tpd_A_P((647 - 30)- 36*13), true),
			2 => (A_dly(3)'last_event, tpd_A_P((647 - 30)- 36*14), true),
			3 => (A_dly(2)'last_event, tpd_A_P((647 - 30)- 36*15), true),
			4 => (A_dly(1)'last_event, tpd_A_P((647 - 30)- 36*16), true),
			5 => (A_dly(0)'last_event, tpd_A_P((647 - 30)- 36*17), true),
			6 => (B_dly(5)'last_event, tpd_B_P((647 - 30)- 36*12), true),
			7 => (B_dly(4)'last_event, tpd_B_P((647 - 30)- 36*13), true),
			8 => (B_dly(3)'last_event, tpd_B_P((647 - 30)- 36*14), true),
			9 => (B_dly(2)'last_event, tpd_B_P((647 - 30)- 36*15), true),
			10 => (B_dly(1)'last_event, tpd_B_P((647 - 30)- 36*16), true),
			11 => (B_dly(0)'last_event, tpd_B_P((647 - 30)- 36*17), true),
			12 => (BCIN_dly(5)'last_event, tpd_BCIN_P((647 - 30)- 36*12), true),
			13 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 30)- 36*13), true),
			14 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 30)- 36*14), true),
			15 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 30)- 36*15), true),
			16 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 30)- 36*16), true),
			17 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 30)- 36*17), true),
			18 => (CLK_dly'last_event, tpd_CLK_P(5), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(4),
         GlitchData	=> P_GlitchData(4),
         OutSignalName	=> "P(4)",
         OutTemp	=> P_zd(4),
         Paths		=> (
			0 => (A_dly(4)'last_event, tpd_A_P((647 - 31)- 36*13), true),
			1 => (A_dly(3)'last_event, tpd_A_P((647 - 31)- 36*14), true),
			2 => (A_dly(2)'last_event, tpd_A_P((647 - 31)- 36*15), true),
			3 => (A_dly(1)'last_event, tpd_A_P((647 - 31)- 36*16), true),
			4 => (A_dly(0)'last_event, tpd_A_P((647 - 31)- 36*17), true),
			5 => (B_dly(4)'last_event, tpd_B_P((647 - 31)- 36*13), true),
			6 => (B_dly(3)'last_event, tpd_B_P((647 - 31)- 36*14), true),
			7 => (B_dly(2)'last_event, tpd_B_P((647 - 31)- 36*15), true),
			8 => (B_dly(1)'last_event, tpd_B_P((647 - 31)- 36*16), true),
			9 => (B_dly(0)'last_event, tpd_B_P((647 - 31)- 36*17), true),
			10 => (BCIN_dly(4)'last_event, tpd_BCIN_P((647 - 31)- 36*13), true),
			11 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 31)- 36*14), true),
			12 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 31)- 36*15), true),
			13 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 31)- 36*16), true),
			14 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 31)- 36*17), true),
			15 => (CLK_dly'last_event, tpd_CLK_P(4), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(3),
         GlitchData	=> P_GlitchData(3),
         OutSignalName	=> "P(3)",
         OutTemp	=> P_zd(3),
         Paths		=> (
			0 => (A_dly(3)'last_event, tpd_A_P((647 - 32)- 36*14), true),
			1 => (A_dly(2)'last_event, tpd_A_P((647 - 32)- 36*15), true),
			2 => (A_dly(1)'last_event, tpd_A_P((647 - 32)- 36*16), true),
			3 => (A_dly(0)'last_event, tpd_A_P((647 - 32)- 36*17), true),
			4 => (B_dly(3)'last_event, tpd_B_P((647 - 32)- 36*14), true),
			5 => (B_dly(2)'last_event, tpd_B_P((647 - 32)- 36*15), true),
			6 => (B_dly(1)'last_event, tpd_B_P((647 - 32)- 36*16), true),
			7 => (B_dly(0)'last_event, tpd_B_P((647 - 32)- 36*17), true),
			8 => (BCIN_dly(3)'last_event, tpd_BCIN_P((647 - 32)- 36*14), true),
			9 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 32)- 36*15), true),
			10 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 32)- 36*16), true),
			11 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 32)- 36*17), true),
			12 => (CLK_dly'last_event, tpd_CLK_P(3), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(2),
         GlitchData	=> P_GlitchData(2),
         OutSignalName	=> "P(2)",
         OutTemp	=> P_zd(2),
         Paths		=> (
			0 => (A_dly(2)'last_event, tpd_A_P((647 - 33)- 36*15), true),
			1 => (A_dly(1)'last_event, tpd_A_P((647 - 33)- 36*16), true),
			2 => (A_dly(0)'last_event, tpd_A_P((647 - 33)- 36*17), true),
			3 => (B_dly(2)'last_event, tpd_B_P((647 - 33)- 36*15), true),
			4 => (B_dly(1)'last_event, tpd_B_P((647 - 33)- 36*16), true),
			5 => (B_dly(0)'last_event, tpd_B_P((647 - 33)- 36*17), true),
			6 => (BCIN_dly(2)'last_event, tpd_BCIN_P((647 - 33)- 36*15), true),
			7 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 33)- 36*16), true),
			8 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 33)- 36*17), true),
			9 => (CLK_dly'last_event, tpd_CLK_P(2), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(1),
         GlitchData	=> P_GlitchData(1),
         OutSignalName	=> "P(1)",
         OutTemp	=> P_zd(1),
         Paths		=> (
			0 => (A_dly(1)'last_event, tpd_A_P((647 - 34)- 36*16), true),
			1 => (A_dly(0)'last_event, tpd_A_P((647 - 34)- 36*17), true),
			2 => (B_dly(1)'last_event, tpd_B_P((647 - 34)- 36*16), true),
			3 => (B_dly(0)'last_event, tpd_B_P((647 - 34)- 36*17), true),
			4 => (BCIN_dly(1)'last_event, tpd_BCIN_P((647 - 34)- 36*16), true),
			5 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 34)- 36*17), true),
			6 => (CLK_dly'last_event, tpd_CLK_P(1), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> P(0),
         GlitchData	=> P_GlitchData(0),
         OutSignalName	=> "P(0)",
         OutTemp	=> P_zd(0),
         Paths		=> (
			0 => (A_dly(0)'last_event, tpd_A_P((647 - 35)- 36*17), true),
			1 => (B_dly(0)'last_event, tpd_B_P((647 - 35)- 36*17), true),
			2 => (BCIN_dly(0)'last_event, tpd_BCIN_P((647 - 35)- 36*17), true),
			3 => (CLK_dly'last_event, tpd_CLK_P(0), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> BCOUT(17),
         GlitchData	=> BCOUT_GlitchData(17),
         OutSignalName	=> "BCOUT(17)",
         OutTemp	=> BCOUT_zd(17),
         Paths		=> (
			0 => (B_dly(17)'last_event, tpd_B_BCOUT((323 - 0)- 18*0), true),
			1 => (BCIN_dly(17)'last_event, tpd_BCIN_BCOUT((323 - 0)- 18*0), true),
			2 => (CLK_dly'last_event, tpd_CLK_BCOUT(17), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> BCOUT(16),
         GlitchData	=> BCOUT_GlitchData(16),
         OutSignalName	=> "BCOUT(16)",
         OutTemp	=> BCOUT_zd(16),
         Paths		=> (
			0 => (B_dly(16)'last_event, tpd_B_BCOUT((323 - 1)- 18*1), true),
			1 => (BCIN_dly(16)'last_event, tpd_BCIN_BCOUT((323 - 1)- 18*1), true),
			2 => (CLK_dly'last_event, tpd_CLK_BCOUT(16), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> BCOUT(15),
         GlitchData	=> BCOUT_GlitchData(15),
         OutSignalName	=> "BCOUT(15)",
         OutTemp	=> BCOUT_zd(15),
         Paths		=> (
			0 => (B_dly(15)'last_event, tpd_B_BCOUT((323 - 2)- 18*2), true),
			1 => (BCIN_dly(15)'last_event, tpd_BCIN_BCOUT((323 - 2)- 18*2), true),
			2 => (CLK_dly'last_event, tpd_CLK_BCOUT(15), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> BCOUT(14),
         GlitchData	=> BCOUT_GlitchData(14),
         OutSignalName	=> "BCOUT(14)",
         OutTemp	=> BCOUT_zd(14),
         Paths		=> (
			0 => (B_dly(14)'last_event, tpd_B_BCOUT((323 - 3)- 18*3), true),
			1 => (BCIN_dly(14)'last_event, tpd_BCIN_BCOUT((323 - 3)- 18*3), true),
			2 => (CLK_dly'last_event, tpd_CLK_BCOUT(14), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> BCOUT(13),
         GlitchData	=> BCOUT_GlitchData(13),
         OutSignalName	=> "BCOUT(13)",
         OutTemp	=> BCOUT_zd(13),
         Paths		=> (
			0 => (B_dly(13)'last_event, tpd_B_BCOUT((323 - 4)- 18*4), true),
			1 => (BCIN_dly(13)'last_event, tpd_BCIN_BCOUT((323 - 4)- 18*4), true),
			2 => (CLK_dly'last_event, tpd_CLK_BCOUT(13), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> BCOUT(12),
         GlitchData	=> BCOUT_GlitchData(12),
         OutSignalName	=> "BCOUT(12)",
         OutTemp	=> BCOUT_zd(12),
         Paths		=> (
			0 => (B_dly(12)'last_event, tpd_B_BCOUT((323 - 5)- 18*5), true),
			1 => (BCIN_dly(12)'last_event, tpd_BCIN_BCOUT((323 - 5)- 18*5), true),
			2 => (CLK_dly'last_event, tpd_CLK_BCOUT(12), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> BCOUT(11),
         GlitchData	=> BCOUT_GlitchData(11),
         OutSignalName	=> "BCOUT(11)",
         OutTemp	=> BCOUT_zd(11),
         Paths		=> (
			0 => (B_dly(11)'last_event, tpd_B_BCOUT((323 - 6)- 18*6), true),
			1 => (BCIN_dly(11)'last_event, tpd_BCIN_BCOUT((323 - 6)- 18*6), true),
			2 => (CLK_dly'last_event, tpd_CLK_BCOUT(11), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> BCOUT(10),
         GlitchData	=> BCOUT_GlitchData(10),
         OutSignalName	=> "BCOUT(10)",
         OutTemp	=> BCOUT_zd(10),
         Paths		=> (
			0 => (B_dly(10)'last_event, tpd_B_BCOUT((323 - 7)- 18*7), true),
			1 => (BCIN_dly(10)'last_event, tpd_BCIN_BCOUT((323 - 7)- 18*7), true),
			2 => (CLK_dly'last_event, tpd_CLK_BCOUT(10), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> BCOUT(9),
         GlitchData	=> BCOUT_GlitchData(9),
         OutSignalName	=> "BCOUT(9)",
         OutTemp	=> BCOUT_zd(9),
         Paths		=> (
			0 => (B_dly(9)'last_event, tpd_B_BCOUT((323 - 8)- 18*8), true),
			1 => (BCIN_dly(9)'last_event, tpd_BCIN_BCOUT((323 - 8)- 18*8), true),
			2 => (CLK_dly'last_event, tpd_CLK_BCOUT(9), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> BCOUT(8),
         GlitchData	=> BCOUT_GlitchData(8),
         OutSignalName	=> "BCOUT(8)",
         OutTemp	=> BCOUT_zd(8),
         Paths		=> (
			0 => (B_dly(8)'last_event, tpd_B_BCOUT((323 - 9)- 18*9), true),
			1 => (BCIN_dly(8)'last_event, tpd_BCIN_BCOUT((323 - 9)- 18*9), true),
			2 => (CLK_dly'last_event, tpd_CLK_BCOUT(8), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> BCOUT(7),
         GlitchData	=> BCOUT_GlitchData(7),
         OutSignalName	=> "BCOUT(7)",
         OutTemp	=> BCOUT_zd(7),
         Paths		=> (
			0 => (B_dly(7)'last_event, tpd_B_BCOUT((323 - 10)- 18*10), true),
			1 => (BCIN_dly(7)'last_event, tpd_BCIN_BCOUT((323 - 10)- 18*10), true),
			2 => (CLK_dly'last_event, tpd_CLK_BCOUT(7), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> BCOUT(6),
         GlitchData	=> BCOUT_GlitchData(6),
         OutSignalName	=> "BCOUT(6)",
         OutTemp	=> BCOUT_zd(6),
         Paths		=> (
			0 => (B_dly(6)'last_event, tpd_B_BCOUT((323 - 11)- 18*11), true),
			1 => (BCIN_dly(6)'last_event, tpd_BCIN_BCOUT((323 - 11)- 18*11), true),
			2 => (CLK_dly'last_event, tpd_CLK_BCOUT(6), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> BCOUT(5),
         GlitchData	=> BCOUT_GlitchData(5),
         OutSignalName	=> "BCOUT(5)",
         OutTemp	=> BCOUT_zd(5),
         Paths		=> (
			0 => (B_dly(5)'last_event, tpd_B_BCOUT((323 - 12)- 18*12), true),
			1 => (BCIN_dly(5)'last_event, tpd_BCIN_BCOUT((323 - 12)- 18*12), true),
			2 => (CLK_dly'last_event, tpd_CLK_BCOUT(5), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> BCOUT(4),
         GlitchData	=> BCOUT_GlitchData(4),
         OutSignalName	=> "BCOUT(4)",
         OutTemp	=> BCOUT_zd(4),
         Paths		=> (
			0 => (B_dly(4)'last_event, tpd_B_BCOUT((323 - 13)- 18*13), true),
			1 => (BCIN_dly(4)'last_event, tpd_BCIN_BCOUT((323 - 13)- 18*13), true),
			2 => (CLK_dly'last_event, tpd_CLK_BCOUT(4), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> BCOUT(3),
         GlitchData	=> BCOUT_GlitchData(3),
         OutSignalName	=> "BCOUT(3)",
         OutTemp	=> BCOUT_zd(3),
         Paths		=> (
			0 => (B_dly(3)'last_event, tpd_B_BCOUT((323 - 14)- 18*14), true),
			1 => (BCIN_dly(3)'last_event, tpd_BCIN_BCOUT((323 - 14)- 18*14), true),
			2 => (CLK_dly'last_event, tpd_CLK_BCOUT(3), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> BCOUT(2),
         GlitchData	=> BCOUT_GlitchData(2),
         OutSignalName	=> "BCOUT(2)",
         OutTemp	=> BCOUT_zd(2),
         Paths		=> (
			0 => (B_dly(2)'last_event, tpd_B_BCOUT((323 - 15)- 18*15), true),
			1 => (BCIN_dly(2)'last_event, tpd_BCIN_BCOUT((323 - 15)- 18*15), true),
			2 => (CLK_dly'last_event, tpd_CLK_BCOUT(2), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> BCOUT(1),
         GlitchData	=> BCOUT_GlitchData(1),
         OutSignalName	=> "BCOUT(1)",
         OutTemp	=> BCOUT_zd(1),
         Paths		=> (
			0 => (B_dly(1)'last_event, tpd_B_BCOUT((323 - 16)- 18*16), true),
			1 => (BCIN_dly(1)'last_event, tpd_BCIN_BCOUT((323 - 16)- 18*16), true),
			2 => (CLK_dly'last_event, tpd_CLK_BCOUT(1), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

       VitalPathDelay01 (
         OutSignal	=> BCOUT(0),
         GlitchData	=> BCOUT_GlitchData(0),
         OutSignalName	=> "BCOUT(0)",
         OutTemp	=> BCOUT_zd(0),
         Paths		=> (
			0 => (B_dly(0)'last_event, tpd_B_BCOUT((323 - 17)- 18*17), true),
			1 => (BCIN_dly(0)'last_event, tpd_BCIN_BCOUT((323 - 17)- 18*17), true),
			2 => (CLK_dly'last_event, tpd_CLK_BCOUT(0), true)),
         Mode		=> VitalTransport,
         Xon		=> Xon,
         MsgOn		=> MsgOn,
         MsgSeverity	=> warning);

-- 07/25/05 -- CR 212535 Added CLK_dly to the sensitivity list
-- 08/29/05 -- CR 213754 Added rest of the signals to the sensitivity list
    wait on A_dly, B_dly, BCIN_dly, CEA_dly, CEB_dly, CEP_dly, CLK_dly, RSTA_dly, RSTB_dly, 
            P_zd, BCOUT_zd;
  end process prcs_Timing;

end X_MULT18X18SIO_V ;

-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  Dual Data Rate Output D Flip-Flop
-- /___/   /\     Filename : X_ODDR2.vhd
-- \   \  /  \    Timestamp : Fri Mar 26 08:18:20 PST 2004
--  \___\/\___\
--
-- Revision:
--    03/23/04 - Initial version.

----- CELL X_ODDR2 -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;


library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.Vcomponents.all;
use simprim.VPACKAGE.all;

entity X_ODDR2 is

  generic(

      TimingChecksOn : boolean := true;
      InstancePath   : string  := "*";
      Xon            : boolean := true;
      MsgOn          : boolean := true;
      LOC            : string  := "UNPLACED";

-- workaround for scirocco
      tbpd_GSR_Q_C0 : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tbpd_R_Q_C0 : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tbpd_S_Q_C0 : VitalDelayType01 := (0.000 ns, 0.000 ns);
  
--  VITAL input Pin path delay variables
      tipd_C0   : VitalDelayType01 := (0 ps, 0 ps);
      tipd_C1   : VitalDelayType01 := (0 ps, 0 ps);
      tipd_CE   : VitalDelayType01 := (0 ps, 0 ps);
      tipd_D0   : VitalDelayType01 := (0 ps, 0 ps);
      tipd_D1   : VitalDelayType01 := (0 ps, 0 ps);
      tipd_GSR  : VitalDelayType01 := (0 ps, 0 ps);
      tipd_R    : VitalDelayType01 := (0 ps, 0 ps);
      tipd_S    : VitalDelayType01 := (0 ps, 0 ps);

--  VITAL clk-to-output path delay variables
      tpd_C0_Q   : VitalDelayType01 := (100 ps, 100 ps);
      tpd_C1_Q   : VitalDelayType01 := (100 ps, 100 ps);

--  VITAL async rest-to-output path delay variables
      tpd_R_Q   : VitalDelayType01 := (0 ps, 0 ps);

--  VITAL async set-to-output path delay variables
      tpd_S_Q   : VitalDelayType01 := (0 ps, 0 ps);

--  VITAL GSR-to-output path delay variable
      tpd_GSR_Q : VitalDelayType01 := (0 ps, 0 ps);


--  VITAL ticd & tisd variables
      ticd_C0     : VitalDelayType   := 0.0 ps;
      ticd_C1     : VitalDelayType   := 0.0 ps;
      tisd_D0_C0  : VitalDelayType   := 0.0 ps;
      tisd_D1_C0  : VitalDelayType   := 0.0 ps;
      tisd_D0_C1  : VitalDelayType   := 0.0 ps;
      tisd_D1_C1  : VitalDelayType   := 0.0 ps;
      tisd_CE_C0  : VitalDelayType   := 0.0 ps;
      tisd_CE_C1  : VitalDelayType   := 0.0 ps;
      tisd_GSR_C0 : VitalDelayType   := 0.0 ps;
      tisd_GSR_C1 : VitalDelayType   := 0.0 ps;
      tisd_R_C0   : VitalDelayType   := 0.0 ps;
      tisd_R_C1   : VitalDelayType   := 0.0 ps;
      tisd_S_C0   : VitalDelayType   := 0.0 ps;
      tisd_S_C1   : VitalDelayType   := 0.0 ps;

--  VITAL Setup/Hold delay variables
      tsetup_CE_C0_posedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_CE_C0_negedge_posedge : VitalDelayType := 0.0 ps;
      thold_CE_C0_posedge_posedge  : VitalDelayType := 0.0 ps;
      thold_CE_C0_negedge_posedge  : VitalDelayType := 0.0 ps;
      tsetup_CE_C1_posedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_CE_C1_negedge_posedge : VitalDelayType := 0.0 ps;
      thold_CE_C1_posedge_posedge  : VitalDelayType := 0.0 ps;
      thold_CE_C1_negedge_posedge  : VitalDelayType := 0.0 ps;

      tsetup_D0_C0_posedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_D0_C0_negedge_posedge : VitalDelayType := 0.0 ps;
      thold_D0_C0_posedge_posedge  : VitalDelayType := 0.0 ps;
      thold_D0_C0_negedge_posedge  : VitalDelayType := 0.0 ps;
      tsetup_D1_C0_posedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_D1_C0_negedge_posedge : VitalDelayType := 0.0 ps;
      thold_D1_C0_posedge_posedge  : VitalDelayType := 0.0 ps;
      thold_D1_C0_negedge_posedge  : VitalDelayType := 0.0 ps;

      tsetup_D0_C1_posedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_D0_C1_negedge_posedge : VitalDelayType := 0.0 ps;
      thold_D0_C1_posedge_posedge  : VitalDelayType := 0.0 ps;
      thold_D0_C1_negedge_posedge  : VitalDelayType := 0.0 ps;
      tsetup_D1_C1_posedge_posedge : VitalDelayType := 0.0 ps;
      tsetup_D1_C1_negedge_posedge : VitalDelayType := 0.0 ps;
      thold_D1_C1_posedge_posedge  : VitalDelayType := 0.0 ps;
      thold_D1_C1_negedge_posedge  : VitalDelayType := 0.0 ps;

      tsetup_R_C0_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_R_C0_negedge_posedge : VitalDelayType := 0 ps;
      thold_R_C0_posedge_posedge  : VitalDelayType := 0 ps;
      thold_R_C0_negedge_posedge  : VitalDelayType := 0 ps;
      tsetup_R_C1_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_R_C1_negedge_posedge : VitalDelayType := 0 ps;
      thold_R_C1_posedge_posedge  : VitalDelayType := 0 ps;
      thold_R_C1_negedge_posedge  : VitalDelayType := 0 ps;
  
      tsetup_S_C0_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_S_C0_negedge_posedge : VitalDelayType := 0 ps;
      thold_S_C0_posedge_posedge  : VitalDelayType := 0 ps;
      thold_S_C0_negedge_posedge  : VitalDelayType := 0 ps;
      tsetup_S_C1_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_S_C1_negedge_posedge : VitalDelayType := 0 ps;
      thold_S_C1_posedge_posedge  : VitalDelayType := 0 ps;
      thold_S_C1_negedge_posedge  : VitalDelayType := 0 ps;
  
-- VITAL pulse width variables
      tpw_C0_negedge              : VitalDelayType := 0 ps;
      tpw_C0_posedge              : VitalDelayType := 0 ps;
      tpw_C1_negedge              : VitalDelayType := 0 ps;
      tpw_C1_posedge              : VitalDelayType := 0 ps;
  
      tpw_GSR_posedge            : VitalDelayType := 0 ps;
      tpw_R_posedge              : VitalDelayType := 0 ps;
      tpw_S_posedge              : VitalDelayType := 0 ps;

-- VITAL period variables
      tperiod_C0_posedge          : VitalDelayType := 0 ps;
      tperiod_C1_posedge          : VitalDelayType := 0 ps;

-- VITAL recovery time variables
      trecovery_GSR_C0_negedge_posedge : VitalDelayType := 0 ps;
      trecovery_R_C0_negedge_posedge   : VitalDelayType := 0 ps;
      trecovery_S_C0_negedge_posedge   : VitalDelayType := 0 ps;
      trecovery_GSR_C1_negedge_posedge : VitalDelayType := 0 ps;
      trecovery_R_C1_negedge_posedge   : VitalDelayType := 0 ps;
      trecovery_S_C1_negedge_posedge   : VitalDelayType := 0 ps;
  
-- VITAL removal time variables
      tremoval_GSR_C0_negedge_posedge  : VitalDelayType := 0 ps;
      tremoval_R_C0_negedge_posedge    : VitalDelayType := 0 ps;
      tremoval_S_C0_negedge_posedge    : VitalDelayType := 0 ps;
      tremoval_GSR_C1_negedge_posedge  : VitalDelayType := 0 ps;
      tremoval_R_C1_negedge_posedge    : VitalDelayType := 0 ps;
      tremoval_S_C1_negedge_posedge    : VitalDelayType := 0 ps;

      DDR_ALIGNMENT : string := "NONE";
      INIT          : bit    := '0';
      SRTYPE        : string := "SYNC"
      );

  port(
      Q           : out std_ulogic;

      C0          : in  std_ulogic;
      C1          : in  std_ulogic;
      CE          : in  std_ulogic;
      D0          : in  std_ulogic;
      D1          : in  std_ulogic;
      R           : in  std_ulogic;
      S           : in  std_ulogic
    );

  attribute VITAL_LEVEL0 of
    X_ODDR2 : entity is true;

end X_ODDR2;

architecture X_ODDR2_V OF X_ODDR2 is

  attribute VITAL_LEVEL0 of
    X_ODDR2_V : architecture is true;


  constant SYNC_PATH_DELAY : time := 100 ps;

  signal C0_ipd	        : std_ulogic := 'X';
  signal C1_ipd	        : std_ulogic := 'X';
  signal CE_ipd	        : std_ulogic := 'X';
  signal D0_ipd	        : std_ulogic := 'X';
  signal D1_ipd	        : std_ulogic := 'X';
  signal GSR_ipd	: std_ulogic := 'X';
  signal R_ipd		: std_ulogic := 'X';
  signal S_ipd		: std_ulogic := 'X';

  signal C0_dly	        : std_ulogic := 'X';
  signal C1_dly	        : std_ulogic := 'X';
  signal CE_dly	        : std_ulogic := 'X';
  signal D0_dly	        : std_ulogic := 'X';
  signal D1_dly	        : std_ulogic := 'X';
  signal GSR_dly	: std_ulogic := 'X';
  signal R_dly		: std_ulogic := 'X';
  signal S_dly		: std_ulogic := 'X';

  signal Q_zd		: std_ulogic := 'X';

  signal Q_viol		: std_ulogic := 'X';

  signal ddr_alignment_type	: integer := -999;
  signal sr_type		: integer := -999;

begin

  ---------------------
  --  INPUT PATH DELAYs
  --------------------

  WireDelay : block
  begin
    VitalWireDelay (C0_ipd,  C0,  tipd_C0);
    VitalWireDelay (C1_ipd,  C1,  tipd_C1);
    VitalWireDelay (CE_ipd,  CE,  tipd_CE);
    VitalWireDelay (D0_ipd,  D0,  tipd_D0);
    VitalWireDelay (D1_ipd,  D1,  tipd_D1);
    VitalWireDelay (GSR_ipd, GSR, tipd_GSR);
    VitalWireDelay (R_ipd,   R,   tipd_R);
    VitalWireDelay (S_ipd,   S,   tipd_S);
  end block;

  SignalDelay : block
  begin
    VitalSignalDelay (C0_dly,  C0_ipd,  ticd_C0);
    VitalSignalDelay (C1_dly,  C1_ipd,  ticd_C1);
    VitalSignalDelay (CE_dly,  CE_ipd,  ticd_C0);
    VitalSignalDelay (D0_dly,  D0_ipd,  ticd_C0);
    VitalSignalDelay (D1_dly,  D1_ipd,  ticd_C1);
    VitalSignalDelay (GSR_dly, GSR_ipd, tisd_GSR_C0);
    VitalSignalDelay (R_dly,   R_ipd,   tisd_R_C0);
    VitalSignalDelay (S_dly,   S_ipd,   tisd_S_C0);
  end block;

  --------------------
  --  BEHAVIOR SECTION
  --------------------


--####################################################################
--#####                     Initialize                           #####
--####################################################################
  prcs_init:process

  begin
      if((DDR_ALIGNMENT = "NONE") or (DDR_ALIGNMENT = "none")) then
         ddr_alignment_type <= 1;
      elsif((DDR_ALIGNMENT = "C0") or (DDR_ALIGNMENT = "c0")) then
         ddr_alignment_type <= 2;
      elsif((DDR_ALIGNMENT = "C1") or (DDR_ALIGNMENT = "c1")) then
         ddr_alignment_type <= 3;
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Error :",
             GenericName => " DDR_ALIGNMENT ",
             EntityName => "/ODDR2",
             GenericValue => DDR_ALIGNMENT,
             Unit => "",
             ExpectedValueMsg => " The Legal values for this attribute are ",
             ExpectedGenericValue => " NONE, C0 or C1.",
             TailMsg => "",
             MsgSeverity => failure
         );
      end if;

      if((SRTYPE = "ASYNC") or (SRTYPE = "async")) then
         sr_type <= 1;
      elsif((SRTYPE = "SYNC") or (SRTYPE = "sync")) then
         sr_type <= 2;
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Error :",
             GenericName => " SRTYPE ",
             EntityName => "/ODDR2",
             GenericValue => SRTYPE,
             Unit => "",
             ExpectedValueMsg => " The Legal values for this attribute are ",
             ExpectedGenericValue => " ASYNC or SYNC. ",
             TailMsg => "",
             MsgSeverity => failure
         );
      end if;

     wait;
  end process prcs_init;
--####################################################################
--#####                      functionality                       #####
--####################################################################
  prcs_func_reg:process(C0_dly, C1_dly, GSR_dly, R_dly, S_dly)
    variable FIRST_TIME : boolean := true;
    variable q_var         : std_ulogic := TO_X01(INIT);
    variable q_d0_c1_out_var : std_ulogic := TO_X01(INIT);
    variable q_d1_c0_out_var : std_ulogic := TO_X01(INIT);
  begin
     if((GSR_dly = '1') or (FIRST_TIME)) then
         q_var         := TO_X01(INIT);
         q_d0_c1_out_var := TO_X01(INIT);
         q_d1_c0_out_var := TO_X01(INIT);
         FIRST_TIME := false;
     else
        case sr_type is
           when 1 => 
                   if(R_dly = '1') then
                      q_var := '0';
                      q_d0_c1_out_var := '0';
                      q_d1_c0_out_var := '0';
                   elsif((R_dly = '0') and (S_dly = '1')) then
                      q_var := '1';
                      q_d0_c1_out_var := '1';
                      q_d1_c0_out_var := '1';
                   elsif((R_dly = '0') and (S_dly = '0')) then
                      if(CE_dly = '1') then
                         if(rising_edge(C0_dly)) then
                           if(ddr_alignment_type = 3) then
                             q_var := q_d0_c1_out_var;
                           else
                             q_var := D0_dly;
                             if(ddr_alignment_type = 2) then
                               q_d1_c0_out_var := D1_dly;
                             end if;
                           end if;
                         end if;
                         if(rising_edge(C1_dly)) then
                           if(ddr_alignment_type = 2) then
                             q_var := q_d1_c0_out_var;
                           else
                             q_var := D1_dly;
                             if(ddr_alignment_type = 3) then
                               q_d0_c1_out_var := D0_dly;
                             end if;
                           end if;
                         end if;
                      end if;
                   end if;

           when 2 => 
                   if(rising_edge(C0_dly)) then
                      if(R_dly = '1') then
                         q_var := '0';
                         q_d1_c0_out_var := '0';
                      elsif((R_dly = '0') and (S_dly = '1')) then
                         q_var := '1';
                         q_d1_c0_out_var := '1';
                      elsif((R_dly = '0') and (S_dly = '0')) then
                         if(CE_dly = '1') then
                           if(ddr_alignment_type = 3) then
                             q_var := q_d0_c1_out_var;
                           else
                             q_var := D0_dly;
                             if(ddr_alignment_type = 2) then
                               q_d1_c0_out_var := D1_dly;
                             end if;
                           end if;
                         end if;
                      end if;
                   end if;
                        
                   if(rising_edge(C1_dly)) then
                      if(R_dly = '1') then
                         q_var := '0';
                         q_d0_c1_out_var := '0';
                      elsif((R_dly = '0') and (S_dly = '1')) then
                         q_var := '1';
                         q_d0_c1_out_var := '1';
                      elsif((R_dly = '0') and (S_dly = '0')) then
                         if(CE_dly = '1') then
                           if(ddr_alignment_type = 2) then
                             q_var := q_d1_c0_out_var;
                           else
                             q_var := D1_dly;
                             if(ddr_alignment_type = 3) then
                               q_d0_c1_out_var := D0_dly;
                             end if;
                           end if;
                         end if;
                      end if;
                   end if;
 
           when others =>
                   null; 
        end case;
     end if;

     Q_zd <= q_var;

  end process prcs_func_reg;
--####################################################################

--####################################################################
--#####                   TIMING CHECKS & OUTPUT                 #####
--####################################################################
  prcs_tmngchk:process

  variable PInfo_R : VitalPeriodDataType := VitalPeriodDataInit;
  variable Pviol_R : std_ulogic          := '0';

  variable PInfo_S : VitalPeriodDataType := VitalPeriodDataInit;
  variable Pviol_S : std_ulogic          := '0';

  variable Pviol_C0 :  std_ulogic          := '0';
  variable PInfo_C0 :  VitalPeriodDataType := VitalPeriodDataInit;
  variable Pviol_C1 :  std_ulogic          := '0';
  variable PInfo_C1 :  VitalPeriodDataType := VitalPeriodDataInit;

  variable Tmkr_CE_C0_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_CE_C0_posedge : std_ulogic := '0';

  variable Tmkr_CE_C1_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_CE_C1_posedge : std_ulogic := '0';

  variable Tmkr_D0_C0_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_D0_C0_posedge : std_ulogic := '0';

  variable Tmkr_D0_C1_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_D0_C1_posedge : std_ulogic := '0';

  variable Tmkr_D1_C0_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_D1_C0_posedge : std_ulogic := '0';

  variable Tmkr_D1_C1_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_D1_C1_posedge : std_ulogic := '0';

  variable Tmkr_R_C0_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_R_C0_posedge : std_ulogic := '0';

  variable Tmkr_R_C1_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_R_C1_posedge : std_ulogic := '0';

  variable Tmkr_S_C0_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_S_C0_posedge : std_ulogic := '0';

  variable Tmkr_S_C1_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_S_C1_posedge : std_ulogic := '0';

  variable Tmkr_GSR_C0_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_GSR_C0_posedge : std_ulogic := '0';

  variable Tmkr_GSR_C1_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_GSR_C1_posedge : std_ulogic := '0';

  variable Violation           : std_ulogic          := '0';
  begin
    if (TimingChecksOn) then
--=====  Vital SetupHold Check for signal CE =====
       VitalSetupHoldCheck (
         Violation            => Tviol_CE_C0_posedge,
         TimingData           => Tmkr_CE_C0_posedge,
         TestSignal           => CE_dly,
         TestSignalName       => "CE",
         TestDelay            => tisd_CE_C0,
         RefSignal            => C0_dly,
         RefSignalName        => "C0",
         RefDelay             => ticd_C0,
         SetupHigh            => tsetup_CE_C0_posedge_posedge,
         SetupLow             => tsetup_CE_C0_negedge_posedge,
         HoldHigh             => thold_CE_C0_posedge_posedge,
         HoldLow              => thold_CE_C0_negedge_posedge,
         CheckEnabled         => true,
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_ODDR2",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => Error);
--=====  Vital SetupHold Check for signal CE =====
       VitalSetupHoldCheck (
         Violation            => Tviol_CE_C1_posedge,
         TimingData           => Tmkr_CE_C1_posedge,
         TestSignal           => CE_dly,
         TestSignalName       => "CE",
         TestDelay            => tisd_CE_C1,
         RefSignal            => C1_dly,
         RefSignalName        => "C1",
         RefDelay             => ticd_C1,
         SetupHigh            => tsetup_CE_C1_posedge_posedge,
         SetupLow             => tsetup_CE_C1_negedge_posedge,
         HoldHigh             => thold_CE_C1_posedge_posedge,
         HoldLow              => thold_CE_C1_negedge_posedge,
         CheckEnabled         => true,
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_ODDR2",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => Error);
--=====  Vital SetupHold Check for signal D0 =====
       VitalSetupHoldCheck (
         Violation            => Tviol_D0_C0_posedge,
         TimingData           => Tmkr_D0_C0_posedge,
         TestSignal           => D0_dly,
         TestSignalName       => "D0",
         TestDelay            => tisd_D0_C0,
         RefSignal            => C0_dly,
         RefSignalName        => "C0",
         RefDelay             => ticd_C0,
         SetupHigh            => tsetup_D0_C0_posedge_posedge,
         SetupLow             => tsetup_D0_C0_negedge_posedge,
         HoldHigh             => thold_D0_C0_posedge_posedge,
         HoldLow              => thold_D0_C0_negedge_posedge,
         CheckEnabled         => true,
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_ODDR2",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => Error);
--=====  Vital SetupHold Check for signal D0 =====
       VitalSetupHoldCheck (
         Violation            => Tviol_D0_C1_posedge,
         TimingData           => Tmkr_D0_C1_posedge,
         TestSignal           => D0_dly,
         TestSignalName       => "D0",
         TestDelay            => tisd_D0_C1,
         RefSignal            => C1_dly,
         RefSignalName        => "C1",
         RefDelay             => ticd_C1,
         SetupHigh            => tsetup_D0_C1_posedge_posedge,
         SetupLow             => tsetup_D0_C1_negedge_posedge,
         HoldHigh             => thold_D0_C1_posedge_posedge,
         HoldLow              => thold_D0_C1_negedge_posedge,
         CheckEnabled         => true,
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_ODDR2",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => Error);
--=====  Vital SetupHold Check for signal D1 =====
       VitalSetupHoldCheck (
         Violation            => Tviol_D1_C0_posedge,
         TimingData           => Tmkr_D1_C0_posedge,
         TestSignal           => D1_dly,
         TestSignalName       => "D1",
         TestDelay            => tisd_D1_C0,
         RefSignal            => C0_dly,
         RefSignalName        => "C0",
         RefDelay             => ticd_C0,
         SetupHigh            => tsetup_D1_C0_posedge_posedge,
         SetupLow             => tsetup_D1_C0_negedge_posedge,
         HoldHigh             => thold_D1_C0_posedge_posedge,
         HoldLow              => thold_D1_C0_negedge_posedge,
         CheckEnabled         => true,
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_ODDR2",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => Error);
--=====  Vital SetupHold Check for signal D1 =====
       VitalSetupHoldCheck (
         Violation            => Tviol_D1_C1_posedge,
         TimingData           => Tmkr_D1_C1_posedge,
         TestSignal           => D1_dly,
         TestSignalName       => "D1",
         TestDelay            => tisd_D1_C1,
         RefSignal            => C1_dly,
         RefSignalName        => "C1",
         RefDelay             => ticd_C1,
         SetupHigh            => tsetup_D1_C1_posedge_posedge,
         SetupLow             => tsetup_D1_C1_negedge_posedge,
         HoldHigh             => thold_D1_C1_posedge_posedge,
         HoldLow              => thold_D1_C1_negedge_posedge,
         CheckEnabled         => true,
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_ODDR2",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => Error);

      --=====  Vital Recovery/Removal Check for signal GSR =====
       VitalRecoveryRemovalCheck (
         Violation            => Tviol_GSR_C0_posedge,
         TimingData           => Tmkr_GSR_C0_posedge,
         TestSignal           => GSR_dly,
         TestSignalName       => "GSR",
         TestDelay            => tisd_GSR_C0,
         RefSignal            => C0_dly,
         RefSignalName        => "C0",
         RefDelay             => ticd_C0,
         Recovery             => trecovery_GSR_C0_negedge_posedge,
         Removal              => tremoval_GSR_C0_negedge_posedge,
         ActiveLow            => FALSE,
         CheckEnabled         => true,
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_ODDR2",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => Error);
--=====  Vital Recovery/Removal Check for signal GSR =====
       VitalRecoveryRemovalCheck (
         Violation            => Tviol_GSR_C1_posedge,
         TimingData           => Tmkr_GSR_C1_posedge,
         TestSignal           => GSR_dly,
         TestSignalName       => "GSR",
         TestDelay            => tisd_GSR_C1,
         RefSignal            => C1_dly,
         RefSignalName        => "C1",
         RefDelay             => ticd_C1,
         Recovery             => trecovery_GSR_C1_negedge_posedge,
         Removal              => tremoval_GSR_C1_negedge_posedge,
         ActiveLow            => FALSE,
         CheckEnabled         => true,
         RefTransition        => 'R',
         HeaderMsg            => InstancePath & "/X_ODDR2",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => Error);

       --=====  Vital Pulse Width Check for signal C0 =====
       VitalPeriodPulseCheck (
         Violation            => Pviol_C0,
         PeriodData           => PInfo_C0,
         TestSignal           => C0_dly,
         TestSignalName       => "C0",
         TestDelay            => 0 ps,
         Period               => tperiod_C0_posedge,
         PulseWidthHigh       => tpw_C0_posedge,
         PulseWidthLow        => tpw_C0_negedge,
         CheckEnabled         => true,
         HeaderMsg            => InstancePath & "/X_ODDR2",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => Error);
--=====  Vital Pulse Width Check for signal C1 =====
       VitalPeriodPulseCheck (
         Violation            => Pviol_C1,
         PeriodData           => PInfo_C1,
         TestSignal           => C1_dly,
         TestSignalName       => "C1",
         TestDelay            => 0 ps,
         Period               => tperiod_C1_posedge,
         PulseWidthHigh       => tpw_C1_posedge,
         PulseWidthLow        => tpw_C1_negedge,
         CheckEnabled         => true,
         HeaderMsg            => InstancePath & "/X_ODDR2",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => Error);

       VitalPeriodPulseCheck (
         Violation            => Pviol_R,
         PeriodData           => PInfo_R,
         TestSignal           => R_dly,
         TestSignalName       => "R",
         TestDelay            => 0 ps,
         Period               => 0 ps,
         PulseWidthHigh       => tpw_R_posedge,
         PulseWidthLow        => 0 ps,
         CheckEnabled         => true,
         HeaderMsg            => "/X_IDDR2",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => Error);
       VitalPeriodPulseCheck (
         Violation            => Pviol_S,
         PeriodData           => PInfo_S,
         TestSignal           => S_dly,
         TestSignalName       => "S",
         TestDelay            => 0 ps,
         Period               => 0 ps,
         PulseWidthHigh       => tpw_S_posedge,
         PulseWidthLow        => 0 ps,
         CheckEnabled         => true,
         HeaderMsg            => "/X_IDDR2",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => Error);
       
       if (SRTYPE = "ASYNC" ) then
--=====  Vital Recovery/Removal Check for signal R =====
         VitalRecoveryRemovalCheck (
           Violation            => Tviol_R_C0_posedge,
           TimingData           => Tmkr_R_C0_posedge,
           TestSignal           => R_dly,
           TestSignalName       => "R",
           TestDelay            => tisd_R_C0,
           RefSignal            => C0_dly,
           RefSignalName        => "C0",
           RefDelay             => ticd_C0,
           Recovery             => trecovery_R_C0_negedge_posedge,
           Removal              => tremoval_R_C0_negedge_posedge,
           ActiveLow            => FALSE,
           CheckEnabled         => true,
           RefTransition        => 'R',
           HeaderMsg            => InstancePath & "/X_ODDR2",
           Xon                  => Xon,
           MsgOn                => true,
           MsgSeverity          => Error);
--=====  Vital Recovery/Removal Check for signal R =====
         VitalRecoveryRemovalCheck (
           Violation            => Tviol_R_C1_posedge,
           TimingData           => Tmkr_R_C1_posedge,
           TestSignal           => R_dly,
           TestSignalName       => "R",
           TestDelay            => tisd_R_C1,
           RefSignal            => C1_dly,
           RefSignalName        => "C1",
           RefDelay             => ticd_C1,
           Recovery             => trecovery_R_C1_negedge_posedge,
           Removal              => tremoval_R_C1_negedge_posedge,
           ActiveLow            => FALSE,
           CheckEnabled         => true,
           RefTransition        => 'R',
           HeaderMsg            => InstancePath & "/X_ODDR2",
           Xon                  => Xon,
           MsgOn                => true,
           MsgSeverity          => Error);
--=====  Vital Recovery/Removal Check for signal S =====
         VitalRecoveryRemovalCheck (
           Violation            => Tviol_S_C0_posedge,
           TimingData           => Tmkr_S_C0_posedge,
           TestSignal           => S_dly,
           TestSignalName       => "S",
           TestDelay            => tisd_S_C0,
           RefSignal            => C0_dly,
           RefSignalName        => "C0",
           RefDelay             => ticd_C0,
           Recovery             => trecovery_S_C0_negedge_posedge,
           Removal              => tremoval_S_C0_negedge_posedge,
           ActiveLow            => FALSE,
           CheckEnabled         => true,
           RefTransition        => 'R',
           HeaderMsg            => InstancePath & "/X_ODDR2",
           Xon                  => Xon,
           MsgOn                => true,
           MsgSeverity          => Error);
--=====  Vital Recovery/Removal Check for signal S =====
         VitalRecoveryRemovalCheck (
           Violation            => Tviol_S_C1_posedge,
           TimingData           => Tmkr_S_C1_posedge,
           TestSignal           => S_dly,
           TestSignalName       => "S",
           TestDelay            => tisd_S_C1,
           RefSignal            => C1_dly,
           RefSignalName        => "C1",
           RefDelay             => ticd_C1,
           Recovery             => trecovery_S_C1_negedge_posedge,
           Removal              => tremoval_S_C1_negedge_posedge,
           ActiveLow            => FALSE,
           CheckEnabled         => true,
           RefTransition        => 'R',
           HeaderMsg            => InstancePath & "/X_ODDR2",
           Xon                  => Xon,
           MsgOn                => true,
           MsgSeverity          => Error);

       elsif (SRTYPE = "SYNC" ) then
--=====  Vital SetupHold Check for signal R =====
         VitalSetupHoldCheck (
           Violation            => Tviol_R_C0_posedge,
           TimingData           => Tmkr_R_C0_posedge,
           TestSignal           => R_dly,
           TestSignalName       => "R",
           TestDelay            => tisd_R_C0,
           RefSignal            => C0_dly,
           RefSignalName        => "C0",
           RefDelay             => ticd_C0,
           SetupHigh            => tsetup_R_C0_posedge_posedge,
           SetupLow             => tsetup_R_C0_negedge_posedge,
           HoldHigh             => thold_R_C0_posedge_posedge,
           HoldLow              => thold_R_C0_negedge_posedge,
           CheckEnabled         => true,
           RefTransition        => 'R',
           HeaderMsg            => InstancePath & "/X_ODDR2",
           Xon                  => Xon,
           MsgOn                => true,
           MsgSeverity          => Error);
--=====  Vital SetupHold Check for signal R =====
         VitalSetupHoldCheck (
            Violation            => Tviol_R_C1_posedge,
            TimingData           => Tmkr_R_C1_posedge,
            TestSignal           => R_dly,
            TestSignalName       => "R",
            TestDelay            => tisd_R_C1,
            RefSignal            => C1_dly,
            RefSignalName        => "C1",
            RefDelay             => ticd_C1,
            SetupHigh            => tsetup_R_C1_posedge_posedge,
            SetupLow             => tsetup_R_C1_negedge_posedge,
            HoldHigh             => thold_R_C1_posedge_posedge,
            HoldLow              => thold_R_C1_negedge_posedge,
            CheckEnabled         => true,
            RefTransition        => 'R',
            HeaderMsg            => InstancePath & "/X_ODDR2",
            Xon                  => Xon,
            MsgOn                => true,
            MsgSeverity          => Error);
--=====  Vital SetupHold Check for signal S =====
         VitalSetupHoldCheck (
           Violation            => Tviol_S_C0_posedge,
           TimingData           => Tmkr_S_C0_posedge,
           TestSignal           => S_dly,
           TestSignalName       => "S",
           TestDelay            => tisd_S_C0,
           RefSignal            => C0_dly,
           RefSignalName        => "C0",
           RefDelay             => ticd_C0,
           SetupHigh            => tsetup_S_C0_posedge_posedge,
           SetupLow             => tsetup_S_C0_negedge_posedge,
           HoldHigh             => thold_S_C0_posedge_posedge,
           HoldLow              => thold_S_C0_negedge_posedge,
           CheckEnabled         => true,
           RefTransition        => 'R',
           HeaderMsg            => InstancePath & "/X_ODDR2",
           Xon                  => Xon,
           MsgOn                => true,
           MsgSeverity          => Error);
--=====  Vital SetupHold Check for signal S =====
         VitalSetupHoldCheck (
           Violation            => Tviol_S_C1_posedge,
           TimingData           => Tmkr_S_C1_posedge,
           TestSignal           => S_dly,
           TestSignalName       => "S",
           TestDelay            => tisd_S_C1,
           RefSignal            => C1_dly,
           RefSignalName        => "C1",
           RefDelay             => ticd_C1,
           SetupHigh            => tsetup_S_C1_posedge_posedge,
           SetupLow             => tsetup_S_C1_negedge_posedge,
           HoldHigh             => thold_S_C1_posedge_posedge,
           HoldLow              => thold_S_C1_negedge_posedge,
           CheckEnabled         => true,
           RefTransition        => 'R',
           HeaderMsg            => InstancePath & "/X_ODDR2",
           Xon                  => Xon,
           MsgOn                => true,
           MsgSeverity          => Error);

        end if;
       
    end if;

    Violation := Tviol_CE_C0_posedge or Tviol_CE_C1_posedge or
                 Tviol_D0_C0_posedge or Tviol_D0_C1_posedge or
                 Tviol_D0_C1_posedge or Tviol_D1_C1_posedge or
                 Pviol_C0 or Pviol_C1;

    Q_viol     <= Violation xor Q_zd;

    wait on C0_dly, C1_dly, CE_dly, D0_dly, D1_dly, GSR_dly, R_dly, S_dly, Q_zd;
 
  end process prcs_tmngchk;
--####################################################################
--#####                           OUTPUT                         #####
--####################################################################
  prcs_output:process
  variable  Q_GlitchData : VitalGlitchDataType;

  begin
     VitalPathDelay01
       (
         OutSignal     => Q,
         GlitchData    => Q_GlitchData,
         OutSignalName => "Q",
         OutTemp       => Q_viol,
         Paths         => (0 => (C0_dly'last_event, tpd_C0_Q, (C0_dly = '1')),
                           1 => (C1_dly'last_event, tpd_C1_Q, (C1_dly = '1')),
                           2 => (GSR_dly'last_event, tpd_GSR_Q, true),
                           3 => (S_dly'last_event, tpd_S_Q, (R_dly /= '1')),
                           4 => (R_dly'last_event, tpd_R_Q, true)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => Error
       );

    wait on Q_viol;
  end process prcs_output;


end X_ODDR2_V;

